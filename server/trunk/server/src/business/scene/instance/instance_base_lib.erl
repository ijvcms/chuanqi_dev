%%%-------------------------------------------------------------------
%%% @author zhengsiying
%%% @copyright (C) 2015, <COMPANY>
%%% @doc
%%%		副本基础模块
%%% @end
%%% Created : 10. 十二月 2015 上午10:19
%%%-------------------------------------------------------------------
-module(instance_base_lib).
%%
-include("common.hrl").
-include("record.hrl").
-include("config.hrl").
-include("cache.hrl").
-include("spec.hrl").

%% API
-export([
	init/2,
	on_timer/1,
	on_obj_enter/2,
	on_obj_harm/4,
	on_obj_die/3,
	on_player_exit/3,
	instance_end/1,
	instance_close/1,
	instance_destroy/1,
	get_instance_info/2,
	is_multiple_instance/1,
	get_instance_sign/2
]).

-export([
	do_get_instance_info/2
]).

%% ====================================================================
%% API functions
%% ====================================================================
%% 副本初始化
init(SceneState, PlayerState) ->
	SceneId = SceneState#scene_state.scene_id,
	CurTime = util_date:unixtime(),
	InstanceConf = instance_config:get(SceneId),
	#instance_conf{
		end_time = ET,
		close_time = CT
	} = InstanceConf,

	%% 检查组队副本
	case is_multiple_instance(SceneId) of
		true ->
			Time = PlayerState#player_state.scene_parameters,
			SceneState1 =
				case is_integer(Time) andalso Time > 0 of
					true ->
						SceneState#scene_state{
							end_time = CurTime + Time,
							close_time = CurTime + Time + 5
						};
					false ->
						SceneState#scene_state{
							end_time = CurTime + ET,
							close_time = CurTime + CT
						}
				end;
		false ->
			SceneState1 = SceneState#scene_state{
				end_time = CurTime + ET,
				close_time = CurTime + CT
			}
	end,
	do_action(SceneState1, init, [PlayerState]).

