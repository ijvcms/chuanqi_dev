%%%-------------------------------------------------------------------
%%% @author zhengsiying
%%% @doc
%%%		自动生成文件，不要手动修改
%%% @end
%%% Created : 2016/10/12
%%%-------------------------------------------------------------------

-module(function_config).

-include("common.hrl").
-include("config.hrl").

-compile([export_all]).

get_list() ->
	[  
 	#function_conf{
		id = 1,
		name = xmerl_ucs:to_utf8("主线任务"),
		lv = 0,
		task_id = 0,
		type = 0,
		begin_time = 0,
		end_time = 0,
		consume = []
	},  
 	#function_conf{
		id = 2,
		name = xmerl_ucs:to_utf8("角色"),
		lv = 0,
		task_id = 0,
		type = 0,
		begin_time = 0,
		end_time = 0,
		consume = []
	},  
 	#function_conf{
		id = 3,
		name = xmerl_ucs:to_utf8("背包"),
		lv = 0,
		task_id = 0,
		type = 0,
		begin_time = 0,
		end_time = 0,
		consume = []
	},  
 	#function_conf{
		id = 4,
		name = xmerl_ucs:to_utf8("技能"),
		lv = 0,
		task_id = 0,
		type = 0,
		begin_time = 0,
		end_time = 0,
		consume = []
	},  
 	#function_conf{
		id = 5,
		name = xmerl_ucs:to_utf8("行会"),
		lv = 0,
		task_id = 0,
		type = 0,
		begin_time = 0,
		end_time = 0,
		consume = []
	},  
 	#function_conf{
		id = 6,
		name = xmerl_ucs:to_utf8("社交（好友、"),
		lv = 0,
		task_id = 0,
		type = 0,
		begin_time = 0,
		end_time = 0,
		consume = []
	},  
 	#function_conf{
		id = 7,
		name = xmerl_ucs:to_utf8("社交（邮件）"),
		lv = 0,
		task_id = 0,
		type = 0,
		begin_time = 0,
		end_time = 0,
		consume = []
	},  
 	#function_conf{
		id = 8,
		name = xmerl_ucs:to_utf8("组队"),
		lv = 0,
		task_id = 0,
		type = 0,
		begin_time = 0,
		end_time = 0,
		consume = []
	},  
 	#function_conf{
		id = 9,
		name = xmerl_ucs:to_utf8("系统设置"),
		lv = 0,
		task_id = 0,
		type = 0,
		begin_time = 0,
		end_time = 0,
		consume = []
	},  
 	#function_conf{
		id = 10,
		name = xmerl_ucs:to_utf8("聊天系统"),
		lv = 0,
		task_id = 0,
		type = 0,
		begin_time = 0,
		end_time = 0,
		consume = []
	},  
 	#function_conf{
		id = 11,
		name = xmerl_ucs:to_utf8("装备强化"),
		lv = 20,
		task_id = 0,
		type = 0,
		begin_time = 0,
		end_time = 0,
		consume = []
	},  
 	#function_conf{
		id = 12,
		name = xmerl_ucs:to_utf8("装备洗练"),
		lv = 28,
		task_id = 0,
		type = 0,
		begin_time = 0,
		end_time = 0,
		consume = []
	},  
 	#function_conf{
		id = 13,
		name = xmerl_ucs:to_utf8("装备打造"),
		lv = 30,
		task_id = 0,
		type = 0,
		begin_time = 0,
		end_time = 0,
		consume = []
	},  
 	#function_conf{
		id = 14,
		name = xmerl_ucs:to_utf8("PK模式"),
		lv = 36,
		task_id = 0,
		type = 0,
		begin_time = 0,
		end_time = 0,
		consume = []
	},  
 	#function_conf{
		id = 15,
		name = xmerl_ucs:to_utf8("首充"),
		lv = 0,
		task_id = 0,
		type = 0,
		begin_time = 0,
		end_time = 0,
		consume = []
	},  
 	#function_conf{
		id = 16,
		name = xmerl_ucs:to_utf8("攻城战"),
		lv = 41,
		task_id = 0,
		type = 0,
		begin_time = 0,
		end_time = 0,
		consume = []
	},  
 	#function_conf{
		id = 17,
		name = xmerl_ucs:to_utf8("今日目标"),
		lv = 38,
		task_id = 0,
		type = 0,
		begin_time = 0,
		end_time = 0,
		consume = []
	},  
 	#function_conf{
		id = 18,
		name = xmerl_ucs:to_utf8("排位赛"),
		lv = 36,
		task_id = 0,
		type = 0,
		begin_time = 0,
		end_time = 0,
		consume = []
	},  
 	#function_conf{
		id = 19,
		name = xmerl_ucs:to_utf8("日常活动"),
		lv = 0,
		task_id = 0,
		type = 0,
		begin_time = 0,
		end_time = 0,
		consume = []
	},  
 	#function_conf{
		id = 20,
		name = xmerl_ucs:to_utf8("福利中心"),
		lv = 0,
		task_id = 0,
		type = 0,
		begin_time = 0,
		end_time = 0,
		consume = []
	},  
 	#function_conf{
		id = 21,
		name = xmerl_ucs:to_utf8("商城"),
		lv = 0,
		task_id = 0,
		type = 0,
		begin_time = 0,
		end_time = 0,
		consume = []
	},  
 	#function_conf{
		id = 22,
		name = xmerl_ucs:to_utf8("挂机"),
		lv = 200,
		task_id = 0,
		type = 0,
		begin_time = 0,
		end_time = 0,
		consume = []
	},  
 	#function_conf{
		id = 23,
		name = xmerl_ucs:to_utf8("功勋任务"),
		lv = 38,
		task_id = 0,
		type = 0,
		begin_time = 0,
		end_time = 0,
		consume = []
	},  
 	#function_conf{
		id = 24,
		name = xmerl_ucs:to_utf8("膜拜功能"),
		lv = 38,
		task_id = 0,
		type = 0,
		begin_time = 0,
		end_time = 0,
		consume = []
	},  
 	#function_conf{
		id = 25,
		name = xmerl_ucs:to_utf8("世界BOSS"),
		lv = 20,
		task_id = 0,
		type = 0,
		begin_time = 0,
		end_time = 0,
		consume = []
	},  
 	#function_conf{
		id = 26,
		name = xmerl_ucs:to_utf8("个人副本"),
		lv = 40,
		task_id = 0,
		type = 0,
		begin_time = 0,
		end_time = 0,
		consume = []
	},  
 	#function_conf{
		id = 27,
		name = xmerl_ucs:to_utf8("分包下载"),
		lv = 200,
		task_id = 0,
		type = 0,
		begin_time = 0,
		end_time = 0,
		consume = []
	},  
 	#function_conf{
		id = 28,
		name = xmerl_ucs:to_utf8("游戏攻略"),
		lv = 200,
		task_id = 0,
		type = 0,
		begin_time = 0,
		end_time = 0,
		consume = []
	},  
 	#function_conf{
		id = 29,
		name = xmerl_ucs:to_utf8("充值"),
		lv = 0,
		task_id = 0,
		type = 0,
		begin_time = 0,
		end_time = 0,
		consume = []
	},  
 	#function_conf{
		id = 30,
		name = xmerl_ucs:to_utf8("装备"),
		lv = 0,
		task_id = 0,
		type = 0,
		begin_time = 0,
		end_time = 0,
		consume = []
	},  
 	#function_conf{
		id = 31,
		name = xmerl_ucs:to_utf8("提纯"),
		lv = 25,
		task_id = 0,
		type = 0,
		begin_time = 0,
		end_time = 0,
		consume = []
	},  
 	#function_conf{
		id = 32,
		name = xmerl_ucs:to_utf8("分解"),
		lv = 200,
		task_id = 0,
		type = 0,
		begin_time = 0,
		end_time = 0,
		consume = []
	},  
 	#function_conf{
		id = 33,
		name = xmerl_ucs:to_utf8("勋章"),
		lv = 38,
		task_id = 0,
		type = 0,
		begin_time = 0,
		end_time = 0,
		consume = []
	},  
 	#function_conf{
		id = 34,
		name = xmerl_ucs:to_utf8("签到"),
		lv = 10,
		task_id = 0,
		type = 0,
		begin_time = 0,
		end_time = 0,
		consume = []
	},  
 	#function_conf{
		id = 35,
		name = xmerl_ucs:to_utf8("交易所"),
		lv = 0,
		task_id = 0,
		type = 0,
		begin_time = 0,
		end_time = 0,
		consume = []
	},  
 	#function_conf{
		id = 36,
		name = xmerl_ucs:to_utf8("日常任务"),
		lv = 35,
		task_id = 0,
		type = 0,
		begin_time = 0,
		end_time = 0,
		consume = []
	},  
 	#function_conf{
		id = 37,
		name = xmerl_ucs:to_utf8("未知暗殿"),
		lv = 50,
		task_id = 0,
		type = 0,
		begin_time = {0,{0,0}},
		end_time = {999,{0,0}},
		consume = []
	},  
 	#function_conf{
		id = 38,
		name = xmerl_ucs:to_utf8("屠龙大会"),
		lv = 45,
		task_id = 0,
		type = 0,
		begin_time = 0,
		end_time = 0,
		consume = []
	},  
 	#function_conf{
		id = 39,
		name = xmerl_ucs:to_utf8("胜者为王"),
		lv = 40,
		task_id = 0,
		type = 0,
		begin_time = 0,
		end_time = 0,
		consume = []
	},  
 	#function_conf{
		id = 40,
		name = xmerl_ucs:to_utf8("开服活动"),
		lv = 0,
		task_id = 0,
		type = 0,
		begin_time = 0,
		end_time = 0,
		consume = []
	},  
 	#function_conf{
		id = 41,
		name = xmerl_ucs:to_utf8("限时活动"),
		lv = 0,
		task_id = 0,
		type = 0,
		begin_time = 0,
		end_time = 0,
		consume = []
	},  
 	#function_conf{
		id = 42,
		name = xmerl_ucs:to_utf8("竞技活动"),
		lv = 0,
		task_id = 0,
		type = 0,
		begin_time = 0,
		end_time = 0,
		consume = []
	},  
 	#function_conf{
		id = 43,
		name = xmerl_ucs:to_utf8("行会Boss"),
		lv = 0,
		task_id = 0,
		type = 0,
		begin_time = 0,
		end_time = 0,
		consume = []
	},  
 	#function_conf{
		id = 44,
		name = xmerl_ucs:to_utf8("行会秘境"),
		lv = 0,
		task_id = 0,
		type = 0,
		begin_time = 0,
		end_time = 0,
		consume = []
	},  
 	#function_conf{
		id = 45,
		name = xmerl_ucs:to_utf8("屠龙大会"),
		lv = 45,
		task_id = 0,
		type = 1,
		begin_time = 0,
		end_time = 0,
		consume = []
	},  
 	#function_conf{
		id = 46,
		name = xmerl_ucs:to_utf8("屠龙大会"),
		lv = 45,
		task_id = 0,
		type = 1,
		begin_time = 0,
		end_time = 0,
		consume = []
	},  
 	#function_conf{
		id = 47,
		name = xmerl_ucs:to_utf8("胜者为王1"),
		lv = 40,
		task_id = 0,
		type = 1,
		begin_time = 0,
		end_time = 0,
		consume = []
	},  
 	#function_conf{
		id = 48,
		name = xmerl_ucs:to_utf8("胜者为王1"),
		lv = 40,
		task_id = 0,
		type = 1,
		begin_time = 0,
		end_time = 0,
		consume = []
	},  
 	#function_conf{
		id = 49,
		name = xmerl_ucs:to_utf8("未知暗殿每天"),
		lv = 50,
		task_id = 0,
		type = 1,
		begin_time = {0,{0,0}},
		end_time = {999,{0,0}},
		consume = []
	},  
 	#function_conf{
		id = 50,
		name = xmerl_ucs:to_utf8("未知暗殿每天"),
		lv = 50,
		task_id = 0,
		type = 1,
		begin_time = {0,{0,0}},
		end_time = {999,{0,0}},
		consume = []
	},  
 	#function_conf{
		id = 51,
		name = xmerl_ucs:to_utf8("攻城战"),
		lv = 41,
		task_id = 0,
		type = 1,
		begin_time = 0,
		end_time = 0,
		consume = []
	},  
 	#function_conf{
		id = 52,
		name = xmerl_ucs:to_utf8("攻城战"),
		lv = 41,
		task_id = 0,
		type = 1,
		begin_time = 0,
		end_time = 0,
		consume = []
	},  
 	#function_conf{
		id = 53,
		name = xmerl_ucs:to_utf8("行会Boss"),
		lv = 0,
		task_id = 0,
		type = 1,
		begin_time = 0,
		end_time = 0,
		consume = []
	},  
 	#function_conf{
		id = 54,
		name = xmerl_ucs:to_utf8("行会Boss"),
		lv = 0,
		task_id = 0,
		type = 1,
		begin_time = 0,
		end_time = 0,
		consume = []
	},  
 	#function_conf{
		id = 55,
		name = xmerl_ucs:to_utf8("行会秘境"),
		lv = 0,
		task_id = 0,
		type = 1,
		begin_time = 0,
		end_time = 0,
		consume = []
	},  
 	#function_conf{
		id = 56,
		name = xmerl_ucs:to_utf8("行会秘境"),
		lv = 0,
		task_id = 0,
		type = 1,
		begin_time = 0,
		end_time = 0,
		consume = []
	},  
 	#function_conf{
		id = 57,
		name = xmerl_ucs:to_utf8("沙城秘境"),
		lv = 0,
		task_id = 0,
		type = 1,
		begin_time = 0,
		end_time = 0,
		consume = []
	},  
 	#function_conf{
		id = 58,
		name = xmerl_ucs:to_utf8("沙城秘境"),
		lv = 0,
		task_id = 0,
		type = 1,
		begin_time = 0,
		end_time = 0,
		consume = []
	},  
 	#function_conf{
		id = 59,
		name = xmerl_ucs:to_utf8("胜者为王2"),
		lv = 40,
		task_id = 0,
		type = 1,
		begin_time = 0,
		end_time = 0,
		consume = []
	},  
 	#function_conf{
		id = 60,
		name = xmerl_ucs:to_utf8("胜者为王2"),
		lv = 40,
		task_id = 0,
		type = 1,
		begin_time = 0,
		end_time = 0,
		consume = []
	},  
 	#function_conf{
		id = 61,
		name = xmerl_ucs:to_utf8("未知暗殿周末"),
		lv = 50,
		task_id = 0,
		type = 1,
		begin_time = {0,{0,0}},
		end_time = {999,{0,0}},
		consume = []
	},  
 	#function_conf{
		id = 62,
		name = xmerl_ucs:to_utf8("未知暗殿周末"),
		lv = 50,
		task_id = 0,
		type = 1,
		begin_time = {0,{0,0}},
		end_time = {999,{0,0}},
		consume = []
	},  
 	#function_conf{
		id = 63,
		name = xmerl_ucs:to_utf8("开服红包1"),
		lv = 200,
		task_id = 0,
		type = 0,
		begin_time = 0,
		end_time = 0,
		consume = []
	},  
 	#function_conf{
		id = 64,
		name = xmerl_ucs:to_utf8("开服红包2"),
		lv = 200,
		task_id = 0,
		type = 0,
		begin_time = 0,
		end_time = 0,
		consume = []
	},  
 	#function_conf{
		id = 65,
		name = xmerl_ucs:to_utf8("开服红包3"),
		lv = 200,
		task_id = 0,
		type = 0,
		begin_time = 0,
		end_time = 0,
		consume = []
	},  
 	#function_conf{
		id = 66,
		name = xmerl_ucs:to_utf8("开服红包4"),
		lv = 200,
		task_id = 0,
		type = 0,
		begin_time = 0,
		end_time = 0,
		consume = []
	},  
 	#function_conf{
		id = 67,
		name = xmerl_ucs:to_utf8("开服红包5"),
		lv = 200,
		task_id = 0,
		type = 0,
		begin_time = 0,
		end_time = 0,
		consume = []
	},  
 	#function_conf{
		id = 68,
		name = xmerl_ucs:to_utf8("强化继承"),
		lv = 52,
		task_id = 0,
		type = 0,
		begin_time = 0,
		end_time = 0,
		consume = []
	},  
 	#function_conf{
		id = 69,
		name = xmerl_ucs:to_utf8("装备铸魂"),
		lv = 51,
		task_id = 0,
		type = 0,
		begin_time = 0,
		end_time = 0,
		consume = []
	},  
 	#function_conf{
		id = 70,
		name = xmerl_ucs:to_utf8("行会红包"),
		lv = 200,
		task_id = 0,
		type = 0,
		begin_time = 0,
		end_time = 0,
		consume = []
	},  
 	#function_conf{
		id = 71,
		name = xmerl_ucs:to_utf8("幸运转盘"),
		lv = 0,
		task_id = 0,
		type = 0,
		begin_time = {0,{0,0}},
		end_time = {3,{0,0}},
		consume = [{1,[{1,20},{10,180}]},{2,[{1,50},{10,450}]},{3,[{1,50},{10,450}]},{4,[{1,80},{10,720}]}]
	},  
 	#function_conf{
		id = 72,
		name = xmerl_ucs:to_utf8("行会宣战"),
		lv = 0,
		task_id = 0,
		type = 1,
		begin_time = 0,
		end_time = 0,
		consume = []
	},  
 	#function_conf{
		id = 73,
		name = xmerl_ucs:to_utf8("怪物攻城"),
		lv = 50,
		task_id = 0,
		type = 1,
		begin_time = 0,
		end_time = 0,
		consume = []
	},  
 	#function_conf{
		id = 74,
		name = xmerl_ucs:to_utf8("怪物攻城"),
		lv = 50,
		task_id = 0,
		type = 1,
		begin_time = 0,
		end_time = 0,
		consume = []
	},  
 	#function_conf{
		id = 75,
		name = xmerl_ucs:to_utf8("怪物攻城"),
		lv = 50,
		task_id = 0,
		type = 0,
		begin_time = 0,
		end_time = 0,
		consume = []
	},  
 	#function_conf{
		id = 76,
		name = xmerl_ucs:to_utf8("神秘探宝"),
		lv = 999,
		task_id = 0,
		type = 0,
		begin_time = {3,{0,0}},
		end_time = {999,{0,0}},
		consume = []
	},  
 	#function_conf{
		id = 77,
		name = xmerl_ucs:to_utf8("精彩活动"),
		lv = 0,
		task_id = 0,
		type = 1,
		begin_time = 0,
		end_time = 0,
		consume = []
	},  
 	#function_conf{
		id = 78,
		name = xmerl_ucs:to_utf8("装备展示"),
		lv = 0,
		task_id = 0,
		type = 0,
		begin_time = 0,
		end_time = 0,
		consume = []
	},  
 	#function_conf{
		id = 79,
		name = xmerl_ucs:to_utf8("智慧答题"),
		lv = 999,
		task_id = 0,
		type = 1,
		begin_time = 0,
		end_time = 0,
		consume = []
	},  
 	#function_conf{
		id = 80,
		name = xmerl_ucs:to_utf8("个人BOSS之家"),
		lv = 55,
		task_id = 0,
		type = 0,
		begin_time = 0,
		end_time = 0,
		consume = []
	},  
 	#function_conf{
		id = 81,
		name = xmerl_ucs:to_utf8("跨服BOSS"),
		lv = 999,
		task_id = 0,
		type = 0,
		begin_time = 0,
		end_time = 0,
		consume = []
	},  
 	#function_conf{
		id = 82,
		name = xmerl_ucs:to_utf8("智慧答题"),
		lv = 999,
		task_id = 0,
		type = 1,
		begin_time = 0,
		end_time = 0,
		consume = []
	},  
 	#function_conf{
		id = 83,
		name = xmerl_ucs:to_utf8("藏宝图任务"),
		lv = 55,
		task_id = 0,
		type = 0,
		begin_time = 0,
		end_time = 0,
		consume = []
	},  
 	#function_conf{
		id = 84,
		name = xmerl_ucs:to_utf8("跨服火龙神殿"),
		lv = 999,
		task_id = 0,
		type = 1,
		begin_time = {7,{0,0}},
		end_time = {999,{0,0}},
		consume = []
	},  
 	#function_conf{
		id = 85,
		name = xmerl_ucs:to_utf8("节日活动"),
		lv = 999,
		task_id = 0,
		type = 0,
		begin_time = 0,
		end_time = 0,
		consume = []
	},  
 	#function_conf{
		id = 86,
		name = xmerl_ucs:to_utf8("跨服暗殿每天"),
		lv = 999,
		task_id = 0,
		type = 1,
		begin_time = {7,{0,0}},
		end_time = {999,{0,0}},
		consume = []
	},  
 	#function_conf{
		id = 87,
		name = xmerl_ucs:to_utf8("合服雪山"),
		lv = 999,
		task_id = 0,
		type = 0,
		begin_time = 0,
		end_time = 0,
		consume = []
	},  
 	#function_conf{
		id = 88,
		name = xmerl_ucs:to_utf8("一生一次"),
		lv = 45,
		task_id = 0,
		type = 0,
		begin_time = 0,
		end_time = 0,
		consume = []
	},  
 	#function_conf{
		id = 89,
		name = xmerl_ucs:to_utf8("合服活动"),
		lv = 1,
		task_id = 0,
		type = 0,
		begin_time = 0,
		end_time = 0,
		consume = []
	},  
 	#function_conf{
		id = 90,
		name = xmerl_ucs:to_utf8("神皇秘境"),
		lv = 0,
		task_id = 0,
		type = 0,
		begin_time = 0,
		end_time = 0,
		consume = [{1,[{1,200},{5,950},{10,1800}]},{2,[{1,200},{5,900},{10,1800}]},{3,[{1,200},{5,900},{10,1800}]}]
	},  
 	#function_conf{
		id = 91,
		name = xmerl_ucs:to_utf8("跨服暗殿每天"),
		lv = 999,
		task_id = 0,
		type = 1,
		begin_time = {7,{0,0}},
		end_time = {999,{0,0}},
		consume = []
	},  
 	#function_conf{
		id = 92,
		name = xmerl_ucs:to_utf8("跨服暗殿每天"),
		lv = 999,
		task_id = 0,
		type = 1,
		begin_time = {7,{0,0}},
		end_time = {999,{0,0}},
		consume = []
	},  
 	#function_conf{
		id = 93,
		name = xmerl_ucs:to_utf8("王城乱斗"),
		lv = 80,
		task_id = 0,
		type = 1,
		begin_time = 0,
		end_time = 0,
		consume = []
	},  
 	#function_conf{
		id = 94,
		name = xmerl_ucs:to_utf8("王城乱斗"),
		lv = 80,
		task_id = 0,
		type = 1,
		begin_time = 0,
		end_time = 0,
		consume = []
	},  
 	#function_conf{
		id = 95,
		name = xmerl_ucs:to_utf8("王城乱斗"),
		lv = 80,
		task_id = 0,
		type = 1,
		begin_time = 0,
		end_time = 0,
		consume = []
	},  
 	#function_conf{
		id = 96,
		name = xmerl_ucs:to_utf8("行会结盟"),
		lv = 80,
		task_id = 0,
		type = 1,
		begin_time = 0,
		end_time = 0,
		consume = []
	},  
 	#function_conf{
		id = 97,
		name = xmerl_ucs:to_utf8("跨服暗殿周末"),
		lv = 999,
		task_id = 0,
		type = 1,
		begin_time = {7,{0,0}},
		end_time = {999,{0,0}},
		consume = []
	},  
 	#function_conf{
		id = 98,
		name = xmerl_ucs:to_utf8("跨服暗殿周末"),
		lv = 999,
		task_id = 0,
		type = 1,
		begin_time = {7,{0,0}},
		end_time = {999,{0,0}},
		consume = []
	},  
 	#function_conf{
		id = 99,
		name = xmerl_ucs:to_utf8("跨服暗殿周末"),
		lv = 999,
		task_id = 0,
		type = 1,
		begin_time = {7,{0,0}},
		end_time = {999,{0,0}},
		consume = []
	},  
 	#function_conf{
		id = 100,
		name = xmerl_ucs:to_utf8("未知暗殿周末"),
		lv = 50,
		task_id = 0,
		type = 0,
		begin_time = {0,{0,0}},
		end_time = {999,{0,0}},
		consume = []
	},  
 	#function_conf{
		id = 101,
		name = xmerl_ucs:to_utf8("全服双倍经验"),
		lv = 0,
		task_id = 0,
		type = 0,
		begin_time = 0,
		end_time = 0,
		consume = []
	},  
 	#function_conf{
		id = 102,
		name = xmerl_ucs:to_utf8("跨服火龙神殿"),
		lv = 999,
		task_id = 0,
		type = 1,
		begin_time = {7,{0,0}},
		end_time = {999,{0,0}},
		consume = []
	},  
 	#function_conf{
		id = 103,
		name = xmerl_ucs:to_utf8("本服火龙神殿（每日）"),
		lv = 50,
		task_id = 0,
		type = 0,
		begin_time = {0,{0,0}},
		end_time = {999,{0,0}},
		consume = []
	},  
 	#function_conf{
		id = 104,
		name = xmerl_ucs:to_utf8("本服火龙神殿（每日）"),
		lv = 50,
		task_id = 0,
		type = 1,
		begin_time = {0,{0,0}},
		end_time = {999,{0,0}},
		consume = []
	},  
 	#function_conf{
		id = 105,
		name = xmerl_ucs:to_utf8("本服火龙神殿（每日）"),
		lv = 50,
		task_id = 0,
		type = 1,
		begin_time = {0,{0,0}},
		end_time = {999,{0,0}},
		consume = []
	},  
 	#function_conf{
		id = 106,
		name = xmerl_ucs:to_utf8("跨服火龙神殿（周末）"),
		lv = 999,
		task_id = 0,
		type = 0,
		begin_time = {7,{0,0}},
		end_time = {999,{0,0}},
		consume = []
	},  
 	#function_conf{
		id = 107,
		name = xmerl_ucs:to_utf8("跨服火龙神殿（周末）"),
		lv = 999,
		task_id = 0,
		type = 1,
		begin_time = {7,{0,0}},
		end_time = {999,{0,0}},
		consume = []
	},  
 	#function_conf{
		id = 108,
		name = xmerl_ucs:to_utf8("跨服火龙神殿（周末）"),
		lv = 999,
		task_id = 0,
		type = 1,
		begin_time = {7,{0,0}},
		end_time = {999,{0,0}},
		consume = []
	},  
 	#function_conf{
		id = 109,
		name = xmerl_ucs:to_utf8("本服火龙神殿（周末）"),
		lv = 50,
		task_id = 0,
		type = 0,
		begin_time = {0,{0,0}},
		end_time = {999,{0,0}},
		consume = []
	},  
 	#function_conf{
		id = 110,
		name = xmerl_ucs:to_utf8("本服火龙神殿（周末）"),
		lv = 50,
		task_id = 0,
		type = 1,
		begin_time = {0,{0,0}},
		end_time = {999,{0,0}},
		consume = []
	},  
 	#function_conf{
		id = 111,
		name = xmerl_ucs:to_utf8("本服火龙神殿（周末）"),
		lv = 50,
		task_id = 0,
		type = 1,
		begin_time = {0,{0,0}},
		end_time = {999,{0,0}},
		consume = []
	},  
 	#function_conf{
		id = 112,
		name = xmerl_ucs:to_utf8("跨服幻境之地"),
		lv = 999,
		task_id = 0,
		type = 0,
		begin_time = {7,{0,0}},
		end_time = {999,{0,0}},
		consume = []
	},  
 	#function_conf{
		id = 113,
		name = xmerl_ucs:to_utf8("跨服幻境之地"),
		lv = 999,
		task_id = 0,
		type = 1,
		begin_time = {7,{0,0}},
		end_time = {999,{0,0}},
		consume = []
	},  
 	#function_conf{
		id = 114,
		name = xmerl_ucs:to_utf8("跨服幻境之地"),
		lv = 999,
		task_id = 0,
		type = 1,
		begin_time = {7,{0,0}},
		end_time = {999,{0,0}},
		consume = []
	},  
 	#function_conf{
		id = 115,
		name = xmerl_ucs:to_utf8("幻境之地"),
		lv = 60,
		task_id = 0,
		type = 0,
		begin_time = {0,{0,0}},
		end_time = {999,{0,0}},
		consume = []
	},  
 	#function_conf{
		id = 116,
		name = xmerl_ucs:to_utf8("幻境之地"),
		lv = 60,
		task_id = 0,
		type = 1,
		begin_time = {0,{0,0}},
		end_time = {999,{0,0}},
		consume = []
	},  
 	#function_conf{
		id = 117,
		name = xmerl_ucs:to_utf8("幻境之地"),
		lv = 60,
		task_id = 0,
		type = 1,
		begin_time = {0,{0,0}},
		end_time = {999,{0,0}},
		consume = []
	},  
 	#function_conf{
		id = 118,
		name = xmerl_ucs:to_utf8("敬请期待"),
		lv = 999,
		task_id = 0,
		type = 1,
		begin_time = 0,
		end_time = 0,
		consume = []
	},  
 	#function_conf{
		id = 119,
		name = xmerl_ucs:to_utf8("跨服变异地宫"),
		lv = 70,
		task_id = 0,
		type = 0,
		begin_time = 0,
		end_time = 0,
		consume = []
	},  
 	#function_conf{
		id = 120,
		name = xmerl_ucs:to_utf8("跨服变异地宫"),
		lv = 70,
		task_id = 0,
		type = 1,
		begin_time = 0,
		end_time = 0,
		consume = []
	},  
 	#function_conf{
		id = 121,
		name = xmerl_ucs:to_utf8("跨服变异地宫"),
		lv = 70,
		task_id = 0,
		type = 1,
		begin_time = 0,
		end_time = 0,
		consume = []
	},  
 	#function_conf{
		id = 122,
		name = xmerl_ucs:to_utf8("跨服火龙神殿"),
		lv = 999,
		task_id = 0,
		type = 1,
		begin_time = {7,{0,0}},
		end_time = {999,{0,0}},
		consume = []
	},  
 	#function_conf{
		id = 123,
		name = xmerl_ucs:to_utf8("跨服火龙神殿"),
		lv = 999,
		task_id = 0,
		type = 1,
		begin_time = {7,{0,0}},
		end_time = {999,{0,0}},
		consume = []
	},  
 	#function_conf{
		id = 124,
		name = xmerl_ucs:to_utf8("跨服火龙神殿（周末）"),
		lv = 999,
		task_id = 0,
		type = 1,
		begin_time = {7,{0,0}},
		end_time = {999,{0,0}},
		consume = []
	},  
 	#function_conf{
		id = 125,
		name = xmerl_ucs:to_utf8("跨服火龙神殿（周末）"),
		lv = 999,
		task_id = 0,
		type = 1,
		begin_time = {7,{0,0}},
		end_time = {999,{0,0}},
		consume = []
	},  
 	#function_conf{
		id = 126,
		name = xmerl_ucs:to_utf8("本服火龙神殿"),
		lv = 50,
		task_id = 0,
		type = 1,
		begin_time = {0,{0,0}},
		end_time = {999,{0,0}},
		consume = []
	},  
 	#function_conf{
		id = 127,
		name = xmerl_ucs:to_utf8("本服火龙神殿"),
		lv = 50,
		task_id = 0,
		type = 1,
		begin_time = {0,{0,0}},
		end_time = {999,{0,0}},
		consume = []
	},  
 	#function_conf{
		id = 128,
		name = xmerl_ucs:to_utf8("七天签到"),
		lv = 10,
		task_id = 0,
		type = 0,
		begin_time = 0,
		end_time = 0,
		consume = []
	}].

