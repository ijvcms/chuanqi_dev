%%%-------------------------------------------------------------------
%%% @author zhengsiying
%%% @doc
%%%		自动生成文件，不要手动修改
%%% @end
%%% Created : 2016/10/12
%%%-------------------------------------------------------------------

-module(mail_config).

-include("common.hrl").
-include("config.hrl").

-compile([export_all]).

get_list_conf() ->
	[ mail_config:get(X) || X <- get_list() ].

get_list() ->
	[7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32, 33, 34, 35, 36, 37, 38, 39, 40, 41, 42, 43, 44, 45, 46, 47, 48, 49, 50, 51, 52, 53, 54, 55, 56, 57, 58, 59, 60, 61, 62, 63, 64, 65, 66, 67, 68, 69, 70, 71, 72, 73, 74, 75, 76, 77, 78, 79, 80, 81, 82, 83, 84, 85, 86, 87, 88, 89, 90, 91, 92, 93, 94, 95, 96, 97, 98, 99, 100, 101, 102, 103, 104, 105, 106, 107, 108, 109, 110, 111, 112, 113, 114, 115, 116, 117, 118, 119, 120, 121, 122, 123, 124, 125, 126, 127, 128].

get(7) ->
	#mail_conf{
		id = 7,
		mail_type = 0,
		sender = xmerl_ucs:to_utf8("系统"),
		title = xmerl_ucs:to_utf8("竞技场排名奖励"),
		content = xmerl_ucs:to_utf8("今日竞技场排名奖励，请查收附件"),
		award = [{110059,1,300},{110009,1,20000},{110003,1,6}],
		active_time = 999999,
		update_time = <<"2015-10-13T09:06:47.000">>
	};

get(8) ->
	#mail_conf{
		id = 8,
		mail_type = 0,
		sender = xmerl_ucs:to_utf8("系统"),
		title = xmerl_ucs:to_utf8("竞技场排名奖励"),
		content = xmerl_ucs:to_utf8("今日竞技场排名奖励，请查收附件"),
		award = [{110059,1,150},{110009,1,10000},{110003,1,4}],
		active_time = 999999,
		update_time = <<"2015-10-13T09:06:47.000">>
	};

get(9) ->
	#mail_conf{
		id = 9,
		mail_type = 0,
		sender = xmerl_ucs:to_utf8("系统"),
		title = xmerl_ucs:to_utf8("竞技场排名奖励"),
		content = xmerl_ucs:to_utf8("今日竞技场排名奖励，请查收附件"),
		award = [{110059,1,100},{110009,1,5000},{110003,1,4}],
		active_time = 999999,
		update_time = <<"2015-10-13T09:06:47.000">>
	};

get(10) ->
	#mail_conf{
		id = 10,
		mail_type = 0,
		sender = xmerl_ucs:to_utf8("系统"),
		title = xmerl_ucs:to_utf8("竞技场排名奖励"),
		content = xmerl_ucs:to_utf8("今日竞技场排名奖励，请查收附件"),
		award = [{110059,1,90},{110009,1,5000},{110003,1,2}],
		active_time = 999999,
		update_time = <<"2015-10-13T09:06:47.000">>
	};

get(11) ->
	#mail_conf{
		id = 11,
		mail_type = 0,
		sender = xmerl_ucs:to_utf8("系统"),
		title = xmerl_ucs:to_utf8("竞技场排名奖励"),
		content = xmerl_ucs:to_utf8("今日竞技场排名奖励，请查收附件"),
		award = [{110059,1,80},{110009,1,5000},{110003,1,2}],
		active_time = 999999,
		update_time = <<"2015-10-13T09:06:47.000">>
	};

get(12) ->
	#mail_conf{
		id = 12,
		mail_type = 0,
		sender = xmerl_ucs:to_utf8("系统"),
		title = xmerl_ucs:to_utf8("竞技场排名奖励"),
		content = xmerl_ucs:to_utf8("今日竞技场排名奖励，请查收附件"),
		award = [{110059,1,70},{110009,1,5000},{110003,1,1}],
		active_time = 999999,
		update_time = <<"2015-10-13T09:06:47.000">>
	};

get(13) ->
	#mail_conf{
		id = 13,
		mail_type = 0,
		sender = xmerl_ucs:to_utf8("系统"),
		title = xmerl_ucs:to_utf8("竞技场排名奖励"),
		content = xmerl_ucs:to_utf8("今日竞技场排名奖励，请查收附件"),
		award = [{110059,1,60},{110009,1,5000},{110003,1,1}],
		active_time = 999999,
		update_time = <<"2015-10-13T09:06:47.000">>
	};

get(14) ->
	#mail_conf{
		id = 14,
		mail_type = 0,
		sender = xmerl_ucs:to_utf8("系统"),
		title = xmerl_ucs:to_utf8("竞技场排名奖励"),
		content = xmerl_ucs:to_utf8("今日竞技场排名奖励，请查收附件"),
		award = [{110059,1,50},{110009,1,5000},{110003,1,1}],
		active_time = 999999,
		update_time = <<"2015-10-13T09:06:47.000">>
	};

get(15) ->
	#mail_conf{
		id = 15,
		mail_type = 0,
		sender = xmerl_ucs:to_utf8("系统"),
		title = xmerl_ucs:to_utf8("最后一击奖励"),
		content = xmerl_ucs:to_utf8("恭喜你获得屠龙大会的【最后一击】奖励。奖励如下："),
		award = [{110009,1,100000},{110078,1,20}],
		active_time = 999999,
		update_time = <<"2016-03-07T00:00:00.000">>
	};

get(16) ->
	#mail_conf{
		id = 16,
		mail_type = 0,
		sender = xmerl_ucs:to_utf8("系统"),
		title = xmerl_ucs:to_utf8("击杀参与奖"),
		content = xmerl_ucs:to_utf8("恭喜你获得屠龙大会的【参与击杀】奖励。奖励如下："),
		award = [{110009,1,50000},{110078,1,10}],
		active_time = 999999,
		update_time = <<"2016-03-07T00:00:00.000">>
	};

get(17) ->
	#mail_conf{
		id = 17,
		mail_type = 0,
		sender = xmerl_ucs:to_utf8("系统"),
		title = xmerl_ucs:to_utf8("输出排行奖励1"),
		content = xmerl_ucs:to_utf8("恭喜你在击杀至尊魔龙时输出排行第1名，奖励如下："),
		award = [{110130,1,1},{110057,1,300000},{110013,1,4}],
		active_time = 999999,
		update_time = <<"2016-03-07T00:00:00.000">>
	};

get(18) ->
	#mail_conf{
		id = 18,
		mail_type = 0,
		sender = xmerl_ucs:to_utf8("系统"),
		title = xmerl_ucs:to_utf8("输出排行奖励2"),
		content = xmerl_ucs:to_utf8("恭喜你在击杀至尊魔龙时输出排行第2名，奖励如下："),
		award = [{110130,1,1},{110057,1,250000},{110013,1,3}],
		active_time = 999999,
		update_time = <<"2016-03-07T00:00:00.000">>
	};

get(19) ->
	#mail_conf{
		id = 19,
		mail_type = 0,
		sender = xmerl_ucs:to_utf8("系统"),
		title = xmerl_ucs:to_utf8("输出排行奖励3"),
		content = xmerl_ucs:to_utf8("恭喜你在击杀至尊魔龙时输出排行第3名，奖励如下："),
		award = [{110130,1,1},{110057,1,200000},{110013,1,2}],
		active_time = 999999,
		update_time = <<"2016-03-07T00:00:00.000">>
	};

get(20) ->
	#mail_conf{
		id = 20,
		mail_type = 0,
		sender = xmerl_ucs:to_utf8("系统"),
		title = xmerl_ucs:to_utf8("输出排行奖励4"),
		content = xmerl_ucs:to_utf8("恭喜你在击杀至尊魔龙时输出排行第4-5名，奖励如下："),
		award = [{110129,1,3},{110057,1,180000},{110013,1,1}],
		active_time = 999999,
		update_time = <<"2016-03-07T00:00:00.000">>
	};

