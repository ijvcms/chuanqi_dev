%%%-------------------------------------------------------------------
%%% @author zhengsiying
%%% @copyright (C) 2016, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 29. 二月 2016 下午12:09
%%%-------------------------------------------------------------------
-module(misc_pp).

-include("common.hrl").
-include("record.hrl").
-include("proto.hrl").
-include("cache.hrl").
-include("button_tips_config.hrl").

%% API
-export([
    handle/3
]).

%% ====================================================================
%% API functions
%% ====================================================================
handle(9000, PlayerState, _Data) ->
    button_tips_lib:get_all_button_tips_data(PlayerState);
    %% 回收道具
    %%game_tool:retrieve_goods(PlayerState, 110304);

handle(9001, PlayerState, Data) ->
    #req_update_button_tips{
        id = Id,
        num = Num
    } = Data,
    case button_tips_config:get(Id) of
        #button_tips_conf{trigger = ?BTN_TIPS_TRIGGER_CLIENT} = _ ->
            button_tips_lib:ref_button_tips(PlayerState, Id, Num);
        _ ->
            skip
    end;
%% 获取军团的红点信息
handle(9002, PlayerState, _Data) ->
    button_tips_lib:ref_button_tips(PlayerState, ?BTN_LEGION_APPLY_LIST);

handle(Cmd, State, Data) ->
    ?ERR("not define ~p cmd:~nstate: ~p~ndata: ~p", [Cmd, State, Data]),
    {ok, State}.
%% ====================================================================
%% Internal functions
%% ====================================================================
