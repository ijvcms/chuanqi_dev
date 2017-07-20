%%%-------------------------------------------------------------------
%%% @author zhengsiying
%%% @doc
%%%		自动生成文件，不要手动修改
%%% @end
%%% Created : 2016/10/12
%%%-------------------------------------------------------------------

-module(active_reward_config).

-include("common.hrl").
-include("config.hrl").

-compile([export_all]).

get_list() ->
	[1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30].

get_list_conf(Lv) ->
	[ active_reward_config:get({X, Lv}) || X <- get_list() ].

get({1 ,PlayerLv}) when PlayerLv >=1 andalso PlayerLv =< 999 ->
	#active_reward_conf{
		key = 1,
		min_lv = 1,
		max_lv = 999,
		type = 1,
		value = 1,
		reward = [{305086,1,1}],
		reward_zhanshi = [{305086,1,1}],
		reward_fashi = [{305086,1,1}],
		reward_daoshi = [{305086,1,1}],
		counter_id = 10024
	};

get({2 ,PlayerLv}) when PlayerLv >=1 andalso PlayerLv =< 999 ->
	#active_reward_conf{
		key = 2,
		min_lv = 1,
		max_lv = 999,
		type = 1,
		value = 2,
		reward = [{305087,1,1}],
		reward_zhanshi = [{305087,1,1}],
		reward_fashi = [{305087,1,1}],
		reward_daoshi = [{305087,1,1}],
		counter_id = 10025
	};

get({3 ,PlayerLv}) when PlayerLv >=1 andalso PlayerLv =< 999 ->
	#active_reward_conf{
		key = 3,
		min_lv = 1,
		max_lv = 999,
		type = 1,
		value = 3,
		reward = [{305088,1,1}],
		reward_zhanshi = [{305088,1,1}],
		reward_fashi = [{305088,1,1}],
		reward_daoshi = [{305088,1,1}],
		counter_id = 10026
	};

get({4 ,PlayerLv}) when PlayerLv >=1 andalso PlayerLv =< 999 ->
	#active_reward_conf{
		key = 4,
		min_lv = 1,
		max_lv = 999,
		type = 1,
		value = 4,
		reward = [{110054,1,10},{110007,1,99}],
		reward_zhanshi = [{110054,1,10},{110007,1,99}],
		reward_fashi = [{110054,1,10},{110007,1,99}],
		reward_daoshi = [{110054,1,10},{110007,1,99}],
		counter_id = 10027
	};

get({5 ,PlayerLv}) when PlayerLv >=1 andalso PlayerLv =< 999 ->
	#active_reward_conf{
		key = 5,
		min_lv = 1,
		max_lv = 999,
		type = 1,
		value = 5,
		reward = [{110140,1,5},{110127,1,20}],
		reward_zhanshi = [{110140,1,5},{110127,1,20}],
		reward_fashi = [{110140,1,5},{110127,1,20}],
		reward_daoshi = [{110140,1,5},{110127,1,20}],
		counter_id = 10028
	};

get({6 ,PlayerLv}) when PlayerLv >=1 andalso PlayerLv =< 999 ->
	#active_reward_conf{
		key = 6,
		min_lv = 1,
		max_lv = 999,
		type = 1,
		value = 6,
		reward = [{110050,1,1},{110003,1,30}],
		reward_zhanshi = [{110050,1,1},{110003,1,30}],
		reward_fashi = [{110050,1,1},{110003,1,30}],
		reward_daoshi = [{110050,1,1},{110003,1,30}],
		counter_id = 10029
	};

get({7 ,PlayerLv}) when PlayerLv >=1 andalso PlayerLv =< 999 ->
	#active_reward_conf{
		key = 7,
		min_lv = 1,
		max_lv = 999,
		type = 1,
		value = 7,
		reward = [{110045,1,1000},{110049,1,10}],
		reward_zhanshi = [{110045,1,1000},{110049,1,10}],
		reward_fashi = [{110045,1,1000},{110049,1,10}],
		reward_daoshi = [{110045,1,1000},{110049,1,10}],
		counter_id = 10030
	};

