%%%-------------------------------------------------------------------
%%% @author tuhujia
%%% @copyright (C) 2016, <COMPANY>
%%% @doc 福利大厅活动
%%%
%%% @end
%%% Created : 29. 一月 2016 11:50
%%%-------------------------------------------------------------------
-module(welfare_active_lib).

-include("common.hrl").
-include("record.hrl").
-include("config.hrl").
-include("cache.hrl").
-include("db_record.hrl").
-include("proto.hrl").
-include("language_config.hrl").
-include("button_tips_config.hrl").
-include("log_type_config.hrl").

-export([
	get_active_info/1,
	get_player_online_times/1,
	update_player_online_times/1,
	get_reward/2,
	check_active_state/1,
	push_login_days/1,
	push_first_charge/1,
	get_first_charge_reward/1,
	get_button_login_tips/1,
	get_button_online_tips/1,
	get_button_lv_bag_tips/1,
	check_button_online_tips/1,
	get_active_info/2
]).

-define(TYPE_LOGIN_DAYS, 1).  %% 7天活动类型
-define(TYPE_ONLINE_TIMES, 2).  %% 在线活动
-define(TYPE_FRIST_CHARGE, 3).  %% 首充活动
-define(TYPE_LV_BAG, 4).  %% 等级礼包

-define(STATE_NOT_PICKUP, 0).  %% 未领取状态
-define(STATE_ALREADY_PICKUP, 1).  %% 已领取状态
-define(STATE_COND_NOT_ENOUGH, 2).  %% 条件不满足状态

-define(ACTIVE_KEY_FIRST_CHARGE, 26).  %% 首充活动key

%%% ----------------------------------------------------------------------------
%%% 对外接口
%%% ----------------------------------------------------------------------------

%% 获取活动状态
get_active_info(PlayerState) ->
	DPB = PlayerState#player_state.db_player_base,
	Lv = DPB#db_player_base.lv,
	check_login_days(PlayerState),
	Fun = fun(ActiveConf, Acc) ->
		case ActiveConf of
			[] ->
				Acc;
			_ ->
				[#proto_active_info
				{
					key = ActiveConf#active_reward_conf.key,  %%  活动id
					state = get_active_state(PlayerState, ActiveConf)   %%  奖励领取状态0未领取 1已领取
				}] ++ Acc
		end
	end,
	lists:foldl(Fun, [], active_reward_config:get_list_conf(Lv)).

%% 获取活动状态
get_active_info(PlayerState, Type) ->
	DPB = PlayerState#player_state.db_player_base,
	Lv = DPB#db_player_base.lv,
	check_login_days(PlayerState),
	Fun = fun(ActiveConf, Acc) ->
		case ActiveConf of
			[] ->
				Acc;
			_ ->
				case ActiveConf#active_reward_conf.type of
					Type ->
						[#proto_active_info
						{
							key = ActiveConf#active_reward_conf.key,  %%  活动id
							state = get_active_state(PlayerState, ActiveConf)   %%  奖励领取状态0未领取 1已领取
						}] ++ Acc;
					_ ->
						Acc
				end
		end
	end,
	lists:foldl(Fun, [], active_reward_config:get_list_conf(Lv)).

%% 获取玩家当天在线时长
get_player_online_times(PlayerState) ->
	PlayerId = PlayerState#player_state.player_id,
	DbBase = PlayerState#player_state.db_player_base,
	LastLoginTime = DbBase#db_player_base.last_login_time,
	NowTime = util_date:unixtime(),
	PC = counter_lib:get_info(PlayerId, ?COUNTER_ONLINE_TIMES),
	Time = PC#ets_player_counter.value,
	TodayTime = util_date:get_today_unixtime(),
	NowTime - max(TodayTime, LastLoginTime) + Time.

%% 玩家下线更新玩家在线时长
update_player_online_times(PlayerState) ->
	#player_state{open_id = OpenId, platform = Platform} = PlayerState,
	PlayerId = PlayerState#player_state.player_id,
	DbBase = PlayerState#player_state.db_player_base,
	LastLoginTime = DbBase#db_player_base.last_login_time,
	PlayerName = DbBase#db_player_base.name,
	NowTime = util_date:unixtime(),
	TodayTime = util_date:get_today_unixtime(),
	log_lib:log_login(OpenId, Platform, PlayerId, PlayerName, LastLoginTime, NowTime, 1),
	PC = counter_lib:get_info(PlayerId, ?COUNTER_ONLINE_TIMES),
	%% 限时活动统计检测
	Count = PC#ets_player_counter.value + NowTime - max(TodayTime, LastLoginTime),
	operate_active_lib:update_limit_type(PlayerState, ?OPERATE_ACTIVE_LIMIT_TYPE_3, Count),
	counter_lib:update_value(PlayerId, ?COUNTER_ONLINE_TIMES, Count).

