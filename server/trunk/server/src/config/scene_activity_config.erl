%%%-------------------------------------------------------------------
%%% @author zhengsiying
%%% @doc
%%%		自动生成文件，不要手动修改
%%% @end
%%% Created : 2016/10/12
%%%-------------------------------------------------------------------

-module(scene_activity_config).

-include("common.hrl").
-include("config.hrl").

-compile([export_all]).

get_list_conf() ->
	[ scene_activity_config:get(X) || X <- get_list() ].

get_list() ->
	[1, 2].

get(1) ->
	#scene_activity_conf{
		activity_id = 1,
		start_time = {0, 6, {21, 00}, {21, 30}},
		effect = {revive_area, {{90,62},{98,68}}, {{56,18},{62,23}}},
		frist_time = {3, {21, 00}, {21, 30}}
	};

get(2) ->
	#scene_activity_conf{
		activity_id = 2,
		start_time = {0, 6, {21, 00}, {21, 30}},
		effect = [],
		frist_time = {3, {21, 00}, {21, 30}}
	};

get(_Key) ->
	?ERR("undefined key from scene_activity_config ~p", [_Key]).