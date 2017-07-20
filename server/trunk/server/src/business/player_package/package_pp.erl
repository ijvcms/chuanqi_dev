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
-module(package_pp).


-include("proto.hrl").
-include("record.hrl").
-include("common.hrl").
-include("cache.hrl").
%% API
-export([handle/3]).

%% 获取vip信息
handle(31001, PlayerState, _Data) ->
	LvList= package_lib:get_package_list(PlayerState),
	net_send:send_to_client(PlayerState#player_state.socket, 31001, #rep_package_list{lv_list = LvList});

%% 领取奖励
handle(31002, PlayerState, Data) ->
	?INFO("29002 ~p",[Data]),
	Lv=Data#req_reward_package_goods.lv,
	{ok,PlayerState1, Result}=package_lib:reward_package_goods(PlayerState,Lv),
	net_send:send_to_client(PlayerState#player_state.socket, 31002, #rep_reward_package_goods{result = Result}),
	{ok,PlayerState1};

handle(Cmd, PlayerState, Data) ->
	?ERR("not define ~p cmd:~nstate: ~p~ndata: ~p", [Cmd, PlayerState, Data]),
	{ok, PlayerState}.

