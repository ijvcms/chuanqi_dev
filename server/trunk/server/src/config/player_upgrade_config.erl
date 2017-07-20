%%%-------------------------------------------------------------------
%%% @author zhengsiying
%%% @doc
%%%		自动生成文件，不要手动修改
%%% @end
%%% Created : 2016/10/12
%%%-------------------------------------------------------------------

-module(player_upgrade_config).

-include("common.hrl").
-include("config.hrl").

-compile([export_all]).

get_list_conf() ->
	[ player_upgrade_config:get(X) || X <- get_list() ].

get_list() ->
	[1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32, 33, 34, 35, 36, 37, 38, 39, 40, 41, 42, 43, 44, 45, 46, 47, 48, 49, 50, 51, 52, 53, 54, 55, 56, 57, 58, 59, 60, 61, 62, 63, 64, 65, 66, 67, 68, 69, 70, 71, 72, 73, 74, 75, 76, 77, 78, 79, 80, 81, 82, 83, 84, 85, 86, 87, 88, 89, 90, 91, 92, 93, 94, 95, 96, 97, 98, 99, 100, 101, 102, 103, 104, 105, 106, 107, 108, 109, 110, 111, 112, 113, 114, 115, 116, 117, 118, 119, 120, 121, 122, 123, 124, 125, 126, 127, 128, 129, 130].

get(1) ->
	#player_upgrade_conf{
		lv = 1,
		need_exp = 60
	};

get(2) ->
	#player_upgrade_conf{
		lv = 2,
		need_exp = 70
	};

get(3) ->
	#player_upgrade_conf{
		lv = 3,
		need_exp = 90
	};

get(4) ->
	#player_upgrade_conf{
		lv = 4,
		need_exp = 130
	};

get(5) ->
	#player_upgrade_conf{
		lv = 5,
		need_exp = 210
	};

get(6) ->
	#player_upgrade_conf{
		lv = 6,
		need_exp = 320
	};

get(7) ->
	#player_upgrade_conf{
		lv = 7,
		need_exp = 480
	};

get(8) ->
	#player_upgrade_conf{
		lv = 8,
		need_exp = 680
	};

get(9) ->
	#player_upgrade_conf{
		lv = 9,
		need_exp = 950
	};

get(10) ->
	#player_upgrade_conf{
		lv = 10,
		need_exp = 1280
	};

get(11) ->
	#player_upgrade_conf{
		lv = 11,
		need_exp = 1578
	};

get(12) ->
	#player_upgrade_conf{
		lv = 12,
		need_exp = 2032
	};

get(13) ->
	#player_upgrade_conf{
		lv = 13,
		need_exp = 2568
	};

get(14) ->
	#player_upgrade_conf{
		lv = 14,
		need_exp = 3193
	};

get(15) ->
	#player_upgrade_conf{
		lv = 15,
		need_exp = 3914
	};

get(16) ->
	#player_upgrade_conf{
		lv = 16,
		need_exp = 4738
	};

get(17) ->
	#player_upgrade_conf{
		lv = 17,
		need_exp = 5672
	};

get(18) ->
	#player_upgrade_conf{
		lv = 18,
		need_exp = 6723
	};

get(19) ->
	#player_upgrade_conf{
		lv = 19,
		need_exp = 7896
	};

get(20) ->
	#player_upgrade_conf{
		lv = 20,
		need_exp = 9201
	};

get(21) ->
	#player_upgrade_conf{
		lv = 21,
		need_exp = 10252
	};

get(22) ->
	#player_upgrade_conf{
		lv = 22,
		need_exp = 11779
	};

get(23) ->
	#player_upgrade_conf{
		lv = 23,
		need_exp = 13452
	};

get(24) ->
	#player_upgrade_conf{
		lv = 24,
		need_exp = 15276
	};

get(25) ->
	#player_upgrade_conf{
		lv = 25,
		need_exp = 17259
	};

get(26) ->
	#player_upgrade_conf{
		lv = 26,
		need_exp = 19408
	};

get(27) ->
	#player_upgrade_conf{
		lv = 27,
		need_exp = 21728
	};

get(28) ->
	#player_upgrade_conf{
		lv = 28,
		need_exp = 24226
	};

get(29) ->
	#player_upgrade_conf{
		lv = 29,
		need_exp = 26910
	};

get(30) ->
	#player_upgrade_conf{
		lv = 30,
		need_exp = 29785
	};

get(31) ->
	#player_upgrade_conf{
		lv = 31,
		need_exp = 92589
	};

get(32) ->
	#player_upgrade_conf{
		lv = 32,
		need_exp = 101826
	};

get(33) ->
	#player_upgrade_conf{
		lv = 33,
		need_exp = 111659
	};

get(34) ->
	#player_upgrade_conf{
		lv = 34,
		need_exp = 122106
	};

get(35) ->
	#player_upgrade_conf{
		lv = 35,
		need_exp = 133186
	};

get(36) ->
	#player_upgrade_conf{
		lv = 36,
		need_exp = 144918
	};

