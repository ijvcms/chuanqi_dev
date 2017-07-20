%%%-------------------------------------------------------------------
%%% @author zhengsiying
%%% @copyright (C) 2015, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 12. 八月 2015 下午3:38
%%%-------------------------------------------------------------------
-module(skill_rule_lib).

-include("common.hrl").
-include("record.hrl").
-include("config.hrl").
-include("cache.hrl").

%% API
-export([
	get_legal_target_list/6,
	spell_effect/3,
	spell_effect/5,
	to_combat_obj/1,
	check_passive_skill_trigger_effect/1,
	check_target/3
]).

%% ====================================================================
%% API functions
%% ====================================================================
%% 判断技能是否是空放
is_null_target(SkillConf, MainTargerId, MainTargerType) ->
	case SkillConf#skill_conf.range of
		{?SKILL_RANGE_SINGLE, 1} ->
			{MainTargerId, MainTargerType} =:= {0, 0};
		_ ->
			false
	end.

%% 获取真实的技能影响对象（只用于正常arpg技能判断，不用与挂机）
get_legal_target_list(CasterState, SkillInfo, TargetList, SceneId, MainTargerId, MainTargerType) when is_record(CasterState, scene_obj_state) ->
	SkillConf = SkillInfo#spell_skill_info.skill_conf,
	Range = SkillConf#skill_conf.range,
	TargetType = SkillConf#skill_conf.target,
	TargetPoint = SkillInfo#spell_skill_info.target_point,
	case TargetType of
		?SKILL_TARGET_MYSELF ->
			[CasterState];
		?SKILL_TARGET_FRIENDLY ->
			case is_null_target(SkillConf, MainTargerId, MainTargerType) of
				true ->
					[];
				_ ->
					F = fun(TargetState) ->
						check_target(TargetType, CasterState, TargetState) andalso
							check_range(Range, TargetPoint, CasterState, TargetState, MainTargerId, MainTargerType)
						end,
					lists:filter(F, TargetList)
			end;
		_ ->
			case area_lib:is_in_safety_area(SceneId, {CasterState#scene_obj_state.x, CasterState#scene_obj_state.y}) orelse
				is_null_target(SkillConf, MainTargerId, MainTargerType) of
				true ->
					[];
				_ ->
					F = fun(TargetState) ->
						#scene_obj_state{
							x = X,
							y = Y
						} = TargetState,
						%% 判断目标是否在安全区
						not area_lib:is_in_safety_area(SceneId, {X, Y}) andalso
							%% 是否友方目标
							check_target(TargetType, CasterState, TargetState) andalso
							%% 计算距离
							check_range(Range, TargetPoint, CasterState, TargetState, MainTargerId, MainTargerType)
					end,
					lists:filter(F, TargetList)
			end
	end.

%% 触发技能效果，每个技能都有一个技能效果列表（可以用于挂机和普通arpg）
spell_effect(CasterState, SkillConf, TargetList) ->
	spell_effect(CasterState, SkillConf, TargetList, 0, null).
spell_effect(CasterState, SkillConf, TargetList, SceneId, TargetPoint) ->
	EffectList = SkillConf#skill_conf.effect_list,
	%% 先将对象都转换成战斗对象
	CasterState1 = to_combat_obj(CasterState),
	TargetList1 = [to_combat_obj(Target) || Target <- TargetList],

	F = fun(Effect, Acc) ->
		%% 触发技能里的单一效果
		ResultList = spell_effect1(Effect, CasterState1, TargetList1, SceneId, TargetPoint, SkillConf),
		ResultList ++ Acc
	end,
	lists:foldl(F, [], EffectList).

%% 转换函数
to_combat_obj(PlayerState) when is_record(PlayerState, player_state) ->
	PlayerBase = PlayerState#player_state.db_player_base,
	PlayerAttr = PlayerState#player_state.db_player_attr,
	#combat_obj{
		obj_id = PlayerState#player_state.player_id,
		obj_type = ?OBJ_TYPE_PLAYER,
		career = PlayerBase#db_player_base.career,
		lv = PlayerBase#db_player_base.lv,
		cur_hp = PlayerAttr#db_player_attr.cur_hp,
		cur_mp = PlayerAttr#db_player_attr.cur_mp,
		buff_dict = PlayerState#player_state.buff_dict,
		effect_dict = PlayerState#player_state.effect_dict,
		effect_src_dict = PlayerState#player_state.effect_src_dict,
		attr_base = PlayerState#player_state.attr_base,
		attr_total = PlayerState#player_state.attr_total,
		pass_trigger_skill_list = PlayerState#player_state.pass_trigger_skill_list,
		monster_id = null,
		pet_dict = PlayerState#player_state.pet_dict
	};
to_combat_obj(SceneObjState) when is_record(SceneObjState, scene_obj_state) ->
	#combat_obj{
		obj_id = SceneObjState#scene_obj_state.obj_id,
		obj_type = SceneObjState#scene_obj_state.obj_type,
		career = SceneObjState#scene_obj_state.career,
		lv = SceneObjState#scene_obj_state.lv,
		cur_hp = SceneObjState#scene_obj_state.cur_hp,
		cur_mp = SceneObjState#scene_obj_state.cur_mp,
		buff_dict = SceneObjState#scene_obj_state.buff_dict,
		effect_dict = SceneObjState#scene_obj_state.effect_dict,
		effect_src_dict = SceneObjState#scene_obj_state.effect_src_dict,
		attr_base = SceneObjState#scene_obj_state.attr_base,
		attr_total = SceneObjState#scene_obj_state.attr_total,
		x = SceneObjState#scene_obj_state.x,
		y = SceneObjState#scene_obj_state.y,
		pass_trigger_skill_list = SceneObjState#scene_obj_state.pass_trigger_skill_list,
		monster_id = SceneObjState#scene_obj_state.monster_id,
		pet_dict = SceneObjState#scene_obj_state.pet_dict
	};
