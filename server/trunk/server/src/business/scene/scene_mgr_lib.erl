%%%-------------------------------------------------------------------
%%% @author zhengsiying
%%% @copyright (C) 2015, <COMPANY>
%%% @doc
%%%		场景管理模块
%%% @end
%%% Created : 27. 七月 2015 上午10:57
%%%-------------------------------------------------------------------
-module(scene_mgr_lib).

-include("common.hrl").
-include("record.hrl").
-include("config.hrl").
-include("cache.hrl").
-include("proto.hrl").
-include("language_config.hrl").
-include("log_type_config.hrl").

-define(SERVER, scene_mgr_mod).

%% API
-export([
	create_scene/1,
	create_scene/2,
	change_scene/3,
	change_scene/4,
	change_scene/5,
	change_scene/6,
	change_scene/7,
	succeed_change_scene/3,
	leave_scene/2,
	close_all_scene/0,
	close_scene/1,
	exit_instance/1,
	create_permanently_scene/0,
	update_boss_refresh/4,
	get_boss_refresh/2,
	get_new_pk_mode/3,
	change_scene_line/6,
	get_line_num/2,
	get_scene_player_num/1,
	get_scene_player_num/2,
	check_condition/5
]).

%% callbacks
-export([
	do_create_scene/2,
	do_create_scene/3,
	do_change_scene/7,
	do_succeed_change_scene/4,
	do_leave_scene/3,
	do_close_scene/2,
	do_create_permanently_scene/1
]).

%% ====================================================================
%% API functions
%% ====================================================================
%% 创建场景（非场景管理进程使用）
create_scene(SceneId) ->
	gen_server2:apply_sync(misc:whereis_name({local, ?SERVER}), {?MODULE, do_create_scene, [SceneId]}).

create_scene(SceneId, PlayerState) ->
	gen_server2:apply_sync(misc:whereis_name({local, ?SERVER}), {?MODULE, do_create_scene, [SceneId, PlayerState]}).

