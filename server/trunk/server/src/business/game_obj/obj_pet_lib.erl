%%%-------------------------------------------------------------------
%%% @author zhengsiying
%%% @copyright (C) 2016, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 29. 一月 2016 下午7:38
%%%-------------------------------------------------------------------
-module(obj_pet_lib).

-include("common.hrl").
-include("record.hrl").
-include("proto.hrl").
-include("config.hrl").
-include("cache.hrl").

%% API
-export([
	recall/6,
	pet_add_exp/4,
	set_attack_type/6
%% 	make_attr/2
]).

%% callbacks
-export([
	ai_action/2,
	on_timer/2,
	on_harm/4,
	on_cure/4,
	on_die/3,
	on_recall/6,
	on_pet_add_exp/4,
	on_set_attack_type/6,
	do_move/2,
	do_trigger_skill/2
]).

%% ====================================================================
%% API functions
%% ====================================================================
%% AI行动
ai_action(SceneState, ObjState) ->
	do_action(ObjState#scene_obj_state.attack_type, SceneState, ObjState).

%% 定时器
on_timer(SceneState, ObjState) ->
	{SceneState, ObjState}.

do_move(SceneState, ObjState) ->
	{SceneState, ObjState}.

do_trigger_skill(SceneState, ObjState) ->
	{SceneState, ObjState}.

%% 受伤事件处理
on_harm(SceneState, ObjState, _HarmProto, _CasterState) ->
	#scene_obj_state{
		obj_id = ObjId,
		monster_id = MonsterId,
		exp = CurExp,
		owner_pid = OwnerPid,
		cur_hp = CurHp
	} = ObjState,
	%% 通知主人进程宠物信息更新
	case is_pid(OwnerPid) of
		true ->
			gen_server2:cast(OwnerPid, {pet_update, self(), ObjId, MonsterId, CurExp, CurHp});
		_ ->
			skip
	end,
	{SceneState, ObjState}.

%% 回血事件处理
on_cure(SceneState, ObjState, _CureProto, _CasterState) ->
	#scene_obj_state{
		obj_id = ObjId,
		monster_id = MonsterId,
		exp = CurExp,
		owner_pid = OwnerPid,
		cur_hp = CurHp
	} = ObjState,
	%% 通知主人进程宠物信息更新
	case is_pid(OwnerPid) of
		true ->
			gen_server2:cast(OwnerPid, {pet_update, self(), ObjId, MonsterId, CurExp, CurHp});
		_ ->
			skip
	end,
	{SceneState, ObjState}.

%% 死亡事件
on_die(SceneState, ObjState, KillerState) ->
	#scene_obj_state{
		obj_type = ObjType,
		obj_id = ObjId,
		owner_pid = OwnerPid
	} = ObjState,
	%% 通知主人进程宠物死亡
	case is_pid(OwnerPid) of
		true ->
			gen_server2:cast(OwnerPid, {pet_die, ObjId});
		_ ->
			skip
	end,
	case scene_obj_lib:do_obj_die(SceneState, ObjType, ObjId, [], KillerState, null) of
		{ok, SceneState1} ->
			ObjState1 = scene_base_lib:get_scene_obj_state(SceneState1, ObjType, ObjId),
			{SceneState1, ObjState1};
		_ ->
			{SceneState, ObjState}
	end.

%% 被召回(玩家进程调用)
recall(PetScenePid, ObjId, ScenePid, SceneId, PlayerPid, {X, Y}) ->
	gen_server2:apply_async(PetScenePid, {?MODULE, on_recall, [ObjId, ScenePid, SceneId, PlayerPid, {X, Y}]}).

%% 被召回事件
on_recall(SceneState, ObjId, ScenePid, SceneId, PlayerPid, {X, Y}) ->
	case scene_base_lib:get_scene_obj_state(SceneState, ?OBJ_TYPE_PET, ObjId) of
		#scene_obj_state{} = ObjState ->
			do_recall(SceneState, ObjState, ScenePid, SceneId, {X, Y});
		_ ->
			gen_server2:cast(PlayerPid, {pet_die, ObjId}),
			skip
	end.

%% 处理被召回事件
do_recall(SceneState, ObjState, ScenePid, SceneId, {X, Y}) ->
	{EX, EY} = game_obj_lib:get_round_rand_point(SceneId, X, Y),
	case self() /= ScenePid of
		true ->
			{NewSceneState, _} = game_obj_lib:change_scene(SceneState, ObjState, ScenePid, {EX, EY}),
			{ok, NewSceneState};
		_ ->
			{NewSceneState, _} = game_obj_lib:instant_move(SceneState, ObjState, {EX, EY}),
			{ok, NewSceneState}
	end.

