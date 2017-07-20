%%%-------------------------------------------------------------------
%%% @author apple
%%% @copyright (C) 2015, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 30. 十一月 2015 19:19
%%%-------------------------------------------------------------------
-module(player_guide_cache).

-include("common.hrl").
-include("cache.hrl").


-export([
	select_row/2,
	select_all/1,
	insert/1,
	delete/2,
	update/2
]).

select_row(PlayerId, GuideStepId) ->
	db_cache_lib:select_row(?DB_PLAYER_GUIDE, {GuideStepId, PlayerId}).

select_all(PlayerId) ->
	db_cache_lib:select_all(?DB_PLAYER_GUIDE, {'_', PlayerId}).

insert(GuideStepInfo) ->
	GuideStepId = GuideStepInfo#db_player_guide.guide_step_id,
	PlayerId = GuideStepInfo#db_player_guide.player_id,
	db_cache_lib:insert(?DB_PLAYER_GUIDE, {GuideStepId, PlayerId}, GuideStepInfo).

update(PlayerId, GuideStepInfo) ->
	db_cache_lib:update(?DB_PLAYER_GUIDE, {GuideStepInfo#db_player_guide.guide_step_id, PlayerId}, GuideStepInfo).

delete(PlayerId, GuideStepInfo) ->
	db_cache_lib:delete(?DB_PLAYER_GUIDE, {GuideStepInfo#db_player_guide.guide_step_id, PlayerId}).

%% API

