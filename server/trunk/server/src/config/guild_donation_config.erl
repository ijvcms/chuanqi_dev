%%%-------------------------------------------------------------------
%%% @author zhengsiying
%%% @doc
%%%		自动生成文件，不要手动修改
%%% @end
%%% Created : 2016/10/12
%%%-------------------------------------------------------------------

-module(guild_donation_config).

-include("common.hrl").
-include("config.hrl").

-compile([export_all]).

get_list_conf() ->
	[ guild_donation_config:get(X) || X <- get_list() ].

get_list() ->
	[1, 2, 3].

get(1) ->
	#guild_donation_conf{
		key = 1,
		consume_type = 1,
		consume_value = 100000,
		vip_limit = 0,
		contribution = 100,
		guild_exp = 100,
		guild_capital = 100,
		counter_id = 10002
	};

get(2) ->
	#guild_donation_conf{
		key = 2,
		consume_type = 2,
		consume_value = 10,
		vip_limit = 1,
		contribution = 200,
		guild_exp = 200,
		guild_capital = 200,
		counter_id = 10003
	};

get(3) ->
	#guild_donation_conf{
		key = 3,
		consume_type = 2,
		consume_value = 50,
		vip_limit = 2,
		contribution = 1000,
		guild_exp = 1000,
		guild_capital = 1000,
		counter_id = 10004
	};

get(_Key) ->
	?ERR("undefined key from guild_donation_config ~p", [_Key]).