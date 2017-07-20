%%%-------------------------------------------------------------------
%%% @author zhengsiying
%%% @doc
%%%		自动生成文件，不要手动修改
%%% @end
%%% Created : 2016/10/12
%%%-------------------------------------------------------------------

-module(decompose_stren_config).

-include("common.hrl").
-include("config.hrl").

-compile([export_all]).

get_list_conf() ->
	[ decompose_stren_config:get(X) || X <- get_list() ].

get_list() ->
	[0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32, 33, 34, 35, 36, 37, 38, 39, 40].

get(0) ->
	#decompose_stren_conf{
		key = 0,
		goods_list = []
	};

get(1) ->
	#decompose_stren_conf{
		key = 1,
		goods_list = [{110081,0,1}]
	};

get(2) ->
	#decompose_stren_conf{
		key = 2,
		goods_list = [{110082,0,1}]
	};

get(3) ->
	#decompose_stren_conf{
		key = 3,
		goods_list = [{110084,0,2}]
	};

get(4) ->
	#decompose_stren_conf{
		key = 4,
		goods_list = [{110085,0,2}]
	};

get(5) ->
	#decompose_stren_conf{
		key = 5,
		goods_list = [{110086,0,2}]
	};

get(6) ->
	#decompose_stren_conf{
		key = 6,
		goods_list = [{110087,0,2}]
	};

get(7) ->
	#decompose_stren_conf{
		key = 7,
		goods_list = [{110087,0,3}]
	};

get(8) ->
	#decompose_stren_conf{
		key = 8,
		goods_list = [{110087,0,5}]
	};

get(9) ->
	#decompose_stren_conf{
		key = 9,
		goods_list = [{110087,0,10}]
	};

get(10) ->
	#decompose_stren_conf{
		key = 10,
		goods_list = [{110088,0,10}]
	};

get(11) ->
	#decompose_stren_conf{
		key = 11,
		goods_list = [{110091,0,1},{110088,0,8}]
	};

get(12) ->
	#decompose_stren_conf{
		key = 12,
		goods_list = [{110092,0,1},{110088,0,8}]
	};

get(13) ->
	#decompose_stren_conf{
		key = 13,
		goods_list = [{110094,0,1},{110088,0,8}]
	};

get(14) ->
	#decompose_stren_conf{
		key = 14,
		goods_list = [{110094,0,3},{110088,0,8}]
	};

get(15) ->
	#decompose_stren_conf{
		key = 15,
		goods_list = [{110094,0,5},{110088,0,8}]
	};

get(16) ->
	#decompose_stren_conf{
		key = 16,
		goods_list = [{110094,0,10},{110088,0,8}]
	};

get(17) ->
	#decompose_stren_conf{
		key = 17,
		goods_list = [{110094,0,20},{110088,0,8}]
	};

get(18) ->
	#decompose_stren_conf{
		key = 18,
		goods_list = [{110094,0,40},{110088,0,8}]
	};

get(19) ->
	#decompose_stren_conf{
		key = 19,
		goods_list = [{110094,0,80},{110088,0,8}]
	};

get(20) ->
	#decompose_stren_conf{
		key = 20,
		goods_list = [{110094,0,160},{110088,0,8}]
	};

get(21) ->
	#decompose_stren_conf{
		key = 21,
		goods_list = [{110101,0,1},{110088,0,8},{110098,0,8}]
	};

get(22) ->
	#decompose_stren_conf{
		key = 22,
		goods_list = [{110102,0,1},{110088,0,8},{110098,0,8}]
	};

get(23) ->
	#decompose_stren_conf{
		key = 23,
		goods_list = [{110104,0,2},{110088,0,8},{110098,0,8}]
	};

get(24) ->
	#decompose_stren_conf{
		key = 24,
		goods_list = [{110104,0,3},{110088,0,8},{110098,0,8}]
	};

get(25) ->
	#decompose_stren_conf{
		key = 25,
		goods_list = [{110104,0,5},{110088,0,8},{110098,0,8}]
	};

get(26) ->
	#decompose_stren_conf{
		key = 26,
		goods_list = [{110104,0,10},{110088,0,8},{110098,0,8}]
	};

get(27) ->
	#decompose_stren_conf{
		key = 27,
		goods_list = [{110104,0,20},{110088,0,8},{110098,0,8}]
	};

get(28) ->
	#decompose_stren_conf{
		key = 28,
		goods_list = [{110104,0,40},{110088,0,8},{110098,0,8}]
	};

get(29) ->
	#decompose_stren_conf{
		key = 29,
		goods_list = [{110104,0,80},{110088,0,8},{110098,0,8}]
	};

get(30) ->
	#decompose_stren_conf{
		key = 30,
		goods_list = [{110104,0,160},{110088,0,8},{110098,0,8}]
	};

get(31) ->
	#decompose_stren_conf{
		key = 31,
		goods_list = [{110102,0,1},{110088,0,8},{110098,0,8}]
	};

get(32) ->
	#decompose_stren_conf{
		key = 32,
		goods_list = [{110103,0,1},{110088,0,8},{110098,0,8}]
	};

get(33) ->
	#decompose_stren_conf{
		key = 33,
		goods_list = [{110104,0,2},{110088,0,8},{110098,0,8}]
	};

get(34) ->
	#decompose_stren_conf{
		key = 34,
		goods_list = [{110104,0,4},{110088,0,8},{110098,0,8}]
	};

get(35) ->
	#decompose_stren_conf{
		key = 35,
		goods_list = [{110104,0,9},{110088,0,8},{110098,0,8}]
	};

get(36) ->
	#decompose_stren_conf{
		key = 36,
		goods_list = [{110104,0,19},{110088,0,8},{110098,0,8}]
	};

get(37) ->
	#decompose_stren_conf{
		key = 37,
		goods_list = [{110104,0,39},{110088,0,8},{110098,0,8}]
	};

get(38) ->
	#decompose_stren_conf{
		key = 38,
		goods_list = [{110104,0,79},{110088,0,8},{110098,0,8}]
	};

get(39) ->
	#decompose_stren_conf{
		key = 39,
		goods_list = [{110104,0,159},{110088,0,8},{110098,0,8}]
	};

get(40) ->
	#decompose_stren_conf{
		key = 40,
		goods_list = [{110104,0,319},{110088,0,8},{110098,0,8}]
	};

get(_Key) ->
	?ERR("undefined key from decompose_stren_config ~p", [_Key]).