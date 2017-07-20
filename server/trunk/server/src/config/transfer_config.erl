%%%-------------------------------------------------------------------
%%% @author zhengsiying
%%% @doc
%%%		自动生成文件，不要手动修改
%%% @end
%%% Created : 2016/10/12
%%%-------------------------------------------------------------------

-module(transfer_config).

-include("common.hrl").
-include("config.hrl").

-compile([export_all]).

get_list_conf() ->
	[transfer_config:get(X) || X <- get_list()].

get_list() ->
	[1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32, 33, 34, 35, 36, 37, 38, 39, 40, 41, 42, 43, 44, 45, 46, 47, 48, 49, 50, 51, 52, 53, 54, 55, 56, 57, 58, 59, 60, 61, 62, 63, 64, 65, 66, 67, 68, 69, 70, 71, 72, 73, 74, 75, 76, 77, 78, 79, 80, 81, 82, 83, 84, 85, 86, 87, 88, 89, 90, 91, 92, 93, 94, 95, 96, 97, 98, 99, 100, 101, 102, 103, 104, 105, 106, 107, 108, 109, 110, 111, 112, 113, 114, 115, 116, 117, 118, 119, 120, 121, 122, 123, 124, 125, 126, 127, 128, 129, 130, 131, 132, 133, 134, 135, 136, 137, 138, 139, 140, 141, 142, 143, 144, 145, 146, 147, 148, 149, 150, 151, 152, 153, 154, 155, 156, 157, 158, 159, 160, 161, 162, 163, 164, 165, 166, 167, 168, 169, 170, 171, 172, 173, 174, 175, 176, 177, 178, 179, 180, 181, 182, 183, 184, 185, 186, 187, 188, 189, 190, 191, 192, 193, 194, 195, 196, 197, 198, 199, 200, 201].

get_scene_transfer_list(20001) ->
	[{103,18}];
get_scene_transfer_list(20008) ->
	[{4,39}, {57,11}];
get_scene_transfer_list(20009) ->
	[{5,10}];
get_scene_transfer_list(20015) ->
	[{26,25}, {79,14}, {108,66}];
get_scene_transfer_list(20016) ->
	[{34,27}];
get_scene_transfer_list(20100) ->
	[{19,93}, {122,94}, {116,13}, {43,16}];
get_scene_transfer_list(20201) ->
	[{36,5}, {12,9}, {26,46}];
get_scene_transfer_list(20101) ->
	[{7,31}];
get_scene_transfer_list(20204) ->
	[{8,16}, {10,38}];
get_scene_transfer_list(20202) ->
	[{6,27}, {45,30}];
get_scene_transfer_list(20203) ->
	[{14,14}];
get_scene_transfer_list(20205) ->
	[{51,6}, {10,37}];
get_scene_transfer_list(20206) ->
	[{27,27}];
get_scene_transfer_list(20102) ->
	[{6,54}, {6,6}, {33,16}, {86,4}, {84,46}, {34,39}];
get_scene_transfer_list(20207) ->
	[{38,4}, {39,38}];
get_scene_transfer_list(20208) ->
	[{53,5}, {44,38}];
get_scene_transfer_list(20209) ->
	[{13,3}];
get_scene_transfer_list(20210) ->
	[{30,9}, {15,42}];
get_scene_transfer_list(20211) ->
	[{55,10}, {34,50}];
get_scene_transfer_list(20230) ->
	[{15,23}, {18,13}, {34,20}, {33,13}];
get_scene_transfer_list(20212) ->
	[{19,31}];
get_scene_transfer_list(20213) ->
	[{29,30}, {32,7}];
get_scene_transfer_list(20214) ->
	[{28,58}, {3,30}];
get_scene_transfer_list(20223) ->
	[{20,18}, {22,8}, {4,17}, {4,8}];
get_scene_transfer_list(20215) ->
	[{22,21}];
get_scene_transfer_list(20103) ->
	[{12,3}, {25,38}, {80,7}, {68,38}];
get_scene_transfer_list(20216) ->
	[{13,3}, {15,32}];
get_scene_transfer_list(20104) ->
	[{6,16}];
get_scene_transfer_list(20217) ->
	[{10,33}, {67,9}];
get_scene_transfer_list(20219) ->
	[{4,17}, {22,8}, {4,17}, {21,17}, {4,8}];
get_scene_transfer_list(20220) ->
	[{22,8}, {4,17}, {21,17}, {4,8}];
get_scene_transfer_list(20221) ->
	[{22,8}, {4,17}, {21,17}, {4,8}];
get_scene_transfer_list(20222) ->
	[{22,8}, {4,17}, {21,17}, {4,8}];
get_scene_transfer_list(20232) ->
	[{22,8}, {4,17}, {21,17}, {4,8}, {4,17}];
get_scene_transfer_list(20225) ->
	[{23,16}, {18,13}, {15,21}, {34,20}, {33,13}];
get_scene_transfer_list(20226) ->
	[{18,13}, {15,21}, {34,20}, {33,13}];
get_scene_transfer_list(20227) ->
	[{18,13}, {15,21}, {34,20}, {33,13}];
get_scene_transfer_list(20228) ->
	[{18,13}, {15,21}, {34,20}, {33,13}];
get_scene_transfer_list(20229) ->
	[{18,13}, {15,21}, {34,20}, {33,13}];
get_scene_transfer_list(20231) ->
	[{18,13}, {15,21}, {34,20}, {33,13}, {34,50}];
get_scene_transfer_list(20303) ->
	[{26,27}];
get_scene_transfer_list(20305) ->
	[{26,27}];
get_scene_transfer_list(20233) ->
	[{40,45}, {62,7}];
get_scene_transfer_list(20218) ->
	[{19,20}];
get_scene_transfer_list(20105) ->
	[{36,3}, {5,47}, {6,14}];
get_scene_transfer_list(20234) ->
	[{33,63}, {84,13}];
get_scene_transfer_list(20235) ->
	[{13,30}, {4,9}];
get_scene_transfer_list(20236) ->
	[{61,36}];
get_scene_transfer_list(20237) ->
	[{8,45}, {46,5}];
get_scene_transfer_list(20238) ->
	[{13,10}, {65,13}];
get_scene_transfer_list(20239) ->
	[{61,10}];
get_scene_transfer_list(20240) ->
	[{57,10}, {41,46}];
get_scene_transfer_list(20241) ->
	[{4,47}, {5,10}];
get_scene_transfer_list(20242) ->
	[{53,21}];
get_scene_transfer_list(31001) ->
	[{20,54}];
get_scene_transfer_list(31004) ->
	[{53,21}];
get_scene_transfer_list(32103) ->
	[{104,17}];
get_scene_transfer_list(32102) ->
	[{24,31}];
get_scene_transfer_list(32001) ->
	[{9,37}];
get_scene_transfer_list(32002) ->
	[{63,6}, {39,46}];
get_scene_transfer_list(32003) ->
	[{62,15}, {62,36}];
get_scene_transfer_list(32004) ->
	[{61,10}, {14,32}];
get_scene_transfer_list(31005) ->
	[{63,50}];
get_scene_transfer_list(20224) ->
	[{98,19}];
get_scene_transfer_list(20243) ->
	[{6,49}, {69,4}];
get_scene_transfer_list(20244) ->
	[{8,57}, {46,7}];
get_scene_transfer_list(20245) ->
	[{16,41}];
get_scene_transfer_list(32105) ->
	[{50,44}];
get_scene_transfer_list(32104) ->
	[{60,41}];
get_scene_transfer_list(32111) ->
	[{53,21}];
get_scene_transfer_list(20306) ->
	[{26,27}];
get_scene_transfer_list(32112) ->
	[{16,7}, {19,6}, {22,7}, {17,15}, {16,16}, {21,15}, {10,11}, {10,13}, {13,13}, {26,9}, {26,13}, {27,15}];
get_scene_transfer_list(32113) ->
	[{11,3}, {11,11}, {3,7}, {19,7}];
get_scene_transfer_list(32114) ->
	[{16,7}, {19,6}, {22,7}, {17,15}, {16,16}, {21,15}, {10,11}, {10,13}, {13,13}, {26,9}, {26,13}, {27,15}];
get_scene_transfer_list(32115) ->
	[{11,3}, {11,11}, {3,7}, {19,7}];
get_scene_transfer_list(32116) ->
	[{98,20}];
get_scene_transfer_list(32118) ->
	[{52,4}, {6,14}];
get_scene_transfer_list(32119) ->
	[{50,46}, {67,12}];
get_scene_transfer_list(32120) ->
	[{4,25}];
get_scene_transfer_list(31003) ->
	[{57,10}];
get_scene_transfer_list(32110) ->
	[{57,10}];
get_scene_transfer_list(32117) ->
	[{16,41}, {41,12}];
get_scene_transfer_list(32121) ->
	[{4,25}];
get_scene_transfer_list(32123) ->
	[{86,12}];
get_scene_transfer_list(32124) ->
	[{57,24}];
get_scene_transfer_list(32125) ->
	[{34,3}];
