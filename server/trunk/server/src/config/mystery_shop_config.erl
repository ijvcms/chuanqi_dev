%%%-------------------------------------------------------------------
%%% @author zhengsiying
%%% @doc
%%%		自动生成文件，不要手动修改
%%% @end
%%% Created : 2016/10/12
%%%-------------------------------------------------------------------

-module(mystery_shop_config).

-include("common.hrl").
-include("config.hrl").

-compile([export_all]).

get_list_conf() ->
	[ mystery_shop_config:get(X) || X <- get_list() ].

get_list() ->
	[1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32, 33, 34, 35, 36, 37, 38, 39, 40, 41, 42, 43, 44, 45, 46, 47, 48, 49, 50, 51, 52, 53, 54, 55, 56, 57, 58, 59, 60, 61, 62, 63, 64, 65, 66, 67, 68, 69, 70, 71, 72, 73, 74, 75, 76, 77, 78, 79, 80, 81, 82, 83, 84].

get(1) ->
	#mystery_shop_conf{
		id = 1,
		goods = {110083,1,10},
		curr_type = 1,
		price = 900000,
		weights = 500,
		vip = 0,
		counter_id = 0,
		discount = <<"treasure_surprise">>
	};

get(2) ->
	#mystery_shop_conf{
		id = 2,
		goods = {110088,1,2},
		curr_type = 1,
		price = 3000000,
		weights = 300,
		vip = 2,
		counter_id = 0,
		discount = <<"treasure_surprise">>
	};

get(3) ->
	#mystery_shop_conf{
		id = 3,
		goods = {110003,1,20},
		curr_type = 1,
		price = 3000000,
		weights = 500,
		vip = 0,
		counter_id = 0,
		discount = <<"treasure_surprise">>
	};

get(4) ->
	#mystery_shop_conf{
		id = 4,
		goods = {110054,1,2},
		curr_type = 1,
		price = 3000000,
		weights = 500,
		vip = 0,
		counter_id = 0,
		discount = <<"treasure_surprise">>
	};

get(5) ->
	#mystery_shop_conf{
		id = 5,
		goods = {110089,1,10},
		curr_type = 1,
		price = 3000000,
		weights = 100,
		vip = 3,
		counter_id = 0,
		discount = <<"treasure_surprise">>
	};

get(6) ->
	#mystery_shop_conf{
		id = 6,
		goods = {110013,1,1},
		curr_type = 1,
		price = 900000,
		weights = 300,
		vip = 0,
		counter_id = 0,
		discount = <<"treasure_surprise">>
	};

get(7) ->
	#mystery_shop_conf{
		id = 7,
		goods = {110016,1,1},
		curr_type = 1,
		price = 2400000,
		weights = 300,
		vip = 0,
		counter_id = 0,
		discount = <<"treasure_surprise">>
	};

get(8) ->
	#mystery_shop_conf{
		id = 8,
		goods = {110140,1,5},
		curr_type = 1,
		price = 4500000,
		weights = 300,
		vip = 2,
		counter_id = 0,
		discount = <<"treasure_surprise">>
	};

get(9) ->
	#mystery_shop_conf{
		id = 9,
		goods = {110007,1,50},
		curr_type = 1,
		price = 7500000,
		weights = 500,
		vip = 0,
		counter_id = 0,
		discount = <<"treasure_surprise">>
	};

get(10) ->
	#mystery_shop_conf{
		id = 10,
		goods = {110160,1,20},
		curr_type = 1,
		price = 6000000,
		weights = 300,
		vip = 0,
		counter_id = 0,
		discount = <<"treasure_surprise">>
	};

get(11) ->
	#mystery_shop_conf{
		id = 11,
		goods = {110049,1,5},
		curr_type = 1,
		price = 1500000,
		weights = 700,
		vip = 0,
		counter_id = 0,
		discount = <<"treasure_surprise">>
	};

get(12) ->
	#mystery_shop_conf{
		id = 12,
		goods = {110083,1,50},
		curr_type = 1,
		price = 3600000,
		weights = 300,
		vip = 0,
		counter_id = 0,
		discount = <<"treasure_surprise">>
	};

get(13) ->
	#mystery_shop_conf{
		id = 13,
		goods = {110083,1,10},
		curr_type = 3,
		price = 27,
		weights = 700,
		vip = 0,
		counter_id = 0,
		discount = <<"treasure_10off">>
	};

get(14) ->
	#mystery_shop_conf{
		id = 14,
		goods = {110088,1,2},
		curr_type = 3,
		price = 90,
		weights = 300,
		vip = 2,
		counter_id = 0,
		discount = <<"treasure_10off">>
	};

