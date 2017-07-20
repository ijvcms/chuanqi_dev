%%%-------------------------------------------------------------------
%%% @author zhengsiying
%%% @copyright (C) 2016, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 25. 一月 2016 下午4:50
%%%-------------------------------------------------------------------
-module(game_obj_lib).

-include("common.hrl").
-include("record.hrl").
-include("config.hrl").
-include("cache.hrl").
-include("proto.hrl").

%% API
-export([
	start_ai/2,
	stop_ai/2,
	ai_action/2,
	on_timer/2,
	on_harm/4,
	on_cure/4,
	on_die/3,
	on_remove/2,
	on_knockback/4,
	check_target/3,
	check_owner/2,
	get_rest_time/1,
	instant_move/3,
	change_scene/4,
	set_cur_target/3,
	set_drop_owner/4,
	get_round_rand_point/3,
	do_chase/3,
	do_patrol/2,
	do_follow/2,
	do_wait/4,
	do_stop/2,
	do_move/2,
	do_attack/4,
	do_trigger_skill/2,
	do_set_move/2,
	set_monster_targer/4
]).

%% ====================================================================
%% API functions
%% ====================================================================
%% 启动怪物AI(现在还不需要用到这个)
start_ai(SceneState, ObjState) ->
	ObjState1 = ObjState#scene_obj_state{
		ai_state = ?AI_STATE_WAIT
	},
	SceneState1 = scene_base_lib:store_scene_obj_state(SceneState, ObjState1, ObjState),
	do_action(SceneState1, ObjState1, ai_action, []).
%% 停止怪物AI(这里现在也使用不到)
stop_ai(SceneState, ObjState) ->
	do_stop(SceneState, ObjState).

%% AI行动，基类里面只写一个虚函数(具体的AI具体写)
ai_action(SceneState, ObjState) ->
	{SceneState, ObjState}.

%% 定时器(这里只是提供方法让场景进程调用，使用的是场景进程的定时器，不是一个真实的timer)
%% on_timer(SceneState, ObjState) ->
%% 	{SceneState, ObjState}.
on_timer(SceneState, ObjState) ->
	case ObjState#scene_obj_state.action_cmd of
		{on_remove, []} ->
			%% 移除事件(这个事件特殊处理)
			CurTime = util_date:longunixtime(),
			case ObjState#scene_obj_state.next_action_time =< CurTime of %% 达到或者超过行动时间
				true ->
					%% 执行对应逻辑
					on_remove(SceneState, ObjState);
				_ ->
					{SceneState, ObjState}
			end;
		{ActionFun, Args} ->
			%% 其他事件(说明AI对象没有死亡或者消失)
			%% 在执行动作前先检查AI对象身上的buff(做移除或者是触发buff)
			{SceneState1, ObjState1, KillObjId} = buff_base_lib:trigger_effect(SceneState, ObjState),

			%% 执行派生AI的定时器逻辑
			{SceneState2, ObjState2} = do_action(SceneState1, ObjState1, on_timer, []),
%% 			{SceneState2, ObjState2} = {SceneState1, ObjState1},
			%% 判断血量，如果小于等于0，直接调用基类死亡方法
			{SceneState3, ObjState3} =
				case ObjState2#scene_obj_state.cur_hp > 0 of
					true ->
						{SceneState2, ObjState2};
					_ ->
						KillObj = scene_base_lib:get_scene_obj_state(SceneState2, ?OBJ_TYPE_PLAYER, KillObjId),
						game_obj_lib:on_die(SceneState2, ObjState2, KillObj)
				end,

			%% 判断AI是否可以行动
			case ObjState3#scene_obj_state.ai_state /= ?AI_STATE_STOP andalso can_action(ObjState3) of
				true ->
					CurTime = util_date:longunixtime(),
					%% 判断是否到达行动时间
					case ObjState3#scene_obj_state.next_action_time =< CurTime of
						true ->
							%% 先执行基类的对应方法
							{SceneState4, ObjState4} = util_sys:apply_catch(?MODULE, ActionFun, [SceneState3 | [ObjState3 | Args]]),
%% 							{SceneState4, ObjState4};
							%% 执行派生的方法
							do_action(SceneState4, ObjState4, ActionFun, Args);
						_ ->
							{SceneState3, ObjState3}
					end;
				_ ->
					{SceneState3, ObjState3}
			end;
		_ ->
			%% 其他事件(都需要检查buff，和执行派生的定时器)
			{SceneState1, ObjState1, _} = buff_base_lib:trigger_effect(SceneState, ObjState),
			do_action(SceneState1, ObjState1, on_timer, [])
	end.

%% 受伤事件处理
%% SceneState: 场景状态
%% ObjState: 当前处理对象状态
%% HarmProto: 伤害信息
%% CasterState: 施法者状态
on_harm(SceneState, ObjState, HarmProto, CasterState) ->
	{SceneState1, ObjState1} = do_action(SceneState, ObjState, on_harm, [HarmProto, CasterState]),
	log_monster:harm_start_time(ObjState1#scene_obj_state.monster_id, SceneState),
	case ObjState1#scene_obj_state.cur_hp =< 0 of
		true ->
			log_monster:kill(ObjState1#scene_obj_state.monster_id, SceneState),
			on_die(SceneState1, ObjState1, CasterState);
		_ ->
			{SceneState1, ObjState1}
	end.

%% 回血事件处理
%% SceneState: 场景状态
%% ObjState: 当前处理对象状态
%% CureProto: 回血信息
%% CasterState: 施法者状态
on_cure(SceneState, ObjState, CureProto, CasterState) ->
	do_action(SceneState, ObjState, on_cure, [CureProto, CasterState]).

%% 死亡事件处理
%% SceneState: 场景状态
%% ObjState: 当前处理对象状态
%% KillerState: 杀人者
on_die(SceneState, ObjState, KillerState) ->
	case ObjState#scene_obj_state.ai_state of
		?AI_STATE_DIE ->
			{SceneState, ObjState};
		_ ->
			%% 执行派生的死亡事件
			{SceneState1, ObjState1} = do_action(SceneState, ObjState, on_die, [KillerState]),
			%% 修改下个事件为移除事件
			CurTime = util_date:longunixtime(),
			NewObjState = ObjState1#scene_obj_state{
				next_action_time = CurTime + ?MONSTER_CORPSE_STAY_TIME,
				action_cmd = {on_remove, []},
				ai_state = ?AI_STATE_DIE
			},
			%% 更新对象信息
			NewSceneState = scene_base_lib:store_scene_obj_state(SceneState1, NewObjState, ObjState),
			{NewSceneState, NewObjState}
	end.

%% 移除事件处理
on_remove(SceneState, ObjState) ->
	#scene_obj_state{
		obj_type = ObjType,
		obj_id = ObjId
	} = ObjState,
	case scene_obj_lib:do_remove_obj(SceneState, ObjType, ObjId, ?LEAVE_SCENE_TYPE_INITIATIVE) of
		{ok, NewSceneState} ->
			{NewSceneState, ObjState};
		_ ->
			{SceneState, ObjState}
	end.