get_scene_transfer_list(_) -> [].

get(1) ->
	#transfer_conf{
		id = 1,
		from_scene = 20001,
		from_pos = {103,18},
		to_scene = 20008,
		to_pos = [{6,37}],
		lv_limit = 60,
		guild_lv_limit = 0,
		power_limit = 0,
		order_num = 0,
		direction = 0
	};

get(2) ->
	#transfer_conf{
		id = 2,
		from_scene = 20008,
		from_pos = {4,39},
		to_scene = 20001,
		to_pos = [{100,20}],
		lv_limit = 60,
		guild_lv_limit = 0,
		power_limit = 0,
		order_num = 0,
		direction = 0
	};

get(3) ->
	#transfer_conf{
		id = 3,
		from_scene = 20008,
		from_pos = {57,11},
		to_scene = 20009,
		to_pos = [{8,12}],
		lv_limit = 60,
		guild_lv_limit = 0,
		power_limit = 0,
		order_num = 0,
		direction = 0
	};

get(4) ->
	#transfer_conf{
		id = 4,
		from_scene = 20009,
		from_pos = {5,10},
		to_scene = 20008,
		to_pos = [{53,12}],
		lv_limit = 60,
		guild_lv_limit = 0,
		power_limit = 0,
		order_num = 0,
		direction = 0
	};

get(5) ->
	#transfer_conf{
		id = 5,
		from_scene = 20015,
		from_pos = {26,25},
		to_scene = 20016,
		to_pos = [{30,25},{24,30},{35,21},{39,17},{36,14},{33,17},{30,20},{26,22},{23,24},{19,24},{15,29},{16,32},{26,26},{40,13},{18,15},{21,18}],
		lv_limit = 40,
		guild_lv_limit = 0,
		power_limit = 0,
		order_num = 0,
		direction = 0
	};

get(6) ->
	#transfer_conf{
		id = 6,
		from_scene = 20016,
		from_pos = {34,27},
		to_scene = 20015,
		to_pos = [{30,29}],
		lv_limit = 40,
		guild_lv_limit = 0,
		power_limit = 0,
		order_num = 0,
		direction = 0
	};

get(7) ->
	#transfer_conf{
		id = 7,
		from_scene = 20100,
		from_pos = {19,93},
		to_scene = 20201,
		to_pos = [{34,7}],
		lv_limit = 5,
		guild_lv_limit = 0,
		power_limit = 0,
		order_num = 0,
		direction = 0
	};

get(8) ->
	#transfer_conf{
		id = 8,
		from_scene = 20201,
		from_pos = {36,5},
		to_scene = 20100,
		to_pos = [{22,91}],
		lv_limit = 0,
		guild_lv_limit = 0,
		power_limit = 0,
		order_num = 0,
		direction = 0
	};

get(9) ->
	#transfer_conf{
		id = 9,
		from_scene = 20101,
		from_pos = {7,31},
		to_scene = 20201,
		to_pos = [{10,11}],
		lv_limit = 5,
		guild_lv_limit = 0,
		power_limit = 0,
		order_num = 0,
		direction = 0
	};

get(10) ->
	#transfer_conf{
		id = 10,
		from_scene = 20201,
		from_pos = {12,9},
		to_scene = 20101,
		to_pos = [{9,29}],
		lv_limit = 0,
		guild_lv_limit = 0,
		power_limit = 0,
		order_num = 0,
		direction = 0
	};

get(11) ->
	#transfer_conf{
		id = 11,
		from_scene = 20100,
		from_pos = {122,94},
		to_scene = 20204,
		to_pos = [{11,18}],
		lv_limit = 5,
		guild_lv_limit = 0,
		power_limit = 0,
		order_num = 0,
		direction = 0
	};

get(12) ->
	#transfer_conf{
		id = 12,
		from_scene = 20204,
		from_pos = {8,16},
		to_scene = 20100,
		to_pos = [{119,92}],
		lv_limit = 0,
		guild_lv_limit = 0,
		power_limit = 0,
		order_num = 0,
		direction = 0
	};

get(13) ->
	#transfer_conf{
		id = 13,
		from_scene = 20201,
		from_pos = {26,46},
		to_scene = 20202,
		to_pos = [{8,28}],
		lv_limit = 0,
		guild_lv_limit = 0,
		power_limit = 0,
		order_num = 0,
		direction = 0
	};

get(14) ->
	#transfer_conf{
		id = 14,
		from_scene = 20202,
		from_pos = {6,27},
		to_scene = 20201,
		to_pos = [{25,44}],
		lv_limit = 0,
		guild_lv_limit = 0,
		power_limit = 0,
		order_num = 0,
		direction = 0
	};

get(15) ->
	#transfer_conf{
		id = 15,
		from_scene = 20202,
		from_pos = {45,30},
		to_scene = 20203,
		to_pos = [{17,14}],
		lv_limit = 0,
		guild_lv_limit = 0,
		power_limit = 0,
		order_num = 0,
		direction = 0
	};

get(16) ->
	#transfer_conf{
		id = 16,
		from_scene = 20203,
		from_pos = {14,14},
		to_scene = 20202,
		to_pos = [{42,29}],
		lv_limit = 0,
		guild_lv_limit = 0,
		power_limit = 0,
		order_num = 0,
		direction = 0
	};

get(17) ->
	#transfer_conf{
		id = 17,
		from_scene = 20204,
		from_pos = {10,38},
		to_scene = 20205,
		to_pos = [{48,8}],
		lv_limit = 0,
		guild_lv_limit = 0,
		power_limit = 0,
		order_num = 0,
		direction = 0
	};

get(18) ->
	#transfer_conf{
		id = 18,
		from_scene = 20205,
		from_pos = {51,6},
		to_scene = 20204,
		to_pos = [{13,38}],
		lv_limit = 0,
		guild_lv_limit = 0,
		power_limit = 0,
		order_num = 0,
		direction = 0
	};

get(19) ->
	#transfer_conf{
		id = 19,
		from_scene = 20205,
		from_pos = {10,37},
		to_scene = 20206,
		to_pos = [{30,26}],
		lv_limit = 10,
		guild_lv_limit = 0,
		power_limit = 0,
		order_num = 0,
		direction = 0
	};

get(20) ->
	#transfer_conf{
		id = 20,
		from_scene = 20206,
		from_pos = {27,27},
		to_scene = 20205,
		to_pos = [{13,37}],
		lv_limit = 0,
		guild_lv_limit = 0,
		power_limit = 0,
		order_num = 0,
		direction = 0
	};

get(21) ->
	#transfer_conf{
		id = 21,
		from_scene = 20100,
		from_pos = {116,13},
		to_scene = 20102,
		to_pos = [{8,50}],
		lv_limit = 5,
		guild_lv_limit = 0,
		power_limit = 0,
		order_num = 0,
		direction = 0
	};

get(22) ->
	#transfer_conf{
		id = 22,
		from_scene = 20102,
		from_pos = {6,54},
		to_scene = 20100,
		to_pos = [{111,15}],
		lv_limit = 0,
		guild_lv_limit = 0,
		power_limit = 0,
		order_num = 0,
		direction = 0
	};

get(23) ->
	#transfer_conf{
		id = 23,
		from_scene = 20102,
		from_pos = {6,6},
		to_scene = 20207,
		to_pos = [{40,7}],
		lv_limit = 0,
		guild_lv_limit = 0,
		power_limit = 0,
		order_num = 0,
		direction = 0
	};

get(24) ->
	#transfer_conf{
		id = 24,
		from_scene = 20207,
		from_pos = {38,4},
		to_scene = 20102,
		to_pos = [{8,9}],
		lv_limit = 0,
		guild_lv_limit = 0,
		power_limit = 0,
		order_num = 0,
		direction = 0
	};

get(25) ->
	#transfer_conf{
		id = 25,
		from_scene = 20207,
		from_pos = {39,38},
		to_scene = 20208,
		to_pos = [{52,8}],
		lv_limit = 0,
		guild_lv_limit = 0,
		power_limit = 0,
		order_num = 0,
		direction = 0
	};

get(26) ->
	#transfer_conf{
		id = 26,
		from_scene = 20208,
		from_pos = {53,5},
		to_scene = 20207,
		to_pos = [{38,35}],
		lv_limit = 0,
		guild_lv_limit = 0,
		power_limit = 0,
		order_num = 0,
		direction = 0
	};

get(27) ->
	#transfer_conf{
		id = 27,
		from_scene = 20208,
		from_pos = {44,38},
		to_scene = 20209,
		to_pos = [{12,6}],
		lv_limit = 0,
		guild_lv_limit = 0,
		power_limit = 0,
		order_num = 0,
		direction = 0
	};

get(28) ->
	#transfer_conf{
		id = 28,
		from_scene = 20209,
		from_pos = {13,3},
		to_scene = 20208,
		to_pos = [{47,36}],
		lv_limit = 0,
		guild_lv_limit = 0,
		power_limit = 0,
		order_num = 0,
		direction = 0
	};

