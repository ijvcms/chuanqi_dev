%%%-------------------------------------------------------------------
%%% @author qhb
%%% @copyright (C) 2016, <COMPANY>
%%% @doc
%%% 趣味答题
%%% @end
%%% Created : 27. 七月 2016 上午11:47
%%%-------------------------------------------------------------------
-module(exam_lib).
-include("common.hrl").
-include("record.hrl").
-include("cache.hrl").
-include("proto.hrl").
-include("config.hrl").
-include("language_config.hrl").
-include("notice_config.hrl").
-include("log_type_config.hrl").

-define(ETS_EXAM, ets_exam).
-define(TOOL1_COUNTER_ID, 10071).
-define(TOOL2_COUNTER_ID, 10072).
-define(TOOL3_COUNTER_ID, 10073).
-define(ACTIVE_REMIND_ID, 9).
-define(REFRESH_TIME, 1). %% 刷新时间间隔(秒)

-record(ets_exam, {player_id, player_name, libs, current, score, right_num, error_num, exp}).

%% API
-export([
	start/1,
	choice/4,
	rank/1,
	use_tool/3,
	do_activity_end/0,
	is_exam_open_srv/0
]).


%% GEN API
-export([
	init_local/0,
	check/1,
	get_left_time/0,
	is_exam_open_local/1
]).