get(15) ->
	#mystery_shop_conf{
		id = 15,
		goods = {110003,1,20},
		curr_type = 3,
		price = 100,
		weights = 100,
		vip = 0,
		counter_id = 0,
		discount = <<"treasure_surprise">>
	};

get(16) ->
	#mystery_shop_conf{
		id = 16,
		goods = {110054,1,2},
		curr_type = 3,
		price = 90,
		weights = 500,
		vip = 0,
		counter_id = 0,
		discount = <<"treasure_10off">>
	};

get(17) ->
	#mystery_shop_conf{
		id = 17,
		goods = {110089,1,10},
		curr_type = 3,
		price = 100,
		weights = 100,
		vip = 3,
		counter_id = 0,
		discount = <<"treasure_surprise">>
	};

get(18) ->
	#mystery_shop_conf{
		id = 18,
		goods = {110013,1,1},
		curr_type = 3,
		price = 27,
		weights = 500,
		vip = 0,
		counter_id = 0,
		discount = <<"treasure_10off">>
	};

get(19) ->
	#mystery_shop_conf{
		id = 19,
		goods = {110016,1,1},
		curr_type = 3,
		price = 72,
		weights = 500,
		vip = 0,
		counter_id = 0,
		discount = <<"treasure_10off">>
	};

get(20) ->
	#mystery_shop_conf{
		id = 20,
		goods = {110140,1,5},
		curr_type = 3,
		price = 150,
		weights = 300,
		vip = 2,
		counter_id = 0,
		discount = <<"treasure_surprise">>
	};

get(21) ->
	#mystery_shop_conf{
		id = 21,
		goods = {110007,1,50},
		curr_type = 3,
		price = 90,
		weights = 500,
		vip = 0,
		counter_id = 0,
		discount = <<"treasure_10off">>
	};

get(22) ->
	#mystery_shop_conf{
		id = 22,
		goods = {110160,1,20},
		curr_type = 3,
		price = 180,
		weights = 300,
		vip = 0,
		counter_id = 0,
		discount = <<"treasure_10off">>
	};

get(23) ->
	#mystery_shop_conf{
		id = 23,
		goods = {110049,1,5},
		curr_type = 3,
		price = 45,
		weights = 700,
		vip = 0,
		counter_id = 0,
		discount = <<"treasure_10off">>
	};

get(24) ->
	#mystery_shop_conf{
		id = 24,
		goods = {110083,1,50},
		curr_type = 3,
		price = 127,
		weights = 700,
		vip = 0,
		counter_id = 0,
		discount = <<"treasure_15off">>
	};

get(25) ->
	#mystery_shop_conf{
		id = 25,
		goods = {110088,1,10},
		curr_type = 3,
		price = 425,
		weights = 500,
		vip = 2,
		counter_id = 0,
		discount = <<"treasure_15off">>
	};

get(26) ->
	#mystery_shop_conf{
		id = 26,
		goods = {110054,1,10},
		curr_type = 3,
		price = 425,
		weights = 700,
		vip = 0,
		counter_id = 0,
		discount = <<"treasure_15off">>
	};

get(27) ->
	#mystery_shop_conf{
		id = 27,
		goods = {110193,1,50},
		curr_type = 3,
		price = 210,
		weights = 500,
		vip = 0,
		counter_id = 0,
		discount = <<"treasure_15off">>
	};

get(28) ->
	#mystery_shop_conf{
		id = 28,
		goods = {110083,0,10},
		curr_type = 2,
		price = 24,
		weights = 1000,
		vip = 0,
		counter_id = 0,
		discount = <<"treasure_20off">>
	};

get(29) ->
	#mystery_shop_conf{
		id = 29,
		goods = {110088,0,2},
		curr_type = 2,
		price = 80,
		weights = 700,
		vip = 0,
		counter_id = 0,
		discount = <<"treasure_20off">>
	};

get(30) ->
	#mystery_shop_conf{
		id = 30,
		goods = {110003,0,20},
		curr_type = 2,
		price = 80,
		weights = 700,
		vip = 0,
		counter_id = 0,
		discount = <<"treasure_20off">>
	};

get(31) ->
	#mystery_shop_conf{
		id = 31,
		goods = {110054,0,2},
		curr_type = 2,
		price = 80,
		weights = 1000,
		vip = 0,
		counter_id = 0,
		discount = <<"treasure_20off">>
	};

