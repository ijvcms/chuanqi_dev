%%%-------------------------------------------------------------------
%%% @author zhengsiying
%%% @copyright (C) 2015, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 09. 十一月 2015 下午4:46
%%%-------------------------------------------------------------------
-module(scene_send_lib_copy).

-include("common.hrl").
-include("record.hrl").
-include("proto.hrl").
-include("cache.hrl").
-include("config.hrl").

%% API
-export([
	send_scene_info_data/3,
	send_scene_info_data_all/1,
	send_scene_move_info/2,
	send_screen_player/2,
	send_player_id/3,
	send_lists_11020/1,
	send_lists_12010/1,
	get_single_boss_result/1,
	add_single_boss_left_time/2,
	stay_scene/1
]).

-export([
	do_send_scene_info_data/3,
	do_send_scene_info_data_all/4,
	do_send_scene_move_info/2,
	do_send_screen/6,
	send_screen/3,
	do_get_single_boss_result/2,
	do_add_single_boss_left_time/3,
	stay_scene_local/1,
	get_scene_guise/3,
	do_get_scene_guise/3
]).


%% 获取玩家所在场景的对象信息
send_scene_info_data(ScenePid, PlayerPid, SceneObj) ->
	gen_server2:apply_async(ScenePid, {?MODULE, do_send_scene_info_data, [PlayerPid, SceneObj]}).
