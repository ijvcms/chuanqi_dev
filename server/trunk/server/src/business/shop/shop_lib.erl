%%%-------------------------------------------------------------------
%%% @author tuhujia
%%% @copyright (C) 2015, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 06. 九月 2015 11:52
%%%-------------------------------------------------------------------
-module(shop_lib).

-include("common.hrl").
-include("record.hrl").
-include("cache.hrl").
-include("config.hrl").
-include("proto.hrl").
-include("language_config.hrl").
-include("log_type_config.hrl").
%% API
-export([
	buy_shop/3,
	shop_once_function_check/1,
	shop_once_add/3,
	shop_once_state/2,
	shop_once_buy/3
]).

%% ====================================================================
%% API functions
%% ====================================================================

%% 购买商品
buy_shop(PlayerState, ShopId, ShopNum) ->
	ShopConf = shop_config:get(ShopId),
	case check_shop(PlayerState, ShopConf, ShopNum) of
		{fail, Reply} ->
			{fail, Reply};
		{ok, _} ->
			case ShopConf#shop_conf.type of
				?SHOP_TYPE_WANDER ->
					buy_wonder_shop(PlayerState, ShopId, ShopNum, ShopConf);
				_ ->
					buy_shop_1(PlayerState, ShopNum, ShopConf)
			end
	end.

buy_wonder_shop(PlayerState, ShopId, ShopNum, ShopConf) ->
	case wander_shop_lib:check_buy_shop_count(ShopId, ShopNum) of
		true ->
			case buy_shop_1(PlayerState, ShopNum, ShopConf) of
				{ok, PlayerState1} ->
					wander_shop_lib:update_shop_buy_count(ShopId, ShopNum),
					wander_shop_lib:send_proto_wander_shop_list(PlayerState1),
					{ok, PlayerState1};
				{fail, Reply} ->
					{fail, Reply}
			end;
		false ->
			{fail, ?ERR_SHOP_NUM_NOT_ENOUGH}
	end.

buy_shop_1(PlayerState, ShopNum, ShopConf) ->
	case check_price(PlayerState, ShopConf, ShopNum) of
		{ok, _} ->
			GoodsId = ShopConf#shop_conf.goods_id,
			IsBind = ShopConf#shop_conf.is_bind,
			GoodsNum = ShopConf#shop_conf.num,

			GoodsConf = goods_lib:get_goods_conf_by_id(GoodsId),
			GoodsType = GoodsConf#goods_conf.type,
			GoodsSubType = GoodsConf#goods_conf.sub_type,

			%% 坐骑只能拥有1只
			case GoodsType == ?EQUIPS_TYPE andalso GoodsSubType == ?SUBTYPE_MOUNTS andalso
				goods_lib:get_goods_num(GoodsId) + goods_lib:get_store_goods_num(GoodsId) > 0 of
				false ->
					LogType =
						case ShopConf#shop_conf.curr_type of
							?SUBTYPE_JADE -> ?LOG_TYPE_JADE_BUY;
							?SUBTYPE_COIN -> ?LOG_TYPE_COIN_BUY;
							?SUBTYPE_GIFT -> ?LOG_TYPE_GIFT_BUY
						end,
					%% 添加道具
					case goods_lib_log:add_goods(PlayerState, GoodsId, IsBind, GoodsNum * ShopNum, LogType) of
						{ok, PlayerState1} ->
							%% 扣钱
							{ok, PlayerState2} = deduct_money(PlayerState1, ShopConf, ShopNum),
							CounterId = ShopConf#shop_conf.counter_id,
							case CounterId > 0 of
								true ->
									PlayerId = PlayerState#player_state.player_id,
									counter_lib:update_value_limit(PlayerId, CounterId, ShopNum);
								false ->
									skip
							end,
							{ok, PlayerState2};
						{fail, Reply} ->
							{fail, Reply}
					end;
				true ->
					{fail, ?ERR_ENOUGH_BUY_COUNT}
			end;
		{fail, Reply} ->
			{fail, Reply}
	end.

