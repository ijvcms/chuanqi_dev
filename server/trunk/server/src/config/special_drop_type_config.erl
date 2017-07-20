%%%-------------------------------------------------------------------
%%% @author zhengsiying
%%% @doc
%%%		自动生成文件，不要手动修改
%%% @end
%%% Created : 2016/10/12
%%%-------------------------------------------------------------------

-module(special_drop_type_config).

-include("common.hrl").
-include("config.hrl").

-compile([export_all]).

get_list_conf() ->
	[ special_drop_type_config:get(X) || X <- get_list() ].

get_list() ->
	[1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 28, 29, 30, 31, 32, 33, 34, 35, 36, 37, 38, 39, 40, 41, 42, 43, 44, 45, 46, 47, 48, 49, 50, 51, 52, 53, 55, 56, 57, 58, 59, 60, 61, 62, 69, 70, 71, 72, 73, 74, 75, 76, 77, 78, 79, 80, 82, 83, 84, 85, 86, 87, 88, 89, 96, 97, 98, 99, 100, 101, 102, 103, 104, 105, 106, 107, 109, 111, 112, 113, 114, 115, 116, 123, 124, 125, 126, 127, 128, 129, 130, 131, 132, 133, 134, 136, 138, 139, 140, 141, 142, 143, 150, 151, 152, 153, 154, 155, 156, 157, 158, 159, 160, 161, 163, 164, 165, 166, 167, 168, 169, 170, 177, 178, 179, 180, 181, 182, 183, 184, 185, 186, 187, 188, 190, 191, 192, 193, 194, 195, 196, 197, 204, 205, 206, 207, 208, 209, 210, 211, 212, 213, 214, 215, 217, 218, 219, 220, 221, 222, 223, 224, 231, 232, 233, 234, 235, 236, 237, 238, 239, 240, 241, 242, 244, 246, 247, 248, 249, 250, 251, 258, 259, 260, 261, 262, 263, 264, 265, 266, 267, 268, 269, 271, 272, 273, 275, 276, 277, 278, 285, 286, 287, 288, 289, 290, 291, 292, 293, 294, 295, 296, 298, 299, 300, 302, 303, 304, 305, 312, 313, 314, 315, 316, 317, 318, 319, 320, 321, 322, 323, 325, 326, 327, 329, 330, 331, 332, 339, 340, 341, 342, 343, 344, 345, 346, 347, 348, 349, 350, 352, 353, 354, 356, 357, 358, 359, 366, 367, 368, 369, 370, 371, 372, 373, 374, 375, 376, 377, 378, 379, 380, 381, 382, 383, 384, 385, 386, 387, 388, 389, 390, 391, 392, 393, 394, 395, 396, 397, 398, 399, 400, 401, 402, 403, 404, 405, 406, 407, 408, 409, 410, 411, 412, 413, 414, 415, 416, 417, 418, 419, 420, 421, 422, 423, 424, 425, 426, 427, 428, 429, 430, 431, 432].

get(1) ->
	#special_drop_type_conf{
		drop_type = 1,
		drop_limit = 5,
		drop_unit = <<"day">>,
		drop_cycle = 1
	};

get(2) ->
	#special_drop_type_conf{
		drop_type = 2,
		drop_limit = 50,
		drop_unit = <<"day">>,
		drop_cycle = 1
	};

get(3) ->
	#special_drop_type_conf{
		drop_type = 3,
		drop_limit = 250,
		drop_unit = <<"day">>,
		drop_cycle = 1
	};

get(4) ->
	#special_drop_type_conf{
		drop_type = 4,
		drop_limit = 200,
		drop_unit = <<"day">>,
		drop_cycle = 1
	};

get(5) ->
	#special_drop_type_conf{
		drop_type = 5,
		drop_limit = 50,
		drop_unit = <<"day">>,
		drop_cycle = 1
	};

get(6) ->
	#special_drop_type_conf{
		drop_type = 6,
		drop_limit = 25,
		drop_unit = <<"day">>,
		drop_cycle = 1
	};

get(7) ->
	#special_drop_type_conf{
		drop_type = 7,
		drop_limit = 1,
		drop_unit = <<"day">>,
		drop_cycle = 1
	};

get(8) ->
	#special_drop_type_conf{
		drop_type = 8,
		drop_limit = 1,
		drop_unit = <<"day">>,
		drop_cycle = 1
	};

get(9) ->
	#special_drop_type_conf{
		drop_type = 9,
		drop_limit = 1,
		drop_unit = <<"day">>,
		drop_cycle = 1
	};

get(10) ->
	#special_drop_type_conf{
		drop_type = 10,
		drop_limit = 1,
		drop_unit = <<"day">>,
		drop_cycle = 1
	};

get(11) ->
	#special_drop_type_conf{
		drop_type = 11,
		drop_limit = 1,
		drop_unit = <<"day">>,
		drop_cycle = 1
	};

get(12) ->
	#special_drop_type_conf{
		drop_type = 12,
		drop_limit = 1,
		drop_unit = <<"day">>,
		drop_cycle = 1
	};

get(13) ->
	#special_drop_type_conf{
		drop_type = 13,
		drop_limit = 1,
		drop_unit = <<"day">>,
		drop_cycle = 1
	};

get(14) ->
	#special_drop_type_conf{
		drop_type = 14,
		drop_limit = 1,
		drop_unit = <<"day">>,
		drop_cycle = 1
	};

get(15) ->
	#special_drop_type_conf{
		drop_type = 15,
		drop_limit = 1,
		drop_unit = <<"day">>,
		drop_cycle = 1
	};

get(16) ->
	#special_drop_type_conf{
		drop_type = 16,
		drop_limit = 1,
		drop_unit = <<"day">>,
		drop_cycle = 1
	};

get(17) ->
	#special_drop_type_conf{
		drop_type = 17,
		drop_limit = 20,
		drop_unit = <<"day">>,
		drop_cycle = 1
	};

get(18) ->
	#special_drop_type_conf{
		drop_type = 18,
		drop_limit = 1,
		drop_unit = <<"day">>,
		drop_cycle = 1
	};

get(19) ->
	#special_drop_type_conf{
		drop_type = 19,
		drop_limit = 100,
		drop_unit = <<"day">>,
		drop_cycle = 1
	};

get(20) ->
	#special_drop_type_conf{
		drop_type = 20,
		drop_limit = 10,
		drop_unit = <<"day">>,
		drop_cycle = 1
	};

get(21) ->
	#special_drop_type_conf{
		drop_type = 21,
		drop_limit = 10,
		drop_unit = <<"day">>,
		drop_cycle = 1
	};

get(22) ->
	#special_drop_type_conf{
		drop_type = 22,
		drop_limit = 10,
		drop_unit = <<"day">>,
		drop_cycle = 1
	};

get(23) ->
	#special_drop_type_conf{
		drop_type = 23,
		drop_limit = 5,
		drop_unit = <<"day">>,
		drop_cycle = 1
	};

get(24) ->
	#special_drop_type_conf{
		drop_type = 24,
		drop_limit = 6,
		drop_unit = <<"day">>,
		drop_cycle = 1
	};

get(25) ->
	#special_drop_type_conf{
		drop_type = 25,
		drop_limit = 4,
		drop_unit = <<"day">>,
		drop_cycle = 1
	};

get(26) ->
	#special_drop_type_conf{
		drop_type = 26,
		drop_limit = 3,
		drop_unit = <<"day">>,
		drop_cycle = 1
	};

get(28) ->
	#special_drop_type_conf{
		drop_type = 28,
		drop_limit = 1,
		drop_unit = <<"day">>,
		drop_cycle = 1
	};

get(29) ->
	#special_drop_type_conf{
		drop_type = 29,
		drop_limit = 1,
		drop_unit = <<"day">>,
		drop_cycle = 1
	};

