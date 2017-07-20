%%%-------------------------------------------------------------------
%%% @author zhengsiying
%%% @copyright (C) 2015, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 24. 九月 2015 下午2:39
%%%-------------------------------------------------------------------
-module(buff_db).

-include("common.hrl").
-include("cache.hrl").

%% API
-export([
	select_all/1,
	select_row/1,
	insert/1,
	update/2,
	delete/1
]).

%% ====================================================================
%% API functions
%% ====================================================================
select_all({PlayerId, '_'}) ->
	case db:select_all(buff, record_info(fields, db_buff), [{player_id, PlayerId}]) of
		[] ->
			[];
		List ->
			[begin
				R = list_to_tuple([db_buff | X]),
				ExtraInfo = R#db_buff.extra_info,
				R#db_buff{extra_info = util_data:string_to_term(ExtraInfo)}
			end	|| X <- List]
	end.

select_row({PlayerId, BuffId}) ->
	case db:select_row(buff, record_info(fields, db_buff), [{player_id, PlayerId}, {buff_id, BuffId}]) of
		[] ->
			null;
		List ->
			R = list_to_tuple([db_buff | List]),
			ExtraInfo = R#db_buff.extra_info,
			R#db_buff{extra_info = util_data:string_to_term(ExtraInfo)}
	end.

insert(Buff) ->
	ExtraInfo = Buff#db_buff.extra_info,
	Buff1 = Buff#db_buff{extra_info = util_data:term_to_string(ExtraInfo)},
	db:insert(buff, util_tuple:to_tuple_list(Buff1)).

update({PlayerId, BuffId}, Buff) ->
	ExtraInfo = Buff#db_buff.extra_info,
	Buff1 = Buff#db_buff{extra_info = util_data:term_to_string(ExtraInfo)},
	db:update(buff, util_tuple:to_tuple_list(Buff1), [{player_id, PlayerId}, {buff_id, BuffId}]).

delete({PlayerId, BuffId}) ->
	db:delete(buff, [{player_id, PlayerId}, {buff_id, BuffId}]).