get(37) ->
	#player_upgrade_conf{
		lv = 37,
		need_exp = 157320
	};

get(38) ->
	#player_upgrade_conf{
		lv = 38,
		need_exp = 170410
	};

get(39) ->
	#player_upgrade_conf{
		lv = 39,
		need_exp = 184208
	};

get(40) ->
	#player_upgrade_conf{
		lv = 40,
		need_exp = 198732
	};

get(41) ->
	#player_upgrade_conf{
		lv = 41,
		need_exp = 381142
	};

get(42) ->
	#player_upgrade_conf{
		lv = 42,
		need_exp = 409695
	};

get(43) ->
	#player_upgrade_conf{
		lv = 43,
		need_exp = 439641
	};

get(44) ->
	#player_upgrade_conf{
		lv = 44,
		need_exp = 471013
	};

get(45) ->
	#player_upgrade_conf{
		lv = 45,
		need_exp = 503844
	};

get(46) ->
	#player_upgrade_conf{
		lv = 46,
		need_exp = 538166
	};

get(47) ->
	#player_upgrade_conf{
		lv = 47,
		need_exp = 574014
	};

get(48) ->
	#player_upgrade_conf{
		lv = 48,
		need_exp = 611421
	};

get(49) ->
	#player_upgrade_conf{
		lv = 49,
		need_exp = 650418
	};

get(50) ->
	#player_upgrade_conf{
		lv = 50,
		need_exp = 691041
	};

get(51) ->
	#player_upgrade_conf{
		lv = 51,
		need_exp = 1616268
	};

get(52) ->
	#player_upgrade_conf{
		lv = 52,
		need_exp = 1713183
	};

get(53) ->
	#player_upgrade_conf{
		lv = 53,
		need_exp = 1813898
	};

get(54) ->
	#player_upgrade_conf{
		lv = 54,
		need_exp = 1918485
	};

get(55) ->
	#player_upgrade_conf{
		lv = 55,
		need_exp = 2027019
	};

get(56) ->
	#player_upgrade_conf{
		lv = 56,
		need_exp = 2139573
	};

get(57) ->
	#player_upgrade_conf{
		lv = 57,
		need_exp = 2256218
	};

get(58) ->
	#player_upgrade_conf{
		lv = 58,
		need_exp = 2377030
	};

get(59) ->
	#player_upgrade_conf{
		lv = 59,
		need_exp = 2502079
	};

get(60) ->
	#player_upgrade_conf{
		lv = 60,
		need_exp = 2631441
	};

get(61) ->
	#player_upgrade_conf{
		lv = 61,
		need_exp = 7008439
	};

get(62) ->
	#player_upgrade_conf{
		lv = 62,
		need_exp = 7358721
	};

get(63) ->
	#player_upgrade_conf{
		lv = 63,
		need_exp = 7720486
	};

get(64) ->
	#player_upgrade_conf{
		lv = 64,
		need_exp = 8093920
	};

get(65) ->
	#player_upgrade_conf{
		lv = 65,
		need_exp = 8479208
	};

get(66) ->
	#player_upgrade_conf{
		lv = 66,
		need_exp = 8876536
	};

get(67) ->
	#player_upgrade_conf{
		lv = 67,
		need_exp = 9286087
	};

get(68) ->
	#player_upgrade_conf{
		lv = 68,
		need_exp = 9708049
	};

get(69) ->
	#player_upgrade_conf{
		lv = 69,
		need_exp = 10142606
	};

get(70) ->
	#player_upgrade_conf{
		lv = 70,
		need_exp = 10589942
	};

get(71) ->
	#player_upgrade_conf{
		lv = 71,
		need_exp = 17313789
	};

get(72) ->
	#player_upgrade_conf{
		lv = 72,
		need_exp = 18055607
	};

get(73) ->
	#player_upgrade_conf{
		lv = 73,
		need_exp = 18818319
	};

get(74) ->
	#player_upgrade_conf{
		lv = 74,
		need_exp = 19602216
	};

get(75) ->
	#player_upgrade_conf{
		lv = 75,
		need_exp = 20407588
	};

get(76) ->
	#player_upgrade_conf{
		lv = 76,
		need_exp = 21234726
	};

get(77) ->
	#player_upgrade_conf{
		lv = 77,
		need_exp = 22083920
	};

get(78) ->
	#player_upgrade_conf{
		lv = 78,
		need_exp = 22955459
	};

get(79) ->
	#player_upgrade_conf{
		lv = 79,
		need_exp = 23849635
	};

get(80) ->
	#player_upgrade_conf{
		lv = 80,
		need_exp = 24766737
	};

get(81) ->
	#player_upgrade_conf{
		lv = 81,
		need_exp = 41294090
	};

get(82) ->
	#player_upgrade_conf{
		lv = 82,
		need_exp = 42842314
	};

get(83) ->
	#player_upgrade_conf{
		lv = 83,
		need_exp = 44428765
	};

