%%%-------------------------------------------------------------------
%%% @author zhengsiying
%%% @doc
%%%		自动生成文件，不要手动修改
%%% @end
%%% Created : 2016/10/12
%%%-------------------------------------------------------------------

-module(buff_config).

-include("common.hrl").
-include("config.hrl").

-compile([export_all]).

get_list_conf() ->
	[ buff_config:get(X) || X <- get_list() ].

get_list() ->
	[1, 2, 101, 102, 103, 104, 105, 106, 107, 108, 109, 110, 111, 112, 201, 202, 203, 204, 205, 206, 207, 208, 209, 210, 211, 212, 301, 302, 303, 304, 305, 306, 307, 308, 309, 310, 311, 312, 1001, 1002, 1003, 1004, 1005, 1101, 1102, 1103, 1104, 1105, 1201, 1202, 1203, 1204, 1205, 1301, 1302, 1303, 1304, 1305, 1401, 1402, 1403, 1404, 1405, 1501, 1502, 1503, 1504, 1505, 1601, 1602, 1603, 1604, 1605, 1701, 1702, 1703, 1704, 1705, 1706, 1707, 1708, 1709, 1801, 1802, 1803, 1804, 1805, 2003, 2002, 3101, 3201, 3301, 1713, 1714, 1715, 1716, 1717, 1718, 1719, 1720, 1721, 1901, 1902, 1903, 2001].

get(1) ->
	#buff_conf{
		buff_id = 1,
		effect_id = <<"">>,
		src_id = <<"">>,
		rule = <<"">>,
		interval = <<"">>,
		duration = <<"">>,
		show = 1
	};

get(2) ->
	#buff_conf{
		buff_id = 2,
		effect_id = <<"">>,
		src_id = <<"">>,
		rule = <<"">>,
		interval = <<"">>,
		duration = <<"">>,
		show = 1
	};

get(101) ->
	#buff_conf{
		buff_id = 101,
		effect_id = <<"">>,
		src_id = <<"">>,
		rule = <<"">>,
		interval = <<"">>,
		duration = <<"">>,
		show = 0
	};

get(102) ->
	#buff_conf{
		buff_id = 102,
		effect_id = <<"">>,
		src_id = <<"">>,
		rule = <<"">>,
		interval = <<"">>,
		duration = <<"">>,
		show = 0
	};

get(103) ->
	#buff_conf{
		buff_id = 103,
		effect_id = <<"">>,
		src_id = <<"">>,
		rule = <<"">>,
		interval = <<"">>,
		duration = <<"">>,
		show = 0
	};

get(104) ->
	#buff_conf{
		buff_id = 104,
		effect_id = <<"">>,
		src_id = <<"">>,
		rule = <<"">>,
		interval = <<"">>,
		duration = <<"">>,
		show = 0
	};

get(105) ->
	#buff_conf{
		buff_id = 105,
		effect_id = <<"">>,
		src_id = <<"">>,
		rule = <<"">>,
		interval = <<"">>,
		duration = <<"">>,
		show = 0
	};

get(106) ->
	#buff_conf{
		buff_id = 106,
		effect_id = <<"">>,
		src_id = <<"">>,
		rule = <<"">>,
		interval = <<"">>,
		duration = <<"">>,
		show = 0
	};

get(107) ->
	#buff_conf{
		buff_id = 107,
		effect_id = <<"">>,
		src_id = <<"">>,
		rule = <<"">>,
		interval = <<"">>,
		duration = <<"">>,
		show = 0
	};

get(108) ->
	#buff_conf{
		buff_id = 108,
		effect_id = <<"">>,
		src_id = <<"">>,
		rule = <<"">>,
		interval = <<"">>,
		duration = <<"">>,
		show = 0
	};

get(109) ->
	#buff_conf{
		buff_id = 109,
		effect_id = <<"">>,
		src_id = <<"">>,
		rule = <<"">>,
		interval = <<"">>,
		duration = <<"">>,
		show = 0
	};

get(110) ->
	#buff_conf{
		buff_id = 110,
		effect_id = <<"">>,
		src_id = <<"">>,
		rule = <<"">>,
		interval = <<"">>,
		duration = <<"">>,
		show = 0
	};

