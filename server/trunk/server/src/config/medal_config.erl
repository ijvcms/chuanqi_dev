%%%-------------------------------------------------------------------
%%% @author zhengsiying
%%% @doc
%%%		自动生成文件，不要手动修改
%%% @end
%%% Created : 2016/10/12
%%%-------------------------------------------------------------------

-module(medal_config).

-include("common.hrl").
-include("config.hrl").

-compile([export_all]).

get_list_conf() ->
	[ medal_config:get(X) || X <- get_list() ].

get_list() ->
	[101, 102, 103, 104, 105, 106, 107, 108, 109, 110, 111, 112, 113, 114, 115, 116, 117, 118, 119, 120, 121, 122, 123, 124, 125, 126, 127, 128, 129, 130, 131, 132, 133, 134, 135, 136, 137, 138, 139, 140, 141, 142, 143, 144, 145, 146, 147, 148, 149, 150, 151, 152, 153, 154, 155, 156, 157, 158, 159, 160, 161, 162, 163, 164, 165, 166, 167, 168, 169, 170, 171, 172, 173, 174, 175, 176, 177, 178, 179, 180, 181, 182, 183, 184, 185, 186, 187, 188, 189, 190, 191, 192, 193, 194, 195, 196, 197, 198, 199, 301, 302, 303, 304, 305, 306, 307, 308, 309, 310, 311, 312, 313, 314, 315, 316, 317, 318, 319, 320, 321, 322, 323, 324, 325, 326, 327, 328, 329, 330, 331, 332, 333, 334, 335, 336, 337, 338, 339, 340, 341, 342, 343, 344, 345, 346, 347, 348, 349, 350, 351, 352, 353, 354, 355, 356, 357, 358, 359, 360, 361, 362, 363, 364, 365, 366, 367, 368, 369, 370, 371, 372, 373, 374, 375, 376, 377, 378, 379, 380, 381, 382, 383, 384, 385, 386, 387, 388, 389, 390, 391, 392, 393, 394, 395, 396, 397, 398, 399, 501, 502, 503, 504, 505, 506, 507, 508, 509, 510, 511, 512, 513, 514, 515, 516, 517, 518, 519, 520, 521, 522, 523, 524, 525, 526, 527, 528, 529, 530, 531, 532, 533, 534, 535, 536, 537, 538, 539, 540, 541, 542, 543, 544, 545, 546, 547, 548, 549, 550, 551, 552, 553, 554, 555, 556, 557, 558, 559, 560, 561, 562, 563, 564, 565, 566, 567, 568, 569, 570, 571, 572, 573, 574, 575, 576, 577, 578, 579, 580, 581, 582, 583, 584, 585, 586, 587, 588, 589, 590, 591, 592, 593, 594, 595, 596, 597, 598, 599, 200, 201, 202, 203, 204, 205, 206, 207, 208, 209, 210, 211, 212, 213, 214, 215, 216, 217, 218, 219, 220, 221, 222, 223, 224, 225, 226, 227, 228, 229, 230, 231, 232, 233, 234, 235, 236, 237, 238, 239, 240, 241, 242, 243, 244, 400, 401, 402, 403, 404, 405, 406, 407, 408, 409, 410, 411, 412, 413, 414, 415, 416, 417, 418, 419, 420, 421, 422, 423, 424, 425, 426, 427, 428, 429, 430, 431, 432, 433, 434, 435, 436, 437, 438, 439, 440, 441, 442, 443, 444, 600, 601, 602, 603, 604, 605, 606, 607, 608, 609, 610, 611, 612, 613, 614, 615, 616, 617, 618, 619, 620, 621, 622, 623, 624, 625, 626, 627, 628, 629, 630, 631, 632, 633, 634, 635, 636, 637, 638, 639, 640, 641, 642, 643, 644].

get(101) ->
	#medal_conf{
		key = 101,
		goods_id = 306000,
		career = 1000,
		need_feats = 800,
		limit_lv = 25,
		next_id = 306001
	};

get(102) ->
	#medal_conf{
		key = 102,
		goods_id = 306001,
		career = 1000,
		need_feats = 960,
		limit_lv = 25,
		next_id = 306002
	};

get(103) ->
	#medal_conf{
		key = 103,
		goods_id = 306002,
		career = 1000,
		need_feats = 1120,
		limit_lv = 25,
		next_id = 306003
	};

get(104) ->
	#medal_conf{
		key = 104,
		goods_id = 306003,
		career = 1000,
		need_feats = 1280,
		limit_lv = 25,
		next_id = 306004
	};

get(105) ->
	#medal_conf{
		key = 105,
		goods_id = 306004,
		career = 1000,
		need_feats = 1440,
		limit_lv = 25,
		next_id = 306005
	};

get(106) ->
	#medal_conf{
		key = 106,
		goods_id = 306005,
		career = 1000,
		need_feats = 1600,
		limit_lv = 25,
		next_id = 306006
	};

get(107) ->
	#medal_conf{
		key = 107,
		goods_id = 306006,
		career = 1000,
		need_feats = 1760,
		limit_lv = 25,
		next_id = 306007
	};

get(108) ->
	#medal_conf{
		key = 108,
		goods_id = 306007,
		career = 1000,
		need_feats = 1920,
		limit_lv = 25,
		next_id = 306008
	};

get(109) ->
	#medal_conf{
		key = 109,
		goods_id = 306008,
		career = 1000,
		need_feats = 2080,
		limit_lv = 25,
		next_id = 306009
	};

get(110) ->
	#medal_conf{
		key = 110,
		goods_id = 306009,
		career = 1000,
		need_feats = 2240,
		limit_lv = 25,
		next_id = 306010
	};

get(111) ->
	#medal_conf{
		key = 111,
		goods_id = 306010,
		career = 1000,
		need_feats = 2400,
		limit_lv = 30,
		next_id = 306011
	};

get(112) ->
	#medal_conf{
		key = 112,
		goods_id = 306011,
		career = 1000,
		need_feats = 2560,
		limit_lv = 30,
		next_id = 306012
	};

get(113) ->
	#medal_conf{
		key = 113,
		goods_id = 306012,
		career = 1000,
		need_feats = 2720,
		limit_lv = 30,
		next_id = 306013
	};

get(114) ->
	#medal_conf{
		key = 114,
		goods_id = 306013,
		career = 1000,
		need_feats = 2880,
		limit_lv = 30,
		next_id = 306014
	};

get(115) ->
	#medal_conf{
		key = 115,
		goods_id = 306014,
		career = 1000,
		need_feats = 3040,
		limit_lv = 30,
		next_id = 306015
	};

get(116) ->
	#medal_conf{
		key = 116,
		goods_id = 306015,
		career = 1000,
		need_feats = 3200,
		limit_lv = 30,
		next_id = 306016
	};

get(117) ->
	#medal_conf{
		key = 117,
		goods_id = 306016,
		career = 1000,
		need_feats = 3370,
		limit_lv = 30,
		next_id = 306017
	};

get(118) ->
	#medal_conf{
		key = 118,
		goods_id = 306017,
		career = 1000,
		need_feats = 3530,
		limit_lv = 30,
		next_id = 306018
	};

get(119) ->
	#medal_conf{
		key = 119,
		goods_id = 306018,
		career = 1000,
		need_feats = 3690,
		limit_lv = 30,
		next_id = 306019
	};

get(120) ->
	#medal_conf{
		key = 120,
		goods_id = 306019,
		career = 1000,
		need_feats = 3850,
		limit_lv = 30,
		next_id = 306020
	};

get(121) ->
	#medal_conf{
		key = 121,
		goods_id = 306020,
		career = 1000,
		need_feats = 4010,
		limit_lv = 35,
		next_id = 306021
	};

get(122) ->
	#medal_conf{
		key = 122,
		goods_id = 306021,
		career = 1000,
		need_feats = 4170,
		limit_lv = 35,
		next_id = 306022
	};

get(123) ->
	#medal_conf{
		key = 123,
		goods_id = 306022,
		career = 1000,
		need_feats = 4330,
		limit_lv = 35,
		next_id = 306023
	};

get(124) ->
	#medal_conf{
		key = 124,
		goods_id = 306023,
		career = 1000,
		need_feats = 4490,
		limit_lv = 35,
		next_id = 306024
	};

get(125) ->
	#medal_conf{
		key = 125,
		goods_id = 306024,
		career = 1000,
		need_feats = 4650,
		limit_lv = 35,
		next_id = 306025
	};

get(126) ->
	#medal_conf{
		key = 126,
		goods_id = 306025,
		career = 1000,
		need_feats = 4810,
		limit_lv = 35,
		next_id = 306026
	};

get(127) ->
	#medal_conf{
		key = 127,
		goods_id = 306026,
		career = 1000,
		need_feats = 4970,
		limit_lv = 35,
		next_id = 306027
	};

get(128) ->
	#medal_conf{
		key = 128,
		goods_id = 306027,
		career = 1000,
		need_feats = 5130,
		limit_lv = 35,
		next_id = 306028
	};

get(129) ->
	#medal_conf{
		key = 129,
		goods_id = 306028,
		career = 1000,
		need_feats = 5290,
		limit_lv = 35,
		next_id = 306029
	};

get(130) ->
	#medal_conf{
		key = 130,
		goods_id = 306029,
		career = 1000,
		need_feats = 5450,
		limit_lv = 35,
		next_id = 306030
	};

get(131) ->
	#medal_conf{
		key = 131,
		goods_id = 306030,
		career = 1000,
		need_feats = 5610,
		limit_lv = 40,
		next_id = 306031
	};

get(132) ->
	#medal_conf{
		key = 132,
		goods_id = 306031,
		career = 1000,
		need_feats = 5770,
		limit_lv = 40,
		next_id = 306032
	};

get(133) ->
	#medal_conf{
		key = 133,
		goods_id = 306032,
		career = 1000,
		need_feats = 5930,
		limit_lv = 40,
		next_id = 306033
	};

get(134) ->
	#medal_conf{
		key = 134,
		goods_id = 306033,
		career = 1000,
		need_feats = 6090,
		limit_lv = 40,
		next_id = 306034
	};

get(135) ->
	#medal_conf{
		key = 135,
		goods_id = 306034,
		career = 1000,
		need_feats = 6250,
		limit_lv = 40,
		next_id = 306035
	};

get(136) ->
	#medal_conf{
		key = 136,
		goods_id = 306035,
		career = 1000,
		need_feats = 6410,
		limit_lv = 40,
		next_id = 306036
	};

get(137) ->
	#medal_conf{
		key = 137,
		goods_id = 306036,
		career = 1000,
		need_feats = 6580,
		limit_lv = 40,
		next_id = 306037
	};

