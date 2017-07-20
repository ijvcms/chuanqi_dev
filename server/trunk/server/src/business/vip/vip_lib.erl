%%%-------------------------------------------------------------------
%%% @author yubing
%%% @copyright (C) 2016, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 19. 一月 2016 19:18
%%%-------------------------------------------------------------------
-module(vip_lib).


-include("cache.hrl").
-include("record.hrl").
-include("common.hrl").
-include("config.hrl").
-include("proto.hrl").
-include("language_config.hrl").
-include("button_tips_config.hrl").
-include("log_type_config.hrl").

-export([
	add_vip_exp/2,
	get_vip_state/2,
	receive_vip_goods/2,
	get_vip_attributes/2,
	get_vip_hook_exp/2,
	get_vip_fh_num/3,
	get_vip_rank_num/2,
	get_vip_clear_red/3,
	get_vip_store_num/2,
	get_vip_buy_fb_num/2,
	clear_pk/1,
	get_vip_buy_hook_num/2,
	get_vip_1_button_list/1,
	get_vip_2_button_list/1,
	get_vip_3_button_list/1,
	get_vip_4_button_list/1,
	get_vip_5_button_list/1,
	get_vip_6_button_list/1,
	get_vip_7_button_list/1,
	get_vip_8_button_list/1,
	get_vip_9_button_list/1,
	get_vip_10_button_list/1,
	get_vip_11_button_list/1,
	get_vip_12_button_list/1,
	get_vip_13_button_list/1,
	get_vip_14_button_list/1,
	get_vip_15_button_list/1,
	get_vip_hook_num/2,
	check_change_scene/2
]).

%% 添加vip经验
add_vip_exp(PlayerState, VipExp) when is_record(PlayerState, player_state) ->
	Base = PlayerState#player_state.db_player_base,
	NowVipExp = Base#db_player_base.vip_exp + VipExp,

	LastVip = vip_up(NowVipExp, Base#db_player_base.career),

	case LastVip#vip_conf.lv > Base#db_player_base.vip of
		true ->
			Update = #player_state{
				db_player_base = #db_player_base{
					vip = LastVip#vip_conf.lv,
					vip_exp = NowVipExp
				}
			},
			{ok, NewPlayerState2} = player_lib:update_refresh_player(PlayerState, Update),
			check_button_list(NewPlayerState2),
			log_lib:log_fight_player_change(NewPlayerState2, PlayerState, ?LOG_TYPE_VIP_UPGRADE),
			%% buff_base_lib:send_buff_info(NewPlayerState2),
			NewPlayerState2;
		_ ->
			Update = #player_state{
				db_player_base = #db_player_base{
					vip_exp = NowVipExp
				}
			},
			{ok, NewPlayerState2} = player_lib:update_player_state(PlayerState, Update),
			NewPlayerState2
	end;
add_vip_exp(PlayerId, VipExp) ->
	Base = player_base_db:select_row(PlayerId),
	NowVipExp = Base#db_player_base.vip_exp + VipExp,
	LastVip = vip_up(NowVipExp, Base#db_player_base.career),
	case LastVip#vip_conf.lv > Base#db_player_base.vip of
		true ->
			NewBase = Base#db_player_base{
				vip = LastVip#vip_conf.lv,
				vip_exp = NowVipExp
			},
			player_base_cache:update(PlayerId, NewBase);
		_ ->
			NewBase = Base#db_player_base{
				vip_exp = NowVipExp
			},
			player_base_cache:update(PlayerId, NewBase)
	end.

