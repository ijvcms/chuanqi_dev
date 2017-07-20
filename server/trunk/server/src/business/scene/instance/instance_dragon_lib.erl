%%%-------------------------------------------------------------------
%%% @author tuhujia
%%% @copyright (C) 2016, <COMPANY>
%%% @doc 屠龙大会副本
%%%
%%% @end
%%% Created : 03. 三月 2016 14:09
%%%-------------------------------------------------------------------
-module(instance_dragon_lib).

-include("common.hrl").
-include("record.hrl").
-include("config.hrl").
-include("proto.hrl").
-include("cache.hrl").
-include("notice_config.hrl").

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
	check_push_rank_info/1
]).

-define(DRAGON_RANK_LIST, dragon_rank_list). %% 屠龙排行列表
-define(REFUSE_TIMES, 5). %% 刷新时间间隔(秒)
-define(SHOW_RANK_NUM, 5). %% 面板显示的排名数量
-define(TYPE_UI, 1). %% 面板类型
-define(TYPE_REWARD, 2). %% 奖励类型
-define(MAIL_ID_KILL_BOSS, 15). %% 击杀boss邮件id

%% 沙城活动
-record(dragon_rank_info, {
	player_id,
	lv,
	rank,
	name,
	harm
}).

%% ====================================================================
%% API functions
%% ====================================================================
%% 初始化副本
init(SceneState, _PS) ->
	%% erlang:erase(),
	set_rank_list([]),
	SceneId = SceneState#scene_state.scene_id,
	InstanceConf = instance_config:get(SceneId),

	InstanceState = #instance_dragon_state{
		boss_id = InstanceConf#instance_conf.boss_id,
		is_die = 0
	},

	gen_server2:apply_after(?REFUSE_TIMES * 1000, self(), {?MODULE, check_push_rank_info, []}),

	SceneState#scene_state{instance_state = InstanceState}.

%% 派生的定时器
on_timer(SceneState) ->
	SceneState.