get(138) ->
	#medal_conf{
		key = 138,
		goods_id = 306037,
		career = 1000,
		need_feats = 6740,
		limit_lv = 40,
		next_id = 306038
	};

get(139) ->
	#medal_conf{
		key = 139,
		goods_id = 306038,
		career = 1000,
		need_feats = 6900,
		limit_lv = 40,
		next_id = 306039
	};

get(140) ->
	#medal_conf{
		key = 140,
		goods_id = 306039,
		career = 1000,
		need_feats = 7060,
		limit_lv = 40,
		next_id = 306040
	};

get(141) ->
	#medal_conf{
		key = 141,
		goods_id = 306040,
		career = 1000,
		need_feats = 7220,
		limit_lv = 45,
		next_id = 306041
	};

get(142) ->
	#medal_conf{
		key = 142,
		goods_id = 306041,
		career = 1000,
		need_feats = 7380,
		limit_lv = 45,
		next_id = 306042
	};

get(143) ->
	#medal_conf{
		key = 143,
		goods_id = 306042,
		career = 1000,
		need_feats = 7540,
		limit_lv = 45,
		next_id = 306043
	};

get(144) ->
	#medal_conf{
		key = 144,
		goods_id = 306043,
		career = 1000,
		need_feats = 7700,
		limit_lv = 45,
		next_id = 306044
	};

get(145) ->
	#medal_conf{
		key = 145,
		goods_id = 306044,
		career = 1000,
		need_feats = 7860,
		limit_lv = 45,
		next_id = 306045
	};

get(146) ->
	#medal_conf{
		key = 146,
		goods_id = 306045,
		career = 1000,
		need_feats = 8020,
		limit_lv = 45,
		next_id = 306046
	};

get(147) ->
	#medal_conf{
		key = 147,
		goods_id = 306046,
		career = 1000,
		need_feats = 8180,
		limit_lv = 45,
		next_id = 306047
	};

get(148) ->
	#medal_conf{
		key = 148,
		goods_id = 306047,
		career = 1000,
		need_feats = 8340,
		limit_lv = 45,
		next_id = 306048
	};

get(149) ->
	#medal_conf{
		key = 149,
		goods_id = 306048,
		career = 1000,
		need_feats = 8500,
		limit_lv = 45,
		next_id = 306049
	};

get(150) ->
	#medal_conf{
		key = 150,
		goods_id = 306049,
		career = 1000,
		need_feats = 8660,
		limit_lv = 45,
		next_id = 306050
	};

get(151) ->
	#medal_conf{
		key = 151,
		goods_id = 306050,
		career = 1000,
		need_feats = 8820,
		limit_lv = 50,
		next_id = 306051
	};

get(152) ->
	#medal_conf{
		key = 152,
		goods_id = 306051,
		career = 1000,
		need_feats = 8980,
		limit_lv = 50,
		next_id = 306052
	};

get(153) ->
	#medal_conf{
		key = 153,
		goods_id = 306052,
		career = 1000,
		need_feats = 9140,
		limit_lv = 50,
		next_id = 306053
	};

get(154) ->
	#medal_conf{
		key = 154,
		goods_id = 306053,
		career = 1000,
		need_feats = 9300,
		limit_lv = 50,
		next_id = 306054
	};

get(155) ->
	#medal_conf{
		key = 155,
		goods_id = 306054,
		career = 1000,
		need_feats = 9460,
		limit_lv = 50,
		next_id = 306055
	};

get(156) ->
	#medal_conf{
		key = 156,
		goods_id = 306055,
		career = 1000,
		need_feats = 9620,
		limit_lv = 50,
		next_id = 306056
	};

get(157) ->
	#medal_conf{
		key = 157,
		goods_id = 306056,
		career = 1000,
		need_feats = 9790,
		limit_lv = 50,
		next_id = 306057
	};

get(158) ->
	#medal_conf{
		key = 158,
		goods_id = 306057,
		career = 1000,
		need_feats = 9950,
		limit_lv = 50,
		next_id = 306058
	};

get(159) ->
	#medal_conf{
		key = 159,
		goods_id = 306058,
		career = 1000,
		need_feats = 10110,
		limit_lv = 50,
		next_id = 306059
	};

get(160) ->
	#medal_conf{
		key = 160,
		goods_id = 306059,
		career = 1000,
		need_feats = 10270,
		limit_lv = 50,
		next_id = 306060
	};

get(161) ->
	#medal_conf{
		key = 161,
		goods_id = 306060,
		career = 1000,
		need_feats = 10430,
		limit_lv = 50,
		next_id = 306061
	};

get(162) ->
	#medal_conf{
		key = 162,
		goods_id = 306061,
		career = 1000,
		need_feats = 10590,
		limit_lv = 50,
		next_id = 306062
	};

get(163) ->
	#medal_conf{
		key = 163,
		goods_id = 306062,
		career = 1000,
		need_feats = 10750,
		limit_lv = 50,
		next_id = 306063
	};

get(164) ->
	#medal_conf{
		key = 164,
		goods_id = 306063,
		career = 1000,
		need_feats = 10910,
		limit_lv = 50,
		next_id = 306064
	};

get(165) ->
	#medal_conf{
		key = 165,
		goods_id = 306064,
		career = 1000,
		need_feats = 11070,
		limit_lv = 50,
		next_id = 306065
	};

get(166) ->
	#medal_conf{
		key = 166,
		goods_id = 306065,
		career = 1000,
		need_feats = 11230,
		limit_lv = 50,
		next_id = 306066
	};

get(167) ->
	#medal_conf{
		key = 167,
		goods_id = 306066,
		career = 1000,
		need_feats = 11390,
		limit_lv = 50,
		next_id = 306067
	};

get(168) ->
	#medal_conf{
		key = 168,
		goods_id = 306067,
		career = 1000,
		need_feats = 11550,
		limit_lv = 50,
		next_id = 306068
	};

get(169) ->
	#medal_conf{
		key = 169,
		goods_id = 306068,
		career = 1000,
		need_feats = 11710,
		limit_lv = 50,
		next_id = 306069
	};

get(170) ->
	#medal_conf{
		key = 170,
		goods_id = 306069,
		career = 1000,
		need_feats = 11870,
		limit_lv = 50,
		next_id = 306070
	};

get(171) ->
	#medal_conf{
		key = 171,
		goods_id = 306070,
		career = 1000,
		need_feats = 12030,
		limit_lv = 50,
		next_id = 306071
	};

get(172) ->
	#medal_conf{
		key = 172,
		goods_id = 306071,
		career = 1000,
		need_feats = 12190,
		limit_lv = 50,
		next_id = 306072
	};

get(173) ->
	#medal_conf{
		key = 173,
		goods_id = 306072,
		career = 1000,
		need_feats = 12350,
		limit_lv = 50,
		next_id = 306073
	};

get(174) ->
	#medal_conf{
		key = 174,
		goods_id = 306073,
		career = 1000,
		need_feats = 12510,
		limit_lv = 50,
		next_id = 306074
	};

get(175) ->
	#medal_conf{
		key = 175,
		goods_id = 306074,
		career = 1000,
		need_feats = 12670,
		limit_lv = 50,
		next_id = 306075
	};

get(176) ->
	#medal_conf{
		key = 176,
		goods_id = 306075,
		career = 1000,
		need_feats = 12830,
		limit_lv = 50,
		next_id = 306076
	};

get(177) ->
	#medal_conf{
		key = 177,
		goods_id = 306076,
		career = 1000,
		need_feats = 13000,
		limit_lv = 50,
		next_id = 306077
	};

get(178) ->
	#medal_conf{
		key = 178,
		goods_id = 306077,
		career = 1000,
		need_feats = 13160,
		limit_lv = 50,
		next_id = 306078
	};

get(179) ->
	#medal_conf{
		key = 179,
		goods_id = 306078,
		career = 1000,
		need_feats = 13320,
		limit_lv = 50,
		next_id = 306079
	};

get(180) ->
	#medal_conf{
		key = 180,
		goods_id = 306079,
		career = 1000,
		need_feats = 13480,
		limit_lv = 50,
		next_id = 306080
	};

get(181) ->
	#medal_conf{
		key = 181,
		goods_id = 306080,
		career = 1000,
		need_feats = 13640,
		limit_lv = 50,
		next_id = 306081
	};

get(182) ->
	#medal_conf{
		key = 182,
		goods_id = 306081,
		career = 1000,
		need_feats = 14444,
		limit_lv = 50,
		next_id = 306082
	};

get(183) ->
	#medal_conf{
		key = 183,
		goods_id = 306082,
		career = 1000,
		need_feats = 15246,
		limit_lv = 50,
		next_id = 306083
	};

get(184) ->
	#medal_conf{
		key = 184,
		goods_id = 306083,
		career = 1000,
		need_feats = 16049,
		limit_lv = 50,
		next_id = 306084
	};

get(185) ->
	#medal_conf{
		key = 185,
		goods_id = 306084,
		career = 1000,
		need_feats = 16851,
		limit_lv = 50,
		next_id = 306085
	};

get(186) ->
	#medal_conf{
		key = 186,
		goods_id = 306085,
		career = 1000,
		need_feats = 17654,
		limit_lv = 50,
		next_id = 306086
	};

get(187) ->
	#medal_conf{
		key = 187,
		goods_id = 306086,
		career = 1000,
		need_feats = 18456,
		limit_lv = 50,
		next_id = 306087
	};

get(188) ->
	#medal_conf{
		key = 188,
		goods_id = 306087,
		career = 1000,
		need_feats = 19259,
		limit_lv = 50,
		next_id = 306088
	};

get(189) ->
	#medal_conf{
		key = 189,
		goods_id = 306088,
		career = 1000,
		need_feats = 20061,
		limit_lv = 50,
		next_id = 306089
	};

get(190) ->
	#medal_conf{
		key = 190,
		goods_id = 306089,
		career = 1000,
		need_feats = 20864,
		limit_lv = 50,
		next_id = 306090
	};

get(191) ->
	#medal_conf{
		key = 191,
		goods_id = 306090,
		career = 1000,
		need_feats = 21666,
		limit_lv = 50,
		next_id = 306091
	};

get(192) ->
	#medal_conf{
		key = 192,
		goods_id = 306091,
		career = 1000,
		need_feats = 22469,
		limit_lv = 50,
		next_id = 306092
	};

get(193) ->
	#medal_conf{
		key = 193,
		goods_id = 306092,
		career = 1000,
		need_feats = 23271,
		limit_lv = 50,
		next_id = 306093
	};

