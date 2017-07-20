%%%-------------------------------------------------------------------
%%% @author qhb
%%% @copyright (C) 2016, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 04. 八月 2016 下午5:22
%%%-------------------------------------------------------------------
-module(player_monster_drop_db).
-include("common.hrl").
-include("db_record.hrl").

%% API
-export([
	select_new/0,
	insert/1
]).

select_new() ->
	case db:select_all(player_monster_drop, record_info(fields, db_player_monster_drop), [], [{id, desc}], [30]) of
		[] ->
			[];
		List ->
			[list_to_tuple([db_player_monster_drop | Info]) || Info <- List]
	end.

insert(PlayerMonsterDrop) ->
	db:insert(player_monster_drop, util_tuple:to_tuple_list(PlayerMonsterDrop)).