%%一生一次礼包功能是否要开启
shop_once_function_check(DbPlayerBase) ->
	#db_player_base{player_id = PlayerId, lv = Lv} = DbPlayerBase,
	ConfList = shop_once_config:get_list_conf(),
	[#shop_once_conf{lv = MinLv} | _] = ConfList,
	#shop_once_conf{lv = MaxLv} = lists:last(ConfList),
	if
		Lv < MinLv -> false;
		Lv < MaxLv -> true;
		true ->
			Time = util_date:unixtime(),
			List = player_shop_once_cache:select_all({PlayerId, MaxLv, '_'}),
			List2 = lists:filter(fun(#db_player_shop_once{expire_time = ExTime}) ->
				ExTime > Time
			end, List),
			length(List2) > 0
	end.

%%添加一生一次礼包
shop_once_add(PlayerId, LvOld, LvNew) ->
	%%PlayerId = PlayerState#player_state.player_id,
	ConfList = shop_once_config:get_list_conf(),
	ConfLvList = [R || R <- ConfList, R#shop_once_conf.lv > LvOld, R#shop_once_conf.lv =< LvNew],
	Time = util_date:unixtime(),
	ExpireTime = Time + 60 * 60 * 24,
	lists:foreach(fun(#shop_once_conf{goods_id = GoodsId, lv = Lv, pos = Pos, num = Num}) ->
		Rec = #db_player_shop_once{player_id = PlayerId, lv = Lv, pos = Pos, state = 0,
			goods_id = GoodsId, goods_num = Num, add_time = Time, expire_time = ExpireTime},
		player_shop_once_cache:insert(Rec)
	end, ConfLvList).

%%一生一次礼包
shop_once_state(PlayerState, Lv) ->
	PlayerId = PlayerState#player_state.player_id,
	ConfList = shop_once_config:get_list_conf(),
	ConfLvList = [R || R <- ConfList, R#shop_once_conf.lv =:= Lv],
	Time = util_date:unixtime(),
	List = player_shop_once_cache:select_all({PlayerId, Lv, '_'}),
	{StList, ExpireTime} =
		lists:foldr(fun(#shop_once_conf{pos = Pos}, {Acc, ExTime1}) ->
			{NewSt, ExTime2} =
				case lists:keyfind(Pos, #db_player_shop_once.pos, List) of
					false ->
						{2, ExTime1};
					#db_player_shop_once{lv = Lv, pos = Pos, state = St, expire_time = ExTime} ->
						St1 = case ExTime > Time of
								  true -> St;
								  false -> 2
							  end,
						{St1, ExTime}

				end,
			Item = #proto_shop_once_state{lv = Lv, pos = Pos, state = NewSt},
			{[Item | Acc], ExTime2}
		end, {[], Time}, ConfLvList),
	LeftTime = erlang:max(ExpireTime - Time, 0),
	Rep = #rep_shop_once_list{state_list = StList, expire_time = LeftTime},
	net_send:send_to_client(PlayerState#player_state.socket, 16004, Rep).

%%一生一次礼包购买
shop_once_buy(PlayerState, Lv, Pos) ->
	PlayerId = PlayerState#player_state.player_id,
	Time = util_date:unixtime(),
	case player_shop_once_cache:select_row({PlayerId, Lv, Pos}) of
		#db_player_shop_once{state = St, expire_time = ExTime} = Info ->
			case St =:= 0 andalso ExTime > Time of
				true ->
					ConfList = shop_once_config:get_list_conf(),
					Choice = [R || R <- ConfList, R#shop_once_conf.lv =:= Lv, R#shop_once_conf.pos =:= Pos],
					case Choice of
						[#shop_once_conf{goods_id = GoodsId, is_bind = IsBind, num = Num, price_now = PriceNow}] ->
							case shop_once_bu1(PlayerState, GoodsId, IsBind, Num, PriceNow) of
								{ok, Ps} ->
									NewInfo = Info#db_player_shop_once{state = 1, buy_time = Time, money = PriceNow},
									player_shop_once_cache:update({PlayerId, Lv, Pos}, NewInfo),
									log_lib:log_shop_once(PlayerState, GoodsId, Num, PriceNow),
									{ok, Ps};
								Result ->
									Result
							end;
						false ->
							{fail, 1}
					end;
				false ->
					{fail, 1}
			end;
		false ->
			{fail, 1}
	end.

shop_once_bu1(PlayerState, GoodsId, IsBind, GoodsNum, Money) ->
	PlayerMoney = PlayerState#player_state.db_player_money,
	PlayerJade = PlayerMoney#db_player_money.jade,
	case PlayerJade >= Money of
		true ->
			case goods_lib_log:add_goods(PlayerState, GoodsId, IsBind, GoodsNum, ?LOG_TYPE_SHOP_ONCE) of
				{ok, PlayerState1} ->
					player_lib:incval_on_player_money_log(PlayerState1, #db_player_money.jade, -Money, ?LOG_TYPE_SHOP_ONCE);
				{fail, Reply} ->
					{fail, Reply}
			end;
		false ->
			{fail, ?ERR_PLAYER_JADE_NOT_ENOUGH}
	end.

check_price(PlayerState, ShopConf, ShopNum) ->
	PlayerMoney = PlayerState#player_state.db_player_money,
	AllPrice = ShopNum * ShopConf#shop_conf.price,
	case ShopConf#shop_conf.curr_type of
		?SUBTYPE_JADE ->
			case PlayerMoney#db_player_money.jade >= AllPrice of
				true ->
					{ok, AllPrice};
				false ->
					{fail, ?ERR_PLAYER_JADE_NOT_ENOUGH}
			end;
		?SUBTYPE_COIN ->
			case PlayerMoney#db_player_money.coin >= AllPrice of
				true ->
					{ok, AllPrice};
				false ->
					{fail, ?ERR_PLAYER_COIN_NOT_ENOUGH}
			end;
		?SUBTYPE_GIFT ->
			case PlayerMoney#db_player_money.gift >= AllPrice of
				true ->
					{ok, AllPrice};
				false ->
					{fail, ?ERR_PLAYER_GIFT_NOT_ENOUGH}
			end
	end.

deduct_money(PlayerState, ShopConf, ShopNum) ->
	AllPrice = ShopNum * ShopConf#shop_conf.price,
	GoodsId = ShopConf#shop_conf.goods_id,
	IsBind = ShopConf#shop_conf.is_bind,
	GoodsNum = ShopConf#shop_conf.num,
	case ShopConf#shop_conf.curr_type of
		?SUBTYPE_JADE ->
			goods_lib:broadcast_goods_change(PlayerState, ?GOODS_ID_JADE, AllPrice, [{GoodsId, IsBind, GoodsNum * ShopNum}]),
			player_lib:incval_on_player_money_log(PlayerState, #db_player_money.jade, -AllPrice, ?LOG_TYPE_SHOP_BUY);
		?SUBTYPE_COIN ->
			player_lib:incval_on_player_money_log(PlayerState, #db_player_money.coin, -AllPrice, ?LOG_TYPE_SHOP_BUY);
		?SUBTYPE_GIFT ->
			goods_lib:broadcast_goods_change(PlayerState, ?GOODS_ID_GIFT, AllPrice, [{GoodsId, IsBind, GoodsNum * ShopNum}]),
			player_lib:incval_on_player_money_log(PlayerState, #db_player_money.gift, -AllPrice, ?LOG_TYPE_SHOP_BUY)
	end.

check_shop(PlayerState, ShopConf, ShopNum) ->
	case util:loop_functions(
		none,
		[
			fun(_) ->
				LimitVip = ShopConf#shop_conf.limit_vip,
				#player_state{db_player_base = #db_player_base{vip = Vip}} = PlayerState,
				case LimitVip > 0
					andalso LimitVip > Vip of
					true ->
						{break, ?ERR_PLAYER_VIPLV_NOT_ENOUGH};
					false ->
						{continue, none}
				end
			end,
			fun(_) ->
				CounterId = ShopConf#shop_conf.counter_id,
				PlayerId = PlayerState#player_state.player_id,
				case CounterId > 0
					andalso counter_lib:get_value(PlayerId, CounterId) + ShopNum > counter_lib:get_limit(CounterId) of
					true ->
						{break, ?ERR_BUY_SHOP_LIMIT};
					false ->
						{continue, none}
				end
			end
		]
	) of
		{break, Reply} -> {fail, Reply};
		{ok, Value} -> {ok, Value}
	end.