%%%-------------------------------------------------------------------
%%% @author zhengsiying
%%% @doc
%%%		自动生成文件，不要手动修改
%%% @end
%%% Created : 2016/10/12
%%%-------------------------------------------------------------------

-module(counter_config).

-include("common.hrl").
-include("config.hrl").

-compile([export_all]).

get_list_conf() ->
	[ counter_config:get(X) || X <- get_list() ].

get_list() ->
	[10001, 10002, 10003, 10004, 10005, 10006, 10007, 10008, 10009, 10010, 10011, 10012, 10013, 10014, 10015, 10016, 10017, 10018, 10019, 10020, 10021, 10022, 10023, 10024, 10025, 10026, 10027, 10028, 10029, 10030, 10031, 10032, 10033, 10034, 10035, 10036, 10037, 10038, 10039, 10040, 10041, 10042, 10043, 10044, 10045, 10046, 10047, 10048, 10049, 10050, 10051, 10052, 10053, 10054, 10055, 10056, 10057, 10058, 10059, 10060, 10061, 10062, 10063, 10064, 10065, 10066, 10067, 10068, 10069, 10070, 10071, 10072, 10073, 10074, 10075, 10076, 10077, 10078, 10079, 10080, 10081, 10082, 10083, 10084, 10085, 10086, 10087, 10088, 10089, 10090, 10091, 10092, 10093, 10094, 10095, 10096, 10097, 10098, 10099, 10100, 10101, 10102, 10103, 10104, 10105, 10106, 10107, 10108, 10109, 10110, 10111, 10112, 10113, 10114, 10115, 10116, 10117, 10118, 10119, 10120, 10121, 10122, 10123, 10124, 10125, 10126, 10127, 10128, 10129, 10130, 10131].

get(10001) ->
	#counter_conf{
		counter_id = 10001,
		period_unit = <<"day">>,
		period = 1,
		limit_value = 3,
		base_time = {{2015,1,1},{0,0,0}}
	};

get(10002) ->
	#counter_conf{
		counter_id = 10002,
		period_unit = <<"day">>,
		period = 1,
		limit_value = 1,
		base_time = {{2015,1,1},{0,0,0}}
	};

get(10003) ->
	#counter_conf{
		counter_id = 10003,
		period_unit = <<"day">>,
		period = 1,
		limit_value = 1,
		base_time = {{2015,1,1},{0,0,0}}
	};

get(10004) ->
	#counter_conf{
		counter_id = 10004,
		period_unit = <<"day">>,
		period = 1,
		limit_value = 1,
		base_time = {{2015,1,1},{0,0,0}}
	};

get(10005) ->
	#counter_conf{
		counter_id = 10005,
		period_unit = <<"hour">>,
		period = 3,
		limit_value = 1,
		base_time = {{2015,1,1},{0,0,0}}
	};

get(10006) ->
	#counter_conf{
		counter_id = 10006,
		period_unit = <<"day">>,
		period = 1,
		limit_value = 999,
		base_time = {{2015,1,1},{0,0,0}}
	};

get(10007) ->
	#counter_conf{
		counter_id = 10007,
		period_unit = <<"day">>,
		period = 1,
		limit_value = 5,
		base_time = {{2015,1,1},{0,0,0}}
	};

get(10008) ->
	#counter_conf{
		counter_id = 10008,
		period_unit = <<"day">>,
		period = 1,
		limit_value = 1,
		base_time = {{2015,1,1},{0,0,0}}
	};

get(10009) ->
	#counter_conf{
		counter_id = 10009,
		period_unit = <<"day">>,
		period = 1,
		limit_value = 1,
		base_time = {{2015,1,1},{0,0,0}}
	};

get(10010) ->
	#counter_conf{
		counter_id = 10010,
		period_unit = <<"day">>,
		period = 1,
		limit_value = 99,
		base_time = {{2015,1,1},{0,0,0}}
	};

get(10011) ->
	#counter_conf{
		counter_id = 10011,
		period_unit = <<"day">>,
		period = 1,
		limit_value = 99,
		base_time = {{2015,1,1},{0,0,0}}
	};

get(10012) ->
	#counter_conf{
		counter_id = 10012,
		period_unit = <<"day">>,
		period = 1,
		limit_value = 99,
		base_time = {{2015,1,1},{0,0,0}}
	};

