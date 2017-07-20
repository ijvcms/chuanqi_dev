%%%-------------------------------------------------------------------
%%% @author zhengsiying
%%% @copyright (C) 2015, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 31. 七月 2015 下午3:43
%%%-------------------------------------------------------------------
-module(scene_pp).
%%
-include("common.hrl").
-include("record.hrl").
-include("proto.hrl").
-include("config.hrl").
-include("cache.hrl").
-include("language_config.hrl").
-include("gameconfig_config.hrl").
-include("log_type_config.hrl").
%% API
-export([
	handle/3
]).

%% ====================================================================
%% API functions
%% ====================================================================
%% 登陆游戏进入场景
handle(11001, PlayerState, _Data) ->
	scene_lib:scene_login(PlayerState, _Data);

%% 开始移动
handle(11002, PlayerState, Data) ->
	?INFO("11002 ~p", [{Data, util_date:longunixtime()}]),
	#player_state{
		scene_pid = ScenePid,
		player_id = PlayerId
	} = PlayerState,
	#req_start_move{
		begin_point = #proto_point{x = BX, y = BY},
		end_point = #proto_point{x = EX, y = EY},
		direction = Direction
	} = Data,
	case player_lib:can_action(PlayerState) of
		true ->
			scene_obj_lib:start_move(ScenePid, ?OBJ_TYPE_PLAYER, PlayerId, {BX, BY}, {EX, EY}, Direction);
		_ ->
			skip
	end,
	{ok, PlayerState};
%% 移动同步
handle(11003, PlayerState,_Data) ->
	?INFO("11003 ~p", [{_Data, util_date:longunixtime()}]),
%% 	#player_state{
%% 		scene_pid = ScenePid,
%% 		player_id = PlayerId
%% 	} = PlayerState,
%% 	#req_move_sync{
%% 		point = Point,
%% 		direction = Direction
%% 	} = Data,
%% 	case player_lib:can_action(PlayerState) of
%% 		true ->
%% 			scene_obj_lib:move_sync(ScenePid, ?OBJ_TYPE_PLAYER, PlayerId, {Point#proto_point.x, Point#proto_point.y}, Direction);
%% 		_ ->
%% 			skip
%% 	end,
	{ok, PlayerState};
%% 拾取掉落
handle(11006, PlayerState, Data) ->
	#player_state{
		scene_pid = ScenePid,
		player_id = PlayerId,
		team_id = TeamId
	} = PlayerState,
	#req_pickup{
		drop_id = DropId
	} = Data,

	DropType = DropId div ?DROP_SECTION_BASE_NUM,
	case player_lib:can_action(PlayerState) andalso
		(goods_lib:get_free_bag_num(PlayerState) > 0 orelse DropType =:= ?DROP_TYPE_MONEY) of
		true ->
			scene_obj_lib:pickup_drop(ScenePid, PlayerId, TeamId, DropId);
		_ ->
			skip
	end;
%% 获取世界boss刷新时间
handle(11009, PlayerState, _Data) ->
	ProtoList = scene_lib:get_world_boss_ref_list(),
	net_send:send_to_client(PlayerState#player_state.socket, 11009, #rep_world_boss_refresh{refresh_list = ProtoList}),
	PlayerState1 = PlayerState#player_state{
		is_world_boss_ui = true
	},
	{ok, PlayerState1};