get(194) ->
	#medal_conf{
		key = 194,
		goods_id = 306093,
		career = 1000,
		need_feats = 24074,
		limit_lv = 50,
		next_id = 306094
	};

get(195) ->
	#medal_conf{
		key = 195,
		goods_id = 306094,
		career = 1000,
		need_feats = 24876,
		limit_lv = 50,
		next_id = 306095
	};

get(196) ->
	#medal_conf{
		key = 196,
		goods_id = 306095,
		career = 1000,
		need_feats = 25679,
		limit_lv = 50,
		next_id = 306096
	};

get(197) ->
	#medal_conf{
		key = 197,
		goods_id = 306096,
		career = 1000,
		need_feats = 26481,
		limit_lv = 50,
		next_id = 306097
	};

get(198) ->
	#medal_conf{
		key = 198,
		goods_id = 306097,
		career = 1000,
		need_feats = 27283,
		limit_lv = 50,
		next_id = 306098
	};

get(199) ->
	#medal_conf{
		key = 199,
		goods_id = 306098,
		career = 1000,
		need_feats = 28086,
		limit_lv = 50,
		next_id = 306099
	};

get(301) ->
	#medal_conf{
		key = 301,
		goods_id = 306200,
		career = 2000,
		need_feats = 800,
		limit_lv = 25,
		next_id = 306201
	};

get(302) ->
	#medal_conf{
		key = 302,
		goods_id = 306201,
		career = 2000,
		need_feats = 960,
		limit_lv = 25,
		next_id = 306202
	};

get(303) ->
	#medal_conf{
		key = 303,
		goods_id = 306202,
		career = 2000,
		need_feats = 1120,
		limit_lv = 25,
		next_id = 306203
	};

get(304) ->
	#medal_conf{
		key = 304,
		goods_id = 306203,
		career = 2000,
		need_feats = 1280,
		limit_lv = 25,
		next_id = 306204
	};

get(305) ->
	#medal_conf{
		key = 305,
		goods_id = 306204,
		career = 2000,
		need_feats = 1440,
		limit_lv = 25,
		next_id = 306205
	};

get(306) ->
	#medal_conf{
		key = 306,
		goods_id = 306205,
		career = 2000,
		need_feats = 1600,
		limit_lv = 25,
		next_id = 306206
	};

get(307) ->
	#medal_conf{
		key = 307,
		goods_id = 306206,
		career = 2000,
		need_feats = 1760,
		limit_lv = 25,
		next_id = 306207
	};

get(308) ->
	#medal_conf{
		key = 308,
		goods_id = 306207,
		career = 2000,
		need_feats = 1920,
		limit_lv = 25,
		next_id = 306208
	};

get(309) ->
	#medal_conf{
		key = 309,
		goods_id = 306208,
		career = 2000,
		need_feats = 2080,
		limit_lv = 25,
		next_id = 306209
	};

get(310) ->
	#medal_conf{
		key = 310,
		goods_id = 306209,
		career = 2000,
		need_feats = 2240,
		limit_lv = 25,
		next_id = 306210
	};

get(311) ->
	#medal_conf{
		key = 311,
		goods_id = 306210,
		career = 2000,
		need_feats = 2400,
		limit_lv = 30,
		next_id = 306211
	};

get(312) ->
	#medal_conf{
		key = 312,
		goods_id = 306211,
		career = 2000,
		need_feats = 2560,
		limit_lv = 30,
		next_id = 306212
	};

get(313) ->
	#medal_conf{
		key = 313,
		goods_id = 306212,
		career = 2000,
		need_feats = 2720,
		limit_lv = 30,
		next_id = 306213
	};

get(314) ->
	#medal_conf{
		key = 314,
		goods_id = 306213,
		career = 2000,
		need_feats = 2880,
		limit_lv = 30,
		next_id = 306214
	};

get(315) ->
	#medal_conf{
		key = 315,
		goods_id = 306214,
		career = 2000,
		need_feats = 3040,
		limit_lv = 30,
		next_id = 306215
	};

get(316) ->
	#medal_conf{
		key = 316,
		goods_id = 306215,
		career = 2000,
		need_feats = 3200,
		limit_lv = 30,
		next_id = 306216
	};

get(317) ->
	#medal_conf{
		key = 317,
		goods_id = 306216,
		career = 2000,
		need_feats = 3370,
		limit_lv = 30,
		next_id = 306217
	};

get(318) ->
	#medal_conf{
		key = 318,
		goods_id = 306217,
		career = 2000,
		need_feats = 3530,
		limit_lv = 30,
		next_id = 306218
	};

get(319) ->
	#medal_conf{
		key = 319,
		goods_id = 306218,
		career = 2000,
		need_feats = 3690,
		limit_lv = 30,
		next_id = 306219
	};

get(320) ->
	#medal_conf{
		key = 320,
		goods_id = 306219,
		career = 2000,
		need_feats = 3850,
		limit_lv = 30,
		next_id = 306220
	};

get(321) ->
	#medal_conf{
		key = 321,
		goods_id = 306220,
		career = 2000,
		need_feats = 4010,
		limit_lv = 35,
		next_id = 306221
	};

get(322) ->
	#medal_conf{
		key = 322,
		goods_id = 306221,
		career = 2000,
		need_feats = 4170,
		limit_lv = 35,
		next_id = 306222
	};

get(323) ->
	#medal_conf{
		key = 323,
		goods_id = 306222,
		career = 2000,
		need_feats = 4330,
		limit_lv = 35,
		next_id = 306223
	};

get(324) ->
	#medal_conf{
		key = 324,
		goods_id = 306223,
		career = 2000,
		need_feats = 4490,
		limit_lv = 35,
		next_id = 306224
	};

get(325) ->
	#medal_conf{
		key = 325,
		goods_id = 306224,
		career = 2000,
		need_feats = 4650,
		limit_lv = 35,
		next_id = 306225
	};

get(326) ->
	#medal_conf{
		key = 326,
		goods_id = 306225,
		career = 2000,
		need_feats = 4810,
		limit_lv = 35,
		next_id = 306226
	};

get(327) ->
	#medal_conf{
		key = 327,
		goods_id = 306226,
		career = 2000,
		need_feats = 4970,
		limit_lv = 35,
		next_id = 306227
	};

get(328) ->
	#medal_conf{
		key = 328,
		goods_id = 306227,
		career = 2000,
		need_feats = 5130,
		limit_lv = 35,
		next_id = 306228
	};

get(329) ->
	#medal_conf{
		key = 329,
		goods_id = 306228,
		career = 2000,
		need_feats = 5290,
		limit_lv = 35,
		next_id = 306229
	};

get(330) ->
	#medal_conf{
		key = 330,
		goods_id = 306229,
		career = 2000,
		need_feats = 5450,
		limit_lv = 35,
		next_id = 306230
	};

get(331) ->
	#medal_conf{
		key = 331,
		goods_id = 306230,
		career = 2000,
		need_feats = 5610,
		limit_lv = 40,
		next_id = 306231
	};

get(332) ->
	#medal_conf{
		key = 332,
		goods_id = 306231,
		career = 2000,
		need_feats = 5770,
		limit_lv = 40,
		next_id = 306232
	};

get(333) ->
	#medal_conf{
		key = 333,
		goods_id = 306232,
		career = 2000,
		need_feats = 5930,
		limit_lv = 40,
		next_id = 306233
	};

get(334) ->
	#medal_conf{
		key = 334,
		goods_id = 306233,
		career = 2000,
		need_feats = 6090,
		limit_lv = 40,
		next_id = 306234
	};

get(335) ->
	#medal_conf{
		key = 335,
		goods_id = 306234,
		career = 2000,
		need_feats = 6250,
		limit_lv = 40,
		next_id = 306235
	};

get(336) ->
	#medal_conf{
		key = 336,
		goods_id = 306235,
		career = 2000,
		need_feats = 6410,
		limit_lv = 40,
		next_id = 306236
	};

get(337) ->
	#medal_conf{
		key = 337,
		goods_id = 306236,
		career = 2000,
		need_feats = 6580,
		limit_lv = 40,
		next_id = 306237
	};

get(338) ->
	#medal_conf{
		key = 338,
		goods_id = 306237,
		career = 2000,
		need_feats = 6740,
		limit_lv = 40,
		next_id = 306238
	};

get(339) ->
	#medal_conf{
		key = 339,
		goods_id = 306238,
		career = 2000,
		need_feats = 6900,
		limit_lv = 40,
		next_id = 306239
	};

get(340) ->
	#medal_conf{
		key = 340,
		goods_id = 306239,
		career = 2000,
		need_feats = 7060,
		limit_lv = 40,
		next_id = 306240
	};

get(341) ->
	#medal_conf{
		key = 341,
		goods_id = 306240,
		career = 2000,
		need_feats = 7220,
		limit_lv = 45,
		next_id = 306241
	};

get(342) ->
	#medal_conf{
		key = 342,
		goods_id = 306241,
		career = 2000,
		need_feats = 7380,
		limit_lv = 45,
		next_id = 306242
	};

get(343) ->
	#medal_conf{
		key = 343,
		goods_id = 306242,
		career = 2000,
		need_feats = 7540,
		limit_lv = 45,
		next_id = 306243
	};

get(344) ->
	#medal_conf{
		key = 344,
		goods_id = 306243,
		career = 2000,
		need_feats = 7700,
		limit_lv = 45,
		next_id = 306244
	};

get(345) ->
	#medal_conf{
		key = 345,
		goods_id = 306244,
		career = 2000,
		need_feats = 7860,
		limit_lv = 45,
		next_id = 306245
	};

get(346) ->
	#medal_conf{
		key = 346,
		goods_id = 306245,
		career = 2000,
		need_feats = 8020,
		limit_lv = 45,
		next_id = 306246
	};

get(347) ->
	#medal_conf{
		key = 347,
		goods_id = 306246,
		career = 2000,
		need_feats = 8180,
		limit_lv = 45,
		next_id = 306247
	};

get(348) ->
	#medal_conf{
		key = 348,
		goods_id = 306247,
		career = 2000,
		need_feats = 8340,
		limit_lv = 45,
		next_id = 306248
	};

get(349) ->
	#medal_conf{
		key = 349,
		goods_id = 306248,
		career = 2000,
		need_feats = 8500,
		limit_lv = 45,
		next_id = 306249
	};

get(350) ->
	#medal_conf{
		key = 350,
		goods_id = 306249,
		career = 2000,
		need_feats = 8660,
		limit_lv = 45,
		next_id = 306250
	};

get(351) ->
	#medal_conf{
		key = 351,
		goods_id = 306250,
		career = 2000,
		need_feats = 8820,
		limit_lv = 50,
		next_id = 306251
	};

