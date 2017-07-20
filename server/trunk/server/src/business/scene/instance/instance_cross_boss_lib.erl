%%%-------------------------------------------------------------------
%%% @author tuhujia
%%% @copyright (C) 2016, <COMPANY>
%%% @doc
%%%		多人副本
%%% @end
%%% Created : 21. 一月 2016 14:19
%%%-------------------------------------------------------------------
-module(instance_cross_boss_lib).

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
	instance_close/1,
	get_instance_info/2
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

	spec_dragon_lib:scene_line_init(SceneState#scene_state.scene_id, self()),
	SceneConf = scene_config:get(SceneState#scene_state.scene_id),
	SceneState1 = init_monster_area(SceneState, SceneConf),

	SceneState1#scene_state{instance_state = InstanceState}.

%% 派生的定时器
on_timer(SceneState) ->
	SceneState.

%% 玩家进入事件
on_obj_enter(SceneState, PlayerState) when is_record(PlayerState, player_state) ->
	log_instance:on_player_enter(SceneState, PlayerState),
	SceneState.

%% 对象死亡事件
on_obj_die(SceneState, DieState, _KillerState) ->
	case DieState#scene_obj_state.obj_type of
		?OBJ_TYPE_MONSTER ->
			spec_dragon_lib:monster_kill();
		_ ->
			skip
	end,
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

	%%还原火龙神殿的状态
	spec_dragon_lib:reset_state(),
	%%清除结盟状态
	%%alliance_lib:reset(),

	%% 如果是沙巴克副本 清除公会开启状态
%% 	ActConf = guild_active_config:get(?ACTIVE_SBK_FEM),
%% 	InsId = ActConf#guild_active_conf.enter_instance,
%% 	case InsId == SceneId of
%% 		true ->
%% 			guild_active:clear_sbk_fem_state(SceneSign);
%% 		false ->
%% 			skip
%% 	end,

	SceneState.

%% 获取跨服副本的定时信息
get_instance_info(SceneState, PlayerPid) ->
	?INFO("11014 ~p",[7777]),
	CurTime = util_date:unixtime(),
	Timespan = SceneState#scene_state.close_time,
	Data = #rep_cross_boss_result{
		left_time = Timespan - CurTime
	},
	net_send:send_to_client(PlayerPid, 11047, Data).


%% ====================================================================
%% Internal functions
%% ====================================================================

init_monster_area(SceneState, SceneConf) ->
	MonsterList = SceneConf#scene_conf.rule_monster_list,
	F = fun(RuleInfo, Acc) ->
		case RuleInfo of
			{area_type, AreaFlag, MonsterId, Num, RefreshInterval, RefreshLocation} ->
				scene_base_lib:add_monster_area(Acc, AreaFlag, MonsterId, Num, RefreshLocation, RefreshInterval);
			_ ->
				Acc
		end
	end,
	lists:foldl(F, SceneState, MonsterList).