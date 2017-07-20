%%%-------------------------------------------------------------------
%%% @author zhengsiying
%%% @doc
%%%		自动生成文件，不要手动修改
%%% @end
%%% Created : 2016/10/12
%%%-------------------------------------------------------------------

-module(skill_tree_config).

-include("common.hrl").
-include("config.hrl").

-compile([export_all]).

get_list() ->
	[{10100,1}, {10100,2}, {10100,3}, {10200,1}, {10200,2}, {10200,3}, {10300,1}, {10300,2}, {10300,3}, {10300,4}, {10400,1}, {10400,2}, {10400,3}, {10500,1}, {10500,2}, {10500,3}, {10500,4}, {10600,1}, {10600,2}, {10600,3}, {10700,1}, {10700,2}, {10700,3}, {10700,4}, {10800,1}, {10800,2}, {10800,3}, {10800,4}, {20100,1}, {20100,2}, {20100,3}, {20200,1}, {20200,2}, {20200,3}, {20200,4}, {20300,1}, {20300,2}, {20300,3}, {20400,1}, {20400,2}, {20400,3}, {20400,4}, {20500,1}, {20500,2}, {20500,3}, {20600,1}, {20600,2}, {20600,3}, {20700,1}, {20700,2}, {20700,3}, {20800,1}, {20800,2}, {20800,3}, {21000,1}, {21000,2}, {21000,3}, {21000,4}, {20900,1}, {20900,2}, {20900,3}, {20900,4}, {30100,1}, {30100,2}, {30100,3}, {30200,1}, {30200,2}, {30200,3}, {30200,4}, {30300,1}, {30300,2}, {30300,3}, {30300,4}, {30800,1}, {30800,2}, {30800,3}, {30400,1}, {30400,2}, {30400,3}, {30500,1}, {30500,2}, {30500,3}, {30600,1}, {30600,2}, {30600,3}, {30600,4}, {30700,1}, {30700,2}, {30700,3}, {30700,4}, {51200,1}, {51200,2}, {51200,3}].

get({10100,1}) ->
	#skill_tree_conf{
		skill_id = 10100,
		lv = 1,
		type = 1,
		auto_type = 1,
		career = 1000,
		limit_lv = 1,
		goods_1 = 0,
		num_1 = 0,
		next_exp = 1000,
		trigger_type = 2
	};

get({10100,2}) ->
	#skill_tree_conf{
		skill_id = 10100,
		lv = 2,
		type = 1,
		auto_type = 1,
		career = 1000,
		limit_lv = 10,
		goods_1 = 110041,
		num_1 = 0,
		next_exp = 5000,
		trigger_type = 2
	};

get({10100,3}) ->
	#skill_tree_conf{
		skill_id = 10100,
		lv = 3,
		type = 1,
		auto_type = 1,
		career = 1000,
		limit_lv = 20,
		goods_1 = 0,
		num_1 = 0,
		next_exp = 0,
		trigger_type = 2
	};

get({10200,1}) ->
	#skill_tree_conf{
		skill_id = 10200,
		lv = 1,
		type = 2,
		auto_type = 0,
		career = 1000,
		limit_lv = 1,
		goods_1 = 110019,
		num_1 = 1,
		next_exp = 1000,
		trigger_type = 4
	};

get({10200,2}) ->
	#skill_tree_conf{
		skill_id = 10200,
		lv = 2,
		type = 2,
		auto_type = 0,
		career = 1000,
		limit_lv = 20,
		goods_1 = 0,
		num_1 = 0,
		next_exp = 5000,
		trigger_type = 4
	};

get({10200,3}) ->
	#skill_tree_conf{
		skill_id = 10200,
		lv = 3,
		type = 2,
		auto_type = 0,
		career = 1000,
		limit_lv = 30,
		goods_1 = 0,
		num_1 = 0,
		next_exp = 0,
		trigger_type = 4
	};

get({10300,1}) ->
	#skill_tree_conf{
		skill_id = 10300,
		lv = 1,
		type = 1,
		auto_type = 1,
		career = 1000,
		limit_lv = 1,
		goods_1 = 110020,
		num_1 = 1,
		next_exp = 1000,
		trigger_type = 2
	};

get({10300,2}) ->
	#skill_tree_conf{
		skill_id = 10300,
		lv = 2,
		type = 1,
		auto_type = 1,
		career = 1000,
		limit_lv = 30,
		goods_1 = 0,
		num_1 = 0,
		next_exp = 5000,
		trigger_type = 2
	};