get(29) ->
	#transfer_conf{
		id = 29,
		from_scene = 20102,
		from_pos = {33,16},
		to_scene = 20210,
		to_pos = [{27,13}],
		lv_limit = 40,
		guild_lv_limit = 0,
		power_limit = 0,
		order_num = 0,
		direction = 0
	};

get(30) ->
	#transfer_conf{
		id = 30,
		from_scene = 20210,
		from_pos = {30,9},
		to_scene = 20102,
		to_pos = [{36,18}],
		lv_limit = 40,
		guild_lv_limit = 0,
		power_limit = 0,
		order_num = 0,
		direction = 0
	};

get(31) ->
	#transfer_conf{
		id = 31,
		from_scene = 20210,
		from_pos = {15,42},
		to_scene = 20211,
		to_pos = [{52,13}],
		lv_limit = 40,
		guild_lv_limit = 0,
		power_limit = 0,
		order_num = 0,
		direction = 0
	};

get(32) ->
	#transfer_conf{
		id = 32,
		from_scene = 20211,
		from_pos = {55,10},
		to_scene = 20210,
		to_pos = [{18,40}],
		lv_limit = 40,
		guild_lv_limit = 0,
		power_limit = 0,
		order_num = 0,
		direction = 0
	};

get(33) ->
	#transfer_conf{
		id = 33,
		from_scene = 20230,
		from_pos = {15,23},
		to_scene = 20212,
		to_pos = [{19,28}],
		lv_limit = 40,
		guild_lv_limit = 0,
		power_limit = 0,
		order_num = 0,
		direction = 0
	};

get(34) ->
	#transfer_conf{
		id = 34,
		from_scene = 20212,
		from_pos = {19,31},
		to_scene = 20230,
		to_pos = [{16,22}],
		lv_limit = 40,
		guild_lv_limit = 0,
		power_limit = 0,
		order_num = 0,
		direction = 0
	};

get(35) ->
	#transfer_conf{
		id = 35,
		from_scene = 20015,
		from_pos = {79,14},
		to_scene = 20213,
		to_pos = [{26,30}],
		lv_limit = 40,
		guild_lv_limit = 0,
		power_limit = 0,
		order_num = 0,
		direction = 0
	};

get(36) ->
	#transfer_conf{
		id = 36,
		from_scene = 20213,
		from_pos = {29,30},
		to_scene = 20015,
		to_pos = [{83,17}],
		lv_limit = 40,
		guild_lv_limit = 0,
		power_limit = 0,
		order_num = 0,
		direction = 0
	};

get(37) ->
	#transfer_conf{
		id = 37,
		from_scene = 20213,
		from_pos = {32,7},
		to_scene = 20214,
		to_pos = [{31,57}],
		lv_limit = 40,
		guild_lv_limit = 0,
		power_limit = 0,
		order_num = 0,
		direction = 0
	};

get(38) ->
	#transfer_conf{
		id = 38,
		from_scene = 20214,
		from_pos = {28,58},
		to_scene = 20213,
		to_pos = [{33,9}],
		lv_limit = 40,
		guild_lv_limit = 0,
		power_limit = 0,
		order_num = 0,
		direction = 0
	};

get(39) ->
	#transfer_conf{
		id = 39,
		from_scene = 20223,
		from_pos = {20,18},
		to_scene = 20215,
		to_pos = [{6,34}],
		lv_limit = 40,
		guild_lv_limit = 0,
		power_limit = 0,
		order_num = 0,
		direction = 0
	};

get(40) ->
	#transfer_conf{
		id = 40,
		from_scene = 20215,
		from_pos = {22,21},
		to_scene = 20223,
		to_pos = [{18,15}],
		lv_limit = 40,
		guild_lv_limit = 0,
		power_limit = 0,
		order_num = 0,
		direction = 0
	};

get(41) ->
	#transfer_conf{
		id = 41,
		from_scene = 20102,
		from_pos = {86,4},
		to_scene = 20015,
		to_pos = [{104,64}],
		lv_limit = 40,
		guild_lv_limit = 0,
		power_limit = 0,
		order_num = 0,
		direction = 0
	};

get(42) ->
	#transfer_conf{
		id = 42,
		from_scene = 20015,
		from_pos = {108,66},
		to_scene = 20102,
		to_pos = [{85,8}],
		lv_limit = 40,
		guild_lv_limit = 0,
		power_limit = 0,
		order_num = 0,
		direction = 0
	};

get(43) ->
	#transfer_conf{
		id = 43,
		from_scene = 20100,
		from_pos = {43,16},
		to_scene = 20103,
		to_pos = [{15,6}],
		lv_limit = 40,
		guild_lv_limit = 0,
		power_limit = 0,
		order_num = 0,
		direction = 0
	};

get(44) ->
	#transfer_conf{
		id = 44,
		from_scene = 20103,
		from_pos = {12,3},
		to_scene = 20100,
		to_pos = [{39,19}],
		lv_limit = 40,
		guild_lv_limit = 0,
		power_limit = 0,
		order_num = 0,
		direction = 0
	};

get(45) ->
	#transfer_conf{
		id = 45,
		from_scene = 20103,
		from_pos = {25,38},
		to_scene = 20216,
		to_pos = [{16,4}],
		lv_limit = 40,
		guild_lv_limit = 0,
		power_limit = 0,
		order_num = 0,
		direction = 0
	};

get(46) ->
	#transfer_conf{
		id = 46,
		from_scene = 20216,
		from_pos = {13,3},
		to_scene = 20103,
		to_pos = [{28,34}],
		lv_limit = 40,
		guild_lv_limit = 0,
		power_limit = 0,
		order_num = 0,
		direction = 0
	};

get(47) ->
	#transfer_conf{
		id = 47,
		from_scene = 20103,
		from_pos = {80,7},
		to_scene = 20104,
		to_pos = [{9,14}],
		lv_limit = 40,
		guild_lv_limit = 0,
		power_limit = 0,
		order_num = 0,
		direction = 0
	};

get(48) ->
	#transfer_conf{
		id = 48,
		from_scene = 20104,
		from_pos = {6,16},
		to_scene = 20103,
		to_pos = [{76,10}],
		lv_limit = 40,
		guild_lv_limit = 0,
		power_limit = 0,
		order_num = 0,
		direction = 0
	};

get(49) ->
	#transfer_conf{
		id = 49,
		from_scene = 20216,
		from_pos = {15,32},
		to_scene = 20217,
		to_pos = [{14,33}],
		lv_limit = 40,
		guild_lv_limit = 0,
		power_limit = 0,
		order_num = 0,
		direction = 0
	};

get(50) ->
	#transfer_conf{
		id = 50,
		from_scene = 20217,
		from_pos = {10,33},
		to_scene = 20216,
		to_pos = [{19,30}],
		lv_limit = 40,
		guild_lv_limit = 0,
		power_limit = 0,
		order_num = 0,
		direction = 0
	};

get(51) ->
	#transfer_conf{
		id = 51,
		from_scene = 20214,
		from_pos = {3,30},
		to_scene = 20219,
		to_pos = [{6,15}],
		lv_limit = 40,
		guild_lv_limit = 0,
		power_limit = 0,
		order_num = 0,
		direction = 0
	};

get(52) ->
	#transfer_conf{
		id = 52,
		from_scene = 20219,
		from_pos = {4,17},
		to_scene = 20214,
		to_pos = [{3,27}],
		lv_limit = 40,
		guild_lv_limit = 0,
		power_limit = 0,
		order_num = 0,
		direction = 0
	};

get(53) ->
	#transfer_conf{
		id = 53,
		from_scene = 20219,
		from_pos = {22,8},
		to_scene = 20232,
		to_pos = [{6,15}],
		lv_limit = 40,
		guild_lv_limit = 0,
		power_limit = 0,
		order_num = 0,
		direction = 0
	};

get(54) ->
	#transfer_conf{
		id = 54,
		from_scene = 20219,
		from_pos = {4,17},
		to_scene = 20232,
		to_pos = [{20,10}],
		lv_limit = 40,
		guild_lv_limit = 0,
		power_limit = 0,
		order_num = 0,
		direction = 0
	};

get(55) ->
	#transfer_conf{
		id = 55,
		from_scene = 20219,
		from_pos = {21,17},
		to_scene = 20232,
		to_pos = [{6,10}],
		lv_limit = 40,
		guild_lv_limit = 0,
		power_limit = 0,
		order_num = 0,
		direction = 0
	};

get(56) ->
	#transfer_conf{
		id = 56,
		from_scene = 20219,
		from_pos = {4,8},
		to_scene = 20220,
		to_pos = [{19,15}],
		lv_limit = 40,
		guild_lv_limit = 0,
		power_limit = 0,
		order_num = 0,
		direction = 0
	};

get(57) ->
	#transfer_conf{
		id = 57,
		from_scene = 20220,
		from_pos = {22,8},
		to_scene = 20221,
		to_pos = [{6,15}],
		lv_limit = 40,
		guild_lv_limit = 0,
		power_limit = 0,
		order_num = 0,
		direction = 0
	};

