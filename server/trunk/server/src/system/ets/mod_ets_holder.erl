%%%-------------------------------------------------------------------
%%% @author qhb
%%% @doc
%%%	ets缓存挂载进程
%%% @end
%%%-------------------------------------------------------------------

-module(mod_ets_holder).
-behaviour(gen_server).
-include("common.hrl").
-export([init/1, handle_call/3, handle_cast/2, handle_info/2, terminate/2, code_change/3]).

%% ====================================================================
%% API functions
%% ====================================================================
-export([
	start_link/1
]).

%% {configs, ConfigList}
%% {modlib, ModLibList}
start_link(Mode) ->
	gen_server:start_link(?MODULE, [Mode], []).

%% ====================================================================
%% Behavioural functions 
%% ====================================================================
-record(state, {}).

%% init/1
%% ====================================================================
init([Mode]) ->
	?INFO("mod_ets_holder init ~p", [Mode]),
	do_init(Mode),
	{ok, #state{}}.


%% handle_call/3
%% ====================================================================
handle_call(_Request, _From, State) ->
	Reply = ok,
	{reply, Reply, State}.


%% handle_cast/2
%% ====================================================================
handle_cast(_Msg, State) ->
	{noreply, State}.


%% handle_info/2
%% ====================================================================
handle_info(_Info, State) ->
	{noreply, State}.


%% terminate/2
%% ====================================================================
terminate(_Reason, _State) ->
	ok.


%% code_change/3
%% ====================================================================
code_change(_OldVsn, State, _Extra) ->
	{ok, State}.


%% ====================================================================
%% Internal functions
%% ====================================================================


do_init({configs, ConfigList}) ->
	lists:foreach(fun(Cfg) ->
		{EtsName, Option} = Cfg,
		ets:new(EtsName, Option)
	end, ConfigList),
	ok;
do_init({modlib, []}) ->
	ok;
do_init({modlib, [{M} | Last]}) ->
	erlang:apply(M, init_local, []),
	do_init({modlib, Last});
do_init({modlib, [{M, A} | Last]}) ->
	erlang:apply(M, init_local, A),
	do_init({modlib, Last});
do_init({modlib, [{M, F, A} | Last]}) ->
	erlang:apply(M, F, A),
	do_init({modlib, Last});
do_init({modlib, [H | Last]}) ->
	?WARNING("mod_ets_holder error ~p", [H]),
	do_init({modlib, Last}).
