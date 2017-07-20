%%%-------------------------------------------------------------------
%%% @author zhengsiying
%%% @copyright (C) 2015, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 11. 八月 2015 上午11:02
%%%-------------------------------------------------------------------
-module(sale_lib).

-include("common.hrl").
-include("record.hrl").
-include("db_record.hrl").
-include("cache.hrl").
-include("config.hrl").
-include("proto.hrl").
-include("uid.hrl").
-include("language_config.hrl").
-include("gameconfig_config.hrl").
-include("button_tips_config.hrl").
-include("log_type_config.hrl").

-define(PAGENUM, 20).
-define(SALESTATE_TIME, 1).%% 状态 1 已退出，2 出售成功，3 表示已下架，4，以购买
-define(SALESTATE_SELL, 2).%% 状态 1 已退出，2 出售成功，3 表示已下架4，以购买
-define(SALESTATE_DEL, 3).%% 状态 1 已退出，2 出售成功，3 表示已下架4，以购买
-define(SALESTATE_BUY, 4).%% 状态 1 已退出，2 出售成功，3 表示已下架4，以购买

%% API
-export([
	get_sale_goodslist/5,
	get_sale_goodslist_name/3,
	add_sale/6,
	del_sale/2,
	get_player_sale_goods_list/1,
	receive_sale_goods/2,
	get_sale_sell_goodslist/1,
	buy_sale/2,
	get_sale_tax/1,
	get_sale_sell/1,
	do_is_sale_goods/2,
	get_receive_sale_goods_coin/2,
	get_coin_receive_time_out/1,
	get_button_tips/1,
	on_timer/1,
	init/0
]).

init() ->
	gen_server2:apply_after(2000, self(), {?MODULE, on_timer, []}).

