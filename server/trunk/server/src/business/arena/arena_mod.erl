%%%-------------------------------------------------------------------
%%% @author tuhujia
%%% @copyright (C) 2015, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 25. 八月 2015 11:42
%%%-------------------------------------------------------------------
-module(arena_mod).
-behaviour(gen_server).
%% --------------------------------------------------------------------
%% Include files
%% --------------------------------------------------------------------
-include("common.hrl").
-include("record.hrl").
-include("cache.hrl").
-include("proto.hrl").
-include("config.hrl").
%% --------------------------------------------------------------------
%% External exports
-export([
	start_link/0,
	update_arena/2,
	arena_cast/1
]).

%% gen_server callbacks
-export([init/1, handle_call/3, handle_cast/2, handle_info/2, terminate/2, code_change/3]).

-record(state, {now_rank}).

%% ====================================================================
%% External functions
%% ====================================================================
%% 更新帮派数据信息
update_arena(F, A) ->
	gen_server:cast(?MODULE, {rpc, F, A}),
	ok.

arena_cast(Msg) ->
	gen_server:cast(?MODULE, Msg).

%% ====================================================================
%% Server functions
%% ====================================================================
start_link() ->
	gen_server:start_link({local, ?MODULE},?MODULE, [], []).
%% --------------------------------------------------------------------
%% Function: init/1
%% Description: Initiates the server
%% Returns: {ok, State}          |
%%          {ok, State, Timeout} |
%%          ignore               |
%%          {stop, Reason}
%% --------------------------------------------------------------------
init([]) ->
	try
		do_init()
	catch
		_:Reason ->
			?WARNING("mod_duplicate do_init is exception:~p~n", [Reason]),
			?WARNING("get_stacktrace:~p", [erlang:get_stacktrace()]),
			{ok, #state{}}
	end.

%% --------------------------------------------------------------------
%% Function: handle_call/3
%% Description: Handling call messages
%% Returns: {reply, Reply, State}          |
%%          {reply, Reply, State, Timeout} |
%%          {noreply, State}               |
%%          {noreply, State, Timeout}      |
%%          {stop, Reason, Reply, State}   | (terminate/2 is called)
%%          {stop, Reason, State}            (terminate/2 is called)
%% --------------------------------------------------------------------
handle_call({rpc, F, A}, _From, State) ->
	try
		Return = try_catch_execute(F, A),
		{reply, Return, State}
	catch
		Error:Info ->
			?ERR("~p:~p, stacktrace:~p~n", [Error, Info,erlang:get_stacktrace()]),
			{reply, error, State}
	end;

handle_call(_Request, _From, State) ->
	Reply = ok,
	{reply, Reply, State}.

%% --------------------------------------------------------------------
%% Function: handle_cast/2
%% Description: Handling cast messages
%% Returns: {noreply, State}          |
%%          {noreply, State, Timeout} |
%%          {stop, Reason, State}            (terminate/2 is called)
%% --------------------------------------------------------------------
handle_cast({rpc, F, A}, State) ->
	try
		try_catch_execute(F, A),
		{noreply, State}
	catch
		Error:Info ->
			?ERR("~p:~p, stacktrace:~p~n", [Error, Info,erlang:get_stacktrace()]),
			{noreply, State}
	end;

handle_cast(Msg, State) ->
	try
		do_cast(Msg, State)
	catch
		Error:Info ->
			?ERR("~p:~p, stacktrace:~p~n", [Error, Info,erlang:get_stacktrace()]),
			{noreply, State}
	end.

%% --------------------------------------------------------------------
%% Function: handle_info/2
%% Description: Handling all non call/cast messages
%% Returns: {noreply, State}          |
%%          {noreply, State, Timeout} |
%%          {stop, Reason, State}            (terminate/2 is called)
%% --------------------------------------------------------------------
handle_info(Info, State) ->
	do_info(Info),
	{noreply, State}.

%% --------------------------------------------------------------------
%% Function: terminate/2
%% Description: Shutdown the server
%% Returns: any (ignored by gen_server)
%% --------------------------------------------------------------------
terminate(_Reason, _State) ->
	ok.

%% --------------------------------------------------------------------
%% Func: code_change/3
%% Purpose: Convert process state when code is changed
%% Returns: {ok, NewState}
%% --------------------------------------------------------------------
code_change(_OldVsn, State, _Extra) ->
	{ok, State}.

%% --------------------------------------------------------------------
%%% Internal functions
%% --------------------------------------------------------------------

do_init() ->
	Rank  = arena_lib:init_rank(),
	State = #state{now_rank = Rank + 1},
	Now10 = util_date:get_today_unixtime() + 22 * 3600,
	NowTime = util_date:unixtime(),
	Time = case NowTime =< Now10 of
			   true -> Now10 - NowTime;
			   false -> 24 * 3600 - (NowTime - Now10)
		   end,
	erlang:send_after(Time * 1000, self(), {'GIVE_REWARD_MAIL'}),
	{ok, State}.

%% 保存玩家竞技场信息(名次为key)
do_cast({update_arena_rank_info, ArenaInfo}, State) ->
	Rank = ArenaInfo#db_arena_rank.rank,
	put(Rank, ArenaInfo),
	{noreply, State};

do_cast({add_player_to_arena_rank, PlayerState}, State) ->
	NowRank = State#state.now_rank,
	case NowRank >= ?MAX_ARENA_RANK of
		true ->
			NowRank1 = NowRank;
		false ->
			PlayerBase = PlayerState#player_state.db_player_base,

			Extra = [PlayerState#player_state.guise,PlayerState#player_state.attr_total,PlayerState#player_state.order_skill_list],

			ArenaInfo = #db_arena_rank{
										player_id = PlayerState#player_state.player_id,
										rank = NowRank,
										lv = PlayerBase#db_player_base.lv,
										name = PlayerBase#db_player_base.name,
										sex = PlayerBase#db_player_base.sex,
										career = PlayerBase#db_player_base.career,
										fighting = PlayerState#player_state.fighting,
										guild_id = PlayerBase#db_player_base.guild_id,
										extra = Extra,
										update_time = util_date:unixtime()
									  },

			put(NowRank, ArenaInfo),
			arena_rank_cache:replace(ArenaInfo),
			arena_rank_cache:save_arena_info_to_ets(ArenaInfo),

			NowRank1 = NowRank + 1
	end,
	{noreply, State#state{now_rank = NowRank1}};

do_cast({change_player_arena_rank, InfoA, InfoB}, State) ->
	RankA = arena_lib:get_player_arena_rank(InfoA#db_arena_rank.player_id),
	RankB = arena_lib:get_player_arena_rank(InfoB#db_arena_rank.player_id),
	ArenaInfoA = InfoA#db_arena_rank{rank = RankA},
	ArenaInfoB = InfoB#db_arena_rank{rank = RankB},
	case RankA > RankB orelse RankA == 0 of
		true ->
			NewArenaInfoA = ArenaInfoA#db_arena_rank{rank = RankB},
			NewArenaInfoB = ArenaInfoB#db_arena_rank{rank = RankA},

			put(RankB, NewArenaInfoA),
			arena_rank_cache:replace(NewArenaInfoA),
			arena_rank_cache:save_arena_info_to_ets(NewArenaInfoA),

			put(RankA, NewArenaInfoB),
			arena_rank_cache:replace(NewArenaInfoB),
			arena_rank_cache:save_arena_info_to_ets(NewArenaInfoB);
		false ->
			skip
	end,
	{noreply, State};

do_cast({broadcast_match_arena_info, MatchList, Socket}, State) ->
	Fun = fun(R, Acc) ->
			Rank = case R of
					   {R1} -> R1;
					   R2 -> R2
				   end,
			case get(Rank) of
				undefined ->
					Acc;
				ArenaInfo ->
					[arena_lib:pack_to_proto_arena_challenge_info(ArenaInfo)] ++ Acc
			end
		end,
	Proto = lists:foldl(Fun, [], lists:reverse(MatchList)),
	net_send:send_to_client(Socket, 23003, #rep_arena_challenge_list{list = Proto}),
	{noreply, State};

do_cast({push_rank, Socket}, State) ->
	Fun = fun(Rank, Acc) ->
			case get(Rank) of
				undefined ->
					Acc;
				ArenaInfo ->
					[arena_lib:pack_to_proto_arena_rank_info(ArenaInfo)] ++ Acc
			end
		  end,
	Proto = lists:foldl(Fun, [], lists:reverse(lists:seq(1, 20))),
	net_send:send_to_client(Socket, 23004, #rep_arena_rank_list{list = Proto}),
	{noreply, State};

do_cast(Msg, State) ->
	?WARNING("unknown cast msg, ~p", [Msg]),
	{noreply, State}.

do_info({'GIVE_REWARD_MAIL'}) ->
	%% 发放排名奖励
	?DEBUG("unknown cast MAIL, ~p", [unknown]),
	send_arena_reward_mail(),
	erlang:send_after(3600 * 24 * 1000, self(), {'GIVE_REWARD_MAIL'}),
	{noreply}.

%% --------------------------------------------------------------------
%%%
%% --------------------------------------------------------------------

try_catch_execute(F, [A]) ->
	try F(A)
	catch
		ErrType:ErrInfo ->
			?ERR("~p:~p~n,stacktrace:~p", [ErrType,ErrInfo,erlang:get_stacktrace()]),
			error
	end;
try_catch_execute(F, [A,B]) ->
	try F(A,B)
	catch
		ErrType:ErrInfo ->
			?ERR("~p:~p~n,stacktrace:~p", [ErrType,ErrInfo,erlang:get_stacktrace()]),
			error
	end;
try_catch_execute(F, [A,B,C]) ->
	try F(A,B,C)
	catch
		ErrType:ErrInfo ->
			?ERR("~p:~p~n,stacktrace:~p", [ErrType,ErrInfo,erlang:get_stacktrace()]),
			error
	end;
try_catch_execute(F, [A,B,C,D]) ->
	try F(A,B,C,D)
	catch
		ErrType:ErrInfo ->
			?ERR("~p:~p~n,stacktrace:~p", [ErrType,ErrInfo,erlang:get_stacktrace()]),
			error
	end;
try_catch_execute(F, [A,B,C,D,E]) ->
	try F(A,B,C,D,E)
	catch
		ErrType:ErrInfo ->
			?ERR("~p:~p~n,stacktrace:~p", [ErrType,ErrInfo,erlang:get_stacktrace()]),
			error
	end;
try_catch_execute(_F, _Other) ->
	?ERR("~p:~p args error",[?MODULE,?LINE]),
	error.

%% 发放邮件
send_arena_reward_mail() ->
	Fun = fun({_Key, ArenaInfo}) ->
		case is_record(ArenaInfo, db_arena_rank) of
			true ->
				PlayerId = ArenaInfo#db_arena_rank.player_id,
				MailId = get_rank_reward(ArenaInfo#db_arena_rank.rank),
				mail_lib:send_mail_to_player(PlayerId, MailId);
			false ->
				skip
		end
	end,
	[Fun(X)||X <- get()].

%% 获取排名奖励
get_rank_reward(Rank) ->
	get_rank_reward(Rank, arena_reward_config:get_list()).
get_rank_reward(_Rank, []) ->
	0;
get_rank_reward(Rank, [Key|T]) ->
	Conf = arena_reward_config:get(Key),
	case Rank >= Conf#arena_reward_conf.min_rank andalso Rank =< Conf#arena_reward_conf.max_rank of
		true ->
			Conf#arena_reward_conf.mail_id;
		false ->
			get_rank_reward(Rank, T)
	end.