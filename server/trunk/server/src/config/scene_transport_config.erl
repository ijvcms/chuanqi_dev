%%%-------------------------------------------------------------------
%%% @author zhengsiying
%%% @doc
%%%		自动生成文件，不要手动修改
%%% @end
%%% Created : 2016/10/12
%%%-------------------------------------------------------------------

-module(scene_transport_config).

-include("common.hrl").
-include("config.hrl").

-compile([export_all]).

get_list_conf() ->
	[ scene_transport_config:get(X) || X <- get_list() ].

get_list() ->
	[101, 102, 103, 104, 105, 106, 107, 108, 109, 110, 111, 112, 113, 114].

get(101) ->
	#scene_transport_conf{
		key = 101,
		scene_id = 20101,
		x = 52,
		y = 23,
		lv_limit = 1,
		spend_limit = []
	};

get(102) ->
	#scene_transport_conf{
		key = 102,
		scene_id = 20100,
		x = 69,
		y = 58,
		lv_limit = 1,
		spend_limit = []
	};

get(103) ->
	#scene_transport_conf{
		key = 103,
		scene_id = 20015,
		x = 80,
		y = 64,
		lv_limit = 10,
		spend_limit = []
	};

get(104) ->
	#scene_transport_conf{
		key = 104,
		scene_id = 20201,
		x = 8,
		y = 14,
		lv_limit = 1,
		spend_limit = []
	};

get(105) ->
	#scene_transport_conf{
		key = 105,
		scene_id = 20204,
		x = 19,
		y = 15,
		lv_limit = 1,
		spend_limit = []
	};

get(106) ->
	#scene_transport_conf{
		key = 106,
		scene_id = 20401,
		x = 21,
		y = 14,
		lv_limit = 1,
		spend_limit = []
	};

get(107) ->
	#scene_transport_conf{
		key = 107,
		scene_id = 20402,
		x = 24,
		y = 15,
		lv_limit = 1,
		spend_limit = []
	};

get(108) ->
	#scene_transport_conf{
		key = 108,
		scene_id = 20405,
		x = 21,
		y = 14,
		lv_limit = 1,
		spend_limit = []
	};

get(109) ->
	#scene_transport_conf{
		key = 109,
		scene_id = 20406,
		x = 24,
		y = 15,
		lv_limit = 1,
		spend_limit = []
	};

get(110) ->
	#scene_transport_conf{
		key = 110,
		scene_id = 20407,
		x = 22,
		y = 19,
		lv_limit = 1,
		spend_limit = []
	};

get(111) ->
	#scene_transport_conf{
		key = 111,
		scene_id = 20408,
		x = 22,
		y = 19,
		lv_limit = 1,
		spend_limit = []
	};

get(112) ->
	#scene_transport_conf{
		key = 112,
		scene_id = 21000,
		x = 16,
		y = 10,
		lv_limit = 1,
		spend_limit = []
	};

get(113) ->
	#scene_transport_conf{
		key = 113,
		scene_id = 21001,
		x = 16,
		y = 10,
		lv_limit = 1,
		spend_limit = []
	};

get(114) ->
	#scene_transport_conf{
		key = 114,
		scene_id = 21002,
		x = 16,
		y = 10,
		lv_limit = 1,
		spend_limit = []
	};

get(_Key) ->
	?ERR("undefined key from scene_transport_config ~p", [_Key]).