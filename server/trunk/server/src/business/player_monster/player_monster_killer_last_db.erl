%%%-------------------------------------------------------------------
%%% @author qhb
%%% @copyright (C) 2016, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 05. 八月 2016 下午7:56
%%%-------------------------------------------------------------------
-module(player_monster_killer_last_db).
-include("common.hrl").
-include("db_record.hrl").

%% API
-export([
	select_all/0,
	replace/1
]).

select_all() ->
	case db:select_all(player_monster_killer_last, record_info(fields, db_player_monster_killer_last), []) of
		[] ->
			[];
		List ->
			[list_to_tuple([db_player_monster_killer_last | Info]) || Info <- List]
	end.

replace(Rec) ->
	db:replace(player_monster_killer_last, util_tuple:to_tuple_list(Rec)).
