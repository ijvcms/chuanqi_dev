%%%-------------------------------------------------------------------
%%% @author yubing
%%% @copyright (C) 2015, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 24. 十二月 2015 09:52
%%%-------------------------------------------------------------------
-module(citytitle_lib).

-include("record.hrl").
-include("cache.hrl").
-include("common.hrl").

-export([get_city_title_player_id/1,update_city_title/1]).

%%根据玩家的id查询出当前的称号信息
get_city_title_player_id(PlayerId) ->
	case city_lib:get_city_officer_player(PlayerId,?SCENEID_SHABAKE) of
		false->
			0;
		CityOfficerInfo->
			if
				CityOfficerInfo#db_city_officer.officer_id=:=?OFFICER_HEAD ->
					?CITY_TITLE;
				true->
					0
			end
	end.

%% 更新城主称号
update_city_title(PlayerId) ->
	case player_lib:get_player_pid(PlayerId) of
		null->
			skip;
		PID->
			player_lib:update_player_career_title(PID)
	end.
