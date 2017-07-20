%%%-------------------------------------------------------------------
%%% @author zhengsiying
%%% @copyright (C) 2015, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 21. 七月 2015 下午5:46
%%%-------------------------------------------------------------------
-module(city_info_db).

-include("common.hrl").
-include("cache.hrl").

%% API
-export([
	select_row/1,
	insert/1,
	update/2,
	delete/1
]).

%% ====================================================================
%% API functions
%% ====================================================================
select_row(SceneId) ->
	case db:select_row(city_info, record_info(fields, db_city_info), [{scene_id, SceneId}]) of
		[] ->
			null;
		List ->
			list_to_tuple([db_city_info | List])
	end.

insert(CityInfo) ->
	db:insert(city_info, util_tuple:to_tuple_list(CityInfo)).

update(SceneId, CityInfo) ->
	db:update(city_info, util_tuple:to_tuple_list(CityInfo), [{scene_id, SceneId}]).

delete(SceneId) ->
	db:delete(city_info, [{scene_id, SceneId}]).

%% ====================================================================
%% Internal functions
%% ====================================================================
