%%%-------------------------------------------------------------------
%%% @author zhengsiying
%%% @doc
%%%		自动生成文件，不要手动修改
%%% @end
%%% Created : 2016/10/12
%%%-------------------------------------------------------------------

-module(npc_config).

-include("common.hrl").
-include("config.hrl").

-compile([export_all]).

get_list_conf() ->
	[ npc_config:get(X) || X <- get_list() ].

get_list() ->
	[7504, 7507, 7508, 7509, 7510, 7512, 7513, 7515, 7516, 7517, 7518, 7519, 7520, 7521, 7522, 7523, 7524, 7525, 7526, 7527, 7528, 7530, 7531, 7532, 7533, 7534, 7535, 7536, 7537, 7539, 7540, 7541, 7542, 7543, 7544, 7545, 7546, 7547, 7548, 7549, 7550, 7551, 7552, 7555, 7556, 7557, 7559, 7560, 7561, 7562, 7563, 7564, 7565, 7566, 7567, 7568, 7569, 7570, 7571, 7572, 7573, 7574, 7575, 7576, 7577, 7578, 7579, 7580, 7581, 7582, 7583, 7584, 7585, 7586, 7587, 7588, 7589, 7590, 7600, 7601, 7602, 7603, 7604, 7605, 7606, 7607, 7608, 7609, 7610, 7611, 7612, 7613, 7614, 7615, 7616, 7617, 7618, 7619, 7620, 7621, 7622, 7623, 7624, 7625, 7626, 7627, 7701, 7702, 7703, 7704, 7705, 7706, 7707, 7708, 7709, 7710, 7711, 7741, 7742, 7743, 7744, 7745, 7746, 7747, 7748, 7749, 7750, 7751, 7752, 7753, 7754, 7755, 7756, 7757, 7758, 7759, 7760, 7761, 7762, 7763, 7764, 7765, 7766, 7767, 7779, 7780, 7781, 7782, 7783, 7784, 7785, 7786, 7787, 7788, 7789, 7790, 7791, 7792, 7793, 7794, 7795, 7800, 7900, 7901, 7902, 7903, 7904, 7905, 7906, 7907, 7908, 7909, 7910, 7911, 7912, 7913, 7914, 7915, 7916, 7917, 7918, 7919, 7920, 7921, 7922, 7923, 7924, 7925, 8001, 8002, 8003, 8004, 8005, 8006, 8007, 8008, 8009, 8010, 8011, 8012, 8013, 8014, 8015, 8016, 8017, 8018, 8019, 8020, 8021, 8022, 8023, 8024, 8025, 8026, 8027, 8028, 8029, 8030, 8031, 8032, 8033, 8034, 8040, 8041, 8042, 8050, 8051, 8052, 8060, 8061, 8062, 8063, 8064, 8065, 8066, 8067].

get(7504) ->
	#npc_conf{
		id = 7504,
		name = xmerl_ucs:to_utf8("单人副本"),
		sceneId = 20100,
		x = 76,
		y = 50,
		type = 6
	};

get(7507) ->
	#npc_conf{
		id = 7507,
		name = xmerl_ucs:to_utf8("老兵"),
		sceneId = 20100,
		x = 62,
		y = 50,
		type = 2
	};

get(7508) ->
	#npc_conf{
		id = 7508,
		name = xmerl_ucs:to_utf8("仓库"),
		sceneId = 20100,
		x = 69,
		y = 58,
		type = 2
	};

get(7509) ->
	#npc_conf{
		id = 7509,
		name = xmerl_ucs:to_utf8("服装店"),
		sceneId = 20100,
		x = 79,
		y = 87,
		type = 2
	};

get(7510) ->
	#npc_conf{
		id = 7510,
		name = xmerl_ucs:to_utf8("首饰店"),
		sceneId = 20100,
		x = 60,
		y = 84,
		type = 2
	};

get(7512) ->
	#npc_conf{
		id = 7512,
		name = xmerl_ucs:to_utf8("红娘"),
		sceneId = 20100,
		x = 34,
		y = 62,
		type = 2
	};

get(7513) ->
	#npc_conf{
		id = 7513,
		name = xmerl_ucs:to_utf8("国王"),
		sceneId = 20100,
		x = 7,
		y = 13,
		type = 2
	};

get(7515) ->
	#npc_conf{
		id = 7515,
		name = xmerl_ucs:to_utf8("擂台主"),
		sceneId = 20100,
		x = 109,
		y = 62,
		type = 2
	};

get(7516) ->
	#npc_conf{
		id = 7516,
		name = xmerl_ucs:to_utf8("老谋事"),
		sceneId = 20100,
		x = 80,
		y = 30,
		type = 2
	};

get(7517) ->
	#npc_conf{
		id = 7517,
		name = xmerl_ucs:to_utf8("武器店"),
		sceneId = 20100,
		x = 75,
		y = 90,
		type = 2
	};

get(7518) ->
	#npc_conf{
		id = 7518,
		name = xmerl_ucs:to_utf8("小商贩"),
		sceneId = 20100,
		x = 78,
		y = 58,
		type = 2
	};

get(7519) ->
	#npc_conf{
		id = 7519,
		name = xmerl_ucs:to_utf8("药店"),
		sceneId = 20100,
		x = 65,
		y = 77,
		type = 2
	};

get(7520) ->
	#npc_conf{
		id = 7520,
		name = xmerl_ucs:to_utf8("金币转盘"),
		sceneId = 20102,
		x = 46,
		y = 26,
		type = 6
	};

get(7521) ->
	#npc_conf{
		id = 7521,
		name = xmerl_ucs:to_utf8("行会宣战"),
		sceneId = 20102,
		x = 54,
		y = 30,
		type = 6
	};

get(7522) ->
	#npc_conf{
		id = 7522,
		name = xmerl_ucs:to_utf8("王城监军"),
		sceneId = 20100,
		x = 60,
		y = 58,
		type = 2
	};

get(7523) ->
	#npc_conf{
		id = 7523,
		name = xmerl_ucs:to_utf8("第一战士"),
		sceneId = 20100,
		x = 16,
		y = 15,
		type = 7
	};

