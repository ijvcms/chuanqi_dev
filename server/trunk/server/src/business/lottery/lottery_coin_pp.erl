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
-module(lottery_coin_pp).


-include("proto.hrl").
-include("record.hrl").
-include("common.hrl").
-include("cache.hrl").
%% API
-export([handle/3]).

%% 获取抽奖日志
handle(36000, PlayerState, Data) ->
    LastId = Data#req_get_lottery_coin_log_list.last_id,
    LogList = lottery_coin_lib:get_lottery_log_lists(LastId),
    net_send:send_to_client(PlayerState#player_state.socket, 36000, #rep_get_lottery_coin_log_list{log_lists = LogList}),
    {ok, PlayerState#player_state{is_coin_lottery = true}};

%% 开始抽奖
handle(36001, PlayerState, Data) ->
    Num = Data#req_lottery_coin_begin.num,
    case lottery_coin_lib:lottery_begin(PlayerState, Num) of
        {fail, Err} ->
            net_send:send_to_client(PlayerState#player_state.socket, 36001, #rep_lottery_coin_begin{result = Err});
        {ok, List, GoodsList, EquipList, PlayerState1} ->
            NewData = #rep_lottery_coin_begin{
                result = 0,
                lottery_id_list = List,
                goods_list = GoodsList,
                equip_list = EquipList
            },
            net_send:send_to_client(PlayerState#player_state.socket, 36001, NewData),
            {ok, PlayerState1}
    end;


%% 离开抽奖ui
handle(36003, PlayerState, _Data) ->
    {ok, PlayerState#player_state{is_coin_lottery = false}};

handle(Cmd, PlayerState, Data) ->
    ?ERR("not define ~p cmd:~nstate: ~p~ndata: ~p", [Cmd, PlayerState, Data]),
    {ok, PlayerState}.

