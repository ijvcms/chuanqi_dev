%%%-------------------------------------------------------------------
%%% @author zhengsiying
%%% @doc
%%%		自动生成文件，不要手动修改
%%% @end
%%% Created : 2016/10/12
%%%-------------------------------------------------------------------

-module(equips_baptiz_change_jade_config).

-include("common.hrl").
-include("config.hrl").

-compile([export_all]).

get(Percent) when Percent >=1 andalso Percent =< 1000 ->
	#equips_baptiz_change_jade_conf{
		key = 1,
		min_percent = 1,
		max_percent = 1000,
		jade = 5
	};

get(Percent) when Percent >=1001 andalso Percent =< 2000 ->
	#equips_baptiz_change_jade_conf{
		key = 2,
		min_percent = 1001,
		max_percent = 2000,
		jade = 10
	};

get(Percent) when Percent >=2001 andalso Percent =< 3000 ->
	#equips_baptiz_change_jade_conf{
		key = 3,
		min_percent = 2001,
		max_percent = 3000,
		jade = 15
	};

get(Percent) when Percent >=3001 andalso Percent =< 4000 ->
	#equips_baptiz_change_jade_conf{
		key = 4,
		min_percent = 3001,
		max_percent = 4000,
		jade = 25
	};

get(Percent) when Percent >=4001 andalso Percent =< 5000 ->
	#equips_baptiz_change_jade_conf{
		key = 5,
		min_percent = 4001,
		max_percent = 5000,
		jade = 50
	};

get(Percent) when Percent >=5001 andalso Percent =< 6000 ->
	#equips_baptiz_change_jade_conf{
		key = 6,
		min_percent = 5001,
		max_percent = 6000,
		jade = 150
	};

get(Percent) when Percent >=6001 andalso Percent =< 7000 ->
	#equips_baptiz_change_jade_conf{
		key = 7,
		min_percent = 6001,
		max_percent = 7000,
		jade = 250
	};

get(Percent) when Percent >=7001 andalso Percent =< 8000 ->
	#equips_baptiz_change_jade_conf{
		key = 8,
		min_percent = 7001,
		max_percent = 8000,
		jade = 350
	};

get(Percent) when Percent >=8001 andalso Percent =< 9000 ->
	#equips_baptiz_change_jade_conf{
		key = 9,
		min_percent = 8001,
		max_percent = 9000,
		jade = 450
	};

get(Percent) when Percent >=9001 andalso Percent =< 10000 ->
	#equips_baptiz_change_jade_conf{
		key = 10,
		min_percent = 9001,
		max_percent = 10000,
		jade = 500
	};

get(_Key) ->
	?ERR("undefined key from equips_baptiz_change_jade_config ~p", [_Key]).