get(1) ->
	#function_conf{
		id = 1,
		name = xmerl_ucs:to_utf8("主线任务"),
		lv = 0,
		task_id = 0,
		type = 0,
		begin_time = 0,
		end_time = 0,
		consume = []
	};

get(2) ->
	#function_conf{
		id = 2,
		name = xmerl_ucs:to_utf8("角色"),
		lv = 0,
		task_id = 0,
		type = 0,
		begin_time = 0,
		end_time = 0,
		consume = []
	};

get(3) ->
	#function_conf{
		id = 3,
		name = xmerl_ucs:to_utf8("背包"),
		lv = 0,
		task_id = 0,
		type = 0,
		begin_time = 0,
		end_time = 0,
		consume = []
	};

get(4) ->
	#function_conf{
		id = 4,
		name = xmerl_ucs:to_utf8("技能"),
		lv = 0,
		task_id = 0,
		type = 0,
		begin_time = 0,
		end_time = 0,
		consume = []
	};

get(5) ->
	#function_conf{
		id = 5,
		name = xmerl_ucs:to_utf8("行会"),
		lv = 0,
		task_id = 0,
		type = 0,
		begin_time = 0,
		end_time = 0,
		consume = []
	};

get(6) ->
	#function_conf{
		id = 6,
		name = xmerl_ucs:to_utf8("社交（好友、"),
		lv = 0,
		task_id = 0,
		type = 0,
		begin_time = 0,
		end_time = 0,
		consume = []
	};

