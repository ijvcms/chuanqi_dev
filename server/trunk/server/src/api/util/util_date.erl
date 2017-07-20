%%%-------------------------------------------------------------------
%%% @author zhengsiying
%%% @copyright (C) 2015, <COMPANY>
%%% @doc
%%%		通用时间函数
%%% @end
%%% Created : 18. 七月 2015 下午4:51
%%%-------------------------------------------------------------------
-module(util_date).


%% API
-export([
	unixtime/0,
	longunixtime/0,
	is_same_days/1,
	is_same_date/2,
	datetime_to_string/1,
	get_week/0,
	check_week_time/1,
	check_last_week_time/1,
	get_today_unixtime/0,
	get_tomorrow_unixtime/0,
	check_week_time_after_8/1,
	unixtime_to_timelist/1,
	unixtime_to_timelist/2,
	timelist_to_unixtime/1,
	get_a_standard_time_format/6,
	time_tuple_to_unixtime/1,
	get_time_str/0,
	unixtime_to_local_time/1
]).

%% ====================================================================
%% API functions
%% ====================================================================
%% 获取当前时间戳
unixtime() ->
	{M, S, _} = misc_timer:now(),
	M * 1000000 + S.

longunixtime() ->
	{M, S, Ms} = misc_timer:now(),
	M * 1000000000 + S * 1000 + Ms div 1000.

%% -----------------------------------------------------------------
%% 判断时间是否超过当天凌晨时间
%% -----------------------------------------------------------------
is_same_days(Second) ->
	Second >= get_today_unixtime().

%% 时间戳转换为local time
unixtime_to_local_time(Seconds) ->
	MS = unixtime_to_ms_tuple(Seconds),
	calendar:now_to_local_time(MS).

%% -----------------------------------------------------------------
%% 判断2个时间是否在同一天
%% -----------------------------------------------------------------
is_same_date(Seconds1, Seconds2) ->
	MS1 = unixtime_to_ms_tuple(Seconds1),
	MS2 = unixtime_to_ms_tuple(Seconds2),
	{Date1, _Time1} = calendar:now_to_local_time(MS1),
	{Date2, _Time2} = calendar:now_to_local_time(MS2),
	Date1 == Date2.

%% timestamp日期存储格式转换
datetime_to_string({{Y, M, D}, {H, I, S}}) ->
	io_lib:format(<<"~p-~p-~p ~p:~p:~p">>, [Y, M, D, H, I, S]).

%% 获取今天是周几
get_week() ->
	{Date, _} = calendar:local_time(),
	calendar:day_of_the_week(Date).

%% 检测时间是否在本周
check_week_time(Time) ->
	{Date, _} = calendar:local_time(),
	Day = calendar:day_of_the_week(Date) - 1,
	TodayTime = get_today_unixtime(),
	LastWeekTime = TodayTime - Day * 86400,
	Time > LastWeekTime.

%% 检测时间是否在本周一八点后
check_week_time_after_8(Time) ->
	{Date, _} = calendar:local_time(),
	Day = calendar:day_of_the_week(Date) - 1,
	TodayTime = get_today_unixtime(),
	LastWeekTime = TodayTime - Day * 86400,
	Time > (LastWeekTime + 3600 * 8).

%% 检测时间是否在上周
check_last_week_time(Time) ->
	{Date, _} = calendar:local_time(),
	Day = calendar:day_of_the_week(Date) - 1,
	TodayTime = get_today_unixtime(),
	LastWeekTime = TodayTime - Day * 86400,
	LastWeekStartTime = LastWeekTime - 7 * 86400,
	Time < LastWeekTime andalso Time > LastWeekStartTime.

%% 取得当天零点unix时间戳
get_today_unixtime() ->
	{M, S, Ms} = os:timestamp(),%erlang:now(),
	{_, Time} = calendar:now_to_local_time({M, S, Ms}),
	M * 1000000 + S - calendar:time_to_seconds(Time).

%% 获取第二天零点时间
get_tomorrow_unixtime() ->
	get_today_unixtime() + 86400.