get({10300,3}) ->
	#skill_tree_conf{
		skill_id = 10300,
		lv = 3,
		type = 1,
		auto_type = 1,
		career = 1000,
		limit_lv = 40,
		goods_1 = 0,
		num_1 = 0,
		next_exp = 0,
		trigger_type = 2
	};

get({10300,4}) ->
	#skill_tree_conf{
		skill_id = 10300,
		lv = 4,
		type = 1,
		auto_type = 1,
		career = 1000,
		limit_lv = 70,
		goods_1 = 110222,
		num_1 = 20,
		next_exp = 0,
		trigger_type = 2
	};

get({10400,1}) ->
	#skill_tree_conf{
		skill_id = 10400,
		lv = 1,
		type = 1,
		auto_type = 2,
		career = 1000,
		limit_lv = 1,
		goods_1 = 110021,
		num_1 = 1,
		next_exp = 1000,
		trigger_type = 2
	};

get({10400,2}) ->
	#skill_tree_conf{
		skill_id = 10400,
		lv = 2,
		type = 1,
		auto_type = 2,
		career = 1000,
		limit_lv = 40,
		goods_1 = 0,
		num_1 = 0,
		next_exp = 5000,
		trigger_type = 2
	};

get({10400,3}) ->
	#skill_tree_conf{
		skill_id = 10400,
		lv = 3,
		type = 1,
		auto_type = 2,
		career = 1000,
		limit_lv = 45,
		goods_1 = 0,
		num_1 = 0,
		next_exp = 0,
		trigger_type = 2
	};

get({10500,1}) ->
	#skill_tree_conf{
		skill_id = 10500,
		lv = 1,
		type = 1,
		auto_type = 3,
		career = 1000,
		limit_lv = 47,
		goods_1 = 110023,
		num_1 = 1,
		next_exp = 300,
		trigger_type = 1
	};

get({10500,2}) ->
	#skill_tree_conf{
		skill_id = 10500,
		lv = 2,
		type = 1,
		auto_type = 3,
		career = 1000,
		limit_lv = 50,
		goods_1 = 0,
		num_1 = 0,
		next_exp = 2000,
		trigger_type = 1
	};

get({10500,3}) ->
	#skill_tree_conf{
		skill_id = 10500,
		lv = 3,
		type = 1,
		auto_type = 3,
		career = 1000,
		limit_lv = 52,
		goods_1 = 0,
		num_1 = 0,
		next_exp = 0,
		trigger_type = 1
	};

get({10500,4}) ->
	#skill_tree_conf{
		skill_id = 10500,
		lv = 4,
		type = 1,
		auto_type = 3,
		career = 1000,
		limit_lv = 80,
		goods_1 = 110222,
		num_1 = 80,
		next_exp = 0,
		trigger_type = 1
	};

get({10600,1}) ->
	#skill_tree_conf{
		skill_id = 10600,
		lv = 1,
		type = 1,
		auto_type = 0,
		career = 1000,
		limit_lv = 1,
		goods_1 = 110022,
		num_1 = 1,
		next_exp = 100,
		trigger_type = 1
	};

get({10600,2}) ->
	#skill_tree_conf{
		skill_id = 10600,
		lv = 2,
		type = 1,
		auto_type = 0,
		career = 1000,
		limit_lv = 46,
		goods_1 = 0,
		num_1 = 0,
		next_exp = 300,
		trigger_type = 1
	};

get({10600,3}) ->
	#skill_tree_conf{
		skill_id = 10600,
		lv = 3,
		type = 1,
		auto_type = 0,
		career = 1000,
		limit_lv = 50,
		goods_1 = 0,
		num_1 = 0,
		next_exp = 0,
		trigger_type = 1
	};

get({10700,1}) ->
	#skill_tree_conf{
		skill_id = 10700,
		lv = 1,
		type = 1,
		auto_type = 2,
		career = 1000,
		limit_lv = 50,
		goods_1 = 110024,
		num_1 = 1,
		next_exp = 1000,
		trigger_type = 2
	};

get({10700,2}) ->
	#skill_tree_conf{
		skill_id = 10700,
		lv = 2,
		type = 1,
		auto_type = 2,
		career = 1000,
		limit_lv = 55,
		goods_1 = 0,
		num_1 = 0,
		next_exp = 5000,
		trigger_type = 2
	};

