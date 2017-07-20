%%%-------------------------------------------------------------------
%%% @author yubing
%%% @copyright (C) 2015, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 11. 十二月 2015 11:44
%%%-------------------------------------------------------------------
-module(player_friend_ask_lib).

-include("common.hrl").
-include("record.hrl").
-include("config.hrl").
-include("cache.hrl").
-include("db_record.hrl").
-include("proto.hrl").
-include("language_config.hrl").
-include("gameconfig_config.hrl").

-export([get_friend_ask_list/1, ok_friend_ask/2, disagree_friend_ask/2, add_friend_ask/2,delete_friend_ask/2]).

%% 获取申请列表
get_friend_ask_list(PlayerId) ->
	FriendAskList = player_friend_ask_cache:get_friend_ask_list(PlayerId),
	F = fun(X) ->
		FBase = player_base_cache:select_row(X#db_player_friend_ask.tplayer_id),
		#proto_relationship_info
		{
			name = FBase#db_player_base.name,
			tplayer_id = FBase#db_player_base.player_id,
			lv = FBase#db_player_base.lv,
			career = FBase#db_player_base.career,
			fight = FBase#db_player_base.fight
		}
	end,
	[F(X) || X <- FriendAskList].

%% 发送申请信息
add_friend_ask(PlayerState,TPlayerId) ->
	Base=PlayerState#player_state.db_player_base,
	FriendList = player_friend_cache:get_friend_list(PlayerState#player_state.player_id),
	case lists:keymember(TPlayerId,#db_player_friend.tplayer_id,FriendList) of
		true->
			?LANGUEGE_RELATIONSHIP1;
		_->
			NowNum = length(FriendList),
			case NowNum >= ?GAMECONFIG_MAX_FRIEND_NUM of
				true ->
					%% 好友已经达到上限了
					?LANGUEGE_RELATIONSHIP2;
				_ ->
					case player_lib:is_online(TPlayerId) of
						false ->
							?LANGUEGE_RELATIONSHIP4;
						_->
							?INFO("24007 ~p",[222]),
							net_send:send_to_client(TPlayerId,24007,#rep_relationship_friend_ask_send{ tplayer_id = PlayerState#player_state.player_id,tname = Base#db_player_base.name }),
							0
					end
			end
	end.


%% 同意玩家的申请
ok_friend_ask(PlayerState,TPlayerId) ->
	PlayerId = PlayerState#player_state.player_id,
	FriendList = player_friend_cache:get_friend_list(PlayerId),
	%% 是否在好友玩家列表中
	case lists:keymember(TPlayerId, #db_player_friend.tplayer_id, FriendList) of
		true ->
			%% 玩家已经在好友列表里面了
			?LANGUEGE_RELATIONSHIP2;
		_ ->
			NowNum = length(FriendList),
			%% 是否超过好友玩家上限
			case NowNum >= ?GAMECONFIG_MAX_FRIEND_NUM of
				true ->
					%% 已经超出好友上限了
					?LANGUEGE_RELATIONSHIP1;
				_ ->
					TFriendList = player_friend_cache:get_friend_list(TPlayerId),
					TNowNum = length(TFriendList),
					%% 判断对方好友上限
					case TNowNum >= ?GAMECONFIG_MAX_FRIEND_NUM of
						true ->
							%% 对方好友已经达到上限了
							?LANGUEGE_RELATIONSHIP3;
						_ ->
							%% 处理 本人关系信息
							player_friend_cache:add_friend_info(PlayerId, TPlayerId),
							player_black_cache:delete(PlayerId, TPlayerId),

							%% 处理 对方的关系信息
							player_friend_cache:add_friend_info(TPlayerId, PlayerId),
							player_black_cache:delete(TPlayerId, PlayerId),

							MyData=#rep_relationship_ref_friend_list{ relationship_list = [ player_friend_lib:get_friend_info_player_id(PlayerState#player_state.player_id) ],type = ?RELATIONSHIP_FRIEND },
							?INFO("24006: ~p ",MyData),
							%% 刷新对方好友列表
							net_send:send_to_client(TPlayerId, 24006,MyData),
							0
					end
			end
	end.

%% 不同意玩家的申请
disagree_friend_ask(PlayerState, TPlayerId) ->
	PlayerId = PlayerState#player_state.player_id,
	player_friend_ask_cache:delete_friend_ask_info(PlayerId, TPlayerId),
	0.

%% 不同意玩家的申请
delete_friend_ask(PlayerId, TPlayerId) ->
	player_friend_ask_cache:delete_friend_ask_info(PlayerId, TPlayerId).
