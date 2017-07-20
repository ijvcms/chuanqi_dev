%%%-------------------------------------------------------------------
%%% @author tuhujia
%%% @copyright (C) 2015, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 13. 八月 2015 10:45
%%%-------------------------------------------------------------------
-module(guild_alliance_db).

-include("common.hrl").
-include("cache.hrl").
-include("db_record.hrl").
-include("record.hrl").
%% API
-export([
	select_row/1,
	select_all/0,
	delete/1,
	insert/1,
	update/2
]).

%% ====================================================================
%% API functions
%% ====================================================================
select_row(GuildId) ->
	case db:select_row(guild_alliance, record_info(fields, db_guild_alliance), [{guild_id, GuildId}]) of
		[] ->
			null;
		List ->
			list_to_tuple([db_guild_alliance | List])
	end.

select_all() ->
	case db:select_all(guild_alliance, record_info(fields, db_guild_alliance), []) of
		[] ->
			[];
		List ->
			Fun = fun(List1) ->
				list_to_tuple([db_guild_alliance | List1])
			end,
			[Fun(X) || X <- List]
	end.

delete(GuildId) ->
	db:delete(guild_alliance, [{guild_id, GuildId}]).

insert(Info) ->
	db:insert(guild_alliance, util_tuple:to_tuple_list(Info)).

update(GuildId, Info) ->
	db:update(guild_alliance, util_tuple:to_tuple_list(Info), [{guild_id, GuildId}]).

%% ====================================================================
%% Internal functions
%% ====================================================================
