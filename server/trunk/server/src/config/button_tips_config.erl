%%%-------------------------------------------------------------------
%%% @author zhengsiying
%%% @doc
%%%		自动生成文件，不要手动修改
%%% @end
%%% Created : 2016/10/12
%%%-------------------------------------------------------------------

-module(button_tips_config).

-include("common.hrl").
-include("config.hrl").
-include("button_tips_config.hrl").

-compile([export_all]).

get_list_conf() ->
	[ button_tips_config:get(X) || X <- get_list() ].

get_list() ->
	[1, 2, 3, 4, 5, 6, 7, 8, 9, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32, 33, 34, 35, 36, 37, 38, 39, 40, 41, 42, 43, 44, 45, 46, 47, 48, 49, 50, 51, 52, 53, 54, 55, 56, 57, 58, 59, 60, 61, 62, 63, 64, 65, 66, 67, 68, 69, 70, 71, 72, 73, 75, 76, 77, 78, 79, 80, 81, 82, 83, 84, 85, 86, 87, 88, 89, 90, 91, 92, 93, 94, 95, 96, 97, 98, 99, 100, 101, 102, 103, 104, 105, 106, 107, 108, 109, 110].

get_sun_list(14) ->
	[3, 4, 5, 6, 65];
get_sun_list(7) ->
	[8, 9, 28, 68, 72];
get_sun_list(11) ->
	[12];
get_sun_list(12) ->
	[13];
get_sun_list(1) ->
	[14, 55];
get_sun_list(15) ->
	[16, 18, 22, 84, 95, 96];
get_sun_list(16) ->
	[17];
get_sun_list(18) ->
	[19, 20, 21];
get_sun_list(23) ->
	[24, 53];
get_sun_list(26) ->
	[27];
get_sun_list(29) ->
	[30];
get_sun_list(31) ->
	[32, 33, 34, 35, 36, 37, 38, 39, 40, 41, 42, 43, 44, 45, 46];
get_sun_list(47) ->
	[48];
get_sun_list(48) ->
	[49, 50, 51];
get_sun_list(53) ->
	[54];
get_sun_list(55) ->
	[56, 57, 58, 83, 104, 105, 106, 107, 108, 109];
get_sun_list(59) ->
	[60, 61, 62, 63, 64, 85, 86, 87];
get_sun_list(65) ->
	[66, 67];
get_sun_list(87) ->
	[69, 75, 89, 90, 91, 92, 93, 94];
get_sun_list(28) ->
	[70, 71];
get_sun_list(76) ->
	[77, 88];
get_sun_list(77) ->
	[78, 79, 80, 81, 82];
get_sun_list(95) ->
	[97];
get_sun_list(98) ->
	[99, 100, 101, 102, 103];
get_sun_list(_) -> [].

get_parent_list(3) ->
	[14, 1];
get_parent_list(4) ->
	[14, 1];
get_parent_list(5) ->
	[14, 1];
get_parent_list(6) ->
	[14, 1];
get_parent_list(8) ->
	[7];
get_parent_list(9) ->
	[7];
get_parent_list(12) ->
	[11];
get_parent_list(13) ->
	[12, 11];
get_parent_list(14) ->
	[1];
get_parent_list(16) ->
	[15];
get_parent_list(17) ->
	[16, 15];
get_parent_list(18) ->
	[15];
get_parent_list(19) ->
	[18, 15];
get_parent_list(20) ->
	[18, 15];
get_parent_list(21) ->
	[18, 15];
get_parent_list(22) ->
	[15];
get_parent_list(24) ->
	[23];
get_parent_list(27) ->
	[26];
get_parent_list(28) ->
	[7];
get_parent_list(30) ->
	[29];
get_parent_list(32) ->
	[31];
get_parent_list(33) ->
	[31];
get_parent_list(34) ->
	[31];
get_parent_list(35) ->
	[31];
get_parent_list(36) ->
	[31];
get_parent_list(37) ->
	[31];
get_parent_list(38) ->
	[31];
get_parent_list(39) ->
	[31];
get_parent_list(40) ->
	[31];
get_parent_list(41) ->
	[31];
get_parent_list(42) ->
	[31];
get_parent_list(43) ->
	[31];
get_parent_list(44) ->
	[31];
get_parent_list(45) ->
	[31];
get_parent_list(46) ->
	[31];
get_parent_list(48) ->
	[47];
get_parent_list(49) ->
	[48, 47];
get_parent_list(50) ->
	[48, 47];
get_parent_list(51) ->
	[48, 47];
get_parent_list(53) ->
	[23];
get_parent_list(54) ->
	[53, 23];
get_parent_list(55) ->
	[1];
get_parent_list(56) ->
	[55, 1];
get_parent_list(57) ->
	[55, 1];
get_parent_list(58) ->
	[55, 1];
get_parent_list(60) ->
	[59];
get_parent_list(61) ->
	[59];
get_parent_list(62) ->
	[59];
get_parent_list(63) ->
	[59];
get_parent_list(64) ->
	[59];
get_parent_list(65) ->
	[14, 1];
get_parent_list(66) ->
	[65, 14, 1];