%% 定时器
on_timer(SceneState) ->
	CurTime = util_date:unixtime(),
	{ok, SceneState1} = do_action(SceneState, on_timer, []),
	case util_data:is_null(SceneState1#scene_state.destroy_time) of
		true ->
			case SceneState1#scene_state.close_time =< CurTime of
				true ->
					instance_close(SceneState1);
				_ ->
					case SceneState1#scene_state.end_time =< CurTime andalso
						SceneState1#scene_state.instance_end_state =/= ?INSTANCE_END_STATE of
						true ->
							instance_end(SceneState1);
						_ ->
							{ok, SceneState1}
					end
			end;
		_ ->
			case SceneState1#scene_state.destroy_time =< CurTime of
				true ->
					instance_destroy(SceneState1);
				_ ->
					{ok, SceneState1}
			end
	end.

%% 对象进入副本事件
on_obj_enter(SceneState, PlayerState) when is_record(PlayerState, player_state) ->
	%% 纪录进入过的副本玩家列表(暂用运营活动统计)
	NewSceneState = update_enter_player_list(SceneState, PlayerState),
	do_action(NewSceneState, on_obj_enter, [PlayerState]).

%% 对象受伤事件
on_obj_harm(SceneState, TargetState, CasterState, HarmValue) ->
	do_action(SceneState, on_obj_harm, [TargetState, CasterState, HarmValue]).

%% 对象死亡事件
%% DieState 和 KillerState 都是 #scene_obj_state{}
on_obj_die(SceneState, DieState, KillerState) ->
	do_action(SceneState, on_obj_die, [DieState, KillerState]).

%% 玩家离开副本
on_player_exit(SceneState, ObjState, LeaveType) ->
	do_action(SceneState, on_player_exit, [ObjState, LeaveType]).

%% 副本结束事件(副本结束不等同于副本关闭)，副本结束后不再计算通关条件，如果通关条件没有达成说明通关失败，如果已经达成说明通关成功
instance_end(SceneState) ->
	do_action(SceneState, instance_end, []).

%% 副本关闭(这里场景进程并不会马上销毁)一般情况下会将在副本里的玩家/宠物踢出副本，这里基类已经实现了这个功能，派生类只需要写自己的特殊逻辑处理
instance_close(SceneState) ->
	%% 停止所有怪物
	ObjList = scene_base_lib:do_get_scene_obj_list(SceneState, [?OBJ_TYPE_MONSTER, ?OBJ_TYPE_IMAGE]),
	F = fun(ObjState, Acc) ->
		#scene_obj_state{
			obj_type = ObjType,
			obj_id = ObjId
		} = ObjState,
		ObjState1 = scene_base_lib:get_scene_obj_state(Acc, ObjType, ObjId),
		{Acc1, _} = game_obj_lib:stop_ai(Acc, ObjState1),
		Acc1
	end,
	SceneState1 = lists:foldl(F, SceneState, ObjList),

	%% 把玩家踢出副本场景
	TempSceneId = SceneState1#scene_state.scene_id,
	SceneId =
		case TempSceneId of
			?SCENEID_HJZC_FAJIAN ->
				?SCENEID_HJZC_DATING;
			_ ->
				TempSceneId
		end,
	SceneConf = scene_config:get(SceneId),
	ExitScene = SceneConf#scene_conf.exit_scene,
	PlayerList = scene_base_lib:do_get_scene_players(SceneState1),
	[gen_server2:cast(SceneObj#scene_obj_state.obj_pid, {change_scene, ExitScene, ?CHANGE_SCENE_TYPE_LEAVE_INSTANCE, null}) || SceneObj <- PlayerList],

	%% 因为提前的清理了场景映射信息，所以必须提前的清理掉玩家信息
	scene_mgr_lib:close_scene(self()),
	F1 = fun(ObjState, Acc) ->
		#scene_obj_state{
			obj_type = ObjType,
			obj_id = ObjId
		} = ObjState,
		{ok, Acc1} = scene_obj_lib:do_remove_obj(Acc, ObjType, ObjId, ?LEAVE_SCENE_TYPE_INITIATIVE),
		Acc1
	end,
	SceneState2 = lists:foldl(F1, SceneState1, PlayerList),

	{ok, SceneState3} = do_action(SceneState2, instance_close, []),
	{ok, SceneState3#scene_state{destroy_time = util_date:unixtime() + 60}}.

%% 副本销毁
instance_destroy(SceneState) ->
	{stop, normal, SceneState}.

%% 获取副本信息(统一都是通过协议11014进来获取，返回的话根据不同的副本需求返回不同内容)
get_instance_info(ScenePid, Socket) ->
	gen_server2:apply_async(ScenePid, {?MODULE, do_get_instance_info, [Socket]}).

do_get_instance_info(SceneState, Socket) ->
	SceneId = SceneState#scene_state.scene_id,
	SceneConf = scene_config:get(SceneId),
	case SceneConf#scene_conf.type of
		?SCENE_TYPE_INSTANCE ->
			do_action(SceneState, get_instance_info, [Socket]);
		_ ->
			{ok, SceneState}
	end.

%% 检测是否是多人副本类型
is_multiple_instance(SceneId) ->
	case instance_config:get(SceneId) of
		#instance_conf{} = InstanceConf ->
			InstanceConf#instance_conf.type == ?INSTANCE_TYPE_MULTIPLE
				orelse
				InstanceConf#instance_conf.type == ?INSTANCE_TYP_DRAGON
				orelse
				InstanceConf#instance_conf.type == ?INSTANCE_TYP_WZAD
				orelse
				InstanceConf#instance_conf.type == ?INSTANCE_TYP_SZWW
				orelse
				InstanceConf#instance_conf.type == ?INSTANCE_TYP_ATTACK_CITY
				orelse
				InstanceConf#instance_conf.type == ?INSTANCE_DRAGON_NATIVE
				orelse
				InstanceConf#instance_conf.type == ?INSTANCE_CROSS_BOSS
				orelse
				InstanceConf#instance_conf.type == ?INSTANCE_CROSS_BOSS2
				orelse
				InstanceConf#instance_conf.type == ?INSTANCE_CROSS_KING
				orelse
				InstanceConf#instance_conf.type == ?INSTANCE_CROSS_DARK
				orelse
				InstanceConf#instance_conf.type == ?INSTANCE_TYP_SINGLE_BOSS
				orelse
				InstanceConf#instance_conf.type == ?INSTANCE_CROSS_HJZC_DATING
				orelse
				InstanceConf#instance_conf.type == ?INSTANCE_CROSS_HJZC
				orelse
				InstanceConf#instance_conf.type == ?INSTANCE_NATIVE_HJZC_DATING
				orelse
				InstanceConf#instance_conf.type == ?INSTANCE_NATIVE_HJZC
				orelse
				InstanceConf#instance_conf.type == ?INSTANCE_TYPE_PALACE;
		_ ->
			false
	end.

%% 获取场景副本标记
get_instance_sign(PlayerState, SceneId) ->
	InstanceConf = instance_config:get(SceneId),
	case InstanceConf#instance_conf.type of
		?INSTANCE_TYPE_MULTIPLE ->
			DbBase = PlayerState#player_state.db_player_base,
			DbBase#db_player_base.guild_id;
		?INSTANCE_TYP_DRAGON ->
			?WORLD_ACTIVE_SIGN;
		?INSTANCE_TYP_WZAD ->
			?WORLD_ACTIVE_SIGN;
		?INSTANCE_TYP_SZWW ->
			?WORLD_ACTIVE_SIGN;
		?INSTANCE_TYP_ATTACK_CITY ->
			?WORLD_ACTIVE_SIGN;
	%%个人BOSS副本也当做多人只能自己进的多人副本，这样会保留副本状态
		?INSTANCE_TYP_SINGLE_BOSS ->
			DbBase = PlayerState#player_state.db_player_base,
			DbBase#db_player_base.player_id;
		?INSTANCE_DRAGON_NATIVE ->
			?WORLD_ACTIVE_SIGN;
		?INSTANCE_CROSS_BOSS ->
			?WORLD_ACTIVE_SIGN;
		?INSTANCE_CROSS_BOSS2 ->
			?WORLD_ACTIVE_SIGN;
		?INSTANCE_CROSS_DARK ->
			?WORLD_ACTIVE_SIGN;
		?INSTANCE_CROSS_KING ->
			?WORLD_ACTIVE_SIGN;
		?INSTANCE_CROSS_HJZC ->
			?WORLD_ACTIVE_SIGN;
		?INSTANCE_CROSS_HJZC_DATING ->
			?WORLD_ACTIVE_SIGN;
		?INSTANCE_NATIVE_HJZC ->
			?WORLD_ACTIVE_SIGN;
		?INSTANCE_NATIVE_HJZC_DATING ->
			?WORLD_ACTIVE_SIGN;
		?INSTANCE_TYPE_PALACE ->
			?WORLD_ACTIVE_SIGN;
		_ ->
			?WORLD_ACTIVE_SIGN
	end.

%% ====================================================================
%% Internal functions
%% ====================================================================
%% 执行指令(实现副本多态功能)
do_action(SceneState, ActionFun, Args) ->
	SceneId = SceneState#scene_state.scene_id,
	SceneConf = scene_config:get(SceneId),
	case SceneConf#scene_conf.type of
		?SCENE_TYPE_INSTANCE ->
			InstanceConf = instance_config:get(SceneId),
			case get_instance_lib(InstanceConf#instance_conf.type) of
				null ->
					{ok, SceneState};
				Mod ->
					try erlang:apply(Mod, ActionFun, [SceneState | Args]) of
						NewSceneState when is_record(NewSceneState, scene_state) ->
							{ok, NewSceneState};
						{ok, NewSceneState} when is_record(NewSceneState, scene_state) ->
							{ok, NewSceneState};
						{ok, Result, NewSceneState} ->
							{ok, Result, NewSceneState};
						{stop, Reason, NewSceneState} ->
							{stop, Reason, NewSceneState};
						_ ->
							{ok, SceneState}
					catch
						_Err:_Info ->
							case _Info /= undef of
								true ->
									?ERR("~p : ~p~nstacktrace : ~p", [_Err, _Info, erlang:get_stacktrace()]);
								_ ->
									skip
							end,
							{ok, SceneState}
					end
			end;
		_ ->
			{ok, SceneState}
	end.

%% 根据对应副本标识获取副本逻辑包
get_instance_lib(?INSTANCE_TYPE_SINGLE) -> instance_single_lib;
get_instance_lib(?INSTANCE_TYPE_ARENA) -> instance_arena_lib;
get_instance_lib(?INSTANCE_TYPE_MULTIPLE) -> instance_multiple_lib;
get_instance_lib(?INSTANCE_TYPE_PLOT) -> instance_plot_lib;
get_instance_lib(?INSTANCE_TYP_DRAGON) -> instance_dragon_lib;
get_instance_lib(?INSTANCE_TYP_WZAD) -> instance_dark_lib;
get_instance_lib(?INSTANCE_TYP_SZWW) -> instance_szww_lib;
get_instance_lib(?INSTANCE_TYP_ATTACK_CITY) -> instance_attack_city_lib;
get_instance_lib(?INSTANCE_TYP_SINGLE_BOSS) -> instance_single_boss_lib;
get_instance_lib(?INSTANCE_DRAGON_NATIVE) -> instance_cross_boss_lib;
get_instance_lib(?INSTANCE_CROSS_BOSS) -> instance_cross_boss_lib;
get_instance_lib(?INSTANCE_CROSS_BOSS2) -> instance_cross_boss_lib;
get_instance_lib(?INSTANCE_CROSS_KING) -> instance_king_lib;
get_instance_lib(?INSTANCE_CROSS_DARK) -> instance_dark_lib;
get_instance_lib(?INSTANCE_CROSS_HJZC) -> instance_cross_hjzc_lib;
get_instance_lib(?INSTANCE_CROSS_HJZC_DATING) -> instance_cross_hjzc_dating_lib;
get_instance_lib(?INSTANCE_NATIVE_HJZC) -> instance_cross_hjzc_lib;
get_instance_lib(?INSTANCE_NATIVE_HJZC_DATING) -> instance_cross_hjzc_dating_lib;
get_instance_lib(?INSTANCE_TYPE_PALACE) -> instance_palace_lib;
get_instance_lib(_) -> null.

%% 更新进入过副本的玩家列表
update_enter_player_list(SceneState, PlayerState) ->
	PlayerId = PlayerState#player_state.player_id,
	EnterList = SceneState#scene_state.enter_instance_player_list,
	case lists:member(PlayerId, EnterList) of
		true ->
			SceneState;
		false ->
			NewEnterList = [PlayerId] ++ EnterList,
			SceneId = SceneState#scene_state.scene_id,
			operate_active_lib:update_instance_enter_count(PlayerId, SceneId),
			SceneState#scene_state{enter_instance_player_list = NewEnterList}
	end.