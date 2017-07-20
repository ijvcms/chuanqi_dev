%%%-------------------------------------------------------------------
%%% @author zhengsiying
%%% @doc
%%%		自动生成文件，不要手动修改
%%% @end
%%% Created : 2016/10/12
%%%-------------------------------------------------------------------

-module(shop_config).

-include("common.hrl").
-include("config.hrl").

-compile([export_all]).

get_list_conf() ->
	[ shop_config:get(X) || X <- get_list() ].

get_list() ->
	[1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32, 33, 34, 35, 36, 37, 38, 39, 40, 41, 42, 43, 44, 45, 46, 47, 48, 49, 50, 51, 52, 53, 54, 55, 56, 57, 58, 59, 60, 61, 62, 63, 64, 65, 66, 67, 68, 69, 70, 71, 72, 73, 74, 75, 76, 77, 78, 79, 80, 81, 82, 83, 84, 85, 86, 87, 88, 89, 90, 91, 92, 93, 94, 95, 96, 97, 98, 99, 100, 101, 102, 103, 104, 105, 106, 107, 108, 109, 110, 111, 112, 113, 114, 115, 116, 117, 118, 119, 120, 801, 802, 803, 804, 805, 806, 807, 808, 809, 810, 811, 812, 813, 814, 815].

get(1) ->
	#shop_conf{
		key = 1,
		type = 1,
		goods_id = 110050,
		is_bind = 0,
		num = 1,
		curr_type = 2,
		price = 50,
		limit_vip = 0,
		counter_id = 0
	};

get(2) ->
	#shop_conf{
		key = 2,
		type = 1,
		goods_id = 110054,
		is_bind = 0,
		num = 1,
		curr_type = 2,
		price = 50,
		limit_vip = 0,
		counter_id = 0
	};

get(3) ->
	#shop_conf{
		key = 3,
		type = 1,
		goods_id = 110003,
		is_bind = 0,
		num = 1,
		curr_type = 2,
		price = 5,
		limit_vip = 0,
		counter_id = 0
	};

get(4) ->
	#shop_conf{
		key = 4,
		type = 1,
		goods_id = 110083,
		is_bind = 0,
		num = 1,
		curr_type = 2,
		price = 3,
		limit_vip = 0,
		counter_id = 0
	};

get(5) ->
	#shop_conf{
		key = 5,
		type = 1,
		goods_id = 110088,
		is_bind = 0,
		num = 1,
		curr_type = 2,
		price = 50,
		limit_vip = 0,
		counter_id = 0
	};

get(6) ->
	#shop_conf{
		key = 6,
		type = 1,
		goods_id = 110089,
		is_bind = 0,
		num = 1,
		curr_type = 2,
		price = 10,
		limit_vip = 0,
		counter_id = 0
	};

get(7) ->
	#shop_conf{
		key = 7,
		type = 1,
		goods_id = 110093,
		is_bind = 0,
		num = 1,
		curr_type = 2,
		price = 128,
		limit_vip = 0,
		counter_id = 0
	};

get(8) ->
	#shop_conf{
		key = 8,
		type = 1,
		goods_id = 110048,
		is_bind = 0,
		num = 1,
		curr_type = 2,
		price = 200,
		limit_vip = 0,
		counter_id = 0
	};

get(9) ->
	#shop_conf{
		key = 9,
		type = 1,
		goods_id = 110148,
		is_bind = 0,
		num = 1,
		curr_type = 2,
		price = 10,
		limit_vip = 0,
		counter_id = 0
	};

get(10) ->
	#shop_conf{
		key = 10,
		type = 1,
		goods_id = 110049,
		is_bind = 0,
		num = 1,
		curr_type = 2,
		price = 10,
		limit_vip = 0,
		counter_id = 0
	};

get(11) ->
	#shop_conf{
		key = 11,
		type = 1,
		goods_id = 110152,
		is_bind = 0,
		num = 1,
		curr_type = 2,
		price = 1,
		limit_vip = 0,
		counter_id = 0
	};

get(12) ->
	#shop_conf{
		key = 12,
		type = 1,
		goods_id = 110078,
		is_bind = 0,
		num = 1,
		curr_type = 2,
		price = 1,
		limit_vip = 0,
		counter_id = 0
	};

get(13) ->
	#shop_conf{
		key = 13,
		type = 1,
		goods_id = 110166,
		is_bind = 0,
		num = 1,
		curr_type = 2,
		price = 50,
		limit_vip = 0,
		counter_id = 0
	};