%%时间戳转换成 2012-12-12 9:35:45 格式
unixtime_to_timelist(Time) ->
	unixtime_to_timelist(Time, 'yyyy-mm-dd hh:mm:ss').
unixtime_to_timelist(Time, Format) ->
	if
		Time =:= 0 ->
			"0";
		true ->
			A = calendar:datetime_to_gregorian_seconds({{1970, 1, 1}, {0, 0, 0}}) + Time,
			B = calendar:gregorian_seconds_to_datetime(A),
			{{Year, Month, Day}, {H, M, S}} = calendar:universal_time_to_local_time(B),
			if
				Month < 10 ->
					Month1 = lists:concat([0, Month]);
				true ->
					Month1 = util_data:to_list(Month)
			end,
			if
				Day < 10 ->
					Day1 = lists:concat([0, Day]);
				true ->
					Day1 = util_data:to_list(Day)
			end,
			if
				H < 10 ->
					H1 = lists:concat([0, H]);
				true ->
					H1 = util_data:to_list(H)
			end,
			if
				M < 10 ->
					M1 = lists:concat([0, M]);
				true ->
					M1 = util_data:to_list(M)
			end,
			if
				S < 10 ->
					S1 = lists:concat([0, S]);
				true ->
					S1 = util_data:to_list(S)
			end,
			case Format of
				'yyyymmddhhmmss' ->
					lists:concat([Year, Month1, Day1, H1, M1, S1]);
				_ ->
					lists:concat([Year, "-", Month1, "-", Day1, " ", H1, ":", M1, ":", S1])
			end
	end.
%% "2012-12-12 9:35:45" 格式 转换成 时间戳
timelist_to_unixtime(TimeList) ->
	timelist_to_unixtime(util_data:to_list(TimeList), [], []).

timelist_to_unixtime([], Info, List) ->
	Integer = list_to_integer(lists:reverse(Info)),
	[Year, Month, Day, Hour, Minutes, Second] = lists:reverse([Integer | List]),
	[DateTime] = calendar:local_time_to_universal_time_dst({{Year, Month, Day}, {Hour, Minutes, Second}}),
	calendar:datetime_to_gregorian_seconds(DateTime) -
		calendar:datetime_to_gregorian_seconds({{1970, 1, 1}, {0, 0, 0}});
timelist_to_unixtime([H | T], Info, List) ->
	if
		H >= $0 andalso H =< $9 ->
			timelist_to_unixtime(T, [H | Info], List);
		true ->
			Integer = list_to_integer(lists:reverse(Info)),
			timelist_to_unixtime(T, [], [Integer | List])
	end.

%% {{2012, 01, 01}, {01, 00, 00}}格式 转换成 时间戳
time_tuple_to_unixtime(TimeTuple) ->
	[DateTime] = calendar:local_time_to_universal_time_dst(TimeTuple),
	calendar:datetime_to_gregorian_seconds(DateTime) -
		calendar:datetime_to_gregorian_seconds({{1970, 1, 1}, {0, 0, 0}}).

get_a_standard_time_format(Year, Month, Day, H, M, S) ->
	if
		Month >= 10 ->
			Month1 = Month;
		true ->
			Month1 = lists:concat(["0", Month])
	end,
	if
		Day >= 10 ->
			Day1 = Day;
		true ->
			Day1 = lists:concat(["0", Day])
	end,
	if
		H >= 10 ->
			H1 = H;
		true ->
			H1 = lists:concat(["0", H])
	end,
	if
		M >= 10 ->
			M1 = M;
		true ->
			M1 = lists:concat(["0", M])
	end,
	if
		S >= 10 ->
			S1 = S;
		true ->
			S1 = lists:concat(["0", S])
	end,
	lists:concat([Year, "-", Month1, "-", Day1, " ", H1, ":", M1, ":", S1]).

get_time_str() ->
	Time = calendar:local_time(),
	util_data:term_to_string(Time).

%% ====================================================================
%% Internal functions
%% ====================================================================
unixtime_to_ms_tuple(Seconds) ->
	M = Seconds div 1000000,
	S = Seconds rem 1000000,
	{M, S, 0}.
