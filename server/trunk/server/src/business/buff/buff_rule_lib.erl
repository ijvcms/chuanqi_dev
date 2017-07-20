%%%-------------------------------------------------------------------
%%% @author zhengsiying
%%% @copyright (C) 2015, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 24. 九月 2015 下午8:41
%%%-------------------------------------------------------------------
-module(buff_rule_lib).

-include("common.hrl").
-include("record.hrl").
-include("cache.hrl").
-include("config.hrl").
-include("proto.hrl").

%% API
-export([
	make_extra_info/4,
	check_stack_rule/6,
	check_stack_rule/5,
	attach_effect/4,
	trigger_effect/4
]).

%% ====================================================================
%% API functions
%% ====================================================================
%% 生成buff扩展信息(用于特殊信息存库包括: 1.堆叠规则 2.效果规则 等信息)
make_extra_info(?BUFF_EFFECT_POISON, CasterState, _TargetState, BuffId) ->
	#attr_base{
		min_sc = MinAttr,
		max_sc = MaxAttr
	} = CasterState#combat_obj.attr_total,
	{MinEffect, MaxEffect} = make_attr_extra_info(MinAttr, MaxAttr, BuffId),
	{CasterState#combat_obj.obj_id, MinEffect, MaxEffect};
make_extra_info(?BUFF_EFFECT_CURE, CasterState, _TargetState, BuffId) ->
	#attr_base{
		min_sc = MinAttr,
		max_sc = MaxAttr
	} = CasterState#combat_obj.attr_total,
	make_attr_extra_info(MinAttr, MaxAttr, BuffId);
make_extra_info(_EffectId, _CasterState, _TargetState, _BuffId) ->
	{}.

%% 生成更属性相关的扩展信息
make_attr_extra_info(MinAttr, MaxAttr, BuffId) ->
	BuffConf = buff_config:get(BuffId),
	P = BuffConf#buff_conf.rule,
	MinEffect = max(util_math:floor(MinAttr * P / ?PERCENT_BASE), 1),
	MaxEffect = max(util_math:floor(MaxAttr * P / ?PERCENT_BASE), 1),
	{MinEffect, MaxEffect}.

%% 校验buff堆叠规则(不同的buff类型有不同的堆叠规则)
check_stack_rule(?BUFF_EFFECT_DAMAGE_REDUCTION, _CasterState, _TargetState, _OldBuff, OldBuffId, NewBuffId) ->
	stack_rule_lv_priority(OldBuffId, NewBuffId);
check_stack_rule(?BUFF_EFFECT_ATTR, _CasterState, _TargetState, _OldBuff, OldBuffId, NewBuffId) ->
	stack_rule_lv_priority(OldBuffId, NewBuffId);
check_stack_rule(?BUFF_EFFECT_ATTR_PLUS, _CasterState, _TargetState, _OldBuff, OldBuffId, NewBuffId) ->
	stack_rule_lv_priority(OldBuffId, NewBuffId);
check_stack_rule(?BUFF_EFFECT_POISON, CasterState, _TargetState, OldBuff, _OldBuffId, NewBuffId) ->
	stack_rule_effect_priority(CasterState, OldBuff, NewBuffId);
check_stack_rule(?BUFF_EFFECT_CURE, CasterState, _TargetState, OldBuff, _OldBuffId, NewBuffId) ->
	stack_rule_effect_priority(CasterState, OldBuff, NewBuffId);
check_stack_rule(?BUFF_EFFECT_INVISIBILITY, _CasterState, _TargetState, _OldBuff, OldBuffId, NewBuffId) ->
	stack_rule_lv_priority(OldBuffId, NewBuffId);
check_stack_rule(_EffectId, _CasterState, _TargetState, _OldBuff, _OldBuffId, _NewBuffId) ->
	?STACK_RULE_NOT.

check_stack_rule(?BUFF_EFFECT_EXP, _PlayerState, _OldBuff, OldBuffId, NewBuffId) ->
	stack_rule_effect_same(OldBuffId, NewBuffId);
check_stack_rule(?BUFF_EFFECT_ATTR_PLUS, _PlayerState, _OldBuff, OldBuffId, NewBuffId) ->
	stack_rule_lv_priority(OldBuffId, NewBuffId);
check_stack_rule(_EffectId, _PlayerState, _OldBuff, _OldBuffId, _NewBuffId) ->
	?STACK_RULE_NOT.

