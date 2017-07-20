%%%-------------------------------------------------------------------
%%% @author zhengsiying
%%% @doc
%%%		自动生成文件，不要手动修改
%%% @end
%%% Created : 2016/10/12
%%%-------------------------------------------------------------------

-module(world_boss_reward_config).

-include("common.hrl").
-include("config.hrl").

-compile([export_all]).

get_list_conf() ->
	[ world_boss_reward_config:get(X) || X <- get_list() ].

get_list() ->
	[1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32, 33, 34, 35, 36, 37, 38, 39, 40, 41, 42].

get(1) ->
	#world_boss_reward_conf{
		key = 1,
		min_rank = 1,
		max_rank = 1,
		min_lv = 1,
		max_lv = 50,
		mail_id = 17
	};

get(2) ->
	#world_boss_reward_conf{
		key = 2,
		min_rank = 2,
		max_rank = 2,
		min_lv = 1,
		max_lv = 50,
		mail_id = 18
	};

get(3) ->
	#world_boss_reward_conf{
		key = 3,
		min_rank = 3,
		max_rank = 3,
		min_lv = 1,
		max_lv = 50,
		mail_id = 19
	};

get(4) ->
	#world_boss_reward_conf{
		key = 4,
		min_rank = 4,
		max_rank = 5,
		min_lv = 1,
		max_lv = 50,
		mail_id = 20
	};

get(5) ->
	#world_boss_reward_conf{
		key = 5,
		min_rank = 6,
		max_rank = 10,
		min_lv = 1,
		max_lv = 50,
		mail_id = 21
	};

get(6) ->
	#world_boss_reward_conf{
		key = 6,
		min_rank = 11,
		max_rank = 50,
		min_lv = 1,
		max_lv = 50,
		mail_id = 22
	};

get(7) ->
	#world_boss_reward_conf{
		key = 7,
		min_rank = 51,
		max_rank = 99999,
		min_lv = 1,
		max_lv = 50,
		mail_id = 23
	};

get(8) ->
	#world_boss_reward_conf{
		key = 8,
		min_rank = 1,
		max_rank = 1,
		min_lv = 51,
		max_lv = 60,
		mail_id = 31
	};

get(9) ->
	#world_boss_reward_conf{
		key = 9,
		min_rank = 2,
		max_rank = 2,
		min_lv = 51,
		max_lv = 60,
		mail_id = 32
	};

get(10) ->
	#world_boss_reward_conf{
		key = 10,
		min_rank = 3,
		max_rank = 3,
		min_lv = 51,
		max_lv = 60,
		mail_id = 33
	};

get(11) ->
	#world_boss_reward_conf{
		key = 11,
		min_rank = 4,
		max_rank = 5,
		min_lv = 51,
		max_lv = 60,
		mail_id = 34
	};

get(12) ->
	#world_boss_reward_conf{
		key = 12,
		min_rank = 6,
		max_rank = 10,
		min_lv = 51,
		max_lv = 60,
		mail_id = 35
	};

get(13) ->
	#world_boss_reward_conf{
		key = 13,
		min_rank = 11,
		max_rank = 50,
		min_lv = 51,
		max_lv = 60,
		mail_id = 36
	};

get(14) ->
	#world_boss_reward_conf{
		key = 14,
		min_rank = 51,
		max_rank = 99999,
		min_lv = 51,
		max_lv = 60,
		mail_id = 37
	};

get(15) ->
	#world_boss_reward_conf{
		key = 15,
		min_rank = 1,
		max_rank = 1,
		min_lv = 61,
		max_lv = 70,
		mail_id = 38
	};

get(16) ->
	#world_boss_reward_conf{
		key = 16,
		min_rank = 2,
		max_rank = 2,
		min_lv = 61,
		max_lv = 70,
		mail_id = 39
	};

get(17) ->
	#world_boss_reward_conf{
		key = 17,
		min_rank = 3,
		max_rank = 3,
		min_lv = 61,
		max_lv = 70,
		mail_id = 40
	};

get(18) ->
	#world_boss_reward_conf{
		key = 18,
		min_rank = 4,
		max_rank = 5,
		min_lv = 61,
		max_lv = 70,
		mail_id = 41
	};

get(19) ->
	#world_boss_reward_conf{
		key = 19,
		min_rank = 6,
		max_rank = 10,
		min_lv = 61,
		max_lv = 70,
		mail_id = 42
	};

get(20) ->
	#world_boss_reward_conf{
		key = 20,
		min_rank = 11,
		max_rank = 50,
		min_lv = 61,
		max_lv = 70,
		mail_id = 43
	};