%% 获取vip信息
get_vip_state(PlayerState, VipLv) ->
	Base = PlayerState#player_state.db_player_base,
	case player_vip_cache:select_row(PlayerState#player_state.player_id, VipLv) of
		null ->
			case Base#db_player_base.vip >= VipLv of
				true ->
					0;%%可以领取
				_ ->
					?ERR_VIP_1 %%还未达到vip等级
			end;
		_ ->
			?ERR_VIP_2 %%已经领取过该vip奖励了
	end.

%% 领取VIP奖励
receive_vip_goods(PlayerState, VipLv) ->
	Base = PlayerState#player_state.db_player_base,
	case get_vip_state(PlayerState, VipLv) of
		0 ->
			VipInfo = vip_config:get(VipLv, Base#db_player_base.career),
			Goodslist = VipInfo#vip_conf.goods,
			%% 添加vip物品信息
			case goods_lib_log:add_goods_list(PlayerState, Goodslist, ?LOG_TYPE_VIP) of
				{ok, PlayerState1} ->
					PlayerVipInfo = #db_player_vip{
						vip_lv = VipLv,
						player_id = PlayerState1#player_state.player_id
					},
					player_vip_cache:insert(PlayerVipInfo),
					check_button_list(PlayerState1),
					{ok, PlayerState1, 0};
				{fail, Err} ->
					{ok, PlayerState, Err};
				_ ->
					{ok, PlayerState, ?ERR_VIP_1}
			end;
		Err ->
			{ok, PlayerState, Err}
	end.

%% 获取vip属性增加
get_vip_attributes(Career, VipLv) ->
	VipInfo = vip_config:get(VipLv, Career),
	VipInfo#vip_conf.attr_base.

%% 获取vip挂机经验增加
get_vip_hook_exp(Career, VipLv) ->
	VipInfo = vip_config:get(VipLv, Career),
	VipInfo#vip_conf.hook_exp.


%% 增加原地复活次数
get_vip_fh_num(PlayerId, Career, VipLv) ->
	VipInfo = vip_config:get(VipLv, Career),
	UseFhnum = counter_lib:get_value(PlayerId, ?COUNTER_FH_NUM),
	?INFO("now ~p ~p", [VipInfo#vip_conf.fh_num, UseFhnum]),
	VipInfo#vip_conf.fh_num - UseFhnum.

%% 增加排位赛挑战次数
get_vip_rank_num(Career, VipLv) ->
	VipInfo = vip_config:get(VipLv, Career),
	VipInfo#vip_conf.rank_num.

%% 获得红名清洗次数 ?
get_vip_clear_red(PlayerId, Career, VipLv) ->
	VipInfo = vip_config:get(VipLv, Career),
	UseClearNum = counter_lib:get_value(PlayerId, ?COUNTER_FH_NUM),
	VipInfo#vip_conf.clear_red - UseClearNum.

%% 获取仓库增加格子数据
get_vip_store_num(Career, VipLv) ->
	VipInfo = vip_config:get(VipLv, Career),
	VipInfo#vip_conf.store_num.

%% 获取允许购买副本次数 ?
get_vip_buy_fb_num(Career, VipLv) ->
	VipInfo = vip_config:get(VipLv, Career),
	VipInfo#vip_conf.buy_fb_num.

%% 获取允许购买挂机扫荡次数 ?
get_vip_buy_hook_num(Career, VipLv) ->
	VipInfo = vip_config:get(VipLv, Career),
	VipInfo#vip_conf.buy_hook_num.

%% 获取挂机增加的扫荡次数 ?
get_vip_hook_num(Career, VipLv) ->
	VipInfo = vip_config:get(VipLv, Career),
	VipInfo#vip_conf.hook_num.


%% *************************************
vip_up(Exp, Career) ->
	VipList = [X || X <- vip_config:get_list(), X#vip_conf.career =:= Career, X#vip_conf.exp =< Exp],
	List = lists:keysort(#vip_conf.lv, VipList),
	lists:last(List).

%% 清空pk值
clear_pk(PlayerState) ->
	Base = PlayerState#player_state.db_player_base,
	ClearNum = get_vip_clear_red(PlayerState#player_state.player_id, Base#db_player_base.career, Base#db_player_base.vip),
	case ClearNum > 0 of
		true ->
			GrayTime = util_date:unixtime(),
			NewPkValue = 0,
			NameColour = player_lib:get_name_colour(NewPkValue, GrayTime),
			Update = #player_state{
				gray_time = GrayTime,
				name_colour = NameColour,
				db_player_base = #db_player_base{
					pk_value = NewPkValue
				}
			},
			player_lib:update_player_state(PlayerState, Update);
		_ ->
			{fail, ?ERR_VIP_4}
	end.

%% **********************************
%%
%% 检测装备传送cd
check_change_scene(PlayerState, IsEquip) ->
	case IsEquip of
		1 ->
			case lists:keyfind(?RING_TRANSFER_SKILL, 1, PlayerState#player_state.pass_trigger_skill_list) of
				false ->
					{fail, ?ERR_COMMON_FAIL};
				{SkillId, SkillLv} ->
					#player_state{db_player_base = PlayerBase} = PlayerState,
					#db_player_base{ring_transfer_cd = RingCd} = PlayerBase,
					Now = util_date:unixtime(),
					case Now > RingCd of
						true ->
							#skill_conf{effect_list = [{cd, CDCfg}]} = skill_config:get({SkillId, SkillLv}),
							Update = #player_state{db_player_base = PlayerBase#db_player_base{ring_transfer_cd =
							Now + CDCfg}},
							?INFO("29005 ~p", [CDCfg]),
							{ok, PlayerState1} = player_lib:update_player_state(PlayerState, Update),
							{PlayerState1, null};
						false ->
							{fail, ?ERR_SEND_EQUIP_CD}
					end
			end;
		_ ->
			{PlayerState, {?ITEM_FLYING_SHOES, 1, ?CHANGE_SCENE_TYPE_CHANGE}}
	end.

check_button_list(PlayerState) ->
	DbBase = PlayerState#player_state.db_player_base,
	VipLv = DbBase#db_player_base.vip,
	check_button_list(PlayerState, VipLv).
check_button_list(_PlayerState, 0) ->
	skip;
check_button_list(PlayerState, VipLv) ->
	get_button_list(PlayerState, VipLv),
	check_button_list(PlayerState, VipLv - 1).

get_button_list(PlayerState, VipLv) ->
	case VipLv of
		1 ->
			button_tips_lib:ref_button_tips(PlayerState, ?BTN_VIP_REWARD_1);
		2 ->
			button_tips_lib:ref_button_tips(PlayerState, ?BTN_VIP_REWARD_2);
		3 ->
			button_tips_lib:ref_button_tips(PlayerState, ?BTN_VIP_REWARD_3);
		4 ->
			button_tips_lib:ref_button_tips(PlayerState, ?BTN_VIP_REWARD_4);
		5 ->
			button_tips_lib:ref_button_tips(PlayerState, ?BTN_VIP_REWARD_5);
		6 ->
			button_tips_lib:ref_button_tips(PlayerState, ?BTN_VIP_REWARD_6);
		7 ->
			button_tips_lib:ref_button_tips(PlayerState, ?BTN_VIP_REWARD_7);
		8 ->
			button_tips_lib:ref_button_tips(PlayerState, ?BTN_VIP_REWARD_8);
		9 ->
			button_tips_lib:ref_button_tips(PlayerState, ?BTN_VIP_REWARD_9);
		10 ->
			button_tips_lib:ref_button_tips(PlayerState, ?BTN_VIP_REWARD_10);
		11 ->
			button_tips_lib:ref_button_tips(PlayerState, ?BTN_VIP_REWARD_11);
		12 ->
			button_tips_lib:ref_button_tips(PlayerState, ?BTN_VIP_REWARD_12);
		13 ->
			button_tips_lib:ref_button_tips(PlayerState, ?BTN_VIP_REWARD_13);
		14 ->
			button_tips_lib:ref_button_tips(PlayerState, ?BTN_VIP_REWARD_14);
		15 ->
			button_tips_lib:ref_button_tips(PlayerState, ?BTN_VIP_REWARD_15)
	end.


get_vip_1_button_list(PlayerState) ->
	case get_vip_state(PlayerState, 1) of
		0 ->
			{PlayerState, 1};
		_ ->
			{PlayerState, 0}
	end.

get_vip_2_button_list(PlayerState) ->
	case get_vip_state(PlayerState, 2) of
		0 ->
			{PlayerState, 1};
		_ ->
			{PlayerState, 0}
	end.

get_vip_3_button_list(PlayerState) ->
	case get_vip_state(PlayerState, 3) of
		0 ->
			{PlayerState, 1};
		_ ->
			{PlayerState, 0}
	end.

get_vip_4_button_list(PlayerState) ->
	case get_vip_state(PlayerState, 4) of
		0 ->
			{PlayerState, 1};
		_ ->
			{PlayerState, 0}
	end.

get_vip_5_button_list(PlayerState) ->
	case get_vip_state(PlayerState, 5) of
		0 ->
			{PlayerState, 1};
		_ ->
			{PlayerState, 0}
	end.

get_vip_6_button_list(PlayerState) ->
	case get_vip_state(PlayerState, 6) of
		0 ->
			{PlayerState, 1};
		_ ->
			{PlayerState, 0}
	end.

get_vip_7_button_list(PlayerState) ->
	case get_vip_state(PlayerState, 7) of
		0 ->
			{PlayerState, 1};
		_ ->
			{PlayerState, 0}
	end.

get_vip_8_button_list(PlayerState) ->
	case get_vip_state(PlayerState, 8) of
		0 ->
			{PlayerState, 1};
		_ ->
			{PlayerState, 0}
	end.

get_vip_9_button_list(PlayerState) ->
	case get_vip_state(PlayerState, 9) of
		0 ->
			{PlayerState, 1};
		_ ->
			{PlayerState, 0}
	end.

get_vip_10_button_list(PlayerState) ->
	case get_vip_state(PlayerState, 10) of
		0 ->
			{PlayerState, 1};
		_ ->
			{PlayerState, 0}
	end.

get_vip_11_button_list(PlayerState) ->
	case get_vip_state(PlayerState, 11) of
		0 ->
			{PlayerState, 1};
		_ ->
			{PlayerState, 0}
	end.

get_vip_12_button_list(PlayerState) ->
	case get_vip_state(PlayerState, 12) of
		0 ->
			{PlayerState, 1};
		_ ->
			{PlayerState, 0}
	end.

get_vip_13_button_list(PlayerState) ->
	case get_vip_state(PlayerState, 13) of
		0 ->
			{PlayerState, 1};
		_ ->
			{PlayerState, 0}
	end.

get_vip_14_button_list(PlayerState) ->
	case get_vip_state(PlayerState, 14) of
		0 ->
			{PlayerState, 1};
		_ ->
			{PlayerState, 0}
	end.

get_vip_15_button_list(PlayerState) ->
	case get_vip_state(PlayerState, 15) of
		0 ->
			{PlayerState, 1};
		_ ->
			{PlayerState, 0}
	end.




