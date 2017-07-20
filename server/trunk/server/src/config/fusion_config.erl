%%%-------------------------------------------------------------------
%%% @author zhengsiying
%%% @doc
%%%		自动生成文件，不要手动修改
%%% @end
%%% Created : 2016/10/12
%%%-------------------------------------------------------------------

-module(fusion_config).

-include("common.hrl").
-include("config.hrl").

-compile([export_all]).

get_list_conf() ->
	[ fusion_config:get(X) || X <- get_list() ].

get_list() ->
	[1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32, 33, 34, 35, 36, 37, 38, 39, 40, 41, 42, 43, 44, 45, 46, 47, 48, 49, 50, 51, 52, 53, 54, 55, 56, 57, 58, 59, 60, 61, 62, 63, 64, 65, 66, 67, 68, 69, 70, 71, 72, 73, 74, 75, 76, 77, 78, 79, 80, 81, 82, 83, 84, 85, 86, 87, 88, 89, 90, 91, 92, 93, 94, 95, 96, 97, 98, 99, 100, 101, 102, 103, 104, 105, 106, 107, 108, 109, 110, 111, 112, 113, 114, 115, 116, 117, 118, 119, 120, 121, 122, 123, 124, 125, 126, 127, 128, 129, 130, 131, 132, 133, 134, 135, 136, 137, 138, 139, 140, 141, 142, 143, 144, 145, 146, 147, 148, 149, 150, 151, 152, 153, 154, 155, 156, 157, 158, 159, 160, 161, 162, 163, 164, 165, 166, 167, 168, 169, 170, 171, 172, 173, 174, 175, 176, 177, 178, 179, 180, 181, 182, 183, 184, 185, 186, 187, 188, 189, 190, 191, 192, 193, 194, 195, 196, 197, 198, 199, 200, 201, 202, 203, 204, 205, 206, 207, 208, 209, 210, 211, 212, 213, 214, 215, 216, 217, 218, 219, 220, 221, 222, 223, 224, 225, 226, 227, 228, 229, 230, 231, 232, 233, 234, 235, 236, 237, 238, 239, 240, 241, 242, 243, 244, 245, 246, 247, 248, 249, 250, 251, 252, 253, 254, 255, 256, 257, 258, 259, 260, 261, 262, 263, 264, 265, 266, 267, 268, 269, 270, 271, 272, 273, 274, 275, 276, 277, 278, 279, 280, 281, 282, 283, 284, 285, 286, 287, 288, 289, 290, 291, 292, 293, 294, 295, 296, 297, 298].

get(1) ->
	#fusion_conf{
		key = 1,
		rate = 10000,
		type = 1,
		sub_type = 103,
		stuff = [{"goods",110010,40},{"coin",50000}],
		wear_equips = 0,
		product = [{"goods",200020, 0, 1}],
		product_equips = [{"goods",200020, 0, 1}]
	};

get(2) ->
	#fusion_conf{
		key = 2,
		rate = 10000,
		type = 1,
		sub_type = 103,
		stuff = [{"goods",110010,30},{"coin",50000}],
		wear_equips = 0,
		product = [{"goods",200021, 0, 1}],
		product_equips = [{"goods",200021, 0, 1}]
	};

get(3) ->
	#fusion_conf{
		key = 3,
		rate = 10000,
		type = 1,
		sub_type = 103,
		stuff = [{"goods",110010,20},{"coin",50000}],
		wear_equips = 0,
		product = [{"goods",200022, 0, 1}],
		product_equips = [{"goods",200022, 0, 1}]
	};

get(4) ->
	#fusion_conf{
		key = 4,
		rate = 10000,
		type = 1,
		sub_type = 103,
		stuff = [{"goods",110010,20},{"coin",50000}],
		wear_equips = 0,
		product = [{"goods",200023, 0, 1}],
		product_equips = [{"goods",200023, 0, 1}]
	};

get(5) ->
	#fusion_conf{
		key = 5,
		rate = 10000,
		type = 1,
		sub_type = 103,
		stuff = [{"goods",110010,20},{"coin",50000}],
		wear_equips = 0,
		product = [{"goods",200025, 0, 1}],
		product_equips = [{"goods",200025, 0, 1}]
	};

get(6) ->
	#fusion_conf{
		key = 6,
		rate = 10000,
		type = 1,
		sub_type = 103,
		stuff = [{"goods",110010,20},{"coin",50000}],
		wear_equips = 0,
		product = [{"goods",200026, 0, 1}],
		product_equips = [{"goods",200026, 0, 1}]
	};

get(7) ->
	#fusion_conf{
		key = 7,
		rate = 10000,
		type = 1,
		sub_type = 103,
		stuff = [{"goods",110010,20},{"coin",50000}],
		wear_equips = 0,
		product = [{"goods",200027, 0, 1}],
		product_equips = [{"goods",200027, 0, 1}]
	};

get(8) ->
	#fusion_conf{
		key = 8,
		rate = 10000,
		type = 1,
		sub_type = 103,
		stuff = [{"goods",110010,20},{"coin",50000}],
		wear_equips = 0,
		product = [{"goods",200029, 0, 1}],
		product_equips = [{"goods",200029, 0, 1}]
	};

get(9) ->
	#fusion_conf{
		key = 9,
		rate = 10000,
		type = 1,
		sub_type = 104,
		stuff = [{"goods",110013,80},{"coin",100000}],
		wear_equips = 0,
		product = [{"goods",305019, 0, 1}],
		product_equips = [{"goods",305019, 0, 1}]
	};

get(10) ->
	#fusion_conf{
		key = 10,
		rate = 10000,
		type = 1,
		sub_type = 105,
		stuff = [{"goods",110109,6},{"coin",100000}],
		wear_equips = 0,
		product = [{"goods",200030, 0, 1}],
		product_equips = [{"goods",200030, 0, 1}]
	};

get(11) ->
	#fusion_conf{
		key = 11,
		rate = 10000,
		type = 1,
		sub_type = 105,
		stuff = [{"goods",110109,4},{"coin",100000}],
		wear_equips = 0,
		product = [{"goods",200031, 0, 1}],
		product_equips = [{"goods",200031, 0, 1}]
	};

get(12) ->
	#fusion_conf{
		key = 12,
		rate = 10000,
		type = 1,
		sub_type = 105,
		stuff = [{"goods",110109,2},{"coin",100000}],
		wear_equips = 0,
		product = [{"goods",200032, 0, 1}],
		product_equips = [{"goods",200032, 0, 1}]
	};

get(13) ->
	#fusion_conf{
		key = 13,
		rate = 10000,
		type = 1,
		sub_type = 105,
		stuff = [{"goods",110109,2},{"coin",100000}],
		wear_equips = 0,
		product = [{"goods",200033, 0, 1}],
		product_equips = [{"goods",200033, 0, 1}]
	};

get(14) ->
	#fusion_conf{
		key = 14,
		rate = 10000,
		type = 1,
		sub_type = 105,
		stuff = [{"goods",110109,2},{"coin",100000}],
		wear_equips = 0,
		product = [{"goods",200035, 0, 1}],
		product_equips = [{"goods",200035, 0, 1}]
	};

get(15) ->
	#fusion_conf{
		key = 15,
		rate = 10000,
		type = 1,
		sub_type = 105,
		stuff = [{"goods",110109,2},{"coin",100000}],
		wear_equips = 0,
		product = [{"goods",200036, 0, 1}],
		product_equips = [{"goods",200036, 0, 1}]
	};

get(16) ->
	#fusion_conf{
		key = 16,
		rate = 10000,
		type = 1,
		sub_type = 105,
		stuff = [{"goods",110109,2},{"coin",100000}],
		wear_equips = 0,
		product = [{"goods",200037, 0, 1}],
		product_equips = [{"goods",200037, 0, 1}]
	};

get(17) ->
	#fusion_conf{
		key = 17,
		rate = 10000,
		type = 1,
		sub_type = 105,
		stuff = [{"goods",110109,2},{"coin",100000}],
		wear_equips = 0,
		product = [{"goods",200039, 0, 1}],
		product_equips = [{"goods",200039, 0, 1}]
	};

get(18) ->
	#fusion_conf{
		key = 18,
		rate = 10000,
		type = 1,
		sub_type = 104,
		stuff = [{"goods",110016,160},{"coin",150000}],
		wear_equips = 0,
		product = [{"goods",305020, 0, 1}],
		product_equips = [{"goods",305020, 0, 1}]
	};

get(19) ->
	#fusion_conf{
		key = 19,
		rate = 10000,
		type = 5,
		sub_type = 107,
		stuff = [{"goods",200030,1},{"goods",110109,15},{"coin",200000}],
		wear_equips = 200030,
		product = [{"goods",200060, 0, 1}],
		product_equips = [{"goods",200060, 0, 1}]
	};

get(20) ->
	#fusion_conf{
		key = 20,
		rate = 10000,
		type = 5,
		sub_type = 107,
		stuff = [{"goods",200031,1},{"goods",110109,10},{"coin",200000}],
		wear_equips = 200031,
		product = [{"goods",200061, 0, 1}],
		product_equips = [{"goods",200061, 0, 1}]
	};

get(21) ->
	#fusion_conf{
		key = 21,
		rate = 10000,
		type = 5,
		sub_type = 107,
		stuff = [{"goods",200035,1},{"goods",110109,7},{"coin",200000}],
		wear_equips = 200035,
		product = [{"goods",200062, 0, 1}],
		product_equips = [{"goods",200062, 0, 1}]
	};

get(22) ->
	#fusion_conf{
		key = 22,
		rate = 10000,
		type = 5,
		sub_type = 107,
		stuff = [{"goods",200032,1},{"goods",110109,7},{"coin",200000}],
		wear_equips = 200032,
		product = [{"goods",200063, 0, 1}],
		product_equips = [{"goods",200063, 0, 1}]
	};

get(23) ->
	#fusion_conf{
		key = 23,
		rate = 10000,
		type = 5,
		sub_type = 107,
		stuff = [{"goods",200036,1},{"goods",110109,7},{"coin",200000}],
		wear_equips = 200036,
		product = [{"goods",200065, 0, 1}],
		product_equips = [{"goods",200065, 0, 1}]
	};

get(24) ->
	#fusion_conf{
		key = 24,
		rate = 10000,
		type = 5,
		sub_type = 107,
		stuff = [{"goods",200033,1},{"goods",110109,7},{"coin",200000}],
		wear_equips = 200033,
		product = [{"goods",200066, 0, 1}],
		product_equips = [{"goods",200066, 0, 1}]
	};

get(25) ->
	#fusion_conf{
		key = 25,
		rate = 10000,
		type = 5,
		sub_type = 107,
		stuff = [{"goods",200037,1},{"goods",110109,7},{"coin",200000}],
		wear_equips = 200037,
		product = [{"goods",200067, 0, 1}],
		product_equips = [{"goods",200067, 0, 1}]
	};

get(26) ->
	#fusion_conf{
		key = 26,
		rate = 10000,
		type = 5,
		sub_type = 107,
		stuff = [{"goods",200039,1},{"goods",110109,7},{"coin",200000}],
		wear_equips = 200039,
		product = [{"goods",200069, 0, 1}],
		product_equips = [{"goods",200069, 0, 1}]
	};

get(27) ->
	#fusion_conf{
		key = 27,
		rate = 10000,
		type = 5,
		sub_type = 108,
		stuff = [{"goods",200060,1},{"goods",110163,30},{"goods",110109,16},{"coin",400000}],
		wear_equips = 200060,
		product = [{"goods",200070, 0, 1}],
		product_equips = [{"goods",200070, 0, 1}]
	};

get(28) ->
	#fusion_conf{
		key = 28,
		rate = 10000,
		type = 5,
		sub_type = 108,
		stuff = [{"goods",200061,1},{"goods",110163,20},{"goods",110109,10},{"coin",400000}],
		wear_equips = 200061,
		product = [{"goods",200071, 0, 1}],
		product_equips = [{"goods",200071, 0, 1}]
	};

get(29) ->
	#fusion_conf{
		key = 29,
		rate = 10000,
		type = 5,
		sub_type = 108,
		stuff = [{"goods",200063,1},{"goods",110163,10},{"goods",110109,6},{"coin",400000}],
		wear_equips = 200063,
		product = [{"goods",200072, 0, 1}],
		product_equips = [{"goods",200072, 0, 1}]
	};

get(30) ->
	#fusion_conf{
		key = 30,
		rate = 10000,
		type = 5,
		sub_type = 108,
		stuff = [{"goods",200066,1},{"goods",110163,10},{"goods",110109,6},{"coin",400000}],
		wear_equips = 200066,
		product = [{"goods",200073, 0, 1}],
		product_equips = [{"goods",200073, 0, 1}]
	};

get(31) ->
	#fusion_conf{
		key = 31,
		rate = 10000,
		type = 5,
		sub_type = 108,
		stuff = [{"goods",200062,1},{"goods",110163,10},{"goods",110109,6},{"coin",400000}],
		wear_equips = 200062,
		product = [{"goods",200075, 0, 1}],
		product_equips = [{"goods",200075, 0, 1}]
	};

get(32) ->
	#fusion_conf{
		key = 32,
		rate = 10000,
		type = 5,
		sub_type = 108,
		stuff = [{"goods",200065,1},{"goods",110163,10},{"goods",110109,6},{"coin",400000}],
		wear_equips = 200065,
		product = [{"goods",200076, 0, 1}],
		product_equips = [{"goods",200076, 0, 1}]
	};

get(33) ->
	#fusion_conf{
		key = 33,
		rate = 10000,
		type = 5,
		sub_type = 108,
		stuff = [{"goods",200067,1},{"goods",110163,10},{"goods",110109,6},{"coin",400000}],
		wear_equips = 200067,
		product = [{"goods",200077, 0, 1}],
		product_equips = [{"goods",200077, 0, 1}]
	};