get(14) ->
	#shop_conf{
		key = 14,
		type = 1,
		goods_id = 110167,
		is_bind = 0,
		num = 1,
		curr_type = 2,
		price = 50,
		limit_vip = 0,
		counter_id = 0
	};

get(15) ->
	#shop_conf{
		key = 15,
		type = 1,
		goods_id = 110168,
		is_bind = 0,
		num = 1,
		curr_type = 2,
		price = 50,
		limit_vip = 0,
		counter_id = 0
	};

get(16) ->
	#shop_conf{
		key = 16,
		type = 1,
		goods_id = 110007,
		is_bind = 0,
		num = 1,
		curr_type = 2,
		price = 2,
		limit_vip = 0,
		counter_id = 0
	};

get(17) ->
	#shop_conf{
		key = 17,
		type = 1,
		goods_id = 110193,
		is_bind = 0,
		num = 1,
		curr_type = 2,
		price = 5,
		limit_vip = 0,
		counter_id = 0
	};

get(18) ->
	#shop_conf{
		key = 18,
		type = 1,
		goods_id = 110194,
		is_bind = 0,
		num = 1,
		curr_type = 2,
		price = 10,
		limit_vip = 0,
		counter_id = 0
	};

get(19) ->
	#shop_conf{
		key = 19,
		type = 1,
		goods_id = 110137,
		is_bind = 0,
		num = 1,
		curr_type = 2,
		price = 2,
		limit_vip = 0,
		counter_id = 0
	};

get(20) ->
	#shop_conf{
		key = 20,
		type = 1,
		goods_id = 110138,
		is_bind = 0,
		num = 1,
		curr_type = 2,
		price = 2,
		limit_vip = 0,
		counter_id = 0
	};

get(21) ->
	#shop_conf{
		key = 21,
		type = 1,
		goods_id = 110056,
		is_bind = 0,
		num = 1,
		curr_type = 2,
		price = 20,
		limit_vip = 0,
		counter_id = 0
	};

get(22) ->
	#shop_conf{
		key = 22,
		type = 1,
		goods_id = 110283,
		is_bind = 0,
		num = 1,
		curr_type = 2,
		price = 10,
		limit_vip = 0,
		counter_id = 0
	};

get(23) ->
	#shop_conf{
		key = 23,
		type = 1,
		goods_id = 110284,
		is_bind = 0,
		num = 1,
		curr_type = 2,
		price = 60,
		limit_vip = 0,
		counter_id = 0
	};

get(24) ->
	#shop_conf{
		key = 24,
		type = 2,
		goods_id = 110083,
		is_bind = 1,
		num = 1,
		curr_type = 3,
		price = 3,
		limit_vip = 0,
		counter_id = 0
	};

get(25) ->
	#shop_conf{
		key = 25,
		type = 2,
		goods_id = 110007,
		is_bind = 1,
		num = 1,
		curr_type = 3,
		price = 5,
		limit_vip = 0,
		counter_id = 0
	};

get(26) ->
	#shop_conf{
		key = 26,
		type = 2,
		goods_id = 110137,
		is_bind = 1,
		num = 1,
		curr_type = 3,
		price = 2,
		limit_vip = 0,
		counter_id = 0
	};

get(27) ->
	#shop_conf{
		key = 27,
		type = 2,
		goods_id = 110138,
		is_bind = 1,
		num = 1,
		curr_type = 3,
		price = 2,
		limit_vip = 0,
		counter_id = 0
	};

get(28) ->
	#shop_conf{
		key = 28,
		type = 2,
		goods_id = 110078,
		is_bind = 1,
		num = 1,
		curr_type = 3,
		price = 1,
		limit_vip = 0,
		counter_id = 0
	};

get(29) ->
	#shop_conf{
		key = 29,
		type = 2,
		goods_id = 110056,
		is_bind = 1,
		num = 1,
		curr_type = 3,
		price = 20,
		limit_vip = 0,
		counter_id = 0
	};

get(30) ->
	#shop_conf{
		key = 30,
		type = 2,
		goods_id = 110172,
		is_bind = 1,
		num = 1,
		curr_type = 3,
		price = 2,
		limit_vip = 0,
		counter_id = 10059
	};

