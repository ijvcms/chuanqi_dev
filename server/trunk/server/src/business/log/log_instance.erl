%%%-------------------------------------------------------------------
%%% @author qhb
%%% @copyright (C) 2016, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 27. 六月 2016 下午6:19
%%%-------------------------------------------------------------------
-module(log_instance).
-include("record.hrl").
-include("cache.hrl").
-include("config.hrl").
-include("db_record.hrl").

%% API
-export([
	on_player_enter/2,
	on_player_exit/2,
	on_end_player_exit/1,
	log_enter_time/2,
	log_instance_activity/3,
	log_instance_single/3
]).

%% Gen API
-export([
	log_instance_activity_local/3,
	log_instance_single_local/3
]).

on_player_enter(SceneState, PlayerState) ->
	log_enter_time(PlayerState#player_state.player_id, SceneState#scene_state.scene_id),
	ok.

on_player_exit(SceneState, ObjState) ->
	#scene_obj_state{obj_id = ObjId, name = ObjName} = ObjState,
	log_instance:log_instance_activity(ObjId, ObjName, SceneState),
	ok.

on_end_player_exit(SceneState) ->
	case scene_base_lib:do_get_scene_players(SceneState) of
		[] ->
			skip;
		ObjList ->
			[
				begin
					#scene_obj_state{obj_id = ObjId, name = ObjName} = ObjState,
					log_instance:log_instance_activity(ObjId, ObjName, SceneState)
				end || ObjState <- ObjList]
	end,
	ok.


%%副本进入时间
log_enter_time(PlayerId, SceneId) ->
	log_data:instance_enter_time_put(PlayerId, SceneId).


%%活动副本
log_instance_activity(PlayerId, PlayerName, SceneState) ->
	dp_lib:cast({?MODULE, log_instance_activity_local, [PlayerId, PlayerName, SceneState]}).
log_instance_activity_local(PlayerId, PlayerName, SceneState) ->
	#scene_state{scene_id = SceneId } = SceneState,
	#scene_conf{name = SceneName} = scene_config:get(SceneId),

	Now = util_date:unixtime(),
	EnterTime = case log_data:instance_enter_time_get(PlayerId, SceneId) of
					0 -> Now;
					R -> R
				end,
	ExitTime = Now,
	Duration = ExitTime - EnterTime,
	cache_log_lib:insert(#db_log_instance_activity{
		player_id = PlayerId,
		player_name = PlayerName,
		server_id = config:get_server_no(),
		createtime = util_date:unixtime(),
		scene_id = SceneId,
		scene_name = SceneName,
		enter_time = EnterTime,
		exit_time = ExitTime,
		duration = Duration
	}),
	log_data:instance_enter_time_delete(PlayerId, SceneId),
	ok.

%%个人副本
log_instance_single(PlayerPid, SceneState, Completed) ->
	gen_server2:apply_async(PlayerPid, {?MODULE, log_instance_single_local, [SceneState, Completed]}).
log_instance_single_local(PlayerState, SceneState, Completed) ->
	#player_state{player_id = PlayerId, db_player_base = #db_player_base{name = PlayerName}} = PlayerState,
	#scene_state{scene_id = SceneId } = SceneState,
	#scene_conf{name = SceneName, belong_scene_id = BelongSceneId} = scene_config:get(SceneId),
	{PlayerState1,PlayerInstanceInfo,_InstanceDict}=player_instance_lib:get_instance_info(PlayerState,BelongSceneId),
	EnterTimes = PlayerInstanceInfo#db_player_instance.enter_times,
	Jade =
		case EnterTimes > 1 of
			true -> -20;
			false -> 0
		end,
	Now = util_date:unixtime(),
	case log_data:instance_enter_time_get(PlayerId, SceneId) of
		0 -> skip;
		EnterTime ->
			ExitTime = Now,
			Duration = ExitTime - EnterTime,
			cache_log_lib:insert(#db_log_instance_single{
				player_id = PlayerId,
				player_name = PlayerName,
				server_id = config:get_server_no(),
				createtime = Now,
				scene_id = SceneId,
				scene_name = SceneName,
				enter_time = EnterTime,
				exit_time = ExitTime,
				duration = Duration,
				jade = Jade,
				completed = Completed
			}),
			log_data:instance_enter_time_delete(PlayerId, SceneId)
	end,
	{ok, PlayerState1}.