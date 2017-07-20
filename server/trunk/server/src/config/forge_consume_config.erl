%%%-------------------------------------------------------------------
%%% @author zhengsiying
%%% @doc
%%%		自动生成文件，不要手动修改
%%% @end
%%% Created : 2016/10/12
%%%-------------------------------------------------------------------

-module(forge_consume_config).

-include("common.hrl").
-include("config.hrl").

-compile([export_all]).

get_list_conf() ->
	[ forge_consume_config:get(X) || X <- get_list() ].

get_list() ->
	[{0,10,1}, {0,20,1}, {0,30,1}, {0,40,1}, {0,50,1}, {0,60,1}, {0,70,1}, {0,80,1}, {0,90,1}, {0,100,1}, {0,10,2}, {0,20,2}, {0,30,2}, {0,40,2}, {0,50,2}, {0,60,2}, {0,70,2}, {0,80,2}, {0,90,2}, {0,100,2}, {0,10,3}, {0,20,3}, {0,30,3}, {0,40,3}, {0,50,3}, {0,60,3}, {0,70,3}, {0,80,3}, {0,90,3}, {0,100,3}, {0,10,4}, {0,20,4}, {0,30,4}, {0,40,4}, {0,50,4}, {0,60,4}, {0,70,4}, {0,80,4}, {0,90,4}, {0,100,4}, {0,10,5}, {0,20,5}, {0,30,5}, {0,40,5}, {0,50,5}, {0,60,5}, {0,70,5}, {0,80,5}, {0,90,5}, {0,100,5}, {1,10,1}, {1,20,1}, {1,30,1}, {1,40,1}, {1,50,1}, {1,60,1}, {1,70,1}, {1,80,1}, {1,90,1}, {1,100,1}, {1,10,2}, {1,20,2}, {1,30,2}, {1,40,2}, {1,50,2}, {1,60,2}, {1,70,2}, {1,80,2}, {1,90,2}, {1,100,2}, {1,10,3}, {1,20,3}, {1,30,3}, {1,40,3}, {1,50,3}, {1,60,3}, {1,70,3}, {1,80,3}, {1,90,3}, {1,100,3}, {1,10,4}, {1,20,4}, {1,30,4}, {1,40,4}, {1,50,4}, {1,60,4}, {1,70,4}, {1,80,4}, {1,90,4}, {1,100,4}, {1,10,5}, {1,20,5}, {1,30,5}, {1,40,5}, {1,50,5}, {1,60,5}, {1,70,5}, {1,80,5}, {1,90,5}, {1,100,5}].

get({0,10,1}) ->
	#forge_consume_conf{
		key = {0,10,1},
		use_smelt = 50
	};

get({0,20,1}) ->
	#forge_consume_conf{
		key = {0,20,1},
		use_smelt = 50
	};

get({0,30,1}) ->
	#forge_consume_conf{
		key = {0,30,1},
		use_smelt = 50
	};

get({0,40,1}) ->
	#forge_consume_conf{
		key = {0,40,1},
		use_smelt = 50
	};

get({0,50,1}) ->
	#forge_consume_conf{
		key = {0,50,1},
		use_smelt = 50
	};

get({0,60,1}) ->
	#forge_consume_conf{
		key = {0,60,1},
		use_smelt = 50
	};

get({0,70,1}) ->
	#forge_consume_conf{
		key = {0,70,1},
		use_smelt = 50
	};

get({0,80,1}) ->
	#forge_consume_conf{
		key = {0,80,1},
		use_smelt = 50
	};

get({0,90,1}) ->
	#forge_consume_conf{
		key = {0,90,1},
		use_smelt = 50
	};

get({0,100,1}) ->
	#forge_consume_conf{
		key = {0,100,1},
		use_smelt = 50
	};

get({0,10,2}) ->
	#forge_consume_conf{
		key = {0,10,2},
		use_smelt = 100
	};

get({0,20,2}) ->
	#forge_consume_conf{
		key = {0,20,2},
		use_smelt = 100
	};

get({0,30,2}) ->
	#forge_consume_conf{
		key = {0,30,2},
		use_smelt = 100
	};

get({0,40,2}) ->
	#forge_consume_conf{
		key = {0,40,2},
		use_smelt = 100
	};

get({0,50,2}) ->
	#forge_consume_conf{
		key = {0,50,2},
		use_smelt = 100
	};

get({0,60,2}) ->
	#forge_consume_conf{
		key = {0,60,2},
		use_smelt = 100
	};

get({0,70,2}) ->
	#forge_consume_conf{
		key = {0,70,2},
		use_smelt = 100
	};

get({0,80,2}) ->
	#forge_consume_conf{
		key = {0,80,2},
		use_smelt = 100
	};

get({0,90,2}) ->
	#forge_consume_conf{
		key = {0,90,2},
		use_smelt = 100
	};

get({0,100,2}) ->
	#forge_consume_conf{
		key = {0,100,2},
		use_smelt = 100
	};

