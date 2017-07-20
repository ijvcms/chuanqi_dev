%%%-------------------------------------------------------------------
%%% @author zhengsiying
%%% @doc
%%%		自动生成文件，不要手动修改
%%% @end
%%% Created : 2016/10/12
%%%-------------------------------------------------------------------

-module(active_service_merge_shop_config).

-include("common.hrl").
-include("config.hrl").

-compile([export_all]).

get_list_conf() ->
	[ active_service_merge_shop_config:get(X) || X <- get_list() ].

get_list() ->
	[1, 2, 3, 4].

get_type_list(2) ->
	[1, 2, 3, 4].

get(1) ->
	#active_service_merge_shop_conf{
		key = 1,
		type = 2,
		goods_id = 110284,
		is_bind = 1,
		num = 200,
		curr_type = 2,
		price = 9999,
		price_old = 12000,
		counter_id = 10126
	};

get(2) ->
	#active_service_merge_shop_conf{
		key = 2,
		type = 2,
		goods_id = 110259,
		is_bind = 1,
		num = 100,
		curr_type = 2,
		price = 4688,
		price_old = 5000,
		counter_id = 10127
	};

get(3) ->
	#active_service_merge_shop_conf{
		key = 3,
		type = 2,
		goods_id = 110003,
		is_bind = 1,
		num = 200,
		curr_type = 2,
		price = 688,
		price_old = 1000,
		counter_id = 10128
	};

get(4) ->
	#active_service_merge_shop_conf{
		key = 4,
		type = 2,
		goods_id = 110294,
		is_bind = 1,
		num = 1,
		curr_type = 2,
		price = 4800,
		price_old = 5000,
		counter_id = 10129
	};

get(_Key) ->
	?ERR("undefined key from active_service_merge_shop_config ~p", [_Key]).