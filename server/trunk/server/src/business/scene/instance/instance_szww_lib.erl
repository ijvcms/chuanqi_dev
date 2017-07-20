%%%-------------------------------------------------------------------
%%% @author tuhujia
%%% @copyright (C) 2016, <COMPANY>
%%% @doc 胜者为王
%%%
%%% @end
%%% Created : 14. 三月 2016 14:05
%%%-------------------------------------------------------------------
-module(instance_szww_lib).

-include("common.hrl").
-include("record.hrl").
-include("config.hrl").
-include("proto.hrl").
-include("cache.hrl").
-include("log_type_config.hrl").

%% API
-export([
	init/2,
	on_timer/1,
	on_obj_enter/2,
	on_obj_harm/4,
	on_obj_die/3,
	on_player_exit/3,
	instance_end/1,
	instance_close/1,
	check_push_instance_info/1,
	do_add_value/1
]).

-define(ACTIVE_INSTANCE_ID, 12). %% 活动副本id
-define(REFUSE_TIMES, 5). %% 刷新时间间隔(秒)
-define(ADD_EXP_TIMES, 15). %% 添加经验时间(秒)
-define(MAX_KILL_COUNT, 20). %% 最大击杀次数
-define(ADD_REPUTATION, 50). %% 增加的功勋值
-define(ADD_REPUTATION_BY_10M, 5). %% 每10秒增加的功勋值

%% ====================================================================
%% API functions
%% ====================================================================
%% 初始化副本
init(SceneState, _PS) ->
	{StopTemp, CloseTemp, TotalTime} = get_time(),

	InstanceState = #instance_szww_state{
		total_time = TotalTime,
		close_tamp = CloseTemp,
		stop_tamp = StopTemp
	},

	gen_server2:apply_after(?REFUSE_TIMES * 1000, self(), {?MODULE, check_push_instance_info, []}),
	gen_server2:apply_after(?ADD_EXP_TIMES * 1000, self(), {?MODULE, do_add_value, []}),

	SceneState#scene_state{instance_state = InstanceState}.

%% 派生的定时器
on_timer(SceneState) ->
	SceneState.

%% 玩家进入事件
on_obj_enter(SceneState, PlayerState) when is_record(PlayerState, player_state) ->
	log_instance:on_player_enter(SceneState, PlayerState),
	%% 推送副本信息
	SceneState.

%% 对手受伤事件
on_obj_harm(SceneState, _TargetState, _CasterState, _HarmValue) ->
	SceneState.

