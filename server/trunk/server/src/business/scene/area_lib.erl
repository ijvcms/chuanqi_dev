%%%-------------------------------------------------------------------
%%% @author zhengsiying
%%% @copyright (C) 2015, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 27. 七月 2015 下午7:59
%%%-------------------------------------------------------------------
-module(area_lib).

-include("common.hrl").
-include("config.hrl").
-include("record.hrl").

%%%--------------------------------------------------------
%% 定义一屏为1136*640像素，每个小格为30*30像素，所以一屏的大小为
%% 38*22个格子（1136/64=18，640/64=10）将一副地图分成N个30*30
%% 的小格子，每个格子表示一个坐标点；将一副地图分成M个大区域，每个
%% 区域大概一屏大小，用于同屏广播
%%%--------------------------------------------------------
%% 注意：以下的定义全部使用格子坐标非像素坐标
%% 一屏大小
-define(SCREEN_WIDTH, 18).
-define(SCREEN_HIGH, 10).

%% 将后端一屏分为九宫格大小
%%-define(AREA_WIDTH, 6).
%%-define(AREA_HIGH, 4).
%% 将后端一屏分为九宫格大小
-define(AREA_WIDTH, 12).
-define(AREA_HIGH, 8).
%% -define(AREA_WIDTH, 2).
%% -define(AREA_HIGH, 2).

%% API
-export([
	get_area_id/3,
	get_grid_flag/2,
	get_border_area/3,
	get_screen_area/3,
	is_in_area/2,
	is_in_screen/2,
	get_path/3,
	get_line_path/3,
	get_direction/2,
	get_round_point_list/3,
	get_round_off_point_list/3,
	get_round_border/3,
	is_in_safety_area/2,
	is_same_point/2,
	rigid_check_direction/3,
	get_direction_round_point/3,
	can_move/2,
	get_line_farthest/3,
	get_path/5,
	get_rand_walk_point/1
]).

%% ====================================================================
%% API functions
%% ====================================================================
%% 获取区域id
get_area_id({X, Y}, Width, High) ->
	case X > Width orelse Y > High orelse X < 0 orelse Y < 0 of
		true ->
			0;
		_ ->
			max(0, (Y div ?AREA_HIGH)) * util_math:ceil(Width / ?AREA_WIDTH) + max(1, util_math:ceil(X / ?AREA_WIDTH))
	end.

get_grid_flag(SceneId, {X, Y}) ->
	SceneConf = scene_config:get(SceneId),
	Mod = SceneConf#scene_conf.map_data,
	{Width, High} = Mod:range(),
	MapData = Mod:data(),
	get_grid_flag(MapData, Width, High, {X, Y}).

can_move(SceneId, {X, Y}) ->
	case get_grid_flag(SceneId, {X, Y}) of
		?GRID_FLAG_OFF ->
			false;
		_ ->
			true
	end.

%% 获取相邻区域(坐标系为左上角为原点，X轴向右为正方向，Y轴向下为正方向)
get_border_area({X, Y}, Width, High) ->
	X1 = max(X - (?AREA_WIDTH div 2), 0),
	X2 = min(X + (?AREA_WIDTH div 2), Width),
	Y1 = max(Y - (?AREA_HIGH div 2), 0),
	Y2 = min(Y + (?AREA_HIGH div 2), High),

	%% 计算自己所在区域
	AreaId0 = get_area_id({X, Y}, Width, High),
	%% 计算左上角坐标所在区域
	AreaId1 = get_area_id({X1, Y1}, Width, High),
	%% 计算右上角坐标所在区域
	AreaId2 = get_area_id({X2, Y1}, Width, High),
	%% 计算左下角坐标所在区域
	AreaId3 = get_area_id({X1, Y2}, Width, High),
	%% 计算右下角坐标所在区域
	AreaId4 = get_area_id({X2, Y2}, Width, High),

	%% 去除无效区域和重复区域
	Map0 = maps:put(AreaId0, AreaId0, maps:new()),
	Map1 = maps:put(AreaId1, AreaId1, Map0),
	Map2 = maps:put(AreaId2, AreaId2, Map1),
	Map3 = maps:put(AreaId3, AreaId3, Map2),
	Map4 = maps:put(AreaId4, AreaId4, Map3),
	F = fun(K, _V, Acc) ->
		case K > 0 of
			true ->
				[K | Acc];
			_ ->
				Acc
		end
	end,
	maps:fold(F, [], Map4).