get({10700,3}) ->
	#skill_tree_conf{
		skill_id = 10700,
		lv = 3,
		type = 1,
		auto_type = 2,
		career = 1000,
		limit_lv = 60,
		goods_1 = 0,
		num_1 = 0,
		next_exp = 0,
		trigger_type = 2
	};

get({10700,4}) ->
	#skill_tree_conf{
		skill_id = 10700,
		lv = 4,
		type = 1,
		auto_type = 2,
		career = 1000,
		limit_lv = 75,
		goods_1 = 110222,
		num_1 = 40,
		next_exp = 0,
		trigger_type = 2
	};

get({10800,1}) ->
	#skill_tree_conf{
		skill_id = 10800,
		lv = 1,
		type = 1,
		auto_type = 4,
		career = 1000,
		limit_lv = 50,
		goods_1 = 110025,
		num_1 = 1,
		next_exp = 100,
		trigger_type = 2
	};

get({10800,2}) ->
	#skill_tree_conf{
		skill_id = 10800,
		lv = 2,
		type = 1,
		auto_type = 4,
		career = 1000,
		limit_lv = 55,
		goods_1 = 0,
		num_1 = 0,
		next_exp = 300,
		trigger_type = 2
	};

get({10800,3}) ->
	#skill_tree_conf{
		skill_id = 10800,
		lv = 3,
		type = 1,
		auto_type = 4,
		career = 1000,
		limit_lv = 60,
		goods_1 = 0,
		num_1 = 0,
		next_exp = 0,
		trigger_type = 2
	};

get({10800,4}) ->
	#skill_tree_conf{
		skill_id = 10800,
		lv = 4,
		type = 1,
		auto_type = 4,
		career = 1000,
		limit_lv = 85,
		goods_1 = 110222,
		num_1 = 160,
		next_exp = 0,
		trigger_type = 2
	};

get({20100,1}) ->
	#skill_tree_conf{
		skill_id = 20100,
		lv = 1,
		type = 1,
		auto_type = 1,
		career = 2000,
		limit_lv = 1,
		goods_1 = 0,
		num_1 = 0,
		next_exp = 1000,
		trigger_type = 2
	};

get({20100,2}) ->
	#skill_tree_conf{
		skill_id = 20100,
		lv = 2,
		type = 1,
		auto_type = 1,
		career = 2000,
		limit_lv = 10,
		goods_1 = 0,
		num_1 = 0,
		next_exp = 5000,
		trigger_type = 2
	};

get({20100,3}) ->
	#skill_tree_conf{
		skill_id = 20100,
		lv = 3,
		type = 1,
		auto_type = 1,
		career = 2000,
		limit_lv = 20,
		goods_1 = 0,
		num_1 = 0,
		next_exp = 0,
		trigger_type = 2
	};

get({20200,1}) ->
	#skill_tree_conf{
		skill_id = 20200,
		lv = 1,
		type = 1,
		auto_type = 1,
		career = 2000,
		limit_lv = 1,
		goods_1 = 110033,
		num_1 = 1,
		next_exp = 1000,
		trigger_type = 2
	};

get({20200,2}) ->
	#skill_tree_conf{
		skill_id = 20200,
		lv = 2,
		type = 1,
		auto_type = 1,
		career = 2000,
		limit_lv = 20,
		goods_1 = 0,
		num_1 = 0,
		next_exp = 5000,
		trigger_type = 2
	};

get({20200,3}) ->
	#skill_tree_conf{
		skill_id = 20200,
		lv = 3,
		type = 1,
		auto_type = 1,
		career = 2000,
		limit_lv = 30,
		goods_1 = 0,
		num_1 = 0,
		next_exp = 0,
		trigger_type = 2
	};

get({20200,4}) ->
	#skill_tree_conf{
		skill_id = 20200,
		lv = 4,
		type = 1,
		auto_type = 1,
		career = 2000,
		limit_lv = 70,
		goods_1 = 110222,
		num_1 = 20,
		next_exp = 0,
		trigger_type = 2
	};

get({20300,1}) ->
	#skill_tree_conf{
		skill_id = 20300,
		lv = 1,
		type = 1,
		auto_type = 4,
		career = 2000,
		limit_lv = 1,
		goods_1 = 110034,
		num_1 = 1,
		next_exp = 1000,
		trigger_type = 1
	};

