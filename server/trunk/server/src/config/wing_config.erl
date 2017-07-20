%%%-------------------------------------------------------------------
%%% @author zhengsiying
%%% @doc
%%%		自动生成文件，不要手动修改
%%% @end
%%% Created : 2016/10/12
%%%-------------------------------------------------------------------

-module(wing_config).

-include("common.hrl").
-include("config.hrl").

-compile([export_all]).

get_list_conf() ->
	[ wing_config:get(X) || X <- get_list() ].

get_list() ->
	[1000, 1001, 1002, 1003, 1004, 1005, 1006, 1007, 1008, 1009, 1010, 1011, 1012, 1013, 1014, 1015, 1016, 1017, 1018, 1019, 1020, 1021, 1022, 1023, 1024, 1025, 1026, 1027, 1028, 1029, 1030, 1031, 1032, 1033, 1034, 1035, 1036, 1037, 1038, 1039, 1040, 1041, 1042, 1043, 1044, 1045, 1046, 1047, 1048, 1049, 1050, 1051, 1052, 1053, 1054, 1055, 1056, 1057, 1058, 1059, 1060, 1061, 1062, 1063, 1064, 1065, 1066, 1067, 1068, 1069, 1070, 1071, 1072, 1073, 1074, 1075, 1076, 1077, 1078, 1079, 1080, 1081, 1082, 1083, 1084, 1085, 1086, 1087, 1088, 1089, 1090, 1091, 1092, 1093, 1094, 1095, 1096, 1097, 1098, 1099, 1100, 1101, 1102, 1103, 1104, 1105, 1106, 1107, 1108, 1109, 1110, 1111, 1112, 1113, 1114, 1115, 1116, 1117, 1118, 1119, 1120, 1121, 1122, 1123, 1124, 1125, 1126, 1127, 1128, 1129, 2000, 2001, 2002, 2003, 2004, 2005, 2006, 2007, 2008, 2009, 2010, 2011, 2012, 2013, 2014, 2015, 2016, 2017, 2018, 2019, 2020, 2021, 2022, 2023, 2024, 2025, 2026, 2027, 2028, 2029, 2030, 2031, 2032, 2033, 2034, 2035, 2036, 2037, 2038, 2039, 2040, 2041, 2042, 2043, 2044, 2045, 2046, 2047, 2048, 2049, 2050, 2051, 2052, 2053, 2054, 2055, 2056, 2057, 2058, 2059, 2060, 2061, 2062, 2063, 2064, 2065, 2066, 2067, 2068, 2069, 2070, 2071, 2072, 2073, 2074, 2075, 2076, 2077, 2078, 2079, 2080, 2081, 2082, 2083, 2084, 2085, 2086, 2087, 2088, 2089, 2090, 2091, 2092, 2093, 2094, 2095, 2096, 2097, 2098, 2099, 2100, 2101, 2102, 2103, 2104, 2105, 2106, 2107, 2108, 2109, 2110, 2111, 2112, 2113, 2114, 2115, 2116, 2117, 2118, 2119, 2120, 2121, 2122, 2123, 2124, 2125, 2126, 2127, 2128, 2129, 3000, 3001, 3002, 3003, 3004, 3005, 3006, 3007, 3008, 3009, 3010, 3011, 3012, 3013, 3014, 3015, 3016, 3017, 3018, 3019, 3020, 3021, 3022, 3023, 3024, 3025, 3026, 3027, 3028, 3029, 3030, 3031, 3032, 3033, 3034, 3035, 3036, 3037, 3038, 3039, 3040, 3041, 3042, 3043, 3044, 3045, 3046, 3047, 3048, 3049, 3050, 3051, 3052, 3053, 3054, 3055, 3056, 3057, 3058, 3059, 3060, 3061, 3062, 3063, 3064, 3065, 3066, 3067, 3068, 3069, 3070, 3071, 3072, 3073, 3074, 3075, 3076, 3077, 3078, 3079, 3080, 3081, 3082, 3083, 3084, 3085, 3086, 3087, 3088, 3089, 3090, 3091, 3092, 3093, 3094, 3095, 3096, 3097, 3098, 3099, 3100, 3101, 3102, 3103, 3104, 3105, 3106, 3107, 3108, 3109, 3110, 3111, 3112, 3113, 3114, 3115, 3116, 3117, 3118, 3119, 3120, 3121, 3122, 3123, 3124, 3125, 3126, 3127, 3128, 3129, 4000, 4001, 4002, 4003, 4004, 4005, 4006, 4007, 4008, 4009, 4010, 5000, 5001, 5002, 5003, 5004, 5005, 5006, 5007, 5008, 5009, 5010, 6000, 6001, 6002, 6003, 6004, 6005, 6006, 6007, 6008, 6009, 6010].

get(1000) ->
	#wing_conf{
		key = 1000,
		goods_id = 307000,
		need_goods = 110127,
		need_num = 5,
		money_type = 1,
		price = 20000,
		limit_lv = 1,
		next_id = 307001
	};

get(1001) ->
	#wing_conf{
		key = 1001,
		goods_id = 307001,
		need_goods = 110127,
		need_num = 5,
		money_type = 1,
		price = 20000,
		limit_lv = 1,
		next_id = 307002
	};

get(1002) ->
	#wing_conf{
		key = 1002,
		goods_id = 307002,
		need_goods = 110127,
		need_num = 5,
		money_type = 1,
		price = 20000,
		limit_lv = 1,
		next_id = 307003
	};

get(1003) ->
	#wing_conf{
		key = 1003,
		goods_id = 307003,
		need_goods = 110127,
		need_num = 5,
		money_type = 1,
		price = 20000,
		limit_lv = 1,
		next_id = 307004
	};

get(1004) ->
	#wing_conf{
		key = 1004,
		goods_id = 307004,
		need_goods = 110127,
		need_num = 5,
		money_type = 1,
		price = 20000,
		limit_lv = 1,
		next_id = 307005
	};

get(1005) ->
	#wing_conf{
		key = 1005,
		goods_id = 307005,
		need_goods = 110127,
		need_num = 5,
		money_type = 1,
		price = 20000,
		limit_lv = 1,
		next_id = 307006
	};

get(1006) ->
	#wing_conf{
		key = 1006,
		goods_id = 307006,
		need_goods = 110127,
		need_num = 5,
		money_type = 1,
		price = 20000,
		limit_lv = 1,
		next_id = 307007
	};

get(1007) ->
	#wing_conf{
		key = 1007,
		goods_id = 307007,
		need_goods = 110127,
		need_num = 5,
		money_type = 1,
		price = 20000,
		limit_lv = 1,
		next_id = 307008
	};

get(1008) ->
	#wing_conf{
		key = 1008,
		goods_id = 307008,
		need_goods = 110127,
		need_num = 5,
		money_type = 1,
		price = 20000,
		limit_lv = 1,
		next_id = 307009
	};

get(1009) ->
	#wing_conf{
		key = 1009,
		goods_id = 307009,
		need_goods = 110140,
		need_num = 10,
		money_type = 2,
		price = 30,
		limit_lv = 1,
		next_id = 307010
	};

get(1010) ->
	#wing_conf{
		key = 1010,
		goods_id = 307010,
		need_goods = 110127,
		need_num = 10,
		money_type = 1,
		price = 20000,
		limit_lv = 1,
		next_id = 307011
	};

get(1011) ->
	#wing_conf{
		key = 1011,
		goods_id = 307011,
		need_goods = 110127,
		need_num = 10,
		money_type = 1,
		price = 20000,
		limit_lv = 1,
		next_id = 307012
	};

get(1012) ->
	#wing_conf{
		key = 1012,
		goods_id = 307012,
		need_goods = 110127,
		need_num = 10,
		money_type = 1,
		price = 20000,
		limit_lv = 1,
		next_id = 307013
	};

get(1013) ->
	#wing_conf{
		key = 1013,
		goods_id = 307013,
		need_goods = 110127,
		need_num = 10,
		money_type = 1,
		price = 20000,
		limit_lv = 1,
		next_id = 307014
	};

get(1014) ->
	#wing_conf{
		key = 1014,
		goods_id = 307014,
		need_goods = 110127,
		need_num = 10,
		money_type = 1,
		price = 20000,
		limit_lv = 1,
		next_id = 307015
	};

get(1015) ->
	#wing_conf{
		key = 1015,
		goods_id = 307015,
		need_goods = 110127,
		need_num = 10,
		money_type = 1,
		price = 20000,
		limit_lv = 1,
		next_id = 307016
	};

get(1016) ->
	#wing_conf{
		key = 1016,
		goods_id = 307016,
		need_goods = 110127,
		need_num = 10,
		money_type = 1,
		price = 20000,
		limit_lv = 1,
		next_id = 307017
	};

get(1017) ->
	#wing_conf{
		key = 1017,
		goods_id = 307017,
		need_goods = 110127,
		need_num = 10,
		money_type = 1,
		price = 20000,
		limit_lv = 1,
		next_id = 307018
	};

get(1018) ->
	#wing_conf{
		key = 1018,
		goods_id = 307018,
		need_goods = 110127,
		need_num = 10,
		money_type = 1,
		price = 20000,
		limit_lv = 1,
		next_id = 307019
	};

get(1019) ->
	#wing_conf{
		key = 1019,
		goods_id = 307019,
		need_goods = 110140,
		need_num = 20,
		money_type = 2,
		price = 30,
		limit_lv = 1,
		next_id = 307020
	};

get(1020) ->
	#wing_conf{
		key = 1020,
		goods_id = 307020,
		need_goods = 110127,
		need_num = 15,
		money_type = 1,
		price = 20000,
		limit_lv = 1,
		next_id = 307021
	};

get(1021) ->
	#wing_conf{
		key = 1021,
		goods_id = 307021,
		need_goods = 110127,
		need_num = 15,
		money_type = 1,
		price = 20000,
		limit_lv = 1,
		next_id = 307022
	};

get(1022) ->
	#wing_conf{
		key = 1022,
		goods_id = 307022,
		need_goods = 110127,
		need_num = 15,
		money_type = 1,
		price = 20000,
		limit_lv = 1,
		next_id = 307023
	};

get(1023) ->
	#wing_conf{
		key = 1023,
		goods_id = 307023,
		need_goods = 110127,
		need_num = 15,
		money_type = 1,
		price = 20000,
		limit_lv = 1,
		next_id = 307024
	};

get(1024) ->
	#wing_conf{
		key = 1024,
		goods_id = 307024,
		need_goods = 110127,
		need_num = 15,
		money_type = 1,
		price = 20000,
		limit_lv = 1,
		next_id = 307025
	};

get(1025) ->
	#wing_conf{
		key = 1025,
		goods_id = 307025,
		need_goods = 110127,
		need_num = 15,
		money_type = 1,
		price = 20000,
		limit_lv = 1,
		next_id = 307026
	};

get(1026) ->
	#wing_conf{
		key = 1026,
		goods_id = 307026,
		need_goods = 110127,
		need_num = 15,
		money_type = 1,
		price = 20000,
		limit_lv = 1,
		next_id = 307027
	};

get(1027) ->
	#wing_conf{
		key = 1027,
		goods_id = 307027,
		need_goods = 110127,
		need_num = 15,
		money_type = 1,
		price = 20000,
		limit_lv = 1,
		next_id = 307028
	};

get(1028) ->
	#wing_conf{
		key = 1028,
		goods_id = 307028,
		need_goods = 110127,
		need_num = 15,
		money_type = 1,
		price = 20000,
		limit_lv = 1,
		next_id = 307029
	};

get(1029) ->
	#wing_conf{
		key = 1029,
		goods_id = 307029,
		need_goods = 110140,
		need_num = 40,
		money_type = 2,
		price = 30,
		limit_lv = 1,
		next_id = 307030
	};

get(1030) ->
	#wing_conf{
		key = 1030,
		goods_id = 307030,
		need_goods = 110127,
		need_num = 20,
		money_type = 1,
		price = 20000,
		limit_lv = 1,
		next_id = 307031
	};

get(1031) ->
	#wing_conf{
		key = 1031,
		goods_id = 307031,
		need_goods = 110127,
		need_num = 20,
		money_type = 1,
		price = 20000,
		limit_lv = 1,
		next_id = 307032
	};

get(1032) ->
	#wing_conf{
		key = 1032,
		goods_id = 307032,
		need_goods = 110127,
		need_num = 20,
		money_type = 1,
		price = 20000,
		limit_lv = 1,
		next_id = 307033
	};

get(1033) ->
	#wing_conf{
		key = 1033,
		goods_id = 307033,
		need_goods = 110127,
		need_num = 20,
		money_type = 1,
		price = 20000,
		limit_lv = 1,
		next_id = 307034
	};

get(1034) ->
	#wing_conf{
		key = 1034,
		goods_id = 307034,
		need_goods = 110127,
		need_num = 20,
		money_type = 1,
		price = 20000,
		limit_lv = 1,
		next_id = 307035
	};

get(1035) ->
	#wing_conf{
		key = 1035,
		goods_id = 307035,
		need_goods = 110127,
		need_num = 20,
		money_type = 1,
		price = 20000,
		limit_lv = 1,
		next_id = 307036
	};

