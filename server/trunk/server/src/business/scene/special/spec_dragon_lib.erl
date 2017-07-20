%%%-------------------------------------------------------------------
%%% @author qhb
%%% @copyright (C) 2016, <COMPANY>
%%% @doc
%%%	火龙神殿玩法
%%% @end
%%% Created : 07. 九月 2016 上午10:55
%%%-------------------------------------------------------------------
-module(spec_dragon_lib).
-include("common.hrl").
-include("config.hrl").
-include("record.hrl").
-include("proto.hrl").
-include("notice_config.hrl").
-define(REFRESH_TIME, 5).        %%定时推送结果
-define(ACTIVE_REMIND_ID1, 9).    %%活动提醒id
-define(ACTIVE_REMIND_ID2, 10).
-define(DRAGON_SCENES, [31002, 31003, 31004]).    %%跨服所有火龙神殿场景id
-define(DRAGON_SCENES_WEEKEND, [32109, 32110, 32111]).    %%跨服所有火龙神殿场景id周末
-define(DRAGON_SCENES_NATIVE, [32108]).    %%本服所有火龙神殿场景id

%%因为没有多个使用的地方，简单从spec_dragon_mod复制定义record,没有定义在全局
-record(state, {monster_kill_num, progress}).

%% API
-export([
	init/0,
	reset_state/0,
	monster_kill/0,
	scene_line_init/2,
	send_kill_num/1
]).

%% GEN API
-export([
	reset_state_local/1,
	monster_kill_local/1,
	create_boss_local/2,
	scene_line_init_local/3,
	send_kill_num_local/2,
	push_result_local/2,
	on_timer/1
]).

%%初始化
init() ->
	gen_server2:apply_after(?REFRESH_TIME * 1000, self(), {?MODULE, on_timer, []}),
	ok.


%%还原火龙神殿的全局状态(任何火龙神殿的场景关闭时检查，需要判断活动时间)
reset_state() ->
	gen_server2:apply_async(misc:whereis_name({local, spec_dragon_mod}), {?MODULE, reset_state_local, []}).
