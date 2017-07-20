%%%-------------------------------------------------------------------
%%% @author tuhujia
%%% @copyright (C) 2015, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 22. 七月 2015 14:42
%%%-------------------------------------------------------------------
-module(goods_cache).

-include("common.hrl").
-include("cache.hrl").

%% API
-export([
	select_row/2,
	select_all/1,
	insert/1,
	update/3,
	delete/2,
	remove_cache/2
]).


%% ====================================================================
%% API functions
%% ====================================================================
select_row(Id, PlayerId) ->
	db_cache_lib:select_row(?DB_GOODS, {Id, PlayerId}).

select_all(PlayerId) ->
	db_cache_lib:select_all(?DB_GOODS, {'_', PlayerId}).

insert(GoodsInfo) ->
%% 	Id = GoodsInfo#db_goods.id,
%% 	PlayerId = GoodsInfo#db_goods.player_id,
%% 	db_cache_lib:insert(?DB_GOODS, {Id, PlayerId}, GoodsInfo).
	goods_db:insert(GoodsInfo).

update(Id, PlayerId, GoodsInfo) ->
	db_cache_lib:update(?DB_GOODS, {Id, PlayerId}, GoodsInfo).

delete(Id, PlayerId) ->
	db_cache_lib:delete(?DB_GOODS, {Id, PlayerId}).

remove_cache(Id, PlayerId) ->
	db_cache_lib:remove_cache(?DB_GOODS, {Id, PlayerId}).

