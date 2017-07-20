%%%-------------------------------------------------------------------
%%% @author zhengsiying
%%% @copyright (C) 2015, <COMPANY>
%%% @doc
%%%		个人副本逻辑
%%% @end
%%% Created : 10. 十二月 2015 下午4:44
%%%-------------------------------------------------------------------
-module(instance_cross_hjzc_lib).

-include("common.hrl").
-include("record.hrl").
-include("config.hrl").
-include("proto.hrl").
-include("log_type_config.hrl").
-include("cache.hrl").
-include("language_config.hrl").

-define(REF_TIME_HJZC, 120). %% 副本刷新时间

%% API
-export([
	init/2,
	on_timer/1,
	on_obj_enter/2,
	on_obj_die/3,
	on_collection/3,
	on_player_exit/3,
	instance_end/1,
	instance_close/1,
	get_instance_info/2,
	add_fangjian_num/2,
	add_fangjian_num/3,
	check_pass_condition/1
]).


%% ====================================================================
%% API functions
%% ====================================================================
%% 初始化副本
init(SceneState, _PS) ->
	SceneId = SceneState#scene_state.scene_id,
	SceneConf = scene_config:get(SceneId),
	%% 根据刷怪配置计算怪物总数和boss总数
	{SceneState1, _} = create_monster_round(SceneState, SceneConf, 1, null, null, null),
	SceneState1.

