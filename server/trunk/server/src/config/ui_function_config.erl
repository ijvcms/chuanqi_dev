%%%-------------------------------------------------------------------
%%% @author zhengsiying
%%% @doc
%%%		自动生成文件，不要手动修改
%%% @end
%%% Created : 2016/10/12
%%%-------------------------------------------------------------------

-module(ui_function_config).

-include("common.hrl").
-include("config.hrl").

-compile([export_all]).

get_list_conf() ->
	[ ui_function_config:get(X) || X <- get_list() ].

get_list() ->
	[1].

get(1) ->
	#ui_function_conf{
		id = 1,
		state = 1
	};

get(_Key) ->
	?ERR("undefined key from ui_function_config ~p", [_Key]).