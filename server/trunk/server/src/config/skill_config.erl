%%%-------------------------------------------------------------------
%%% @author zhengsiying
%%% @doc
%%%		自动生成文件，不要手动修改
%%% @end
%%% Created : 2016/10/12
%%%-------------------------------------------------------------------

-module(skill_config).

-include("common.hrl").
-include("config.hrl").

-compile([export_all]).

get_list() ->
	[{10100, 1}, {10100, 2}, {10100, 3}, {10200, 1}, {10200, 2}, {10200, 3}, {10300, 1}, {10300, 2}, {10300, 3}, {10300, 4}, {10400, 1}, {10400, 2}, {10400, 3}, {10500, 1}, {10500, 2}, {10500, 3}, {10500, 4}, {10600, 1}, {10600, 2}, {10600, 3}, {10700, 1}, {10700, 2}, {10700, 3}, {10700, 4}, {10800, 1}, {10800, 2}, {10800, 3}, {10800, 4}, {20100, 1}, {20100, 2}, {20100, 3}, {20200, 1}, {20200, 2}, {20200, 3}, {20200, 4}, {20300, 1}, {20300, 2}, {20300, 3}, {20400, 1}, {20400, 2}, {20400, 3}, {20400, 4}, {20500, 1}, {20500, 2}, {20500, 3}, {20600, 1}, {20600, 2}, {20600, 3}, {20700, 1}, {20700, 2}, {20700, 3}, {20800, 1}, {20800, 2}, {20800, 3}, {20900, 1}, {20900, 2}, {20900, 3}, {20900, 4}, {21000, 1}, {21000, 2}, {21000, 3}, {21000, 4}, {30100, 1}, {30100, 2}, {30100, 3}, {30200, 1}, {30200, 2}, {30200, 3}, {30200, 4}, {30300, 1}, {30300, 2}, {30300, 3}, {30300, 4}, {30400, 1}, {30400, 2}, {30400, 3}, {30500, 1}, {30500, 2}, {30500, 3}, {30600, 1}, {30600, 2}, {30600, 3}, {30600, 4}, {30700, 1}, {30700, 2}, {30700, 3}, {30700, 4}, {30800, 1}, {30800, 2}, {30800, 3}, {40100, 1}, {40200, 1}, {40300, 1}, {40400, 1}, {40500, 1}, {40600, 1}, {40700, 1}, {40800, 1}, {40900, 1}, {99900, 1}, {99900, 2}, {99900, 3}, {99900, 4}, {50100, 1}, {50100, 2}, {50100, 3}, {50200, 1}, {50200, 2}, {50200, 3}, {50300, 1}, {50300, 2}, {50300, 3}, {50400, 1}, {50400, 2}, {50400, 3}, {50500, 1}, {50500, 2}, {50500, 3}, {50600, 1}, {50700, 1}, {50700, 2}, {50700, 3}, {50101, 1}, {50102, 1}, {50103, 1}, {50104, 1}, {50201, 1}, {50202, 1}, {50301, 1}, {50302, 1}, {50401, 1}, {51001, 1}, {51002, 1}, {51003, 1}, {51004, 1}, {51005, 1}, {51006, 1}, {51007, 1}, {51008, 1}, {51009, 1}, {50800, 1}, {50800, 2}, {50800, 3}, {50900, 1}, {50900, 2}, {50900, 3}, {51000, 1}, {51000, 2}, {51000, 3}, {51100, 1}, {51100, 2}, {51100, 3}, {51200, 1}, {51200, 2}, {51200, 3}, {51300, 1}, {51300, 2}, {51300, 3}, {50105, 1}].

get({10100, 1}) ->
	#skill_conf{
		skill_id = 10100,
		lv = 1,
		type = 1,
		cost_mp = 0,
		cd = 800,
		spell_distance = 1,
		hit = 1,
		target = 3,
		range = {single, 1},
		effect_list = [{dm, 10200, 0}],
		spell_time = 800
	};

get({10100, 2}) ->
	#skill_conf{
		skill_id = 10100,
		lv = 2,
		type = 1,
		cost_mp = 0,
		cd = 800,
		spell_distance = 1,
		hit = 1,
		target = 3,
		range = {single, 1},
		effect_list = [{dm, 10500, 0}],
		spell_time = 800
	};

get({10100, 3}) ->
	#skill_conf{
		skill_id = 10100,
		lv = 3,
		type = 1,
		cost_mp = 0,
		cd = 800,
		spell_distance = 1,
		hit = 1,
		target = 3,
		range = {single, 1},
		effect_list = [{dm, 10800, 0}],
		spell_time = 800
	};

get({10200, 1}) ->
	#skill_conf{
		skill_id = 10200,
		lv = 1,
		type = 2,
		cost_mp = 0,
		cd = 0,
		spell_distance = 0,
		hit = 1,
		target = 3,
		range = {},
		effect_list = [{rand_add_dm, 1000, 6000}],
		spell_time = 800
	};

get({10200, 2}) ->
	#skill_conf{
		skill_id = 10200,
		lv = 2,
		type = 2,
		cost_mp = 0,
		cd = 0,
		spell_distance = 0,
		hit = 1,
		target = 3,
		range = {},
		effect_list = [{rand_add_dm, 1500, 7000}],
		spell_time = 800
	};

get({10200, 3}) ->
	#skill_conf{
		skill_id = 10200,
		lv = 3,
		type = 2,
		cost_mp = 0,
		cd = 0,
		spell_distance = 0,
		hit = 1,
		target = 3,
		range = {},
		effect_list = [{rand_add_dm, 2000, 8000}],
		spell_time = 800
	};

get({10300, 1}) ->
	#skill_conf{
		skill_id = 10300,
		lv = 1,
		type = 1,
		cost_mp = 5,
		cd = 800,
		spell_distance = 1,
		hit = 1,
		target = 3,
		range = {line,2},
		effect_list = [{impale_dm, 12000, 0}],
		spell_time = 800
	};

get({10300, 2}) ->
	#skill_conf{
		skill_id = 10300,
		lv = 2,
		type = 1,
		cost_mp = 15,
		cd = 800,
		spell_distance = 1,
		hit = 1,
		target = 3,
		range = {line,2},
		effect_list = [{impale_dm, 13500, 0}],
		spell_time = 800
	};

get({10300, 3}) ->
	#skill_conf{
		skill_id = 10300,
		lv = 3,
		type = 1,
		cost_mp = 20,
		cd = 800,
		spell_distance = 1,
		hit = 1,
		target = 3,
		range = {line,2},
		effect_list = [{impale_dm, 15000, 0}],
		spell_time = 800
	};

get({10300, 4}) ->
	#skill_conf{
		skill_id = 10300,
		lv = 4,
		type = 1,
		cost_mp = 30,
		cd = 800,
		spell_distance = 1,
		hit = 1,
		target = 3,
		range = {line,2},
		effect_list = [{impale_dm, 16500, 0}],
		spell_time = 800
	};

get({10400, 1}) ->
	#skill_conf{
		skill_id = 10400,
		lv = 1,
		type = 1,
		cost_mp = 10,
		cd = 800,
		spell_distance = 1,
		hit = 1,
		target = 3,
		range = {circle, 1},
		effect_list = [{dm, 7000, 0}],
		spell_time = 800
	};

get({10400, 2}) ->
	#skill_conf{
		skill_id = 10400,
		lv = 2,
		type = 1,
		cost_mp = 30,
		cd = 800,
		spell_distance = 1,
		hit = 1,
		target = 3,
		range = {circle, 1},
		effect_list = [{dm, 8000, 0}],
		spell_time = 800
	};

