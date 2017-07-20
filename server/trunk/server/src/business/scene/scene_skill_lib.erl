%%%-------------------------------------------------------------------
%%% @author zhengsiying
%%% @copyright (C) 2015, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 09. 十一月 2015 下午3:04
%%%-------------------------------------------------------------------
-module(scene_skill_lib).

-include("common.hrl").
-include("record.hrl").
-include("config.hrl").
-include("proto.hrl").
-include("cache.hrl").
%% API
-export([
	obj_start_use_skill/4,
	obj_use_skill/3,
	trigger_buff_effect/5,
	remove_effect_buff/4,
	check_and_do_fire_wall/1,
	get_fire_wall_state/2,
	remove_buff/4,
	sync_harm/4,
	sync_cure/4
]).

%% callbacks
-export([
	do_obj_start_use_skill/5,
	do_obj_use_skill/4,
	do_remove_buff/4,
	do_trigger_buff_effect/5
]).

%% ====================================================================
%% API functions
%% ====================================================================
%% 对象开始使用技能(玩家进程调用)
obj_start_use_skill(PlayerState, SKillIdLv, TargetObjOrPoint, Direction) ->
	#player_state{
		player_id = PlayerId,
		scene_pid = ScenePid
	} = PlayerState,
	gen_server2:apply_async(ScenePid, {?MODULE, do_obj_start_use_skill, [{?OBJ_TYPE_PLAYER, PlayerId}, SKillIdLv, TargetObjOrPoint, Direction]}).

%% 对象开始使用技能(场景进程调用，这里还没有触发技能效果)
do_obj_start_use_skill(SceneState, {CasterType, CasterId}, {SkillId, SkillLv}, TargetObjOrPoint, Direction) ->
	%% 检查施法者是否合法
	case check_caster(SceneState, CasterType, CasterId) of
		{ok, CasterState} ->
			#scene_obj_state{
				x = X,
				y = Y
			} = CasterState,

			%% 根据技能的目标类型提取数据
			{TargetType, Flag, Point} =
				case TargetObjOrPoint of
					{target, ObjType, ObjId} ->
						{?TARGET_TYPE_OBJ, #proto_obj_flag{type = ObjType, id = ObjId}, #proto_point{}};
					{point, TX, TY} ->
						{?TARGET_TYPE_POINT, #proto_obj_flag{}, #proto_point{x = TX, y = TY}}
				end,

			Data = #rep_start_use_skill{
				caster_flag = #proto_obj_flag{type = CasterType, id = CasterId},
				caster_point = #proto_point{x = X, y = Y},
				direction = Direction,
				skill_id = SkillId,
				skill_lv = SkillLv,
				target_type = TargetType,
				target_flag = Flag,
				target_point = Point
			},

			%% 检测是否是警告技能 是警告技能则计算下一次警告技能时间
			CasterState1 =
				case CasterState#scene_obj_state.warning_skill_info of
					{_UseTime, WSkillId} when SkillId == WSkillId ->
						update_warning_skill_info(CasterState, WSkillId);
					_ ->
						CasterState
				end,

			%% 记录最后使用的技能id，便于触发技能
			NewCasterState = CasterState1#scene_obj_state{
				direction = Direction,
				last_use_skill = #use_skill_info{
					skill_id = SkillId,
					target = TargetObjOrPoint
				},
				last_skill = SkillId
			},
			NewSceneState = scene_base_lib:store_scene_obj_state(SceneState, NewCasterState, CasterState),

			%% 通知同屏玩家
			scene_send_lib:do_send_screen(NewSceneState, CasterType, CasterId, true, 12002, Data),
			{ok, NewSceneState};
		{fail, Err} ->
			{fail, Err}
	end.

%% 对象使用技能，这里是真实触发技能效果(玩家进程调用)
obj_use_skill(PlayerState, SkillConf, TargetObjOrPoint) when is_record(PlayerState, player_state) ->
	PlayerId = PlayerState#player_state.player_id,
	gen_server2:apply_async(PlayerState#player_state.scene_pid, {?MODULE, do_obj_use_skill,
		[{?OBJ_TYPE_PLAYER, PlayerId}, SkillConf, TargetObjOrPoint]}).