get(31) ->
	#shop_conf{
		key = 31,
		type = 2,
		goods_id = 110177,
		is_bind = 1,
		num = 1,
		curr_type = 3,
		price = 2,
		limit_vip = 0,
		counter_id = 10060
	};

get(32) ->
	#shop_conf{
		key = 32,
		type = 2,
		goods_id = 110182,
		is_bind = 1,
		num = 1,
		curr_type = 3,
		price = 2,
		limit_vip = 0,
		counter_id = 10061
	};

get(33) ->
	#shop_conf{
		key = 33,
		type = 2,
		goods_id = 110187,
		is_bind = 1,
		num = 1,
		curr_type = 3,
		price = 2,
		limit_vip = 0,
		counter_id = 10062
	};

get(34) ->
	#shop_conf{
		key = 34,
		type = 3,
		goods_id = 110295,
		is_bind = 1,
		num = 1,
		curr_type = 2,
		price = 999,
		limit_vip = 3,
		counter_id = 10110
	};

get(35) ->
	#shop_conf{
		key = 35,
		type = 3,
		goods_id = 110296,
		is_bind = 1,
		num = 1,
		curr_type = 2,
		price = 1350,
		limit_vip = 5,
		counter_id = 10112
	};

get(36) ->
	#shop_conf{
		key = 36,
		type = 3,
		goods_id = 110291,
		is_bind = 1,
		num = 1,
		curr_type = 2,
		price = 6120,
		limit_vip = 7,
		counter_id = 10123
	};

get(37) ->
	#shop_conf{
		key = 37,
		type = 3,
		goods_id = 110297,
		is_bind = 1,
		num = 1,
		curr_type = 2,
		price = 17500,
		limit_vip = 8,
		counter_id = 10115
	};

get(38) ->
	#shop_conf{
		key = 38,
		type = 3,
		goods_id = 110298,
		is_bind = 1,
		num = 1,
		curr_type = 2,
		price = 8300,
		limit_vip = 9,
		counter_id = 10116
	};

get(39) ->
	#shop_conf{
		key = 39,
		type = 3,
		goods_id = 110299,
		is_bind = 1,
		num = 1,
		curr_type = 2,
		price = 12000,
		limit_vip = 10,
		counter_id = 10117
	};

get(40) ->
	#shop_conf{
		key = 40,
		type = 3,
		goods_id = 110300,
		is_bind = 1,
		num = 1,
		curr_type = 2,
		price = 21800,
		limit_vip = 11,
		counter_id = 10118
	};

get(41) ->
	#shop_conf{
		key = 41,
		type = 3,
		goods_id = 110292,
		is_bind = 1,
		num = 1,
		curr_type = 2,
		price = 81600,
		limit_vip = 12,
		counter_id = 10124
	};

get(42) ->
	#shop_conf{
		key = 42,
		type = 3,
		goods_id = 110293,
		is_bind = 1,
		num = 1,
		curr_type = 2,
		price = 238680,
		limit_vip = 13,
		counter_id = 10125
	};

get(43) ->
	#shop_conf{
		key = 43,
		type = 3,
		goods_id = 110301,
		is_bind = 1,
		num = 1,
		curr_type = 2,
		price = 72000,
		limit_vip = 14,
		counter_id = 10121
	};

get(44) ->
	#shop_conf{
		key = 44,
		type = 3,
		goods_id = 110302,
		is_bind = 1,
		num = 1,
		curr_type = 2,
		price = 118000,
		limit_vip = 15,
		counter_id = 10122
	};

get(45) ->
	#shop_conf{
		key = 45,
		type = 10,
		goods_id = 200000,
		is_bind = 1,
		num = 1,
		curr_type = 1,
		price = 400,
		limit_vip = 0,
		counter_id = 0
	};

get(46) ->
	#shop_conf{
		key = 46,
		type = 10,
		goods_id = 201000,
		is_bind = 1,
		num = 1,
		curr_type = 1,
		price = 400,
		limit_vip = 0,
		counter_id = 0
	};

get(47) ->
	#shop_conf{
		key = 47,
		type = 10,
		goods_id = 202000,
		is_bind = 1,
		num = 1,
		curr_type = 1,
		price = 400,
		limit_vip = 0,
		counter_id = 0
	};

get(48) ->
	#shop_conf{
		key = 48,
		type = 10,
		goods_id = 200010,
		is_bind = 1,
		num = 1,
		curr_type = 1,
		price = 4000,
		limit_vip = 0,
		counter_id = 0
	};

