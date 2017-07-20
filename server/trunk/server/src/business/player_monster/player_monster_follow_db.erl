%%%-------------------------------------------------------------------
%%% @author qhb
%%% @copyright (C) 2016, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 04. 八月 2016 下午3:49
%%%-------------------------------------------------------------------
-module(player_monster_follow_db).
-include("db_record.hrl").

%% API
-export([
	select_all/1,
	select_player_id/2,
	insert/1,
	delete/3,
	replace/1
]).



select_all(PlayerId) ->
	case db:select_all(player_monster_follow, record_info(fields, db_player_monster_follow), [{player_id, PlayerId}]) of
		[] ->
			[];
		List ->
			[list_to_tuple([db_player_monster_follow | Info]) || Info <- List]
	end.

select_player_id(SceneId, MonsterId) ->
	case db:select_all(player_monster_follow, [player_id], [{scene_id, SceneId}, {monster_id, MonsterId}]) of
		[] ->
			[];
		List ->
			lists:flatten(List)
	end.

insert(PlayerMonsterFollow) ->
	db:insert(player_monster_follow, util_tuple:to_tuple_list(PlayerMonsterFollow)).

delete(SecneId, MonsterId, PlayerId) ->
	db:delete(player_monster_follow, [{scene_id, SecneId}, {monster_id, MonsterId}, {player_id, PlayerId}]).

replace(PlayerMonsterFollow) ->
	db:replace(player_monster_follow, util_tuple:to_tuple_list(PlayerMonsterFollow)).