get(352) ->
	#medal_conf{
		key = 352,
		goods_id = 306251,
		career = 2000,
		need_feats = 8980,
		limit_lv = 50,
		next_id = 306252
	};

get(353) ->
	#medal_conf{
		key = 353,
		goods_id = 306252,
		career = 2000,
		need_feats = 9140,
		limit_lv = 50,
		next_id = 306253
	};

get(354) ->
	#medal_conf{
		key = 354,
		goods_id = 306253,
		career = 2000,
		need_feats = 9300,
		limit_lv = 50,
		next_id = 306254
	};

get(355) ->
	#medal_conf{
		key = 355,
		goods_id = 306254,
		career = 2000,
		need_feats = 9460,
		limit_lv = 50,
		next_id = 306255
	};

get(356) ->
	#medal_conf{
		key = 356,
		goods_id = 306255,
		career = 2000,
		need_feats = 9620,
		limit_lv = 50,
		next_id = 306256
	};

get(357) ->
	#medal_conf{
		key = 357,
		goods_id = 306256,
		career = 2000,
		need_feats = 9790,
		limit_lv = 50,
		next_id = 306257
	};

get(358) ->
	#medal_conf{
		key = 358,
		goods_id = 306257,
		career = 2000,
		need_feats = 9950,
		limit_lv = 50,
		next_id = 306258
	};

get(359) ->
	#medal_conf{
		key = 359,
		goods_id = 306258,
		career = 2000,
		need_feats = 10110,
		limit_lv = 50,
		next_id = 306259
	};

get(360) ->
	#medal_conf{
		key = 360,
		goods_id = 306259,
		career = 2000,
		need_feats = 10270,
		limit_lv = 50,
		next_id = 306260
	};

get(361) ->
	#medal_conf{
		key = 361,
		goods_id = 306260,
		career = 2000,
		need_feats = 10430,
		limit_lv = 50,
		next_id = 306261
	};

get(362) ->
	#medal_conf{
		key = 362,
		goods_id = 306261,
		career = 2000,
		need_feats = 10590,
		limit_lv = 50,
		next_id = 306262
	};

get(363) ->
	#medal_conf{
		key = 363,
		goods_id = 306262,
		career = 2000,
		need_feats = 10750,
		limit_lv = 50,
		next_id = 306263
	};

get(364) ->
	#medal_conf{
		key = 364,
		goods_id = 306263,
		career = 2000,
		need_feats = 10910,
		limit_lv = 50,
		next_id = 306264
	};

get(365) ->
	#medal_conf{
		key = 365,
		goods_id = 306264,
		career = 2000,
		need_feats = 11070,
		limit_lv = 50,
		next_id = 306265
	};

get(366) ->
	#medal_conf{
		key = 366,
		goods_id = 306265,
		career = 2000,
		need_feats = 11230,
		limit_lv = 50,
		next_id = 306266
	};

get(367) ->
	#medal_conf{
		key = 367,
		goods_id = 306266,
		career = 2000,
		need_feats = 11390,
		limit_lv = 50,
		next_id = 306267
	};

get(368) ->
	#medal_conf{
		key = 368,
		goods_id = 306267,
		career = 2000,
		need_feats = 11550,
		limit_lv = 50,
		next_id = 306268
	};

get(369) ->
	#medal_conf{
		key = 369,
		goods_id = 306268,
		career = 2000,
		need_feats = 11710,
		limit_lv = 50,
		next_id = 306269
	};

get(370) ->
	#medal_conf{
		key = 370,
		goods_id = 306269,
		career = 2000,
		need_feats = 11870,
		limit_lv = 50,
		next_id = 306270
	};

get(371) ->
	#medal_conf{
		key = 371,
		goods_id = 306270,
		career = 2000,
		need_feats = 12030,
		limit_lv = 50,
		next_id = 306271
	};

get(372) ->
	#medal_conf{
		key = 372,
		goods_id = 306271,
		career = 2000,
		need_feats = 12190,
		limit_lv = 50,
		next_id = 306272
	};

get(373) ->
	#medal_conf{
		key = 373,
		goods_id = 306272,
		career = 2000,
		need_feats = 12350,
		limit_lv = 50,
		next_id = 306273
	};

get(374) ->
	#medal_conf{
		key = 374,
		goods_id = 306273,
		career = 2000,
		need_feats = 12510,
		limit_lv = 50,
		next_id = 306274
	};

get(375) ->
	#medal_conf{
		key = 375,
		goods_id = 306274,
		career = 2000,
		need_feats = 12670,
		limit_lv = 50,
		next_id = 306275
	};

get(376) ->
	#medal_conf{
		key = 376,
		goods_id = 306275,
		career = 2000,
		need_feats = 12830,
		limit_lv = 50,
		next_id = 306276
	};

get(377) ->
	#medal_conf{
		key = 377,
		goods_id = 306276,
		career = 2000,
		need_feats = 13000,
		limit_lv = 50,
		next_id = 306277
	};

get(378) ->
	#medal_conf{
		key = 378,
		goods_id = 306277,
		career = 2000,
		need_feats = 13160,
		limit_lv = 50,
		next_id = 306278
	};

get(379) ->
	#medal_conf{
		key = 379,
		goods_id = 306278,
		career = 2000,
		need_feats = 13320,
		limit_lv = 50,
		next_id = 306279
	};

get(380) ->
	#medal_conf{
		key = 380,
		goods_id = 306279,
		career = 2000,
		need_feats = 13480,
		limit_lv = 50,
		next_id = 306280
	};

get(381) ->
	#medal_conf{
		key = 381,
		goods_id = 306280,
		career = 2000,
		need_feats = 13640,
		limit_lv = 50,
		next_id = 306281
	};

get(382) ->
	#medal_conf{
		key = 382,
		goods_id = 306281,
		career = 2000,
		need_feats = 14444,
		limit_lv = 50,
		next_id = 306282
	};

get(383) ->
	#medal_conf{
		key = 383,
		goods_id = 306282,
		career = 2000,
		need_feats = 15246,
		limit_lv = 50,
		next_id = 306283
	};

get(384) ->
	#medal_conf{
		key = 384,
		goods_id = 306283,
		career = 2000,
		need_feats = 16049,
		limit_lv = 50,
		next_id = 306284
	};

get(385) ->
	#medal_conf{
		key = 385,
		goods_id = 306284,
		career = 2000,
		need_feats = 16851,
		limit_lv = 50,
		next_id = 306285
	};

get(386) ->
	#medal_conf{
		key = 386,
		goods_id = 306285,
		career = 2000,
		need_feats = 17654,
		limit_lv = 50,
		next_id = 306286
	};

get(387) ->
	#medal_conf{
		key = 387,
		goods_id = 306286,
		career = 2000,
		need_feats = 18456,
		limit_lv = 50,
		next_id = 306287
	};

get(388) ->
	#medal_conf{
		key = 388,
		goods_id = 306287,
		career = 2000,
		need_feats = 19259,
		limit_lv = 50,
		next_id = 306288
	};

get(389) ->
	#medal_conf{
		key = 389,
		goods_id = 306288,
		career = 2000,
		need_feats = 20061,
		limit_lv = 50,
		next_id = 306289
	};

get(390) ->
	#medal_conf{
		key = 390,
		goods_id = 306289,
		career = 2000,
		need_feats = 20864,
		limit_lv = 50,
		next_id = 306290
	};

get(391) ->
	#medal_conf{
		key = 391,
		goods_id = 306290,
		career = 2000,
		need_feats = 21666,
		limit_lv = 50,
		next_id = 306291
	};

get(392) ->
	#medal_conf{
		key = 392,
		goods_id = 306291,
		career = 2000,
		need_feats = 22469,
		limit_lv = 50,
		next_id = 306292
	};

get(393) ->
	#medal_conf{
		key = 393,
		goods_id = 306292,
		career = 2000,
		need_feats = 23271,
		limit_lv = 50,
		next_id = 306293
	};

get(394) ->
	#medal_conf{
		key = 394,
		goods_id = 306293,
		career = 2000,
		need_feats = 24074,
		limit_lv = 50,
		next_id = 306294
	};

get(395) ->
	#medal_conf{
		key = 395,
		goods_id = 306294,
		career = 2000,
		need_feats = 24876,
		limit_lv = 50,
		next_id = 306295
	};

get(396) ->
	#medal_conf{
		key = 396,
		goods_id = 306295,
		career = 2000,
		need_feats = 25679,
		limit_lv = 50,
		next_id = 306296
	};

get(397) ->
	#medal_conf{
		key = 397,
		goods_id = 306296,
		career = 2000,
		need_feats = 26481,
		limit_lv = 50,
		next_id = 306297
	};

get(398) ->
	#medal_conf{
		key = 398,
		goods_id = 306297,
		career = 2000,
		need_feats = 27283,
		limit_lv = 50,
		next_id = 306298
	};

get(399) ->
	#medal_conf{
		key = 399,
		goods_id = 306298,
		career = 2000,
		need_feats = 28086,
		limit_lv = 50,
		next_id = 306299
	};

get(501) ->
	#medal_conf{
		key = 501,
		goods_id = 306400,
		career = 3000,
		need_feats = 800,
		limit_lv = 25,
		next_id = 306401
	};

get(502) ->
	#medal_conf{
		key = 502,
		goods_id = 306401,
		career = 3000,
		need_feats = 960,
		limit_lv = 25,
		next_id = 306402
	};

get(503) ->
	#medal_conf{
		key = 503,
		goods_id = 306402,
		career = 3000,
		need_feats = 1120,
		limit_lv = 25,
		next_id = 306403
	};

get(504) ->
	#medal_conf{
		key = 504,
		goods_id = 306403,
		career = 3000,
		need_feats = 1280,
		limit_lv = 25,
		next_id = 306404
	};

get(505) ->
	#medal_conf{
		key = 505,
		goods_id = 306404,
		career = 3000,
		need_feats = 1440,
		limit_lv = 25,
		next_id = 306405
	};

get(506) ->
	#medal_conf{
		key = 506,
		goods_id = 306405,
		career = 3000,
		need_feats = 1600,
		limit_lv = 25,
		next_id = 306406
	};

get(507) ->
	#medal_conf{
		key = 507,
		goods_id = 306406,
		career = 3000,
		need_feats = 1760,
		limit_lv = 25,
		next_id = 306407
	};

get(508) ->
	#medal_conf{
		key = 508,
		goods_id = 306407,
		career = 3000,
		need_feats = 1920,
		limit_lv = 25,
		next_id = 306408
	};

