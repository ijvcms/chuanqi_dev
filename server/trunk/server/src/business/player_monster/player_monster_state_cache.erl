%%%-------------------------------------------------------------------
%%% @author qhb
%%% @copyright (C) 2016, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 12. 八月 2016 上午9:27
%%%-------------------------------------------------------------------
-module(player_monster_state_cache).
-include("common.hrl").
-include("cache.hrl").

%% API
-export([
	select_row/1,
	insert/1,
	update/1,
	delete/1
]).


select_row(PlayerId) ->
	db_cache_lib:select_row(?DB_PLAYER_MONSTER_STATE, PlayerId).

insert(Rec) ->
	db_cache_lib:insert(?DB_PLAYER_MONSTER_STATE, Rec#db_player_monster_state.player_id, Rec).

update(Rec) ->
	db_cache_lib:update(?DB_PLAYER_MONSTER_STATE, Rec#db_player_monster_state.player_id, Rec).

delete(PlayerId) ->
	db_cache_lib:delete(?DB_PLAYER_MONSTER_STATE, PlayerId).