get_parent_list(67) ->
	[65, 14, 1];
get_parent_list(68) ->
	[7];
get_parent_list(69) ->
	[87, 59];
get_parent_list(70) ->
	[28, 7];
get_parent_list(71) ->
	[28, 7];
get_parent_list(72) ->
	[7];
get_parent_list(75) ->
	[87, 59];
get_parent_list(77) ->
	[76];
get_parent_list(78) ->
	[77, 76];
get_parent_list(79) ->
	[77, 76];
get_parent_list(80) ->
	[77, 76];
get_parent_list(81) ->
	[77, 76];
get_parent_list(82) ->
	[77, 76];
get_parent_list(83) ->
	[55, 1];
get_parent_list(84) ->
	[15];
get_parent_list(85) ->
	[59];
get_parent_list(86) ->
	[59];
get_parent_list(87) ->
	[59];
get_parent_list(88) ->
	[76];
get_parent_list(89) ->
	[87, 59];
get_parent_list(90) ->
	[87, 59];
get_parent_list(91) ->
	[87, 59];
get_parent_list(92) ->
	[87, 59];
get_parent_list(93) ->
	[87, 59];
get_parent_list(94) ->
	[87, 59];
get_parent_list(95) ->
	[15];
get_parent_list(96) ->
	[15];
get_parent_list(97) ->
	[95, 15];
get_parent_list(99) ->
	[98];
get_parent_list(100) ->
	[98];
get_parent_list(101) ->
	[98];
get_parent_list(102) ->
	[98];
get_parent_list(103) ->
	[98];
get_parent_list(104) ->
	[55, 1];
get_parent_list(105) ->
	[55, 1];
get_parent_list(106) ->
	[55, 1];
get_parent_list(107) ->
	[55, 1];
get_parent_list(108) ->
	[55, 1];
get_parent_list(109) ->
	[55, 1];
get_parent_list(_) -> [].

get_load_list() -> 
	[[2, 3, 4, 5, 6, 8, 9, 13, 17, 19, 20, 21, 22, 24, 25, 27, 30, 32, 33, 34, 35, 36, 37, 38, 39, 40, 41, 42, 43, 44, 45, 46, 49, 50, 51, 52, 54, 56, 57, 58, 60, 61, 62, 63, 64, 66, 67, 68, 69, 70, 71, 72, 73, 75, 78, 79, 80, 81, 82, 83, 84, 85, 86, 88, 89, 90, 91, 92, 93, 94, 96, 97, 99, 100, 101, 102, 103, 104, 105, 106, 107, 108, 109, 110],[12, 16, 18, 26, 29, 31, 48, 53, 55, 65, 87, 28, 77, 95, 98],[11, 15, 47, 23, 14, 59, 7, 76],[1]].

get(1) ->
	#button_tips_conf{
		id = 1,
		name = xmerl_ucs:to_utf8("活动中心"),
		macro = <<"BTN_ACTIVITY">>,
		parent = 0,
		daily_refresh = 1,
		trigger = 1,
		daily_one_count = 0
	};

get(2) ->
	#button_tips_conf{
		id = 2,
		name = xmerl_ucs:to_utf8("今日目标"),
		macro = <<"BTN_DAILY_TARGET">>,
		parent = 0,
		daily_refresh = 1,
		trigger = 1,
		daily_one_count = 0
	};

get(3) ->
	#button_tips_conf{
		id = 3,
		name = xmerl_ucs:to_utf8("排位赛"),
		macro = <<"BTN_ARENA">>,
		parent = 14,
		daily_refresh = 1,
		trigger = 1,
		daily_one_count = 0
	};

get(4) ->
	#button_tips_conf{
		id = 4,
		name = xmerl_ucs:to_utf8("功勋任务"),
		macro = <<"BTN_TASK_MERIT">>,
		parent = 14,
		daily_refresh = 1,
		trigger = 1,
		daily_one_count = 0
	};

get(5) ->
	#button_tips_conf{
		id = 5,
		name = xmerl_ucs:to_utf8("膜拜英雄"),
		macro = <<"BTN_WORSHIP">>,
		parent = 14,
		daily_refresh = 1,
		trigger = 1,
		daily_one_count = 0
	};

get(6) ->
	#button_tips_conf{
		id = 6,
		name = xmerl_ucs:to_utf8("个人副本"),
		macro = <<"BTN_INSTANCE_SINGLE">>,
		parent = 14,
		daily_refresh = 1,
		trigger = 1,
		daily_one_count = 0
	};

get(7) ->
	#button_tips_conf{
		id = 7,
		name = xmerl_ucs:to_utf8("福利大厅"),
		macro = <<"BTN_WELFARE">>,
		parent = 0,
		daily_refresh = 1,
		trigger = 1,
		daily_one_count = 0
	};

get(8) ->
	#button_tips_conf{
		id = 8,
		name = xmerl_ucs:to_utf8("连续登陆"),
		macro = <<"BTN_LOGIN">>,
		parent = 7,
		daily_refresh = 1,
		trigger = 1,
		daily_one_count = 0
	};