to_combat_obj(HookObjState) when is_record(HookObjState, hook_obj_state) ->
	#combat_obj{
		obj_id = HookObjState#hook_obj_state.obj_id,
		obj_type = HookObjState#hook_obj_state.obj_type,
		career = HookObjState#hook_obj_state.career,
		lv = HookObjState#hook_obj_state.lv,
		cur_hp = HookObjState#hook_obj_state.cur_hp,
		cur_mp = HookObjState#hook_obj_state.cur_mp,
		buff_dict = HookObjState#hook_obj_state.buff_dict,
		effect_dict = HookObjState#hook_obj_state.effect_dict,
		effect_src_dict = HookObjState#hook_obj_state.effect_src_dict,
		attr_base = HookObjState#hook_obj_state.attr_base,
		attr_total = HookObjState#hook_obj_state.attr_total,
		pass_trigger_skill_list = HookObjState#hook_obj_state.pass_trigger_skill_list,
		monster_id = HookObjState#hook_obj_state.monster_id,
		pet_dict = dict:new()
	};
to_combat_obj(ObjState) ->
	ObjState.

%% ====================================================================
%% Internal functions
%% ====================================================================

%% ====================================================================
%% 需要添加的规则部分
%% ====================================================================
%% 根据技能目标类型检查目标是否合法
%% 检查是否是友方技能的目标
check_target(?SKILL_TARGET_FRIENDLY, CasterState, TargetState) ->
	case CasterState#scene_obj_state.obj_type of
		?OBJ_TYPE_MONSTER ->
			%% 如果施法者是怪物，友方只有怪物(龙柱除外)
			is_monster_by_monster(TargetState);
		_ ->
			%% 如果施法者是其他对象，需要判断施法者的pk模式
			case CasterState#scene_obj_state.pk_mode of
				?PK_MODE_PEACE ->
					%% 如果pk模式是和平模式，友方是非怪物和特殊怪
					TargetState#scene_obj_state.obj_type /= ?OBJ_TYPE_MONSTER orelse is_spec_monster_by_player(TargetState);
				?PK_MODE_FOE ->
					%% 如果pk模式是仇人模式，友方是非怪物，非仇人
					is_foe(CasterState, TargetState) =:= false orelse is_spec_monster_by_player(TargetState);
				?PK_MODE_ALL ->
					%% 如果pk模式是全体模式，友方只有自己和宠物
					is_same_obj(CasterState, TargetState) orelse is_ownership(CasterState, TargetState) orelse is_spec_monster_by_player(TargetState);
				?PK_MODE_TEAM ->
					%% 如果pk模式是队伍模式，友方是自己、宠物以及同一个队伍的玩家和宠物
					is_same_obj(CasterState, TargetState) orelse is_same_team(CasterState, TargetState) orelse is_ownership(CasterState, TargetState) orelse is_spec_monster_by_player(TargetState);
				?PK_MODE_GUILD ->
					%% 如果pk模式是帮派模式，友方是自己、宠物以及同一个帮派的玩家和宠物
					is_same_obj(CasterState, TargetState) orelse is_same_guild(CasterState, TargetState) orelse is_ownership(CasterState, TargetState) orelse is_spec_monster_by_player(TargetState);
				?PK_MODE_ALLIANCE ->
					%% 如果pk模式是帮派模式，友方是自己、宠物以及同一个帮派的玩家和宠物
					is_same_obj(CasterState, TargetState) orelse is_same_guild(CasterState, TargetState) orelse is_same_alliance(CasterState, TargetState) orelse is_ownership(CasterState, TargetState) orelse is_spec_monster_by_player(TargetState);
				?PK_MODE_LEGION ->
					%% 如果pk模式是帮派模式，友方是自己、宠物以及同一个帮派的玩家和宠物
					is_same_obj(CasterState, TargetState) orelse is_same_legion(CasterState, TargetState) orelse is_ownership(CasterState, TargetState) orelse is_spec_monster_by_player(TargetState);
				?PK_MODE_JUSTICE ->
					%% 如果pk模式是善恶模式，友方是自己、宠物以及非红名和灰名的玩家
					case TargetState#scene_obj_state.obj_type /= ?OBJ_TYPE_MONSTER of
						true ->
							TNameColour = TargetState#scene_obj_state.name_colour,
							is_same_obj(CasterState, TargetState) orelse is_ownership(CasterState, TargetState) orelse not player_lib:is_outlaw(TNameColour) orelse is_spec_monster_by_player(TargetState);
						_ ->
							false
					end;
				?PK_MODE_NOOB ->
					%% 如果pk模式新手模式，友方是非怪物
					TargetState#scene_obj_state.obj_type /= ?OBJ_TYPE_MONSTER orelse TargetState#scene_obj_state.attack_type == ?ATTACK_TYPE_STATIC_2;
				_ ->
					is_same_obj(CasterState, TargetState)
			end
	end;
%% 检查是否是敌方技能的目标
check_target(?SKILL_TARGET_HOSTILE, CasterState, TargetState) ->
	not check_target(?SKILL_TARGET_FRIENDLY, CasterState, TargetState) andalso TargetState#scene_obj_state.cur_hp > 0.

%% 是否是同一个对象
is_same_obj(CasterState, TargetState) ->
	#scene_obj_state{
		obj_type = CasterType,
		obj_id = CasterId
	} = CasterState,
	#scene_obj_state{
		obj_type = TargetType,
		obj_id = TargetId,
		pk_mode = PkMode
	} = TargetState,
	(CasterType =:= TargetType andalso CasterId =:= TargetId) orelse PkMode == ?PK_MODE_NOOB.

%% 是否是可攻击怪物
is_spec_monster_by_player(TargetState) ->
	TargetState#scene_obj_state.attack_type == ?ATTACK_TYPE_STATIC_2
		orelse
		TargetState#scene_obj_state.obj_type == ?OBJ_TYPE_COLLECT.

