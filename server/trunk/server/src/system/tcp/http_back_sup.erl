%%%-------------------------------------------------------------------
%%% @author ming
%%% @copyright (C) 2015, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 22. 八月 2014 下午4:14
%%%-------------------------------------------------------------------
-module(http_back_sup).

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

%%--------------------------------------------------------------------
%% @doc
%% Starts the supervisor
%%
%% @end
%%--------------------------------------------------------------------
-spec(start_link() ->
	{ok, Pid :: pid()} | ignore | {error, Reason :: term()}).
start_link() ->
	{ok, Pid} = supervisor:start_link({local, ?MODULE}, ?MODULE, []),
	start_child(Pid),
	{ok, Pid}.

start_child(Server) ->
	supervisor:start_child(Server, []).

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
	BasicSockOpts = [binary, {active, false}, {packet, http_bin}, {reuseaddr, true}],
	Port = config:get_background_port(),
	{ok, LSock} = gen_tcp:listen(Port, BasicSockOpts),

	Server = {http_back, {http_back, start_link, [LSock]},
		temporary, brutal_kill, worker, [http_back]},
	RestartStrategy = {simple_one_for_one, 1000, 3600},
	{ok, {RestartStrategy, [Server]}}.

%%%===================================================================
%%% Internal functions
%%%===================================================================
