%%%-------------------------------------------------------------------
%%% @author tuhujia
%%% @copyright (C) 2016, <COMPANY>
%%% @doc 排行榜
%%%
%%% @end
%%% Created : 07. 四月 2016 11:42
%%%-------------------------------------------------------------------
-module(rank_lib).

-include("common.hrl").
-include("rank.hrl").
-include("proto.hrl").
-include("cache.hrl").
-include("config.hrl").

-export([
	init_rank/0,
	init_single_rank/1,
	init_single_rank_active/1,
	get_rank_refuse_time/1,
	get_rank_list_data/2,
	get_rank_list_data/3,
	get_rank_list_data/4,
	get_rank_list/1,
	get_rank/3,
	get_rank_ets_by_active_type/1,
	get_rank_list_active_type/2,
	get_rank_list_active_merge_type/2
]).

%% ====================================================================
%% API functions
%% ====================================================================

%% 初始化排行榜
init_rank() ->
	[init_single_rank(RankFlag) || RankFlag <- ?ACTIVATE_RANKS].

%% 初始化排行 运营活动击杀排行特殊处理
init_single_rank({?ETS_OPERATE_TYPE_4, ActiveId, FinishType}) ->
	RankFlag = {?ETS_OPERATE_TYPE_4, ActiveId, FinishType},
	%% 开服时间检测
	StartTime = config:get_start_time(),
	CurTime = util_date:unixtime(),
	case CurTime >= StartTime of
		true ->
			case load_rank_info(RankFlag) of
				[] ->
					update_rank(RankFlag, [], CurTime),
					[];
				RankList ->
					%% 前三名特殊处理 获取玩家姓名
					R = get_max_rank(RankList),
					Fun = fun(List, {Rank, AllList}) ->
						[PlayerId, Score] = List,
						NewRank = Rank + 1,
						PlayerName = case NewRank =< ?MAX_RANK_OPERATE_PAGE_NUM of
										 true ->
											 %% 更新玩家名字
											 Base = player_base_cache:select_row(PlayerId),
											 Base#db_player_base.name;
										 false ->
											 <<>>
									 end,
						NewList = [PlayerId, PlayerName, Score, NewRank],
						List1 = list_to_tuple([?ETS_OPERATE_TYPE_4 | NewList]),
						{NewRank, [List1] ++ AllList}
					end,
					{_, RankLvList1} = lists:foldl(Fun, {R, []}, RankList),
					RankLvList2 = lists:reverse(RankLvList1),
					update_rank(RankFlag, RankLvList2, CurTime),
					RankLvList2
			end;
		false ->
			[]
	end;
init_single_rank(RankFlag) ->
	%% 开服时间检测
	StartTime = config:get_start_time(),
	CurTime = util_date:unixtime(),
	case CurTime >= StartTime of
		true ->
			case load_rank_info(RankFlag) of
				[] ->
					update_rank(RankFlag, [], CurTime),
					[];
				RankList ->
					Fun = fun(List, {Rank, AllList}) ->
						List1 = list_to_tuple([RankFlag | List ++ [Rank + 1]]),
						{Rank + 1, [List1] ++ AllList}
					end,
					{_, RankLvList1} = lists:foldl(Fun, {0, []}, RankList),
					RankLvList2 = lists:reverse(RankLvList1),
					update_rank(RankFlag, RankLvList2, CurTime),
					RankLvList2
			end;
		false ->
			[]
	end.
