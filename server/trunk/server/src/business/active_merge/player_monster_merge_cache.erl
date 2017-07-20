%%%-------------------------------------------------------------------
%%% @author apple
%%% @copyright (C) 2015, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 30. 十一月 2015 19:19
%%%-------------------------------------------------------------------
-module(player_monster_merge_cache).

-include("common.hrl").
-include("cache.hrl").


-export([
	select_row/2,
	select_all/0,
	insert/1,
	delete/2,
	update/2
]).

select_row(PlayerId, MonsterId) ->
	db_cache_lib:select_row(?DB_PLAYER_MONSTER_MERGE, {MonsterId, PlayerId}).

select_all() ->
	db_cache_lib:select_all(?DB_PLAYER_MONSTER_MERGE, {'_', '_'}).

insert(PlayerMonsterInfo) ->
	MonsterId = PlayerMonsterInfo#db_player_monster_merge.monster_id,
	PlayerId = PlayerMonsterInfo#db_player_monster_merge.player_id,
	db_cache_lib:insert(?DB_PLAYER_MONSTER_MERGE, {MonsterId, PlayerId}, PlayerMonsterInfo).

update({PlayerId, MonsterId}, PlayerMonsterInfo) ->
	db_cache_lib:update(?DB_PLAYER_MONSTER_MERGE, {MonsterId, PlayerId}, PlayerMonsterInfo).

delete(PlayerId, MonsterId) ->
	db_cache_lib:delete(?DB_PLAYER_MONSTER_MERGE, {MonsterId, PlayerId}).

%% API

