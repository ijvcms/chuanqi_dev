%%%-------------------------------------------------------------------
%%% @author tuhujia
%%% @copyright (C) 2015, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 13. 八月 2015 10:46
%%%-------------------------------------------------------------------
-module(guild_cache).

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
	save_guild_info_to_ets/1,
	get_guild_info_from_ets/1,
	get_guild_member_list_from_ets/1,
	get_guild_member_num_from_ets/1,
	get_guild_log_list/1,
	get_guild_apply_list/1,
	get_position_num/2,
	update_guild_info_to_ets/1,
	update_guild_log_list/5,
	update_guild_apply_list/2,
	delete_guild_info_from_ets/1,
	delete_guild_apply_list_by_apply_id/2,
	clear_guild_apply_list/1,
	get_guild_member_list/1
]).


%% ====================================================================
%% API functions
%% ====================================================================
select_row(GuildId) ->
	db_cache_lib:select_row(?DB_GUILD, GuildId).

select_all() ->
	db_cache_lib:select_all(?DB_GUILD).

replace(DbInfo) ->
	GuildId = DbInfo#db_guild.guild_id,
	db_cache_lib:replace(?DB_GUILD, GuildId, DbInfo).

delete(GuildId) ->
	db_cache_lib:delete(?DB_GUILD, GuildId).

remove_cache(GuildId) ->
	db_cache_lib:remove_cache(?DB_GUILD, GuildId).

%% ====================================================================
%%
%% ====================================================================

%% 保存帮派数据到ets
save_guild_info_to_ets(Info) ->
	ets:insert(?ETS_GUILD, Info).

%% 获取帮派信息
get_guild_info_from_ets(GuildId) ->
	case ets:lookup(?ETS_GUILD, GuildId) of
		[R|_] ->
			R;
		_ ->
			[]
	end.

%% 获取帮派成员列表
get_guild_member_list_from_ets(GuildId) ->
	case ets:lookup(?ETS_GUILD_LIST, GuildId) of
		[R|_] ->
			R#ets_guild_list.member_list;
		_ ->
			[]
	end.

%% 获取帮派成员列表
get_guild_member_num_from_ets(GuildId) ->
	case ets:lookup(?ETS_GUILD_LIST, GuildId) of
		[R|_] ->
			R#ets_guild_list.member_list;
		_ ->
			[]
	end.
%% 获取成员列表
get_guild_member_list(GuildId) ->
	case player_guild_cache:select_all() of
		[] ->
			skip;
		List ->
			[X || X <- List, X#db_player_guild.guild_id =:= GuildId]
	end.
%% 更新帮派信息
update_guild_info_to_ets(Info) ->
	ets:insert(?ETS_GUILD, Info).

%% 删除工会信息
delete_guild_info_from_ets(GuildId) ->
	ets:delete(?ETS_GUILD_LIST, GuildId),
	ets:delete(?ETS_GUILD, GuildId).

%% 获取申请列表
get_guild_apply_list(GuildId) ->
	case ets:lookup(?ETS_GUILD_LIST, GuildId) of
		[R|_] ->
			R#ets_guild_list.apply_list;
		_ ->
			[]
	end.

%% 获取行会日志信息
get_guild_log_list(GuildId) ->
	case ets:lookup(?ETS_GUILD_LIST, GuildId) of
		[R|_] ->
			R#ets_guild_list.log_list;
		_ ->
			[]
	end.

%% 获取对应职位人数
get_position_num(GuildId, Postiton) ->
	case ets:lookup(?ETS_GUILD_LIST, GuildId) of
		[R|_] ->
			MemberList = R#ets_guild_list.member_list,
			List = [X||X <- MemberList, X#db_player_guild.position =:= Postiton],
			length(List);
		_ ->
			0
	end.

%% 更新行会日志信息
update_guild_log_list(GuildId, Type, Param1, Param2, Param3) ->
	case ets:lookup(?ETS_GUILD_LIST, GuildId) of
		[R|_] ->
			LogList = R#ets_guild_list.log_list,
			LogList1 = [{Type, Param1, Param2, Param3}] ++ LogList,
			LogList2 = lists:sublist(LogList1, 20),
			ets:update_element(?ETS_GUILD_LIST, GuildId, [{#ets_guild_list.log_list, LogList2}]);
		_ ->
			LogList = [{Type, Param1, Param2, Param3}],
			ets:update_element(?ETS_GUILD_LIST, GuildId, [{#ets_guild_list.log_list, LogList}])
	end.

%% 添加玩家帮派申请信息
update_guild_apply_list(GuildId, State) ->
	PlayerId = State#player_state.player_id,
	DbPlayerBase = State#player_state.db_player_base,
	Name = DbPlayerBase#db_player_base.name,
	Lv = DbPlayerBase#db_player_base.lv,
	Career = DbPlayerBase#db_player_base.career,
	Fighting = State#player_state.fighting,
	case ets:lookup(?ETS_GUILD_LIST, GuildId) of
		[R|_] ->
			ApplyList = R#ets_guild_list.apply_list,
			ApplyList1 = lists:keystore(PlayerId, 1, ApplyList, {PlayerId, Name, Lv, Career, Fighting}),
			ApplyList2 = lists:sublist(ApplyList1, 100),
			guild_lib:send_apply_list_button_tips(R#ets_guild_list.member_list),
			ets:update_element(?ETS_GUILD_LIST, GuildId, [{#ets_guild_list.apply_list, ApplyList2}]);
		_ ->
			skip
	end.

%% 删除玩家申请信息
delete_guild_apply_list_by_apply_id(GuildId, ApplyId) ->
	case ets:lookup(?ETS_GUILD_LIST, GuildId) of
		[R|_] ->
			ApplyList = R#ets_guild_list.apply_list,
			ApplyList1 = lists:keydelete(ApplyId, 1, ApplyList),
			ets:update_element(?ETS_GUILD_LIST, GuildId, [{#ets_guild_list.apply_list, ApplyList1}]);
		_ ->
			[]
	end.

%% 清空申请列表
clear_guild_apply_list(GuildId) ->
	ets:update_element(?ETS_GUILD_LIST, GuildId, [{#ets_guild_list.apply_list, []}]).