%%%-------------------------------------------------------------------
%%% @author zhengsiying
%%% @doc
%%%		自动生成文件，不要手动修改
%%% @end
%%% Created : 2016/10/12
%%%-------------------------------------------------------------------

-module(taskreward_config).

-include("common.hrl").
-include("config.hrl").

-compile([export_all]).

get_list_conf() ->
	[ taskreward_config:get(X) || X <- get_list() ].

get_list() ->
	[1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32, 33, 34, 35, 36, 37, 38, 39, 40, 41, 42, 43, 44, 45, 46, 47, 48, 49, 50].

get(1) ->
	#taskreward_conf{
		id = 1,
		lv = 34,
		need_active = 20,
		goods = [{110009,1,50000}]
	};

get(2) ->
	#taskreward_conf{
		id = 2,
		lv = 34,
		need_active = 40,
		goods = [{110045,1,20}]
	};

get(3) ->
	#taskreward_conf{
		id = 3,
		lv = 34,
		need_active = 60,
		goods = [{110076,1,20},{110077,1,20}]
	};

get(4) ->
	#taskreward_conf{
		id = 4,
		lv = 34,
		need_active = 80,
		goods = [{110065,1,1000}]
	};

get(5) ->
	#taskreward_conf{
		id = 5,
		lv = 34,
		need_active = 100,
		goods = [{110057,1,90000}]
	};

get(6) ->
	#taskreward_conf{
		id = 6,
		lv = 49,
		need_active = 20,
		goods = [{110009,1,50000}]
	};

get(7) ->
	#taskreward_conf{
		id = 7,
		lv = 49,
		need_active = 40,
		goods = [{110045,1,20}]
	};

get(8) ->
	#taskreward_conf{
		id = 8,
		lv = 49,
		need_active = 60,
		goods = [{110076,1,20},{110077,1,20}]
	};

get(9) ->
	#taskreward_conf{
		id = 9,
		lv = 49,
		need_active = 80,
		goods = [{110065,1,1000}]
	};

get(10) ->
	#taskreward_conf{
		id = 10,
		lv = 49,
		need_active = 100,
		goods = [{110057,1,90000}]
	};

get(11) ->
	#taskreward_conf{
		id = 11,
		lv = 60,
		need_active = 20,
		goods = [{110009,1,50000}]
	};

get(12) ->
	#taskreward_conf{
		id = 12,
		lv = 60,
		need_active = 40,
		goods = [{110045,1,20}]
	};

get(13) ->
	#taskreward_conf{
		id = 13,
		lv = 60,
		need_active = 60,
		goods = [{110076,1,20},{110077,1,20}]
	};

get(14) ->
	#taskreward_conf{
		id = 14,
		lv = 60,
		need_active = 80,
		goods = [{110065,1,1000}]
	};

get(15) ->
	#taskreward_conf{
		id = 15,
		lv = 60,
		need_active = 100,
		goods = [{110057,1,120000}]
	};

get(16) ->
	#taskreward_conf{
		id = 16,
		lv = 70,
		need_active = 20,
		goods = [{110009,1,50000}]
	};

get(17) ->
	#taskreward_conf{
		id = 17,
		lv = 70,
		need_active = 40,
		goods = [{110045,1,20}]
	};

get(18) ->
	#taskreward_conf{
		id = 18,
		lv = 70,
		need_active = 60,
		goods = [{110076,1,20},{110077,1,20}]
	};

get(19) ->
	#taskreward_conf{
		id = 19,
		lv = 70,
		need_active = 80,
		goods = [{110065,1,1000}]
	};

get(20) ->
	#taskreward_conf{
		id = 20,
		lv = 70,
		need_active = 100,
		goods = [{110057,1,250000}]
	};

get(21) ->
	#taskreward_conf{
		id = 21,
		lv = 80,
		need_active = 20,
		goods = [{110009,1,50000}]
	};

get(22) ->
	#taskreward_conf{
		id = 22,
		lv = 80,
		need_active = 40,
		goods = [{110045,1,20}]
	};

get(23) ->
	#taskreward_conf{
		id = 23,
		lv = 80,
		need_active = 60,
		goods = [{110076,1,20},{110077,1,20}]
	};

