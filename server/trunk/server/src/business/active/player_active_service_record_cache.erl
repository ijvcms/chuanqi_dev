%%%-------------------------------------------------------------------
%%% @author apple
%%% @copyright (C) 2015, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 30. 十一月 2015 19:19
%%%-------------------------------------------------------------------
-module(player_active_service_record_cache).

-include("common.hrl").
-include("cache.hrl").


-export([
    select_row/2,
    select_all/1,
    insert/1,
    delete/2,
    update/2
]).

select_row(TypeId, PlayerId) ->
    db_cache_lib:select_row(?DB_PLAYER_ACTIVE_SERVICE_RECORD, {TypeId, PlayerId}).

select_all(TypeId) ->
    db_cache_lib:select_all(?DB_PLAYER_ACTIVE_SERVICE_RECORD, {TypeId, '_'}).

insert(RecordInfo) ->
    TypeId = RecordInfo#db_player_active_service_record.active_service_type_id,
    PlayerId = RecordInfo#db_player_active_service_record.player_id,
    db_cache_lib:insert(?DB_PLAYER_ACTIVE_SERVICE_RECORD, {TypeId, PlayerId}, RecordInfo).

update({TypeId, PlayerId}, RecordInfo) ->
    db_cache_lib:update(?DB_PLAYER_ACTIVE_SERVICE_RECORD, {TypeId, PlayerId}, RecordInfo).

delete(PlayerId, TypeId) ->
    db_cache_lib:delete(?DB_PLAYER_ACTIVE_SERVICE_RECORD, {TypeId, PlayerId}).

%% API

