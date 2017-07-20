%%%-------------------------------------------------------------------
%%% @author yubing
%%% @copyright (C) 2015, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 10. 十二月 2015 20:04
%%%-------------------------------------------------------------------
-module(player_friend_ask_cache).


-include("cache.hrl").
-include("record.hrl").

-export([
	select_row/2,
	select_all/1,
	insert/1,
	delete/2,
	update/3,
	get_friend_ask_list/1,
	add_friend_ask_info/2,
	delete_friend_ask_info/2
]).
%% ====================================================================
%% API functions
%% ====================================================================
select_row(PlayerId, TPlayerId) ->
	db_cache_lib:select_row(?DB_PLAYER_FRIEND_ASK, {PlayerId,TPlayerId}).

select_all(PlayerId) ->
	db_cache_lib:select_all(?DB_PLAYER_FRIEND_ASK, {PlayerId,'_'}).

insert(Info) ->
	PlayerId = Info#db_player_friend_ask.player_id,
	TPlayerId = Info#db_player_friend_ask.tplayer_id,
	db_cache_lib:insert(?DB_PLAYER_FRIEND_ASK, {PlayerId, TPlayerId}, Info).

update(PlayerId, TPlayerId,Info) ->
	db_cache_lib:update(?DB_PLAYER_FRIEND_ASK, {PlayerId, TPlayerId}, Info).

delete(PlayerId, TPlayerId) ->
	db_cache_lib:delete(?DB_PLAYER_FRIEND_ASK, {PlayerId,TPlayerId}).


%% 获取玩家的申请列表
get_friend_ask_list(PlayerId)->
	case relationship_lib:get_ets(PlayerId) of
		[] ->
			select_all(PlayerId);
		Ets->
			Ets#ets_relationship.friend_ask_list
	end.

%% 添加玩家的申请信息
add_friend_ask_info(PlayerId,FriendskInfo)->
	insert(FriendskInfo),
	case relationship_lib:get_ets(PlayerId) of
		[]->
			skip;
		Ets->
			FriendAskList=Ets#ets_relationship.friend_ask_list,
			FriendAskList1 = [FriendskInfo | FriendAskList],
			Ets1=Ets#ets_relationship
			{
				friend_ask_list = FriendAskList1
			},
			relationship_lib:save_ets(Ets1)
	end.

%% 删除玩家的申请信息
delete_friend_ask_info(PlayerId,TPlayerId)->
	delete(PlayerId,TPlayerId),
	case relationship_lib:get_ets(PlayerId) of
		[]->
			skip;
		Ets->
			FriendAskList=Ets#ets_relationship.friend_ask_list,
			FriendAskList1=lists:keydelete(TPlayerId,#db_player_friend_ask.tplayer_id,FriendAskList),
			Ets1=Ets#ets_relationship
			{
				friend_ask_list =FriendAskList1
			},
			relationship_lib:save_ets(Ets1)
	end.
