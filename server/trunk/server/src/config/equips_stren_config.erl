%%%-------------------------------------------------------------------
%%% @author zhengsiying
%%% @doc
%%%		自动生成文件，不要手动修改
%%% @end
%%% Created : 2016/10/12
%%%-------------------------------------------------------------------

-module(equips_stren_config).

-include("common.hrl").
-include("config.hrl").

-compile([export_all]).

get_list_conf() ->
	[ equips_stren_config:get(X) || X <- get_list() ].

get_list() ->
	[1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32, 33, 34, 35, 36, 37, 38, 39, 40].

get(1) ->
	#equips_stren_conf{
		key = 1,
		coin = 8000,
		change_jade = 0,
		max_bless = 0
	};

get(2) ->
	#equips_stren_conf{
		key = 2,
		coin = 16000,
		change_jade = 0,
		max_bless = 0
	};

get(3) ->
	#equips_stren_conf{
		key = 3,
		coin = 24000,
		change_jade = 0,
		max_bless = 0
	};

get(4) ->
	#equips_stren_conf{
		key = 4,
		coin = 32000,
		change_jade = 0,
		max_bless = 0
	};

get(5) ->
	#equips_stren_conf{
		key = 5,
		coin = 40000,
		change_jade = 0,
		max_bless = 0
	};

get(6) ->
	#equips_stren_conf{
		key = 6,
		coin = 48000,
		change_jade = 38,
		max_bless = 0
	};

get(7) ->
	#equips_stren_conf{
		key = 7,
		coin = 56000,
		change_jade = 76,
		max_bless = 0
	};

get(8) ->
	#equips_stren_conf{
		key = 8,
		coin = 64000,
		change_jade = 153,
		max_bless = 0
	};

get(9) ->
	#equips_stren_conf{
		key = 9,
		coin = 72000,
		change_jade = 200,
		max_bless = 0
	};

get(10) ->
	#equips_stren_conf{
		key = 10,
		coin = 80000,
		change_jade = 250,
		max_bless = 0
	};

get(11) ->
	#equips_stren_conf{
		key = 11,
		coin = 88000,
		change_jade = 300,
		max_bless = 0
	};

get(12) ->
	#equips_stren_conf{
		key = 12,
		coin = 96000,
		change_jade = 400,
		max_bless = 0
	};

get(13) ->
	#equips_stren_conf{
		key = 13,
		coin = 104000,
		change_jade = 500,
		max_bless = 0
	};

get(14) ->
	#equips_stren_conf{
		key = 14,
		coin = 112000,
		change_jade = 600,
		max_bless = 0
	};

get(15) ->
	#equips_stren_conf{
		key = 15,
		coin = 120000,
		change_jade = 700,
		max_bless = 0
	};

get(16) ->
	#equips_stren_conf{
		key = 16,
		coin = 128000,
		change_jade = 800,
		max_bless = 0
	};

get(17) ->
	#equips_stren_conf{
		key = 17,
		coin = 136000,
		change_jade = 900,
		max_bless = 0
	};

get(18) ->
	#equips_stren_conf{
		key = 18,
		coin = 144000,
		change_jade = 1000,
		max_bless = 1280
	};

get(19) ->
	#equips_stren_conf{
		key = 19,
		coin = 152000,
		change_jade = 1100,
		max_bless = 2560
	};

get(20) ->
	#equips_stren_conf{
		key = 20,
		coin = 160000,
		change_jade = 1200,
		max_bless = 5120
	};

get(21) ->
	#equips_stren_conf{
		key = 21,
		coin = 168000,
		change_jade = 1300,
		max_bless = 0
	};

get(22) ->
	#equips_stren_conf{
		key = 22,
		coin = 176000,
		change_jade = 1400,
		max_bless = 0
	};

get(23) ->
	#equips_stren_conf{
		key = 23,
		coin = 184000,
		change_jade = 1500,
		max_bless = 0
	};

get(24) ->
	#equips_stren_conf{
		key = 24,
		coin = 192000,
		change_jade = 1600,
		max_bless = 0
	};

get(25) ->
	#equips_stren_conf{
		key = 25,
		coin = 200000,
		change_jade = 1700,
		max_bless = 0
	};

get(26) ->
	#equips_stren_conf{
		key = 26,
		coin = 208000,
		change_jade = 1800,
		max_bless = 0
	};

get(27) ->
	#equips_stren_conf{
		key = 27,
		coin = 216000,
		change_jade = 1900,
		max_bless = 0
	};

get(28) ->
	#equips_stren_conf{
		key = 28,
		coin = 224000,
		change_jade = 2000,
		max_bless = 0
	};

get(29) ->
	#equips_stren_conf{
		key = 29,
		coin = 232000,
		change_jade = 2100,
		max_bless = 0
	};

get(30) ->
	#equips_stren_conf{
		key = 30,
		coin = 240000,
		change_jade = 2200,
		max_bless = 0
	};

get(31) ->
	#equips_stren_conf{
		key = 31,
		coin = 320000,
		change_jade = 2300,
		max_bless = 5120
	};

get(32) ->
	#equips_stren_conf{
		key = 32,
		coin = 400000,
		change_jade = 2400,
		max_bless = 10240
	};

get(33) ->
	#equips_stren_conf{
		key = 33,
		coin = 480000,
		change_jade = 2500,
		max_bless = 20480
	};

get(34) ->
	#equips_stren_conf{
		key = 34,
		coin = 560000,
		change_jade = 2600,
		max_bless = 40960
	};

get(35) ->
	#equips_stren_conf{
		key = 35,
		coin = 640000,
		change_jade = 2700,
		max_bless = 81920
	};

get(36) ->
	#equips_stren_conf{
		key = 36,
		coin = 720000,
		change_jade = 2800,
		max_bless = 122880
	};

get(37) ->
	#equips_stren_conf{
		key = 37,
		coin = 800000,
		change_jade = 2900,
		max_bless = 122880
	};

get(38) ->
	#equips_stren_conf{
		key = 38,
		coin = 880000,
		change_jade = 3000,
		max_bless = 122880
	};

get(39) ->
	#equips_stren_conf{
		key = 39,
		coin = 960000,
		change_jade = 3100,
		max_bless = 122880
	};

get(40) ->
	#equips_stren_conf{
		key = 40,
		coin = 1040000,
		change_jade = 3200,
		max_bless = 122880
	};

get(_Key) ->
	?ERR("undefined key from equips_stren_config ~p", [_Key]).