get({10400, 3}) ->
	#skill_conf{
		skill_id = 10400,
		lv = 3,
		type = 1,
		cost_mp = 50,
		cd = 800,
		spell_distance = 1,
		hit = 1,
		target = 3,
		range = {circle, 1},
		effect_list = [{dm, 9000, 0}],
		spell_time = 800
	};

get({10500, 1}) ->
	#skill_conf{
		skill_id = 10500,
		lv = 1,
		type = 1,
		cost_mp = 50,
		cd = 5000,
		spell_distance = 1,
		hit = 1,
		target = 1,
		range = {single, 0},
		effect_list = [{buff, 1201, 10000}],
		spell_time = 0
	};

get({10500, 2}) ->
	#skill_conf{
		skill_id = 10500,
		lv = 2,
		type = 1,
		cost_mp = 100,
		cd = 5000,
		spell_distance = 1,
		hit = 1,
		target = 1,
		range = {single, 0},
		effect_list = [{buff, 1202, 10000}],
		spell_time = 0
	};

get({10500, 3}) ->
	#skill_conf{
		skill_id = 10500,
		lv = 3,
		type = 1,
		cost_mp = 150,
		cd = 5000,
		spell_distance = 1,
		hit = 1,
		target = 1,
		range = {single, 0},
		effect_list = [{buff, 1203, 10000}],
		spell_time = 0
	};

get({10500, 4}) ->
	#skill_conf{
		skill_id = 10500,
		lv = 4,
		type = 1,
		cost_mp = 180,
		cd = 5000,
		spell_distance = 1,
		hit = 1,
		target = 1,
		range = {single, 0},
		effect_list = [{buff, 1204, 10000}],
		spell_time = 0
	};

get({10600, 1}) ->
	#skill_conf{
		skill_id = 10600,
		lv = 1,
		type = 1,
		cost_mp = 50,
		cd = 10000,
		spell_distance = 5,
		hit = 0,
		target = 3,
		range = {single, 1},
		effect_list = [{move_knockback, 0, 1},{buff, 1301, 10000,1,5000}],
		spell_time = 800
	};

get({10600, 2}) ->
	#skill_conf{
		skill_id = 10600,
		lv = 2,
		type = 1,
		cost_mp = 100,
		cd = 9000,
		spell_distance = 5,
		hit = 0,
		target = 3,
		range = {single, 1},
		effect_list = [{move_knockback, 0, 1},{buff, 1302, 10000,1,5000}],
		spell_time = 800
	};

get({10600, 3}) ->
	#skill_conf{
		skill_id = 10600,
		lv = 3,
		type = 1,
		cost_mp = 150,
		cd = 8000,
		spell_distance = 6,
		hit = 0,
		target = 3,
		range = {single, 1},
		effect_list = [{move_knockback, 0, 1},{buff, 1303, 10000,1,5000}],
		spell_time = 800
	};

get({10700, 1}) ->
	#skill_conf{
		skill_id = 10700,
		lv = 1,
		type = 1,
		cost_mp = 60,
		cd = 800,
		spell_distance = 1,
		hit = 1,
		target = 3,
		range = {circle, 1},
		effect_list = [{dm, 9000, 0}],
		spell_time = 800
	};

get({10700, 2}) ->
	#skill_conf{
		skill_id = 10700,
		lv = 2,
		type = 1,
		cost_mp = 80,
		cd = 800,
		spell_distance = 1,
		hit = 1,
		target = 3,
		range = {circle, 1},
		effect_list = [{dm, 10000, 0}],
		spell_time = 800
	};

get({10700, 3}) ->
	#skill_conf{
		skill_id = 10700,
		lv = 3,
		type = 1,
		cost_mp = 100,
		cd = 800,
		spell_distance = 1,
		hit = 1,
		target = 3,
		range = {circle, 1},
		effect_list = [{dm, 11000, 0}],
		spell_time = 800
	};

get({10700, 4}) ->
	#skill_conf{
		skill_id = 10700,
		lv = 4,
		type = 1,
		cost_mp = 120,
		cd = 800,
		spell_distance = 1,
		hit = 1,
		target = 3,
		range = {circle, 1},
		effect_list = [{dm, 12000, 0}],
		spell_time = 800
	};

get({10800, 1}) ->
	#skill_conf{
		skill_id = 10800,
		lv = 1,
		type = 1,
		cost_mp = 80,
		cd = 8000,
		spell_distance = 4,
		hit = 1,
		target = 3,
		range = {line, 4},
		effect_list = [{dm, 18000, 0}],
		spell_time = 800
	};

get({10800, 2}) ->
	#skill_conf{
		skill_id = 10800,
		lv = 2,
		type = 1,
		cost_mp = 100,
		cd = 8000,
		spell_distance = 4,
		hit = 1,
		target = 3,
		range = {line, 4},
		effect_list = [{dm, 19000, 0}],
		spell_time = 800
	};

get({10800, 3}) ->
	#skill_conf{
		skill_id = 10800,
		lv = 3,
		type = 1,
		cost_mp = 120,
		cd = 8000,
		spell_distance = 4,
		hit = 1,
		target = 3,
		range = {line, 4},
		effect_list = [{dm, 20000, 0}],
		spell_time = 800
	};

get({10800, 4}) ->
	#skill_conf{
		skill_id = 10800,
		lv = 4,
		type = 1,
		cost_mp = 140,
		cd = 8000,
		spell_distance = 4,
		hit = 1,
		target = 3,
		range = {line, 4},
		effect_list = [{dm, 21000, 0}],
		spell_time = 800
	};

get({20100, 1}) ->
	#skill_conf{
		skill_id = 20100,
		lv = 1,
		type = 1,
		cost_mp = 0,
		cd = 800,
		spell_distance = 5,
		hit = 1,
		target = 3,
		range = {single, 1},
		effect_list = [{dm, 11000, 0}],
		spell_time = 800
	};

get({20100, 2}) ->
	#skill_conf{
		skill_id = 20100,
		lv = 2,
		type = 1,
		cost_mp = 0,
		cd = 800,
		spell_distance = 5,
		hit = 1,
		target = 3,
		range = {single, 1},
		effect_list = [{dm, 11500, 0}],
		spell_time = 800
	};

get({20100, 3}) ->
	#skill_conf{
		skill_id = 20100,
		lv = 3,
		type = 1,
		cost_mp = 0,
		cd = 800,
		spell_distance = 5,
		hit = 1,
		target = 3,
		range = {single, 1},
		effect_list = [{dm, 12000, 0}],
		spell_time = 800
	};

get({20200, 1}) ->
	#skill_conf{
		skill_id = 20200,
		lv = 1,
		type = 1,
		cost_mp = 10,
		cd = 800,
		spell_distance = 5,
		hit = 1,
		target = 3,
		range = {single, 1},
		effect_list = [{dm, 12000, 0}],
		spell_time = 800
	};

get({20200, 2}) ->
	#skill_conf{
		skill_id = 20200,
		lv = 2,
		type = 1,
		cost_mp = 30,
		cd = 800,
		spell_distance = 5,
		hit = 1,
		target = 3,
		range = {single, 1},
		effect_list = [{dm, 13000, 0}],
		spell_time = 800
	};

get({20200, 3}) ->
	#skill_conf{
		skill_id = 20200,
		lv = 3,
		type = 1,
		cost_mp = 40,
		cd = 800,
		spell_distance = 5,
		hit = 1,
		target = 3,
		range = {single, 1},
		effect_list = [{dm, 14000, 0}],
		spell_time = 800
	};

