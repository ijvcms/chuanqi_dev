%%%-------------------------------------------------------------------
%%% @author tuhujia
%%% @copyright (C) 2015, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 07. 十二月 2015 10:24
%%%-------------------------------------------------------------------
-module(team_mod).
-behaviour(gen_server).
%% --------------------------------------------------------------------
%% Include files
%% --------------------------------------------------------------------
-include("common.hrl").
-include("record.hrl").
-include("proto.hrl").
-include("cache.hrl").
-include("db_record.hrl").
-include("config.hrl").
-include("uid.hrl").
-include("language_config.hrl").

%% --------------------------------------------------------------------
%% External exports
-export([
	create_team/3,
	create_and_join_team/6
]).

%% gen_server callbacks
-export([init/1, handle_call/3, handle_cast/2, handle_info/2, terminate/2, code_change/3]).

%% ====================================================================
%% External functions
%% ====================================================================

%% 创建队伍
create_team(PlayerState, TeamId, Pid) ->
	gen_server:start_link(?MODULE, [PlayerState, TeamId, Pid], []).
create_and_join_team(PlayerState, TeamId, Pid, JoinDBP, JoinSocket, JoinPid) ->
	gen_server:start_link(?MODULE, [PlayerState, TeamId, Pid, JoinDBP, JoinSocket, JoinPid], []).


%% ====================================================================
%% Server functions
%% ====================================================================


%% --------------------------------------------------------------------
%% Function: init/1
%% Description: Initiates the server
%% Returns: {ok, State}          |
%%          {ok, State, Timeout} |
%%          ignore               |
%%          {stop, Reason}
%% --------------------------------------------------------------------
init([PlayerState, TeamId, Pid]) ->
	PlayerId = PlayerState#player_state.player_id,
	DbBase = PlayerState#player_state.db_player_base,
	Lv = DbBase#db_player_base.lv,
	Career = DbBase#db_player_base.career,
	Name = DbBase#db_player_base.name,
	GuildId = DbBase#db_player_base.guild_id,
	Fight = DbBase#db_player_base.fight,
	GuildName = guild_lib:get_guild_name(GuildId),
	SceneId = PlayerState#player_state.scene_id,

	EtsTeam = #ets_team{
		team_id = TeamId,            %% 队长id
		leader_id = PlayerId,        %% 队长pid
		pid = Pid,
		name = Name,                %% 队长名字
		lv = Lv,                    %% 队长等级
		career = Career,            %% 队长职业
		guild_name = GuildName,        %% 队长帮会名
		mb_num = 1,                    %% 队伍人数
		team_pid = self()            %% 队伍pid
	},

	State = #team{
		team_id = TeamId,
		leader_id = PlayerId,      %% 队长id
		leader_pid = Pid,            %% 队长pid
		mb = [#team_mb{
			player_id = PlayerId,      %% 玩家id
			name = Name,               %% 名字
			lv = Lv,                   %% 等级
			career = Career,           %% 职业
			guild_name = GuildName,    %% 帮会名
			player_pid = Pid,
			fight = Fight,
			is_online = 1,
			scene_id = SceneId,
			socket = PlayerState#player_state.socket
		}]
	},
	ets:insert(?ETS_TEAM, EtsTeam),
	broadcast_team_member_info(State),
	team_lib:update_player_team_to_ets(PlayerId, TeamId),
	{ok, State};

