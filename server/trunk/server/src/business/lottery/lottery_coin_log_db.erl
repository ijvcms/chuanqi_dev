%%%-------------------------------------------------------------------
%%% @author apple
%%% @copyright (C) 2015, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 30. 十一月 2015 14:11
%%%-------------------------------------------------------------------
-module(lottery_coin_log_db).

-include("common.hrl").
-include("cache.hrl").

%% API
-export([
	select_row/1,
	insert/1,
	select_all/1,
	update/2
]).

%% ====================================================================
%% API functions
%% ====================================================================

select_row(Id) ->
	case db:select_row(lottery_coin_log, record_info(fields, db_lottery_coin_log), [{id, Id}]) of
		[] ->
			null;
		List ->
			list_to_tuple([db_lottery_coin_log | List])
	end.

select_all(Id) ->
	case Id =:= 0 of
		true ->
			Sql = lists:concat([" select * from lottery_coin_log  order by id desc limit 20"]),
			List = db:select_all(Sql),
			[list_to_tuple([db_lottery_coin_log | X]) || X <- List];
		_ ->
			Sql = lists:concat([" select * from lottery_coin_log where id<", Id, " order by id desc limit 20"]),
			List = db:select_all(Sql),
			[list_to_tuple([db_lottery_coin_log | X]) || X <- List]
	end.

update(Id, LotteryLogInfo) ->
	db:update(lottery_coin_log, util_tuple:to_tuple_list(LotteryLogInfo), [{id, Id}]).

insert(LotteryLogInfo) ->
	db:insert(lottery_coin_log, util_tuple:to_tuple_list(LotteryLogInfo)).

