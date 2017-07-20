%%%-------------------------------------------------------------------
%%% @author zhengsiying
%%% @doc
%%%		自动生成文件，不要手动修改
%%% @end
%%% Created : 2016/10/12
%%%-------------------------------------------------------------------

-module(equips_type_config).

-include("common.hrl").
-include("config.hrl").

-compile([export_all]).

get_list_conf() ->
	[ equips_type_config:get(X) || X <- get_list() ].

get_list() ->
	[1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 13, 14, 15, 21, 22, 23, 24, 25, 26, 27, 28, 29].

get(1) ->
	#equips_type_conf{
		id = 1,
		id_qian = [1]
	};

get(2) ->
	#equips_type_conf{
		id = 2,
		id_qian = [2]
	};

get(3) ->
	#equips_type_conf{
		id = 3,
		id_qian = [3]
	};

get(4) ->
	#equips_type_conf{
		id = 4,
		id_qian = [4]
	};

get(5) ->
	#equips_type_conf{
		id = 5,
		id_qian = [5]
	};

get(6) ->
	#equips_type_conf{
		id = 6,
		id_qian = [6,11]
	};

get(7) ->
	#equips_type_conf{
		id = 7,
		id_qian = [7,12]
	};

get(8) ->
	#equips_type_conf{
		id = 8,
		id_qian = [8]
	};

get(9) ->
	#equips_type_conf{
		id = 9,
		id_qian = [9]
	};

get(10) ->
	#equips_type_conf{
		id = 10,
		id_qian = [10]
	};

get(13) ->
	#equips_type_conf{
		id = 13,
		id_qian = [13]
	};

get(14) ->
	#equips_type_conf{
		id = 14,
		id_qian = [14]
	};

get(15) ->
	#equips_type_conf{
		id = 15,
		id_qian = [15]
	};

get(21) ->
	#equips_type_conf{
		id = 21,
		id_qian = [21]
	};

get(22) ->
	#equips_type_conf{
		id = 22,
		id_qian = [22]
	};

get(23) ->
	#equips_type_conf{
		id = 23,
		id_qian = [23]
	};

get(24) ->
	#equips_type_conf{
		id = 24,
		id_qian = [24]
	};

get(25) ->
	#equips_type_conf{
		id = 25,
		id_qian = [25]
	};

get(26) ->
	#equips_type_conf{
		id = 26,
		id_qian = [26]
	};

get(27) ->
	#equips_type_conf{
		id = 27,
		id_qian = [27]
	};

get(28) ->
	#equips_type_conf{
		id = 28,
		id_qian = [28]
	};

get(29) ->
	#equips_type_conf{
		id = 29,
		id_qian = [29,30]
	};

get(_Key) ->
	?ERR("undefined key from equips_type_config ~p", [_Key]).