get(7524) ->
	#npc_conf{
		id = 7524,
		name = xmerl_ucs:to_utf8("第一法师"),
		sceneId = 20100,
		x = 19,
		y = 17,
		type = 7
	};

get(7525) ->
	#npc_conf{
		id = 7525,
		name = xmerl_ucs:to_utf8("第一道士"),
		sceneId = 20100,
		x = 22,
		y = 19,
		type = 7
	};

get(7526) ->
	#npc_conf{
		id = 7526,
		name = xmerl_ucs:to_utf8("书店"),
		sceneId = 20101,
		x = 42,
		y = 19,
		type = 2
	};

get(7527) ->
	#npc_conf{
		id = 7527,
		name = xmerl_ucs:to_utf8("药店"),
		sceneId = 20101,
		x = 39,
		y = 27,
		type = 2
	};

get(7528) ->
	#npc_conf{
		id = 7528,
		name = xmerl_ucs:to_utf8("老兵陈伯"),
		sceneId = 20101,
		x = 46,
		y = 15,
		type = 2
	};

get(7530) ->
	#npc_conf{
		id = 7530,
		name = xmerl_ucs:to_utf8("武器店"),
		sceneId = 20101,
		x = 58,
		y = 16,
		type = 2
	};

get(7531) ->
	#npc_conf{
		id = 7531,
		name = xmerl_ucs:to_utf8("服装店"),
		sceneId = 20101,
		x = 48,
		y = 17,
		type = 2
	};

get(7532) ->
	#npc_conf{
		id = 7532,
		name = xmerl_ucs:to_utf8("将军"),
		sceneId = 20100,
		x = 8,
		y = 18,
		type = 2
	};

get(7533) ->
	#npc_conf{
		id = 7533,
		name = xmerl_ucs:to_utf8("书店"),
		sceneId = 20100,
		x = 65,
		y = 33,
		type = 2
	};

get(7534) ->
	#npc_conf{
		id = 7534,
		name = xmerl_ucs:to_utf8("皇宫卫兵"),
		sceneId = 20100,
		x = 11,
		y = 22,
		type = 2
	};

get(7535) ->
	#npc_conf{
		id = 7535,
		name = xmerl_ucs:to_utf8("王城木工"),
		sceneId = 20100,
		x = 91,
		y = 67,
		type = 2
	};

get(7536) ->
	#npc_conf{
		id = 7536,
		name = xmerl_ucs:to_utf8("陈队长"),
		sceneId = 20201,
		x = 23,
		y = 42,
		type = 2
	};

get(7537) ->
	#npc_conf{
		id = 7537,
		name = xmerl_ucs:to_utf8("矿工小张"),
		sceneId = 20201,
		x = 11,
		y = 18,
		type = 2
	};

get(7539) ->
	#npc_conf{
		id = 7539,
		name = xmerl_ucs:to_utf8("矿工小李"),
		sceneId = 20201,
		x = 12,
		y = 29,
		type = 2
	};

get(7540) ->
	#npc_conf{
		id = 7540,
		name = xmerl_ucs:to_utf8("拾荒者"),
		sceneId = 20201,
		x = 8,
		y = 33,
		type = 2
	};

get(7541) ->
	#npc_conf{
		id = 7541,
		name = xmerl_ucs:to_utf8("小队长"),
		sceneId = 20101,
		x = 16,
		y = 5,
		type = 2
	};

get(7542) ->
	#npc_conf{
		id = 7542,
		name = xmerl_ucs:to_utf8("砍柴翁"),
		sceneId = 20101,
		x = 28,
		y = 3,
		type = 2
	};

get(7543) ->
	#npc_conf{
		id = 7543,
		name = xmerl_ucs:to_utf8("王队长"),
		sceneId = 20202,
		x = 8,
		y = 32,
		type = 2
	};

get(7544) ->
	#npc_conf{
		id = 7544,
		name = xmerl_ucs:to_utf8("矿洞先锋"),
		sceneId = 20202,
		x = 18,
		y = 21,
		type = 2
	};

get(7545) ->
	#npc_conf{
		id = 7545,
		name = xmerl_ucs:to_utf8("矿洞行者"),
		sceneId = 20202,
		x = 11,
		y = 4,
		type = 2
	};

get(7546) ->
	#npc_conf{
		id = 7546,
		name = xmerl_ucs:to_utf8("降魔师"),
		sceneId = 20202,
		x = 39,
		y = 7,
		type = 2
	};

get(7547) ->
	#npc_conf{
		id = 7547,
		name = xmerl_ucs:to_utf8("陈药师"),
		sceneId = 20204,
		x = 22,
		y = 12,
		type = 2
	};

get(7548) ->
	#npc_conf{
		id = 7548,
		name = xmerl_ucs:to_utf8("边境探子"),
		sceneId = 20204,
		x = 15,
		y = 36,
		type = 2
	};

get(7549) ->
	#npc_conf{
		id = 7549,
		name = xmerl_ucs:to_utf8("张大宝"),
		sceneId = 20204,
		x = 36,
		y = 29,
		type = 2
	};

get(7550) ->
	#npc_conf{
		id = 7550,
		name = xmerl_ucs:to_utf8("张小宝幻影"),
		sceneId = 20205,
		x = 41,
		y = 17,
		type = 2
	};

get(7551) ->
	#npc_conf{
		id = 7551,
		name = xmerl_ucs:to_utf8("魔物猎人"),
		sceneId = 20205,
		x = 51,
		y = 39,
		type = 2
	};

get(7552) ->
	#npc_conf{
		id = 7552,
		name = xmerl_ucs:to_utf8("职业战士"),
		sceneId = 20205,
		x = 23,
		y = 44,
		type = 2
	};

get(7555) ->
	#npc_conf{
		id = 7555,
		name = xmerl_ucs:to_utf8("首饰店"),
		sceneId = 20102,
		x = 43,
		y = 8,
		type = 2
	};

