%%%-------------------------------------------------------------------
%%% @author yubing
%%% @copyright (C) 2016, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 05. 一月 2016 10:20
%%%-------------------------------------------------------------------
-module(task_comply).

-include("cache.hrl").
-include("config.hrl").
-include("proto.hrl").
-include("record.hrl").
-include("common.hrl").
-include("button_tips_config.hrl").

-export([update_player_task_info/3,
  update_player_tasksort_kill_scene/3,
  update_player_tasksort_up_lv/1,
  update_player_tasksort_hava_goods/2,
  update_player_tasksort_kill_monster/2,
  update_accpet__player_task/2,
  update_player_tasksort_past_fb/2,
  update_player_tasksort_collect_item/2,
  update_player_task_info_tool/4
]).

%% 更新玩家的任务信息 标准版
update_player_task_info(PlayerPid, TaskSortId, Num) when is_pid(PlayerPid) ->
  gen_server2:apply_async(PlayerPid, {?MODULE, update_player_task_info, [TaskSortId, Num]});

%% 更新玩家的任务信息 标准版
update_player_task_info(State, TaskSortId, Num) ->
  PlayerId = State#player_state.player_id,
  TaskList = player_task_dict:get_value_from_list_by_tasksortid(TaskSortId),
  F = fun(X, List) ->
    Num1 = X#db_player_task.nownum + Num,
    TaskConf = task_config:get(X#db_player_task.taskid_id),
    X1 =
      case TaskConf#task_conf.need_num =< Num1 of
        true ->
          X#db_player_task{
            isfinish = 1,
            nownum = TaskConf#task_conf.need_num
          };
        _ ->
          X#db_player_task{
            nownum = Num1
          }
      end,
    %% 存库
    player_task_cache:update(PlayerId, X1),
    player_task_dict:update_task_list(X1),

    if
      TaskConf#task_conf.type_id =:= ?TASKTYPEID2 ->
        send_active_task(State, X, X1, TaskConf),
        List;
      true ->
        [X1 | List]
    end
  end,
  TaskList1 = lists:foldl(F, [], TaskList),
  main_task_lib:ref_task_navigate_list(State, TaskList1),
  {ok, State}.

%% 更新玩家的任务信息 标准版
update_player_task_info_tool(PlayerPid, TaskSortId, Tool, Num) when is_pid(PlayerPid) ->
  gen_server2:apply_async(PlayerPid, {?MODULE, update_player_task_info_tool, [TaskSortId, Tool, Num]});

%% 更新玩家的任务信息 标准版
update_player_task_info_tool(State, TaskSortId, Tool, Num) ->
  PlayerId = State#player_state.player_id,
  TaskList = player_task_dict:get_value_from_list_by_tasksortid(TaskSortId, Tool),
  F = fun(X, List) ->
    Num1 = X#db_player_task.nownum + Num,
    TaskConf = task_config:get(X#db_player_task.taskid_id),
    X1 =
      case TaskConf#task_conf.need_num =< Num1 of
        true ->
          X#db_player_task{
            isfinish = 1,
            nownum = TaskConf#task_conf.need_num
          };
        _ ->
          X#db_player_task{
            nownum = Num1
          }
      end,
    %% 存库
    player_task_cache:update(PlayerId, X1),
    player_task_dict:update_task_list(X1),

    if
      TaskConf#task_conf.type_id =:= ?TASKTYPEID2 ->
        send_active_task(State, X, X1, TaskConf),
        List;
      true ->
        [X1 | List]
    end
  end,
  TaskList1 = lists:foldl(F, [], TaskList),
  main_task_lib:ref_task_navigate_list(State, TaskList1),
  {ok, State}.

%% 更新玩家的场景击杀任务信息
update_player_tasksort_kill_scene(PlayerPid, Num, SceneId) when is_pid(PlayerPid) ->
  gen_server2:apply_async(PlayerPid, {?MODULE, update_player_tasksort_kill_scene, [Num, SceneId]});

