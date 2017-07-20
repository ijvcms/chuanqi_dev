%%%-------------------------------------------------------------------
%%% @author tuhujia
%%% @copyright (C) 2015, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 07. 十二月 2015 10:24
%%%-------------------------------------------------------------------
-module(team_pp).

-include("common.hrl").
-include("record.hrl").
-include("proto.hrl").
-include("cache.hrl").
-include("config.hrl").
-include("language_config.hrl").

%% API
-export([
	handle/3
]).

%% ====================================================================
%% API functions
%% ====================================================================

%% 创建队伍
handle(21000, PlayerState, _Data) ->
	case team_lib:create_team(PlayerState) of
		{ok, PlayerState1} ->
			net_send:send_to_client(PlayerState#player_state.socket, 21000, #rep_create_team{result = ?ERR_COMMON_SUCCESS}),
			{ok, PlayerState1};
		{fail, Reply} ->
			net_send:send_to_client(PlayerState#player_state.socket, 21000, #rep_create_team{result = Reply})
	end;

%% 获取队伍信息
handle(21001, PlayerState, _Data) ->
	case team_lib:get_team_info(PlayerState) of
		{fail, _Reply} ->
			Switch_1 = PlayerState#player_state.team_switch_1,
			Switch_2 = PlayerState#player_state.team_switch_2,
			net_send:send_to_client(PlayerState#player_state.socket, 21001,
				#rep_team_info{switch1 = Switch_1, switch2 = Switch_2});
		_ ->
			skip
	end;

%% 设置组队开关
handle(21002, PlayerState, #req_team_switch{switch_type = Type, status = Status}) ->
	PlayerState1 = team_lib:set_team_switch(PlayerState, Type, Status),
	net_send:send_to_client(PlayerState1#player_state.socket, 21002, #rep_team_switch{switch_type = Type, status = Status}),
	{ok, PlayerState1};

%% 邀请玩家加入队伍
handle(21004, PlayerState, #req_invite_join_team{player_id = PlayerId}) ->
	case team_lib:invite_team(PlayerState, PlayerId) of
		{fail, Reply} ->
			net_send:send_to_client(PlayerState#player_state.socket, 21004,
				#rep_invite_join_team{result = Reply});
		_ ->
			skip
	end;

%% 玩家是否同意加入队伍
handle(21006, PlayerState, #req_agree_join_team{team_id = TeamId, type = Type, player_id = InviteId}) ->
	case team_lib:agree_team_invite(PlayerState, TeamId, Type, InviteId) of
		{fail, Reply} ->
			net_send:send_to_client(PlayerState#player_state.socket, 21006,
				#rep_agree_join_team{result = Reply});
		{ok, TeamPid} ->
			PlayerState1 = #player_state{team_id = TeamId, leader = 0, team_pid = TeamPid},
			player_lib:update_player_state(PlayerState, PlayerState1);
		_ ->
			skip
	end;

%% 玩家申请加入队伍
handle(21007, PlayerState, #req_apply_join_team{team_id = TeamId}) ->
	{_, Reply} = team_lib:apply_join_team(PlayerState, TeamId),
	net_send:send_to_client(PlayerState#player_state.socket, 21007, #rep_apply_join_team{result = Reply});

%% 队长是否同意申请
handle(21009, PlayerState, #req_agree_apply_team{player_id = PlayerId, type = Type}) ->
	case team_lib:agree_apply_team(PlayerState, PlayerId, Type) of
		{fail, Reply} ->
			net_send:send_to_client(PlayerState#player_state.socket, 21009,
				#rep_agree_apply_team{result = Reply});
		_ ->
			skip
	end;

%% 获取附近玩家信息
handle(21010, PlayerState, _Data) ->
	case PlayerState#player_state.scene_pid of
		ScenePid when is_pid(ScenePid) ->
			Socket = PlayerState#player_state.socket,
			PlayerId = PlayerState#player_state.player_id,
			scene_send_lib:send_scene_near_player_info(ScenePid, PlayerId, Socket);
		_ ->
			skip
	end;

%% 获取附近队伍信息
handle(21011, PlayerState, _Data) ->
	case PlayerState#player_state.scene_pid of
		ScenePid when is_pid(ScenePid) ->
			Socket = PlayerState#player_state.socket,
			PlayerId = PlayerState#player_state.player_id,
			scene_send_lib:send_scene_near_team_info(ScenePid, PlayerId, Socket);
		_ ->
			skip
	end;

%% 转移队长
handle(21012, PlayerState, #req_change_team{player_id = PlayerId}) ->
	case team_lib:change_team_leader(PlayerState, PlayerId) of
		{fail, Reply} ->
			net_send:send_to_client(PlayerState#player_state.socket, 21012,
				#rep_change_team{result = Reply});
		{ok, _} ->
			PlayerState1 = PlayerState#player_state{leader = 0},
			player_lib:update_player_state(PlayerState, PlayerState1),
			{ok, PlayerState1}
	end;

%% 踢出队伍
handle(21013, PlayerState, #req_remove_team{player_id = PlayerId}) ->
	{_, Reply} = team_lib:remove_team(PlayerState, PlayerId),
	net_send:send_to_client(PlayerState#player_state.socket, 21013, #rep_remove_team{result = Reply});


%% 解散队伍
handle(21014, PlayerState, _Data) ->
	{_, Reply} = team_lib:clear_team(PlayerState),
	net_send:send_to_client(PlayerState#player_state.socket, 21014, #rep_clear_team{result = Reply});

%% 离开队伍
handle(21015, PlayerState, _Data) ->
	{_, Reply} = team_lib:leave_team(PlayerState),
	net_send:send_to_client(PlayerState#player_state.socket, 21015, #rep_leave_team{result = Reply});

%% 传送到队长身边
handle(21017, PlayerState, _Data) ->
	case team_lib:transfer_to_leader(PlayerState) of
		{ok, PlayerState1} ->
			net_send:send_to_client(PlayerState#player_state.socket, 21017, #rep_transfer_hz{result = ?ERR_COMMON_SUCCESS}),
			{ok, PlayerState1};
		{fail, Reply} ->
			net_send:send_to_client(PlayerState#player_state.socket, 21017, #rep_transfer_hz{result = Reply})
	end;

handle(Cmd, PlayerState, Data) ->
	?ERR("not define ~p cmd:~nstate: ~p~ndata: ~p", [Cmd, PlayerState, Data]),
	{ok, PlayerState}.