get(9) ->
	#button_tips_conf{
		id = 9,
		name = xmerl_ucs:to_utf8("在线奖励"),
		macro = <<"BTN_AWARD_ONLINE">>,
		parent = 7,
		daily_refresh = 1,
		trigger = 1,
		daily_one_count = 0
	};

get(11) ->
	#button_tips_conf{
		id = 11,
		name = xmerl_ucs:to_utf8("装备"),
		macro = <<"BTN_EQUIP">>,
		parent = 0,
		daily_refresh = 0,
		trigger = 1,
		daily_one_count = 0
	};

get(12) ->
	#button_tips_conf{
		id = 12,
		name = xmerl_ucs:to_utf8("勋章"),
		macro = <<"BTN_MEDAL">>,
		parent = 11,
		daily_refresh = 0,
		trigger = 1,
		daily_one_count = 0
	};

get(13) ->
	#button_tips_conf{
		id = 13,
		name = xmerl_ucs:to_utf8("升级"),
		macro = <<"BTN_MEDAL_UPGRADE">>,
		parent = 12,
		daily_refresh = 0,
		trigger = 1,
		daily_one_count = 0
	};

get(14) ->
	#button_tips_conf{
		id = 14,
		name = xmerl_ucs:to_utf8("日常任务"),
		macro = <<"BTN_ACTIVITY_DAILY">>,
		parent = 1,
		daily_refresh = 1,
		trigger = 1,
		daily_one_count = 0
	};

get(15) ->
	#button_tips_conf{
		id = 15,
		name = xmerl_ucs:to_utf8("行会"),
		macro = <<"BIN_GUILD">>,
		parent = 0,
		daily_refresh = 1,
		trigger = <<"">>,
		daily_one_count = 0
	};

get(16) ->
	#button_tips_conf{
		id = 16,
		name = xmerl_ucs:to_utf8("行会信息"),
		macro = <<"BIN_GUILD_INFO">>,
		parent = 15,
		daily_refresh = 1,
		trigger = <<"">>,
		daily_one_count = 0
	};

get(17) ->
	#button_tips_conf{
		id = 17,
		name = xmerl_ucs:to_utf8("每日捐献"),
		macro = <<"BTN_GUILD_CONTRIBUTION">>,
		parent = 16,
		daily_refresh = 1,
		trigger = <<"">>,
		daily_one_count = 0
	};

get(18) ->
	#button_tips_conf{
		id = 18,
		name = xmerl_ucs:to_utf8("行会活动"),
		macro = <<"BIN_GUILD_ACTIVE">>,
		parent = 15,
		daily_refresh = 1,
		trigger = <<"">>,
		daily_one_count = 0
	};

get(19) ->
	#button_tips_conf{
		id = 19,
		name = xmerl_ucs:to_utf8("行会BOSS"),
		macro = <<"BTN_GUILD_BOSS">>,
		parent = 18,
		daily_refresh = 1,
		trigger = <<"">>,
		daily_one_count = 0
	};

get(20) ->
	#button_tips_conf{
		id = 20,
		name = xmerl_ucs:to_utf8("行会秘境"),
		macro = <<"BTN_GUILD_MJ">>,
		parent = 18,
		daily_refresh = 1,
		trigger = <<"">>,
		daily_one_count = 0
	};

get(21) ->
	#button_tips_conf{
		id = 21,
		name = xmerl_ucs:to_utf8("沙巴克秘境"),
		macro = <<"BTN_SBK_MJ">>,
		parent = 18,
		daily_refresh = 1,
		trigger = <<"">>,
		daily_one_count = 0
	};

get(22) ->
	#button_tips_conf{
		id = 22,
		name = xmerl_ucs:to_utf8("申请列表"),
		macro = <<"BTN_GUILD_APPLY_LIST">>,
		parent = 15,
		daily_refresh = 0,
		trigger = <<"">>,
		daily_one_count = 0
	};

get(23) ->
	#button_tips_conf{
		id = 23,
		name = xmerl_ucs:to_utf8("社交"),
		macro = <<"BIN_SOCIAL">>,
		parent = 0,
		daily_refresh = 0,
		trigger = <<"">>,
		daily_one_count = 0
	};

get(24) ->
	#button_tips_conf{
		id = 24,
		name = xmerl_ucs:to_utf8("邮件"),
		macro = <<"BTN_MAIL">>,
		parent = 23,
		daily_refresh = 0,
		trigger = <<"">>,
		daily_one_count = 0
	};

get(25) ->
	#button_tips_conf{
		id = 25,
		name = xmerl_ucs:to_utf8("首充"),
		macro = <<"BIN_FIRST_CHARGR">>,
		parent = 0,
		daily_refresh = 0,
		trigger = <<"">>,
		daily_one_count = 0
	};

get(26) ->
	#button_tips_conf{
		id = 26,
		name = xmerl_ucs:to_utf8("交易所"),
		macro = <<"BIN_PLAYER_SALE">>,
		parent = 0,
		daily_refresh = 0,
		trigger = <<"">>,
		daily_one_count = 0
	};

