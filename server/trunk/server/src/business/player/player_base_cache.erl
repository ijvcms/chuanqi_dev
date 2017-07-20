%%%-------------------------------------------------------------------
%%% @author zhengsiying
%%% @copyright (C) 2015, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 21. 七月 2015 下午5:46
%%%-------------------------------------------------------------------
-module(player_base_cache).

-include("common.hrl").
-include("cache.hrl").

%% API
-export([
	select_row/1,
	insert/1,
	update/2,
	remove_cache/1
]).

%% ====================================================================
%% API functions
%% ====================================================================
select_row(PlayerId) ->
	db_cache_lib:select_row(?DB_PLAYER_BASE, PlayerId).

insert(PlayerBase) ->
	%%db_cache_lib:insert(?DB_PLAYER_BASE, PlayerBase#db_player_base.player_id, PlayerBase),
	player_base_db:insert(PlayerBase).

update(PlayerId, UpdatePlayerBase) ->
	db_cache_lib:update(?DB_PLAYER_BASE, PlayerId, UpdatePlayerBase).

remove_cache(PlayerId) ->
	db_cache_lib:remove_cache(?DB_PLAYER_BASE, PlayerId).

%% ====================================================================
%% Internal functions
%% ====================================================================
