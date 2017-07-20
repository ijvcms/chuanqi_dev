%%%-------------------------------------------------------------------
%%% @author tuhujia
%%% @copyright (C) 2015, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 17. 八月 2015 14:20
%%%-------------------------------------------------------------------
-module(equips_baptize).

-include("common.hrl").
-include("record.hrl").
-include("proto.hrl").
-include("cache.hrl").
-include("db_record.hrl").
-include("config.hrl").
-include("language_config.hrl").
-include("log_type_config.hrl").

%% API
-export([
	baptize_equips/2,
	baptize_equips_save/2,
	baptize_lock/4,
	baptize_change/3,
	get_baptize_attr/3,
	get_spec_conditon/2,
	get_equips_baptize_num/1,
	get_equips_baptize_attr/1,
	get_bap_attr_record/1,
	get_equips_init_baptize_attr/1
]).

%% ====================================================================
%% API functions
%% ====================================================================

%% 装备洗炼
baptize_equips(State, Id) ->
	case check_baptize_condition(State, Id) of
		{ok, {EquipsInfo, BaptizConf, LockLen}} ->
			%% 计算属性
			Extra = EquipsInfo#db_goods.extra,
			Num = get_equips_baptize_num(Extra),
			AttrList = get_equips_baptize_attr(Extra),
			NewAttrList = get_baptize_attr(BaptizConf, Num, AttrList),
			ProtoAttrList = goods_util:attr_type_list_changed_proto_list(NewAttrList),
			NewBaptize = {?EQUIPS_BAPTIZE_KEY, Num + 1, AttrList},
			%% 扣除道具
			UseGoodsNum = BaptizConf#equips_baptize_conf.use_goods_num + get_extra_num(LockLen),
			UseGoodsId = BaptizConf#equips_baptize_conf.use_goods,
			goods_lib_log:delete_goods_by_num(State, UseGoodsId, UseGoodsNum, ?LOG_TYPE_BAPTIZE_EQUIPS),
			%% 更新装备信息
			Extra1 = lists:keystore(?EQUIPS_BAPTIZE_KEY, 1, EquipsInfo#db_goods.extra, NewBaptize),
			goods_lib:update_player_goods_info(State, EquipsInfo#db_goods{extra = update_goods_extra(Extra1)}),
			%% 扣除玩家金币
			UseCoin = BaptizConf#equips_baptize_conf.use_coin,
			{ok, State1} = player_lib:incval_on_player_money_log(State, #db_player_money.coin, -UseCoin, ?LOG_TYPE_BAPTIZE_EQUIPS),
			%% 保存洗练属性到字典
			goods_dict:set_equips_baptize_attr({Id, NewAttrList}),
			{ok, State1, ProtoAttrList};
		{fail, Reply} ->
			{fail, Reply}
	end.

%% 装备洗练保存
baptize_equips_save(State, Id) ->
	case check_baptize_save(Id) of
		{ok, EquipsInfo, AttrList} ->
			Extra = EquipsInfo#db_goods.extra,
			Num = get_equips_baptize_num(Extra),
			NewBaptize = {?EQUIPS_BAPTIZE_KEY, Num, AttrList},

			%% 更新装备信息
			Extra1 = lists:keystore(?EQUIPS_BAPTIZE_KEY, 1, EquipsInfo#db_goods.extra, NewBaptize),
			NewEquipsInfo = EquipsInfo#db_goods{extra = update_goods_extra(Extra1)},
			goods_lib:update_player_goods_info(State, NewEquipsInfo),

			%% 保存洗练属性到字典
			goods_dict:set_equips_baptize_attr([]),

			Result = player_lib:update_refresh_player(State, #player_state{}),
			case Result of
				{ok, StateNew} ->
					log_lib:log_goods_attr_change(StateNew, State, EquipsInfo, NewEquipsInfo, ?LOG_TYPE_BAPTIZE_EQUIPS);
				_ ->
					skip
			end,
			Result;
		{fail, Reply} ->
			{fail, Reply}
	end.

%% 洗练转移
baptize_change(PlayerState, IdA, IdB) ->
	case goods_lib:get_player_equips_info_by_id(IdA) of
		[] ->
			{fail, ?ERR_GOODS_NOT_EXIST};
		EquipsInfoA ->
			case goods_lib:get_server_use(EquipsInfoA#db_goods.server_id) of
				1 ->
					baptize_change_1(PlayerState, EquipsInfoA, IdB);
				_ ->
					{fail, ?ERR_SERVER_NO_USE}
			end
	end.

baptize_change_1(PlayerState, EquipsInfoA, IdB) ->
	case goods_lib:get_player_equips_info_by_id(IdB) of
		[] ->
			{fail, ?ERR_GOODS_NOT_EXIST};
		EquipsInfoB ->
			case EquipsInfoA#db_goods.expire_time =/= 0 orelse EquipsInfoB#db_goods.expire_time =/= 0 of
				true ->
					{fail, ?ERR_COMMON_FAIL};
				false ->
					baptize_change_2(PlayerState, EquipsInfoA, EquipsInfoB)
			end
	end.

baptize_change_2(PlayerState, EquipsInfoA, EquipsInfoB) ->
	GoodsIdA = EquipsInfoA#db_goods.goods_id,
	GoodsIdB = EquipsInfoB#db_goods.goods_id,
	GoodsConfA = goods_lib:get_goods_conf_by_id(GoodsIdA),
	GoodsConfB = goods_lib:get_goods_conf_by_id(GoodsIdB),

	BapConfA = equips_baptize_config:get({GoodsConfA#goods_conf.quality, GoodsConfA#goods_conf.sub_type, GoodsConfA#goods_conf.limit_career, GoodsConfA#goods_conf.limit_lvl}),
	BapConfB = equips_baptize_config:get({GoodsConfB#goods_conf.quality, GoodsConfB#goods_conf.sub_type, GoodsConfB#goods_conf.limit_career, GoodsConfB#goods_conf.limit_lvl}),

	case GoodsConfA#goods_conf.sub_type == GoodsConfB#goods_conf.sub_type andalso
		BapConfA#equips_baptize_conf.branch_num =< BapConfB#equips_baptize_conf.branch_num andalso
		get_equips_baptize_info(EquipsInfoA#db_goods.extra) =/= [] of
		true ->
			NeedJade = get_change_jade(EquipsInfoA#db_goods.extra),
			DBM = PlayerState#player_state.db_player_money,
			Jade = DBM#db_player_money.jade,
			case Jade >= NeedJade of
				true ->
					ExtraA = EquipsInfoA#db_goods.extra,
					ExtraB = EquipsInfoB#db_goods.extra,

					Num = get_equips_baptize_num(ExtraB),
					AttrList = get_equips_baptize_attr(ExtraA),

					NewBaptizB = {?EQUIPS_BAPTIZE_KEY, Num, AttrList},
					NewExtraA = lists:keydelete(?EQUIPS_BAPTIZE_KEY, 1, ExtraA),
					NewExtraB = update_goods_extra(lists:keystore(?EQUIPS_BAPTIZE_KEY, 1, ExtraB, NewBaptizB)),

					goods_lib:update_player_goods_info(PlayerState, EquipsInfoA#db_goods{extra = NewExtraA}),
					goods_lib:update_player_goods_info(PlayerState, EquipsInfoB#db_goods{extra = NewExtraB}),

					{ok, PlayerState2} = player_lib:incval_on_player_money_log(PlayerState, #db_player_money.jade, -NeedJade, ?LOG_TYPE_BAPTIZ_CHANGE),

					Result =
						case EquipsInfoB#db_goods.location =:= ?EQUIPS_LOCATION_TYPE orelse EquipsInfoA#db_goods.location =:= ?EQUIPS_LOCATION_TYPE of
							true ->
								{ok, PlayerState3} = player_lib:update_refresh_player(PlayerState2, #player_state{}),
								{ok, PlayerState3};
							false ->
								{ok, PlayerState2}
						end,
					{_, StateNew} = Result,
					log_lib:log_goods_attr_change(StateNew, PlayerState, EquipsInfoA, EquipsInfoA#db_goods{extra = NewExtraA}, ?LOG_TYPE_BAPTIZ_CHANGE),
					log_lib:log_goods_attr_change(StateNew, PlayerState, EquipsInfoB, EquipsInfoB#db_goods{extra = NewExtraB}, ?LOG_TYPE_BAPTIZ_CHANGE),
					Result;
				false ->
					{fail, ?ERR_PLAYER_JADE_NOT_ENOUGH}
			end;
		false ->
			{fail, ?ERR_COMMON_FAIL}
	end.

%% 洗练条件检测
check_baptize_condition(State, Id) ->
	case util:loop_functions(
		none,
		[fun(_) ->
			case goods_lib:get_player_equips_info_by_id(Id) of
				[] ->
					{break, ?ERR_GOODS_NOT_EXIST};
				EquipsInfo ->
					{continue, EquipsInfo}
			end
		end,
			fun(EquipsInfo) ->
				GoodsConf = goods_lib:get_goods_conf_by_id(EquipsInfo#db_goods.goods_id),
				case GoodsConf#goods_conf.is_timeliness == 0 of
					true ->
						{continue, EquipsInfo};
					false ->
						{break, ?ERR_COMMON_FAIL}
				end
			end,
			fun(EquipsInfo) ->
				Extra = EquipsInfo#db_goods.extra,
				AttrList = get_equips_baptize_attr(Extra),
				LockIdList = [A || {A, B, _C, _D} <- AttrList, B =/= 0],
				LockLen = length(LockIdList),
				{continue, {EquipsInfo, LockLen, AttrList}}
			end,
			fun({EquipsInfo, LockLen, AttrList}) ->
				GoodsId = EquipsInfo#db_goods.goods_id,
				GoodsConf = goods_lib:get_goods_conf_by_id(GoodsId),
				Quality = GoodsConf#goods_conf.quality,
				Lv = GoodsConf#goods_conf.limit_lvl,
				SubType = GoodsConf#goods_conf.sub_type,
				Career = GoodsConf#goods_conf.limit_career,
				case equips_baptize_config:get({Quality, SubType, Career, Lv}) of
					#equips_baptize_conf{} = BaptizConf ->
						case LockLen >= BaptizConf#equips_baptize_conf.branch_num andalso AttrList =/= [] of
							true ->
								{break, ?ERR_COMMON_FAIL};
							false ->
								{continue, {EquipsInfo, BaptizConf, LockLen}}
						end;
					_ ->
						{break, ?ERR_COMMON_FAIL}
				end
			end,
			fun({EquipsInfo, BaptizConf, LockLen}) ->
				PlayerMoney = State#player_state.db_player_money,
				Coin = PlayerMoney#db_player_money.coin,
				NeedCoin = BaptizConf#equips_baptize_conf.use_coin,
				case Coin >= NeedCoin of
					false ->
						{break, ?ERR_PLAYER_COIN_NOT_ENOUGH};
					true ->
						{continue, {EquipsInfo, BaptizConf, LockLen}}
				end
			end,
			fun({EquipsInfo, BaptizConf, LockLen}) ->
				UseGoodsNum = BaptizConf#equips_baptize_conf.use_goods_num,
				UseGoodsId = BaptizConf#equips_baptize_conf.use_goods,
				GoodsNum = goods_lib:get_goods_num(UseGoodsId),
				case GoodsNum >= UseGoodsNum + get_extra_num(LockLen) of
					false ->
						{break, ?ERR_GOODS_NOT_ENOUGH};
					true ->
						{continue, {EquipsInfo, BaptizConf, LockLen}}
				end
			end
		]) of
		{break, Reply} -> {fail, Reply};
		{ok, Value} ->
			{ok, Value}
	end.

%% 洗属性保存检测
check_baptize_save(Id) ->
	case util:loop_functions(
		none,
		[fun(_) ->
			case goods_dict:get_equips_baptize_attr() of
				[] ->
					{break, ?ERR_COMMON_FAIL};
				{Id1, AttrList} ->
					{continue, {Id1, AttrList}}
			end
		end,
			fun({Id1, AttrList}) ->
				case Id1 =:= Id of
					true ->
						{continue, AttrList};
					false ->
						{break, ?ERR_COMMON_FAIL}
				end
			end,
			fun(AttrList) ->
				case goods_lib:get_player_equips_info_by_id(Id) of
					[] ->
						{break, ?ERR_COMMON_FAIL};
					EquipsInfo ->
						{continue, {EquipsInfo, AttrList}}
				end
			end
		]) of
		{break, Reply} -> {fail, Reply};
		{ok, {EquipsInfo, AttrList}} ->
			{ok, EquipsInfo, AttrList}
	end.

%% 锁定与解锁装备洗练属性
baptize_lock(PlayerState, GoodsKey, Id, State) ->
	case goods_lib:get_player_equips_info_by_id(GoodsKey) of
		[] ->
			{fail, ?ERR_GOODS_NOT_EXIST};
		EquipsInfo ->
			baptize_lock_1(PlayerState, EquipsInfo, Id, State)
	end.

baptize_lock_1(PlayerState, EquipsInfo, Id, State) ->
	Extra = EquipsInfo#db_goods.extra,
	case get_equips_baptize_info(Extra) of
		{_, Num, AttrList} ->
			case lists:keyfind(Id, 1, AttrList) of
				{_, _, Type, Value} ->
					NewAttrList = lists:keystore(Id, 1, AttrList, {Id, State, Type, Value}),
					NewBaptize = {?EQUIPS_BAPTIZE_KEY, Num, NewAttrList},
					%% 更新装备信息
					Extra1 = lists:keystore(?EQUIPS_BAPTIZE_KEY, 1, Extra, NewBaptize),
					goods_lib:update_player_goods_info(PlayerState, EquipsInfo#db_goods{extra = update_goods_extra(Extra1)}),

					{ok, ?ERR_COMMON_SUCCESS};
				_ ->
					{fail, ?ERR_COMMON_FAIL}
			end;
		_ ->
			{fail, ?ERR_COMMON_FAIL}
	end.

%% 获取该装备的洗炼次数
get_equips_baptize_num(Extra) ->
	case lists:keyfind(?EQUIPS_BAPTIZE_KEY, 1, Extra) of
		{_, Num, _AttrList} ->
			Num;
		_ ->
			0
	end.

%% 获取该装备的洗炼属性
get_equips_baptize_attr(Extra) ->
	case lists:keyfind(?EQUIPS_BAPTIZE_KEY, 1, Extra) of
		{_, _Num, AttrList} ->
			Len = length(AttrList),
			%% 老数据格式转换
			Fun = fun(AttrInfo, Id) ->
				case AttrInfo of
					{Type, Value} ->
						{Id, 0, Type, Value};
					_ ->
						AttrInfo
				end
			end,
			lists:zipwith(Fun, AttrList, lists:seq(1, Len));
		_ ->
			[]
	end.

%% 获取该装备的洗炼信息
get_equips_baptize_info(Extra) ->
	case lists:keyfind(?EQUIPS_BAPTIZE_KEY, 1, Extra) of
		{_Key, _Num, AttrList} ->
			Len = length(AttrList),
			%% 老数据格式转换
			Fun = fun(AttrInfo, Id) ->
				case AttrInfo of
					{Type, Value} ->
						{Id, 0, Type, Value};
					_ ->
						AttrInfo
				end
			end,
			NewAttrList = lists:zipwith(Fun, AttrList, lists:seq(1, Len)),
			{_Key, _Num, NewAttrList};
		_ ->
			[]
	end.

%% 洗炼属性
get_baptize_attr(BaptizConf, BaptizeNum, OldAttrList) ->
	%% 找出锁定的id
	LockIdList = [A || {A, B, _C, _D} <- OldAttrList, B =/= 0],
	LockAttrList = [{A, B, C, D} || {A, B, C, D} <- OldAttrList, B =/= 0],
	LockLen = length(LockIdList),
	Num = BaptizConf#equips_baptize_conf.branch_num,
	AttrRateList = BaptizConf#equips_baptize_conf.attr_rate,
	AttrValueList = BaptizConf#equips_baptize_conf.attr_max_value,
	SpecCond = get_spec_conditon(BaptizeNum, BaptizConf#equips_baptize_conf.bap_rate),

	AttrRandList = get_attr_random_list(Num - LockLen, AttrRateList),

	AttrList = get_attr_list(AttrRandList, AttrValueList, SpecCond),

	%% 拼接属性列表
	UnlockList = lists:seq(1, Num) -- LockIdList,
	Fun = fun({Type, Value}, Id) ->
		{Id, 0, Type, Value}
	end,
	UnlockAttrList = lists:zipwith(Fun, AttrList, UnlockList),
	lists:keysort(1, LockAttrList ++ UnlockAttrList).

get_attr_random_list(BaptizeNum, AttrRateList) ->
	RateList = [X || {_Type, X} <- AttrRateList],
	RateSum = lists:sum(RateList),

	Fun = fun(_, Acc) ->
		Random = util_rand:rand(1, RateSum),
		Attr = get_attr_random_list(Random, 0, AttrRateList),
		Acc ++ [Attr]
	end,
	lists:foldl(Fun, [], lists:seq(1, BaptizeNum)).

get_attr_random_list(Random, Rate, [H | T]) ->
	{Attr, Value} = H,
	case Rate + Value >= Random of
		true ->
			Attr;
		false ->
			get_attr_random_list(Random, Rate + Value, T)
	end.

get_spec_conditon(BaptizeNum, List) ->
	[{Y, Z} || {X, Y, Z} <- List, BaptizeNum >= X].

get_attr_list(AttrRandList, AttrValueList, SpecCond) ->
	Fun = fun(AttrType) ->
		{_AttrType, AttrMaxValue} = lists:keyfind(AttrType, 1, AttrValueList),
		AttrValue = get_attr_value(AttrMaxValue, SpecCond),
		{AttrType, AttrValue}
	end,
	[Fun(X) || X <- AttrRandList].

get_attr_value(AttrMaxValue, SpecCond) ->
	RateList = [X || {X, _} <- SpecCond],
	RateSum = lists:sum(RateList),
	Random = util_rand:rand(1, RateSum),
	[Min, Max] = get_attr_value(Random, 0, SpecCond),
	RandValue = util_rand:rand(Min, Max),
	util_math:ceil(RandValue / 100 * AttrMaxValue).

get_attr_value(Random, Rate, [H | T]) ->
	{Value, L} = H,
	case Rate + Value >= Random of
		true ->
			L;
		false ->
			get_attr_value(Random, Rate + Value, T)
	end.

%% 洗练属性转化为属性纪录
get_bap_attr_record(Extra) ->
	case get_equips_baptize_attr(Extra) of
		[] ->
			[];
		AttrList ->
			Fun = fun(AttrInfo, Acc) ->
				{Key, Value} =
					case AttrInfo of
						{_Id, _Lock, K, V} -> %% 新版本属性
							{K, V};
						Attr -> %% 老版本属性
							Attr
					end,
				[_, AttrKey] = player_lib:get_key_map(Key),
				Value1 = max(0, Value + element(AttrKey, Acc)),
				setelement(AttrKey, Acc, Value1)
			end,
			lists:foldl(Fun, #attr_base{}, AttrList)
	end.

%% 获取装备洗练属性
get_equips_init_baptize_attr(GoodsConf) ->
	Quality = GoodsConf#goods_conf.quality,
	Lv = GoodsConf#goods_conf.limit_lvl,
	SubType = GoodsConf#goods_conf.sub_type,
	Career = GoodsConf#goods_conf.limit_career,
	case GoodsConf#goods_conf.id of
		?SPEC_TIMELESS_GOODS ->
			AttrList = [{1, 1, 23, 37}, {2, 1, 23, 37}, {3, 1, 23, 37}, {4, 1, 23, 37}],
			[{?EQUIPS_BAPTIZE_KEY, 0, AttrList}];
		_ ->
			case equips_baptize_config:get({Quality, SubType, Career, Lv}) of
				#equips_baptize_conf{} = BaptizConf ->
					AttrList = get_baptize_attr(BaptizConf, 0, []),
					[{?EQUIPS_BAPTIZE_KEY, 0, AttrList}];
				_ ->
					[]
			end
	end.

%% 获取额外洗练消耗数量
get_extra_num(LockLen) ->
	case equips_baptize_lock_config:get(LockLen) of
		#equips_baptize_lock_conf{} = Conf ->
			Conf#equips_baptize_lock_conf.cost;
		_ ->
			0
	end.

%% 洗练属性刷新
update_goods_extra(Extra) ->
	BapList = case lists:keyfind(?EQUIPS_BAPTIZE_KEY, 1, Extra) of false -> []; Info -> [Info] end,
	LuckList = case lists:keyfind(?EQUIPS_LUCK_KEY, 1, Extra) of false -> []; Info1 -> [Info1] end,
	BapList ++ LuckList.

%% 计算洗练转移所需要的价格
get_change_jade(Extra) ->
	List = get_equips_baptize_attr(Extra),
	Fun = fun({_, _, Type, Value}, Jade) ->
		MaxConf = equips_baptize_qian_config:get(Type),
		MaxValue = MaxConf#equips_baptize_qian_conf.max,
		Percent = min(?PERCENT_BASE, util_math:floor((Value / MaxValue) * ?PERCENT_BASE)),
		Conf = equips_baptiz_change_jade_config:get(Percent),
		Jade + Conf#equips_baptiz_change_jade_conf.jade
	end,
	lists:foldl(Fun, 0, List).


