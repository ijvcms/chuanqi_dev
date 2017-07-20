%%%-------------------------------------------------------------------
%%% @author tuhujia
%%% @copyright (C) 2015, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 22. 七月 2015 14:56
%%%-------------------------------------------------------------------
-module(goods_db).

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
	case db:select_row(player_goods, record_info(fields, db_goods), [{id, Id}, {player_id, PlayerId}]) of
		[] ->
			null;
		List ->
			DbGoods = list_to_tuple([db_goods | List]),
			DbGoods#db_goods{extra = util_data:string_to_term(DbGoods#db_goods.extra)}
	end.

select_all({'_', PlayerId}) ->
	case db:select_all(player_goods, record_info(fields, db_goods), [{player_id, PlayerId}]) of
		[] ->
			[];
		List ->
			Fun = fun(List1) ->
					DbGoods = list_to_tuple([db_goods | List1]),
					DbGoods#db_goods{extra = util_data:string_to_term(DbGoods#db_goods.extra)}
				  end,
			[Fun(X) || X <- List]
	end.

insert(GoodsInfo) ->
	Extra = GoodsInfo#db_goods.extra,
	GoodsInfo1 = GoodsInfo#db_goods{extra = util_data:term_to_string(Extra)},
	db:insert(player_goods, util_tuple:to_tuple_list(GoodsInfo1)).

update({Id, PlayerId}, GoodsInfo) ->
	Extra = GoodsInfo#db_goods.extra,
	GoodsInfo1 = GoodsInfo#db_goods{extra = util_data:term_to_string(Extra)},
	db:update(player_goods, util_tuple:to_tuple_list(GoodsInfo1), [{id, Id}, {player_id, PlayerId}]).

delete({Id, PlayerId}) ->
	db:delete(player_goods, [{id, Id}, {player_id, PlayerId}]).
%% ====================================================================
%% Internal functions
%% ====================================================================