get(7) ->
	#function_conf{
		id = 7,
		name = xmerl_ucs:to_utf8("社交（邮件）"),
		lv = 0,
		task_id = 0,
		type = 0,
		begin_time = 0,
		end_time = 0,
		consume = []
	};

get(8) ->
	#function_conf{
		id = 8,
		name = xmerl_ucs:to_utf8("组队"),
		lv = 0,
		task_id = 0,
		type = 0,
		begin_time = 0,
		end_time = 0,
		consume = []
	};

get(9) ->
	#function_conf{
		id = 9,
		name = xmerl_ucs:to_utf8("系统设置"),
		lv = 0,
		task_id = 0,
		type = 0,
		begin_time = 0,
		end_time = 0,
		consume = []
	};

get(10) ->
	#function_conf{
		id = 10,
		name = xmerl_ucs:to_utf8("聊天系统"),
		lv = 0,
		task_id = 0,
		type = 0,
		begin_time = 0,
		end_time = 0,
		consume = []
	};

get(11) ->
	#function_conf{
		id = 11,
		name = xmerl_ucs:to_utf8("装备强化"),
		lv = 20,
		task_id = 0,
		type = 0,
		begin_time = 0,
		end_time = 0,
		consume = []
	};

get(12) ->
	#function_conf{
		id = 12,
		name = xmerl_ucs:to_utf8("装备洗练"),
		lv = 28,
		task_id = 0,
		type = 0,
		begin_time = 0,
		end_time = 0,
		consume = []
	};

