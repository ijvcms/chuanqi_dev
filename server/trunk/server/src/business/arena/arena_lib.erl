%%%-------------------------------------------------------------------
%%% @author tuhujia
%%% @copyright (C) 2015, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 25. 八月 2015 14:42
%%%-------------------------------------------------------------------
-module(arena_lib).

-include("common.hrl").
-include("record.hrl").
-include("proto.hrl").
-include("cache.hrl").
-include("db_record.hrl").
-include("config.hrl").
-include("uid.hrl").
-include("language_config.hrl").
-include("button_tips_config.hrl").
-include("log_type_config.hrl").

%% API
-export([
	init_arena_rank/0,
	init_rank/0,
	add_player_to_arena_rank/3,
	add_player_arena_reputation/3,
	change_player_arena_rank/2,
	challenge_arena_player/2,
	challenge_win/2,
	challenge_lose/2,
	reduce_player_arena_reputation/3,
	refuse_match_arena_info/1,
	get_player_arena_rank/1,
	get_match_arena_info/1,
	get_rank_list_before_twenty/1,
	get_player_challenge_record/1,
	get_match_arena_list/1,
	get_player_arena_reputation/1,
	get_challenge_count/1,
	get_button_tips/1,
	update_arena_record/3,
	pack_to_proto_arena_challenge_info/1,
	pack_to_proto_arena_rank_info/1,
	pack_to_proto_arena_record/1,
	get_arena_num/1,
	check_uniform_service/1
]).

%% 加入所需要等级
-define(JOIN_LV, 1).
%% 胜利与失败奖励
-define(WIN_REWARD, [{110009, ?BIND, 10000},{110059, ?BIND, 10}]).
-define(LOSE_REWARD, [{110009, ?BIND, 5000},{110059, ?BIND, 5}]).

%% ====================================================================
%% API functions
%% ====================================================================