get(58) ->
	#transfer_conf{
		id = 58,
		from_scene = 20220,
		from_pos = {4,17},
		to_scene = 20219,
		to_pos = [{20,10}],
		lv_limit = 40,
		guild_lv_limit = 0,
		power_limit = 0,
		order_num = 0,
		direction = 0
	};

get(59) ->
	#transfer_conf{
		id = 59,
		from_scene = 20220,
		from_pos = {21,17},
		to_scene = 20219,
		to_pos = [{6,10}],
		lv_limit = 40,
		guild_lv_limit = 0,
		power_limit = 0,
		order_num = 0,
		direction = 0
	};

get(60) ->
	#transfer_conf{
		id = 60,
		from_scene = 20220,
		from_pos = {4,8},
		to_scene = 20219,
		to_pos = [{19,15}],
		lv_limit = 40,
		guild_lv_limit = 0,
		power_limit = 0,
		order_num = 0,
		direction = 0
	};

get(61) ->
	#transfer_conf{
		id = 61,
		from_scene = 20221,
		from_pos = {22,8},
		to_scene = 20222,
		to_pos = [{6,15}],
		lv_limit = 40,
		guild_lv_limit = 0,
		power_limit = 0,
		order_num = 0,
		direction = 0
	};

get(62) ->
	#transfer_conf{
		id = 62,
		from_scene = 20221,
		from_pos = {4,17},
		to_scene = 20219,
		to_pos = [{20,10}],
		lv_limit = 40,
		guild_lv_limit = 0,
		power_limit = 0,
		order_num = 0,
		direction = 0
	};

get(63) ->
	#transfer_conf{
		id = 63,
		from_scene = 20221,
		from_pos = {21,17},
		to_scene = 20219,
		to_pos = [{6,10}],
		lv_limit = 40,
		guild_lv_limit = 0,
		power_limit = 0,
		order_num = 0,
		direction = 0
	};

get(64) ->
	#transfer_conf{
		id = 64,
		from_scene = 20221,
		from_pos = {4,8},
		to_scene = 20219,
		to_pos = [{19,15}],
		lv_limit = 40,
		guild_lv_limit = 0,
		power_limit = 0,
		order_num = 0,
		direction = 0
	};

get(65) ->
	#transfer_conf{
		id = 65,
		from_scene = 20222,
		from_pos = {22,8},
		to_scene = 20223,
		to_pos = [{6,15}],
		lv_limit = 40,
		guild_lv_limit = 0,
		power_limit = 0,
		order_num = 0,
		direction = 0
	};

get(66) ->
	#transfer_conf{
		id = 66,
		from_scene = 20222,
		from_pos = {4,17},
		to_scene = 20219,
		to_pos = [{20,10}],
		lv_limit = 40,
		guild_lv_limit = 0,
		power_limit = 0,
		order_num = 0,
		direction = 0
	};

get(67) ->
	#transfer_conf{
		id = 67,
		from_scene = 20222,
		from_pos = {21,17},
		to_scene = 20219,
		to_pos = [{6,10}],
		lv_limit = 40,
		guild_lv_limit = 0,
		power_limit = 0,
		order_num = 0,
		direction = 0
	};

get(68) ->
	#transfer_conf{
		id = 68,
		from_scene = 20222,
		from_pos = {4,8},
		to_scene = 20219,
		to_pos = [{19,15}],
		lv_limit = 40,
		guild_lv_limit = 0,
		power_limit = 0,
		order_num = 0,
		direction = 0
	};

get(69) ->
	#transfer_conf{
		id = 69,
		from_scene = 20223,
		from_pos = {22,8},
		to_scene = 20219,
		to_pos = [{6,15}],
		lv_limit = 40,
		guild_lv_limit = 0,
		power_limit = 0,
		order_num = 0,
		direction = 0
	};

get(70) ->
	#transfer_conf{
		id = 70,
		from_scene = 20223,
		from_pos = {4,17},
		to_scene = 20219,
		to_pos = [{20,10}],
		lv_limit = 40,
		guild_lv_limit = 0,
		power_limit = 0,
		order_num = 0,
		direction = 0
	};

get(71) ->
	#transfer_conf{
		id = 71,
		from_scene = 20223,
		from_pos = {4,8},
		to_scene = 20219,
		to_pos = [{19,15}],
		lv_limit = 40,
		guild_lv_limit = 0,
		power_limit = 0,
		order_num = 0,
		direction = 0
	};

get(72) ->
	#transfer_conf{
		id = 72,
		from_scene = 20232,
		from_pos = {22,8},
		to_scene = 20219,
		to_pos = [{6,15}],
		lv_limit = 40,
		guild_lv_limit = 0,
		power_limit = 0,
		order_num = 0,
		direction = 0
	};

get(73) ->
	#transfer_conf{
		id = 73,
		from_scene = 20232,
		from_pos = {4,17},
		to_scene = 20219,
		to_pos = [{20,10}],
		lv_limit = 40,
		guild_lv_limit = 0,
		power_limit = 0,
		order_num = 0,
		direction = 0
	};

get(74) ->
	#transfer_conf{
		id = 74,
		from_scene = 20232,
		from_pos = {21,17},
		to_scene = 20219,
		to_pos = [{6,10}],
		lv_limit = 40,
		guild_lv_limit = 0,
		power_limit = 0,
		order_num = 0,
		direction = 0
	};

get(75) ->
	#transfer_conf{
		id = 75,
		from_scene = 20232,
		from_pos = {4,8},
		to_scene = 20220,
		to_pos = [{19,15}],
		lv_limit = 40,
		guild_lv_limit = 0,
		power_limit = 0,
		order_num = 0,
		direction = 0
	};

get(76) ->
	#transfer_conf{
		id = 76,
		from_scene = 20232,
		from_pos = {4,17},
		to_scene = 20214,
		to_pos = [{3,27}],
		lv_limit = 40,
		guild_lv_limit = 0,
		power_limit = 0,
		order_num = 0,
		direction = 0
	};

get(77) ->
	#transfer_conf{
		id = 77,
		from_scene = 20211,
		from_pos = {34,50},
		to_scene = 20225,
		to_pos = [{20,20}],
		lv_limit = 40,
		guild_lv_limit = 0,
		power_limit = 0,
		order_num = 0,
		direction = 0
	};

get(78) ->
	#transfer_conf{
		id = 78,
		from_scene = 20225,
		from_pos = {23,16},
		to_scene = 20211,
		to_pos = [{32,48}],
		lv_limit = 40,
		guild_lv_limit = 0,
		power_limit = 0,
		order_num = 0,
		direction = 0
	};

get(79) ->
	#transfer_conf{
		id = 79,
		from_scene = 20225,
		from_pos = {18,13},
		to_scene = 20231,
		to_pos = [{31,19}],
		lv_limit = 40,
		guild_lv_limit = 0,
		power_limit = 0,
		order_num = 0,
		direction = 0
	};

get(80) ->
	#transfer_conf{
		id = 80,
		from_scene = 20225,
		from_pos = {15,21},
		to_scene = 20231,
		to_pos = [{31,15}],
		lv_limit = 40,
		guild_lv_limit = 0,
		power_limit = 0,
		order_num = 0,
		direction = 0
	};

get(81) ->
	#transfer_conf{
		id = 81,
		from_scene = 20225,
		from_pos = {34,20},
		to_scene = 20231,
		to_pos = [{18,15}],
		lv_limit = 40,
		guild_lv_limit = 0,
		power_limit = 0,
		order_num = 0,
		direction = 0
	};

get(82) ->
	#transfer_conf{
		id = 82,
		from_scene = 20225,
		from_pos = {33,13},
		to_scene = 20226,
		to_pos = [{18,19}],
		lv_limit = 40,
		guild_lv_limit = 0,
		power_limit = 0,
		order_num = 0,
		direction = 0
	};

get(83) ->
	#transfer_conf{
		id = 83,
		from_scene = 20226,
		from_pos = {18,13},
		to_scene = 20225,
		to_pos = [{31,19}],
		lv_limit = 40,
		guild_lv_limit = 0,
		power_limit = 0,
		order_num = 0,
		direction = 0
	};

get(84) ->
	#transfer_conf{
		id = 84,
		from_scene = 20226,
		from_pos = {15,21},
		to_scene = 20227,
		to_pos = [{31,15}],
		lv_limit = 40,
		guild_lv_limit = 0,
		power_limit = 0,
		order_num = 0,
		direction = 0
	};

get(85) ->
	#transfer_conf{
		id = 85,
		from_scene = 20226,
		from_pos = {34,20},
		to_scene = 20225,
		to_pos = [{18,15}],
		lv_limit = 40,
		guild_lv_limit = 0,
		power_limit = 0,
		order_num = 0,
		direction = 0
	};

get(86) ->
	#transfer_conf{
		id = 86,
		from_scene = 20226,
		from_pos = {33,13},
		to_scene = 20225,
		to_pos = [{18,19}],
		lv_limit = 40,
		guild_lv_limit = 0,
		power_limit = 0,
		order_num = 0,
		direction = 0
	};

