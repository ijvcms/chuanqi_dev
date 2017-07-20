%%%-------------------------------------------------------------------
%%% @author qhb
%%% @copyright (C) 2016, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 01. 八月 2016 上午10:23
%%%-------------------------------------------------------------------
-module(instance_single_boss_lib).
-include("common.hrl").
-include("record.hrl").
-include("config.hrl").
-include("proto.hrl").
-include("cache.hrl").
-include("db_record.hrl").

-define(REFUSE_TIME, 1). %% 刷新时间间隔(秒)

%% API
-export([
	init/2,
	on_timer/1,
	on_obj_enter/2,
	on_obj_die/3,
	on_player_exit/3,
	instance_end/1,
	instance_close/1,
	check/1,
	save_left_time_local/2,
	check_left_time_local/2,
	check_left_time_local2/2
]).

%% ====================================================================
%% API functions
%% ====================================================================
%% 初始化副本
init(SceneState, PS) ->
	SceneId = SceneState#scene_state.scene_id,
	SceneConf = scene_config:get(SceneId),
	MonsterList = SceneConf#scene_conf.monster_list,

	%%?WARNING("single boss init",[]),

	%% 根据刷怪配置计算怪物总数和boss总数
	F = fun(Info, Acc) ->
		{MonsterCount, BossCount, AccBossList} = Acc,
		case Info of
			{monster_type, MonsterId, Num, _, _} ->
				MonsterConf = monster_config:get(MonsterId),
				case MonsterConf#monster_conf.type of
					?MONSTER_TYPE_BOSS ->
						{MonsterCount, BossCount + Num, [MonsterId | AccBossList]};
					?MONSTER_TYPE_ELITE ->
						{MonsterCount + Num, BossCount, [MonsterId | AccBossList]};
					_ ->
						{MonsterCount + Num, BossCount, AccBossList}
				end;
			{area_type, _, _, Num, _, _} ->
				{MonsterCount + Num, BossCount, AccBossList}
		end
	end,
	{_MonsterCount, BossCount, SaveBossList} = lists:foldl(F, {0, 0, []}, MonsterList),
	save_boss_list(SaveBossList),
	{ok, SceneState1, BossStateList} = restore_boss_hp(SceneState, PS),
	BossCount1 =
		case BossStateList =/= [] of
			true ->
				lists:foldl(fun(ObjState, Acc) ->
					MonsterConf = monster_config:get(ObjState#scene_obj_state.monster_id),
					case MonsterConf#monster_conf.type =:= ?MONSTER_TYPE_BOSS
						andalso ObjState#scene_obj_state.cur_hp > 0  of
						true -> Acc + 1;
						false -> Acc
					end
				end, 0, BossStateList);
			false -> BossCount
		end,

	SceneSign = instance_base_lib:get_instance_sign(PS, SceneState#scene_state.scene_id),
	TomorrowTime = util_date:get_tomorrow_unixtime(),
	NextWeekTime = get_next_week_time(),
	InstanceState = #instance_single_boss_state{
		scene_sign = SceneSign,
		instance_week = NextWeekTime,
		instance_day = TomorrowTime,
		enter_time = 0,
		left_time = 0,
		boss_count = BossCount1,
		kill_boss_count = 0
	},
	gen_server2:apply_after(?REFUSE_TIME * 1000, self(), {?MODULE, check, []}),
	SceneState1#scene_state{instance_state = InstanceState, end_time = NextWeekTime + 60, close_time = NextWeekTime + 60}.

%% 派生的定时器
on_timer(SceneState) ->
	SceneState.

%% 玩家进入事件
on_obj_enter(SceneState, PlayerState) when is_record(PlayerState, player_state) ->
	log_instance:on_player_enter(SceneState, PlayerState),
	DbPlayerBase = PlayerState#player_state.db_player_base,
	InstanceLeftTime = DbPlayerBase#db_player_base.instance_left_time,
	InstanceState = SceneState#scene_state.instance_state,
	NewInstanceState = InstanceState#instance_single_boss_state{enter_time = util_date:unixtime(), left_time = InstanceLeftTime},

	check_left_time(PlayerState#player_state.pid),

	%%SceneState1 = restore_boss_hp_full(SceneState),
	SceneState#scene_state{instance_state = NewInstanceState}.

%% 对象死亡事件
on_obj_die(SceneState, DieState, _KillerState) ->
	InstanceState = SceneState#scene_state.instance_state,

	%% 更新击杀数量
	NewInstanceState =
		case DieState#scene_obj_state.obj_type of
			?OBJ_TYPE_MONSTER ->
				MonsterConf = monster_config:get(DieState#scene_obj_state.monster_id),
				case MonsterConf#monster_conf.type of
					?MONSTER_TYPE_BOSS ->
						Num = InstanceState#instance_single_boss_state.kill_boss_count + 1,
						InstanceState#instance_single_boss_state{kill_boss_count = Num};
					_ ->
						InstanceState
				end;
			_ ->
				InstanceState
		end,

	%% 发送副本统计更新给前端
	#instance_single_boss_state{
		enter_time = EnterTime,
		left_time = LeftTimeOld,
		boss_count = BossCount,
		kill_boss_count = KillBossCount
	} = NewInstanceState,
	CurTime = util_date:unixtime(),
	LeftTime = erlang:max(LeftTimeOld - (CurTime - EnterTime), 0),

	Rep = #rep_palace_boss_result{left_time = LeftTime, kill_boss = BossCount - KillBossCount},
	%%?WARNING("single boss result2 ~p",[Rep]),
	scene_send_lib:do_send_scene(SceneState, 11045, Rep),

	SceneState#scene_state{instance_state = NewInstanceState}.

%% 玩家退出事件
on_player_exit(SceneState, ObjState, _LeaveType) ->
	log_instance:on_player_exit(SceneState, ObjState),
	%%?WARNING("ins exit",[]),

	InstanceState = SceneState#scene_state.instance_state,
	#instance_single_boss_state{
		instance_day = InsDay,
		enter_time = EnterTime
	} = InstanceState,
	CurTime = util_date:unixtime(),
	%%?WARNING("LeftTimeOld ~p", [LeftTimeOld]),
	%%LeftTime = erlang:max(LeftTimeOld - (CurTime - EnterTime), 0),

	case CurTime < InsDay of
		true ->
			save_left_time(ObjState#scene_obj_state.obj_pid, CurTime - EnterTime);
		false ->
			skip
	end,
	save_boss_hp(SceneState, ObjState#scene_obj_state.obj_id),

	%%NewInstanceState = InstanceState#instance_single_boss_state{enter_time = 0, left_time = 0},
	%%SceneState1 = SceneState#scene_state{instance_state = NewInstanceState},
	instance_base_lib:instance_close(SceneState).

%% 副本结束
instance_end(SceneState) ->
	SceneState.

%% 副本关闭
instance_close(SceneState) ->
	InstanceState = SceneState#scene_state.instance_state,
	SceneSign = InstanceState#instance_single_boss_state.scene_sign,
	SceneId = SceneState#scene_state.scene_id,
	Key = {SceneId, SceneSign},
	case ets:lookup(?ETS_SCENE_MAPS, Key) of
		[_EtsMaps] ->
			ets:delete(?ETS_SCENE_MAPS, Key);
		_ ->
			skip
	end,
	ets:delete(?ETS_SCENE, self()),

	SceneState.

check(SceneState) ->
	InstanceState = SceneState#scene_state.instance_state,
	#instance_single_boss_state{instance_day = InsDay, instance_week = InsWeek,
		enter_time = EnterTime, left_time = LeftTime} = InstanceState,
	CurTime = util_date:unixtime(),
	NewSceneState =
		case CurTime > InsWeek of
			true ->
				{ok, SceneState1} = instance_base_lib:instance_close(SceneState),
				SceneState1;
			false ->
				case EnterTime > 0 andalso ((CurTime - EnterTime) > LeftTime orelse CurTime > InsDay) of
					true ->
						kick_player(SceneState);
					false ->
						skip
				end,
				SceneState
		end,
	gen_server2:apply_after(?REFUSE_TIME * 1000, self(), {?MODULE, check, []}),
	{ok, NewSceneState}.

%%退出时保存剩余时间
save_left_time(PlayerPid, UseTime) ->
	gen_server2:apply_async(PlayerPid, {?MODULE, save_left_time_local, [UseTime]}).
save_left_time_local(PlayerState, UseTime) ->
	#player_state{db_player_base = #db_player_base{instance_left_time = LeftTimeOld}} = PlayerState,
	LeftTime = erlang:max(LeftTimeOld - UseTime, 0),
	Update = #player_state{
		db_player_base = #db_player_base{instance_left_time = LeftTime}
	},
	player_lib:update_player_state(PlayerState, Update).

%%检查剩余时间，当从个人boss一层进入二层时，playerstate还没同步剩余时间
check_left_time(PlayerPid) ->
	gen_server2:apply_async(PlayerPid, {?MODULE, check_left_time_local, [self()]}).
check_left_time_local(PlayerState, ScenePid) ->
	gen_server2:apply_async(ScenePid, {?MODULE, check_left_time_local2, [PlayerState]}).
check_left_time_local2(SceneState, PlayerState) ->
	DbPlayerBase = PlayerState#player_state.db_player_base,
	InstanceLeftTime = DbPlayerBase#db_player_base.instance_left_time,
	InstanceState = SceneState#scene_state.instance_state,
	NewInstanceState = InstanceState#instance_single_boss_state{left_time = InstanceLeftTime},

	NewSceneState = SceneState#scene_state{instance_state = NewInstanceState},
	%%send_result(NewSceneState, PlayerState),

	{ok, NewSceneState}.

%% send_result(SceneState, PlayerState) ->
%% 	#instance_single_boss_state{
%% 		left_time = LeftTime,
%% 		boss_count = BossCount,
%% 		kill_boss_count = KillBossCount
%% 	} = SceneState#scene_state.instance_state,
%% 	Rep = #rep_single_boss_result{left_time = LeftTime, left_boss = BossCount - KillBossCount},
%% 	?WARNING("send_result1 ~p", [Rep]),
%% 	net_send:send_to_client(PlayerState#player_state.player_id, 11045, Rep).

%% ====================================================================
%% Internal functions
%% ====================================================================

save_boss_list(List) ->
	KvList = [{R, 1} || R <- List],
	Dict = dict:from_list(KvList),
	put(single_boss_hash, Dict),
	Dict.

get_boss_list() ->
	get(single_boss_hash).

%%保存boss血量到缓存
save_boss_hp(SceneState, PlayerId) ->
	BossDict = get_boss_list(),
	HpKvList =
		case dict:find(?OBJ_TYPE_MONSTER, SceneState#scene_state.obj_dict) of
			{ok, TypeObjDict} ->
				dict:fold(fun(_K, ObjState, Acc) ->
					#scene_obj_state{monster_id = MonsterId, cur_hp = CurHp} = ObjState,
					case dict:is_key(MonsterId, BossDict) of
						true ->
							[{MonsterId, CurHp} | Acc];
						false ->
							Acc
					end
				end, [], TypeObjDict);
			_ ->
				[]
		end,
	SceneId = SceneState#scene_state.scene_id,
	#instance_single_boss_state{instance_day = HpTime, instance_week = NextWorkTime} = SceneState#scene_state.instance_state,
	case player_monster_state_cache:select_row(PlayerId) of
		null ->
			MonsterState = [{SceneId, HpKvList}],
			Rec = #db_player_monster_state{player_id = PlayerId, refresh_time = NextWorkTime, hp_reset_time = HpTime, monster_state = MonsterState},
			player_monster_state_cache:insert(Rec);
		R ->
			MonsterState1 = R#db_player_monster_state.monster_state,
			MonsterState2 = lists:keydelete(SceneId, 1, MonsterState1),
			MonsterState = [{SceneId, HpKvList} | MonsterState2],
			Rec = R#db_player_monster_state{refresh_time = NextWorkTime, hp_reset_time = HpTime, monster_state = MonsterState},
			player_monster_state_cache:update(Rec)
	end.

%%从缓存还原boss血量
restore_boss_hp(SceneState, PlayerState) ->
	BossStateList = get_boss_state_list(SceneState, PlayerState),
	SceneState1 =
	lists:foldl(fun(ObjState, AccSceneState) ->
		case ObjState#scene_obj_state.cur_hp > 0 of
			true ->
				scene_base_lib:store_scene_obj_state(AccSceneState, ObjState);%%
			false ->
				scene_base_lib:erase_scene_obj_state(AccSceneState, ObjState)%%
		end
	end, SceneState, BossStateList),
	{ok, SceneState1, BossStateList}.

%%缓存的血量
get_boss_hp_dict(PlayerId, SceneId) ->
	case player_monster_state_cache:select_row(PlayerId) of
		#db_player_monster_state{refresh_time = RefreshTime, hp_reset_time = HpTime} = Rec ->
			case util_date:unixtime() < RefreshTime of
				true ->
					MonsterState =
						case util_date:unixtime() < HpTime of
							true ->
								Rec#db_player_monster_state.monster_state;
							false ->
								NewRec = restore_boss_hp_full(Rec),
								NewRec#db_player_monster_state.monster_state
						end,
					case lists:keyfind(SceneId, 1, MonsterState) of
						{SceneId, MonsterHpList} ->
							dict:from_list(MonsterHpList);
						_ ->
							null
					end;
				false ->
					%%?WARNING("delete ~p",[PlayerId]),
					player_monster_state_cache:delete(PlayerId),
					null
			end;
		_ ->
			null
	end.

%%根据缓存计算boss新的血量
get_boss_state_list(SceneState, PlayerState) ->
	HpDict = get_boss_hp_dict(PlayerState#player_state.player_id, SceneState#scene_state.scene_id),
	BossDict = get_boss_list(),
	case HpDict =/= null of
		true ->
			case dict:find(?OBJ_TYPE_MONSTER, SceneState#scene_state.obj_dict) of
				{ok, TypeObjDict} ->
					dict:fold(fun(_K, ObjState, Acc) ->
						#scene_obj_state{monster_id = MonsterId} = ObjState,
						case dict:is_key(MonsterId, BossDict) of
							true ->
								case dict:find(MonsterId, HpDict) of
									{ok, Value} ->
										[ObjState#scene_obj_state{cur_hp = Value} | Acc];
									_ ->
										[ObjState#scene_obj_state{cur_hp = 0} | Acc]
								end;
							false ->
								Acc
						end
					end, [], TypeObjDict);
				_ ->
					[]
			end;
		false ->
			[]
	end.

%%boss满血量
restore_boss_hp_full(Rec) ->
	MonsterState = Rec#db_player_monster_state.monster_state,
	NewMonsterState =
		[
			begin
				{SceneId, KvList} = R,
				NewKvList =
					lists:foldl(fun({MonsterId, OldHp}, Acc) ->
						case OldHp > 0 of
							true ->
								case monster_config:get(MonsterId) of
									#monster_conf{attr_base = AttrBase} ->
										#attr_base{hp = Hp} = AttrBase,
										[{MonsterId, Hp} | Acc];
									_ ->
										Acc
								end;
							false ->
								Acc
						end
					end, [], KvList),
				{SceneId, NewKvList}
			end
			|| R <- MonsterState],
	NewRec = Rec#db_player_monster_state{hp_reset_time = util_date:get_tomorrow_unixtime(), monster_state = NewMonsterState},
	player_monster_state_cache:update(NewRec),
	NewRec.

%%下周一零点的时间
get_next_week_time() ->
	{Date, _} = calendar:local_time(),
	Day = 7 - calendar:day_of_the_week(Date) + 1,
	TodayTime = util_date:get_today_unixtime(),
	NextWeekTime = TodayTime + Day * 86400,
	NextWeekTime.

kick_player(SceneState) ->
	SceneId = SceneState#scene_state.scene_id,
	SceneConf = scene_config:get(SceneId),
	ExitScene = SceneConf#scene_conf.exit_scene,
	PlayerList = scene_base_lib:do_get_scene_players(SceneState),
	[gen_server2:cast(SceneObj#scene_obj_state.obj_pid, {change_scene, ExitScene, ?CHANGE_SCENE_TYPE_LEAVE_INSTANCE, null}) || SceneObj <- PlayerList].