is_monster_by_monster(TargetState) ->
	(TargetState#scene_obj_state.obj_type =:= ?OBJ_TYPE_MONSTER orelse
		TargetState#scene_obj_state.obj_type =:= ?OBJ_TYPE_COLLECT orelse
		TargetState#scene_obj_state.obj_type =:= ?OBJ_TYPE_FIRE_WALL orelse
		TargetState#scene_obj_state.obj_type =:= ?OBJ_TYPE_DROP)
		andalso
		TargetState#scene_obj_state.attack_type =/= ?ATTACK_TYPE_STATIC_2.

%% 是否仇人
is_foe(CasterState, TargetState) ->
	case CasterState#scene_obj_state.obj_type of
		?OBJ_TYPE_PLAYER ->
			case TargetState#scene_obj_state.obj_type of
				?OBJ_TYPE_PET ->
					%% 归属着id
					%% 归属type
					OwnerId = TargetState#scene_obj_state.owner_id,
					player_foe_cache:is_foe(CasterState#scene_obj_state.obj_id, OwnerId);
				?OBJ_TYPE_PLAYER ->
					player_foe_cache:is_foe(CasterState#scene_obj_state.obj_id, TargetState#scene_obj_state.obj_id);
				_ ->
					true
			end;
		?OBJ_TYPE_PET ->
			case TargetState#scene_obj_state.obj_type of
				?OBJ_TYPE_PLAYER ->
					#scene_obj_state{
						owner_id = OwnerId
					} = CasterState,
					#scene_obj_state{
						obj_id = ObjId
					} = TargetState,
					player_foe_cache:is_foe(OwnerId, ObjId);
				?OBJ_TYPE_PET ->
					#scene_obj_state{
						owner_id = OwnerId1
					} = CasterState,
					#scene_obj_state{
						owner_id = OwnerId2
					} = TargetState,
					player_foe_cache:is_foe(OwnerId1, OwnerId2);
				_ ->
					true
			end;
		?OBJ_TYPE_FIRE_WALL ->
			case TargetState#scene_obj_state.obj_type of
				?OBJ_TYPE_PLAYER ->
					player_foe_cache:is_foe(CasterState#scene_obj_state.owner_id, TargetState#scene_obj_state.obj_id);
				?OBJ_TYPE_PET ->
					player_foe_cache:is_foe(CasterState#scene_obj_state.owner_id, TargetState#scene_obj_state.owner_id);
				_ ->
					true
			end;
		_ ->
			true
	end.

%% 是否存在归属关系
is_ownership(CasterState, TargetState) ->
	case CasterState#scene_obj_state.obj_type of
		?OBJ_TYPE_PLAYER ->
			case TargetState#scene_obj_state.obj_type of
				?OBJ_TYPE_PET ->
					#scene_obj_state{
						owner_type = OwnerType,
						owner_id = OwnerId
					} = TargetState,
					#scene_obj_state{
						obj_type = ObjType,
						obj_id = ObjId
					} = CasterState,
					{OwnerType, OwnerId} =:= {ObjType, ObjId};
				_ ->
					false
			end;
		?OBJ_TYPE_PET ->
			case TargetState#scene_obj_state.obj_type of
				?OBJ_TYPE_PLAYER ->
					#scene_obj_state{
						owner_type = OwnerType,
						owner_id = OwnerId
					} = CasterState,
					#scene_obj_state{
						obj_type = ObjType,
						obj_id = ObjId
					} = TargetState,
					{OwnerType, OwnerId} =:= {ObjType, ObjId};
				?OBJ_TYPE_PET ->
					#scene_obj_state{
						owner_type = OwnerType1,
						owner_id = OwnerId1
					} = CasterState,
					#scene_obj_state{
						owner_type = OwnerType2,
						owner_id = OwnerId2
					} = TargetState,
					{OwnerType1, OwnerId1} =:= {OwnerType2, OwnerId2};
				_ ->
					false
			end;
		?OBJ_TYPE_FIRE_WALL ->
			case TargetState#scene_obj_state.obj_type of
				?OBJ_TYPE_PLAYER ->
					CasterState#scene_obj_state.owner_id =:= TargetState#scene_obj_state.obj_id;
				?OBJ_TYPE_PET ->
					CasterState#scene_obj_state.owner_id =:= TargetState#scene_obj_state.owner_id;
				_ ->
					false
			end;
		_ ->
			false
	end.

