%%%-------------------------------------------------------------------
%%% @author zhengsiying
%%% @doc
%%%		自动生成文件，不要手动修改
%%% @end
%%% Created : 2016/10/12
%%%-------------------------------------------------------------------

-module(active_instance_config).

-include("common.hrl").
-include("config.hrl").

-compile([export_all]).

get_list_conf() ->
	[ active_instance_config:get(X) || X <- get_list() ].

get_list() ->
	[10, 11, 12, 13, 14, 15, 31002, 31003, 31004, 31005, 32104, 32105, 32106, 32107, 32108, 32109, 32110, 32111, 32112, 32114, 32122, 32123, 32124, 32125].

get(10) ->
	#active_instance_conf{
		key = 10,
		open_type = 1,
		open_week = [1,2,3,4,5,6,7],
		open_time_1 = {11,0,0},
		close_time_1 = {11,30,0},
		open_time_2 = {20,0,0},
		close_time_2 = {20,30,0},
		enter_time_1 = [],
		stop_time_1 = [],
		enter_time_2 = [],
		stop_time_2 = [],
		instance_id = 20224,
		sub_instance_list = [31005]
	};

get(11) ->
	#active_instance_conf{
		key = 11,
		open_type = 1,
		open_week = [1,2,3,4,5,6,7],
		open_time_1 = {18,0,0},
		close_time_1 = {18,30,0},
		open_time_2 = [],
		close_time_2 = [],
		enter_time_1 = [],
		stop_time_1 = [],
		enter_time_2 = [],
		stop_time_2 = [],
		instance_id = 20403,
		sub_instance_list = []
	};

get(12) ->
	#active_instance_conf{
		key = 12,
		open_type = 1,
		open_week = [1,2,3,4,5,6,7],
		open_time_1 = {15,0,0},
		close_time_1 = {15,30,0},
		open_time_2 = [],
		close_time_2 = [],
		enter_time_1 = {15,0,0},
		stop_time_1 = {15,15,0},
		enter_time_2 = [],
		stop_time_2 = [],
		instance_id = 20404,
		sub_instance_list = []
	};

get(13) ->
	#active_instance_conf{
		key = 13,
		open_type = 1,
		open_week = [1,2,3,4,5,6,7],
		open_time_1 = {19,0,0},
		close_time_1 = {19,45,0},
		open_time_2 = [],
		close_time_2 = [],
		enter_time_1 = [],
		stop_time_1 = [],
		enter_time_2 = [],
		stop_time_2 = [],
		instance_id = 22001,
		sub_instance_list = []
	};

get(14) ->
	#active_instance_conf{
		key = 14,
		open_type = 1,
		open_week = [1,2,3,4,5,6,7],
		open_time_1 = {0,0,0},
		close_time_1 = {23,59,59},
		open_time_2 = [],
		close_time_2 = [],
		enter_time_1 = [],
		stop_time_1 = [],
		enter_time_2 = [],
		stop_time_2 = [],
		instance_id = 32001,
		sub_instance_list = []
	};

get(15) ->
	#active_instance_conf{
		key = 15,
		open_type = 1,
		open_week = [1,2,3,4,5,6,7],
		open_time_1 = {17,0,0},
		close_time_1 = {18,0,0},
		open_time_2 = [],
		close_time_2 = [],
		enter_time_1 = [],
		stop_time_1 = [],
		enter_time_2 = [],
		stop_time_2 = [],
		instance_id = [],
		sub_instance_list = []
	};

get(31002) ->
	#active_instance_conf{
		key = 31002,
		open_type = 1,
		open_week = [1,2,3,4,5],
		open_time_1 = {12,0,0},
		close_time_1 = {13,0,0},
		open_time_2 = {23,0,0},
		close_time_2 = {23,59,59},
		enter_time_1 = [],
		stop_time_1 = [],
		enter_time_2 = [],
		stop_time_2 = [],
		instance_id = 31002,
		sub_instance_list = []
	};