get(87) ->
	#transfer_conf{
		id = 87,
		from_scene = 20227,
		from_pos = {18,13},
		to_scene = 20225,
		to_pos = [{31,19}],
		lv_limit = 40,
		guild_lv_limit = 0,
		power_limit = 0,
		order_num = 0,
		direction = 0
	};

get(88) ->
	#transfer_conf{
		id = 88,
		from_scene = 20227,
		from_pos = {15,21},
		to_scene = 20225,
		to_pos = [{31,15}],
		lv_limit = 40,
		guild_lv_limit = 0,
		power_limit = 0,
		order_num = 0,
		direction = 0
	};

get(89) ->
	#transfer_conf{
		id = 89,
		from_scene = 20227,
		from_pos = {34,20},
		to_scene = 20225,
		to_pos = [{18,15}],
		lv_limit = 40,
		guild_lv_limit = 0,
		power_limit = 0,
		order_num = 0,
		direction = 0
	};

get(90) ->
	#transfer_conf{
		id = 90,
		from_scene = 20227,
		from_pos = {33,13},
		to_scene = 20228,
		to_pos = [{18,19}],
		lv_limit = 40,
		guild_lv_limit = 0,
		power_limit = 0,
		order_num = 0,
		direction = 0
	};

get(91) ->
	#transfer_conf{
		id = 91,
		from_scene = 20228,
		from_pos = {18,13},
		to_scene = 20225,
		to_pos = [{31,19}],
		lv_limit = 40,
		guild_lv_limit = 0,
		power_limit = 0,
		order_num = 0,
		direction = 0
	};

get(92) ->
	#transfer_conf{
		id = 92,
		from_scene = 20228,
		from_pos = {15,21},
		to_scene = 20229,
		to_pos = [{31,15}],
		lv_limit = 40,
		guild_lv_limit = 0,
		power_limit = 0,
		order_num = 0,
		direction = 0
	};

get(93) ->
	#transfer_conf{
		id = 93,
		from_scene = 20228,
		from_pos = {34,20},
		to_scene = 20225,
		to_pos = [{18,15}],
		lv_limit = 40,
		guild_lv_limit = 0,
		power_limit = 0,
		order_num = 0,
		direction = 0
	};

get(94) ->
	#transfer_conf{
		id = 94,
		from_scene = 20228,
		from_pos = {33,13},
		to_scene = 20225,
		to_pos = [{18,19}],
		lv_limit = 40,
		guild_lv_limit = 0,
		power_limit = 0,
		order_num = 0,
		direction = 0
	};

get(95) ->
	#transfer_conf{
		id = 95,
		from_scene = 20229,
		from_pos = {18,13},
		to_scene = 20225,
		to_pos = [{31,19}],
		lv_limit = 40,
		guild_lv_limit = 0,
		power_limit = 0,
		order_num = 0,
		direction = 0
	};

get(96) ->
	#transfer_conf{
		id = 96,
		from_scene = 20229,
		from_pos = {15,21},
		to_scene = 20225,
		to_pos = [{31,15}],
		lv_limit = 40,
		guild_lv_limit = 0,
		power_limit = 0,
		order_num = 0,
		direction = 0
	};

get(97) ->
	#transfer_conf{
		id = 97,
		from_scene = 20229,
		from_pos = {34,20},
		to_scene = 20225,
		to_pos = [{18,15}],
		lv_limit = 40,
		guild_lv_limit = 0,
		power_limit = 0,
		order_num = 0,
		direction = 0
	};

get(98) ->
	#transfer_conf{
		id = 98,
		from_scene = 20229,
		from_pos = {33,13},
		to_scene = 20230,
		to_pos = [{18,19}],
		lv_limit = 40,
		guild_lv_limit = 0,
		power_limit = 0,
		order_num = 0,
		direction = 0
	};

get(99) ->
	#transfer_conf{
		id = 99,
		from_scene = 20230,
		from_pos = {18,13},
		to_scene = 20225,
		to_pos = [{31,19}],
		lv_limit = 40,
		guild_lv_limit = 0,
		power_limit = 0,
		order_num = 0,
		direction = 0
	};

get(100) ->
	#transfer_conf{
		id = 100,
		from_scene = 20230,
		from_pos = {34,20},
		to_scene = 20225,
		to_pos = [{18,15}],
		lv_limit = 40,
		guild_lv_limit = 0,
		power_limit = 0,
		order_num = 0,
		direction = 0
	};

get(101) ->
	#transfer_conf{
		id = 101,
		from_scene = 20230,
		from_pos = {33,13},
		to_scene = 20225,
		to_pos = [{18,19}],
		lv_limit = 40,
		guild_lv_limit = 0,
		power_limit = 0,
		order_num = 0,
		direction = 0
	};

get(102) ->
	#transfer_conf{
		id = 102,
		from_scene = 20231,
		from_pos = {18,13},
		to_scene = 20225,
		to_pos = [{31,19}],
		lv_limit = 40,
		guild_lv_limit = 0,
		power_limit = 0,
		order_num = 0,
		direction = 0
	};

get(103) ->
	#transfer_conf{
		id = 103,
		from_scene = 20231,
		from_pos = {15,21},
		to_scene = 20225,
		to_pos = [{31,15}],
		lv_limit = 40,
		guild_lv_limit = 0,
		power_limit = 0,
		order_num = 0,
		direction = 0
	};

get(104) ->
	#transfer_conf{
		id = 104,
		from_scene = 20231,
		from_pos = {34,20},
		to_scene = 20225,
		to_pos = [{18,15}],
		lv_limit = 40,
		guild_lv_limit = 0,
		power_limit = 0,
		order_num = 0,
		direction = 0
	};

get(105) ->
	#transfer_conf{
		id = 105,
		from_scene = 20231,
		from_pos = {33,13},
		to_scene = 20226,
		to_pos = [{18,19}],
		lv_limit = 40,
		guild_lv_limit = 0,
		power_limit = 0,
		order_num = 0,
		direction = 0
	};

get(106) ->
	#transfer_conf{
		id = 106,
		from_scene = 20231,
		from_pos = {34,50},
		to_scene = 20211,
		to_pos = [{32,48}],
		lv_limit = 40,
		guild_lv_limit = 0,
		power_limit = 0,
		order_num = 0,
		direction = 0
	};

get(107) ->
	#transfer_conf{
		id = 107,
		from_scene = 20303,
		from_pos = {26,27},
		to_scene = 20305,
		to_pos = [{47,16}],
		lv_limit = 0,
		guild_lv_limit = 5,
		power_limit = 0,
		order_num = 0,
		direction = 0
	};

get(108) ->
	#transfer_conf{
		id = 108,
		from_scene = 20305,
		from_pos = {26,27},
		to_scene = 20306,
		to_pos = [{47,16}],
		lv_limit = 0,
		guild_lv_limit = 7,
		power_limit = 0,
		order_num = 0,
		direction = 0
	};

get(109) ->
	#transfer_conf{
		id = 109,
		from_scene = 20217,
		from_pos = {67,9},
		to_scene = 20233,
		to_pos = [{44,42}],
		lv_limit = 40,
		guild_lv_limit = 0,
		power_limit = 0,
		order_num = 0,
		direction = 0
	};

get(110) ->
	#transfer_conf{
		id = 110,
		from_scene = 20233,
		from_pos = {40,45},
		to_scene = 20217,
		to_pos = [{64,8}],
		lv_limit = 40,
		guild_lv_limit = 0,
		power_limit = 0,
		order_num = 0,
		direction = 0
	};

get(111) ->
	#transfer_conf{
		id = 111,
		from_scene = 20233,
		from_pos = {62,7},
		to_scene = 20218,
		to_pos = [{21,18}],
		lv_limit = 40,
		guild_lv_limit = 0,
		power_limit = 0,
		order_num = 0,
		direction = 0
	};

get(112) ->
	#transfer_conf{
		id = 112,
		from_scene = 20218,
		from_pos = {19,20},
		to_scene = 20233,
		to_pos = [{59,9}],
		lv_limit = 40,
		guild_lv_limit = 0,
		power_limit = 0,
		order_num = 0,
		direction = 0
	};

get(113) ->
	#transfer_conf{
		id = 113,
		from_scene = 20105,
		from_pos = {36,3},
		to_scene = 20234,
		to_pos = [{36,60}],
		lv_limit = 65,
		guild_lv_limit = 0,
		power_limit = 0,
		order_num = 0,
		direction = 0
	};

get(114) ->
	#transfer_conf{
		id = 114,
		from_scene = 20234,
		from_pos = {33,63},
		to_scene = 20105,
		to_pos = [{40,6}],
		lv_limit = 65,
		guild_lv_limit = 0,
		power_limit = 0,
		order_num = 0,
		direction = 0
	};

get(115) ->
	#transfer_conf{
		id = 115,
		from_scene = 20234,
		from_pos = {84,13},
		to_scene = 20235,
		to_pos = [{18,28}],
		lv_limit = 65,
		guild_lv_limit = 0,
		power_limit = 0,
		order_num = 0,
		direction = 0
	};