get({8 ,PlayerLv}) when PlayerLv >=1 andalso PlayerLv =< 59 ->
	#active_reward_conf{
		key = 8,
		min_lv = 1,
		max_lv = 59,
		type = 2,
		value = 60,
		reward = [{110009,1,20000}],
		reward_zhanshi = [{110009,0,20000}],
		reward_fashi = [{110009,0,20000}],
		reward_daoshi = [{110009,0,20000}],
		counter_id = 10031
	};

get({9 ,PlayerLv}) when PlayerLv >=1 andalso PlayerLv =< 59 ->
	#active_reward_conf{
		key = 9,
		min_lv = 1,
		max_lv = 59,
		type = 2,
		value = 300,
		reward = [{110009,0,20000},{110078,1,10}],
		reward_zhanshi = [{110009,0,20000},{110078,1,10}],
		reward_fashi = [{110009,0,20000},{110078,1,10}],
		reward_daoshi = [{110009,0,20000},{110078,1,10}],
		counter_id = 10032
	};

get({10 ,PlayerLv}) when PlayerLv >=1 andalso PlayerLv =< 59 ->
	#active_reward_conf{
		key = 10,
		min_lv = 1,
		max_lv = 59,
		type = 2,
		value = 900,
		reward = [{110009,0,30000},{110076,1,20}],
		reward_zhanshi = [{110009,0,30000},{110076,1,20}],
		reward_fashi = [{110009,0,30000},{110076,1,20}],
		reward_daoshi = [{110009,0,30000},{110076,1,20}],
		counter_id = 10033
	};

get({11 ,PlayerLv}) when PlayerLv >=1 andalso PlayerLv =< 59 ->
	#active_reward_conf{
		key = 11,
		min_lv = 1,
		max_lv = 59,
		type = 2,
		value = 1800,
		reward = [{110009,0,30000},{110077,1,20}],
		reward_zhanshi = [{110009,0,30000},{110077,1,20}],
		reward_fashi = [{110009,0,30000},{110077,1,20}],
		reward_daoshi = [{110009,0,30000},{110077,1,20}],
		counter_id = 10034
	};

get({12 ,PlayerLv}) when PlayerLv >=1 andalso PlayerLv =< 59 ->
	#active_reward_conf{
		key = 12,
		min_lv = 1,
		max_lv = 59,
		type = 2,
		value = 3600,
		reward = [{110009,0,50000},{110083,1,5}],
		reward_zhanshi = [{110009,0,50000},{110083,1,5}],
		reward_fashi = [{110009,0,50000},{110083,1,5}],
		reward_daoshi = [{110009,0,50000},{110083,1,5}],
		counter_id = 10035
	};

get({13 ,PlayerLv}) when PlayerLv >=1 andalso PlayerLv =< 59 ->
	#active_reward_conf{
		key = 13,
		min_lv = 1,
		max_lv = 59,
		type = 2,
		value = 7200,
		reward = [{110009,0,50000},{110007,1,5}],
		reward_zhanshi = [{110009,0,50000},{110007,1,5}],
		reward_fashi = [{110009,0,50000},{110007,1,5}],
		reward_daoshi = [{110009,0,50000},{110007,1,5}],
		counter_id = 10036
	};

get({14 ,PlayerLv}) when PlayerLv >=60 andalso PlayerLv =< 79 ->
	#active_reward_conf{
		key = 14,
		min_lv = 60,
		max_lv = 79,
		type = 2,
		value = 60,
		reward = [{110009,1,20000}],
		reward_zhanshi = [{110009,1,20000}],
		reward_fashi = [{110009,1,20000}],
		reward_daoshi = [{110009,1,20000}],
		counter_id = 10031
	};

get({15 ,PlayerLv}) when PlayerLv >=60 andalso PlayerLv =< 79 ->
	#active_reward_conf{
		key = 15,
		min_lv = 60,
		max_lv = 79,
		type = 2,
		value = 300,
		reward = [{110009,1,20000},{110078,1,20}],
		reward_zhanshi = [{110009,1,20000},{110078,1,20}],
		reward_fashi = [{110009,1,20000},{110078,1,20}],
		reward_daoshi = [{110009,1,20000},{110078,1,20}],
		counter_id = 10032
	};

