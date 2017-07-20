%%%-------------------------------------------------------------------
%%% @author zhengsiying
%%% @copyright (C) 2015, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 11. 八月 2015 下午6:37
%%%-------------------------------------------------------------------
-module(skill_cache).

-include("common.hrl").
-include("cache.hrl").

%% API
-export([
	select_all/1,
	select_row/1,
	insert/1,
	delete/1,
	update/2,
	remove_cache/1
]).

%% ====================================================================
%% API functions
%% ====================================================================
select_all(PlayerId) ->
	db_cache_lib:select_all(?DB_SKILL, {PlayerId, '_'}).

select_row({PlayerId, SkillId}) ->
	db_cache_lib:select_row(?DB_SKILL, {PlayerId, SkillId}).

insert(Skill) ->
	#db_skill{
		player_id = PlayerId,
		skill_id = SkillId
	} = Skill,
	db_cache_lib:insert(?DB_SKILL, {PlayerId, SkillId}, Skill).

delete({PlayerId, SkillId}) ->
	db_cache_lib:delete(?DB_SKILL, {PlayerId, SkillId}).


update({PlayerId, SkillId}, UpdateSkill) ->
	db_cache_lib:update(?DB_SKILL, {PlayerId, SkillId}, UpdateSkill).

remove_cache(PlayerId) ->
	db_cache_lib:remove_all_cache(?DB_SKILL, {PlayerId, '_'}).

%% ====================================================================
%% Internal functions
%% ====================================================================
