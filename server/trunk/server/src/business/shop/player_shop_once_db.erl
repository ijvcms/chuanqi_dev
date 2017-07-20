%%%-------------------------------------------------------------------
%%% @author qhb
%%% @copyright (C) 2016, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 23. 九月 2016 上午11:12
%%%-------------------------------------------------------------------
-module(player_shop_once_db).
-include("common.hrl").
-include("cache.hrl").


%% API
-export([
	insert/1,
	update/2,
	delete/1,
	select_row/1,
	select_all/1
]).


insert(Info) ->
	db:insert(player_shop_once, util_tuple:to_tuple_list(Info)).

update({PlayerId, Lv, Pos}, Info) ->
	db:update(player_shop_once, util_tuple:to_tuple_list(Info), [{player_id, PlayerId}, {lv, Lv}, {pos, Pos}]).

delete({PlayerId, Lv, Pos}) ->
	db:delete(player_mystery_shop, [{player_id, PlayerId}, {lv, Lv}, {pos, Pos}]).

select_row({PlayerId, Lv, Pos}) ->
	case db:select_row(player_shop_once, record_info(fields, db_player_shop_once), [{player_id, PlayerId}, {lv, Lv}, {pos, Pos}]) of
		[] ->
			null;
		List ->
			list_to_tuple([db_player_shop_once | List])
	end.

select_all({PlayerId, Lv, '_'}) ->
	case db:select_all(player_shop_once, record_info(fields, db_player_shop_once), [{player_id, PlayerId}, {lv, Lv}]) of
		[] ->
			[];
		List ->
			[list_to_tuple([db_player_shop_once | X]) || X <- List]
	end.