%% 被击退事件处理
%% SceneState: 场景状态
%% ObjState: 当前处理对象状态
%% _CasterState: 施法者状态
%% Proto: 被击退信息
on_knockback(SceneState, ObjState, _CasterState, Proto) ->
	#proto_point_change{begin_point = BP, end_point = EP} = Proto,
	#proto_point{x = BX, y = BY} = BP,
	#proto_point{x = EX, y = EY} = EP,
	D = max(util_math:get_distance({BX, BY}, {EX, EY}), 1),
	RestTime = D * 700,
	do_wait(SceneState, ObjState, RestTime, {ai_action, []}).

%% 检查目标是否在自己的攻击范围，并返回对应的状态
%% SceneState: 场景状态
%% ObjState: 当前处理对象状态
%% TargetState: 目标状态
check_target(SceneState, ObjState, TargetState) ->
	#scene_obj_state{
		obj_type = ObjType,
		owner_type = OwnerType,
		owner_id = OwnerId,
		x = X1,
		y = Y1,
		chase_range = ChaseRange,
		last_use_skill_time = LastUseTime,
		public_cd_interval = PublicCd
	} = ObjState,

	#scene_obj_state{
		x = X2,
		y = Y2,
		cur_hp = CurHp,
		buff_dict = BuffDict,
		effect_dict = EffectDict
	} = TargetState,

	%% 判断目标是否已经死亡
	case CurHp > 0 of
		true ->
			BuffEffect = buff_base_lib:get_buff_effect(BuffDict, EffectDict, ?BUFF_EFFECT_INVISIBILITY),
			%% 判断目标是否隐身 或者 带有抗性
			case (BuffEffect#buff_effect.effect_p == 0 andalso BuffEffect#buff_effect.effect_v == 0) orelse
				check_monster_resist(TargetState, ?BUFF_EFFECT_INVISIBILITY) of
				true ->
					Dist = util_math:get_distance({X1, Y1}, {X2, Y2}),
					%% 检查是否能够攻击目标(如果是返回对应的技能和需要等待的时间)
					case check_attack(ObjState, TargetState, Dist) of
						{ok, SkillId, WaitTime} when SkillId /= 0 ->
							CurTime = util_date:longunixtime(),
							WaitTime1 = PublicCd + LastUseTime - CurTime,
							WaitTime2 = max(WaitTime1, WaitTime),
							case WaitTime2 =< 0 of
								true ->
									%% 可以直接使用技能攻击目标
									{?CHECK_TARGET_CAN_ATTACK, SkillId};
								_ ->
									%% 技能CD中，需要等待
									{?CHECK_TARGET_SKILL_CD, WaitTime2}
							end;
						_ ->
							%% 距离目标太远所有技能都无法攻击到目标
							case ObjType of
								?OBJ_TYPE_MONSTER ->
									D = util_math:get_distance_set({X1, Y1}, {X2, Y2}),
									%% 判断是否在追击范围内
									case D =< ChaseRange * ChaseRange of
										true ->
											%% 在追击范围内，可以追击玩家
											?CHECK_TARGET_SO_FAR;
										_ ->
											%% 玩家已经逃离到追击范围外
											?CHECK_TARGET_ESCAPE
									end;
								?OBJ_TYPE_PET ->
									%% 检查主人是否跟自己在同一个场景
									case scene_base_lib:get_scene_obj_state(SceneState, OwnerType, OwnerId) of
										#scene_obj_state{x = X3, y = Y3} = _ ->
											D = util_math:get_distance_set({X3, Y3}, {X2, Y2}),
											%% 判断是否在追击范围内
											case D =< ChaseRange * ChaseRange of
												true ->
													%% 在追击范围内，可以追击玩家
													?CHECK_TARGET_SO_FAR;
												_ ->
													%% 玩家已经逃离到追击范围外
													?CHECK_TARGET_ESCAPE
											end;
										_ ->
											%% 主人不在不能追击
											?CHECK_TARGET_ESCAPE
									end;
								_ ->
									?CHECK_TARGET_SO_FAR
							end
					end;
				_ ->
					?CHECK_TARGET_INVISIBILITY
			end;
		_ ->
			?CHECK_TARGET_DIE
	end.

%% 检查主人状态
check_owner(SceneState, ObjState) ->
	#scene_obj_state{
		x = X,
		y = Y,
		owner_id = OwnerId,
		chase_range = ChaseRange
	} = ObjState,
	case scene_base_lib:get_scene_obj_state(SceneState, ?OBJ_TYPE_PLAYER, OwnerId) of
		#scene_obj_state{x = OwnerX, y = OwnerY} = _OwnerState ->
			Dist = util_math:get_distance_set({X, Y}, {OwnerX, OwnerY}),
			case Dist > ChaseRange * ChaseRange of
				true ->
					%% 主人远离
					{?CHECK_OWNER_SO_FAR, OwnerX, OwnerY};
				_ ->
					%% 主人就在自己附近
					{?CHECK_OWNER_SIDE, OwnerX, OwnerY}
			end;
		_ ->
			%% 主人更自己不在同一张场景
			?CHECK_OWNER_NOT_FOUND
	end.

