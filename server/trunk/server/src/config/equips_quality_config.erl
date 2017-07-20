%%%-------------------------------------------------------------------
%%% @author zhengsiying
%%% @doc
%%%		自动生成文件，不要手动修改
%%% @end
%%% Created : 2016/10/12
%%%-------------------------------------------------------------------

-module(equips_quality_config).

-include("common.hrl").
-include("config.hrl").

-compile([export_all]).

get_list_conf() ->
	[ equips_quality_config:get(X) || X <- get_list() ].

get_list() ->
	[1, 2, 3, 4, 5, 6].

get(1) ->
	#equips_quality_conf{
		id = 1,
		stren_consume = 1,
		smelt_value = 5
	};

get(2) ->
	#equips_quality_conf{
		id = 2,
		stren_consume = 1.1,
		smelt_value = 10
	};

get(3) ->
	#equips_quality_conf{
		id = 3,
		stren_consume = 1.2,
		smelt_value = 20
	};

get(4) ->
	#equips_quality_conf{
		id = 4,
		stren_consume = 1.3,
		smelt_value = 50
	};

get(5) ->
	#equips_quality_conf{
		id = 5,
		stren_consume = 1.4,
		smelt_value = 150
	};

get(6) ->
	#equips_quality_conf{
		id = 6,
		stren_consume = 1.5,
		smelt_value = 0
	};

get(_Key) ->
	?ERR("undefined key from equips_quality_config ~p", [_Key]).