%% 活动排行
init_single_rank_active(Type) ->
	CurTime = util_date:unixtime(),
	RecordList = player_active_service_record_cache:select_all(Type),
	#active_service_type_conf{value = TypeValue} = active_service_type_config:get(Type),
	F = fun(X, [List, TempRank]) ->
		#db_player_active_service_record{value = Value, player_id = PlayerId} = X,
		case Value < TypeValue of
			true ->
				[List, TempRank];
			_ ->
				Name = player_id_name_lib:get_player_name(PlayerId),
				RankInfo = #ets_active_rank_info{
					rank = TempRank,
					player_id = PlayerId,
					name = Name,
					value = Value
				},
				[List ++ [RankInfo], TempRank + 1]
		end
	end,
	RecordList1 = lists:keysort(#ets_active_rank_info.value, RecordList),
	[RankList, _Rank] = lists:foldr(F, [[], 1], RecordList1),
	update_rank({active, Type}, RankList, CurTime),
	RankList.

%% 合服排行
init_single_rank_active_merge(Type) ->
	CurTime = util_date:unixtime(),
	RecordList = player_active_service_record_merge_cache:select_all(Type),
	#active_service_merge_type_conf{value = TypeValue} = active_service_merge_type_config:get(Type),
	F = fun(X, [List, TempRank]) ->
		#db_player_active_service_record_merge{value = Value, player_id = PlayerId} = X,
		case Value < TypeValue of
			true ->
				[List, TempRank];
			_ ->
				Name = player_id_name_lib:get_player_name(PlayerId),
				RankInfo = #ets_active_rank_info{
					rank = TempRank,
					player_id = PlayerId,
					name = Name,
					value = Value
				},
				[List ++ [RankInfo], TempRank + 1]
		end
	end,
	RecordList1 = lists:keysort(#ets_active_rank_info.value, RecordList),
	[RankList, _Rank] = lists:foldr(F, [[], 1], RecordList1),
	update_rank({active_merge, Type}, RankList, CurTime),
	RankList.

%% 获取排行榜列表信息
get_rank_list_data({?ETS_OPERATE_TYPE_4, _ActiveId, _FinishType}, RankList) ->
	RankLen = length(RankList),
	case RankLen =< 0 of
		true ->
			[];
		_ ->
			SubList = lists:sublist(RankList, ?MAX_RANK_OPERATE_PAGE_NUM),
			Proto = make_proto_data({?ETS_OPERATE_TYPE_4, _ActiveId, _FinishType}, SubList),
			Proto
	end.
get_rank_list_data(RankFlag, RankList, Page) ->
	case Page > 0 of
		true ->
			RankLen = length(RankList),
			StartIndex = get_start_index(Page, ?MAX_RANK_PER_PAGE_NUM),
			case RankLen < StartIndex of
				true ->
					[];
				_ ->
					SubList = lists:sublist(RankList, StartIndex, ?MAX_RANK_PER_PAGE_NUM),
					Proto = make_proto_data(RankFlag, SubList),
					Proto
			end;
		_ ->
			[]
	end.

get_rank_list_data(?ETS_RANK_PLAYER_LV, RankList, Page, Type) ->
	case Type of
		0 ->
			get_rank_list_data(?ETS_RANK_PLAYER_LV, RankList, Page);
		1 ->
			RankList1 = [X || X <- RankList, X#ets_rank_player_lv.career == ?CAREER_ZHANSHI],
			get_rank_list_data(?ETS_RANK_PLAYER_LV, RankList1, Page);
		2 ->
			RankList1 = [X || X <- RankList, X#ets_rank_player_lv.career == ?CAREER_FASHI],
			get_rank_list_data(?ETS_RANK_PLAYER_LV, RankList1, Page);
		3 ->
			RankList1 = [X || X <- RankList, X#ets_rank_player_lv.career == ?CAREER_DAOSHI],
			get_rank_list_data(?ETS_RANK_PLAYER_LV, RankList1, Page)
	end;
get_rank_list_data(?ETS_RANK_PLAYER_FIGHT, RankList, Page, Type) ->
	case Type of
		0 ->
			get_rank_list_data(?ETS_RANK_PLAYER_FIGHT, RankList, Page);
		1 ->
			RankList1 = [X || X <- RankList, X#ets_rank_player_fight.career == ?CAREER_ZHANSHI],
			get_rank_list_data(?ETS_RANK_PLAYER_FIGHT, RankList1, Page);
		2 ->
			RankList1 = [X || X <- RankList, X#ets_rank_player_fight.career == ?CAREER_FASHI],
			get_rank_list_data(?ETS_RANK_PLAYER_FIGHT, RankList1, Page);
		3 ->
			RankList1 = [X || X <- RankList, X#ets_rank_player_fight.career == ?CAREER_DAOSHI],
			get_rank_list_data(?ETS_RANK_PLAYER_FIGHT, RankList1, Page)
	end.

%% 获取个人排名(0表示不上榜)
get_rank(RankFlag, RankList, Id) ->
	get_rank_by_id(RankFlag, RankList, Id).

%% 获取排行榜刷新时间
get_rank_refuse_time(?ETS_RANK_PLAYER_LV) ->
	3600;
get_rank_refuse_time(?ETS_RANK_PLAYER_FIGHT) ->
	3700;
get_rank_refuse_time(?ETS_RANK_GUILD_LV) ->
	3800;
%% 默认7200
get_rank_refuse_time(_) ->
	60.

get_rank_ets_by_active_type(Type) ->
	?ERR("err not hava ~p", [Type]).

%% 获取对应页码的开始下标
get_start_index(Page, MaxPerPageNum) ->
	(Page - 1) * MaxPerPageNum + 1.

%% 获取排行榜 vales
get_rank_list(RankFlag) ->
	case ets:lookup(?ETS_RANK_INFO, RankFlag) of
		[R | _] ->
			case R#ets_rank_info.update_time < util_date:unixtime() of
				true ->
					init_single_rank(R#ets_rank_info.key);
				_ ->
					R#ets_rank_info.rank_list
			end;
		_ ->
			init_single_rank(RankFlag)
	end.
%% 获取排行榜 vales
get_rank_list_active_type(Type, IsInit) ->
	case IsInit of
		true ->
			init_single_rank_active(Type);
		_ ->
			case ets:lookup(?ETS_RANK_INFO, {active, Type}) of
				[R | _] ->
					case R#ets_rank_info.update_time < util_date:unixtime() of
						true ->
							init_single_rank_active(Type);
						_ ->
							R#ets_rank_info.rank_list
					end;
				_ ->
					init_single_rank_active(Type)
			end
	end.

%% 获取合服排行榜 vales
get_rank_list_active_merge_type(Type, IsInit) ->
	case IsInit of
		true ->
			init_single_rank_active_merge(Type);
		_ ->
			case ets:lookup(?ETS_RANK_INFO, {active_merge, Type}) of
				[R | _] ->
					case R#ets_rank_info.update_time < util_date:unixtime() of
						true ->
							init_single_rank_active_merge(Type);
						_ ->
							R#ets_rank_info.rank_list
					end;
				_ ->
					init_single_rank_active_merge(Type)
			end
	end.


%% ====================================================================
%% Internal functions
%% ====================================================================

%% 每添加一个排行榜需要在这里多加一个规则
load_rank_info(?ETS_RANK_PLAYER_LV) ->
	Sql = io_lib:format(?SQL_RANK_PLAYER_LV, [0, ?MAX_RANK_NUM]),
	db:select_all(Sql);
load_rank_info(?ETS_RANK_PLAYER_FIGHT) ->
	Sql = io_lib:format(?SQL_RANK_PLAYER_FIGHT, [0, ?MAX_RANK_NUM]),
	db:select_all(Sql);
load_rank_info(?ETS_RANK_GUILD_LV) ->
	db:select_all(?SQL_RANK_GUILD_LV);
load_rank_info({?ETS_OPERATE_TYPE_4, ActiveId, FinishType}) ->
	Conf = holidays_active_config:get(?OPERATE_ACTIVE_TYPE_4),
	{_, List} = lists:keyfind(rank, 1, Conf#holidays_active_conf.reward),
	MinValue = lists:min([X || {_, _, X} <- List]),
	db:select_all(io_lib:format(<<"SELECT `player_id`, `finish_limit_value` FROM `player_operate_record` WHERE `active_id`= ~w and `finish_limit_type`= ~w and `finish_limit_value` > ~w ORDER BY `finish_limit_value` DESC LIMIT ~w">>, [ActiveId, FinishType, MinValue, ?MAX_RANK_OPERATE_TYPE_4_NUM]));
load_rank_info(_) ->
	[].

%% 更新排行
update_rank(RankFlag, RankList, CurTime) ->
%%   ets:delete(?ETS_RANK_INFO, RankFlag),
	R = #ets_rank_info{key = RankFlag, rank_list = RankList, update_time = CurTime + rank_lib:get_rank_refuse_time(RankFlag)},
	ets:insert(?ETS_RANK_INFO, R).

%% 更新排行榜信息
make_proto_data(?ETS_RANK_PLAYER_LV, SubList) ->
	Fun = fun(Info) ->
		#proto_lv_rank_info
		{
			player_id = Info#ets_rank_player_lv.player_id,  %%  玩家id
			name = Info#ets_rank_player_lv.name,  %%  玩家名字
			career = Info#ets_rank_player_lv.career,  %%  玩家职业
			lv = Info#ets_rank_player_lv.lv,  %%  等级
			guild_name = guild_lib:get_guild_name(Info#ets_rank_player_lv.guild_id),  %%  公会名
			rank = Info#ets_rank_player_lv.rank  %%  玩家排名
		}
	end,
	[Fun(X) || X <- SubList];
make_proto_data(?ETS_RANK_PLAYER_FIGHT, SubList) ->
	Fun = fun(Info) ->
		#proto_fight_rank_info
		{
			player_id = Info#ets_rank_player_fight.player_id,  %%  玩家id
			name = Info#ets_rank_player_fight.name,  %%  玩家名字
			career = Info#ets_rank_player_fight.career,  %%  玩家职业
			fight = Info#ets_rank_player_fight.fight,
			guild_name = guild_lib:get_guild_name(Info#ets_rank_player_fight.guild_id),  %%  公会名
			rank = Info#ets_rank_player_fight.rank  %%  玩家排名
		}
	end,
	[Fun(X) || X <- SubList];
make_proto_data(?ETS_RANK_GUILD_LV, SubList) ->
	Fun = fun(Info) ->
		#proto_guild_rank_info
		{
			guild_id = Info#ets_rank_guild_lv.guild_id,  %%  行会id
			chief_name = Info#ets_rank_guild_lv.chief_name,  %%  会长名字
			member_num = Info#ets_rank_guild_lv.member_count,  %%  成员数量
			guild_lv = Info#ets_rank_guild_lv.lv,  %%  行会等级
			guild_name = Info#ets_rank_guild_lv.guild_name,  %%  公会名
			rank = Info#ets_rank_guild_lv.rank  %%  行会排名
		}
	end,
	[Fun(X) || X <- SubList];
make_proto_data({?ETS_OPERATE_TYPE_4, _, _}, SubList) ->
	Fun = fun(Info) ->
		#proto_active_rank_info
		{
			player_id = Info#ets_rank_kill_active.player_id,  %%  玩家id
			name = Info#ets_rank_kill_active.player_name,  %%  玩家名字
			score = Info#ets_rank_kill_active.score,  %%  玩家积分
			rank = Info#ets_rank_kill_active.rank  %%  玩家排名
		}
	end,
	[Fun(X) || X <- SubList];
make_proto_data(_Flag, _SubList) ->
	[].

get_rank_by_id(?ETS_RANK_PLAYER_LV, RankList, PlayerId) ->
	case lists:keyfind(PlayerId, #ets_rank_player_lv.player_id, RankList) of
		false ->
			0;
		Info ->
			Info#ets_rank_player_lv.rank
	end;
get_rank_by_id(?ETS_RANK_PLAYER_FIGHT, RankList, PlayerId) ->
	case lists:keyfind(PlayerId, #ets_rank_player_fight.player_id, RankList) of
		false ->
			0;
		Info ->
			Info#ets_rank_player_fight.rank
	end;
get_rank_by_id(?ETS_RANK_GUILD_LV, RankList, GuildId) ->
	case lists:keyfind(GuildId, #ets_rank_guild_lv.guild_id, RankList) of
		false ->
			0;
		Info ->
			Info#ets_rank_guild_lv.rank
	end;
get_rank_by_id(_Flag, _RankList, _PlayerId) ->
	0.

get_max_rank(RankList) ->
	case length(RankList) > 0 of
		true ->
			%% 获取杀怪积分配置
			Conf = holidays_active_config:get(?OPERATE_ACTIVE_TYPE_4),
			{_, List} = lists:keyfind(rank, 1, Conf#holidays_active_conf.reward),
			[_PlayerId, Score] = lists:nth(1, RankList),
			get_max_rank_1(List, Score, 3);
		false ->
			0
	end.
get_max_rank_1([], _Score, Result) ->
	Result - 1;
get_max_rank_1([{Rank, _, S} | T], Score, _Result) ->
	case Score >= S of
		true ->
			Rank - 1;
		false ->
			get_max_rank_1(T, Score, Rank)
	end.