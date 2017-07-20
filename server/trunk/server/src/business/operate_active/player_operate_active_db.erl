%%%-------------------------------------------------------------------
%%% @author tuhujia
%%% @copyright (C) 2016, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 07. 七月 2016 09:52
%%%-------------------------------------------------------------------
-module(player_operate_active_db).

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
select_all({PlayerId, '_'}) ->
	case db:select_all(player_operate_active, record_info(fields, db_player_operate_active), [{player_id, PlayerId}]) of
		[] ->
			[];
		List ->
			[list_to_tuple([db_player_operate_active | X]) || X <- List]
	end.

select_row({PlayerId, ActiveId, SubType}) ->
	case db:select_row(player_operate_active, record_info(fields, db_player_operate_active), [{player_id, PlayerId}, {active_id, ActiveId}, {sub_type, SubType}]) of
		[] ->
			null;
		Info ->
			list_to_tuple([db_player_operate_active | Info])
	end.

replace(Info) ->
	db:replace(player_operate_active, util_tuple:to_tuple_list(Info)).

delete({PlayerId, ActiveId, SubType}) ->
	db:delete(player_operate_active, [{player_id, PlayerId}, {active_id, ActiveId}, {sub_type, SubType}]).

insert(Info) ->
	db:insert(player_operate_active, util_tuple:to_tuple_list(Info)).

update({PlayerId, ActiveId, SubType}, Info) ->
	db:update(player_operate_active, util_tuple:to_tuple_list(Info), [{player_id, PlayerId}, {active_id, ActiveId}, {sub_type, SubType}]).

%% ====================================================================
%% Internal functions
%% ====================================================================
