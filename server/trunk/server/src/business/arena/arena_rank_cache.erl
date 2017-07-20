%%%-------------------------------------------------------------------
%%% @author tuhujia
%%% @copyright (C) 2015, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 24. 八月 2015 17:31
%%%-------------------------------------------------------------------
-module(arena_rank_cache).

-include("common.hrl").
-include("cache.hrl").
-include("record.hrl").

%% API
-export([
	select_all/0,
	select_row/1,
	insert/1,
	replace/1,
	update/2,
	delete/1,
	remove_cache/1,
	save_arena_info_to_ets/1,
	get_arena_info_from_ets/1
]).

%% ====================================================================
%% API functions
%% ====================================================================
select_all() ->
	db_cache_lib:select_all(?DB_ARENA_RANK).

select_row(PlayerId) ->
	db_cache_lib:select_row(?DB_ARENA_RANK, PlayerId).

insert(Info) ->
	PlayerId = Info#db_arena_rank.player_id,
	db_cache_lib:insert(?DB_ARENA_RANK, PlayerId, Info).

replace(Info) ->
	PlayerId = Info#db_arena_rank.player_id,
	db_cache_lib:replace(?DB_ARENA_RANK, PlayerId, Info).

update(PlayerId, Info) ->
	db_cache_lib:update(?DB_ARENA_RANK, PlayerId, Info).

delete(PlayerId) ->
	db_cache_lib:delete(?DB_ARENA_RANK, PlayerId).

remove_cache(PlayerId) ->
	db_cache_lib:remove_cache(?DB_ARENA_RANK, PlayerId).

%% ====================================================================
%%
%% ====================================================================

%% 保存排行榜信息到ets
save_arena_info_to_ets(Info) ->
	ets:insert(?ETS_ARENA_RANK, Info).

%% 获取玩家排行榜信息
get_arena_info_from_ets(PlayerId) ->
	case ets:lookup(?ETS_ARENA_RANK, PlayerId) of
		[R|_] ->
			R;
		_ ->
			[]
	end.