%%%-------------------------------------------------------------------
%%% @author tuhujia
%%% @copyright (C) 2016, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 06. 七月 2016 16:09
%%%-------------------------------------------------------------------
-module(operate_active_mod).

-behaviour(gen_server).

-include("common.hrl").
-include("record.hrl").
-include("config.hrl").
-include("rank.hrl").
-include("notice_config.hrl").
%% --------------------------------------------------------------------
%% External exports
-export([
	start_link/0,
	operate_active_cast/1
]).

%% gen_server callbacks
-export([init/1, handle_call/3, handle_cast/2, handle_info/2, terminate/2, code_change/3]).

-define(SERVER, ?MODULE).
%% 帧循环1秒, 单位毫秒
-define(TIMER_FRAME, 10000).

-record(state, {
	start_list = [],  %% 当前开启的活动列表
	start_holiday_list = [], %% 当前开启的节日活动列表
	limit_list = [],  %% 限制条件列表
	double_exp_state = 0  %% 当前双倍经验状态0未开启 1已开启
}).
%%%===================================================================
%%% API
%%%===================================================================

%%--------------------------------------------------------------------
%% @doc
%% Starts the server
%%
%% @end
%%--------------------------------------------------------------------
-spec(start_link() ->
	{ok, Pid :: pid()} | ignore | {error, Reason :: term()}).
start_link() ->
	gen_server:start_link({local, ?SERVER}, ?MODULE, [], []).

%% ====================================================================
%% External functions
%% ====================================================================
operate_active_cast(Msg) ->
	gen_server:cast(?MODULE, Msg).

%%%===================================================================
%%% gen_server callbacks
%%%===================================================================

