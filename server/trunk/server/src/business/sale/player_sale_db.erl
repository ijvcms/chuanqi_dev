%%%-------------------------------------------------------------------
%%% @author apple
%%% @copyright (C) 2015, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 30. 十一月 2015 14:11
%%%-------------------------------------------------------------------
-module(player_sale_db).

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

select_row({Id, PlayerId}) ->
	case db:select_row(player_sale, record_info(fields, db_player_sale), [{id, Id}, {player_id, PlayerId}]) of
		[] ->
			null;
		List ->
			Data=list_to_tuple([db_player_sale | List]),
			Data#db_player_sale{
				extra = util_data:string_to_term(Data#db_player_sale.extra)
			}
	end.

select_all({'_', PlayerId}) ->
	case db:select_all(player_sale, record_info(fields, db_player_sale), [{player_id, PlayerId}]) of
		[] ->
			[];
		List ->
			Data=[list_to_tuple([db_player_sale | X]) || X <- List],
			[ X#db_player_sale{extra =  util_data:string_to_term(X#db_player_sale.extra) } || X<-Data]
	end.

insert(PlayerSaleInfo) ->
	Extra = PlayerSaleInfo#db_player_sale.extra,
	PlayerSaleInfo1 = PlayerSaleInfo#db_player_sale{extra = util_data:term_to_string(Extra)},
	db:insert(player_sale, util_tuple:to_tuple_list(PlayerSaleInfo1)).

update({Id, PlayerId}, PlayerSaleInfo) ->
	Extra = PlayerSaleInfo#db_player_sale.extra,
	PlayerSaleInfo1 = PlayerSaleInfo#db_player_sale{extra = util_data:term_to_string(Extra)},
	db:update(player_sale, util_tuple:to_tuple_list(PlayerSaleInfo1), [{id, Id}, {player_id, PlayerId}]).

delete({Id, PlayerId}) ->
	db:delete(player_sale, [{id, Id}, {player_id, PlayerId}]).
%% API

