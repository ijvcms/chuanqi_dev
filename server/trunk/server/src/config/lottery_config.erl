%%%-------------------------------------------------------------------
%%% @author zhengsiying
%%% @doc
%%%		自动生成文件，不要手动修改
%%% @end
%%% Created : 2016/10/12
%%%-------------------------------------------------------------------

-module(lottery_config).

-include("common.hrl").
-include("config.hrl").

-compile([export_all]).

get_list() ->
	[1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32].

get_group_list_conf(1) ->
	[lottery_config:get(1), lottery_config:get(2), lottery_config:get(3), lottery_config:get(4), lottery_config:get(5), lottery_config:get(6), lottery_config:get(7), lottery_config:get(8)];
get_group_list_conf(2) ->
	[lottery_config:get(9), lottery_config:get(10), lottery_config:get(11), lottery_config:get(12), lottery_config:get(13), lottery_config:get(14), lottery_config:get(15), lottery_config:get(16)];
get_group_list_conf(3) ->
	[lottery_config:get(17), lottery_config:get(18), lottery_config:get(19), lottery_config:get(20), lottery_config:get(21), lottery_config:get(22), lottery_config:get(23), lottery_config:get(24)];
get_group_list_conf(4) ->
	[lottery_config:get(25), lottery_config:get(26), lottery_config:get(27), lottery_config:get(28), lottery_config:get(29), lottery_config:get(30), lottery_config:get(31), lottery_config:get(32)].

get_group_list(1) ->
	[1, 2, 3, 4, 5, 6, 7, 8];
get_group_list(2) ->
	[9, 10, 11, 12, 13, 14, 15, 16];
get_group_list(3) ->
	[17, 18, 19, 20, 21, 22, 23, 24];
get_group_list(4) ->
	[25, 26, 27, 28, 29, 30, 31, 32];
get_group_list(_Key) ->
	[]. 
get(1) ->
	#lottery_conf{
		id = 1,
		group = 1,
		weights = 200,
		min_num = 0,
		day_num = 0,
		server_num = 0,
		goods = [{110219,0,1}],
		is_log = 0,
		name = xmerl_ucs:to_utf8("超级经验丹*1"),
		notice_info = <<"">>,
		is_notice = 0
	};

get(2) ->
	#lottery_conf{
		id = 2,
		group = 1,
		weights = 60,
		min_num = 0,
		day_num = 0,
		server_num = 0,
		goods = [{110088,0,1}],
		is_log = 1,
		name = xmerl_ucs:to_utf8("黑铁矿+10*1"),
		notice_info = <<"">>,
		is_notice = 0
	};

get(3) ->
	#lottery_conf{
		id = 3,
		group = 1,
		weights = 75,
		min_num = 0,
		day_num = 0,
		server_num = 0,
		goods = [{110091,0,1}],
		is_log = 1,
		name = xmerl_ucs:to_utf8("玄冰铁+3*1"),
		notice_info = <<"">>,
		is_notice = 0
	};

get(4) ->
	#lottery_conf{
		id = 4,
		group = 1,
		weights = 150,
		min_num = 0,
		day_num = 0,
		server_num = 0,
		goods = [{110160,0,2}],
		is_log = 0,
		name = xmerl_ucs:to_utf8("铸魂精华*2"),
		notice_info = <<"">>,
		is_notice = 0
	};

get(5) ->
	#lottery_conf{
		id = 5,
		group = 1,
		weights = 1,
		min_num = 100,
		day_num = 0,
		server_num = 211,
		goods = [{110147,0,1}],
		is_log = 1,
		name = xmerl_ucs:to_utf8("超级祝福油*1"),
		notice_info = xmerl_ucs:to_utf8("可喜可贺，~s在幸运大转盘中抽到了~s，令人羡慕不已！"),
		is_notice = 1
	};

get(6) ->
	#lottery_conf{
		id = 6,
		group = 1,
		weights = 60,
		min_num = 0,
		day_num = 0,
		server_num = 0,
		goods = [{110050,0,1}],
		is_log = 1,
		name = xmerl_ucs:to_utf8("金砖*1"),
		notice_info = <<"">>,
		is_notice = 0
	};

get(7) ->
	#lottery_conf{
		id = 7,
		group = 1,
		weights = 150,
		min_num = 0,
		day_num = 0,
		server_num = 0,
		goods = [{110193,0,4}],
		is_log = 0,
		name = xmerl_ucs:to_utf8("万年雪参*4"),
		notice_info = <<"">>,
		is_notice = 0
	};

get(8) ->
	#lottery_conf{
		id = 8,
		group = 1,
		weights = 2,
		min_num = 50,
		day_num = 0,
		server_num = 60,
		goods = [{110109,0,1}],
		is_log = 1,
		name = xmerl_ucs:to_utf8("金刚石*1"),
		notice_info = xmerl_ucs:to_utf8("可喜可贺，~s在幸运大转盘中抽到了~s，令人羡慕不已！"),
		is_notice = 1
	};

