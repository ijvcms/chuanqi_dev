%%%-------------------------------------------------------------------
%%% @author zhengsiying
%%% @doc
%%%		自动生成文件，不要手动修改
%%% @end
%%% Created : 2016/10/12
%%%-------------------------------------------------------------------

-module(package_goods_config).

-include("common.hrl").
-include("config.hrl").

-compile([export_all]).

get_list_conf() ->
	[ package_goods_config:get(X) || X <- get_list() ].

get_list() ->
	[25, 50].

get(25) ->
	#package_goods_conf{
		lv = 25,
		goods = []
	};

get(50) ->
	#package_goods_conf{
		lv = 50,
		goods = []
	};

get(_Key) ->
	 null.