%%%-------------------------------------------------------------------
%%% @author zhengsiying
%%% @copyright (C) 2015, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 31. 七月 2015 下午3:43
%%%-------------------------------------------------------------------
-module(scene_lib).

-include("common.hrl").
-include("record.hrl").
-include("proto.hrl").
-include("config.hrl").
-include("cache.hrl").
-include("language_config.hrl").
-include("gameconfig_config.hrl").
-include("log_type_config.hrl").
-include("spec.hrl").
-define(CROSS_SCENE_BLACK, 20101).%% 跨服返回
%% API
-export([
	get_line_list/1,
	get_world_boss_ref_list/0,
	ref_world_boss/0,
	send_world_boss_list/2,
	get_world_boss_ref_follow_list/1,
	get_vip_boss_ref_follow_list/1,
	get_single_boss_ref_list/1,
	get_single_boss_time/1,
	check_scene_player/2,
	scene_login/2
]).

%% GEN API
-export([
	do_get_single_boss_time/1,
	do_check_scene_player/2
]).

%% 登录进入游戏
scene_login(PlayerState, _Data) ->
	?INFO("11001 ~p", [11001]),
	%% 登陆进入场景
	DbPlayerBase = PlayerState#player_state.db_player_base,
	#db_player_base{
		scene_id = SceneId,
		x = X,
		y = Y,
		state = State
	} = DbPlayerBase,

	case SceneId =:= 0 orelse util_data:is_null(SceneId) of
		true ->
			scene_mgr_lib:change_scene(PlayerState, PlayerState#player_state.pid, ?GAMECONFIG_FIRST_SCENE, ?CHANGE_SCENE_TYPE_ENTER, {X, Y});%
		_ ->
			%% 判断如果在副本剔出场景
			OldSceneConf = scene_config:get(SceneId),

			{SceneId1, PlayerState1} =
				case State of
					?STATUS_DIE ->
						TempSceneId =
							case OldSceneConf#scene_conf.exit_scene > 0 of
								true ->
									OldSceneConf#scene_conf.exit_scene;
								_ ->
									SceneId
							end,
						Update = #player_state{
							db_player_base = #db_player_base{
								state = ?STATUS_ALIVE
							}
						},
						{ok, TempPlayerState} = player_lib:update_player_state(PlayerState, Update),
						{TempSceneId, TempPlayerState};
					_ ->
						TempSceneId =
							case SceneId of
								?SCENEID_HJZC_FAJIAN ->
									?SCENEID_HJZC_DATING;
								_ ->
									SceneId
							end,
						OldSceneConf1 = scene_config:get(TempSceneId),
						%% 判断时间是否已经过了
						case active_instance_config:get(TempSceneId) of
							#active_instance_conf{} = _ ->
								case active_instance_lib:is_open_active(TempSceneId) of
									{ok, TimeSpan} when TimeSpan > 10 ->
										{TempSceneId, PlayerState};
									_ ->
										{OldSceneConf1#scene_conf.exit_scene, PlayerState}
								end;
							_ ->
								case OldSceneConf1#scene_conf.type =:= ?SCENE_TYPE_MAIN_CITY orelse
									OldSceneConf1#scene_conf.type =:= ?SCENE_TYPE_OUTDOOR of
									true ->
										{TempSceneId, PlayerState};
									_ ->
										{OldSceneConf1#scene_conf.exit_scene, PlayerState}
								end
						end
				end,

			SceneConf = scene_config:get(SceneId1),
			case SceneConf#scene_conf.is_cross of
				1 ->
					case scene_cross:send_cross(PlayerState1) of
						{ok, PlayerState2} ->
							Base1 = PlayerState2#player_state.db_player_base,
							PlayerState3 = PlayerState2#player_state{
								db_player_base = Base1#db_player_base{
									scene_id = SceneId1
								}
							},
							%%scene_mgr_lib:change_scene(PlayerState1, self(), ?CROSS_SCENE_BLACK, ?CHANGE_SCENE_TYPE_ENTER, {X, Y});
							%%cross_boss_lib:handle(scene_pp, 11031, #req_quick_change_scene{scene_id = SceneId1}, PlayerState2, true);
							case cross_boss_lib:handle(scene_pp, 11001, _Data, PlayerState3, true) of
								{ok, PlayerState4} ->
									{ok, PlayerState4};
								Err ->
									?ERR(" ~p", [Err]),
									skip
							end;
						_ ->
							scene_mgr_lib:change_scene(PlayerState1, PlayerState1#player_state.pid, ?CROSS_SCENE_BLACK, ?CHANGE_SCENE_TYPE_ENTER, {X, Y})
					end;
				_ ->
					case SceneConf#scene_conf.type == ?SCENE_TYPE_INSTANCE of
						true ->
							ExitScene = SceneConf#scene_conf.exit_scene,
							scene_mgr_lib:change_scene(PlayerState1, PlayerState1#player_state.pid, ExitScene);%
						false ->
							scene_mgr_lib:change_scene(PlayerState1, PlayerState1#player_state.pid, SceneId1, ?CHANGE_SCENE_TYPE_ENTER, {X, Y})%
					end
			end
	end.

%% 获取分线信息
get_line_list(PlayerState) ->
	case not util_data:is_null(PlayerState#player_state.scene_id) of
		true ->
			SceneConf = scene_config:get(PlayerState#player_state.scene_id),
			NeedSceneId = case instance_base_lib:is_multiple_instance(SceneConf#scene_conf.scene_id) of%% 检测是否是多人副本类型
							  true ->
								  %% 如果是多人副本判断副本是否已经创建，如果是已经创建随机选择一个进入就行
								  SceneSign = instance_base_lib:get_instance_sign(PlayerState, SceneConf#scene_conf.scene_id),%% 获取场景副本标记
								  {SceneConf#scene_conf.scene_id, SceneSign};
							  _ ->
								  SceneConf#scene_conf.scene_id
						  end,

			{SceneLineNum, PidList} = scene_mgr_lib:get_line_num(PlayerState#player_state.scene_pid, NeedSceneId),
			%% 场景信息
			RedNum = SceneConf#scene_conf.limit_num * 0.8,
			F = fun(X, Acc) ->
				PlayerNum = scene_mgr_lib:get_scene_player_num(X#pid_line.pid),
				case PlayerNum < 1 of
					true ->
						Acc;
					_ ->
						State = case PlayerNum > RedNum of
									true ->
										1;
									_ ->
										0
								end,
						LineInfo = #proto_line_info{
							line_num = X#pid_line.line_num,
							state = State,
							player_num = PlayerNum
						},
						[LineInfo | Acc]
				end
			end,
			%% 可以跳转的线路信息
			NewList = lists:foldr(F, [], PidList),
			{SceneLineNum, NewList};
		_ ->
			{1, [#proto_line_info{line_num = 1, state = 0, player_num = 1}]}
%% 			Fun = fun(X) ->
%% 				#proto_line_info{
%% 					line_num = X,
%% 					state = 0,
%% 					player_num = 1
%% 				}
%% 			end,
%% 			List = [Fun(X) || X <- lists:seq(1, 30)],
%% 			{1, List}
	end.

%% 刷新boss信息
ref_world_boss() ->
	ProtoList = get_world_boss_ref_list(),
	{ok, Bin} = pt:write_cmd(11009, #rep_world_boss_refresh{refresh_list = ProtoList}),
	Bin1 = pt:pack(11009, Bin),
	[send_world_boss_list(X#ets_online.pid, Bin1) || X <- player_lib:get_online_players()].

send_world_boss_list(PlayerPid, Bin) when is_pid(PlayerPid) ->
	gen_server2:apply_async(PlayerPid, {?MODULE, send_world_boss_list, [Bin]});
send_world_boss_list(PlayerState, Bin) ->
	case PlayerState#player_state.is_world_boss_ui of
		true ->
			net_send:send_one(PlayerState#player_state.socket, Bin);
		_ ->
			skip
	end.

%%玩家退出时保存场景的相关信息到玩家表
get_single_boss_time(PlayerState) ->
	case is_integer(PlayerState#player_state.scene_id) of
		false ->
			skip;
		_ ->
			SceneConf = scene_config:get(PlayerState#player_state.scene_id),
			case SceneConf#scene_conf.is_cross of
				1 ->
					skip;
				_ ->
					case util_data:check_pid(PlayerState#player_state.scene_pid) of
						true ->
							gen_server2:apply_sync(PlayerState#player_state.scene_pid,
								{?MODULE, do_get_single_boss_time, []});
						_ ->
							skip
					end
			end
	end.


%% 获取副本的剩余时间
do_get_single_boss_time(SceneState) ->
	case SceneState#scene_state.instance_state of
		#instance_single_boss_state{enter_time = EnterTime} ->
			CurTime = util_date:unixtime(),
			%%?ERR("LeftTimeOld2 ~p ~p ~p", [LeftTimeOld, EnterTime,CurTime]),
			UseTime = CurTime - EnterTime,
			{ok, UseTime};
		_ ->
			skip
	end.

%% ====================================================================
%% Internal functions
%% ====================================================================

%% 获取boss刷新信息
get_world_boss_ref_list() ->
	List = world_boss_config:get_list(),
	CurTime = util_date:unixtime(),
	F = fun(X, List1) ->
		#world_boss_conf{
			scene_id = SceneId,
			boss_id = BossId
		} = world_boss_config:get(X),
		case function_db:is_open_scene(SceneId) of
			true ->
				RefreshTime =
					case scene_mgr_lib:get_boss_refresh(SceneId, BossId) of
						#ets_boss_refresh{refresh_time = RT} = _EtsInfo ->
							max(RT - CurTime, 0);
						_ ->
							0
					end,
				BossTimeInfo = #proto_boss_refresh{id = X, refresh_time = RefreshTime},
				[BossTimeInfo | List1];
			_ ->
				List1
		end
	end,
	lists:foldl(F, [], List).

%% 获取世界boss刷新信息和关注
get_world_boss_ref_follow_list(PlayerId) ->
	List = world_boss_config:get_list(),
	FollowDict = player_monster_follow_lib:follow_dict(PlayerId),
	CurTime = util_date:unixtime(),
	F = fun(X, List1) ->
		#world_boss_conf{
			scene_id = SceneId,
			boss_id = BossId
		} = world_boss_config:get(X),
		case function_db:is_open_scene(SceneId) of
			true ->
				RefreshTime =
					case scene_mgr_lib:get_boss_refresh(SceneId, BossId) of
						#ets_boss_refresh{refresh_time = RT} = _EtsInfo ->
							max(RT - CurTime, 0);
						_ ->
							0
					end,
				Follow = case dict:is_key({SceneId, BossId}, FollowDict) of
							 true -> 1;
							 false -> 0
						 end,
				BossTimeInfo = #proto_boss_time_and_follow{scene_id = SceneId, monster_id = BossId, refresh_time = RefreshTime, follow = Follow},
				[BossTimeInfo | List1];
			_ ->
				List1
		end
	end,
	lists:foldl(F, [], List).

%% 获取boss之家刷新信息和关注
get_vip_boss_ref_follow_list(PlayerId) ->
	List = vip_boss_config:get_list(),
	FollowDict = player_monster_follow_lib:follow_dict(PlayerId),
	CurTime = util_date:unixtime(),
	F = fun(X) ->
		#vip_boss_conf{
			scene_id = SceneId,
			boss_id = BossId
		} = vip_boss_config:get(X),
		RefreshTime =
			case scene_mgr_lib:get_boss_refresh(SceneId, BossId) of
				#ets_boss_refresh{refresh_time = RT} = _EtsInfo ->
					max(RT - CurTime, 0);
				_ ->
					0
			end,
		Follow = case dict:is_key({SceneId, BossId}, FollowDict) of
					 true -> 1;
					 false -> 0
				 end,
		#proto_boss_time_and_follow{scene_id = SceneId, monster_id = BossId, refresh_time = RefreshTime, follow = Follow}
	end,
	[F(X) || X <- List].

%% 获取个人boss刷新信息
get_single_boss_ref_list(PlayerId) ->
	List = self_boss_config:get_list(),
	SingleBossDict = get_single_boss_hp_dict(PlayerId),

	F = fun(X, List1) ->
		#self_boss_conf{
			scene_id = SceneId,
			boss_id = BossId
		} = self_boss_config:get(X),
		case function_db:is_open_scene(SceneId) of
			true ->
				RefreshTime =
					case dict:find(SceneId, SingleBossDict) of
						{ok, BossHpList} ->
							case lists:keyfind(BossId, 1, BossHpList) of
								{BossId, _} ->
									0;
								_ ->
									1
							end;
						_ ->
							0
					end,
				BossTimeInfo = #proto_boss_time_and_follow{scene_id = SceneId, monster_id = BossId, refresh_time = RefreshTime},
				[BossTimeInfo | List1];
			_ ->
				List1
		end
	end,
	lists:foldl(F, [], List).
%%获取保存的boss的血量
get_single_boss_hp_dict(PlayerId) ->
	case player_monster_state_cache:select_row(PlayerId) of
		#db_player_monster_state{refresh_time = RefreshTime, hp_reset_time = _HpTime} = Rec ->
			case util_date:unixtime() < RefreshTime of
				true ->
					MonsterState = Rec#db_player_monster_state.monster_state,
					dict:from_list(MonsterState);
				false ->
					dict:new()
			end;
		_ ->
			dict:new()
	end.


%% 判断对方玩家是否在玩家对应的 场景中
check_scene_player(PlayerState, PlayerId) ->
	#player_state{scene_pid = ScendPid} = PlayerState,
	case util_data:check_pid(ScendPid) of
		true ->
			case gen_server2:apply_sync(ScendPid, {?MODULE, do_check_scene_player, [PlayerId]}) of
				{ok, _} ->
					true;
				_ ->
					false
			end;
		_ ->
			false
	end.
%% 判断对方玩家是否在玩家对应的 场景中
do_check_scene_player(SceneState, PlayerId) ->
	case scene_base_lib:get_scene_obj_state(SceneState, ?OBJ_TYPE_PLAYER, PlayerId) of
		#scene_obj_state{cur_hp = CurHp} when CurHp > 0 ->
			{ok, SceneState};
		_ ->
			{fail, false}
	end.