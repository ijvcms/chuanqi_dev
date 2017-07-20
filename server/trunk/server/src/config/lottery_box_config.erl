%%%-------------------------------------------------------------------
%%% @author zhengsiying
%%% @doc
%%%		自动生成文件，不要手动修改
%%% @end
%%% Created : 2016/10/12
%%%-------------------------------------------------------------------

-module(lottery_box_config).

-include("common.hrl").
-include("config.hrl").

-compile([export_all]).

get_list() ->
	[1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24].

get_group_list_conf(1) ->
	[lottery_box_config:get(1), lottery_box_config:get(2), lottery_box_config:get(3), lottery_box_config:get(4), lottery_box_config:get(5), lottery_box_config:get(6), lottery_box_config:get(7), lottery_box_config:get(8), lottery_box_config:get(9), lottery_box_config:get(10), lottery_box_config:get(11), lottery_box_config:get(12), lottery_box_config:get(13), lottery_box_config:get(14), lottery_box_config:get(15), lottery_box_config:get(16), lottery_box_config:get(17), lottery_box_config:get(18), lottery_box_config:get(19), lottery_box_config:get(20), lottery_box_config:get(21), lottery_box_config:get(22), lottery_box_config:get(23), lottery_box_config:get(24)].

get_group_list(1) ->
	[1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24];
get_group_list(_Key) ->
	[]. 
get(1) ->
	#lottery_box_conf{
		id = 1,
		group = 1,
		type = 1,
		weights = 223,
		min_num = 0,
		day_num = 0,
		server_num = 50,
		goods = [{110304,1,1}],
		is_log = 1,
		name = xmerl_ucs:to_utf8("赤炼魂石"),
		notice_info = xmerl_ucs:to_utf8("~s在神皇秘境中抽到了~s，羡煞旁人！"),
		is_notice = 1
	};

get(2) ->
	#lottery_box_conf{
		id = 2,
		group = 1,
		type = 1,
		weights = 445,
		min_num = 0,
		day_num = 0,
		server_num = 0,
		goods = [{110050,0,1}],
		is_log = 0,
		name = xmerl_ucs:to_utf8("金条"),
		notice_info = <<"">>,
		is_notice = 0
	};

get(3) ->
	#lottery_box_conf{
		id = 3,
		group = 1,
		type = 1,
		weights = 8897,
		min_num = 0,
		day_num = 0,
		server_num = 0,
		goods = [{110063,1,1}],
		is_log = 0,
		name = xmerl_ucs:to_utf8("经验丹（大）"),
		notice_info = <<"">>,
		is_notice = 0
	};

get(4) ->
	#lottery_box_conf{
		id = 4,
		group = 1,
		type = 1,
		weights = 38372,
		min_num = 0,
		day_num = 0,
		server_num = 0,
		goods = [{110064,1,1}],
		is_log = 0,
		name = xmerl_ucs:to_utf8("超级经验丹"),
		notice_info = <<"">>,
		is_notice = 0
	};

get(5) ->
	#lottery_box_conf{
		id = 5,
		group = 1,
		type = 1,
		weights = 371,
		min_num = 0,
		day_num = 0,
		server_num = 0,
		goods = [{110222,0,1}],
		is_log = 1,
		name = xmerl_ucs:to_utf8("绝世秘籍"),
		notice_info = xmerl_ucs:to_utf8("~s在神皇秘境中抽到了~s，羡煞旁人！"),
		is_notice = 1
	};

get(6) ->
	#lottery_box_conf{
		id = 6,
		group = 1,
		type = 1,
		weights = 223,
		min_num = 0,
		day_num = 0,
		server_num = 70,
		goods = [{110163,0,1}],
		is_log = 1,
		name = xmerl_ucs:to_utf8("上古神石"),
		notice_info = xmerl_ucs:to_utf8("~s在神皇秘境中抽到了~s，羡煞旁人！"),
		is_notice = 1
	};

get(7) ->
	#lottery_box_conf{
		id = 7,
		group = 1,
		type = 1,
		weights = 74,
		min_num = 0,
		day_num = 0,
		server_num = 200,
		goods = [{110294,0,1}],
		is_log = 1,
		name = xmerl_ucs:to_utf8("女娲神石"),
		notice_info = xmerl_ucs:to_utf8("~s在神皇秘境中抽到了~s，羡煞旁人！"),
		is_notice = 1
	};

