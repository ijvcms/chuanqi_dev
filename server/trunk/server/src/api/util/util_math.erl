%%%-------------------------------------------------------------------
%%% @author zhengsiying
%%% @copyright (C) 2015, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 28. 七月 2015 上午10:02
%%%-------------------------------------------------------------------
-module(util_math).


%% API
-export([
	ceil/1,
	floor/1,
	is_positive_integer/1,
	gcd/2,
	round/2,
	get_distance/2,
	vector/2,
	unit_vector/2,
	dot_product/2,
	vector_norm/1,
	cos_vetorial_angle/2,
	vector_cumsum/1,
	vector_real_product/2,
	get_distance_set/2,
	check_rectangle/4
]).

%% ====================================================================
%% API functions
%% ====================================================================
%%向上取整
ceil(N) ->
	T = trunc(N),
	case N == T of
		true -> T;
		false -> 1 + T
	end.

%%向下取整
floor(X) ->
	T = trunc(X),
	case (X < T) of
		true -> T - 1;
		_ -> T
	end.

%% 判断是否为正整数
is_positive_integer(N) ->
	if
		is_number(N) andalso N > 0 ->
			T = ceil(N),
			if
				T == N ->
					true;
				true ->
					false
			end;
		true ->
			false
	end.

%% 求A,B的最大公约数
gcd(A, B) when is_integer(A) andalso is_integer(B) ->
	C = A div B,
	case C =:= 0 of
		true -> B;
		_ -> gcd(B, C)
	end.

%% 四舍五入到小数点后若干位
round(Var, Precision) ->
	Rate = math:pow(10, Precision),
	erlang:round(Var * Rate) / Rate.

%% 求点{x1, y1}到点{x2, y2}的距离
get_distance({X1, Y1}, {X2, Y2}) ->
	DX = X2 - X1,
	DY = Y2 - Y1,
	floor(math:sqrt(DX * DX + DY * DY)).

%% 求点{x1, y1}到点{x2, y2}的距离
get_distance_set({X1, Y1}, {X2, Y2}) ->
	DX = X2 - X1,
	DY = Y2 - Y1,
	floor(DX * DX + DY * DY).

check_rectangle({X1, Y1}, {X2, Y2}, WDis, HDis) ->
	X1 + WDis > X2 andalso X1 - WDis < X2 andalso Y1 + HDis > Y2 andalso Y1 - HDis < Y2.

%% 求点{x1, y1}到点{x2, y2}的向量
vector({X1, Y1}, {X2, Y2}) ->
	{X2 - X1, Y2 - Y1}.

%% 求点{x1, y1}到点{x2, y2}的单位向量
unit_vector({X1, Y1}, {X2, Y2}) ->
	{VX, VY} = vector({X1, Y1}, {X2, Y2}),
	D = get_distance({X1, Y1}, {X2, Y2}),
	case D > 0 of
		true ->
			{VX / D, VY / D};
		_ ->
			{1, 0}
	end.

%% 向量实数乘积
vector_real_product(Num, {X, Y}) ->
	{X * Num, Y * Num}.

%% 求向量{x1,y1}, {x2,y2}点积
dot_product({X1, Y1}, {X2, Y2}) ->
	X1 * X2 + Y1 * Y2.

%% 求向量{x,y}的模
vector_norm({X, Y}) ->
	math:sqrt(X * X + Y * Y).

%% 求向量{x1,y1}, {x2,y2}的夹角cos值
cos_vetorial_angle({X1, Y1}, {X2, Y2}) ->
	DP = dot_product({X1, Y1}, {X2, Y2}),
	VN1 = vector_norm({X1, Y1}),
	VN2 = vector_norm({X2, Y2}),
	case VN1 > 0 andalso VN2 of
		true ->
			DP / VN1 / VN2;
		_ ->
			0
	end.

%% 向量累加
vector_cumsum(VectorList) ->
	[{X, Y} | T] = VectorList,
	vector_cumsum(T, {X, Y}).

vector_cumsum([], {X, Y}) ->
	{X, Y};
vector_cumsum([{X1, Y1} | T], {X, Y}) ->
	NX = X + X1,
	NY = Y + Y1,
	vector_cumsum(T, {NX, NY}).

%% ====================================================================
%% Internal functions
%% ====================================================================
