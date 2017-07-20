%%%-------------------------------------------------------------------
%%% @author tuhujia
%%% @copyright (C) 2016, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 12. 四月 2016 11:16
%%%-------------------------------------------------------------------
-module(player_drop_cache).

-include("common.hrl").
-include("cache.hrl").
-include("record.hrl").
-include("config.hrl").

%% API
-export([
	select_row/2,
	replace/1,
	remove_cache/2,
	get_player_drop_value/2,
	update_player_kill_count/2,
	reset_player_kill_count/2
]).

%% 最大幸运点数
-define(MAX_DROP_VALUE, 100).

%% ====================================================================
%% API functions
%% ====================================================================
select_row(PlayerId, MonsterId) ->
	db_cache_lib:select_row(?DB_PLAYER_DROP, {PlayerId, MonsterId}).

replace(Info) ->
	PlayerId = Info#db_player_drop.player_id,
	MonsterId = Info#db_player_drop.monster_id,
	db_cache_lib:replace(?DB_PLAYER_DROP, {PlayerId, MonsterId}, Info).

remove_cache(MonsterId, SceneId) ->
	db_cache_lib:remove_cache(?DB_PLAYER_DROP, {MonsterId, SceneId}).

%% ====================================================================

%% 获取玩家击杀怪物幸运点
get_player_drop_value(PlayerId, MonsterConf) ->
	MonsterId = MonsterConf#monster_conf.monster_id,
	case select_row(PlayerId, MonsterId) of
		null ->
			0;
		Info ->
			KillValue = MonsterConf#monster_conf.kill_value,
			100 * (min(?MAX_DROP_VALUE, KillValue * Info#db_player_drop.kill_count))
	end.

%% 更新玩家击杀怪物次数
update_player_kill_count(PlayerId, MonsterId) ->
	case select_row(PlayerId, MonsterId) of
		null ->
			Info = #db_player_drop
			{
				player_id = PlayerId, %% 玩家id
				monster_id = MonsterId, %% 怪物id
				kill_count = 1, %% 击杀次数
				update_time = util_date:unixtime() %% 更新时间
			},
			replace(Info);
		Info ->
			KillCount = Info#db_player_drop.kill_count,
			Info1 = Info#db_player_drop{kill_count = 1 + KillCount},
			replace(Info1)
	end.

%% 重置玩家击杀怪物次数
reset_player_kill_count(PlayerId, MonsterId) ->
	Info = #db_player_drop
	{
		player_id = PlayerId, %% 玩家id
		monster_id = MonsterId, %% 怪物id
		kill_count = 0, %% 击杀次数
		update_time = util_date:unixtime() %% 更新时间
	},
	replace(Info).