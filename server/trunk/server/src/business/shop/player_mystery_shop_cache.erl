%%%-------------------------------------------------------------------
%%% @author tuhujia
%%% @copyright (C) 2015, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 27. 八月 2015 14:10
%%%-------------------------------------------------------------------
-module(player_mystery_shop_cache).

-include("common.hrl").
-include("cache.hrl").
-include("record.hrl").
-include("config.hrl").
-include("language_config.hrl").

%% API
-export([
	select_row/1,
	insert/1,
	update/2,
	delete/1,
	select_all/1
]).

%% ====================================================================
%% API functions
%% ====================================================================
select_row({PlayerId,Id}) ->
	db_cache_lib:select_row(?DB_PLAYER_MYSTERY_SHOP, {PlayerId,Id}).

select_all(PlayerId) ->
	db_cache_lib:select_all(?DB_PLAYER_MYSTERY_SHOP, {PlayerId,'_'}).

insert(Info) ->
	Id = Info#db_player_mystery_shop.id,
	PlayerId = Info#db_player_mystery_shop.player_id,
	db_cache_lib:insert(?DB_PLAYER_MYSTERY_SHOP, {PlayerId,Id}, Info).

update({PlayerId,Id}, Info) ->
	db_cache_lib:update(?DB_PLAYER_MYSTERY_SHOP, {PlayerId,Id}, Info).

delete({PlayerId,Id}) ->
	db_cache_lib:delete(?DB_PLAYER_MYSTERY_SHOP,{PlayerId,Id}).
