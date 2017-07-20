%%%-------------------------------------------------------------------
%%% @author tuhujia
%%% @copyright (C) 2015, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 24. 八月 2015 17:30
%%%-------------------------------------------------------------------
-module(arena_rank_db).

-include("common.hrl").
-include("cache.hrl").

%% API
-export([
	select_all/0,
	select_row/1,
	insert/1,
	update/2,
	delete/1
]).

%% 最大排名数
-define(MAX_RANK, 10000).

%% ====================================================================
%% API functions
%% ====================================================================
select_all() ->
	case db:select_all(player_arena_rank, record_info(fields, db_arena_rank), [{rank, "<=", ?MAX_RANK}]) of
		[] ->
			[];
		List ->
			Fun = fun([PlayerId, Rank, Name, Sex, Lv, Career, Fighting, GuildId, Extra, UpdateTime]) ->
						List1 = [PlayerId, Rank, Name, Sex, Lv, Career, Fighting, GuildId,
								util_data:string_to_term(Extra), UpdateTime],
						list_to_tuple([db_arena_rank | List1])
				  end,
			[Fun(X) || X <- List]
	end.

select_row(PlayerId) ->
	case db:select_row(player_arena_rank, record_info(fields, db_arena_rank), [{player_id, PlayerId}]) of
		[] ->
			null;
		List ->
			[PlayerId, Rank, Name, Sex, Lv, Career, Fighting, GuildId, Extra, UpdateTime] = List,
			List1 = [PlayerId, Rank, Name, Sex, Lv, Career, Fighting, GuildId,
				util_data:string_to_term(Extra), UpdateTime],
			list_to_tuple([db_arena_record | List1])
	end.

insert(Info) ->
	Extra = Info#db_arena_rank.extra,
	Info1 = Info#db_arena_rank{extra = util_data:term_to_string(Extra)},
	db:insert(player_arena_rank, util_tuple:to_tuple_list(Info1)).

update(PlayerId, Info) ->
	Extra = Info#db_arena_rank.extra,
	Info1 = Info#db_arena_rank{extra = util_data:term_to_string(Extra)},
	db:update(player_arena_rank, util_tuple:to_tuple_list(Info1), [{player_id, PlayerId}]).

delete(PlayerId) ->
	db:delete(player_arena_rank, [{player_id, PlayerId}]).
%% ====================================================================
%% Internal functions
%% ====================================================================
