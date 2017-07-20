%%%-------------------------------------------------------------------
%%% @author tuhujia
%%% @copyright (C) 2015, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 27. 八月 2015 14:09
%%%-------------------------------------------------------------------
-module(player_mystery_shop_db).

-include("common.hrl").
-include("cache.hrl").

%% API
-export([
	select_row/1,
	insert/1,
	update/2,
	delete/1,
	select_all/1
]).

%% ====================================================================
%% API functions
%% ====================================================================
select_row({PlayerId,Id}) ->
	case db:select_row(player_mystery_shop, record_info(fields, db_player_mystery_shop), [{player_id, PlayerId},{id, Id}]) of
		[] ->
			null;
		List ->
			list_to_tuple([db_player_mystery_shop | List])
	end.

select_all({PlayerId,'_'}) ->
	case db:select_all(player_mystery_shop, record_info(fields, db_player_mystery_shop), [{player_id, PlayerId}]) of
		[] ->
			[];
		List ->
			[list_to_tuple([db_player_mystery_shop | X]) || X <- List]
	end.

insert(Info) ->
	db:insert(player_mystery_shop, util_tuple:to_tuple_list(Info)).

update({PlayerId,Id}, MysteryInfo) ->
	db:update(player_mystery_shop, util_tuple:to_tuple_list(MysteryInfo), [{player_id, PlayerId},{id, Id}]).

delete({PlayerId,Id}) ->
	db:delete(player_mystery_shop, [{id, Id}, {player_id, PlayerId}]).
%% ====================================================================
%% Internal functions
%% ====================================================================