reset_state_local(State) ->
	check_open_state(),
	case not is_activity_open() of
		true ->
			{ok, State#state{monster_kill_num = 0, progress = 0}};
		false ->
			{ok, State#state{monster_kill_num = 0, progress = 0}}
	end.

%%杀怪计数，符合一定的条件后激发玩法
monster_kill() ->
	gen_server2:apply_async(misc:whereis_name({local, spec_dragon_mod}), {?MODULE, monster_kill_local, []}).
monster_kill_local(State) ->
	case is_activity_open() of
		true ->
			NewKillNum = State#state.monster_kill_num + 1,
			NewProgress = trigger_game(NewKillNum, State#state.progress),
			{ok, State#state{monster_kill_num = NewKillNum, progress = NewProgress}};
		false ->
			{ok, State}
	end.


%%有多个场景，活动开启一段时间后新创建的场景要激发玩法
scene_line_init(SceneId, ScenePid) ->
	gen_server2:apply_async(misc:whereis_name({local, spec_dragon_mod}), {?MODULE, scene_line_init_local, [SceneId, ScenePid]}).
scene_line_init_local(State, SceneId, ScenePid) ->
	trigger_game_init(State#state.monster_kill_num, SceneId, ScenePid),
	check_open_state(),
	{ok, State}.

%%发送杀怪数量
send_kill_num(PlayerId) ->
	gen_server2:apply_async(misc:whereis_name({local, spec_dragon_mod}), {?MODULE, send_kill_num_local, [PlayerId]}).
send_kill_num_local(State, PlayerId) ->
	Rep = #rep_dragon_kill_num{kill_num = State#state.monster_kill_num},
	net_send:send_to_client(PlayerId, 11054, Rep),
	{ok, State}.

%%%===================================================================
%%% Internal functions
%%%===================================================================
%%根据杀怪数量触发BOSS
trigger_game(KillNum, OldProgress) ->
	NextSteps =
		lists:filter(fun(E) ->
			KillNum >= E andalso E > OldProgress
		end, get_config_keys()),
	case NextSteps of
		[] -> OldProgress;
		[NewProgress | _] ->
			{BossSceneId, SceneList, NoticeId} = get_config(NewProgress),
			refresh_monster(BossSceneId, ?MONSTER_TYPE_BOSS),
			[refresh_monster(S, ?MONSTER_TYPE_ELITE) || S <- SceneList],
			case NoticeId =/= 0 of
				true ->
					send_notice_scenes(NoticeId);
				false ->
					skip
			end,
			NewProgress
	end.

%%后创建的场景初始化时要添加活动已经刷新出来的怪物
trigger_game_init(KillNum, SceneId, ScenePid) ->
	NextSteps =
		lists:filter(fun(E) ->
			KillNum >= E
		end, get_config_keys()),
	Func = fun(Progress) ->
		{BossSceneId, SceneList, _} = get_config(Progress),
		case BossSceneId =:= SceneId of
			true ->
				create_boss(ScenePid, ?MONSTER_TYPE_BOSS);
			false ->
				skip
		end,
		case lists:member(SceneId, SceneList) of
			true ->
				create_boss(ScenePid, ?MONSTER_TYPE_ELITE);
			false ->
				skip
		end
	end,
	lists:foreach(Func, NextSteps).

%%根据场景得到场景的所有进程，通知场景进程创建怪物
refresh_monster(SceneId, BossType) ->
	SceneSign = ?WORLD_ACTIVE_SIGN,
	Key = {SceneId, SceneSign},
	case ets:lookup(?ETS_SCENE_MAPS, Key) of
		[#ets_scene_maps{pid_list = PidLineList}] ->
			lists:foreach(fun(#pid_line{pid = Pid}) ->
				create_boss(Pid, BossType)
			end, PidLineList),
			ok;
		_ ->
			skip
	end.


%%创建指定场景指定类型的怪物
create_boss(ScenePid, BossType) ->
	gen_server2:apply_async(ScenePid, {?MODULE, create_boss_local, [BossType]}).
create_boss_local(SceneState, BossType) ->
	%%?WARNING("create booss ~p ~p",[SceneState#scene_state.scene_id, BossType]),
	Dict = SceneState#scene_state.monster_area_dict,
	CurTime = util_date:unixtime(),
	SceneConf = scene_config:get(SceneState#scene_state.scene_id),
	RuleMonsterList = SceneConf#scene_conf.rule_monster_list,
	F = fun(RuleInfo, Acc) ->
		case RuleInfo of
			{area_type, AreaFlag, _, _, _, _} ->
				case dict:find(AreaFlag, Dict) of
					{ok, AreaObj} ->
						#monster_area_state{
							area_flag = AreaFlag,
							count = Count,
							monster_id = MonsterId,
							monster_list = List,
							next_refresh_time = _RefTime,
							refresh_interval = RI,
							refresh_location = RL
						} = AreaObj,
						CurCount = length(List),
						#monster_conf{type = Type} = monster_config:get(MonsterId),
						case Type =:= BossType of
							true ->
								Acc1 = scene_base_lib:update_monster_area(Acc, AreaFlag, CurTime + RI),
								case Count > CurCount of
									true ->
										scene_obj_lib:create_area_monster(Acc1, {area_type, AreaFlag, MonsterId, Count - CurCount, RI, RL});
									_ ->
										Acc1
								end;
							_ ->
								Acc
						end;
					_ ->
						Acc
				end;
			_ ->
				Acc
		end
	end,
	SceneState1 = lists:foldl(F, SceneState, RuleMonsterList),
	{ok, SceneState1}.

%%定时推送杀怪数量
on_timer(State) ->
	KillNum = State#state.monster_kill_num,
	case get(monster_kill_num) =/= KillNum of
		true ->
			Func = fun(SceneId) ->
				SceneSign = ?WORLD_ACTIVE_SIGN,
				Key = {SceneId, SceneSign},
				case ets:lookup(?ETS_SCENE_MAPS, Key) of
					[#ets_scene_maps{pid_list = PidLineList}] ->
						lists:foreach(fun(#pid_line{pid = Pid}) ->
							gen_server2:apply_async(Pid, {?MODULE, push_result_local, [KillNum]})
						end, PidLineList),
						ok;
					_ ->
						skip
				end
			end,
			%% 遍历所有场景推送结果
			[Func(SceneId) || SceneId <- get_scenes()],
			put(monster_kill_num, KillNum);
		false ->
			skip
	end,
	gen_server2:apply_after(?REFRESH_TIME * 1000, self(), {?MODULE, on_timer, []}),
	{ok, State}.
%%推送单个场景的玩家杀怪结果
push_result_local(SceneState, KillNum) ->
	PlayerList = scene_base_lib:do_get_scene_players(SceneState),
	Func = fun(ObjState) ->
		Rep = #rep_dragon_kill_num{kill_num = KillNum},
		net_send:send_to_client(ObjState#scene_obj_state.obj_id, 11054, Rep)
	end,
	lists:foreach(Func, PlayerList).

%%给所有火龙场景推送刷怪公告
send_notice_scenes(NoticeId) ->
	Func = fun(SceneId) ->
		SceneSign = ?WORLD_ACTIVE_SIGN,
		Key = {SceneId, SceneSign},
		case ets:lookup(?ETS_SCENE_MAPS, Key) of
			[#ets_scene_maps{pid_list = PidLineList}] ->
				lists:foreach(fun(#pid_line{pid = Pid}) ->
					send_notice_scene(Pid, NoticeId, [])
				end, PidLineList),
				ok;
			_ ->
				skip
		end
	end,
	%% 遍历所有场景推送公告
	[Func(SceneId) || SceneId <- get_scenes()],
	ok.

%%给场景推送公告
send_notice_scene(ScenePid, NoticeMacro, ArgList) ->
	case notice_config:get(NoticeMacro) of
		#notice_conf{} = NoticeConf ->
			ArgList1 = [util_data:to_list(Arg) || Arg <- ArgList],
			Data = #rep_notice{
				notice_id = NoticeConf#notice_conf.notice_id,
				arg_list = ArgList1
			},
			scene_send_lib:send_scene(ScenePid, 9999, Data);
		_ ->
			?ERR("not notice [~p]", [NoticeMacro])
	end.

%%检查活动开放状态，场景创建和关闭时都需要检查，杀怪时要根据状态来判断是否统计
check_open_state() ->
	case is_activity_open() of
		true ->
			case not is_activity_open_time() of
				true ->
					delete_activity_open(),
					ok;
				false -> skip
			end;
		false ->
			case is_activity_open_time() of
				true -> set_activity_open();
				false -> skip
			end
	end.

%% 判断活动是否开始
is_activity_open() ->
%% 	case get("activity_open_flag") of
%% 		undefined -> false;
%% 		_ -> true
%% 	end.
	true.

%%设置活动开启
set_activity_open() ->
	put("activity_open_flag", true).

%%关闭活动
delete_activity_open() ->
	erase("activity_open_flag").

%%是否在活动开启时间内
is_activity_open_time() ->
%% 	{_Date, Time} = calendar:local_time(),
%% 	#active_remind_conf{time_list = [{_, Time1_1, Time1_2}]} = active_remind_config:get(?ACTIVE_REMIND_ID1),
%% 	%%#active_remind_conf{time_list = [{_, Time2_1, Time2_2}]} = active_remind_config:get(?ACTIVE_REMIND_ID2),
%% 	%%(Time >= Time1_1 andalso Time < Time1_2) orelse (Time >= Time2_1 andalso Time < Time2_2).
%% 	Time >= Time1_1 andalso Time < Time1_2.
	true.

%%获取本服或跨服的场景列表,跨服周六日判断
get_scenes() ->
	%%判断跨服
	case config:get_server_no() >= 800 andalso config:get_server_no() < 1000 of
		false ->
			?DRAGON_SCENES_NATIVE;
		true ->
			Week = util_date:get_week(),
			case Week < 6 of
				true -> ?DRAGON_SCENES;
				false -> ?DRAGON_SCENES_WEEKEND
			end
	end.

%%获取活动配置的key列表
get_config_keys() ->
	%%判断跨服
	case config:get_server_no() >= 800 andalso config:get_server_no() < 1000 of
		false ->
			instance_dragon_native_config:get_list();
		true ->
			Week = util_date:get_week(),
			case Week < 6 of
				true -> instance_dragon_config:get_list();
				false -> instance_dragon_weeken_config:get_list()
			end
	end.

%%获取活动配置
get_config(Key) ->
	%%判断跨服
	case config:get_server_no() >= 800 andalso config:get_server_no() < 1000 of
		false ->
			#instance_dragon_native_conf{boss_scene_id = BossSceneId, scene_list = SceneList, notice_id = NoticeId} =
				instance_dragon_native_config:get(Key),
			{BossSceneId, SceneList, NoticeId};
		true ->
			Week = util_date:get_week(),
			case Week < 6 of
				true ->
					#instance_dragon_conf{boss_scene_id = BossSceneId, scene_list = SceneList, notice_id = NoticeId} =
						instance_dragon_config:get(Key),
					{BossSceneId, SceneList, NoticeId};
				false ->
					#instance_dragon_weeken_conf{boss_scene_id = BossSceneId, scene_list = SceneList, notice_id = NoticeId} =
						instance_dragon_weeken_config:get(Key),
					{BossSceneId, SceneList, NoticeId}
			end
	end.