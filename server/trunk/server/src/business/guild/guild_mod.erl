%%%-------------------------------------------------------------------
%%% @author tuhujia
%%% @copyright (C) 2015, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 13. 八月 2015 10:46
%%%-------------------------------------------------------------------
-module(guild_mod).
-behaviour(gen_server).
%% --------------------------------------------------------------------
%% Include files
%% --------------------------------------------------------------------
-include("common.hrl").
-include("record.hrl").

-define(GUILD_MOD_SERVER_NUM, 10). %% 帮派进程服务个数

%% --------------------------------------------------------------------
%% External exports
-export([
	start/0,
	start_link/1,
	update_guild/3
]).

%% gen_server callbacks
-export([init/1, handle_call/3, handle_cast/2, handle_info/2, terminate/2, code_change/3]).

-record(state, {}).

%% ====================================================================
%% External functions
%% ====================================================================
%% 更新帮派数据信息
update_guild(GuildId, F, A) ->
	gen_server:cast(get_server(GuildId), {rpc, F, A}),
	ok.

%% ====================================================================
%% Server functions
%% ====================================================================
start()->
	Que = lists:seq(0, ?GUILD_MOD_SERVER_NUM-1),
	[start_one(Num) || Num<-Que],
	ok.
start_one(Num)->
	Server = get_server_name(Num),
	{ok,_} = supervisor:start_child(
		server_sup,
		{Server,
			{?MODULE, start_link, [Server]},
			permanent, 10000, supervisor, [?MODULE]}),
	ok.
start_link(Server) ->
	gen_server:start_link({local, Server},?MODULE, [], []).


get_server(Id)->
	ServerNum = Id rem ?GUILD_MOD_SERVER_NUM,
	get_server_name(ServerNum).

get_server_name(Num)->
	turn_list_to_atom(atom_to_list(?MODULE) ++ integer_to_list(Num)).
%% --------------------------------------------------------------------
%% Function: init/1
%% Description: Initiates the server
%% Returns: {ok, State}          |
%%          {ok, State, Timeout} |
%%          ignore               |
%%          {stop, Reason}
%% --------------------------------------------------------------------
init([]) ->
	process_flag(trap_exit, true),
	{ok, #state{}}.

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

handle_cast(_Msg, State) ->
	{noreply, State}.

%% --------------------------------------------------------------------
%% Function: handle_info/2
%% Description: Handling all non call/cast messages
%% Returns: {noreply, State}          |
%%          {noreply, State, Timeout} |
%%          {stop, Reason, State}            (terminate/2 is called)
%% --------------------------------------------------------------------
handle_info(_Info, State) ->
	{noreply, State}.

%% --------------------------------------------------------------------
%% Function: terminate/2
%% Description: Shutdown the server
%% Returns: any (ignored by gen_server)
%% --------------------------------------------------------------------
terminate(_Reason, _State) ->
	io:format("~p terminate~n", [?MODULE]),
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

%%列表字符串转换成原子
turn_list_to_atom(List)->
	try
		list_to_existing_atom(List)
	catch
		_:_->
			list_to_atom(List)
	end.

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