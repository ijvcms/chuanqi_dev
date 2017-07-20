%%%-------------------------------------------------------------------
%%% @author zhengsiying
%%% @copyright (C) 2015, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 11. 八月 2015 下午6:06
%%%-------------------------------------------------------------------
-module(skill_db).

-include("common.hrl").
-include("cache.hrl").

%% API
-export([
	select_all/1,
	select_row/1,
	insert/1,
	delete/1,
	update/2
]).

%% ====================================================================
%% API functions
%% ====================================================================
select_all({PlayerId, '_'}) ->
	case db:select_all(skill, record_info(fields, db_skill), [{player_id, PlayerId}]) of
		[] ->
			[];
		List ->
			[list_to_tuple([db_skill | X]) || X <- List]
	end.

select_row({PlayerId, SkillId}) ->
	case db:select_row(skill, record_info(fields, db_skill), [{player_id, PlayerId}, {skill_id, SkillId}]) of
		[] ->
			null;
		List ->
			list_to_tuple([db_skill | List])
	end.

insert(Skill) ->
	db:insert(skill, util_tuple:to_tuple_list(Skill)).

update({PlayerId, SkillId}, Skill) ->
	db:update(skill, util_tuple:to_tuple_list(Skill), [{player_id, PlayerId}, {skill_id, SkillId}]).

delete({PlayerId, SkillId}) ->
	db:delete(skill,  [{player_id, PlayerId}, {skill_id, SkillId}]).