%% 玩家进入事件
on_obj_enter(SceneState, PlayerState) when is_record(PlayerState, player_state) ->
	log_instance:on_player_enter(SceneState, PlayerState),
	%% 玩家进入推送排名信息
	push_player_rank_info(PlayerState#player_state.player_id, ?TYPE_UI),
	SceneState.

%% 对象受伤事件
on_obj_harm(SceneState, TargetState, CasterState, HarmValue) ->
	InstanceState = SceneState#scene_state.instance_state,
	BossId = InstanceState#instance_dragon_state.boss_id,

	case is_record(CasterState, scene_obj_state) of
		true ->
			case TargetState#scene_obj_state.monster_id == BossId andalso
				CasterState#scene_obj_state.obj_type == ?OBJ_TYPE_PLAYER of
				true ->
					update_player_harm(CasterState, HarmValue);
				false ->
					skip
			end;
		false ->
			skip
	end,

	SceneState.

%% 对象死亡事件
on_obj_die(SceneState, DieState, KillerState) ->
	%% boss死亡关闭副本结算奖励
	InstanceState = SceneState#scene_state.instance_state,
	BossId = InstanceState#instance_dragon_state.boss_id,

	case DieState#scene_obj_state.monster_id == BossId of
		true ->
			%% 发放奖励(最后一击打奖和参与参与奖)
			notice_lib:send_notice(0, ?NOTICE_TLDH_KILL, []),
			case KillerState#scene_obj_state.obj_type of
				?OBJ_TYPE_PLAYER when is_record(KillerState, scene_obj_state) ->
					mail_lib:send_mail_to_player(KillerState#scene_obj_state.obj_id, ?MAIL_ID_KILL_BOSS);
				?OBJ_TYPE_PET when is_record(KillerState, scene_obj_state) ->
					mail_lib:send_mail_to_player(KillerState#scene_obj_state.owner_id, ?MAIL_ID_KILL_BOSS);
				_ ->
					skip
			end,

			%% 更新boss状态
			InstanceState = SceneState#scene_state.instance_state,
			InstanceState1 = InstanceState#instance_dragon_state{is_die = 1},
			SceneState#scene_state{instance_state = InstanceState1};
		false ->
			SceneState
	end.

%% 玩家退出事件
on_player_exit(SceneState, ObjState, _LeaveType) ->
	log_instance:on_player_exit(SceneState, ObjState),

	SceneState.

%% 副本结束事件
instance_end(SceneState) ->
	SceneState.

%% 副本关闭事件
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

	%% 发放奖励
	send_reward_mail(),

	SceneState.

%% ====================================================================
%% Internal functions
%% ====================================================================

%% 检测推送排行榜信息
check_push_rank_info(SceneState) ->
	%% 刷新排行榜
	refuse_rank(),
	%% 推送排行给副本玩家
	push_all_player_rank_info(SceneState),

	%% boss死亡不再刷新排行
	InstanceState = SceneState#scene_state.instance_state,
	IsDie = InstanceState#instance_dragon_state.is_die,
	case IsDie == 1 of
		true ->
			skip;
		false ->
			gen_server2:apply_after(?REFUSE_TIMES * 1000, self(), {?MODULE, check_push_rank_info, []})
	end,

	{ok, SceneState}.

%% 推送信息给场景玩家
push_all_player_rank_info(SceneState) ->
	ObjList = scene_base_lib:do_get_scene_players(SceneState),
	Proto = get_proto_rank_list(),
	Fun = fun(ObjState) ->
				PlayerId = ObjState#scene_obj_state.obj_id,
				[PlayerRank, PlayerHarm] = get_player_rank_and_harm(PlayerId),
				net_send:send_to_client(PlayerId, 11028,
					#rep_dragon_instance_info
					{
						type = ?TYPE_UI,
						player_rank = PlayerRank,  %%  玩家自己排名
						player_harm = PlayerHarm,  %%  玩家自己造成伤害
						rank_list = Proto  %%  排名信息
					})
		  end,
	[Fun(X) || X <- ObjList].

%% 推送给单个玩家
push_player_rank_info(PlayerId, Type) ->
	Proto = get_proto_rank_list(),
	[PlayerRank, PlayerHarm] = get_player_rank_and_harm(PlayerId),
	net_send:send_to_client(PlayerId, 11028,
		#rep_dragon_instance_info
		{
			type = Type,
			player_rank = PlayerRank,  %%  玩家自己排名
			player_harm = PlayerHarm,  %%  玩家自己造成伤害
			rank_list = Proto  %%  排名信息
		}).

%% 定时刷新排行
refuse_rank() ->
	RankInfoList = [Y || {X, Y} <- get(), is_integer(X)],
	RankInfoList1 = lists:keysort(#dragon_rank_info.harm, RankInfoList),

	Fun = fun(RankInfo, {List, Rank}) ->
				NewRankInfo = RankInfo#dragon_rank_info{rank = Rank},
				PlayerId = NewRankInfo#dragon_rank_info.player_id,
				put(PlayerId, NewRankInfo),

				case Rank =< ?SHOW_RANK_NUM of
					true ->
						{[NewRankInfo] ++ List, Rank + 1};
					false ->
						{List, Rank + 1}
				end
		  end,
	{ShowList, _} = lists:foldr(Fun, {[], 1}, RankInfoList1),

	set_rank_list(ShowList).

%% 玩家攻击记录伤害
update_player_harm(CasterState, HarmValue) ->
	PlayerId = CasterState#scene_obj_state.obj_id,
	case get(PlayerId) of
		#dragon_rank_info{} = RankInfo ->
			RankInfo1 = RankInfo#dragon_rank_info
			{
				harm = RankInfo#dragon_rank_info.harm + HarmValue
			},
			put(PlayerId, RankInfo1);
		_ ->
			Lv = CasterState#scene_obj_state.lv,
			Name = CasterState#scene_obj_state.name,
			RankInfo = #dragon_rank_info
			{
				player_id = PlayerId,
				lv = Lv,
				rank = 0,
				name = Name,
				harm = HarmValue
			},
			put(PlayerId, RankInfo)
	end.

get_proto_rank_list() ->
	Fun = fun(RankInfo) ->
				#proto_world_boss_rank
				{
					rank = RankInfo#dragon_rank_info.rank,  %%  排名
					name = RankInfo#dragon_rank_info.name,  %%  名字
					harm = RankInfo#dragon_rank_info.harm  %%  造成伤害
				}
		  end,
	[Fun(X) || X <- get_rank_list()].

get_player_rank_and_harm(PlayerId) ->
	case get(PlayerId) of
		#dragon_rank_info{} = RankInfo ->
			[
				RankInfo#dragon_rank_info.rank,  %%  排名
				RankInfo#dragon_rank_info.harm  %%  造成伤害
			];
		_ ->
			[0, 0]
	end.

%% 发放邮件
send_reward_mail() ->
	RankInfoList = [Y || {X, Y} <- get(), is_integer(X)],
	RankInfoList1 = lists:keysort(#dragon_rank_info.harm, RankInfoList),
	Proto = get_proto_rank_list(),

	Fun = fun(RankInfo, Rank) ->
		PlayerId = RankInfo#dragon_rank_info.player_id,
		Lv = RankInfo#dragon_rank_info.lv,
		[PlayerRank, PlayerHarm] = get_player_rank_and_harm(PlayerId),
		net_send:send_to_client(PlayerId, 11028,
			#rep_dragon_instance_info
			{
				type = ?TYPE_REWARD,
				player_rank = PlayerRank,  %%  玩家自己排名
				player_harm = PlayerHarm,  %%  玩家自己造成伤害
				rank_list = Proto  %%  排名信息
			}),


		PlayerId = RankInfo#dragon_rank_info.player_id,
		MailId = get_reward(Rank, Lv),
		mail_lib:send_mail_to_player(PlayerId, MailId),
		Rank + 1
	end,
	lists:foldr(Fun, 1, RankInfoList1).

%% 获取排名奖励
get_reward(Rank, Lv) ->
	List = [X || X <- world_boss_reward_config:get_list_conf(),
		(Lv >= X#world_boss_reward_conf.min_lv andalso Lv =< X#world_boss_reward_conf.max_lv)],
	get_rank_reward(Rank, List).
get_rank_reward(_Rank, []) ->
	0;
get_rank_reward(Rank, [Conf|T]) ->
	case Rank >= Conf#world_boss_reward_conf.min_rank andalso Rank =< Conf#world_boss_reward_conf.max_rank of
		true ->
			Conf#world_boss_reward_conf.mail_id;
		false ->
			get_rank_reward(Rank, T)
	end.

%% ====================================================================
%% 内部字典
%% ====================================================================

%% 刷新排行榜 暂时记录前5名
set_rank_list(RankList) ->
	put(?DRAGON_RANK_LIST, RankList).

%% 获取排行榜 暂时记录前5名
get_rank_list() ->
	get(?DRAGON_RANK_LIST).