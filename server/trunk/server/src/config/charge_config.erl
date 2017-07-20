%%%-------------------------------------------------------------------
%%% @author zhengsiying
%%% @doc
%%%		自动生成文件，不要手动修改
%%% @end
%%% Created : 2016/10/12
%%%-------------------------------------------------------------------

-module(charge_config).

-include("common.hrl").
-include("config.hrl").

-compile([export_all]).

get_list_conf() ->
	[ charge_config:get(X) || X <- get_list() ].

get_list() ->
	[1, 2, 3, 4, 5, 6, 7, 8, 9].

get(1) ->
	#charge_conf{
		key = 1,
		jade = 300,
		first_giving = 0,
		common_giving = 0,
		rmb = 30,
		counter_id = 10050,
		time_counter_id = 0,
		month_day = 30,
		month_jade = 100
	};

get(2) ->
	#charge_conf{
		key = 2,
		jade = 60,
		first_giving = 60,
		common_giving = 0,
		rmb = 6,
		counter_id = 10013,
		time_counter_id = 10131,
		month_day = 0,
		month_jade = 0
	};

get(3) ->
	#charge_conf{
		key = 3,
		jade = 250,
		first_giving = 250,
		common_giving = 0,
		rmb = 25,
		counter_id = 10014,
		time_counter_id = 10131,
		month_day = 0,
		month_jade = 0
	};

get(4) ->
	#charge_conf{
		key = 4,
		jade = 680,
		first_giving = 680,
		common_giving = 0,
		rmb = 68,
		counter_id = 10015,
		time_counter_id = 0,
		month_day = 0,
		month_jade = 0
	};

get(5) ->
	#charge_conf{
		key = 5,
		jade = 980,
		first_giving = 980,
		common_giving = 0,
		rmb = 98,
		counter_id = 10016,
		time_counter_id = 0,
		month_day = 0,
		month_jade = 0
	};

get(6) ->
	#charge_conf{
		key = 6,
		jade = 3280,
		first_giving = 3280,
		common_giving = 0,
		rmb = 328,
		counter_id = 10018,
		time_counter_id = 0,
		month_day = 0,
		month_jade = 0
	};

get(7) ->
	#charge_conf{
		key = 7,
		jade = 6480,
		first_giving = 6480,
		common_giving = 0,
		rmb = 648,
		counter_id = 10019,
		time_counter_id = 0,
		month_day = 0,
		month_jade = 0
	};

get(8) ->
	#charge_conf{
		key = 8,
		jade = 19980,
		first_giving = 19980,
		common_giving = 0,
		rmb = 1998,
		counter_id = 10047,
		time_counter_id = 0,
		month_day = 0,
		month_jade = 0
	};

get(9) ->
	#charge_conf{
		key = 9,
		jade = 1980,
		first_giving = 1980,
		common_giving = 0,
		rmb = 198,
		counter_id = 10017,
		time_counter_id = 0,
		month_day = 0,
		month_jade = 0
	};

get(_Key) ->
	?ERR("undefined key from charge_config ~p", [_Key]).