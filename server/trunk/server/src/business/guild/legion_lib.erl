%%%-------------------------------------------------------------------
%%% @author tuhujia
%%% @copyright (C) 2015, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 13. 八月 2015 10:46
%%%-------------------------------------------------------------------
-module(legion_lib).

-include("common.hrl").
-include("record.hrl").
-include("proto.hrl").
-include("cache.hrl").

%% API
-export([
    get_apply_list_button_tips/1,
    on_player_login/1
]).

%% 玩家登陆 检测军团登录相关信息
on_player_login(State) ->
    case cross_lib:send_cross_mfc(legion_lib, on_player_login, [State]) of
        PlayerState when is_record(PlayerState, player_state) ->
            PlayerState;
        _Err ->
            ?ERR("_Err~p", [_Err]),
            State
    end.

%% 行会申请列表红点提示
get_apply_list_button_tips(PlayerState) ->
    case cross_lib:send_cross_mfc(?MODULE, get_apply_list_button_tips, [PlayerState]) of
        {PlayerState1, Num} when is_record(PlayerState1, player_state) ->
            {PlayerState1, Num};
        _ ->
            {PlayerState, 0}
    end.


