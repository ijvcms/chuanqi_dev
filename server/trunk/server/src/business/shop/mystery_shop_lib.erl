%%%-------------------------------------------------------------------
%%% @author yubing
%%% @copyright (C) 2016, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 29. 六月 2016 10:18
%%%-------------------------------------------------------------------
-module(mystery_shop_lib).

-include("common.hrl").
-include("record.hrl").
-include("cache.hrl").
-include("config.hrl").
-include("proto.hrl").
-include("language_config.hrl").
-include("log_type_config.hrl").
-include("uid.hrl").

-define(VIP_LIMIT_NUM, 2).%% vip限制次数
-define(MYSTERY_LIMIT_NUM, 5).%% 神秘商店限制次数
-define(REF_MYSTERY_NEED_JADE, 30).%% 刷新需要的元宝
%% API
-export([
	get_mystery_shop_list/1,
	ref_mystery_shop_list/1,
	ref_time/1,
	buy_mystery_shop/2,
	get_need_jade/0,
	init/1,
	check_price/3,
	deduct_money/4
]).


%% 获取神秘商店物品列表
get_mystery_shop_list(PlayerState) ->
	F = fun(X) ->
		MysteryConf = mystery_shop_config:get(X#db_player_mystery_shop.mystery_shop_id),
		{GoodsId, IsBind, Num} = MysteryConf#mystery_shop_conf.goods,
		#proto_mystery_shop{
			mystery_shop_id = MysteryConf#mystery_shop_conf.id,
			is_buy = X#db_player_mystery_shop.is_buy,
			curr_type = MysteryConf#mystery_shop_conf.curr_type,
			price = MysteryConf#mystery_shop_conf.price,
			vip = MysteryConf#mystery_shop_conf.vip,
			goods_id = GoodsId,
			is_bind = IsBind,
			num = Num,
			discount = MysteryConf#mystery_shop_conf.discount
		}
	end,
	[F(X) || X <- PlayerState#player_state.mystery_shop_list].

%% 手动刷新神秘商店物品
ref_mystery_shop_list(PlayerState) ->
	DbMoney = PlayerState#player_state.db_player_money,
	NeedJade = get_need_jade(),
	case DbMoney#db_player_money.jade < NeedJade of
		true ->
			{fail, ?ERR_PLAYER_JADE_NOT_ENOUGH};
		_ ->
			{ok, PlayerState1} = player_lib:incval_on_player_money_log(PlayerState, #db_player_money.jade, -NeedJade, ?LOG_TYPE_REF_MYSTERY_SHOP),
			PlayerState2 = ref_mystery_shop(PlayerState1, PlayerState1#player_state.ref_mystery_shop_time),
			{ok, PlayerState2, get_mystery_shop_list(PlayerState2)}
	end.
%% 购买商品
buy_mystery_shop(PlayerState, MysteryShopId) ->
	MysteryList = PlayerState#player_state.mystery_shop_list,
	case counter_lib:check(PlayerState#player_state.player_id, ?COUNTER_BUY_MYSTERY_LIMIE) of
		false ->
			{fail, ?ERR_BUY_MYSTERY_LIMIT};
		_ ->
			case lists:keyfind(MysteryShopId, #db_player_mystery_shop.mystery_shop_id, MysteryList) of
				false ->
					{fail, ?ERR_NOT_SALE_GOODS};
				MysteryInfo ->
					case MysteryInfo#db_player_mystery_shop.is_buy of
						1 ->
							{fail, ?ERR_BUY_MYSTERY};
						_ ->
							MysteryConf = mystery_shop_config:get(MysteryShopId),
							#mystery_shop_conf{curr_type = CurrType, price = Price} = MysteryConf,
							case check_price(PlayerState, CurrType, Price) of
								{ok, _Price} ->
                                  LogType = case CurrType of
                                              ?SUBTYPE_GIFT -> ?LOG_TYPE_MYSTERY_SHOP_GIFT_BUY;
                                              ?SUBTYPE_COIN -> ?LOG_TYPE_MYSTERY_SHOP_COIN_BUY;
                                              _ -> ?LOG_TYPE_MYSTERY_SHOP_JADE_BUY
                                            end,
									case goods_lib_log:add_goods_list(PlayerState, [MysteryConf#mystery_shop_conf.goods], LogType) of
										{ok, PlayerState1} ->
											MysteryInfo1 = MysteryInfo#db_player_mystery_shop{
												is_buy = 1
											},
											player_mystery_shop_cache:update({MysteryInfo#db_player_mystery_shop.player_id, MysteryInfo#db_player_mystery_shop.id}, MysteryInfo1),
											%% 替换缓存数据
											MysteryList1 = lists:keyreplace(MysteryInfo1#db_player_mystery_shop.id, #db_player_mystery_shop.id, MysteryList, MysteryInfo1),
											%% 扣除玩家的消耗
											{ok, PlayerState2} = deduct_money(PlayerState1, CurrType, Price,?LOG_TYPE_BUY_MYSTERY_SHOP),
											%% 神秘商人购买上限
											counter_lib:update_limit(PlayerState2#player_state.player_id, ?COUNTER_BUY_MYSTERY_LIMIE),
											{ok, PlayerState2#player_state{mystery_shop_list = MysteryList1}};
										Err ->
											Err
									end;
								Err ->
									Err
							end
					end
			end
	end.


%% 时间到了刷新玩家的 神秘商品列表
ref_time(PlayerState) ->
	CurTime = util_date:unixtime(),
	RefTime = PlayerState#player_state.ref_mystery_shop_time,
	%%?ERR(" ~p", [{RefTime, CurTime, RefTime - CurTime}]),
	case RefTime < CurTime of
		true ->
			TodayTime = util_date:get_today_unixtime(),
			Hour = (CurTime - TodayTime) div (6 * 3600),
			NewTime = TodayTime + (1 + Hour) * 6 * 3600,
			ref_mystery_shop(PlayerState, NewTime);
		_ ->
			PlayerState
	end.


%%***************************************************
%% API
%%***************************************************
init(PlayerState) ->
	MysteryList = player_mystery_shop_cache:select_all(PlayerState#player_state.player_id),
	RefTime = case length(MysteryList) > 0 of
				  true ->
					  [MysteryInfo | _] = MysteryList,
					  MysteryInfo#db_player_mystery_shop.ref_time;
				  _ ->
					  util_date:get_today_unixtime()
			  end,
	PlayerState#player_state{mystery_shop_list = MysteryList, ref_mystery_shop_time = RefTime}.

%% 获取刷新需要的元宝
get_need_jade() ->
	?REF_MYSTERY_NEED_JADE.

%% 刷新玩家的神秘商店
ref_mystery_shop(PlayerState, RefTime) ->
	PlayerId = PlayerState#player_state.player_id,
	Base = PlayerState#player_state.db_player_base,
	VipLv = Base#db_player_base.vip,
	MysteryShopList = PlayerState#player_state.mystery_shop_list,
	MysteryShopList1 = case length(MysteryShopList) < 1 of
						   true ->
							   F = fun(_X) ->
								   null
							   end,
							   [F(X) || X <- lists:seq(1, 5)];
						   _ ->
							   MysteryShopList
					   end,
	NewList = random_mystery_list(MysteryShopList1, {[], PlayerId, VipLv, 0, RefTime}),
	PlayerState#player_state{
		mystery_shop_list = NewList,
		ref_mystery_shop_time = RefTime
	}.

%% 随机出神秘商店物品
%% VipNum 大于玩家vip的数量 RefTime 刷新时间 List已经获取的物品列表
random_mystery_list([], {List, _PlayerId, _VipLv, _VipNum, _RefTime}) ->
	List;
random_mystery_list([T | H], {List, PlayerId, VipLv, VipNum, RefTime}) ->
	MySteryConfList = case VipNum > 1 of
						  true ->
							  [M || M <- mystery_shop_config:get_list_conf(),
								  M#mystery_shop_conf.vip =< VipLv, check_limit_num(PlayerId, M, List)];
						  _ ->
							  [M || M <- mystery_shop_config:get_list_conf(), check_limit_num(PlayerId, M, List)]
					  end,
	SumNum = lists:sum([M#mystery_shop_conf.weights || M <- MySteryConfList]),
	RdNum = util_rand:rand(1, SumNum),
	%% 随机出玩家的 神秘商店物品
	MySteryConf = random_mystery(MySteryConfList, RdNum, 0, SumNum),
	%% 如果以前不存在玩家的 神秘物品，那么就新添加
	MySteryInfo2 = case T of
					   null ->
						   MySteryInfo = #db_player_mystery_shop{
							   id = uid_lib:get_uid(?UID_TYPE_PLAYER_MYSTERY_SHOP),
							   player_id = PlayerId,
							   mystery_shop_id = MySteryConf#mystery_shop_conf.id,
							   ref_time = RefTime,
							   is_buy = 0
						   },
						   player_mystery_shop_cache:insert(MySteryInfo),
						   MySteryInfo;
					   MySteryInfo ->
						   MySteryInfo1 = MySteryInfo#db_player_mystery_shop{
							   player_id = PlayerId,
							   mystery_shop_id = MySteryConf#mystery_shop_conf.id,
							   ref_time = RefTime,
							   is_buy = 0
						   },
						   player_mystery_shop_cache:update({MySteryInfo#db_player_mystery_shop.player_id, MySteryInfo#db_player_mystery_shop.id}, MySteryInfo1),
						   MySteryInfo1
				   end,

	NewList = [MySteryInfo2 | List],
	%% 如果大于玩家vip 那么vip计数
	NewVipNum = case MySteryConf#mystery_shop_conf.vip > VipLv of
					true ->
						VipNum + 1;
					_ ->
						VipNum
				end,
	%% 如果有计算器 那么记录出现次数
	case MySteryConf#mystery_shop_conf.counter_id > 0 of
		true ->
			counter_lib:update_limit(PlayerId, MySteryConf#mystery_shop_conf.counter_id);
		_ ->
			skip
	end,
	random_mystery_list(H, {NewList, PlayerId, VipLv, NewVipNum, RefTime}).

%% 从列表中 随机一个物品
random_mystery([], _RdNum, _TempNum, SumNum) ->
	?ERR("random_mystery ~p", [{_RdNum, SumNum}]),
	null;
random_mystery([T | H], RdNum, TempNum, SumNum) ->
	NewTempSum = TempNum + T#mystery_shop_conf.weights,
	case RdNum >= TempNum + 1 andalso RdNum =< NewTempSum of
		true ->
			T;
		_ ->
			random_mystery(H, RdNum, NewTempSum, SumNum)
	end.

%% 验证奖池是否能出现该物品
%% nowlist 当前已经获取的物品列表
check_limit_num(PlayerId, MySteryConf, NowList) ->
	case lists:keymember(MySteryConf#mystery_shop_conf.id, #db_player_mystery_shop.mystery_shop_id, NowList) of
		true ->
			false;
		_ ->
			CounterId = MySteryConf#mystery_shop_conf.counter_id,
			case CounterId < 1 of
				true ->
					true;
				_ ->
					counter_lib:check(PlayerId, CounterId)
			end
	end.

%% 验证钱是否足够
check_price(PlayerState, CurrType, Price) ->
	PlayerMoney = PlayerState#player_state.db_player_money,
	AllPrice = Price,
	case CurrType of
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
%% 扣除货币
deduct_money(PlayerState, CurrType, Price,LogType) ->
	AllPrice = Price,
	case CurrType of
		?SUBTYPE_JADE ->
			player_lib:incval_on_player_money_log(PlayerState, #db_player_money.jade, -AllPrice,LogType);
		?SUBTYPE_COIN ->
			player_lib:incval_on_player_money_log(PlayerState, #db_player_money.coin, -AllPrice,LogType);
		?SUBTYPE_GIFT ->
			player_lib:incval_on_player_money_log(PlayerState, #db_player_money.gift, -AllPrice,LogType)
	end.