get(8) ->
	#lottery_box_conf{
		id = 8,
		group = 1,
		type = 1,
		weights = 185,
		min_num = 0,
		day_num = 0,
		server_num = 0,
		goods = [{110259,0,1}],
		is_log = 1,
		name = xmerl_ucs:to_utf8("通灵神石"),
		notice_info = <<"">>,
		is_notice = 0
	};

get(9) ->
	#lottery_box_conf{
		id = 9,
		group = 1,
		type = 1,
		weights = 278,
		min_num = 0,
		day_num = 0,
		server_num = 110,
		goods = [{110104,0,1}],
		is_log = 1,
		name = xmerl_ucs:to_utf8("紫水晶+6"),
		notice_info = <<"">>,
		is_notice = 0
	};

get(10) ->
	#lottery_box_conf{
		id = 10,
		group = 1,
		type = 1,
		weights = 445,
		min_num = 0,
		day_num = 0,
		server_num = 170,
		goods = [{110095,0,1}],
		is_log = 1,
		name = xmerl_ucs:to_utf8("玄冰铁+7"),
		notice_info = xmerl_ucs:to_utf8("~s在神皇秘境中抽到了~s，羡煞旁人！"),
		is_notice = 1
	};

get(11) ->
	#lottery_box_conf{
		id = 11,
		group = 1,
		type = 1,
		weights = 1111,
		min_num = 0,
		day_num = 0,
		server_num = 0,
		goods = [{110160,0,50}],
		is_log = 0,
		name = xmerl_ucs:to_utf8("铸魂精华X50"),
		notice_info = <<"">>,
		is_notice = 0
	};

get(12) ->
	#lottery_box_conf{
		id = 12,
		group = 1,
		type = 1,
		weights = 309,
		min_num = 0,
		day_num = 0,
		server_num = 0,
		goods = [{201030,0,1},{200030,0,1},{202030,0,1}],
		is_log = 0,
		name = xmerl_ucs:to_utf8("50级武器"),
		notice_info = <<"">>,
		is_notice = 0
	};

get(13) ->
	#lottery_box_conf{
		id = 13,
		group = 1,
		type = 1,
		weights = 464,
		min_num = 0,
		day_num = 0,
		server_num = 0,
		goods = [{201031,0,1},{202031,0,1},{200031,0,1}],
		is_log = 0,
		name = xmerl_ucs:to_utf8("50级衣服"),
		notice_info = <<"">>,
		is_notice = 0
	};

get(14) ->
	#lottery_box_conf{
		id = 14,
		group = 1,
		type = 1,
		weights = 926,
		min_num = 0,
		day_num = 0,
		server_num = 0,
		goods = [{201032,0,1},{201033,0,1},{201035,0,1},{201036,0,1},{201037,0,1},{201039,0,1},{202032,0,1},{202033,0,1},{202035,0,1},{202036,0,1},{202037,0,1},{202039,0,1},{200032,0,1},{200033,0,1},{200035,0,1},{200036,0,1},{200037,0,1},{200039,0,1}],
		is_log = 0,
		name = xmerl_ucs:to_utf8("50级部件"),
		notice_info = <<"">>,
		is_notice = 0
	};

get(15) ->
	#lottery_box_conf{
		id = 15,
		group = 1,
		type = 1,
		weights = 103,
		min_num = 0,
		day_num = 0,
		server_num = 282,
		goods = [{201060,0,1},{202060,0,1},{200060,0,1}],
		is_log = 1,
		name = xmerl_ucs:to_utf8("60级武器"),
		notice_info = xmerl_ucs:to_utf8("~s在神皇秘境中抽到了~s，羡煞旁人！"),
		is_notice = 1
	};

get(16) ->
	#lottery_box_conf{
		id = 16,
		group = 1,
		type = 1,
		weights = 154,
		min_num = 0,
		day_num = 0,
		server_num = 189,
		goods = [{201061,0,1},{202061,0,1},{200061,0,1}],
		is_log = 1,
		name = xmerl_ucs:to_utf8("60级衣服"),
		notice_info = xmerl_ucs:to_utf8("~s在神皇秘境中抽到了~s，羡煞旁人！"),
		is_notice = 1
	};

get(17) ->
	#lottery_box_conf{
		id = 17,
		group = 1,
		type = 1,
		weights = 232,
		min_num = 0,
		day_num = 0,
		server_num = 126,
		goods = [{201062,0,1},{201063,0,1},{201065,0,1},{201066,0,1},{201067,0,1},{201069,0,1},{202062,0,1},{202063,0,1},{202065,0,1},{202066,0,1},{202067,0,1},{202069,0,1},{200062,0,1},{200063,0,1},{200065,0,1},{200066,0,1},{200067,0,1},{200069,0,1}],
		is_log = 1,
		name = xmerl_ucs:to_utf8("60级部件"),
		notice_info = xmerl_ucs:to_utf8("~s在神皇秘境中抽到了~s，羡煞旁人！"),
		is_notice = 1
	};