%% 获取休息时间
get_rest_time(ObjState) ->
	case util_data:is_null(ObjState#scene_obj_state.cur_target) of
		true ->
			{Min, Max} = ObjState#scene_obj_state.patrol_interval,
			case ObjState#scene_obj_state.attack_type of
				?ATTACK_TYPE_MOVE ->
					util_rand:rand(Min, Max);
				?ATTACK_TYPE_MOVE_2 ->
					util_rand:rand(Min, Max);
				_ ->
					util_rand:rand(Min, Max)
			end;
		_ ->
			ObjState#scene_obj_state.chase_interval
	end.

%% 追踪
do_chase(SceneState, ObjState, TargetState) ->
	#scene_obj_state{
		obj_type = ObjType,
		birth_x = BirthX,
		birth_y = BirthY,
		x = X,
		y = Y,
		chase_range = Range,
		monster_id = MonsterId
	} = ObjState,
	X1 = TargetState#scene_obj_state.x,
	Y1 = TargetState#scene_obj_state.y,

	%% 判断玩家点是否超过了怪物的追踪距离
	case ObjType of
		?OBJ_TYPE_MONSTER ->
			Dist = util_math:get_distance_set({X, Y}, {X1, Y1}),

			{EX, EY} =
				case Dist > Range * Range of
					true ->
						%% 合成目标点
						compute_next_move_point(SceneState, ObjState, {BirthX, BirthY});
					_ ->
						%% boss使用a星寻路
						SceneId = SceneState#scene_state.scene_id,
						MonsterConf = monster_config:get(MonsterId),
						case MonsterConf#monster_conf.type of
							?MONSTER_TYPE_BOSS ->
								{EX2, EY2} =
									case area_lib:get_path(SceneId, X, Y, X1, Y1) of
										[{EX1, EY1} | _] ->
											{EX1, EY1};
										_ ->
											{X, Y}
									end,
								ObstacleDict = scene_base_lib:get_obstacle_dict(),
								%% 碰撞检查，判断位置是否已经有对象站在上面
								case dict:find({EX2, EY2}, ObstacleDict) of
									{ok, _} ->
										%% 有对象在上面 获取身边一个可走点走过去
										compute_next_move_point(SceneState, ObjState, {X1, Y1});
									_ ->
										{EX2, EY2}
								end;
							_ ->
								compute_next_move_point(SceneState, ObjState, {X1, Y1})
						end
				end,
			start_move(SceneState, ObjState, {EX, EY});
		_ ->
			{EX, EY} = compute_next_move_point(SceneState, ObjState, {X1, Y1}),
			start_move(SceneState, ObjState, {EX, EY})
	end.

%% 巡逻
do_patrol(SceneState, ObjState) ->
	SceneId = SceneState#scene_state.scene_id,
	#scene_obj_state{
		x = CurX,
		y = CurY,
		patrol_rate = Rate,%% 巡逻概率
		patrol_range = Range, %% 巡逻范围
		patrol_list = PatrolList %% 巡逻坐标列表
	} = ObjState,
	case util_rand:rand_hit(Rate) of
		true ->
			List =
				case util_data:is_null(PatrolList) of
					true ->
						area_lib:get_round_point_list(SceneId, {CurX, CurY}, Range);
					_ ->
						PatrolList
				end,

			case List /= [] of
				true ->
					{X, Y} = util_rand:list_rand(List),
					{EX, EY} = compute_next_move_point(SceneState, ObjState, {X, Y}),
					%% 移动占用cup多
					start_move(SceneState, ObjState, {EX, EY});
				_ ->
					RestTime = get_rest_time(ObjState),
					do_wait(SceneState, ObjState, RestTime, {ai_action, []})
			end;
		_ ->
			RestTime = get_rest_time(ObjState),
			do_wait(SceneState, ObjState, RestTime, {ai_action, []})
	end.

%% 移动到指定位置
do_set_move(SceneState, ObjState) ->
	#scene_obj_state{
		patrol_range = {X, Y},
		patrol_rate = Rate,
		x = CurX,
		y = CurY
	} = ObjState,

	case util_rand:rand_hit(Rate) of
		true ->
			%% 怪物攻城使用a星寻路
			SceneId = SceneState#scene_state.scene_id,
			{EX, EY} =
				case area_lib:get_path(SceneId, {CurX, CurY}, {X, Y}) of
					[{_, _}, {EX1, EY1} | _] ->
						{EX1, EY1};
					_ ->
						{X, Y}
				end,
			ObstacleDict = scene_base_lib:get_obstacle_dict(),
			%% 碰撞检查，判断位置是否已经有对象站在上面
			case dict:find({EX, EY}, ObstacleDict) of
				{ok, _} ->
					%% 有对象在上面 获取身边一个可走点走过去
					{X1, Y1} = compute_next_move_point(SceneState, ObjState, {X, Y}),
					start_move(SceneState, ObjState, {X1, Y1});
				_ ->
					%% 如果没有对象站在上面(这个点离目标点是否比上面找出的合法点还要近)
					start_move(SceneState, ObjState, {EX, EY})
			end;
		false ->
			RestTime = get_rest_time(ObjState),
			do_wait(SceneState, ObjState, RestTime, {ai_action, []})
	end.