get(30) ->
	#special_drop_type_conf{
		drop_type = 30,
		drop_limit = 1,
		drop_unit = <<"day">>,
		drop_cycle = 3
	};

get(31) ->
	#special_drop_type_conf{
		drop_type = 31,
		drop_limit = 1,
		drop_unit = <<"day">>,
		drop_cycle = 7
	};

get(32) ->
	#special_drop_type_conf{
		drop_type = 32,
		drop_limit = 5,
		drop_unit = <<"day">>,
		drop_cycle = 1
	};

get(33) ->
	#special_drop_type_conf{
		drop_type = 33,
		drop_limit = 1,
		drop_unit = <<"day">>,
		drop_cycle = 1
	};

get(34) ->
	#special_drop_type_conf{
		drop_type = 34,
		drop_limit = 1,
		drop_unit = <<"day">>,
		drop_cycle = 1
	};

get(35) ->
	#special_drop_type_conf{
		drop_type = 35,
		drop_limit = 1,
		drop_unit = <<"day">>,
		drop_cycle = 1
	};

get(36) ->
	#special_drop_type_conf{
		drop_type = 36,
		drop_limit = 1,
		drop_unit = <<"day">>,
		drop_cycle = 1
	};

get(37) ->
	#special_drop_type_conf{
		drop_type = 37,
		drop_limit = 1,
		drop_unit = <<"day">>,
		drop_cycle = 1
	};

get(38) ->
	#special_drop_type_conf{
		drop_type = 38,
		drop_limit = 1,
		drop_unit = <<"day">>,
		drop_cycle = 1
	};

get(39) ->
	#special_drop_type_conf{
		drop_type = 39,
		drop_limit = 1,
		drop_unit = <<"day">>,
		drop_cycle = 1
	};

get(40) ->
	#special_drop_type_conf{
		drop_type = 40,
		drop_limit = 1,
		drop_unit = <<"day">>,
		drop_cycle = 1
	};

get(41) ->
	#special_drop_type_conf{
		drop_type = 41,
		drop_limit = 1,
		drop_unit = <<"day">>,
		drop_cycle = 1
	};

get(42) ->
	#special_drop_type_conf{
		drop_type = 42,
		drop_limit = 1,
		drop_unit = <<"day">>,
		drop_cycle = 1
	};

get(43) ->
	#special_drop_type_conf{
		drop_type = 43,
		drop_limit = 1,
		drop_unit = <<"day">>,
		drop_cycle = 1
	};

get(44) ->
	#special_drop_type_conf{
		drop_type = 44,
		drop_limit = 20,
		drop_unit = <<"day">>,
		drop_cycle = 1
	};

get(45) ->
	#special_drop_type_conf{
		drop_type = 45,
		drop_limit = 1,
		drop_unit = <<"day">>,
		drop_cycle = 1
	};

get(46) ->
	#special_drop_type_conf{
		drop_type = 46,
		drop_limit = 100,
		drop_unit = <<"day">>,
		drop_cycle = 1
	};

get(47) ->
	#special_drop_type_conf{
		drop_type = 47,
		drop_limit = 10,
		drop_unit = <<"day">>,
		drop_cycle = 1
	};

get(48) ->
	#special_drop_type_conf{
		drop_type = 48,
		drop_limit = 10,
		drop_unit = <<"day">>,
		drop_cycle = 1
	};

get(49) ->
	#special_drop_type_conf{
		drop_type = 49,
		drop_limit = 10,
		drop_unit = <<"day">>,
		drop_cycle = 1
	};

get(50) ->
	#special_drop_type_conf{
		drop_type = 50,
		drop_limit = 5,
		drop_unit = <<"day">>,
		drop_cycle = 1
	};

get(51) ->
	#special_drop_type_conf{
		drop_type = 51,
		drop_limit = 6,
		drop_unit = <<"day">>,
		drop_cycle = 1
	};

get(52) ->
	#special_drop_type_conf{
		drop_type = 52,
		drop_limit = 4,
		drop_unit = <<"day">>,
		drop_cycle = 1
	};

get(53) ->
	#special_drop_type_conf{
		drop_type = 53,
		drop_limit = 3,
		drop_unit = <<"day">>,
		drop_cycle = 1
	};

get(55) ->
	#special_drop_type_conf{
		drop_type = 55,
		drop_limit = 1,
		drop_unit = <<"day">>,
		drop_cycle = 1
	};

get(56) ->
	#special_drop_type_conf{
		drop_type = 56,
		drop_limit = 1,
		drop_unit = <<"day">>,
		drop_cycle = 1
	};

get(57) ->
	#special_drop_type_conf{
		drop_type = 57,
		drop_limit = 1,
		drop_unit = <<"day">>,
		drop_cycle = 3
	};

get(58) ->
	#special_drop_type_conf{
		drop_type = 58,
		drop_limit = 1,
		drop_unit = <<"day">>,
		drop_cycle = 7
	};

get(59) ->
	#special_drop_type_conf{
		drop_type = 59,
		drop_limit = 5,
		drop_unit = <<"day">>,
		drop_cycle = 1
	};

get(60) ->
	#special_drop_type_conf{
		drop_type = 60,
		drop_limit = 1,
		drop_unit = <<"day">>,
		drop_cycle = 1
	};

get(61) ->
	#special_drop_type_conf{
		drop_type = 61,
		drop_limit = 1,
		drop_unit = <<"day">>,
		drop_cycle = 1
	};

get(62) ->
	#special_drop_type_conf{
		drop_type = 62,
		drop_limit = 1,
		drop_unit = <<"day">>,
		drop_cycle = 1
	};

get(69) ->
	#special_drop_type_conf{
		drop_type = 69,
		drop_limit = 1,
		drop_unit = <<"day">>,
		drop_cycle = 1
	};

get(70) ->
	#special_drop_type_conf{
		drop_type = 70,
		drop_limit = 1,
		drop_unit = <<"day">>,
		drop_cycle = 1
	};

get(71) ->
	#special_drop_type_conf{
		drop_type = 71,
		drop_limit = 24,
		drop_unit = <<"day">>,
		drop_cycle = 1
	};

get(72) ->
	#special_drop_type_conf{
		drop_type = 72,
		drop_limit = 1,
		drop_unit = <<"day">>,
		drop_cycle = 1
	};

get(73) ->
	#special_drop_type_conf{
		drop_type = 73,
		drop_limit = 100,
		drop_unit = <<"day">>,
		drop_cycle = 1
	};

get(74) ->
	#special_drop_type_conf{
		drop_type = 74,
		drop_limit = 10,
		drop_unit = <<"day">>,
		drop_cycle = 1
	};

get(75) ->
	#special_drop_type_conf{
		drop_type = 75,
		drop_limit = 10,
		drop_unit = <<"day">>,
		drop_cycle = 1
	};

get(76) ->
	#special_drop_type_conf{
		drop_type = 76,
		drop_limit = 8,
		drop_unit = <<"day">>,
		drop_cycle = 1
	};

get(77) ->
	#special_drop_type_conf{
		drop_type = 77,
		drop_limit = 5,
		drop_unit = <<"day">>,
		drop_cycle = 1
	};

get(78) ->
	#special_drop_type_conf{
		drop_type = 78,
		drop_limit = 6,
		drop_unit = <<"day">>,
		drop_cycle = 1
	};

get(79) ->
	#special_drop_type_conf{
		drop_type = 79,
		drop_limit = 4,
		drop_unit = <<"day">>,
		drop_cycle = 1
	};

get(80) ->
	#special_drop_type_conf{
		drop_type = 80,
		drop_limit = 3,
		drop_unit = <<"day">>,
		drop_cycle = 1
	};

get(82) ->
	#special_drop_type_conf{
		drop_type = 82,
		drop_limit = 1,
		drop_unit = <<"day">>,
		drop_cycle = 1
	};

