%%%-------------------------------------------------------------------
%%% @author tuhujia
%%% @copyright (C) 2015, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 13. 八月 2015 10:45
%%%-------------------------------------------------------------------
-module(guild_db).

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
select_row(GuildId) ->
	case db:select_row(guild, record_info(fields, db_guild), [{guild_id, GuildId}]) of
		[] ->
			null;
		List ->
			DbGuildInfo = list_to_tuple([db_guild | List]),
			Extra = DbGuildInfo#db_guild.extra,
			DbGuildInfo#db_guild{
				extra = util_data:string_to_term(Extra)
			}
	end.

select_all() ->
	case db:select_all(guild, record_info(fields, db_guild), []) of
		[] ->
			[];
		List ->
			Fun = fun(List1) ->
				DbGuildInfo = list_to_tuple([db_guild | List1]),
				Extra = DbGuildInfo#db_guild.extra,
				DbGuildInfo#db_guild{
					extra = util_data:string_to_term(Extra)
				}
			end,
			[Fun(X) || X <- List]
	end.

replace(Info) ->
	db:replace(guild, util_tuple:to_tuple_list(Info)).

delete(GuildId) ->
	db:delete(guild, [{guild_id, GuildId}]).

insert(Info) ->
	Extra = Info#db_guild.extra,
	Info1 = Info#db_guild{
		extra = util_data:term_to_string(Extra)
	},
	db:insert(guild, util_tuple:to_tuple_list(Info1)).

update(GuildId, Info) ->
	Extra = Info#db_guild.extra,
	Info1 = Info#db_guild{
		extra = util_data:term_to_string(Extra)
	},
	db:update(guild, util_tuple:to_tuple_list(Info1), [{guild_id, GuildId}]).

%% ====================================================================
%% Internal functions
%% ====================================================================