get(9) ->
	#lottery_conf{
		id = 9,
		group = 2,
		weights = 90,
		min_num = 0,
		day_num = 0,
		server_num = 0,
		goods = [{110194,0,2}],
		is_log = 0,
		name = xmerl_ucs:to_utf8("疗伤药*2"),
		notice_info = <<"">>,
		is_notice = 0
	};

get(10) ->
	#lottery_conf{
		id = 10,
		group = 2,
		weights = 75,
		min_num = 0,
		day_num = 0,
		server_num = 0,
		goods = [{110160,0,5}],
		is_log = 1,
		name = xmerl_ucs:to_utf8("铸魂精华*5"),
		notice_info = <<"">>,
		is_notice = 0
	};

get(11) ->
	#lottery_conf{
		id = 11,
		group = 2,
		weights = 75,
		min_num = 0,
		day_num = 0,
		server_num = 0,
		goods = [{110091,0,1}],
		is_log = 1,
		name = xmerl_ucs:to_utf8("玄冰铁+3*1"),
		notice_info = <<"">>,
		is_notice = 0
	};

get(12) ->
	#lottery_conf{
		id = 12,
		group = 2,
		weights = 50,
		min_num = 0,
		day_num = 0,
		server_num = 0,
		goods = [{110100,0,1}],
		is_log = 1,
		name = xmerl_ucs:to_utf8("紫水晶+2*1"),
		notice_info = <<"">>,
		is_notice = 0
	};

get(13) ->
	#lottery_conf{
		id = 13,
		group = 2,
		weights = 80,
		min_num = 0,
		day_num = 0,
		server_num = 0,
		goods = [{110260,0,1}],
		is_log = 0,
		name = xmerl_ucs:to_utf8("通灵水晶"),
		notice_info = <<"">>,
		is_notice = 0
	};

get(14) ->
	#lottery_conf{
		id = 14,
		group = 2,
		weights = 1,
		min_num = 100,
		day_num = 0,
		server_num = 131,
		goods = [{110147,0,1}],
		is_log = 1,
		name = xmerl_ucs:to_utf8("超级祝福油*1"),
		notice_info = xmerl_ucs:to_utf8("可喜可贺，~s在幸运大转盘中抽到了~s，令人羡慕不已！"),
		is_notice = 1
	};

get(15) ->
	#lottery_conf{
		id = 15,
		group = 2,
		weights = 2,
		min_num = 0,
		day_num = 0,
		server_num = 20,
		goods = [{110109,0,1}],
		is_log = 1,
		name = xmerl_ucs:to_utf8("金刚石*1"),
		notice_info = xmerl_ucs:to_utf8("可喜可贺，~s在幸运大转盘中抽到了~s，令人羡慕不已！"),
		is_notice = 1
	};

get(16) ->
	#lottery_conf{
		id = 16,
		group = 2,
		weights = 1,
		min_num = 50,
		day_num = 0,
		server_num = 89,
		goods = [{110163,0,1}],
		is_log = 1,
		name = xmerl_ucs:to_utf8("上古神石*1"),
		notice_info = xmerl_ucs:to_utf8("可喜可贺，~s在幸运大转盘中抽到了~s，令人羡慕不已！"),
		is_notice = 1
	};

get(17) ->
	#lottery_conf{
		id = 17,
		group = 3,
		weights = 90,
		min_num = 0,
		day_num = 0,
		server_num = 0,
		goods = [{110194,0,2}],
		is_log = 0,
		name = xmerl_ucs:to_utf8("疗伤药*2"),
		notice_info = <<"">>,
		is_notice = 0
	};

get(18) ->
	#lottery_conf{
		id = 18,
		group = 3,
		weights = 75,
		min_num = 0,
		day_num = 0,
		server_num = 0,
		goods = [{110160,0,5}],
		is_log = 1,
		name = xmerl_ucs:to_utf8("铸魂精华*5"),
		notice_info = <<"">>,
		is_notice = 0
	};

get(19) ->
	#lottery_conf{
		id = 19,
		group = 3,
		weights = 75,
		min_num = 0,
		day_num = 0,
		server_num = 0,
		goods = [{110091,0,1}],
		is_log = 1,
		name = xmerl_ucs:to_utf8("玄冰铁+3*1"),
		notice_info = <<"">>,
		is_notice = 0
	};

get(20) ->
	#lottery_conf{
		id = 20,
		group = 3,
		weights = 50,
		min_num = 0,
		day_num = 0,
		server_num = 0,
		goods = [{110100,0,1}],
		is_log = 1,
		name = xmerl_ucs:to_utf8("紫水晶+2*1"),
		notice_info = <<"">>,
		is_notice = 0
	};

get(21) ->
	#lottery_conf{
		id = 21,
		group = 3,
		weights = 80,
		min_num = 0,
		day_num = 0,
		server_num = 0,
		goods = [{110260,0,1}],
		is_log = 0,
		name = xmerl_ucs:to_utf8("通灵水晶"),
		notice_info = <<"">>,
		is_notice = 0
	};