get(83) ->
	#special_drop_type_conf{
		drop_type = 83,
		drop_limit = 1,
		drop_unit = <<"day">>,
		drop_cycle = 1
	};

get(84) ->
	#special_drop_type_conf{
		drop_type = 84,
		drop_limit = 1,
		drop_unit = <<"day">>,
		drop_cycle = 3
	};

get(85) ->
	#special_drop_type_conf{
		drop_type = 85,
		drop_limit = 1,
		drop_unit = <<"day">>,
		drop_cycle = 7
	};

get(86) ->
	#special_drop_type_conf{
		drop_type = 86,
		drop_limit = 5,
		drop_unit = <<"day">>,
		drop_cycle = 1
	};

get(87) ->
	#special_drop_type_conf{
		drop_type = 87,
		drop_limit = 1,
		drop_unit = <<"day">>,
		drop_cycle = 1
	};

get(88) ->
	#special_drop_type_conf{
		drop_type = 88,
		drop_limit = 1,
		drop_unit = <<"day">>,
		drop_cycle = 1
	};

get(89) ->
	#special_drop_type_conf{
		drop_type = 89,
		drop_limit = 1,
		drop_unit = <<"day">>,
		drop_cycle = 1
	};

get(96) ->
	#special_drop_type_conf{
		drop_type = 96,
		drop_limit = 1,
		drop_unit = <<"day">>,
		drop_cycle = 1
	};

get(97) ->
	#special_drop_type_conf{
		drop_type = 97,
		drop_limit = 1,
		drop_unit = <<"day">>,
		drop_cycle = 1
	};

get(98) ->
	#special_drop_type_conf{
		drop_type = 98,
		drop_limit = 20,
		drop_unit = <<"day">>,
		drop_cycle = 1
	};

get(99) ->
	#special_drop_type_conf{
		drop_type = 99,
		drop_limit = 1,
		drop_unit = <<"day">>,
		drop_cycle = 1
	};

get(100) ->
	#special_drop_type_conf{
		drop_type = 100,
		drop_limit = 100,
		drop_unit = <<"day">>,
		drop_cycle = 1
	};

get(101) ->
	#special_drop_type_conf{
		drop_type = 101,
		drop_limit = 10,
		drop_unit = <<"day">>,
		drop_cycle = 1
	};

get(102) ->
	#special_drop_type_conf{
		drop_type = 102,
		drop_limit = 10,
		drop_unit = <<"day">>,
		drop_cycle = 1
	};

get(103) ->
	#special_drop_type_conf{
		drop_type = 103,
		drop_limit = 10,
		drop_unit = <<"day">>,
		drop_cycle = 1
	};

get(104) ->
	#special_drop_type_conf{
		drop_type = 104,
		drop_limit = 5,
		drop_unit = <<"day">>,
		drop_cycle = 1
	};

get(105) ->
	#special_drop_type_conf{
		drop_type = 105,
		drop_limit = 6,
		drop_unit = <<"day">>,
		drop_cycle = 1
	};

get(106) ->
	#special_drop_type_conf{
		drop_type = 106,
		drop_limit = 4,
		drop_unit = <<"day">>,
		drop_cycle = 1
	};

get(107) ->
	#special_drop_type_conf{
		drop_type = 107,
		drop_limit = 3,
		drop_unit = <<"day">>,
		drop_cycle = 1
	};

get(109) ->
	#special_drop_type_conf{
		drop_type = 109,
		drop_limit = 1,
		drop_unit = <<"day">>,
		drop_cycle = 1
	};

get(111) ->
	#special_drop_type_conf{
		drop_type = 111,
		drop_limit = 1,
		drop_unit = <<"day">>,
		drop_cycle = 3
	};

get(112) ->
	#special_drop_type_conf{
		drop_type = 112,
		drop_limit = 1,
		drop_unit = <<"day">>,
		drop_cycle = 7
	};

get(113) ->
	#special_drop_type_conf{
		drop_type = 113,
		drop_limit = 5,
		drop_unit = <<"day">>,
		drop_cycle = 1
	};

get(114) ->
	#special_drop_type_conf{
		drop_type = 114,
		drop_limit = 1,
		drop_unit = <<"day">>,
		drop_cycle = 1
	};

get(115) ->
	#special_drop_type_conf{
		drop_type = 115,
		drop_limit = 1,
		drop_unit = <<"day">>,
		drop_cycle = 1
	};

get(116) ->
	#special_drop_type_conf{
		drop_type = 116,
		drop_limit = 1,
		drop_unit = <<"day">>,
		drop_cycle = 1
	};

get(123) ->
	#special_drop_type_conf{
		drop_type = 123,
		drop_limit = 1,
		drop_unit = <<"day">>,
		drop_cycle = 1
	};

get(124) ->
	#special_drop_type_conf{
		drop_type = 124,
		drop_limit = 1,
		drop_unit = <<"day">>,
		drop_cycle = 1
	};

get(125) ->
	#special_drop_type_conf{
		drop_type = 125,
		drop_limit = 20,
		drop_unit = <<"day">>,
		drop_cycle = 1
	};

get(126) ->
	#special_drop_type_conf{
		drop_type = 126,
		drop_limit = 1,
		drop_unit = <<"day">>,
		drop_cycle = 1
	};

get(127) ->
	#special_drop_type_conf{
		drop_type = 127,
		drop_limit = 100,
		drop_unit = <<"day">>,
		drop_cycle = 1
	};

get(128) ->
	#special_drop_type_conf{
		drop_type = 128,
		drop_limit = 10,
		drop_unit = <<"day">>,
		drop_cycle = 1
	};

get(129) ->
	#special_drop_type_conf{
		drop_type = 129,
		drop_limit = 10,
		drop_unit = <<"day">>,
		drop_cycle = 1
	};

get(130) ->
	#special_drop_type_conf{
		drop_type = 130,
		drop_limit = 10,
		drop_unit = <<"day">>,
		drop_cycle = 1
	};

get(131) ->
	#special_drop_type_conf{
		drop_type = 131,
		drop_limit = 5,
		drop_unit = <<"day">>,
		drop_cycle = 1
	};

get(132) ->
	#special_drop_type_conf{
		drop_type = 132,
		drop_limit = 6,
		drop_unit = <<"day">>,
		drop_cycle = 1
	};

get(133) ->
	#special_drop_type_conf{
		drop_type = 133,
		drop_limit = 4,
		drop_unit = <<"day">>,
		drop_cycle = 1
	};

get(134) ->
	#special_drop_type_conf{
		drop_type = 134,
		drop_limit = 3,
		drop_unit = <<"day">>,
		drop_cycle = 1
	};

get(136) ->
	#special_drop_type_conf{
		drop_type = 136,
		drop_limit = 1,
		drop_unit = <<"day">>,
		drop_cycle = 1
	};

get(138) ->
	#special_drop_type_conf{
		drop_type = 138,
		drop_limit = 1,
		drop_unit = <<"day">>,
		drop_cycle = 3
	};

get(139) ->
	#special_drop_type_conf{
		drop_type = 139,
		drop_limit = 1,
		drop_unit = <<"day">>,
		drop_cycle = 7
	};

get(140) ->
	#special_drop_type_conf{
		drop_type = 140,
		drop_limit = 5,
		drop_unit = <<"day">>,
		drop_cycle = 1
	};

get(141) ->
	#special_drop_type_conf{
		drop_type = 141,
		drop_limit = 1,
		drop_unit = <<"day">>,
		drop_cycle = 1
	};

get(142) ->
	#special_drop_type_conf{
		drop_type = 142,
		drop_limit = 1,
		drop_unit = <<"day">>,
		drop_cycle = 1
	};

