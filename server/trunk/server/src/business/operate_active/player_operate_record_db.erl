%%%-------------------------------------------------------------------
%%% @author tuhujia
%%% @copyright (C) 2016, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 07. 七月 2016 09:51
%%%-------------------------------------------------------------------
-module(player_operate_record_db).

-include("common.hrl").
-include("cache.hrl").
-include("record.hrl").

%% API
-export([
	select_all/1,
	select_row/1,
	replace/1,
	delete/1,
	insert/1,
	update/2
]).

%% ====================================================================
%% API functions
%% ====================================================================
select_all({PlayerId, '_', '_'}) ->
	case db:select_all(player_operate_record, record_info(fields, db_player_operate_record), [{player_id, PlayerId}]) of
		[] ->
			[];
		List ->
			[list_to_tuple([db_player_operate_record | X]) || X <- List]
	end.

select_row({PlayerId, ActiveId, Type}) ->
	case db:select_row(player_operate_record, record_info(fields, db_player_operate_record), [{player_id, PlayerId}, {active_id, ActiveId}, {finish_limit_type, Type}]) of
		[] ->
			null;
		Info ->
			list_to_tuple([db_player_operate_record | Info])
	end.

replace(Info) ->
	db:replace(player_operate_record, util_tuple:to_tuple_list(Info)).

delete({PlayerId, ActiveId, Type}) ->
	db:delete(player_operate_record, [{player_id, PlayerId}, {active_id, ActiveId}, {finish_limit_type, Type}]).

insert(Info) ->
	db:insert(player_operate_record, util_tuple:to_tuple_list(Info)).

update({PlayerId, ActiveId, Type}, Info) ->
	db:update(player_operate_record, util_tuple:to_tuple_list(Info), [{player_id, PlayerId}, {active_id, ActiveId}, {finish_limit_type, Type}]).

%% ====================================================================
%% Internal functions
%% ====================================================================