get({20200, 4}) ->
	#skill_conf{
		skill_id = 20200,
		lv = 4,
		type = 1,
		cost_mp = 50,
		cd = 800,
		spell_distance = 5,
		hit = 1,
		target = 3,
		range = {single, 1},
		effect_list = [{dm, 15000, 0}],
		spell_time = 800
	};

get({20300, 1}) ->
	#skill_conf{
		skill_id = 20300,
		lv = 1,
		type = 1,
		cost_mp = 40,
		cd = 800,
		spell_distance = 5,
		hit = 1,
		target = 3,
		range = {single, 0},
		effect_list = [{fire_wall, 4000, 30, 1.5}],
		spell_time = 800
	};

get({20300, 2}) ->
	#skill_conf{
		skill_id = 20300,
		lv = 2,
		type = 1,
		cost_mp = 50,
		cd = 800,
		spell_distance = 5,
		hit = 1,
		target = 3,
		range = {single, 0},
		effect_list = [{fire_wall, 4800, 35, 1.5}],
		spell_time = 800
	};

get({20300, 3}) ->
	#skill_conf{
		skill_id = 20300,
		lv = 3,
		type = 1,
		cost_mp = 60,
		cd = 800,
		spell_distance = 5,
		hit = 1,
		target = 3,
		range = {single, 0},
		effect_list = [{fire_wall, 5500, 40, 1.5}],
		spell_time = 800
	};

get({20400, 1}) ->
	#skill_conf{
		skill_id = 20400,
		lv = 1,
		type = 1,
		cost_mp = 50,
		cd = 10000,
		spell_distance = 1,
		hit = 1,
		target = 1,
		range = {single, 0},
		effect_list = [{buff, 1001, 10000}],
		spell_time = 800
	};

get({20400, 2}) ->
	#skill_conf{
		skill_id = 20400,
		lv = 2,
		type = 1,
		cost_mp = 60,
		cd = 10000,
		spell_distance = 1,
		hit = 1,
		target = 1,
		range = {single, 0},
		effect_list = [{buff, 1002, 10000}],
		spell_time = 800
	};

get({20400, 3}) ->
	#skill_conf{
		skill_id = 20400,
		lv = 3,
		type = 1,
		cost_mp = 70,
		cd = 10000,
		spell_distance = 1,
		hit = 1,
		target = 1,
		range = {single, 0},
		effect_list = [{buff, 1003, 10000}],
		spell_time = 800
	};

get({20400, 4}) ->
	#skill_conf{
		skill_id = 20400,
		lv = 4,
		type = 1,
		cost_mp = 80,
		cd = 10000,
		spell_distance = 1,
		hit = 1,
		target = 1,
		range = {single, 0},
		effect_list = [{buff, 1004, 10000}],
		spell_time = 800
	};

get({20500, 1}) ->
	#skill_conf{
		skill_id = 20500,
		lv = 1,
		type = 1,
		cost_mp = 50,
		cd = 800,
		spell_distance = 1,
		hit = 1,
		target = 3,
		range = {circle, 1},
		effect_list = [{dm, 11000, 0}],
		spell_time = 800
	};

get({20500, 2}) ->
	#skill_conf{
		skill_id = 20500,
		lv = 2,
		type = 1,
		cost_mp = 60,
		cd = 800,
		spell_distance = 1,
		hit = 1,
		target = 3,
		range = {circle, 1},
		effect_list = [{dm, 12000, 0}],
		spell_time = 800
	};

get({20500, 3}) ->
	#skill_conf{
		skill_id = 20500,
		lv = 3,
		type = 1,
		cost_mp = 80,
		cd = 800,
		spell_distance = 1,
		hit = 1,
		target = 3,
		range = {circle, 1},
		effect_list = [{dm, 13000, 0}],
		spell_time = 800
	};

get({20600, 1}) ->
	#skill_conf{
		skill_id = 20600,
		lv = 1,
		type = 1,
		cost_mp = 20,
		cd = 800,
		spell_distance = 5,
		hit = 1,
		target = 3,
		range = {rang, 1},
		effect_list = [{dm, 10500, 0}],
		spell_time = 800
	};

get({20600, 2}) ->
	#skill_conf{
		skill_id = 20600,
		lv = 2,
		type = 1,
		cost_mp = 50,
		cd = 800,
		spell_distance = 5,
		hit = 1,
		target = 3,
		range = {rang, 1},
		effect_list = [{dm, 11000, 0}],
		spell_time = 800
	};

get({20600, 3}) ->
	#skill_conf{
		skill_id = 20600,
		lv = 3,
		type = 1,
		cost_mp = 60,
		cd = 800,
		spell_distance = 5,
		hit = 1,
		target = 3,
		range = {rang, 1},
		effect_list = [{dm, 11500, 0}],
		spell_time = 800
	};

get({20700, 1}) ->
	#skill_conf{
		skill_id = 20700,
		lv = 1,
		type = 1,
		cost_mp = 50,
		cd = 800,
		spell_distance = 5,
		hit = 1,
		target = 3,
		range = {line, 5},
		effect_list = [{dm, 12000, 0}],
		spell_time = 800
	};

get({20700, 2}) ->
	#skill_conf{
		skill_id = 20700,
		lv = 2,
		type = 1,
		cost_mp = 60,
		cd = 800,
		spell_distance = 5,
		hit = 1,
		target = 3,
		range = {line, 5},
		effect_list = [{dm, 12500, 0}],
		spell_time = 800
	};

get({20700, 3}) ->
	#skill_conf{
		skill_id = 20700,
		lv = 3,
		type = 1,
		cost_mp = 70,
		cd = 800,
		spell_distance = 5,
		hit = 1,
		target = 3,
		range = {line, 5},
		effect_list = [{dm, 13000, 0}],
		spell_time = 800
	};

get({20800, 1}) ->
	#skill_conf{
		skill_id = 20800,
		lv = 1,
		type = 1,
		cost_mp = 100,
		cd = 800,
		spell_distance = 2,
		hit = 1,
		target = 3,
		range = {circle, 2},
		effect_list = [{knockback, 2, 1, 5000}],
		spell_time = 800
	};

get({20800, 2}) ->
	#skill_conf{
		skill_id = 20800,
		lv = 2,
		type = 1,
		cost_mp = 150,
		cd = 800,
		spell_distance = 2,
		hit = 1,
		target = 3,
		range = {circle, 2},
		effect_list = [{knockback, 2, 1, 5000}],
		spell_time = 800
	};

get({20800, 3}) ->
	#skill_conf{
		skill_id = 20800,
		lv = 3,
		type = 1,
		cost_mp = 200,
		cd = 800,
		spell_distance = 2,
		hit = 1,
		target = 3,
		range = {circle, 2},
		effect_list = [{knockback, 2, 1, 5000}],
		spell_time = 800
	};

get({20900, 1}) ->
	#skill_conf{
		skill_id = 20900,
		lv = 1,
		type = 1,
		cost_mp = 80,
		cd = 800,
		spell_distance = 5,
		hit = 1,
		target = 3,
		range = {rang, 1},
		effect_list = [{dm, 13000, 0}],
		spell_time = 800
	};

get({20900, 2}) ->
	#skill_conf{
		skill_id = 20900,
		lv = 2,
		type = 1,
		cost_mp = 100,
		cd = 800,
		spell_distance = 5,
		hit = 1,
		target = 3,
		range = {rang, 1},
		effect_list = [{dm, 14000, 0}],
		spell_time = 800
	};

