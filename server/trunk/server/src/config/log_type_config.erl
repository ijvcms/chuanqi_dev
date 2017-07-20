%%%-------------------------------------------------------------------
%%% @author zhengsiying
%%% @doc
%%%		自动生成文件，不要手动修改
%%% @end
%%% Created : 2016/10/12
%%%-------------------------------------------------------------------

-module(log_type_config).

-include("common.hrl").
-include("config.hrl").

-compile([export_all]).

get_active_type_id(2) ->
	98;
get_active_type_id(5) ->
	99;
get_active_type_id(_Key) ->
	0.