%% 宠物加经验(玩家进程调用)
pet_add_exp(ScenePid, PlayerId, AddExp, LvLimit) ->
	gen_server2:apply_async(ScenePid, {?MODULE, on_pet_add_exp, [PlayerId, AddExp, LvLimit]}).

%% 宠物加经验事件
on_pet_add_exp(SceneState, PlayerId, AddExp, LvLimit) ->
	case scene_base_lib:do_get_screen_biont(SceneState, ?OBJ_TYPE_PLAYER, PlayerId, false) of
		[] ->
			skip;
		ObjList ->
			F = fun(ObjState) ->
				#scene_obj_state{
					obj_type = ObjType,
					owner_id = OwnerId,
					monster_id = MonsterId
				} = ObjState,
				case ObjType =:= ?OBJ_TYPE_PET andalso OwnerId =:= PlayerId of
					true ->
						Lv = MonsterId rem 10,
						MonsterConf = monster_config:get(MonsterId),
						LvLimit > Lv andalso MonsterConf#monster_conf.need_exp > 0;
					_ ->
						false
				end
			end,
			PetList = lists:filter(F, ObjList),
			case PetList of
				[] ->
					skip;
				_ ->
					[_ObjState | PetList1] = PetList,
					ObjState =
						case PetList1 of
							[] ->
								_ObjState;
							_ ->
								F1 = fun(PetState, Acc) ->
									#scene_obj_state{
										monster_id = MonsterId,
										exp = Exp
									} = PetState,
									#scene_obj_state{
										monster_id = MonsterId1,
										exp = Exp1
									} = Acc,
									Lv = MonsterId rem 10,
									Lv1 = MonsterId1 rem 10,
									case Lv < Lv1 orelse (Lv == Lv1 andalso Exp < Exp1) of
										true ->
											PetState;
										_ ->
											Acc
									end
								end,
								lists:foldl(F1, _ObjState, PetList1)
						end,
					add_exp(SceneState, ObjState, AddExp)
			end
	end.

%% 宠物加经验
add_exp(SceneState, ObjState, AddExp) ->
	#scene_obj_state{
		obj_id = ObjId,
		monster_id = MonsterId,
		exp = CurExp,
		owner_pid = OwnerPid,
		cur_hp = CurHp
	} = ObjState,
	MonsterConf = monster_config:get(MonsterId),
	NewExp = CurExp + AddExp,
	NeedExp = MonsterConf#monster_conf.need_exp,
	case NeedExp >= 0 of
		true ->
			case NewExp >= NeedExp of
				true ->
					lv_up(SceneState, ObjState, NewExp - NeedExp);
				_ ->
					gen_server2:cast(OwnerPid, {pet_update, self(), ObjId, MonsterId, NewExp, CurHp}),
					NewObjState = ObjState#scene_obj_state{exp = NewExp},
					NewSceneState = scene_base_lib:store_scene_obj_state(SceneState, NewObjState, ObjState),
					{ok, NewSceneState}
			end;
		_ ->
			skip
	end.

%% 宠物升级
lv_up(SceneState, ObjState, Exp) ->
	#scene_obj_state{
		obj_type = ObjType,
		obj_id = ObjId,
		monster_id = _MonsterId,
		owner_id = OwnerId,
		owner_pid = OwnerPid,
		skill_dict = SkillDict
	} = ObjState,

	case scene_base_lib:get_scene_obj_state(SceneState, ?OBJ_TYPE_PLAYER, OwnerId) of
		#scene_obj_state{lv = OwnerLv, name = OwnerName} = _OwnerState ->
			MonsterId = _MonsterId + 1,
			MonsterConf = monster_config:get(MonsterId),
			SkillRule = MonsterConf#monster_conf.skill_rule,
			F = fun({_, _, List}, Acc) ->
				F1 =
					fun({SkillId, _}, Acc1) ->
						case dict:find(SkillId, Acc1) of
							{ok, _} ->
								Acc1;
							_ ->
								Skill = #db_skill{
									skill_id = SkillId,
									lv = 1,
									next_time = 0
								},
								dict:store(SkillId, Skill, Acc1)
						end
					end,
				lists:foldl(F1, Acc, List)
			end,
			NewSkillDict = lists:foldl(F, SkillDict, SkillRule),

