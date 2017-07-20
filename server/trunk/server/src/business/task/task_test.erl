%%%-------------------------------------------------------------------
%%% @author apple
%%% @copyright (C) 2015, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 30. 十一月 2015 14:07
%%%-------------------------------------------------------------------
-module(task_test).

-compile([export_all]).

-include("cache.hrl").
-include("config.hrl").
-include("proto.hrl").
-include("record.hrl").
-include("common.hrl").

%% 跳转任务
task_jump(PlayerState, TaskId) ->
	case task_config:get(TaskId) of
		null ->
			skip;
		TaskConf ->
			case TaskConf#task_conf.type_id /= ?TASKTYPEID1 of
				true ->
					skip;
				_ ->
					F = fun(X) ->
						case X#proto_navigate_task_info.state /= 2 of
							true ->
								player_task_cache:delete(PlayerState#player_state.player_id, X#proto_navigate_task_info.task_id),
								player_task_dict:delete_task_to_dict(X#proto_navigate_task_info.task_id);
							_ ->
								skip
						end,
						?INFO("taskconf ~p", [X]),
						ref_task_navigate_list_finish(PlayerState, X#proto_navigate_task_info.task_id)
					end,
					{_PlayerStateNew, TaskNavigateList} = main_task_lib:get_task_navigate_list(PlayerState),
					[F(X) || X <- TaskNavigateList],

					TaskFinishList1 = player_task_finish_dict:get_player_task_finish_list(),
					F1 = fun(X) ->
						player_task_finish_dict:delete_task_to_dict(X),
						player_task_finish_cache:delete(PlayerState#player_state.player_id, X)
					end,
					[F1(X) || X <- TaskFinishList1],

					add_fun_task(PlayerState#player_state.player_id, TaskConf),
					main_task_lib:ref_task_navigate_list(PlayerState)
			%%main_task_lib:accept_task(PlayerState,TaskConf#task_conf.id),
			end
	end.

%% 刷新数据信息
ref_task_navigate_list_finish(PlayerState, TaskId) ->
	TaskNavigateInfo = #proto_navigate_task_info{
		task_id = TaskId,
		state = 3
	},
	TaskNavigateList = [TaskNavigateInfo],
	?INFO("task_test del ~p", [TaskNavigateList]),
	net_send:send_to_client(PlayerState#player_state.socket, 26003, #rep_navigate_ref_task_list{navigate_task_list = TaskNavigateList}).

%% 添加任务的前置任务信息
add_fun_task(PlayerId, TaskConf) ->
	case TaskConf#task_conf.front_task_id > 0 of
		true ->
			TaskFinishInfo = #db_player_task_finish{
				taskid_id = TaskConf#task_conf.front_task_id,
				player_id = PlayerId
			},
			%% 添加完成数据
			player_task_finish_cache:insert(TaskFinishInfo),
			player_task_finish_dict:inster_task_list(TaskFinishInfo),

			TaskConf1 = task_config:get(TaskConf#task_conf.front_task_id),
			add_fun_task(PlayerId, TaskConf1);
		_ ->
			skip
	end.

%% 立刻完成身上所有任务
task_finish(PlayerState) ->
	TaskList = player_task_dict:get_player_task_list(),
	F = fun(X, List) ->
		TaskConf = task_config:get(X#db_player_task.taskid_id),
		X1 =
			X#db_player_task{
				isfinish = 1,
				nownum = TaskConf#task_conf.need_num
			},
		%% 存库
		player_task_cache:update(PlayerState#player_state.player_id, X1),
		player_task_dict:update_task_list(X1),

		case TaskConf#task_conf.type_id /= ?TASKTYPEID2 of
			true ->
				[X1 | List];
			_ ->
				List
		end
	end,
	TaskList1 = lists:foldl(F, [], TaskList),
	main_task_lib:ref_task_navigate_list(PlayerState, TaskList1).

%% 立刻指定的任务
task_finish(PlayerState, TaskId) ->
	TaskList = [X || X <- player_task_dict:get_player_task_list(), X#db_player_task.taskid_id =:= TaskId],
	F = fun(X, List) ->
		TaskConf = task_config:get(X#db_player_task.taskid_id),
		X1 =
			X#db_player_task{
				isfinish = 1,
				nownum = TaskConf#task_conf.need_num
			},
		%% 存库
		player_task_cache:update(PlayerState#player_state.player_id, X1),
		player_task_dict:update_task_list(X1),

		case TaskConf#task_conf.type_id /= ?TASKTYPEID2 of
			true ->
				[X1 | List];
			_ ->
				List
		end
	end,
	TaskList1 = lists:foldl(F, [], TaskList),
	main_task_lib:ref_task_navigate_list(PlayerState, TaskList1).


