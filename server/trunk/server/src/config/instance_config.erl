%%%-------------------------------------------------------------------
%%% @author zhengsiying
%%% @doc
%%%		自动生成文件，不要手动修改
%%% @end
%%% Created : 2016/10/12
%%%-------------------------------------------------------------------

-module(instance_config).

-include("common.hrl").
-include("config.hrl").

-compile([export_all]).

get_list_conf() ->
	[ instance_config:get(X) || X <- get_list() ].

get_list() ->
	[20010, 20011, 20012, 20017, 20300, 20301, 20302, 20303, 20304, 20401, 20402, 20224, 31005, 20403, 20305, 20306, 20404, 20405, 20406, 20407, 20408, 21000, 21001, 21002, 30001, 30002, 30003, 30004, 30005, 30006, 30007, 30008, 30009, 30010, 30011, 30012, 30013, 30014, 30015, 30016, 30017, 30018, 30019, 30021, 30022, 30023, 30024, 30025, 30026, 30027, 30028, 30029, 30030, 30031, 30032, 30033, 30034, 30035, 30036, 30037, 30038, 30039, 30041, 30042, 30043, 30044, 30045, 30046, 30047, 30048, 30049, 30050, 30051, 30052, 30053, 30054, 30055, 30056, 30057, 30058, 30059, 22001, 32001, 32002, 32003, 32004, 32117, 32121, 31002, 31003, 31004, 32107, 32104, 32105, 32106, 32108, 32109, 32110, 32111, 20307, 20308, 20309, 32112, 32113, 32114, 32115, 32122, 32123, 32124, 32125].

get(20010) ->
	#instance_conf{
		scene_id = 20010,
		next_id = 0,
		type = 1,
		setup_time = 0,
		end_time = 1800,
		close_time = 1810,
		times_limit = 2,
		buy_limit = 1,
		cost = [],
		pass_condition = {kill_all},
		pass_prize = [{110057, 1, 100000}],
		boss_id = 7301,
		recover = 0
	};

get(20011) ->
	#instance_conf{
		scene_id = 20011,
		next_id = 0,
		type = 1,
		setup_time = 0,
		end_time = 1800,
		close_time = 1810,
		times_limit = 2,
		buy_limit = 1,
		cost = [],
		pass_condition = {kill_all},
		pass_prize = [{110009, 1, 50000}],
		boss_id = 7302,
		recover = 0
	};

get(20012) ->
	#instance_conf{
		scene_id = 20012,
		next_id = 0,
		type = 1,
		setup_time = 0,
		end_time = 1800,
		close_time = 1810,
		times_limit = 2,
		buy_limit = 1,
		cost = [],
		pass_condition = {kill_all},
		pass_prize = [{110079, 1, 20},{110003, 1, 10}],
		boss_id = 7303,
		recover = 0
	};

get(20017) ->
	#instance_conf{
		scene_id = 20017,
		next_id = 0,
		type = 2,
		setup_time = 3,
		end_time = 120,
		close_time = 125,
		times_limit = -1,
		buy_limit = 0,
		cost = [],
		pass_condition = [],
		pass_prize = [],
		boss_id = <<"">>,
		recover = 1
	};

get(20300) ->
	#instance_conf{
		scene_id = 20300,
		next_id = 0,
		type = 3,
		setup_time = 0,
		end_time = 1800,
		close_time = 1810,
		times_limit = -1,
		buy_limit = 0,
		cost = [],
		pass_condition = [],
		pass_prize = [],
		boss_id = 7321,
		recover = 0
	};

get(20301) ->
	#instance_conf{
		scene_id = 20301,
		next_id = 0,
		type = 3,
		setup_time = 0,
		end_time = 1800,
		close_time = 1810,
		times_limit = -1,
		buy_limit = 0,
		cost = [],
		pass_condition = [],
		pass_prize = [],
		boss_id = 7322,
		recover = 0
	};

get(20302) ->
	#instance_conf{
		scene_id = 20302,
		next_id = 0,
		type = 3,
		setup_time = 0,
		end_time = 1800,
		close_time = 1810,
		times_limit = -1,
		buy_limit = 0,
		cost = [],
		pass_condition = [],
		pass_prize = [],
		boss_id = 7323,
		recover = 0
	};

get(20303) ->
	#instance_conf{
		scene_id = 20303,
		next_id = 0,
		type = 3,
		setup_time = 0,
		end_time = 1800,
		close_time = 1810,
		times_limit = -1,
		buy_limit = 0,
		cost = [],
		pass_condition = [],
		pass_prize = [],
		boss_id = 7326,
		recover = 0
	};

get(20304) ->
	#instance_conf{
		scene_id = 20304,
		next_id = 0,
		type = 3,
		setup_time = 0,
		end_time = 1800,
		close_time = 1810,
		times_limit = -1,
		buy_limit = 0,
		cost = [],
		pass_condition = [],
		pass_prize = [],
		boss_id = 7326,
		recover = 0
	};

get(20401) ->
	#instance_conf{
		scene_id = 20401,
		next_id = 0,
		type = 4,
		setup_time = 0,
		end_time = 600,
		close_time = 630,
		times_limit = -1,
		buy_limit = 0,
		cost = [],
		pass_condition = {kill_all},
		pass_prize = [{110004, 1, 10},{110005, 1, 10}],
		boss_id = 7301,
		recover = 0
	};

get(20402) ->
	#instance_conf{
		scene_id = 20402,
		next_id = 0,
		type = 4,
		setup_time = 0,
		end_time = 600,
		close_time = 630,
		times_limit = -1,
		buy_limit = 0,
		cost = [],
		pass_condition = {kill_all},
		pass_prize = [{110004, 1, 10},{110005, 1, 10}],
		boss_id = 7302,
		recover = 0
	};