get(34) ->
	#fusion_conf{
		key = 34,
		rate = 10000,
		type = 5,
		sub_type = 108,
		stuff = [{"goods",200069,1},{"goods",110163,10},{"goods",110109,6},{"coin",400000}],
		wear_equips = 200069,
		product = [{"goods",200079, 0, 1}],
		product_equips = [{"goods",200079, 0, 1}]
	};

get(35) ->
	#fusion_conf{
		key = 35,
		rate = 10000,
		type = 1,
		sub_type = 203,
		stuff = [{"goods",110010,40},{"coin",50000}],
		wear_equips = 0,
		product = [{"goods",201020, 0, 1}],
		product_equips = [{"goods",201020, 0, 1}]
	};

get(36) ->
	#fusion_conf{
		key = 36,
		rate = 10000,
		type = 1,
		sub_type = 203,
		stuff = [{"goods",110010,30},{"coin",50000}],
		wear_equips = 0,
		product = [{"goods",201021, 0, 1}],
		product_equips = [{"goods",201021, 0, 1}]
	};

get(37) ->
	#fusion_conf{
		key = 37,
		rate = 10000,
		type = 1,
		sub_type = 203,
		stuff = [{"goods",110010,20},{"coin",50000}],
		wear_equips = 0,
		product = [{"goods",201022, 0, 1}],
		product_equips = [{"goods",201022, 0, 1}]
	};

get(38) ->
	#fusion_conf{
		key = 38,
		rate = 10000,
		type = 1,
		sub_type = 203,
		stuff = [{"goods",110010,20},{"coin",50000}],
		wear_equips = 0,
		product = [{"goods",201023, 0, 1}],
		product_equips = [{"goods",201023, 0, 1}]
	};

get(39) ->
	#fusion_conf{
		key = 39,
		rate = 10000,
		type = 1,
		sub_type = 203,
		stuff = [{"goods",110010,20},{"coin",50000}],
		wear_equips = 0,
		product = [{"goods",201025, 0, 1}],
		product_equips = [{"goods",201025, 0, 1}]
	};

get(40) ->
	#fusion_conf{
		key = 40,
		rate = 10000,
		type = 1,
		sub_type = 203,
		stuff = [{"goods",110010,20},{"coin",50000}],
		wear_equips = 0,
		product = [{"goods",201026, 0, 1}],
		product_equips = [{"goods",201026, 0, 1}]
	};

get(41) ->
	#fusion_conf{
		key = 41,
		rate = 10000,
		type = 1,
		sub_type = 203,
		stuff = [{"goods",110010,20},{"coin",50000}],
		wear_equips = 0,
		product = [{"goods",201027, 0, 1}],
		product_equips = [{"goods",201027, 0, 1}]
	};

get(42) ->
	#fusion_conf{
		key = 42,
		rate = 10000,
		type = 1,
		sub_type = 203,
		stuff = [{"goods",110010,20},{"coin",50000}],
		wear_equips = 0,
		product = [{"goods",201029, 0, 1}],
		product_equips = [{"goods",201029, 0, 1}]
	};

get(43) ->
	#fusion_conf{
		key = 43,
		rate = 10000,
		type = 1,
		sub_type = 204,
		stuff = [{"goods",110013,80},{"coin",100000}],
		wear_equips = 0,
		product = [{"goods",305019, 0, 1}],
		product_equips = [{"goods",305019, 0, 1}]
	};

get(44) ->
	#fusion_conf{
		key = 44,
		rate = 10000,
		type = 1,
		sub_type = 205,
		stuff = [{"goods",110109,6},{"coin",100000}],
		wear_equips = 0,
		product = [{"goods",201030, 0, 1}],
		product_equips = [{"goods",201030, 0, 1}]
	};

get(45) ->
	#fusion_conf{
		key = 45,
		rate = 10000,
		type = 1,
		sub_type = 205,
		stuff = [{"goods",110109,4},{"coin",100000}],
		wear_equips = 0,
		product = [{"goods",201031, 0, 1}],
		product_equips = [{"goods",201031, 0, 1}]
	};

get(46) ->
	#fusion_conf{
		key = 46,
		rate = 10000,
		type = 1,
		sub_type = 205,
		stuff = [{"goods",110109,2},{"coin",100000}],
		wear_equips = 0,
		product = [{"goods",201032, 0, 1}],
		product_equips = [{"goods",201032, 0, 1}]
	};

get(47) ->
	#fusion_conf{
		key = 47,
		rate = 10000,
		type = 1,
		sub_type = 205,
		stuff = [{"goods",110109,2},{"coin",100000}],
		wear_equips = 0,
		product = [{"goods",201033, 0, 1}],
		product_equips = [{"goods",201033, 0, 1}]
	};

get(48) ->
	#fusion_conf{
		key = 48,
		rate = 10000,
		type = 1,
		sub_type = 205,
		stuff = [{"goods",110109,2},{"coin",100000}],
		wear_equips = 0,
		product = [{"goods",201035, 0, 1}],
		product_equips = [{"goods",201035, 0, 1}]
	};

get(49) ->
	#fusion_conf{
		key = 49,
		rate = 10000,
		type = 1,
		sub_type = 205,
		stuff = [{"goods",110109,2},{"coin",100000}],
		wear_equips = 0,
		product = [{"goods",201036, 0, 1}],
		product_equips = [{"goods",201036, 0, 1}]
	};

get(50) ->
	#fusion_conf{
		key = 50,
		rate = 10000,
		type = 1,
		sub_type = 205,
		stuff = [{"goods",110109,2},{"coin",100000}],
		wear_equips = 0,
		product = [{"goods",201037, 0, 1}],
		product_equips = [{"goods",201037, 0, 1}]
	};

get(51) ->
	#fusion_conf{
		key = 51,
		rate = 10000,
		type = 1,
		sub_type = 205,
		stuff = [{"goods",110109,2},{"coin",100000}],
		wear_equips = 0,
		product = [{"goods",201039, 0, 1}],
		product_equips = [{"goods",201039, 0, 1}]
	};

get(52) ->
	#fusion_conf{
		key = 52,
		rate = 10000,
		type = 1,
		sub_type = 204,
		stuff = [{"goods",110016,160},{"coin",150000}],
		wear_equips = 0,
		product = [{"goods",305020, 0, 1}],
		product_equips = [{"goods",305020, 0, 1}]
	};

get(53) ->
	#fusion_conf{
		key = 53,
		rate = 10000,
		type = 5,
		sub_type = 207,
		stuff = [{"goods",201030,1},{"goods",110109,15},{"coin",200000}],
		wear_equips = 201030,
		product = [{"goods",201060, 0, 1}],
		product_equips = [{"goods",201060, 0, 1}]
	};

get(54) ->
	#fusion_conf{
		key = 54,
		rate = 10000,
		type = 5,
		sub_type = 207,
		stuff = [{"goods",201031,1},{"goods",110109,10},{"coin",200000}],
		wear_equips = 201031,
		product = [{"goods",201061, 0, 1}],
		product_equips = [{"goods",201061, 0, 1}]
	};

get(55) ->
	#fusion_conf{
		key = 55,
		rate = 10000,
		type = 5,
		sub_type = 207,
		stuff = [{"goods",201035,1},{"goods",110109,7},{"coin",200000}],
		wear_equips = 201035,
		product = [{"goods",201062, 0, 1}],
		product_equips = [{"goods",201062, 0, 1}]
	};

get(56) ->
	#fusion_conf{
		key = 56,
		rate = 10000,
		type = 5,
		sub_type = 207,
		stuff = [{"goods",201032,1},{"goods",110109,7},{"coin",200000}],
		wear_equips = 201032,
		product = [{"goods",201063, 0, 1}],
		product_equips = [{"goods",201063, 0, 1}]
	};

get(57) ->
	#fusion_conf{
		key = 57,
		rate = 10000,
		type = 5,
		sub_type = 207,
		stuff = [{"goods",201036,1},{"goods",110109,7},{"coin",200000}],
		wear_equips = 201036,
		product = [{"goods",201065, 0, 1}],
		product_equips = [{"goods",201065, 0, 1}]
	};

get(58) ->
	#fusion_conf{
		key = 58,
		rate = 10000,
		type = 5,
		sub_type = 207,
		stuff = [{"goods",201033,1},{"goods",110109,7},{"coin",200000}],
		wear_equips = 201033,
		product = [{"goods",201066, 0, 1}],
		product_equips = [{"goods",201066, 0, 1}]
	};

get(59) ->
	#fusion_conf{
		key = 59,
		rate = 10000,
		type = 5,
		sub_type = 207,
		stuff = [{"goods",201037,1},{"goods",110109,7},{"coin",200000}],
		wear_equips = 201037,
		product = [{"goods",201067, 0, 1}],
		product_equips = [{"goods",201067, 0, 1}]
	};

get(60) ->
	#fusion_conf{
		key = 60,
		rate = 10000,
		type = 5,
		sub_type = 207,
		stuff = [{"goods",201039,1},{"goods",110109,7},{"coin",200000}],
		wear_equips = 201039,
		product = [{"goods",201069, 0, 1}],
		product_equips = [{"goods",201069, 0, 1}]
	};

get(61) ->
	#fusion_conf{
		key = 61,
		rate = 10000,
		type = 5,
		sub_type = 208,
		stuff = [{"goods",201060,1},{"goods",110163,30},{"goods",110109,16},{"coin",400000}],
		wear_equips = 201060,
		product = [{"goods",201070, 0, 1}],
		product_equips = [{"goods",201070, 0, 1}]
	};

get(62) ->
	#fusion_conf{
		key = 62,
		rate = 10000,
		type = 5,
		sub_type = 208,
		stuff = [{"goods",201061,1},{"goods",110163,20},{"goods",110109,10},{"coin",400000}],
		wear_equips = 201061,
		product = [{"goods",201071, 0, 1}],
		product_equips = [{"goods",201071, 0, 1}]
	};

get(63) ->
	#fusion_conf{
		key = 63,
		rate = 10000,
		type = 5,
		sub_type = 208,
		stuff = [{"goods",201063,1},{"goods",110163,10},{"goods",110109,6},{"coin",400000}],
		wear_equips = 201063,
		product = [{"goods",201072, 0, 1}],
		product_equips = [{"goods",201072, 0, 1}]
	};

get(64) ->
	#fusion_conf{
		key = 64,
		rate = 10000,
		type = 5,
		sub_type = 208,
		stuff = [{"goods",201066,1},{"goods",110163,10},{"goods",110109,6},{"coin",400000}],
		wear_equips = 201066,
		product = [{"goods",201073, 0, 1}],
		product_equips = [{"goods",201073, 0, 1}]
	};

get(65) ->
	#fusion_conf{
		key = 65,
		rate = 10000,
		type = 5,
		sub_type = 208,
		stuff = [{"goods",201062,1},{"goods",110163,10},{"goods",110109,6},{"coin",400000}],
		wear_equips = 201062,
		product = [{"goods",201075, 0, 1}],
		product_equips = [{"goods",201075, 0, 1}]
	};

get(66) ->
	#fusion_conf{
		key = 66,
		rate = 10000,
		type = 5,
		sub_type = 208,
		stuff = [{"goods",201065,1},{"goods",110163,10},{"goods",110109,6},{"coin",400000}],
		wear_equips = 201065,
		product = [{"goods",201076, 0, 1}],
		product_equips = [{"goods",201076, 0, 1}]
	};

get(67) ->
	#fusion_conf{
		key = 67,
		rate = 10000,
		type = 5,
		sub_type = 208,
		stuff = [{"goods",201067,1},{"goods",110163,10},{"goods",110109,6},{"coin",400000}],
		wear_equips = 201067,
		product = [{"goods",201077, 0, 1}],
		product_equips = [{"goods",201077, 0, 1}]
	};

get(68) ->
	#fusion_conf{
		key = 68,
		rate = 10000,
		type = 5,
		sub_type = 208,
		stuff = [{"goods",201069,1},{"goods",110163,10},{"goods",110109,6},{"coin",400000}],
		wear_equips = 201069,
		product = [{"goods",201079, 0, 1}],
		product_equips = [{"goods",201079, 0, 1}]
	};

get(69) ->
	#fusion_conf{
		key = 69,
		rate = 10000,
		type = 1,
		sub_type = 303,
		stuff = [{"goods",110010,40},{"coin",50000}],
		wear_equips = 0,
		product = [{"goods",202020, 0, 1}],
		product_equips = [{"goods",202020, 0, 1}]
	};

get(70) ->
	#fusion_conf{
		key = 70,
		rate = 10000,
		type = 1,
		sub_type = 303,
		stuff = [{"goods",110010,30},{"coin",50000}],
		wear_equips = 0,
		product = [{"goods",202021, 0, 1}],
		product_equips = [{"goods",202021, 0, 1}]
	};

get(71) ->
	#fusion_conf{
		key = 71,
		rate = 10000,
		type = 1,
		sub_type = 303,
		stuff = [{"goods",110010,20},{"coin",50000}],
		wear_equips = 0,
		product = [{"goods",202022, 0, 1}],
		product_equips = [{"goods",202022, 0, 1}]
	};

get(72) ->
	#fusion_conf{
		key = 72,
		rate = 10000,
		type = 1,
		sub_type = 303,
		stuff = [{"goods",110010,20},{"coin",50000}],
		wear_equips = 0,
		product = [{"goods",202023, 0, 1}],
		product_equips = [{"goods",202023, 0, 1}]
	};