%% 跟随
do_follow(SceneState, ObjState) ->
	case game_obj_lib:check_owner(SceneState, ObjState) of
		{?CHECK_OWNER_SO_FAR, X, Y} ->
			{EX, EY} = get_round_rand_point(SceneState#scene_state.scene_id, X, Y),
			instant_move(SceneState, ObjState, {EX, EY});
		{?CHECK_OWNER_SIDE, X, Y} ->
			#scene_obj_state{
				x = X1,
				y = Y1
			} = ObjState,
			Dist = util_math:get_distance_set({X, Y}, {X1, Y1}),
			case Dist =< ObjState#scene_obj_state.patrol_range * ObjState#scene_obj_state.patrol_range of
				true ->
					RestTime = get_rest_time(ObjState),
					do_wait(SceneState, ObjState, RestTime, {ai_action, []});
				_ ->
					{X2, Y2} = get_round_rand_point(SceneState#scene_state.scene_id, X, Y),
					{EX, EY} = compute_next_move_point(SceneState, ObjState, {X2, Y2}),
					start_move(SceneState, ObjState, {EX, EY})
			end;
		_ ->
			RestTime = get_rest_time(ObjState),
			do_wait(SceneState, ObjState, RestTime, {ai_action, []})
	end.

%% 开始移动(不是真实移动)
start_move(SceneState, ObjState, {EX, EY}) ->
	#scene_obj_state{
		obj_type = ObjType,
		obj_id = ObjId,
		x = BX,
		y = BY
	} = ObjState,
	case area_lib:is_same_point({BX, BY}, {EX, EY}) of
		true ->
			RestTime = get_rest_time(ObjState),
			do_wait(SceneState, ObjState, RestTime, {ai_action, []});
		_ ->
			%% 通知场景开始移动
			Direction = area_lib:get_direction({BX, BY}, {EX, EY}),
			case scene_obj_lib:do_start_move(SceneState, ObjType, ObjId, {BX, BY}, {EX, EY}, Direction) of
				{ok, SceneState1} ->
					ObjState1 = scene_base_lib:get_scene_obj_state(SceneState1, ObjType, ObjId),
					RestTime = get_rest_time(ObjState1),
					%% 移动cpu占用多
					do_wait(SceneState1, ObjState1, RestTime, {do_move, []});
				_ ->
					RestTime = get_rest_time(ObjState),
					do_wait(SceneState, ObjState, RestTime, {ai_action, []})
			end
	end.

%% 瞬间移动
instant_move(SceneState, ObjState, {EX, EY}) ->
	#scene_obj_state{
		obj_type = ObjType,
		obj_id = ObjId,
		x = BX,
		y = BY
	} = ObjState,

	Direction = area_lib:get_direction({BX, BY}, {EX, EY}),
%% 	SceneState1 = scene_base_lib:store_scene_obj_state(SceneState, ObjState), 多余的保存
	case scene_obj_lib:do_move_sync(SceneState, ObjType, ObjId, {EX, EY}, Direction, true) of
		{ok, SceneState2} ->
			ObjState1 = scene_base_lib:get_scene_obj_state(SceneState2, ObjType, ObjId),
			RestTime = game_obj_lib:get_rest_time(ObjState1),
			game_obj_lib:do_wait(SceneState2, ObjState1, RestTime, {ai_action, []});
		_ ->
			RestTime = game_obj_lib:get_rest_time(ObjState),
			game_obj_lib:do_wait(SceneState, ObjState, RestTime, {ai_action, []})
	end.

%% 切换场景
change_scene(SceneState, ObjState, ScenePid, {X, Y}) ->
	%% 先移除原场景对象
	{SceneState1, ObjState1} = on_remove(SceneState, ObjState),
	scene_obj_lib_copy:enter(ObjState, null, ScenePid, ?CHANGE_SCENE_TYPE_CHANGE, {X, Y}),

	{SceneState1, ObjState1}.

%% 设置当前目标
set_cur_target(SceneState, ObjState, TargetState) ->
	OldTarget = ObjState#scene_obj_state.cur_target,
	case util_data:is_null(OldTarget) of
		true ->
			case util_data:is_null(TargetState) of
				true ->
					{SceneState, ObjState};
				_ ->
					#scene_obj_state{
						obj_type = TargetType,
						obj_id = TargetId,
						name = Name,
						career = Career,
						sex = Sex,
						monster_id = MonsterId
					} = TargetState,

					CurTarget = #cur_target_info{
						obj_type = TargetType,
						obj_id = TargetId,
						name = Name,
						career = Career,
						sex = Sex,
						monster_id = MonsterId
					},
					update_cur_target(SceneState, ObjState, CurTarget)
			end;
		_ ->
			#cur_target_info{
				obj_type = TargetType1,
				obj_id = TargetId1
			} = OldTarget,
			case util_data:is_null(TargetState) of
				true ->
					update_cur_target(SceneState, ObjState, null);
				_ ->
					#scene_obj_state{
						obj_type = TargetType,
						obj_id = TargetId,
						name = Name,
						career = Career,
						sex = Sex,
						monster_id = Monsterid
					} = TargetState,
					case {TargetType, TargetId} /= {TargetType1, TargetId1} of
						true ->
							CurTarget = #cur_target_info{
								obj_type = TargetType,
								obj_id = TargetId,
								name = Name,
								career = Career,
								sex = Sex,
								monster_id = Monsterid
							},
							update_cur_target(SceneState, ObjState, CurTarget);
						_ ->
							{SceneState, ObjState}
					end
			end
	end.

%% 更新当前目标
update_cur_target(SceneState, ObjState, CurTarget) ->
	#scene_obj_state{
		monster_id = MonsterId
	} = ObjState,

	NewObjState = ObjState#scene_obj_state{cur_target = CurTarget},
	case util_data:is_null(MonsterId) of
		true ->
			skip;
		_ ->
			MonsterConf = monster_config:get(MonsterId),
			case MonsterConf#monster_conf.type of
				?MONSTER_TYPE_BOSS ->
					scene_send_lib:send_monster_update(SceneState, NewObjState);
				_ ->
					skip
			end
	end,
	NewSceneState = scene_base_lib:store_scene_obj_state(SceneState, NewObjState, ObjState),
	{NewSceneState, NewObjState}.