get(27) ->
	#button_tips_conf{
		id = 27,
		name = xmerl_ucs:to_utf8("领取物品"),
		macro = <<"BTN_SALE">>,
		parent = 26,
		daily_refresh = 0,
		trigger = <<"">>,
		daily_one_count = 0
	};

get(28) ->
	#button_tips_conf{
		id = 28,
		name = xmerl_ucs:to_utf8("每日签到"),
		macro = <<"BIN_SIGN">>,
		parent = 7,
		daily_refresh = 1,
		trigger = <<"">>,
		daily_one_count = 0
	};

get(29) ->
	#button_tips_conf{
		id = 29,
		name = xmerl_ucs:to_utf8("沙巴克"),
		macro = <<"BTN_SBK">>,
		parent = 0,
		daily_refresh = 0,
		trigger = <<"">>,
		daily_one_count = 0
	};

get(30) ->
	#button_tips_conf{
		id = 30,
		name = xmerl_ucs:to_utf8("沙巴克奖励信息"),
		macro = <<"BIN_SBK_REWARD">>,
		parent = 29,
		daily_refresh = 0,
		trigger = <<"">>,
		daily_one_count = 0
	};

get(31) ->
	#button_tips_conf{
		id = 31,
		name = xmerl_ucs:to_utf8("VIP按钮"),
		macro = <<"BIN_VIP_BUTTON">>,
		parent = 0,
		daily_refresh = 0,
		trigger = <<"">>,
		daily_one_count = 0
	};

get(32) ->
	#button_tips_conf{
		id = 32,
		name = <<"VIP1">>,
		macro = <<"BTN_VIP_REWARD_1">>,
		parent = 31,
		daily_refresh = 0,
		trigger = <<"">>,
		daily_one_count = 0
	};

get(33) ->
	#button_tips_conf{
		id = 33,
		name = <<"VIP2">>,
		macro = <<"BTN_VIP_REWARD_2">>,
		parent = 31,
		daily_refresh = 0,
		trigger = <<"">>,
		daily_one_count = 0
	};

get(34) ->
	#button_tips_conf{
		id = 34,
		name = <<"VIP3">>,
		macro = <<"BTN_VIP_REWARD_3">>,
		parent = 31,
		daily_refresh = 0,
		trigger = <<"">>,
		daily_one_count = 0
	};

get(35) ->
	#button_tips_conf{
		id = 35,
		name = <<"VIP4">>,
		macro = <<"BTN_VIP_REWARD_4">>,
		parent = 31,
		daily_refresh = 0,
		trigger = <<"">>,
		daily_one_count = 0
	};

get(36) ->
	#button_tips_conf{
		id = 36,
		name = <<"VIP5">>,
		macro = <<"BTN_VIP_REWARD_5">>,
		parent = 31,
		daily_refresh = 0,
		trigger = <<"">>,
		daily_one_count = 0
	};

get(37) ->
	#button_tips_conf{
		id = 37,
		name = <<"VIP6">>,
		macro = <<"BTN_VIP_REWARD_6">>,
		parent = 31,
		daily_refresh = 0,
		trigger = <<"">>,
		daily_one_count = 0
	};

get(38) ->
	#button_tips_conf{
		id = 38,
		name = <<"VIP7">>,
		macro = <<"BTN_VIP_REWARD_7">>,
		parent = 31,
		daily_refresh = 0,
		trigger = <<"">>,
		daily_one_count = 0
	};

get(39) ->
	#button_tips_conf{
		id = 39,
		name = <<"VIP8">>,
		macro = <<"BTN_VIP_REWARD_8">>,
		parent = 31,
		daily_refresh = 0,
		trigger = <<"">>,
		daily_one_count = 0
	};

get(40) ->
	#button_tips_conf{
		id = 40,
		name = <<"VIP9">>,
		macro = <<"BTN_VIP_REWARD_9">>,
		parent = 31,
		daily_refresh = 0,
		trigger = <<"">>,
		daily_one_count = 0
	};

get(41) ->
	#button_tips_conf{
		id = 41,
		name = <<"VIP10">>,
		macro = <<"BTN_VIP_REWARD_10">>,
		parent = 31,
		daily_refresh = 0,
		trigger = <<"">>,
		daily_one_count = 0
	};

get(42) ->
	#button_tips_conf{
		id = 42,
		name = <<"VIP11">>,
		macro = <<"BTN_VIP_REWARD_11">>,
		parent = 31,
		daily_refresh = 0,
		trigger = <<"">>,
		daily_one_count = 0
	};

get(43) ->
	#button_tips_conf{
		id = 43,
		name = <<"VIP12">>,
		macro = <<"BTN_VIP_REWARD_12">>,
		parent = 31,
		daily_refresh = 0,
		trigger = <<"">>,
		daily_one_count = 0
	};

get(44) ->
	#button_tips_conf{
		id = 44,
		name = <<"VIP13">>,
		macro = <<"BTN_VIP_REWARD_13">>,
		parent = 31,
		daily_refresh = 0,
		trigger = <<"">>,
		daily_one_count = 0
	};

get(45) ->
	#button_tips_conf{
		id = 45,
		name = <<"VIP14">>,
		macro = <<"BTN_VIP_REWARD_14">>,
		parent = 31,
		daily_refresh = 0,
		trigger = <<"">>,
		daily_one_count = 0
	};

