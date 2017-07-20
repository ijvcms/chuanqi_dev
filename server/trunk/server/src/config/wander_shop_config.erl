%%%-------------------------------------------------------------------
%%% @author zhengsiying
%%% @doc
%%%		自动生成文件，不要手动修改
%%% @end
%%% Created : 2016/10/12
%%%-------------------------------------------------------------------

-module(wander_shop_config).

-include("common.hrl").
-include("config.hrl").

-compile([export_all]).

get_list_conf() ->
	[ wander_shop_config:get(X) || X <- get_list() ].

get_list() ->
	[1, 2].

get(1) ->
	#wander_shop_conf{
		key = 1,
		refuse_time = {12,0,0},
		random_num = 2,
		shop_list = [{801,200},{812,1000},{813,1000},{802,1000},{805,2000},{815,100},{806,1},{807,1},{808,1}],
		random_list = [{100,{803,100}},{100,{804,200}},{100,{814,1000}}]
	};

get(2) ->
	#wander_shop_conf{
		key = 2,
		refuse_time = {18,0,0},
		random_num = 2,
		shop_list = [{801,200},{812,1000},{813,1000},{802,1000},{805,2000},{815,100},{809,1},{810,1},{811,1}],
		random_list = [{100,{803,100}},{100,{804,200}},{100,{814,1000}}]
	};

get(_Key) ->
	?ERR("undefined key from wander_shop_config ~p", [_Key]).