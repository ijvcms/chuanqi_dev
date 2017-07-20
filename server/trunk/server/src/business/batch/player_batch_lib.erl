%%%-------------------------------------------------------------------
%%% @author qhb
%%% @copyright (C) 2016, <COMPANY>
%%% @doc
%%%	vip返还批处理
%%% @end
%%% Created : 17. 八月 2016 上午9:18
%%%-------------------------------------------------------------------
-module(player_batch_lib).
-include("common.hrl").
-include("record.hrl").
-include("cache.hrl").
-include("config.hrl").

-define(PAGE_SIZE, 10).
-define(TIMER_FRAME, 3000).
-define(BATCH_TASK_VIP_RETURN, 4).	%%vip返还,4
-define(BATCH_TASK_CHANGYANG_BUG, 3).	%%重阳物品有误，补偿
-define(BATCH_TASKS, [?BATCH_TASK_VIP_RETURN]).
-record(state, {type, tasks, step, page_no, pages}).

%% API
-export([
	init/0,
	start_task/0
]).

%% GEN API
-export([
	start_task_local/1,
	do_task_local/1
]).

%%初始化
init() ->
	ok.

%%启动任务
start_task() ->
	io:format("player batch task delay 10s~n"),
	gen_server2:apply_after(10000, misc:whereis_name({local, player_batch_mod}), {?MODULE, start_task_local, []}).
	%%ok.
