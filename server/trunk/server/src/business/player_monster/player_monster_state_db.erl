%%%-------------------------------------------------------------------
%%% @author qhb
%%% @copyright (C) 2016, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 04. 八月 2016 下午3:49
%%%-------------------------------------------------------------------
-module(player_monster_state_db).
-include("cache.hrl").

%% API
-export([
	select_row/1,
	insert/1,
	update/2,
	replace/1,
	delete/1
]).



select_row(PlayerId) ->
	case db:select_row(player_monster_state, record_info(fields, db_player_monster_state), [{player_id, PlayerId}]) of
		[] ->
			null;
		List ->
			Rec = list_to_tuple([db_player_monster_state | List]),
			MonsterState = util_data:string_to_term(Rec#db_player_monster_state.monster_state),
			Rec#db_player_monster_state{monster_state = MonsterState}
	end.

insert(Rec) ->
	MonsterState = util_data:term_to_string(Rec#db_player_monster_state.monster_state),
	Rec1 = Rec#db_player_monster_state{monster_state = MonsterState},
	db:insert(player_monster_state, util_tuple:to_tuple_list(Rec1)).

delete(PlayerId) ->
	db:delete(player_monster_state, [{player_id, PlayerId}]).

update(PlayerId, Rec) ->
	MonsterState = util_data:term_to_string(Rec#db_player_monster_state.monster_state),
	Rec1 = Rec#db_player_monster_state{monster_state = MonsterState},
	db:update(player_monster_state, util_tuple:to_tuple_list(Rec1), [{player_id, PlayerId}]).

replace(Rec) ->
	MonsterState = util_data:term_to_string(Rec#db_player_monster_state.monster_state),
	Rec1 = Rec#db_player_monster_state{monster_state = MonsterState},
	db:replace(player_monster_state, util_tuple:to_tuple_list(Rec1)).