get({20900, 3}) ->
	#skill_conf{
		skill_id = 20900,
		lv = 3,
		type = 1,
		cost_mp = 120,
		cd = 800,
		spell_distance = 5,
		hit = 1,
		target = 3,
		range = {rang, 1},
		effect_list = [{dm, 15000, 0}],
		spell_time = 800
	};

get({20900, 4}) ->
	#skill_conf{
		skill_id = 20900,
		lv = 4,
		type = 1,
		cost_mp = 140,
		cd = 800,
		spell_distance = 5,
		hit = 1,
		target = 3,
		range = {rang, 1},
		effect_list = [{dm, 16000, 0}],
		spell_time = 800
	};

get({21000, 1}) ->
	#skill_conf{
		skill_id = 21000,
		lv = 1,
		type = 1,
		cost_mp = 50,
		cd = 800,
		spell_distance = 5,
		hit = 1,
		target = 3,
		range = {single, 1},
		effect_list = [{tempt, 1000, 3, 3}],
		spell_time = 800
	};

get({21000, 2}) ->
	#skill_conf{
		skill_id = 21000,
		lv = 2,
		type = 1,
		cost_mp = 100,
		cd = 800,
		spell_distance = 5,
		hit = 1,
		target = 3,
		range = {single, 1},
		effect_list = [{tempt, 1500, 3, 5}],
		spell_time = 800
	};

get({21000, 3}) ->
	#skill_conf{
		skill_id = 21000,
		lv = 3,
		type = 1,
		cost_mp = 150,
		cd = 800,
		spell_distance = 5,
		hit = 1,
		target = 3,
		range = {single, 1},
		effect_list = [{tempt, 2000, 3, 7}],
		spell_time = 800
	};

get({21000, 4}) ->
	#skill_conf{
		skill_id = 21000,
		lv = 4,
		type = 1,
		cost_mp = 200,
		cd = 800,
		spell_distance = 5,
		hit = 1,
		target = 3,
		range = {single, 1},
		effect_list = [{tempt, 2500, 3, 7}],
		spell_time = 800
	};

get({30100, 1}) ->
	#skill_conf{
		skill_id = 30100,
		lv = 1,
		type = 1,
		cost_mp = 0,
		cd = 800,
		spell_distance = 5,
		hit = 1,
		target = 3,
		range = {single, 1},
		effect_list = [{dm, 10000, 0}],
		spell_time = 800
	};

get({30100, 2}) ->
	#skill_conf{
		skill_id = 30100,
		lv = 2,
		type = 1,
		cost_mp = 0,
		cd = 800,
		spell_distance = 5,
		hit = 1,
		target = 3,
		range = {single, 1},
		effect_list = [{dm, 10500, 0}],
		spell_time = 800
	};

get({30100, 3}) ->
	#skill_conf{
		skill_id = 30100,
		lv = 3,
		type = 1,
		cost_mp = 0,
		cd = 800,
		spell_distance = 5,
		hit = 1,
		target = 3,
		range = {single, 1},
		effect_list = [{dm, 11000, 0}],
		spell_time = 800
	};

get({30200, 1}) ->
	#skill_conf{
		skill_id = 30200,
		lv = 1,
		type = 1,
		cost_mp = 50,
		cd = 800,
		spell_distance = 1,
		hit = 1,
		target = 2,
		range = {circle, 2},
		effect_list = [{buff, 1801, 10000}],
		spell_time = 800
	};

get({30200, 2}) ->
	#skill_conf{
		skill_id = 30200,
		lv = 2,
		type = 1,
		cost_mp = 100,
		cd = 800,
		spell_distance = 1,
		hit = 1,
		target = 2,
		range = {circle, 2},
		effect_list = [{buff, 1802, 10000}],
		spell_time = 800
	};

get({30200, 3}) ->
	#skill_conf{
		skill_id = 30200,
		lv = 3,
		type = 1,
		cost_mp = 150,
		cd = 800,
		spell_distance = 1,
		hit = 1,
		target = 2,
		range = {circle, 2},
		effect_list = [{buff, 1803, 10000}],
		spell_time = 800
	};

get({30200, 4}) ->
	#skill_conf{
		skill_id = 30200,
		lv = 4,
		type = 1,
		cost_mp = 200,
		cd = 800,
		spell_distance = 1,
		hit = 1,
		target = 2,
		range = {circle, 2},
		effect_list = [{buff, 1804, 10000}],
		spell_time = 800
	};

get({30300, 1}) ->
	#skill_conf{
		skill_id = 30300,
		lv = 1,
		type = 1,
		cost_mp = 35,
		cd = 800,
		spell_distance = 5,
		hit = 1,
		target = 3,
		range = {rang, 1},
		effect_list = [{buff, 1401, 10000},{buff, 1501, 10000}],
		spell_time = 800
	};

get({30300, 2}) ->
	#skill_conf{
		skill_id = 30300,
		lv = 2,
		type = 1,
		cost_mp = 70,
		cd = 800,
		spell_distance = 5,
		hit = 1,
		target = 3,
		range = {rang, 1},
		effect_list = [{buff, 1402, 10000},{buff, 1502, 10000}],
		spell_time = 800
	};

get({30300, 3}) ->
	#skill_conf{
		skill_id = 30300,
		lv = 3,
		type = 1,
		cost_mp = 105,
		cd = 800,
		spell_distance = 5,
		hit = 1,
		target = 3,
		range = {rang, 1},
		effect_list = [{buff, 1403, 10000},{buff, 1503, 10000}],
		spell_time = 800
	};

get({30300, 4}) ->
	#skill_conf{
		skill_id = 30300,
		lv = 4,
		type = 1,
		cost_mp = 140,
		cd = 800,
		spell_distance = 5,
		hit = 1,
		target = 3,
		range = {rang, 1},
		effect_list = [{buff, 1404, 10000},{buff, 1504, 10000}],
		spell_time = 800
	};

get({30400, 1}) ->
	#skill_conf{
		skill_id = 30400,
		lv = 1,
		type = 1,
		cost_mp = 150,
		cd = 800,
		spell_distance = 1,
		hit = 1,
		target = 2,
		range = {circle, 1},
		effect_list = [{buff, 1601, 10000}],
		spell_time = 800
	};

get({30400, 2}) ->
	#skill_conf{
		skill_id = 30400,
		lv = 2,
		type = 1,
		cost_mp = 170,
		cd = 800,
		spell_distance = 1,
		hit = 1,
		target = 2,
		range = {circle, 1},
		effect_list = [{buff, 1602, 10000}],
		spell_time = 800
	};

get({30400, 3}) ->
	#skill_conf{
		skill_id = 30400,
		lv = 3,
		type = 1,
		cost_mp = 200,
		cd = 800,
		spell_distance = 1,
		hit = 1,
		target = 2,
		range = {circle, 1},
		effect_list = [{buff, 1603, 10000}],
		spell_time = 800
	};

get({30500, 1}) ->
	#skill_conf{
		skill_id = 30500,
		lv = 1,
		type = 1,
		cost_mp = 150,
		cd = 800,
		spell_distance = 5,
		hit = 1,
		target = 2,
		range = {rang, 2},
		effect_list = [{buff, 1101, 10000}],
		spell_time = 800
	};

get({30500, 2}) ->
	#skill_conf{
		skill_id = 30500,
		lv = 2,
		type = 1,
		cost_mp = 170,
		cd = 800,
		spell_distance = 5,
		hit = 1,
		target = 2,
		range = {rang, 2},
		effect_list = [{buff, 1102, 10000}],
		spell_time = 800
	};

