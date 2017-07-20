%%%-------------------------------------------------------------------
%%% @author zhengsiying
%%% @copyright (C) 2015, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 01. 六月 2015 下午4:37
%%%-------------------------------------------------------------------
-module(logger_handle).

-behaviour(gen_event).

-include("common.hrl").

-export([
	init/1,
	handle_event/2,
	handle_call/2,
	handle_info/2,
	terminate/2,
	code_change/3
]).

-record(state, {fd, file, cur_day}).

%% ====================================================================
%% API functions
%% ====================================================================
init([]) ->
	CurDay = get_cur_day(),
	Dir = get_dir(CurDay),
	file:make_dir(Dir),
	File = get_file_name(Dir),
	case file:open(File, [append, raw]) of
		{ok, Fd} ->
			{ok, #state{fd = Fd, file = File, cur_day = CurDay}};
		Error ->
			Error
	end.

handle_event(Event, State) ->
	CurDay = get_cur_day(),
	NewState =
		case CurDay =:= State#state.cur_day of
			true ->
				State;
			_ ->
				Dir = get_dir(CurDay),
				file:make_dir(Dir),
				File = get_file_name(Dir),
				case file:open(File, [append, raw]) of
					{ok, Fd} ->
						State#state{fd = Fd, file = File, cur_day = CurDay};
					_Error ->
						State
				end
		end,
	write_event(NewState#state.fd, {erlang:localtime(), Event}),
	{ok, NewState}.

handle_call(_Request, State) ->
	Reply = ok,
	{ok, Reply, State}.

handle_info({'EXIT', _Fd, _Reason}, _State) ->
	remove_handle;
handle_info(_Info, State) ->
	{ok, State}.

terminate(_Reason, _State) ->
	ok.

code_change(_OldVsn, State, _Extra) ->
	{ok, State}.

%% ====================================================================
%% Internal functions
%% ====================================================================
write_event(Fd, {Time, {error, _GL, {Pid, Format, Args}}}) ->
	T = write_time(Time),
	case catch io_lib:format(add_node(Format, Pid), Args) of
		S when is_list(S) ->
			file:write(Fd, io_lib:format(T ++ S, []));
		_ ->
			F = add_node("ERROR: ~p - ~p~n", Pid),
			file:write(Fd, io_lib:format(T ++ F, [Format, Args]))
	end;
write_event(Fd, {Time, {warning_msg, _GL, {Pid, Format, Args}}}) ->
	T = write_time(Time, "WARNING REPORT"),
	case catch io_lib:format(add_node(Format, Pid), Args) of
		S when is_list(S) ->
			file:write(Fd, io_lib:format(T ++ S, []));
		_ ->
			F = add_node("WARNING REPORT: ~p - ~p~n", Pid),
			file:write(Fd, io_lib:format(T ++ F, [Format, Args]))
	end;
write_event(Fd, {Time, {info, _GL, {Pid, Info, _}}}) ->
	T = write_time(Time),
	file:write(Fd, io_lib:format(T ++ add_node("~p~n", Pid), [Info]));
write_event(Fd, {Time, {error_report, _GL, {Pid, std_error, Rep}}}) ->
	T = write_time(Time),
	S = format_report(Rep),
	file:write(Fd, io_lib:format(T ++ S ++ add_node("", Pid), []));
write_event(Fd, {Time, {info_report, _GL, {Pid, std_info, Rep}}}) ->
	T = write_time(Time, "INFO REPORT"),
	S = format_report(Rep),
	file:write(Fd, io_lib:format(T ++ S ++ add_node("", Pid), []));
write_event(Fd, {Time, {info_msg, _GL, {Pid, Format, Args}}}) ->
	T = write_time(Time, "INFO REPORT"),
	case catch io_lib:format(add_node(Format, Pid), Args) of
		S when is_list(S) ->
			file:write(Fd, io_lib:format(T ++ S, []));
		_ ->
			F = add_node("ERROR: ~p - ~p~n", Pid),
			file:write(Fd, io_lib:format(T ++ F, [Format, Args]))
	end;
write_event(_T, _H) ->
	ok.

format_report(Rep) when is_list(Rep) ->
	case string_p(Rep) of
		true ->
			io_lib:format("~s~n", [Rep]);
		_ ->
			format_rep(Rep)
	end;
format_report(Rep) ->
	io_lib:format("~p~n", [Rep]).

format_rep([{Tag, Data} | Rep]) ->
	io_lib:format("    ~p: ~p~n", [Tag, Data]) ++ format_rep(Rep);
format_rep([Other | Rep]) ->
	io_lib:format("    ~p~n", [Other]) ++ format_rep(Rep);
format_rep(_) ->
	[].

add_node(X, Pid) when is_atom(X) ->
	add_node(atom_to_list(X), Pid);
add_node(X, Pid) when node(Pid) /= node() ->
	lists:concat([X, "** at node ", node(Pid), " **~n"]);
add_node(X, _) ->
	X.

string_p([]) ->
	false;
string_p(Term) ->
	string_p1(Term).

string_p1([H | T]) when is_integer(H), H >= $\s, H < 255 ->
	string_p1(T);
string_p1([$\n | T]) -> string_p1(T);
string_p1([$\r | T]) -> string_p1(T);
string_p1([$\t | T]) -> string_p1(T);
string_p1([$\v | T]) -> string_p1(T);
string_p1([$\b | T]) -> string_p1(T);
string_p1([$\f | T]) -> string_p1(T);
string_p1([$\e | T]) -> string_p1(T);
string_p1([H | T]) when is_list(H) ->
	case string_p1(H) of
		true -> string_p1(T);
		_ -> false
	end;
string_p1([]) -> true;
string_p1(_) -> false.

write_time(Time) -> write_time(Time, "ERROR REPORT").

write_time({{Y, Mo, D}, {H, Mi, S}}, Type) ->
	io_lib:format("~n=~s==== ~w-~.2.0w-~.2.0w ~.2.0w:~.2.0w:~.2.0w ===", [Type, Y, Mo, D, H, Mi, S]).

get_cur_day() ->
	{Y, Mo, D} = date(),
	Y * 10000 + Mo * 100 +D.

get_dir(CurDay) ->
	"../log/" ++ util_data:to_list(CurDay).

get_file_name(Dir) ->
	Dir ++ "/" ++ util_data:to_list(node()) ++ ".log".