%% 创建场景(场景管理进程使用)
do_create_scene(_State, SceneId) ->
	%% 获取属于的线路
	LineNum = get_use_scene_line_scene_id(SceneId),
	case scene_mod:start(SceneId, LineNum) of %%初始化 场景  并获取盗场景的 状态pid
		{ok, Pid} ->
			EtsScene = #ets_scene{
				pid = Pid,
				scene_id = SceneId,
				player_list = []
			},
			ets:insert(?ETS_SCENE, EtsScene),
			PidLine = #pid_line{
				pid = Pid,
				line_num = LineNum
			},
			case ets:lookup(?ETS_SCENE_MAPS, SceneId) of
				[EtsMaps] ->
					NewPidLineList = EtsMaps#ets_scene_maps.pid_list ++ [PidLine],
					ets:insert(?ETS_SCENE_MAPS, EtsMaps#ets_scene_maps{pid_list = NewPidLineList});
				_ ->
					ets:insert(?ETS_SCENE_MAPS, #ets_scene_maps{scene_id = SceneId, pid_list = [PidLine]})
			end,
			{ok, Pid};
		Err ->
			?ERR("create scene ~p error: ~p", [SceneId, Err]),
			{fail, Err}
	end.

do_create_scene(_State, SceneId, PlayerState) ->
	%% 获取属于的线路
	LineNum = get_use_scene_line_scene_id(SceneId, PlayerState),
	case scene_mod:start(SceneId, PlayerState, LineNum) of %%初始化 场景  并获取盗场景的 状态pid
		{ok, Pid} ->
			EtsScene = #ets_scene{
				pid = Pid,
				scene_id = SceneId,
				player_list = []
			},
			ets:insert(?ETS_SCENE, EtsScene),

			PidLine = #pid_line{
				pid = Pid,
				line_num = LineNum
			},
			%% 多人副本创建纪录修改
			case instance_base_lib:is_multiple_instance(SceneId) of
				false ->
					case ets:lookup(?ETS_SCENE_MAPS, SceneId) of
						[EtsMaps] ->
							NewPidLineList = EtsMaps#ets_scene_maps.pid_list ++ [PidLine],
							ets:insert(?ETS_SCENE_MAPS, EtsMaps#ets_scene_maps{pid_list = NewPidLineList});
						_ ->
							ets:insert(?ETS_SCENE_MAPS, #ets_scene_maps{scene_id = SceneId, pid_list = [PidLine]})
					end;
				true ->
					SceneSign = instance_base_lib:get_instance_sign(PlayerState, SceneId),
					case ets:lookup(?ETS_SCENE_MAPS, {SceneId, SceneSign}) of
						[EtsMaps] ->
							NewPidLineList = EtsMaps#ets_scene_maps.pid_list ++ [PidLine],
							ets:insert(?ETS_SCENE_MAPS, EtsMaps#ets_scene_maps{pid_list = NewPidLineList});
						_ ->
							ets:insert(?ETS_SCENE_MAPS, #ets_scene_maps{scene_id = {SceneId, SceneSign}, pid_list = [PidLine]})
					end
			end,
			{ok, Pid};
		Err ->
			?ERR("create scene ~p error: ~p", [SceneId, Err]),
			{fail, Err}
	end.

%% 创建永存场景
create_permanently_scene() ->
	gen_server2:apply_sync(misc:whereis_name({local, ?SERVER}), {?MODULE, do_create_permanently_scene, []}, 10 * 1000).
%% 创建永存场景2
do_create_permanently_scene(_State) ->
	F = fun(Type) ->
		SceneList = scene_config:get_type_list(Type),
		F1 = fun(X) ->
			do_create_scene(_State, X)
		end,
		[F1(SceneId) || SceneId <- SceneList, not lists:member(SceneId, scene_config:get_cross_list())]
	end,
%%  永存场景类型
	PermSceneList = [?SCENE_TYPE_MAIN_CITY, ?SCENE_TYPE_OUTDOOR],
	[F(Type) || Type <- PermSceneList],

	%% 创建完场景创建随机怪物(随机怪物只刷新在1线)
	create_random_monster().

create_random_monster() ->
	List = random_monster_config:get_list(),
	create_random_monster([], List).
create_random_monster(_, []) ->
	skip;
create_random_monster(TypeList, [Id | T]) ->
	Conf = random_monster_config:get(Id),
	Type = Conf#random_monster_conf.batch,
	case lists:member(Type, TypeList) of
		true ->
			skip;
		false ->
			%% 属怪
			scene_obj_lib:refuse_random_monster(Conf),
			create_random_monster([Type] ++ TypeList, T)
	end.

%% 切换场景(玩家进程掉用)
change_scene(PlayerState, PlayerPid, SceneId) ->%%?CHANGE_SCENE_TYPE_CHANGE 主动切换场景
	change_scene(PlayerState, PlayerPid, SceneId, ?CHANGE_SCENE_TYPE_CHANGE, null).%%
%% 切换场景
change_scene(PlayerState, PlayerPid, SceneId, ChangeType) ->
	change_scene(PlayerState, PlayerPid, SceneId, ChangeType, null).%%

%% 切换场景(玩家进程掉用)
change_scene(PlayerState, PlayerPid, SceneId, ChangeType, Point) ->
	change_scene(PlayerState, PlayerPid, SceneId, ChangeType, Point, null, false).


%%主动切换线,本服幻境有使用
change_scene(PlayerState, PlayerPid, SceneId, ChangeType, Point, LineNum) ->
	change_scene(PlayerState, PlayerPid, SceneId, ChangeType, Point, null, false, LineNum).


%% 如果是合服场景，判断是否放
change_scene(PlayerState, PlayerPid, SceneId, ChangeType, Point, ItemLoss, IsNotItem) ->
	change_scene(PlayerState, PlayerPid, SceneId, ChangeType, Point, ItemLoss, IsNotItem, 0).
%% 如果是合服场景，判断是否放
change_scene(PlayerState, PlayerPid, SceneId, ChangeType, Point, ItemLoss, IsNotItem, LineNum) ->
	case function_db:is_open_scene(SceneId) of
		true ->
			change_scene_new(PlayerState, PlayerPid, SceneId, ChangeType, Point, ItemLoss, IsNotItem, LineNum);
		_ ->
			net_send:send_to_client(PlayerState#player_state.socket, 11001, #rep_change_scene{result = ?ERR_SCENE_MERGE_NO_OPEN}),
			{ok, PlayerState}
	end.

%% 切换场景(玩家进程掉用) 有特殊道具消耗 IsDelItem是否 验证道具
change_scene_new(PlayerState, PlayerPid, SceneId, ChangeType, Point, ItemLoss, IsNotItemTemp, LineNum) ->
	SceneConf = scene_config:get(SceneId),
	case ChangeType of
		?CHANGE_SCENE_TYPE_CHANGE ->
			%% 只有切换场景才需要做条件判断和扣物品的检查
			{PlayerState1, EnterTimes} = player_instance_lib:get_instance_enter_times(PlayerState, SceneId),
			IsNotItem =
				case IsNotItemTemp of
					false ->
						check_scene_cost(PlayerState1, SceneConf);
					_ ->
						IsNotItemTemp
				end,
			case check_condition(PlayerState1, SceneId, EnterTimes, ItemLoss, IsNotItem, LineNum) of
				{true, TimeSpan} ->
					NewPlayerState =
						case SceneConf#scene_conf.type of
							?SCENE_TYPE_INSTANCE ->
								case active_instance_config:get(SceneId) of
									#active_instance_conf{} = _ ->
										PlayerState1#player_state{
											scene_parameters = TimeSpan
										};
									_ ->
										?INFO("TTTSSS1111 ~p", [11]),
										%% 如果进入副本则需要扣相应的道具并且增加副本进入次数
										InstanceConf = instance_config:get(SceneId),
										{ok, PlayerState2} = goods_util:delete_special_list(PlayerState1, InstanceConf#instance_conf.cost, ?LOG_TYPE_TRANSFER),
										PlayerState3 = player_instance_lib:add_instance_enter_times(PlayerState2, SceneConf#scene_conf.belong_scene_id),
										PlayerState3
								end;
							_ ->

								?INFO("TTTSSS222 ~p", [11]),
								Cost = SceneConf#scene_conf.cost,

								%% 判断是否扣除道具信息
								{ok, PlayerState2} =
									case Cost =:= [] orelse IsNotItem of
										true -> {ok, PlayerState1};
										_ ->
											goods_util:delete_special_list(PlayerState1, Cost, ?LOG_TYPE_TRANSFER)
									end,
								{ok, PlayerState4} = case ItemLoss of
														 null -> {ok, PlayerState2};
														 {ItemId, ItemNum, Type} ->
															 case goods_lib_log:delete_goods_by_num(PlayerState2, ItemId, ItemNum, Type) of
																 {ok, PlayerState3} ->
																	 {ok, PlayerState3};
																 _ ->
																	 {ok, PlayerState2}
															 end
													 end,
								PlayerState4
						end,
					change_scene_cross(NewPlayerState, PlayerPid, SceneId, ChangeType, Point, LineNum);
				{fail, Err} ->
					?INFO("TTTSSS333 ~p", [Err]),
					net_send:send_to_client(PlayerState#player_state.socket, 11001, #rep_change_scene{result = Err}),
					{ok, PlayerState}
			end;
		_ ->
			change_scene_cross(PlayerState, PlayerPid, SceneId, ChangeType, Point, LineNum)
	end.

%% 检测场景消耗
check_scene_cost(PlayerState, SceneConf) ->
	OldSceneConf = scene_config:get(PlayerState#player_state.scene_id),
	case is_record(OldSceneConf, scene_conf) andalso
		OldSceneConf#scene_conf.belong_scene_id =:= SceneConf#scene_conf.belong_scene_id andalso
		OldSceneConf#scene_conf.power_limit > SceneConf#scene_conf.power_limit
	of
		true ->
			true;
		_ ->
			false
	end.

%% 检查切换场景条件是否满足
check_condition(PlayerState, SceneId, EnterTimes, ItemLoss, IsNotItem) ->
	check_condition(PlayerState, SceneId, EnterTimes, ItemLoss, IsNotItem, 0).
%% 检查切换场景条件是否满足
check_condition(PlayerState, SceneId, EnterTimes, ItemLoss, IsNotItem, LineNum) ->
	case scene_config:get(SceneId) of
		#scene_conf{} = SceneConf ->
			DbPlayerBase = PlayerState#player_state.db_player_base,
			%% 如何是副本场景，还需要进一步判断副本进入次数和道具
			case active_instance_config:get(SceneId) of
				#active_instance_conf{} = _ ->
					check_condition2(PlayerState, SceneConf, ItemLoss, IsNotItem);
				_ ->
					%% 判断场景类型
					case SceneConf#scene_conf.type of
						?SCENE_TYPE_INSTANCE ->
							check_condition1(PlayerState, SceneConf, EnterTimes, IsNotItem, LineNum);
						_ ->
							case DbPlayerBase#db_player_base.lv >= SceneConf#scene_conf.lv_limit of
								true ->
									case PlayerState#player_state.fighting > SceneConf#scene_conf.power_limit of
										true ->
											case IsNotItem orelse goods_util:check_special_list(PlayerState, SceneConf#scene_conf.cost) of
												true ->
													%% 是否还有其他的道具消耗
													case ItemLoss of
														{ItemId, ItemNum, _Type} ->
															case goods_util:check_special_list(PlayerState, [{ItemId, ItemNum}]) of
																true ->
																	case DbPlayerBase#db_player_base.vip >= SceneConf#scene_conf.viplv_limit of
																		true -> {true, 0};
																		false -> {fail, ?ERR_PLAYER_VIPLV_NOT_ENOUGH}
																	end;
																Fail ->
																	Fail
															end;
														_ ->
															{true, 0}
													end;
												Fail ->
													Fail
											end;
										_ ->
											{fail, ?ERR_PLAYER_FIGHT_NOT_ENOUGH}
									end;
								_ ->
									{fail, ?ERR_PLAYER_LV_NOT_GO_TO}    %% 等级不足
							end
					end
			end;
		_ ->
			{fail, ?ERR_COMMON_FAIL}
	end.

%% 如何是副本场景，还需要进一步判断副本进入次数和道具
check_condition1(PlayerState, SceneConf, EnterTimes, IsNotItem, LineNum) ->
	case scene_config:get(PlayerState#player_state.scene_id) of
		#scene_conf{} = OldSceneConf ->
			%% 玩家原先所在的场景
			case OldSceneConf#scene_conf.type =:= ?SCENE_TYPE_INSTANCE andalso PlayerState#player_state.scene_id =:= SceneConf#scene_conf.scene_id
				andalso PlayerState#player_state.scene_line_num =:= LineNum of
				true ->
					{fail, ?ERR_SCENE_INSTANCE};
				_ ->
					SceneId = SceneConf#scene_conf.scene_id,
					DbPlayerBase = PlayerState#player_state.db_player_base,
					case DbPlayerBase#db_player_base.lv >= SceneConf#scene_conf.lv_limit of
						true ->
							case PlayerState#player_state.fighting > SceneConf#scene_conf.power_limit of
								true ->
									InstanceConf = instance_config:get(SceneId),
									case (EnterTimes < InstanceConf#instance_conf.times_limit
										orelse InstanceConf#instance_conf.times_limit =< 0 orelse IsNotItem)
										andalso check_instance(InstanceConf#instance_conf.type, InstanceConf) of
										true ->
											case IsNotItem orelse goods_util:check_special_list(PlayerState, InstanceConf#instance_conf.cost) of
												true ->
													%%检查个人boss剩余时间
													case InstanceConf#instance_conf.type =/= 9
														orelse DbPlayerBase#db_player_base.instance_left_time > 0 of
														true ->
															{true, 0};
														false ->
															{fail, ?ERR_INSTANCE_LEFT_TIME_LIMIT}
													end;
												_ ->
													{fail, ?ERR_GOODS_NOT_ENOUGH}
											end;
										_ ->
											{fail, ?ERR_ARENA_CHALL_NOT_ENOUGH} %% 副本进入次数用光了
									end;
								_ ->
									{fail, ?ERR_PLAYER_FIGHT_NOT_ENOUGH}%% 玩家战力不足
							end;
						_ ->
							{fail, ?ERR_PLAYER_LV_NOT_GO_TO}    %% 等级不足
					end
			end;
		_ ->
			{fail, ?ERR_SCENE}
	end.
%% 如何是活动，判断活动的开启时间
check_condition2(PlayerState, SceneConf, ItemLoss, IsNotItem) ->
	%% 玩家原先所在的场景
	DbPlayerBase = PlayerState#player_state.db_player_base,
	case DbPlayerBase#db_player_base.lv >= SceneConf#scene_conf.lv_limit of
		true ->
			case PlayerState#player_state.fighting > SceneConf#scene_conf.power_limit of
				true ->
					case active_instance_lib:is_open_active(SceneConf#scene_conf.scene_id) of
						{ok, TimeSpam} ->
							case IsNotItem of
								true ->
									{true, TimeSpam};
								_ ->
									case goods_util:check_special_list(PlayerState, SceneConf#scene_conf.cost) of
										true ->
											%% 是否还有其他的道具消耗
											case ItemLoss of
												{ItemId, ItemNum, _Type} ->
													case goods_util:check_special_list(PlayerState, [{ItemId, ItemNum}]) of
														true ->
															{true, TimeSpam};
														Fail ->
															Fail
													end;
												_ ->
													{true, TimeSpam}
											end;
										Fail ->
											Fail
									end
							end;
						Fail ->
							Fail
					end;
				_ ->
					{fail, ?ERR_PLAYER_FIGHT_NOT_ENOUGH}
			end;
		_ ->
			{fail, ?ERR_PLAYER_LV_NOT_GO_TO}    %% 等级不足
	end.

%% 判断玩家是否可以进入剧情副本
check_instance(?INSTANCE_TYPE_PLOT, InstanceConf) ->
	TaskList = player_task_dict:get_player_task_list(),
	F = fun(X, IsOk) ->
		case IsOk of
			true ->
				IsOk;
			_ ->
				case X#db_player_task.isfinish of
					1 ->
						false;
					_ ->
						TaskConf = task_config:get(X#db_player_task.taskid_id),
						case TaskConf#task_conf.openinstance of
							<<"">> ->
								false;
							OpenWinInfo ->
								OpenWinInfo1 = erlang:binary_to_list(OpenWinInfo),
								TList = string:tokens(OpenWinInfo1, ","),
								TId = list_to_integer(lists:last(TList)),
								Conf = scene_transport_config:get(TId),
								Conf#scene_transport_conf.scene_id =:= InstanceConf#instance_conf.scene_id
						end
				end
		end
	end,
	lists:foldr(F, false, TaskList);
check_instance(_, _) ->
	true.

%% 检查切换场景是否需要恢复血量
need_recover(ChangeType, CurSceneId, NewSceneId) ->
	case ChangeType of
		?CHANGE_SCENE_TYPE_CHANGE ->%% 主动切换场景
			NewSceneConf = scene_config:get(NewSceneId),%% 新场景信息
			case NewSceneConf#scene_conf.type of
				?SCENE_TYPE_INSTANCE ->%% 普通副本
					NewInstanceConf = instance_config:get(NewSceneId),%% 获取普通副本信息
					NewInstanceConf#instance_conf.recover =:= ?INSTANCE_RECOVER_IS;%% 进出满状态
				_ ->
					case util_data:is_null(CurSceneId) of%%  检查cursceneid是否为空
						true ->
							false;
						_ ->
							CurSceneConf = scene_config:get(CurSceneId),%% 获取老场景信息
							case CurSceneConf#scene_conf.type of
								?SCENE_TYPE_INSTANCE ->%% 普通副本
									CurInstanceConf = instance_config:get(CurSceneId),
									CurInstanceConf#instance_conf.recover =:= ?INSTANCE_RECOVER_IS;
								_ ->
									false
							end
					end
			end;
		?CHANGE_SCENE_TYPE_LEAVE_INSTANCE ->%% 离开副本
			case util_data:is_null(CurSceneId) of
				true ->
					false;
				_ ->
					CurSceneConf = scene_config:get(CurSceneId),
					case CurSceneConf#scene_conf.type of
						?SCENE_TYPE_INSTANCE ->
							CurInstanceConf = instance_config:get(CurSceneId),
							CurInstanceConf#instance_conf.recover =:= ?INSTANCE_RECOVER_IS;
						_ ->
							false
					end
			end;
		_ ->
			false
	end.

%% 跨服验证
change_scene_cross(PlayerState, PlayerPid, SceneId, ChangeType, Point, LineNum) ->
	SceneConf = scene_config:get(SceneId),
	#player_state{server_pass = ServerPass} = PlayerState,
	case SceneConf#scene_conf.is_cross of
		1 ->
			?INFO("change_scene_cross ~p", [1111]),
			%% 如果是在跨服的话 那么处理跨服信息
			Result = case util_data:is_null(ServerPass) of
						 true ->
							 scene_cross:send_cross(PlayerState);
						 _ ->
							 {ok, PlayerState}
					 end,
			case Result of
				{ok, PlayerState1} ->
					case cross_lib:send_cross_mfc(PlayerState1#player_state.server_pass, ?MODULE, change_scene, [PlayerState1, PlayerPid, SceneId, ChangeType, Point, LineNum]) of
						{ok, PlayerState2} ->
							{ok, PlayerState2};
						_Err ->
							?ERR("~p", [_Err]),
							net_send:send_to_client(PlayerState#player_state.socket, 11001, #rep_change_scene{result = ?ERR_COMMON_FAIL})
					end;
				{fail, Err} ->
					net_send:send_to_client(PlayerState#player_state.socket, 11001, #rep_change_scene{result = Err}),
					{ok, PlayerState}
			end;
		_ ->
			?INFO("change_scene_cross ~p", [2222]),
			%% 如果不是在跨服的话 那么移除跨服信息
			PlayerState1 = scene_cross:send_log_out(PlayerState),
			change_scene1(PlayerState1, PlayerPid, SceneId, ChangeType, Point, LineNum)
	end.


%% 切换场景(这里必须用异步操作，原来用同步操作压力大时会出现timeout)
change_scene1(PlayerState, PlayerPid, SceneId, ChangeType, Point, LineNum) ->
	%% 如果是同一张场景
	#player_state{
		player_id = PlayerId,
		scene_id = CurSceneId,
		scene_pid = CurScenePid,
		scene_line_num = OldLineNum
	} = PlayerState,
	case CurSceneId =:= SceneId andalso is_pid(CurScenePid) andalso (OldLineNum =:= LineNum orelse LineNum =:= 0) andalso not util_data:is_null(Point) of
		true ->
			?INFO("TTTSSS444 ~p", [11]),
			%% 如果是同场景，只需要瞬移就可以
			scene_obj_lib:instant_move(CurScenePid, ?OBJ_TYPE_PLAYER, PlayerId, Point, ?DIRECTION_UP),
			{ok, PlayerState#player_state{recover_pet_list = []}};
		_ ->
			?INFO("TTTSSS555 ~p", [11]),
			%% 非同场景需要正常的跑进入流程
			PlayerState1 =
				case need_recover(ChangeType, CurSceneId, SceneId) of %% %% 检查切换场景是否需要恢复血量
					true ->
						AttrTotal = PlayerState#player_state.attr_total,%% 获取玩家的属性信息
						Update = #player_state{
							db_player_attr = #db_player_attr{cur_mp = AttrTotal#attr_base.mp, cur_hp = AttrTotal#attr_base.hp}
						},
						{ok, _PlayerState1} = player_lib:update_player_state(PlayerState, Update),
						_PlayerState1;
					_ ->
						PlayerState
				end,
			%% 异步切换场景
			gen_server2:apply_async(misc:whereis_name({local, ?SERVER}), {?MODULE, do_change_scene, [PlayerState1, PlayerPid, SceneId, ChangeType, Point, LineNum]}),
			{ok, PlayerState1#player_state{recover_pet_list = []}}
	end.

%% 切换线路
change_scene_line(PlayerState, PlayerPid, SceneId, ChangeType, Point, LineNum) ->
	%% 异步切换场景
	gen_server2:apply_async(misc:whereis_name({local, ?SERVER}), {?MODULE, do_change_scene, [PlayerState, PlayerPid, SceneId, ChangeType, Point, LineNum]}),
	{ok, PlayerState#player_state{recover_pet_list = []}}.

%% 切换场景(场景管理进程调用)
do_change_scene(State, PlayerState, PlayerPid, SceneId, ChangeType, Point, LineNum) ->
	case scene_config:get(SceneId) of
		#scene_conf{} = _SceneConf ->
			do_change_scene1(State, PlayerState, PlayerPid, SceneId, ChangeType, Point, null, LineNum);
%% 			PlayerId = PlayerState#player_state.player_id,
%% 			SceneType = SceneConf#scene_conf.type,
%% 			case ets:lookup(?ETS_PLAYER_SCENE, PlayerId) of
%% 				[EtsPlayerScene] ->
%% 					?INFO("do_change_scene1 222  ~p", [11]),
%% 					do_change_scene1(State, PlayerState, PlayerPid, SceneId, ChangeType, Point, EtsPlayerScene, LineNum);
%% 				_ ->
%% 					%% 进入新场景
%% 					?INFO("do_enter_new_scene 11  ~p", [11]),
%% 					do_enter_new_scene(SceneType, State, PlayerState, PlayerPid, SceneId, ChangeType, Point, LineNum)
%% 			end;
		_ ->
			?ERR("enter scene ~p error: not scene config!", [SceneId])
	end.

%% 切换场景
do_change_scene1(State, PlayerState, PlayerPid, SceneId, ChangeType, Point, _EtsPlayerScene, LineNum) ->
	ScenePid = PlayerState#player_state.scene_pid,
	case PlayerState#player_state.scene_id =:= SceneId andalso LineNum =:= 0 of
		true ->
			%% 判断该场景是否还存在
			case ets:lookup(?ETS_SCENE, ScenePid) of
				[_EtsScene] ->
					?INFO("ooo 11 ~p", [11]),
					%%leave_and_enter_new_scene(State, PlayerState, PlayerPid, SceneId, ChangeType, Point, ScenePid, LineNum);
					do_change_scene2(State, PlayerState, PlayerPid, SceneId, ChangeType, Point, ScenePid, PlayerState#player_state.scene_line_num);
				_ ->
					?INFO("ooo 22  ~p", [22]),
					leave_and_enter_new_scene(State, PlayerState, PlayerPid, SceneId, ChangeType, Point, ScenePid, LineNum)
			end;
		_ ->
			?INFO("ooo 33  ~p", [33]),
			leave_and_enter_new_scene(State, PlayerState, PlayerPid, SceneId, ChangeType, Point, ScenePid, LineNum)
	end.

%% 切换场景
do_change_scene2(State, PlayerState, PlayerPid, SceneId, ChangeType, Point, ScenePid, LineNum) ->
	SceneConf = scene_config:get(SceneId),
	#scene_conf{
		type = SceneType,
		activity_id = ActivityId,
		exit_scene = ExitScene
	} = SceneConf,
	case misc:is_process_alive(ScenePid) of
		true ->
			case ChangeType =:= ?CHANGE_SCENE_TYPE_ENTER andalso ActivityId =:= ?SCENE_ACTIVITY_PALACE of
				true ->
					%% 如果进入场景的时候是皇宫场景，则要传送到出口
					case ets:lookup(?ETS_SCENE_MAPS, ExitScene) of
						[EtsMaps] ->
							ExitSceneConf = scene_config:get(ExitScene),
							PidLineList = EtsMaps#ets_scene_maps.pid_list,
							case get_pid_top(PidLineList, PidLineList, LineNum, ExitSceneConf, null) of
								null ->
									{fail, 1};
								Pid ->
									?INFO("ooo 55  ~p", [55]),
									scene_obj_lib_copy:enter(PlayerState, PlayerPid, Pid, ChangeType, null)
							end;
						_ ->
							{fail, 1}
					end;
				_ ->
					%% 重新进入场景
					case ets:lookup(?ETS_SCENE_MAPS, SceneId) of
						[EtsMaps] ->
							PidLineList = EtsMaps#ets_scene_maps.pid_list,
							case get_pid_top(PidLineList, PidLineList, LineNum, SceneConf, null) of
								null ->
									{fail, 1};
								Pid ->
									?INFO("ooo 44 ~p ~p", [length(PidLineList), 44]),
									scene_obj_lib_copy:enter(PlayerState, PlayerPid, Pid, ChangeType, Point)
							end;
						_ ->
							?INFO("ooo 99 ~p", [44]),
							%% 重新进入场景
							scene_obj_lib_copy:enter(PlayerState, PlayerPid, ScenePid, ChangeType, Point)
					end
			end;
		_ ->
			%% 如果场景进程已经崩溃
			%% 先清理掉无效的ets信息
			do_close_scene(State, ScenePid),

			%% 根据不同的场景做不同的操作
			case SceneType of
				?SCENE_TYPE_INSTANCE ->
					%% 如果是副本场景需要跑正常的逻辑
					leave_and_enter_new_scene(State, PlayerState, PlayerPid, SceneId, ChangeType, Point, ScenePid, 0);
				_ ->
					%% 如果是野外或者主城，必须修正（重建主城/野外）再进入场景
					case do_create_scene(State, SceneId, PlayerState) of
						{ok, Pid} ->
							?INFO("ooo 66", [66]),
							scene_obj_lib_copy:enter(PlayerState, PlayerPid, Pid, ChangeType, Point);
						{fail, Err} ->
							{fail, Err}
					end
			end
	end.

%% 离开旧场景且进入新场景
leave_and_enter_new_scene(State, PlayerState, PlayerPid, SceneId, ChangeType, Point, ScenePid, LineNum) ->
	PlayerId = PlayerState#player_state.player_id,
	SceneConf = scene_config:get(SceneId),
	SceneType = SceneConf#scene_conf.type,
	%% 离开旧场景
	do_leave_scene(State, PlayerId, ScenePid, ?LEAVE_SCENE_TYPE_INITIATIVE),
	%% 进入新场景
	do_enter_new_scene(SceneType, State, PlayerState, PlayerPid, SceneId, ChangeType, Point, LineNum).

%% 保存玩家的id 进入场景的进程中 (玩家进程调用)
succeed_change_scene(PlayerId, SceneId, ScenePid) ->
	gen_server2:apply_async(misc:whereis_name({local, ?SERVER}), {?MODULE, do_succeed_change_scene, [PlayerId, SceneId, ScenePid]}).

%% 保存玩家的id 进入场景的进程中 (玩家进程调用)
do_succeed_change_scene(_State, PlayerId, SceneId, ScenePid) ->
	case ets:lookup(?ETS_SCENE, ScenePid) of
		[EtsScene] ->
			NewPlayerList = util_list:store(PlayerId, EtsScene#ets_scene.player_list),
			ets:update_element(?ETS_SCENE, ScenePid, {#ets_scene.player_list, NewPlayerList}),
			ets:insert(?ETS_PLAYER_SCENE, #ets_player_scene{player_id = PlayerId, scene_id = SceneId, pid = ScenePid});
		_ ->
			skip
	end.

%% 离开场景
leave_scene(PlayerState, LeaveType) ->
	%% 跨服退出
	scene_cross:send_log_out(PlayerState),
	gen_server2:apply_sync(misc:whereis_name({local, ?SERVER}), {?MODULE, do_leave_scene, [PlayerState#player_state.player_id, LeaveType]}).

do_leave_scene(State, PlayerId, LeaveType) ->
	case ets:lookup(?ETS_PLAYER_SCENE, PlayerId) of
		[EtsPlayerScene] ->
			do_leave_scene(State, PlayerId, EtsPlayerScene#ets_player_scene.pid, LeaveType),
			case LeaveType of
				?LEAVE_SCENE_TYPE_INITIATIVE ->
					ets:delete(?ETS_PLAYER_SCENE, PlayerId);
				_ ->
					skip
			end;
		_ ->
			skip
	end.
do_leave_scene(_State, PlayerId, ScenePid, LeaveType) ->
	case util_data:check_pid(ScenePid) of
		true ->
			%% 调用这个方法从参加进程移除玩家并通知同屏玩家
			scene_obj_lib:remove_obj(ScenePid, ?OBJ_TYPE_PLAYER, PlayerId, LeaveType);
		_ ->
			skip
	end.


%% 关闭所有场景，用于场景管理进程崩溃或者关服
close_all_scene() ->
	List = ets:tab2list(?ETS_SCENE),
	[gen_server2:apply_async(EtsScene#ets_scene.pid, {scene_mod, stop, []}) || EtsScene <- List].

%% 场景进程调用(场景自动关闭或者出错关闭的时候调用)
close_scene(ScenePid) ->
	gen_server2:apply_sync(misc:whereis_name({local, ?SERVER}), {?MODULE, do_close_scene, [ScenePid]}).

do_close_scene(_State, ScenePid) ->
	case ets:lookup(?ETS_SCENE, ScenePid) of
		[EtsScene] ->
			SceneId = EtsScene#ets_scene.scene_id,
			case ets:lookup(?ETS_SCENE_MAPS, SceneId) of
				[EtsMaps] ->
					NewPidList = lists:keydelete(ScenePid, #pid_line.pid, EtsMaps#ets_scene_maps.pid_list),
					case NewPidList of
						[] ->
							ets:delete(?ETS_SCENE_MAPS, SceneId);
						_ ->
							ets:insert(?ETS_SCENE_MAPS, EtsMaps#ets_scene_maps{pid_list = NewPidList})
					end;
				_ ->
					skip
			end,
			ets:delete(?ETS_SCENE, ScenePid);
		_ ->
			skip
	end.

%% 退出副本(只有玩家进程才能掉用)
exit_instance(PlayerState) ->
	SceneId = PlayerState#player_state.scene_id,
	case scene_config:get(SceneId) of
		#scene_conf{exit_scene = ExitScene} when ExitScene > 0 ->
			%% CHANGE_SCENE_TYPE_LEAVE_INSTANCE 离开副本
			change_scene(PlayerState, self(), ExitScene, ?CHANGE_SCENE_TYPE_LEAVE_INSTANCE);
		_ ->
			skip
	end.

%% 更新boss刷新时间，只有需要记录刷新倒计时的boss才会用到
update_boss_refresh(SceneId, LineNum, BossId, RefreshTime) ->
	EtsBossRefresh = #ets_boss_refresh{
		scene_boss_id = {SceneId, LineNum, BossId},
		refresh_time = RefreshTime
	},
	ets:insert(?ETS_BOSS_REFRESH, EtsBossRefresh).

%% 获取boss刷新时间
get_boss_refresh(SceneId, BossId) ->
	case ets:lookup(?ETS_BOSS_REFRESH, {SceneId, 1, BossId}) of
		[EtsBossRefresh] ->
			EtsBossRefresh;
		_ ->
			null
	end.

%% 根据进入的场景id获取合理的pk模式
get_new_pk_mode(SceneId, _OldPkMode, SetPkMode) ->
	SceneConf = scene_config:get(SceneId),
	PkModeList = SceneConf#scene_conf.pk_mode_list,
	%% 如果自己设定的模式符合场景允许的pk模式则用自己的设定的模式
	case lists:member(SetPkMode, PkModeList) orelse PkModeList =:= [] of
		true ->
			SetPkMode;
		_ ->
			%% 如果自己设定的模式以场景允许的模式不符合则使用场景允许的第一个模式
			[NewPkMode | _T] = PkModeList,
			NewPkMode
	end.

%% ====================================================================
%% Internal functions
%% ====================================================================
%% 根据不同的场景类型来做不同的操作
%% 如果是副本类型场景
do_enter_new_scene(?SCENE_TYPE_INSTANCE, State, PlayerState, PlayerPid, SceneId, ChangeType, Point, LineNum) ->
	case ChangeType of
		?CHANGE_SCENE_TYPE_CHANGE ->% 主动切换场景
			%% 自动切换
			case instance_base_lib:is_multiple_instance(SceneId) of%% 检测是否是多人副本类型
				true ->
					%% 如果是多人副本判断副本是否已经创建，如果是已经创建随机选择一个进入就行
					SceneSign = instance_base_lib:get_instance_sign(PlayerState, SceneId),%% 获取场景副本标记
					case ets:lookup(?ETS_SCENE_MAPS, {SceneId, SceneSign}) of
						[EtsMaps] ->
							SceneConf = scene_config:get(SceneId),
							PidLineList = EtsMaps#ets_scene_maps.pid_list,%%
							case get_pid_top(PidLineList, PidLineList, LineNum, SceneConf, PlayerState) of%% 随机一个场景pid用于进入场景
								null ->
									{fail, 1};
								Pid ->
									scene_obj_lib_copy:enter(PlayerState, PlayerPid, Pid, ChangeType, Point)
							end;
						_ ->
							%% 如果没有创建，先创建场景然后再进入
							case do_create_scene(State, SceneId, PlayerState) of
								{ok, Pid} ->
									scene_obj_lib_copy:enter(PlayerState, PlayerPid, Pid, ChangeType, Point);
								{fail, Err} ->
									{fail, Err}
							end
					end;
				false ->
					%% 其他副本直接直接创建新的场景再进入
					case do_create_scene(State, SceneId, PlayerState) of
						{ok, Pid} ->
							scene_obj_lib_copy:enter(PlayerState, PlayerPid, Pid, ChangeType, Point);
						{fail, Err} ->
							{fail, Err}
					end
			end;
		_ ->
			%% 非自动(这里一般情况不会进来，即使进来，一般场景都是已经创建好的了，否则场景管理进程已经出问题)
			SceneConf = scene_config:get(SceneId),
			%%ExitScene = SceneConf#scene_conf.exit_scene,
			Key = case instance_base_lib:is_multiple_instance(SceneId) of%% 检测是否是多人副本类型
					  true ->
						  SceneSign = instance_base_lib:get_instance_sign(PlayerState, SceneId),%% 获取场景副本标记
						  {SceneId, SceneSign};
					  _ ->
						  SceneId
				  end,
			?WARNING("do_enter_new_scene ~p", [[SceneId, LineNum]]),

			case ets:lookup(?ETS_SCENE_MAPS, Key) of
				[EtsMaps] ->
					%%ExitSceneConf = scene_config:get(ExitScene),
					PidLineList = EtsMaps#ets_scene_maps.pid_list,
					case get_pid_top(PidLineList, PidLineList, LineNum, SceneConf, null) of
						null ->
							{fail, 1};
						Pid ->
							scene_obj_lib_copy:enter(PlayerState, PlayerPid, Pid, ChangeType, null)
					end;
				_ ->
					{fail, 1}
			end
	end;
%% 主城和野外等非副本类的场景都在这里判断
do_enter_new_scene(_Type, _State, PlayerState, PlayerPid, SceneId, ChangeType, Point, LineNum) ->
	%% 正常情况都不需要再创建场景，在服务器开启的时候已经预先创建好(以后如过做分线可以修改这里)
	case ets:lookup(?ETS_SCENE_MAPS, SceneId) of
		[EtsMaps] ->
			SceneConf = scene_config:get(SceneId),
			PidLineList = EtsMaps#ets_scene_maps.pid_list,
			case get_pid_top(PidLineList, PidLineList, LineNum, SceneConf, null) of
				null ->
					{fail, 1};
				Pid ->
					Pid2 = case is_process_alive(Pid) of
							   true ->
								   Pid;
							   _ ->
								   scene_tool:create_scene_pid(SceneId),
								   case scene_mgr_lib:do_create_scene(_State, SceneId) of
									   {ok, Pid1} ->
										   Pid1;
									   _ ->
										   Pid
								   end
						   end,
					scene_obj_lib_copy:enter(PlayerState, PlayerPid, Pid2, ChangeType, Point)
			end;
		_ ->
			{fail, 1}
	end.
%%***********************************************
%%*********************************************获取场景pid
get_pid_top([], PidLineList, _LineNum, SceneConf, PlayerState) ->
	case SceneConf#scene_conf.copy_num =:= 1 of
		true ->
			case util_rand:list_rand(PidLineList) of
				null ->
					null;
				PidLine ->
					?INFO("linenum 33 ~p", [PidLine#pid_line.line_num]),
					PidLine#pid_line.pid
			end;
		_ ->
			Result = case util_data:is_null(PlayerState) of
						 true ->
							 do_create_scene(null, SceneConf#scene_conf.scene_id);
						 _ ->
							 do_create_scene(null, SceneConf#scene_conf.scene_id, PlayerState)
					 end,
			case Result of
				{ok, Pid} ->
					Pid;
				_ ->
					case util_rand:list_rand(PidLineList) of
						null ->
							null;
						PidLine ->
							?INFO("linenum 33 ~p", [PidLine#pid_line.line_num]),
							PidLine#pid_line.pid
					end
			end
	end;
get_pid_top([PidLine | H], PidLineList, LineNum, SceneConf, PlayerState) ->
	%% 如果linenum不为0那么就是寻找跳转的具体线路
	NowPid = case LineNum /= 0 of
				 true ->
					 case lists:keyfind(LineNum, #pid_line.line_num, PidLineList) of
						 false ->
							 0;
						 NowPidLine ->
							 ?INFO("linenum 22 ~p ~p", [NowPidLine#pid_line.line_num, LineNum]),
							 NowPidLine#pid_line.pid
					 end;
				 _ ->
					 0
			 end,
	case NowPid =:= 0 of
		true ->
			%% 随机线路
			case ets:lookup(?ETS_SCENE, PidLine#pid_line.pid) of
				[EtsScene] ->
					case length(EtsScene#ets_scene.player_list) < SceneConf#scene_conf.limit_num of
						true ->
							?INFO("linenum 11 ~p", [PidLine#pid_line.line_num]),
							PidLine#pid_line.pid;
						_ ->
							get_pid_top(H, PidLineList, 0, SceneConf, PlayerState)
					end;
				_ ->
					get_pid_top(H, PidLineList, 0, SceneConf, PlayerState)
			end;
		_ ->
			NowPid
	end.

%% 获取场景里面的玩家人数
get_scene_player_num(ScenePid) ->
	%% 随机线路
	case ets:lookup(?ETS_SCENE, ScenePid) of
		[EtsScene] ->
			length(EtsScene#ets_scene.player_list);
		_ ->
			0
	end.
%% 获取场景里面的玩家人数
get_scene_player_num(SceneId, LineNum) ->
	case ets:lookup(?ETS_SCENE_MAPS, SceneId) of
		[EtsMaps] ->
			PidLineList = EtsMaps#ets_scene_maps.pid_list,
			case lists:keyfind(LineNum, #pid_line.line_num, PidLineList) of
				false ->
					0;
				PidLine ->
					get_scene_player_num(PidLine#pid_line.pid)
			end;
		_ ->
			0
	end.

%% 获取场景pid所在线路
get_line_num(ScenePid, SceneId) ->
	case ets:lookup(?ETS_SCENE_MAPS, SceneId) of
		[EtsMaps] ->
			PidLineList = EtsMaps#ets_scene_maps.pid_list,
			case lists:keyfind(ScenePid, #pid_line.pid, PidLineList) of
				false ->
					{0, PidLineList};
				PidLine ->
					{PidLine#pid_line.line_num, PidLineList}
			end;
		_ ->
			{0, []}
	end.

%% 获取以用的线路信息
get_use_scene_line_scene_id(SceneId) ->
	%% 多人副本创建纪录修改
	case ets:lookup(?ETS_SCENE_MAPS, SceneId) of
		[EtsMaps] ->
			get_use_scene_line(EtsMaps#ets_scene_maps.pid_list);
		_ ->
			1
	end.

%% 获取可以用的线路信息
get_use_scene_line_scene_id(SceneId, PlayerState) ->
	%% 多人副本创建纪录修改
	case instance_base_lib:is_multiple_instance(SceneId) of
		false ->
			case ets:lookup(?ETS_SCENE_MAPS, SceneId) of
				[EtsMaps] ->
					get_use_scene_line(EtsMaps#ets_scene_maps.pid_list);
				_ ->
					1
			end;
		true ->
			SceneSign = instance_base_lib:get_instance_sign(PlayerState, SceneId),
			case ets:lookup(?ETS_SCENE_MAPS, {SceneId, SceneSign}) of
				[EtsMaps] ->
					get_use_scene_line(EtsMaps#ets_scene_maps.pid_list);
				_ ->
					1
			end
	end.

%% 获取可以用的线路信息
get_use_scene_line(PidLineList) ->
	Length = length(PidLineList),
	case Length =:= 0 of
		true ->
			1;
		_ ->
			LineList = [X#pid_line.line_num || X <- PidLineList],
			MaxLine = lists:max(LineList),
			get_use_scene_line1(MaxLine, 1, LineList)
	end.

%% 获取还未使用的线路
get_use_scene_line1(MaxLine, MaxLine, _LineList) ->
	MaxLine + 1;
get_use_scene_line1(NowLine, MaxLine, LineList) ->
	case lists:member(NowLine, LineList) of
		true ->
			get_use_scene_line1(NowLine + 1, MaxLine, LineList);
		_ ->
			NowLine
	end.