get(31003) ->
	#active_instance_conf{
		key = 31003,
		open_type = 1,
		open_week = [1,2,3,4,5],
		open_time_1 = {12,0,0},
		close_time_1 = {13,0,0},
		open_time_2 = {23,0,0},
		close_time_2 = {23,59,59},
		enter_time_1 = [],
		stop_time_1 = [],
		enter_time_2 = [],
		stop_time_2 = [],
		instance_id = 31003,
		sub_instance_list = []
	};

get(31004) ->
	#active_instance_conf{
		key = 31004,
		open_type = 1,
		open_week = [1,2,3,4,5],
		open_time_1 = {12,0,0},
		close_time_1 = {13,0,0},
		open_time_2 = {23,0,0},
		close_time_2 = {23,59,59},
		enter_time_1 = [],
		stop_time_1 = [],
		enter_time_2 = [],
		stop_time_2 = [],
		instance_id = 31004,
		sub_instance_list = []
	};

get(31005) ->
	#active_instance_conf{
		key = 31005,
		open_type = 1,
		open_week = [1,2,3,4,5,6,7],
		open_time_1 = {1,0,0},
		close_time_1 = {23,0,0},
		open_time_2 = [],
		close_time_2 = [],
		enter_time_1 = [],
		stop_time_1 = [],
		enter_time_2 = [],
		stop_time_2 = [],
		instance_id = 31005,
		sub_instance_list = []
	};

get(32104) ->
	#active_instance_conf{
		key = 32104,
		open_type = 1,
		open_week = [1,2,3,4,5,6,7],
		open_time_1 = {11,0,0},
		close_time_1 = {11,30,0},
		open_time_2 = {20,0,0},
		close_time_2 = {20,30,0},
		enter_time_1 = [],
		stop_time_1 = [],
		enter_time_2 = [],
		stop_time_2 = [],
		instance_id = 32104,
		sub_instance_list = [32105]
	};

get(32105) ->
	#active_instance_conf{
		key = 32105,
		open_type = 1,
		open_week = [1,2,3,4,5,6,7],
		open_time_1 = {11,0,0},
		close_time_1 = {11,30,0},
		open_time_2 = {20,0,0},
		close_time_2 = {20,30,0},
		enter_time_1 = [],
		stop_time_1 = [],
		enter_time_2 = [],
		stop_time_2 = [],
		instance_id = 32105,
		sub_instance_list = []
	};

get(32106) ->
	#active_instance_conf{
		key = 32106,
		open_type = 1,
		open_week = [1,2,3,4,5,6,7],
		open_time_1 = {20,0,0},
		close_time_1 = {20,30,0},
		open_time_2 = [],
		close_time_2 = [],
		enter_time_1 = [],
		stop_time_1 = [],
		enter_time_2 = [],
		stop_time_2 = [],
		instance_id = 32106,
		sub_instance_list = []
	};

get(32107) ->
	#active_instance_conf{
		key = 32107,
		open_type = 1,
		open_week = [1,2,3,4,5,7],
		open_time_1 = {20,0,0},
		close_time_1 = {21,0,0},
		open_time_2 = [],
		close_time_2 = [],
		enter_time_1 = [],
		stop_time_1 = [],
		enter_time_2 = [],
		stop_time_2 = [],
		instance_id = 32107,
		sub_instance_list = []
	};

get(32108) ->
	#active_instance_conf{
		key = 32108,
		open_type = 1,
		open_week = [1,2,3,4,5,6,7],
		open_time_1 = {12,0,0},
		close_time_1 = {13,0,0},
		open_time_2 = {23,0,0},
		close_time_2 = {23,59,59},
		enter_time_1 = [],
		stop_time_1 = [],
		enter_time_2 = [],
		stop_time_2 = [],
		instance_id = 32108,
		sub_instance_list = []
	};