get(46) ->
	#button_tips_conf{
		id = 46,
		name = <<"VIP15">>,
		macro = <<"BTN_VIP_REWARD_15">>,
		parent = 31,
		daily_refresh = 0,
		trigger = <<"">>,
		daily_one_count = 0
	};

get(47) ->
	#button_tips_conf{
		id = 47,
		name = xmerl_ucs:to_utf8("设置"),
		macro = <<"BIN_SET">>,
		parent = 0,
		daily_refresh = 0,
		trigger = <<"">>,
		daily_one_count = 0
	};

get(48) ->
	#button_tips_conf{
		id = 48,
		name = xmerl_ucs:to_utf8("自动喝药"),
		macro = <<"BIN_AUTO_DRINK">>,
		parent = 47,
		daily_refresh = 0,
		trigger = <<"">>,
		daily_one_count = 0
	};

get(49) ->
	#button_tips_conf{
		id = 49,
		name = xmerl_ucs:to_utf8("红药点"),
		macro = <<"BIN_AUTO_DRINK_RED">>,
		parent = 48,
		daily_refresh = 0,
		trigger = <<"">>,
		daily_one_count = 0
	};

get(50) ->
	#button_tips_conf{
		id = 50,
		name = xmerl_ucs:to_utf8("蓝药点"),
		macro = <<"BIN_AUTO_DRINK_BLUE">>,
		parent = 48,
		daily_refresh = 0,
		trigger = <<"">>,
		daily_one_count = 0
	};

get(51) ->
	#button_tips_conf{
		id = 51,
		name = xmerl_ucs:to_utf8("太阳水点"),
		macro = <<"BIN_AUTO_DRINK_SUN">>,
		parent = 48,
		daily_refresh = 0,
		trigger = <<"">>,
		daily_one_count = 0
	};

get(52) ->
	#button_tips_conf{
		id = 52,
		name = xmerl_ucs:to_utf8("下载奖励"),
		macro = <<"BIN_DOWNLOAD">>,
		parent = 0,
		daily_refresh = 0,
		trigger = <<"">>,
		daily_one_count = 0
	};

get(53) ->
	#button_tips_conf{
		id = 53,
		name = xmerl_ucs:to_utf8("好友"),
		macro = <<"BIN_FRIEND">>,
		parent = 23,
		daily_refresh = 0,
		trigger = <<"">>,
		daily_one_count = 0
	};

get(54) ->
	#button_tips_conf{
		id = 54,
		name = xmerl_ucs:to_utf8("仇人"),
		macro = <<"BIN_FOE">>,
		parent = 53,
		daily_refresh = 0,
		trigger = <<"">>,
		daily_one_count = 0
	};

get(55) ->
	#button_tips_conf{
		id = 55,
		name = xmerl_ucs:to_utf8("限时活动"),
		macro = <<"BIN_LIMIT_TIME_ACTIVE">>,
		parent = 1,
		daily_refresh = 0,
		trigger = <<"">>,
		daily_one_count = 0
	};

get(56) ->
	#button_tips_conf{
		id = 56,
		name = xmerl_ucs:to_utf8("未知暗殿本服每天"),
		macro = <<"BTN_ACTIVE_WZAD">>,
		parent = 55,
		daily_refresh = 0,
		trigger = <<"">>,
		daily_one_count = 0
	};

get(57) ->
	#button_tips_conf{
		id = 57,
		name = xmerl_ucs:to_utf8("屠龙大会"),
		macro = <<"BTN_ACTIVE_TLDH">>,
		parent = 55,
		daily_refresh = 0,
		trigger = <<"">>,
		daily_one_count = 0
	};

get(58) ->
	#button_tips_conf{
		id = 58,
		name = xmerl_ucs:to_utf8("胜者为王"),
		macro = <<"BTN_ACTIVE_SZWW">>,
		parent = 55,
		daily_refresh = 0,
		trigger = <<"">>,
		daily_one_count = 0
	};

get(59) ->
	#button_tips_conf{
		id = 59,
		name = xmerl_ucs:to_utf8("开服活动"),
		macro = <<"BTN_ACTIVE_SERVICE">>,
		parent = 0,
		daily_refresh = 0,
		trigger = <<"">>,
		daily_one_count = 0
	};

get(60) ->
	#button_tips_conf{
		id = 60,
		name = xmerl_ucs:to_utf8("等级活动"),
		macro = <<"BTN_ACTIVE_SERVICE_LV">>,
		parent = 59,
		daily_refresh = 0,
		trigger = <<"">>,
		daily_one_count = 0
	};

get(61) ->
	#button_tips_conf{
		id = 61,
		name = xmerl_ucs:to_utf8("战力活动"),
		macro = <<"BTN_ACTIVE_SERVICE_FIGHT">>,
		parent = 59,
		daily_refresh = 0,
		trigger = <<"">>,
		daily_one_count = 0
	};

