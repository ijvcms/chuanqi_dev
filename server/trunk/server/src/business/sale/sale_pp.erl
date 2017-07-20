%%%-------------------------------------------------------------------
%%%-------------------------------------------------------------------
%%%-------------------------------------------------------------------
%%% @author yubing
%%% @copyright (C) 2016, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 05. 一月 2016 14:16
%%%-------------------------------------------------------------------
-module(sale_pp).


-include("proto.hrl").
-include("record.hrl").
-include("common.hrl").
-include("cache.hrl").
%% API
-export([handle/3]).

%% 获取拍卖的物品信息-类型
handle(33000, PlayerState, Data) ->
	?INFO("33000 ~p", [Data]),
	Page = Data#req_get_sale_goodslist.page,
	Sort1 = Data#req_get_sale_goodslist.sort1,
	Sort2 = Data#req_get_sale_goodslist.sort2,
	Sort3 = Data#req_get_sale_goodslist.sort3,
	Order = Data#req_get_sale_goodslist.order,

	{Data1, Num} = sale_lib:get_sale_goodslist(Sort1, Sort2, Sort3, Page, Order),
	?INFO("33000 ~p ~p", [Data1, Num]),
	net_send:send_to_client(PlayerState#player_state.socket, 33000, #rep_get_sale_goodslist{sale_goods_list = Data1, num = Num});

%% 获取拍卖的物品信息-模糊搜索
handle(33001, PlayerState, Data) ->
	?INFO("33001 ~p", [Data]),
	Name = util_data:to_list(Data#req_get_sale_goodslist_name.name),
	Page = Data#req_get_sale_goodslist_name.page,
	Order = Data#req_get_sale_goodslist_name.order,
	{Data1, Num} = sale_lib:get_sale_goodslist_name(Name, Page, Order),
	net_send:send_to_client(PlayerState#player_state.socket, 33001, #rep_get_sale_goodslist_name{sale_goods_list = Data1, num = Num});

%% 获取玩家上架的物品列表
handle(33002, PlayerState, Data) ->
	?INFO("33002 ~p", [Data]),
	Data1 = sale_lib:get_sale_sell_goodslist(PlayerState),
	net_send:send_to_client(PlayerState#player_state.socket, 33002, #rep_get_sale_sell_goodslist{sale_goods_list = Data1});

%% 玩家查看领取物品信息
handle(33003, PlayerState, Data) ->
	?INFO("33003 ~p", [Data]),
	Data1 = sale_lib:get_player_sale_goods_list(PlayerState),
	net_send:send_to_client(PlayerState#player_state.socket, 33003, #rep_get_player_sale_goods_list{sale_goods_list = Data1});

%% 玩家上架物品
handle(33004, PlayerState, Data) ->
	?INFO("33004 ~p", [Data]),
	BagId = Data#req_add_sale.bag_id,
	GoodsId = Data#req_add_sale.goods_id,
	Num = Data#req_add_sale.num,
	Jade = Data#req_add_sale.jade,
	Hour = Data#req_add_sale.hour,

	{ok, PlayerState1, Result} = sale_lib:add_sale(PlayerState, BagId, GoodsId, Num, Jade, Hour),
	?INFO("33004 result ~p", [Result]),
	net_send:send_to_client(PlayerState#player_state.socket, 33004, #rep_add_sale{result = Result}),
	{ok, PlayerState1};

%% 玩家购买拍卖物品
handle(33005, PlayerState, Data) ->
	?INFO("33005 ~p", [Data]),
	SaleId = Data#req_buy_sale.sale_id,
	{ok, PlayerState1, Result} = sale_lib:buy_sale(PlayerState, SaleId),
	?INFO("33005 RESULT ~p", [Result]),
	net_send:send_to_client(PlayerState#player_state.socket, 33005, #rep_buy_sale{result = Result}),
	{ok, PlayerState1};

%% 物品下架
handle(33006, PlayerState, Data) ->
	?INFO("33006 ~p", [Data]),
	SaleId = Data#req_del_sale.sale_id,
	Result = sale_lib:del_sale(PlayerState, SaleId),
	net_send:send_to_client(PlayerState#player_state.socket, 33006, #rep_del_sale{result = Result});

%% 玩家领取物品
handle(33007, PlayerState, Data) ->
	?INFO("33007 ~p", [Data]),
	Id = Data#req_receive_sale_goods.id,
	{ok, PlayerState1, Result} = sale_lib:receive_sale_goods(PlayerState, Id),
	net_send:send_to_client(PlayerState#player_state.socket, 33007, #rep_receive_sale_goods{result = Result}),
	?INFO("33007 result ~p", [Result]),

	{ok, PlayerState1};

% 获取交易税
handle(33008, PlayerState, Data) ->
	?INFO("33008 ~p", [Data]),
	SaleId = Data#req_get_sale_tax.sale_id,
	%% 获取交易税
	Result = case sale_db:select_row(SaleId) of
				 null ->
					 0;
				 SaleInfo ->
					 sale_lib:get_sale_tax(SaleInfo)
			 end,
	net_send:send_to_client(PlayerState#player_state.socket, 33008, #rep_get_sale_tax{result = Result});

%% 获取出售需要的金币
handle(33009, PlayerState, Data) ->
	?INFO("33009 ~p", [Data]),
	Hour = Data#req_get_sale_sell.hour,
	Result = sale_lib:get_sale_sell(Hour),
	net_send:send_to_client(PlayerState#player_state.socket, 33009, #rep_get_sale_sell{result = Result});

%% 获取领取需要的金币
handle(33010, PlayerState, Data) ->
	?INFO("33010 ~p", [Data]),
	Id = Data#req_get_receive_sale_goods_coin.id,
	{Result, _List, _List1} = sale_lib:get_receive_sale_goods_coin(PlayerState, Id),
	?INFO("33010 111 ~p", [Result]),
	net_send:send_to_client(PlayerState#player_state.socket, 33010, #rep_get_receive_sale_goods_coin{result = Result});

handle(Cmd, PlayerState, Data) ->
	?ERR("not define ~p cmd:~nstate: ~p~ndata: ~p", [Cmd, PlayerState, Data]),
	{ok, PlayerState}.