get(10013) ->
	#counter_conf{
		counter_id = 10013,
		period_unit = <<"forever">>,
		period = 1,
		limit_value = 99999,
		base_time = {{2015,1,1},{0,0,0}}
	};

get(10014) ->
	#counter_conf{
		counter_id = 10014,
		period_unit = <<"forever">>,
		period = 1,
		limit_value = 99999,
		base_time = {{2015,1,1},{0,0,0}}
	};

get(10015) ->
	#counter_conf{
		counter_id = 10015,
		period_unit = <<"forever">>,
		period = 1,
		limit_value = 99999,
		base_time = {{2015,1,1},{0,0,0}}
	};

get(10016) ->
	#counter_conf{
		counter_id = 10016,
		period_unit = <<"forever">>,
		period = 1,
		limit_value = 99999,
		base_time = {{2015,1,1},{0,0,0}}
	};

get(10017) ->
	#counter_conf{
		counter_id = 10017,
		period_unit = <<"forever">>,
		period = 1,
		limit_value = 99999,
		base_time = {{2015,1,1},{0,0,0}}
	};

get(10018) ->
	#counter_conf{
		counter_id = 10018,
		period_unit = <<"forever">>,
		period = 1,
		limit_value = 99999,
		base_time = {{2015,1,1},{0,0,0}}
	};

get(10019) ->
	#counter_conf{
		counter_id = 10019,
		period_unit = <<"forever">>,
		period = 1,
		limit_value = 99999,
		base_time = {{2015,1,1},{0,0,0}}
	};

get(10020) ->
	#counter_conf{
		counter_id = 10020,
		period_unit = <<"forever">>,
		period = 1,
		limit_value = 99999,
		base_time = {{2015,1,1},{0,0,0}}
	};

get(10021) ->
	#counter_conf{
		counter_id = 10021,
		period_unit = <<"forever">>,
		period = 1,
		limit_value = 1,
		base_time = {{2015,1,1},{0,0,0}}
	};

get(10022) ->
	#counter_conf{
		counter_id = 10022,
		period_unit = <<"forever">>,
		period = 1,
		limit_value = 99999,
		base_time = {{2015,1,1},{0,0,0}}
	};

get(10023) ->
	#counter_conf{
		counter_id = 10023,
		period_unit = <<"day">>,
		period = 1,
		limit_value = 99999999,
		base_time = {{2015,1,1},{0,0,0}}
	};

get(10024) ->
	#counter_conf{
		counter_id = 10024,
		period_unit = <<"forever">>,
		period = 1,
		limit_value = 1,
		base_time = {{2015,1,1},{0,0,0}}
	};

get(10025) ->
	#counter_conf{
		counter_id = 10025,
		period_unit = <<"forever">>,
		period = 1,
		limit_value = 1,
		base_time = {{2015,1,1},{0,0,0}}
	};

get(10026) ->
	#counter_conf{
		counter_id = 10026,
		period_unit = <<"forever">>,
		period = 1,
		limit_value = 1,
		base_time = {{2015,1,1},{0,0,0}}
	};

get(10027) ->
	#counter_conf{
		counter_id = 10027,
		period_unit = <<"forever">>,
		period = 1,
		limit_value = 1,
		base_time = {{2015,1,1},{0,0,0}}
	};

get(10028) ->
	#counter_conf{
		counter_id = 10028,
		period_unit = <<"forever">>,
		period = 1,
		limit_value = 1,
		base_time = {{2015,1,1},{0,0,0}}
	};

get(10029) ->
	#counter_conf{
		counter_id = 10029,
		period_unit = <<"forever">>,
		period = 1,
		limit_value = 1,
		base_time = {{2015,1,1},{0,0,0}}
	};

get(10030) ->
	#counter_conf{
		counter_id = 10030,
		period_unit = <<"forever">>,
		period = 1,
		limit_value = 1,
		base_time = {{2015,1,1},{0,0,0}}
	};

get(10031) ->
	#counter_conf{
		counter_id = 10031,
		period_unit = <<"day">>,
		period = 1,
		limit_value = 1,
		base_time = {{2015,1,1},{0,0,0}}
	};

get(10032) ->
	#counter_conf{
		counter_id = 10032,
		period_unit = <<"day">>,
		period = 1,
		limit_value = 1,
		base_time = {{2015,1,1},{0,0,0}}
	};