get(49) ->
	#shop_conf{
		key = 49,
		type = 10,
		goods_id = 201010,
		is_bind = 1,
		num = 1,
		curr_type = 1,
		price = 4000,
		limit_vip = 0,
		counter_id = 0
	};

get(50) ->
	#shop_conf{
		key = 50,
		type = 10,
		goods_id = 202010,
		is_bind = 1,
		num = 1,
		curr_type = 1,
		price = 4000,
		limit_vip = 0,
		counter_id = 0
	};

get(51) ->
	#shop_conf{
		key = 51,
		type = 11,
		goods_id = 200001,
		is_bind = 1,
		num = 1,
		curr_type = 1,
		price = 300,
		limit_vip = 0,
		counter_id = 0
	};

get(52) ->
	#shop_conf{
		key = 52,
		type = 11,
		goods_id = 200012,
		is_bind = 1,
		num = 1,
		curr_type = 1,
		price = 3000,
		limit_vip = 0,
		counter_id = 0
	};

get(53) ->
	#shop_conf{
		key = 53,
		type = 11,
		goods_id = 201001,
		is_bind = 1,
		num = 1,
		curr_type = 1,
		price = 300,
		limit_vip = 0,
		counter_id = 0
	};

get(54) ->
	#shop_conf{
		key = 54,
		type = 11,
		goods_id = 201012,
		is_bind = 1,
		num = 1,
		curr_type = 1,
		price = 3000,
		limit_vip = 0,
		counter_id = 0
	};

get(55) ->
	#shop_conf{
		key = 55,
		type = 11,
		goods_id = 202001,
		is_bind = 1,
		num = 1,
		curr_type = 1,
		price = 300,
		limit_vip = 0,
		counter_id = 0
	};

get(56) ->
	#shop_conf{
		key = 56,
		type = 11,
		goods_id = 202012,
		is_bind = 1,
		num = 1,
		curr_type = 1,
		price = 3000,
		limit_vip = 0,
		counter_id = 0
	};

get(57) ->
	#shop_conf{
		key = 57,
		type = 11,
		goods_id = 200015,
		is_bind = 1,
		num = 1,
		curr_type = 1,
		price = 2000,
		limit_vip = 0,
		counter_id = 0
	};

get(58) ->
	#shop_conf{
		key = 58,
		type = 11,
		goods_id = 201015,
		is_bind = 1,
		num = 1,
		curr_type = 1,
		price = 2000,
		limit_vip = 0,
		counter_id = 0
	};

get(59) ->
	#shop_conf{
		key = 59,
		type = 11,
		goods_id = 202015,
		is_bind = 1,
		num = 1,
		curr_type = 1,
		price = 2000,
		limit_vip = 0,
		counter_id = 0
	};

get(60) ->
	#shop_conf{
		key = 60,
		type = 11,
		goods_id = 200017,
		is_bind = 1,
		num = 1,
		curr_type = 1,
		price = 2000,
		limit_vip = 0,
		counter_id = 0
	};

get(61) ->
	#shop_conf{
		key = 61,
		type = 11,
		goods_id = 201017,
		is_bind = 1,
		num = 1,
		curr_type = 1,
		price = 2000,
		limit_vip = 0,
		counter_id = 0
	};

get(62) ->
	#shop_conf{
		key = 62,
		type = 11,
		goods_id = 202017,
		is_bind = 1,
		num = 1,
		curr_type = 1,
		price = 2000,
		limit_vip = 0,
		counter_id = 0
	};

get(63) ->
	#shop_conf{
		key = 63,
		type = 11,
		goods_id = 200019,
		is_bind = 1,
		num = 1,
		curr_type = 1,
		price = 2000,
		limit_vip = 0,
		counter_id = 0
	};

get(64) ->
	#shop_conf{
		key = 64,
		type = 11,
		goods_id = 201019,
		is_bind = 1,
		num = 1,
		curr_type = 1,
		price = 2000,
		limit_vip = 0,
		counter_id = 0
	};

get(65) ->
	#shop_conf{
		key = 65,
		type = 11,
		goods_id = 202019,
		is_bind = 1,
		num = 1,
		curr_type = 1,
		price = 2000,
		limit_vip = 0,
		counter_id = 0
	};

