%%%-------------------------------------------------------------------
%%% @author tuhujia
%%% @copyright (C) 2015, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 24. 七月 2015 14:09
%%%-------------------------------------------------------------------
-module(equips_lib).

-include("common.hrl").
-include("record.hrl").
-include("proto.hrl").
-include("cache.hrl").
-include("db_record.hrl").
-include("config.hrl").
-include("language_config.hrl").
-include("notice_config.hrl").
-include("log_type_config.hrl").

%% API
-export([
	get_equips_attr_list/0,
	change_equips/4,
	unload_equips/2,
	upgrade_equips/3,
	upgrade_change/3,
	equips_soul_back/2,
	soul_equips/2,
	equips_secure/3,
	get_equips_info_from_grid/1,
	get_equips_range_max_lv/1,
	restore_guise_state/2,
	update_equips_skill/3,
	medal_upgrade/2,
	wing_upgrade/3,
	mounts_upgrade/2,
	decompose_equips_by_quality/2,
	decompose_equips_by_id/2,
	add_stealth_ring_skill/2,
	clean_stealth_ring_skill/2,
	up_mounts/1,
	down_mounts/1,
	get_change_consume/2,
	check_guise_state/2
]).

%% 强化装备放入道具数量限制
-define(LIMIT_UPGRADE_GOODS_NUM, 5).

%% ====================================================================
%% API functions
%% ====================================================================

