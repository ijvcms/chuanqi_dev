%%%-------------------------------------------------------------------
%%% @author zhengsiying
%%% @doc
%%%		自动生成文件，不要手动修改
%%% @end
%%% Created : 2016/10/12
%%%-------------------------------------------------------------------

-module(function_notice_config).

-include("common.hrl").
-include("config.hrl").

-compile([export_all]).

get_list_conf() ->
	[ function_notice_config:get(X) || X <- get_list() ].

get_list() ->
	[1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14].

get(1) ->
	#function_notice_conf{
		id = 1,
		name = xmerl_ucs:to_utf8("翅膀展示"),
		lv = 10,
		reward = [{110237,1,1}],
		counter_id = 10084
	};

get(2) ->
	#function_notice_conf{
		id = 2,
		name = xmerl_ucs:to_utf8("强化展示"),
		lv = 20,
		reward = [{110238,1,1}],
		counter_id = 10085
	};

get(3) ->
	#function_notice_conf{
		id = 3,
		name = xmerl_ucs:to_utf8("提纯展示"),
		lv = 25,
		reward = [{110239,1,1}],
		counter_id = 10086
	};

get(4) ->
	#function_notice_conf{
		id = 4,
		name = xmerl_ucs:to_utf8("洗炼展示"),
		lv = 28,
		reward = [{110240,1,1}],
		counter_id = 10087
	};

get(5) ->
	#function_notice_conf{
		id = 5,
		name = xmerl_ucs:to_utf8("打造展示"),
		lv = 30,
		reward = [{110241,1,1}],
		counter_id = 10088
	};

get(6) ->
	#function_notice_conf{
		id = 6,
		name = xmerl_ucs:to_utf8("日常任务"),
		lv = 35,
		reward = [{110242,1,1}],
		counter_id = 10089
	};

get(7) ->
	#function_notice_conf{
		id = 7,
		name = xmerl_ucs:to_utf8("勋章展示"),
		lv = 38,
		reward = [{110243,1,1}],
		counter_id = 10090
	};

get(8) ->
	#function_notice_conf{
		id = 8,
		name = xmerl_ucs:to_utf8("奖励展示"),
		lv = 40,
		reward = [{110244,1,1}],
		counter_id = 10091
	};

get(9) ->
	#function_notice_conf{
		id = 9,
		name = xmerl_ucs:to_utf8("奖励展示"),
		lv = 41,
		reward = [{110248,1,1}],
		counter_id = 10092
	};

get(10) ->
	#function_notice_conf{
		id = 10,
		name = xmerl_ucs:to_utf8("奖励展示"),
		lv = 45,
		reward = [{110247,1,1}],
		counter_id = 10094
	};

get(11) ->
	#function_notice_conf{
		id = 11,
		name = xmerl_ucs:to_utf8("奖励展示"),
		lv = 49,
		reward = [{110246,1,1}],
		counter_id = 10093
	};

get(12) ->
	#function_notice_conf{
		id = 12,
		name = xmerl_ucs:to_utf8("坐骑展示"),
		lv = 50,
		reward = [{110267,1,1}],
		counter_id = 10095
	};

get(13) ->
	#function_notice_conf{
		id = 13,
		name = xmerl_ucs:to_utf8("铸魂展示"),
		lv = 51,
		reward = [{110249,1,1}],
		counter_id = 10096
	};

get(14) ->
	#function_notice_conf{
		id = 14,
		name = xmerl_ucs:to_utf8("继承展示"),
		lv = 52,
		reward = [{110250,1,1}],
		counter_id = 10097
	};

get(_Key) ->
	?ERR("undefined key from function_notice_config ~p", [_Key]).