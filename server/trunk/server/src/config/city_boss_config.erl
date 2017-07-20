%%%-------------------------------------------------------------------
%%% @author zhengsiying
%%% @doc
%%%		自动生成文件，不要手动修改
%%% @end
%%% Created : 2016/10/12
%%%-------------------------------------------------------------------

-module(city_boss_config).

-include("common.hrl").
-include("config.hrl").

-compile([export_all]).

get_list_conf() ->
	[ city_boss_config:get(X) || X <- get_list() ].

get_list() ->
	[1, 2, 3, 4, 5, 6, 7, 8, 9, 10].

get(1) ->
	#city_boss_conf{
		id = 1,
		boss_id = 8150
	};

get(2) ->
	#city_boss_conf{
		id = 2,
		boss_id = 8151
	};

get(3) ->
	#city_boss_conf{
		id = 3,
		boss_id = 8152
	};

get(4) ->
	#city_boss_conf{
		id = 4,
		boss_id = 8153
	};

get(5) ->
	#city_boss_conf{
		id = 5,
		boss_id = 8154
	};

get(6) ->
	#city_boss_conf{
		id = 6,
		boss_id = 8155
	};

get(7) ->
	#city_boss_conf{
		id = 7,
		boss_id = 8156
	};

get(8) ->
	#city_boss_conf{
		id = 8,
		boss_id = 8157
	};

get(9) ->
	#city_boss_conf{
		id = 9,
		boss_id = 8158
	};

get(10) ->
	#city_boss_conf{
		id = 10,
		boss_id = 8159
	};

get(_Key) ->
	?ERR("undefined key from city_boss_config ~p", [_Key]).