%% 是否在同一个帮派
is_same_guild(CasterState, TargetState) ->
	not util_data:is_null(CasterState#scene_obj_state.guild_id) andalso
		CasterState#scene_obj_state.guild_id /= 0 andalso
		CasterState#scene_obj_state.guild_id =:= TargetState#scene_obj_state.guild_id.
%% 是否在同一个军团
is_same_legion(CasterState, TargetState) ->
	not util_data:is_null(CasterState#scene_obj_state.legion_id) andalso
		CasterState#scene_obj_state.legion_id /= 0 andalso
		CasterState#scene_obj_state.legion_id =:= TargetState#scene_obj_state.legion_id.
%% 是否在同一个队伍
is_same_team(CasterState, TargetState) ->
	not util_data:is_null(CasterState#scene_obj_state.team_id) andalso
		CasterState#scene_obj_state.team_id /= 0 andalso
		CasterState#scene_obj_state.team_id =:= TargetState#scene_obj_state.team_id.
%%是否同盟
is_same_alliance(CasterState, TargetState) ->
	alliance_lib:is_guild_alliance(CasterState#scene_obj_state.guild_id, TargetState#scene_obj_state.guild_id).

%% 检查技能范围
%% 单体攻击的距离直接就是施法距离，在进入这里之前已经对施法距离的合法性进行判断
check_range({?SKILL_RANGE_SINGLE, IsNeedTarget}, _TargetPoint, _CasterState, TargetState, MainTargerId, MainTargerType) ->
	case IsNeedTarget =:= 1 of
		true ->
			#scene_obj_state{
				obj_id = TargetId,
				obj_type = TargetType
			} = TargetState,
			{TargetId, TargetType} =:= {MainTargerId, MainTargerType};
		_ ->
			true
	end;
%% 普通群体技能
check_range({?SKILL_RANGE_RANG, Num}, {TargetX, TargetY}, _CasterState, TargetState, _MainTargerId, _MainTargerType) ->
	X1 = TargetX - Num,
	Y1 = TargetY - Num,
	X2 = TargetX + Num,
	Y2 = TargetY + Num,
	X = TargetState#scene_obj_state.x,
	Y = TargetState#scene_obj_state.y,
	area_lib:is_in_area({X, Y}, {?AREA_TYPE_RECTANGLE, {X1, Y1}, {X2, Y2}});
%% 以自己为圆心的群体技能
check_range({?SKILL_RANGE_CIRCLE, Num}, _TargetPoint, CasterState, TargetState, _MainTargerId, _MainTargerType) ->
	X = TargetState#scene_obj_state.x,
	Y = TargetState#scene_obj_state.y,
	CX = CasterState#scene_obj_state.x,
	CY = CasterState#scene_obj_state.y,
	case Num >= 5 of
		true ->
			area_lib:is_in_area({X, Y}, {?AREA_TYPE_CIRCLE, {CX, CY}, Num});
		_ ->
			X1 = CX - Num,
			Y1 = CY - Num,
			X2 = CX + Num,
			Y2 = CY + Num,
			area_lib:is_in_area({X, Y}, {?AREA_TYPE_RECTANGLE, {X1, Y1}, {X2, Y2}})
	end;
%% 线性技能
check_range({?SKILL_RANGE_LINE, Num}, {TargetX, TargetY}, CasterState, TargetState, _MainTargerId, _MainTargerType) ->
	X = TargetState#scene_obj_state.x,
	Y = TargetState#scene_obj_state.y,
	CX = CasterState#scene_obj_state.x,
	CY = CasterState#scene_obj_state.y,
	area_lib:is_in_area({X, Y}, {?AREA_TYPE_LINE, {CX, CY}, {TargetX, TargetY}, Num}).

%% 触发技能效果
%% 回血（瞬间回血）
spell_effect1({cure, AddPercent}, CasterState, TargetList, _SceneId, _TargetPoint, _SkillConf) ->
	AttrTotal = CasterState#combat_obj.attr_total,
	Att = util_rand:rand(AttrTotal#attr_base.min_sc, AttrTotal#attr_base.max_sc),
	AddHp = util_math:ceil(AddPercent / ?PERCENT_BASE * Att),
	[#skill_result{
		skill_cmd = ?SKILL_CMD_CURE,
		obj_type = TargetState#combat_obj.obj_type,
		obj_id = TargetState#combat_obj.obj_id,
		result = AddHp
	} || TargetState <- TargetList];
%% 伤害
spell_effect1({dm, AddPercent, Append}, CasterState, TargetList, _SceneId, _TargetPoint, SkillConf) ->
	SkillHarm = #skill_harm{add_percent = AddPercent, append = Append},
	List = lists:append([combat_lib:compute_harm(CasterState, TargetState, SkillHarm) || TargetState <- TargetList]),
	%% 判断攻击的技能是不是烈火，如果是烈火那么移除buff，如果不是那么就不移除烈火buff
	List1 = case SkillConf#skill_conf.skill_id of
				?SPECIAL_SKILL_ID_FIRE_1 ->
					%% 获取烈火的buff信息
					case get_buff_fire(CasterState) of
						#buff_effect{effect_p = P, effect_v = V} when P > 0 orelse V > 0 ->
							Data = #skill_result{
								skill_cmd = ?SKILL_CMD_REMOVE_EFFECT,
								obj_type = CasterState#combat_obj.obj_type,
								obj_id = CasterState#combat_obj.obj_id,
								result = ?BUFF_EFFECT_FIRE
							},
							[Data | List];
						_ ->
							List
					end;
				_ ->
					List
			end,
	PassList = CasterState#combat_obj.pass_trigger_skill_list,
	List2 = check_atk_type_pass_skill(CasterState, TargetList, List, PassList, []),
	List3 = check_pass_skill_hp_suck(CasterState, TargetList, List),
	List3 ++ List2 ++ List1;
%% 穿刺伤害（无视魔法盾效果的伤害）
spell_effect1({impale_dm, AddPercent, Append}, CasterState, TargetList, _SceneId, _TargetPoint, _SkillConf) ->
	SkillHarm = #skill_harm{add_percent = AddPercent, append = Append},
	List = lists:append([combat_lib:compute_harm(CasterState, TargetState, SkillHarm, false, true) || TargetState <- TargetList]),
	PassList = CasterState#combat_obj.pass_trigger_skill_list,
	List1 = check_atk_type_pass_skill(CasterState, TargetList, List, PassList, []),
	List2 = check_pass_skill_hp_suck(CasterState, TargetList, List),
	List2 ++ List1 ++ List;
%% buff（无等级限制型的buff）
spell_effect1({buff, BuffId, Rate}, CasterState, TargetList, _SceneId, _TargetPoint, _SkillConf) ->
	[buff_base_lib:trigger(CasterState, TargetState, BuffId, Rate) || TargetState <- TargetList];
%% buff（有等级限制型的buff）
spell_effect1({buff, BuffId, Rate, LvLimit}, CasterState, TargetList, _SceneId, _TargetPoint, _SkillConf) ->
	[begin
		 case LvLimit =:= 0 orelse CasterState#combat_obj.lv >= TargetState#combat_obj.lv of
			 true ->
				 buff_base_lib:trigger(CasterState, TargetState, BuffId, Rate);
			 _ ->
				 skip
		 end
	 end || TargetState <- TargetList];
%% buff（有等级限制型的buff和同级概率限制）
spell_effect1({buff, BuffId, Rate, LvLimit, SameLvRate}, CasterState, TargetList, _SceneId, _TargetPoint, _SkillConf) ->
	[begin
		 case LvLimit =:= 0 orelse CasterState#combat_obj.lv > TargetState#combat_obj.lv of
			 true ->
				 buff_base_lib:trigger(CasterState, TargetState, BuffId, Rate);
			 _ ->
				 case LvLimit =:= 0 orelse CasterState#combat_obj.lv == TargetState#combat_obj.lv of
					 true ->
						 buff_base_lib:trigger(CasterState, TargetState, BuffId, SameLvRate);
					 false ->
						 skip
				 end
		 end
	 end || TargetState <- TargetList];
%% 召唤宠物
spell_effect1({call_pet, MonsterId, _LvLimit}, CasterState, _TargetList, _SceneId, _TargetPoint, _SkillConf) ->
	[#skill_result{
		skill_cmd = ?SKILL_CMD_CALL_PET,
		obj_type = CasterState#combat_obj.obj_type,
		obj_id = CasterState#combat_obj.obj_id,
		result = MonsterId
	}];
%% 火墙
spell_effect1({fire_wall, Percent, EffectiveTime, Interval}, CasterState, _TargetList, _SceneId, _TargetPoint, _SkillConf) ->
	[#skill_result{
		skill_cmd = ?SKILL_CMD_FIRE_WALL,
		obj_type = CasterState#combat_obj.obj_type,
		obj_id = CasterState#combat_obj.obj_id,
		result = {Percent, EffectiveTime, Interval}
	}];
