%%%-------------------------------------------------------------------
%%% @author zhengsiying
%%% @copyright (C) 2015, <COMPANY>
%%% @doc
%%%		个人副本逻辑
%%% @end
%%% Created : 10. 十二月 2015 下午4:44
%%%-------------------------------------------------------------------
-module(instance_single_lib).

-include("common.hrl").
-include("record.hrl").
-include("config.hrl").
-include("proto.hrl").
-include("log_type_config.hrl").
-include("cache.hrl").
-include("language_config.hrl").

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

%% button_tips callback
%% 只有玩家进程才能调用
-export([
	get_button_tips/1
]).

%% ====================================================================
%% API functions
%% ====================================================================
%% 初始化副本
init(SceneState, _PS) ->
	SceneId = SceneState#scene_state.scene_id,
	SceneConf = scene_config:get(SceneId),
	MonsterList = SceneConf#scene_conf.monster_list,

	%% 根据刷怪配置计算怪物总数和boss总数
	F = fun(Info, Acc) ->
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
				{MonsterCount + Num, BossCount}
		end
	end,
	{MonsterCount, BossCount} = lists:foldl(F, {0, 0}, MonsterList),

	InstanceState = #instance_single_state{
		monster_count = MonsterCount,
		kill_monster_count = 0,
		boss_count = BossCount,
		kill_boss_count = 0,
		logout_time = 0
	},
	SceneState#scene_state{instance_state = InstanceState}.

%% 定时器
on_timer(SceneState) ->
	InstanceState = SceneState#scene_state.instance_state,
	LogoutTime = InstanceState#instance_single_state.logout_time,
	CurTime = util_date:unixtime(),
	case LogoutTime /= 0 andalso LogoutTime + ?PLAYER_LOGOUT_HOLD_TIME < CurTime of
		true ->
			{ok, NewSceneState} = instance_base_lib:instance_close(SceneState),
			NewSceneState;
		_ ->
			SceneState
	end.

%% 玩家进入事件
on_obj_enter(SceneState, PlayerState) when is_record(PlayerState, player_state) ->
	log_instance:log_enter_time(PlayerState#player_state.player_id, SceneState#scene_state.scene_id),
	InstanceState = SceneState#scene_state.instance_state,
	NewInstanceState = InstanceState#instance_single_state{
		logout_time = 0
	},
	SceneState#scene_state{
		instance_state = NewInstanceState
	}.
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
			_ ->
				InstanceState
		end,

	%% 发送副本统计更新给前端
	#instance_single_state{
		monster_count = MC,
		kill_monster_count = KMC,
		boss_count = BC,
		kill_boss_count = KBC
	} = NewInstanceState,
	CurTime = util_date:unixtime(),

	#scene_state{
		scene_id = SceneId,
		end_time = EndTime
	} = SceneState,
	Data = #rep_single_instance_info{
		scene_id = SceneId,
		monster_count = MC,
		kill_monster = KMC,
		boss_count = BC,
		kill_boss = KBC,
		end_time = EndTime - CurTime,
		round = SceneState#scene_state.round
	},
	scene_send_lib:do_send_scene(SceneState, 11015, Data),
	SceneState1 = SceneState#scene_state{instance_state = NewInstanceState},
	InstanceConf = instance_config:get(SceneId),
	%% 检查通关条件
	case check_pass_condition(InstanceConf#instance_conf.pass_condition, SceneState1) of
		true ->
			%% 单人副本轮数判断 20160407
			Sceneconf = scene_config:get(SceneId),
			case scene_obj_lib:create_monster_round(SceneState1, Sceneconf, SceneState1#scene_state.round + 1, EndTime, CurTime) of
				{SceneState2, 1} ->
					SceneState2;
				{SceneState2, _} ->
					case SceneState2#scene_state.round =:= -1 of
						true ->
							skip;
						_ ->
							%% 副本结束逻辑
							Data1 = #rep_single_instance_result{
								scene_id = SceneId,
								instance_result = ?INSTANCE_RESULT_SUCCESS
							},
							case scene_base_lib:do_get_scene_players(SceneState2) of
								[] ->
									skip;
								ObjList ->
									%% 个人副本通关奖励
									GoodsList = InstanceConf#instance_conf.pass_prize,
									%% 发放通关奖励
									[begin
										 ObjPid = ObjState#scene_obj_state.obj_pid,
										 ObjId = ObjState#scene_obj_state.obj_id,
										 %% 添加玩家的副本通关信息 20160407
										 case player_instance_pass_cache:select_row({ObjId, SceneId}) of
											 null ->
												 PlayerInstancePassInfo = #db_player_instance_pass{
													 player_id = ObjId,
													 scene_id = SceneId,
													 pass_time = util_date:unixtime()
												 },
												 player_instance_pass_cache:insert(PlayerInstancePassInfo);
											 _ ->
												 skip
										 end,

										 put("instance_single_completed", 1),

										 gen_server2:cast(ObjPid, {add_goods_list, GoodsList, ?LOG_TYPE_INSTANCE}),
										 task_comply:update_player_tasksort_past_fb(ObjPid, SceneId)
									 end || ObjState <- ObjList]

							end,
							%% 通知前端副本通关
							scene_send_lib:do_send_scene(SceneState2, 11017, Data1),
							SceneState2#scene_state{close_time = CurTime + 60, round = -1}
					end
			end;
		_ ->
			SceneState1
	end.

