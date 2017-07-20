%%%-------------------------------------------------------------------
%%% @author yubing
%%% @copyright (C) 2016, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 05. 一月 2016 14:24
%%%-------------------------------------------------------------------
-module(active_task_lib).

-include("cache.hrl").
-include("config.hrl").
-include("proto.hrl").
-include("record.hrl").
-include("common.hrl").
-include("button_tips_config.hrl").
-include("log_type_config.hrl").

-export([
	check_ref_tasklist/2,
	get_active_num/1,
	reward_goods/3,
	get_player_task_list/1,
	init_task_list_new/1,
	ref_player_task_list/1,
	check_ref_guild_task/4,
	taskreward_list/1
]).

%% ******************************* 活跃度任务 start
%% 获取新加的 活跃信息
init_task_list_new(Base) ->
	%% 获取配置 静态任务数据
	List2 = task_lib:get_task_conf_list(?TASKTYPEID2, {Base, false}),
	F = fun(X) ->
		%% 存库
		TaskInfo = #db_player_task
		{
			taskid_id = X#task_conf.id,
			player_id = Base#db_player_base.player_id,
			nownum = 0,
			isfinish = 0
		},
		player_task_cache:insert(TaskInfo),
		player_task_dict:inster_task_list(TaskInfo),
		TaskInfo
	end,
	[F(X) || X <- List2].

%% 获取玩家的活跃任务列表
get_player_task_list(_State) ->
	TaskList = task_lib:get_player_task_list_by_type_id(?TASKTYPEID2),
	F = fun(X) ->
		#proto_taskinfo
		{
			task_id = X#db_player_task.taskid_id,
			nownum = X#db_player_task.nownum,
			isfinish = X#db_player_task.isfinish
		}
	end,

	?INFO("activetasklist ~p", [TaskList]),
	[F(X) || X <- TaskList].

%% 判断玩家的 任务是否可以刷新了 IsOpenFunction 是否是开启功能 IsLogin是否登陆的时候调用
check_ref_tasklist(PlayerState, IsLogin) ->
	Base = PlayerState#player_state.db_player_base,
	RefTime = Base#db_player_base.ref_task_time,
	%% 获取当前的时间搓
	NowTime = util_date:unixtime(),

	%% 更新玩家工会任务
	{ok, PlayerStateNew1} = check_ref_guild_task(PlayerState, Base, NowTime, IsLogin),
	case NowTime >= RefTime + 2 of
		true ->
			%%?INFO(" active_task_lib 2222 ~p ~p", [2222,IsOpenFunction]),
			%% 如果当前时间大于 修改 需要修改的 玩家状态信息
			Update = #player_state{
				db_player_base = #db_player_base{
					ref_task_time = util_date:get_tomorrow_unixtime(),
					task_reward_active = []
				}
			},
			{ok, PlayerStateNew2} = player_lib:update_player_state(PlayerStateNew1, Update),
			PlayerStateNew3 = case IsLogin of
								  true ->
									  PlayerStateNew2;
								  _ ->
									  main_task_lib:ref_task_navigate_list(PlayerStateNew2)
							  end,
			%% 如果功能开启的话 那么刷新任务
			ref_player_task_list(PlayerStateNew3),
			{ok, PlayerStateNew3};
		_ ->
			{ok, PlayerStateNew1}
	end.