get({30500, 3}) ->
	#skill_conf{
		skill_id = 30500,
		lv = 3,
		type = 1,
		cost_mp = 200,
		cd = 800,
		spell_distance = 5,
		hit = 1,
		target = 2,
		range = {rang, 2},
		effect_list = [{buff, 1103, 10000}],
		spell_time = 800
	};

get({30600, 1}) ->
	#skill_conf{
		skill_id = 30600,
		lv = 1,
		type = 1,
		cost_mp = 100,
		cd = 800,
		spell_distance = 1,
		hit = 1,
		target = 1,
		range = {single, 0},
		effect_list = [{call_pet, 20001, 3}],
		spell_time = 800
	};

get({30600, 2}) ->
	#skill_conf{
		skill_id = 30600,
		lv = 2,
		type = 1,
		cost_mp = 120,
		cd = 800,
		spell_distance = 1,
		hit = 1,
		target = 1,
		range = {single, 0},
		effect_list = [{call_pet, 20002, 5}],
		spell_time = 800
	};

get({30600, 3}) ->
	#skill_conf{
		skill_id = 30600,
		lv = 3,
		type = 1,
		cost_mp = 150,
		cd = 800,
		spell_distance = 1,
		hit = 1,
		target = 1,
		range = {single, 0},
		effect_list = [{call_pet, 20003, 7}],
		spell_time = 800
	};

get({30600, 4}) ->
	#skill_conf{
		skill_id = 30600,
		lv = 4,
		type = 1,
		cost_mp = 180,
		cd = 800,
		spell_distance = 1,
		hit = 1,
		target = 1,
		range = {single, 0},
		effect_list = [{call_pet, 20007, 9}],
		spell_time = 800
	};

get({30700, 1}) ->
	#skill_conf{
		skill_id = 30700,
		lv = 1,
		type = 1,
		cost_mp = 60,
		cd = 800,
		spell_distance = 5,
		hit = 1,
		target = 3,
		range = {single, 1},
		effect_list = [{dm_and_cure, 11000, 800}],
		spell_time = 800
	};

get({30700, 2}) ->
	#skill_conf{
		skill_id = 30700,
		lv = 2,
		type = 1,
		cost_mp = 80,
		cd = 800,
		spell_distance = 5,
		hit = 1,
		target = 3,
		range = {single, 1},
		effect_list = [{dm_and_cure, 12000, 1000}],
		spell_time = 800
	};

get({30700, 3}) ->
	#skill_conf{
		skill_id = 30700,
		lv = 3,
		type = 1,
		cost_mp = 90,
		cd = 800,
		spell_distance = 5,
		hit = 1,
		target = 3,
		range = {single, 1},
		effect_list = [{dm_and_cure, 13000, 1200}],
		spell_time = 800
	};

get({30700, 4}) ->
	#skill_conf{
		skill_id = 30700,
		lv = 4,
		type = 1,
		cost_mp = 100,
		cd = 800,
		spell_distance = 5,
		hit = 1,
		target = 3,
		range = {single, 1},
		effect_list = [{dm_and_cure, 14000, 1400}],
		spell_time = 800
	};

get({30800, 1}) ->
	#skill_conf{
		skill_id = 30800,
		lv = 1,
		type = 1,
		cost_mp = 50,
		cd = 800,
		spell_distance = 1,
		hit = 1,
		target = 1,
		range = {single, 0},
		effect_list = [{call_pet, 20011, 3}],
		spell_time = 800
	};

get({30800, 2}) ->
	#skill_conf{
		skill_id = 30800,
		lv = 2,
		type = 1,
		cost_mp = 70,
		cd = 800,
		spell_distance = 1,
		hit = 1,
		target = 1,
		range = {single, 0},
		effect_list = [{call_pet, 20012, 5}],
		spell_time = 800
	};

get({30800, 3}) ->
	#skill_conf{
		skill_id = 30800,
		lv = 3,
		type = 1,
		cost_mp = 100,
		cd = 800,
		spell_distance = 1,
		hit = 1,
		target = 1,
		range = {single, 0},
		effect_list = [{call_pet, 20013, 7}],
		spell_time = 800
	};

get({40100, 1}) ->
	#skill_conf{
		skill_id = 40100,
		lv = 1,
		type = 1,
		cost_mp = 0,
		cd = 1500,
		spell_distance = 1,
		hit = 1,
		target = 3,
		range = {single, 1},
		effect_list = [{dm, 10000, 0}],
		spell_time = 800
	};

get({40200, 1}) ->
	#skill_conf{
		skill_id = 40200,
		lv = 1,
		type = 1,
		cost_mp = 0,
		cd = 1500,
		spell_distance = 5,
		hit = 1,
		target = 3,
		range = {single, 1},
		effect_list = [{dm, 10000, 0}],
		spell_time = 800
	};

get({40300, 1}) ->
	#skill_conf{
		skill_id = 40300,
		lv = 1,
		type = 1,
		cost_mp = 0,
		cd = 800,
		spell_distance = 5,
		hit = 1,
		target = 3,
		range = {single, 1},
		effect_list = [{dm, 10000, 0}],
		spell_time = 800
	};

get({40400, 1}) ->
	#skill_conf{
		skill_id = 40400,
		lv = 1,
		type = 1,
		cost_mp = 0,
		cd = 800,
		spell_distance = 2,
		hit = 1,
		target = 3,
		range = {line,2},
		effect_list = [{dm, 10000, 0}],
		spell_time = 800
	};

get({40500, 1}) ->
	#skill_conf{
		skill_id = 40500,
		lv = 1,
		type = 1,
		cost_mp = 0,
		cd = 1500,
		spell_distance = 5,
		hit = 1,
		target = 3,
		range = {circle, 12},
		effect_list = [{dm, 10000, 0}],
		spell_time = 800
	};

get({40600, 1}) ->
	#skill_conf{
		skill_id = 40600,
		lv = 1,
		type = 1,
		cost_mp = 0,
		cd = 1500,
		spell_distance = 5,
		hit = 1,
		target = 3,
		range = {single, 1},
		effect_list = [{dm, 10000, 0}],
		spell_time = 800
	};

get({40700, 1}) ->
	#skill_conf{
		skill_id = 40700,
		lv = 1,
		type = 1,
		cost_mp = 0,
		cd = 1500,
		spell_distance = 5,
		hit = 1,
		target = 3,
		range = {rang, 3},
		effect_list = [{dm, 10000, 0}],
		spell_time = 800
	};

get({40800, 1}) ->
	#skill_conf{
		skill_id = 40800,
		lv = 1,
		type = 1,
		cost_mp = 0,
		cd = 1500,
		spell_distance = 1,
		hit = 0,
		target = 3,
		range = {circle, 2},
		effect_list = [{dm, 10000, 0}],
		spell_time = 1500
	};

get({40900, 1}) ->
	#skill_conf{
		skill_id = 40900,
		lv = 1,
		type = 1,
		cost_mp = 0,
		cd = 1500,
		spell_distance = 5,
		hit = 0,
		target = 3,
		range = {rang, 1},
		effect_list = [{dm, 10000, 0}],
		spell_time = 1500
	};

get({99900, 1}) ->
	#skill_conf{
		skill_id = 99900,
		lv = 1,
		type = 1,
		cost_mp = 50,
		cd = 5000,
		spell_distance = 1,
		hit = 1,
		target = 3,
		range = {single, 1},
		effect_list = [{dm, 15000, 0}],
		spell_time = 800
	};