get(1036) ->
	#wing_conf{
		key = 1036,
		goods_id = 307036,
		need_goods = 110127,
		need_num = 20,
		money_type = 1,
		price = 20000,
		limit_lv = 1,
		next_id = 307037
	};

get(1037) ->
	#wing_conf{
		key = 1037,
		goods_id = 307037,
		need_goods = 110127,
		need_num = 20,
		money_type = 1,
		price = 20000,
		limit_lv = 1,
		next_id = 307038
	};

get(1038) ->
	#wing_conf{
		key = 1038,
		goods_id = 307038,
		need_goods = 110127,
		need_num = 20,
		money_type = 1,
		price = 20000,
		limit_lv = 1,
		next_id = 307039
	};

get(1039) ->
	#wing_conf{
		key = 1039,
		goods_id = 307039,
		need_goods = 110140,
		need_num = 100,
		money_type = 2,
		price = 30,
		limit_lv = 1,
		next_id = 307040
	};

get(1040) ->
	#wing_conf{
		key = 1040,
		goods_id = 307040,
		need_goods = 110127,
		need_num = 25,
		money_type = 1,
		price = 20000,
		limit_lv = 1,
		next_id = 307041
	};

get(1041) ->
	#wing_conf{
		key = 1041,
		goods_id = 307041,
		need_goods = 110127,
		need_num = 25,
		money_type = 1,
		price = 20000,
		limit_lv = 1,
		next_id = 307042
	};

get(1042) ->
	#wing_conf{
		key = 1042,
		goods_id = 307042,
		need_goods = 110127,
		need_num = 25,
		money_type = 1,
		price = 20000,
		limit_lv = 1,
		next_id = 307043
	};

get(1043) ->
	#wing_conf{
		key = 1043,
		goods_id = 307043,
		need_goods = 110127,
		need_num = 25,
		money_type = 1,
		price = 20000,
		limit_lv = 1,
		next_id = 307044
	};

get(1044) ->
	#wing_conf{
		key = 1044,
		goods_id = 307044,
		need_goods = 110127,
		need_num = 25,
		money_type = 1,
		price = 20000,
		limit_lv = 1,
		next_id = 307045
	};

get(1045) ->
	#wing_conf{
		key = 1045,
		goods_id = 307045,
		need_goods = 110127,
		need_num = 25,
		money_type = 1,
		price = 20000,
		limit_lv = 1,
		next_id = 307046
	};

get(1046) ->
	#wing_conf{
		key = 1046,
		goods_id = 307046,
		need_goods = 110127,
		need_num = 25,
		money_type = 1,
		price = 20000,
		limit_lv = 1,
		next_id = 307047
	};

get(1047) ->
	#wing_conf{
		key = 1047,
		goods_id = 307047,
		need_goods = 110127,
		need_num = 25,
		money_type = 1,
		price = 20000,
		limit_lv = 1,
		next_id = 307048
	};

get(1048) ->
	#wing_conf{
		key = 1048,
		goods_id = 307048,
		need_goods = 110127,
		need_num = 25,
		money_type = 1,
		price = 20000,
		limit_lv = 1,
		next_id = 307049
	};

get(1049) ->
	#wing_conf{
		key = 1049,
		goods_id = 307049,
		need_goods = 110140,
		need_num = 200,
		money_type = 2,
		price = 30,
		limit_lv = 1,
		next_id = 307050
	};

get(1050) ->
	#wing_conf{
		key = 1050,
		goods_id = 307050,
		need_goods = 110127,
		need_num = 30,
		money_type = 1,
		price = 20000,
		limit_lv = 1,
		next_id = 307051
	};

get(1051) ->
	#wing_conf{
		key = 1051,
		goods_id = 307051,
		need_goods = 110127,
		need_num = 30,
		money_type = 1,
		price = 20000,
		limit_lv = 1,
		next_id = 307052
	};

get(1052) ->
	#wing_conf{
		key = 1052,
		goods_id = 307052,
		need_goods = 110127,
		need_num = 30,
		money_type = 1,
		price = 20000,
		limit_lv = 1,
		next_id = 307053
	};

get(1053) ->
	#wing_conf{
		key = 1053,
		goods_id = 307053,
		need_goods = 110127,
		need_num = 30,
		money_type = 1,
		price = 20000,
		limit_lv = 1,
		next_id = 307054
	};

get(1054) ->
	#wing_conf{
		key = 1054,
		goods_id = 307054,
		need_goods = 110127,
		need_num = 30,
		money_type = 1,
		price = 20000,
		limit_lv = 1,
		next_id = 307055
	};

get(1055) ->
	#wing_conf{
		key = 1055,
		goods_id = 307055,
		need_goods = 110127,
		need_num = 30,
		money_type = 1,
		price = 20000,
		limit_lv = 1,
		next_id = 307056
	};

get(1056) ->
	#wing_conf{
		key = 1056,
		goods_id = 307056,
		need_goods = 110127,
		need_num = 30,
		money_type = 1,
		price = 20000,
		limit_lv = 1,
		next_id = 307057
	};

get(1057) ->
	#wing_conf{
		key = 1057,
		goods_id = 307057,
		need_goods = 110127,
		need_num = 30,
		money_type = 1,
		price = 20000,
		limit_lv = 1,
		next_id = 307058
	};

get(1058) ->
	#wing_conf{
		key = 1058,
		goods_id = 307058,
		need_goods = 110127,
		need_num = 30,
		money_type = 1,
		price = 20000,
		limit_lv = 1,
		next_id = 307059
	};

get(1059) ->
	#wing_conf{
		key = 1059,
		goods_id = 307059,
		need_goods = 110140,
		need_num = 400,
		money_type = 2,
		price = 30,
		limit_lv = 1,
		next_id = 307060
	};

get(1060) ->
	#wing_conf{
		key = 1060,
		goods_id = 307060,
		need_goods = 110127,
		need_num = 35,
		money_type = 1,
		price = 20000,
		limit_lv = 1,
		next_id = 307061
	};

get(1061) ->
	#wing_conf{
		key = 1061,
		goods_id = 307061,
		need_goods = 110127,
		need_num = 35,
		money_type = 1,
		price = 20000,
		limit_lv = 1,
		next_id = 307062
	};

get(1062) ->
	#wing_conf{
		key = 1062,
		goods_id = 307062,
		need_goods = 110127,
		need_num = 35,
		money_type = 1,
		price = 20000,
		limit_lv = 1,
		next_id = 307063
	};

get(1063) ->
	#wing_conf{
		key = 1063,
		goods_id = 307063,
		need_goods = 110127,
		need_num = 35,
		money_type = 1,
		price = 20000,
		limit_lv = 1,
		next_id = 307064
	};

get(1064) ->
	#wing_conf{
		key = 1064,
		goods_id = 307064,
		need_goods = 110127,
		need_num = 35,
		money_type = 1,
		price = 20000,
		limit_lv = 1,
		next_id = 307065
	};

get(1065) ->
	#wing_conf{
		key = 1065,
		goods_id = 307065,
		need_goods = 110127,
		need_num = 35,
		money_type = 1,
		price = 20000,
		limit_lv = 1,
		next_id = 307066
	};

get(1066) ->
	#wing_conf{
		key = 1066,
		goods_id = 307066,
		need_goods = 110127,
		need_num = 35,
		money_type = 1,
		price = 20000,
		limit_lv = 1,
		next_id = 307067
	};

get(1067) ->
	#wing_conf{
		key = 1067,
		goods_id = 307067,
		need_goods = 110127,
		need_num = 35,
		money_type = 1,
		price = 20000,
		limit_lv = 1,
		next_id = 307068
	};

get(1068) ->
	#wing_conf{
		key = 1068,
		goods_id = 307068,
		need_goods = 110127,
		need_num = 35,
		money_type = 1,
		price = 20000,
		limit_lv = 1,
		next_id = 307069
	};

get(1069) ->
	#wing_conf{
		key = 1069,
		goods_id = 307069,
		need_goods = 110140,
		need_num = 600,
		money_type = 2,
		price = 30,
		limit_lv = 1,
		next_id = 307070
	};

get(1070) ->
	#wing_conf{
		key = 1070,
		goods_id = 307070,
		need_goods = 110127,
		need_num = 40,
		money_type = 1,
		price = 20000,
		limit_lv = 1,
		next_id = 307071
	};

get(1071) ->
	#wing_conf{
		key = 1071,
		goods_id = 307071,
		need_goods = 110127,
		need_num = 40,
		money_type = 1,
		price = 20000,
		limit_lv = 1,
		next_id = 307072
	};

get(1072) ->
	#wing_conf{
		key = 1072,
		goods_id = 307072,
		need_goods = 110127,
		need_num = 40,
		money_type = 1,
		price = 20000,
		limit_lv = 1,
		next_id = 307073
	};

get(1073) ->
	#wing_conf{
		key = 1073,
		goods_id = 307073,
		need_goods = 110127,
		need_num = 40,
		money_type = 1,
		price = 20000,
		limit_lv = 1,
		next_id = 307074
	};

get(1074) ->
	#wing_conf{
		key = 1074,
		goods_id = 307074,
		need_goods = 110127,
		need_num = 40,
		money_type = 1,
		price = 20000,
		limit_lv = 1,
		next_id = 307075
	};

get(1075) ->
	#wing_conf{
		key = 1075,
		goods_id = 307075,
		need_goods = 110127,
		need_num = 40,
		money_type = 1,
		price = 20000,
		limit_lv = 1,
		next_id = 307076
	};

get(1076) ->
	#wing_conf{
		key = 1076,
		goods_id = 307076,
		need_goods = 110127,
		need_num = 40,
		money_type = 1,
		price = 20000,
		limit_lv = 1,
		next_id = 307077
	};

get(1077) ->
	#wing_conf{
		key = 1077,
		goods_id = 307077,
		need_goods = 110127,
		need_num = 40,
		money_type = 1,
		price = 20000,
		limit_lv = 1,
		next_id = 307078
	};

get(1078) ->
	#wing_conf{
		key = 1078,
		goods_id = 307078,
		need_goods = 110127,
		need_num = 40,
		money_type = 1,
		price = 20000,
		limit_lv = 1,
		next_id = 307079
	};

get(1079) ->
	#wing_conf{
		key = 1079,
		goods_id = 307079,
		need_goods = 110140,
		need_num = 1000,
		money_type = 2,
		price = 30,
		limit_lv = 1,
		next_id = 307080
	};

get(1080) ->
	#wing_conf{
		key = 1080,
		goods_id = 307080,
		need_goods = 110127,
		need_num = 45,
		money_type = 1,
		price = 20000,
		limit_lv = 1,
		next_id = 307081
	};

get(1081) ->
	#wing_conf{
		key = 1081,
		goods_id = 307081,
		need_goods = 110127,
		need_num = 45,
		money_type = 1,
		price = 20000,
		limit_lv = 1,
		next_id = 307082
	};

get(1082) ->
	#wing_conf{
		key = 1082,
		goods_id = 307082,
		need_goods = 110127,
		need_num = 45,
		money_type = 1,
		price = 20000,
		limit_lv = 1,
		next_id = 307083
	};

get(1083) ->
	#wing_conf{
		key = 1083,
		goods_id = 307083,
		need_goods = 110127,
		need_num = 45,
		money_type = 1,
		price = 20000,
		limit_lv = 1,
		next_id = 307084
	};

get(1084) ->
	#wing_conf{
		key = 1084,
		goods_id = 307084,
		need_goods = 110127,
		need_num = 45,
		money_type = 1,
		price = 20000,
		limit_lv = 1,
		next_id = 307085
	};

get(1085) ->
	#wing_conf{
		key = 1085,
		goods_id = 307085,
		need_goods = 110127,
		need_num = 45,
		money_type = 1,
		price = 20000,
		limit_lv = 1,
		next_id = 307086
	};

get(1086) ->
	#wing_conf{
		key = 1086,
		goods_id = 307086,
		need_goods = 110127,
		need_num = 45,
		money_type = 1,
		price = 20000,
		limit_lv = 1,
		next_id = 307087
	};

get(1087) ->
	#wing_conf{
		key = 1087,
		goods_id = 307087,
		need_goods = 110127,
		need_num = 45,
		money_type = 1,
		price = 20000,
		limit_lv = 1,
		next_id = 307088
	};

get(1088) ->
	#wing_conf{
		key = 1088,
		goods_id = 307088,
		need_goods = 110127,
		need_num = 45,
		money_type = 1,
		price = 20000,
		limit_lv = 1,
		next_id = 307089
	};

get(1089) ->
	#wing_conf{
		key = 1089,
		goods_id = 307089,
		need_goods = 110140,
		need_num = 1600,
		money_type = 2,
		price = 30,
		limit_lv = 1,
		next_id = 307090
	};

get(1090) ->
	#wing_conf{
		key = 1090,
		goods_id = 307090,
		need_goods = 110127,
		need_num = 50,
		money_type = 1,
		price = 20000,
		limit_lv = 1,
		next_id = 307091
	};