get(20224) ->
	#instance_conf{
		scene_id = 20224,
		next_id = 0,
		type = 6,
		setup_time = 0,
		end_time = 3600,
		close_time = 3610,
		times_limit = -1,
		buy_limit = 0,
		cost = [],
		pass_condition = [],
		pass_prize = [],
		boss_id = <<"">>,
		recover = 0
	};

get(31005) ->
	#instance_conf{
		scene_id = 31005,
		next_id = 0,
		type = 6,
		setup_time = 0,
		end_time = 3600,
		close_time = 3610,
		times_limit = -1,
		buy_limit = 0,
		cost = [],
		pass_condition = [],
		pass_prize = [],
		boss_id = <<"">>,
		recover = 0
	};

get(20403) ->
	#instance_conf{
		scene_id = 20403,
		next_id = 0,
		type = 5,
		setup_time = 0,
		end_time = 3600,
		close_time = 3610,
		times_limit = -1,
		buy_limit = 0,
		cost = [],
		pass_condition = [],
		pass_prize = [],
		boss_id = 7701,
		recover = 0
	};

get(20305) ->
	#instance_conf{
		scene_id = 20305,
		next_id = 0,
		type = 3,
		setup_time = 0,
		end_time = 1800,
		close_time = 1810,
		times_limit = -1,
		buy_limit = 0,
		cost = [],
		pass_condition = [],
		pass_prize = [],
		boss_id = 7327,
		recover = 0
	};

get(20306) ->
	#instance_conf{
		scene_id = 20306,
		next_id = 0,
		type = 3,
		setup_time = 0,
		end_time = 1800,
		close_time = 1810,
		times_limit = -1,
		buy_limit = 0,
		cost = [],
		pass_condition = [],
		pass_prize = [],
		boss_id = 7328,
		recover = 0
	};

get(20404) ->
	#instance_conf{
		scene_id = 20404,
		next_id = 0,
		type = 7,
		setup_time = 0,
		end_time = 1800,
		close_time = 1810,
		times_limit = -1,
		buy_limit = 0,
		cost = [],
		pass_condition = [],
		pass_prize = [],
		boss_id = <<"">>,
		recover = 0
	};

get(20405) ->
	#instance_conf{
		scene_id = 20405,
		next_id = 0,
		type = 4,
		setup_time = 0,
		end_time = 600,
		close_time = 630,
		times_limit = -1,
		buy_limit = 0,
		cost = [],
		pass_condition = {kill_all},
		pass_prize = [],
		boss_id = 7301,
		recover = 0
	};

get(20406) ->
	#instance_conf{
		scene_id = 20406,
		next_id = 0,
		type = 4,
		setup_time = 0,
		end_time = 600,
		close_time = 630,
		times_limit = 5,
		buy_limit = 0,
		cost = [],
		pass_condition = {kill_all},
		pass_prize = [],
		boss_id = 7302,
		recover = 0
	};

get(20407) ->
	#instance_conf{
		scene_id = 20407,
		next_id = 0,
		type = 4,
		setup_time = 0,
		end_time = 600,
		close_time = 630,
		times_limit = -1,
		buy_limit = 0,
		cost = [],
		pass_condition = {kill_all},
		pass_prize = [],
		boss_id = 7301,
		recover = 0
	};

get(20408) ->
	#instance_conf{
		scene_id = 20408,
		next_id = 0,
		type = 4,
		setup_time = 0,
		end_time = 600,
		close_time = 630,
		times_limit = -1,
		buy_limit = 0,
		cost = [],
		pass_condition = {kill_all},
		pass_prize = [],
		boss_id = 7302,
		recover = 0
	};

get(21000) ->
	#instance_conf{
		scene_id = 21000,
		next_id = 0,
		type = 4,
		setup_time = 0,
		end_time = 600,
		close_time = 630,
		times_limit = -1,
		buy_limit = 0,
		cost = [],
		pass_condition = {kill_all},
		pass_prize = [],
		boss_id = 7302,
		recover = 0
	};

get(21001) ->
	#instance_conf{
		scene_id = 21001,
		next_id = 0,
		type = 4,
		setup_time = 0,
		end_time = 600,
		close_time = 630,
		times_limit = -1,
		buy_limit = 0,
		cost = [],
		pass_condition = {kill_all},
		pass_prize = [],
		boss_id = 7302,
		recover = 0
	};

get(21002) ->
	#instance_conf{
		scene_id = 21002,
		next_id = 0,
		type = 4,
		setup_time = 0,
		end_time = 600,
		close_time = 630,
		times_limit = -1,
		buy_limit = 0,
		cost = [],
		pass_condition = {kill_all},
		pass_prize = [],
		boss_id = 7302,
		recover = 0
	};

get(30001) ->
	#instance_conf{
		scene_id = 30001,
		next_id = 30002,
		type = 1,
		setup_time = 0,
		end_time = 300,
		close_time = 305,
		times_limit = 1,
		buy_limit = 1,
		cost = [],
		pass_condition = {kill_all},
		pass_prize = [{110057, 1, 100000}],
		boss_id = 7200,
		recover = 0
	};

get(30002) ->
	#instance_conf{
		scene_id = 30002,
		next_id = 30003,
		type = 1,
		setup_time = 0,
		end_time = 300,
		close_time = 305,
		times_limit = 1,
		buy_limit = 1,
		cost = [],
		pass_condition = {kill_all},
		pass_prize = [{110057, 1, 120000}],
		boss_id = 7201,
		recover = 0
	};

