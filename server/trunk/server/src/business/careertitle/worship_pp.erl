%%%-------------------------------------------------------------------
%%% @author yubing
%%% @copyright (C) 2016, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 06. 一月 2016 15:08
%%%-------------------------------------------------------------------
-module(worship_pp).


-include("proto.hrl").
-include("record.hrl").
-include("common.hrl").
-include("cache.hrl").
%% API
-export([handle/3]).

%%获取各个职业的第一名
handle(27000, PlayerState, _Data) ->
	List=worship_lib:get_worship_first_career_list(),
	net_send:send_to_client(PlayerState#player_state.socket, 27000, #rep_worship_frist_career_list{worship_frist_career_list = List});

%%获取玩家的朝拜信息
handle(27001, PlayerState, _Data) ->
	Info=worship_lib:get_worship_info(PlayerState),
	net_send:send_to_client(PlayerState#player_state.socket, 27001, Info);

%%玩家朝拜
handle(27002, PlayerState, Data) ->
	Is_Jade=Data#req_worship.is_jade,
	{ok,PlayerState1,Result}=worship_lib:worship(PlayerState,Is_Jade),
	net_send:send_to_client(PlayerState#player_state.socket, 27002, #rep_worship{result = Result}),
	{ok,PlayerState1};


handle(Cmd, PlayerState, Data) ->
	?ERR("not define ~p cmd:~nstate: ~p~ndata: ~p", [Cmd, PlayerState, Data]),
	{ok, PlayerState}.