init_local() ->
	ets:new(?ETS_EXAM,[{keypos, #ets_exam.player_id},named_table, public, set]),
	gen_server2:apply_after(?REFRESH_TIME * 1000, self(), {?MODULE, check, []}),
	ok.

%%开始答题
start(PlayerState) ->
	#player_state{player_id = PlayerId, db_player_base = #db_player_base{name = PlayerName, vip = Vip}} = PlayerState,
	%%ets:delete(?ETS_EXAM, PlayerId),
	case is_exam_open_srv() of
		true ->
			case ets:lookup(?ETS_EXAM, PlayerId) of
				[_] ->
					net_send:send_to_client(PlayerId, 32030, #rep_exam_start{result = ?ERR_EXAM_DONE});
				[] ->
					ToolNum = get_tools_num(Vip),
					Tool_num1 = ToolNum - counter_lib:get_value(PlayerId, ?TOOL1_COUNTER_ID),
					Tool_num2 = ToolNum - counter_lib:get_value(PlayerId, ?TOOL2_COUNTER_ID),
					Tool_num3 = ToolNum - counter_lib:get_value(PlayerId, ?TOOL3_COUNTER_ID),
					ExIds = create_lib(),
					EtsExam = #ets_exam{player_id = PlayerId, player_name = PlayerName, libs = ExIds,
						current = 1, score = 0, right_num = 0, error_num = 0, exp = 0},
					ets:insert(?ETS_EXAM, EtsExam),
					PlayerRank = get_player_rank(PlayerId),
					%%get_left_time(),
					Rep = #rep_exam_start{result = 0, rank = PlayerRank, tools1 = Tool_num1, tools2 = Tool_num2, tools3 = Tool_num3,
						ex_ids = ExIds, time_left = 900},
					?WARNING("32030 ~p",[Rep]),
					net_send:send_to_client(PlayerId, 32030, Rep),
					put(exam_choice_time, util_date:unixtime())
			end;
		false ->
			net_send:send_to_client(PlayerId, 32030, #rep_exam_start{result = ?ERR_ACTIVE_NOT_OPEN})
	end,
	{ok, PlayerState}.

%%选择答案
choice(PlayerState, ExIndex, Choice, IsPass) ->
	#player_state{player_id = PlayerId, db_player_base = #db_player_base{lv = Lv}} = PlayerState,
	?WARNING("choice",[]),
	case ets:lookup(?ETS_EXAM, PlayerId) of
		[R] ->
			#ets_exam{libs = Libs, current = _Curr, right_num = RightNumOld, error_num = ErrorNumOld,
			score = ScoreOld, exp = ExpOld} = R,
			ExId = lists:nth(ExIndex, Libs),
			IsRight = right_flag(ExId, Choice, IsPass),
			ScoreAdd = case IsRight =:= 1 of
						   true -> get_score();
						   false -> 0
					   end,
			ExpAdd = erlang:max(erlang:round( (ExIndex + 29) * (Lv - 10)*4.12 ), 0),
			{RightNum, ErrorNum} =
				case IsRight of
					1 -> {RightNumOld + 1, ErrorNumOld};
					_ -> {RightNumOld, ErrorNumOld + 1}
				end,
			Score = ScoreOld + ScoreAdd,
			Exp = ExpOld + ExpAdd,

			EtsExamNew = R#ets_exam{right_num = RightNum, error_num = ErrorNum, score = Score, exp = Exp},
			ets:insert(?ETS_EXAM, EtsExamNew),
			PlayerRank = get_player_rank(PlayerId),

			Rep = #rep_exam_choice{result = 0, rank = PlayerRank, is_right = IsRight, total_score = Score,
				right_num = RightNum, error_num = ErrorNum, exp =Exp},
			?WARNING("32031 ~p",[Rep]),
			net_send:send_to_client(PlayerId, 32031, Rep),

			Result = player_lib:add_exp(PlayerState, ExpAdd, {?LOG_TYPE_EXAM, []}),
			put(exam_choice_time, util_date:unixtime()),
			Result;
		[] ->
			?WARNING("choice2",[]),
			{ok, PlayerState}
	end.

%%排行榜
rank(PlayerState) ->
	#player_state{player_id = PlayerId} = PlayerState,
	List1 = get_rank_list(),
	List2 = [
		begin
			{_, #ets_exam{player_name = RankPlayerName, score = RankScore}, Index} = E,
			#proto_exam_rank_info{name = RankPlayerName, score = RankScore, rank = Index}
		end || E <- List1
	],
	List = lists:sublist(List2, 8),
	Rep = #rep_exam_rank{ranks = List},
	?WARNING("32032 ~p",[Rep]),
	net_send:send_to_client(PlayerId, 32032, Rep).

%%答题道具
use_tool(PlayerState, ToolType, ExIndex) ->
	?WARNING("use_tool ~p",[ToolType]),
	#player_state{player_id = PlayerId, db_player_base = #db_player_base{vip = Vip}} = PlayerState,
	ToolNum = get_tools_num(Vip),
	case ToolType of
		%%双倍积分道具
		1 ->
			case ToolNum - counter_lib:get_value(PlayerId, ?TOOL1_COUNTER_ID) > 0 of
				true ->
					counter_lib:update(PlayerId, ?TOOL1_COUNTER_ID),
					put("exam_tool1", true),
					ToolLeft = ToolNum - counter_lib:get_value(PlayerId, ?TOOL1_COUNTER_ID),
					Rep = #rep_exam_tool{result = 0, type = 1,tools_num = ToolLeft},
					net_send:send_to_client(PlayerId, 32033, Rep);
				false ->
					Rep = #rep_exam_tool{result = ?ERR_EXAM_USEUP, type = 1},
					net_send:send_to_client(PlayerId, 32033, Rep)
			end,
			{ok, PlayerState};
		%%难度减半道具
		2 ->
			case ToolNum - counter_lib:get_value(PlayerId, ?TOOL2_COUNTER_ID) > 0 of
				true ->
					counter_lib:update(PlayerId, ?TOOL2_COUNTER_ID),

					ExId = case ets:lookup(?ETS_EXAM, PlayerId) of
							   [R] ->
								   #ets_exam{libs = Libs} = R,
								   lists:nth(ExIndex, Libs);
							   [] ->
								   0
						   end,
					ErrorList = two_error_choice(ExId),
					Prams = [util_data:to_binary(R) || R <- ErrorList],
					ToolLeft = ToolNum - counter_lib:get_value(PlayerId, ?TOOL2_COUNTER_ID),
					Rep = #rep_exam_tool{result = 0, type = 2, params = Prams,tools_num = ToolLeft},
					net_send:send_to_client(PlayerId, 32033, Rep);
				false ->
					Rep = #rep_exam_tool{result = ?ERR_EXAM_USEUP, type = 2},
					net_send:send_to_client(PlayerId, 32033, Rep)
			end,
			{ok, PlayerState};
		%%免答题道具
		3 ->
			case ToolNum - counter_lib:get_value(PlayerId, ?TOOL3_COUNTER_ID) > 0 of
				true ->
					counter_lib:update(PlayerId, ?TOOL3_COUNTER_ID),

					ToolLeft = ToolNum - counter_lib:get_value(PlayerId, ?TOOL3_COUNTER_ID),
					Rep = #rep_exam_tool{result = 0, type = 3, tools_num = ToolLeft},
					net_send:send_to_client(PlayerId, 32033, Rep),
					choice(PlayerState, ExIndex, 0, true);
				false ->
					Rep = #rep_exam_tool{result = ?ERR_EXAM_USEUP, type = 3},
					net_send:send_to_client(PlayerId, 32033, Rep),
					{ok, PlayerState}
			end;
		_ ->
			{ok, PlayerState}
	end.

%%答题活动结束
do_activity_end() ->
	EtsList = ets:tab2list(?ETS_EXAM),
	List = lists:sort(fun(E1, E2) -> E1#ets_exam.score > E2#ets_exam.score end, EtsList),
	case List of
		[#ets_exam{player_name = PlayerName} | _] ->
			notice_lib:send_notice(0, ?NOTICE_EXAM, [PlayerName]);
		_ ->
			skip
	end,
	lists:foldl(fun(E, Index) ->
		case Index =< 8 of
			true ->
				MailId = 83 + Index,
				mail_lib:send_mail_to_player(E#ets_exam.player_id, MailId);
			false ->
				MailId = 92,
				mail_lib:send_mail_to_player(E#ets_exam.player_id, MailId)
		end,
		Index + 1
	end, 1, List).

%% create_lib() ->
%% 	[1, 2, 3, 4, 5].

create_lib() ->
	[(R - 1) * 5 + random:uniform(5) || R <- lists:seq(1, 30)].

%%判断答案是否正确
right_flag(ExId, Choice, IsPass) ->
	case IsPass of
		true -> 1;
		false ->
			#examination_conf{result = Result} = examination_config:get(ExId),
			case Result =:= Choice of
				true -> 1;
				false -> 0
			end
	end.

%%难度减半道具，选出两个错误的答案
two_error_choice(ExId) ->
	#examination_conf{result = Result} = examination_config:get(ExId),
	List = lists:delete(Result, [1, 2, 3, 4]),
	lists:sublist(List, 2).

%%计算分数，有使用积分双倍道具就积分双倍
get_score() ->
	TimeLeft = erlang:max(10 - (util_date:unixtime() - get(exam_choice_time)), 0),
	Score = 50 * TimeLeft,
	case get("exam_tool1") of
		undefined -> Score;
		_ ->
			erase("exam_tool1"),
			Score * 2
	end.

%%计算排行榜
get_rank_list() ->
	EtsList = ets:tab2list(?ETS_EXAM),
	List1 = lists:sort(fun(E1, E2) ->
		E1#ets_exam.score > E2#ets_exam.score
	end, EtsList),

	{_, List2} = lists:foldl(
		fun(E, {Index, Acc}) ->
			A = {E#ets_exam.player_id, E, Index},
			AccNew = [A | Acc],
			{Index + 1, AccNew}
		end,
		{1, []}, List1),
	lists:reverse(List2).

%%计算玩家的排行
get_player_rank(PlayerId) ->
	List1 = get_rank_list(),
	case lists:keyfind(PlayerId, 1, List1) of
		{PlayerId, _, Index} -> Index;
		_ -> 0
	end.

%%获取玩家答题道具的数量
get_tools_num(Vip) ->
	case  vip_config:get(Vip, 1000) of
		#vip_conf{exam_tools = ToolsNum} -> ToolsNum;
		_ -> 1
	end.

%%定时检查活动结束
check(State) ->
	try
		case is_exam_open() of
			true ->
				case not is_exam_open_time() of
					true ->
						do_activity_end(),
						delete_exam_open(),
						ets:delete_all_objects(?ETS_EXAM);
					false -> skip
				end;
			false ->
				case is_exam_open_time() of
					true -> set_exam_open();
					false -> skip
				end
		end
	catch
		_:Reason ->
			?ERR("exam error ~p ~p", [Reason, erlang:get_stacktrace()])
	end,
	gen_server2:apply_after(?REFRESH_TIME * 1000, self(), {?MODULE, check, []}),
	{ok, State}.

is_exam_open_srv() ->
	gen_server2:apply_sync(misc:whereis_name({local, exam_mod}), {?MODULE, is_exam_open_local, []}).
is_exam_open_local(_State) ->
	is_exam_open().

%% 判断活动是否开始
is_exam_open() ->
	case get("exam_open_flag") of
		undefined -> false;
		_ -> true
	end.

%%设置活动开启
set_exam_open() ->
	put("exam_open_flag", true).

%%关闭活动
delete_exam_open() ->
	erase("exam_open_flag").

%%是否在活动开启时间内
is_exam_open_time() ->
	{_Date, Time} = calendar:local_time(),
	#active_remind_conf{time_list = [_, TimeCfg]} = active_remind_config:get(?ACTIVE_REMIND_ID),
	{_, Time1, Time2} = TimeCfg,
	Time > Time1 andalso Time < Time2.

%%获取活动剩余的时间
get_left_time() ->
	{Date, _Time} = calendar:local_time(),
	#active_remind_conf{time_list = [_, TimeCfg]} = active_remind_config:get(?ACTIVE_REMIND_ID),
	{_, _Time1, Time2} = TimeCfg,
	EndTime = datetime_to_unix({Date, Time2}),
	case is_exam_open() of
		true -> util_date:unixtime() - EndTime;
		false -> 0
	end.

unix_gregorian_seconds() ->
	calendar:datetime_to_gregorian_seconds({{1970, 1, 1}, {0, 0, 0}}).

gregorian_seconds_to_unix(GreSec) ->
	GreSec - unix_gregorian_seconds().

datetime_to_unix({Date, Time}) ->
	gregorian_seconds_to_unix(calendar:datetime_to_gregorian_seconds({Date, Time})).