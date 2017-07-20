%% @author qhb
%% @doc @todo Add description to mod_ets_holder_sup.


-module(mod_ets_holder_sup).
-behaviour(supervisor).
-export([init/1]).

%% ====================================================================
%% API functions
%% ====================================================================
-export([
		 start_link/0,
		 start_child/1
		 ]).

start_link() ->
	supervisor:start_link({local, ?MODULE}, ?MODULE, []).

start_child(Args) ->
	{ok, _} = supervisor:start_child(?MODULE,Args),
	ok.


%% ====================================================================
%% Behavioural functions 
%% ====================================================================

%% init/1
%% ====================================================================
%% @doc <a href="http://www.erlang.org/doc/man/supervisor.html#Module:init-1">supervisor:init/1</a>
-spec init(Args :: term()) -> Result when
	Result :: {ok, {SupervisionPolicy, [ChildSpec]}} | ignore,
	SupervisionPolicy :: {RestartStrategy, MaxR :: non_neg_integer(), MaxT :: pos_integer()},
	RestartStrategy :: one_for_all
					 | one_for_one
					 | rest_for_one
					 | simple_one_for_one,
	ChildSpec :: {Id :: term(), StartFunc, RestartPolicy, Type :: worker | supervisor, Modules},
	StartFunc :: {M :: module(), F :: atom(), A :: [term()] | undefined},
	RestartPolicy :: permanent
				   | transient
				   | temporary,
	Modules :: [module()] | dynamic.
%% ====================================================================
init([]) ->
    AChild = {'mod_ets_holder',{'mod_ets_holder',start_link,[]},
	      permanent,2000,worker,['mod_ets_holder']},
    {ok,{{simple_one_for_one,0,1}, [AChild]}}.

%% ====================================================================
%% Internal functions
%% ====================================================================
