%%%-------------------------------------------------------------------
%%% @author tuhujia
%%% @copyright (C) 2016, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 03. 三月 2016 16:14
%%%-------------------------------------------------------------------
-module(monster_kills_db).

-include("common.hrl").
-include("cache.hrl").

%% API
-export([
	select_row/1,
	replace/1,
	insert/1,
	update/2
]).

%% ====================================================================
%% API functions
%% ====================================================================
select_row({MonsterId, SceneId}) ->
	case db:select_row(monster_kills, record_info(fields, db_monster_kills), [{monster_id, MonsterId}, {scene_id, SceneId}]) of
		[] ->
			null;
		List ->
			list_to_tuple([db_monster_kills | List])
	end.

replace(Info) ->
	db:replace(monster_kills, util_tuple:to_tuple_list(Info)).

insert(Info) ->
	db:insert(monster_kills, util_tuple:to_tuple_list(Info)).

update({MonsterId, SceneId}, Info) ->
	db:update(monster_kills, util_tuple:to_tuple_list(Info), [{monster_id, MonsterId}, {scene_id, SceneId}]).

%% ====================================================================
%% Internal functions
%% ====================================================================