get(32109) ->
	#active_instance_conf{
		key = 32109,
		open_type = 1,
		open_week = [6,7],
		open_time_1 = {12,0,0},
		close_time_1 = {13,0,0},
		open_time_2 = {23,0,0},
		close_time_2 = {23,59,59},
		enter_time_1 = [],
		stop_time_1 = [],
		enter_time_2 = [],
		stop_time_2 = [],
		instance_id = 32109,
		sub_instance_list = []
	};

get(32110) ->
	#active_instance_conf{
		key = 32110,
		open_type = 1,
		open_week = [6,7],
		open_time_1 = {12,0,0},
		close_time_1 = {13,0,0},
		open_time_2 = {23,0,0},
		close_time_2 = {23,59,59},
		enter_time_1 = [],
		stop_time_1 = [],
		enter_time_2 = [],
		stop_time_2 = [],
		instance_id = 32110,
		sub_instance_list = []
	};

get(32111) ->
	#active_instance_conf{
		key = 32111,
		open_type = 1,
		open_week = [6,7],
		open_time_1 = {12,0,0},
		close_time_1 = {13,0,0},
		open_time_2 = {23,0,0},
		close_time_2 = {23,59,59},
		enter_time_1 = [],
		stop_time_1 = [],
		enter_time_2 = [],
		stop_time_2 = [],
		instance_id = 32111,
		sub_instance_list = []
	};

get(32112) ->
	#active_instance_conf{
		key = 32112,
		open_type = 1,
		open_week = [1,2,3,4,5,7],
		open_time_1 = {21,0,0},
		close_time_1 = {21,45,0},
		open_time_2 = [],
		close_time_2 = [],
		enter_time_1 = [],
		stop_time_1 = [],
		enter_time_2 = [],
		stop_time_2 = [],
		instance_id = 32112,
		sub_instance_list = []
	};

get(32114) ->
	#active_instance_conf{
		key = 32114,
		open_type = 1,
		open_week = [1,2,3,4,5,7],
		open_time_1 = {21,0,0},
		close_time_1 = {21,45,0},
		open_time_2 = [],
		close_time_2 = [],
		enter_time_1 = [],
		stop_time_1 = [],
		enter_time_2 = [],
		stop_time_2 = [],
		instance_id = 32113,
		sub_instance_list = []
	};

get(32122) ->
	#active_instance_conf{
		key = 32122,
		open_type = 1,
		open_week = [1,2,3,4,5,6,7],
		open_time_1 = {22,0,0},
		close_time_1 = {23,0,0},
		open_time_2 = [],
		close_time_2 = [],
		enter_time_1 = [],
		stop_time_1 = [],
		enter_time_2 = [],
		stop_time_2 = [],
		instance_id = 32122,
		sub_instance_list = []
	};

get(32123) ->
	#active_instance_conf{
		key = 32123,
		open_type = 1,
		open_week = [1,2,3,4,5,6,7],
		open_time_1 = {22,0,0},
		close_time_1 = {23,0,0},
		open_time_2 = [],
		close_time_2 = [],
		enter_time_1 = [],
		stop_time_1 = [],
		enter_time_2 = [],
		stop_time_2 = [],
		instance_id = 32123,
		sub_instance_list = []
	};

get(32124) ->
	#active_instance_conf{
		key = 32124,
		open_type = 1,
		open_week = [1,2,3,4,5,6,7],
		open_time_1 = {22,0,0},
		close_time_1 = {23,0,0},
		open_time_2 = [],
		close_time_2 = [],
		enter_time_1 = [],
		stop_time_1 = [],
		enter_time_2 = [],
		stop_time_2 = [],
		instance_id = 32124,
		sub_instance_list = []
	};

get(32125) ->
	#active_instance_conf{
		key = 32125,
		open_type = 1,
		open_week = [1,2,3,4,5,6,7],
		open_time_1 = {22,0,0},
		close_time_1 = {23,0,0},
		open_time_2 = [],
		close_time_2 = [],
		enter_time_1 = [],
		stop_time_1 = [],
		enter_time_2 = [],
		stop_time_2 = [],
		instance_id = 32125,
		sub_instance_list = []
	};

get(_Key) ->
	 null.