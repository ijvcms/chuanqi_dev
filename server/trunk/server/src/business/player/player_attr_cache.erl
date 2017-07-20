%%%-------------------------------------------------------------------
%%% @author zhengsiying
%%% @copyright (C) 2015, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 11. 八月 2015 下午3:12
%%%-------------------------------------------------------------------
-module(player_attr_cache).

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
	db_cache_lib:select_row(?DB_PLAYER_ATTR, PlayerId).

insert(PlayerAttr) ->
	db_cache_lib:insert(?DB_PLAYER_ATTR, PlayerAttr#db_player_attr.player_id, PlayerAttr).

update(PlayerId, UpdatePlayerAttr) ->
	db_cache_lib:update(?DB_PLAYER_ATTR, PlayerId, UpdatePlayerAttr).

remove_cache(PlayerId) ->
	db_cache_lib:remove_cache(?DB_PLAYER_ATTR, PlayerId).

%% ====================================================================
%% Internal functions
%% ====================================================================
