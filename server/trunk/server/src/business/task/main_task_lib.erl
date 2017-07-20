%%%-------------------------------------------------------------------
%%% @author yubing
%%% @copyright (C) 2016, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 05. 一月 2016 14:16
%%%-------------------------------------------------------------------
-module(main_task_lib).

-export([init_main_task/1,
	get_task_navigate_list/1,
	npc_task_id/2,
	ref_task_navigate_list/2,
	accept_task/2,
	finish_task/2,
	fast_finish_task/2,
	ref_task_navigate_list/1,
	get_ref_task_navigate_list/1,
	get_task_complete_jade/2,
	ref_task_clear/3
]).

-include("cache.hrl").
-include("config.hrl").
-include("proto.hrl").
-include("record.hrl").
-include("common.hrl").
-include("language_config.hrl").
-include("gameconfig_config.hrl").
-include("button_tips_config.hrl").
-include("log_type_config.hrl").
%% 初始化玩家的主线任务
init_main_task(PlayerState) ->
	MainList = task_lib:get_task_conf_list(?TASKTYPEID1, PlayerState#player_state.db_player_base),
	F = fun(X) ->
		TaskInfo = task_comply:update_accpet__player_task(PlayerState, X#task_conf.id),
		player_task_cache:insert(TaskInfo),
		TaskInfo
	end,
	[F(X) || X <- MainList].

%% 获取任务导航信息
get_task_navigate_list(PlayerState) ->
	List = task_lib:get_player_task_list_not_type_id(?TASKTYPEID2),
	F = fun(X) ->
		#proto_navigate_task_info{
			task_id = X#db_player_task.taskid_id,
			now_num = X#db_player_task.nownum,
			state = X#db_player_task.isfinish
		}
	end,
	List1 = [F(X) || X <- List],
	{PlayerStateNew, List2} = get_ref_task_navigate_list(PlayerState),
	{PlayerStateNew, lists:concat([List1, List2])}.

%% 接受任务
accept_task(PlayerState, TaskId) ->
	%% 是否可以接取
	{PlayerState1, ERR} = is_accept_task(PlayerState, TaskId),
	if
		ERR > 0 ->
			{ok, PlayerState1, ERR};
		true ->
			TaskInfo = task_comply:update_accpet__player_task(PlayerState, TaskId),
			player_task_cache:insert(TaskInfo),
			player_task_dict:inster_task_list(TaskInfo),
			ref_task_navigate_list_accept(PlayerState, TaskInfo),
			{ok, PlayerState1, ?ERR_COMMON_SUCCESS}
	end.
%% 完成任务验证
is_finish_task(PlayerState, TaskConf) ->
	Base = PlayerState#player_state.db_player_base,
	case TaskConf#task_conf.type_id =:= ?TASKTYPEID_GUILD of
		true ->
			case Base#db_player_base.guild_id < 1 of
				true ->
					?ERR_MAIN_TASK8;
				_ ->
					0
			end;
		_ ->
			0
	end.

%% 完成任务
finish_task(PlayerState, TaskId) ->
	Base = PlayerState#player_state.db_player_base,
	case player_task_dict:get_value_from_list_by_taskid(TaskId) of
		false ->
			{ok, PlayerState, ?ERR_MAIN_TASK1};
		TaskInfo ->
			finish_task1(PlayerState, Base, TaskInfo, TaskId)
	end.
%% 完成任务 1
finish_task1(PlayerState, Base, TaskInfo, TaskId) ->
	if
		TaskInfo#db_player_task.isfinish =:= 0 ->
			{ok, PlayerState, ?ERR_MAIN_TASK1};
		true ->
			TaskConf = task_config:get(TaskInfo#db_player_task.taskid_id),
			Err = is_finish_task(PlayerState, TaskConf),
			case Err > 0 of
				true ->
					{ok, PlayerState, Err};
				_ ->
					finish_task2(PlayerState, Base, TaskInfo, TaskId, TaskConf)
			end
	end.
%% 完成任务 2
finish_task2(PlayerState, Base, TaskInfo, TaskId, TaskConf) ->
	Goodslist = get_task_goods(Base#db_player_base.career, TaskId),
	case goods_lib_log:add_goods_list(PlayerState, Goodslist, {?LOG_TYPE_TASK, [TaskId]}) of
		{ok, PlayerState1} ->
			%% 处理任务相关信息
			player_task_dict:delete_task_to_dict(TaskInfo#db_player_task.taskid_id),
			player_task_cache:delete(PlayerState1#player_state.player_id, TaskInfo#db_player_task.taskid_id),
			%% 如果时功勋任务的话 ，清空功勋任务信息
			PlayerStateNew =
				case TaskConf#task_conf.type_id of
					?TASKTYPEID_MERIT ->
						log_lib:log_daily(PlayerState1, ?LOG_TYPE_TASK_MERIT, 0, ?STATUS_TASK_END),
						operate_active_lib:update_limit_type(PlayerState1, ?OPERATE_ACTIVE_LIMIT_TYPE_9),
						%% 清空 功勋任务
						PlayerState1#player_state{
							merit_task_id = 0
						};
					?TASKTYPEID_DAY ->
						log_lib:log_daily(PlayerState1, ?LOG_TYPE_TASK_DAY, 0, ?STATUS_TASK_END),
						operate_active_lib:update_limit_type(PlayerState1, ?OPERATE_ACTIVE_LIMIT_TYPE_6),
						%% 清空 日常任务
						PlayerState1#player_state{
							day_task_id = 0
						};
					?TASKTYPEID_WEEK ->
						log_lib:log_daily(PlayerState1, ?LOG_TYPE_TASK_WEEK, 0, ?STATUS_TASK_END),
						%% 清空 周任务
						PlayerState1#player_state{
							week_task_id = 0
						};
					?TASKTYPEID_MAP ->
						log_lib:log_daily(PlayerState1, ?LOG_TYPE_TASK_MAP, 0, ?STATUS_TASK_END),
						%% 清空 周任务
						PlayerState1#player_state{
							map_task_id = 0
						};
					?TASKTYPEID_GUILD ->
						log_lib:log_daily(PlayerState1, ?LOG_TYPE_TASK_GUILD, 0, ?STATUS_TASK_END),
						%% 获取工会任务
						GuildTaskList = task_lib:get_task_conf_list(?TASKTYPEID_GUILD, {Base, TaskConf#task_conf.id}),
						%% 工会任务完成 获取下一个任务
						UpdateState = case lists:keyfind(TaskConf#task_conf.id, #task_conf.front_task_id, GuildTaskList) of
										  false ->
											  #player_state{
												  db_player_base = Base#db_player_base{
													  guild_task_id = 0
												  }
											  };
										  GuildTaskInfo ->
											  #player_state{
												  db_player_base = Base#db_player_base{
													  guild_task_id = GuildTaskInfo#task_conf.id
												  }
											  }
									  end,
						{ok, PlayerState2} = player_lib:update_player_state(PlayerState1, UpdateState),
						PlayerState2;
					_ ->
						TaskFinishInfo = #db_player_task_finish{
							taskid_id = TaskId,
							player_id = PlayerState1#player_state.player_id
						},
						%% 添加完成数据
						player_task_finish_cache:insert(TaskFinishInfo),
						player_task_finish_dict:inster_task_list(TaskFinishInfo),
						%% 主线任务完成 查看功能开启状态 依据主线任务限定
						function_lib:ref_function_open_list(PlayerState1)
				end,
			%% 更新刷新信息
			RefTaskIdListNew = lists:delete(TaskId, PlayerStateNew#player_state.ref_task_list),
			%% 刷新导航信息
			PlayerStateNew1 = ref_task_navigate_list_finish(PlayerStateNew#player_state{ref_task_list = RefTaskIdListNew}, TaskId),

			%% 完成任务触发
			task_comply:update_player_task_info_tool(PlayerStateNew1, ?TASKSORT_TASKTYPE_COMPLETE, TaskConf#task_conf.type_id, 1),

			%% 此行必须最后一行 需要返回 状态信息
			{ok, PlayerStateNew1, ?ERR_COMMON_SUCCESS};
		{fail, Err} ->
			{ok, PlayerState, Err};
		_ ->
			{ok, PlayerState, ?ERR_MAIN_TASK1}
	end.

%% 快速完成任务
fast_finish_task(PlayerState, TaskId) ->
	TaskConf = task_config:get(TaskId),
	case TaskConf of
		#task_conf{} ->
			Money = PlayerState#player_state.db_player_money,
			Base = PlayerState#player_state.db_player_base,
			case TaskConf#task_conf.type_id =:= ?TASKTYPEID1 orelse TaskConf#task_conf.type_id =:= ?TASKTYPEID2 of
				true ->
					{fail, ?ERR_PLAYER_JADE_NOT_ENOUGH};
				_ ->
					NeedJade = get_task_complete_jade(PlayerState#player_state.player_id, TaskConf#task_conf.type_id),
					%% 判断钱是否足够
					case Money#db_player_money.jade < NeedJade of
						true ->
							{fail, ?ERR_PLAYER_JADE_NOT_ENOUGH};
						_ ->
							%% 是否有这个任务
							case player_task_dict:get_value_from_list_by_taskid(TaskId) of
								false ->
									Goodslist = get_task_goods(Base#db_player_base.career, TaskId),
									%% 额外奖励 添加
									Goodslist1 = Goodslist ++ get_goods_extra(TaskConf),
									case goods_lib_log:add_goods_list(PlayerState, Goodslist1, {?LOG_TYPE_TASK, [TaskId]}) of
										{ok, PlayerState1} ->
											%% 快速完成任务 代码2
											PlayerState2 = fast_finish_task1(PlayerState1, TaskConf, NeedJade, Goodslist1, true),
											%% 刷新导航信息
											PlayerStateNew = ref_task_navigate_list_finish(PlayerState2, TaskId),
											%% 此行必须最后一行 需要返回 状态信息
											{ok, PlayerStateNew};
										Err ->
											Err
									end;
								TaskInfo ->
									Goodslist = get_task_goods(Base#db_player_base.career, TaskId),
									%% 额外奖励 添加
									Goodslist1 = Goodslist ++ get_goods_extra(TaskConf),
									case goods_lib_log:add_goods_list(PlayerState, Goodslist1, {?LOG_TYPE_TASK, [TaskId]}) of
										{ok, PlayerState1} ->
											%% 快速完成任务 代码2
											PlayerState2 = fast_finish_task1(PlayerState1, TaskConf, NeedJade, Goodslist, false),

											%% 处理任务相关信息
											player_task_dict:delete_task_to_dict(TaskInfo#db_player_task.taskid_id),
											player_task_cache:delete(PlayerState2#player_state.player_id, TaskInfo#db_player_task.taskid_id),

											%% 刷新导航信息
											PlayerStateNew = ref_task_navigate_list_finish(PlayerState2, TaskId),

											%% 此行必须最后一行 需要返回 状态信息
											{ok, PlayerStateNew};
										Err ->
											Err
									end

							end
					end
			end;
		_ ->
			{fail, ?ERR_MAIN_TASK1}
	end.


%% 快速完成任务2 任务分类处理 IsCount 是否计数
fast_finish_task1(PlayerState, TaskConf, NeedJade, _GoodsList, IsCount) ->
	%% 更新刷新信息
	RefTaskIdListNew = lists:delete(TaskConf#task_conf.id, PlayerState#player_state.ref_task_list),
	case TaskConf#task_conf.type_id of
		?TASKTYPEID_MERIT ->
			case IsCount of
				true ->
					%% 功勋任务次数加一
					counter_lib:update_limit(PlayerState#player_state.player_id, ?COUNTER_MERIT_TASK_NUM);
				_ ->
					skip
			end,
			%% 刷新功勋任务领取红点
			button_tips_lib:ref_button_tips(PlayerState, ?BTN_TASK_MERIT),
			%% 使用元宝次数加一
			counter_lib:update_limit(PlayerState#player_state.player_id, ?COUNTER_MERIT_TASK_JADE),
			%% 扣除元宝
			{ok, PlayerState2} = player_lib:incval_on_player_money_log(PlayerState, #db_player_money.jade, -NeedJade, ?LOG_TYPE_TASK_MERIT),
			%% 完成任务触发
			task_comply:update_player_task_info_tool(PlayerState, ?TASKSORT_TASKTYPE_COMPLETE, TaskConf#task_conf.type_id, 1),

			log_lib:log_daily(PlayerState, ?LOG_TYPE_TASK_MERIT, -NeedJade, ?STATUS_COMPLETE),
			operate_active_lib:update_limit_type(PlayerState, ?OPERATE_ACTIVE_LIMIT_TYPE_9),
			%% 更新任务状态
			PlayerState2#player_state{
				merit_task_id = 0,
				ref_task_list = RefTaskIdListNew
			};
		?TASKTYPEID_DAY ->
			case IsCount of
				true ->
					%% 日常任务次数加一
					counter_lib:update_limit(PlayerState#player_state.player_id, ?COUNTER_DAY_TASK_NUM);
				_ ->
					skip
			end,

			%% 使用元宝次数加一
			counter_lib:update_limit(PlayerState#player_state.player_id, ?COUNTER_DAY_TASK_JADE),
			%% 扣除元宝
			{ok, PlayerState2} = player_lib:incval_on_player_money_log(PlayerState, #db_player_money.jade, -NeedJade, ?LOG_TYPE_TASK_DAY),

			%% 完成任务触发
			task_comply:update_player_task_info_tool(PlayerState, ?TASKSORT_TASKTYPE_COMPLETE, TaskConf#task_conf.type_id, 1),

			log_lib:log_daily(PlayerState, ?LOG_TYPE_TASK_DAY, -NeedJade, ?STATUS_COMPLETE),
			operate_active_lib:update_limit_type(PlayerState, ?OPERATE_ACTIVE_LIMIT_TYPE_6),
			%% 更新任务状态
			PlayerState2#player_state{
				day_task_id = 0,
				ref_task_list = RefTaskIdListNew
			};
		?TASKTYPEID_MAP ->
			case IsCount of
				true ->
					%% 宝图任务次数加一
					counter_lib:update_limit(PlayerState#player_state.player_id, ?COUNTER_MAP_TASK_NUM);
				_ ->
					skip
			end,

			%% 使用元宝次数加一
			counter_lib:update_limit(PlayerState#player_state.player_id, ?COUNTER_MAP_TASK_JADE),
			%% 扣除元宝
			{ok, PlayerState2} = player_lib:incval_on_player_money_log(PlayerState, #db_player_money.jade, -NeedJade, ?LOG_TYPE_TASK_MAP),

			%% 完成任务触发
			task_comply:update_player_task_info_tool(PlayerState, ?TASKSORT_TASKTYPE_COMPLETE, TaskConf#task_conf.type_id, 1),

			log_lib:log_daily(PlayerState, ?LOG_TYPE_TASK_MAP, -NeedJade, ?STATUS_COMPLETE),
			operate_active_lib:update_limit_type(PlayerState, ?OPERATE_ACTIVE_LIMIT_TYPE_17),
			%% 更新任务状态
			PlayerState2#player_state{
				map_task_id = 0,
				ref_task_list = RefTaskIdListNew
			};
		_ ->
			PlayerState
	end.

%% 刷新数据信息
ref_task_navigate_list_accept(PlayerState, TaskInfo) ->
	TaskNavigateInfo = #proto_navigate_task_info{
		task_id = TaskInfo#db_player_task.taskid_id,
		now_num = TaskInfo#db_player_task.nownum,
		state = TaskInfo#db_player_task.isfinish
	},
	TaskNavigateList = [TaskNavigateInfo],
	?INFO("tasknew444 ~p", [TaskNavigateList]),
	net_send:send_to_client(PlayerState#player_state.socket, 26003, #rep_navigate_ref_task_list{navigate_task_list = TaskNavigateList}).
%% 刷新数据信息
ref_task_navigate_list_finish(PlayerState, TaskId) ->
	TaskNavigateInfo = #proto_navigate_task_info{
		task_id = TaskId,
		state = 3
	},
	{PlayerStateNew, AccpetList} = get_ref_task_navigate_list(PlayerState),
	TaskNavigateList = [TaskNavigateInfo | AccpetList],
	?INFO("tasknew1111 ~p", [TaskNavigateList]),
	net_send:send_to_client(PlayerState#player_state.socket, 26003, #rep_navigate_ref_task_list{navigate_task_list = TaskNavigateList}),
	PlayerStateNew.

%% 刷新数据信息 并删除任务
ref_task_clear(PlayerState, PlayerTaskList, TaskId) ->
	F = fun(X) ->
		%% 处理任务相关信息
		player_task_dict:delete_task_to_dict(X#db_player_task.taskid_id),
		player_task_cache:delete(PlayerState#player_state.player_id, X#db_player_task.taskid_id),
		#proto_navigate_task_info{
			task_id = X#db_player_task.taskid_id,
			state = 3
		}
	end,
	TaskNavigateList = [F(X) || X <- PlayerTaskList],

	TaskNavigateList1 = case TaskId > 0 of
							true ->
								Temp = #proto_navigate_task_info{
									task_id = TaskId,
									state = 3
								},
								[Temp | TaskNavigateList];
							_ ->
								TaskNavigateList
						end,

	?INFO("cleartask ~p", [TaskNavigateList1]),
	case length(TaskNavigateList1) > 0 of
		true ->
			net_send:send_to_client(PlayerState#player_state.socket, 26003, #rep_navigate_ref_task_list{navigate_task_list = TaskNavigateList1});
		_ ->
			skip
	end.

%% 刷新数据信息
ref_task_navigate_list(PlayerState) ->
	{PlayerStateNew, TaskNavigateList} = get_ref_task_navigate_list(PlayerState),
	?INFO("tasknew222 ~p", [TaskNavigateList]),
	net_send:send_to_client(PlayerState#player_state.socket, 26003, #rep_navigate_ref_task_list{navigate_task_list = TaskNavigateList}),
	PlayerStateNew.

%% 刷新数据信息
ref_task_navigate_list(PlayerState, TaskInfoList) ->
	case length(TaskInfoList) > 0 of
		true ->
			F = fun(X) ->
				#proto_navigate_task_info{
					task_id = X#db_player_task.taskid_id,
					now_num = X#db_player_task.nownum,
					state = X#db_player_task.isfinish
				}
			end,
			TaskNavigateList = [F(X) || X <- TaskInfoList],
			?INFO("tasknew333 ~p", [TaskNavigateList]),
			net_send:send_to_client(PlayerState#player_state.socket, 26003, #rep_navigate_ref_task_list{navigate_task_list = TaskNavigateList});
		_ ->
			skip
	end.

%% ******************************逻辑处理方法
%% 获取刷新的数据信息
get_ref_task_navigate_list(PlayerState) ->
	{PlayerStateNew, AcceptList} = get_accept_task_list(PlayerState),
	#player_state{
		ref_task_list = RefTaskList
	} = PlayerStateNew,
	F = fun(X, {List, TempRefTaskList}) ->
		#task_conf{
			id = TaskId
		} = X,
		case lists:member(TaskId, TempRefTaskList) of
			true ->
				{List, TempRefTaskList};
			_ ->
				Temp = #proto_navigate_task_info{
					task_id = X#task_conf.id,
					now_num = 0,
					state = 2
				},
				TempRefTaskList1 = [TaskId | TempRefTaskList],
				NewList = [Temp | List],
				{NewList, TempRefTaskList1}
		end
	end,
	{NewTaskList, RefTaskListNew} = lists:foldr(F, {[], RefTaskList}, AcceptList),
	?INFO("NEWTASKLIST ~p", [NewTaskList]),
	PlayerStateNew1 = PlayerStateNew#player_state{
		ref_task_list = RefTaskListNew
	},
	{PlayerStateNew1, NewTaskList}.

%% 获取玩家可以接取的任务信息
get_accept_task_list(PlayerState) ->
	Base = PlayerState#player_state.db_player_base,
	TaskConfList1 = task_lib:get_task_conf_list(?TASKTYPEID1, Base),
	TaskConfList2 = task_lib:get_task_conf_list(?TASKTYPEID_OTHER, Base),
	MainTaskList = TaskConfList1 ++ TaskConfList2,
	%% 获取功勋任务纪录信息
	{PlayerState1, MainTaskList1} = get_accept_task_list_Merit(MainTaskList, PlayerState, Base),
	%% 获取日常任务纪录信息
	{PlayerState2, MainTaskList2} = get_accept_task_list_day(PlayerState1, MainTaskList1, Base),
	%% 获取周任务记录信息
	{PlayerState3, MainTaskList3} = get_accept_task_list_week(PlayerState2, MainTaskList2, Base),
	%% 宝图任务
	{PlayerState4, MainTaskList4} = get_accept_task_list_map(PlayerState3, MainTaskList3, Base),
	%% 获取帮派任务
	get_accept_task_list_guild(PlayerState4, MainTaskList4).

%% 获取功勋任务可以接取信息
get_accept_task_list_Merit(MainTaskList, PlayerState, Base) ->
	case PlayerState#player_state.merit_task_id of
		0 ->
			?INFO("get_accept_task_list_merit check ~p", [counter_lib:check(PlayerState#player_state.player_id, ?COUNTER_MERIT_TASK_NUM)]),
			IsCanAccept = counter_lib:check(PlayerState#player_state.player_id, ?COUNTER_MERIT_TASK_NUM),
			AlreadyAccept = player_task_dict:num_exist_type(?TASKTYPEID_MERIT),
			case IsCanAccept andalso (not AlreadyAccept) of
				true ->
					MeritTaskList = task_lib:get_task_conf_list(?TASKTYPEID_MERIT, Base),
					case util_rand:list_rand(MeritTaskList) of
						null ->
							{PlayerState, MainTaskList};
						MeritTaskInfo ->
							%% 存储玩家的功勋任务信息
							PlayerState1 = PlayerState#player_state{
								merit_task_id = MeritTaskInfo#task_conf.id
							},
							{PlayerState1, [MeritTaskInfo | MainTaskList]}
					end;
				_ ->
					{PlayerState, MainTaskList}
			end;
		MeritTaskId ->
			MeritTaskInfo = task_config:get(MeritTaskId),
			{PlayerState, [MeritTaskInfo | MainTaskList]}
	end.
%% %% 获取日常任务信息
get_accept_task_list_day(PlayerState, MainTaskList, Base) ->
	#player_state{day_task_id = DayTaskId, player_id = PlayerId} = PlayerState,
	case DayTaskId of
		0 ->
			IsCanAccept = counter_lib:check(PlayerId, ?COUNTER_DAY_TASK_NUM),
			AlreadyAccept = player_task_dict:num_exist_type(?TASKTYPEID_DAY),
			?INFO("day_task33 islimit:~p  tasktypenum:~p", [IsCanAccept, AlreadyAccept]),
			case IsCanAccept andalso (not AlreadyAccept) of
				true ->
					DayTaskList = task_lib:get_task_conf_list(?TASKTYPEID_DAY, Base),
					case util_rand:list_rand(DayTaskList) of
						null ->
							?INFO("day_task22 ~p", [length(DayTaskList)]),
							{PlayerState, MainTaskList};
						DayTaskInfo ->
							?INFO("day_task11 ~p", [DayTaskInfo#task_conf.id]),
							%% 存储玩家的功勋任务信息
							PlayerState1 = PlayerState#player_state{
								day_task_id = DayTaskInfo#task_conf.id
							},
							{PlayerState1, [DayTaskInfo | MainTaskList]}
					end;
				_ ->
					{PlayerState, MainTaskList}
			end;
		_ ->
			?INFO("-=-=-=-=-=- ~p", [DayTaskId]),
			DayTaskInfo = task_config:get(DayTaskId),
			{PlayerState, [DayTaskInfo | MainTaskList]}
	end.
%% 获取周任务接取信息
get_accept_task_list_week(PlayerState, MainTaskList, Base) ->
	case PlayerState#player_state.week_task_id of
		0 ->
			IsCanAccept = counter_lib:check(PlayerState#player_state.player_id, ?COUNTER_WEEK_TASK_NUM),
			AlreadyAccept = player_task_dict:num_exist_type(?TASKTYPEID_WEEK),
			case IsCanAccept andalso (not AlreadyAccept) of
				true ->
					WeekTaskList = task_lib:get_task_conf_list(?TASKTYPEID_WEEK, Base),
					case util_rand:list_rand(WeekTaskList) of
						null ->
							{PlayerState, MainTaskList};
						WeekTaskInfo ->
							%% 存储玩家的功勋任务信息
							PlayerState1 = PlayerState#player_state{
								week_task_id = WeekTaskInfo#task_conf.id
							},
							{PlayerState1, [WeekTaskInfo | MainTaskList]}
					end;
				_ ->
					{PlayerState, MainTaskList}
			end;
		WeekTaskId ->
			WeekTaskInfo = task_config:get(WeekTaskId),
			{PlayerState, [WeekTaskInfo | MainTaskList]}
	end.

%% 获取宝图任务接取信息
get_accept_task_list_map(PlayerState, MainTaskList, Base) ->
	case PlayerState#player_state.map_task_id of
		0 ->
			IsCanAccept = counter_lib:check(PlayerState#player_state.player_id, ?COUNTER_MAP_TASK_NUM),
			AlreadyAccept = player_task_dict:num_exist_type(?TASKTYPEID_MAP),
			case IsCanAccept andalso (not AlreadyAccept) of
				true ->
					MapTaskList = task_lib:get_task_conf_list(?TASKTYPEID_MAP, Base),
					case util_rand:list_rand(MapTaskList) of
						null ->
							{PlayerState, MainTaskList};
						MapTaskInfo ->
							%% 存储玩家的功勋任务信息
							PlayerState1 = PlayerState#player_state{
								map_task_id = MapTaskInfo#task_conf.id
							},
							{PlayerState1, [MapTaskInfo | MainTaskList]}
					end;
				_ ->
					{PlayerState, MainTaskList}
			end;
		MapTaskId ->
			MapTaskInfo = task_config:get(MapTaskId),
			{PlayerState, [MapTaskInfo | MainTaskList]}
	end.

%% 获取帮派任务
get_accept_task_list_guild(PlayerState, MainTaskList) ->
	Base = PlayerState#player_state.db_player_base,
	AlreadyAccept = player_task_dict:num_exist_type(?TASKTYPEID_GUILD),
	case Base#db_player_base.guild_task_id > 0 andalso (not AlreadyAccept) of
		true ->
			TaskInfo = task_config:get(Base#db_player_base.guild_task_id),
			{PlayerState, [TaskInfo | MainTaskList]};
		_ ->
			{PlayerState, MainTaskList}
	end.


%% 判断npc的状态信息
npc_task_id(PlayerState, NpcId) ->
	{PlayerStateNew, AcceptList} = get_accept_task_list(PlayerState),
	case npc_task_id2(AcceptList, NpcId) of
		0 ->
			NewTaskId = npc_task_id1(NpcId),
			{PlayerStateNew, NewTaskId};
		TaskId ->
			{PlayerStateNew, TaskId}
	end.

%% 判断npc的状态信息－－从玩家已经接取的任务中
npc_task_id1(NpcId) ->
	TaskList = player_task_dict:get_player_task_list(),
	{FinshList, List} = get_finsh_list(TaskList, {[], []}),
	case npc_task_id2(FinshList, NpcId) of
		0 ->
			npc_task_id2(List, NpcId);
		TaskId ->
			TaskId
	end.
%% 判断npc的状态信息－－从拥有这个npcid的 任务列表中
npc_task_id2(AcceptList, NpcId) ->
	case lists:keyfind(NpcId, #task_conf.finish_npc_id, AcceptList) of
		false ->
			case lists:keyfind(NpcId, #task_conf.accept_npc_id, AcceptList) of
				false ->
					0;
				TaskConf ->
					TaskConf#task_conf.id
			end;
		TaskConf ->
			TaskConf#task_conf.id
	end.


%% 判断该任务能否接取
is_accept_task(PlayerState, TaskId) ->
	Base = PlayerState#player_state.db_player_base,
	TaskConf = task_config:get(TaskId),

	case TaskConf#task_conf.type_id of
		?TASKTYPEID_MERIT -> %% 接取功勋任务
			case counter_lib:check(PlayerState#player_state.player_id, ?COUNTER_MERIT_TASK_NUM) of
				true ->
					%% 功勋任务次数加一
					counter_lib:update_limit(PlayerState#player_state.player_id, ?COUNTER_MERIT_TASK_NUM),

					log_lib:log_daily(PlayerState, ?LOG_TYPE_TASK_MERIT, 0, ?STATUS_TASK_BEGIN),

					%% 刷新功勋任务领取红点
					button_tips_lib:ref_button_tips(PlayerState, ?BTN_TASK_MERIT),
					PlayerState1 = PlayerState#player_state{
						merit_task_id = 0
					},
					{PlayerState1, 0};
				_ ->
					{PlayerState, ?ERR_MAIN_TASK9}
			end;
		?TASKTYPEID_DAY -> %% 接取日常任务
			case counter_lib:check(PlayerState#player_state.player_id, ?COUNTER_DAY_TASK_NUM) of
				true ->
					%% 日常任务次数加一
					counter_lib:update_limit(PlayerState#player_state.player_id, ?COUNTER_DAY_TASK_NUM),

					log_lib:log_daily(PlayerState, ?LOG_TYPE_TASK_DAY, 0, ?STATUS_TASK_BEGIN),

					PlayerState1 = PlayerState#player_state{
						day_task_id = 0
					},
					{PlayerState1, 0};
				_ ->
					{PlayerState, ?ERR_MAIN_TASK10}
			end;
		?TASKTYPEID_WEEK -> %% 接取周任务
			case counter_lib:check(PlayerState#player_state.player_id, ?COUNTER_WEEK_TASK_NUM) of
				true ->
					%% 日常任务次数加一
					counter_lib:update_limit(PlayerState#player_state.player_id, ?COUNTER_WEEK_TASK_NUM),

					log_lib:log_daily(PlayerState, ?LOG_TYPE_TASK_WEEK, 0, ?STATUS_TASK_BEGIN),
					PlayerState1 = PlayerState#player_state{
						week_task_id = 0
					},
					{PlayerState1, 0};
				_ ->
					{PlayerState, ?ERR_MAIN_TASK11}
			end;
		?TASKTYPEID_MAP ->%% 接取宝图任务
			case counter_lib:check(PlayerState#player_state.player_id, ?COUNTER_MAP_TASK_NUM) of
				true ->
					%% 宝图任务次数加一
					counter_lib:update_limit(PlayerState#player_state.player_id, ?COUNTER_MAP_TASK_NUM),

					log_lib:log_daily(PlayerState, ?LOG_TYPE_TASK_MAP, 0, ?STATUS_TASK_BEGIN),

					PlayerState1 = PlayerState#player_state{
						map_task_id = 0
					},
					{PlayerState1, 0};
				_ ->
					{PlayerState, ?ERR_MAIN_TASK12}
			end;
		?TASKTYPEID_GUILD ->
			case Base#db_player_base.guild_id < 1 of
				true ->
					{PlayerState, ?ERR_MAIN_TASK7};
				_ ->
					log_lib:log_daily(PlayerState, ?LOG_TYPE_TASK_GUILD, 0, ?STATUS_TASK_BEGIN),
					{PlayerState, 0}
			end;
		_ -> %% 主线任务 －－支线任务
			%% 是否已经接取
			IsAccpet = player_task_dict:is_exist_task(TaskConf#task_conf.id),
			%% 是否已经完成
			IsFinish = player_task_finish_dict:is_exist_task(TaskConf#task_conf.id),
			%% 前置任务是否已经完成
			IsFontFinish = case TaskConf#task_conf.front_task_id > 0 of
							   true ->
								   player_task_finish_dict:is_exist_task(TaskConf#task_conf.front_task_id);
							   _ ->
								   true
						   end,
			?INFO("is_accept_task ~p ~p", [TaskId, IsFontFinish]),
			if
				TaskConf#task_conf.limit_lv > Base#db_player_base.lv ->
					{PlayerState, ?ERR_MAIN_TASK4};
				IsAccpet =:= true ->
					{PlayerState, ?ERR_MAIN_TASK3};
				IsFinish =:= true ->
					{PlayerState, ?ERR_MAIN_TASK6};
				IsFontFinish =:= false ->
					{PlayerState, ?ERR_MAIN_TASK5};
				true ->
					{PlayerState, 0}
			end
	end.

%% 根据职业获取 奖励信息
get_task_goods(Career, TaskId) ->
	TaskConf = task_config:get(TaskId),
	if
		Career =:= ?CAREER_ZHANSHI ->
			TaskConf#task_conf.goods_zhanshi;
		Career =:= ?CAREER_DAOSHI ->
			TaskConf#task_conf.goods_daoshi;
		true ->
			TaskConf#task_conf.goods_fashi
	end.

%% ***************************************************************************
%% API
%% ***************************************************************************
%% 获取快速完成任务需要消耗的元宝
get_task_complete_jade(PlayerId, TaskTypeId) ->
	NowNum = if
				 TaskTypeId =:= ?TASKTYPEID_DAY ->
					 counter_lib:get_value(PlayerId, ?COUNTER_DAY_TASK_JADE);
				 TaskTypeId =:= ?TASKTYPEID_MERIT ->
					 counter_lib:get_value(PlayerId, ?COUNTER_MERIT_TASK_JADE);
				 TaskTypeId =:= ?TASKTYPEID_MAP ->
					 counter_lib:get_value(PlayerId, ?COUNTER_MAP_TASK_JADE);
				 true ->
					 1
			 end,
	TaskCompleteInfo = task_complete_config:get(TaskTypeId, NowNum + 1),
	TaskCompleteInfo#task_complete_conf.need_jade.

%% 获取玩家已经完成的任务列表，和未完成的任务列表
get_finsh_list([], {FinshList, List}) ->
	{FinshList, List};

get_finsh_list([TaskInfo | H], {FinshList, List}) ->
	{FinshList1, List1} = case TaskInfo#db_player_task.isfinish =:= 1 of
							  true ->
								  NewFinshList = [task_config:get(TaskInfo#db_player_task.taskid_id) | FinshList],
								  {NewFinshList, List};
							  _ ->
								  NewList = [task_config:get(TaskInfo#db_player_task.taskid_id) | List],
								  {FinshList, NewList}
						  end,
	get_finsh_list(H, {FinshList1, List1}).

%% 获取额外奖励
get_goods_extra(TaskConf) ->
	#task_conf{goods_extra = GoodsList, goods_extra_probability = Rd} = TaskConf,
	case Rd of
		0 ->
			GoodsList;
		_ ->
			RdNum = util_rand:rand(1, 10000),
			case RdNum < Rd of
				true ->
					GoodsList;
				_ ->
					[]
			end
	end.





