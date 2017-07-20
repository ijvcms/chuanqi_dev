%%%-------------------------------------------------------------------
%%% @author tuhujia
%%% @copyright (C) 2015, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 09. 十月 2015 15:58
%%%-------------------------------------------------------------------
-module(mail_pp).

-include("common.hrl").
-include("record.hrl").
-include("proto.hrl").
-include("cache.hrl").
-include("config.hrl").
-include("language_config.hrl").
-include("button_tips_config.hrl").

%% API
-export([
	handle/3
]).

%% ====================================================================
%% API functions
%% ====================================================================

%% 获取玩家邮件列表
handle(15001, PlayerState, _Data) ->
	PlayerId = PlayerState#player_state.player_id,
	ProtoMailList = mail_lib:get_proto_mail_list(PlayerId),
	net_send:send_to_client(PlayerState#player_state.socket, 15001, #rep_mail_list{mail_list = ProtoMailList});

%% 领取邮件奖励
handle(15003, PlayerState, #req_open_mail{id = Id}) ->
	case mail_lib:get_mail_award(PlayerState, Id) of
		{ok, PlayerState1} ->
			%% 红点
			button_tips_lib:ref_button_tips(PlayerState1, ?BTN_MAIL),
			net_send:send_to_client(PlayerState#player_state.socket, 15003, #rep_open_mail{result = ?ERR_COMMON_SUCCESS, id = Id}),
			{ok, PlayerState1};
		{fail, Reply} ->
			net_send:send_to_client(PlayerState#player_state.socket, 15003, #rep_open_mail{result = Reply})
	end;

%% 删除指定邮件
handle(15004, PlayerState, #req_remove_mail{id = Id}) ->
	case mail_lib:remove_mail(PlayerState, Id) of
		{ok, PlayerState1} ->
			net_send:send_to_client(PlayerState#player_state.socket, 15004, #rep_remove_mail{id = Id, result = ?ERR_COMMON_SUCCESS}),
			{ok, PlayerState1};
		{fail, Reply} ->
			net_send:send_to_client(PlayerState#player_state.socket, 15004, #rep_remove_mail{id = Id, result = Reply})
	end;

handle(Cmd, PlayerState, Data) ->
	?ERR("not define ~p cmd:~nstate: ~p~ndata: ~p", [Cmd, PlayerState, Data]),
	{ok, PlayerState}.
%% ====================================================================
%% Internal functions
%% ====================================================================
