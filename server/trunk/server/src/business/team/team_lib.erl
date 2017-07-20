%%%-------------------------------------------------------------------
%%% @author tuhujia
%%% @copyright (C) 2015, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 07. 十二月 2015 10:25
%%%-------------------------------------------------------------------
-module(team_lib).

-include("common.hrl").
-include("record.hrl").
-include("proto.hrl").
-include("cache.hrl").
-include("db_record.hrl").
-include("config.hrl").
-include("uid.hrl").
-include("language_config.hrl").
-include("log_type_config.hrl").

%% API
-export([
	player_login/1,
	player_logout/1,
	create_team/1,
	create_and_join_team/4,
	get_team_info/1,
	set_team_switch/3,
	invite_team/2,
	agree_team_invite/4,
	apply_join_team/2,
	agree_apply_team/3,
	change_team_leader/2,
	remove_team/2,
	clear_team/1,
	leave_team/1,
	pack_near_by_team_info/1,
	pack_near_by_player_info/1,
	kill_monster/5,
	delete_player_team_from_ets/1,
	update_player_team_to_ets/2,
	send_team_info/2,
	transfer_to_leader/1,
	get_team_info_from_ets/1,
	update_team_info/1,
	update_team_info/2
]).

%% ====================================================================
%% API functions
%% ====================================================================