get({99900, 2}) ->
	#skill_conf{
		skill_id = 99900,
		lv = 2,
		type = 1,
		cost_mp = 100,
		cd = 5000,
		spell_distance = 1,
		hit = 1,
		target = 3,
		range = {single, 1},
		effect_list = [{dm, 17000, 0}],
		spell_time = 800
	};

get({99900, 3}) ->
	#skill_conf{
		skill_id = 99900,
		lv = 3,
		type = 1,
		cost_mp = 150,
		cd = 5000,
		spell_distance = 1,
		hit = 1,
		target = 3,
		range = {single, 1},
		effect_list = [{dm, 19000, 0}],
		spell_time = 800
	};

get({99900, 4}) ->
	#skill_conf{
		skill_id = 99900,
		lv = 4,
		type = 1,
		cost_mp = 180,
		cd = 5000,
		spell_distance = 1,
		hit = 1,
		target = 3,
		range = {single, 1},
		effect_list = [{dm, 21000, 0}],
		spell_time = 800
	};

get({50100, 1}) ->
	#skill_conf{
		skill_id = 50100,
		lv = 1,
		type = 2,
		cost_mp = 0,
		cd = 0,
		spell_distance = 0,
		hit = 1,
		target = 3,
		range = {single, 0},
		effect_list = [{buff, 1000, 1701, 2000},{buff, 2000, 1701, 1000},{buff, 3000, 1701, 1000}],
		spell_time = 0
	};

get({50100, 2}) ->
	#skill_conf{
		skill_id = 50100,
		lv = 2,
		type = 2,
		cost_mp = 0,
		cd = 0,
		spell_distance = 0,
		hit = 1,
		target = 3,
		range = {single, 0},
		effect_list = [{buff, 1000, 1707, 2000},{buff, 2000, 1707, 1000},{buff, 3000, 1707, 1000}],
		spell_time = 0
	};

get({50100, 3}) ->
	#skill_conf{
		skill_id = 50100,
		lv = 3,
		type = 2,
		cost_mp = 0,
		cd = 0,
		spell_distance = 0,
		hit = 1,
		target = 3,
		range = {single, 0},
		effect_list = [{buff, 1000, 1707, 3000},{buff, 2000, 1707, 1500},{buff, 3000, 1707, 1500}],
		spell_time = 0
	};

get({50200, 1}) ->
	#skill_conf{
		skill_id = 50200,
		lv = 1,
		type = 2,
		cost_mp = 0,
		cd = 0,
		spell_distance = 0,
		hit = 1,
		target = 1,
		range = {single, 0},
		effect_list = [{hs,[{1000, 0.05, 0.5, 0.83},{2000, 0.1, 0.5, 0.83}, {3000, 0.1, 0.5, 0.83}]}],
		spell_time = 0
	};

get({50200, 2}) ->
	#skill_conf{
		skill_id = 50200,
		lv = 2,
		type = 2,
		cost_mp = 0,
		cd = 0,
		spell_distance = 0,
		hit = 1,
		target = 1,
		range = {single, 0},
		effect_list = [{hs,[{1000, 0.1, 0.5, 0.66},{2000, 0.2, 0.5, 0.66}, {3000, 0.2, 0.5, 0.66}]}],
		spell_time = 0
	};

get({50200, 3}) ->
	#skill_conf{
		skill_id = 50200,
		lv = 3,
		type = 2,
		cost_mp = 0,
		cd = 0,
		spell_distance = 0,
		hit = 1,
		target = 1,
		range = {single, 0},
		effect_list = [{hs,[{1000, 0.2, 0.5, 0.5},{2000, 0.4, 0.5, 0.5}, {3000, 0.4, 0.5, 0.5}]}],
		spell_time = 0
	};

get({50300, 1}) ->
	#skill_conf{
		skill_id = 50300,
		lv = 1,
		type = 2,
		cost_mp = 0,
		cd = 0,
		spell_distance = 0,
		hit = 1,
		target = 1,
		range = {single, 0},
		effect_list = [{cd,180}],
		spell_time = 0
	};

get({50300, 2}) ->
	#skill_conf{
		skill_id = 50300,
		lv = 2,
		type = 2,
		cost_mp = 0,
		cd = 0,
		spell_distance = 0,
		hit = 1,
		target = 1,
		range = {single, 0},
		effect_list = [{cd,150}],
		spell_time = 0
	};

get({50300, 3}) ->
	#skill_conf{
		skill_id = 50300,
		lv = 3,
		type = 2,
		cost_mp = 0,
		cd = 0,
		spell_distance = 0,
		hit = 1,
		target = 1,
		range = {single, 0},
		effect_list = [{cd,120}],
		spell_time = 0
	};

get({50400, 1}) ->
	#skill_conf{
		skill_id = 50400,
		lv = 1,
		type = 2,
		cost_mp = 0,
		cd = 0,
		spell_distance = 0,
		hit = 1,
		target = 3,
		range = {single, 0},
		effect_list = [{buff, 1000, 1706, 800},{buff, 2000, 1706, 800},{buff, 3000, 1706, 800}],
		spell_time = 0
	};

get({50400, 2}) ->
	#skill_conf{
		skill_id = 50400,
		lv = 2,
		type = 2,
		cost_mp = 0,
		cd = 0,
		spell_distance = 0,
		hit = 1,
		target = 3,
		range = {single, 0},
		effect_list = [{buff, 1000, 1708, 1200},{buff, 2000, 1708, 1200},{buff, 3000, 1708, 1200}],
		spell_time = 0
	};

get({50400, 3}) ->
	#skill_conf{
		skill_id = 50400,
		lv = 3,
		type = 2,
		cost_mp = 0,
		cd = 0,
		spell_distance = 0,
		hit = 1,
		target = 3,
		range = {single, 0},
		effect_list = [{buff, 1000, 1709, 1500},{buff, 2000, 1709, 1500},{buff, 3000, 1709, 1500}],
		spell_time = 0
	};

get({50500, 1}) ->
	#skill_conf{
		skill_id = 50500,
		lv = 1,
		type = 2,
		cost_mp = 0,
		cd = 0,
		spell_distance = 0,
		hit = 1,
		target = 3,
		range = {single, 0},
		effect_list = [{hp_suck, 3000, 2000, 0}],
		spell_time = 0
	};

get({50500, 2}) ->
	#skill_conf{
		skill_id = 50500,
		lv = 2,
		type = 2,
		cost_mp = 0,
		cd = 0,
		spell_distance = 0,
		hit = 1,
		target = 3,
		range = {single, 0},
		effect_list = [{hp_suck, 4000, 2000, 0}],
		spell_time = 0
	};

get({50500, 3}) ->
	#skill_conf{
		skill_id = 50500,
		lv = 3,
		type = 2,
		cost_mp = 0,
		cd = 0,
		spell_distance = 0,
		hit = 1,
		target = 3,
		range = {single, 0},
		effect_list = [{hp_suck, 4000, 3000, 0}],
		spell_time = 0
	};

get({50600, 1}) ->
	#skill_conf{
		skill_id = 50600,
		lv = 1,
		type = 2,
		cost_mp = 0,
		cd = 0,
		spell_distance = 0,
		hit = 1,
		target = 3,
		range = {single, 0},
		effect_list = [{mp_suck, 10000, 1000, 0}],
		spell_time = 0
	};

get({50700, 1}) ->
	#skill_conf{
		skill_id = 50700,
		lv = 1,
		type = 2,
		cost_mp = 0,
		cd = 0,
		spell_distance = 0,
		hit = 1,
		target = 3,
		range = {single, 0},
		effect_list = [{thorns, 10000, 2000, 0}],
		spell_time = 0
	};

