%%%-------------------------------------------------------------------
%%% @author zhengsiying
%%% @copyright (C) 2AttrRecord#attr_base.15, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 22. 七月 2AttrRecord#attr_base.15 下午4:57
%%%-------------------------------------------------------------------
-module(api_attr).

-include("common.hrl").
-include("record.hrl").
-include("config.hrl").

%% API
-export([
	attach_attr/1,
	attach_attr/2,
	attach_attr_by_value/1,
	attach_attr_by_value/2,
	attach_attr_by_p/1,
	attach_attr_by_p/2,
	addition_attr/2,
	addition_attr_by_modulus/2,
	floor_attr/1,
	compute_base_attr_p/2,
	compute_spec_attr_p/3,
	compute_suit_attr/1
]).

%% ====================================================================
%% API functions
%% ====================================================================
%% 把各个属性模块附加到一起
attach_attr(AttrRecordList) ->
	attach_attr(AttrRecordList, #attr_base{}).

%% 把各个属性模块附加到总属性上
attach_attr([], TotalAttr) ->
	TotalAttr;
attach_attr([AttrRecord | T], TotalAttr) when is_record(AttrRecord, attr_base) ->
	NewTotalAttr = TotalAttr#attr_base{
		hp = TotalAttr#attr_base.hp + AttrRecord#attr_base.hp,
		mp = TotalAttr#attr_base.mp + AttrRecord#attr_base.mp,
		min_ac = TotalAttr#attr_base.min_ac + AttrRecord#attr_base.min_ac,
		max_ac = TotalAttr#attr_base.max_ac + AttrRecord#attr_base.max_ac,
		min_mac = TotalAttr#attr_base.min_mac + AttrRecord#attr_base.min_mac,
		max_mac = TotalAttr#attr_base.max_mac + AttrRecord#attr_base.max_mac,
		min_sc = TotalAttr#attr_base.min_sc + AttrRecord#attr_base.min_sc,
		max_sc = TotalAttr#attr_base.max_sc + AttrRecord#attr_base.max_sc,
		min_def = TotalAttr#attr_base.min_def + AttrRecord#attr_base.min_def,
		max_def = TotalAttr#attr_base.max_def + AttrRecord#attr_base.max_def,
		min_res = TotalAttr#attr_base.min_res + AttrRecord#attr_base.min_res,
		max_res = TotalAttr#attr_base.max_res + AttrRecord#attr_base.max_res,
		crit = TotalAttr#attr_base.crit + AttrRecord#attr_base.crit,
		crit_att = TotalAttr#attr_base.crit_att + AttrRecord#attr_base.crit_att,
		hit = TotalAttr#attr_base.hit + AttrRecord#attr_base.hit,
		dodge = TotalAttr#attr_base.dodge + AttrRecord#attr_base.dodge,
		damage_deepen = TotalAttr#attr_base.damage_deepen + AttrRecord#attr_base.damage_deepen,
		damage_reduction = TotalAttr#attr_base.damage_reduction + AttrRecord#attr_base.damage_reduction,
		holy = TotalAttr#attr_base.holy + AttrRecord#attr_base.holy,
		skill_add = TotalAttr#attr_base.skill_add + AttrRecord#attr_base.skill_add,
		m_hit = TotalAttr#attr_base.m_hit + AttrRecord#attr_base.m_hit,
		m_dodge = TotalAttr#attr_base.m_dodge + AttrRecord#attr_base.m_dodge,
		hp_recover = TotalAttr#attr_base.hp_recover + AttrRecord#attr_base.hp_recover,
		mp_recover = TotalAttr#attr_base.mp_recover + AttrRecord#attr_base.mp_recover,
		resurgence = TotalAttr#attr_base.resurgence + AttrRecord#attr_base.resurgence,
		damage_offset = TotalAttr#attr_base.damage_offset + AttrRecord#attr_base.damage_offset,
		luck = TotalAttr#attr_base.luck + AttrRecord#attr_base.luck,
		chaos = TotalAttr#attr_base.chaos + AttrRecord#attr_base.chaos,
		hp_p = TotalAttr#attr_base.hp_p + AttrRecord#attr_base.hp_p,
		mp_p = TotalAttr#attr_base.mp_p + AttrRecord#attr_base.mp_p,
		min_ac_p = TotalAttr#attr_base.min_ac_p + AttrRecord#attr_base.min_ac_p,
		max_ac_p = TotalAttr#attr_base.max_ac_p + AttrRecord#attr_base.max_ac_p,
		min_mac_p = TotalAttr#attr_base.min_mac_p + AttrRecord#attr_base.min_mac_p,
		max_mac_p = TotalAttr#attr_base.max_mac_p + AttrRecord#attr_base.max_mac_p,
		min_sc_p = TotalAttr#attr_base.min_sc_p + AttrRecord#attr_base.min_sc_p,
		max_sc_p = TotalAttr#attr_base.max_sc_p + AttrRecord#attr_base.max_sc_p,
		min_def_p = TotalAttr#attr_base.min_def_p + AttrRecord#attr_base.min_def_p,
		max_def_p = TotalAttr#attr_base.max_def_p + AttrRecord#attr_base.max_def_p,
		min_res_p = TotalAttr#attr_base.min_res_p + AttrRecord#attr_base.min_res_p,
		max_res_p = TotalAttr#attr_base.max_res_p + AttrRecord#attr_base.max_res_p,
		crit_p = TotalAttr#attr_base.crit_p + AttrRecord#attr_base.crit_p,
		crit_att_p = TotalAttr#attr_base.crit_att_p + AttrRecord#attr_base.crit_att_p,
		hit_p = TotalAttr#attr_base.hit_p + AttrRecord#attr_base.hit_p,
		dodge_p = TotalAttr#attr_base.dodge_p + AttrRecord#attr_base.dodge_p,
		damage_deepen_p = TotalAttr#attr_base.damage_deepen_p + AttrRecord#attr_base.damage_deepen_p,
		damage_reduction_p = TotalAttr#attr_base.damage_reduction_p + AttrRecord#attr_base.damage_reduction_p,
		holy_p = TotalAttr#attr_base.holy_p + AttrRecord#attr_base.holy_p,
		skill_add_p = TotalAttr#attr_base.skill_add_p + AttrRecord#attr_base.skill_add_p,
		m_hit_p = TotalAttr#attr_base.m_hit_p + AttrRecord#attr_base.m_hit_p,
		m_dodge_p = TotalAttr#attr_base.m_dodge_p + AttrRecord#attr_base.m_dodge_p,
		hp_recover_p = TotalAttr#attr_base.hp_recover_p + AttrRecord#attr_base.hp_recover_p,
		mp_recover_p = TotalAttr#attr_base.mp_recover_p + AttrRecord#attr_base.mp_recover_p,
		resurgence_p = TotalAttr#attr_base.resurgence_p + AttrRecord#attr_base.resurgence_p,
		coin_p = TotalAttr#attr_base.coin_p + AttrRecord#attr_base.coin_p,
		exp_p = TotalAttr#attr_base.exp_p + AttrRecord#attr_base.exp_p
	},
	attach_attr(T, NewTotalAttr);
