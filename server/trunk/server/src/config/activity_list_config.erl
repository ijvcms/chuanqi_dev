%%%-------------------------------------------------------------------
%%% @author zhengsiying
%%% @doc
%%%		自动生成文件，不要手动修改
%%% @end
%%% Created : 2016/10/12
%%%-------------------------------------------------------------------

-module(activity_list_config).

-include("common.hrl").
-include("config.hrl").

-compile([export_all]).

get_list_conf() ->
	[ activity_list_config:get(X) || X <- get_list() ].

get_list() ->
	[101, 102, 103, 104, 105, 107, 108, 201, 202, 203, 204, 205, 206, 207].

get(101) ->
	#activity_list_conf{
		id = 101,
		type = 1,
		is_show_num = 1,
		function_id = 36
	};

get(102) ->
	#activity_list_conf{
		id = 102,
		type = 1,
		is_show_num = 1,
		function_id = 24
	};

get(103) ->
	#activity_list_conf{
		id = 103,
		type = 1,
		is_show_num = 1,
		function_id = 18
	};

get(104) ->
	#activity_list_conf{
		id = 104,
		type = 1,
		is_show_num = 1,
		function_id = 23
	};

get(105) ->
	#activity_list_conf{
		id = 105,
		type = 1,
		is_show_num = 1,
		function_id = 83
	};

get(107) ->
	#activity_list_conf{
		id = 107,
		type = 1,
		is_show_num = 0,
		function_id = 26
	};

get(108) ->
	#activity_list_conf{
		id = 108,
		type = 1,
		is_show_num = 0,
		function_id = 118
	};

get(201) ->
	#activity_list_conf{
		id = 201,
		type = 2,
		is_show_num = 0,
		function_id = 38
	};

get(202) ->
	#activity_list_conf{
		id = 202,
		type = 2,
		is_show_num = 0,
		function_id = 39
	};

get(203) ->
	#activity_list_conf{
		id = 203,
		type = 2,
		is_show_num = 0,
		function_id = 37
	};

get(204) ->
	#activity_list_conf{
		id = 204,
		type = 2,
		is_show_num = 0,
		function_id = 43
	};

get(205) ->
	#activity_list_conf{
		id = 205,
		type = 2,
		is_show_num = 0,
		function_id = 44
	};

get(206) ->
	#activity_list_conf{
		id = 206,
		type = 2,
		is_show_num = 0,
		function_id = 5
	};

get(207) ->
	#activity_list_conf{
		id = 207,
		type = 2,
		is_show_num = 0,
		function_id = 75
	};

get(_Key) ->
	?ERR("undefined key from activity_list_config ~p", [_Key]).