%%%-------------------------------------------------------------------
%%% @author apple
%%% @copyright (C) 2015, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 30. 十一月 2015 14:11
%%%-------------------------------------------------------------------
-module(player_month_db).

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

select_row(PlayerId) ->
	case db:select_row(player_month, record_info(fields, db_player_month), [{player_id, PlayerId}]) of
		[] ->
			null;
		List ->
			list_to_tuple([db_player_month | List])
	end.

select_all(PlayerId) ->
	case db:select_all(player_month, record_info(fields, db_player_month), [{player_id, PlayerId}]) of
		[] ->
			[];
		List ->
			[list_to_tuple([db_player_month | X]) || X <- List]
	end.

insert(PlayerMonthInfo) ->
	db:insert(player_month, util_tuple:to_tuple_list(PlayerMonthInfo)).

update(PlayerId, PlayerMonthInfo) ->
	db:update(player_month, util_tuple:to_tuple_list(PlayerMonthInfo), [{player_id, PlayerId}]).

delete(PlayerId) ->
	db:delete(player_month, [{player_id, PlayerId}]).

%% API

