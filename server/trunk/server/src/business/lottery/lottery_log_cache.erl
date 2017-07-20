%%%-------------------------------------------------------------------
%%% @author apple
%%% @copyright (C) 2015, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 30. 十一月 2015 19:19
%%%-------------------------------------------------------------------
-module(lottery_log_cache).

-include("common.hrl").
-include("cache.hrl").


-export([
	select_row/1,
	insert/1,
	select_all/1,
	update/2
]).

select_row(Id) ->
	db_cache_lib:select_row(?DB_LOTTERY_LOG, Id).

select_all(Id) ->
	db_cache_lib:select_all(?DB_LOTTERY_LOG,Id).

update(RedId, LotteryLogInfo) ->
	db_cache_lib:update(?DB_LOTTERY_LOG,RedId, LotteryLogInfo).

insert(LotteryLogInfo) ->
	Id = LotteryLogInfo#db_lottery_log.id,
	db_cache_lib:insert(?DB_LOTTERY_LOG, Id, LotteryLogInfo).


%% API

