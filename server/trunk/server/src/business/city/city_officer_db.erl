%%%-------------------------------------------------------------------
%%% @author yubing
%%% @copyright (C) 2015, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 16. 十二月 2015 11:49
%%%-------------------------------------------------------------------
-module(city_officer_db).

-include("common.hrl").
-include("cache.hrl").

-export([select_all/1,insert/1,update/2,delete/1,select_row/1]).

%% ====================================================================
%% API functions
%% ====================================================================
select_all({SceneId,'_'}) ->
	case db:select_all(city_officer, record_info(fields, db_city_officer), [{scene_id, SceneId}]) of
		[] ->
			[];
		List ->
			[list_to_tuple([db_city_officer | X]) || X <- List]
	end.

select_row({SceneId, PlayerId}) ->
	case db:select_row(city_officer, record_info(fields, db_city_officer), [{scene_id, SceneId}, {player_id, PlayerId}]) of
		[] ->
			null;
		List ->
			list_to_tuple([db_city_officer | List])
	end.

insert(CityOfficerInfo) ->
	db:insert(city_officer, util_tuple:to_tuple_list(CityOfficerInfo)).

update({SceneId,PlayerId}, CityOfficerInfo) ->
	db:update(city_officer, util_tuple:to_tuple_list(CityOfficerInfo), [{scene_id, SceneId},{player_id,PlayerId}]).

delete({SceneId,PlayerId}) ->
	db:delete(city_officer, [{scene_id, SceneId},{player_id,PlayerId}]).