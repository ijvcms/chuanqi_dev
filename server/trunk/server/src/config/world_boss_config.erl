%%%-------------------------------------------------------------------
%%% @author zhengsiying
%%% @doc
%%%		自动生成文件，不要手动修改
%%% @end
%%% Created : 2016/10/12
%%%-------------------------------------------------------------------

-module(world_boss_config).

-include("common.hrl").
-include("config.hrl").

-compile([export_all]).

get_list_conf() ->
	[ world_boss_config:get(X) || X <- get_list() ].

get_list() ->
	[1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18].

get_monsterid_list() ->
	[6900, 6907, 6908, 6901, 6902, 6903, 6904, 6905, 6909, 6906, 6910, 6911, 6912, 6913, 6916, 6917, 6919, 6920].

get(1) ->
	#world_boss_conf{
		id = 1,
		scene_id = 20201,
		boss_id = 6900
	};

get(2) ->
	#world_boss_conf{
		id = 2,
		scene_id = 20207,
		boss_id = 6907
	};

get(3) ->
	#world_boss_conf{
		id = 3,
		scene_id = 20208,
		boss_id = 6908
	};

get(4) ->
	#world_boss_conf{
		id = 4,
		scene_id = 20203,
		boss_id = 6901
	};

get(5) ->
	#world_boss_conf{
		id = 5,
		scene_id = 20206,
		boss_id = 6902
	};

get(6) ->
	#world_boss_conf{
		id = 6,
		scene_id = 20209,
		boss_id = 6903
	};

get(7) ->
	#world_boss_conf{
		id = 7,
		scene_id = 20212,
		boss_id = 6904
	};

get(8) ->
	#world_boss_conf{
		id = 8,
		scene_id = 20215,
		boss_id = 6905
	};

get(9) ->
	#world_boss_conf{
		id = 9,
		scene_id = 20217,
		boss_id = 6909
	};

get(10) ->
	#world_boss_conf{
		id = 10,
		scene_id = 20218,
		boss_id = 6906
	};

get(11) ->
	#world_boss_conf{
		id = 11,
		scene_id = 20235,
		boss_id = 6910
	};

get(12) ->
	#world_boss_conf{
		id = 12,
		scene_id = 20236,
		boss_id = 6911
	};

get(13) ->
	#world_boss_conf{
		id = 13,
		scene_id = 20238,
		boss_id = 6912
	};

get(14) ->
	#world_boss_conf{
		id = 14,
		scene_id = 20239,
		boss_id = 6913
	};

get(15) ->
	#world_boss_conf{
		id = 15,
		scene_id = 20244,
		boss_id = 6916
	};

get(16) ->
	#world_boss_conf{
		id = 16,
		scene_id = 20245,
		boss_id = 6917
	};

get(17) ->
	#world_boss_conf{
		id = 17,
		scene_id = 32119,
		boss_id = 6919
	};

get(18) ->
	#world_boss_conf{
		id = 18,
		scene_id = 32120,
		boss_id = 6920
	};

get(_Key) ->
	 null.