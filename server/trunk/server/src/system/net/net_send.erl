%%%-------------------------------------------------------------------
%%% @author zhengsiying
%%% @copyright (C) 2015, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 16. 七月 2015 下午5:57
%%%-------------------------------------------------------------------
-module(net_send).

-include("common.hrl").
-include("record.hrl").
-include("cache.hrl").
-include("util_json.hrl").
-include("push_notifiction.hrl").

%% ====================================================================
%% API functions
%% ====================================================================
-export([
	send_one/2,
	send_to_client/3,
	send_to_world/2,
	send_to_guild/3,
	send_to_scene/3,
	send_to_screen/4,
	send_to_screen/5,
	send_to_screen2/4,
	send_to_back/3,
	send_one_list/2,
	get_bin/2
]).

send_one(Socket, Bin) when is_port(Socket) ->
	%% BinX16 = lists:concat([erlang:integer_to_list(Item, 16) ++ " " || Item <- binary_to_list(Bin)]),
	%% ?INFO("send bin: ~p", [BinX16]),
	gen_tcp:send(Socket, Bin);
send_one(PlayerId, Bin) ->
	case player_lib:get_socket(PlayerId) of
		Socket when is_port(Socket) ->
			send_one(Socket, Bin);
		_ ->
			skip
	end.
%% 发送列表
send_one_list(PlayerList, Bin1) ->
	[send_one(PlayerId, Bin1) || PlayerId <- PlayerList].

%% 发送给管理端
send_to_back(Socket, Cmd, Data) when is_port(Socket) ->
	send_one(Socket, pt_ex:write_cmd(Cmd, Data)).

%% 发送数据 包含 cmd
send_to_client(Socket, Cmd, Data) when is_port(Socket) ->
	NoLogCmds = [10006, 10012, 11004, 10004, 11019],
	case not lists:member(Cmd, NoLogCmds) of
		true ->
			?INFO("send_to_client1 ~p, ~p",[Cmd, Data]);
		false ->
			skip
	end,
	{ok, Bin} = pt:write_cmd(Cmd, Data),
	Bin1 = pt:pack(Cmd, Bin),
	send_one(Socket, Bin1);
send_to_client(Pid, Cmd, Data) when is_pid(Pid) ->
	gen_server2:apply_async(Pid, {?MODULE, send_to_client, [Cmd, Data]});
send_to_client(PlayerState, Cmd, Data) when is_record(PlayerState, player_state) ->
	net_send:send_to_client(PlayerState#player_state.socket, Cmd, Data);
send_to_client(PlayerId, Cmd, Data) ->
	case player_lib:get_socket(PlayerId) of
		Socket when is_port(Socket) ->
			send_to_client(Socket, Cmd, Data);
		_ ->
			skip
	end.

send_to_world(Cmd, Data) ->
	{ok, Bin} = pt:write_cmd(Cmd, Data),
	Bin1 = pt:pack(Cmd, Bin),
	PlayerList = player_lib:get_online_players(),
	[send_one(EtsOnline#ets_online.socket, Bin1) || EtsOnline <- PlayerList].

send_to_guild(Cmd, Data, GuildId) ->
	{ok, Bin} = pt:write_cmd(Cmd, Data),
	Bin1 = pt:pack(Cmd, Bin),
	PlayerList = guild_lib:get_online_players(GuildId),
	[send_one(EtsOnline#ets_online.socket, Bin1) || EtsOnline <- PlayerList].

send_to_scene(ScenePid, Cmd, Data) ->
	scene_send_lib:send_scene(ScenePid, Cmd, Data).

%% 全屏广播(包括自己)
send_to_screen(ScenePid, PlayerId, Cmd, Data) ->
	scene_send_lib:send_screen(ScenePid, ?OBJ_TYPE_PLAYER, PlayerId, Cmd, Data).

%% 全屏广播(不包括自己)
send_to_screen2(ScenePid, PlayerId, Cmd, Data) ->
	scene_send_lib:send_screen2(ScenePid, ?OBJ_TYPE_PLAYER, PlayerId, Cmd, Data).

send_to_screen(ScenePid, ObjType, ObjId, Cmd, Data) ->
	scene_send_lib:send_screen(ScenePid, ObjType, ObjId, Cmd, Data).

get_bin(Cmd, Data) ->
	{ok, Bin} = pt:write_cmd(Cmd, Data),
	pt:pack(Cmd, Bin).
%% ====================================================================
%% Internal functions
%% ====================================================================