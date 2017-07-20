%%%-------------------------------------------------------------------
%%% @author yubing
%%% @copyright (C) 2015, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 10. 十二月 2015 20:03
%%%-------------------------------------------------------------------
-module(player_black_cache).

-include("cache.hrl").
-include("record.hrl").

-export([
	select_row/2,
	select_all/1,
	insert/1,
	delete/2,
	update/3,
	get_black_list/1,
	add_black_info/2,
	delete_black_info/2
]).
%% ====================================================================
%% API functions
%% ====================================================================
select_row(PlayerId, TPlayerId) ->
db_cache_lib:select_row(?DB_PLAYER_BLACK, {PlayerId,TPlayerId}).

select_all(PlayerId) ->
	db_cache_lib:select_all(?DB_PLAYER_BLACK, {PlayerId,'_'}).

insert(Info) ->
	PlayerId = Info#db_player_black.player_id,
	TPlayerId = Info#db_player_black.tplayer_id,
	db_cache_lib:insert(?DB_PLAYER_BLACK, {PlayerId, TPlayerId}, Info).

update(PlayerId, TPlayerId,Info) ->
	db_cache_lib:update(?DB_PLAYER_BLACK, {PlayerId, TPlayerId}, Info).

delete(PlayerId, TPlayerId) ->
	db_cache_lib:delete(?DB_PLAYER_BLACK, {PlayerId,TPlayerId}).


%% 获取黑名单列表
get_black_list(PlayerId)->
	case relationship_lib:get_ets(PlayerId) of
		[] ->
			select_all(PlayerId);
		Ets->
			Ets#ets_relationship.black_list
	end.

%% 添加玩家的黑名单信息
add_black_info(PlayerId,TPlayerId)->
	BlackInfo=#db_player_black
	{
		player_id =PlayerId,
		tplayer_id = TPlayerId
	},
	insert(BlackInfo),
	case relationship_lib:get_ets(PlayerId) of
		[] ->
			skip;
		Ets->
			BlackList=Ets#ets_relationship.black_list,
			BlackList1 = [BlackInfo | BlackList],
			Ets1=Ets#ets_relationship
			{
				black_list  = BlackList1
			},
			relationship_lib:save_ets(Ets1)
	end.

%% 删除玩家的黑名单信息
delete_black_info(PlayerId,TPlayerId)->
	delete(PlayerId,TPlayerId),

	case relationship_lib:get_ets(PlayerId) of
		[]->
			skip;
		Ets->
			BlackList=Ets#ets_relationship.black_list,
			BlackList1=lists:keydelete(TPlayerId,#db_player_friend_ask.tplayer_id,BlackList),
			Ets1=Ets#ets_relationship
			{
				black_list =BlackList1
			},
			relationship_lib:save_ets(Ets1)
	end.