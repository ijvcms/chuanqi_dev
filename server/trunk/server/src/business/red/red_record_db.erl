%%%-------------------------------------------------------------------
%%% @author apple
%%% @copyright (C) 2015, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 30. 十一月 2015 14:11
%%%-------------------------------------------------------------------
-module(red_record_db).

-include("common.hrl").
-include("cache.hrl").

%% API
-export([
	select_row/1,
	insert/1,
	select_all/1,
	update/2,
	select_all/0
]).

%% ====================================================================
%% API functions
%% ====================================================================

select_row(RedId) ->
	case db:select_row(red_record, record_info(fields, db_red_record), [{red_id, RedId}]) of
		[] ->
			null;
		List ->
			list_to_tuple([db_red_record | List])
	end.

select_all({GuildId, RedId}) ->
	case RedId =:= 0 of
		true ->
			Sql = lists:concat([" select * from red_record where guild_id=", GuildId, " order by red_id desc limit 20"]),
			List = db:select_all(Sql),
			[list_to_tuple([db_red_record | X]) || X <- List];
		_ ->
			Sql = lists:concat([" select * from red_record where guild_id=", GuildId, " and red_id<", RedId, " order by red_id desc limit 20"]),
			List = db:select_all(Sql),
			[list_to_tuple([db_red_record | X]) || X <- List]
	end.

select_all() ->
	Sql = lists:concat([" select * from red_record where guild_id >0 and loss_num<num and jade>loss_jade"]),
	List = db:select_all(Sql),
	[list_to_tuple([db_red_record | X]) || X <- List].

update(RedId, RedInfo) ->
	db:update(red_record, util_tuple:to_tuple_list(RedInfo), [{red_id, RedId}]).

insert(RedInfo) ->
	db:insert(red_record, util_tuple:to_tuple_list(RedInfo)).

