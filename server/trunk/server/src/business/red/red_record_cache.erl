%%%-------------------------------------------------------------------
%%% @author apple
%%% @copyright (C) 2015, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 30. 十一月 2015 19:19
%%%-------------------------------------------------------------------
-module(red_record_cache).

-include("common.hrl").
-include("cache.hrl").


-export([
	select_row/1,
	insert/1,
	select_all/1,
	update/2
]).

select_row(RedId) ->
	db_cache_lib:select_row(?DB_RED_RECORD, RedId).

select_all({GuildId,RedId}) ->
	db_cache_lib:select_all(?DB_RED_RECORD,{GuildId,RedId}).

update(RedId, RedInfo) ->
	db_cache_lib:update(?DB_RED_RECORD,RedId, RedInfo).

insert(RedInfo) ->
	RedId = RedInfo#db_red_record.red_id,
	db_cache_lib:insert(?DB_RED_RECORD, RedId, RedInfo).


%% API

