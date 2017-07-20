%%%-------------------------------------------------------------------
%%% @author zhengsiying
%%% @doc
%%%		自动生成文件，不要手动修改
%%% @end
%%% Created : 2016/10/12
%%%-------------------------------------------------------------------

-module(szww_reward_config).

-include("common.hrl").
-include("config.hrl").

-compile([export_all]).

get_list_conf() ->
	[ szww_reward_config:get(X) || X <- get_list() ].

get_list() ->
	[1, 2, 3, 4, 5, 6, 7].

get(1) ->
	#szww_reward_conf{
		key = 1,
		min_rank = 1,
		max_rank = 1,
		mail_id = 24
	};

get(2) ->
	#szww_reward_conf{
		key = 2,
		min_rank = 2,
		max_rank = 2,
		mail_id = 25
	};

get(3) ->
	#szww_reward_conf{
		key = 3,
		min_rank = 3,
		max_rank = 3,
		mail_id = 26
	};

get(4) ->
	#szww_reward_conf{
		key = 4,
		min_rank = 4,
		max_rank = 5,
		mail_id = 27
	};

get(5) ->
	#szww_reward_conf{
		key = 5,
		min_rank = 6,
		max_rank = 10,
		mail_id = 28
	};

get(6) ->
	#szww_reward_conf{
		key = 6,
		min_rank = 11,
		max_rank = 50,
		mail_id = 29
	};

get(7) ->
	#szww_reward_conf{
		key = 7,
		min_rank = 51,
		max_rank = 99999,
		mail_id = 30
	};

get(_Key) ->
	?ERR("undefined key from szww_reward_config ~p", [_Key]).