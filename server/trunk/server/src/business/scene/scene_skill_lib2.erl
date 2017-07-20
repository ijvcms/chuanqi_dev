%%%-------------------------------------------------------------------
%%% @author zhengsiying
%%% @copyright (C) 2015, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 09. 十一月 2015 下午3:04
%%%-------------------------------------------------------------------
-module(scene_skill_lib2).

-include("common.hrl").
-include("record.hrl").
-include("config.hrl").
-include("proto.hrl").
-include("cache.hrl").
-include("language_config.hrl").
%% API
-export([

]).

%% callbacks
-export([
	check_skill/3,
	do_check_skill/4
]).

%% 对象使用技能，这里是真实触发技能效果(玩家进程调用)
check_skill(PlayerState, SkillConf, TargetObjOrPoint) when is_record(PlayerState, player_state) ->
	PlayerId = PlayerState#player_state.player_id,
	case util_data:check_pid(PlayerState#player_state.scene_pid) of
		true->
			case gen_server2:apply_sync(PlayerState#player_state.scene_pid, {?MODULE, do_check_skill,
				[{?OBJ_TYPE_PLAYER, PlayerId}, SkillConf, TargetObjOrPoint]}) of
				{ok, _} ->
					true;
				ERR ->
					ERR
			end;
		_->
			{fail, ?ERR_SKILL_4}
	end.


%% ====================================================================
%% Internal functions
%% ====================================================================
%% 检查施法者，技能和受击者信息
do_check_skill(SceneState, {CasterType, CasterId}, SkillConf, TargetObjOrPoint) ->
	%% 检查释放者 在场景中的信息 释放正常
	case check_caster(SceneState, CasterType, CasterId) of
		{ok, CasterState} ->
			%% 检查目标 在场景中的信息  释放正常
			check_target(SceneState, CasterState, SkillConf, TargetObjOrPoint);
		{fail, Err} ->
			{fail, Err}
	end.


%% 检查技能的释放范围 以及被攻击的目标集合
check_target(SceneState, CasterState, SkillConf, {target, TargetType, TargetId}) ->
	case scene_base_lib:get_scene_obj_state(SceneState, TargetType, TargetId) of
		#scene_obj_state{cur_hp = CurHp} = TargetState when CurHp > 0 ->
			CasterX = CasterState#scene_obj_state.x,
			CasterY = CasterState#scene_obj_state.y,
			TargetX = TargetState#scene_obj_state.x,
			TargetY = TargetState#scene_obj_state.y,
			%% 检查施法距离
			case check_spell_distance(SkillConf, {CasterX, CasterY}, {TargetX, TargetY}) of
				true ->
					{ok, 0};
				_ ->
					{fail, ?ERR_SKILL_5}
			end;
		_ ->
			{fail, ?ERR_SKILL_6}
	end;
check_target(_SceneState, CasterState, SkillConf, {point, TargetX, TargetY}) ->
	CasterX = CasterState#scene_obj_state.x,
	CasterY = CasterState#scene_obj_state.y,
	case check_spell_distance(SkillConf, {CasterX, CasterY}, {TargetX, TargetY}) of
		true ->
			{ok, 0};
		_ ->
			{fail, ?ERR_SKILL_5}
	end.
%% 检查场景对象的信息 释放正常
check_caster(SceneState, CasterType, CasterId) ->
	case scene_base_lib:get_scene_obj_state(SceneState, CasterType, CasterId) of
		#scene_obj_state{cur_hp = CurHp} = CasterState when CurHp > 0 ->
			{ok, CasterState};
		_ ->
			{fail, ?ERR_SKILL_4}
	end.
%% 检查施法距离
check_spell_distance(SkillConf, {CasterX, CasterY}, {TargetX, TargetY}) ->
	Distance = util_math:get_distance_set({CasterX, CasterY}, {TargetX, TargetY}),

	Temp = SkillConf#skill_conf.spell_distance + ?MIN_SPELL_DISTANCE_AMEND,
	case SkillConf#skill_conf.skill_id of
		20300 ->
			Temp1=20,
			Distance =< Temp1 * Temp1 orelse
				SkillConf#skill_conf.target == ?SKILL_TARGET_MYSELF;
		_ ->
			Distance =< Temp * Temp orelse
				SkillConf#skill_conf.target == ?SKILL_TARGET_MYSELF
	end.
