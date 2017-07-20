%%%-------------------------------------------------------------------
%%% @author zhengsiying
%%% @copyright (C) 2015, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 01. 九月 2015 下午8:17
%%%-------------------------------------------------------------------
-module(gen_fsm2).


%% API
-export([
	cancel_timer/1,
	send_event_after/3
]).

%% ====================================================================
%% API functions
%% ====================================================================
cancel_timer(Ref) when is_reference(Ref) ->
	gen_fsm:cancel_timer(Ref);
cancel_timer(_) ->
	ok.

send_event_after(Ref, Time, Event) ->
	cancel_timer(Ref),
	gen_fsm:send_event_after(util_math:ceil(Time), Event).

%% ====================================================================
%% Internal functions
%% ====================================================================