get(13) ->
	#function_conf{
		id = 13,
		name = xmerl_ucs:to_utf8("装备打造"),
		lv = 30,
		task_id = 0,
		type = 0,
		begin_time = 0,
		end_time = 0,
		consume = []
	};

get(14) ->
	#function_conf{
		id = 14,
		name = xmerl_ucs:to_utf8("PK模式"),
		lv = 36,
		task_id = 0,
		type = 0,
		begin_time = 0,
		end_time = 0,
		consume = []
	};

get(15) ->
	#function_conf{
		id = 15,
		name = xmerl_ucs:to_utf8("首充"),
		lv = 0,
		task_id = 0,
		type = 0,
		begin_time = 0,
		end_time = 0,
		consume = []
	};

get(16) ->
	#function_conf{
		id = 16,
		name = xmerl_ucs:to_utf8("攻城战"),
		lv = 41,
		task_id = 0,
		type = 0,
		begin_time = 0,
		end_time = 0,
		consume = []
	};

get(17) ->
	#function_conf{
		id = 17,
		name = xmerl_ucs:to_utf8("今日目标"),
		lv = 38,
		task_id = 0,
		type = 0,
		begin_time = 0,
		end_time = 0,
		consume = []
	};

get(18) ->
	#function_conf{
		id = 18,
		name = xmerl_ucs:to_utf8("排位赛"),
		lv = 36,
		task_id = 0,
		type = 0,
		begin_time = 0,
		end_time = 0,
		consume = []
	};