get(22) ->
	#lottery_conf{
		id = 22,
		group = 3,
		weights = 1,
		min_num = 100,
		day_num = 0,
		server_num = 131,
		goods = [{110147,0,1}],
		is_log = 1,
		name = xmerl_ucs:to_utf8("超级祝福油*1"),
		notice_info = xmerl_ucs:to_utf8("可喜可贺，~s在幸运大转盘中抽到了~s，令人羡慕不已！"),
		is_notice = 1
	};

get(23) ->
	#lottery_conf{
		id = 23,
		group = 3,
		weights = 2,
		min_num = 0,
		day_num = 0,
		server_num = 20,
		goods = [{110109,0,1}],
		is_log = 1,
		name = xmerl_ucs:to_utf8("金刚石*1"),
		notice_info = xmerl_ucs:to_utf8("可喜可贺，~s在幸运大转盘中抽到了~s，令人羡慕不已！"),
		is_notice = 1
	};

get(24) ->
	#lottery_conf{
		id = 24,
		group = 3,
		weights = 1,
		min_num = 50,
		day_num = 0,
		server_num = 89,
		goods = [{110163,0,1}],
		is_log = 1,
		name = xmerl_ucs:to_utf8("上古神石*1"),
		notice_info = xmerl_ucs:to_utf8("可喜可贺，~s在幸运大转盘中抽到了~s，令人羡慕不已！"),
		is_notice = 1
	};

get(25) ->
	#lottery_conf{
		id = 25,
		group = 4,
		weights = 70,
		min_num = 0,
		day_num = 0,
		server_num = 0,
		goods = [{110260,0,2}],
		is_log = 0,
		name = xmerl_ucs:to_utf8("通灵水晶*2"),
		notice_info = <<"">>,
		is_notice = 0
	};

get(26) ->
	#lottery_conf{
		id = 26,
		group = 4,
		weights = 110,
		min_num = 0,
		day_num = 0,
		server_num = 0,
		goods = [{110160,0,5}],
		is_log = 1,
		name = xmerl_ucs:to_utf8("铸魂精华*5"),
		notice_info = <<"">>,
		is_notice = 0
	};

get(27) ->
	#lottery_conf{
		id = 27,
		group = 4,
		weights = 95,
		min_num = 0,
		day_num = 0,
		server_num = 0,
		goods = [{110091,0,1}],
		is_log = 1,
		name = xmerl_ucs:to_utf8("玄冰铁+3*1"),
		notice_info = <<"">>,
		is_notice = 0
	};

get(28) ->
	#lottery_conf{
		id = 28,
		group = 4,
		weights = 95,
		min_num = 0,
		day_num = 0,
		server_num = 0,
		goods = [{110100,0,1}],
		is_log = 1,
		name = xmerl_ucs:to_utf8("紫水晶+2*1"),
		notice_info = <<"">>,
		is_notice = 0
	};

get(29) ->
	#lottery_conf{
		id = 29,
		group = 4,
		weights = 1,
		min_num = 70,
		day_num = 0,
		server_num = 110,
		goods = [{110294,0,1}],
		is_log = 0,
		name = xmerl_ucs:to_utf8("女娲神石"),
		notice_info = xmerl_ucs:to_utf8("可喜可贺，~s在幸运大转盘中抽到了~s，令人羡慕不已！"),
		is_notice = 1
	};

get(30) ->
	#lottery_conf{
		id = 30,
		group = 4,
		weights = 1,
		min_num = 100,
		day_num = 0,
		server_num = 131,
		goods = [{110147,0,1}],
		is_log = 1,
		name = xmerl_ucs:to_utf8("超级幸运油*1"),
		notice_info = xmerl_ucs:to_utf8("可喜可贺，~s在幸运大转盘中抽到了~s，令人羡慕不已！"),
		is_notice = 1
	};

get(31) ->
	#lottery_conf{
		id = 31,
		group = 4,
		weights = 2,
		min_num = 0,
		day_num = 0,
		server_num = 20,
		goods = [{110109,0,1}],
		is_log = 1,
		name = xmerl_ucs:to_utf8("金刚石*1"),
		notice_info = xmerl_ucs:to_utf8("可喜可贺，~s在幸运大转盘中抽到了~s，令人羡慕不已！"),
		is_notice = 1
	};

get(32) ->
	#lottery_conf{
		id = 32,
		group = 4,
		weights = 1,
		min_num = 50,
		day_num = 0,
		server_num = 89,
		goods = [{110163,0,1}],
		is_log = 1,
		name = xmerl_ucs:to_utf8("上古神石*1"),
		notice_info = xmerl_ucs:to_utf8("可喜可贺，~s在幸运大转盘中抽到了~s，令人羡慕不已！"),
		is_notice = 1
	};

get(_Key) ->
	?ERR("undefined key from lottery_config ~p", [_Key]).