get({50700, 2}) ->
	#skill_conf{
		skill_id = 50700,
		lv = 2,
		type = 2,
		cost_mp = 0,
		cd = 0,
		spell_distance = 0,
		hit = 1,
		target = 3,
		range = {single, 0},
		effect_list = [{thorns, 10000, 3000, 0}],
		spell_time = 0
	};

get({50700, 3}) ->
	#skill_conf{
		skill_id = 50700,
		lv = 3,
		type = 2,
		cost_mp = 0,
		cd = 0,
		spell_distance = 0,
		hit = 1,
		target = 3,
		range = {single, 0},
		effect_list = [{thorns, 10000, 4000, 0}],
		spell_time = 0
	};

get({50101, 1}) ->
	#skill_conf{
		skill_id = 50101,
		lv = 1,
		type = 1,
		cost_mp = 0,
		cd = 1500,
		spell_distance = 1,
		hit = 1,
		target = 3,
		range = {single, 0},
		effect_list = [{buff, 1702, 1000},{dm, 10000, 0}],
		spell_time = 0
	};

get({50102, 1}) ->
	#skill_conf{
		skill_id = 50102,
		lv = 1,
		type = 1,
		cost_mp = 0,
		cd = 1500,
		spell_distance = 1,
		hit = 1,
		target = 3,
		range = {single, 0},
		effect_list = [{buff, 1703, 500},{dm, 10000, 0}],
		spell_time = 0
	};

get({50103, 1}) ->
	#skill_conf{
		skill_id = 50103,
		lv = 1,
		type = 2,
		cost_mp = 0,
		cd = 0,
		spell_distance = 0,
		hit = 1,
		target = 3,
		range = {single, 0},
		effect_list = [{buff, 1000, 1701, 3000},{buff, 2000, 1701, 2000},{buff, 3000, 1701, 2000}],
		spell_time = 0
	};

get({50104, 1}) ->
	#skill_conf{
		skill_id = 50104,
		lv = 1,
		type = 2,
		cost_mp = 0,
		cd = 0,
		spell_distance = 0,
		hit = 1,
		target = 3,
		range = {single, 0},
		effect_list = [{buff, 1000, 1701, 4000},{buff, 2000, 1701, 3000},{buff, 3000, 1701, 3000}],
		spell_time = 0
	};

get({50201, 1}) ->
	#skill_conf{
		skill_id = 50201,
		lv = 1,
		type = 2,
		cost_mp = 0,
		cd = 0,
		spell_distance = 0,
		hit = 1,
		target = 1,
		range = {single, 0},
		effect_list = [{hs,[{1000, 4000, 5000},{2000, 4000, 2500}, {3000, 4000, 5000}]}],
		spell_time = 0
	};

get({50202, 1}) ->
	#skill_conf{
		skill_id = 50202,
		lv = 1,
		type = 2,
		cost_mp = 0,
		cd = 0,
		spell_distance = 0,
		hit = 1,
		target = 1,
		range = {single, 0},
		effect_list = [{hs,[{1000, 2500, 5000},{2000, 2500, 2500}, {3000, 2500, 5000}]}],
		spell_time = 0
	};

get({50301, 1}) ->
	#skill_conf{
		skill_id = 50301,
		lv = 1,
		type = 2,
		cost_mp = 0,
		cd = 0,
		spell_distance = 0,
		hit = 1,
		target = 1,
		range = {single, 0},
		effect_list = [{cd,150}],
		spell_time = 0
	};

get({50302, 1}) ->
	#skill_conf{
		skill_id = 50302,
		lv = 1,
		type = 2,
		cost_mp = 0,
		cd = 0,
		spell_distance = 0,
		hit = 1,
		target = 1,
		range = {single, 0},
		effect_list = [{cd,90}],
		spell_time = 0
	};

get({50401, 1}) ->
	#skill_conf{
		skill_id = 50401,
		lv = 1,
		type = 1,
		cost_mp = 0,
		cd = 1500,
		spell_distance = 1,
		hit = 1,
		target = 3,
		range = {single, 0},
		effect_list = [{buff, 1702, 500},{dm, 10000, 0}],
		spell_time = 0
	};

get({51001, 1}) ->
	#skill_conf{
		skill_id = 51001,
		lv = 1,
		type = 1,
		cost_mp = 0,
		cd = 800,
		spell_distance = 1,
		hit = 1,
		target = 3,
		range = {circle, 12},
		effect_list = [{dm, 50000, 0}],
		spell_time = 800
	};

get({51002, 1}) ->
	#skill_conf{
		skill_id = 51002,
		lv = 1,
		type = 1,
		cost_mp = 0,
		cd = 2000,
		spell_distance = 7,
		hit = 1,
		target = 3,
		range = {rang, 3},
		effect_list = [{dm, 50000, 0}],
		spell_time = 500
	};

get({51003, 1}) ->
	#skill_conf{
		skill_id = 51003,
		lv = 1,
		type = 1,
		cost_mp = 0,
		cd = 5000,
		spell_distance = 1,
		hit = 1,
		target = 3,
		range = {rang, 5},
		effect_list = [{dm, 50000, 0}],
		spell_time = 500
	};

get({51004, 1}) ->
	#skill_conf{
		skill_id = 51004,
		lv = 1,
		type = 1,
		cost_mp = 0,
		cd = 5000,
		spell_distance = 5,
		hit = 1,
		target = 3,
		range = {rang, 5},
		effect_list = [{dm, 50000, 0}],
		spell_time = 500
	};

get({51005, 1}) ->
	#skill_conf{
		skill_id = 51005,
		lv = 1,
		type = 1,
		cost_mp = 0,
		cd = 5000,
		spell_distance = 5,
		hit = 1,
		target = 3,
		range = {rang, 5},
		effect_list = [{dm, 30000, 0}],
		spell_time = 500
	};

get({51006, 1}) ->
	#skill_conf{
		skill_id = 51006,
		lv = 1,
		type = 1,
		cost_mp = 0,
		cd = 5000,
		spell_distance = 7,
		hit = 1,
		target = 3,
		range = {rang, 5},
		effect_list = [{dm, 50000, 0}],
		spell_time = 500
	};

get({51007, 1}) ->
	#skill_conf{
		skill_id = 51007,
		lv = 1,
		type = 1,
		cost_mp = 0,
		cd = 5000,
		spell_distance = 7,
		hit = 1,
		target = 3,
		range = {rang, 5},
		effect_list = [{buff, 1704, 10000},{buff, 1705, 10000}],
		spell_time = 500
	};

get({51008, 1}) ->
	#skill_conf{
		skill_id = 51008,
		lv = 1,
		type = 1,
		cost_mp = 0,
		cd = 800,
		spell_distance = 1,
		hit = 1,
		target = 3,
		range = {circle, 12},
		effect_list = [{dm, 50000, 0}],
		spell_time = 800
	};

get({51009, 1}) ->
	#skill_conf{
		skill_id = 51009,
		lv = 1,
		type = 1,
		cost_mp = 0,
		cd = 2000,
		spell_distance = 7,
		hit = 1,
		target = 3,
		range = {rang, 3},
		effect_list = [{dm, 50000, 0}],
		spell_time = 500
	};

get({50800, 1}) ->
	#skill_conf{
		skill_id = 50800,
		lv = 1,
		type = 2,
		cost_mp = 0,
		cd = 0,
		spell_distance = 0,
		hit = 1,
		target = 1,
		range = {single, 0},
		effect_list = [{cure_mp, 10000, 400, 0}],
		spell_time = 0
	};

