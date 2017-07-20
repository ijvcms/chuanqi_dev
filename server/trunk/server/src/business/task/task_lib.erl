%%%-------------------------------------------------------------------
%%% @author apple
%%% @copyright (C) 2015, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 30. 十一月 2015 14:07
%%%-------------------------------------------------------------------
-module(task_lib).

-export([init_task/1,
	get_player_task_list_by_type_id/1,
	get_player_task_list_not_type_id/1,
	get_task_conf_list/2]).

-include("cache.hrl").
-include("config.hrl").
-include("proto.hrl").
-include("record.hrl").
-include("common.hrl").

%%初始化玩家任务信息
init_task(State) ->
	PlayerId = State#player_state.player_id,

	%% 处理玩家的任务信息 初始化dict
	%% 玩家已经接取的所有任务
	player_task_dict:new_lists(),
	List = player_task_cache:select_all(PlayerId),
	player_task_dict:save_player_task_list(List),

	%% 处理玩家完成任务的列表信息
	%% 玩家已经完成的任务
	player_task_finish_dict:new_lists(),
	ListFinish = player_task_finish_cache:select_all(PlayerId),
	player_task_finish_dict:save_player_task_finish_list(ListFinish),

	%% 刷新判断 更新活跃任务
	{ok, NewState} = active_task_lib:check_ref_tasklist(State, true),

	%% 查看新的日常任务信息
	active_task_lib:init_task_list_new(NewState#player_state.db_player_base),

	NewState.

%% 根据类型获取任务列表
get_player_task_list_by_type_id(TypeId) ->
	List = player_task_dict:get_player_task_list(),
	?INFO("list1111 ~p", [List]),
	F = fun(X) ->
		TaskConf = task_config:get(X#db_player_task.taskid_id),
		TaskConf#task_conf.type_id =:= TypeId
	end,
	lists:filter(F, List).

%% 根据类型获取任务列表
get_player_task_list_not_type_id(TypeId) ->
	List = player_task_dict:get_player_task_list(),
	F = fun(X) ->
		TaskConf = task_config:get(X#db_player_task.taskid_id),
		TaskConf#task_conf.type_id /= TypeId
	end,
	lists:filter(F, List).


%% 获取任务列表
get_task_conf_list(?TASKTYPEID1, Base) ->
	TaskType = ?TASKTYPEID1,
	Lv = Base#db_player_base.lv,
	TaskIdList1 = task_config:get_type_list(TaskType, Lv),
	[task_config:get(TaskId) || {TaskId, _MinLv, MaxLv, FrontId} <- TaskIdList1,
		MaxLv =< Lv,
		player_task_dict:is_exist_task(TaskId) =:= false,
		player_task_finish_dict:is_exist_task(TaskId) =:= false,
		FrontId =:= 0 orelse player_task_finish_dict:is_exist_task(FrontId) =:= true
	];
get_task_conf_list(?TASKTYPEID_OTHER, Base) ->
	TaskType = ?TASKTYPEID_OTHER,
	Lv = Base#db_player_base.lv,
	TaskIdList1 = task_config:get_type_list(TaskType, Lv),
	[task_config:get(TaskId) || {TaskId, _MinLv, MaxLv, FrontId} <- TaskIdList1,
		MaxLv =< Lv,
		player_task_dict:is_exist_task(TaskId) =:= false,
		player_task_finish_dict:is_exist_task(TaskId) =:= false,
		FrontId =:= 0 orelse player_task_finish_dict:is_exist_task(FrontId) =:= true
	];
get_task_conf_list(?TASKTYPEID2, TempBase) ->
	TaskType = ?TASKTYPEID2,
	%% {玩家基础信息,是否包含已经接取的任务}
	{Base, IsHave} = TempBase,
	Lv = Base#db_player_base.lv,
	TaskIdList1 = task_config:get_type_list(TaskType, Lv),
	case IsHave of
		true ->
			[task_config:get(TaskId) || {TaskId, _, _, _FrontId} <- TaskIdList1];
		_ ->
			[task_config:get(TaskId) || {TaskId, _, _, _FrontId} <- TaskIdList1,
				player_task_dict:is_exist_task(TaskId) =:= false]
	end;
get_task_conf_list(?TASKTYPEID_GUILD, TempBase) ->
	TaskType = ?TASKTYPEID_GUILD,
	{Base, TempFrontId} = TempBase,
	Lv = Base#db_player_base.lv,
	TaskIdList1 = task_config:get_type_list(TaskType, Lv),
	[task_config:get(TaskId) || {TaskId, _MinLv, _MaxLv, FrontId} <- TaskIdList1, FrontId =:= TempFrontId];
get_task_conf_list(TaskType, Base) ->
	Lv = Base#db_player_base.lv,
	TaskIdList1 = task_config:get_type_list(TaskType, Lv),
	[task_config:get(TaskId) || {TaskId, _MinLv, _MaxLv, _FrontId} <- TaskIdList1].
