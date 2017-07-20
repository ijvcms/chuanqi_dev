%%%-------------------------------------------------------------------
%%% @author tuhujia
%%% @copyright (C) 2016, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 22. 六月 2016 14:22
%%%-------------------------------------------------------------------
-module(instance_attack_city_lib).

-include("common.hrl").
-include("record.hrl").
-include("config.hrl").
-include("proto.hrl").
-include("log_type_config.hrl").
-include("cache.hrl").
-include("language_config.hrl").
-include("notice_config.hrl").
-include("button_tips_config.hrl").

-define(CITY_RANK_LIST, city_rank_list). %% 攻城排行列表
-define(MONSTER_ROUND, monster_round). %% 怪物存在的波数
-define(REFUSE_TIMES, 5). %% 刷新时间间隔(秒)
-define(SHOW_RANK_NUM, 5). %% 面板显示的排名数量
-define(TYPE_UI, 1). %% 面板类型
-define(TYPE_REWARD_WIN, 2). %% 奖励类型
-define(TYPE_REWARD_LOSE, 3). %% 奖励类型
-define(MONSTER_TYPE_1, 1). %% 怪物类型积分
-define(MONSTER_TYPE_2, 5). %% 怪物类型积分
-define(MONSTER_TYPE_3, 50). %% 怪物类型积分

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
	check_push_rank_info/1,
	delete_box_num/2
]).

%% 攻城活动
-record(city_rank_info, {
	player_id,
	lv,
	rank,
	name,
	score
}).

%% ====================================================================
%% API functions
%% ====================================================================
%% 初始化副本
init(SceneState, _PS) ->
	set_rank_list([]),
	SceneId = SceneState#scene_state.scene_id,
	SceneConf = scene_config:get(SceneId),
	RuleMonsterList = SceneConf#scene_conf.rule_monster_list,
	NextRefuseTime = get_next_refuse_time(2, RuleMonsterList),
	InstanceConf = instance_config:get(SceneId),

	MonsterList = SceneConf#scene_conf.monster_list,
	BossId = InstanceConf#instance_conf.boss_id,
	BossConf = monster_config:get(BossId),
	AttrBase = BossConf#monster_conf.attr_base,
	set_monster_id_and_round(MonsterList, 1, BossId),

	InstanceState = #instance_attack_city_state{
		round = 1, %% 当前怪物波数
		box_count = 0, %% 剩余宝箱数量
		next_refuse_time = NextRefuseTime, %% 下一波怪物刷新时间
		is_kill_boss = 0,
		boss_id = BossId,
		boss_hp = AttrBase#attr_base.hp,
		boss_harm = 0
	},

	gen_server2:apply_after(?REFUSE_TIMES * 1000, self(), {?MODULE, check_push_rank_info, []}),

	SceneState#scene_state{instance_state = InstanceState}.

%% 定时器
on_timer(SceneState) ->
	SceneState.

%% 玩家进入事件
on_obj_enter(SceneState, PlayerState) when is_record(PlayerState, player_state) ->
	%% 玩家进入推送排名信息
	update_player_score(PlayerState, 0),
	push_player_rank_info(SceneState, PlayerState#player_state.player_id, ?TYPE_UI),
	SceneState.

on_obj_harm(SceneState, TargetState, _CasterState, HarmValue) ->
	InstanceState = SceneState#scene_state.instance_state,
	BossId = InstanceState#instance_attack_city_state.boss_id,

	case TargetState#scene_obj_state.monster_id == BossId of
		true ->
			%% ?ERR("boss_harm AAA ~p", [HarmVanlue]),
			NewInstanceState = InstanceState#instance_attack_city_state{
				boss_harm = HarmValue + InstanceState#instance_attack_city_state.boss_harm
			},
			SceneState#scene_state{instance_state = NewInstanceState};
		false ->
			SceneState
	end.

