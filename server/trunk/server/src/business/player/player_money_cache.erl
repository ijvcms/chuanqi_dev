%%%-------------------------------------------------------------------
%%% @author zhengsiying
%%% @copyright (C) 2015, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 23. 七月 2015 上午10:05
%%%-------------------------------------------------------------------
-module(player_money_cache).

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
	db_cache_lib:select_row(?DB_PLAYER_MONEY, PlayerId).

insert(PlayerMoney) ->
	db_cache_lib:insert(?DB_PLAYER_MONEY, PlayerMoney#db_player_money.player_id, PlayerMoney).

update(PlayerId, UpdatePlayerMoney) ->
	db_cache_lib:update(?DB_PLAYER_MONEY, PlayerId, UpdatePlayerMoney).

remove_cache(PlayerId) ->
	db_cache_lib:remove_cache(?DB_PLAYER_MONEY, PlayerId).

%% ====================================================================
%% Internal functions
%% ====================================================================
