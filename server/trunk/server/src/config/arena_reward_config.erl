%%%-------------------------------------------------------------------
%%% @author zhengsiying
%%% @doc
%%%		自动生成文件，不要手动修改
%%% @end
%%% Created : 2016/10/12
%%%-------------------------------------------------------------------

-module(arena_reward_config).

-include("common.hrl").
-include("config.hrl").

-compile([export_all]).

get_list_conf() ->
	[ arena_reward_config:get(X) || X <- get_list() ].

get_list() ->
	[1, 2, 3, 4, 5, 6, 7, 8, 9].

get(1) ->
	#arena_reward_conf{
		key = 1,
		min_rank = 1,
		max_rank = 1,
		coin = 20000,
		reputation = 300,
		goods_list = [{110003,1,6}],
		mail_id = 7
	};

get(2) ->
	#arena_reward_conf{
		key = 2,
		min_rank = 2,
		max_rank = 2,
		coin = 10000,
		reputation = 150,
		goods_list = [{110003,1,4}],
		mail_id = 8
	};

get(3) ->
	#arena_reward_conf{
		key = 3,
		min_rank = 3,
		max_rank = 3,
		coin = 5000,
		reputation = 100,
		goods_list = [{110003,1,4}],
		mail_id = 9
	};

get(4) ->
	#arena_reward_conf{
		key = 4,
		min_rank = 4,
		max_rank = 10,
		coin = 5000,
		reputation = 90,
		goods_list = [{110003,1,2}],
		mail_id = 10
	};

get(5) ->
	#arena_reward_conf{
		key = 5,
		min_rank = 11,
		max_rank = 50,
		coin = 5000,
		reputation = 80,
		goods_list = [{110003,1,2}],
		mail_id = 11
	};

get(6) ->
	#arena_reward_conf{
		key = 6,
		min_rank = 51,
		max_rank = 100,
		coin = 5000,
		reputation = 70,
		goods_list = [{110003,1,1}],
		mail_id = 12
	};

get(7) ->
	#arena_reward_conf{
		key = 7,
		min_rank = 101,
		max_rank = 500,
		coin = 5000,
		reputation = 60,
		goods_list = [{110003,1,1}],
		mail_id = 13
	};

get(8) ->
	#arena_reward_conf{
		key = 8,
		min_rank = 501,
		max_rank = 1000,
		coin = 5000,
		reputation = 50,
		goods_list = [{110003,1,1}],
		mail_id = 14
	};

get(9) ->
	#arena_reward_conf{
		key = 9,
		min_rank = 1001,
		max_rank = 10000,
		coin = 5000,
		reputation = 50,
		goods_list = [{110003,1,1}],
		mail_id = 14
	};

get(_Key) ->
	?ERR("undefined key from arena_reward_config ~p", [_Key]).