get(7556) ->
	#npc_conf{
		id = 7556,
		name = xmerl_ucs:to_utf8("服装店"),
		sceneId = 20102,
		x = 56,
		y = 15,
		type = 2
	};

get(7557) ->
	#npc_conf{
		id = 7557,
		name = xmerl_ucs:to_utf8("武器店"),
		sceneId = 20102,
		x = 22,
		y = 17,
		type = 2
	};

get(7559) ->
	#npc_conf{
		id = 7559,
		name = xmerl_ucs:to_utf8("药店"),
		sceneId = 20102,
		x = 10,
		y = 30,
		type = 2
	};

get(7560) ->
	#npc_conf{
		id = 7560,
		name = xmerl_ucs:to_utf8("仓库管理员"),
		sceneId = 20102,
		x = 51,
		y = 43,
		type = 2
	};

get(7561) ->
	#npc_conf{
		id = 7561,
		name = xmerl_ucs:to_utf8("土城老兵"),
		sceneId = 20102,
		x = 81,
		y = 40,
		type = 2
	};

get(7562) ->
	#npc_conf{
		id = 7562,
		name = xmerl_ucs:to_utf8("书店"),
		sceneId = 20102,
		x = 76,
		y = 16,
		type = 2
	};

get(7563) ->
	#npc_conf{
		id = 7563,
		name = xmerl_ucs:to_utf8("农民"),
		sceneId = 20207,
		x = 45,
		y = 8,
		type = 2
	};

get(7564) ->
	#npc_conf{
		id = 7564,
		name = xmerl_ucs:to_utf8("小女孩"),
		sceneId = 20207,
		x = 9,
		y = 14,
		type = 2
	};

get(7565) ->
	#npc_conf{
		id = 7565,
		name = xmerl_ucs:to_utf8("捕虫大师"),
		sceneId = 20207,
		x = 37,
		y = 29,
		type = 2
	};

get(7566) ->
	#npc_conf{
		id = 7566,
		name = xmerl_ucs:to_utf8("昆虫专家"),
		sceneId = 20208,
		x = 47,
		y = 11,
		type = 2
	};

get(7567) ->
	#npc_conf{
		id = 7567,
		name = xmerl_ucs:to_utf8("村民小李"),
		sceneId = 20208,
		x = 30,
		y = 6,
		type = 2
	};

get(7568) ->
	#npc_conf{
		id = 7568,
		name = xmerl_ucs:to_utf8("职业玩家"),
		sceneId = 20208,
		x = 56,
		y = 37,
		type = 2
	};

get(7569) ->
	#npc_conf{
		id = 7569,
		name = xmerl_ucs:to_utf8("祭祀"),
		sceneId = 20209,
		x = 32,
		y = 14,
		type = 2
	};

get(7570) ->
	#npc_conf{
		id = 7570,
		name = xmerl_ucs:to_utf8("猪洞卫士"),
		sceneId = 20210,
		x = 14,
		y = 12,
		type = 2
	};

get(7571) ->
	#npc_conf{
		id = 7571,
		name = xmerl_ucs:to_utf8("祭师"),
		sceneId = 20210,
		x = 44,
		y = 34,
		type = 2
	};

get(7572) ->
	#npc_conf{
		id = 7572,
		name = xmerl_ucs:to_utf8("石匠老王"),
		sceneId = 20211,
		x = 48,
		y = 11,
		type = 2
	};

get(7573) ->
	#npc_conf{
		id = 7573,
		name = xmerl_ucs:to_utf8("盗墓贼"),
		sceneId = 20211,
		x = 49,
		y = 44,
		type = 2
	};

get(7574) ->
	#npc_conf{
		id = 7574,
		name = xmerl_ucs:to_utf8("土城卫士"),
		sceneId = 20213,
		x = 36,
		y = 10,
		type = 2
	};

get(7575) ->
	#npc_conf{
		id = 7575,
		name = xmerl_ucs:to_utf8("工匠老陈"),
		sceneId = 20213,
		x = 11,
		y = 9,
		type = 2
	};

get(7576) ->
	#npc_conf{
		id = 7576,
		name = xmerl_ucs:to_utf8("曾经的信徒"),
		sceneId = 20214,
		x = 39,
		y = 24,
		type = 2
	};

get(7577) ->
	#npc_conf{
		id = 7577,
		name = xmerl_ucs:to_utf8("狙击者"),
		sceneId = 20214,
		x = 42,
		y = 39,
		type = 2
	};

get(7578) ->
	#npc_conf{
		id = 7578,
		name = xmerl_ucs:to_utf8("导游"),
		sceneId = 20216,
		x = 20,
		y = 29,
		type = 2
	};

get(7579) ->
	#npc_conf{
		id = 7579,
		name = xmerl_ucs:to_utf8("迷路旅客"),
		sceneId = 20216,
		x = 41,
		y = 14,
		type = 2
	};

get(7580) ->
	#npc_conf{
		id = 7580,
		name = xmerl_ucs:to_utf8("研究人员"),
		sceneId = 20217,
		x = 63,
		y = 33,
		type = 2
	};

get(7581) ->
	#npc_conf{
		id = 7581,
		name = xmerl_ucs:to_utf8("赤月勇士"),
		sceneId = 20217,
		x = 35,
		y = 3,
		type = 2
	};

get(7582) ->
	#npc_conf{
		id = 7582,
		name = xmerl_ucs:to_utf8("神秘探宝"),
		sceneId = 20102,
		x = 67,
		y = 29,
		type = 2
	};

get(7583) ->
	#npc_conf{
		id = 7583,
		name = xmerl_ucs:to_utf8("张屠夫"),
		sceneId = 20210,
		x = 32,
		y = 10,
		type = 2
	};

get(7584) ->
	#npc_conf{
		id = 7584,
		name = xmerl_ucs:to_utf8("职业法师"),
		sceneId = 20211,
		x = 7,
		y = 38,
		type = 2
	};

get(7585) ->
	#npc_conf{
		id = 7585,
		name = xmerl_ucs:to_utf8("武器师傅"),
		sceneId = 20213,
		x = 26,
		y = 28,
		type = 2
	};

