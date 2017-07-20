%% @author qhb
%% @doc @todo Add description to email_mod.


-module(email_mod).
-behaviour(gen_server).
-export([init/1, handle_call/3, handle_cast/2, handle_info/2, terminate/2, code_change/3]).
-include("common.hrl").

-define(SAME_TYPE_SEND_SPAN, 60 * 10).	%%同一类型邮件发送的间隔

%% ====================================================================
%% API functions
%% ====================================================================
-export([
	start_link/0,
	send/4
]).


%% ====================================================================
%% Behavioural functions 
%% ====================================================================
-record(state, {}).

start_link() ->
	gen_server:start_link({local, ?MODULE}, ?MODULE, [], []).

send(Title, Content, EmailGroup, Type) ->
	gen_server:cast(?MODULE, {send, [Title, Content, EmailGroup, Type]}).

%% init/1
%% ====================================================================
%% @doc <a href="http://www.erlang.org/doc/man/gen_server.html#Module:init-1">gen_server:init/1</a>
-spec init(Args :: term()) -> Result when
	Result :: {ok, State}
	| {ok, State, Timeout}
	| {ok, State, hibernate}
	| {stop, Reason :: term()}
	| ignore,
	State :: term(),
	Timeout :: non_neg_integer() | infinity.
%% ====================================================================
init([]) ->
	{ok, #state{}}.


%% handle_call/3
%% ====================================================================
%% @doc <a href="http://www.erlang.org/doc/man/gen_server.html#Module:handle_call-3">gen_server:handle_call/3</a>
-spec handle_call(Request :: term(), From :: {pid(), Tag :: term()}, State :: term()) -> Result when
	Result :: {reply, Reply, NewState}
	| {reply, Reply, NewState, Timeout}
	| {reply, Reply, NewState, hibernate}
	| {noreply, NewState}
	| {noreply, NewState, Timeout}
	| {noreply, NewState, hibernate}
	| {stop, Reason, Reply, NewState}
	| {stop, Reason, NewState},
	Reply :: term(),
	NewState :: term(),
	Timeout :: non_neg_integer() | infinity,
	Reason :: term().
%% ====================================================================
handle_call(_Request, _From, State) ->
	Reply = ok,
	{reply, Reply, State}.


%% handle_cast/2
%% ====================================================================
%% @doc <a href="http://www.erlang.org/doc/man/gen_server.html#Module:handle_cast-2">gen_server:handle_cast/2</a>
-spec handle_cast(Request :: term(), State :: term()) -> Result when
	Result :: {noreply, NewState}
	| {noreply, NewState, Timeout}
	| {noreply, NewState, hibernate}
	| {stop, Reason :: term(), NewState},
	NewState :: term(),
	Timeout :: non_neg_integer() | infinity.
%% ====================================================================
handle_cast({send, [Title, Content, EmailGroup, Type]}, State) ->
	try
		Now = util_date:unixtime(),
		LastSendTime = get(Type),
		case LastSendTime =:= undefined orelse Now - LastSendTime > ?SAME_TYPE_SEND_SPAN of
			true ->
				put(Type, Now),
				email_lib:send_and_log(Title, Content, EmailGroup, Type);
			false ->
				skip
		end
	catch
	    _:Reason  ->
			?ERR("email send error ~p ~p",[Reason, erlang:get_stacktrace()])
	end,
	{noreply, State};
handle_cast(_Msg, State) ->
	{noreply, State}.


%% handle_info/2
%% ====================================================================
%% @doc <a href="http://www.erlang.org/doc/man/gen_server.html#Module:handle_info-2">gen_server:handle_info/2</a>
-spec handle_info(Info :: timeout | term(), State :: term()) -> Result when
	Result :: {noreply, NewState}
	| {noreply, NewState, Timeout}
	| {noreply, NewState, hibernate}
	| {stop, Reason :: term(), NewState},
	NewState :: term(),
	Timeout :: non_neg_integer() | infinity.
%% ====================================================================
handle_info(_Info, State) ->
	{noreply, State}.


%% terminate/2
%% ====================================================================
%% @doc <a href="http://www.erlang.org/doc/man/gen_server.html#Module:terminate-2">gen_server:terminate/2</a>
-spec terminate(Reason, State :: term()) -> Any :: term() when
	Reason :: normal
	| shutdown
	| {shutdown, term()}
	| term().
%% ====================================================================
terminate(_Reason, _State) ->
	ok.


%% code_change/3
%% ====================================================================
%% @doc <a href="http://www.erlang.org/doc/man/gen_server.html#Module:code_change-3">gen_server:code_change/3</a>
-spec code_change(OldVsn, State :: term(), Extra :: term()) -> Result when
	Result :: {ok, NewState :: term()} | {error, Reason :: term()},
	OldVsn :: Vsn | {down, Vsn},
	Vsn :: term().
%% ====================================================================
code_change(_OldVsn, State, _Extra) ->
	{ok, State}.


%% ====================================================================
%% Internal functions
%% ====================================================================