%% 冲撞并击退
spell_effect1({move_knockback, Dist, LvLimit}, CasterState, TargetList, SceneId, TargetPoint, _SkillConf) ->
	case SceneId /= 0 andalso TargetList /= [] of
		true ->
			[TargetState | _T] = TargetList,
			#combat_obj{
				x = BX,
				y = BY
			} = CasterState,
			#combat_obj{
				x = EX,
				y = EY
			} = TargetState,
			{X, Y} = area_lib:get_line_farthest(SceneId, {BX, BY}, {EX, EY}),
			D = util_math:get_distance_set({EX, EY}, {X, Y}),
			case LvLimit =:= 0 orelse CasterState#combat_obj.lv >= TargetState#combat_obj.lv andalso D =< 2 * 2 andalso
				check_resist_knockback(TargetState) of
				true ->
					KnockbackResult = knockback(CasterState, TargetState, SceneId, Dist),
					[
						#skill_result{
							skill_cmd = ?SKILL_CMD_MOVE,
							obj_type = CasterState#combat_obj.obj_type,
							obj_id = CasterState#combat_obj.obj_id,
							result = {{BX, BY}, {X, Y}}
						},
						KnockbackResult
					];
				_ ->
					[#skill_result{
						skill_cmd = ?SKILL_CMD_MOVE,
						obj_type = CasterState#combat_obj.obj_type,
						obj_id = CasterState#combat_obj.obj_id,
						result = {{BX, BY}, {X, Y}}
					}]
			end;
		_ ->
			BX = CasterState#combat_obj.x,
			BY = CasterState#combat_obj.y,
			{EX, EY} = TargetPoint,
			{X, Y} = area_lib:get_line_farthest(SceneId, {BX, BY}, {EX, EY}),
			[#skill_result{
				skill_cmd = ?SKILL_CMD_MOVE,
				obj_type = CasterState#combat_obj.obj_type,
				obj_id = CasterState#combat_obj.obj_id,
				result = {{BX, BY}, {X, Y}}
			}]
	end;
%% 击退
spell_effect1({knockback, Dist, LvLimit}, CasterState, TargetList, SceneId, _TargetPoint, _SkillConf) ->
	case SceneId /= 0 of
		true ->
			F = fun(TargetState, Acc) ->
				case LvLimit =:= 0 orelse CasterState#combat_obj.lv >= TargetState#combat_obj.lv
					andalso check_resist_back(TargetState) of
					true ->
						KnockbackResult = knockback(CasterState, TargetState, SceneId, Dist),
						[KnockbackResult | Acc];
					_ ->
						Acc
				end
			end,
			lists:foldl(F, [], TargetList);
		_ ->
			[]
	end;
%% 击退(同级击退概率)
spell_effect1({knockback, Dist, LvLimit, SameLvRate}, CasterState, TargetList, SceneId, _TargetPoint, _SkillConf) ->
	case SceneId /= 0 of
		true ->
			F = fun(TargetState, Acc) ->
				case LvLimit =:= 0 orelse CasterState#combat_obj.lv > TargetState#combat_obj.lv andalso check_resist_back(TargetState) of
					true ->
						KnockbackResult = knockback(CasterState, TargetState, SceneId, Dist),
						[KnockbackResult | Acc];
					_ ->
						case LvLimit =:= 0 orelse CasterState#combat_obj.lv == TargetState#combat_obj.lv andalso util_rand:rand_hit(SameLvRate) of
							true ->
								KnockbackResult = knockback(CasterState, TargetState, SceneId, Dist),
								[KnockbackResult | Acc];
							false ->
								Acc
						end
				end
			end,
			lists:foldl(F, [], TargetList);
		_ ->
			[]
	end;