get(143) ->
	#special_drop_type_conf{
		drop_type = 143,
		drop_limit = 1,
		drop_unit = <<"day">>,
		drop_cycle = 1
	};

get(150) ->
	#special_drop_type_conf{
		drop_type = 150,
		drop_limit = 1,
		drop_unit = <<"day">>,
		drop_cycle = 1
	};

get(151) ->
	#special_drop_type_conf{
		drop_type = 151,
		drop_limit = 1,
		drop_unit = <<"day">>,
		drop_cycle = 1
	};

get(152) ->
	#special_drop_type_conf{
		drop_type = 152,
		drop_limit = 20,
		drop_unit = <<"day">>,
		drop_cycle = 1
	};

get(153) ->
	#special_drop_type_conf{
		drop_type = 153,
		drop_limit = 1,
		drop_unit = <<"day">>,
		drop_cycle = 1
	};

get(154) ->
	#special_drop_type_conf{
		drop_type = 154,
		drop_limit = 100,
		drop_unit = <<"day">>,
		drop_cycle = 1
	};

get(155) ->
	#special_drop_type_conf{
		drop_type = 155,
		drop_limit = 10,
		drop_unit = <<"day">>,
		drop_cycle = 1
	};

get(156) ->
	#special_drop_type_conf{
		drop_type = 156,
		drop_limit = 10,
		drop_unit = <<"day">>,
		drop_cycle = 1
	};

get(157) ->
	#special_drop_type_conf{
		drop_type = 157,
		drop_limit = 10,
		drop_unit = <<"day">>,
		drop_cycle = 1
	};

get(158) ->
	#special_drop_type_conf{
		drop_type = 158,
		drop_limit = 5,
		drop_unit = <<"day">>,
		drop_cycle = 1
	};

get(159) ->
	#special_drop_type_conf{
		drop_type = 159,
		drop_limit = 6,
		drop_unit = <<"day">>,
		drop_cycle = 1
	};

get(160) ->
	#special_drop_type_conf{
		drop_type = 160,
		drop_limit = 4,
		drop_unit = <<"day">>,
		drop_cycle = 1
	};

get(161) ->
	#special_drop_type_conf{
		drop_type = 161,
		drop_limit = 3,
		drop_unit = <<"day">>,
		drop_cycle = 1
	};

get(163) ->
	#special_drop_type_conf{
		drop_type = 163,
		drop_limit = 4,
		drop_unit = <<"day">>,
		drop_cycle = 1
	};

get(164) ->
	#special_drop_type_conf{
		drop_type = 164,
		drop_limit = 1,
		drop_unit = <<"day">>,
		drop_cycle = 1
	};

get(165) ->
	#special_drop_type_conf{
		drop_type = 165,
		drop_limit = 1,
		drop_unit = <<"day">>,
		drop_cycle = 3
	};

get(166) ->
	#special_drop_type_conf{
		drop_type = 166,
		drop_limit = 1,
		drop_unit = <<"day">>,
		drop_cycle = 7
	};

get(167) ->
	#special_drop_type_conf{
		drop_type = 167,
		drop_limit = 5,
		drop_unit = <<"day">>,
		drop_cycle = 1
	};

get(168) ->
	#special_drop_type_conf{
		drop_type = 168,
		drop_limit = 1,
		drop_unit = <<"day">>,
		drop_cycle = 1
	};

get(169) ->
	#special_drop_type_conf{
		drop_type = 169,
		drop_limit = 1,
		drop_unit = <<"day">>,
		drop_cycle = 1
	};

get(170) ->
	#special_drop_type_conf{
		drop_type = 170,
		drop_limit = 1,
		drop_unit = <<"day">>,
		drop_cycle = 1
	};

get(177) ->
	#special_drop_type_conf{
		drop_type = 177,
		drop_limit = 1,
		drop_unit = <<"day">>,
		drop_cycle = 1
	};

get(178) ->
	#special_drop_type_conf{
		drop_type = 178,
		drop_limit = 1,
		drop_unit = <<"day">>,
		drop_cycle = 1
	};

get(179) ->
	#special_drop_type_conf{
		drop_type = 179,
		drop_limit = 22,
		drop_unit = <<"day">>,
		drop_cycle = 1
	};

get(180) ->
	#special_drop_type_conf{
		drop_type = 180,
		drop_limit = 5,
		drop_unit = <<"day">>,
		drop_cycle = 1
	};

get(181) ->
	#special_drop_type_conf{
		drop_type = 181,
		drop_limit = 100,
		drop_unit = <<"day">>,
		drop_cycle = 1
	};

get(182) ->
	#special_drop_type_conf{
		drop_type = 182,
		drop_limit = 10,
		drop_unit = <<"day">>,
		drop_cycle = 1
	};

get(183) ->
	#special_drop_type_conf{
		drop_type = 183,
		drop_limit = 10,
		drop_unit = <<"day">>,
		drop_cycle = 1
	};

get(184) ->
	#special_drop_type_conf{
		drop_type = 184,
		drop_limit = 10,
		drop_unit = <<"day">>,
		drop_cycle = 1
	};

get(185) ->
	#special_drop_type_conf{
		drop_type = 185,
		drop_limit = 5,
		drop_unit = <<"day">>,
		drop_cycle = 1
	};

get(186) ->
	#special_drop_type_conf{
		drop_type = 186,
		drop_limit = 5,
		drop_unit = <<"day">>,
		drop_cycle = 1
	};

get(187) ->
	#special_drop_type_conf{
		drop_type = 187,
		drop_limit = 4,
		drop_unit = <<"day">>,
		drop_cycle = 1
	};

get(188) ->
	#special_drop_type_conf{
		drop_type = 188,
		drop_limit = 3,
		drop_unit = <<"day">>,
		drop_cycle = 1
	};

get(190) ->
	#special_drop_type_conf{
		drop_type = 190,
		drop_limit = 1,
		drop_unit = <<"day">>,
		drop_cycle = 1
	};

get(191) ->
	#special_drop_type_conf{
		drop_type = 191,
		drop_limit = 1,
		drop_unit = <<"day">>,
		drop_cycle = 1
	};

get(192) ->
	#special_drop_type_conf{
		drop_type = 192,
		drop_limit = 1,
		drop_unit = <<"day">>,
		drop_cycle = 3
	};

get(193) ->
	#special_drop_type_conf{
		drop_type = 193,
		drop_limit = 1,
		drop_unit = <<"day">>,
		drop_cycle = 7
	};

get(194) ->
	#special_drop_type_conf{
		drop_type = 194,
		drop_limit = 5,
		drop_unit = <<"day">>,
		drop_cycle = 1
	};

get(195) ->
	#special_drop_type_conf{
		drop_type = 195,
		drop_limit = 1,
		drop_unit = <<"day">>,
		drop_cycle = 1
	};

get(196) ->
	#special_drop_type_conf{
		drop_type = 196,
		drop_limit = 1,
		drop_unit = <<"day">>,
		drop_cycle = 1
	};

get(197) ->
	#special_drop_type_conf{
		drop_type = 197,
		drop_limit = 1,
		drop_unit = <<"day">>,
		drop_cycle = 1
	};

get(204) ->
	#special_drop_type_conf{
		drop_type = 204,
		drop_limit = 1,
		drop_unit = <<"day">>,
		drop_cycle = 1
	};

get(205) ->
	#special_drop_type_conf{
		drop_type = 205,
		drop_limit = 1,
		drop_unit = <<"day">>,
		drop_cycle = 1
	};

get(206) ->
	#special_drop_type_conf{
		drop_type = 206,
		drop_limit = 20,
		drop_unit = <<"day">>,
		drop_cycle = 1
	};

get(207) ->
	#special_drop_type_conf{
		drop_type = 207,
		drop_limit = 1,
		drop_unit = <<"day">>,
		drop_cycle = 1
	};