get(10033) ->
	#counter_conf{
		counter_id = 10033,
		period_unit = <<"day">>,
		period = 1,
		limit_value = 1,
		base_time = {{2015,1,1},{0,0,0}}
	};

get(10034) ->
	#counter_conf{
		counter_id = 10034,
		period_unit = <<"day">>,
		period = 1,
		limit_value = 1,
		base_time = {{2015,1,1},{0,0,0}}
	};

get(10035) ->
	#counter_conf{
		counter_id = 10035,
		period_unit = <<"day">>,
		period = 1,
		limit_value = 1,
		base_time = {{2015,1,1},{0,0,0}}
	};

get(10036) ->
	#counter_conf{
		counter_id = 10036,
		period_unit = <<"day">>,
		period = 1,
		limit_value = 1,
		base_time = {{2015,1,1},{0,0,0}}
	};

get(10037) ->
	#counter_conf{
		counter_id = 10037,
		period_unit = <<"forever">>,
		period = 1,
		limit_value = 1,
		base_time = {{2015,1,1},{0,0,0}}
	};

get(10038) ->
	#counter_conf{
		counter_id = 10038,
		period_unit = <<"month">>,
		period = 1,
		limit_value = 31,
		base_time = {{2015,1,1},{0,0,0}}
	};

get(10039) ->
	#counter_conf{
		counter_id = 10039,
		period_unit = <<"day">>,
		period = 1,
		limit_value = 1,
		base_time = {{2015,1,1},{0,0,0}}
	};

get(10040) ->
	#counter_conf{
		counter_id = 10040,
		period_unit = <<"day">>,
		period = 1,
		limit_value = 10,
		base_time = {{2015,1,1},{0,0,0}}
	};

get(10041) ->
	#counter_conf{
		counter_id = 10041,
		period_unit = <<"day">>,
		period = 1,
		limit_value = 99,
		base_time = {{2015,1,1},{0,0,0}}
	};

get(10042) ->
	#counter_conf{
		counter_id = 10042,
		period_unit = <<"day">>,
		period = 1,
		limit_value = 99,
		base_time = {{2015,1,1},{0,0,0}}
	};

get(10043) ->
	#counter_conf{
		counter_id = 10043,
		period_unit = <<"day">>,
		period = 1,
		limit_value = 99,
		base_time = {{2015,1,1},{0,0,0}}
	};

get(10044) ->
	#counter_conf{
		counter_id = 10044,
		period_unit = <<"week">>,
		period = 1,
		limit_value = 1,
		base_time = {{2015,1,1},{0,0,0}}
	};

get(10045) ->
	#counter_conf{
		counter_id = 10045,
		period_unit = <<"day">>,
		period = 1,
		limit_value = 5,
		base_time = {{2015,1,1},{0,0,0}}
	};

get(10046) ->
	#counter_conf{
		counter_id = 10046,
		period_unit = <<"day">>,
		period = 1,
		limit_value = 5,
		base_time = {{2015,1,1},{0,0,0}}
	};

get(10047) ->
	#counter_conf{
		counter_id = 10047,
		period_unit = <<"forever">>,
		period = 1,
		limit_value = 99999,
		base_time = {{2015,1,1},{0,0,0}}
	};

get(10048) ->
	#counter_conf{
		counter_id = 10048,
		period_unit = <<"forever">>,
		period = 1,
		limit_value = 99999,
		base_time = {{2015,1,1},{0,0,0}}
	};

get(10049) ->
	#counter_conf{
		counter_id = 10049,
		period_unit = <<"forever">>,
		period = 1,
		limit_value = 99999,
		base_time = {{2015,1,1},{0,0,0}}
	};

get(10050) ->
	#counter_conf{
		counter_id = 10050,
		period_unit = <<"day">>,
		period = 30,
		limit_value = 1,
		base_time = {{2015,1,1},{0,0,0}}
	};

get(10051) ->
	#counter_conf{
		counter_id = 10051,
		period_unit = <<"forever">>,
		period = 1,
		limit_value = 1,
		base_time = {{2015,1,1},{0,0,0}}
	};

get(10052) ->
	#counter_conf{
		counter_id = 10052,
		period_unit = <<"forever">>,
		period = 1,
		limit_value = 1,
		base_time = {{2015,1,1},{0,0,0}}
	};