%% 获取打宝地图boss刷新时间
handle(11010, PlayerState, _Data) ->
	List = treasure_config:get_list(),
	CurTime = util_date:unixtime(),
	ProtoList = [
		begin
			#treasure_conf{
				scene_id = SceneId,
				boss_id = BossId
			} = treasure_config:get(Id),
			RefreshTime =
				case scene_mgr_lib:get_boss_refresh(SceneId, BossId) of
					#ets_boss_refresh{refresh_time = RT} = _EtsInfo ->
						max(RT - CurTime, 0);
					_ ->
						0
				end,
			#proto_boss_refresh{id = Id, refresh_time = RefreshTime}
		end || Id <- List],
	?INFO("send data : ~p", [ProtoList]),
	net_send:send_to_client(PlayerState#player_state.socket, 11010, #rep_treasure_refresh{refresh_list = ProtoList});
%% 获取副本入口信息
handle(11013, PlayerState, Data) ->
	?ERR("11013 ~p", [Data]),
	SceneId = Data#req_instance_entry_info.scene_id,
	SceneConf = scene_config:get(SceneId),
	case SceneConf#scene_conf.type of
		?SCENE_TYPE_INSTANCE ->
			{PlayerState1, Times} = player_instance_lib:get_instance_enter_times(PlayerState, SceneId),
			InstanceConf = instance_config:get(SceneId),

%% 获取自己购买的次数信息
%%BuyFbNum=counter_lib:get_value(PlayerState1#player_state.player_id,?COUNTER_FB_BUY_NUM),
			Times1 = InstanceConf#instance_conf.times_limit - Times,
			net_send:send_to_client(PlayerState1#player_state.socket, 11013, #rep_instance_entry_info{scene_id = SceneId, enter_times = Times1}),
			{ok, PlayerState1};
		_ ->
			skip
	end;
%% 获取副本场景统计
handle(11014, PlayerState, _Data) ->
	SceneId = PlayerState#player_state.scene_id,
	case is_number(SceneId) of
		true ->
			SceneConf = scene_config:get(SceneId),
			case SceneConf#scene_conf.type of
				?SCENE_TYPE_INSTANCE ->
					ScenePid = PlayerState#player_state.scene_pid,
					case is_pid(ScenePid) of
						true ->
							instance_base_lib:get_instance_info(ScenePid, PlayerState#player_state.pid);
						_ ->
							skip
					end;
				_ ->
					skip
			end;
		_ ->
			skip
	end;
%% 退出副本
handle(11016, PlayerState, _Data) ->
%% 	?ERR("recv 11016", []),
	scene_mgr_lib:exit_instance(PlayerState);
%% 获取沙城活动信息
handle(11018, PlayerState, _Data) ->
	Data = scene_activity_shacheng_lib:get_rep_shacheng_info(),
	net_send:send_to_client(PlayerState#player_state.socket, 11018, Data);
%% 获取场景内某个存活怪物坐标点
handle(11021, PlayerState, _Data) ->
	#player_state{
		player_id = PlayerId,
		scene_pid = ScenePid,
		socket = Socket
	} = PlayerState,
	scene_obj_lib:find_monster(ScenePid, PlayerId, Socket);
%% 传送阵传送协议
handle(11022, PlayerState, Data) ->
	?INFO("11022 ~p", [Data]),
	case scene_obj_lib:transfer(PlayerState, Data#req_transfer.id) of
		{ok, PlayerState1} ->
			net_send:send_to_client(PlayerState1#player_state.socket, 11022, #rep_transfer{}),
			{ok, PlayerState1};
		{fail, Err} ->
			net_send:send_to_client(PlayerState#player_state.socket, 11022, #rep_transfer{result = Err});
		_ERR ->
			?ERR("~p", [_ERR])
	end;
%% 场景地图标识
handle(11019, PlayerState, _Data) ->
	ScenePid = PlayerState#player_state.scene_pid,
	PlayerId = PlayerState#player_state.player_id,
	TeamId = PlayerState#player_state.team_id,
	Socket = PlayerState#player_state.socket,
	scene_send_lib:send_scene_teammate_flag(ScenePid, PlayerId, TeamId, Socket),
	{ok, PlayerState};

%% 传送点传送协议
handle(11024, PlayerState, Data) ->
	case cross_lib:transport(PlayerState, Data#req_transport.id) of
		{ok, PlayerState1} ->
			{ok, PlayerState1};
		{fail, Err} ->
			net_send:send_to_client(PlayerState#player_state.socket, 11024, #rep_transport{result = Err})
	end;

%% 获取npc功能状态
handle(11025, PlayerState, Data) ->
	PlayerStateNew = scene_npc_lib:get_scene_npc_state(PlayerState, Data#req_get_npc_state.id),
	{ok, PlayerStateNew};

%% 获取新手状态信息
handle(11026, PlayerState, Data) ->
	Result = guide_lib:get_guide_state(PlayerState#player_state.player_id, Data#req_get_guide_state.guide_step_id),
	net_send:send_to_client(PlayerState#player_state.socket, 11026, #rep_get_guide_state{result = Result});

%% 快速传送登入场景
handle(11031, PlayerState, #req_quick_change_scene{scene_id = SceneId}) ->
%% 	?ERR("scene pp 11031 ===================>>>>>>>>>>>>>>>>:~p~n", [SceneId]),
	if
		SceneId =:= 32104 ->
			%%跨服暗殿
			case active_instance_lib:check_wzad_cross_open(SceneId) of
				true ->
					cross_lib:change_scene_11031(PlayerState, SceneId, null, null);
				false ->
					net_send:send_to_client(PlayerState#player_state.socket, 11001, #rep_change_scene{result = ?ERR_ACTIVE_NOT_OPEN})
			end;
		(SceneId >= 31002 andalso SceneId =< 31004) orelse (SceneId >= 32109 andalso SceneId =< 32111) ->
			%%跨服火龙
			case active_instance_lib:check_dragon_cross_open(SceneId) of
				true ->
					cross_lib:change_scene_11031(PlayerState, SceneId, null, null);
				false ->
					net_send:send_to_client(PlayerState#player_state.socket, 11001, #rep_change_scene{result = ?ERR_ACTIVE_NOT_OPEN})
			end;
		true ->

			cross_lib:change_scene_11031(PlayerState, SceneId, null, null)
	end;


%% 获取世界boss免费传送次数
handle(11032, PlayerState, _Data) ->
	PlayerId = PlayerState#player_state.player_id,
	DPB = PlayerState#player_state.db_player_base,
	VipLv = DPB#db_player_base.vip,
	Career = DPB#db_player_base.career,
	VipConf = vip_config:get(VipLv, Career),

	UseCount = counter_lib:get_value(PlayerId, ?COUNTER_WORLD_BOSS_TRANSFER),
	LimitCount = VipConf#vip_conf.boss_transfer,
	Count = LimitCount - UseCount,

	net_send:send_to_client(PlayerState#player_state.socket, 11032, #rep_get_free_transfer_num{num = Count});

%% 世界boss免费传送
handle(11033, PlayerState, #req_get_free_transfer{scene_id = SceneId}) ->
%% 	PlayerId = PlayerState#player_state.player_id,
%% 	DPB = PlayerState#player_state.db_player_base,
%% 	VipLv = DPB#db_player_base.vip,
%% 	Career = DPB#db_player_base.career,
%% 	VipConf = vip_config:get(VipLv, Career),
%%
%% 	UseCount = counter_lib:get_value(PlayerId, ?COUNTER_WORLD_BOSS_TRANSFER),
%% 	LimitCount = VipConf#vip_conf.boss_transfer,
%% 	Count = LimitCount - UseCount,
%%
%% 	case Count > 0 of
%% 		true ->
%% 			WorldBossConf = world_boss_config:get(Id),
%% 			SceneId = WorldBossConf#world_boss_conf.scene_id,
%% 			case scene_mgr_lib:change_scene(PlayerState, self(), SceneId) of
%% 				{ok, PlayerState1} ->
%% 					counter_lib:update(PlayerId, ?COUNTER_WORLD_BOSS_TRANSFER),
%% 					{ok, PlayerState1};
%% 				_ ->
%% 					{ok, PlayerState}
%% 			end;
%% 		false ->
%% 			net_send:send_to_client(PlayerState#player_state.socket, 11033, #rep_get_free_transfer{result = ?ERR_WORLD_BOSS_TRANSFER_NOT_ENOUGH})
%% 	end;
	cross_lib:change_scene_11031(PlayerState, SceneId, {?ITEM_FLYING_SHOES, 1, ?LOG_TYPE_TRANSFER}, null);

%% 获取副本列表
handle(11034, PlayerState, _Data) ->
	?INFO("11034 ~p", [11034]),
	[FBList, PlayerState1] = player_instance_lib:get_instance_list(PlayerState),
	net_send:send_to_client(PlayerState#player_state.socket, 11034, #rep_get_fb_list{fb_list = FBList}),
	{ok, PlayerState1};

%% 购买副本次数
handle(11035, PlayerState, Data) ->
	SceneId = Data#req_buy_fb_num.scene_id,
	{PlayerState1, Result} = player_instance_lib:buy_fb_num(PlayerState, SceneId),
	net_send:send_to_client(PlayerState1#player_state.socket, 11035, #rep_buy_fb_num{result = Result}),
	{ok, PlayerState1};
%% 发送自己消息给其他玩家，获取其他玩家信息
handle(11037, PlayerState, _Data) ->
	Attr = PlayerState#player_state.db_player_attr,
	case Attr#db_player_attr.cur_hp < 1 of
		true ->
			player_pp:handle(10010, PlayerState, #req_player_die{});
		_ ->
			skip
	end,

	scene_send_lib_copy:send_scene_info_data_all(PlayerState),
	PlayerState1 = PlayerState#player_state{
		is_load_over = true
	},
	{ok, PlayerState1};

%% 获取当前场景的线路信息
handle(11038, PlayerState, _Data) ->
	{SceneLineNum, NewList} = scene_lib:get_line_list(PlayerState),
	NewData = #rep_get_line_list{
		now_line = SceneLineNum,
		line_info_list = NewList
	},
	net_send:send_to_client(PlayerState#player_state.socket, 11038, NewData);
%% 跳转到指定的线路
handle(11039, PlayerState, Data) ->
	LineNum = Data#req_change_scene_line.line,
	case is_integer(PlayerState#player_state.scene_id) of
		true ->
			SceneConf = scene_config:get(PlayerState#player_state.scene_id),
			case SceneConf#scene_conf.copy_num of
				1 ->
					skip;
				_ ->
					case PlayerState#player_state.scene_line_num =:= LineNum of
						true ->
							{ok, PlayerState};
						_ ->
							DbPlayerBase = PlayerState#player_state.db_player_base,
							#db_player_base{
								scene_id = SceneId,
								x = X,
								y = Y
							} = DbPlayerBase,
							scene_mgr_lib:change_scene_line(PlayerState, PlayerState#player_state.pid, SceneId, ?CHANGE_SCENE_TYPE_CHANGE, {X, Y}, LineNum)
					end
			end;
		_ ->
			skip
	end;
%% 跳转到指定的线路
handle(11040, PlayerState, _Data) ->
	List = player_foe_lib:get_foe_list_id(PlayerState#player_state.player_id),
	net_send:send_to_client(PlayerState#player_state.socket, 11040, #rep_get_foe_list{player_id_list = List});

%% 采集怪物
handle(11043, PlayerState, Data) ->
	#player_state{
		scene_pid = ScenePid,
		player_id = PlayerId,
		db_player_base = DPB,
		pid = PlayerPid
	} = PlayerState,

	ObjId = Data#req_collection.id,
	FreeBag = goods_lib:get_free_bag_num(PlayerState),

	case player_lib:can_action(PlayerState) of
		true ->
			GuildId = DPB#db_player_base.guild_id,
			scene_obj_lib:collection(ScenePid, PlayerId, GuildId, PlayerPid, FreeBag, ObjId);
		_ ->
			net_send:send_to_client(PlayerPid, 11043, #rep_collection{result = ?ERR_COMMON_FAIL})
	end;

%% 离开bossui
handle(11044, PlayerState, _Data) ->
	?INFO("11044 ~p", [111]),
	PlayerState1 = PlayerState#player_state{
		is_world_boss_ui = false
	},
	{ok, PlayerState1};

handle(11045, PlayerState, _Data) ->
	scene_send_lib_copy:get_single_boss_result(PlayerState);

handle(11046, PlayerState, _Data) ->
	player_monster_lib:monster_boss_drop(PlayerState);

%% 获取副本场景统计
handle(11047, _PlayerState, _Data) ->
	null;

%% 获取世界boss刷新时间和关注
handle(11048, PlayerState, #req_boss_time_and_follow{type = Type}) ->
	case Type of
		1 ->
			ProtoList = scene_lib:get_world_boss_ref_follow_list(PlayerState#player_state.player_id),
%% 			?ERR("~p", [ProtoList]),
			net_send:send_to_client(PlayerState#player_state.socket, 11048, #rep_boss_time_and_follow{type = Type, boss_list = ProtoList}),
			PlayerState1 = PlayerState#player_state{
				is_world_boss_ui = true
			},
			{ok, PlayerState1};
		2 ->
			ProtoList = scene_lib:get_vip_boss_ref_follow_list(PlayerState#player_state.player_id),
			net_send:send_to_client(PlayerState#player_state.socket, 11048, #rep_boss_time_and_follow{type = Type, boss_list = ProtoList}),
			{ok, PlayerState};
		5 ->
			ProtoList = scene_lib:get_single_boss_ref_list(PlayerState#player_state.player_id),
			net_send:send_to_client(PlayerState#player_state.socket, 11048, #rep_boss_time_and_follow{type = Type, boss_list = ProtoList}),
			{ok, PlayerState}
	end;

handle(11050, PlayerState, _Data) ->
	player_monster_lib:city_boss_killers(PlayerState);

%% 副本通关后继续留在副本中
handle(11051, PlayerState, _Data) ->
	scene_send_lib_copy:stay_scene(PlayerState);

%% 副本通关后继续留在副本中
handle(11053, PlayerState, #req_guise_list{top = _Top}) ->
	#player_state{scene_pid = ScenePid, pid = PlayerPid, player_id = PlayerId} = PlayerState,
	scene_send_lib_copy:get_scene_guise(ScenePid, PlayerPid, PlayerId);

handle(11054, PlayerState, Data) ->
	rpc:call(PlayerState#player_state.server_pass, scene_cross, proto_mod, [PlayerState, scene_pp, 11054, Data]);

%% 合服地图相关判断
handle(11055, PlayerState, _Data) ->
	F = fun(X, List) ->
		case function_db:is_open_scene(X#word_map_conf.scene_id) of
			true ->
				List;
			_ ->
				MapInfo = #proto_word_map_info{
					scene_id = X#word_map_conf.scene_id,
					state = 1
				},
				[MapInfo | List]
		end
	end,
	List1 = lists:foldl(F, [], word_map_config:get_list_conf()),
	Data1 = #rep_word_map_list{
		map_info_list = List1
	},
	?INFO("~p", [Data1]),
	net_send:send_to_client(PlayerState#player_state.socket, 11055, Data1);

%% 更新玩家采集状态
handle(11060, PlayerState, Data) ->
	?INFO("11060 ~p", [Data]),
	State = Data#req_update_collection_state.state,
	Upate = #player_state{collect_state = State},
	player_lib:update_player_state(PlayerState, Upate);


%% 请求变异地宫击杀boss数量
handle(11061, PlayerStatus, _Data) ->
	spec_palace_boss_mod:req_boss_info(PlayerStatus#player_state.pid),
	{ok, PlayerStatus};


%%************************************************************
%% 幻境之城
%%************************************************************
%%获取幻境之城的排名信息
handle(11103, PlayerState, _Data) ->
	scene_hjzc_lib:get_hjzc_rank_list(PlayerState);

%%获取玩家幻境之城的点亮信息
handle(11104, PlayerState, _Data) ->
	scene_hjzc_lib:get_hjzc_plyaer_info(PlayerState);

%%获取玩家幻境之城的点亮信息
handle(11105, PlayerState, #req_hjzc_send_change{room_num = RoomNum}) ->
	cross_lib:hjzc_send_change_11105(PlayerState, RoomNum);

handle(Cmd, PlayerState, Data) ->
	?ERR("not define ~p cmd:~nstate: ~p~ndata: ~p", [Cmd, PlayerState, Data]),
	{ok, PlayerState}.

%% ====================================================================
%% Internal functions
%% ====================================================================