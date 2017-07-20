%%%-------------------------------------------------------------------
%%%-------------------------------------------------------------------
%%%-------------------------------------------------------------------
%%% @author yubing
%%% @copyright (C) 2016, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 05. 一月 2016 14:16
%%%-------------------------------------------------------------------
-module(main_task_pp).


-include("proto.hrl").
-include("record.hrl").
-include("common.hrl").
-include("cache.hrl").
-include("language_config.hrl").
%% API
-export([handle/3]).

%%获取导航列表
handle(26000, PlayerState, _Data) ->
	{PlayerState1, TaskList} = main_task_lib:get_task_navigate_list(PlayerState),
	?INFO("send 26000: ~p", [TaskList]),
	net_send:send_to_client(PlayerState1#player_state.socket, 26000, #rep_navigate_task_list{navigate_task_list = TaskList}),
	{ok, PlayerState1};

%%接取任务
handle(26001, PlayerState, Data) ->
	?INFO("26001 ~p", [Data]),
	TaskId = Data#req_navigate_accept_task.task_id,
	{ok, PlayerState1, Result} = main_task_lib:accept_task(PlayerState, TaskId),
	net_send:send_to_client(PlayerState#player_state.socket, 26001, #rep_navigate_accept_task{result = Result, task_id = TaskId}),
	{ok, PlayerState1};
%%领取任务 完成度的奖励
handle(26002, PlayerState, Data) ->
	?INFO("26002 ~p", [Data]),
	TaskId = Data#req_navigate_finish_task.task_id,
	{ok, PlayerState1, Result} = main_task_lib:finish_task(PlayerState, TaskId),
	net_send:send_to_client(PlayerState#player_state.socket, 26002, #rep_navigate_finish_task{result = Result, task_id = TaskId}),
	{ok, PlayerState1};

%快速完成 功勋任务
handle(26007, PlayerState, Data) ->
	?INFO("26007 ~p", [Data]),
	TaskId = Data#req_fast_finish_task.task_id,
	case main_task_lib:fast_finish_task(PlayerState, TaskId) of
		{ok, PlayerState1} ->
			net_send:send_to_client(PlayerState1#player_state.socket, 26007, #rep_fast_finish_task{result = ?ERR_COMMON_SUCCESS, task_id = TaskId}),
			{ok, PlayerState1};
		{fail, Err} ->
			net_send:send_to_client(PlayerState#player_state.socket, 26007, #rep_fast_finish_task{result = Err, task_id = TaskId})
	end;

%快速完成 任务需要多少元宝
handle(26009, PlayerState, Data) ->
	?INFO("26009 ~p", [Data]),
	TaskTypeId = Data#req_get_task_complete_jade.task_type,
	Result = main_task_lib:get_task_complete_jade(PlayerState#player_state.player_id, TaskTypeId),
	net_send:send_to_client(PlayerState#player_state.socket, 26009, #rep_get_task_complete_jade{result = Result});

handle(Cmd, PlayerState, Data) ->
	?ERR("not define ~p cmd:~nstate: ~p~ndata: ~p", [Cmd, PlayerState, Data]),
	{ok, PlayerState}.