attach_attr([{UpdateKey, V} | T], TotalAttr) ->
	K = get_key_map(UpdateKey),
	V1 = element(K, TotalAttr),
	NewTotalAttr = setelement(K, TotalAttr, V + V1),
	attach_attr(T, NewTotalAttr);
attach_attr([_AttrRecord | T], TotalAttr) ->
	attach_attr(T, TotalAttr).

%% 把各个属性模块附加到一起(仅数值)
attach_attr_by_value(AttrRecordList) ->
	attach_attr(AttrRecordList, #attr_base{}).

%% 把各个属性模块附加到总属性上(仅数值)
attach_attr_by_value([], TotalAttr) ->
	TotalAttr;
attach_attr_by_value([AttrRecord | T], TotalAttr) when is_record(AttrRecord, attr_base) ->
	NewTotalAttr = TotalAttr#attr_base{
		hp = TotalAttr#attr_base.hp + AttrRecord#attr_base.hp,
		mp = TotalAttr#attr_base.mp + AttrRecord#attr_base.mp,
		min_ac = TotalAttr#attr_base.min_ac + AttrRecord#attr_base.min_ac,
		max_ac = TotalAttr#attr_base.max_ac + AttrRecord#attr_base.max_ac,
		min_mac = TotalAttr#attr_base.min_mac + AttrRecord#attr_base.min_mac,
		max_mac = TotalAttr#attr_base.max_mac + AttrRecord#attr_base.max_mac,
		min_sc = TotalAttr#attr_base.min_sc + AttrRecord#attr_base.min_sc,
		max_sc = TotalAttr#attr_base.max_sc + AttrRecord#attr_base.max_sc,
		min_def = TotalAttr#attr_base.min_def + AttrRecord#attr_base.min_def,
		max_def = TotalAttr#attr_base.max_def + AttrRecord#attr_base.max_def,
		min_res = TotalAttr#attr_base.min_res + AttrRecord#attr_base.min_res,
		max_res = TotalAttr#attr_base.max_res + AttrRecord#attr_base.max_res,
		crit = TotalAttr#attr_base.crit + AttrRecord#attr_base.crit,
		crit_att = TotalAttr#attr_base.crit_att + AttrRecord#attr_base.crit_att,
		hit = TotalAttr#attr_base.hit + AttrRecord#attr_base.hit,
		dodge = TotalAttr#attr_base.dodge + AttrRecord#attr_base.dodge,
		damage_deepen = TotalAttr#attr_base.damage_deepen + AttrRecord#attr_base.damage_deepen,
		damage_reduction = TotalAttr#attr_base.damage_reduction + AttrRecord#attr_base.damage_reduction,
		holy = TotalAttr#attr_base.holy + AttrRecord#attr_base.holy,
		skill_add = TotalAttr#attr_base.skill_add + AttrRecord#attr_base.skill_add,
		m_hit = TotalAttr#attr_base.m_hit + AttrRecord#attr_base.m_hit,
		m_dodge = TotalAttr#attr_base.m_dodge + AttrRecord#attr_base.m_dodge,
		hp_recover = TotalAttr#attr_base.hp_recover + AttrRecord#attr_base.hp_recover,
		mp_recover = TotalAttr#attr_base.mp_recover + AttrRecord#attr_base.mp_recover,
		resurgence = TotalAttr#attr_base.resurgence + AttrRecord#attr_base.resurgence,
		damage_offset = TotalAttr#attr_base.damage_offset + AttrRecord#attr_base.damage_offset,
		luck = TotalAttr#attr_base.luck + AttrRecord#attr_base.luck,
		chaos = TotalAttr#attr_base.chaos + AttrRecord#attr_base.chaos
	},
	attach_attr(T, NewTotalAttr);