get_screen_area({X, Y}, Width, High) ->
	case ets:lookup(?ETS_AREA_ID_LIST, {X, Y, Width, High}) of
		[R | _] ->
			R#ets_area_id_list.list;
		_ ->
			X1 = max(X - (?SCREEN_WIDTH div 2), 0),
			X2 = min(X + (?SCREEN_WIDTH div 2), Width),
			Y1 = max(Y - (?SCREEN_HIGH div 2), 0),
			Y2 = min(Y + (?SCREEN_HIGH div 2), High),

			%% 计算一行有多少格
			LineNum = util_math:ceil(Width / ?AREA_WIDTH),

			%% 计算左上角坐标所在区域
			AreaId1 = get_area_id({X1, Y1}, Width, High),
			%% 计算右上角坐标所在区域
			AreaId2 = get_area_id({X2, Y1}, Width, High),
			%% 计算左下角坐标所在区域
			AreaId3 = get_area_id({X1, Y2}, Width, High),
			%% 计算右下角坐标所在区域
			%% AreaId4 = get_area_id({X2, Y2}, Width, High),

			%% 推演出包含的其他区域id
			%% 计算出最左边包含的区域id
			List = lists:seq(AreaId1, AreaId3, LineNum),

			%% 计算行长度
			WidthLen = AreaId2 - AreaId1,
			%% 计算出每一行的area id
			NewList = compute_line_area(List, WidthLen, 0, []),
			ets:insert(?ETS_AREA_ID_LIST, #ets_area_id_list{x_y_witgh_high = {X, Y, Width, High}, list = NewList}),
			NewList
	end.




compute_line_area([], _WidthLen, _N, List) ->
	List;
compute_line_area([H | T] = L, WidthLen, N, List) ->
	NewList = [H + N | List],
	case N < WidthLen of
		true ->
			compute_line_area(L, WidthLen, N + 1, NewList);
		_ ->
			compute_line_area(T, WidthLen, 0, NewList)
	end.

%% 通过A星求出两点间的路径
get_path(_SceneId, {X, Y}, {X, Y}) ->
	[{X, Y}];
get_path(SceneId, {BX, BY}, {EX, EY}) ->
	SceneConf = scene_config:get(SceneId),
	Mod = SceneConf#scene_conf.map_data,
	{Width, High} = Mod:range(),
	MapData = Mod:data(),
	Flag1 = get_grid_flag(MapData, Width, High, {BX, BY}),
	Flag2 = get_grid_flag(MapData, Width, High, {EX, EY}),
	case Flag1 =/= ?GRID_FLAG_OFF andalso Flag2 =/= ?GRID_FLAG_OFF of
		true ->
			OpenDict = dict:new(),
			H = util_math:get_distance({BX, BY}, {EX, EY}),
			ClosedDict = dict:store({BX, BY}, {null, {0, H, H}}, dict:new()),
			FDict = dict:new(),
			FList = [],
			make_path(0, MapData, Width, High, {BX, BY}, {EX, EY}, OpenDict, ClosedDict, FDict, FList, {BX, BY});
		_ ->
			[]
	end.

get_line_path(_SceneId, {X, Y}, {X, Y}) ->
	[{X, Y}];
get_line_path(SceneId, {BX, BY}, {EX, EY}) ->
	SceneConf = scene_config:get(SceneId),
	Mod = SceneConf#scene_conf.map_data,
	{Width, High} = Mod:range(),
	MapData = Mod:data(),
	Flag1 = get_grid_flag(MapData, Width, High, {BX, BY}),
	Flag2 = get_grid_flag(MapData, Width, High, {EX, EY}),
	case Flag1 =/= ?GRID_FLAG_OFF andalso Flag2 =/= ?GRID_FLAG_OFF of
		true ->
			Dist = util_math:get_distance({BX, BY}, {EX, EY}),
			%% 计算单位距离x轴和y轴增量
			XInc = (EX - BX) / Dist,
			YInc = (EY - BY) / Dist,
			make_line_path(1, erlang:round(Dist), MapData, Width, High, {BX, BY}, XInc, YInc, [{BX, BY}]);
		_ ->
			[]
	end.

%% 获取{bx, by}到{ex, ey}的直线上最远可行走点
get_line_farthest(_SceneId, {X, Y}, {X, Y}) ->
	{X, Y};
get_line_farthest(SceneId, {BX, BY}, {EX, EY}) ->
	SceneConf = scene_config:get(SceneId),
	Mod = SceneConf#scene_conf.map_data,
	{Width, High} = Mod:range(),
	MapData = Mod:data(),
	Dist = util_math:get_distance({BX, BY}, {EX, EY}),
	%% 计算单位距离x轴和y轴增量
	XInc = (EX - BX) / Dist,
	YInc = (EY - BY) / Dist,
	get_line_farthest1(1, erlang:round(Dist), MapData, Width, High, {BX, BY}, XInc, YInc, {BX, BY}).

get_line_farthest1(N, Dist, MapData, Width, High, {BX, BY}, XInc, YInc, Point) ->
	case N >= Dist of
		true ->
			Point;
		_ ->
			X = erlang:round(BX + N * XInc),
			Y = erlang:round(BY + N * YInc),
			Flag = get_grid_flag(MapData, Width, High, {X, Y}),
			case Flag =:= ?GRID_FLAG_OFF of
				true ->
					Point;
				_ ->
					get_line_farthest1(N + 1, Dist, MapData, Width, High, {BX, BY}, XInc, YInc, {X, Y})
			end
	end.

make_line_path(N, Dist, MapData, Width, High, {BX, BY}, XInc, YInc, Path) ->
	case N >= Dist of
		true ->
			lists:reverse(Path);
		_ ->
			X = erlang:round(BX + N * XInc),
			Y = erlang:round(BY + N * YInc),
			Flag = get_grid_flag(MapData, Width, High, {X, Y}),
			case Flag =:= ?GRID_FLAG_OFF of
				true ->
					lists:reverse(Path);
				_ ->
					NewPath = util_list:store({X, Y}, Path),
					make_line_path(N + 1, Dist, MapData, Width, High, {BX, BY}, XInc, YInc, NewPath)
			end
	end.

%% 获取周围可走列表
get_round_point_list(SceneId, {X, Y}, Radius) ->
	SceneConf = scene_config:get(SceneId),
	Mod = SceneConf#scene_conf.map_data,
	{Width, High} = Mod:range(),
	MapData = Mod:data(),
	all_round_point(MapData, Width, High, {X, Y}, -Radius, -Radius, Radius, [], [?GRID_FLAG_ON, ?GRID_FLAG_LUCENCY]).

%% 获取周围不可走点
get_round_off_point_list(SceneId, {X, Y}, Radius) ->
	SceneConf = scene_config:get(SceneId),
	Mod = SceneConf#scene_conf.map_data,
	{Width, High} = Mod:range(),
	MapData = Mod:data(),
	all_round_point(MapData, Width, High, {X, Y}, -Radius, -Radius, Radius, [], [?GRID_FLAG_OFF]).

all_round_point(MapData, Width, High, {X, Y}, XInc, YInc, Radius, Path, FlagList) ->
	X1 = X + XInc,
	Y1 = Y + YInc,
	Flag = get_grid_flag(MapData, Width, High, {X1, Y1}),
	NewPath =
		case lists:member(Flag, FlagList) of
			true ->
				[{X1, Y1} | Path];
			_ ->
				Path
		end,
	case XInc >= Radius andalso YInc >= Radius of
		true ->
			NewPath;
		_ ->
			case YInc >= Radius of
				true ->
					all_round_point(MapData, Width, High, {X, Y}, XInc + 1, -Radius, Radius, NewPath, FlagList);
				_ ->
					all_round_point(MapData, Width, High, {X, Y}, XInc, YInc + 1, Radius, NewPath, FlagList)
			end
	end.

%% 获取距离中心点{x,y}，radius格的方框坐标点
get_round_border(SceneId, {X, Y}, Radius) ->
	SceneConf = scene_config:get(SceneId),
	Mod = SceneConf#scene_conf.map_data,

	%% 找出边框坐标
	List3 =
		case Radius > 0 of
			true ->
				ListLeft = [{X - Radius, Y + YInc1} || YInc1 <- lists:seq(-Radius, Radius, 1)],
				ListDown = [{X + XInc1, Y - Radius} || XInc1 <- lists:seq(Radius, 1 - Radius, -1)],
				ListRight = [{X + Radius, Y + YInc2} || YInc2 <- lists:seq(Radius, 1 - Radius, -1)],
				ListUp = [{X + XInc2, Y + Radius} || XInc2 <- lists:seq(1 - Radius, Radius - 1, 1)],

				List1 = ListLeft ++ ListDown,
				List2 = ListRight ++ List1,
				ListUp ++ List2;
			_ ->
				[{X, Y}]
		end,

	%% 过滤掉不可走的点
	{Width, High} = Mod:range(),
	MapData = Mod:data(),

	F = fun({X1, Y1}) ->
		Flag = get_grid_flag(MapData, Width, High, {X1, Y1}),
		Flag /= ?GRID_FLAG_OFF
	end,
	lists:filter(F, List3).

%% %% 获取x2,y2 相对于点 x1,y1 的朝向
%% get_direction({X1, Y1}, {X2, Y2}) ->
%% 	if
%% 		X2 == X1 andalso Y2 >= Y1 -> ?DIRECTION_UP;
%% 		X2 == X1 andalso Y2 < Y1 -> ?DIRECTION_DOWN;
%% 		Y2 == Y1 andalso X2 >= X1 -> ?DIRECTION_RIGHT;
%% 		Y2 == Y1 andalso X2 < X1 -> ?DIRECTION_LEFT;
%% 		true ->
%% 			Pi = math:pi(),
%% 			A = (Y2 - Y1) / (X2 - X1),
%% 			A1 = math:tan(-3/8*Pi),
%% 			A2 = math:tan(-1/8*Pi),
%% 			A3 = math:tan(1/8*Pi),
%% 			A4 = math:tan(3/8*Pi),
%% 			if
%% 				A =< A1 andalso Y2 >= Y1 -> ?DIRECTION_UP;
%% 				A =< A1 andalso Y2 < Y1 -> ?DIRECTION_DOWN;
%% 				A1 < A andalso A < A2 andalso Y2 >= Y1 -> ?DIRECTION_UP_LEFT;
%% 				A1 < A andalso A < A2 andalso Y2 < Y1 -> ?DIRECTION_DOWN_RIGHT;
%% 				A2 =< A andalso A =< A3 andalso X2 >= X1 -> ?DIRECTION_RIGHT;
%% 				A2 =< A andalso A =< A3 andalso X2 < X1 -> ?DIRECTION_LEFT;
%% 				A3 < A andalso A < A4 andalso X2 >= X1 -> ?DIRECTION_UP_RIGHT;
%% 				A3 < A andalso A < A4 andalso X2 < X1 -> ?DIRECTION_DOWN_LEFT;
%% 				A >= A4 andalso Y2 >= Y1 -> ?DIRECTION_UP;
%% 				A >= A4 andalso Y2 < Y1 -> ?DIRECTION_DOWN;
%% 				true -> ?DIRECTION_UP
%% 			end
%% 	end.
%% 获取x2,y2 相对于点 x1,y1 的朝向
get_direction({X1, Y1}, {X2, Y2}) ->
	if
		X2 == X1 andalso Y2 >= Y1 -> ?DIRECTION_UP;
		X2 == X1 andalso Y2 < Y1 -> ?DIRECTION_DOWN;
		Y2 == Y1 andalso X2 >= X1 -> ?DIRECTION_RIGHT;
		Y2 == Y1 andalso X2 < X1 -> ?DIRECTION_LEFT;
		Y2 > Y1 andalso X2 > X1 -> ?DIRECTION_UP_RIGHT;
		Y2 < Y1 andalso X2 > X1 -> ?DIRECTION_DOWN_RIGHT;
		Y2 > Y1 andalso X2 < X1 -> ?DIRECTION_UP_LEFT;
		Y2 < Y1 andalso X2 < X1 -> ?DIRECTION_UP_LEFT;
		true ->
			?DIRECTION_UP
	end.

%% 严格检查朝向
rigid_check_direction({X1, Y1}, {X2, Y2}, Dire) ->
	Temp = get_direction({X1, Y1}, {X2, Y2}),
	Temp =:= Dire.

%% 判断坐标{x,y}是否在场景的安全区中
is_in_safety_area(SceneId, {X, Y}) ->
	SceneConf = scene_config:get(SceneId),
	SafetyArea = SceneConf#scene_conf.safety_area,
	is_in_safety_area1(SafetyArea, {X, Y}).

is_in_safety_area1([], {_X, _Y}) ->
	false;
is_in_safety_area1([{{BX, BY}, {EX, EY}} | T], {X, Y}) ->
	case is_in_area({X, Y}, {?AREA_TYPE_RECTANGLE, {BX, BY}, {EX, EY}}) of
		true ->
			true;
		_ ->
			is_in_safety_area1(T, {X, Y})
	end.

is_same_point({X, Y}, {X, Y}) -> true;
is_same_point(_P1, _P2) -> false.

%% ----------------------------------------------------
%% 判断坐标点Point是否落在固定区域Area内
%% Point: {x, y}
%% Area: {area_type, ...}
%% ----------------------------------------------------
%% 判断点(x, y)是否落在点(bx, by),(ex, ey)确定的矩形区域内
is_in_area({X, Y}, {?AREA_TYPE_RECTANGLE, {BX, BY}, {EX, EY}}) ->
	MinX = min(BX, EX),
	MaxX = max(BX, EX),
	MinY = min(BY, EY),
	MaxY = max(BY, EY),
	MinX =< X andalso X =< MaxX andalso MinY =< Y andalso Y =< MaxY;
%% 判断点(x, y)是否落在圆心(cx, cy)半径为Radius的园上
is_in_area({X, Y}, {?AREA_TYPE_CIRCLE, {CX, CY}, Radius}) ->
	Dist = util_math:get_distance_set({X, Y}, {CX, CY}),
	Dist =< Radius * Radius;
%% 判断点(x, y)是否落在由(x1,y1), (x2,y2)组成的线上，并且距离(x1,y1)小于Dist
is_in_area({X, Y}, {?AREA_TYPE_LINE, {X1, Y1}, {X2, Y2}, Dist}) ->
	D1 = get_direction({X1, Y1}, {X2, Y2}),
	Dist1 = util_math:get_distance_set({X, Y}, {X1, Y1}),
	(rigid_check_direction({X1, Y1}, {X, Y}, D1) orelse {X, Y} =:= {X2, Y2}) andalso Dist1 =< Dist * Dist;
is_in_area(_Point, _Area) ->
	false.

%% 判断点(x1, y1)是否落在以(x, y)为中心点的屏幕内
is_in_screen({X, Y}, {X1, Y1}) ->
	BX = X - (?SCREEN_WIDTH div 2),
	BY = Y - (?SCREEN_HIGH div 2),
	EX = X + (?SCREEN_WIDTH div 2),
	EY = Y + (?SCREEN_HIGH div 2),
	is_in_area({X1, Y1}, {?AREA_TYPE_RECTANGLE, {BX, BY}, {EX, EY}}).



get_direction_round_point({X, Y}, Dire, SceneId) ->
	SceneConf = scene_config:get(SceneId),
	MapMod = SceneConf#scene_conf.map_data,
	MapData = MapMod:data(),
	{W, H} = MapMod:range(),
	{X1, Y1} =
		case Dire of
			?DIRECTION_UP -> {X, Y + 1};
			?DIRECTION_UP_RIGHT -> {X + 1, Y + 1};
			?DIRECTION_RIGHT -> {X + 1, Y};
			?DIRECTION_DOWN_RIGHT -> {X + 1, Y - 1};
			?DIRECTION_DOWN -> {X, Y - 1};
			?DIRECTION_DOWN_LEFT -> {X - 1, Y - 1};
			?DIRECTION_LEFT -> {X - 1, Y};
			?DIRECTION_UP_LEFT -> {X - 1, Y + 1};
			_ -> {X, Y}
		end,
	case get_grid_flag(MapData, W, H, {X1, Y1}) of
		?GRID_FLAG_OFF ->
			case get_round_border(SceneId, {X, Y}, 1) of
				[] ->
					{X, Y};
				PointList ->
					util_rand:list_rand(PointList)
			end;
		_ ->
			{X1, Y1}
	end.

%% ====================================================================
%% Internal functions
%% ====================================================================
get_grid_flag(MapData, Width, High, {X, Y}) ->
	case X =< Width andalso Y =< High andalso X >= 1 andalso Y >= 1 of
		true ->
			D1 = element(Y, MapData),
			element(X, D1);
		_ ->
			?GRID_FLAG_OFF
	end.

make_path(
	SearchNum, _MapData, _Width,
	_High, Point, _EndPoint, _OpenDict,
	ClosedDict, _FDict, _FList, _OptimalPoint) when SearchNum >= 10000 ->
	make_path1(ClosedDict, Point, [Point]);
make_path(
	SearchNum, MapData, Width,
	High, Point, EndPoint, OpenDict,
	ClosedDict, FDict, FList, OptimalPoint) ->
	case dict:find(EndPoint, ClosedDict) of
		{ok, _} ->
			make_path1(ClosedDict, EndPoint, [EndPoint]);
		_ ->
			case SearchNum /= 0 andalso dict:size(OpenDict) == 0 of
				true ->
					make_path1(ClosedDict, OptimalPoint, [OptimalPoint]);
				_ ->
					NewOpenPointList = get_border_on_point(MapData, Width, High, Point),
					{OpenDict1, FDict1, FList1} =
						open_dict_add(NewOpenPointList, Point, EndPoint, OpenDict, ClosedDict, FDict, FList),

					{ChoosePoint, NewOpenDict, NewClosedDict, NewFDict, NewFList} =
						choose_priority_point(OpenDict1, ClosedDict, FDict1, FList1),

					{ok, {_, {_, H1, _}}} = dict:find(OptimalPoint, NewClosedDict),
					{ok, {_, {_, H2, _}}} = dict:find(ChoosePoint, NewClosedDict),
					%% ?INFO("p1:~p, h1:~p, p2:~p, h2:~p", [OptimalPoint, H1, ChoosePoint, H2]),
					NewOptimalPoint =
						case H1 > H2 of
							true ->
								ChoosePoint;
							_ ->
								OptimalPoint
						end,
					make_path(SearchNum + 1, MapData, Width, High, ChoosePoint, EndPoint,
						NewOpenDict, NewClosedDict, NewFDict, NewFList, NewOptimalPoint)
			end
	end.

make_path1(ClosedDict, Point, PathList) ->
	case dict:find(Point, ClosedDict) of
		{ok, {FrontPoint, _F}} ->
			case FrontPoint =:= null of
				true ->
					PathList;
				_ ->
					make_path1(ClosedDict, FrontPoint, [FrontPoint | PathList])
			end;
		_ ->
			PathList
	end.

get_border_on_point(MapData, Width, High, {X, Y}) ->
	ObliqueDist = 1.4,    %% 斜方向距离增量
	PositiveDist = 1,    %% 正方向距离增量
	LUP = {X - 1, Y - 1},    %% 左上角坐标
	LP = {X - 1, Y},        %% 正左坐标
	LDP = {X - 1, Y + 1},    %% 左下角坐标
	UP = {X, Y - 1},        %% 正上坐标
	DP = {X, Y + 1},        %% 正下坐标
	RUP = {X + 1, Y - 1},    %% 右上角坐标
	RP = {X + 1, Y},        %% 正右坐标
	RDP = {X + 1, Y + 1},    %% 右下角坐标

	LUFlag = get_grid_flag(MapData, Width, High, LUP),
	LFlag = get_grid_flag(MapData, Width, High, LP),
	LDFlag = get_grid_flag(MapData, Width, High, LDP),
	UFlag = get_grid_flag(MapData, Width, High, UP),
	DFlag = get_grid_flag(MapData, Width, High, DP),
	RUFlag = get_grid_flag(MapData, Width, High, RUP),
	RFlag = get_grid_flag(MapData, Width, High, RP),
	RDFlag = get_grid_flag(MapData, Width, High, RDP),

	A1 = LUFlag /= ?GRID_FLAG_OFF andalso (LFlag /= ?GRID_FLAG_OFF orelse UFlag /= ?GRID_FLAG_OFF),
	A2 = LFlag /= ?GRID_FLAG_OFF,
	A3 = LDFlag /= ?GRID_FLAG_OFF andalso (LFlag /= ?GRID_FLAG_OFF orelse DFlag /= ?GRID_FLAG_OFF),
	A4 = UFlag /= ?GRID_FLAG_OFF,
	A5 = DFlag /= ?GRID_FLAG_OFF,
	A6 = RUFlag /= ?GRID_FLAG_OFF andalso (RFlag /= ?GRID_FLAG_OFF orelse UFlag /= ?GRID_FLAG_OFF),
	A7 = RFlag /= ?GRID_FLAG_OFF,
	A8 = RDFlag /= ?GRID_FLAG_OFF andalso (RFlag /= ?GRID_FLAG_OFF orelse DFlag /= ?GRID_FLAG_OFF),

	List = [{A1, LUP, ObliqueDist}, {A2, LP, PositiveDist}, {A3, LDP, ObliqueDist}, {A4, UP, PositiveDist},
		{A5, DP, PositiveDist}, {A6, RUP, ObliqueDist}, {A7, RP, PositiveDist}, {A8, RDP, ObliqueDist}],
	[{Point, Dist} || {IsOk, Point, Dist} <- List, IsOk =:= true].

open_dict_add([], _FrontPoint, _EndPoint, OpenDict, _ClosedDict, FDict, FList) ->
	{OpenDict, FDict, FList};
open_dict_add([{Point, Dist} | T], FrontPoint, EndPoint, OpenDict, ClosedDict, FDict, FList) ->
	case dict:find(Point, OpenDict) of
		{ok, _} ->
			open_dict_add(T, FrontPoint, EndPoint, OpenDict, ClosedDict, FDict, FList);
		_ ->
			case dict:find(Point, ClosedDict) of
				{ok, _} ->
					open_dict_add(T, FrontPoint, EndPoint, OpenDict, ClosedDict, FDict, FList);
				_ ->
					{ok, {_FP, {_G, _H, _F}}} = dict:find(FrontPoint, ClosedDict),
					G = _G + Dist,
					H = util_math:get_distance(Point, EndPoint),
					F = G + H,
					NewOpenDict = dict:store(Point, {FrontPoint, {G, H, F}}, OpenDict),
					{NewFDict, NewFList} =
						case dict:find(F, FDict) of
							{ok, PointList} ->
								NewList = util_list:store(Point, PointList),
								{dict:store(F, NewList, FDict), FList};
							_ ->
								{dict:store(F, [Point], FDict), [F | FList]}
						end,
					open_dict_add(T, FrontPoint, EndPoint, NewOpenDict, ClosedDict, NewFDict, NewFList)
			end
	end.

choose_priority_point(OpenDict, ClosedDict, FDict, FList) ->
	MinF = lists:min(FList),
	{ok, List} = dict:find(MinF, FDict),
	[Point | NewList] = List,
	{ok, V} = dict:find(Point, OpenDict),
	NewClosedDict = dict:store(Point, V, ClosedDict),
	NewOpenDict = dict:erase(Point, OpenDict),
	{NewFDict, NewFList} =
		case NewList =:= [] of
			true ->
				{dict:erase(MinF, FDict), lists:delete(MinF, FList)};
			_ ->
				{dict:store(MinF, NewList, FDict), FList}
		end,
	{Point, NewOpenDict, NewClosedDict, NewFDict, NewFList}.

%% ====================================================================
%% A*算法
%% ====================================================================

%%获取场景SceneId中{X1,Y1}到{X2,Y2}的最近线路点列表
%% 返回[{X1,Y1}，{X2,Y2}……]没包括起点包括了终点
get_path(SceneId, X1, Y1, X2, Y2) ->
	Start = {X1, Y1},
	Target = {X2, Y2},
	case area_lib:can_move(SceneId, {X2, Y2}) of
		false ->
			[{X1, Y1}];
		true ->
			get_walk_path(SceneId, Start, Target)
	end.

%%A星算法获取线路函数
get_walk_path(SceneId, Start, Target) ->
	OpenList = dict:store(Start, {Start, 0}, dict:new()),  %%开放列表 存储待处理的点
	WalkList = dict:store(Start, {Start, 0}, dict:new()),  %%路线列表 存储路线点
	CloseList = dict:new(),       %%封闭列表  存放已处理的节点
	WalkList2 = get_nodes(SceneId, Start, Target, OpenList, CloseList, WalkList),  %%获取路线开始
	WalkList2 ++ [Target].

get_nodes(SceneId, Start, Target, OpenList, CloseList, WalkList) ->
	{Tx, Ty} = Target,
	{CurNode, G} = getBestNode(OpenList, Target),   %%在开放列表获取最佳点 即G+H为最小的点（G从开始点走到当前点的路程，H当前点到目标的距离）
	{X, Y} = CurNode,
	%% B*寻路的几个停止条件 1搜索到目标点停止 2所有分支搜寻到地图边界停止 3探索路径搜寻到行走点停止
	case X == Tx andalso Y == Ty of
		true ->      %%如果最佳点等于目标点
			PathList = getPath(WalkList, Start, Target, []),
			lists:reverse(PathList);
		false ->    %%不等
			OpenList1 = dict:erase({X, Y}, OpenList),    %%开放列表删除该最佳点 以该点为节点
			CloseList1 = dict:store({X, Y}, {CurNode, G}, CloseList),  %%节点存入到封闭列表
			Neighbor = getNeighBor(X, Y),          %%获取该节点邻接点
			[OpenList2, CloseList2, WalkListNew2] = checkNeighbor(SceneId, Neighbor, Start, Target, OpenList1, CloseList1, {CurNode, G}, WalkList),
			get_nodes(SceneId, Start, Target, OpenList2, CloseList2, WalkListNew2)
	end.

getBestNode(OpenList, Target) ->
	OpenList1 = dict:to_list(OpenList),
	F = fun({Pos1, {_, G1}}, {Pos2, {_, G2}}) ->
		dist(Pos1, Target) + G1 =< dist(Pos2, Target) + G2 end, %%dist(Pos1, Target) + G1=H+G
	[Node | _] = lists:sort(F, OpenList1),
	{Pos, {_, Score}} = Node,
	{Pos, Score}.

getNeighBor(X, Y) ->
	AllPos = [{X - 1, Y - 1}, {X - 1, Y}, {X - 1, Y + 1}, {X, Y - 1}, {X, Y + 1}, {X + 1, Y - 1}, {X + 1, Y}, {X + 1, Y + 1}],
	[{Px, Py} || {Px, Py} <- AllPos, Px > 0 andalso Py > 0].

%%对节点邻接点进行判断
checkNeighbor(_SceneId, [], _Start, _Target, OpenList, CloseList, _, WalkList) ->
	[OpenList, CloseList, WalkList];
checkNeighbor(SceneId, [Pos | T], Start, Target, OpenList, CloseList, Node, WalkList) ->
	{CurPos, G} = Node,          %%当前节点
	GNew = G + dist(CurPos, Pos),   %%当前邻点的G值
	IsBlocked = is_block(SceneId, Pos),
	IsLowerThanCloseList = dict:is_key(Pos, CloseList),
	IsLowerThanOpenList = dict:is_key(Pos, OpenList),

	if
		IsBlocked ->   %%当前邻点为不可走不用操作就进行下一个邻点判断
			checkNeighbor(SceneId, T, Start, Target, OpenList, CloseList, Node, WalkList);
		IsLowerThanCloseList ->   %%当前邻点为在封闭列表不用操作
			checkNeighbor(SceneId, T, Start, Target, OpenList, CloseList, Node, WalkList);
		IsLowerThanOpenList ->    %%当前邻点在开放列表
			{_ParPos, GValue} = dict:fetch(Pos, OpenList),
			case GNew < GValue of
				true ->   %%若走当前节点到该邻点的G值小于该邻点保存的G值   则更新该邻点G值并写到路点列表
					OpenListNew = dict:store(Pos, {CurPos, GNew}, OpenList),
					WalkListNew = dict:store(Pos, {CurPos, GNew}, WalkList),
					checkNeighbor(SceneId, T, Start, Target, OpenListNew, CloseList, Node, WalkListNew);
				false ->  %%大于则不用操作
					checkNeighbor(SceneId, T, Start, Target, OpenList, CloseList, Node, WalkList)
			end;
		true ->     %%否则当前邻点添加到开放列表和路点列表
			WalkListNew = dict:store(Pos, {CurPos, GNew}, WalkList),
			OpenListNew = dict:store(Pos, {CurPos, GNew}, OpenList),
			checkNeighbor(SceneId, T, Start, Target, OpenListNew, CloseList, Node, WalkListNew)
	end.

%%从最后得到的路点列表获取想要的值
getPath(WalkList, {X, Y}, {Px, Py}, Result) ->
	Tmp = dict:fetch({Px, Py}, WalkList),
	{{X0, Y0}, _} = Tmp,
	case X0 == X andalso Y == Y0 of
		true ->
			Result;
		false ->
			getPath(WalkList, {X, Y}, {X0, Y0}, Result ++ [{X0, Y0}])
	end.

%%获取两个点距离
dist({X1, Y1}, {X2, Y2}) ->
	math:sqrt((X2 - X1) * (X2 - X1) + (Y2 - Y1) * (Y2 - Y1)).

%% 判断一个点是否可走
is_block(SceneId, {EX, EY}) ->
	not area_lib:can_move(SceneId, {EX, EY}).

%% ====================================================================
%% B*算法
%% ====================================================================

%%B星算法获取线路函数
%% get_walk_path_b(SceneId,Start,Target)->
%% 	SceneConf = scene_config:get(SceneId),
%% 	Mod = SceneConf#scene_conf.map_data,
%% 	{Width, High} = Mod:range(),
%%
%% 	DictFreeList=dict:store(0, Start, dict:new()),  %%自由节点列表 存储待处理的点 key值为路径编号, 每条路径始终只保持一个自由节点
%% 	DictWalkList=dict:store({0, Start}, Start, dict:new()),  %%路线列表 存储路线点 key值为路径编号 初始路径默认0
%% 	DictCloseList=dict:new(),       %%封闭列表  存放已处理的节点  用来过滤使用
%%
%% 	WalkList2=get_walk_path_b1(SceneId, Start, Target, DictFreeList, DictCloseList, DictWalkList, {Width, High}),  %%获取路线开始
%% 	WalkList2 ++ [Target].
%%
%% get_walk_path_b1(SceneId, Start, Target, DictFreeList, DictWalkList, DictCloseList, {Width, High}) ->
%% 	OpenList = dict:to_list(DictFreeList),
%% 	get_walk_path_b2(SceneId, Start, Target, OpenList, DictFreeList, DictCloseList, DictWalkList, {Width, High}).
%%
%% get_walk_path_b2(SceneId, Start, Target, [], DictOpenList, DictCloseList, DictWalkList, {Width, High}) ->
%% 	get_walk_path_b1(SceneId, Start, Target, DictOpenList, DictCloseList, DictWalkList, {Width, High});
%% get_walk_path_b2(SceneId, Start, Target, [{Branch, {CurX, CurY}}|T], DictOpenList, DictCloseList, DictWalkList, {Width, High}) ->
%% 	%% 根据不同的路径id搜寻不同的路径
%% 	{Tx, Ty} = Target,
%% 	case CurX == Tx andalso CurY == Ty of
%% 		true -> %%如果最佳点等于目标点
%% 			PathList=getPath(DictWalkList, Start, Target, Branch, []),
%% 			lists:reverse(PathList);
%% 		false ->
%% 			%% 获取该节点邻接点
%% 			Neighbor=getNeighBor(CurX, CurY),
%% 			%% 找出8个邻接点的所有障碍点
%% 			ObstaclList = check_bstacle(Neighbor, SceneId, Target, []),
%% 			case ObstaclList of
%% 				[] -> %% 没有障碍物 下个点直接用探索点 进行下一条路径的判断
%% 					%% 找到下一个自由节点
%% 					ExplorePos = getBestNodeb(Neighbor, Target),
%% 					NewDictWalkList = dict:store({Branch, ExplorePos}, {CurX, CurY}, DictWalkList),
%% 					NewDictOpenList = dict:store(Branch, ExplorePos, DictOpenList),
%% 					NewDictCloseList = dict:store({CurX,CurY}, {Branch, ExplorePos}, DictCloseList),  %%节点存入到封闭列表
%% 					get_walk_path_b2(SceneId, Start, Target, [{Branch, {CurX, CurY}}|T], NewDictOpenList, NewDictCloseList, NewDictWalkList, {Width, High});
%% 				_ ->
%% 					%% 计算出所有障碍物点的邻接点与节点邻接点的交集 这里只计算前后左右的4个
%% 					List = lists:flatten([getNeighBorb(NX, NY) || {NX, NY} <- ObstaclList]),
%% 					NeighborB = getNeighBorb(CurX, CurY),
%% 					IntersectionList = get_Intersection(NeighborB, List, []),
%% 					ExplorePos = getBestNodeb(NeighborB, Target),
%% 					%% 获取绕道爬行的最佳探索点列表
%% 					case IntersectionList of
%% 						[] ->
%% 			end
%% 	end.
%%
%% getBestNodeb(OpenList, Target)->
%% 	F=fun(Pos1, Pos2)-> dist(Pos1, Target) =< dist(Pos2, Target) end,
%% 	[NewPos|_] = lists:sort(F, OpenList),
%% 	NewPos.
%%
%% getBestNodeb2(OpenList, Target)->
%% 	F=fun(Pos1, Pos2)-> dist(Pos1, Target) =< dist(Pos2, Target) end,
%% 	[NewPos1, NewPos2|_] = lists:sort(F, OpenList),
%% 	case .
%%
%% getNeighBorb(X,Y)->
%% 	AllPos=[{X-1, Y}, {X, Y-1}, {X, Y+1}, {X+1, Y}],
%% 	[{Px, Py} || {Px,Py} <- AllPos, Px > 0 andalso Py > 0 ].
%%
%% %%从最后得到的路点列表获取想要的值
%% getPath(WalkList, {X,Y}, {Px,Py}, Branch, Result) ->
%% 	Tmp = dict:fetch({Branch, {Px,Py}}, WalkList),
%% 	{X0, Y0} = Tmp,
%% 	case X0 == X andalso Y == Y0 of
%% 		true ->
%% 			Result;
%% 		false ->
%% 			getPath(WalkList, {X,Y}, {X0,Y0}, Result ++ [{X0, Y0}])
%% 	end.
%%
%% check_bstacle([], _SceneId, _Target, ObstacleList) ->
%% 	ObstacleList;
%% check_bstacle([{X,Y}|T], SceneId, Target, ObstacleList) ->
%% 	case is_block(SceneId, {X, Y}, Target) of
%% 		true ->
%% 			check_bstacle(T, SceneId, Target, ObstacleList);
%% 		false ->
%% 			check_bstacle(T, SceneId, Target, [{X,Y}] ++ ObstacleList)
%% 	end.
%%
%% %% 判断一个点是否可走
%% is_block(SceneId, {EX, EY}, Target) ->
%% 	ObstacleDict = scene_base_lib:get_obstacle_dict(),
%% 	case {EX, EY} == Target of
%% 		true ->
%% 			true;
%% 		false ->
%% 			case dict:find({EX, EY}, ObstacleDict) of
%% 				{ok, _} ->
%% 					false;
%% 				_ ->
%% 					area_lib:can_move(SceneId, {EX, EY})
%% 			end
%% 	end.
%%
%% get_Intersection([], _List, L) ->
%% 	L;
%% get_Intersection([Pos|T], List, L) ->
%% 	case lists:member(Pos, List) of
%% 		true ->
%% 			[Pos] ++ L;
%% 		false ->
%% 			get_Intersection(T, List, L)
%% 	end.

%% 获取场景里面随机一个可走点
get_rand_walk_point(SceneId) ->
	SceneConf = scene_config:get(SceneId),
	Mod = SceneConf#scene_conf.map_data,
	{Width, High} = Mod:range(),
	get_rand_walk_point(SceneId, Width, High).
get_rand_walk_point(SceneId, Width, High) ->
	EX = util_rand:rand(2, Width - 1),
	EY = util_rand:rand(2, High - 2),
	case area_lib:can_move(SceneId, {EX, EY}) of
		true ->
			{EX, EY};
		false ->
			get_rand_walk_point(SceneId, Width, High)
	end.
