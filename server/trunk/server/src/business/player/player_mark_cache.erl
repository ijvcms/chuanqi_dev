%%%-------------------------------------------------------------------
%%% @author tuhujia
%%% @copyright (C) 2016, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 08. 六月 2016 10:19
%%%-------------------------------------------------------------------
-module(player_mark_cache).

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
	db_cache_lib:select_row(?DB_PLAYER_MARK, PlayerId).

insert(PlayerMark) ->
	db_cache_lib:insert(?DB_PLAYER_MARK, PlayerMark#db_player_mark.player_id, PlayerMark).

update(PlayerId, UpdatePlayerMark) ->
	db_cache_lib:update(?DB_PLAYER_MARK, PlayerId, UpdatePlayerMark).

remove_cache(PlayerId) ->
	db_cache_lib:remove_cache(?DB_PLAYER_MARK, PlayerId).

%% ====================================================================
%% Internal functions
%% ====================================================================
