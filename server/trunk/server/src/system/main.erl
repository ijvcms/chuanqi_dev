%% Author: ming
%% Created: 2012-6-10
%% Description: TODO: Add description to main
-module(main).

%%
%% Include files
%%
-include("common.hrl").
-include("record.hrl").
-include("proto.hrl").
-include("language_config.hrl").
-define(SERVER_APPS, [sasl, server]).
-define(KICKOUT_WAITING_TIME, 10).      %% 踢除所有玩家,关闭登陆服务等待时间
-define(APPLICATION_TIME, 1).           %% 关闭应用等待时间a
-define(CLOSE_LOGIC_SERVER_TIME, 15).   %% 关闭玩家节点等待时间

%%
%% Exported Functions
%%
-export([
	server_start/0,
	server_stop/0,
	node_online/0,
	close_node/1
]).

%%
%% API Functions
%%
server_start() ->
	ok = start_applications(?SERVER_APPS).

%% 关闭服务
server_stop() ->
%% 	List = ets:tab2list(?ETS_ONLINE),
%% 	[net_send:send_to_client(EtsOnline#ets_online.socket, 9997, #rep_login_out{result = ?ERR_SERVER_STOP}) || EtsOnline <- List],

	stop_applications(?SERVER_APPS),
	timer:sleep(?APPLICATION_TIME * 1000),
	erlang:halt(0, [{flush, false}]).

%% 节点在线人数s
node_online() ->
	ets:info(?ETS_ONLINE, size).

%% 关闭节点
close_node(Argus) ->
	Node = hd(Argus),
	Result = net_adm:ping(Node),
	case Result of
		pong ->
			timer:sleep(1000),
			erlang:halt(0, [{flush, false}]);
		_ ->
			?TRACE("can not connet to the node!!!!!")
	end.

%%
%% Local Functions
%%
manage_applications(Iterate, Do, Undo, SkipError, ErrorTag, Apps) ->
	Iterate(fun(App, Acc) ->
		case Do(App) of
			ok -> [App | Acc];%% 合拢
			{error, {SkipError, _}} -> Acc;
			{error, Reason} ->
				lists:foreach(Undo, Acc),
				throw({error, {ErrorTag, App, Reason}})
		end
	end, [], Apps),
	ok.

start_applications(Apps) ->
	manage_applications(fun lists:foldl/3,
		fun application:start/1,
		fun application:stop/1,
		already_started,
		cannot_start_application,
		Apps).

stop_applications(Apps) ->
	manage_applications(fun lists:foldr/3,
		fun application:stop/1,
		fun application:start/1,
		not_started,
		cannot_stop_application,
		Apps).
