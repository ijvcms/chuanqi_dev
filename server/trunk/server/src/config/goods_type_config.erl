%%%-------------------------------------------------------------------
%%% @author zhengsiying
%%% @doc
%%%		自动生成文件，不要手动修改
%%% @end
%%% Created : 2016/10/12
%%%-------------------------------------------------------------------

-module(goods_type_config).

-include("common.hrl").
-include("config.hrl").

-compile([export_all]).

get_list() ->
	[{4,3}, {4,2}, {4,5}].

get({4,3}) ->
	#goods_type_conf{
		key = 1,
		type = 4,
		sub_type = 3,
		cd_time = 2
	};

get({4,2}) ->
	#goods_type_conf{
		key = 2,
		type = 4,
		sub_type = 2,
		cd_time = 1
	};

get({4,5}) ->
	#goods_type_conf{
		key = 3,
		type = 4,
		sub_type = 5,
		cd_time = 2
	};

get(_Key) ->
	?ERR("undefined key from goods_type_config ~p", [_Key]).