get(10053) ->
	#counter_conf{
		counter_id = 10053,
		period_unit = <<"forever">>,
		period = 1,
		limit_value = 1,
		base_time = {{2015,1,1},{0,0,0}}
	};

get(10054) ->
	#counter_conf{
		counter_id = 10054,
		period_unit = <<"forever">>,
		period = 1,
		limit_value = 1,
		base_time = {{2015,1,1},{0,0,0}}
	};

get(10055) ->
	#counter_conf{
		counter_id = 10055,
		period_unit = <<"forever">>,
		period = 1,
		limit_value = 1,
		base_time = {{2015,1,1},{0,0,0}}
	};

get(10056) ->
	#counter_conf{
		counter_id = 10056,
		period_unit = <<"forever">>,
		period = 1,
		limit_value = 1,
		base_time = {{2015,1,1},{0,0,0}}
	};

get(10057) ->
	#counter_conf{
		counter_id = 10057,
		period_unit = <<"forever">>,
		period = 1,
		limit_value = 1,
		base_time = {{2015,1,1},{0,0,0}}
	};

get(10058) ->
	#counter_conf{
		counter_id = 10058,
		period_unit = <<"day">>,
		period = 1,
		limit_value = 500,
		base_time = {{2015,1,1},{0,0,0}}
	};

get(10059) ->
	#counter_conf{
		counter_id = 10059,
		period_unit = <<"day">>,
		period = 1,
		limit_value = 40,
		base_time = {{2015,1,1},{0,0,0}}
	};

get(10060) ->
	#counter_conf{
		counter_id = 10060,
		period_unit = <<"day">>,
		period = 1,
		limit_value = 40,
		base_time = {{2015,1,1},{0,0,0}}
	};

get(10061) ->
	#counter_conf{
		counter_id = 10061,
		period_unit = <<"day">>,
		period = 1,
		limit_value = 40,
		base_time = {{2015,1,1},{0,0,0}}
	};

get(10062) ->
	#counter_conf{
		counter_id = 10062,
		period_unit = <<"day">>,
		period = 1,
		limit_value = 40,
		base_time = {{2015,1,1},{0,0,0}}
	};

get(10063) ->
	#counter_conf{
		counter_id = 10063,
		period_unit = <<"day">>,
		period = 1,
		limit_value = 20,
		base_time = {{2015,1,1},{0,0,0}}
	};

get(10064) ->
	#counter_conf{
		counter_id = 10064,
		period_unit = <<"day">>,
		period = 1,
		limit_value = 20,
		base_time = {{2015,1,1},{0,0,0}}
	};

get(10065) ->
	#counter_conf{
		counter_id = 10065,
		period_unit = <<"day">>,
		period = 1,
		limit_value = 50,
		base_time = {{2015,1,1},{0,0,0}}
	};

get(10066) ->
	#counter_conf{
		counter_id = 10066,
		period_unit = <<"day">>,
		period = 1,
		limit_value = 2,
		base_time = {{2015,1,1},{0,0,0}}
	};

get(10067) ->
	#counter_conf{
		counter_id = 10067,
		period_unit = <<"day">>,
		period = 1,
		limit_value = 2,
		base_time = {{2015,1,1},{0,0,0}}
	};

get(10068) ->
	#counter_conf{
		counter_id = 10068,
		period_unit = <<"day">>,
		period = 1,
		limit_value = 5,
		base_time = {{2015,1,1},{0,0,0}}
	};

get(10069) ->
	#counter_conf{
		counter_id = 10069,
		period_unit = <<"day">>,
		period = 1,
		limit_value = 10,
		base_time = {{2015,1,1},{0,0,0}}
	};

get(10070) ->
	#counter_conf{
		counter_id = 10070,
		period_unit = <<"day">>,
		period = 1,
		limit_value = 99,
		base_time = {{2015,1,1},{0,0,0}}
	};

get(10071) ->
	#counter_conf{
		counter_id = 10071,
		period_unit = <<"week">>,
		period = 1,
		limit_value = 10,
		base_time = {{2015,1,1},{0,0,0}}
	};

get(10072) ->
	#counter_conf{
		counter_id = 10072,
		period_unit = <<"week">>,
		period = 1,
		limit_value = 10,
		base_time = {{2015,1,1},{0,0,0}}
	};