get(19) ->
	#function_conf{
		id = 19,
		name = xmerl_ucs:to_utf8("日常活动"),
		lv = 0,
		task_id = 0,
		type = 0,
		begin_time = 0,
		end_time = 0,
		consume = []
	};

get(20) ->
	#function_conf{
		id = 20,
		name = xmerl_ucs:to_utf8("福利中心"),
		lv = 0,
		task_id = 0,
		type = 0,
		begin_time = 0,
		end_time = 0,
		consume = []
	};

get(21) ->
	#function_conf{
		id = 21,
		name = xmerl_ucs:to_utf8("商城"),
		lv = 0,
		task_id = 0,
		type = 0,
		begin_time = 0,
		end_time = 0,
		consume = []
	};

get(22) ->
	#function_conf{
		id = 22,
		name = xmerl_ucs:to_utf8("挂机"),
		lv = 200,
		task_id = 0,
		type = 0,
		begin_time = 0,
		end_time = 0,
		consume = []
	};

get(23) ->
	#function_conf{
		id = 23,
		name = xmerl_ucs:to_utf8("功勋任务"),
		lv = 38,
		task_id = 0,
		type = 0,
		begin_time = 0,
		end_time = 0,
		consume = []
	};

get(24) ->
	#function_conf{
		id = 24,
		name = xmerl_ucs:to_utf8("膜拜功能"),
		lv = 38,
		task_id = 0,
		type = 0,
		begin_time = 0,
		end_time = 0,
		consume = []
	};

get(25) ->
	#function_conf{
		id = 25,
		name = xmerl_ucs:to_utf8("世界BOSS"),
		lv = 20,
		task_id = 0,
		type = 0,
		begin_time = 0,
		end_time = 0,
		consume = []
	};

get(26) ->
	#function_conf{
		id = 26,
		name = xmerl_ucs:to_utf8("个人副本"),
		lv = 40,
		task_id = 0,
		type = 0,
		begin_time = 0,
		end_time = 0,
		consume = []
	};

get(27) ->
	#function_conf{
		id = 27,
		name = xmerl_ucs:to_utf8("分包下载"),
		lv = 200,
		task_id = 0,
		type = 0,
		begin_time = 0,
		end_time = 0,
		consume = []
	};

get(28) ->
	#function_conf{
		id = 28,
		name = xmerl_ucs:to_utf8("游戏攻略"),
		lv = 200,
		task_id = 0,
		type = 0,
		begin_time = 0,
		end_time = 0,
		consume = []
	};

get(29) ->
	#function_conf{
		id = 29,
		name = xmerl_ucs:to_utf8("充值"),
		lv = 0,
		task_id = 0,
		type = 0,
		begin_time = 0,
		end_time = 0,
		consume = []
	};

get(30) ->
	#function_conf{
		id = 30,
		name = xmerl_ucs:to_utf8("装备"),
		lv = 0,
		task_id = 0,
		type = 0,
		begin_time = 0,
		end_time = 0,
		consume = []
	};

get(31) ->
	#function_conf{
		id = 31,
		name = xmerl_ucs:to_utf8("提纯"),
		lv = 25,
		task_id = 0,
		type = 0,
		begin_time = 0,
		end_time = 0,
		consume = []
	};

get(32) ->
	#function_conf{
		id = 32,
		name = xmerl_ucs:to_utf8("分解"),
		lv = 200,
		task_id = 0,
		type = 0,
		begin_time = 0,
		end_time = 0,
		consume = []
	};

get(33) ->
	#function_conf{
		id = 33,
		name = xmerl_ucs:to_utf8("勋章"),
		lv = 38,
		task_id = 0,
		type = 0,
		begin_time = 0,
		end_time = 0,
		consume = []
	};

get(34) ->
	#function_conf{
		id = 34,
		name = xmerl_ucs:to_utf8("签到"),
		lv = 10,
		task_id = 0,
		type = 0,
		begin_time = 0,
		end_time = 0,
		consume = []
	};

get(35) ->
	#function_conf{
		id = 35,
		name = xmerl_ucs:to_utf8("交易所"),
		lv = 0,
		task_id = 0,
		type = 0,
		begin_time = 0,
		end_time = 0,
		consume = []
	};

get(36) ->
	#function_conf{
		id = 36,
		name = xmerl_ucs:to_utf8("日常任务"),
		lv = 35,
		task_id = 0,
		type = 0,
		begin_time = 0,
		end_time = 0,
		consume = []
	};

