%%%-------------------------------------------------------------------
%%% @author zhengsiying
%%% @doc
%%%		自动生成文件，不要手动修改
%%% @end
%%% Created : 2016/10/12
%%%-------------------------------------------------------------------

-module(instance_dragon_weeken_config).

-include("common.hrl").
-include("config.hrl").

-compile([export_all]).

get_list_conf() ->
	[ instance_dragon_weeken_config:get(X) || X <- get_list() ].

get_list() ->
	[1000, 2000, 3000, 4000, 5000, 6000, 999999].

get(1000) ->
	#instance_dragon_weeken_conf{
		id = 1000,
		boss_scene_id = 32110,
		scene_list = [],
		notice_id = 48,
		description = xmerl_ucs:to_utf8("消灭1000只怪，刷新二层BOSS")
	};

get(2000) ->
	#instance_dragon_weeken_conf{
		id = 2000,
		boss_scene_id = 32111,
		scene_list = [],
		notice_id = 49,
		description = xmerl_ucs:to_utf8("消灭2000只怪，刷新三层BOSS")
	};

get(3000) ->
	#instance_dragon_weeken_conf{
		id = 3000,
		boss_scene_id = 32110,
		scene_list = [],
		notice_id = 50,
		description = xmerl_ucs:to_utf8("消灭3000只怪，刷新二层BOSS")
	};

get(4000) ->
	#instance_dragon_weeken_conf{
		id = 4000,
		boss_scene_id = 32111,
		scene_list = [],
		notice_id = 51,
		description = xmerl_ucs:to_utf8("消灭4000只怪，刷新三层BOSS")
	};

get(5000) ->
	#instance_dragon_weeken_conf{
		id = 5000,
		boss_scene_id = 32110,
		scene_list = [],
		notice_id = 66,
		description = xmerl_ucs:to_utf8("消灭5000只怪，刷新二层BOSS")
	};

get(6000) ->
	#instance_dragon_weeken_conf{
		id = 6000,
		boss_scene_id = 32111,
		scene_list = [],
		notice_id = 67,
		description = xmerl_ucs:to_utf8("消灭6000只怪，刷新三层BOSS")
	};

get(999999) ->
	#instance_dragon_weeken_conf{
		id = 999999,
		boss_scene_id = 0,
		scene_list = [],
		notice_id = 0,
		description = xmerl_ucs:to_utf8("大家请尽情刷怪")
	};

get(_Key) ->
	?ERR("undefined key from instance_dragon_weeken_config ~p", [_Key]).