get(32) ->
	#mystery_shop_conf{
		id = 32,
		goods = {110089,0,10},
		curr_type = 2,
		price = 80,
		weights = 700,
		vip = 0,
		counter_id = 0,
		discount = <<"treasure_20off">>
	};

get(33) ->
	#mystery_shop_conf{
		id = 33,
		goods = {110013,0,1},
		curr_type = 2,
		price = 24,
		weights = 500,
		vip = 0,
		counter_id = 0,
		discount = <<"treasure_20off">>
	};

get(34) ->
	#mystery_shop_conf{
		id = 34,
		goods = {110016,0,1},
		curr_type = 2,
		price = 64,
		weights = 500,
		vip = 0,
		counter_id = 0,
		discount = <<"treasure_20off">>
	};

get(35) ->
	#mystery_shop_conf{
		id = 35,
		goods = {110140,0,5},
		curr_type = 2,
		price = 120,
		weights = 700,
		vip = 0,
		counter_id = 0,
		discount = <<"treasure_20off">>
	};

get(36) ->
	#mystery_shop_conf{
		id = 36,
		goods = {110007,0,50},
		curr_type = 2,
		price = 80,
		weights = 1000,
		vip = 4,
		counter_id = 0,
		discount = <<"treasure_20off">>
	};

get(37) ->
	#mystery_shop_conf{
		id = 37,
		goods = {110160,0,20},
		curr_type = 2,
		price = 200,
		weights = 700,
		vip = 4,
		counter_id = 0,
		discount = <<"treasure_surprise">>
	};

get(38) ->
	#mystery_shop_conf{
		id = 38,
		goods = {110109,0,1},
		curr_type = 2,
		price = 1500,
		weights = 500,
		vip = 0,
		counter_id = 0,
		discount = <<"treasure_rare">>
	};

get(39) ->
	#mystery_shop_conf{
		id = 39,
		goods = {110049,0,5},
		curr_type = 2,
		price = 40,
		weights = 1000,
		vip = 0,
		counter_id = 0,
		discount = <<"treasure_20off">>
	};

get(40) ->
	#mystery_shop_conf{
		id = 40,
		goods = {110083,0,50},
		curr_type = 2,
		price = 112,
		weights = 700,
		vip = 0,
		counter_id = 0,
		discount = <<"treasure_25off">>
	};

get(41) ->
	#mystery_shop_conf{
		id = 41,
		goods = {110088,0,10},
		curr_type = 2,
		price = 375,
		weights = 500,
		vip = 0,
		counter_id = 0,
		discount = <<"treasure_25off">>
	};

get(42) ->
	#mystery_shop_conf{
		id = 42,
		goods = {110025,0,1},
		curr_type = 2,
		price = 1500,
		weights = 500,
		vip = 3,
		counter_id = 0,
		discount = <<"treasure_surprise">>
	};

get(43) ->
	#mystery_shop_conf{
		id = 43,
		goods = {110032,0,1},
		curr_type = 2,
		price = 1500,
		weights = 500,
		vip = 3,
		counter_id = 0,
		discount = <<"treasure_surprise">>
	};

get(44) ->
	#mystery_shop_conf{
		id = 44,
		goods = {110040,0,1},
		curr_type = 2,
		price = 1500,
		weights = 500,
		vip = 3,
		counter_id = 0,
		discount = <<"treasure_surprise">>
	};

get(45) ->
	#mystery_shop_conf{
		id = 45,
		goods = {110024,0,1},
		curr_type = 2,
		price = 1500,
		weights = 500,
		vip = 3,
		counter_id = 0,
		discount = <<"treasure_surprise">>
	};

get(46) ->
	#mystery_shop_conf{
		id = 46,
		goods = {110031,0,1},
		curr_type = 2,
		price = 1500,
		weights = 500,
		vip = 3,
		counter_id = 0,
		discount = <<"treasure_surprise">>
	};

get(47) ->
	#mystery_shop_conf{
		id = 47,
		goods = {110067,0,1},
		curr_type = 2,
		price = 1500,
		weights = 500,
		vip = 3,
		counter_id = 0,
		discount = <<"treasure_surprise">>
	};

get(48) ->
	#mystery_shop_conf{
		id = 48,
		goods = {110003,0,300},
		curr_type = 2,
		price = 1125,
		weights = 700,
		vip = 0,
		counter_id = 0,
		discount = <<"treasure_25off">>
	};

get(49) ->
	#mystery_shop_conf{
		id = 49,
		goods = {110054,0,10},
		curr_type = 2,
		price = 375,
		weights = 1000,
		vip = 0,
		counter_id = 0,
		discount = <<"treasure_25off">>
	};