get(30003) ->
	#instance_conf{
		scene_id = 30003,
		next_id = 30004,
		type = 1,
		setup_time = 0,
		end_time = 300,
		close_time = 305,
		times_limit = 1,
		buy_limit = 1,
		cost = [],
		pass_condition = {kill_all},
		pass_prize = [{110057, 1, 140000}],
		boss_id = 7202,
		recover = 0
	};

get(30004) ->
	#instance_conf{
		scene_id = 30004,
		next_id = 30005,
		type = 1,
		setup_time = 0,
		end_time = 300,
		close_time = 305,
		times_limit = 1,
		buy_limit = 1,
		cost = [],
		pass_condition = {kill_all},
		pass_prize = [{110057, 1, 160000}],
		boss_id = 7203,
		recover = 0
	};

get(30005) ->
	#instance_conf{
		scene_id = 30005,
		next_id = 30006,
		type = 1,
		setup_time = 0,
		end_time = 300,
		close_time = 305,
		times_limit = 1,
		buy_limit = 1,
		cost = [],
		pass_condition = {kill_all},
		pass_prize = [{110057, 1, 240000}],
		boss_id = 7204,
		recover = 0
	};

get(30006) ->
	#instance_conf{
		scene_id = 30006,
		next_id = 30007,
		type = 1,
		setup_time = 0,
		end_time = 300,
		close_time = 305,
		times_limit = 1,
		buy_limit = 1,
		cost = [],
		pass_condition = {kill_all},
		pass_prize = [{110057, 1, 400000}],
		boss_id = 7205,
		recover = 0
	};

get(30007) ->
	#instance_conf{
		scene_id = 30007,
		next_id = 30008,
		type = 1,
		setup_time = 0,
		end_time = 300,
		close_time = 305,
		times_limit = 1,
		buy_limit = 1,
		cost = [],
		pass_condition = {kill_all},
		pass_prize = [{110057, 1, 560000}],
		boss_id = 7206,
		recover = 0
	};

get(30008) ->
	#instance_conf{
		scene_id = 30008,
		next_id = 30009,
		type = 1,
		setup_time = 0,
		end_time = 300,
		close_time = 305,
		times_limit = 1,
		buy_limit = 1,
		cost = [],
		pass_condition = {kill_all},
		pass_prize = [{110057, 1, 720000}],
		boss_id = 7207,
		recover = 0
	};

get(30009) ->
	#instance_conf{
		scene_id = 30009,
		next_id = 30010,
		type = 1,
		setup_time = 0,
		end_time = 300,
		close_time = 305,
		times_limit = 1,
		buy_limit = 1,
		cost = [],
		pass_condition = {kill_all},
		pass_prize = [{110057, 1, 780000}],
		boss_id = 7208,
		recover = 0
	};

get(30010) ->
	#instance_conf{
		scene_id = 30010,
		next_id = 30011,
		type = 1,
		setup_time = 0,
		end_time = 300,
		close_time = 305,
		times_limit = 1,
		buy_limit = 1,
		cost = [],
		pass_condition = {kill_all},
		pass_prize = [{110057, 1, 840000}],
		boss_id = 7209,
		recover = 0
	};

get(30011) ->
	#instance_conf{
		scene_id = 30011,
		next_id = 30012,
		type = 1,
		setup_time = 0,
		end_time = 300,
		close_time = 305,
		times_limit = 1,
		buy_limit = 1,
		cost = [],
		pass_condition = {kill_all},
		pass_prize = [{110057, 1, 900000}],
		boss_id = 7210,
		recover = 0
	};

get(30012) ->
	#instance_conf{
		scene_id = 30012,
		next_id = 30013,
		type = 1,
		setup_time = 0,
		end_time = 300,
		close_time = 305,
		times_limit = 1,
		buy_limit = 1,
		cost = [],
		pass_condition = {kill_all},
		pass_prize = [{110057, 1, 960000}],
		boss_id = 7211,
		recover = 0
	};

get(30013) ->
	#instance_conf{
		scene_id = 30013,
		next_id = 30014,
		type = 1,
		setup_time = 0,
		end_time = 300,
		close_time = 305,
		times_limit = 1,
		buy_limit = 1,
		cost = [],
		pass_condition = {kill_all},
		pass_prize = [{110057, 1, 1020000}],
		boss_id = 7212,
		recover = 0
	};

get(30014) ->
	#instance_conf{
		scene_id = 30014,
		next_id = 30015,
		type = 1,
		setup_time = 0,
		end_time = 300,
		close_time = 305,
		times_limit = 1,
		buy_limit = 1,
		cost = [],
		pass_condition = {kill_all},
		pass_prize = [{110057, 1, 1500000}],
		boss_id = 7213,
		recover = 0
	};

get(30015) ->
	#instance_conf{
		scene_id = 30015,
		next_id = 30016,
		type = 1,
		setup_time = 0,
		end_time = 300,
		close_time = 305,
		times_limit = 1,
		buy_limit = 1,
		cost = [],
		pass_condition = {kill_all},
		pass_prize = [{110057, 1, 2400000}],
		boss_id = 7214,
		recover = 0
	};

get(30016) ->
	#instance_conf{
		scene_id = 30016,
		next_id = 30017,
		type = 1,
		setup_time = 0,
		end_time = 300,
		close_time = 305,
		times_limit = 1,
		buy_limit = 1,
		cost = [],
		pass_condition = {kill_all},
		pass_prize = [{110057, 1, 3000000}],
		boss_id = 7215,
		recover = 0
	};

