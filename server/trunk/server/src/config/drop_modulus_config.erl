%%%-------------------------------------------------------------------
%%% @author zhengsiying
%%% @doc
%%%		自动生成文件，不要手动修改
%%% @end
%%% Created : 2016/10/12
%%%-------------------------------------------------------------------

-module(drop_modulus_config).

-include("common.hrl").
-include("config.hrl").

-compile([export_all]).

get(X) when X>=0 andalso X=< 10 -> 
 	#drop_modulus_conf{
		key = 1,
		min_lv = 0,
		max_lv = 10,
		modulus = 1
	};

get(X) when X>=11 andalso X=< 20 -> 
 	#drop_modulus_conf{
		key = 2,
		min_lv = 11,
		max_lv = 20,
		modulus = 1
	};

get(X) when X>=21 andalso X=< 30 -> 
 	#drop_modulus_conf{
		key = 3,
		min_lv = 21,
		max_lv = 30,
		modulus = 2
	};

get(X) when X>=31 andalso X=< 40 -> 
 	#drop_modulus_conf{
		key = 4,
		min_lv = 31,
		max_lv = 40,
		modulus = 2
	};

get(X) when X>=41 andalso X=< 50 -> 
 	#drop_modulus_conf{
		key = 5,
		min_lv = 41,
		max_lv = 50,
		modulus = 2
	};

get(X) when X>=51 andalso X=< 60 -> 
 	#drop_modulus_conf{
		key = 6,
		min_lv = 51,
		max_lv = 60,
		modulus = 2
	};

get(X) when X>=61 andalso X=< 99999 -> 
 	#drop_modulus_conf{
		key = 7,
		min_lv = 61,
		max_lv = 99999,
		modulus = 2
	};

get(_X) ->
	  null . 