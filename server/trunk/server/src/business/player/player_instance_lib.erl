%%%-------------------------------------------------------------------
%%% @author zhengsiying
%%% @copyright (C) 2015, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 16. 十二月 2015 上午12:48
%%%-------------------------------------------------------------------
-module(player_instance_lib).

-include("common.hrl").
-include("record.hrl").
-include("cache.hrl").
-include("config.hrl").
-include("button_tips_config.hrl").
-include("proto.hrl").
-include("language_config.hrl").
-include("log_type_config.hrl").

-define('BUY_FB_NEED_JADE', 20).
-define(SINGLE_BOSS_LEFT_TIME, 3600).

%% API
-export([
	init/1,
	get_instance_enter_times/2,
	add_instance_enter_times/2,
	get_instance_info/2,
	get_instance_list/1,
	buy_fb_num/2,
	get_single_boss_left_time/1,
	add_single_boss_left_time/2
]).

%% ====================================================================
%% API functions
%% ====================================================================
init(PlayerState) ->
	PlayerId = PlayerState#player_state.player_id,
	case check_reset_time(PlayerState) of
		{true, NewPlayerState} ->
			player_instance_cache:delete_all(PlayerId),
			put_instance_dict(dict:new()),
			NewPlayerState;
		_ ->
			case player_instance_cache:select_all(PlayerId) of
				[] ->
					put_instance_dict(dict:new());
				List ->
					F = fun(X, Acc) ->
						SceneId = X#db_player_instance.scene_id,
						dict:store(SceneId, X, Acc)
					end,
					InstanceDict = lists:foldl(F, dict:new(), List),
					put_instance_dict(InstanceDict)
			end,
			PlayerState
	end.

