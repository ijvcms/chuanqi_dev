%%%-------------------------------------------------------------------
%%% @author apple
%%% @copyright (C) 2015, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 30. 十一月 2015 14:11
%%%-------------------------------------------------------------------
-module(player_red_db).

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
select_row({RedId, PlayerId}) ->
	case db:select_row(player_red, record_info(fields, db_player_red), [{red_id, RedId}, {player_id, PlayerId}]) of
		[] ->
			null;
		List ->
			list_to_tuple([db_player_red | List])
	end.

select_all({GuildId, Id}) ->
	case Id =:= 0 of
		true ->
			Sql = lists:concat([" select * from player_red where guild_id=", GuildId, " order by id desc limit 20"]),
			List = db:select_all(Sql),
			[list_to_tuple([db_player_red | X]) || X <- List];
		_ ->
			Sql = lists:concat([" select * from player_red where guild_id=", GuildId, " and id<", Id, " order by id desc limit 20"]),
			List = db:select_all(Sql),
			[list_to_tuple([db_player_red | X]) || X <- List]
	end.

insert(PlayerRedInfo) ->
	db:insert(player_red, util_tuple:to_tuple_list(PlayerRedInfo)).

update({RedId, PlayerId}, TaskInfo) ->
	db:update(player_red, util_tuple:to_tuple_list(TaskInfo), [{red_id, RedId}, {player_id, PlayerId}]).

delete({RedId, PlayerId}) ->
	db:delete(player_red, [{red_id, RedId}, {player_id, PlayerId}]).
%% API

