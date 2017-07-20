%%%-------------------------------------------------------------------
%%% @author zhengsiying
%%% @copyright (C) 2016, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 27. 二月 2016 上午11:41
%%%-------------------------------------------------------------------
-module(button_tips_lib).

-include("common.hrl").
-include("record.hrl").
-include("proto.hrl").
-include("cache.hrl").
-include("button_tips_config.hrl").

%% API
-export([
	init/1,
	get_all_button_tips_data/1,
	ref_button_tips/2,
	ref_button_tips/3,
	send_button_tips/3,
	ref_button_tips_player_id/2
]).

%% ====================================================================
%% API functions
%% ====================================================================
%% 初始化数据(必须在所有需要统计按钮提示的功能都加载完才能加载)
init(PlayerState) ->
	put_button_tips_dict(dict:new()),
	NewPlayerState = reload_btn_tips(PlayerState),
	NewPlayerState.

%% 获取所有按钮提示
get_all_button_tips_data(PlayerState) ->
	List = button_tips_config:get_list(),
	PlayerId = PlayerState#player_state.player_id,
	List1 =
		[begin
			 Proto = #proto_button_tips{
				 id = Id,
				 num = get_button_tips(PlayerState#player_state.player_id, Id)
			 },
			 update_button_update_time(PlayerId, Id),
			 Proto
		 end || Id <- List],
	?INFO("~p", [List1]),
	net_send:send_to_client(PlayerState#player_state.socket, 9000, #rep_get_button_tips{button_list = List1}).

%% 刷新红点
ref_button_tips_player_id(PlayerId, ButtonId) ->
	case player_lib:get_player_pid(PlayerId) of
		null ->
			skip;
		Pid ->
			gen_server2:apply_async(Pid, {?MODULE, ref_button_tips, [ButtonId]})
	end.

%% 刷新按钮提示
ref_button_tips(PlayerState, ButtonIdList) when is_list(ButtonIdList) ->
	Dict = get_button_tips_dict(),
	case util_data:is_null(Dict) of
		true ->
			{ok, PlayerState};
		_ ->
			F = fun(ButtonId, Acc) ->
				{PlayerState1, UpdateList} = Acc,
				OldNum = get_button_tips(PlayerState#player_state.player_id, ButtonId),
				PlayerState2 = update_button_tips(PlayerState1, ButtonId),
				NewNum = get_button_tips(PlayerState#player_state.player_id, ButtonId),
				case OldNum /= NewNum of
					true ->
						ButtonTipsConf = button_tips_config:get(ButtonId),
						case ButtonTipsConf#button_tips_conf.trigger of
							?BTN_TIPS_TRIGGER_CLIENT ->
								PlayerId = PlayerState#player_state.player_id,
								ButtonTips = #db_button_tips{
									player_id = PlayerId,
									btn_id = ButtonId,
									num = NewNum
								},
								button_tips_cache:update({PlayerId, ButtonId}, ButtonTips);
							_ ->
								skip
						end,
						{PlayerState2, [ButtonId | UpdateList]};
					_ ->
						{PlayerState2, UpdateList}
				end
			end,
			{NewPlayerState, UpdateList} = lists:foldl(F, {PlayerState, []}, ButtonIdList),
			send_button_tips_update(NewPlayerState, UpdateList),
			{ok, NewPlayerState}
	end;
ref_button_tips(PlayerState, ButtonId) ->
	Dict = get_button_tips_dict(),
	case util_data:is_null(Dict) of
		true ->
			{ok, PlayerState};
		_ ->
			OldNum = get_button_tips(PlayerState#player_state.player_id, ButtonId),
			NewPlayerState = update_button_tips(PlayerState, ButtonId),
			NewNum = get_button_tips(PlayerState#player_state.player_id, ButtonId),
			case OldNum /= NewNum of
				true ->
					ButtonTipsConf = button_tips_config:get(ButtonId),
					case ButtonTipsConf#button_tips_conf.trigger of
						?BTN_TIPS_TRIGGER_CLIENT ->
							PlayerId = PlayerState#player_state.player_id,
							ButtonTips = #db_button_tips{
								player_id = PlayerId,
								btn_id = ButtonId,
								num = NewNum
							},
							button_tips_cache:update({PlayerId, ButtonId}, ButtonTips);
						_ ->
							skip
					end,
					send_button_tips_update(PlayerState, ButtonId);
				_ ->
					skip
			end,
			{ok, NewPlayerState}
	end.

%% 刷新按钮提示(一般是前端触发才调用这个方法)
ref_button_tips(PlayerState, ButtonId, Num) ->
	Dict = get_button_tips_dict(),
	case util_data:is_null(Dict) of
		true ->
			{ok, PlayerState};
		_ ->
			OldNum = get_button_tips(PlayerState#player_state.player_id, ButtonId),
			NewPlayerState = update_button_tips(PlayerState, ButtonId, Num),
			NewNum = get_button_tips(PlayerState#player_state.player_id, ButtonId),
			case OldNum /= NewNum of
				true ->
					ButtonTipsConf = button_tips_config:get(ButtonId),
					case ButtonTipsConf#button_tips_conf.trigger of
						?BTN_TIPS_TRIGGER_CLIENT ->
							PlayerId = PlayerState#player_state.player_id,
							ButtonTips = #db_button_tips{
								player_id = PlayerId,
								btn_id = ButtonId,
								num = NewNum
							},
							button_tips_cache:update({PlayerId, ButtonId}, ButtonTips);
						_ ->
							skip
					end,
					send_button_tips_update(PlayerState, ButtonId);
				_ ->
					skip
			end,
			{ok, NewPlayerState}
	end.

%% ====================================================================
%% Internal functions
%% ====================================================================
%% 加载玩家的所有的红点记录
reload_btn_tips(PlayerState) ->
	PlayerId = PlayerState#player_state.player_id,
	%% 获取玩家的红点日志
	List = button_tips_cache:select_all(PlayerId),
	%% 获取红点列表
	BtnList = button_tips_config:get_list(),
	F = fun(ButtonId) ->
		ButtonTipsConf = button_tips_config:get(ButtonId),
		case ButtonTipsConf#button_tips_conf.trigger of
			?BTN_TIPS_TRIGGER_CLIENT ->
				set_button_tips(ButtonId, 1);
			_ ->
				set_button_tips(ButtonId, 0)
		end
	end,
	lists:foreach(F, BtnList),

	F1 = fun(ButtonTips) ->
		#db_button_tips{
			btn_id = ButtonId,
			num = Num
		} = ButtonTips,
		case button_tips_config:get(ButtonId) of
			#button_tips_conf{} = _ ->
				set_button_tips(ButtonId, Num);
			_ ->
				skip
		end
	end,
	lists:foreach(F1, List),

	LoadList = button_tips_config:get_load_list(),
	PlayerState1 = load_btn_tips(LoadList, PlayerState),

	F2 = fun(ButtonTips, Acc) ->
		#db_button_tips{
			btn_id = ButtonId,
			num = Num
		} = ButtonTips,
		dict:store(ButtonId, Num, Acc)
	end,
	OldDict = lists:foldl(F2, dict:new(), List),
	NewDict = get_button_tips_dict(),

	%% 将改动的数据存库(只有前端触发的才需要存库，服务端触发的数据每次都需要重新计算不需要存库)
	F3 = fun(ButtonId, Num) ->
		ButtonTipsConf = button_tips_config:get(ButtonId),
		case ButtonTipsConf#button_tips_conf.trigger of
			?BTN_TIPS_TRIGGER_CLIENT ->
				ButtonTips = #db_button_tips{
					player_id = PlayerId,
					btn_id = ButtonId,
					num = Num
				},
				case dict:find(ButtonId, OldDict) of
					{ok, Num1} ->
						case Num1 /= Num of
							true ->
								button_tips_cache:update({PlayerId, ButtonId}, ButtonTips);
							_ ->
								skip
						end;
					_ ->
						button_tips_cache:insert(ButtonTips)
				end;
			_ ->
				skip
		end
	end,
	dict:map(F3, NewDict),
	PlayerState1.

%% 根据加载顺序列表从叶子端逐层往上加载
%% 加载叶子端数据
load_btn_tips([], PlayerState) ->
	PlayerState;
load_btn_tips([List | T], PlayerState) ->
	F = fun(ButtonId, Acc) ->
		case get_fun(ButtonId) of
			{M, F} ->
				{NewAcc, Num} = M:F(Acc),
				NewNum = check_button_update_time(PlayerState#player_state.player_id, ButtonId, Num),
				set_button_tips(ButtonId, NewNum),
				NewAcc;
			_ ->
				Acc
		end
	end,
	NewPlayerState = lists:foldl(F, PlayerState, List),
	load_btn_tips1(T, NewPlayerState).

%% 根据加载顺序列表从叶子端逐层往上加载
%% 加载树枝和树根数据
load_btn_tips1([], PlayerState) ->
	PlayerState;
load_btn_tips1([List | T], PlayerState) ->
	F = fun(ButtonId) ->
		SunList = button_tips_config:get_sun_list(ButtonId),
		F1 = fun(BtnId, Acc) ->
			N = get_button_tips(PlayerState#player_state.player_id, BtnId),
			Acc + N
		end,
		Num = lists:foldl(F1, 0, SunList),
		set_button_tips(ButtonId, Num)
	end,
	lists:foreach(F, List),
	load_btn_tips1(T, PlayerState).

update_button_tips(PlayerState, ButtonId) ->
	case button_tips_config:get_sun_list(ButtonId) of
		[] ->
			{NewPlayerState, Num} =
				try
					case get_fun(ButtonId) of
						{M, F} ->
							{PlayerState1, N} = M:F(PlayerState),
							N1 = check_button_update_time(PlayerState#player_state.player_id, ButtonId, N),
							{PlayerState1, N1};
						_ ->
							{PlayerState, 0}
					end
				catch
					_Err:_Info ->
						?ERR("~p : ~p~nstacktrace : ~p", [_Err, _Info, erlang:get_stacktrace()]),
						{PlayerState, 0}
				end,
			update_button_tips(NewPlayerState, ButtonId, Num),
			NewPlayerState;
		SunList ->
			F = fun(BtnId, Acc) ->
				N = get_button_tips(PlayerState#player_state.player_id, BtnId),
				Acc + N
			end,
			Num = lists:foldl(F, 0, SunList),
			update_button_tips(PlayerState, ButtonId, Num),
			PlayerState
	end.

update_button_tips(PlayerState, ButtonId, Num) ->
	set_button_tips(ButtonId, Num),
	case button_tips_config:get_parent_list(ButtonId) of
		[] ->
			PlayerState;
		ParentList ->
			F = fun(BtnId, Acc) ->
				update_button_tips(Acc, BtnId)
			end,
			lists:foldl(F, PlayerState, ParentList)
	end.

get_button_tips(_PlayerId, ButtonId) ->
	Dict = get_button_tips_dict(),
	case dict:find(ButtonId, Dict) of
		{ok, V} ->
			V;
		_ ->
			0
	end.

check_button_update_time(PlayerId, ButtonId, V) ->
	ButtonConf = button_tips_config:get(ButtonId),
	case ButtonConf#button_tips_conf.daily_one_count of
		1 ->
			case ets:lookup(?ETS_BUTTON_UPDATE_TIME, {PlayerId, ButtonId}) of
				[R | _] ->
					case R#ets_button_update_time.update_time >= util_date:get_today_unixtime() of
						true ->
							0;
						false ->
							V
					end;
				_ ->
					V
			end;
		_ ->
			V
	end.

update_button_update_time(PlayerId, ButtonId) ->
	ButtonConf = button_tips_config:get(ButtonId),
	case ButtonConf#button_tips_conf.daily_one_count of
		1 ->
			case ets:lookup(?ETS_BUTTON_UPDATE_TIME, {PlayerId, ButtonId}) of
				[R | _] ->
					case R#ets_button_update_time.update_time >= util_date:get_today_unixtime() of
						true ->
							skip;
						false ->
							ets:insert(?ETS_BUTTON_UPDATE_TIME, R#ets_button_update_time{update_time = util_date:unixtime()})
					end;
				_ ->
					R = #ets_button_update_time{
						key = {PlayerId, ButtonId},
						update_time = util_date:unixtime()
					},
					ets:insert(?ETS_BUTTON_UPDATE_TIME, R)

			end;
		_ ->
			skip
	end.

set_button_tips(ButtonId, Num) ->
	Dict = get_button_tips_dict(),
	NewDict = dict:store(ButtonId, Num, Dict),
	put_button_tips_dict(NewDict).

get_button_tips_dict() ->
	get(button_tips_dict).

put_button_tips_dict(Dict) ->
	put(button_tips_dict, Dict).

send_button_tips_update(PlayerState, ButtonIdList) when is_list(ButtonIdList) ->
	PlayerId = PlayerState#player_state.player_id,
	F = fun(ButtonId, Acc) ->
		ParentList = button_tips_config:get_parent_list(ButtonId),
		UpdateList = [ButtonId | ParentList],
		List = [#proto_button_tips{id = Id, num = get_button_tips(PlayerState#player_state.player_id, Id)} || Id <- UpdateList],
		update_button_update_time(PlayerId, ButtonId),
		List ++ Acc
	end,
	ProtoList = lists:foldl(F, [], ButtonIdList),
	Data = #rep_update_button_tips{button_list = ProtoList},
	net_send:send_to_client(PlayerState#player_state.socket, 9001, Data);
send_button_tips_update(PlayerState, ButtonId) ->
	PlayerId = PlayerState#player_state.player_id,
	ParentList = button_tips_config:get_parent_list(ButtonId),
	UpdateList = [ButtonId | ParentList],
	ProtoList = [#proto_button_tips{id = Id, num = get_button_tips(PlayerState#player_state.player_id, Id)} || Id <- UpdateList],
	Data = #rep_update_button_tips{button_list = ProtoList},
	update_button_update_time(PlayerId, ButtonId),
	net_send:send_to_client(PlayerState#player_state.socket, 9001, Data).

send_button_tips(PlayerState, ButtonId, Num) ->
	ParentList = button_tips_config:get_parent_list(ButtonId),
	UpdateList = [ButtonId | ParentList],
	ProtoList = [#proto_button_tips{id = Id, num = Num} || Id <- UpdateList],
	Data = #rep_update_button_tips{button_list = ProtoList},
	net_send:send_to_client(PlayerState#player_state.socket, 9001, Data).

%% 回调函数(函数格式为M:F(PlayerState) -> 返回 {NewPlayerState, Num}).
get_fun(?BTN_INSTANCE_SINGLE) -> {instance_single_lib, get_button_tips};%%
get_fun(?BTN_DAILY_TARGET) -> {function_lib, is_get_active_award};
get_fun(?BTN_TASK_MERIT) -> {function_lib, is_get_merit_task};
get_fun(?BTN_WORSHIP) -> {function_lib, is_get_worship_none};
get_fun(?BTN_ARENA) -> {arena_lib, get_button_tips};
get_fun(?BTN_LOGIN) -> {welfare_active_lib, get_button_login_tips};
get_fun(?BTN_AWARD_ONLINE) -> {welfare_active_lib, get_button_online_tips};
get_fun(?BTN_GUILD_CONTRIBUTION) -> {guild_contribution, get_button_tips};
get_fun(?BTN_GUILD_BOSS) -> {guild_active, get_guild_boss_button_tips};
get_fun(?BTN_GUILD_MJ) -> {guild_active, get_guild_mj_button_tips};
get_fun(?BTN_SBK_MJ) -> {guild_active, get_sbk_mj_button_tips};
get_fun(?BTN_GUILD_APPLY_LIST) -> {guild_lib, get_apply_list_button_tips};
get_fun(?BTN_MAIL) -> {mail_lib, get_button_tips};
get_fun(?BTN_SALE) -> {sale_lib, get_button_tips};
get_fun(?BTN_VIP_REWARD_1) -> {vip_lib, get_vip_1_button_list};
get_fun(?BTN_VIP_REWARD_2) -> {vip_lib, get_vip_2_button_list};
get_fun(?BTN_VIP_REWARD_3) -> {vip_lib, get_vip_3_button_list};
get_fun(?BTN_VIP_REWARD_4) -> {vip_lib, get_vip_4_button_list};
get_fun(?BTN_VIP_REWARD_5) -> {vip_lib, get_vip_5_button_list};
get_fun(?BTN_VIP_REWARD_6) -> {vip_lib, get_vip_6_button_list};
get_fun(?BTN_VIP_REWARD_7) -> {vip_lib, get_vip_7_button_list};
get_fun(?BTN_VIP_REWARD_8) -> {vip_lib, get_vip_8_button_list};
get_fun(?BTN_VIP_REWARD_9) -> {vip_lib, get_vip_9_button_list};
get_fun(?BTN_VIP_REWARD_10) -> {vip_lib, get_vip_10_button_list};
get_fun(?BTN_VIP_REWARD_11) -> {vip_lib, get_vip_11_button_list};
get_fun(?BTN_VIP_REWARD_12) -> {vip_lib, get_vip_12_button_list};
get_fun(?BTN_VIP_REWARD_13) -> {vip_lib, get_vip_13_button_list};
get_fun(?BTN_VIP_REWARD_14) -> {vip_lib, get_vip_14_button_list};
get_fun(?BTN_VIP_REWARD_15) -> {vip_lib, get_vip_15_button_list};
get_fun(?BTN_ACTIVE_WZAD) -> {active_instance_lib, get_active_ad_button_tips};
get_fun(?BTN_ACTIVE_TLDH) -> {active_instance_lib, get_active_tldh_button_tips};
get_fun(?BTN_ACTIVE_SZWW) -> {active_instance_lib, get_active_szww_button_tips};
get_fun(?BTN_HOOK_RAIDS) -> {hook_lib, get_button_tips_hook_raids};
get_fun(?BIN_SBK_REWARD) -> {city_lib, get_button_tips};
get_fun(?BTN_SBK) -> {city_lib, get_button_tips_sbk};
get_fun(?BTN_MONTH_GOODS) -> {charge_lib, get_button_tips};

get_fun(?BIN_SIGN_BTN) -> {sign_lib, get_sign_button};
get_fun(?BIN_SIGN_REWARD) -> {sign_lib, get_sign_reward_button};
get_fun(?BIN_LEVEL_REWARD) -> {welfare_active_lib, get_button_lv_bag_tips};
get_fun(?BTN_ROLE_STAMP_HP) -> {player_mark_lib, check_button_red_by_hp};
get_fun(?BTN_ROLE_STAMP_ATK) -> {player_mark_lib, check_button_red_by_atk};
get_fun(?BTN_ROLE_STAMP_DEF) -> {player_mark_lib, check_button_red_by_def};
get_fun(?BTN_ROLE_STAMP_MDEF) -> {player_mark_lib, check_button_red_by_res};
get_fun(?BTN_ROLE_STAMP_HOLY) -> {player_mark_lib, check_button_red_by_holy};
get_fun(?BTN_ACTIVE_MAC) -> {active_instance_lib, get_active_gwgc_button_tips};
get_fun(?BIN_AUTO_DRINK_RED) -> {set_lib, get_hpmp1_button_tips};
get_fun(?BIN_AUTO_DRINK_BLUE) -> {set_lib, get_hpmp2_button_tips};
get_fun(?BIN_AUTO_DRINK_SUN) -> {set_lib, get_hpmp3_button_tips};
get_fun(?BTN_GUILD_APPLY) -> {guild_lib, get_guild_apply_button_tips};
%% 开服排行
%% get_fun(?BTN_ACTIVE_SERVICE_LV)->{active_service_lib,get_button_tips_lv};
%% get_fun(?BTN_ACTIVE_SERVICE_FIGHT)->{active_service_lib,get_button_tips_fight};
%% get_fun(?BTN_ACTIVE_SERVICE_MEDAL)->{active_service_lib,get_button_tips_medal};
%% get_fun(?BTN_ACTIVE_SERVICE_STREN)->{active_service_lib,get_button_tips_stren};
%% get_fun(?BTN_ACTIVE_SERVICE_WING)->{active_service_lib,get_button_tips_wing};
%% get_fun(?BTN_ACTIVE_SERVICE_CHARGE)->{active_service_lib,get_button_tips_charge};
%% 开服活动
get_fun(?BTN_ACTIVE_SERVICE_EXP) -> {active_service_lib, get_button_tips_charge_by_exp};
get_fun(?BTN_ACTIVE_SERVICE_JADE_SELL) -> {active_service_lib, get_button_tips_jade_sell};
get_fun(?BTN_ACTIVE_SERVICE_MYSTERY_SHOP_SELL) -> {active_service_lib, get_button_tips_mystery_shop_sell};
get_fun(?BTN_ACTIVE_SERVICE_MYSTERY_SHOP_SELL_1) -> {active_service_lib, get_button_tips_mystery_shop_sell_1};
get_fun(?BTN_ACTIVE_SERVICE_BOSS) -> {active_service_lib, get_button_tips_boss};
get_fun(?BTN_LIMIT_WING) -> {goods_lib, get_wing_button_tips};
get_fun(?BTN_ACTIVE_SERVICE_MARK_SHOP) -> {active_service_lib, get_button_tips_mark_shop};
get_fun(?BTN_ACTIVE_SERVICE_STREN_SHOP) -> {active_service_lib, get_button_tips_stren_shop};
get_fun(?BTN_ACTIVE_SERVICE_RANK) -> {active_service_lib, get_button_tips_rank};
get_fun(?BTN_LEGION_APPLY_LIST) -> {legion_lib, get_apply_list_button_tips};

%% 合服活动
get_fun(?BTN_ACTIVE_SERVICE_EXP_MERGE) -> {active_service_merge_lib, get_button_tips_charge_by_exp};
get_fun(?BTN_ACTIVE_SERVICE_STREN_SHOP_MERGE) -> {active_service_merge_lib, get_button_tips_stren_shop};
get_fun(?BTN_ACTIVE_SERVICE_LOGION_MERGE) -> {active_service_merge_lib, get_button_tips_login};
get_fun(?BTN_ACTIVE_SERVICE_FRIST_PAY_MERGE) -> {active_service_merge_lib, get_button_frist_pay};
get_fun(?BTN_ACTIVE_SERVICE_BOSS_MERGE) -> {active_service_merge_lib, get_button_tips_boss};
%%-define(BTN_ACTIVE_CROSS_WZAD, 107). %% 跨服暗殿每天
%%-define(BTN_ACTIVE_CROSS_WZAD_WEEKEND, 108). %% 跨服暗殿周末
%%-define(BTN_ACTIVE_DOUBLE_EXP, 109). %% 全服双倍经验
get_fun(106) -> {active_instance_lib, get_active_ad2_button_tips};
get_fun(107) -> {active_instance_lib, get_active_gfad_button_tips};
get_fun(108) -> {active_instance_lib, get_active_gfad2_button_tips};
get_fun(109) -> {active_instance_lib, get_active_double_exp_button_tips};
get_fun(_) -> null.