get(66) ->
	#shop_conf{
		key = 66,
		type = 12,
		goods_id = 200002,
		is_bind = 1,
		num = 1,
		curr_type = 1,
		price = 200,
		limit_vip = 0,
		counter_id = 0
	};

get(67) ->
	#shop_conf{
		key = 67,
		type = 12,
		goods_id = 201002,
		is_bind = 1,
		num = 1,
		curr_type = 1,
		price = 200,
		limit_vip = 0,
		counter_id = 0
	};

get(68) ->
	#shop_conf{
		key = 68,
		type = 12,
		goods_id = 202002,
		is_bind = 1,
		num = 1,
		curr_type = 1,
		price = 200,
		limit_vip = 0,
		counter_id = 0
	};

get(69) ->
	#shop_conf{
		key = 69,
		type = 12,
		goods_id = 200003,
		is_bind = 1,
		num = 1,
		curr_type = 1,
		price = 200,
		limit_vip = 0,
		counter_id = 0
	};

get(70) ->
	#shop_conf{
		key = 70,
		type = 12,
		goods_id = 201003,
		is_bind = 1,
		num = 1,
		curr_type = 1,
		price = 200,
		limit_vip = 0,
		counter_id = 0
	};

get(71) ->
	#shop_conf{
		key = 71,
		type = 12,
		goods_id = 202003,
		is_bind = 1,
		num = 1,
		curr_type = 1,
		price = 200,
		limit_vip = 0,
		counter_id = 0
	};

get(72) ->
	#shop_conf{
		key = 72,
		type = 12,
		goods_id = 200006,
		is_bind = 1,
		num = 1,
		curr_type = 1,
		price = 400,
		limit_vip = 0,
		counter_id = 0
	};

get(73) ->
	#shop_conf{
		key = 73,
		type = 12,
		goods_id = 201006,
		is_bind = 1,
		num = 1,
		curr_type = 1,
		price = 400,
		limit_vip = 0,
		counter_id = 0
	};

get(74) ->
	#shop_conf{
		key = 74,
		type = 12,
		goods_id = 202006,
		is_bind = 1,
		num = 1,
		curr_type = 1,
		price = 400,
		limit_vip = 0,
		counter_id = 0
	};

get(75) ->
	#shop_conf{
		key = 75,
		type = 12,
		goods_id = 200011,
		is_bind = 1,
		num = 1,
		curr_type = 1,
		price = 2000,
		limit_vip = 0,
		counter_id = 0
	};

get(76) ->
	#shop_conf{
		key = 76,
		type = 12,
		goods_id = 201011,
		is_bind = 1,
		num = 1,
		curr_type = 1,
		price = 2000,
		limit_vip = 0,
		counter_id = 0
	};

get(77) ->
	#shop_conf{
		key = 77,
		type = 12,
		goods_id = 202011,
		is_bind = 1,
		num = 1,
		curr_type = 1,
		price = 2000,
		limit_vip = 0,
		counter_id = 0
	};

get(78) ->
	#shop_conf{
		key = 78,
		type = 12,
		goods_id = 200013,
		is_bind = 1,
		num = 1,
		curr_type = 1,
		price = 1000,
		limit_vip = 0,
		counter_id = 0
	};

get(79) ->
	#shop_conf{
		key = 79,
		type = 12,
		goods_id = 201013,
		is_bind = 1,
		num = 1,
		curr_type = 1,
		price = 1000,
		limit_vip = 0,
		counter_id = 0
	};

get(80) ->
	#shop_conf{
		key = 80,
		type = 12,
		goods_id = 202013,
		is_bind = 1,
		num = 1,
		curr_type = 1,
		price = 1000,
		limit_vip = 0,
		counter_id = 0
	};

get(81) ->
	#shop_conf{
		key = 81,
		type = 12,
		goods_id = 200016,
		is_bind = 1,
		num = 1,
		curr_type = 1,
		price = 1000,
		limit_vip = 0,
		counter_id = 0
	};

get(82) ->
	#shop_conf{
		key = 82,
		type = 12,
		goods_id = 201016,
		is_bind = 1,
		num = 1,
		curr_type = 1,
		price = 1000,
		limit_vip = 0,
		counter_id = 0
	};

get(83) ->
	#shop_conf{
		key = 83,
		type = 12,
		goods_id = 202016,
		is_bind = 1,
		num = 1,
		curr_type = 1,
		price = 1000,
		limit_vip = 0,
		counter_id = 0
	};