get(73) ->
	#fusion_conf{
		key = 73,
		rate = 10000,
		type = 1,
		sub_type = 303,
		stuff = [{"goods",110010,20},{"coin",50000}],
		wear_equips = 0,
		product = [{"goods",202025, 0, 1}],
		product_equips = [{"goods",202025, 0, 1}]
	};

get(74) ->
	#fusion_conf{
		key = 74,
		rate = 10000,
		type = 1,
		sub_type = 303,
		stuff = [{"goods",110010,20},{"coin",50000}],
		wear_equips = 0,
		product = [{"goods",202026, 0, 1}],
		product_equips = [{"goods",202026, 0, 1}]
	};

get(75) ->
	#fusion_conf{
		key = 75,
		rate = 10000,
		type = 1,
		sub_type = 303,
		stuff = [{"goods",110010,20},{"coin",50000}],
		wear_equips = 0,
		product = [{"goods",202027, 0, 1}],
		product_equips = [{"goods",202027, 0, 1}]
	};

get(76) ->
	#fusion_conf{
		key = 76,
		rate = 10000,
		type = 1,
		sub_type = 303,
		stuff = [{"goods",110010,20},{"coin",50000}],
		wear_equips = 0,
		product = [{"goods",202029, 0, 1}],
		product_equips = [{"goods",202029, 0, 1}]
	};

get(77) ->
	#fusion_conf{
		key = 77,
		rate = 10000,
		type = 1,
		sub_type = 304,
		stuff = [{"goods",110013,80},{"coin",100000}],
		wear_equips = 0,
		product = [{"goods",305019, 0, 1}],
		product_equips = [{"goods",305019, 0, 1}]
	};

get(78) ->
	#fusion_conf{
		key = 78,
		rate = 10000,
		type = 1,
		sub_type = 305,
		stuff = [{"goods",110109,6},{"coin",100000}],
		wear_equips = 0,
		product = [{"goods",202030, 0, 1}],
		product_equips = [{"goods",202030, 0, 1}]
	};

get(79) ->
	#fusion_conf{
		key = 79,
		rate = 10000,
		type = 1,
		sub_type = 305,
		stuff = [{"goods",110109,4},{"coin",100000}],
		wear_equips = 0,
		product = [{"goods",202031, 0, 1}],
		product_equips = [{"goods",202031, 0, 1}]
	};

get(80) ->
	#fusion_conf{
		key = 80,
		rate = 10000,
		type = 1,
		sub_type = 305,
		stuff = [{"goods",110109,2},{"coin",100000}],
		wear_equips = 0,
		product = [{"goods",202032, 0, 1}],
		product_equips = [{"goods",202032, 0, 1}]
	};

get(81) ->
	#fusion_conf{
		key = 81,
		rate = 10000,
		type = 1,
		sub_type = 305,
		stuff = [{"goods",110109,2},{"coin",100000}],
		wear_equips = 0,
		product = [{"goods",202033, 0, 1}],
		product_equips = [{"goods",202033, 0, 1}]
	};

get(82) ->
	#fusion_conf{
		key = 82,
		rate = 10000,
		type = 1,
		sub_type = 305,
		stuff = [{"goods",110109,2},{"coin",100000}],
		wear_equips = 0,
		product = [{"goods",202035, 0, 1}],
		product_equips = [{"goods",202035, 0, 1}]
	};

get(83) ->
	#fusion_conf{
		key = 83,
		rate = 10000,
		type = 1,
		sub_type = 305,
		stuff = [{"goods",110109,2},{"coin",100000}],
		wear_equips = 0,
		product = [{"goods",202036, 0, 1}],
		product_equips = [{"goods",202036, 0, 1}]
	};

get(84) ->
	#fusion_conf{
		key = 84,
		rate = 10000,
		type = 1,
		sub_type = 305,
		stuff = [{"goods",110109,2},{"coin",100000}],
		wear_equips = 0,
		product = [{"goods",202037, 0, 1}],
		product_equips = [{"goods",202037, 0, 1}]
	};

get(85) ->
	#fusion_conf{
		key = 85,
		rate = 10000,
		type = 1,
		sub_type = 305,
		stuff = [{"goods",110109,2},{"coin",100000}],
		wear_equips = 0,
		product = [{"goods",202039, 0, 1}],
		product_equips = [{"goods",202039, 0, 1}]
	};

get(86) ->
	#fusion_conf{
		key = 86,
		rate = 10000,
		type = 1,
		sub_type = 304,
		stuff = [{"goods",110016,160},{"coin",150000}],
		wear_equips = 0,
		product = [{"goods",305020, 0, 1}],
		product_equips = [{"goods",305020, 0, 1}]
	};

get(87) ->
	#fusion_conf{
		key = 87,
		rate = 10000,
		type = 5,
		sub_type = 307,
		stuff = [{"goods",202030,1},{"goods",110109,15},{"coin",200000}],
		wear_equips = 202030,
		product = [{"goods",202060, 0, 1}],
		product_equips = [{"goods",202060, 0, 1}]
	};

get(88) ->
	#fusion_conf{
		key = 88,
		rate = 10000,
		type = 5,
		sub_type = 307,
		stuff = [{"goods",202031,1},{"goods",110109,10},{"coin",200000}],
		wear_equips = 202031,
		product = [{"goods",202061, 0, 1}],
		product_equips = [{"goods",202061, 0, 1}]
	};

get(89) ->
	#fusion_conf{
		key = 89,
		rate = 10000,
		type = 5,
		sub_type = 307,
		stuff = [{"goods",202035,1},{"goods",110109,7},{"coin",200000}],
		wear_equips = 202035,
		product = [{"goods",202062, 0, 1}],
		product_equips = [{"goods",202062, 0, 1}]
	};

get(90) ->
	#fusion_conf{
		key = 90,
		rate = 10000,
		type = 5,
		sub_type = 307,
		stuff = [{"goods",202032,1},{"goods",110109,7},{"coin",200000}],
		wear_equips = 202032,
		product = [{"goods",202063, 0, 1}],
		product_equips = [{"goods",202063, 0, 1}]
	};

get(91) ->
	#fusion_conf{
		key = 91,
		rate = 10000,
		type = 5,
		sub_type = 307,
		stuff = [{"goods",202036,1},{"goods",110109,7},{"coin",200000}],
		wear_equips = 202036,
		product = [{"goods",202065, 0, 1}],
		product_equips = [{"goods",202065, 0, 1}]
	};

get(92) ->
	#fusion_conf{
		key = 92,
		rate = 10000,
		type = 5,
		sub_type = 307,
		stuff = [{"goods",202033,1},{"goods",110109,7},{"coin",200000}],
		wear_equips = 202033,
		product = [{"goods",202066, 0, 1}],
		product_equips = [{"goods",202066, 0, 1}]
	};

get(93) ->
	#fusion_conf{
		key = 93,
		rate = 10000,
		type = 5,
		sub_type = 307,
		stuff = [{"goods",202037,1},{"goods",110109,7},{"coin",200000}],
		wear_equips = 202037,
		product = [{"goods",202067, 0, 1}],
		product_equips = [{"goods",202067, 0, 1}]
	};

get(94) ->
	#fusion_conf{
		key = 94,
		rate = 10000,
		type = 5,
		sub_type = 307,
		stuff = [{"goods",202039,1},{"goods",110109,7},{"coin",200000}],
		wear_equips = 202039,
		product = [{"goods",202069, 0, 1}],
		product_equips = [{"goods",202069, 0, 1}]
	};

get(95) ->
	#fusion_conf{
		key = 95,
		rate = 10000,
		type = 5,
		sub_type = 308,
		stuff = [{"goods",202060,1},{"goods",110163,30},{"goods",110109,16},{"coin",400000}],
		wear_equips = 202060,
		product = [{"goods",202070, 0, 1}],
		product_equips = [{"goods",202070, 0, 1}]
	};

get(96) ->
	#fusion_conf{
		key = 96,
		rate = 10000,
		type = 5,
		sub_type = 308,
		stuff = [{"goods",202061,1},{"goods",110163,20},{"goods",110109,10},{"coin",400000}],
		wear_equips = 202061,
		product = [{"goods",202071, 0, 1}],
		product_equips = [{"goods",202071, 0, 1}]
	};

get(97) ->
	#fusion_conf{
		key = 97,
		rate = 10000,
		type = 5,
		sub_type = 308,
		stuff = [{"goods",202063,1},{"goods",110163,10},{"goods",110109,6},{"coin",400000}],
		wear_equips = 202063,
		product = [{"goods",202072, 0, 1}],
		product_equips = [{"goods",202072, 0, 1}]
	};

get(98) ->
	#fusion_conf{
		key = 98,
		rate = 10000,
		type = 5,
		sub_type = 308,
		stuff = [{"goods",202066,1},{"goods",110163,10},{"goods",110109,6},{"coin",400000}],
		wear_equips = 202066,
		product = [{"goods",202073, 0, 1}],
		product_equips = [{"goods",202073, 0, 1}]
	};

get(99) ->
	#fusion_conf{
		key = 99,
		rate = 10000,
		type = 5,
		sub_type = 308,
		stuff = [{"goods",202062,1},{"goods",110163,10},{"goods",110109,6},{"coin",400000}],
		wear_equips = 202062,
		product = [{"goods",202075, 0, 1}],
		product_equips = [{"goods",202075, 0, 1}]
	};

get(100) ->
	#fusion_conf{
		key = 100,
		rate = 10000,
		type = 5,
		sub_type = 308,
		stuff = [{"goods",202065,1},{"goods",110163,10},{"goods",110109,6},{"coin",400000}],
		wear_equips = 202065,
		product = [{"goods",202076, 0, 1}],
		product_equips = [{"goods",202076, 0, 1}]
	};

get(101) ->
	#fusion_conf{
		key = 101,
		rate = 10000,
		type = 5,
		sub_type = 308,
		stuff = [{"goods",202067,1},{"goods",110163,10},{"goods",110109,6},{"coin",400000}],
		wear_equips = 202067,
		product = [{"goods",202077, 0, 1}],
		product_equips = [{"goods",202077, 0, 1}]
	};

get(102) ->
	#fusion_conf{
		key = 102,
		rate = 10000,
		type = 5,
		sub_type = 308,
		stuff = [{"goods",202069,1},{"goods",110163,10},{"goods",110109,6},{"coin",400000}],
		wear_equips = 202069,
		product = [{"goods",202079, 0, 1}],
		product_equips = [{"goods",202079, 0, 1}]
	};

get(103) ->
	#fusion_conf{
		key = 103,
		rate = 10000,
		type = 3,
		sub_type = 101,
		stuff = [{"goods",110079,2}],
		wear_equips = 0,
		product = [{"goods",110080, 0, 1}],
		product_equips = [{"goods",110080, 0, 1}]
	};

get(104) ->
	#fusion_conf{
		key = 104,
		rate = 10000,
		type = 3,
		sub_type = 101,
		stuff = [{"goods",110080,2}],
		wear_equips = 0,
		product = [{"goods",110081, 0, 1}],
		product_equips = [{"goods",110081, 0, 1}]
	};

get(105) ->
	#fusion_conf{
		key = 105,
		rate = 10000,
		type = 3,
		sub_type = 101,
		stuff = [{"goods",110081,2}],
		wear_equips = 0,
		product = [{"goods",110082, 0, 1}],
		product_equips = [{"goods",110082, 0, 1}]
	};

get(106) ->
	#fusion_conf{
		key = 106,
		rate = 10000,
		type = 4,
		sub_type = 101,
		stuff = [{"jade",20},{"coin",1000000}],
		wear_equips = 0,
		product = [{"goods",110050,0,1}],
		product_equips = [{"goods",110050,0,1}]
	};

get(107) ->
	#fusion_conf{
		key = 107,
		rate = 10000,
		type = 4,
		sub_type = 102,
		stuff = [{"goods",110050,5}],
		wear_equips = 0,
		product = [{"goods",110131,0,1}],
		product_equips = [{"goods",110131,0,1}]
	};

get(108) ->
	#fusion_conf{
		key = 108,
		rate = 10000,
		type = 3,
		sub_type = 101,
		stuff = [{"goods",110082,2}],
		wear_equips = 0,
		product = [{"goods",110083, 0, 1}],
		product_equips = [{"goods",110083, 0, 1}]
	};

get(109) ->
	#fusion_conf{
		key = 109,
		rate = 10000,
		type = 3,
		sub_type = 101,
		stuff = [{"goods",110083,2}],
		wear_equips = 0,
		product = [{"goods",110084, 0, 1}],
		product_equips = [{"goods",110084, 0, 1}]
	};

get(110) ->
	#fusion_conf{
		key = 110,
		rate = 10000,
		type = 3,
		sub_type = 101,
		stuff = [{"goods",110084,2}],
		wear_equips = 0,
		product = [{"goods",110085, 0, 1}],
		product_equips = [{"goods",110085, 0, 1}]
	};

get(111) ->
	#fusion_conf{
		key = 111,
		rate = 10000,
		type = 3,
		sub_type = 101,
		stuff = [{"goods",110085,2}],
		wear_equips = 0,
		product = [{"goods",110086, 0, 1}],
		product_equips = [{"goods",110086, 0, 1}]
	};

get(112) ->
	#fusion_conf{
		key = 112,
		rate = 10000,
		type = 3,
		sub_type = 101,
		stuff = [{"goods",110086,2}],
		wear_equips = 0,
		product = [{"goods",110087, 0, 1}],
		product_equips = [{"goods",110087, 0, 1}]
	};

get(113) ->
	#fusion_conf{
		key = 113,
		rate = 10000,
		type = 3,
		sub_type = 101,
		stuff = [{"goods",110087,2}],
		wear_equips = 0,
		product = [{"goods",110088, 0, 1}],
		product_equips = [{"goods",110088, 0, 1}]
	};

