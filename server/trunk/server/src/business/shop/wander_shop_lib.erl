%%%-------------------------------------------------------------------
%%% @author tuhujia
%%% @copyright (C) 2016, <COMPANY>
%%% @doc 云游商店
%%%
%%% @end
%%% Created : 08. 三月 2016 10:16
%%%-------------------------------------------------------------------
-module(wander_shop_lib).

-include("common.hrl").
-include("record.hrl").
-include("proto.hrl").
-include("cache.hrl").
-include("db_record.hrl").
-include("config.hrl").
-include("uid.hrl").
-include("language_config.hrl").

%% API
-export([
	reload_shop_list/0,
	send_proto_wander_shop_list/1,
	check_buy_shop_count/2,
	update_shop_buy_count/2
]).

%% ====================================================================
%% API functions
%% ====================================================================

%% 重载商品列表
reload_shop_list() ->
	%% 初始化商品
	ets:delete_all_objects(?ETS_WANDER_SHOP_LIST),
	init_random_shop(),
	ok.

%% 获取云游商人商品列表
send_proto_wander_shop_list(PlayerState) ->
	Proto = get_shop_list(),
	net_send:send_to_client(PlayerState#player_state.socket, 16002, #rep_get_wander_shop_list{shop_list = Proto}).

%% 检测是否能买该道具
check_buy_shop_count(ShopId, N) ->
	get_buy_count(ShopId) >= N.

%% 刷新道具购买次数
update_shop_buy_count(ShopId, N) ->
	case ets:lookup(?ETS_WANDER_SHOP_LIST, ?SHOP_TYPE_WANDER) of
		[R|_] ->
			ShopList = R#ets_wander_shop_list.shop_list,
			case lists:keyfind(ShopId, #ets_wander_shop.shop_id, ShopList) of
				#ets_wander_shop{} = EtsInfo ->
					NewBuyCount = N + EtsInfo#ets_wander_shop.buy_count,
					EtsInfo1 = EtsInfo#ets_wander_shop{buy_count = NewBuyCount},
					ShopList1 = lists:keyreplace(ShopId, #ets_wander_shop.shop_id, ShopList, EtsInfo1),
					R1 = R#ets_wander_shop_list{shop_list = ShopList1},
					ets:insert(?ETS_WANDER_SHOP_LIST, R1);
				_ ->
					skip
			end;
		_ ->
			skip
	end.

%% ====================================================================
%% 内部函数
%% ====================================================================

get_shop_list() ->
	case ets:lookup(?ETS_WANDER_SHOP_LIST, ?SHOP_TYPE_WANDER) of
		[R|_] ->
			%% 商品刷新时间检测
			check_random_shop(R);
		_ ->
			%% 初始化商品
			init_random_shop()
	end.

%% 获取商品剩余购买次数
get_buy_count(ShopId) ->
	case ets:lookup(?ETS_WANDER_SHOP_LIST, ?SHOP_TYPE_WANDER) of
		[R|_] ->
			ShopList = R#ets_wander_shop_list.shop_list,
			case lists:keyfind(ShopId, #ets_wander_shop.shop_id, ShopList) of
				#ets_wander_shop{} = EtsInfo ->
					LimitCount = EtsInfo#ets_wander_shop.limit_count,
					BuyCount = EtsInfo#ets_wander_shop.buy_count,
					LimitCount - BuyCount;
				_ ->
					0
			end;
		_ ->
			0
	end.

%% 商品刷新时间检测
check_random_shop(R) ->
	RefuseList = R#ets_wander_shop_list.refuse_list,
	ShopList = R#ets_wander_shop_list.shop_list,
	NowTime = util_date:unixtime(),

	Fun = fun({Key, RefuseTime}, {RefuseList1, ShopList1}) ->
				case NowTime >= RefuseTime of
					true ->
						Conf = wander_shop_config:get(Key),
						Num = Conf#wander_shop_conf.random_num,
						RandomList = Conf#wander_shop_conf.random_list,
						RefuseList2 = lists:keyreplace(Key, 1, RefuseList1, {Key, RefuseTime + ?DAY_TIME_COUNT}),
						ShopList2 = get_ets_wander_shop_list(util_rand:weight_rand_2(Num, RandomList)),
						ShopList3 = get_ets_wander_shop_list(Conf#wander_shop_conf.shop_list),
						{RefuseList2, ShopList3 ++ ShopList2};
					false ->
						{RefuseList1, ShopList1}
				end
		  end,
	{NewRefuseList, NewShopList} = lists:foldl(Fun, {RefuseList, ShopList}, RefuseList),

	case NewRefuseList == RefuseList of
		true ->
			change_proto_wander_shop_list(NewShopList);
		false ->
			R1 = R#ets_wander_shop_list
			{
				shop_list = NewShopList,
				refuse_list = NewRefuseList,
				update_time = NowTime
			},
			ets:insert(?ETS_WANDER_SHOP_LIST, R1),
			change_proto_wander_shop_list(NewShopList)
	end.


%% 初始化刷新随机商品
init_random_shop() ->
	NowTime = util_date:unixtime(),
	Fun = fun(Conf, {RefuseList, ShopList, Len, AllLen}) ->
				RefuseDate = Conf#wander_shop_conf.refuse_time,
				{Date, _} = calendar:local_time(),
				RefuseTime = util_date:time_tuple_to_unixtime({Date, RefuseDate}),
				Key = Conf#wander_shop_conf.key,
				Num = Conf#wander_shop_conf.random_num,
				RandomList = Conf#wander_shop_conf.random_list,

				case NowTime >= RefuseTime of
					true ->
						RefuseList1 = [{Key, RefuseTime + ?DAY_TIME_COUNT}] ++ RefuseList,
						SList = Conf#wander_shop_conf.shop_list,
						ShopList1 = SList ++ util_rand:weight_rand_2(Num, RandomList),
						{RefuseList1, ShopList1, Len + 1, AllLen};
					false ->
						RefuseList1 = [{Key, RefuseTime}] ++ RefuseList,
						ShopList1 = case Len == AllLen andalso ShopList == [] of
										true ->
											SList = Conf#wander_shop_conf.shop_list,
											SList ++ util_rand:weight_rand_2(Num, RandomList);
										false -> ShopList
									end,
						{RefuseList1, ShopList1,  Len + 1, AllLen}
				end
		  end,
	{RTList, SList, _, _} = lists:foldl(Fun, {[], [], 1, length(wander_shop_config:get_list())}, wander_shop_config:get_list_conf()),

	WanderShopList = get_ets_wander_shop_list(SList),
	EtsWanderShopList = #ets_wander_shop_list
	{
		type = ?SHOP_TYPE_WANDER,
		shop_list = WanderShopList,
		update_time = util_date:unixtime(),
		refuse_list = lists:keysort(2, RTList)
	},
	ets:insert(?ETS_WANDER_SHOP_LIST, EtsWanderShopList),

	change_proto_wander_shop_list(WanderShopList).

get_ets_wander_shop_list(RTList) ->
	Fun = fun({ShopId, LimitCount}) ->
				#ets_wander_shop
				{
					shop_id = ShopId,
					limit_count = LimitCount,
					buy_count = 0
				}
		  end,
	[Fun(X) || X <- RTList].

change_proto_wander_shop_list(ShopList) ->
	Fun = fun(EtsWanderShop) ->
		#proto_wander_shop
		{
			shop_id = EtsWanderShop#ets_wander_shop.shop_id,
			count = EtsWanderShop#ets_wander_shop.limit_count - EtsWanderShop#ets_wander_shop.buy_count
		}
	end,
	[Fun(X)||X <- ShopList].