get(111) ->
	#buff_conf{
		buff_id = 111,
		effect_id = <<"">>,
		src_id = <<"">>,
		rule = <<"">>,
		interval = <<"">>,
		duration = <<"">>,
		show = 0
	};

get(112) ->
	#buff_conf{
		buff_id = 112,
		effect_id = <<"">>,
		src_id = <<"">>,
		rule = <<"">>,
		interval = <<"">>,
		duration = <<"">>,
		show = 0
	};

get(201) ->
	#buff_conf{
		buff_id = 201,
		effect_id = <<"">>,
		src_id = <<"">>,
		rule = <<"">>,
		interval = <<"">>,
		duration = <<"">>,
		show = 0
	};

get(202) ->
	#buff_conf{
		buff_id = 202,
		effect_id = <<"">>,
		src_id = <<"">>,
		rule = <<"">>,
		interval = <<"">>,
		duration = <<"">>,
		show = 0
	};

get(203) ->
	#buff_conf{
		buff_id = 203,
		effect_id = <<"">>,
		src_id = <<"">>,
		rule = <<"">>,
		interval = <<"">>,
		duration = <<"">>,
		show = 0
	};

get(204) ->
	#buff_conf{
		buff_id = 204,
		effect_id = <<"">>,
		src_id = <<"">>,
		rule = <<"">>,
		interval = <<"">>,
		duration = <<"">>,
		show = 0
	};

get(205) ->
	#buff_conf{
		buff_id = 205,
		effect_id = <<"">>,
		src_id = <<"">>,
		rule = <<"">>,
		interval = <<"">>,
		duration = <<"">>,
		show = 0
	};

get(206) ->
	#buff_conf{
		buff_id = 206,
		effect_id = <<"">>,
		src_id = <<"">>,
		rule = <<"">>,
		interval = <<"">>,
		duration = <<"">>,
		show = 0
	};

get(207) ->
	#buff_conf{
		buff_id = 207,
		effect_id = <<"">>,
		src_id = <<"">>,
		rule = <<"">>,
		interval = <<"">>,
		duration = <<"">>,
		show = 0
	};

get(208) ->
	#buff_conf{
		buff_id = 208,
		effect_id = <<"">>,
		src_id = <<"">>,
		rule = <<"">>,
		interval = <<"">>,
		duration = <<"">>,
		show = 0
	};

get(209) ->
	#buff_conf{
		buff_id = 209,
		effect_id = <<"">>,
		src_id = <<"">>,
		rule = <<"">>,
		interval = <<"">>,
		duration = <<"">>,
		show = 0
	};

get(210) ->
	#buff_conf{
		buff_id = 210,
		effect_id = <<"">>,
		src_id = <<"">>,
		rule = <<"">>,
		interval = <<"">>,
		duration = <<"">>,
		show = 0
	};

get(211) ->
	#buff_conf{
		buff_id = 211,
		effect_id = <<"">>,
		src_id = <<"">>,
		rule = <<"">>,
		interval = <<"">>,
		duration = <<"">>,
		show = 0
	};

get(212) ->
	#buff_conf{
		buff_id = 212,
		effect_id = <<"">>,
		src_id = <<"">>,
		rule = <<"">>,
		interval = <<"">>,
		duration = <<"">>,
		show = 0
	};

get(301) ->
	#buff_conf{
		buff_id = 301,
		effect_id = <<"">>,
		src_id = <<"">>,
		rule = <<"">>,
		interval = <<"">>,
		duration = <<"">>,
		show = 0
	};

get(302) ->
	#buff_conf{
		buff_id = 302,
		effect_id = <<"">>,
		src_id = <<"">>,
		rule = <<"">>,
		interval = <<"">>,
		duration = <<"">>,
		show = 0
	};

get(303) ->
	#buff_conf{
		buff_id = 303,
		effect_id = <<"">>,
		src_id = <<"">>,
		rule = <<"">>,
		interval = <<"">>,
		duration = <<"">>,
		show = 0
	};

get(304) ->
	#buff_conf{
		buff_id = 304,
		effect_id = <<"">>,
		src_id = <<"">>,
		rule = <<"">>,
		interval = <<"">>,
		duration = <<"">>,
		show = 0
	};

get(305) ->
	#buff_conf{
		buff_id = 305,
		effect_id = <<"">>,
		src_id = <<"">>,
		rule = <<"">>,
		interval = <<"">>,
		duration = <<"">>,
		show = 0
	};