get(1091) ->
	#wing_conf{
		key = 1091,
		goods_id = 307091,
		need_goods = 110127,
		need_num = 50,
		money_type = 1,
		price = 20000,
		limit_lv = 1,
		next_id = 307092
	};

get(1092) ->
	#wing_conf{
		key = 1092,
		goods_id = 307092,
		need_goods = 110127,
		need_num = 50,
		money_type = 1,
		price = 20000,
		limit_lv = 1,
		next_id = 307093
	};

get(1093) ->
	#wing_conf{
		key = 1093,
		goods_id = 307093,
		need_goods = 110127,
		need_num = 50,
		money_type = 1,
		price = 20000,
		limit_lv = 1,
		next_id = 307094
	};

get(1094) ->
	#wing_conf{
		key = 1094,
		goods_id = 307094,
		need_goods = 110127,
		need_num = 50,
		money_type = 1,
		price = 20000,
		limit_lv = 1,
		next_id = 307095
	};

get(1095) ->
	#wing_conf{
		key = 1095,
		goods_id = 307095,
		need_goods = 110127,
		need_num = 50,
		money_type = 1,
		price = 20000,
		limit_lv = 1,
		next_id = 307096
	};

get(1096) ->
	#wing_conf{
		key = 1096,
		goods_id = 307096,
		need_goods = 110127,
		need_num = 50,
		money_type = 1,
		price = 20000,
		limit_lv = 1,
		next_id = 307097
	};

get(1097) ->
	#wing_conf{
		key = 1097,
		goods_id = 307097,
		need_goods = 110127,
		need_num = 50,
		money_type = 1,
		price = 20000,
		limit_lv = 1,
		next_id = 307098
	};

get(1098) ->
	#wing_conf{
		key = 1098,
		goods_id = 307098,
		need_goods = 110127,
		need_num = 50,
		money_type = 1,
		price = 20000,
		limit_lv = 1,
		next_id = 307099
	};

get(1099) ->
	#wing_conf{
		key = 1099,
		goods_id = 307099,
		need_goods = 110284,
		need_num = 1000,
		money_type = 2,
		price = 60,
		limit_lv = 1,
		next_id = 307100
	};

get(1100) ->
	#wing_conf{
		key = 1100,
		goods_id = 307100,
		need_goods = 110283,
		need_num = 60,
		money_type = 2,
		price = 10,
		limit_lv = 1,
		next_id = 307101
	};

get(1101) ->
	#wing_conf{
		key = 1101,
		goods_id = 307101,
		need_goods = 110283,
		need_num = 60,
		money_type = 2,
		price = 10,
		limit_lv = 1,
		next_id = 307102
	};

get(1102) ->
	#wing_conf{
		key = 1102,
		goods_id = 307102,
		need_goods = 110283,
		need_num = 60,
		money_type = 2,
		price = 10,
		limit_lv = 1,
		next_id = 307103
	};

get(1103) ->
	#wing_conf{
		key = 1103,
		goods_id = 307103,
		need_goods = 110283,
		need_num = 60,
		money_type = 2,
		price = 10,
		limit_lv = 1,
		next_id = 307104
	};

get(1104) ->
	#wing_conf{
		key = 1104,
		goods_id = 307104,
		need_goods = 110283,
		need_num = 60,
		money_type = 2,
		price = 10,
		limit_lv = 1,
		next_id = 307105
	};

get(1105) ->
	#wing_conf{
		key = 1105,
		goods_id = 307105,
		need_goods = 110283,
		need_num = 60,
		money_type = 2,
		price = 10,
		limit_lv = 1,
		next_id = 307106
	};

get(1106) ->
	#wing_conf{
		key = 1106,
		goods_id = 307106,
		need_goods = 110283,
		need_num = 60,
		money_type = 2,
		price = 10,
		limit_lv = 1,
		next_id = 307107
	};

get(1107) ->
	#wing_conf{
		key = 1107,
		goods_id = 307107,
		need_goods = 110283,
		need_num = 60,
		money_type = 2,
		price = 10,
		limit_lv = 1,
		next_id = 307108
	};

get(1108) ->
	#wing_conf{
		key = 1108,
		goods_id = 307108,
		need_goods = 110283,
		need_num = 60,
		money_type = 2,
		price = 10,
		limit_lv = 1,
		next_id = 307109
	};

get(1109) ->
	#wing_conf{
		key = 1109,
		goods_id = 307109,
		need_goods = 110284,
		need_num = 1200,
		money_type = 2,
		price = 60,
		limit_lv = 1,
		next_id = 307110
	};

get(1110) ->
	#wing_conf{
		key = 1110,
		goods_id = 307110,
		need_goods = 110283,
		need_num = 120,
		money_type = 2,
		price = 10,
		limit_lv = 1,
		next_id = 307111
	};

get(1111) ->
	#wing_conf{
		key = 1111,
		goods_id = 307111,
		need_goods = 110283,
		need_num = 120,
		money_type = 2,
		price = 10,
		limit_lv = 1,
		next_id = 307112
	};

get(1112) ->
	#wing_conf{
		key = 1112,
		goods_id = 307112,
		need_goods = 110283,
		need_num = 120,
		money_type = 2,
		price = 10,
		limit_lv = 1,
		next_id = 307113
	};

get(1113) ->
	#wing_conf{
		key = 1113,
		goods_id = 307113,
		need_goods = 110283,
		need_num = 120,
		money_type = 2,
		price = 10,
		limit_lv = 1,
		next_id = 307114
	};

get(1114) ->
	#wing_conf{
		key = 1114,
		goods_id = 307114,
		need_goods = 110283,
		need_num = 120,
		money_type = 2,
		price = 10,
		limit_lv = 1,
		next_id = 307115
	};

get(1115) ->
	#wing_conf{
		key = 1115,
		goods_id = 307115,
		need_goods = 110283,
		need_num = 120,
		money_type = 2,
		price = 10,
		limit_lv = 1,
		next_id = 307116
	};

get(1116) ->
	#wing_conf{
		key = 1116,
		goods_id = 307116,
		need_goods = 110283,
		need_num = 120,
		money_type = 2,
		price = 10,
		limit_lv = 1,
		next_id = 307117
	};

get(1117) ->
	#wing_conf{
		key = 1117,
		goods_id = 307117,
		need_goods = 110283,
		need_num = 120,
		money_type = 2,
		price = 10,
		limit_lv = 1,
		next_id = 307118
	};

get(1118) ->
	#wing_conf{
		key = 1118,
		goods_id = 307118,
		need_goods = 110283,
		need_num = 120,
		money_type = 2,
		price = 10,
		limit_lv = 1,
		next_id = 307119
	};

get(1119) ->
	#wing_conf{
		key = 1119,
		goods_id = 307119,
		need_goods = 110284,
		need_num = 1400,
		money_type = 2,
		price = 60,
		limit_lv = 1,
		next_id = 307120
	};

get(1120) ->
	#wing_conf{
		key = 1120,
		goods_id = 307120,
		need_goods = 110283,
		need_num = 240,
		money_type = 2,
		price = 10,
		limit_lv = 1,
		next_id = 307121
	};

get(1121) ->
	#wing_conf{
		key = 1121,
		goods_id = 307121,
		need_goods = 110283,
		need_num = 240,
		money_type = 2,
		price = 10,
		limit_lv = 1,
		next_id = 307122
	};

get(1122) ->
	#wing_conf{
		key = 1122,
		goods_id = 307122,
		need_goods = 110283,
		need_num = 240,
		money_type = 2,
		price = 10,
		limit_lv = 1,
		next_id = 307123
	};

get(1123) ->
	#wing_conf{
		key = 1123,
		goods_id = 307123,
		need_goods = 110283,
		need_num = 240,
		money_type = 2,
		price = 10,
		limit_lv = 1,
		next_id = 307124
	};

get(1124) ->
	#wing_conf{
		key = 1124,
		goods_id = 307124,
		need_goods = 110283,
		need_num = 240,
		money_type = 2,
		price = 10,
		limit_lv = 1,
		next_id = 307125
	};

get(1125) ->
	#wing_conf{
		key = 1125,
		goods_id = 307125,
		need_goods = 110283,
		need_num = 240,
		money_type = 2,
		price = 10,
		limit_lv = 1,
		next_id = 307126
	};

get(1126) ->
	#wing_conf{
		key = 1126,
		goods_id = 307126,
		need_goods = 110283,
		need_num = 240,
		money_type = 2,
		price = 10,
		limit_lv = 1,
		next_id = 307127
	};

get(1127) ->
	#wing_conf{
		key = 1127,
		goods_id = 307127,
		need_goods = 110283,
		need_num = 240,
		money_type = 2,
		price = 10,
		limit_lv = 1,
		next_id = 307128
	};

get(1128) ->
	#wing_conf{
		key = 1128,
		goods_id = 307128,
		need_goods = 110283,
		need_num = 240,
		money_type = 2,
		price = 10,
		limit_lv = 1,
		next_id = 307129
	};

get(1129) ->
	#wing_conf{
		key = 1129,
		goods_id = 307129,
		need_goods = 110284,
		need_num = 0,
		money_type = 2,
		price = 60,
		limit_lv = 1,
		next_id = 0
	};

get(2000) ->
	#wing_conf{
		key = 2000,
		goods_id = 307200,
		need_goods = 110127,
		need_num = 5,
		money_type = 1,
		price = 20000,
		limit_lv = 1,
		next_id = 307201
	};

get(2001) ->
	#wing_conf{
		key = 2001,
		goods_id = 307201,
		need_goods = 110127,
		need_num = 5,
		money_type = 1,
		price = 20000,
		limit_lv = 1,
		next_id = 307202
	};

get(2002) ->
	#wing_conf{
		key = 2002,
		goods_id = 307202,
		need_goods = 110127,
		need_num = 5,
		money_type = 1,
		price = 20000,
		limit_lv = 1,
		next_id = 307203
	};

get(2003) ->
	#wing_conf{
		key = 2003,
		goods_id = 307203,
		need_goods = 110127,
		need_num = 5,
		money_type = 1,
		price = 20000,
		limit_lv = 1,
		next_id = 307204
	};

get(2004) ->
	#wing_conf{
		key = 2004,
		goods_id = 307204,
		need_goods = 110127,
		need_num = 5,
		money_type = 1,
		price = 20000,
		limit_lv = 1,
		next_id = 307205
	};

get(2005) ->
	#wing_conf{
		key = 2005,
		goods_id = 307205,
		need_goods = 110127,
		need_num = 5,
		money_type = 1,
		price = 20000,
		limit_lv = 1,
		next_id = 307206
	};

get(2006) ->
	#wing_conf{
		key = 2006,
		goods_id = 307206,
		need_goods = 110127,
		need_num = 5,
		money_type = 1,
		price = 20000,
		limit_lv = 1,
		next_id = 307207
	};

get(2007) ->
	#wing_conf{
		key = 2007,
		goods_id = 307207,
		need_goods = 110127,
		need_num = 5,
		money_type = 1,
		price = 20000,
		limit_lv = 1,
		next_id = 307208
	};

get(2008) ->
	#wing_conf{
		key = 2008,
		goods_id = 307208,
		need_goods = 110127,
		need_num = 5,
		money_type = 1,
		price = 20000,
		limit_lv = 1,
		next_id = 307209
	};

get(2009) ->
	#wing_conf{
		key = 2009,
		goods_id = 307209,
		need_goods = 110140,
		need_num = 10,
		money_type = 2,
		price = 30,
		limit_lv = 1,
		next_id = 307210
	};

get(2010) ->
	#wing_conf{
		key = 2010,
		goods_id = 307210,
		need_goods = 110127,
		need_num = 10,
		money_type = 1,
		price = 20000,
		limit_lv = 1,
		next_id = 307211
	};

get(2011) ->
	#wing_conf{
		key = 2011,
		goods_id = 307211,
		need_goods = 110127,
		need_num = 10,
		money_type = 1,
		price = 20000,
		limit_lv = 1,
		next_id = 307212
	};

get(2012) ->
	#wing_conf{
		key = 2012,
		goods_id = 307212,
		need_goods = 110127,
		need_num = 10,
		money_type = 1,
		price = 20000,
		limit_lv = 1,
		next_id = 307213
	};

get(2013) ->
	#wing_conf{
		key = 2013,
		goods_id = 307213,
		need_goods = 110127,
		need_num = 10,
		money_type = 1,
		price = 20000,
		limit_lv = 1,
		next_id = 307214
	};

get(2014) ->
	#wing_conf{
		key = 2014,
		goods_id = 307214,
		need_goods = 110127,
		need_num = 10,
		money_type = 1,
		price = 20000,
		limit_lv = 1,
		next_id = 307215
	};

get(2015) ->
	#wing_conf{
		key = 2015,
		goods_id = 307215,
		need_goods = 110127,
		need_num = 10,
		money_type = 1,
		price = 20000,
		limit_lv = 1,
		next_id = 307216
	};

