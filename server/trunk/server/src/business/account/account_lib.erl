%%%-------------------------------------------------------------------
%%% @author zhengsiying
%%% @copyright (C) 2015, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 30. 十月 2015 上午9:48
%%%-------------------------------------------------------------------
-module(account_lib).

-include("common.hrl").
-include("record.hrl").
-include("proto.hrl").
-include("language_config.hrl").

%% API
-export([
	login/4,
	enter_game/7,
	logout/1,
	delete_player/3
]).

%% ====================================================================
%% API functions 记录在线玩家账号
%% ====================================================================
login(OpenId, Platform, SocketPid, Socket) ->
	case ets:lookup(?ETS_ACCOUNT_ONLINE, {OpenId, Platform}) of
		[Info] ->
			case Info#ets_account_online.socket_pid /= SocketPid of
				true ->
					case not util_data:is_null(Info#ets_account_online.player_id) of
						true ->
							player_lib:logout(Info#ets_account_online.player_id);
						_ ->
							skip
					end,
					%% 踢玩家下线
					net_send:send_to_client(Info#ets_account_online.socket, 10007, #rep_logout{flag = ?LOGOUT_FLAG_OTHER_LOGIN}),
					%% cast tcp 关闭socket
					gen_server2:cast(Info#ets_account_online.socket_pid, {socket_closed});
				_ ->
					skip
			end,
			NewInfo = Info#ets_account_online{
				socket_pid = SocketPid,
				socket = Socket
			},
			ets:insert(?ETS_ACCOUNT_ONLINE, NewInfo);
		_ ->
			Info = #ets_account_online{
				account_flag = {OpenId, Platform},
				socket_pid = SocketPid,
				socket = Socket
			},
			ets:insert(?ETS_ACCOUNT_ONLINE, Info)
	end.
%% 进入游戏
enter_game(PlayerBase, OpenId, Platform, Socket, PlayerId, OsType, IsRobot) ->
	case ets:lookup(?ETS_ACCOUNT_ONLINE, {OpenId, Platform}) of
		[Info] -> %% 判断在线玩家里面是否存在，如果存在那么就把 当前角色 踢出
			case Info#ets_account_online.player_id /= PlayerId andalso not util_data:is_null(Info#ets_account_online.player_id) of
				true ->
					player_lib:logout(Info#ets_account_online.player_id);
				_ ->
					skip
			end,
			%% 进入游戏获取 玩家的PID
			case player_lib:enter(PlayerBase, Socket, self(), OsType, OpenId, Platform, IsRobot) of
				{ok, Pid} ->
					NewInfo = Info#ets_account_online{
						player_id = PlayerId,
						player_pid = Pid
					},
					ets:insert(?ETS_ACCOUNT_ONLINE, NewInfo),
					{ok, Pid};
				{fail, Err} ->
					{fail, Err}
			end;
		_ ->
			?ERR("info ~p", [111]),
			{fail, ?ERR_COMMON_FAIL}
	end.

logout(ClientState) ->
	#tcp_client_state{player_id = PlayerId, open_id = OpenId, platform = Platform, first_time = FirstTime} = ClientState,
	case ets:lookup(?ETS_ACCOUNT_ONLINE, {OpenId, Platform}) of
		[Info] ->
			case not util_data:is_null(Info#ets_account_online.player_id) of
				true ->
					player_lib:logout(Info#ets_account_online.player_id);
				_ ->
					skip
			end,
			log_lib:log_login(OpenId, Platform, PlayerId, null, FirstTime, util_date:unixtime(), 0),
			ets:delete(?ETS_ACCOUNT_ONLINE, {OpenId, Platform});
		_ ->
			skip
	end.

delete_player(OpenId, Platform, PlayerId) ->
	log_lib:log_del_account(OpenId, Platform, PlayerId),
	account_db:delete(OpenId, Platform, PlayerId).

%% ====================================================================
%% Internal functions
%% ====================================================================
