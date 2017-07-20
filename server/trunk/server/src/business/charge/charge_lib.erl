%%%-------------------------------------------------------------------
%%% @author tuhujia
%%% @copyright (C) 2016, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 26. 一月 2016 14:44
%%%-------------------------------------------------------------------
-module(charge_lib).

-include("common.hrl").
-include("record.hrl").
-include("config.hrl").
-include("cache.hrl").
-include("db_record.hrl").
-include("proto.hrl").
-include("language_config.hrl").
-include("uid.hrl").
-include("log_type_config.hrl").
-include("button_tips_config.hrl").

-export([
	buy_charge/2,
	get_already_buy_charge/1,
	buy_charge_pay/2,
	receive_charge_month/1,
	bug_charge_month/2,
	get_charge_month_info/1,
	get_button_tips/1,
	get_player_charge/1
]).

%%% ----------------------------------------------------------------------------
%%% 对外接口
%%% ----------------------------------------------------------------------------
%% 购买对应充值商品
buy_charge(PlayerState, Key) ->
	PlayerId = PlayerState#player_state.player_id,
	ChargeConf = charge_config:get(Key),
	Result1 = case ChargeConf#charge_conf.month_day =:= 0 of
				  true ->
					  0;
				  _ ->
					  {State, _OverNum, _} = get_charge_month_info(PlayerState),
					  case State /= 1 of
						  true ->
							  ?ERR_BUT_MONTH_PAY;
						  _ ->
							  0
					  end
			  end,

	%% 验证
	Result = check_charge(PlayerId, ChargeConf, Result1),

	case Result =:= 0 of
		true ->
			PlayerChargeInfo = #db_player_charge{
				id = uid_lib:get_uid(?UID_TYPE_PLAYER_CHARGE),
				player_id = PlayerId,
				charge_key = Key,
				platform = PlayerState#player_state.platform,
				rmb = ChargeConf#charge_conf.rmb,
				charge_time = util_date:unixtime(),
				state = 0
			},
			%% 返回定单id
			player_charge_db:insert(PlayerChargeInfo),

			%%统计
			#charge_conf{rmb = Money, jade = Virtual} = ChargeConf,
			#db_player_charge{id = ChargeId, platform = Platform} = PlayerChargeInfo,
			Server = config:get_server_no(),
			stat_lib:charge(PlayerId, Money, Virtual, Platform, Server, ChargeId, false, false),