%% 玩家上线 初始化玩家队伍信息
player_login(PlayerState) ->
	Base = PlayerState#player_state.db_player_base,
	case scene_config:get(Base#db_player_base.scene_id) of
		#scene_conf{is_cross = IsCross} when IsCross =:= 1 ->
			case cross_lib:send_cross_mfc(?MODULE, player_login, [PlayerState]) of
				#player_state{} = TempState ->
					TempState;
				_ ->
					PlayerState#player_state{team_id = 0, team_pid = 0}%%
			end;
		_ ->
			PlayerId = PlayerState#player_state.player_id,
			case ets:lookup(?ETS_PlAYER_TEAM, PlayerId) of
				[R | _] ->
					TeamId = R#ets_player_team.team_id,
					case get_team_info_from_ets(TeamId) of
						[] ->
							delete_player_team_from_ets(PlayerId),
							PlayerState#player_state{team_id = 0, team_pid = 0};%%
						EtsTeam ->
							TeamPid = EtsTeam#ets_team.team_pid,
							case is_process_alive(TeamPid) of
								true ->
									Socket = PlayerState#player_state.socket,
									DPB = PlayerState#player_state.db_player_base,
									Lv = DPB#db_player_base.lv,
									Fight = DPB#db_player_base.fight,
									gen_server:cast(TeamPid, {'TEAM_BY_PLAYER_LOGIN', PlayerId, PlayerState#player_state.pid, Socket, Lv, Fight}),
									PlayerState#player_state{team_id = TeamId};
								false ->
									delete_player_team_from_ets(PlayerId),
									ets:delete(?ETS_TEAM, TeamId),
									PlayerState#player_state{team_id = 0, team_pid = 0}%%
							end
					end;
				_ ->
					PlayerState#player_state{team_id = 0, team_pid = 0}%%
			end
	end.


%% 玩家下线处理(如果玩家有队伍保留玩家队伍id不离开队伍)
player_logout(PlayerState) ->
	case PlayerState#player_state.team_id > 0 of
		true ->
			TeamId = PlayerState#player_state.team_id,
			case get_team_info_from_ets(TeamId) of
				[] ->
					{fail, ?ERR_TEAM_NOT_EXIST};
				EtsTeam ->
					TeamPid = EtsTeam#ets_team.team_pid,
					case is_pid(TeamPid) of
						true ->
							PlayerId = PlayerState#player_state.player_id,
							DPB = PlayerState#player_state.db_player_base,
							PlayerLv = DPB#db_player_base.lv,
							PlayerFight = DPB#db_player_base.fight,
							gen_server:cast(TeamPid, {'TEAM_BY_PLAYER_LOGOUT', PlayerId, PlayerLv, PlayerFight});
						false ->
							skip
					end
			end;
		false ->
			skip
	end.

%% 创建队伍
create_team(PlayerState) ->
	TeamId = PlayerState#player_state.team_id,
	case TeamId == 0 of
		true ->
			NewTeamId = get_team_uid(),
			case team_mod:create_team(PlayerState, NewTeamId, PlayerState#player_state.pid) of
				{ok, TeamPid} ->
					PlayerState1 = PlayerState#player_state{team_id = NewTeamId, leader = 1, team_pid = TeamPid},
					player_lib:update_player_state(PlayerState, PlayerState1),
					{ok, PlayerState1};
				_ ->
					{fail, ?ERR_COMMON_FAIL}
			end;
		false ->
			{fail, ?ERR_PLAYERB_HAVE_BEEN_TEAM}
	end.

%% 玩家进程调用
create_and_join_team(PlayerState, JoinDBP, JoinSocket, JoinPid) ->
	TeamId = PlayerState#player_state.team_id,
	case TeamId == 0 of
		true ->
			JoinId = JoinDBP#db_player_base.player_id,
			case ets:lookup(?ETS_PlAYER_TEAM, JoinId) of
				[_R | _] ->
					{ok, PlayerState};
				_ ->
					NewTeamId = get_team_uid(),
					case team_mod:create_and_join_team(PlayerState, NewTeamId, PlayerState#player_state.pid, JoinDBP, JoinSocket, JoinPid) of
						{ok, TeamPid} ->
							PlayerState1 = PlayerState#player_state{team_id = NewTeamId, leader = 1, team_pid = TeamPid},
							player_lib:update_player_state(PlayerState, PlayerState1),
							{ok, PlayerState1};
						_ ->
							{ok, PlayerState}
					end
			end;
		false ->
			{ok, PlayerState}
	end.

%% 获取队伍开关与队伍信息
get_team_info(PlayerState) ->
	TeamId = PlayerState#player_state.team_id,
	case TeamId > 0 of
		true ->
			case get_team_info_from_ets(TeamId) of
				#ets_team{} = EtsTeam ->
					TeamPid = EtsTeam#ets_team.team_pid,
					case is_pid(TeamPid) of
						true ->
							gen_server:cast(TeamPid, {'SEND_TEAM_INFO', PlayerState});
						false ->
							{fail, ?ERR_COMMON_FAIL}
					end;
				_ ->
					{fail, ?ERR_COMMON_FAIL}
			end;
		false ->
			{fail, ?ERR_PLAYERB_TEAM_NOT_EXIST}
	end.

%% 设置开关
set_team_switch(PlayerState, Type, Status) when Status == 0 orelse Status == 1 ->
	case Type of
		1 ->
			PlayerState#player_state{team_switch_1 = Status};
		2 ->
			PlayerState#player_state{team_switch_2 = Status}
	end.

%% 邀请玩家入队
invite_team(PlayerState, InviteId) when InviteId =/= PlayerState#player_state.player_id ->
	TeamId = PlayerState#player_state.team_id,
	case TeamId > 0 of
		true ->
			case get_team_info_from_ets(TeamId) of
				[] ->
					{fail, ?ERR_PLAYERB_TEAM_NOT_EXIST};
				R ->
					TeamPid = R#ets_team.team_pid,
					case is_pid(TeamPid) andalso R#ets_team.mb_num < ?MAX_TEAM_MB of
						true ->
							case player_lib:get_player_pid(InviteId) of
								null ->
									{fail, ?ERR_PLAYER_LOGOUT};
								PlayerPid ->
									PlayerId = PlayerState#player_state.player_id,
									DbBase = PlayerState#player_state.db_player_base,
									Name = DbBase#db_player_base.name,
									Socket = PlayerState#player_state.socket,
									gen_server2:cast(PlayerPid, {invite_team_sw, TeamId, Name, Socket, PlayerId}),
									{ok, ?ERR_COMMON_SUCCESS}
							end;
						false ->
							{fail, ?ERR_TEAM_FULL}
					end
			end;
		false ->
			case player_lib:get_player_pid(InviteId) of
				null ->
					{fail, ?ERR_PLAYER_LOGOUT};
				PlayerPid ->
					PlayerId = PlayerState#player_state.player_id,
					DbBase = PlayerState#player_state.db_player_base,
					Name = DbBase#db_player_base.name,
					Socket = PlayerState#player_state.socket,
					gen_server2:cast(PlayerPid, {invite_team_sw, TeamId, Name, Socket, PlayerId}),
					{ok, ?ERR_COMMON_SUCCESS}
			end
	end.

%% 玩家同意加入队伍
agree_team_invite(PlayerState, TeamId, Type, InviteId) ->
	case Type of
		1 ->  %% 同意
			case PlayerState#player_state.team_id == 0 of
				true ->
					%% 添加检测（邀请者如果没有队伍自动创建队伍）
					case get_team_info_from_ets(TeamId) of
						[] ->
							%% 如果对方玩家在线发给对方进程处理(创建 and 加入)
							case player_lib:get_player_pid(InviteId) of
								null ->
									{fail, ?ERR_PLAYER_LOGOUT};
								PlayerPid ->
									DbBase = PlayerState#player_state.db_player_base,
									Socket = PlayerState#player_state.socket,
									gen_server2:cast(PlayerPid, {create_and_join_team, DbBase, Socket, PlayerState#player_state.pid}),
									{fail, ?ERR_COMMON_SUCCESS}
							end;
						EtsTeam ->
							TeamPid = EtsTeam#ets_team.team_pid,
							case is_pid(TeamPid) andalso is_process_alive(TeamPid) of
								true ->
									gen_server:call(TeamPid, {'JOIN_TEAM', PlayerState, PlayerState#player_state.pid});
								false ->
									{fail, ?ERR_COMMON_FAIL}
							end
					end;
				false ->
					{fail, ?ERR_PLAYERB_HAVE_BEEN_TEAM}
			end;
		0 ->  %% 拒绝
			skip
	end.

%% 玩家申请加入队伍
apply_join_team(PlayerState, TeamId) ->
	case TeamId =/= PlayerState#player_state.team_id of
		true ->
			case PlayerState#player_state.team_id > 0 of
				false ->
					case get_team_info_from_ets(TeamId) of
						[] ->
							{fail, ?ERR_PLAYERB_TEAM_NOT_EXIST};
						R ->
							case R#ets_team.mb_num < ?MAX_TEAM_MB of
								true ->
									DbBase = PlayerState#player_state.db_player_base,
									Name = DbBase#db_player_base.name,
									PlayerId = PlayerState#player_state.player_id,
									gen_server2:cast(R#ets_team.pid, {apply_join_team_sw, PlayerId, Name}),
									{ok, ?ERR_COMMON_SUCCESS};
								false ->
									{fail, ?ERR_TEAM_FULL}
							end
					end;
				true ->
					{fail, ?ERR_PLAYERB_HAVE_BEEN_TEAM}
			end;
		false ->
			{fail, ?ERR_COMMON_FAIL}
	end.

%% 队长同意玩家加入队伍
agree_apply_team(PlayerState, PlayerId, Type) when PlayerId =/= PlayerState#player_state.player_id ->
	case Type of
		1 ->  %% 同意
			case PlayerState#player_state.leader == 1 of
				true ->
					TeamId = PlayerState#player_state.team_id,
					case get_team_info_from_ets(TeamId) of
						[] ->
							{fail, ?ERR_TEAM_NOT_EXIST};
						EtsTeam ->
							case player_lib:get_player_pid(PlayerId) of
								null ->
									{fail, ?ERR_PLAYER_LOGOUT};
								PlayerPid ->
									gen_server2:cast(PlayerPid, {join_team, TeamId, EtsTeam#ets_team.team_pid})
							end
					end;
				false ->
					{fail, ?ERR_PLAYER_NOT_HUIZHANG}
			end;
		0 ->  %% 拒绝
			skip
	end.

%% 转移队长
change_team_leader(PlayerState, PlayerId) when PlayerId =/= PlayerState#player_state.player_id ->
	case PlayerState#player_state.leader == 1 of
		true ->
			TeamId = PlayerState#player_state.team_id,
			case get_team_info_from_ets(TeamId) of
				[] ->
					{fail, ?ERR_TEAM_NOT_EXIST};
				EtsTeam ->
					TeamPid = EtsTeam#ets_team.team_pid,
					case is_pid(TeamPid) andalso is_process_alive(TeamPid) of
						true ->
							gen_server:call(TeamPid, {'CHANGE_TEAM_LEADER', PlayerId});
						false ->
							{fail, ?ERR_COMMON_FAIL}
					end
			end;
		false ->
			{fail, ?ERR_PLAYER_NOT_HUIZHANG}
	end.

%% 踢出队伍
remove_team(PlayerState, PlayerId) when PlayerId =/= PlayerState#player_state.player_id ->
	case PlayerState#player_state.leader == 1 of
		true ->
			TeamId = PlayerState#player_state.team_id,
			case get_team_info_from_ets(TeamId) of
				[] ->
					{fail, ?ERR_TEAM_NOT_EXIST};
				EtsTeam ->
					TeamPid = EtsTeam#ets_team.team_pid,
					case is_pid(TeamPid) of
						true ->
							gen_server:cast(TeamPid, {'REMOVE_TEAM', PlayerId}),
							{ok, ?ERR_COMMON_SUCCESS};
						false ->
							{fail, ?ERR_COMMON_FAIL}
					end
			end;
		false ->
			{fail, ?ERR_PLAYERB_NOT_DUIZHANG}
	end.

%% 解散队伍
clear_team(PlayerState) ->
	case PlayerState#player_state.leader == 1 of
		true ->
			TeamId = PlayerState#player_state.team_id,
			case get_team_info_from_ets(TeamId) of
				[] ->
					{fail, ?ERR_TEAM_NOT_EXIST};
				EtsTeam ->
					TeamPid = EtsTeam#ets_team.team_pid,
					case is_pid(TeamPid) of
						true ->
							gen_server:cast(TeamPid, {'CLEAR_TEAM'}),
							{ok, ?ERR_COMMON_SUCCESS};
						false ->
							{fail, ?ERR_COMMON_FAIL}
					end
			end;
		false ->
			{fail, ?ERR_PLAYER_NOT_HUIZHANG}
	end.

%% 离开队伍
leave_team(PlayerState) ->
	case PlayerState#player_state.team_id > 0 of
		true ->
			TeamId = PlayerState#player_state.team_id,
			case get_team_info_from_ets(TeamId) of
				[] ->
					{fail, ?ERR_TEAM_NOT_EXIST};
				EtsTeam ->
					TeamPid = EtsTeam#ets_team.team_pid,
					case is_pid(TeamPid) andalso is_process_alive(TeamPid) of
						true ->
							gen_server:call(TeamPid, {'LEAVE_TEAM', PlayerState#player_state.player_id});
						false ->
							{fail, ?ERR_COMMON_FAIL}
					end
			end;
		false ->
			{fail, ?ERR_PLAYERB_HAVE_BEEN_TEAM}
	end.

%% 队伍击杀怪物
kill_monster(TeamId, SceneId, MonsterId, DropOwnerId, KillPlayerId) ->
	case get_team_info_from_ets(TeamId) of
		[] ->
			skip;
		EtsTeam ->
			TeamPid = EtsTeam#ets_team.team_pid,
			case is_pid(TeamPid) of
				true ->
					gen_server:cast(TeamPid, {'KILL_MONSTER', SceneId, MonsterId, DropOwnerId, KillPlayerId});
				false ->
					skip
			end
	end.

%% 传送到队长身边
transfer_to_leader(PlayerState) ->
	TeamId = PlayerState#player_state.team_id,
	case get_team_info_from_ets(TeamId) of
		[] ->
			{fail, ?ERR_PLAYERB_TEAM_NOT_EXIST};
		EtsTeam ->
			#scene_conf{is_leader_transfer = IsLeaderTransfer} = scene_config:get(PlayerState#player_state.scene_id),
			case IsLeaderTransfer =:= 1 of
				true ->
					case goods_lib:is_goods_enough(?ITEM_FLYING_SHOES, 1) of
						true ->
							LeaderId = EtsTeam#ets_team.leader_id,
							case player_lib:get_player_pid(LeaderId) of
								null ->
									{fail, ?ERR_GOODS_XIAOFEIXIE_NOT_ENOUGH};
								PlayerPid ->
									case gen_server2:apply_sync(PlayerPid, {player_lib, get_scene_xy, []}) of
										{ok, #db_player_base{} = LeaderBase} ->
											%% 传送
											X = LeaderBase#db_player_base.x,
											Y = LeaderBase#db_player_base.y,
											SceneId = LeaderBase#db_player_base.scene_id,

											SceneConf = scene_config:get(SceneId),
											case SceneConf#scene_conf.type =/= ?SCENE_TYPE_INSTANCE andalso
												SceneConf#scene_conf.activity_id =/= ?SCENE_ACTIVITY_SHACHENG andalso
												SceneConf#scene_conf.activity_id =/= ?SCENE_ACTIVITY_PALACE of
												true ->
													case scene_mgr_lib:change_scene(PlayerState, PlayerState#player_state.pid, SceneId, ?CHANGE_SCENE_TYPE_CHANGE, {X, Y}, {?ITEM_FLYING_SHOES, 1, ?LOG_TYPE_TRANSFER}, false) of%%
														{ok, PlayerState1} ->
															{ok, PlayerState1};
														_ ->
															{fail, ?ERR_COMMON_FAIL}
													end;
												false ->
													{fail, ?ERR_COMMON_FAIL}
											end;
										_ ->
											%% 没有该角色
											{fail, ?ERR_COMMON_FAIL}
									end

							end;
						false ->
							{fail, ?ERR_GOODS_XIAOFEIXIE_NOT_ENOUGH}
					end;
				false ->
					{fail, ?ERR_COMMON_FAIL}
			end
	end.

%% 更新玩家队伍信息
update_team_info(PlayerState) ->
	case PlayerState#player_state.team_id > 0 of
		true ->
			TeamId = PlayerState#player_state.team_id,
			case get_team_info_from_ets(TeamId) of
				[] ->
					skip;
				EtsTeam ->
					TeamPid = EtsTeam#ets_team.team_pid,
					update_team_info(PlayerState, TeamPid)
			end;
		false ->
			skip
	end.
%% 更新玩家队伍信息
update_team_info(PlayerState, TeamPid) ->
	case is_pid(TeamPid) of
		true ->
			PlayerId = PlayerState#player_state.player_id,
			DPB = PlayerState#player_state.db_player_base,
			PlayerLv = DPB#db_player_base.lv,
			PlayerFight = DPB#db_player_base.fight,
			SceneId = PlayerState#player_state.scene_id,
			Update = #team_mb{lv = PlayerLv, fight = PlayerFight, scene_id = SceneId},
			gen_server:cast(TeamPid, {'UPDATE_TEAM_MEMBER_INFO', PlayerId, Update});
		false ->
			skip
	end.

%% ====================================================================
%% Server functions
%% ====================================================================

%% 获取队伍记录
get_team_info_from_ets(TeamId) ->
	case ets:lookup(?ETS_TEAM, TeamId) of
		[R | _] ->
			R;
		_ ->
			[]
	end.

%% 获取唯一id
get_team_uid() ->
	uid_lib:get_uid(?UID_TYPE_TEAM).

%% 组包
pack_near_by_team_info(TeamList) ->
	Fun = fun(TeamId, Acc) ->
		case get_team_info_from_ets(TeamId) of
			[] ->
				Acc;
			R ->
				[#proto_near_by_team{
					team_id = TeamId,
					name = R#ets_team.name,
					lv = R#ets_team.lv,
					career = R#ets_team.career,
					memeber_num = R#ets_team.mb_num,
					guild_name = R#ets_team.guild_name}]
				++ Acc
		end
	end,
	lists:foldl(Fun, [], TeamList).

pack_near_by_player_info(ObjList) ->
	Fun = fun(Obj) ->
		#proto_near_by_player{
			player_id = Obj#scene_obj_state.obj_id,
			name = Obj#scene_obj_state.name,
			lv = Obj#scene_obj_state.lv,
			career = Obj#scene_obj_state.career,
			guild_name = guild_lib:get_guild_name(Obj#scene_obj_state.guild_id)
		}
	end,
	[Fun(X) || X <- ObjList, X#scene_obj_state.team_id =:= 0].

delete_player_team_from_ets(PlayerId) ->
	ets:delete(?ETS_PlAYER_TEAM, PlayerId).

update_player_team_to_ets(PlayerId, TeamId) ->
	R = #ets_player_team{player_id = PlayerId, team_id = TeamId},
	ets:insert(?ETS_PlAYER_TEAM, R).

send_team_info(Socket, Proto) ->
	net_send:send_to_client(Socket, 21016, #rep_update_team_info{member_list = Proto}).
