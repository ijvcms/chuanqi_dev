%%%-------------------------------------------------------------------
%%% @author zhengsiying
%%% @doc
%%%		自动生成文件，不要手动修改
%%% @end
%%% Created : 2016/10/12
%%%-------------------------------------------------------------------

-module(charge_times_config).

-include("common.hrl").
-include("config.hrl").

-compile([export_all]).

get_list_conf() ->
	[ charge_times_config:get(X) || X <- get_list() ].

get_list() ->
	[1, 2, 3, 4, 5, 6, 7, 8, 9].

get(1) ->
	#charge_times_conf{
		id = 1,
		min_num = 0,
		max_num = 3,
		time = 0
	};

get(2) ->
	#charge_times_conf{
		id = 2,
		min_num = 4,
		max_num = 4,
		time = 300
	};

get(3) ->
	#charge_times_conf{
		id = 3,
		min_num = 5,
		max_num = 5,
		time = 600
	};

get(4) ->
	#charge_times_conf{
		id = 4,
		min_num = 6,
		max_num = 6,
		time = 1800
	};

get(5) ->
	#charge_times_conf{
		id = 5,
		min_num = 7,
		max_num = 7,
		time = 3600
	};

get(6) ->
	#charge_times_conf{
		id = 6,
		min_num = 8,
		max_num = 8,
		time = 7200
	};

get(7) ->
	#charge_times_conf{
		id = 7,
		min_num = 9,
		max_num = 9,
		time = 14400
	};

get(8) ->
	#charge_times_conf{
		id = 8,
		min_num = 10,
		max_num = 10,
		time = 28800
	};

get(9) ->
	#charge_times_conf{
		id = 9,
		min_num = 11,
		max_num = 11,
		time = 57600
	};

get(_Key) ->
	?ERR("undefined key from charge_times_config ~p", [_Key]).