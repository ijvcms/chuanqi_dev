%%%-------------------------------------------------------------------
%%% @author apple
%%% @copyright (C) 2015, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 30. 十一月 2015 14:11
%%%-------------------------------------------------------------------
-module(lottery_box_db_db).

-include("common.hrl").
-include("cache.hrl").

%% API
-export([
	select_row/1,
	insert/1,
	select_all/0,
	update/2
]).

%% ====================================================================
%% API functions
%% ====================================================================

select_row(LotteryId) ->
	case db:select_row(lottery_box_db, record_info(fields, db_lottery_box_db), [{lottery_id, LotteryId}]) of
		[] ->
			null;
		List ->
			list_to_tuple([db_lottery_box_db | List])
	end.

select_all() ->
	case db:select_all(lottery_box_db, record_info(fields, db_lottery_box_db),[]) of
		[] ->
			[];
		List ->
			[list_to_tuple([db_lottery_box_db | X]) || X <- List]
	end.

update(LotteryId, LotteryInfo) ->
	db:update(lottery_box_db, util_tuple:to_tuple_list(LotteryInfo), [{lottery_id, LotteryId}]).

insert(LotteryInfo) ->
	db:insert(lottery_box_db, util_tuple:to_tuple_list(LotteryInfo)).

