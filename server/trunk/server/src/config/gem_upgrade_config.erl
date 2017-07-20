%%%-------------------------------------------------------------------
%%% @author zhengsiying
%%% @doc
%%%		自动生成文件，不要手动修改
%%% @end
%%% Created : 2016/10/12
%%%-------------------------------------------------------------------

-module(gem_upgrade_config).

-include("common.hrl").
-include("config.hrl").

-compile([export_all]).

get_list_conf() ->
	[ gem_upgrade_config:get(X) || X <- get_list() ].

get_list() ->
	[10003, 10004, 10005, 10006, 10007, 10008].

get(10003) ->
	#gem_upgrade_conf{
		key = 10003,
		rate = 10000,
		stuff = [{goods, 10003, 2},{coin, 2000}],
		result = 10009
	};

get(10004) ->
	#gem_upgrade_conf{
		key = 10004,
		rate = 10000,
		stuff = [{goods, 10004, 2},{coin, 2000}],
		result = 10010
	};

get(10005) ->
	#gem_upgrade_conf{
		key = 10005,
		rate = 10000,
		stuff = [{goods, 10005, 2},{coin, 2000}],
		result = 10011
	};

get(10006) ->
	#gem_upgrade_conf{
		key = 10006,
		rate = 10000,
		stuff = [{goods, 10006, 2},{coin, 2000}],
		result = 10012
	};

get(10007) ->
	#gem_upgrade_conf{
		key = 10007,
		rate = 10000,
		stuff = [{goods, 10007, 2},{coin, 2000}],
		result = 10013
	};

get(10008) ->
	#gem_upgrade_conf{
		key = 10008,
		rate = 10000,
		stuff = [{goods, 10008, 2},{coin, 2000}],
		result = 10014
	};

get(_Key) ->
	?ERR("undefined key from gem_upgrade_config ~p", [_Key]).