get(509) ->
	#medal_conf{
		key = 509,
		goods_id = 306408,
		career = 3000,
		need_feats = 2080,
		limit_lv = 25,
		next_id = 306409
	};

get(510) ->
	#medal_conf{
		key = 510,
		goods_id = 306409,
		career = 3000,
		need_feats = 2240,
		limit_lv = 25,
		next_id = 306410
	};

get(511) ->
	#medal_conf{
		key = 511,
		goods_id = 306410,
		career = 3000,
		need_feats = 2400,
		limit_lv = 30,
		next_id = 306411
	};

get(512) ->
	#medal_conf{
		key = 512,
		goods_id = 306411,
		career = 3000,
		need_feats = 2560,
		limit_lv = 30,
		next_id = 306412
	};

get(513) ->
	#medal_conf{
		key = 513,
		goods_id = 306412,
		career = 3000,
		need_feats = 2720,
		limit_lv = 30,
		next_id = 306413
	};

get(514) ->
	#medal_conf{
		key = 514,
		goods_id = 306413,
		career = 3000,
		need_feats = 2880,
		limit_lv = 30,
		next_id = 306414
	};

get(515) ->
	#medal_conf{
		key = 515,
		goods_id = 306414,
		career = 3000,
		need_feats = 3040,
		limit_lv = 30,
		next_id = 306415
	};

get(516) ->
	#medal_conf{
		key = 516,
		goods_id = 306415,
		career = 3000,
		need_feats = 3200,
		limit_lv = 30,
		next_id = 306416
	};

get(517) ->
	#medal_conf{
		key = 517,
		goods_id = 306416,
		career = 3000,
		need_feats = 3370,
		limit_lv = 30,
		next_id = 306417
	};

get(518) ->
	#medal_conf{
		key = 518,
		goods_id = 306417,
		career = 3000,
		need_feats = 3530,
		limit_lv = 30,
		next_id = 306418
	};

get(519) ->
	#medal_conf{
		key = 519,
		goods_id = 306418,
		career = 3000,
		need_feats = 3690,
		limit_lv = 30,
		next_id = 306419
	};

get(520) ->
	#medal_conf{
		key = 520,
		goods_id = 306419,
		career = 3000,
		need_feats = 3850,
		limit_lv = 30,
		next_id = 306420
	};

get(521) ->
	#medal_conf{
		key = 521,
		goods_id = 306420,
		career = 3000,
		need_feats = 4010,
		limit_lv = 35,
		next_id = 306421
	};

get(522) ->
	#medal_conf{
		key = 522,
		goods_id = 306421,
		career = 3000,
		need_feats = 4170,
		limit_lv = 35,
		next_id = 306422
	};

get(523) ->
	#medal_conf{
		key = 523,
		goods_id = 306422,
		career = 3000,
		need_feats = 4330,
		limit_lv = 35,
		next_id = 306423
	};

get(524) ->
	#medal_conf{
		key = 524,
		goods_id = 306423,
		career = 3000,
		need_feats = 4490,
		limit_lv = 35,
		next_id = 306424
	};

get(525) ->
	#medal_conf{
		key = 525,
		goods_id = 306424,
		career = 3000,
		need_feats = 4650,
		limit_lv = 35,
		next_id = 306425
	};

get(526) ->
	#medal_conf{
		key = 526,
		goods_id = 306425,
		career = 3000,
		need_feats = 4810,
		limit_lv = 35,
		next_id = 306426
	};

get(527) ->
	#medal_conf{
		key = 527,
		goods_id = 306426,
		career = 3000,
		need_feats = 4970,
		limit_lv = 35,
		next_id = 306427
	};

get(528) ->
	#medal_conf{
		key = 528,
		goods_id = 306427,
		career = 3000,
		need_feats = 5130,
		limit_lv = 35,
		next_id = 306428
	};

get(529) ->
	#medal_conf{
		key = 529,
		goods_id = 306428,
		career = 3000,
		need_feats = 5290,
		limit_lv = 35,
		next_id = 306429
	};

get(530) ->
	#medal_conf{
		key = 530,
		goods_id = 306429,
		career = 3000,
		need_feats = 5450,
		limit_lv = 35,
		next_id = 306430
	};

get(531) ->
	#medal_conf{
		key = 531,
		goods_id = 306430,
		career = 3000,
		need_feats = 5610,
		limit_lv = 40,
		next_id = 306431
	};

get(532) ->
	#medal_conf{
		key = 532,
		goods_id = 306431,
		career = 3000,
		need_feats = 5770,
		limit_lv = 40,
		next_id = 306432
	};

get(533) ->
	#medal_conf{
		key = 533,
		goods_id = 306432,
		career = 3000,
		need_feats = 5930,
		limit_lv = 40,
		next_id = 306433
	};

get(534) ->
	#medal_conf{
		key = 534,
		goods_id = 306433,
		career = 3000,
		need_feats = 6090,
		limit_lv = 40,
		next_id = 306434
	};

get(535) ->
	#medal_conf{
		key = 535,
		goods_id = 306434,
		career = 3000,
		need_feats = 6250,
		limit_lv = 40,
		next_id = 306435
	};

get(536) ->
	#medal_conf{
		key = 536,
		goods_id = 306435,
		career = 3000,
		need_feats = 6410,
		limit_lv = 40,
		next_id = 306436
	};

get(537) ->
	#medal_conf{
		key = 537,
		goods_id = 306436,
		career = 3000,
		need_feats = 6580,
		limit_lv = 40,
		next_id = 306437
	};

get(538) ->
	#medal_conf{
		key = 538,
		goods_id = 306437,
		career = 3000,
		need_feats = 6740,
		limit_lv = 40,
		next_id = 306438
	};

get(539) ->
	#medal_conf{
		key = 539,
		goods_id = 306438,
		career = 3000,
		need_feats = 6900,
		limit_lv = 40,
		next_id = 306439
	};

get(540) ->
	#medal_conf{
		key = 540,
		goods_id = 306439,
		career = 3000,
		need_feats = 7060,
		limit_lv = 40,
		next_id = 306440
	};

get(541) ->
	#medal_conf{
		key = 541,
		goods_id = 306440,
		career = 3000,
		need_feats = 7220,
		limit_lv = 45,
		next_id = 306441
	};

get(542) ->
	#medal_conf{
		key = 542,
		goods_id = 306441,
		career = 3000,
		need_feats = 7380,
		limit_lv = 45,
		next_id = 306442
	};

get(543) ->
	#medal_conf{
		key = 543,
		goods_id = 306442,
		career = 3000,
		need_feats = 7540,
		limit_lv = 45,
		next_id = 306443
	};

get(544) ->
	#medal_conf{
		key = 544,
		goods_id = 306443,
		career = 3000,
		need_feats = 7700,
		limit_lv = 45,
		next_id = 306444
	};

get(545) ->
	#medal_conf{
		key = 545,
		goods_id = 306444,
		career = 3000,
		need_feats = 7860,
		limit_lv = 45,
		next_id = 306445
	};

get(546) ->
	#medal_conf{
		key = 546,
		goods_id = 306445,
		career = 3000,
		need_feats = 8020,
		limit_lv = 45,
		next_id = 306446
	};

get(547) ->
	#medal_conf{
		key = 547,
		goods_id = 306446,
		career = 3000,
		need_feats = 8180,
		limit_lv = 45,
		next_id = 306447
	};

get(548) ->
	#medal_conf{
		key = 548,
		goods_id = 306447,
		career = 3000,
		need_feats = 8340,
		limit_lv = 45,
		next_id = 306448
	};

get(549) ->
	#medal_conf{
		key = 549,
		goods_id = 306448,
		career = 3000,
		need_feats = 8500,
		limit_lv = 45,
		next_id = 306449
	};

get(550) ->
	#medal_conf{
		key = 550,
		goods_id = 306449,
		career = 3000,
		need_feats = 8660,
		limit_lv = 45,
		next_id = 306450
	};

get(551) ->
	#medal_conf{
		key = 551,
		goods_id = 306450,
		career = 3000,
		need_feats = 8820,
		limit_lv = 50,
		next_id = 306451
	};

get(552) ->
	#medal_conf{
		key = 552,
		goods_id = 306451,
		career = 3000,
		need_feats = 8980,
		limit_lv = 50,
		next_id = 306452
	};

get(553) ->
	#medal_conf{
		key = 553,
		goods_id = 306452,
		career = 3000,
		need_feats = 9140,
		limit_lv = 50,
		next_id = 306453
	};

get(554) ->
	#medal_conf{
		key = 554,
		goods_id = 306453,
		career = 3000,
		need_feats = 9300,
		limit_lv = 50,
		next_id = 306454
	};

get(555) ->
	#medal_conf{
		key = 555,
		goods_id = 306454,
		career = 3000,
		need_feats = 9460,
		limit_lv = 50,
		next_id = 306455
	};

get(556) ->
	#medal_conf{
		key = 556,
		goods_id = 306455,
		career = 3000,
		need_feats = 9620,
		limit_lv = 50,
		next_id = 306456
	};

get(557) ->
	#medal_conf{
		key = 557,
		goods_id = 306456,
		career = 3000,
		need_feats = 9790,
		limit_lv = 50,
		next_id = 306457
	};

get(558) ->
	#medal_conf{
		key = 558,
		goods_id = 306457,
		career = 3000,
		need_feats = 9950,
		limit_lv = 50,
		next_id = 306458
	};

get(559) ->
	#medal_conf{
		key = 559,
		goods_id = 306458,
		career = 3000,
		need_feats = 10110,
		limit_lv = 50,
		next_id = 306459
	};

get(560) ->
	#medal_conf{
		key = 560,
		goods_id = 306459,
		career = 3000,
		need_feats = 10270,
		limit_lv = 50,
		next_id = 306460
	};

get(561) ->
	#medal_conf{
		key = 561,
		goods_id = 306460,
		career = 3000,
		need_feats = 10430,
		limit_lv = 50,
		next_id = 306461
	};

get(562) ->
	#medal_conf{
		key = 562,
		goods_id = 306461,
		career = 3000,
		need_feats = 10590,
		limit_lv = 50,
		next_id = 306462
	};

get(563) ->
	#medal_conf{
		key = 563,
		goods_id = 306462,
		career = 3000,
		need_feats = 10750,
		limit_lv = 50,
		next_id = 306463
	};

get(564) ->
	#medal_conf{
		key = 564,
		goods_id = 306463,
		career = 3000,
		need_feats = 10910,
		limit_lv = 50,
		next_id = 306464
	};

get(565) ->
	#medal_conf{
		key = 565,
		goods_id = 306464,
		career = 3000,
		need_feats = 11070,
		limit_lv = 50,
		next_id = 306465
	};