%% 判断玩家的工会任务
check_ref_guild_task(PlayerState, Base, NowTime, IsLogin) ->
	%% 判断玩家的工会任务
	case NowTime >= Base#db_player_base.guild_task_time + 2 andalso Base#db_player_base.guild_id > 0 of
		true ->
			?INFO(" check_ref_guild_task NowTime ~p ~p", [NowTime, Base#db_player_base.guild_task_time]),

			main_task_lib:ref_task_clear(PlayerState, task_lib:get_player_task_list_by_type_id(?TASKTYPEID_GUILD), Base#db_player_base.guild_task_id),
			%% 获取工会任务
			GuildTaskList = task_lib:get_task_conf_list(?TASKTYPEID_GUILD, {Base, 0}),
			case length(GuildTaskList) > 0 of
				true ->
					[GuildInfo | _H] = GuildTaskList,
					Update = #player_state{
						db_player_base = #db_player_base{
							guild_task_id = GuildInfo#task_conf.id,
							guild_task_time = util_date:get_tomorrow_unixtime()
						}
					},
					{ok, PlayerState1} = player_lib:update_player_state(PlayerState, Update),
					PlayerState2 = case IsLogin of
									   true ->
										   PlayerState1;
									   _ ->
										   main_task_lib:ref_task_navigate_list(PlayerState1)
								   end,
					{ok, PlayerState2};
				_ ->
					{ok, PlayerState}
			end;
		_ ->
			{ok, PlayerState}
	end.


%% 每日刷新活跃任务信息
ref_player_task_list(PlayerState) ->
	PlayerTaskList = player_task_cache:select_all(PlayerState#player_state.player_id),
	List_Active = task_lib:get_player_task_list_by_type_id(?TASKTYPEID2),
	%% 刷新活跃任务
	case List_Active of
		[] ->
			List2 = task_lib:get_task_conf_list(?TASKTYPEID2, {PlayerState#player_state.db_player_base, true}),
			F = fun(X, List) ->
				%% 存库
				TaskInfo = #db_player_task
				{
					taskid_id = X#task_conf.id,
					player_id = PlayerState#player_state.player_id,
					nownum = 0,
					isfinish = 0
				},
				player_task_cache:insert(TaskInfo),
				player_task_dict:inster_task_list(TaskInfo),
				[TaskInfo | List]
			end,
			NewList = lists:foldr(F, PlayerTaskList, List2),
			player_task_dict:save_player_task_list(NewList);
		List ->
			%% 解析任务 并装入TaskList
			F = fun(X, TempList) ->
				TaskInfo = X#db_player_task{
					nownum = 0,
					isfinish = 0
				},
				player_task_cache:update(PlayerState#player_state.player_id, TaskInfo),
				lists:keyreplace(X#db_player_task.taskid_id, #db_player_task.taskid_id, TempList, TaskInfo)
			end,
			NewList = lists:foldr(F, PlayerTaskList, List),
			player_task_dict:save_player_task_list(NewList)
	end,
	%% 刷新活跃任务领取红点
	button_tips_lib:ref_button_tips(PlayerState, ?BTN_DAILY_TARGET).

taskreward_list(Lv) ->
	List = taskreward_config:get_list_conf(),
	LvTarget = lists:min([E#taskreward_conf.lv || E <- List, Lv =< E#taskreward_conf.lv]),
	lists:filter(fun(E) -> LvTarget =:= E#taskreward_conf.lv end, List).

taskreward_get(Lv, Active) ->
	List = taskreward_list(Lv),
	lists:keyfind(Active, #taskreward_conf.need_active, List).

%% 领取活跃度奖励
reward_goods(PlayerState, Cmd, Active) ->
	Base = PlayerState#player_state.db_player_base,
	MyReward = Base#db_player_base.task_reward_active,
	IsIn = lists:member({Active}, MyReward),
	if
		IsIn =:= false ->
			NowActive = get_active_num(PlayerState),
			if
				NowActive >= Active ->
					Goods = taskreward_get(Base#db_player_base.lv, Active),
					MyReward1 = [{Active} | MyReward],

					Update = #player_state
					{
						db_player_base = #db_player_base
						{
							task_reward_active = MyReward1
						}
					},

					Goodslist = Goods#taskreward_conf.goods,
					case goods_lib_log:add_goods_list(PlayerState, Goodslist, ?LOG_TYPE_TASK_ACTIVE) of
						{ok, PlayerState1} ->
							net_send:send_to_client(PlayerState#player_state.socket, Cmd, #rep_task_reward{result = 0}),

							%% 此行必须最后一行 需要返回 状态信息
							{ok, PlayerState2} = player_lib:update_player_state(PlayerState1, Update),

							%% 刷新活跃任务领取红点
							button_tips_lib:ref_button_tips(PlayerState2, ?BTN_DAILY_TARGET);
						{fail, Err} ->
							net_send:send_to_client(PlayerState#player_state.socket, Cmd, #rep_task_reward{result = Err}),
							{ok, PlayerState};
						_ ->
							{ok, PlayerState}
					end;
				true ->
					{ok, PlayerState}
			end;
		true ->
			{ok, PlayerState}
	end.

%% 获取玩家当前已经完成的活跃度
get_active_num(PlayerState) ->
	TaskList = active_task_lib:get_player_task_list(PlayerState),
	F = fun(X, Sum) ->
		case X#proto_taskinfo.isfinish =:= 1 of
			true ->
				TaskConf = task_config:get(X#proto_taskinfo.task_id),
				Sum + TaskConf#task_conf.active;
			_ ->
				Sum + 0
		end
	end,
	lists:foldl(F, 0, TaskList).


%% ****************************