get(84) ->
	#player_upgrade_conf{
		lv = 84,
		need_exp = 46053907
	};

get(85) ->
	#player_upgrade_conf{
		lv = 85,
		need_exp = 47718207
	};

get(86) ->
	#player_upgrade_conf{
		lv = 86,
		need_exp = 49422132
	};

get(87) ->
	#player_upgrade_conf{
		lv = 87,
		need_exp = 51166147
	};

get(88) ->
	#player_upgrade_conf{
		lv = 88,
		need_exp = 52950719
	};

get(89) ->
	#player_upgrade_conf{
		lv = 89,
		need_exp = 54776314
	};

get(90) ->
	#player_upgrade_conf{
		lv = 90,
		need_exp = 56643398
	};

get(91) ->
	#player_upgrade_conf{
		lv = 91,
		need_exp = 60013736
	};

get(92) ->
	#player_upgrade_conf{
		lv = 92,
		need_exp = 62013900
	};

get(93) ->
	#player_upgrade_conf{
		lv = 93,
		need_exp = 64058021
	};

get(94) ->
	#player_upgrade_conf{
		lv = 94,
		need_exp = 66146578
	};

get(95) ->
	#player_upgrade_conf{
		lv = 95,
		need_exp = 68280048
	};

get(96) ->
	#player_upgrade_conf{
		lv = 96,
		need_exp = 70458910
	};

get(97) ->
	#player_upgrade_conf{
		lv = 97,
		need_exp = 72683640
	};

get(98) ->
	#player_upgrade_conf{
		lv = 98,
		need_exp = 74954718
	};

get(99) ->
	#player_upgrade_conf{
		lv = 99,
		need_exp = 77272620
	};

get(100) ->
	#player_upgrade_conf{
		lv = 100,
		need_exp = 79637825
	};

get(101) ->
	#player_upgrade_conf{
		lv = 101,
		need_exp = 227377470
	};

get(102) ->
	#player_upgrade_conf{
		lv = 102,
		need_exp = 234198015
	};

get(103) ->
	#player_upgrade_conf{
		lv = 103,
		need_exp = 241153616
	};

get(104) ->
	#player_upgrade_conf{
		lv = 104,
		need_exp = 248245597
	};

get(105) ->
	#player_upgrade_conf{
		lv = 105,
		need_exp = 255475282
	};

get(106) ->
	#player_upgrade_conf{
		lv = 106,
		need_exp = 262843995
	};

get(107) ->
	#player_upgrade_conf{
		lv = 107,
		need_exp = 270353061
	};

get(108) ->
	#player_upgrade_conf{
		lv = 108,
		need_exp = 278003803
	};

get(109) ->
	#player_upgrade_conf{
		lv = 109,
		need_exp = 285797545
	};

get(110) ->
	#player_upgrade_conf{
		lv = 110,
		need_exp = 293735612
	};

get(111) ->
	#player_upgrade_conf{
		lv = 111,
		need_exp = 368042524
	};

get(112) ->
	#player_upgrade_conf{
		lv = 112,
		need_exp = 378079135
	};

get(113) ->
	#player_upgrade_conf{
		lv = 113,
		need_exp = 388296581
	};

get(114) ->
	#player_upgrade_conf{
		lv = 114,
		need_exp = 398696476
	};

get(115) ->
	#player_upgrade_conf{
		lv = 115,
		need_exp = 409280436
	};

get(116) ->
	#player_upgrade_conf{
		lv = 116,
		need_exp = 420050074
	};

get(117) ->
	#player_upgrade_conf{
		lv = 117,
		need_exp = 431007006
	};

get(118) ->
	#player_upgrade_conf{
		lv = 118,
		need_exp = 442152846
	};

get(119) ->
	#player_upgrade_conf{
		lv = 119,
		need_exp = 453489208
	};

get(120) ->
	#player_upgrade_conf{
		lv = 120,
		need_exp = 465017708
	};

get(121) ->
	#player_upgrade_conf{
		lv = 121,
		need_exp = 558021249
	};

get(122) ->
	#player_upgrade_conf{
		lv = 122,
		need_exp = 613823373
	};

get(123) ->
	#player_upgrade_conf{
		lv = 123,
		need_exp = 675205710
	};

get(124) ->
	#player_upgrade_conf{
		lv = 124,
		need_exp = 742726281
	};

get(125) ->
	#player_upgrade_conf{
		lv = 125,
		need_exp = 1114089421
	};

get(126) ->
	#player_upgrade_conf{
		lv = 126,
		need_exp = 1225498363
	};

get(127) ->
	#player_upgrade_conf{
		lv = 127,
		need_exp = 1348048199
	};

get(128) ->
	#player_upgrade_conf{
		lv = 128,
		need_exp = 1482853018
	};

get(129) ->
	#player_upgrade_conf{
		lv = 129,
		need_exp = 1631138319
	};

get(130) ->
	#player_upgrade_conf{
		lv = 130,
		need_exp = 2000000000
	};

get(_Key) ->
	 null.