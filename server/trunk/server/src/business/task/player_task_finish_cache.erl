%%%-------------------------------------------------------------------
%%% @author apple
%%% @copyright (C) 2015, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 30. 十一月 2015 19:19
%%%-------------------------------------------------------------------
-module(player_task_finish_cache).

-include("common.hrl").
-include("cache.hrl").


-export([
	select_row/2,
	select_all/1,
	insert/1,
	delete/2,
	update/2
]).

select_row(PlayerId, TaskId) ->
	db_cache_lib:select_row(?DB_PLAYER_TASK_FINISH, {TaskId, PlayerId}).

select_all(PlayerId) ->
	db_cache_lib:select_all(?DB_PLAYER_TASK_FINISH, {'_', PlayerId}).

insert(TaskInfo) ->
	TaskId = TaskInfo#db_player_task_finish.taskid_id,
	PlayerId = TaskInfo#db_player_task_finish.player_id,
	db_cache_lib:insert(?DB_PLAYER_TASK_FINISH, {TaskId, PlayerId}, TaskInfo).

update(PlayerId, TaskInfo) ->
	db_cache_lib:update(?DB_PLAYER_TASK_FINISH, {TaskInfo#db_player_task_finish.taskid_id, PlayerId}, TaskInfo).

delete(PlayerId, TaskInfo) ->
	db_cache_lib:delete(?DB_PLAYER_TASK_FINISH, {TaskInfo#db_player_task_finish.taskid_id, PlayerId}).

%% API

