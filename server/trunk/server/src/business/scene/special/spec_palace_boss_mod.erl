-module(spec_palace_boss_mod).
-author("tim").

-behaviour(gen_server).

-include("common.hrl").
-include("record.hrl").
-include("proto.hrl").

%% gen_server callbacks
-export([init/1, handle_call/3, handle_cast/2, handle_info/2, terminate/2, code_change/3]).
-export([
  init_scene/2,
  terminate_scene/1,
  add_num/2,
  push_boss_info/1,
  send_to_players/1,
  req_boss_info/1,
  req_boss_info2/2
]).
-define(SERVER, ?MODULE).

-record(state, {
  kill_boss = [],   %% 击杀boos数量
  left_time = []   %% 剩余时间
}).
-define(PALACE_BOSS_TIME, 5).
%% API
-export([
  start_link/0
]).

start_link() ->
  gen_server:start_link({local, ?SERVER}, ?MODULE, [], []).

init([]) ->
%%   erlang:register('palace_boss_serv', self()),
  erlang:send_after(?PALACE_BOSS_TIME*1000, self(), {loop}),
  {ok, #state{}}.

handle_call(_Request, _From, State) ->
  {reply, ok, State}.

handle_cast({init_scene, Args}, State) ->
  {SceneId, EndTime}= Args,
  #state{left_time = LeftTimeList}= State,
  NewLeftTimeList = lists:keystore(SceneId, 1, LeftTimeList, {SceneId, EndTime}),
  {noreply, State#state{left_time = NewLeftTimeList}};
handle_cast({terminate_scene, SceneId}, State) ->
  #state{left_time = LeftTimeList, kill_boss = KillBossList}= State,
  NewKillBoss = [{{BossId, Sid}, Num} || {{BossId, Sid}, Num} <- KillBossList, Sid =/= SceneId],
  NewLeftTime = [{Sid2, EndTime} || {Sid2, EndTime} <- LeftTimeList, Sid2 =/= SceneId],
  {noreply, State#state{kill_boss = NewKillBoss, left_time = NewLeftTime}};
handle_cast({add_num, Args}, State) ->
  #state{kill_boss = KillBossList}= State,
  {SceneId, BossId} = Args,
  NewKillBossList =
    case lists:keyfind({BossId, SceneId}, 1, KillBossList) of
      {_, Num} ->
        lists:keyreplace({BossId, SceneId}, 1, KillBossList, {{BossId,SceneId}, Num+1});
      false ->
        lists:keystore({BossId, SceneId}, 1, KillBossList, {{BossId, SceneId}, 1})
    end,
  {noreply, State#state{kill_boss = NewKillBossList}};
handle_cast({req_boss_info, Pid}, State) ->
%%   ?ERR("req boss info : ~p~n", [Pid]),
  req_boss_info2(Pid, State),
  {noreply, State};
handle_cast(_Request, State) ->
  {noreply, State}.

handle_info({loop}, State) ->
  erlang:send_after(?PALACE_BOSS_TIME*1000, self(), {loop}),
  push_boss_info(State),
  {noreply, State};
handle_info(_Info, State) ->
  {noreply, State}.

terminate(_Reason, _State) ->
  ok.

code_change(_OldVsn, State, _Extra) ->
  {ok, State}.

%%=================
%%    api
%%=================
%% 初始化记录
init_scene(SceneId, EndTime) ->
  gen_server:cast(?MODULE, {init_scene, {SceneId, EndTime}}),
  ok.

%% 清除数量
terminate_scene(SceneId) ->
  gen_server:cast(?MODULE, {terminate_scene, SceneId}),
  ok.

%% 加数量
add_num(SceneId, BossId) ->
  gen_server:cast(?MODULE,  {add_num, {SceneId, BossId}}),
  ok.



%% 推送消息
push_boss_info(State) ->
  #state{kill_boss=KillBossList, left_time=LeftTimeList} = State,
  KillBossBin = [#proto_palace_boss_num{scene_id=SceneId, boss_id=BossId, num=Num} || {{BossId, SceneId}, Num} <-
    KillBossList],
  LeftTimeBin = [#proto_palace_scene{scene_id=SceneId, time=EndTime} || {SceneId, EndTime} <- LeftTimeList],
  Bin = #rep_palace_boss_result{kill_boss = KillBossBin, left_time = LeftTimeBin},
  send_to_players(Bin),
  ok.


%% 推送消息
send_to_players(Bin) ->
  Func = fun(SceneId) ->
    SceneSign = ?WORLD_ACTIVE_SIGN,
    Key = {SceneId, SceneSign},
    case ets:lookup(?ETS_SCENE_MAPS, Key) of
      [#ets_scene_maps{pid_list = PidLineList}] ->
        lists:foreach(fun(#pid_line{pid = Pid}) ->
          scene_send_lib:send_scene(Pid, 11061, Bin)
        end, PidLineList),
        ok;
      _ ->
        skip
    end
  end,
  [Func(SceneId) || SceneId <- [?SCENE_PALACE_1, ?SCENE_PALACE_2, ?SCENE_PALACE_3, ?SCENE_PALACE_4]],
  ok.



req_boss_info(Pid) ->
%%   ?ERR("req boss info : ~p~n", [Pid]),
  gen_server:cast(?MODULE, {req_boss_info, Pid}).


req_boss_info2(Pid, State) ->
  #state{kill_boss=KillBossList, left_time=LeftTimeList} = State,
  KillBossBin = [#proto_palace_boss_num{scene_id=SceneId, boss_id=BossId, num=Num} || {{BossId, SceneId}, Num} <-
    KillBossList],
  Now = util_date:unixtime(),
  LeftTimeBin = [#proto_palace_scene{scene_id=SceneId, time=max(EndTime-Now, 0)} || {SceneId, EndTime} <- LeftTimeList],
  Bin = #rep_palace_boss_result{kill_boss = KillBossBin, left_time = LeftTimeBin},
  net_send:send_to_client(Pid, 11061, Bin).