get(30017) ->
	#instance_conf{
		scene_id = 30017,
		next_id = 30018,
		type = 1,
		setup_time = 0,
		end_time = 300,
		close_time = 305,
		times_limit = 1,
		buy_limit = 1,
		cost = [],
		pass_condition = {kill_all},
		pass_prize = [{110057, 1, 3600000}],
		boss_id = 7216,
		recover = 0
	};

get(30018) ->
	#instance_conf{
		scene_id = 30018,
		next_id = 30019,
		type = 1,
		setup_time = 0,
		end_time = 300,
		close_time = 305,
		times_limit = 1,
		buy_limit = 1,
		cost = [],
		pass_condition = {kill_all},
		pass_prize = [{110057, 1, 4200000}],
		boss_id = 7217,
		recover = 0
	};

get(30019) ->
	#instance_conf{
		scene_id = 30019,
		next_id = 0,
		type = 1,
		setup_time = 0,
		end_time = 300,
		close_time = 305,
		times_limit = 1,
		buy_limit = 1,
		cost = [],
		pass_condition = {kill_all},
		pass_prize = [{110057, 1, 4800000}],
		boss_id = 7218,
		recover = 0
	};

get(30021) ->
	#instance_conf{
		scene_id = 30021,
		next_id = 30022,
		type = 1,
		setup_time = 0,
		end_time = 300,
		close_time = 305,
		times_limit = 1,
		buy_limit = 1,
		cost = [],
		pass_condition = {kill_all},
		pass_prize = [{110009, 1, 200000}],
		boss_id = 7220,
		recover = 0
	};

get(30022) ->
	#instance_conf{
		scene_id = 30022,
		next_id = 30023,
		type = 1,
		setup_time = 0,
		end_time = 300,
		close_time = 305,
		times_limit = 1,
		buy_limit = 1,
		cost = [],
		pass_condition = {kill_all},
		pass_prize = [{110009, 1, 210000}],
		boss_id = 7221,
		recover = 0
	};

get(30023) ->
	#instance_conf{
		scene_id = 30023,
		next_id = 30024,
		type = 1,
		setup_time = 0,
		end_time = 300,
		close_time = 305,
		times_limit = 1,
		buy_limit = 1,
		cost = [],
		pass_condition = {kill_all},
		pass_prize = [{110009, 1, 220000}],
		boss_id = 7222,
		recover = 0
	};

get(30024) ->
	#instance_conf{
		scene_id = 30024,
		next_id = 30025,
		type = 1,
		setup_time = 0,
		end_time = 300,
		close_time = 305,
		times_limit = 1,
		buy_limit = 1,
		cost = [],
		pass_condition = {kill_all},
		pass_prize = [{110009, 1, 230000}],
		boss_id = 7223,
		recover = 0
	};

get(30025) ->
	#instance_conf{
		scene_id = 30025,
		next_id = 30026,
		type = 1,
		setup_time = 0,
		end_time = 300,
		close_time = 305,
		times_limit = 1,
		buy_limit = 1,
		cost = [],
		pass_condition = {kill_all},
		pass_prize = [{110009, 1, 240000}],
		boss_id = 7224,
		recover = 0
	};

get(30026) ->
	#instance_conf{
		scene_id = 30026,
		next_id = 30027,
		type = 1,
		setup_time = 0,
		end_time = 300,
		close_time = 305,
		times_limit = 1,
		buy_limit = 1,
		cost = [],
		pass_condition = {kill_all},
		pass_prize = [{110009, 1, 250000}],
		boss_id = 7225,
		recover = 0
	};

get(30027) ->
	#instance_conf{
		scene_id = 30027,
		next_id = 30028,
		type = 1,
		setup_time = 0,
		end_time = 300,
		close_time = 305,
		times_limit = 1,
		buy_limit = 1,
		cost = [],
		pass_condition = {kill_all},
		pass_prize = [{110009, 1, 260000}],
		boss_id = 7226,
		recover = 0
	};

get(30028) ->
	#instance_conf{
		scene_id = 30028,
		next_id = 30029,
		type = 1,
		setup_time = 0,
		end_time = 300,
		close_time = 305,
		times_limit = 1,
		buy_limit = 1,
		cost = [],
		pass_condition = {kill_all},
		pass_prize = [{110009, 1, 270000}],
		boss_id = 7227,
		recover = 0
	};

get(30029) ->
	#instance_conf{
		scene_id = 30029,
		next_id = 30030,
		type = 1,
		setup_time = 0,
		end_time = 300,
		close_time = 305,
		times_limit = 1,
		buy_limit = 1,
		cost = [],
		pass_condition = {kill_all},
		pass_prize = [{110009, 1, 280000}],
		boss_id = 7228,
		recover = 0
	};

get(30030) ->
	#instance_conf{
		scene_id = 30030,
		next_id = 30031,
		type = 1,
		setup_time = 0,
		end_time = 300,
		close_time = 305,
		times_limit = 1,
		buy_limit = 1,
		cost = [],
		pass_condition = {kill_all},
		pass_prize = [{110009, 1, 290000}],
		boss_id = 7229,
		recover = 0
	};

get(30031) ->
	#instance_conf{
		scene_id = 30031,
		next_id = 30032,
		type = 1,
		setup_time = 0,
		end_time = 300,
		close_time = 305,
		times_limit = 1,
		buy_limit = 1,
		cost = [],
		pass_condition = {kill_all},
		pass_prize = [{110009, 1, 300000}],
		boss_id = 7230,
		recover = 0
	};

