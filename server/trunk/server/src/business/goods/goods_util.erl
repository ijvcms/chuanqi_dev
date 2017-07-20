%%%-------------------------------------------------------------------
%%% @author tuhujia
%%% @copyright (C) 2015, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 20. 八月 2015 11:24
%%%-------------------------------------------------------------------
-module(goods_util).

-include("common.hrl").
-include("record.hrl").
-include("proto.hrl").
-include("cache.hrl").
-include("db_record.hrl").
-include("config.hrl").
-include("language_config.hrl").
-include("log_type_config.hrl").

%% API
-export([
	check_cond_list/2,
	check_special_list/2,
	add_reward_list/3,
	delete_cond_list/3,
	delete_special_list/3,
	delete_special_list_jade/3,
	separate_cond/1,
	use_goods_effect/2,
	use_goods_effect/3,
	use_goods_bless_oil/2,
	change_weapon_luck/3,
	change_weapon_luck/4,
	check_blood_bag/1,
	attr_type_list_changed_proto_list/1,
	stack_cond_and_award/2,
	get_bag_goods_list/2,
	get_equips_luck/1,
	merge_goods_list/1,
	check_special_list_jade/2
]).

%% 血包恢复间隔时间
-define(BLOOD_BAG_TIME, 1).
-define(BLOOD_BAG_HP, 100).
-define(BLOOD_BAG_MP, 100).
-define(BLOOD_BAG_SPEND, 200).
-define(BLOOD_BAG_MAX, 999999999).

%% ====================================================================
%% API functions
%% ====================================================================

%% 条件检测
check_cond_list(_State, []) ->
	true;
check_cond_list(State, [H | T]) ->
	case check_cond(State, H) of
		true ->
			check_cond_list(State, T);
		{fail, Reply} ->
			{fail, Reply}
	end.

check_cond(_State, {"goods", GoodsId, Num}) ->
	NowNum = goods_lib:get_goods_num(GoodsId),
	case NowNum >= Num of
		true ->
			true;
		false ->
			{fail, ?ERR_GOODS_NOT_ENOUGH}
	end;
check_cond(State, {"coin", Value}) ->
	PlayerMoney = State#player_state.db_player_money,
	PlayerCoin = PlayerMoney#db_player_money.coin,
	case PlayerCoin >= Value of
		true ->
			true;
		false ->
			{fail, ?ERR_PLAYER_COIN_NOT_ENOUGH}
	end;
check_cond(State, {"jade", Value}) ->
	PlayerMoney = State#player_state.db_player_money,
	PlayerJade = PlayerMoney#db_player_money.jade,
	case PlayerJade >= Value of
		true ->
			true;
		false ->
			{fail, ?ERR_PLAYER_JADE_NOT_ENOUGH}
	end;
check_cond(State, {"gift", Value}) ->
	PlayerMoney = State#player_state.db_player_money,
	PlayerGift = PlayerMoney#db_player_money.gift,
	case PlayerGift >= Value of
		true ->
			true;
		false ->
			{fail, ?ERR_PLAYER_GIFT_NOT_ENOUGH}
	end;
check_cond(State, {"smelt", Value}) ->
	PlayerMoney = State#player_state.db_player_money,
	PlayerSmelt = PlayerMoney#db_player_money.smelt_value,
	case PlayerSmelt >= Value of
		true ->
			true;
		false ->
			{fail, ?ERR_PLAYER_SMELT_NOT_ENOUGH}
	end;
check_cond(State, {"hp_mark_value", Value}) ->
	PlayerMoney = State#player_state.db_player_money,
	MarkValue = PlayerMoney#db_player_money.hp_mark_value,
	case MarkValue >= Value of
		true ->
			true;
		false ->
			{fail, ?ERR_PLAYER_MARK_VALUE_NOT_ENOUGH}
	end;
check_cond(State, {"atk_mark_value", Value}) ->
	PlayerMoney = State#player_state.db_player_money,
	MarkValue = PlayerMoney#db_player_money.atk_mark_value,
	case MarkValue >= Value of
		true ->
			true;
		false ->
			{fail, ?ERR_PLAYER_MARK_VALUE_NOT_ENOUGH}
	end;
check_cond(State, {"def_mark_value", Value}) ->
	PlayerMoney = State#player_state.db_player_money,
	MarkValue = PlayerMoney#db_player_money.def_mark_value,
	case MarkValue >= Value of
		true ->
			true;
		false ->
			{fail, ?ERR_PLAYER_MARK_VALUE_NOT_ENOUGH}
	end;
check_cond(State, {"res_mark_value", Value}) ->
	PlayerMoney = State#player_state.db_player_money,
	MarkValue = PlayerMoney#db_player_money.res_mark_value,
	case MarkValue >= Value of
		true ->
			true;
		false ->
			{fail, ?ERR_PLAYER_MARK_VALUE_NOT_ENOUGH}
	end;
check_cond(_State, _Other) ->
	?DEBUG("Not defined cond arameter in goods_fusion: ~p", [_Other]),
	{fail, ?ERR_COMMON_FAIL}.

%% 检测特殊列表
check_special_list(_State, []) ->
	true;
check_special_list(State, [H | T]) ->
	{GoodsId, Num} = H,
	H1 = get_cond_type(GoodsId, Num),
	case check_cond(State, H1) of
		true ->
			check_special_list(State, T);
		{fail, Reply} ->
			{fail, Reply}
	end.

