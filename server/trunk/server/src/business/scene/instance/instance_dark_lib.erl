%%%-------------------------------------------------------------------
%%% @author qhb
%%% @copyright (C) 2016, <COMPANY>
%%% @doc
%%%		未知暗殿及跨服暗殿
%%% @end
%%% Created : 21. 一月 2016 14:19
%%%-------------------------------------------------------------------
-module(instance_dark_lib).
%%
-include("common.hrl").
-include("record.hrl").
-include("config.hrl").
-include("proto.hrl").
-include("cache.hrl").

-define(PLAYER_LOGOUT_HOLD_TIME, 300). %% 玩家下线后副本保留时间
-define(REFRESH_TIME, 60). %% 刷新时间间隔(秒)

-record(instance_dark_state, {
	scene_sign,
	monster_num_list,    %%怪物可出现次数列表
	monster_exist        %%已经出现过的怪物
}).

%% API
-export([
	init/2,
	on_timer/1,
	on_obj_enter/2,
	on_obj_die/3,
	on_player_exit/3,
	instance_end/1,
	instance_close/1,
	timer_check/1
]).

%% ====================================================================
%% API functions
%% ====================================================================
%% 初始化副本
init(SceneState, PS) ->
	SceneSign = instance_base_lib:get_instance_sign(PS, SceneState#scene_state.scene_id),
	#scene_conf{rule_monster_list = RuleMonsterList} = scene_config:get(SceneState#scene_state.scene_id),
	MonsterNumList = [{MonsterId, Num} || {_, MonsterId, Num, _, _} <- RuleMonsterList],

	InstanceState = #instance_dark_state{
		scene_sign = SceneSign,
		monster_num_list = MonsterNumList,
		monster_exist = []
	},

	RefreshTime =
		case SceneState#scene_state.scene_id of
			20224 -> 90;
			31005 -> 150;
			32104 -> 150;
			32105 -> 300;
			_ -> ?REFRESH_TIME
		end,
	gen_server2:apply_after(RefreshTime * 1000, self(), {?MODULE, timer_check, []}),

	SceneState1 = SceneState#scene_state{instance_state = InstanceState},
	create_monster(SceneState1).


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
	SceneSign = InstanceState#instance_dark_state.scene_sign,
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

%% ====================================================================
%% Internal functions
%% ====================================================================

%%定时刷新
timer_check(SceneState) ->
	RefreshTime =
		case SceneState#scene_state.scene_id of
			20224 -> 90;
			31005 -> 150;
			32104 -> 150;
			32105 -> 300;
			_ -> ?REFRESH_TIME
		end,
	gen_server2:apply_after(RefreshTime * 1000, self(), {?MODULE, timer_check, []}),
	create_monster(SceneState).

%%创建怪物
create_monster(SceneState) ->
	%%获取怪物ID及可创建次数
	InstanceState = SceneState#scene_state.instance_state,
	#instance_dark_state{monster_num_list = MonsterNumList, monster_exist = MonsterExist} = InstanceState,
	MonsterIdList = [M || {M, N} <- MonsterNumList, N > 0],
	MonsterId = choice_monster(MonsterIdList, MonsterExist),
	case MonsterId > 0 of
		true ->
			{_, Num} = lists:keyfind(MonsterId, 1, MonsterNumList),
			?WARNING("MonsterNumList ~p ~p ~p", [SceneState#scene_state.scene_id, MonsterNumList, MonsterExist]),

			%%创建怪物
			SceneConf = scene_config:get(SceneState#scene_state.scene_id),
			RuleMonsterList = SceneConf#scene_conf.rule_monster_list,
			{monster_type, MonsterId, _Count, RefreshInterval, RefreshLocation} = lists:keyfind(MonsterId, 2, RuleMonsterList),
			Rule = {monster_type, MonsterId, 1, RefreshInterval, RefreshLocation},
			SceneState1 = scene_obj_lib:create_area_monster(SceneState, Rule),

			%%更新场景中,当前怪物剩余可以创建的次数,及已经产生过的怪物
			MonsterExist2 = case lists:member(MonsterId, MonsterExist) of
								true -> MonsterExist;
								false -> [MonsterId | MonsterExist]
							end,
			MonsterNumList2 = lists:keyreplace(MonsterId, 1, MonsterNumList, {MonsterId, Num - 1}),
			InstanceState2 = InstanceState#instance_dark_state{monster_num_list = MonsterNumList2, monster_exist = MonsterExist2},
			SceneState2 = SceneState1#scene_state{instance_state = InstanceState2},
			{ok, SceneState2};
		false ->
			%%?WARNING("monsterid 0", []),
			{ok, SceneState}
	end.

%%选择怪物
choice_monster(MonsterIdList, ExistMonsterIdList) ->
	case MonsterIdList of
		[] ->
			0;
		_ ->
			case lists:subtract(MonsterIdList, ExistMonsterIdList) of
				[] ->
					util_rand:list_rand(MonsterIdList);
				List ->
					util_rand:list_rand(List)
			end
	end.