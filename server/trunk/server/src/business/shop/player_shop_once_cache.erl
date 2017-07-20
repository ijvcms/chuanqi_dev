%%%-------------------------------------------------------------------
%%% @author qhb
%%% @copyright (C) 2016, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 23. 九月 2016 上午11:43
%%%-------------------------------------------------------------------
-module(player_shop_once_cache).
-include("common.hrl").
-include("cache.hrl").

%% API
-export([
	insert/1,
	update/2,
	delete/1,
	select_row/1,
	select_all/1
]).

insert(Info) ->
	PlayerId = Info#db_player_shop_once.player_id,
	Lv = Info#db_player_shop_once.lv,
	Pos = Info#db_player_shop_once.pos,
	db_cache_lib:insert(?DB_PLAYER_SHOP_ONCE, {PlayerId, Lv, Pos}, Info).

update({PlayerId, Lv, Pos}, Info) ->
	db_cache_lib:update(?DB_PLAYER_SHOP_ONCE, {PlayerId, Lv, Pos}, Info).

delete({PlayerId, Lv, Pos}) ->
	db_cache_lib:delete(?DB_PLAYER_SHOP_ONCE, {PlayerId, Lv, Pos}).

select_row({PlayerId, Lv, Pos}) ->
	db_cache_lib:select_row(?DB_PLAYER_SHOP_ONCE, {PlayerId, Lv, Pos}).

select_all({PlayerId, Lv, '_'}) ->
	db_cache_lib:select_all(?DB_PLAYER_SHOP_ONCE, {PlayerId, Lv, '_'}).