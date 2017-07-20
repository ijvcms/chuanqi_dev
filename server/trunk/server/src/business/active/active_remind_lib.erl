%%%-------------------------------------------------------------------
%%% @author tuhujia
%%% @copyright (C) 2016, <COMPANY>
%%% @doc 开启功能按钮提醒
%%%
%%% @end
%%% Created : 28. 四月 2016 15:10
%%%-------------------------------------------------------------------
-module(active_remind_lib).
%%
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
	check_active_remind/2,
	update_active_remind_function/0
]).

%%% ----------------------------------------------------------------------------
%%% 对外接口
%%% ----------------------------------------------------------------------------
-define(NOTICE_MOD_DOUBLE_EXP, 'notice_mod_double_exp').
%% 定时检测
check_active_remind('login', PlayerState) ->
	CurTime = util_date:unixtime(),
	ServerStartTime = config:get_start_time(),
	T = CurTime - ServerStartTime,
	case ets:lookup(?ETS_ACTIVE_REMIND, 1) of
		[R | _] ->
			OpenList = R#ets_active_remind.open_function_list,
			case PlayerState#player_state.active_remind_list =:= OpenList of
				true ->
					PlayerState;
				false ->
					Fun = fun({Key, FunctionId}, Acc) ->
						Conf = active_remind_config:get(Key),
						EnterLimit = Conf#active_remind_conf.enter_limit,
						case check_active_remind_cond_list(PlayerState, EnterLimit) of
							{ok, _} ->

								%%去掉跨服暗殿(6,8)及跨服火龙(5,13,17,18)跨服幻境(14)夸服变异地宫(16)
								ShieldList = [6, 8, 5, 13, 16, 17, 18, 14],
								case lists:member(Key, ShieldList) of
									true ->
										Acc;
									_ ->
										[FunctionId | ShieldList]
								end;