%% 对象死亡事件
on_obj_die(SceneState, DieState, KillerState) ->
	NowTime = util_date:unixtime(),
	InstanceState = SceneState#scene_state.instance_state,
	StopTamp = InstanceState#instance_szww_state.stop_tamp,
	%% io:format("player die:~p,~p,~p~n", [NowTime, StopTamp, DieState#scene_obj_state.obj_type]),
	%% 开始记录排名
	NewSceneState =
	case NowTime >= StopTamp andalso DieState#scene_obj_state.obj_type == ?OBJ_TYPE_PLAYER of
		true ->
			%% 记录排名
			ObjList = scene_base_lib:do_get_scene_players(SceneState),
			ObjList1 = [X || X <- ObjList, X#scene_obj_state.cur_hp > 0],
			Rank = length(ObjList1),

			ObjList = scene_base_lib:do_get_scene_players(SceneState),
			update_player_rank(DieState#scene_obj_state.obj_id, Rank + 1),

			%% io:format("player die 333:~p~n", [Rank]),

			case Rank == 1 of
				true ->
					send_reward_mail(SceneState);
				false ->
					SceneState
			end;
		false ->
			SceneState
	end,

	%% 击杀玩家增加功勋
	%% io:format("kill obj type 333:~p~n", [KillerState#scene_obj_state.obj_type]),

	case DieState#scene_obj_state.obj_type == ?OBJ_TYPE_PLAYER of
		true when is_record(KillerState, scene_obj_state)->
			case KillerState#scene_obj_state.obj_type of
				?OBJ_TYPE_PLAYER ->
					case check_player_kill_count(KillerState#scene_obj_state.obj_id) of
						false ->
							skip;
						true ->
							%% io:format("kill player:~p~n", [KillerState#scene_obj_state.obj_pid]),
							Pid = KillerState#scene_obj_state.obj_pid,
							gen_server2:cast(Pid, {add_value, ?SUBTYPE_FEATS, ?ADD_REPUTATION, ?LOG_TYPE_INSTANCE_SZWW}),
							update_player_kill_count(KillerState#scene_obj_state.obj_id)
					end;
				?OBJ_TYPE_PET ->
					case check_player_kill_count(KillerState#scene_obj_state.owner_id) of
						false ->
							skip;
						true ->
							Pid = KillerState#scene_obj_state.owner_pid,
							gen_server2:cast(Pid, {add_value, ?SUBTYPE_FEATS, ?ADD_REPUTATION, ?LOG_TYPE_INSTANCE_SZWW}),
							update_player_kill_count(KillerState#scene_obj_state.owner_id)
					end;
				_ ->
					skip
			end;
		_ ->
			skip
	end,

	NewSceneState.

%% 玩家退出事件
on_player_exit(SceneState, ObjState, _LeaveType) ->
	%% io:format("player exit scene:~p~n", [get(ObjState#scene_obj_state.obj_id)]),
	log_instance:on_player_exit(SceneState, ObjState),
	NewSceneState =
	case get(ObjState#scene_obj_state.obj_id) of
		undefined ->
			NowTime = util_date:unixtime(),
			InstanceState = SceneState#scene_state.instance_state,
			StopTamp = InstanceState#instance_szww_state.stop_tamp,
			%% io:format("player exit scene 222:~p,~p~n", [NowTime, ObjState#scene_obj_state.obj_type]),
			%% 开始记录排名
			case NowTime >= StopTamp andalso ObjState#scene_obj_state.obj_type == ?OBJ_TYPE_PLAYER of
				true ->
					%% 记录排名
					ObjList = scene_base_lib:do_get_scene_players(SceneState),
					ObjList1 = [X || X <- ObjList, X#scene_obj_state.cur_hp > 0],
					Rank = length(ObjList1),

					ObjList = scene_base_lib:do_get_scene_players(SceneState),
					update_player_rank(ObjState#scene_obj_state.obj_id, Rank + 1),

					%% io:format("player exit scene 333:~p~n", [Rank]),

					case Rank == 1 of
						true ->
							send_reward_mail(SceneState);
						false ->
							SceneState
					end;
				false ->
					SceneState
			end;
		_ ->
			SceneState
	end,

	NewSceneState.

%% 副本关闭
instance_end(SceneState) ->
	%% 发放奖励
	ObjList = scene_base_lib:do_get_scene_players(SceneState),
	ObjList1 = [X || X <- ObjList, X#scene_obj_state.cur_hp > 0],
	case length(ObjList1) >= 1 of
		true ->
			send_reward_mail(SceneState);
		false ->
			skip
	end,

	SceneState#scene_state{instance_end_state = ?INSTANCE_END_STATE}.

%% 副本关闭
instance_close(SceneState) ->
	%% 清楚多人副本场景ets
	SceneId = SceneState#scene_state.scene_id,
	Key = {SceneId, ?WORLD_ACTIVE_SIGN},
	case ets:lookup(?ETS_SCENE_MAPS, Key) of
		[_EtsMaps] ->
			ets:delete(?ETS_SCENE_MAPS, Key);
		_ ->
			skip
	end,
	ets:delete(?ETS_SCENE, self()),

	SceneState.

%% ====================================================================
%% Internal functions
%% ====================================================================

%% 检测推送排行榜信息
check_push_instance_info(SceneState) ->
	push_all_player_instance_info(SceneState),
	gen_server2:apply_after(?REFUSE_TIMES * 1000, self(), {?MODULE, check_push_instance_info, []}),
%% 	NowTime = util_date:unixtime(),
%% 	InstanceState = SceneState#scene_state.instance_state,
%% 	StopTemp = InstanceState#instance_szww_state.stop_tamp,
%% 	case NowTime >= StopTemp of
%% 		true ->
%% 			skip;
%% 		false ->
%% 			push_all_player_instance_info(SceneState),
%%
%% 			gen_server2:apply_after(?REFUSE_TIMES * 1000, self(), {?MODULE, check_push_instance_info, []})
%% 	end,
	{ok, SceneState}.

%% 添加经验
do_add_value(SceneState) ->
	ObjList = scene_base_lib:do_get_scene_players(SceneState),
	Fun = fun(ObjState) ->
		Pid = ObjState#scene_obj_state.obj_pid,
		gen_server2:cast(Pid, {add_value, ?SUBTYPE_FEATS, ?ADD_REPUTATION_BY_10M, ?LOG_TYPE_INSTANCE_SZWW})
	end,
	[Fun(X) || X <- ObjList],
	gen_server2:apply_after(?ADD_EXP_TIMES * 1000, self(), {?MODULE, do_add_value, []}),
	{ok, SceneState}.

%% 推送信息给场景玩家
push_all_player_instance_info(SceneState) ->
	ObjList = scene_base_lib:do_get_scene_players(SceneState),
	NowTime = util_date:unixtime(),
	InstanceState = SceneState#scene_state.instance_state,
	CloseTamp = InstanceState#instance_szww_state.close_tamp,
	TotalTime = InstanceState#instance_szww_state.total_time,

	Time = CloseTamp - NowTime,
	TheNumber = length(ObjList),
	%% io:format("InstanceState time is:~p,~p~n", [Time, TheNumber]),
	Fun = fun(ObjState) ->
		PlayerId = ObjState#scene_obj_state.obj_id,
		net_send:send_to_client(PlayerId, 11029,
			#rep_szww_instance_info
			{
				total_time = TotalTime,
				time = Time,  %%  剩余时间(秒)
				the_number = TheNumber  %%  人数
			})
	end,
	[Fun(X) || X <- ObjList].

%% 更新玩家名次
update_player_rank(PlayerId, Rank) ->
	put(PlayerId, Rank).

%% 发放邮件
send_reward_mail(SceneState) ->
	case SceneState#scene_state.instance_end_state =/= ?INSTANCE_END_STATE of
		true ->
			RankInfoList = [{X, Y} || {X, Y} <- get(), is_integer(X)],
			%% io:format("ObjList len 111 is :~p~n", [RankInfoList]),
			Fun = fun({PlayerId, Rank}, _Acc) ->
				net_send:send_to_client(PlayerId, 11030,
					#rep_szww_reward
					{
						rank = Rank
					}),

				MailId = get_rank_reward(Rank),
				mail_lib:send_mail_to_player(PlayerId, MailId)
			end,
			lists:foldr(Fun, 0, RankInfoList),

			ObjList = scene_base_lib:do_get_scene_players(SceneState),
			ObjList1 = [X || X <- ObjList, X#scene_obj_state.cur_hp > 0],
			Rank1 = length(ObjList1),
			Fun1 = fun(ObjState) ->
						PlayerId = ObjState#scene_obj_state.obj_id,
						net_send:send_to_client(PlayerId, 11030,
							#rep_szww_reward
							{
								rank = Rank1
							}),

						%% io:format("ObjList len is :~p,~p~n", [Rank1, PlayerId]),
						MailId = get_rank_reward(Rank1),
						mail_lib:send_mail_to_player(PlayerId, MailId)
				   end,
			[Fun1(X) || X <- ObjList1],

			SceneState#scene_state{instance_end_state = ?INSTANCE_END_STATE};
		false ->
			skip
	end.

%% 获取排名奖励
get_rank_reward(Rank) ->
	get_rank_reward(Rank, szww_reward_config:get_list()).
get_rank_reward(_Rank, []) ->
	0;
get_rank_reward(Rank, [Key|T]) ->
	Conf = szww_reward_config:get(Key),
	case Rank >= Conf#szww_reward_conf.min_rank andalso Rank =< Conf#szww_reward_conf.max_rank of
		true ->
			Conf#szww_reward_conf.mail_id;
		false ->
			get_rank_reward(Rank, T)
	end.

%% 获取当前配置时间
get_time() ->
	ActConf = active_instance_config:get(?ACTIVE_INSTANCE_ID),
	{Date, _} = calendar:local_time(),
	NowTime = util_date:unixtime(),
	OpenTime = ActConf#active_instance_conf.open_time_1,
	OpenTamp = util_date:time_tuple_to_unixtime({Date, OpenTime}),
	CloseTime = ActConf#active_instance_conf.close_time_1,
	CloseTemp = util_date:time_tuple_to_unixtime({Date, CloseTime}),

	case NowTime >= OpenTamp andalso NowTime =< CloseTemp of
		true ->
			StopTime1 = ActConf#active_instance_conf.stop_time_1,
			StopTemp1 = util_date:time_tuple_to_unixtime({Date, StopTime1}),
			TotalTime1 = CloseTemp - OpenTamp,
			{StopTemp1, CloseTemp, TotalTime1};
		false ->
			StopTime2 = ActConf#active_instance_conf.stop_time_2,
			StopTemp2 = util_date:time_tuple_to_unixtime({Date, StopTime2}),
			CloseTime2 = ActConf#active_instance_conf.close_time_2,
			CloseTemp2 = util_date:time_tuple_to_unixtime({Date, CloseTime2}),
			OpenTime2 = ActConf#active_instance_conf.open_time_2,
			OpenTamp2 = util_date:time_tuple_to_unixtime({Date, OpenTime2}),
			TotalTime2 = CloseTemp2 - OpenTamp2,
			{StopTemp2, CloseTemp2, TotalTime2}
	end.

%% 获取玩家击杀次数
check_player_kill_count(PlayerId) ->
	Key = "sswz" ++ util_data:to_list(PlayerId),
	Count = get(Key),
	%% io:format("get player key:~p~n", [Count]),
	Count == undefined orelse Count < ?MAX_KILL_COUNT.

%% 更新玩家击杀次数
update_player_kill_count(PlayerId) ->
	Key = "sswz" ++ util_data:to_list(PlayerId),
	case get(Key) of
		undefined ->
			put(Key, 1);
		Count ->
			put(Key, Count + 1)
	end.