get(21) ->
	#mail_conf{
		id = 21,
		mail_type = 0,
		sender = xmerl_ucs:to_utf8("系统"),
		title = xmerl_ucs:to_utf8("输出排行奖励"),
		content = xmerl_ucs:to_utf8("恭喜你在击杀至尊魔龙时输出排行第6-10名，奖励如下："),
		award = [{110129,1,2},{110057,1,150000},{110013,1,1}],
		active_time = 999999,
		update_time = <<"2016-03-07T00:00:00.000">>
	};

get(22) ->
	#mail_conf{
		id = 22,
		mail_type = 0,
		sender = xmerl_ucs:to_utf8("系统"),
		title = xmerl_ucs:to_utf8("输出排行奖励"),
		content = xmerl_ucs:to_utf8("恭喜你在击杀至尊魔龙时输出排行第10-50名，奖励如下："),
		award = [{110129,1,1},{110057,1,130000},{110013,1,1}],
		active_time = 999999,
		update_time = <<"2016-03-07T00:00:00.000">>
	};

get(23) ->
	#mail_conf{
		id = 23,
		mail_type = 0,
		sender = xmerl_ucs:to_utf8("系统"),
		title = xmerl_ucs:to_utf8("输出排行奖励"),
		content = xmerl_ucs:to_utf8("恭喜你在击杀至尊魔龙时输出排行第50名以后，奖励如下："),
		award = [{110128,1,1},{110009,1,100000}],
		active_time = 999999,
		update_time = <<"2016-03-07T00:00:00.000">>
	};

get(24) ->
	#mail_conf{
		id = 24,
		mail_type = 0,
		sender = xmerl_ucs:to_utf8("系统"),
		title = xmerl_ucs:to_utf8("胜者为王排名奖励"),
		content = xmerl_ucs:to_utf8("恭喜你在胜者为王排行第1名，奖励如下："),
		award = [{110065,1,1000},{110009,1,100000}],
		active_time = 999999,
		update_time = <<"2016-03-07T00:00:00.000">>
	};

get(25) ->
	#mail_conf{
		id = 25,
		mail_type = 0,
		sender = xmerl_ucs:to_utf8("系统"),
		title = xmerl_ucs:to_utf8("胜者为王排名奖励"),
		content = xmerl_ucs:to_utf8("恭喜你在胜者为王排行第2名，奖励如下："),
		award = [{110065,1,800},{110009,1,50000}],
		active_time = 999999,
		update_time = <<"2016-03-07T00:00:00.000">>
	};

get(26) ->
	#mail_conf{
		id = 26,
		mail_type = 0,
		sender = xmerl_ucs:to_utf8("系统"),
		title = xmerl_ucs:to_utf8("胜者为王排名奖励"),
		content = xmerl_ucs:to_utf8("恭喜你在胜者为王排行第3名，奖励如下："),
		award = [{110065,1,600},{110009,1,30000}],
		active_time = 999999,
		update_time = <<"2016-03-07T00:00:00.000">>
	};

get(27) ->
	#mail_conf{
		id = 27,
		mail_type = 0,
		sender = xmerl_ucs:to_utf8("系统"),
		title = xmerl_ucs:to_utf8("胜者为王排名奖励"),
		content = xmerl_ucs:to_utf8("恭喜你在胜者为王排行第4-5名，奖励如下："),
		award = [{110065,1,400},{110009,1,20000}],
		active_time = 999999,
		update_time = <<"2016-03-07T00:00:00.000">>
	};

get(28) ->
	#mail_conf{
		id = 28,
		mail_type = 0,
		sender = xmerl_ucs:to_utf8("系统"),
		title = xmerl_ucs:to_utf8("胜者为王排名奖励"),
		content = xmerl_ucs:to_utf8("恭喜你在胜者为王排行第6-10名，奖励如下："),
		award = [{110065,1,300},{110009,1,20000}],
		active_time = 999999,
		update_time = <<"2016-03-07T00:00:00.000">>
	};

get(29) ->
	#mail_conf{
		id = 29,
		mail_type = 0,
		sender = xmerl_ucs:to_utf8("系统"),
		title = xmerl_ucs:to_utf8("胜者为王排名奖励"),
		content = xmerl_ucs:to_utf8("恭喜你在胜者为王排行第11-50名，奖励如下："),
		award = [{110065,1,200},{110009,1,20000}],
		active_time = 999999,
		update_time = <<"2016-03-07T00:00:00.000">>
	};

get(30) ->
	#mail_conf{
		id = 30,
		mail_type = 0,
		sender = xmerl_ucs:to_utf8("系统"),
		title = xmerl_ucs:to_utf8("胜者为王排名奖励"),
		content = xmerl_ucs:to_utf8("恭喜你在胜者为王排行第50名以后，奖励如下："),
		award = [{110065,1,200},{110009,1,10000}],
		active_time = 999999,
		update_time = <<"2016-03-07T00:00:00.000">>
	};

get(31) ->
	#mail_conf{
		id = 31,
		mail_type = 0,
		sender = xmerl_ucs:to_utf8("系统"),
		title = xmerl_ucs:to_utf8("输出排行奖励1"),
		content = xmerl_ucs:to_utf8("恭喜你在击杀至尊魔龙时输出排行第1名，奖励如下："),
		award = [{110130,1,1},{110057,1,350000},{110013,1,4}],
		active_time = 999999,
		update_time = <<"2016-03-07T00:00:00.000">>
	};

get(32) ->
	#mail_conf{
		id = 32,
		mail_type = 0,
		sender = xmerl_ucs:to_utf8("系统"),
		title = xmerl_ucs:to_utf8("输出排行奖励2"),
		content = xmerl_ucs:to_utf8("恭喜你在击杀至尊魔龙时输出排行第2名，奖励如下："),
		award = [{110130,1,1},{110057,1,300000},{110013,1,3}],
		active_time = 999999,
		update_time = <<"2016-03-07T00:00:00.000">>
	};

get(33) ->
	#mail_conf{
		id = 33,
		mail_type = 0,
		sender = xmerl_ucs:to_utf8("系统"),
		title = xmerl_ucs:to_utf8("输出排行奖励3"),
		content = xmerl_ucs:to_utf8("恭喜你在击杀至尊魔龙时输出排行第3名，奖励如下："),
		award = [{110130,1,1},{110057,1,250000},{110013,1,2}],
		active_time = 999999,
		update_time = <<"2016-03-07T00:00:00.000">>
	};

get(34) ->
	#mail_conf{
		id = 34,
		mail_type = 0,
		sender = xmerl_ucs:to_utf8("系统"),
		title = xmerl_ucs:to_utf8("输出排行奖励4"),
		content = xmerl_ucs:to_utf8("恭喜你在击杀至尊魔龙时输出排行第4-5名，奖励如下："),
		award = [{110129,1,3},{110057,1,230000},{110013,1,1}],
		active_time = 999999,
		update_time = <<"2016-03-07T00:00:00.000">>
	};

get(35) ->
	#mail_conf{
		id = 35,
		mail_type = 0,
		sender = xmerl_ucs:to_utf8("系统"),
		title = xmerl_ucs:to_utf8("输出排行奖励"),
		content = xmerl_ucs:to_utf8("恭喜你在击杀至尊魔龙时输出排行第6-10名，奖励如下："),
		award = [{110129,1,2},{110057,1,200000},{110013,1,1}],
		active_time = 999999,
		update_time = <<"2016-03-07T00:00:00.000">>
	};

get(36) ->
	#mail_conf{
		id = 36,
		mail_type = 0,
		sender = xmerl_ucs:to_utf8("系统"),
		title = xmerl_ucs:to_utf8("输出排行奖励"),
		content = xmerl_ucs:to_utf8("恭喜你在击杀至尊魔龙时输出排行第10-50名，奖励如下："),
		award = [{110129,1,1},{110057,1,180000},{110013,1,1}],
		active_time = 999999,
		update_time = <<"2016-03-07T00:00:00.000">>
	};

