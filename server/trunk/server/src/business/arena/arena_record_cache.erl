%%%-------------------------------------------------------------------
%%% @author tuhujia
%%% @copyright (C) 2015, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 24. 八月 2015 17:38
%%%-------------------------------------------------------------------
-module(arena_record_cache).

-include("common.hrl").
-include("cache.hrl").
-include("record.hrl").

%% API
-export([
	select_row/1,
	insert/1,
	replace/1,
	update/2,
	delete/1,
	remove_cache/1,
	save_arena_info_to_ets/1,
	get_arena_record/1,
	update_arena_record/2,
	update_arena_record/3,
	update_match_list/2,
	clear_arena_record/1
]).

%% ====================================================================
%% API functions
%% ====================================================================
select_row(PlayerId) ->
	db_cache_lib:select_row(?DB_ARENA_RECORD, PlayerId).

insert(Info) ->
	PlayerId = Info#db_arena_record.player_id,
	db_cache_lib:insert(?DB_ARENA_RECORD, PlayerId, Info).

replace(Info) ->
	PlayerId = Info#db_arena_record.player_id,
	db_cache_lib:replace(?DB_ARENA_RECORD, PlayerId, Info).

update(PlayerId, Info) ->
	db_cache_lib:update(?DB_ARENA_RECORD, PlayerId, Info).

delete(PlayerId) ->
	db_cache_lib:delete(?DB_ARENA_RECORD, PlayerId).

remove_cache(PlayerId) ->
	db_cache_lib:remove_cache(?DB_ARENA_RECORD, PlayerId).

%% ====================================================================
%%
%% ====================================================================

%% 保存玩家挑战记录
save_arena_info_to_ets(Info) ->
	ets:insert(?ETS_ARENA_RECORD, Info).

%% 获取玩家排行榜信息
get_arena_record(PlayerId) ->
	case ets:lookup(?ETS_ARENA_RECORD, PlayerId) of
		[R|_] ->
			R;
		_ ->
			case select_row(PlayerId) of
				null ->
					ArenaR = #db_arena_record{
						player_id = PlayerId,
						reputation = 0,
						arena_list = [],
						match_list = [],
						update_time = util_date:unixtime()
					},
					save_arena_info_to_ets(ArenaR),
					ArenaR;
				ArenaR ->
					save_arena_info_to_ets(ArenaR),
					ArenaR
			end
	end.

%% 更新玩家挑战信息
update_arena_record(PlayerId, Record) ->
	NowTime = util_date:unixtime(),
	case ets:lookup(?ETS_ARENA_RECORD, PlayerId) of
		[ArenaRecord|_] ->
			ArenaList = ArenaRecord#db_arena_record.arena_list,
			ArenaList1 = lists:sublist([Record|ArenaList], 10),
			R = ArenaRecord#db_arena_record{
				arena_list = ArenaList1,
				update_time = NowTime
			},
			save_arena_info_to_ets(R),
			replace(R);
		_ ->
			case select_row(PlayerId) of
				null ->
					R = #db_arena_record{
						player_id = PlayerId,
						arena_list = [Record],
						reputation = 0,
						match_list = [],
						update_time = NowTime
					},
					save_arena_info_to_ets(R),
					replace(R);
				ArenaR ->
					ArenaList = ArenaR#db_arena_record.arena_list,
					ArenaList1 = lists:sublist([Record|ArenaList], 10),
					R = ArenaR#db_arena_record{player_id = PlayerId, arena_list = ArenaList1, update_time = NowTime},
					save_arena_info_to_ets(R),
					replace(R)
			end
	end.

%% 清空记录
clear_arena_record(PlayerId) ->
	NowTime = util_date:unixtime(),
	case ets:lookup(?ETS_ARENA_RECORD, PlayerId) of
		[ArenaRecord|_] ->
			R = ArenaRecord#db_arena_record{
				arena_list = [],
				update_time = NowTime
			},
			save_arena_info_to_ets(R),
			replace(R);
		_ ->
			case select_row(PlayerId) of
				null ->
					skip;
				ArenaR ->
					R = ArenaR#db_arena_record{arena_list = [], update_time = NowTime},
					save_arena_info_to_ets(R),
					replace(R)
			end
	end.

update_arena_record(PlayerId, Record, MatchList) ->
	NowTime = util_date:unixtime(),
	case ets:lookup(?ETS_ARENA_RECORD, PlayerId) of
		[ArenaRecord|_] ->
			ArenaList = ArenaRecord#db_arena_record.arena_list,
			ArenaList1 = lists:sublist([Record|ArenaList], 10),
			R = ArenaRecord#db_arena_record{
				player_id = PlayerId,
				arena_list = ArenaList1,
				update_time = NowTime,
				match_list = MatchList
			},
			save_arena_info_to_ets(R),
			replace(R);
		_ ->
			case select_row(PlayerId) of
				null ->
					R = #db_arena_record{
						player_id = PlayerId,
						arena_list = [Record],
						match_list = MatchList,
						update_time = NowTime
					},
					save_arena_info_to_ets(R),
					replace(R);
				ArenaR ->
					ArenaList = ArenaR#db_arena_record.arena_list,
					ArenaList1 = lists:sublist([Record|ArenaList], 10),
					R = ArenaR#db_arena_record{
						player_id = PlayerId,
						match_list = MatchList,
						arena_list = ArenaList1,
						update_time = NowTime
					},
					save_arena_info_to_ets(R),
					replace(R)
			end
	end.

%% 更新玩家刷新列表
update_match_list(PlayerId, MatchList) ->
	NowTime = util_date:unixtime(),
	case ets:lookup(?ETS_ARENA_RECORD, PlayerId) of
		[ArenaRecord|_] ->
			R = ArenaRecord#db_arena_record{match_list = MatchList, update_time = NowTime},
			save_arena_info_to_ets(R),
			replace(R);
		_ ->
			case select_row(PlayerId) of
				null ->
					R = #db_arena_record{player_id = PlayerId, match_list = MatchList, update_time = NowTime},
					save_arena_info_to_ets(R),
					replace(R);
				ArenaR ->
					R = ArenaR#db_arena_record{player_id = PlayerId, match_list = MatchList, update_time = NowTime},
					save_arena_info_to_ets(R),
					replace(R)
			end
	end.