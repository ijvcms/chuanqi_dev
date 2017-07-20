%%%-------------------------------------------------------------------
%%% @author apple
%%% @copyright (C) 2015, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 30. 十一月 2015 14:11
%%%-------------------------------------------------------------------
-module(player_active_service_record_merge_db).

-include("common.hrl").
-include("cache.hrl").

%% API
-export([
    select_row/1,
    select_all/1,
    insert/1,
    update/2,
    delete/1
]).

%% ====================================================================
%% API functions
%% ====================================================================

select_row({TypeId, PlayerId}) ->
    case db:select_row(player_active_service_record_merge, record_info(fields, db_player_active_service_record_merge), [{active_service_merge_type_id, TypeId}, {player_id, PlayerId}]) of
        [] ->
            null;
        List ->
            list_to_tuple([db_player_active_service_record_merge | List])
    end.

select_all({TypeId, '_'}) ->
    case db:select_all(player_active_service_record_merge, record_info(fields, db_player_active_service_record_merge), [{active_service_merge_type_id, TypeId}]) of
        [] ->
            [];
        List ->
            [list_to_tuple([db_player_active_service_record_merge | X]) || X <- List]
    end.

insert(RecordInfo) ->
    db:insert(player_active_service_record_merge, util_tuple:to_tuple_list(RecordInfo)).

update({TypeId, PlayerId}, RecordInfo) ->
    db:update(player_active_service_record_merge, util_tuple:to_tuple_list(RecordInfo), [{active_service_merge_type_id, TypeId}, {player_id, PlayerId}]).

delete({TypeId, PlayerId}) ->
    db:delete(player_active_service_record_merge, [{active_service_merge_type_id, TypeId}, {player_id, PlayerId}]).
%% API