get(37) ->
	#function_conf{
		id = 37,
		name = xmerl_ucs:to_utf8("未知暗殿"),
		lv = 50,
		task_id = 0,
		type = 0,
		begin_time = {0,{0,0}},
		end_time = {999,{0,0}},
		consume = []
	};

get(38) ->
	#function_conf{
		id = 38,
		name = xmerl_ucs:to_utf8("屠龙大会"),
		lv = 45,
		task_id = 0,
		type = 0,
		begin_time = 0,
		end_time = 0,
		consume = []
	};

get(39) ->
	#function_conf{
		id = 39,
		name = xmerl_ucs:to_utf8("胜者为王"),
		lv = 40,
		task_id = 0,
		type = 0,
		begin_time = 0,
		end_time = 0,
		consume = []
	};

get(40) ->
	#function_conf{
		id = 40,
		name = xmerl_ucs:to_utf8("开服活动"),
		lv = 0,
		task_id = 0,
		type = 0,
		begin_time = 0,
		end_time = 0,
		consume = []
	};

get(41) ->
	#function_conf{
		id = 41,
		name = xmerl_ucs:to_utf8("限时活动"),
		lv = 0,
		task_id = 0,
		type = 0,
		begin_time = 0,
		end_time = 0,
		consume = []
	};

get(42) ->
	#function_conf{
		id = 42,
		name = xmerl_ucs:to_utf8("竞技活动"),
		lv = 0,
		task_id = 0,
		type = 0,
		begin_time = 0,
		end_time = 0,
		consume = []
	};

get(43) ->
	#function_conf{
		id = 43,
		name = xmerl_ucs:to_utf8("行会Boss"),
		lv = 0,
		task_id = 0,
		type = 0,
		begin_time = 0,
		end_time = 0,
		consume = []
	};

get(44) ->
	#function_conf{
		id = 44,
		name = xmerl_ucs:to_utf8("行会秘境"),
		lv = 0,
		task_id = 0,
		type = 0,
		begin_time = 0,
		end_time = 0,
		consume = []
	};

get(45) ->
	#function_conf{
		id = 45,
		name = xmerl_ucs:to_utf8("屠龙大会"),
		lv = 45,
		task_id = 0,
		type = 1,
		begin_time = 0,
		end_time = 0,
		consume = []
	};

get(46) ->
	#function_conf{
		id = 46,
		name = xmerl_ucs:to_utf8("屠龙大会"),
		lv = 45,
		task_id = 0,
		type = 1,
		begin_time = 0,
		end_time = 0,
		consume = []
	};

get(47) ->
	#function_conf{
		id = 47,
		name = xmerl_ucs:to_utf8("胜者为王1"),
		lv = 40,
		task_id = 0,
		type = 1,
		begin_time = 0,
		end_time = 0,
		consume = []
	};

get(48) ->
	#function_conf{
		id = 48,
		name = xmerl_ucs:to_utf8("胜者为王1"),
		lv = 40,
		task_id = 0,
		type = 1,
		begin_time = 0,
		end_time = 0,
		consume = []
	};

get(49) ->
	#function_conf{
		id = 49,
		name = xmerl_ucs:to_utf8("未知暗殿每天"),
		lv = 50,
		task_id = 0,
		type = 1,
		begin_time = {0,{0,0}},
		end_time = {999,{0,0}},
		consume = []
	};

get(50) ->
	#function_conf{
		id = 50,
		name = xmerl_ucs:to_utf8("未知暗殿每天"),
		lv = 50,
		task_id = 0,
		type = 1,
		begin_time = {0,{0,0}},
		end_time = {999,{0,0}},
		consume = []
	};

get(51) ->
	#function_conf{
		id = 51,
		name = xmerl_ucs:to_utf8("攻城战"),
		lv = 41,
		task_id = 0,
		type = 1,
		begin_time = 0,
		end_time = 0,
		consume = []
	};

get(52) ->
	#function_conf{
		id = 52,
		name = xmerl_ucs:to_utf8("攻城战"),
		lv = 41,
		task_id = 0,
		type = 1,
		begin_time = 0,
		end_time = 0,
		consume = []
	};

get(53) ->
	#function_conf{
		id = 53,
		name = xmerl_ucs:to_utf8("行会Boss"),
		lv = 0,
		task_id = 0,
		type = 1,
		begin_time = 0,
		end_time = 0,
		consume = []
	};

get(54) ->
	#function_conf{
		id = 54,
		name = xmerl_ucs:to_utf8("行会Boss"),
		lv = 0,
		task_id = 0,
		type = 1,
		begin_time = 0,
		end_time = 0,
		consume = []
	};

get(55) ->
	#function_conf{
		id = 55,
		name = xmerl_ucs:to_utf8("行会秘境"),
		lv = 0,
		task_id = 0,
		type = 1,
		begin_time = 0,
		end_time = 0,
		consume = []
	};

get(56) ->
	#function_conf{
		id = 56,
		name = xmerl_ucs:to_utf8("行会秘境"),
		lv = 0,
		task_id = 0,
		type = 1,
		begin_time = 0,
		end_time = 0,
		consume = []
	};

get(57) ->
	#function_conf{
		id = 57,
		name = xmerl_ucs:to_utf8("沙城秘境"),
		lv = 0,
		task_id = 0,
		type = 1,
		begin_time = 0,
		end_time = 0,
		consume = []
	};

get(58) ->
	#function_conf{
		id = 58,
		name = xmerl_ucs:to_utf8("沙城秘境"),
		lv = 0,
		task_id = 0,
		type = 1,
		begin_time = 0,
		end_time = 0,
		consume = []
	};

get(59) ->
	#function_conf{
		id = 59,
		name = xmerl_ucs:to_utf8("胜者为王2"),
		lv = 40,
		task_id = 0,
		type = 1,
		begin_time = 0,
		end_time = 0,
		consume = []
	};

get(60) ->
	#function_conf{
		id = 60,
		name = xmerl_ucs:to_utf8("胜者为王2"),
		lv = 40,
		task_id = 0,
		type = 1,
		begin_time = 0,
		end_time = 0,
		consume = []
	};

get(61) ->
	#function_conf{
		id = 61,
		name = xmerl_ucs:to_utf8("未知暗殿周末"),
		lv = 50,
		task_id = 0,
		type = 1,
		begin_time = {0,{0,0}},
		end_time = {999,{0,0}},
		consume = []
	};

get(62) ->
	#function_conf{
		id = 62,
		name = xmerl_ucs:to_utf8("未知暗殿周末"),
		lv = 50,
		task_id = 0,
		type = 1,
		begin_time = {0,{0,0}},
		end_time = {999,{0,0}},
		consume = []
	};

get(63) ->
	#function_conf{
		id = 63,
		name = xmerl_ucs:to_utf8("开服红包1"),
		lv = 200,
		task_id = 0,
		type = 0,
		begin_time = 0,
		end_time = 0,
		consume = []
	};

get(64) ->
	#function_conf{
		id = 64,
		name = xmerl_ucs:to_utf8("开服红包2"),
		lv = 200,
		task_id = 0,
		type = 0,
		begin_time = 0,
		end_time = 0,
		consume = []
	};

get(65) ->
	#function_conf{
		id = 65,
		name = xmerl_ucs:to_utf8("开服红包3"),
		lv = 200,
		task_id = 0,
		type = 0,
		begin_time = 0,
		end_time = 0,
		consume = []
	};

get(66) ->
	#function_conf{
		id = 66,
		name = xmerl_ucs:to_utf8("开服红包4"),
		lv = 200,
		task_id = 0,
		type = 0,
		begin_time = 0,
		end_time = 0,
		consume = []
	};

get(67) ->
	#function_conf{
		id = 67,
		name = xmerl_ucs:to_utf8("开服红包5"),
		lv = 200,
		task_id = 0,
		type = 0,
		begin_time = 0,
		end_time = 0,
		consume = []
	};

get(68) ->
	#function_conf{
		id = 68,
		name = xmerl_ucs:to_utf8("强化继承"),
		lv = 52,
		task_id = 0,
		type = 0,
		begin_time = 0,
		end_time = 0,
		consume = []
	};

get(69) ->
	#function_conf{
		id = 69,
		name = xmerl_ucs:to_utf8("装备铸魂"),
		lv = 51,
		task_id = 0,
		type = 0,
		begin_time = 0,
		end_time = 0,
		consume = []
	};