get(208) ->
	#special_drop_type_conf{
		drop_type = 208,
		drop_limit = 100,
		drop_unit = <<"day">>,
		drop_cycle = 1
	};

get(209) ->
	#special_drop_type_conf{
		drop_type = 209,
		drop_limit = 10,
		drop_unit = <<"day">>,
		drop_cycle = 1
	};

get(210) ->
	#special_drop_type_conf{
		drop_type = 210,
		drop_limit = 10,
		drop_unit = <<"day">>,
		drop_cycle = 1
	};

get(211) ->
	#special_drop_type_conf{
		drop_type = 211,
		drop_limit = 10,
		drop_unit = <<"day">>,
		drop_cycle = 1
	};

get(212) ->
	#special_drop_type_conf{
		drop_type = 212,
		drop_limit = 5,
		drop_unit = <<"day">>,
		drop_cycle = 1
	};

get(213) ->
	#special_drop_type_conf{
		drop_type = 213,
		drop_limit = 6,
		drop_unit = <<"day">>,
		drop_cycle = 1
	};

get(214) ->
	#special_drop_type_conf{
		drop_type = 214,
		drop_limit = 4,
		drop_unit = <<"day">>,
		drop_cycle = 1
	};

get(215) ->
	#special_drop_type_conf{
		drop_type = 215,
		drop_limit = 3,
		drop_unit = <<"day">>,
		drop_cycle = 1
	};

get(217) ->
	#special_drop_type_conf{
		drop_type = 217,
		drop_limit = 1,
		drop_unit = <<"day">>,
		drop_cycle = 1
	};

get(218) ->
	#special_drop_type_conf{
		drop_type = 218,
		drop_limit = 1,
		drop_unit = <<"day">>,
		drop_cycle = 1
	};

get(219) ->
	#special_drop_type_conf{
		drop_type = 219,
		drop_limit = 1,
		drop_unit = <<"day">>,
		drop_cycle = 3
	};

get(220) ->
	#special_drop_type_conf{
		drop_type = 220,
		drop_limit = 1,
		drop_unit = <<"day">>,
		drop_cycle = 7
	};

get(221) ->
	#special_drop_type_conf{
		drop_type = 221,
		drop_limit = 5,
		drop_unit = <<"day">>,
		drop_cycle = 1
	};

get(222) ->
	#special_drop_type_conf{
		drop_type = 222,
		drop_limit = 1,
		drop_unit = <<"day">>,
		drop_cycle = 1
	};

get(223) ->
	#special_drop_type_conf{
		drop_type = 223,
		drop_limit = 1,
		drop_unit = <<"day">>,
		drop_cycle = 1
	};

get(224) ->
	#special_drop_type_conf{
		drop_type = 224,
		drop_limit = 1,
		drop_unit = <<"day">>,
		drop_cycle = 1
	};

get(231) ->
	#special_drop_type_conf{
		drop_type = 231,
		drop_limit = 1,
		drop_unit = <<"day">>,
		drop_cycle = 1
	};

get(232) ->
	#special_drop_type_conf{
		drop_type = 232,
		drop_limit = 1,
		drop_unit = <<"day">>,
		drop_cycle = 1
	};

get(233) ->
	#special_drop_type_conf{
		drop_type = 233,
		drop_limit = 20,
		drop_unit = <<"day">>,
		drop_cycle = 1
	};

get(234) ->
	#special_drop_type_conf{
		drop_type = 234,
		drop_limit = 1,
		drop_unit = <<"day">>,
		drop_cycle = 1
	};

get(235) ->
	#special_drop_type_conf{
		drop_type = 235,
		drop_limit = 100,
		drop_unit = <<"day">>,
		drop_cycle = 1
	};

get(236) ->
	#special_drop_type_conf{
		drop_type = 236,
		drop_limit = 10,
		drop_unit = <<"day">>,
		drop_cycle = 1
	};

get(237) ->
	#special_drop_type_conf{
		drop_type = 237,
		drop_limit = 10,
		drop_unit = <<"day">>,
		drop_cycle = 1
	};

get(238) ->
	#special_drop_type_conf{
		drop_type = 238,
		drop_limit = 10,
		drop_unit = <<"day">>,
		drop_cycle = 1
	};

get(239) ->
	#special_drop_type_conf{
		drop_type = 239,
		drop_limit = 5,
		drop_unit = <<"day">>,
		drop_cycle = 1
	};

get(240) ->
	#special_drop_type_conf{
		drop_type = 240,
		drop_limit = 6,
		drop_unit = <<"day">>,
		drop_cycle = 1
	};

get(241) ->
	#special_drop_type_conf{
		drop_type = 241,
		drop_limit = 4,
		drop_unit = <<"day">>,
		drop_cycle = 1
	};

get(242) ->
	#special_drop_type_conf{
		drop_type = 242,
		drop_limit = 3,
		drop_unit = <<"day">>,
		drop_cycle = 1
	};

get(244) ->
	#special_drop_type_conf{
		drop_type = 244,
		drop_limit = 3,
		drop_unit = <<"day">>,
		drop_cycle = 1
	};

get(246) ->
	#special_drop_type_conf{
		drop_type = 246,
		drop_limit = 1,
		drop_unit = <<"day">>,
		drop_cycle = 3
	};

get(247) ->
	#special_drop_type_conf{
		drop_type = 247,
		drop_limit = 1,
		drop_unit = <<"day">>,
		drop_cycle = 7
	};

get(248) ->
	#special_drop_type_conf{
		drop_type = 248,
		drop_limit = 5,
		drop_unit = <<"day">>,
		drop_cycle = 1
	};

get(249) ->
	#special_drop_type_conf{
		drop_type = 249,
		drop_limit = 1,
		drop_unit = <<"day">>,
		drop_cycle = 1
	};

get(250) ->
	#special_drop_type_conf{
		drop_type = 250,
		drop_limit = 1,
		drop_unit = <<"day">>,
		drop_cycle = 1
	};

get(251) ->
	#special_drop_type_conf{
		drop_type = 251,
		drop_limit = 1,
		drop_unit = <<"day">>,
		drop_cycle = 1
	};

get(258) ->
	#special_drop_type_conf{
		drop_type = 258,
		drop_limit = 1,
		drop_unit = <<"day">>,
		drop_cycle = 1
	};

get(259) ->
	#special_drop_type_conf{
		drop_type = 259,
		drop_limit = 1,
		drop_unit = <<"day">>,
		drop_cycle = 1
	};

get(260) ->
	#special_drop_type_conf{
		drop_type = 260,
		drop_limit = 20,
		drop_unit = <<"day">>,
		drop_cycle = 1
	};

get(261) ->
	#special_drop_type_conf{
		drop_type = 261,
		drop_limit = 6,
		drop_unit = <<"day">>,
		drop_cycle = 1
	};

get(262) ->
	#special_drop_type_conf{
		drop_type = 262,
		drop_limit = 100,
		drop_unit = <<"day">>,
		drop_cycle = 1
	};

get(263) ->
	#special_drop_type_conf{
		drop_type = 263,
		drop_limit = 10,
		drop_unit = <<"day">>,
		drop_cycle = 1
	};

get(264) ->
	#special_drop_type_conf{
		drop_type = 264,
		drop_limit = 10,
		drop_unit = <<"day">>,
		drop_cycle = 1
	};

get(265) ->
	#special_drop_type_conf{
		drop_type = 265,
		drop_limit = 10,
		drop_unit = <<"day">>,
		drop_cycle = 1
	};

get(266) ->
	#special_drop_type_conf{
		drop_type = 266,
		drop_limit = 4,
		drop_unit = <<"day">>,
		drop_cycle = 1
	};

get(267) ->
	#special_drop_type_conf{
		drop_type = 267,
		drop_limit = 6,
		drop_unit = <<"day">>,
		drop_cycle = 1
	};

