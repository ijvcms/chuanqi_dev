%%%-------------------------------------------------------------------
%%% @author zhengsiying
%%% @doc
%%%		自动生成文件，不要手动修改
%%% @end
%%% Created : 2016/10/12
%%%-------------------------------------------------------------------

-module(equips_forge_config).

-include("common.hrl").
-include("config.hrl").

-compile([export_all]).

get_list_conf() ->
	[ equips_forge_config:get(X) || X <- get_list() ].

get_list() ->
	[{0,1,10}, {0,11,20}, {0,21,30}, {0,31,40}, {0,41,50}, {0,51,60}, {0,61,70}, {0,71,80}, {0,81,90}, {0,91,100}, {1,1,10}, {1,11,20}, {1,21,30}, {1,31,40}, {1,41,50}, {1,51,60}, {1,61,70}, {1,71,80}, {1,81,90}, {1,91,100}].

get({0,1,10}) ->
	#equips_forge_conf{
		key = {0,1,10},
		rate = 10000,
		quality_rate = [{1,10000}]
	};

get({0,11,20}) ->
	#equips_forge_conf{
		key = {0,11,20},
		rate = 10000,
		quality_rate = [{2,10000}]
	};

get({0,21,30}) ->
	#equips_forge_conf{
		key = {0,21,30},
		rate = 10000,
		quality_rate = [{3,10000}]
	};

get({0,31,40}) ->
	#equips_forge_conf{
		key = {0,31,40},
		rate = 10000,
		quality_rate = [{4,10000}]
	};

get({0,41,50}) ->
	#equips_forge_conf{
		key = {0,41,50},
		rate = 10000,
		quality_rate = [{4,10000}]
	};

get({0,51,60}) ->
	#equips_forge_conf{
		key = {0,51,60},
		rate = 10000,
		quality_rate = [{5,10000}]
	};

get({0,61,70}) ->
	#equips_forge_conf{
		key = {0,61,70},
		rate = 10000,
		quality_rate = [{5,10000}]
	};

get({0,71,80}) ->
	#equips_forge_conf{
		key = {0,71,80},
		rate = 10000,
		quality_rate = [{5,10000}]
	};

get({0,81,90}) ->
	#equips_forge_conf{
		key = {0,81,90},
		rate = 10000,
		quality_rate = [{5,10000}]
	};

get({0,91,100}) ->
	#equips_forge_conf{
		key = {0,91,100},
		rate = 10000,
		quality_rate = [{5,10000}]
	};

get({1,1,10}) ->
	#equips_forge_conf{
		key = {1,1,10},
		rate = 0,
		quality_rate = [{1,10000}]
	};

get({1,11,20}) ->
	#equips_forge_conf{
		key = {1,11,20},
		rate = 0,
		quality_rate = [{2,10000}]
	};

get({1,21,30}) ->
	#equips_forge_conf{
		key = {1,21,30},
		rate = 0,
		quality_rate = [{3,10000}]
	};

get({1,31,40}) ->
	#equips_forge_conf{
		key = {1,31,40},
		rate = 0,
		quality_rate = [{4,10000}]
	};

get({1,41,50}) ->
	#equips_forge_conf{
		key = {1,41,50},
		rate = 0,
		quality_rate = [{4,10000}]
	};

get({1,51,60}) ->
	#equips_forge_conf{
		key = {1,51,60},
		rate = 0,
		quality_rate = [{5,10000}]
	};

get({1,61,70}) ->
	#equips_forge_conf{
		key = {1,61,70},
		rate = 0,
		quality_rate = [{5,10000}]
	};

get({1,71,80}) ->
	#equips_forge_conf{
		key = {1,71,80},
		rate = 0,
		quality_rate = [{5,10000}]
	};

get({1,81,90}) ->
	#equips_forge_conf{
		key = {1,81,90},
		rate = 0,
		quality_rate = [{5,10000}]
	};

get({1,91,100}) ->
	#equips_forge_conf{
		key = {1,91,100},
		rate = 0,
		quality_rate = [{5,10000}]
	};

get(_Key) ->
	?ERR("undefined key from equips_forge_config ~p", [_Key]).