get({50800, 2}) ->
	#skill_conf{
		skill_id = 50800,
		lv = 2,
		type = 2,
		cost_mp = 0,
		cd = 0,
		spell_distance = 0,
		hit = 1,
		target = 1,
		range = {single, 0},
		effect_list = [{cure_mp, 10000, 400, 0}],
		spell_time = 0
	};

get({50800, 3}) ->
	#skill_conf{
		skill_id = 50800,
		lv = 3,
		type = 2,
		cost_mp = 0,
		cd = 0,
		spell_distance = 0,
		hit = 1,
		target = 1,
		range = {single, 0},
		effect_list = [{cure_mp, 10000, 800, 0}],
		spell_time = 0
	};

get({50900, 1}) ->
	#skill_conf{
		skill_id = 50900,
		lv = 1,
		type = 2,
		cost_mp = 0,
		cd = 0,
		spell_distance = 0,
		hit = 1,
		target = 1,
		range = {single, 0},
		effect_list = [{gethit_targer_buff, 1000, 1713, 1500},{gethit_targer_buff, 2000, 1713, 1500},{gethit_targer_buff, 3000, 1713, 1500}],
		spell_time = 0
	};

get({50900, 2}) ->
	#skill_conf{
		skill_id = 50900,
		lv = 2,
		type = 2,
		cost_mp = 0,
		cd = 0,
		spell_distance = 0,
		hit = 1,
		target = 1,
		range = {single, 0},
		effect_list = [{gethit_targer_buff, 1000, 1714, 3000},{gethit_targer_buff, 2000, 1714, 3000},{gethit_targer_buff, 3000, 1714, 3000}],
		spell_time = 0
	};

get({50900, 3}) ->
	#skill_conf{
		skill_id = 50900,
		lv = 3,
		type = 2,
		cost_mp = 0,
		cd = 0,
		spell_distance = 0,
		hit = 1,
		target = 1,
		range = {single, 0},
		effect_list = [{gethit_targer_buff, 1000, 1715, 5000},{gethit_targer_buff, 2000, 1715, 5000},{gethit_targer_buff, 3000, 1715, 5000}],
		spell_time = 0
	};

get({51000, 1}) ->
	#skill_conf{
		skill_id = 51000,
		lv = 1,
		type = 2,
		cost_mp = 0,
		cd = 0,
		spell_distance = 0,
		hit = 1,
		target = 1,
		range = {single, 0},
		effect_list = [{attack_caster_buff, 1000, 1716, 1500},{attack_caster_buff, 2000, 1716, 1500},{attack_caster_buff, 3000, 1716, 1500}],
		spell_time = 0
	};

get({51000, 2}) ->
	#skill_conf{
		skill_id = 51000,
		lv = 2,
		type = 2,
		cost_mp = 0,
		cd = 0,
		spell_distance = 0,
		hit = 1,
		target = 1,
		range = {single, 0},
		effect_list = [{attack_caster_buff, 1000, 1717, 3000},{attack_caster_buff, 2000, 1717, 3000},{attack_caster_buff, 3000, 1717, 3000}],
		spell_time = 0
	};

get({51000, 3}) ->
	#skill_conf{
		skill_id = 51000,
		lv = 3,
		type = 2,
		cost_mp = 0,
		cd = 0,
		spell_distance = 0,
		hit = 1,
		target = 1,
		range = {single, 0},
		effect_list = [{attack_caster_buff, 1000, 1718, 5000},{attack_caster_buff, 2000, 1718, 5000},{attack_caster_buff, 3000, 1718, 5000}],
		spell_time = 0
	};

get({51100, 1}) ->
	#skill_conf{
		skill_id = 51100,
		lv = 1,
		type = 2,
		cost_mp = 0,
		cd = 0,
		spell_distance = 0,
		hit = 1,
		target = 1,
		range = {single, 0},
		effect_list = [{attack_caster_buff, 1000, 1719, 10000},{attack_caster_buff, 2000, 1719, 10000},{attack_caster_buff, 3000, 1719, 10000}],
		spell_time = 0
	};

get({51100, 2}) ->
	#skill_conf{
		skill_id = 51100,
		lv = 2,
		type = 2,
		cost_mp = 0,
		cd = 0,
		spell_distance = 0,
		hit = 1,
		target = 1,
		range = {single, 0},
		effect_list = [{attack_caster_buff, 1000, 1720, 10000},{attack_caster_buff, 2000, 1720, 10000},{attack_caster_buff, 3000, 1720, 10000}],
		spell_time = 0
	};

get({51100, 3}) ->
	#skill_conf{
		skill_id = 51100,
		lv = 3,
		type = 2,
		cost_mp = 0,
		cd = 0,
		spell_distance = 0,
		hit = 1,
		target = 1,
		range = {single, 0},
		effect_list = [{attack_caster_buff, 1000, 1721, 10000},{attack_caster_buff, 2000, 1721, 10000},{attack_caster_buff, 3000, 1721, 10000}],
		spell_time = 0
	};

get({51200, 1}) ->
	#skill_conf{
		skill_id = 51200,
		lv = 1,
		type = 1,
		cost_mp = 0,
		cd = 800,
		spell_distance = 1,
		hit = 1,
		target = 1,
		range = {single, 0},
		effect_list = [{buff, 1901, 10000}],
		spell_time = 800
	};

get({51200, 2}) ->
	#skill_conf{
		skill_id = 51200,
		lv = 2,
		type = 1,
		cost_mp = 0,
		cd = 800,
		spell_distance = 1,
		hit = 1,
		target = 1,
		range = {single, 0},
		effect_list = [{buff, 1902, 10000}],
		spell_time = 800
	};

get({51200, 3}) ->
	#skill_conf{
		skill_id = 51200,
		lv = 3,
		type = 1,
		cost_mp = 0,
		cd = 800,
		spell_distance = 1,
		hit = 1,
		target = 1,
		range = {single, 0},
		effect_list = [{buff, 1903, 10000}],
		spell_time = 800
	};

get({51300, 1}) ->
	#skill_conf{
		skill_id = 51300,
		lv = 1,
		type = 1,
		cost_mp = 0,
		cd = 0,
		spell_distance = 1,
		hit = 1,
		target = 1,
		range = {single, 0},
		effect_list = [{cd,300}],
		spell_time = <<"">>
	};

get({51300, 2}) ->
	#skill_conf{
		skill_id = 51300,
		lv = 2,
		type = 1,
		cost_mp = 0,
		cd = 0,
		spell_distance = 1,
		hit = 1,
		target = 1,
		range = {single, 0},
		effect_list = [{cd,180}],
		spell_time = <<"">>
	};

get({51300, 3}) ->
	#skill_conf{
		skill_id = 51300,
		lv = 3,
		type = 1,
		cost_mp = 0,
		cd = 0,
		spell_distance = 1,
		hit = 1,
		target = 1,
		range = {single, 0},
		effect_list = [{cd,60}],
		spell_time = <<"">>
	};

get({50105, 1}) ->
	#skill_conf{
		skill_id = 50105,
		lv = 1,
		type = 1,
		cost_mp = 0,
		cd = 1500,
		spell_distance = 5,
		hit = 1,
		target = 3,
		range = {single, 0},
		effect_list = [{buff, 2001, 1000},{dm, 10000, 0}],
		spell_time = 0
	};

get(_Key) ->
	?ERR("undefined key from skill_config ~p", [_Key]).