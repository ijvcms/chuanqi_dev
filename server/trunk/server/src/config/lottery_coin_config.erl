%%%-------------------------------------------------------------------
%%% @author zhengsiying
%%% @doc
%%%		自动生成文件，不要手动修改
%%% @end
%%% Created : 2016/10/12
%%%-------------------------------------------------------------------

-module(lottery_coin_config).

-include("common.hrl").
-include("config.hrl").

-compile([export_all]).

get_list_conf() ->
	[ lottery_coin_config:get(X) || X <- get_list() ].

get_list() ->
	[1, 2, 3, 4, 5, 6, 7, 8].

get(1) ->
	#lottery_coin_conf{
		id = 1,
		weights = 600,
		min_num = 0,
		day_num = 0,
		server_num = 0,
		goods = [{110196,1,100}],
		is_log = 1,
		name = xmerl_ucs:to_utf8("攻击印记*100"),
		notice_info = <<"">>,
		is_notice = 0
	};

get(2) ->
	#lottery_coin_conf{
		id = 2,
		weights = 300,
		min_num = 0,
		day_num = 0,
		server_num = 0,
		goods = [{110160,1,1}],
		is_log = 1,
		name = xmerl_ucs:to_utf8("铸魂精华*1"),
		notice_info = <<"">>,
		is_notice = 0
	};

get(3) ->
	#lottery_coin_conf{
		id = 3,
		weights = 375,
		min_num = 0,
		day_num = 0,
		server_num = 0,
		goods = [{110003,1,1}],
		is_log = 1,
		name = xmerl_ucs:to_utf8("洗炼石*1"),
		notice_info = <<"">>,
		is_notice = 0
	};

get(4) ->
	#lottery_coin_conf{
		id = 4,
		weights = 600,
		min_num = 0,
		day_num = 0,
		server_num = 0,
		goods = [{110007,1,1}],
		is_log = 0,
		name = xmerl_ucs:to_utf8("超级太阳水*1"),
		notice_info = <<"">>,
		is_notice = 0
	};

get(5) ->
	#lottery_coin_conf{
		id = 5,
		weights = 100,
		min_num = 0,
		day_num = 0,
		server_num = 0,
		goods = [{110140,1,1}],
		is_log = 1,
		name = xmerl_ucs:to_utf8("进阶丹*1"),
		notice_info = <<"">>,
		is_notice = 0
	};

get(6) ->
	#lottery_coin_conf{
		id = 6,
		weights = 1000,
		min_num = 0,
		day_num = 0,
		server_num = 0,
		goods = [{110198,1,100}],
		is_log = 0,
		name = xmerl_ucs:to_utf8("魔防印记*100"),
		notice_info = <<"">>,
		is_notice = 0
	};

get(7) ->
	#lottery_coin_conf{
		id = 7,
		weights = 1000,
		min_num = 0,
		day_num = 0,
		server_num = 0,
		goods = [{110197,1,100}],
		is_log = 0,
		name = xmerl_ucs:to_utf8("物防印记*100"),
		notice_info = <<"">>,
		is_notice = 0
	};

get(8) ->
	#lottery_coin_conf{
		id = 8,
		weights = 750,
		min_num = 0,
		day_num = 0,
		server_num = 0,
		goods = [{110195,1,100}],
		is_log = 0,
		name = xmerl_ucs:to_utf8("生命印记*100"),
		notice_info = <<"">>,
		is_notice = 0
	};

get(_Key) ->
	?ERR("undefined key from lottery_coin_config ~p", [_Key]).