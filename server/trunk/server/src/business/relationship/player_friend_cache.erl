%%%-------------------------------------------------------------------
%%% @author yubing
%%% @copyright (C) 2015, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 10. 十二月 2015 20:05
%%%-------------------------------------------------------------------
-module(player_friend_cache).


-include("cache.hrl").
-include("record.hrl").
-export([
	select_row/2,
	select_all/1,
	insert/1,
	delete/2,
	update/3,
	get_friend_list/1,
	add_friend_info/2,
	delete_friend_info/2
]).
%% ====================================================================
%% API functions
%% ====================================================================
select_row(PlayerId, TPlayerId) ->
	db_cache_lib:select_row(?DB_PLAYER_FRIEND, {PlayerId, TPlayerId}).

select_all(PlayerId) ->
	db_cache_lib:select_all(?DB_PLAYER_FRIEND, {PlayerId,'_'}).

insert(Info) ->
	PlayerId = Info#db_player_friend.player_id,
	TPlayerId = Info#db_player_friend.tplayer_id,
	db_cache_lib:insert(?DB_PLAYER_FRIEND, {PlayerId, TPlayerId}, Info).

update(PlayerId, TPlayerId, Info) ->
	db_cache_lib:update(?DB_PLAYER_FRIEND, {PlayerId, TPlayerId}, Info).

delete(PlayerId, TPlayerId) ->
	db_cache_lib:delete(?DB_PLAYER_FRIEND, {PlayerId, TPlayerId}).

%% 获取玩家的好友列表
get_friend_list(PlayerId) ->
	case relationship_lib:get_ets(PlayerId) of
		[] ->
			select_all(PlayerId);
		Ets ->
			Ets#ets_relationship.friend_list
	end.

%% 添加玩家的好友信息
add_friend_info(PlayerId, TPlayerId) ->
	FriendInfo = #db_player_friend
	{
		player_id = PlayerId,
		tplayer_id = TPlayerId
	},
	player_friend_cache:insert(FriendInfo),

	case relationship_lib:get_ets(PlayerId) of
		[]->
			skip;
		Ets->
			FriendList = Ets#ets_relationship.friend_list,
			FriendList1 = [FriendInfo | FriendList],
			Ets1 = Ets#ets_relationship
			{
				friend_list = FriendList1
			},
			relationship_lib:save_ets(Ets1)
	end.

%% 删除玩家的好友信息
delete_friend_info(PlayerId, TPlayerId) ->
	player_friend_cache:delete(PlayerId, TPlayerId),
	case relationship_lib:get_ets(PlayerId) of
		[]->
			skip;
		Ets->
			FriendList = Ets#ets_relationship.friend_list,
			FriendList1 = lists:keydelete(TPlayerId, #db_player_friend.tplayer_id, FriendList),
			Ets1 = Ets#ets_relationship
			{
				friend_list = FriendList1
			},
			relationship_lib:save_ets(Ets1)
	end.