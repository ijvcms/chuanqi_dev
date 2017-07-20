%%%-------------------------------------------------------------------
%%% @author tuhujia
%%% @copyright (C) 2016, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 26. 一月 2016 14:43
%%%-------------------------------------------------------------------
-module(charge_pp).

-include("common.hrl").
-include("record.hrl").
-include("proto.hrl").
-include("cache.hrl").
-include("config.hrl").
-include("language_config.hrl").

%% API
-export([
	handle/3
]).

%% ====================================================================
%% API functions
%% ====================================================================

%% 购买充值
handle(30001, PlayerState, Data) ->
	Key= Data#req_buy_charge.key,
	{Result,OrderId,PlayerState1} = charge_lib:buy_charge(PlayerState, Key),
	PayType = config:get_manager_paytype(),
	Rep = #rep_buy_charge{result = Result, order_id = OrderId, pay_type = PayType},
	net_send:send_to_client(PlayerState#player_state.socket, 30001, Rep),
	{ok,PlayerState1};

%% 购买充值
handle(30002, PlayerState, _Data) ->
	?INFO("30002 ~p",[1]),
	List = charge_lib:get_already_buy_charge(PlayerState),
	net_send:send_to_client(PlayerState#player_state.socket, 30002, #rep_get_charge_list{key_list = List});

%% 获取月卡信息
handle(30003, PlayerState, _Data) ->
	{State,OverDay,_} = charge_lib:get_charge_month_info(PlayerState),
	net_send:send_to_client(PlayerState#player_state.socket, 30003, #rep_get_charge_month_info{state = State,over_day = OverDay});

%% 领取奖励
handle(30004, PlayerState, _Data) ->
	case charge_lib:receive_charge_month(PlayerState) of
		{ok,PlayerState1}->
			net_send:send_to_client(PlayerState#player_state.socket, 30004, #rep_receive_charge_month{result = 0}),
			{ok,PlayerState1};
		{fail,Err}->
			net_send:send_to_client(PlayerState#player_state.socket, 30004, #rep_receive_charge_month{result = Err})
	end;

handle(Cmd, PlayerState, Data) ->
	?ERR("not define chat_pp ~p cmd:~nstate: ~p~ndata: ~p", [Cmd, PlayerState, Data]),
	{ok, PlayerState}.
%% ====================================================================
%% Internal functions
%% ====================================================================
