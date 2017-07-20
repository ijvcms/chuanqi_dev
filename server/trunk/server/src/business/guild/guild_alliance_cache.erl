%%%-------------------------------------------------------------------
%%% @author tuhujia
%%% @copyright (C) 2015, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 13. 八月 2015 10:46
%%%-------------------------------------------------------------------
-module(guild_alliance_cache).

-include("common.hrl").
-include("cache.hrl").
-include("record.hrl").

%% API
-export([
	select_row/1,
	select_all/0,
	insert/1,
	delete/1,
	update_guild_alliance/2
]).


%% ====================================================================
%% API functions
%% ====================================================================
select_row(GuidlId) ->
	db_cache_lib:select_row(?DB_GUILD_ALLIANCE, GuidlId).

select_all() ->
	db_cache_lib:select_all(?DB_GUILD_ALLIANCE).

insert(DbInfo) ->
	GuildId = DbInfo#db_guild_alliance.guild_id,
	db_cache_lib:insert(?DB_GUILD_ALLIANCE, GuildId, DbInfo).

delete(GuidlId) ->
	db_cache_lib:delete(?DB_GUILD_ALLIANCE, GuidlId).


%% ====================================================================
%%
%% ====================================================================
update_guild_alliance(Guild, Aid) ->
	case Aid of
		0 ->
			delete(Guild);
		_ ->
			case select_row(Guild) of
				null ->
					Info = #db_guild_alliance{
						guild_id = Guild,
						alliance_id = Aid
					},
					insert(Info);
				DbInfo ->
					DbInfo#db_guild_alliance{
						alliance_id = Aid
					}
			end
	end.