get(114) ->
	#fusion_conf{
		key = 114,
		rate = 10000,
		type = 3,
		sub_type = 101,
		stuff = [{"goods",110089,2}],
		wear_equips = 0,
		product = [{"goods",110090, 0, 1}],
		product_equips = [{"goods",110090, 0, 1}]
	};

get(115) ->
	#fusion_conf{
		key = 115,
		rate = 10000,
		type = 3,
		sub_type = 101,
		stuff = [{"goods",110090,2}],
		wear_equips = 0,
		product = [{"goods",110091, 0, 1}],
		product_equips = [{"goods",110091, 0, 1}]
	};

get(116) ->
	#fusion_conf{
		key = 116,
		rate = 10000,
		type = 3,
		sub_type = 101,
		stuff = [{"goods",110091,2}],
		wear_equips = 0,
		product = [{"goods",110092, 0, 1}],
		product_equips = [{"goods",110092, 0, 1}]
	};

get(117) ->
	#fusion_conf{
		key = 117,
		rate = 10000,
		type = 3,
		sub_type = 101,
		stuff = [{"goods",110092,2}],
		wear_equips = 0,
		product = [{"goods",110093, 0, 1}],
		product_equips = [{"goods",110093, 0, 1}]
	};

get(118) ->
	#fusion_conf{
		key = 118,
		rate = 10000,
		type = 3,
		sub_type = 101,
		stuff = [{"goods",110093,2}],
		wear_equips = 0,
		product = [{"goods",110094, 0, 1}],
		product_equips = [{"goods",110094, 0, 1}]
	};

get(119) ->
	#fusion_conf{
		key = 119,
		rate = 10000,
		type = 3,
		sub_type = 101,
		stuff = [{"goods",110094,2}],
		wear_equips = 0,
		product = [{"goods",110095, 0, 1}],
		product_equips = [{"goods",110095, 0, 1}]
	};

get(120) ->
	#fusion_conf{
		key = 120,
		rate = 10000,
		type = 3,
		sub_type = 101,
		stuff = [{"goods",110099,2}],
		wear_equips = 0,
		product = [{"goods",110100, 0, 1}],
		product_equips = [{"goods",110100, 0, 1}]
	};

get(121) ->
	#fusion_conf{
		key = 121,
		rate = 10000,
		type = 3,
		sub_type = 101,
		stuff = [{"goods",110100,2}],
		wear_equips = 0,
		product = [{"goods",110101, 0, 1}],
		product_equips = [{"goods",110101, 0, 1}]
	};

get(122) ->
	#fusion_conf{
		key = 122,
		rate = 10000,
		type = 3,
		sub_type = 101,
		stuff = [{"goods",110101,2}],
		wear_equips = 0,
		product = [{"goods",110102, 0, 1}],
		product_equips = [{"goods",110102, 0, 1}]
	};

get(123) ->
	#fusion_conf{
		key = 123,
		rate = 10000,
		type = 3,
		sub_type = 101,
		stuff = [{"goods",110102,2}],
		wear_equips = 0,
		product = [{"goods",110103, 0, 1}],
		product_equips = [{"goods",110103, 0, 1}]
	};

get(124) ->
	#fusion_conf{
		key = 124,
		rate = 10000,
		type = 3,
		sub_type = 101,
		stuff = [{"goods",110103,2}],
		wear_equips = 0,
		product = [{"goods",110104, 0, 1}],
		product_equips = [{"goods",110104, 0, 1}]
	};

get(125) ->
	#fusion_conf{
		key = 125,
		rate = 10000,
		type = 5,
		sub_type = 109,
		stuff = [{"goods",200070,1},{"goods",110163,75},{"goods",110109,75},{"coin",800000}],
		wear_equips = 200070,
		product = [{"goods",200080, 0, 1}],
		product_equips = [{"goods",200080, 0, 1}]
	};

get(126) ->
	#fusion_conf{
		key = 126,
		rate = 10000,
		type = 5,
		sub_type = 109,
		stuff = [{"goods",200071,1},{"goods",110163,50},{"goods",110109,50},{"coin",800000}],
		wear_equips = 200071,
		product = [{"goods",200081, 0, 1}],
		product_equips = [{"goods",200081, 0, 1}]
	};

get(127) ->
	#fusion_conf{
		key = 127,
		rate = 10000,
		type = 5,
		sub_type = 109,
		stuff = [{"goods",200072,1},{"goods",110163,25},{"goods",110109,25},{"coin",800000}],
		wear_equips = 200072,
		product = [{"goods",200082, 0, 1}],
		product_equips = [{"goods",200082, 0, 1}]
	};

get(128) ->
	#fusion_conf{
		key = 128,
		rate = 10000,
		type = 5,
		sub_type = 109,
		stuff = [{"goods",200073,1},{"goods",110163,25},{"goods",110109,25},{"coin",800000}],
		wear_equips = 200073,
		product = [{"goods",200083, 0, 1}],
		product_equips = [{"goods",200083, 0, 1}]
	};

get(129) ->
	#fusion_conf{
		key = 129,
		rate = 10000,
		type = 5,
		sub_type = 109,
		stuff = [{"goods",200075,1},{"goods",110163,25},{"goods",110109,25},{"coin",800000}],
		wear_equips = 200075,
		product = [{"goods",200085, 0, 1}],
		product_equips = [{"goods",200085, 0, 1}]
	};

get(130) ->
	#fusion_conf{
		key = 130,
		rate = 10000,
		type = 5,
		sub_type = 109,
		stuff = [{"goods",200076,1},{"goods",110163,25},{"goods",110109,25},{"coin",800000}],
		wear_equips = 200076,
		product = [{"goods",200086, 0, 1}],
		product_equips = [{"goods",200086, 0, 1}]
	};

get(131) ->
	#fusion_conf{
		key = 131,
		rate = 10000,
		type = 5,
		sub_type = 109,
		stuff = [{"goods",200077,1},{"goods",110163,25},{"goods",110109,25},{"coin",800000}],
		wear_equips = 200077,
		product = [{"goods",200087, 0, 1}],
		product_equips = [{"goods",200087, 0, 1}]
	};

get(132) ->
	#fusion_conf{
		key = 132,
		rate = 10000,
		type = 5,
		sub_type = 109,
		stuff = [{"goods",200079,1},{"goods",110163,25},{"goods",110109,25},{"coin",800000}],
		wear_equips = 200079,
		product = [{"goods",200089, 0, 1}],
		product_equips = [{"goods",200089, 0, 1}]
	};

get(133) ->
	#fusion_conf{
		key = 133,
		rate = 10000,
		type = 5,
		sub_type = 209,
		stuff = [{"goods",201070,1},{"goods",110163,75},{"goods",110109,75},{"coin",800000}],
		wear_equips = 201070,
		product = [{"goods",201080, 0, 1}],
		product_equips = [{"goods",201080, 0, 1}]
	};

get(134) ->
	#fusion_conf{
		key = 134,
		rate = 10000,
		type = 5,
		sub_type = 209,
		stuff = [{"goods",201071,1},{"goods",110163,50},{"goods",110109,50},{"coin",800000}],
		wear_equips = 201071,
		product = [{"goods",201081, 0, 1}],
		product_equips = [{"goods",201081, 0, 1}]
	};

get(135) ->
	#fusion_conf{
		key = 135,
		rate = 10000,
		type = 5,
		sub_type = 209,
		stuff = [{"goods",201072,1},{"goods",110163,25},{"goods",110109,25},{"coin",800000}],
		wear_equips = 201072,
		product = [{"goods",201082, 0, 1}],
		product_equips = [{"goods",201082, 0, 1}]
	};

get(136) ->
	#fusion_conf{
		key = 136,
		rate = 10000,
		type = 5,
		sub_type = 209,
		stuff = [{"goods",201073,1},{"goods",110163,25},{"goods",110109,25},{"coin",800000}],
		wear_equips = 201073,
		product = [{"goods",201083, 0, 1}],
		product_equips = [{"goods",201083, 0, 1}]
	};

get(137) ->
	#fusion_conf{
		key = 137,
		rate = 10000,
		type = 5,
		sub_type = 209,
		stuff = [{"goods",201075,1},{"goods",110163,25},{"goods",110109,25},{"coin",800000}],
		wear_equips = 201075,
		product = [{"goods",201085, 0, 1}],
		product_equips = [{"goods",201085, 0, 1}]
	};

get(138) ->
	#fusion_conf{
		key = 138,
		rate = 10000,
		type = 5,
		sub_type = 209,
		stuff = [{"goods",201076,1},{"goods",110163,25},{"goods",110109,25},{"coin",800000}],
		wear_equips = 201076,
		product = [{"goods",201086, 0, 1}],
		product_equips = [{"goods",201086, 0, 1}]
	};

get(139) ->
	#fusion_conf{
		key = 139,
		rate = 10000,
		type = 5,
		sub_type = 209,
		stuff = [{"goods",201077,1},{"goods",110163,25},{"goods",110109,25},{"coin",800000}],
		wear_equips = 201077,
		product = [{"goods",201087, 0, 1}],
		product_equips = [{"goods",201087, 0, 1}]
	};

get(140) ->
	#fusion_conf{
		key = 140,
		rate = 10000,
		type = 5,
		sub_type = 209,
		stuff = [{"goods",201079,1},{"goods",110163,25},{"goods",110109,25},{"coin",800000}],
		wear_equips = 201079,
		product = [{"goods",201089, 0, 1}],
		product_equips = [{"goods",201089, 0, 1}]
	};

get(141) ->
	#fusion_conf{
		key = 141,
		rate = 10000,
		type = 5,
		sub_type = 309,
		stuff = [{"goods",202070,1},{"goods",110163,75},{"goods",110109,75},{"coin",800000}],
		wear_equips = 202070,
		product = [{"goods",202080, 0, 1}],
		product_equips = [{"goods",202080, 0, 1}]
	};

get(142) ->
	#fusion_conf{
		key = 142,
		rate = 10000,
		type = 5,
		sub_type = 309,
		stuff = [{"goods",202071,1},{"goods",110163,50},{"goods",110109,50},{"coin",800000}],
		wear_equips = 202071,
		product = [{"goods",202081, 0, 1}],
		product_equips = [{"goods",202081, 0, 1}]
	};

get(143) ->
	#fusion_conf{
		key = 143,
		rate = 10000,
		type = 5,
		sub_type = 309,
		stuff = [{"goods",202072,1},{"goods",110163,25},{"goods",110109,25},{"coin",800000}],
		wear_equips = 202072,
		product = [{"goods",202082, 0, 1}],
		product_equips = [{"goods",202082, 0, 1}]
	};

get(144) ->
	#fusion_conf{
		key = 144,
		rate = 10000,
		type = 5,
		sub_type = 309,
		stuff = [{"goods",202073,1},{"goods",110163,25},{"goods",110109,25},{"coin",800000}],
		wear_equips = 202073,
		product = [{"goods",202083, 0, 1}],
		product_equips = [{"goods",202083, 0, 1}]
	};

get(145) ->
	#fusion_conf{
		key = 145,
		rate = 10000,
		type = 5,
		sub_type = 309,
		stuff = [{"goods",202075,1},{"goods",110163,25},{"goods",110109,25},{"coin",800000}],
		wear_equips = 202075,
		product = [{"goods",202085, 0, 1}],
		product_equips = [{"goods",202085, 0, 1}]
	};

get(146) ->
	#fusion_conf{
		key = 146,
		rate = 10000,
		type = 5,
		sub_type = 309,
		stuff = [{"goods",202076,1},{"goods",110163,25},{"goods",110109,25},{"coin",800000}],
		wear_equips = 202076,
		product = [{"goods",202086, 0, 1}],
		product_equips = [{"goods",202086, 0, 1}]
	};

get(147) ->
	#fusion_conf{
		key = 147,
		rate = 10000,
		type = 5,
		sub_type = 309,
		stuff = [{"goods",202077,1},{"goods",110163,25},{"goods",110109,25},{"coin",800000}],
		wear_equips = 202077,
		product = [{"goods",202087, 0, 1}],
		product_equips = [{"goods",202087, 0, 1}]
	};

get(148) ->
	#fusion_conf{
		key = 148,
		rate = 10000,
		type = 5,
		sub_type = 309,
		stuff = [{"goods",202079,1},{"goods",110163,25},{"goods",110109,25},{"coin",800000}],
		wear_equips = 202079,
		product = [{"goods",202089, 0, 1}],
		product_equips = [{"goods",202089, 0, 1}]
	};

get(149) ->
	#fusion_conf{
		key = 149,
		rate = 10000,
		type = 6,
		sub_type = 101,
		stuff = [{"goods",110261,5},{"goods",110262,2}],
		wear_equips = 0,
		product = [{"goods",110264, 1, 1}],
		product_equips = [{"goods",110264, 1, 1}]
	};

get(150) ->
	#fusion_conf{
		key = 150,
		rate = 10000,
		type = 6,
		sub_type = 101,
		stuff = [{"goods",110261,2},{"goods",110263,1}],
		wear_equips = 0,
		product = [{"goods",110265, 1, 1}],
		product_equips = [{"goods",110265, 1, 1}]
	};

get(151) ->
	#fusion_conf{
		key = 151,
		rate = 10000,
		type = 6,
		sub_type = 101,
		stuff = [{"goods",110261,1},{"goods",110262,1},{"goods",110263,5}],
		wear_equips = 0,
		product = [{"goods",110266, 1, 1}],
		product_equips = [{"goods",110266, 1, 1}]
	};

get(152) ->
	#fusion_conf{
		key = 152,
		rate = 10000,
		type = 6,
		sub_type = 101,
		stuff = [{"goods",110285,5},{"goods",110286,2}],
		wear_equips = 0,
		product = [{"goods",110288, 1, 1}],
		product_equips = [{"goods",110288, 1, 1}]
	};