get(268) ->
	#special_drop_type_conf{
		drop_type = 268,
		drop_limit = 4,
		drop_unit = <<"day">>,
		drop_cycle = 1
	};

get(269) ->
	#special_drop_type_conf{
		drop_type = 269,
		drop_limit = 3,
		drop_unit = <<"day">>,
		drop_cycle = 1
	};

get(271) ->
	#special_drop_type_conf{
		drop_type = 271,
		drop_limit = 8,
		drop_unit = <<"day">>,
		drop_cycle = 1
	};

get(272) ->
	#special_drop_type_conf{
		drop_type = 272,
		drop_limit = 1,
		drop_unit = <<"day">>,
		drop_cycle = 1
	};

get(273) ->
	#special_drop_type_conf{
		drop_type = 273,
		drop_limit = 1,
		drop_unit = <<"day">>,
		drop_cycle = 3
	};

get(275) ->
	#special_drop_type_conf{
		drop_type = 275,
		drop_limit = 8,
		drop_unit = <<"day">>,
		drop_cycle = 1
	};

get(276) ->
	#special_drop_type_conf{
		drop_type = 276,
		drop_limit = 1,
		drop_unit = <<"day">>,
		drop_cycle = 1
	};

get(277) ->
	#special_drop_type_conf{
		drop_type = 277,
		drop_limit = 1,
		drop_unit = <<"day">>,
		drop_cycle = 1
	};

get(278) ->
	#special_drop_type_conf{
		drop_type = 278,
		drop_limit = 1,
		drop_unit = <<"day">>,
		drop_cycle = 1
	};

get(285) ->
	#special_drop_type_conf{
		drop_type = 285,
		drop_limit = 1,
		drop_unit = <<"day">>,
		drop_cycle = 1
	};

get(286) ->
	#special_drop_type_conf{
		drop_type = 286,
		drop_limit = 1,
		drop_unit = <<"day">>,
		drop_cycle = 1
	};

get(287) ->
	#special_drop_type_conf{
		drop_type = 287,
		drop_limit = 20,
		drop_unit = <<"day">>,
		drop_cycle = 1
	};

get(288) ->
	#special_drop_type_conf{
		drop_type = 288,
		drop_limit = 8,
		drop_unit = <<"day">>,
		drop_cycle = 1
	};

get(289) ->
	#special_drop_type_conf{
		drop_type = 289,
		drop_limit = 100,
		drop_unit = <<"day">>,
		drop_cycle = 1
	};

get(290) ->
	#special_drop_type_conf{
		drop_type = 290,
		drop_limit = 10,
		drop_unit = <<"day">>,
		drop_cycle = 1
	};

get(291) ->
	#special_drop_type_conf{
		drop_type = 291,
		drop_limit = 10,
		drop_unit = <<"day">>,
		drop_cycle = 1
	};

get(292) ->
	#special_drop_type_conf{
		drop_type = 292,
		drop_limit = 10,
		drop_unit = <<"day">>,
		drop_cycle = 1
	};

get(293) ->
	#special_drop_type_conf{
		drop_type = 293,
		drop_limit = 5,
		drop_unit = <<"day">>,
		drop_cycle = 1
	};

get(294) ->
	#special_drop_type_conf{
		drop_type = 294,
		drop_limit = 6,
		drop_unit = <<"day">>,
		drop_cycle = 1
	};

get(295) ->
	#special_drop_type_conf{
		drop_type = 295,
		drop_limit = 6,
		drop_unit = <<"day">>,
		drop_cycle = 1
	};

get(296) ->
	#special_drop_type_conf{
		drop_type = 296,
		drop_limit = 3,
		drop_unit = <<"day">>,
		drop_cycle = 1
	};

get(298) ->
	#special_drop_type_conf{
		drop_type = 298,
		drop_limit = 6,
		drop_unit = <<"day">>,
		drop_cycle = 1
	};

get(299) ->
	#special_drop_type_conf{
		drop_type = 299,
		drop_limit = 1,
		drop_unit = <<"day">>,
		drop_cycle = 1
	};

get(300) ->
	#special_drop_type_conf{
		drop_type = 300,
		drop_limit = 1,
		drop_unit = <<"day">>,
		drop_cycle = 3
	};

get(302) ->
	#special_drop_type_conf{
		drop_type = 302,
		drop_limit = 12,
		drop_unit = <<"day">>,
		drop_cycle = 1
	};

get(303) ->
	#special_drop_type_conf{
		drop_type = 303,
		drop_limit = 1,
		drop_unit = <<"day">>,
		drop_cycle = 1
	};

get(304) ->
	#special_drop_type_conf{
		drop_type = 304,
		drop_limit = 1,
		drop_unit = <<"day">>,
		drop_cycle = 1
	};

get(305) ->
	#special_drop_type_conf{
		drop_type = 305,
		drop_limit = 1,
		drop_unit = <<"day">>,
		drop_cycle = 1
	};

get(312) ->
	#special_drop_type_conf{
		drop_type = 312,
		drop_limit = 1,
		drop_unit = <<"day">>,
		drop_cycle = 1
	};

get(313) ->
	#special_drop_type_conf{
		drop_type = 313,
		drop_limit = 1,
		drop_unit = <<"day">>,
		drop_cycle = 1
	};

get(314) ->
	#special_drop_type_conf{
		drop_type = 314,
		drop_limit = 20,
		drop_unit = <<"day">>,
		drop_cycle = 1
	};

get(315) ->
	#special_drop_type_conf{
		drop_type = 315,
		drop_limit = 6,
		drop_unit = <<"day">>,
		drop_cycle = 1
	};

get(316) ->
	#special_drop_type_conf{
		drop_type = 316,
		drop_limit = 100,
		drop_unit = <<"day">>,
		drop_cycle = 1
	};

get(317) ->
	#special_drop_type_conf{
		drop_type = 317,
		drop_limit = 10,
		drop_unit = <<"day">>,
		drop_cycle = 1
	};

get(318) ->
	#special_drop_type_conf{
		drop_type = 318,
		drop_limit = 10,
		drop_unit = <<"day">>,
		drop_cycle = 1
	};

get(319) ->
	#special_drop_type_conf{
		drop_type = 319,
		drop_limit = 10,
		drop_unit = <<"day">>,
		drop_cycle = 1
	};

get(320) ->
	#special_drop_type_conf{
		drop_type = 320,
		drop_limit = 5,
		drop_unit = <<"day">>,
		drop_cycle = 1
	};

get(321) ->
	#special_drop_type_conf{
		drop_type = 321,
		drop_limit = 6,
		drop_unit = <<"day">>,
		drop_cycle = 1
	};

get(322) ->
	#special_drop_type_conf{
		drop_type = 322,
		drop_limit = 6,
		drop_unit = <<"day">>,
		drop_cycle = 1
	};

get(323) ->
	#special_drop_type_conf{
		drop_type = 323,
		drop_limit = 3,
		drop_unit = <<"day">>,
		drop_cycle = 1
	};

get(325) ->
	#special_drop_type_conf{
		drop_type = 325,
		drop_limit = 6,
		drop_unit = <<"day">>,
		drop_cycle = 1
	};

get(326) ->
	#special_drop_type_conf{
		drop_type = 326,
		drop_limit = 1,
		drop_unit = <<"day">>,
		drop_cycle = 1
	};

get(327) ->
	#special_drop_type_conf{
		drop_type = 327,
		drop_limit = 1,
		drop_unit = <<"day">>,
		drop_cycle = 3
	};

get(329) ->
	#special_drop_type_conf{
		drop_type = 329,
		drop_limit = 6,
		drop_unit = <<"day">>,
		drop_cycle = 1
	};

