%%%-------------------------------------------------------------------
%%% @author zhengsiying
%%% @copyright (C) 2015, <COMPANY>
%%% @doc
%%%		个人挂机
%%% @end
%%% Created : 04. 八月 2015 下午5:21
%%%-------------------------------------------------------------------
-module(hook_lib).

-include("common.hrl").
-include("record.hrl").
-include("cache.hrl").
-include("config.hrl").
-include("proto.hrl").
-include("language_config.hrl").
-include("log_type_config.hrl").

-define(REVISE_CLIENT_ROUND_TIME, 60). %% 回合修正时间间隔
-define(UPDATE_LAST_HOOK_TIME, 300). %% 更新最后挂机时间间隔(用于记录最后挂机时间，便于离线后上线奖励计算)
-define(HOOK_BOSS_TIME, 2).%% boss击杀后下一轮时间
%% API
-export([
	init/1,
	get_obj/3,
	get_monster_data/1,
	new_round/2,
	refresh_monster/1,
	get_hook_statistics/2,
	compute_hook_gain/2,
	compute_hook_offline/2,
	obj_use_skill/6,
	heartbeat/1,
	on_timer/2,
	check_scene_id/2,
	update_drive/3,
	challenge_boos/3,
	get_hook_report/2,
	get_challenge_info/1,
	buy_challenge_num/1,
	receive_hook_draw/2,
	buy_power/1,
	get_buy_power_need/1,
	update_last_hook_time/2,
	fire_wall_attack/3
]).

-export([get_button_tips_hook_raids/1]).

-record(hook_report, {
	time_count = 0,
	win_num = 0,
	fail_num = 0,
	kill_num = 0,
	coin = 0,
	exp = 0,
	goods_dict = dict:new(),
	sell_coin = 0,
	sell_list = []
}).

%% ====================================================================
%% API functions
%% ====================================================================
%% 初始化挂机信息
init(PlayerState) ->
	PlayerBase = PlayerState#player_state.db_player_base,
	F = fun(SkillId, Skill, Acc) ->
		dict:store(SkillId, Skill#db_skill{next_time = 0}, Acc)
	end,
	SkillDict = dict:fold(F, dict:new(), PlayerState#player_state.skill_dict),
	PlayerAttr = PlayerState#player_state.attr_total,
	PlayerAttr1 = PlayerAttr#attr_base{hp = PlayerAttr#attr_base.hp},
	HookPlayerState = #hook_obj_state{
		obj_id = PlayerState#player_state.player_id,
		obj_type = ?OBJ_TYPE_PLAYER,
		career = PlayerBase#db_player_base.career,
		lv = PlayerBase#db_player_base.lv,
		status = ?STATUS_ALIVE,
		attr_base = PlayerState#player_state.attr_base,
		attr_total = PlayerAttr1,
		buff_dict = dict:new(),
		effect_dict = dict:new(),
		effect_src_dict = dict:new(),
		cur_hp = PlayerAttr1#attr_base.hp,
		cur_mp = PlayerAttr1#attr_base.mp,
		skill_dict = SkillDict,
		order_skill_list = PlayerState#player_state.order_skill_list,
		last_use_skill_time = 0,
		pass_trigger_skill_list = PlayerState#player_state.pass_trigger_skill_list
	},
	#hook_state{
		scene_id = PlayerBase#db_player_base.hook_scene_id,
		hook_player_state = HookPlayerState,
		start_time = 0,
		next_round_time = 0,
		round_status = ?ROUND_STATUS_INIT,
		hook_heartbeat = util_date:unixtime(),
		drive = ?HOOK_DRIVE_CLIENT,
		fire_wall_dict = dict:new(),
		monster_dict = dict:new(),
		fire_wall_uid = util_rand:rand(1000, 10000)
	}.

%% 挂机心跳
heartbeat(HookState) ->
	HookState#hook_state{hook_heartbeat = util_date:unixtime()}.

%% 挂机定时器
on_timer(PlayerState, HookState) ->
	CurTime = util_date:unixtime(),
	HeartbeatTime = HookState#hook_state.hook_heartbeat, %% 挂机心跳，每次收到前端挂机动作都会更新心跳
	EndTime = HookState#hook_state.end_time,
	%% 判断挂机是否由前端驱动
	case HookState#hook_state.drive =:= ?HOOK_DRIVE_CLIENT andalso PlayerState#player_state.scene_id =:= null of
		true ->
			%% 如果是前端驱动，说明玩家在挂机场景
			if
			%% 判断是否是回合结束
				HookState#hook_state.round_status /= ?ROUND_STATUS_END andalso EndTime =< CurTime ->
					%% 回合结束更新挂机状态，并且通知前端
					NewHookState = HookState#hook_state{round_status = ?ROUND_STATUS_END, challenge_boos = false},
					player_lib:put_hook_state(NewHookState),
					%% 回合时间到，还没有通过，说明回合失败
					send_result_to_client(PlayerState, HookState, ?RESULT_STATUS_FAIL),
					case HookState#hook_state.boss_round of
						true ->
							Base = PlayerState#player_state.db_player_base,
							%% 如果是boss回合通知前端回合星数为0星挑战失败
							Data = #rep_challenge_boos_result{status = ?RESULT_STATUS_FAIL, scene_id = Base#db_player_base.hook_scene_id},
							net_send:send_to_client(PlayerState#player_state.socket, 13017, Data);
						_ ->
							skip
					end;
			%% 下面俩条判断都是用于挂机网络不好，丢包或者断网做特殊处理
			%% 太久没收到挂机心跳，导致最后挂机心跳到当前时间超过了最后挂机更新时间间隔，触发最后挂机时间更新
				HeartbeatTime + ?UPDATE_LAST_HOOK_TIME =< CurTime ->
					%% 更新最后挂机时间
					update_last_hook_time(PlayerState, HookState);
			%% 太久没收到挂机心跳，导致最后心跳到当前时间超过了回合修正时间，通知前端回合修正，抛弃旧回合，进入新回合
				HeartbeatTime + ?REVISE_CLIENT_ROUND_TIME =< CurTime ->
					send_result_to_client(PlayerState, HookState, ?RESULT_STATUS_WAIT);
				true ->
					skip
			end;
		_ ->
			%% 服务端驱动挂机，说明玩家当前不在挂机场景，在普通场景
			DbPlayerBase = PlayerState#player_state.db_player_base,
			LastHookTime = DbPlayerBase#db_player_base.last_hook_time,
			DrawHookTime = DbPlayerBase#db_player_base.draw_hook_time,
			TimeCount = min(CurTime - LastHookTime, CurTime - DrawHookTime),

			%% 定时给予玩家挂机奖励并且更新最后挂机时间
			case TimeCount >= 60 of
				true ->
					Update = #player_state{
						db_player_base = #db_player_base{
							last_hook_time = CurTime
						}
					},
					{ok, PlayerState1} = player_lib:update_player_state(PlayerState, Update, false),
					GoodsHook = compute_hook_gain(PlayerState1, TimeCount),%% 计算挂机奖励
					{ok, receive_hook_draw(PlayerState1, GoodsHook)};%% 领取挂机奖励
				_ ->
					skip
			end
	end.