get(18) ->
	#lottery_box_conf{
		id = 18,
		group = 1,
		type = 1,
		weights = 7,
		min_num = 0,
		day_num = 0,
		server_num = 892,
		goods = [{201070,0,1},{202070,0,1},{200070,0,1}],
		is_log = 1,
		name = xmerl_ucs:to_utf8("70级武器"),
		notice_info = xmerl_ucs:to_utf8("~s在神皇秘境中抽到了~s，羡煞旁人！"),
		is_notice = 1
	};

get(19) ->
	#lottery_box_conf{
		id = 19,
		group = 1,
		type = 1,
		weights = 11,
		min_num = 0,
		day_num = 0,
		server_num = 588,
		goods = [{201071,0,1},{202071,0,1},{200071,0,1}],
		is_log = 1,
		name = xmerl_ucs:to_utf8("70级衣服"),
		notice_info = xmerl_ucs:to_utf8("~s在神皇秘境中抽到了~s，羡煞旁人！"),
		is_notice = 1
	};

get(20) ->
	#lottery_box_conf{
		id = 20,
		group = 1,
		type = 1,
		weights = 22,
		min_num = 0,
		day_num = 0,
		server_num = 314,
		goods = [{201072,0,1},{201073,0,1},{201075,0,1},{201076,0,1},{201077,0,1},{201079,0,1},{202072,0,1},{202073,0,1},{202075,0,1},{202076,0,1},{202077,0,1},{202079,0,1},{200072,0,1},{200073,0,1},{200075,0,1},{200076,0,1},{200077,0,1},{200079,0,1}],
		is_log = 1,
		name = xmerl_ucs:to_utf8("70级部件"),
		notice_info = xmerl_ucs:to_utf8("~s在神皇秘境中抽到了~s，羡煞旁人！"),
		is_notice = 1
	};

get(21) ->
	#lottery_box_conf{
		id = 21,
		group = 1,
		type = 1,
		weights = 2,
		min_num = 0,
		day_num = 0,
		server_num = 2288,
		goods = [{201080,0,1},{202080,0,1},{200080,0,1}],
		is_log = 1,
		name = xmerl_ucs:to_utf8("80级武器"),
		notice_info = xmerl_ucs:to_utf8("~s在神皇秘境中抽到了~s，羡煞旁人！"),
		is_notice = 1
	};

get(22) ->
	#lottery_box_conf{
		id = 22,
		group = 1,
		type = 1,
		weights = 4,
		min_num = 0,
		day_num = 0,
		server_num = 1522,
		goods = [{201081,0,1},{202081,0,1},{200081,0,1}],
		is_log = 1,
		name = xmerl_ucs:to_utf8("80级衣服"),
		notice_info = xmerl_ucs:to_utf8("~s在神皇秘境中抽到了~s，羡煞旁人！"),
		is_notice = 1
	};

get(23) ->
	#lottery_box_conf{
		id = 23,
		group = 1,
		type = 1,
		weights = 8,
		min_num = 0,
		day_num = 0,
		server_num = 766,
		goods = [{201082,0,1},{201083,0,1},{201085,0,1},{201086,0,1},{201087,0,1},{201089,0,1},{202082,0,1},{202083,0,1},{202085,0,1},{202086,0,1},{202087,0,1},{202089,0,1},{200082,0,1},{200083,0,1},{200085,0,1},{200086,0,1},{200087,0,1},{200089,0,1}],
		is_log = 1,
		name = xmerl_ucs:to_utf8("80级部件"),
		notice_info = xmerl_ucs:to_utf8("~s在神皇秘境中抽到了~s，羡煞旁人！"),
		is_notice = 1
	};

get(24) ->
	#lottery_box_conf{
		id = 24,
		group = 1,
		type = 1,
		weights = 23,
		min_num = 0,
		day_num = 0,
		server_num = 500,
		goods = [{110319,0,1}],
		is_log = 1,
		name = xmerl_ucs:to_utf8("幻金钥匙"),
		notice_info = xmerl_ucs:to_utf8("~s在神皇秘境中抽到了~s，羡煞旁人！")
	};

get(_Key) ->
	?ERR("undefined key from lottery_box_config ~p", [_Key]).