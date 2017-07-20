%%%-------------------------------------------------------------------
%%% @author zhengsiying
%%% @doc
%%%		自动生成文件，不要手动修改
%%% @end
%%% Created : 2016/10/12
%%%-------------------------------------------------------------------

-module(monster_attack_reward_config).

-include("common.hrl").
-include("config.hrl").

-compile([export_all]).

get_list_conf() ->
	[ monster_attack_reward_config:get(X) || X <- get_list() ].

get_list() ->
	[1, 2, 3, 4, 5, 6, 7].

get(1) ->
	#monster_attack_reward_conf{
		key = 1,
		min_rank = 1,
		max_rank = 1,
		win_mail_id = 69,
		lose_mail_id = 76
	};

get(2) ->
	#monster_attack_reward_conf{
		key = 2,
		min_rank = 2,
		max_rank = 2,
		win_mail_id = 70,
		lose_mail_id = 77
	};

get(3) ->
	#monster_attack_reward_conf{
		key = 3,
		min_rank = 3,
		max_rank = 3,
		win_mail_id = 71,
		lose_mail_id = 78
	};

get(4) ->
	#monster_attack_reward_conf{
		key = 4,
		min_rank = 4,
		max_rank = 5,
		win_mail_id = 72,
		lose_mail_id = 79
	};

get(5) ->
	#monster_attack_reward_conf{
		key = 5,
		min_rank = 6,
		max_rank = 10,
		win_mail_id = 73,
		lose_mail_id = 80
	};

get(6) ->
	#monster_attack_reward_conf{
		key = 6,
		min_rank = 11,
		max_rank = 50,
		win_mail_id = 74,
		lose_mail_id = 81
	};

get(7) ->
	#monster_attack_reward_conf{
		key = 7,
		min_rank = 51,
		max_rank = 99999,
		win_mail_id = 75,
		lose_mail_id = 82
	};

get(_Key) ->
	?ERR("undefined key from monster_attack_reward_config ~p", [_Key]).