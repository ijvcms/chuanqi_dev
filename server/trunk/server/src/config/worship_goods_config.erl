%%%-------------------------------------------------------------------
%%% @author zhengsiying
%%% @doc
%%%		自动生成文件，不要手动修改
%%% @end
%%% Created : 2016/10/12
%%%-------------------------------------------------------------------

-module(worship_goods_config).

-include("common.hrl").
-include("config.hrl").

-compile([export_all]).

get_list() ->
	[ 
 	 #worship_goods_conf { 
 		id = 1,
		min_lv = 38,
		max_lv = 39,
		goods = [{110057,1,150000}],
		jade_goods = [{110057,1,450000}]
	},  
	 #worship_goods_conf { 
 		id = 2,
		min_lv = 40,
		max_lv = 49,
		goods = [{110057,1,150000}],
		jade_goods = [{110057,1,450000}]
	},  
	 #worship_goods_conf { 
 		id = 3,
		min_lv = 50,
		max_lv = 59,
		goods = [{110057,1,200000}],
		jade_goods = [{110057,1,600000}]
	},  
	 #worship_goods_conf { 
 		id = 4,
		min_lv = 60,
		max_lv = 69,
		goods = [{110057,1,400000}],
		jade_goods = [{110057,1,1200000}]
	},  
	 #worship_goods_conf { 
 		id = 5,
		min_lv = 70,
		max_lv = 79,
		goods = [{110057,1,600000}],
		jade_goods = [{110057,1,1800000}]
	},  
	 #worship_goods_conf { 
 		id = 6,
		min_lv = 80,
		max_lv = 89,
		goods = [{110057,1,700000}],
		jade_goods = [{110057,1,2100000}]
	},  
	 #worship_goods_conf { 
 		id = 7,
		min_lv = 90,
		max_lv = 99,
		goods = [{110057,1,800000}],
		jade_goods = [{110057,1,2400000}]
	},  
	 #worship_goods_conf { 
 		id = 8,
		min_lv = 100,
		max_lv = 109,
		goods = [{110057,1,2500000}],
		jade_goods = [{110057,1,12500000}]
	},  
	 #worship_goods_conf { 
 		id = 9,
		min_lv = 110,
		max_lv = 119,
		goods = [{110057,1,3000000}],
		jade_goods = [{110057,1,15000000}]
	},  
	 #worship_goods_conf { 
 		id = 10,
		min_lv = 120,
		max_lv = 130,
		goods = [{110057,1,3500000}],
		jade_goods = [{110057,1,18000000}]
	}].

get(X) when X>=38 andalso X=< 39 
 -> 
 	#worship_goods_conf{
		id = 1,
		min_lv = 38,
		max_lv = 39,
		goods = [{110057,1,150000}],
		jade_goods = [{110057,1,450000}]
	};

get(X) when X>=40 andalso X=< 49 
 -> 
 	#worship_goods_conf{
		id = 2,
		min_lv = 40,
		max_lv = 49,
		goods = [{110057,1,150000}],
		jade_goods = [{110057,1,450000}]
	};

get(X) when X>=50 andalso X=< 59 
 -> 
 	#worship_goods_conf{
		id = 3,
		min_lv = 50,
		max_lv = 59,
		goods = [{110057,1,200000}],
		jade_goods = [{110057,1,600000}]
	};

get(X) when X>=60 andalso X=< 69 
 -> 
 	#worship_goods_conf{
		id = 4,
		min_lv = 60,
		max_lv = 69,
		goods = [{110057,1,400000}],
		jade_goods = [{110057,1,1200000}]
	};

get(X) when X>=70 andalso X=< 79 
 -> 
 	#worship_goods_conf{
		id = 5,
		min_lv = 70,
		max_lv = 79,
		goods = [{110057,1,600000}],
		jade_goods = [{110057,1,1800000}]
	};

get(X) when X>=80 andalso X=< 89 
 -> 
 	#worship_goods_conf{
		id = 6,
		min_lv = 80,
		max_lv = 89,
		goods = [{110057,1,700000}],
		jade_goods = [{110057,1,2100000}]
	};

get(X) when X>=90 andalso X=< 99 
 -> 
 	#worship_goods_conf{
		id = 7,
		min_lv = 90,
		max_lv = 99,
		goods = [{110057,1,800000}],
		jade_goods = [{110057,1,2400000}]
	};

get(X) when X>=100 andalso X=< 109 
 -> 
 	#worship_goods_conf{
		id = 8,
		min_lv = 100,
		max_lv = 109,
		goods = [{110057,1,2500000}],
		jade_goods = [{110057,1,12500000}]
	};

get(X) when X>=110 andalso X=< 119 
 -> 
 	#worship_goods_conf{
		id = 9,
		min_lv = 110,
		max_lv = 119,
		goods = [{110057,1,3000000}],
		jade_goods = [{110057,1,15000000}]
	};

get(X) when X>=120 andalso X=< 130 
 -> 
 	#worship_goods_conf{
		id = 10,
		min_lv = 120,
		max_lv = 130,
		goods = [{110057,1,3500000}],
		jade_goods = [{110057,1,18000000}]
	};

get(_X) ->
	  null . 