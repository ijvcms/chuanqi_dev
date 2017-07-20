%%%-------------------------------------------------------------------
%%% @author zhengsiying
%%% @copyright (C) 2015, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 23. 十二月 2015 下午3:36
%%%-------------------------------------------------------------------
-module(notice_mod).
%%

-behaviour(gen_server).

-include("common.hrl").
-include("record.hrl").
-include("config.hrl").
-include("notice_config.hrl").

%% gen_server callbacks
-export([init/1, handle_call/3, handle_cast/2, handle_info/2, terminate/2, code_change/3]).

-define(SERVER, ?MODULE).
%% 帧循环1秒, 单位毫秒
-define(TIMER_FRAME, 2000).

-record(state, {}).

%% API
-export([
	start_link/0
]).
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
	ets:new(?ETS_NOTICE, [{keypos, #ets_notice.key}, named_table, public, set, {read_concurrency, true}, {write_concurrency, true}]),
	erlang:send_after(?TIMER_FRAME, self(), {on_timer}),
	{ok, #state{}}.

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
handle_cast(_Request, State) ->
	{noreply, State}.

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
%% 	io:format("notice mod on timer 1:~p~n", [util_date:longunixtime()]),
	List = loop_notice_config:get_list(),

	CurTime = util_date:unixtime(),
	ServerStartTime = config:get_start_time(),
	T = CurTime - ServerStartTime,

	{Date, {H, M, _S}} = calendar:local_time(),
	CurWeek = calendar:day_of_the_week(Date),

	F = fun(Key) ->
		Conf = loop_notice_config:get(Key),
		{DayLimit, Week, StartTime} = Conf#loop_notice_conf.time_rule,
		DayTime =
			case ets:lookup(?ETS_NOTICE, Key) of
				[EtsInfo] ->
					EtsInfo#ets_notice.day_time;
				_ ->
					null
			end,

		if
			DayTime /= {Date, {H, M}} andalso T >= DayLimit * ?DAY_TIME_COUNT andalso
				(CurWeek == Week orelse Week == 0) andalso {H, M} == StartTime ->
				ets:insert(?ETS_NOTICE, #ets_notice{key = Key, day_time = {Date, {H, M}}}),
				?INFO("send notice : ~p", [Conf#loop_notice_conf.notice_id]),
				active_instance_lib:send_active_button_to_all_player(Conf#loop_notice_conf.notice_id),
				%% 当沙城没有归属的时候不开启怪物攻城与广播
				case Conf#loop_notice_conf.notice_id of
					?NOTICE_MONSTER_ATK_OPEN ->
						%% 开启怪物攻城并公告
						active_instance_lib:open_monster_attack_instance(),
						notice_lib:send_notice(0, Conf#loop_notice_conf.notice_id, []);
					?NOTICE_WZAD_OPEN ->%%本服暗殿只有开服前七天开.因为配置不支持前七天,需要单独处理.
						K = Conf#loop_notice_conf.key,
						%%小于七天,每天晚上
						%% todo 暂时屏蔽跨服活动
%%						case T < 7 * ?DAY_TIME_COUNT andalso (K =:= 41) of
						case K =:= 41 of
							true ->
								notice_lib:send_notice(0, Conf#loop_notice_conf.notice_id, []);
							false ->
								skip
						end;
					?NOTICE_WZAD_CLOSE ->%%本服暗殿只有开服前七天开
						K = Conf#loop_notice_conf.key,
						%%小于七天,每天晚上
						%% todo 暂时屏蔽跨服活动
%%						case T < 7 * ?DAY_TIME_COUNT andalso (K =:= 42) of
						case (K =:= 42) of
							true ->
								notice_lib:send_notice(0, Conf#loop_notice_conf.notice_id, []);
							false ->
								skip
						end;
					59 ->%%本服暗殿周末开.
						K = Conf#loop_notice_conf.key,
						%%小于七天,周六或周日的上午
						%% todo 暂时屏蔽跨服活动
%%						case T < 7 * ?DAY_TIME_COUNT andalso (K =:= 43 orelse K =:= 45) of
						case (K =:= 43 orelse K =:= 45) of
							true ->
								notice_lib:send_notice(0, Conf#loop_notice_conf.notice_id, []);
							false ->
								skip
						end;
					60 ->%%本服暗殿周末关.
						K = Conf#loop_notice_conf.key,
						%%小于七天,周六或周日的上午
						%% todo 暂时屏蔽跨服活动
%%						case T < 7 * ?DAY_TIME_COUNT andalso (K =:= 44 orelse K =:= 46) of
						case (K =:= 44 orelse K =:= 46) of
							true ->
								notice_lib:send_notice(0, Conf#loop_notice_conf.notice_id, []);
							false ->
								skip
						end;
					?NOTICE_NATIVE_BOSS_OPEN -> %本服火龙开启
						%%小于七天
						%% todo 暂时屏蔽跨服活动
%%						case T < 7 * ?DAY_TIME_COUNT of
%%							true ->
								notice_lib:send_notice(0, Conf#loop_notice_conf.notice_id, []);
%%							false ->
%%								skip
%%						end;
					?NOTICE_NATIVE_BOSS_CLOSE -> %本服火龙关闭
						%%小于七天
						%% todo 暂时屏蔽跨服活动
%%						case T < 7 * ?DAY_TIME_COUNT of
%%							true ->
								notice_lib:send_notice(0, Conf#loop_notice_conf.notice_id, []);
%%							false ->
%%								skip
%%						end;
					?NOTICE_HJZC -> %% 幻境之城
						skip;
						%% todo 暂时屏蔽跨服活动
%%						case cross_lib:send_cross_mfc(scene_hjzc_lib, create_scene, []) of
%%							ok ->
%%								notice_lib:send_notice(0, Conf#loop_notice_conf.notice_id, []);
%%							Err ->
%%								?ERR("scene_hjzc_lib ~p", [Err]),
%%								skip
%%						end;
					?NOTICE_NATIVE_HJZC -> %% 本服幻境之城
						%% todo 暂时屏蔽跨服活动
%%						case T > 7 * ?DAY_TIME_COUNT orelse scene_activity_palace_lib:is_open() of
						case scene_activity_palace_lib:is_open() of
							true ->
								skip;
							false ->
								case scene_hjzc_lib:create_scene() of
									ok ->
										notice_lib:send_notice(0, Conf#loop_notice_conf.notice_id, []);
									Err ->
										?ERR("native scene_hjzc_lib ~p", [Err]),
										skip
								end
						end;
					_ ->
						notice_lib:send_notice(0, Conf#loop_notice_conf.notice_id, [])
				end;
			true ->
				skip
		end
	end,
	lists:foreach(F, List),
	%% 定时检测限时活动
	active_remind_lib:update_active_remind_function(),
	erlang:send_after(?TIMER_FRAME, self(), {on_timer}),
%% 	io:format("notice mod on timer 2:~p~n", [util_date:longunixtime()]),
	{noreply, State};
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