get(153) ->
	#fusion_conf{
		key = 153,
		rate = 10000,
		type = 6,
		sub_type = 101,
		stuff = [{"goods",110285,2},{"goods",110287,1}],
		wear_equips = 0,
		product = [{"goods",110289, 1, 1}],
		product_equips = [{"goods",110289, 1, 1}]
	};

get(154) ->
	#fusion_conf{
		key = 154,
		rate = 10000,
		type = 6,
		sub_type = 101,
		stuff = [{"goods",110285,1},{"goods",110286,1},{"goods",110287,5}],
		wear_equips = 0,
		product = [{"goods",110290, 1, 1}],
		product_equips = [{"goods",110290, 1, 1}]
	};

get(155) ->
	#fusion_conf{
		key = 155,
		rate = 10000,
		type = 6,
		sub_type = 101,
		stuff = [{"goods",110305,5},{"goods",110306,2}],
		wear_equips = 0,
		product = [{"goods",110308, 1, 1}],
		product_equips = [{"goods",110308, 1, 1}]
	};

get(156) ->
	#fusion_conf{
		key = 156,
		rate = 10000,
		type = 6,
		sub_type = 101,
		stuff = [{"goods",110305,2},{"goods",110307,1}],
		wear_equips = 0,
		product = [{"goods",110309, 1, 1}],
		product_equips = [{"goods",110309, 1, 1}]
	};

get(157) ->
	#fusion_conf{
		key = 157,
		rate = 10000,
		type = 6,
		sub_type = 101,
		stuff = [{"goods",110305,1},{"goods",110306,1},{"goods",110307,5}],
		wear_equips = 0,
		product = [{"goods",110310, 1, 1}],
		product_equips = [{"goods",110310, 1, 1}]
	};

get(158) ->
	#fusion_conf{
		key = 158,
		rate = 10000,
		type = 6,
		sub_type = 101,
		stuff = [{"goods",110079,10},{"goods",110080,10},{"goods",110081,20}],
		wear_equips = 0,
		product = [{"goods",200020, 1, 1}],
		product_equips = [{"goods",200020, 1, 1}]
	};

get(159) ->
	#fusion_conf{
		key = 159,
		rate = 10000,
		type = 6,
		sub_type = 101,
		stuff = [{"goods",110079,10},{"goods",110080,10},{"goods",110081,20}],
		wear_equips = 0,
		product = [{"goods",200020, 1, 1}],
		product_equips = [{"goods",200020, 1, 1}]
	};

get(160) ->
	#fusion_conf{
		key = 160,
		rate = 10000,
		type = 6,
		sub_type = 101,
		stuff = [{"goods",110079,10},{"goods",110080,10},{"goods",110081,20}],
		wear_equips = 0,
		product = [{"goods",200020, 1, 1}],
		product_equips = [{"goods",200020, 1, 1}]
	};

get(161) ->
	#fusion_conf{
		key = 161,
		rate = 10000,
		type = 6,
		sub_type = 101,
		stuff = [{"goods",110079,10},{"goods",110080,10},{"goods",110081,20}],
		wear_equips = 0,
		product = [{"goods",200020, 1, 1}],
		product_equips = [{"goods",200020, 1, 1}]
	};

get(162) ->
	#fusion_conf{
		key = 162,
		rate = 10000,
		type = 6,
		sub_type = 101,
		stuff = [{"goods",110079,10},{"goods",110080,10},{"goods",110081,20}],
		wear_equips = 0,
		product = [{"goods",200020, 1, 1}],
		product_equips = [{"goods",200020, 1, 1}]
	};

get(163) ->
	#fusion_conf{
		key = 163,
		rate = 10000,
		type = 6,
		sub_type = 101,
		stuff = [{"goods",110079,10},{"goods",110080,10},{"goods",110081,20}],
		wear_equips = 0,
		product = [{"goods",200020, 1, 1}],
		product_equips = [{"goods",200020, 1, 1}]
	};

get(164) ->
	#fusion_conf{
		key = 164,
		rate = 10000,
		type = 6,
		sub_type = 101,
		stuff = [{"goods",110079,10},{"goods",110080,10},{"goods",110081,20}],
		wear_equips = 0,
		product = [{"goods",200020, 1, 1}],
		product_equips = [{"goods",200020, 1, 1}]
	};

get(165) ->
	#fusion_conf{
		key = 165,
		rate = 10000,
		type = 6,
		sub_type = 101,
		stuff = [{"goods",110079,10},{"goods",110080,10},{"goods",110081,20}],
		wear_equips = 0,
		product = [{"goods",200020, 1, 1}],
		product_equips = [{"goods",200020, 1, 1}]
	};

get(166) ->
	#fusion_conf{
		key = 166,
		rate = 10000,
		type = 6,
		sub_type = 101,
		stuff = [{"goods",110079,10},{"goods",110080,10},{"goods",110081,20}],
		wear_equips = 0,
		product = [{"goods",200020, 1, 1}],
		product_equips = [{"goods",200020, 1, 1}]
	};

get(167) ->
	#fusion_conf{
		key = 167,
		rate = 10000,
		type = 6,
		sub_type = 101,
		stuff = [{"goods",110079,10},{"goods",110080,10},{"goods",110081,20}],
		wear_equips = 0,
		product = [{"goods",200020, 1, 1}],
		product_equips = [{"goods",200020, 1, 1}]
	};

get(168) ->
	#fusion_conf{
		key = 168,
		rate = 10000,
		type = 6,
		sub_type = 101,
		stuff = [{"goods",110079,10},{"goods",110080,10},{"goods",110081,20}],
		wear_equips = 0,
		product = [{"goods",200020, 1, 1}],
		product_equips = [{"goods",200020, 1, 1}]
	};

get(169) ->
	#fusion_conf{
		key = 169,
		rate = 10000,
		type = 6,
		sub_type = 101,
		stuff = [{"goods",110079,10},{"goods",110080,10},{"goods",110081,20}],
		wear_equips = 0,
		product = [{"goods",200020, 1, 1}],
		product_equips = [{"goods",200020, 1, 1}]
	};

get(170) ->
	#fusion_conf{
		key = 170,
		rate = 10000,
		type = 6,
		sub_type = 101,
		stuff = [{"goods",110079,10},{"goods",110080,10},{"goods",110081,20}],
		wear_equips = 0,
		product = [{"goods",200020, 1, 1}],
		product_equips = [{"goods",200020, 1, 1}]
	};

get(171) ->
	#fusion_conf{
		key = 171,
		rate = 10000,
		type = 6,
		sub_type = 101,
		stuff = [{"goods",110079,10},{"goods",110080,10},{"goods",110081,20}],
		wear_equips = 0,
		product = [{"goods",200020, 1, 1}],
		product_equips = [{"goods",200020, 1, 1}]
	};

get(172) ->
	#fusion_conf{
		key = 172,
		rate = 10000,
		type = 6,
		sub_type = 101,
		stuff = [{"goods",110079,10},{"goods",110080,10},{"goods",110081,20}],
		wear_equips = 0,
		product = [{"goods",200020, 1, 1}],
		product_equips = [{"goods",200020, 1, 1}]
	};

get(173) ->
	#fusion_conf{
		key = 173,
		rate = 10000,
		type = 6,
		sub_type = 101,
		stuff = [{"goods",110079,10},{"goods",110080,10},{"goods",110081,20}],
		wear_equips = 0,
		product = [{"goods",200020, 1, 1}],
		product_equips = [{"goods",200020, 1, 1}]
	};

get(174) ->
	#fusion_conf{
		key = 174,
		rate = 10000,
		type = 6,
		sub_type = 101,
		stuff = [{"goods",110079,10},{"goods",110080,10},{"goods",110081,20}],
		wear_equips = 0,
		product = [{"goods",200020, 1, 1}],
		product_equips = [{"goods",200020, 1, 1}]
	};

get(175) ->
	#fusion_conf{
		key = 175,
		rate = 10000,
		type = 6,
		sub_type = 101,
		stuff = [{"goods",110079,10},{"goods",110080,10},{"goods",110081,20}],
		wear_equips = 0,
		product = [{"goods",200020, 1, 1}],
		product_equips = [{"goods",200020, 1, 1}]
	};

get(176) ->
	#fusion_conf{
		key = 176,
		rate = 10000,
		type = 6,
		sub_type = 101,
		stuff = [{"goods",110079,10},{"goods",110080,10},{"goods",110081,20}],
		wear_equips = 0,
		product = [{"goods",200020, 1, 1}],
		product_equips = [{"goods",200020, 1, 1}]
	};

get(177) ->
	#fusion_conf{
		key = 177,
		rate = 10000,
		type = 6,
		sub_type = 101,
		stuff = [{"goods",110079,10},{"goods",110080,10},{"goods",110081,20}],
		wear_equips = 0,
		product = [{"goods",200020, 1, 1}],
		product_equips = [{"goods",200020, 1, 1}]
	};

get(178) ->
	#fusion_conf{
		key = 178,
		rate = 10000,
		type = 6,
		sub_type = 101,
		stuff = [{"goods",110079,10},{"goods",110080,10},{"goods",110081,20}],
		wear_equips = 0,
		product = [{"goods",200020, 1, 1}],
		product_equips = [{"goods",200020, 1, 1}]
	};

get(179) ->
	#fusion_conf{
		key = 179,
		rate = 10000,
		type = 5,
		sub_type = 110,
		stuff = [{"goods",200081,1},{"goods",110163,75},{"goods",110109,100},{"goods",110294,80},{"coin",1600000}],
		wear_equips = 200081,
		product = [{"goods",200091, 1, 1}],
		product_equips = [{"goods",200091, 0, 1}]
	};

get(180) ->
	#fusion_conf{
		key = 180,
		rate = 10000,
		type = 5,
		sub_type = 110,
		stuff = [{"goods",200082,1},{"goods",110163,38},{"goods",110109,50},{"goods",110294,40},{"coin",1600000}],
		wear_equips = 200082,
		product = [{"goods",200092, 1, 1}],
		product_equips = [{"goods",200092, 0, 1}]
	};

get(181) ->
	#fusion_conf{
		key = 181,
		rate = 10000,
		type = 5,
		sub_type = 110,
		stuff = [{"goods",200083,1},{"goods",110163,38},{"goods",110109,50},{"goods",110294,40},{"coin",1600000}],
		wear_equips = 200083,
		product = [{"goods",200093, 1, 1}],
		product_equips = [{"goods",200093, 0, 1}]
	};

get(182) ->
	#fusion_conf{
		key = 182,
		rate = 10000,
		type = 5,
		sub_type = 110,
		stuff = [{"goods",200085,1},{"goods",110163,38},{"goods",110109,50},{"goods",110294,40},{"coin",1600000}],
		wear_equips = 200085,
		product = [{"goods",200095, 1, 1}],
		product_equips = [{"goods",200095, 0, 1}]
	};

get(183) ->
	#fusion_conf{
		key = 183,
		rate = 10000,
		type = 5,
		sub_type = 110,
		stuff = [{"goods",200086,1},{"goods",110163,38},{"goods",110109,50},{"goods",110294,40},{"coin",1600000}],
		wear_equips = 200086,
		product = [{"goods",200096, 1, 1}],
		product_equips = [{"goods",200096, 0, 1}]
	};

get(184) ->
	#fusion_conf{
		key = 184,
		rate = 10000,
		type = 5,
		sub_type = 110,
		stuff = [{"goods",200087,1},{"goods",110163,38},{"goods",110109,50},{"goods",110294,40},{"coin",1600000}],
		wear_equips = 200087,
		product = [{"goods",200097, 1, 1}],
		product_equips = [{"goods",200097, 0, 1}]
	};

get(185) ->
	#fusion_conf{
		key = 185,
		rate = 10000,
		type = 5,
		sub_type = 110,
		stuff = [{"goods",200089,1},{"goods",110163,38},{"goods",110109,50},{"goods",110294,40},{"coin",1600000}],
		wear_equips = 200089,
		product = [{"goods",200099, 1, 1}],
		product_equips = [{"goods",200099, 0, 1}]
	};

get(186) ->
	#fusion_conf{
		key = 186,
		rate = 10000,
		type = 5,
		sub_type = 210,
		stuff = [{"goods",201081,1},{"goods",110163,75},{"goods",110109,100},{"goods",110294,80},{"coin",1600000}],
		wear_equips = 201081,
		product = [{"goods",201091, 1, 1}],
		product_equips = [{"goods",201091, 0, 1}]
	};

get(187) ->
	#fusion_conf{
		key = 187,
		rate = 10000,
		type = 5,
		sub_type = 210,
		stuff = [{"goods",201082,1},{"goods",110163,38},{"goods",110109,50},{"goods",110294,40},{"coin",1600000}],
		wear_equips = 201082,
		product = [{"goods",201092, 1, 1}],
		product_equips = [{"goods",201092, 0, 1}]
	};

get(188) ->
	#fusion_conf{
		key = 188,
		rate = 10000,
		type = 5,
		sub_type = 210,
		stuff = [{"goods",201083,1},{"goods",110163,38},{"goods",110109,50},{"goods",110294,40},{"coin",1600000}],
		wear_equips = 201083,
		product = [{"goods",201093, 1, 1}],
		product_equips = [{"goods",201093, 0, 1}]
	};

get(189) ->
	#fusion_conf{
		key = 189,
		rate = 10000,
		type = 5,
		sub_type = 210,
		stuff = [{"goods",201085,1},{"goods",110163,38},{"goods",110109,50},{"goods",110294,40},{"coin",1600000}],
		wear_equips = 201085,
		product = [{"goods",201095, 1, 1}],
		product_equips = [{"goods",201095, 0, 1}]
	};

