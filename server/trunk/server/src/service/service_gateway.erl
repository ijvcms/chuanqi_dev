%%%-------------------------------------------------------------------
%%% @author zhengsiying
%%% @copyright (C) 2015, <COMPANY>
%%% @doc
%%%     网关服务
%%% @end
%%% Created : 07. 三月 2015 17:35
%%%-------------------------------------------------------------------
-module(service_gateway).

%% API
-export([
	start/0
]).

%% ====================================================================
%% API functions
%% ====================================================================
start() ->
	[_Ip, Port] = config:get_tcp_listener(),
	io:format(" start ip:~p port:~p servier_id:~p backport:~p",[_Ip,Port,config:get_server_no(),config:get_background_port()]),
	%% tcp_client_sup 发送
	%% tcp_listener_sup 监听接收
	ModList = [{tcp_client_sup}, {tcp_listener_sup, start_link, [Port]}],
	ok = util:start_mod(transient, ModList),
	ok.

%% ====================================================================
%% Internal functions
%% ====================================================================