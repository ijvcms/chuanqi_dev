%%%-------------------------------------------------------------------
%%% @author yubing
%%% @copyright (C) 2016, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 16. 五月 2016 17:17
%%%-------------------------------------------------------------------
-module(lottery_box_lib).

-include("common.hrl").
-include("record.hrl").
-include("cache.hrl").
-include("config.hrl").
-include("proto.hrl").
-include("uid.hrl").
-include("language_config.hrl").
-include("gameconfig_config.hrl").
-include("button_tips_config.hrl").
-include("log_type_config.hrl").
-include("notice_config.hrl").

%% API
-export([
	init/1,
	do_lottery_begin/4,
	lottery_begin/3,
	get_logs_type/1,
	get_logs_me/2,
	get_lottery_log_lists/2,
	do_send_lottery_log/2,
	get_need_consume/2,
	get_lottery_goods_list/2,
	exchange/2,
	check_daynum_local/3
]).

-define(NEEDJADE, 20).
-define(NEEDJADE10, 180).

init(LotteryState) ->
	DBList = lottery_box_db_db:select_all(),
	RefTime = case length(DBList) > 0 of
				  true ->
					  [D | _H] = DBList,
					  D#db_lottery_box_db.ref_time;
				  _ ->
					  util_date:get_tomorrow_unixtime()
			  end,
	%% 转盘抽奖信息
	LotteryData = #lottery_data{
		lottery_db_list = lottery_box_db_db:select_all(),
		server_num = 0,
		ref_time = RefTime
	},
	LotteryState1 = LotteryState#lottery_state{
		lottery_shmj = LotteryData
	},
	{ok, LotteryState1}.