get(84) ->
	#shop_conf{
		key = 84,
		type = 13,
		goods_id = 110004,
		is_bind = 1,
		num = 1,
		curr_type = 1,
		price = 500,
		limit_vip = 0,
		counter_id = 0
	};

get(85) ->
	#shop_conf{
		key = 85,
		type = 13,
		goods_id = 110005,
		is_bind = 1,
		num = 1,
		curr_type = 1,
		price = 500,
		limit_vip = 0,
		counter_id = 0
	};

get(86) ->
	#shop_conf{
		key = 86,
		type = 13,
		goods_id = 110076,
		is_bind = 1,
		num = 1,
		curr_type = 1,
		price = 1500,
		limit_vip = 0,
		counter_id = 0
	};

get(87) ->
	#shop_conf{
		key = 87,
		type = 13,
		goods_id = 110077,
		is_bind = 1,
		num = 1,
		curr_type = 1,
		price = 1500,
		limit_vip = 0,
		counter_id = 0
	};

get(88) ->
	#shop_conf{
		key = 88,
		type = 13,
		goods_id = 110006,
		is_bind = 1,
		num = 1,
		curr_type = 1,
		price = 10000,
		limit_vip = 0,
		counter_id = 0
	};

get(89) ->
	#shop_conf{
		key = 89,
		type = 13,
		goods_id = 110007,
		is_bind = 1,
		num = 1,
		curr_type = 1,
		price = 120000,
		limit_vip = 0,
		counter_id = 0
	};

get(90) ->
	#shop_conf{
		key = 90,
		type = 14,
		goods_id = 110019,
		is_bind = 1,
		num = 1,
		curr_type = 1,
		price = 1000,
		limit_vip = 0,
		counter_id = 0
	};

get(91) ->
	#shop_conf{
		key = 91,
		type = 14,
		goods_id = 110020,
		is_bind = 1,
		num = 1,
		curr_type = 1,
		price = 20000,
		limit_vip = 0,
		counter_id = 0
	};

get(92) ->
	#shop_conf{
		key = 92,
		type = 14,
		goods_id = 110021,
		is_bind = 1,
		num = 1,
		curr_type = 1,
		price = 200000,
		limit_vip = 0,
		counter_id = 0
	};

get(93) ->
	#shop_conf{
		key = 93,
		type = 14,
		goods_id = 110022,
		is_bind = 1,
		num = 1,
		curr_type = 1,
		price = 2000000,
		limit_vip = 0,
		counter_id = 0
	};

get(94) ->
	#shop_conf{
		key = 94,
		type = 14,
		goods_id = 110023,
		is_bind = 1,
		num = 1,
		curr_type = 1,
		price = 3000000,
		limit_vip = 0,
		counter_id = 0
	};

get(95) ->
	#shop_conf{
		key = 95,
		type = 14,
		goods_id = 110033,
		is_bind = 1,
		num = 1,
		curr_type = 1,
		price = 1000,
		limit_vip = 0,
		counter_id = 0
	};

get(96) ->
	#shop_conf{
		key = 96,
		type = 14,
		goods_id = 110034,
		is_bind = 1,
		num = 1,
		curr_type = 1,
		price = 20000,
		limit_vip = 0,
		counter_id = 0
	};

get(97) ->
	#shop_conf{
		key = 97,
		type = 14,
		goods_id = 110036,
		is_bind = 1,
		num = 1,
		curr_type = 1,
		price = 100000,
		limit_vip = 0,
		counter_id = 0
	};

get(98) ->
	#shop_conf{
		key = 98,
		type = 14,
		goods_id = 110037,
		is_bind = 1,
		num = 1,
		curr_type = 1,
		price = 100000,
		limit_vip = 0,
		counter_id = 0
	};

get(99) ->
	#shop_conf{
		key = 99,
		type = 14,
		goods_id = 110035,
		is_bind = 1,
		num = 1,
		curr_type = 1,
		price = 2000000,
		limit_vip = 0,
		counter_id = 0
	};

get(100) ->
	#shop_conf{
		key = 100,
		type = 14,
		goods_id = 110038,
		is_bind = 1,
		num = 1,
		curr_type = 1,
		price = 3000000,
		limit_vip = 0,
		counter_id = 0
	};

get(101) ->
	#shop_conf{
		key = 101,
		type = 14,
		goods_id = 110039,
		is_bind = 1,
		num = 1,
		curr_type = 1,
		price = 2000000,
		limit_vip = 0,
		counter_id = 0
	};

