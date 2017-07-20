%%%-------------------------------------------------------------------
%%% @author apple
%%% @copyright (C) 2015, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 30. 十一月 2015 14:11
%%%-------------------------------------------------------------------
-module(player_charge_db).

-include("common.hrl").
-include("cache.hrl").

%% API
-export([
	select_row/1,
	select_charge_num/1,
	insert/1,
	update/2,
	delete/1,
	select_byid/1,
	update_byid/2
]).

%% ====================================================================
%% API functions
%% ====================================================================

select_row({Id, PlayerId}) ->
	case db:select_row(player_charge, record_info(fields, db_player_charge), [{id, Id}, {player_id, PlayerId}]) of
		[] ->
			null;
		List ->
			list_to_tuple([db_player_charge | List])
	end.

select_charge_num(PlayerId) ->
	Sql = lists:concat([" select ifnull(sum(rmb),0) from player_charge where player_id=", PlayerId," and state=2"]),
	Data = db:execute(Sql),
	[T | _H] = Data,
	[T1 | _H1] = T,
	T1.

insert(PlayerChargeInfo) ->
	db:insert(player_charge, util_tuple:to_tuple_list(PlayerChargeInfo)).

update({Id, PlayerId}, PlayerChargeInfo) ->
	db:update(player_charge, util_tuple:to_tuple_list(PlayerChargeInfo), [{id, Id}, {player_id, PlayerId}]).

delete({Id, PlayerId}) ->
	db:delete(player_charge, [{id, Id}, {player_id, PlayerId}]).

select_byid(Id) ->
	case db:select_row(player_charge, record_info(fields, db_player_charge), [{id, Id}]) of
		[] ->
			null;
		List ->
			list_to_tuple([db_player_charge | List])
	end.
update_byid(Id, PlayerChargeInfo) ->
	db:update(player_charge, util_tuple:to_tuple_list(PlayerChargeInfo), [{id, Id}]).


%% API

