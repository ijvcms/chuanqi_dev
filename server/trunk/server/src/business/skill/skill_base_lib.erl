%%%-------------------------------------------------------------------
%%% @author zhengsiying
%%% @copyright (C) 2015, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 11. 八月 2015 上午11:02
%%%-------------------------------------------------------------------
-module(skill_base_lib).

-include("common.hrl").
-include("record.hrl").
-include("cache.hrl").
-include("config.hrl").
-include("proto.hrl").
-include("language_config.hrl").

%% API
-export([
	init_skill/1,
	start_use_skill/2,
	trigger_skill/1,
	scene_obj_use_skill/6,
	hook_use_skill/4,
	simulation_use_skill/4,
	fire_wall_attack/2,
	get_skill_info/2,
	get_base_skill/1,
	check_skill/3
]).

%% ====================================================================
%% API functions
%% ====================================================================
init_skill(PlayerState) ->
	PlayerId = PlayerState#player_state.player_id,
	case skill_cache:select_all(PlayerId) of
		[] ->
			%% 添加玩家普通技能信息
			PlayerBase = PlayerState#player_state.db_player_base,
			Career = PlayerBase#db_player_base.career,
			SkillConf = get_base_skill(Career),
			Skill = #db_skill{
				player_id = PlayerId,
				skill_id = SkillConf#skill_conf.skill_id,
				lv = SkillConf#skill_conf.lv,
				pos = 0,
				exp = 0,
				auto_set = 1,
				next_time = 0
			},
			NewSkillDict = dict:store(Skill#db_skill.skill_id, Skill, dict:new()),
			skill_cache:insert(Skill),

			%% 临时接口  学习所有技能
%% 			PlayerBase = PlayerState#player_state.db_player_base,
%% 			Career = PlayerBase#db_player_base.career,
%% 			SkillList = [SId||{SId, SLv} <- skill_config:get_list(), SLv =:= 1 andalso (SId div 10000) * 1000 =:= Career andalso SId =/= SkillConf#skill_conf.skill_id],
%% 			Fun = fun(Id, Acc) ->
%% %% 					case lists:member(Id, [10700, 20600, 30400]) of
%% %% 						true ->
%% 							S = #db_skill{
%% 								player_id = PlayerId,
%% 								skill_id = Id,
%% 								lv = 1,
%% 								pos = 0,
%% 								exp = 0,
%% 								auto_set = 0,
%% 								next_time = 0
%% 							},
%% 							NSD = dict:store(Id, S, Acc),
%% 							skill_cache:insert(S),
%% 							NSD
%% %% 						false ->
%% %% 							Acc
%% %% 					end
%% 				  end,
%% 			NSD1 = lists:foldl(Fun, NewSkillDict, SkillList),

			PlayerState#player_state{
				skill_dict = NewSkillDict,
				order_skill_list = [Skill#db_skill.skill_id],
				skill_keyboard = [],
				pass_trigger_skill_list = []
			};
		List ->
			%% 基础技能检测
			List1 = check_base_skill(PlayerState, List),
			F = fun(Skill, Acc) ->
				{SkillDict, SkillList, KeyBoard, PassList} = Acc,
				NewSkillDict = dict:store(Skill#db_skill.skill_id, Skill, SkillDict),
				SkillId = Skill#db_skill.skill_id,
				SkillLv = Skill#db_skill.lv,
				SkillConf = skill_config:get({SkillId, SkillLv}),
				NewSkillList = case Skill#db_skill.auto_set =:= 1 of
								   true -> [SkillId | SkillList];
								   false -> SkillList
							   end,
				NewKeyBoard = case Skill#db_skill.pos =/= 0 of
								  true -> [{Skill#db_skill.pos, SkillId} | KeyBoard];
								  false -> KeyBoard
							  end,
				NewPassList = case SkillConf#skill_conf.type =:= ?SKILL_TYPE_PASSIVITY of
								  true -> [{SkillId, SkillLv} | PassList];
								  false -> PassList
							  end,
				{NewSkillDict, NewSkillList, NewKeyBoard, NewPassList}
			end,
			{SkillDict1, SkillList1, KeyBoard1, PassList1} = lists:foldl(F, {dict:new(), [], [], []}, List1),
			PlayerState#player_state{
				skill_dict = SkillDict1,
				order_skill_list = SkillList1,
				skill_keyboard = KeyBoard1,
				pass_trigger_skill_list = PassList1
			}
	end.

%% 开始使用技能
%% TargetObjOrPoint有下面两种方式
%% 	1.{target, TargetType, TargetId} : 指定目标
%% 	2.{point, X, Y} : 指定坐标
start_use_skill(PlayerState, ReqData) ->
	%% 判断玩家是否有学习这个技能
	#req_start_use_skill{
		direction = Direction, %% 朝向
		skill_id = SkillId, %% 技能模板id
		target_type = TargetType, %% 目标类型: 1 对象, 2 地面坐标
		target_flag = Flag, %% 目标对象唯一标识
		target_point = Point %% 目标坐标
	} = ReqData,

	%% 目标
	Target =
		case TargetType of
			?TARGET_TYPE_OBJ ->
				#proto_obj_flag{
					type = ObjType,
					id = ObjId
				} = Flag,
				{target, ObjType, ObjId};
			?TARGET_TYPE_POINT ->
				#proto_point{
					x = X1,
					y = Y1
				} = Point,
				{point, X1, Y1};
			TargetErr ->
				?ERR("err ~p", [TargetErr]),
				null
		end,
	%% 判断玩家是否可以行动
	case player_lib:can_action(PlayerState) andalso Target /= null andalso player_lib:can_use_skill(PlayerState) of
		true ->
			#player_state{
				skill_dict = SkillDict,
				db_player_attr = DbPlayerAttr,
				buff_dict = BuffDict,
				effect_dict = EffectDict
			} = PlayerState,

			%% 技能距离检测
			case check_skill(PlayerState, SkillId, Target) of %% 检查技能是否可以释放
				{ok, Skill, SkillConf} -> %% 释放技能
					NewCurMp = DbPlayerAttr#db_player_attr.cur_mp - SkillConf#skill_conf.cost_mp,

					%% 烈火buff不计算时间
					{CurTime, NewSkill, NewSkillDict} =
						case Skill#db_skill.skill_id =:= ?SPECIAL_SKILL_ID_FIRE of
							true ->
								{PlayerState#player_state.last_use_skill_time, Skill, SkillDict};
							_ ->
								CurTime1 = util_date:longunixtime(),
								NewSkill1 = Skill#db_skill{next_time = CurTime1 + SkillConf#skill_conf.cd},  %% 冷却时间
								NewSkillDict1 = dict:store(SkillId, NewSkill1, SkillDict), %% 替换技能状态信息 保存
								{CurTime1, NewSkill1, NewSkillDict1}
						end,

					%% 判断身上是否有烈火buff
					SkillId1 =
						case buff_base_lib:get_buff_effect(BuffDict, EffectDict, ?BUFF_EFFECT_FIRE) of
							#buff_effect{effect_p = P, effect_v = V} when P > 0 orelse V > 0 ->
								%% 如果有烈火buff，并且使用的技能是普通攻击或者是刺杀则用烈火替代
								case lists:member(SkillId, ?SKILL_ID_FIRE_REPLACE_LIST) of
									true ->
										?SPECIAL_SKILL_ID_FIRE_1;
									_ ->
										SkillId
								end;
							_ ->
								SkillId
						end,

					SkillLv = case SkillId1 /= SkillId of
								  true ->
									  case get_skill_info(SkillDict, ?SPECIAL_SKILL_ID_FIRE) of
										  #db_skill{} = SkillInfo ->
											  SkillInfo#db_skill.lv;
										  _ ->
											  NewSkill#db_skill.lv
									  end;
								  _ ->
									  NewSkill#db_skill.lv
							  end,

					UseSkillInfo = #use_skill_info{
						skill_id = SkillId1,
						target = Target
					},

					%% 修改玩家状态
					Update = #player_state{
						last_use_skill_time = CurTime,
						skill_dict = NewSkillDict,
						db_player_attr = #db_player_attr{cur_mp = NewCurMp},
						last_use_skill = UseSkillInfo
					},

					%% 先扣蓝再用技能
					{ok, NewPlayerState} = player_lib:update_player_state(PlayerState, Update),
					scene_skill_lib:obj_start_use_skill(NewPlayerState, {SkillId1, SkillLv}, Target, Direction),
					{ok, NewPlayerState};
				{fail, Err} ->
					{fail, Err}
			end;
		_ ->
			{fail, ?ERR_COMMON_FAIL}
	end.

