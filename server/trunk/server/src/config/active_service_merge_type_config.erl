%%%-------------------------------------------------------------------
%%% @author zhengsiying
%%% @doc
%%%		自动生成文件，不要手动修改
%%% @end
%%% Created : 2016/10/12
%%%-------------------------------------------------------------------

-module(active_service_merge_type_config).

-include("common.hrl").
-include("config.hrl").

-compile([export_all]).

get_list_conf() ->
	[ active_service_merge_type_config:get(X) || X <- get_list() ].

get_list() ->
	[1, 2, 9, 15, 16, 17, 18, 19, 20].

get_ui_list(1) ->
	[1, 2, 9, 15, 16, 17, 18, 19, 20].

get(1) ->
	#active_service_merge_type_conf{
		id = 1,
		list_id = 1,
		receive_state = 1,
		name = xmerl_ucs:to_utf8("合服累充"),
		is_show = 1,
		is_add = 1,
		begin_time = {0,{0,0}},
		end_time = {3,{0,0}},
		show_time = {3,{0,0}},
		limit_lv = 0,
		value = 0,
		is_one = 1,
		sort = 3
	};

get(2) ->
	#active_service_merge_type_conf{
		id = 2,
		list_id = 1,
		receive_state = 3,
		name = xmerl_ucs:to_utf8("超值礼包"),
		is_show = 1,
		is_add = 1,
		begin_time = {3,{0,0}},
		end_time = {1,{0,0}},
		show_time = {1,{0,0}},
		limit_lv = 0,
		value = 0,
		is_one = 1,
		sort = 4
	};

get(9) ->
	#active_service_merge_type_conf{
		id = 9,
		list_id = 1,
		receive_state = 1,
		name = xmerl_ucs:to_utf8("首杀BOSS"),
		is_show = 1,
		is_add = 1,
		begin_time = {0,{0,0}},
		end_time = {5,{0,0}},
		show_time = {5,{0,0}},
		limit_lv = 0,
		value = 0,
		is_one = 0,
		sort = 6
	};

get(15) ->
	#active_service_merge_type_conf{
		id = 15,
		list_id = 1,
		receive_state = 2,
		name = xmerl_ucs:to_utf8("战力排名"),
		is_show = 1,
		is_add = 0,
		begin_time = {1,{0,0}},
		end_time = {1,{0,0}},
		show_time = {2,{0,0}},
		limit_lv = 0,
		value = 60000,
		is_one = 0,
		sort = 5
	};

get(16) ->
	#active_service_merge_type_conf{
		id = 16,
		list_id = 1,
		receive_state = 1,
		name = xmerl_ucs:to_utf8("合服首充"),
		is_show = 1,
		is_add = 1,
		begin_time = {0,{0,0}},
		end_time = {5,{0,0}},
		show_time = {5,{0,0}},
		limit_lv = 0,
		value = 0,
		is_one = 1,
		sort = 2
	};

get(17) ->
	#active_service_merge_type_conf{
		id = 17,
		list_id = 1,
		receive_state = 1,
		name = xmerl_ucs:to_utf8("登录大礼"),
		is_show = 1,
		is_add = 2,
		begin_time = {0,{0,0}},
		end_time = {5,{0,0}},
		show_time = {5,{0,0}},
		limit_lv = 50,
		value = 0,
		is_one = 1,
		sort = 1
	};

get(18) ->
	#active_service_merge_type_conf{
		id = 18,
		list_id = 1,
		receive_state = 0,
		name = xmerl_ucs:to_utf8("合服双倍"),
		is_show = 1,
		is_add = 1,
		begin_time = {0,{0,0}},
		end_time = {1,{0,0}},
		show_time = {1,{0,0}},
		limit_lv = 0,
		value = 0,
		is_one = 0,
		sort = 7
	};

get(19) ->
	#active_service_merge_type_conf{
		id = 19,
		list_id = 1,
		receive_state = 0,
		name = xmerl_ucs:to_utf8("合服攻城"),
		is_show = 1,
		is_add = 1,
		begin_time = {0,{0,0}},
		end_time = {5,{0,0}},
		show_time = {5,{0,0}},
		limit_lv = 0,
		value = 0,
		is_one = 0,
		sort = 8
	};

get(20) ->
	#active_service_merge_type_conf{
		id = 20,
		list_id = 1,
		receive_state = 0,
		name = xmerl_ucs:to_utf8("合服转盘"),
		is_show = 0,
		is_add = 1,
		begin_time = {5,{0,0}},
		end_time = {1,{0,0}},
		show_time = {1,{0,0}},
		limit_lv = 0,
		value = 3,
		is_one = 0,
		sort = 9
	};

get(_Key) ->
	?ERR("undefined key from active_service_merge_type_config ~p", [_Key]).