get(2016) ->
	#wing_conf{
		key = 2016,
		goods_id = 307216,
		need_goods = 110127,
		need_num = 10,
		money_type = 1,
		price = 20000,
		limit_lv = 1,
		next_id = 307217
	};

get(2017) ->
	#wing_conf{
		key = 2017,
		goods_id = 307217,
		need_goods = 110127,
		need_num = 10,
		money_type = 1,
		price = 20000,
		limit_lv = 1,
		next_id = 307218
	};

get(2018) ->
	#wing_conf{
		key = 2018,
		goods_id = 307218,
		need_goods = 110127,
		need_num = 10,
		money_type = 1,
		price = 20000,
		limit_lv = 1,
		next_id = 307219
	};

get(2019) ->
	#wing_conf{
		key = 2019,
		goods_id = 307219,
		need_goods = 110140,
		need_num = 20,
		money_type = 2,
		price = 30,
		limit_lv = 1,
		next_id = 307220
	};

get(2020) ->
	#wing_conf{
		key = 2020,
		goods_id = 307220,
		need_goods = 110127,
		need_num = 15,
		money_type = 1,
		price = 20000,
		limit_lv = 1,
		next_id = 307221
	};

get(2021) ->
	#wing_conf{
		key = 2021,
		goods_id = 307221,
		need_goods = 110127,
		need_num = 15,
		money_type = 1,
		price = 20000,
		limit_lv = 1,
		next_id = 307222
	};

get(2022) ->
	#wing_conf{
		key = 2022,
		goods_id = 307222,
		need_goods = 110127,
		need_num = 15,
		money_type = 1,
		price = 20000,
		limit_lv = 1,
		next_id = 307223
	};

get(2023) ->
	#wing_conf{
		key = 2023,
		goods_id = 307223,
		need_goods = 110127,
		need_num = 15,
		money_type = 1,
		price = 20000,
		limit_lv = 1,
		next_id = 307224
	};

get(2024) ->
	#wing_conf{
		key = 2024,
		goods_id = 307224,
		need_goods = 110127,
		need_num = 15,
		money_type = 1,
		price = 20000,
		limit_lv = 1,
		next_id = 307225
	};

get(2025) ->
	#wing_conf{
		key = 2025,
		goods_id = 307225,
		need_goods = 110127,
		need_num = 15,
		money_type = 1,
		price = 20000,
		limit_lv = 1,
		next_id = 307226
	};

get(2026) ->
	#wing_conf{
		key = 2026,
		goods_id = 307226,
		need_goods = 110127,
		need_num = 15,
		money_type = 1,
		price = 20000,
		limit_lv = 1,
		next_id = 307227
	};

get(2027) ->
	#wing_conf{
		key = 2027,
		goods_id = 307227,
		need_goods = 110127,
		need_num = 15,
		money_type = 1,
		price = 20000,
		limit_lv = 1,
		next_id = 307228
	};

get(2028) ->
	#wing_conf{
		key = 2028,
		goods_id = 307228,
		need_goods = 110127,
		need_num = 15,
		money_type = 1,
		price = 20000,
		limit_lv = 1,
		next_id = 307229
	};

get(2029) ->
	#wing_conf{
		key = 2029,
		goods_id = 307229,
		need_goods = 110140,
		need_num = 40,
		money_type = 2,
		price = 30,
		limit_lv = 1,
		next_id = 307230
	};

get(2030) ->
	#wing_conf{
		key = 2030,
		goods_id = 307230,
		need_goods = 110127,
		need_num = 20,
		money_type = 1,
		price = 20000,
		limit_lv = 1,
		next_id = 307231
	};

get(2031) ->
	#wing_conf{
		key = 2031,
		goods_id = 307231,
		need_goods = 110127,
		need_num = 20,
		money_type = 1,
		price = 20000,
		limit_lv = 1,
		next_id = 307232
	};

get(2032) ->
	#wing_conf{
		key = 2032,
		goods_id = 307232,
		need_goods = 110127,
		need_num = 20,
		money_type = 1,
		price = 20000,
		limit_lv = 1,
		next_id = 307233
	};

get(2033) ->
	#wing_conf{
		key = 2033,
		goods_id = 307233,
		need_goods = 110127,
		need_num = 20,
		money_type = 1,
		price = 20000,
		limit_lv = 1,
		next_id = 307234
	};

get(2034) ->
	#wing_conf{
		key = 2034,
		goods_id = 307234,
		need_goods = 110127,
		need_num = 20,
		money_type = 1,
		price = 20000,
		limit_lv = 1,
		next_id = 307235
	};

get(2035) ->
	#wing_conf{
		key = 2035,
		goods_id = 307235,
		need_goods = 110127,
		need_num = 20,
		money_type = 1,
		price = 20000,
		limit_lv = 1,
		next_id = 307236
	};

get(2036) ->
	#wing_conf{
		key = 2036,
		goods_id = 307236,
		need_goods = 110127,
		need_num = 20,
		money_type = 1,
		price = 20000,
		limit_lv = 1,
		next_id = 307237
	};

get(2037) ->
	#wing_conf{
		key = 2037,
		goods_id = 307237,
		need_goods = 110127,
		need_num = 20,
		money_type = 1,
		price = 20000,
		limit_lv = 1,
		next_id = 307238
	};

get(2038) ->
	#wing_conf{
		key = 2038,
		goods_id = 307238,
		need_goods = 110127,
		need_num = 20,
		money_type = 1,
		price = 20000,
		limit_lv = 1,
		next_id = 307239
	};

get(2039) ->
	#wing_conf{
		key = 2039,
		goods_id = 307239,
		need_goods = 110140,
		need_num = 100,
		money_type = 2,
		price = 30,
		limit_lv = 1,
		next_id = 307240
	};

get(2040) ->
	#wing_conf{
		key = 2040,
		goods_id = 307240,
		need_goods = 110127,
		need_num = 25,
		money_type = 1,
		price = 20000,
		limit_lv = 1,
		next_id = 307241
	};

get(2041) ->
	#wing_conf{
		key = 2041,
		goods_id = 307241,
		need_goods = 110127,
		need_num = 25,
		money_type = 1,
		price = 20000,
		limit_lv = 1,
		next_id = 307242
	};

get(2042) ->
	#wing_conf{
		key = 2042,
		goods_id = 307242,
		need_goods = 110127,
		need_num = 25,
		money_type = 1,
		price = 20000,
		limit_lv = 1,
		next_id = 307243
	};

get(2043) ->
	#wing_conf{
		key = 2043,
		goods_id = 307243,
		need_goods = 110127,
		need_num = 25,
		money_type = 1,
		price = 20000,
		limit_lv = 1,
		next_id = 307244
	};

get(2044) ->
	#wing_conf{
		key = 2044,
		goods_id = 307244,
		need_goods = 110127,
		need_num = 25,
		money_type = 1,
		price = 20000,
		limit_lv = 1,
		next_id = 307245
	};

get(2045) ->
	#wing_conf{
		key = 2045,
		goods_id = 307245,
		need_goods = 110127,
		need_num = 25,
		money_type = 1,
		price = 20000,
		limit_lv = 1,
		next_id = 307246
	};

get(2046) ->
	#wing_conf{
		key = 2046,
		goods_id = 307246,
		need_goods = 110127,
		need_num = 25,
		money_type = 1,
		price = 20000,
		limit_lv = 1,
		next_id = 307247
	};

get(2047) ->
	#wing_conf{
		key = 2047,
		goods_id = 307247,
		need_goods = 110127,
		need_num = 25,
		money_type = 1,
		price = 20000,
		limit_lv = 1,
		next_id = 307248
	};

get(2048) ->
	#wing_conf{
		key = 2048,
		goods_id = 307248,
		need_goods = 110127,
		need_num = 25,
		money_type = 1,
		price = 20000,
		limit_lv = 1,
		next_id = 307249
	};

get(2049) ->
	#wing_conf{
		key = 2049,
		goods_id = 307249,
		need_goods = 110140,
		need_num = 200,
		money_type = 2,
		price = 30,
		limit_lv = 1,
		next_id = 307250
	};

get(2050) ->
	#wing_conf{
		key = 2050,
		goods_id = 307250,
		need_goods = 110127,
		need_num = 30,
		money_type = 1,
		price = 20000,
		limit_lv = 1,
		next_id = 307251
	};

get(2051) ->
	#wing_conf{
		key = 2051,
		goods_id = 307251,
		need_goods = 110127,
		need_num = 30,
		money_type = 1,
		price = 20000,
		limit_lv = 1,
		next_id = 307252
	};

get(2052) ->
	#wing_conf{
		key = 2052,
		goods_id = 307252,
		need_goods = 110127,
		need_num = 30,
		money_type = 1,
		price = 20000,
		limit_lv = 1,
		next_id = 307253
	};

get(2053) ->
	#wing_conf{
		key = 2053,
		goods_id = 307253,
		need_goods = 110127,
		need_num = 30,
		money_type = 1,
		price = 20000,
		limit_lv = 1,
		next_id = 307254
	};

get(2054) ->
	#wing_conf{
		key = 2054,
		goods_id = 307254,
		need_goods = 110127,
		need_num = 30,
		money_type = 1,
		price = 20000,
		limit_lv = 1,
		next_id = 307255
	};

get(2055) ->
	#wing_conf{
		key = 2055,
		goods_id = 307255,
		need_goods = 110127,
		need_num = 30,
		money_type = 1,
		price = 20000,
		limit_lv = 1,
		next_id = 307256
	};

get(2056) ->
	#wing_conf{
		key = 2056,
		goods_id = 307256,
		need_goods = 110127,
		need_num = 30,
		money_type = 1,
		price = 20000,
		limit_lv = 1,
		next_id = 307257
	};

get(2057) ->
	#wing_conf{
		key = 2057,
		goods_id = 307257,
		need_goods = 110127,
		need_num = 30,
		money_type = 1,
		price = 20000,
		limit_lv = 1,
		next_id = 307258
	};

get(2058) ->
	#wing_conf{
		key = 2058,
		goods_id = 307258,
		need_goods = 110127,
		need_num = 30,
		money_type = 1,
		price = 20000,
		limit_lv = 1,
		next_id = 307259
	};

get(2059) ->
	#wing_conf{
		key = 2059,
		goods_id = 307259,
		need_goods = 110140,
		need_num = 400,
		money_type = 2,
		price = 30,
		limit_lv = 1,
		next_id = 307260
	};

get(2060) ->
	#wing_conf{
		key = 2060,
		goods_id = 307260,
		need_goods = 110127,
		need_num = 35,
		money_type = 1,
		price = 20000,
		limit_lv = 1,
		next_id = 307261
	};

get(2061) ->
	#wing_conf{
		key = 2061,
		goods_id = 307261,
		need_goods = 110127,
		need_num = 35,
		money_type = 1,
		price = 20000,
		limit_lv = 1,
		next_id = 307262
	};

get(2062) ->
	#wing_conf{
		key = 2062,
		goods_id = 307262,
		need_goods = 110127,
		need_num = 35,
		money_type = 1,
		price = 20000,
		limit_lv = 1,
		next_id = 307263
	};

get(2063) ->
	#wing_conf{
		key = 2063,
		goods_id = 307263,
		need_goods = 110127,
		need_num = 35,
		money_type = 1,
		price = 20000,
		limit_lv = 1,
		next_id = 307264
	};

get(2064) ->
	#wing_conf{
		key = 2064,
		goods_id = 307264,
		need_goods = 110127,
		need_num = 35,
		money_type = 1,
		price = 20000,
		limit_lv = 1,
		next_id = 307265
	};

get(2065) ->
	#wing_conf{
		key = 2065,
		goods_id = 307265,
		need_goods = 110127,
		need_num = 35,
		money_type = 1,
		price = 20000,
		limit_lv = 1,
		next_id = 307266
	};

get(2066) ->
	#wing_conf{
		key = 2066,
		goods_id = 307266,
		need_goods = 110127,
		need_num = 35,
		money_type = 1,
		price = 20000,
		limit_lv = 1,
		next_id = 307267
	};

get(2067) ->
	#wing_conf{
		key = 2067,
		goods_id = 307267,
		need_goods = 110127,
		need_num = 35,
		money_type = 1,
		price = 20000,
		limit_lv = 1,
		next_id = 307268
	};

get(2068) ->
	#wing_conf{
		key = 2068,
		goods_id = 307268,
		need_goods = 110127,
		need_num = 35,
		money_type = 1,
		price = 20000,
		limit_lv = 1,
		next_id = 307269
	};

get(2069) ->
	#wing_conf{
		key = 2069,
		goods_id = 307269,
		need_goods = 110140,
		need_num = 600,
		money_type = 2,
		price = 30,
		limit_lv = 1,
		next_id = 307270
	};

get(2070) ->
	#wing_conf{
		key = 2070,
		goods_id = 307270,
		need_goods = 110127,
		need_num = 40,
		money_type = 1,
		price = 20000,
		limit_lv = 1,
		next_id = 307271
	};

get(2071) ->
	#wing_conf{
		key = 2071,
		goods_id = 307271,
		need_goods = 110127,
		need_num = 40,
		money_type = 1,
		price = 20000,
		limit_lv = 1,
		next_id = 307272
	};