get(37) ->
	#mail_conf{
		id = 37,
		mail_type = 0,
		sender = xmerl_ucs:to_utf8("系统"),
		title = xmerl_ucs:to_utf8("输出排行奖励"),
		content = xmerl_ucs:to_utf8("恭喜你在击杀至尊魔龙时输出排行第50名以后，奖励如下："),
		award = [{110128,1,1},{110009,1,150000}],
		active_time = 999999,
		update_time = <<"2016-03-07T00:00:00.000">>
	};

get(38) ->
	#mail_conf{
		id = 38,
		mail_type = 0,
		sender = xmerl_ucs:to_utf8("系统"),
		title = xmerl_ucs:to_utf8("输出排行奖励1"),
		content = xmerl_ucs:to_utf8("恭喜你在击杀至尊魔龙时输出排行第1名，奖励如下："),
		award = [{110130,1,1},{110057,1,400000},{110013,1,4}],
		active_time = 999999,
		update_time = <<"2016-03-07T00:00:00.000">>
	};

get(39) ->
	#mail_conf{
		id = 39,
		mail_type = 0,
		sender = xmerl_ucs:to_utf8("系统"),
		title = xmerl_ucs:to_utf8("输出排行奖励2"),
		content = xmerl_ucs:to_utf8("恭喜你在击杀至尊魔龙时输出排行第2名，奖励如下："),
		award = [{110130,1,1},{110057,1,350000},{110013,1,3}],
		active_time = 999999,
		update_time = <<"2016-03-07T00:00:00.000">>
	};

get(40) ->
	#mail_conf{
		id = 40,
		mail_type = 0,
		sender = xmerl_ucs:to_utf8("系统"),
		title = xmerl_ucs:to_utf8("输出排行奖励3"),
		content = xmerl_ucs:to_utf8("恭喜你在击杀至尊魔龙时输出排行第3名，奖励如下："),
		award = [{110130,1,1},{110057,1,300000},{110013,1,2}],
		active_time = 999999,
		update_time = <<"2016-03-07T00:00:00.000">>
	};

get(41) ->
	#mail_conf{
		id = 41,
		mail_type = 0,
		sender = xmerl_ucs:to_utf8("系统"),
		title = xmerl_ucs:to_utf8("输出排行奖励4"),
		content = xmerl_ucs:to_utf8("恭喜你在击杀至尊魔龙时输出排行第4-5名，奖励如下："),
		award = [{110129,1,3},{110057,1,280000},{110013,1,1}],
		active_time = 999999,
		update_time = <<"2016-03-07T00:00:00.000">>
	};

get(42) ->
	#mail_conf{
		id = 42,
		mail_type = 0,
		sender = xmerl_ucs:to_utf8("系统"),
		title = xmerl_ucs:to_utf8("输出排行奖励"),
		content = xmerl_ucs:to_utf8("恭喜你在击杀至尊魔龙时输出排行第6-10名，奖励如下："),
		award = [{110129,1,2},{110057,1,250000},{110013,1,1}],
		active_time = 999999,
		update_time = <<"2016-03-07T00:00:00.000">>
	};

get(43) ->
	#mail_conf{
		id = 43,
		mail_type = 0,
		sender = xmerl_ucs:to_utf8("系统"),
		title = xmerl_ucs:to_utf8("输出排行奖励"),
		content = xmerl_ucs:to_utf8("恭喜你在击杀至尊魔龙时输出排行第10-50名，奖励如下："),
		award = [{110129,1,1},{110057,1,230000},{110013,1,1}],
		active_time = 999999,
		update_time = <<"2016-03-07T00:00:00.000">>
	};

get(44) ->
	#mail_conf{
		id = 44,
		mail_type = 0,
		sender = xmerl_ucs:to_utf8("系统"),
		title = xmerl_ucs:to_utf8("输出排行奖励"),
		content = xmerl_ucs:to_utf8("恭喜你在击杀至尊魔龙时输出排行第50名以后，奖励如下："),
		award = [{110128,1,1},{110009,1,200000}],
		active_time = 999999,
		update_time = <<"2016-03-07T00:00:00.000">>
	};

get(45) ->
	#mail_conf{
		id = 45,
		mail_type = 0,
		sender = xmerl_ucs:to_utf8("系统"),
		title = xmerl_ucs:to_utf8("输出排行奖励1"),
		content = xmerl_ucs:to_utf8("恭喜你在击杀至尊魔龙时输出排行第1名，奖励如下："),
		award = [{110130,1,1},{110057,1,450000},{110013,1,4}],
		active_time = 999999,
		update_time = <<"2016-03-07T00:00:00.000">>
	};

get(46) ->
	#mail_conf{
		id = 46,
		mail_type = 0,
		sender = xmerl_ucs:to_utf8("系统"),
		title = xmerl_ucs:to_utf8("输出排行奖励2"),
		content = xmerl_ucs:to_utf8("恭喜你在击杀至尊魔龙时输出排行第2名，奖励如下："),
		award = [{110130,1,1},{110057,1,400000},{110013,1,3}],
		active_time = 999999,
		update_time = <<"2016-03-07T00:00:00.000">>
	};

get(47) ->
	#mail_conf{
		id = 47,
		mail_type = 0,
		sender = xmerl_ucs:to_utf8("系统"),
		title = xmerl_ucs:to_utf8("输出排行奖励3"),
		content = xmerl_ucs:to_utf8("恭喜你在击杀至尊魔龙时输出排行第3名，奖励如下："),
		award = [{110130,1,1},{110057,1,350000},{110013,1,2}],
		active_time = 999999,
		update_time = <<"2016-03-07T00:00:00.000">>
	};

get(48) ->
	#mail_conf{
		id = 48,
		mail_type = 0,
		sender = xmerl_ucs:to_utf8("系统"),
		title = xmerl_ucs:to_utf8("输出排行奖励4"),
		content = xmerl_ucs:to_utf8("恭喜你在击杀至尊魔龙时输出排行第4-5名，奖励如下："),
		award = [{110129,1,3},{110057,1,330000},{110013,1,1}],
		active_time = 999999,
		update_time = <<"2016-03-07T00:00:00.000">>
	};

get(49) ->
	#mail_conf{
		id = 49,
		mail_type = 0,
		sender = xmerl_ucs:to_utf8("系统"),
		title = xmerl_ucs:to_utf8("输出排行奖励"),
		content = xmerl_ucs:to_utf8("恭喜你在击杀至尊魔龙时输出排行第6-10名，奖励如下："),
		award = [{110129,1,2},{110057,1,300000},{110013,1,1}],
		active_time = 999999,
		update_time = <<"2016-03-07T00:00:00.000">>
	};

get(50) ->
	#mail_conf{
		id = 50,
		mail_type = 0,
		sender = xmerl_ucs:to_utf8("系统"),
		title = xmerl_ucs:to_utf8("输出排行奖励"),
		content = xmerl_ucs:to_utf8("恭喜你在击杀至尊魔龙时输出排行第10-50名，奖励如下："),
		award = [{110129,1,1},{110057,1,280000},{110013,1,1}],
		active_time = 999999,
		update_time = <<"2016-03-07T00:00:00.000">>
	};

get(51) ->
	#mail_conf{
		id = 51,
		mail_type = 0,
		sender = xmerl_ucs:to_utf8("系统"),
		title = xmerl_ucs:to_utf8("输出排行奖励"),
		content = xmerl_ucs:to_utf8("恭喜你在击杀至尊魔龙时输出排行第50名以后，奖励如下："),
		award = [{110128,1,1},{110009,1,250000}],
		active_time = 999999,
		update_time = <<"2016-03-07T00:00:00.000">>
	};

