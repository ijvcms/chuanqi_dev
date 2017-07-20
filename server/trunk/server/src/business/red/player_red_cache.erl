%%%-------------------------------------------------------------------
%%% @author apple
%%% @copyright (C) 2015, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 30. 十一月 2015 19:19
%%%-------------------------------------------------------------------
-module(player_red_cache).

-include("common.hrl").
-include("cache.hrl").


-export([
	select_row/2,
	select_all/1,
	insert/1,
	delete/2,
	update/2
]).

select_row(PlayerId, RedId) ->
	db_cache_lib:select_row(?DB_PLAYER_RED, {RedId, PlayerId}).

select_all({GuildId,Id}) ->
	db_cache_lib:select_all(?DB_PLAYER_RED, {GuildId,Id}).

insert(PlayerRedInfo) ->
	RedId = PlayerRedInfo#db_player_red.red_id,
	PlayerId = PlayerRedInfo#db_player_red.player_id,
	db_cache_lib:insert(?DB_PLAYER_RED, {RedId, PlayerId}, PlayerRedInfo).

update(PlayerId, TaskInfo) ->
	db_cache_lib:update(?DB_PLAYER_RED, {TaskInfo#db_player_red.red_id, PlayerId}, TaskInfo).

delete(PlayerId, RedId) ->
	db_cache_lib:delete(?DB_PLAYER_RED, {RedId, PlayerId}).

%% API