%% 定时器
on_timer(SceneState) ->
	InstanceState = SceneState#scene_state.instance_state,
	CurTime = util_date:unixtime(),
	#instance_single_state{
		is_pass = IsPass,
		ref_time = RefTime
	} = InstanceState,
	case IsPass =:= true andalso RefTime < CurTime of
		true ->
			InstanceState1 = InstanceState#instance_single_state{
				monster_list = null,
				is_pass = false,
				ref_time = 0
			},
			SceneState1 = SceneState#scene_state{instance_state = InstanceState1},
			SceneConf = scene_config:get(SceneState1#scene_state.scene_id),
			{SceneState2, _} = create_monster_round(SceneState1, SceneConf, 1, null, null, null),
			SceneState2;
		_ ->
			SceneState
	end.


%% 玩家进入事件
on_obj_enter(SceneState, PlayerState) when is_record(PlayerState, player_state) ->
	InstanceState = SceneState#scene_state.instance_state,

	{SceneState3, Result} =
		case InstanceState#instance_single_state.is_pass of
			true ->
%% 				PlayerList = scene_base_lib:do_get_scene_obj_list(SceneState, [?OBJ_TYPE_PLAYER]),
%% 				PlayerList1 = [X || X <- PlayerList, X#scene_obj_state.obj_id /= PlayerState#player_state.player_id],
%% 				case PlayerList1 =:= [] of
%% 					true ->
%% 						InstanceState1 = InstanceState#instance_single_state{
%% 							monster_list = null,
%% 							is_pass = false,
%% 							ref_time = 0
%% 						},
%% 						SceneState1 = SceneState#scene_state{instance_state = InstanceState1},
%% 						SceneConf = scene_config:get(SceneState1#scene_state.scene_id),
%% 						{SceneState2, _} = create_monster_round(SceneState1, SceneConf, 1, null, null),
%% 						{SceneState2, null};
%% 					_ ->
%% 						#player_state{
%% 							player_id = PlayerId,
%% 							db_player_base = #db_player_base{name = Name},
%% 							server_pass_my = ServerPassMy
%% 						} = PlayerState,
%% 						add_fangjian_num(SceneState#scene_state.line_num, [{PlayerId, Name, ServerPassMy}]),
%% 						{SceneState, 1}
%% 				end;
				#player_state{
					player_id = PlayerId,
					db_player_base = #db_player_base{name = Name},
					server_pass_my = ServerPassMy
				} = PlayerState,
				add_fangjian_num(SceneState#scene_state.line_num, [{PlayerId, Name, ServerPassMy}]),
				{SceneState, 1};
			_ ->
				MonsterList = scene_base_lib:do_get_scene_obj_list(SceneState, [?OBJ_TYPE_COLLECT, ?OBJ_TYPE_MONSTER]),
				case MonsterList of
					[] ->
						InstanceState1 = InstanceState#instance_single_state{
							monster_list = null,
							is_pass = false,
							ref_time = 0
						},
						SceneState1 = SceneState#scene_state{instance_state = InstanceState1},
						SceneConf = scene_config:get(SceneState1#scene_state.scene_id),
						{SceneState2, _} = create_monster_round(SceneState1, SceneConf, 1, null, null, null),
						{SceneState2, null};
					_ ->
						{SceneState, 1}
				end
		end,
	%%保留通关状态
	case Result of
		null ->
			skip;
		_ ->
			InstanceState2 = SceneState3#scene_state.instance_state,
			Data2 = case InstanceState2#instance_single_state.is_pass of
						true ->
							#req_hjzc_pass{
								room_pass = 1
							};
						_ ->
							#req_hjzc_pass{
								room_pass = 0
							}
					end,
			%% 	?INFO("11102 ~p", [{Data, SceneState#scene_state.line_num}]),
			%% 发送房间状态
			net_send:send_to_client(PlayerState#player_state.pid, 11102, Data2)
	end,
	SceneState3.
%% 个人副本 对象死亡逻辑
%% 对象死亡事件
on_obj_die(SceneState, DieState, _KillerState) ->
	InstanceState = SceneState#scene_state.instance_state,
	%% 更新击杀数量
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
			?OBJ_TYPE_COLLECT ->
				Num = InstanceState#instance_single_state.kill_monster_count + 1,
				InstanceState#instance_single_state{kill_monster_count = Num};
			_ ->
				InstanceState
		end,
	CurTime = util_date:unixtime(),

	#scene_state{
		scene_id = SceneId,
		end_time = EndTime
	} = SceneState,
	SceneState1 = SceneState#scene_state{instance_state = NewInstanceState},
	%% 检查通关条件
	case check_pass_condition(SceneState1) of
		true ->
			%% 单人副本轮数判断 20160407
			Sceneconf = scene_config:get(SceneId),
			case create_monster_round(SceneState1, Sceneconf, InstanceState#instance_single_state.round + 1, EndTime, CurTime, DieState) of
				{SceneState2, 1} ->
					SceneState2;
				{SceneState2, _} ->

					%% 添加通关记录
					case scene_base_lib:do_get_scene_players(SceneState2) of
						[] ->
							skip;
						ObjList ->
							%% 发放通关奖励
							F = fun(ObjState) ->
								{ObjState#scene_obj_state.obj_id,
									ObjState#scene_obj_state.name,
									ObjState#scene_obj_state.server_pass}
							end,
							PlayerIdNameList = [F(ObjState) || ObjState <- ObjList],
							%% 添加玩家的幻境之城通过房间数据
							add_fangjian_num(SceneState#scene_state.line_num, PlayerIdNameList)
					end,

					%% 发送房间状态
					Data = #req_hjzc_pass{
						room_pass = 1
					},
					%% 设置副本的通关状态
					NewInstanceState1 = NewInstanceState#instance_single_state{
						is_pass = true,
						ref_time = util_date:unixtime() + ?REF_TIME_HJZC
					},

					scene_send_lib:do_send_scene(SceneState2, 11102, Data),
					SceneState2#scene_state{instance_state = NewInstanceState1}
			end;
		_ ->
			SceneState1
	end.

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

%% 获取副本统计信息
get_instance_info(SceneState, Socket) ->
	InstanceState = SceneState#scene_state.instance_state,
	#instance_single_state{
		monster_count = MC,
		kill_monster_count = KMC,
		boss_count = BC,
		kill_boss_count = KBC
	} = InstanceState,
	CurTime = util_date:unixtime(),
	Data = #rep_single_instance_info{
		scene_id = SceneState#scene_state.scene_id,
		monster_count = MC,
		kill_monster = KMC,
		boss_count = BC,
		kill_boss = KBC,
		end_time = SceneState#scene_state.end_time - CurTime,
		round = SceneState#scene_state.round
	},
	net_send:send_to_client(Socket, 11015, Data).

%% ====================================================================
%% Internal functions
%% ====================================================================
%% 检查通关条件
check_pass_condition(SceneState) ->
	InstanceState = SceneState#scene_state.instance_state,
	#instance_single_state{
		monster_count = MC,
		kill_monster_count = KMC,
		boss_count = BC,
		kill_boss_count = KBC
	} = InstanceState,
	KMC >= MC andalso KBC >= BC.

%% 加载下一波怪物
create_monster_round(SceneState, SceneConf, Round, _EndTime, _CurTime, DieState) ->
	Instance_state = SceneState#scene_state.instance_state,
	HjzcInfo = scene_hjzc_lib:get_hjzc_info(),
	Instance_state1 = case util_data:is_null(Instance_state) of
						  true ->
							  get_instance_single_state(SceneState, SceneConf, HjzcInfo);
						  _ ->
							  case util_data:is_null(Instance_state#instance_single_state.monster_list) of
								  true ->
									  get_instance_single_state(SceneState, SceneConf, HjzcInfo);
								  _ ->
									  Instance_state
							  end
					  end,
	?INFO("create_monster_round 111 ~p", [{Round, Instance_state1}]),
	case lists:keyfind(Round, 2, Instance_state1#instance_single_state.monster_list) of
		{_, _, MonsterList} ->
			create_monster_round1(SceneState, MonsterList, Instance_state1, Round);
		_ ->
			CollectList = scene_base_lib:do_get_scene_obj_list(SceneState, ?OBJ_TYPE_COLLECT),
			CollectList1 = [X || X <- CollectList, X#scene_obj_state.obj_type /= DieState#scene_obj_state.obj_type, X#scene_obj_state.obj_id /= DieState#scene_obj_state.obj_id],
			case CollectList1 of
				[] ->
					{SceneState1, Num} = create_box(SceneState, SceneConf, HjzcInfo, Instance_state1),
					?INFO("create_monster_round 222 ~p", [222]),
					InstanceState2 = SceneState1#scene_state.instance_state,
					%% 发送房间状态
					Data = case InstanceState2#instance_single_state.is_pass of
							   true ->
								   #req_hjzc_pass{
									   room_pass = 1
								   };
							   _ ->
								   #req_hjzc_pass{
									   room_pass = 0
								   }
						   end,
					scene_send_lib:do_send_scene(SceneState, 11102, Data),
					{SceneState1, Num};
				_ ->
					{SceneState, 1}
			end
	end.
%% 加载怪物
create_monster_round1(SceneState, MonsterList, Instance_state1, Round) ->
	F = fun(RuleInfo, Acc) ->
		scene_obj_lib:create_area_monster(Acc, RuleInfo)
	end,
	SceneState1 = lists:foldl(F, SceneState, MonsterList),
	?INFO("create_monster_round 222 ~p ~p", [Round, Instance_state1#instance_single_state.monster_list]),
	%% 根据刷怪配置计算怪物总数和boss总数
	F1 = fun(Info, Acc) ->
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
				{MonsterCount + Num, BossCount};
			{collect_type, _, Num, _, _, _} ->
				{MonsterCount + Num, BossCount}
		end
	end,
	{MonsterCount, BossCount} = lists:foldl(F1, {0, 0}, MonsterList),

	SumNum = MonsterCount + BossCount,


	InstanceState2 = Instance_state1#instance_single_state{
		monster_count = MonsterCount,
		kill_monster_count = 0,
		boss_count = BossCount,
		kill_boss_count = 0,
		logout_time = 0,
		round = Round
	},

	%% 如果怪物数量为0 那么默认设置为通关状态
	InstanceState3 =
		case SumNum =:= 0 of
			true ->
				InstanceState2#instance_single_state{
					is_pass = true,
					ref_time = util_date:unixtime() + ?REF_TIME_HJZC,
					monster_list = null
				};
			_ ->
				InstanceState2
		end,
	SceneState2 = SceneState1#scene_state{
		instance_state = InstanceState3
	},
	%% 发送房间状态
	Data = case InstanceState3#instance_single_state.is_pass of
			   true ->
				   #req_hjzc_pass{
					   room_pass = 1
				   };
			   _ ->
				   #req_hjzc_pass{
					   room_pass = 0
				   }
		   end,
	scene_send_lib:do_send_scene(SceneState, 11102, Data),
	?INFO("create_monster_round 3333 ~p", [InstanceState3]),
	{SceneState2, 1}.

