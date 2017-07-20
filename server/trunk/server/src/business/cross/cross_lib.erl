%%%-------------------------------------------------------------------
%%% @author yubing
%%% @copyright (C) 2016, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 13. 六月 2016 14:13
%%%-------------------------------------------------------------------
-module(cross_lib).

-include("record.hrl").
-include("common.hrl").
-include("cache.hrl").
-include("config.hrl").
-include("log_type_config.hrl").
-include("language_config.hrl").
-include("proto.hrl").
%% API
-export([
	succeed_change_scene/3,
	is_goods_enough/3,
	transport/2,
	transfer/2,
	delete_player_team_from_ets/1,
	change_scene_11031/4,
	change_scene_equip/4,
	change_scene_11031/6,
	send_cross_mfc/4,
	send_cross_mfc/3,
	hjzc_send_change_11105/2
]).

%% 调用跨服场景相关方法
send_cross_mfc(Scene_Cross, M, F, C) ->
	rpc:call(Scene_Cross, M, F, C).
%% 调用跨服场景相关方法
send_cross_mfc(M, F, C) ->
	send_cross_mfc(config:get_cross_path(), M, F, C).

%% 保存玩家的id 进入场景的进程中 (玩家进程调用)
succeed_change_scene(PlayerState, SceneId, ScenePid) ->
	case not util_data:is_null(PlayerState#player_state.server_pass) of
		true ->
			send_cross_mfc(PlayerState#player_state.server_pass, scene_mgr_lib, succeed_change_scene, [PlayerState#player_state.player_id, SceneId, ScenePid]);
		_ ->
			scene_mgr_lib:succeed_change_scene(PlayerState#player_state.player_id, SceneId, ScenePid)
	end.

%% 检查物品是否足够
is_goods_enough(_PlayerState, GoodsId, Num) ->
	IsOk = goods_lib:is_goods_enough(GoodsId, Num),
	?INFO(" ISOK ~p", [IsOk]),
	{ok, IsOk}.

%% 删除玩家信息
delete_player_team_from_ets(PlayerState1) ->
	case not util_data:is_null(PlayerState1#player_state.server_pass) of
		true ->
			send_cross_mfc(PlayerState1#player_state.server_pass, team_lib, delete_player_team_from_ets, [PlayerState1#player_state.player_id]);
		_ ->
			team_lib:delete_player_team_from_ets(PlayerState1#player_state.player_id)
	end.


%% 传送幻境之地
hjzc_send_change_11105(PlayerState, RoomNum) ->
	case vip_lib:check_change_scene(PlayerState, 1) of
		{PlayerState1, _} when is_record(PlayerState1, player_state) ->
			case util_data:is_null(PlayerState#player_state.server_pass) of
				true ->
					scene_hjzc_lib:hjzc_change(PlayerState, RoomNum);
				_ ->
					send_cross_mfc(PlayerState1#player_state.server_pass, scene_hjzc_lib, hjzc_change, [PlayerState, RoomNum])
			end;
		{fail, Err} ->
			net_send:send_to_client(PlayerState#player_state.pid, 11105, #rep_hjzc_send_change{result = Err})
	end.
%%***********************************************************************
%%
%%***********************************************************************
%% 传送阵传送
transfer(PlayerState, TransferId) ->
	case transfer_config:get(TransferId) of
		#transfer_conf{} = TransferConf ->
			#player_state{
				player_id = PlayerId,
				scene_id = SceneId,
				scene_pid = ScenePid,
				db_player_base = DbPlayerBase
			} = PlayerState,
			Lv = DbPlayerBase#db_player_base.lv,

			#transfer_conf{
				from_scene = FScene,
				lv_limit = LvLimit,
				guild_lv_limit = GuildLvLimit
			} = TransferConf,

			case FScene == SceneId andalso Lv >= LvLimit of
				true ->
					case guild_lib:get_guild_lv(DbPlayerBase#db_player_base.guild_id) >= GuildLvLimit of
						true ->
							?INFO("transfer ~p", [11111]),
							%% 通知场景进程，玩家要进行传送阵传送
							gen_server2:apply_async(ScenePid, {scene_obj_lib, do_transfer, [PlayerId, TransferId]}),
							{ok, PlayerState};
						false ->
							?INFO("transfer ~p", [44444]),
							{fail, ?ERR_GUILD_LV_NOT_ENOUGH}
					end;
				_ ->
					case FScene /= SceneId of
						true ->
							{fail, ?ERR_MAIN_TASK1};
						_ ->
							%% 传送条件不符
							{fail, ?ERR_PLAYER_LV_NOT_ENOUGH}
					end
			end;
		_ ->
			%% 无效的操作
			{fail, ?ERR_COMMON_FAIL}
	end.

%% 传送点传送
transport(PlayerState, TransportId) ->
	case scene_transport_config:get(TransportId) of
		#scene_transport_conf{} = TransportConf ->
			#player_state{
				db_player_base = DbPlayerBase
			} = PlayerState,
			Lv = DbPlayerBase#db_player_base.lv,

			#scene_transport_conf{
				scene_id = SceneId,
				x = X,
				y = Y,
				lv_limit = LvLimit,
				spend_limit = SpendLimit
			} = TransportConf,
			case Lv >= LvLimit of
				true ->
					case goods_util:check_special_list(PlayerState, SpendLimit) of
						true ->
							gen_server2:cast(self(), {change_scene, SceneId, ?CHANGE_SCENE_TYPE_CHANGE, {X, Y}}),
							goods_util:delete_special_list(PlayerState, SpendLimit, ?LOG_TYPE_TRANSFER);
						{fail, Reply} ->
							?ERR("111 ~p", [4444]),
							{fail, Reply}
					end;
				_ ->
					?ERR("111 ~p", [55555]),
					%% 传送条件不符
					{fail, ?ERR_PLAYER_LV_NOT_ENOUGH}
			end;
		_ ->
			%% 无效的操作
			{fail, ?ERR_COMMON_FAIL}
	end.

%% 快速传送 11031 快速传送
change_scene_equip(PlayerState, SceneId, ItemLoss, Point) ->
	change_scene_11031(PlayerState, SceneId, ItemLoss, Point, false, true).
change_scene_11031(PlayerState, SceneId, ItemLoss, Point) ->
	%% 传送说明
	case change_scene_11031(PlayerState, SceneId, ItemLoss, Point, false, false) of
		{ok, PlayerState1} ->
			{ok, PlayerState1};
		{fail, Err} ->
			net_send:send_to_client(PlayerState#player_state.socket, 11001, #rep_change_scene{result = Err})
	end.
change_scene_11031(PlayerState, SceneId, ItemLoss, Point, IsNoItem, IsEquipe) ->
	case scene_config:get(SceneId) of
		#scene_conf{is_quick_transfer = IsQuickTransfer, is_flying_shoes = IsFlaying, is_equip_send = IsQuipSend} = _SceneConf ->
			case IsEquipe of
				true ->
					case IsQuipSend =:= 1 of
						true ->
							scene_mgr_lib:change_scene(PlayerState, self(), SceneId, ?CHANGE_SCENE_TYPE_CHANGE, Point, ItemLoss, IsNoItem);
						false ->
							?INFO("11031 ~p", [{6666, SceneId}]),
							{fail, ?ERR_NO_EQUIP_TRANSFER}
					end;
				_ ->
					case SceneId =:= PlayerState#player_state.scene_id of
						true ->
							case IsFlaying =:= 0 of
								true ->
									{fail, ?ERR_NO_FLYING_SHOES};
								_ ->
									scene_mgr_lib:change_scene(PlayerState, self(), SceneId, ?CHANGE_SCENE_TYPE_CHANGE, Point, ItemLoss, IsNoItem)
							end;
						_ ->
							case IsQuickTransfer =:= 1 orelse PlayerState#player_state.is_robot =:= 1 of
								true ->
									scene_mgr_lib:change_scene(PlayerState, self(), SceneId, ?CHANGE_SCENE_TYPE_CHANGE, Point, ItemLoss, IsNoItem);
								false ->
									?INFO("11031 ~p", [{6666, SceneId}]),
									{fail, ?ERR_NO_QUICK_TRANSFER}
							end
					end
			end;
		_ ->
			{fail, ?ERR_COMMON_FAIL}
	end.