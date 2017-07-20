%%% -------------------------------------------------------------------
%%% Author  : ming
%%% Description : 时间生成器
%%%
%%% Created : 2012-12-2
%%% -------------------------------------------------------------------
-module(misc_timer).
-behaviour(gen_server).
%% --------------------------------------------------------------------
%% Include files
%% --------------------------------------------------------------------

%% --------------------------------------------------------------------
%% External exports
-export([now/0, now_seconds/0, now_milseconds/0, cpu_time/0, start_link/0, start/1, info/0]).

%% gen_server callbacks
-export([init/1, handle_call/3, handle_cast/2, handle_info/2, terminate/2, code_change/3]).

-define(ETS_TIMER, ets_timer).
-define(CLOCK, 100).

%% ====================================================================
%% External functions
%% ====================================================================


now() ->
	[{timer, {Now, _}}] = ets:lookup(?ETS_TIMER, timer),
	Now.

now_seconds() ->
	[{timer, {Now, _}}] = ets:lookup(?ETS_TIMER, timer),
	{MegaSecs, Secs, _MicroSecs} = Now,
	MegaSecs * 1000000 + Secs.

%% 毫秒
now_milseconds() ->
	util_date:longunixtime().

cpu_time() ->
	[{timer, {_, Wallclock_Time_Since_Last_Call}}] = ets:lookup(?ETS_TIMER, timer),
	Wallclock_Time_Since_Last_Call.

info() ->
	[
		ets:info(ets_timer),
		ets:tab2list(ets_timer)
	].

start(Sup) ->
	supervisor:start_child(Sup,
		{misc_timer,
			{misc_timer, start_link, []},
			permanent, brutal_kill, worker, [misc_timer]}).

start_link() ->
	gen_server:start_link({local, ?MODULE}, ?MODULE, [], []).

%% ====================================================================
%% Server functions
%% ====================================================================

%% --------------------------------------------------------------------
%% Function: init/1
%% Description: Initiates the server
%% Returns: {ok, State}          |
%%          {ok, State, Timeout} |
%%          ignore               |
%%          {stop, Reason}
%% --------------------------------------------------------------------
init([]) ->
	process_flag(trap_exit, true),
	ets:new(?ETS_TIMER, [set, protected, named_table]),
	ets:insert(?ETS_TIMER, {timer, {erlang:now(), 0}}),
	erlang:send_after(?CLOCK, self(), {event, clock}),
	{ok, []}.

%% --------------------------------------------------------------------
%% Function: handle_call/3
%% Description: Handling call messages
%% Returns: {reply, Reply, State}          |
%%          {reply, Reply, State, Timeout} |
%%          {noreply, State}               |
%%          {noreply, State, Timeout}      |
%%          {stop, Reason, Reply, State}   | (terminate/2 is called)
%%          {stop, Reason, State}            (terminate/2 is called)
%% --------------------------------------------------------------------
handle_call(_Request, _From, State) ->
	Reply = ok,
	{reply, Reply, State}.

%% --------------------------------------------------------------------
%% Function: handle_cast/2
%% Description: Handling cast messages
%% Returns: {noreply, State}          |
%%          {noreply, State, Timeout} |
%%          {stop, Reason, State}            (terminate/2 is called)
%% --------------------------------------------------------------------
handle_cast(_Msg, State) ->
	{noreply, State}.

%% --------------------------------------------------------------------
%% Function: handle_info/2
%% Description: Handling all non call/cast messages
%% Returns: {noreply, State}          |
%%          {noreply, State, Timeout} |
%%          {stop, Reason, State}            (terminate/2 is called)
%% --------------------------------------------------------------------

handle_info({event, clock}, State) ->
	{_Total_Run_Time, Time_Since_Last_Call} = statistics(runtime),
	ets:insert(?ETS_TIMER, {timer, {erlang:now(), Time_Since_Last_Call}}),
	erlang:send_after(?CLOCK, self(), {event, clock}),
	{noreply, State};

handle_info(_Info, State) ->
	{noreply, State}.

%% --------------------------------------------------------------------
%% Function: terminate/2
%% Description: Shutdown the server
%% Returns: any (ignored by gen_server)
%% --------------------------------------------------------------------
terminate(_Reason, _State) ->
	io:format("~p terminate~n", [?MODULE]),
	ok.

%% --------------------------------------------------------------------
%% Func: code_change/3
%% Purpose: Convert process state when code is changed
%% Returns: {ok, NewState}
%% --------------------------------------------------------------------
code_change(_OldVsn, State, _Extra) ->
	{ok, State}.

%% --------------------------------------------------------------------
%%% Internal functions
%% --------------------------------------------------------------------

