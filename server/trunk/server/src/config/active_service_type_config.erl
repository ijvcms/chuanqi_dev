%%%-------------------------------------------------------------------
%%% @author zhengsiying
%%% @doc
%%%		自动生成文件，不要手动修改
%%% @end
%%% Created : 2016/10/12
%%%-------------------------------------------------------------------

-module(active_service_type_config).

-include("common.hrl").
-include("config.hrl").

-compile([export_all]).

get_list_conf() ->
	[ active_service_type_config:get(X) || X <- get_list() ].

get_list() ->
	[1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15].

get_ui_list(1) ->
	[1, 2, 3, 4, 5, 6, 7, 8, 9];
get_ui_list(2) ->
	[10, 11, 12, 13, 14, 15].

get(1) ->
	#active_service_type_conf{
		id = 1,
		list_id = 1,
		receive_state = 1,
		name = xmerl_ucs:to_utf8("充值送大礼"),
		is_add = 1,
		begin_time = {0,{0,0}},
		end_time = {1,{0,0}},
		show_time = {1,{0,0}},
		value = 0,
		is_one = 1
	};

get(2) ->
	#active_service_type_conf{
		id = 2,
		list_id = 1,
		receive_state = 3,
		name = xmerl_ucs:to_utf8("强化折扣日"),
		is_add = 0,
		begin_time = {1,{0,0}},
		end_time = {1,{0,0}},
		show_time = {1,{0,0}},
		value = 0,
		is_one = 1
	};

get(3) ->
	#active_service_type_conf{
		id = 3,
		list_id = 1,
		receive_state = 1,
		name = xmerl_ucs:to_utf8("消耗元宝送物品"),
		is_add = 1,
		begin_time = {2,{0,0}},
		end_time = {1,{0,0}},
		show_time = {1,{0,0}},
		value = 0,
		is_one = 1
	};

get(4) ->
	#active_service_type_conf{
		id = 4,
		list_id = 1,
		receive_state = 1,
		name = xmerl_ucs:to_utf8("神秘商店回馈"),
		is_add = 1,
		begin_time = {3,{0,0}},
		end_time = {1,{0,0}},
		show_time = {1,{0,0}},
		value = 0,
		is_one = 1
	};

get(5) ->
	#active_service_type_conf{
		id = 5,
		list_id = 1,
		receive_state = 3,
		name = xmerl_ucs:to_utf8("印记折扣"),
		is_add = 0,
		begin_time = {4,{0,0}},
		end_time = {1,{0,0}},
		show_time = {1,{0,0}},
		value = 0,
		is_one = 1
	};

get(6) ->
	#active_service_type_conf{
		id = 6,
		list_id = 1,
		receive_state = 1,
		name = xmerl_ucs:to_utf8("神秘商店回馈"),
		is_add = 1,
		begin_time = {5,{0,0}},
		end_time = {1,{0,0}},
		show_time = {1,{0,0}},
		value = 0,
		is_one = 1
	};

get(7) ->
	#active_service_type_conf{
		id = 7,
		list_id = 1,
		receive_state = 1,
		name = xmerl_ucs:to_utf8("赤月紫装欢乐送"),
		is_add = 1,
		begin_time = {0,{0,0}},
		end_time = {7,{0,0}},
		show_time = {7,{0,0}},
		value = 0,
		is_one = 1
	};

get(8) ->
	#active_service_type_conf{
		id = 8,
		list_id = 1,
		receive_state = 0,
		name = xmerl_ucs:to_utf8("开服红包满天飞"),
		is_add = 0,
		begin_time = {0,{0,0}},
		end_time = {3,{0,0}},
		show_time = {3,{0,0}},
		value = 0,
		is_one = 0
	};

get(9) ->
	#active_service_type_conf{
		id = 9,
		list_id = 1,
		receive_state = 1,
		name = xmerl_ucs:to_utf8("首杀BOSS送大奖"),
		is_add = 0,
		begin_time = {0,{0,0}},
		end_time = {7,{0,0}},
		show_time = {7,{0,0}},
		value = 0,
		is_one = 0
	};

get(10) ->
	#active_service_type_conf{
		id = 10,
		list_id = 2,
		receive_state = 2,
		name = xmerl_ucs:to_utf8("    冲级达人榜"),
		is_add = 0,
		begin_time = {0,{0,0}},
		end_time = {1,{0,0}},
		show_time = {7,{0,0}},
		value = 60,
		is_one = 0
	};

get(11) ->
	#active_service_type_conf{
		id = 11,
		list_id = 2,
		receive_state = 2,
		name = xmerl_ucs:to_utf8("    装备强化榜"),
		is_add = 0,
		begin_time = {1,{0,0}},
		end_time = {1,{0,0}},
		show_time = {6,{0,0}},
		value = 180,
		is_one = 0
	};

get(12) ->
	#active_service_type_conf{
		id = 12,
		list_id = 2,
		receive_state = 2,
		name = xmerl_ucs:to_utf8("    翅膀进阶榜"),
		is_add = 0,
		begin_time = {2,{0,0}},
		end_time = {1,{0,0}},
		show_time = {5,{0,0}},
		value = 61,
		is_one = 0
	};

get(13) ->
	#active_service_type_conf{
		id = 13,
		list_id = 2,
		receive_state = 2,
		name = xmerl_ucs:to_utf8("    勋章升阶榜"),
		is_add = 0,
		begin_time = {3,{0,0}},
		end_time = {1,{0,0}},
		show_time = {4,{0,0}},
		value = 22,
		is_one = 0
	};

get(14) ->
	#active_service_type_conf{
		id = 14,
		list_id = 2,
		receive_state = 2,
		name = xmerl_ucs:to_utf8("    印记升级榜"),
		is_add = 0,
		begin_time = {4,{0,0}},
		end_time = {1,{0,0}},
		show_time = {3,{0,0}},
		value = 50,
		is_one = 0
	};

get(15) ->
	#active_service_type_conf{
		id = 15,
		list_id = 2,
		receive_state = 2,
		name = xmerl_ucs:to_utf8("    战力名人榜"),
		is_add = 0,
		begin_time = {5,{0,0}},
		end_time = {1,{0,0}},
		show_time = {2,{0,0}},
		value = 45000,
		is_one = 0
	};

get(_Key) ->
	?ERR("undefined key from active_service_type_config ~p", [_Key]).