%%%-------------------------------------------------------------------
%%% @author zhengsiying
%%% @copyright (C) 2015, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 20. 十月 2015 下午6:30
%%%-------------------------------------------------------------------
-module(hook_star_reward_db).

-include("common.hrl").
-include("cache.hrl").

%% API
-export([
	select_all/1,
	select_row/1,
	insert/1,
	replace/1,
	update/2
]).

%% ====================================================================
%% API functions
%% ====================================================================
select_all({PlayerId, '_'}) ->
	case db:select_all(hook_star_reward, record_info(fields, db_hook_star_reward), [{player_id, PlayerId}]) of
		[] ->
			[];
		List ->
			[
				begin
					Recard = list_to_tuple([db_hook_star_reward | X]),
					StepList = util_data:string_to_term(Recard#db_hook_star_reward.step_list),
					Recard#db_hook_star_reward{step_list = StepList}
				end || X <- List]
	end.

select_row({PlayerId, Chapter}) ->
	case db:select_row(hook_star_reward, record_info(fields, db_hook_star_reward), [{player_id, PlayerId}, {chapter, Chapter}]) of
		[] ->
			null;
		List ->
			Recard = list_to_tuple([db_hook_star_reward | List]),
			StepList = util_data:string_to_term(Recard#db_hook_star_reward.step_list),
			Recard#db_hook_star_reward{step_list = StepList}
	end.

insert(HookStarReward) ->
	StepList = util_data:term_to_string(HookStarReward#db_hook_star_reward.step_list),
	HookStarReward1 = HookStarReward#db_hook_star_reward{step_list = StepList},
	db:insert(hook_star_reward, util_tuple:to_tuple_list(HookStarReward1)).

replace(HookStarReward) ->
	StepList = util_data:term_to_string(HookStarReward#db_hook_star_reward.step_list),
	HookStarReward1 = HookStarReward#db_hook_star_reward{step_list = StepList},
	db:replace(hook_star_reward, util_tuple:to_tuple_list(HookStarReward1)).

update({PlayerId, Chapter}, HookStarReward) ->
	StepList = util_data:term_to_string(HookStarReward#db_hook_star_reward.step_list),
	HookStarReward1 = HookStarReward#db_hook_star_reward{step_list = StepList},
	db:update(hook_star_reward, util_tuple:to_tuple_list(HookStarReward1), [{player_id, PlayerId}, {chapter, Chapter}]).

