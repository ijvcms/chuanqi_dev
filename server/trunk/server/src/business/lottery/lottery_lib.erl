%%%-------------------------------------------------------------------
%%% @author yubing
%%% @copyright (C) 2016, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 16. 五月 2016 17:17
%%%-------------------------------------------------------------------
-module(lottery_lib).

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
	do_lottery_begin/3,
	lottery_begin/2,
	get_lottery_log_lists/1,
	do_send_lottery_log/2,
	get_need_consume/1,
	get_lottery_goods_list/1
]).

-define(NEEDJADE, 20).
-define(NEEDJADE10, 180).

init(LotteryState) ->
	DBList = lottery_db_db:select_all(),
	RefTime = case length(DBList) > 0 of
				  true ->
					  [D | _H] = DBList,
					  D#db_lottery_db.ref_time;
				  _ ->
					  util_date:get_tomorrow_unixtime()
			  end,
	%% 转盘抽奖信息
	LotteryData = #lottery_data{
		lottery_db_list = lottery_box_db_db:select_all(),
		server_num = 0,
		day_num = 0,
		ref_time = RefTime
	},
	LotteryState1 = LotteryState#lottery_state{
		lottery_db_list = lottery_db_db:select_all(),
		server_num = 0,
		ref_time = RefTime,
		lottery_shmj = LotteryData
	},
	{ok, LotteryState1}.