%% 获取玩家所在场景的对象信息
do_send_scene_info_data(SceneState, PlayerPid, SceneObj) ->
	Data = scene_send_lib:make_rep_change_scene([SceneObj], #rep_change_scene{scene_id = SceneState#scene_state.scene_id}),
	net_send:send_to_client(PlayerPid, 11101, #req_scene_pic{scene_pic = SceneState#scene_state.scene_pic}),
	net_send:send_to_client(PlayerPid, 11001, Data).

%% 获取玩家所在场景的对象信息
get_scene_guise(ScenePid, PlayerPid, PlayerId) ->
	try
		gen_server2:apply_async(ScenePid, {?MODULE, do_get_scene_guise, [PlayerPid, PlayerId]})
	catch
		Err:Info ->
			?ERR("Err ~p ~p", [{Err, Info}, {ScenePid, PlayerPid, PlayerId}]),
			Data = #rep_guise_list{},
%%             ?INFO("11053 ~p ~p", [Data, length(GuiseList)]),
			net_send:send_to_client(PlayerPid, 11053, Data)
	end.
%% 获取玩家所在场景的对象信息
do_get_scene_guise(SceneState, PlayerPid, PlayerId) ->
	MyObj = scene_base_lib:get_scene_obj_state(SceneState, ?OBJ_TYPE_PLAYER, PlayerId),
	case MyObj of
		null ->
			?ERR("sceneid: ~p", [{SceneState#scene_state.scene_id, PlayerId}]);
		_ ->
			#scene_obj_state{x = MX, y = MY} = MyObj,
			ObjList = scene_base_lib:do_get_scene_obj_list(SceneState, [?OBJ_TYPE_PLAYER, ?OBJ_TYPE_MONSTER]),
			F = fun(X, {TempGuiseList, TempMonsterList}) ->
				#scene_obj_state{x = X1, y = Y1, guise = Guise, monster_res_id = MonsterResId, obj_type = ObjType} = X,
				case ObjType of
					?OBJ_TYPE_PLAYER ->
						TempGuise = {util_math:get_distance_set({MX, MY}, {X1, Y1}), Guise},
						{[TempGuise | TempGuiseList], TempMonsterList};
					_ ->
						{TempGuiseList, [MonsterResId | TempMonsterList]}
				end
			end,
			{GuiseList, MonsterResList} = lists:foldl(F, {[], []}, ObjList),
			GuiseList1 = lists:keysort(1, GuiseList),
			{WeaponList, ClothesList, WingList} = get_guise_list(GuiseList1, [], [], []),
			Data = #rep_guise_list{
				weapon_list = WeaponList,
				clothes_list = ClothesList,
				wing_list = WingList,
				monster_list = MonsterResList
			},
			?INFO("11053 ~p ~p", [Data, length(GuiseList)]),
			net_send:send_to_client(PlayerPid, 11053, Data)
	end.
%% 获取材质列表
get_guise_list([], WeaponList, ClothesList, WingList) ->
	{WeaponList, ClothesList, WingList};
get_guise_list([{_, Guise} | GuiseList], WeaponList, ClothesList, WingList) ->
	#guise_state{weapon = Weapon, clothes = Clothes, wing = Wing} = Guise,
	WeaponList1 = case Weapon =:= 0 orelse lists:member(Weapon, WeaponList) of
					  true ->
						  WeaponList;
					  _ ->
						  [Weapon | WeaponList]
				  end,
	ClothesList1 = case Clothes =:= 0 orelse lists:member(Clothes, ClothesList) of
					   true ->
						   ClothesList;
					   _ ->
						   [Clothes | ClothesList]
				   end,
	WingList1 = case Wing =:= 0 orelse lists:member(Wing, WingList) of
					true ->
						WingList;
					_ ->
						[Wing | WingList]
				end,
	get_guise_list(GuiseList, WeaponList1, ClothesList1, WingList1).

%% 发送周围玩家给玩家自己， 把自己信息告诉周围的玩家
send_scene_info_data_all(PlayerState) ->
	gen_server2:apply_async(PlayerState#player_state.scene_pid, {?MODULE, do_send_scene_info_data_all, [PlayerState#player_state.socket, PlayerState#player_state.scene_obj, PlayerState#player_state.player_id]}).


%% 发送周围玩家给玩家自己， 把自己信息告诉周围的玩家
do_send_scene_info_data_all(SceneState, Socket, SceneObj, PlayerId) ->
	case scene_base_lib:do_get_screen_obj(SceneState, ?OBJ_TYPE_PLAYER, PlayerId, false) of
		[] ->
			skip;
		ObjList ->
			{Data, TempNum} = scene_send_lib:make_rep_obj_enter(ObjList, {#rep_obj_enter{}, 0}),
			case TempNum > 0 of
				true ->
					net_send:send_to_client(Socket, 11005, Data);
				_ ->
					skip
			end,
			TempList = [X || X <- ObjList, X#scene_obj_state.obj_type =:= ?OBJ_TYPE_PLAYER],
			scene_send_lib:send_enter_screen(TempList, SceneObj, false),
			game_obj_lib:set_monster_targer(SceneState, ?OBJ_TYPE_PLAYER, PlayerId, ObjList)
	end.

%%发送 11020列表
send_lists_11020([{PlayerId, Data} | H]) ->
	Data1 = scene_send_lib:make_rep_obj_often_update(Data, #rep_obj_often_update{}),
	send_player_id(PlayerId, 11020, Data1),
	send_lists_11020(H);
send_lists_11020([]) ->
	[].

%% 发送12010列表
send_lists_12010([{PlayerId, TargetList, BuffList, MoveList, KnockBackList} | H]) ->
	Data = #rep_trigger_skill{
		target_list = TargetList,
		buff_list = BuffList,
		move_list = MoveList,
		knockback_list = KnockBackList
	},
	send_player_id(PlayerId, 12010, Data),
	send_lists_12010(H);
send_lists_12010([]) ->
	[].

%% 个人boss副本，前前端完全进入副本场景后发获取
get_single_boss_result(PlayerState) ->
	gen_server2:apply_async(PlayerState#player_state.scene_pid, {?MODULE, do_get_single_boss_result, [PlayerState]}).
do_get_single_boss_result(SceneState, PlayerState) ->
	case SceneState#scene_state.instance_state of
		#instance_single_boss_state{
			enter_time = EnterTime,
			boss_count = BossCount,
			kill_boss_count = KillBossCount
		} ->
			#player_state{db_player_base = #db_player_base{instance_left_time = LeftTimeOld}} = PlayerState,
			CurTime = util_date:unixtime(),
			LeftTime = erlang:max(LeftTimeOld - (CurTime - EnterTime), 0),

			Rep = #rep_single_boss_result{left_time = LeftTime, left_boss = BossCount - KillBossCount},
			%%?WARNING("send_result ~p", [Rep]),
			scene_send_lib:do_send_scene(SceneState, 11045, Rep);
		_ ->
			skip
	end.

%% 个人boss副本，增加副本时间
add_single_boss_left_time(PlayerState, Time) ->
	case scene_config:get(PlayerState#player_state.scene_id) of
		#scene_conf{type = ?SCENE_TYPE_INSTANCE} ->
			InstanceConf = instance_config:get(PlayerState#player_state.scene_id),
			case InstanceConf#instance_conf.type =:= 9 of
				true ->
					gen_server2:apply_async(PlayerState#player_state.scene_pid, {?MODULE, do_add_single_boss_left_time, [PlayerState, Time]});
				false ->
					skip
			end;
		_ ->
			skip
	end.
do_add_single_boss_left_time(SceneState, PlayerState, Time) ->
	InstanceState = SceneState#scene_state.instance_state,
	case InstanceState of
		#instance_single_boss_state{} ->
			#player_state{db_player_base = #db_player_base{instance_left_time = LeftTimeOld}} = PlayerState,
			NewInstanceState = InstanceState#instance_single_boss_state{left_time = LeftTimeOld + Time},
			NewSceneState = SceneState#scene_state{instance_state = NewInstanceState},
			do_get_single_boss_result(NewSceneState, PlayerState),
			{ok, NewSceneState};
		_ ->
			skip
	end.

%% 副本通关后继续留在副本中
stay_scene(PlayerState) ->
	SceneId = PlayerState#player_state.scene_id,
	case scene_config:get(SceneId) of
		#scene_conf{type = ?SCENE_TYPE_INSTANCE} ->
			%%InstanceConf = instance_config:get(SceneId),
			case not instance_base_lib:is_multiple_instance(SceneId) of
				true ->
					gen_server2:apply_async(PlayerState#player_state.scene_pid, {?MODULE, stay_scene_local, []});
				false ->
					skip
			end;
		_ ->
			skip
	end.
stay_scene_local(SceneState) ->
	CurTime = util_date:unixtime(),
	{ok, SceneState#scene_state{close_time = CurTime + 300}}.


%% ====================================================================
%% Internal functions 发送给场景中的玩家
%% ====================================================================
send_screen_player(ObjList, Bin) ->
	[begin
		 case Obj#scene_obj_state.obj_type of
			 ?OBJ_TYPE_PLAYER ->
				 send_scene_move_info(Obj#scene_obj_state.obj_id, Bin);
			 _ ->
				 skip
		 end
	 end || Obj <- ObjList].

%% 全屏广播 包含自己
send_screen(PlayerState, Cmd, Data) ->
	gen_server2:apply_async(PlayerState#player_state.scene_pid, {?MODULE, do_send_screen, [?OBJ_TYPE_PLAYER, PlayerState#player_state.player_id, true, Cmd, Data]}).

%% 全屏广播(不包括自己)
do_send_screen(SceneState, ObjType, ObjId, IncludeSelf, Cmd, Data) ->
	case scene_base_lib:do_get_screen_biont(SceneState, ObjType, ObjId, IncludeSelf) of
		[] ->
			skip;
		ObjList ->
			{ok, Bin} = pt:write_cmd(Cmd, Data),
			Bin1 = pt:pack(Cmd, Bin),
			F = fun(ObjState) ->
				case ObjState#scene_obj_state.obj_type of
					?OBJ_TYPE_PLAYER ->
						%% ?INFO("send player: ~p: ~p", [ObjState#scene_obj_state.obj_id, Data]),
						send_scene_move_info(ObjState#scene_obj_state.obj_id, Bin1);
					_ ->
						skip
				end
			end,
			[F(X) || X <- ObjList]
	end.

send_player_id(PlayerId, Cmd, Data) ->
	{ok, Bin} = pt:write_cmd(Cmd, Data),
	Bin1 = pt:pack(Cmd, Bin),
	send_scene_move_info(PlayerId, Bin1).

%% 发送移动信息
send_scene_move_info(Playerid, Bin) ->
	net_send:send_one(Playerid, Bin).

%% 发送移动信息
do_send_scene_move_info(PlayerState, Bin) ->
	case PlayerState#player_state.is_load_over of
		false ->
			skip;
		_ ->
			net_send:send_one(PlayerState#player_state.socket, Bin)
	end.


