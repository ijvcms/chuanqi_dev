%%%-------------------------------------------------------------------
%%% @author qhb
%%% @copyright (C) 2016, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 13. 六月 2016 下午4:13
%%%-------------------------------------------------------------------
-module(merge_lib).
-include("common.hrl").
-include("cache.hrl").
-include("db_record.hrl").
-include("record.hrl").

-define(PAGE_SIZE, 50).
-define(TIMER_FRAME, 2).
-define(THREAD_NUM, 10).
-define(ETS_MERGE_PLAYER, ets_merge_player).
-define(ETS_MERGE_PLAYER_NAME, ets_merge_playername).
-define(ETS_MERGE_GUILD, ets_merge_guild).
-define(ETS_MERGE_GUILD_NAME, ets_merge_guildname).
-define(ETS_MERGE_MONEY, ets_merge_money).

%% API
-export([
	init/0,
	start_task/1,

	start_work/1,
	start/0
]).


%% GEN API
-export([
	start_task_local/2,
	do_task_local/1,

	start_work_local/2,
	after_work_local/2,
	after_work_local/3,
	tell_work_status_local/4,

	start_local/1,
	next_local/1
]).

init() ->
	ets:new(?ETS_MERGE_PLAYER, [named_table, public, set]),
	ets:new(?ETS_MERGE_PLAYER_NAME, [named_table, public, set]),
	ets:new(?ETS_MERGE_GUILD, [named_table, public, set]),
	ets:new(?ETS_MERGE_GUILD_NAME, [named_table, public, set]),
	ets:new(?ETS_MERGE_MONEY, [named_table, public, set]),
	ok.

%%开始顺序执行任务
start_task(ServerId) ->
	gen_server2:apply_async(misc:whereis_name({local, merge_mod}), {?MODULE, start_task_local, [ServerId]}).