get(102) ->
	#shop_conf{
		key = 102,
		type = 14,
		goods_id = 110027,
		is_bind = 1,
		num = 1,
		curr_type = 1,
		price = 1000,
		limit_vip = 0,
		counter_id = 0
	};

get(103) ->
	#shop_conf{
		key = 103,
		type = 14,
		goods_id = 110028,
		is_bind = 1,
		num = 1,
		curr_type = 1,
		price = 20000,
		limit_vip = 0,
		counter_id = 0
	};

get(104) ->
	#shop_conf{
		key = 104,
		type = 14,
		goods_id = 110066,
		is_bind = 1,
		num = 1,
		curr_type = 1,
		price = 200000,
		limit_vip = 0,
		counter_id = 0
	};

get(105) ->
	#shop_conf{
		key = 105,
		type = 14,
		goods_id = 110029,
		is_bind = 1,
		num = 1,
		curr_type = 1,
		price = 2000000,
		limit_vip = 0,
		counter_id = 0
	};

get(106) ->
	#shop_conf{
		key = 106,
		type = 14,
		goods_id = 110030,
		is_bind = 1,
		num = 1,
		curr_type = 1,
		price = 3000000,
		limit_vip = 0,
		counter_id = 0
	};

get(107) ->
	#shop_conf{
		key = 107,
		type = 16,
		goods_id = 110127,
		is_bind = 1,
		num = 1,
		curr_type = 1,
		price = 20000,
		limit_vip = 0,
		counter_id = 0
	};

get(108) ->
	#shop_conf{
		key = 108,
		type = 1,
		goods_id = 110140,
		is_bind = 0,
		num = 1,
		curr_type = 2,
		price = 30,
		limit_vip = 0,
		counter_id = 0
	};

get(109) ->
	#shop_conf{
		key = 109,
		type = 4,
		goods_id = 305022,
		is_bind = 1,
		num = <<"VIP7">>,
		curr_type = 2,
		price = 0,
		limit_vip = 0,
		counter_id = 0
	};

get(110) ->
	#shop_conf{
		key = 110,
		type = 4,
		goods_id = 305002,
		is_bind = 1,
		num = <<"VIP8">>,
		curr_type = 2,
		price = 0,
		limit_vip = 0,
		counter_id = 0
	};

get(111) ->
	#shop_conf{
		key = 111,
		type = 4,
		goods_id = 305026,
		is_bind = 1,
		num = <<"VIP9">>,
		curr_type = 2,
		price = 0,
		limit_vip = 0,
		counter_id = 0
	};

get(112) ->
	#shop_conf{
		key = 112,
		type = 4,
		goods_id = 305001,
		is_bind = 1,
		num = <<"VIP10">>,
		curr_type = 2,
		price = 0,
		limit_vip = 0,
		counter_id = 0
	};

get(113) ->
	#shop_conf{
		key = 113,
		type = 4,
		goods_id = 305000,
		is_bind = 1,
		num = <<"VIP11">>,
		curr_type = 2,
		price = 0,
		limit_vip = 0,
		counter_id = 0
	};

get(114) ->
	#shop_conf{
		key = 114,
		type = 4,
		goods_id = 305030,
		is_bind = 1,
		num = <<"VIP12">>,
		curr_type = 2,
		price = 0,
		limit_vip = 0,
		counter_id = 0
	};

get(115) ->
	#shop_conf{
		key = 115,
		type = 4,
		goods_id = 305033,
		is_bind = 1,
		num = <<"VIP13">>,
		curr_type = 2,
		price = 0,
		limit_vip = 0,
		counter_id = 0
	};

get(116) ->
	#shop_conf{
		key = 116,
		type = 4,
		goods_id = 305029,
		is_bind = 1,
		num = <<"VIP14">>,
		curr_type = 2,
		price = 0,
		limit_vip = 0,
		counter_id = 0
	};

get(117) ->
	#shop_conf{
		key = 117,
		type = 4,
		goods_id = 200090,
		is_bind = 1,
		num = <<"VIP15">>,
		curr_type = 2,
		price = 0,
		limit_vip = 0,
		counter_id = 0
	};

get(118) ->
	#shop_conf{
		key = 118,
		type = 4,
		goods_id = 201090,
		is_bind = 1,
		num = <<"VIP15">>,
		curr_type = 2,
		price = 0,
		limit_vip = 0,
		counter_id = 0
	};

