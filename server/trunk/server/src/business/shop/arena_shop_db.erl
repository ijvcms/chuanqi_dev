%%%-------------------------------------------------------------------
%%% @author tuhujia
%%% @copyright (C) 2015, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 27. 八月 2015 14:09
%%%-------------------------------------------------------------------
-module(arena_shop_db).

-include("common.hrl").
-include("cache.hrl").

%% API
-export([
	select_row/1,
	insert/1,
	update/2,
	delete/1
]).

%% ====================================================================
%% API functions
%% ====================================================================
select_row({Id, PlayerId}) ->
	case db:select_row(arena_shop, record_info(fields, db_arena_shop), [{id, Id}, {player_id, PlayerId}]) of
		[] ->
			null;
		List ->
			list_to_tuple([db_arena_shop | List])
	end.

insert(Info) ->
	db:insert(arena_shop, util_tuple:to_tuple_list(Info)).

update({Id, PlayerId}, Info) ->
	db:update(arena_shop, util_tuple:to_tuple_list(Info), [{id, Id}, {player_id, PlayerId}]).

delete({Id, PlayerId}) ->
	db:delete(arena_shop, [{id, Id}, {player_id, PlayerId}]).
%% ====================================================================
%% Internal functions
%% ====================================================================