%% 更新玩家的场景击杀任务信息
update_player_tasksort_kill_scene(State, Num, SceneId) ->
  PlayerId = State#player_state.player_id,
  TaskList = player_task_dict:get_value_from_list_by_tasksortid(?TASKSORT_KILL_SCENE, SceneId),
  F = fun(X, List) ->
    Num1 = X#db_player_task.nownum + Num,
    TaskConf = task_config:get(X#db_player_task.taskid_id),
    X1 =
      case TaskConf#task_conf.need_num =< Num1 of
        true ->
          X#db_player_task{
            isfinish = 1,
            nownum = TaskConf#task_conf.need_num
          };
        _ ->
          X#db_player_task{
            nownum = Num1
          }
      end,
    %% 存库
    player_task_cache:update(PlayerId, X1),
    player_task_dict:update_task_list(X1),

    if
      TaskConf#task_conf.type_id =:= ?TASKTYPEID2 ->
        send_active_task(State, X, X1, TaskConf),
        List;
      true ->
        [X1 | List]
    end
  end,
  TaskList1 = lists:foldl(F, [], TaskList),
  main_task_lib:ref_task_navigate_list(State, TaskList1),

  {ok, State}.

%% 更新玩家升级任务信息
update_player_tasksort_up_lv(PlayerPid) when is_pid(PlayerPid) ->
  gen_server2:apply_async(PlayerPid, {?MODULE, update_player_tasksort_up_lv, []});

%% 更新玩家升级任务信息
update_player_tasksort_up_lv(State) ->
  Base = State#player_state.db_player_base,
  PlayerId = State#player_state.player_id,
  TaskList = player_task_dict:get_value_from_list_by_tasksortid(?TASKSORT_UP_LV),
  Num1 = Base#db_player_base.lv,
  F = fun(X, List) ->
    TaskConf = task_config:get(X#db_player_task.taskid_id),
    X1 =
      case TaskConf#task_conf.need_num =< Num1 of
        true ->
          X#db_player_task{
            isfinish = 1,
            nownum = TaskConf#task_conf.need_num
          };
        _ ->
          X#db_player_task{
            nownum = Num1
          }
      end,
    %% 存库
    player_task_cache:update(PlayerId, X1),
    player_task_dict:update_task_list(X1),

    if
      TaskConf#task_conf.type_id =:= ?TASKTYPEID2 ->
        send_active_task(State, X, X1, TaskConf),
        List;
      true ->
        [X1 | List]
    end
  end,
  TaskList1 = lists:foldl(F, [], TaskList),

  NewState1 = main_task_lib:ref_task_navigate_list(State),
  main_task_lib:ref_task_navigate_list(NewState1, TaskList1),
  %% 开服活动刷新
  active_service_lib:ref_button_tips(NewState1, ?ACTIVE_SERVICE_TYPE_LV).%%

%% 更新玩家获取道具信息
update_player_tasksort_hava_goods(PlayerPid, GoodsId) when is_pid(PlayerPid) ->
  gen_server2:apply_async(PlayerPid, {?MODULE, update_player_tasksort_hava_goods, [GoodsId]});

%% 更新玩家获取道具信息
update_player_tasksort_hava_goods(State, GoodsId) ->
  PlayerId = State#player_state.player_id,
  TaskList = player_task_dict:get_value_from_list_by_tasksortid(?TASKSORT_HAVE_ITEM, GoodsId),
  F = fun(X, List) ->
    TaskConf = task_config:get(X#db_player_task.taskid_id),
    Num1 = goods_lib:get_goods_num(GoodsId),
    X1 =
      case TaskConf#task_conf.need_num =< Num1 of
        true ->
          X#db_player_task{
            isfinish = 1,
            nownum = TaskConf#task_conf.need_num
          };
        _ ->
          X#db_player_task{
            nownum = Num1
          }
      end,
    %% 存库
    player_task_cache:update(PlayerId, X1),
    player_task_dict:update_task_list(X1),

    if
      TaskConf#task_conf.type_id =:= ?TASKTYPEID2 ->
        send_active_task(State, X, X1, TaskConf),
        List;
      true ->
        [X1 | List]
    end
  end,
  TaskList1 = lists:foldl(F, [], TaskList),
  main_task_lib:ref_task_navigate_list(State, TaskList1),
  {ok, State}.

