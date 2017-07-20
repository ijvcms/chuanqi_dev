%%%-------------------------------------------------------------------
%%% @author zhengsiying
%%% @doc
%%%		自动生成文件，不要手动修改
%%% @end
%%% Created : 2016/10/12
%%%-------------------------------------------------------------------

-module(bag_drop_config).

-include("common.hrl").
-include("config.hrl").

-compile([export_all]).

get_list_conf() ->
	[ bag_drop_config:get(X) || X <- get_list() ].

get_list() ->
	[2, 3, 4, 5, 6, 7, 8, 9, 10].

get(2) ->
	#bag_drop_conf{
		id = 2,
		num_min = 1001,
		num_max = 2000,
		weight = 200
	};

get(3) ->
	#bag_drop_conf{
		id = 3,
		num_min = 2001,
		num_max = 3000,
		weight = 200
	};

get(4) ->
	#bag_drop_conf{
		id = 4,
		num_min = 3001,
		num_max = 4000,
		weight = 300
	};

get(5) ->
	#bag_drop_conf{
		id = 5,
		num_min = 4001,
		num_max = 5000,
		weight = 300
	};

get(6) ->
	#bag_drop_conf{
		id = 6,
		num_min = 5001,
		num_max = 6000,
		weight = 300
	};

get(7) ->
	#bag_drop_conf{
		id = 7,
		num_min = 6001,
		num_max = 7000,
		weight = 200
	};

get(8) ->
	#bag_drop_conf{
		id = 8,
		num_min = 7001,
		num_max = 8000,
		weight = 100
	};

get(9) ->
	#bag_drop_conf{
		id = 9,
		num_min = 8001,
		num_max = 9000,
		weight = 50
	};

get(10) ->
	#bag_drop_conf{
		id = 10,
		num_min = 9001,
		num_max = 10000,
		weight = 50
	};

get(_Key) ->
	?ERR("undefined key from bag_drop_config ~p", [_Key]).