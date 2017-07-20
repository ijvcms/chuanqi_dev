%%%-------------------------------------------------------------------
%%% @author zhengsiying
%%% @copyright (C) 2015, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 21. 五月 2015 上午11:09
%%%-------------------------------------------------------------------

-module(db_cache_mod).
-behaviour(gen_server).
-export([init/1, handle_call/3, handle_cast/2, handle_info/2, terminate/2, code_change/3]).

-include("common.hrl").
-include("record.hrl").
-include("cache.hrl").

-define(EACH_FETCH_NUM, 1000).
-define(TIMER_FRAME, 180000). %% mod_cache定时时长

%% ====================================================================
%% API functions
%% ====================================================================
-export([start_link/0]).

%% ====================================================================
%% Behavioural functions 
%% ====================================================================
-record(state, {}).

start_link() ->
	gen_server:start_link({global, ?MODULE}, ?MODULE, [], []).

%% init/1
%% ====================================================================
%% @doc <a href="http://www.erlang.org/doc/man/gen_server.html#Module:init-1">gen_server:init/1</a>
-spec init(Args :: term()) -> Result when
	Result :: {ok, State}
	| {ok, State, Timeout}
	| {ok, State, hibernate}
	| {stop, Reason :: term()}
	| ignore,
	State :: term(),
	Timeout :: non_neg_integer() | infinity.
%% ====================================================================
init([]) ->
	process_flag(trap_exit, true),
	init_data(),
	erlang:send_after(?TIMER_FRAME, self(), {timer}),
	{ok, #state{}}.


%% handle_call/3
%% ====================================================================
%% @doc <a href="http://www.erlang.org/doc/man/gen_server.html#Module:handle_call-3">gen_server:handle_call/3</a>
-spec handle_call(Request :: term(), From :: {pid(), Tag :: term()}, State :: term()) -> Result when
	Result :: {reply, Reply, NewState}
	| {reply, Reply, NewState, Timeout}
	| {reply, Reply, NewState, hibernate}
	| {noreply, NewState}
	| {noreply, NewState, Timeout}
	| {noreply, NewState, hibernate}
	| {stop, Reason, Reply, NewState}
	| {stop, Reason, NewState},
	Reply :: term(),
	NewState :: term(),
	Timeout :: non_neg_integer() | infinity,
	Reason :: term().
%% ====================================================================
handle_call(_Request, _From, State) ->
	Reply = ok,
	{reply, Reply, State}.


%% handle_cast/2
%% ====================================================================
%% @doc <a href="http://www.erlang.org/doc/man/gen_server.html#Module:handle_cast-2">gen_server:handle_cast/2</a>
-spec handle_cast(Request :: term(), State :: term()) -> Result when
	Result :: {noreply, NewState}
	| {noreply, NewState, Timeout}
	| {noreply, NewState, hibernate}
	| {stop, Reason :: term(), NewState},
	NewState :: term(),
	Timeout :: non_neg_integer() | infinity.
%% ====================================================================
handle_cast(_Msg, State) ->
	{noreply, State}.

%% handle_info/2
%% ====================================================================
%% @doc <a href="http://www.erlang.org/doc/man/gen_server.html#Module:handle_info-2">gen_server:handle_info/2</a>
-spec handle_info(Info :: timeout | term(), State :: term()) -> Result when
	Result :: {noreply, NewState}
	| {noreply, NewState, Timeout}
	| {noreply, NewState, hibernate}
	| {stop, Reason :: term(), NewState},
	NewState :: term(),
	Timeout :: non_neg_integer() | infinity.
%% ====================================================================
handle_info(Info, State) ->
	do_info(Info, State),
	{noreply, State}.

%% terminate/2
%% ====================================================================
%% @doc <a href="http://www.erlang.org/doc/man/gen_server.html#Module:terminate-2">gen_server:terminate/2</a>
-spec terminate(Reason, State :: term()) -> Any :: term() when
	Reason :: normal
	| shutdown
	| {shutdown, term()}
	| term().
%% ====================================================================
terminate(_Reason, _State) ->
	io:format("~p terminate~n", [?MODULE]),
	db_cache_lib:save_to_db(),
	ok.

%% code_change/3
%% ====================================================================
%% @doc <a href="http://www.erlang.org/doc/man/gen_server.html#Module:code_change-3">gen_server:code_change/3</a>
-spec code_change(OldVsn, State :: term(), Extra :: term()) -> Result when
	Result :: {ok, NewState :: term()} | {error, Reason :: term()},
	OldVsn :: Vsn | {down, Vsn},
	Vsn :: term().
%% ====================================================================
code_change(_OldVsn, State, _Extra) ->
	{ok, State}.

%% ====================================================================
%% Internal functions
%% ====================================================================
do_info({timer}, State) ->
	%% 定时保存
	db_cache_lib:check_effective(),
	db_cache_lib:save_to_db(),
	erlang:send_after(?TIMER_FRAME, self(), {timer}),
	{noreply, State}.

init_data() ->
	init_ets(),
	ok.

init_ets() ->
	db_cache_lib:init(),
	cache_table:init(),
	%% ets:new(?TAB_TASK, [{keypos, #ets_task.id}, named_table, public, set]),
	ok.
