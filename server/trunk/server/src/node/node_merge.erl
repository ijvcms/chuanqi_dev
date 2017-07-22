%%%-------------------------------------------------------------------
%%% @author qhb
%%% @copyright (C) 2016, <COMPANY>
%%% @doc
%%%		合服相关节点
%%% @end
%%% Created : 15. 六月 2016 上午9:58
%%%-------------------------------------------------------------------
-module(node_merge).

%% API
-export([
	start/0
]).

start() ->
	merge_db:init_mysql(),
	ServerIds = merge_cfg:get_source_servers(),
	lists:foreach(fun(ServerId) -> merge_db:connect(ServerId) end, ServerIds),

	ModList = [{misc_timer}, {mod_randseed},{merge_mod}],
	ok = util:start_mod(permanent, ModList),
	ok.