get({20300,2}) ->
	#skill_tree_conf{
		skill_id = 20300,
		lv = 2,
		type = 1,
		auto_type = 4,
		career = 2000,
		limit_lv = 30,
		goods_1 = 0,
		num_1 = 0,
		next_exp = 5000,
		trigger_type = 1
	};

get({20300,3}) ->
	#skill_tree_conf{
		skill_id = 20300,
		lv = 3,
		type = 1,
		auto_type = 4,
		career = 2000,
		limit_lv = 40,
		goods_1 = 0,
		num_1 = 0,
		next_exp = 0,
		trigger_type = 1
	};

get({20400,1}) ->
	#skill_tree_conf{
		skill_id = 20400,
		lv = 1,
		type = 1,
		auto_type = 3,
		career = 2000,
		limit_lv = 30,
		goods_1 = 110035,
		num_1 = 1,
		next_exp = 1000,
		trigger_type = 1
	};

get({20400,2}) ->
	#skill_tree_conf{
		skill_id = 20400,
		lv = 2,
		type = 1,
		auto_type = 3,
		career = 2000,
		limit_lv = 35,
		goods_1 = 0,
		num_1 = 0,
		next_exp = 5000,
		trigger_type = 1
	};

get({20400,3}) ->
	#skill_tree_conf{
		skill_id = 20400,
		lv = 3,
		type = 1,
		auto_type = 3,
		career = 2000,
		limit_lv = 40,
		goods_1 = 0,
		num_1 = 0,
		next_exp = 0,
		trigger_type = 1
	};

get({20400,4}) ->
	#skill_tree_conf{
		skill_id = 20400,
		lv = 4,
		type = 1,
		auto_type = 3,
		career = 2000,
		limit_lv = 75,
		goods_1 = 110222,
		num_1 = 40,
		next_exp = 0,
		trigger_type = 1
	};

get({20500,1}) ->
	#skill_tree_conf{
		skill_id = 20500,
		lv = 1,
		type = 1,
		auto_type = 2,
		career = 2000,
		limit_lv = 1,
		goods_1 = 110036,
		num_1 = 1,
		next_exp = 1000,
		trigger_type = 2
	};

get({20500,2}) ->
	#skill_tree_conf{
		skill_id = 20500,
		lv = 2,
		type = 1,
		auto_type = 2,
		career = 2000,
		limit_lv = 40,
		goods_1 = 0,
		num_1 = 0,
		next_exp = 5000,
		trigger_type = 2
	};

get({20500,3}) ->
	#skill_tree_conf{
		skill_id = 20500,
		lv = 3,
		type = 1,
		auto_type = 2,
		career = 2000,
		limit_lv = 45,
		goods_1 = 0,
		num_1 = 0,
		next_exp = 0,
		trigger_type = 2
	};

get({20600,1}) ->
	#skill_tree_conf{
		skill_id = 20600,
		lv = 1,
		type = 1,
		auto_type = 2,
		career = 2000,
		limit_lv = 47,
		goods_1 = 110038,
		num_1 = 1,
		next_exp = 1000,
		trigger_type = 2
	};

get({20600,2}) ->
	#skill_tree_conf{
		skill_id = 20600,
		lv = 2,
		type = 1,
		auto_type = 2,
		career = 2000,
		limit_lv = 50,
		goods_1 = 0,
		num_1 = 0,
		next_exp = 5000,
		trigger_type = 2
	};

get({20600,3}) ->
	#skill_tree_conf{
		skill_id = 20600,
		lv = 3,
		type = 1,
		auto_type = 2,
		career = 2000,
		limit_lv = 52,
		goods_1 = 0,
		num_1 = 0,
		next_exp = 0,
		trigger_type = 2
	};

get({20700,1}) ->
	#skill_tree_conf{
		skill_id = 20700,
		lv = 1,
		type = 1,
		auto_type = 0,
		career = 2000,
		limit_lv = 40,
		goods_1 = 110037,
		num_1 = 1,
		next_exp = 1000,
		trigger_type = 2
	};

get({20700,2}) ->
	#skill_tree_conf{
		skill_id = 20700,
		lv = 2,
		type = 1,
		auto_type = 0,
		career = 2000,
		limit_lv = 46,
		goods_1 = 0,
		num_1 = 0,
		next_exp = 5000,
		trigger_type = 2
	};

