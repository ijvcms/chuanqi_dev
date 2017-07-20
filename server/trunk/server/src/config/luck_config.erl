%%%-------------------------------------------------------------------
%%% @author zhengsiying
%%% @doc
%%%		自动生成文件，不要手动修改
%%% @end
%%% Created : 2016/10/12
%%%-------------------------------------------------------------------

-module(luck_config).

-include("common.hrl").
-include("config.hrl").

-compile([export_all]).

get_list_conf() ->
	[ luck_config:get(X) || X <- get_list() ].

get_list() ->
	[-1, -2, -3, -4, -5, -6, -7, -8, -9, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9].

get(-1) ->
	#luck_conf{
		key = -1,
		succ_rate = 10000,
		nor_rate = 0,
		fail_rate = 0,
		max_atk_rate = 0,
		min_atk_rate = 100
	};

get(-2) ->
	#luck_conf{
		key = -2,
		succ_rate = 10000,
		nor_rate = 0,
		fail_rate = 0,
		max_atk_rate = 0,
		min_atk_rate = 500
	};

get(-3) ->
	#luck_conf{
		key = -3,
		succ_rate = 10000,
		nor_rate = 0,
		fail_rate = 0,
		max_atk_rate = 0,
		min_atk_rate = 1000
	};

get(-4) ->
	#luck_conf{
		key = -4,
		succ_rate = 10000,
		nor_rate = 0,
		fail_rate = 0,
		max_atk_rate = 0,
		min_atk_rate = 1500
	};

get(-5) ->
	#luck_conf{
		key = -5,
		succ_rate = 10000,
		nor_rate = 0,
		fail_rate = 0,
		max_atk_rate = 0,
		min_atk_rate = 2300
	};

get(-6) ->
	#luck_conf{
		key = -6,
		succ_rate = 10000,
		nor_rate = 0,
		fail_rate = 0,
		max_atk_rate = 0,
		min_atk_rate = 2600
	};

get(-7) ->
	#luck_conf{
		key = -7,
		succ_rate = 10000,
		nor_rate = 0,
		fail_rate = 0,
		max_atk_rate = 0,
		min_atk_rate = 2900
	};

get(-8) ->
	#luck_conf{
		key = -8,
		succ_rate = 10000,
		nor_rate = 0,
		fail_rate = 0,
		max_atk_rate = 0,
		min_atk_rate = 3500
	};

get(-9) ->
	#luck_conf{
		key = -9,
		succ_rate = 10000,
		nor_rate = 0,
		fail_rate = 0,
		max_atk_rate = 0,
		min_atk_rate = 10000
	};

get(0) ->
	#luck_conf{
		key = 0,
		succ_rate = 10000,
		nor_rate = 0,
		fail_rate = 0,
		max_atk_rate = 0,
		min_atk_rate = 0
	};

get(1) ->
	#luck_conf{
		key = 1,
		succ_rate = 10000,
		nor_rate = 0,
		fail_rate = 0,
		max_atk_rate = 100,
		min_atk_rate = 0
	};

get(2) ->
	#luck_conf{
		key = 2,
		succ_rate = 4000,
		nor_rate = 4000,
		fail_rate = 2000,
		max_atk_rate = 500,
		min_atk_rate = 0
	};

get(3) ->
	#luck_conf{
		key = 3,
		succ_rate = 2000,
		nor_rate = 2000,
		fail_rate = 6000,
		max_atk_rate = 1000,
		min_atk_rate = 0
	};

get(4) ->
	#luck_conf{
		key = 4,
		succ_rate = 500,
		nor_rate = 2000,
		fail_rate = 7500,
		max_atk_rate = 1500,
		min_atk_rate = 0
	};

get(5) ->
	#luck_conf{
		key = 5,
		succ_rate = 300,
		nor_rate = 1000,
		fail_rate = 8700,
		max_atk_rate = 2300,
		min_atk_rate = 0
	};

get(6) ->
	#luck_conf{
		key = 6,
		succ_rate = 100,
		nor_rate = 1500,
		fail_rate = 8400,
		max_atk_rate = 2600,
		min_atk_rate = 0
	};

get(7) ->
	#luck_conf{
		key = 7,
		succ_rate = 100,
		nor_rate = 800,
		fail_rate = 9100,
		max_atk_rate = 2900,
		min_atk_rate = 0
	};

get(8) ->
	#luck_conf{
		key = 8,
		succ_rate = 0,
		nor_rate = 0,
		fail_rate = 10000,
		max_atk_rate = 3500,
		min_atk_rate = 0
	};

get(9) ->
	#luck_conf{
		key = 9,
		succ_rate = 0,
		nor_rate = 10000,
		fail_rate = 0,
		max_atk_rate = 10000,
		min_atk_rate = 0
	};

get(_Key) ->
	?ERR("undefined key from luck_config ~p", [_Key]).