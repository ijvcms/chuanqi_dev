%%%-------------------------------------------------------------------
%%% @author zhengsiying
%%% @copyright (C) 2015, <COMPANY>
%%% @doc
%%%		普通节点模块
%%% @end
%%% Created : 15. 七月 2015 上午10:36
%%%-------------------------------------------------------------------
-module(node_normal).

-include("common.hrl").

%% API
-export([
	start/0,
	stop/0
]).

%% ====================================================================
%% API functions
%% ====================================================================
start() ->
	ok = service_base:start(),%% 基础
	ok = service_cache:start(),%% 缓存
	ok = service_game:start(),%% 游戏
	ok = service_back:start(),%% 后台
	ok = service_gateway:start(),%% 路由器
	ok.

stop() ->
	?TRACE("node normal stop!"),
	ok.

%% ====================================================================
%% Internal functions
%% ====================================================================