get(306) ->
	#buff_conf{
		buff_id = 306,
		effect_id = <<"">>,
		src_id = <<"">>,
		rule = <<"">>,
		interval = <<"">>,
		duration = <<"">>,
		show = 0
	};

get(307) ->
	#buff_conf{
		buff_id = 307,
		effect_id = <<"">>,
		src_id = <<"">>,
		rule = <<"">>,
		interval = <<"">>,
		duration = <<"">>,
		show = 0
	};

get(308) ->
	#buff_conf{
		buff_id = 308,
		effect_id = <<"">>,
		src_id = <<"">>,
		rule = <<"">>,
		interval = <<"">>,
		duration = <<"">>,
		show = 0
	};

get(309) ->
	#buff_conf{
		buff_id = 309,
		effect_id = <<"">>,
		src_id = <<"">>,
		rule = <<"">>,
		interval = <<"">>,
		duration = <<"">>,
		show = 0
	};

get(310) ->
	#buff_conf{
		buff_id = 310,
		effect_id = <<"">>,
		src_id = <<"">>,
		rule = <<"">>,
		interval = <<"">>,
		duration = <<"">>,
		show = 0
	};

get(311) ->
	#buff_conf{
		buff_id = 311,
		effect_id = <<"">>,
		src_id = <<"">>,
		rule = <<"">>,
		interval = <<"">>,
		duration = <<"">>,
		show = 0
	};

get(312) ->
	#buff_conf{
		buff_id = 312,
		effect_id = <<"">>,
		src_id = <<"">>,
		rule = <<"">>,
		interval = <<"">>,
		duration = <<"">>,
		show = 0
	};

get(1001) ->
	#buff_conf{
		buff_id = 1001,
		effect_id = 1,
		src_id = 1,
		rule = {1400,25},
		interval = 0,
		duration = 20,
		show = 1
	};

get(1002) ->
	#buff_conf{
		buff_id = 1002,
		effect_id = 1,
		src_id = 1,
		rule = {1700,50},
		interval = 0,
		duration = 30,
		show = 1
	};

get(1003) ->
	#buff_conf{
		buff_id = 1003,
		effect_id = 1,
		src_id = 1,
		rule = {2000,70},
		interval = 0,
		duration = 40,
		show = 1
	};

get(1004) ->
	#buff_conf{
		buff_id = 1004,
		effect_id = 1,
		src_id = 1,
		rule = {2500,100},
		interval = 0,
		duration = 50,
		show = 1
	};

get(1005) ->
	#buff_conf{
		buff_id = 1005,
		effect_id = 1,
		src_id = 1,
		rule = {2000,70},
		interval = 0,
		duration = 60,
		show = 1
	};

get(1101) ->
	#buff_conf{
		buff_id = 1101,
		effect_id = 2,
		src_id = 1,
		rule = [{46, 1400},{47, 1400}, {48, 1400},{49, 1400},{13, 40},{14, 80}, {15, 40},{16, 80}],
		interval = 0,
		duration = 30,
		show = 1
	};

get(1102) ->
	#buff_conf{
		buff_id = 1102,
		effect_id = 2,
		src_id = 1,
		rule = [{46, 1700},{47, 1700}, {48, 1700},{49, 1700},{13, 70},{14, 140}, {15, 70},{16, 140}],
		interval = 0,
		duration = 50,
		show = 1
	};

get(1103) ->
	#buff_conf{
		buff_id = 1103,
		effect_id = 2,
		src_id = 1,
		rule = [{46, 2000},{47, 2000}, {48, 2000},{49, 2000},{13, 100},{14, 200}, {15, 100},{16, 200}],
		interval = 0,
		duration = 70,
		show = 1
	};

get(1104) ->
	#buff_conf{
		buff_id = 1104,
		effect_id = 2,
		src_id = 1,
		rule = [{46, 2000},{47, 2000}, {48, 2000},{49, 2000},{13, 100},{14, 200}, {15, 100},{16, 200}],
		interval = 0,
		duration = 90,
		show = 1
	};

get(1105) ->
	#buff_conf{
		buff_id = 1105,
		effect_id = 2,
		src_id = 1,
		rule = [{46, 2000},{47, 2000}, {48, 2000},{49, 2000},{13, 100},{14, 200}, {15, 100},{16, 200}],
		interval = 0,
		duration = 110,
		show = 1
	};