%% 检测特殊列表 可以用jade替换
check_special_list_jade(_State, []) ->
	true;
check_special_list_jade(State, [H | T]) ->
	{GoodsId, Num} = H,
	NowNum = goods_lib:get_goods_num(GoodsId),
	case NowNum >= Num of
		true ->
			check_special_list_jade(State, T);
		_ ->
			NeeNum = Num - NowNum,
			GoodsConf = goods_config:get(GoodsId),
			NeedJade = GoodsConf#goods_conf.price_jade * NeeNum,
			DbMoney = State#player_state.db_player_money,
			case DbMoney#db_player_money.jade < NeedJade of
				true ->
					{fail, ?ERR_PLAYER_JADE_NOT_ENOUGH};
				_ ->
					true
			end
	end.


get_cond_type(GoodsId, Num) ->
	GoodsConf = goods_lib:get_goods_conf_by_id(GoodsId),
	case GoodsConf#goods_conf.type =:= ?GOODS_TYPE_VALUE of
		true ->
			case GoodsConf#goods_conf.sub_type of
				?SUBTYPE_COIN ->
					{"coin", Num};
				?SUBTYPE_JADE ->
					{"jade", Num};
				?SUBTYPE_GIFT ->
					{"gift", Num};
				?SUBTYPE_HP_MARK_VALUE ->
					{"hp_mark_value", Num};
				?SUBTYPE_ATK_MARK_VALUE ->
					{"atk_mark_value", Num};
				?SUBTYPE_DEF_MARK_VALUE ->
					{"def_mark_value", Num};
				?SUBTYPE_RES_MARK_VALUE ->
					{"res_mark_value", Num}
			end;
		false ->
			{"goods", GoodsId, Num}
	end.


%% 添加奖励(先判断是否背包足够添加道具,再奖励数值)
%% 仅道具合成使用，加记录日志
add_reward_list(State, RewardList, LogType) ->
	[GoodsList, OtherList] = separate_cond(RewardList),
	case goods_lib_log:add_goods_list(State, GoodsList, LogType) of
		{ok, _} ->
			add_other_reward(State, OtherList, LogType);
		{fail, Reply} ->
			{fail, Reply}
	end.

add_other_reward(State, [], _LogType) ->
	{ok, State};
add_other_reward(State, [H | T], LogType) ->
	{ok, State1} = add_reward(State, H, LogType),
	add_other_reward(State1, T, LogType).