%% 伤害并且吸血
spell_effect1({dm_and_cure, AddPercent, CurePercent}, CasterState, TargetList, _SceneId, _TargetPoint, _SkillConf) ->
	SkillHarm = #skill_harm{add_percent = AddPercent},
	List = lists:append([combat_lib:compute_harm(CasterState, TargetState, SkillHarm) || TargetState <- TargetList]),
	TotalHarm = compute_total_harm_by_target(List),
	{P1, V1} = get_pass_skill_hp_suck_percent(CasterState, TargetList),
	AddHp = util_math:ceil(TotalHarm / ?PERCENT_BASE * (CurePercent + P1)) + V1,
	CureCaster = #skill_result{
		skill_cmd = ?SKILL_CMD_CURE,
		obj_type = CasterState#combat_obj.obj_type,
		obj_id = CasterState#combat_obj.obj_id,
		result = AddHp
	},
	PassList = CasterState#combat_obj.pass_trigger_skill_list,
	List2 = check_atk_type_pass_skill(CasterState, TargetList, List, PassList, []),
	[CureCaster | List] ++ List2;
%% 诱惑
spell_effect1({tempt, Percent, Num, _LvLimit}, CasterState, TargetList, _SceneId, _TargetPoint, SkillConf) ->
	case TargetList /= [] of
		true ->
			[TargetState | _T] = TargetList,
			#combat_obj{
				obj_type = TargetType,
				obj_id = TargetId,
				monster_id = MonsterId
			} = TargetState,

			IsNull = util_data:is_null(MonsterId),
			CurNum = dict:size(CasterState#combat_obj.pet_dict),
			if
				IsNull ->
					%% 诱惑无效
					[#skill_result{
						skill_cmd = ?SKILL_CMD_TEMPT,
						obj_type = CasterState#combat_obj.obj_type,
						obj_id = CasterState#combat_obj.obj_id,
						result = {void}    %% 对象无效
					}];
				CurNum >= Num ->
					[#skill_result{
						skill_cmd = ?SKILL_CMD_TEMPT,
						obj_type = CasterState#combat_obj.obj_type,
						obj_id = CasterState#combat_obj.obj_id,
						result = {pet_num_limit}    %% 已经有宠物
					}];
				true ->
					MonsterConf = monster_config:get(MonsterId),
					#monster_conf{
						tempt = Tempt,
						pet_id = PetId,
						tempt_lv_limit = LvLimit,
						tempt_skill_lv_limit = SkillLvLimit
					} = MonsterConf,
					IsHit = util_rand:rand_hit(Percent),
					SkillLv = SkillConf#skill_conf.lv,
					if
						Tempt == 1 andalso CasterState#combat_obj.lv >= LvLimit andalso SkillLv >= SkillLvLimit andalso IsHit ->
							[#skill_result{
								skill_cmd = ?SKILL_CMD_TEMPT,
								obj_type = CasterState#combat_obj.obj_type,
								obj_id = CasterState#combat_obj.obj_id,
								result = {ok, TargetType, TargetId, PetId} %% 诱惑成功
							}];
						Tempt == 1 andalso CasterState#combat_obj.lv >= LvLimit ->
							[#skill_result{
								skill_cmd = ?SKILL_CMD_TEMPT,
								obj_type = CasterState#combat_obj.obj_type,
								obj_id = CasterState#combat_obj.obj_id,
								result = {fail, TargetType, TargetId, PetId} %% 诱惑失败
							}];
						Tempt == 1 ->
							[#skill_result{
								skill_cmd = ?SKILL_CMD_TEMPT,
								obj_type = CasterState#combat_obj.obj_type,
								obj_id = CasterState#combat_obj.obj_id,
								result = {lv_limit}    %% 等级不足
							}];
						true ->
							[#skill_result{
								skill_cmd = ?SKILL_CMD_TEMPT,
								obj_type = CasterState#combat_obj.obj_type,
								obj_id = CasterState#combat_obj.obj_id,
								result = {void}    %% 对象无效
							}]
					end
			end;
		_ ->
			[]
	end.

%% 获取战斗对象烈火buff
get_buff_fire(CasterState) ->
	BuffDict = CasterState#combat_obj.buff_dict,
	EffectDict = CasterState#combat_obj.effect_dict,
	buff_base_lib:get_buff_effect(BuffDict, EffectDict, ?BUFF_EFFECT_FIRE).

%% 击退
knockback(CasterState, TargetState, SceneId, Dist) ->
	X = TargetState#combat_obj.x,
	Y = TargetState#combat_obj.y,
	BX = CasterState#combat_obj.x,
	BY = CasterState#combat_obj.y,
	{XInc, YInc} =
		if
			X == BX andalso Y == BY ->
				{1, 1};
			X == BX andalso Y /= BY ->
				{0, (Y - BY) / abs(Y - BY)};
			X /= BX andalso Y == BY ->
				{(X - BX) / abs(X - BX), 0};
			true ->
				D = abs(X - BX),
				{(X - BX) / D, (Y - BY) / D}
		end,
	{X1, Y1} = get_knockback_point(SceneId, {X, Y}, XInc, YInc, Dist),
	#skill_result{
		skill_cmd = ?SKILL_CMD_KNOCKBACK,
		obj_type = TargetState#combat_obj.obj_type,
		obj_id = TargetState#combat_obj.obj_id,
		result = {{X, Y}, {X1, Y1}}
	}.

%% 获取击退点
get_knockback_point(SceneId, {X, Y}, XInc, YInc, Dist) ->
	get_knockback_point(SceneId, {X, Y}, {X, Y}, XInc, YInc, 1, Dist).

get_knockback_point(SceneId, {X, Y}, {X1, Y1}, XInc, YInc, N, Dist) ->
	case N > Dist of
		true ->
			{X1, Y1};
		_ ->
			X2 = erlang:round(X + XInc * N),
			Y2 = erlang:round(Y + YInc * N),
			case area_lib:get_grid_flag(SceneId, {X2, Y2}) of
				?GRID_FLAG_OFF ->
					{X1, Y1};
				_ ->
					get_knockback_point(SceneId, {X, Y}, {X2, Y2}, XInc, YInc, N + 1, Dist)
			end
	end.

