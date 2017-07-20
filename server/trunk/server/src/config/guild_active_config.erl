%%%-------------------------------------------------------------------
%%% @author zhengsiying
%%% @doc
%%%		自动生成文件，不要手动修改
%%% @end
%%% Created : 2016/10/12
%%%-------------------------------------------------------------------

-module(guild_active_config).

-include("common.hrl").
-include("config.hrl").

-compile([export_all]).

get_list_conf() ->
	[ guild_active_config:get(X) || X <- get_list() ].

get_list() ->
	[1, 2, 3, 4, 5, 6, 7].

get(1) ->
	#guild_active_conf{
		key = 1,
		is_push = 1,
		open_limit = [],
		enter_limit = [{guild_lv,2}],
		open_type = 1,
		open_week = [1,2,3,4,5,6,7],
		open_time = {13,0,0},
		close_time = {13,30,0},
		count_type = <<"day">>,
		limit_count = 1,
		enter_instance = 20300,
		sub_instance = []
	};

get(2) ->
	#guild_active_conf{
		key = 2,
		is_push = 1,
		open_limit = [],
		enter_limit = [{guild_lv,4}],
		open_type = 1,
		open_week = [1,2,3,4,5,6,7],
		open_time = {13,0,0},
		close_time = {13,30,0},
		count_type = <<"day">>,
		limit_count = 1,
		enter_instance = 20301,
		sub_instance = []
	};

get(3) ->
	#guild_active_conf{
		key = 3,
		is_push = 1,
		open_limit = [],
		enter_limit = [{guild_lv,6}],
		open_type = 1,
		open_week = [1,2,3,4,5,6,7],
		open_time = {13,0,0},
		close_time = {13,30,0},
		count_type = <<"day">>,
		limit_count = 1,
		enter_instance = 20302,
		sub_instance = []
	};

get(4) ->
	#guild_active_conf{
		key = 4,
		is_push = 0,
		open_limit = [],
		enter_limit = [{guild_lv,3}],
		open_type = 1,
		open_week = [1,2,3,4,5,6,7],
		open_time = {14,00,0},
		close_time = {14,30,0},
		count_type = <<"day">>,
		limit_count = 1,
		enter_instance = 20303,
		sub_instance = [20305,20306]
	};

get(5) ->
	#guild_active_conf{
		key = 5,
		is_push = 0,
		open_limit = [is_sbk,is_guild_hz,{guild_capital, 1000}],
		enter_limit = [{player_lv,35}],
		open_type = 1,
		open_week = [1,2,3,4,5,7],
		open_time = [],
		close_time = [],
		count_type = <<"week">>,
		limit_count = 3,
		enter_instance = 20304,
		sub_instance = []
	};

get(6) ->
	#guild_active_conf{
		key = 6,
		is_push = 1,
		open_limit = [],
		enter_limit = [{guild_lv,8}],
		open_type = 1,
		open_week = [1,2,3,4,5,6,7],
		open_time = {13,0,0},
		close_time = {13,30,0},
		count_type = <<"day">>,
		limit_count = 1,
		enter_instance = 20307,
		sub_instance = []
	};

get(7) ->
	#guild_active_conf{
		key = 7,
		is_push = 1,
		open_limit = [],
		enter_limit = [{guild_lv,10}],
		open_type = 1,
		open_week = [1,2,3,4,5,6,7],
		open_time = {13,0,0},
		close_time = {13,30,0},
		count_type = <<"day">>,
		limit_count = 1,
		enter_instance = 20308,
		sub_instance = []
	};

get(_Key) ->
	?ERR("undefined key from guild_active_config ~p", [_Key]).