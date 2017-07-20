-module(spec_real_boss_lib).
-author("tim").

%% API
-export([
  init_data/0,
  boss_die/2,
  check_real_boss_dead/1
]).

-define(DIC_ACC_STATE, 'dic_acc_state').
-define(DIC_REAL_BOSS_ACC, 'dic_real_boss_acc').
-define(ETS_REAL_BOSS, ets_real_boss).
-record(ets_real_boss, {
  scene_id,
  unreal_boss,
  boss_id,
  num,
  create_time,
  dead_time
}).

init_data() ->
  ets:new(?ETS_REAL_BOSS, [{keypos, #ets_real_boss.scene_id}, named_table, public, set, {read_concurrency, true},
    {write_conrurrency, true}]),
  ok.

%% 假boss死亡触发
boss_die(SceneId, MonsterId) ->
  %% todo check monsterId is boss ?
  set_acc_state(1),
  Now = util_date:unixtime(),
  Record = #ets_real_boss{scene_id = SceneId, unreal_boss = MonsterId, num=0, dead_time=Now + 1800 - 1},
  ets:insert(?ETS_REAL_BOSS, Record),
  ok.

%% @doc 检查real boss 到时没有,on_timer调用
check_real_boss_dead(SceneId) ->
  case get_acc_state() of
    2 ->
      case ets:lookup(?ETS_REAL_BOSS, SceneId) of
        #ets_real_boss{dead_time = DeadTime} ->
          case util_date:unixtime() >= DeadTime of
            true ->
              del_real_boss();
            false -> next
          end;
        _ -> next
      end;
    _ -> next
  end,
  ok.

%% @doc real boss 死的时候清除记录
do_with_real_boss_dead(MonsterId) ->
  BossId = 10001,
  case MonsterId == BossId of
    true -> ok;
    false -> next
  end.



%% 小怪死亡触发统计
accumulate_monster_num(SceneId) ->
  AccState = get_acc_state(),
  case AccState of
    1 ->
      real_boss_create(SceneId);
    _ -> next
  end,
  ok.

%% boss 刷新
real_boss_create(SceneId) ->
  Rate = 500,
  Max = 100,
  BossId = 10001,
  Rand = util_rand:rand(1, 10000),
  case Rand =< Rate of
    true ->
      create_real_boss(SceneId, BossId),
      ok;
    false ->
      N = get_acc(SceneId),
      case N >= Max of
        true ->
          create_real_boss(SceneId, BossId);
        false ->
          ets:update_element(?ETS_REAL_BOSS, SceneId, {#ets_real_boss.num, N+1})
      end
  end,
  ok.


%% create real boss
create_real_boss(SceneId, BossId) ->
  set_acc_state(2),
  %% todo create_boos
  Now = util_date:unixtime(),
  ets:update_element(?ETS_REAL_BOSS, SceneId, [
    {#ets_real_boss.boss_id, BossId},
    {#ets_real_boss.num, 0},
    {#ets_real_boss.create_time, Now}]),
  ok.


%% del real boss
del_real_boss() ->
  set_acc_state(0),
  %% todo del boss
  ok.

get_acc(SceneId) ->
  case ets:lookup(?ETS_REAL_BOSS, SceneId) of
    #ets_real_boss{num=Num} -> Num;
    _ -> 0
  end.
%% acc_add() ->
%%   case get(?DIC_REAL_BOSS_ACC) of
%%     undefined ->
%%       set_acc(0),
%%       0;
%%     N -> N
%%   end.
%%
%% set_acc(N) ->
%%   put(?DIC_REAL_BOSS_ACC, N).
%%
%% get_acc() ->
%%   case get(?DIC_REAL_BOSS_ACC) of
%%     undefined -> 0;
%%     N -> N
%%   end.


get_acc_state() ->
  case get(?DIC_ACC_STATE) of
    undefined ->
      set_acc_state(0),
      0;
    N -> N
  end.

set_acc_state(S) ->
  put(?DIC_ACC_STATE, S).


get_real_boss_info_list() ->
  List = ets:tab2list(?ETS_REAL_BOSS),
  %% todo pack and send to client
  ok.