%% 更新玩家的怪物击杀任务信息
update_player_tasksort_kill_monster(PlayerPid, MonsterId) when is_pid(PlayerPid) ->
  gen_server2:apply_async(PlayerPid, {?MODULE, update_player_tasksort_kill_monster, [MonsterId]});

%% 更新玩家升级任务信息
update_player_tasksort_kill_monster(State, MonsterId) ->
  PlayerId = State#player_state.player_id,
  TaskList = player_task_dict:get_value_from_list_by_tasksortid(?TASKSORT_MONSTER, MonsterId),
  F = fun(X, List) ->
    TaskConf = task_config:get(X#db_player_task.taskid_id),
    Num1 = X#db_player_task.nownum + 1,

    X1 =
      case TaskConf#task_conf.need_num =< Num1 of
        true ->
          X#db_player_task{
            isfinish = 1,
            nownum = TaskConf#task_conf.need_num
          };
        _ ->
          X#db_player_task{
            nownum = Num1
          }
      end,
    %% 存库
    player_task_cache:update(PlayerId, X1),
    player_task_dict:update_task_list(X1),

    if
      TaskConf#task_conf.type_id =:= ?TASKTYPEID2 ->
        send_active_task(State, X, X1, TaskConf),
        List;
      true ->
        [X1 | List]
    end
  end,
  TaskList1 = lists:foldl(F, [], TaskList),
  main_task_lib:ref_task_navigate_list(State, TaskList1),
  %% 更新任务信息
  update_player_tasksort_collect_item(State, MonsterId),
  {ok, State}.

%% 通关副本信息 纪录
update_player_tasksort_past_fb(PlayerPid, SceneId) when is_pid(PlayerPid) ->
  gen_server2:apply_async(PlayerPid, {?MODULE, update_player_tasksort_past_fb, [SceneId]});

%% 更新玩家升级任务信息
update_player_tasksort_past_fb(State, SceneId) ->
  ?INFO("SceneId ", [SceneId]),
  PlayerId = State#player_state.player_id,
  TaskList = player_task_dict:get_value_from_list_by_tasksortid(?TASKSORT_PAST_FB, SceneId),
  F = fun(X, List) ->
    TaskConf = task_config:get(X#db_player_task.taskid_id),
    Num1 = X#db_player_task.nownum + 1,
    X1 =
      case TaskConf#task_conf.need_num =< Num1 of
        true ->
          X#db_player_task{
            isfinish = 1,
            nownum = TaskConf#task_conf.need_num
          };
        _ ->
          X#db_player_task{
            nownum = Num1
          }
      end,
    %% 存库
    player_task_cache:update(PlayerId, X1),
    player_task_dict:update_task_list(X1),

    if
      TaskConf#task_conf.type_id =:= ?TASKTYPEID2 ->
        send_active_task(State, X, X1, TaskConf),
        List;
      true ->
        [X1 | List]
    end
  end,
  TaskList1 = lists:foldl(F, [], TaskList),
  main_task_lib:ref_task_navigate_list(State, TaskList1),
  {ok, State}.

%% 击杀怪物获取道具 任务信息
update_player_tasksort_collect_item(State, MonsterId) ->
  PlayerId = State#player_state.player_id,
  TaskList = player_task_dict:get_value_from_list_by_tasksortid(?TASKSORT_COLLECT_ITEM),
  F = fun(X, List) ->
    TaskConf = task_config:get(X#db_player_task.taskid_id),
    case lists:member(MonsterId, TaskConf#task_conf.monsterid_arr) of
      true ->
        %% 判断随机数
        RandNum = random:uniform(100),
        if
          RandNum =< TaskConf#task_conf.tool ->
            Num1 = X#db_player_task.nownum + 1,
            X1 =
              case TaskConf#task_conf.need_num =< Num1 of
                true ->

                  X#db_player_task{
                    isfinish = 1,
                    nownum = TaskConf#task_conf.need_num
                  };
                _ ->
                  X#db_player_task{
                    nownum = Num1
                  }
              end,
            %% 存库
            player_task_cache:update(PlayerId, X1),
            player_task_dict:update_task_list(X1),

            if
              TaskConf#task_conf.type_id =:= ?TASKTYPEID2 ->
                send_active_task(State, X, X1, TaskConf),
                List;
              true ->
                [X1 | List]
            end;
          true ->
            List
        end;
      _ ->
        List
    end
  end,
  TaskList1 = lists:foldl(F, [], TaskList),
  main_task_lib:ref_task_navigate_list(State, TaskList1).

