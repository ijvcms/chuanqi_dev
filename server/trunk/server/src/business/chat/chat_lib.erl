%%%-------------------------------------------------------------------
%%% @author tuhujia
%%% @copyright (C) 2015, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 03. 八月 2015 09:36
%%%-------------------------------------------------------------------
-module(chat_lib).
-include("common.hrl").
-include("record.hrl").
-include("config.hrl").
-include("cache.hrl").
-include("db_record.hrl").
-include("proto.hrl").
-include("language_config.hrl").

-export([
	chat_by_world/3,
	chat_by_one/5,
	chat_by_guild/3,
	chat_by_team/3,
	send_err_result/2,
	chat_player_state/3,
	send_chat_list/2
]).

%%% ----------------------------------------------------------------------------
%%% 对外接口
%%% ----------------------------------------------------------------------------

%% 世界
chat_by_world(Cmd, State, Content) ->
	Content1 = handle_content(Content),
	PlayerBase = State#player_state.db_player_base,
	PlayerId = State#player_state.player_id,
	Name = PlayerBase#db_player_base.name,
	Data = get_chat_info(State, Content1),

	{ok, Bin} = pt:write_cmd(Cmd, #rep_world_chat{chat_info = Data}),
	Bin1 = pt:pack(Cmd, Bin),

	case PlayerBase#db_player_base.limit_chat > util_date:unixtime() of
		true ->
			chat_player_state(State, PlayerId, Bin1);
		_ ->
			chat_cache:save_chat({?CHAT_SORT_WORD, 0}, Data),
			PlayerList = player_lib:get_online_players(),
			[chat_player_state(X#ets_online.pid, PlayerId, Bin1) || X <- PlayerList],
			log_lib:log_chat(PlayerId, Name, Content1)
	end,
	{ok, State}.

%% 私聊
chat_by_one(Cmd, State, TargetId, TargetName, Content) ->
	Content1 = handle_content(Content),
	PlayerId = State#player_state.player_id,
	TargetId1 = case TargetId of
					0 ->
						case player_id_name_lib:get_ets_player_id_name_by_playername(TargetName) of
							fail ->
								0;
							Ets ->
								Ets#ets_player_id_name.player_id
						end;
					_ ->
						TargetId
				end,
	TargetId2 = if
					TargetId1 =:= PlayerId -> null;
					TargetId1 > 0 -> TargetId1;
					true -> null
				end,
	case TargetId2 of
		null ->
			chat_in_not_online(State),
			{ok, State};
		_ ->
			PlayerBase = State#player_state.db_player_base,
			Name = PlayerBase#db_player_base.name,

			case PlayerBase#db_player_base.limit_chat > util_date:unixtime() of
				true ->
					skip;
				false ->
					Data = get_chat_info(State, Content1),
					%% 返回给自己，告诉自己发送成功
					%% 保存私聊信息
					chat_cache:save_chat({?CHAT_SORT_PLAYER, PlayerId}, Data),
					chat_cache:save_chat({?CHAT_SORT_PLAYER, TargetId2}, Data),

					Data1 = #rep_friend_chat{
						chat_info = Data
					},
					{ok, Bin} = pt:write_cmd(Cmd, Data1),
					Bin1 = pt:pack(Cmd, Bin),
					chat_player_state(TargetId2, PlayerId, Bin1),
					log_lib:log_chat(PlayerId, Name, Content1)
			end
	end.

%% 公会
chat_by_guild(Cmd, State, Content) ->
	Content1 = handle_content(Content),
	PlayerBase = State#player_state.db_player_base,
	PlayerId = State#player_state.player_id,
	Name = PlayerBase#db_player_base.name,
	Name = PlayerBase#db_player_base.name,
	GuildId = PlayerBase#db_player_base.guild_id,

	case GuildId > 0 of
		false ->
			chat_in_not_guild(State);
		true ->
			case PlayerBase#db_player_base.limit_chat > util_date:unixtime() of
				true ->
					skip;
				false ->
					Data = get_chat_info(State, Content1),
					%% 保存工会聊天信息
					chat_cache:save_chat({?CHAT_SORT_GUILD, GuildId}, Data),

					Data1 = #rep_guild_chat{
						chat_info = Data
					},

					net_send:send_to_guild(Cmd, Data1, GuildId),
					log_lib:log_chat(PlayerId, Name, Content1)
			end
	end,
	{ok, State}.

%% 队伍
chat_by_team(Cmd, State, Content) ->
	TeamId = State#player_state.team_id,
	case TeamId > 0 of
		true ->
			case team_lib:get_team_info_from_ets(TeamId) of
				#ets_team{} = EtsTeam ->
					TeamPid = EtsTeam#ets_team.team_pid,
					Content1 = handle_content(Content),
					PlayerBase = State#player_state.db_player_base,
					PlayerId = State#player_state.player_id,
					Name = PlayerBase#db_player_base.name,
					Name = PlayerBase#db_player_base.name,

					case PlayerBase#db_player_base.limit_chat > util_date:unixtime() of
						true ->
							skip;
						false ->
							Data = get_chat_info(State, Content1),

							Data1 = #rep_team_chat{
								chat_info = Data
							},

							gen_server:cast(TeamPid, {'SEND_CMD', Cmd, Data1}),
							log_lib:log_chat(PlayerId, Name, Content1)
					end;
				_ ->
					chat_in_not_team(State)
			end;
		false ->
			chat_in_not_team(State)
	end,
	{ok, State}.

