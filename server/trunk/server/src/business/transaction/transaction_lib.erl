%%%-------------------------------------------------------------------
%%% @author tuhujia
%%% @copyright (C) 2015, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 03. 十二月 2015 11:04
%%%-------------------------------------------------------------------
-module(transaction_lib).

-include("common.hrl").
-include("record.hrl").
-include("proto.hrl").
-include("cache.hrl").
-include("db_record.hrl").
-include("config.hrl").
-include("uid.hrl").
-include("language_config.hrl").
-include("log_type_config.hrl").

%% API
-export([
	apply_trade/2,
	trade_feedback/5,
	clearn_player_trade/1,
	change_trade_info/3,
	confirm_trade/1,
	succ_trade/3,
	do_get_trade_state/1,
	get_trade_state/1,
	do_update_trade_state/1,
	update_trade_state/1
]).

-define(ERR_ALREADY_COFIRM, 21113).        %% 已经确认交易
-define(MAX_TRADE_NUM, 4).                %% 最大交易数量
-define(TRADE_STATE_START, 0).            %% 交易中
-define(TRADE_STATE_LOCK, 1).            %% 锁定状态
-define(TRADE_STATE_ALREADY, 2).        %% 确认交易

%% ====================================================================
%% API functions
%% ====================================================================

%% 申请交易
apply_trade(PlayerState, PlayerIdB) ->
	case check_trade_cond(PlayerState, PlayerIdB) of
		{ok, _} ->
			DbBase = PlayerState#player_state.db_player_base,
			PlayerId = PlayerState#player_state.player_id,
			Name = DbBase#db_player_base.name,
			Lv = DbBase#db_player_base.lv,
			Proto = #rep_trade_invite{
				player_id = PlayerId,
				player_name = Name,
				player_lv = Lv
			},
			net_send:send_to_client(PlayerIdB, 20002, Proto),
			{ok, PlayerState#player_state{is_transaction = 1}};
		{fail, Reply} ->
			{fail, Reply}
	end.


update_trade_state(Pid) when is_pid(Pid) ->
	gen_server2:apply_async(Pid, {?MODULE, do_update_trade_state, []});
update_trade_state(PlayerId) ->
	case player_lib:get_player_pid(PlayerId) of
		null ->
			0;
		Pid ->
			update_trade_state(Pid)
	end.
do_update_trade_state(PlayerState) ->
	{ok, PlayerState#player_state{is_transaction = 0}}.

%% 玩家B反馈交易请求
trade_feedback(PlayerState, PlayerIdA, NameA, LvA, Type) ->
	case get_trade_state(PlayerIdA) of
		true ->
			update_trade_state(PlayerIdA),
			case Type of
				0 ->  %% 拒绝
					net_send:send_to_client(PlayerIdA, 20001, #rep_apply_trade{result = ?ERR_PLAYERB_REFUSE_TRADE});
				1 ->  %% 同意
					case check_trade_cond(PlayerState, PlayerIdA) of
						{ok, _} ->
							DbBase = PlayerState#player_state.db_player_base,
							Name = DbBase#db_player_base.name,
							Lv = DbBase#db_player_base.lv,
							PlayerId = PlayerState#player_state.player_id,
							Data = #rep_trade_feedback{result = ?ERR_COMMON_SUCCESS, player_name = NameA, player_lv = LvA},
							DataA = #rep_apply_trade{result = ?ERR_COMMON_SUCCESS, player_name = Name, player_lv = Lv},
							creat_trade_record(PlayerId, PlayerIdA),
							net_send:send_to_client(PlayerIdA, 20001, DataA),
							net_send:send_to_client(PlayerState#player_state.socket, 20003, Data);
						{fail, Reply} ->
							net_send:send_to_client(PlayerState#player_state.socket, 20003, #rep_trade_feedback{result = Reply})
					end
			end;
		_ ->
			skip
	end.


%% 取消交易
clearn_player_trade(PlayerId) ->
	case ets:lookup(?ETS_TRANSACTION, PlayerId) of
		[Trans] ->
			PlayerIdB = Trans#ets_transaction.player_idB,
			ets:delete(?ETS_TRANSACTION, PlayerId),
			ets:delete(?ETS_TRANSACTION, PlayerIdB),
			case PlayerIdB > 0 of
				true ->
					net_send:send_to_client(PlayerIdB, 20008, #rep_fail_trade{result = ?ERR_COMMON_FAIL});
				false ->
					skip
			end,
			{ok, ?ERR_COMMON_SUCCESS};
		_ ->
			{fail, ?ERR_COMMON_FAIL}
	end.

%% 交易数据校验
change_trade_info(PlayerState, Jade, TradeList) ->
	case check_trade_cond(PlayerState, Jade, TradeList) of
		{ok, PlayerIdB, ProtoList, GoodsInfoList} ->
			PlayerId = PlayerState#player_state.player_id,
			save_trade_item(PlayerId, Jade, GoodsInfoList),
			net_send:send_to_client(PlayerIdB, 20006, #rep_b_trade_info{jade = Jade, goods_list = ProtoList}),
			{ok, ?ERR_COMMON_SUCCESS};
		{fail, Reply} ->
			{fail, Reply}
	end.

%% 确认交易
confirm_trade(PlayerState) ->
	case check_confirm_trade(PlayerState) of
		{ok, TradeInfoA} ->
			%% 检测对方玩家是否确认交易
			PlayerIdB = TradeInfoA#ets_transaction.player_idB,
			case get_trade_record_from_ets(PlayerIdB) of
				[] ->
					clearn_player_trade(PlayerState),
					{fail, ?ERR_COMMON_FAIL};
				TradeInfoB ->
					case TradeInfoB#ets_transaction.status =:= ?TRADE_STATE_ALREADY of
						true ->
							executive_trade(PlayerState, TradeInfoA, TradeInfoB);
						false ->
							%% 单方确认交易成功 更新交易状态
							PlayerId = PlayerState#player_state.player_id,
							update_trade_record(PlayerId, #ets_transaction.status, ?TRADE_STATE_ALREADY),
							{ok, ?ERR_COMMON_SUCCESS}
					end
			end;
		{fail, ?ERR_ALREADY_COFIRM} ->
			skip;
		{fail, Reply} ->
			clearn_player_trade(PlayerState),
			{fail, Reply}
	end.

%% 执行交易
executive_trade(PlayerState, TradeInfoA, TradeInfoB) ->
	PlayerIdA = TradeInfoA#ets_transaction.player_idA,
	PlayerIdB = TradeInfoB#ets_transaction.player_idA,
	NeedJadeA = TradeInfoA#ets_transaction.jade,
	NeedJadeB = TradeInfoB#ets_transaction.jade,
	NeedGoodsListA = TradeInfoA#ets_transaction.goods_list,
	NeedGoodsListB = TradeInfoB#ets_transaction.goods_list,

	case util:loop_functions(
		none,
		[fun(_) ->
			case NeedGoodsListA == [] andalso NeedGoodsListB == []
				andalso NeedJadeA == 0 andalso NeedJadeB == 0 of
				true ->
					{break, ?ERR_COMMON_FAIL};
				false ->
					{continue, none}
			end
		end,
			fun(_) ->
				%% 检测自己背包是否足够
				DbBase = PlayerState#player_state.db_player_base,
				AllCell = DbBase#db_player_base.bag,
				UseCell = goods_dict:get_bag_cell(),
				Cell = AllCell - UseCell,
				case Cell >= length(NeedGoodsListB) of
					true ->
						{continue, none};
					false ->
						{break, ?ERR_PLAYER_BAG_NOT_ENOUGH}
				end
			end,
			fun(_) ->
				case player_lib:get_player_pid(PlayerIdB) of
					null ->
						clean_both_trans(PlayerIdA, PlayerIdB),
						{break, ?ERR_PLAYER_LOGOUT};
					PlayerPid ->
						[CellB, JadeB, GoodsListB] = gen_server2:call(PlayerPid, {get_trade_info}),
						{continue, [CellB, JadeB, GoodsListB]}
				end
			end,
			fun([CellB, JadeB, GoodsListB]) ->
				case check_goods_exsit(NeedGoodsListB, GoodsListB) of
					true ->
						{continue, [CellB, JadeB]};
					false ->
						{break, ?ERR_COMMON_FAIL}
				end
			end,
			fun([CellB, JadeB]) ->
				case CellB >= length(NeedGoodsListA) of
					true ->
						{continue, JadeB};
					false ->
						{break, ?ERR_COMMON_FAIL}
				end
			end,
			fun(JadeB) ->
				case JadeB >= NeedJadeB + ?TRADE_SPEND_JADE of
					true ->
						{continue, none};
					false ->
						{break, ?ERR_COMMON_FAIL}
				end
			end
		]) of
		{break, Reply} ->
			clearn_player_trade(PlayerIdA),
			{fail, Reply};
		{ok, _Value} ->
			case player_lib:get_player_pid(PlayerIdB) of
				null ->
					clean_both_trans(PlayerIdA, PlayerIdB),
					{fail, ?ERR_PLAYER_LOGOUT};
				PlayerPid ->
					log_lib:log_trade(TradeInfoA, TradeInfoB),

					%% 交易成功  发送给对方进程处理
					gen_server2:cast(PlayerPid, {trade_success, {NeedJadeA, NeedJadeB}, {NeedGoodsListA, NeedGoodsListB}}),
					%% 交易成功数据处理
					succ_trade(PlayerState, NeedJadeB, NeedGoodsListB)
			end
	end.

%% 交易成功数据处理
succ_trade(PlayerState, {GetJade, DeletJade}, {GetGoodsList, DelGoodsList}) ->
	PlayerId = PlayerState#player_state.player_id,
	DeletGoodsList = change_trade_dele_goods_list(DelGoodsList),
	goods_lib_log:delete_goods_list_by_id_and_num(PlayerState, DeletGoodsList, ?LOG_TYPE_TRADE),
	[goods_lib_log:add_goods_by_goods_info(PlayerState, GoodsInfo, ?LOG_TYPE_TRADE) || GoodsInfo <- GetGoodsList],
	{ok, PlayerState1} = player_lib:incval_on_player_money_log(PlayerState, #db_player_money.jade, GetJade - ?TRADE_SPEND_JADE - DeletJade, ?LOG_TYPE_TRADE),
	%% 通知交易成功
	ets:delete(?ETS_TRANSACTION, PlayerId),
	net_send:send_to_client(PlayerState#player_state.socket, 20009, #rep_success_trade{result = ?ERR_COMMON_SUCCESS}),
	{ok, PlayerState1};
%% 交易成功数据处理
succ_trade(PlayerState, GetJade, GetGoodsList) ->
	PlayerId = PlayerState#player_state.player_id,
	TradeRecord = get_trade_record_from_ets(PlayerId),
	DeletJade = TradeRecord#ets_transaction.jade,
	succ_trade(PlayerState, {GetJade, DeletJade}, {GetGoodsList, TradeRecord#ets_transaction.goods_list}).


%% ====================================================================
%% 内部函数
%% ====================================================================
check_trade_cond(PlayerState, PlayerIdB) ->
	case util:loop_functions(
		none,
		[fun(_) ->
			DbMoney = PlayerState#player_state.db_player_money,
			case DbMoney#db_player_money.jade >= ?TRADE_SPEND_JADE of
				true ->
					{continue, none};
				false ->
					{break, ?ERR_PLAYER_JADE_NOT_ENOUGH}
			end
		end,
			fun(_) ->
				case player_lib:get_player_pid(PlayerIdB) of
					null ->
						clean_both_trans(PlayerState#player_state.player_id, PlayerIdB),
						{break, ?ERR_PLAYER_LOGOUT};
					_ ->
						{continue, none}
				end
			end,
			fun(_) ->
				case get_trade_record_from_ets(PlayerIdB) of
					[] ->
						{continue, none};
					_ ->
						{break, ?ERR_PLAYER_TRADEING}
				end
			end,
			fun(_) ->
				PlayerId = PlayerState#player_state.player_id,
				case get_trade_record_from_ets(PlayerId) of
					[] ->
						{continue, none};
					_ ->
						{break, ?ERR_PLAYER_TRADEING}
				end
			end,
			fun(_) ->

				case player_base_cache:select_row(PlayerIdB) of
					#db_player_base{} = DPB ->
						SceneId = PlayerState#player_state.scene_id,
						case DPB#db_player_base.scene_id == SceneId of
							true -> {continue, none};
							false -> {break, ?ERR_SAME_SCENCE_CAN_NOT_TRADE}
						end;
					_ ->
						{break, ?ERR_COMMON_FAIL}
				end
			end
		]) of
		{break, Reply} -> {fail, Reply};
		{ok, Value} ->
			{ok, Value}
	end.

%% 交易数据校验
check_trade_cond(PlayerState, Jade, TradeList) ->
	case util:loop_functions(
		none,
		[fun(_) ->
			case length(TradeList) =< ?MAX_TRADE_NUM of
				true ->
					{continue, none};
				false ->
					{break, ?ERR_COMMON_FAIL}
			end
		end,
			fun(_) ->
				DbMoney = PlayerState#player_state.db_player_money,
				case DbMoney#db_player_money.jade >= Jade + ?TRADE_SPEND_JADE of
					true ->
						{continue, none};
					false ->
						{break, ?ERR_PLAYER_JADE_NOT_ENOUGH}
				end
			end,
			fun(_) ->
				PlayerId = PlayerState#player_state.player_id,
				case get_trade_record_from_ets(PlayerId) of
					[] ->
						{break, ?ERR_COMMON_FAIL};
					R ->
						case R#ets_transaction.status =:= ?TRADE_STATE_START of
							true ->
								{continue, R#ets_transaction.player_idB};
							false ->
								{break, ?ERR_COMMON_FAIL}
						end
				end
			end,
			fun(PlayerIdB) ->
				case check_goods_exsit(TradeList) of
					false ->
						{break, ?ERR_GOODS_NOT_ENOUGH};
					[ProtoList, GoodsInfoList] ->
						{continue, {PlayerIdB, ProtoList, GoodsInfoList}}
				end
			end
		]) of
		{break, Reply} -> {fail, Reply};
		{ok, {A, B, C}} ->
			{ok, A, B, C}
	end.

%% 检测确认交易
check_confirm_trade(PlayerState) ->
	case util:loop_functions(
		none,
		[fun(_) ->
			PlayerId = PlayerState#player_state.player_id,
			case get_trade_record_from_ets(PlayerId) of
				[] ->
					{break, ?ERR_COMMON_FAIL};
				TradeInfo ->
					case TradeInfo#ets_transaction.status =:= ?TRADE_STATE_LOCK of
						true ->
							{continue, TradeInfo};
						false ->
							case TradeInfo#ets_transaction.status =:= ?TRADE_STATE_ALREADY of
								true ->
									{break, ?ERR_ALREADY_COFIRM};
								false ->
									{break, ?ERR_COMMON_FAIL}
							end
					end
			end
		end,
			fun(TradeInfo) ->
				DbMoney = PlayerState#player_state.db_player_money,
				case DbMoney#db_player_money.jade >= TradeInfo#ets_transaction.jade + ?TRADE_SPEND_JADE of
					true ->
						{continue, TradeInfo};
					false ->
						{break, ?ERR_PLAYER_JADE_NOT_ENOUGH}
				end
			end,
			fun(TradeInfo) ->
				case check_goods_exsit_bool(TradeInfo#ets_transaction.goods_list) of
					false ->
						{break, ?ERR_GOODS_NOT_ENOUGH};
					true ->
						{continue, TradeInfo}
				end
			end
		]) of
		{break, Reply} -> {fail, Reply};
		{ok, Value} ->
			{ok, Value}
	end.

%% 获取玩家交易记录
get_trade_record_from_ets(PlayerId) ->
	case ets:lookup(?ETS_TRANSACTION, PlayerId) of
		[R | _] ->
			R;
		_ ->
			[]
	end.

%% 交易道具保存
save_trade_item(PlayerId, Jade, TradeList) ->
	ets:update_element(?ETS_TRANSACTION, PlayerId, [{#ets_transaction.jade, Jade},
		{#ets_transaction.goods_list, TradeList},
		{#ets_transaction.status, ?TRADE_STATE_LOCK}]).

%% 更新交易记录
update_trade_record(PlayerId, Pos, Value) ->
	ets:update_element(?ETS_TRANSACTION, PlayerId, {Pos, Value}).

%% 创建交易记录
creat_trade_record(PlayerIdA, PlayerIdB) ->
	ets:insert(?ETS_TRANSACTION, #ets_transaction{player_idA = PlayerIdA, player_idB = PlayerIdB}),
	ets:insert(?ETS_TRANSACTION, #ets_transaction{player_idA = PlayerIdB, player_idB = PlayerIdA}).

%% 检测道具是否存在
check_goods_exsit(TradeList) ->
	GoodsList = goods_lib:get_goods_list(?NORMAL_LOCATION_TYPE, ?NOT_BIND),
	check_goods_exsit(TradeList, GoodsList, [], []).
check_goods_exsit([], _GoodsList, ProtoList, GoodsInfoList) ->
	[ProtoList, GoodsInfoList];
check_goods_exsit([H | T], GoodsList, ProtoList, GoodsInfoList) ->
	Id = H#proto_trade_list.id,
	Num = H#proto_trade_list.num,
	case lists:keyfind(Id, #db_goods.id, GoodsList) of
		false -> false;
		GoodsInfo ->
			case GoodsInfo#db_goods.num >= Num andalso Num > 0 of
				true ->
					Proto = change_proto_goods_info(GoodsInfo, Num),
					ProtoList1 = [Proto] ++ ProtoList,
					GoodsInfoList1 = [GoodsInfo#db_goods{num = Num}] ++ GoodsInfoList,
					check_goods_exsit(T, GoodsList, ProtoList1, GoodsInfoList1);
				false ->
					false
			end
	end.

check_goods_exsit_bool(TradeList) ->
	GoodsList = goods_lib:get_goods_list(?NORMAL_LOCATION_TYPE, ?NOT_BIND),
	check_goods_exsit(TradeList, GoodsList).
check_goods_exsit([], _GoodsList) ->
	true;
check_goods_exsit([H | T], GoodsList) ->
	Id = H#db_goods.id,
	Num = H#db_goods.num,
	case lists:keyfind(Id, #db_goods.id, GoodsList) of
		false -> false;
		GoodsInfo ->
			case GoodsInfo#db_goods.num >= Num of
				true ->
					check_goods_exsit(T, GoodsList);
				false ->
					false
			end
	end.

%% 转换成proto道具信息
change_proto_goods_info(DbGoods, Num) ->
	GoodsId = DbGoods#db_goods.goods_id,
	case goods_lib:check_is_equips_by_id(GoodsId) of
		true ->
			Extra = DbGoods#db_goods.extra,
			BaptizeAttrList = equips_baptize:get_equips_baptize_attr(Extra),
			#proto_goods_full_info{
				id = DbGoods#db_goods.id,
				goods_id = DbGoods#db_goods.goods_id,
				is_bind = DbGoods#db_goods.is_bind,
				num = Num,
				stren_lv = DbGoods#db_goods.stren_lv,
				location = DbGoods#db_goods.location,
				grid = DbGoods#db_goods.grid,
				baptize_attr_list = goods_util:attr_type_list_changed_proto_list(BaptizeAttrList),
				soul = DbGoods#db_goods.soul,
				luck = goods_util:get_equips_luck(DbGoods),
				secure = DbGoods#db_goods.secure
			};
		false ->
			#proto_goods_full_info{
				id = DbGoods#db_goods.id,
				goods_id = DbGoods#db_goods.goods_id,
				is_bind = DbGoods#db_goods.is_bind,
				num = Num,
				stren_lv = DbGoods#db_goods.stren_lv,
				location = DbGoods#db_goods.location,
				grid = DbGoods#db_goods.grid,
				secure = DbGoods#db_goods.secure
			}
	end.

%% 清除双方的交易数据
clean_both_trans(PlayerIdA, PlayerIdB) ->
	ets:delete(?ETS_TRANSACTION, PlayerIdA),
	ets:delete(?ETS_TRANSACTION, PlayerIdB),
	ok.

%% 道具列表转换
change_trade_dele_goods_list(TradeList) ->
	Fun = fun(GoodsInfo) ->
		{GoodsInfo#db_goods.id,
			GoodsInfo#db_goods.goods_id,
			GoodsInfo#db_goods.num}
	end,
	[Fun(X) || X <- TradeList].

%% 获取交易的状态信息
get_trade_state(Pid) when is_pid(Pid) ->
	case gen_server2:apply_sync(Pid, {?MODULE, do_get_trade_state, []}) of
		{ok, 1} ->
			true;
		_ERR ->
			false
	end;
get_trade_state(PlayerId) ->
	case player_lib:get_player_pid(PlayerId) of
		null ->
			0;
		Pid ->
			get_trade_state(Pid)
	end.
do_get_trade_state(PlayerState) ->
	{ok, PlayerState#player_state.is_transaction}.