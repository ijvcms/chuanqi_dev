%%%-------------------------------------------------------------------
%%% @author zhengsiying
%%% @doc
%%%		自动生成文件，不要手动修改
%%% @end
%%% Created : 2016/10/12
%%%-------------------------------------------------------------------

-module(equips_baptize_qian_config).

-include("common.hrl").
-include("config.hrl").

-compile([export_all]).

get_list_conf() ->
	[ equips_baptize_qian_config:get(X) || X <- get_list() ].

get_list() ->
	[5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 23, 24, 27, 28].

get(5) ->
	#equips_baptize_qian_conf{
		id = 5,
		max = 1113
	};

get(6) ->
	#equips_baptize_qian_conf{
		id = 6,
		max = 1113
	};

get(7) ->
	#equips_baptize_qian_conf{
		id = 7,
		max = 27
	};

get(8) ->
	#equips_baptize_qian_conf{
		id = 8,
		max = 55
	};

get(9) ->
	#equips_baptize_qian_conf{
		id = 9,
		max = 27
	};

get(10) ->
	#equips_baptize_qian_conf{
		id = 10,
		max = 55
	};

get(11) ->
	#equips_baptize_qian_conf{
		id = 11,
		max = 27
	};

get(12) ->
	#equips_baptize_qian_conf{
		id = 12,
		max = 55
	};

get(13) ->
	#equips_baptize_qian_conf{
		id = 13,
		max = 18
	};

get(14) ->
	#equips_baptize_qian_conf{
		id = 14,
		max = 37
	};

get(15) ->
	#equips_baptize_qian_conf{
		id = 15,
		max = 18
	};

get(16) ->
	#equips_baptize_qian_conf{
		id = 16,
		max = 37
	};

get(17) ->
	#equips_baptize_qian_conf{
		id = 17,
		max = 18
	};

get(18) ->
	#equips_baptize_qian_conf{
		id = 18,
		max = 110
	};

get(19) ->
	#equips_baptize_qian_conf{
		id = 19,
		max = 3
	};

get(20) ->
	#equips_baptize_qian_conf{
		id = 20,
		max = 3
	};

get(23) ->
	#equips_baptize_qian_conf{
		id = 23,
		max = 37
	};

get(24) ->
	#equips_baptize_qian_conf{
		id = 24,
		max = 37
	};

get(27) ->
	#equips_baptize_qian_conf{
		id = 27,
		max = 18
	};

get(28) ->
	#equips_baptize_qian_conf{
		id = 28,
		max = 18
	};

get(_Key) ->
	?ERR("undefined key from equips_baptize_qian_config ~p", [_Key]).