%% 福利大厅领取奖励
get_reward(PlayerState, Key) ->
	DPB = PlayerState#player_state.db_player_base,
	Lv = DPB#db_player_base.lv,
	ActiveConf = active_reward_config:get({Key, Lv}),
	case get_active_state(PlayerState, ActiveConf) of
		?STATE_NOT_PICKUP ->
			PlayerId = PlayerState#player_state.player_id,
			CounterId = ActiveConf#active_reward_conf.counter_id,
			Reward = reward(PlayerState, ActiveConf),
			Type = ActiveConf#active_reward_conf.type,
			case add_reward(PlayerState, Key, Reward, Type) of
				{ok, PlayerState1} ->
					counter_lib:update(PlayerId, CounterId),
					%% 红点检测
					case Type of
						?TYPE_LOGIN_DAYS ->
							button_tips_lib:ref_button_tips(PlayerState1, ?BTN_LOGIN);
						?TYPE_ONLINE_TIMES ->
							button_tips_lib:ref_button_tips(PlayerState1, ?BTN_AWARD_ONLINE);
						?TYPE_FRIST_CHARGE ->
							PlayerState2 = function_lib:ref_function_open_list(PlayerState1),
							{ok, PlayerState2};
						?TYPE_LV_BAG ->
							button_tips_lib:ref_button_tips(PlayerState1, ?BIN_LEVEL_REWARD);
						_ ->
							{ok, PlayerState1}
					end;
				{fail, Reply} ->
					{fail, Reply}
			end;
		?STATE_COND_NOT_ENOUGH ->
			{fail, ?ERR_COMMON_FAIL};
		?STATE_ALREADY_PICKUP ->
			{fail, ?LANGUEGE_CITY_SCENE9}
	end.

reward(PlayerState, ActiveConf) ->
	DPB = PlayerState#player_state.db_player_base,
	Career = DPB#db_player_base.career,
	case Career of
		?CAREER_ZHANSHI ->
			ActiveConf#active_reward_conf.reward_zhanshi;
		?CAREER_FASHI ->
			ActiveConf#active_reward_conf.reward_fashi;
		_ ->
			ActiveConf#active_reward_conf.reward_daoshi
	end.

add_reward(PlayerState, Key, Reward, Type) ->
	case Type of
		?TYPE_FRIST_CHARGE ->
			goods_lib_log:add_goods_list_and_send_mail(PlayerState, Reward, ?LOG_TYPE_FRIST_CHARGE);
		_ ->
			LogType =
				if
					Key =< 7 -> ?LOG_TYPE_WELFARE_SEVEN;
					Key =< 13 -> ?LOG_TYPE_WELFARE_ONLINE;
					true ->
						?LOG_TYPE_WELFARE
				end,
			goods_lib_log:add_goods_list(PlayerState, Reward, LogType)
	end.


%% 玩家登录开启倒计时活动检测
check_active_state(_PlayerState) ->
	Time = ?DAY_TIME_COUNT - (util_date:unixtime() - util_date:get_today_unixtime()),
	%% 添加定时器
	gen_server2:apply_after(Time * 1000, self(), {welfare_active_lib, push_login_days, []}).

