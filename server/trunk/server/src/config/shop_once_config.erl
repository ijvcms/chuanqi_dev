%%%-------------------------------------------------------------------
%%% @author zhengsiying
%%% @doc
%%%		自动生成文件，不要手动修改
%%% @end
%%% Created : 2016/10/12
%%%-------------------------------------------------------------------

-module(shop_once_config).

-include("common.hrl").
-include("config.hrl").

-compile([export_all]).

get_list_conf() ->
	[ shop_once_config:get(X) || X <- get_list() ].

get_list() ->
	[1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18].

get(1) ->
	#shop_once_conf{
		id = 1,
		goods_id = 110109,
		lv = 45,
		pos = 1,
		is_bind = 1,
		num = 2,
		price_now = 2000
	};

get(2) ->
	#shop_once_conf{
		id = 2,
		goods_id = 110088,
		lv = 45,
		pos = 2,
		is_bind = 1,
		num = 10,
		price_now = 320
	};

get(3) ->
	#shop_once_conf{
		id = 3,
		goods_id = 110140,
		lv = 45,
		pos = 3,
		is_bind = 1,
		num = 10,
		price_now = 200
	};

get(4) ->
	#shop_once_conf{
		id = 4,
		goods_id = 110109,
		lv = 55,
		pos = 1,
		is_bind = 1,
		num = 4,
		price_now = 3500
	};

get(5) ->
	#shop_once_conf{
		id = 5,
		goods_id = 110303,
		lv = 55,
		pos = 2,
		is_bind = 1,
		num = 1,
		price_now = 1300
	};

get(6) ->
	#shop_once_conf{
		id = 6,
		goods_id = 110091,
		lv = 55,
		pos = 3,
		is_bind = 1,
		num = 10,
		price_now = 295
	};

get(7) ->
	#shop_once_conf{
		id = 7,
		goods_id = 110163,
		lv = 65,
		pos = 1,
		is_bind = 1,
		num = 4,
		price_now = 9600
	};

get(8) ->
	#shop_once_conf{
		id = 8,
		goods_id = 110092,
		lv = 65,
		pos = 2,
		is_bind = 1,
		num = 10,
		price_now = 590
	};

get(9) ->
	#shop_once_conf{
		id = 9,
		goods_id = 110260,
		lv = 65,
		pos = 3,
		is_bind = 1,
		num = 30,
		price_now = 1275
	};

get(10) ->
	#shop_once_conf{
		id = 10,
		goods_id = 110163,
		lv = 70,
		pos = 1,
		is_bind = 1,
		num = 6,
		price_now = 14400
	};

get(11) ->
	#shop_once_conf{
		id = 11,
		goods_id = 110003,
		lv = 70,
		pos = 2,
		is_bind = 1,
		num = 50,
		price_now = 170
	};

get(12) ->
	#shop_once_conf{
		id = 12,
		goods_id = 110100,
		lv = 70,
		pos = 3,
		is_bind = 1,
		num = 20,
		price_now = 900
	};

get(13) ->
	#shop_once_conf{
		id = 13,
		goods_id = 110260,
		lv = 75,
		pos = 1,
		is_bind = 1,
		num = 100,
		price_now = 2550
	};

get(14) ->
	#shop_once_conf{
		id = 14,
		goods_id = 110093,
		lv = 75,
		pos = 2,
		is_bind = 1,
		num = 10,
		price_now = 1100
	};

get(15) ->
	#shop_once_conf{
		id = 15,
		goods_id = 110101,
		lv = 75,
		pos = 3,
		is_bind = 1,
		num = 20,
		price_now = 1780
	};

get(16) ->
	#shop_once_conf{
		id = 16,
		goods_id = 110193,
		lv = 80,
		pos = 1,
		is_bind = 1,
		num = 100,
		price_now = 330
	};

get(17) ->
	#shop_once_conf{
		id = 17,
		goods_id = 110003,
		lv = 80,
		pos = 2,
		is_bind = 1,
		num = 200,
		price_now = 690
	};

get(18) ->
	#shop_once_conf{
		id = 18,
		goods_id = 110103,
		lv = 80,
		pos = 3,
		is_bind = 1,
		num = 20,
		price_now = 7200
	};

get(_Key) ->
	?ERR("undefined key from shop_once_config ~p", [_Key]).