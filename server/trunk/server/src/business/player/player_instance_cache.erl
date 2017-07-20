%%%-------------------------------------------------------------------
%%% @author zhengsiying
%%% @copyright (C) 2015, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 15. 十二月 2015 下午8:18
%%%-------------------------------------------------------------------
-module(player_instance_cache).

-include("common.hrl").
-include("cache.hrl").

%% API
-export([
	select_all/1,
	select_row/1,
	insert/1,
	update/2,
	delete/1,
	delete_all/1,
	remove_cache/1
]).

%% ====================================================================
%% API functions
%% ====================================================================
select_all(PlayerId) ->
	db_cache_lib:select_all(?DB_PLAYER_INSTANCE, {PlayerId, '_'}).

select_row({PlayerId, SceneId}) ->
	db_cache_lib:select_row(?DB_PLAYER_INSTANCE, {PlayerId, SceneId}).

insert(PlayerInstance) ->
	#db_player_instance{
		player_id = PlayerId,
		scene_id = SceneId
	} = PlayerInstance,
	db_cache_lib:insert(?DB_PLAYER_INSTANCE, {PlayerId, SceneId}, PlayerInstance).

update({PlayerId, SceneId}, PlayerInstance) ->
	db_cache_lib:update(?DB_PLAYER_INSTANCE, {PlayerId, SceneId}, PlayerInstance).

delete({PlayerId, SceneId}) ->
	db_cache_lib:delete(?DB_PLAYER_INSTANCE, {PlayerId, SceneId}).

%% 特殊要求，特殊处理
delete_all(PlayerId) ->
	remove_cache(PlayerId),
	player_instance_db:delete_all(PlayerId).

remove_cache(PlayerId) ->
	db_cache_lib:remove_all_cache(?DB_PLAYER_INSTANCE, {PlayerId, '_'}).

%% ====================================================================
%% Internal functions
%% ====================================================================