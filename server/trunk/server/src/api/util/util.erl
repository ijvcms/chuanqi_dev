%% Author: ming
%% Created: 2012-12-2
%% Description: TODO: 公用函数
-module(util).

%%
%% Include files
%%
-include("common.hrl").
-include("record.hrl").

%%
%% Exported Functions
%%
-export([
	sleep/1,
	sleep/2,
	get_list/2,
	for/3,
	for/4,
	len_pos/2,
	get_index_of/2,
	get_local_time/0,
	add_to_dic/2,
	get_dic/1,
	config_find/2,
	get_local_day/0,
	get_prop_value/2,
	is_player_online/1,
	get_ip_str/1,
	get_uid/0,
	get_uuid32/0,
	delete_blank/1,
	reload_all/0,
	loop_functions/2,
	get_nth/2,
	start_mod/2
]).


%%
%% API Functions
%%

sleep(T) ->
	receive
	after T -> ok
	end.

sleep(T, F) ->
	receive
	after T -> F()
	end.

get_list([], _) ->
	[];
get_list(X, F) ->
	F(X).

%% for循环
for(Max, Max, F) ->
	F(Max);
for(I, Max, F) ->
	F(I),
	for(I + 1, Max, F).

%% 带返回状态的for循环
%% @return {ok, State}
for(Max, Min, _F, State) when Min < Max -> {ok, State};
for(Max, Max, F, State) -> F(Max, State);
for(I, Max, F, State) -> {ok, NewState} = F(I, State), for(I + 1, Max, F, NewState).

%% 获取一个元素在列表中的位置
len_pos(X, [H | T]) when X =:= H -> length(T) + 1;
len_pos(X, [H | T]) when X =/= H -> len_pos(X, T).

get_index_of(X, List) ->
	NewList = lists:reverse(List),
	Index = len_pos(X, NewList),
	Index.

get_local_time() ->
	{{Year, Mon, Day}, {Hour, Min, Sec}} = erlang:localtime(),
	[Year, Mon, Day, Hour, Min, Sec].

get_local_day() ->
	{_, _, Day} = date(),
	Day.

%% 往进程字典里添加进一个东西
add_to_dic(Dic, Element) ->
	List = get_dic(Dic),
	put(Dic, [Element | List]).

%% 取出一个进程字典列表 Dic必须是进程字典
get_dic(Dic) ->
	case get(Dic) of
		undefined ->
			[];
		List when is_list(List) ->
			List;
		_ ->
			[]
	end.

%%用关键字Key读取Moudle配置表里的对应信息
config_find(Moudle, Key) ->
	Moudle:get(Key).

get_prop_value(Pro, List) ->
	case proplists:get_value(Pro, List) of
		undefined ->
			"";
		Value ->
			Value
	end.

is_player_online(ID) ->
	case ets:lookup(?ETS_ONLINE, ID) of
		[_OnlinePlayer | _] ->
			true;
		_ ->
			false
	end.

get_ip_str(Socket) ->
	{ok, {{IP1, IP2, IP3, IP4}, _Port}} = inet:peername(Socket),
	lists:concat([IP1, ".", IP2, ".", IP3, ".", IP4]).

get_uid() ->
	uuid:to_string(uuid:uuid1()).

get_uuid32() ->
	Str = uuid:to_string(uuid:uuid1()),
	re:replace(Str, "-", "", [global, {return, list}]).

%% 删除一个字符串里的空格
delete_blank(Str) ->
	re:replace(Str, "\\s+", "", [global, {return, list}]).

reload_all() ->
	{ok, FileList} = file:list_dir("../ebin"),
	?DEBUG("all modules reload", []),
	F = fun(FileName) ->
		[FileStr | _] = string:tokens(FileName, "."),
		FileAtom = util_data:to_atom(FileStr),
		c:l(FileAtom)
	end,
	[F(File) || File <- FileList].

%% 检查系列条件
loop_functions(Status, []) -> {ok, Status};
loop_functions(Status, [F | T]) when is_function(F, 1) ->
	case F(Status) of
		{continue, NewStatus} -> loop_functions(NewStatus, T);
		{break, Value} -> {break, Value}
	end.

get_nth(Elem, List) ->
	get_nth1(Elem, List, 1).

get_nth1(_Elem, [], _Nth) ->
	0;
get_nth1(Elem, [T | List], Nth) ->
	case Elem =:= T of
		true ->
			Nth;
		_ ->
			get_nth1(Elem, List, Nth + 1)
	end.

%% 启动mod
start_mod(_Restart, []) ->
	ok;
start_mod(Restart, [{M} | T]) ->
	start_mod(Restart, [{M, start_link, []} | T]);
start_mod(Restart, [{M, F} | T]) ->
	start_mod(Restart, [{M, F, []} | T]);
%% 异常重启
start_mod(transient, [{M, F, A} | T]) ->
	{ok, _} = supervisor:start_child(
		server_sup,
		{M, {M, F, A}, transient, infinity, supervisor, [M]}),
	start_mod(transient, T);
%% 永久重启
start_mod(permanent, [{M, F, A} | T]) ->
	{ok, _} = supervisor:start_child(
		server_sup,
		{M, {M, F, A}, permanent, 10000, supervisor, [M]}),
	start_mod(permanent, T).

%%
%% Local Functions
%%