%% 等级优先规则(等级高的替换等级低的，同级的新的替换旧的)
stack_rule_lv_priority(OldBuffId, NewBuffId) ->
	Flag1 = OldBuffId div 100,
	Flag2 = NewBuffId div 100,
	Lv1 = OldBuffId rem 100,
	Lv2 = NewBuffId rem 100,
	case Flag1 =:= Flag2 andalso Lv2 >= Lv1 of
		true ->
			?STACK_RULE_REPLACE;
		_ ->
			?STACK_RULE_NOT
	end.

%% 效果优先规则(效果高的替换效果低的，同样效果新的替换旧的)
stack_rule_effect_priority(CasterState, OldBuff, NewBuffId) ->
	{MinAtt, MaxAtt} = case OldBuff#db_buff.extra_info of
						   {Min, Max} ->
							   {Min, Max};
						   {_, Min, Max} ->
							   {Min, Max}
					   end,
	#attr_base{
		min_sc = MinAttr,
		max_sc = MaxAttr
	} = CasterState#combat_obj.attr_total,
	{MinAtt1, MaxAtt1} = make_attr_extra_info(MinAttr, MaxAttr, NewBuffId),
	case MinAtt + MaxAtt =< MinAtt1 + MaxAtt1 of
		true ->
			case OldBuff#db_buff.extra_info of
				{_, _} ->
					{?STACK_RULE_REPLACE, {MinAtt1, MaxAtt1}};
				{ObjId, _, _} ->
					{?STACK_RULE_REPLACE, {ObjId, MinAtt1, MaxAtt1}}
			end;
		_ ->
			?STACK_RULE_NOT
	end.

%% 相同效果buff时间叠加
stack_rule_effect_same(OldBuffId, NewBuffId) ->
	OldBuffConf = buff_config:get(OldBuffId),
	NewBuffConf = buff_config:get(NewBuffId),

	case OldBuffId =:= NewBuffId of
		true ->
			?STACK_RULE_TIME_ACCUMULATION;
		_ ->
			case OldBuffConf#buff_conf.src_id =:= NewBuffConf#buff_conf.src_id andalso
				OldBuffConf#buff_conf.effect_id =:= NewBuffConf#buff_conf.effect_id of
				true ->
					?STACK_RULE_REPLACE;
				_ ->
					?STACK_RULE_NOT
			end
	end.

%% 加和所有同种效果buff
attach_effect(?BUFF_EFFECT_DAMAGE_REDUCTION, {Percent, Value}, _Buff, BuffEffect) ->
	NewP = BuffEffect#buff_effect.effect_p + Percent,
	NewV = BuffEffect#buff_effect.effect_v + Value,
	BuffEffect#buff_effect{effect_p = NewP, effect_v = NewV};
attach_effect(?BUFF_EFFECT_ATTR, EffectList, _Buff, BuffEffect) ->
	AttrChange = BuffEffect#buff_effect.attr_change,
	NewAttrChange = api_attr:attach_attr(EffectList, AttrChange),
	BuffEffect#buff_effect{attr_change = NewAttrChange};
attach_effect(?BUFF_EFFECT_FIRE, {P, V}, _Buff, BuffEffect) ->
	NewP = BuffEffect#buff_effect.effect_p + P,
	NewV = BuffEffect#buff_effect.effect_v + V,
	BuffEffect#buff_effect{effect_p = NewP, effect_v = NewV};
attach_effect(?BUFF_EFFECT_ATTR_PLUS, EffectList, _Buff, BuffEffect) ->
	AttrChange = BuffEffect#buff_effect.attr_change,
	NewAttrChange = api_attr:attach_attr(EffectList, AttrChange),
	BuffEffect#buff_effect{attr_change = NewAttrChange};
attach_effect(_EffectFlag, _, _Buff, BuffEffect) ->
	BuffEffect#buff_effect{effect_p = 1, effect_v = 1}.