on_timer(_State) ->
	try
		Where = lists:concat(["where end_time <=", util_date:unixtime()]),
		Data = sale_db:select_page1(Where, 0, 0),
		F = fun(X) ->
			PlayerSaleInfo = #db_player_sale{
				id = uid_lib:get_uid(?UID_TYPE_PLAYER_SALE),
				player_id = X#db_sale.player_id,
				goods_id = X#db_sale.goods_id,
				state = ?SALESTATE_DEL,
				num = X#db_sale.num,
				stren_lv = X#db_sale.stren_lv,%%
				jade = X#db_sale.jade,
				update_time = util_date:unixtime(),
				extra = X#db_sale.extra,
				soul = X#db_sale.soul, %%--
				secure = X#db_sale.secure
			},
			add_player_sale(X#db_sale.player_id, PlayerSaleInfo),
			sale_db:delete(X#db_sale.sale_id)
		end,
		[F(X) || X <- Data]
	catch
		_ErrInfo:_Info ->
			skip
	end,
	gen_server2:apply_after(600000, self(), {?MODULE, on_timer, []}).


%% 获取拍卖的物品信息-类型
get_sale_goodslist(Sort1, Sort2, Sort3, Page, Order) ->
	SaleSortList = if
					   Sort3 > 0 ->
						   [X#sale_sort_conf.sort3 || X <- sale_sort_config:get_list()
							   , X#sale_sort_conf.sort3 =:= Sort3];
					   Sort2 > 0 ->
						   [X#sale_sort_conf.sort3 || X <- sale_sort_config:get_list()
							   , X#sale_sort_conf.sort2 =:= Sort2];
					   Sort1 > 0 ->
						   [X#sale_sort_conf.sort3 || X <- sale_sort_config:get_list()
							   , X#sale_sort_conf.sort1 =:= Sort1];
					   true ->
						   [X#sale_sort_conf.sort3 || X <- sale_sort_config:get_list()]
				   end,

	case erlang:length(SaleSortList) < 1 of
		true ->
			{[], 0};
		_ ->
			SaleSortList1 = [integer_to_list(X) || X <- SaleSortList],

			%% order 1 升序 0，降序
			Where = case Order of
						1 ->
							lists:concat(["where sale_sort in (", string:join(SaleSortList1, ","), ") order by jade"]);
						_ ->
							lists:concat(["where sale_sort in (", string:join(SaleSortList1, ","), ") order by jade desc"])
					end,
			SaleList = sale_db:select_page(Where, (Page - 1) * ?PAGENUM, Page * ?PAGENUM),

			Data = [get_proto_sale_info(X) || X <- SaleList],
			Num = sale_db:select_page_num(Where),
			{Data, Num}
	end.

%% 获取拍卖的物品信息-模糊搜索
get_sale_goodslist_name(Name, Page, Order) ->
	GoodsIdList = if
					  length(Name) > 0 ->
						  [X#goods_conf.id || X <- goods_config:get_list_conf()
							  , string:rstr(X#goods_conf.name, Name) > 0];
					  true ->
						  [X#goods_conf.id || X <- goods_config:get_list_conf()]
				  end,

	case erlang:length(GoodsIdList) < 1 of
		true ->
			{[], 0};
		_ ->
			GoodsIdList1 = [integer_to_list(X) || X <- GoodsIdList],

			%% order 1 升序 0，降序
			Where = case Order of
						1 ->
							lists:concat(["where goods_id in (", string:join(GoodsIdList1, ","), ") order by jade"]);
						_ ->
							lists:concat(["where goods_id in (", string:join(GoodsIdList1, ","), ") order by jade desc"])
					end,
			SaleList = sale_db:select_page(Where, (Page - 1) * ?PAGENUM, Page * ?PAGENUM),


			Data = [get_proto_sale_info(X) || X <- SaleList],
			Num = sale_db:select_page_num(Where),
			{Data, Num}
	end.


%% 获取玩家上架的物品列表
get_sale_sell_goodslist(PlayerState) ->
	PlayerSellGoodsList = sale_db:select_all(PlayerState#player_state.player_id),
	[get_proto_sale_info(X) || X <- PlayerSellGoodsList].

%% 玩家查看领取物品信息
get_player_sale_goods_list(PlayerState) ->
	PlayerSaleGoodsList = player_sale_cache:select_all(PlayerState#player_state.player_id),
	[get_proto_player_sale_info(X) || X <- PlayerSaleGoodsList].

%% 玩家上架物品
add_sale(PlayerState, BagId, GoodsId, Num, Jade, Hour) ->
	%% 获取玩家的背包信息
	case goods_lib:get_player_goods_info(BagId, GoodsId, true) of %%
		{fail, Err} ->
			{ok, PlayerState, Err};
		GoodsInfo ->
			%% 判断物品是否绑定
			case GoodsInfo#db_goods.is_bind =:= 1 of
				true ->
					{ok, PlayerState, ?ERR_BINDING};
				_ ->
					DBMoney = PlayerState#player_state.db_player_money,
					NeedCoin = get_sale_sell(Hour),
					%% 判断 金币是否足够
					case DBMoney#db_player_money.coin < NeedCoin of
						true ->
							{ok, PlayerState, ?ERR_PLAYER_COIN_NOT_ENOUGH};
						_ ->
							%% 是否已达上架上限
							Where = lists:concat(["where player_id=", PlayerState#player_state.player_id]),
							NowSellNum = sale_db:select_page_num(Where),
							case NowSellNum >= ?GAMECONFIG_SALE_SELL_NUM of
								true ->
									{ok, PlayerState, ?ERR_SALE_SELL_NUM};
								_ ->
									%% 删除物品
									case goods_lib_log:delete_goods_by_id_and_num(PlayerState, BagId, GoodsId, Num, ?LOG_TYPE_SALE_ADD) of
										{ok, PlayerState1} ->
											GoodsConf = goods_config:get(GoodsId),
											SaleInfo = #db_sale{
												sale_id = uid_lib:get_uid(?UID_TYPE_SALE),
												goods_id = GoodsId,
												num = Num,
												jade = Jade,
												begin_time = util_date:unixtime(),
												end_time = util_date:unixtime() + Hour * 3600,
												player_id = PlayerState#player_state.player_id,
												sale_sort = GoodsConf#goods_conf.sale_sort,
												extra = GoodsInfo#db_goods.extra,
												stren_lv = GoodsInfo#db_goods.stren_lv,%%
												soul = GoodsInfo#db_goods.soul, %%--
												secure = GoodsInfo#db_goods.secure
											},
											?INFO("sale ~p", [SaleInfo]),
											sale_db:insert(SaleInfo),
											%% 扣除金币
											{ok, PlayerState2} = player_lib:incval_on_player_money_log(PlayerState1, #db_player_money.coin, -NeedCoin, ?LOG_TYPE_SALE_ADD),
											{ok, PlayerState2, 0};
										{fail, Err} ->
											{ok, PlayerState, Err};
										_ ->
											{ok, PlayerState, ?ERR_BINDING}
									end
							end
					end
			end
	end.

%% 玩家购买拍卖物品
buy_sale(PlayerState, SaleId) ->
	case sale_db:select_row(SaleId) of
		null ->
			{ok, PlayerState, ?ERR_GOODS_NOT_EXIST};
		SaleInfo ->
			%%如果有物品的话
			NeedJade = SaleInfo#db_sale.jade + get_sale_tax(SaleInfo),
			DBMoney = PlayerState#player_state.db_player_money,
			case DBMoney#db_player_money.jade < NeedJade of
				true ->
					%% 如果玩家的元宝不足
					{ok, PlayerState, ?ERR_PLAYER_JADE_NOT_ENOUGH};
				_ ->
					%% 进程判断物品是否存在
					case gen_server2:apply_sync(misc:whereis_name({local, sale_mod}), {?MODULE, do_is_sale_goods, [SaleId]}) of
						{ok, 0} ->
							%% 保存玩家购买的物品信息
							{ok, PlayerState1} = player_lib:incval_on_player_money_log(PlayerState, #db_player_money.jade, -NeedJade, ?LOG_TYPE_SALE_BUY),
							BuySaleInfo = #db_player_sale{
								id = uid_lib:get_uid(?UID_TYPE_PLAYER_SALE),
								player_id = PlayerState#player_state.player_id,
								goods_id = SaleInfo#db_sale.goods_id,
								num = SaleInfo#db_sale.num,
								stren_lv = SaleInfo#db_sale.stren_lv,%%
								jade = SaleInfo#db_sale.jade,
								state = ?SALESTATE_BUY,
								update_time = util_date:unixtime(),
								extra = SaleInfo#db_sale.extra,
								soul = SaleInfo#db_sale.soul, %%--
								secure = SaleInfo#db_sale.secure
							},
							%% 保存出售玩家的 元宝信息
							SellSaleInfo = #db_player_sale{
								id = uid_lib:get_uid(?UID_TYPE_PLAYER_SALE),
								player_id = SaleInfo#db_sale.player_id,
								goods_id = SaleInfo#db_sale.goods_id,
								num = SaleInfo#db_sale.num,
								stren_lv = SaleInfo#db_sale.stren_lv,%%
								jade = SaleInfo#db_sale.jade,
								state = ?SALESTATE_SELL,
								update_time = util_date:unixtime(),
								extra = SaleInfo#db_sale.extra,
								soul = SaleInfo#db_sale.soul, %%--
								secure = SaleInfo#db_sale.secure
							},
							add_player_sale(PlayerState, BuySaleInfo),
							add_player_sale(SaleInfo#db_sale.player_id, SellSaleInfo),
							%% 红点检测
							button_tips_lib:ref_button_tips(PlayerState1, ?BTN_SALE),

							%% 推送红点给出售玩家
							case player_lib:get_player_pid(SaleInfo#db_sale.player_id) of
								null ->
									skip;
								PlayerPid ->
									gen_server2:cast(PlayerPid, {update_button_tips, ?BTN_SALE})
							end,
							%% 日志
							log_lib:log_buy(PlayerState#player_state.player_id, SaleInfo#db_sale.player_id, SaleInfo#db_sale.goods_id, SaleInfo#db_sale.num, NeedJade),

							{ok, PlayerState1, ?ERR_COMMON_SUCCESS};
						{ok, Err} ->
							{ok, PlayerState, Err};
						_ ->
							{ok, PlayerState, ?ERR_GOODS_NOT_EXIST}
					end
			end
	end.

%% 玩家下架物品
del_sale(PlayerState, SaleId) ->
	case sale_db:select_row(SaleId) of
		null ->
			?ERR_NOT_SALE_GOODS;
		SaleInfo ->
			case SaleInfo#db_sale.player_id /= PlayerState#player_state.player_id of
				true ->
					?ERR_NOT_SALE_GOODS;
				_ ->
					%% 判断物品是否存在
					case gen_server2:apply_sync(misc:whereis_name({local, sale_mod}), {?MODULE, do_is_sale_goods, [SaleId]}) of
						{ok, 0} ->
							PlayerSaleInfo = #db_player_sale{
								id = uid_lib:get_uid(?UID_TYPE_PLAYER_SALE),
								player_id = PlayerState#player_state.player_id,
								goods_id = SaleInfo#db_sale.goods_id,
								state = ?SALESTATE_DEL,
								num = SaleInfo#db_sale.num,
								stren_lv = SaleInfo#db_sale.stren_lv,%%
								jade = SaleInfo#db_sale.jade,
								update_time = util_date:unixtime(),
								extra = SaleInfo#db_sale.extra,
								soul = SaleInfo#db_sale.soul, %%--
								secure = SaleInfo#db_sale.secure
							},
							add_player_sale(PlayerState, PlayerSaleInfo),
							%% 红点检测
							button_tips_lib:ref_button_tips(PlayerState, ?BTN_SALE),
							?ERR_COMMON_SUCCESS;
						{ok, Err} ->
							Err;
						_ ->
							?ERR_GOODS_NOT_EXIST
					end
			end
	end.

%% 玩家领取物品
receive_sale_goods(PlayerState, SaleId) ->

	%% 需要多少金币
	{NeedCoin, GoodsList, PlayerSaleList} = get_receive_sale_goods_coin(PlayerState, SaleId),
	?INFO("25666 ~p", [GoodsList]),
	DBMoney = PlayerState#player_state.db_player_money,
	case DBMoney#db_player_money.coin < NeedCoin of
		true ->
			{ok, PlayerState, ?ERR_PLAYER_COIN_NOT_ENOUGH};
		_ ->
			%% 添加物品列表
			case goods_lib_log:add_goods_list_by_goods_info(PlayerState, GoodsList, ?LOG_TYPE_SALE_RECEIVE) of
				{fail, Err} ->
					{ok, PlayerState, Err};
				{ok, PlayerState2} ->
					%% 删除领取列表信息
					F = fun(X) ->
						player_sale_cache:delete(X#db_player_sale.id, X#db_player_sale.player_id)
					end,
					[F(X) || X <- PlayerSaleList],

					%% 红点检测
					button_tips_lib:ref_button_tips(PlayerState2, ?BTN_SALE),

					if
						NeedCoin > 0 ->
							{ok, PlayerState3} = player_lib:incval_on_player_money_log(PlayerState2, #db_player_money.coin, -NeedCoin, ?LOG_TYPE_SALE_RECEIVE),
							{ok, PlayerState3, ?ERR_COMMON_SUCCESS};
						true ->
							{ok, PlayerState2, ?ERR_COMMON_SUCCESS}
					end;
				_ ->
					{ok, PlayerState, ?ERR_PLAYER_COIN_NOT_ENOUGH}
			end
	end.

%% *************************************** 通用判断
add_player_sale(_PlayerId, PlayerSaleInfo) when is_number(_PlayerId) ->
	player_sale_cache:insert(PlayerSaleInfo);
add_player_sale(_PlayerState, PlayerSaleInfo) ->
	player_sale_cache:insert(PlayerSaleInfo).

%% 获取交易税
get_sale_tax(SaleInfo) ->
	TaxNum = trunc(SaleInfo#db_sale.jade * ?GAMECONFIG_SALE_TAX),
	if
		TaxNum < 1 ->
			1;
		TaxNum > 200 ->
			200;
		true ->
			TaxNum
	end.

%% 获取出售需要多少金币
get_sale_sell(HourNum) ->
	HourNum * ?GAMECONFIG_SALE_SELL_TIME.

%% 获取超过时间 需要的金币
get_coin_receive_time_out(PlayerSaleInfo) ->
	%% 领取物品的时间
	Time = ?GAMECONFIG_SALE_EXPIRED_TIME - (util_date:unixtime() - PlayerSaleInfo#db_player_sale.update_time),
	case Time < 1 of
		true ->
			?GAMECONFIG_SALE_RECEIVE_TIME_OUT;
		_ ->
			0
	end.

%% 获取当前所有物品需要的金币 获取的道具，列表信息
get_receive_sale_goods_coin(PlayerState, PlayerSaleId) ->
	case PlayerSaleId =:= 0 of
		true ->
			PlayerSaleList = player_sale_cache:select_all(PlayerState#player_state.player_id),
			F = fun(X, {Sum, List}) ->
				%% 需要金币
				Sum1 = Sum + get_coin_receive_time_out(X),
				%% 获取道具
				GoodsInfo = get_receive_sale_goods_coin1(PlayerState#player_state.player_id, X),
				List1 = [GoodsInfo | List],
				{Sum1, List1}
			end,
			{NeedCoin, GoodsList} = lists:foldr(F, {0, []}, PlayerSaleList),
			{NeedCoin, GoodsList, PlayerSaleList};
		_ ->
			case player_sale_cache:select_row(PlayerSaleId, PlayerState#player_state.player_id) of
				null ->
					{0, [], []};
				PlayerSaleInfo ->
					NeedCoin = get_coin_receive_time_out(PlayerSaleInfo),
					%% 获取道具
					GoodsInfo = get_receive_sale_goods_coin1(PlayerState#player_state.player_id, PlayerSaleInfo),
					{NeedCoin, [GoodsInfo], [PlayerSaleInfo]}
			end
	end.

%% 获取所有的领取的物品信息
get_receive_sale_goods_coin1(PlayerId, PlayerSaleInfo) ->
	case PlayerSaleInfo#db_player_sale.state =:= ?SALESTATE_SELL of
		true ->
			%%如果是出售物品 那么就添加元宝
			#db_goods{
				id = uid_lib:get_uid(?UID_TYPE_PLAYER_GOODS),
				player_id = PlayerId,
				goods_id = ?GOODS_ID_JADE,
				is_bind = 0,
				num = PlayerSaleInfo#db_player_sale.jade
			};
		_ ->
			#db_goods{
				id = uid_lib:get_uid(?UID_TYPE_PLAYER_GOODS),
				player_id = PlayerId,
				goods_id = PlayerSaleInfo#db_player_sale.goods_id,
				is_bind = 0,
				num = PlayerSaleInfo#db_player_sale.num,
				stren_lv = PlayerSaleInfo#db_player_sale.stren_lv,%%
				extra = PlayerSaleInfo#db_player_sale.extra,
				soul = PlayerSaleInfo#db_player_sale.soul, %%--
				secure = PlayerSaleInfo#db_player_sale.secure
			}
	end.


%% 获取proto_sale_info信息
get_proto_sale_info(X) ->
	case goods_lib:check_is_equips_by_id(X#db_sale.goods_id) of
		true ->
			Extra = X#db_sale.extra,
			BaptizeAttrList = equips_baptize:get_equips_baptize_attr(Extra),
			{StarLv, Lv, Exp} = equips_artifact:get_equips_artifact_info(Extra),
			#proto_sale_info{
				sale_id = X#db_sale.sale_id,
				goods_id = X#db_sale.goods_id,
				jade = X#db_sale.jade,
				time = X#db_sale.end_time - util_date:unixtime(),
				num = X#db_sale.num,

				stren_lv = X#db_sale.stren_lv,%%
				soul = X#db_sale.soul, %%--
				secure = X#db_sale.secure,
				baptize_attr_list = goods_util:attr_type_list_changed_proto_list(BaptizeAttrList),
				artifact_exp = Exp,
				artifact_lv = Lv,
				artifact_star = StarLv
			};
		_ ->
			#proto_sale_info{
				sale_id = X#db_sale.sale_id,
				goods_id = X#db_sale.goods_id,
				jade = X#db_sale.jade,
				time = X#db_sale.end_time - util_date:unixtime(),
				num = X#db_sale.num
			}
	end.

%% 获取proto_player_sale_info
get_proto_player_sale_info(X) ->
	case goods_lib:check_is_equips_by_id(X#db_player_sale.goods_id) of
		true ->
			Extra = X#db_player_sale.extra,
			BaptizeAttrList = equips_baptize:get_equips_baptize_attr(Extra),
			{StarLv, Lv, Exp} = equips_artifact:get_equips_artifact_info(Extra),
			#proto_player_sale_info{
				id = X#db_player_sale.id,
				goods_id = X#db_player_sale.goods_id,
				jade = X#db_player_sale.jade,
				num = X#db_player_sale.num,
				time = ?GAMECONFIG_SALE_EXPIRED_TIME - (util_date:unixtime() - X#db_player_sale.update_time),
				state = X#db_player_sale.state,

				stren_lv = X#db_player_sale.stren_lv,%%
				soul = X#db_player_sale.soul,%% --
				secure = X#db_player_sale.secure,
				baptize_attr_list = goods_util:attr_type_list_changed_proto_list(BaptizeAttrList),
				artifact_exp = Exp,
				artifact_lv = Lv,
				artifact_star = StarLv
			};
		_ ->
			#proto_player_sale_info{
				id = X#db_player_sale.id,
				goods_id = X#db_player_sale.goods_id,
				jade = X#db_player_sale.jade,
				num = X#db_player_sale.num,
				time = ?GAMECONFIG_SALE_EXPIRED_TIME - (util_date:unixtime() - X#db_player_sale.update_time),
				state = X#db_player_sale.state
			}
	end.

%% &&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&购买物品
%% 购买拍卖物品判断
do_is_sale_goods(_State, SaleId) ->
	case sale_db:select_row(SaleId) of
		null ->
			{ok, ?ERR_GOODS_NOT_EXIST};
		_ ->
			%% 保存玩家购买的物品信息
			sale_db:delete(SaleId),
			{ok, 0}
	end.

%% 红点提示
get_button_tips(PlayerState) ->
	case sale_lib:get_player_sale_goods_list(PlayerState) of
		[] ->
			{PlayerState, 0};
		List ->
			{PlayerState, length(List)}
	end.

%% %% 获取道具列表中的元宝数量
%% get_jade_goods_num(GoodsList) ->
%% 	case lists:keyfind(?GOODS_ID_JADE, 1, GoodsList) of
%% 		{_, _, Jade} ->
%% 			Jade;
%% 		_ ->
%% 			0
%% 	end.
