%%%-------------------------------------------------------------------
%%% @author ming
%%% @copyright (C) 2015, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 22. 八月 2014 下午4:14
%%%-------------------------------------------------------------------
-module(http_back).

-behaviour(gen_server).

%% API
-export([start_link/1]).

%% gen_server callbacks
-export([init/1, handle_call/3, handle_cast/2, handle_info/2, terminate/2, code_change/3]).

-define(SERVER, ?MODULE).

-include("common.hrl").

-record(state, {
	lsock,
	socket,
	parent,
	request_line,
	headers = [],
	body = <<>>,
	content_remaining = 0
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
-spec(start_link(LSock :: port()) ->
	{ok, Pid :: pid()} | ignore | {error, Reason :: term()}).
start_link(LSock) ->
	gen_server:start_link(?MODULE, [LSock, self()], []).

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
init([LSock, Parent]) ->
	{ok, #state{lsock = LSock, parent = Parent}, 0}.

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
handle_info(timeout, #state{lsock = LSock, parent = Parent} = State) ->
	case gen_tcp:accept(LSock) of
		{ok, Socket} ->
			http_back_sup:start_child(Parent),
			inet:setopts(Socket, [{active,once}]),
			{noreply, State#state{socket = Socket}};
		_ ->
			{stop, normal, State}
	end;

handle_info({http, _Socket, {http_request, _, _, _} = Request}, State) ->
	inet:setopts(State#state.socket, [{active, once}]),
	{noreply, State#state{request_line = Request}};

handle_info({http, _Socket, {http_header, _, Name, _, Value}}, State) ->
	inet:setopts(State#state.socket, [{active, once}]),
	{noreply, header(Name, Value, State)};

handle_info({http, Socket, http_eoh}, #state{content_remaining = 0} = State) ->
	{stop, normal, handle_http_request(State, Socket)};

handle_info({http, _Socket, http_eoh}, State) ->
	inet:setopts(State#state.socket, [{active, once}, {packet, raw}]),
	{noreply, State};

handle_info({tcp, Socket, Data}, State) when is_binary(Data) ->
	ContentRem = State#state.content_remaining - byte_size(Data),
	Body = list_to_binary([State#state.body, Data]),
	NewState = State#state{body = Body, content_remaining = ContentRem},
	if
		ContentRem > 0 ->
			inet:setopts(State#state.socket, [{active, once}]),
			{noreply, NewState};
		true ->
			{stop, normal, handle_http_request(NewState, Socket)}
	end;

handle_info({tcp_closed, _Sock}, State) ->
	{stop, normal, State};

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
header('Content-Length' = Name, Value, State) ->
	ContentLength = list_to_integer(binary_to_list(Value)),
	State#state{content_remaining = ContentLength,
		headers = [{Name, Value} | State#state.headers]};

header(<<"Expect">> = Name, <<"100-continue">> = Value, State) ->
	State#state{headers = [{Name, Value} | State#state.headers]};

header(Name, Value, State) ->
	State#state{headers = [{Name, Value} | State#state.headers]}.

handle_http_request(#state{request_line = RequestLine, headers = _Headers, body = Body}, Socket) ->
	{http_request, _Method, _Info, _} = RequestLine,
%% 	?WARNING("info is ~p, body is ~p", [Info, Body]),
	do_rpc(Socket, Body),
	gen_tcp:close(Socket).

do_rpc(Socket, Bin) ->
	{Cmd, Data} = pt_ex:read_cmd(Bin),
	back_pp:handle(Socket, Cmd, Data),
	ok.
