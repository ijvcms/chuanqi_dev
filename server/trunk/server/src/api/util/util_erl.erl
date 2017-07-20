%% @author qhb
%% @doc @todo Add description to util_erl.


-module(util_erl).

%% ====================================================================
%% API functions
%% ====================================================================
-export([
	ceil/1,
	floor/1,
	get_or_default/2,
	get_if/3,
	set_element/3,
	list_loop_index/2,
	rand_no_repeat/2,
	rand_no_repeat/3
]).

%% 向上取整
ceil(N) ->
	T = trunc(N),
	case (N > T) of
		true -> 1 + T;
		false -> T
	end.

%% 向下取整
floor(X) ->
	T = trunc(X),
	case (X < T) of
		true -> T - 1;
		_ -> T
	end.

get_or_default(Value, Default) ->
	case Value of
		undefined -> Default;
		_ -> Value
	end.

get_if(If, TrueValue, FalseValue) ->
	case If of
		true -> TrueValue;
		false -> FalseValue
	end.

set_element(Index, Elm, List) when is_list(List) ->
	list_loop_index(fun(E, Idx) ->
		case Idx + 1 == Index of
			true -> Elm;
			false -> E
		end
	end, List).

list_loop_index(Func, List) ->
	list_loop_index(Func, List, [], 0).

%% 取出Count个数值在Num以内的不重复的随机数，从0开始
rand_no_repeat(Count, Num) ->
	random_no_repeat(Count, 0, Num, dict:new()).

%% 取出Count个数值在(Min,Max)以内的不重复的随机数
%% [2,31,98]
rand_no_repeat(Count, Min, Max) ->
	random_no_repeat(Count, Min, Max, dict:new()).

random_no_repeat(0, _, _, AccDict) ->
	dict:fetch_keys(AccDict);
random_no_repeat(Count, Min, Max, AccDict) ->
	Rnd = random(Min, Max),
	%%Rnd = util:rand(Min, Max),
	case dict:is_key(Rnd, AccDict) of
		true -> random_no_repeat(Count, Min, Max, AccDict);
		false ->
			AccDict2 = dict:store(Rnd, Rnd, AccDict),
			random_no_repeat(Count - 1, Min, Max, AccDict2)
	end.

%% ====================================================================
%% Internal functions
%% ====================================================================

random(Same, Same) -> Same;
random(Value1, Value2) ->
	Min = min(Value1, Value2),
	Max = max(Value1, Value2),
	random:uniform(Max - (Min - 1)) + Min - 1.

list_loop_index(_Func, [], Acc, _Index) ->
	lists:reverse(Acc);
list_loop_index(Func, [H | Last], Acc, Index) ->
	list_loop_index(Func, Last, [Func(H, Index) | Acc], Index + 1).