%%  获取副本列表
get_instance_list(PlayerState) ->
	SceneList = [scene_config:get(X) || X <- scene_config:get_type_list(?SCENE_TYPE_INSTANCE)],
	Base = PlayerState#player_state.db_player_base,
	F = fun(X, [List, PlayerStateTemp]) ->
		%% 获取副本信息
		InstanceConf = instance_config:get(X#scene_conf.scene_id),
		case InstanceConf#instance_conf.type =:= ?INSTANCE_TYPE_SINGLE andalso
			X#scene_conf.lv_limit =< Base#db_player_base.lv andalso
			X#scene_conf.lv_max >= Base#db_player_base.lv of
			true ->
				{PlayerStateTemp1, FBInfo} = get_fb_info(InstanceConf, X, PlayerStateTemp),
				[[FBInfo | List], PlayerStateTemp1];
			_ ->
				[List, PlayerStateTemp]
		end
	end,
	lists:foldr(F, [[], PlayerState], SceneList).

%% 获取副本次数
get_instance_enter_times(PlayerState, SceneId) ->
	SceneConf = scene_config:get(SceneId),

	case check_reset_time(PlayerState) of
		{true, NewPlayerState} ->
			player_instance_cache:delete_all(PlayerState#player_state.player_id),
			put_instance_dict(dict:new()),
			{NewPlayerState, 0};
		_ ->
			InstanceDict = get_instance_dict(),
			Times =
				case dict:find(SceneConf#scene_conf.belong_scene_id, InstanceDict) of
					{ok, V} ->
						V#db_player_instance.enter_times - V#db_player_instance.buy_times;
					_ ->
						0
				end,
			{PlayerState, Times}
	end.

%% 获取副本纪录信息
get_instance_info(PlayerState, SceneId) ->
	case check_reset_time(PlayerState) of
		{true, NewPlayerState} ->
			player_instance_cache:delete_all(PlayerState#player_state.player_id),
			PlayerInstanceInfo = #db_player_instance{
				scene_id = SceneId,
				enter_times = 0,
				buy_times = 0,
				player_id = PlayerState#player_state.player_id
			},
			player_instance_cache:insert(PlayerInstanceInfo),
			InstanceDict = dict:store(SceneId, PlayerInstanceInfo, dict:new()),
			put_instance_dict(InstanceDict),
			{NewPlayerState, PlayerInstanceInfo, InstanceDict};
		_ ->
			InstanceDict = get_instance_dict(),
			PlayerInstanceInfo1 = case dict:find(SceneId, InstanceDict) of
									  {ok, V} ->
										  V;
									  _ ->
										  PlayerInstanceInfo = #db_player_instance{
											  scene_id = SceneId,
											  enter_times = 0,
											  buy_times = 0,
											  player_id = PlayerState#player_state.player_id
										  },
										  player_instance_cache:insert(PlayerInstanceInfo),
										  InstanceDictNew = dict:store(SceneId, PlayerInstanceInfo, InstanceDict),
										  put_instance_dict(InstanceDictNew),
										  PlayerInstanceInfo
								  end,
			{PlayerState, PlayerInstanceInfo1, InstanceDict}
	end.
%% 加副本次数
add_instance_enter_times(PlayerState, SceneId) ->
	PlayerId = PlayerState#player_state.player_id,
	PlayerState1 =
		case check_reset_time(PlayerState) of
			{true, _PlayerState1} ->
				player_instance_cache:delete_all(PlayerState#player_state.player_id),
				Info = #db_player_instance{
					player_id = PlayerState#player_state.player_id,
					scene_id = SceneId,
					enter_times = 1,
					buy_times = 0
				},
				player_instance_cache:insert(Info),
				InstanceDict = dict:store(SceneId, Info, dict:new()),
				put_instance_dict(InstanceDict),
				_PlayerState1;
			_ ->
				InstanceDict = get_instance_dict(),
				case dict:find(SceneId, InstanceDict) of
					{ok, V} ->
						NewTimes = V#db_player_instance.enter_times + 1,
						NV = V#db_player_instance{enter_times = NewTimes},
						player_instance_cache:update({PlayerId, SceneId}, NV),
						NewInstanceDict = dict:store(SceneId, NV, InstanceDict),
						put_instance_dict(NewInstanceDict);
					_ ->
						Info = #db_player_instance{
							player_id = PlayerState#player_state.player_id,
							scene_id = SceneId,
							enter_times = 1,
							buy_times = 0
						},
						player_instance_cache:insert(Info),
						NewInstanceDict = dict:store(SceneId, Info, InstanceDict),
						put_instance_dict(NewInstanceDict)
				end,
				PlayerState
		end,

	InstanceConf = instance_config:get(SceneId),
	case InstanceConf#instance_conf.type of
		?INSTANCE_TYPE_SINGLE ->
			{ok, PlayerState2} = button_tips_lib:ref_button_tips(PlayerState1, ?BTN_INSTANCE_SINGLE),
			PlayerState2;
		_ ->
			PlayerState1
	end.

%% 购买副本次数
buy_fb_num(PlayerState, SceneId) ->
	SceneConf = scene_config:get(SceneId),
	InstanceConf = instance_config:get(SceneId),
	{PlayerState1, PlayerInstanceInfo, InstanceDict} = get_instance_info(PlayerState, SceneConf#scene_conf.belong_scene_id),
	case PlayerInstanceInfo#db_player_instance.buy_times >= InstanceConf#instance_conf.buy_limit of
		true ->
			{PlayerState1, ?ERR_INSTANCE_BUY_LIMIT_NUM};
		_ ->
			PlayerMoney = PlayerState1#player_state.db_player_money,
			case ?BUY_FB_NEED_JADE > PlayerMoney#db_player_money.jade of
				true ->
					{PlayerState1, ?ERR_PLAYER_JADE_NOT_ENOUGH};
				_ ->
					{ok, PlayerState2} = player_lib:incval_on_player_money_log(PlayerState1, #db_player_money.jade, -?BUY_FB_NEED_JADE, ?LOG_TYPE_BUY_FB_NUM),
					%% 获取购买次数
					NewBuyTimes = PlayerInstanceInfo#db_player_instance.buy_times + 1,
					NV = PlayerInstanceInfo#db_player_instance{buy_times = NewBuyTimes},
					%% 修改玩家的副本信息
					player_instance_cache:update({PlayerState#player_state.player_id, SceneConf#scene_conf.belong_scene_id}, NV),
					%% 保存ets表
					NewInstanceDict = dict:store(SceneConf#scene_conf.belong_scene_id, NV, InstanceDict),

					put_instance_dict(NewInstanceDict),
					{PlayerState3, FbInfo} = get_fb_info(InstanceConf, SceneConf, PlayerState2),

					net_send:send_to_client(PlayerState3#player_state.socket, 11036, #rep_ref_fb_info{fb_info = FbInfo}),

					{PlayerState3, 0}
			end
	end.

get_single_boss_left_time(PlayerState) ->
	{NewPlayerState, _EnterTimes} = get_instance_enter_times(PlayerState, 20100),
	NewPlayerBase = NewPlayerState#player_state.db_player_base,
	{NewPlayerState, NewPlayerBase#db_player_base.instance_left_time}.

add_single_boss_left_time(PlayerState, Time) ->
	{PlayerState1, SingleBossTime} = get_single_boss_left_time(PlayerState),
	Update = #player_state{
		db_player_base = #db_player_base{instance_left_time = SingleBossTime + Time}
	},
	player_lib:update_player_state(PlayerState1, Update).

%% ====================================================================
%% Internal functions
%% ====================================================================
%% 判断刷新次数时间
check_reset_time(PlayerState) ->
	DbPlayerBase = PlayerState#player_state.db_player_base,
	ResetTime = DbPlayerBase#db_player_base.instance_reset_time,
	CurTime = util_date:unixtime(),
	case CurTime >= ResetTime of
		true ->
			ResetTime1 = util_date:get_tomorrow_unixtime(),
			Update = #player_state{
				db_player_base = #db_player_base{instance_reset_time = ResetTime1, instance_left_time = ?SINGLE_BOSS_LEFT_TIME}
			},
			{ok, PlayerState1} = player_lib:update_player_state(PlayerState, Update),
			{true, PlayerState1};
		_ ->
			{false, PlayerState}
	end.



put_instance_dict(InstanceDict) ->
	put(instance_dict, InstanceDict).

get_instance_dict() ->
	get(instance_dict).

get_fb_info(InstanceConf, SceneConf, PlayerState) ->
	{PlayerState1, PlayerInstanceInfo, _} = player_instance_lib:get_instance_info(PlayerState, SceneConf#scene_conf.belong_scene_id),
	%% 副本可以攻击次数
	Times1 = InstanceConf#instance_conf.times_limit + PlayerInstanceInfo#db_player_instance.buy_times - PlayerInstanceInfo#db_player_instance.enter_times,
	FBInfo = #proto_fb_info{
		next_scene_id = InstanceConf#instance_conf.next_id,
		scene_id = SceneConf#scene_conf.scene_id,
		now_times = Times1,
		need_jade = ?BUY_FB_NEED_JADE,
		limit_buy_times = InstanceConf#instance_conf.buy_limit,
		buy_times = PlayerInstanceInfo#db_player_instance.buy_times
	},
	{PlayerState1, FBInfo}.
%%
%% check_instance_pass(PlayerId, SceneId) ->
%% 	case player_instance_pass_cache:select_row({PlayerId, SceneId}) of
%% 		null ->
%% 			0;
%% 		_ ->
%% 			1
%% 	end.