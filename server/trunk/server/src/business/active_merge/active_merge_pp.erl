%%%-------------------------------------------------------------------
%%% @author tuhujia
%%% @copyright (C) 2016, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 29. 一月 2016 11:51
%%%-------------------------------------------------------------------
-module(active_merge_pp).

-include("common.hrl").
-include("record.hrl").
-include("proto.hrl").
-include("cache.hrl").
-include("config.hrl").
-include("language_config.hrl").
-include("rank.hrl").
-include("log_type_config.hrl").
-include("button_tips_config.hrl").
%% API
-export([
	handle/3
]).

%% ====================================================================
%% API functions
%% ====================================================================


%% 获取合服活动相关列表
handle(38012, PlayerState, #req_active_service_merge_list{type = ActiveServiceType}) ->
	?INFO("38012 11 ~p", [ActiveServiceType]),
	{BeginTime, EndTime, _, ActiveServiceTypeConf} = active_service_merge_lib:get_active_time(ActiveServiceType),
	active_service_merge_lib:ref_button_tips1(PlayerState, ActiveServiceType),
	active_service_merge_lib:send_active_service_info(PlayerState, ActiveServiceTypeConf, BeginTime, EndTime);

%% 领取合服活动奖励
handle(38013, PlayerState, #req_receive_merge_goods{active_service_id = ActiveServiceId}) ->
	?INFO("138013 ~p", [ActiveServiceId]),
	ActiveServiceConf = active_service_merge_config:get(ActiveServiceId),
	case active_service_merge_lib:receive_goods(PlayerState, ActiveServiceConf) of
		{fail, Err} ->
			net_send:send_to_client(PlayerState#player_state.socket, 38013, #rep_receive_merge_goods{result = Err});
		{ok, NewPlayerState} ->
			net_send:send_to_client(PlayerState#player_state.socket, 38013, #rep_receive_merge_goods{result = 0, active_service_id = ActiveServiceId}),
			%% 刷新红点
			active_service_merge_lib:ref_button_tips(NewPlayerState, ActiveServiceConf#active_service_merge_conf.type) %%
	end;


%% 获取开启的活动列表
handle(38019, PlayerState, _Data) ->
	TypeInfoList = active_merge_lib:get_show_active_type_list(),
	?INFO("38019 ~p", [TypeInfoList]),
	net_send:send_to_client(PlayerState#player_state.socket, 38019, #rep_get_active_service_merge_type_list{type_info_list = TypeInfoList});


%% 购买活动商店物品
handle(38042, PlayerState, Data) ->
	#req_buy_active_merge_shop{id = ActiveShopKey} = Data,
	BuyNum = 1,
	case active_shop_merge_lib:buy_mystery_shop(PlayerState, ActiveShopKey, BuyNum) of
		{ok, PlayerState1} ->
			ActiveShopProto = active_shop_merge_lib:get_active_shop_proto(PlayerState1#player_state.player_id, ActiveShopKey),
			Data1 = #rep_buy_active_merge_shop{
				result = ?ERR_COMMON_SUCCESS,
				active_shop_info = ActiveShopProto
			},
			net_send:send_to_client(PlayerState1#player_state.socket, 38042, Data1),
			?INFO("38042 ~p", [Data1]),
			{ok, PlayerState1};
		{fail, Err} ->
			?INFO("38042 ~p", [Err]),
			net_send:send_to_client(PlayerState#player_state.socket, 38042, #rep_buy_active_merge_shop{result = Err});
		Err ->
			?ERR("~p", [Err])
	end;

%% 排行榜红点刷新
handle(38043, PlayerState, Data) ->
	#req_active_service_merge_red{list_id = ListUid} = Data,
	case ListUid of
		?ACTIVE_SERVICE_UI_RANK ->
			button_tips_lib:ref_button_tips(PlayerState, ?BTN_ACTIVE_SERVICE_RANK);
		_ ->
			skip
	end;

handle(Cmd, PlayerState, Data) ->
	?ERR("not define active_pp ~p cmd:~nstate: ~p~ndata: ~p", [Cmd, PlayerState, Data]),
	{ok, PlayerState}.
%% ====================================================================
%% Internal functions
%% ====================================================================