add_reward(PS, {"coin", Value}, LogType) ->
	player_lib:incval_on_player_money_log(PS, #db_player_money.coin, Value, false, LogType);
add_reward(PS, {"jade", Value}, LogType) ->
	player_lib:incval_on_player_money_log(PS, #db_player_money.jade, Value, false, LogType);
add_reward(PS, {"smelt", Value}, LogType) ->
	player_lib:incval_on_player_money_log(PS, #db_player_money.smelt_value, Value, false, LogType);
add_reward(PS, _Other, _LogType) ->
	?DEBUG("Not defined reward arameter in goods_fusion: ~p", [_Other]),
	{ok, PS}.

%% 扣除条件列表
%% delete_cond_list(State, []) ->
%% 	{ok, State};
%% delete_cond_list(State, [H | T]) ->
%% 	{ok, State1} = delete_cond(State, H, ?LOG_TYPE_FUSION),
%% 	delete_cond_list(State1, T).

%% 扣除条件列表
delete_cond_list(State, [], _LogType) ->
	{ok, State};
delete_cond_list(State, [H | T], LogType) ->
	{ok, State1} = delete_cond(State, H, LogType),
	delete_cond_list(State1, T, LogType).

delete_cond(PS, {"coin", Value}, LogType) ->
	player_lib:incval_on_player_money_log(PS, #db_player_money.coin, -Value, true, LogType);
delete_cond(PS, {"jade", Value}, LogType) ->
	player_lib:incval_on_player_money_log(PS, #db_player_money.jade, -Value, true, LogType);
delete_cond(PS, {"gift", Value}, LogType) ->
	player_lib:incval_on_player_money_log(PS, #db_player_money.gift, -Value, true, LogType);
delete_cond(PS, {"smelt", Value}, LogType) ->
	player_lib:incval_on_player_money_log(PS, #db_player_money.smelt_value, -Value, true, LogType);
delete_cond(PS, {"hp_mark_value", Value}, LogType) ->
	player_lib:incval_on_player_money_log(PS, #db_player_money.hp_mark_value, -Value, false, LogType);
delete_cond(PS, {"atk_mark_value", Value}, LogType) ->
	player_lib:incval_on_player_money_log(PS, #db_player_money.atk_mark_value, -Value, false, LogType);
delete_cond(PS, {"def_mark_value", Value}, LogType) ->
	player_lib:incval_on_player_money_log(PS, #db_player_money.def_mark_value, -Value, false, LogType);
delete_cond(PS, {"res_mark_value", Value}, LogType) ->
	player_lib:incval_on_player_money_log(PS, #db_player_money.res_mark_value, -Value, false, LogType);
delete_cond(PS, {"goods", GoodsId, Num}, LogType) ->
	log_lib:log_goods_change(PS, GoodsId, -Num, LogType),
	case goods_lib:delete_goods_by_num(PS, GoodsId, Num) of
		{ok, PS1} ->
			{ok, PS1};
		_ ->
			{ok, PS}
	end.

%% 扣除特殊条件
%% delete_special_list(State, []) ->
%% 	{ok, State};
%% delete_special_list(State, [H | T]) ->
%% 	{GoodsId, Num} = H,
%% 	H1 = get_cond_type(GoodsId, Num),
%% 	{ok, State1} = delete_cond(State, H1, ?LOG_TYPE_FUSION),
%% 	delete_special_list(State1, T).

%% 扣除特殊条件
delete_special_list(State, [], _LogType) ->
	{ok, State};
delete_special_list(State, [H | T], LogType) ->
	{GoodsId, Num} = H,
	H1 = get_cond_type(GoodsId, Num),
	{ok, State1} = delete_cond(State, H1, LogType),
	delete_special_list(State1, T, LogType).

%% 扣除特殊条件 不足的用元宝替换
delete_special_list_jade(State, [], _LogType) ->
	{ok, State};
delete_special_list_jade(State, [H | T], LogType) ->
	{GoodsId, Num} = H,
	NowNum = goods_lib:get_goods_num(GoodsId),
	case NowNum >= Num of
		true ->
			goods_lib:delete_goods_by_num(State, GoodsId, Num);
		_ ->
			NeedNum = Num - NowNum,
			{ok, State1} = goods_lib:delete_goods_by_num(State, GoodsId, NowNum),
			GoodsConf = goods_config:get(GoodsId),
			NeedJade = GoodsConf#goods_conf.price_jade * NeedNum,
			{ok, State2} = player_lib:incval_on_player_money_log(State1, #db_player_money.jade, -NeedJade, LogType),
			delete_special_list_jade(State2, T, LogType)
	end.

%% 分离条件列表
separate_cond(CondList) ->
	separate_cond(CondList, [], []).
separate_cond([], GoodsList, OtherList) ->
	[GoodsList, OtherList];
separate_cond([H | T], GoodsList, OtherList) ->
	case H of
		{"goods", GoodsId, IsBind, Num} ->
			GoodsList1 = lists:append([{GoodsId, IsBind, Num}], GoodsList),
			separate_cond(T, GoodsList1, OtherList);
		Other ->
			OtherList1 = lists:append(OtherList, [Other]),
			separate_cond(T, GoodsList, OtherList1)
	end.

%% 条件和奖励叠加
stack_cond_and_award(List, N) ->
	Fun = fun(H) ->
		case H of
			{"coin", V} ->
				{"coin", V * N};
			{"jade", V} ->
				{"jade", V * N};
			{"gift", V} ->
				{"gift", V * N};
			{"goods", GoodsId, V} ->
				{"goods", GoodsId, V * N};
			{"goods", GoodsId, IsBind, V} ->
				{"goods", GoodsId, IsBind, V * N};
			_Other ->
				_Other
		end
	end,
	[Fun(X) || X <- List].

%% 道具使用效果
use_goods_effect(State, EffectList) when is_list(EffectList) ->
	use_goods_effect_1(State, EffectList).

use_goods_effect_1(State, []) ->
	{ok, State};
use_goods_effect_1(State, [H | T]) ->
	case use_goods_effect_2(State, H) of
		{ok, State1} ->
			use_goods_effect_1(State1, T);
		{fail, Reply} ->
			{fail, Reply};
		{Spec, State2} ->
			{Spec, State2}
	end.

use_goods_effect_2(State, {add_exp, Val}) ->
	{ok, State1} = player_lib:add_exp(State, Val, {?LOG_TYPE_USE_GOODS, []}),
	{add_exp, State1};
use_goods_effect_2(State, {add_coin, Val}) ->
	{ok, State1} = player_lib:incval_on_player_money_log(State, #db_player_money.coin, Val, false, ?LOG_TYPE_USE_GOODS),
	{ok, State1};
use_goods_effect_2(State, {add_jade, Val}) ->
	{ok, State1} = player_lib:incval_on_player_money_log(State, #db_player_money.jade, Val, false, ?LOG_TYPE_USE_GOODS),
	{ok, State1};
use_goods_effect_2(State, {add_gift, Val}) ->
	{ok, State1} = player_lib:incval_on_player_money_log(State, #db_player_money.gift, Val, false, ?LOG_TYPE_USE_GOODS),
	{ok, State1};
use_goods_effect_2(State, {add_hp_mark_value, Val}) ->
	{ok, State1} = player_lib:incval_on_player_money_log(State, #db_player_money.hp_mark_value, Val, false, ?LOG_TYPE_USE_GOODS),
	player_mark_lib:check_button_red(State1, ?MARK_TYPE_HP),
	{ok, State1};
use_goods_effect_2(State, {add_atk_mark_value, Val}) ->
	{ok, State1} = player_lib:incval_on_player_money_log(State, #db_player_money.atk_mark_value, Val, false, ?LOG_TYPE_USE_GOODS),
	player_mark_lib:check_button_red(State1, ?MARK_TYPE_ATK),
	{ok, State1};
use_goods_effect_2(State, {add_def_mark_value, Val}) ->
	{ok, State1} = player_lib:incval_on_player_money_log(State, #db_player_money.def_mark_value, Val, false, ?LOG_TYPE_USE_GOODS),
	player_mark_lib:check_button_red(State1, ?MARK_TYPE_DEF),
	{ok, State1};
use_goods_effect_2(State, {add_res_mark_value, Val}) ->
	{ok, State1} = player_lib:incval_on_player_money_log(State, #db_player_money.res_mark_value, Val, false, ?LOG_TYPE_USE_GOODS),
	player_mark_lib:check_button_red(State1, ?MARK_TYPE_RES),
	{ok, State1};
use_goods_effect_2(State, {add_dekaron_boss, Val}) ->
	DbPlayerBase = State#player_state.db_player_base,
	ChallengeNum = DbPlayerBase#db_player_base.challenge_num,
	NewChallengeNum = ChallengeNum + Val,
	NewDbPlayerBase = DbPlayerBase#db_player_base{challenge_num = NewChallengeNum},
	NewPlayerState = State#player_state{db_player_base = NewDbPlayerBase},
	{ok, NewPlayerState};
use_goods_effect_2(State, {add_blood_bag, Val}) ->
	DbPlayerBase = State#player_state.db_player_base,
	BloodBag = DbPlayerBase#db_player_base.blood_bag,
	case BloodBag + Val > ?BLOOD_BAG_MAX of
		true -> {fail, ?ERR_BLOOD_BAG_ENOUGH};
		false ->
			NewBloodBag = BloodBag + Val,
			NewDbPlayerBase = DbPlayerBase#db_player_base{blood_bag = NewBloodBag},
			NewPlayerState = State#player_state{db_player_base = NewDbPlayerBase},
			buff_base_lib:send_buff_info(NewPlayerState, NewPlayerState#player_state.buff_dict),
			net_send:send_to_client(State#player_state.socket, 14010, #rep_get_blood_bag{value = NewBloodBag}),
			{ok, NewPlayerState}
	end;
use_goods_effect_2(State, {add_hp, Val}) ->
	DbAttr = State#player_state.db_player_attr,
	CurHp = DbAttr#db_player_attr.cur_hp,
	case CurHp == 0 of
		false ->
			AttrTotal = State#player_state.attr_total,
			MaxHp = AttrTotal#attr_base.hp,
			NewDbAttr = DbAttr#db_player_attr{cur_hp = min(MaxHp, Val + CurHp)},
			{ok, State#player_state{db_player_attr = NewDbAttr}};
		true ->
			{fail, ?ERR_COMMON_FAIL}
	end;
use_goods_effect_2(State, {add_mp, Val}) ->
	DbAttr = State#player_state.db_player_attr,
	CurHp = DbAttr#db_player_attr.cur_hp,
	case CurHp == 0 of
		false ->
			CurMp = DbAttr#db_player_attr.cur_mp,
			AttrTotal = State#player_state.attr_total,
			MaxMp = AttrTotal#attr_base.mp,
			NewDbAttr = DbAttr#db_player_attr{cur_mp = min(MaxMp, Val + CurMp)},
			{ok, State#player_state{db_player_attr = NewDbAttr}};
		true ->
			{fail, ?ERR_COMMON_FAIL}
	end;
use_goods_effect_2(State, {add_hp_p, Val}) ->
	DbAttr = State#player_state.db_player_attr,
	CurHp = DbAttr#db_player_attr.cur_hp,
	case CurHp == 0 of
		false ->
			AttrTotal = State#player_state.attr_total,
			MaxHp = AttrTotal#attr_base.hp,
			AddHp = util_math:floor(Val / ?PERCENT_BASE * MaxHp),
			NewDbAttr = DbAttr#db_player_attr{cur_hp = min(MaxHp, AddHp + CurHp)},
			{ok, State#player_state{db_player_attr = NewDbAttr}};
		true ->
			{fail, ?ERR_COMMON_FAIL}
	end;
use_goods_effect_2(State, {add_mp_p, Val}) ->
	DbAttr = State#player_state.db_player_attr,
	CurHp = DbAttr#db_player_attr.cur_hp,
	case CurHp == 0 of
		false ->
			CurMp = DbAttr#db_player_attr.cur_mp,
			AttrTotal = State#player_state.attr_total,
			MaxMp = AttrTotal#attr_base.mp,
			AddMp = util_math:floor(Val / ?PERCENT_BASE * MaxMp),
			NewDbAttr = DbAttr#db_player_attr{cur_mp = min(MaxMp, AddMp + CurMp)},
			{ok, State#player_state{db_player_attr = NewDbAttr}};
		true ->
			{fail, ?ERR_COMMON_FAIL}
	end;
use_goods_effect_2(State, {learn_skill, SkillId}) ->
	case skill_tree_lib:learn_skill_by_use_goods(State, SkillId, 1) of
		{ok, State1} ->
			{learn_skill, State1};
		Result ->
			Result
	end;
use_goods_effect_2(State, {bag_id, BagId}) ->
	BagConf = bag_config:get(BagId),
	GoodsList = BagConf#bag_conf.goods,
	case goods_lib_log:add_goods_list(State, GoodsList, ?LOG_TYPE_GOOD_EFFECT) of
		{ok, State1} ->
			goods_lib:broadcast_goods_reward(State, GoodsList),
			{ok, State1};
		{fail, Reply} ->
			{fail, Reply}
	end;
use_goods_effect_2(State, {career_bag, BagList}) ->
	DbBase = State#player_state.db_player_base,
	Career = DbBase#db_player_base.career,
	[BagId] = [Y || {X, Y} <- BagList, X =:= Career],
	BagConf = bag_config:get(BagId),
	GoodsList = BagConf#bag_conf.goods,
	case goods_lib_log:add_goods_list(State, GoodsList, ?LOG_TYPE_GOOD_EFFECT) of
		{ok, State1} ->
			goods_lib:broadcast_goods_reward(State, GoodsList),
			{ok, State1};
		{fail, Reply} ->
			{fail, Reply}
	end;
use_goods_effect_2(State, {rand_bag, BagId, RandNum}) ->
	BagConf = bag_config:get(BagId),
	GoodsList = util_rand:get_randlist_in_list(BagConf#bag_conf.goods, RandNum),
	case goods_lib_log:add_goods_list(State, GoodsList, ?LOG_TYPE_GOOD_EFFECT) of
		{ok, State1} ->
			goods_lib:broadcast_goods_reward(State, GoodsList),
			{ok, State1};
		{fail, Reply} ->
			{fail, Reply}
	end;
use_goods_effect_2(State, {rand_bag_1, Num, RandList}) ->
	GoodsList = util_rand:weight_rand_2(Num, RandList),
	case goods_lib_log:add_goods_list(State, GoodsList, ?LOG_TYPE_GOOD_EFFECT) of
		{ok, State1} ->
			goods_lib:broadcast_goods_reward(State, GoodsList),
			{ok, State1#player_state{bag_goods_list = GoodsList}};
		{fail, Reply} ->
			{fail, Reply}
	end;
use_goods_effect_2(State, {rand_bag_2, Num, RandList}) ->
	GoodsList = util_rand:weight_rand_3(Num, RandList),
	GoodsList1 = merge_goods_list2(GoodsList),
	case goods_lib_log:add_goods_list(State, GoodsList1, ?LOG_TYPE_GOOD_EFFECT) of
		{ok, State1} ->
			goods_lib:broadcast_goods_reward(State, GoodsList1),
			{ok, State1};
		{fail, Reply} ->
			{fail, Reply}
	end;
use_goods_effect_2(State, {hp_recover, RecTime, Val, DurationTime}) ->
	DbAttr = State#player_state.db_player_attr,
	CurHp = DbAttr#db_player_attr.cur_hp,
	case CurHp == 0 of
		false ->
			NowTime = util_date:unixtime(),
			goods_dict:update_hp_recover(RecTime, Val, NowTime, NowTime + DurationTime),
			{ok, State};
		true ->
			{fail, ?ERR_COMMON_FAIL}
	end;
use_goods_effect_2(State, {mp_recover, RecTime, Val, DurationTime}) ->
	DbAttr = State#player_state.db_player_attr,
	CurHp = DbAttr#db_player_attr.cur_hp,
	case CurHp == 0 of
		false ->
			NowTime = util_date:unixtime(),
			goods_dict:update_mp_recover(RecTime, Val, NowTime, NowTime + DurationTime),
			{ok, State};
		true ->
			{fail, ?ERR_COMMON_FAIL}
	end;
use_goods_effect_2(State, {clear_pk_value, Value}) ->
	DPB = State#player_state.db_player_base,
	PkValue = DPB#db_player_base.pk_value,
	GrayTime = util_date:unixtime(),
	NewPkValue = max(0, PkValue - Value),
	NameColour = player_lib:get_name_colour(NewPkValue, GrayTime),
	PlayerStateNew = State#player_state{
		gray_time = GrayTime,
		name_colour = NameColour,
		db_player_base = DPB#db_player_base{
			pk_value = NewPkValue
		}
	},
	{ok, PlayerStateNew};
use_goods_effect_2(State, {add_guild_exp, Value}) ->
	PlayerBase = State#player_state.db_player_base,
	GuildId = PlayerBase#db_player_base.guild_id,
	Args = [State, GuildId, Value, 0],
	guild_mod:update_guild(GuildId, fun guild_contribution:update_guild_info_by_donation/4, Args),
	{ok, State};
use_goods_effect_2(State, {add_guild_capital, Value}) ->
	PlayerBase = State#player_state.db_player_base,
	GuildId = PlayerBase#db_player_base.guild_id,
	Args = [State, GuildId, 0, Value],
	guild_mod:update_guild(GuildId, fun guild_contribution:update_guild_info_by_donation/4, Args),
	{ok, State};
use_goods_effect_2(State, {add_guild_contribution, Value}) ->
	guild_contribution:update_player_contribution(State, Value),
	{ok, State};
%% 增加buff
use_goods_effect_2(State, {buff_id, BuffId}) ->
	{ok, State1} = buff_base_lib:trigger(State, BuffId, ?PERCENT_BASE),
	{refuse_attr, State1};
%% 回程道具
use_goods_effect_2(State, {back_city}) ->
	player_lib:back_city(State);
use_goods_effect_2(State, {add_single_boss_time, Value}) ->
	Result = player_instance_lib:add_single_boss_left_time(State, Value),
	scene_send_lib_copy:add_single_boss_left_time(State, Value),
	Result;
%% 升级丹
use_goods_effect_2(State, {upgrade_dan, MinLv, MaxLv, Exp}) ->
	DPB = State#player_state.db_player_base,
	Lv = DPB#db_player_base.lv,
	case Lv < MinLv of
		true ->
			{fail, ?ERR_PLAYER_LV_NOT_ENOUGH};
		false ->
			case Lv >= MinLv andalso Lv =< MaxLv of
				true ->
					UpgradeConf = player_upgrade_config:get(Lv),
					AddExp = UpgradeConf#player_upgrade_conf.need_exp,
					{ok, PS} = player_lib:add_exp(State, AddExp, {?LOG_TYPE_USE_GOODS, []}),
					{add_exp, PS};
				false ->
					{ok, PS} = player_lib:add_exp(State, Exp, {?LOG_TYPE_USE_GOODS, []}),
					{add_exp, PS}
			end
	end;
use_goods_effect_2(_State, _Effect) ->
	?DEBUG("undefined goods effect is:~p~n", [_Effect]),
	{fail, ?ERR_COMMON_FAIL}.

%% 道具使用效果
use_goods_effect(State, Num, EffectList) when is_list(EffectList) ->
	use_goods_effect_1(State, Num, EffectList).

use_goods_effect_1(State, _Num, []) ->
	{ok, State};
use_goods_effect_1(State, Num, [H | T]) ->
	case use_goods_effect_2(State, Num, H) of
		{ok, State1} ->
			use_goods_effect_1(State1, Num, T);
		{fail, Reply} ->
			{fail, Reply};
		{Spec, State2} ->
			{Spec, State2}
	end.

use_goods_effect_2(State, Num, {add_exp, Val}) ->
	{ok, State1} = player_lib:add_exp(State, Num * Val, {?LOG_TYPE_USE_GOODS, []}),
	{add_exp, State1};
use_goods_effect_2(State, Num, {add_coin, Val}) ->
	{ok, State1} = player_lib:incval_on_player_money_log(State, #db_player_money.coin, Num * Val, false, ?LOG_TYPE_USE_GOODS),
	{ok, State1};
use_goods_effect_2(State, Num, {add_jade, Val}) ->
	{ok, State1} = player_lib:incval_on_player_money_log(State, #db_player_money.jade, Num * Val, false, ?LOG_TYPE_USE_GOODS),
	{ok, State1};
use_goods_effect_2(State, Num, {add_gift, Val}) ->
	{ok, State1} = player_lib:incval_on_player_money_log(State, #db_player_money.gift, Num * Val, false, ?LOG_TYPE_USE_GOODS),
	{ok, State1};
use_goods_effect_2(State, Num, {add_hp_mark_value, Val}) ->
	{ok, State1} = player_lib:incval_on_player_money_log(State, #db_player_money.hp_mark_value, Num * Val, false, ?LOG_TYPE_USE_GOODS),
	player_mark_lib:check_button_red(State1, ?MARK_TYPE_HP),
	{ok, State1};
use_goods_effect_2(State, Num, {add_atk_mark_value, Val}) ->
	{ok, State1} = player_lib:incval_on_player_money_log(State, #db_player_money.atk_mark_value, Num * Val, false, ?LOG_TYPE_USE_GOODS),
	player_mark_lib:check_button_red(State1, ?MARK_TYPE_ATK),
	{ok, State1};
use_goods_effect_2(State, Num, {add_def_mark_value, Val}) ->
	{ok, State1} = player_lib:incval_on_player_money_log(State, #db_player_money.def_mark_value, Num * Val, false, ?LOG_TYPE_USE_GOODS),
	player_mark_lib:check_button_red(State1, ?MARK_TYPE_DEF),
	{ok, State1};
use_goods_effect_2(State, Num, {add_res_mark_value, Val}) ->
	{ok, State1} = player_lib:incval_on_player_money_log(State, #db_player_money.res_mark_value, Num * Val, false, ?LOG_TYPE_USE_GOODS),
	player_mark_lib:check_button_red(State1, ?MARK_TYPE_RES),
	{ok, State1};
use_goods_effect_2(State, Num, {add_dekaron_boss, Val}) ->
	DbPlayerBase = State#player_state.db_player_base,
	ChallengeNum = DbPlayerBase#db_player_base.challenge_num,
	NewChallengeNum = ChallengeNum + Num * Val,
	NewDbPlayerBase = DbPlayerBase#db_player_base{challenge_num = NewChallengeNum},
	NewPlayerState = State#player_state{db_player_base = NewDbPlayerBase},
	{ok, NewPlayerState};
use_goods_effect_2(State, Num, {clear_pk_value, Value}) ->
	DPB = State#player_state.db_player_base,
	PkValue = DPB#db_player_base.pk_value,
	GrayTime = util_date:unixtime(),
	NewPkValue = max(0, PkValue - Num * Value),
	NameColour = player_lib:get_name_colour(NewPkValue, GrayTime),
	PlayerStateNew = State#player_state{
		gray_time = GrayTime,
		name_colour = NameColour,
		db_player_base = DPB#db_player_base{
			pk_value = NewPkValue
		}
	},
	{ok, PlayerStateNew};
use_goods_effect_2(State, Num, {add_guild_exp, Value}) ->
	PlayerBase = State#player_state.db_player_base,
	GuildId = PlayerBase#db_player_base.guild_id,
	Args = [State, GuildId, Num * Value, 0],
	guild_mod:update_guild(GuildId, fun guild_contribution:update_guild_info_by_donation/4, Args),
	{ok, State};
use_goods_effect_2(State, Num, {add_guild_capital, Value}) ->
	PlayerBase = State#player_state.db_player_base,
	GuildId = PlayerBase#db_player_base.guild_id,
	Args = [State, GuildId, 0, Num * Value],
	guild_mod:update_guild(GuildId, fun guild_contribution:update_guild_info_by_donation/4, Args),
	{ok, State};
use_goods_effect_2(State, Num, {add_guild_contribution, Value}) ->
	guild_contribution:update_player_contribution(State, Num * Value),
	{ok, State};
use_goods_effect_2(State, Num, {bag_id, BagId}) ->
	BagConf = bag_config:get(BagId),
	GoodsList = BagConf#bag_conf.goods,
	NewGoodsList = [{GoodsId, IsBind, N * Num} || {GoodsId, IsBind, N} <- GoodsList],
	case goods_lib_log:add_goods_list(State, NewGoodsList, ?LOG_TYPE_GOOD_EFFECT) of
		{ok, State1} ->
			{ok, State1};
		{fail, Reply} ->
			{fail, Reply}
	end;
use_goods_effect_2(_State, _Num, _Effect) ->
	?DEBUG("undefined goods effect1 is:~p~n", [_Effect]),
	{fail, ?ERR_COMMON_FAIL}.

%% 特殊道具祝福油
use_goods_bless_oil(normal_bless_oil, State) ->
	%% 判断是否装备武器
	case equips_lib:get_equips_info_from_grid(?SUBTYPE_WEAPON) of
		[] ->
			{fail, ?ERR_NOT_EQUIPS_WEAPON};
		GoodsInfo ->
			Luck = get_equips_luck(GoodsInfo),
			ChangeLuck = get_change_luck(Luck),
			case ChangeLuck =:= 0 of
				true ->
					{fail, ?ERR_BLESS_OIL_NOT_EFFECT};
				false ->
					change_weapon_luck(State, GoodsInfo, ChangeLuck, true)
			end
	end;
use_goods_bless_oil(special_bless_oil, State) ->
	%% 判断是否装备武器
	case equips_lib:get_equips_info_from_grid(?SUBTYPE_WEAPON) of
		[] ->
			{fail, ?ERR_NOT_EQUIPS_WEAPON};
		GoodsInfo ->
			Luck = get_equips_luck(GoodsInfo),
			MaxLuck = lists:max(luck_config:get_list()),
			case Luck >= MaxLuck of
				true ->
					{fail, ?ERR_COMMON_FAIL};
				false ->
					change_weapon_luck(State, GoodsInfo, 1, true)
			end
	end.

%% 改变装备幸运
change_weapon_luck(State, ChangeLuck, Bool) when is_record(State, player_state) ->
	case equips_lib:get_equips_info_from_grid(?SUBTYPE_WEAPON) of
		[] ->
			{fail, ?ERR_NOT_EQUIPS_WEAPON};
		GoodsInfo ->
			change_weapon_luck(State, GoodsInfo, ChangeLuck, Bool)
	end.

change_weapon_luck(State, GoodsInfo, ChangeLuck, Bool) ->
	OldLuck = get_equips_luck(GoodsInfo),
	NewLuck = OldLuck + ChangeLuck,
	Extra = GoodsInfo#db_goods.extra,
	NewExtra = lists:keystore(?EQUIPS_LUCK_KEY, 1, Extra, {?EQUIPS_LUCK_KEY, NewLuck}),
	NewGoodsInfo = GoodsInfo#db_goods{extra = NewExtra},
	goods_lib:update_player_goods_info(State, NewGoodsInfo),

	Result =
		case Bool of
			true ->
				player_lib:update_refresh_player(State, #player_state{});
			false ->
				{ok, State}
		end,
	case Result of
		{ok, StateNew} ->
			log_lib:log_goods_attr_change(StateNew, State, GoodsInfo, NewGoodsInfo, ?LOG_TYPE_EQUIPS_LUCK);
		_ ->
			skip
	end,
	Result.

%% 血量 魔法回复检测(血包, 药品)
check_blood_bag(PlayerState) ->
	goods_dict:add_blood_bag(),
	{ok, PlayerState1} = check_hp_recover(PlayerState),
	{ok, PlayerState2} = check_mp_recover(PlayerState1),
	{ok, PlayerState3} =
		case util_date:unixtime() rem ?PLAYER_RECOVER_CD == 0 of
			true ->
				combat_lib:compute_player_recover(PlayerState2);
			false ->
				{ok, PlayerState2}
		end,

	case goods_dict:get_blood_bag() >= ?BLOOD_BAG_TIME of
		true ->
			DbBase = PlayerState3#player_state.db_player_base,
			BloodBag = DbBase#db_player_base.blood_bag,
			case BloodBag > 0 of
				true ->
					DbAttr = PlayerState3#player_state.db_player_attr,
					AttrTotal = PlayerState3#player_state.attr_total,
					CurHp = DbAttr#db_player_attr.cur_hp,
					MaxHp = AttrTotal#attr_base.hp,
					CurMp = DbAttr#db_player_attr.cur_mp,
					MaxMp = AttrTotal#attr_base.mp,
					case (CurHp == MaxHp andalso CurMp == MaxMp) orelse CurHp == 0 of
						true ->
							{ok, PlayerState3};
						false ->
							NewDbAttr = DbAttr#db_player_attr{
								cur_hp = min(MaxHp, ?BLOOD_BAG_HP + CurHp),
								cur_mp = min(MaxMp, ?BLOOD_BAG_MP + CurMp)
							},
							NewDbBase = DbBase#db_player_base{blood_bag = max(0, BloodBag - ?BLOOD_BAG_SPEND)},
							PlayerState4 = PlayerState3#player_state{
								db_player_attr = NewDbAttr,
								db_player_base = NewDbBase
							},
							%% player_lib:update_player_state(PlayerState, PlayerState1),
							goods_dict:init_blood_bag(),
							{ok, PlayerState4}
					end;
				false ->
					{ok, PlayerState3}
			end;
		false ->
			{ok, PlayerState3}
	end.

%% 检测药品回复
check_hp_recover(PlayerState) ->
	DbAttr = PlayerState#player_state.db_player_attr,
	AttrTotal = PlayerState#player_state.attr_total,
	CurHp = DbAttr#db_player_attr.cur_hp,
	MaxHp = AttrTotal#attr_base.hp,
	case CurHp == 0 orelse CurHp == MaxHp of
		true ->
			{ok, PlayerState};
		false ->
			case goods_dict:get_hp_recover() of
				{RecTime, Val, StartTime, FinishTime} ->
					case StartTime == FinishTime of
						true -> goods_dict:clear_hp_recover();
						false -> goods_dict:update_hp_recover(RecTime, Val, StartTime + 1, FinishTime)
					end,
					case (FinishTime - StartTime) rem RecTime == 0 of
						true ->
							NewDbAttr = DbAttr#db_player_attr{
								cur_hp = min(MaxHp, Val + CurHp)
							},
							PlayerState1 = PlayerState#player_state{
								db_player_attr = NewDbAttr
							},
							{ok, PlayerState1};
						false ->
							{ok, PlayerState}
					end;
				_ ->
					{ok, PlayerState}
			end
	end.
check_mp_recover(PlayerState) ->
	DbAttr = PlayerState#player_state.db_player_attr,
	AttrTotal = PlayerState#player_state.attr_total,
	CurHp = DbAttr#db_player_attr.cur_hp,
	CurMp = DbAttr#db_player_attr.cur_mp,
	MaxMp = AttrTotal#attr_base.mp,
	case CurHp == 0 orelse CurMp == MaxMp of
		true ->
			{ok, PlayerState};
		false ->
			case goods_dict:get_mp_recover() of
				{RecTime, Val, StartTime, FinishTime} ->
					case StartTime == FinishTime of
						true -> goods_dict:clear_mp_recover();
						false -> goods_dict:update_mp_recover(RecTime, Val, StartTime + 1, FinishTime)
					end,
					case (FinishTime - StartTime) rem RecTime == 0 of
						true ->
							NewDbAttr = DbAttr#db_player_attr{
								cur_mp = min(MaxMp, Val + CurMp)
							},
							PlayerState1 = PlayerState#player_state{
								db_player_attr = NewDbAttr
							},
							{ok, PlayerState1};
						false ->
							{ok, PlayerState}
					end;
				_ ->
					{ok, PlayerState}
			end
	end.

%% 属性列表转换为发送纪录
attr_type_list_changed_proto_list(AttrList) ->
	Fun = fun({Id, State, Type, Value}) ->
		#proto_attr_baptize_value
		{
			id = Id,
			state = State,
			key = Type,
			value = Value
		}
	end,
	[Fun(X) || X <- AttrList].

%% 获取礼包道具列表
get_bag_goods_list(PlayerState, GoodsId) ->
	GoodConf = goods_lib:get_goods_conf_by_id(GoodsId),
	case GoodConf#goods_conf.extra of
		[{bag_id, BagId}] ->
			BagConf = bag_config:get(BagId),
			BagConf#bag_conf.goods;
		[{career_bag, BagList}] ->
			DbBase = PlayerState#player_state.db_player_base,
			Career = DbBase#db_player_base.career,
			[BagId] = [Y || {X, Y} <- BagList, X =:= Career],
			BagConf = bag_config:get(BagId),
			BagConf#bag_conf.goods
	end.

%% 道具列表合并
merge_goods_list(List) ->
	merge_goods_list_1([], List).

merge_goods_list_1(List, []) ->
	List;
merge_goods_list_1(List, [{GoodsId, Num} | T]) ->
	case lists:keyfind(GoodsId, 1, List) of
		{_, OldNum} ->
			NewList = lists:keystore(GoodsId, 1, List, {GoodsId, OldNum + Num}),
			merge_goods_list_1(NewList, T);
		_ ->
			NewList = lists:keystore(GoodsId, 1, List, {GoodsId, Num}),
			merge_goods_list_1(NewList, T)
	end.

merge_goods_list2(List) ->
	merge_goods_list_2([], List).

merge_goods_list_2(List, []) ->
	List;
merge_goods_list_2(List, [{GoodsId, IsBind, Num} | T]) ->
	case lists:keyfind(GoodsId, 1, List) of
		{_, IsBind, OldNum} ->
			NewList = lists:keystore(GoodsId, 1, List, {GoodsId, IsBind, OldNum + Num}),
			merge_goods_list_2(NewList, T);
		_ ->
			NewList = lists:keystore(GoodsId, 1, List, {GoodsId, IsBind, Num}),
			merge_goods_list_2(NewList, T)
	end.

%% ====================================================================
%% 内部函数
%% ====================================================================

%% 获取幸运值
get_equips_luck(GoodsInfo) ->
	Extra = GoodsInfo#db_goods.extra,
	case lists:keyfind(?EQUIPS_LUCK_KEY, 1, Extra) of
		{_, Luck} ->
			Luck;
		_ ->
			0
	end.

%% 根据当前幸运数值获取使用祝福油的改变数值
get_change_luck(Luck) ->
	LuckConf = luck_config:get(Luck),
	SuccRate = LuckConf#luck_conf.succ_rate,
	NorRate = LuckConf#luck_conf.nor_rate,
	Rate = util_rand:rand(1, ?PERCENT_BASE),
	if
		SuccRate >= Rate ->
			1;
		SuccRate + NorRate >= Rate ->
			0;
		true ->
			-1
	end.


