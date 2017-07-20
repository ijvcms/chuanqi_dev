%%%-------------------------------------------------------------------
%%% @author zhengsiying
%%% @copyright (C) 2015, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 22. 七月 2015 下午3:17
%%%-------------------------------------------------------------------
-module(player_mod).


-behaviour(gen_server).

-include("common.hrl").
-include("record.hrl").
-include("cache.hrl").

%% gen_server callbacks
-export([init/1, handle_call/3, handle_cast/2, handle_info/2, terminate/2, code_change/3]).

-define(SERVER, ?MODULE).
-record(state, {}).

%% APIF
-export([
	start/1
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
start([PlayerBase, Socket, SocketPid, OsType, OpenId, Platform, IsRobot]) ->
	gen_server:start(?MODULE, [PlayerBase, Socket, SocketPid, OsType, OpenId, Platform, IsRobot], []).

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
%% 初始化玩家状态信息
init([PlayerBase, Socket, SocketPid, OsType, OpenId, Platform, IsRobot]) ->
	#db_player_base{player_id = PlayerId} = PlayerBase,
	try
		process_flag(trap_exit, true),
		PlayerState = #player_state{
			player_id = PlayerId,
			socket = Socket,
			socket_pid = SocketPid,
			server_no = config:get_server_no(),
			team_id = 0,%%
			team_pid = 0,
			leader = 0,
			team_switch_1 = 0,
			team_switch_2 = 0,
			merit_task_id = 0,
			day_task_id = 0,
			week_task_id = 0,
			map_task_id = 0,
			ref_task_list = [],
			ref_day_task_list = [],
			ref_merit_task_list = [],
			ref_week_task_list = [],
			ref_map_task_list = [],
			function_open_list = [],
			chat_list = [],
			is_guild_red = false,
			is_robot = IsRobot,
			atk_num = 0,
			db_player_base = PlayerBase,
			atk_time = util_date:unixtime(),
			pid = self(),
			server_name = config:get_server_name(),
			black_friend_list = player_black_cache:select_all(PlayerId), %%缓存黑名单
			collect_state = 0
		},
		case player_lib:init_player_state(PlayerState, OsType, OpenId, Platform) of
			{ok, NewPlayerState} ->
				PlayerProcessName = misc:player_process_name(PlayerId),
				MyselfPid = self(),
				misc:register(global, PlayerProcessName, MyselfPid),
				{ok, NewPlayerState};
			{fail, _Err} ->
				?ERR("player_mod init ~p error:~n{~p ~p}", [PlayerId, _Err, erlang:get_stacktrace()])
		end
	catch
		Class:Err ->
			?ERR("player_mod init ~p error:~n{~p: ~p ~p}", [PlayerId, Class, Err, erlang:get_stacktrace()])
	end.

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

handle_call(Request, From, State) ->
	try
		case player_mod_call:handle(Request, From, State) of
			{ok, NewState} ->
				{reply, ok, NewState};
			{ok, NewState, Reply} ->
				{reply, Reply, NewState};
			{stop, Reason, NewState} ->
				{stop, Reason, NewState};
			{stop, Reason, Reply, NewState} ->
				{stop, Reason, Reply, NewState};
			_ ->
				{noreply, State}
		end
	catch
		Err:Info ->
			?ERR("~p ~p ~p", [Err, Info, erlang:get_stacktrace()]),
			{reply, ok, State}
	end.


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
handle_cast(Request, State) ->
%% 	io:format("player handle cast 1:~p~n", [{util_date:longunixtime(), Request}]),
	case player_mod_cast:handle(Request, State) of
		{ok, NewState} ->
%% 			io:format("player handle cast 2:~p~n", [{util_date:longunixtime(), Request}]),
			{noreply, NewState};
		{stop, Reason, NewState} ->
			{stop, Reason, NewState};
		_ ->
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
handle_info({apply_async, {F}}, State) ->
%% 	io:format("player handle info 1-1:~p~n", [{util_date:longunixtime(), F}]),
	handle_apply_async_return(util_sys:apply_catch(F, [State]), {undefined, F, []}, State);
handle_info({apply_async, {F, A}}, State) ->
%% 	io:format("player handle info 2-1:~p~n", [{util_date:longunixtime(), F, A}]),
	handle_apply_async_return(util_sys:apply_catch(F, [State | A]), {undefined, F, A}, State);
handle_info({apply_async, {M, F, A}}, State) ->
%% 	io:format("player handle info 3-1:~p~n", [{util_date:longunixtime(),M, F, A}]),
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
terminate(Reason, State) ->
	%% 玩家进程关闭或者不正常消亡必须清空玩家信息已经向关联的信息
	case Reason of
		normal ->
			skip;
		_ ->
			player_lib:logout(State)
	end,
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
%% 	io:format("player handle info *-2:~p~n", [{util_date:longunixtime(), _Mfa}]),
	{noreply, State};
handle_apply_async_return(ok, _Mfa, State) ->
%% 	io:format("player handle info *-2:~p~n", [{util_date:longunixtime(), _Mfa}]),
	{noreply, State};
handle_apply_async_return({stop, Reason, State}, _Mfa, _OldState) ->
	{stop, Reason, State};
handle_apply_async_return(_Else, _Mfa, State) ->
	{noreply, State}.