start_task_local(State) ->
	case State#state.type =/= undefined of
		true ->
			?WARNING("player batch task(~p) is running",[State#state.type]);
		false ->
			Tasks = ?BATCH_TASKS,

			Total = count(lists:nth(1, Tasks)),
			Pages = util_math:ceil(Total / ?PAGE_SIZE),
			gen_server2:apply_after(?TIMER_FRAME, self(), {?MODULE, do_task_local, []}),
			io:format("player batch started~n"),
			{ok, State#state{type = batch_player, tasks = Tasks, step = 1, page_no = 1, pages = Pages}}
	end.

%%分页处理任务
do_task_local(State) ->
	#state{type = TaskType, tasks = Tasks, step = Step, page_no = PageNo, pages = Pages} = State,
	Task = lists:nth(Step, Tasks),
	case PageNo rem 100 =:= 0 of
		true -> io:format("task ~p: ~p/~p~n",[Task, PageNo, Pages]);
		false -> skip
	end,
	case PageNo =< Pages of
		true->
			loop_db(Task, PageNo),
			gen_server2:apply_after(?TIMER_FRAME, self(), {?MODULE, do_task_local, []}),
			{ok, State#state{page_no = PageNo + 1}};
		false ->
			io:format("task ~p complete: ~p~n",[Task, Pages]),
			NewStep = Step + 1,
			case NewStep =< length(Tasks) of
				true ->
					do_task_complete(Task),
					Task = lists:nth(NewStep, Tasks),

					Total = count(Task),
					NewPages = util_math:ceil(Total / ?PAGE_SIZE),
					gen_server2:apply_after(?TIMER_FRAME, self(), {?MODULE, do_task_local, []}),
					{ok, State#state{step = NewStep, page_no = 1, pages = NewPages}};
				false ->
					do_task_complete(Task),
					?WARNING("complete ~p",[TaskType]),
					{ok, State#state{type = undefined, step = undefined, page_no = undefined, pages = undefiend}}
			end
	end.

%%处理一页的任务
loop_db(?BATCH_TASK_CHANGYANG_BUG, PageNo) ->
	Task = ?BATCH_TASK_CHANGYANG_BUG,
	PlayerIdList = select_rows(Task, PageNo),
	NewPlayerIdList = filter_player_id(PlayerIdList, Task),
	PlayerIdBinList = [util_data:to_binary(R) || R<-NewPlayerIdList],

	ActiveList = db_mysql:select_all(?DB_POOL, player_operate_record, util_tuple:fields(db_player_operate_record),
		[{active_id, ">=", 3472}, {active_id, "<=", 3509}, {finish_limit_value, ">", 0}, {player_id, "in", PlayerIdBinList}]),
	case length(ActiveList) > 0 of
		true ->
		ActiveList2 = [list_to_tuple([db_player_operate_record | X]) || X <- ActiveList],
		ActiveDict =
			lists:foldl(fun(E, AccDict) ->
				#db_player_operate_record{player_id = PlayerId} = E,
				case dict:is_key(PlayerId, AccDict) of
					true ->
						List = dict:fetch(PlayerId, AccDict),
						dict:store(PlayerId, [E | List], AccDict);
					false ->
						dict:store(PlayerId, [E], AccDict)
				end
			end, dict:new(), ActiveList2),

		F = fun(PlayerId, List, Acc1) ->
			GoodsList =
				lists:foldl(fun(#db_player_operate_record{finish_limit_type = FinishType, finish_limit_value = Num}, Acc2) ->
					case FinishType of
						153 -> [{110099, 1, Num} | Acc2];
						154 -> [{110260, 1, Num} | Acc2];
						_ -> Acc2
					end
				end, [], List),
			Sender = xmerl_ucs:to_utf8("系统"),
			Title = xmerl_ucs:to_utf8("重阳节礼包补偿"),
			Content = xmerl_ucs:to_utf8("尊敬的玩家，因重阳节中级礼包和高级礼包内容与描述不符，现已修复，同时补偿奖励已同此邮件补偿给您，请注意查收。"),
			mail_lib:send_mail_to_player(PlayerId, Sender, Title, Content, GoodsList),
			%%?WARNING("do player id, ~p",[PlayerId]),
			save_status(PlayerId, Task),
			Acc1
		end,
		dict:fold(F, [], ActiveDict);
	false ->
		skip
	end,
	ok;
loop_db(?BATCH_TASK_VIP_RETURN, PageNo) ->
	Task = ?BATCH_TASK_VIP_RETURN,
	List = select_rows(Task, PageNo),
	PlayerIdList = [R#db_player_base.player_id || R<-List],
	NewPlayerIdList = filter_player_id(PlayerIdList, Task),

	lists:foreach(fun(E) ->
		#db_player_base{player_id = PlayerId, vip = Vip} = E,
		case lists:member(PlayerId, NewPlayerIdList) of
			true ->
				#vip_return_conf{goods = Goods} = vip_return_config:get(Vip),
				Sender = xmerl_ucs:to_utf8("系统"),
				Title = xmerl_ucs:to_utf8("VIP奖励调整补偿"),
				Content = xmerl_ucs:to_utf8("因VIP3奖励内容调整，故将补偿已领取过VIP3奖励的玩家金刚石1颗，补偿物品已同本邮件一并发送，请注意查收。"),
				mail_lib:send_mail_to_player(PlayerId, Sender, Title, Content, Goods),
				%%?WARNING("do player id, ~p",[PlayerId]),
				save_status(PlayerId, Task),
				ok;
			false ->
				%%?WARNING("ignore player id, ~p",[PlayerId]),
				skip
		end
	end, List),
	ok.

%%统计任务的数量
count(?BATCH_TASK_CHANGYANG_BUG) ->
	WhereList = [{register_time, "<" ,1476072000}],%%register_time 2016-10-10 12:00:00
	db_mysql:select_count(?DB_POOL, player_base, WhereList);
count(?BATCH_TASK_VIP_RETURN) ->
	WhereList = [{vip, ">", 2}, {register_time, "<" ,1476349200}],%%register_time 2016-10-13 17:00:00
	db_mysql:select_count(?DB_POOL, player_base, WhereList).

%%获取一页的数据
select_rows(?BATCH_TASK_CHANGYANG_BUG, PageNo) ->
	Offset = (PageNo - 1) * ?PAGE_SIZE,
	WhereList = [{register_time, "<" ,1476072000}],
	case db_mysql:select_all(?DB_POOL, player_base, [player_id], WhereList, [], [Offset, ?PAGE_SIZE]) of
		[] ->
			[];
		List ->
			lists:flatten(List)
	end;
select_rows(?BATCH_TASK_VIP_RETURN, PageNo) ->
	Offset = (PageNo - 1) * ?PAGE_SIZE,
	WhereList = [{vip, ">", 2}, {register_time, "<" ,1476349200}],
	case db_mysql:select_all(?DB_POOL, player_base, util_tuple:fields(db_player_base), WhereList, [], [Offset, ?PAGE_SIZE]) of
		[] ->
			[];
		List ->
			[list_to_tuple([db_player_base | X]) || X <- List]
	end.

%%单个任务执行完后的操作
do_task_complete(_) ->
	ok.

%%过滤已经处理过的任务
filter_player_id(PlayerIdList, TaskId) ->
	PlayerIdBinList = [util_data:to_binary(R) || R<-PlayerIdList],
	List = db_mysql:select_all(?DB_POOL, player_batch_record, [player_id], [{task_id, TaskId}, {player_id, "in", PlayerIdBinList}]),
	List1 = lists:flatten(List),
	lists:subtract(PlayerIdList, List1).

%%任务处理完成后保存状态
save_status(PlayerId, TaskId) ->
	db_mysql:insert(?DB_POOL, player_batch_record, [{player_id, PlayerId}, {task_id, TaskId}, {add_time, util_date:unixtime()}]),
	ok.
