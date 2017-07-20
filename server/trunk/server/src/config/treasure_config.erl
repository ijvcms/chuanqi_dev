%%%-------------------------------------------------------------------
%%% @author zhengsiying
%%% @doc
%%%		自动生成文件，不要手动修改
%%% @end
%%% Created : 2016/10/12
%%%-------------------------------------------------------------------

-module(treasure_config).

-include("common.hrl").
-include("config.hrl").

-compile([export_all]).

get_list_conf() ->
	[ treasure_config:get(X) || X <- get_list() ].

get_list() ->
	[1, 2, 3, 4, 5, 6, 7].

get(1) ->
	#treasure_conf{
		id = 1,
		scene_id = 20001,
		boss_id = 7101
	};

get(2) ->
	#treasure_conf{
		id = 2,
		scene_id = 20001,
		boss_id = 7102
	};

get(3) ->
	#treasure_conf{
		id = 3,
		scene_id = 20001,
		boss_id = 7103
	};

get(4) ->
	#treasure_conf{
		id = 4,
		scene_id = 20001,
		boss_id = 7104
	};

get(5) ->
	#treasure_conf{
		id = 5,
		scene_id = 20001,
		boss_id = 7105
	};

get(6) ->
	#treasure_conf{
		id = 6,
		scene_id = 20008,
		boss_id = 7106
	};

get(7) ->
	#treasure_conf{
		id = 7,
		scene_id = 20009,
		boss_id = 7107
	};

get(_Key) ->
	?ERR("undefined key from treasure_config ~p", [_Key]).