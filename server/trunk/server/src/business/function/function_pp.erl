%%%-------------------------------------------------------------------
%%%-------------------------------------------------------------------
%%%-------------------------------------------------------------------
%%% @author yubing
%%% @copyright (C) 2016, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 05. 一月 2016 14:16
%%%-------------------------------------------------------------------
-module(function_pp).

-include("proto.hrl").
-include("record.hrl").
-include("common.hrl").
-include("cache.hrl").
-include("config.hrl").
%% API
-export([handle/3]).

%% 获取vip信息
handle(28001, PlayerState, _Data) ->
	?INFO("28001 ~p", [111]),
	ActivityList = function_lib:get_activity_list(PlayerState),
	net_send:send_to_client(PlayerState#player_state.socket, 28001, #rep_get_activity_list{activity_list = ActivityList});

%% 获取新手卡开启状态
handle(28003, PlayerState, Data) ->
	?INFO("28003 ~p", [Data]),
	Channel = Data#req_noob_card_state.channel,%% 渠道
	_Cps = Data#req_noob_card_state.cps, %% 子渠道
	State = case util_data:is_int(Channel) of
				false ->
					1;
				ChannelNum ->
					case PlayerState#player_state.is_robot of
						1 ->
							1;
						_ ->
							case ChannelNum =:= 1888 orelse ChannelNum > 3000 of
								true ->
									0;
								_ ->
									1
							end
					end
			end,
	net_send:send_to_client(PlayerState#player_state.socket, 28003, #rep_noob_card_state{state = State});

handle(Cmd, PlayerState, Data) ->
	?ERR("not define ~p cmd:~nstate: ~p~ndata: ~p", [Cmd, PlayerState, Data]),
	{ok, PlayerState}.

