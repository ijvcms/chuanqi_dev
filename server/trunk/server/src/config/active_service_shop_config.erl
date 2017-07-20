%%%-------------------------------------------------------------------
%%% @author zhengsiying
%%% @doc
%%%		自动生成文件，不要手动修改
%%% @end
%%% Created : 2016/10/12
%%%-------------------------------------------------------------------

-module(active_service_shop_config).

-include("common.hrl").
-include("config.hrl").

-compile([export_all]).

get_list_conf() ->
	[ active_service_shop_config:get(X) || X <- get_list() ].

get_list() ->
	[1, 2, 3, 4, 5, 6, 7].

get_type_list(2) ->
	[1, 2, 3, 4];
get_type_list(5) ->
	[5, 6, 7].

get(1) ->
	#active_service_shop_conf{
		key = 1,
		type = 2,
		goods_id = 110083,
		is_bind = 0,
		num = 10,
		curr_type = 2,
		price = 20,
		counter_id = 10077
	};

get(2) ->
	#active_service_shop_conf{
		key = 2,
		type = 2,
		goods_id = 110089,
		is_bind = 0,
		num = 10,
		curr_type = 2,
		price = 90,
		counter_id = 10078
	};

get(3) ->
	#active_service_shop_conf{
		key = 3,
		type = 2,
		goods_id = 110093,
		is_bind = 0,
		num = 5,
		curr_type = 2,
		price = 540,
		counter_id = 10079
	};

get(4) ->
	#active_service_shop_conf{
		key = 4,
		type = 2,
		goods_id = 110094,
		is_bind = 0,
		num = 10,
		curr_type = 2,
		price = 2100,
		counter_id = 10080
	};

get(5) ->
	#active_service_shop_conf{
		key = 5,
		type = 5,
		goods_id = 110217,
		is_bind = 0,
		num = 20,
		curr_type = 2,
		price = 120,
		counter_id = 10081
	};

get(6) ->
	#active_service_shop_conf{
		key = 6,
		type = 5,
		goods_id = 110218,
		is_bind = 0,
		num = 20,
		curr_type = 2,
		price = 220,
		counter_id = 10082
	};

get(7) ->
	#active_service_shop_conf{
		key = 7,
		type = 5,
		goods_id = 110219,
		is_bind = 0,
		num = 20,
		curr_type = 2,
		price = 360,
		counter_id = 10083
	};

get(_Key) ->
	?ERR("undefined key from active_service_shop_config ~p", [_Key]).