get(330) ->
	#special_drop_type_conf{
		drop_type = 330,
		drop_limit = 1,
		drop_unit = <<"day">>,
		drop_cycle = 1
	};

get(331) ->
	#special_drop_type_conf{
		drop_type = 331,
		drop_limit = 1,
		drop_unit = <<"day">>,
		drop_cycle = 1
	};

get(332) ->
	#special_drop_type_conf{
		drop_type = 332,
		drop_limit = 1,
		drop_unit = <<"day">>,
		drop_cycle = 1
	};

get(339) ->
	#special_drop_type_conf{
		drop_type = 339,
		drop_limit = 1,
		drop_unit = <<"day">>,
		drop_cycle = 1
	};

get(340) ->
	#special_drop_type_conf{
		drop_type = 340,
		drop_limit = 1,
		drop_unit = <<"day">>,
		drop_cycle = 1
	};

get(341) ->
	#special_drop_type_conf{
		drop_type = 341,
		drop_limit = 20,
		drop_unit = <<"day">>,
		drop_cycle = 1
	};

get(342) ->
	#special_drop_type_conf{
		drop_type = 342,
		drop_limit = 6,
		drop_unit = <<"day">>,
		drop_cycle = 1
	};

get(343) ->
	#special_drop_type_conf{
		drop_type = 343,
		drop_limit = 100,
		drop_unit = <<"day">>,
		drop_cycle = 1
	};

get(344) ->
	#special_drop_type_conf{
		drop_type = 344,
		drop_limit = 10,
		drop_unit = <<"day">>,
		drop_cycle = 1
	};

get(345) ->
	#special_drop_type_conf{
		drop_type = 345,
		drop_limit = 10,
		drop_unit = <<"day">>,
		drop_cycle = 1
	};

get(346) ->
	#special_drop_type_conf{
		drop_type = 346,
		drop_limit = 10,
		drop_unit = <<"day">>,
		drop_cycle = 1
	};

get(347) ->
	#special_drop_type_conf{
		drop_type = 347,
		drop_limit = 5,
		drop_unit = <<"day">>,
		drop_cycle = 1
	};

get(348) ->
	#special_drop_type_conf{
		drop_type = 348,
		drop_limit = 6,
		drop_unit = <<"day">>,
		drop_cycle = 1
	};

get(349) ->
	#special_drop_type_conf{
		drop_type = 349,
		drop_limit = 6,
		drop_unit = <<"day">>,
		drop_cycle = 1
	};

get(350) ->
	#special_drop_type_conf{
		drop_type = 350,
		drop_limit = 6,
		drop_unit = <<"day">>,
		drop_cycle = 1
	};

get(352) ->
	#special_drop_type_conf{
		drop_type = 352,
		drop_limit = 5,
		drop_unit = <<"day">>,
		drop_cycle = 1
	};

get(353) ->
	#special_drop_type_conf{
		drop_type = 353,
		drop_limit = 1,
		drop_unit = <<"day">>,
		drop_cycle = 1
	};

get(354) ->
	#special_drop_type_conf{
		drop_type = 354,
		drop_limit = 1,
		drop_unit = <<"day">>,
		drop_cycle = 3
	};

get(356) ->
	#special_drop_type_conf{
		drop_type = 356,
		drop_limit = 8,
		drop_unit = <<"day">>,
		drop_cycle = 1
	};

get(357) ->
	#special_drop_type_conf{
		drop_type = 357,
		drop_limit = 1,
		drop_unit = <<"day">>,
		drop_cycle = 1
	};

get(358) ->
	#special_drop_type_conf{
		drop_type = 358,
		drop_limit = 1,
		drop_unit = <<"day">>,
		drop_cycle = 1
	};

get(359) ->
	#special_drop_type_conf{
		drop_type = 359,
		drop_limit = 1,
		drop_unit = <<"day">>,
		drop_cycle = 1
	};

get(366) ->
	#special_drop_type_conf{
		drop_type = 366,
		drop_limit = 1,
		drop_unit = <<"day">>,
		drop_cycle = 1
	};

get(367) ->
	#special_drop_type_conf{
		drop_type = 367,
		drop_limit = 1,
		drop_unit = <<"day">>,
		drop_cycle = 1
	};

get(368) ->
	#special_drop_type_conf{
		drop_type = 368,
		drop_limit = 20,
		drop_unit = <<"day">>,
		drop_cycle = 1
	};

get(369) ->
	#special_drop_type_conf{
		drop_type = 369,
		drop_limit = 5,
		drop_unit = <<"day">>,
		drop_cycle = 1
	};

get(370) ->
	#special_drop_type_conf{
		drop_type = 370,
		drop_limit = 100,
		drop_unit = <<"day">>,
		drop_cycle = 1
	};

get(371) ->
	#special_drop_type_conf{
		drop_type = 371,
		drop_limit = 10,
		drop_unit = <<"day">>,
		drop_cycle = 1
	};

get(372) ->
	#special_drop_type_conf{
		drop_type = 372,
		drop_limit = 10,
		drop_unit = <<"day">>,
		drop_cycle = 1
	};

get(373) ->
	#special_drop_type_conf{
		drop_type = 373,
		drop_limit = 10,
		drop_unit = <<"day">>,
		drop_cycle = 1
	};

get(374) ->
	#special_drop_type_conf{
		drop_type = 374,
		drop_limit = 5,
		drop_unit = <<"day">>,
		drop_cycle = 1
	};

get(375) ->
	#special_drop_type_conf{
		drop_type = 375,
		drop_limit = 6,
		drop_unit = <<"day">>,
		drop_cycle = 1
	};

get(376) ->
	#special_drop_type_conf{
		drop_type = 376,
		drop_limit = 5,
		drop_unit = <<"day">>,
		drop_cycle = 1
	};

get(377) ->
	#special_drop_type_conf{
		drop_type = 377,
		drop_limit = 5,
		drop_unit = <<"day">>,
		drop_cycle = 1
	};

get(378) ->
	#special_drop_type_conf{
		drop_type = 378,
		drop_limit = 2,
		drop_unit = <<"day">>,
		drop_cycle = 1
	};

get(379) ->
	#special_drop_type_conf{
		drop_type = 379,
		drop_limit = 4,
		drop_unit = <<"day">>,
		drop_cycle = 1
	};

get(380) ->
	#special_drop_type_conf{
		drop_type = 380,
		drop_limit = 6,
		drop_unit = <<"day">>,
		drop_cycle = 1
	};

get(381) ->
	#special_drop_type_conf{
		drop_type = 381,
		drop_limit = 4,
		drop_unit = <<"hour">>,
		drop_cycle = 1
	};

get(382) ->
	#special_drop_type_conf{
		drop_type = 382,
		drop_limit = 1,
		drop_unit = <<"day">>,
		drop_cycle = 7
	};

get(383) ->
	#special_drop_type_conf{
		drop_type = 383,
		drop_limit = 2,
		drop_unit = <<"day">>,
		drop_cycle = 7
	};

get(384) ->
	#special_drop_type_conf{
		drop_type = 384,
		drop_limit = 1,
		drop_unit = <<"day">>,
		drop_cycle = 7
	};

get(385) ->
	#special_drop_type_conf{
		drop_type = 385,
		drop_limit = 2,
		drop_unit = <<"hour">>,
		drop_cycle = 1
	};

get(386) ->
	#special_drop_type_conf{
		drop_type = 386,
		drop_limit = 1,
		drop_unit = <<"day">>,
		drop_cycle = 7
	};

get(387) ->
	#special_drop_type_conf{
		drop_type = 387,
		drop_limit = 2,
		drop_unit = <<"day">>,
		drop_cycle = 3
	};

get(388) ->
	#special_drop_type_conf{
		drop_type = 388,
		drop_limit = 3,
		drop_unit = <<"hour">>,
		drop_cycle = 1
	};

