%%%-------------------------------------------------------------------
%%% @author yubing
%%% @copyright (C) 2016, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 01. 八月 2016 09:44
%%%-------------------------------------------------------------------
-module(scene_tool).

-include("record.hrl").
-include("common.hrl").

%% API
-export([]).
-compile(export_all).


stop_scene(ScenePid) ->
    gen_server2:apply_async(ScenePid, {scene_mod, stop, []}).

stop_scene_all(SceneId) ->
    case ets:lookup(?ETS_SCENE_MAPS, SceneId) of
        [EtsMaps] ->
            [stop_scene(X#pid_line.pid) || X <- EtsMaps#ets_scene_maps.pid_list],
            PidLineList = [],
            ets:insert(?ETS_SCENE_MAPS, EtsMaps#ets_scene_maps{pid_list = PidLineList});
        _ ->
            {0, []}
    end.

create_scene_pid(SceneId) ->
    case ets:lookup(?ETS_SCENE_MAPS, SceneId) of
        [EtsMaps] ->
            F = fun(X, ACC) ->
                case is_process_alive(X#pid_line.pid) of
                    true ->
                        ACC ++ [X];
                    _ ->
                        ACC
                end
            end,
            PidLineList1 = lists:foldl(F, [], EtsMaps#ets_scene_maps.pid_list),
            ets:insert(?ETS_SCENE_MAPS, EtsMaps#ets_scene_maps{pid_list = PidLineList1});
        _ ->
            {0, []}
    end.

time_init() ->
    List = [20015, 20016],
    F1 = fun(SceneId) ->
        case ets:lookup(?ETS_SCENE_MAPS, SceneId) of
            [EtsMaps] ->
                #ets_scene_maps{pid_list = PidLineList} = EtsMaps,
                F = fun(X) ->
                    gen_server2:apply_async(X#pid_line.pid, {scene_activity_base_lib, init_time, []})
                end,
                [F(X) || X <- PidLineList];
            _ ->
                skip
        end
    end,
    [F1(X) || X <- List].