get({20700,3}) ->
	#skill_tree_conf{
		skill_id = 20700,
		lv = 3,
		type = 1,
		auto_type = 0,
		career = 2000,
		limit_lv = 50,
		goods_1 = 0,
		num_1 = 0,
		next_exp = 0,
		trigger_type = 2
	};

get({20800,1}) ->
	#skill_tree_conf{
		skill_id = 20800,
		lv = 1,
		type = 1,
		auto_type = 0,
		career = 2000,
		limit_lv = 1,
		goods_1 = 110039,
		num_1 = 1,
		next_exp = 100,
		trigger_type = 1
	};

get({20800,2}) ->
	#skill_tree_conf{
		skill_id = 20800,
		lv = 2,
		type = 1,
		auto_type = 0,
		career = 2000,
		limit_lv = 50,
		goods_1 = 0,
		num_1 = 0,
		next_exp = 300,
		trigger_type = 1
	};

get({20800,3}) ->
	#skill_tree_conf{
		skill_id = 20800,
		lv = 3,
		type = 1,
		auto_type = 0,
		career = 2000,
		limit_lv = 52,
		goods_1 = 0,
		num_1 = 0,
		next_exp = 0,
		trigger_type = 1
	};

get({21000,1}) ->
	#skill_tree_conf{
		skill_id = 21000,
		lv = 1,
		type = 1,
		auto_type = 0,
		career = 2000,
		limit_lv = 50,
		goods_1 = 110067,
		num_1 = 1,
		next_exp = 100,
		trigger_type = 5
	};

get({21000,2}) ->
	#skill_tree_conf{
		skill_id = 21000,
		lv = 2,
		type = 1,
		auto_type = 0,
		career = 2000,
		limit_lv = 55,
		goods_1 = 0,
		num_1 = 0,
		next_exp = 300,
		trigger_type = 5
	};

get({21000,3}) ->
	#skill_tree_conf{
		skill_id = 21000,
		lv = 3,
		type = 1,
		auto_type = 0,
		career = 2000,
		limit_lv = 60,
		goods_1 = 0,
		num_1 = 0,
		next_exp = 0,
		trigger_type = 5
	};

get({21000,4}) ->
	#skill_tree_conf{
		skill_id = 21000,
		lv = 4,
		type = 1,
		auto_type = 0,
		career = 2000,
		limit_lv = 80,
		goods_1 = 110222,
		num_1 = 80,
		next_exp = 0,
		trigger_type = 5
	};

get({20900,1}) ->
	#skill_tree_conf{
		skill_id = 20900,
		lv = 1,
		type = 1,
		auto_type = 2,
		career = 2000,
		limit_lv = 50,
		goods_1 = 110040,
		num_1 = 1,
		next_exp = 1000,
		trigger_type = 2
	};

get({20900,2}) ->
	#skill_tree_conf{
		skill_id = 20900,
		lv = 2,
		type = 1,
		auto_type = 2,
		career = 2000,
		limit_lv = 55,
		goods_1 = 0,
		num_1 = 0,
		next_exp = 5000,
		trigger_type = 2
	};

get({20900,3}) ->
	#skill_tree_conf{
		skill_id = 20900,
		lv = 3,
		type = 1,
		auto_type = 2,
		career = 2000,
		limit_lv = 60,
		goods_1 = 0,
		num_1 = 0,
		next_exp = 0,
		trigger_type = 2
	};

get({20900,4}) ->
	#skill_tree_conf{
		skill_id = 20900,
		lv = 4,
		type = 1,
		auto_type = 2,
		career = 2000,
		limit_lv = 85,
		goods_1 = 110222,
		num_1 = 160,
		next_exp = 0,
		trigger_type = 2
	};

get({30100,1}) ->
	#skill_tree_conf{
		skill_id = 30100,
		lv = 1,
		type = 1,
		auto_type = 1,
		career = 3000,
		limit_lv = 1,
		goods_1 = 0,
		num_1 = 0,
		next_exp = 1000,
		trigger_type = 2
	};

get({30100,2}) ->
	#skill_tree_conf{
		skill_id = 30100,
		lv = 2,
		type = 1,
		auto_type = 1,
		career = 3000,
		limit_lv = 10,
		goods_1 = 0,
		num_1 = 0,
		next_exp = 5000,
		trigger_type = 2
	};

get({30100,3}) ->
	#skill_tree_conf{
		skill_id = 30100,
		lv = 3,
		type = 1,
		auto_type = 1,
		career = 3000,
		limit_lv = 20,
		goods_1 = 0,
		num_1 = 0,
		next_exp = 0,
		trigger_type = 2
	};

