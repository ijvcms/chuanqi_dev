%%%-------------------------------------------------------------------
%%% @author tuhujia
%%% @copyright (C) 2015, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 13. 八月 2015 10:45
%%%-------------------------------------------------------------------
-module(player_guild_cache).

-include("common.hrl").
-include("cache.hrl").
-include("record.hrl").

%% API
-export([
	select_row/1,
	select_all/0,
	replace/1,
	delete/1,
	remove_cache/1,
	save_player_guild_to_ets/1,
	get_player_guild_info_from_ets/2,
	delete_player_guild_info_from_ets/2,
	get_guild_member_num_from_ets/1
]).


%% ====================================================================
%% API functions
%% ====================================================================
select_row(PlayerId) ->
	db_cache_lib:select_row(?DB_PLAYER_GUILD, PlayerId).

select_all() ->
	db_cache_lib:select_all(?DB_PLAYER_GUILD).

replace(DbInfo) ->
	PlayerId = DbInfo#db_player_guild.player_id,
	db_cache_lib:replace(?DB_PLAYER_GUILD, PlayerId, DbInfo).

delete(PlayerId) ->
	db_cache_lib:delete(?DB_PLAYER_GUILD, PlayerId).

remove_cache(PlayerId) ->
	db_cache_lib:remove_cache(?DB_PLAYER_GUILD, PlayerId).

%% ====================================================================
%%
%% ====================================================================

save_player_guild_to_ets(Info) ->
	GuildId = Info#db_player_guild.guild_id,
	PlayerId = Info#db_player_guild.player_id,
	case ets:lookup(?ETS_GUILD_LIST, GuildId) of
		[R|_] ->
			MemberList = R#ets_guild_list.member_list,
			MemberList1 = lists:keystore(PlayerId, #db_player_guild.player_id, MemberList, Info),
			MemberNum = length(MemberList1),
			%% 排序
			MemberList2 = lists:keysort(#db_player_guild.totoal_contribution, MemberList1),
			MemberList3 = lists:reverse(MemberList2),
			MemberList4 = lists:keysort(#db_player_guild.position, MemberList3),
			ets:update_element(?ETS_GUILD_LIST, GuildId, [{#ets_guild_list.member_list, MemberList4},
														  {#ets_guild_list.member_num, MemberNum}]);
		_ ->
			R = #ets_guild_list{guild_id = GuildId, member_list = [Info]},
			ets:insert(?ETS_GUILD_LIST, R)
	end.

%% 获取玩家帮派信息
get_player_guild_info_from_ets(PlayerId, GuildId) ->
	case ets:lookup(?ETS_GUILD_LIST, GuildId) of
		[R|_] ->
			MemberList = R#ets_guild_list.member_list,
			case lists:keyfind(PlayerId, #db_player_guild.player_id, MemberList) of
				false ->
					[];
				Info ->
					Info
			end;
		_ ->
			[]
	end.

%% 获取帮派成员数量
get_guild_member_num_from_ets(GuildId) ->
	case ets:lookup(?ETS_GUILD_LIST, GuildId) of
		[R|_] ->
			R#ets_guild_list.member_num;
		_ ->
			0
	end.

%% 删除玩家帮派信息
delete_player_guild_info_from_ets(PlayerId, GuildId) ->
	case ets:lookup(?ETS_GUILD_LIST, GuildId) of
		[R|_] ->
			MemberList = R#ets_guild_list.member_list,
			case lists:keyfind(PlayerId, #db_player_guild.player_id, MemberList) of
				false ->
					skip;
				Info ->
					MemberList1 = lists:delete(Info, MemberList),
					MemberNum = length(MemberList1),
					ets:update_element(?ETS_GUILD_LIST, GuildId, [{#ets_guild_list.member_list, MemberList1},
																  {#ets_guild_list.member_num, MemberNum}])
			end;
		_ ->
			skip
	end.