attach_attr_by_value([{UpdateKey, V} | T], TotalAttr) ->
	K = get_key_map(UpdateKey),
	V1 = element(K, TotalAttr),
	NewTotalAttr = setelement(K, TotalAttr, V + V1),
	attach_attr(T, NewTotalAttr);
attach_attr_by_value([_AttrRecord | T], TotalAttr) ->
	attach_attr(T, TotalAttr).

%% 把各个属性模块附加到一起(仅百分比)
attach_attr_by_p(AttrRecordList) ->
	attach_attr(AttrRecordList, #attr_base{}).

%% 把各个属性模块附加到总属性上(仅百分比)
attach_attr_by_p([], TotalAttr) ->
	TotalAttr;
attach_attr_by_p([AttrRecord | T], TotalAttr) when is_record(AttrRecord, attr_base) ->
	NewTotalAttr = TotalAttr#attr_base{
		hp_p = TotalAttr#attr_base.hp_p + AttrRecord#attr_base.hp_p,
		mp_p = TotalAttr#attr_base.mp_p + AttrRecord#attr_base.mp_p,
		min_ac_p = TotalAttr#attr_base.min_ac_p + AttrRecord#attr_base.min_ac_p,
		max_ac_p = TotalAttr#attr_base.max_ac_p + AttrRecord#attr_base.max_ac_p,
		min_mac_p = TotalAttr#attr_base.min_mac_p + AttrRecord#attr_base.min_mac_p,
		max_mac_p = TotalAttr#attr_base.max_mac_p + AttrRecord#attr_base.max_mac_p,
		min_sc_p = TotalAttr#attr_base.min_sc_p + AttrRecord#attr_base.min_sc_p,
		max_sc_p = TotalAttr#attr_base.max_sc_p + AttrRecord#attr_base.max_sc_p,
		min_def_p = TotalAttr#attr_base.min_def_p + AttrRecord#attr_base.min_def_p,
		max_def_p = TotalAttr#attr_base.max_def_p + AttrRecord#attr_base.max_def_p,
		min_res_p = TotalAttr#attr_base.min_res_p + AttrRecord#attr_base.min_res_p,
		max_res_p = TotalAttr#attr_base.max_res_p + AttrRecord#attr_base.max_res_p,
		crit_p = TotalAttr#attr_base.crit_p + AttrRecord#attr_base.crit_p,
		crit_att_p = TotalAttr#attr_base.crit_att_p + AttrRecord#attr_base.crit_att_p,
		hit_p = TotalAttr#attr_base.hit_p + AttrRecord#attr_base.hit_p,
		dodge_p = TotalAttr#attr_base.dodge_p + AttrRecord#attr_base.dodge_p,
		damage_deepen_p = TotalAttr#attr_base.damage_deepen_p + AttrRecord#attr_base.damage_deepen_p,
		damage_reduction_p = TotalAttr#attr_base.damage_reduction_p + AttrRecord#attr_base.damage_reduction_p,
		holy_p = TotalAttr#attr_base.holy_p + AttrRecord#attr_base.holy_p,
		skill_add_p = TotalAttr#attr_base.skill_add_p + AttrRecord#attr_base.skill_add_p,
		m_hit_p = TotalAttr#attr_base.m_hit_p + AttrRecord#attr_base.m_hit_p,
		m_dodge_p = TotalAttr#attr_base.m_dodge_p + AttrRecord#attr_base.m_dodge_p,
		hp_recover_p = TotalAttr#attr_base.hp_recover_p + AttrRecord#attr_base.hp_recover_p,
		mp_recover_p = TotalAttr#attr_base.mp_recover_p + AttrRecord#attr_base.mp_recover_p,
		resurgence_p = TotalAttr#attr_base.resurgence_p + AttrRecord#attr_base.resurgence_p,
		coin_p = TotalAttr#attr_base.coin_p + AttrRecord#attr_base.coin_p,
		exp_p = TotalAttr#attr_base.exp_p + AttrRecord#attr_base.exp_p
	},
	attach_attr(T, NewTotalAttr);
