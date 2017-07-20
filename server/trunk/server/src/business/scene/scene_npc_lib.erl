%%%-------------------------------------------------------------------
%%% @author tuhujia
%%% @copyright (C) 2016, <COMPANY>
%%% @doc 场景npc
%%%
%%% @end
%%% Created : 05. 一月 2016 10:01
%%%-------------------------------------------------------------------
-module(scene_npc_lib).

-include("common.hrl").
-include("record.hrl").
-include("proto.hrl").
-include("cache.hrl").
-include("db_record.hrl").
-include("uid.hrl").
-include("config.hrl").
-include("language_config.hrl").
-include("gameconfig_config.hrl").

%% API
-export([
    get_scene_npc_state/2
%% 	transport/2
]).

%% callbacks
-export([
    do_get_scene_npc_state/5
]).

%% ====================================================================
%% API functions
%% ====================================================================

%% 获取npc功能状态
get_scene_npc_state(PlayerState, NpcId) ->
    PlayerId = PlayerState#player_state.player_id,
    ScenePid = PlayerState#player_state.scene_pid,
    PlayerPid = PlayerState#player_state.pid,
    {PlayerStateNew, Result} = main_task_lib:npc_task_id(PlayerState, NpcId),
    ?INFO("get_scene_npc_state ~p ", [Result]),
    gen_server2:apply_async(ScenePid, {?MODULE, do_get_scene_npc_state, [PlayerId, NpcId, Result, PlayerPid]}),
    PlayerStateNew.

do_get_scene_npc_state(SceneState, PlayerId, NpcId, Result, PlayerPid) ->
    try
        case scene_base_lib:get_scene_obj_state(SceneState, ?OBJ_TYPE_PLAYER, PlayerId) of
            #scene_obj_state{} = _Obj ->
                NpcConf = npc_config:get(NpcId),
%% 				X = Obj#scene_obj_state.x,
%% 				Y = Obj#scene_obj_state.y,
%% 				#npc_conf{
%% 					sceneId = SceneId,
%% 					x = FX,
%% 					y = FY
%% 				} = NpcConf,
%% 				_D1 = util_math:get_distance({X, Y}, {FX, FY}),
                D = 1,
                %% 允许有两格距离的误差
                case D =< 2 andalso NpcConf#npc_conf.sceneId == SceneState#scene_state.scene_id of
                    true ->
                        net_send:send_to_client(PlayerPid, 11025, #rep_get_npc_state{type = Result});
                    _ ->
                        skip
                end;
            _ ->
                skip
        end
    catch
        ErrType:ErrInfo ->
            ?ERR("~p:~p~n,stacktrace:~p", [ErrType, ErrInfo, erlang:get_stacktrace()]),
            error
    end.

%% %% 传送点传送
%% transport(PlayerState, TransportId) ->
%% 	case scene_transport_config:get(TransportId) of
%% 		#scene_transport_conf{} = TransportConf ->
%% 			#player_state{
%% 				db_player_base = DbPlayerBase
%% 			} = PlayerState,
%% 			Lv = DbPlayerBase#db_player_base.lv,
%%
%% 			#scene_transport_conf{
%% 				scene_id = SceneId,
%% 				x = X,
%% 				y = Y,
%% 				lv_limit = LvLimit,
%% 				spend_limit = SpendLimit
%% 			} = TransportConf,
%% 			case Lv >= LvLimit of
%% 				true ->
%% 					case goods_util:check_special_list(PlayerState, SpendLimit) of
%% 						true ->
%% 							gen_server2:cast(self(), {change_scene, SceneId, ?CHANGE_SCENE_TYPE_CHANGE, {X, Y}}),
%% 							goods_util:delete_special_list(PlayerState, SpendLimit);
%% 						{fail, Reply} ->
%% 							{fail, Reply}
%% 					end;
%% 				_ ->
%% 					%% 传送条件不符
%% 					{fail, 1}
%% 			end;
%% 		_ ->
%% 			%% 无效的操作
%% 			{fail, ?ERR_COMMON_FAIL}
%% 	end.