get(30032) ->
	#instance_conf{
		scene_id = 30032,
		next_id = 30033,
		type = 1,
		setup_time = 0,
		end_time = 300,
		close_time = 305,
		times_limit = 1,
		buy_limit = 1,
		cost = [],
		pass_condition = {kill_all},
		pass_prize = [{110009, 1, 310000}],
		boss_id = 7231,
		recover = 0
	};

get(30033) ->
	#instance_conf{
		scene_id = 30033,
		next_id = 30034,
		type = 1,
		setup_time = 0,
		end_time = 300,
		close_time = 305,
		times_limit = 1,
		buy_limit = 1,
		cost = [],
		pass_condition = {kill_all},
		pass_prize = [{110009, 1, 320000}],
		boss_id = 7232,
		recover = 0
	};

get(30034) ->
	#instance_conf{
		scene_id = 30034,
		next_id = 30035,
		type = 1,
		setup_time = 0,
		end_time = 300,
		close_time = 305,
		times_limit = 1,
		buy_limit = 1,
		cost = [],
		pass_condition = {kill_all},
		pass_prize = [{110009, 1, 330000}],
		boss_id = 7233,
		recover = 0
	};

get(30035) ->
	#instance_conf{
		scene_id = 30035,
		next_id = 30036,
		type = 1,
		setup_time = 0,
		end_time = 300,
		close_time = 305,
		times_limit = 1,
		buy_limit = 1,
		cost = [],
		pass_condition = {kill_all},
		pass_prize = [{110009, 1, 340000}],
		boss_id = 7234,
		recover = 0
	};

get(30036) ->
	#instance_conf{
		scene_id = 30036,
		next_id = 30037,
		type = 1,
		setup_time = 0,
		end_time = 300,
		close_time = 305,
		times_limit = 1,
		buy_limit = 1,
		cost = [],
		pass_condition = {kill_all},
		pass_prize = [{110009, 1, 350000}],
		boss_id = 7235,
		recover = 0
	};

get(30037) ->
	#instance_conf{
		scene_id = 30037,
		next_id = 30038,
		type = 1,
		setup_time = 0,
		end_time = 300,
		close_time = 305,
		times_limit = 1,
		buy_limit = 1,
		cost = [],
		pass_condition = {kill_all},
		pass_prize = [{110009, 1, 360000}],
		boss_id = 7236,
		recover = 0
	};

get(30038) ->
	#instance_conf{
		scene_id = 30038,
		next_id = 30039,
		type = 1,
		setup_time = 0,
		end_time = 300,
		close_time = 305,
		times_limit = 1,
		buy_limit = 1,
		cost = [],
		pass_condition = {kill_all},
		pass_prize = [{110009, 1, 370000}],
		boss_id = 7237,
		recover = 0
	};

get(30039) ->
	#instance_conf{
		scene_id = 30039,
		next_id = 0,
		type = 1,
		setup_time = 0,
		end_time = 300,
		close_time = 305,
		times_limit = 1,
		buy_limit = 1,
		cost = [],
		pass_condition = {kill_all},
		pass_prize = [{110009, 1, 380000}],
		boss_id = 7238,
		recover = 0
	};

get(30041) ->
	#instance_conf{
		scene_id = 30041,
		next_id = 30042,
		type = 1,
		setup_time = 0,
		end_time = 300,
		close_time = 305,
		times_limit = 1,
		buy_limit = 1,
		cost = [],
		pass_condition = {kill_all},
		pass_prize = [{110079, 1, 40},{110003, 1, 10}],
		boss_id = 7240,
		recover = 0
	};

get(30042) ->
	#instance_conf{
		scene_id = 30042,
		next_id = 30043,
		type = 1,
		setup_time = 0,
		end_time = 300,
		close_time = 305,
		times_limit = 1,
		buy_limit = 1,
		cost = [],
		pass_condition = {kill_all},
		pass_prize = [{110079, 1, 45},{110003, 1, 12}],
		boss_id = 7241,
		recover = 0
	};

get(30043) ->
	#instance_conf{
		scene_id = 30043,
		next_id = 30044,
		type = 1,
		setup_time = 0,
		end_time = 300,
		close_time = 305,
		times_limit = 1,
		buy_limit = 1,
		cost = [],
		pass_condition = {kill_all},
		pass_prize = [{110079, 1, 50},{110003, 1, 14}],
		boss_id = 7242,
		recover = 0
	};

get(30044) ->
	#instance_conf{
		scene_id = 30044,
		next_id = 30045,
		type = 1,
		setup_time = 0,
		end_time = 300,
		close_time = 305,
		times_limit = 1,
		buy_limit = 1,
		cost = [],
		pass_condition = {kill_all},
		pass_prize = [{110080, 1, 45},{110003, 1, 16}],
		boss_id = 7243,
		recover = 0
	};

get(30045) ->
	#instance_conf{
		scene_id = 30045,
		next_id = 30046,
		type = 1,
		setup_time = 0,
		end_time = 300,
		close_time = 305,
		times_limit = 1,
		buy_limit = 1,
		cost = [],
		pass_condition = {kill_all},
		pass_prize = [{110080, 1, 50},{110003, 1, 18}],
		boss_id = 7244,
		recover = 0
	};

get(30046) ->
	#instance_conf{
		scene_id = 30046,
		next_id = 30047,
		type = 1,
		setup_time = 0,
		end_time = 300,
		close_time = 305,
		times_limit = 1,
		buy_limit = 1,
		cost = [],
		pass_condition = {kill_all},
		pass_prize = [{110081, 1, 45},{110003, 1, 20}],
		boss_id = 7245,
		recover = 0
	};