get(62) ->
	#button_tips_conf{
		id = 62,
		name = xmerl_ucs:to_utf8("勋章活动"),
		macro = <<"BTN_ACTIVE_SERVICE_MEDAL">>,
		parent = 59,
		daily_refresh = 0,
		trigger = <<"">>,
		daily_one_count = 0
	};

get(63) ->
	#button_tips_conf{
		id = 63,
		name = xmerl_ucs:to_utf8("翅膀活动"),
		macro = <<"BTN_ACTIVE_SERVICE_WING">>,
		parent = 59,
		daily_refresh = 0,
		trigger = <<"">>,
		daily_one_count = 0
	};

get(64) ->
	#button_tips_conf{
		id = 64,
		name = xmerl_ucs:to_utf8("强化活动"),
		macro = <<"BTN_ACTIVE_SERVICE_STREN">>,
		parent = 59,
		daily_refresh = 0,
		trigger = <<"">>,
		daily_one_count = 0
	};

get(65) ->
	#button_tips_conf{
		id = 65,
		name = xmerl_ucs:to_utf8("挂机"),
		macro = <<"BTN_HOOK">>,
		parent = 14,
		daily_refresh = 1,
		trigger = <<"">>,
		daily_one_count = 0
	};

get(66) ->
	#button_tips_conf{
		id = 66,
		name = xmerl_ucs:to_utf8("挑战boss"),
		macro = <<"BTN_HOOK_BOOS">>,
		parent = 65,
		daily_refresh = 1,
		trigger = <<"">>,
		daily_one_count = 0
	};

get(67) ->
	#button_tips_conf{
		id = 67,
		name = xmerl_ucs:to_utf8("扫荡挂机"),
		macro = <<"BTN_HOOK_RAIDS">>,
		parent = 65,
		daily_refresh = 1,
		trigger = <<"">>,
		daily_one_count = 0
	};

get(68) ->
	#button_tips_conf{
		id = 68,
		name = xmerl_ucs:to_utf8("月卡奖励"),
		macro = <<"BTN_MONTH_GOODS">>,
		parent = 7,
		daily_refresh = 1,
		trigger = <<"">>,
		daily_one_count = 0
	};

get(69) ->
	#button_tips_conf{
		id = 69,
		name = xmerl_ucs:to_utf8("累积充值98元"),
		macro = <<"BTN_ACTIVE_SERVICE_CHARGE">>,
		parent = 87,
		daily_refresh = 0,
		trigger = <<"">>,
		daily_one_count = 0
	};

get(70) ->
	#button_tips_conf{
		id = 70,
		name = xmerl_ucs:to_utf8("签到按钮"),
		macro = <<"BIN_SIGN_BTN">>,
		parent = 28,
		daily_refresh = 1,
		trigger = <<"">>,
		daily_one_count = 0
	};

get(71) ->
	#button_tips_conf{
		id = 71,
		name = xmerl_ucs:to_utf8("签到奖励"),
		macro = <<"BIN_SIGN_REWARD">>,
		parent = 28,
		daily_refresh = 1,
		trigger = <<"">>,
		daily_one_count = 0
	};

get(72) ->
	#button_tips_conf{
		id = 72,
		name = xmerl_ucs:to_utf8("等级礼包"),
		macro = <<"BIN_LEVEL_REWARD">>,
		parent = 7,
		daily_refresh = 0,
		trigger = <<"">>,
		daily_one_count = 0
	};

get(73) ->
	#button_tips_conf{
		id = 73,
		name = xmerl_ucs:to_utf8("暂未用到"),
		macro = <<"BTN_ACTIVE_SERVICE_EQUIP">>,
		parent = 0,
		daily_refresh = 0,
		trigger = <<"">>,
		daily_one_count = 0
	};

get(75) ->
	#button_tips_conf{
		id = 75,
		name = xmerl_ucs:to_utf8("首杀BOSS活动"),
		macro = <<"BTN_ACTIVE_SERVICE_BOSS">>,
		parent = 87,
		daily_refresh = 0,
		trigger = <<"">>,
		daily_one_count = 0
	};

get(76) ->
	#button_tips_conf{
		id = 76,
		name = xmerl_ucs:to_utf8("角色"),
		macro = <<"BTN_ROLE">>,
		parent = 0,
		daily_refresh = 0,
		trigger = <<"">>,
		daily_one_count = 0
	};

get(77) ->
	#button_tips_conf{
		id = 77,
		name = xmerl_ucs:to_utf8("印记标签"),
		macro = <<"BTN_ROLE_STAMP">>,
		parent = 76,
		daily_refresh = 0,
		trigger = <<"">>,
		daily_one_count = 0
	};

get(78) ->
	#button_tips_conf{
		id = 78,
		name = xmerl_ucs:to_utf8("生命印记"),
		macro = <<"BTN_ROLE_STAMP_HP">>,
		parent = 77,
		daily_refresh = 0,
		trigger = <<"">>,
		daily_one_count = 0
	};

get(79) ->
	#button_tips_conf{
		id = 79,
		name = xmerl_ucs:to_utf8("攻击印记"),
		macro = <<"BTN_ROLE_STAMP_ATK">>,
		parent = 77,
		daily_refresh = 0,
		trigger = <<"">>,
		daily_one_count = 0
	};