%% 对象死亡事件
on_obj_die(SceneState, DieState, KillerState) ->
	InstanceState = SceneState#scene_state.instance_state,
	BossId = InstanceState#instance_attack_city_state.boss_id,

	SceneState1 =
	case DieState#scene_obj_state.monster_id == BossId of
		true ->
			%% boss死亡 结束定时器
			CurTime = util_date:unixtime(),
			NewInstanceState = InstanceState#instance_attack_city_state{next_refuse_time = 0, is_kill_boss = 1},
			SceneState#scene_state{instance_state = NewInstanceState, close_time = CurTime + 10};
		false when is_record(KillerState, scene_obj_state)->
			%% 给击杀玩家添加相应积分
			case DieState#scene_obj_state.obj_type == ?OBJ_TYPE_MONSTER andalso
				KillerState#scene_obj_state.obj_type == ?OBJ_TYPE_PLAYER of
				true ->
					MonsterId = DieState#scene_obj_state.monster_id,
					MonsterConf = monster_config:get(MonsterId),
					MonsterScore = get_monster_score(MonsterConf),
					update_player_score(KillerState, MonsterScore);
				false ->
					skip
			end,

			%% 宠物击杀给拥有者添加积分
			case DieState#scene_obj_state.obj_type == ?OBJ_TYPE_MONSTER andalso
				KillerState#scene_obj_state.obj_type == ?OBJ_TYPE_PET of
				true ->
					MonsterId1 = DieState#scene_obj_state.monster_id,
					MonsterConf1 = monster_config:get(MonsterId1),
					MonsterScore1 = get_monster_score(MonsterConf1),
					update_player_score(KillerState#scene_obj_state.owner_id, MonsterScore1);
				false ->
					skip
			end,

			SceneState;
		_ ->
			SceneState
	end,

	%% 刷新宝箱检测
	check_refuse_box(SceneState1, DieState).

%% 玩家退出副本事件
on_player_exit(SceneState, _ObjState, _LeaveType) ->
	SceneState.

%% 副本结束事件(副本结束不等同于副本关闭)，副本结束后不再计算通关条件，如果通关条件没有达成说明通关失败，如果已经达成说明通关成功
instance_end(SceneState) ->
	SceneState.

%% 副本关闭事件(一般情况下会将在副本里的玩家/宠物踢出副本，这里基类已经实现了这个功能，派生类只需要写自己的特殊逻辑处理)
instance_close(SceneState) ->
	%% 条件检测发放奖励
	InstanceState = SceneState#scene_state.instance_state,
	IsDie = InstanceState#instance_attack_city_state.is_kill_boss,
	case IsDie == 1 of
		true ->
			notice_lib:send_notice(0, ?NOTICE_MONSTER_ATK_LOSE, []),
			send_reward_mail(?TYPE_REWARD_LOSE);
		false ->
			MOL = scene_base_lib:do_get_scene_obj_list(SceneState, ?OBJ_TYPE_MONSTER),
			BossId = InstanceState#instance_attack_city_state.boss_id,
			case [X || X <- MOL, X#scene_obj_state.monster_id =/= BossId] of
				[] ->
					notice_lib:send_notice(0, ?NOTICE_MONSTER_ATK_WIN, []),
					send_reward_mail(?TYPE_REWARD_WIN);
				_ ->
					notice_lib:send_notice(0, ?NOTICE_MONSTER_ATK_LOSE, []),
					send_reward_mail(?TYPE_REWARD_LOSE)
			end
	end,

	%% 清除多人副本场景ets
	SceneId = SceneState#scene_state.scene_id,
	Key = {SceneId, ?WORLD_ACTIVE_SIGN},
	case ets:lookup(?ETS_SCENE_MAPS, Key) of
		[_EtsMaps] ->
			ets:delete(?ETS_SCENE_MAPS, Key);
		_ ->
			skip
	end,
	ets:delete(?ETS_SCENE, self()),

	%% 红点
	active_instance_lib:send_active_button_to_all_player_1(?BTN_ACTIVE_MAC),

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
	%% 检测刷怪
	NewSceneState = check_refuse_round_monster(SceneState),

	%% boss死亡不再刷新排行
	InstanceState = SceneState#scene_state.instance_state,
	IsDie = InstanceState#instance_attack_city_state.is_kill_boss,
	case IsDie == 1 of
		true ->
			skip;
		false ->
			gen_server2:apply_after(?REFUSE_TIMES * 1000, self(), {?MODULE, check_push_rank_info, []})
	end,

	{ok, NewSceneState}.

%% 定时刷新排行
refuse_rank() ->
	RankInfoList = [Y || {X, Y} <- get(), is_integer(X)],
	RankInfoList1 = lists:keysort(#city_rank_info.score, RankInfoList),

	Fun = fun(RankInfo, {List, Rank}) ->
		NewRankInfo = RankInfo#city_rank_info{rank = Rank},
		PlayerId = NewRankInfo#city_rank_info.player_id,
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

%% 推送信息给场景玩家
push_all_player_rank_info(SceneState) ->
	ObjList = scene_base_lib:do_get_scene_players(SceneState),
	Proto = get_proto_rank_list(),
	InstanceState = SceneState#scene_state.instance_state,
	Round = InstanceState#instance_attack_city_state.round,
	Box = InstanceState#instance_attack_city_state.box_count,
	Time =
		case InstanceState#instance_attack_city_state.next_refuse_time == 0 of
			true -> 0;
			false -> max(0, InstanceState#instance_attack_city_state.next_refuse_time - util_date:unixtime())
		end,

	Hp = InstanceState#instance_attack_city_state.boss_hp,
	CurHp = max(0, Hp - InstanceState#instance_attack_city_state.boss_harm),

	Fun = fun(ObjState) ->
		PlayerId = ObjState#scene_obj_state.obj_id,
		[PlayerRank, PlayerHarm] = get_player_rank_and_score(PlayerId),
		net_send:send_to_client(PlayerId, 11042,
			#rep_attack_city_instance_info
			{
				type = ?TYPE_UI,
				player_rank = PlayerRank,  %%  玩家自己排名
				player_score = PlayerHarm,  %%  玩家自己造成伤害
				rank_list = Proto,  %%  排名信息
				round = Round,
				box = Box,
				time = Time,
				boss_hp = Hp,
				boss_cur_hp = CurHp
			})
	end,
	[Fun(X) || X <- ObjList].

%% 推送给单个玩家
push_player_rank_info(SceneState, PlayerId, Type) ->
	Proto = get_proto_rank_list(),
	[PlayerRank, PlayerHarm] = get_player_rank_and_score(PlayerId),
	InstanceState = SceneState#scene_state.instance_state,
	Round = InstanceState#instance_attack_city_state.round,
	Box = InstanceState#instance_attack_city_state.box_count,
	Time =
		case InstanceState#instance_attack_city_state.next_refuse_time == 0 of
			true -> 0;
			false -> max(0, InstanceState#instance_attack_city_state.next_refuse_time - util_date:unixtime())
		end,

	Hp = InstanceState#instance_attack_city_state.boss_hp,
	CurHp = max(0, Hp - InstanceState#instance_attack_city_state.boss_harm),

	net_send:send_to_client(PlayerId, 11042,
		#rep_attack_city_instance_info
		{
			type = Type,
			player_rank = PlayerRank,  %%  玩家自己排名
			player_score = PlayerHarm,  %%  玩家自己造成伤害
			rank_list = Proto,  %% 排名信息
			round = Round,
			box = Box,
			time = Time,
			boss_cur_hp = CurHp,
			boss_hp = Hp
		}).

get_proto_rank_list() ->
	Fun = fun(RankInfo) ->
		#proto_attack_city_rank
		{
			rank = RankInfo#city_rank_info.rank,  %%  排名
			name = RankInfo#city_rank_info.name,  %%  名字
			score = RankInfo#city_rank_info.score  %%  积分
		}
	end,
	[Fun(X) || X <- get_rank_list()].

get_player_rank_and_score(PlayerId) ->
	case get(PlayerId) of
		#city_rank_info{} = RankInfo ->
			[
				RankInfo#city_rank_info.rank,  %%  排名
				RankInfo#city_rank_info.score  %%  积分
			];
		_ ->
			[0, 0]
	end.

%% 玩家攻击记录伤害
update_player_score(PlayerId, Score) when is_integer(PlayerId) ->
	case get(PlayerId) of
		#city_rank_info{} = RankInfo ->
			RankInfo1 = RankInfo#city_rank_info
			{
				score = RankInfo#city_rank_info.score + Score
			},
			put(PlayerId, RankInfo1);
		_ ->
			skip
	end;
update_player_score(PlayerState, Score) when is_record(PlayerState, player_state) ->
	PlayerId = PlayerState#player_state.player_id,
	case get(PlayerId) of
		#city_rank_info{} = RankInfo ->
			RankInfo1 = RankInfo#city_rank_info
			{
				score = RankInfo#city_rank_info.score + Score
			},
			put(PlayerId, RankInfo1);
		_ ->
			DPB = PlayerState#player_state.db_player_base,
			Lv = DPB#db_player_base.lv,
			Name = DPB#db_player_base.name,
			RankInfo = #city_rank_info
			{
				player_id = PlayerId,
				lv = Lv,
				rank = 0,
				name = Name,
				score = Score
			},
			put(PlayerId, RankInfo)
	end;
update_player_score(CasterState, Score) ->
	PlayerId = CasterState#scene_obj_state.obj_id,
	case get(PlayerId) of
		#city_rank_info{} = RankInfo ->
			RankInfo1 = RankInfo#city_rank_info
			{
				score = RankInfo#city_rank_info.score + Score
			},
			put(PlayerId, RankInfo1);
		_ ->
			Lv = CasterState#scene_obj_state.lv,
			Name = CasterState#scene_obj_state.name,
			RankInfo = #city_rank_info
			{
				player_id = PlayerId,
				lv = Lv,
				rank = 0,
				name = Name,
				score = Score
			},
			put(PlayerId, RankInfo)
	end.

%% 删除宝箱数量
delete_box_num(SceneState, BoxNum) ->
	case SceneState#scene_state.instance_state of
		#instance_attack_city_state{} = InstanceState ->
			NewInstanceState = InstanceState#instance_attack_city_state{
				box_count = InstanceState#instance_attack_city_state.box_count - BoxNum
			},
			SceneState#scene_state{instance_state = NewInstanceState};
		_ ->
			SceneState
	end.

%% ====================================================================
%% 刷怪分隔
%% ====================================================================

%% 刷新怪物
check_refuse_round_monster(SceneState) ->
	InstanceState = SceneState#scene_state.instance_state,
	NextRefuseTime = InstanceState#instance_attack_city_state.next_refuse_time,
	NowTime = util_date:unixtime(),
	%% ?ERR("check_monster_refuse AAA ~p,~p", [NowTime, NextRefuseTime]),
	case InstanceState#instance_attack_city_state.is_kill_boss == 0
		andalso NowTime >= NextRefuseTime andalso NextRefuseTime =/= 0 of
		true ->
			SceneId = SceneState#scene_state.scene_id,
			SceneConf = scene_config:get(SceneId),
			RuleMonsterList = SceneConf#scene_conf.rule_monster_list,
			Round = InstanceState#instance_attack_city_state.round,

			case lists:keyfind(Round + 1, 2, RuleMonsterList) of
				{_, _, MonsterList} ->
					F = fun(RuleInfo, Acc) ->
						scene_obj_lib:create_area_monster(Acc, RuleInfo)
					end,
					SceneState1 = lists:foldl(F, SceneState, MonsterList),
					%% ?ERR("create_monster_round AAA ~p", [Round]),

					BossId = InstanceState#instance_attack_city_state.boss_id,
					set_monster_id_and_round(MonsterList, Round + 1, BossId),

					NewInstanceState = InstanceState#instance_attack_city_state{
						round = Round + 1, %% 当前怪物波数
						next_refuse_time = get_next_refuse_time(Round + 2, RuleMonsterList) %% 下一波怪物刷新时间
					},

					notice_lib:send_notice(0, ?NOTICE_MONSTER_ATK_REFUSE, [Round + 1]),
					SceneState1#scene_state{instance_state = NewInstanceState};
				_ ->
					%% ?ERR("create_monster_round DDD ~p", [Round]),
					SceneState
			end;
		false ->
			SceneState
	end.

get_next_refuse_time(Round, RuleMonsterList) ->
	case lists:keyfind(Round, 2, RuleMonsterList) of
		{Time, _Round, _MonsterList} ->
			Time + util_date:unixtime();
		_ ->
			%% ?ERR("create_monster_round 222 ~p", [2]),
			0
	end.

get_monster_score(MonsterConf) ->
	case MonsterConf#monster_conf.type of
		1 ->
			?MONSTER_TYPE_1;
		2 ->
			?MONSTER_TYPE_2;
		_ ->
			?MONSTER_TYPE_3
	end.

check_refuse_box(SceneState, DieState) ->
	InstanceState = SceneState#scene_state.instance_state,
	BossId = InstanceState#instance_attack_city_state.boss_id,

	case DieState#scene_obj_state.monster_id =/= BossId andalso
		DieState#scene_obj_state.obj_type == ?OBJ_TYPE_MONSTER of
		true ->
			MonsterId = DieState#scene_obj_state.monster_id,
			%% io:format("round is:~p,~p,~p~n", [MonsterId, get_monster_round(MonsterId), get_round_monster_num(get_monster_round(MonsterId))]),
			Round = get_monster_round(MonsterId),
			RoundNum = get_round_monster_num(Round),
			NewSceneState =
			case RoundNum - 1 == 0 of
				true ->
					SceneId = SceneState#scene_state.scene_id,
					SceneConf = scene_config:get(SceneId),
					RuleMonsterList = SceneConf#scene_conf.rule_monster_list,
					Round1 = InstanceState#instance_attack_city_state.round,
					%% 刷新宝箱
					case lists:keyfind(Round1 + 100, 2, RuleMonsterList) of
						{_, _, MonsterList} ->
							F = fun(RuleInfo, Acc) ->
								scene_obj_lib:create_area_monster(Acc, RuleInfo)
							end,
							SceneState1 = lists:foldl(F, SceneState, MonsterList),
							%% ?ERR("create_box_round BBB ~p", [Round]),

							F1 = fun(Info, N) ->
								case Info of
									{collect_type, _MonsterId, Num, _, _} ->
										N + Num;
									_ ->
										N
								end
							end,
							Count = lists:foldl(F1, 0, MonsterList),

							NewInstanceState = InstanceState#instance_attack_city_state{
								box_count = InstanceState#instance_attack_city_state.box_count + Count
							},

							notice_lib:send_notice(0, ?NOTICE_MONSTER_ATK_REFUSE_BOX, [Round]),
							SceneState1#scene_state{instance_state = NewInstanceState};
						_ ->
							SceneState
					end;
				false ->
					SceneState
			end,
			put_round_monster_num(Round, RoundNum - 1),

			NewSceneState;
		false ->
			SceneState
	end.

%% 发放结束邮件
send_reward_mail(Type) ->
	RankInfoList = [Y || {X, Y} <- get(), is_integer(X)],
	RankInfoList1 = lists:keysort(#city_rank_info.score, RankInfoList),
	Proto = get_proto_rank_list(),

	Fun = fun(RankInfo, Rank) ->
		PlayerId = RankInfo#city_rank_info.player_id,
		Lv = RankInfo#city_rank_info.lv,
		[PlayerRank, PlayerHarm] = get_player_rank_and_score(PlayerId),
		net_send:send_to_client(PlayerId, 11042,
			#rep_attack_city_instance_info
			{
				type = Type,
				player_rank = PlayerRank,  %%  玩家自己排名
				player_score = PlayerHarm,  %%  玩家自己造成伤害
				rank_list = Proto  %%  排名信息
			}),

		PlayerId = RankInfo#city_rank_info.player_id,
		MailId = get_reward(Rank, Lv, Type),
		mail_lib:send_mail_to_player(PlayerId, MailId),
		Rank + 1
	end,
	lists:foldr(Fun, 1, RankInfoList1).

%% 获取排名奖励
get_reward(Rank, _Lv, Type) ->
	List = monster_attack_reward_config:get_list_conf(),
	get_rank_reward(Rank, List, Type).
get_rank_reward(_Rank, [], _Type) ->
	0;
get_rank_reward(Rank, [Conf|T], Type) ->
	case Rank >= Conf#monster_attack_reward_conf.min_rank andalso Rank =< Conf#monster_attack_reward_conf.max_rank of
		true ->
			case Type of
				?TYPE_REWARD_WIN ->
					Conf#monster_attack_reward_conf.win_mail_id;
				?TYPE_REWARD_LOSE ->
					Conf#monster_attack_reward_conf.lose_mail_id
			end;
		false ->
			get_rank_reward(Rank, T, Type)
	end.

%% ====================================================================
%% 内部字典
%% ====================================================================

%% 刷新排行榜 暂时记录前5名
set_rank_list(RankList) ->
	put(?CITY_RANK_LIST, RankList).

%% 获取排行榜 暂时记录前5名
get_rank_list() ->
	get(?CITY_RANK_LIST).

%% 设定怪物id存在的波数
set_monster_id_and_round(MonsterList, Round, BossId) ->
%% 	SceneConf = scene_config:get(SceneId),
%% 	MonsterList = SceneConf#scene_conf.monster_list,
	F = fun(Info, {L, N}) ->
		case Info of
			{monster_type, MonsterId, Num, _, _} ->
				case MonsterId == BossId of
					true -> {L, N};
					false -> {[{MonsterId, Round}] ++ L, N + Num}
				end;
			{area_type, _, MonsterId, Num, _, _} ->
				case MonsterId == BossId of
					true -> {L, N};
					false -> {[{MonsterId, Round}] ++ L, N + Num}
				end;
			_ ->
				{L, N}
		end
	end,
	{SMList, AllNum} = lists:foldl(F, {[],  0}, MonsterList),

	MonsterRound =
		case get_monster_id_and_round() of
			undefined -> [];
			List -> List
		end,

	NewMonsterRound = SMList ++ MonsterRound,

	NewAllNum = case Round == 1 of true -> AllNum - 1; false -> AllNum end,

	put_round_monster_num(Round, NewAllNum),
	put(?MONSTER_ROUND, NewMonsterRound).

get_monster_id_and_round() ->
	get(?MONSTER_ROUND).

put_round_monster_num(Round, Num) ->
	Key = "atk_city_round" ++ util_data:to_list(Round),
	put(Key, Num).

get_round_monster_num(Round) ->
	Key = "atk_city_round" ++ util_data:to_list(Round),
	get(Key).

get_monster_round(MonsterId) ->
	List = get_monster_id_and_round(),
	case lists:keyfind(MonsterId, 1, List) of
		{_, Round} ->
			Round;
		_ ->
			0
	end.