%%%-------------------------------------------------------------------
%%% @author zhengsiying
%%% @copyright (C) 2015, <COMPANY>
%%% @doc
%%%		个人副本逻辑
%%% @end
%%% Created : 10. 十二月 2015 下午4:44
%%%-------------------------------------------------------------------
-module(instance_cross_hjzc_dating_lib).

-include("common.hrl").
-include("record.hrl").
-include("config.hrl").
-include("proto.hrl").
-include("log_type_config.hrl").
-include("cache.hrl").
-include("language_config.hrl").


%% API
-export([
	init/2,
	on_timer/1,
	on_obj_enter/2,
	on_obj_die/3,
	on_player_exit/3,
	instance_end/1,
	instance_close/1,
	on_collection/3
]).



-define(REF_TIME_HJZC, 600). %% 宝箱刷新规则
%% ====================================================================
%% API functions
%% ====================================================================
%% 初始化副本
init(SceneState, _PS) ->
	SceneState#scene_state{refuse_box_time_shacheng = util_date:unixtime() + ?REF_TIME_HJZC}.

%% 定时器
on_timer(SceneState) ->
	RefTime = SceneState#scene_state.refuse_box_time_shacheng,
	CurTime = util_date:unixtime(),
	case CurTime >= RefTime of
		true ->
			%% 获取幻境的相关信息
			HjzcInfo = scene_hjzc_lib:get_hjzc_info(),
			case HjzcInfo#ets_hjzc.rand_room_num_list /= [] of
				true ->
					%% 随机幻境宝箱出现的房间
					Room1 = util_rand:list_rand(HjzcInfo#ets_hjzc.rand_room_num_list),

					%% 保存新的幻境信息
					HjzcInfo1 = HjzcInfo#ets_hjzc{
						box_from_list = [Room1 | HjzcInfo#ets_hjzc.box_from_list],
						record_box_list = [Room1 | HjzcInfo#ets_hjzc.record_box_list],
						rand_room_num_list = lists:delete(Room1, HjzcInfo#ets_hjzc.rand_room_num_list)
					},
					%%?WARNING("~p", [HjzcInfo1#ets_hjzc.box_from_list]),
					scene_hjzc_lib:save_hjzc(HjzcInfo1),
					SceneState#scene_state{refuse_box_time_shacheng = CurTime + ?REF_TIME_HJZC};
				_ ->
					SceneState
			end;
		_ ->
			SceneState
	end.

%% 玩家进入事件
on_obj_enter(SceneState, PlayerState) when is_record(PlayerState, player_state) ->
	SceneState.
%% 个人副本 对象死亡逻辑
%% 对象死亡事件
on_obj_die(SceneState, _DieState, _KillerState) ->
	SceneState.

%% 采集
on_collection(SceneState, _DieState, _KillerState) ->
	SceneState.

%% 玩家退出副本事件
on_player_exit(SceneState, _ObjState, _LeaveType) ->
	SceneState.

%% 副本结束事件(副本结束不等同于副本关闭)，副本结束后不再计算通关条件，如果通关条件没有达成说明通关失败，如果已经达成说明通关成功
instance_end(SceneState) ->
	SceneState#scene_state{instance_end_state = ?INSTANCE_END_STATE}.

%% 副本关闭事件(一般情况下会将在副本里的玩家/宠物踢出副本，这里基类已经实现了这个功能，派生类只需要写自己的特殊逻辑处理)
instance_close(SceneState) ->
	scene_hjzc_lib:close_hjzc(SceneState#scene_state.scene_id),
%% 获取场景副本标记
	SceneSign = instance_base_lib:get_instance_sign(null, SceneState#scene_state.scene_id),
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