get(10073) ->
	#counter_conf{
		counter_id = 10073,
		period_unit = <<"week">>,
		period = 1,
		limit_value = 10,
		base_time = {{2015,1,1},{0,0,0}}
	};

get(10074) ->
	#counter_conf{
		counter_id = 10074,
		period_unit = <<"forever">>,
		period = 1,
		limit_value = 1,
		base_time = {{2015,1,1},{0,0,0}}
	};

get(10075) ->
	#counter_conf{
		counter_id = 10075,
		period_unit = <<"forever">>,
		period = 1,
		limit_value = 1,
		base_time = {{2015,1,1},{0,0,0}}
	};

get(10076) ->
	#counter_conf{
		counter_id = 10076,
		period_unit = <<"forever">>,
		period = 1,
		limit_value = 1,
		base_time = {{2015,1,1},{0,0,0}}
	};

get(10077) ->
	#counter_conf{
		counter_id = 10077,
		period_unit = <<"forever">>,
		period = 1,
		limit_value = 10,
		base_time = {{2015,1,1},{0,0,0}}
	};

get(10078) ->
	#counter_conf{
		counter_id = 10078,
		period_unit = <<"forever">>,
		period = 1,
		limit_value = 10,
		base_time = {{2015,1,1},{0,0,0}}
	};

get(10079) ->
	#counter_conf{
		counter_id = 10079,
		period_unit = <<"forever">>,
		period = 1,
		limit_value = 10,
		base_time = {{2015,1,1},{0,0,0}}
	};

get(10080) ->
	#counter_conf{
		counter_id = 10080,
		period_unit = <<"forever">>,
		period = 1,
		limit_value = 5,
		base_time = {{2015,1,1},{0,0,0}}
	};

get(10081) ->
	#counter_conf{
		counter_id = 10081,
		period_unit = <<"forever">>,
		period = 1,
		limit_value = 10,
		base_time = {{2015,1,1},{0,0,0}}
	};

get(10082) ->
	#counter_conf{
		counter_id = 10082,
		period_unit = <<"forever">>,
		period = 1,
		limit_value = 10,
		base_time = {{2015,1,1},{0,0,0}}
	};

get(10083) ->
	#counter_conf{
		counter_id = 10083,
		period_unit = <<"forever">>,
		period = 1,
		limit_value = 10,
		base_time = {{2015,1,1},{0,0,0}}
	};

get(10084) ->
	#counter_conf{
		counter_id = 10084,
		period_unit = <<"forever">>,
		period = 1,
		limit_value = 1,
		base_time = {{2015,1,1},{0,0,0}}
	};

get(10085) ->
	#counter_conf{
		counter_id = 10085,
		period_unit = <<"forever">>,
		period = 1,
		limit_value = 1,
		base_time = {{2015,1,1},{0,0,0}}
	};

get(10086) ->
	#counter_conf{
		counter_id = 10086,
		period_unit = <<"forever">>,
		period = 1,
		limit_value = 1,
		base_time = {{2015,1,1},{0,0,0}}
	};

get(10087) ->
	#counter_conf{
		counter_id = 10087,
		period_unit = <<"forever">>,
		period = 1,
		limit_value = 1,
		base_time = {{2015,1,1},{0,0,0}}
	};

get(10088) ->
	#counter_conf{
		counter_id = 10088,
		period_unit = <<"forever">>,
		period = 1,
		limit_value = 1,
		base_time = {{2015,1,1},{0,0,0}}
	};

get(10089) ->
	#counter_conf{
		counter_id = 10089,
		period_unit = <<"forever">>,
		period = 1,
		limit_value = 1,
		base_time = {{2015,1,1},{0,0,0}}
	};

get(10090) ->
	#counter_conf{
		counter_id = 10090,
		period_unit = <<"forever">>,
		period = 1,
		limit_value = 1,
		base_time = {{2015,1,1},{0,0,0}}
	};

get(10091) ->
	#counter_conf{
		counter_id = 10091,
		period_unit = <<"forever">>,
		period = 1,
		limit_value = 1,
		base_time = {{2015,1,1},{0,0,0}}
	};

get(10092) ->
	#counter_conf{
		counter_id = 10092,
		period_unit = <<"forever">>,
		period = 1,
		limit_value = 1,
		base_time = {{2015,1,1},{0,0,0}}
	};