get({16 ,PlayerLv}) when PlayerLv >=60 andalso PlayerLv =< 79 ->
	#active_reward_conf{
		key = 16,
		min_lv = 60,
		max_lv = 79,
		type = 2,
		value = 900,
		reward = [{110009,1,30000},{110007,1,10}],
		reward_zhanshi = [{110009,1,30000},{110007,1,10}],
		reward_fashi = [{110009,1,30000},{110007,1,10}],
		reward_daoshi = [{110009,1,30000},{110007,1,10}],
		counter_id = 10033
	};

get({17 ,PlayerLv}) when PlayerLv >=60 andalso PlayerLv =< 79 ->
	#active_reward_conf{
		key = 17,
		min_lv = 60,
		max_lv = 79,
		type = 2,
		value = 1800,
		reward = [{110009,1,30000},{110089,1,5}],
		reward_zhanshi = [{110009,1,30000},{110089,1,5}],
		reward_fashi = [{110009,1,30000},{110089,1,5}],
		reward_daoshi = [{110009,1,30000},{110089,1,5}],
		counter_id = 10034
	};

get({18 ,PlayerLv}) when PlayerLv >=60 andalso PlayerLv =< 79 ->
	#active_reward_conf{
		key = 18,
		min_lv = 60,
		max_lv = 79,
		type = 2,
		value = 3600,
		reward = [{110009,1,50000},{110003,1,5}],
		reward_zhanshi = [{110009,1,50000},{110003,1,5}],
		reward_fashi = [{110009,1,50000},{110003,1,5}],
		reward_daoshi = [{110009,1,50000},{110003,1,5}],
		counter_id = 10035
	};

get({19 ,PlayerLv}) when PlayerLv >=60 andalso PlayerLv =< 79 ->
	#active_reward_conf{
		key = 19,
		min_lv = 60,
		max_lv = 79,
		type = 2,
		value = 7200,
		reward = [{110009,1,50000},{110160,1,5}],
		reward_zhanshi = [{110009,1,50000},{110160,1,5}],
		reward_fashi = [{110009,1,50000},{110160,1,5}],
		reward_daoshi = [{110009,1,50000},{110160,1,5}],
		counter_id = 10036
	};

get({20 ,PlayerLv}) when PlayerLv >=80 andalso PlayerLv =< 999 ->
	#active_reward_conf{
		key = 20,
		min_lv = 80,
		max_lv = 999,
		type = 2,
		value = 60,
		reward = [{110009,1,20000}],
		reward_zhanshi = [{110009,1,20000}],
		reward_fashi = [{110009,1,20000}],
		reward_daoshi = [{110009,1,20000}],
		counter_id = 10031
	};

get({21 ,PlayerLv}) when PlayerLv >=80 andalso PlayerLv =< 999 ->
	#active_reward_conf{
		key = 21,
		min_lv = 80,
		max_lv = 999,
		type = 2,
		value = 300,
		reward = [{110009,1,20000},{110078,1,20}],
		reward_zhanshi = [{110009,1,20000},{110078,1,20}],
		reward_fashi = [{110009,1,20000},{110078,1,20}],
		reward_daoshi = [{110009,1,20000},{110078,1,20}],
		counter_id = 10032
	};

get({22 ,PlayerLv}) when PlayerLv >=80 andalso PlayerLv =< 999 ->
	#active_reward_conf{
		key = 22,
		min_lv = 80,
		max_lv = 999,
		type = 2,
		value = 900,
		reward = [{110009,1,30000},{110003,1,5}],
		reward_zhanshi = [{110009,1,30000},{110003,1,5}],
		reward_fashi = [{110009,1,30000},{110003,1,5}],
		reward_daoshi = [{110009,1,30000},{110003,1,5}],
		counter_id = 10033
	};

get({23 ,PlayerLv}) when PlayerLv >=80 andalso PlayerLv =< 999 ->
	#active_reward_conf{
		key = 23,
		min_lv = 80,
		max_lv = 999,
		type = 2,
		value = 1800,
		reward = [{110009,1,30000},{110219,1,2}],
		reward_zhanshi = [{110009,1,30000},{110219,1,2}],
		reward_fashi = [{110009,1,30000},{110219,1,2}],
		reward_daoshi = [{110009,1,30000},{110219,1,2}],
		counter_id = 10034
	};