get(190) ->
	#fusion_conf{
		key = 190,
		rate = 10000,
		type = 5,
		sub_type = 210,
		stuff = [{"goods",201086,1},{"goods",110163,38},{"goods",110109,50},{"goods",110294,40},{"coin",1600000}],
		wear_equips = 201086,
		product = [{"goods",201096, 1, 1}],
		product_equips = [{"goods",201096, 0, 1}]
	};

get(191) ->
	#fusion_conf{
		key = 191,
		rate = 10000,
		type = 5,
		sub_type = 210,
		stuff = [{"goods",201087,1},{"goods",110163,38},{"goods",110109,50},{"goods",110294,40},{"coin",1600000}],
		wear_equips = 201087,
		product = [{"goods",201097, 1, 1}],
		product_equips = [{"goods",201097, 0, 1}]
	};

get(192) ->
	#fusion_conf{
		key = 192,
		rate = 10000,
		type = 5,
		sub_type = 210,
		stuff = [{"goods",201089,1},{"goods",110163,38},{"goods",110109,50},{"goods",110294,40},{"coin",1600000}],
		wear_equips = 201089,
		product = [{"goods",201099, 1, 1}],
		product_equips = [{"goods",201099, 0, 1}]
	};

get(193) ->
	#fusion_conf{
		key = 193,
		rate = 10000,
		type = 5,
		sub_type = 310,
		stuff = [{"goods",202081,1},{"goods",110163,75},{"goods",110109,100},{"goods",110294,80},{"coin",1600000}],
		wear_equips = 202081,
		product = [{"goods",202091, 1, 1}],
		product_equips = [{"goods",202091, 0, 1}]
	};

get(194) ->
	#fusion_conf{
		key = 194,
		rate = 10000,
		type = 5,
		sub_type = 310,
		stuff = [{"goods",202082,1},{"goods",110163,38},{"goods",110109,50},{"goods",110294,40},{"coin",1600000}],
		wear_equips = 202082,
		product = [{"goods",202092, 1, 1}],
		product_equips = [{"goods",202092, 0, 1}]
	};

get(195) ->
	#fusion_conf{
		key = 195,
		rate = 10000,
		type = 5,
		sub_type = 310,
		stuff = [{"goods",202083,1},{"goods",110163,38},{"goods",110109,50},{"goods",110294,40},{"coin",1600000}],
		wear_equips = 202083,
		product = [{"goods",202093, 1, 1}],
		product_equips = [{"goods",202093, 0, 1}]
	};

get(196) ->
	#fusion_conf{
		key = 196,
		rate = 10000,
		type = 5,
		sub_type = 310,
		stuff = [{"goods",202085,1},{"goods",110163,38},{"goods",110109,50},{"goods",110294,40},{"coin",1600000}],
		wear_equips = 202085,
		product = [{"goods",202095, 1, 1}],
		product_equips = [{"goods",202095, 0, 1}]
	};

get(197) ->
	#fusion_conf{
		key = 197,
		rate = 10000,
		type = 5,
		sub_type = 310,
		stuff = [{"goods",202086,1},{"goods",110163,38},{"goods",110109,50},{"goods",110294,40},{"coin",1600000}],
		wear_equips = 202086,
		product = [{"goods",202096, 1, 1}],
		product_equips = [{"goods",202096, 0, 1}]
	};

get(198) ->
	#fusion_conf{
		key = 198,
		rate = 10000,
		type = 5,
		sub_type = 310,
		stuff = [{"goods",202087,1},{"goods",110163,38},{"goods",110109,50},{"goods",110294,40},{"coin",1600000}],
		wear_equips = 202087,
		product = [{"goods",202097, 1, 1}],
		product_equips = [{"goods",202097, 0, 1}]
	};

get(199) ->
	#fusion_conf{
		key = 199,
		rate = 10000,
		type = 5,
		sub_type = 310,
		stuff = [{"goods",202089,1},{"goods",110163,38},{"goods",110109,50},{"goods",110294,40},{"coin",1600000}],
		wear_equips = 202089,
		product = [{"goods",202099, 1, 1}],
		product_equips = [{"goods",202099, 0, 1}]
	};

get(200) ->
	#fusion_conf{
		key = 200,
		rate = 10000,
		type = 5,
		sub_type = 101,
		stuff = [{"goods",305000,1},{"goods",110304,160},{"coin",3200000}],
		wear_equips = 305000,
		product = [{"goods",305036, 1, 1}],
		product_equips = [{"goods",305036, 1, 1}]
	};

get(201) ->
	#fusion_conf{
		key = 201,
		rate = 10000,
		type = 5,
		sub_type = 101,
		stuff = [{"goods",305001,1},{"goods",110304,120},{"coin",3200000}],
		wear_equips = 305001,
		product = [{"goods",305037, 1, 1}],
		product_equips = [{"goods",305037, 1, 1}]
	};

get(202) ->
	#fusion_conf{
		key = 202,
		rate = 10000,
		type = 5,
		sub_type = 101,
		stuff = [{"goods",305002,1},{"goods",110304,80},{"coin",3200000}],
		wear_equips = 305002,
		product = [{"goods",305038, 1, 1}],
		product_equips = [{"goods",305038, 1, 1}]
	};

get(203) ->
	#fusion_conf{
		key = 203,
		rate = 10000,
		type = 5,
		sub_type = 101,
		stuff = [{"goods",305036,1},{"goods",110304,320},{"coin",6400000}],
		wear_equips = 305036,
		product = [{"goods",305039, 1, 1}],
		product_equips = [{"goods",305039, 1, 1}]
	};

get(204) ->
	#fusion_conf{
		key = 204,
		rate = 10000,
		type = 5,
		sub_type = 101,
		stuff = [{"goods",305037,1},{"goods",110304,240},{"coin",6400000}],
		wear_equips = 305037,
		product = [{"goods",305040, 1, 1}],
		product_equips = [{"goods",305040, 1, 1}]
	};

get(205) ->
	#fusion_conf{
		key = 205,
		rate = 10000,
		type = 5,
		sub_type = 101,
		stuff = [{"goods",305038,1},{"goods",110304,160},{"coin",6400000}],
		wear_equips = 305038,
		product = [{"goods",305041, 1, 1}],
		product_equips = [{"goods",305041, 1, 1}]
	};

get(206) ->
	#fusion_conf{
		key = 206,
		rate = 10000,
		type = 5,
		sub_type = 102,
		stuff = [{"goods",305029,1},{"goods",110304,160},{"coin",3200000}],
		wear_equips = 305029,
		product = [{"goods",305042, 1, 1}],
		product_equips = [{"goods",305042, 1, 1}]
	};

get(207) ->
	#fusion_conf{
		key = 207,
		rate = 10000,
		type = 5,
		sub_type = 102,
		stuff = [{"goods",305030,1},{"goods",110304,80},{"coin",3200000}],
		wear_equips = 305030,
		product = [{"goods",305043, 1, 1}],
		product_equips = [{"goods",305043, 1, 1}]
	};

get(208) ->
	#fusion_conf{
		key = 208,
		rate = 10000,
		type = 5,
		sub_type = 102,
		stuff = [{"goods",305033,1},{"goods",110304,80},{"coin",3200000}],
		wear_equips = 305033,
		product = [{"goods",305044, 1, 1}],
		product_equips = [{"goods",305044, 1, 1}]
	};

get(209) ->
	#fusion_conf{
		key = 209,
		rate = 10000,
		type = 5,
		sub_type = 102,
		stuff = [{"goods",305062,1},{"goods",110304,60},{"coin",3200000}],
		wear_equips = 305062,
		product = [{"goods",305063, 1, 1}],
		product_equips = [{"goods",305063, 1, 1}]
	};

get(210) ->
	#fusion_conf{
		key = 210,
		rate = 10000,
		type = 5,
		sub_type = 102,
		stuff = [{"goods",305067,1},{"goods",110304,60},{"coin",3200000}],
		wear_equips = 305067,
		product = [{"goods",305068, 1, 1}],
		product_equips = [{"goods",305068, 1, 1}]
	};

get(211) ->
	#fusion_conf{
		key = 211,
		rate = 10000,
		type = 5,
		sub_type = 102,
		stuff = [{"goods",305072,1},{"goods",110304,60},{"coin",3200000}],
		wear_equips = 305072,
		product = [{"goods",305073, 1, 1}],
		product_equips = [{"goods",305073, 1, 1}]
	};

get(212) ->
	#fusion_conf{
		key = 212,
		rate = 10000,
		type = 5,
		sub_type = 102,
		stuff = [{"goods",305077,1},{"goods",110304,60},{"coin",6400000}],
		wear_equips = 305077,
		product = [{"goods",305078, 1, 1}],
		product_equips = [{"goods",305078, 1, 1}]
	};

get(213) ->
	#fusion_conf{
		key = 213,
		rate = 10000,
		type = 5,
		sub_type = 102,
		stuff = [{"goods",305042,1},{"goods",110304,320},{"coin",6400000}],
		wear_equips = 305042,
		product = [{"goods",305045, 1, 1}],
		product_equips = [{"goods",305045, 1, 1}]
	};

get(214) ->
	#fusion_conf{
		key = 214,
		rate = 10000,
		type = 5,
		sub_type = 102,
		stuff = [{"goods",305043,1},{"goods",110304,160},{"coin",6400000}],
		wear_equips = 305043,
		product = [{"goods",305046, 1, 1}],
		product_equips = [{"goods",305046, 1, 1}]
	};

get(215) ->
	#fusion_conf{
		key = 215,
		rate = 10000,
		type = 5,
		sub_type = 102,
		stuff = [{"goods",305044,1},{"goods",110304,160},{"coin",6400000}],
		wear_equips = 305044,
		product = [{"goods",305047, 1, 1}],
		product_equips = [{"goods",305047, 1, 1}]
	};

get(216) ->
	#fusion_conf{
		key = 216,
		rate = 10000,
		type = 5,
		sub_type = 102,
		stuff = [{"goods",305063,1},{"goods",110304,120},{"coin",6400000}],
		wear_equips = 305063,
		product = [{"goods",305064, 1, 1}],
		product_equips = [{"goods",305064, 1, 1}]
	};

get(217) ->
	#fusion_conf{
		key = 217,
		rate = 10000,
		type = 5,
		sub_type = 102,
		stuff = [{"goods",305068,1},{"goods",110304,120},{"coin",6400000}],
		wear_equips = 305068,
		product = [{"goods",305069, 1, 1}],
		product_equips = [{"goods",305069, 1, 1}]
	};

get(218) ->
	#fusion_conf{
		key = 218,
		rate = 10000,
		type = 5,
		sub_type = 102,
		stuff = [{"goods",305073,1},{"goods",110304,120},{"coin",6400000}],
		wear_equips = 305073,
		product = [{"goods",305074, 1, 1}],
		product_equips = [{"goods",305074, 1, 1}]
	};

get(219) ->
	#fusion_conf{
		key = 219,
		rate = 10000,
		type = 5,
		sub_type = 102,
		stuff = [{"goods",305078,1},{"goods",110304,120},{"coin",6400000}],
		wear_equips = 305078,
		product = [{"goods",305079, 1, 1}],
		product_equips = [{"goods",305079, 1, 1}]
	};

get(220) ->
	#fusion_conf{
		key = 220,
		rate = 10000,
		type = 5,
		sub_type = 201,
		stuff = [{"goods",305000,1},{"goods",110304,160},{"coin",3200000}],
		wear_equips = 305000,
		product = [{"goods",305036, 1, 1}],
		product_equips = [{"goods",305036, 1, 1}]
	};

get(221) ->
	#fusion_conf{
		key = 221,
		rate = 10000,
		type = 5,
		sub_type = 201,
		stuff = [{"goods",305001,1},{"goods",110304,120},{"coin",3200000}],
		wear_equips = 305001,
		product = [{"goods",305037, 1, 1}],
		product_equips = [{"goods",305037, 1, 1}]
	};

get(222) ->
	#fusion_conf{
		key = 222,
		rate = 10000,
		type = 5,
		sub_type = 201,
		stuff = [{"goods",305002,1},{"goods",110304,80},{"coin",3200000}],
		wear_equips = 305002,
		product = [{"goods",305038, 1, 1}],
		product_equips = [{"goods",305038, 1, 1}]
	};

get(223) ->
	#fusion_conf{
		key = 223,
		rate = 10000,
		type = 5,
		sub_type = 201,
		stuff = [{"goods",305036,1},{"goods",110304,320},{"coin",6400000}],
		wear_equips = 305036,
		product = [{"goods",305039, 1, 1}],
		product_equips = [{"goods",305039, 1, 1}]
	};

get(224) ->
	#fusion_conf{
		key = 224,
		rate = 10000,
		type = 5,
		sub_type = 201,
		stuff = [{"goods",305037,1},{"goods",110304,240},{"coin",6400000}],
		wear_equips = 305037,
		product = [{"goods",305040, 1, 1}],
		product_equips = [{"goods",305040, 1, 1}]
	};

get(225) ->
	#fusion_conf{
		key = 225,
		rate = 10000,
		type = 5,
		sub_type = 201,
		stuff = [{"goods",305038,1},{"goods",110304,160},{"coin",6400000}],
		wear_equips = 305038,
		product = [{"goods",305041, 1, 1}],
		product_equips = [{"goods",305041, 1, 1}]
	};

get(226) ->
	#fusion_conf{
		key = 226,
		rate = 10000,
		type = 5,
		sub_type = 202,
		stuff = [{"goods",305029,1},{"goods",110304,160},{"coin",3200000}],
		wear_equips = 305029,
		product = [{"goods",305042, 1, 1}],
		product_equips = [{"goods",305042, 1, 1}]
	};

