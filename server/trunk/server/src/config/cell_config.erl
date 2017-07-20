%%%-------------------------------------------------------------------
%%% @author zhengsiying
%%% @doc
%%%		自动生成文件，不要手动修改
%%% @end
%%% Created : 2016/10/12
%%%-------------------------------------------------------------------

-module(cell_config).

-include("common.hrl").
-include("config.hrl").
-include("record.hrl").

-compile([export_all]).

get(Lv) when Lv >= 1 andalso Lv =< 49 -> 
	#cell_conf{
		key = 1,
		min_lv = 1,
		max_lv = 49,
		cell = 50
	};

get(Lv) when Lv >= 50 andalso Lv =< 59 -> 
	#cell_conf{
		key = 2,
		min_lv = 50,
		max_lv = 59,
		cell = 60
	};

get(Lv) when Lv >= 60 andalso Lv =< 64 -> 
	#cell_conf{
		key = 3,
		min_lv = 60,
		max_lv = 64,
		cell = 70
	};

get(Lv) when Lv >= 65 andalso Lv =< 69 -> 
	#cell_conf{
		key = 4,
		min_lv = 65,
		max_lv = 69,
		cell = 80
	};

get(Lv) when Lv >= 70 andalso Lv =< 74 -> 
	#cell_conf{
		key = 5,
		min_lv = 70,
		max_lv = 74,
		cell = 90
	};

get(Lv) when Lv >= 75 andalso Lv =< 99999 -> 
	#cell_conf{
		key = 6,
		min_lv = 75,
		max_lv = 99999,
		cell = 100
	};

get(_Key) ->
	skip.