get(70) ->
	#function_conf{
		id = 70,
		name = xmerl_ucs:to_utf8("行会红包"),
		lv = 200,
		task_id = 0,
		type = 0,
		begin_time = 0,
		end_time = 0,
		consume = []
	};

get(71) ->
	#function_conf{
		id = 71,
		name = xmerl_ucs:to_utf8("幸运转盘"),
		lv = 0,
		task_id = 0,
		type = 0,
		begin_time = {0,{0,0}},
		end_time = {3,{0,0}},
		consume = [{1,[{1,20},{10,180}]},{2,[{1,50},{10,450}]},{3,[{1,50},{10,450}]},{4,[{1,80},{10,720}]}]
	};

get(72) ->
	#function_conf{
		id = 72,
		name = xmerl_ucs:to_utf8("行会宣战"),
		lv = 0,
		task_id = 0,
		type = 1,
		begin_time = 0,
		end_time = 0,
		consume = []
	};

get(73) ->
	#function_conf{
		id = 73,
		name = xmerl_ucs:to_utf8("怪物攻城"),
		lv = 50,
		task_id = 0,
		type = 1,
		begin_time = 0,
		end_time = 0,
		consume = []
	};

get(74) ->
	#function_conf{
		id = 74,
		name = xmerl_ucs:to_utf8("怪物攻城"),
		lv = 50,
		task_id = 0,
		type = 1,
		begin_time = 0,
		end_time = 0,
		consume = []
	};

get(75) ->
	#function_conf{
		id = 75,
		name = xmerl_ucs:to_utf8("怪物攻城"),
		lv = 50,
		task_id = 0,
		type = 0,
		begin_time = 0,
		end_time = 0,
		consume = []
	};

get(76) ->
	#function_conf{
		id = 76,
		name = xmerl_ucs:to_utf8("神秘探宝"),
		lv = 999,
		task_id = 0,
		type = 0,
		begin_time = {3,{0,0}},
		end_time = {999,{0,0}},
		consume = []
	};

get(77) ->
	#function_conf{
		id = 77,
		name = xmerl_ucs:to_utf8("精彩活动"),
		lv = 0,
		task_id = 0,
		type = 1,
		begin_time = 0,
		end_time = 0,
		consume = []
	};

get(78) ->
	#function_conf{
		id = 78,
		name = xmerl_ucs:to_utf8("装备展示"),
		lv = 0,
		task_id = 0,
		type = 0,
		begin_time = 0,
		end_time = 0,
		consume = []
	};

get(79) ->
	#function_conf{
		id = 79,
		name = xmerl_ucs:to_utf8("智慧答题"),
		lv = 999,
		task_id = 0,
		type = 1,
		begin_time = 0,
		end_time = 0,
		consume = []
	};

get(80) ->
	#function_conf{
		id = 80,
		name = xmerl_ucs:to_utf8("个人BOSS之家"),
		lv = 55,
		task_id = 0,
		type = 0,
		begin_time = 0,
		end_time = 0,
		consume = []
	};

get(81) ->
	#function_conf{
		id = 81,
		name = xmerl_ucs:to_utf8("跨服BOSS"),
		lv = 999,
		task_id = 0,
		type = 0,
		begin_time = 0,
		end_time = 0,
		consume = []
	};

get(82) ->
	#function_conf{
		id = 82,
		name = xmerl_ucs:to_utf8("智慧答题"),
		lv = 999,
		task_id = 0,
		type = 1,
		begin_time = 0,
		end_time = 0,
		consume = []
	};

get(83) ->
	#function_conf{
		id = 83,
		name = xmerl_ucs:to_utf8("藏宝图任务"),
		lv = 55,
		task_id = 0,
		type = 0,
		begin_time = 0,
		end_time = 0,
		consume = []
	};

get(84) ->
	#function_conf{
		id = 84,
		name = xmerl_ucs:to_utf8("跨服火龙神殿"),
		lv = 999,
		task_id = 0,
		type = 1,
		begin_time = {7,{0,0}},
		end_time = {999,{0,0}},
		consume = []
	};

get(85) ->
	#function_conf{
		id = 85,
		name = xmerl_ucs:to_utf8("节日活动"),
		lv = 999,
		task_id = 0,
		type = 0,
		begin_time = 0,
		end_time = 0,
		consume = []
	};

get(86) ->
	#function_conf{
		id = 86,
		name = xmerl_ucs:to_utf8("跨服暗殿每天"),
		lv = 999,
		task_id = 0,
		type = 1,
		begin_time = {7,{0,0}},
		end_time = {999,{0,0}},
		consume = []
	};

get(87) ->
	#function_conf{
		id = 87,
		name = xmerl_ucs:to_utf8("合服雪山"),
		lv = 999,
		task_id = 0,
		type = 0,
		begin_time = 0,
		end_time = 0,
		consume = []
	};

get(88) ->
	#function_conf{
		id = 88,
		name = xmerl_ucs:to_utf8("一生一次"),
		lv = 45,
		task_id = 0,
		type = 0,
		begin_time = 0,
		end_time = 0,
		consume = []
	};

get(89) ->
	#function_conf{
		id = 89,
		name = xmerl_ucs:to_utf8("合服活动"),
		lv = 1,
		task_id = 0,
		type = 0,
		begin_time = 0,
		end_time = 0,
		consume = []
	};

get(90) ->
	#function_conf{
		id = 90,
		name = xmerl_ucs:to_utf8("神皇秘境"),
		lv = 0,
		task_id = 0,
		type = 0,
		begin_time = 0,
		end_time = 0,
		consume = [{1,[{1,200},{5,950},{10,1800}]},{2,[{1,200},{5,900},{10,1800}]},{3,[{1,200},{5,900},{10,1800}]}]
	};

get(91) ->
	#function_conf{
		id = 91,
		name = xmerl_ucs:to_utf8("跨服暗殿每天"),
		lv = 999,
		task_id = 0,
		type = 1,
		begin_time = {7,{0,0}},
		end_time = {999,{0,0}},
		consume = []
	};

get(92) ->
	#function_conf{
		id = 92,
		name = xmerl_ucs:to_utf8("跨服暗殿每天"),
		lv = 999,
		task_id = 0,
		type = 1,
		begin_time = {7,{0,0}},
		end_time = {999,{0,0}},
		consume = []
	};

get(93) ->
	#function_conf{
		id = 93,
		name = xmerl_ucs:to_utf8("王城乱斗"),
		lv = 80,
		task_id = 0,
		type = 1,
		begin_time = 0,
		end_time = 0,
		consume = []
	};

get(94) ->
	#function_conf{
		id = 94,
		name = xmerl_ucs:to_utf8("王城乱斗"),
		lv = 80,
		task_id = 0,
		type = 1,
		begin_time = 0,
		end_time = 0,
		consume = []
	};

get(95) ->
	#function_conf{
		id = 95,
		name = xmerl_ucs:to_utf8("王城乱斗"),
		lv = 80,
		task_id = 0,
		type = 1,
		begin_time = 0,
		end_time = 0,
		consume = []
	};

get(96) ->
	#function_conf{
		id = 96,
		name = xmerl_ucs:to_utf8("行会结盟"),
		lv = 80,
		task_id = 0,
		type = 1,
		begin_time = 0,
		end_time = 0,
		consume = []
	};

get(97) ->
	#function_conf{
		id = 97,
		name = xmerl_ucs:to_utf8("跨服暗殿周末"),
		lv = 999,
		task_id = 0,
		type = 1,
		begin_time = {7,{0,0}},
		end_time = {999,{0,0}},
		consume = []
	};

get(98) ->
	#function_conf{
		id = 98,
		name = xmerl_ucs:to_utf8("跨服暗殿周末"),
		lv = 999,
		task_id = 0,
		type = 1,
		begin_time = {7,{0,0}},
		end_time = {999,{0,0}},
		consume = []
	};

get(99) ->
	#function_conf{
		id = 99,
		name = xmerl_ucs:to_utf8("跨服暗殿周末"),
		lv = 999,
		task_id = 0,
		type = 1,
		begin_time = {7,{0,0}},
		end_time = {999,{0,0}},
		consume = []
	};