get(227) ->
	#fusion_conf{
		key = 227,
		rate = 10000,
		type = 5,
		sub_type = 202,
		stuff = [{"goods",305030,1},{"goods",110304,80},{"coin",3200000}],
		wear_equips = 305030,
		product = [{"goods",305043, 1, 1}],
		product_equips = [{"goods",305043, 1, 1}]
	};

get(228) ->
	#fusion_conf{
		key = 228,
		rate = 10000,
		type = 5,
		sub_type = 202,
		stuff = [{"goods",305033,1},{"goods",110304,80},{"coin",3200000}],
		wear_equips = 305033,
		product = [{"goods",305044, 1, 1}],
		product_equips = [{"goods",305044, 1, 1}]
	};

get(229) ->
	#fusion_conf{
		key = 229,
		rate = 10000,
		type = 5,
		sub_type = 202,
		stuff = [{"goods",305062,1},{"goods",110304,60},{"coin",3200000}],
		wear_equips = 305062,
		product = [{"goods",305063, 1, 1}],
		product_equips = [{"goods",305063, 1, 1}]
	};

get(230) ->
	#fusion_conf{
		key = 230,
		rate = 10000,
		type = 5,
		sub_type = 202,
		stuff = [{"goods",305067,1},{"goods",110304,60},{"coin",3200000}],
		wear_equips = 305067,
		product = [{"goods",305068, 1, 1}],
		product_equips = [{"goods",305068, 1, 1}]
	};

get(231) ->
	#fusion_conf{
		key = 231,
		rate = 10000,
		type = 5,
		sub_type = 202,
		stuff = [{"goods",305072,1},{"goods",110304,60},{"coin",3200000}],
		wear_equips = 305072,
		product = [{"goods",305073, 1, 1}],
		product_equips = [{"goods",305073, 1, 1}]
	};

get(232) ->
	#fusion_conf{
		key = 232,
		rate = 10000,
		type = 5,
		sub_type = 202,
		stuff = [{"goods",305077,1},{"goods",110304,60},{"coin",6400000}],
		wear_equips = 305077,
		product = [{"goods",305078, 1, 1}],
		product_equips = [{"goods",305078, 1, 1}]
	};

get(233) ->
	#fusion_conf{
		key = 233,
		rate = 10000,
		type = 5,
		sub_type = 202,
		stuff = [{"goods",305042,1},{"goods",110304,320},{"coin",6400000}],
		wear_equips = 305042,
		product = [{"goods",305045, 1, 1}],
		product_equips = [{"goods",305045, 1, 1}]
	};

get(234) ->
	#fusion_conf{
		key = 234,
		rate = 10000,
		type = 5,
		sub_type = 202,
		stuff = [{"goods",305043,1},{"goods",110304,160},{"coin",6400000}],
		wear_equips = 305043,
		product = [{"goods",305046, 1, 1}],
		product_equips = [{"goods",305046, 1, 1}]
	};

get(235) ->
	#fusion_conf{
		key = 235,
		rate = 10000,
		type = 5,
		sub_type = 202,
		stuff = [{"goods",305044,1},{"goods",110304,160},{"coin",6400000}],
		wear_equips = 305044,
		product = [{"goods",305047, 1, 1}],
		product_equips = [{"goods",305047, 1, 1}]
	};

get(236) ->
	#fusion_conf{
		key = 236,
		rate = 10000,
		type = 5,
		sub_type = 202,
		stuff = [{"goods",305063,1},{"goods",110304,120},{"coin",6400000}],
		wear_equips = 305063,
		product = [{"goods",305064, 1, 1}],
		product_equips = [{"goods",305064, 1, 1}]
	};

get(237) ->
	#fusion_conf{
		key = 237,
		rate = 10000,
		type = 5,
		sub_type = 202,
		stuff = [{"goods",305068,1},{"goods",110304,120},{"coin",6400000}],
		wear_equips = 305068,
		product = [{"goods",305069, 1, 1}],
		product_equips = [{"goods",305069, 1, 1}]
	};

get(238) ->
	#fusion_conf{
		key = 238,
		rate = 10000,
		type = 5,
		sub_type = 202,
		stuff = [{"goods",305073,1},{"goods",110304,120},{"coin",6400000}],
		wear_equips = 305073,
		product = [{"goods",305074, 1, 1}],
		product_equips = [{"goods",305074, 1, 1}]
	};

get(239) ->
	#fusion_conf{
		key = 239,
		rate = 10000,
		type = 5,
		sub_type = 202,
		stuff = [{"goods",305078,1},{"goods",110304,120},{"coin",6400000}],
		wear_equips = 305078,
		product = [{"goods",305079, 1, 1}],
		product_equips = [{"goods",305079, 1, 1}]
	};

get(240) ->
	#fusion_conf{
		key = 240,
		rate = 10000,
		type = 5,
		sub_type = 301,
		stuff = [{"goods",305000,1},{"goods",110304,160},{"coin",3200000}],
		wear_equips = 305000,
		product = [{"goods",305036, 1, 1}],
		product_equips = [{"goods",305036, 1, 1}]
	};

get(241) ->
	#fusion_conf{
		key = 241,
		rate = 10000,
		type = 5,
		sub_type = 301,
		stuff = [{"goods",305001,1},{"goods",110304,120},{"coin",3200000}],
		wear_equips = 305001,
		product = [{"goods",305037, 1, 1}],
		product_equips = [{"goods",305037, 1, 1}]
	};

get(242) ->
	#fusion_conf{
		key = 242,
		rate = 10000,
		type = 5,
		sub_type = 301,
		stuff = [{"goods",305002,1},{"goods",110304,80},{"coin",3200000}],
		wear_equips = 305002,
		product = [{"goods",305038, 1, 1}],
		product_equips = [{"goods",305038, 1, 1}]
	};

get(243) ->
	#fusion_conf{
		key = 243,
		rate = 10000,
		type = 5,
		sub_type = 301,
		stuff = [{"goods",305036,1},{"goods",110304,320},{"coin",6400000}],
		wear_equips = 305036,
		product = [{"goods",305039, 1, 1}],
		product_equips = [{"goods",305039, 1, 1}]
	};

get(244) ->
	#fusion_conf{
		key = 244,
		rate = 10000,
		type = 5,
		sub_type = 301,
		stuff = [{"goods",305037,1},{"goods",110304,240},{"coin",6400000}],
		wear_equips = 305037,
		product = [{"goods",305040, 1, 1}],
		product_equips = [{"goods",305040, 1, 1}]
	};

get(245) ->
	#fusion_conf{
		key = 245,
		rate = 10000,
		type = 5,
		sub_type = 301,
		stuff = [{"goods",305038,1},{"goods",110304,160},{"coin",6400000}],
		wear_equips = 305038,
		product = [{"goods",305041, 1, 1}],
		product_equips = [{"goods",305041, 1, 1}]
	};

get(246) ->
	#fusion_conf{
		key = 246,
		rate = 10000,
		type = 5,
		sub_type = 302,
		stuff = [{"goods",305029,1},{"goods",110304,160},{"coin",3200000}],
		wear_equips = 305029,
		product = [{"goods",305042, 1, 1}],
		product_equips = [{"goods",305042, 1, 1}]
	};

get(247) ->
	#fusion_conf{
		key = 247,
		rate = 10000,
		type = 5,
		sub_type = 302,
		stuff = [{"goods",305030,1},{"goods",110304,80},{"coin",3200000}],
		wear_equips = 305030,
		product = [{"goods",305043, 1, 1}],
		product_equips = [{"goods",305043, 1, 1}]
	};

get(248) ->
	#fusion_conf{
		key = 248,
		rate = 10000,
		type = 5,
		sub_type = 302,
		stuff = [{"goods",305033,1},{"goods",110304,80},{"coin",3200000}],
		wear_equips = 305033,
		product = [{"goods",305044, 1, 1}],
		product_equips = [{"goods",305044, 1, 1}]
	};

get(249) ->
	#fusion_conf{
		key = 249,
		rate = 10000,
		type = 5,
		sub_type = 302,
		stuff = [{"goods",305062,1},{"goods",110304,60},{"coin",3200000}],
		wear_equips = 305062,
		product = [{"goods",305063, 1, 1}],
		product_equips = [{"goods",305063, 1, 1}]
	};

get(250) ->
	#fusion_conf{
		key = 250,
		rate = 10000,
		type = 5,
		sub_type = 302,
		stuff = [{"goods",305067,1},{"goods",110304,60},{"coin",3200000}],
		wear_equips = 305067,
		product = [{"goods",305068, 1, 1}],
		product_equips = [{"goods",305068, 1, 1}]
	};

get(251) ->
	#fusion_conf{
		key = 251,
		rate = 10000,
		type = 5,
		sub_type = 302,
		stuff = [{"goods",305072,1},{"goods",110304,60},{"coin",3200000}],
		wear_equips = 305072,
		product = [{"goods",305073, 1, 1}],
		product_equips = [{"goods",305073, 1, 1}]
	};

get(252) ->
	#fusion_conf{
		key = 252,
		rate = 10000,
		type = 5,
		sub_type = 302,
		stuff = [{"goods",305077,1},{"goods",110304,60},{"coin",6400000}],
		wear_equips = 305077,
		product = [{"goods",305078, 1, 1}],
		product_equips = [{"goods",305078, 1, 1}]
	};

get(253) ->
	#fusion_conf{
		key = 253,
		rate = 10000,
		type = 5,
		sub_type = 302,
		stuff = [{"goods",305042,1},{"goods",110304,320},{"coin",6400000}],
		wear_equips = 305042,
		product = [{"goods",305045, 1, 1}],
		product_equips = [{"goods",305045, 1, 1}]
	};

get(254) ->
	#fusion_conf{
		key = 254,
		rate = 10000,
		type = 5,
		sub_type = 302,
		stuff = [{"goods",305043,1},{"goods",110304,160},{"coin",6400000}],
		wear_equips = 305043,
		product = [{"goods",305046, 1, 1}],
		product_equips = [{"goods",305046, 1, 1}]
	};

get(255) ->
	#fusion_conf{
		key = 255,
		rate = 10000,
		type = 5,
		sub_type = 302,
		stuff = [{"goods",305044,1},{"goods",110304,160},{"coin",6400000}],
		wear_equips = 305044,
		product = [{"goods",305047, 1, 1}],
		product_equips = [{"goods",305047, 1, 1}]
	};

get(256) ->
	#fusion_conf{
		key = 256,
		rate = 10000,
		type = 5,
		sub_type = 302,
		stuff = [{"goods",305063,1},{"goods",110304,120},{"coin",6400000}],
		wear_equips = 305063,
		product = [{"goods",305064, 1, 1}],
		product_equips = [{"goods",305064, 1, 1}]
	};

get(257) ->
	#fusion_conf{
		key = 257,
		rate = 10000,
		type = 5,
		sub_type = 302,
		stuff = [{"goods",305068,1},{"goods",110304,120},{"coin",6400000}],
		wear_equips = 305068,
		product = [{"goods",305069, 1, 1}],
		product_equips = [{"goods",305069, 1, 1}]
	};

get(258) ->
	#fusion_conf{
		key = 258,
		rate = 10000,
		type = 5,
		sub_type = 302,
		stuff = [{"goods",305073,1},{"goods",110304,120},{"coin",6400000}],
		wear_equips = 305073,
		product = [{"goods",305074, 1, 1}],
		product_equips = [{"goods",305074, 1, 1}]
	};

get(259) ->
	#fusion_conf{
		key = 259,
		rate = 10000,
		type = 5,
		sub_type = 302,
		stuff = [{"goods",305078,1},{"goods",110304,120},{"coin",6400000}],
		wear_equips = 305078,
		product = [{"goods",305079, 1, 1}],
		product_equips = [{"goods",305079, 1, 1}]
	};

get(260) ->
	#fusion_conf{
		key = 260,
		rate = 10000,
		type = 6,
		sub_type = 101,
		stuff = [{"goods",110312,5},{"goods",110313,2}],
		wear_equips = 0,
		product = [{"goods",110315, 1, 1}],
		product_equips = [{"goods",110315, 1, 1}]
	};

get(261) ->
	#fusion_conf{
		key = 261,
		rate = 10000,
		type = 6,
		sub_type = 101,
		stuff = [{"goods",110313,2},{"goods",110314,1}],
		wear_equips = 0,
		product = [{"goods",110316, 1, 1}],
		product_equips = [{"goods",110316, 1, 1}]
	};

get(262) ->
	#fusion_conf{
		key = 262,
		rate = 10000,
		type = 6,
		sub_type = 101,
		stuff = [{"goods",110312,1},{"goods",110313,1},{"goods",110314,5}],
		wear_equips = 0,
		product = [{"goods",110317, 1, 1}],
		product_equips = [{"goods",110317, 1, 1}]
	};

get(263) ->
	#fusion_conf{
		key = 263,
		rate = 10000,
		type = 5,
		sub_type = 111,
		stuff = [{"goods",200090,1},{"goods",110320,140},{"goods",110294,160},{"goods",110163,200},{"goods",110109,200},{"coin",2080000}],
		wear_equips = 200090,
		product = [{"goods",200100, 1, 1}],
		product_equips = [{"goods",200100, 1, 1}]
	};

get(264) ->
	#fusion_conf{
		key = 264,
		rate = 10000,
		type = 5,
		sub_type = 111,
		stuff = [{"goods",200091,1},{"goods",110320,120},{"goods",110294,130},{"goods",110163,150},{"goods",110109,150},{"coin",2080000}],
		wear_equips = 200091,
		product = [{"goods",200101, 0, 1}],
		product_equips = [{"goods",200101, 0, 1}]
	};

