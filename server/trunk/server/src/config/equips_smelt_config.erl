%%%-------------------------------------------------------------------
%%% @author zhengsiying
%%% @doc
%%%		自动生成文件，不要手动修改
%%% @end
%%% Created : 2016/10/12
%%%-------------------------------------------------------------------

-module(equips_smelt_config).

-include("common.hrl").
-include("config.hrl").

-compile([export_all]).

get_list_conf() ->
	[ equips_smelt_config:get(X) || X <- get_list() ].

get_list() ->
	[{10,1}, {10,2}, {20,1}, {20,2}, {30,2}, {30,3}, {40,4}, {50,4}, {60,5}, {70,5}, {80,5}, {90,5}, {100,5}].

get({10,1}) ->
	#equips_smelt_conf{
		key = {10,1},
		smelt_rate = 0,
		up_rate = 3000
	};

get({10,2}) ->
	#equips_smelt_conf{
		key = {10,2},
		smelt_rate = 0,
		up_rate = 3000
	};

get({20,1}) ->
	#equips_smelt_conf{
		key = {20,1},
		smelt_rate = 0,
		up_rate = 500
	};

get({20,2}) ->
	#equips_smelt_conf{
		key = {20,2},
		smelt_rate = 0,
		up_rate = 500
	};

get({30,2}) ->
	#equips_smelt_conf{
		key = {30,2},
		smelt_rate = 0,
		up_rate = 0
	};

get({30,3}) ->
	#equips_smelt_conf{
		key = {30,3},
		smelt_rate = 0,
		up_rate = 0
	};

get({40,4}) ->
	#equips_smelt_conf{
		key = {40,4},
		smelt_rate = 0,
		up_rate = 0
	};

get({50,4}) ->
	#equips_smelt_conf{
		key = {50,4},
		smelt_rate = 0,
		up_rate = 0
	};

get({60,5}) ->
	#equips_smelt_conf{
		key = {60,5},
		smelt_rate = 0,
		up_rate = 0
	};

get({70,5}) ->
	#equips_smelt_conf{
		key = {70,5},
		smelt_rate = 0,
		up_rate = 0
	};

get({80,5}) ->
	#equips_smelt_conf{
		key = {80,5},
		smelt_rate = 0,
		up_rate = 0
	};

get({90,5}) ->
	#equips_smelt_conf{
		key = {90,5},
		smelt_rate = 0,
		up_rate = 0
	};

get({100,5}) ->
	#equips_smelt_conf{
		key = {100,5},
		smelt_rate = 0,
		up_rate = 0
	};

get(_Key) ->
	?ERR("undefined key from equips_smelt_config ~p", [_Key]).