%% 设置掉落归属对象
set_drop_owner(SceneState, ObjState, DropOwner, HarmValue) ->
	case not util_data:is_null(DropOwner) of
		true ->
			case util_data:is_null(ObjState#scene_obj_state.drop_owner) of
				true ->
					DropOwner1 = DropOwner#cur_drop_owner_info{total_harm = HarmValue, harm = HarmValue},
					update_drop_owner(SceneState, ObjState, DropOwner1);
				_ ->
					OldDropOwnerInfo = ObjState#scene_obj_state.drop_owner,
					#cur_drop_owner_info{
						player_id = OldId,
						effective_time = OldTime,
						harm = OldHarm
					} = OldDropOwnerInfo,
					NewId = DropOwner#cur_drop_owner_info.player_id,

					CurTime = util_date:unixtime(),
					if
						OldId /= NewId andalso OldTime < CurTime ->
							DropOwner1 = DropOwner#cur_drop_owner_info{total_harm = HarmValue, harm = HarmValue},
							update_drop_owner(SceneState, ObjState, DropOwner1);
						OldId == NewId ->
							TotalHarm = OldDropOwnerInfo#cur_drop_owner_info.total_harm,
							DropOwner1 = DropOwner#cur_drop_owner_info{total_harm = TotalHarm + HarmValue, harm = HarmValue + OldHarm},
							NewObjState = ObjState#scene_obj_state{drop_owner = DropOwner1},
							NewSceneState = scene_base_lib:store_scene_obj_state(SceneState, NewObjState, ObjState),
							{NewSceneState, NewObjState};
						true ->
							TotalHarm = OldDropOwnerInfo#cur_drop_owner_info.total_harm,
							DropOwner1 = OldDropOwnerInfo#cur_drop_owner_info{total_harm = TotalHarm + HarmValue},
							NewObjState = ObjState#scene_obj_state{drop_owner = DropOwner1},
							{SceneState, NewObjState}
					end
			end;
		_ ->
			{SceneState, ObjState}
	end.

%% 更新当前归属
update_drop_owner(SceneState, ObjState, DropOwner) ->
	#scene_obj_state{
		monster_id = MonsterId
	} = ObjState,

	NewObjState = ObjState#scene_obj_state{drop_owner = DropOwner},
	case util_data:is_null(MonsterId) of
		true ->
			skip;
		_ ->
			MonsterConf = monster_config:get(MonsterId),
			case MonsterConf#monster_conf.type of
				?MONSTER_TYPE_BOSS ->
					scene_send_lib:send_monster_update(SceneState, NewObjState);
				_ ->
					skip
			end
	end,

	NewSceneState = scene_base_lib:store_scene_obj_state(SceneState, NewObjState, ObjState),
	{NewSceneState, NewObjState}.

%% 等待(用于设置下一次行动事件)
do_wait(SceneState, ObjState, Time, ActionCmd) ->
	CurTime = util_date:longunixtime(),
	ObjState1 = ObjState#scene_obj_state{
		next_action_time = CurTime + Time,
		action_cmd = ActionCmd,
		ai_state = ?AI_STATE_WAIT
	},
	SceneState1 = scene_base_lib:store_scene_obj_state(SceneState, ObjState1, ObjState),
	{SceneState1, ObjState1}.

%% AI停止
do_stop(SceneState, ObjState) ->
	ObjState1 = ObjState#scene_obj_state{
		ai_state = ?AI_STATE_STOP
	},
	SceneState1 = scene_base_lib:store_scene_obj_state(SceneState, ObjState1, ObjState),
	{SceneState1, ObjState1}.

%% 移动
do_move(SceneState, ObjState) ->
	#scene_obj_state{
		obj_type = ObjType,
		obj_id = ObjId,
		x = X,
		y = Y,
		ex = EX,
		ey = EY,
		direction = Direction
	} = ObjState,
	case {X, Y} /= {EX, EY} of
		true ->
			case scene_obj_lib:do_move_sync(SceneState, ObjType, ObjId, {EX, EY}, Direction) of%% 移动同步
				{ok, SceneState1} ->
					ObjState1 = scene_base_lib:get_scene_obj_state(SceneState1, ObjType, ObjId),
					RestTime = get_rest_time(ObjState),
					do_wait(SceneState1, ObjState1, RestTime, {ai_action, []});
				_ ->
					RestTime = get_rest_time(ObjState),
					do_wait(SceneState, ObjState, RestTime, {ai_action, []})
			end;
		_ ->
			RestTime = get_rest_time(ObjState),
			do_wait(SceneState, ObjState, RestTime, {ai_action, []})
	end.