get(119) ->
	#shop_conf{
		key = 119,
		type = 4,
		goods_id = 202090,
		is_bind = 1,
		num = <<"VIP15">>,
		curr_type = 2,
		price = 0,
		limit_vip = 0,
		counter_id = 0
	};

get(120) ->
	#shop_conf{
		key = 120,
		type = 1,
		goods_id = 110260,
		is_bind = 0,
		num = 1,
		curr_type = 2,
		price = 50,
		limit_vip = 0,
		counter_id = 0
	};

get(801) ->
	#shop_conf{
		key = 801,
		type = 15,
		goods_id = 110109,
		is_bind = 0,
		num = 1,
		curr_type = 2,
		price = 1500,
		limit_vip = 0,
		counter_id = 0
	};

get(802) ->
	#shop_conf{
		key = 802,
		type = 15,
		goods_id = 110089,
		is_bind = 0,
		num = 1,
		curr_type = 2,
		price = 8,
		limit_vip = 0,
		counter_id = 0
	};

get(803) ->
	#shop_conf{
		key = 803,
		type = 15,
		goods_id = 110013,
		is_bind = 0,
		num = 1,
		curr_type = 2,
		price = 30,
		limit_vip = 0,
		counter_id = 0
	};

get(804) ->
	#shop_conf{
		key = 804,
		type = 15,
		goods_id = 110016,
		is_bind = 0,
		num = 1,
		curr_type = 2,
		price = 80,
		limit_vip = 0,
		counter_id = 0
	};

get(805) ->
	#shop_conf{
		key = 805,
		type = 15,
		goods_id = 110003,
		is_bind = 0,
		num = 1,
		curr_type = 2,
		price = 4,
		limit_vip = 0,
		counter_id = 0
	};

get(806) ->
	#shop_conf{
		key = 806,
		type = 15,
		goods_id = 110025,
		is_bind = 0,
		num = 1,
		curr_type = 2,
		price = 2000,
		limit_vip = 0,
		counter_id = 0
	};

get(807) ->
	#shop_conf{
		key = 807,
		type = 15,
		goods_id = 110032,
		is_bind = 0,
		num = 1,
		curr_type = 2,
		price = 2000,
		limit_vip = 0,
		counter_id = 0
	};

get(808) ->
	#shop_conf{
		key = 808,
		type = 15,
		goods_id = 110040,
		is_bind = 0,
		num = 1,
		curr_type = 2,
		price = 2000,
		limit_vip = 0,
		counter_id = 0
	};

get(809) ->
	#shop_conf{
		key = 809,
		type = 15,
		goods_id = 110024,
		is_bind = 0,
		num = 1,
		curr_type = 2,
		price = 2000,
		limit_vip = 0,
		counter_id = 0
	};

get(810) ->
	#shop_conf{
		key = 810,
		type = 15,
		goods_id = 110031,
		is_bind = 0,
		num = 1,
		curr_type = 2,
		price = 2000,
		limit_vip = 0,
		counter_id = 0
	};

get(811) ->
	#shop_conf{
		key = 811,
		type = 15,
		goods_id = 110067,
		is_bind = 0,
		num = 1,
		curr_type = 2,
		price = 2000,
		limit_vip = 0,
		counter_id = 0
	};

get(812) ->
	#shop_conf{
		key = 812,
		type = 15,
		goods_id = 110083,
		is_bind = 0,
		num = 1,
		curr_type = 2,
		price = 2,
		limit_vip = 0,
		counter_id = 0
	};

get(813) ->
	#shop_conf{
		key = 813,
		type = 15,
		goods_id = 110088,
		is_bind = 0,
		num = 1,
		curr_type = 2,
		price = 40,
		limit_vip = 0,
		counter_id = 0
	};

get(814) ->
	#shop_conf{
		key = 814,
		type = 15,
		goods_id = 110093,
		is_bind = 0,
		num = 1,
		curr_type = 2,
		price = 128,
		limit_vip = 0,
		counter_id = 0
	};

get(815) ->
	#shop_conf{
		key = 815,
		type = 15,
		goods_id = 110162,
		is_bind = 0,
		num = 1,
		curr_type = 2,
		price = 500,
		limit_vip = 0,
		counter_id = 0
	};

get(_Key) ->
	?ERR("undefined key from shop_config ~p", [_Key]).