get(566) ->
	#medal_conf{
		key = 566,
		goods_id = 306465,
		career = 3000,
		need_feats = 11230,
		limit_lv = 50,
		next_id = 306466
	};

get(567) ->
	#medal_conf{
		key = 567,
		goods_id = 306466,
		career = 3000,
		need_feats = 11390,
		limit_lv = 50,
		next_id = 306467
	};

get(568) ->
	#medal_conf{
		key = 568,
		goods_id = 306467,
		career = 3000,
		need_feats = 11550,
		limit_lv = 50,
		next_id = 306468
	};

get(569) ->
	#medal_conf{
		key = 569,
		goods_id = 306468,
		career = 3000,
		need_feats = 11710,
		limit_lv = 50,
		next_id = 306469
	};

get(570) ->
	#medal_conf{
		key = 570,
		goods_id = 306469,
		career = 3000,
		need_feats = 11870,
		limit_lv = 50,
		next_id = 306470
	};

get(571) ->
	#medal_conf{
		key = 571,
		goods_id = 306470,
		career = 3000,
		need_feats = 12030,
		limit_lv = 50,
		next_id = 306471
	};

get(572) ->
	#medal_conf{
		key = 572,
		goods_id = 306471,
		career = 3000,
		need_feats = 12190,
		limit_lv = 50,
		next_id = 306472
	};

get(573) ->
	#medal_conf{
		key = 573,
		goods_id = 306472,
		career = 3000,
		need_feats = 12350,
		limit_lv = 50,
		next_id = 306473
	};

get(574) ->
	#medal_conf{
		key = 574,
		goods_id = 306473,
		career = 3000,
		need_feats = 12510,
		limit_lv = 50,
		next_id = 306474
	};

get(575) ->
	#medal_conf{
		key = 575,
		goods_id = 306474,
		career = 3000,
		need_feats = 12670,
		limit_lv = 50,
		next_id = 306475
	};

get(576) ->
	#medal_conf{
		key = 576,
		goods_id = 306475,
		career = 3000,
		need_feats = 12830,
		limit_lv = 50,
		next_id = 306476
	};

get(577) ->
	#medal_conf{
		key = 577,
		goods_id = 306476,
		career = 3000,
		need_feats = 13000,
		limit_lv = 50,
		next_id = 306477
	};

get(578) ->
	#medal_conf{
		key = 578,
		goods_id = 306477,
		career = 3000,
		need_feats = 13160,
		limit_lv = 50,
		next_id = 306478
	};

get(579) ->
	#medal_conf{
		key = 579,
		goods_id = 306478,
		career = 3000,
		need_feats = 13320,
		limit_lv = 50,
		next_id = 306479
	};

get(580) ->
	#medal_conf{
		key = 580,
		goods_id = 306479,
		career = 3000,
		need_feats = 13480,
		limit_lv = 50,
		next_id = 306480
	};

get(581) ->
	#medal_conf{
		key = 581,
		goods_id = 306480,
		career = 3000,
		need_feats = 13640,
		limit_lv = 50,
		next_id = 306481
	};

get(582) ->
	#medal_conf{
		key = 582,
		goods_id = 306481,
		career = 3000,
		need_feats = 14444,
		limit_lv = 50,
		next_id = 306482
	};

get(583) ->
	#medal_conf{
		key = 583,
		goods_id = 306482,
		career = 3000,
		need_feats = 15246,
		limit_lv = 50,
		next_id = 306483
	};

get(584) ->
	#medal_conf{
		key = 584,
		goods_id = 306483,
		career = 3000,
		need_feats = 16049,
		limit_lv = 50,
		next_id = 306484
	};

get(585) ->
	#medal_conf{
		key = 585,
		goods_id = 306484,
		career = 3000,
		need_feats = 16851,
		limit_lv = 50,
		next_id = 306485
	};

get(586) ->
	#medal_conf{
		key = 586,
		goods_id = 306485,
		career = 3000,
		need_feats = 17654,
		limit_lv = 50,
		next_id = 306486
	};

get(587) ->
	#medal_conf{
		key = 587,
		goods_id = 306486,
		career = 3000,
		need_feats = 18456,
		limit_lv = 50,
		next_id = 306487
	};

get(588) ->
	#medal_conf{
		key = 588,
		goods_id = 306487,
		career = 3000,
		need_feats = 19259,
		limit_lv = 50,
		next_id = 306488
	};

get(589) ->
	#medal_conf{
		key = 589,
		goods_id = 306488,
		career = 3000,
		need_feats = 20061,
		limit_lv = 50,
		next_id = 306489
	};

get(590) ->
	#medal_conf{
		key = 590,
		goods_id = 306489,
		career = 3000,
		need_feats = 20864,
		limit_lv = 50,
		next_id = 306490
	};

get(591) ->
	#medal_conf{
		key = 591,
		goods_id = 306490,
		career = 3000,
		need_feats = 21666,
		limit_lv = 50,
		next_id = 306491
	};

get(592) ->
	#medal_conf{
		key = 592,
		goods_id = 306491,
		career = 3000,
		need_feats = 22469,
		limit_lv = 50,
		next_id = 306492
	};

get(593) ->
	#medal_conf{
		key = 593,
		goods_id = 306492,
		career = 3000,
		need_feats = 23271,
		limit_lv = 50,
		next_id = 306493
	};

get(594) ->
	#medal_conf{
		key = 594,
		goods_id = 306493,
		career = 3000,
		need_feats = 24074,
		limit_lv = 50,
		next_id = 306494
	};

get(595) ->
	#medal_conf{
		key = 595,
		goods_id = 306494,
		career = 3000,
		need_feats = 24876,
		limit_lv = 50,
		next_id = 306495
	};

get(596) ->
	#medal_conf{
		key = 596,
		goods_id = 306495,
		career = 3000,
		need_feats = 25679,
		limit_lv = 50,
		next_id = 306496
	};

get(597) ->
	#medal_conf{
		key = 597,
		goods_id = 306496,
		career = 3000,
		need_feats = 26481,
		limit_lv = 50,
		next_id = 306497
	};

get(598) ->
	#medal_conf{
		key = 598,
		goods_id = 306497,
		career = 3000,
		need_feats = 27283,
		limit_lv = 50,
		next_id = 306498
	};

get(599) ->
	#medal_conf{
		key = 599,
		goods_id = 306498,
		career = 3000,
		need_feats = 28086,
		limit_lv = 50,
		next_id = 306499
	};

get(200) ->
	#medal_conf{
		key = 200,
		goods_id = 306099,
		career = 1000,
		need_feats = 29286,
		limit_lv = 60,
		next_id = 306100
	};

get(201) ->
	#medal_conf{
		key = 201,
		goods_id = 306100,
		career = 1000,
		need_feats = 30486,
		limit_lv = 60,
		next_id = 306101
	};

get(202) ->
	#medal_conf{
		key = 202,
		goods_id = 306101,
		career = 1000,
		need_feats = 31686,
		limit_lv = 60,
		next_id = 306102
	};

get(203) ->
	#medal_conf{
		key = 203,
		goods_id = 306102,
		career = 1000,
		need_feats = 32886,
		limit_lv = 60,
		next_id = 306103
	};

get(204) ->
	#medal_conf{
		key = 204,
		goods_id = 306103,
		career = 1000,
		need_feats = 34086,
		limit_lv = 60,
		next_id = 306104
	};

get(205) ->
	#medal_conf{
		key = 205,
		goods_id = 306104,
		career = 1000,
		need_feats = 35286,
		limit_lv = 60,
		next_id = 306105
	};

get(206) ->
	#medal_conf{
		key = 206,
		goods_id = 306105,
		career = 1000,
		need_feats = 36486,
		limit_lv = 60,
		next_id = 306106
	};

get(207) ->
	#medal_conf{
		key = 207,
		goods_id = 306106,
		career = 1000,
		need_feats = 37686,
		limit_lv = 60,
		next_id = 306107
	};

get(208) ->
	#medal_conf{
		key = 208,
		goods_id = 306107,
		career = 1000,
		need_feats = 38886,
		limit_lv = 60,
		next_id = 306108
	};

get(209) ->
	#medal_conf{
		key = 209,
		goods_id = 306108,
		career = 1000,
		need_feats = 40086,
		limit_lv = 60,
		next_id = 306109
	};

get(210) ->
	#medal_conf{
		key = 210,
		goods_id = 306109,
		career = 1000,
		need_feats = 41286,
		limit_lv = 70,
		next_id = 306110
	};

get(211) ->
	#medal_conf{
		key = 211,
		goods_id = 306110,
		career = 1000,
		need_feats = 42486,
		limit_lv = 70,
		next_id = 306111
	};

get(212) ->
	#medal_conf{
		key = 212,
		goods_id = 306111,
		career = 1000,
		need_feats = 43686,
		limit_lv = 70,
		next_id = 306112
	};

get(213) ->
	#medal_conf{
		key = 213,
		goods_id = 306112,
		career = 1000,
		need_feats = 44886,
		limit_lv = 70,
		next_id = 306113
	};

get(214) ->
	#medal_conf{
		key = 214,
		goods_id = 306113,
		career = 1000,
		need_feats = 46086,
		limit_lv = 70,
		next_id = 306114
	};

get(215) ->
	#medal_conf{
		key = 215,
		goods_id = 306114,
		career = 1000,
		need_feats = 47286,
		limit_lv = 70,
		next_id = 306115
	};

get(216) ->
	#medal_conf{
		key = 216,
		goods_id = 306115,
		career = 1000,
		need_feats = 48486,
		limit_lv = 70,
		next_id = 306116
	};

get(217) ->
	#medal_conf{
		key = 217,
		goods_id = 306116,
		career = 1000,
		need_feats = 49686,
		limit_lv = 70,
		next_id = 306117
	};

get(218) ->
	#medal_conf{
		key = 218,
		goods_id = 306117,
		career = 1000,
		need_feats = 50886,
		limit_lv = 70,
		next_id = 306118
	};

get(219) ->
	#medal_conf{
		key = 219,
		goods_id = 306118,
		career = 1000,
		need_feats = 52486,
		limit_lv = 70,
		next_id = 306119
	};

get(220) ->
	#medal_conf{
		key = 220,
		goods_id = 306119,
		career = 1000,
		need_feats = 54086,
		limit_lv = 80,
		next_id = 306120
	};

get(221) ->
	#medal_conf{
		key = 221,
		goods_id = 306120,
		career = 1000,
		need_feats = 55686,
		limit_lv = 80,
		next_id = 306121
	};

