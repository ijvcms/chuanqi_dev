%%%-------------------------------------------------------------------
%%% @author apple
%%% @copyright (C) 2015, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 30. 十一月 2015 19:19
%%%-------------------------------------------------------------------
-module(lottery_coin_db_cache).

-include("common.hrl").
-include("cache.hrl").


-export([
	select_row/1,
	insert/1,
	update/2
]).

select_row(LotteryId) ->
	db_cache_lib:select_row(?DB_LOTTERY_COIN_DB, LotteryId).

update(LotteryId, LotteryInfo) ->
	db_cache_lib:update(?DB_LOTTERY_COIN_DB,LotteryId, LotteryInfo).

insert(LotteryInfo) ->
	LotteryId = LotteryInfo#db_lottery_coin_db.lottery_coin_id,
	db_cache_lib:insert(?DB_LOTTERY_COIN_DB, LotteryId, LotteryInfo).


%% API