%% ************************任务另外逻辑
%% 接取任务时检测
update_accpet__player_task(PlayerState, TaskId) ->
  TaskConf = task_config:get(TaskId),
  if
    TaskConf#task_conf.sort_id =:= ?TASKSORT_DIALOG ->
      #db_player_task{
        player_id = PlayerState#player_state.player_id,
        taskid_id = TaskConf#task_conf.id,
        nownum = 1,
        isfinish = 1
      };
    TaskConf#task_conf.sort_id =:= ?TASKSORT_UP_LV ->
      {NowNum, IsFinish} = is_ok_up_lv(PlayerState, TaskConf),
      #db_player_task{
        player_id = PlayerState#player_state.player_id,
        taskid_id = TaskConf#task_conf.id,
        nownum = NowNum,
        isfinish = IsFinish
      };
    TaskConf#task_conf.sort_id =:= ?TASKSORT_HAVE_ITEM ->
      {NowNum, IsFinish} = is_ok_have_item(TaskConf),
      #db_player_task{
        player_id = PlayerState#player_state.player_id,
        taskid_id = TaskConf#task_conf.id,
        nownum = NowNum,
        isfinish = IsFinish
      };
    true ->
      #db_player_task{
        player_id = PlayerState#player_state.player_id,
        taskid_id = TaskConf#task_conf.id,
        nownum = 0,
        isfinish = 0
      }
  end.

%% 判断升级信息
is_ok_up_lv(PlayerState, TaskConf) ->
  Base = PlayerState#player_state.db_player_base,
  case Base#db_player_base.lv >= TaskConf#task_conf.need_num of
    true ->
      {Base#db_player_base.lv, 1};
    _ ->
      {Base#db_player_base.lv, 0}
  end.

%% 判断物品获取
is_ok_have_item(TaskConf) ->
  Num1 = goods_lib:get_goods_num(TaskConf#task_conf.tool),
  case TaskConf#task_conf.need_num =< Num1 of
    true ->
      {Num1, 1};
    _ ->
      {Num1, 0}
  end.

%% 发送日常活跃任务信息纪录
send_active_task(PlayerState, OldTaskInfo, NewTaskInfo, TaskConf) ->
  ?INFO("sss ~p  ~p", [OldTaskInfo, NewTaskInfo]),
  case NewTaskInfo#db_player_task.isfinish =:= 1 of
    true ->
      Data =
        case TaskConf#task_conf.need_num =:= 1 of
          true ->
            #proto_navigate_task_info{
              task_id = TaskConf#task_conf.id,
              state = 10
            };
          _ ->
            #proto_navigate_task_info{
              task_id = TaskConf#task_conf.id,
              state = 2
            }
        end,
      net_send:send_to_client(PlayerState#player_state.socket, 26008, #rep_record_task{record_task_info = Data}),
      %% 刷新活跃任务领取红点
      button_tips_lib:ref_button_tips(PlayerState, ?BTN_DAILY_TARGET);
    _ ->
      case OldTaskInfo#db_player_task.nownum =:= 0 of
        true ->
          Data = #proto_navigate_task_info{
            task_id = TaskConf#task_conf.id,
            state = 1
          },
          net_send:send_to_client(PlayerState#player_state.socket, 26008, #rep_record_task{record_task_info = Data});
        _ ->
          skip
      end
  end.