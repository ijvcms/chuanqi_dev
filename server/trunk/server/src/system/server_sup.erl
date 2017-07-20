%% Author: Administrator
%% Created: 2012-6-5
%% Description: TODO: Add description to server_sup
-module(server_sup).
-behaviour(supervisor).

%%
%% Include files
%%

%%
%% Exported Functions
%%
-export([init/1, start_child/2, start_child/1, start_link/0]).

%%
%% API Functions
%%

start_link() ->
	supervisor:start_link({local, ?MODULE}, ?MODULE, []).

init([]) ->
	{ok, {
		{one_for_one, 3, 10},
		[]
	}
	}.

start_child(Mod, Args) ->
	{ok, _} = supervisor:start_child(?MODULE,
		{Mod, {Mod, start_link, Args},
			transient, 100, worker, [Mod]}),
	ok.

start_child(Mod) ->
	start_child(Mod, []).

%%
%% Local Functions
%%