get(2072) ->
	#wing_conf{
		key = 2072,
		goods_id = 307272,
		need_goods = 110127,
		need_num = 40,
		money_type = 1,
		price = 20000,
		limit_lv = 1,
		next_id = 307273
	};

get(2073) ->
	#wing_conf{
		key = 2073,
		goods_id = 307273,
		need_goods = 110127,
		need_num = 40,
		money_type = 1,
		price = 20000,
		limit_lv = 1,
		next_id = 307274
	};

get(2074) ->
	#wing_conf{
		key = 2074,
		goods_id = 307274,
		need_goods = 110127,
		need_num = 40,
		money_type = 1,
		price = 20000,
		limit_lv = 1,
		next_id = 307275
	};

get(2075) ->
	#wing_conf{
		key = 2075,
		goods_id = 307275,
		need_goods = 110127,
		need_num = 40,
		money_type = 1,
		price = 20000,
		limit_lv = 1,
		next_id = 307276
	};

get(2076) ->
	#wing_conf{
		key = 2076,
		goods_id = 307276,
		need_goods = 110127,
		need_num = 40,
		money_type = 1,
		price = 20000,
		limit_lv = 1,
		next_id = 307277
	};

get(2077) ->
	#wing_conf{
		key = 2077,
		goods_id = 307277,
		need_goods = 110127,
		need_num = 40,
		money_type = 1,
		price = 20000,
		limit_lv = 1,
		next_id = 307278
	};

get(2078) ->
	#wing_conf{
		key = 2078,
		goods_id = 307278,
		need_goods = 110127,
		need_num = 40,
		money_type = 1,
		price = 20000,
		limit_lv = 1,
		next_id = 307279
	};

get(2079) ->
	#wing_conf{
		key = 2079,
		goods_id = 307279,
		need_goods = 110140,
		need_num = 1000,
		money_type = 2,
		price = 30,
		limit_lv = 1,
		next_id = 307280
	};

get(2080) ->
	#wing_conf{
		key = 2080,
		goods_id = 307280,
		need_goods = 110127,
		need_num = 45,
		money_type = 1,
		price = 20000,
		limit_lv = 1,
		next_id = 307281
	};

get(2081) ->
	#wing_conf{
		key = 2081,
		goods_id = 307281,
		need_goods = 110127,
		need_num = 45,
		money_type = 1,
		price = 20000,
		limit_lv = 1,
		next_id = 307282
	};

get(2082) ->
	#wing_conf{
		key = 2082,
		goods_id = 307282,
		need_goods = 110127,
		need_num = 45,
		money_type = 1,
		price = 20000,
		limit_lv = 1,
		next_id = 307283
	};

get(2083) ->
	#wing_conf{
		key = 2083,
		goods_id = 307283,
		need_goods = 110127,
		need_num = 45,
		money_type = 1,
		price = 20000,
		limit_lv = 1,
		next_id = 307284
	};

get(2084) ->
	#wing_conf{
		key = 2084,
		goods_id = 307284,
		need_goods = 110127,
		need_num = 45,
		money_type = 1,
		price = 20000,
		limit_lv = 1,
		next_id = 307285
	};

get(2085) ->
	#wing_conf{
		key = 2085,
		goods_id = 307285,
		need_goods = 110127,
		need_num = 45,
		money_type = 1,
		price = 20000,
		limit_lv = 1,
		next_id = 307286
	};

get(2086) ->
	#wing_conf{
		key = 2086,
		goods_id = 307286,
		need_goods = 110127,
		need_num = 45,
		money_type = 1,
		price = 20000,
		limit_lv = 1,
		next_id = 307287
	};

get(2087) ->
	#wing_conf{
		key = 2087,
		goods_id = 307287,
		need_goods = 110127,
		need_num = 45,
		money_type = 1,
		price = 20000,
		limit_lv = 1,
		next_id = 307288
	};

get(2088) ->
	#wing_conf{
		key = 2088,
		goods_id = 307288,
		need_goods = 110127,
		need_num = 45,
		money_type = 1,
		price = 20000,
		limit_lv = 1,
		next_id = 307289
	};

get(2089) ->
	#wing_conf{
		key = 2089,
		goods_id = 307289,
		need_goods = 110140,
		need_num = 1600,
		money_type = 2,
		price = 30,
		limit_lv = 1,
		next_id = 307290
	};

get(2090) ->
	#wing_conf{
		key = 2090,
		goods_id = 307290,
		need_goods = 110127,
		need_num = 50,
		money_type = 1,
		price = 20000,
		limit_lv = 1,
		next_id = 307291
	};

get(2091) ->
	#wing_conf{
		key = 2091,
		goods_id = 307291,
		need_goods = 110127,
		need_num = 50,
		money_type = 1,
		price = 20000,
		limit_lv = 1,
		next_id = 307292
	};

get(2092) ->
	#wing_conf{
		key = 2092,
		goods_id = 307292,
		need_goods = 110127,
		need_num = 50,
		money_type = 1,
		price = 20000,
		limit_lv = 1,
		next_id = 307293
	};

get(2093) ->
	#wing_conf{
		key = 2093,
		goods_id = 307293,
		need_goods = 110127,
		need_num = 50,
		money_type = 1,
		price = 20000,
		limit_lv = 1,
		next_id = 307294
	};

get(2094) ->
	#wing_conf{
		key = 2094,
		goods_id = 307294,
		need_goods = 110127,
		need_num = 50,
		money_type = 1,
		price = 20000,
		limit_lv = 1,
		next_id = 307295
	};

get(2095) ->
	#wing_conf{
		key = 2095,
		goods_id = 307295,
		need_goods = 110127,
		need_num = 50,
		money_type = 1,
		price = 20000,
		limit_lv = 1,
		next_id = 307296
	};

get(2096) ->
	#wing_conf{
		key = 2096,
		goods_id = 307296,
		need_goods = 110127,
		need_num = 50,
		money_type = 1,
		price = 20000,
		limit_lv = 1,
		next_id = 307297
	};

get(2097) ->
	#wing_conf{
		key = 2097,
		goods_id = 307297,
		need_goods = 110127,
		need_num = 50,
		money_type = 1,
		price = 20000,
		limit_lv = 1,
		next_id = 307298
	};

get(2098) ->
	#wing_conf{
		key = 2098,
		goods_id = 307298,
		need_goods = 110127,
		need_num = 50,
		money_type = 1,
		price = 20000,
		limit_lv = 1,
		next_id = 307299
	};

get(2099) ->
	#wing_conf{
		key = 2099,
		goods_id = 307299,
		need_goods = 110284,
		need_num = 1000,
		money_type = 2,
		price = 60,
		limit_lv = 1,
		next_id = 307300
	};

get(2100) ->
	#wing_conf{
		key = 2100,
		goods_id = 307300,
		need_goods = 110283,
		need_num = 60,
		money_type = 2,
		price = 10,
		limit_lv = 1,
		next_id = 307301
	};

get(2101) ->
	#wing_conf{
		key = 2101,
		goods_id = 307301,
		need_goods = 110283,
		need_num = 60,
		money_type = 2,
		price = 10,
		limit_lv = 1,
		next_id = 307302
	};

get(2102) ->
	#wing_conf{
		key = 2102,
		goods_id = 307302,
		need_goods = 110283,
		need_num = 60,
		money_type = 2,
		price = 10,
		limit_lv = 1,
		next_id = 307303
	};

get(2103) ->
	#wing_conf{
		key = 2103,
		goods_id = 307303,
		need_goods = 110283,
		need_num = 60,
		money_type = 2,
		price = 10,
		limit_lv = 1,
		next_id = 307304
	};

get(2104) ->
	#wing_conf{
		key = 2104,
		goods_id = 307304,
		need_goods = 110283,
		need_num = 60,
		money_type = 2,
		price = 10,
		limit_lv = 1,
		next_id = 307305
	};

get(2105) ->
	#wing_conf{
		key = 2105,
		goods_id = 307305,
		need_goods = 110283,
		need_num = 60,
		money_type = 2,
		price = 10,
		limit_lv = 1,
		next_id = 307306
	};

get(2106) ->
	#wing_conf{
		key = 2106,
		goods_id = 307306,
		need_goods = 110283,
		need_num = 60,
		money_type = 2,
		price = 10,
		limit_lv = 1,
		next_id = 307307
	};

get(2107) ->
	#wing_conf{
		key = 2107,
		goods_id = 307307,
		need_goods = 110283,
		need_num = 60,
		money_type = 2,
		price = 10,
		limit_lv = 1,
		next_id = 307308
	};

get(2108) ->
	#wing_conf{
		key = 2108,
		goods_id = 307308,
		need_goods = 110283,
		need_num = 60,
		money_type = 2,
		price = 10,
		limit_lv = 1,
		next_id = 307309
	};

get(2109) ->
	#wing_conf{
		key = 2109,
		goods_id = 307309,
		need_goods = 110284,
		need_num = 1200,
		money_type = 2,
		price = 60,
		limit_lv = 1,
		next_id = 307310
	};

get(2110) ->
	#wing_conf{
		key = 2110,
		goods_id = 307310,
		need_goods = 110283,
		need_num = 120,
		money_type = 2,
		price = 10,
		limit_lv = 1,
		next_id = 307311
	};

get(2111) ->
	#wing_conf{
		key = 2111,
		goods_id = 307311,
		need_goods = 110283,
		need_num = 120,
		money_type = 2,
		price = 10,
		limit_lv = 1,
		next_id = 307312
	};

get(2112) ->
	#wing_conf{
		key = 2112,
		goods_id = 307312,
		need_goods = 110283,
		need_num = 120,
		money_type = 2,
		price = 10,
		limit_lv = 1,
		next_id = 307313
	};

get(2113) ->
	#wing_conf{
		key = 2113,
		goods_id = 307313,
		need_goods = 110283,
		need_num = 120,
		money_type = 2,
		price = 10,
		limit_lv = 1,
		next_id = 307314
	};

get(2114) ->
	#wing_conf{
		key = 2114,
		goods_id = 307314,
		need_goods = 110283,
		need_num = 120,
		money_type = 2,
		price = 10,
		limit_lv = 1,
		next_id = 307315
	};

get(2115) ->
	#wing_conf{
		key = 2115,
		goods_id = 307315,
		need_goods = 110283,
		need_num = 120,
		money_type = 2,
		price = 10,
		limit_lv = 1,
		next_id = 307316
	};

get(2116) ->
	#wing_conf{
		key = 2116,
		goods_id = 307316,
		need_goods = 110283,
		need_num = 120,
		money_type = 2,
		price = 10,
		limit_lv = 1,
		next_id = 307317
	};

get(2117) ->
	#wing_conf{
		key = 2117,
		goods_id = 307317,
		need_goods = 110283,
		need_num = 120,
		money_type = 2,
		price = 10,
		limit_lv = 1,
		next_id = 307318
	};

get(2118) ->
	#wing_conf{
		key = 2118,
		goods_id = 307318,
		need_goods = 110283,
		need_num = 120,
		money_type = 2,
		price = 10,
		limit_lv = 1,
		next_id = 307319
	};

get(2119) ->
	#wing_conf{
		key = 2119,
		goods_id = 307319,
		need_goods = 110284,
		need_num = 1400,
		money_type = 2,
		price = 60,
		limit_lv = 1,
		next_id = 307320
	};

get(2120) ->
	#wing_conf{
		key = 2120,
		goods_id = 307320,
		need_goods = 110283,
		need_num = 240,
		money_type = 2,
		price = 10,
		limit_lv = 1,
		next_id = 307321
	};

get(2121) ->
	#wing_conf{
		key = 2121,
		goods_id = 307321,
		need_goods = 110283,
		need_num = 240,
		money_type = 2,
		price = 10,
		limit_lv = 1,
		next_id = 307322
	};

get(2122) ->
	#wing_conf{
		key = 2122,
		goods_id = 307322,
		need_goods = 110283,
		need_num = 240,
		money_type = 2,
		price = 10,
		limit_lv = 1,
		next_id = 307323
	};

get(2123) ->
	#wing_conf{
		key = 2123,
		goods_id = 307323,
		need_goods = 110283,
		need_num = 240,
		money_type = 2,
		price = 10,
		limit_lv = 1,
		next_id = 307324
	};

get(2124) ->
	#wing_conf{
		key = 2124,
		goods_id = 307324,
		need_goods = 110283,
		need_num = 240,
		money_type = 2,
		price = 10,
		limit_lv = 1,
		next_id = 307325
	};

get(2125) ->
	#wing_conf{
		key = 2125,
		goods_id = 307325,
		need_goods = 110283,
		need_num = 240,
		money_type = 2,
		price = 10,
		limit_lv = 1,
		next_id = 307326
	};

get(2126) ->
	#wing_conf{
		key = 2126,
		goods_id = 307326,
		need_goods = 110283,
		need_num = 240,
		money_type = 2,
		price = 10,
		limit_lv = 1,
		next_id = 307327
	};

