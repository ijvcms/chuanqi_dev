%%%-------------------------------------------------------------------
%%% @author zhengsiying
%%% @copyright (C) 2015, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 06. 八月 2015 下午6:02
%%%-------------------------------------------------------------------
-module(combat_lib).

-include("common.hrl").
-include("record.hrl").
-include("cache.hrl").
-include("config.hrl").

-define(MIN_HARM, 1).

%% API
-export([
	compute_harm/3,
	compute_harm/4,
	compute_harm/5,
	compute_fire_wall_harm/3,
	compute_poison_harm/3,
	compute_player_recover/1
]).

%% ====================================================================
%% API functions
%% ====================================================================
%% 计算伤害
compute_harm(Caster, Target, SkillHarm) ->
	compute_harm(Caster, Target, SkillHarm, false, false).

compute_harm(Caster, Target, SkillHarm, MustHit) ->
	compute_harm(Caster, Target, SkillHarm, MustHit, false).

compute_harm(Caster, Target, SkillHarm, MustHit, Impale) ->
	CasterAttr = compute_attr(Caster),
	TargetAttr = compute_attr(Target),
	NewSkillHarm = compute_pass_skill_trigger(Caster, SkillHarm),

	CasterLv = Caster#combat_obj.lv,
	TargetLv = Target#combat_obj.lv,
	Hit = max(CasterAttr#attr_base.hit, 1),
	Dodge = max(TargetAttr#attr_base.dodge, 1),

	%% 判断是否命中目标
	IsHit =
		case Caster#combat_obj.career of
			?CAREER_ZHANSHI ->
				util_rand:rand_hit(2 * Hit / (Hit + Dodge));
			_ ->
				case Hit =< Dodge of
					true ->
						util_rand:rand_hit(2 * Hit / (Hit + Dodge));
					_ ->
						MHit = CasterAttr#attr_base.m_hit,
						MDodge = TargetAttr#attr_base.m_dodge,
						N = min(1.0, 1 + (MHit - MDodge) / ?PERCENT_BASE),
						util_rand:rand_hit(N)
				end
		end,

	case IsHit orelse MustHit of
		true ->
			%% 根据职业取出基本攻击和防御
			{MinAtt, MaxAtt, TargetMinDef, TargetMaxDef} =
				case Caster#combat_obj.career of
					?CAREER_ZHANSHI ->
						{
							CasterAttr#attr_base.min_ac,
							CasterAttr#attr_base.max_ac,
							TargetAttr#attr_base.min_def,
							TargetAttr#attr_base.max_def
						};
					?CAREER_FASHI ->
						{
							CasterAttr#attr_base.min_mac,
							CasterAttr#attr_base.max_mac,
							TargetAttr#attr_base.min_res,
							TargetAttr#attr_base.max_res
						};
					_ ->
						{
							CasterAttr#attr_base.min_sc,
							CasterAttr#attr_base.max_sc,
							TargetAttr#attr_base.min_res,
							TargetAttr#attr_base.max_res
						}
				end,

			%% 幸运值判定
			Luck = CasterAttr#attr_base.luck,
			Att = get_atk(Luck, MinAtt, MaxAtt),
			TargetDef = util_rand:rand(TargetMinDef, TargetMaxDef),
			AddPercent = NewSkillHarm#skill_harm.add_percent / ?PERCENT_BASE,
			Append = NewSkillHarm#skill_harm.append,
			SkillAdd = CasterAttr#attr_base.skill_add,

			%% 判断是否是暴击
			Crit = CasterAttr#attr_base.crit,
			%% 暴击率= 2%+暴击值／（暴击值＋玩家等级*10)
			IsCrit = util_rand:rand_hit(0.02 + (Crit / (Crit + CasterLv * 10))),
			{CritAtt, HarmStatus} =
				case IsCrit of
					true ->
						{CasterAttr#attr_base.crit_att, ?HARM_STATUS_CRIT};
					_ ->
						{0, ?HARM_STATUS_NORMAL}
				end,

			Holy = CasterAttr#attr_base.holy,
			Chaos = CasterAttr#attr_base.chaos,

			%% 计算魔法盾减免值
			{EP, EV} =
				case Impale of
					true ->
						{0, 0};
					_ ->
						%% 受击对象是否有魔法盾
						#buff_effect{
							effect_p = _EP,
							effect_v = _EV
						} = get_damage_reduction(Target),
						{_EP, _EV}
				end,

			%% 计算伤害加深
			DD = CasterAttr#attr_base.damage_deepen / ?PERCENT_BASE,
			%% 计算伤害减免
			DR = (TargetAttr#attr_base.damage_reduction + EP) / ?PERCENT_BASE,

			%% 伤害值＝(攻击*技能伤害百分比＋技能附加伤害值＋技能追加伤害值＋暴击力－敌方防御力)*(1+伤害加深－敌方伤害减免)＋神圣+混乱*参数A-魔法盾
			%% a.如果怪物等级>=玩家等级，参数A=1；
			%% b.如果怪物等级<玩家等级，参数A=1-(玩家等级-怪物等级)/20；
			%% c.当参数A<0.5时，取0.5；
			Harm = (Att * AddPercent + Append + SkillAdd + CritAtt - TargetDef) * (1 + DD - DR),

			A =
				case CasterLv >= TargetLv of
					true -> 1;
					_ -> max(0.5, 1 - (TargetLv - CasterLv) / 20)
				end,

			EvHarm = util_math:floor(max(?MIN_HARM, Harm - EV)),
			Harm1 = util_math:floor(EvHarm + Holy + Chaos * A),
			TargetPassSKillList = Target#combat_obj.pass_trigger_skill_list,
			TargetPassResult = get_pass_skill_result(Caster, Target, Harm1, TargetPassSKillList, []),

			%% 护身戒指检测
			case check_protect_ring_skill(Target, EvHarm) of
				{HpHarm, MpHarm} ->
					NewHpHarm = util_math:floor(HpHarm + Holy + Chaos * A),
					HpResult =
						case NewHpHarm > 0 of
							true ->
								[
									#skill_result{
										skill_cmd = ?SKILL_CMD_HARM,
										obj_type = Target#combat_obj.obj_type,
										obj_id = Target#combat_obj.obj_id,
										result = #harm_result{harm_value = NewHpHarm, status = HarmStatus}
									}
								];
							false ->
								[]
						end,
					[
						#skill_result{
							skill_cmd = ?SKILL_CMD_COST_MP,
							obj_type = Target#combat_obj.obj_type,
							obj_id = Target#combat_obj.obj_id,
							result = #harm_result{harm_value = MpHarm, status = ?HARM_STATUS_MP}
						}] ++ HpResult ++ TargetPassResult;
				_ ->
					[#skill_result{
						skill_cmd = ?SKILL_CMD_HARM,
						obj_type = Target#combat_obj.obj_type,
						obj_id = Target#combat_obj.obj_id,
						result = #harm_result{harm_value = Harm1, status = HarmStatus}
					}] ++ TargetPassResult
			end;
		_ ->
			[#skill_result{
				skill_cmd = ?SKILL_CMD_HARM,
				obj_type = Target#combat_obj.obj_type,
				obj_id = Target#combat_obj.obj_id,
				result = #harm_result{harm_value = 0, status = ?HARM_STATUS_MISS}
			}]
	end.