attach_attr_by_p([{UpdateKey, V} | T], TotalAttr) ->
	K = get_key_map(UpdateKey),
	V1 = element(K, TotalAttr),
	NewTotalAttr = setelement(K, TotalAttr, V + V1),
	attach_attr(T, NewTotalAttr);
attach_attr_by_p([_AttrRecord | T], TotalAttr) ->
	attach_attr(T, TotalAttr).

%% 向下取整属性
floor_attr(TotalAttr) ->
	TotalAttr#attr_base{
		hp = util_math:floor(TotalAttr#attr_base.hp),
		mp = util_math:floor(TotalAttr#attr_base.mp),
		min_ac = util_math:floor(TotalAttr#attr_base.min_ac),
		max_ac = util_math:floor(TotalAttr#attr_base.max_ac),
		min_mac = util_math:floor(TotalAttr#attr_base.min_mac),
		max_mac = util_math:floor(TotalAttr#attr_base.max_mac),
		min_sc = util_math:floor(TotalAttr#attr_base.min_sc),
		max_sc = util_math:floor(TotalAttr#attr_base.max_sc),
		min_def = util_math:floor(TotalAttr#attr_base.min_def),
		max_def = util_math:floor(TotalAttr#attr_base.max_def),
		min_res = util_math:floor(TotalAttr#attr_base.min_res),
		max_res = util_math:floor(TotalAttr#attr_base.max_res),
		crit = util_math:floor(TotalAttr#attr_base.crit),
		crit_att = util_math:floor(TotalAttr#attr_base.crit_att),
		hit = util_math:floor(TotalAttr#attr_base.hit),
		dodge = util_math:floor(TotalAttr#attr_base.dodge),
		damage_deepen = util_math:floor(TotalAttr#attr_base.damage_deepen),
		damage_reduction = util_math:floor(TotalAttr#attr_base.damage_reduction),
		holy = util_math:floor(TotalAttr#attr_base.holy),
		skill_add = util_math:floor(TotalAttr#attr_base.skill_add),
		m_hit = util_math:floor(TotalAttr#attr_base.m_hit),
		m_dodge = util_math:floor(TotalAttr#attr_base.m_dodge),
		hp_recover = util_math:floor(TotalAttr#attr_base.hp_recover),
		mp_recover = util_math:floor(TotalAttr#attr_base.mp_recover),
		resurgence = util_math:floor(TotalAttr#attr_base.resurgence),
		damage_offset = util_math:floor(TotalAttr#attr_base.damage_offset),
		luck = util_math:floor(TotalAttr#attr_base.luck),
		chaos = util_math:floor(TotalAttr#attr_base.chaos)
	}.

%% 属性百分比加成
addition_attr(AttrRecord, Addition) ->
	Addition1 = 1 + Addition,
	NewAttr = AttrRecord#attr_base{
		hp = trunc(AttrRecord#attr_base.hp * Addition1),
		mp = trunc(AttrRecord#attr_base.mp * Addition1),
		min_ac = trunc(AttrRecord#attr_base.min_ac * Addition1),
		max_ac = trunc(AttrRecord#attr_base.max_ac * Addition1),
		min_mac = trunc(AttrRecord#attr_base.min_mac * Addition1),
		max_mac = trunc(AttrRecord#attr_base.max_mac * Addition1),
		min_sc = trunc(AttrRecord#attr_base.min_sc * Addition1),
		max_sc = trunc(AttrRecord#attr_base.max_sc * Addition1),
		min_def = trunc(AttrRecord#attr_base.min_def * Addition1),
		max_def = trunc(AttrRecord#attr_base.max_def * Addition1),
		min_res = trunc(AttrRecord#attr_base.min_res * Addition1),
		max_res = trunc(AttrRecord#attr_base.max_res * Addition1),
		crit = trunc(AttrRecord#attr_base.crit * Addition1),
		crit_att = trunc(AttrRecord#attr_base.crit_att * Addition1),
		hit = trunc(AttrRecord#attr_base.hit * Addition1),
		dodge = trunc(AttrRecord#attr_base.dodge * Addition1),
		damage_deepen = trunc(AttrRecord#attr_base.damage_deepen * Addition1),
		damage_reduction = trunc(AttrRecord#attr_base.damage_reduction * Addition1),
		holy = trunc(AttrRecord#attr_base.holy * Addition1),
		skill_add = trunc(AttrRecord#attr_base.skill_add * Addition1),
		m_hit = trunc(AttrRecord#attr_base.m_hit * Addition1),
		m_dodge = trunc(AttrRecord#attr_base.m_dodge * Addition1),
		hp_recover = trunc(AttrRecord#attr_base.hp_recover * Addition1),
		mp_recover = trunc(AttrRecord#attr_base.mp_recover * Addition1),
		resurgence = trunc(AttrRecord#attr_base.resurgence * Addition1),
		damage_offset = trunc(AttrRecord#attr_base.damage_offset * Addition1)
	},
	NewAttr.

%% 属性百分比加成
addition_attr_by_modulus(AttrRecord, Addition) ->
	NewAttr = #attr_base{
		hp = trunc(AttrRecord#attr_base.hp * Addition),
		mp = trunc(AttrRecord#attr_base.mp * Addition),
		min_ac = trunc(AttrRecord#attr_base.min_ac * Addition),
		max_ac = trunc(AttrRecord#attr_base.max_ac * Addition),
		min_mac = trunc(AttrRecord#attr_base.min_mac * Addition),
		max_mac = trunc(AttrRecord#attr_base.max_mac * Addition),
		min_sc = trunc(AttrRecord#attr_base.min_sc * Addition),
		max_sc = trunc(AttrRecord#attr_base.max_sc * Addition),
		min_def = trunc(AttrRecord#attr_base.min_def * Addition),
		max_def = trunc(AttrRecord#attr_base.max_def * Addition),
		min_res = trunc(AttrRecord#attr_base.min_res * Addition),
		max_res = trunc(AttrRecord#attr_base.max_res * Addition),
		crit = trunc(AttrRecord#attr_base.crit * Addition),
		crit_att = trunc(AttrRecord#attr_base.crit_att * Addition),
		hit = trunc(AttrRecord#attr_base.hit * Addition),
		dodge = trunc(AttrRecord#attr_base.dodge * Addition),
		damage_deepen = trunc(AttrRecord#attr_base.damage_deepen * Addition),
		damage_reduction = trunc(AttrRecord#attr_base.damage_reduction * Addition),
		holy = trunc(AttrRecord#attr_base.holy * Addition),
		skill_add = trunc(AttrRecord#attr_base.skill_add * Addition),
		m_hit = trunc(AttrRecord#attr_base.m_hit * Addition),
		m_dodge = trunc(AttrRecord#attr_base.m_dodge * Addition),
		hp_recover = trunc(AttrRecord#attr_base.hp_recover * Addition),
		mp_recover = trunc(AttrRecord#attr_base.mp_recover * Addition),
		resurgence = trunc(AttrRecord#attr_base.resurgence * Addition),
		damage_offset = trunc(AttrRecord#attr_base.damage_offset * Addition)
	},
	NewAttr.

%% 计算基础属性百分比(基础属性 ＝ 装备基础属性 ＋ 人物基础属性)
compute_base_attr_p(BaseAttr, TotalAttr) ->
	NewAttr = #attr_base{
		hp = (BaseAttr#attr_base.hp * TotalAttr#attr_base.hp_p)/?PERCENT_BASE,
		mp = (BaseAttr#attr_base.mp * TotalAttr#attr_base.mp_p)/?PERCENT_BASE,
		min_ac = (BaseAttr#attr_base.min_ac * TotalAttr#attr_base.min_ac_p)/?PERCENT_BASE,
		max_ac = (BaseAttr#attr_base.max_ac * TotalAttr#attr_base.max_ac_p)/?PERCENT_BASE,
		min_mac = (BaseAttr#attr_base.min_mac * TotalAttr#attr_base.min_mac_p)/?PERCENT_BASE,
		max_mac = (BaseAttr#attr_base.max_mac * TotalAttr#attr_base.max_mac_p)/?PERCENT_BASE,
		min_sc = (BaseAttr#attr_base.min_sc * TotalAttr#attr_base.min_sc_p)/?PERCENT_BASE,
		max_sc = (BaseAttr#attr_base.max_sc * TotalAttr#attr_base.max_sc_p)/?PERCENT_BASE,
		min_def = (BaseAttr#attr_base.min_def * TotalAttr#attr_base.min_def_p)/?PERCENT_BASE,
		max_def = (BaseAttr#attr_base.max_def * TotalAttr#attr_base.max_def_p)/?PERCENT_BASE,
		min_res = (BaseAttr#attr_base.min_res * TotalAttr#attr_base.min_res_p)/?PERCENT_BASE,
		max_res = (BaseAttr#attr_base.max_res * TotalAttr#attr_base.max_res_p)/?PERCENT_BASE,
		crit = (BaseAttr#attr_base.crit * TotalAttr#attr_base.crit_p)/?PERCENT_BASE,
		crit_att = (BaseAttr#attr_base.crit_att * TotalAttr#attr_base.crit_att_p)/?PERCENT_BASE,
		hit = (BaseAttr#attr_base.hit * TotalAttr#attr_base.hit_p)/?PERCENT_BASE,
		dodge = (BaseAttr#attr_base.dodge * TotalAttr#attr_base.dodge_p)/?PERCENT_BASE,
		damage_deepen = (BaseAttr#attr_base.damage_deepen * TotalAttr#attr_base.damage_deepen_p)/?PERCENT_BASE,
		damage_reduction = (BaseAttr#attr_base.damage_reduction * TotalAttr#attr_base.damage_reduction_p)/?PERCENT_BASE,
		holy = (BaseAttr#attr_base.holy * TotalAttr#attr_base.holy_p)/?PERCENT_BASE,
		skill_add = (BaseAttr#attr_base.skill_add * TotalAttr#attr_base.skill_add_p)/?PERCENT_BASE,
		m_hit = (BaseAttr#attr_base.m_hit * TotalAttr#attr_base.m_hit_p)/?PERCENT_BASE,
		m_dodge = (BaseAttr#attr_base.m_dodge * TotalAttr#attr_base.m_dodge_p)/?PERCENT_BASE,
		hp_recover = (BaseAttr#attr_base.hp_recover * TotalAttr#attr_base.hp_recover_p)/?PERCENT_BASE,
		mp_recover = (BaseAttr#attr_base.mp_recover * TotalAttr#attr_base.mp_recover_p)/?PERCENT_BASE,
		resurgence = (BaseAttr#attr_base.resurgence * TotalAttr#attr_base.resurgence_p)/?PERCENT_BASE,
		damage_offset = (BaseAttr#attr_base.damage_offset * TotalAttr#attr_base.damage_offset_p)/?PERCENT_BASE
	},
	NewAttr.

%% 经验与金币百分比加成计算
compute_spec_attr_p(PlayerStats, Type, Value) ->
	TotalAttr = PlayerStats#player_state.attr_base,
	case Type of
		?UPDATE_KEY_COIN_P ->
			util_math:floor(TotalAttr#attr_base.coin_p * Value/?PERCENT_BASE) + Value;
		?UPDATE_KEY_EXP_P ->
			util_math:floor(TotalAttr#attr_base.exp_p * Value/?PERCENT_BASE) + Value
	end.

%% 套装属性统计
compute_suit_attr(SuitList) ->
	SuitList1 = util_list:list_statistics(SuitList),

	Fun = fun({SuitId, Count}, Acc) ->
		case equips_suit_config:get({SuitId}) of
			List when is_list(List) ->
				SList = [{SuitId, X} || X <- List, Count >= X],
				SList ++ Acc;
			_ ->
				Acc
		end
	end,
	SuitList2 = lists:foldl(Fun, [], SuitList1),

	Fun1 = fun({SuitId, Count}, AttrBase) ->
				case equips_suit_config:get({SuitId, Count}) of
					#equips_suit_conf{} = SuitConf ->
						SuitAttr = SuitConf#equips_suit_conf.attr_base,
						attach_attr([SuitAttr, AttrBase]);
					_ ->
						AttrBase
				end
		  end,
	lists:foldl(Fun1, #attr_base{}, SuitList2).

%% ====================================================================
%% Internal functions
%% ====================================================================
get_key_map(?UPDATE_KEY_HP) -> #attr_base.hp;
get_key_map(?UPDATE_KEY_MP) -> #attr_base.mp;
get_key_map(?UPDATE_KEY_MIN_AC) -> #attr_base.min_ac;
get_key_map(?UPDATE_KEY_MAX_AC) -> #attr_base.max_ac;
get_key_map(?UPDATE_KEY_MIN_MAC) -> #attr_base.min_mac;
get_key_map(?UPDATE_KEY_MAX_MAC) -> #attr_base.max_mac;
get_key_map(?UPDATE_KEY_MIN_SC) -> #attr_base.min_sc;
get_key_map(?UPDATE_KEY_MAX_SC) -> #attr_base.max_sc;
get_key_map(?UPDATE_KEY_MIN_DEF) -> #attr_base.min_def;
get_key_map(?UPDATE_KEY_MAX_DEF) -> #attr_base.max_def;
get_key_map(?UPDATE_KEY_MIN_RES) -> #attr_base.min_res;
get_key_map(?UPDATE_KEY_MAX_RES) -> #attr_base.max_res;
get_key_map(?UPDATE_KEY_CRIT) -> #attr_base.crit;
get_key_map(?UPDATE_KEY_CRIT_ATT) -> #attr_base.crit_att;
get_key_map(?UPDATE_KEY_HIT) -> #attr_base.hit;
get_key_map(?UPDATE_KEY_DODGE) -> #attr_base.dodge;
get_key_map(?UPDATE_KEY_DAMAGE_DEEPEN) -> #attr_base.damage_deepen;
get_key_map(?UPDATE_KEY_DAMAGE_REDUCTION) -> #attr_base.damage_reduction;
get_key_map(?UPDATE_KEY_HOLY) -> #attr_base.holy;
get_key_map(?UPDATE_KEY_SKILL_ADD) -> #attr_base.skill_add;
get_key_map(?UPDATE_KEY_M_HIT) -> #attr_base.m_hit;
get_key_map(?UPDATE_KEY_M_DODGE) -> #attr_base.m_dodge;
get_key_map(?UPDATE_KEY_HP_RECOVER) -> #attr_base.hp_recover;
get_key_map(?UPDATE_KEY_MP_RECOVER) -> #attr_base.mp_recover;
get_key_map(?UPDATE_KEY_RESURGENCE) -> #attr_base.resurgence;
get_key_map(?UPDATE_KEY_DAMAGE_OFFSET) -> #attr_base.damage_offset;
get_key_map(?UPDATE_KEY_LUCK) -> #attr_base.luck;
get_key_map(?UPDATE_KEY_HP_P) -> #attr_base.hp_p;
get_key_map(?UPDATE_KEY_MP_P) -> #attr_base.mp_p;
get_key_map(?UPDATE_KEY_MIN_AC_P) -> #attr_base.min_ac_p;
get_key_map(?UPDATE_KEY_MAX_AC_P) -> #attr_base.max_ac_p;
get_key_map(?UPDATE_KEY_MIN_MAC_P) -> #attr_base.min_mac_p;
get_key_map(?UPDATE_KEY_MAX_MAC_P) -> #attr_base.max_mac_p;
get_key_map(?UPDATE_KEY_MIN_SC_P) -> #attr_base.min_sc_p;
get_key_map(?UPDATE_KEY_MAX_SC_P) -> #attr_base.max_sc_p;
get_key_map(?UPDATE_KEY_MIN_DEF_P) -> #attr_base.min_def_p;
get_key_map(?UPDATE_KEY_MAX_DEF_P) -> #attr_base.max_def_p;
get_key_map(?UPDATE_KEY_MIN_RES_P) -> #attr_base.min_res_p;
get_key_map(?UPDATE_KEY_MAX_RES_P) -> #attr_base.max_res_p;
get_key_map(?UPDATE_KEY_CRIT_P) -> #attr_base.crit_p;
get_key_map(?UPDATE_KEY_CRIT_ATT_P) -> #attr_base.crit_att_p;
get_key_map(?UPDATE_KEY_HIT_P) -> #attr_base.hit_p;
get_key_map(?UPDATE_KEY_DODGE_P) -> #attr_base.dodge_p;
get_key_map(?UPDATE_KEY_DAMAGE_DEEPEN_P) -> #attr_base.damage_deepen_p;
get_key_map(?UPDATE_KEY_DAMAGE_REDUCTION_P) -> #attr_base.damage_reduction_p;
get_key_map(?UPDATE_KEY_HOLY_P) -> #attr_base.holy_p;
get_key_map(?UPDATE_KEY_SKILL_ADD_P) -> #attr_base.skill_add_p;
get_key_map(?UPDATE_KEY_M_HIT_P) -> #attr_base.m_hit_p;
get_key_map(?UPDATE_KEY_M_DODGE_P) -> #attr_base.m_dodge_p;
get_key_map(?UPDATE_KEY_HP_RECOVER_P) -> #attr_base.hp_recover_p;
get_key_map(?UPDATE_KEY_MP_RECOVER_P) -> #attr_base.mp_recover_p;
get_key_map(?UPDATE_KEY_RESURGENCE_P) -> #attr_base.resurgence_p;
get_key_map(?UPDATE_KEY_DAMAGE_OFFSET_P) -> #attr_base.damage_offset_p.