%%%-------------------------------------------------------------------
%%% @author zhengsiying
%%% @copyright (C) 2016, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 14. 三月 2016 上午10:46
%%%-------------------------------------------------------------------
-module(util_sys).

-include("common.hrl").

%% API
-export([
	apply_catch/2,
	apply_catch/3
]).

%% ====================================================================
%% API functions
%% ====================================================================
%% 对调用的函数做catch错误检测
apply_catch(F, A) ->
	try
		erlang:apply(F, A)
	catch
		Err : Info ->
			ErrMsg = io_lib:format("do function ~p/~p err : ~p:~p~n~p", [F, length(A), Err, Info, erlang:get_stacktrace()]),
			Type = io_lib:format("~p",[F]),
			email_mod:send("方法调用错误", ErrMsg, "dev", Type),
			?ERR(ErrMsg, []),
			{fail, Err}
	end.

apply_catch(M, F, A) ->
	try
		erlang:apply(M, F, A)
	catch
		Err : Info ->
			ErrMsg = io_lib:format("do function ~p:~p/~p err : ~p:~p~n~p", [M, F, length(A), Err, Info, erlang:get_stacktrace()]),
			Type = io_lib:format("~p:~p",[M, F]),
			email_mod:send("方法调用错误", ErrMsg, "dev", Type),
			?ERR(ErrMsg, []),
			{fail, Err}
	end.

%% ====================================================================
%% Internal functions
%% ====================================================================