get({30200,1}) ->
	#skill_tree_conf{
		skill_id = 30200,
		lv = 1,
		type = 1,
		auto_type = 3,
		career = 3000,
		limit_lv = 1,
		goods_1 = 110028,
		num_1 = 1,
		next_exp = 100,
		trigger_type = 1
	};

get({30200,2}) ->
	#skill_tree_conf{
		skill_id = 30200,
		lv = 2,
		type = 1,
		auto_type = 3,
		career = 3000,
		limit_lv = 30,
		goods_1 = 0,
		num_1 = 0,
		next_exp = 300,
		trigger_type = 1
	};

get({30200,3}) ->
	#skill_tree_conf{
		skill_id = 30200,
		lv = 3,
		type = 1,
		auto_type = 3,
		career = 3000,
		limit_lv = 40,
		goods_1 = 0,
		num_1 = 0,
		next_exp = 0,
		trigger_type = 1
	};

get({30200,4}) ->
	#skill_tree_conf{
		skill_id = 30200,
		lv = 4,
		type = 1,
		auto_type = 3,
		career = 3000,
		limit_lv = 75,
		goods_1 = 110222,
		num_1 = 40,
		next_exp = 0,
		trigger_type = 1
	};

get({30300,1}) ->
	#skill_tree_conf{
		skill_id = 30300,
		lv = 1,
		type = 1,
		auto_type = 4,
		career = 3000,
		limit_lv = 1,
		goods_1 = 110027,
		num_1 = 1,
		next_exp = 100,
		trigger_type = 1
	};

get({30300,2}) ->
	#skill_tree_conf{
		skill_id = 30300,
		lv = 2,
		type = 1,
		auto_type = 4,
		career = 3000,
		limit_lv = 20,
		goods_1 = 0,
		num_1 = 0,
		next_exp = 300,
		trigger_type = 1
	};

get({30300,3}) ->
	#skill_tree_conf{
		skill_id = 30300,
		lv = 3,
		type = 1,
		auto_type = 4,
		career = 3000,
		limit_lv = 30,
		goods_1 = 0,
		num_1 = 0,
		next_exp = 0,
		trigger_type = 1
	};

get({30300,4}) ->
	#skill_tree_conf{
		skill_id = 30300,
		lv = 4,
		type = 1,
		auto_type = 4,
		career = 3000,
		limit_lv = 70,
		goods_1 = 110222,
		num_1 = 20,
		next_exp = 0,
		trigger_type = 1
	};

get({30800,1}) ->
	#skill_tree_conf{
		skill_id = 30800,
		lv = 1,
		type = 1,
		auto_type = 3,
		career = 3000,
		limit_lv = 1,
		goods_1 = 110066,
		num_1 = 1,
		next_exp = 100,
		trigger_type = 3
	};

get({30800,2}) ->
	#skill_tree_conf{
		skill_id = 30800,
		lv = 2,
		type = 1,
		auto_type = 3,
		career = 3000,
		limit_lv = 30,
		goods_1 = 0,
		num_1 = 0,
		next_exp = 200,
		trigger_type = 3
	};

get({30800,3}) ->
	#skill_tree_conf{
		skill_id = 30800,
		lv = 3,
		type = 1,
		auto_type = 3,
		career = 3000,
		limit_lv = 40,
		goods_1 = 0,
		num_1 = 0,
		next_exp = 0,
		trigger_type = 3
	};

get({30400,1}) ->
	#skill_tree_conf{
		skill_id = 30400,
		lv = 1,
		type = 1,
		auto_type = 0,
		career = 3000,
		limit_lv = 1,
		goods_1 = 110029,
		num_1 = 1,
		next_exp = 100,
		trigger_type = 1
	};

get({30400,2}) ->
	#skill_tree_conf{
		skill_id = 30400,
		lv = 2,
		type = 1,
		auto_type = 0,
		career = 3000,
		limit_lv = 35,
		goods_1 = 0,
		num_1 = 0,
		next_exp = 300,
		trigger_type = 1
	};

get({30400,3}) ->
	#skill_tree_conf{
		skill_id = 30400,
		lv = 3,
		type = 1,
		auto_type = 0,
		career = 3000,
		limit_lv = 40,
		goods_1 = 0,
		num_1 = 0,
		next_exp = 0,
		trigger_type = 1
	};

