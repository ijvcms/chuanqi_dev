%%%-------------------------------------------------------------------
%%% @author yubing
%%% @copyright (C) 2016, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 30. 五月 2016 16:57
%%%-------------------------------------------------------------------
-module(cross_boss_lib).

-include("record.hrl").
-include("cache.hrl").
-include("common.hrl").
-include("proto.hrl").
-include("language_config.hrl").
-include("config.hrl").
-include("log_type_config.hrl").

%% API
-export([
    handle/5,
    check_scene/4,
    handle/4
]).

%% 跨服boss传送
handle(Mod, 11031, Data, PlayerState, IsNotItem) ->
%%     io:format("11031 ================>>>>>>>>>>>>>>>>>> ：~p~n", [Data]),
    #req_quick_change_scene{scene_id = SceneId} = Data,
    case check_scene(PlayerState, SceneId, IsNotItem, null) of
        {ok, PlayerState1} ->
            case scene_cross:send_cross(PlayerState1) of
                {ok, PlayerState2} ->
                    ?INFO("~p ", [SceneId]),
                    rpc:call(PlayerState2#player_state.server_pass, scene_cross, proto_mod, [PlayerState2, Mod, 11031, Data]);
                Err ->
                    ?INFO("11031 ~p", [4444]),
                    Err
            end;
        {fail, Err} ->
            net_send:send_to_client(PlayerState#player_state.socket, 11001, #rep_change_scene{result = Err}),
            {ok, PlayerState}
    end;

handle(Mod, Cmd, Data, PlayerState, _) ->
    rpc:call(PlayerState#player_state.server_pass, scene_cross, proto_mod, [PlayerState, Mod, Cmd, Data]).

%% 直接请求跨服数据
handle(PlayerState, Mod, Cmd, Data) ->
    rpc:call(config:get_cross_path(), scene_cross, proto_mod, [PlayerState, Mod, Cmd, Data]).

%% 检测是否可以传送进入跨服场景
check_scene(PlayerState, SceneId, IsNotItem, ItemLoss) ->
    case scene_mgr_lib:check_condition(PlayerState, SceneId, 0, ItemLoss, IsNotItem) of
        {true, TimeSpan} ->
            SceneConf = scene_config:get(SceneId),
            Cost = SceneConf#scene_conf.cost,
            ?INFO("~p ~p", [Cost, IsNotItem]),
            {ok, PlayerState1} = case Cost =:= [] orelse IsNotItem of
                                     true ->
                                         {ok, PlayerState};
                                     _ -> goods_util:delete_special_list(PlayerState, Cost, ?LOG_TYPE_TRANSFER)
                                 end,

            {ok, PlayerState3} = case ItemLoss of
                                     null -> {ok, PlayerState1};
                                     {ItemId, ItemNum, Type} ->
                                         case goods_lib_log:delete_goods_by_num(PlayerState1, ItemId, ItemNum, Type) of
                                             {ok, PlayerState2} ->
                                                 {ok, PlayerState2};
                                             _ ->
                                                 {ok, PlayerState1}
                                         end
                                 end,
            {ok, PlayerState3#player_state{scene_parameters = TimeSpan}};
        Fail ->
            Fail
    end.


