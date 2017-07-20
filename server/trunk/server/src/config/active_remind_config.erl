%%%-------------------------------------------------------------------
%%% @author zhengsiying
%%% @doc
%%%		自动生成文件，不要手动修改
%%% @end
%%% Created : 2016/10/12
%%%-------------------------------------------------------------------

-module(active_remind_config).

-include("common.hrl").
-include("config.hrl").

-compile([export_all]).

get_list_conf() ->
	[ active_remind_config:get(X) || X <- get_list() ].

get_list() ->
	[1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19].

get(1) ->
	#active_remind_conf{
		key = 1,
		enter_limit = [{player_lv,45}],
		type = [1,2,3,4,5,6,7],
		time_list = [{45,{17,30,0},{17,59,59}},{46,{18,0,0},{18,30,0}}]
	};

get(2) ->
	#active_remind_conf{
		key = 2,
		enter_limit = [{player_lv,40}],
		type = [1,2,3,4,5,7],
		time_list = [{47,{14,30,0},{14,59,59}},{48,{15,0,0},{15,30,0}}]
	};

get(3) ->
	#active_remind_conf{
		key = 3,
		enter_limit = [{player_lv,40}],
		type = [1,2,3,4,5,7],
		time_list = []
	};

get(4) ->
	#active_remind_conf{
		key = 4,
		enter_limit = [{player_lv,50},{sbk_open_limit}],
		type = [1,2,3,4,5,7],
		time_list = [{73,{18,30,0},{19,0,0}},{74,{19,0,0},{19,45,0}}]
	};

get(5) ->
	#active_remind_conf{
		key = 5,
		enter_limit = [{player_lv,80}],
		type = [1,2,3,4,5],
		time_list = [{102,{22,30,0},{22,59,59}},{84,{23,0,0},{23,59,59}}]
	};

get(6) ->
	#active_remind_conf{
		key = 6,
		enter_limit = [{player_lv,60}],
		type = [1,2,3,4,5,6,7],
		time_list = [{91,{19,30,0},{19,59,59}},{92,{20,0,0},{20,30,0}}]
	};

get(7) ->
	#active_remind_conf{
		key = 7,
		enter_limit = [{player_lv,50}],
		type = [1,2,3,4,5,6,7],
		time_list = [{49,{19,30,0},{19,59,59}},{50,{20,0,0},{20,30,0}}]
	};

get(8) ->
	#active_remind_conf{
		key = 8,
		enter_limit = [{player_lv,60}],
		type = [1,2,3,4,5,6,7],
		time_list = [{98,{10,30,0},{11,0,0}},{99,{11,0,0},{11,30,0}}]
	};

get(9) ->
	#active_remind_conf{
		key = 9,
		enter_limit = [{player_lv,50}],
		type = [1,2,3,4,5,6,7],
		time_list = [{61,{10,30,0},{11,0,0}},{62,{11,0,0},{11,30,0}}]
	};

get(10) ->
	#active_remind_conf{
		key = 10,
		enter_limit = [],
		type = [1,2,3,4,5,6,7],
		time_list = [{101,{17,0,0},{18,0,0}}]
	};

get(11) ->
	#active_remind_conf{
		key = 11,
		enter_limit = [{player_lv,50}],
		type = [1,2,3,4,5,6,7],
		time_list = [{104,{22,30,0},{22,59,59}},{105,{23,0,0},{23,59,59}}]
	};

get(12) ->
	#active_remind_conf{
		key = 12,
		enter_limit = [{player_lv,50}],
		type = [6,7],
		time_list = [{110,{11,30,0},{11,59,59}},{111,{12,0,0},{13,0,0}}]
	};

get(13) ->
	#active_remind_conf{
		key = 13,
		enter_limit = [{player_lv,80}],
		type = [6,7],
		time_list = [{107,{22,30,0},{22,59,59}},{108,{23,0,0},{23,59,59}}]
	};

get(14) ->
	#active_remind_conf{
		key = 14,
		enter_limit = [{player_lv,70}],
		type = [1,2,3,4,5,7],
		time_list = [{113,{20,30,0},{20,59,59}},{114,{21,0,0},{21,45,0}}]
	};

get(15) ->
	#active_remind_conf{
		key = 15,
		enter_limit = [{player_lv,60}],
		type = [1,2,3,4,5,7],
		time_list = [{116,{20,30,0},{20,59,59}},{117,{21,0,0},{21,45,0}}]
	};

get(16) ->
	#active_remind_conf{
		key = 16,
		enter_limit = [{player_lv,70}],
		type = [1,2,3,4,5,6,7],
		time_list = [{120,{21,30,0},{21,59,59}},{121,{22,0,0},{23,0,0}}]
	};

get(17) ->
	#active_remind_conf{
		key = 17,
		enter_limit = [{player_lv,80}],
		type = [1,2,3,4,5],
		time_list = [{122,{11,30,0},{11,59,59}},{123,{12,0,0},{13,0,0}}]
	};

get(18) ->
	#active_remind_conf{
		key = 18,
		enter_limit = [{player_lv,80}],
		type = [6,7],
		time_list = [{124,{11,30,0},{11,59,59}},{125,{12,0,0},{13,0,0}}]
	};

get(19) ->
	#active_remind_conf{
		key = 19,
		enter_limit = [{player_lv,50}],
		type = [1,2,3,4,5],
		time_list = [{126,{11,30,0},{11,59,59}},{127,{12,0,0},{13,0,0}}]
	};

get(_Key) ->
	?ERR("undefined key from active_remind_config ~p", [_Key]).