get({30500,1}) ->
	#skill_tree_conf{
		skill_id = 30500,
		lv = 1,
		type = 1,
		auto_type = 3,
		career = 3000,
		limit_lv = 1,
		goods_1 = 110030,
		num_1 = 1,
		next_exp = 100,
		trigger_type = 1
	};

get({30500,2}) ->
	#skill_tree_conf{
		skill_id = 30500,
		lv = 2,
		type = 1,
		auto_type = 3,
		career = 3000,
		limit_lv = 46,
		goods_1 = 0,
		num_1 = 0,
		next_exp = 300,
		trigger_type = 1
	};

get({30500,3}) ->
	#skill_tree_conf{
		skill_id = 30500,
		lv = 3,
		type = 1,
		auto_type = 3,
		career = 3000,
		limit_lv = 50,
		goods_1 = 0,
		num_1 = 0,
		next_exp = 0,
		trigger_type = 1
	};

get({30600,1}) ->
	#skill_tree_conf{
		skill_id = 30600,
		lv = 1,
		type = 1,
		auto_type = 3,
		career = 3000,
		limit_lv = 50,
		goods_1 = 110031,
		num_1 = 1,
		next_exp = 100,
		trigger_type = 3
	};

get({30600,2}) ->
	#skill_tree_conf{
		skill_id = 30600,
		lv = 2,
		type = 1,
		auto_type = 3,
		career = 3000,
		limit_lv = 55,
		goods_1 = 0,
		num_1 = 0,
		next_exp = 300,
		trigger_type = 3
	};

get({30600,3}) ->
	#skill_tree_conf{
		skill_id = 30600,
		lv = 3,
		type = 1,
		auto_type = 3,
		career = 3000,
		limit_lv = 60,
		goods_1 = 0,
		num_1 = 0,
		next_exp = 0,
		trigger_type = 3
	};

get({30600,4}) ->
	#skill_tree_conf{
		skill_id = 30600,
		lv = 4,
		type = 1,
		auto_type = 3,
		career = 3000,
		limit_lv = 80,
		goods_1 = 110222,
		num_1 = 80,
		next_exp = 0,
		trigger_type = 3
	};

get({30700,1}) ->
	#skill_tree_conf{
		skill_id = 30700,
		lv = 1,
		type = 1,
		auto_type = 1,
		career = 3000,
		limit_lv = 50,
		goods_1 = 110032,
		num_1 = 1,
		next_exp = 1000,
		trigger_type = 2
	};

get({30700,2}) ->
	#skill_tree_conf{
		skill_id = 30700,
		lv = 2,
		type = 1,
		auto_type = 1,
		career = 3000,
		limit_lv = 55,
		goods_1 = 0,
		num_1 = 0,
		next_exp = 5000,
		trigger_type = 2
	};

get({30700,3}) ->
	#skill_tree_conf{
		skill_id = 30700,
		lv = 3,
		type = 1,
		auto_type = 1,
		career = 3000,
		limit_lv = 60,
		goods_1 = 0,
		num_1 = 0,
		next_exp = 0,
		trigger_type = 2
	};

get({30700,4}) ->
	#skill_tree_conf{
		skill_id = 30700,
		lv = 4,
		type = 1,
		auto_type = 1,
		career = 3000,
		limit_lv = 85,
		goods_1 = 110222,
		num_1 = 160,
		next_exp = 0,
		trigger_type = 2
	};

get({51200,1}) ->
	#skill_tree_conf{
		skill_id = 51200,
		lv = 1,
		type = 1,
		auto_type = 0,
		career = 0,
		limit_lv = 0,
		goods_1 = 1,
		num_1 = 0,
		next_exp = 0,
		trigger_type = 0
	};

get({51200,2}) ->
	#skill_tree_conf{
		skill_id = 51200,
		lv = 2,
		type = 1,
		auto_type = 0,
		career = 0,
		limit_lv = 0,
		goods_1 = 0,
		num_1 = 0,
		next_exp = 0,
		trigger_type = 0
	};

get({51200,3}) ->
	#skill_tree_conf{
		skill_id = 51200,
		lv = 3,
		type = 1,
		auto_type = 0,
		career = 0,
		limit_lv = 0,
		goods_1 = 0,
		num_1 = 0,
		next_exp = 0,
		trigger_type = 0
	};

get(_Key) ->
	?ERR("undefined key from skill_tree_config ~p", [_Key]).