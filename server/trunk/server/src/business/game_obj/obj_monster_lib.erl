%%%-------------------------------------------------------------------
%%% @author zhengsiying
%%% @copyright (C) 2016, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 27. 一月 2016 下午6:44
%%%-------------------------------------------------------------------
-module(obj_monster_lib).

-include("common.hrl").
-include("record.hrl").
-include("proto.hrl").
-include("config.hrl").
-include("notice_config.hrl").

-export([
	be_tempt/2
]).

%% callbacks
-export([
	ai_action/2,
	on_timer/2,
	on_harm/4,
	on_die/3,
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
	CurTime = util_date:unixtime(),
	Ontime = util_data:get_value(SceneState#scene_state.ai_obj_on_time, CurTime),%%--
	case Ontime < CurTime of
		true ->
			#scene_obj_state{
				go_out_time = GoOutTime
			} = ObjState,
			{SceneState1, _ObjState1} =
				case is_integer(GoOutTime) andalso GoOutTime /= 0 andalso GoOutTime < CurTime of
					true ->
						game_obj_lib:on_remove(SceneState, ObjState);
					_ ->
						{SceneState, ObjState}
				end,
			ObjState1 = check_enmity(_ObjState1),
			ObjState2 = check_warning(SceneState1, ObjState1),
			NewObjState = check_drop_owner(SceneState1, ObjState2),
			NewSceneState = scene_base_lib:store_scene_obj_state(SceneState1, NewObjState, ObjState),
			{NewSceneState#scene_state{ai_obj_on_time = Ontime + 1}, NewObjState};
		_ ->
			{SceneState#scene_state{ai_obj_on_time = CurTime}, ObjState}
	end.
do_move(SceneState, ObjState) ->
	{SceneState, ObjState}.

do_trigger_skill(SceneState, ObjState) ->
	{SceneState, ObjState}.
%% 受伤事件处理
%% SceneState: 场景状态
%% ObjState: 当前处理对象状态
%% HarmProto: 伤害信息
%% CasterState: 施法者状态
on_harm(SceneState, ObjState, HarmProto, CasterState) ->
	#proto_harm{
		harm_value = HarmValue
	} = HarmProto,

	case is_record(CasterState, scene_obj_state) of
		true ->
			#scene_obj_state{
				obj_type = CasterType,
				obj_id = CasterId,
				name = Name,
				lv = Lv,
				owner_type = OwnerType,
				owner_id = OwnerId,
				vip = Vip,
				career = Career
			} = CasterState,

			CurTime = util_date:unixtime(),
			EffectiveTime = CurTime + ?DROP_OWNER_EFFECTIVE_TIME,
			NewDropOwnerInfo =
				case CasterType of
					?OBJ_TYPE_PLAYER ->
						#cur_drop_owner_info{
							player_id = CasterId,
							career = Career,
							name = Name,
							lv = Lv,
							effective_time = EffectiveTime,
							vip = Vip
						};
					?OBJ_TYPE_PET ->
						case OwnerType of
							?OBJ_TYPE_PLAYER ->
								case scene_base_lib:get_scene_obj_state(SceneState, OwnerType, OwnerId) of
									#scene_obj_state{obj_id = PlayerId, name = PlayerName,
										lv = PlayerLv, vip = PlayerVip, career = PlayerCareer} = _ ->
										#cur_drop_owner_info{
											player_id = PlayerId,
											name = PlayerName,
											lv = PlayerLv,
											effective_time = EffectiveTime,
											vip = PlayerVip,
											career = PlayerCareer
										};
									_ ->
										null
								end;
							_ ->
								null
						end;
					_ ->
						null
				end,

			%% 设置掉落归属
			#scene_obj_state{
				monster_id = MonsterId
			} = ObjState,
			MonsterConf = monster_config:get(MonsterId),

			{SceneState1, ObjState1} =
				case MonsterConf#monster_conf.ownership == 1 andalso CasterState#scene_obj_state.pk_mode =/= ?PK_MODE_NOOB of
					true ->
						game_obj_lib:set_drop_owner(SceneState, ObjState, NewDropOwnerInfo, HarmValue);
					false ->
						game_obj_lib:set_drop_owner(SceneState, ObjState, null, HarmValue)
				end,

			%% 更新仇恨列表
			{SceneState2, ObjState2} =
				%% 反弹被动技能判断过滤
			case ObjState#scene_obj_state.obj_id =/= CasterState#scene_obj_state.obj_id of
				true ->
					add_enmity(SceneState1, ObjState1, CasterState, HarmValue);
				false ->
					{SceneState1, ObjState1}
			end,

			%% 怪物受伤 检测是否触发预警技能
			SkillRule = ObjState2#scene_obj_state.skill_rule,
			CurHp = ObjState#scene_obj_state.cur_hp,
			{SceneState3, ObjState3} = check_warning_skill(SkillRule, SceneState2, ObjState2, CurHp, HarmValue),

			{SceneState3, ObjState3};
		_ ->
			{SceneState, ObjState}
	end.

