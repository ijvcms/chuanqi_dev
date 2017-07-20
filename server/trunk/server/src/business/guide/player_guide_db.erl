%%%-------------------------------------------------------------------
%%% @author apple
%%% @copyright (C) 2015, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 30. 十一月 2015 14:11
%%%-------------------------------------------------------------------
-module(player_guide_db).

-include("common.hrl").
-include("cache.hrl").

%% API
-export([
	select_row/1,
	select_all/1,
	insert/1,
	update/2,
	delete/1
]).

%% ====================================================================
%% API functions
%% ====================================================================

select_row({GuideStepId, PlayerId}) ->
	case db:select_row(player_guide, record_info(fields, db_player_guide), [{guide_step_id, GuideStepId}, {player_id, PlayerId}]) of
		[] ->
			null;
		List ->
			list_to_tuple([db_player_guide | List])
	end.

select_all({'_', PlayerId}) ->
	case db:select_all(player_guide, record_info(fields, db_player_guide), [{player_id, PlayerId}]) of
		[] ->
			[];
		List ->
			[list_to_tuple([db_player_guide | X]) || X <- List]
	end.

insert(GuideStepInfo) ->
	db:insert(player_guide, util_tuple:to_tuple_list(GuideStepInfo)).

update({GuideStepId, PlayerId}, GuideStepInfo) ->
	db:update(player_guide, util_tuple:to_tuple_list(GuideStepInfo), [{guide_step_id, GuideStepId}, {player_id, PlayerId}]).

delete({GuideStepId, PlayerId}) ->
	db:delete(player_guide, [{guide_step_id, GuideStepId}, {player_id, PlayerId}]).
%% API