get(52) ->
	#mail_conf{
		id = 52,
		mail_type = 0,
		sender = xmerl_ucs:to_utf8("系统"),
		title = xmerl_ucs:to_utf8("输出排行奖励1"),
		content = xmerl_ucs:to_utf8("恭喜你在击杀至尊魔龙时输出排行第1名，奖励如下："),
		award = [{110130,1,1},{110057,1,500000},{110013,1,4}],
		active_time = 999999,
		update_time = <<"2016-03-07T00:00:00.000">>
	};

get(53) ->
	#mail_conf{
		id = 53,
		mail_type = 0,
		sender = xmerl_ucs:to_utf8("系统"),
		title = xmerl_ucs:to_utf8("输出排行奖励2"),
		content = xmerl_ucs:to_utf8("恭喜你在击杀至尊魔龙时输出排行第2名，奖励如下："),
		award = [{110130,1,1},{110057,1,450000},{110013,1,3}],
		active_time = 999999,
		update_time = <<"2016-03-07T00:00:00.000">>
	};

get(54) ->
	#mail_conf{
		id = 54,
		mail_type = 0,
		sender = xmerl_ucs:to_utf8("系统"),
		title = xmerl_ucs:to_utf8("输出排行奖励3"),
		content = xmerl_ucs:to_utf8("恭喜你在击杀至尊魔龙时输出排行第3名，奖励如下："),
		award = [{110130,1,1},{110057,1,400000},{110013,1,2}],
		active_time = 999999,
		update_time = <<"2016-03-07T00:00:00.000">>
	};

get(55) ->
	#mail_conf{
		id = 55,
		mail_type = 0,
		sender = xmerl_ucs:to_utf8("系统"),
		title = xmerl_ucs:to_utf8("输出排行奖励4"),
		content = xmerl_ucs:to_utf8("恭喜你在击杀至尊魔龙时输出排行第4-5名，奖励如下："),
		award = [{110129,1,3},{110057,1,380000},{110013,1,1}],
		active_time = 999999,
		update_time = <<"2016-03-07T00:00:00.000">>
	};

get(56) ->
	#mail_conf{
		id = 56,
		mail_type = 0,
		sender = xmerl_ucs:to_utf8("系统"),
		title = xmerl_ucs:to_utf8("输出排行奖励"),
		content = xmerl_ucs:to_utf8("恭喜你在击杀至尊魔龙时输出排行第6-10名，奖励如下："),
		award = [{110129,1,2},{110057,1,350000},{110013,1,1}],
		active_time = 999999,
		update_time = <<"2016-03-07T00:00:00.000">>
	};

get(57) ->
	#mail_conf{
		id = 57,
		mail_type = 0,
		sender = xmerl_ucs:to_utf8("系统"),
		title = xmerl_ucs:to_utf8("输出排行奖励"),
		content = xmerl_ucs:to_utf8("恭喜你在击杀至尊魔龙时输出排行第10-50名，奖励如下："),
		award = [{110129,1,1},{110057,1,330000},{110013,1,1}],
		active_time = 999999,
		update_time = <<"2016-03-07T00:00:00.000">>
	};

get(58) ->
	#mail_conf{
		id = 58,
		mail_type = 0,
		sender = xmerl_ucs:to_utf8("系统"),
		title = xmerl_ucs:to_utf8("输出排行奖励"),
		content = xmerl_ucs:to_utf8("恭喜你在击杀至尊魔龙时输出排行第50名以后，奖励如下："),
		award = [{110128,1,1},{110009,1,300000}],
		active_time = 999999,
		update_time = <<"2016-03-07T00:00:00.000">>
	};

get(59) ->
	#mail_conf{
		id = 59,
		mail_type = 0,
		sender = xmerl_ucs:to_utf8("系统"),
		title = xmerl_ucs:to_utf8("输出排行奖励1"),
		content = xmerl_ucs:to_utf8("恭喜你在击杀至尊魔龙时输出排行第1名，奖励如下："),
		award = [{110130,1,1},{110057,1,550000},{110013,1,4}],
		active_time = 999999,
		update_time = <<"2016-03-07T00:00:00.000">>
	};

get(60) ->
	#mail_conf{
		id = 60,
		mail_type = 0,
		sender = xmerl_ucs:to_utf8("系统"),
		title = xmerl_ucs:to_utf8("输出排行奖励2"),
		content = xmerl_ucs:to_utf8("恭喜你在击杀至尊魔龙时输出排行第2名，奖励如下："),
		award = [{110130,1,1},{110057,1,500000},{110013,1,3}],
		active_time = 999999,
		update_time = <<"2016-03-07T00:00:00.000">>
	};

get(61) ->
	#mail_conf{
		id = 61,
		mail_type = 0,
		sender = xmerl_ucs:to_utf8("系统"),
		title = xmerl_ucs:to_utf8("输出排行奖励3"),
		content = xmerl_ucs:to_utf8("恭喜你在击杀至尊魔龙时输出排行第3名，奖励如下："),
		award = [{110130,1,1},{110057,1,450000},{110013,1,2}],
		active_time = 999999,
		update_time = <<"2016-03-07T00:00:00.000">>
	};

get(62) ->
	#mail_conf{
		id = 62,
		mail_type = 0,
		sender = xmerl_ucs:to_utf8("系统"),
		title = xmerl_ucs:to_utf8("输出排行奖励4"),
		content = xmerl_ucs:to_utf8("恭喜你在击杀至尊魔龙时输出排行第4-5名，奖励如下："),
		award = [{110129,1,3},{110057,1,430000},{110013,1,1}],
		active_time = 999999,
		update_time = <<"2016-03-07T00:00:00.000">>
	};

get(63) ->
	#mail_conf{
		id = 63,
		mail_type = 0,
		sender = xmerl_ucs:to_utf8("系统"),
		title = xmerl_ucs:to_utf8("输出排行奖励"),
		content = xmerl_ucs:to_utf8("恭喜你在击杀至尊魔龙时输出排行第6-10名，奖励如下："),
		award = [{110129,1,2},{110057,1,400000},{110013,1,1}],
		active_time = 999999,
		update_time = <<"2016-03-07T00:00:00.000">>
	};

get(64) ->
	#mail_conf{
		id = 64,
		mail_type = 0,
		sender = xmerl_ucs:to_utf8("系统"),
		title = xmerl_ucs:to_utf8("输出排行奖励"),
		content = xmerl_ucs:to_utf8("恭喜你在击杀至尊魔龙时输出排行第10-50名，奖励如下："),
		award = [{110129,1,1},{110057,1,380000},{110013,1,1}],
		active_time = 999999,
		update_time = <<"2016-03-07T00:00:00.000">>
	};

get(65) ->
	#mail_conf{
		id = 65,
		mail_type = 0,
		sender = xmerl_ucs:to_utf8("系统"),
		title = xmerl_ucs:to_utf8("输出排行奖励"),
		content = xmerl_ucs:to_utf8("恭喜你在击杀至尊魔龙时输出排行第50名以后，奖励如下："),
		award = [{110128,1,1},{110009,1,350000}],
		active_time = 999999,
		update_time = <<"2016-03-07T00:00:00.000">>
	};

get(66) ->
	#mail_conf{
		id = 66,
		mail_type = 0,
		sender = xmerl_ucs:to_utf8("系统"),
		title = xmerl_ucs:to_utf8("胜利者邮件"),
		content = xmerl_ucs:to_utf8("恭喜您，你们行会在【%s与%s的行会战】中获胜，你们一共击败了对方%s次。"),
		award = [],
		active_time = 999999,
		update_time = <<"2016-06-23T00:00:00.000">>
	};

get(67) ->
	#mail_conf{
		id = 67,
		mail_type = 0,
		sender = xmerl_ucs:to_utf8("系统"),
		title = xmerl_ucs:to_utf8("失败者邮件"),
		content = xmerl_ucs:to_utf8("很遗憾，您的行会在【%s与%s的行会战】中落败，你们一共击败了对方%s次。"),
		award = [],
		active_time = 999999,
		update_time = <<"2016-06-23T00:00:00.000">>
	};