get(50) ->
	#mystery_shop_conf{
		id = 50,
		goods = {110089,0,50},
		curr_type = 2,
		price = 375,
		weights = 700,
		vip = 0,
		counter_id = 0,
		discount = <<"treasure_25off">>
	};

get(51) ->
	#mystery_shop_conf{
		id = 51,
		goods = {110096,0,1},
		curr_type = 2,
		price = 960,
		weights = 300,
		vip = 5,
		counter_id = 0,
		discount = <<"treasure_rare">>
	};

get(52) ->
	#mystery_shop_conf{
		id = 52,
		goods = {110099,0,50},
		curr_type = 2,
		price = 1125,
		weights = 500,
		vip = 6,
		counter_id = 0,
		discount = <<"treasure_25off">>
	};

get(53) ->
	#mystery_shop_conf{
		id = 53,
		goods = {110140,0,50},
		curr_type = 2,
		price = 1125,
		weights = 500,
		vip = 0,
		counter_id = 0,
		discount = <<"treasure_25off">>
	};

get(54) ->
	#mystery_shop_conf{
		id = 54,
		goods = {110193,0,50},
		curr_type = 2,
		price = 187,
		weights = 700,
		vip = 0,
		counter_id = 0,
		discount = <<"treasure_25off">>
	};

get(55) ->
	#mystery_shop_conf{
		id = 55,
		goods = {110007,0,500},
		curr_type = 2,
		price = 750,
		weights = 700,
		vip = 0,
		counter_id = 0,
		discount = <<"treasure_25off">>
	};

get(56) ->
	#mystery_shop_conf{
		id = 56,
		goods = {110160,0,100},
		curr_type = 2,
		price = 900,
		weights = 700,
		vip = 4,
		counter_id = 0,
		discount = <<"treasure_10off">>
	};

get(57) ->
	#mystery_shop_conf{
		id = 57,
		goods = {110109,0,10},
		curr_type = 2,
		price = 9000,
		weights = 500,
		vip = 0,
		counter_id = 0,
		discount = <<"treasure_40off">>
	};

get(58) ->
	#mystery_shop_conf{
		id = 58,
		goods = {110147,0,1},
		curr_type = 2,
		price = 3000,
		weights = 100,
		vip = 8,
		counter_id = 10068,
		discount = <<"treasure_rare">>
	};

get(59) ->
	#mystery_shop_conf{
		id = 59,
		goods = {110049,0,10},
		curr_type = 2,
		price = 75,
		weights = 1000,
		vip = 0,
		counter_id = 0,
		discount = <<"treasure_25off">>
	};

get(60) ->
	#mystery_shop_conf{
		id = 60,
		goods = {110195,0,50000},
		curr_type = 2,
		price = 1320,
		weights = 700,
		vip = 4,
		counter_id = 0,
		discount = <<"treasure_20off">>
	};

get(61) ->
	#mystery_shop_conf{
		id = 61,
		goods = {110196,0,50000},
		curr_type = 2,
		price = 1320,
		weights = 500,
		vip = 4,
		counter_id = 0,
		discount = <<"treasure_20off">>
	};

get(62) ->
	#mystery_shop_conf{
		id = 62,
		goods = {110197,0,50000},
		curr_type = 2,
		price = 1320,
		weights = 1000,
		vip = 4,
		counter_id = 0,
		discount = <<"treasure_20off">>
	};

get(63) ->
	#mystery_shop_conf{
		id = 63,
		goods = {110198,0,50000},
		curr_type = 2,
		price = 1320,
		weights = 1000,
		vip = 4,
		counter_id = 0,
		discount = <<"treasure_20off">>
	};

get(64) ->
	#mystery_shop_conf{
		id = 64,
		goods = {110163,0,5},
		curr_type = 2,
		price = 15000,
		weights = 100,
		vip = 8,
		counter_id = 10066,
		discount = <<"treasure_rare">>
	};

get(65) ->
	#mystery_shop_conf{
		id = 65,
		goods = {305013,0,1},
		curr_type = 2,
		price = 4000,
		weights = 300,
		vip = 6,
		counter_id = 0,
		discount = <<"treasure_rare">>
	};

get(66) ->
	#mystery_shop_conf{
		id = 66,
		goods = {305014,0,1},
		curr_type = 2,
		price = 4000,
		weights = 300,
		vip = 6,
		counter_id = 0,
		discount = <<"treasure_rare">>
	};

get(67) ->
	#mystery_shop_conf{
		id = 67,
		goods = {305015,0,1},
		curr_type = 2,
		price = 4000,
		weights = 300,
		vip = 6,
		counter_id = 0,
		discount = <<"treasure_rare">>
	};