get(116) ->
	#transfer_conf{
		id = 116,
		from_scene = 20235,
		from_pos = {13,30},
		to_scene = 20234,
		to_pos = [{88,15}],
		lv_limit = 65,
		guild_lv_limit = 0,
		power_limit = 0,
		order_num = 0,
		direction = 0
	};

get(117) ->
	#transfer_conf{
		id = 117,
		from_scene = 20235,
		from_pos = {4,9},
		to_scene = 20236,
		to_pos = [{57,36}],
		lv_limit = 65,
		guild_lv_limit = 0,
		power_limit = 0,
		order_num = 0,
		direction = 0
	};

get(118) ->
	#transfer_conf{
		id = 118,
		from_scene = 20236,
		from_pos = {61,36},
		to_scene = 20235,
		to_pos = [{9,7}],
		lv_limit = 65,
		guild_lv_limit = 0,
		power_limit = 0,
		order_num = 0,
		direction = 0
	};

get(119) ->
	#transfer_conf{
		id = 119,
		from_scene = 20103,
		from_pos = {68,38},
		to_scene = 20105,
		to_pos = [{8,45}],
		lv_limit = 50,
		guild_lv_limit = 0,
		power_limit = 0,
		order_num = 0,
		direction = 0
	};

get(120) ->
	#transfer_conf{
		id = 120,
		from_scene = 20105,
		from_pos = {5,47},
		to_scene = 20103,
		to_pos = [{70,35}],
		lv_limit = 50,
		guild_lv_limit = 0,
		power_limit = 0,
		order_num = 0,
		direction = 0
	};

get(121) ->
	#transfer_conf{
		id = 121,
		from_scene = 20105,
		from_pos = {6,14},
		to_scene = 20237,
		to_pos = [{11,43}],
		lv_limit = 65,
		guild_lv_limit = 0,
		power_limit = 0,
		order_num = 0,
		direction = 0
	};

get(122) ->
	#transfer_conf{
		id = 122,
		from_scene = 20237,
		from_pos = {8,45},
		to_scene = 20105,
		to_pos = [{10,16}],
		lv_limit = 65,
		guild_lv_limit = 0,
		power_limit = 0,
		order_num = 0,
		direction = 0
	};

get(123) ->
	#transfer_conf{
		id = 123,
		from_scene = 20237,
		from_pos = {46,5},
		to_scene = 20238,
		to_pos = [{15,14}],
		lv_limit = 65,
		guild_lv_limit = 0,
		power_limit = 0,
		order_num = 0,
		direction = 0
	};

get(124) ->
	#transfer_conf{
		id = 124,
		from_scene = 20238,
		from_pos = {13,10},
		to_scene = 20237,
		to_pos = [{43,11}],
		lv_limit = 65,
		guild_lv_limit = 0,
		power_limit = 0,
		order_num = 0,
		direction = 0
	};

get(125) ->
	#transfer_conf{
		id = 125,
		from_scene = 20238,
		from_pos = {65,13},
		to_scene = 20239,
		to_pos = [{58,11}],
		lv_limit = 65,
		guild_lv_limit = 0,
		power_limit = 0,
		order_num = 0,
		direction = 0
	};

get(126) ->
	#transfer_conf{
		id = 126,
		from_scene = 20239,
		from_pos = {61,10},
		to_scene = 20238,
		to_pos = [{60,11}],
		lv_limit = 65,
		guild_lv_limit = 0,
		power_limit = 0,
		order_num = 0,
		direction = 0
	};

get(127) ->
	#transfer_conf{
		id = 127,
		from_scene = 20240,
		from_pos = {57,10},
		to_scene = 20103,
		to_pos = [{80,21}],
		lv_limit = 65,
		guild_lv_limit = 0,
		power_limit = 0,
		order_num = 0,
		direction = 0
	};

get(128) ->
	#transfer_conf{
		id = 128,
		from_scene = 20240,
		from_pos = {41,46},
		to_scene = 20241,
		to_pos = [{8,50}],
		lv_limit = 65,
		guild_lv_limit = 0,
		power_limit = 0,
		order_num = 0,
		direction = 0
	};

get(129) ->
	#transfer_conf{
		id = 129,
		from_scene = 20241,
		from_pos = {4,47},
		to_scene = 20242,
		to_pos = [{50,22}],
		lv_limit = 65,
		guild_lv_limit = 0,
		power_limit = 0,
		order_num = 0,
		direction = 0
	};

get(130) ->
	#transfer_conf{
		id = 130,
		from_scene = 20242,
		from_pos = {53,21},
		to_scene = 20241,
		to_pos = [{8,12}],
		lv_limit = 65,
		guild_lv_limit = 0,
		power_limit = 0,
		order_num = 0,
		direction = 0
	};

get(131) ->
	#transfer_conf{
		id = 131,
		from_scene = 20241,
		from_pos = {5,10},
		to_scene = 20240,
		to_pos = [{38,43}],
		lv_limit = 65,
		guild_lv_limit = 0,
		power_limit = 0,
		order_num = 0,
		direction = 0
	};

get(132) ->
	#transfer_conf{
		id = 132,
		from_scene = 31001,
		from_pos = {20,54},
		to_scene = 20102,
		to_pos = [{52,30}],
		lv_limit = 1,
		guild_lv_limit = 0,
		power_limit = 0,
		order_num = 0,
		direction = 0
	};

get(133) ->
	#transfer_conf{
		id = 133,
		from_scene = 31004,
		from_pos = {53,21},
		to_scene = 31003,
		to_pos = [{34,4}],
		lv_limit = 1,
		guild_lv_limit = 0,
		power_limit = 0,
		order_num = 0,
		direction = 0
	};

get(134) ->
	#transfer_conf{
		id = 134,
		from_scene = 32103,
		from_pos = {104,17},
		to_scene = 32102,
		to_pos = [{88,59}],
		lv_limit = 5,
		guild_lv_limit = 0,
		power_limit = 0,
		order_num = 0,
		direction = 0
	};

get(135) ->
	#transfer_conf{
		id = 135,
		from_scene = 32102,
		from_pos = {24,31},
		to_scene = 32101,
		to_pos = [{14,40}],
		lv_limit = 5,
		guild_lv_limit = 0,
		power_limit = 0,
		order_num = 0,
		direction = 0
	};

get(136) ->
	#transfer_conf{
		id = 136,
		from_scene = 32001,
		from_pos = {9,37},
		to_scene = 32002,
		to_pos = [{60,8}],
		lv_limit = 5,
		guild_lv_limit = 0,
		power_limit = 0,
		order_num = 0,
		direction = 0
	};

get(137) ->
	#transfer_conf{
		id = 137,
		from_scene = 32002,
		from_pos = {63,6},
		to_scene = 32001,
		to_pos = [{11,35}],
		lv_limit = 5,
		guild_lv_limit = 0,
		power_limit = 0,
		order_num = 0,
		direction = 0
	};

get(138) ->
	#transfer_conf{
		id = 138,
		from_scene = 32002,
		from_pos = {39,46},
		to_scene = 32003,
		to_pos = [{59,15}],
		lv_limit = 5,
		guild_lv_limit = 0,
		power_limit = 0,
		order_num = 0,
		direction = 0
	};

get(139) ->
	#transfer_conf{
		id = 139,
		from_scene = 32003,
		from_pos = {62,15},
		to_scene = 32002,
		to_pos = [{42,43}],
		lv_limit = 5,
		guild_lv_limit = 0,
		power_limit = 0,
		order_num = 0,
		direction = 0
	};

get(140) ->
	#transfer_conf{
		id = 140,
		from_scene = 32004,
		from_pos = {61,10},
		to_scene = 32003,
		to_pos = [{59,36}],
		lv_limit = 5,
		guild_lv_limit = 0,
		power_limit = 0,
		order_num = 0,
		direction = 0
	};

get(141) ->
	#transfer_conf{
		id = 141,
		from_scene = 32003,
		from_pos = {62,36},
		to_scene = 32004,
		to_pos = [{58,11}],
		lv_limit = 5,
		guild_lv_limit = 0,
		power_limit = 0,
		order_num = 0,
		direction = 0
	};

get(142) ->
	#transfer_conf{
		id = 142,
		from_scene = 31005,
		from_pos = {63,50},
		to_scene = 20224,
		to_pos = [{100,17}],
		lv_limit = 0,
		guild_lv_limit = 0,
		power_limit = 0,
		order_num = 0,
		direction = 0
	};

get(143) ->
	#transfer_conf{
		id = 143,
		from_scene = 20224,
		from_pos = {98,19},
		to_scene = 31005,
		to_pos = [{56,43}],
		lv_limit = 60,
		guild_lv_limit = 0,
		power_limit = 0,
		order_num = 0,
		direction = 0
	};

get(144) ->
	#transfer_conf{
		id = 144,
		from_scene = 20102,
		from_pos = {84,46},
		to_scene = 20243,
		to_pos = [{8,46}],
		lv_limit = 0,
		guild_lv_limit = 0,
		power_limit = 0,
		order_num = 0,
		direction = 0
	};