get(1201) ->
	#buff_conf{
		buff_id = 1201,
		effect_id = 3,
		src_id = 1,
		rule = {15000, 0},
		interval = 0,
		duration = 20,
		show = 0
	};

get(1202) ->
	#buff_conf{
		buff_id = 1202,
		effect_id = 3,
		src_id = 1,
		rule = {17000, 0},
		interval = 0,
		duration = 20,
		show = 0
	};

get(1203) ->
	#buff_conf{
		buff_id = 1203,
		effect_id = 3,
		src_id = 1,
		rule = {19000, 0},
		interval = 0,
		duration = 20,
		show = 0
	};

get(1204) ->
	#buff_conf{
		buff_id = 1204,
		effect_id = 3,
		src_id = 1,
		rule = {21000, 0},
		interval = 0,
		duration = 20,
		show = 0
	};

get(1205) ->
	#buff_conf{
		buff_id = 1205,
		effect_id = 3,
		src_id = 1,
		rule = {19000, 0},
		interval = 0,
		duration = 20,
		show = 0
	};

get(1301) ->
	#buff_conf{
		buff_id = 1301,
		effect_id = 4,
		src_id = 1,
		rule = {},
		interval = 0,
		duration = 2,
		show = 0
	};

get(1302) ->
	#buff_conf{
		buff_id = 1302,
		effect_id = 4,
		src_id = 1,
		rule = {},
		interval = 0,
		duration = 2,
		show = 0
	};

get(1303) ->
	#buff_conf{
		buff_id = 1303,
		effect_id = 4,
		src_id = 1,
		rule = {},
		interval = 0,
		duration = 2,
		show = 0
	};

get(1304) ->
	#buff_conf{
		buff_id = 1304,
		effect_id = 4,
		src_id = 1,
		rule = {},
		interval = 0,
		duration = 2,
		show = 0
	};

get(1305) ->
	#buff_conf{
		buff_id = 1305,
		effect_id = 4,
		src_id = 1,
		rule = {},
		interval = 0,
		duration = 2,
		show = 0
	};

get(1401) ->
	#buff_conf{
		buff_id = 1401,
		effect_id = 2,
		src_id = 1,
		rule = [{46, -1400},{47, -1400}, {48, -1400},{49, -1400},{13, -9},{14, -18}, {15, -9},{16, -18}],
		interval = 0,
		duration = 20,
		show = 0
	};

get(1402) ->
	#buff_conf{
		buff_id = 1402,
		effect_id = 2,
		src_id = 1,
		rule = [{46, -1700},{47, -1700}, {48, -1700},{49, -1700},{13, -63},{14, -126}, {15, -63},{16, -126}],
		interval = 0,
		duration = 30,
		show = 0
	};

get(1403) ->
	#buff_conf{
		buff_id = 1403,
		effect_id = 2,
		src_id = 1,
		rule = [{46, -2000},{47, -2000}, {48, -2000},{49, -2000},{13, -131},{14, -262}, {15, -131},{16, -262}],
		interval = 0,
		duration = 40,
		show = 0
	};

get(1404) ->
	#buff_conf{
		buff_id = 1404,
		effect_id = 2,
		src_id = 1,
		rule = [{46, -2300},{47, -2300}, {48, -2300},{49, -2300},{13, -175},{14, -350}, {15, -175},{16, -350}],
		interval = 0,
		duration = 50,
		show = 0
	};

get(1405) ->
	#buff_conf{
		buff_id = 1405,
		effect_id = 2,
		src_id = 1,
		rule = [{46, -2000},{47, -2000}, {48, -2000},{49, -2000},{13, -131},{14, -262}, {15, -131},{16, -262}],
		interval = 0,
		duration = 60,
		show = 0
	};

get(1501) ->
	#buff_conf{
		buff_id = 1501,
		effect_id = 5,
		src_id = 1,
		rule = 2100,
		interval = 2,
		duration = 20,
		show = 0
	};

get(1502) ->
	#buff_conf{
		buff_id = 1502,
		effect_id = 5,
		src_id = 1,
		rule = 2800,
		interval = 2,
		duration = 30,
		show = 0
	};