%% 攻击(这里还没有触发技能效果，只是用于播攻击动作)
do_attack(SceneState, ObjState, SkillId, TargetState) ->
	#scene_obj_state{
		obj_type = CasterType,
		obj_id = CasterId,
		x = X1,
		y = Y1,
		skill_dict = SkillDict
	} = ObjState,

	#scene_obj_state{
		obj_type = TargetType,
		obj_id = TargetId,
		x = X2,
		y = Y2
	} = TargetState,
	{ok, SkillInfo} = dict:find(SkillId, SkillDict),
	SkillConf = skill_config:get({SkillId, SkillInfo#db_skill.lv}),
	CurTime = util_date:longunixtime(),
	NewSkill = SkillInfo#db_skill{next_time = CurTime + SkillConf#skill_conf.cd},  %% 冷却时间
	NewSkillDict = dict:store(SkillId, NewSkill, SkillDict), %% 替换技能状态信息 保存
	ObjState1 = ObjState#scene_obj_state{skill_dict = NewSkillDict},

	SceneState1 = scene_base_lib:store_scene_obj_state(SceneState, ObjState1, ObjState),
	Direction = area_lib:get_direction({X1, Y1}, {X2, Y2}),
	case can_use_skill(ObjState) of
		true ->
			case scene_skill_lib:do_obj_start_use_skill(SceneState1, {CasterType, CasterId}, {SkillInfo#db_skill.skill_id, SkillInfo#db_skill.lv}, {target, TargetType, TargetId}, Direction) of
				{ok, SceneState2} ->
					ObjState2 = scene_base_lib:get_scene_obj_state(SceneState2, CasterType, CasterId),
					RestTime = SkillConf#skill_conf.spell_time,
					do_wait(SceneState2, ObjState2, RestTime, {do_trigger_skill, []});
				_Err ->
					RestTime = get_rest_time(ObjState),
					do_wait(SceneState, ObjState, RestTime, {ai_action, []})
			end;
		false ->
			RestTime = get_rest_time(ObjState),
			do_wait(SceneState, ObjState, RestTime, {ai_action, []})
	end.

%% 触发技能效果
do_trigger_skill(SceneState, ObjState) ->
	#scene_obj_state{
		obj_type = ObjType,
		obj_id = ObjId,
		skill_dict = SkillDict,
		last_use_skill = LastUseSkill
	} = ObjState,
	case util_data:is_null(LastUseSkill) of
		false ->
			#use_skill_info{
				skill_id = SkillId,
				target = Target
			} = LastUseSkill,
			{ok, Skill} = dict:find(SkillId, SkillDict),
			SkillConf = skill_config:get({SkillId, Skill#db_skill.lv}),
			case scene_skill_lib:do_obj_use_skill(SceneState, {ObjType, ObjId}, SkillConf, Target) of
				{ok, SceneState1} ->
					ObjState1 = scene_base_lib:get_scene_obj_state(SceneState1, ObjType, ObjId),
					RestTime = get_rest_time(ObjState),
					do_wait(SceneState1, ObjState1, RestTime, {ai_action, []});
				_ ->
					do_wait(SceneState, ObjState, ?AI_HEARTBEAT, {ai_action, []})
			end;
		_ ->
			do_wait(SceneState, ObjState, ?AI_HEARTBEAT, {ai_action, []})
	end.

%% 获取周围可走的随机坐标点
get_round_rand_point(SceneId, X, Y) ->
	PointList = area_lib:get_round_point_list(SceneId, {X, Y}, 2),
	case util_rand:list_rand(PointList) of
		{X1, Y1} ->
			{X1, Y1};
		_ ->
			{X, Y}
	end.

%% ====================================================================
%% Internal functions
%% ====================================================================
%% 这个函数用于调用子类派生的方法
do_action(SceneState, ObjState, ActionFun, Args) ->
	ObjType = ObjState#scene_obj_state.obj_type,
	case get_obj_lib(ObjType) of
		null ->
			{SceneState, ObjState};
		Mod ->
			try erlang:apply(Mod, ActionFun, [SceneState | [ObjState | Args]]) of
				{NewSceneState, NewObjState} ->
					{NewSceneState, NewObjState};
				_ ->
					{SceneState, ObjState}
			catch
				_Err:_Info ->
%% 					case _Info /= undef of
%% 						true ->
%% %% 							?ERR("~p : ~p~nstacktrace : ~p", [_Err, _Info, erlang:get_stacktrace()]);
%% 						_ ->
%% 							?ERR("~p", [{Mod, ActionFun, _Info, _Err}]),
%% 							skip
%% 					end,
					?ERR("~p", [{Mod, ActionFun, _Info, _Err}]),
					{SceneState, ObjState}
			end
	end.

%% 获取子类方法文件
get_obj_lib(?OBJ_TYPE_MONSTER) -> obj_monster_lib;
get_obj_lib(?OBJ_TYPE_PET) -> obj_pet_lib;
get_obj_lib(?OBJ_TYPE_IMAGE) -> obj_image_lib;
get_obj_lib(?OBJ_TYPE_COLLECT) -> obj_collect_lib;
get_obj_lib(_) -> null.

%% 检查是否可以攻击
check_attack(ObjState, TargetState, SkillDist) ->
	SkillRule = ObjState#scene_obj_state.skill_rule,
	SkillDict = ObjState#scene_obj_state.skill_dict,
	CurHp = ObjState#scene_obj_state.cur_hp,
	AttrBase = ObjState#scene_obj_state.attr_total,
	Hp = AttrBase#attr_base.hp,
	HpPercent = util_math:floor((CurHp / Hp) * ?PERCENT_BASE),
	case chose_skill(SkillRule, ObjState, TargetState, SkillDict, SkillDist, HpPercent) of
		{SkillId, WaitTime} when SkillId /= 0 ->
			{ok, Skill} = dict:find(SkillId, SkillDict),
			SkillConf = skill_config:get({SkillId, Skill#db_skill.lv}),
			%% 如果唯一可以使用的技能是对自身释放的技能则判断技能是否是需要等待
			case SkillConf#skill_conf.target =:= ?SKILL_TARGET_MYSELF andalso WaitTime > 0 of
				true ->
					%% 需要等待，说明其他的技能的施法距离还不合法，目标距离自己太远
					?CHECK_TARGET_SO_FAR;
				_ ->
					%% 如果不需要等待，返回技能
					{ok, SkillId, WaitTime}
			end;
		_ ->
			?CHECK_TARGET_SO_FAR
	end.

chose_skill([], _ObjState, _Target, _SkillDict, _Dist, _HpPercent) ->
	null;
chose_skill([{MinP, MaxP, SkillList} | T], ObjState, Target, SkillDict, Dist, HpPercent) ->
	%% 根据当前对象的血量百分百来选择应该释放的技能
	case MinP =< HpPercent andalso HpPercent =< MaxP of
		true ->
			F = fun({SkillId, _Percent}) ->
				{ok, Skill} = dict:find(SkillId, SkillDict),
				SkillConf = skill_config:get({SkillId, Skill#db_skill.lv}),
				Dist =< SkillConf#skill_conf.spell_distance orelse SkillConf#skill_conf.target =:= ?SKILL_TARGET_MYSELF
			end,
			%% 过滤掉不在施法距离内的技能
			SkillList1 = lists:filter(F, SkillList),
			chose_skill1(SkillList1, ObjState, SkillDict, 0, 0);
		_ ->
			chose_skill(T, ObjState, Target, SkillDict, Dist, HpPercent)
	end;
chose_skill([{MinP, MaxP, _WaringId, _WaringList, SkillList} | T], ObjState, Target, SkillDict, Dist, HpPercent) ->
	%% 给释放的技能排序
	LastSkill = ObjState#scene_obj_state.last_skill,
	SkillList1 = get_new_order_skill_list(SkillList, LastSkill, []),
	%% 根据当前对象的血量百分百来选择应该释放的技能
	NewSkillList = case ObjState#scene_obj_state.warning_skill_info of
					   {UseTime, SkillId} ->
						   case util_date:unixtime() >= UseTime of
							   true ->
								   [{SkillId, ?PERCENT_BASE}] ++ SkillList1;
							   _ ->
								   SkillList1
						   end;
					   _ ->
						   SkillList1
				   end,
	case MinP =< HpPercent andalso HpPercent =< MaxP of
		true ->
			F = fun({SkillId, _Percent}) ->
				{ok, Skill} = dict:find(SkillId, SkillDict),
				SkillConf = skill_config:get({SkillId, Skill#db_skill.lv}),
				Dist =< SkillConf#skill_conf.spell_distance orelse SkillConf#skill_conf.target =:= ?SKILL_TARGET_MYSELF
			end,
			%% 过滤掉不在施法距离内的技能
			NewSkillList1 = lists:filter(F, NewSkillList),
			chose_skill2(NewSkillList1, ObjState, SkillDict, 0, 0);
		_ ->
			chose_skill(T, ObjState, Target, SkillDict, Dist, HpPercent)
	end.

%% 获取技能新的触发排序
get_new_order_skill_list([], _LastSkill, NewSkillList) ->
	NewSkillList;
get_new_order_skill_list([{SkillId, P} | T], LastSkill, NewSkillList) ->
	case SkillId == LastSkill of
		true ->
			T ++ NewSkillList ++ [{SkillId, P}];
		false ->
			get_new_order_skill_list(T, LastSkill, NewSkillList ++ [{SkillId, P}])
	end.

%% 这里用于判断技能CD等内容(规则权重随机)
chose_skill1([], _ObjState, _SkillDict, SkillId, WaitTime) ->
	{SkillId, WaitTime};
chose_skill1(SkillList, ObjState, SkillDict, SkillId, WaitTime) ->
	%% 根据释放权重随机产生技能
	SkillId1 = util_rand:weight_rand_ex(SkillList),
	case dict:find(SkillId1, SkillDict) of
		{ok, Skill} ->
			%% 如果是已经学习了的技能
			CurTime = util_date:longunixtime(),
			WaitTime1 = max(Skill#db_skill.next_time - CurTime, 0),
			case WaitTime1 =:= 0 of
				true ->
					%% 技能不在CD中
					SkillConf = skill_config:get({SkillId1, Skill#db_skill.lv}),
					[Effect | _T] = SkillConf#skill_conf.effect_list,
					case Effect of
						{call_pet, _, _} ->
							%% 如果是召唤技能判断是否已经召唤过宠物
							PetCount = dict:size(ObjState#scene_obj_state.pet_dict),
							case PetCount > 0 of
								true ->
									%% 如果已经召唤了宠物忽略这个技能进入下一次循环
									chose_skill1(lists:keydelete(SkillId1, 1, SkillList), ObjState, SkillDict, SkillId, WaitTime);
								_ ->
									{SkillId1, 0}
							end;
						_ ->
							{SkillId1, 0}
					end;
				_ ->
					%% 技能还在CD中
					case WaitTime1 < WaitTime orelse SkillId == 0 of
						true ->
							chose_skill1(lists:keydelete(SkillId1, 1, SkillList), ObjState, SkillDict, SkillId1, WaitTime1);
						_ ->
							chose_skill1(lists:keydelete(SkillId1, 1, SkillList), ObjState, SkillDict, SkillId, WaitTime)
					end
			end;
		_ ->
			%% 来到这里的话说明技能数据有错乱(直接忽略掉这个技能进入下一次循环)
			chose_skill1(lists:keydelete(SkillId1, 1, SkillList), ObjState, SkillDict, SkillId, WaitTime)
	end.
%% 这里用于判断技能CD等内容(规则顺序随机)
chose_skill2([], _ObjState, _SkillDict, SkillId, WaitTime) ->
	{SkillId, WaitTime};
chose_skill2([{SkillId1, Percent} | T], ObjState, SkillDict, SkillId, WaitTime) ->
	%% 根据释放顺序可概率决定是否释放
	case util_rand:rand_hit(Percent) of
		true ->
			case dict:find(SkillId1, SkillDict) of
				{ok, Skill} ->
					%% 如果是已经学习了的技能
					CurTime = util_date:longunixtime(),
					WaitTime1 = max(Skill#db_skill.next_time - CurTime, 0),
					case WaitTime1 =:= 0 of
						true ->
							%% 技能不在CD中
							SkillConf = skill_config:get({SkillId1, Skill#db_skill.lv}),
							[Effect | _T] = SkillConf#skill_conf.effect_list,
							case Effect of
								{call_pet, _, _} ->
									%% 如果是召唤技能判断是否已经召唤过宠物
									PetCount = dict:size(ObjState#scene_obj_state.pet_dict),
									case PetCount > 0 of
										true ->
											%% 如果已经召唤了宠物忽略这个技能进入下一次循环
											chose_skill2(T, ObjState, SkillDict, SkillId, WaitTime);
										_ ->
											{SkillId1, 0}
									end;
								_ ->
									{SkillId1, 0}
							end;
						_ ->
							%% 技能还在CD中
							case WaitTime1 < WaitTime orelse SkillId == 0 of
								true ->
									chose_skill2(T, ObjState, SkillDict, SkillId1, WaitTime1);
								_ ->
									chose_skill2(T, ObjState, SkillDict, SkillId, WaitTime)
							end
					end;
				_ ->
					%% 来到这里的话说明技能数据有错乱(直接忽略掉这个技能进入下一次循环)
					chose_skill2(T, ObjState, SkillDict, SkillId, WaitTime)
			end;
		false ->
			chose_skill2(T, ObjState, SkillDict, SkillId, WaitTime)
	end.

%% 判断AI是否可以行动
can_action(ObjState) ->
	#scene_obj_state{
		buff_dict = BuffDict,
		effect_dict = EffectDict
	} = ObjState,
	%% 判断身上是否有麻痹或者晕眩BUFF，或者是是否已经死亡
	BuffEffect = buff_base_lib:get_buff_effect(BuffDict, EffectDict, ?BUFF_EFFECT_STUN),
	BuffEffect1 = buff_base_lib:get_buff_effect(BuffDict, EffectDict, ?BUFF_EFFECT_MB),
	Res = ObjState#scene_obj_state.cur_hp > 0 andalso BuffEffect#buff_effect.effect_p =:= 0 andalso
		BuffEffect#buff_effect.effect_v =:= 0 andalso BuffEffect1#buff_effect.effect_v =:= 0,
	Res.

%% 判断A是否能使用技能(沉默效果判断)
can_use_skill(ObjState) ->
	#scene_obj_state{
		buff_dict = BuffDict,
		effect_dict = EffectDict
	} = ObjState,
	BuffEffect = buff_base_lib:get_buff_effect(BuffDict, EffectDict, ?BUFF_EFFECT_SILENT),
	Res = BuffEffect#buff_effect.effect_v =:= 0,
	Res.

%% 计算下一个移动点
compute_next_move_point(SceneState, ObjState, {X, Y}) ->
	ObstacleDict = scene_base_lib:get_obstacle_dict(),
	SceneId = SceneState#scene_state.scene_id,
	#scene_obj_state{
		x = BX,
		y = BY,
		speed = _Speed,
		obj_type = ObjType
	} = ObjState,

	%% 这里先计算出与目标坐标间的直线方向朝向
	Dire = area_lib:get_direction({BX, BY}, {X, Y}),

	%% 这里顺时针旋转朝向(会检查完所有的朝向并且计算出离目标最近的可走点)
	F = fun(Rotate, Acc) ->
		{_, D} = Acc,
		Dire1 = Dire + Rotate,
		Dire2 =
			case Dire1 =< 8 of
				true ->
					Dire1;
				_ ->
					Dire1 rem 8
			end,
		{X1, Y1} =
			case Dire2 of
				?DIRECTION_UP ->
					{BX, BY + 1};
				?DIRECTION_UP_RIGHT ->
					{BX + 1, BY + 1};
				?DIRECTION_RIGHT ->
					{BX + 1, BY};
				?DIRECTION_DOWN_RIGHT ->
					{BX + 1, BY - 1};
				?DIRECTION_DOWN ->
					{BX, BY - 1};
				?DIRECTION_DOWN_LEFT ->
					{BX - 1, BY - 1};
				?DIRECTION_LEFT ->
					{BX - 1, BY};
				_ ->
					{BX - 1, BY + 1}
			end,

		%% 判断是不是可走点
		case area_lib:can_move(SceneId, {X1, Y1}) of
			true ->
				case ObjType of
					?OBJ_TYPE_MONSTER ->
						%% 碰撞检查，判断位置是否已经有对象站在上面
						case dict:find({X1, Y1}, ObstacleDict) of
							{ok, _} ->
								Acc;
							_ ->
								%% 如果没有对象站在上面(这个点离目标点是否比上面找出的合法点还要近)
								D1 = util_math:get_distance_set({X1, Y1}, {X, Y}),
								case D1 < D * D of
									true ->
										%% 如果距离还要短(直接替换合法点)
										{{X1, Y1}, D1};
									_ ->
										Acc
								end
						end;
					?OBJ_TYPE_PET ->
						case dict:find({X1, Y1}, ObstacleDict) of
							{ok, ObjList} ->
								%% 宠物的比较特殊，只与宠物做碰撞
								case lists:keyfind(?OBJ_TYPE_PET, 1, ObjList) of
									{?OBJ_TYPE_PET, _} ->
										Acc;
									_ ->
										D1 = util_math:get_distance_set({X1, Y1}, {X, Y}),
										case D1 < D * D of
											true ->
												{{X1, Y1}, D1};
											_ ->
												Acc
										end
								end;
							_ ->
								D1 = util_math:get_distance_set({X1, Y1}, {X, Y}),
								case D1 < D * D of
									true ->
										{{X1, Y1}, D1};
									_ ->
										Acc
								end
						end;
					_ ->
						D1 = util_math:get_distance_set({X1, Y1}, {X, Y}),
						case D1 < D * D of
							true ->
								{{X1, Y1}, D1};
							_ ->
								Acc
						end
				end;
			_ ->
				Acc
		end
	end,
	{Point1, _} = lists:foldl(F, {{BX, BY}, 99999}, lists:seq(0, 7)),
	Point1.

%% 检测怪物是否有隐身抗性
check_monster_resist(TargetState, Effect) ->
	case TargetState#scene_obj_state.obj_type of
		?OBJ_TYPE_MONSTER ->
			MonsterConf = monster_config:get(TargetState#scene_obj_state.monster_id),
			case Effect of
				?BUFF_EFFECT_INVISIBILITY ->
					MonsterConf#monster_conf.is_resist_invisibility == 1;
				_ ->
					false
			end;
		_ ->
			false
	end.

%% 玩家移动的时候 移动的时候，修改怪物的攻击ai攻击
set_monster_targer(SceneState, ObjType, ObjId, ObjList) ->
	case ObjType of
		?OBJ_TYPE_PLAYER ->
			ObjList1 = [X || X <- ObjList,
				X#scene_obj_state.obj_type =:= ?OBJ_TYPE_MONSTER,
				X#scene_obj_state.cur_target =:= null,
				X#scene_obj_state.attack_type =:= ?ATTACK_TYPE_INITIATIVE
			],
			case ObjList1 of
				[] ->
					{ok, SceneState};
				_ ->
%% 					?ERR("~p", [length(ObjList1)]),
					F = fun(X, Acc) ->
						X1 = X#scene_obj_state{cur_target = #cur_target_info{obj_type = ObjType, obj_id = ObjId}, next_action_time = 0},
						scene_base_lib:store_scene_obj_state(Acc, X1)
					end,
					SceneState1 = lists:foldl(F, SceneState, ObjList1),
					{ok, SceneState1}
			end;
		_ ->
			{ok, SceneState}
	end.