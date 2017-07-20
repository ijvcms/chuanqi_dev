%%%-------------------------------------------------------------------
%%% @author tuhujia
%%% @copyright (C) 2015, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 05. 十一月 2015 16:47
%%%-------------------------------------------------------------------
-module(guild_shop_cache).

-include("common.hrl").
-include("cache.hrl").
-include("record.hrl").

%% API
-export([
	select_row/2,
	replace/1,
	remove_cache/2
]).


%% ====================================================================
%% API functions
%% ====================================================================
select_row(PlayerId, ShopId) ->
	db_cache_lib:select_row(?DB_PLAYER_GUILD_SHOP, {PlayerId, ShopId}).

replace(Info) ->
	PlayerId = Info#db_player_guild_shop.player_id,
	ShopId = Info#db_player_guild_shop.shop_id,
	db_cache_lib:replace(?DB_PLAYER_GUILD_SHOP, {PlayerId, ShopId}, Info).

remove_cache(PlayerId, ShopId) ->
	db_cache_lib:remove_cache(?DB_PLAYER_GUILD_SHOP, {PlayerId, ShopId}).

%% ====================================================================