%% 触发buff效果
trigger_effect(?BUFF_EFFECT_POISON, ObjState, Buff, _BuffEffect) ->
	{ObjId, MinAtt, MaxAtt} = Buff#db_buff.extra_info,
	CombatObj = skill_rule_lib:to_combat_obj(ObjState),
	Harm = combat_lib:compute_poison_harm(MinAtt, MaxAtt, CombatObj),
	NewObjState = update_obj_state({harm, Harm}, ObjState),
	NewCombatObj = skill_rule_lib:to_combat_obj(NewObjState),
	Result = #proto_harm{
		obj_flag = #proto_obj_flag{type = CombatObj#combat_obj.obj_type, id = CombatObj#combat_obj.obj_id},
		harm_status = ?HARM_STATUS_NORMAL,
		harm_value = Harm,
		cur_hp = NewCombatObj#combat_obj.cur_hp,
		cur_mp = NewCombatObj#combat_obj.cur_mp
	},

	Result1 = case is_record(ObjState, player_state) of
				  true ->
					  KillObjState =
						  case ObjId > 0 of
							  true ->
								  scene_base_lib:get_scene_obj_state(ObjState#player_state.scene_pid, ?OBJ_TYPE_PLAYER, ObjId);
							  _ ->
								  ObjState
						  end,
					  %% 通知玩家受伤事件
					  gen_server2:cast(ObjState#player_state.pid, {on_harm, Result, KillObjState, true}),
					  null;
				  _ ->
					  Result
			  end,
	{NewObjState, Result1, ObjId};
trigger_effect(?BUFF_EFFECT_CURE, ObjState, Buff, _BuffEffect) ->
	{MinAtt, MaxAtt} = Buff#db_buff.extra_info,
	AddValue =
		case is_record(ObjState, scene_obj_state) of
			true ->
				case ObjState#scene_obj_state.obj_type of
					?OBJ_TYPE_PET ->
						2 * util_rand:rand(MinAtt, MaxAtt);
					_ ->
						util_rand:rand(MinAtt, MaxAtt)
				end;
			false ->
				util_rand:rand(MinAtt, MaxAtt)
		end,
	NewObjState = update_obj_state({cure, AddValue}, ObjState),
	NewCombatObj = skill_rule_lib:to_combat_obj(NewObjState),
	Result = #proto_cure{
		obj_flag = #proto_obj_flag{type = NewCombatObj#combat_obj.obj_type, id = NewCombatObj#combat_obj.obj_id},
		add_hp = AddValue,
		cur_hp = NewCombatObj#combat_obj.cur_hp,
		cur_mp = NewCombatObj#combat_obj.cur_mp
	},
	Result1 = case is_record(ObjState, player_state) of
				  true ->
					  %% 通知玩家受伤事件
					  gen_server2:cast(ObjState#player_state.pid, {on_cure, Result, ObjState}),
					  null;
				  _ ->
					  Result
			  end,
	{NewObjState, Result1}.


%% ====================================================================
%% Internal functions
%% ====================================================================
update_obj_state({harm, Harm}, PlayerState) when is_record(PlayerState, player_state) ->
	DbAttr = PlayerState#player_state.db_player_attr,
	NewHp = max(DbAttr#db_player_attr.cur_hp - Harm, 0),
	NewDbAttr = DbAttr#db_player_attr{cur_hp = NewHp},
	PlayerState#player_state{db_player_attr = NewDbAttr};
update_obj_state({harm, Harm}, SceneObjState) when is_record(SceneObjState, scene_obj_state) ->
	NewHp = max(SceneObjState#scene_obj_state.cur_hp - Harm, 0),
	case NewHp > 0 of
		true ->
			SceneObjState#scene_obj_state{cur_hp = NewHp};
		_ ->
			SceneObjState#scene_obj_state{cur_hp = NewHp, status = ?STATUS_DIE}
	end;
update_obj_state({cure, AddValue}, PlayerState) when is_record(PlayerState, player_state) ->
	Attr = PlayerState#player_state.attr_total,
	DbAttr = PlayerState#player_state.db_player_attr,
	NewHp = min(DbAttr#db_player_attr.cur_hp + AddValue, Attr#attr_base.hp),
	NewDbAttr = DbAttr#db_player_attr{cur_hp = NewHp},
	PlayerState#player_state{db_player_attr = NewDbAttr};
update_obj_state({cure, AddValue}, SceneObjState) when is_record(SceneObjState, scene_obj_state) ->
	Attr = SceneObjState#scene_obj_state.attr_total,
	NewHp = min(SceneObjState#scene_obj_state.cur_hp + AddValue, Attr#attr_base.hp),
	SceneObjState#scene_obj_state{cur_hp = NewHp}.