-module(player_timer).
-author("tim").

-behaviour(gen_server).
-include("common.hrl").
%% API
-export([start_link/0]).

%% gen_server callbacks
-export([init/1,
  handle_call/3,
  handle_cast/2,
  handle_info/2,
  terminate/2,
  code_change/3]).

-export([
  register/1
]).



-define(SERVER, ?MODULE).

-define(FRAME_TIME, 1000).
-define(ETS_PLAYER_TIME, ets_player_time).
-record(state, {}).

-record(ets_player_timer, {
  player_id,
  player_pid,
  event,
  frame_time,
  do_time
}).

start_link() ->
  gen_server:start_link({local, ?SERVER}, ?MODULE, [], []).


init([]) ->
  ets:new(?ETS_PLAYER_TIME, [{keypos, #ets_player_timer.player_id}, named_table, public, bag, {read_concurrency,
    true}, {write_concurrency, true}]),
  erlang:send_after(?FRAME_TIME, self(), {loop}),
  {ok, #state{}}.


handle_call(_Request, _From, State) ->
  {reply, ok, State}.

handle_cast({register, Record}, State) ->
  ets:insert(?ETS_PLAYER_TIME, Record),
  {noreply, State};
handle_cast(_Request, State) ->
  {noreply, State}.

handle_info({loop}, State) ->
  erlang:send_after(?FRAME_TIME, self(), {loop}),
  do_timer(),
  {noreply, State};
handle_info(_Info, State) ->
  {noreply, State}.

terminate(_Reason, _State) ->
  ok.

code_change(_OldVsn, State, _Extra) ->
  {ok, State}.


%%================
%%  internal api
%%================
register({PlayerId, PlayerPid, Event, AddTime}) ->
  Record = #ets_player_timer{player_id = PlayerId, player_pid = PlayerPid, event = Event, frame_time=AddTime, do_time =
  0},
  gen_server:cast(?MODULE, {register, Record}),
  ok.



do_timer() ->
  try
    handle_timer(),
    ok
  catch Type:Err  ->
      ?ERR("do timer error:~p, ~p ~n", [Type, Err])
  end,

  ok.


handle_timer() ->
  Now = util_date:unixtime(),
  List = ets:tab2list(?ETS_PLAYER_TIME),
  lists:foreach(fun(X) ->
    #ets_player_timer{player_pid = Pid, frame_time = AddTime, do_time = DoTime} = X,
    case DoTime + AddTime =< Now of
      true ->
        gen_server:cast(Pid, {on_timer}),
        do;
      false ->
        next
    end
  end, List),
  ok.
