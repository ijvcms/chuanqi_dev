%% @author qhb
%% @doc @todo Add description to util_list.


-module(util_list).

%% ====================================================================
%% API functions
%% ====================================================================
-export([
	implode/2,
	copy_elements/2,
	map/2,
	foreach/2,
	repeat/2,
	while/2,
	record_to_list/1,
	list_to_record/2,
	shuffle/1,
	store/2,
	filter_duplicate/1,
	list_statistics/1
]).

%% 在List中的每两个元素之间插入一个分隔符
implode(_S, []) ->
	[<<>>];
implode(S, L) when is_list(L) ->
	implode(S, L, []).
implode(_S, [H], NList) ->
	lists:reverse([util_data:to_list(H) | NList]);
implode(S, [H | T], NList) ->
	L = [util_data:to_list(H) | NList],
	implode(S, T, [S | L]).

copy_elements(DestList, SrcList) ->
	copy_elements_acc(DestList, SrcList, []).

copy_elements_acc(DestList, SrcList, Acc) when length(DestList) == 0 orelse length(SrcList) ->
	lists:reverse(Acc);
copy_elements_acc([D | DestLast], [S | SrcLast], Acc) ->
	case util_data:is_null(S) of
		true ->
			copy_elements_acc(DestLast, SrcLast, [D | Acc]);
		_ ->
			copy_elements_acc(DestLast, SrcLast, [S | Acc])
	end.

map(Func, List) ->
	map_index(Func, List, [], 0).

map_index(Func, [H | Last], Acc, Index) ->
	map_index(Func, Last, [Func(H, Index) | Acc], Index + 1);
map_index(_, [], Acc, _) ->
	lists:reverse(Acc).

foreach(Func, List) ->
	foreach_index(Func, List, 0).

foreach_index(_, [], _) ->
	ok;
foreach_index(Func, [H | Last], Index) ->
	Func(H, Index),
	foreach_index(Func, Last, Index + 1).

repeat(_, 0) ->
	ok;
repeat(Func, Count) ->
	Func(Count - 1),
	repeat(Func, Count - 1).

while(Func, Status) ->
	while(Func, [], Status).

while(break, Acc, _) ->
	lists:reverse(Acc);
while(Func, Acc, Status) ->
	{StatusNew, Result} = Func(Status),
	case StatusNew of
		break -> while(break, Acc, StatusNew);
		_ -> while(Func, [Result | Acc], StatusNew)
	end.

shuffle(L) ->
	Len = length(L),
	L1 = lists:map(fun(X) -> {random:uniform(Len), X} end, L),
	L2 = lists:sort(L1),
	[V || {_, V} <- L2].

%% record 转 list
%% @return 一个LIST 成员同 Record一样
record_to_list(Record) when erlang:is_tuple(Record) ->
	RecordList = erlang:tuple_to_list(Record),
	[_ | ListLeft] = RecordList,
	ListLeft;
record_to_list(_Record) ->
	[].

%% list 转 record
%% @param List 必须长度跟rocrod一样
%% @param RecordAtom record的名字,是一个原子
%% @return RecordAtom类型的RECORD
list_to_record(RecordAtom, List) ->
	RecordList = [RecordAtom | List],
	erlang:list_to_tuple(RecordList).

store(Elem, List) ->
	case lists:member(Elem, List) of
		true ->
			List;
		_ ->
			[Elem | List]
	end.

filter_duplicate(List) ->
	filter_duplicate1(List, [], #{}).

filter_duplicate1([], Acc, _) ->
	lists:reverse(Acc);
filter_duplicate1([H | Last], Acc, Map) ->
	case maps:is_key(H, Map) of
		true ->
			filter_duplicate1(Last, Acc, Map);
		false ->
			NewMap = maps:put(H, 1, Map),
			filter_duplicate1(Last, [H | Acc], NewMap)
	end.

%% 列表统计
list_statistics(List) ->
	list_statistics([], List).
list_statistics(Result, []) ->
	Result;
list_statistics(Result, [H|T]) ->
	case lists:keyfind(H, 1, Result) of
		{_H, Num} ->
			Result1 = lists:keystore(H, 1, Result, {H, Num + 1}),
			list_statistics(Result1, T);
		_ ->
			Result1 = lists:keystore(H, 1, Result, {H, 1}),
			list_statistics(Result1, T)
	end.

%% ====================================================================
%% Internal functions
%% ====================================================================