%% 对象使用技能，这里是真实触发技能效果(场景进程调用)
do_obj_use_skill(SceneState, {CasterType, CasterId}, SkillConf, TargetObjOrPoint) ->
	%% 检查施法者，受击者和技能是否满足技能释放
	case check_obj_use_skill(SceneState, CasterType, CasterId, SkillConf, TargetObjOrPoint) of
		{ok, CasterState, TargetList, {TargetType, TargetId}, {TargetX, TargetY}} ->
			SkillInfo = #spell_skill_info{
				target_point = {TargetX, TargetY},
				skill_conf = SkillConf
			},

			%% 调用技能模块计算技能效果
			case skill_base_lib:scene_obj_use_skill(SceneState, CasterState#scene_obj_state{last_use_skill = null}, SkillInfo, TargetList, TargetId, TargetType) of
				{ok, UpdateDict, SkillEffect} ->

					do_obj_use_skill1(SceneState, CasterState, SkillConf, TargetType,
						TargetId, TargetX, TargetY, UpdateDict, SkillEffect);
				{fail, Err} ->
					{fail, Err}
			end;
		{fail, Err} ->
			{fail, Err}
	end.

%% 根据计算出来的技能效果和对象更新，更新场景对应，通知前端对象更新
do_obj_use_skill1(SceneState, CasterState, SkillConf, TargetType,
	TargetId, TargetX, TargetY, UpdateDict, SkillEffect) ->
	#scene_obj_state{
		obj_type = CasterType,
		obj_id = CasterId,
		obj_pid = CasterPid,
		lv = CasterLv,
		pet_dict = PetDict
	} = CasterState,

	%% 更新场景对象
	SceneState1 = scene_base_lib:store_scene_obj_state(SceneState, UpdateDict),%%

	TargetList = make_target_list(SkillEffect),
	TargetList1 =
		case TargetList =:= [] andalso {TargetType, TargetId} /= {0, 0} of
			true ->
				[#proto_obj_flag{type = TargetType, id = TargetId}];
			_ ->
				TargetList
		end,

	%% 根据技能影响效果生成气血变更表
	HpMpUpdateList = scene_send_lib:make_hp_mp_update_list(SceneState1, SkillEffect),
	%% 发送更新给前端
	SceneStateNew = send_skill_effect(SceneState1, CasterType, CasterId, TargetList1, SkillEffect, HpMpUpdateList),

	SceneState2 =
		case CasterType of
			?OBJ_TYPE_PLAYER ->
				%% 切换宠物目标
				change_pet_target(SceneStateNew, PetDict, SkillEffect);
			_ ->
				SceneStateNew
		end,
	%% 同步技能效果给对应的对象
	NewSceneState = sync_to_obj_mod(SceneState2, UpdateDict, SkillEffect, CasterState),

	%% 如果是因为烈火buff而砍出来的烈火伤害不用增加技能熟练度
	case SkillConf#skill_conf.skill_id /= ?SPECIAL_SKILL_ID_FIRE_1 of
		true ->
			%% 技能是否增加熟练度检测
			check_and_add_skill_exp(CasterState, SkillConf, SkillEffect, TargetList1);
		_ ->
			skip
	end,

	SkillId = SkillConf#skill_conf.skill_id,
	SkillLv = SkillConf#skill_conf.lv,

	%% 触发召唤宠物效果
	{ok, NewSceneState1} =
		case SkillEffect#skill_effect.call_pet of
			MonsterId when is_integer(MonsterId) ->
				SkillTreeConf1 = skill_tree_config:get({SkillId, SkillLv}),
				case CasterLv >= SkillTreeConf1#skill_tree_conf.limit_lv of
					true -> gen_server2:cast(CasterPid, {add_skill_exp, SkillId});
					false -> skip
				end,
				scene_obj_lib:create_pet(NewSceneState, CasterState, MonsterId);
			_ ->
				{ok, NewSceneState}
		end,

	%% 触发火墙效果
	NewSceneState2 =
		case SkillEffect#skill_effect.fire_wall of
			{Percent, EffectiveTime, Interval} ->
				make_fire_wall(NewSceneState1, CasterState, Percent, EffectiveTime, Interval, {TargetX, TargetY});
			_ ->
				NewSceneState1
		end,

	%% 移除buff
	NewSceneState3 =
		case SkillEffect#skill_effect.remove_effect of
			{ObjType, ObjId, EffectId} ->
				case remove_effect_buff(NewSceneState2, ObjType, ObjId, EffectId) of
					{_NewSceneState2, _} ->
						_NewSceneState2;
					_ ->
						NewSceneState2
				end;
			_ ->
				NewSceneState2
		end,

	%% 触发诱惑之光效果
	NewSceneState4 =
		case SkillEffect#skill_effect.tempt of
			{ok, TargetType, TargetId, PetId} ->
				TargetState = scene_base_lib:get_scene_obj_state(NewSceneState3, TargetType, TargetId),
				case obj_monster_lib:be_tempt(NewSceneState3, TargetState) of
					{ok, _NewSceneState3} ->
						case scene_obj_lib:create_pet(_NewSceneState3, CasterState, PetId) of
							{ok, __NewSceneState3} ->
								__NewSceneState3;
							_ ->
								_NewSceneState3
						end;
					_ ->
						NewSceneState3
				end;
			{void} ->
				NewSceneState3;
			{lv_limit} ->
				NewSceneState3;
			{pet_num_limit} ->
				NewSceneState3;
			_ ->
				NewSceneState3
		end,

	%% 施法成功，判断是否是使用了隐身技能
	case lists:keyfind(?BUFF_EFFECT_INVISIBILITY, #proto_buff_operate.effect_id, SkillEffect#skill_effect.buff_list) of
		#proto_buff_operate{} = _ ->
			%% 如果是隐身技能这里不需要做操作
			{ok, NewSceneState4};
		_ ->
			%% 如果不是隐身技能，去除身上的隐身效果
			case remove_effect_buff(NewSceneState4, CasterType, CasterId, ?BUFF_EFFECT_INVISIBILITY) of
				{NewSceneState5, _} ->
					{ok, NewSceneState5};
				_ ->
					{ok, NewSceneState4}
			end
	end.

%% 发送技能效果给前端
send_skill_effect(SceneState, CasterType, CasterId, TargetList, SkillEffect, HpMpUpdateList) ->
	SceneStatNew = case length(SkillEffect#skill_effect.buff_list) > 0 orelse
		length(SkillEffect#skill_effect.move_list) > 0 orelse
		length(SkillEffect#skill_effect.knockback_list) > 0 of
					   true ->
						   case CasterType =:= ?OBJ_TYPE_PLAYER orelse CasterType =:= ?OBJ_TYPE_PET of
							   true ->
								   Data = #rep_trigger_skill{
									   target_list = TargetList,
									   buff_list = SkillEffect#skill_effect.buff_list,
									   move_list = SkillEffect#skill_effect.move_list,
									   knockback_list = SkillEffect#skill_effect.knockback_list
								   },
								   %% 发送非气血变更效果给前端
								   scene_send_lib:do_send_screen(SceneState, CasterType, CasterId, true, 12010, Data),
								   SceneState;
							   _ ->
								   %% 发送非气血变更效果给前端
								   scene_send_lib:add_send_screen_12010(SceneState,
									   CasterType,
									   CasterId,
									   TargetList,
									   SkillEffect#skill_effect.buff_list,
									   SkillEffect#skill_effect.move_list,
									   SkillEffect#skill_effect.knockback_list)
						   end;
					   _ ->
						   SceneState
				   end,

	case length(HpMpUpdateList) > 0 of
		true ->

			case CasterType =:= ?OBJ_TYPE_PLAYER orelse CasterType =:= ?OBJ_TYPE_PET of
				true ->
					%% 发送气血变更效果给前端（气血变更必须单独出来，统一的气血变更便于管理）
					Data1 = scene_send_lib:make_rep_obj_often_update_atk(CasterId, CasterType, HpMpUpdateList, #rep_obj_often_update{}),
					scene_send_lib:do_send_screen(SceneState, CasterType, CasterId, true, 11020, Data1),
					SceneStatNew;
				_ ->
					%% 发送气血变更效果给前端（气血变更必须单独出来，统一的气血变更便于管理）
					scene_send_lib:add_send_screen_11020(SceneStatNew, CasterType, CasterId, HpMpUpdateList)
			end;
		_ ->
			SceneStatNew
	end.

%% 改变宠物目标
change_pet_target(SceneState, PetDict, SkillEffect) ->
	%% 判断施法者是否有宠物，判断是否是伤害型的技能
	case PetDict /= dict:new() andalso SkillEffect#skill_effect.harm_list /= [] of
		true ->
			%% 在所有受伤的目标里面随机找一个目标为宠物目标
			HarmProto = util_rand:list_rand(SkillEffect#skill_effect.harm_list),
			#proto_obj_flag{
				type = TargetType1,
				id = TargetId1
			} = HarmProto#proto_harm.obj_flag,
			case scene_base_lib:get_scene_obj_state(SceneState, TargetType1, TargetId1) of
				#scene_obj_state{} = TargetState ->
					F = fun(_, PetInfo, Acc) ->
						PetId = PetInfo#pet_info.uid,
						case scene_base_lib:get_scene_obj_state(Acc, ?OBJ_TYPE_PET, PetId) of
							#scene_obj_state{} = PetState ->
								%% 设置宠物目标
								{NewAcc, _} = game_obj_lib:set_cur_target(Acc, PetState, TargetState),
								NewAcc;
							_ ->
								Acc
						end
					end,
					dict:fold(F, SceneState, PetDict);
				_ ->
					SceneState
			end;
		_ ->
			SceneState
	end.

%% 检查并增加技能熟练度
check_and_add_skill_exp(CasterState, SkillConf, SkillEffect, TargetList) ->
	#scene_obj_state{
		obj_type = CasterType,
		obj_pid = CasterPid,
		lv = CasterLv
	} = CasterState,

	SkillId = SkillConf#skill_conf.skill_id,
	SkillLv = SkillConf#skill_conf.lv,
	case CasterType of
		?OBJ_TYPE_PLAYER ->
			case skill_tree_config:get({SkillId, SkillLv}) of
				#skill_tree_conf{} = SkillTreeConf ->
					LimitLv = SkillTreeConf#skill_tree_conf.limit_lv,
					case CasterLv >= LimitLv of
						true ->
							case SkillTreeConf#skill_tree_conf.trigger_type of
								?SKILL_TRIGGER_1 ->
									gen_server2:cast(CasterPid, {add_skill_exp, SkillId});
								?SKILL_TRIGGER_2 ->
									case SkillEffect#skill_effect.harm_list =/= [] of
										true -> gen_server2:cast(CasterPid, {add_skill_exp, SkillId});
										false -> skip
									end;
								?SKILL_TRIGGER_5 ->
									case lists:keyfind(?OBJ_TYPE_MONSTER, #proto_obj_flag.type, TargetList) of
										false -> skip;
										_ -> gen_server2:cast(CasterPid, {add_skill_exp, SkillId})
									end;
								?SKILL_TRIGGER_6 ->
									case SkillEffect#skill_effect.buff_list =/= [] of
										true -> gen_server2:cast(CasterPid, {add_skill_exp, SkillId});
										false -> skip
									end;
								_ ->
									skip
							end;
						false ->
							skip
					end;
				_ ->
					skip
			end;
		_ ->
			skip
	end.

%% 触发buff效果
trigger_buff_effect(ScenePid, ObjType, ObjId, Update, BuffResultList) ->
	gen_server2:apply_async(ScenePid, {?MODULE, do_trigger_buff_effect, [ObjType, ObjId, Update, BuffResultList]}).
%% 触发buff效果
do_trigger_buff_effect(SceneState, ObjType, ObjId, Update, BuffResultList) ->
	scene_send_lib:do_send_buff_effect(SceneState, ObjType, ObjId, BuffResultList),
	%% ?ERR("222 ~p ~p", [length(BuffResultList), {BuffResultList}]),
	scene_obj_lib:do_update_obj(SceneState, ObjType, ObjId, Update, ?UPDATE_CAUSE_SKILL).

%% 根据移除列表移除buff
remove_buff(ScenePid, ObjType, ObjId, RemoveList) ->
	gen_server2:apply_async(ScenePid, {?MODULE, do_remove_buff, [ObjType, ObjId, RemoveList]}).

do_remove_buff(SceneState, ObjType, ObjId, RemoveList) ->
	case scene_base_lib:get_scene_obj_state(SceneState, ObjType, ObjId) of
		#scene_obj_state{} = ObjState ->
			F = fun(BuffId, Acc) ->
				buff_base_lib:remove_buff(Acc, BuffId)
			end,
			NewObjState = lists:foldl(F, ObjState, RemoveList),
			NewSceneState = scene_base_lib:store_scene_obj_state(SceneState, NewObjState, ObjState),
			%% 移除buff信息
			do_remove_buff(NewSceneState, NewObjState, RemoveList),
			{ok, NewSceneState};
		_ ->
			skip
	end.
%% 移除buff信息
do_remove_buff(SceneState, ObjState, RemoveList) ->
	F1 = fun(BuffId) ->
		BuffConf = buff_config:get(BuffId),
		#proto_buff_operate{
			obj_flag = #proto_obj_flag{type = ObjState#scene_obj_state.obj_type, id = ObjState#scene_obj_state.obj_id},%% 都是玩家
			operate = ?BUFF_OPERATE_DELETE,
			buff_id = BuffId,
			effect_id = BuffConf#buff_conf.effect_id
		}
	end,
	List = [F1(BuffId) || BuffId <- RemoveList],
	Data = #rep_buff_operate{
		buff_list = List
	},
	scene_send_lib:do_send_screen(SceneState, ObjState#scene_obj_state.obj_type, ObjState#scene_obj_state.obj_id, true, 11007, Data).

%% 根据效率ID移除对象的buff
remove_effect_buff(SceneState, ObjType, ObjId, EffectId) ->
	case scene_base_lib:get_scene_obj_state(SceneState, ObjType, ObjId) of
		#scene_obj_state{} = ObjState ->
			{NewObjState, RemoveList} = buff_base_lib:remove_effect_buff(ObjState, EffectId),
			case RemoveList /= [] of
				true ->
					MakeProtoF =
						fun(BuffId, Acc) ->
							BuffConf = buff_config:get(BuffId),
							Proto = #proto_buff_operate{
								obj_flag = #proto_obj_flag{type = ObjType, id = ObjId},
								operate = ?BUFF_OPERATE_DELETE,
								buff_id = BuffId,
								effect_id = BuffConf#buff_conf.effect_id
							},
							[Proto | Acc]
						end,
					List = lists:foldl(MakeProtoF, [], RemoveList),
					scene_send_lib:do_send_screen(SceneState, ObjType, ObjId, true, 11007, #rep_buff_operate{buff_list = List}),
					NewSceneState = scene_base_lib:store_scene_obj_state(SceneState, NewObjState, ObjState),
					{NewSceneState, NewObjState};
				_ ->
					skip
			end;
		_ ->
			skip
	end.

%% 场景火墙检测
check_and_do_fire_wall(SceneState) ->
	FireWallDict = SceneState#scene_state.fire_wall_dict,
	CurTime = util_date:unixtime(),
	F = fun(_, FireWallState, Acc) ->
		{Acc1, FireWallState1} = fire_wall_attack(Acc, FireWallState, CurTime),
		remove_invalid_fire_wall(Acc1, FireWallState1, CurTime)
	end,
	dict:fold(F, SceneState, FireWallDict).

%% 场景火墙攻击检测
fire_wall_attack(SceneState, FireWallState, CurTime) ->
	#fire_wall_state{
		uid = FireUid,
		owner_id = OwnerId,
		pk_mode = PkMode,
		x = X,
		y = Y,
		interval = Interval,
		next_time = NextTime,
		guild_id = GuildId,
		team_id = TeamId
	} = FireWallState,
	SceneId = SceneState#scene_state.scene_id,
	%% 检查攻击触发时间和是否在安全区
	case NextTime =< CurTime andalso not area_lib:is_in_safety_area(SceneId, {X, Y}) of
		true ->
			%% 获取站在火强坐标点上的所有对象
			ObjFlagList = scene_base_lib:get_point_obj(SceneState, {X, Y}),
			FireSceneObj = #scene_obj_state{
				obj_type = ?OBJ_TYPE_FIRE_WALL,
				obj_id = FireUid,
				owner_id = OwnerId,
				pk_mode = PkMode,
				guild_id = GuildId,
				team_id = TeamId
			},

			%% 过滤掉非仇敌玩家
			F = fun({ObjType, ObjId}, Acc) ->
				case scene_base_lib:get_scene_obj_state(SceneState, ObjType, ObjId) of
					#scene_obj_state{} = SceneObjState ->
						case skill_rule_lib:check_target(?SKILL_TARGET_HOSTILE, FireSceneObj, SceneObjState) of
							true ->
								[SceneObjState | Acc];
							_ ->
								Acc
						end;
					_ ->
						Acc
				end
			end,
			ObjList = lists:foldl(F, [], ObjFlagList),

			SceneState1 =
				case ObjList /= [] of
					true ->
						%% 随机选择其中一个目标作为攻击目标
						Target = util_rand:list_rand(ObjList),
						%% 计算火墙伤害
						{HarmResult, NewTarget} = skill_base_lib:fire_wall_attack(FireWallState, Target),
						#scene_obj_state{
							obj_type = TargetType,
							obj_id = TargetId,
							cur_hp = CurHp,
							cur_mp = CurMp
						} = NewTarget,

						ProtoHarm = #proto_harm{
							obj_flag = #proto_obj_flag{type = TargetType, id = TargetId},
							harm_status = HarmResult#harm_result.status,
							harm_value = HarmResult#harm_result.harm_value,
							cur_hp = CurHp,
							cur_mp = CurMp
						},
						HarmList = [ProtoHarm],
						ObjDict = dict:store({TargetType, TargetId}, NewTarget, dict:new()),

						%% 获取施法者
						CasterState =
							case scene_base_lib:get_scene_obj_state(SceneState, ?OBJ_TYPE_PLAYER, OwnerId) of
								#scene_obj_state{} = OwnerState ->
									%% 如果释放火墙的玩家跟火强同一场景，则施法者为玩家
									OwnerState;
								_ ->
									%% 否则标识为火墙
									fire_wall
							end,

						%% 同步伤害
						_SceneState = scene_base_lib:store_scene_obj_state(SceneState, NewTarget),%%
						_SceneState1 = case CasterState of
										   #scene_obj_state{} ->
											   sync_harm(_SceneState, ObjDict, HarmList, CasterState);
										   _ ->
											   _SceneState
									   end,


						%% 通知前端气血变更
						HpMpUpdateList = scene_send_lib:make_hp_mp_update_list(_SceneState1, #skill_effect{harm_list = HarmList, cure_list = []}),
						Data = scene_send_lib:make_rep_obj_often_update(HpMpUpdateList, #rep_obj_often_update{}),
						scene_send_lib:do_send_screen(_SceneState1, TargetType, TargetId, true, 11020, Data),

						_SceneState1;
					_ ->
						SceneState
				end,
			%% 更新火墙状态
			FireWallState1 = FireWallState#fire_wall_state{next_time = NextTime + Interval},
			SceneState2 = update_fire_wall_state(SceneState1, FireWallState1),
			{SceneState2, FireWallState1};
		_ ->
			{SceneState, FireWallState}
	end.

%% 移除失效火墙
remove_invalid_fire_wall(SceneState, FireWallState, CurTime) ->
	case FireWallState#fire_wall_state.remove_time =< CurTime of
		true ->
			delete_fire_wall_state(SceneState, FireWallState);
		_ ->
			SceneState
	end.

%% ====================================================================
%% Internal functions
%% ====================================================================
%% 检查施法者，技能和受击者信息
check_obj_use_skill(SceneState, CasterType, CasterId, SkillConf, TargetObjOrPoint) ->
	%% 检查释放者 在场景中的信息 释放正常
	case check_caster(SceneState, CasterType, CasterId) of
		{ok, CasterState} ->
			%% 检查目标 在场景中的信息  释放正常
			case check_target(SceneState, CasterState, SkillConf, TargetObjOrPoint) of
				{ok, TargetList, TargetFlag, TargetPoint} ->
					{ok, CasterState, TargetList, TargetFlag, TargetPoint};
				{fail, Err} ->
					{fail, Err}
			end;
		{fail, Err} ->
			{fail, Err}
	end.
%% 检查场景对象的信息 释放正常
check_caster(SceneState, CasterType, CasterId) ->
	case scene_base_lib:get_scene_obj_state(SceneState, CasterType, CasterId) of
		#scene_obj_state{cur_hp = CurHp} = CasterState when CurHp > 0 ->
			{ok, CasterState};
		_ ->
			{fail, 1}
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
					Range = SkillConf#skill_conf.range,
					RangeFlag = element(1, Range),
					case RangeFlag of
						?SKILL_RANGE_SINGLE ->
							{ok, [TargetState], {TargetType, TargetId}, {TargetX, TargetY}};
						_ ->
							TargetList = scene_base_lib:get_screen_obj_by_point(SceneState, {TargetX, TargetY}, [], ?BIONT_TYPE),
							{ok, TargetList, {TargetType, TargetId}, {TargetX, TargetY}}
					end;
				_ ->
					{fail, 4}
			end;
		_ ->
			{fail, 2}
	end;
check_target(SceneState, CasterState, SkillConf, {point, TargetX, TargetY}) ->
	CasterX = CasterState#scene_obj_state.x,
	CasterY = CasterState#scene_obj_state.y,
	case check_spell_distance(SkillConf, {CasterX, CasterY}, {TargetX, TargetY}) of
		true ->
			TargetList = scene_base_lib:get_screen_obj_by_point(SceneState, {TargetX, TargetY}, [], ?BIONT_TYPE),
			{ok, TargetList, {0, 0}, {TargetX, TargetY}};
		_ ->
			{fail, 4}
	end.

%% 检查施法距离
check_spell_distance(SkillConf, {CasterX, CasterY}, {TargetX, TargetY}) ->
	Distance = util_math:get_distance_set({CasterX, CasterY}, {TargetX, TargetY}),
	Temp = SkillConf#skill_conf.spell_distance + ?MIN_SPELL_DISTANCE_AMEND,
	Distance =< Temp * Temp orelse
		SkillConf#skill_conf.target == ?SKILL_TARGET_MYSELF orelse
		SkillConf#skill_conf.hit =:= 1.

%% 同步到玩家进程
sync_to_obj_mod(SceneState, ObjDict, SkillEffect, CasterState) ->
	%% 同步伤害
	SceneState1 = sync_harm(SceneState, ObjDict, SkillEffect#skill_effect.harm_list, CasterState),
	%% 同步回血
	SceneState2 = sync_cure(SceneState1, ObjDict, SkillEffect#skill_effect.cure_list, CasterState),
	%% 同步buff
	SceneState3 = sync_buff(SceneState2, ObjDict, SkillEffect#skill_effect.buff_list, CasterState),
	%% 同步位置
	SceneState4 = sync_location(SceneState3, ObjDict, SkillEffect#skill_effect.move_list ++ SkillEffect#skill_effect.knockback_list, CasterState),
	SceneState4.

%% 同步伤害
sync_harm(SceneState, ObjDict, HarmList, TempCasterState) ->
	%% 找到正在击杀玩家人
	CasterState =
		case TempCasterState#scene_obj_state.obj_type of
			?OBJ_TYPE_PET ->
				case scene_base_lib:get_scene_obj_state(SceneState, TempCasterState#scene_obj_state.owner_type, TempCasterState#scene_obj_state.owner_id) of
					#scene_obj_state{} = _Obj ->
						_Obj;
					_ ->
						TempCasterState
				end;
			_ ->
				TempCasterState
		end,

	SceneId = SceneState#scene_state.scene_id,
	SceneConf = scene_config:get(SceneId),
	F = fun(HarmProto, Acc) ->
		{HarmPlayerNum, KillPlayerNum, _SceneState} = Acc,
		#proto_obj_flag{
			type = ObjType,
			id = ObjId
		} = HarmProto#proto_harm.obj_flag,

		CurHp = HarmProto#proto_harm.cur_hp,
		case dict:find({ObjType, ObjId}, ObjDict) of
			{ok, ObjState} ->
				%% 判断是否是在副本，触发副本对象伤害事件
				_SceneState2 =
					case SceneConf#scene_conf.type of
						?SCENE_TYPE_INSTANCE ->
							HarmValue = HarmProto#proto_harm.harm_value,
							{ok, _SceneState1} = instance_base_lib:on_obj_harm(_SceneState, ObjState, CasterState, HarmValue),
							_SceneState1;
						_ ->
							_SceneState
					end,

				%% 判断受击者是否是玩家
				case ObjType of
					?OBJ_TYPE_PLAYER ->
						case util_data:is_null(ObjState#scene_obj_state.kill_targer) of
							true ->
								gen_server2:cast(ObjState#scene_obj_state.obj_pid, {on_harm, HarmProto, CasterState, false});
							_ ->
								KillTarger = ObjState#scene_obj_state.kill_targer,
								TCasterState = scene_base_lib:get_scene_obj_state(SceneState, KillTarger#combat_obj.obj_type, KillTarger#combat_obj.obj_id),
								gen_server2:cast(ObjState#scene_obj_state.obj_pid, {on_harm, HarmProto, TCasterState, true})
						end,
						%% 通知玩家受伤事件
						ObjNameColour = ObjState#scene_obj_state.name_colour,
						%% 通知玩家击杀事件
						case is_record(CasterState, scene_obj_state) of
							true ->
								case CurHp =< 0 of
									true ->
										case CasterState#scene_obj_state.obj_type == ?OBJ_TYPE_PLAYER andalso
											is_record(CasterState, scene_obj_state) of
											true ->
												guild_challenge_lib:kill_player(SceneState, CasterState, ObjState),
												gen_server2:cast(CasterState#scene_obj_state.obj_pid, {kill_player, ObjState});
											false ->
												skip
										end;
									false ->
										skip
								end,
								%% 判断受击玩家是否为犯法玩家（红名或者灰名为犯法玩家）
								GuildIdA = CasterState#scene_obj_state.guild_id,
								GuildIdB = ObjState#scene_obj_state.guild_id,
								case player_lib:is_outlaw(ObjNameColour)
									orelse guild_challenge_lib:is_challenge(GuildIdA, GuildIdB)
									orelse ObjState#scene_obj_state.obj_id == CasterState#scene_obj_state.obj_id of
									true ->
										%% 如果是，不需要添加伤害玩家数量
										{HarmPlayerNum, KillPlayerNum, _SceneState2};
									_ ->
										KillPlayerNum1 =
											case CurHp =< 0 of
												true ->
													KillPlayerNum + 1;
												_ ->
													KillPlayerNum
											end,
										%% 否则添加伤害玩家数量或者击杀玩家数量
										{HarmPlayerNum + 1, KillPlayerNum1, _SceneState2}
								end;
							false ->
								case player_lib:is_outlaw(ObjNameColour) of
									true ->
										%% 如果是，不需要添加伤害玩家数量
										{HarmPlayerNum, KillPlayerNum, _SceneState2};
									_ ->
										KillPlayerNum1 =
											case CurHp =< 0 of
												true ->
													KillPlayerNum + 1;
												_ ->
													KillPlayerNum
											end,
										%% 否则添加伤害玩家数量或者击杀玩家数量
										{HarmPlayerNum + 1, KillPlayerNum1, _SceneState2}
								end
						end;
					?OBJ_TYPE_PET ->
						%% 触发AI受伤时间
						{_SceneState3, _} = game_obj_lib:on_harm(_SceneState2, ObjState, HarmProto, CasterState),
						%% 有伤害到玩家宠物也必须添加伤害计数
						{HarmPlayerNum, KillPlayerNum, _SceneState3};
					_ ->
						%% 触发AI受伤时间
						{_SceneState3, _} = game_obj_lib:on_harm(_SceneState2, ObjState, HarmProto, TempCasterState),
						{HarmPlayerNum, KillPlayerNum, _SceneState3}
				end;
			_ ->
				{HarmPlayerNum, KillPlayerNum, _SceneState}
		end
	end,
	{HarmPlayerNum, KillPlayerNum, SceneState1} = lists:foldl(F, {0, 0, SceneState}, HarmList),

	case is_record(CasterState, scene_obj_state) andalso SceneConf#scene_conf.add_pk_value > 0
		andalso (HarmPlayerNum > 0 orelse KillPlayerNum > 0) of
		true ->
			%% 如果技能有伤害到其他的玩家或者宠物，添加pk值
			AddPkValue = SceneConf#scene_conf.add_pk_value * KillPlayerNum,
			case CasterState#scene_obj_state.obj_type of
				?OBJ_TYPE_PET ->
					gen_server2:cast(CasterState#scene_obj_state.owner_pid, {harm_player, AddPkValue});
				_ ->
					gen_server2:cast(CasterState#scene_obj_state.obj_pid, {harm_player, AddPkValue})
			end;
		_ ->
			skip
	end,
	SceneState1.

%% 同步回血
sync_cure(SceneState, ObjDict, CureList, CasterState) ->
	F = fun(CureProto, Acc) ->
		#proto_obj_flag{
			type = ObjType,
			id = ObjId
		} = CureProto#proto_cure.obj_flag,
		case dict:find({ObjType, ObjId}, ObjDict) of
			{ok, ObjState} ->
				case ObjType of
					?OBJ_TYPE_PLAYER ->
						gen_server2:cast(ObjState#scene_obj_state.obj_pid, {on_cure, CureProto, CasterState}),
						Acc;
					_ ->
						{NewAcc, _} = game_obj_lib:on_cure(Acc, ObjState, CureProto, CasterState),
						NewAcc
				end;
			_ ->
				Acc
		end
	end,
	lists:foldl(F, SceneState, CureList).

%% 同步buff
sync_buff(SceneState, ObjDict, BuffList, CasterState) ->
	F = fun(BuffProto, Acc) ->
		#proto_obj_flag{
			type = ObjType,
			id = ObjId
		} = BuffProto#proto_buff_operate.obj_flag,

		#proto_buff_operate{
			operate = Operate,
			effect_id = EffectId
		} = BuffProto,
		case dict:find({ObjType, ObjId}, ObjDict) of
			{ok, ObjState} ->
				#scene_obj_state{
					buff_dict = BuffDict,
					effect_dict = EffectDict,
					effect_src_dict = EffectSrcDict
				} = ObjState,
				Update = {BuffDict, EffectDict, EffectSrcDict},
				case ObjType of
					?OBJ_TYPE_PLAYER ->
						gen_server2:cast(ObjState#scene_obj_state.obj_pid, {buff_update, Update, CasterState}),
						ObjNameColour = ObjState#scene_obj_state.name_colour,
						case (Operate =:= ?BUFF_OPERATE_ADD orelse Operate =:= ?BUFF_OPERATE_UPDATE) andalso
							EffectId =:= ?BUFF_EFFECT_POISON andalso not player_lib:is_outlaw(ObjNameColour) of
							true ->
								Acc + 1;
							_ ->
								Acc
						end;
					_ ->
						Acc
				end;
			_ ->
				Acc
		end
	end,
	HarmPlayerNum = lists:foldl(F, 0, BuffList),
	SceneId = SceneState#scene_state.scene_id,
	SceneConf = scene_config:get(SceneId),
	case SceneConf#scene_conf.add_pk_value > 0 andalso HarmPlayerNum > 0 of
		true ->
			gen_server2:cast(CasterState#scene_obj_state.obj_pid, {harm_player, 0});
		_ ->
			skip
	end,
	SceneState.

%% 同步位置变更
sync_location(SceneState, ObjDict, List, CasterState) ->
	F = fun(Proto, Acc) ->
		#proto_obj_flag{
			type = ObjType,
			id = ObjId
		} = Proto#proto_point_change.obj_flag,
		case dict:find({ObjType, ObjId}, ObjDict) of
			{ok, ObjState} ->
				if
					ObjType == ?OBJ_TYPE_MONSTER orelse ObjType == ?OBJ_TYPE_PET ->
						{Acc1, _} = game_obj_lib:on_knockback(SceneState, ObjState, CasterState, Proto),
						Acc1;
					true ->
						Acc
				end;
			_ ->
				Acc
		end
	end,
	lists:foldl(F, SceneState, List).

%% 生成火墙
make_fire_wall(SceneState, CasterState, Percent, EffectiveTime, Interval, {X, Y}) ->
	%% 一个火墙技能会在5个点生成火墙
	PointList = [{X, Y}, {X + 1, Y}, {X, Y + 1}, {X - 1, Y}, {X, Y - 1}],
	make_fire_wall1(PointList, SceneState, CasterState, Percent, EffectiveTime, Interval).

make_fire_wall1([], SceneState, _CasterState, _AddPercent, _EffectiveTime, _Interval) ->
	SceneState;
make_fire_wall1([{X, Y} | T], SceneState, CasterState, Percent, EffectiveTime, Interval) ->
	case get_obj_from_fire_wall_point(SceneState, {X, Y}) of
		#fire_wall_state{} = _ ->
			%% 如果坐标点原本就有火墙存在，直接忽略
			make_fire_wall1(T, SceneState, CasterState, Percent, EffectiveTime, Interval);
		_ ->
			%% 如果没有火墙，生成火墙
			CurTime = util_date:unixtime(),
			Attr = CasterState#scene_obj_state.attr_total,
			Uid = SceneState#scene_state.fire_wall_cur_uid + util_rand:rand(1, 10),
			AreaId = area_lib:get_area_id({X, Y}, SceneState#scene_state.width, SceneState#scene_state.high),
			State = #fire_wall_state{
				uid = Uid,
				owner_id = CasterState#scene_obj_state.obj_id,
				pk_mode = CasterState#scene_obj_state.pk_mode,
				x = X,
				y = Y,
				area_id = AreaId,
				min_att = util_math:floor(Attr#attr_base.min_mac * Percent / ?PERCENT_BASE),
				max_att = util_math:floor(Attr#attr_base.max_mac * Percent / ?PERCENT_BASE),
				interval = Interval,
				next_time = CurTime,
				remove_time = CurTime + EffectiveTime,
				guild_id = CasterState#scene_obj_state.guild_id,
				team_id = CasterState#scene_obj_state.team_id
			},
			NewSceneState = add_fire_wall_state(SceneState, State),

			ScreenObjList = scene_base_lib:get_screen_obj_by_point(NewSceneState, {X, Y}, [{?OBJ_TYPE_FIRE_WALL, Uid}], ?BIONT_TYPE),
			ObjState = #scene_obj_state{
				obj_type = ?OBJ_TYPE_FIRE_WALL,
				obj_id = Uid,
				x = X,
				y = Y
			},
			?INFO("TTTSSS666 ~p ", [11]),
			%% 通知前端火墙生成
			scene_send_lib:send_enter_screen(ScreenObjList, ObjState, false),

			make_fire_wall1(T, NewSceneState#scene_state{fire_wall_cur_uid = Uid}, CasterState, Percent, EffectiveTime, Interval)
	end.

%% 通过坐标点获取火墙对象
get_obj_from_fire_wall_point(SceneState, Point) ->
	FireWallPointDict = SceneState#scene_state.fire_wall_point_dict,
	case dict:find(Point, FireWallPointDict) of
		{ok, Uid} ->
			get_fire_wall_state(SceneState, Uid);
		_ ->
			null
	end.

%% 添加火墙映射到对应的坐标点
add_obj_to_fire_wall_point(SceneState, Point, Uid) ->
	FireWallPointDict = SceneState#scene_state.fire_wall_point_dict,
	NewFireWallPointDict = dict:store(Point, Uid, FireWallPointDict),
	SceneState#scene_state{fire_wall_point_dict = NewFireWallPointDict}.

%% 删除火墙坐标点映射
delete_obj_from_fire_wall_point(SceneState, Point) ->
	FireWallPointDict = SceneState#scene_state.fire_wall_point_dict,
	NewFireWallPointDict = dict:erase(Point, FireWallPointDict),
	SceneState#scene_state{fire_wall_point_dict = NewFireWallPointDict}.

%% 通过火墙唯一id获取火墙对象
get_fire_wall_state(SceneState, FireWallUid) ->
	FireWallDict = SceneState#scene_state.fire_wall_dict,
	CurTime = util_date:unixtime(),
	case dict:find(FireWallUid, FireWallDict) of
		{ok, FireWallState} when FireWallState#fire_wall_state.remove_time > CurTime ->
			FireWallState;
		_ ->
			null
	end.

%% 添加火墙对象进场景
add_fire_wall_state(SceneState, FireWallState) ->
	#fire_wall_state{
		uid = Uid,
		x = X,
		y = Y,
		area_id = AreaId
	} = FireWallState,

	NewState1 =
		case get_fire_wall_state(SceneState, Uid) of
			#fire_wall_state{} = _OldFireWallState ->
				SceneState;
			_ ->
				SceneState1 = scene_base_lib:add_obj_to_area(SceneState, AreaId, ?OBJ_TYPE_FIRE_WALL, Uid),
				add_obj_to_fire_wall_point(SceneState1, {X, Y}, Uid)
		end,

	FireWallDict = dict:store(Uid, FireWallState, NewState1#scene_state.fire_wall_dict),
	NewState1#scene_state{fire_wall_dict = FireWallDict}.

%% 更新火墙对象
update_fire_wall_state(SceneState, FireWallState) ->
	FireWallDict = dict:store(FireWallState#fire_wall_state.uid, FireWallState, SceneState#scene_state.fire_wall_dict),
	SceneState#scene_state{fire_wall_dict = FireWallDict}.

%% 删除火墙对象
delete_fire_wall_state(SceneState, FireWallState) ->
	#fire_wall_state{
		uid = Uid,
		x = X,
		y = Y,
		area_id = AreaId
	} = FireWallState,

	SceneState1 = scene_base_lib:delete_obj_from_area(SceneState, AreaId, ?OBJ_TYPE_FIRE_WALL, Uid),
	SceneState2 = delete_obj_from_fire_wall_point(SceneState1, {X, Y}),

	FireWallDict = dict:erase(Uid, SceneState2#scene_state.fire_wall_dict),

	NewSceneState = SceneState2#scene_state{fire_wall_dict = FireWallDict},
	ObjList = scene_base_lib:get_screen_obj_by_point(NewSceneState, {X, Y}, [], [?OBJ_TYPE_PLAYER]),
	%% 离屏广播
	scene_send_lib:send_leave_screen(ObjList, #scene_obj_state{obj_type = ?OBJ_TYPE_FIRE_WALL, obj_id = Uid}),
	NewSceneState.

%% 生成目标列表（用于发送给前端）
make_target_list(SkillEffect) ->
	#skill_effect{
		harm_list = HarmList,
		cure_list = CureList,
		buff_list = BuffList,
		move_list = MoveList,
		knockback_list = KnockbackList
	} = SkillEffect,

	F1 = fun(Proto, Acc) ->
		ObjFlag = Proto#proto_harm.obj_flag,
		dict:store(ObjFlag, true, Acc)
	end,
	Dict1 = lists:foldl(F1, dict:new(), HarmList),

	F2 = fun(Proto, Acc) ->
		ObjFlag = Proto#proto_cure.obj_flag,
		dict:store(ObjFlag, true, Acc)
	end,
	Dict2 = lists:foldl(F2, Dict1, CureList),

	F3 = fun(Proto, Acc) ->
		ObjFlag = Proto#proto_buff_operate.obj_flag,
		dict:store(ObjFlag, true, Acc)
	end,
	Dict3 = lists:foldl(F3, Dict2, BuffList),

	F4 = fun(Proto, Acc) ->
		ObjFlag = Proto#proto_point_change.obj_flag,
		dict:store(ObjFlag, true, Acc)
	end,
	Dict4 = lists:foldl(F4, Dict3, MoveList ++ KnockbackList),

	F5 = fun(K, _V, Acc) ->
		[K | Acc]
	end,
	dict:fold(F5, [], Dict4).

update_warning_skill_info(CasterState, WSkillId) ->
	CurHp = CasterState#scene_obj_state.cur_hp,
	AttrBase = CasterState#scene_obj_state.attr_total,
	Hp = AttrBase#attr_base.hp,
	HpPercent = util_math:floor((CurHp / Hp) * ?PERCENT_BASE),
	SkillRule = CasterState#scene_obj_state.skill_rule,
	NewSkillList = get_waring_skill_list(SkillRule, HpPercent, WSkillId),
	case length(NewSkillList) > 0 of
		true ->
			{Time1, WaringId, Time2, WaringSkill} = lists:nth(1, NewSkillList),
			NowTime = util_date:unixtime(),
			WaringInfo = {NowTime + Time1, WaringId},
			WaringSkillInfo = {NowTime + Time2, WaringSkill},
			CasterState#scene_obj_state{warning_info = WaringInfo, warning_skill_info = WaringSkillInfo};
		false ->
			CasterState
	end.

get_waring_skill_list([{MinP, MaxP, _WaringId, WaringList, _SkillList} | T], HpPercent, WSkillId) ->
	%% 根据当前对象的血量百分百来选择应该释放的技能
	case MinP =< HpPercent andalso HpPercent =< MaxP of
		true ->
			get_new_order_skill_list(WaringList, WSkillId, []);
		_ ->
			get_waring_skill_list(T, HpPercent, WSkillId)
	end;
get_waring_skill_list(_, _HpPercent, _WSkillId) ->
	[].

%% 获取技能新的触发排序
get_new_order_skill_list([], _LastSkill, NewSkillList) ->
	NewSkillList;
get_new_order_skill_list([{Time1, W, Time2, SkillId} | T], LastSkill, NewSkillList) ->
	case SkillId == LastSkill of
		true ->
			T ++ NewSkillList ++ [{Time1, W, Time2, SkillId}];
		false ->
			get_new_order_skill_list(T, LastSkill, NewSkillList ++ [{Time1, W, Time2, SkillId}])
	end.