get(30047) ->
	#instance_conf{
		scene_id = 30047,
		next_id = 30048,
		type = 1,
		setup_time = 0,
		end_time = 300,
		close_time = 305,
		times_limit = 1,
		buy_limit = 1,
		cost = [],
		pass_condition = {kill_all},
		pass_prize = [{110081, 1, 50},{110003, 1, 22}],
		boss_id = 7246,
		recover = 0
	};

get(30048) ->
	#instance_conf{
		scene_id = 30048,
		next_id = 30049,
		type = 1,
		setup_time = 0,
		end_time = 300,
		close_time = 305,
		times_limit = 1,
		buy_limit = 1,
		cost = [],
		pass_condition = {kill_all},
		pass_prize = [{110082, 1, 45},{110003, 1, 24}],
		boss_id = 7247,
		recover = 0
	};

get(30049) ->
	#instance_conf{
		scene_id = 30049,
		next_id = 30050,
		type = 1,
		setup_time = 0,
		end_time = 300,
		close_time = 305,
		times_limit = 1,
		buy_limit = 1,
		cost = [],
		pass_condition = {kill_all},
		pass_prize = [{110082, 1, 50},{110003, 1, 26}],
		boss_id = 7248,
		recover = 0
	};

get(30050) ->
	#instance_conf{
		scene_id = 30050,
		next_id = 30051,
		type = 1,
		setup_time = 0,
		end_time = 300,
		close_time = 305,
		times_limit = 1,
		buy_limit = 1,
		cost = [],
		pass_condition = {kill_all},
		pass_prize = [{110083, 1, 45},{110003, 1, 28}],
		boss_id = 7249,
		recover = 0
	};

get(30051) ->
	#instance_conf{
		scene_id = 30051,
		next_id = 30052,
		type = 1,
		setup_time = 0,
		end_time = 300,
		close_time = 305,
		times_limit = 1,
		buy_limit = 1,
		cost = [],
		pass_condition = {kill_all},
		pass_prize = [{110083, 1, 50},{110003, 1, 30}],
		boss_id = 7250,
		recover = 0
	};

get(30052) ->
	#instance_conf{
		scene_id = 30052,
		next_id = 30053,
		type = 1,
		setup_time = 0,
		end_time = 300,
		close_time = 305,
		times_limit = 1,
		buy_limit = 1,
		cost = [],
		pass_condition = {kill_all},
		pass_prize = [{110083, 1, 55},{110003, 1, 32}],
		boss_id = 7251,
		recover = 0
	};

get(30053) ->
	#instance_conf{
		scene_id = 30053,
		next_id = 30054,
		type = 1,
		setup_time = 0,
		end_time = 300,
		close_time = 305,
		times_limit = 1,
		buy_limit = 1,
		cost = [],
		pass_condition = {kill_all},
		pass_prize = [{110083, 1, 60},{110003, 1, 34}],
		boss_id = 7252,
		recover = 0
	};

get(30054) ->
	#instance_conf{
		scene_id = 30054,
		next_id = 30055,
		type = 1,
		setup_time = 0,
		end_time = 300,
		close_time = 305,
		times_limit = 1,
		buy_limit = 1,
		cost = [],
		pass_condition = {kill_all},
		pass_prize = [{110089, 1, 10},{110003, 1, 36}],
		boss_id = 7253,
		recover = 0
	};

get(30055) ->
	#instance_conf{
		scene_id = 30055,
		next_id = 30056,
		type = 1,
		setup_time = 0,
		end_time = 300,
		close_time = 305,
		times_limit = 1,
		buy_limit = 1,
		cost = [],
		pass_condition = {kill_all},
		pass_prize = [{110089, 1, 15},{110003, 1, 38}],
		boss_id = 7254,
		recover = 0
	};

get(30056) ->
	#instance_conf{
		scene_id = 30056,
		next_id = 30057,
		type = 1,
		setup_time = 0,
		end_time = 300,
		close_time = 305,
		times_limit = 1,
		buy_limit = 1,
		cost = [],
		pass_condition = {kill_all},
		pass_prize = [{110090, 1, 10},{110003, 1, 40}],
		boss_id = 7255,
		recover = 0
	};

get(30057) ->
	#instance_conf{
		scene_id = 30057,
		next_id = 30058,
		type = 1,
		setup_time = 0,
		end_time = 300,
		close_time = 305,
		times_limit = 1,
		buy_limit = 1,
		cost = [],
		pass_condition = {kill_all},
		pass_prize = [{110090, 1, 15},{110003, 1, 42}],
		boss_id = 7256,
		recover = 0
	};

get(30058) ->
	#instance_conf{
		scene_id = 30058,
		next_id = 30059,
		type = 1,
		setup_time = 0,
		end_time = 300,
		close_time = 305,
		times_limit = 1,
		buy_limit = 1,
		cost = [],
		pass_condition = {kill_all},
		pass_prize = [{110091, 1, 10},{110003, 1, 44}],
		boss_id = 7257,
		recover = 0
	};

get(30059) ->
	#instance_conf{
		scene_id = 30059,
		next_id = 0,
		type = 1,
		setup_time = 0,
		end_time = 300,
		close_time = 305,
		times_limit = 1,
		buy_limit = 1,
		cost = [],
		pass_condition = {kill_all},
		pass_prize = [{110091, 1, 15},{110003, 1, 46}],
		boss_id = 7258,
		recover = 0
	};

