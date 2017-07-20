%%%-------------------------------------------------------------------
%%% @author tuhujia
%%% @copyright (C) 2015, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 30. 七月 2015 16:02
%%%-------------------------------------------------------------------
-module(counter_cache).


-include("common.hrl").
-include("cache.hrl").
-include("record.hrl").

%% API
-export([
	select_row/2,
	select_all/1,
	replace/1,
	remove_cache/2,
	get_player_counter_info_from_ets/2,
	save_player_counter_info_to_ets/1,
	delete_player_counter_info_from_ets/1,
	select_row_ets/2
]).


%% ====================================================================
%% API functions
%% ====================================================================
select_row(PlayerId, CounterId) ->
	db_cache_lib:select_row(?DB_PLAYER_COUNTER, {PlayerId, CounterId}).

select_all(PlayerId) ->
	db_cache_lib:select_all(?DB_PLAYER_COUNTER, {PlayerId, '_'}).

replace(CounterInfo) ->
	{PlayerId, CounterId} = CounterInfo#ets_player_counter.key,
	DbCounterInfo = #db_player_counter{counter_id = CounterId,
										player_id = PlayerId,
										value = CounterInfo#ets_player_counter.value,
										update_time = CounterInfo#ets_player_counter.update_time},
	db_cache_lib:replace(?DB_PLAYER_COUNTER, {PlayerId, CounterId}, DbCounterInfo).

remove_cache(PlayerId, CounterId) ->
	db_cache_lib:remove_cache(?DB_PLAYER_COUNTER, {PlayerId, CounterId}).

%% ====================================================================

select_row_ets(PlayerId, CounterId) ->
	case select_row(PlayerId, CounterId) of
		#db_player_counter{} = CounterInfo ->
			CounterId = CounterInfo#db_player_counter.counter_id,
			Record = #ets_player_counter{key = {PlayerId, CounterId},
										value = CounterInfo#db_player_counter.value,
										update_time = CounterInfo#db_player_counter.update_time},
			counter_cache:save_player_counter_info_to_ets(Record),
			Record;
		_ ->
			Record = #ets_player_counter{key = {PlayerId, CounterId},
										value = 0,
										update_time = counter_lib:get_localtime()},
			counter_cache:save_player_counter_info_to_ets(Record),
			Record
	end.

%% 从ets获取玩家计数器记录
get_player_counter_info_from_ets(PlayerId, CounterId) ->
	case ets:lookup(?ETS_PLAYER_COUNTER, {PlayerId, CounterId}) of
		[PC|_] ->
			{ok, PC};
		_ ->
			[]
	end.

%% 保存玩家计数器记录到ets
save_player_counter_info_to_ets(PC) ->
	ets:insert(?ETS_PLAYER_COUNTER, PC).

%% 删除该玩家的记录
delete_player_counter_info_from_ets(PlayerId) ->
	ets:delete_object(?ETS_PLAYER_COUNTER, #ets_player_counter{key = {PlayerId, '_'}, _ = '_'}).