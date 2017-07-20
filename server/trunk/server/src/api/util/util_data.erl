%%%-------------------------------------------------------------------
%%% @author zhengsiying
%%% @copyright (C) 2015, <COMPANY>
%%% @doc
%%%		通用数据函数
%%% @end
%%% Created : 18. 七月 2015 下午5:02
%%%-------------------------------------------------------------------
-module(util_data).


%% API
-export([
	term_to_string/1,
	term_to_bitstring/1,
	string_to_term/1,
	bitstring_to_term/1,
	to_integer/1,
	to_binary/1,
	to_atom/1,
	list_to_atom2/1,
	to_list/1,
	f2s/1,
	is_null/1,
	add_goodslist/2,
	replace_by_keyword/2,
	my_exec/1,
	is_int/1,
	check_pid/1,
	get_ip/1,
	get_value/2
]).

%% ====================================================================
%% API functions
%% ====================================================================
%% term序列化，term转换为string格式，e.g., [{a},1] => "[{a},1]"
term_to_string(Term) ->
	binary_to_list(list_to_binary(io_lib:format("~p", [Term]))).

%% term序列化，term转换为bitstring格式，e.g., [{a},1] => <<"[{a},1]">>
term_to_bitstring(Term) ->
	erlang:list_to_bitstring(io_lib:format("~p", [Term])).

%% term反序列化，string转换为term，e.g., "[{a},1]"  => [{a},1]
string_to_term(undefined) -> [];
string_to_term(String) when is_binary(String) ->
	string_to_term(binary_to_list(String));
string_to_term(String) ->
	case erl_scan:string(String ++ ".") of
		{ok, Tokens, _} ->
			case erl_parse:parse_term(Tokens) of
				{ok, Term} -> Term;
				_Err -> undefined
			end;
		_Error ->
			undefined
	end.

%% term反序列化，bitstring转换为term，e.g., <<"[{a},1]">>  => [{a},1]
bitstring_to_term(undefined) -> undefined;
bitstring_to_term(BitString) ->
	string_to_term(binary_to_list(BitString)).

%%转化为整数
to_integer(Msg) when is_integer(Msg) ->
	Msg;
to_integer(Msg) when is_binary(Msg) ->
	Msg2 = binary_to_list(Msg),
	list_to_integer(Msg2);
to_integer(Msg) when is_list(Msg) ->
	list_to_integer(Msg);
to_integer(Msg) when is_float(Msg) ->
	round(Msg);
to_integer(_Msg) ->
	throw(other_value).

%% @doc convert other type to binary
to_binary(Msg) when is_binary(Msg) ->
	Msg;
to_binary(Msg) when is_atom(Msg) ->
	list_to_binary(atom_to_list(Msg));
%%atom_to_binary(Msg, utf8);
to_binary(Msg) when is_list(Msg) ->
	list_to_binary(Msg);
to_binary(Msg) when is_integer(Msg) ->
	list_to_binary(integer_to_list(Msg));
to_binary(Msg) when is_float(Msg) ->
	list_to_binary(f2s(Msg));
to_binary(Msg) when is_tuple(Msg) ->
	list_to_binary(tuple_to_list(Msg));
to_binary(_Msg) ->
	throw(other_value).

%% @doc convert other type to atom
to_atom(Msg) when is_atom(Msg) ->
	Msg;
to_atom(Msg) when is_binary(Msg) ->
	list_to_atom2(binary_to_list(Msg));
to_atom(Msg) when is_list(Msg) ->
	list_to_atom2(Msg);
to_atom(_) ->
	throw(other_value).  %%list_to_atom("").

list_to_atom2(List) when is_list(List) ->
	case catch (list_to_existing_atom(List)) of
		{'EXIT', _} -> erlang:list_to_atom(List);
		Atom when is_atom(Atom) -> Atom
	end.

%% @doc convert other type to list
to_list(Msg) when is_list(Msg) ->
	Msg;
to_list(Msg) when is_atom(Msg) ->
	atom_to_list(Msg);
to_list(Msg) when is_binary(Msg) ->
	binary_to_list(Msg);
to_list(Msg) when is_integer(Msg) ->
	integer_to_list(Msg);
to_list(Msg) when is_float(Msg) ->
	f2s(Msg);
to_list(Msg) when is_tuple(Msg) ->
	tuple_to_list(Msg);
to_list(_) ->
	throw(other_value).

%% f2s(1.5678) -> 1.57 四舍五入
f2s(N) when is_integer(N) ->
	integer_to_list(N) ++ ".00";
f2s(F) when is_float(F) ->
	[A] = io_lib:format("~.2f", [F]),
	A.

is_null(N) ->
	case N of
		null -> true;
		undefined -> true;
		_ -> false
	end.

is_int(N) when is_list(N) ->
	try
		list_to_integer(N)
	catch
		_ERR:_Info ->
			false
	end;
is_int(N) ->
	N1 = erlang:binary_to_list(N),
	is_int(N1).

%% 添加组合道具列表
add_goodslist(GooosList, AddGoodsList) ->
	F1 =
		fun(X, List) ->
			{GoodsId, IsBind, Num} = X,
			F2 = fun({GoodsId1, IsBind1, Num1}, List1) ->
				case GoodsId =:= GoodsId1 andalso IsBind =:= IsBind1 of
					true ->
						[{GoodsId, IsBind, Num + Num1} | List1];
					_ ->
						[{GoodsId1, IsBind1, Num1} | List1]
				end
			end,
			lists:foldr(F2, [], List)
		end,
	lists:foldl(F1, GooosList, AddGoodsList).

replace_by_keyword(BinMsg, Keyword) ->
	RegExp = list_to_binary(".*" ++ binary_to_list(Keyword) ++ ".*"),
	case re:compile(Keyword, [caseless]) of
		{ok, Mp} ->
			case re:run(BinMsg, RegExp) of
				nomatch -> BinMsg;
				{match, _} -> re:replace(BinMsg, Mp, <<"***">>, [global, {return, binary}])
			end;
		{error, _} -> BinMsg
	end.

%% ====================================================================
%% Internal functions
%% ====================================================================
%% 直接cmd shell命令
my_exec(Command) ->
	Port = open_port({spawn, Command}, [stream, in, eof, hide, exit_status]),
	Result = get_data(Port, []),
	Result.

get_data(Port, Sofar) ->
	receive
		{Port, {data, Bytes}} ->
			get_data(Port, [Sofar | Bytes]);
		{Port, eof} ->
			Port ! {self(), close},
			receive
				{Port, closed} ->
					true
			end,
			receive
				{'EXIT', Port, _} ->
					ok
			after 1 ->              % force context switch
				ok
			end,
			ExitCode =
				receive
					{Port, {exit_status, Code}} ->
						Code
				end,
			{ExitCode, lists:flatten(Sofar)}
	end.


%% 判断pid是否存活
check_pid(Pid) ->
	case is_pid(Pid) of
		true ->
			rpc:call(node(Pid), erlang, is_process_alive, [Pid]);
		_ ->
			false
	end.

get_ip(Socket) ->
	try
		{ok, {{IP1, IP2, IP3, IP4}, _Port}} = inet:peername(Socket),
		%% erlang原生代码
		%% inets:start(),
		%% ssl:start(),
		lists:concat([IP1, ".", IP2, ".", IP3, ".", IP4])
	catch
		_:_ ->
			""
	end.

get_value(N, N1) ->
	case N of
		null -> N1;
		undefined -> N1;
		_ -> N
	end.
