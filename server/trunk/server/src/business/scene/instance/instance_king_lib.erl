%%%-------------------------------------------------------------------
%%% @author qhb
%%% @copyright (C) 2016, <COMPANY>
%%% @doc
%%%	王城乱斗
%%% @end
%%% Created : 22. 十一月 2016 上午10:16
%%%-------------------------------------------------------------------
-module(instance_king_lib).
-author("qhb").

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
	check_push_rank_info/1,
	push_player_rank/1
]).

%% GEN API
-export([
	push_player_rank_local/2
]).

-define(KING_RANK_LIST, king_rank_list). %% 王城乱斗排行列表
-define(REFRESH_TIME, 5). %% 刷新时间间隔(秒)
-define(SHOW_RANK_NUM, 10). %% 面板显示的排名数量
-define(ROUND_TIME, 60 * 2).	%%每一场游戏的时间

%% 王城乱斗活动
-record(king_rank_info, {
	player_id,
	lv,
	name,
	career,
	score,
	rank,
	harm_list,
	group = 0,
	flag_in = 0
}).

%% ====================================================================
%% API functions
%% ====================================================================
%% 初始化副本
init(SceneState, _PS) ->
	%% erlang:erase(),
	set_rank_list([]),
	%%SceneId = SceneState#scene_state.scene_id,
	%%InstanceConf = instance_config:get(SceneId),

	InstanceState = #instance_king_state{
		next_round_time = util_date:unixtime() + ?ROUND_TIME
	},

	gen_server2:apply_after(?REFRESH_TIME * 1000, self(), {?MODULE, check_push_rank_info, []}),

	SceneState#scene_state{instance_state = InstanceState}.

%% 派生的定时器
on_timer(SceneState) ->
	SceneState.

%% 玩家进入事件
on_obj_enter(SceneState, PlayerState) when is_record(PlayerState, player_state) ->
	log_instance:on_player_enter(SceneState, PlayerState),
	{ok, SceneState1} = init_payer_info(SceneState, PlayerState),
	?WARNING("king enter",[]),