%%--------------------------------------------------------------------
%% @private
%% @doc
%% Initializes the server
%%
%% @spec init(Args) -> {ok, State} |
%%                     {ok, State, Timeout} |
%%                     ignore |
%%                     {stop, Reason}
%% @end
%%--------------------------------------------------------------------
-spec(init(Args :: term()) ->
	{ok, State :: #state{}} | {ok, State :: #state{}, timeout() | hibernate} |
	{stop, Reason :: term()} | ignore).
init([]) ->
	process_flag(trap_exit, true),
	ets:new(?ETS_OPERATE_ACTIVE_CONF, [{keypos, #ets_operate_active_conf.active_id}, named_table, public, set, {read_concurrency,true}, {write_concurrency,true}]),
	ets:new(?ETS_OPERATE_SUB_TYPE_CONF, [{keypos, #ets_operate_sub_type_conf.key}, named_table, public, set, {read_concurrency,true}, {write_concurrency,true}]),
	ets:new(?ETS_OPEN_OPERATE_LIST, [{keypos, #ets_open_operate_list.key}, named_table, public, set, {read_concurrency,true}, {write_concurrency,true}]),
	ets:new(?ETS_DOUBLE_EXP, [{keypos, #ets_double_exp.key}, named_table, public, set, {read_concurrency,true}, {write_concurrency,true}]),

	%% 初始化
	{OpenList, HolidayList, LimitList, State} = operate_active_lib:init_conf(),

	%% 初始化节日活动排行榜
	case lists:keyfind(?OPERATE_ACTIVE_TYPE_4, 2, HolidayList) of
		{ActiveId, _Type} ->
			rank_lib:init_single_rank({?ETS_OPERATE_TYPE_4, ActiveId, ?OPERATE_ACTIVE_LIMIT_TYPE_18});
		_ ->
			skip
	end,
	erlang:send_after(?TIMER_FRAME, self(), {on_timer}),
	{ok, #state{start_list = OpenList, start_holiday_list = HolidayList, double_exp_state = State, limit_list = LimitList}}.

%%--------------------------------------------------------------------
%% @private
%% @doc
%% Handling call messages
%%
%% @end
%%--------------------------------------------------------------------
-spec(handle_call(Request :: term(), From :: {pid(), Tag :: term()},
	State :: #state{}) ->
	{reply, Reply :: term(), NewState :: #state{}} |
	{reply, Reply :: term(), NewState :: #state{}, timeout() | hibernate} |
	{noreply, NewState :: #state{}} |
	{noreply, NewState :: #state{}, timeout() | hibernate} |
	{stop, Reason :: term(), Reply :: term(), NewState :: #state{}} |
	{stop, Reason :: term(), NewState :: #state{}}).
%% 执行同步apply操作
handle_call({apply_sync, {F}}, _From, State) ->
	handle_apply_sync_return(util_sys:apply_catch(F, [State]), {undefined, F, []}, State);
handle_call({apply_sync, {F, A}}, _From, State) ->
	handle_apply_sync_return(util_sys:apply_catch(F, [State | A]), {undefined, F, A}, State);
handle_call({apply_sync, {M, F, A}}, _From, State) ->
	handle_apply_sync_return(util_sys:apply_catch(M, F, [State | A]), {M, F, A}, State);

handle_call({get, Args}, _From, State) ->
	Reply = util_sys:apply_catch(erlang, get, Args),
	{reply, Reply, State};
handle_call({put, [Index, Value]}, _From, State) ->
	put(Index, Value),
	{reply, ok, State};

handle_call(_Request, _From, State) ->
	{reply, ok, State}.

%%--------------------------------------------------------------------
%% @private
%% @doc
%% Handling cast messages
%%
%% @end
%%--------------------------------------------------------------------
-spec(handle_cast(Request :: term(), State :: #state{}) ->
	{noreply, NewState :: #state{}} |
	{noreply, NewState :: #state{}, timeout() | hibernate} |
	{stop, Reason :: term(), NewState :: #state{}}).
handle_cast(Msg, State) ->
	try
		do_cast(Msg, State)
	catch
		Error:Info ->
			?ERR("~p:~p, stacktrace:~p~n", [Error, Info,erlang:get_stacktrace()]),
			{noreply, State}
	end.

%%--------------------------------------------------------------------
%% @private
%% @doc
%% Handling all non call/cast messages
%%
%% @spec handle_info(Info, State) -> {noreply, State} |
%%                                   {noreply, State, Timeout} |
%%                                   {stop, Reason, State}
%% @end
%%--------------------------------------------------------------------
-spec(handle_info(Info :: timeout() | term(), State :: #state{}) ->
	{noreply, NewState :: #state{}} |
	{noreply, NewState :: #state{}, timeout() | hibernate} |
	{stop, Reason :: term(), NewState :: #state{}}).
%% 执行异步apply操作
handle_info({on_timer}, State) ->
%% 	io:format("operate active mod on timer 1:~p~n", [util_date:longunixtime()]),
	{NewOpenList, NewHolidayList, NewLimitList, NewState} = operate_active_lib:check_conf(),
	OldOpenList = State#state.start_list,
	OldHolidayList = State#state.start_holiday_list,
	OldLimitList = State#state.limit_list,
	OldState = State#state.double_exp_state,
	%% 更新开启活动列表ets
	case NewOpenList == OldOpenList andalso OldLimitList == NewLimitList andalso OldHolidayList == NewHolidayList of
		true ->
			skip;
		false ->
			%% 检测是否要加载节日击杀活动排行榜
			case OldHolidayList == NewHolidayList of
				true ->
					skip;
				false ->
					F = fun(A) ->
						RankFlag = {?ETS_OPERATE_TYPE_4, A, ?OPERATE_ACTIVE_LIMIT_TYPE_18},
						rank_lib:init_single_rank(RankFlag)
					end,
					[F(X)||{X, Y} <- NewHolidayList, Y == ?OPERATE_ACTIVE_TYPE_4],
					%% 如果活动结束 发放奖励 清空ets
					F1 = fun(A) ->
						RankFlag = {?ETS_OPERATE_TYPE_4, A, ?OPERATE_ACTIVE_LIMIT_TYPE_18},
						case rank_lib:get_rank_list(RankFlag) of
							[] ->
								skip;
							_ ->
								RankList = rank_lib:get_rank_list({?ETS_OPERATE_TYPE_4, A, ?OPERATE_ACTIVE_LIMIT_TYPE_18}),
								ets:delete(?ETS_RANK_INFO, {?ETS_OPERATE_TYPE_4, A, ?OPERATE_ACTIVE_LIMIT_TYPE_18}),
								operate_active_lib:send_kill_active_mail(RankList)
						end
					end,
					[F1(X)||{X, Y} <- OldHolidayList -- NewHolidayList, Y == ?OPERATE_ACTIVE_TYPE_4]

			end,
			ets:insert(?ETS_OPEN_OPERATE_LIST, #ets_open_operate_list{key = ?ALL_SERVER_SIGN, holiday_list = NewHolidayList, active_list = NewOpenList, limit_list = NewLimitList})
	end,

	%% 更新双倍活动状态ets
	case NewState == OldState of
		true ->
			skip;
		false ->
			active_service_merge_lib:check_double_exp(),
			ets:insert(?ETS_DOUBLE_EXP, #ets_double_exp{key = ?ALL_SERVER_SIGN, state = NewState})
	end,

	%% 推送功能按钮
	UpdateList1 = util_erl:get_if(NewOpenList == [] andalso OldOpenList =/= [],
		[{?FUNCTION_STATE_CLOSE, ?FUNCTION_OPERATE_ACTIVE}],
		[]),

	UpdateList2 = util_erl:get_if(NewOpenList =/= [] andalso OldOpenList == [],
		[{?FUNCTION_STATE_OPEN, ?FUNCTION_OPERATE_ACTIVE}], []),

	UpdateList3 = util_erl:get_if(NewHolidayList == [] andalso OldHolidayList =/= [],
		[{?FUNCTION_STATE_CLOSE, ?FUNCTION_HOLIDAY_ACTIVE}], []),

	UpdateList4 = util_erl:get_if(NewHolidayList =/= [] andalso OldHolidayList == [],
		[{?FUNCTION_STATE_OPEN, ?FUNCTION_HOLIDAY_ACTIVE}], []),

	UpdateList = lists:concat([UpdateList1, UpdateList2, UpdateList3, UpdateList4]),

	case UpdateList of
		[] -> next;
		_ ->
			PlayerList1 = player_lib:get_online_players(),
			Fun1 = fun(EtsOnline1) ->
				gen_server2:cast(EtsOnline1#ets_online.pid, {update_function_button, UpdateList})
			end,
			[Fun1(X) || X <- PlayerList1]
	end,
	erlang:send_after(?TIMER_FRAME, self(), {on_timer}),
%% 	io:format("operate active mod on timer 2:~p~n", [util_date:longunixtime()]),
	{noreply, State#state{start_list = NewOpenList, start_holiday_list = NewHolidayList, double_exp_state = NewState}};
handle_info({apply_async, {F}}, State) ->
	handle_apply_async_return(util_sys:apply_catch(F, [State]), {undefined, F, []}, State);
handle_info({apply_async, {F, A}}, State) ->
	handle_apply_async_return(util_sys:apply_catch(F, [State | A]), {undefined, F, A}, State);
handle_info({apply_async, {M, F, A}}, State) ->
	handle_apply_async_return(util_sys:apply_catch(M, F, [State | A]), {M, F, A}, State);
handle_info(_Info, State) ->
	{noreply, State}.

%%--------------------------------------------------------------------
%% @private
%% @doc
%% This function is called by a gen_server when it is about to
%% terminate. It should be the opposite of Module:init/1 and do any
%% necessary cleaning up. When it returns, the gen_server terminates
%% with Reason. The return value is ignored.
%%
%% @spec terminate(Reason, State) -> void()
%% @end
%%--------------------------------------------------------------------
-spec(terminate(Reason :: (normal | shutdown | {shutdown, term()} | term()),
	State :: #state{}) -> term()).
terminate(_Reason, _State) ->
	io:format("~p terminate~n", [?MODULE]),
	ok.

%%--------------------------------------------------------------------
%% @private
%% @doc
%% Convert process state when code is changed
%%
%% @spec code_change(OldVsn, State, Extra) -> {ok, NewState}
%% @end
%%--------------------------------------------------------------------
-spec(code_change(OldVsn :: term() | {down, term()}, State :: #state{},
	Extra :: term()) ->
	{ok, NewState :: #state{}} | {error, Reason :: term()}).
code_change(_OldVsn, State, _Extra) ->
	{ok, State}.

%%%===================================================================
%%% Internal functions
%%%===================================================================
%% 处理同步apply的返回值
handle_apply_sync_return({ok, Reply, State}, _Mfa, _OldState) ->
	{reply, {ok, Reply}, State};
handle_apply_sync_return({ok, Reply}, _Mfa, State) ->
	{reply, {ok, Reply}, State};
handle_apply_sync_return({stop, Reason, State}, _Mfa, _OldState) ->
	{stop, Reason, State};
handle_apply_sync_return(Else, _Mfa, State) ->
	{reply, Else, State}.

%% 处理异步apply的返回值
handle_apply_async_return({ok, State}, _Mfa, _OldState) ->
	{noreply, State};
handle_apply_async_return(ok, _Mfa, State) ->
	{noreply, State};
handle_apply_async_return({stop, Reason, State}, _Mfa, _OldState) ->
	{stop, Reason, State};
handle_apply_async_return(_Else, _Mfa, State) ->
	{noreply, State}.

%% --------------------------------------------------------------------
%%% Internal functions
%% --------------------------------------------------------------------
do_cast(Msg, State) ->
	?WARNING("unknown cast msg, ~p", [Msg]),
	{noreply, State}.