get(389) ->
	#special_drop_type_conf{
		drop_type = 389,
		drop_limit = 1,
		drop_unit = <<"day">>,
		drop_cycle = 7
	};

get(390) ->
	#special_drop_type_conf{
		drop_type = 390,
		drop_limit = 1,
		drop_unit = <<"hour">>,
		drop_cycle = 1
	};

get(391) ->
	#special_drop_type_conf{
		drop_type = 391,
		drop_limit = 6,
		drop_unit = <<"hour">>,
		drop_cycle = 3
	};

get(392) ->
	#special_drop_type_conf{
		drop_type = 392,
		drop_limit = 1,
		drop_unit = <<"day">>,
		drop_cycle = 7
	};

get(393) ->
	#special_drop_type_conf{
		drop_type = 393,
		drop_limit = 1,
		drop_unit = <<"day">>,
		drop_cycle = 7
	};

get(394) ->
	#special_drop_type_conf{
		drop_type = 394,
		drop_limit = 1,
		drop_unit = <<"day">>,
		drop_cycle = 7
	};

get(395) ->
	#special_drop_type_conf{
		drop_type = 395,
		drop_limit = 1,
		drop_unit = <<"day">>,
		drop_cycle = 7
	};

get(396) ->
	#special_drop_type_conf{
		drop_type = 396,
		drop_limit = 1,
		drop_unit = <<"day">>,
		drop_cycle = 7
	};

get(397) ->
	#special_drop_type_conf{
		drop_type = 397,
		drop_limit = 2,
		drop_unit = <<"day">>,
		drop_cycle = 1
	};

get(398) ->
	#special_drop_type_conf{
		drop_type = 398,
		drop_limit = 4,
		drop_unit = <<"day">>,
		drop_cycle = 1
	};

get(399) ->
	#special_drop_type_conf{
		drop_type = 399,
		drop_limit = 400,
		drop_unit = <<"day">>,
		drop_cycle = 1
	};

get(400) ->
	#special_drop_type_conf{
		drop_type = 400,
		drop_limit = 80,
		drop_unit = <<"day">>,
		drop_cycle = 1
	};

get(401) ->
	#special_drop_type_conf{
		drop_type = 401,
		drop_limit = 2,
		drop_unit = <<"day">>,
		drop_cycle = 1
	};

get(402) ->
	#special_drop_type_conf{
		drop_type = 402,
		drop_limit = 4,
		drop_unit = <<"day">>,
		drop_cycle = 1
	};

get(403) ->
	#special_drop_type_conf{
		drop_type = 403,
		drop_limit = 4,
		drop_unit = <<"hour">>,
		drop_cycle = 1
	};

get(404) ->
	#special_drop_type_conf{
		drop_type = 404,
		drop_limit = 2,
		drop_unit = <<"hour">>,
		drop_cycle = 1
	};

get(405) ->
	#special_drop_type_conf{
		drop_type = 405,
		drop_limit = 1,
		drop_unit = <<"day">>,
		drop_cycle = 3
	};

get(406) ->
	#special_drop_type_conf{
		drop_type = 406,
		drop_limit = 99,
		drop_unit = <<"hour">>,
		drop_cycle = 3
	};

get(407) ->
	#special_drop_type_conf{
		drop_type = 407,
		drop_limit = 99,
		drop_unit = <<"hour">>,
		drop_cycle = 3
	};

get(408) ->
	#special_drop_type_conf{
		drop_type = 408,
		drop_limit = 99,
		drop_unit = <<"hour">>,
		drop_cycle = 3
	};

get(409) ->
	#special_drop_type_conf{
		drop_type = 409,
		drop_limit = 99,
		drop_unit = <<"hour">>,
		drop_cycle = 3
	};

get(410) ->
	#special_drop_type_conf{
		drop_type = 410,
		drop_limit = 99,
		drop_unit = <<"hour">>,
		drop_cycle = 3
	};

get(411) ->
	#special_drop_type_conf{
		drop_type = 411,
		drop_limit = 99,
		drop_unit = <<"hour">>,
		drop_cycle = 3
	};

get(412) ->
	#special_drop_type_conf{
		drop_type = 412,
		drop_limit = 99,
		drop_unit = <<"hour">>,
		drop_cycle = 3
	};

get(413) ->
	#special_drop_type_conf{
		drop_type = 413,
		drop_limit = 99,
		drop_unit = <<"hour">>,
		drop_cycle = 3
	};

get(414) ->
	#special_drop_type_conf{
		drop_type = 414,
		drop_limit = 99,
		drop_unit = <<"hour">>,
		drop_cycle = 3
	};

get(415) ->
	#special_drop_type_conf{
		drop_type = 415,
		drop_limit = 99,
		drop_unit = <<"hour">>,
		drop_cycle = 3
	};

get(416) ->
	#special_drop_type_conf{
		drop_type = 416,
		drop_limit = 5,
		drop_unit = <<"day">>,
		drop_cycle = 1
	};

get(417) ->
	#special_drop_type_conf{
		drop_type = 417,
		drop_limit = 18,
		drop_unit = <<"day">>,
		drop_cycle = 1
	};

get(418) ->
	#special_drop_type_conf{
		drop_type = 418,
		drop_limit = 30,
		drop_unit = <<"day">>,
		drop_cycle = 1
	};

get(419) ->
	#special_drop_type_conf{
		drop_type = 419,
		drop_limit = 6,
		drop_unit = <<"day">>,
		drop_cycle = 1
	};

get(420) ->
	#special_drop_type_conf{
		drop_type = 420,
		drop_limit = 2,
		drop_unit = <<"day">>,
		drop_cycle = 1
	};

get(421) ->
	#special_drop_type_conf{
		drop_type = 421,
		drop_limit = 4,
		drop_unit = <<"day">>,
		drop_cycle = 1
	};

get(422) ->
	#special_drop_type_conf{
		drop_type = 422,
		drop_limit = 1,
		drop_unit = <<"day">>,
		drop_cycle = 1
	};

get(423) ->
	#special_drop_type_conf{
		drop_type = 423,
		drop_limit = 3,
		drop_unit = <<"hour">>,
		drop_cycle = 1
	};

get(424) ->
	#special_drop_type_conf{
		drop_type = 424,
		drop_limit = 2,
		drop_unit = <<"hour">>,
		drop_cycle = 1
	};

get(425) ->
	#special_drop_type_conf{
		drop_type = 425,
		drop_limit = 3,
		drop_unit = <<"hour">>,
		drop_cycle = 1
	};

get(426) ->
	#special_drop_type_conf{
		drop_type = 426,
		drop_limit = 1,
		drop_unit = <<"hour">>,
		drop_cycle = 1
	};

get(427) ->
	#special_drop_type_conf{
		drop_type = 427,
		drop_limit = 4,
		drop_unit = <<"hour">>,
		drop_cycle = 1
	};

get(428) ->
	#special_drop_type_conf{
		drop_type = 428,
		drop_limit = 1,
		drop_unit = <<"hour">>,
		drop_cycle = 1
	};

get(429) ->
	#special_drop_type_conf{
		drop_type = 429,
		drop_limit = 1,
		drop_unit = <<"hour">>,
		drop_cycle = 1
	};

get(430) ->
	#special_drop_type_conf{
		drop_type = 430,
		drop_limit = 5,
		drop_unit = <<"hour">>,
		drop_cycle = 1
	};

get(431) ->
	#special_drop_type_conf{
		drop_type = 431,
		drop_limit = 1,
		drop_unit = <<"hour">>,
		drop_cycle = 1
	};

get(432) ->
	#special_drop_type_conf{
		drop_type = 432,
		drop_limit = 1,
		drop_unit = <<"hour">>,
		drop_cycle = 1
	};

get(_Key) ->
	 null.