get(222) ->
	#medal_conf{
		key = 222,
		goods_id = 306121,
		career = 1000,
		need_feats = 57286,
		limit_lv = 80,
		next_id = 306122
	};

get(223) ->
	#medal_conf{
		key = 223,
		goods_id = 306122,
		career = 1000,
		need_feats = 58886,
		limit_lv = 80,
		next_id = 306123
	};

get(224) ->
	#medal_conf{
		key = 224,
		goods_id = 306123,
		career = 1000,
		need_feats = 60486,
		limit_lv = 80,
		next_id = 306124
	};

get(225) ->
	#medal_conf{
		key = 225,
		goods_id = 306124,
		career = 1000,
		need_feats = 62086,
		limit_lv = 80,
		next_id = 306125
	};

get(226) ->
	#medal_conf{
		key = 226,
		goods_id = 306125,
		career = 1000,
		need_feats = 63686,
		limit_lv = 80,
		next_id = 306126
	};

get(227) ->
	#medal_conf{
		key = 227,
		goods_id = 306126,
		career = 1000,
		need_feats = 65286,
		limit_lv = 80,
		next_id = 306127
	};

get(228) ->
	#medal_conf{
		key = 228,
		goods_id = 306127,
		career = 1000,
		need_feats = 66886,
		limit_lv = 80,
		next_id = 306128
	};

get(229) ->
	#medal_conf{
		key = 229,
		goods_id = 306128,
		career = 1000,
		need_feats = 68486,
		limit_lv = 80,
		next_id = 306129
	};

get(230) ->
	#medal_conf{
		key = 230,
		goods_id = 306129,
		career = 1000,
		need_feats = 70086,
		limit_lv = 90,
		next_id = 306130
	};

get(231) ->
	#medal_conf{
		key = 231,
		goods_id = 306130,
		career = 1000,
		need_feats = 71686,
		limit_lv = 90,
		next_id = 306131
	};

get(232) ->
	#medal_conf{
		key = 232,
		goods_id = 306131,
		career = 1000,
		need_feats = 73286,
		limit_lv = 90,
		next_id = 306132
	};

get(233) ->
	#medal_conf{
		key = 233,
		goods_id = 306132,
		career = 1000,
		need_feats = 74886,
		limit_lv = 90,
		next_id = 306133
	};

get(234) ->
	#medal_conf{
		key = 234,
		goods_id = 306133,
		career = 1000,
		need_feats = 76486,
		limit_lv = 90,
		next_id = 306134
	};

get(235) ->
	#medal_conf{
		key = 235,
		goods_id = 306134,
		career = 1000,
		need_feats = 78086,
		limit_lv = 90,
		next_id = 306135
	};

get(236) ->
	#medal_conf{
		key = 236,
		goods_id = 306135,
		career = 1000,
		need_feats = 79686,
		limit_lv = 90,
		next_id = 306136
	};

get(237) ->
	#medal_conf{
		key = 237,
		goods_id = 306136,
		career = 1000,
		need_feats = 81286,
		limit_lv = 90,
		next_id = 306137
	};

get(238) ->
	#medal_conf{
		key = 238,
		goods_id = 306137,
		career = 1000,
		need_feats = 82886,
		limit_lv = 90,
		next_id = 306138
	};

get(239) ->
	#medal_conf{
		key = 239,
		goods_id = 306138,
		career = 1000,
		need_feats = 84486,
		limit_lv = 90,
		next_id = 306139
	};

get(240) ->
	#medal_conf{
		key = 240,
		goods_id = 306139,
		career = 1000,
		need_feats = 86086,
		limit_lv = 90,
		next_id = 306140
	};

get(241) ->
	#medal_conf{
		key = 241,
		goods_id = 306140,
		career = 1000,
		need_feats = 87686,
		limit_lv = 90,
		next_id = 306141
	};

get(242) ->
	#medal_conf{
		key = 242,
		goods_id = 306141,
		career = 1000,
		need_feats = 89286,
		limit_lv = 90,
		next_id = 306142
	};

get(243) ->
	#medal_conf{
		key = 243,
		goods_id = 306142,
		career = 1000,
		need_feats = 90886,
		limit_lv = 90,
		next_id = 306143
	};

get(244) ->
	#medal_conf{
		key = 244,
		goods_id = 306143,
		career = 1000,
		need_feats = 92486,
		limit_lv = 90,
		next_id = 0
	};

get(400) ->
	#medal_conf{
		key = 400,
		goods_id = 306299,
		career = 2000,
		need_feats = 29286,
		limit_lv = 60,
		next_id = 306300
	};

get(401) ->
	#medal_conf{
		key = 401,
		goods_id = 306300,
		career = 2000,
		need_feats = 30486,
		limit_lv = 60,
		next_id = 306301
	};

get(402) ->
	#medal_conf{
		key = 402,
		goods_id = 306301,
		career = 2000,
		need_feats = 31686,
		limit_lv = 60,
		next_id = 306302
	};

get(403) ->
	#medal_conf{
		key = 403,
		goods_id = 306302,
		career = 2000,
		need_feats = 32886,
		limit_lv = 60,
		next_id = 306303
	};

get(404) ->
	#medal_conf{
		key = 404,
		goods_id = 306303,
		career = 2000,
		need_feats = 34086,
		limit_lv = 60,
		next_id = 306304
	};

get(405) ->
	#medal_conf{
		key = 405,
		goods_id = 306304,
		career = 2000,
		need_feats = 35286,
		limit_lv = 60,
		next_id = 306305
	};

get(406) ->
	#medal_conf{
		key = 406,
		goods_id = 306305,
		career = 2000,
		need_feats = 36486,
		limit_lv = 60,
		next_id = 306306
	};

get(407) ->
	#medal_conf{
		key = 407,
		goods_id = 306306,
		career = 2000,
		need_feats = 37686,
		limit_lv = 60,
		next_id = 306307
	};

get(408) ->
	#medal_conf{
		key = 408,
		goods_id = 306307,
		career = 2000,
		need_feats = 38886,
		limit_lv = 60,
		next_id = 306308
	};

get(409) ->
	#medal_conf{
		key = 409,
		goods_id = 306308,
		career = 2000,
		need_feats = 40086,
		limit_lv = 60,
		next_id = 306309
	};

get(410) ->
	#medal_conf{
		key = 410,
		goods_id = 306309,
		career = 2000,
		need_feats = 41286,
		limit_lv = 70,
		next_id = 306310
	};

get(411) ->
	#medal_conf{
		key = 411,
		goods_id = 306310,
		career = 2000,
		need_feats = 42486,
		limit_lv = 70,
		next_id = 306311
	};

get(412) ->
	#medal_conf{
		key = 412,
		goods_id = 306311,
		career = 2000,
		need_feats = 43686,
		limit_lv = 70,
		next_id = 306312
	};

get(413) ->
	#medal_conf{
		key = 413,
		goods_id = 306312,
		career = 2000,
		need_feats = 44886,
		limit_lv = 70,
		next_id = 306313
	};

get(414) ->
	#medal_conf{
		key = 414,
		goods_id = 306313,
		career = 2000,
		need_feats = 46086,
		limit_lv = 70,
		next_id = 306314
	};

get(415) ->
	#medal_conf{
		key = 415,
		goods_id = 306314,
		career = 2000,
		need_feats = 47286,
		limit_lv = 70,
		next_id = 306315
	};

get(416) ->
	#medal_conf{
		key = 416,
		goods_id = 306315,
		career = 2000,
		need_feats = 48486,
		limit_lv = 70,
		next_id = 306316
	};

get(417) ->
	#medal_conf{
		key = 417,
		goods_id = 306316,
		career = 2000,
		need_feats = 49686,
		limit_lv = 70,
		next_id = 306317
	};

get(418) ->
	#medal_conf{
		key = 418,
		goods_id = 306317,
		career = 2000,
		need_feats = 50886,
		limit_lv = 70,
		next_id = 306318
	};

get(419) ->
	#medal_conf{
		key = 419,
		goods_id = 306318,
		career = 2000,
		need_feats = 52486,
		limit_lv = 70,
		next_id = 306319
	};

get(420) ->
	#medal_conf{
		key = 420,
		goods_id = 306319,
		career = 2000,
		need_feats = 54086,
		limit_lv = 80,
		next_id = 306320
	};

get(421) ->
	#medal_conf{
		key = 421,
		goods_id = 306320,
		career = 2000,
		need_feats = 55686,
		limit_lv = 80,
		next_id = 306321
	};

get(422) ->
	#medal_conf{
		key = 422,
		goods_id = 306321,
		career = 2000,
		need_feats = 57286,
		limit_lv = 80,
		next_id = 306322
	};

get(423) ->
	#medal_conf{
		key = 423,
		goods_id = 306322,
		career = 2000,
		need_feats = 58886,
		limit_lv = 80,
		next_id = 306323
	};

get(424) ->
	#medal_conf{
		key = 424,
		goods_id = 306323,
		career = 2000,
		need_feats = 60486,
		limit_lv = 80,
		next_id = 306324
	};

get(425) ->
	#medal_conf{
		key = 425,
		goods_id = 306324,
		career = 2000,
		need_feats = 62086,
		limit_lv = 80,
		next_id = 306325
	};

get(426) ->
	#medal_conf{
		key = 426,
		goods_id = 306325,
		career = 2000,
		need_feats = 63686,
		limit_lv = 80,
		next_id = 306326
	};

get(427) ->
	#medal_conf{
		key = 427,
		goods_id = 306326,
		career = 2000,
		need_feats = 65286,
		limit_lv = 80,
		next_id = 306327
	};

get(428) ->
	#medal_conf{
		key = 428,
		goods_id = 306327,
		career = 2000,
		need_feats = 66886,
		limit_lv = 80,
		next_id = 306328
	};

get(429) ->
	#medal_conf{
		key = 429,
		goods_id = 306328,
		career = 2000,
		need_feats = 68486,
		limit_lv = 80,
		next_id = 306329
	};

get(430) ->
	#medal_conf{
		key = 430,
		goods_id = 306329,
		career = 2000,
		need_feats = 70086,
		limit_lv = 90,
		next_id = 306330
	};

get(431) ->
	#medal_conf{
		key = 431,
		goods_id = 306330,
		career = 2000,
		need_feats = 71686,
		limit_lv = 90,
		next_id = 306331
	};

get(432) ->
	#medal_conf{
		key = 432,
		goods_id = 306331,
		career = 2000,
		need_feats = 73286,
		limit_lv = 90,
		next_id = 306332
	};

get(433) ->
	#medal_conf{
		key = 433,
		goods_id = 306332,
		career = 2000,
		need_feats = 74886,
		limit_lv = 90,
		next_id = 306333
	};