%%  			AttrBase = make_attr(MonsterId, OwnerLv),
			AttrBase = api_attr:addition_attr(MonsterConf#monster_conf.attr_base, OwnerLv / 100),
			Name = MonsterConf#monster_conf.name ++ "(" ++ util_data:to_list(OwnerName) ++ ")",
			Update2 = #scene_obj_state{
				monster_id = MonsterId,
				name = Name,
				lv = MonsterConf#monster_conf.lv,
				exp = Exp,
				skill_dict = NewSkillDict,
				skill_rule = SkillRule,
				attr_total = AttrBase,
				attr_base = AttrBase,
				cur_hp = AttrBase#attr_base.hp,
				cur_mp = AttrBase#attr_base.mp
			},
			gen_server2:cast(OwnerPid, {pet_update, self(), ObjId, MonsterId, Exp, AttrBase#attr_base.hp}),

			scene_obj_lib:do_update_obj(SceneState, ObjType, ObjId, Update2, ?UPDATE_CAUSE_LV_UP);
		_ ->
			skip
	end.

%% 重新计算宠物属性
%% make_attr(MonsterId, OwnerLv) ->
%% 	MonsterConf = monster_config:get(MonsterId),
%% 	AttrBase = MonsterConf#monster_conf.attr_base,
%% 	case OwnerLv =< 52 of
%% 		true ->
%% 			AttrBase;
%% 		_ ->
%% 			#attr_base{
%% 				min_ac = MinAc,
%% 				max_ac = MaxAc,
%% 				min_mac = MinMac,
%% 				max_mac = MaxMac,
%% 				min_sc = MinSc,
%% 				max_sc = MaxSc
%% 			} = AttrBase,
%% 			AttAdd = util_math:floor(OwnerLv * (OwnerLv - 52) * 0.3),
%% 			AttrBase#attr_base{
%% 				min_ac = MinAc + AttAdd,
%% 				max_ac = MaxAc + AttAdd,
%% 				min_mac = MinMac + AttAdd,
%% 				max_mac = MaxMac + AttAdd,
%% 				min_sc = MinSc + AttAdd,
%% 				max_sc = MaxSc + AttAdd
%% 			}
%% 	end.

%% 设置宠物攻击状态
set_attack_type(PetScenePid, ObjId, ScenePid, SceneId, {X, Y}, AttackType) ->
	gen_server2:apply_async(PetScenePid, {?MODULE, on_set_attack_type, [ObjId, ScenePid, SceneId, {X, Y}, AttackType]}).

%% 设置宠物攻击状态事件
on_set_attack_type(SceneState, ObjId, ScenePid, SceneId, {X, Y}, AttackType) ->
	case scene_base_lib:get_scene_obj_state(SceneState, ?OBJ_TYPE_PET, ObjId) of
		#scene_obj_state{} = ObjState ->
			NewObjState = ObjState#scene_obj_state{attack_type = AttackType, action_cmd = {ai_action, []}},
			case AttackType of
				?ATTACK_TYPE_INITIATIVE ->
					NewSceneState = scene_base_lib:store_scene_obj_state(SceneState, NewObjState, ObjState),
					do_recall(NewSceneState, NewObjState, ScenePid, SceneId, {X, Y});
				_ ->
					NewSceneState = scene_base_lib:store_scene_obj_state(SceneState, NewObjState, ObjState),
					{ok, NewSceneState}
			end;
		_ ->
			skip
	end.

%% ====================================================================
%% Internal functions
%% ====================================================================
%% 主动攻击型AI处理
do_action(?ATTACK_TYPE_INITIATIVE, SceneState, ObjState) ->
	case game_obj_lib:check_owner(SceneState, ObjState) of
		{?CHECK_OWNER_SO_FAR, X, Y} ->
			game_obj_lib:instant_move(SceneState, ObjState, {X, Y});
		_ ->
			case get_target(SceneState, ObjState) of
				{Res, TargetState} ->
					do_action(Res, SceneState, ObjState, TargetState);
				_ ->
					case find_new_target(SceneState, ObjState) of
						{Res, TargetState} ->
							{SceneState1, ObjState1} = game_obj_lib:set_cur_target(SceneState, ObjState, TargetState),
							do_action(Res, SceneState1, ObjState1, TargetState);
						_ ->
							{SceneState1, ObjState1} = game_obj_lib:set_cur_target(SceneState, ObjState, null),
							game_obj_lib:do_follow(SceneState1, ObjState1)
					end
			end
	end;
