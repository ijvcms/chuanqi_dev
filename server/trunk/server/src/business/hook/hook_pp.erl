%%%-------------------------------------------------------------------
%%% @author zhengsiying
%%% @copyright (C) 2015, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 26. 八月 2015 上午10:55
%%%-------------------------------------------------------------------
-module(hook_pp).

-include("common.hrl").
-include("record.hrl").
-include("proto.hrl").
-include("cache.hrl").
-include("config.hrl").
-include("language_config.hrl").
-include("button_tips_config.hrl").
%% API
-export([
	handle/3
]).


%% ====================================================================
%% API functions
%% ====================================================================
%% 直接切换挂机场景(不等待回合结束)
handle(13001, PlayerState, Data) ->
	?INFO("13001 ~p", [Data]),
	HookSceneId = Data#req_change_hook_scene.scene_id,
	case hook_lib:check_scene_id(PlayerState, HookSceneId) of
		true ->
			Update = #player_state{
				db_player_base = #db_player_base{hook_scene_id = HookSceneId}
			},
			case player_lib:update_player_state(PlayerState, Update) of
				{ok, PlayerState1} ->
					HookState = player_lib:get_hook_state(),
					case hook_lib:update_drive(PlayerState1, HookState, ?HOOK_DRIVE_CLIENT) of
						{NewPlayerState, HookState1} ->
							scene_mgr_lib:leave_scene(PlayerState, ?LEAVE_SCENE_TYPE_INITIATIVE),

							NewHookState = hook_lib:heartbeat(HookState1),
							player_lib:put_hook_state(NewHookState),

							net_send:send_to_client(NewPlayerState#player_state.socket, 13001, #rep_change_hook_scene{scene_id = HookSceneId}),
							{ok, NewPlayerState#player_state{scene_id = null, scene_pid = null}};
						_ ->
							NewHookState = hook_lib:heartbeat(HookState),
							player_lib:put_hook_state(NewHookState),

							net_send:send_to_client(PlayerState1#player_state.socket, 13001, #rep_change_hook_scene{scene_id = HookSceneId}),
							{ok, PlayerState1#player_state{scene_id = null, scene_pid = null}}
					end;
				_ ->
					skip
			end;
		_ ->
			skip
	end;


%% 获取场景刷怪信息
handle(13002, PlayerState, _Data) ->
	?INFO("13002 ~p", [_Data]),
	HookState = player_lib:get_hook_state(),
	case HookState#hook_state.drive of
		?HOOK_DRIVE_CLIENT ->
			HookState1 = hook_lib:heartbeat(HookState),
			case hook_lib:new_round(PlayerState, HookState1) of
				{ok, NewHookState} ->
					player_lib:put_hook_state(NewHookState),

					MonsterList = hook_lib:get_monster_data(NewHookState),
					MonsterType =
						case NewHookState#hook_state.boss_round of
							true ->
								2;
							_ ->
								1
						end,

					Data = #rep_get_hook_monster{monster_list = MonsterList, monster_type = MonsterType},
					net_send:send_to_client(PlayerState#player_state.socket, 13002, Data);
				_ ->
					NextTime = max(0, HookState#hook_state.next_round_time - util_date:unixtime()),
					Data = #rep_round_result{
						status = 2,
						next_time = NextTime
					},
					net_send:send_to_client(PlayerState#player_state.socket, 13004, Data)
			end;
		_ ->
			skip
	end;

%% 挂机释放技能
handle(13003, PlayerState, Data) ->
	?INFO("13003 ~p", [Data]),
	HookState = player_lib:get_hook_state(),
	case HookState#hook_state.drive of
		?HOOK_DRIVE_CLIENT ->
			HookState1 = hook_lib:heartbeat(HookState),
			#req_hook_use_skill{
				caster_flag = CasterFlag,
				target_point = TargetPoint,
				skill_id = SkillId,
				target_list = TargetList
			} = Data,
			CasterType = CasterFlag#proto_obj_flag.type,
			CasterId = CasterFlag#proto_obj_flag.id,
			TargetFlagList = [{Type, Id} || #proto_obj_flag{type = Type, id = Id} <- TargetList, Type /= ?OBJ_TYPE_PET],
			#proto_point{x = X, y = Y} = TargetPoint,

			case hook_lib:obj_use_skill(PlayerState, HookState1, {CasterType, CasterId}, SkillId, TargetFlagList, {X, Y}) of
				{NewPlayerState, NewHookState} ->
					player_lib:put_hook_state(NewHookState),
					{ok, NewPlayerState};
				_ ->
					skip
			end;
		_ ->
			skip
	end;

%% 获取boss可用挑战次数
handle(13006, PlayerState, _Data) ->
	?INFO("13006 ~p", [_Data]),
	case hook_lib:get_challenge_info(PlayerState) of
		{NewPlayerState, ChallengeNum, NeedJade} ->
			Data = #rep_challenge_num{challenge_num = ChallengeNum, need_jade = NeedJade},
			net_send:send_to_client(NewPlayerState#player_state.socket, 13006, Data),
			{ok, NewPlayerState};
		_ ->
			skip
	end;

%% 挑战boss
handle(13007, PlayerState, Data) ->
	?INFO("13007 ~p", [Data]),
	HookState = player_lib:get_hook_state(),
	case HookState#hook_state.drive of
		?HOOK_DRIVE_CLIENT ->
			HookState1 = hook_lib:heartbeat(HookState),
			HookSceneId = Data#req_challenge_boos.scene_id,
			%% 挑战boss
			case hook_lib:challenge_boos(PlayerState, HookState1, HookSceneId) of
				{NewPlayerState, NewHookState} ->
					player_lib:put_hook_state(NewHookState),
					net_send:send_to_client(NewPlayerState#player_state.socket, 13007, #rep_challenge_boos{scene_id = HookSceneId}),
					{ok, NewPlayerState};
				_ ->
					skip
			end;
		_ ->
			skip
	end;

%% 切换挂机场景(等待回合结束)
handle(13008, PlayerState, Data) ->
	?INFO("13008 ~p", [Data]),
	HookState = player_lib:get_hook_state(),
	case HookState#hook_state.drive of
		?HOOK_DRIVE_CLIENT ->
			HookSceneId = Data#req_change_hook_scene1.scene_id,
			case hook_lib:check_scene_id(PlayerState, HookSceneId) of
				true ->
					HookState1 = hook_lib:heartbeat(HookState),
					Update = #player_state{
						db_player_base = #db_player_base{hook_scene_id = HookSceneId}
					},
					case player_lib:update_player_state(PlayerState, Update) of
						{ok, NewPlayerState} ->
							player_lib:put_hook_state(HookState1),

							net_send:send_to_client(PlayerState#player_state.socket, 13008, #rep_change_hook_scene1{scene_id = HookSceneId}),
							{ok, NewPlayerState};
						_ ->
							skip
					end;
				_ ->
					skip
			end;
		_ ->
			skip
	end;

%% 获取离线报告
handle(13009, PlayerState, _Data) ->
	?INFO("13009 ~p", [_Data]),
	HookReport = hook_lib:get_hook_report(PlayerState, null),
	case HookReport#proto_hook_report.offline_time >= 300 of
		true ->
			net_send:send_to_client(PlayerState#player_state.socket, 13009, #rep_offline_report{hook_report = HookReport});
		_ ->
			skip
	end;

%% 快速挂机 扫荡
handle(13010, PlayerState, Data) ->
	?INFO("13010 ~p", [Data]),

	Times = Data#req_quick_hook.times,

	Base = PlayerState#player_state.db_player_base,
	%% 购买的次数
	BuyHookNum = counter_lib:get_value(PlayerState#player_state.player_id, ?COUNTER_HOOK_BUY_NUM),
	%% 免费的次数上限
	LimitNum = counter_lib:get_limit(?COUNTER_HOOK_NUM),
	%% 已用的次数
	HookNum = counter_lib:get_value(PlayerState#player_state.player_id, ?COUNTER_HOOK_NUM),

	VipNum = vip_lib:get_vip_hook_num(Base#db_player_base.career, Base#db_player_base.vip),
	NewTimes = case Times > LimitNum + VipNum + BuyHookNum - HookNum of
				   true ->
					   LimitNum + VipNum + BuyHookNum - HookNum;
				   _ ->
					   Times
			   end,
	case NewTimes > 0 of
		true ->
			PerTimeCount = 7200 * NewTimes,    %% 每次快速挂机
			GoodsHook = hook_lib:compute_hook_gain(PlayerState, PerTimeCount),%% 计算挂机奖励

			%% 添加次数
			counter_lib:update_value_limit(PlayerState#player_state.player_id, ?COUNTER_HOOK_NUM, NewTimes),
			HookReport = hook_lib:get_hook_report(PlayerState, GoodsHook),
			%% 挂机报告
			SendData = #rep_cur_power{
				need_jade = hook_lib:get_buy_power_need(BuyHookNum),
				remain_times = LimitNum + VipNum + BuyHookNum - (HookNum + NewTimes),
				buy_num = BuyHookNum,
				all_buy_num = vip_lib:get_vip_buy_hook_num(Base#db_player_base.career, Base#db_player_base.vip),
				hook_info = HookReport
			},
			net_send:send_to_client(PlayerState#player_state.socket, 13013, SendData),
			%% 领取挂机奖励
			NewPlayerState1 = hook_lib:receive_hook_draw(PlayerState, GoodsHook),

			%% 刷新挂机红点信息
			button_tips_lib:ref_button_tips(NewPlayerState1, ?BTN_HOOK_RAIDS),
			task_comply:update_player_task_info(NewPlayerState1, ?TASKSORT_BATTLE, NewTimes);
		_ ->
			net_send:send_to_client(PlayerState#player_state.socket, 13010, #rep_quick_hook{result = ?ERR_HOOK_POWER_NOT_ENOUGH})
	end;

%% 领取挂机奖励
handle(13025, PlayerState, _Data) ->
	?INFO("13011 ~p", [_Data]),
	NewPlayerState = hook_lib:receive_hook_draw(PlayerState, null),
	{ok, NewPlayerState};


%% 购买boss挑战次数
handle(13011, PlayerState, _Data) ->
	?INFO("13011 ~p", [_Data]),
	case hook_lib:buy_challenge_num(PlayerState) of
		{NewPlayerState, ChallengeNum, NeedJade} ->
			SendData = #rep_buy_challenge{challenge_num = ChallengeNum, need_jade = NeedJade},
			net_send:send_to_client(PlayerState#player_state.socket, 13011, SendData),
			{ok, NewPlayerState};
		_ ->
			skip
	end;

%% 获取挂机统计
handle(13012, PlayerState, _Data) ->
	?INFO("13012 ~p", [_Data]),
	HookState = player_lib:get_hook_state(),
	HookSceneId = HookState#hook_state.scene_id,
	HookSceneConf = hook_scene_config:get(HookSceneId),

	{SumKill, Exp, Coin} = hook_lib:get_hook_statistics(PlayerState, 3600),
	PerDrop = HookSceneConf#hook_scene_conf.per_drop,
	SendData = #rep_hook_statistics{
		hour_kill_num = SumKill,
		hour_coin_gain = Coin,
		hour_exp_gain = Exp,
		drop_rate = PerDrop
	},
	net_send:send_to_client(PlayerState#player_state.socket, 13012, SendData);

%% 获取当前挂机信息
handle(13013, PlayerState, _Data) ->
	?INFO("130013 ~p", [_Data]),
	Base = PlayerState#player_state.db_player_base,
	%% 购买的次数
	BuyHookNum = counter_lib:get_value(PlayerState#player_state.player_id, ?COUNTER_HOOK_BUY_NUM),
	%% 免费的次数上限
	LimitNum = counter_lib:get_limit(?COUNTER_HOOK_NUM),
	%% 已用的次数
	HookNum = counter_lib:get_value(PlayerState#player_state.player_id, ?COUNTER_HOOK_NUM),
	VipNum = vip_lib:get_vip_hook_num(Base#db_player_base.career, Base#db_player_base.vip),
	SendData = #rep_cur_power{
		need_jade = hook_lib:get_buy_power_need(BuyHookNum),
		remain_times = LimitNum + BuyHookNum + VipNum - HookNum,
		buy_num = BuyHookNum,
		all_buy_num = vip_lib:get_vip_buy_hook_num(Base#db_player_base.career, Base#db_player_base.vip),
		hook_info = #proto_hook_report{}
	},
	net_send:send_to_client(PlayerState#player_state.socket, 13013, SendData);

%% 购买挂机扫荡次数 20160408 aidan 改版挂机系统
handle(13014, PlayerState, _Data) ->
	?ERR("13014 ~p", [111]),
	case hook_lib:buy_power(PlayerState) of
		{ok, NewPlayerState} ->
			%% 更新购买次数信息
			net_send:send_to_client(PlayerState#player_state.socket, 13014, #rep_buy_power{result = 0}),
			%% 刷新红点
			button_tips_lib:ref_button_tips(PlayerState, ?BTN_HOOK_RAIDS),
			{ok, NewPlayerState};
		{fail, Err} ->
			net_send:send_to_client(PlayerState#player_state.socket, 13014, #rep_buy_power{result = Err})
	end;

%% 获取挂机星级列表
handle(13015, PlayerState, _Data) ->
	?INFO("13015 ~p", [_Data]),
	HookStarList = player_hook_star_lib:get_hook_star_list(),
	HookStarRewardList = hook_star_reward_lib:get_hook_star_reward_list(),
	Data = #rep_hook_star_list{
		hook_star_list = HookStarList,
		hook_star_reward_list = HookStarRewardList
	},
	net_send:send_to_client(PlayerState#player_state.socket, 13015, Data);

%% 火墙攻击
handle(13020, PlayerState, Data) ->
	HookState = player_lib:get_hook_state(),
	case HookState#hook_state.drive of
		?HOOK_DRIVE_CLIENT ->
			HookState1 = hook_lib:heartbeat(HookState),
			case hook_lib:fire_wall_attack(PlayerState, HookState1, Data) of
				{NewPlayerState, NewHookState} ->
					player_lib:put_hook_state(NewHookState),
					{ok, NewPlayerState};
				_ ->
					skip
			end;
		_ ->
			skip
	end;

%% 领取挂机星级奖励
handle(13022, PlayerState, Data) ->
	#req_draw_star_reward{
		chapter = Chapter,
		step = Step
	} = Data,
	hook_star_reward_lib:draw_reward(PlayerState, Chapter, Step);

%% 领取首次通关奖励
handle(13024, PlayerState, Data) ->
	#req_draw_first_reward{scene_id = SceneId} = Data,
	player_hook_star_lib:draw_first_prize(PlayerState, SceneId);

handle(Cmd, PlayerState, Data) ->
	?ERR("not define ~p cmd:~nstate: ~p~ndata: ~p", [Cmd, PlayerState, Data]),
	{ok, PlayerState}.

%% ====================================================================
%% Internal functions
%% ====================================================================
