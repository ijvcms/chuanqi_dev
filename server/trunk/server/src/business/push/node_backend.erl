%%%-------------------------------------------------------------------
%%% @author qhb
%%% @copyright (C) 2016, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 20. 七月 2016 下午2:30
%%%-------------------------------------------------------------------
-module(node_backend).

%% API
-export([
	start/0
]).


start() ->
	push_db:init_mysql(),
	ModList = [{misc_timer}, {mod_randseed},{dp_sup}, {push_mod}],
	ok = util:start_mod(permanent, ModList),
	dp_lib:add(dp_push, 10),
	ok.