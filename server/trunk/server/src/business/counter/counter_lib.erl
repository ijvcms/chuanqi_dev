%%%-------------------------------------------------------------------
%%% @author tuhujia
%%% @copyright (C) 2015, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 30. 七月 2015 16:02
%%%-------------------------------------------------------------------
-module(counter_lib).
-include("common.hrl").
-include("record.hrl").
-include("config.hrl").
-include("cache.hrl").

-export([
	on_player_login/1,
	on_player_logout/1,
	get_value/2,
	get_value_time/2,
	get_limit/1,
	get_info/2,
	check/2,
	update/2,
	update_value/3,
	get_localtime/0,
	update_value_limit/3,
	update_limit/2,
	get_last_value/2,
	check_num/3,
	update_limit/3
]).

%%% ----------------------------------------------------------------------------
%%% 类型定义
%%% ----------------------------------------------------------------------------
-define(SECONDS_PER_MINUTE, 60).
-define(SECONDS_PER_HOUR, 3600).
-define(SECONDS_PER_DAY, 86400).
-define(SECONDS_PER_WEEK, 604800).
-define(MINUTES_PER_HOUR, 60).
-define(MINUTES_PER_DAY, 1440).
-define(HOURS_PER_DAY, 24).
-define(MONTHES_PER_YEAR, 12).
-define(DAYS_PER_WEEK, 7).
-define(DAYS_FROM_0_TO_1970, 719528).
%%% ----------------------------------------------------------------------------
%%% 对外接口
%%% ----------------------------------------------------------------------------

%% @doc 玩家登录事件
on_player_login(PlayerId) ->
	db_load_player_counter(PlayerId).

%% @doc 玩家退出事件
on_player_logout(CharId) ->
	ets_unload_player_counter(CharId).

%%@doc 获取玩家CounterId对应的统计值
get_value(CharId, CounterId) when is_integer(CounterId) ->
	case get_info(CharId, CounterId) of
		null -> 0;
		PC -> get_player_counter_value(PC)
	end.
%% 获取统计值 和 统计的时间
get_value_time(_CharId, 0) ->
	{0, 0};