%% 加载宝箱
create_box(SceneState, SceneConf, HjzcInfo, Instance_state1) ->
	RuleMonsterList = SceneConf#scene_conf.rule_monster_list,
	RoomNum = SceneState#scene_state.line_num,
	case lists:member(RoomNum, HjzcInfo#ets_hjzc.box_from_list) of
		true ->
			%% 随机宝箱信息
			HjzcInfo1 = HjzcInfo#ets_hjzc{
				box_from_list = lists:delete(RoomNum, HjzcInfo#ets_hjzc.box_from_list)
			},
			scene_hjzc_lib:save_hjzc(HjzcInfo1),
			?INFO("~p", [RoomNum]),
			RuleMonsterList1 = lists:sublist(RuleMonsterList, 3),
			RuleMonsterList2 = util_rand:weight_rand_one(RuleMonsterList1),
			%% 添加宝箱信息
			F = fun({_, _, MonsterList}, Acc) ->
				{Acc1, _} = create_monster_round1(Acc, MonsterList, Instance_state1, 0),
				Acc1
			end,
			SceneState1 = lists:foldl(F, SceneState, RuleMonsterList2),
			%% 返回副本状态信息
			{SceneState1#scene_state{instance_state = Instance_state1}, 1};
		_ ->
			%% 保存状态信息
			InstanceState1 = Instance_state1#instance_single_state{
				is_pass = true,
				ref_time = util_date:unixtime() + ?REF_TIME_HJZC
			},
			{SceneState#scene_state{instance_state = InstanceState1}, 0}
	end.
%% 获取副本新的状态信息
get_instance_single_state(_SceneState, SceneConf, _HjzcInfo) ->
	RuleMonsterList = SceneConf#scene_conf.rule_monster_list,
%% 	RoomNum = SceneState#scene_state.line_num,

%% 	RuleMonsterList1 =
%% 		case lists:member(RoomNum, HjzcInfo#ets_hjzc.box_from_list) of
%% 			true ->
%% 				%% 随机宝箱信息
%% 				HjzcInfo1 = HjzcInfo#ets_hjzc{
%% 					box_from_list = lists:delete(RoomNum, HjzcInfo#ets_hjzc.box_from_list)
%% 				},
%% 				scene_hjzc_lib:save_hjzc(HjzcInfo1),
%% 				?ERR("~p", [RoomNum]),
%% 				lists:sublist(RuleMonsterList, 3);
%% 			_ ->
%% 				lists:sublist(RuleMonsterList, 4, 99)
%% 		end,
	RuleMonsterList1 = lists:sublist(RuleMonsterList, 4, 99),
	RuleMonsterList2 = util_rand:weight_rand_one(RuleMonsterList1),

%% 	{_, RuleMonsterList2} = lists:last(RuleMonsterList),
	#instance_single_state{
		monster_count = 0,
		kill_monster_count = 0,
		boss_count = 0,
		kill_boss_count = 0,
		logout_time = 0,
		is_pass = false,
		round = 1,
		ref_time = 0,
		monster_list = RuleMonsterList2
	}.

%% 添加玩家的房间数量信息
add_fangjian_num(RoomNum, PlayerIdNameList) ->
	gen_server2:apply_async(misc:whereis_name({local, cache_log_mod}), {?MODULE, add_fangjian_num, [RoomNum, PlayerIdNameList]}).
add_fangjian_num(State, RoomNum, PlayerIdNameList) ->
	HjzcInfo = scene_hjzc_lib:get_hjzc_info(),
	CurTime = util_date:unixtime(),
	%% 添加玩家的通过房间记录
	F = fun(PlayerIdName, Acc) ->
		%% 获取玩家id 和名字
		{PlayerId, Name, ServerPass} = PlayerIdName,
		case dict:find(PlayerId, Acc) of
			{ok, HjzcPlayer} ->
				#hjzc_player{
					room_list = RoomList
				} = HjzcPlayer,
				case lists:member(RoomNum, RoomList) of
					true ->
						Acc;
					_ ->
						RoomList1 = [RoomNum | RoomList],
						HjzcPlayer1 = HjzcPlayer#hjzc_player{
							room_list = RoomList1,
							time = CurTime
						},
						dict:store(PlayerId, HjzcPlayer1, Acc)
				end;
			_ ->
				HjzcPlayer = #hjzc_player{
					player_id = PlayerId,
					room_list = [RoomNum],
					name = Name,
					time = CurTime,
					server_pass = ServerPass
				},
				dict:store(PlayerId, HjzcPlayer, Acc)
		end
	end,
	PlayerDict1 = lists:foldl(F, HjzcInfo#ets_hjzc.player_pass_dict, PlayerIdNameList),
	%% 记录玩家的房间数量
	HjzcInfo1 = HjzcInfo#ets_hjzc{
		player_pass_dict = PlayerDict1
	},


	scene_hjzc_lib:save_hjzc(HjzcInfo1),
	{ok, State}.