%% 获取指定类型的日志列表
get_logs_type(LotteryType) ->
	List = lottery_box_log_db:select_by_type(LotteryType),
	[pack_lottery_log(X, 0, player_id_name_lib:get_player_name(X#db_lottery_box_log.player_id)) || X <- List].

%% 获取我的日志列表
get_logs_me(LotteryType, PlayerId) ->
	List = lottery_box_log_db:select_by_player(LotteryType, PlayerId),
	[pack_lottery_log(X, 0, player_id_name_lib:get_player_name(X#db_lottery_box_log.player_id)) || X <- List].

%% 获取日志列表
get_lottery_log_lists(_LotteryType, GroupNum) ->
	List = lottery_box_log_db:select_all(GroupNum),
	[pack_lottery_log(X, 0, player_id_name_lib:get_player_name(X#db_lottery_box_log.player_id)) || X <- List].
%% 获取日志信息
pack_lottery_log(LotteryLogInfo, PlayerId, Name) ->
	LotteryConf = lottery_box_config:get(LotteryLogInfo#db_lottery_box_log.lottery_id),
	GoodsId =
		case LotteryLogInfo#db_lottery_box_log.goods_id > 0 of
			true ->
				LotteryLogInfo#db_lottery_box_log.goods_id;
			false ->
				[{GoodsId_1, _, _} | _] = LotteryConf#lottery_box_conf.goods,
				GoodsId_1
		end,
	#proto_lottery_log_info{
		id = LotteryLogInfo#db_lottery_box_log.id,
		name = Name,
		goods_id = GoodsId,
		player_id = PlayerId
	}.

%% 获取抽奖的物品列表
get_lottery_goods_list(LotteryType, GropNum) ->
	F = fun(LotteryConf) ->
		%%LotteryConf = lottery_box_config:get(X),
		[{GoodsId, IsBind, GoodsNum} | _] = LotteryConf#lottery_box_conf.goods,
		#proto_lottery_goods_info{
			id = LotteryConf#lottery_box_conf.id,
			goods_id = GoodsId,
			is_bind = IsBind,
			num = GoodsNum
		}
	end,
	[F(X) || X <- get_lottery_list(LotteryType, GropNum)].

%% 开始抽奖
lottery_begin(PlayerState, LotteryType, Num) ->
	case check_daynum(LotteryType, Num) of
		true ->
			case get_need_consume(LotteryType, Num) of%%
				{0, _, _, _, _} ->
					{fail, ?ERR_ACTIVE_SERVICE_10};
				{GroupNum, {NewNum, NeedJade}, _, _, _} ->
					DbMoney = PlayerState#player_state.db_player_money,

					UseBagNum = goods_lib:get_free_bag_num(PlayerState),
					case UseBagNum =:= 0 of
						true ->
							{fail, ?ERR_PLAYER_BAG_NOT_ENOUGH};
						_ ->
							case DbMoney#db_player_money.jade < NeedJade of
								true ->
									{fail, ?ERR_PLAYER_JADE_NOT_ENOUGH};
								_ ->
									NewPlayerState = PlayerState#player_state{
										is_lottery_begin = false,
										equip_list = [],
										goods_list = []
									},
									%% 开始抽奖
									{List, GoodsList, PlayerState2} = lottery_begin(NewPlayerState, LotteryType, GroupNum, NewNum, 0, [], [], [], []),
									NewList = [X#lottery_box_conf.id || X <- List],
									ProtoGoodsList = [#proto_goods_info{goods_id = GoodsId, is_bind = IsBind, num = GoodsNum}
										|| {GoodsId, IsBind, GoodsNum} <- GoodsList],
									%% 修改玩家的抽奖次数
									Base = PlayerState#player_state.db_player_base,
									Update = #player_state{
										db_player_base = add_lottery_num(LotteryType, Base, NewNum)
									},
									{ok, PlayerState3} = player_lib:update_player_state(PlayerState2, Update),
									{ok, PlayerState4} = player_lib:incval_on_player_money_log(PlayerState3, #db_player_money.jade, -NeedJade, ?LOG_TYPE_LOTTERY_BOX),
									{ok, NewList, ProtoGoodsList, PlayerState4#player_state.equip_list, PlayerState4#player_state{is_lottery_begin = false, goods_list = [], equip_list = []}}
							end
					end
			end;
		false ->
			{fail, ?ERR_SHENHUANGMIJING}
	end.

%% 获取转盘的抽奖信息
get_need_consume(LotteryType, Num) ->
	FuncId = getLotteryFunctionId(LotteryType),
	FunctionConf = function_config:get(FuncId),
	case function_lib:check_is_open_time(FunctionConf) of%%
		{false, _} ->
			{0, {0, 0}, [], 0, 0};
		{_, FunctionInfo} ->
			{GroupNum, BeginTime, EndTime} = case FunctionInfo of
												 null ->
													 {1, util_date:get_today_unixtime(), util_date:get_tomorrow_unixtime()};
												 _ ->
													 {FunctionInfo#db_function.group_num, FunctionInfo#db_function.begin_time, FunctionInfo#db_function.end_time}
											 end,
			%% 获取消耗列表
			ConsumeList1 = case lists:keyfind(GroupNum, 1, FunctionConf#function_conf.consume) of
							   false ->
								   [{_, ConsumeList} | _] = FunctionConf#function_conf.consume,
								   ConsumeList;
							   {_, ConsumeList} ->
								   ConsumeList
						   end,

			%% 获取次数
			{NewNum, NeedJade} =
				case lists:keyfind(Num, 1, ConsumeList1) of
					false ->
						{1, 1000};
					Value ->
						Value
				end,
			%% 获取消耗元宝列表
			JadList = [R || {_, R} <- ConsumeList1],

			{GroupNum, {NewNum, NeedJade}, JadList, BeginTime, EndTime}
	end.

%%临时加的,应该跟抽奖流程整合一起
check_daynum(LotteryType, Num) ->
	case gen_server2:apply_sync(misc:whereis_name({local, lottery_mod}), {?MODULE, check_daynum_local, [LotteryType, Num]}) of
		{ok, true} ->
			true;
		_ ->
			false
	end.
check_daynum_local(LotteryState, LotteryType, Num) ->
	NewLotteryState = check_lottery_state(LotteryState, LotteryType),
	LotteryData = getLotteryData(NewLotteryState, LotteryType),
	Flag = LotteryData#lottery_data.day_num + Num =< counter_lib:get_limit(10130),
	%%?WARNING("check_daynum ~p ~p",[LotteryData#lottery_data.day_num, Flag]),
	{ok, Flag, NewLotteryState}.


%% 开始抽奖 state,分组,最大次数,当前次数,
lottery_begin(PlayerState, LotteryType, _GroupNum, Num, Num, List, NewListLog, NewNoticeList, GoodsList) ->
	case length(NewListLog) > 0 of
		true ->
			Buf = net_send:get_bin(35007, #rep_lottery_log_shmj{type = LotteryType, log_lists = NewListLog}),
			PlayerList = player_lib:get_online_players(),

			[notice_lib:send_notice(0, ?NOTICE_BACK, [X]) || X <- NewNoticeList],
			[send_lottery_log(X#ets_online.pid, Buf) || X <- PlayerList];
		_ ->
			skip
	end,
	{List, GoodsList, PlayerState};
%% 开始抽奖
lottery_begin(PlayerState, LotteryType, GroupNum, Num, NowNum, List, ListLog, NoticeList, GoodsList) ->
	Base = PlayerState#player_state.db_player_base,
	case gen_server2:apply_sync(misc:whereis_name({local, lottery_mod}), {?MODULE, do_lottery_begin, [LotteryType, GroupNum, Base]}) of
		{ok, LotteryConf2} ->
			%% 添加物品
			Goods = util_rand:list_rand(LotteryConf2#lottery_box_conf.goods),
			{GoodsId, _, _} = Goods,
			{ok, PlayerState1} = goods_lib_log:add_goods_list_and_send_mail(PlayerState, [Goods], ?LOG_TYPE_LOTTERY),
			NewListLog = case LotteryConf2#lottery_box_conf.is_log =:= 1 of
							 true ->
								 Log = add_log(LotteryType, PlayerState1, GroupNum, LotteryConf2#lottery_box_conf.id, GoodsId),
								 [Log | ListLog];
							 _ ->
								 ListLog
						 end,
			NewNoticeList = case LotteryConf2#lottery_box_conf.is_notice =:= 1 of
								true ->
									%% 全服公告
									#goods_conf{name = GoodsName} = goods_config:get(GoodsId),
									NoticeInfo = io_lib:format(LotteryConf2#lottery_box_conf.notice_info, [util_data:to_list(Base#db_player_base.name), GoodsName]),
									[NoticeInfo | NoticeList];
								_ ->
									NoticeList
							end,

			NewList = [LotteryConf2 | List],
			NewGoodsList = [Goods | GoodsList],
			lottery_begin(PlayerState1, LotteryType, GroupNum, Num, NowNum + 1, NewList, NewListLog, NewNoticeList, NewGoodsList);
		_ ->
			lottery_begin(PlayerState, LotteryType, GroupNum, Num, NowNum + 1, List, ListLog, NoticeList, GoodsList)
	end.

%% 抽奖信息
do_lottery_begin(LotteryState, LotteryType, GroupNum, Base) ->

	NewLotteryState = check_lottery_state(LotteryState, LotteryType),
	F = fun(X, [Sum, List, TempLotteryConf, TempLotteryInfo]) ->
		%% 如果已经有lotteryConf了那么就直接返回
		case TempLotteryConf /= null of
			true ->
				[Sum, List, TempLotteryConf, TempLotteryInfo];
			_ ->
				%% 寻找该抽奖的记录信息
				{Result, LotteryInfo, LotteryConf} = get_lottery_server(LotteryType, X, NewLotteryState, Base),
				case Result /= 0 of
					true ->
						%%如果大于服务器对应的次数 那么直接出改物品
						[Sum, List, TempLotteryConf, TempLotteryInfo];
					_ ->

						NewList = [{X, LotteryInfo} | List],
						NewSum = Sum + X#lottery_box_conf.weights,
						[NewSum, NewList, LotteryConf, LotteryInfo]
				end
		end
	end,
	%% 获取抽奖内容
	[Sum1, List1, LotteryConf1, LotteryInfo1] = lists:foldr(F, [0, [], null, null], get_lottery_list(LotteryType, GroupNum)),
	case LotteryConf1 /= null of
		true ->
			LotteryState1 = update_lottery(NewLotteryState, LotteryType, LotteryConf1, LotteryInfo1),
			{ok, LotteryConf1, LotteryState1};
		_ ->
			RdNum = random:uniform(Sum1),
			{LotteryInfo2, LotteryConf2} = rand_lottery(List1, {RdNum, 0, null, null}),
			LotteryState1 = update_lottery(NewLotteryState, LotteryType, LotteryConf2, LotteryInfo2),
			{ok, LotteryConf2, LotteryState1}
	end.

%% 修改相关的 抽奖信息
update_lottery(LotteryState, LotteryType, LotteryConf, LotteryInfo) ->
	LotteryData = getLotteryData(LotteryState, LotteryType),
	NewServerNum = LotteryData#lottery_data.server_num + 1,
	NewDayNum = LotteryData#lottery_data.day_num + 1,
	%% 如果有记录信息
	case LotteryInfo /= null of
		true ->
			%% 修改记录信息
			NewLotteryInfo = LotteryInfo#db_lottery_box_db{
				day_num = LotteryInfo#db_lottery_box_db.day_num + 1
			},
			lottery_box_db_cache:update(NewLotteryInfo#db_lottery_box_db.lottery_id, NewLotteryInfo),
			NewLotteryInfoList = lists:keyreplace(NewLotteryInfo#db_lottery_box_db.lottery_id, #db_lottery_box_db.lottery_id, LotteryData#lottery_data.lottery_db_list, NewLotteryInfo),
			NewLotteryData = LotteryData#lottery_data{
				lottery_db_list = NewLotteryInfoList,
				server_num = NewServerNum,
				day_num = NewDayNum
			},
			setLotteryData(LotteryState, LotteryType, NewLotteryData);
		_ ->
			%% 添加记录信息
			NewLotteryInfo = #db_lottery_box_db{
				lottery_id = LotteryConf#lottery_box_conf.id,
				day_num = 1,
				ref_time = util_date:get_tomorrow_unixtime()
			},
			lottery_box_db_cache:insert(NewLotteryInfo),
			NewLotteryInfoList = [NewLotteryInfo | LotteryData#lottery_data.lottery_db_list],
			NewLotteryData = LotteryData#lottery_data{
				lottery_db_list = NewLotteryInfoList,
				server_num = NewServerNum
			},
			setLotteryData(LotteryState, LotteryType, NewLotteryData)
	end.

%% 从列表中 随机一个物品
rand_lottery([], {_, _, LotteryInfo, LotteryConf}) ->
	{LotteryInfo, LotteryConf};
rand_lottery([{LotteryConf1, LotteryInfo1} | H], {RdNum, TempNum, LotteryInfo, LotteryConf}) ->
	case LotteryConf /= null of
		true ->
			{LotteryInfo, LotteryConf};
		_ ->
			NewTempSum = TempNum + LotteryConf1#lottery_box_conf.weights,
			case RdNum >= TempNum + 1 andalso RdNum =< NewTempSum of
				true ->
					{LotteryInfo1, LotteryConf1};
				_ ->
					rand_lottery(H, {RdNum, NewTempSum, LotteryInfo, LotteryConf})
			end
	end.

%% 判断服务器相关信息，检查玩家是否能获取该物品信息
get_lottery_server(LotteryType, LotteryConf, LotteryState, Base) ->
	LotteryData = getLotteryData(LotteryState, LotteryType),
	LotterInfo1 = case lists:keyfind(LotteryConf#lottery_box_conf.id, #db_lottery_box_db.lottery_id, LotteryData#lottery_data.lottery_db_list) of
					  false ->
						  %% 没有该物品的抽冲记录
						  null;
					  LotterInfo ->
						  LotterInfo
				  end,
	case
	LotterInfo1 /= null andalso
		LotterInfo1#db_lottery_box_db.day_num >= LotteryConf#lottery_box_conf.day_num andalso
		LotteryConf#lottery_box_conf.day_num /= 0 of
		true ->
			{1, null, null};%% 不能抽取
		_ ->
			RemNum = case LotteryConf#lottery_box_conf.server_num =:= 0 orelse LotteryData#lottery_data.server_num =:= 0 of
						 true ->
							 1;
						 _ ->
							 LotteryData#lottery_data.server_num rem LotteryConf#lottery_box_conf.server_num
					 end,
			case RemNum =:= 0 of
				true ->
					{0, LotterInfo1, LotteryConf};%%如果大于服务器对应的次数 那么直接出改物品
				_ ->
					case LotteryConf#lottery_box_conf.min_num > get_lottery_num(LotteryType, Base) andalso
						LotteryConf#lottery_box_conf.min_num /= 0 of
						true ->
							{1, null, null};%% 不出
						_ ->
							{0, LotterInfo1, null}%% 随机出
					end
			end
	end.

exchange(PlayerState, Id) ->
	#luckdraw_exchange_conf{point = Score, goods = GoodsList, lv = ExchangeLv} = luckdraw_exchange_config:get(Id),
	#db_player_base{lv = Lv, lottery_score_get_1 = ScoreGet, lottery_score_use_1 = ScoreUse}
		= PlayerState#player_state.db_player_base,

	case Lv >= ExchangeLv of
		true ->
			case ScoreGet - ScoreUse >= Score of
				true ->
					case goods_lib_log:add_goods_list(PlayerState, GoodsList, 1) of
						{ok, PlayerState1} ->
							Update = #player_state{
								db_player_base = #db_player_base{
									lottery_score_use_1 = ScoreUse + Score
								}
							},
%% 							DbBase = PlayerState1#player_state.db_player_base,
%% 							NewDbBase = DbBase#db_player_base{lottery_score_use_1 = ScoreUse + Score},
%% 							NewPlayerState = PlayerState1#player_state{db_player_base = NewDbBase},
%% 							{ok, NewPlayerState};
							player_lib:update_player_state(PlayerState1, Update);
						{fail, Reply} ->
							{fail, Reply}
					end;
				false ->
					{fail, ?ERR_SCORE_NOT_ENOUGH}
			end;
		false ->
			{fail, ?ERR_ACTIVE_SERVICE_3}
	end.

%% **************************************************
%% 内部函数
%% **************************************************
%% 添加日志
add_log(LotteryType, PlayerState, GroupNum, LotteryId, GoodsId) ->
	LogInfo = #db_lottery_box_log{
		id = uid_lib:get_uid(?UID_TYPE_LOTTERY_BOX_LOG),
		player_id = PlayerState#player_state.player_id,
		lottery_id = LotteryId,
		lottery_type = LotteryType,
		group_num = GroupNum,
		goods_id = GoodsId,
		time = util_date:unixtime()
	},
	lottery_box_log_db:insert(LogInfo),
	Base = PlayerState#player_state.db_player_base,

	pack_lottery_log(LogInfo, PlayerState#player_state.player_id, Base#db_player_base.name).

%% 发送抽奖信息
send_lottery_log(PId, LogBin) ->
	gen_server2:apply_async(PId, {?MODULE, do_send_lottery_log, [LogBin]}).

%%  发送抽奖信息
do_send_lottery_log(PlayerState, LogBin) ->
	case PlayerState#player_state.is_lottery of
		false ->
			skip;
		_ ->
			net_send:send_one(PlayerState#player_state.socket, LogBin)
	end.


%% 检查抽奖信息
check_lottery_state(LotteryState, LotteryType) ->
	LotteryData = getLotteryData(LotteryState, LotteryType),
	CurTime = util_date:unixtime(),
	case LotteryData#lottery_data.ref_time < CurTime of
		true ->
			TomTime = util_date:get_tomorrow_unixtime(),
			F = fun(X) ->
				LotteryInfo = X#db_lottery_box_db{
					ref_time = TomTime,
					day_num = 0
				},
				lottery_box_db_cache:update(LotteryInfo#db_lottery_box_db.lottery_id, LotteryInfo),
				LotteryInfo
			end,
			NewList = [F(X) || X <- LotteryData#lottery_data.lottery_db_list],
			NewLotteryData = LotteryData#lottery_data{
				ref_time = TomTime,
				day_num = 0,
				lottery_db_list = NewList
			},
			setLotteryData(LotteryState, LotteryType, NewLotteryData);
		_ ->
			LotteryState
	end.

get_lottery_list(LotteryType, Group) ->
	List = lottery_box_config:get_group_list_conf(Group),
	[R || R <- List, R#lottery_box_conf.type =:= LotteryType].

add_lottery_num(?LOTTERY_BOX_TYPE_1, PlayerBase, AddValue) ->
	#db_player_base{
		lottery_score_get_1 = PlayerBase#db_player_base.lottery_score_get_1 + AddValue,
		lottery_num_1 = PlayerBase#db_player_base.lottery_num_1 + AddValue
	};
add_lottery_num(_, PlayerBase, AddValue) ->
	#db_player_base{
		lottery_num = PlayerBase#db_player_base.lottery_num + AddValue
	}.

get_lottery_num(?LOTTERY_BOX_TYPE_1, PlayerBase) -> PlayerBase#db_player_base.lottery_num_1;
get_lottery_num(_, PlayerBase) -> PlayerBase#db_player_base.lottery_num.

getLotteryData(LotteryState, LotteryType) ->
	case LotteryType of
		_ ->
			LotteryState#lottery_state.lottery_shmj
	end.

setLotteryData(LotteryState, LotteryType, LotteryData) ->
	case LotteryType of
		_ ->
			LotteryState#lottery_state{
				lottery_shmj = LotteryData
			}
	end.

getLotteryFunctionId(?LOTTERY_BOX_TYPE_1) -> ?FUNCTION_LOTTERY_SHMJ;
getLotteryFunctionId(_LotteryType) -> ?FUNCTION_LOTTERY.