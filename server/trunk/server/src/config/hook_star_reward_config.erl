%%%-------------------------------------------------------------------
%%% @author zhengsiying
%%% @doc
%%%		自动生成文件，不要手动修改
%%% @end
%%% Created : 2016/10/12
%%%-------------------------------------------------------------------

-module(hook_star_reward_config).

-include("common.hrl").
-include("config.hrl").

-compile([export_all]).

get_list_conf() ->
	[ hook_star_reward_config:get(X) || X <- get_list() ].

get_list() ->
	[1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20].

get(1) ->
	#hook_star_reward_conf{
		chapter = 1,
		step1_condition = 5,
		step1_reward = [{110009, 10000}],
		step2_condition = 10,
		step2_reward = [{110003, 10}],
		step3_condition = 15,
		step3_reward = [{110079, 5}]
	};

get(2) ->
	#hook_star_reward_conf{
		chapter = 2,
		step1_condition = 5,
		step1_reward = [{110009, 12000}],
		step2_condition = 10,
		step2_reward = [{110003, 10}],
		step3_condition = 15,
		step3_reward = [{110079, 5}]
	};

get(3) ->
	#hook_star_reward_conf{
		chapter = 3,
		step1_condition = 5,
		step1_reward = [{110009, 14000}],
		step2_condition = 10,
		step2_reward = [{110003, 10}],
		step3_condition = 15,
		step3_reward = [{110080, 5}]
	};

get(4) ->
	#hook_star_reward_conf{
		chapter = 4,
		step1_condition = 5,
		step1_reward = [{110009, 16000}],
		step2_condition = 10,
		step2_reward = [{110003, 10}],
		step3_condition = 15,
		step3_reward = [{110080, 5}]
	};

get(5) ->
	#hook_star_reward_conf{
		chapter = 5,
		step1_condition = 5,
		step1_reward = [{110009, 18000}],
		step2_condition = 10,
		step2_reward = [{110003, 10}],
		step3_condition = 15,
		step3_reward = [{110081, 5}]
	};

get(6) ->
	#hook_star_reward_conf{
		chapter = 6,
		step1_condition = 5,
		step1_reward = [{110009, 20000}],
		step2_condition = 10,
		step2_reward = [{110003, 10}],
		step3_condition = 15,
		step3_reward = [{110081, 5}]
	};

get(7) ->
	#hook_star_reward_conf{
		chapter = 7,
		step1_condition = 5,
		step1_reward = [{110009, 22000}],
		step2_condition = 10,
		step2_reward = [{110003, 10}],
		step3_condition = 15,
		step3_reward = [{110082, 5}]
	};

get(8) ->
	#hook_star_reward_conf{
		chapter = 8,
		step1_condition = 5,
		step1_reward = [{110009, 24000}],
		step2_condition = 10,
		step2_reward = [{110003, 10}],
		step3_condition = 15,
		step3_reward = [{110082, 5}]
	};

get(9) ->
	#hook_star_reward_conf{
		chapter = 9,
		step1_condition = 5,
		step1_reward = [{110009, 26000}],
		step2_condition = 10,
		step2_reward = [{110003, 10}],
		step3_condition = 15,
		step3_reward = [{110083, 5}]
	};

get(10) ->
	#hook_star_reward_conf{
		chapter = 10,
		step1_condition = 5,
		step1_reward = [{110009, 28000}],
		step2_condition = 10,
		step2_reward = [{110003, 10}],
		step3_condition = 15,
		step3_reward = [{110083, 5}]
	};

get(11) ->
	#hook_star_reward_conf{
		chapter = 11,
		step1_condition = 5,
		step1_reward = [{110009, 30000}],
		step2_condition = 10,
		step2_reward = [{110003, 10}],
		step3_condition = 15,
		step3_reward = [{110084, 5}]
	};

get(12) ->
	#hook_star_reward_conf{
		chapter = 12,
		step1_condition = 5,
		step1_reward = [{110009, 32000}],
		step2_condition = 10,
		step2_reward = [{110003, 10}],
		step3_condition = 15,
		step3_reward = [{110084, 5}]
	};

get(13) ->
	#hook_star_reward_conf{
		chapter = 13,
		step1_condition = 5,
		step1_reward = [{110009, 34000}],
		step2_condition = 10,
		step2_reward = [{110003, 10}],
		step3_condition = 15,
		step3_reward = [{110085, 5}]
	};

get(14) ->
	#hook_star_reward_conf{
		chapter = 14,
		step1_condition = 5,
		step1_reward = [{110009, 36000}],
		step2_condition = 10,
		step2_reward = [{110003, 10}],
		step3_condition = 15,
		step3_reward = [{110085, 5}]
	};

get(15) ->
	#hook_star_reward_conf{
		chapter = 15,
		step1_condition = 5,
		step1_reward = [{110009, 38000}],
		step2_condition = 10,
		step2_reward = [{110003, 10}],
		step3_condition = 15,
		step3_reward = [{110086, 5}]
	};

get(16) ->
	#hook_star_reward_conf{
		chapter = 16,
		step1_condition = 5,
		step1_reward = [{110009, 40000}],
		step2_condition = 10,
		step2_reward = [{110003, 10}],
		step3_condition = 15,
		step3_reward = [{110086, 5}]
	};

get(17) ->
	#hook_star_reward_conf{
		chapter = 17,
		step1_condition = 5,
		step1_reward = [{110009, 42000}],
		step2_condition = 10,
		step2_reward = [{110003, 10}],
		step3_condition = 15,
		step3_reward = [{110087, 5}]
	};

get(18) ->
	#hook_star_reward_conf{
		chapter = 18,
		step1_condition = 5,
		step1_reward = [{110009, 44000}],
		step2_condition = 10,
		step2_reward = [{110003, 10}],
		step3_condition = 15,
		step3_reward = [{110087, 5}]
	};

get(19) ->
	#hook_star_reward_conf{
		chapter = 19,
		step1_condition = 5,
		step1_reward = [{110009, 46000}],
		step2_condition = 10,
		step2_reward = [{110003, 10}],
		step3_condition = 15,
		step3_reward = [{110088, 5}]
	};

get(20) ->
	#hook_star_reward_conf{
		chapter = 20,
		step1_condition = 5,
		step1_reward = [{110009, 48000}],
		step2_condition = 10,
		step2_reward = [{110003, 10}],
		step3_condition = 15,
		step3_reward = [{110088, 5}]
	};

get(_Key) ->
	?ERR("undefined key from hook_star_reward_config ~p", [_Key]).