start_task_local(State, ServerId) ->
	case State#merge_state.type =/= undefined of
		true ->
			?WARNING("merge task(~p) is running",[State#merge_state.type]);
		false ->
			Tasks = [R || R <-merge_cfg:get_list(), merge_cfg:get_keys(R) =/= null],
			set_now(),
			ready_jade(ServerId),

			Total = count(db_player_base, ServerId),
			Pages = util_math:ceil(Total / ?PAGE_SIZE),
			gen_server2:apply_after(?TIMER_FRAME, self(), {?MODULE, do_task_local, []}),
			io:format("merge started~n"),
			{ok, State#merge_state{type = ServerId, tasks = Tasks, step = 1, page_no = 1, pages = Pages}}
	end.

do_task_local(State) ->
	#merge_state{type = ServerId, tasks = Tasks, step = Step, page_no = PageNo, pages = Pages} = State,
	RecName = lists:nth(Step, Tasks),
	case PageNo rem 100 =:= 0 of
		true -> io:format("task ~p: ~p/~p~n",[RecName, PageNo, Pages]);
		false -> skip
	end,
	case PageNo =< Pages of
		true->
			loop_db(RecName, PageNo, ServerId),
			gen_server2:apply_after(?TIMER_FRAME, self(), {?MODULE, do_task_local, []}),
			{ok, State#merge_state{page_no = PageNo + 1}};
		false ->
			NewStep = Step + 1,
			case NewStep =< length(Tasks) of
				true ->
					do_rec_complete(RecName),
					io:format("task ~p complete: ~p~n",[RecName, Pages]),
					NewRecName = lists:nth(NewStep, Tasks),
					
					Total = count(NewRecName, ServerId),
					NewPages = util_math:ceil(Total / ?PAGE_SIZE),
					gen_server2:apply_after(?TIMER_FRAME, self(), {?MODULE, do_task_local, []}),
					{ok, State#merge_state{step = NewStep, page_no = 1, pages = NewPages}};
				false ->
					do_rec_complete(RecName),
					io:format("task ~p complete ~p~n",[RecName, Pages]),
					?WARNING("complete ~p",[ServerId]),
					{ok, State#merge_state{type = undefined, step = undefined, page_no = undefined, pages = undefiend}}
			end
	end.

%%启动全部任务
start() ->
	ServerIds = merge_cfg:get_source_servers(),
	io:format("start task list ~p~n",[ServerIds]),
	gen_server2:apply_async(misc:whereis_name({local, merge_mod}), {?MODULE, start_local, []}).
start_local(State) ->
	ServerIds = merge_cfg:get_source_servers(),
	put(task_list, ServerIds),
	case ServerIds of
		[] ->
			io:format("task list empty ~n",[]);
		[_|_] ->
			next()
	end,
	{ok, State}.


%%开始下一个任务
next() ->
	gen_server2:apply_after(1000, misc:whereis_name({local, merge_mod}), {?MODULE, next_local, []}).
next_local(State) ->
	ServerIds = get(task_list),
	case ServerIds of
		[] ->
			io:format("end ~n",[]);
		[ServerId|LastServerIds] ->
			io:format("current task list ~p~n",[ServerIds]),
			put(task_list, LastServerIds),
			start_work(ServerId);
		_ ->
			skip
	end,
	{ok, State}.

%%开始多线程执行任务
start_work(ServerId) ->
	gen_server2:apply_async(misc:whereis_name({local, merge_mod}), {?MODULE, start_work_local, [ServerId]}).
start_work_local(State, ServerId) ->
	case State#merge_state.type =/= undefined of
		true ->
			?WARNING("merge task(~p) is running",[State#merge_state.type]);
		false ->
			Tasks = [R || R <-merge_cfg:get_list(), merge_cfg:get_keys(R) =/= null],
			set_now(),
			ready_jade(ServerId),

			after_work(1),
			io:format("merge started~n"),
			{ok, State#merge_state{type = ServerId, tasks = Tasks, single_tasks = [db_player_base, db_guild],
				process_tasks = [], idle_pools = lists:seq(1, ?THREAD_NUM)}}
	end.

%%使用某个线程处理任务
after_work(PoolId) ->
	gen_server2:apply_after(?TIMER_FRAME, self(), {?MODULE, after_work_local, [PoolId]}).
after_work_local(State, PoolId) ->
	#merge_state{type = ServerId, tasks = Tasks, process_tasks = ProcessTasks, single_tasks = SingleTasks} = State,
	case SingleTasks of
		[RecName|_] -> after_work_local(State, PoolId, RecName);
		_ ->
			case Tasks of
				[RecName|_] -> after_work_local(State, PoolId, RecName);
				[] ->
					io:format("pool end ~p ~n",[PoolId]),
					case length(ProcessTasks) + length(ProcessTasks) =:= 0 of
						true ->
							io:format("task end ~p ~n",[ServerId]),
							next(),
							{ok, State#merge_state{type = undefined}};
						false ->
							{ok, State}
					end
			end
	end.

after_work_local(State, PoolId, RecName) ->
	#merge_state{type = ServerId, idle_pools = IdlePools} = State,
	case lists:member(PoolId, IdlePools) of
		true ->
			spawn(fun() ->
				timer:sleep(1000),
				do_work_rec(ServerId, RecName),
				tell_work_status(PoolId, RecName, 1),
				ok
			end),
			tell_work_status_local(State, PoolId, RecName, 0);
		false ->
			?WARNING("pool busy ~p",[PoolId]),
			{ok, State}
	end.

%%处理任务
do_work_rec(ServerId, RecName) ->
	Total = count(RecName, ServerId),
	Pages = util_math:ceil(Total / ?PAGE_SIZE),
	lists:foreach(fun(PageNo) ->
		loop_db(RecName, PageNo, ServerId)
	end, lists:seq(1, Pages)),
	do_rec_complete(RecName),
	io:format("task ~p(~p)",[RecName, Total]),
	ok.

%%任务状态
tell_work_status(PoolId, RecName, Status) ->
	gen_server2:apply_async(misc:whereis_name({local, merge_mod}), {?MODULE, tell_work_status_local, [PoolId, RecName, Status]}).
tell_work_status_local(State, PoolId, RecName, Status) ->
	#merge_state{tasks = Tasks, single_tasks = SingleTasks, process_tasks = ProcessTasks, idle_pools = IdlePools} = State,
	case Status =:=0 of
		true ->
			NewTasks = lists:delete(RecName, Tasks),
			NewSingleTasks = case SingleTasks =/= undefined of
								 true -> lists:delete(RecName, SingleTasks);
								 false -> SingleTasks
							 end,
			NewIdlePools = lists:delete(PoolId, IdlePools),
			NewProcessTasks = lists:append(ProcessTasks, [RecName]),
			{ok, State#merge_state{tasks = NewTasks, single_tasks = NewSingleTasks, process_tasks = NewProcessTasks,
				idle_pools = NewIdlePools}};
		false ->
			NewIdlePools = lists:append(IdlePools, [PoolId]),
			NewProcessTasks = lists:delete(RecName, ProcessTasks),
			NewSingleTasks =
				case SingleTasks of
					[] ->
						lists:foreach(fun(P) -> after_work(P) end, lists:seq(1, ?THREAD_NUM)),
						undefined;
					_ ->
						after_work(PoolId),
						SingleTasks
				end,
			io:format(" tasks left:~p,process:~p ~n",[length(Tasks), length(NewProcessTasks)]),
			{ok, State#merge_state{single_tasks = NewSingleTasks, process_tasks = NewProcessTasks, idle_pools = NewIdlePools}}
	end.


loop_db(db_player_base, PageNo, FromServerId) ->
	List = select_rows(db_player_base, FromServerId, PageNo),
	Shift = merge_cfg:get_player_shift(FromServerId),
	[cp_data(db_player_base, Row, FromServerId, Shift) || Row <- List],
	ok;
loop_db(RecName, PageNo, FromServerId) ->
	List = select_rows(RecName, FromServerId, PageNo),
	Shift = merge_cfg:get_player_shift(FromServerId),
	[cp_data(RecName, Row, FromServerId, Shift) || Row <- List],
	ok.

%%角色
cp_data(db_player_base, Rec, FromServerId, Shift) ->
	#db_player_base{player_id = PlayerId, name = PlayerName, lv = Lv, vip = Vip, last_login_time = LastLoginTime} = Rec,
	Jade = get_jade(PlayerId),
	Now = get_now(),
	CleanTime = 3600 * 24 * 14,
	case Lv =< 40 andalso Jade =:= 0 andalso Vip =:= 0 andalso Now - LastLoginTime > CleanTime of
		true -> skip;
		false ->
			NewPlayerName = player_name_check(PlayerName, FromServerId),
			NewRec = Rec#db_player_base{name = NewPlayerName},
			Result = cp_data_base(db_player_base, NewRec, Shift),
			save_player_status(Result)
	end;
%%账号
cp_data(db_account, Rec, _FromServerId, Shift) ->
	#db_account{player_id = PlayerId} = Rec,
	case is_exist_player(PlayerId + Shift) of
		true -> cp_data_base(db_account, Rec, Shift);
		false ->
			skip
	end;
%%黑名单
cp_data(db_player_black, Rec, _FromServerId, Shift) ->
	#db_player_black{player_id = PlayerId, tplayer_id = TPlayerId} = Rec,
	case is_exist_player(PlayerId + Shift) andalso is_exist_player(TPlayerId + Shift)  of
		true -> cp_data_base(db_player_black, Rec, Shift);
		false ->
			skip
	end;
%%couter
cp_data(db_player_counter, Rec, _FromServerId, Shift) ->
	#db_player_counter{player_id = PlayerId, update_time = UpdateTime} = Rec,
	case is_exist_player(PlayerId + Shift) of
		true ->
			{_, TimeValue} = UpdateTime,
			NewRec = Rec#db_player_counter{update_time = util_date:datetime_to_string(TimeValue)},
			cp_data_base(db_player_counter, NewRec, Shift);
		false ->
			skip
	end;
%%仇人
cp_data(db_player_foe, Rec, _FromServerId, Shift) ->
	#db_player_foe{player_id = PlayerId, tplayer_id = TPlayerId} = Rec,
	case is_exist_player(PlayerId + Shift) andalso is_exist_player(TPlayerId + Shift)  of
		true -> cp_data_base(db_player_foe, Rec, Shift);
		false ->
			skip
	end;
%%好友
cp_data(db_player_friend, Rec, _FromServerId, Shift) ->
	#db_player_friend{player_id = PlayerId, tplayer_id = TPlayerId} = Rec,
	case is_exist_player(PlayerId + Shift) andalso is_exist_player(TPlayerId + Shift)  of
		true -> cp_data_base(db_player_friend, Rec, Shift);
		false ->
			skip
	end;
%%好友请求
cp_data(db_player_friend_ask, Rec, _FromServerId, Shift) ->
	#db_player_friend_ask{player_id = PlayerId, tplayer_id = TPlayerId} = Rec,
	case is_exist_player(PlayerId + Shift) andalso is_exist_player(TPlayerId + Shift)  of
		true -> cp_data_base(db_player_friend_ask, Rec, Shift);
		false ->
			skip
	end;
%%帮会成员
cp_data(db_player_guild, Rec, _FromServerId, Shift) ->
	#db_player_guild{player_id = PlayerId, guild_id = GuildId} = Rec,
	case is_exist_player(PlayerId + Shift) andalso get_guild_name(GuildId + Shift) =/= null of
		true ->
			NewPlayerName = get_player_name(PlayerId + Shift),
			NewGuildName = get_guild_name(GuildId + Shift),
			NewRec = Rec#db_player_guild{name = NewPlayerName, guild_name = NewGuildName},
			cp_data_base(db_player_guild, NewRec, Shift);
		false ->
			skip
	end;
%%帮会
cp_data(db_guild, Rec, FromServerId, Shift) ->
	#db_guild{guild_name = GuildName, chief_id = ChiefId} = Rec,
	case is_exist_player(ChiefId + Shift) of
		true ->
			NewGuildName = guild_name_check(GuildName, FromServerId),
			NewChiefName = get_player_name(ChiefId + Shift),
			NewRec = Rec#db_guild{guild_name = NewGuildName, chief_name = NewChiefName},
			Result = cp_data_base(db_guild, NewRec, Shift),
			save_guild_status(Result);
		false ->
			skip
	end;
%%邮件
cp_data(db_player_mail, Rec, _FromServerId, Shift) ->
	#db_player_mail{player_id = PlayerId, state = State} = Rec,
	case is_exist_player(PlayerId + Shift) andalso State =/= 1 of
		true ->
			cp_data_base(db_player_mail, Rec, Shift);
		false ->
			skip
	end;
%%红包
cp_data(db_red_record, Rec, _FromServerId, Shift) ->
	#db_red_record{player_id = PlayerId} = Rec,
	case is_exist_player(PlayerId + Shift) of
		true ->
			NewPlayerName = get_player_name(PlayerId + Shift),
			NewRec = Rec#db_red_record{name = NewPlayerName},
			cp_data_base(db_red_record, NewRec, Shift);
		false ->
			skip
	end;
cp_data(RecName, Rec, _FromServerId, Shift) ->
	case merge_cfg:get_keys(RecName) of
		[Index | _] ->
			PlayerId = element(Index, Rec),
			case is_exist_player(PlayerId + Shift) of
				true -> cp_data_base(RecName, Rec, Shift);
				false ->
					skip
			end;
		_ ->
			io:format("ignore ~p~n",[RecName]),
			skip
	end.

cp_data_base(RecName, Rec, Shift) ->
	Keys = merge_cfg:get_keys(RecName),
	NewRec =
		lists:foldl(fun(Index, RecAcc) ->
			OldValue = element(Index, RecAcc),
			case OldValue =/=0 of
				true ->
					NewValue = OldValue + Shift,
					setelement(Index, RecAcc, NewValue);
				false ->
					RecAcc
			end
		end, Rec, Keys),
	Pool = pool0,
	TableName = get_table_name(RecName),
	db_mysql:insert(Pool, TableName, util_tuple:to_tuple_list(NewRec)),
	NewRec.

count(RecName, ServerId) ->
	Pool = get_pool(ServerId),
	TableName = get_table_name(RecName),
	db_mysql:select_count(Pool, TableName, []).

select_rows(RecName, ServerId, PageNo) ->
	Pool = get_pool(ServerId),
	TableName = get_table_name(RecName),
	Offset = (PageNo - 1) * ?PAGE_SIZE,
	case db_mysql:select_all(Pool, TableName, util_tuple:fields(RecName), [], [], [Offset, ?PAGE_SIZE]) of
		[] ->
			[];
		List ->
			[list_to_tuple([RecName | X]) || X <- List]
	end.

do_rec_complete(db_goods) ->
	Pool = pool0,
	Sql = <<"delete from player_goods where goods_id=305010">>,	%%特武
	db_mysql:execute(Pool, Sql),
	ok;
do_rec_complete(db_arena_record) ->
	Pool = pool0,
	Sql = <<"update player_arena_record set match_list='[]', arena_list='[]'">>,
	db_mysql:execute(Pool, Sql),
	ok;
do_rec_complete(db_guild_) ->
	Pool = pool0,
	Sql = <<"">>,
	db_mysql:execute(Pool, Sql),
	ok;
do_rec_complete(_) ->
	ok.

%% clear_ets() ->
%% 	ets:delete(?ETS_MERGE_PLAYER),
%% 	ets:delete(?ETS_MERGE_PLAYER_NAME),
%% 	ets:delete(?ETS_MERGE_GUILD),
%% 	ets:delete(?ETS_MERGE_GUILD_NAME),
%% 	ets:delete(?ETS_MERGE_MONEY),
%% 	ok.

get_pool(ServerId) ->
	Pool = list_to_atom(lists:concat([pool, ServerId])),
	Pool.

get_table_name(db_goods) ->
	re:replace(atom_to_list(db_goods), "db_", "player_", [{return, list}]);
get_table_name(db_arena_record) ->
	re:replace(atom_to_list(db_arena_record), "db_", "player_", [{return, list}]);
get_table_name(RecName) ->
	re:replace(atom_to_list(RecName), "db_", "", [{return, list}]).



set_now() ->
	put(now, unixtime()).

get_now() ->
	case get(now) of
		undefined ->
			Time = unixtime(),
			put(now, Time),
			Time;
		Tm ->
			Tm
	end.

unixtime() ->
	{Mega, Sec, _} = os:timestamp(),
	(Mega * 1000000) + Sec.

ready_jade(ServerId) ->
	ets:delete_all_objects(?ETS_MERGE_MONEY),
	Pool = get_pool(ServerId),
	TableName = get_table_name(db_player_money),
	List =
		case db_mysql:select_all(Pool, TableName, record_info(fields, db_player_money), []) of
			[] ->
				[];
			List2 ->
				[list_to_tuple([db_player_money | X]) || X <- List2]
		end,
	lists:foreach(fun(R) ->
		#db_player_money{player_id = PlayerId, jade = Jade} = R,
		ets:insert(?ETS_MERGE_MONEY, {PlayerId, Jade}),
		ok
	end, List),
	ok.

get_jade(PlayerId) ->
	case ets:lookup(?ETS_MERGE_MONEY, PlayerId) of
		[{_PayerId, Jade}] -> Jade;
		_ -> 0
	end.

save_player_status(Rec) ->
	#db_player_base{player_id = PlayerId, name = PlayerName} = Rec,
	ets:insert(?ETS_MERGE_PLAYER, {PlayerId, PlayerName}),
	PlayerNameCase = util_data:to_binary(string:to_lower(util_data:to_list(PlayerName))),
	ets:insert(?ETS_MERGE_PLAYER_NAME, {PlayerNameCase, 1}),
	ok.

save_guild_status(Rec) ->
	#db_guild{guild_id = GuildId, guild_name = GuildName} = Rec,
	ets:insert(?ETS_MERGE_GUILD, {GuildId, GuildName}),
	GuildNameCase = util_data:to_binary(string:to_lower(util_data:to_list(GuildName))),
	ets:insert(?ETS_MERGE_GUILD_NAME, {GuildNameCase, 1}),
	ok.

is_exist_player(PlayerId) ->
	case ets:lookup(?ETS_MERGE_PLAYER, PlayerId) of
		[_] -> true;
		[] ->
			false
	end.

get_player_name(PlayerId) ->
	case ets:lookup(?ETS_MERGE_PLAYER, PlayerId) of
		[{_, Name}] -> Name;
		[] ->
			io:format("get_player_name error ~p ~n",[PlayerId]),
			null
	end.

get_guild_name(GuildId) ->
	case ets:lookup(?ETS_MERGE_GUILD, GuildId) of
		[{_, Name}] -> Name;
		[] ->
			io:format("get_guild_name error ~p ~n",[GuildId]),
			null
	end.

%%角色名重复检查
player_name_check(PlayerName, _ServerId) ->
	PlayerNameCase = util_data:to_binary(string:to_lower(util_data:to_list(PlayerName))),
	case ets:lookup(?ETS_MERGE_PLAYER_NAME, PlayerNameCase) of
		[_] ->
			BaseName0 = re:replace(PlayerName, "\\d+$", "", [global, {return, binary}]),
			BaseName =
				case BaseName0 =:= <<>> of
					true -> list_to_binary(lists:concat([binary_to_list(PlayerName), "_"]));
					false -> BaseName0
				end,
			PlayerName1 = list_to_binary(lists:concat([binary_to_list(BaseName), 1])),
			player_name_check1(PlayerName1, BaseName, 2);
		[] ->
			PlayerName
	end.
player_name_check1(PlayerName, BaseName, Num) ->
	PlayerNameCase = util_data:to_binary(string:to_lower(util_data:to_list(PlayerName))),
	case ets:lookup(?ETS_MERGE_PLAYER_NAME, PlayerNameCase) of
		[_] ->
			PlayerName1 = list_to_binary(lists:concat([binary_to_list(BaseName), Num])),
			player_name_check1(PlayerName1, BaseName, Num + 1);
		[] ->
			%%io:format("change player name  ~p ~p~n",[BaseName, PlayerName]),
			PlayerName
	end.

%%帮会名重复检查
guild_name_check(Name, _ServerId) ->
	NameCase = util_data:to_binary(string:to_lower(util_data:to_list(Name))),
	case ets:lookup(?ETS_MERGE_GUILD_NAME, NameCase) of
		[_] ->
			BaseName0 = re:replace(Name, "\\d+$", "", [global, {return, binary}]),
			BaseName =
				case BaseName0 =:= <<>> of
					true -> list_to_binary(lists:concat([binary_to_list(Name), "_"]));
					false -> BaseName0
				end,
			Name1 = list_to_binary(lists:concat([binary_to_list(BaseName), 1])),
			guild_name_check1(Name1, BaseName, 2);
		[] ->
			Name
	end.
guild_name_check1(Name, BaseName, Num) ->
	NameCase = util_data:to_binary(string:to_lower(util_data:to_list(Name))),
	case ets:lookup(?ETS_MERGE_GUILD_NAME, NameCase) of
		[_] ->
			Name1 = list_to_binary(lists:concat([binary_to_list(BaseName), Num])),
			guild_name_check1(Name1, BaseName, Num + 1);
		[] ->
			%%io:format("change guild name ~p ~p~n",[BaseName, Name]),
			Name
	end.