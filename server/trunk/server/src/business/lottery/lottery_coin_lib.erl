%%%-------------------------------------------------------------------
%%% @author yubing
%%% @copyright (C) 2016, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 16. 五月 2016 17:17
%%%-------------------------------------------------------------------
-module(lottery_coin_lib).

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
	do_lottery_begin/2,
	lottery_begin/2,
	get_lottery_log_lists/1,
	do_send_lottery_log/2
]).

-define(NEEDCOIN, 100000).
-define(NEEDCOIN10, 1000000).

init(LotteryState) ->
	DBList = lottery_coin_db_db:select_all(),
	RefTime = case length(DBList) > 0 of
				  true ->
					  [D | _H] = DBList,
					  D#db_lottery_coin_db.ref_time;
				  _ ->
					  util_date:get_tomorrow_unixtime()
			  end,

	LotteryState1 = LotteryState#lottery_state{
		lottery_coin_db_list = lottery_coin_db_db:select_all(),
		server_coin_num = 0,
		ref_coin_time = RefTime
	},
	{ok, LotteryState1}.


%% 获取日志列表
get_lottery_log_lists(Id) ->
	List = lottery_coin_log_db:select_all(Id),
	[get_lottery_log_lists(X, player_id_name_lib:get_player_name(X#db_lottery_coin_log.player_id)) || X <- List].
%% 获取日志信息
get_lottery_log_lists(LotteryLogInfo, Name) ->
	LogtteryConf = lottery_coin_config:get(LotteryLogInfo#db_lottery_coin_log.lottery_coin_id),
	[{GoodsId, _, _} | _] = LogtteryConf#lottery_coin_conf.goods,
	#proto_lottery_log_info{
		id = LotteryLogInfo#db_lottery_coin_log.id,
		name = Name,
		goods_id = GoodsId
	}.

%% 开始抽奖
lottery_begin(PlayerState, Num) ->
	DbMoney = PlayerState#player_state.db_player_money,
	{NeedCoin, NewNum} = case Num > 1 of
							 true ->
								 {?NEEDCOIN10, 10};
							 _ ->
								 {?NEEDCOIN, 1}
						 end,
	UseBagNum = goods_lib:get_free_bag_num(PlayerState),
	case UseBagNum =:= 0 of
		true ->
			{fail, ?ERR_PLAYER_BAG_NOT_ENOUGH};
		_ ->
			case DbMoney#db_player_money.coin < NeedCoin of
				true ->
					{fail, ?ERR_PLAYER_COIN_NOT_ENOUGH};
				_ ->
					NewPlayerState = PlayerState#player_state{
						is_lottery_begin = true,
						equip_list = [],
						goods_list = []
					},
					%% 开始抽奖
					{List, PlayerState2} = lottery_begin(NewPlayerState, NewNum, 0, [], [], []),
					NewList = [X#lottery_coin_conf.id || X <- List],
					%% 修改玩家的抽奖次数
					Base = PlayerState#player_state.db_player_base,
					Update = #player_state{
						db_player_base = #db_player_base{
							lottery_coin_num = Base#db_player_base.lottery_coin_num + NewNum
						}
					},
					{ok, PlayerState3} = player_lib:update_player_state(PlayerState2, Update),
					{ok, PlayerState4} = player_lib:incval_on_player_money_log(PlayerState3, #db_player_money.coin, -NeedCoin, ?LOG_TYPE_LOTTERY_COIN),
					{ok, NewList, PlayerState4#player_state.goods_list, PlayerState4#player_state.equip_list, PlayerState4#player_state{is_lottery_begin = false, goods_list = [], equip_list = []}}
			end
	end.

%% 开始抽奖
lottery_begin(PlayerState, Num, Num, List, NewListLog, NewNoticeList) ->
	case length(NewListLog) > 0 of
		true ->
			Buf = net_send:get_bin(36002, #rep_send_lottery_coin_log_list{log_lists = NewListLog}),
			PlayerList = player_lib:get_online_players(),

			[notice_lib:send_notice(0, ?NOTICE_BACK, [X]) || X <- NewNoticeList],
			[send_lottery_log(X#ets_online.pid, Buf) || X <- PlayerList];
		_ ->
			skip
	end,
	{List, PlayerState};
%% 开始抽奖
lottery_begin(PlayerState, Num, NowNum, List, ListLog, NoticeList) ->
	Base = PlayerState#player_state.db_player_base,
	case gen_server2:apply_sync(misc:whereis_name({local, lottery_mod}), {?MODULE, do_lottery_begin, [Base]}) of
		{ok, LotteryConf2} ->
			%% 添加物品
			{ok, PlayerState1} = goods_lib_log:add_goods_list_and_send_mail(PlayerState, LotteryConf2#lottery_coin_conf.goods, ?LOG_TYPE_LOTTERY_COIN),
			NewListLog = case LotteryConf2#lottery_coin_conf.is_log =:= 1 of
							 true ->
								 Log = add_log(PlayerState1, LotteryConf2#lottery_coin_conf.id),
								 [Log | ListLog];
							 _ ->
								 ListLog
						 end,
			NewNoticeList = case LotteryConf2#lottery_coin_conf.is_notice =:= 1 of
								true ->
									%% 全服公告
									NoticeInfo = io_lib:format(LotteryConf2#lottery_coin_conf.notice_info, [util_data:to_list(Base#db_player_base.name), util_data:to_list(LotteryConf2#lottery_coin_conf.name)]),
									[NoticeInfo | NoticeList];
								_ ->
									NoticeList
							end,

			NewList = [LotteryConf2 | List],
			lottery_begin(PlayerState1, Num, NowNum + 1, NewList, NewListLog, NewNoticeList);
		_ ->
			lottery_begin(PlayerState, Num, NowNum + 1, List, ListLog, NoticeList)
	end.

%% 抽奖信息
do_lottery_begin(LotteryState, Base) ->

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
						%% 加入抽奖列表
						NewList = [{X, LotteryInfo} | List],
						%% 抽奖权重
						NewSum = Sum + X#lottery_coin_conf.weights,
						[NewSum, NewList, LotteryConf, LotteryInfo]
				end
		end
	end,
	%% 获取抽奖内容
	[Sum1, List1, LotteryConf1, LotteryInfo1] = lists:foldr(F, [0, [], null, null], lottery_coin_config:get_list_conf()),
	case LotteryConf1 /= null of
		true ->
			LotteryState1 = update_lottery(NewLotteryState, LotteryConf1, LotteryInfo1),
			{ok, LotteryConf1, LotteryState1};
		_ ->
			RdNum = random:uniform(Sum1),
			%% 获取抽奖物品
			{LotteryInfo2, LotteryConf2} = rand_lottery(List1, {RdNum, 0, null, null}),
			LotteryState1 = update_lottery(NewLotteryState, LotteryConf2, LotteryInfo2),
			{ok, LotteryConf2, LotteryState1}
	end.

%% 修改相关的 抽奖信息
update_lottery(LotteryState, LotteryConf, LotteryInfo) ->
	NewServerNum = LotteryState#lottery_state.server_coin_num + 1,
	%% 如果有记录信息
	case LotteryInfo /= null of
		true ->
			%% 修改记录信息
			NewLotteryInfo = LotteryInfo#db_lottery_coin_db{
				day_num = LotteryInfo#db_lottery_coin_db.day_num + 1
			},
			lottery_coin_db_cache:update(NewLotteryInfo#db_lottery_coin_db.lottery_coin_id, NewLotteryInfo),
			NewLotteryInfoList = lists:keyreplace(NewLotteryInfo#db_lottery_coin_db.lottery_coin_id, #db_lottery_coin_db.lottery_coin_id, LotteryState#lottery_state.lottery_coin_db_list, NewLotteryInfo),
			LotteryState#lottery_state{
				lottery_coin_db_list = NewLotteryInfoList,
				server_coin_num = NewServerNum
			};
		_ ->
			%% 添加记录信息
			NewLotteryInfo = #db_lottery_coin_db{
				lottery_coin_id = LotteryConf#lottery_coin_conf.id,
				day_num = 1,
				ref_time = util_date:get_tomorrow_unixtime()
			},
			lottery_coin_db_cache:insert(NewLotteryInfo),
			NewLotteryInfoList = [NewLotteryInfo | LotteryState#lottery_state.lottery_coin_db_list],
			LotteryState#lottery_state{
				lottery_coin_db_list = NewLotteryInfoList,
				server_coin_num = NewServerNum
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
			NewTempSum = TempNum + LotteryConf1#lottery_coin_conf.weights,
			%% 抽奖
			case RdNum >= TempNum + 1 andalso RdNum =< NewTempSum of
				true ->
					{LotteryInfo1, LotteryConf1};
				_ ->
					%% 抽奖
					rand_lottery(H, {RdNum, NewTempSum, LotteryInfo, LotteryConf})
			end
	end.

%% 判断服务器相关信息，检查玩家是否能获取该物品信息
get_lottery_server(LotteryConf, LotteryState, Base) ->
	LotterInfo1 = case lists:keyfind(LotteryConf#lottery_coin_conf.id, #db_lottery_coin_db.lottery_coin_id, LotteryState#lottery_state.lottery_coin_db_list) of
					  false ->
						  %% 没有该物品的抽冲记录
						  null;
					  LotterInfo ->
						  LotterInfo
				  end,
	case
	LotterInfo1 /= null andalso
		LotterInfo1#db_lottery_coin_db.day_num >= LotteryConf#lottery_coin_conf.day_num andalso
		LotteryConf#lottery_coin_conf.day_num /= 0 of
		true ->
			{1, null, null};%% 不能抽取
		_ ->
			RemNum = case LotteryConf#lottery_coin_conf.server_num =:= 0 of
						 true ->
							 1;
						 _ ->
							 LotteryState#lottery_state.server_coin_num rem LotteryConf#lottery_coin_conf.server_num
					 end,
			case RemNum =:= 0 of
				true ->
					{0, LotterInfo1, LotteryConf};%%如果大于服务器对应的次数 那么直接出改物品
				_ ->
					case LotteryConf#lottery_coin_conf.min_num > Base#db_player_base.lottery_coin_num andalso
						LotteryConf#lottery_coin_conf.min_num /= 0 of
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
add_log(PlayerState, LotteryId) ->
	LogInfo = #db_lottery_coin_log{
		id = uid_lib:get_uid(?UID_TYPE_LOTTERY_COIN_LOG),
		player_id = PlayerState#player_state.player_id,
		lottery_coin_id = LotteryId,
		time = util_date:unixtime()
	},
	lottery_coin_log_db:insert(LogInfo),
	Base = PlayerState#player_state.db_player_base,

	get_lottery_log_lists(LogInfo, Base#db_player_base.name).

%% 发送抽奖信息
send_lottery_log(PId, LogBin) ->
	gen_server2:apply_async(PId, {?MODULE, do_send_lottery_log, [LogBin]}).

%%  发送抽奖信息
do_send_lottery_log(PlayerState, LogBin) ->
	case PlayerState#player_state.is_coin_lottery of
		false ->
			skip;
		_ ->
			net_send:send_one(PlayerState#player_state.socket, LogBin)
	end.


%% 检查抽奖信息
check_lottery_state(LotteryState) ->
	CurTime = util_date:unixtime(),
	case LotteryState#lottery_state.ref_coin_time < CurTime of
		true ->
			TomTime = util_date:get_tomorrow_unixtime(),
			F = fun(X) ->
				LotteryInfo = X#db_lottery_coin_db{
					ref_time = TomTime,
					day_num = 0
				},
				lottery_coin_db_cache:update(LotteryInfo#db_lottery_coin_db.lottery_coin_id, LotteryInfo),
				LotteryInfo
			end,
			NewList = [F(X) || X <- LotteryState#lottery_state.lottery_coin_db_list],
			LotteryState#lottery_state{
				ref_coin_time = TomTime,
				lottery_coin_db_list = NewList
			};
		_ ->
			LotteryState
	end.