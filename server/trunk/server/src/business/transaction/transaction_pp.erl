%%%-------------------------------------------------------------------
%%% @author tuhujia
%%% @copyright (C) 2015, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 03. 十二月 2015 11:04
%%%-------------------------------------------------------------------
-module(transaction_pp).

-include("common.hrl").
-include("record.hrl").
-include("proto.hrl").
-include("cache.hrl").
-include("config.hrl").
-include("language_config.hrl").

%% API
-export([
    handle/3
]).

%% ====================================================================
%% API functions
%% ====================================================================

%% 发起交易邀请A->B
handle(20001, PlayerState, #req_apply_trade{player_id = PlayerIdB}) ->
    case transaction_lib:apply_trade(PlayerState, PlayerIdB) of
        {fail, Reply} ->
            net_send:send_to_client(PlayerState#player_state.socket, 20001, #rep_apply_trade{result = Reply});
        {ok, PlayerState1} ->
            {ok, PlayerState1};
        _ ->
            skip
    end;

%% 玩家B反馈交易请求
handle(20003, PlayerState, #req_trade_feedback{player_id = PlayerIdA, player_name = NameA, player_lv = LvA, type = Type}) ->
    transaction_lib:trade_feedback(PlayerState, PlayerIdA, NameA, LvA, Type);

%% 取消交易
handle(20004, PlayerState, _Data) ->
    {_, Reply} = transaction_lib:clearn_player_trade(PlayerState#player_state.player_id),
    net_send:send_to_client(PlayerState#player_state.socket, 20004, #rep_clean_trade{result = Reply});

%% 变更交易数据
handle(20005, PlayerState, #req_trade_info{jade = Jade, trade_list = TradeList}) ->
    {_, Reply} = transaction_lib:change_trade_info(PlayerState, Jade, TradeList),
    net_send:send_to_client(PlayerState#player_state.socket, 20005, #rep_trade_info{result = Reply});

%% 确认交易
handle(20007, PlayerState, _Data) ->
    case transaction_lib:confirm_trade(PlayerState) of
        {ok, ?ERR_COMMON_SUCCESS} ->
            net_send:send_to_client(PlayerState#player_state.socket, 20007, #rep_confirm_trade{result = ?ERR_COMMON_SUCCESS});
        {ok, PlayerState1} ->
            {ok, PlayerState1};
        {fail, Reply} ->
            net_send:send_to_client(PlayerState#player_state.socket, 20007, #rep_confirm_trade{result = Reply})
    end;

handle(Cmd, PlayerState, Data) ->
    ?ERR("not define ~p cmd:~nstate: ~p~ndata: ~p", [Cmd, PlayerState, Data]),
    {ok, PlayerState}.