%%%-------------------------------------------------------------------
%%% @author zhengsiying
%%% @copyright (C) 2015, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 18. 七月 2015 下午5:18
%%%-------------------------------------------------------------------
-module(util_rand).

-include("common.hrl").

%% API
-export([
	rand/2,
	list_rand/1,
	get_randlist_in_list/2,
	weight_rand/1,
	weight_rand_ex/1,
	weight_rand_2/2,
	weight_rand_3/2,
	rand_hit/1,
	weight_rand_one/1
]).

%% ====================================================================
%% API functions
%% ====================================================================
%% 产生一个介于Min到Max之间的随机整数
rand(Same, Same) -> Same;
rand(Value1, Value2) ->
	Min = min(Value1, Value2),
	Max = max(Value1, Value2),
	%% 如果没有种子，将从核心服务器中去获取一个种子，以保证不同进程都可取得不同的种子
	case get("rand_seed") of
		undefined ->
			RandSeed = mod_randseed:get_seed(),
			random:seed(RandSeed),
			put("rand_seed", RandSeed);
		_ -> skip
	end,
	if
		Max > Min ->
			M = Min - 1,
			random:uniform(Max - M) + M;
		Max < Min ->
			M = Max - 1,
			random:uniform(Min - M) + M
	end.

%% 从一个list中随机取出一项
%% null | term()
list_rand([]) -> null;
list_rand([I]) -> I;
list_rand(List) ->
	Len = length(List),
	Index = rand(1, Len),
	get_term_from_list(List, Index).
get_term_from_list(List, 1) ->
	[Term | _R] = List,
	Term;
get_term_from_list(List, Index) ->
	[_H | R] = List,
	get_term_from_list(R, Index - 1).

%% 从原列表List中获取Count个随机不重复元素（原List里面的元素必须是唯一的，不然有可能会随机到同样的元素）
get_randlist_in_list(List, Count) ->
	if
		length(List) > Count ->
			get_randlist_in_list(List, Count, []);
		true ->
			List
	end.
get_randlist_in_list(List, Count, RandList) ->
	if
		length(RandList) >= Count orelse length(List) =< 0 ->
			RandList;
		true ->
			Rand = rand(1, length(List)),
			Elem = lists:nth(Rand, List),
			get_randlist_in_list(lists:delete(Elem, List), Count, [Elem | RandList])
	end.

%% RateList为[10, 20, 30, 80, 50]这样的权重列表
%% 表示的是落在区域1的权重为10, 落在2的权重为20...
%% 返回随机的位置
weight_rand(RateList) ->
	MaxNum = lists:sum(RateList),
	RandNum = rand(1, MaxNum),
	weight_rand1(RateList, 1, RandNum).

weight_rand1([], Index, _RandNum) ->
	Index;
weight_rand1([Num | T], Index, RandNum) ->
	case Num >= RandNum of
		true ->
			Index;
		_ ->
			weight_rand1(T, Index + 1, RandNum - Num)
	end.
%% ValueRateList为[{a, 10}, {b, 20}, {c, 30}]这样的权重列表
%% ValueRateList里面的元素为{Value, Rate}, 表示出现Value的概率权重为Rate
%% value可以为任何元素
%% 返回随机出来的value
weight_rand_ex(ValueRateList) ->
	F = fun({_V, Rate}, Acc) ->
			Acc + Rate
		end,
	MaxNum = lists:foldl(F, 0, ValueRateList),
	RandNum = rand(1, MaxNum),
	weight_rand_ex1(ValueRateList, RandNum).

weight_rand_ex1([{V, _R}], _RandNum) ->
	V;
weight_rand_ex1([{V, R} | T], RandNum) ->
	case R >= RandNum of
		true ->
			V;
		_ ->
			weight_rand_ex1(T, RandNum - R)
	end.

%% 随机概率
%% RandNum表示概率为RandNum/10000
%% 成功命中返回true,否则false
rand_hit(RandNum) when is_integer(RandNum) ->
	Num = rand(1, ?PERCENT_BASE),
	Num =< RandNum;
rand_hit(RandNum) when is_float(RandNum) ->
	Num = rand(1, ?PERCENT_BASE),
	Num =< (RandNum * ?PERCENT_BASE).

%% 权重随机指定数量的列表
%% RandomList[{10, a}, {10, a}, {10, a}]这样的权重列表
%% RandomList里面的元素为{Rate, Value}, 表示出现Value的概率权重为Rate
%% value可以为任何元素
%% 返回随机出来的value列表
weight_rand_2(Num, RandomList) ->
	weight_rand_2([], Num, RandomList).

weight_rand_2(ShopList, 0, _) ->
	ShopList;
weight_rand_2(ShopList, Num, RandomList) ->
	Sum = lists:sum([X|| {X, _} <- RandomList]),
	RandValue = util_rand:rand(1, Sum),
	weight_rand_2(ShopList, Num, RandomList, RandValue, 0, RandomList).

weight_rand_2(ShopList, _Num, [], _RandValue, _Value, _RandomList) ->
	ShopList;
weight_rand_2(ShopList, Num, [H|T], RandValue, Value, RandomList) ->
	{V, M} = H,
	case V + Value >= RandValue of
		true ->
			RandomList1 = lists:delete(H, RandomList),
			weight_rand_2([M] ++ ShopList, Num - 1, RandomList1);
		false ->
			weight_rand_2(ShopList, Num, T, RandValue, Value + V, RandomList)
	end.

%% 权重随机指定数量的列表
%% RandomList[{10, a}, {10, a}, {10, a}]这样的权重列表
%% RandomList里面的元素为{Rate, Value}, 表示出现Value的概率权重为Rate
%% value可以为任何元素
%% 返回随机出来的value列表
weight_rand_3(Num, RandomList) ->
	Sum = lists:sum([X|| {X, _} <- RandomList]),
	weight_rand_3([], Num, RandomList, Sum).

weight_rand_3(ShopList, 0, _, _Sum) ->
	ShopList;
weight_rand_3(ShopList, Num, RandomList, Sum) ->
	RandValue = util_rand:rand(1, Sum),
	weight_rand_3(ShopList, Num, RandomList, RandValue, 0, RandomList, Sum).

weight_rand_3(ShopList, _Num, [], _RandValue, _Value, _RandomList, _Sum) ->
	ShopList;
weight_rand_3(ShopList, Num, [H|T], RandValue, Value, RandomList, Sum) ->
	{V, M} = H,
	case V + Value >= RandValue of
		true ->
			weight_rand_3([M] ++ ShopList, Num - 1, RandomList, Sum);
		false ->
			weight_rand_3(ShopList, Num, T, RandValue, Value + V, RandomList, Sum)
	end.

%% ====================================================================
%% Internal functions
%% ====================================================================
%% 权重随机指定数量的列表
%% RandomList[{10, a}, {10, a}, {10, a}]这样的权重列表
%% RandomList里面的元素为{Rate, Value}, 表示出现Value的概率权重为Rate
%% value可以为任何元素
%% 返回随机出来的一个权重 value
weight_rand_one(RandomList) ->
	Sum = lists:sum([X || {X, _} <- RandomList]),
	Num = util_rand:rand(1, Sum),
	weight_rand_one(Num, 0, RandomList).
weight_rand_one(Num, TempNum, []) ->
	?ERR("~p", [{Num, TempNum}]),
	yu_test:log_err();
weight_rand_one(Num, TempNum, [{Weight, Value} | H]) ->
	TempNum1 = TempNum + Weight,
	case TempNum < Num andalso Num =< TempNum1 of
		true ->
			Value;
		_ ->
			weight_rand_one(Num, TempNum1, H)
	end.