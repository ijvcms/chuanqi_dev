%%%-------------------------------------------------------------------
%%% @author yubing
%%% @copyright (C) 2015, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 16. 十二月 2015 11:49
%%%-------------------------------------------------------------------
-module(city_officer_cache).

-export([select_all/1,insert/1,update/2,delete/1,select_row/1]).

-include("cache.hrl").

select_all(SceneId) ->
	db_cache_lib:select_all(?DB_CITY_OFFICER,{SceneId,'_'}).

select_row({SceneId, PlayerId}) ->
	db_cache_lib:select_row(?DB_CITY_OFFICER,{SceneId, PlayerId}).

insert(CityOfficerInfo) ->
	SceneId=CityOfficerInfo#db_city_officer.scene_id,
	PlayerId=CityOfficerInfo#db_city_officer.player_id,
	db_cache_lib:insert(?DB_CITY_OFFICER,{SceneId,PlayerId}, CityOfficerInfo).

update({SceneId,PlayerId},CityOfficerInfo) ->
	db_cache_lib:update(?DB_CITY_OFFICER,{SceneId,PlayerId}, CityOfficerInfo).

delete({SceneId,PlayerId}) ->
	db_cache_lib:delete(?DB_CITY_OFFICER,{SceneId,PlayerId}).