get(145) ->
	#transfer_conf{
		id = 145,
		from_scene = 20243,
		from_pos = {6,49},
		to_scene = 20102,
		to_pos = [{82,43}],
		lv_limit = 0,
		guild_lv_limit = 0,
		power_limit = 0,
		order_num = 0,
		direction = 0
	};

get(146) ->
	#transfer_conf{
		id = 146,
		from_scene = 20243,
		from_pos = {69,4},
		to_scene = 20244,
		to_pos = [{8,54}],
		lv_limit = 0,
		guild_lv_limit = 0,
		power_limit = 0,
		order_num = 0,
		direction = 0
	};

get(147) ->
	#transfer_conf{
		id = 147,
		from_scene = 20244,
		from_pos = {8,57},
		to_scene = 20243,
		to_pos = [{70,7}],
		lv_limit = 0,
		guild_lv_limit = 0,
		power_limit = 0,
		order_num = 0,
		direction = 0
	};

get(148) ->
	#transfer_conf{
		id = 148,
		from_scene = 20244,
		from_pos = {46,7},
		to_scene = 20245,
		to_pos = [{18,43}],
		lv_limit = 0,
		guild_lv_limit = 0,
		power_limit = 0,
		order_num = 0,
		direction = 0
	};

get(149) ->
	#transfer_conf{
		id = 149,
		from_scene = 20245,
		from_pos = {16,41},
		to_scene = 20244,
		to_pos = [{45,9}],
		lv_limit = 0,
		guild_lv_limit = 0,
		power_limit = 0,
		order_num = 0,
		direction = 0
	};

get(150) ->
	#transfer_conf{
		id = 150,
		from_scene = 32105,
		from_pos = {50,44},
		to_scene = 32104,
		to_pos = [{67,46}],
		lv_limit = 0,
		guild_lv_limit = 0,
		power_limit = 0,
		order_num = 0,
		direction = 0
	};

get(151) ->
	#transfer_conf{
		id = 151,
		from_scene = 32104,
		from_pos = {60,41},
		to_scene = 32105,
		to_pos = [{64,15},{52,20},{69,13},{66,12},{86,27},{91,30},{61,42},{66,17},{38,57},{45,60},{60,69},{65,66},{80,58},{90,63},{91,51},{93,47},{26,60},{28,68}],
		lv_limit = 0,
		guild_lv_limit = 0,
		power_limit = 0,
		order_num = 0,
		direction = 0
	};

get(152) ->
	#transfer_conf{
		id = 152,
		from_scene = 32111,
		from_pos = {53,21},
		to_scene = 32110,
		to_pos = [{34,4}],
		lv_limit = 1,
		guild_lv_limit = 0,
		power_limit = 0,
		order_num = 0,
		direction = 0
	};

get(153) ->
	#transfer_conf{
		id = 153,
		from_scene = 20306,
		from_pos = {26,27},
		to_scene = 20309,
		to_pos = [{47,16}],
		lv_limit = 0,
		guild_lv_limit = 9,
		power_limit = 0,
		order_num = 0,
		direction = 0
	};

get(154) ->
	#transfer_conf{
		id = 154,
		from_scene = 32112,
		from_pos = {16,7},
		to_scene = 32113,
		to_pos = [{10,5}],
		lv_limit = 0,
		guild_lv_limit = 0,
		power_limit = 0,
		order_num = 35,
		direction = 1
	};

get(155) ->
	#transfer_conf{
		id = 155,
		from_scene = 32112,
		from_pos = {19,6},
		to_scene = 32113,
		to_pos = [{10,5}],
		lv_limit = 0,
		guild_lv_limit = 0,
		power_limit = 0,
		order_num = 36,
		direction = 1
	};

get(156) ->
	#transfer_conf{
		id = 156,
		from_scene = 32112,
		from_pos = {22,7},
		to_scene = 32113,
		to_pos = [{10,5}],
		lv_limit = 0,
		guild_lv_limit = 0,
		power_limit = 0,
		order_num = 37,
		direction = 1
	};

get(157) ->
	#transfer_conf{
		id = 157,
		from_scene = 32112,
		from_pos = {17,15},
		to_scene = 32113,
		to_pos = [{10,5}],
		lv_limit = 0,
		guild_lv_limit = 0,
		power_limit = 0,
		order_num = 75,
		direction = 2
	};

get(158) ->
	#transfer_conf{
		id = 158,
		from_scene = 32112,
		from_pos = {16,16},
		to_scene = 32113,
		to_pos = [{10,5}],
		lv_limit = 0,
		guild_lv_limit = 0,
		power_limit = 0,
		order_num = 76,
		direction = 2
	};

get(159) ->
	#transfer_conf{
		id = 159,
		from_scene = 32112,
		from_pos = {21,15},
		to_scene = 32113,
		to_pos = [{10,5}],
		lv_limit = 0,
		guild_lv_limit = 0,
		power_limit = 0,
		order_num = 77,
		direction = 2
	};

get(160) ->
	#transfer_conf{
		id = 160,
		from_scene = 32112,
		from_pos = {10,11},
		to_scene = 32113,
		to_pos = [{10,5}],
		lv_limit = 0,
		guild_lv_limit = 0,
		power_limit = 0,
		order_num = 44,
		direction = 3
	};

get(161) ->
	#transfer_conf{
		id = 161,
		from_scene = 32112,
		from_pos = {10,13},
		to_scene = 32113,
		to_pos = [{10,5}],
		lv_limit = 0,
		guild_lv_limit = 0,
		power_limit = 0,
		order_num = 54,
		direction = 3
	};

get(162) ->
	#transfer_conf{
		id = 162,
		from_scene = 32112,
		from_pos = {13,13},
		to_scene = 32113,
		to_pos = [{10,5}],
		lv_limit = 0,
		guild_lv_limit = 0,
		power_limit = 0,
		order_num = 64,
		direction = 3
	};

get(163) ->
	#transfer_conf{
		id = 163,
		from_scene = 32112,
		from_pos = {26,9},
		to_scene = 32113,
		to_pos = [{10,5}],
		lv_limit = 0,
		guild_lv_limit = 0,
		power_limit = 0,
		order_num = 48,
		direction = 4
	};

get(164) ->
	#transfer_conf{
		id = 164,
		from_scene = 32112,
		from_pos = {26,13},
		to_scene = 32113,
		to_pos = [{10,5}],
		lv_limit = 0,
		guild_lv_limit = 0,
		power_limit = 0,
		order_num = 58,
		direction = 4
	};

get(165) ->
	#transfer_conf{
		id = 165,
		from_scene = 32112,
		from_pos = {27,15},
		to_scene = 32113,
		to_pos = [{10,5}],
		lv_limit = 0,
		guild_lv_limit = 0,
		power_limit = 0,
		order_num = 68,
		direction = 4
	};

get(166) ->
	#transfer_conf{
		id = 166,
		from_scene = 32113,
		from_pos = {11,3},
		to_scene = 32113,
		to_pos = [{11,9}],
		lv_limit = 0,
		guild_lv_limit = 0,
		power_limit = 0,
		order_num = 0,
		direction = 1
	};

get(167) ->
	#transfer_conf{
		id = 167,
		from_scene = 32113,
		from_pos = {11,11},
		to_scene = 32113,
		to_pos = [{12,4}],
		lv_limit = 0,
		guild_lv_limit = 0,
		power_limit = 0,
		order_num = 0,
		direction = 2
	};

get(168) ->
	#transfer_conf{
		id = 168,
		from_scene = 32113,
		from_pos = {3,7},
		to_scene = 32113,
		to_pos = [{16,7}],
		lv_limit = 0,
		guild_lv_limit = 0,
		power_limit = 0,
		order_num = 0,
		direction = 3
	};

get(169) ->
	#transfer_conf{
		id = 169,
		from_scene = 32113,
		from_pos = {19,7},
		to_scene = 32113,
		to_pos = [{5,7}],
		lv_limit = 0,
		guild_lv_limit = 0,
		power_limit = 0,
		order_num = 0,
		direction = 4
	};

get(170) ->
	#transfer_conf{
		id = 170,
		from_scene = 32114,
		from_pos = {16,7},
		to_scene = 32115,
		to_pos = [{10,5}],
		lv_limit = 0,
		guild_lv_limit = 0,
		power_limit = 0,
		order_num = 35,
		direction = 1
	};

get(171) ->
	#transfer_conf{
		id = 171,
		from_scene = 32114,
		from_pos = {19,6},
		to_scene = 32115,
		to_pos = [{10,5}],
		lv_limit = 0,
		guild_lv_limit = 0,
		power_limit = 0,
		order_num = 36,
		direction = 1
	};

get(172) ->
	#transfer_conf{
		id = 172,
		from_scene = 32114,
		from_pos = {22,7},
		to_scene = 32115,
		to_pos = [{10,5}],
		lv_limit = 0,
		guild_lv_limit = 0,
		power_limit = 0,
		order_num = 37,
		direction = 1
	};

