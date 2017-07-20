%%%-------------------------------------------------------------------
%%% @author apple
%%% @copyright (C) 2015, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 30. 十一月 2015 14:11
%%%-------------------------------------------------------------------
-module(player_package_db).

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

select_row({Lv, PlayerId}) ->
	case db:select_row(player_package, record_info(fields, db_player_package), [{lv, Lv}, {player_id, PlayerId}]) of
		[] ->
			null;
		List ->
			list_to_tuple([db_player_package | List])
	end.

select_all({'_', PlayerId}) ->
	case db:select_all(player_package, record_info(fields, db_player_package), [{player_id, PlayerId}]) of
		[] ->
			[];
		List ->
			[list_to_tuple([db_player_package | X]) || X <- List]
	end.

insert(PackageInfo) ->
	db:insert(player_package, util_tuple:to_tuple_list(PackageInfo)).

update({Lv, PlayerId}, PackageInfo) ->
	db:update(player_package, util_tuple:to_tuple_list(PackageInfo), [{lv, Lv}, {player_id, PlayerId}]).

delete({Lv, PlayerId}) ->
	db:delete(player_package, [{lv, Lv}, {player_id, PlayerId}]).
%% API