get(22001) ->
	#instance_conf{
		scene_id = 22001,
		next_id = 0,
		type = 8,
		setup_time = 0,
		end_time = 2700,
		close_time = 2710,
		times_limit = -1,
		buy_limit = 0,
		cost = [],
		pass_condition = [],
		pass_prize = [],
		boss_id = 8210,
		recover = 0,
		mail_reward = <<"">>
	};

get(32001) ->
	#instance_conf{
		scene_id = 32001,
		next_id = 0,
		type = 9,
		setup_time = 0,
		end_time = 3600,
		close_time = 3600,
		times_limit = -1,
		buy_limit = 0,
		cost = [],
		pass_condition = [],
		pass_prize = [],
		boss_id = 8210,
		recover = 0,
		mail_reward = <<"">>
	};

get(32002) ->
	#instance_conf{
		scene_id = 32002,
		next_id = 0,
		type = 9,
		setup_time = 0,
		end_time = 3600,
		close_time = 3600,
		times_limit = -1,
		buy_limit = 0,
		cost = [],
		pass_condition = [],
		pass_prize = [],
		boss_id = 8210,
		recover = 0,
		mail_reward = <<"">>
	};

get(32003) ->
	#instance_conf{
		scene_id = 32003,
		next_id = 0,
		type = 9,
		setup_time = 0,
		end_time = 3600,
		close_time = 3600,
		times_limit = -1,
		buy_limit = 0,
		cost = [],
		pass_condition = [],
		pass_prize = [],
		boss_id = 8210,
		recover = 0,
		mail_reward = <<"">>
	};

get(32004) ->
	#instance_conf{
		scene_id = 32004,
		next_id = 0,
		type = 9,
		setup_time = 0,
		end_time = 3600,
		close_time = 3600,
		times_limit = -1,
		buy_limit = 0,
		cost = [],
		pass_condition = [],
		pass_prize = [],
		boss_id = 8210,
		recover = 0,
		mail_reward = <<"">>
	};

get(32117) ->
	#instance_conf{
		scene_id = 32117,
		next_id = 0,
		type = 9,
		setup_time = 0,
		end_time = 3600,
		close_time = 3600,
		times_limit = -1,
		buy_limit = 0,
		cost = [],
		pass_condition = [],
		pass_prize = [],
		boss_id = 8210,
		recover = 0,
		mail_reward = <<"">>
	};

get(32121) ->
	#instance_conf{
		scene_id = 32121,
		next_id = 0,
		type = 9,
		setup_time = 0,
		end_time = 3600,
		close_time = 3600,
		times_limit = -1,
		buy_limit = 0,
		cost = [],
		pass_condition = [],
		pass_prize = [],
		boss_id = 8210,
		recover = 0,
		mail_reward = <<"">>
	};

get(31002) ->
	#instance_conf{
		scene_id = 31002,
		next_id = 0,
		type = 10,
		setup_time = 0,
		end_time = 7200,
		close_time = 7200,
		times_limit = -1,
		buy_limit = 0,
		cost = [],
		pass_condition = [],
		pass_prize = [],
		boss_id = 7701,
		recover = 0,
		mail_reward = <<"">>
	};

get(31003) ->
	#instance_conf{
		scene_id = 31003,
		next_id = 0,
		type = 10,
		setup_time = 0,
		end_time = 7200,
		close_time = 7200,
		times_limit = -1,
		buy_limit = 0,
		cost = [],
		pass_condition = [],
		pass_prize = [],
		boss_id = 7701,
		recover = 0,
		mail_reward = <<"">>
	};

get(31004) ->
	#instance_conf{
		scene_id = 31004,
		next_id = 0,
		type = 10,
		setup_time = 0,
		end_time = 7200,
		close_time = 7200,
		times_limit = -1,
		buy_limit = 0,
		cost = [],
		pass_condition = [],
		pass_prize = [],
		boss_id = 7701,
		recover = 0,
		mail_reward = <<"">>
	};

get(32107) ->
	#instance_conf{
		scene_id = 32107,
		next_id = 0,
		type = 11,
		setup_time = 0,
		end_time = 1200,
		close_time = 1220,
		times_limit = -1,
		buy_limit = 0,
		cost = [],
		pass_condition = [],
		pass_prize = [],
		boss_id = <<"">>,
		recover = 0,
		mail_reward = <<"">>
	};

get(32104) ->
	#instance_conf{
		scene_id = 32104,
		next_id = 0,
		type = 12,
		setup_time = 0,
		end_time = 3600,
		close_time = 3600,
		times_limit = -1,
		buy_limit = 0,
		cost = [],
		pass_condition = [],
		pass_prize = [],
		boss_id = <<"">>,
		recover = 0,
		mail_reward = <<"">>
	};

get(32105) ->
	#instance_conf{
		scene_id = 32105,
		next_id = 0,
		type = 12,
		setup_time = 0,
		end_time = 3600,
		close_time = 3600,
		times_limit = -1,
		buy_limit = 0,
		cost = [],
		pass_condition = [],
		pass_prize = [],
		boss_id = <<"">>,
		recover = 0,
		mail_reward = <<"">>
	};

get(32106) ->
	#instance_conf{
		scene_id = 32106,
		next_id = 0,
		type = 12,
		setup_time = 0,
		end_time = 3600,
		close_time = 3600,
		times_limit = -1,
		buy_limit = 0,
		cost = [],
		pass_condition = [],
		pass_prize = [],
		boss_id = <<"">>,
		recover = 0,
		mail_reward = <<"">>
	};

get(32108) ->
	#instance_conf{
		scene_id = 32108,
		next_id = 0,
		type = 13,
		setup_time = 0,
		end_time = 7200,
		close_time = 7200,
		times_limit = -1,
		buy_limit = 0,
		cost = [],
		pass_condition = [],
		pass_prize = [],
		boss_id = 7701,
		recover = 0,
		mail_reward = <<"">>
	};