get(2127) ->
	#wing_conf{
		key = 2127,
		goods_id = 307327,
		need_goods = 110283,
		need_num = 240,
		money_type = 2,
		price = 10,
		limit_lv = 1,
		next_id = 307328
	};

get(2128) ->
	#wing_conf{
		key = 2128,
		goods_id = 307328,
		need_goods = 110283,
		need_num = 240,
		money_type = 2,
		price = 10,
		limit_lv = 1,
		next_id = 307329
	};

get(2129) ->
	#wing_conf{
		key = 2129,
		goods_id = 307329,
		need_goods = 110284,
		need_num = 0,
		money_type = 2,
		price = 60,
		limit_lv = 1,
		next_id = 0
	};

get(3000) ->
	#wing_conf{
		key = 3000,
		goods_id = 307400,
		need_goods = 110127,
		need_num = 5,
		money_type = 1,
		price = 20000,
		limit_lv = 1,
		next_id = 307401
	};

get(3001) ->
	#wing_conf{
		key = 3001,
		goods_id = 307401,
		need_goods = 110127,
		need_num = 5,
		money_type = 1,
		price = 20000,
		limit_lv = 1,
		next_id = 307402
	};

get(3002) ->
	#wing_conf{
		key = 3002,
		goods_id = 307402,
		need_goods = 110127,
		need_num = 5,
		money_type = 1,
		price = 20000,
		limit_lv = 1,
		next_id = 307403
	};

get(3003) ->
	#wing_conf{
		key = 3003,
		goods_id = 307403,
		need_goods = 110127,
		need_num = 5,
		money_type = 1,
		price = 20000,
		limit_lv = 1,
		next_id = 307404
	};

get(3004) ->
	#wing_conf{
		key = 3004,
		goods_id = 307404,
		need_goods = 110127,
		need_num = 5,
		money_type = 1,
		price = 20000,
		limit_lv = 1,
		next_id = 307405
	};

get(3005) ->
	#wing_conf{
		key = 3005,
		goods_id = 307405,
		need_goods = 110127,
		need_num = 5,
		money_type = 1,
		price = 20000,
		limit_lv = 1,
		next_id = 307406
	};

get(3006) ->
	#wing_conf{
		key = 3006,
		goods_id = 307406,
		need_goods = 110127,
		need_num = 5,
		money_type = 1,
		price = 20000,
		limit_lv = 1,
		next_id = 307407
	};

get(3007) ->
	#wing_conf{
		key = 3007,
		goods_id = 307407,
		need_goods = 110127,
		need_num = 5,
		money_type = 1,
		price = 20000,
		limit_lv = 1,
		next_id = 307408
	};

get(3008) ->
	#wing_conf{
		key = 3008,
		goods_id = 307408,
		need_goods = 110127,
		need_num = 5,
		money_type = 1,
		price = 20000,
		limit_lv = 1,
		next_id = 307409
	};

get(3009) ->
	#wing_conf{
		key = 3009,
		goods_id = 307409,
		need_goods = 110140,
		need_num = 10,
		money_type = 2,
		price = 30,
		limit_lv = 1,
		next_id = 307410
	};

get(3010) ->
	#wing_conf{
		key = 3010,
		goods_id = 307410,
		need_goods = 110127,
		need_num = 10,
		money_type = 1,
		price = 20000,
		limit_lv = 1,
		next_id = 307411
	};

get(3011) ->
	#wing_conf{
		key = 3011,
		goods_id = 307411,
		need_goods = 110127,
		need_num = 10,
		money_type = 1,
		price = 20000,
		limit_lv = 1,
		next_id = 307412
	};

get(3012) ->
	#wing_conf{
		key = 3012,
		goods_id = 307412,
		need_goods = 110127,
		need_num = 10,
		money_type = 1,
		price = 20000,
		limit_lv = 1,
		next_id = 307413
	};

get(3013) ->
	#wing_conf{
		key = 3013,
		goods_id = 307413,
		need_goods = 110127,
		need_num = 10,
		money_type = 1,
		price = 20000,
		limit_lv = 1,
		next_id = 307414
	};

get(3014) ->
	#wing_conf{
		key = 3014,
		goods_id = 307414,
		need_goods = 110127,
		need_num = 10,
		money_type = 1,
		price = 20000,
		limit_lv = 1,
		next_id = 307415
	};

get(3015) ->
	#wing_conf{
		key = 3015,
		goods_id = 307415,
		need_goods = 110127,
		need_num = 10,
		money_type = 1,
		price = 20000,
		limit_lv = 1,
		next_id = 307416
	};

get(3016) ->
	#wing_conf{
		key = 3016,
		goods_id = 307416,
		need_goods = 110127,
		need_num = 10,
		money_type = 1,
		price = 20000,
		limit_lv = 1,
		next_id = 307417
	};

get(3017) ->
	#wing_conf{
		key = 3017,
		goods_id = 307417,
		need_goods = 110127,
		need_num = 10,
		money_type = 1,
		price = 20000,
		limit_lv = 1,
		next_id = 307418
	};

get(3018) ->
	#wing_conf{
		key = 3018,
		goods_id = 307418,
		need_goods = 110127,
		need_num = 10,
		money_type = 1,
		price = 20000,
		limit_lv = 1,
		next_id = 307419
	};

get(3019) ->
	#wing_conf{
		key = 3019,
		goods_id = 307419,
		need_goods = 110140,
		need_num = 20,
		money_type = 2,
		price = 30,
		limit_lv = 1,
		next_id = 307420
	};

get(3020) ->
	#wing_conf{
		key = 3020,
		goods_id = 307420,
		need_goods = 110127,
		need_num = 15,
		money_type = 1,
		price = 20000,
		limit_lv = 1,
		next_id = 307421
	};

get(3021) ->
	#wing_conf{
		key = 3021,
		goods_id = 307421,
		need_goods = 110127,
		need_num = 15,
		money_type = 1,
		price = 20000,
		limit_lv = 1,
		next_id = 307422
	};

get(3022) ->
	#wing_conf{
		key = 3022,
		goods_id = 307422,
		need_goods = 110127,
		need_num = 15,
		money_type = 1,
		price = 20000,
		limit_lv = 1,
		next_id = 307423
	};

get(3023) ->
	#wing_conf{
		key = 3023,
		goods_id = 307423,
		need_goods = 110127,
		need_num = 15,
		money_type = 1,
		price = 20000,
		limit_lv = 1,
		next_id = 307424
	};

get(3024) ->
	#wing_conf{
		key = 3024,
		goods_id = 307424,
		need_goods = 110127,
		need_num = 15,
		money_type = 1,
		price = 20000,
		limit_lv = 1,
		next_id = 307425
	};

get(3025) ->
	#wing_conf{
		key = 3025,
		goods_id = 307425,
		need_goods = 110127,
		need_num = 15,
		money_type = 1,
		price = 20000,
		limit_lv = 1,
		next_id = 307426
	};

get(3026) ->
	#wing_conf{
		key = 3026,
		goods_id = 307426,
		need_goods = 110127,
		need_num = 15,
		money_type = 1,
		price = 20000,
		limit_lv = 1,
		next_id = 307427
	};

get(3027) ->
	#wing_conf{
		key = 3027,
		goods_id = 307427,
		need_goods = 110127,
		need_num = 15,
		money_type = 1,
		price = 20000,
		limit_lv = 1,
		next_id = 307428
	};

get(3028) ->
	#wing_conf{
		key = 3028,
		goods_id = 307428,
		need_goods = 110127,
		need_num = 15,
		money_type = 1,
		price = 20000,
		limit_lv = 1,
		next_id = 307429
	};

get(3029) ->
	#wing_conf{
		key = 3029,
		goods_id = 307429,
		need_goods = 110140,
		need_num = 40,
		money_type = 2,
		price = 30,
		limit_lv = 1,
		next_id = 307430
	};

get(3030) ->
	#wing_conf{
		key = 3030,
		goods_id = 307430,
		need_goods = 110127,
		need_num = 20,
		money_type = 1,
		price = 20000,
		limit_lv = 1,
		next_id = 307431
	};

get(3031) ->
	#wing_conf{
		key = 3031,
		goods_id = 307431,
		need_goods = 110127,
		need_num = 20,
		money_type = 1,
		price = 20000,
		limit_lv = 1,
		next_id = 307432
	};

get(3032) ->
	#wing_conf{
		key = 3032,
		goods_id = 307432,
		need_goods = 110127,
		need_num = 20,
		money_type = 1,
		price = 20000,
		limit_lv = 1,
		next_id = 307433
	};

get(3033) ->
	#wing_conf{
		key = 3033,
		goods_id = 307433,
		need_goods = 110127,
		need_num = 20,
		money_type = 1,
		price = 20000,
		limit_lv = 1,
		next_id = 307434
	};

get(3034) ->
	#wing_conf{
		key = 3034,
		goods_id = 307434,
		need_goods = 110127,
		need_num = 20,
		money_type = 1,
		price = 20000,
		limit_lv = 1,
		next_id = 307435
	};

get(3035) ->
	#wing_conf{
		key = 3035,
		goods_id = 307435,
		need_goods = 110127,
		need_num = 20,
		money_type = 1,
		price = 20000,
		limit_lv = 1,
		next_id = 307436
	};

get(3036) ->
	#wing_conf{
		key = 3036,
		goods_id = 307436,
		need_goods = 110127,
		need_num = 20,
		money_type = 1,
		price = 20000,
		limit_lv = 1,
		next_id = 307437
	};

get(3037) ->
	#wing_conf{
		key = 3037,
		goods_id = 307437,
		need_goods = 110127,
		need_num = 20,
		money_type = 1,
		price = 20000,
		limit_lv = 1,
		next_id = 307438
	};

get(3038) ->
	#wing_conf{
		key = 3038,
		goods_id = 307438,
		need_goods = 110127,
		need_num = 20,
		money_type = 1,
		price = 20000,
		limit_lv = 1,
		next_id = 307439
	};

get(3039) ->
	#wing_conf{
		key = 3039,
		goods_id = 307439,
		need_goods = 110140,
		need_num = 100,
		money_type = 2,
		price = 30,
		limit_lv = 1,
		next_id = 307440
	};

get(3040) ->
	#wing_conf{
		key = 3040,
		goods_id = 307440,
		need_goods = 110127,
		need_num = 25,
		money_type = 1,
		price = 20000,
		limit_lv = 1,
		next_id = 307441
	};

get(3041) ->
	#wing_conf{
		key = 3041,
		goods_id = 307441,
		need_goods = 110127,
		need_num = 25,
		money_type = 1,
		price = 20000,
		limit_lv = 1,
		next_id = 307442
	};

get(3042) ->
	#wing_conf{
		key = 3042,
		goods_id = 307442,
		need_goods = 110127,
		need_num = 25,
		money_type = 1,
		price = 20000,
		limit_lv = 1,
		next_id = 307443
	};

get(3043) ->
	#wing_conf{
		key = 3043,
		goods_id = 307443,
		need_goods = 110127,
		need_num = 25,
		money_type = 1,
		price = 20000,
		limit_lv = 1,
		next_id = 307444
	};

get(3044) ->
	#wing_conf{
		key = 3044,
		goods_id = 307444,
		need_goods = 110127,
		need_num = 25,
		money_type = 1,
		price = 20000,
		limit_lv = 1,
		next_id = 307445
	};

get(3045) ->
	#wing_conf{
		key = 3045,
		goods_id = 307445,
		need_goods = 110127,
		need_num = 25,
		money_type = 1,
		price = 20000,
		limit_lv = 1,
		next_id = 307446
	};

get(3046) ->
	#wing_conf{
		key = 3046,
		goods_id = 307446,
		need_goods = 110127,
		need_num = 25,
		money_type = 1,
		price = 20000,
		limit_lv = 1,
		next_id = 307447
	};

get(3047) ->
	#wing_conf{
		key = 3047,
		goods_id = 307447,
		need_goods = 110127,
		need_num = 25,
		money_type = 1,
		price = 20000,
		limit_lv = 1,
		next_id = 307448
	};

get(3048) ->
	#wing_conf{
		key = 3048,
		goods_id = 307448,
		need_goods = 110127,
		need_num = 25,
		money_type = 1,
		price = 20000,
		limit_lv = 1,
		next_id = 307449
	};

get(3049) ->
	#wing_conf{
		key = 3049,
		goods_id = 307449,
		need_goods = 110140,
		need_num = 200,
		money_type = 2,
		price = 30,
		limit_lv = 1,
		next_id = 307450
	};

get(3050) ->
	#wing_conf{
		key = 3050,
		goods_id = 307450,
		need_goods = 110127,
		need_num = 30,
		money_type = 1,
		price = 20000,
		limit_lv = 1,
		next_id = 307451
	};

get(3051) ->
	#wing_conf{
		key = 3051,
		goods_id = 307451,
		need_goods = 110127,
		need_num = 30,
		money_type = 1,
		price = 20000,
		limit_lv = 1,
		next_id = 307452
	};

