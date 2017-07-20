%%%-------------------------------------------------------------------
%%% @author zhengsiying
%%% @doc
%%%		自动生成文件，不要手动修改
%%% @end
%%% Created : 2016/10/12
%%%-------------------------------------------------------------------

-module(self_boss_config).

-include("common.hrl").
-include("config.hrl").

-compile([export_all]).

get_list_conf() ->
	[ self_boss_config:get(X) || X <- get_list() ].

get_list() ->
	[1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18].

get(1) ->
	#self_boss_conf{
		id = 1,
		scene_id = 32001,
		boss_id = 8401
	};

get(2) ->
	#self_boss_conf{
		id = 2,
		scene_id = 32001,
		boss_id = 8408
	};

get(3) ->
	#self_boss_conf{
		id = 3,
		scene_id = 32001,
		boss_id = 8409
	};

get(4) ->
	#self_boss_conf{
		id = 4,
		scene_id = 32001,
		boss_id = 8402
	};

get(5) ->
	#self_boss_conf{
		id = 5,
		scene_id = 32001,
		boss_id = 8403
	};

get(6) ->
	#self_boss_conf{
		id = 6,
		scene_id = 32001,
		boss_id = 8404
	};

get(7) ->
	#self_boss_conf{
		id = 7,
		scene_id = 32002,
		boss_id = 8405
	};

get(8) ->
	#self_boss_conf{
		id = 8,
		scene_id = 32002,
		boss_id = 8406
	};

get(9) ->
	#self_boss_conf{
		id = 9,
		scene_id = 32002,
		boss_id = 8410
	};

get(10) ->
	#self_boss_conf{
		id = 10,
		scene_id = 32002,
		boss_id = 8407
	};

get(11) ->
	#self_boss_conf{
		id = 11,
		scene_id = 32003,
		boss_id = 8411
	};

get(12) ->
	#self_boss_conf{
		id = 12,
		scene_id = 32003,
		boss_id = 8412
	};

get(13) ->
	#self_boss_conf{
		id = 13,
		scene_id = 32004,
		boss_id = 8413
	};

get(14) ->
	#self_boss_conf{
		id = 14,
		scene_id = 32004,
		boss_id = 8414
	};

get(15) ->
	#self_boss_conf{
		id = 15,
		scene_id = 32117,
		boss_id = 8415
	};

get(16) ->
	#self_boss_conf{
		id = 16,
		scene_id = 32117,
		boss_id = 8416
	};

get(17) ->
	#self_boss_conf{
		id = 17,
		scene_id = 32121,
		boss_id = 8528
	};

get(18) ->
	#self_boss_conf{
		id = 18,
		scene_id = 32121,
		boss_id = 8529
	};

get(_Key) ->
	?ERR("undefined key from self_boss_config ~p", [_Key]).