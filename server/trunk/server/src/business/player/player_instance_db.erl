%%%-------------------------------------------------------------------
%%% @author zhengsiying
%%% @copyright (C) 2015, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 15. 十二月 2015 下午4:25
%%%-------------------------------------------------------------------
-module(player_instance_db).

-include("common.hrl").
-include("cache.hrl").

%% API
-export([
	select_all/1,
	select_row/1,
	insert/1,
	update/2,
	delete/1,
	delete_all/1
]).

%% ====================================================================
%% API functions
%% ====================================================================
select_all({PlayerId, '_'}) ->
	case db:select_all(player_instance, record_info(fields, db_player_instance), [{player_id, PlayerId}]) of
		[] ->
			[];
		List ->
			[list_to_tuple([db_player_instance | X]) || X <- List]
	end.

select_row({PlayerId, SceneId}) ->
	case db:select_row(player_instance, record_info(fields, db_player_instance), [{player_id, PlayerId}, {scene_id, SceneId}]) of
		[] ->
			null;
		List ->
			list_to_tuple([db_player_instance | List])
	end.

insert(PlayerInstance) ->
	db:insert(player_instance, util_tuple:to_tuple_list(PlayerInstance)).

update({PlayerId, SceneId}, PlayerInstance) ->
	db:update(player_instance, util_tuple:to_tuple_list(PlayerInstance), [{player_id, PlayerId}, {scene_id, SceneId}]).

delete({PlayerId, SceneId}) ->
	db:delete(player_instance, [{player_id, PlayerId}, {scene_id, SceneId}]).

%% 特殊要求，特殊处理
delete_all(PlayerId) ->
	db:delete(player_instance, [{player_id, PlayerId}]).