get(1503) ->
	#buff_conf{
		buff_id = 1503,
		effect_id = 5,
		src_id = 1,
		rule = 3100,
		interval = 2,
		duration = 40,
		show = 0
	};

get(1504) ->
	#buff_conf{
		buff_id = 1504,
		effect_id = 5,
		src_id = 1,
		rule = 3500,
		interval = 2,
		duration = 50,
		show = 0
	};

get(1505) ->
	#buff_conf{
		buff_id = 1505,
		effect_id = 5,
		src_id = 1,
		rule = 4000,
		interval = 2,
		duration = 60,
		show = 0
	};

get(1601) ->
	#buff_conf{
		buff_id = 1601,
		effect_id = 6,
		src_id = 1,
		rule = {},
		interval = 0,
		duration = 15,
		show = 0
	};

get(1602) ->
	#buff_conf{
		buff_id = 1602,
		effect_id = 6,
		src_id = 1,
		rule = {},
		interval = 0,
		duration = 20,
		show = 0
	};

get(1603) ->
	#buff_conf{
		buff_id = 1603,
		effect_id = 6,
		src_id = 1,
		rule = {},
		interval = 0,
		duration = 25,
		show = 0
	};

get(1604) ->
	#buff_conf{
		buff_id = 1604,
		effect_id = 6,
		src_id = 1,
		rule = {},
		interval = 0,
		duration = 30,
		show = 0
	};

get(1605) ->
	#buff_conf{
		buff_id = 1605,
		effect_id = 6,
		src_id = 1,
		rule = {},
		interval = 0,
		duration = 35,
		show = 0
	};

get(1701) ->
	#buff_conf{
		buff_id = 1701,
		effect_id = 7,
		src_id = 1,
		rule = {},
		interval = 0,
		duration = 3,
		show = 0
	};

get(1702) ->
	#buff_conf{
		buff_id = 1702,
		effect_id = 7,
		src_id = 1,
		rule = {},
		interval = 0,
		duration = 3,
		show = 0
	};

get(1703) ->
	#buff_conf{
		buff_id = 1703,
		effect_id = 7,
		src_id = 1,
		rule = {},
		interval = 0,
		duration = 2,
		show = 0
	};

get(1704) ->
	#buff_conf{
		buff_id = 1704,
		effect_id = 2,
		src_id = 1,
		rule = [{46, -2000},{47, -2000}, {48, -2000},{49, -2000},{13, -131},{14, -262}, {15, -131},{16, -262}],
		interval = 0,
		duration = 20,
		show = 0
	};

get(1705) ->
	#buff_conf{
		buff_id = 1705,
		effect_id = 5,
		src_id = 1,
		rule = 8000,
		interval = 2,
		duration = 20,
		show = 0
	};

get(1706) ->
	#buff_conf{
		buff_id = 1706,
		effect_id = 11,
		src_id = 1,
		rule = {},
		interval = 0,
		duration = 2,
		show = 0
	};

get(1707) ->
	#buff_conf{
		buff_id = 1707,
		effect_id = 7,
		src_id = 1,
		rule = {},
		interval = 0,
		duration = 4,
		show = 0
	};

get(1708) ->
	#buff_conf{
		buff_id = 1708,
		effect_id = 11,
		src_id = 1,
		rule = {},
		interval = 0,
		duration = 3,
		show = 0
	};

get(1709) ->
	#buff_conf{
		buff_id = 1709,
		effect_id = 11,
		src_id = 1,
		rule = {},
		interval = 0,
		duration = 4,
		show = 0
	};

get(1801) ->
	#buff_conf{
		buff_id = 1801,
		effect_id = 8,
		src_id = 1,
		rule = 1100,
		interval = 2,
		duration = 20,
		show = 0
	};

get(1802) ->
	#buff_conf{
		buff_id = 1802,
		effect_id = 8,
		src_id = 1,
		rule = 1400,
		interval = 2,
		duration = 20,
		show = 0
	};

get(1803) ->
	#buff_conf{
		buff_id = 1803,
		effect_id = 8,
		src_id = 1,
		rule = 1700,
		interval = 2,
		duration = 20,
		show = 0
	};

get(1804) ->
	#buff_conf{
		buff_id = 1804,
		effect_id = 8,
		src_id = 1,
		rule = 2000,
		interval = 2,
		duration = 20,
		show = 0
	};

