%%%-------------------------------------------------------------------
%%% @author zhengsiying
%%% @doc
%%%		自动生成文件，不要手动修改
%%% @end
%%% Created : 2016/10/12
%%%-------------------------------------------------------------------

-module(equips_baptize_lock_config).

-include("common.hrl").
-include("config.hrl").

-compile([export_all]).

get_list_conf() ->
	[ equips_baptize_lock_config:get(X) || X <- get_list() ].

get_list() ->
	[0, 1, 2, 3, 4, 5].

get(0) ->
	#equips_baptize_lock_conf{
		lock = 0,
		cost = 0
	};

get(1) ->
	#equips_baptize_lock_conf{
		lock = 1,
		cost = 2
	};

get(2) ->
	#equips_baptize_lock_conf{
		lock = 2,
		cost = 4
	};

get(3) ->
	#equips_baptize_lock_conf{
		lock = 3,
		cost = 6
	};

get(4) ->
	#equips_baptize_lock_conf{
		lock = 4,
		cost = 8
	};

get(5) ->
	#equips_baptize_lock_conf{
		lock = 5,
		cost = 10
	};

get(_Key) ->
	?ERR("undefined key from equips_baptize_lock_config ~p", [_Key]).