get(173) ->
	#transfer_conf{
		id = 173,
		from_scene = 32114,
		from_pos = {17,15},
		to_scene = 32115,
		to_pos = [{10,5}],
		lv_limit = 0,
		guild_lv_limit = 0,
		power_limit = 0,
		order_num = 75,
		direction = 2
	};

get(174) ->
	#transfer_conf{
		id = 174,
		from_scene = 32114,
		from_pos = {16,16},
		to_scene = 32115,
		to_pos = [{10,5}],
		lv_limit = 0,
		guild_lv_limit = 0,
		power_limit = 0,
		order_num = 76,
		direction = 2
	};

get(175) ->
	#transfer_conf{
		id = 175,
		from_scene = 32114,
		from_pos = {21,15},
		to_scene = 32115,
		to_pos = [{10,5}],
		lv_limit = 0,
		guild_lv_limit = 0,
		power_limit = 0,
		order_num = 77,
		direction = 2
	};

get(176) ->
	#transfer_conf{
		id = 176,
		from_scene = 32114,
		from_pos = {10,11},
		to_scene = 32115,
		to_pos = [{10,5}],
		lv_limit = 0,
		guild_lv_limit = 0,
		power_limit = 0,
		order_num = 44,
		direction = 3
	};

get(177) ->
	#transfer_conf{
		id = 177,
		from_scene = 32114,
		from_pos = {10,13},
		to_scene = 32115,
		to_pos = [{10,5}],
		lv_limit = 0,
		guild_lv_limit = 0,
		power_limit = 0,
		order_num = 54,
		direction = 3
	};

get(178) ->
	#transfer_conf{
		id = 178,
		from_scene = 32114,
		from_pos = {13,13},
		to_scene = 32115,
		to_pos = [{10,5}],
		lv_limit = 0,
		guild_lv_limit = 0,
		power_limit = 0,
		order_num = 64,
		direction = 3
	};

get(179) ->
	#transfer_conf{
		id = 179,
		from_scene = 32114,
		from_pos = {26,9},
		to_scene = 32115,
		to_pos = [{10,5}],
		lv_limit = 0,
		guild_lv_limit = 0,
		power_limit = 0,
		order_num = 48,
		direction = 4
	};

get(180) ->
	#transfer_conf{
		id = 180,
		from_scene = 32114,
		from_pos = {26,13},
		to_scene = 32115,
		to_pos = [{10,5}],
		lv_limit = 0,
		guild_lv_limit = 0,
		power_limit = 0,
		order_num = 58,
		direction = 4
	};

get(181) ->
	#transfer_conf{
		id = 181,
		from_scene = 32114,
		from_pos = {27,15},
		to_scene = 32115,
		to_pos = [{10,5}],
		lv_limit = 0,
		guild_lv_limit = 0,
		power_limit = 0,
		order_num = 68,
		direction = 4
	};

get(182) ->
	#transfer_conf{
		id = 182,
		from_scene = 32115,
		from_pos = {11,3},
		to_scene = 32115,
		to_pos = [{11,9}],
		lv_limit = 0,
		guild_lv_limit = 0,
		power_limit = 0,
		order_num = 0,
		direction = 1
	};

get(183) ->
	#transfer_conf{
		id = 183,
		from_scene = 32115,
		from_pos = {11,11},
		to_scene = 32115,
		to_pos = [{12,4}],
		lv_limit = 0,
		guild_lv_limit = 0,
		power_limit = 0,
		order_num = 0,
		direction = 2
	};

get(184) ->
	#transfer_conf{
		id = 184,
		from_scene = 32115,
		from_pos = {3,7},
		to_scene = 32115,
		to_pos = [{16,7}],
		lv_limit = 0,
		guild_lv_limit = 0,
		power_limit = 0,
		order_num = 0,
		direction = 3
	};

get(185) ->
	#transfer_conf{
		id = 185,
		from_scene = 32115,
		from_pos = {19,7},
		to_scene = 32115,
		to_pos = [{5,7}],
		lv_limit = 0,
		guild_lv_limit = 0,
		power_limit = 0,
		order_num = 0,
		direction = 4
	};

get(186) ->
	#transfer_conf{
		id = 186,
		from_scene = 32116,
		from_pos = {98,20},
		to_scene = 32103,
		to_pos = [{62,42}],
		lv_limit = 5,
		guild_lv_limit = 0,
		power_limit = 0,
		order_num = 0,
		direction = 0
	};

get(187) ->
	#transfer_conf{
		id = 187,
		from_scene = 20102,
		from_pos = {34,39},
		to_scene = 32118,
		to_pos = [{56,4}],
		lv_limit = 70,
		guild_lv_limit = 0,
		power_limit = 0,
		order_num = 0,
		direction = 0
	};

get(188) ->
	#transfer_conf{
		id = 188,
		from_scene = 32118,
		from_pos = {52,4},
		to_scene = 20102,
		to_pos = [{37,36}],
		lv_limit = 70,
		guild_lv_limit = 0,
		power_limit = 0,
		order_num = 0,
		direction = 0
	};

get(189) ->
	#transfer_conf{
		id = 189,
		from_scene = 32118,
		from_pos = {6,14},
		to_scene = 32119,
		to_pos = [{52,43}],
		lv_limit = 70,
		guild_lv_limit = 0,
		power_limit = 0,
		order_num = 0,
		direction = 0
	};

get(190) ->
	#transfer_conf{
		id = 190,
		from_scene = 32119,
		from_pos = {50,46},
		to_scene = 32118,
		to_pos = [{9,16}],
		lv_limit = 70,
		guild_lv_limit = 0,
		power_limit = 0,
		order_num = 0,
		direction = 0
	};

get(191) ->
	#transfer_conf{
		id = 191,
		from_scene = 32119,
		from_pos = {67,12},
		to_scene = 32120,
		to_pos = [{7,24}],
		lv_limit = 70,
		guild_lv_limit = 0,
		power_limit = 0,
		order_num = 0,
		direction = 0
	};

get(192) ->
	#transfer_conf{
		id = 192,
		from_scene = 32120,
		from_pos = {4,25},
		to_scene = 32119,
		to_pos = [{67,15}],
		lv_limit = 70,
		guild_lv_limit = 0,
		power_limit = 0,
		order_num = 0,
		direction = 0
	};

get(193) ->
	#transfer_conf{
		id = 193,
		from_scene = 31003,
		from_pos = {57,10},
		to_scene = 31002,
		to_pos = [{96,27}],
		lv_limit = 1,
		guild_lv_limit = 0,
		power_limit = 0,
		order_num = 0,
		direction = 0
	};

get(194) ->
	#transfer_conf{
		id = 194,
		from_scene = 32110,
		from_pos = {57,10},
		to_scene = 32109,
		to_pos = [{96,27}],
		lv_limit = 1,
		guild_lv_limit = 0,
		power_limit = 0,
		order_num = 0,
		direction = 0
	};

get(195) ->
	#transfer_conf{
		id = 195,
		from_scene = 32004,
		from_pos = {14,32},
		to_scene = 32117,
		to_pos = [{18,43}],
		lv_limit = 5,
		guild_lv_limit = 0,
		power_limit = 0,
		order_num = 0,
		direction = 0
	};

get(196) ->
	#transfer_conf{
		id = 196,
		from_scene = 32117,
		from_pos = {16,41},
		to_scene = 32004,
		to_pos = [{16,30}],
		lv_limit = 5,
		guild_lv_limit = 0,
		power_limit = 0,
		order_num = 0,
		direction = 0
	};

get(197) ->
	#transfer_conf{
		id = 197,
		from_scene = 32117,
		from_pos = {41,12},
		to_scene = 32121,
		to_pos = [{7,24}],
		lv_limit = 5,
		guild_lv_limit = 0,
		power_limit = 0,
		order_num = 0,
		direction = 0
	};

get(198) ->
	#transfer_conf{
		id = 198,
		from_scene = 32121,
		from_pos = {4,25},
		to_scene = 32117,
		to_pos = [{43,15}],
		lv_limit = 5,
		guild_lv_limit = 0,
		power_limit = 0,
		order_num = 0,
		direction = 0
	};

get(199) ->
	#transfer_conf{
		id = 199,
		from_scene = 32123,
		from_pos = {86,12},
		to_scene = 32122,
		to_pos = [{27,59}],
		lv_limit = 5,
		guild_lv_limit = 0,
		power_limit = 0,
		order_num = 0,
		direction = 0
	};

get(200) ->
	#transfer_conf{
		id = 200,
		from_scene = 32124,
		from_pos = {57,24},
		to_scene = 32123,
		to_pos = [{25,60}],
		lv_limit = 5,
		guild_lv_limit = 0,
		power_limit = 0,
		order_num = 0,
		direction = 0
	};

get(201) ->
	#transfer_conf{
		id = 201,
		from_scene = 32125,
		from_pos = {34,3},
		to_scene = 32124,
		to_pos = [{20,40}],
		lv_limit = 5,
		guild_lv_limit = 0,
		power_limit = 0,
		order_num = 0,
		direction = 0
	};

get(_Key) ->
	 null.