get(1805) ->
	#buff_conf{
		buff_id = 1805,
		effect_id = 8,
		src_id = 1,
		rule = 5000,
		interval = 2,
		duration = 20,
		show = 0
	};

get(2003) ->
	#buff_conf{
		buff_id = 2003,
		effect_id = 9,
		src_id = 1,
		rule = 10000,
		interval = 0,
		duration = 1800,
		show = 1
	};

get(2002) ->
	#buff_conf{
		buff_id = 2002,
		effect_id = 9,
		src_id = 1,
		rule = 20000,
		interval = 0,
		duration = 1800,
		show = 1
	};

get(3101) ->
	#buff_conf{
		buff_id = 3101,
		effect_id = 10,
		src_id = 1,
		rule = [{38, 500}],
		interval = 0,
		duration = 1800,
		show = 1
	};

get(3201) ->
	#buff_conf{
		buff_id = 3201,
		effect_id = 10,
		src_id = 2,
		rule = [{7, 50},{8, 100},{9, 50},{10, 100},{11, 50},{12, 100}],
		interval = 0,
		duration = 1800,
		show = 1
	};

get(3301) ->
	#buff_conf{
		buff_id = 3301,
		effect_id = 10,
		src_id = 3,
		rule = [{13, 100},{14, 200},{15, 100},{16, 200}],
		interval = 0,
		duration = 1800,
		show = 1
	};

get(1713) ->
	#buff_conf{
		buff_id = 1713,
		effect_id = 10,
		src_id = 4,
		rule = [{20, 5}],
		interval = 0,
		duration = 5,
		show = 1
	};

get(1714) ->
	#buff_conf{
		buff_id = 1714,
		effect_id = 10,
		src_id = 4,
		rule = [{20, 12}],
		interval = 0,
		duration = 10,
		show = 1
	};

get(1715) ->
	#buff_conf{
		buff_id = 1715,
		effect_id = 10,
		src_id = 4,
		rule = [{20, 29}],
		interval = 0,
		duration = 30,
		show = 1
	};

get(1716) ->
	#buff_conf{
		buff_id = 1716,
		effect_id = 10,
		src_id = 5,
		rule = [{19, 5}],
		interval = 0,
		duration = 5,
		show = 1
	};

get(1717) ->
	#buff_conf{
		buff_id = 1717,
		effect_id = 10,
		src_id = 5,
		rule = [{19, 12}],
		interval = 0,
		duration = 10,
		show = 1
	};

get(1718) ->
	#buff_conf{
		buff_id = 1718,
		effect_id = 10,
		src_id = 5,
		rule = [{19, 29}],
		interval = 0,
		duration = 30,
		show = 1
	};

get(1719) ->
	#buff_conf{
		buff_id = 1719,
		effect_id = 10,
		src_id = 6,
		rule = [{17, 35},{18, 1000}],
		interval = 0,
		duration = 5,
		show = 1
	};

get(1720) ->
	#buff_conf{
		buff_id = 1720,
		effect_id = 10,
		src_id = 6,
		rule = [{17, 45},{18, 2000}],
		interval = 0,
		duration = 10,
		show = 1
	};

get(1721) ->
	#buff_conf{
		buff_id = 1721,
		effect_id = 10,
		src_id = 6,
		rule = [{17, 75},{18, 4000}],
		interval = 0,
		duration = 30,
		show = 1
	};

get(1901) ->
	#buff_conf{
		buff_id = 1901,
		effect_id = 6,
		src_id = 1,
		rule = {},
		interval = 0,
		duration = 25,
		show = 0
	};

get(1902) ->
	#buff_conf{
		buff_id = 1902,
		effect_id = 6,
		src_id = 1,
		rule = {},
		interval = 0,
		duration = 30,
		show = 0
	};

get(1903) ->
	#buff_conf{
		buff_id = 1903,
		effect_id = 6,
		src_id = 1,
		rule = {},
		interval = 0,
		duration = 35,
		show = 0
	};

get(2001) ->
	#buff_conf{
		buff_id = 2001,
		effect_id = 7,
		src_id = 1,
		rule = {},
		interval = 0,
		duration = 3,
		show = 0
	};

get(_Key) ->
	 null.