compute_fire_wall_harm(MinAtt, MaxAtt, Target) ->
	Att = util_rand:rand(MinAtt, MaxAtt),
	TargetAttr = compute_attr(Target),
	TargetDef = util_rand:rand(TargetAttr#attr_base.min_res, TargetAttr#attr_base.max_res),

	%% 受击对象是否有魔法盾
	#buff_effect{
		effect_p = EP,
		effect_v = EV
	} = get_damage_reduction(Target),

	DR = (TargetAttr#attr_base.damage_reduction + EP) / ?PERCENT_BASE,

	%% 伤害值＝（攻击＊技能伤害百分比＋技能附加伤害值＋技能追加伤害值＋暴击力＋神圣伤害－敌方防御力）＊（1+伤害加深－敌方伤害减免）
	Harm = (Att - TargetDef) * (1 - DR),
	max(?MIN_HARM, util_math:floor(Harm - EV)).

compute_poison_harm(MinAtt, MaxAtt, CombatObj) ->
	Att = util_rand:rand(MinAtt, MaxAtt),
	TargetAttr = compute_attr(CombatObj),
	TargetDef = util_rand:rand(TargetAttr#attr_base.min_res, TargetAttr#attr_base.max_res),

	DR = (TargetAttr#attr_base.damage_reduction) / ?PERCENT_BASE,
	%% 伤害值＝（攻击＊技能伤害百分比＋技能附加伤害值＋技能追加伤害值＋暴击力＋神圣伤害－敌方防御力）＊（1+伤害加深－敌方伤害减免）
	Harm = (Att - TargetDef) * (1 - DR),
	max(?MIN_HARM, util_math:floor(Harm)).

%% ====================================================================
%% Internal functions
%% ====================================================================
compute_attr(CombatObj) ->
	BuffDict = CombatObj#combat_obj.buff_dict,
	EffectDict = CombatObj#combat_obj.effect_dict,
	AttrBase = CombatObj#combat_obj.attr_base,
	BuffAttr = buff_base_lib:get_buff_attr(BuffDict, EffectDict, AttrBase),
	Attr0 = api_attr:attach_attr([CombatObj#combat_obj.attr_total, BuffAttr]),
	api_attr:floor_attr(Attr0).

%% 获取战斗对象魔法盾buff
get_damage_reduction(CombatObj) ->
	BuffDict = CombatObj#combat_obj.buff_dict,
	EffectDict = CombatObj#combat_obj.effect_dict,
	buff_base_lib:get_buff_effect(BuffDict, EffectDict, ?BUFF_EFFECT_DAMAGE_REDUCTION).

%% 计算被动技能触发技能效果
compute_pass_skill_trigger(Caster, SkillHarm) ->
	PassEffectList = skill_rule_lib:check_passive_skill_trigger_effect(Caster),
	Fun = fun(Effect, Acc) ->
		case Effect of
			{Key, Val} ->
				Val1 = max(0, Val + element(Key, SkillHarm)),
				NewSkillHarm = setelement(Key, SkillHarm, Val1),
				NewSkillHarm;
			_ ->
				Acc
		end
	end,
	lists:foldl(Fun, SkillHarm, PassEffectList).

%% 检测护身技能
check_protect_ring_skill(Target, Harm1) ->
	PassList = Target#combat_obj.pass_trigger_skill_list,
	case lists:keyfind(?SKILL_ID_HUSHEN, 1, PassList) of
		false ->
			skip;
		{SkillId, SkillLv} ->
			SkillConf = skill_config:get({SkillId, SkillLv}),
			[{_, List}] = SkillConf#skill_conf.effect_list,
			Career = Target#combat_obj.career,
			{_, ReductRate, MpDmRate, MpModleRate} = lists:keyfind(Career, 1, List),
			%% 扣除的总伤害
			TotalHarm = util_math:floor((1 - ReductRate) * Harm1),
			%% 扣除的蓝
			MpHarm = util_math:floor(TotalHarm * MpDmRate * MpModleRate),
			%% 扣除的血
			HpHarm = util_math:floor(TotalHarm * (1 - MpDmRate)),
			CurMp = Target#combat_obj.cur_mp,
			%% 特殊情况判断
			case CurMp >= MpHarm of
				true ->
					{HpHarm, MpHarm};
				false ->
					ExtraHp = util_math:floor((MpHarm - CurMp) / MpModleRate),
					{ExtraHp + HpHarm, CurMp}
			end
	end.

%% 获取被攻击者被动技能结果
get_pass_skill_result(_Caster, _Target, _Harm, [], ResultList) ->
	ResultList;
get_pass_skill_result(Caster, Target, Harm, [H | T], ResultList) ->
	ResultList1 = get_pass_skill_result(H, Caster, Target, Harm),
	get_pass_skill_result(Caster, Target, Harm, T, ResultList1 ++ ResultList).

get_pass_skill_result({?SKILL_ID_THORNS, SkillLv}, Caster, Target, Harm) ->
	TargetPassList = Target#combat_obj.pass_trigger_skill_list,
	%% 如果施法者是怪物检测是否带有抗性
	case check_resist_thorns(Caster) of
		true ->
			case lists:keyfind(?SKILL_ID_THORNS, 1, TargetPassList) of
				false ->
					[];
				{SkillId, SkillLv} ->
					SkillConf = skill_config:get({SkillId, SkillLv}),
					[{_, Rate, P, V}] = SkillConf#skill_conf.effect_list,
					case util_rand:rand_hit(Rate) of
						true ->
							ThornsHarm = util_math:ceil(Harm / ?PERCENT_BASE * P) + V,
							[#skill_result{
								skill_cmd = ?SKILL_CMD_HARM,
								obj_type = Caster#combat_obj.obj_type,
								obj_id = Caster#combat_obj.obj_id,
								result = {#harm_result{harm_value = ThornsHarm, status = ?HARM_STATUS_THORNS}, Target}
							}];
						false ->
							[]
					end
			end;
		false ->
			[]
	end;
get_pass_skill_result({SkillId, SkillLv}, _Caster, Target, _Harm) ->
	%% 加防御技能
	SkillConf = skill_config:get({SkillId, SkillLv}),
	case lists:keyfind(Target#combat_obj.career, 2, SkillConf#skill_conf.effect_list) of
		{gethit_targer_buff, _, BuffId, Rate} ->
			case buff_base_lib:trigger(Target, Target, BuffId, Rate) of
				skip ->
					[];
				Result ->
					[Result]
			end;
		_ ->
			[]
	end;
get_pass_skill_result(_, _Caster, _Target, _Harm) ->
	[].

%% 计算玩家回血属性
compute_player_recover(PlayerStats) ->
	AttrTotal = PlayerStats#player_state.attr_total,
	DbAttr = PlayerStats#player_state.db_player_attr,
	CurHp = DbAttr#db_player_attr.cur_hp,
	CurMp = DbAttr#db_player_attr.cur_mp,
	MaxMp = AttrTotal#attr_base.mp,
	MaxHp = AttrTotal#attr_base.hp,
	HpRecoverP = AttrTotal#attr_base.hp_recover_p,
	MpRecoverP = AttrTotal#attr_base.mp_recover_p,
	case CurHp == 0 of
		false ->
			RecoverHp = trunc(MaxHp * 0.02 * (1 + HpRecoverP / ?PERCENT_BASE)),
			RecoverMp = trunc(MaxMp * 0.02 * (1 + MpRecoverP / ?PERCENT_BASE)),

			NewCurHp = min(MaxHp, RecoverHp + CurHp),
			NewCurMp = min(MaxMp, RecoverMp + CurMp),

			%% PlayerId = PlayerStats#player_state.player_id,
			ChangePlayerAttr = DbAttr#db_player_attr{cur_hp = NewCurHp, cur_mp = NewCurMp},
			%% {ok, NewPlayerAttr} = player_attr_cache:update(PlayerId, ChangePlayerAttr),
			{ok, PlayerStats#player_state{db_player_attr = ChangePlayerAttr}};
		true ->
			{ok, PlayerStats}
	end.

%% 幸运触发
get_atk(Luck, MinAtt, MaxAtt) ->
	try
		LuckConf = luck_config:get(Luck),
		MaxAtkRate = LuckConf#luck_conf.max_atk_rate,
		MinAtkRate = LuckConf#luck_conf.min_atk_rate,
		Rate = util_rand:rand(1, ?PERCENT_BASE),
		if
			MaxAtkRate >= Rate ->
				MaxAtt;
			MinAtkRate >= Rate ->
				MinAtt;
			true ->
				util_rand:rand(MinAtt, MaxAtt)
		end
	catch
		_:_ -> MinAtt
	end.

check_resist_thorns(Caster) ->
	case Caster#combat_obj.obj_type of
		?OBJ_TYPE_MONSTER ->
			MonsterConf = monster_config:get(Caster#combat_obj.monster_id),
			MonsterConf#monster_conf.is_resist_thorns == 0;
		_ ->
			true
	end.
