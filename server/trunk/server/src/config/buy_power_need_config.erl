%%%-------------------------------------------------------------------
%%% @author zhengsiying
%%% @doc
%%%		自动生成文件，不要手动修改
%%% @end
%%% Created : 2016/10/12
%%%-------------------------------------------------------------------

-module(buy_power_need_config).

-include("common.hrl").
-include("config.hrl").

-compile([export_all]).

get_list_conf() ->
	[ buy_power_need_config:get(X) || X <- get_list() ].

get_list() ->
	[1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15].

get(1) ->
	#buy_power_need_conf{
		times = 1,
		need_jade = 20
	};

get(2) ->
	#buy_power_need_conf{
		times = 2,
		need_jade = 20
	};

get(3) ->
	#buy_power_need_conf{
		times = 3,
		need_jade = 20
	};

get(4) ->
	#buy_power_need_conf{
		times = 4,
		need_jade = 20
	};

get(5) ->
	#buy_power_need_conf{
		times = 5,
		need_jade = 20
	};

get(6) ->
	#buy_power_need_conf{
		times = 6,
		need_jade = 20
	};

get(7) ->
	#buy_power_need_conf{
		times = 7,
		need_jade = 20
	};

get(8) ->
	#buy_power_need_conf{
		times = 8,
		need_jade = 20
	};

get(9) ->
	#buy_power_need_conf{
		times = 9,
		need_jade = 20
	};

get(10) ->
	#buy_power_need_conf{
		times = 10,
		need_jade = 20
	};

get(11) ->
	#buy_power_need_conf{
		times = 11,
		need_jade = 20
	};

get(12) ->
	#buy_power_need_conf{
		times = 12,
		need_jade = 20
	};

get(13) ->
	#buy_power_need_conf{
		times = 13,
		need_jade = 20
	};

get(14) ->
	#buy_power_need_conf{
		times = 14,
		need_jade = 20
	};

get(15) ->
	#buy_power_need_conf{
		times = 15,
		need_jade = 20
	};

get(_Key) ->
	?ERR("undefined key from buy_power_need_config ~p", [_Key]).