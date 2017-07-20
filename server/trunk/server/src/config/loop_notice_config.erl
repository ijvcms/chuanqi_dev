%%%-------------------------------------------------------------------
%%% @author zhengsiying
%%% @doc
%%%		自动生成文件，不要手动修改
%%% @end
%%% Created : 2016/10/12
%%%-------------------------------------------------------------------

-module(loop_notice_config).

-include("common.hrl").
-include("config.hrl").

-compile([export_all]).

get_list_conf() ->
	[ loop_notice_config:get(X) || X <- get_list() ].

get_list() ->
	[1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18].

get(1) ->
	#loop_notice_conf{
		key = 1,
		notice_id = 5,
		time_rule = {3, 6, {12,0}}
	};

get(2) ->
	#loop_notice_conf{
		key = 2,
		notice_id = 5,
		time_rule = {3, 6, {16,0}}
	};

get(3) ->
	#loop_notice_conf{
		key = 3,
		notice_id = 6,
		time_rule = {3, 6, {20,30}}
	};

get(4) ->
	#loop_notice_conf{
		key = 4,
		notice_id = 7,
		time_rule = {3, 6, {21,0}}
	};

get(5) ->
	#loop_notice_conf{
		key = 5,
		notice_id = 21,
		time_rule = {0, 0, {18,00}}
	};

get(6) ->
	#loop_notice_conf{
		key = 6,
		notice_id = 22,
		time_rule = {0, 0, {18,30}}
	};

get(7) ->
	#loop_notice_conf{
		key = 7,
		notice_id = 24,
		time_rule = {0, 0, {15,0}}
	};

get(8) ->
	#loop_notice_conf{
		key = 8,
		notice_id = 26,
		time_rule = {0, 0, {15,30}}
	};

get(9) ->
	#loop_notice_conf{
		key = 9,
		notice_id = 35,
		time_rule = {0, 0, {19,00}}
	};

get(10) ->
	#loop_notice_conf{
		key = 10,
		notice_id = 35,
		time_rule = {9999, 0, {19,00}}
	};

get(11) ->
	#loop_notice_conf{
		key = 11,
		notice_id = 63,
		time_rule = {0, 7, {17,00}}
	};

get(12) ->
	#loop_notice_conf{
		key = 12,
		notice_id = 64,
		time_rule = {0, 7, {18,00}}
	};

get(13) ->
	#loop_notice_conf{
		key = 13,
		notice_id = 68,
		time_rule = {0, 0, {22,00}}
	};

get(14) ->
	#loop_notice_conf{
		key = 14,
		notice_id = 69,
		time_rule = {0, 0, {23,59}}
	};

get(15) ->
	#loop_notice_conf{
		key = 15,
		notice_id = 68,
		time_rule = {0, 0, {12,00}}
	};

get(16) ->
	#loop_notice_conf{
		key = 16,
		notice_id = 69,
		time_rule = {0, 0, {12,59}}
	};

get(17) ->
	#loop_notice_conf{
		key = 17,
		notice_id = 74,
		time_rule = {0, 0, {21,00}}
	};

get(18) ->
	#loop_notice_conf{
		key = 18,
		notice_id = 75,
		time_rule = {0, 0, {21,45}}
	};

get(_Key) ->
	?ERR("undefined key from loop_notice_config ~p", [_Key]).