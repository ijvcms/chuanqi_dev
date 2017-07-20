%%%-------------------------------------------------------------------
%%% @author yubing
%%% @copyright (C) 2015, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 01. 十二月 2015 18:41
%%%-------------------------------------------------------------------
-module(player_task_dict).

-include("cache.hrl").
-include("config.hrl").

-export([update_task_list/1,
	get_value_from_list_by_tasksortid/1,
	new_lists/0,
	delete_task_to_dict/1,
	get_value_from_list_by_taskid/1,
	is_exist_task/1,
	get_player_task_list/0,
	save_player_task_list/1,
	get_value_from_list_by_tasksortid/2,
	num_exist_type/1,
	inster_task_list/1]).

%% 玩家任务列表缓存表
-define(TASK_DICT, task_dict).

%% 生成一个新的字典
new_lists() ->
	put(?TASK_DICT, []).

%% 获取字典数据
get_player_task_list() ->
	get(?TASK_DICT).

%% 保存字典数据
save_player_task_list(TaskList) ->
	put(?TASK_DICT, TaskList).

%% 更新字典里面的数据
update_task_list(TaskInfo) ->
	TaskList = get_player_task_list(),
	TaskList1 = lists:keystore(TaskInfo#db_player_task.taskid_id, #db_player_task.taskid_id, TaskList, TaskInfo),
	save_player_task_list(TaskList1).

%% 更新字典里面的数据
inster_task_list(TaskInfo) ->
	TaskList = get_player_task_list(),
	TaskList1 = [TaskInfo | TaskList],
	save_player_task_list(TaskList1).

%% 删除任务至字典
delete_task_to_dict(TaskId) ->
	TaskList = get_player_task_list(),
	TaskList1 = lists:keydelete(TaskId, #db_player_task.taskid_id, TaskList),
	save_player_task_list(TaskList1).

%%========================================================
%% 根据任务ID获取字典里面的数据
get_value_from_list_by_taskid(TaskId) ->
	lists:keyfind(TaskId, #db_player_task.taskid_id, get_player_task_list()).

%% 根据任务类型获取任务数据数组
get_value_from_list_by_tasksortid(TaskSortId) ->
	F = fun(X) ->
		TaskConf = task_config:get(X#db_player_task.taskid_id),
		TaskConf#task_conf.sort_id =:= TaskSortId andalso X#db_player_task.isfinish =:= 0
	end,
	TaskList = get_player_task_list(),
	lists:filter(F, TaskList).
%% 根据任务类型获取任务数据数组
get_value_from_list_by_tasksortid(TaskSortId, Tool) ->
	F = fun(X) ->
		TaskConf = task_config:get(X#db_player_task.taskid_id),
		TaskConf#task_conf.sort_id =:= TaskSortId andalso
			X#db_player_task.isfinish =:= 0 andalso
			(TaskConf#task_conf.tool =:= Tool orelse TaskConf#task_conf.tool =:= 0)
	end,
	TaskList = get_player_task_list(),
	lists:filter(F, TaskList).


%%===========================================
%% 判断数组里面是否存在该任务 | 返回true/false
is_exist_task(TaskId) ->
	lists:keymember(TaskId, #db_player_task.taskid_id, get_player_task_list()).

%% 判断数组里面是否存在该任务类型 | 返回true/false
num_exist_type(TypeId) ->
	num_exist_type(get_player_task_list(), TypeId).
num_exist_type([], _TypeId) ->
	false;
num_exist_type([TaskInfo | T], TypeId) ->
	TaskConf = task_config:get(TaskInfo#db_player_task.taskid_id),
	case TaskConf#task_conf.type_id =:= TypeId of
		true ->
			true;
		_ ->
			num_exist_type(T, TypeId)
	end.
