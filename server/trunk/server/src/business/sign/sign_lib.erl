%%%-------------------------------------------------------------------
%%% @author tuhujia
%%% @copyright (C) 2016, <COMPANY>
%%% @doc 每日签到
%%%
%%% @end
%%% Created : 05. 四月 2016 11:39
%%%-------------------------------------------------------------------
-module(sign_lib).

-include("common.hrl").
-include("record.hrl").
-include("cache.hrl").
-include("config.hrl").
-include("proto.hrl").
-include("language_config.hrl").
-include("log_type_config.hrl").
-include("button_tips_config.hrl").

%% API
-export([
	proto_get_player_sign_info/1,
	player_sign/1,
	repair_sign/1,
	get_sign_reward/2,
	get_sign_button/1,
	get_sign_reward_button/1,
	check_refuse_sign_list/1
]).

%% ====================================================================
%% API functions
%% ====================================================================

%% 获取玩家签到信息
proto_get_player_sign_info(PlayerState) ->
	PlayerId = PlayerState#player_state.player_id,
	%% 获取玩家签到信息
	SignInfo = sign_cache:get_player_sign_info(PlayerId),
	SignList = SignInfo#db_player_sign.sign_list,
	SignReward = SignInfo#db_player_sign.reward_list,

	DPB = PlayerState#player_state.db_player_base,
	VipLv = DPB#db_player_base.vip,
	Career = DPB#db_player_base.career,
	VipConf = vip_config:get(VipLv, Career),
	Count = VipConf#vip_conf.sign_num - SignInfo#db_player_sign.count,

	%% 签到日期容错检测

	Proto = #rep_sign_list
	{
		sign_list = [X || {X} <- SignList],  %%  签到日期列表
		reward_list = SignReward,  %%  已领取奖励日期列表
		count = Count   %%  剩余补签次数
	},

	net_send:send_to_client(PlayerState#player_state.socket, 32014, Proto).

%% 玩家签到
player_sign(PlayerState) ->
	PlayerId = PlayerState#player_state.player_id,
	{{_, _, Day}, _} = calendar:local_time(),
	SignInfo = sign_cache:get_player_sign_info(PlayerId),
	case lists:member({Day}, SignInfo#db_player_sign.sign_list) of
		false ->
			NewInfo = SignInfo#db_player_sign
			{
				sign_list = [{Day}] ++ SignInfo#db_player_sign.sign_list, %% 签到日期列表
				update_time = util_date:unixtime() %% 更新时间
			},
			sign_cache:update(NewInfo),
			%% 红点刷新
			button_tips_lib:ref_button_tips(PlayerState, ?BIN_SIGN_BTN),
			button_tips_lib:ref_button_tips(PlayerState, ?BIN_SIGN_REWARD),

			{ok, ?ERR_COMMON_SUCCESS};
		true ->
			{fail, ?ERR_COMMON_FAIL}
	end.

%% 玩家补签
repair_sign(State) ->
	DPM = State#player_state.db_player_money,
	case DPM#db_player_money.jade >= 10 of
		true ->
			repair_sign_1(State);
		false ->
			{fail, ?ERR_PLAYER_JADE_NOT_ENOUGH}
	end.

repair_sign_1(State) ->
	PlayerId = State#player_state.player_id,
	SignInfo = sign_cache:get_player_sign_info(PlayerId),
	DPB = State#player_state.db_player_base,
	VipLv = DPB#db_player_base.vip,
	Career = DPB#db_player_base.career,
	VipConf = vip_config:get(VipLv, Career),
	case SignInfo#db_player_sign.count < VipConf#vip_conf.sign_num of
		true ->
			repair_sign_2(State, SignInfo);
		false ->
			{fail, ?ERR_RAPAIR_COUNT_NOT_ENOUGH}
	end.

repair_sign_2(State, SignInfo) ->
	case get_repair_day(SignInfo) of
		[Day|_] ->
			NewInfo = SignInfo#db_player_sign
			{
				sign_list = [{Day}] ++ SignInfo#db_player_sign.sign_list, %% 签到日期列表
				count = 1 + SignInfo#db_player_sign.count,
				update_time = util_date:unixtime() %% 更新时间
			},
			sign_cache:update(NewInfo),
			%% 红点刷新
			button_tips_lib:ref_button_tips(State, ?BIN_SIGN_REWARD),
			player_lib:incval_on_player_money_log(State, #db_player_money.jade, -10, ?LOG_TYPE_SIGN);
		_ ->
			{fail, ?ERR_NO_REPAIR_DAYS}
	end.

%% 玩家领取奖励
get_sign_reward(State, Days) ->
	{{Years, Months, _}, _} = calendar:local_time(),
	case everyday_sign_config:get({Years, Months, Days}) of
		#everyday_sign_conf{} = SignConf ->
			case SignConf#everyday_sign_conf.reward =/= [] of
				true ->
					get_sign_reward_1(State, Days, SignConf);
				false ->
					{fail, ?ERR_COMMON_FAIL}
			end;
		_ ->
			{fail, ?ERR_COMMON_FAIL}
	end.

get_sign_reward_1(State, Days, SignConf) ->
	PlayerId = State#player_state.player_id,
	SignInfo = sign_cache:get_player_sign_info(PlayerId),
	case length(SignInfo#db_player_sign.sign_list) >= Days of
		true ->
			case lists:member(Days, SignInfo#db_player_sign.reward_list) of
				true ->
					{fail, ?ERR_COMMON_FAIL};
				false ->
					get_sign_reward_2(State, SignInfo, Days, SignConf)
			end;
		false ->
			{fail, ?ERR_COMMON_FAIL}
	end.

get_sign_reward_2(State, SignInfo, Days, SignConf) ->
	GoodsList = SignConf#everyday_sign_conf.reward,
	case goods_lib_log:add_goods_list(State, GoodsList, ?LOG_TYPE_SIGN) of
		{ok, State1} ->
			NewInfo = SignInfo#db_player_sign
			{
				reward_list = [Days] ++ SignInfo#db_player_sign.reward_list, %% 签到日期列表
				update_time = util_date:unixtime() %% 更新时间
			},
			sign_cache:update(NewInfo),
			%% 红点刷新
			case get_sign_reward_button(State, NewInfo, []) of
				{_, 0} ->
					button_tips_lib:send_button_tips(State1, ?BIN_SIGN_REWARD, 0);
				{_, 1} ->
					button_tips_lib:send_button_tips(State1, ?BIN_SIGN_REWARD, 1)
			end,
			{ok, State1};
		{fail, Reply} ->
			{fail, Reply}
	end.


%% 获取补签的日期
get_repair_day(SignInfo) ->
	{{_, _, Day}, _} = calendar:local_time(),
	SignList = SignInfo#db_player_sign.sign_list,
	AllList = lists:seq(1, Day - 1),
	AllList -- [X || {X} <- SignList].

%% 获取签到红点
get_sign_button(PlayerState) ->
	PlayerId = PlayerState#player_state.player_id,
	{{_, _, Day}, _} = calendar:local_time(),
	SignInfo = sign_cache:get_player_sign_info(PlayerId),
	case lists:member({Day}, SignInfo#db_player_sign.sign_list) of
		false ->
			{PlayerState, 1};
		true ->
			{PlayerState, 0}
	end.

%% 获取签到奖励红点
get_sign_reward_button(PlayerState) ->
	PlayerId = PlayerState#player_state.player_id,
	SignInfo = sign_cache:get_player_sign_info(PlayerId),
	get_sign_reward_button(PlayerState, SignInfo, [2,5,10,17,26]).

get_sign_reward_button(PlayerState, _SignInfo, []) ->
	{PlayerState, 0};
get_sign_reward_button(PlayerState, SignInfo, [Days|T]) ->
	case length(SignInfo#db_player_sign.sign_list) >= Days of
		true ->
			case lists:member(Days, SignInfo#db_player_sign.reward_list) of
				true ->
					get_sign_reward_button(PlayerState, SignInfo, T);
				false ->
					{PlayerState, 1}
			end;
		false ->
			get_sign_reward_button(PlayerState, SignInfo, T)
	end.

%% 获取重置后的签到列表
check_refuse_sign_list(SignInfo) ->
	OldSignList = SignInfo#db_player_sign.sign_list,
	Fun = fun(Day, Acc) ->
		case Day of
			{D} ->
				[{D}] ++ Acc;
			D1 ->
				case D1 > 31 of
					true ->
						Acc;
					false ->
						[{D1}] ++ Acc
				end
		end
	end,
	NewOldSignList = lists:foldl(Fun, [], OldSignList),

	case OldSignList == NewOldSignList of
		true ->
			SignInfo;
		false ->
			NewSignInfo = SignInfo#db_player_sign{sign_list = NewOldSignList},
			sign_cache:update(NewSignInfo),
			NewSignInfo
	end.