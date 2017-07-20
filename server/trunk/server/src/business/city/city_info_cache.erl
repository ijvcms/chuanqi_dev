%%%-------------------------------------------------------------------
%%% @author apple
%%% @copyright (C) 2015, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 30. 十一月 2015 19:19
%%%-------------------------------------------------------------------
-module(city_info_cache).

-include("common.hrl").
-include("cache.hrl").


-export([
	select_row/1,
	insert/1,
	update/2,
	delete/1
]).

select_row(SceneId) ->
	db_cache_lib:select_row(?DB_CITY_INFO,SceneId).

insert(CityInfo) ->
	db_cache_lib:insert(?DB_CITY_INFO, CityInfo#db_city_info.scene_id, CityInfo).

update(SceneId, CityInfo) ->
	db_cache_lib:update(?DB_CITY_INFO,SceneId, CityInfo).

delete(SceneId) ->
	db_cache_lib:delete(?DB_CITY_INFO,SceneId).
%% API

