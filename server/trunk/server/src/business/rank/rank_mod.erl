%%%-------------------------------------------------------------------
%%% @author tuhujia
%%% @copyright (C) 2016, <COMPANY>
%%% @doc 排行榜进程
%%%
%%% @end
%%% Created : 07. 四月 2016 11:44
%%%-------------------------------------------------------------------
-module(rank_mod).
-behaviour(gen_server).
-export([init/1, handle_call/3, handle_cast/2, handle_info/2, terminate/2, code_change/3]).

-include("common.hrl").
-include("record.hrl").
-include("config.hrl").
-include("rank.hrl").

-define(SERVER, ?MODULE).

%% ====================================================================
%% API functions
%% ====================================================================
-export([
  start_link/0
]).

start_link() ->
  gen_server:start_link({local, ?SERVER}, ?MODULE, [], []).

%% ====================================================================
%% Behavioural functions
%% ====================================================================

%% init/1
%% ====================================================================
%% @doc <a href="http://www.erlang.org/doc/man/gen_server.html#Module:init-1">gen_server:init/1</a>
%% -spec init(Args :: term()) -> Result when
%% 	Result :: {ok, State}
%% 			| {ok, State, Timeout}
%% 			| {ok, State, hibernate}
%% 			| {stop, Reason :: term()}
%% 			| ignore,
%% 	State :: term(),
%% 	Timeout :: non_neg_integer() | infinity.
%% ====================================================================
init([]) ->
  init_ets(),
  {ok, []}.

init_ets() ->
  ets:new(?ETS_RANK_INFO, [named_table, {keypos, #ets_rank_info.key}, public, set, {read_concurrency, true}, {write_concurrency, true}]),
  rank_lib:init_rank(),

%%   Fun = fun(RankFlag) ->
%%     case rank_lib:get_rank_refuse_time(RankFlag) of
%%       skip ->
%%         skip;
%%       Time ->
%%         erlang:send_after(Time, self(), {on_timer, RankFlag})
%%     end
%%   end,
%%   [Fun(X) || X <- ?ACTIVATE_RANKS],
  ok.


%% handle_call/3
%% ====================================================================
%% @doc <a href="http://www.erlang.org/doc/man/gen_server.html#Module:handle_call-3">gen_server:handle_call/3</a>
%% -spec handle_call(Request :: term(), From :: {pid(), Tag :: term()}, State :: term()) -> Result when
%% 	Result :: {reply, Reply, NewState}
%% 			| {reply, Reply, NewState, Timeout}
%% 			| {reply, Reply, NewState, hibernate}
%% 			| {noreply, NewState}
%% 			| {noreply, NewState, Timeout}
%% 			| {noreply, NewState, hibernate}
%% 			| {stop, Reason, Reply, NewState}
%% 			| {stop, Reason, NewState},
%% 	Reply :: term(),
%% 	NewState :: term(),
%% 	Timeout :: non_neg_integer() | infinity,
%% 	Reason :: term().
%% ====================================================================
handle_call(_Request, _From, State) ->
  Reply = ok,
  {reply, Reply, State}.


%% handle_cast/2
%% ====================================================================
%% @doc <a href="http://www.erlang.org/doc/man/gen_server.html#Module:handle_cast-2">gen_server:handle_cast/2</a>
%% -spec handle_cast(Request :: term(), State :: term()) -> Result when
%% 	Result :: {noreply, NewState}
%% 			| {noreply, NewState, Timeout}
%% 			| {noreply, NewState, hibernate}
%% 			| {stop, Reason :: term(), NewState},
%% 	NewState :: term(),
%% 	Timeout :: non_neg_integer() | infinity.
%% ====================================================================
handle_cast(_Msg, State) ->
  {noreply, State}.


%% handle_info/2
%% ====================================================================
%% @doc <a href="http://www.erlang.org/doc/man/gen_server.html#Module:handle_info-2">gen_server:handle_info/2</a>
%% -spec handle_info(Info :: timeout | term(), State :: term()) -> Result when
%% 	Result :: {noreply, NewState}
%% 			| {noreply, NewState, Timeout}
%% 			| {noreply, NewState, hibernate}
%% 			| {stop, Reason :: term(), NewState},
%% 	NewState :: term(),
%% 	Timeout :: non_neg_integer() | infinity.
%% ====================================================================
%% 执行异步apply操作
%% handle_info({on_timer, RankFlag}, State) ->
%%   rank_lib:init_single_rank(RankFlag),
%%   case rank_lib:get_rank_refuse_time(RankFlag) of
%%     skip ->
%%       skip;
%%     Time ->
%%       erlang:send_after(Time, self(), {on_timer, RankFlag})
%%   end,
%%   {noreply, State};
handle_info(_Info, State) ->
  {noreply, State}.


%% terminate/2
%% ====================================================================
%% @doc <a href="http://www.erlang.org/doc/man/gen_server.html#Module:terminate-2">gen_server:terminate/2</a>
%% -spec terminate(Reason, State :: term()) -> Any :: term() when
%% 	Reason :: normal
%% 			| shutdown
%% 			| {shutdown, term()}
%% 			| term().
%% ====================================================================
terminate(_Reason, _State) ->
  ok.


%% code_change/3
%% ====================================================================
%% @doc <a href="http://www.erlang.org/doc/man/gen_server.html#Module:code_change-3">gen_server:code_change/3</a>
%% -spec code_change(OldVsn, State :: term(), Extra :: term()) -> Result when
%% 	Result :: {ok, NewState :: term()} | {error, Reason :: term()},
%% 	OldVsn :: Vsn | {down, Vsn},
%% 	Vsn :: term().
%% ====================================================================
code_change(_OldVsn, State, _Extra) ->
  {ok, State}.


%% ====================================================================
%% Internal functions
%% ====================================================================
