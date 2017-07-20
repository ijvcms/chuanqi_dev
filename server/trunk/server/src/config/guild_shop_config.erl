%%%-------------------------------------------------------------------
%%% @author zhengsiying
%%% @doc
%%%		自动生成文件，不要手动修改
%%% @end
%%% Created : 2016/10/12
%%%-------------------------------------------------------------------

-module(guild_shop_config).

-include("common.hrl").
-include("config.hrl").

-compile([export_all]).

get_list_conf() ->
	[ guild_shop_config:get(X) || X <- get_list() ].

get_list() ->
	[101, 102, 103, 104, 105, 106, 107, 108, 109, 110, 111, 112].

get(101) ->
	#guild_shop_conf{
		key = 101,
		goods_id = 110079,
		need_contribution = 2,
		limit_lv = 45,
		limit_guild_lv = 1,
		limit_count = 0
	};

get(102) ->
	#guild_shop_conf{
		key = 102,
		goods_id = 110003,
		need_contribution = 100,
		limit_lv = 45,
		limit_guild_lv = 1,
		limit_count = 20
	};

get(103) ->
	#guild_shop_conf{
		key = 103,
		goods_id = 110049,
		need_contribution = 200,
		limit_lv = 45,
		limit_guild_lv = 1,
		limit_count = 20
	};

get(104) ->
	#guild_shop_conf{
		key = 104,
		goods_id = 110078,
		need_contribution = 20,
		limit_lv = 45,
		limit_guild_lv = 1,
		limit_count = 0
	};

get(105) ->
	#guild_shop_conf{
		key = 105,
		goods_id = 110006,
		need_contribution = 3,
		limit_lv = 45,
		limit_guild_lv = 1,
		limit_count = 0
	};

get(106) ->
	#guild_shop_conf{
		key = 106,
		goods_id = 110010,
		need_contribution = 25,
		limit_lv = 50,
		limit_guild_lv = 2,
		limit_count = 0
	};

get(107) ->
	#guild_shop_conf{
		key = 107,
		goods_id = 110083,
		need_contribution = 60,
		limit_lv = 50,
		limit_guild_lv = 2,
		limit_count = 0
	};

get(108) ->
	#guild_shop_conf{
		key = 108,
		goods_id = 110013,
		need_contribution = 1000,
		limit_lv = 55,
		limit_guild_lv = 3,
		limit_count = 0
	};

get(109) ->
	#guild_shop_conf{
		key = 109,
		goods_id = 110086,
		need_contribution = 400,
		limit_lv = 55,
		limit_guild_lv = 3,
		limit_count = 0
	};

get(110) ->
	#guild_shop_conf{
		key = 110,
		goods_id = 110089,
		need_contribution = 60,
		limit_lv = 60,
		limit_guild_lv = 4,
		limit_count = 0
	};

get(111) ->
	#guild_shop_conf{
		key = 111,
		goods_id = 110016,
		need_contribution = 2000,
		limit_lv = 70,
		limit_guild_lv = 5,
		limit_count = 0
	};

get(112) ->
	#guild_shop_conf{
		key = 112,
		goods_id = 110091,
		need_contribution = 800,
		limit_lv = 70,
		limit_guild_lv = 5,
		limit_count = 0
	};

get(_Key) ->
	?ERR("undefined key from guild_shop_config ~p", [_Key]).