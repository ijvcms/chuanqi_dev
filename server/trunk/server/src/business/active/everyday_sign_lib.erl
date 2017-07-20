%%%-------------------------------------------------------------------
%%% @author tuhujia
%%% @copyright (C) 2016, <COMPANY>
%%% @doc 每日签到活动
%%%
%%% @end
%%% Created : 23. 二月 2016 18:06
%%%-------------------------------------------------------------------
-module(everyday_sign_lib).

-include("common.hrl").
-include("record.hrl").
-include("config.hrl").
-include("cache.hrl").
-include("db_record.hrl").
-include("proto.hrl").
-include("language_config.hrl").
-include("log_type_config.hrl").

-export([
	send_player_sign_info/1,
	sign_reward/1
]).

%%% ----------------------------------------------------------------------------
%%% 对外接口
%%% ----------------------------------------------------------------------------

%% 发送玩家签到信息
send_player_sign_info(PlayerState) ->
	PlayerId = PlayerState#player_state.player_id,
	Proto =
	#rep_everyday_sign_info
	{
		is_sign = counter_lib:get_value(PlayerId, ?COUNTER_EVERYDAY_SIGN_STATE),  %%  今日是否签到0未签到 1已签到
		sign_count = counter_lib:get_value(PlayerId, ?COUNTER_EVERYDAY_SIGN_COUNT)   %%  本月已签到次数
	},
	net_send:send_to_client(PlayerState#player_state.socket, 32006, Proto).

%% 每日签到
sign_reward(PlayerState) ->
	PlayerId = PlayerState#player_state.player_id,
	case counter_lib:check(PlayerId, ?COUNTER_EVERYDAY_SIGN_STATE) of
		true ->
			GoodsList = get_reward(PlayerState),
			case goods_lib_log:add_goods_list(PlayerState, GoodsList,?LOG_TYPE_SIGN) of
				{ok, PlayerState1} ->
					counter_lib:update(PlayerId, ?COUNTER_EVERYDAY_SIGN_COUNT),
					counter_lib:update(PlayerId, ?COUNTER_EVERYDAY_SIGN_STATE),
					{ok, PlayerState1};
				{fail, Reply} ->
					{fail, Reply}
			end;
		false ->
			{fail, ?ERR_COMMON_FAIL}
	end.

%% 检测奖励是否翻倍
get_reward(PlayerState) ->
	PlayerId = PlayerState#player_state.player_id,
	{{Year, Month, _},_} = calendar:local_time(),
	Count = counter_lib:get_value(PlayerId, ?COUNTER_EVERYDAY_SIGN_COUNT) + 1,
	SignConf = everyday_sign_config:get({Year, Month, Count}),
	case SignConf#everyday_sign_conf.is_double == 0 of
		true ->
			SignConf#everyday_sign_conf.reward;
		false ->
			DbPlayerBase = PlayerState#player_state.db_player_base,
			Vip = DbPlayerBase#db_player_base.vip,

			case Vip >= SignConf#everyday_sign_conf.vip_double of
				true ->
					[{GoodsId, IsBind, Num}] = SignConf#everyday_sign_conf.reward,
					[{GoodsId, IsBind, 2 * Num}];
				false ->
					SignConf#everyday_sign_conf.reward
			end
	end.