get(100) ->
	#function_conf{
		id = 100,
		name = xmerl_ucs:to_utf8("未知暗殿周末"),
		lv = 50,
		task_id = 0,
		type = 0,
		begin_time = {0,{0,0}},
		end_time = {999,{0,0}},
		consume = []
	};

get(101) ->
	#function_conf{
		id = 101,
		name = xmerl_ucs:to_utf8("全服双倍经验"),
		lv = 0,
		task_id = 0,
		type = 0,
		begin_time = 0,
		end_time = 0,
		consume = []
	};

get(102) ->
	#function_conf{
		id = 102,
		name = xmerl_ucs:to_utf8("跨服火龙神殿"),
		lv = 999,
		task_id = 0,
		type = 1,
		begin_time = {7,{0,0}},
		end_time = {999,{0,0}},
		consume = []
	};

get(103) ->
	#function_conf{
		id = 103,
		name = xmerl_ucs:to_utf8("本服火龙神殿（每日）"),
		lv = 50,
		task_id = 0,
		type = 0,
		begin_time = {0,{0,0}},
		end_time = {999,{0,0}},
		consume = []
	};

get(104) ->
	#function_conf{
		id = 104,
		name = xmerl_ucs:to_utf8("本服火龙神殿（每日）"),
		lv = 50,
		task_id = 0,
		type = 1,
		begin_time = {0,{0,0}},
		end_time = {999,{0,0}},
		consume = []
	};

get(105) ->
	#function_conf{
		id = 105,
		name = xmerl_ucs:to_utf8("本服火龙神殿（每日）"),
		lv = 50,
		task_id = 0,
		type = 1,
		begin_time = {0,{0,0}},
		end_time = {999,{0,0}},
		consume = []
	};

get(106) ->
	#function_conf{
		id = 106,
		name = xmerl_ucs:to_utf8("跨服火龙神殿（周末）"),
		lv = 999,
		task_id = 0,
		type = 0,
		begin_time = {7,{0,0}},
		end_time = {999,{0,0}},
		consume = []
	};

get(107) ->
	#function_conf{
		id = 107,
		name = xmerl_ucs:to_utf8("跨服火龙神殿（周末）"),
		lv = 999,
		task_id = 0,
		type = 1,
		begin_time = {7,{0,0}},
		end_time = {999,{0,0}},
		consume = []
	};

get(108) ->
	#function_conf{
		id = 108,
		name = xmerl_ucs:to_utf8("跨服火龙神殿（周末）"),
		lv = 999,
		task_id = 0,
		type = 1,
		begin_time = {7,{0,0}},
		end_time = {999,{0,0}},
		consume = []
	};

get(109) ->
	#function_conf{
		id = 109,
		name = xmerl_ucs:to_utf8("本服火龙神殿（周末）"),
		lv = 50,
		task_id = 0,
		type = 0,
		begin_time = {0,{0,0}},
		end_time = {999,{0,0}},
		consume = []
	};

get(110) ->
	#function_conf{
		id = 110,
		name = xmerl_ucs:to_utf8("本服火龙神殿（周末）"),
		lv = 50,
		task_id = 0,
		type = 1,
		begin_time = {0,{0,0}},
		end_time = {999,{0,0}},
		consume = []
	};

get(111) ->
	#function_conf{
		id = 111,
		name = xmerl_ucs:to_utf8("本服火龙神殿（周末）"),
		lv = 50,
		task_id = 0,
		type = 1,
		begin_time = {0,{0,0}},
		end_time = {999,{0,0}},
		consume = []
	};

get(112) ->
	#function_conf{
		id = 112,
		name = xmerl_ucs:to_utf8("跨服幻境之地"),
		lv = 999,
		task_id = 0,
		type = 0,
		begin_time = {7,{0,0}},
		end_time = {999,{0,0}},
		consume = []
	};

get(113) ->
	#function_conf{
		id = 113,
		name = xmerl_ucs:to_utf8("跨服幻境之地"),
		lv = 999,
		task_id = 0,
		type = 1,
		begin_time = {7,{0,0}},
		end_time = {999,{0,0}},
		consume = []
	};

get(114) ->
	#function_conf{
		id = 114,
		name = xmerl_ucs:to_utf8("跨服幻境之地"),
		lv = 999,
		task_id = 0,
		type = 1,
		begin_time = {7,{0,0}},
		end_time = {999,{0,0}},
		consume = []
	};

get(115) ->
	#function_conf{
		id = 115,
		name = xmerl_ucs:to_utf8("幻境之地"),
		lv = 60,
		task_id = 0,
		type = 0,
		begin_time = {0,{0,0}},
		end_time = {999,{0,0}},
		consume = []
	};

get(116) ->
	#function_conf{
		id = 116,
		name = xmerl_ucs:to_utf8("幻境之地"),
		lv = 60,
		task_id = 0,
		type = 1,
		begin_time = {0,{0,0}},
		end_time = {999,{0,0}},
		consume = []
	};

get(117) ->
	#function_conf{
		id = 117,
		name = xmerl_ucs:to_utf8("幻境之地"),
		lv = 60,
		task_id = 0,
		type = 1,
		begin_time = {0,{0,0}},
		end_time = {999,{0,0}},
		consume = []
	};

get(118) ->
	#function_conf{
		id = 118,
		name = xmerl_ucs:to_utf8("敬请期待"),
		lv = 999,
		task_id = 0,
		type = 1,
		begin_time = 0,
		end_time = 0,
		consume = []
	};

get(119) ->
	#function_conf{
		id = 119,
		name = xmerl_ucs:to_utf8("跨服变异地宫"),
		lv = 70,
		task_id = 0,
		type = 0,
		begin_time = 0,
		end_time = 0,
		consume = []
	};

get(120) ->
	#function_conf{
		id = 120,
		name = xmerl_ucs:to_utf8("跨服变异地宫"),
		lv = 70,
		task_id = 0,
		type = 1,
		begin_time = 0,
		end_time = 0,
		consume = []
	};

get(121) ->
	#function_conf{
		id = 121,
		name = xmerl_ucs:to_utf8("跨服变异地宫"),
		lv = 70,
		task_id = 0,
		type = 1,
		begin_time = 0,
		end_time = 0,
		consume = []
	};

get(122) ->
	#function_conf{
		id = 122,
		name = xmerl_ucs:to_utf8("跨服火龙神殿"),
		lv = 999,
		task_id = 0,
		type = 1,
		begin_time = {7,{0,0}},
		end_time = {999,{0,0}},
		consume = []
	};

get(123) ->
	#function_conf{
		id = 123,
		name = xmerl_ucs:to_utf8("跨服火龙神殿"),
		lv = 999,
		task_id = 0,
		type = 1,
		begin_time = {7,{0,0}},
		end_time = {999,{0,0}},
		consume = []
	};

get(124) ->
	#function_conf{
		id = 124,
		name = xmerl_ucs:to_utf8("跨服火龙神殿（周末）"),
		lv = 999,
		task_id = 0,
		type = 1,
		begin_time = {7,{0,0}},
		end_time = {999,{0,0}},
		consume = []
	};

get(125) ->
	#function_conf{
		id = 125,
		name = xmerl_ucs:to_utf8("跨服火龙神殿（周末）"),
		lv = 999,
		task_id = 0,
		type = 1,
		begin_time = {7,{0,0}},
		end_time = {999,{0,0}},
		consume = []
	};

get(126) ->
	#function_conf{
		id = 126,
		name = xmerl_ucs:to_utf8("本服火龙神殿"),
		lv = 50,
		task_id = 0,
		type = 1,
		begin_time = {0,{0,0}},
		end_time = {999,{0,0}},
		consume = []
	};

get(127) ->
	#function_conf{
		id = 127,
		name = xmerl_ucs:to_utf8("本服火龙神殿"),
		lv = 50,
		task_id = 0,
		type = 1,
		begin_time = {0,{0,0}},
		end_time = {999,{0,0}},
		consume = []
	};

get(128) ->
	#function_conf{
		id = 128,
		name = xmerl_ucs:to_utf8("七天签到"),
		lv = 10,
		task_id = 0,
		type = 0,
		begin_time = 0,
		end_time = 0,
		consume = []
	};

get(_Key) ->
	?ERR("undefined key from function_config ~p", [_Key]).