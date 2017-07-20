%%%-------------------------------------------------------------------
%%% @author tuhujia
%%% @copyright (C) 2016, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 12. 四月 2016 11:16
%%%-------------------------------------------------------------------
-module(player_drop_db).

-include("common.hrl").
-include("cache.hrl").

%% API
-export([
	select_row/1,
	replace/1,
	insert/1,
	update/2
]).

%% ====================================================================
%% API functions
%% ====================================================================
select_row({PlayerId, MonsterId}) ->
	case db:select_row(player_drop, record_info(fields, db_player_drop), [{player_id, PlayerId}, {monster_id, MonsterId}]) of
		[] ->
			null;
		List ->
			list_to_tuple([db_player_drop | List])
	end.

replace(Info) ->
	db:replace(player_drop, util_tuple:to_tuple_list(Info)).

insert(Info) ->
	db:insert(player_drop, util_tuple:to_tuple_list(Info)).

update({PlayerId, MonsterId}, Info) ->
	db:update(player_drop, util_tuple:to_tuple_list(Info), [{player_id, PlayerId}, {monster_id, MonsterId}]).

%% ====================================================================
%% Internal functions
%% ====================================================================
