%%%-------------------------------------------------------------------
%%%-------------------------------------------------------------------
%%%-------------------------------------------------------------------
%%% @author yubing
%%% @copyright (C) 2016, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 05. 一月 2016 14:16
%%%-------------------------------------------------------------------
-module(lottery_pp).


-include("proto.hrl").
-include("record.hrl").
-include("common.hrl").
-include("cache.hrl").
-include("config.hrl").
%% API
-export([handle/3]).

%% 获取抽奖日志
handle(35000, PlayerState, _Data) ->
	{GroupNum, _, _, NeedJade1, NeedJade10, BeginTime, EndTime} = lottery_lib:get_need_consume(1),
	LogList = lottery_lib:get_lottery_log_lists(GroupNum),
	Data1 = #rep_get_lottery_info{
		log_lists = LogList,
		num1_need_jade = NeedJade1,
		num10_need_jade = NeedJade10,
		begin_time = BeginTime,
		end_time = EndTime,
		lottery_goods_list = lottery_lib:get_lottery_goods_list(GroupNum)
	},
	net_send:send_to_client(PlayerState#player_state.socket, 35000, Data1),
	{ok, PlayerState#player_state{is_lottery = true}};

%% 开始抽奖
handle(35001, PlayerState, Data) ->
	Num = Data#req_lottery_begin.num,
	case lottery_lib:lottery_begin(PlayerState, Num) of
		{fail, Err} ->
			net_send:send_to_client(PlayerState#player_state.socket, 35001, #rep_lottery_begin{result = Err});
		{ok, List, GoodsList, EquipList, PlayerState1} ->
			NewData = #rep_lottery_begin{
				result = 0,
				lottery_id_list = List,
				goods_list = GoodsList,
				equip_list = EquipList
			},
			net_send:send_to_client(PlayerState#player_state.socket, 35001, NewData),
			{ok, PlayerState1}
	end;

%% 离开抽奖ui
handle(35003, PlayerState, _Data) ->
	{ok, PlayerState#player_state{is_lottery = false}};

%% 获取神皇秘境抽奖日志
handle(35004, PlayerState, _Data) ->
	{GroupNum, _, NeedJadeList, BeginTime, EndTime} = lottery_box_lib:get_need_consume(?LOTTERY_BOX_TYPE_1, 1),
	AllLogList = lottery_box_lib:get_logs_type(?LOTTERY_BOX_TYPE_1),
	MyLogList = lottery_box_lib:get_logs_me(?LOTTERY_BOX_TYPE_1, PlayerState#player_state.player_id),
	#db_player_base{lottery_score_get_1 = ScoreGet, lottery_score_use_1 = ScoreUse}
		= PlayerState#player_state.db_player_base,
	[NeedJade1, NeedJade5, NeedJade10] = NeedJadeList,

	Data1 = #rep_lottery_info_shmj{
		lottery_score = ScoreGet - ScoreUse,
		all_log_lists = AllLogList,
		my_log_lists = MyLogList,
		num1_need_jade = NeedJade1,
		num5_need_jade = NeedJade5,
		num10_need_jade = NeedJade10,
		begin_time = BeginTime,
		end_time = EndTime,
		group_id = GroupNum
	},
	%%?WARNING("lottery ~p",[Data1]),
	net_send:send_to_client(PlayerState#player_state.socket, 35004, Data1),
	{ok, PlayerState#player_state{is_lottery = true}};

%% 开始神皇秘境抽奖
handle(35005, PlayerState, Data) ->
	Num = Data#req_lottery_begin_shmj.num,
	case lottery_box_lib:lottery_begin(PlayerState, ?LOTTERY_BOX_TYPE_1, Num) of
		{fail, Err} ->
			net_send:send_to_client(PlayerState#player_state.socket, 35005, #rep_lottery_begin_shmj{result = Err});
		{ok, List, GoodsList, EquipList, PlayerState1} ->
			#db_player_base{lottery_score_get_1 = ScoreGet, lottery_score_use_1 = ScoreUse}
				= PlayerState1#player_state.db_player_base,
			NewData = #rep_lottery_begin_shmj{
				result = 0,
				lottery_id_list = List,
				goods_list = GoodsList,
				equip_list = EquipList,
				lottery_score = ScoreGet - ScoreUse
			},
			net_send:send_to_client(PlayerState#player_state.socket, 35005, NewData),
			{ok, PlayerState1}
	end;

%% 神皇秘境抽奖积分兑换物品
handle(35006, PlayerState, Data) ->
	Id = Data#req_lottery_exchange_shmj.id,
	case lottery_box_lib:exchange(PlayerState, Id) of
		{ok, PlayerState1} ->
			#db_player_base{lottery_score_get_1 = ScoreGet, lottery_score_use_1 = ScoreUse}
				= PlayerState1#player_state.db_player_base,
			NewData = #rep_lottery_exchange_shmj{
				result = 0,
				lottery_score = ScoreGet - ScoreUse
			},
			net_send:send_to_client(PlayerState#player_state.socket, 35006, NewData),
			{ok, PlayerState1};
		{fail, Err} ->
			#db_player_base{lottery_score_get_1 = ScoreGet, lottery_score_use_1 = ScoreUse}
				= PlayerState#player_state.db_player_base,
			NewData = #rep_lottery_exchange_shmj{
				result = Err,
				lottery_score = ScoreGet - ScoreUse
			},
			net_send:send_to_client(PlayerState#player_state.socket, 35006, NewData)
	end;

handle(Cmd, PlayerState, Data) ->
	?ERR("not define ~p cmd:~nstate: ~p~ndata: ~p", [Cmd, PlayerState, Data]),
	{ok, PlayerState}.