%% 玩家退出副本事件
on_player_exit(SceneState, ObjState, LeaveType) ->
	Completed =
		case get("instance_single_completed") of
			undefined -> 0;
			_ -> 1
		end,
	log_instance:log_instance_single(ObjState#scene_obj_state.obj_pid, SceneState, Completed),

	case LeaveType of
		?LEAVE_SCENE_TYPE_INITIATIVE ->
			instance_base_lib:instance_close(SceneState);
		_ ->
			InstanceState = SceneState#scene_state.instance_state,
			NewInstanceState = InstanceState#instance_single_state{
				logout_time = util_date:unixtime()
			},
			SceneState#scene_state{
				instance_state = NewInstanceState
			}
	end.

%% 副本结束事件(副本结束不等同于副本关闭)，副本结束后不再计算通关条件，如果通关条件没有达成说明通关失败，如果已经达成说明通关成功
instance_end(SceneState) ->
	SceneState#scene_state{instance_end_state = ?INSTANCE_END_STATE}.

%% 副本关闭事件(一般情况下会将在副本里的玩家/宠物踢出副本，这里基类已经实现了这个功能，派生类只需要写自己的特殊逻辑处理)
instance_close(SceneState) ->
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

%% 获取按钮提示内容，只有玩家进程才能调用
get_button_tips(PlayerState) ->
	case function_lib:is_function_open(PlayerState, ?FUNCTION_ID_INSTANCE_SINGLE) of
		true ->
			List = instance_single_config:get_list(),
			F = fun(Id, Acc) ->
				{PS1, Num} = Acc,
				Conf = instance_single_config:get(Id),
				SceneId = Conf#instance_single_conf.scene_id,
				InstanceConf = instance_config:get(SceneId),
				#instance_conf{
					times_limit = TL,
					cost = Cost
				} = InstanceConf,
				{PS2, EnterTimes} = player_instance_lib:get_instance_enter_times(PS1, SceneId),
				case TL > EnterTimes of
					true ->
						case goods_util:check_special_list(PS2, Cost) of
							true ->
								{PS2, Num + 1};
							_ ->
								{PS2, Num}
						end;
					_ ->
						{PS2, Num}
				end
			end,
			lists:foldl(F, {PlayerState, 0}, List);
		_ ->
			{PlayerState, 0}
	end.

%% 扫荡副本 ， 只有玩家进程才能调用  扫荡功能去掉了
%% raids_instance(PlayerState,SceneId)->
%% 	Base=PlayerState#player_state.db_player_base,
%% 	case player_instance_pass_cache:select_row({PlayerState#player_state.player_id,SceneId}) of
%% 		null->
%% 			?ERR_RAIDS_INSTANCE;
%% 		_->
%% 			SceneConf=scene_config:get(SceneId),
%% 			MonsterList=SceneConf#scene_conf.monster_list,
%% 			F=fun(X,List)->
%% 				{_,_,TempMonsterList}=X,
%% 				List ++ TempMonsterList
%% 			end,
%% 			MonsterList1=lists:foldr(F,MonsterList,SceneConf#scene_conf.rule_monster_list),
%%
%% 			F1=fun(X,List)->
%% 				GoodsList= raids_instance_monster(SceneId,Base#db_player_base.career,X),
%% 				util_data:add_goodslist(List,GoodsList)
%% 			end,
%% 			lists:foldr(F1,[],MonsterList1)
%% 	end.


%% ====================================================================
%% Internal functions
%% ====================================================================
%% 检查通关条件
check_pass_condition({kill_all}, SceneState) ->
	InstanceState = SceneState#scene_state.instance_state,
	#instance_single_state{
		monster_count = MC,
		kill_monster_count = KMC,
		boss_count = BC,
		kill_boss_count = KBC
	} = InstanceState,
	KMC >= MC andalso KBC >= BC.

%% %% 扫荡使用 模拟怪物物品掉落 参考 scene_obj_lib 文件的 create_monster 函数
%% raids_instance_monster(SceneId,Career, {monster_type, MonsterId, Num, _RefreshInterval, _RefreshLocation}) ->
%% 	F = fun(_, List) ->
%% 		GoodsList=obj_monster_lib:rand_drop(MonsterId,Career,SceneId),
%% 		util_data:add_goodslist(List,GoodsList)
%% 	end,
%% 	lists:foldl(F,[], lists:seq(1, Num));
%% %% 扫荡使用 模拟怪物物品掉落 参考 scene_obj_lib 文件的 create_monster 函数
%% raids_instance_monster(SceneId,Career, {area_type, _AreaFlag, MonsterId, Num, _RefreshInterval, _RefreshLocation}) ->
%% 	F = fun(_, List) ->
%% 		GoodsList=obj_monster_lib:rand_drop(MonsterId,Career,SceneId),
%% 		util_data:add_goodslist(List,GoodsList)
%% 	end,
%% 	lists:foldl(F, [], lists:seq(1, Num)).