get_value_time(CharId, CounterId) when is_integer(CounterId) ->
	case get_info(CharId, CounterId) of
		null -> {0, 0};
		PC ->
			{PC#ets_player_counter.value, util_date:time_tuple_to_unixtime(PC#ets_player_counter.update_time)}
	end.
%% 获取剩余次数
get_last_value(CharId, CounterId) when is_integer(CounterId) ->
	case get_info(CharId, CounterId) of
		null -> 0;
		PC ->
			get_limit(CounterId) - get_player_counter_value(PC)
	end.

%%@doc 获取CounterId对应的上限值
get_limit(CounterId) when is_integer(CounterId) ->
	Counter = counter_config:get(CounterId),
	Counter#counter_conf.limit_value.

%%@doc 检查CounterId是否满足条件     true 表示  没领取过 可以领取
check(CharId, CounterId) when is_integer(CounterId) ->
	Counter = counter_config:get(CounterId),
	case get_info(CharId, CounterId) of
		null -> 0 < Counter#counter_conf.limit_value;
		PC -> get_player_counter_value(PC) < Counter#counter_conf.limit_value
	end.

%%@doc 检查CounterId是否满足条件 num添加的数量     true 表示  没领取过 可以领取
check_num(CharId, CounterId, Num) when is_integer(CounterId) ->
	case Num < 1 of
		true ->
			false;
		_ ->
			Counter = counter_config:get(CounterId),
			case get_info(CharId, CounterId) of
				null -> Num =< Counter#counter_conf.limit_value;
				PC -> get_player_counter_value(PC) + Num =< Counter#counter_conf.limit_value
			end
	end.

%%@doc 递增玩家CounterId对应的统计次数
update(CharId, CounterId) when is_integer(CounterId) ->
	Counter = counter_config:get(CounterId),
	case get_info(CharId, CounterId) of
		null ->
			case 0 < Counter#counter_conf.limit_value of
				false -> false;
				true ->
					update_player_counter(create_player_counter({CharId, CounterId})),
					true
			end;
		PC ->
			case get_player_counter_value(PC) < Counter#counter_conf.limit_value of
				false -> false;
				true ->
					update_player_counter(PC),
					true
			end
	end.

%%@doc 递增玩家CounterId对应的统计次数
update_limit(CharId, CounterId) when is_integer(CounterId) ->
	Counter = counter_config:get(CounterId),
	case get_info(CharId, CounterId) of
		null ->
			case 0 < Counter#counter_conf.limit_value of
				false -> false;
				true ->
					update_player_counter(create_player_counter({CharId, CounterId})),
					true
			end;
		PC ->
			update_player_counter(PC),
			true
	end.
%%@doc 递增玩家CounterId对应的统计次数
update_limit(CharId, CounterId, Num) when is_integer(CounterId) ->
	case get_info(CharId, CounterId) of
		null ->
			update_player_counter(create_player_counter({CharId, CounterId, Num}));
		PC ->
			update_player_counter(PC, Num),
			true
	end.


%%@doc 修改玩家CounterId对应的统计次数
update_value(CharId, CounterId, Value) when is_integer(CounterId), is_integer(Value) ->
	Counter = counter_config:get(CounterId),
	PC = case get_info(CharId, CounterId) of
			 null -> create_player_counter({CharId, CounterId});
			 X -> X
		 end,
	case Value =< Counter#counter_conf.limit_value of
		false -> false;
		true ->
			update_player_counter_value(PC, Value),
			true
	end.
%%@doc 修改玩家CounterId可以超过上限
update_value_limit(CharId, CounterId, Value) when is_integer(CounterId), is_integer(Value) ->
	PC = case get_info(CharId, CounterId) of
			 null -> create_player_counter({CharId, CounterId});
			 X -> X
		 end,
	update_player_counter(PC, Value).
%%% ----------------------------------------------------------------------------
%%% 私有方法
%%% ----------------------------------------------------------------------------
%%@doc 获取玩家CounterId对应的记录
get_info(CharId, CounterId) when is_integer(CounterId) ->
	case counter_cache:get_player_counter_info_from_ets(CharId, CounterId) of
		[] ->
			PC = counter_cache:select_row_ets(CharId, CounterId),
			refresh_player_counter(CounterId, PC);
		{ok, PC} ->
			refresh_player_counter(CounterId, PC)
	end.

refresh_player_counter(CounterId, PC) ->
	Counter = counter_config:get(CounterId),
	case util_data:to_atom(Counter#counter_conf.period_unit) =:= forever of
		true -> PC;
		false ->
			refresh_player_counter_1(Counter, PC)
	end.

refresh_player_counter_1(Counter, PC) when is_record(Counter, counter_conf) ->
	Now = get_localtime(),
	I1 = get_period_index(load_period_unit(Counter#counter_conf.period_unit), Counter#counter_conf.period, PC#ets_player_counter.update_time, Counter#counter_conf.base_time),
	I2 = get_period_index(load_period_unit(Counter#counter_conf.period_unit), Counter#counter_conf.period, Now, Counter#counter_conf.base_time),
	case I1 =:= I2 of
		true ->
			PC;
		false ->
			PC1 = PC#ets_player_counter{value = 0, update_time = Now},
			counter_cache:save_player_counter_info_to_ets(PC1),
			counter_cache:replace(PC1),
			PC1
	end.

get_player_counter_value(PC) ->
	PC#ets_player_counter.value.

update_player_counter(PC) ->
	Now = calendar:local_time(),
	Value = 1 + PC#ets_player_counter.value,
	PC1 = PC#ets_player_counter{value = Value,
		update_time = Now},
	counter_cache:save_player_counter_info_to_ets(PC1),
	counter_cache:replace(PC1).
%% 添加指定的数量
update_player_counter(PC, Num) ->
	Now = calendar:local_time(),
	Value = Num + PC#ets_player_counter.value,
	PC1 = PC#ets_player_counter{value = Value,
		update_time = Now},
	counter_cache:save_player_counter_info_to_ets(PC1),
	counter_cache:replace(PC1).

update_player_counter_value(PC, Value) ->
	Now = calendar:local_time(),
	PC1 = PC#ets_player_counter{value = Value,
		update_time = Now},
	counter_cache:save_player_counter_info_to_ets(PC1),
	counter_cache:replace(PC1).

create_player_counter(Data) ->
	case Data of
		{CharId, CounterId} ->
			#ets_player_counter{key = {CharId, CounterId},
				value = 0,
				update_time = get_localtime()};
		{CharId, CounterId, Num} ->
			#ets_player_counter{key = {CharId, CounterId},
				value = Num,
				update_time = get_localtime()}
	end.

%%% ----------------------------------------------------------------------------
%%% 存储相关方法
%%% ----------------------------------------------------------------------------

db_load_player_counter(PlayerId) ->
	case counter_cache:select_all(PlayerId) of
		[] ->
			skip;
		CounterList ->
			Fun = fun(CounterInfo) ->
				CounterId = CounterInfo#db_player_counter.counter_id,
				Record = #ets_player_counter{key = {PlayerId, CounterId},
					value = CounterInfo#db_player_counter.value,
					update_time = CounterInfo#db_player_counter.update_time},
				counter_cache:save_player_counter_info_to_ets(Record)
			end,
			lists:foreach(Fun, CounterList)
	end.

ets_unload_player_counter(PlayerId) ->
	counter_cache:delete_player_counter_info_from_ets(PlayerId).

%%% ----------------------------------------------------------------------------
%%% 时间相关函数
%%% ----------------------------------------------------------------------------

%%@doc 获取本地时间{{Y,M,D},{H,I,S}}
get_localtime() ->
	calendar:local_time().


load_period_unit(<<"forever">>) -> forever;
load_period_unit(<<"day">>) -> day;
load_period_unit(<<"week">>) -> week;
load_period_unit(<<"month">>) -> month;
load_period_unit(<<"hour">>) -> hour;
load_period_unit(<<"minute">>) -> minute;
load_period_unit(<<"second">>) -> second;
load_period_unit(<<"year">>) -> year;
load_period_unit(_Other) -> ?DEBUG("Invalid period unit: ~p", [_Other]), forever.

%% 计算时间2相对时间1的周期数
get_period_index(year, Period, {{Y1, _, _}, _}, {{Y2, _, _}, _}) ->
	(Y2 - Y1) div Period;
get_period_index(month, Period, {{Y1, M1, _}, _}, {{Y2, M2, _}, _}) ->
	((Y2 - Y1) * 12 + M2 - M1) div Period;
%% get_period_index(week,Period,T1,T2) ->
%%     {Days,_} = calendar:time_difference(T1,T2),
%%     Days div (?DAYS_PER_WEEK * Period);
get_period_index(week, Period, T1, _T2) ->
	{Date, _} = T1,
	{_, Week} = calendar:iso_week_number(Date),
	Week div Period;
get_period_index(day, Period, T1, T2) ->
	{Days, _} = calendar:time_difference(T1, T2),
	Days div Period;
get_period_index(hour, Period, T1, T2) ->
	{Days, {H, _, _}} = calendar:time_difference(T1, T2),
	(Days * ?HOURS_PER_DAY + H) div Period;
get_period_index(minute, Period, T1, T2) ->
	{Days, {H, I, _}} = calendar:time_difference(T1, T2),
	(Days * ?MINUTES_PER_DAY + H * ?MINUTES_PER_HOUR + I) div Period;
get_period_index(second, Period, T1, T2) ->
	{Days, {H, I, S}} = calendar:time_difference(T1, T2),
	(Days * ?SECONDS_PER_DAY + H * ?SECONDS_PER_HOUR + I * ?SECONDS_PER_MINUTE + S) div Period.