get(3052) ->
	#wing_conf{
		key = 3052,
		goods_id = 307452,
		need_goods = 110127,
		need_num = 30,
		money_type = 1,
		price = 20000,
		limit_lv = 1,
		next_id = 307453
	};

get(3053) ->
	#wing_conf{
		key = 3053,
		goods_id = 307453,
		need_goods = 110127,
		need_num = 30,
		money_type = 1,
		price = 20000,
		limit_lv = 1,
		next_id = 307454
	};

get(3054) ->
	#wing_conf{
		key = 3054,
		goods_id = 307454,
		need_goods = 110127,
		need_num = 30,
		money_type = 1,
		price = 20000,
		limit_lv = 1,
		next_id = 307455
	};

get(3055) ->
	#wing_conf{
		key = 3055,
		goods_id = 307455,
		need_goods = 110127,
		need_num = 30,
		money_type = 1,
		price = 20000,
		limit_lv = 1,
		next_id = 307456
	};

get(3056) ->
	#wing_conf{
		key = 3056,
		goods_id = 307456,
		need_goods = 110127,
		need_num = 30,
		money_type = 1,
		price = 20000,
		limit_lv = 1,
		next_id = 307457
	};

get(3057) ->
	#wing_conf{
		key = 3057,
		goods_id = 307457,
		need_goods = 110127,
		need_num = 30,
		money_type = 1,
		price = 20000,
		limit_lv = 1,
		next_id = 307458
	};

get(3058) ->
	#wing_conf{
		key = 3058,
		goods_id = 307458,
		need_goods = 110127,
		need_num = 30,
		money_type = 1,
		price = 20000,
		limit_lv = 1,
		next_id = 307459
	};

get(3059) ->
	#wing_conf{
		key = 3059,
		goods_id = 307459,
		need_goods = 110140,
		need_num = 400,
		money_type = 2,
		price = 30,
		limit_lv = 1,
		next_id = 307460
	};

get(3060) ->
	#wing_conf{
		key = 3060,
		goods_id = 307460,
		need_goods = 110127,
		need_num = 35,
		money_type = 1,
		price = 20000,
		limit_lv = 1,
		next_id = 307461
	};

get(3061) ->
	#wing_conf{
		key = 3061,
		goods_id = 307461,
		need_goods = 110127,
		need_num = 35,
		money_type = 1,
		price = 20000,
		limit_lv = 1,
		next_id = 307462
	};

get(3062) ->
	#wing_conf{
		key = 3062,
		goods_id = 307462,
		need_goods = 110127,
		need_num = 35,
		money_type = 1,
		price = 20000,
		limit_lv = 1,
		next_id = 307463
	};

get(3063) ->
	#wing_conf{
		key = 3063,
		goods_id = 307463,
		need_goods = 110127,
		need_num = 35,
		money_type = 1,
		price = 20000,
		limit_lv = 1,
		next_id = 307464
	};

get(3064) ->
	#wing_conf{
		key = 3064,
		goods_id = 307464,
		need_goods = 110127,
		need_num = 35,
		money_type = 1,
		price = 20000,
		limit_lv = 1,
		next_id = 307465
	};

get(3065) ->
	#wing_conf{
		key = 3065,
		goods_id = 307465,
		need_goods = 110127,
		need_num = 35,
		money_type = 1,
		price = 20000,
		limit_lv = 1,
		next_id = 307466
	};

get(3066) ->
	#wing_conf{
		key = 3066,
		goods_id = 307466,
		need_goods = 110127,
		need_num = 35,
		money_type = 1,
		price = 20000,
		limit_lv = 1,
		next_id = 307467
	};

get(3067) ->
	#wing_conf{
		key = 3067,
		goods_id = 307467,
		need_goods = 110127,
		need_num = 35,
		money_type = 1,
		price = 20000,
		limit_lv = 1,
		next_id = 307468
	};

get(3068) ->
	#wing_conf{
		key = 3068,
		goods_id = 307468,
		need_goods = 110127,
		need_num = 35,
		money_type = 1,
		price = 20000,
		limit_lv = 1,
		next_id = 307469
	};

get(3069) ->
	#wing_conf{
		key = 3069,
		goods_id = 307469,
		need_goods = 110140,
		need_num = 600,
		money_type = 2,
		price = 30,
		limit_lv = 1,
		next_id = 307470
	};

get(3070) ->
	#wing_conf{
		key = 3070,
		goods_id = 307470,
		need_goods = 110127,
		need_num = 40,
		money_type = 1,
		price = 20000,
		limit_lv = 1,
		next_id = 307471
	};

get(3071) ->
	#wing_conf{
		key = 3071,
		goods_id = 307471,
		need_goods = 110127,
		need_num = 40,
		money_type = 1,
		price = 20000,
		limit_lv = 1,
		next_id = 307472
	};

get(3072) ->
	#wing_conf{
		key = 3072,
		goods_id = 307472,
		need_goods = 110127,
		need_num = 40,
		money_type = 1,
		price = 20000,
		limit_lv = 1,
		next_id = 307473
	};

get(3073) ->
	#wing_conf{
		key = 3073,
		goods_id = 307473,
		need_goods = 110127,
		need_num = 40,
		money_type = 1,
		price = 20000,
		limit_lv = 1,
		next_id = 307474
	};

get(3074) ->
	#wing_conf{
		key = 3074,
		goods_id = 307474,
		need_goods = 110127,
		need_num = 40,
		money_type = 1,
		price = 20000,
		limit_lv = 1,
		next_id = 307475
	};

get(3075) ->
	#wing_conf{
		key = 3075,
		goods_id = 307475,
		need_goods = 110127,
		need_num = 40,
		money_type = 1,
		price = 20000,
		limit_lv = 1,
		next_id = 307476
	};

get(3076) ->
	#wing_conf{
		key = 3076,
		goods_id = 307476,
		need_goods = 110127,
		need_num = 40,
		money_type = 1,
		price = 20000,
		limit_lv = 1,
		next_id = 307477
	};

get(3077) ->
	#wing_conf{
		key = 3077,
		goods_id = 307477,
		need_goods = 110127,
		need_num = 40,
		money_type = 1,
		price = 20000,
		limit_lv = 1,
		next_id = 307478
	};

get(3078) ->
	#wing_conf{
		key = 3078,
		goods_id = 307478,
		need_goods = 110127,
		need_num = 40,
		money_type = 1,
		price = 20000,
		limit_lv = 1,
		next_id = 307479
	};

get(3079) ->
	#wing_conf{
		key = 3079,
		goods_id = 307479,
		need_goods = 110140,
		need_num = 1000,
		money_type = 2,
		price = 30,
		limit_lv = 1,
		next_id = 307480
	};

get(3080) ->
	#wing_conf{
		key = 3080,
		goods_id = 307480,
		need_goods = 110127,
		need_num = 45,
		money_type = 1,
		price = 20000,
		limit_lv = 1,
		next_id = 307481
	};

get(3081) ->
	#wing_conf{
		key = 3081,
		goods_id = 307481,
		need_goods = 110127,
		need_num = 45,
		money_type = 1,
		price = 20000,
		limit_lv = 1,
		next_id = 307482
	};

get(3082) ->
	#wing_conf{
		key = 3082,
		goods_id = 307482,
		need_goods = 110127,
		need_num = 45,
		money_type = 1,
		price = 20000,
		limit_lv = 1,
		next_id = 307483
	};

get(3083) ->
	#wing_conf{
		key = 3083,
		goods_id = 307483,
		need_goods = 110127,
		need_num = 45,
		money_type = 1,
		price = 20000,
		limit_lv = 1,
		next_id = 307484
	};

get(3084) ->
	#wing_conf{
		key = 3084,
		goods_id = 307484,
		need_goods = 110127,
		need_num = 45,
		money_type = 1,
		price = 20000,
		limit_lv = 1,
		next_id = 307485
	};

get(3085) ->
	#wing_conf{
		key = 3085,
		goods_id = 307485,
		need_goods = 110127,
		need_num = 45,
		money_type = 1,
		price = 20000,
		limit_lv = 1,
		next_id = 307486
	};

get(3086) ->
	#wing_conf{
		key = 3086,
		goods_id = 307486,
		need_goods = 110127,
		need_num = 45,
		money_type = 1,
		price = 20000,
		limit_lv = 1,
		next_id = 307487
	};

get(3087) ->
	#wing_conf{
		key = 3087,
		goods_id = 307487,
		need_goods = 110127,
		need_num = 45,
		money_type = 1,
		price = 20000,
		limit_lv = 1,
		next_id = 307488
	};

get(3088) ->
	#wing_conf{
		key = 3088,
		goods_id = 307488,
		need_goods = 110127,
		need_num = 45,
		money_type = 1,
		price = 20000,
		limit_lv = 1,
		next_id = 307489
	};

get(3089) ->
	#wing_conf{
		key = 3089,
		goods_id = 307489,
		need_goods = 110140,
		need_num = 1600,
		money_type = 2,
		price = 30,
		limit_lv = 1,
		next_id = 307490
	};

get(3090) ->
	#wing_conf{
		key = 3090,
		goods_id = 307490,
		need_goods = 110127,
		need_num = 50,
		money_type = 1,
		price = 20000,
		limit_lv = 1,
		next_id = 307491
	};

get(3091) ->
	#wing_conf{
		key = 3091,
		goods_id = 307491,
		need_goods = 110127,
		need_num = 50,
		money_type = 1,
		price = 20000,
		limit_lv = 1,
		next_id = 307492
	};

get(3092) ->
	#wing_conf{
		key = 3092,
		goods_id = 307492,
		need_goods = 110127,
		need_num = 50,
		money_type = 1,
		price = 20000,
		limit_lv = 1,
		next_id = 307493
	};

get(3093) ->
	#wing_conf{
		key = 3093,
		goods_id = 307493,
		need_goods = 110127,
		need_num = 50,
		money_type = 1,
		price = 20000,
		limit_lv = 1,
		next_id = 307494
	};

get(3094) ->
	#wing_conf{
		key = 3094,
		goods_id = 307494,
		need_goods = 110127,
		need_num = 50,
		money_type = 1,
		price = 20000,
		limit_lv = 1,
		next_id = 307495
	};

get(3095) ->
	#wing_conf{
		key = 3095,
		goods_id = 307495,
		need_goods = 110127,
		need_num = 50,
		money_type = 1,
		price = 20000,
		limit_lv = 1,
		next_id = 307496
	};

get(3096) ->
	#wing_conf{
		key = 3096,
		goods_id = 307496,
		need_goods = 110127,
		need_num = 50,
		money_type = 1,
		price = 20000,
		limit_lv = 1,
		next_id = 307497
	};

get(3097) ->
	#wing_conf{
		key = 3097,
		goods_id = 307497,
		need_goods = 110127,
		need_num = 50,
		money_type = 1,
		price = 20000,
		limit_lv = 1,
		next_id = 307498
	};

get(3098) ->
	#wing_conf{
		key = 3098,
		goods_id = 307498,
		need_goods = 110127,
		need_num = 50,
		money_type = 1,
		price = 20000,
		limit_lv = 1,
		next_id = 307499
	};

get(3099) ->
	#wing_conf{
		key = 3099,
		goods_id = 307499,
		need_goods = 110284,
		need_num = 1000,
		money_type = 2,
		price = 60,
		limit_lv = 1,
		next_id = 307500
	};

get(3100) ->
	#wing_conf{
		key = 3100,
		goods_id = 307500,
		need_goods = 110283,
		need_num = 60,
		money_type = 2,
		price = 10,
		limit_lv = 1,
		next_id = 307501
	};

get(3101) ->
	#wing_conf{
		key = 3101,
		goods_id = 307501,
		need_goods = 110283,
		need_num = 60,
		money_type = 2,
		price = 10,
		limit_lv = 1,
		next_id = 307502
	};

get(3102) ->
	#wing_conf{
		key = 3102,
		goods_id = 307502,
		need_goods = 110283,
		need_num = 60,
		money_type = 2,
		price = 10,
		limit_lv = 1,
		next_id = 307503
	};

get(3103) ->
	#wing_conf{
		key = 3103,
		goods_id = 307503,
		need_goods = 110283,
		need_num = 60,
		money_type = 2,
		price = 10,
		limit_lv = 1,
		next_id = 307504
	};

get(3104) ->
	#wing_conf{
		key = 3104,
		goods_id = 307504,
		need_goods = 110283,
		need_num = 60,
		money_type = 2,
		price = 10,
		limit_lv = 1,
		next_id = 307505
	};

get(3105) ->
	#wing_conf{
		key = 3105,
		goods_id = 307505,
		need_goods = 110283,
		need_num = 60,
		money_type = 2,
		price = 10,
		limit_lv = 1,
		next_id = 307506
	};

get(3106) ->
	#wing_conf{
		key = 3106,
		goods_id = 307506,
		need_goods = 110283,
		need_num = 60,
		money_type = 2,
		price = 10,
		limit_lv = 1,
		next_id = 307507
	};

get(3107) ->
	#wing_conf{
		key = 3107,
		goods_id = 307507,
		need_goods = 110283,
		need_num = 60,
		money_type = 2,
		price = 10,
		limit_lv = 1,
		next_id = 307508
	};

