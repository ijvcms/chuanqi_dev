%%%-------------------------------------------------------------------
%%% @author apple
%%% @copyright (C) 2015, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 30. 十一月 2015 19:19
%%%-------------------------------------------------------------------
-module(player_sale_cache).

-include("common.hrl").
-include("cache.hrl").


-export([
	select_row/2,
	select_all/1,
	insert/1,
	delete/2,
	update/2
]).

select_row(Id,PlayerId) ->
	db_cache_lib:select_row(?DB_PLAYER_SALE, {Id,PlayerId}).

select_all(PlayerId) ->
	db_cache_lib:select_all(?DB_PLAYER_SALE, {'_', PlayerId}).

insert(PlayerSaleInfo) ->
	Id = PlayerSaleInfo#db_player_sale.id,
	db_cache_lib:insert(?DB_PLAYER_SALE, {Id,PlayerSaleInfo#db_player_sale.player_id}, PlayerSaleInfo).

update(Id, PlayerSaleInfo) ->
	db_cache_lib:update(?DB_PLAYER_SALE, {Id,PlayerSaleInfo#db_player_sale.player_id}, PlayerSaleInfo).

delete(Id,PlayerId) ->
	db_cache_lib:delete(?DB_PLAYER_SALE, {Id,PlayerId}).

%% API

