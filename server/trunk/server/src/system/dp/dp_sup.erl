%%%-------------------------------------------------------------------
%%% @author qhb
%%% @copyright (C) 2016, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 31. 五月 2016 下午4:07
%%%-------------------------------------------------------------------
-module(dp_sup).
-author("qhb").

-behaviour(supervisor).

%% API
-export([
	start_link/0,
	start_child/1
]).

%% Supervisor callbacks
-export([init/1]).

-define(SERVER, ?MODULE).

%%%===================================================================
%%% API functions
%%%===================================================================

start_child(Args) ->
	{ok, _} = supervisor:start_child(?MODULE,Args),
	ok.

%%--------------------------------------------------------------------
%% @doc
%% Starts the supervisor
%%
%% @end
%%--------------------------------------------------------------------
-spec(start_link() ->
	{ok, Pid :: pid()} | ignore | {error, Reason :: term()}).
start_link() ->
	supervisor:start_link({local, ?SERVER}, ?MODULE, []).

%%%===================================================================
%%% Supervisor callbacks
%%%===================================================================

%%--------------------------------------------------------------------
%% @private
%% @doc
%% Whenever a supervisor is started using supervisor:start_link/[2,3],
%% this function is called by the new process to find out about
%% restart strategy, maximum restart frequency and child
%% specifications.
%%
%% @end
%%--------------------------------------------------------------------
-spec(init(Args :: term()) ->
	{ok, {SupFlags :: {RestartStrategy :: supervisor:strategy(),
		MaxR :: non_neg_integer(), MaxT :: non_neg_integer()},
		[ChildSpec :: supervisor:child_spec()]
	}} |
	ignore |
	{error, Reason :: term()}).
init([]) ->
	AChild = {'dp_mod',{'dp_mod',start_link,[]},
		permanent,2000,worker,['dp_mod']},
	{ok,{{simple_one_for_one,1000,3600}, [AChild]}}.

%%%===================================================================
%%% Internal functions
%%%===================================================================