%% 获取日志列表
get_lottery_log_lists(GroupNum) ->
	List = lottery_log_db:select_all(GroupNum),
	[get_lottery_log_lists(X, player_id_name_lib:get_player_name(X#db_lottery_log.player_id)) || X <- List].
%% 获取日志信息
get_lottery_log_lists(LotteryLogInfo, Name) ->
	LotteryConf = lottery_config:get(LotteryLogInfo#db_lottery_log.lottery_id),
	[{GoodsId, _, _} | _] = LotteryConf#lottery_conf.goods,
	#proto_lottery_log_info{
		id = LotteryLogInfo#db_lottery_log.id,
		name = Name,
		goods_id = GoodsId
	}.

%% 获取抽奖的物品列表
get_lottery_goods_list(GropNum) ->
	F = fun(X) ->
		LotteryConf = lottery_config:get(X),
		[{GoodsId, IsBind, GoodsNum} | _] = LotteryConf#lottery_conf.goods,
		#proto_lottery_goods_info{
			id = X,
			goods_id = GoodsId,
			is_bind = IsBind,
			num = GoodsNum
		}
	end,
	[F(X) || X <- lottery_config:get_group_list(GropNum)].

%% 开始抽奖
lottery_begin(PlayerState, Num) ->
	case get_need_consume(Num) of%%
		{0, 0, 0, 0, 0, 0, 0} ->
			{fail, ?ERR_ACTIVE_SERVICE_10};
		{GroupNum, NewNum, NeedJade, _, _, _, _} ->
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
								is_lottery_begin = true,
								equip_list = [],
								goods_list = []
							},
							%% 开始抽奖
							{List, PlayerState2} = lottery_begin(NewPlayerState, GroupNum, NewNum, 0, [], [], []),
							NewList = [X#lottery_conf.id || X <- List],
							%% 修改玩家的抽奖次数
							Base = PlayerState#player_state.db_player_base,
							Update = #player_state{
								db_player_base = #db_player_base{
									lottery_num = Base#db_player_base.lottery_num + NewNum
								}
							},
							{ok, PlayerState3} = player_lib:update_player_state(PlayerState2, Update),
							{ok, PlayerState4} = player_lib:incval_on_player_money_log(PlayerState3, #db_player_money.jade, -NeedJade, ?LOG_TYPE_LOTTERY),
							{ok, NewList, PlayerState4#player_state.goods_list, PlayerState4#player_state.equip_list, PlayerState4#player_state{is_lottery_begin = false, goods_list = [], equip_list = []}}
					end
			end
	end.

%% 获取转盘的抽奖信息
get_need_consume(Num) ->
	FunctionConf = function_config:get(?FUNCTION_LOTTERY),
	case function_lib:check_is_open_time(FunctionConf) of%%
		{false, _} ->
			{0, 0, 0, 0, 0, 0, 0};
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

			%% 获取消耗元宝
			{_, NeedJade1} = lists:keyfind(1, 1, ConsumeList1),
			{_, NeedJade10} = lists:keyfind(10, 1, ConsumeList1),

			%% 获取次数
			{NewNum, NeedJade} = case Num > 1 of
									 true ->
										 {10, NeedJade10};
									 _ ->
										 {1, NeedJade1}
								 end,

			{GroupNum, NewNum, NeedJade, NeedJade1, NeedJade10, BeginTime, EndTime}
	end.


%% 开始抽奖 state,分组,最大次数,当前次数,
lottery_begin(PlayerState, _GroupNum, Num, Num, List, NewListLog, NewNoticeList) ->
	case length(NewListLog) > 0 of
		true ->
			Buf = net_send:get_bin(35002, #rep_send_lottery_log_list{log_lists = NewListLog}),
			PlayerList = player_lib:get_online_players(),

			[notice_lib:send_notice(0, ?NOTICE_BACK, [X]) || X <- NewNoticeList],
			[send_lottery_log(X#ets_online.pid, Buf) || X <- PlayerList];
		_ ->
			skip
	end,
	{List, PlayerState};
%% 开始抽奖
lottery_begin(PlayerState, GroupNum, Num, NowNum, List, ListLog, NoticeList) ->
	Base = PlayerState#player_state.db_player_base,
	case gen_server2:apply_sync(misc:whereis_name({local, lottery_mod}), {?MODULE, do_lottery_begin, [GroupNum, Base]}) of
		{ok, LotteryConf2} ->
			%% 添加物品
			{ok, PlayerState1} = goods_lib_log:add_goods_list_and_send_mail(PlayerState, LotteryConf2#lottery_conf.goods, ?LOG_TYPE_LOTTERY),
			NewListLog = case LotteryConf2#lottery_conf.is_log =:= 1 of
							 true ->
								 Log = add_log(PlayerState1, GroupNum, LotteryConf2#lottery_conf.id),
								 [Log | ListLog];
							 _ ->
								 ListLog
						 end,
			NewNoticeList = case LotteryConf2#lottery_conf.is_notice =:= 1 of
								true ->
									%% 全服公告
									NoticeInfo = io_lib:format(LotteryConf2#lottery_conf.notice_info, [util_data:to_list(Base#db_player_base.name), util_data:to_list(LotteryConf2#lottery_conf.name)]),
									[NoticeInfo | NoticeList];
								_ ->
									NoticeList
							end,

			NewList = [LotteryConf2 | List],
			lottery_begin(PlayerState1, GroupNum, Num, NowNum + 1, NewList, NewListLog, NewNoticeList);
		_ ->
			lottery_begin(PlayerState, GroupNum, Num, NowNum + 1, List, ListLog, NoticeList)
	end.

%% 抽奖信息
do_lottery_begin(LotteryState, GroupNum, Base) ->

	NewLotteryState = check_lottery_state(LotteryState),
	F = fun(X, [Sum, List, TempLotteryConf, TempLotteryInfo]) ->
		%% 如果已经有lotteryConf了那么就直接返回
		case TempLotteryConf /= null of
			true ->
				[Sum, List, TempLotteryConf, TempLotteryInfo];
			_ ->
				%% 寻找该抽奖的记录信息
				{Result, LotteryInfo, LotteryConf} = get_lottery_server(X, NewLotteryState, Base),
				case Result /= 0 of
					true ->
						%%如果大于服务器对应的次数 那么直接出改物品
						[Sum, List, TempLotteryConf, TempLotteryInfo];
					_ ->

						NewList = [{X, LotteryInfo} | List],
						NewSum = Sum + X#lottery_conf.weights,
						[NewSum, NewList, LotteryConf, LotteryInfo]
				end
		end
	end,
	%% 获取抽奖内容
	[Sum1, List1, LotteryConf1, LotteryInfo1] = lists:foldr(F, [0, [], null, null], lottery_config:get_group_list_conf(GroupNum)),
	case LotteryConf1 /= null of
		true ->
			LotteryState1 = update_lottery(NewLotteryState, LotteryConf1, LotteryInfo1),
			{ok, LotteryConf1, LotteryState1};
		_ ->
			RdNum = random:uniform(Sum1),
			{LotteryInfo2, LotteryConf2} = rand_lottery(List1, {RdNum, 0, null, null}),
			LotteryState1 = update_lottery(NewLotteryState, LotteryConf2, LotteryInfo2),
			{ok, LotteryConf2, LotteryState1}
	end.

%% 修改相关的 抽奖信息
update_lottery(LotteryState, LotteryConf, LotteryInfo) ->
	NewServerNum = LotteryState#lottery_state.server_num + 1,
	%% 如果有记录信息
	case LotteryInfo /= null of
		true ->
			%% 修改记录信息
			NewLotteryInfo = LotteryInfo#db_lottery_db{
				day_num = LotteryInfo#db_lottery_db.day_num + 1
			},
			lottery_db_cache:update(NewLotteryInfo#db_lottery_db.lottery_id, NewLotteryInfo),
			NewLotteryInfoList = lists:keyreplace(NewLotteryInfo#db_lottery_db.lottery_id, #db_lottery_db.lottery_id, LotteryState#lottery_state.lottery_db_list, NewLotteryInfo),
			LotteryState#lottery_state{
				lottery_db_list = NewLotteryInfoList,
				server_num = NewServerNum
			};
		_ ->
			%% 添加记录信息
			NewLotteryInfo = #db_lottery_db{
				lottery_id = LotteryConf#lottery_conf.id,
				day_num = 1,
				ref_time = util_date:get_tomorrow_unixtime()
			},
			lottery_db_cache:insert(NewLotteryInfo),
			NewLotteryInfoList = [NewLotteryInfo | LotteryState#lottery_state.lottery_db_list],
			LotteryState#lottery_state{
				lottery_db_list = NewLotteryInfoList,
				server_num = NewServerNum
			}
	end.

%% 从列表中 随机一个物品
rand_lottery([], {_, _, LotteryInfo, LotteryConf}) ->
	{LotteryInfo, LotteryConf};
rand_lottery([{LotteryConf1, LotteryInfo1} | H], {RdNum, TempNum, LotteryInfo, LotteryConf}) ->
	case LotteryConf /= null of
		true ->
			{LotteryInfo, LotteryConf};
		_ ->
			NewTempSum = TempNum + LotteryConf1#lottery_conf.weights,
			case RdNum >= TempNum + 1 andalso RdNum =< NewTempSum of
				true ->
					{LotteryInfo1, LotteryConf1};
				_ ->
					rand_lottery(H, {RdNum, NewTempSum, LotteryInfo, LotteryConf})
			end
	end.

%% 判断服务器相关信息，检查玩家是否能获取该物品信息
get_lottery_server(LotteryConf, LotteryState, Base) ->
	LotterInfo1 = case lists:keyfind(LotteryConf#lottery_conf.id, #db_lottery_db.lottery_id, LotteryState#lottery_state.lottery_db_list) of
					  false ->
						  %% 没有该物品的抽冲记录
						  null;
					  LotterInfo ->
						  LotterInfo
				  end,
	case
	LotterInfo1 /= null andalso
		LotterInfo1#db_lottery_db.day_num >= LotteryConf#lottery_conf.day_num andalso
		LotteryConf#lottery_conf.day_num /= 0 of
		true ->
			{1, null, null};%% 不能抽取
		_ ->
			RemNum = case LotteryConf#lottery_conf.server_num =:= 0 of
						 true ->
							 1;
						 _ ->
							 LotteryState#lottery_state.server_num rem LotteryConf#lottery_conf.server_num
					 end,
			case RemNum =:= 0 of
				true ->
					{0, LotterInfo1, LotteryConf};%%如果大于服务器对应的次数 那么直接出改物品
				_ ->
					case LotteryConf#lottery_conf.min_num > Base#db_player_base.lottery_num andalso
						LotteryConf#lottery_conf.min_num /= 0 of
						true ->
							{1, null, null};%% 不出
						_ ->
							{0, LotterInfo1, null}%% 随机出
					end
			end
	end.

%% **************************************************
%% 内部函数
%% **************************************************
%% 添加日志
add_log(PlayerState, GroupNum, LotteryId) ->
	LogInfo = #db_lottery_log{
		id = uid_lib:get_uid(?UID_TYPE_LOTTERY_LOG),
		player_id = PlayerState#player_state.player_id,
		lottery_id = LotteryId,
		group_num = GroupNum,
		time = util_date:unixtime()
	},
	lottery_log_db:insert(LogInfo),
	Base = PlayerState#player_state.db_player_base,

	get_lottery_log_lists(LogInfo, Base#db_player_base.name).

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
check_lottery_state(LotteryState) ->
	CurTime = util_date:unixtime(),
	case LotteryState#lottery_state.ref_time < CurTime of
		true ->
			TomTime = util_date:get_tomorrow_unixtime(),
			F = fun(X) ->
				LotteryInfo = X#db_lottery_db{
					ref_time = TomTime,
					day_num = 0
				},
				lottery_db_cache:update(LotteryInfo#db_lottery_db.lottery_id, LotteryInfo),
				LotteryInfo
			end,
			NewList = [F(X) || X <- LotteryState#lottery_state.lottery_db_list],
			LotteryState#lottery_state{
				ref_time = TomTime,
				lottery_db_list = NewList
			};
		_ ->
			LotteryState
	end.