get(32109) ->
	#instance_conf{
		scene_id = 32109,
		next_id = 0,
		type = 14,
		setup_time = 0,
		end_time = 7200,
		close_time = 7200,
		times_limit = -1,
		buy_limit = 0,
		cost = [],
		pass_condition = [],
		pass_prize = [],
		boss_id = 7701
	};

get(32110) ->
	#instance_conf{
		scene_id = 32110,
		next_id = 0,
		type = 14,
		setup_time = 0,
		end_time = 7200,
		close_time = 7200,
		times_limit = -1,
		buy_limit = 0,
		cost = [],
		pass_condition = [],
		pass_prize = [],
		boss_id = 7701,
		recover = 0,
		mail_reward = <<"">>
	};

get(32111) ->
	#instance_conf{
		scene_id = 32111,
		next_id = 0,
		type = 14,
		setup_time = 0,
		end_time = 7200,
		close_time = 7200,
		times_limit = -1,
		buy_limit = 0,
		cost = [],
		pass_condition = [],
		pass_prize = [],
		boss_id = 7701,
		recover = 0,
		mail_reward = <<"">>
	};

get(20307) ->
	#instance_conf{
		scene_id = 20307,
		next_id = 0,
		type = 3,
		setup_time = 0,
		end_time = 1800,
		close_time = 1810,
		times_limit = -1,
		buy_limit = 0,
		cost = [],
		pass_condition = [],
		pass_prize = [],
		boss_id = 7324,
		recover = 0
	};

get(20308) ->
	#instance_conf{
		scene_id = 20308,
		next_id = 0,
		type = 3,
		setup_time = 0,
		end_time = 1800,
		close_time = 1810,
		times_limit = -1,
		buy_limit = 0,
		cost = [],
		pass_condition = [],
		pass_prize = [],
		boss_id = 7325,
		recover = 0
	};

get(20309) ->
	#instance_conf{
		scene_id = 20309,
		next_id = 0,
		type = 3,
		setup_time = 0,
		end_time = 1800,
		close_time = 1810,
		times_limit = -1,
		buy_limit = 0,
		cost = [],
		pass_condition = [],
		pass_prize = [],
		boss_id = 7329,
		recover = 0
	};

get(32112) ->
	#instance_conf{
		scene_id = 32112,
		next_id = 0,
		type = 15,
		setup_time = 0,
		end_time = 3600,
		close_time = 3610,
		times_limit = -1,
		buy_limit = 0,
		cost = [],
		pass_condition = [],
		pass_prize = [],
		boss_id = <<"">>,
		recover = 0,
		mail_reward = [{1,1,119},{2,2,120},{3,3,121},{4,10,122},{11,999,123}]
	};

get(32113) ->
	#instance_conf{
		scene_id = 32113,
		next_id = 0,
		type = 16,
		setup_time = 0,
		end_time = 3600,
		close_time = 3610,
		times_limit = -1,
		buy_limit = 0,
		cost = [],
		pass_condition = [],
		pass_prize = [],
		boss_id = <<"">>,
		recover = 0,
		mail_reward = <<"">>
	};

get(32114) ->
	#instance_conf{
		scene_id = 32114,
		next_id = 0,
		type = 17,
		setup_time = 0,
		end_time = 3600,
		close_time = 3610,
		times_limit = -1,
		buy_limit = 0,
		cost = [],
		pass_condition = [],
		pass_prize = [],
		boss_id = <<"">>,
		recover = 0,
		mail_reward = [{1,1,124},{2,2,125},{3,3,126},{4,10,127},{11,999,128}]
	};

get(32115) ->
	#instance_conf{
		scene_id = 32115,
		next_id = 0,
		type = 18,
		setup_time = 0,
		end_time = 3600,
		close_time = 3610,
		times_limit = -1,
		buy_limit = 0,
		cost = [],
		pass_condition = [],
		pass_prize = [],
		boss_id = <<"">>,
		recover = 0
	};

get(32122) ->
	#instance_conf{
		scene_id = 32122,
		next_id = 0,
		type = 19,
		setup_time = 0,
		end_time = 3600,
		close_time = 3610,
		times_limit = -1,
		buy_limit = 0,
		cost = [],
		pass_condition = [],
		pass_prize = [],
		boss_id = <<"">>,
		recover = 0
	};

get(32123) ->
	#instance_conf{
		scene_id = 32123,
		next_id = 0,
		type = 19,
		setup_time = 0,
		end_time = 3600,
		close_time = 3610,
		times_limit = -1,
		buy_limit = 0,
		cost = [],
		pass_condition = [],
		pass_prize = [],
		boss_id = <<"">>,
		recover = 0
	};

get(32124) ->
	#instance_conf{
		scene_id = 32124,
		next_id = 0,
		type = 19,
		setup_time = 0,
		end_time = 3600,
		close_time = 3610,
		times_limit = -1,
		buy_limit = 0,
		cost = [],
		pass_condition = [],
		pass_prize = [],
		boss_id = <<"">>,
		recover = 0
	};

get(32125) ->
	#instance_conf{
		scene_id = 32125,
		next_id = 0,
		type = 19,
		setup_time = 0,
		end_time = 3600,
		close_time = 3610,
		times_limit = -1,
		buy_limit = 0,
		cost = [],
		pass_condition = [],
		pass_prize = [],
		boss_id = <<"">>,
		recover = 0
	};

get(_Key) ->
	 null.