get(24) ->
	#taskreward_conf{
		id = 24,
		lv = 80,
		need_active = 80,
		goods = [{110065,1,1000}]
	};

get(25) ->
	#taskreward_conf{
		id = 25,
		lv = 80,
		need_active = 100,
		goods = [{110057,1,350000}]
	};

get(26) ->
	#taskreward_conf{
		id = 26,
		lv = 90,
		need_active = 20,
		goods = [{110009,1,50000}]
	};

get(27) ->
	#taskreward_conf{
		id = 27,
		lv = 90,
		need_active = 40,
		goods = [{110045,1,20}]
	};

get(28) ->
	#taskreward_conf{
		id = 28,
		lv = 90,
		need_active = 60,
		goods = [{110076,1,20},{110077,1,20}]
	};

get(29) ->
	#taskreward_conf{
		id = 29,
		lv = 90,
		need_active = 80,
		goods = [{110065,1,1000}]
	};

get(30) ->
	#taskreward_conf{
		id = 30,
		lv = 90,
		need_active = 100,
		goods = [{110057,1,450000}]
	};

get(31) ->
	#taskreward_conf{
		id = 31,
		lv = 99,
		need_active = 20,
		goods = [{110009,1,50000}]
	};

get(32) ->
	#taskreward_conf{
		id = 32,
		lv = 99,
		need_active = 40,
		goods = [{110045,1,20}]
	};

get(33) ->
	#taskreward_conf{
		id = 33,
		lv = 99,
		need_active = 60,
		goods = [{110076,1,20},{110077,1,20}]
	};

get(34) ->
	#taskreward_conf{
		id = 34,
		lv = 99,
		need_active = 80,
		goods = [{110065,1,1000}]
	};

get(35) ->
	#taskreward_conf{
		id = 35,
		lv = 99,
		need_active = 100,
		goods = [{110057,1,500000}]
	};

get(36) ->
	#taskreward_conf{
		id = 36,
		lv = 109,
		need_active = 20,
		goods = [{110009,1,50000}]
	};

get(37) ->
	#taskreward_conf{
		id = 37,
		lv = 109,
		need_active = 40,
		goods = [{110045,1,20}]
	};

get(38) ->
	#taskreward_conf{
		id = 38,
		lv = 109,
		need_active = 60,
		goods = [{110076,1,20},{110077,1,20}]
	};

get(39) ->
	#taskreward_conf{
		id = 39,
		lv = 109,
		need_active = 80,
		goods = [{110065,1,1000}]
	};

get(40) ->
	#taskreward_conf{
		id = 40,
		lv = 109,
		need_active = 100,
		goods = [{110057,1,550000}]
	};

get(41) ->
	#taskreward_conf{
		id = 41,
		lv = 120,
		need_active = 20,
		goods = [{110009,1,50000}]
	};

get(42) ->
	#taskreward_conf{
		id = 42,
		lv = 120,
		need_active = 40,
		goods = [{110045,1,20}]
	};

get(43) ->
	#taskreward_conf{
		id = 43,
		lv = 120,
		need_active = 60,
		goods = [{110076,1,20},{110077,1,20}]
	};

get(44) ->
	#taskreward_conf{
		id = 44,
		lv = 120,
		need_active = 80,
		goods = [{110065,1,1000}]
	};

get(45) ->
	#taskreward_conf{
		id = 45,
		lv = 120,
		need_active = 100,
		goods = [{110057,1,600000}]
	};

get(46) ->
	#taskreward_conf{
		id = 46,
		lv = 130,
		need_active = 20,
		goods = [{110009,1,50000}]
	};

get(47) ->
	#taskreward_conf{
		id = 47,
		lv = 130,
		need_active = 40,
		goods = [{110045,1,20}]
	};

get(48) ->
	#taskreward_conf{
		id = 48,
		lv = 130,
		need_active = 60,
		goods = [{110076,1,20},{110077,1,20}]
	};

get(49) ->
	#taskreward_conf{
		id = 49,
		lv = 130,
		need_active = 80,
		goods = [{110065,1,1000}]
	};

get(50) ->
	#taskreward_conf{
		id = 50,
		lv = 130,
		need_active = 100,
		goods = [{110057,1,700000}]
	};

get(_Key) ->
	?ERR("undefined key from taskreward_config ~p", [_Key]).