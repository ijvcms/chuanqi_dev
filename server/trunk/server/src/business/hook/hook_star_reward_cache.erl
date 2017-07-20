%%%-------------------------------------------------------------------
%%% @author zhengsiying
%%% @copyright (C) 2015, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 20. 十月 2015 下午9:04
%%%-------------------------------------------------------------------
-module(hook_star_reward_cache).

-include("common.hrl").
-include("cache.hrl").

%% API
-export([
	select_all/1,
	select_row/1,
	insert/1,
	update/2,
	replace/1,
	remove_cache/1
]).

%% ====================================================================
%% API functions
%% ====================================================================
select_all(PlayerId) ->
	db_cache_lib:select_all(?DB_HOOK_STAR_REWARD, {PlayerId, '_'}).

select_row({PlayerId, Chapter}) ->
	db_cache_lib:select_row(?DB_HOOK_STAR_REWARD, {PlayerId, Chapter}).

insert(HookStarReward) ->
	#db_hook_star_reward{
		player_id = PlayerId,
		chapter = Chapter
	} = HookStarReward,
	db_cache_lib:insert(?DB_HOOK_STAR_REWARD, {PlayerId, Chapter}, HookStarReward).

update({PlayerId, Chapter}, UpdateHookStarReward) ->
	db_cache_lib:update(?DB_HOOK_STAR_REWARD, {PlayerId, Chapter}, UpdateHookStarReward).

replace(HookStarReward) ->
	#db_hook_star_reward{
		player_id = PlayerId,
		chapter = Chapter
	} = HookStarReward,
	db_cache_lib:replace(?DB_HOOK_STAR_REWARD, {PlayerId, Chapter}, HookStarReward).

remove_cache(PlayerId) ->
	db_cache_lib:remove_all_cache(?DB_HOOK_STAR_REWARD, {PlayerId, '_'}).

%% ====================================================================
%% Internal functions
%% ====================================================================
