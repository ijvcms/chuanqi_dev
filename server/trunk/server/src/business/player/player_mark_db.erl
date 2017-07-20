%%%-------------------------------------------------------------------
%%% @author tuhujia
%%% @copyright (C) 2016, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 08. 六月 2016 10:20
%%%-------------------------------------------------------------------
-module(player_mark_db).

-include("common.hrl").
-include("cache.hrl").

%% API
-export([
	select_row/1,
	insert/1,
	update/2
]).

%% ====================================================================
%% API functions
%% ====================================================================
select_row(PlayerId) ->
	case db:select_row(player_mark, record_info(fields, db_player_mark), [{player_id, PlayerId}]) of
		[] ->
			null;
		List ->
			list_to_tuple([db_player_mark | List])
	end.

insert(PlayerMark) ->
	db:insert(player_mark, util_tuple:to_tuple_list(PlayerMark)).

update(PlayerId, PlayerMark) ->
	db:update(player_mark, util_tuple:to_tuple_list(PlayerMark), [{player_id, PlayerId}]).

%% ====================================================================
%% Internal functions
%% ====================================================================