get(80) ->
	#button_tips_conf{
		id = 80,
		name = xmerl_ucs:to_utf8("物防印记"),
		macro = <<"BTN_ROLE_STAMP_DEF">>,
		parent = 77,
		daily_refresh = 0,
		trigger = <<"">>,
		daily_one_count = 0
	};

get(81) ->
	#button_tips_conf{
		id = 81,
		name = xmerl_ucs:to_utf8("魔防印记"),
		macro = <<"BTN_ROLE_STAMP_MDEF">>,
		parent = 77,
		daily_refresh = 0,
		trigger = <<"">>,
		daily_one_count = 0
	};

get(82) ->
	#button_tips_conf{
		id = 82,
		name = xmerl_ucs:to_utf8("神圣印记"),
		macro = <<"BTN_ROLE_STAMP_HOLY">>,
		parent = 77,
		daily_refresh = 0,
		trigger = <<"">>,
		daily_one_count = 0
	};

get(83) ->
	#button_tips_conf{
		id = 83,
		name = xmerl_ucs:to_utf8("怪物攻城"),
		macro = <<"BTN_ACTIVE_MAC">>,
		parent = 55,
		daily_refresh = 0,
		trigger = <<"">>,
		daily_one_count = 0
	};

get(84) ->
	#button_tips_conf{
		id = 84,
		name = xmerl_ucs:to_utf8("行会申请按钮"),
		macro = <<"BTN_GUILD_APPLY">>,
		parent = 15,
		daily_refresh = 1,
		trigger = <<"">>,
		daily_one_count = 1
	};

get(85) ->
	#button_tips_conf{
		id = 85,
		name = xmerl_ucs:to_utf8("印记活动"),
		macro = <<"BTN_ACTIVE_SERVICE_MARK">>,
		parent = 59,
		daily_refresh = 0,
		trigger = <<"">>,
		daily_one_count = 0
	};

get(86) ->
	#button_tips_conf{
		id = 86,
		name = xmerl_ucs:to_utf8("开服排行榜"),
		macro = <<"BTN_ACTIVE_SERVICE_RANK">>,
		parent = 59,
		daily_refresh = 1,
		trigger = <<"">>,
		daily_one_count = 1
	};

get(87) ->
	#button_tips_conf{
		id = 87,
		name = xmerl_ucs:to_utf8("开服活动（里面）"),
		macro = <<"BTN_ACTIVE_SERVICE_INSIDE">>,
		parent = 59,
		daily_refresh = 0,
		trigger = <<"">>,
		daily_one_count = 0
	};

get(88) ->
	#button_tips_conf{
		id = 88,
		name = xmerl_ucs:to_utf8("限时翅膀"),
		macro = <<"BTN_LIMIT_WING">>,
		parent = 76,
		daily_refresh = 0,
		trigger = <<"">>,
		daily_one_count = 1
	};

get(89) ->
	#button_tips_conf{
		id = 89,
		name = xmerl_ucs:to_utf8("1充值送大礼"),
		macro = <<"BTN_ACTIVE_SERVICE_EXP">>,
		parent = 87,
		daily_refresh = 0,
		trigger = <<"">>,
		daily_one_count = 0
	};

get(90) ->
	#button_tips_conf{
		id = 90,
		name = xmerl_ucs:to_utf8("2强化折扣日"),
		macro = <<"BTN_ACTIVE_SERVICE_STREN_SHOP">>,
		parent = 87,
		daily_refresh = 1,
		trigger = <<"">>,
		daily_one_count = 1
	};

get(91) ->
	#button_tips_conf{
		id = 91,
		name = xmerl_ucs:to_utf8("3消耗元宝送物品"),
		macro = <<"BTN_ACTIVE_SERVICE_JADE_SELL">>,
		parent = 87,
		daily_refresh = 0,
		trigger = <<"">>,
		daily_one_count = 0
	};

get(92) ->
	#button_tips_conf{
		id = 92,
		name = xmerl_ucs:to_utf8("4神秘商店回馈"),
		macro = <<"BTN_ACTIVE_SERVICE_MYSTERY_SHOP_SELL">>,
		parent = 87,
		daily_refresh = 0,
		trigger = <<"">>,
		daily_one_count = 0
	};

get(93) ->
	#button_tips_conf{
		id = 93,
		name = xmerl_ucs:to_utf8("5印记折扣"),
		macro = <<"BTN_ACTIVE_SERVICE_MARK_SHOP">>,
		parent = 87,
		daily_refresh = 1,
		trigger = <<"">>,
		daily_one_count = 1
	};

get(94) ->
	#button_tips_conf{
		id = 94,
		name = xmerl_ucs:to_utf8("6神秘商店回馈"),
		macro = <<"BTN_ACTIVE_SERVICE_MYSTERY_SHOP_SELL_1">>,
		parent = 87,
		daily_refresh = 0,
		trigger = <<"">>,
		daily_one_count = 0
	};

get(95) ->
	#button_tips_conf{
		id = 95,
		name = xmerl_ucs:to_utf8("军团标签页"),
		macro = <<"BTN_LEGION_TAG">>,
		parent = 15,
		daily_refresh = 0,
		trigger = <<"">>,
		daily_one_count = 0
	};

