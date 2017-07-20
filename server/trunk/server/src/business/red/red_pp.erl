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
-module(red_pp).


-include("proto.hrl").
-include("record.hrl").
-include("common.hrl").
-include("cache.hrl").
%% API
-export([handle/3]).

%% 领取红包奖励
handle(34000, PlayerState, Data) ->
	?INFO("34000 ~p", [Data]),
	RedId = Data#req_receive_red.red_id,
	case red_lib:receive_red(PlayerState, RedId) of
		{fail, Err} ->
			net_send:send_to_client(PlayerState#player_state.socket, 34000, #rep_receive_red{result = Err});
		{ok, PlayerState1} ->
			{ok, PlayerState1};
		_ ->
			skip
	end;

handle(Cmd, PlayerState, Data) ->
	?ERR("not define ~p cmd:~nstate: ~p~ndata: ~p", [Cmd, PlayerState, Data]),
	{ok, PlayerState}.