get({0,10,3}) ->
	#forge_consume_conf{
		key = {0,10,3},
		use_smelt = 200
	};

get({0,20,3}) ->
	#forge_consume_conf{
		key = {0,20,3},
		use_smelt = 200
	};

get({0,30,3}) ->
	#forge_consume_conf{
		key = {0,30,3},
		use_smelt = 200
	};

get({0,40,3}) ->
	#forge_consume_conf{
		key = {0,40,3},
		use_smelt = 200
	};

get({0,50,3}) ->
	#forge_consume_conf{
		key = {0,50,3},
		use_smelt = 200
	};

get({0,60,3}) ->
	#forge_consume_conf{
		key = {0,60,3},
		use_smelt = 200
	};

get({0,70,3}) ->
	#forge_consume_conf{
		key = {0,70,3},
		use_smelt = 200
	};

get({0,80,3}) ->
	#forge_consume_conf{
		key = {0,80,3},
		use_smelt = 200
	};

get({0,90,3}) ->
	#forge_consume_conf{
		key = {0,90,3},
		use_smelt = 200
	};

get({0,100,3}) ->
	#forge_consume_conf{
		key = {0,100,3},
		use_smelt = 200
	};

get({0,10,4}) ->
	#forge_consume_conf{
		key = {0,10,4},
		use_smelt = 2000
	};

get({0,20,4}) ->
	#forge_consume_conf{
		key = {0,20,4},
		use_smelt = 2000
	};

get({0,30,4}) ->
	#forge_consume_conf{
		key = {0,30,4},
		use_smelt = 2000
	};

get({0,40,4}) ->
	#forge_consume_conf{
		key = {0,40,4},
		use_smelt = 2000
	};

get({0,50,4}) ->
	#forge_consume_conf{
		key = {0,50,4},
		use_smelt = 2000
	};

get({0,60,4}) ->
	#forge_consume_conf{
		key = {0,60,4},
		use_smelt = 2000
	};

get({0,70,4}) ->
	#forge_consume_conf{
		key = {0,70,4},
		use_smelt = 2000
	};

get({0,80,4}) ->
	#forge_consume_conf{
		key = {0,80,4},
		use_smelt = 2000
	};

get({0,90,4}) ->
	#forge_consume_conf{
		key = {0,90,4},
		use_smelt = 2000
	};

get({0,100,4}) ->
	#forge_consume_conf{
		key = {0,100,4},
		use_smelt = 2000
	};

get({0,10,5}) ->
	#forge_consume_conf{
		key = {0,10,5},
		use_smelt = 5000
	};

get({0,20,5}) ->
	#forge_consume_conf{
		key = {0,20,5},
		use_smelt = 5000
	};

get({0,30,5}) ->
	#forge_consume_conf{
		key = {0,30,5},
		use_smelt = 5000
	};

get({0,40,5}) ->
	#forge_consume_conf{
		key = {0,40,5},
		use_smelt = 5000
	};

get({0,50,5}) ->
	#forge_consume_conf{
		key = {0,50,5},
		use_smelt = 5000
	};

get({0,60,5}) ->
	#forge_consume_conf{
		key = {0,60,5},
		use_smelt = 5000
	};

get({0,70,5}) ->
	#forge_consume_conf{
		key = {0,70,5},
		use_smelt = 5000
	};

get({0,80,5}) ->
	#forge_consume_conf{
		key = {0,80,5},
		use_smelt = 5000
	};

get({0,90,5}) ->
	#forge_consume_conf{
		key = {0,90,5},
		use_smelt = 5000
	};

get({0,100,5}) ->
	#forge_consume_conf{
		key = {0,100,5},
		use_smelt = 5000
	};

get({1,10,1}) ->
	#forge_consume_conf{
		key = {1,10,1},
		use_smelt = 1000
	};

get({1,20,1}) ->
	#forge_consume_conf{
		key = {1,20,1},
		use_smelt = 1000
	};

get({1,30,1}) ->
	#forge_consume_conf{
		key = {1,30,1},
		use_smelt = 1000
	};

get({1,40,1}) ->
	#forge_consume_conf{
		key = {1,40,1},
		use_smelt = 1000
	};

get({1,50,1}) ->
	#forge_consume_conf{
		key = {1,50,1},
		use_smelt = 1000
	};

get({1,60,1}) ->
	#forge_consume_conf{
		key = {1,60,1},
		use_smelt = 1000
	};

get({1,70,1}) ->
	#forge_consume_conf{
		key = {1,70,1},
		use_smelt = 1000
	};

get({1,80,1}) ->
	#forge_consume_conf{
		key = {1,80,1},
		use_smelt = 1000
	};

get({1,90,1}) ->
	#forge_consume_conf{
		key = {1,90,1},
		use_smelt = 1000
	};

get({1,100,1}) ->
	#forge_consume_conf{
		key = {1,100,1},
		use_smelt = 1000
	};

