%%%-------------------------------------------------------------------
%%% @author zhengsiying
%%% @doc
%%%		自动生成文件，不要手动修改
%%% @end
%%% Created : 2016/10/12
%%%-------------------------------------------------------------------

-module(guild_config).

-include("common.hrl").
-include("config.hrl").

-compile([export_all]).

get_list_conf() ->
	[ guild_config:get(X) || X <- get_list() ].

get_list() ->
	[1, 2, 3, 4, 5, 6, 7, 8, 9, 10].

get(1) ->
	#guild_conf{
		key = 1,
		exp = 9000,
		member_limit = 40
	};

get(2) ->
	#guild_conf{
		key = 2,
		exp = 20000,
		member_limit = 45
	};

get(3) ->
	#guild_conf{
		key = 3,
		exp = 60000,
		member_limit = 50
	};

get(4) ->
	#guild_conf{
		key = 4,
		exp = 130000,
		member_limit = 55
	};

get(5) ->
	#guild_conf{
		key = 5,
		exp = 260000,
		member_limit = 60
	};

get(6) ->
	#guild_conf{
		key = 6,
		exp = 520000,
		member_limit = 65
	};

get(7) ->
	#guild_conf{
		key = 7,
		exp = 1040000,
		member_limit = 70
	};

get(8) ->
	#guild_conf{
		key = 8,
		exp = 2080000,
		member_limit = 75
	};

get(9) ->
	#guild_conf{
		key = 9,
		exp = 4160000,
		member_limit = 80
	};

get(10) ->
	#guild_conf{
		key = 10,
		exp = 9999999999,
		member_limit = 85
	};

get(_Key) ->
	?ERR("undefined key from guild_config ~p", [_Key]).