get(21) ->
	#world_boss_reward_conf{
		key = 21,
		min_rank = 51,
		max_rank = 99999,
		min_lv = 61,
		max_lv = 70,
		mail_id = 44
	};

get(22) ->
	#world_boss_reward_conf{
		key = 22,
		min_rank = 1,
		max_rank = 1,
		min_lv = 71,
		max_lv = 80,
		mail_id = 45
	};

get(23) ->
	#world_boss_reward_conf{
		key = 23,
		min_rank = 2,
		max_rank = 2,
		min_lv = 71,
		max_lv = 80,
		mail_id = 46
	};

get(24) ->
	#world_boss_reward_conf{
		key = 24,
		min_rank = 3,
		max_rank = 3,
		min_lv = 71,
		max_lv = 80,
		mail_id = 47
	};

get(25) ->
	#world_boss_reward_conf{
		key = 25,
		min_rank = 4,
		max_rank = 5,
		min_lv = 71,
		max_lv = 80,
		mail_id = 48
	};

get(26) ->
	#world_boss_reward_conf{
		key = 26,
		min_rank = 6,
		max_rank = 10,
		min_lv = 71,
		max_lv = 80,
		mail_id = 49
	};

get(27) ->
	#world_boss_reward_conf{
		key = 27,
		min_rank = 11,
		max_rank = 50,
		min_lv = 71,
		max_lv = 80,
		mail_id = 50
	};

get(28) ->
	#world_boss_reward_conf{
		key = 28,
		min_rank = 51,
		max_rank = 99999,
		min_lv = 71,
		max_lv = 80,
		mail_id = 51
	};

get(29) ->
	#world_boss_reward_conf{
		key = 29,
		min_rank = 1,
		max_rank = 1,
		min_lv = 81,
		max_lv = 90,
		mail_id = 52
	};

get(30) ->
	#world_boss_reward_conf{
		key = 30,
		min_rank = 2,
		max_rank = 2,
		min_lv = 81,
		max_lv = 90,
		mail_id = 53
	};

get(31) ->
	#world_boss_reward_conf{
		key = 31,
		min_rank = 3,
		max_rank = 3,
		min_lv = 81,
		max_lv = 90,
		mail_id = 54
	};

get(32) ->
	#world_boss_reward_conf{
		key = 32,
		min_rank = 4,
		max_rank = 5,
		min_lv = 81,
		max_lv = 90,
		mail_id = 55
	};

get(33) ->
	#world_boss_reward_conf{
		key = 33,
		min_rank = 6,
		max_rank = 10,
		min_lv = 81,
		max_lv = 90,
		mail_id = 56
	};

get(34) ->
	#world_boss_reward_conf{
		key = 34,
		min_rank = 11,
		max_rank = 50,
		min_lv = 81,
		max_lv = 90,
		mail_id = 57
	};

get(35) ->
	#world_boss_reward_conf{
		key = 35,
		min_rank = 51,
		max_rank = 99999,
		min_lv = 81,
		max_lv = 90,
		mail_id = 58
	};

get(36) ->
	#world_boss_reward_conf{
		key = 36,
		min_rank = 1,
		max_rank = 1,
		min_lv = 91,
		max_lv = 999,
		mail_id = 59
	};

get(37) ->
	#world_boss_reward_conf{
		key = 37,
		min_rank = 2,
		max_rank = 2,
		min_lv = 91,
		max_lv = 999,
		mail_id = 60
	};

get(38) ->
	#world_boss_reward_conf{
		key = 38,
		min_rank = 3,
		max_rank = 3,
		min_lv = 91,
		max_lv = 999,
		mail_id = 61
	};

get(39) ->
	#world_boss_reward_conf{
		key = 39,
		min_rank = 4,
		max_rank = 5,
		min_lv = 91,
		max_lv = 999,
		mail_id = 62
	};

get(40) ->
	#world_boss_reward_conf{
		key = 40,
		min_rank = 6,
		max_rank = 10,
		min_lv = 91,
		max_lv = 999,
		mail_id = 63
	};

get(41) ->
	#world_boss_reward_conf{
		key = 41,
		min_rank = 11,
		max_rank = 50,
		min_lv = 91,
		max_lv = 999,
		mail_id = 64
	};

get(42) ->
	#world_boss_reward_conf{
		key = 42,
		min_rank = 51,
		max_rank = 99999,
		min_lv = 91,
		max_lv = 999,
		mail_id = 65
	};

get(_Key) ->
	?ERR("undefined key from world_boss_reward_config ~p", [_Key]).