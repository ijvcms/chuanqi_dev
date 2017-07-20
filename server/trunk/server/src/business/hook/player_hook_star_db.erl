%%%-------------------------------------------------------------------
%%% @author zhengsiying
%%% @copyright (C) 2015, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 22. 九月 2015 下午9:45
%%%-------------------------------------------------------------------
-module(player_hook_star_db).

-include("common.hrl").
-include("cache.hrl").

%% API
-export([
	select_all/1,
	select_row/1,
	insert/1,
	update/2
]).

%% ====================================================================
%% API functions
%% ====================================================================
select_all({PlayerId, '_'}) ->
	case db:select_all(player_hook_star, record_info(fields, db_player_hook_star), [{player_id, PlayerId}]) of
		[] ->
			[];
		List ->
			[list_to_tuple([db_player_hook_star | X]) || X <- List]
	end.

select_row({PlayerId, SceneId}) ->
	case db:select_row(player_hook_star, record_info(fields, db_player_hook_star), [{player_id, PlayerId}, {hook_scene_id, SceneId}]) of
		[] ->
			null;
		List ->
			list_to_tuple([db_player_hook_star | List])
	end.

insert(PlayerHookStar) ->
	db:insert(player_hook_star, util_tuple:to_tuple_list(PlayerHookStar)).

update({PlayerId, SceneId}, PlayerHookStar) ->
	db:update(player_hook_star, util_tuple:to_tuple_list(PlayerHookStar), [{player_id, PlayerId}, {hook_scene_id, SceneId}]).
