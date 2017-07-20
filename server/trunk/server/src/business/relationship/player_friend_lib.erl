%%%-------------------------------------------------------------------
%%% @author yubing
%%% @copyright (C) 2015, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 11. 十二月 2015 11:45
%%%-------------------------------------------------------------------
-module(player_friend_lib).


-include("common.hrl").
-include("record.hrl").
-include("config.hrl").
-include("cache.hrl").
-include("db_record.hrl").
-include("proto.hrl").
-include("gameconfig_config.hrl").
-include("language_config.hrl").

-export([get_friend_list/1,
get_friend_info_player_id/1,
get_friend_info_player_state/1,
	delete_friend/2]).

%% 获取好友列表
get_friend_list(PlayerId) ->
	FriendList = player_friend_cache:get_friend_list(PlayerId),
	[get_friend_info_player_id(X#db_player_friend.tplayer_id) || X <- FriendList].

%% 获取客户端需要的好友信息
 get_friend_info_player_id(PlayerId) ->
	FBase = player_base_cache:select_row(PlayerId),
	#proto_relationship_info
	{
		name = FBase#db_player_base.name,
		tplayer_id = FBase#db_player_base.player_id,
		lv = FBase#db_player_base.lv,
		career = FBase#db_player_base.career,
		fight = FBase#db_player_base.fight,
		last_offline_time = FBase#db_player_base.last_logout_time,
		isonline = player_lib:is_online_int(PlayerId)
	}.
%% 获取客户端需要的好友信息
get_friend_info_player_state(FBase) ->
	#proto_relationship_info
	{
		name = FBase#db_player_base.name,
		tplayer_id = FBase#db_player_base.player_id,
		lv = FBase#db_player_base.lv,
		career = FBase#db_player_base.career,
		fight = FBase#db_player_base.fight,
		last_offline_time = FBase#db_player_base.last_logout_time,
		isonline = player_lib:is_online_int(FBase#db_player_base.player_id)
	}.


%% 删除玩家好友
delete_friend(PlayerId, TPlayerId) ->
	player_friend_cache:delete_friend_info(PlayerId, TPlayerId),
	player_friend_cache:delete_friend_info(TPlayerId, PlayerId),
	0.

