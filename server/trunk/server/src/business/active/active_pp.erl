%%%-------------------------------------------------------------------
%%% @author tuhujia
%%% @copyright (C) 2016, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 29. 一月 2016 11:51
%%%-------------------------------------------------------------------
-module(active_pp).

-include("common.hrl").
-include("record.hrl").
-include("proto.hrl").
-include("cache.hrl").
-include("config.hrl").
-include("language_config.hrl").
-include("rank.hrl").
-include("log_type_config.hrl").
-include("button_tips_config.hrl").
%% API
-export([
	handle/3
]).

%% ====================================================================
%% API functions
%% ====================================================================

%% 获取活动信息
handle(32001, PlayerState, _Data) ->
	Proto = welfare_active_lib:get_active_info(PlayerState),
	?INFO("~p", [Proto]),
	net_send:send_to_client(PlayerState#player_state.socket, 32001, #rep_get_active_info{info_list = Proto});

handle(32046, PlayerState, #req_get_type_active_info{type = Type}) ->
	Proto = welfare_active_lib:get_active_info(PlayerState, Type),
	?INFO("~p", [Proto]),
	net_send:send_to_client(PlayerState#player_state.socket, 32046, #rep_get_active_info{info_list = Proto});

%% 获取玩家当天登录游戏时长
handle(32002, PlayerState, _Data) ->
	Times = welfare_active_lib:get_player_online_times(PlayerState),
	%% io:format("32002 :~p~n", [Times]),
	net_send:send_to_client(PlayerState#player_state.socket, 32002, #rep_get_login_times{times = Times});

%% 领取活动奖励
handle(32003, PlayerState, #req_get_active_reward{key = Key}) ->
	%% io:format("32003 :~p~n", [Key]),
	case welfare_active_lib:get_reward(PlayerState, Key) of
		{ok, PlayerState1} ->
			%% io:format("32003 :~p~n", [?ERR_COMMON_SUCCESS]),
			net_send:send_to_client(PlayerState#player_state.socket, 32003, #rep_get_active_reward{result = ?ERR_COMMON_SUCCESS, key = Key}),
			{ok, PlayerState1};
		{fail, Reply} ->
			%% io:format("32003 :~p~n", [Reply]),
			net_send:send_to_client(PlayerState#player_state.socket, 32003, #rep_get_active_reward{result = Reply, key = Key})
	end;

%% 获取首充奖励列表
handle(32005, PlayerState, _Data) ->
	welfare_active_lib:get_first_charge_reward(PlayerState);

%% 获取签到状态
handle(32006, PlayerState, _Data) ->
	case lists:member(34, PlayerState#player_state.function_open_list) of
		true ->
			everyday_sign_lib:send_player_sign_info(PlayerState);
		false ->
			skip
	end;

%% 获取首充奖励列表
handle(32007, PlayerState, _Data) ->
	case everyday_sign_lib:sign_reward(PlayerState) of
		{ok, PlayerState1} ->
			net_send:send_to_client(PlayerState#player_state.socket, 32007, #rep_everyday_sign{result = ?ERR_COMMON_SUCCESS}),
			{ok, PlayerState1};
		{fail, Reply} ->
			net_send:send_to_client(PlayerState#player_state.socket, 32007, #rep_everyday_sign{result = Reply})
	end;

%% 进入活动副本(跨服活动)
handle(32008, PlayerState, #req_enter_active_instance{active_id = ActiveId}) ->
	case active_instance_lib:enter_active_instance(PlayerState, ActiveId) of
		{ok, PlayerState1} ->
			net_send:send_to_client(PlayerState#player_state.socket, 32008, #rep_enter_active_instance{result = ?ERR_COMMON_SUCCESS}),
			{ok, PlayerState1};
		{fail, Reply} ->
			net_send:send_to_client(PlayerState#player_state.socket, 32008, #rep_enter_active_instance{result = Reply})
	end;

%% 获取等级排行
handle(32009, PlayerState, #req_get_lv_rank_info{type = Type, page = Page}) ->
	RankList = rank_lib:get_rank_list(?ETS_RANK_PLAYER_LV),
	Proto = rank_lib:get_rank_list_data(?ETS_RANK_PLAYER_LV, RankList, Page, Type),

	PlayerId = PlayerState#player_state.player_id,
	PlayerRank = rank_lib:get_rank(?ETS_RANK_PLAYER_LV, RankList, PlayerId),
	net_send:send_to_client(PlayerState#player_state.socket, 32009, #rep_get_lv_rank_info{rank = PlayerRank, rank_list = Proto});

%% 获取战力排行
handle(32010, PlayerState, #req_get_fight_rank_info{type = Type, page = Page}) ->
	RankList = rank_lib:get_rank_list(?ETS_RANK_PLAYER_FIGHT),
	Proto = rank_lib:get_rank_list_data(?ETS_RANK_PLAYER_FIGHT, RankList, Page, Type),

	PlayerId = PlayerState#player_state.player_id,
	PlayerRank = rank_lib:get_rank(?ETS_RANK_PLAYER_FIGHT, RankList, PlayerId),
	net_send:send_to_client(PlayerState#player_state.socket, 32010, #rep_get_fight_rank_info{rank = PlayerRank, rank_list = Proto});

%% 获取行会排行
handle(32011, PlayerState, #req_get_guild_rank_info{page = Page}) ->
	RankList = rank_lib:get_rank_list(?ETS_RANK_GUILD_LV),
	Proto = rank_lib:get_rank_list_data(?ETS_RANK_GUILD_LV, RankList, Page),

	DPB = PlayerState#player_state.db_player_base,
	GuildId = DPB#db_player_base.guild_id,
	Rank = rank_lib:get_rank(?ETS_RANK_GUILD_LV, RankList, GuildId),
	net_send:send_to_client(PlayerState#player_state.socket, 32011, #rep_get_guild_rank_info{rank = Rank, rank_list = Proto});

%% 获取开服活动相关列表
handle(32012, PlayerState, #req_active_service_list{type = ActiveServiceType}) ->
	?INFO("32012 11 ~p", [ActiveServiceType]),
	{BeginTime, EndTime, _, ActiveServiceTypeConf} = active_service_lib:get_active_time(ActiveServiceType),
	active_service_lib:ref_button_tips1(PlayerState, ActiveServiceType),
	active_service_lib:send_active_service_info(PlayerState, ActiveServiceTypeConf, BeginTime, EndTime);

%% 领取开服活动奖励
handle(32013, PlayerState, #req_receive_goods{active_service_id = ActiveServiceId}) ->
	?INFO("132013 ~p", [ActiveServiceId]),
	ActiveServiceConf = active_service_config:get(ActiveServiceId),
	case active_service_lib:receive_goods(PlayerState, ActiveServiceConf) of
		{fail, Err} ->
			net_send:send_to_client(PlayerState#player_state.socket, 32013, #rep_receive_goods{result = Err});
		{ok, NewPlayerState} ->
			net_send:send_to_client(PlayerState#player_state.socket, 32013, #rep_receive_goods{result = 0}),
			%% 刷新红点
			active_service_lib:ref_button_tips(NewPlayerState, ActiveServiceConf#active_service_conf.type) %%
	end;

%% 获取签到功能列表
handle(32014, PlayerState, _Data) ->
	sign_lib:proto_get_player_sign_info(PlayerState);

%% 玩家签到
handle(32015, PlayerState, _Data) ->
	case sign_lib:player_sign(PlayerState) of
		{fail, Err} ->
			net_send:send_to_client(PlayerState#player_state.socket, 32015, #rep_player_sign{result = Err});
		{ok, _} ->
			sign_lib:proto_get_player_sign_info(PlayerState),
			net_send:send_to_client(PlayerState#player_state.socket, 32015, #rep_player_sign{result = 0})
	end;


%% 玩家补签
handle(32016, PlayerState, _Data) ->
	case sign_lib:repair_sign(PlayerState) of
		{fail, Err} ->
			net_send:send_to_client(PlayerState#player_state.socket, 32016, #rep_player_repair_sig{result = Err});
		{ok, PlayerState1} ->
			sign_lib:proto_get_player_sign_info(PlayerState),
			net_send:send_to_client(PlayerState#player_state.socket, 32016, #rep_player_repair_sig{result = 0}),
			{ok, PlayerState1}
	end;

%% 玩家领取签到奖励
handle(32017, PlayerState, #req_player_sign_reward{days = Days}) ->
	case sign_lib:get_sign_reward(PlayerState, Days) of
		{fail, Err} ->
			net_send:send_to_client(PlayerState#player_state.socket, 32017, #rep_player_sign_reward{result = Err});
		{ok, NewPlayerState} ->
			sign_lib:proto_get_player_sign_info(PlayerState),
			net_send:send_to_client(PlayerState#player_state.socket, 32017, #rep_player_sign_reward{result = 0}),
			{ok, NewPlayerState}
	end;

%% 获取开启的活动列表
handle(32019, PlayerState, _Data) ->
	TypeInfoList = active_lib:get_show_active_type_list(),
	?INFO("32019 ~p", [TypeInfoList]),
	net_send:send_to_client(PlayerState#player_state.socket, 32019, #rep_get_active_service_type_list{type_info_list = TypeInfoList});

%% 获取运营活动
handle(32020, PlayerState, _Data) ->
	[L1, L2, L3] = operate_active_lib:get_player_operate_active_info(PlayerState),
	Proto = #rep_get_operate_active_info{
		list = L1,
		list2 = L2,
		list3 = L3
	},
	net_send:send_to_client(PlayerState#player_state.socket, 32020, Proto);

%% 领取运营活动奖励
handle(32021, PlayerState, #req_receive_reward{active_id = Id}) ->
	case operate_active_lib:receive_reward(PlayerState, Id) of
		{ok, PlayerState1, State} ->
			net_send:send_to_client(PlayerState#player_state.socket, 32021, #rep_receive_reward{result = State}),
			{ok, PlayerState1};
		{fail, Reply} ->
			net_send:send_to_client(PlayerState#player_state.socket, 32021, #rep_receive_reward{result = Reply})
	end;

%% 领取特殊运营活动奖励
handle(32045, PlayerState, #req_new_receive_reward{active_id = Id, sub_type = SubType}) ->
	case operate_active_lib:receive_reward(PlayerState, Id, SubType) of
		{ok, PlayerState1, State} ->
			net_send:send_to_client(PlayerState#player_state.socket, 32045, #rep_new_receive_reward{result = ?ERR_COMMON_SUCCESS, active_id = Id, sub_type = SubType, value = State}),
			{ok, PlayerState1};
		{fail, Reply} ->
			net_send:send_to_client(PlayerState#player_state.socket, 32045, #rep_new_receive_reward{result = Reply})
	end;

handle(32030, PlayerState, _) ->
	exam_lib:start(PlayerState);

handle(32031, PlayerState, #req_exam_choice{ex_index = ExIndex, choice = Choice}) ->
	exam_lib:choice(PlayerState, ExIndex, Choice, false);

handle(32032, PlayerState, _) ->
	exam_lib:rank(PlayerState);

handle(32033, PlayerState, #req_exam_tool{type = ToolType, ex_index = ExIndex}) ->
	exam_lib:use_tool(PlayerState, ToolType, ExIndex);

%%触发活动条件
handle(32034, PlayerState, #req_activity_trigger{type = Type}) ->
	Rep =
		case Type of
		%%玩家下载分包获取礼包
			1 ->
				#player_state{db_player_base = #db_player_base{lv = Lv}} = PlayerState,
				case Lv >= 40 of
					true ->
						#rep_activity_trigger{result = 0};
					false ->
						#rep_activity_trigger{result = 1}
				end;
			_ ->
				#rep_activity_trigger{result = 1}
		end,
	net_send:send_to_client(PlayerState#player_state.socket, 32034, Rep);

%% 获取活动相关排名
handle(32035, PlayerState, #req_active_rank{active_id = Id}) ->
	RankList = rank_lib:get_rank_list({?ETS_OPERATE_TYPE_4, Id, ?OPERATE_ACTIVE_LIMIT_TYPE_18}),
	Proto = rank_lib:get_rank_list_data({?ETS_OPERATE_TYPE_4, Id, ?OPERATE_ACTIVE_LIMIT_TYPE_18}, RankList),
	NewProto = [P || P <- Proto, P#proto_active_rank_info.rank =< 3],

	PlayerId = PlayerState#player_state.player_id,
	PlayerRank =
		case lists:keyfind(PlayerId, #ets_rank_kill_active.player_id, RankList) of
			false ->
				0;
			Info ->
				Info#ets_rank_kill_active.rank
		end,

	Score = case operate_active_lib:get_operate_active_conf(Id) of
				[] -> 0;
				Conf ->
					FinishType = Conf#ets_operate_active_conf.finish_type,
					Info1 = player_operate_record_cache:get_info(PlayerId, Id, ?OPERATE_ACTIVE_LIMIT_TYPE_18, FinishType),
					Info1#db_player_operate_record.finish_limit_value
			end,
	net_send:send_to_client(PlayerState#player_state.socket, 32035, #rep_active_rank{score = Score, rank = PlayerRank, rank_list = NewProto});

%% 获取节日活动信息列表
handle(32036, PlayerState, _Data) ->
	Proto = operate_active_lib:get_player_holiday_active_info(PlayerState),
	net_send:send_to_client(PlayerState#player_state.socket, 32036, #rep_get_operate_holiday_active_info{list = Proto});

%%功能预告礼包状态
handle(32037, PlayerState, _) ->
	Key = gift_lib:function_notice_first_key(PlayerState),
	net_send:send_to_client(PlayerState#player_state.socket, 32037, #rep_function_notice_state{key = Key});

%%功能预告礼包领取
handle(32038, PlayerState, #req_function_notice_get{key = Key}) ->
	#function_notice_conf{lv = ConfigLv, reward = Reward, counter_id = CounterId} = function_notice_config:get(Key),
	#player_state{db_player_base = #db_player_base{lv = Lv}} = PlayerState,
	case Lv >= ConfigLv andalso counter_lib:check(PlayerState#player_state.player_id, CounterId) of
		true ->
			case goods_lib_log:add_goods_list(PlayerState, Reward, ?LOG_TYPE_FUNCTION_NOTICE) of
				{ok, PlayerState1} ->
					counter_lib:update(PlayerState#player_state.player_id, CounterId),
					net_send:send_to_client(PlayerState#player_state.socket, 32038, #rep_function_notice_get{result = 0}),
					{ok, PlayerState1};
				{fail, Reply} ->
					net_send:send_to_client(PlayerState#player_state.socket, 32038, #rep_function_notice_get{result = Reply})
			end;
		false ->
			net_send:send_to_client(PlayerState#player_state.socket, 32038, #rep_function_notice_get{result = ?ERR_PLAYER_LV_NOT_ENOUGH}),
			{ok, PlayerState}
	end;

%% 购买活动商店物品
handle(32042, PlayerState, Data) ->
	#req_buy_active_shop{id = ActiveShopKey, num = BuyNum} = Data,
	case active_shop_lib:buy_mystery_shop(PlayerState, ActiveShopKey, BuyNum) of
		{ok, PlayerState1} ->
			ActiveShopProto = active_shop_lib:get_active_shop_proto(PlayerState1#player_state.player_id, ActiveShopKey),
			Data1 = #rep_buy_active_shop{
				result = ?ERR_COMMON_SUCCESS,
				active_shop_info = ActiveShopProto
			},
			net_send:send_to_client(PlayerState1#player_state.socket, 32042, Data1),
			{ok, PlayerState1};
		{fail, Err} ->
			net_send:send_to_client(PlayerState#player_state.socket, 32042, #rep_buy_active_shop{result = Err});
		Err ->
			?ERR("~p", [Err])
	end;

%% 购买活动商店物品
handle(32043, PlayerState, Data) ->
	#req_active_service_red{list_id = ListUid} = Data,
	case ListUid of
		?ACTIVE_SERVICE_UI_RANK ->
			button_tips_lib:ref_button_tips(PlayerState, ?BTN_ACTIVE_SERVICE_RANK);
		_ ->
			skip
	end;

%% 获取节日活动兑换信息
handle(32044, PlayerState, #req_get_operate_holiday_change_info{active_id = Id}) ->
	Proto =
		case operate_active_lib:get_operate_active_conf(Id) of
			[] ->
				[];
			Conf ->
				Type = Conf#ets_operate_active_conf.type,
				case holidays_active_config:get(Type) of
					#holidays_active_conf{} = Aconf ->
						PlayerId = PlayerState#player_state.player_id,
						FinishType = Conf#ets_operate_active_conf.finish_type,
						Fun = fun(X, Acc) ->
							case X of
								{FusionId, _Count} when is_integer(FusionId) ->
									Info = player_operate_record_cache:get_info(PlayerId, Id, FusionId, FinishType),
									[#proto_operate_holiday_change_info{
										active_id = Id,  %%  活动编号
										fusion_id = FusionId,  %%  兑换配方id
										count = Info#db_player_operate_record.finish_limit_value  %%  已兑换次数
									}] ++ Acc;
								_ ->
									Acc
							end
						end,
						lists:foldl(Fun, [], Aconf#holidays_active_conf.reward);
					[] ->
						[]
				end
		end,
	net_send:send_to_client(PlayerState#player_state.socket, 32044, #rep_get_operate_holiday_change_info{list = Proto});

handle(Cmd, PlayerState, Data) ->
	?ERR("not define active_pp ~p cmd:~nstate: ~p~ndata: ~p", [Cmd, PlayerState, Data]),
	{ok, PlayerState}.
%% ====================================================================
%% Internal functions
%% ====================================================================
