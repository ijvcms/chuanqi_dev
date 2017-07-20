%%%-------------------------------------------------------------------
%%% @author zhengsiying
%%% @doc
%%%		自动生成文件，不要手动修改
%%% @end
%%% Created : 2016/10/12
%%%-------------------------------------------------------------------

-module(instance_dragon_native_config).

-include("common.hrl").
-include("config.hrl").

-compile([export_all]).

get_list_conf() ->
	[ instance_dragon_native_config:get(X) || X <- get_list() ].

get_list() ->
	[1000, 2000, 999999].

get(1000) ->
	#instance_dragon_native_conf{
		id = 1000,
		boss_scene_id = 32108,
		scene_list = [],
		notice_id = 65,
		description = xmerl_ucs:to_utf8("消灭1000只怪，刷新终极BOSS")
	};

get(2000) ->
	#instance_dragon_native_conf{
		id = 2000,
		boss_scene_id = 32108,
		scene_list = [],
		notice_id = 65,
		description = xmerl_ucs:to_utf8("消灭2000只怪，刷新终极BOSS")
	};

get(999999) ->
	#instance_dragon_native_conf{
		id = 999999,
		boss_scene_id = 0,
		scene_list = [],
		notice_id = 0,
		description = xmerl_ucs:to_utf8("大家请尽情刷怪")
	};

get(_Key) ->
	?ERR("undefined key from instance_dragon_native_config ~p", [_Key]).