get(434) ->
	#medal_conf{
		key = 434,
		goods_id = 306333,
		career = 2000,
		need_feats = 76486,
		limit_lv = 90,
		next_id = 306334
	};

get(435) ->
	#medal_conf{
		key = 435,
		goods_id = 306334,
		career = 2000,
		need_feats = 78086,
		limit_lv = 90,
		next_id = 306335
	};

get(436) ->
	#medal_conf{
		key = 436,
		goods_id = 306335,
		career = 2000,
		need_feats = 79686,
		limit_lv = 90,
		next_id = 306336
	};

get(437) ->
	#medal_conf{
		key = 437,
		goods_id = 306336,
		career = 2000,
		need_feats = 81286,
		limit_lv = 90,
		next_id = 306337
	};

get(438) ->
	#medal_conf{
		key = 438,
		goods_id = 306337,
		career = 2000,
		need_feats = 82886,
		limit_lv = 90,
		next_id = 306338
	};

get(439) ->
	#medal_conf{
		key = 439,
		goods_id = 306338,
		career = 2000,
		need_feats = 84486,
		limit_lv = 90,
		next_id = 306339
	};

get(440) ->
	#medal_conf{
		key = 440,
		goods_id = 306339,
		career = 2000,
		need_feats = 86086,
		limit_lv = 90,
		next_id = 306340
	};

get(441) ->
	#medal_conf{
		key = 441,
		goods_id = 306340,
		career = 2000,
		need_feats = 87686,
		limit_lv = 90,
		next_id = 306341
	};

get(442) ->
	#medal_conf{
		key = 442,
		goods_id = 306341,
		career = 2000,
		need_feats = 89286,
		limit_lv = 90,
		next_id = 306342
	};

get(443) ->
	#medal_conf{
		key = 443,
		goods_id = 306342,
		career = 2000,
		need_feats = 90886,
		limit_lv = 90,
		next_id = 306343
	};

get(444) ->
	#medal_conf{
		key = 444,
		goods_id = 306343,
		career = 2000,
		need_feats = 92486,
		limit_lv = 90,
		next_id = 0
	};

get(600) ->
	#medal_conf{
		key = 600,
		goods_id = 306499,
		career = 3000,
		need_feats = 29286,
		limit_lv = 60,
		next_id = 306500
	};

get(601) ->
	#medal_conf{
		key = 601,
		goods_id = 306500,
		career = 3000,
		need_feats = 30486,
		limit_lv = 60,
		next_id = 306501
	};

get(602) ->
	#medal_conf{
		key = 602,
		goods_id = 306501,
		career = 3000,
		need_feats = 31686,
		limit_lv = 60,
		next_id = 306502
	};

get(603) ->
	#medal_conf{
		key = 603,
		goods_id = 306502,
		career = 3000,
		need_feats = 32886,
		limit_lv = 60,
		next_id = 306503
	};

get(604) ->
	#medal_conf{
		key = 604,
		goods_id = 306503,
		career = 3000,
		need_feats = 34086,
		limit_lv = 60,
		next_id = 306504
	};

get(605) ->
	#medal_conf{
		key = 605,
		goods_id = 306504,
		career = 3000,
		need_feats = 35286,
		limit_lv = 60,
		next_id = 306505
	};

get(606) ->
	#medal_conf{
		key = 606,
		goods_id = 306505,
		career = 3000,
		need_feats = 36486,
		limit_lv = 60,
		next_id = 306506
	};

get(607) ->
	#medal_conf{
		key = 607,
		goods_id = 306506,
		career = 3000,
		need_feats = 37686,
		limit_lv = 60,
		next_id = 306507
	};

get(608) ->
	#medal_conf{
		key = 608,
		goods_id = 306507,
		career = 3000,
		need_feats = 38886,
		limit_lv = 60,
		next_id = 306508
	};

get(609) ->
	#medal_conf{
		key = 609,
		goods_id = 306508,
		career = 3000,
		need_feats = 40086,
		limit_lv = 60,
		next_id = 306509
	};

get(610) ->
	#medal_conf{
		key = 610,
		goods_id = 306509,
		career = 3000,
		need_feats = 41286,
		limit_lv = 70,
		next_id = 306510
	};

get(611) ->
	#medal_conf{
		key = 611,
		goods_id = 306510,
		career = 3000,
		need_feats = 42486,
		limit_lv = 70,
		next_id = 306511
	};

get(612) ->
	#medal_conf{
		key = 612,
		goods_id = 306511,
		career = 3000,
		need_feats = 43686,
		limit_lv = 70,
		next_id = 306512
	};

get(613) ->
	#medal_conf{
		key = 613,
		goods_id = 306512,
		career = 3000,
		need_feats = 44886,
		limit_lv = 70,
		next_id = 306513
	};

get(614) ->
	#medal_conf{
		key = 614,
		goods_id = 306513,
		career = 3000,
		need_feats = 46086,
		limit_lv = 70,
		next_id = 306514
	};

get(615) ->
	#medal_conf{
		key = 615,
		goods_id = 306514,
		career = 3000,
		need_feats = 47286,
		limit_lv = 70,
		next_id = 306515
	};

get(616) ->
	#medal_conf{
		key = 616,
		goods_id = 306515,
		career = 3000,
		need_feats = 48486,
		limit_lv = 70,
		next_id = 306516
	};

get(617) ->
	#medal_conf{
		key = 617,
		goods_id = 306516,
		career = 3000,
		need_feats = 49686,
		limit_lv = 70,
		next_id = 306517
	};

get(618) ->
	#medal_conf{
		key = 618,
		goods_id = 306517,
		career = 3000,
		need_feats = 50886,
		limit_lv = 70,
		next_id = 306518
	};

get(619) ->
	#medal_conf{
		key = 619,
		goods_id = 306518,
		career = 3000,
		need_feats = 52486,
		limit_lv = 70,
		next_id = 306519
	};

get(620) ->
	#medal_conf{
		key = 620,
		goods_id = 306519,
		career = 3000,
		need_feats = 54086,
		limit_lv = 80,
		next_id = 306520
	};

get(621) ->
	#medal_conf{
		key = 621,
		goods_id = 306520,
		career = 3000,
		need_feats = 55686,
		limit_lv = 80,
		next_id = 306521
	};

get(622) ->
	#medal_conf{
		key = 622,
		goods_id = 306521,
		career = 3000,
		need_feats = 57286,
		limit_lv = 80,
		next_id = 306522
	};

get(623) ->
	#medal_conf{
		key = 623,
		goods_id = 306522,
		career = 3000,
		need_feats = 58886,
		limit_lv = 80,
		next_id = 306523
	};

get(624) ->
	#medal_conf{
		key = 624,
		goods_id = 306523,
		career = 3000,
		need_feats = 60486,
		limit_lv = 80,
		next_id = 306524
	};

get(625) ->
	#medal_conf{
		key = 625,
		goods_id = 306524,
		career = 3000,
		need_feats = 62086,
		limit_lv = 80,
		next_id = 306525
	};

get(626) ->
	#medal_conf{
		key = 626,
		goods_id = 306525,
		career = 3000,
		need_feats = 63686,
		limit_lv = 80,
		next_id = 306526
	};

get(627) ->
	#medal_conf{
		key = 627,
		goods_id = 306526,
		career = 3000,
		need_feats = 65286,
		limit_lv = 80,
		next_id = 306527
	};

get(628) ->
	#medal_conf{
		key = 628,
		goods_id = 306527,
		career = 3000,
		need_feats = 66886,
		limit_lv = 80,
		next_id = 306528
	};

get(629) ->
	#medal_conf{
		key = 629,
		goods_id = 306528,
		career = 3000,
		need_feats = 68486,
		limit_lv = 80,
		next_id = 306529
	};

get(630) ->
	#medal_conf{
		key = 630,
		goods_id = 306529,
		career = 3000,
		need_feats = 70086,
		limit_lv = 90,
		next_id = 306530
	};

get(631) ->
	#medal_conf{
		key = 631,
		goods_id = 306530,
		career = 3000,
		need_feats = 71686,
		limit_lv = 90,
		next_id = 306531
	};

get(632) ->
	#medal_conf{
		key = 632,
		goods_id = 306531,
		career = 3000,
		need_feats = 73286,
		limit_lv = 90,
		next_id = 306532
	};

get(633) ->
	#medal_conf{
		key = 633,
		goods_id = 306532,
		career = 3000,
		need_feats = 74886,
		limit_lv = 90,
		next_id = 306533
	};

get(634) ->
	#medal_conf{
		key = 634,
		goods_id = 306533,
		career = 3000,
		need_feats = 76486,
		limit_lv = 90,
		next_id = 306534
	};

get(635) ->
	#medal_conf{
		key = 635,
		goods_id = 306534,
		career = 3000,
		need_feats = 78086,
		limit_lv = 90,
		next_id = 306535
	};

get(636) ->
	#medal_conf{
		key = 636,
		goods_id = 306535,
		career = 3000,
		need_feats = 79686,
		limit_lv = 90,
		next_id = 306536
	};

get(637) ->
	#medal_conf{
		key = 637,
		goods_id = 306536,
		career = 3000,
		need_feats = 81286,
		limit_lv = 90,
		next_id = 306537
	};

get(638) ->
	#medal_conf{
		key = 638,
		goods_id = 306537,
		career = 3000,
		need_feats = 82886,
		limit_lv = 90,
		next_id = 306538
	};

get(639) ->
	#medal_conf{
		key = 639,
		goods_id = 306538,
		career = 3000,
		need_feats = 84486,
		limit_lv = 90,
		next_id = 306539
	};

get(640) ->
	#medal_conf{
		key = 640,
		goods_id = 306539,
		career = 3000,
		need_feats = 86086,
		limit_lv = 90,
		next_id = 306540
	};

get(641) ->
	#medal_conf{
		key = 641,
		goods_id = 306540,
		career = 3000,
		need_feats = 87686,
		limit_lv = 90,
		next_id = 306541
	};

get(642) ->
	#medal_conf{
		key = 642,
		goods_id = 306541,
		career = 3000,
		need_feats = 89286,
		limit_lv = 90,
		next_id = 306542
	};

get(643) ->
	#medal_conf{
		key = 643,
		goods_id = 306542,
		career = 3000,
		need_feats = 90886,
		limit_lv = 90,
		next_id = 306543
	};

get(644) ->
	#medal_conf{
		key = 644,
		goods_id = 306543,
		career = 3000,
		need_feats = 92486,
		limit_lv = 90,
		next_id = 0
	};

get(_Key) ->
	?ERR("undefined key from medal_config ~p", [_Key]).