get(68) ->
	#mail_conf{
		id = 68,
		mail_type = 0,
		sender = xmerl_ucs:to_utf8("系统"),
		title = xmerl_ucs:to_utf8("宣战平局邮件"),
		content = xmerl_ucs:to_utf8("%s与%s势均力敌，杀敌数%s:%s，行会战打成了平手"),
		award = [],
		active_time = 999999,
		update_time = <<"2016-06-23T00:00:00.000">>
	};

get(69) ->
	#mail_conf{
		id = 69,
		mail_type = 0,
		sender = xmerl_ucs:to_utf8("系统"),
		title = xmerl_ucs:to_utf8("怪物攻城排名奖励"),
		content = xmerl_ucs:to_utf8("恭喜守城成功，你在怪物攻城中积分排名第1名，奖励如下："),
		award = [{110045,1,200},{110195,1,10000},{110196,1,10000},{110197,1,10000},{110198,1,10000}],
		active_time = 999999,
		update_time = <<"2016-03-07T00:00:00.000">>
	};

get(70) ->
	#mail_conf{
		id = 70,
		mail_type = 0,
		sender = xmerl_ucs:to_utf8("系统"),
		title = xmerl_ucs:to_utf8("怪物攻城排名奖励"),
		content = xmerl_ucs:to_utf8("恭喜守城成功，你在怪物攻城中积分排名第2名，奖励如下："),
		award = [{110045,1,150},{110195,1,8000},{110196,1,8000},{110197,1,8000},{110198,1,8000}],
		active_time = 999999,
		update_time = <<"2016-03-07T00:00:00.000">>
	};

get(71) ->
	#mail_conf{
		id = 71,
		mail_type = 0,
		sender = xmerl_ucs:to_utf8("系统"),
		title = xmerl_ucs:to_utf8("怪物攻城排名奖励"),
		content = xmerl_ucs:to_utf8("恭喜守城成功，你在怪物攻城中积分排名第3名，奖励如下："),
		award = [{110045,1,100},{110195,1,6000},{110196,1,6000},{110197,1,6000},{110198,1,6000}],
		active_time = 999999,
		update_time = <<"2016-03-07T00:00:00.000">>
	};

get(72) ->
	#mail_conf{
		id = 72,
		mail_type = 0,
		sender = xmerl_ucs:to_utf8("系统"),
		title = xmerl_ucs:to_utf8("怪物攻城排名奖励"),
		content = xmerl_ucs:to_utf8("恭喜守城成功，你在怪物攻城中积分排名第4-5名，奖励如下："),
		award = [{110045,1,100},{110195,1,5000},{110196,1,5000},{110197,1,5000},{110198,1,5000}],
		active_time = 999999,
		update_time = <<"2016-03-07T00:00:00.000">>
	};

get(73) ->
	#mail_conf{
		id = 73,
		mail_type = 0,
		sender = xmerl_ucs:to_utf8("系统"),
		title = xmerl_ucs:to_utf8("怪物攻城排名奖励"),
		content = xmerl_ucs:to_utf8("恭喜守城成功，你在怪物攻城中积分排名第6-10名，奖励如下："),
		award = [{110045,1,100},{110195,1,3000},{110196,1,3000},{110197,1,3000},{110198,1,3000}],
		active_time = 999999,
		update_time = <<"2016-03-07T00:00:00.000">>
	};

get(74) ->
	#mail_conf{
		id = 74,
		mail_type = 0,
		sender = xmerl_ucs:to_utf8("系统"),
		title = xmerl_ucs:to_utf8("怪物攻城排名奖励"),
		content = xmerl_ucs:to_utf8("恭喜守城成功，你在怪物攻城中积分排名第11-50名，奖励如下："),
		award = [{110045,1,100},{110195,1,2000},{110196,1,2000},{110197,1,2000},{110198,1,2000}],
		active_time = 999999,
		update_time = <<"2016-03-07T00:00:00.000">>
	};

get(75) ->
	#mail_conf{
		id = 75,
		mail_type = 0,
		sender = xmerl_ucs:to_utf8("系统"),
		title = xmerl_ucs:to_utf8("怪物攻城排名奖励"),
		content = xmerl_ucs:to_utf8("恭喜守城成功，你在怪物攻城中积分排名50名以后，奖励如下："),
		award = [{110045,1,50},{110195,1,1000},{110196,1,1000},{110197,1,1000},{110198,1,1000}],
		active_time = 999999,
		update_time = <<"2016-03-07T00:00:00.000">>
	};

get(76) ->
	#mail_conf{
		id = 76,
		mail_type = 0,
		sender = xmerl_ucs:to_utf8("系统"),
		title = xmerl_ucs:to_utf8("怪物攻城排名奖励"),
		content = xmerl_ucs:to_utf8("很遗憾守城失败，你在怪物攻城中积分排名第1名，奖励如下："),
		award = [{110045,1,100},{110195,1,5000},{110196,1,5000},{110197,1,5000},{110198,1,5000}],
		active_time = 999999,
		update_time = <<"2016-03-07T00:00:00.000">>
	};

get(77) ->
	#mail_conf{
		id = 77,
		mail_type = 0,
		sender = xmerl_ucs:to_utf8("系统"),
		title = xmerl_ucs:to_utf8("怪物攻城排名奖励"),
		content = xmerl_ucs:to_utf8("很遗憾守城失败，你在怪物攻城中积分排名第2名，奖励如下："),
		award = [{110045,1,75},{110195,1,4000},{110196,1,4000},{110197,1,4000},{110198,1,4000}],
		active_time = 999999,
		update_time = <<"2016-03-07T00:00:00.000">>
	};

get(78) ->
	#mail_conf{
		id = 78,
		mail_type = 0,
		sender = xmerl_ucs:to_utf8("系统"),
		title = xmerl_ucs:to_utf8("怪物攻城排名奖励"),
		content = xmerl_ucs:to_utf8("很遗憾守城失败，你在怪物攻城中积分排名第3名，奖励如下："),
		award = [{110045,1,50},{110195,1,3000},{110196,1,3000},{110197,1,3000},{110198,1,3000}],
		active_time = 999999,
		update_time = <<"2016-03-07T00:00:00.000">>
	};

get(79) ->
	#mail_conf{
		id = 79,
		mail_type = 0,
		sender = xmerl_ucs:to_utf8("系统"),
		title = xmerl_ucs:to_utf8("怪物攻城排名奖励"),
		content = xmerl_ucs:to_utf8("很遗憾守城失败，你在怪物攻城中积分排名第4-5名，奖励如下："),
		award = [{110045,1,50},{110195,1,2500},{110196,1,2500},{110197,1,2500},{110198,1,2500}],
		active_time = 999999,
		update_time = <<"2016-03-07T00:00:00.000">>
	};

get(80) ->
	#mail_conf{
		id = 80,
		mail_type = 0,
		sender = xmerl_ucs:to_utf8("系统"),
		title = xmerl_ucs:to_utf8("怪物攻城排名奖励"),
		content = xmerl_ucs:to_utf8("很遗憾守城失败，你在怪物攻城中积分排名第6-10名，奖励如下："),
		award = [{110045,1,50},{110195,1,1500},{110196,1,1500},{110197,1,1500},{110198,1,1500}],
		active_time = 999999,
		update_time = <<"2016-03-07T00:00:00.000">>
	};

get(81) ->
	#mail_conf{
		id = 81,
		mail_type = 0,
		sender = xmerl_ucs:to_utf8("系统"),
		title = xmerl_ucs:to_utf8("怪物攻城排名奖励"),
		content = xmerl_ucs:to_utf8("很遗憾守城失败，你在怪物攻城中积分排名第11-50名，奖励如下："),
		award = [{110045,1,50},{110195,1,1000},{110196,1,1000},{110197,1,1000},{110198,1,1000}],
		active_time = 999999,
		update_time = <<"2016-03-07T00:00:00.000">>
	};