%% 	PlayerId = PlayerState#player_state.player_id,
%% 	case scene_base_lib:get_scene_obj_state(SceneState1, ?OBJ_TYPE_PLAYER, PlayerId) of
%% 		#scene_obj_state{} = ObjState ->
%% 			SceneId = SceneState#scene_state.scene_id,
%% 			SceneConf = scene_config:get(SceneId),
%% 			Pos =
%% 				case ObjState#scene_obj_state.group =:= 1 of
%% 					true -> 1;
%% 					false -> 2
%% 				end,
%% 			{{BX, BY}, {EX, EY}} = lists:nth(Pos, SceneConf#scene_conf.birth_area),
%% 			Point = {util_rand:rand(BX, EX), util_rand:rand(BY, EY)},
%% 			?WARNING("king point ~p ~p",[Pos, Point]),
%% 			scene_obj_lib:instant_move(self(), ?OBJ_TYPE_PLAYER, PlayerId, Point, ?DIRECTION_UP);
%% 		_ ->
%% 			skip
%% 	end,
	%% 玩家进入推送排名信息
	push_player_rank_info(PlayerState#player_state.player_id, null),
	SceneState1.

%% 对象受伤事件
on_obj_harm(SceneState, TargetState, CasterState, HarmValue) ->
	?WARNING("king harm",[]),
	%%InstanceState = SceneState#scene_state.instance_state,

	case is_record(TargetState, scene_obj_state) andalso  is_record(CasterState, scene_obj_state)of
		true ->
			case TargetState#scene_obj_state.obj_type == ?OBJ_TYPE_PLAYER andalso
				CasterState#scene_obj_state.obj_type == ?OBJ_TYPE_PLAYER of
				true ->
					update_player_harm(TargetState, CasterState, HarmValue);
				false ->
					skip
			end;
		false ->
			skip
	end,

	SceneState.

%% 对象死亡事件
on_obj_die(SceneState, DieState, KillerState) ->
	?WARNING("king die",[]),
	case is_record(DieState, scene_obj_state) andalso  is_record(KillerState, scene_obj_state)of
		true ->
			case DieState#scene_obj_state.obj_type == ?OBJ_TYPE_PLAYER andalso
				KillerState#scene_obj_state.obj_type == ?OBJ_TYPE_PLAYER of
				true ->
					update_score(DieState, KillerState);
				false ->
					skip
			end;
		false ->
			skip
	end,
	SceneState.

%% 玩家退出事件
on_player_exit(SceneState, ObjState, _LeaveType) ->
	?WARNING("king exit",[]),
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
	case get(score_need_send) =/= undefined of
		true ->
			erase(score_need_send),
			push_all_player_rank_info(SceneState);
		false ->
			skip
	end,

	%% boss死亡不再刷新排行
	InstanceState = SceneState#scene_state.instance_state,
	NextRoundTime = InstanceState#instance_king_state.next_round_time,
	Time = util_date:unixtime(),
	?WARNING("time left ~p",[NextRoundTime - Time]),
	{ok, SceneState1} =
		case Time > NextRoundTime of
			true ->
				%%新的场次,敌我关系变换,
				erase(round_notice),
				change_group(SceneState);
			false ->
				%%提前10S左右公告
				case NextRoundTime - Time < 10 andalso get(round_notice) =:= undefined of
					true ->
						?WARNING("round time ~p ~p",[NextRoundTime, Time]),
						put(round_notice, true),
						send_round_time(SceneState);
					false ->
						skip
				end,
				{ok, SceneState}
		end,
	gen_server2:apply_after(?REFRESH_TIME * 1000, self(), {?MODULE, check_push_rank_info, []}),

	{ok, SceneState1}.

%% 推送信息给场景玩家
push_all_player_rank_info(SceneState) ->
	ObjList = scene_base_lib:do_get_scene_players(SceneState),
	Proto = pack_proto_rank_list(),
	Fun = fun(ObjState) ->
		PlayerId = ObjState#scene_obj_state.obj_id,
		[PlayerRank, PlayerScore] = get_player_rank_and_score(PlayerId),
		net_send:send_to_client(PlayerId, 11057,
			#rep_instance_king_info
			{
				player_rank = PlayerRank,  %%  玩家自己排名
				player_score = PlayerScore,  %%  玩家自己的分数
				rank_list = lists:reverse(Proto)  %%  排名信息
			})
	end,
	[Fun(X) || X <- ObjList].

push_player_rank(PlayerState) ->
	#player_state{server_pass = _ServerPass,
		db_player_base = #db_player_base{player_id = PlayerId, scene_id = SceneId}} = PlayerState,
	case scene_config:get(SceneId) of
		#scene_conf{is_cross = 1} ->
			gen_server2:apply_async(PlayerState#player_state.scene_pid, {?MODULE, push_player_rank_local,
				[PlayerId]});
		_ ->
			Rep = #rep_instance_king_info{player_rank = 0, player_score = 0, rank_list = []},
			net_send:send_to_client(PlayerId, 11057, Rep)
	end.
push_player_rank_local(State, PlayerId) ->
	push_player_rank_info(PlayerId, null),
	{ok, State}.

%% 推送给单个玩家
push_player_rank_info(PlayerId, _Type) ->
	Proto = pack_proto_rank_list(),
	[PlayerRank, PlayerScore] = get_player_rank_and_score(PlayerId),
	net_send:send_to_client(PlayerId, 11057,
		#rep_instance_king_info
		{
			player_rank = PlayerRank,  %%  玩家自己排名
			player_score = PlayerScore,  %%  玩家自己的分数
			rank_list = lists:reverse(Proto)  %%  排名信息
		}).

%%敌我关系变化10S倒计时
send_round_time(SceneState) ->
	ObjList = scene_base_lib:do_get_scene_players(SceneState),
	Fun = fun(ObjState) ->
		PlayerId = ObjState#scene_obj_state.obj_id,
		net_send:send_to_client(PlayerId, 11056,#rep_instance_king_round_time_left{time_left = 10})
	end,
	[Fun(X) || X <- ObjList].

%% 定时刷新排行
refuse_rank() ->
	RankInfoList = [Y || {X, Y} <- get(), is_integer(X)],
	RankInfoList1 = lists:keysort(#king_rank_info.score, RankInfoList),

	Fun = fun(RankInfo, {List, Rank}) ->
		NewRankInfo = RankInfo#king_rank_info{rank = Rank},
		PlayerId = NewRankInfo#king_rank_info.player_id,
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

%%进入时初始化玩家信息
init_payer_info(SceneState, PlayerState) ->
	PlayerId = PlayerState#player_state.player_id,
	Group =
		case get(PlayerId) of
			#king_rank_info{group = OldGroup, rank = Rank} = RankInfo ->
				%%如group为0则是没有分组,玩家前一次进入后又进行一轮游戏
				NewGroup = case OldGroup =:= 0 of
							   true -> (Rank - 1) rem 2 + 1;
							   false -> OldGroup
						   end,
				NewRankInfo = RankInfo#king_rank_info{group = NewGroup, flag_in = true},
				put(PlayerId, NewRankInfo),
				NewGroup;
			_ ->
				%%新进入玩家,以排名奇偶来分组
				RankInfoList = [Y || {X, Y} <- get(), is_integer(X)],
				Rank = length(RankInfoList) + 1,
				#player_state{db_player_base = #db_player_base{lv = Lv, name = Name, career = Career}} = PlayerState,
				Group1 = (Rank - 1) rem 2 + 1,
				RankInfo = #king_rank_info
				{
					player_id = PlayerId,
					lv = Lv,
					name = Name,
					career = Career,
					score = 0,
					rank = Rank,
					harm_list = [],
					group = Group1,
					flag_in = true
				},
				put(PlayerId, RankInfo),
				Group1
		end,
	?WARNING("init Group ~p ~p",[PlayerId, Group]),
	change_state_group(SceneState, dict:from_list([{PlayerId, Group}])).

%% 玩家助攻的伤害记录
update_player_harm(TargetState, CasterState, HarmValue) ->
	PlayerId = TargetState#scene_obj_state.obj_id,
	PlayerIdCaster = CasterState#scene_obj_state.obj_id,
	case get(PlayerId) of
		#king_rank_info{} = RankInfo ->
			HarmList = RankInfo#king_rank_info.harm_list,
			NewHarmList =
				case lists:keyfind(PlayerIdCaster, 1, HarmList) of
					false ->
						[{PlayerIdCaster, HarmValue} | HarmList];
					{PlayerIdCaster, OldHarmValue} ->
						lists:keyreplace(PlayerIdCaster, 1, HarmList, {PlayerIdCaster, OldHarmValue + HarmValue})

				end,
			RankInfo1 = RankInfo#king_rank_info
			{
				harm_list = NewHarmList
			},
			put(PlayerId, RankInfo1);
		_ ->
			Lv = CasterState#scene_obj_state.lv,
			Name = CasterState#scene_obj_state.name,
			RankInfo = #king_rank_info
			{
				player_id = PlayerId,
				lv = Lv,
				rank = 0,
				name = Name,
				score = 0,
				harm_list = [{PlayerIdCaster, HarmValue}]
			},
			put(PlayerId, RankInfo)
	end.

%%击杀玩家后,计算主攻及助攻的分数
update_score(TargetState, KillerState) ->
	put(score_need_send, true),
	PlayerId = TargetState#scene_obj_state.obj_id,
	PlayerIdKiller = KillerState#scene_obj_state.obj_id,
	case get(PlayerId) of
		#king_rank_info{harm_list = HarmList, rank = Rank} ->
			PlayerIdCasterList = [T1 || {T1, _} <- HarmList, T1 =/= PlayerIdKiller],
			lists:foreach(fun(T1) -> update_player_score(T1, 1) end, PlayerIdCasterList),
			Score = if
						Rank > 10 -> 3;
						Rank > 3 -> 6;
						true -> 10
					end,
			update_player_score(PlayerIdKiller, Score);
		_ ->
			?WARNING("not record ~p",[PlayerId])
	end.

%%更新玩家的分数
update_player_score(PlayerId, Score) ->
	case get(PlayerId) of
		#king_rank_info{} = RankInfo ->
			RankInfo1 = RankInfo#king_rank_info
			{
				score = RankInfo#king_rank_info.score + Score
			},
			put(PlayerId, RankInfo1);
		_ ->
			?WARNING("not record2 ~p",[PlayerId])
	end.

%%重新分组
change_group(SceneState) ->
	InstanceState = #instance_king_state{
		next_round_time = util_date:unixtime() + ?ROUND_TIME
	},
	SceneState1 = SceneState#scene_state{instance_state = InstanceState},

	SceneId = SceneState#scene_state.scene_id,
	SceneConf = scene_config:get(SceneId),

	RankInfoList = [Y || {X, Y} <- get(), is_integer(X)],
	RankKVList =
		lists:foldl(fun(RankInfo, Acc) ->
			#king_rank_info{player_id = PlayerId, rank = Rank, flag_in = FlagIn} = RankInfo,
			Group =
				case FlagIn of
					true -> (Rank - 1) rem 2 + 1;
					false -> 0
				end,
			put(PlayerId, RankInfo#king_rank_info{group = Group}),

			{{BX, BY}, {EX, EY}} = lists:nth(Group, SceneConf#scene_conf.birth_area),
			Point = {util_rand:rand(BX, EX), util_rand:rand(BY, EY)},
			?WARNING("king point ~p ~p", [Group, Point]),
			scene_obj_lib:instant_move(self(), ?OBJ_TYPE_PLAYER, PlayerId, Point, ?DIRECTION_UP),

			[{PlayerId, Group} | Acc]
		end, [], RankInfoList),
	change_state_group(SceneState1, dict:from_list(RankKVList)).

change_state_group(SceneState, PlayerGroupDict) ->
	StateList =
		case dict:find(?OBJ_TYPE_PLAYER, SceneState#scene_state.obj_dict) of
			{ok, TypeObjDict} ->
				dict:fold(fun(_K, ObjState, Acc) ->
					#scene_obj_state{obj_id = ObjId} = ObjState,
					case dict:find(ObjId, PlayerGroupDict) of
						{ok, Value} ->
							?WARNING("update group ~p ~p",[ObjId, Value]),
							[ObjState#scene_obj_state{group = Value} | Acc];
						_ ->
							Acc
					end
				end, [], TypeObjDict);
			_ ->
				[]
		end,
		lists:foldl(fun(ObjState, _AccSceneState) ->
			%%NewSceneState = scene_base_lib:store_scene_obj_state(AccSceneState, ObjState),
			%%scene_send_lib:send_screen_player_update(SceneState, ObjState, ObjState, true),
			scene_obj_lib:update_obj(self(), ?OBJ_TYPE_PLAYER, ObjState#scene_obj_state.obj_id, ObjState, true)
		end, SceneState, StateList),
	{ok, SceneState}.

pack_proto_rank_list() ->
	Fun = fun(RankInfo) ->
		#proto_instance_king_rank
		{
			rank = RankInfo#king_rank_info.rank,  %%  排名
			name = RankInfo#king_rank_info.name,  %%  名字
			score = RankInfo#king_rank_info.score  %% 分数
		}
	end,
	[Fun(X) || X <- get_rank_list()].

pack_proto_rank_list_full() ->
	Fun = fun(RankInfo) ->
		#proto_instance_king_rank_full
		{
			rank = RankInfo#king_rank_info.rank,  %%  排名
			name = RankInfo#king_rank_info.name,  %%  名字
			lv = RankInfo#king_rank_info.lv,		%%排名
			career = RankInfo#king_rank_info.career,%%职业
			score = RankInfo#king_rank_info.score  %% 分数
		}
	end,
	[Fun(X) || X <- get_rank_list()].

get_player_rank_and_score(PlayerId) ->
	case get(PlayerId) of
		#king_rank_info{} = RankInfo ->
			[
				RankInfo#king_rank_info.rank,  %%  排名
				RankInfo#king_rank_info.score  %%  造成伤害
			];
		_ ->
			[0, 0]
	end.

%% 发放邮件
send_reward_mail() ->
	RankInfoList = [Y || {X, Y} <- get(), is_integer(X)],
	RankInfoList1 = lists:keysort(#king_rank_info.score, RankInfoList),
	Proto = pack_proto_rank_list_full(),

	Fun = fun(RankInfo, Rank) ->
		#king_rank_info{player_id = PlayerId, score = PlayerScore} = RankInfo,
		Rep1 = #rep_instance_king_info{player_rank = Rank, player_score = PlayerScore,rank_list = Proto},
		net_send:send_to_client(PlayerId, 11058, Rep1),

		if
			Rank =< 3 ->
				MailIdBase = 107,
				#mail_conf{title = Title, content = Content, award = Award} = mail_config:get(MailIdBase + Rank),
				Title2 = re:replace(Title, "", "", [global, {return, list}]),
				Content2 = re:replace(Content, "", "", [global, {return, list}]),
				mail_lib:send_mail_to_player(PlayerId, xmerl_ucs:to_utf8("系统"), Title2, Content2, Award);
			Rank =< 10 ->
				#mail_conf{title = Title, content = ContentTpl1, award = Award} = mail_config:get(111),
				Title2 = re:replace(Title, "", "", [global, {return, list}]),
				ContentTpl2 = re:replace(ContentTpl1, "%s", "~s", [global, {return, list}]),
				Content2 = io_lib:format(ContentTpl2, [Rank]),
				mail_lib:send_mail_to_player(PlayerId, xmerl_ucs:to_utf8("系统"), Title2, Content2, Award);
			true ->
				#mail_conf{title = Title, content = Content, award = Award} = mail_config:get(112),
				Title2 = re:replace(Title, "", "", [global, {return, list}]),
				Content2 = re:replace(Content, "", "", [global, {return, list}]),
				mail_lib:send_mail_to_player(PlayerId, xmerl_ucs:to_utf8("系统"), Title2, Content2, Award)
		end,

		Rank + 1
	end,
	lists:foldr(Fun, 1, RankInfoList1).

%% ====================================================================
%% 内部字典
%% ====================================================================

%% 刷新排行榜 暂时记录前5名
set_rank_list(RankList) ->
	put(?KING_RANK_LIST, RankList).

%% 获取排行榜 暂时记录前5名
get_rank_list() ->
	get(?KING_RANK_LIST).
