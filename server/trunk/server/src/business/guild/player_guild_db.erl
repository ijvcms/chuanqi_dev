%%%-------------------------------------------------------------------
%%% @author tuhujia
%%% @copyright (C) 2015, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 13. 八月 2015 10:45
%%%-------------------------------------------------------------------
-module(player_guild_db).

-include("common.hrl").
-include("cache.hrl").
-include("db_record.hrl").

%% API
-export([
	select_row/1,
	select_all/0,
	replace/1,
	delete/1,
	insert/1,
	update/2
]).

%% ====================================================================
%% API functions
%% ====================================================================
select_row(PlayerId) ->
	case db:select_row(player_guild, record_info(fields, db_player_guild), [{player_id, PlayerId}]) of
		[] ->
			null;
		List ->
			list_to_tuple([db_player_guild | List])
	end.

select_all() ->
	case db:select_all(player_guild, record_info(fields, db_player_guild), []) of
		[] ->
			[];
		List ->
			[list_to_tuple([db_player_guild | X]) || X <- List]
	end.

replace(Info) ->
	db:replace(player_guild, util_tuple:to_tuple_list(Info)).

delete(PlayerId) ->
	db:delete(player_guild, [{player_id, PlayerId}]).

insert(Info) ->
	db:insert(player_guild, util_tuple:to_tuple_list(Info)).

update(PlayerId, Info) ->
	db:update(player_guild, util_tuple:to_tuple_list(Info), [{player_id, PlayerId}]).
%% ====================================================================
%% Internal functions
%% ====================================================================