get({1,10,2}) ->
	#forge_consume_conf{
		key = {1,10,2},
		use_smelt = 2000
	};

get({1,20,2}) ->
	#forge_consume_conf{
		key = {1,20,2},
		use_smelt = 2000
	};

get({1,30,2}) ->
	#forge_consume_conf{
		key = {1,30,2},
		use_smelt = 2000
	};

get({1,40,2}) ->
	#forge_consume_conf{
		key = {1,40,2},
		use_smelt = 2000
	};

get({1,50,2}) ->
	#forge_consume_conf{
		key = {1,50,2},
		use_smelt = 2000
	};

get({1,60,2}) ->
	#forge_consume_conf{
		key = {1,60,2},
		use_smelt = 2000
	};

get({1,70,2}) ->
	#forge_consume_conf{
		key = {1,70,2},
		use_smelt = 2000
	};

get({1,80,2}) ->
	#forge_consume_conf{
		key = {1,80,2},
		use_smelt = 2000
	};

get({1,90,2}) ->
	#forge_consume_conf{
		key = {1,90,2},
		use_smelt = 2000
	};

get({1,100,2}) ->
	#forge_consume_conf{
		key = {1,100,2},
		use_smelt = 2000
	};

get({1,10,3}) ->
	#forge_consume_conf{
		key = {1,10,3},
		use_smelt = 3000
	};

get({1,20,3}) ->
	#forge_consume_conf{
		key = {1,20,3},
		use_smelt = 3000
	};

get({1,30,3}) ->
	#forge_consume_conf{
		key = {1,30,3},
		use_smelt = 3000
	};

get({1,40,3}) ->
	#forge_consume_conf{
		key = {1,40,3},
		use_smelt = 3000
	};

get({1,50,3}) ->
	#forge_consume_conf{
		key = {1,50,3},
		use_smelt = 3000
	};

get({1,60,3}) ->
	#forge_consume_conf{
		key = {1,60,3},
		use_smelt = 3000
	};

get({1,70,3}) ->
	#forge_consume_conf{
		key = {1,70,3},
		use_smelt = 3000
	};

get({1,80,3}) ->
	#forge_consume_conf{
		key = {1,80,3},
		use_smelt = 3000
	};

get({1,90,3}) ->
	#forge_consume_conf{
		key = {1,90,3},
		use_smelt = 3000
	};

get({1,100,3}) ->
	#forge_consume_conf{
		key = {1,100,3},
		use_smelt = 3000
	};

get({1,10,4}) ->
	#forge_consume_conf{
		key = {1,10,4},
		use_smelt = 5000
	};

get({1,20,4}) ->
	#forge_consume_conf{
		key = {1,20,4},
		use_smelt = 5000
	};

get({1,30,4}) ->
	#forge_consume_conf{
		key = {1,30,4},
		use_smelt = 5000
	};

get({1,40,4}) ->
	#forge_consume_conf{
		key = {1,40,4},
		use_smelt = 5000
	};

get({1,50,4}) ->
	#forge_consume_conf{
		key = {1,50,4},
		use_smelt = 5000
	};

get({1,60,4}) ->
	#forge_consume_conf{
		key = {1,60,4},
		use_smelt = 5000
	};

get({1,70,4}) ->
	#forge_consume_conf{
		key = {1,70,4},
		use_smelt = 5000
	};

get({1,80,4}) ->
	#forge_consume_conf{
		key = {1,80,4},
		use_smelt = 5000
	};

get({1,90,4}) ->
	#forge_consume_conf{
		key = {1,90,4},
		use_smelt = 5000
	};

get({1,100,4}) ->
	#forge_consume_conf{
		key = {1,100,4},
		use_smelt = 5000
	};

get({1,10,5}) ->
	#forge_consume_conf{
		key = {1,10,5},
		use_smelt = 10000
	};

get({1,20,5}) ->
	#forge_consume_conf{
		key = {1,20,5},
		use_smelt = 10000
	};

get({1,30,5}) ->
	#forge_consume_conf{
		key = {1,30,5},
		use_smelt = 10000
	};

get({1,40,5}) ->
	#forge_consume_conf{
		key = {1,40,5},
		use_smelt = 10000
	};

get({1,50,5}) ->
	#forge_consume_conf{
		key = {1,50,5},
		use_smelt = 10000
	};

get({1,60,5}) ->
	#forge_consume_conf{
		key = {1,60,5},
		use_smelt = 10000
	};

get({1,70,5}) ->
	#forge_consume_conf{
		key = {1,70,5},
		use_smelt = 10000
	};

get({1,80,5}) ->
	#forge_consume_conf{
		key = {1,80,5},
		use_smelt = 10000
	};

get({1,90,5}) ->
	#forge_consume_conf{
		key = {1,90,5},
		use_smelt = 10000
	};

get({1,100,5}) ->
	#forge_consume_conf{
		key = {1,100,5},
		use_smelt = 10000
	};

get(_Key) ->
	?ERR("undefined key from forge_consume_config ~p", [_Key]).