%%------------------------------------------------------------------------
%%------------------------------------------------------------------------
%%------------------------------------------------------------------------
%% 发送聊天信息
chat_player_state(PlayerPid, TPlayerId, Bin) when is_pid(PlayerPid) ->
	gen_server2:apply_async(PlayerPid, {?MODULE, chat_player_state, [TPlayerId, Bin]});
%% 发送聊天信息
chat_player_state(Playerid, TPlayerId, Bin) when is_integer(Playerid) ->
	case player_lib:get_player_pid(Playerid) of
		null ->
			skip;
		PId ->
			chat_player_state(PId, TPlayerId, Bin)
	end;
%% 发送聊天信息
chat_player_state(PlayerState, TPlayerId, Bin) ->
	case lists:keymember(TPlayerId, #db_player_black.tplayer_id, PlayerState#player_state.black_friend_list) orelse not util_data:is_null(PlayerState#player_state.server_pass) of
		true ->
			skip;
		_ ->
			Temp = length(PlayerState#player_state.chat_list),
			NewList1 = case Temp > 10 of
						   true ->
							   Bin1 = lists:last(PlayerState#player_state.chat_list),
							   NewList = lists:delete(Bin1, PlayerState#player_state.chat_list),
							   [Bin | NewList];
						   _ ->
							   [Bin | PlayerState#player_state.chat_list]
					   end,

			PlayerState1 = PlayerState#player_state{
				chat_list = NewList1
			},
			{ok, PlayerState1}
	%%net_send:send_one(PlayerState#player_state.socket,Bin)
	end.

send_chat_list(PlayerState, []) ->
	PlayerState#player_state{
		chat_list = []
	};
%% 批量发送聊天信息
send_chat_list(PlayerState, [Bin | H]) ->
	net_send:send_one(PlayerState#player_state.socket, Bin),
	send_chat_list(PlayerState, H).

%% 处理聊天内容、检查玩家物品id
%% 输入，Content::list
handle_content(Content) ->
%% 	Content1 = re:replace(Content, "[\ue415]", "", [unicode, {return, list}]),
%% 	%%Content1 = util_string:check_emoji(bitstring_to_list(Content), []),
%% 	?ERR(" ~ts", [Content1]),
	Content.


%% 私聊返回玩家不在线
chat_in_not_online(State) ->
	Result = ?ERR_PLAYER_LOGOUT,
	net_send:send_to_client(State#player_state.socket, 18004, #rep_friend_chat_result{result = Result}).
%% 工会聊天 如果没有帮会返回 没有帮会
chat_in_not_guild(State) ->
	Result = ?ERR_PLAYER_NOT_JOINED_GUILD,
	net_send:send_to_client(State#player_state.socket, 18004, #rep_friend_chat_result{result = Result}).
%% 队伍聊天 如果没用队伍返回 没有队伍
chat_in_not_team(State) ->
	Result = ?ERR_PLAYERB_TEAM_NOT_EXIST,
	net_send:send_to_client(State#player_state.socket, 18004, #rep_friend_chat_result{result = Result}).


%% 发送公用错误码
send_err_result(PlayerState, Result) ->
	net_send:send_to_client(PlayerState#player_state.socket, 9998, #rep_err_result{result = Result}).

%% 获取发送聊天的相关信息
get_chat_info(State, Content1) ->
	#player_state{
		db_player_base = #db_player_base{guild_id = GuildId, legion_id = LegionId, name = Name, vip = Vip},
		player_id = PlayerId,
		team_id = TeamId
	} = State,
	#proto_world_chat_info{
		player_id = PlayerId,
		player_name = Name,
		vip = Vip,
		time = util_date:unixtime(),
		content = Content1,
		guild_id = GuildId,
		team_id = TeamId,
		legion_id = LegionId
	}.