get(96) ->
	#button_tips_conf{
		id = 96,
		name = xmerl_ucs:to_utf8("行会标签页"),
		macro = <<"BTN_GUIDE_TAG">>,
		parent = 15,
		daily_refresh = 0,
		trigger = <<"">>,
		daily_one_count = 0
	};

get(97) ->
	#button_tips_conf{
		id = 97,
		name = xmerl_ucs:to_utf8("军团申请红点"),
		macro = <<"BTN_LEGION_APPLY_LIST">>,
		parent = 95,
		daily_refresh = 0,
		trigger = <<"">>,
		daily_one_count = 0
	};

get(98) ->
	#button_tips_conf{
		id = 98,
		name = xmerl_ucs:to_utf8("合服总按钮"),
		macro = <<"BTN_ACTIVE_SERVICE_MERGE">>,
		parent = 0,
		daily_refresh = 0,
		trigger = <<"">>,
		daily_one_count = 0
	};

get(99) ->
	#button_tips_conf{
		id = 99,
		name = xmerl_ucs:to_utf8("合服累计充值"),
		macro = <<"BTN_ACTIVE_SERVICE_EXP_MERGE">>,
		parent = 98,
		daily_refresh = 0,
		trigger = <<"">>,
		daily_one_count = 0
	};

get(100) ->
	#button_tips_conf{
		id = 100,
		name = xmerl_ucs:to_utf8("合服 全服首杀活动"),
		macro = <<"BTN_ACTIVE_SERVICE_BOSS_MERGE">>,
		parent = 98,
		daily_refresh = 0,
		trigger = <<"">>,
		daily_one_count = 0
	};

get(101) ->
	#button_tips_conf{
		id = 101,
		name = xmerl_ucs:to_utf8("合服超值礼包商店"),
		macro = <<"BTN_ACTIVE_SERVICE_STREN_SHOP_MERGE">>,
		parent = 98,
		daily_refresh = 0,
		trigger = <<"">>,
		daily_one_count = 1
	};

get(102) ->
	#button_tips_conf{
		id = 102,
		name = xmerl_ucs:to_utf8("合服首冲"),
		macro = <<"BTN_ACTIVE_SERVICE_FRIST_PAY_MERGE">>,
		parent = 98,
		daily_refresh = 0,
		trigger = <<"">>,
		daily_one_count = 0
	};

get(103) ->
	#button_tips_conf{
		id = 103,
		name = xmerl_ucs:to_utf8("合服登录大礼"),
		macro = <<"BTN_ACTIVE_SERVICE_LOGION_MERGE">>,
		parent = 98,
		daily_refresh = 0,
		trigger = <<"">>,
		daily_one_count = 0
	};

get(104) ->
	#button_tips_conf{
		id = 104,
		name = xmerl_ucs:to_utf8("神秘暗殿时间红点2"),
		macro = <<"BTN_ACTIVE_WZAD2">>,
		parent = 55,
		daily_refresh = 0,
		trigger = <<"">>,
		daily_one_count = 0
	};

get(105) ->
	#button_tips_conf{
		id = 105,
		name = xmerl_ucs:to_utf8("胜者为王2"),
		macro = <<"BTN_ACTVE_SZWW2">>,
		parent = 55,
		daily_refresh = 0,
		trigger = <<"">>,
		daily_one_count = 0
	};

get(106) ->
	#button_tips_conf{
		id = 106,
		name = xmerl_ucs:to_utf8("未知暗殿周末"),
		macro = <<"BTN_ACTIVE_WZAD_WEEKEND">>,
		parent = 55,
		daily_refresh = 0,
		trigger = <<"">>,
		daily_one_count = 0
	};

get(107) ->
	#button_tips_conf{
		id = 107,
		name = xmerl_ucs:to_utf8("跨服暗殿每天"),
		macro = <<"BTN_ACTIVE_CROSS_WZAD">>,
		parent = 55,
		daily_refresh = 0,
		trigger = <<"">>,
		daily_one_count = 0
	};

get(108) ->
	#button_tips_conf{
		id = 108,
		name = xmerl_ucs:to_utf8("跨服暗殿周末"),
		macro = <<"BTN_ACTIVE_CROSS_WZAD_WEEKEND">>,
		parent = 55,
		daily_refresh = 0,
		trigger = <<"">>,
		daily_one_count = 0
	};

get(109) ->
	#button_tips_conf{
		id = 109,
		name = xmerl_ucs:to_utf8("全服双倍经验"),
		macro = <<"BTN_ACTIVE_DOUBLE_EXP">>,
		parent = 55,
		daily_refresh = 0,
		trigger = <<"">>,
		daily_one_count = 0
	};

get(110) ->
	#button_tips_conf{
		id = 110,
		name = xmerl_ucs:to_utf8("七天登陆"),
		macro = <<"BIN_SEVENDAYS_BTN">>,
		parent = 0,
		daily_refresh = 1,
		trigger = <<"">>,
		daily_one_count = 1
	};

get(_Key) ->
	null.