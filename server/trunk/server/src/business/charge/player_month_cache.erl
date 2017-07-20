%%%-------------------------------------------------------------------
%%% @author apple
%%% @copyright (C) 2015, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 30. 十一月 2015 19:19
%%%-------------------------------------------------------------------
-module(player_month_cache).

-include("common.hrl").
-include("cache.hrl").


-export([
	select_row/1,
	select_all/1,
	insert/1,
	delete/1,
	update/2
]).

select_row(PlayerId) ->
	db_cache_lib:select_row(?DB_PLAYER_MONTH,PlayerId).

select_all(PlayerId) ->
	db_cache_lib:select_all(?DB_PLAYER_MONTH,  PlayerId).

insert(PlayerMonthInfo) ->
	PlayerId = PlayerMonthInfo#db_player_month.player_id,
	db_cache_lib:insert(?DB_PLAYER_MONTH, PlayerId, PlayerMonthInfo).

update(PlayerId, PlayerMonthInfo) ->
	db_cache_lib:update(?DB_PLAYER_MONTH, PlayerId, PlayerMonthInfo).

delete(PlayerId) ->
	db_cache_lib:delete(?DB_PLAYER_MONTH, PlayerId).

%% API

