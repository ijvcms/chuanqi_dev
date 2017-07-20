%%%-------------------------------------------------------------------
%%% @author qhb
%%% @copyright (C) 2016, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 15. 六月 2016 上午9:58
%%%-------------------------------------------------------------------
-module(node_restore).

-define(APP, server).

%% API
-export([
	start/0
]).


start() ->
	restore_db:init_mysql(),
	ServerIds = get_source_servers(),
	lists:foreach(fun(ServerId) -> restore_db:connect(ServerId) end, ServerIds),

	ModList = [{misc_timer}, {mod_randseed},{merge_mod}],
	ok = util:start_mod(permanent, ModList),
	ok.

get_source_servers() ->
	case application:get_env(?APP, source_servers) of
		{ok, ServerIds} ->
			ServerIds;
		_ ->
			[]
	end.