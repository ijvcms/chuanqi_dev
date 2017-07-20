%%%-------------------------------------------------------------------
%%% @author zhengsiying
%%% @doc
%%%		自动生成文件，不要手动修改
%%% @end
%%% Created : 2016/10/12
%%%-------------------------------------------------------------------

-module(vip_boss_config).

-include("common.hrl").
-include("config.hrl").

-compile([export_all]).

get_list_conf() ->
	[ vip_boss_config:get(X) || X <- get_list() ].

get_list() ->
	[1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18].

get(1) ->
	#vip_boss_conf{
		id = 1,
		scene_id = 32101,
		boss_id = 8501
	};

get(2) ->
	#vip_boss_conf{
		id = 2,
		scene_id = 32101,
		boss_id = 8508
	};

get(3) ->
	#vip_boss_conf{
		id = 3,
		scene_id = 32101,
		boss_id = 8509
	};

get(4) ->
	#vip_boss_conf{
		id = 4,
		scene_id = 32101,
		boss_id = 8502
	};

get(5) ->
	#vip_boss_conf{
		id = 5,
		scene_id = 32101,
		boss_id = 8503
	};

get(6) ->
	#vip_boss_conf{
		id = 6,
		scene_id = 32101,
		boss_id = 8504
	};

get(7) ->
	#vip_boss_conf{
		id = 7,
		scene_id = 32102,
		boss_id = 8505
	};

get(8) ->
	#vip_boss_conf{
		id = 8,
		scene_id = 32102,
		boss_id = 8506
	};

get(9) ->
	#vip_boss_conf{
		id = 9,
		scene_id = 32102,
		boss_id = 8510
	};

get(10) ->
	#vip_boss_conf{
		id = 10,
		scene_id = 32102,
		boss_id = 8507
	};

get(11) ->
	#vip_boss_conf{
		id = 11,
		scene_id = 32103,
		boss_id = 8511
	};

get(12) ->
	#vip_boss_conf{
		id = 12,
		scene_id = 32103,
		boss_id = 8512
	};

get(13) ->
	#vip_boss_conf{
		id = 13,
		scene_id = 32103,
		boss_id = 8513
	};

get(14) ->
	#vip_boss_conf{
		id = 14,
		scene_id = 32103,
		boss_id = 8514
	};

get(15) ->
	#vip_boss_conf{
		id = 15,
		scene_id = 32116,
		boss_id = 8515
	};

get(16) ->
	#vip_boss_conf{
		id = 16,
		scene_id = 32116,
		boss_id = 8516
	};

get(17) ->
	#vip_boss_conf{
		id = 17,
		scene_id = 32116,
		boss_id = 8526
	};

get(18) ->
	#vip_boss_conf{
		id = 18,
		scene_id = 32116,
		boss_id = 8527
	};

get(_Key) ->
	?ERR("undefined key from vip_boss_config ~p", [_Key]).