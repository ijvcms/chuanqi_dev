%%%-------------------------------------------------------------------
%%% @author zhengsiying
%%% @doc
%%%		自动生成文件，不要手动修改
%%% @end
%%% Created : 2016/10/12
%%%-------------------------------------------------------------------

-module(arena_shop_config).

-include("common.hrl").
-include("config.hrl").

-compile([export_all]).

get_list_conf() ->
	[ arena_shop_config:get(X) || X <- get_list() ].

get_list() ->
	[1, 2, 3, 4].

get(1) ->
	#arena_shop_conf{
		key = 1,
		limit_count = 10,
		goods_id = 110049,
		reputation = 10
	};

get(2) ->
	#arena_shop_conf{
		key = 2,
		limit_count = 100,
		goods_id = 110078,
		reputation = 2
	};

get(3) ->
	#arena_shop_conf{
		key = 3,
		limit_count = 10,
		goods_id = 110055,
		reputation = 20
	};

get(4) ->
	#arena_shop_conf{
		key = 4,
		limit_count = 10,
		goods_id = 110079,
		reputation = 10
	};

get(_Key) ->
	?ERR("undefined key from arena_shop_config ~p", [_Key]).