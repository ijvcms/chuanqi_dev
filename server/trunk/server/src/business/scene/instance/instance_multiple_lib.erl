%%%-------------------------------------------------------------------
%%% @author tuhujia
%%% @copyright (C) 2016, <COMPANY>
%%% @doc
%%%		多人副本
%%% @end
%%% Created : 21. 一月 2016 14:19
%%%-------------------------------------------------------------------
-module(instance_multiple_lib).

-include("common.hrl").
-include("record.hrl").
-include("config.hrl").
-include("proto.hrl").
-include("cache.hrl").

-define(PLAYER_LOGOUT_HOLD_TIME, 300). %% 玩家下线后副本保留时间

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

%% ====================================================================
%% API functions
%% ====================================================================
%% 初始化副本
init(SceneState, PS) ->
	SceneSign = instance_base_lib:get_instance_sign(PS, SceneState#scene_state.scene_id),

	InstanceState = #instance_multiple_state{
		scene_sign = SceneSign
	},
	SceneState#scene_state{instance_state = InstanceState}.

%% 派生的定时器
on_timer(SceneState) ->
	SceneState.

%% 玩家进入事件
on_obj_enter(SceneState, PlayerState) when is_record(PlayerState, player_state) ->
	log_instance:on_player_enter(SceneState, PlayerState),
	SceneState.

%% 对象死亡事件
on_obj_die(SceneState, _DieState, _KillerState) ->
	SceneState.

%% 玩家退出事件
on_player_exit(SceneState, ObjState, _LeaveType) ->
	log_instance:on_player_exit(SceneState, ObjState),
	SceneState.

%% 副本结束
instance_end(SceneState) ->
	SceneState.

%% 副本关闭
instance_close(SceneState) ->
	InstanceState = SceneState#scene_state.instance_state,
	SceneSign = InstanceState#instance_multiple_state.scene_sign,
	SceneId = SceneState#scene_state.scene_id,
	Key = {SceneId, SceneSign},
	case ets:lookup(?ETS_SCENE_MAPS, Key) of
		[_EtsMaps] ->
			ets:delete(?ETS_SCENE_MAPS, Key);
		_ ->
			skip
	end,
	ets:delete(?ETS_SCENE, self()),

	%% 如果是沙巴克副本 清除公会开启状态
	ActConf = guild_active_config:get(?ACTIVE_SBK_FEM),
	InsId = ActConf#guild_active_conf.enter_instance,
	case InsId == SceneId of
		true ->
			guild_active:clear_sbk_fem_state(SceneSign);
		false ->
			skip
	end,

	SceneState.

%% ====================================================================
%% Internal functions
%% ====================================================================
