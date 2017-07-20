%%%-------------------------------------------------------------------
%%% @author qhb
%%% @copyright (C) 2016, <COMPANY>
%%% @doc
%%% 数据独立线程处理模块
%%% @end
%%% Created : 24. 五月 2016 下午3:33
%%%-------------------------------------------------------------------
-module(dp_mod).
-behaviour(gen_server).
-export([init/1, handle_call/3, handle_cast/2, handle_info/2, terminate/2, code_change/3]).
-include("common.hrl").

%% ====================================================================
%% API functions
%% ====================================================================
-export([
	start_link/1
]).


%% ====================================================================
%% Behavioural functions 
%% ====================================================================
-record(state, {}).

start_link({Type, Index}) ->
	ModName = dp_lib:get_name(Type, Index),
	?INFO("init dp_mode:~p~p",[Type, Index]),
	gen_server:start_link({local, ModName}, ?MODULE, [], []).

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
handle_cast({dp_cast, {M, F, A}}, State) ->
	try
		%%?INFO("dp_cast(~p):~p",[self(), {M, F, A}]),
		erlang:apply(M, F, A)
	catch
	    Err:Reason  ->
			ErrMsg = io_lib:format("dp_cast ~p:~p/~p err : ~p:~p~n~p", [M, F, length(A), Err, Reason, erlang:get_stacktrace()]),
			Type = io_lib:format("~p:~p",[M, F]),
			email_mod:send("数据处理出错", ErrMsg, "dev", Type),
			?ERR("dp_cast error ~p ~p",[Reason, erlang:get_stacktrace()])
	end,
	{noreply, State};
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
handle_info(_Info, State) ->
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


