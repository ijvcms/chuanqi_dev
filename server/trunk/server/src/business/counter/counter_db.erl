%%%-------------------------------------------------------------------
%%% @author apple
%%% @copyright (C) 2015, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 30. 七月 2015 16:02
%%%-------------------------------------------------------------------
-module(counter_db).


-include("common.hrl").
-include("cache.hrl").

%% API
-export([
	select_row/1,
	select_all/1,
	replace/1,
	insert/1,
	update/2
]).

%% ====================================================================
%% API functions
%% ====================================================================
select_row({PlayerId, CounterId}) ->
	case db:select_row(player_counter, record_info(fields, db_player_counter), [{player_id, PlayerId}, {counter_id, CounterId}]) of
		[] ->
			null;
		[PlayerId, CounterId, Value, {_Datetime, UpdateTime}] ->
			List = [PlayerId, CounterId, Value, UpdateTime],
			list_to_tuple([db_player_counter | List])
	end.

select_all({PlayerId, '_'}) ->
	case db:select_all(player_counter, record_info(fields, db_player_counter), [{player_id, PlayerId}]) of
		[] ->
			[];
		List ->
			List1 = [[P, C, V, U] || [P, C, V, {_D, U}] <- List],
			[list_to_tuple([db_player_counter | X]) || X <- List1]
	end.

replace(CounterInfo) ->
	UpdateTime = util_date:datetime_to_string(CounterInfo#db_player_counter.update_time),
	db:replace(player_counter, util_tuple:to_tuple_list(CounterInfo#db_player_counter{update_time = UpdateTime})).

insert(CounterInfo) ->
	UpdateTime = util_date:datetime_to_string(CounterInfo#db_player_counter.update_time),
	db:insert(player_counter, util_tuple:to_tuple_list(CounterInfo#db_player_counter{update_time = UpdateTime})).

update({PlayerId, CounterId}, CounterInfo) ->
	UpdateTime = util_date:datetime_to_string(CounterInfo#db_player_counter.update_time),
	db:update(player_counter, util_tuple:to_tuple_list(CounterInfo#db_player_counter{update_time = UpdateTime}), [{player_id, PlayerId}, {counter_id, CounterId}]).

%% ====================================================================
%% Internal functions
%% ====================================================================