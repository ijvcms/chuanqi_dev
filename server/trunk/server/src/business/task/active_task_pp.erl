%%%-------------------------------------------------------------------
%%% @author yubing
%%% @copyright (C) 2016, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 05. 一月 2016 14:24
%%%-------------------------------------------------------------------
-module(active_task_pp).

-include("proto.hrl").
-include("record.hrl").
-include("common.hrl").
-include("cache.hrl").
%% API
-export([handle/3]).

%%获取玩家的日常任务列表
handle(19000, PlayerState, _Data) ->
	?DEBUG("-=-=-=-=-=-=-=-=-=-=-="),
	TaskList = active_task_lib:get_player_task_list(PlayerState),
	?DEBUG("~p", [TaskList]),
	Base = PlayerState#player_state.db_player_base,
	StrReward = Base#db_player_base.task_reward_active,
	ReswardList = [X || {X} <- StrReward],
	net_send:send_to_client(PlayerState#player_state.socket, 19000, #rep_task_list{player_tasklist = TaskList, player_reward_list = ReswardList}),
	{ok, PlayerState};

%%领取任务 完成度的奖励
handle(19001, PlayerState, Data) ->
	Active = Data#req_task_reward.active,
	{ok, NewState} = active_task_lib:reward_goods(PlayerState, 19001, Active),
	{ok, NewState};

handle(Cmd, PlayerState, Data) ->
	?ERR("not define ~p cmd:~nstate: ~p~ndata: ~p", [Cmd, PlayerState, Data]),
	{ok, PlayerState}.

