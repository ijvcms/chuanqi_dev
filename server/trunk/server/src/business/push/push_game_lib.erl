%%%-------------------------------------------------------------------
%%% @author qhb
%%% @copyright (C) 2016, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 18. 七月 2016 下午2:30{ok
%%%-------------------------------------------------------------------
-module(push_game_lib).
-include("common.hrl").
-include("config.hrl").
-define(PAGE_SIZE, 50).
-define(TIMER_FRAME, 20).
-define(THREAD_NUM, 10).
-define(TIMER_FRAME_TASK_MONITER, 60000).
-define(PUSH_TYPE_OPENID, 0).
-define(PUSH_TYPE_ALL, 1).
-define(PUSH_TYPE_LOSS, 2).
-define(PUSH_TYPE_ACTIVE, 3).
-define(PUSH_TYPE_VIP, 4).
-define(PUSH_TYPE_PAY, 5).
-define(PUSH_TYPE_BOSS, 6).
-define(ETS_PUSH_GAME, ets_push_game).

-record(state, {task, step, step_pages, pages, page_no, process_tasks, idle_pools}).
-record(push_task, {id, content, type, args}).

%% API
-export([
	init/0,
	add_push_task/2,
	on_timer/1
]).

%% GEN API
-export([
	after_work_local/2,
	do_work_thread/4,
	tell_work_status_local/4
]).

init() ->
	ets:new(?ETS_PUSH_GAME, [{keypos, #push_task.id}, named_table, public, set]),
	gen_server2:apply_after(?TIMER_FRAME_TASK_MONITER, self(), {?MODULE, on_timer, []}),
	ok.

add_push_task(monster_refresh, [SceneId, MonsterId]) ->
	TabKey = {SceneId, MonsterId},
	#monster_conf{name = Name} = monster_config:get(MonsterId),
	ServerNo = config:get_server_no(),
	Content = xmerl_ucs:to_utf8("游戏服") ++ integer_to_list(ServerNo)
		++ xmerl_ucs:to_utf8("的怪物\"") ++ Name ++ xmerl_ucs:to_utf8("\"马上要刷新了!"),
	Ets = #push_task{id = TabKey, content = Content, type = ?PUSH_TYPE_BOSS, args = [SceneId, MonsterId]},
	ets:insert(?ETS_PUSH_GAME, Ets),
	ok.


on_timer(State) ->
	case State#state.task =/= undefined of
		true ->
			skip;
		false ->
			gen_server2:apply_after(?TIMER_FRAME_TASK_MONITER, self(), {?MODULE, on_timer, []}),
			Task = find_task(),
			case Task =/= null of
				true ->
					lists:foreach(fun(P) -> after_work(P) end, lists:seq(1, ?THREAD_NUM)),
					StepPages = count_task_pages(Task),
					io:format("StepPages ~p~n",[StepPages]),
					Pages = lists:nth(1, StepPages),
					update_task_pages(Task#push_task.id, lists:sum(StepPages)),
					{ok, State#state{task = Task, step = 1, step_pages = StepPages, pages= Pages, page_no = 1,
						process_tasks = [], idle_pools = lists:seq(1, ?THREAD_NUM)}};
				false ->
					{ok, State}
			end
	end.

%%使用某个线程处理任务
after_work(PoolId) ->
	gen_server2:apply_after(?TIMER_FRAME, self(), {?MODULE, after_work_local, [PoolId]}).
after_work_local(State, PoolId) ->
	#state{task = Task, step = Step, step_pages = StepPages, pages = Pages, page_no = PageNo,
		process_tasks = ProcessTasks, idle_pools = IdlePools} = State,
	case PageNo =< Pages of
		true ->
			{StepPagesPre, _} = lists:split(Step - 1, StepPages),
			update_task_page(Task#push_task.id, PageNo + lists:sum(StepPagesPre)),
			case lists:member(PoolId, IdlePools) of
				true ->
					dp_lib:cast(dp_push, PoolId, {?MODULE, do_work_thread, [PoolId, Task, Step, PageNo]}),
					tell_work_status_local(State, PoolId, PageNo, 0);
				false ->
					?WARNING("pool busy ~p",[PoolId]),
					{ok, State}
			end;
		false ->
			NewStep = Step + 1,
			case NewStep =< get_push_plats() of
				true ->
					after_work(PoolId),
					NewPages = lists:nth(NewStep, StepPages),
					{ok, State#state{step = NewStep, pages = NewPages, page_no = 1}};
				false ->
					io:format("pool end ~p ~n",[PoolId]),
					case Task =/= undefined andalso length(ProcessTasks) =:= 0 of
						true ->
							io:format("task end ~p ~p ~n",[NewStep, Task]),
							gen_server2:apply_after(?TIMER_FRAME_TASK_MONITER, self(), {?MODULE, on_timer, []}),
							update_task_state(Task#push_task.id, 3),
							{ok, State#state{task = undefined}};
						false ->
							{ok, State}
					end

			end
	end.

%%进程工作逻辑
do_work_thread(PoolId, Task, Step, PageNo) ->
	%%?WARNING("work pool ~p, page:~p",[PoolId, PageNo]),
	do_work_thread_main(Task, Step, PageNo),
	tell_work_status(PoolId, PageNo, 1).
do_work_thread_main(Task, Step, PageNo) ->
	{AppId, Platform} = get_push_platform(Step),
	case Task#push_task.type of
		?PUSH_TYPE_OPENID ->
			case Step =:= 1 of
				true ->
					io:format("send single ~n"),
					push_tool:push_notifiction(AppId, Platform, Task#push_task.args, xmerl_ucs:from_utf8(Task#push_task.content));
				false ->
					skip
			end;
		?PUSH_TYPE_ALL ->
			case Step =:= 1 of
				true ->
					io:format("send all ~n"),
					push_tool:push_notifiction(AppId, Platform, [0], xmerl_ucs:from_utf8(Task#push_task.content));
				false ->
					skip
			end;
		_ ->
			List = select_rows(Task#push_task.type, Step, Task#push_task.args, PageNo),
			OpenIdList = lists:flatten(List),
			%%?WARNING("work list ~p,~p",[PageNo, OpenIdList]),
			push_tool:push_notifiction(AppId, Platform, OpenIdList, xmerl_ucs:from_utf8(Task#push_task.content))
	end.

tell_work_status(PoolId, PageNo, Status) ->
	gen_server2:apply_async(misc:whereis_name({local, push_game_mod}), {?MODULE, tell_work_status_local, [PoolId, PageNo, Status]}).
tell_work_status_local(State, PoolId, PageNo, Status) ->
	#state{process_tasks = ProcessTasks, idle_pools = IdlePools} = State,
	case Status =:=0 of
		true ->
			NewIdlePools = lists:delete(PoolId, IdlePools),
			NewProcessTasks = lists:append(ProcessTasks, [PageNo]),
			{ok, State#state{page_no = PageNo + 1, process_tasks = NewProcessTasks, idle_pools = NewIdlePools}};
		false ->
			NewIdlePools = lists:append(IdlePools, [PoolId]),
			NewProcessTasks = lists:delete(PageNo, ProcessTasks),
			after_work(PoolId),
			{ok, State#state{process_tasks = NewProcessTasks, idle_pools = NewIdlePools}}
	end.


%%指定用户
count(?PUSH_TYPE_OPENID, _, _) ->
	1;
%%全部
count(?PUSH_TYPE_ALL, _, _) ->
	1;
%%流失条件
count(?PUSH_TYPE_LOSS, PushPlat, [Time]) ->
	SqlTpl = <<"select count(*) from my_account where ~s and login_time<~w">>,
	ChannelId = get_push_channel(PushPlat),
	ChannelParam =
		case ChannelId =/= 0 of
			true -> lists:concat(["platform=", ChannelId]);
			false -> <<"platform between 2000 and 2999">>
		end,
	Sql = io_lib:format(SqlTpl, [ChannelParam, Time]),
	db_mysql:select_one(pool, Sql);
%%boss刷新
count(?PUSH_TYPE_BOSS, PushPlat, [SceneId, MonsterId]) ->
	SqlTpl = <<"select count(*) from player_monster_follow where ~s and scene_id=~w and monster_id=~w">>,
	ChannelId = get_push_channel(PushPlat),
	ChannelParam =
		case ChannelId =/= 0 of
			true -> lists:concat(["channel=", ChannelId]);
			false -> <<"channel between 2000 and 2999">>
		end,
	Sql = io_lib:format(SqlTpl, [ChannelParam, SceneId, MonsterId]),
	db_mysql:select_one(?DB_POOL, Sql).


%%流失条件：至今已经连续	X天以上没有使用产品的用户
select_rows(?PUSH_TYPE_LOSS, PushPlat, [Time], PageNo) ->
	SqlTpl = <<"select md5_open_id from my_account where ~s and login_time<~w limit ~w,~w">>,
	ChannelId = get_push_channel(PushPlat),
	ChannelParam =
		case ChannelId =/= 0 of
			true -> lists:concat(["platform=", ChannelId]);
			false -> <<"platform between 2000 and 2999">>
		end,
	Sql = io_lib:format(SqlTpl, [ChannelParam, Time, (PageNo - 1) * ?PAGE_SIZE, ?PAGE_SIZE]),
	db_mysql:select_all(pool, Sql);
%%boss刷新：关注的用户
select_rows(?PUSH_TYPE_BOSS, PushPlat, [SceneId, MonsterId], PageNo) ->
	SqlTpl = <<"select open_id from player_monster_follow where ~s and scene_id=~w and monster_id=~w group by open_id limit ~w,~w">>,
	ChannelId = get_push_channel(PushPlat),
	ChannelParam =
		case ChannelId =/= 0 of
			true -> lists:concat(["channel=", ChannelId]);
			false -> <<"channel between 2000 and 2999">>
		end,
	Sql = io_lib:format(SqlTpl, [ChannelParam, SceneId, MonsterId, (PageNo - 1) * ?PAGE_SIZE, ?PAGE_SIZE]),
	db_mysql:select_all(?DB_POOL, Sql).



get_push_plats() -> 1.

get_push_channel(1) -> 3888;
get_push_channel(2) -> 1888;
get_push_channel(_) -> 0.

get_push_platform(1) -> {1, <<"ios">>};
get_push_platform(2) -> {2, <<"ios">>};
get_push_platform(_) -> {1, <<"android">>}.

find_task() ->
	case ets:first(ets_push_game) of
		'$end_of_table' -> null;
		Key ->
			case ets:lookup(ets_push_game, Key) of
				[R] -> R;
				_ -> null
			end
	end.

count_task_pages(Task) ->
	PushPlats = get_push_plats(),
	[util_math:ceil(count(Task#push_task.type, PushPlat, Task#push_task.args) / ?PAGE_SIZE) || PushPlat <- lists:seq(1, PushPlats)].

update_task_pages(_TaskId, _Pages) ->
	%%ets:update_element(ets_push_game, TaskId, {1, Pages}).
	ok.

update_task_page(_TaskId, _PageNo) ->
	%%ets:update_element(ets_push_game, TaskId, {2, PageNo}).
	ok.

update_task_state(TaskId, State) ->
	case State =/=3 of
		true ->
			%%ets:update_element(ets_push_game, TaskId, {3, State}),
			ok;
		false ->
			ets:delete(ets_push_game, TaskId)
	end.