get(7586) ->
	#npc_conf{
		id = 7586,
		name = xmerl_ucs:to_utf8("羊头主教"),
		sceneId = 20214,
		x = 24,
		y = 40,
		type = 2
	};

get(7587) ->
	#npc_conf{
		id = 7587,
		name = xmerl_ucs:to_utf8("麻醉师"),
		sceneId = 20233,
		x = 10,
		y = 29,
		type = 2
	};

get(7588) ->
	#npc_conf{
		id = 7588,
		name = xmerl_ucs:to_utf8("修炼达人"),
		sceneId = 20233,
		x = 61,
		y = 29,
		type = 2
	};

get(7589) ->
	#npc_conf{
		id = 7589,
		name = xmerl_ucs:to_utf8("装备打造"),
		sceneId = 20100,
		x = 65,
		y = 61,
		type = 6
	};

get(7590) ->
	#npc_conf{
		id = 7590,
		name = xmerl_ucs:to_utf8("寻宝猎人"),
		sceneId = 20102,
		x = 82,
		y = 31,
		type = 2
	};

get(7600) ->
	#npc_conf{
		id = 7600,
		name = xmerl_ucs:to_utf8("卫兵"),
		sceneId = 20100,
		x = 47,
		y = 46,
		type = 2
	};

get(7601) ->
	#npc_conf{
		id = 7601,
		name = xmerl_ucs:to_utf8("卫兵"),
		sceneId = 20100,
		x = 52,
		y = 43,
		type = 2
	};

get(7602) ->
	#npc_conf{
		id = 7602,
		name = xmerl_ucs:to_utf8("卫兵"),
		sceneId = 20100,
		x = 97,
		y = 35,
		type = 2
	};

get(7603) ->
	#npc_conf{
		id = 7603,
		name = xmerl_ucs:to_utf8("卫兵"),
		sceneId = 20100,
		x = 103,
		y = 39,
		type = 2
	};

get(7604) ->
	#npc_conf{
		id = 7604,
		name = xmerl_ucs:to_utf8("卫兵"),
		sceneId = 20100,
		x = 118,
		y = 88,
		type = 2
	};

get(7605) ->
	#npc_conf{
		id = 7605,
		name = xmerl_ucs:to_utf8("卫兵"),
		sceneId = 20100,
		x = 113,
		y = 92,
		type = 2
	};

get(7606) ->
	#npc_conf{
		id = 7606,
		name = xmerl_ucs:to_utf8("卫兵"),
		sceneId = 20100,
		x = 27,
		y = 84,
		type = 2
	};

get(7607) ->
	#npc_conf{
		id = 7607,
		name = xmerl_ucs:to_utf8("卫兵"),
		sceneId = 20100,
		x = 31,
		y = 88,
		type = 2
	};

get(7608) ->
	#npc_conf{
		id = 7608,
		name = <<"">>,
		sceneId = 20100,
		x = 56,
		y = 49,
		type = 5
	};

get(7609) ->
	#npc_conf{
		id = 7609,
		name = <<"">>,
		sceneId = 20100,
		x = 56,
		y = 53,
		type = 5
	};

get(7610) ->
	#npc_conf{
		id = 7610,
		name = <<"">>,
		sceneId = 20100,
		x = 56,
		y = 57,
		type = 5
	};

get(7611) ->
	#npc_conf{
		id = 7611,
		name = <<"">>,
		sceneId = 20100,
		x = 56,
		y = 61,
		type = 5
	};

get(7612) ->
	#npc_conf{
		id = 7612,
		name = <<"">>,
		sceneId = 20100,
		x = 56,
		y = 65,
		type = 5
	};

get(7613) ->
	#npc_conf{
		id = 7613,
		name = <<"">>,
		sceneId = 20100,
		x = 60,
		y = 65,
		type = 5
	};

get(7614) ->
	#npc_conf{
		id = 7614,
		name = <<"">>,
		sceneId = 20100,
		x = 64,
		y = 65,
		type = 5
	};

get(7615) ->
	#npc_conf{
		id = 7615,
		name = <<"">>,
		sceneId = 20100,
		x = 68,
		y = 65,
		type = 5
	};

get(7616) ->
	#npc_conf{
		id = 7616,
		name = <<"">>,
		sceneId = 20100,
		x = 72,
		y = 65,
		type = 5
	};

get(7617) ->
	#npc_conf{
		id = 7617,
		name = <<"">>,
		sceneId = 20100,
		x = 76,
		y = 65,
		type = 5
	};

get(7618) ->
	#npc_conf{
		id = 7618,
		name = <<"">>,
		sceneId = 20100,
		x = 80,
		y = 65,
		type = 5
	};

get(7619) ->
	#npc_conf{
		id = 7619,
		name = <<"">>,
		sceneId = 20100,
		x = 80,
		y = 61,
		type = 5
	};

get(7620) ->
	#npc_conf{
		id = 7620,
		name = <<"">>,
		sceneId = 20100,
		x = 80,
		y = 57,
		type = 5
	};

get(7621) ->
	#npc_conf{
		id = 7621,
		name = <<"">>,
		sceneId = 20100,
		x = 80,
		y = 53,
		type = 5
	};

get(7622) ->
	#npc_conf{
		id = 7622,
		name = <<"">>,
		sceneId = 20100,
		x = 80,
		y = 49,
		type = 5
	};

get(7623) ->
	#npc_conf{
		id = 7623,
		name = <<"">>,
		sceneId = 20100,
		x = 76,
		y = 49,
		type = 5
	};

get(7624) ->
	#npc_conf{
		id = 7624,
		name = <<"">>,
		sceneId = 20100,
		x = 72,
		y = 49,
		type = 5
	};

get(7625) ->
	#npc_conf{
		id = 7625,
		name = <<"">>,
		sceneId = 20100,
		x = 68,
		y = 49,
		type = 5
	};

get(7626) ->
	#npc_conf{
		id = 7626,
		name = <<"">>,
		sceneId = 20100,
		x = 64,
		y = 49,
		type = 5
	};