%%								case T < 7 * ?DAY_TIME_COUNT of
%%									true ->
%%										%%去掉跨服暗殿(6,8)及跨服火龙(5,13,17,18)跨服幻境(14)
%%										case Key =:= 6 orelse Key =:= 8 orelse Key =:= 5 orelse Key =:= 13 orelse Key =:= 17 orelse Key =:= 18 orelse Key =:= 14 of
%%											true ->
%%												Acc;
%%											false ->
%%												[FunctionId] ++ Acc
%%										end;
%%									false ->
%%										%%去掉本服暗殿(7,9)及本服火龙(11,12,19)本服幻境(15)
%%										case Key =:= 7 orelse Key =:= 9 orelse Key =:= 11 orelse Key =:= 12 orelse Key =:= 19 orelse Key =:= 15 of
%%											true ->
%%												Acc;
%%											false ->
%%												[FunctionId] ++ Acc
%%										end
%%								end;
							_ ->
								Acc
						end
					end,
					OpenList1 = lists:foldl(Fun, [], OpenList),

					CloseList = [X || {_, X} <- R#ets_active_remind.close_function_list],
					FunctionList = PlayerState#player_state.function_open_list,
					NewFunctionList = OpenList1 ++ FunctionList -- CloseList,
					PlayerState#player_state{function_open_list = NewFunctionList, active_remind_list = OpenList}
			end;
		[] ->
			PlayerState;
		Err ->
			?ERR("~p", [Err]),
			PlayerState
	end;
check_active_remind('on_timer', PlayerState) ->
	CurTime = util_date:unixtime(),
	ServerStartTime = config:get_start_time(),
	T = CurTime - ServerStartTime,
	case ets:lookup(?ETS_ACTIVE_REMIND, 1) of
		[R | _] ->
			OpenList = R#ets_active_remind.open_function_list,
			case PlayerState#player_state.active_remind_list == OpenList of
				true ->
					PlayerState;
				false ->
					Fun = fun({Key, FunctionId}, Acc) ->
						Conf = active_remind_config:get(Key),
						EnterLimit = Conf#active_remind_conf.enter_limit,
						case check_active_remind_cond_list(PlayerState, EnterLimit) of
							{ok, _} ->
								%%去掉跨服暗殿(6,8)及跨服火龙(5,13,17,18)跨服幻境(14)
								ShieldList = [6, 8, 5, 13, 16, 17, 18, 14],
								case lists:member(Key, ShieldList) of
									true ->
										Acc;
									_ ->
										[FunctionId | ShieldList]
								end;
								%% 暂时先把所有的跨服功能都屏蔽
%%								case T < 7 * ?DAY_TIME_COUNT of
%%									true ->
%%										%%去掉跨服暗殿(6,8)及跨服火龙(5,13,17,18)跨服幻境(14)
%%										case Key =:= 6 orelse Key =:= 8 orelse Key =:= 5 orelse Key =:= 13 orelse Key =:= 17 orelse Key =:= 18 orelse Key =:= 14 of
%%											true ->
%%												Acc;
%%											false ->
%%												[FunctionId] ++ Acc
%%										end;
%%									false ->
%%										%%去掉本服暗殿(7,9)及本服火龙(11,12,19)本服幻境(15)
%%										case Key =:= 7 orelse Key =:= 9 orelse Key =:= 11 orelse Key =:= 12 orelse Key =:= 19 orelse Key =:= 15 of
%%											true ->
%%												Acc;
%%											false ->
%%												[FunctionId] ++ Acc
%%										end
%%								end;
							_ ->
								Acc
						end
					end,
					OpenList1 = lists:foldl(Fun, [], OpenList),

					CloseList = [X || {_, X} <- R#ets_active_remind.close_function_list],
					FunctionList = PlayerState#player_state.function_open_list,
					NewFunctionList = OpenList1 ++ FunctionList -- CloseList,

					case NewFunctionList =/= [] of
						true ->
							net_send:send_to_client(PlayerState#player_state.socket, 28000, #rep_ref_function_open_list{function_open_list = NewFunctionList});
						false ->
							skip
					end,
					case CloseList =/= [] of
						true ->
							net_send:send_to_client(PlayerState#player_state.socket, 28002, #rep_ref_function_close_list{function_close_list = CloseList});
						false ->
							skip
					end,
					PlayerState#player_state{function_open_list = NewFunctionList, active_remind_list = OpenList}
			end;
		_ ->
			PlayerState
	end.

%% 更新开启的功能id
update_active_remind_function() ->
	ConfList = active_remind_config:get_list_conf(),
	WeekDay = util_date:get_week(),
	{{_, _, _Day}, DateTime} = calendar:local_time(),
	Fun = fun(Conf, Acc) ->
		case lists:member(WeekDay, Conf#active_remind_conf.type) of
			true ->
				List = [{Conf#active_remind_conf.key, F} || {F, Time1, Time2} <- Conf#active_remind_conf.time_list,
					(DateTime >= Time1 andalso DateTime < Time2)],
				List ++ Acc;
			false ->
				Acc
		end
	end,
	FunctionList = lists:foldl(Fun, [], ConfList),

	case active_instance_lib:is_open_double_exp_active() of
		{ok, _} ->
			check_double_exp(true);
		_ ->
			check_double_exp(false)
	end,

	case ets:lookup(?ETS_ACTIVE_REMIND, 1) of
		[R | _] ->
			R1 = case R#ets_active_remind.open_function_list == FunctionList of
					 true ->
						 R;
					 false ->
						 R#ets_active_remind
						 {
							 open_function_list = FunctionList,
							 close_function_list = R#ets_active_remind.open_function_list
						 }
				 end,
			ets:insert(?ETS_ACTIVE_REMIND, R1);
		_ ->
			R1 = #ets_active_remind
			{
				key = 1,
				open_function_list = [],
				close_function_list = []
			},
			ets:insert(?ETS_ACTIVE_REMIND, R1)
	end.


%% 活动进入条件检测
check_active_remind_cond_list(_State, []) ->
	{ok, true};
check_active_remind_cond_list(State, [H | T]) ->
	case check_active_remind_cond(State, H) of
		{ok, true} ->
			check_active_remind_cond_list(State, T);
		{fail, Reply} ->
			{fail, Reply}
	end.

check_active_remind_cond(State, {guild_lv, LimitLv}) ->
	DPB = State#player_state.db_player_base,
	GuildId = DPB#db_player_base.guild_id,
	case guild_cache:get_guild_info_from_ets(GuildId) of
		[] ->
			{fail, ?ERR_GUILD_LV_NOT_ENOUGH};
		GuildInfo ->
			case GuildInfo#db_guild.lv >= LimitLv of
				true ->
					{ok, true};
				false ->
					{fail, ?ERR_GUILD_LV_NOT_ENOUGH}
			end
	end;
check_active_remind_cond(State, {player_lv, LimitLv}) ->
	DbBase = State#player_state.db_player_base,
	case DbBase#db_player_base.lv >= LimitLv of
		true ->
			{ok, true};
		false ->
			{fail, ?ERR_PLAYER_LV_NOT_ENOUGH}
	end;
check_active_remind_cond(_State, {sbk_open_limit}) ->
	case scene_activity_palace_lib:is_open() of
		true ->
			{fail, ?ERR_ACTIVE_TIME_LIMIT};
		false ->
			{ok, true}
	end;
check_active_remind_cond(_State, _Other) ->
	?DEBUG("not defined cond arameter in guild_active: ~p", [_Other]),
	{fail, ?ERR_COMMON_FAIL}.


check_double_exp(State) ->
	OldState = get(?NOTICE_MOD_DOUBLE_EXP),
	case OldState == State of
		true -> next;
		_ ->
			case OldState == undefined andalso State == false of
				true -> next;
				_ ->
					put(?NOTICE_MOD_DOUBLE_EXP, State),
					active_service_merge_lib:check_double_exp()
			end
	end.

