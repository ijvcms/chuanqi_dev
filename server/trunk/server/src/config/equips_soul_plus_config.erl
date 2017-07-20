%%%-------------------------------------------------------------------
%%% @author zhengsiying
%%% @doc
%%%		自动生成文件，不要手动修改
%%% @end
%%% Created : 2016/10/12
%%%-------------------------------------------------------------------

-module(equips_soul_plus_config).

-include("common.hrl").
-include("config.hrl").

-compile([export_all]).

get_list_conf() ->
	[ equips_soul_plus_config:get(X) || X <- get_list() ].

get_list() ->
	[0, 1, 2, 3, 4, 5, 6, 7].

get(0) ->
	#equips_soul_plus_conf{
		key = 0,
		modulus = 0
	};

get(1) ->
	#equips_soul_plus_conf{
		key = 1,
		modulus = 0.15
	};

get(2) ->
	#equips_soul_plus_conf{
		key = 2,
		modulus = 0.3
	};

get(3) ->
	#equips_soul_plus_conf{
		key = 3,
		modulus = 0.4
	};

get(4) ->
	#equips_soul_plus_conf{
		key = 4,
		modulus = 0.5
	};

get(5) ->
	#equips_soul_plus_conf{
		key = 5,
		modulus = 0.6
	};

get(6) ->
	#equips_soul_plus_conf{
		key = 6,
		modulus = 0.7
	};

get(7) ->
	#equips_soul_plus_conf{
		key = 7,
		modulus = 0.8
	};

get(_Key) ->
	?ERR("undefined key from equips_soul_plus_config ~p", [_Key]).