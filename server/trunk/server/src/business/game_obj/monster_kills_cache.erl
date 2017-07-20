%%%-------------------------------------------------------------------
%%% @author tuhujia
%%% @copyright (C) 2016, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 03. 三月 2016 16:13
%%%-------------------------------------------------------------------
-module(monster_kills_cache).

-include("common.hrl").
-include("cache.hrl").
-include("record.hrl").

%% API
-export([
	select_row/2,
	replace/1,
	remove_cache/2,
	get_monster_kills_count/2,
	update_monster_kills/2
]).

%% ====================================================================
%% API functions
%% ====================================================================
select_row(MonsterId, SceneId) ->
	db_cache_lib:select_row(?DB_MONSTER_KILLS, {MonsterId, SceneId}).

replace(Info) ->
	MonsterId = Info#db_monster_kills.monster_id,
	SceneId = Info#db_monster_kills.scene_id,
	db_cache_lib:replace(?DB_MONSTER_KILLS, {MonsterId, SceneId}, Info).

remove_cache(MonsterId, SceneId) ->
	db_cache_lib:remove_cache(?DB_MONSTER_KILLS, {MonsterId, SceneId}).

%% ====================================================================

%% 获取怪物被击杀次数
get_monster_kills_count(MonsterId, SceneId) ->
	case select_row(MonsterId, SceneId) of
		null ->
			0;
		DbInfo ->
			DbInfo#db_monster_kills.kill_count
	end.

%% 更新怪物击杀次数
update_monster_kills(MonsterId, SceneId) ->
	case select_row(MonsterId, SceneId) of
		null ->
			DbInfo = #db_monster_kills
			{
				monster_id = MonsterId, %% 怪物id
				scene_id = SceneId, %% 场景id
				kill_count = 1, %% 被击杀次数
				update_time = util_date:unixtime() %% 更新时间
			},
			replace(DbInfo);
		DbInfo ->
			KillCount = DbInfo#db_monster_kills.kill_count,
			NewDbInfo = DbInfo#db_monster_kills{kill_count = KillCount + 1},
			replace(NewDbInfo)
	end.