get(3108) ->
	#wing_conf{
		key = 3108,
		goods_id = 307508,
		need_goods = 110283,
		need_num = 60,
		money_type = 2,
		price = 10,
		limit_lv = 1,
		next_id = 307509
	};

get(3109) ->
	#wing_conf{
		key = 3109,
		goods_id = 307509,
		need_goods = 110284,
		need_num = 1200,
		money_type = 2,
		price = 60,
		limit_lv = 1,
		next_id = 307510
	};

get(3110) ->
	#wing_conf{
		key = 3110,
		goods_id = 307510,
		need_goods = 110283,
		need_num = 120,
		money_type = 2,
		price = 10,
		limit_lv = 1,
		next_id = 307511
	};

get(3111) ->
	#wing_conf{
		key = 3111,
		goods_id = 307511,
		need_goods = 110283,
		need_num = 120,
		money_type = 2,
		price = 10,
		limit_lv = 1,
		next_id = 307512
	};

get(3112) ->
	#wing_conf{
		key = 3112,
		goods_id = 307512,
		need_goods = 110283,
		need_num = 120,
		money_type = 2,
		price = 10,
		limit_lv = 1,
		next_id = 307513
	};

get(3113) ->
	#wing_conf{
		key = 3113,
		goods_id = 307513,
		need_goods = 110283,
		need_num = 120,
		money_type = 2,
		price = 10,
		limit_lv = 1,
		next_id = 307514
	};

get(3114) ->
	#wing_conf{
		key = 3114,
		goods_id = 307514,
		need_goods = 110283,
		need_num = 120,
		money_type = 2,
		price = 10,
		limit_lv = 1,
		next_id = 307515
	};

get(3115) ->
	#wing_conf{
		key = 3115,
		goods_id = 307515,
		need_goods = 110283,
		need_num = 120,
		money_type = 2,
		price = 10,
		limit_lv = 1,
		next_id = 307516
	};

get(3116) ->
	#wing_conf{
		key = 3116,
		goods_id = 307516,
		need_goods = 110283,
		need_num = 120,
		money_type = 2,
		price = 10,
		limit_lv = 1,
		next_id = 307517
	};

get(3117) ->
	#wing_conf{
		key = 3117,
		goods_id = 307517,
		need_goods = 110283,
		need_num = 120,
		money_type = 2,
		price = 10,
		limit_lv = 1,
		next_id = 307518
	};

get(3118) ->
	#wing_conf{
		key = 3118,
		goods_id = 307518,
		need_goods = 110283,
		need_num = 120,
		money_type = 2,
		price = 10,
		limit_lv = 1,
		next_id = 307519
	};

get(3119) ->
	#wing_conf{
		key = 3119,
		goods_id = 307519,
		need_goods = 110284,
		need_num = 1400,
		money_type = 2,
		price = 60,
		limit_lv = 1,
		next_id = 307520
	};

get(3120) ->
	#wing_conf{
		key = 3120,
		goods_id = 307520,
		need_goods = 110283,
		need_num = 240,
		money_type = 2,
		price = 10,
		limit_lv = 1,
		next_id = 307521
	};

get(3121) ->
	#wing_conf{
		key = 3121,
		goods_id = 307521,
		need_goods = 110283,
		need_num = 240,
		money_type = 2,
		price = 10,
		limit_lv = 1,
		next_id = 307522
	};

get(3122) ->
	#wing_conf{
		key = 3122,
		goods_id = 307522,
		need_goods = 110283,
		need_num = 240,
		money_type = 2,
		price = 10,
		limit_lv = 1,
		next_id = 307523
	};

get(3123) ->
	#wing_conf{
		key = 3123,
		goods_id = 307523,
		need_goods = 110283,
		need_num = 240,
		money_type = 2,
		price = 10,
		limit_lv = 1,
		next_id = 307524
	};

get(3124) ->
	#wing_conf{
		key = 3124,
		goods_id = 307524,
		need_goods = 110283,
		need_num = 240,
		money_type = 2,
		price = 10,
		limit_lv = 1,
		next_id = 307525
	};

get(3125) ->
	#wing_conf{
		key = 3125,
		goods_id = 307525,
		need_goods = 110283,
		need_num = 240,
		money_type = 2,
		price = 10,
		limit_lv = 1,
		next_id = 307526
	};

get(3126) ->
	#wing_conf{
		key = 3126,
		goods_id = 307526,
		need_goods = 110283,
		need_num = 240,
		money_type = 2,
		price = 10,
		limit_lv = 1,
		next_id = 307527
	};

get(3127) ->
	#wing_conf{
		key = 3127,
		goods_id = 307527,
		need_goods = 110283,
		need_num = 240,
		money_type = 2,
		price = 10,
		limit_lv = 1,
		next_id = 307528
	};

get(3128) ->
	#wing_conf{
		key = 3128,
		goods_id = 307528,
		need_goods = 110283,
		need_num = 240,
		money_type = 2,
		price = 10,
		limit_lv = 1,
		next_id = 307529
	};

get(3129) ->
	#wing_conf{
		key = 3129,
		goods_id = 307529,
		need_goods = 110284,
		need_num = 0,
		money_type = 2,
		price = 60,
		limit_lv = 1,
		next_id = 0
	};

get(4000) ->
	#wing_conf{
		key = 4000,
		goods_id = 309000,
		need_goods = 110127,
		need_num = 5,
		money_type = 1,
		price = 20000,
		limit_lv = 1,
		next_id = 309001
	};

get(4001) ->
	#wing_conf{
		key = 4001,
		goods_id = 309001,
		need_goods = 110127,
		need_num = 5,
		money_type = 1,
		price = 20000,
		limit_lv = 1,
		next_id = 309002
	};

get(4002) ->
	#wing_conf{
		key = 4002,
		goods_id = 309002,
		need_goods = 110127,
		need_num = 5,
		money_type = 1,
		price = 20000,
		limit_lv = 1,
		next_id = 309003
	};

get(4003) ->
	#wing_conf{
		key = 4003,
		goods_id = 309003,
		need_goods = 110127,
		need_num = 5,
		money_type = 1,
		price = 20000,
		limit_lv = 1,
		next_id = 309004
	};

get(4004) ->
	#wing_conf{
		key = 4004,
		goods_id = 309004,
		need_goods = 110127,
		need_num = 5,
		money_type = 1,
		price = 20000,
		limit_lv = 1,
		next_id = 309005
	};

get(4005) ->
	#wing_conf{
		key = 4005,
		goods_id = 309005,
		need_goods = 110127,
		need_num = 5,
		money_type = 1,
		price = 20000,
		limit_lv = 1,
		next_id = 309006
	};

get(4006) ->
	#wing_conf{
		key = 4006,
		goods_id = 309006,
		need_goods = 110127,
		need_num = 5,
		money_type = 1,
		price = 20000,
		limit_lv = 1,
		next_id = 309007
	};

get(4007) ->
	#wing_conf{
		key = 4007,
		goods_id = 309007,
		need_goods = 110127,
		need_num = 5,
		money_type = 1,
		price = 20000,
		limit_lv = 1,
		next_id = 309008
	};

get(4008) ->
	#wing_conf{
		key = 4008,
		goods_id = 309008,
		need_goods = 110127,
		need_num = 5,
		money_type = 1,
		price = 20000,
		limit_lv = 1,
		next_id = 309009
	};

get(4009) ->
	#wing_conf{
		key = 4009,
		goods_id = 309009,
		need_goods = 110140,
		need_num = 10,
		money_type = 2,
		price = 30,
		limit_lv = 1,
		next_id = 309010
	};

get(4010) ->
	#wing_conf{
		key = 4010,
		goods_id = 309010,
		need_goods = 110127,
		need_num = 5,
		money_type = 1,
		price = 20000,
		limit_lv = 1,
		next_id = 0
	};

get(5000) ->
	#wing_conf{
		key = 5000,
		goods_id = 309200,
		need_goods = 110127,
		need_num = 5,
		money_type = 1,
		price = 20000,
		limit_lv = 1,
		next_id = 309201
	};

get(5001) ->
	#wing_conf{
		key = 5001,
		goods_id = 309201,
		need_goods = 110127,
		need_num = 5,
		money_type = 1,
		price = 20000,
		limit_lv = 1,
		next_id = 309202
	};

get(5002) ->
	#wing_conf{
		key = 5002,
		goods_id = 309202,
		need_goods = 110127,
		need_num = 5,
		money_type = 1,
		price = 20000,
		limit_lv = 1,
		next_id = 309203
	};

get(5003) ->
	#wing_conf{
		key = 5003,
		goods_id = 309203,
		need_goods = 110127,
		need_num = 5,
		money_type = 1,
		price = 20000,
		limit_lv = 1,
		next_id = 309204
	};

get(5004) ->
	#wing_conf{
		key = 5004,
		goods_id = 309204,
		need_goods = 110127,
		need_num = 5,
		money_type = 1,
		price = 20000,
		limit_lv = 1,
		next_id = 309205
	};

get(5005) ->
	#wing_conf{
		key = 5005,
		goods_id = 309205,
		need_goods = 110127,
		need_num = 5,
		money_type = 1,
		price = 20000,
		limit_lv = 1,
		next_id = 309206
	};

get(5006) ->
	#wing_conf{
		key = 5006,
		goods_id = 309206,
		need_goods = 110127,
		need_num = 5,
		money_type = 1,
		price = 20000,
		limit_lv = 1,
		next_id = 309207
	};

get(5007) ->
	#wing_conf{
		key = 5007,
		goods_id = 309207,
		need_goods = 110127,
		need_num = 5,
		money_type = 1,
		price = 20000,
		limit_lv = 1,
		next_id = 309208
	};

get(5008) ->
	#wing_conf{
		key = 5008,
		goods_id = 309208,
		need_goods = 110127,
		need_num = 5,
		money_type = 1,
		price = 20000,
		limit_lv = 1,
		next_id = 309209
	};

get(5009) ->
	#wing_conf{
		key = 5009,
		goods_id = 309209,
		need_goods = 110140,
		need_num = 10,
		money_type = 2,
		price = 30,
		limit_lv = 1,
		next_id = 309210
	};

get(5010) ->
	#wing_conf{
		key = 5010,
		goods_id = 309210,
		need_goods = 110127,
		need_num = 5,
		money_type = 1,
		price = 20000,
		limit_lv = 1,
		next_id = 0
	};

get(6000) ->
	#wing_conf{
		key = 6000,
		goods_id = 309400,
		need_goods = 110127,
		need_num = 5,
		money_type = 1,
		price = 20000,
		limit_lv = 1,
		next_id = 309401
	};

get(6001) ->
	#wing_conf{
		key = 6001,
		goods_id = 309401,
		need_goods = 110127,
		need_num = 5,
		money_type = 1,
		price = 20000,
		limit_lv = 1,
		next_id = 309402
	};

get(6002) ->
	#wing_conf{
		key = 6002,
		goods_id = 309402,
		need_goods = 110127,
		need_num = 5,
		money_type = 1,
		price = 20000,
		limit_lv = 1,
		next_id = 309403
	};

get(6003) ->
	#wing_conf{
		key = 6003,
		goods_id = 309403,
		need_goods = 110127,
		need_num = 5,
		money_type = 1,
		price = 20000,
		limit_lv = 1,
		next_id = 309404
	};

get(6004) ->
	#wing_conf{
		key = 6004,
		goods_id = 309404,
		need_goods = 110127,
		need_num = 5,
		money_type = 1,
		price = 20000,
		limit_lv = 1,
		next_id = 309405
	};

get(6005) ->
	#wing_conf{
		key = 6005,
		goods_id = 309405,
		need_goods = 110127,
		need_num = 5,
		money_type = 1,
		price = 20000,
		limit_lv = 1,
		next_id = 309406
	};

get(6006) ->
	#wing_conf{
		key = 6006,
		goods_id = 309406,
		need_goods = 110127,
		need_num = 5,
		money_type = 1,
		price = 20000,
		limit_lv = 1,
		next_id = 309407
	};

get(6007) ->
	#wing_conf{
		key = 6007,
		goods_id = 309407,
		need_goods = 110127,
		need_num = 5,
		money_type = 1,
		price = 20000,
		limit_lv = 1,
		next_id = 309408
	};

get(6008) ->
	#wing_conf{
		key = 6008,
		goods_id = 309408,
		need_goods = 110127,
		need_num = 5,
		money_type = 1,
		price = 20000,
		limit_lv = 1,
		next_id = 309409
	};

get(6009) ->
	#wing_conf{
		key = 6009,
		goods_id = 309409,
		need_goods = 110140,
		need_num = 10,
		money_type = 2,
		price = 30,
		limit_lv = 1,
		next_id = 309410
	};

get(6010) ->
	#wing_conf{
		key = 6010,
		goods_id = 309410,
		need_goods = 110127,
		need_num = 5,
		money_type = 1,
		price = 20000,
		limit_lv = 1,
		next_id = 0
	};

get(_Key) ->
	?ERR("undefined key from wing_config ~p", [_Key]).