%% 检查被动技能
check_passive_skill_trigger_effect(Caster) ->
	case Caster#combat_obj.pass_trigger_skill_list of
		PassList when is_list(PassList) ->
			Fun = fun({SkillId, SkillLv}, Acc) ->
				SkillConf = skill_config:get({SkillId, SkillLv}),
				List = passive_skill_effect([], SkillConf#skill_conf.effect_list),
				case List =/= [] of
					true ->
						SkillTreeConf = skill_tree_config:get({SkillId, SkillLv}),
						LimitLv = SkillTreeConf#skill_tree_conf.limit_lv,
						case Caster#combat_obj.lv >= LimitLv of
							true -> gen_server2:cast(Caster#combat_obj.obj_id, {add_skill_exp, SkillId});
							false -> skip
						end;
					false ->
						skip
				end,
				Acc ++ List
			end,
			lists:foldl(Fun, [], PassList);
		_ ->
			[]
	end.

passive_skill_effect(ResultList, []) ->
	ResultList;
passive_skill_effect(ResultList, [H | T]) ->
	case passive_effect(H) of
		[] -> passive_skill_effect(ResultList, T);
		Result -> passive_skill_effect([Result | ResultList], T)
	end.

passive_effect({rand_dm, DamValue, RandValue}) ->
	case util_rand:rand_hit(RandValue) of
		true -> {#skill_harm.append, DamValue};
		false -> []
	end;
passive_effect({rand_add_dm, DamValue, RandValue}) ->
	case util_rand:rand_hit(RandValue) of
		true -> {#skill_harm.add_percent, DamValue};
		false -> []
	end;
passive_effect(_Effect) ->
	%% ?ERR("undefined passive effect ~p", [Effect]),
	[].

%% 计算受击对象的总伤害
compute_total_harm_by_target(TargetHarmList) ->
	Fun = fun(SkillResult, Acc) ->
		case SkillResult#skill_result.result of
			#harm_result{} = HarmResult ->
				case lists:member(HarmResult#harm_result.status, [?HARM_STATUS_NORMAL, ?HARM_STATUS_CRIT, ?HARM_STATUS_MP]) of
					true ->
						HarmValue = HarmResult#harm_result.harm_value,
						Acc + HarmValue;
					false ->
						Acc
				end;
			_ ->
				Acc
		end
	end,
	lists:foldl(Fun, 0, TargetHarmList).

compute_rand_harm_by_target(TargetHarmList) ->
	Fun = fun(SkillResult, Acc) ->
		case SkillResult#skill_result.result of
			#harm_result{} = HarmResult ->
				case lists:member(HarmResult#harm_result.status, [?HARM_STATUS_NORMAL, ?HARM_STATUS_CRIT, ?HARM_STATUS_MP]) of
					true ->
						HarmValue = HarmResult#harm_result.harm_value,
						Acc + HarmValue;
					false ->
						Acc
				end;
			_ ->
				Acc
		end
	end,
	lists:foldl(Fun, 0, TargetHarmList).


%% 攻击类装备被动技能检测
check_atk_type_pass_skill(_CasterState, _TargetList, _HarmList, [], List) ->
	List;
check_atk_type_pass_skill(CasterState, TargetList, HarmList, [H | T], List) ->
	List1 = check_atk_type_pass_skill(H, CasterState, TargetList, HarmList),
	check_atk_type_pass_skill(CasterState, TargetList, HarmList, T, List1 ++ List).

check_atk_type_pass_skill({?SKILL_ID_MABI, SkillLv}, CasterState, TargetList, _HarmList) ->
	Len = length(TargetList),
	case Len =:= 1 of
		true ->
			%% 麻痹列表
			SkillConf = skill_config:get({?SKILL_ID_MABI, SkillLv}),
			case lists:keyfind(CasterState#combat_obj.career, 2, SkillConf#skill_conf.effect_list) of
				{_, _, BuffId, Rate} ->
					[buff_base_lib:trigger(CasterState, TargetState, BuffId, Rate) || TargetState <- TargetList];
				_ ->
					[]
			end;
		_ ->
			[]
	end;
check_atk_type_pass_skill({?SKILL_ID_SILENT, SkillLv1}, CasterState, TargetList, _HarmList) ->
	Len = length(TargetList),
	case Len =:= 1 of
		true ->
			%% 沉默列表
			SkillConf1 = skill_config:get({?SKILL_ID_SILENT, SkillLv1}),
			case lists:keyfind(CasterState#combat_obj.career, 2, SkillConf1#skill_conf.effect_list) of
				{_, _, BuffId1, Rate1} ->
					[buff_base_lib:trigger(CasterState, TargetState, BuffId1, Rate1) || TargetState <- TargetList];
				_ ->
					[]
			end;
		_ ->
			[]
	end;
check_atk_type_pass_skill({?SKILL_ID_MP_SUCK, SkillLv3}, _CasterState, TargetList, HarmList) ->
	Len = length(TargetList),
	case Len =:= 1 of
		true ->
			%% 扣蓝技能
			SkillConf3 = skill_config:get({?SKILL_ID_MP_SUCK, SkillLv3}),
			case SkillConf3#skill_conf.effect_list of
				[{mp_suck, Rate2, P1, V1}] ->
					case util_rand:rand_hit(Rate2) of
						true ->
							[Target] = TargetList,
							TotalHarm = compute_total_harm_by_target(HarmList),
							HitMp = util_math:ceil(TotalHarm / ?PERCENT_BASE * P1) + V1,
							[#skill_result
							{
								skill_cmd = ?SKILL_CMD_COST_MP,
								obj_type = Target#combat_obj.obj_type,
								obj_id = Target#combat_obj.obj_id,
								result = #harm_result{harm_value = HitMp, status = ?HARM_STATUS_MP}
							}];
						false ->
							[]
					end;
				_ ->
					[]
			end;
		_ ->
			[]
	end;
check_atk_type_pass_skill({?SKILL_ID_ADD_MP, SkillLv3}, CasterState, TargetList, HarmList) ->
	Len = length(TargetList),
	case Len =:= 1 of
		true ->
			[Target] = TargetList,
			case Target#combat_obj.obj_type of
				?OBJ_TYPE_PLAYER ->
					%% 施法者回蓝 并扣除受击者相同血量
					SkillConf3 = skill_config:get({?SKILL_ID_ADD_MP, SkillLv3}),
					case SkillConf3#skill_conf.effect_list of
						[{cure_mp, Rate2, P1, V1}] ->
							case util_rand:rand_hit(Rate2) of
								true ->
									TotalHarm = compute_total_harm_by_target(HarmList),
									HitMp = util_math:ceil(TotalHarm / ?PERCENT_BASE * P1) + V1,
									[#skill_result
									{
										skill_cmd = ?SKILL_CMD_COST_MP,
										obj_type = CasterState#combat_obj.obj_type,
										obj_id = CasterState#combat_obj.obj_id,
										result = #harm_result{harm_value = -HitMp, status = ?HARM_STATUS_MP}
									},
										#skill_result
										{
											skill_cmd = ?SKILL_CMD_COST_MP,
											obj_type = Target#combat_obj.obj_type,
											obj_id = Target#combat_obj.obj_id,
											result = #harm_result{harm_value = HitMp, status = ?HARM_STATUS_MP}
										}];
								false ->
									[]
							end;
						_ ->
							[]
					end;
				_ ->
					[]
			end;
		_ ->
			[]
	end;
%% 加buff类技能(分为施加对方或自己) 目前只做了加自己身上的
check_atk_type_pass_skill({SkillId, SkillLv}, CasterState, TargetList, _HarmList) ->
	Len = length(TargetList),
	case Len =:= 1 of
		true ->
			SkillConf = skill_config:get({SkillId, SkillLv}),
			case lists:keyfind(CasterState#combat_obj.career, 2, SkillConf#skill_conf.effect_list) of
				{attack_caster_buff, _, BuffId, Rate} -> %% 作用于施法者的buff
					case buff_base_lib:trigger(CasterState, CasterState, BuffId, Rate) of
						skip ->
							[];
						Result ->
							[Result]
					end;
				_ ->
					[]
			end;
		_ ->
			[]
	end;
check_atk_type_pass_skill(_SkillId, _CasterState, _TargetList, _HarmList) ->
	[].

%% 被动技能吸血检测
check_pass_skill_hp_suck(CasterState, TargetList, HarmList) ->
	Len = length(TargetList),
	PassList = CasterState#combat_obj.pass_trigger_skill_list,
	case Len >= 1 of
		true ->
			[Target | _] = TargetList,
			case check_resist_vampire(Target) of
				true ->
					%% 检测是对方否有吸血抗性
					case lists:keyfind(?SKILL_ID_HP_SUCK, 1, PassList) of
						false ->
							[];
						{SkillId, SkillLv} ->
							SkillConf = skill_config:get({SkillId, SkillLv}),
							case SkillConf#skill_conf.effect_list of
								[{hp_suck, Rate, P1, V1}] -> %% {hp_suck, 吸血概率, 吸血伤害百分百, 吸血固定值}
									case util_rand:rand_hit(Rate) of
										true ->
											TotalHarm = compute_rand_harm_by_target(HarmList),
											AddHp = util_math:ceil(TotalHarm / ?PERCENT_BASE * P1) + V1,
											[#skill_result
											{
												skill_cmd = ?SKILL_CMD_CURE,
												obj_type = CasterState#combat_obj.obj_type,
												obj_id = CasterState#combat_obj.obj_id,
												result = AddHp
											}];
										false ->
											[]
									end;
								_ ->
									[]
							end
					end;
				_ ->
					[]
			end;
		false ->
			[]
	end.

%% 获取被动吸血概率加成
get_pass_skill_hp_suck_percent(CasterState, TargetList) ->
	Len = length(TargetList),
	PassList = CasterState#combat_obj.pass_trigger_skill_list,
	case Len >= 1 of
		true ->
			[Target | _] = TargetList,
			%% 怪物吸血面具抗性检测
			case check_resist_vampire(Target) of
				true ->
					case lists:keyfind(?SKILL_ID_HP_SUCK, 1, PassList) of
						false ->
							{0, 0};
						{SkillId, SkillLv} ->
							SkillConf = skill_config:get({SkillId, SkillLv}),
							case SkillConf#skill_conf.effect_list of
								[{hp_suck, Rate, P1, V1}] -> %% {hp_suck, 吸血概率, 吸血伤害百分百, 吸血固定值}
									case util_rand:rand_hit(Rate) of
										true ->
											{P1, V1};
										false ->
											{0, 0}
									end;
								_ ->
									{0, 0}
							end
					end;
				_ ->
					{0, 0}
			end;
		false ->
			{0, 0}
	end.

check_resist_knockback(TargetState) ->
	case TargetState#combat_obj.obj_type of
		?OBJ_TYPE_MONSTER ->
			MonsterConf = monster_config:get(TargetState#combat_obj.monster_id),
			MonsterConf#monster_conf.is_resist_knockback =/= 1;
		_ ->
			true
	end.

check_resist_back(TargetState) ->
	case TargetState#combat_obj.obj_type of
		?OBJ_TYPE_MONSTER ->
			MonsterConf = monster_config:get(TargetState#combat_obj.monster_id),
			MonsterConf#monster_conf.is_resist_back =/= 1;
		_ ->
			true
	end.

check_resist_vampire(TargetState) ->
	case TargetState#combat_obj.obj_type of
		?OBJ_TYPE_MONSTER ->
			MonsterConf = monster_config:get(TargetState#combat_obj.monster_id),
			MonsterConf#monster_conf.is_resist_vampire =/= 1;
		_ ->
			true
	end.