get(82) ->
	#mail_conf{
		id = 82,
		mail_type = 0,
		sender = xmerl_ucs:to_utf8("系统"),
		title = xmerl_ucs:to_utf8("怪物攻城排名奖励"),
		content = xmerl_ucs:to_utf8("很遗憾守城失败，你在怪物攻城中积分排名50名以后，奖励如下："),
		award = [{110045,1,25},{110195,1,500},{110196,1,500},{110197,1,500},{110198,1,500}],
		active_time = 999999,
		update_time = <<"2016-03-07T00:00:00.000">>
	};

get(83) ->
	#mail_conf{
		id = 83,
		mail_type = 0,
		sender = xmerl_ucs:to_utf8("系统"),
		title = xmerl_ucs:to_utf8("攻城胜利参与奖励"),
		content = xmerl_ucs:to_utf8("恭喜你们行会攻城成功，这是给予你的参与奖励："),
		award = [{110045,1,500},{110089,1,5},{110003,1,20}],
		active_time = 999999,
		update_time = <<"2016-03-07T00:00:00.000">>
	};

get(84) ->
	#mail_conf{
		id = 84,
		mail_type = 0,
		sender = xmerl_ucs:to_utf8("系统"),
		title = xmerl_ucs:to_utf8("智慧答题排名奖励"),
		content = xmerl_ucs:to_utf8("恭喜你获得答题第1名，奖励如下："),
		award = [{110109,1,1},{110003,1,50},{110219,1,50}],
		active_time = 999999,
		update_time = <<"2016-03-07T00:00:00.000">>
	};

get(85) ->
	#mail_conf{
		id = 85,
		mail_type = 0,
		sender = xmerl_ucs:to_utf8("系统"),
		title = xmerl_ucs:to_utf8("智慧答题排名奖励"),
		content = xmerl_ucs:to_utf8("恭喜你获得答题第2名，奖励如下："),
		award = [{110109,1,1},{110003,1,40},{110219,1,40}],
		active_time = 999999,
		update_time = <<"2016-03-07T00:00:00.000">>
	};

get(86) ->
	#mail_conf{
		id = 86,
		mail_type = 0,
		sender = xmerl_ucs:to_utf8("系统"),
		title = xmerl_ucs:to_utf8("智慧答题排名奖励"),
		content = xmerl_ucs:to_utf8("恭喜你获得答题第3名，奖励如下："),
		award = [{110109,1,1},{110003,1,30},{110219,1,30}],
		active_time = 999999,
		update_time = <<"2016-03-07T00:00:00.000">>
	};

get(87) ->
	#mail_conf{
		id = 87,
		mail_type = 0,
		sender = xmerl_ucs:to_utf8("系统"),
		title = xmerl_ucs:to_utf8("智慧答题排名奖励"),
		content = xmerl_ucs:to_utf8("恭喜你获得答题第4名，奖励如下："),
		award = [{110003,1,20},{110219,1,20}],
		active_time = 999999,
		update_time = <<"2016-03-07T00:00:00.000">>
	};

get(88) ->
	#mail_conf{
		id = 88,
		mail_type = 0,
		sender = xmerl_ucs:to_utf8("系统"),
		title = xmerl_ucs:to_utf8("智慧答题排名奖励"),
		content = xmerl_ucs:to_utf8("恭喜你获得答题第5名，奖励如下："),
		award = [{110003,1,20},{110219,1,20}],
		active_time = 999999,
		update_time = <<"2016-03-07T00:00:00.000">>
	};

get(89) ->
	#mail_conf{
		id = 89,
		mail_type = 0,
		sender = xmerl_ucs:to_utf8("系统"),
		title = xmerl_ucs:to_utf8("智慧答题排名奖励"),
		content = xmerl_ucs:to_utf8("恭喜你获得答题第6名，奖励如下："),
		award = [{110003,1,20},{110219,1,20}],
		active_time = 999999,
		update_time = <<"2016-03-07T00:00:00.000">>
	};

get(90) ->
	#mail_conf{
		id = 90,
		mail_type = 0,
		sender = xmerl_ucs:to_utf8("系统"),
		title = xmerl_ucs:to_utf8("智慧答题排名奖励"),
		content = xmerl_ucs:to_utf8("恭喜你获得答题第7名，奖励如下："),
		award = [{110003,1,20},{110219,1,20}],
		active_time = 999999,
		update_time = <<"2016-03-07T00:00:00.000">>
	};

get(91) ->
	#mail_conf{
		id = 91,
		mail_type = 0,
		sender = xmerl_ucs:to_utf8("系统"),
		title = xmerl_ucs:to_utf8("智慧答题排名奖励"),
		content = xmerl_ucs:to_utf8("恭喜你获得答题第8名，奖励如下："),
		award = [{110003,1,20},{110219,1,20}],
		active_time = 999999,
		update_time = <<"2016-03-07T00:00:00.000">>
	};

get(92) ->
	#mail_conf{
		id = 92,
		mail_type = 0,
		sender = xmerl_ucs:to_utf8("系统"),
		title = xmerl_ucs:to_utf8("智慧答题排名奖励"),
		content = xmerl_ucs:to_utf8("很遗憾本次答题未获得排名，只能获得参与奖励，下次加油哦！"),
		award = [{110219,1,10}],
		active_time = 999999,
		update_time = <<"2016-03-07T00:00:00.000">>
	};

get(93) ->
	#mail_conf{
		id = 93,
		mail_type = 0,
		sender = xmerl_ucs:to_utf8("系统"),
		title = xmerl_ucs:to_utf8("教师节活动奖励"),
		content = xmerl_ucs:to_utf8("恭喜您在本次教师节杀怪积分活动中获得第1名，可以获取以下奖励"),
		award = [{110109,1,1},{110140,1,30},{110007,1,80},{110222,1,1}],
		active_time = 999999,
		update_time = <<"2016-03-07T00:00:00.000">>
	};

get(94) ->
	#mail_conf{
		id = 94,
		mail_type = 0,
		sender = xmerl_ucs:to_utf8("系统"),
		title = xmerl_ucs:to_utf8("教师节活动奖励"),
		content = xmerl_ucs:to_utf8("恭喜您在本次教师节杀怪积分活动中获得第2名，可以获取以下奖励"),
		award = [{110109,1,1},{110140,1,10},{110007,1,50},{110056,1,5}],
		active_time = 999999,
		update_time = <<"2016-03-07T00:00:00.000">>
	};

get(95) ->
	#mail_conf{
		id = 95,
		mail_type = 0,
		sender = xmerl_ucs:to_utf8("系统"),
		title = xmerl_ucs:to_utf8("教师节活动奖励"),
		content = xmerl_ucs:to_utf8("恭喜您在本次教师节杀怪积分活动中获得第3名，可以获取以下奖励"),
		award = [{110050,1,3},{110140,1,10},{110007,1,30},{110056,1,3}],
		active_time = 999999,
		update_time = <<"2016-03-07T00:00:00.000">>
	};

get(96) ->
	#mail_conf{
		id = 96,
		mail_type = 0,
		sender = xmerl_ucs:to_utf8("系统"),
		title = xmerl_ucs:to_utf8("教师节活动奖励"),
		content = xmerl_ucs:to_utf8("恭喜您在本次教师节杀怪积分活动中突破2000积分，可以获取以下奖励"),
		award = [{110050,1,1},{110054,1,2},{110078,1,30},{110007,1,15}],
		active_time = 999999,
		update_time = <<"2016-03-07T00:00:00.000">>
	};

get(97) ->
	#mail_conf{
		id = 97,
		mail_type = 0,
		sender = xmerl_ucs:to_utf8("系统"),
		title = xmerl_ucs:to_utf8("教师节活动奖励"),
		content = xmerl_ucs:to_utf8("恭喜您在本次教师节杀怪积分活动中突破1000积分，可以获取以下奖励"),
		award = [{110148,1,2},{110078,1,30},{110003,1,15},{110006,1,20}],
		active_time = 999999,
		update_time = <<"2016-03-07T00:00:00.000">>
	};