%% 真正触发技能效果
trigger_skill(PlayerState) ->
	#player_state{
		last_use_skill = LastUseSkill,
		pet_dict = PetDict,
		scene_pid = ScenePid,
		scene_id = SceneId,
		db_player_base = DbPlayerBase,
		skill_dict = SkillDict
	} = PlayerState,
	case util_data:is_null(LastUseSkill) of
		false ->
			Update = #player_state{
				last_use_skill = null
			},

			%% 触发技能效果后先最新使用技能消息置空
			case player_lib:update_player_state(PlayerState, Update) of
				{ok, NewPlayerState} ->
					#use_skill_info{
						skill_id = SkillId,
						target = Target
					} = LastUseSkill,
					%% 对烈火剑法进行特殊处理
					SkillId1 =
						case SkillId =:= ?SPECIAL_SKILL_ID_FIRE_1 of
							true ->
								?SPECIAL_SKILL_ID_FIRE;
							_ ->
								SkillId
						end,
					{ok, Skill} = dict:find(SkillId1, SkillDict),
					SkillConf = skill_config:get({SkillId, Skill#db_skill.lv}),

					%% 判断是否是召唤技能，如果是召唤技能并且，宠物个数大于0，则表示召回宠物
					IsRecallPet =
						case lists:keyfind(call_pet, 1, SkillConf#skill_conf.effect_list) of
							false ->
								false;
							_ ->
								PetNum = dict:size(PetDict),
								PetNum > 0
						end,

					case IsRecallPet of
						true ->
							%% 如果是召回宠物，直接执行召回宠物逻辑
							#db_player_base{
								x = X,
								y = Y
							} = DbPlayerBase,

							F = fun(_, PetInfo) ->
								#pet_info{
									scene_pid = PetScenePid,
									uid = Uid
								} = PetInfo,
								obj_pet_lib:recall(PetScenePid, Uid, ScenePid, SceneId, self(), {X, Y})
							end,
							dict:map(F, PetDict);
						_ ->
							%% 否则执行使用技能逻辑
							scene_skill_lib:obj_use_skill(NewPlayerState, SkillConf, Target)
					end,
					{ok, NewPlayerState};
				{fail, Err} ->
					{fail, Err}
			end;
		_ ->
			{fail, ?ERR_COMMON_FAIL}
	end.

%% 场景对象使用技能
scene_obj_use_skill(SceneState, CasterState, SkillInfo, TargetList, TargerId, TargerType) ->
	#spell_skill_info{
		skill_conf = SkillConf,
		target_point = TargetPoint
	} = SkillInfo,
	%% 获取真实承受目标
	SceneId = SceneState#scene_state.scene_id,
	TargetList1 = skill_rule_lib:get_legal_target_list(CasterState, SkillInfo, TargetList, SceneId, TargerId, TargerType),

	TargetList2 =
		case TargetList1 =:= [] andalso SkillConf#skill_conf.target /= ?SKILL_TARGET_HOSTILE of
			true ->
				[CasterState];
			_ ->
				TargetList1
		end,
	%% 触发技能效果
	ResultList = skill_rule_lib:spell_effect(CasterState, SkillConf, TargetList2, SceneId, TargetPoint),
	F = fun(Target, Acc) ->
		dict:store({Target#scene_obj_state.obj_type, Target#scene_obj_state.obj_id}, Target, Acc)
	end,
	ObjDict1 = lists:foldl(F, dict:new(), [CasterState | TargetList2]),

	%% 更新对象，生成更新对象字典
	UpdateDict = update_obj(ResultList, ObjDict1),
	%% 生成技能效果信息
	EffectProto = make_skill_effect(ResultList, UpdateDict, #skill_effect{}),
	%%?INFO("~p", [EffectProto]),
	{ok, UpdateDict, EffectProto}.

%% 挂机使用技能
hook_use_skill(HookState, {CasterType, CasterId}, SkillId, TargetFlagList) ->
	case hook_lib:get_obj(HookState, CasterType, CasterId) of%%
		#hook_obj_state{} = CasterState ->
			SkillDict = CasterState#hook_obj_state.skill_dict,
			case check_skill(CasterState, SkillId) of
				{ok, Skill, SkillConf} ->
					case check_target(HookState, SkillConf, TargetFlagList) of
						{ok, TargetList} ->
							ResultList = skill_rule_lib:spell_effect(CasterState, SkillConf, TargetList),
							ObjType = CasterState#hook_obj_state.obj_type,
							ObjId = CasterState#hook_obj_state.obj_id,
							NewMp = CasterState#hook_obj_state.cur_mp - SkillConf#skill_conf.cost_mp,
							NewSkill = Skill#db_skill{next_time = util_date:longunixtime() + SkillConf#skill_conf.cd},
							NewSkillDict = dict:store(Skill#db_skill.skill_id, NewSkill, SkillDict),
							NewCaster = CasterState#hook_obj_state{
								cur_mp = NewMp,
								skill_dict = NewSkillDict
							},
							ObjDict = dict:store({ObjType, ObjId}, NewCaster, dict:new()),
							F = fun(Target, Acc) ->
								dict:store({Target#hook_obj_state.obj_type, Target#hook_obj_state.obj_id}, Target, Acc)
							end,
							ObjDict1 = lists:foldl(F, ObjDict, TargetList),
							UpdateDict = update_obj(ResultList, ObjDict1),
							EffectProto = make_skill_effect(ResultList, UpdateDict, #skill_effect{}),
							{ok, UpdateDict, EffectProto};
						{fail, Err} ->
							{fail, Err}
					end;
				{fail, Err} ->
					{fail, Err}
			end;
		_ ->
			{fail, ?ERR_HOOK_OBJ_NOT}
	end.

%% 挂机模拟使用技能
simulation_use_skill(CasterState, SkillConf, TargetList, SimulationTime) ->
	SkillConf1 =
		case SkillConf#skill_conf.skill_id =:= ?SPECIAL_SKILL_ID_FIRE of
			true ->
				skill_config:get({?SPECIAL_SKILL_ID_FIRE_1, SkillConf#skill_conf.lv});
			_ ->
				SkillConf
		end,
	ResultList = skill_rule_lib:spell_effect(CasterState, SkillConf1, TargetList),
	SkillDict = CasterState#hook_obj_state.skill_dict,
	SkillId = SkillConf#skill_conf.skill_id,
	case dict:find(SkillId, SkillDict) of
		{ok, Skill} ->
			ObjType = CasterState#hook_obj_state.obj_type,
			ObjId = CasterState#hook_obj_state.obj_id,
			NewMp = CasterState#hook_obj_state.cur_mp - SkillConf#skill_conf.cost_mp,
			NewSkill = Skill#db_skill{next_time = SimulationTime + SkillConf#skill_conf.cd},
			NewSkillDict = dict:store(SkillId, NewSkill, SkillDict),
			NewCaster = CasterState#hook_obj_state{
				cur_mp = NewMp,
				skill_dict = NewSkillDict
			},
			ObjDict = dict:store({ObjType, ObjId}, NewCaster, dict:new()),
			F = fun(Target, Acc) ->
				dict:store({Target#hook_obj_state.obj_type, Target#hook_obj_state.obj_id}, Target, Acc)
			end,
			ObjDict1 = lists:foldl(F, ObjDict, TargetList),
			UpdateDict = update_obj(ResultList, ObjDict1),
			EffectProto = make_skill_effect(ResultList, UpdateDict, #skill_effect{}),
			{UpdateDict, EffectProto};
		_ ->
			null
	end.

fire_wall_attack(FireWallState, ObjState) ->
	Target = skill_rule_lib:to_combat_obj(ObjState),
	Harm = combat_lib:compute_fire_wall_harm(FireWallState#fire_wall_state.min_att, FireWallState#fire_wall_state.max_att, Target),
	HarmResult = #harm_result{harm_value = Harm, status = ?HARM_STATUS_NORMAL},
	NewObjState = spell_single_effect(?SKILL_CMD_HARM, HarmResult, ObjState),
	{HarmResult, NewObjState}.

%% ====================================================================
%% Internal functions 检查技能
%% ====================================================================
check_skill(PlayerState, SkillId, TargerOrPoint) when is_record(PlayerState, player_state) ->
	SkillDict = PlayerState#player_state.skill_dict,
	PlayerBase = PlayerState#player_state.db_player_base,
	#db_player_attr{
		cur_mp = CurMp
	} = PlayerState#player_state.db_player_attr,
	Career = PlayerBase#db_player_base.career,
	LastTime = PlayerState#player_state.last_use_skill_time,

	case check_skill(Career, LastTime, CurMp, SkillDict, SkillId) of
		{ok, Skill, SkillConf} ->
			%% 检测距离
			case scene_skill_lib2:check_skill(PlayerState, SkillConf, TargerOrPoint) of
				true ->
					{ok, Skill, SkillConf}; %% 执行技能
				Err1 ->
					Err1
			end;
		{fail, Err} ->
			{fail, Err}
	end.
check_skill(HookObjState, SkillId) when is_record(HookObjState, hook_obj_state) ->
	SkillDict = HookObjState#hook_obj_state.skill_dict,
	Career = HookObjState#hook_obj_state.career,
	LastTime = HookObjState#hook_obj_state.last_use_skill_time,
	CurMp = HookObjState#hook_obj_state.cur_mp,
	PetId = HookObjState#hook_obj_state.pet_id,
	case check_skill(Career, LastTime, CurMp, SkillDict, SkillId) of
		{ok, Skill, SkillConf} ->
			List = SkillConf#skill_conf.effect_list,
			case lists:keyfind(call_pet, 1, List) of
				{call_pet, _, _} ->
					case util_data:is_null(PetId) of
						true ->
							{ok, Skill, SkillConf};
						_ ->
							{fail, 4}
					end;
				_ ->
					{ok, Skill, SkillConf}
			end;
		{fail, Err} ->
			{fail, Err}
	end.

%% 玩家检测技能是否可用
check_skill(Career, LastTime, CurMp, SkillDict, SkillId) ->
	SkillId1 =
		case SkillId =:= ?SPECIAL_SKILL_ID_FIRE_1 of
			true ->
				?SPECIAL_SKILL_ID_FIRE;
			_ ->
				SkillId
		end,

	case get_skill_info(SkillDict, SkillId1) of
		#db_skill{} = Skill ->
			SkillLv = Skill#db_skill.lv,
			SkillConf = skill_config:get({SkillId, SkillLv}),
			%% 判断技能是否是主动技能
			case SkillConf#skill_conf.type of
				?SKILL_TYPE_DRIVING ->
					%% 判断技能CD
					case check_cd(Career, LastTime, Skill) of
						true ->
							case check_mp(CurMp, SkillConf) of
								true ->
									{ok, Skill, SkillConf};
								_ ->
									{fail, ?ERR_SKILL_2}
							end;
						_ ->
							{fail, ?ERR_SKILL_1}
					end;
				_ ->
					{fail, ?ERR_SKILL_3}
			end;
		_ ->
			%% {fail, 1}
			SkillConf = skill_config:get({SkillId, 1}),
			Skill = #db_skill{
				skill_id = SkillId,
				lv = 1,
				next_time = 0
			},
			{ok, Skill, SkillConf#skill_conf{cost_mp = 0}}
	end.

check_cd(Career, LastTime, Skill) ->
	CurTime = util_date:longunixtime(),
	Interval = player_lib:get_attack_interval(Career),
	(LastTime + Interval =< CurTime) andalso Skill#db_skill.next_time =< CurTime.

check_mp(CurMp, SkillConf) ->
	CurMp >= SkillConf#skill_conf.cost_mp.
%% 获取目标列表
check_target(HookState, SkillConf, TargetFlagList) ->
	TargetList = [hook_lib:get_obj(HookState, ObjType, ObjId) || {ObjType, ObjId} <- TargetFlagList],%%
	case lists:member(null, TargetList) of
		false ->
			case SkillConf#skill_conf.range of
				?SKILL_RANGE_SINGLE ->
					TargetNum = length(TargetList),
					case TargetNum =:= 1 of
						true ->
							{ok, TargetList};
						_ ->
							{fail, 2}
					end;
				_ ->
					{ok, TargetList}
			end;
		_ ->
			{fail, 1}
	end.

get_skill_info(SkillDict, SkillId) ->
	case dict:find(SkillId, SkillDict) of
		{ok, SkillInfo} ->
			SkillInfo;
		_ ->
			null
	end.

update_obj([], ObjDict) ->
	ObjDict;
update_obj([SkillResult | T], ObjDict) when is_record(SkillResult, skill_result) ->
	ObjType = SkillResult#skill_result.obj_type,
	ObjId = SkillResult#skill_result.obj_id,
	case dict:find({ObjType, ObjId}, ObjDict) of
		{ok, ObjState} ->
			Cmd = SkillResult#skill_result.skill_cmd,
			NewObjState = spell_single_effect(Cmd, SkillResult#skill_result.result, ObjState),
			update_obj(T, dict:store({ObjType, ObjId}, NewObjState, ObjDict));
		_ ->
			update_obj(T, ObjDict)
	end;
update_obj([_ | T], ObjDict) ->
	update_obj(T, ObjDict).

spell_single_effect(?SKILL_CMD_COST_MP, Result, ObjState) when is_record(ObjState, hook_obj_state) ->
	NewMp = ObjState#hook_obj_state.cur_mp - Result#harm_result.harm_value,
	ObjState#hook_obj_state{cur_mp = NewMp};
spell_single_effect(?SKILL_CMD_COST_MP, Result, ObjState) when is_record(ObjState, scene_obj_state) ->
	NewMp = ObjState#scene_obj_state.cur_mp - Result#harm_result.harm_value,
	ObjState#scene_obj_state{cur_mp = NewMp};

spell_single_effect(?SKILL_CMD_HARM, TempResult, ObjState) when is_record(ObjState, hook_obj_state) ->
	%% 反伤处理
	{Result, _KillTarger} =
		case TempResult of
			{#harm_result{}, _} ->
				TempResult;
			_ ->
				{TempResult, null}
		end,
	NewHp = max(ObjState#hook_obj_state.cur_hp - Result#harm_result.harm_value, 0),
	case NewHp > 0 of
		true ->
			ObjState#hook_obj_state{cur_hp = NewHp};
		_ ->
			ObjState#hook_obj_state{cur_hp = NewHp, status = ?STATUS_DIE}
	end;
spell_single_effect(?SKILL_CMD_HARM, TempResult, ObjState) when is_record(ObjState, scene_obj_state) ->
	%% 反伤处理
	{Result, KillTarger} =
		case TempResult of
			{#harm_result{}, _} ->
				TempResult;
			_ ->
				{TempResult, null}
		end,
	NewHp = max(ObjState#scene_obj_state.cur_hp - Result#harm_result.harm_value, 0),
	case NewHp > 0 of
		true ->
			ObjState#scene_obj_state{cur_hp = NewHp};
		_ ->
			%% 复活戒指检测
			case check_su_sheng_of_the_dead(ObjState) of
				{true, NewCdTime} ->
					AttrTotal = ObjState#scene_obj_state.attr_total,
					ObjState#scene_obj_state{cur_hp = AttrTotal#attr_base.hp, cur_mp = AttrTotal#attr_base.mp, fh_cd = NewCdTime};
				false ->
					ObjState#scene_obj_state{cur_hp = NewHp, kill_targer = KillTarger, status = ?STATUS_DIE}
			end
	end;

spell_single_effect(?SKILL_CMD_CURE, AddHp, ObjState) when is_record(ObjState, hook_obj_state) ->
	Attr = ObjState#hook_obj_state.attr_total,
	NewHp = min(ObjState#hook_obj_state.cur_hp + AddHp, Attr#attr_base.hp),
	ObjState#hook_obj_state{cur_hp = NewHp};
spell_single_effect(?SKILL_CMD_CURE, AddHp, ObjState) when is_record(ObjState, scene_obj_state) ->
	Attr = ObjState#scene_obj_state.attr_total,
	NewHp = min(ObjState#scene_obj_state.cur_hp + AddHp, Attr#attr_base.hp),
	ObjState#scene_obj_state{cur_hp = NewHp};

spell_single_effect(?SKILL_CMD_BUFF, ResultList, ObjState) ->
	F = fun(BuffResult, Acc) ->
		#buff_result{
			operate = Oper,
			buff_id = BuffId,
			buff_info = Buff
		} = BuffResult,
		case Oper of
			?BUFF_OPERATE_DELETE ->
				buff_base_lib:remove_buff(Acc, BuffId);
			_ ->
				buff_base_lib:store_buff(Acc, BuffId, Buff)
		end
	end,
	lists:foldl(F, ObjState, ResultList);

spell_single_effect(?SKILL_CMD_MOVE, {{_BX, _BY}, {EX, EY}}, ObjState) when is_record(ObjState, scene_obj_state) ->
	ObjState#scene_obj_state{x = EX, y = EY, ex = EX, ey = EY};

spell_single_effect(?SKILL_CMD_KNOCKBACK, {{_BX, _BY}, {EX, EY}}, ObjState) when is_record(ObjState, scene_obj_state) ->
	ObjState#scene_obj_state{x = EX, y = EY, ex = EX, ey = EY};

spell_single_effect(_, _Result, ObjState) ->
	ObjState.

make_skill_effect([], _UpdateDict, EffectProto) ->
	EffectProto;
make_skill_effect([SkillResult | T], UpdateDict, EffectProto) when is_record(SkillResult, skill_result) ->
	ObjType = SkillResult#skill_result.obj_type,
	ObjId = SkillResult#skill_result.obj_id,
	case dict:find({ObjType, ObjId}, UpdateDict) of
		{ok, ObjState} ->
			Cmd = SkillResult#skill_result.skill_cmd,
			CombatObj = skill_rule_lib:to_combat_obj(ObjState),
			NewEffectProto = add_skill_effect(Cmd, SkillResult#skill_result.result, CombatObj, EffectProto),
			make_skill_effect(T, UpdateDict, NewEffectProto);
		_ ->
			Cmd = SkillResult#skill_result.skill_cmd,
			NewEffectProto = add_skill_effect(Cmd, SkillResult#skill_result.result, null, EffectProto),
			make_skill_effect(T, UpdateDict, NewEffectProto)
	end;
make_skill_effect([_ | T], UpdateDict, EffectProto) ->
	make_skill_effect(T, UpdateDict, EffectProto).

add_skill_effect(?SKILL_CMD_HARM, TempResult, CombatObj, EffectProto) ->
	%% 反伤处理
	Result =
		case TempResult of
			{#harm_result{} = TempResult1, _Targer} ->
				TempResult1;
			_ ->
				TempResult
		end,
	HarmList = EffectProto#skill_effect.harm_list,
	#combat_obj{
		obj_type = ObjType,
		obj_id = ObjId,
		cur_hp = CurHp,
		cur_mp = CurMp
	} = CombatObj,%% 攻击方

	HarmProto = #proto_harm{
		obj_flag = #proto_obj_flag{type = ObjType, id = ObjId},
		harm_status = Result#harm_result.status,
		harm_value = Result#harm_result.harm_value,
		cur_hp = CurHp,
		cur_mp = CurMp
	},
	EffectProto#skill_effect{harm_list = [HarmProto | HarmList]};

add_skill_effect(?SKILL_CMD_COST_MP, Result, CombatObj, EffectProto) ->
	HarmList = EffectProto#skill_effect.harm_list,
	#combat_obj{
		obj_type = ObjType,
		obj_id = ObjId,
		cur_hp = CurHp,
		cur_mp = CurMp
	} = CombatObj,%% 攻击方

	HarmProto = #proto_harm{
		obj_flag = #proto_obj_flag{type = ObjType, id = ObjId},
		harm_status = Result#harm_result.status,
		harm_value = Result#harm_result.harm_value,
		cur_hp = CurHp,
		cur_mp = CurMp
	},
	EffectProto#skill_effect{harm_list = [HarmProto | HarmList]};

add_skill_effect(?SKILL_CMD_CURE, Result, ObjState, EffectProto) ->
	CureList = EffectProto#skill_effect.cure_list,
	#combat_obj{
		obj_type = ObjType,
		obj_id = ObjId,
		cur_hp = CurHp,
		cur_mp = CurMp
	} = ObjState,
	Proto = #proto_cure{
		obj_flag = #proto_obj_flag{type = ObjType, id = ObjId},
		add_hp = Result,
		cur_hp = CurHp,
		cur_mp = CurMp
	},
	EffectProto#skill_effect{cure_list = [Proto | CureList]};

add_skill_effect(?SKILL_CMD_BUFF, ResultList, ObjState, EffectProto) ->
	BuffList = EffectProto#skill_effect.buff_list,
	#combat_obj{
		obj_type = ObjType,
		obj_id = ObjId
	} = ObjState,

	CurTime = util_date:unixtime(),
	F = fun(BuffResult, Acc) ->
		Countdown =
			case BuffResult#buff_result.operate of
				?BUFF_OPERATE_DELETE ->
					0;
				_ ->
					case BuffResult#buff_result.buff_info of
						#db_buff{remove_time = RT} = _Buff ->
							max(RT - CurTime, 0);
						_ ->
							0
					end
			end,
		BuffId = BuffResult#buff_result.buff_id,
		BuffConf = buff_config:get(BuffId),
		Proto = #proto_buff_operate{
			obj_flag = #proto_obj_flag{type = ObjType, id = ObjId},
			operate = BuffResult#buff_result.operate,
			buff_id = BuffId,
			effect_id = BuffConf#buff_conf.effect_id,
			countdown = Countdown
		},
		[Proto | Acc]
	end,
	NewBuffList = lists:foldl(F, BuffList, ResultList),
	EffectProto#skill_effect{buff_list = NewBuffList};

add_skill_effect(?SKILL_CMD_CALL_PET, MonsterId, _ObjState, EffectProto) ->
	EffectProto#skill_effect{call_pet = MonsterId};

add_skill_effect(?SKILL_CMD_FIRE_WALL, Result, _ObjState, EffectProto) ->
	EffectProto#skill_effect{fire_wall = Result};

add_skill_effect(?SKILL_CMD_REMOVE_EFFECT, EffectId, ObjState, EffectProto) ->
	EffectProto#skill_effect{remove_effect = {ObjState#combat_obj.obj_type, ObjState#combat_obj.obj_id, EffectId}};

add_skill_effect(?SKILL_CMD_MOVE, {{BX, BY}, {EX, EY}}, ObjState, EffectProto) ->
	MoveList = EffectProto#skill_effect.move_list,
	#combat_obj{
		obj_type = ObjType,
		obj_id = ObjId
	} = ObjState,
	Proto = #proto_point_change{
		obj_flag = #proto_obj_flag{type = ObjType, id = ObjId},
		begin_point = #proto_point{x = BX, y = BY},
		end_point = #proto_point{x = EX, y = EY}
	},
	EffectProto#skill_effect{move_list = [Proto | MoveList]};

add_skill_effect(?SKILL_CMD_KNOCKBACK, {{BX, BY}, {EX, EY}}, ObjState, EffectProto) ->
	KnockbackList = EffectProto#skill_effect.knockback_list,
	#combat_obj{
		obj_type = ObjType,
		obj_id = ObjId
	} = ObjState,
	Proto = #proto_point_change{
		obj_flag = #proto_obj_flag{type = ObjType, id = ObjId},
		begin_point = #proto_point{x = BX, y = BY},
		end_point = #proto_point{x = EX, y = EY}
	},
	EffectProto#skill_effect{knockback_list = [Proto | KnockbackList]};

add_skill_effect(?SKILL_CMD_TEMPT, Result, _ObjState, EffectProto) ->
	EffectProto#skill_effect{tempt = Result};

add_skill_effect(_Cmd, _Result, _ObjState, EffectProto) ->
	EffectProto.

get_base_skill(Career) ->
	case Career of
		?CAREER_ZHANSHI ->
			skill_config:get({10100, 1});
		?CAREER_FASHI ->
			skill_config:get({20100, 1});
		_ ->
			skill_config:get({30100, 1})
	end.

%% 复活戒指检测
check_su_sheng_of_the_dead(ObjState) ->
	PassList = ObjState#scene_obj_state.pass_trigger_skill_list,
	case lists:keyfind(?SKILL_ID_FUHUO, 1, PassList) of
		false ->
			false;
		{SkillId, SkillLv} ->
			NowTime = util_date:unixtime(),
%% 			?ERR(" ~p", [{NowTime > ObjState#scene_obj_state.fh_cd, NowTime, ObjState#scene_obj_state.fh_cd}]),
			case NowTime > ObjState#scene_obj_state.fh_cd of
				true -> %% 复活
					SkillConf = skill_config:get({SkillId, SkillLv}),
					[{_, CdTime}] = SkillConf#skill_conf.effect_list,
					NewCdTime = CdTime + NowTime,
					ObjType = ObjState#scene_obj_state.obj_type,
					ObjId = ObjState#scene_obj_state.obj_id,
					gen_server2:cast(ObjState#scene_obj_state.obj_pid, {update_fh_cd, NewCdTime, ObjType, ObjId}),
					{true, NewCdTime};
				false ->
					false
			end
	end.

%% 基础技能检测
check_base_skill(PlayerState, List) ->
	PlayerBase = PlayerState#player_state.db_player_base,
	Career = PlayerBase#db_player_base.career,
	SkillConf = get_base_skill(Career),
	SkillId = SkillConf#skill_conf.skill_id,
	case lists:keyfind(SkillId, #db_skill.skill_id, List) of
		false ->
			%% 添加玩家普通技能信息
			Skill = #db_skill{
				player_id = PlayerState#player_state.player_id,
				skill_id = SkillId,
				lv = SkillConf#skill_conf.lv,
				pos = 0,
				exp = 0,
				auto_set = 1,
				next_time = 0
			},
			skill_cache:insert(Skill),
			[Skill] ++ List;
		_ ->
			List
	end.