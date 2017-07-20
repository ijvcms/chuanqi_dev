%%%-------------------------------------------------------------------
%%% @author apple
%%% @copyright (C) 2015, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 30. 十一月 2015 14:11
%%%-------------------------------------------------------------------
-module(player_monster_merge_db).

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

select_row({MonsterId, PlayerId}) ->
	case db:select_row(player_monster_merge, record_info(fields, db_player_monster_merge), [{monster_id, MonsterId}, {player_id, PlayerId}]) of
		[] ->
			null;
		List ->
			list_to_tuple([db_player_monster_merge | List])
	end.

select_all({'_','_'}) ->
	case db:select_all(player_monster_merge, record_info(fields, db_player_monster_merge), []) of
		[] ->
			[];
		List ->
			[list_to_tuple([db_player_monster_merge | X]) || X <- List]
	end.

insert(PlayerMonsterInfo) ->
	db:insert(player_monster_merge, util_tuple:to_tuple_list(PlayerMonsterInfo)).

update({MonsterId, PlayerId}, PlayerMonsterInfo) ->
	db:update(player_monster_merge, util_tuple:to_tuple_list(PlayerMonsterInfo), [{monster_id, MonsterId}, {player_id, PlayerId}]).

delete({MonsterId, PlayerId}) ->
	db:delete(player_monster_merge, [{monster_id, MonsterId}, {player_id, PlayerId}]).
%% API

