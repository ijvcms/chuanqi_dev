%%%-------------------------------------------------------------------
%%% @author qhb
%%% @copyright (C) 2016, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 18. 五月 2016 下午3:12
%%%-------------------------------------------------------------------
-module(cache_log_lib).
-author("qhb").
-include("common.hrl").
-include("record.hrl").

-define(CACHE_LOG_NUM, 2).
-define(TIMER_FRAME_LOG, 300000).
-define(BATCH_NUM, 30).

%% API
-export([
	init/0,
	insert/1,
	set_next_save_id/1,
	set_saving_status/1
]).

%% GEN API
-export([
	insert_local/2,
	set_next_save_id_local/2,
	set_saving_status_local/2,
	on_timer_local/1
]).



init() ->
	ets:new(ets_log_cache, [named_table, public, ordered_set]),
	gen_server2:apply_after(?TIMER_FRAME_LOG, self(), {?MODULE, on_timer_local, []}),
	ok.

%%插入日志数据
insert(Rc) ->
	gen_server2:apply_async(misc:whereis_name({local, cache_log_mod}), {?MODULE, insert_local, [Rc]}).
insert_local(State, Rc) ->
	#log_cache_state{current_id = CurId} = State,
	try
		ets:insert(ets_log_cache, {CurId, Rc})
	catch
		_:Reason ->
			?ERR("cache log insert error ~p ~p", [Reason, erlang:get_stacktrace()])
	end,
	{ok, State#log_cache_state{current_id = CurId + 1}}.

%%保存日志的进度
set_next_save_id(Idx) ->
	gen_server2:apply_sync(misc:whereis_name({local, cache_log_mod}), {?MODULE, set_next_save_id_local, [Idx]}).
set_next_save_id_local(State, Idx) ->
	case Idx > State#log_cache_state.begin_id of
		true ->
			%%?WARNING("set_next_save_id_local ~p", [Idx]),
			{ok, true, State#log_cache_state{begin_id = Idx, saving = false}};
		false ->
			{ok, true, State}
	end.

%%是否正在进行保存到数据库
set_saving_status(Flag) ->
	gen_server2:apply_sync(misc:whereis_name({local, cache_log_mod}), {?MODULE, set_saving_status_local, [Flag]}).
set_saving_status_local(State, Flag) ->
	{ok, true, State#log_cache_state{saving = Flag}}.

%%定时保存
on_timer_local(State) ->
	save(State),
	gen_server2:apply_after(?TIMER_FRAME_LOG, self(), {?MODULE, on_timer_local, []}),
	{ok, State}.


%% ====================================================================
%% Internal functions
%% ====================================================================
%%保存到数据库逻辑
save(State) ->
	#log_cache_state{begin_id = BeginId, current_id = CurrentId, saving = Saveing} = State,
	case Saveing of
		true ->
			?WARNING("cache log save busy", []),
			no;
		_ ->
			spawn(fun() ->
				try
					loop_ets_index(ets_log_cache, BeginId, CurrentId, dict:new()),
					cache_log_lib:set_next_save_id(CurrentId)
				catch
					Err:Reason ->
						cache_log_lib:set_saving_status(false),
						ErrMsg = io_lib:format("cache_log_lib err ~p148~n ~p:~p~n~p", [State, Err, Reason, erlang:get_stacktrace()]),
						Type = "log",
						email_mod:send("日志缓存错误", ErrMsg, "dev", Type),
						?ERR("cache log save error ~p ~p", [Reason, erlang:get_stacktrace()])
				end
			end)
	end,
	{ok, State#log_cache_state{saving = true}}.


%%遍历ets转换成dict,然后保存
loop_ets_index(EtsName, Idx, Idx, DictAcc) ->
	Keys = dict:fetch_keys(DictAcc),
	[
		begin
			do_item_dict(EtsName, Key, DictAcc)
		end
		|| Key <- Keys
	],
	ok;
loop_ets_index(EtsName, Idx, EndIdx, DictAcc) ->
	NewDictAcc =
		case ets:lookup(EtsName, Idx) of
			[Ele] ->
				{ok, DictAcc1} = do_item(EtsName, Ele, DictAcc),
				DictAcc1;
			[] -> DictAcc
		end,
	loop_ets_index(EtsName, Idx + 1, EndIdx, NewDictAcc).

%%保存dict的单个元素
do_item(EtsName, Ele, DictAcc) ->
	{_Idx, Rc} = Ele,
	RcType = element(1, Rc),
	OldList =
		case dict:find(RcType, DictAcc) of
			{ok, OldList01} ->
				OldList01;
			_ ->
				[]
		end,
	NewList = [Ele | OldList],

	NewDictAcc =
		case length(NewList) >= ?BATCH_NUM of
			true ->
				do_item_dict(EtsName, RcType, dict:store(RcType, NewList, DictAcc));
			false ->
				dict:store(RcType, NewList, DictAcc)
		end,
	{ok, NewDictAcc}.

%%保存dict
do_item_dict(EtsName, Key, Dict) ->
	{ok, List} = dict:find(Key, Dict),
	case save_and_remove_ets(EtsName, List) of
		ok ->
			dict:erase(Key, Dict);
		_ ->
			?WARNING("save_and_remove_ets fail", []),
			Dict
	end.

%%保存到数据库
save_and_remove_ets(_, []) ->
	ok;
save_and_remove_ets(EtsName, List) ->
	try
		%% save batch
		[{_, Rc0} | _] = List,
		RcName = element(1, Rc0),
		TableName = log_factory:get_tablename(RcName),
		PoolId = log_factory:get_poolId(RcName),
		cache_table:create_if_not_exist(PoolId, TableName, log_factory:get_create_sql(RcName)),

		Fields = util_tuple:fields(RcName),
		List1 = [tuple_to_list(Rc1) || {_, Rc1} <- List],
		Records = lists:reverse([Last || [_ | Last] <- List1]),
		Sql = make_sql(TableName, Fields, Records),
		%%?WARNING("sql ~p",[Sql]),
		db_mysql:execute(PoolId, Sql),

		[
			begin
			%%?WARNING("ets delete ~p, ~p", [EtsName, Idx]),
				ets:delete(EtsName, Idx)
			end
			|| {Idx, _} <- List
		],
		ok
	catch
		Err:Reason ->
			?ERR("~p ~p ~p", [Err, Reason, List])
	end.


%%sql语句拼装
make_sql(TableName, Fields, Records) ->
	Bin1 = util_data:to_binary(TableName),
	FieldSql = format_field(Fields, <<>>),
	ValueSql = list_to_binary(string:join([[format_value(ValueList, <<>>)] || ValueList <- Records], ",")),
	<<"insert into `", Bin1/binary, "`  ", FieldSql/binary, " values ", ValueSql/binary>>.

format_field([], Expr) ->
	<<"(", Expr/binary, ")">>;
format_field([V], Expr) ->
	Bin = util_data:to_binary(V),
	format_field([], <<Expr/binary, "`", Bin/binary, "`">>);
format_field([V | T], Expr) ->
	Bin = util_data:to_binary(V),
	format_field(T, <<Expr/binary, "`", Bin/binary, "`,">>).

format_value([], Expr) ->
	<<"(", Expr/binary, ")">>;
format_value([Val], Expr) when is_binary(Val) orelse is_list(Val) ->
	Bin = re:replace(Val, "'", "''", [global, {return, binary}]),
	format_value([], <<Expr/binary, "'", Bin/binary, "'">>);
format_value([Val | T], Expr) when is_binary(Val) orelse is_list(Val) ->
	Bin = re:replace(Val, "'", "''", [global, {return, binary}]),
	format_value(T, <<Expr/binary, "'", Bin/binary, "',">>);
format_value([Val], Expr) ->
	Bin =
		case Val =/= undefined of
			true ->
				util_data:to_binary(Val);
			false ->
				<<"null">>
		end,
	format_value([], <<Expr/binary, Bin/binary>>);
format_value([Val | T], Expr) ->
	Bin =
		case Val =/= undefined of
			true ->
				util_data:to_binary(Val);
			false ->
				<<"null">>
		end,
	format_value(T, <<Expr/binary, Bin/binary, ",">>).
