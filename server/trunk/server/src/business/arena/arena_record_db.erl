%%%-------------------------------------------------------------------
%%% @author tuhujia
%%% @copyright (C) 2015, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 24. 八月 2015 17:38
%%%-------------------------------------------------------------------
-module(arena_record_db).

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
select_row(PlayerId) ->
	case db:select_row(player_arena_record, record_info(fields, db_arena_record), [{player_id, PlayerId}]) of
		[] ->
			null;
		List ->
			[PlayerId, R, MatchList, ArenaList, UpdateTime] = List,
			list_to_tuple([db_arena_record | [PlayerId, R, util_data:string_to_term(MatchList),
			util_data:bitstring_to_term(ArenaList), UpdateTime]])
	end.

insert(Info) ->
	ArenaList = Info#db_arena_record.arena_list,
	MatchList = Info#db_arena_record.match_list,
	Info1 = Info#db_arena_record{arena_list = util_data:term_to_bitstring(ArenaList),
								 match_list = util_data:term_to_string(MatchList)},
	db:insert(player_arena_record, util_tuple:to_tuple_list(Info1)).

update(PlayerId, Info) ->
	ArenaList = Info#db_arena_record.arena_list,
	MatchList = Info#db_arena_record.match_list,
	Info1 = Info#db_arena_record{arena_list = util_data:term_to_bitstring(ArenaList),
								 match_list = util_data:term_to_string(MatchList)},
	db:update(player_arena_record, util_tuple:to_tuple_list(Info1), [{player_id, PlayerId}]).

delete(PlayerId) ->
	db:delete(player_arena_record, [{player_id, PlayerId}]).
%% ====================================================================
%% Internal functions
%% ====================================================================
