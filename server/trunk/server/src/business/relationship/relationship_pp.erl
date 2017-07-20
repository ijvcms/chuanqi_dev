%%%-------------------------------------------------------------------
%%% @author tuhujia
%%% @copyright (C) 2015, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 10. 八月 2015 14:39
%%%-------------------------------------------------------------------
-module(relationship_pp).

-include("common.hrl").
-include("record.hrl").
-include("config.hrl").
-include("cache.hrl").
-include("proto.hrl").

-export([handle/3]).

%% 获取玩家相关的关系列表
handle(24000, PlayerState, Data) ->
	%% 1,标示好友，2，表示申请列表，3，标示黑名单，4标示仇人
	PlayerId = PlayerState#player_state.player_id,
	RType = Data#req_relationship_list.type,
	if
		RType =:= ?RELATIONSHIP_FRIEND ->
			FriendList = player_friend_lib:get_friend_list(PlayerId),
			net_send:send_to_client(PlayerState#player_state.socket, 24000, #rep_relationship_list{relationship_list = FriendList, type = RType});
		RType =:= ?RELATIONSHIP_BLACK ->
			BlackList = player_black_lib:get_black_list(PlayerId),
			net_send:send_to_client(PlayerState#player_state.socket, 24000, #rep_relationship_list{relationship_list = BlackList, type = RType});
		true ->
			FoeList = player_foe_lib:get_foe_list(PlayerId),
			net_send:send_to_client(PlayerState#player_state.socket, 24000, #rep_relationship_list{relationship_list = FoeList, type = RType})
	end;

%% 操作列表信息
handle(24001, PlayerState, Data) ->
	%% 1,标示好友，2，表示申请列表，3，标示黑名单，4标示仇人
	PlayerId = PlayerState#player_state.player_id,
	TPlayerId = Data#req_relationship_operate.tplayer_id,
	RType = Data#req_relationship_operate.type,
	if
		RType =:= ?RELATIONSHIP_FRIEND ->
			Result = player_friend_lib:delete_friend(PlayerId, TPlayerId),
			net_send:send_to_client(PlayerState#player_state.socket, 24001, #rep_relationship_operate{result = Result, tplayer_id = TPlayerId, type = RType});
		RType =:= ?RELATIONSHIP_BLACK ->
			{PlayerState1, Result} = player_black_lib:delete_black(PlayerState, TPlayerId),
			net_send:send_to_client(PlayerState#player_state.socket, 24001, #rep_relationship_operate{result = Result, tplayer_id = TPlayerId, type = RType}),
			{ok, PlayerState1};
		true ->
			Result = player_foe_lib:delete_foe(PlayerState, TPlayerId),
			net_send:send_to_client(PlayerState#player_state.socket, 24001, #rep_relationship_operate{result = Result, tplayer_id = TPlayerId, type = RType})
	end;

%% 拉黑 玩家
handle(24002, PlayerState, Data) ->
	TPlayerId = Data#req_relationship_black.tplayer_id,
	{PlayerState1, Result} = player_black_lib:add_black(PlayerState, TPlayerId),
	net_send:send_to_client(PlayerState#player_state.socket, 24002, #rep_relationship_black{result = Result, tplayer_id = TPlayerId}),
	{ok, PlayerState1};

%% 申请 成为好友
handle(24003, PlayerState, Data) ->
	TPlayerId = Data#req_relationship_friend_ask.tplayerId,
	Result = player_friend_ask_lib:add_friend_ask(PlayerState, TPlayerId),
	net_send:send_to_client(PlayerState#player_state.socket, 24003, #rep_relationship_friend_ask{result = Result});

%% 通过id获取玩家的信息
handle(24004, PlayerState, Data) ->
	TPlayerId = Data#req_relationship_playerinfo_playerid.tplayerId,
	case player_base_cache:select_row(TPlayerId) of
		[] ->
			Data1 = #rep_relationship_playerinfo_playerid
			{
				tplayer_id = 0
			},
			net_send:send_to_client(PlayerState#player_state.socket, 24004, Data1);
		Base ->
			Data1 = #rep_relationship_playerinfo_playerid
			{
				name = Base#db_player_base.name,
				lv = Base#db_player_base.lv,
				career = Base#db_player_base.career,
				tplayer_id = Base#db_player_base.player_id
			},
			net_send:send_to_client(PlayerState#player_state.socket, 24004, Data1)
	end;


%% 通过名字获取玩家的信息
handle(24005, PlayerState, Data) ->
	Name = Data#req_relationship_playerinfo_playername.name,
	case player_id_name_lib:get_ets_player_id_name_by_playername(Name) of
		fail ->
			Data1 = #rep_relationship_playerinfo_playername
			{
				tplayer_id = 0
			},
			net_send:send_to_client(PlayerState#player_state.socket, 24005, Data1);
		Ets_Player_Name ->
			Base = player_base_cache:select_row(Ets_Player_Name#ets_player_id_name.player_id),
			Data1 = #rep_relationship_playerinfo_playername
			{
				name = Base#db_player_base.name,
				lv = Base#db_player_base.lv,
				career = Base#db_player_base.career,
				tplayer_id = Base#db_player_base.player_id
			},
			net_send:send_to_client(PlayerState#player_state.socket, 24005, Data1)
	end;

%% 同意好友的申请信息
handle(24008, PlayerState, Data) ->
	TPlayerId = Data#req_relationship_friend_ask_isok.tplayer_id,
	Result = player_friend_ask_lib:ok_friend_ask(PlayerState, TPlayerId),
	net_send:send_to_client(PlayerState#player_state.socket, 24008, #rep_relationship_friend_ask_isok{result = Result});

%% 添加仇人 玩家
handle(24009, PlayerState, Data) ->
	TPlayerId = Data#req_relationship_foe.tplayer_id,
	player_foe_lib:add_foe(PlayerState, TPlayerId),

	net_send:send_to_client(PlayerState#player_state.socket, 24009, #rep_relationship_foe{result = 0, tplayer_id = TPlayerId});

handle(Cmd, State, Data) ->
	?ERR("not define ~p cmd:~nstate: ~p~ndata: ~p", [Cmd, State, Data]),
	{ok, State}.