push_login_days(PlayerState) ->
	DPB = PlayerState#player_state.db_player_base,
	Lv = DPB#db_player_base.lv,
	check_login_days(PlayerState),
	Fun = fun(ActiveConf, Acc) ->
		case ActiveConf of
			[] -> Acc;
			_ ->
				case get_active_state(PlayerState, ActiveConf) of
					?STATE_NOT_PICKUP ->
						[#proto_active_info
						{
							key = ActiveConf#active_reward_conf.key,  %%  活动id
							state = get_active_state(PlayerState, ActiveConf)   %%  奖励领取状态0未领取 1已领取
						}] ++ Acc;
					_ ->
						Acc
				end
		end
	end,
	Proto = lists:foldl(Fun, [], active_reward_config:get_list_conf(Lv)),
	net_send:send_to_client(PlayerState#player_state.socket, 32004, #rep_update_active_state{info_list = Proto}).

push_first_charge(PlayerState) ->
	DPB = PlayerState#player_state.db_player_base,
	Lv = DPB#db_player_base.lv,
	ActiveConf = active_reward_config:get({?ACTIVE_KEY_FIRST_CHARGE, Lv}),
	Proto = [#proto_active_info
	{
		key = ActiveConf#active_reward_conf.key,  %%  活动id
		state = get_active_state(PlayerState, ActiveConf)   %%  奖励领取状态0未领取 1已领取
	}],
	button_tips_lib:ref_button_tips(PlayerState, ?BTN_LOGIN),
	net_send:send_to_client(PlayerState#player_state.socket, 32004, #rep_update_active_state{info_list = Proto}).

%% 获取首充活动奖励
get_first_charge_reward(PlayerState) ->
	DPB = PlayerState#player_state.db_player_base,
	Lv = DPB#db_player_base.lv,
	ActiveConf = active_reward_config:get({?ACTIVE_KEY_FIRST_CHARGE, Lv}),
	[{GoodsId, _, _}] = ActiveConf#active_reward_conf.reward,
	GoodsList = goods_util:get_bag_goods_list(PlayerState, GoodsId),
	Proto = goods_lib:get_proto_goods_list(GoodsList),
	net_send:send_to_client(PlayerState#player_state.socket, 32005, #rep_get_first_charge_reward{goods_list = Proto}).

get_button_login_tips(PlayerState) ->
	FunctionList = PlayerState#player_state.function_open_list,
	case lists:member(?FUNCTION_ID_WELFARE, FunctionList) of
		true ->
			get_button_login_tips_1(PlayerState);
		false ->
			{PlayerState, 0}
	end.

get_button_login_tips_1(PlayerState) ->
	DPB = PlayerState#player_state.db_player_base,
	Lv = DPB#db_player_base.lv,
	Fun = fun(ActiveConf, Acc) ->
		case ActiveConf of
			[] -> Acc;
			_ ->
				case ActiveConf#active_reward_conf.type == ?TYPE_LOGIN_DAYS of
					true ->
						case get_active_state(PlayerState, ActiveConf) of
							?STATE_NOT_PICKUP ->
								Acc + 1;
							_ ->
								Acc
						end;
					false ->
						Acc
				end
		end
	end,
	N = lists:foldl(Fun, 0, active_reward_config:get_list_conf(Lv)),
	{PlayerState, N}.


get_button_online_tips(PlayerState) ->
	FunctionList = PlayerState#player_state.function_open_list,
	case lists:member(?FUNCTION_ID_WELFARE, FunctionList) of
		true ->
			get_button_online_tips_1(PlayerState);
		false ->
			{PlayerState, 0}
	end.

get_button_online_tips_1(PlayerState) ->
	DPB = PlayerState#player_state.db_player_base,
	Lv = DPB#db_player_base.lv,
	Fun = fun(ActiveConf, Acc) ->
		case ActiveConf of
			[] -> Acc;
			_ ->
				case ActiveConf#active_reward_conf.type == ?TYPE_ONLINE_TIMES of
					true ->
						case get_active_state(PlayerState, ActiveConf) of
							?STATE_NOT_PICKUP ->
								Acc + 1;
							_ ->
								Acc
						end;
					false ->
						Acc
				end
		end
	end,
	N = lists:foldl(Fun, 0, active_reward_config:get_list_conf(Lv)),
	{PlayerState, N}.

%% 获取等级礼包红点
get_button_lv_bag_tips(PlayerState) ->
	DPB = PlayerState#player_state.db_player_base,
	Lv = DPB#db_player_base.lv,
	Fun = fun(ActiveConf, Acc) ->
		case ActiveConf of
			[] -> Acc;
			_ ->
				case ActiveConf#active_reward_conf.type == ?TYPE_LV_BAG of
					true ->
						case get_active_state(PlayerState, ActiveConf) of
							?STATE_NOT_PICKUP ->
								Acc + 1;
							_ ->
								Acc
						end;
					false ->
						Acc
				end
		end
	end,
	N = lists:foldl(Fun, 0, active_reward_config:get_list_conf(Lv)),
	{PlayerState, N}.

%% 在线时长红点检测(玩家进程调用)
check_button_online_tips(PlayerState) ->
	NowTime = util_date:unixtime(),
	TimeList = check_online_tips_info(PlayerState),

	Fun = fun(Time) ->
		case NowTime >= Time of
			true ->
				button_tips_lib:ref_button_tips(PlayerState, ?BTN_AWARD_ONLINE),
				delete_online_tips_info(Time);
			false ->
				skip
		end
	end,
	[Fun(X) || X <- TimeList].

check_online_tips_info(PlayerState) ->
	case get_online_tips_info() of
		[Time, TimeList] ->
			NowTime = util_date:unixtime(),
			case NowTime >= Time of
				true ->
					refuse_effective_list(PlayerState);
				false ->
					TimeList
			end;
		_ ->
			refuse_effective_list(PlayerState)
	end.

get_online_tips_info() ->
	get(online_tips).

put_online_tips_info(List) ->
	put(online_tips, List).

delete_online_tips_info(Time) ->
	[TodayTime, TimeList] = get_online_tips_info(),
	TimeList1 = TimeList -- [Time],
	put_online_tips_info([TodayTime, TimeList1]).

%% 获取有效列表
refuse_effective_list(PlayerState) ->
	DPB = PlayerState#player_state.db_player_base,
	Lv = DPB#db_player_base.lv,
	%% 获取明天时间
	TodayLastTime = util_date:get_today_unixtime() + ?DAY_TIME_COUNT,
	PlayerId = PlayerState#player_state.player_id,
	DbBase = PlayerState#player_state.db_player_base,
	LastLoginTime = DbBase#db_player_base.last_login_time,%% 最后登陆时间
	NowTime = util_date:unixtime(),%% 当前时间
	PC = counter_lib:get_info(PlayerId, ?COUNTER_ONLINE_TIMES),%% 每日在线时长
	Time = PC#ets_player_counter.value,%% 数量
	Fun = fun(ActiveConf, Acc) ->
		case ActiveConf of
			[] -> Acc;
			_ ->
				case ActiveConf#active_reward_conf.type == ?TYPE_ONLINE_TIMES of
					true ->
						Value = ActiveConf#active_reward_conf.value,
						case get_player_online_times(PlayerState) >= Value of
							true ->
								Acc;
							false ->
								OnLineTime = Time + NowTime - LastLoginTime,
								[NowTime + Value - OnLineTime] ++ Acc
						end;
					false ->
						Acc
				end
		end
	end,
	TimeList = lists:foldl(Fun, [], active_reward_config:get_list_conf(Lv)),
	put_online_tips_info([TodayLastTime, TimeList]),
	TimeList.

%%% ----------------------------------------------------------------------------
%%% 内部接口
%%% ----------------------------------------------------------------------------

%% 检查是否当天第一次登录
check_login_days(PlayerState) ->
	PlayerId = PlayerState#player_state.player_id,
	PC = counter_lib:get_info(PlayerId, ?COUNTER_LOGIN_DAYS),
	{Date, _} = calendar:local_time(),
	{Date1, _} = PC#ets_player_counter.update_time,
	case Date == Date1 of
		true ->
			case PC#ets_player_counter.value == 0 of
				true -> counter_lib:update(PlayerId, ?COUNTER_LOGIN_DAYS);
				false -> skip
			end;
		false -> counter_lib:update(PlayerId, ?COUNTER_LOGIN_DAYS)
	end.

%% 获取活动状态
get_active_state(PlayerState, ActiveConf) ->
	PlayerId = PlayerState#player_state.player_id,
	check_login_days(PlayerState),
	Value = ActiveConf#active_reward_conf.value,
	case ActiveConf#active_reward_conf.type of
		?TYPE_LOGIN_DAYS ->
			case counter_lib:get_value(PlayerId, ?COUNTER_LOGIN_DAYS) >= Value of
				true ->
					CounterId = ActiveConf#active_reward_conf.counter_id,
					get_active_state_1(PlayerId, CounterId);
				false ->
					?STATE_COND_NOT_ENOUGH
			end;
		?TYPE_ONLINE_TIMES ->
			case get_player_online_times(PlayerState) >= Value of
				true ->
					CounterId = ActiveConf#active_reward_conf.counter_id,
					get_active_state_1(PlayerId, CounterId);
				false ->
					?STATE_COND_NOT_ENOUGH
			end;
		?TYPE_LV_BAG ->
			DPB = PlayerState#player_state.db_player_base,
			PlayerLv = DPB#db_player_base.lv,
			case PlayerLv >= Value of
				true ->
					CounterId = ActiveConf#active_reward_conf.counter_id,
					get_active_state_1(PlayerId, CounterId);
				false ->
					?STATE_COND_NOT_ENOUGH
			end;
		_ ->
			case counter_lib:check(PlayerId, ?COUNTER_FIRST_CHARGE) of
				false ->
					CounterId = ActiveConf#active_reward_conf.counter_id,
					get_active_state_1(PlayerId, CounterId);
				true ->
					?STATE_COND_NOT_ENOUGH
			end
	end.

get_active_state_1(PlayerId, CounterId) ->
	case counter_lib:check(PlayerId, CounterId) of
		true ->
			?STATE_NOT_PICKUP;
		false ->
			?STATE_ALREADY_PICKUP
	end.
