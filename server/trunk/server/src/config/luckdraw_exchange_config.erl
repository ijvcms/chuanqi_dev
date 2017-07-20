%%%-------------------------------------------------------------------
%%% @author zhengsiying
%%% @doc
%%%		自动生成文件，不要手动修改
%%% @end
%%% Created : 2016/10/12
%%%-------------------------------------------------------------------

-module(luckdraw_exchange_config).

-include("common.hrl").
-include("config.hrl").

-compile([export_all]).

get_list_conf() ->
	[ luckdraw_exchange_config:get(X) || X <- get_list() ].

get_list() ->
	[1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22].

get(1) ->
	#luckdraw_exchange_conf{
		id = 1,
		lv = 1,
		point = 5,
		goods = [{110319,1,1}]
	};

get(2) ->
	#luckdraw_exchange_conf{
		id = 2,
		lv = 1,
		point = 5,
		goods = [{110304,1,1}]
	};

get(3) ->
	#luckdraw_exchange_conf{
		id = 3,
		lv = 1,
		point = 6,
		goods = [{110259,1,10}]
	};

get(4) ->
	#luckdraw_exchange_conf{
		id = 4,
		lv = 1,
		point = 15,
		goods = [{110095,0,6}]
	};

get(5) ->
	#luckdraw_exchange_conf{
		id = 5,
		lv = 1,
		point = 20,
		goods = [{200061,0,1}]
	};

get(6) ->
	#luckdraw_exchange_conf{
		id = 6,
		lv = 1,
		point = 20,
		goods = [{202061,0,1}]
	};

get(7) ->
	#luckdraw_exchange_conf{
		id = 7,
		lv = 1,
		point = 20,
		goods = [{201061,0,1}]
	};

get(8) ->
	#luckdraw_exchange_conf{
		id = 8,
		lv = 1,
		point = 140,
		goods = [{200071,0,1}]
	};

get(9) ->
	#luckdraw_exchange_conf{
		id = 9,
		lv = 1,
		point = 140,
		goods = [{202071,0,1}]
	};

get(10) ->
	#luckdraw_exchange_conf{
		id = 10,
		lv = 1,
		point = 140,
		goods = [{201071,0,1}]
	};

get(11) ->
	#luckdraw_exchange_conf{
		id = 11,
		lv = 1,
		point = 460,
		goods = [{200081,0,1}]
	};

get(12) ->
	#luckdraw_exchange_conf{
		id = 12,
		lv = 1,
		point = 460,
		goods = [{202081,0,1}]
	};

get(13) ->
	#luckdraw_exchange_conf{
		id = 13,
		lv = 1,
		point = 460,
		goods = [{201081,0,1}]
	};

get(14) ->
	#luckdraw_exchange_conf{
		id = 14,
		lv = 1,
		point = 30,
		goods = [{200060,0,1}]
	};

get(15) ->
	#luckdraw_exchange_conf{
		id = 15,
		lv = 1,
		point = 30,
		goods = [{202060,0,1}]
	};

get(16) ->
	#luckdraw_exchange_conf{
		id = 16,
		lv = 1,
		point = 30,
		goods = [{201060,0,1}]
	};

get(17) ->
	#luckdraw_exchange_conf{
		id = 17,
		lv = 1,
		point = 210,
		goods = [{200070,0,1}]
	};

get(18) ->
	#luckdraw_exchange_conf{
		id = 18,
		lv = 1,
		point = 210,
		goods = [{202070,0,1}]
	};

get(19) ->
	#luckdraw_exchange_conf{
		id = 19,
		lv = 1,
		point = 210,
		goods = [{201070,0,1}]
	};

get(20) ->
	#luckdraw_exchange_conf{
		id = 20,
		lv = 1,
		point = 700,
		goods = [{200080,0,1}]
	};

get(21) ->
	#luckdraw_exchange_conf{
		id = 21,
		lv = 1,
		point = 700,
		goods = [{202080,0,1}]
	};

get(22) ->
	#luckdraw_exchange_conf{
		id = 22,
		lv = 1,
		point = 700,
		goods = [{201080,0,1}]
	};

get(_Key) ->
	?ERR("undefined key from luckdraw_exchange_config ~p", [_Key]).