%% 			{ok, 0, PlayerState2} = buy_charge_pay(PlayerState, PlayerChargeInfo#db_player_charge.id),
			case buy_create_pay(PlayerState, PlayerChargeInfo) of
				false ->
					{?ERR_COMMON_FAIL, 0, PlayerState};
				CId ->
					{0, CId, PlayerState}
			end;
		_ ->
			{Result, 0, PlayerState}
	end.
%% 创建定单
buy_create_pay(PlayerState, ChargeInfo) ->
	#player_state{open_id = OpenId, player_id = PlayerId, platform = Plat} = PlayerState,
	case Plat of
		1010 ->
			try

				%% erlang原生代码
				%% inets:start(),
				%% ssl:start(),
				%% 组合兑换码参数
				TestData = lists:concat([
					"charge_id=", ChargeInfo#db_player_charge.id,
					"&amount=", ChargeInfo#db_player_charge.rmb,
					"&open_id=", bitstring_to_list(OpenId),
					"&player_id=", PlayerId,
					"&plat=", Plat,
					"&service_id=", config:get_server_no()
				]),
				%%{ok, {_,_,Body}}
				%% http请求 获取内容
				{ok, {_, _, Body}} = httpc:request(post, {"http://123.206.225.144/zfmSDKbase/index.php?__s__=/Order/addOrder",
					[], "application/x-www-form-urlencoded", TestData}, [], []),
				List = string:tokens(Body, "&"),
				[Reslut | Order] = List,
				case Reslut of
					"true" ->
						Order;
					_ ->
						?ERR("~p", [Body]),
						false
				end
			catch
				Error:Info ->
					?ERR("~p:~p, stacktrace:~p~n", [Error, Info, erlang:get_stacktrace()]),
					false
			end;
		%%6kw越狱
		_ ->
			server_creat_order(PlayerState, ChargeInfo),
			ChargeInfo#db_player_charge.id
	end.

server_creat_order(PlayerState, ChargeInfo) ->
	#player_state{open_id = OpenId, player_id = PlayerId, platform = Plat} = PlayerState,
	try
		ChargeConf = charge_config:get(ChargeInfo#db_player_charge.charge_key),
		TestData = lists:concat([
			"charge_id=", ChargeInfo#db_player_charge.id,
			"&rmb=", ChargeInfo#db_player_charge.rmb,
			"&jade=", ChargeConf#charge_conf.jade,
			"&open_id=", bitstring_to_list(OpenId),
			"&player_id=", PlayerId,
			"&plat=", Plat,
			"&service_id=", config:get_server_no()
		]),
		%%{ok, {_,_,Body}}
		%% http请求 获取内容
		{ok, {_, _, Body}} = httpc:request(post, {"http://123.206.225.144/zfmSDKbase/index.php?__s__=/Order/addOrder",
			[], "application/x-www-form-urlencoded", TestData}, [], []),
		List = string:tokens(Body, "&"),
		[Reslut | Order] = List,
		case Reslut of
			"true" ->
				Order;
			_ ->
				?ERR("~p", [Body]),
				false
		end
	catch
		Error:Info ->
			?ERR("~p:~p, stacktrace:~p~n", [Error, Info, erlang:get_stacktrace()]),
			false
	end.

%% PI修改状态信息
buy_charge_pay(PlayerPid, PlayerChargeId) when is_pid(PlayerPid) ->
	gen_server2:apply_sync(PlayerPid, {?MODULE, buy_charge_pay, [PlayerChargeId]});

%% 购买对应充值 离线购买CHARGE_PAY
buy_charge_pay(PlayerId, PlayerChargeId) when is_number(PlayerId) ->
	%% 修改定单状态
	PlayerChargeInfo = player_charge_db:select_row({PlayerChargeId, PlayerId}),
	case PlayerChargeInfo =:= null of
		true ->
			?ERR("not find charge !!!!!! ~p", [{PlayerId, PlayerChargeId}]),
			{fail, -9};
		_ ->
			case PlayerChargeInfo#db_player_charge.state of
%%				0 -> %% 定单开始
%%					?ERR("charge state error !!!!!!!", []),
%%					{fail, -9};
				2 -> %% 定单以结束
					{ok, 0};
				0 -> %% 定单已经验证
					%% 获取定单详细信息
					ChargeConf = charge_config:get(PlayerChargeInfo#db_player_charge.charge_key),

					%% 订单的安全验证
					case check_charge(PlayerId, ChargeConf, 0) /= 0 of
						true ->
							%% 订单次数验证失败
							%% 修改定单信息
							PlayerChargeInfo1 = PlayerChargeInfo#db_player_charge{
								state = 2,
								is_bad = 1
							},
							player_charge_db:update({PlayerChargeId, PlayerId}, PlayerChargeInfo1),
							{ok, 0};
						_ ->
							%% 订单次数验证成功

							%% 充值验证次数添加
							TimeCounterId = ChargeConf#charge_conf.time_counter_id,
							case TimeCounterId > 0 of
								true ->
									counter_lib:update_value_limit(PlayerId, TimeCounterId, 1);
								_ ->
									skip
							end,

							%% 修改定单信息
							PlayerChargeInfo1 = PlayerChargeInfo#db_player_charge{
								state = 2
							},
							player_charge_db:update({PlayerChargeId, PlayerId}, PlayerChargeInfo1),

							%% 判断 实际充值的元宝 返回实际获取的元宝 和 vip 经验值
							{AddJade, AddVipExp} = case PlayerChargeInfo1#db_player_charge.rmb < ChargeConf#charge_conf.rmb of
													   true ->
														   Jade = PlayerChargeInfo1#db_player_charge.rmb * 10,
														   {Jade, Jade};
													   _ ->
														   VipExp = PlayerChargeInfo1#db_player_charge.rmb * 10,
														   Jade = case ChargeConf#charge_conf.month_day /= 0 of
																	  true ->
																		  bug_charge_month(PlayerId, ChargeConf),
																		  ChargeConf#charge_conf.jade;
																	  _ ->
																		  PlayerChargeInfo1#db_player_charge.rmb * 10
																  end,
														   %%Jade = ChargeConf#charge_conf.jade,
														   CounterId = ChargeConf#charge_conf.counter_id,
														   %% 获取定单额外获取元宝 数量
														   VipLv = case player_base_cache:select_row(PlayerId) of
																	   #db_player_base{} = DPB ->
																		   DPB#db_player_base.vip;
																	   _ ->
																		   0
																   end,
														   %% VIP8后，永久充值双倍
														   FreeJade =
															   case VipLv >= 8 of
																   true ->
																	   Jade;
																   false ->
																	   case counter_lib:get_value(PlayerId, CounterId) == 0 of
																		   true ->
																			   counter_lib:update(PlayerId, ?COUNTER_FIRST_CHARGE),
																			   counter_lib:update(PlayerId, CounterId),
																			   ChargeConf#charge_conf.first_giving;
																		   false ->
																			   counter_lib:update(PlayerId, ?COUNTER_FIRST_CHARGE),
																			   counter_lib:update(PlayerId, CounterId),
																			   ChargeConf#charge_conf.common_giving
																	   end
															   end,
														   %% 总元宝数
														   {Jade + FreeJade, VipExp}
												   end,
							player_lib:add_money_to_logout_player(PlayerId, #db_player_money.jade, AddJade, ?LOG_TYPE_CHARGE_PAY),
							vip_lib:add_vip_exp(PlayerId, AddVipExp),


							%%统计
							Virtual = AddJade,
							#db_player_charge{id = ChargeId, platform = Platform, rmb = Money} = PlayerChargeInfo1,
							Server = config:get_server_no(),

							red_lib:send_red_charge(PlayerId, Money, false),
							stat_lib:charge(PlayerId, Money, Virtual, Platform, Server, ChargeId, false, true),

							%% 开服活动处理
							active_service_lib:insert_active_record(?ACTIVE_SERVICE_TYPE_CHARGE, PlayerId, PlayerChargeInfo1#db_player_charge.rmb),
							active_service_lib:insert_active_record(?ACTIVE_SERVICE_TYPE_CHARGE_BY_EXP, PlayerId, PlayerChargeInfo1#db_player_charge.rmb),
							active_service_merge_lib:insert_active_record(?MERGE_ACTIVE_SERVICE_TYPE_CHARGE_BY_EXP, PlayerId, PlayerChargeInfo1#db_player_charge.rmb),
							active_service_merge_lib:insert_active_record(?MERGE_ACTIVE_SERVICE_FRIST_PAY, PlayerId, PlayerChargeInfo1#db_player_charge.rmb),
							%% 限时活动统计检测
							operate_active_lib:update_limit_type(#player_state{player_id = PlayerId}, ?OPERATE_ACTIVE_LIMIT_TYPE_2, PlayerChargeInfo1#db_player_charge.rmb),
							{ok, 0}
					end
			end
	end;
%% 购买对应充值商品 在线购买
buy_charge_pay(PlayerState, PlayerChargeId) ->
	PlayerId = PlayerState#player_state.player_id,
	%% 修改定单状态
	PlayerChargeInfo = player_charge_db:select_row({PlayerChargeId, PlayerId}),
	case PlayerChargeInfo =:= null of
		true ->
			{fail, -9};
		_ ->
			case PlayerChargeInfo#db_player_charge.state of
%%				0 -> %% 定单开始
%%					{fail, -9};
				2 -> %% 定单以结束
					{ok, 0, PlayerState};
				0 -> %% 定单已经验证
					%% 获取定单详细信息
					ChargeConf = charge_config:get(PlayerChargeInfo#db_player_charge.charge_key),
					%% 订单的安全验证
					case check_charge(PlayerId, ChargeConf, 0) /= 0 of
						true ->
							%% 订单次数验证失败
							%% 修改定单信息
							PlayerChargeInfo1 = PlayerChargeInfo#db_player_charge{
								state = 2,
								is_bad = 1
							},
							player_charge_db:update({PlayerChargeId, PlayerId}, PlayerChargeInfo1),
							{ok, 0, PlayerState};
						_ ->
							%% 订单次数验证成功

							%% 充值验证次数添加
							TimeCounterId = ChargeConf#charge_conf.time_counter_id,
							case TimeCounterId > 0 of
								true ->
									counter_lib:update_value_limit(PlayerId, TimeCounterId, 1);
								_ ->
									skip
							end,
							%% 修改定单信息
							PlayerChargeInfo1 = PlayerChargeInfo#db_player_charge{
								state = 2
							},
							player_charge_db:update({PlayerChargeId, PlayerId}, PlayerChargeInfo1),

							%% 获取定单详细信息
							ChargeConf = charge_config:get(PlayerChargeInfo#db_player_charge.charge_key),

							%% 判断 实际充值的元宝 返回实际获取的元宝 和 vip 经验值
							{AddJade, AddVipExp} = case PlayerChargeInfo1#db_player_charge.rmb < ChargeConf#charge_conf.rmb of
													   true ->
														   Jade = PlayerChargeInfo1#db_player_charge.rmb * 10,
														   {Jade, Jade};
													   _ ->
														   VipExp = PlayerChargeInfo1#db_player_charge.rmb * 10,
														   Jade = case ChargeConf#charge_conf.month_day /= 0 of
																	  true ->
																		  bug_charge_month(PlayerId, ChargeConf),
																		  ChargeConf#charge_conf.jade;
																	  _ ->
																		  PlayerChargeInfo1#db_player_charge.rmb * 10
																  end,

														   %%Jade = ChargeConf#charge_conf.jade,
														   CounterId = ChargeConf#charge_conf.counter_id,
														   %% 获取定单额外获取元宝 数量
														   VipLv = case player_base_cache:select_row(PlayerId) of
																	   #db_player_base{} = DPB ->
																		   DPB#db_player_base.vip;
																	   _ ->
																		   0
																   end,
														   %% VIP8后，永久充值双倍
														   FreeJade =
															   case VipLv >= 8 of
																   true ->
																	   counter_lib:update(PlayerId, ?COUNTER_FIRST_CHARGE),
																	   counter_lib:update(PlayerId, CounterId),
																	   Jade;
																   false ->
																	   case counter_lib:get_value(PlayerId, CounterId) == 0 of
																		   true ->
																			   counter_lib:update(PlayerId, ?COUNTER_FIRST_CHARGE),
																			   counter_lib:update(PlayerId, CounterId),
																			   ChargeConf#charge_conf.first_giving;
																		   false ->
																			   counter_lib:update(PlayerId, ?COUNTER_FIRST_CHARGE),
																			   counter_lib:update(PlayerId, CounterId),
																			   ChargeConf#charge_conf.common_giving
																	   end
															   end,
														   %% 总元宝数
														   {Jade + FreeJade, VipExp}
												   end,
							%%添加元宝
							{ok, PlayerState1} = player_lib:incval_on_player_money_log(PlayerState, #db_player_money.jade, AddJade, ?LOG_TYPE_CHARGE_PAY),
							?INFO(" 111 ~p", [PlayerState1#player_state.db_player_money]),
							%% 添加经验
							PlayerState2 = vip_lib:add_vip_exp(PlayerState1, AddVipExp),
							?INFO(" 222 ~p", [PlayerState2#player_state.db_player_money]),
							%% 刷新充值列表
							List = charge_lib:get_already_buy_charge(PlayerState2),
							net_send:send_to_client(PlayerState#player_state.socket, 30002, #rep_get_charge_list{key_list = List}),

							%%统计
							Virtual = AddJade,
							#db_player_charge{id = ChargeId, platform = Platform, rmb = Money} = PlayerChargeInfo1,
							Server = config:get_server_no(),
							stat_lib:charge(PlayerId, Money, Virtual, Platform, Server, ChargeId, false, true),

							%% 刷新首充活动
							Proto = welfare_active_lib:get_active_info(PlayerState),
							%% 开服活动处理
							active_service_lib:insert_active_record(?ACTIVE_SERVICE_TYPE_CHARGE, PlayerId, PlayerChargeInfo1#db_player_charge.rmb),
							active_service_lib:insert_active_record(?ACTIVE_SERVICE_TYPE_CHARGE_BY_EXP, PlayerId, PlayerChargeInfo1#db_player_charge.rmb),
							active_service_merge_lib:insert_active_record(?MERGE_ACTIVE_SERVICE_TYPE_CHARGE_BY_EXP, PlayerId, PlayerChargeInfo1#db_player_charge.rmb),
							active_service_merge_lib:insert_active_record(?MERGE_ACTIVE_SERVICE_FRIST_PAY, PlayerId, PlayerChargeInfo1#db_player_charge.rmb),
							%% 限时活动统计检测
							operate_active_lib:update_limit_type(PlayerState, ?OPERATE_ACTIVE_LIMIT_TYPE_2, PlayerChargeInfo1#db_player_charge.rmb),
							%% io:format("32001 :~p~n", [Proto]),
							net_send:send_to_client(PlayerState#player_state.socket, 32001, #rep_get_active_info{info_list = Proto}),
							%% 刷新红点
							active_service_merge_lib:ref_button_tips(PlayerState2, ?MERGE_ACTIVE_SERVICE_TYPE_CHARGE_BY_EXP),
							active_service_merge_lib:ref_button_tips(PlayerState2, ?MERGE_ACTIVE_SERVICE_FRIST_PAY),

							red_lib:send_red_charge(PlayerId, Money, false),

							{ok, 0, PlayerState2}
					end

			end
	end.


%% 月卡处理
bug_charge_month(PlayerId, ChargeConf) ->
	case player_month_cache:select_row(PlayerId) of
		null ->
			PlayerMonthInfo1 = #db_player_month{
				player_id = PlayerId,
				begin_time = util_date:get_tomorrow_unixtime(),
				time = util_date:get_tomorrow_unixtime(),
				end_time = util_date:get_tomorrow_unixtime() + ChargeConf#charge_conf.month_day * ?DAY_TIME_COUNT,
				charge_key = ChargeConf#charge_conf.key,
				is_jade = 0
			},
			player_month_cache:insert(PlayerMonthInfo1);
		PlayerMonthInfo ->
			PlayerMonthInfo1 = case PlayerMonthInfo#db_player_month.end_time < util_date:unixtime() of
								   true ->
									   PlayerMonthInfo#db_player_month{
										   begin_time = util_date:get_tomorrow_unixtime(),
										   time = util_date:get_tomorrow_unixtime(),
										   is_jade = 0,
										   end_time = util_date:get_tomorrow_unixtime() + ChargeConf#charge_conf.month_day * ?DAY_TIME_COUNT
									   };
								   _ ->
									   PlayerMonthInfo#db_player_month{
										   is_jade = 0,
										   end_time = PlayerMonthInfo#db_player_month.end_time + ChargeConf#charge_conf.month_day * ?DAY_TIME_COUNT
									   }
							   end,
			player_month_cache:update(PlayerId, PlayerMonthInfo1)
	end.

%% 获取月卡信息
get_charge_month_info(PlayerState) ->
%% 1，没有购买月卡，2，可以领取奖励，3，奖励已经领取过了
	case player_month_cache:select_row(PlayerState#player_state.player_id) of
		null ->
			{1, 0, null};
		PlayerMonthInfo ->
			Time = case PlayerMonthInfo#db_player_month.time > util_date:get_today_unixtime() of
					   true ->
						   PlayerMonthInfo#db_player_month.time;
					   _ ->
						   util_date:get_today_unixtime()
				   end,
			DayNum = (PlayerMonthInfo#db_player_month.end_time - Time) div ?DAY_TIME_COUNT,
			case DayNum < 1 of
				true ->
					{1, 0, PlayerMonthInfo};
				_ ->
					case PlayerMonthInfo#db_player_month.time > util_date:unixtime() of
						true ->
							{3, DayNum, PlayerMonthInfo};
						_ ->
							{2, DayNum, PlayerMonthInfo}
					end
			end
	end.
%% 领取月卡奖励
receive_charge_month(PlayerState) ->
	%% 1，没有购买月卡，2，可以领取奖励，3，奖励已经领取过了
	{State, _OverNum, PlayerMonthInfo} = get_charge_month_info(PlayerState),
	case State /= 2 of
		true ->
			{fail, ?ERR_MAIN_TASK1};
		_ ->
			ChargeConf = charge_config:get(PlayerMonthInfo#db_player_month.charge_key),
			{ok, PlayerState1} = case PlayerMonthInfo#db_player_month.is_jade of
									 1 ->
										 player_lib:incval_on_player_money_log(PlayerState, #db_player_money.jade, ChargeConf#charge_conf.month_jade, ?LOG_TYPE_MONTH_CHARGE);
									 _ ->
										 player_lib:incval_on_player_money_log(PlayerState, #db_player_money.gift, ChargeConf#charge_conf.month_jade, ?LOG_TYPE_MONTH_CHARGE)
								 end,

			PlayerMonthInfo1 = PlayerMonthInfo#db_player_month{
				time = util_date:get_tomorrow_unixtime()
			},
			player_month_cache:update(PlayerState#player_state.player_id, PlayerMonthInfo1),

			%% 红点刷新
			button_tips_lib:ref_button_tips(PlayerState1, ?BTN_MONTH_GOODS),
			{ok, PlayerState1}
	end.

%% 获取已购买的key
get_already_buy_charge(PlayerState) ->
	PlayerId = PlayerState#player_state.player_id,
	Fun = fun(ChargeConf, Acc) ->
		CounterId = ChargeConf#charge_conf.counter_id,
		case counter_lib:get_value(PlayerId, CounterId) == 0 of
			true -> Acc;
			false -> [ChargeConf#charge_conf.key] ++ Acc
		end
	end,
	lists:foldl(Fun, [], charge_config:get_list_conf()).

%% 获取玩家的累计充值信息
get_player_charge(PlayerState) ->
	player_charge_db:select_charge_num(PlayerState#player_state.player_id).


%% ＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊
%% api
%% ＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊

%% 充值成功验证
check_charge(PlayerId, ChargeConf, Result1) ->
	%% 充值间隔验证
	CurTime = util_date:unixtime(),
	TimeCountId = ChargeConf#charge_conf.time_counter_id,
	case TimeCountId > 0 of
		true ->
			{Num, Time} = counter_lib:get_value_time(PlayerId, TimeCountId),
			[ChargeTimeConf | _] = [X ||
				#charge_times_conf{min_num = MinNum, max_num = MaxNum} = X <- charge_times_config:get_list_conf(),
				Num >= MinNum, Num =< MaxNum
			],
%% 			?ERR("~p", [{Num, CurTime, Time, ChargeTimeConf#charge_times_conf.time}]),
			case CurTime - Time >= ChargeTimeConf#charge_times_conf.time of
				true ->
					Result1;
				_ ->
					?ERR_COMMON_FAIL
			end;
		_ ->
			Result1
	end.

%% -----------------------------------------------------红点提示
%% -----------------------------------------------------红点提示
%% -----------------------------------------------------红点提示
get_button_tips(PlayerState) ->
	{State, _OverNum, _} = get_charge_month_info(PlayerState),
	case State /= 2 of
		true ->
			{PlayerState, 0};
		_ ->
			{PlayerState, 1}
	end.