%% 死亡事件
%% SceneState: 场景状态
%% ObjState: 当前处理对象状态
%% KillerState: 杀人者
on_die(SceneState, ObjState, KillerState) ->
	SceneId = SceneState#scene_state.scene_id,
	#scene_obj_state{
		obj_type = ObjType,
		obj_id = ObjId,
		monster_id = MonsterId,
		drop_owner = DropOwner
	} = ObjState,

	MonsterConf = monster_config:get(MonsterId),
	case is_record(KillerState, scene_obj_state) of
		true ->
			KillerPid =
				case KillerState#scene_obj_state.obj_type of
					?OBJ_TYPE_PLAYER ->
						KillerState#scene_obj_state.obj_pid;
					?OBJ_TYPE_PET ->
						KillerState#scene_obj_state.owner_pid;
					_ ->
						null
				end,
			case is_pid(KillerPid) of
				true ->
					TeamId = KillerState#scene_obj_state.team_id,
					PlayerId =
						case ObjState#scene_obj_state.drop_owner of
							#cur_drop_owner_info{} = DropOwnerInfo ->
								DropOwnerInfo#cur_drop_owner_info.player_id;
							_ ->
								0
						end,
					case TeamId > 0 andalso is_integer(TeamId) of
						true ->
							KillPlayerId = KillerState#scene_obj_state.obj_id,
							team_lib:kill_monster(TeamId, SceneId, MonsterId, PlayerId, KillPlayerId);
						false ->
							player_lib:kill_monster(KillerPid, SceneId, MonsterId)
					end;
				_ ->
					skip
			end;
		_ ->
			case player_lib:get_player_pid(KillerState) of
				KillPid when is_pid(KillPid) ->
					player_lib:kill_monster(KillPid, SceneId, MonsterId);
				_ ->
					skip
			end
	end,

	{Career, OwnerObjState} =
		case DropOwner of
			null ->
				{null, null};
			_ ->
				CurTime = util_date:unixtime(),
				#cur_drop_owner_info{
					player_id = DropOwnerId,
					effective_time = EffectiveTime
				} = DropOwner,

				case MonsterConf#monster_conf.ownership == 1 andalso EffectiveTime >= CurTime of
					true ->
						Obj = scene_base_lib:get_scene_obj_state(SceneState, ?OBJ_TYPE_PLAYER, DropOwnerId),
						%%判断是否活着,且在场景
						OwnerObjState1 = get_true_owner(SceneState, Obj),
						case OwnerObjState1 =/= null of
							true ->
								{OwnerObjState1#scene_obj_state.career, OwnerObjState1};
							_ ->
								OwnerObjState2 = get_true_owner(SceneState, KillerState),
								case OwnerObjState2 =/= null of
									true ->
										{OwnerObjState2#scene_obj_state.career, OwnerObjState2};
									false ->
										{null, null}
								end
						end;
					_ ->
						case is_record(KillerState, scene_obj_state) of
							true ->
								{KillerState#scene_obj_state.career, null};
							_ ->
								{null, null}
						end
				end
		end,

	GoodsList = rand_drop(MonsterId, Career, SceneId, ObjState),
	LimitList = special_drop_cache:get_no_drop_type_list(),
	SpecDropList = spec_drop(ObjState, MonsterId, LimitList),
	GoodsList1 = filter_special_drop(LimitList, GoodsList, MonsterConf#monster_conf.drop_type),
	ActiveDrop = operate_active_lib:get_holiday_drop(Career, MonsterId),
	NewGoodsList = SpecDropList ++ GoodsList1 ++ ActiveDrop,
	case SpecDropList =/= [] of true -> check_normal_drop(GoodsList1, MonsterConf); false -> skip end,
	update_drop(NewGoodsList, MonsterConf),

	%%得到名字及归属
	{OwnerName, OwnerFlag} =
		case OwnerObjState of
			#scene_obj_state{} ->
				{OwnerObjState#scene_obj_state.name, {?OBJ_TYPE_PLAYER, OwnerObjState#scene_obj_state.obj_id}};
			_ ->
				{null, null}
		end,

	case scene_obj_lib:do_obj_die(SceneState, ObjType, ObjId, NewGoodsList, KillerState, OwnerFlag) of
		{ok, SceneState1} ->
			%% 掉落广播
			send_loot_notic(ObjState, KillerState, NewGoodsList, SceneId, OwnerName),

			ObjState1 = scene_base_lib:get_scene_obj_state(SceneState1, ObjType, ObjId),
			{SceneState1, ObjState1};
		_ ->
			{SceneState, ObjState}
	end.

get_true_owner(SceneState, #scene_obj_state{obj_type = ObjType, cur_hp = CurHp} = ObjState) ->
	case ObjType of
		?OBJ_TYPE_PLAYER ->
			case CurHp > 0 of
				true ->
					%% 归属属于归属者
					ObjState;
				_ ->
					null
			end;
		_ ->
			%% 如果归属者不是玩家，那么寻找归属者的主人
			OwnerId1 = ObjState#scene_obj_state.owner_id,
			case scene_base_lib:get_scene_obj_state(SceneState, ?OBJ_TYPE_PLAYER, OwnerId1) of
				#scene_obj_state{cur_hp = CurHp1} = ObjState2 when CurHp1 > 0 ->
					%% 归属属于原归属者主人
					ObjState2;
				_ ->
					null
			end
	end;
get_true_owner(_, _) ->
	null.

%% 被诱惑
be_tempt(SceneState, ObjState) ->
	#scene_obj_state{
		obj_type = ObjType,
		obj_id = ObjId
	} = ObjState,
	scene_obj_lib:do_be_tempt(SceneState, ObjType, ObjId).

%% ====================================================================
%% Internal functions
%% ====================================================================
%% 主动攻击型AI
do_action(?ATTACK_TYPE_INITIATIVE, SceneState, ObjState) ->
	case get_target(SceneState, ObjState) of
		{Res, TargetState} ->
			do_action(Res, SceneState, ObjState, TargetState);
		_ ->
%% 			RestTime = game_obj_lib:get_rest_time(ObjState),
%% 			game_obj_lib:do_wait(SceneState, ObjState, RestTime, {ai_action, []})
			%% 寻找列表占用cpu多
			case find_new_target(SceneState, ObjState) of
				{Res, TargetState} ->
					do_action(Res, SceneState, ObjState, TargetState);
				_ ->
					{SceneState1, ObjState1} = game_obj_lib:set_cur_target(SceneState, ObjState, null),
					case ObjState1#scene_obj_state.patrol_range > 0 of
						true ->
							%% 巡逻压力比较大 占用cpu多
							game_obj_lib:do_patrol(SceneState1, ObjState1);
						_ ->
							RestTime = game_obj_lib:get_rest_time(ObjState1),
							game_obj_lib:do_wait(SceneState1, ObjState1, RestTime, {ai_action, []})
					end
			end
	end;
%% 被动反击型AI
do_action(?ATTACK_TYPE_PASSIVITY, SceneState, ObjState) ->
	case get_target(SceneState, ObjState) of
		{Res, TargetState} ->
			do_action(Res, SceneState, ObjState, TargetState);
		_ ->
			{SceneState1, ObjState1} = game_obj_lib:set_cur_target(SceneState, ObjState, null),
			case ObjState#scene_obj_state.patrol_range > 0 of
				true ->
					game_obj_lib:do_patrol(SceneState1, ObjState1);
				_ ->
					RestTime = game_obj_lib:get_rest_time(ObjState1),
					game_obj_lib:do_wait(SceneState1, ObjState1, RestTime, {ai_action, []})
			end
	end;
%% 守卫AI
do_action(?ATTACK_TYPE_GUARD, SceneState, ObjState) ->
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
	end;
%% 守卫AI(不攻击宠物)
do_action(?ATTACK_TYPE_GUARD_2, SceneState, ObjState) ->
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
	end;
%% 优先移动到指定位置怪物(中途可攻击玩家)
do_action(?ATTACK_TYPE_MOVE, SceneState, ObjState) ->
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
							game_obj_lib:do_set_move(SceneState1, ObjState1);
						_ ->
							RestTime = game_obj_lib:get_rest_time(ObjState1),
							game_obj_lib:do_wait(SceneState1, ObjState1, RestTime, {ai_action, []})
					end
			end
	end;
%% 优先移动到指定位置怪物(只攻击龙柱)
do_action(?ATTACK_TYPE_MOVE_2, SceneState, ObjState) ->
	case get_target_no_enmity(SceneState, ObjState) of
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
							game_obj_lib:do_set_move(SceneState1, ObjState1);
						_ ->
							RestTime = game_obj_lib:get_rest_time(ObjState1),
							game_obj_lib:do_wait(SceneState1, ObjState1, RestTime, {ai_action, []})
					end
			end
	end;
%% 其他AI
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
			case ObjState#scene_obj_state.patrol_range of
				{_X, _Y} ->
					game_obj_lib:do_set_move(SceneState1, ObjState1);
				_ ->
					game_obj_lib:do_patrol(SceneState1, ObjState1)
			end;
		_ ->
			RestTime = game_obj_lib:get_rest_time(ObjState1),
			game_obj_lib:do_wait(SceneState1, ObjState1, RestTime, {ai_action, []})
	end.

%% 获取目标
get_target(SceneState, ObjState) ->
	EnmityDict = ObjState#scene_obj_state.enmity_dict,
	EnmityList = dict:to_list(EnmityDict),
	case EnmityList /= [] of
		true ->
			F = fun({_ObjFlag1, EnmityInfo1}, {_ObjFlag2, EnmityInfo2}) ->
				if
					EnmityInfo1#enmity_info.value > EnmityInfo2#enmity_info.value -> true;
					EnmityInfo1#enmity_info.value == EnmityInfo2#enmity_info.value ->
						EnmityInfo1#enmity_info.effective_time < EnmityInfo2#enmity_info.effective_time;
					true -> false
				end
			end,
			SortList = lists:sort(F, EnmityList),
			get_target(SortList, SceneState, ObjState);
		_ ->
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
			end
	end.

%% 获取目标(无视仇恨值)
get_target_no_enmity(SceneState, ObjState) ->
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

%% 获取目标
get_target([], _SceneState, _ObjState) ->
	null;
get_target([{{ObjType, ObjId}, _} | T], SceneState, ObjState) ->
	case scene_base_lib:get_scene_obj_state(SceneState, ObjType, ObjId) of
		#scene_obj_state{} = TargetState ->
			case game_obj_lib:check_target(SceneState, ObjState, TargetState) of
				?CHECK_TARGET_DIE ->
					get_target(T, SceneState, ObjState);
				Res ->
					{Res, TargetState}
			end;
		_ ->
			get_target(T, SceneState, ObjState)
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
			HostileList1 = lists:keysort(1, HostileList),
			%% 寻找目标
			chose_target(SceneState, ObjState, HostileList1);
		_ ->
			null
	end.

%% 在同屏对象里面获取敌对列表
get_hostile_list(ObjState, ScreenObjList) ->
	#scene_obj_state{
		attack_type = AttackType,
		x = X,
		y = Y,
		guard_range = GuardRange,%% 警戒范围
		chase_range = ChaseRange %% 追击范围
	} = ObjState,
	F = fun(TargetState, Acc) ->
		IsOk = case AttackType of
				   ?ATTACK_TYPE_GUARD ->
					   case TargetState#scene_obj_state.obj_type of
						   ?OBJ_TYPE_PLAYER ->
							   TargetState#scene_obj_state.name_colour =:= ?NAME_COLOUR_RED;
						   ?OBJ_TYPE_PET ->
							   true;
						   _ ->
							   false
					   end;
				   ?ATTACK_TYPE_GUARD_2 ->
					   case TargetState#scene_obj_state.obj_type of
						   ?OBJ_TYPE_PLAYER ->
							   TargetState#scene_obj_state.name_colour =:= ?NAME_COLOUR_RED;
						   _ ->
							   false
					   end;
				   ?ATTACK_TYPE_MOVE ->
					   case TargetState#scene_obj_state.obj_type of
						   ?OBJ_TYPE_MONSTER ->
							   TargetState#scene_obj_state.attack_type == ?ATTACK_TYPE_STATIC_2;
						   ?OBJ_TYPE_COLLECT ->
							   false;
						   _ ->
							   true
					   end;
				   ?ATTACK_TYPE_MOVE_2 ->
					   case TargetState#scene_obj_state.obj_type of
						   ?OBJ_TYPE_MONSTER ->
							   TargetState#scene_obj_state.attack_type == ?ATTACK_TYPE_STATIC_2;
						   ?OBJ_TYPE_COLLECT ->
							   false;
						   _ ->
							   false
					   end;
				   _ ->
					   case TargetState#scene_obj_state.obj_type of
						   ?OBJ_TYPE_MONSTER ->
							   false;
						   _ ->
							   true
					   end
			   end,
		%% 判断与目标的距离信息
		case IsOk of
			false ->
				Acc;
			_ ->
				D1 = util_math:get_distance_set({X, Y}, {TargetState#scene_obj_state.x, TargetState#scene_obj_state.y}),
				%% 是否在警戒范围内
				case D1 =< GuardRange * GuardRange of
					true ->
						%% 是否在追击范围內
						case ChaseRange > 0 andalso D1 > ChaseRange * ChaseRange of
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
chose_target(SceneState, ObjState, HostileList) ->
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


%% 把施法者加入仇恨列表
add_enmity(SceneState, ObjState, CasterState, HarmValue) ->
	#scene_obj_state{
		obj_type = CasterType,
		obj_id = CasterId
	} = CasterState,
	EnmityDict = ObjState#scene_obj_state.enmity_dict,
	EffectiveTime = util_date:unixtime() + 30,
	NewEnmityDict =
		case dict:find({CasterType, CasterId}, EnmityDict) of
			{ok, EnmityObj} ->
				NewValue = EnmityObj#enmity_info.value + HarmValue,
				NewEnmityObj = EnmityObj#enmity_info{
					value = NewValue,
					effective_time = EffectiveTime
				},
				dict:store({CasterType, CasterId}, NewEnmityObj, EnmityDict);
			_ ->
				NewEnmityObj = #enmity_info{
					obj_type = CasterType,
					obj_id = CasterId,
					value = HarmValue,
					effective_time = EffectiveTime
				},
				dict:store({CasterType, CasterId}, NewEnmityObj, EnmityDict)
		end,
	NewObjState = ObjState#scene_obj_state{enmity_dict = NewEnmityDict},
	NewSceneState = scene_base_lib:store_scene_obj_state(SceneState, NewObjState, ObjState),
	{NewSceneState, NewObjState}.

%% 检查仇恨列表，清理超时的仇恨信息
check_enmity(ObjState) ->
	EnmityDict = ObjState#scene_obj_state.enmity_dict,
	CurTime = util_date:unixtime(),
	F = fun(Key, EnmityInfo, Acc) ->
		case EnmityInfo#enmity_info.effective_time < CurTime of
			true ->
				dict:erase(Key, Acc);
			_ ->
				Acc
		end
	end,
	NewEnmityDict = dict:fold(F, EnmityDict, EnmityDict),
	ObjState#scene_obj_state{enmity_dict = NewEnmityDict}.

%% 检查掉落归属是否失效
check_drop_owner(SceneState, ObjState) ->
	DropOwner = ObjState#scene_obj_state.drop_owner,
	case util_data:is_null(DropOwner) of
		true ->
			ObjState;
		_ ->
			CurTime = util_date:unixtime(),
			case DropOwner#cur_drop_owner_info.effective_time < CurTime of
				true ->
					NewObjState = ObjState#scene_obj_state{drop_owner = null},
					scene_send_lib:send_monster_update(SceneState, NewObjState),
					NewObjState;
				_ ->
					ObjState
			end
	end.

%% 产生随机掉落信息
rand_drop(MonsterId, Career, SceneId, ObjState) ->
	MonsterConf = monster_config:get(MonsterId),
	DropModulus = get_drop_modulus(ObjState),
	DropList =
		case MonsterConf#monster_conf.is_growth == 1 of
			true ->
				MonsterId = MonsterConf#monster_conf.monster_id,
				KillCount = monster_kills_cache:get_monster_kills_count(MonsterId, SceneId),
				%% 刷新击杀次数
				monster_kills_cache:update_monster_kills(MonsterId, SceneId),
				case monster_growth_config:get(KillCount) of
					#monster_growth_conf{} = GrowthConf ->
						GrowthConf#monster_growth_conf.drop_list;
					_ ->
						MonsterConf#monster_conf.drop_list
				end;
			false ->
				MonsterConf#monster_conf.drop_list
		end,
	rand_drop1(DropList, Career, [], DropModulus).

rand_drop1([], _Career, DropList, _DropModulus) ->
	DropList;
rand_drop1([{CareerLimit, DropWeightList, List} | T], Career, DropList, DropModulus) ->
	case CareerLimit == 0 orelse CareerLimit == Career of
		true ->
			List1 = [{{GoodsId, IsBind, Num}, Rate} || {GoodsId, IsBind, Num, Rate} <- List],
			DropWeightList1 = add_drop_modulus(DropWeightList, DropModulus),
			DropNum = util_rand:weight_rand_ex(DropWeightList1),
			DropList1 =
				case DropNum > 0 of
					true ->
						[util_rand:weight_rand_ex(List1) || _N <- lists:seq(1, DropNum)];
					_ ->
						[]
				end,
			rand_drop1(T, Career, DropList1 ++ DropList, DropModulus);
		_ ->
			rand_drop1(T, Career, DropList, DropModulus)
	end.

%% 掉落广播
send_loot_notic(ObjState, _KillerState, GoodsList, SceneId, OwnerName) ->
	try
		Fun = fun({GoodsId, _IsBind, _Num}, Acc) ->
			GoodsConf = goods_config:get(GoodsId),
			case GoodsConf#goods_conf.is_notice == 1 of
				true ->
					[GoodsConf#goods_conf.name] ++ Acc;
				false ->
					Acc
			end
		end,
		DropNameList = lists:foldl(Fun, [], GoodsList),

		case DropNameList =/= [] of
			true ->
				GoodsStr = string:join(DropNameList, ", "),
				MonsterId = ObjState#scene_obj_state.monster_id,
				MonsterInfo = monster_config:get(MonsterId),
				MonsterName = MonsterInfo#monster_conf.name,
				case ObjState#scene_obj_state.drop_owner of
					#cur_drop_owner_info{} = DropOwnerInfo ->
						PlayerName = DropOwnerInfo#cur_drop_owner_info.name,
						Lv = DropOwnerInfo#cur_drop_owner_info.lv,
						SceneConf = scene_config:get(SceneId),
						SceneName = SceneConf#scene_conf.name,
						%% 藏宝图怪物判断
						MapConf = goods_map_config:get(Lv),
						MonsterList = MapConf#goods_map_conf.monster_list,
						case lists:keyfind(MonsterId, 1, MonsterList) of
							false ->
								NoticeName = case OwnerName =/= null of
												 true -> OwnerName;
												 false -> PlayerName
											 end,
								notice_lib:send_notice(0, ?NOTICE_MONSTER_LOOT, [MonsterName, SceneName, NoticeName, GoodsStr]);
							_ ->
								notice_lib:send_notice(0, ?NOTICE_XUNBAO_KILL, [PlayerName, GoodsStr])
						end;
					_ ->
						SceneConf = scene_config:get(SceneId),
						SceneName = SceneConf#scene_conf.name,
						notice_lib:send_notice(0, ?NOTICE_RANDOM_BOSS_LOOT, [MonsterName, SceneName, GoodsStr])
				end;
			false ->
				skip
		end
	catch
		_Err:_Info ->
			?ERR("~p : ~p~nstacktrace : ~p", [_Err, _Info, erlang:get_stacktrace()])
	end.

%% 获取掉落系数
get_drop_modulus(ObjState) ->
	case ObjState#scene_obj_state.drop_owner of
		#cur_drop_owner_info{} = DropOwnerInfo ->
			MonsterId = ObjState#scene_obj_state.monster_id,
			MonsterConf = monster_config:get(MonsterId),
			MonsterLv = MonsterConf#monster_conf.lv,

			OwnerLv = DropOwnerInfo#cur_drop_owner_info.lv,
			Harm = DropOwnerInfo#cur_drop_owner_info.harm,
			TotalHarm = DropOwnerInfo#cur_drop_owner_info.total_harm,

			case OwnerLv >= MonsterLv of
				true ->
					1;
				false ->
					DiffLv = MonsterLv - OwnerLv,
					DropConf = drop_modulus_config:get(DiffLv),
					LvModulus = DropConf#drop_modulus_conf.modulus,
					VipLv = DropOwnerInfo#cur_drop_owner_info.vip,
					Career = DropOwnerInfo#cur_drop_owner_info.career,
					VipConf = vip_config:get(VipLv, Career),
					VipDropModulus = VipConf#vip_conf.drop_modulus,
					max(1, LvModulus * Harm / TotalHarm * VipDropModulus)
			end;
		_ ->
			1
	end.

%% 增加掉落系数
add_drop_modulus(DropWeightList, Modulus) ->
	Fun = fun(N, Rate) ->
		case N == 0 of
			true -> {N, Rate};
			false ->
				NewRate = max(Rate, util_math:floor(Modulus * Rate)),
				{N, NewRate}
		end
	end,
	[Fun(X, Y) || {X, Y} <- DropWeightList].

%% 特殊掉落
spec_drop(ObjState, MonsterId, LimitList) ->
	MonsterId = ObjState#scene_obj_state.monster_id,
	MonsterConf = monster_config:get(MonsterId),
	case MonsterConf#monster_conf.is_drop of
		0 -> %% 不启用掉落
			[];
		_ ->
			spec_drop_1(ObjState, MonsterConf, LimitList)
	end.

spec_drop_1(ObjState, MonsterConf, LimitList) ->
	MonsterId = MonsterConf#monster_conf.monster_id,
	DropRate = player_drop_cache:get_player_drop_value(?ALL_SERVER_SIGN, MonsterConf),

	case util_rand:rand_hit(DropRate) of
		true ->
			spec_drop_2(ObjState, MonsterConf, LimitList);
		false ->
			%% 更新玩家幸运值
			player_drop_cache:update_player_kill_count(?ALL_SERVER_SIGN, MonsterId),
			[]
	end.

spec_drop_2(_ObjState, MonsterConf, LimitList) ->
	SpecDropList = MonsterConf#monster_conf.special_drop,
	MonsterId = MonsterConf#monster_conf.monster_id,

	%% 过滤已掉落的道具
	NewSpecDropList = filter_special_drop(LimitList, SpecDropList, MonsterConf#monster_conf.drop_type),

	%% 随机其中一个道具
	case util_rand:list_rand(NewSpecDropList) of
		null ->
			%% 更新玩家幸运值
			player_drop_cache:update_player_kill_count(?ALL_SERVER_SIGN, MonsterId),
			[];
		{GoodsId, IsBind, Num} ->
			%% 重置玩家幸运值
			player_drop_cache:reset_player_kill_count(?ALL_SERVER_SIGN, MonsterId),

			[{GoodsId, IsBind, Num}]
	end.

%% 过滤已掉落的道具
filter_special_drop(LimitList, SpecDropList, Type) ->
	Fun = fun({GoodsId, IsBind, Num}, Acc) ->
		case special_drop_config:get({GoodsId, Type}) of
			#special_drop_conf{} = SpecDropConf ->
				DropType = SpecDropConf#special_drop_conf.drop_type,
				case lists:member(DropType, LimitList) of
					true -> Acc;
					false -> [{GoodsId, IsBind, Num}] ++ Acc
				end;
			_ ->
				[{GoodsId, IsBind, Num}] ++ Acc
		end
	end,
	lists:foldl(Fun, [], SpecDropList).

%% 更新掉落次数
update_drop(DropList, MonsterConf) ->
	Type = MonsterConf#monster_conf.drop_type,
	Fun = fun({GoodsId, _IsBind, Num}) ->
		%% 更新特殊掉落
		special_drop_cache:update_drop_type_info(GoodsId, Num, Type)
	end,
	[Fun(X) || X <- DropList].

%% 检测通常掉落
check_normal_drop([], _MonsterConf) ->
	skip;
check_normal_drop([{GoodsId, _IsBind, _Num} | T], MonsterConf) ->
	GoodsConf = goods_lib:get_goods_conf_by_id(GoodsId),
	case GoodsConf#goods_conf.type == ?EQUIPS_TYPE andalso GoodsConf#goods_conf.quality == 5 of
		true ->
			%% 如果装备是橙色装备清空怪物幸运值
			MonsterId = MonsterConf#monster_conf.monster_id,
			player_drop_cache:reset_player_kill_count(?ALL_SERVER_SIGN, MonsterId);
		false ->
			check_normal_drop(T, MonsterConf)
	end.

%% 怪物预警技能检测
check_warning_skill([], SceneState, ObjState, _CurHp, _HarmValue) ->
	{SceneState, ObjState};
check_warning_skill([{_MinP, MaxP, Id, WaringList, _SkillList} | T], SceneState, ObjState, CurHp, HarmValue) ->
	case ObjState#scene_obj_state.warning_skill_info == [] of
		true ->
			AttrBase = ObjState#scene_obj_state.attr_total,
			Hp = AttrBase#attr_base.hp,
			HpPercent = util_math:floor((CurHp / Hp) * ?PERCENT_BASE),
			OldHpPercent = util_math:floor(((CurHp + HarmValue) / Hp) * ?PERCENT_BASE),
			%% 根据当前对象的血量百分百来选择应该释放的技能
			case MaxP =< OldHpPercent andalso HpPercent =< MaxP of
				true ->
					%% 血量变化预警
					case Id == 0 of
						true -> skip;
						false ->
							ObjId = ObjState#scene_obj_state.obj_id,
							ObjType = ObjState#scene_obj_state.obj_type,
							scene_send_lib:do_send_screen(SceneState, ObjType, ObjId, false, 11052, #rep_monster_warning{warning_id = Id})
					end,
					%% 更新预警技能
					case WaringList of
						[{Time1, WaringId, Time2, WaringSkill} | _] ->
							NowTime = util_date:unixtime(),
							WaringInfo = {NowTime + Time1, WaringId},
							WaringSkillInfo = {NowTime + Time2, WaringSkill},
							NewObjState = ObjState#scene_obj_state{warning_info = WaringInfo, warning_skill_info = WaringSkillInfo},
							NewSceneState = scene_base_lib:store_scene_obj_state(SceneState, NewObjState, ObjState),
							{NewSceneState, NewObjState};
						_ ->
							{SceneState, ObjState}
					end;
				_ ->
					check_warning_skill(T, SceneState, ObjState, CurHp, HarmValue)
			end;
		false ->
			{SceneState, ObjState}
	end;
check_warning_skill(_, SceneState, ObjState, _CurHp, _HarmValue) ->
	{SceneState, ObjState}.

%% 定时器检测是否播放技能预警
check_warning(SceneState, ObjState) ->
	NowTime = util_date:unixtime(),
	case ObjState#scene_obj_state.warning_info of
		{WaringTime, WaringId} ->
			case NowTime >= WaringTime of
				true ->
					ObjId = ObjState#scene_obj_state.obj_id,
					ObjType = ObjState#scene_obj_state.obj_type,
					scene_send_lib:do_send_screen(SceneState, ObjType, ObjId, false, 11052, #rep_monster_warning{warning_id = WaringId}),
					ObjState#scene_obj_state{warning_info = []};
				false ->
					ObjState
			end;
		_ ->
			ObjState
	end.