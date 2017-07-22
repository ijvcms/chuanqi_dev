%%%-------------------------------------------------------------------
%%% @author zhengsiying
%%% @copyright (C) 2017, <COMPANY>
%%% @doc
%%%		跨服节点
%%% @end
%%% Created : 15. 六月 2017 上午1:15
%%%-------------------------------------------------------------------
-module(node_cross).
-author("zhengsiying").

-include("common.hrl").

%% API
%% API
-export([
	start/0,
	stop/0
]).

%% ====================================================================
%% API functions
%% ====================================================================
start() ->
	?ERR("start base", []),
	ok = service_base:start(),%% 基础
	?ERR("start cache", []),
	ok = service_cache:start(),%% 缓存
	?ERR("start game", []),
	ok = service_game:start(),%% 游戏
	?ERR("start back", []),
	ok = service_back:start(),%% 后台
	?ERR("start gateway", []),
	ok = service_gateway:start(),%% 路由器
	io:format("dsdsdsfdgg"),
	ok.

stop() ->
	?TRACE("node normal stop!"),
	ok.

%% ====================================================================
%% Internal functions
%% ====================================================================