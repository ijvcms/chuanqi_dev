%%%-------------------------------------------------------------------
%%% @author zhengsiying
%%% @copyright (C) 2015, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 22. 九月 2015 下午9:46
%%%-------------------------------------------------------------------
-module(player_hook_star_cache).

-include("common.hrl").
-include("cache.hrl").

%% API
-export([
	select_all/1,
	select_row/1,
	insert/1,
	update/2,
	remove_cache/1
]).

%% ====================================================================
%% API functions
%% ====================================================================
select_all(PlayerId) ->
	db_cache_lib:select_all(?DB_PLAYER_HOOK_STAR, {PlayerId, '_'}).

select_row({PlayerId, SceneId}) ->
	db_cache_lib:select_row(?DB_PLAYER_HOOK_STAR, {PlayerId, SceneId}).

insert(PlayerHookStar) ->
	#db_player_hook_star{
		player_id = PlayerId,
		hook_scene_id = SceneId
	} = PlayerHookStar,
	db_cache_lib:insert(?DB_PLAYER_HOOK_STAR, {PlayerId, SceneId}, PlayerHookStar).

update({PlayerId, SceneId}, UpdatePlayerHookStar) ->
	db_cache_lib:update(?DB_PLAYER_HOOK_STAR, {PlayerId, SceneId}, UpdatePlayerHookStar).

remove_cache(PlayerId) ->
	db_cache_lib:remove_all_cache(?DB_PLAYER_HOOK_STAR, {PlayerId, '_'}).

%% ====================================================================
%% Internal functions
%% ====================================================================
