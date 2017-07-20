%%%-------------------------------------------------------------------
%%% @author zhengsiying
%%% @doc
%%%		自动生成文件，不要手动修改
%%% @end
%%% Created : 2016/10/12
%%%-------------------------------------------------------------------

-module(instance_single_config).

-include("common.hrl").
-include("config.hrl").

-compile([export_all]).

get_list_conf() ->
	[ instance_single_config:get(X) || X <- get_list() ].

get_list() ->
	[1, 2, 3].

get(1) ->
	#instance_single_conf{
		id = 1,
		scene_id = 30001
	};

get(2) ->
	#instance_single_conf{
		id = 2,
		scene_id = 30021
	};

get(3) ->
	#instance_single_conf{
		id = 3,
		scene_id = 30041
	};

get(_Key) ->
	?ERR("undefined key from instance_single_config ~p", [_Key]).