get(68) ->
	#mystery_shop_conf{
		id = 68,
		goods = {305016,0,1},
		curr_type = 2,
		price = 6000,
		weights = 100,
		vip = 6,
		counter_id = 0,
		discount = <<"treasure_rare">>
	};

get(69) ->
	#mystery_shop_conf{
		id = 69,
		goods = {305017,0,1},
		curr_type = 2,
		price = 6000,
		weights = 100,
		vip = 6,
		counter_id = 0,
		discount = <<"treasure_rare">>
	};

get(70) ->
	#mystery_shop_conf{
		id = 70,
		goods = {305018,0,1},
		curr_type = 2,
		price = 6000,
		weights = 100,
		vip = 6,
		counter_id = 0,
		discount = <<"treasure_rare">>
	};

get(71) ->
	#mystery_shop_conf{
		id = 71,
		goods = {110003,0,1000},
		curr_type = 2,
		price = 3500,
		weights = 500,
		vip = 0,
		counter_id = 0,
		discount = <<"treasure_30off">>
	};

get(72) ->
	#mystery_shop_conf{
		id = 72,
		goods = {110096,0,5},
		curr_type = 2,
		price = 6400,
		weights = 500,
		vip = 0,
		counter_id = 0,
		discount = <<"treasure_rare">>
	};

get(73) ->
	#mystery_shop_conf{
		id = 73,
		goods = {110105,0,5},
		curr_type = 2,
		price = 9600,
		weights = 500,
		vip = 8,
		counter_id = 0,
		discount = <<"treasure_rare">>
	};

get(74) ->
	#mystery_shop_conf{
		id = 74,
		goods = {110140,0,200},
		curr_type = 2,
		price = 4200,
		weights = 500,
		vip = 0,
		counter_id = 0,
		discount = <<"treasure_30off">>
	};

get(75) ->
	#mystery_shop_conf{
		id = 75,
		goods = {110193,0,200},
		curr_type = 2,
		price = 700,
		weights = 700,
		vip = 0,
		counter_id = 0,
		discount = <<"treasure_30off">>
	};

get(76) ->
	#mystery_shop_conf{
		id = 76,
		goods = {110007,0,1000},
		curr_type = 2,
		price = 1400,
		weights = 700,
		vip = 0,
		counter_id = 0,
		discount = <<"treasure_30off">>
	};

get(77) ->
	#mystery_shop_conf{
		id = 77,
		goods = {110160,0,500},
		curr_type = 2,
		price = 4000,
		weights = 700,
		vip = 0,
		counter_id = 0,
		discount = <<"treasure_20off">>
	};

get(78) ->
	#mystery_shop_conf{
		id = 78,
		goods = {110109,0,30},
		curr_type = 2,
		price = 18000,
		weights = 500,
		vip = 5,
		counter_id = 0,
		discount = <<"treasure_60off">>
	};

get(79) ->
	#mystery_shop_conf{
		id = 79,
		goods = {110163,0,10},
		curr_type = 2,
		price = 27000,
		weights = 100,
		vip = 8,
		counter_id = 10067,
		discount = <<"treasure_rare">>
	};

get(80) ->
	#mystery_shop_conf{
		id = 80,
		goods = {110222,0,1},
		curr_type = 2,
		price = 500,
		weights = 500,
		vip = 3,
		counter_id = 0,
		discount = <<"treasure_rare">>
	};

get(81) ->
	#mystery_shop_conf{
		id = 81,
		goods = {110222,0,10},
		curr_type = 2,
		price = 4000,
		weights = 500,
		vip = 3,
		counter_id = 0,
		discount = <<"treasure_20off">>
	};

get(82) ->
	#mystery_shop_conf{
		id = 82,
		goods = {110304,0,10},
		curr_type = 2,
		price = 9000,
		weights = 0,
		vip = 8,
		counter_id = 0,
		discount = <<"treasure_rare">>
	};

get(83) ->
	#mystery_shop_conf{
		id = 83,
		goods = {110304,0,20},
		curr_type = 2,
		price = 16000,
		weights = 0,
		vip = 8,
		counter_id = 0,
		discount = <<"treasure_20off">>
	};

get(84) ->
	#mystery_shop_conf{
		id = 84,
		goods = {110304,0,1},
		curr_type = 2,
		price = 1000,
		weights = 0,
		vip = 8,
		counter_id = 0,
		discount = <<"treasure_rare">>
	};

get(_Key) ->
	?ERR("undefined key from mystery_shop_config ~p", [_Key]).