%% 更新最后挂机时间
update_last_hook_time(PlayerState, HookState) ->
	DbPlayerBase = PlayerState#player_state.db_player_base,
	LastHookTime = DbPlayerBase#db_player_base.last_hook_time,
	HeartbeatTime = HookState#hook_state.hook_heartbeat,
	case LastHookTime /= HeartbeatTime of
		true ->
			Update = #player_state{
				db_player_base = #db_player_base{
					last_hook_time = HeartbeatTime
				}
			},
			player_lib:update_player_state(PlayerState, Update, false);
		_ ->
			{ok, PlayerState}
	end.

%% 校验挂机场景id，判断玩家是否可以进入这张场景挂机
check_scene_id(PlayerState, HookSceneId) ->
	DbPlayerBase = PlayerState#player_state.db_player_base,
	PassHookSceneId = DbPlayerBase#db_player_base.pass_hook_scene_id,
	(PassHookSceneId + 1 >= HookSceneId andalso HookSceneId >= ?INIT_HOOK_SCENE_ID) orelse HookSceneId =:= ?INIT_HOOK_SCENE_ID.

%% 挑战boss
challenge_boos(PlayerState, HookState, HookSceneId) ->
	DbPlayerBase = PlayerState#player_state.db_player_base,
	%% 判断是否有挑战次数
	case DbPlayerBase#db_player_base.challenge_num > 0 andalso HookState#hook_state.challenge_boos /= true of
		true ->
			%% 检查是否可以挑战这个场景的boss
			case hook_lib:check_scene_id(PlayerState, HookSceneId) of
				true ->
					%% 所有条件都合法的话，这里只需要更新玩家的挂机场景id，以及更新回合标识
					%% 并不会马上作用于当前回合，作用于下一回合
					Update = #player_state{
						db_player_base = #db_player_base{hook_scene_id = HookSceneId}
					},
					case player_lib:update_player_state(PlayerState, Update) of
						{ok, NewPlayerState} ->
							NewHookState = HookState#hook_state{challenge_boos = true},
							{NewPlayerState, NewHookState};
						_ ->
							skip
					end;
				_ ->
					skip
			end;
		_ ->
			skip
	end.

