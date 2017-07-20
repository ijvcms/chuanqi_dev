%% @author qhb
%% @doc @todo Add description to tcp_client.


-module(tcp_client).
-behaviour(gen_server).

-include("common.hrl").
-include("record.hrl").
-include("proto.hrl").

-export([init/1, handle_call/3, handle_cast/2, handle_info/2, terminate/2, code_change/3]).

-define(TCP_TIMEOUT, 30 * 1000).        %% 毫秒
-define(SOCKET_TIMEOUT, 6000 * 1000).    %% 毫秒
-define(SOCKET_TIMEOUT_TIME, 30).        %% 次数
-define(HEADER_LENGTH, 2).                %% 包头长度

-define(TIMER_FRAME, 10000).            %% 定时器时间片
-define(HEART_TIMEOUT, 180).                %% 秒

%% ====================================================================
%% API functions
%% ====================================================================
-export([start_link/0]).

start_link() ->
	gen_server:start_link(?MODULE, [], []).

%% ====================================================================
%% Behavioural functions
%% ====================================================================

init([]) ->
	process_flag(trap_exit, true),
	erlang:send_after(?TIMER_FRAME, self(), {on_timer}),
	Time = util_date:unixtime(),
	{ok, #tcp_client_state{first_time = Time, last_heart = Time}}.

handle_call(_Request, _From, State) ->
	Reply = ok,
	{reply, Reply, State}.

handle_cast({socket_closed}, State) ->
	?INFO("socket closed =================", []),
	gen_tcp:close(State#tcp_client_state.socket),
	{stop, normal, State#tcp_client_state{need_clean_account = false}};
handle_cast({test_cmd, Cmd, Data}, State) ->
	?ERR("test cmd ~p ~p", [Cmd, Data]),
	PPMod = proto_cmd:route(Cmd),
	case proto_cmd:to_process(Cmd) of
		tcp_client ->
			case PPMod:handle(Cmd, State, Data) of
				{ok, NewState} ->
					{ok, NewState};
				{fail, ErrorCode} ->
					?INFO("fail! ===== >>>>>> error code: ~p", [ErrorCode]),
					{fail, ErrorCode};
				_ ->
					{ok, State}
			end;
		player ->
			gen_server2:cast(State#tcp_client_state.player_pid, {'SOCKET_EVENT', PPMod, Cmd, Data})
	end;
%% 封号 踢人
handle_cast({kick_out, Flag}, ClientState) ->
	?INFO("TEST KICK_OUT ~p", [Flag]),
	%%Platform = ClientState#tcp_client_state.platform,
	%%OpenId = ClientState#tcp_client_state.open_id,
	PlayerId = ClientState#tcp_client_state.player_id,
	case Flag of
	%% 账号退出
		?LOGOUT_FLAG_ACCOUNT ->
			account_lib:logout(ClientState),
			net_send:send_to_client(ClientState#tcp_client_state.socket, 10007, #rep_logout{flag = ?LOGOUT_FLAG_ACCOUNT}),
			{ok, ClientState#tcp_client_state{open_id = null, platform = null, player_id = null, player_pid = null}};
	%% 角色退出
		?LOGOUT_FLAG_PLAYER ->
			player_lib:logout(PlayerId),
			net_send:send_to_client(ClientState#tcp_client_state.socket, 10007, #rep_logout{flag = ?LOGOUT_FLAG_PLAYER}),
			{ok, ClientState#tcp_client_state{player_id = null, player_pid = null}};
		_ ->
			{ok, ClientState}
	end;
handle_cast(_Msg, State) ->
	{noreply, State}.


handle_info({go, Socket}, State) ->
	%%ws_lib:recv_ws_handshake(Socket),
	inet:setopts(Socket, [{low_watermark, 65536}, {high_watermark, 131072}, {delay_send, true}, {send_timeout, 5000}, {sndbuf, 16 * 1024}]),
	async_recv(Socket, ?HEADER_LENGTH, ?SOCKET_TIMEOUT),

	NewState = State#tcp_client_state{
		socket = Socket,
		ip = util_data:get_ip(Socket)
	},
	{noreply, NewState};


%%flash安全沙箱
handle_info({inet_async, Socket, _Ref, {ok, ?FL_POLICY_REQ}}, State) ->
	Len = 23 - ?HEADER_LENGTH,
	async_recv(Socket, Len, ?TCP_TIMEOUT),
	net_send:send_one(Socket, ?FL_POLICY_FILE),
	{noreply, State};

%% 超时处理
handle_info({inet_async, Socket, _Ref, {error, timeout}}, State) ->
	?INFO("timeout ", []),
	case State#tcp_client_state.timeout >= ?SOCKET_TIMEOUT_TIME of
		true ->
			?WARNING("login lost time out", []),
			login_lost(Socket, State, 11, {error, timeout});
		false ->
			async_recv(Socket, ?HEADER_LENGTH, ?SOCKET_TIMEOUT),
			NewState = State#tcp_client_state{
				timeout = State#tcp_client_state.timeout + 1
			},
			{noreply, NewState}
	end;

%% 数据处理
handle_info({inet_async, Socket, _Ref, {ok, <<Binary/binary>>}}, State) ->
	do_data(Binary, Socket, State);

handle_info({inet_async, _, _, {error, closed}}, State) ->
	?INFO("closed", []),
	account_lib:logout(State),
	{stop, normal, State};

handle_info({inet_async, _, _, {error, Reason}}, State) ->
	?INFO("error ~p:~p", ["Socket error", Reason]),
	account_lib:logout(State),
	{stop, normal, State};

handle_info({on_timer}, State) ->
	CurTime = util_date:unixtime(),
	case State#tcp_client_state.last_heart + ?HEART_TIMEOUT < CurTime of
		true ->
			account_lib:logout(State),
			{stop, normal, State};
		_ ->
			erlang:send_after(?TIMER_FRAME, self(), {on_timer}),
			{noreply, State}
	end;

handle_info(_Info, State) ->
	{noreply, State}.

terminate(_Reason, State) ->
	#tcp_client_state{
		%%open_id = OpenId,
		%%platform = Platform,
		socket = Socket,
		need_clean_account = NeedClean
	} = State,
	(catch gen_tcp:close(Socket)),
	case NeedClean of
		true ->
			?INFO("1111 ~p", [1111]),
			account_lib:logout(State);
		_ ->
			skip
	end,
	ok.

code_change(_OldVsn, State, _Extra) ->
	{ok, State}.


%% ====================================================================
%% Internal functions
%% ====================================================================
%% accept data
async_recv(Sock, Length, Timeout) when is_port(Sock) ->
	case prim_inet:async_recv(Sock, Length, Timeout) of
		{error, Reason} ->
			throw({Reason});
		{ok, Res} ->
			Res;
		Res ->
			Res
	end.

login_lost(Socket, _State, _Location, Reason) ->
	timer:sleep(100),
	gen_tcp:close(Socket),
	exit({unexpected_message, Reason}).

do_data(<<Len:16/little-unsigned>>, Socket, State) ->
	async_recv(Socket, Len, ?TCP_TIMEOUT),
	{noreply, State};
do_data(<<RequestBin/binary>>, Socket, State) ->
	CurTime = util_date:unixtime(),
	case tcp_handler:dispatch(State, RequestBin) of
		{ok, NewState} ->
			async_recv(Socket, ?HEADER_LENGTH, ?SOCKET_TIMEOUT),
			{noreply, NewState#tcp_client_state{last_heart = CurTime}};
		_ ->
			async_recv(Socket, ?HEADER_LENGTH, ?SOCKET_TIMEOUT),
			{noreply, State#tcp_client_state{last_heart = CurTime}}
	end.