get(7627) ->
	#npc_conf{
		id = 7627,
		name = <<"">>,
		sceneId = 20100,
		x = 60,
		y = 49,
		type = 5
	};

get(7701) ->
	#npc_conf{
		id = 7701,
		name = xmerl_ucs:to_utf8("白日天门老兵"),
		sceneId = 20103,
		x = 70,
		y = 20,
		type = 2
	};

get(7702) ->
	#npc_conf{
		id = 7702,
		name = xmerl_ucs:to_utf8("武器店"),
		sceneId = 20103,
		x = 78,
		y = 18,
		type = 2
	};

get(7703) ->
	#npc_conf{
		id = 7703,
		name = xmerl_ucs:to_utf8("服装店"),
		sceneId = 20103,
		x = 64,
		y = 31,
		type = 2
	};

get(7704) ->
	#npc_conf{
		id = 7704,
		name = xmerl_ucs:to_utf8("首饰店"),
		sceneId = 20103,
		x = 55,
		y = 13,
		type = 2
	};

get(7705) ->
	#npc_conf{
		id = 7705,
		name = xmerl_ucs:to_utf8("书店"),
		sceneId = 20103,
		x = 47,
		y = 6,
		type = 2
	};

get(7706) ->
	#npc_conf{
		id = 7706,
		name = xmerl_ucs:to_utf8("药店"),
		sceneId = 20103,
		x = 64,
		y = 8,
		type = 2
	};

get(7707) ->
	#npc_conf{
		id = 7707,
		name = xmerl_ucs:to_utf8("仓库管理员"),
		sceneId = 20103,
		x = 58,
		y = 24,
		type = 2
	};

get(7708) ->
	#npc_conf{
		id = 7708,
		name = xmerl_ucs:to_utf8("卫兵"),
		sceneId = 20103,
		x = 26,
		y = 11,
		type = 2
	};

get(7709) ->
	#npc_conf{
		id = 7709,
		name = xmerl_ucs:to_utf8("卫兵"),
		sceneId = 20103,
		x = 18,
		y = 14,
		type = 2
	};

get(7710) ->
	#npc_conf{
		id = 7710,
		name = xmerl_ucs:to_utf8("神秘老人"),
		sceneId = 20103,
		x = 74,
		y = 9,
		type = 2
	};

get(7711) ->
	#npc_conf{
		id = 7711,
		name = xmerl_ucs:to_utf8("武器尊者"),
		sceneId = 20103,
		x = 64,
		y = 16,
		type = 2
	};

get(7741) ->
	#npc_conf{
		id = 7741,
		name = <<"">>,
		sceneId = 20102,
		x = 54,
		y = 27,
		type = 5
	};

get(7742) ->
	#npc_conf{
		id = 7742,
		name = <<"">>,
		sceneId = 20102,
		x = 54,
		y = 28,
		type = 5
	};

get(7743) ->
	#npc_conf{
		id = 7743,
		name = <<"">>,
		sceneId = 20102,
		x = 54,
		y = 30,
		type = 5
	};

get(7744) ->
	#npc_conf{
		id = 7744,
		name = <<"">>,
		sceneId = 20102,
		x = 54,
		y = 33,
		type = 5
	};

get(7745) ->
	#npc_conf{
		id = 7745,
		name = <<"">>,
		sceneId = 20102,
		x = 54,
		y = 35,
		type = 5
	};

get(7746) ->
	#npc_conf{
		id = 7746,
		name = <<"">>,
		sceneId = 20102,
		x = 54,
		y = 36,
		type = 5
	};

get(7747) ->
	#npc_conf{
		id = 7747,
		name = <<"">>,
		sceneId = 20102,
		x = 54,
		y = 38,
		type = 5
	};

get(7748) ->
	#npc_conf{
		id = 7748,
		name = <<"">>,
		sceneId = 20102,
		x = 54,
		y = 39,
		type = 5
	};

get(7749) ->
	#npc_conf{
		id = 7749,
		name = <<"">>,
		sceneId = 20102,
		x = 55,
		y = 39,
		type = 5
	};

get(7750) ->
	#npc_conf{
		id = 7750,
		name = <<"">>,
		sceneId = 20102,
		x = 58,
		y = 39,
		type = 5
	};

get(7751) ->
	#npc_conf{
		id = 7751,
		name = <<"">>,
		sceneId = 20102,
		x = 61,
		y = 39,
		type = 5
	};

get(7752) ->
	#npc_conf{
		id = 7752,
		name = <<"">>,
		sceneId = 20102,
		x = 63,
		y = 39,
		type = 5
	};

get(7753) ->
	#npc_conf{
		id = 7753,
		name = <<"">>,
		sceneId = 20102,
		x = 65,
		y = 39,
		type = 5
	};

get(7754) ->
	#npc_conf{
		id = 7754,
		name = <<"">>,
		sceneId = 20102,
		x = 68,
		y = 39,
		type = 5
	};

get(7755) ->
	#npc_conf{
		id = 7755,
		name = <<"">>,
		sceneId = 20102,
		x = 69,
		y = 39,
		type = 5
	};

get(7756) ->
	#npc_conf{
		id = 7756,
		name = <<"">>,
		sceneId = 20102,
		x = 69,
		y = 38,
		type = 5
	};

get(7757) ->
	#npc_conf{
		id = 7757,
		name = <<"">>,
		sceneId = 20102,
		x = 69,
		y = 36,
		type = 5
	};

get(7758) ->
	#npc_conf{
		id = 7758,
		name = <<"">>,
		sceneId = 20102,
		x = 69,
		y = 35,
		type = 5
	};

get(7759) ->
	#npc_conf{
		id = 7759,
		name = <<"">>,
		sceneId = 20102,
		x = 69,
		y = 33,
		type = 5
	};

get(7760) ->
	#npc_conf{
		id = 7760,
		name = <<"">>,
		sceneId = 20102,
		x = 69,
		y = 30,
		type = 5
	};

get(7761) ->
	#npc_conf{
		id = 7761,
		name = <<"">>,
		sceneId = 20102,
		x = 69,
		y = 28,
		type = 5
	};