get(10093) ->
	#counter_conf{
		counter_id = 10093,
		period_unit = <<"forever">>,
		period = 1,
		limit_value = 1,
		base_time = {{2015,1,1},{0,0,0}}
	};

get(10094) ->
	#counter_conf{
		counter_id = 10094,
		period_unit = <<"forever">>,
		period = 1,
		limit_value = 1,
		base_time = {{2015,1,1},{0,0,0}}
	};

get(10095) ->
	#counter_conf{
		counter_id = 10095,
		period_unit = <<"forever">>,
		period = 1,
		limit_value = 1,
		base_time = {{2015,1,1},{0,0,0}}
	};

get(10096) ->
	#counter_conf{
		counter_id = 10096,
		period_unit = <<"forever">>,
		period = 1,
		limit_value = 1,
		base_time = {{2015,1,1},{0,0,0}}
	};

get(10097) ->
	#counter_conf{
		counter_id = 10097,
		period_unit = <<"forever">>,
		period = 1,
		limit_value = 1,
		base_time = {{2015,1,1},{0,0,0}}
	};

get(10098) ->
	#counter_conf{
		counter_id = 10098,
		period_unit = <<"forever">>,
		period = 1,
		limit_value = 1,
		base_time = {{2015,1,1},{0,0,0}}
	};

get(10099) ->
	#counter_conf{
		counter_id = 10099,
		period_unit = <<"forever">>,
		period = 1,
		limit_value = 1,
		base_time = {{2015,1,1},{0,0,0}}
	};

get(10100) ->
	#counter_conf{
		counter_id = 10100,
		period_unit = <<"forever">>,
		period = 1,
		limit_value = 9999999,
		base_time = {{2015,1,1},{0,0,0}}
	};

get(10101) ->
	#counter_conf{
		counter_id = 10101,
		period_unit = <<"day">>,
		period = 1,
		limit_value = 9999999,
		base_time = {{2015,1,1},{0,0,0}}
	};

get(10102) ->
	#counter_conf{
		counter_id = 10102,
		period_unit = <<"forever">>,
		period = 1,
		limit_value = 9999999,
		base_time = {{2015,1,1},{0,0,0}}
	};

get(10103) ->
	#counter_conf{
		counter_id = 10103,
		period_unit = <<"day">>,
		period = 1,
		limit_value = 9999999,
		base_time = {{2015,1,1},{0,0,0}}
	};

get(10104) ->
	#counter_conf{
		counter_id = 10104,
		period_unit = <<"forever">>,
		period = 1,
		limit_value = 9999999,
		base_time = {{2015,1,1},{0,0,0}}
	};

get(10105) ->
	#counter_conf{
		counter_id = 10105,
		period_unit = <<"day">>,
		period = 1,
		limit_value = 9999999,
		base_time = {{2015,1,1},{0,0,0}}
	};

get(10106) ->
	#counter_conf{
		counter_id = 10106,
		period_unit = <<"forever">>,
		period = 1,
		limit_value = 9999999,
		base_time = {{2015,1,1},{0,0,0}}
	};

get(10107) ->
	#counter_conf{
		counter_id = 10107,
		period_unit = <<"day">>,
		period = 1,
		limit_value = 9999999,
		base_time = {{2015,1,1},{0,0,0}}
	};

get(10108) ->
	#counter_conf{
		counter_id = 10108,
		period_unit = <<"forever">>,
		period = 1,
		limit_value = 1,
		base_time = {{2015,1,1},{0,0,0}}
	};

get(10109) ->
	#counter_conf{
		counter_id = 10109,
		period_unit = <<"forever">>,
		period = 1,
		limit_value = 1,
		base_time = {{2015,1,1},{0,0,0}}
	};

get(10110) ->
	#counter_conf{
		counter_id = 10110,
		period_unit = <<"forever">>,
		period = 1,
		limit_value = 1,
		base_time = {{2015,1,1},{0,0,0}}
	};

get(10111) ->
	#counter_conf{
		counter_id = 10111,
		period_unit = <<"forever">>,
		period = 1,
		limit_value = 1,
		base_time = {{2015,1,1},{0,0,0}}
	};

