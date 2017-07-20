%%%-------------------------------------------------------------------
%%% @author zhengsiying
%%% @copyright (C) 2015, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 27. 七月 2015 下午2:36
%%%-------------------------------------------------------------------
-module(gen_server2).

-include("common.hrl").
-include("record.hrl").

%% API
-export([
	call/2,
	cast/2,
	apply_async/2,
	apply_sync/2,
	apply_sync/3,
	apply_after/3,
	get/2,
	put/2
]).

%% ====================================================================
%% API functions
%% ====================================================================
call(PlayerId, Msg) when is_integer(PlayerId) ->
	case player_lib:get_player_pid(PlayerId) of
		null ->
			?ERR("not player [~p] pid, msg: ~p", [PlayerId, Msg]),
			{fail, 1};
		Pid ->
			call(Pid, Msg)
	end;
call(Dest, Msg) ->
	gen_server:call(Dest, Msg).

cast(PlayerId, Msg) when is_integer(PlayerId) ->
	case player_lib:get_player_pid(PlayerId) of
		null ->
			?ERR("not player [~p] pid, msg: ~p", [PlayerId, Msg]),
			{fail, 1};
		Pid ->
			cast(Pid, Msg)
	end;
cast(Pid, Msg)  when is_pid(Pid) ->
	gen_server:cast(Pid, Msg);
cast(Dest,  {F}) ->
	gen_server:cast(Dest, {apply_async, {F}}),
	ok;
cast(Dest,  {F, A}) ->
	gen_server:cast(Dest, {apply_async, {F, A}}),
	ok;
cast(Dest,  {M, F, A}) ->
	gen_server:cast(Dest, {apply_async, {M, F, A}}),
	ok;
cast(Dest, Msg) ->
	gen_server:cast(Dest, Msg).

%% 异步
apply_async(Pid, {F}) when is_pid(Pid) ->
	Pid ! {apply_async, {F}},
	ok;
apply_async(Pid, {F, A}) when is_pid(Pid) ->
	Pid ! {apply_async, {F, A}},
	ok;
apply_async(Pid, {M, F, A}) when is_pid(Pid) ->
	Pid ! {apply_async, {M, F, A}},
	ok;
apply_async(_Pid, _) ->
	ok.

%% 同步
apply_sync(Pid, _Mfa) when not is_pid(Pid) ->
	{error, not_pid};
apply_sync(Pid, _Mfa) when self() =:= Pid ->
	{_M, _F, _, _} = hd(tl(erlang:get_stacktrace())),
	{error, self_call};
apply_sync(Pid, {F}) ->
	gen_server:call(Pid, {apply_sync, F});
apply_sync(Pid, {F, A}) ->
	gen_server:call(Pid, {apply_sync, {F, A}});
apply_sync(Pid, {M, F, A}) ->
	gen_server:call(Pid, {apply_sync, {M, F, A}}).

%% 同步
apply_sync(Pid, _Mfa, _TimeOut) when not is_pid(Pid) ->
	{error, not_pid};
apply_sync(Pid, _Mfa, _TimeOut) when self() =:= Pid ->
	{_M, _F, _, _} = hd(tl(erlang:get_stacktrace())),
	{error, self_call};
apply_sync(Pid, {F}, TimeOut) ->
	gen_server:call(Pid, {apply_sync, F}, TimeOut);
apply_sync(Pid, {F, A}, TimeOut) ->
	gen_server:call(Pid, {apply_sync, {F, A}}, TimeOut);
apply_sync(Pid, {M, F, A}, TimeOut) ->
	gen_server:call(Pid, {apply_sync, {M, F, A}}, TimeOut).

%% 在进程中延时执行函数
apply_after(Time, Pid, {F}) ->
	erlang:send_after(Time, Pid, {apply_async, {F}});
apply_after(Time, Pid, {F, A}) ->
	erlang:send_after(Time, Pid, {apply_async, {F, A}});
apply_after(Time, Pid, {M, F, A}) ->
	erlang:send_after(Time, Pid, {apply_async, {M, F, A}}).

get(Pid, Args) ->
	gen_server:call(Pid, {get, Args}).

put(Pid, [Index, Value]) ->
	gen_server:call(Pid, {put, [Index, Value]}).

%% ====================================================================
%% Internal functions
%% ====================================================================