get(7762) ->
	#npc_conf{
		id = 7762,
		name = <<"">>,
		sceneId = 20102,
		x = 69,
		y = 27,
		type = 5
	};

get(7763) ->
	#npc_conf{
		id = 7763,
		name = <<"">>,
		sceneId = 20102,
		x = 68,
		y = 27,
		type = 5
	};

get(7764) ->
	#npc_conf{
		id = 7764,
		name = <<"">>,
		sceneId = 20102,
		x = 65,
		y = 27,
		type = 5
	};

get(7765) ->
	#npc_conf{
		id = 7765,
		name = <<"">>,
		sceneId = 20102,
		x = 61,
		y = 27,
		type = 5
	};

get(7766) ->
	#npc_conf{
		id = 7766,
		name = <<"">>,
		sceneId = 20102,
		x = 58,
		y = 27,
		type = 5
	};

get(7767) ->
	#npc_conf{
		id = 7767,
		name = <<"">>,
		sceneId = 20102,
		x = 55,
		y = 27,
		type = 5
	};

get(7779) ->
	#npc_conf{
		id = 7779,
		name = <<"">>,
		sceneId = 20103,
		x = 56,
		y = 12,
		type = 5
	};

get(7780) ->
	#npc_conf{
		id = 7780,
		name = <<"">>,
		sceneId = 20103,
		x = 56,
		y = 16,
		type = 5
	};

get(7781) ->
	#npc_conf{
		id = 7781,
		name = <<"">>,
		sceneId = 20103,
		x = 56,
		y = 19,
		type = 5
	};

get(7782) ->
	#npc_conf{
		id = 7782,
		name = <<"">>,
		sceneId = 20103,
		x = 56,
		y = 23,
		type = 5
	};

get(7783) ->
	#npc_conf{
		id = 7783,
		name = <<"">>,
		sceneId = 20103,
		x = 59,
		y = 23,
		type = 5
	};

get(7784) ->
	#npc_conf{
		id = 7784,
		name = <<"">>,
		sceneId = 20103,
		x = 62,
		y = 23,
		type = 5
	};

get(7785) ->
	#npc_conf{
		id = 7785,
		name = <<"">>,
		sceneId = 20103,
		x = 65,
		y = 23,
		type = 5
	};

get(7786) ->
	#npc_conf{
		id = 7786,
		name = <<"">>,
		sceneId = 20103,
		x = 68,
		y = 23,
		type = 5
	};

get(7787) ->
	#npc_conf{
		id = 7787,
		name = <<"">>,
		sceneId = 20103,
		x = 71,
		y = 23,
		type = 5
	};

get(7788) ->
	#npc_conf{
		id = 7788,
		name = <<"">>,
		sceneId = 20103,
		x = 74,
		y = 23,
		type = 5
	};

get(7789) ->
	#npc_conf{
		id = 7789,
		name = <<"">>,
		sceneId = 20103,
		x = 74,
		y = 20,
		type = 5
	};

get(7790) ->
	#npc_conf{
		id = 7790,
		name = <<"">>,
		sceneId = 20103,
		x = 74,
		y = 16,
		type = 5
	};

get(7791) ->
	#npc_conf{
		id = 7791,
		name = <<"">>,
		sceneId = 20103,
		x = 74,
		y = 12,
		type = 5
	};

get(7792) ->
	#npc_conf{
		id = 7792,
		name = <<"">>,
		sceneId = 20103,
		x = 59,
		y = 12,
		type = 5
	};

get(7793) ->
	#npc_conf{
		id = 7793,
		name = <<"">>,
		sceneId = 20103,
		x = 62,
		y = 12,
		type = 5
	};

get(7794) ->
	#npc_conf{
		id = 7794,
		name = <<"">>,
		sceneId = 20103,
		x = 65,
		y = 12,
		type = 5
	};

get(7795) ->
	#npc_conf{
		id = 7795,
		name = <<"">>,
		sceneId = 20103,
		x = 68,
		y = 12,
		type = 5
	};

get(7800) ->
	#npc_conf{
		id = 7800,
		name = xmerl_ucs:to_utf8("行会使者"),
		sceneId = 20100,
		x = 69,
		y = 51,
		type = 2
	};

get(7900) ->
	#npc_conf{
		id = 7900,
		name = <<"">>,
		sceneId = 20015,
		x = 89,
		y = 61,
		type = 5
	};

get(7901) ->
	#npc_conf{
		id = 7901,
		name = <<"">>,
		sceneId = 20015,
		x = 91,
		y = 61,
		type = 5
	};

get(7902) ->
	#npc_conf{
		id = 7902,
		name = <<"">>,
		sceneId = 20015,
		x = 93,
		y = 61,
		type = 5
	};

get(7903) ->
	#npc_conf{
		id = 7903,
		name = <<"">>,
		sceneId = 20015,
		x = 95,
		y = 61,
		type = 5
	};

get(7904) ->
	#npc_conf{
		id = 7904,
		name = <<"">>,
		sceneId = 20015,
		x = 97,
		y = 61,
		type = 5
	};

get(7905) ->
	#npc_conf{
		id = 7905,
		name = <<"">>,
		sceneId = 20015,
		x = 99,
		y = 61,
		type = 5
	};

get(7906) ->
	#npc_conf{
		id = 7906,
		name = <<"">>,
		sceneId = 20015,
		x = 99,
		y = 63,
		type = 5
	};

get(7907) ->
	#npc_conf{
		id = 7907,
		name = <<"">>,
		sceneId = 20015,
		x = 99,
		y = 65,
		type = 5
	};

get(7908) ->
	#npc_conf{
		id = 7908,
		name = <<"">>,
		sceneId = 20015,
		x = 99,
		y = 67,
		type = 5
	};

get(7909) ->
	#npc_conf{
		id = 7909,
		name = <<"">>,
		sceneId = 20015,
		x = 99,
		y = 69,
		type = 5
	};

get(7910) ->
	#npc_conf{
		id = 7910,
		name = <<"">>,
		sceneId = 20015,
		x = 97,
		y = 69,
		type = 5
	};

