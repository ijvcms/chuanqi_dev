%%%-------------------------------------------------------------------
%%% @author zhengsiying
%%% @copyright (C) 2015, <COMPANY>
%%% @doc
%%%		场景管理模块
%%% @end
%%% Created : 27. 七月 2015 上午10:57
%%%-------------------------------------------------------------------
-module(scene_hjzc_lib).

-include("common.hrl").
-include("record.hrl").
-include("config.hrl").
-include("cache.hrl").
-include("proto.hrl").
-include("language_config.hrl").
-include("log_type_config.hrl").
-include("spec.hrl").
%% API
%% callbacks
-export([
	create_scene/2,
	create_scene/0,
	change_scene_line/5,
	close_hjzc/1,
	get_hjzc_state/0,
	save_hjzc/1,
	get_hjzc_info/0,
	get_hjzc_rank_list/1,
	get_hjzc_plyaer_info/1,
	check_jump/1,
	get_hjzc_rank/0,
	hjzc_change/2
]).
%% ====================================================================
%% API functions
%% ====================================================================

%% 幻境之城 安全空间
-define(HJZC_SAFE_NUM, [45, 46, 47, 55, 56, 57, 65, 66, 67]).

%% 排名奖励
%% 获取幻境之城的排名信息
get_hjzc_rank_list(PlayerState) ->
	%% 组合所有的排名信息
	F2 = fun({_, HjzcPlayer}, {Acc, Num}) ->
		Data = #proto_hjzc_rank_info{
			name = HjzcPlayer#hjzc_player.name,
			rank = Num,
			player_id = HjzcPlayer#hjzc_player.player_id,
			num = length(HjzcPlayer#hjzc_player.room_list)
		},
		{Acc ++ [Data], Num + 1}
	end,

	%% 组合所有的排名信息
	Lists1 = lists:sublist(get_hjzc_rank(), 10),
	{Lists3, _} = lists:foldl(F2, {[], 1}, Lists1),
	%% 获取排名信息
	Data1 = #rep_get_hjzc_rank_list{
		rank_list = Lists3
	},
	net_send:send_to_client(PlayerState#player_state.pid, 11103, Data1).


%% 获取玩家幻境之城的点亮信息
get_hjzc_plyaer_info(PlayerState) ->
	RoomNum = case PlayerState#player_state.scene_id /= ?SCENEID_HJZC_FAJIAN of
				  true ->
					  [T | _H] = ?HJZC_SAFE_NUM,
					  T;
				  _ ->
					  PlayerState#player_state.scene_line_num
			  end,

	Data = #rep_get_hjzc_plyaer_info{
		room_num = RoomNum,
		pass_room_num_list = get_hjzc_player(PlayerState#player_state.player_id)
	},
	?INFO("~p", [Data]),
	net_send:send_to_client(PlayerState#player_state.pid, 11104, Data).

%% 传送
hjzc_change(PlayerState, OrderNum) ->
	change_scene_line(PlayerState, ?SCENEID_HJZC_FAJIAN, null, OrderNum, 0).

%%*****************************************************
%% API
%%*****************************************************
create_scene() ->
	%% 设置幻境之城开启
	R = get_hjzc_info(),
	case R#ets_hjzc.is_open =:= false of
		true ->
			RoomNumList = [X || X <- lists:seq(1, 100), not lists:member(X, ?HJZC_SAFE_NUM)],
%% 			%% 获取保存宝箱的地址
%% 			F = fun(_X, {Acc, List}) ->
%% 				Room1 = util_rand:list_rand(RoomNumList),
%% 				Acc1 = [Room1 | Acc],
%% 				Lists1 = lists:delete(Room1, List),
%% 				{Acc1, Lists1}
%% 			end,
%% 			{BoxNumList, _} = lists:foldl(F, {[], RoomNumList}, lists:seq(1, 4)),


			R1 = R#ets_hjzc{
				player_pass_dict = dict:new(),
				is_open = true,
				box_from_list = [],
				rand_room_num_list = RoomNumList
			},
			save_hjzc(R1),

			[create_scene(?SCENEID_HJZC_FAJIAN, X) || X <- RoomNumList],
			create_scene(?SCENEID_HJZC_DATING, 1),

			?ERR("~p", [ok]);
		_ ->
			?ERR("~p", [open]),
			skip
	end,
	ok.

%% 创建场景(场景管理进程使用)
create_scene(SceneId, LineNum) ->
	%% 获取场景副本标记
	SceneSign = instance_base_lib:get_instance_sign(null, SceneId),
	%% 幻境之城 背景图片列表
	ScenePic = case SceneId of
				   ?SCENEID_HJZC_FAJIAN ->
					   util_rand:rand(12001, 12010);
				   _ ->
					   0
			   end,

	Key = {SceneId, SceneSign},
	%% 获取属于的线路
	{ok, Pid} = scene_mod:start(SceneId, #player_state{}, {LineNum, ScenePic}),
	EtsScene = #ets_scene{
		pid = Pid,
		scene_id = SceneId,
		player_list = []
	},
	ets:insert(?ETS_SCENE, EtsScene),
	PidLine = #pid_line{
		pid = Pid,
		line_num = LineNum
	},
	case ets:lookup(?ETS_SCENE_MAPS, Key) of
		[EtsMaps] ->
			NewPidLineList = EtsMaps#ets_scene_maps.pid_list ++ [PidLine],
			ets:insert(?ETS_SCENE_MAPS, EtsMaps#ets_scene_maps{pid_list = NewPidLineList});
		_ ->
			ets:insert(?ETS_SCENE_MAPS, #ets_scene_maps{scene_id = Key, pid_list = [PidLine]})
	end,
	{ok, Pid}.

%% 设置幻境之城关闭
close_hjzc(SceneId) ->
	%% 发送奖励
	InstanceConf = instance_config:get(SceneId),
	RankList = scene_hjzc_lib:get_hjzc_rank(),
	F = fun(X, Rank) ->
		{_, #hjzc_player{
			server_pass = ServerPass,
			player_id = PlayerId
		}} = X,
		MailIdList = [MailId || {MinRank, MaxRank, MailId} <- InstanceConf#instance_conf.mail_reward,
			Rank >= MinRank, Rank =< MaxRank
		],
		?WARNING("MailIdList ~p", [[ServerPass, PlayerId, MailIdList]]),
		case MailIdList of
			[] ->
				skip;
			_ ->
				[MailId1 | _] = MailIdList,
				mail_lib:send_mail_to_player(ServerPass, PlayerId, MailId1)
		end,
		Rank + 1
	end,
	lists:foldl(F, 1, RankList),

	%% 幻境房间全部关闭
	SceneSign = instance_base_lib:get_instance_sign(null, ?SCENEID_HJZC_FAJIAN),
	Key = {?SCENEID_HJZC_FAJIAN, SceneSign},
	case ets:lookup(?ETS_SCENE_MAPS, Key) of
		[EtsMaps] ->
			F1 = fun(HH) ->
				gen_server2:apply_async(HH, {instance_base_lib, instance_close, []})
			end,
			[F1(X#pid_line.pid) || X <- EtsMaps#ets_scene_maps.pid_list];
		_ ->
			skip
	end,

	%%  设置关闭
	R = get_hjzc_info(),
	R1 = R#ets_hjzc{
		is_open = false
	},
	save_hjzc(R1).

%% 获取幻境之城的状态信息
get_hjzc_state() ->
	case ets:lookup(?ETS_HJZC, ?SCENEID_HJZC_DATING) of
		[R | _] ->
			R#ets_hjzc.is_open;
		_ ->
			false
	end.

%% 传送幻境之城
change_scene_line(PlayerState, ToSceneId, ToPosList, OrderNum, Direction) ->
	#player_state{
		scene_line_num = SceneLineNum,
		pid = Pid,
		scene_pid = ScenePid
	} = PlayerState,
	case check_jump(ScenePid) of
%% 	case true of
		true ->
			OrderNum1 = case OrderNum < 1 of
							true ->
								LineNum = SceneLineNum,
								case Direction of
									1 ->
										LineNum1 = LineNum - 10,
										case LineNum1 < 1 of
											true ->
												LineNum + 90;
											_ ->
												LineNum1
										end;
									2 ->
										LineNum1 = LineNum + 10,
										case LineNum1 > 100 of
											true ->
												LineNum - 90;
											_ ->
												LineNum1
										end;
									3 ->
										Bit = LineNum rem 10,
										case Bit of
											1 ->
												LineNum + 9;
											_ ->
												LineNum - 1
										end;
									_ ->
										Bit = LineNum rem 10,
										case Bit of
											0 ->
												LineNum - 9;
											_ ->
												LineNum + 1
										end
								end;
							_ ->
								if
									OrderNum < 1 ->
										1;
									OrderNum > 100 ->
										100;
									true ->
										OrderNum
								end
						end,
			ToPos = util_rand:list_rand(ToPosList),
			?WARNING("ordernum ~p roomnum ~p nowroomnum ~p", [OrderNum, OrderNum1, SceneLineNum]),
			case not lists:member(OrderNum1, ?HJZC_SAFE_NUM) of
				true ->
					scene_mgr_lib:change_scene(PlayerState, Pid, ToSceneId, ?CHANGE_SCENE_TYPE_CHANGE, ToPos, OrderNum1);
				_ ->
					scene_mgr_lib:change_scene(PlayerState, Pid, ?SCENEID_HJZC_DATING, ?CHANGE_SCENE_TYPE_CHANGE, null, 0)
			end;
		_Err ->
			?ERR("~p", [_Err]),
			{fail, ?ERR_HJZC_KILL_ALL}
	end.


%% 检测是否可以跳转
check_jump(ScenePid) when is_pid(ScenePid) ->
	gen_server2:apply_sync(ScenePid, {?MODULE, check_jump, []});
check_jump(SceneState) ->
	case util_data:is_null(SceneState#scene_state.instance_state) of
		true ->
			true;
		_ ->
			instance_cross_hjzc_lib:check_pass_condition(SceneState)
	end.

%% 保存幻境之城数据
save_hjzc(R) ->
	ets:insert(?ETS_HJZC, R).

%% 获取幻境之城数据
get_hjzc_info() ->
	case ets:lookup(?ETS_HJZC, ?SCENEID_HJZC_DATING) of
		[R | _] ->
			R;
		_ ->
			#ets_hjzc{
				key = ?SCENEID_HJZC_DATING,
				player_pass_dict = dict:new(),
				is_open = false,
				box_from_list = [],
				rand_room_num_list = [],
				record_box_list = []
			}
	end.
%% 获取玩家的幻境之城信息
get_hjzc_player(PlayerId) ->
	HjzcInfo = get_hjzc_info(),
	case dict:find(PlayerId, HjzcInfo#ets_hjzc.player_pass_dict) of
		{ok, HjzcPlayer} ->
			HjzcPlayer#hjzc_player.room_list;
		_ ->
			[]
	end.
%% 获取排名信息
get_hjzc_rank() ->
	HjzcInfo = get_hjzc_info(),
	%% 获取房间点亮信息
	Lists = dict:to_list(HjzcInfo#ets_hjzc.player_pass_dict),
	%% 排序
	case length(Lists) > 1 of
		true ->
			F1 = fun({_, HjzcPlayer1}, {_, HjzcPlayer2}) ->
				#hjzc_player{
					room_list = RoolList1,
					time = Time1
				} = HjzcPlayer1,
				#hjzc_player{
					room_list = RoolList2,
					time = Time2
				} = HjzcPlayer2,
				Temp1 = length(RoolList1),
				Temp2 = length(RoolList2),
				Temp1 > Temp2 orelse (Temp1 =:= Temp2 andalso Time1 < Time2)
			end,
			lists:sort(F1, Lists);
		_ ->
			Lists
	end.