get(265) ->
	#fusion_conf{
		key = 265,
		rate = 10000,
		type = 5,
		sub_type = 111,
		stuff = [{"goods",200092,1},{"goods",110320,80},{"goods",110294,100},{"goods",110163,130},{"goods",110109,80},{"coin",2080000}],
		wear_equips = 200092,
		product = [{"goods",200102, 0, 1}],
		product_equips = [{"goods",200102, 0, 1}]
	};

get(266) ->
	#fusion_conf{
		key = 266,
		rate = 10000,
		type = 5,
		sub_type = 111,
		stuff = [{"goods",200093,1},{"goods",110320,80},{"goods",110294,100},{"goods",110163,130},{"goods",110109,80},{"coin",2080000}],
		wear_equips = 200093,
		product = [{"goods",200103, 0, 1}],
		product_equips = [{"goods",200103, 0, 1}]
	};

get(267) ->
	#fusion_conf{
		key = 267,
		rate = 10000,
		type = 5,
		sub_type = 111,
		stuff = [{"goods",200095,1},{"goods",110320,80},{"goods",110294,100},{"goods",110163,130},{"goods",110109,80},{"coin",2080000}],
		wear_equips = 200095,
		product = [{"goods",200105, 0, 1}],
		product_equips = [{"goods",200105, 0, 1}]
	};

get(268) ->
	#fusion_conf{
		key = 268,
		rate = 10000,
		type = 5,
		sub_type = 111,
		stuff = [{"goods",200096,1},{"goods",110320,80},{"goods",110294,100},{"goods",110163,130},{"goods",110109,80},{"coin",2080000}],
		wear_equips = 200096,
		product = [{"goods",200106, 0, 1}],
		product_equips = [{"goods",200106, 0, 1}]
	};

get(269) ->
	#fusion_conf{
		key = 269,
		rate = 10000,
		type = 5,
		sub_type = 111,
		stuff = [{"goods",200097,1},{"goods",110320,80},{"goods",110294,100},{"goods",110163,130},{"goods",110109,80},{"coin",2080000}],
		wear_equips = 200097,
		product = [{"goods",200107, 0, 1}],
		product_equips = [{"goods",200107, 0, 1}]
	};

get(270) ->
	#fusion_conf{
		key = 270,
		rate = 10000,
		type = 5,
		sub_type = 111,
		stuff = [{"goods",200099,1},{"goods",110320,80},{"goods",110294,100},{"goods",110163,130},{"goods",110109,80},{"coin",2080000}],
		wear_equips = 200099,
		product = [{"goods",200109, 0, 1}],
		product_equips = [{"goods",200109, 0, 1}]
	};

get(271) ->
	#fusion_conf{
		key = 271,
		rate = 10000,
		type = 5,
		sub_type = 211,
		stuff = [{"goods",201090,1},{"goods",110320,140},{"goods",110294,160},{"goods",110163,200},{"goods",110109,200},{"coin",2080000}],
		wear_equips = 201090,
		product = [{"goods",201100, 1, 1}],
		product_equips = [{"goods",201100, 1, 1}]
	};

get(272) ->
	#fusion_conf{
		key = 272,
		rate = 10000,
		type = 5,
		sub_type = 211,
		stuff = [{"goods",201091,1},{"goods",110320,120},{"goods",110294,130},{"goods",110163,150},{"goods",110109,150},{"coin",2080000}],
		wear_equips = 201091,
		product = [{"goods",201101, 0, 1}],
		product_equips = [{"goods",201101, 0, 1}]
	};

get(273) ->
	#fusion_conf{
		key = 273,
		rate = 10000,
		type = 5,
		sub_type = 211,
		stuff = [{"goods",201092,1},{"goods",110320,80},{"goods",110294,100},{"goods",110163,130},{"goods",110109,80},{"coin",2080000}],
		wear_equips = 201092,
		product = [{"goods",201102, 0, 1}],
		product_equips = [{"goods",201102, 0, 1}]
	};

get(274) ->
	#fusion_conf{
		key = 274,
		rate = 10000,
		type = 5,
		sub_type = 211,
		stuff = [{"goods",201093,1},{"goods",110320,80},{"goods",110294,100},{"goods",110163,130},{"goods",110109,80},{"coin",2080000}],
		wear_equips = 201093,
		product = [{"goods",201103, 0, 1}],
		product_equips = [{"goods",201103, 0, 1}]
	};

get(275) ->
	#fusion_conf{
		key = 275,
		rate = 10000,
		type = 5,
		sub_type = 211,
		stuff = [{"goods",201095,1},{"goods",110320,80},{"goods",110294,100},{"goods",110163,130},{"goods",110109,80},{"coin",2080000}],
		wear_equips = 201095,
		product = [{"goods",201105, 0, 1}],
		product_equips = [{"goods",201105, 0, 1}]
	};

get(276) ->
	#fusion_conf{
		key = 276,
		rate = 10000,
		type = 5,
		sub_type = 211,
		stuff = [{"goods",201096,1},{"goods",110320,80},{"goods",110294,100},{"goods",110163,130},{"goods",110109,80},{"coin",2080000}],
		wear_equips = 201096,
		product = [{"goods",201106, 0, 1}],
		product_equips = [{"goods",201106, 0, 1}]
	};

get(277) ->
	#fusion_conf{
		key = 277,
		rate = 10000,
		type = 5,
		sub_type = 211,
		stuff = [{"goods",201097,1},{"goods",110320,80},{"goods",110294,100},{"goods",110163,130},{"goods",110109,80},{"coin",2080000}],
		wear_equips = 201097,
		product = [{"goods",201107, 0, 1}],
		product_equips = [{"goods",201107, 0, 1}]
	};

get(278) ->
	#fusion_conf{
		key = 278,
		rate = 10000,
		type = 5,
		sub_type = 211,
		stuff = [{"goods",201099,1},{"goods",110320,80},{"goods",110294,100},{"goods",110163,130},{"goods",110109,80},{"coin",2080000}],
		wear_equips = 201099,
		product = [{"goods",201109, 0, 1}],
		product_equips = [{"goods",201109, 0, 1}]
	};

get(279) ->
	#fusion_conf{
		key = 279,
		rate = 10000,
		type = 5,
		sub_type = 311,
		stuff = [{"goods",202090,1},{"goods",110320,140},{"goods",110294,160},{"goods",110163,200},{"goods",110109,200},{"coin",2080000}],
		wear_equips = 202090,
		product = [{"goods",202100, 1, 1}],
		product_equips = [{"goods",202100, 1, 1}]
	};

get(280) ->
	#fusion_conf{
		key = 280,
		rate = 10000,
		type = 5,
		sub_type = 311,
		stuff = [{"goods",202091,1},{"goods",110320,120},{"goods",110294,130},{"goods",110163,150},{"goods",110109,150},{"coin",2080000}],
		wear_equips = 202091,
		product = [{"goods",202101, 1, 1}],
		product_equips = [{"goods",202101, 0, 1}]
	};

get(281) ->
	#fusion_conf{
		key = 281,
		rate = 10000,
		type = 5,
		sub_type = 311,
		stuff = [{"goods",202092,1},{"goods",110320,80},{"goods",110294,100},{"goods",110163,130},{"goods",110109,80},{"coin",2080000}],
		wear_equips = 202092,
		product = [{"goods",202102, 1, 1}],
		product_equips = [{"goods",202102, 0, 1}]
	};

get(282) ->
	#fusion_conf{
		key = 282,
		rate = 10000,
		type = 5,
		sub_type = 311,
		stuff = [{"goods",202093,1},{"goods",110320,80},{"goods",110294,100},{"goods",110163,130},{"goods",110109,80},{"coin",2080000}],
		wear_equips = 202093,
		product = [{"goods",202103, 1, 1}],
		product_equips = [{"goods",202103, 0, 1}]
	};

get(283) ->
	#fusion_conf{
		key = 283,
		rate = 10000,
		type = 5,
		sub_type = 311,
		stuff = [{"goods",202095,1},{"goods",110320,80},{"goods",110294,100},{"goods",110163,130},{"goods",110109,80},{"coin",2080000}],
		wear_equips = 202095,
		product = [{"goods",202105, 1, 1}],
		product_equips = [{"goods",202105, 0, 1}]
	};

get(284) ->
	#fusion_conf{
		key = 284,
		rate = 10000,
		type = 5,
		sub_type = 311,
		stuff = [{"goods",202096,1},{"goods",110320,80},{"goods",110294,100},{"goods",110163,130},{"goods",110109,80},{"coin",2080000}],
		wear_equips = 202096,
		product = [{"goods",202106, 1, 1}],
		product_equips = [{"goods",202106, 0, 1}]
	};

get(285) ->
	#fusion_conf{
		key = 285,
		rate = 10000,
		type = 5,
		sub_type = 311,
		stuff = [{"goods",202097,1},{"goods",110320,80},{"goods",110294,100},{"goods",110163,130},{"goods",110109,80},{"coin",2080000}],
		wear_equips = 202097,
		product = [{"goods",202107, 1, 1}],
		product_equips = [{"goods",202107, 0, 1}]
	};

get(286) ->
	#fusion_conf{
		key = 286,
		rate = 10000,
		type = 5,
		sub_type = 311,
		stuff = [{"goods",202099,1},{"goods",110320,80},{"goods",110294,100},{"goods",110163,130},{"goods",110109,80},{"coin",2080000}],
		wear_equips = 202099,
		product = [{"goods",202109, 1, 1}],
		product_equips = [{"goods",202109, 0, 1}]
	};

get(287) ->
	#fusion_conf{
		key = 287,
		rate = 10000,
		type = 5,
		sub_type = 101,
		stuff = [{"goods",305080,1},{"goods",110304,80},{"coin",3200000}],
		wear_equips = 305080,
		product = [{"goods",305081, 1, 1}],
		product_equips = [{"goods",305081, 1, 1}]
	};

get(288) ->
	#fusion_conf{
		key = 288,
		rate = 10000,
		type = 5,
		sub_type = 101,
		stuff = [{"goods",305083,1},{"goods",110304,80},{"coin",3200000}],
		wear_equips = 305083,
		product = [{"goods",305084, 1, 1}],
		product_equips = [{"goods",305084, 1, 1}]
	};

get(289) ->
	#fusion_conf{
		key = 289,
		rate = 10000,
		type = 5,
		sub_type = 101,
		stuff = [{"goods",305081,1},{"goods",110304,160},{"coin",6400000}],
		wear_equips = 305081,
		product = [{"goods",305082, 1, 1}],
		product_equips = [{"goods",305082, 1, 1}]
	};

get(290) ->
	#fusion_conf{
		key = 290,
		rate = 10000,
		type = 5,
		sub_type = 101,
		stuff = [{"goods",305084,1},{"goods",110304,160},{"coin",6400000}],
		wear_equips = 305084,
		product = [{"goods",305085, 1, 1}],
		product_equips = [{"goods",305085, 1, 1}]
	};

get(291) ->
	#fusion_conf{
		key = 291,
		rate = 10000,
		type = 5,
		sub_type = 201,
		stuff = [{"goods",305080,1},{"goods",110304,80},{"coin",3200000}],
		wear_equips = 305080,
		product = [{"goods",305081, 1, 1}],
		product_equips = [{"goods",305081, 1, 1}]
	};

get(292) ->
	#fusion_conf{
		key = 292,
		rate = 10000,
		type = 5,
		sub_type = 201,
		stuff = [{"goods",305083,1},{"goods",110304,80},{"coin",3200000}],
		wear_equips = 305083,
		product = [{"goods",305084, 1, 1}],
		product_equips = [{"goods",305084, 1, 1}]
	};

get(293) ->
	#fusion_conf{
		key = 293,
		rate = 10000,
		type = 5,
		sub_type = 201,
		stuff = [{"goods",305081,1},{"goods",110304,160},{"coin",6400000}],
		wear_equips = 305081,
		product = [{"goods",305082, 1, 1}],
		product_equips = [{"goods",305082, 1, 1}]
	};

get(294) ->
	#fusion_conf{
		key = 294,
		rate = 10000,
		type = 5,
		sub_type = 201,
		stuff = [{"goods",305084,1},{"goods",110304,160},{"coin",6400000}],
		wear_equips = 305084,
		product = [{"goods",305085, 1, 1}],
		product_equips = [{"goods",305085, 1, 1}]
	};

get(295) ->
	#fusion_conf{
		key = 295,
		rate = 10000,
		type = 5,
		sub_type = 301,
		stuff = [{"goods",305080,1},{"goods",110304,80},{"coin",3200000}],
		wear_equips = 305080,
		product = [{"goods",305081, 1, 1}],
		product_equips = [{"goods",305081, 1, 1}]
	};

get(296) ->
	#fusion_conf{
		key = 296,
		rate = 10000,
		type = 5,
		sub_type = 301,
		stuff = [{"goods",305083,1},{"goods",110304,80},{"coin",3200000}],
		wear_equips = 305083,
		product = [{"goods",305084, 1, 1}],
		product_equips = [{"goods",305084, 1, 1}]
	};

get(297) ->
	#fusion_conf{
		key = 297,
		rate = 10000,
		type = 5,
		sub_type = 301,
		stuff = [{"goods",305081,1},{"goods",110304,160},{"coin",6400000}],
		wear_equips = 305081,
		product = [{"goods",305082, 1, 1}],
		product_equips = [{"goods",305082, 1, 1}]
	};

get(298) ->
	#fusion_conf{
		key = 298,
		rate = 10000,
		type = 5,
		sub_type = 301,
		stuff = [{"goods",305084,1},{"goods",110304,160},{"coin",6400000}],
		wear_equips = 305084,
		product = [{"goods",305085, 1, 1}],
		product_equips = [{"goods",305085, 1, 1}]
	};

get(_Key) ->
	?ERR("undefined key from fusion_config ~p", [_Key]).