get(7911) ->
	#npc_conf{
		id = 7911,
		name = <<"">>,
		sceneId = 20015,
		x = 95,
		y = 69,
		type = 5
	};

get(7912) ->
	#npc_conf{
		id = 7912,
		name = <<"">>,
		sceneId = 20015,
		x = 93,
		y = 69,
		type = 5
	};

get(7913) ->
	#npc_conf{
		id = 7913,
		name = <<"">>,
		sceneId = 20015,
		x = 91,
		y = 69,
		type = 5
	};

get(7914) ->
	#npc_conf{
		id = 7914,
		name = <<"">>,
		sceneId = 20015,
		x = 89,
		y = 69,
		type = 5
	};

get(7915) ->
	#npc_conf{
		id = 7915,
		name = <<"">>,
		sceneId = 20015,
		x = 89,
		y = 67,
		type = 5
	};

get(7916) ->
	#npc_conf{
		id = 7916,
		name = <<"">>,
		sceneId = 20015,
		x = 89,
		y = 65,
		type = 5
	};

get(7917) ->
	#npc_conf{
		id = 7917,
		name = <<"">>,
		sceneId = 20015,
		x = 89,
		y = 63,
		type = 5
	};

get(7918) ->
	#npc_conf{
		id = 7918,
		name = <<"">>,
		sceneId = 20015,
		x = 56,
		y = 18,
		type = 5
	};

get(7919) ->
	#npc_conf{
		id = 7919,
		name = <<"">>,
		sceneId = 20015,
		x = 59,
		y = 18,
		type = 5
	};

get(7920) ->
	#npc_conf{
		id = 7920,
		name = <<"">>,
		sceneId = 20015,
		x = 62,
		y = 18,
		type = 5
	};

get(7921) ->
	#npc_conf{
		id = 7921,
		name = <<"">>,
		sceneId = 20015,
		x = 62,
		y = 21,
		type = 5
	};

get(7922) ->
	#npc_conf{
		id = 7922,
		name = <<"">>,
		sceneId = 20015,
		x = 62,
		y = 23,
		type = 5
	};

get(7923) ->
	#npc_conf{
		id = 7923,
		name = <<"">>,
		sceneId = 20015,
		x = 59,
		y = 23,
		type = 5
	};

get(7924) ->
	#npc_conf{
		id = 7924,
		name = <<"">>,
		sceneId = 20015,
		x = 56,
		y = 23,
		type = 5
	};

get(7925) ->
	#npc_conf{
		id = 7925,
		name = <<"">>,
		sceneId = 20015,
		x = 56,
		y = 21,
		type = 5
	};

get(8001) ->
	#npc_conf{
		id = 8001,
		name = xmerl_ucs:to_utf8("沧月岛老兵"),
		sceneId = 20105,
		x = 43,
		y = 28,
		type = 2
	};

get(8002) ->
	#npc_conf{
		id = 8002,
		name = xmerl_ucs:to_utf8("海鲜店老板"),
		sceneId = 20105,
		x = 68,
		y = 39,
		type = 2
	};

get(8003) ->
	#npc_conf{
		id = 8003,
		name = xmerl_ucs:to_utf8("武器店"),
		sceneId = 20105,
		x = 52,
		y = 14,
		type = 2
	};

get(8004) ->
	#npc_conf{
		id = 8004,
		name = xmerl_ucs:to_utf8("服装店"),
		sceneId = 20105,
		x = 57,
		y = 26,
		type = 2
	};

get(8005) ->
	#npc_conf{
		id = 8005,
		name = xmerl_ucs:to_utf8("首饰店"),
		sceneId = 20105,
		x = 30,
		y = 19,
		type = 2
	};

get(8006) ->
	#npc_conf{
		id = 8006,
		name = xmerl_ucs:to_utf8("书店"),
		sceneId = 20105,
		x = 26,
		y = 12,
		type = 2
	};

get(8007) ->
	#npc_conf{
		id = 8007,
		name = xmerl_ucs:to_utf8("药店"),
		sceneId = 20105,
		x = 14,
		y = 26,
		type = 2
	};

get(8008) ->
	#npc_conf{
		id = 8008,
		name = xmerl_ucs:to_utf8("仓库管理员"),
		sceneId = 20105,
		x = 13,
		y = 19,
		type = 2
	};

get(8009) ->
	#npc_conf{
		id = 8009,
		name = xmerl_ucs:to_utf8("渔业会长"),
		sceneId = 20105,
		x = 21,
		y = 37,
		type = 2
	};

get(8010) ->
	#npc_conf{
		id = 8010,
		name = xmerl_ucs:to_utf8("沧月岛渔夫"),
		sceneId = 20234,
		x = 76,
		y = 16,
		type = 2
	};

get(8011) ->
	#npc_conf{
		id = 8011,
		name = xmerl_ucs:to_utf8("潜水者"),
		sceneId = 20234,
		x = 67,
		y = 34,
		type = 2
	};

get(8012) ->
	#npc_conf{
		id = 8012,
		name = xmerl_ucs:to_utf8("寻宝家"),
		sceneId = 20234,
		x = 37,
		y = 59,
		type = 2
	};

get(8013) ->
	#npc_conf{
		id = 8013,
		name = xmerl_ucs:to_utf8("捕鱼达人"),
		sceneId = 20235,
		x = 10,
		y = 5,
		type = 2
	};

get(8014) ->
	#npc_conf{
		id = 8014,
		name = <<"">>,
		sceneId = 20105,
		x = 21,
		y = 15,
		type = 5
	};

get(8015) ->
	#npc_conf{
		id = 8015,
		name = <<"">>,
		sceneId = 20105,
		x = 21,
		y = 17,
		type = 5
	};

get(8016) ->
	#npc_conf{
		id = 8016,
		name = <<"">>,
		sceneId = 20105,
		x = 21,
		y = 19,
		type = 5
	};

get(8017) ->
	#npc_conf{
		id = 8017,
		name = <<"">>,
		sceneId = 20105,
		x = 21,
		y = 22,
		type = 5
	};

