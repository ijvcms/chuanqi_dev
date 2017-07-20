%%%-------------------------------------------------------------------
%%% @author tuhujia
%%% @copyright (C) 2016, <COMPANY>
%%% @doc 剧情副本
%%%
%%% @end
%%% Created : 27. 一月 2016 10:28
%%%-------------------------------------------------------------------
-module(instance_plot_lib).

-include("common.hrl").
-include("record.hrl").
-include("config.hrl").
-include("proto.hrl").
-include("cache.hrl").

%% API
-export([
	init/2,
	on_timer/1,
	on_obj_enter/2,
	on_obj_die/3,
	on_player_exit/3,
	instance_end/1,
	instance_close/1
]).

-define(PLAYER_LOGOUT_HOLD_TIME, 300). %% 玩家下线后副本保留时间

%% ====================================================================
%% API functions
%% ====================================================================
%% 初始化副本
init(SceneState, _PS) ->
	SceneId = SceneState#scene_state.scene_id,
	SceneConf = scene_config:get(SceneId),
	MonsterList = SceneConf#scene_conf.monster_list,

	%% 根据刷怪配置计算怪物总数和boss总数
	F = fun(Info, Acc) ->
		{MonsterCount, BossCount} = Acc,
		case Info of
			{monster_type, MonsterId, Num, _, _} ->
				MonsterConf = monster_config:get(MonsterId),
				case MonsterConf#monster_conf.type of
					?MONSTER_TYPE_BOSS ->
						{MonsterCount, BossCount + Num};
					_ ->
						{MonsterCount + Num, BossCount}
				end;
			{area_type, _, _, Num, _, _} ->
				{MonsterCount + Num, BossCount}
		end
	end,
	{MonsterCount, BossCount} = lists:foldl(F, {0, 0}, MonsterList),

	InstanceState = #instance_single_state{
		monster_count = MonsterCount,
		kill_monster_count = 0,
		boss_count = BossCount,
		kill_boss_count = 0,
		logout_time = 0
	},
	SceneState#scene_state{instance_state = InstanceState}.

%% 派生的定时器
on_timer(SceneState) ->
	InstanceState = SceneState#scene_state.instance_state,
	LogoutTime = InstanceState#instance_single_state.logout_time,
	CurTime = util_date:unixtime(),
	case LogoutTime /= 0 andalso LogoutTime + ?PLAYER_LOGOUT_HOLD_TIME < CurTime of
		true ->
			instance_base_lib:instance_close(SceneState);
		_ ->
			SceneState
	end.

%% 玩家进入事件
on_obj_enter(SceneState, PlayerState) when is_record(PlayerState, player_state) ->
	SceneState.

%% 对象死亡事件
on_obj_die(SceneState, DieState, _KillerState) ->
	InstanceState = SceneState#scene_state.instance_state,
	NewInstanceState =
		case DieState#scene_obj_state.obj_type of
			?OBJ_TYPE_MONSTER ->
				MonsterConf = monster_config:get(DieState#scene_obj_state.monster_id),
				case MonsterConf#monster_conf.type of
					?MONSTER_TYPE_BOSS ->
						Num = InstanceState#instance_single_state.kill_boss_count + 1,
						InstanceState#instance_single_state{kill_boss_count = Num};
					_ ->
						Num = InstanceState#instance_single_state.kill_monster_count + 1,
						InstanceState#instance_single_state{kill_monster_count = Num}
				end;
			_ ->
				InstanceState
		end,

	#scene_state{
		scene_id = SceneId
	} = SceneState,

	SceneState1 = SceneState#scene_state{instance_state = NewInstanceState},
	InstanceConf = instance_config:get(SceneId),
	case check_pass_condition(InstanceConf#instance_conf.pass_condition, SceneState1) of
		true -> %% 成功击杀完所有怪物
			case scene_base_lib:do_get_scene_players(SceneState) of
				[] ->
					skip;
				ObjList ->
					[gen_server2:cast(ObjState#scene_obj_state.obj_pid, {clearance_instance, SceneId}) || ObjState <- ObjList]
			end,

			Data1 = #rep_single_instance_result{
				scene_id = SceneId,
				instance_result = ?INSTANCE_RESULT_SUCCESS
			},
			scene_send_lib:do_send_scene(SceneState, 11017, Data1),

			SceneState1;
		_ ->
			SceneState1
	end.

%% 玩家退出事件
on_player_exit(SceneState, _ObjState, LeaveType) ->
	case LeaveType of
		?LEAVE_SCENE_TYPE_INITIATIVE ->
			instance_base_lib:instance_close(SceneState);
		_ ->
			InstanceState = SceneState#scene_state.instance_state,
			NewInstanceState = InstanceState#instance_single_state{
				logout_time = util_date:unixtime()
			},
			SceneState#scene_state{
				instance_state = NewInstanceState
			}
	end.

%% 副本结束
instance_end(SceneState) ->
	SceneState.

%% 副本关闭
instance_close(SceneState) ->
	SceneState.

%% ====================================================================
%% Internal functions
%% ====================================================================
%% 检查通过条件
check_pass_condition({kill_all}, SceneState) ->
	InstanceState = SceneState#scene_state.instance_state,
	#instance_single_state{
		monster_count = MC,
		kill_monster_count = KMC,
		boss_count = BC,
		kill_boss_count = KBC
	} = InstanceState,
	KMC >= MC andalso KBC >= BC.