%% 获取挂机报告
get_hook_report(PlayerState, GoodsHook) ->
	HookReport = case GoodsHook of
					 null ->
						 PlayerState#player_state.hook_report;
					 _ ->
						 GoodsHook
				 end,
	%% 计算挂机得到物品对应品质数量
	F = fun({GoodsId, _}, Num, Acc) ->
		GoodsConf = goods_config:get(GoodsId),
		case GoodsConf#goods_conf.type =:= ?EQUIPS_TYPE of
			true ->
				Quality = GoodsConf#goods_conf.quality,
				case dict:find(Quality, Acc) of
					{ok, Num1} ->
						NewNum = Num1 + Num,
						dict:store(Quality, NewNum, Acc);
					_ ->
						dict:store(Quality, Num, Acc)
				end;
			false ->
				Acc
		end
	end,
	QualityDict = dict:fold(F, dict:new(), HookReport#hook_report.goods_dict),

	F1 =
		fun(Quality, Num, Acc) ->
			[#proto_goods_report{quality = Quality, num = Num, sale_num = 0} | Acc]
		end,
	GoodsReportList = dict:fold(F1, [], QualityDict),

	%% 计算挂机出售物品对应品质数量
	F2 =
		fun({Quality, Num}, Acc) ->
			case lists:keyfind(Quality, #proto_goods_report.quality, Acc) of
				#proto_goods_report{} = R ->
					lists:keyreplace(Quality, #proto_goods_report.quality, Acc, R#proto_goods_report{sale_num = Num});
				_ ->
					Acc
			end
		end,
	GoodsReportList1 = lists:foldl(F2, GoodsReportList, HookReport#hook_report.sell_list),

	%% 计算挂机活的物品
	F3 =
		fun({GoodsId, _}, Num, Acc) ->
			[#proto_hook_drop{goods_id = GoodsId, num = Num} | Acc]
		end,
	GoodsList = dict:fold(F3, [], HookReport#hook_report.goods_dict),

	%% 返回估计统计
	#proto_hook_report{
		offline_time = HookReport#hook_report.time_count,
		kill_num = HookReport#hook_report.kill_num,
		die_num = HookReport#hook_report.fail_num,
		coin = HookReport#hook_report.coin + HookReport#hook_report.sell_coin,
		exp = HookReport#hook_report.exp,
		goods_report_list = GoodsReportList1,
		goods_list = GoodsList
	}.

%% 更新挂机驱动
update_drive(PlayerState, HookState, DriveStatus) ->
	case HookState#hook_state.drive /= DriveStatus of
		true ->
			NewPlayerState =
				case DriveStatus of
					?HOOK_DRIVE_SERVER ->
						%% 如果新驱动是服务器驱动说明玩家已经离开挂机场景，立刻更新最后挂机时间
						Update = #player_state{
							db_player_base = #db_player_base{
								last_hook_time = util_date:unixtime()
							}
						},
						{ok, PlayerState1} = player_lib:update_player_state(PlayerState, Update),
						PlayerState1;
					_ ->
						PlayerState
				end,
			%% ?INFO("update state: ~p", [DriveStatus]),
			{NewPlayerState, HookState#hook_state{drive = DriveStatus}};
		_ ->
			skip
	end.

%% 获取挂机对象
get_obj(HookState, ObjType, ObjId) ->
	try
		case ObjType of
			?OBJ_TYPE_PLAYER ->
				HookState#hook_state.hook_player_state;
			?OBJ_TYPE_MONSTER ->
				MonsterDict = HookState#hook_state.monster_dict,
				case dict:find(ObjId, MonsterDict) of
					{ok, ObjState} ->
						ObjState;
					_ ->
						null
				end;
			?OBJ_TYPE_PET ->
				HookState#hook_state.hook_pet_state;
			_ ->
				null
		end
	catch
		Error:Info ->
			?ERR("~p:~p ~p ~p ~p", [Error, Info, HookState#hook_state.scene_id, ObjType, ObjId]),
			null
	end.


%% 获取挂机怪物信息
get_monster_data(HookState) ->
	F = fun(_K, Obj, Acc) ->
		[make_proto_hook_monster(Obj, null) | Acc]
	end,
	dict:fold(F, [], HookState#hook_state.monster_dict).

%% 获取boss挑战信息
get_challenge_info(PlayerState) ->
	get_challenge_info(PlayerState, true).

%% 获取boss挑战信息
get_challenge_info(PlayerState, IsSendUpdate) ->
	DbPlayerBase = PlayerState#player_state.db_player_base,
	#db_player_base{
		challenge_num = ChallengeNum,
		buy_challenge_num = BuyChallengeNum,
		reset_challenge_time = ResetTime
	} = DbPlayerBase,
	CurTime = util_date:unixtime(),

	case ResetTime =< CurTime of
		true ->
			Update = #player_state{
				db_player_base = #db_player_base{
					challenge_num = ?INIT_CHALLENGE_NUM,
					buy_challenge_num = 0,
					reset_challenge_time = util_date:get_tomorrow_unixtime()
				}
			},
			{ok, NewPlayerState} = player_lib:update_player_state(PlayerState, Update, IsSendUpdate),
			{NewPlayerState, ?INIT_CHALLENGE_NUM, 50};
		_ ->
			{PlayerState, ChallengeNum, util_math:floor((BuyChallengeNum + 1) * 50)}
	end.

%% 购买boss挑战次数
buy_challenge_num(PlayerState) ->
	{PlayerState1, ChallengeNum, NeedJade} = get_challenge_info(PlayerState, false),
	DbPlayerMoney = PlayerState1#player_state.db_player_money,
	case DbPlayerMoney#db_player_money.jade >= NeedJade of
		true ->
			case player_lib:incval_on_player_money_log(PlayerState1, #db_player_money.jade, -NeedJade, false, ?LOG_TYPE_BUY_CHALLENGE) of
				{ok, PlayerState2} ->
					DbPlayerBase = PlayerState2#player_state.db_player_base,
					NewBuyChallengeNum = DbPlayerBase#db_player_base.buy_challenge_num + 1,
					NewChallengeNum = ChallengeNum + 1,
					Update = #player_state{
						db_player_base = #db_player_base{
							challenge_num = NewChallengeNum,
							buy_challenge_num = NewBuyChallengeNum
						}
					},
					{ok, NewPlayerState} = player_lib:update_player_state(PlayerState2, Update, false),
					player_lib:send_update(PlayerState, NewPlayerState, ?UPDATE_CAUSE_OTHER),
					{NewPlayerState, NewChallengeNum, util_math:floor((NewBuyChallengeNum + 1) * 50)};
				_ ->
					skip
			end;
		_ ->
			skip
	end.

%% 生成新回合
new_round(PlayerState, HookState) ->
	CurTime = util_date:unixtime(),
	#hook_state{
		next_round_time = NextTime,
		round_status = Status,
		end_time = EndTime,
		challenge_boos = ChallengeBoss
	} = HookState,
	case NextTime =< CurTime andalso (Status /= ?ROUND_STATUS_START orelse EndTime =< CurTime) of
		true ->
			HookState1 = init(PlayerState),
			HookState2 = HookState1#hook_state{start_time = CurTime, challenge_boos = HookState#hook_state.challenge_boos},

			HookSceneConf = hook_scene_config:get(HookState2#hook_state.scene_id),
			%% 根据回合标识刷出对应怪物
			{HookState4, MinRoundTime} =
				case ChallengeBoss of
					true ->
						%% 刷出boss
						HookState3 = refresh_boss(HookState2#hook_state{end_time = CurTime + HookSceneConf#hook_scene_conf.limit_time}),
						{HookState3, ?HOOK_BOSS_TIME};
					_ ->
						%% 刷出小怪
						HookState3 = refresh_monster(HookState2#hook_state{end_time = CurTime + 600}),
						{HookState3, HookSceneConf#hook_scene_conf.min_round_time}
				end,
			NewHookState = HookState4#hook_state{next_round_time = CurTime + MinRoundTime},
			{ok, NewHookState};
		_ ->
			{fail, 1}
	end.

%% 刷新挂机怪物
refresh_monster(HookState) ->
	SceneId = HookState#hook_state.scene_id,
	HookSceneConf = hook_scene_config:get(SceneId),
	MinNum = HookSceneConf#hook_scene_conf.min_monster_num,
	MaxNum = HookSceneConf#hook_scene_conf.max_monster_num,
	Count = util_rand:rand(MinNum, MaxNum),
	MonsterList = HookSceneConf#hook_scene_conf.monster_list,
	CurTime = util_date:unixtime(),
	SeedId = util_rand:rand(CurTime - 1000, CurTime),
	MonsterDict = add_monster(Count, MonsterList, dict:new(), SeedId),
	NewHookState = HookState#hook_state{
		monster_dict = MonsterDict
	},
	NewHookState.

%% 刷新挂机boss
refresh_boss(HookState) ->
	SceneId = HookState#hook_state.scene_id,
	HookSceneConf = hook_scene_config:get(SceneId),

	MonsterId = HookSceneConf#hook_scene_conf.boss_id,
	MonsterConf = monster_config:get(MonsterId),
	MonsterAttr = MonsterConf#monster_conf.attr_base,

	F = fun(SkillId, Acc) ->
		dict:store(SkillId, #db_skill{skill_id = SkillId, lv = 1, next_time = 0}, Acc)
	end,
	SkillDict = lists:foldl(F, dict:new(), MonsterConf#monster_conf.hook_skill_list),

	CurTime = util_date:unixtime(),
	MonsterUid = util_rand:rand(CurTime - 1000, CurTime),
	ObjState = #hook_obj_state{
		obj_id = MonsterUid,
		obj_type = ?OBJ_TYPE_MONSTER,
		monster_id = MonsterId,
		status = ?STATUS_ALIVE,
		is_boss = true,
		last_use_skill_time = 0,
		attr_base = MonsterAttr,
		attr_total = MonsterAttr,
		cur_hp = MonsterAttr#attr_base.hp,
		cur_mp = MonsterAttr#attr_base.mp,
		lv = MonsterConf#monster_conf.lv,
		career = MonsterConf#monster_conf.career,
		order_skill_list = MonsterConf#monster_conf.hook_skill_list,
		skill_dict = SkillDict,
		buff_dict = dict:new(),
		effect_dict = dict:new(),
		effect_src_dict = dict:new(),
		is_drop = false
	},
	NewDict = dict:store(MonsterUid, ObjState, dict:new()),
	HookState#hook_state{
		monster_dict = NewDict,
		boss_round = true
	}.

%% 创建宠物（挂机创建）
create_pet(HookState, MonsterId) ->
	HookPlayerState = HookState#hook_state.hook_player_state,
	OwnerLv = HookPlayerState#hook_obj_state.lv,
	MonsterConf = monster_config:get(MonsterId),
%% 	MonsterAttr = obj_pet_lib:make_attr(MonsterId, Lv),
	MonsterAttr = api_attr:addition_attr(MonsterConf#monster_conf.attr_base, OwnerLv / 100),
	F = fun(SkillId, Acc) ->
		dict:store(SkillId, #db_skill{skill_id = SkillId, lv = 1, next_time = 0}, Acc)
	end,
	SkillDict = lists:foldl(F, dict:new(), MonsterConf#monster_conf.hook_skill_list),
	ObjState = #hook_obj_state{
		obj_id = HookPlayerState#hook_obj_state.obj_id,
		obj_type = ?OBJ_TYPE_PET,
		monster_id = MonsterId,
		status = ?STATUS_ALIVE,
		last_use_skill_time = 0,
		attr_base = MonsterAttr,
		attr_total = MonsterAttr,
		cur_hp = MonsterAttr#attr_base.hp,
		cur_mp = MonsterAttr#attr_base.mp,
		lv = MonsterConf#monster_conf.lv,
		career = MonsterConf#monster_conf.career,
		order_skill_list = MonsterConf#monster_conf.hook_skill_list,
		skill_dict = SkillDict,
		buff_dict = dict:new(),
		effect_dict = dict:new(),
		effect_src_dict = dict:new()
	},
	HookState1 = HookState#hook_state{
		hook_pet_state = ObjState,
		hook_player_state = HookPlayerState#hook_obj_state{pet_id = HookPlayerState#hook_obj_state.obj_id}
	},
	{HookState1, ObjState}.

%% 创建火墙（挂机火墙）
make_fire_wall(HookState, Percent, EffectiveTime, Interval, {X, Y}) ->
	HookPlayerState = HookState#hook_state.hook_player_state,
	Attr = HookPlayerState#hook_obj_state.attr_total,
	CurTime = util_date:unixtime(),
	PointList = [{X, Y}, {X + 1, Y}, {X - 1, Y}, {X, Y + 1}, {X, Y - 1}],
	F = fun({X1, Y1}, Acc) ->
		{HookState1, FireWallList} = Acc,
		Uid = HookState1#hook_state.fire_wall_uid + 1,
		FireWallDict = HookState1#hook_state.fire_wall_dict,
		State = #fire_wall_state{
			uid = Uid,
			min_att = util_math:floor(Attr#attr_base.min_mac * Percent / ?PERCENT_BASE),
			max_att = util_math:floor(Attr#attr_base.max_mac * Percent / ?PERCENT_BASE),
			interval = Interval,
			next_time = CurTime,
			remove_time = CurTime + EffectiveTime
		},
		NewFireWallDict = dict:store(Uid, State, FireWallDict),
		HookState2 = HookState1#hook_state{fire_wall_dict = NewFireWallDict, fire_wall_uid = Uid},

		ProtoFireWall = #proto_hook_fire_wall{
			obj_flag = #proto_obj_flag{type = ?OBJ_TYPE_FIRE_WALL, id = Uid},
			point = #proto_point{x = X1, y = Y1},
			interval = Interval,
			duration = EffectiveTime
		},
		NewFireWallList = [ProtoFireWall | FireWallList],
		{HookState2, NewFireWallList}
	end,
	lists:foldl(F, {HookState, []}, PointList).

%% 发送挂机结果给前端
send_result_to_client(PlayerState, HookState, ResultStatus) ->
	NextTime = max(5, HookState#hook_state.next_round_time - util_date:unixtime()),
	Data1 = #rep_round_result{
		status = ResultStatus,
		next_time = NextTime
	},
	net_send:send_to_client(PlayerState#player_state.socket, 13004, Data1).

%% 挂机对象使用技能，玩家和怪物使用技能都由客户端发送，服务器只做伤害结果计算
obj_use_skill(PlayerState, HookState, {CasterType, CasterId}, SkillId, TargetFlagList, {X, Y}) ->
	case skill_base_lib:hook_use_skill(HookState, {CasterType, CasterId}, SkillId, TargetFlagList) of
		{ok, UpdateDict, EffectProto} ->
			{NewPlayerState, HookState1} = update_obj_state(UpdateDict, PlayerState, HookState),

			#hook_state{
				hook_player_state = HookPlayerState,
				monster_dict = MonsterDict
			} = HookState1,

			%% 发送技能效果
			Data = #rep_hook_use_skill{
				harm_list = EffectProto#skill_effect.harm_list,
				cure_list = EffectProto#skill_effect.cure_list,
				buff_list = EffectProto#skill_effect.buff_list
			},

			net_send:send_to_client(PlayerState#player_state.socket, 13003, Data),

			%% 如果使用的技能是召唤宠物
			_NewHookState0 =
				case EffectProto#skill_effect.call_pet of
					PetId when is_integer(PetId) ->
						%% 生成宠物并通知前端
						{HookState2, PetObj} = create_pet(HookState1, PetId),
						AddObjData = #rep_add_hook_obj{
							hook_obj_list = [make_proto_hook_monster(PetObj, PlayerState)]
						},
						net_send:send_to_client(NewPlayerState#player_state.socket, 13018, AddObjData),
						HookState2;
					_ ->
						HookState1
				end,

			%% 如果技能需要移除buff，执行移除buff操作
			_NewHookState1 =
				case EffectProto#skill_effect.remove_effect of
					{ObjType, ObjId, EffectId} ->
						case get_obj(_NewHookState0, ObjType, ObjId) of%%
							#hook_obj_state{} = ObjState ->
								{NewObjState, RemoveBuffList} = buff_base_lib:remove_effect_buff(ObjState, EffectId),
								{_, HookState3} = update_obj_state(NewObjState, NewPlayerState, _NewHookState0),
								MakeProtoF =
									fun(BuffId, Acc) ->
										Proto = #proto_buff_operate{
											obj_flag = #proto_obj_flag{type = ObjType, id = ObjId},
											operate = ?BUFF_OPERATE_DELETE,
											buff_id = BuffId,
											effect_id = EffectId
										},
										[Proto | Acc]
									end,
								List = lists:foldl(MakeProtoF, [], RemoveBuffList),
								net_send:send_to_client(NewPlayerState#player_state.socket, 13021, #rep_hook_buff_operate{buff_list = List}),
								HookState3;
							_ ->
								_NewHookState0
						end;
					_ ->
						_NewHookState0
				end,

			%% 如果是火墙技能，生成火墙
			NewHookState =
				case EffectProto#skill_effect.fire_wall of
					{Percent, EffectiveTime, Interval} ->
						{HookState4, FireWallList} = make_fire_wall(_NewHookState0, Percent, EffectiveTime, Interval, {X, Y}),
						AddFireWallData = #rep_add_hook_fire_wall{
							hook_fire_wall_list = FireWallList
						},
						net_send:send_to_client(NewPlayerState#player_state.socket, 13019, AddFireWallData),
						HookState4;
					_ ->
						_NewHookState0
				end,

			%% 判断是否回合结束
			IsPlayerDie = is_player_die(HookPlayerState), %% 玩家是否死亡
			KillNum = monster_die_num(MonsterDict), %% 杀死怪物数量
			MonsterNum = dict:size(MonsterDict), %% 怪物总数
			{IsEnd, Status} =
				if
					IsPlayerDie =:= true ->
						{true, ?RESULT_STATUS_FAIL};
					KillNum >= MonsterNum ->
						{true, ?RESULT_STATUS_WIN};
					true ->
						{false, ?RESULT_STATUS_FAIL}
				end,

			case IsEnd andalso NewHookState#hook_state.round_status /= ?ROUND_STATUS_END of
				true ->
					%% 发送回合结果
					send_result_to_client(NewPlayerState, NewHookState, Status),
					{NewPlayerState, NewHookState#hook_state{round_status = ?ROUND_STATUS_END}};
				_ ->
					{NewPlayerState, NewHookState}
			end;
		{fail, ?ERR_HOOK_OBJ_NOT} ->
			%% %% ?INFO("~p", [_Err]),
			send_result_to_client(PlayerState, HookState, ?RESULT_STATUS_WAIT),
			skip;
		_Err ->
			%% %% ?INFO("err: ~p", [_Err]),
			skip
	end.

%% 挂机怪物死亡
do_monster_die(PlayerState, HookState, MonsterUid) ->
	case get_obj(HookState, ?OBJ_TYPE_MONSTER, MonsterUid) of%%
		#hook_obj_state{is_drop = false, status = ?STATUS_DIE} = ObjState ->
			#hook_scene_conf{
				per_exp = Exp,
				per_coin = Coin
			} = hook_scene_config:get(HookState#hook_state.scene_id),

			NewObjState = ObjState#hook_obj_state{is_drop = true},
			NewMonsterDict = dict:store(MonsterUid, NewObjState, HookState#hook_state.monster_dict),
			HookState1 = HookState#hook_state{monster_dict = NewMonsterDict},

			%% 发放物品
			DbPlayerBase = PlayerState#player_state.db_player_base,
			Career = DbPlayerBase#db_player_base.career,

			HookSceneConf = hook_scene_config:get(HookState1#hook_state.scene_id),
			GoodsList =
				case NewObjState#hook_obj_state.is_boss of
					true ->
						make_boss_drop(Career, HookSceneConf);
					_ ->
						make_monster_drop(Career, HookSceneConf)
				end,

			%% 发放经验金币  %% vip经验加成
			VipAddExp = vip_lib:get_vip_hook_exp(Career, DbPlayerBase#db_player_base.vip),
			{ok, PlayerState1} = player_lib:add_exp(PlayerState, util_math:floor(Exp * ((100 + VipAddExp) / 100)), {?LOG_TYPE_HOOK, []}),
			{ok, PlayerState2} = player_lib:incval_on_player_money_log(PlayerState1, #db_player_money.coin, Coin, ?LOG_TYPE_HOOK),

			%% 直接把掉落物品加入玩家背包
			{ok, PlayerState3, _SellCoin, _QList} = goods_lib:add_goods_list_and_auto_sell(PlayerState2, GoodsList),
			%% 生成掉落，通知前端（这里的掉落只用于前端显示，生成的瞬间已经加入玩家背包）
			Data = make_rep_drop(MonsterUid, GoodsList),
			net_send:send_to_client(PlayerState3#player_state.socket, 13005, Data),

			case NewObjState#hook_obj_state.is_boss of
				true ->
					{PlayerState4, HookState2} = do_boss_die(PlayerState3, HookState1, HookSceneConf),
					%% boss死亡
					{ok, PlayerState5} = task_comply:update_player_task_info(PlayerState4, ?TASKSORT_BOSS, 1),
					{PlayerState5, HookState2};
				_ ->
					{PlayerState3, HookState1}
			end;
		_ ->
			{PlayerState, HookState}
	end.

%% 计算星级
compute_star(HookState) ->
	CurTime = util_date:unixtime(),
	SceneId = HookState#hook_state.scene_id,
	StartTime = HookState#hook_state.start_time,
	UseTime = CurTime - StartTime,
	#hook_scene_conf{
		star_2_time = Star2Time,
		star_3_time = Star3Time
	} = hook_scene_config:get(SceneId),
	if
		Star3Time >= UseTime -> 3;
		Star3Time < UseTime andalso UseTime =< Star2Time -> 2;
		true -> 1
	end.

%% 挂机boss死亡逻辑
do_boss_die(PlayerState, HookState, HookSceneConf) ->
	DbPlayerBase = PlayerState#player_state.db_player_base,
	PassSceneId = DbPlayerBase#db_player_base.pass_hook_scene_id,
	CurSceneId = HookState#hook_state.scene_id,
	{PlayerState1, ChallengeNum, NeedJade} = get_challenge_info(PlayerState, false),
	NewChallengeNum = ChallengeNum - 1,
	Socket = PlayerState#player_state.socket,

	{NewPlayerState, NewHookState} =
		%% 判断当前所在场景是不是比之前通关的最大场景还要大
	case CurSceneId >= PassSceneId of
		true ->
			%% 如果是，说明玩家是在最大可以挂机场景挑战boss通关，直接把玩家移到下一个场景（在前端不会马上显示，下一回合会移到新场景）
			NewHookSceneId =
				case hook_scene_config:get(CurSceneId + 1) of
					#hook_scene_conf{} = _ ->
						CurSceneId + 1;
					_ ->
						CurSceneId
				end,

			%% 更新最大通过场景为当前场景
			Update = #player_state{
				db_player_base = #db_player_base{
					pass_hook_scene_id = CurSceneId,
					hook_scene_id = NewHookSceneId,
					challenge_num = NewChallengeNum
				}
			},
			{ok, PlayerState2} = player_lib:update_player_state(PlayerState1, Update, false),
			GoodsList = [{GoodsId, ?BIND, Num} || {GoodsId, Num} <- HookSceneConf#hook_scene_conf.first_prize],
			{ok, PlayerState3} = goods_lib_log:add_goods_list_and_send_mail(PlayerState2, GoodsList, ?LOG_TYPE_HOOK),
			%% 发送结果给前端
			net_send:send_to_client(Socket, 13008, #rep_change_hook_scene1{scene_id = NewHookSceneId}),
			{PlayerState3, HookState#hook_state{scene_id = NewHookSceneId, challenge_boos = false}};
		_ ->
			Update = #player_state{
				db_player_base = #db_player_base{
					challenge_num = NewChallengeNum
				}
			},
			{ok, PlayerState2} = player_lib:update_player_state(PlayerState1, Update, false),
			{PlayerState2, HookState#hook_state{challenge_boos = false}}
	end,
	player_lib:send_update(PlayerState, NewPlayerState, ?UPDATE_CAUSE_OTHER),
	net_send:send_to_client(Socket, 13006, #rep_challenge_num{challenge_num = NewChallengeNum, need_jade = NeedJade}),

	Base = NewPlayerState#player_state.db_player_base,
	%% 计算星级
	Star = compute_star(NewHookState),
	net_send:send_to_client(Socket, 13017, #rep_challenge_boos_result{status = ?RESULT_STATUS_WIN, scene_id = Base#db_player_base.hook_scene_id}),
	player_hook_star_lib:store_hook_star(NewPlayerState, CurSceneId, Star),
	{NewPlayerState, NewHookState}.

%% 生成挂机掉落
make_rep_drop(MonsterUid, DropList) ->
	List = [#proto_hook_drop{goods_id = GoodsId, num = Num} || {GoodsId, _, Num} <- DropList],
	#rep_drop{
		obj_flag = #proto_obj_flag{type = ?OBJ_TYPE_MONSTER, id = MonsterUid},
		drop_list = List
	}.

%% 添加怪物
add_monster(0, _MonsterList, MonsterDict, _SeedId) ->
	MonsterDict;
add_monster(Count, MonsterList, MonsterDict, SeedId) ->
	MonsterUid = SeedId + util_rand:rand(1, 10),
	MonsterId = util_rand:weight_rand_ex(MonsterList),
	MonsterConf = monster_config:get(MonsterId),
	MonsterAttr = MonsterConf#monster_conf.attr_base,

	F = fun(SkillId, Acc) ->
		dict:store(SkillId, #db_skill{skill_id = SkillId, lv = 1, next_time = 0}, Acc)
	end,
	SkillDict = lists:foldl(F, dict:new(), MonsterConf#monster_conf.hook_skill_list),

	ObjState = #hook_obj_state{
		obj_id = MonsterUid,
		obj_type = ?OBJ_TYPE_MONSTER,
		monster_id = MonsterId,
		status = ?STATUS_ALIVE,
		is_boss = false,
		last_use_skill_time = 0,
		attr_base = MonsterAttr,
		attr_total = MonsterAttr,
		cur_hp = MonsterAttr#attr_base.hp,
		cur_mp = MonsterAttr#attr_base.mp,
		lv = MonsterConf#monster_conf.lv,
		career = MonsterConf#monster_conf.career,
		order_skill_list = MonsterConf#monster_conf.hook_skill_list,
		skill_dict = SkillDict,
		buff_dict = dict:new(),
		effect_dict = dict:new(),
		effect_src_dict = dict:new(),
		is_drop = false
	},
	NewDict = dict:store(MonsterUid, ObjState, MonsterDict),
	add_monster(Count - 1, MonsterList, NewDict, MonsterUid + 1).

%% 获取怪物平均血量（用于离线挂机数据统计）
get_monster_avg_hp(HookSceneConf) ->
	MonsterList = HookSceneConf#hook_scene_conf.monster_list,
	F = fun({MonsterId, Weight}, Acc) ->
		{HpCount, WeightCount} = Acc,
		MonsterConf = monster_config:get(MonsterId),
		Attr = MonsterConf#monster_conf.attr_base,
		NewHpCount = Attr#attr_base.hp * Weight + HpCount,
		{NewHpCount, WeightCount + Weight}
	end,
	{HpCount, WeightCount} = lists:foldl(F, {0, 0}, MonsterList),
	HpCount / WeightCount.

%% 生成怪物掉落
make_monster_drop(Career, HookSceneConf) ->
	MonsterDrop = HookSceneConf#hook_scene_conf.monster_drop,
	make_drop(Career, MonsterDrop).

%% 生成boss掉落
make_boss_drop(Career, HookSceneConf) ->
	BossDrop = HookSceneConf#hook_scene_conf.boss_drop,
	make_drop(Career, BossDrop).

%% 生成掉落列表
make_drop(Career, DropList) ->
	F = fun({CareerLimit, DropNumList, GoodsList}, Acc) ->
		case CareerLimit == Career orelse CareerLimit == 0 of
			true ->
				DropNum = util_rand:weight_rand_ex(DropNumList),
				case DropNum > 0 of
					true ->
						List1 = [{{GoodsId, IsBind, Num}, Rate} || {GoodsId, IsBind, Num, Rate} <- GoodsList],
						DropList1 = [util_rand:weight_rand_ex(List1) || _N <- lists:seq(1, DropNum)],
						DropList1 ++ Acc;
					_ ->
						Acc
				end;
			_ ->
				Acc
		end
	end,
	lists:foldl(F, [], DropList).

%% 根据离线市场获取挂机统计数据
get_hook_statistics(PlayerState, TimeCount) ->
	PlayerBase = PlayerState#player_state.db_player_base,
	PlayerAttr = PlayerState#player_state.attr_total,
	HookSceneConf = hook_scene_config:get(PlayerBase#db_player_base.hook_scene_id),

	%% 计算一回合单个怪物平均血量
	MonseterAvgHp = get_monster_avg_hp(HookSceneConf),
	%% 获取玩家平均伤害
	PlayerAvgAtt =
		case PlayerBase#db_player_base.career of
			?CAREER_ZHANSHI ->
				(PlayerAttr#attr_base.min_ac + PlayerAttr#attr_base.max_ac) / 2;
			?CAREER_FASHI ->
				(PlayerAttr#attr_base.min_mac + PlayerAttr#attr_base.max_mac) / 2;
			_ ->
				(PlayerAttr#attr_base.min_sc + PlayerAttr#attr_base.max_sc) / 2
		end,

	MinCount = HookSceneConf#hook_scene_conf.min_monster_num,
	MaxCount = HookSceneConf#hook_scene_conf.max_monster_num,
	%% 获取每回合平均怪物个数
	Count = (MinCount + MaxCount) / 2,

	%% 计算杀死一回合怪物所需时间
	T = util_math:ceil(MonseterAvgHp / PlayerAvgAtt * Count),
	T1 = max(T, HookSceneConf#hook_scene_conf.min_round_time),

	%% 根据离线时间计算一共杀死多少只怪物，并根据杀死的怪物给予玩家对应的经验和金币奖励
	SumKill = util_math:floor(TimeCount / T1 * Count),
	Exp = SumKill * HookSceneConf#hook_scene_conf.per_exp,
	Coin = SumKill * HookSceneConf#hook_scene_conf.per_coin,
	{SumKill, Exp, Coin}.

%% 计算离线挂机奖励
compute_hook_offline(PlayerState, TimeCount) ->
	GoodsHook = compute_hook_gain(PlayerState, TimeCount),%%计算离线挂机奖励
	PlayerState#player_state{
		hook_report = GoodsHook
	}.

%% 计算挂机获取
compute_hook_gain(PlayerState, TimeCountTemp) ->
	TimeCount = case TimeCountTemp < 1 of
					true ->
						60;
					_ ->
						TimeCountTemp
				end,
	case function_lib:is_function_open(PlayerState, ?FUNCTION_ID_HOOK) of
		true ->
			PlayerBase = PlayerState#player_state.db_player_base,
			HookSceneConf = hook_scene_config:get(PlayerBase#db_player_base.hook_scene_id),
			{SumKill, Exp, Coin} = get_hook_statistics(PlayerState, TimeCount),

			%% 根据玩家职业以及杀死怪物总数生成掉落信息
			Career = PlayerBase#db_player_base.career,
			F = fun(_, Acc) ->
				case make_monster_drop(Career, HookSceneConf) of
					[] ->
						Acc;
					DropList ->
						F1 =
							fun({GoodsId, IsBind, Num}, Acc1) ->
								case dict:find({GoodsId, IsBind}, Acc1) of
									{ok, Num1} ->
										dict:store({GoodsId, IsBind}, Num1 + Num, Acc1);
									_ ->
										dict:store({GoodsId, IsBind}, Num, Acc1)
								end
							end,
						lists:foldl(F1, Acc, DropList)
				end
			end,
			DropDict = lists:foldl(F, dict:new(), lists:seq(1, SumKill)),
			%% 生成离线统计数据
			#hook_report{
				time_count = TimeCount,
				kill_num = SumKill,
				exp = Exp,
				coin = Coin,
				goods_dict = DropDict
			};
		_ ->
			#hook_report{}
	end.

%% 领取挂机奖励
receive_hook_draw(PlayerState, GoodsHook) ->
	HookReport = case GoodsHook of
					 null ->
						 PlayerState#player_state.hook_report;
					 _ ->
						 GoodsHook
				 end,
	Exp = HookReport#hook_report.exp,
	case Exp > 0 of
		true ->
			F1 = fun({GoodsId, IsBind}, Num, Acc) ->
				[{GoodsId, IsBind, Num} | Acc]
			end,
			GoodsList = dict:fold(F1, [], HookReport#hook_report.goods_dict),

			%% 直接把物品发放到背包
			{ok, PlayerState1, SellCoin, _SellList} = goods_lib:add_goods_list_and_auto_sell(PlayerState, GoodsList),

			Base = PlayerState1#player_state.db_player_base,
			%% 发放经验金币  %% vip经验加成
			DbPlayerBase = PlayerState1#player_state.db_player_base,
			VipAddExp = vip_lib:get_vip_hook_exp(Base#db_player_base.career, DbPlayerBase#db_player_base.vip),


			Coin = HookReport#hook_report.coin + SellCoin,
			{ok, PlayerState2} = player_lib:add_exp(PlayerState1, util_math:floor(Exp * ((100 + VipAddExp) / 100)), {?LOG_TYPE_HOOK, []}),
			{ok, PlayerState3} = player_lib:incval_on_player_money_log(PlayerState2, #db_player_money.coin, Coin, ?LOG_TYPE_HOOK),

			%% 领取挂机奖励
			case GoodsHook of
				null ->
					PlayerState3#player_state{
						hook_report = #hook_report{}
					};
				_ ->
					PlayerState3
			end;
		_ ->
			PlayerState
	end.


%% 获取购买次数需求
get_buy_power_need(BuyNum) ->
	case buy_power_need_config:get(BuyNum + 1) of
		#buy_power_need_conf{} = Conf ->
			Conf#buy_power_need_conf.need_jade;
		_ ->
			0
	end.

%% 购买 挂机次数
buy_power(PlayerState) ->
	%% 获取购买的的次数
	BuyHookNum = counter_lib:get_value(PlayerState#player_state.player_id, ?COUNTER_HOOK_BUY_NUM),
	Base = PlayerState#player_state.db_player_base,

	VipBuyHookNum = vip_lib:get_vip_buy_hook_num(Base#db_player_base.career, Base#db_player_base.vip),
	%% 判断已经购买的次数
	case BuyHookNum >= VipBuyHookNum of
		true ->
			{fail, ?ERR_VIP_3};
		_ ->
			%% 购买挂机次数元宝消耗配置
			BuyPowerConf = buy_power_need_config:get(BuyHookNum + 1),
			DbPlayerMoney = PlayerState#player_state.db_player_money,
			case DbPlayerMoney#db_player_money.jade >= BuyPowerConf#buy_power_need_conf.need_jade of
				true ->
					case player_lib:incval_on_player_money_log(PlayerState, #db_player_money.jade, -BuyPowerConf#buy_power_need_conf.need_jade, ?LOG_TYPE_BUY_POWER) of
						{ok, PlayerState2} ->
							counter_lib:update_limit(PlayerState#player_state.player_id, ?COUNTER_HOOK_BUY_NUM),
							{ok, PlayerState2};
						_ ->
							{fail, ?ERR_PLAYER_JADE_NOT_ENOUGH}
					end;
				_ ->
					{fail, ?ERR_PLAYER_JADE_NOT_ENOUGH}
			end
	end.

%% 挂机火墙攻击（这里也必须由前端触发火墙攻击，服务端只是计算伤害）
%% 这个函数现在没用到，先阶段挂机没有火墙技能
fire_wall_attack(PlayerState, HookState, Data) ->
	CurTime = util_date:unixtime(),
	F = fun(FireWallAttack, Acc) ->
		{PlayerState1, HookState1, HarmList} = Acc,
		#proto_fire_wall_attack{
			fire_wall_uid = Fuid,
			monster_uid = Muid
		} = FireWallAttack,
		FireWallDict = HookState1#hook_state.fire_wall_dict,

		MonsterDict = HookState1#hook_state.monster_dict,
		case dict:find(Fuid, FireWallDict) of
			{ok, #fire_wall_state{next_time = NT, remove_time = RT} = FWState} when CurTime < RT ->
				case dict:find(Muid, MonsterDict) of
					{ok, #hook_obj_state{cur_hp = CurHp} = ObjState} when CurHp > 0 ->
						Interval = FWState#fire_wall_state.interval,
						NFWState = FWState#fire_wall_state{next_time = NT + Interval},
						{HarmResult, NewObjState} = skill_base_lib:fire_wall_attack(NFWState, ObjState),

						NewFireWallDict = dict:store(Fuid, NFWState, FireWallDict),
						HookState2 = HookState1#hook_state{fire_wall_dict = NewFireWallDict},

						{PlayerState2, HookState3} = update_obj_state(NewObjState, PlayerState1, HookState2),
						ProtoHarm = #proto_harm{
							obj_flag = #proto_obj_flag{type = ?OBJ_TYPE_MONSTER, id = Muid},
							harm_status = HarmResult#harm_result.status,
							harm_value = HarmResult#harm_result.harm_value,
							cur_hp = NewObjState#hook_obj_state.cur_hp,
							cur_mp = NewObjState#hook_obj_state.cur_mp
						},
						NewHarmList = [ProtoHarm | HarmList],
						{PlayerState2, HookState3, NewHarmList};
					_ ->
						Acc
				end;
			_ ->
				Acc
		end
	end,
	{NewPlayerState, NewHookState, List} = lists:foldl(F, {PlayerState, HookState, []}, Data#req_hook_fire_wall_attack.fire_wall_attack_list),
	net_send:send_to_client(PlayerState#player_state.socket, 13003, #rep_hook_use_skill{harm_list = List}),
	{NewPlayerState, NewHookState}.


%% ====================================================================
%% 红点提示
%% ====================================================================
%% 挂机扫荡
get_button_tips_hook_raids(PlayerState) ->
	%% 购买的次数
	BuyHookNum = counter_lib:get_value(PlayerState#player_state.player_id, ?COUNTER_HOOK_BUY_NUM),
	%% 免费的次数上限
	LimitNum = counter_lib:get_limit(?COUNTER_HOOK_NUM),
	%% 已用的次数
	HookNum = counter_lib:get_value(PlayerState#player_state.player_id, ?COUNTER_HOOK_NUM),
	{PlayerState, BuyHookNum + LimitNum - HookNum}.

%% ====================================================================
%% Internal functions
%% ====================================================================
%% 判断玩家是否死亡
is_player_die(HookPlayerState) ->
	case HookPlayerState#hook_obj_state.status of
		?STATUS_DIE -> true;
		_ -> false
	end.

%% 获取怪物死亡个数
monster_die_num(MonsterDict) ->
	F = fun(_K, V, Acc) ->
		case V#hook_obj_state.status of
			?STATUS_DIE -> Acc + 1;
			_ -> Acc
		end
	end,
	dict:fold(F, 0, MonsterDict).

%% 更新对象状态
update_obj_state(HookObjState, PlayerState, HookState) when is_record(HookObjState, hook_obj_state) ->
	ObjType = HookObjState#hook_obj_state.obj_type,
	ObjId = HookObjState#hook_obj_state.obj_id,
	case ObjType of
		?OBJ_TYPE_PLAYER ->
			{PlayerState, HookState#hook_state{hook_player_state = HookObjState}};
		?OBJ_TYPE_MONSTER ->
			MonsterDict = HookState#hook_state.monster_dict,
			NewMonsterDict = dict:store(ObjId, HookObjState, MonsterDict),
			NewHookState = HookState#hook_state{monster_dict = NewMonsterDict},
			case HookObjState#hook_obj_state.status of
				?STATUS_DIE ->
					do_monster_die(PlayerState, NewHookState, ObjId);
				_ ->
					{PlayerState, NewHookState}
			end;
		?OBJ_TYPE_PET ->
			case HookObjState#hook_obj_state.status of
				?STATUS_ALIVE ->
					{PlayerState, HookState#hook_state{hook_pet_state = HookObjState}};
				_ ->
					HookPlayerState = HookState#hook_state.hook_player_state,
					NewHookState = HookState#hook_state{
						hook_player_state = HookPlayerState#hook_obj_state{pet_id = null},
						hook_pet_state = HookObjState
					},
					{PlayerState, NewHookState}
			end;
		_ ->
			{PlayerState, HookState}
	end;
update_obj_state(UpdateDict, PlayerState, HookState) ->
	F = fun(_, HookObjState, Acc) ->
		{PlayerState1, HookState1} = Acc,
		update_obj_state(HookObjState, PlayerState1, HookState1)
	end,
	dict:fold(F, {PlayerState, HookState}, UpdateDict).

%% 生成对应的数据格式，便于发送给前端，便于服务器统一管理
make_proto_hook_monster(MonsterObj, PlayerState) ->
	#hook_obj_state{
		obj_id = ObjId,
		obj_type = ObjType,
		attr_total = AttrTotal,
		monster_id = MonsterId,
		cur_hp = CurHp,
		cur_mp = CurMp
	} = MonsterObj,
	case ObjType of
		?OBJ_TYPE_PET ->
			DbPlayerBase = PlayerState#player_state.db_player_base,
			#proto_hook_monster{
				obj_flag = #proto_obj_flag{type = ObjType, id = ObjId},
				owner_flag = #proto_obj_flag{type = ?OBJ_TYPE_PLAYER, id = ObjId},
				monster_id = MonsterId,
				cur_hp = CurHp,
				cur_mp = CurMp,
				hp = AttrTotal#attr_base.hp,
				mp = AttrTotal#attr_base.mp,
				guild_id = DbPlayerBase#db_player_base.guild_id,
				team_id = PlayerState#player_state.team_id,
				name_colour = PlayerState#player_state.name_colour
			};
		_ ->
			#proto_hook_monster{
				obj_flag = #proto_obj_flag{type = ObjType, id = ObjId},
				monster_id = MonsterId,
				cur_hp = CurHp,
				cur_mp = CurMp,
				hp = AttrTotal#attr_base.hp,
				mp = AttrTotal#attr_base.mp
			}
	end.