%% 获取竞技场 排位赛的总次数
get_arena_num(PlayerState)->
	Base=PlayerState#player_state.db_player_base,
	%% 获取vip增加次数
	VipCount=vip_lib:get_vip_rank_num(Base#db_player_base.career,Base#db_player_base.vip),
	?LIMIT_CHALLENGE_COUNT+VipCount.


%% 初始化竞技场排名
init_arena_rank() ->
	arena_mod:start_link().

init_rank() ->
	case arena_rank_cache:select_all() of
		[] ->
			Rank = 0,
			Rank;
		List ->
			Fun = fun(ArenaInfo, Acc) ->
					Rank = ArenaInfo#db_arena_rank.rank,
					arena_mod:arena_cast({update_arena_rank_info, ArenaInfo}),
					arena_rank_cache:save_arena_info_to_ets(ArenaInfo),
					max(Acc, Rank)
				  end,
			Rank = lists:foldl(Fun, 1, List),
			Rank
	end.

%% 玩家升到25级触发加入排行事件
add_player_to_arena_rank(State, OldLv, NewLv) ->
	case OldLv < 25 andalso NewLv >= 25 of
		true ->
			case arena_rank_cache:get_arena_info_from_ets(State#player_state.player_id) of
				[] ->
					arena_mod:arena_cast({add_player_to_arena_rank, State});
				_ ->
					skip
			end;
		false ->
			skip
	end.

%% 合服检测
check_uniform_service(State) ->
	case config:get_merge_servers() of
		[] -> skip;
		_ ->
			case arena_rank_cache:get_arena_info_from_ets(State#player_state.player_id) of
				[] ->
					arena_mod:arena_cast({add_player_to_arena_rank, State});
				_ ->
					skip
			end
	end.

%% 更换玩家排名(A挑战者／B被挑战者)
change_player_arena_rank(ArenaInfoA, ArenaInfoB) ->
	arena_mod:arena_cast({change_player_arena_rank, ArenaInfoA, ArenaInfoB}).

%% 推送排行榜前20名玩家
get_rank_list_before_twenty(Socket) ->
	arena_mod:arena_cast({push_rank, Socket}).

%% 获取竞技场匹配列表
get_match_arena_info(State) ->
	PlayerId = State#player_state.player_id,
	DbBase = State#player_state.db_player_base,
	Lv = DbBase#db_player_base.lv,
	Socket = State#player_state.socket,
	case Lv < ?JOIN_LV of
		true ->
			net_send:send_to_client(Socket, 23003, #rep_arena_challenge_list{list = []});
		false ->
			ArenaR = arena_record_cache:get_arena_record(PlayerId),
			MatchList = ArenaR#db_arena_record.match_list,
			case MatchList == [] of
				true ->
					Rank = get_player_arena_rank(State),
					MatchList1 = get_match_arena_list(Rank),
					arena_record_cache:update_match_list(PlayerId, MatchList1),
					arena_mod:arena_cast({broadcast_match_arena_info, MatchList1, Socket});
				false ->
					arena_mod:arena_cast({broadcast_match_arena_info, MatchList, Socket})
			end
	end.

refuse_match_arena_info(State) ->
	PlayerId = State#player_state.player_id,
	DbBase = State#player_state.db_player_base,
	Lv = DbBase#db_player_base.lv,
	Socket = State#player_state.socket,
	case Lv < ?JOIN_LV of
		true ->
			{fail, ?ERR_COMMON_FAIL};
		false ->
			Rank = get_player_arena_rank(State),
			MatchList1 = get_match_arena_list(Rank),
			arena_record_cache:update_match_list(PlayerId, MatchList1),
			arena_mod:arena_cast({broadcast_match_arena_info, MatchList1, Socket}),
			{ok, ?ERR_COMMON_SUCCESS}
	end.

%% 获取玩家挑战信息记录
get_player_challenge_record(State) ->
	PlayerId = State#player_state.player_id,
	ArenaR = arena_record_cache:get_arena_record(PlayerId),
	Proto = pack_to_proto_arena_record(ArenaR#db_arena_record.arena_list),
	Proto.

%% 刷新匹配列表
get_match_arena_list(Rank) when Rank == 0 ->
	Rank1 = util_rand:rand(util_math:floor(0.9 * ?MAX_ARENA_RANK), util_math:floor(0.99 * ?MAX_ARENA_RANK)),
	Rank2 = util_rand:rand(util_math:floor(0.76 * ?MAX_ARENA_RANK), util_math:floor(0.89 * ?MAX_ARENA_RANK)),
	Rank3 = util_rand:rand(util_math:floor(0.56 * ?MAX_ARENA_RANK), util_math:floor(0.75 * ?MAX_ARENA_RANK)),
	Rank4 = util_rand:rand(util_math:floor(0.45 * ?MAX_ARENA_RANK), util_math:floor(0.55 * ?MAX_ARENA_RANK)),
	get_match_arena_list_1([{Rank1}, {Rank2}, {Rank3}, {Rank4}]);
get_match_arena_list(Rank) ->
	case Rank =< 5 of
		true ->
			[{1}, {2}, {3}, {4}];
		false ->
			Rank1 = util_rand:rand(util_math:floor(0.9 * Rank), util_math:floor(0.99 * Rank)),
			Rank2 = util_rand:rand(util_math:floor(0.76 * Rank), util_math:floor(0.89 * Rank)),
			Rank3 = util_rand:rand(util_math:floor(0.56 * Rank), util_math:floor(0.75 * Rank)),
			Rank4 = util_rand:rand(util_math:floor(0.45 * Rank), util_math:floor(0.55 * Rank)),
			get_match_arena_list_1([{Rank1}, {Rank2}, {Rank3}, {Rank4}])
	end.

get_match_arena_list_1(List) ->
	Fun = fun(Rank, Acc) ->
		case lists:member(Rank, Acc) of
			true ->
				[{H}|_] = Acc,
				[{H - 1}] ++ Acc;
			false ->
				[Rank] ++ Acc
		end
	end,
	lists:foldl(Fun, [], List).

%% 获取声望
get_player_arena_reputation(PlayerState) ->
	PlayerId = PlayerState#player_state.player_id,
	case arena_record_cache:get_arena_record(PlayerId) of
		[] -> 0;
		R ->
			R#db_arena_record.reputation
	end.

%% 增加声望
add_player_arena_reputation(PlayerState, Reputation, LogType) ->
	PlayerId = PlayerState#player_state.player_id,
	R = arena_record_cache:get_arena_record(PlayerId),
	R1 = R#db_arena_record{reputation = R#db_arena_record.reputation + Reputation},
	arena_record_cache:save_arena_info_to_ets(R1),
	arena_record_cache:replace(R1),
	log_lib:log_reputation(PlayerState, Reputation ,LogType),
	net_send:send_to_client(PlayerState#player_state.socket, 23012, #rep_change_reputation{reputation = Reputation}),
	{ok, PlayerState}.

%% 扣除声望
reduce_player_arena_reputation(PlayerState, Reputation, LogType) ->
	PlayerId = PlayerState#player_state.player_id,
	case arena_record_cache:get_arena_record(PlayerId) of
		[] -> skip;
		R ->
			NewReputation = R#db_arena_record.reputation - Reputation,
			R1 = R#db_arena_record{reputation = NewReputation},
			arena_record_cache:save_arena_info_to_ets(R1),
			arena_record_cache:replace(R1),
			log_lib:log_reputation(PlayerState, -Reputation ,LogType),
			net_send:send_to_client(PlayerState#player_state.socket, 23012, #rep_change_reputation{reputation = -Reputation}),
			net_send:send_to_client(PlayerState#player_state.socket, 23007, #rep_get_arena_reputation{reputation = NewReputation})
	end.

%% 发起挑战
challenge_arena_player(PlayerState, PlayerIdB) ->
	case PlayerState#player_state.player_id =/= PlayerIdB of
		true ->
			%% 已经挑战次数
			HitCount=counter_lib:get_value(PlayerState#player_state.player_id, ?ARENA_CHALLENGE_LIMIT_COUNTER),
			LimitCount=get_arena_num(PlayerState),
			case LimitCount>HitCount of
				true ->
					case arena_rank_cache:get_arena_info_from_ets(PlayerIdB) of
						[] ->
							{fail, ?ERR_CHALL_NOT_EXIST};
						ArenaInfoB ->
							case scene_mgr_lib:change_scene(PlayerState#player_state{scene_parameters = ArenaInfoB}, self(), ?ARENA_INSTANCE_ID) of
								{ok, PlayerState2} ->
									counter_lib:update(PlayerState2#player_state.player_id, ?ARENA_CHALLENGE_LIMIT_COUNTER),

									%% 完成任务触发
									task_comply:update_player_task_info(PlayerState2, ?TASKSORT_ARENA, 1),
									operate_active_lib:update_limit_type(PlayerState2, ?OPERATE_ACTIVE_LIMIT_TYPE_8),

									{ok, PlayerState3} = button_tips_lib:ref_button_tips(PlayerState2, ?BTN_ARENA),
									{ok, PlayerState3};
								_ ->
									{ok, ?ERR_COMMON_SUCCESS}
							end
					end;
				false ->
					{fail, ?ERR_ARENA_CHALL_NOT_ENOUGH}
			end;
		false ->
			{fail, ?ERR_COMMON_FAIL}
	end.

%% 挑战成功
challenge_win(ArenaInfoA, ArenaInfoB) ->
	arena_mod:arena_cast({change_player_arena_rank, ArenaInfoA, ArenaInfoB}),
	update_arena_record(win, ArenaInfoA, ArenaInfoB),
	net_send:send_to_client(ArenaInfoA#db_arena_rank.player_id, 23011, #rep_arena_result{result = ?ERR_COMMON_SUCCESS,
		rank = get_min_rank(ArenaInfoA#db_arena_rank.rank, ArenaInfoB#db_arena_rank.rank), goods_list = pack_to_proto_arena_reward(?WIN_REWARD)}),
	gen_server2:cast(ArenaInfoA#db_arena_rank.player_id, {add_goods_list, ?WIN_REWARD,?LOG_TYPE_ARENA_WIN}).

%% 挑战失败
challenge_lose(ArenaInfoA, ArenaInfoB) ->
	update_arena_record(lose, ArenaInfoA, ArenaInfoB),
	net_send:send_to_client(ArenaInfoA#db_arena_rank.player_id, 23011, #rep_arena_result{result = ?ERR_COMMON_FAIL,
		rank = 0, goods_list = pack_to_proto_arena_reward(?LOSE_REWARD)}),
	gen_server2:cast(ArenaInfoA#db_arena_rank.player_id, {add_goods_list, ?LOSE_REWARD,?LOG_TYPE_ARENA_LOSS}).

%% 挑战完毕更新挑战记录(挑战者A 被挑战者B)
update_arena_record(win, ArenaInfoA, ArenaInfoB) ->
	Time = util_date:unixtime(),
	RecordA = {2, ArenaInfoA#db_arena_rank.player_id, ArenaInfoA#db_arena_rank.name, get_max_rank(ArenaInfoA#db_arena_rank.rank, ArenaInfoB#db_arena_rank.rank), Time},
	RecordB = {1, ArenaInfoB#db_arena_rank.player_id, ArenaInfoB#db_arena_rank.name, get_min_rank(ArenaInfoA#db_arena_rank.rank, ArenaInfoB#db_arena_rank.rank), Time},

	arena_record_cache:update_arena_record(ArenaInfoA#db_arena_rank.player_id, RecordB, get_match_arena_list(ArenaInfoB#db_arena_rank.rank)),
	arena_record_cache:update_arena_record(ArenaInfoB#db_arena_rank.player_id, RecordA, get_match_arena_list(ArenaInfoA#db_arena_rank.rank));

update_arena_record(lose, ArenaInfoA, ArenaInfoB) ->
	Time = util_date:unixtime(),
	RecordA = {4, ArenaInfoA#db_arena_rank.player_id, ArenaInfoA#db_arena_rank.name, 0, Time},
	RecordB = {3, ArenaInfoB#db_arena_rank.player_id, ArenaInfoB#db_arena_rank.name, 0, Time},

	arena_record_cache:update_arena_record(ArenaInfoA#db_arena_rank.player_id, RecordB),
	arena_record_cache:update_arena_record(ArenaInfoB#db_arena_rank.player_id, RecordA).

%% 获取竞技场排名
get_player_arena_rank(PlayerState) when is_record(PlayerState, player_state)->
	PlayerId = PlayerState#player_state.player_id,
	case arena_rank_cache:get_arena_info_from_ets(PlayerId) of
		[] -> 0;
		R ->
			R#db_arena_rank.rank
	end;
get_player_arena_rank(PlayerId) ->
	case arena_rank_cache:get_arena_info_from_ets(PlayerId) of
		[] -> 0;
		R ->
			R#db_arena_rank.rank
	end.

%% 获取挑战次数
get_challenge_count(PlayerState) ->
	PlayerId = PlayerState#player_state.player_id,
	arena_lib:get_arena_num(PlayerState) - counter_lib:get_value(PlayerId, ?ARENA_CHALLENGE_LIMIT_COUNTER).

get_button_tips(PlayerState) ->
	FunctionList = PlayerState#player_state.function_open_list,
	case lists:member(?FUNCTION_ID_ARENA, FunctionList) of
		true ->
			Count = get_challenge_count(PlayerState),
			{PlayerState, Count};
		false ->
			{PlayerState, 0}
	end.

%% 组包
pack_to_proto_arena_challenge_info(ArenaInfo) ->
	#proto_arena_challenge_info{
		player_id = ArenaInfo#db_arena_rank.player_id,
		name = ArenaInfo#db_arena_rank.name,
		career = ArenaInfo#db_arena_rank.career,
		sex = ArenaInfo#db_arena_rank.sex,
		fight = ArenaInfo#db_arena_rank.fighting,
		rank = ArenaInfo#db_arena_rank.rank
	}.

pack_to_proto_arena_rank_info(ArenaInfo) ->
	#proto_arena_rank_info{
		player_id = ArenaInfo#db_arena_rank.player_id,
		name = ArenaInfo#db_arena_rank.name,
		career = ArenaInfo#db_arena_rank.career,
		fight = ArenaInfo#db_arena_rank.fighting,
		lv = ArenaInfo#db_arena_rank.lv,
		guild_name = guild_lib:get_guild_name(ArenaInfo#db_arena_rank.guild_id),
		rank = ArenaInfo#db_arena_rank.rank
	}.

pack_to_proto_arena_record(RecordList) ->
	Fun = fun({Type, PlayerId, Name, Rank, Time}) ->
		#proto_arena_record{
			type = Type,
			player_id = PlayerId,
			name = Name,
			rank = Rank,
			time = Time
		}
	end,
	[Fun(X)||X <- RecordList].

pack_to_proto_arena_reward(GoodsList) ->
	Fun = fun({GoodsId, IsBind, Num}) ->
		#proto_goods_list{
			goods_id = GoodsId,
			is_bind = IsBind,
			num = Num
		}
	end,
	[Fun(X)||X <- GoodsList].

%% 获取较小的排名
get_min_rank(Rank1, Rank2) ->
	case Rank1 == 0 orelse Rank2 == 0 of
		true -> max(Rank1, Rank2);
		false -> min(Rank1, Rank2)
	end.

get_max_rank(Rank1, Rank2) ->
	case Rank1 == 0 orelse Rank2 == 0 of
		true -> 0;
		false -> max(Rank1, Rank2)
	end.

