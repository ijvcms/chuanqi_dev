%%%-------------------------------------------------------------------
%%% @author zhengsiying
%%% @copyright (C) 2015, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 18. 十二月 2015 上午11:33
%%%-------------------------------------------------------------------
-module(scene_activity_base_lib).

-include("common.hrl").
-include("record.hrl").
-include("config.hrl").

%% API
-export([
	init/2,
	on_timer/1,
	on_obj_die/3,
	is_activity_time/1,
	init_time/1
]).

%% ====================================================================
%% API functions
%% ====================================================================
init(SceneState, Args) ->
	do_action(SceneState, init, [Args]).%% 检查场景活动，初始话场景活动信息
%% 场景定时器
on_timer(SceneState) ->
	SceneId = SceneState#scene_state.scene_id,
	SceneStateNew = case SceneState#scene_state.activity_begintime_endtime of
						null ->
							SceneState#scene_state{
								activity_begintime_endtime = scene_activity_palace_lib:get_next_start_time(SceneId)
							};
						_ ->
							SceneState
					end,
	CurTime = util_date:unixtime(),
	{BeginTime, EndTime} = SceneStateNew#scene_state.activity_begintime_endtime,
	%% 获取当前活动的状态信息

	CurStatus = SceneStateNew#scene_state.activity_status,
	SceneState1 =
		if
			BeginTime =< CurTime andalso CurStatus =:= ?ACTIVITY_STATUS_OFF -> %% 查看场景活动的开启时间
				{ok, _SceneState} = on_start(SceneStateNew),
				city_lib:ref_button_tips_sbk(),
				_SceneState;
			CurStatus =:= ?ACTIVITY_STATUS_ON andalso EndTime =< CurTime -> %% 查看场景活动的结束时间
				{ok, _SceneState} = on_end(SceneStateNew),
				city_lib:ref_button_tips_sbk(),
				_SceneState#scene_state{
					activity_begintime_endtime = scene_activity_palace_lib:get_next_start_time(SceneId)
				};
			true ->
				SceneStateNew
		end,
	do_action(SceneState1, on_timer, []).

%% 沙巴克时间重置
init_time(SceneState) ->

	R = scene_activity_shacheng_lib:get_ets_time(),
	R1 = R#ets_sbk_box{
		ref_palace_time = 0,
		ref_shacheng_time = 0
	},
	ets:insert(?ETS_SBK_BOX, R1),

	SceneStateNew = SceneState#scene_state{
		activity_begintime_endtime = scene_activity_palace_lib:get_next_start_time(SceneState#scene_state.scene_id)
	},
	{ok, SceneStateNew}.

%% 活动开启
on_start(SceneState) ->
	?INFO("activity start: ~p", [SceneState#scene_state.scene_id]),
	SceneState1 = SceneState#scene_state{activity_status = ?ACTIVITY_STATUS_ON},
	do_action(SceneState1, on_start, []).%% 启动活动场景
%% 活动结束
on_end(SceneState) ->
	?INFO("activity end: ~p", [SceneState#scene_state.scene_id]),
	SceneState1 = SceneState#scene_state{activity_status = ?ACTIVITY_STATUS_OFF},
	do_action(SceneState1, on_end, []).%% 关闭活动场景
%% 场景obj死亡
on_obj_die(SceneState, DieState, KillerState) ->
	do_action(SceneState, on_obj_die, [DieState, KillerState]).

%% 是否是活动时间 活动是否开启
is_activity_time(SceneState) ->
	SceneState#scene_state.activity_status =:= ?ACTIVITY_STATUS_ON.

%% ====================================================================
%% Internal functions  初始话活动相关信息
%% ====================================================================
%% 执行指令(实现副本多态功能)
do_action(SceneState, ActionFun, Args) ->
	SceneId = SceneState#scene_state.scene_id,
	SceneConf = scene_config:get(SceneId),%% 检查当前场景是否有活动，然后处理活动相关信息
	case get_activity_lib(SceneConf#scene_conf.activity_id) of
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
	end.

%% 根据对应场景获取活动逻辑包
get_activity_lib(?SCENE_ACTIVITY_SHACHENG) -> scene_activity_shacheng_lib;
get_activity_lib(?SCENE_ACTIVITY_PALACE) -> scene_activity_palace_lib;
get_activity_lib(_) -> null.