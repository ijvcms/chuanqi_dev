%%%-------------------------------------------------------------------
%%% @author zhengsiying
%%% @doc
%%%		自动生成文件，不要手动修改
%%% @end
%%% Created : 2016/10/12
%%%-------------------------------------------------------------------

-module(real_boss_config).

-include("common.hrl").
-include("config.hrl").

-compile([export_all]).

get_list_conf() ->
	[ real_boss_config:get(X) || X <- get_list() ].

get_list() ->
	[].

get(_Key) ->
	?ERR("undefined key from real_boss_config ~p", [_Key]).