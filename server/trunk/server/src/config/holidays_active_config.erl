%%%-------------------------------------------------------------------
%%% @author zhengsiying
%%% @doc
%%%		自动生成文件，不要手动修改
%%% @end
%%% Created : 2016/10/12
%%%-------------------------------------------------------------------

-module(holidays_active_config).

-include("common.hrl").
-include("config.hrl").

-compile([export_all]).

get_list_conf() ->
	[ holidays_active_config:get(X) || X <- get_list() ].

get_list() ->
	[4, 5].

get(4) ->
	#holidays_active_conf{
		active_type = 4,
		reward = [{rank,[{1, 113,5000},{2, 114,5000}, {3, 115,5000}]},{score, [{2000, 116}, {1000, 117},{500, 118}]}]
	};

get(5) ->
	#holidays_active_conf{
		active_type = 5,
		reward = [{260, 10}, {261, 5}, {262, 2}]
	};

get(_Key) ->
	?ERR("undefined key from holidays_active_config ~p", [_Key]).