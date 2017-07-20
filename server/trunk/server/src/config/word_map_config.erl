%%%-------------------------------------------------------------------
%%% @author zhengsiying
%%% @doc
%%%		自动生成文件，不要手动修改
%%% @end
%%% Created : 2016/10/12
%%%-------------------------------------------------------------------

-module(word_map_config).

-include("common.hrl").
-include("config.hrl").

-compile([export_all]).

get_list_conf() ->
	[ word_map_config:get(X) || X <- get_list() ].

get_list() ->
	[1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16].

get(1) ->
	#word_map_conf{
		id = 1,
		scene_id = 20100
	};

get(2) ->
	#word_map_conf{
		id = 2,
		scene_id = 20101
	};

get(3) ->
	#word_map_conf{
		id = 3,
		scene_id = 20102
	};

get(4) ->
	#word_map_conf{
		id = 4,
		scene_id = 20103
	};

get(5) ->
	#word_map_conf{
		id = 5,
		scene_id = 20015
	};

get(6) ->
	#word_map_conf{
		id = 6,
		scene_id = 20105
	};

get(7) ->
	#word_map_conf{
		id = 7,
		scene_id = 20201
	};

get(8) ->
	#word_map_conf{
		id = 8,
		scene_id = 20204
	};

get(9) ->
	#word_map_conf{
		id = 9,
		scene_id = 20207
	};

get(10) ->
	#word_map_conf{
		id = 10,
		scene_id = 20210
	};

get(11) ->
	#word_map_conf{
		id = 11,
		scene_id = 20213
	};

get(12) ->
	#word_map_conf{
		id = 12,
		scene_id = 20216
	};

get(13) ->
	#word_map_conf{
		id = 13,
		scene_id = 20234
	};

get(14) ->
	#word_map_conf{
		id = 14,
		scene_id = 20237
	};

get(15) ->
	#word_map_conf{
		id = 15,
		scene_id = 20243
	};

get(16) ->
	#word_map_conf{
		id = 16,
		scene_id = 32118
	};

get(_Key) ->
	?ERR("undefined key from word_map_config ~p", [_Key]).