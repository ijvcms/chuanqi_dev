%%%-------------------------------------------------------------------
%%% @author zhengsiying
%%% @copyright (C) 2016, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 19. 二月 2016 上午10:00
%%%-------------------------------------------------------------------
-module(obj_image_lib).

-include("common.hrl").
-include("record.hrl").

%% callbacks
-export([
	ai_action/2,
	on_timer/2,
	on_harm/4,
	on_die/3,
	do_move/2,
	on_cure/2,
	do_trigger_skill/2
]).

%% ====================================================================
%% API functions
%% ====================================================================
%% AI行动事件
ai_action(SceneState, ObjState) ->
	case get_target(SceneState, ObjState) of
		{Res, TargetState} ->
			do_action(Res, SceneState, ObjState, TargetState);
		_ ->
			case find_new_target(SceneState, ObjState) of
				{Res, TargetState} ->
					do_action(Res, SceneState, ObjState, TargetState);
				_ ->
					{SceneState1, ObjState1} = game_obj_lib:set_cur_target(SceneState, ObjState, null),
					case ObjState1#scene_obj_state.patrol_range > 0 of
						true ->
							game_obj_lib:do_patrol(SceneState1, ObjState1);
						_ ->
							RestTime = game_obj_lib:get_rest_time(ObjState1),
							game_obj_lib:do_wait(SceneState1, ObjState1, RestTime, {ai_action, []})
					end
			end
	end.

%% 定时器
on_timer(SceneState, ObjState) ->
	{SceneState, ObjState}.

do_move(SceneState, ObjState) ->
	{SceneState, ObjState}.

do_trigger_skill(SceneState, ObjState) ->
	{SceneState, ObjState}.

on_cure(SceneState, ObjState) ->
	{SceneState, ObjState}.

%% 受伤事件(这里不用做特殊的事情，受伤死亡在基类里面有做处理)
%% SceneState: 场景状态
%% ObjState: 当前处理对象状态
%% _HarmProto: 伤害信息
%% _CasterState: 施法者状态
on_harm(SceneState, ObjState, _HarmProto, _CasterState) ->
	{SceneState, ObjState}.

%% 死亡事件
%% SceneState: 场景状态
%% ObjState: 当前处理对象状态
%% KillerState: 杀人者
on_die(SceneState, ObjState, KillerState) ->
	#scene_obj_state{
		obj_type = ObjType,
		obj_id = ObjId
	} = ObjState,
	case scene_obj_lib:do_obj_die(SceneState, ObjType, ObjId, [], KillerState, null) of
		{ok, SceneState1} ->
			ObjState1 = scene_base_lib:get_scene_obj_state(SceneState1, ObjType, ObjId),
			{SceneState1, ObjState1};
		_ ->
			{SceneState, ObjState}
	end.

%% ====================================================================
%% Internal functions
%% ====================================================================
%% 目标可用技能攻击
do_action({?CHECK_TARGET_CAN_ATTACK, SkillId}, SceneState, ObjState, TargetState) ->
	{SceneState1, ObjState1} = game_obj_lib:set_cur_target(SceneState, ObjState, TargetState),
	game_obj_lib:do_attack(SceneState1, ObjState1, SkillId, TargetState);
%% 所有技能都在CD中，需要等待最短CD时间后再行动
do_action({?CHECK_TARGET_SKILL_CD, WaitTime}, SceneState, ObjState, TargetState) ->
	{SceneState1, ObjState1} = game_obj_lib:set_cur_target(SceneState, ObjState, TargetState),
	game_obj_lib:do_wait(SceneState1, ObjState1, WaitTime, {ai_action, []});
%% 目标远离
do_action(?CHECK_TARGET_SO_FAR, SceneState, ObjState, TargetState) ->
	case ObjState#scene_obj_state.chase_range > 0 of
		true ->
			{SceneState1, ObjState1} = game_obj_lib:set_cur_target(SceneState, ObjState, TargetState),
			game_obj_lib:do_chase(SceneState1, ObjState1, TargetState);
		_ ->
			{SceneState1, ObjState1} = game_obj_lib:set_cur_target(SceneState, ObjState, null),
			RestTime = game_obj_lib:get_rest_time(ObjState1),
			game_obj_lib:do_wait(SceneState1, ObjState1, RestTime, {ai_action, []})
	end;
do_action(_, SceneState, ObjState, _TargetState) ->
	{SceneState1, ObjState1} = game_obj_lib:set_cur_target(SceneState, ObjState, null),
	case ObjState#scene_obj_state.patrol_range > 0 of
		true ->
			game_obj_lib:do_patrol(SceneState1, ObjState1);
		_ ->
			RestTime = game_obj_lib:get_rest_time(ObjState1),
			game_obj_lib:do_wait(SceneState1, ObjState1, RestTime, {ai_action, []})
	end.

%% 获取目标
get_target(SceneState, ObjState) ->
	case ObjState#scene_obj_state.cur_target of
		#cur_target_info{obj_type = ObjType, obj_id = ObjId} = _Enmity ->
			%% 如果有追击目标
			case scene_base_lib:get_scene_obj_state(SceneState, ObjType, ObjId) of
				#scene_obj_state{} = TargetState ->
					case game_obj_lib:check_target(SceneState, ObjState, TargetState) of
						?CHECK_TARGET_DIE ->
							null;
						Res ->
							{Res, TargetState}
					end;
				_ ->
					null
			end;
		_ ->
			null
	end.

%% 找新目标
find_new_target(SceneState, ObjState) ->
	#scene_obj_state{
		obj_type = ObjType,
		obj_id = ObjId
	} = ObjState,
	ScreenObjList = scene_base_lib:do_get_screen_biont(SceneState, ObjType, ObjId, false),
	HostileList = get_hostile_list(ObjState, ScreenObjList),
	case HostileList /= [] of
		true ->
			%% 寻找目标
			chose_target(SceneState, ObjState, HostileList);
		_ ->
			null
	end.

get_hostile_list(_ObjState, ScreenObjList) ->
	ScreenObjList.

%% 寻找新的目标
chose_target(SceneState, ObjState, HostileList) ->
	#scene_obj_state{
		x = X,
		y = Y
	} = ObjState,

	F = fun(TargetState, Acc) ->
		case game_obj_lib:check_target(SceneState, ObjState, TargetState) of
			?CHECK_TARGET_DIE ->
				Acc;
			?CHECK_TARGET_INVISIBILITY ->
				Acc;
			Res ->
				{_, D} = Acc,
				#scene_obj_state{
					x = X1,
					y = Y1
				} = TargetState,
				D1 = util_math:get_distance_set({X, Y}, {X1, Y1}),
				case D1 < D * D of
					true ->
						{{Res, TargetState}, D1};
					_ ->
						Acc
				end
		end
	end,
	%% Dist : 玩家离怪物距离
	{TargetRes, _Dist} = lists:foldl(F, {null, 999999}, HostileList),
	TargetRes.
