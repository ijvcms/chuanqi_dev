%%%-------------------------------------------------------------------
%%% @author zhengsiying
%%% @doc
%%%		自动生成文件，不要手动修改
%%% @end
%%% Created : 2016/10/12
%%%-------------------------------------------------------------------

-module(mounts_config).

-include("common.hrl").
-include("config.hrl").

-compile([export_all]).

get_list_conf() ->
	[ mounts_config:get(X) || X <- get_list() ].

get_list() ->
	[1000, 1001, 1002, 1003, 1004, 1005, 1006, 1007, 1008, 1009, 1010, 1011, 1012, 1013, 1014].

get(1000) ->
	#mounts_conf{
		key = 1000,
		goods_id = 309411,
		limit_lv = 1,
		rate = 10000,
		stuff = [{110259,60}],
		next_id = 309412
	};

get(1001) ->
	#mounts_conf{
		key = 1001,
		goods_id = 309412,
		limit_lv = 1,
		rate = 10000,
		stuff = [{110259,200}],
		next_id = 309413
	};

get(1002) ->
	#mounts_conf{
		key = 1002,
		goods_id = 309413,
		limit_lv = 1,
		rate = 10000,
		stuff = [{110259,800}],
		next_id = 309414
	};

get(1003) ->
	#mounts_conf{
		key = 1003,
		goods_id = 309414,
		limit_lv = 1,
		rate = 10000,
		stuff = [{110259,2400}],
		next_id = 309415
	};

get(1004) ->
	#mounts_conf{
		key = 1004,
		goods_id = 309415,
		limit_lv = 1,
		rate = 10000,
		stuff = [],
		next_id = 0
	};

get(1005) ->
	#mounts_conf{
		key = 1005,
		goods_id = 309416,
		limit_lv = 1,
		rate = 10000,
		stuff = [{110259,60}],
		next_id = 309417
	};

get(1006) ->
	#mounts_conf{
		key = 1006,
		goods_id = 309417,
		limit_lv = 1,
		rate = 10000,
		stuff = [{110259,200}],
		next_id = 309418
	};

get(1007) ->
	#mounts_conf{
		key = 1007,
		goods_id = 309418,
		limit_lv = 1,
		rate = 10000,
		stuff = [{110259,800}],
		next_id = 309419
	};

get(1008) ->
	#mounts_conf{
		key = 1008,
		goods_id = 309419,
		limit_lv = 1,
		rate = 10000,
		stuff = [{110259,2400}],
		next_id = 309420
	};

get(1009) ->
	#mounts_conf{
		key = 1009,
		goods_id = 309420,
		limit_lv = 1,
		rate = 10000,
		stuff = [],
		next_id = 0
	};

get(1010) ->
	#mounts_conf{
		key = 1010,
		goods_id = 309421,
		limit_lv = 1,
		rate = 10000,
		stuff = [{110259,60}],
		next_id = 309422
	};

get(1011) ->
	#mounts_conf{
		key = 1011,
		goods_id = 309422,
		limit_lv = 1,
		rate = 10000,
		stuff = [{110259,200}],
		next_id = 309423
	};

get(1012) ->
	#mounts_conf{
		key = 1012,
		goods_id = 309423,
		limit_lv = 1,
		rate = 10000,
		stuff = [{110259,800}],
		next_id = 309424
	};

get(1013) ->
	#mounts_conf{
		key = 1013,
		goods_id = 309424,
		limit_lv = 1,
		rate = 10000,
		stuff = [{110259,2400}],
		next_id = 309425
	};

get(1014) ->
	#mounts_conf{
		key = 1014,
		goods_id = 309425,
		limit_lv = 1,
		rate = 10000,
		stuff = [],
		next_id = 0
	};

get(_Key) ->
	?ERR("undefined key from mounts_config ~p", [_Key]).