%% 获取背包初始属性
get_equips_attr_list() ->
	NowTime = util_date:unixtime(),
	Fun = fun(GoodsInfo, {EBaseAttr1, ETotalAttr1, SuitList1}) ->
		%% 时效过期道具不计算属性
		case GoodsInfo#db_goods.location =:= 1 andalso
			(GoodsInfo#db_goods.expire_time == 0 orelse
				GoodsInfo#db_goods.expire_time > NowTime) of
			true ->
				GoodsId = GoodsInfo#db_goods.goods_id,
				StrenLv = GoodsInfo#db_goods.stren_lv,
				EquipsConf = equips_config:get(GoodsId),
				GoodsConf = goods_lib:get_goods_conf_by_id(GoodsId),
				SubType = GoodsConf#goods_conf.sub_type,
				StrenConf = equips_plus_config:get({StrenLv, SubType}),
				AttrRecord = EquipsConf#equips_conf.attr_base,
				%% 强化加成
				AttrRecord1 = StrenConf#equips_plus_conf.attr_base,
				%% 洗炼加成
				Extra = GoodsInfo#db_goods.extra,
				BapAttrRecord = equips_baptize:get_bap_attr_record(Extra),
				%% 神器加成
%% 					GoodsConf = goods_lib:get_goods_conf_by_id(GoodsId),
%% 					SubType = GoodsConf#goods_conf.sub_type,
%% 					ArtAttrRecord = equips_artifact:get_arit_attr_record(SubType, Extra),
				%% 武器幸运加成
				LuckRecord = get_luck_record(GoodsInfo),
				%% 铸魂加成
				Soul = GoodsInfo#db_goods.soul,
				SoulPlusConf = equips_soul_plus_config:get(Soul),
				SoulRecord = api_attr:addition_attr_by_modulus(AttrRecord, SoulPlusConf#equips_soul_plus_conf.modulus),

				ETotalAttr2 = api_attr:attach_attr([AttrRecord, AttrRecord1, BapAttrRecord, LuckRecord, ETotalAttr1, SoulRecord]),
				EBaseAttr2 = api_attr:attach_attr([AttrRecord, EBaseAttr1]),

				SuitList2 = [GoodsConf#goods_conf.suit_id] ++ SuitList1,

				{EBaseAttr2, ETotalAttr2, SuitList2};
			false ->
				{EBaseAttr1, ETotalAttr1, SuitList1}
		end
	end,
	{EBaseAttr, ETotalAttr, SuitList} = lists:foldl(Fun, {#attr_base{}, #attr_base{}, []}, goods_dict:get_player_equips_list()),

	%% 计算套装属性
	SuitAttr = api_attr:compute_suit_attr(SuitList),
	ETotalAttr1 = api_attr:attach_attr([SuitAttr, ETotalAttr]),
	{EBaseAttr, ETotalAttr1}.

%% 装备更换
change_equips(State, Id, GoodsId, Grid) ->
	case Grid =/= ?SUBTYPE_MOUNTS andalso Grid =/= ?SUBTYPE_WING andalso Grid =/= ?SUBTYPE_MEDAL of
		true ->
			case check_change_equips(State, Id, GoodsId, Grid) of
				{ok, EquipsInfo} ->
					change_equips_1(State, EquipsInfo, Grid);
				{fail, Reply} ->
					{fail, Reply}
			end;
		false ->
			{fail, ?ERR_COMMON_FAIL}
	end.

change_equips_1(State, EquipsInfo, Grid) ->
%% 	io:format("change equips 1 :~p~n", [State#player_state.player_id]),
	case get_equips_info_from_grid(Grid) of
		[] ->
			#db_goods{goods_id=GoodsId}=EquipsInfo,
			EquipsInfo1 = EquipsInfo#db_goods{location = 1, grid = Grid},
			goods_lib:update_player_goods_info(State, EquipsInfo1, false),

			%% 外观变更检测
			UpdateState = check_guise_state(State, EquipsInfo1),
			UpdateState1 = UpdateState#player_state{pass_trigger_skill_list = State#player_state.pass_trigger_skill_list},
			UpdateState2 = update_equips_skill(UpdateState1, [], EquipsInfo1),
			UpdateState3 = add_stealth_ring_skill(UpdateState2, GoodsId),
			%% 更新玩家属性
			Result = player_lib:update_refresh_player(State, UpdateState3),
			case Result of
				{ok, StateNew} ->
					log_lib:log_fight_goods_change(StateNew, State, EquipsInfo1, true, ?LOG_TYPE_EQUIPS_ON);
				_ -> skip
			end,
			Result;
		OldEquipsInfo ->
			#db_goods{goods_id=GoodsId}=EquipsInfo,
			EquipsInfo1 = EquipsInfo#db_goods{location = 1, grid = Grid},
			goods_lib:update_player_goods_info(State, EquipsInfo1),
			goods_lib:update_player_goods_info(State, OldEquipsInfo#db_goods{location = 0, grid = 0}),
			%% 外观变更检测
			UpdateState = check_guise_state(State, EquipsInfo1),
			UpdateState1 = UpdateState#player_state{pass_trigger_skill_list = State#player_state.pass_trigger_skill_list},
			UpdateState2 = update_equips_skill(UpdateState1, OldEquipsInfo, EquipsInfo1),
			UpdateState3 = add_stealth_ring_skill(UpdateState2, GoodsId),
			#db_goods{goods_id = OldGoodsId} = OldEquipsInfo,
			UpdateState4 = clean_stealth_ring_skill(UpdateState3, OldGoodsId),
			%% 更新玩家属性
			Result = player_lib:update_refresh_player(State, UpdateState4),
			case Result of
				{ok, StateNew} ->
					log_lib:log_fight_goods_change(StateNew, State, OldEquipsInfo, EquipsInfo1, ?LOG_TYPE_EQUIPS_REPLACE);
				_ -> skip
			end,
			Result
	end.

%% 装备穿戴检测
check_change_equips(State, Id, GoodsId, Grid) ->
	case util:loop_functions(
		none,
		[fun(_)
			->
			case goods_lib:get_player_goods_info(Id, GoodsId, true) of %%
				{fail, Err} ->
					{break, Err};
				EquipsInfo ->
					{continue, EquipsInfo}
			end
		end,
			fun(EquipsInfo) ->
				EquipsConf = goods_lib:get_goods_conf_by_id(GoodsId),
				PlayerBase = State#player_state.db_player_base,
				case PlayerBase#db_player_base.career =:= EquipsConf#goods_conf.limit_career orelse
					EquipsConf#goods_conf.limit_career =:= 0 of
					true ->
						{continue, {EquipsInfo, EquipsConf}};
					false ->
						{break, ?ERR_PLAYER_CAREER_LIMIT}
				end
			end,
			fun({EquipsInfo, EquipsConf}) ->
				SubType = EquipsConf#goods_conf.sub_type,
				case EquipsInfo#db_goods.grid =:= 0 andalso SubType =:= get_match_subtype_by_grid(Grid) of
					true ->
						{continue, {EquipsInfo, EquipsConf}};
					false ->
						{break, ?ERR_WEAR_GRID_ERROR}
				end
			end,
			fun({EquipsInfo, EquipsConf}) ->
				PlayerBase = State#player_state.db_player_base,
				case PlayerBase#db_player_base.lv >= EquipsConf#goods_conf.limit_lvl of
					true ->
						{continue, EquipsInfo};
					false ->
						{break, ?ERR_PLAYER_LV_NOT_ENOUGH}
				end
			end
		]) of
		{break, Reply} -> {fail, Reply};
		{ok, EquipsInfo} ->
			{ok, EquipsInfo}
	end.


%% 装备拆卸
unload_equips(State, Grid) ->
	case Grid =/= ?SUBTYPE_MOUNTS andalso Grid =/= ?SUBTYPE_WING andalso Grid =/= ?SUBTYPE_MEDAL of
		true ->
			PlayerBase = State#player_state.db_player_base,
			case goods_dict:get_bag_cell() >= PlayerBase#db_player_base.bag of
				true ->
					{fail, ?ERR_PLAYER_BAG_NOT_ENOUGH};
				false ->
					case get_equips_info_from_grid(Grid) of
						[] ->
							{fail, ?ERR_GOODS_NOT_EXIST};
						OldEquipsInfo ->
							#db_goods{goods_id = GoodsId} = OldEquipsInfo,
							goods_lib:update_player_goods_info(State, OldEquipsInfo#db_goods{location = 0, grid = 0}, true),
							%% 外观变更检测
							UpdateState = restore_guise_state(State, OldEquipsInfo),
							UpdateState1 = UpdateState#player_state{pass_trigger_skill_list = State#player_state.pass_trigger_skill_list},
							UpdateState2 = update_equips_skill(UpdateState1, OldEquipsInfo, []),
							clean_stealth_ring_skill(State, GoodsId),

							%% 更新玩家属性
							Result = player_lib:update_refresh_player(State, UpdateState2),
							case Result of
								{ok, StateNew} ->
									log_lib:log_fight_goods_change(StateNew, State, OldEquipsInfo, false, ?LOG_TYPE_EQUIPS_OFF);
								_ -> skip
							end,
							Result
					end
			end;
		false ->
			{fail, ?ERR_COMMON_FAIL}
	end.

%% 装备强化
upgrade_equips(State, Id, GoodsList) ->
	case goods_lib:get_player_equips_info_by_id(Id) of
		[] ->
			{fail, ?ERR_GOODS_NOT_EXIST};
		EquipsInfo ->
			upgrade_equips_1(State, EquipsInfo, GoodsList)
	end.

upgrade_equips_1(State, EquipsInfo, GoodsList) ->
	StrenLv = EquipsInfo#db_goods.stren_lv,
	case equips_stren_config:get(StrenLv + 1) of
		#equips_stren_conf{} = StrenConf ->
			upgrade_equips_2(State, EquipsInfo, StrenConf, GoodsList);
		_ ->
			{fail, ?ERR_COMMON_FAIL}
	end.

upgrade_equips_2(State, EquipsInfo, StrenConf, GoodsList) ->
	StrenLv = EquipsInfo#db_goods.stren_lv,
	case check_upgrade_goods(State, GoodsList, StrenLv + 1) of
		{ok, ExtraRate, Bless, GoodsList1} ->
			upgrade_equips_3(State, EquipsInfo, StrenConf, ExtraRate, Bless, GoodsList1);
		{fail, Reply} ->
			{fail, Reply}
	end.

upgrade_equips_3(State, EquipsInfo, StrenConf, ExtraRate, Bless, GoodsList) ->
	StrenLv = EquipsInfo#db_goods.stren_lv,
	NeedMoney = StrenConf#equips_stren_conf.coin,
	MoneyRecord = State#player_state.db_player_money,
	GoodsConf = goods_lib:get_goods_conf_by_id(EquipsInfo#db_goods.goods_id),

	if
		MoneyRecord#db_player_money.coin < NeedMoney ->
			{fail, ?ERR_PLAYER_COIN_NOT_ENOUGH};
		GoodsConf#goods_conf.is_timeliness =/= 0 ->
			{fail, ?ERR_COMMON_FAIL};
		true ->
			MaxBless = StrenConf#equips_stren_conf.max_bless,
			GoodsBless = EquipsInfo#db_goods.bless,
			Rate = ExtraRate,
			Reply =
				case util_rand:rand_hit(Rate) orelse (GoodsBless >= MaxBless andalso MaxBless =/= 0) of
					true ->  %% 成功
						NewStrenLv = StrenLv + 1,
						Equips1 = EquipsInfo#db_goods{stren_lv = NewStrenLv, bless = 0},
						%% 更新装备信息
						goods_lib:update_player_goods_info(State, Equips1),

						%% 发送装备强化公告
						case NewStrenLv > 6 of
							true ->
								DbPlayerBase = State#player_state.db_player_base,
								PlayerName = DbPlayerBase#db_player_base.name,
								GoodsConf1 = goods_config:get(EquipsInfo#db_goods.goods_id),
								GoodsStr = GoodsConf1#goods_conf.name,
								notice_lib:send_notice(0, ?NOTICE_EQUIPS_STREN, [PlayerName, GoodsStr, NewStrenLv]);
							false ->
								skip
						end,

						?ERR_COMMON_SUCCESS;
					false -> %% 失败
						DPB = State#player_state.db_player_base,
						VipLv = DPB#db_player_base.vip,
						case MaxBless =/= 0 andalso VipLv >= 8 of
							true ->
								%% 强化失败 增加祝福值
								Equips2 = EquipsInfo#db_goods{bless = GoodsBless + Bless},
								%% 更新装备信息
								goods_lib:update_player_goods_info(State, Equips2);
							false ->
								skip
						end,
						?ERR_EQUIPS_UPGRADE_FAIL
				end,

			%% 扣除道具
			goods_util:delete_special_list(State, GoodsList, ?LOG_TYPE_UPGRADE_EQUIPS),

			[log_lib:log_goods_change(State, GoodsId, -Num, ?LOG_TYPE_UPGRADE_EQUIPS) || {GoodsId, Num} <- GoodsList],
			%% 扣除金币 更新属性
			Result =
				case EquipsInfo#db_goods.location =:= ?EQUIPS_LOCATION_TYPE of
					true ->
						{ok, State1} = player_lib:incval_on_player_money_log(State, #db_player_money.coin, -NeedMoney, false, ?LOG_TYPE_UPGRADE_EQUIPS),
						{ok, State2} = player_lib:update_refresh_player(State, State1),
						{ok, State2, Reply, true};%% 第4个 判断是否更新活动红点
					false ->
						{ok, State1} = player_lib:incval_on_player_money_log(State, #db_player_money.coin, -NeedMoney, ?LOG_TYPE_UPGRADE_EQUIPS),
						{ok, State1, Reply, false}
				end,
			case Reply =:= ?ERR_COMMON_SUCCESS of
				true ->
					{_, StateNew, _, _} = Result,
					log_lib:log_goods_attr_change(StateNew, State, EquipsInfo, EquipsInfo#db_goods{stren_lv = StrenLv + 1}, ?LOG_TYPE_UPGRADE_EQUIPS);
				false ->
					skip
			end,
			Result
	end.

check_upgrade_goods(State, GoodsList, StrenLv) ->
	case length(GoodsList) =< ?LIMIT_UPGRADE_GOODS_NUM andalso length(GoodsList) > 0 of
		true ->
			GoodsList1 = util_list:list_statistics(GoodsList),
			case goods_util:check_special_list(State, GoodsList1) of
				true ->
					case get_extra_rate(GoodsList, StrenLv) of
						{ok, Rate, Bless} ->
							{ok, Rate, Bless, GoodsList1};
						{fail, Reply} ->
							{fail, Reply}
					end;
				{fail, Reply} ->
					{fail, Reply}
			end;
		false ->
%% 			io:format("streng : ~p~n", [2222]),
			{fail, ?ERR_COMMON_FAIL}
	end.

get_extra_rate([], _StrenLv) ->
	{ok, 0};
get_extra_rate(GoodsList, StrenLv) ->
	get_extra_rate(0, 0, GoodsList, StrenLv).

get_extra_rate(Rate, Bless, [], _StrenLv) ->
	{ok, Rate, Bless};
get_extra_rate(Rate, Bless, [GoodsId | T], StrenLv) ->
	case stren_rate_config:get({GoodsId, StrenLv}) of
		#stren_rate_conf{} = RateConf ->
			Rate1 = RateConf#stren_rate_conf.rate,
			Bless1 = get_bless(GoodsId),
			get_extra_rate(Rate + Rate1, Bless + Bless1, T, StrenLv);
		_ ->
			{fail, ?ERR_COMMON_FAIL}
	end.

get_bless(GoodsId) ->
	GoodsConf = goods_lib:get_goods_conf_by_id(GoodsId),
	Extra = GoodsConf#goods_conf.extra,
	case lists:keyfind(bless, 1, Extra) of
		{_, Value} ->
			Value;
		_ ->
			0
	end.

%% 强化转移
upgrade_change(PlayerState, IdA, IdB) ->
	case goods_lib:get_player_equips_info_by_id(IdA) of
		[] ->
			{fail, ?ERR_GOODS_NOT_EXIST};
		EquipsInfoA ->
			case goods_lib:get_server_use(EquipsInfoA#db_goods.server_id) of
				1 ->
					upgrade_change_1(PlayerState, EquipsInfoA, IdB);
				_ ->
					{fail, ?ERR_SERVER_NO_USE}
			end
	end.

upgrade_change_1(PlayerState, EquipsInfoA, IdB) ->
	case goods_lib:get_player_equips_info_by_id(IdB) of
		[] ->
			{fail, ?ERR_GOODS_NOT_EXIST};
		EquipsInfoB ->
			case EquipsInfoA#db_goods.expire_time =/= 0 orelse EquipsInfoB#db_goods.expire_time =/= 0 of
				true ->
					{fail, ?ERR_COMMON_FAIL};
				false ->
					upgrade_change_2(PlayerState, EquipsInfoA, EquipsInfoB)
			end
	end.

upgrade_change_2(PlayerState, EquipsInfoA, EquipsInfoB) ->
	LvA = EquipsInfoA#db_goods.stren_lv,
	LvB = EquipsInfoB#db_goods.stren_lv,
	NeedJade =
		case equips_stren_config:get(LvA) of
			#equips_stren_conf{} = StrenConf ->
				StrenConf#equips_stren_conf.change_jade;
			_ ->
				0
		end,
	DPM = PlayerState#player_state.db_player_money,
	case DPM#db_player_money.jade >= NeedJade of
		true ->
			case LvA > LvB of
				true ->
					%% 更新装备信息
					goods_lib:update_player_goods_info(PlayerState, EquipsInfoA#db_goods{stren_lv = 0}),
					goods_lib:update_player_goods_info(PlayerState, EquipsInfoB#db_goods{stren_lv = LvA}),

					{ok, PlayerState2} = player_lib:incval_on_player_money_log(PlayerState, #db_player_money.jade, -NeedJade, ?LOG_TYPE_UPGRADE_EQUIPS),

					Result =
						case EquipsInfoA#db_goods.location =:= ?EQUIPS_LOCATION_TYPE orelse
							EquipsInfoB#db_goods.location =:= ?EQUIPS_LOCATION_TYPE of
							true ->
								{ok, PlayerState3} = player_lib:update_refresh_player(PlayerState2, #player_state{}),
								{ok, PlayerState3};
							false ->
								{ok, PlayerState2}
						end,
					{_, StateNew} = Result,
					log_lib:log_goods_attr_change(StateNew, PlayerState, EquipsInfoA, EquipsInfoA#db_goods{stren_lv = 0, soul = 0}, ?LOG_TYPE_EQUIPS_CHANGE),
					log_lib:log_goods_attr_change(StateNew, PlayerState, EquipsInfoB, EquipsInfoB#db_goods{stren_lv = LvA}, ?LOG_TYPE_EQUIPS_CHANGE),
					Result;
				false ->
					{fail, ?ERR_COMMON_FAIL}
			end;
		false ->
			{fail, ?ERR_PLAYER_JADE_NOT_ENOUGH}
	end.
%% 获取铸魂返还信息
get_change_consume(EquipsInfo, IsConsume) ->
	GoodsId = EquipsInfo#db_goods.goods_id,
	Soul = EquipsInfo#db_goods.soul,
	case Soul > 0 of
		true ->
			Fun = fun(SoulLv, Acc) ->
				%% 获取升级消耗的铸魂精华
				case equips_soul_config:get({GoodsId, SoulLv}) of
					#equips_soul_conf{} = SoulConf ->
						SoulConf#equips_soul_conf.consume ++ Acc;
					_ ->
						Acc
				end
			end,
			List = lists:foldl(Fun, [], lists:seq(1, Soul)),
			List1 = goods_util:merge_goods_list(List),
			case IsConsume of
				true ->
					%% 铸魂精华减少到 30％
					F = fun({G, N}, Acc) ->
						case G =:= ?GOODS_ID_SOUL of
							true ->
								TempNum = round(N * 0.3),
								case TempNum < 1 of
									true ->
										Acc;
									_ ->
										[{G, TempNum} | Acc]
								end;
							_ ->
								[{G, N} | Acc]
						end
					end,
					lists:foldl(F, [], List1);
				_ ->
					List1
			end;
		false ->
			[]
	end.

%% 铸魂返还
equips_soul_back(PlayerState, IdA) ->
	case goods_lib:get_player_equips_info_by_id(IdA) of
		[] ->
			{fail, ?ERR_GOODS_NOT_EXIST};
		EquipsInfoA ->
			equips_soul_back_1(PlayerState, EquipsInfoA)
	end.

equips_soul_back_1(PlayerState, EquipsInfoA) ->
	Consume = get_change_consume(EquipsInfoA, true),
	GoodsList = [{G, ?NOT_BIND, N} || {G, N} <- Consume],
	case goods_lib_log:add_goods_list(PlayerState, GoodsList, ?LOG_TYPE_SOUL_CHANGE) of
		{ok, PlayerState1} ->
			%% 更新装备信息
			goods_lib:update_player_goods_info(PlayerState, EquipsInfoA#db_goods{soul = 0}),
			{ok, PlayerState1};
		{fail, Reply} ->
			{fail, Reply}
	end.

%% 铸魂装备
soul_equips(PlayerState, Id) ->
	case goods_lib:get_player_equips_info_by_id(Id) of
		[] ->
			{fail, ?ERR_GOODS_NOT_EXIST};
		EquipsInfo ->
			soul_equips_1(PlayerState, EquipsInfo)
	end.

soul_equips_1(PlayerState, EquipsInfo) ->
	GoodsId = EquipsInfo#db_goods.goods_id,
	Soul = EquipsInfo#db_goods.soul,
	case equips_soul_config:get({GoodsId, Soul + 1}) of
		#equips_soul_conf{} = SoulConf ->
			soul_equips_2(PlayerState, EquipsInfo, SoulConf);
		_ ->
			{fail, ?ERR_COMMON_FAIL}
	end.

soul_equips_2(PlayerState, EquipsInfo, SoulConf) ->
	GoodsConf = goods_lib:get_goods_conf_by_id(EquipsInfo#db_goods.goods_id),
	case GoodsConf#goods_conf.is_timeliness == 0 of
		true ->
			soul_equips_3(PlayerState, EquipsInfo, SoulConf);
		false ->
			{fail, ?ERR_COMMON_FAIL}
	end.

soul_equips_3(PlayerState, EquipsInfo, SoulConf) ->
	Consume = SoulConf#equips_soul_conf.consume,
	case goods_util:check_special_list(PlayerState, Consume) of
		true ->
			case goods_util:delete_special_list(PlayerState, Consume, ?LOG_TYPE_SOUAL_UPGRADE) of
				{ok, PlayerState1} ->
					NewEquipsInfo = EquipsInfo#db_goods{soul = 1 + EquipsInfo#db_goods.soul},
					%% 更新装备信息
					goods_lib:update_player_goods_info(PlayerState, NewEquipsInfo),

					Result =
						case EquipsInfo#db_goods.location =:= ?EQUIPS_LOCATION_TYPE of
							true ->
								{ok, PlayerState2} = player_lib:update_refresh_player(PlayerState1, #player_state{}),
								{ok, PlayerState2};
							false ->
								{ok, PlayerState}
						end,
					{ok, StateNew} = Result,
					log_lib:log_goods_attr_change(StateNew, PlayerState, EquipsInfo, NewEquipsInfo, ?LOG_TYPE_SOUAL_UPGRADE),
					Result;
				{fail, Reply} ->
					{fail, Reply}
			end;
		{fail, _Reply} ->
			{fail, ?ERR_SOUL_NOT_ENOUGH}
	end.

%% 勋章升级
medal_upgrade(PlayerState, Id) ->
	case get_equips_info_from_grid(?SUBTYPE_MEDAL) of
		[] ->
			{fail, ?ERR_GOODS_NOT_ENOUGH};
		GoodsInfo ->
			medal_upgrade_1(PlayerState, Id, GoodsInfo)
	end.

medal_upgrade_1(PlayerState, Id, GoodsInfo) ->
	MedalConf = medal_config:get(Id),
	GoodsId = GoodsInfo#db_goods.goods_id,
	case MedalConf#medal_conf.goods_id == GoodsId of
		true ->
			medal_upgrade_2(PlayerState, MedalConf, GoodsInfo);
		false ->
			{fail, ?ERR_HIT_QUICK}
	end.

medal_upgrade_2(PlayerState, MedalConf, GoodsInfo) ->
	DbBase = PlayerState#player_state.db_player_base,
	Lv = DbBase#db_player_base.lv,
	LimitLv = MedalConf#medal_conf.limit_lv,
	case Lv >= LimitLv of
		true ->
			medal_upgrade_3(PlayerState, MedalConf, GoodsInfo);
		false ->
			{fail, ?ERR_COMMON_FAIL}
	end.

medal_upgrade_3(PlayerState, MedalConf, GoodsInfo) ->
	MoneyDb = PlayerState#player_state.db_player_money,
	Feats = MoneyDb#db_player_money.feats,
	case MedalConf#medal_conf.need_feats =< Feats of
		true ->
			NextGoodsId = MedalConf#medal_conf.next_id,
			case NextGoodsId =/= 0 of
				true ->
					medal_upgrade_4(PlayerState, MedalConf, GoodsInfo);
				false ->
					{fail, ?ERR_COMMON_FAIL}
			end;
		false ->
			{fail, ?ERR_PLAYER_FEATS_NOT_ENOUGH}
	end.

medal_upgrade_4(PlayerState, MedalConf, GoodsInfo) ->
	NextGoodsId = MedalConf#medal_conf.next_id,
	NextGoodsConf = goods_lib:get_goods_conf_by_id(NextGoodsId),
	case NextGoodsConf#goods_conf.sub_type == ?SUBTYPE_MEDAL of
		true ->
			NeedFeats = MedalConf#medal_conf.need_feats,
			NewGoodsInfo = GoodsInfo#db_goods{goods_id = NextGoodsId},
			goods_dict:delete_goods_num_to_dict(GoodsInfo#db_goods.goods_id, GoodsInfo#db_goods.id, GoodsInfo#db_goods.is_bind),
			goods_lib:update_player_goods_info(PlayerState, NewGoodsInfo),
			{ok, PlayerState1} = player_lib:incval_on_player_money_log(PlayerState, #db_player_money.feats, -NeedFeats, false, ?LOG_TYPE_MEDAL_UPGRADE),
			Result = player_lib:update_refresh_player(PlayerState, PlayerState1),
			case Result of
				{ok, StateNew} ->
					log_lib:log_goods_attr_change(StateNew, PlayerState, GoodsInfo, NewGoodsInfo, ?LOG_TYPE_MEDAL_UPGRADE);
				_ ->
					skip
			end,
			Result;
		false ->
			{fail, ?ERR_COMMON_FAIL}
	end.

%% 翅膀升级
wing_upgrade(PlayerState, Id, Type) ->
	case get_equips_info_from_grid(?SUBTYPE_WING) of
		[] ->
			{fail, ?ERR_GOODS_NOT_ENOUGH};
		GoodsInfo ->
			wing_upgrade_1(PlayerState, Id, Type, GoodsInfo)
	end.

wing_upgrade_1(PlayerState, Id, Type, GoodsInfo) ->
	WingConf = wing_config:get(Id),
	GoodsId = GoodsInfo#db_goods.goods_id,
	case WingConf#wing_conf.goods_id == GoodsId of
		true ->
			wing_upgrade_2(PlayerState, Type, WingConf, GoodsInfo);
		false ->
			{fail, ?ERR_COMMON_FAIL}
	end.

wing_upgrade_2(PlayerState, Type, WingConf, GoodsInfo) ->
	DbBase = PlayerState#player_state.db_player_base,
	Lv = DbBase#db_player_base.lv,
	LimitLv = WingConf#wing_conf.limit_lv,
	case Lv >= LimitLv of
		true ->
			%% 时效翅膀只能升到10级
			GoodsId = GoodsInfo#db_goods.goods_id,
			GoodsConf = goods_lib:get_goods_conf_by_id(GoodsId),
			case GoodsConf#goods_conf.is_timeliness > 0 andalso GoodsConf#goods_conf.limit_lvl >= 10 of
				true ->
					{fail, ?ERR_WING_UP};
				false ->
					wing_upgrade_3(PlayerState, Type, WingConf, GoodsInfo)
			end;
		false ->
			{fail, ?ERR_COMMON_FAIL}
	end.

wing_upgrade_3(PlayerState, Type, WingConf, GoodsInfo) ->
	NeedGoodsId = WingConf#wing_conf.need_goods,
	GoodsNum = goods_lib:get_goods_num(NeedGoodsId),
	NeedNum = WingConf#wing_conf.need_num,
	case GoodsNum >= NeedNum of
		true ->
			wing_upgrade_5(PlayerState, WingConf, GoodsInfo, NeedNum, 0);
		false ->
			case Type of
				0 ->    %% 不使用元宝代替
					{fail, ?ERR_GOODS_NOT_ENOUGH};
				1 ->  %% 使用元宝代替
					wing_upgrade_4(PlayerState, WingConf, GoodsInfo, GoodsNum, NeedNum - GoodsNum)
			end
	end.

wing_upgrade_4(PlayerState, WingConf, GoodsInfo, NeedNum, OtherNum) ->
	DbMoney = PlayerState#player_state.db_player_money,
	NeedCoin = WingConf#wing_conf.price * OtherNum,
	case WingConf#wing_conf.money_type of
		?SUBTYPE_COIN ->
			Coin = DbMoney#db_player_money.coin,
			case Coin >= NeedCoin of
				true ->
					wing_upgrade_5(PlayerState, WingConf, GoodsInfo, NeedNum, NeedCoin);
				false ->
					{fail, ?ERR_PLAYER_COIN_NOT_ENOUGH}
			end;
		?SUBTYPE_JADE ->
			Jade = DbMoney#db_player_money.jade,
			case Jade >= NeedCoin of
				true ->
					wing_upgrade_5(PlayerState, WingConf, GoodsInfo, NeedNum, NeedCoin);
				false ->
					{fail, ?ERR_PLAYER_JADE_NOT_ENOUGH}
			end;
		_ ->
			{fail, ?ERR_COMMON_FAIL}
	end.

wing_upgrade_5(PlayerState, WingConf, GoodsInfo, NeedNum, NeedCoin) ->
	NextGoodsId = WingConf#wing_conf.next_id,
	case goods_lib:get_goods_conf_by_id(NextGoodsId) of
		#goods_conf{} = NextGoodsConf ->
			case NextGoodsConf#goods_conf.sub_type == ?SUBTYPE_WING of
				true ->
					NeedGoodsId = WingConf#wing_conf.need_goods,
					NewGoodsInfo = GoodsInfo#db_goods{goods_id = NextGoodsId},
					goods_lib_log:delete_goods_by_num(PlayerState, NeedGoodsId, NeedNum, ?LOG_TYPE_WING_UPGRADE),
					goods_dict:delete_goods_num_to_dict(GoodsInfo#db_goods.goods_id, GoodsInfo#db_goods.id, GoodsInfo#db_goods.is_bind),
					goods_lib:update_player_goods_info(PlayerState, GoodsInfo#db_goods{goods_id = NextGoodsId}),
					{ok, PlayerState1} =
						case WingConf#wing_conf.money_type of
							?SUBTYPE_COIN ->
								player_lib:incval_on_player_money_log(PlayerState, #db_player_money.coin, -NeedCoin, false, ?LOG_TYPE_WING_UPGRADE);
							?SUBTYPE_JADE ->
								player_lib:incval_on_player_money_log(PlayerState, #db_player_money.jade, -NeedCoin, false, ?LOG_TYPE_WING_UPGRADE)
						end,

					PlayerState2 = goods_lib:update_guise_state(PlayerState1),
					{ok, PlayerState3} = player_lib:update_refresh_player(PlayerState, PlayerState2),
					log_lib:log_goods_attr_change(PlayerState3, PlayerState, GoodsInfo, NewGoodsInfo, ?LOG_TYPE_WING_UPGRADE),
					{ok, PlayerState3};
				false ->
					{fail, ?ERR_COMMON_FAIL}
			end;
		_ ->
			{fail, ?ERR_COMMON_FAIL}
	end.

%% 坐骑升级
mounts_upgrade(PlayerState, Id) ->
	case get_equips_info_from_grid(?SUBTYPE_MOUNTS) of
		[] ->
			{fail, ?ERR_GOODS_NOT_ENOUGH};
		GoodsInfo ->
			mounts_upgrade_1(PlayerState, Id, GoodsInfo)
	end.

mounts_upgrade_1(PlayerState, Id, GoodsInfo) ->
	MountsConf = mounts_config:get(Id),
	GoodsId = GoodsInfo#db_goods.goods_id,
	case MountsConf#mounts_conf.goods_id == GoodsId of
		true ->
			mounts_upgrade_2(PlayerState, MountsConf, GoodsInfo);
		false ->
			{fail, ?ERR_HIT_QUICK}
	end.

mounts_upgrade_2(PlayerState, MountsConf, GoodsInfo) ->
	DbBase = PlayerState#player_state.db_player_base,
	Lv = DbBase#db_player_base.lv,
	LimitLv = MountsConf#mounts_conf.limit_lv,
	case Lv >= LimitLv of
		true ->
			mounts_upgrade_3(PlayerState, MountsConf, GoodsInfo);
		false ->
			{fail, ?ERR_COMMON_FAIL}
	end.

mounts_upgrade_3(PlayerState, MountsConf, GoodsInfo) ->
	NextGoodsId = MountsConf#mounts_conf.next_id,
	case NextGoodsId =/= 0 of
		true ->
			mounts_upgrade_4(PlayerState, MountsConf, GoodsInfo);
		false ->
			{fail, ?ERR_COMMON_FAIL}
	end.

mounts_upgrade_4(PlayerState, MountsConf, GoodsInfo) ->
	NextGoodsId = MountsConf#mounts_conf.next_id,
	NextGoodsConf = goods_lib:get_goods_conf_by_id(NextGoodsId),
	Stuff = MountsConf#mounts_conf.stuff,
	case goods_util:check_special_list(PlayerState, Stuff) of
		true ->
			case NextGoodsConf#goods_conf.sub_type == ?SUBTYPE_MOUNTS of
				true ->
					%% 检测强化成功率
					Rate = MountsConf#mounts_conf.rate,
					case util_rand:rand_hit(Rate) of
						true ->
							NewGoodsInfo = GoodsInfo#db_goods{goods_id = NextGoodsId},
							{ok, PlayerState1} = goods_util:delete_special_list(PlayerState, Stuff, ?LOG_TYPE_MEDAL_UPGRADE),
							goods_dict:delete_goods_num_to_dict(GoodsInfo#db_goods.goods_id, GoodsInfo#db_goods.id, GoodsInfo#db_goods.is_bind),
							goods_lib:update_player_goods_info(PlayerState, NewGoodsInfo),
							PlayerState2 = goods_lib:update_guise_state(PlayerState1),
							{ok, PlayerState3} = player_lib:update_refresh_player(PlayerState, PlayerState2),
							log_lib:log_goods_attr_change(PlayerState3, PlayerState, GoodsInfo, NewGoodsInfo, ?LOG_TYPE_MEDAL_UPGRADE),
							{ok, PlayerState3, ?ERR_COMMON_SUCCESS};
						false ->
							{ok, PlayerState1} = goods_util:delete_special_list(PlayerState, Stuff, ?LOG_TYPE_MEDAL_UPGRADE),
							{ok, PlayerState1, ?ERR_COMMON_FAIL}
					end;
				false ->
					{fail, ?ERR_COMMON_FAIL}
			end;
		{fail, Reply} ->
			{fail, Reply}
	end.

%% 按品质分解装备
decompose_equips_by_quality(State, QualityList) ->
	EquipsInfoList = goods_dict:get_player_equips_list(),
	Fun = fun(GoodsInfo, {Acc, Acc1}) ->
		GoodsId = GoodsInfo#db_goods.goods_id,
		GoodsConf = goods_lib:get_goods_conf_by_id(GoodsId),
		Quality = GoodsConf#goods_conf.quality,
		IsDecompose = GoodsConf#goods_conf.is_decompose,
		Location = GoodsInfo#db_goods.location,
		StrenLv = GoodsInfo#db_goods.stren_lv,
		case lists:member(Quality, QualityList) andalso Location == ?NORMAL_LOCATION_TYPE andalso
			StrenLv == 0 andalso IsDecompose == 0 andalso
			goods_lib:get_server_use(GoodsInfo#db_goods.server_id) =:= 1
		of
			true ->
				Id = GoodsInfo#db_goods.id,
				{[Id] ++ Acc, [GoodsInfo] ++ Acc1};
			false ->
				{Acc, Acc1}
		end
	end,
	{IdList, DecomposeList} = lists:foldl(Fun, {[], []}, EquipsInfoList),

	case check_decompose_equips_1([], DecomposeList) of
		{ok, AddGoodsList} ->
			case goods_lib_log:decompose(State, IdList, AddGoodsList, ?LOG_TYPE_DECOMPOSE) of
				{ok, State1} ->
					{ok, State1, IdList};
				{fail, Reply} ->
					{fail, Reply}
			end;
		{fail, Reply} ->
			{fail, Reply}
	end.

%% 出售道具列表根据道具唯一id
decompose_equips_by_id(State, IdList) ->
	case check_decompose_equips([], IdList) of
		{ok, AddGoodsList} ->
			case goods_lib_log:decompose(State, IdList, AddGoodsList, ?LOG_TYPE_DECOMPOSE) of
				{ok, State1} ->
					{ok, State1};
				{fail, Reply} ->
					{fail, Reply}
			end;
		{fail, Reply} ->
			{fail, Reply}
	end.

%% 分解装备检测
check_decompose_equips(GoodsInfoList, []) ->
	check_decompose_equips_1([], GoodsInfoList);
check_decompose_equips(GoodsInfoList, [Id | T]) ->
	case goods_lib:get_player_goods_info(Id, true) of%%--
		{fail, Err} ->
			{fail, Err};
		GoodsInfo ->
			check_decompose_equips([GoodsInfo] ++ GoodsInfoList, T)
	end.
%% 分解装备
check_decompose_equips_1(AddGoodsList, []) ->
	merge_add_goods_list(AddGoodsList);
check_decompose_equips_1(AddGoodsList, [GoodsInfo | T]) ->
	GoodsId = GoodsInfo#db_goods.goods_id,
	case decompose_config:get(GoodsId) of
		#decompose_conf{} = DecConf ->
			GoodsList = DecConf#decompose_conf.goods_list,
			StrenLv = GoodsInfo#db_goods.stren_lv,
			DecStrConf = decompose_stren_config:get(StrenLv),
			GoodsList1 = DecStrConf#decompose_stren_conf.goods_list,
			AddList = GoodsList ++ GoodsList1,
			AddGoodsList1 = AddList ++ AddGoodsList,
			Consume = get_change_consume(GoodsInfo, true),
			SoulList = [{G, ?NOT_BIND, N} || {G, N} <- Consume],
			AddGoodsList2 = SoulList ++ AddGoodsList1,
			check_decompose_equips_1(AddGoodsList2, T);
		_ ->
			StrenLv = GoodsInfo#db_goods.stren_lv,
			DecStrConf = decompose_stren_config:get(StrenLv),
			%% 非分解装备兑换成金币
			GoodsConf = goods_lib:get_goods_conf_by_id(GoodsId),
			GoodsList = DecStrConf#decompose_stren_conf.goods_list,
			Price = GoodsConf#goods_conf.sale,
			AddList = [{?GOODS_ID_COIN, ?BIND, Price}] ++ GoodsList,
			AddGoodsList1 = AddList ++ AddGoodsList,
			Consume = get_change_consume(GoodsInfo, true),
			SoulList = [{G, ?NOT_BIND, N} || {G, N} <- Consume],
			AddGoodsList2 = SoulList ++ AddGoodsList1,
			check_decompose_equips_1(AddGoodsList2, T)
	end.

merge_add_goods_list(GoodsList) ->
	Fun = fun({GoodsId, IsBind, Num}, Acc) ->
		case lists:keyfind({GoodsId, IsBind}, 1, Acc) of
			false ->
				lists:keystore({GoodsId, IsBind}, 1, Acc, {{GoodsId, IsBind}, Num});
			{_, N} ->
				lists:keystore({GoodsId, IsBind}, 1, Acc, {{GoodsId, IsBind}, N + Num})
		end
	end,
	Result = lists:foldl(Fun, [], GoodsList),
	{ok, [{G, I, N} || {{G, I}, N} <- Result]}.

%% 装备投保
equips_secure(PlayerState, Id, Count) ->
	case goods_lib:get_player_goods_info(Id, false) of%%
		{fail, Err} ->
			{fail, Err};
		GoodsInfo ->
			equips_secure_1(PlayerState, GoodsInfo, Count)
	end.

equips_secure_1(PlayerState, GoodsInfo, Count) ->
	case GoodsInfo#db_goods.is_bind == ?BIND of
		true ->
			{fail, ?ERR_COMMON_FAIL};
		false ->
			case GoodsInfo#db_goods.secure + Count > 10 of
				true ->
					{fail, ?ERR_PLAYER_SECURE_LIMIT_COUNT};
				false ->
					equips_secure_2(PlayerState, GoodsInfo, Count)
			end
	end.

equips_secure_2(PlayerState, GoodsInfo, Count) ->
	GoodsId = GoodsInfo#db_goods.goods_id,
	GoodsConf = goods_config:get(GoodsId),
	Price = GoodsConf#goods_conf.secure_price,
	case Price == 0 of
		true ->
			{fail, ?ERR_COMMON_FAIL};
		false ->
			DBM = PlayerState#player_state.db_player_money,
			case DBM#db_player_money.jade >= Count * Price of
				true ->
					equips_secure_3(PlayerState, GoodsInfo, Count);
				false ->
					{fail, ?ERR_PLAYER_JADE_NOT_ENOUGH}
			end
	end.

equips_secure_3(PlayerState, GoodsInfo, Count) ->
	GoodsId = GoodsInfo#db_goods.goods_id,
	GoodsConf = goods_config:get(GoodsId),
	Price = GoodsConf#goods_conf.secure_price,
	Secure = GoodsInfo#db_goods.secure,
	goods_lib:update_player_goods_info(PlayerState, GoodsInfo#db_goods{secure = Secure + Count}),
	Result = player_lib:incval_on_player_money_log(PlayerState, #db_player_money.jade, -Count * Price, true, ?LOG_TYPE_EQUIPS_SECURE),
	log_lib:log_insurance(PlayerState, GoodsId, Count, Secure + Count),
	Result.


%% ====================================================================
%%
%% ====================================================================

%% 获取格子上的装备信息
get_equips_info_from_grid(Grid) ->
	EquipsList = goods_dict:get_player_equips_list(),
	case lists:keyfind(Grid, #db_goods.grid, EquipsList) of
		false ->
			[];
		GoodsInfo ->
			GoodsInfo
	end.

%% 获取装备格子对应的装备类型
get_match_subtype_by_grid(Grid) ->
	case Grid of
		11 ->
			?SUBTYPE_BANGLE;
		12 ->
			?SUBTYPE_RING;
		30 ->
			?SUBTYPE_SP_RING;
		_ ->
			Grid
	end.

%% 更新外观检测(2套武器外观特殊处理)
check_guise_state(State, EquipsInfo) ->
	case EquipsInfo#db_goods.grid of
		?SUBTYPE_WEAPON ->
			case equips_lib:get_equips_info_from_grid(?SUBTYPE_SP_WEAPON) of
				[] ->
					GoodsId = EquipsInfo#db_goods.goods_id,
					GoodsConf = goods_lib:get_goods_conf_by_id(GoodsId),
					GuiseState = State#player_state.guise,
					Res = GoodsConf#goods_conf.res,
					#player_state{guise = GuiseState#guise_state{weapon = Res}};
				_ ->
					#player_state{}
			end;
		?SUBTYPE_CLOTHES ->
			GoodsId = EquipsInfo#db_goods.goods_id,
			GoodsConf = goods_lib:get_goods_conf_by_id(GoodsId),
			GuiseState = State#player_state.guise,
			Res = GoodsConf#goods_conf.res,
			#player_state{guise = GuiseState#guise_state{clothes = Res}};
		?SUBTYPE_WING ->
			GoodsId = EquipsInfo#db_goods.goods_id,
			GoodsConf = goods_lib:get_goods_conf_by_id(GoodsId),
			GuiseState = State#player_state.guise,
			Res = GoodsConf#goods_conf.res,
			#player_state{guise = GuiseState#guise_state{wing = Res}};
		?SUBTYPE_PET ->
			GoodsId = EquipsInfo#db_goods.goods_id,
			GoodsConf = goods_lib:get_goods_conf_by_id(GoodsId),
			GuiseState = State#player_state.guise,
			Res = GoodsConf#goods_conf.res,
			#player_state{guise = GuiseState#guise_state{pet = Res}};
		?SUBTYPE_MOUNTS ->
			GoodsId = EquipsInfo#db_goods.goods_id,
			GoodsConf = goods_lib:get_goods_conf_by_id(GoodsId),
			GuiseState = State#player_state.guise,
			Res = GoodsConf#goods_conf.res,
			#player_state{guise = GuiseState#guise_state{mounts = Res}};
		?SUBTYPE_SP_WEAPON ->
			GoodsId = EquipsInfo#db_goods.goods_id,
			GoodsConf = goods_lib:get_goods_conf_by_id(GoodsId),
			GuiseState = State#player_state.guise,
			Res = GoodsConf#goods_conf.res,
			#player_state{guise = GuiseState#guise_state{weapon = Res}};
		_ ->
			#player_state{}
	end.

restore_guise_state(State, EquipsInfo) ->
	case EquipsInfo#db_goods.grid of
		?SUBTYPE_WEAPON ->
			case equips_lib:get_equips_info_from_grid(?SUBTYPE_SP_WEAPON) of
				[] ->
					GuiseState = State#player_state.guise,
					#player_state{guise = GuiseState#guise_state{weapon = ?DEFAULT_GUISE_WEAPON}};
				_ ->
					#player_state{}
			end;
		?SUBTYPE_CLOTHES ->
			GuiseState = State#player_state.guise,
			#player_state{guise = GuiseState#guise_state{clothes = ?DEFAULT_GUISE_CLOTHES}};
		?SUBTYPE_WING ->
			GuiseState = State#player_state.guise,
			#player_state{guise = GuiseState#guise_state{wing = 0}};
		?SUBTYPE_PET ->
			GuiseState = State#player_state.guise,
			#player_state{guise = GuiseState#guise_state{pet = 0}};
		?SUBTYPE_MOUNTS ->
			GuiseState = State#player_state.guise,
			#player_state{guise = GuiseState#guise_state{mounts = 0}};
		?SUBTYPE_SP_WEAPON ->
			case equips_lib:get_equips_info_from_grid(?SUBTYPE_WEAPON) of
				[] ->
					GuiseState = State#player_state.guise,
					#player_state{guise = GuiseState#guise_state{weapon = ?DEFAULT_GUISE_WEAPON}};
				EquipsInfo1 ->
					GoodsId = EquipsInfo1#db_goods.goods_id,
					GoodsConf = goods_lib:get_goods_conf_by_id(GoodsId),
					GuiseState = State#player_state.guise,
					Res = GoodsConf#goods_conf.res,
					#player_state{guise = GuiseState#guise_state{weapon = Res}}
			end;
		_ ->
			#player_state{}
	end.

update_equips_skill(State, [], NewEquipsInfo) ->
	PassList = State#player_state.pass_trigger_skill_list,
	NewGoodsId = NewEquipsInfo#db_goods.goods_id,
	PassList1 = case get_equips_skill_by_goods_id(NewGoodsId) of
					[] -> PassList;
					{SkillId, SkillLv} ->
						lists:keystore(SkillId, 1, PassList, {SkillId, SkillLv})
				end,
	State#player_state{pass_trigger_skill_list = PassList1};
update_equips_skill(State, OldEquipsInfo, []) ->
	PassList = State#player_state.pass_trigger_skill_list,
	OldGoodsId = OldEquipsInfo#db_goods.goods_id,
	PassList1 = lists:delete(get_equips_skill_by_goods_id(OldGoodsId), PassList),
	State#player_state{pass_trigger_skill_list = PassList1};
update_equips_skill(State, OldEquipsInfo, NewEquipsInfo) ->
	PassList = State#player_state.pass_trigger_skill_list,
	OldGoodsId = OldEquipsInfo#db_goods.goods_id,
	NewGoodsId = NewEquipsInfo#db_goods.goods_id,
	PassList1 = lists:delete(get_equips_skill_by_goods_id(OldGoodsId), PassList),
	PassList2 = case get_equips_skill_by_goods_id(NewGoodsId) of
					[] -> PassList1;
					{SkillId, SkillLv} ->
						lists:keystore(SkillId, 1, PassList1, {SkillId, SkillLv})
				end,
	State#player_state{pass_trigger_skill_list = PassList2}.

get_equips_skill_by_goods_id(GoodsId) ->
	GoodsConf = goods_lib:get_goods_conf_by_id(GoodsId),
	Extra = GoodsConf#goods_conf.extra,
	case lists:keyfind(skill, 1, Extra) of
		{_, SkillId, SkillLv} ->
			{SkillId, SkillLv};
		_ ->
			[]
	end.

%% 获取幸运属性
get_luck_record(GoodsInfo) ->
	Location = GoodsInfo#db_goods.location,
	Grid = GoodsInfo#db_goods.grid,
	case Location =:= ?EQUIPS_LOCATION_TYPE andalso Grid =:= ?SUBTYPE_WEAPON of
		true ->
			Extra = GoodsInfo#db_goods.extra,
			case lists:keyfind(?EQUIPS_LUCK_KEY, 1, Extra) of
				{_, Luck} ->
					#attr_base{luck = Luck};
				_ ->
					[]
			end;
		false ->
			[]
	end.

%% 上坐骑
up_mounts(State) ->
	case get_equips_info_from_grid(?SUBTYPE_MOUNTS) of
		[] ->
			skip;
		EquipsInfo ->
			GoodsId = EquipsInfo#db_goods.goods_id,
			GoodsConf = goods_lib:get_goods_conf_by_id(GoodsId),
			ResMounts = GoodsConf#goods_conf.res,

			ChangeState = #player_state{guise = #guise_state{mounts = ResMounts}},
			%% 更新玩家属性
			player_lib:update_refresh_player(State, ChangeState)
	end.

%% 下坐骑
down_mounts(State) ->
	case get_equips_info_from_grid(?SUBTYPE_MOUNTS) of
		[] ->
			skip;
		_EquipsInfo ->
			ChangeState = #player_state{guise = #guise_state{mounts = 0}},
			%% 更新玩家属性
			player_lib:update_refresh_player(State, ChangeState)
	end.

%% 获取装备配置范围内最大等级
get_equips_range_max_lv(Lv) ->
	case Lv rem 10 of
		0 -> Lv;
		_ -> (1 + (Lv div 10)) * 10
	end.

%% 获取隐身戒指技能
add_stealth_ring_skill(PlayerState, GoodsId) ->
	#goods_conf{extra = Extra} = goods_config:get(GoodsId),
	NPlayerState =
	case Extra of
		[{skill, ?RING_STEALTH_SKILL, SkillLv}] ->
			case skill_tree_lib:add_skill(PlayerState, ?RING_STEALTH_SKILL, SkillLv) of
				{ok, PlayerState1} ->
					PlayerState1;
				_AA ->
					PlayerState
			end;
		_BB ->
			PlayerState
	end,
	NPlayerState.


%% 清除隐身戒指技能
clean_stealth_ring_skill(PlayerState, GoodsId) ->
%% 	io:format("clean ring skill : ~p~n",[{GoodsId, PlayerState#player_state.player_id}]),
	#goods_conf{extra = Extra} = goods_config:get(GoodsId),
%% 	io:format("clean ring skill 2:~p~n", [Extra]),
	NPlayerState =
		case Extra of
			[{skill, ?RING_STEALTH_SKILL, _SkillLv}] ->
				case skill_tree_lib:clean_skill(PlayerState, ?RING_STEALTH_SKILL) of
					{ok, PlayerState1} ->
%% 						io:format("clean ring skill 3 : ~p~n", [1]),
						PlayerState1;
					_AA ->
%% 						io:format("clean ring skill 4 : ~p~n", [_AA]),
						PlayerState
				end;
			_BB ->
%% 				io:format("clean ring skill 5 : ~p~n", [_BB]),
				PlayerState
		end,
	NPlayerState.