init([PlayerState, TeamId, Pid, JoinDBP, JoinSocket, JoinPid]) ->
	JoinId = JoinDBP#db_player_base.player_id,
	case ets:lookup(?ETS_PlAYER_TEAM, JoinId) of
		[_R | _] ->
			init([PlayerState, TeamId, Pid]);
		_ ->
			PlayerId = PlayerState#player_state.player_id,
			DbBase = PlayerState#player_state.db_player_base,
			Lv = DbBase#db_player_base.lv,
			Career = DbBase#db_player_base.career,
			Name = DbBase#db_player_base.name,
			GuildId = DbBase#db_player_base.guild_id,
			Fight = DbBase#db_player_base.fight,
			GuildName = guild_lib:get_guild_name(GuildId),
			SceneId = PlayerState#player_state.scene_id,

			EtsTeam = #ets_team{
				team_id = TeamId,            %% 队长id
				leader_id = PlayerId,        %% 队长pid
				pid = Pid,
				name = Name,                %% 队长名字
				lv = Lv,                    %% 队长等级
				career = Career,            %% 队长职业
				guild_name = GuildName,        %% 队长帮会名
				mb_num = 2,                    %% 队伍人数
				team_pid = self()            %% 队伍pid
			},

			State = #team{
				team_id = TeamId,
				leader_id = PlayerId,      %% 队长id
				leader_pid = Pid,            %% 队长pid
				mb =
				[#team_mb{
					player_id = PlayerId,      %% 玩家id
					name = Name,               %% 名字
					lv = Lv,                   %% 等级
					career = Career,           %% 职业
					guild_name = GuildName,    %% 帮会名
					player_pid = Pid,
					fight = Fight,
					is_online = 1,
					scene_id = SceneId,
					socket = PlayerState#player_state.socket},
					#team_mb{
						player_id = JoinDBP#db_player_base.player_id,      %% 玩家id
						name = JoinDBP#db_player_base.name,               %% 名字
						lv = JoinDBP#db_player_base.lv,                   %% 等级
						career = JoinDBP#db_player_base.career,           %% 职业
						guild_name = guild_lib:get_guild_name(JoinDBP#db_player_base.guild_id),    %% 帮会名
						player_pid = JoinPid,
						fight = JoinDBP#db_player_base.fight,
						is_online = 1,
						scene_id = JoinDBP#db_player_base.scene_id,
						socket = JoinSocket}
				]
			},
			ets:insert(?ETS_TEAM, EtsTeam),

			gen_server2:cast(JoinPid, {update_team_info, TeamId, 0, self()}),
			broadcast_team_member_info(State),
			boradcast_member(State, 21003, #rep_team_notice{type = 1, value = JoinDBP#db_player_base.name}),

			team_lib:update_player_team_to_ets(PlayerId, TeamId),
			team_lib:update_player_team_to_ets(JoinDBP#db_player_base.player_id, TeamId),
			{ok, State}
	end.

%% --------------------------------------------------------------------
%% Function: handle_call/3
%% Description: Handling call messages
%% Returns: {reply, Reply, State}          |
%%          {reply, Reply, State, Timeout} |
%%          {noreply, State}               |
%%          {noreply, State, Timeout}      |
%%          {stop, Reason, Reply, State}   | (terminate/2 is called)
%%          {stop, Reason, State}            (terminate/2 is called)
%% --------------------------------------------------------------------
%% 玩家同意加入队伍
handle_call({'JOIN_TEAM', PlayerState, Pid}, _From, State) ->
	case length(State#team.mb) < ?MAX_TEAM_MB of
		true ->
			PlayerId = PlayerState#player_state.player_id,
			DbBase = PlayerState#player_state.db_player_base,
			Lv = DbBase#db_player_base.lv,
			Career = DbBase#db_player_base.career,
			Name = DbBase#db_player_base.name,
			GuildId = DbBase#db_player_base.guild_id,
			GuildName = guild_lib:get_guild_name(GuildId),
			Fight = DbBase#db_player_base.fight,
			SceneId = PlayerState#player_state.scene_id,

			Mb = #team_mb{
				player_id = PlayerId,      %% 玩家id
				name = Name,                %% 名字
				lv = Lv,                    %% 等级
				career = Career,            %% 职业
				fight = Fight,                %% 战斗力
				is_online = 1,                %% 在线状态
				guild_name = GuildName,    %% 帮会名
				player_pid = Pid,
				scene_id = SceneId,
				socket = PlayerState#player_state.socket
			},

			NewMb = [Mb] ++ State#team.mb,
			ets:update_element(?ETS_TEAM, State#team.team_id, {#ets_team.mb_num, length(NewMb)}),
			NewState = State#team{mb = NewMb},
			boradcast_member(NewState, 21003, #rep_team_notice{type = 1, value = Name}),
			broadcast_team_member_info(NewState),
			team_lib:update_player_team_to_ets(PlayerId, State#team.team_id),
			{reply, {ok, self()}, NewState};
		false ->
			{reply, {fail, ?ERR_TEAM_FULL}, State}
	end;

%% 队长移交
handle_call({'CHANGE_TEAM_LEADER', PlayerId}, _From, State) ->
	case State#team.leader_id =:= PlayerId of
		false ->
			MB = State#team.mb,
			case lists:keyfind(PlayerId, #team_mb.player_id, MB) of
				false ->
					{reply, {fail, ?ERR_COMMON_FAIL}, State};
				TeamMb ->
					%% 通知对方变更属性
					gen_server2:cast(TeamMb#team_mb.player_pid, {update_team_info, State#team.team_id, 1, self()}),
					%% boradcast_member(State, 21003, #rep_team_notice{type = 4, value = TeamMb#team_mb.name}),
					ets:update_element(?ETS_TEAM, State#team.team_id,
						[{#ets_team.leader_id, TeamMb#team_mb.player_id},
							{#ets_team.pid, TeamMb#team_mb.player_pid},
							{#ets_team.name, TeamMb#team_mb.name},
							{#ets_team.lv, TeamMb#team_mb.lv},
							{#ets_team.career, TeamMb#team_mb.career},
							{#ets_team.guild_name, TeamMb#team_mb.guild_name}
						]),
					NewState = State#team{leader_id = TeamMb#team_mb.player_id, leader_pid = TeamMb#team_mb.player_pid},
					broadcast_team_member_info(NewState),
					{reply, {ok, ?ERR_COMMON_SUCCESS}, NewState}
			end;
		true ->
			{reply, {fail, ?ERR_COMMON_FAIL}, State}
	end;

%% 离开队伍
handle_call({'LEAVE_TEAM', PlayerId}, _From, State) ->
	case State#team.leader_id =:= PlayerId of
		true ->  %% 队长离开要移交队长
			MB = State#team.mb,
			case lists:keyfind(PlayerId, #team_mb.player_id, MB) of
				false ->
					{reply, {fail, ?ERR_COMMON_FAIL}, State};
				TeamMb ->
					NewMb = lists:delete(TeamMb, MB),
					NewState = State#team{mb = NewMb},
					case length(NewMb) > 0 andalso check_member_is_online(NewState) of
						true ->
							[LeaderMb | _] = [X || X <- NewMb, (X#team_mb.is_online == 1 andalso X#team_mb.player_id =/= PlayerId)],
							%% 委任新队长
							NewState1 = NewState#team{mb = NewMb, leader_id = LeaderMb#team_mb.player_id, leader_pid = LeaderMb#team_mb.player_pid},
							gen_server2:cast(LeaderMb#team_mb.player_pid, {update_team_info, State#team.team_id, 1, self()}),
							gen_server2:cast(TeamMb#team_mb.player_pid, {update_team_info, 0, 0, 0}),
							%% boradcast_member(NewState1, 21003, #rep_team_notice{type = 4, value = LeaderMb#team_mb.name}),
							%% boradcast_member(NewState1, 21003, #rep_team_notice{type = 2, value = TeamMb#team_mb.name}),
							broadcast_team_member_info(NewState1),
							ets:update_element(?ETS_TEAM, State#team.team_id,
								[{#ets_team.leader_id, LeaderMb#team_mb.player_id},
									{#ets_team.pid, LeaderMb#team_mb.player_pid},
									{#ets_team.name, LeaderMb#team_mb.name},
									{#ets_team.lv, LeaderMb#team_mb.lv},
									{#ets_team.career, LeaderMb#team_mb.career},
									{#ets_team.guild_name, LeaderMb#team_mb.guild_name},
									{#ets_team.mb_num, length(NewMb)}
								]),
							{reply, {ok, ?ERR_COMMON_SUCCESS}, NewState1};
						false ->
							gen_server:cast(self(), {'CLEAR_TEAM'}),
							{reply, {ok, ?ERR_COMMON_SUCCESS}, State}
					end
			end;
		false ->
			MB = State#team.mb,
			case lists:keyfind(PlayerId, #team_mb.player_id, MB) of
				false ->
					{reply, {fail, ?ERR_COMMON_FAIL}, State};
				TeamMb ->
					NewMb = lists:delete(TeamMb, MB),
					NewState = State#team{mb = NewMb},
					case length(NewMb) > 0 andalso check_member_is_online(NewState) of
						true ->
							gen_server2:cast(TeamMb#team_mb.player_pid, {update_team_info, 0, 0, 0}),
							%% boradcast_member(NewState, 21003, #rep_team_notice{type = 2, value = TeamMb#team_mb.name}),
							broadcast_team_member_info(NewState),
							ets:update_element(?ETS_TEAM, State#team.team_id, {#ets_team.mb_num, length(NewMb)}),
							{reply, {ok, ?ERR_COMMON_SUCCESS}, NewState};
						false ->
							gen_server:cast(self(), {'CLEAR_TEAM'}),
							{reply, {ok, ?ERR_COMMON_SUCCESS}, State}
					end
			end
	end;

handle_call(_Request, _From, State) ->
	Reply = ok,
	{reply, Reply, State}.

%% --------------------------------------------------------------------
%% Function: handle_cast/2
%% Description: Handling cast messages
%% Returns: {noreply, State}          |
%%          {noreply, State, Timeout} |
%%          {stop, Reason, State}            (terminate/2 is called)
%% --------------------------------------------------------------------
%% 查看队伍信息
handle_cast({'SEND_TEAM_INFO', PlayerState}, State) ->
	Switch_1 = PlayerState#player_state.team_switch_1,
	Switch_2 = PlayerState#player_state.team_switch_2,
	PackMember = pack_member(State#team.mb, State#team.leader_id),
	net_send:send_to_client(PlayerState#player_state.pid, 21001,
		#rep_team_info{switch1 = Switch_1, switch2 = Switch_2, member_list = PackMember}),
	{noreply, State};

%% 协议相关
handle_cast({'SEND_CMD', Cmd, Proto}, State) ->
	boradcast_member(State, Cmd, Proto),
	{noreply, State};

%% 踢出玩家
handle_cast({'REMOVE_TEAM', PlayerId}, State) ->
	case State#team.leader_id =:= PlayerId of
		false ->
			MB = State#team.mb,
			case lists:keyfind(PlayerId, #team_mb.player_id, MB) of
				false ->
					{noreply, State};
				TeamMb ->
					%% 通知对方变更属性
					case TeamMb#team_mb.is_online == 1 of
						true ->
							gen_server2:cast(TeamMb#team_mb.player_pid, {update_team_info, 0, 0, 0});
						false ->
							team_lib:delete_player_team_from_ets(PlayerId)
					end,
					%% boradcast_member(State, 21003, #rep_team_notice{type = 3, value = TeamMb#team_mb.name}),
					NewMb = lists:delete(TeamMb, MB),
					ets:update_element(?ETS_TEAM, State#team.team_id, {#ets_team.mb_num, length(NewMb)}),
					NewState = State#team{mb = NewMb},
					broadcast_team_member_info(NewState),
					{noreply, NewState}
			end;
		true ->
			{noreply, State}
	end;

%% 离开队伍
handle_cast({'LEAVE_TEAM', PlayerId}, State) ->
	case State#team.leader_id =:= PlayerId of
		true ->  %% 队长离开要移交队长
			MB = State#team.mb,
			case lists:keyfind(PlayerId, #team_mb.player_id, MB) of
				false ->
					{noreply, State};
				TeamMb ->
					NewMb = lists:delete(TeamMb, MB),
					NewState = State#team{mb = NewMb},
					case length(NewMb) > 0 andalso check_member_is_online(NewState) of
						true ->
							[LeaderMb | _] = [X || X <- NewMb, (X#team_mb.is_online == 1 andalso X#team_mb.player_id =/= PlayerId)],
							%% 委任新队长
							NewState1 = NewState#team{mb = NewMb, leader_id = LeaderMb#team_mb.player_id, leader_pid = LeaderMb#team_mb.player_pid},
							gen_server2:cast(LeaderMb#team_mb.player_pid, {update_team_info, State#team.team_id, 1, self()}),
							%% boradcast_member(NewState, 21003, #rep_team_notice{type = 4, value = LeaderMb#team_mb.name}),
							%% boradcast_member(NewState, 21003, #rep_team_notice{type = 2, value = TeamMb#team_mb.name}),
							broadcast_team_member_info(NewState1),
							ets:update_element(?ETS_TEAM, State#team.team_id,
								[{#ets_team.leader_id, LeaderMb#team_mb.player_id},
									{#ets_team.pid, LeaderMb#team_mb.player_pid},
									{#ets_team.name, LeaderMb#team_mb.name},
									{#ets_team.lv, LeaderMb#team_mb.lv},
									{#ets_team.career, LeaderMb#team_mb.career},
									{#ets_team.guild_name, LeaderMb#team_mb.guild_name},
									{#ets_team.mb_num, length(NewMb)}
								]),
							{noreply, NewState1};
						false ->
							gen_server:cast(self(), {'CLEAR_TEAM'}),
							{noreply, State}
					end
			end;
		false ->
			MB = State#team.mb,
			case lists:keyfind(PlayerId, #team_mb.player_id, MB) of
				false ->
					{noreply, State};
				TeamMb ->
					NewMb = lists:delete(TeamMb, MB),
					NewState = State#team{mb = NewMb},
					case length(NewMb) > 0 andalso check_member_is_online(NewState) of
						true ->
							gen_server2:cast(TeamMb#team_mb.player_pid, {update_team_info, 0, 0, 0}),
							%% boradcast_member(NewState, 21003, #rep_team_notice{type = 2, value = TeamMb#team_mb.name}),
							broadcast_team_member_info(NewState),
							ets:update_element(?ETS_TEAM, State#team.team_id, {#ets_team.mb_num, length(NewMb)}),
							{noreply, NewState};
						false ->
							gen_server:cast(self(), {'CLEAR_TEAM'}),
							{noreply, State}
					end
			end
	end;

%% 解散队伍
handle_cast({'CLEAR_TEAM'}, State) ->
	%% boradcast_member(State, 21003, #rep_team_notice{type = 3, value = ""}),
	{stop, normal, State};

%% 击杀怪物经验平分
handle_cast({'KILL_MONSTER', SceneId, MonsterId, DropOwnerId, KillPlayerId}, State) ->
	MB = State#team.mb,
	MemberList =
		case lists:keyfind(KillPlayerId, #team_mb.player_id, MB) of
			false ->
				gen_server2:cast(player_lib:get_player_pid(KillPlayerId), {update_team_info, 0, 0, 0}),
				MB;
			TeamMb ->
				case TeamMb#team_mb.scene_id == SceneId of
					true ->
						MB;
					false ->
						NewTeamMb = TeamMb#team_mb{scene_id = SceneId},
						NewMb = lists:keyreplace(KillPlayerId, #team_mb.player_id, MB, NewTeamMb),
						NewMb
				end
		end,

	%% 先找出相同场景的队友
	MemberList1 = [X || X <- MemberList, X#team_mb.scene_id == SceneId],
	MemberNum = length(MemberList1),

	%% boss首杀活动
	active_ets:save_kill_team(MonsterId, DropOwnerId, MemberList1),
	%% 合服首杀boss
	active_merge_ets:save_kill_team(MonsterId, DropOwnerId, MemberList1),
	Fun = fun(R) ->
		PlayerPid = R#team_mb.player_pid,
		MonsterConf = monster_config:get(MonsterId),
		MonsterExp = MonsterConf#monster_conf.exp,
		AddExp = util_math:floor(MonsterExp * (MemberNum + 9) / (10 * MemberNum)),
		player_lib:kill_monster_by_team(PlayerPid, SceneId, MonsterId, AddExp)
	end,
	lists:foreach(Fun, MemberList1),
	{noreply, State#team{mb = MemberList}};

%% 玩家离线处理
handle_cast({'TEAM_BY_PLAYER_LOGOUT', PlayerId, PlayerLv, PlayerFight}, State) ->
	case State#team.leader_id =:= PlayerId of
		true ->  %% 队长离开要移交队长
			MB = State#team.mb,
			case lists:keyfind(PlayerId, #team_mb.player_id, MB) of
				false ->
					{noreply, State};
				TeamMb ->
					NewMb = lists:keyreplace(PlayerId, #team_mb.player_id, MB, TeamMb#team_mb{is_online = 0, lv = PlayerLv, fight = PlayerFight}),
					NewState = State#team{mb = NewMb},
					case length(NewMb) > 1 andalso check_member_is_online(NewState) of
						true ->
							[LeaderMb | _] = [X || X <- NewMb, (X#team_mb.is_online == 1 andalso X#team_mb.player_id =/= PlayerId)],
							%% 委任新队长
							NewState1 = NewState#team{mb = NewMb, leader_id = LeaderMb#team_mb.player_id, leader_pid = LeaderMb#team_mb.player_pid},
							gen_server2:cast(LeaderMb#team_mb.player_pid, {update_team_info, State#team.team_id, 1, self()}),
							%% boradcast_member(NewState, 21003, #rep_team_notice{type = 4, value = LeaderMb#team_mb.name}),
							%% boradcast_member(NewState, 21003, #rep_team_notice{type = 2, value = TeamMb#team_mb.name}),
							broadcast_team_member_info(NewState1),
							ets:update_element(?ETS_TEAM, State#team.team_id,
								[{#ets_team.leader_id, LeaderMb#team_mb.player_id},
									{#ets_team.pid, LeaderMb#team_mb.player_pid},
									{#ets_team.name, LeaderMb#team_mb.name},
									{#ets_team.lv, LeaderMb#team_mb.lv},
									{#ets_team.career, LeaderMb#team_mb.career},
									{#ets_team.guild_name, LeaderMb#team_mb.guild_name},
									{#ets_team.mb_num, length(NewMb)}
								]),
							{noreply, NewState1};
						false ->
							gen_server:cast(self(), {'CLEAR_TEAM'}),
							{noreply, State}
					end
			end;
		false ->
			MB = State#team.mb,
			case lists:keyfind(PlayerId, #team_mb.player_id, MB) of
				false ->
					{noreply, State};
				TeamMb ->
					NewMb = lists:keyreplace(PlayerId, #team_mb.player_id, MB, TeamMb#team_mb{is_online = 0, lv = PlayerLv, fight = PlayerFight}),
					NewState = State#team{mb = NewMb},
					case length(NewMb) > 1 andalso check_member_is_online(NewState) of
						true ->
							%% boradcast_member(NewState, 21003, #rep_team_notice{type = 2, value = TeamMb#team_mb.name}),
							broadcast_team_member_info(NewState),
							ets:update_element(?ETS_TEAM, State#team.team_id, {#ets_team.mb_num, length(NewMb)}),
							{noreply, NewState};
						false ->
							gen_server:cast(self(), {'CLEAR_TEAM'}),
							{noreply, State}
					end
			end
	end;

%% 玩家上线处理
handle_cast({'TEAM_BY_PLAYER_LOGIN', PlayerId, Pid, Socket, Lv, Fight}, State) ->
	MB = State#team.mb,
	case lists:keyfind(PlayerId, #team_mb.player_id, MB) of
		false ->
			{noreply, State};
		TeamMb ->
			NewMb = lists:keyreplace(PlayerId, #team_mb.player_id, MB,
				TeamMb#team_mb{socket = Socket, player_pid = Pid, is_online = 1, lv = Lv, fight = Fight}),
			NewState = State#team{mb = NewMb},
			case length(NewMb) > 0 of
				true ->
					%% boradcast_member(NewState, 21003, #rep_team_notice{type = 2, value = TeamMb#team_mb.name}),
					broadcast_team_member_info(NewState),
					ets:update_element(?ETS_TEAM, State#team.team_id, {#ets_team.mb_num, length(NewMb)}),
					{noreply, NewState};
				false ->
					gen_server:cast(self(), {'CLEAR_TEAM'}),
					{noreply, State}
			end
	end;

%% 更新玩家信息
handle_cast({'UPDATE_TEAM_MEMBER_INFO', PlayerId, Update}, State) ->
	MB = State#team.mb,
	case lists:keyfind(PlayerId, #team_mb.player_id, MB) of
		false ->
			{noreply, State};
		TeamMb ->
			NewTeamMb = util_tuple:copy_elements(TeamMb, Update),
			NewMb = lists:keyreplace(PlayerId, #team_mb.player_id, MB, NewTeamMb),
			NewState = State#team{mb = NewMb},
			{noreply, NewState}
	end;

handle_cast(_Msg, State) ->
	{noreply, State}.

%% --------------------------------------------------------------------
%% Function: handle_info/2
%% Description: Handling all non call/cast messages
%% Returns: {noreply, State}          |
%%          {noreply, State, Timeout} |
%%          {stop, Reason, State}            (terminate/2 is called)
%% --------------------------------------------------------------------
handle_info(_Info, State) ->
	{noreply, State}.

%% --------------------------------------------------------------------
%% Function: terminate/2
%% Description: Shutdown the server
%% Returns: any (ignored by gen_server)
%% --------------------------------------------------------------------
terminate(_Reason, State) ->
	%% 通知队伍所有玩家变更state
	clear_team(State#team.mb),
	TeamId = State#team.team_id,
	ets:delete(?ETS_TEAM, TeamId),
	ok.

%% --------------------------------------------------------------------
%% Func: code_change/3
%% Purpose: Convert process state when code is changed
%% Returns: {ok, NewState}
%% --------------------------------------------------------------------
code_change(_OldVsn, State, _Extra) ->
	{ok, State}.

%% --------------------------------------------------------------------
%%% Internal functions
%% --------------------------------------------------------------------

%% 组装队员列表
pack_member(MemberList, LeaderId) when is_list(MemberList) ->
	Fun = fun(R) ->
		#proto_team_member_info{
			player_id = R#team_mb.player_id,
			name = R#team_mb.name,
			type = case LeaderId =:= R#team_mb.player_id of true -> 1; false -> 0 end,
			lv = R#team_mb.lv,
			career = R#team_mb.career,
			is_online = R#team_mb.is_online,
			fight = R#team_mb.fight,
			guild_name = R#team_mb.guild_name
		}
	end,
	[Fun(X) || X <- MemberList].

%% 队伍相关通知
boradcast_member(State, Cmd, Proto) ->
	MemberList = State#team.mb,
	Fun = fun(R) ->
		Socket = R#team_mb.player_pid,
		net_send:send_to_client(Socket, Cmd, Proto)
	end,
	lists:foreach(Fun, [X || X <- MemberList, X#team_mb.is_online == 1]).

%% 队伍解散
clear_team(MemberList) ->
	Fun = fun(R) ->
		case R#team_mb.is_online == 1 of
			true ->
				gen_server2:cast(R#team_mb.player_pid, {update_team_info, 0, 0, 0});
			_ ->
				skip
		end,
		team_lib:delete_player_team_from_ets(R#team_mb.player_id)
	end,
	lists:foreach(Fun, MemberList).

%% 推送最新的队伍信息
broadcast_team_member_info(State) ->
	PackMember = pack_member(State#team.mb, State#team.leader_id),
	MemberList = State#team.mb,
	Fun = fun(R) ->
		Socket = R#team_mb.player_pid,
		net_send:send_to_client(Socket, 21016, #rep_update_team_info{member_list = PackMember})
	end,
	lists:foreach(Fun, MemberList).

%% 检查队伍成员是否全部离线
check_member_is_online(State) ->
	MemberList = State#team.mb,
	case lists:keyfind(1, #team_mb.is_online, MemberList) of
		false ->
			false;
		_ ->
			true
	end.