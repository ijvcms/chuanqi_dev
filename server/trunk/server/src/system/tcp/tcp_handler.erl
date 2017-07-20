%% @author qhb
%% @doc @todo Add description to rpc_handler.


-module(tcp_handler).

-include("common.hrl").
-include("record.hrl").
-include("proto.hrl").
-include("language_config.hrl").

-define(MARK_NOT, 0).
-define(MARK_COMPRESS, 1).

-record(proto_content, {
	cmd,
	data
}).

-export([
	dispatch/2
]).

%% ====================================================================
%% API functions
%% ====================================================================
dispatch(State, ReqBin) ->
	{ok, ProtoContent} = get_proto_content(ReqBin),
	Cmd = ProtoContent#proto_content.cmd,
	Data = ProtoContent#proto_content.data,
	case proto_cmd:route(Cmd) of
		null ->
			Trace = try throw(42) catch 42 -> erlang:get_stacktrace() end,
			?ERR("undefined cmd: ~p mod :~p", [Cmd, Trace]);
		PPMod ->
			Result = case proto_cmd:to_process(Cmd) of
						 tcp_client ->
							 ?INFO("recv cmd : ~p ==> ~p", [Cmd, Data]),
							 %% socket进程自己处理
							 case PPMod:handle(Cmd, State, Data) of
								 {ok, NewState} ->
									 {ok, NewState};
								 {fail, ErrorCode} ->
									 ?INFO("fail! ===== >>>>>> error code: ~p", [ErrorCode]),
									 {fail, ErrorCode};
								 _ ->
									 skip
							 end;
						 player ->
							 NoLogCmds = [11002, 11003],
							 case not lists:member(Cmd, NoLogCmds) of
								 true ->
									 ?INFO("cmd: ~p, data: ~p", [Cmd, Data]);
								 false ->
									 skip
							 end,
							 %% 发送到玩家进程进行处理
							 gen_server2:cast(State#tcp_client_state.player_pid, {'SOCKET_EVENT', PPMod, Cmd, Data}),
							 {ok, State}
					 end,
			%% socket运行次数验证
			case Result of
				{ok, NewState1} ->
					CurTime = util_date:unixtime(),
					NewState2 = case NewState1#tcp_client_state.socket_time < CurTime of
									true ->
										NewState1#tcp_client_state{
											socket_num = [],
											socket_time = CurTime
										};
									_ ->
										NewState1#tcp_client_state{
											socket_num = [Cmd | NewState1#tcp_client_state.socket_num]
										}
								end,
					case length(NewState2#tcp_client_state.socket_num) > 100 of
						true ->
							?ERR("tcp_client_state 20 ~p", [{NewState2#tcp_client_state.open_id, NewState2#tcp_client_state.player_id, NewState2#tcp_client_state.socket_num, NewState2#tcp_client_state.ip}]),
							net_send:send_to_client(NewState2#tcp_client_state.socket, 9997, #rep_login_out{result = ?ERR_ACCOUNT_ERR}),
							gen_server2:cast(self(), {kick_out, 1});
						_ ->
							{ok, NewState2}
					end;
				_ ->
					Result
			end
	end.

%% ====================================================================
%% Internal functions
%% ====================================================================
get_proto_content(<<Mark:8/little-unsigned, Cmd:16/little-unsigned, Bin0/binary>>) ->
	Bin =
		case Mark of
			?MARK_COMPRESS ->
				zlib:uncompress(Bin0);
			_ ->
				Bin0
		end,
	{ok, Data} = pt:read_cmd(Cmd, Bin),
	ProtoContent = #proto_content{
		cmd = Cmd,
		data = Data
	},
	{ok, ProtoContent}.