get(10112) ->
	#counter_conf{
		counter_id = 10112,
		period_unit = <<"forever">>,
		period = 1,
		limit_value = 1,
		base_time = {{2015,1,1},{0,0,0}}
	};

get(10113) ->
	#counter_conf{
		counter_id = 10113,
		period_unit = <<"forever">>,
		period = 1,
		limit_value = 1,
		base_time = {{2015,1,1},{0,0,0}}
	};

get(10114) ->
	#counter_conf{
		counter_id = 10114,
		period_unit = <<"forever">>,
		period = 1,
		limit_value = 1,
		base_time = {{2015,1,1},{0,0,0}}
	};

get(10115) ->
	#counter_conf{
		counter_id = 10115,
		period_unit = <<"forever">>,
		period = 1,
		limit_value = 1,
		base_time = {{2015,1,1},{0,0,0}}
	};

get(10116) ->
	#counter_conf{
		counter_id = 10116,
		period_unit = <<"forever">>,
		period = 1,
		limit_value = 1,
		base_time = {{2015,1,1},{0,0,0}}
	};

get(10117) ->
	#counter_conf{
		counter_id = 10117,
		period_unit = <<"forever">>,
		period = 1,
		limit_value = 1,
		base_time = {{2015,1,1},{0,0,0}}
	};

get(10118) ->
	#counter_conf{
		counter_id = 10118,
		period_unit = <<"forever">>,
		period = 1,
		limit_value = 1,
		base_time = {{2015,1,1},{0,0,0}}
	};

get(10119) ->
	#counter_conf{
		counter_id = 10119,
		period_unit = <<"forever">>,
		period = 1,
		limit_value = 1,
		base_time = {{2015,1,1},{0,0,0}}
	};

get(10120) ->
	#counter_conf{
		counter_id = 10120,
		period_unit = <<"forever">>,
		period = 1,
		limit_value = 1,
		base_time = {{2015,1,1},{0,0,0}}
	};

get(10121) ->
	#counter_conf{
		counter_id = 10121,
		period_unit = <<"forever">>,
		period = 1,
		limit_value = 1,
		base_time = {{2015,1,1},{0,0,0}}
	};

get(10122) ->
	#counter_conf{
		counter_id = 10122,
		period_unit = <<"forever">>,
		period = 1,
		limit_value = 1,
		base_time = {{2015,1,1},{0,0,0}}
	};

get(10123) ->
	#counter_conf{
		counter_id = 10123,
		period_unit = <<"forever">>,
		period = 1,
		limit_value = 1,
		base_time = {{2015,1,1},{0,0,0}}
	};

get(10124) ->
	#counter_conf{
		counter_id = 10124,
		period_unit = <<"forever">>,
		period = 1,
		limit_value = 1,
		base_time = {{2015,1,1},{0,0,0}}
	};

get(10125) ->
	#counter_conf{
		counter_id = 10125,
		period_unit = <<"forever">>,
		period = 1,
		limit_value = 1,
		base_time = {{2015,1,1},{0,0,0}}
	};

get(10126) ->
	#counter_conf{
		counter_id = 10126,
		period_unit = <<"day">>,
		period = 1,
		limit_value = 10,
		base_time = {{2015,1,1},{0,0,0}}
	};

get(10127) ->
	#counter_conf{
		counter_id = 10127,
		period_unit = <<"day">>,
		period = 1,
		limit_value = 10,
		base_time = {{2015,1,1},{0,0,0}}
	};

get(10128) ->
	#counter_conf{
		counter_id = 10128,
		period_unit = <<"day">>,
		period = 1,
		limit_value = 20,
		base_time = {{2015,1,1},{0,0,0}}
	};

get(10129) ->
	#counter_conf{
		counter_id = 10129,
		period_unit = <<"day">>,
		period = 1,
		limit_value = 10,
		base_time = {{2015,1,1},{0,0,0}}
	};

get(10130) ->
	#counter_conf{
		counter_id = 10130,
		period_unit = <<"day">>,
		period = 1,
		limit_value = 100000,
		base_time = {{2015,1,1},{0,0,0}}
	};

get(10131) ->
	#counter_conf{
		counter_id = 10131,
		period_unit = <<"day">>,
		period = 1,
		limit_value = 999999,
		base_time = {{2015,1,1},{0,0,0}}
	};

get(_Key) ->
	?ERR("undefined key from counter_config ~p", [_Key]).