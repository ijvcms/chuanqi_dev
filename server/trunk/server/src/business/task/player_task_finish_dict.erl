%%%-------------------------------------------------------------------
%%% @author yubing
%%% @copyright (C) 2015, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 01. 十二月 2015 18:41
%%%-------------------------------------------------------------------
-module(player_task_finish_dict).

-include("cache.hrl").
-include("config.hrl").

-export([update_task_list/1,
	new_lists/0,
	delete_task_to_dict/1,
	get_player_task_finish_info/1,
	is_exist_task/1,
	get_player_task_finish_list/0,
	save_player_task_finish_list/1,
	inster_task_list/1]).

%% 玩家任务列表缓存表
-define(TASK_FINISH_DICT, task_finish_dict).

%% 生成一个新的字典
new_lists() ->
	put(?TASK_FINISH_DICT, []).

%% 获取字典数据
get_player_task_finish_list() ->
	get(?TASK_FINISH_DICT).

%% 保存字典数据
save_player_task_finish_list(TaskFinishList) ->
	put(?TASK_FINISH_DICT, TaskFinishList).

%% 更新字典里面的数据
update_task_list(TaskFinishInfo) ->
	TaskFinishList = get_player_task_finish_list(),
	TaskFinishList1 = lists:keystore(TaskFinishInfo#db_player_task_finish.taskid_id, #db_player_task_finish.taskid_id, TaskFinishList, TaskFinishInfo),
	save_player_task_finish_list(TaskFinishList1).
%% 更新字典里面的数据
inster_task_list(TaskFinishInfo) ->
	TaskFinishList = get_player_task_finish_list(),
	TaskFinishList1=[TaskFinishInfo | TaskFinishList],
	save_player_task_finish_list(TaskFinishList1).

%% 删除任务至字典
delete_task_to_dict(TaskFinishInfo) ->
	TaskFinishList = get_player_task_finish_list(),
	TaskFinishList1 = lists:keydelete(TaskFinishInfo#db_player_task_finish.taskid_id, #db_player_task_finish.taskid_id, TaskFinishList),
	save_player_task_finish_list(TaskFinishList1).

%%========================================================
%% 根据任务ID获取字典里面的数据
get_player_task_finish_info(TaskId) ->
	lists:keyfind(TaskId, #db_player_task_finish.taskid_id, get_player_task_finish_list()).

%%===========================================
%% 判断数组里面是否存在该任务 | 返回true/false
is_exist_task(TaskId) ->
	lists:keymember(TaskId, #db_player_task_finish.taskid_id, get_player_task_finish_list()).