get(98) ->
	#mail_conf{
		id = 98,
		mail_type = 0,
		sender = xmerl_ucs:to_utf8("系统"),
		title = xmerl_ucs:to_utf8("40级升级奖励"),
		content = xmerl_ucs:to_utf8("恭喜您成功升到40级，已为您解锁大量全新地图，更有高难度BOSS白野猪王、祖玛教主、赤月老魔等供您挑战。同时为您准备了升级礼包，请及时领取。"),
		award = <<"">>,
		active_time = 999999,
		update_time = <<"2016-03-07T00:00:00.000">>
	};

get(99) ->
	#mail_conf{
		id = 99,
		mail_type = 0,
		sender = xmerl_ucs:to_utf8("系统"),
		title = xmerl_ucs:to_utf8("50级升级奖励"),
		content = xmerl_ucs:to_utf8("恭喜您成功升到50级，已为您解锁大量全新地图，更有顶级BOSS冥蛇女妖、冥海领主等供您挑战。同时为您准备了升级礼包，请及时领取。"),
		award = <<"">>,
		active_time = 999999,
		update_time = <<"2016-03-07T00:00:00.000">>
	};

get(100) ->
	#mail_conf{
		id = 100,
		mail_type = 0,
		sender = xmerl_ucs:to_utf8("系统"),
		title = xmerl_ucs:to_utf8("79级升级奖励"),
		content = xmerl_ucs:to_utf8("恭喜您成功升到79级，本服已经无法满足您了，现在已为您解锁跨服地图，更有超级BOSS火龙供您挑战。同时为您准备了升级礼包，请及时领取。"),
		award = <<"">>,
		active_time = 999999,
		update_time = <<"2016-03-07T00:00:00.000">>
	};

get(101) ->
	#mail_conf{
		id = 101,
		mail_type = 0,
		sender = xmerl_ucs:to_utf8("系统"),
		title = xmerl_ucs:to_utf8("教师节活动奖励"),
		content = xmerl_ucs:to_utf8("恭喜您在本次教师节杀怪积分活动中突破500积分，可以获取以下奖励"),
		award = [{110078,1,10},{110056,1,1},{110049,1,5},{110006,1,10}],
		active_time = 999999,
		update_time = <<"2016-03-07T00:00:00.000">>
	};

get(102) ->
	#mail_conf{
		id = 102,
		mail_type = 0,
		sender = xmerl_ucs:to_utf8("系统"),
		title = xmerl_ucs:to_utf8("坐骑回收补偿"),
		content = xmerl_ucs:to_utf8("鉴于新坐骑系统的调整，我们将回收您的坐骑:驭风，同时会返回购买时相同数量的元宝，请注意查收。"),
		award = [{110008,0,5888}],
		active_time = 999999,
		update_time = <<"2016-09-19T00:00:00.000">>
	};

get(103) ->
	#mail_conf{
		id = 103,
		mail_type = 0,
		sender = xmerl_ucs:to_utf8("系统"),
		title = xmerl_ucs:to_utf8("坐骑回收补偿"),
		content = xmerl_ucs:to_utf8("鉴于新坐骑系统的调整，我们将回收您的坐骑:狱焰，同时会返回对应价值材料作为补偿，返还材料足够升级至原坐骑同样的属性与外观。"),
		award = [{110259,1,260}],
		active_time = 999999,
		update_time = <<"2016-09-19T00:00:00.000">>
	};

get(104) ->
	#mail_conf{
		id = 104,
		mail_type = 0,
		sender = xmerl_ucs:to_utf8("系统"),
		title = xmerl_ucs:to_utf8("结盟邮件"),
		content = xmerl_ucs:to_utf8("我方行会已与%s服%s行会成功结成同盟，请注意切换模式避免误伤盟友，同盟关系会在跨服活动结束后消失。"),
		award = [],
		active_time = 999999,
		update_time = <<"2016-09-19T00:00:00.000">>
	};

get(105) ->
	#mail_conf{
		id = 105,
		mail_type = 0,
		sender = xmerl_ucs:to_utf8("系统"),
		title = xmerl_ucs:to_utf8("结盟邮件"),
		content = xmerl_ucs:to_utf8("我方行会已与%s服%s行会、%s服%s行会成功结成三方同盟，请注意切换模式避免误伤盟友，同盟关系会在跨服活动结束后消失。"),
		award = [],
		active_time = 999999,
		update_time = <<"2016-09-19T00:00:00.000">>
	};

get(106) ->
	#mail_conf{
		id = 106,
		mail_type = 0,
		sender = xmerl_ucs:to_utf8("系统"),
		title = xmerl_ucs:to_utf8("解除结盟邮件"),
		content = xmerl_ucs:to_utf8("我方行会已与%s服%s行会解除同盟关系，请全体人员注意！"),
		award = [],
		active_time = 999999,
		update_time = <<"2016-09-19T00:00:00.000">>
	};

get(107) ->
	#mail_conf{
		id = 107,
		mail_type = 0,
		sender = xmerl_ucs:to_utf8("系统"),
		title = xmerl_ucs:to_utf8("解除结盟邮件"),
		content = xmerl_ucs:to_utf8("我方行会已与%s服%s行会、%s服%s行会解除三方同盟关系，请全体人员注意！"),
		award = [],
		active_time = 999999,
		update_time = <<"2016-09-19T00:00:00.000">>
	};

get(108) ->
	#mail_conf{
		id = 108,
		mail_type = 0,
		sender = xmerl_ucs:to_utf8("系统"),
		title = xmerl_ucs:to_utf8("王城乱斗奖励"),
		content = xmerl_ucs:to_utf8("恭喜获得王城乱斗第1名，奖励如下："),
		award = [{110008,0,5888}],
		active_time = 999999,
		update_time = <<"2016-09-19T00:00:00.000">>
	};

get(109) ->
	#mail_conf{
		id = 109,
		mail_type = 0,
		sender = xmerl_ucs:to_utf8("系统"),
		title = xmerl_ucs:to_utf8("王城乱斗奖励"),
		content = xmerl_ucs:to_utf8("恭喜获得王城乱斗第2名，奖励如下："),
		award = [{110008,0,1000}],
		active_time = 999999,
		update_time = <<"2016-09-19T00:00:00.000">>
	};

get(110) ->
	#mail_conf{
		id = 110,
		mail_type = 0,
		sender = xmerl_ucs:to_utf8("系统"),
		title = xmerl_ucs:to_utf8("王城乱斗奖励"),
		content = xmerl_ucs:to_utf8("恭喜获得王城乱斗第3名，奖励如下："),
		award = [{110008,0,500}],
		active_time = 999999,
		update_time = <<"2016-09-19T00:00:00.000">>
	};

get(111) ->
	#mail_conf{
		id = 111,
		mail_type = 0,
		sender = xmerl_ucs:to_utf8("系统"),
		title = xmerl_ucs:to_utf8("王城乱斗奖励"),
		content = xmerl_ucs:to_utf8("恭喜获得王城乱斗第%s名，奖励如下："),
		award = [{110008,0,200}],
		active_time = 999999,
		update_time = <<"2016-09-19T00:00:00.000">>
	};

get(112) ->
	#mail_conf{
		id = 112,
		mail_type = 0,
		sender = xmerl_ucs:to_utf8("系统"),
		title = xmerl_ucs:to_utf8("王城乱斗奖励"),
		content = xmerl_ucs:to_utf8("很遗憾本次王城乱斗未跻身进前十，这是您的参与奖励，请下次再接再厉！"),
		award = [{110008,0,10}],
		active_time = 999999,
		update_time = <<"2016-09-19T00:00:00.000">>
	};