get(8018) ->
	#npc_conf{
		id = 8018,
		name = <<"">>,
		sceneId = 20105,
		x = 22,
		y = 22,
		type = 5
	};

get(8019) ->
	#npc_conf{
		id = 8019,
		name = <<"">>,
		sceneId = 20105,
		x = 24,
		y = 22,
		type = 5
	};

get(8020) ->
	#npc_conf{
		id = 8020,
		name = <<"">>,
		sceneId = 20105,
		x = 26,
		y = 22,
		type = 5
	};

get(8021) ->
	#npc_conf{
		id = 8021,
		name = <<"">>,
		sceneId = 20105,
		x = 28,
		y = 22,
		type = 5
	};

get(8022) ->
	#npc_conf{
		id = 8022,
		name = <<"">>,
		sceneId = 20105,
		x = 30,
		y = 22,
		type = 5
	};

get(8023) ->
	#npc_conf{
		id = 8023,
		name = <<"">>,
		sceneId = 20105,
		x = 33,
		y = 22,
		type = 5
	};

get(8024) ->
	#npc_conf{
		id = 8024,
		name = <<"">>,
		sceneId = 20105,
		x = 34,
		y = 22,
		type = 5
	};

get(8025) ->
	#npc_conf{
		id = 8025,
		name = <<"">>,
		sceneId = 20105,
		x = 34,
		y = 21,
		type = 5
	};

get(8026) ->
	#npc_conf{
		id = 8026,
		name = <<"">>,
		sceneId = 20105,
		x = 34,
		y = 18,
		type = 5
	};

get(8027) ->
	#npc_conf{
		id = 8027,
		name = <<"">>,
		sceneId = 20105,
		x = 34,
		y = 15,
		type = 5
	};

get(8028) ->
	#npc_conf{
		id = 8028,
		name = <<"">>,
		sceneId = 20105,
		x = 34,
		y = 14,
		type = 5
	};

get(8029) ->
	#npc_conf{
		id = 8029,
		name = <<"">>,
		sceneId = 20105,
		x = 33,
		y = 14,
		type = 5
	};

get(8030) ->
	#npc_conf{
		id = 8030,
		name = <<"">>,
		sceneId = 20105,
		x = 30,
		y = 14,
		type = 5
	};

get(8031) ->
	#npc_conf{
		id = 8031,
		name = <<"">>,
		sceneId = 20105,
		x = 28,
		y = 14,
		type = 5
	};

get(8032) ->
	#npc_conf{
		id = 8032,
		name = <<"">>,
		sceneId = 20105,
		x = 26,
		y = 14,
		type = 5
	};

get(8033) ->
	#npc_conf{
		id = 8033,
		name = <<"">>,
		sceneId = 20105,
		x = 24,
		y = 14,
		type = 5
	};

get(8034) ->
	#npc_conf{
		id = 8034,
		name = <<"">>,
		sceneId = 20105,
		x = 23,
		y = 14,
		type = 5
	};

get(8040) ->
	#npc_conf{
		id = 8040,
		name = xmerl_ucs:to_utf8("挑战者"),
		sceneId = 20237,
		x = 63,
		y = 41,
		type = 2
	};

get(8041) ->
	#npc_conf{
		id = 8041,
		name = xmerl_ucs:to_utf8("精壮男子"),
		sceneId = 20237,
		x = 61,
		y = 13,
		type = 2
	};

get(8042) ->
	#npc_conf{
		id = 8042,
		name = xmerl_ucs:to_utf8("牛魔祭师"),
		sceneId = 20238,
		x = 21,
		y = 13,
		type = 2
	};

get(8050) ->
	#npc_conf{
		id = 8050,
		name = xmerl_ucs:to_utf8("火龙神殿2层"),
		sceneId = 31002,
		x = 14,
		y = 11,
		type = 2
	};

get(8051) ->
	#npc_conf{
		id = 8051,
		name = xmerl_ucs:to_utf8("火龙神殿3层"),
		sceneId = 31003,
		x = 51,
		y = 24,
		type = 2
	};

get(8052) ->
	#npc_conf{
		id = 8052,
		name = xmerl_ucs:to_utf8("跨服火龙神殿"),
		sceneId = 31001,
		x = 50,
		y = 27,
		type = 2
	};

get(8060) ->
	#npc_conf{
		id = 8060,
		name = xmerl_ucs:to_utf8("2层传送使者"),
		sceneId = 32101,
		x = 12,
		y = 38,
		type = 2
	};

get(8061) ->
	#npc_conf{
		id = 8061,
		name = xmerl_ucs:to_utf8("3层传送使者"),
		sceneId = 32102,
		x = 88,
		y = 56,
		type = 2
	};

get(8062) ->
	#npc_conf{
		id = 8062,
		name = xmerl_ucs:to_utf8("火龙神殿2层"),
		sceneId = 32109,
		x = 14,
		y = 11,
		type = 2
	};

get(8063) ->
	#npc_conf{
		id = 8063,
		name = xmerl_ucs:to_utf8("火龙神殿3层"),
		sceneId = 32110,
		x = 51,
		y = 24,
		type = 2
	};

get(8064) ->
	#npc_conf{
		id = 8064,
		name = xmerl_ucs:to_utf8("4层传送使者"),
		sceneId = 32103,
		x = 70,
		y = 37,
		type = 2
	};

get(8065) ->
	#npc_conf{
		id = 8065,
		name = xmerl_ucs:to_utf8("2层传送使者"),
		sceneId = 32122,
		x = 27,
		y = 58,
		type = 2
	};

get(8066) ->
	#npc_conf{
		id = 8066,
		name = xmerl_ucs:to_utf8("3层传送使者"),
		sceneId = 32123,
		x = 29,
		y = 59,
		type = 2
	};

get(8067) ->
	#npc_conf{
		id = 8067,
		name = xmerl_ucs:to_utf8("4层传送使者"),
		sceneId = 32124,
		x = 23,
		y = 34,
		type = 2
	};

get(_Key) ->
	?ERR("undefined key from npc_config ~p", [_Key]).