get({24 ,PlayerLv}) when PlayerLv >=80 andalso PlayerLv =< 999 ->
	#active_reward_conf{
		key = 24,
		min_lv = 80,
		max_lv = 999,
		type = 2,
		value = 3600,
		reward = [{110009,1,50000},{110193,1,5}],
		reward_zhanshi = [{110009,1,50000},{110193,1,5}],
		reward_fashi = [{110009,1,50000},{110193,1,5}],
		reward_daoshi = [{110009,1,50000},{110193,1,5}],
		counter_id = 10035
	};

get({25 ,PlayerLv}) when PlayerLv >=80 andalso PlayerLv =< 999 ->
	#active_reward_conf{
		key = 25,
		min_lv = 80,
		max_lv = 999,
		type = 2,
		value = 7200,
		reward = [{110009,1,50000},{110099,1,5}],
		reward_zhanshi = [{110009,1,50000},{110099,1,5}],
		reward_fashi = [{110009,1,50000},{110099,1,5}],
		reward_daoshi = [{110009,1,50000},{110099,1,5}],
		counter_id = 10036
	};

get({26 ,PlayerLv}) when PlayerLv >=1 andalso PlayerLv =< 999 ->
	#active_reward_conf{
		key = 26,
		min_lv = 1,
		max_lv = 999,
		type = 3,
		value = 0,
		reward = [{110123,1,1}],
		reward_zhanshi = [{110123,1,1}],
		reward_fashi = [{110123,1,1}],
		reward_daoshi = [{110123,1,1}],
		counter_id = 10037
	};

get({27 ,PlayerLv}) when PlayerLv >=1 andalso PlayerLv =< 999 ->
	#active_reward_conf{
		key = 27,
		min_lv = 1,
		max_lv = 999,
		type = 4,
		value = 45,
		reward = [{200029,1,1},{110079,1,50},{110076,1,99},{110077,1,99}],
		reward_zhanshi = [{200029,0,1},{110079,1,50},{110076,1,99},{110077,1,99}],
		reward_fashi = [{201029,0,1},{110079,1,50},{110076,1,99},{110077,1,99}],
		reward_daoshi = [{202029,0,1},{110079,1,50},{110076,1,99},{110077,1,99}],
		counter_id = 10051
	};

get({28 ,PlayerLv}) when PlayerLv >=1 andalso PlayerLv =< 999 ->
	#active_reward_conf{
		key = 28,
		min_lv = 1,
		max_lv = 999,
		type = 4,
		value = 47,
		reward = [{200026,1,1},{110080,1,20},{110045,1,200},{110127,1,50}],
		reward_zhanshi = [{200026,0,1},{110080,1,20},{110045,1,200},{110127,1,50}],
		reward_fashi = [{201026,0,1},{110080,1,20},{110045,1,200},{110127,1,50}],
		reward_daoshi = [{202026,0,1},{110080,1,20},{110045,1,200},{110127,1,50}],
		counter_id = 10052
	};

get({29 ,PlayerLv}) when PlayerLv >=1 andalso PlayerLv =< 999 ->
	#active_reward_conf{
		key = 29,
		min_lv = 1,
		max_lv = 999,
		type = 4,
		value = 50,
		reward = [{200023,1,1},{110081,1,10},{110045,1,300},{110148,1,1}],
		reward_zhanshi = [{200023,0,1},{110081,1,10},{110045,1,300},{110148,1,1}],
		reward_fashi = [{201023,0,1},{110081,1,10},{110045,1,300},{110148,1,1}],
		reward_daoshi = [{202023,0,1},{110081,1,10},{110045,1,300},{110148,1,1}],
		counter_id = 10053
	};

get({30 ,PlayerLv}) when PlayerLv >=1 andalso PlayerLv =< 999 ->
	#active_reward_conf{
		key = 30,
		min_lv = 1,
		max_lv = 999,
		type = 4,
		value = 55,
		reward = [{200039,1,1},{110083,1,10},{110045,1,500},{110149,1,1}],
		reward_zhanshi = [{200039,1,1},{110083,1,10},{110045,1,500},{110149,1,1}],
		reward_fashi = [{201039,1,1},{110083,1,10},{110045,1,500},{110149,1,1}],
		reward_daoshi = [{202039,1,1},{110083,1,10},{110045,1,500},{110149,1,1}],
		counter_id = 10054
	};

get(_Key) ->
	[].