%% 被动攻击型AI处理
do_action(?ATTACK_TYPE_PASSIVITY, SceneState, ObjState) ->
	case get_target(SceneState, ObjState) of
		{Res, TargetState} ->
			do_action(Res, SceneState, ObjState, TargetState);
		_ ->
			{SceneState1, ObjState1} = game_obj_lib:set_cur_target(SceneState, ObjState, null),
			RestTime = game_obj_lib:get_rest_time(ObjState1),
			game_obj_lib:do_wait(SceneState1, ObjState1, RestTime, {ai_action, []})
	end;
do_action(_, SceneState, ObjState) ->
	game_obj_lib:do_stop(SceneState, ObjState).

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
	#scene_obj_state{
		chase_range = ChaseRange,
		attack_type = AttackType
	} = ObjState,
	case ChaseRange > 0 andalso AttackType == ?ATTACK_TYPE_INITIATIVE of
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
	game_obj_lib:do_follow(SceneState1, ObjState1).

%% 获取目标
get_target(SceneState, ObjState) ->
	case ObjState#scene_obj_state.cur_target of
		#cur_target_info{obj_type = ObjType, obj_id = ObjId} = _Enmity ->
			%% 如果有追击目标
			case scene_base_lib:get_scene_obj_state(SceneState, ObjType, ObjId) of
				#scene_obj_state{} = TargetState ->
					case skill_rule_lib:check_target(?SKILL_TARGET_HOSTILE, ObjState, TargetState) of
						true ->
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
			end;
		_ ->
			null
	end.

%% 找新目标
find_new_target(SceneState, ObjState) ->
	#scene_obj_state{
		obj_type = ObjType,
		obj_id = ObjId,
		owner_type = OwnerType,
		owner_id = OwnerId
	} = ObjState,
	ScreenObjList = scene_base_lib:do_get_screen_biont(SceneState, ObjType, ObjId, false),
	case scene_base_lib:get_scene_obj_state(SceneState, OwnerType, OwnerId) of
		#scene_obj_state{} = OwnerState ->
			HostileList = get_hostile_list(SceneState, ObjState, OwnerState, ScreenObjList),
			case HostileList /= [] of
				true ->
					HostileList1 = lists:keysort(1, HostileList),
					%% 寻找目标
					chose_target(SceneState, ObjState, OwnerState, HostileList1);
				_ ->
					null
			end;
		_ ->
			null
	end.

%% 获取敌对列表
get_hostile_list(_SceneState, ObjState, OwnerState, ScreenObjList) ->
	#scene_obj_state{
		x = X,
		y = Y,
		guard_range = GuardRange,%% 警戒范围
		chase_range = ChaseRange %% 追击范围
	} = ObjState,
	#scene_obj_state{
		x = X2,
		y = Y2
	} = OwnerState,
	F = fun(TargetState, Acc) ->
		IsOk = skill_rule_lib:check_target(?SKILL_TARGET_HOSTILE, OwnerState, TargetState),
		%% 判断与目标的距离信息
		case IsOk of
			false ->
				Acc;
			_ ->
				D1 = util_math:get_distance_set({X, Y}, {TargetState#scene_obj_state.x, TargetState#scene_obj_state.y}),
				%% 是否在警戒范围内
				case D1 =< GuardRange * GuardRange of
					true ->
						D2 = util_math:get_distance_set({X2, Y2}, {TargetState#scene_obj_state.x, TargetState#scene_obj_state.y}),
						%% 是否在追击范围內
						case ChaseRange > 0 andalso D2 > ChaseRange * ChaseRange of
							true ->
								Acc;
							_ ->
								[{D1, TargetState} | Acc]
						end;
					_ ->
						Acc
				end
		end
	end,
	%% 获取与对象间的距离
	lists:foldl(F, [], ScreenObjList).

%% 寻找新的目标
chose_target(SceneState, ObjState, _OwnerState, HostileList) ->
	F = fun({_, TargetState}, Acc) ->
		case Acc of
			null ->
				case game_obj_lib:check_target(SceneState, ObjState, TargetState) of
					?CHECK_TARGET_DIE ->
						Acc;
					?CHECK_TARGET_INVISIBILITY ->
						Acc;
					Res ->
						{Res, TargetState}
				end;
			_ ->
				Acc
		end
	end,
	%% 找到可以攻击的敌对目标信息
	TargetRes = lists:foldl(F, null, HostileList),
	TargetRes.