get(113) ->
	#mail_conf{
		id = 113,
		mail_type = 0,
		sender = xmerl_ucs:to_utf8("系统"),
		title = xmerl_ucs:to_utf8("春节活动奖励"),
		content = xmerl_ucs:to_utf8("恭喜您在本次春节杀怪积分活动中获得第1名，可以获取以下奖励"),
		award = [{110163,1,2},{110109,1,2},{110260,1,20},{110102,1,5}],
		active_time = 999999,
		update_time = <<"2016-03-07T00:00:00.000">>
	};

get(114) ->
	#mail_conf{
		id = 114,
		mail_type = 0,
		sender = xmerl_ucs:to_utf8("系统"),
		title = xmerl_ucs:to_utf8("春节活动奖励"),
		content = xmerl_ucs:to_utf8("恭喜您在本次春节杀怪积分活动中获得第2名，可以获取以下奖励"),
		award = [{110163,1,1},{110109,1,1},{110147,1,1},{110101,1,5}],
		active_time = 999999,
		update_time = <<"2016-03-07T00:00:00.000">>
	};

get(115) ->
	#mail_conf{
		id = 115,
		mail_type = 0,
		sender = xmerl_ucs:to_utf8("系统"),
		title = xmerl_ucs:to_utf8("春节活动奖励"),
		content = xmerl_ucs:to_utf8("恭喜您在本次春节杀怪积分活动中获得第3名，可以获取以下奖励"),
		award = [{110054,1,5},{110109,1,1},{110101,1,5},{110260,1,10}],
		active_time = 999999,
		update_time = <<"2016-03-07T00:00:00.000">>
	};

get(116) ->
	#mail_conf{
		id = 116,
		mail_type = 0,
		sender = xmerl_ucs:to_utf8("系统"),
		title = xmerl_ucs:to_utf8("春节活动奖励"),
		content = xmerl_ucs:to_utf8("恭喜您在本次春节杀怪积分活动中突破2000积分，可以获取以下奖励"),
		award = [{110099,1,5},{110054,1,5},{110152,1,10},{110193,1,10}],
		active_time = 999999,
		update_time = <<"2016-03-07T00:00:00.000">>
	};

get(117) ->
	#mail_conf{
		id = 117,
		mail_type = 0,
		sender = xmerl_ucs:to_utf8("系统"),
		title = xmerl_ucs:to_utf8("春节活动奖励"),
		content = xmerl_ucs:to_utf8("恭喜您在本次春节杀怪积分活动中突破1000积分，可以获取以下奖励"),
		award = [{110149,1,1},{110152,1,5},{110003,1,15},{110007,1,5}],
		active_time = 999999,
		update_time = <<"2016-03-07T00:00:00.000">>
	};

get(118) ->
	#mail_conf{
		id = 118,
		mail_type = 0,
		sender = xmerl_ucs:to_utf8("系统"),
		title = xmerl_ucs:to_utf8("春节活动奖励"),
		content = xmerl_ucs:to_utf8("恭喜您在本次春节杀怪积分活动中突破500积分，可以获取以下奖励"),
		award = [{110152,1,5},{110260,1,1},{110003,1,10},{110056,1,5}],
		active_time = 999999,
		update_time = <<"2016-03-07T00:00:00.000">>
	};

get(119) ->
	#mail_conf{
		id = 119,
		mail_type = 0,
		sender = xmerl_ucs:to_utf8("系统"),
		title = xmerl_ucs:to_utf8("跨服幻境之地活动奖励"),
		content = xmerl_ucs:to_utf8("恭喜您在本次跨服幻境之地活动获得第1名，可以获取以下奖励"),
		award = [{110318,0,5}],
		active_time = 999999,
		update_time = <<"2016-03-07T00:00:00.000">>
	};

get(120) ->
	#mail_conf{
		id = 120,
		mail_type = 0,
		sender = xmerl_ucs:to_utf8("系统"),
		title = xmerl_ucs:to_utf8("跨服幻境之地活动奖励"),
		content = xmerl_ucs:to_utf8("恭喜您在本次跨服幻境之地活动获得第2名，可以获取以下奖励"),
		award = [{110318,0,4}],
		active_time = 999999,
		update_time = <<"2016-03-07T00:00:00.000">>
	};

get(121) ->
	#mail_conf{
		id = 121,
		mail_type = 0,
		sender = xmerl_ucs:to_utf8("系统"),
		title = xmerl_ucs:to_utf8("跨服幻境之地活动奖励"),
		content = xmerl_ucs:to_utf8("恭喜您在本次跨服幻境之地活动获得第3名，可以获取以下奖励"),
		award = [{110318,0,3}],
		active_time = 999999,
		update_time = <<"2016-03-07T00:00:00.000">>
	};

get(122) ->
	#mail_conf{
		id = 122,
		mail_type = 0,
		sender = xmerl_ucs:to_utf8("系统"),
		title = xmerl_ucs:to_utf8("跨服幻境之地活动奖励"),
		content = xmerl_ucs:to_utf8("恭喜您在本次跨服幻境之地活动获得4-10名，可以获取以下奖励"),
		award = [{110318,0,1}],
		active_time = 999999,
		update_time = <<"2016-03-07T00:00:00.000">>
	};

get(123) ->
	#mail_conf{
		id = 123,
		mail_type = 0,
		sender = xmerl_ucs:to_utf8("系统"),
		title = xmerl_ucs:to_utf8("跨服幻境之地活动奖励"),
		content = xmerl_ucs:to_utf8("很遗憾，您本次跨服幻境之地活动中未获得名次，请下次再接再厉！"),
		award = [],
		active_time = 999999,
		update_time = <<"2016-03-07T00:00:00.000">>
	};

get(124) ->
	#mail_conf{
		id = 124,
		mail_type = 0,
		sender = xmerl_ucs:to_utf8("系统"),
		title = xmerl_ucs:to_utf8("幻境之地活动奖励"),
		content = xmerl_ucs:to_utf8("恭喜您在本次幻境之地活动获得第一名，可以获取以下奖励"),
		award = [{110008,0,1500}],
		active_time = 999999,
		update_time = <<"2016-03-07T00:00:00.000">>
	};

get(125) ->
	#mail_conf{
		id = 125,
		mail_type = 0,
		sender = xmerl_ucs:to_utf8("系统"),
		title = xmerl_ucs:to_utf8("幻境之地活动奖励"),
		content = xmerl_ucs:to_utf8("恭喜您在本次幻境之地活动获得第二名，可以获取以下奖励"),
		award = [{110008,0,800}],
		active_time = 999999,
		update_time = <<"2016-03-07T00:00:00.000">>
	};

get(126) ->
	#mail_conf{
		id = 126,
		mail_type = 0,
		sender = xmerl_ucs:to_utf8("系统"),
		title = xmerl_ucs:to_utf8("幻境之地活动奖励"),
		content = xmerl_ucs:to_utf8("恭喜您在本次幻境之地活动获得第三名，可以获取以下奖励"),
		award = [{110008,0,500}],
		active_time = 999999,
		update_time = <<"2016-03-07T00:00:00.000">>
	};

get(127) ->
	#mail_conf{
		id = 127,
		mail_type = 0,
		sender = xmerl_ucs:to_utf8("系统"),
		title = xmerl_ucs:to_utf8("幻境之地活动奖励"),
		content = xmerl_ucs:to_utf8("很遗憾，您本次幻境之地活动未达到前三名，请下次再接再厉"),
		award = [],
		active_time = 999999,
		update_time = <<"2016-03-07T00:00:00.000">>
	};

get(128) ->
	#mail_conf{
		id = 128,
		mail_type = 0,
		sender = xmerl_ucs:to_utf8("系统"),
		title = xmerl_ucs:to_utf8("幻境之地活动奖励"),
		content = xmerl_ucs:to_utf8("很遗憾，您本次幻境之地活动中未获得名次，请下次再接再厉！"),
		award = [],
		active_time = 999999,
		update_time = <<"2016-03-07T00:00:00.000">>
	};

get(_Key) ->
	?ERR("undefined key from mail_config ~p", [_Key]).