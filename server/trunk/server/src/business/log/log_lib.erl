%%%-------------------------------------------------------------------
%%% @author yubing
%%% @copyright (C) 2016, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 30. 三月 2016 11:11
%%%-------------------------------------------------------------------
-module(log_lib).


-include("common.hrl").
-include("record.hrl").
-include("config.hrl").
-include("cache.hrl").
-include("db_record.hrl").
-include("uid.hrl").
-include("proto.hrl").
-include("language_config.hrl").

%% API
-export([
	log_money_inster/5,
	log_del_account/3,
	log_chat/3,
	log_trade/2,
	log_buy/5,
	log_goods_change/4,
	log_goods_change/5,
	log_goods_attr_change/5,
	log_fight_player_change/3,
	log_fight_goods_change/5,
	log_fight_change/5,
	log_reputation/3,
	log_drop/5,
	log_login/7,
	log_mail/10,
	log_daily/4,
	log_daily/5,
	log_activity/2,
	log_insurance/4,
	log_shop_once/4
]).

%% Gen API
-export([
	do_log_inster/2,
	log_chat_local/3,
	log_trade_local/2,
	log_buy_local/5,
	log_goods_attr_change_local/5,
	log_fight_player_change_local/3,
	log_fight_goods_change_local/5,
	log_reputation_local/3,
	log_drop_local/6,
	log_login_local/7,
	log_mail_local/10,
	log_daily_local/5,
	log_exp_inster/4,
	get_type/1,
	log_activity_local/2,
	log_insurance_local/4,
	log_shop_once_local/4
]).

%% 多少经验开始记录玩家获得的经验
-define(MAX_EXP_LOG, 5000).

log_money_inster(PlayerId, Key, Num, NewNum, Type) ->
	case Num /= 0 of
		true ->
			LogMoneyInfo = #db_log_money{
				player_id = PlayerId,
				key = Key,
				num = Num,
				current_num = NewNum,
				type = Type,
				time = util_date:unixtime()
			},
			log_inster(LogMoneyInfo);
		_ ->
			skip
	end.

log_del_account(OpenId, Platform, PlayerId) ->
	LogAccountInfo = #db_log_account{
		open_id = OpenId,
		platform = Platform,
		player_id = PlayerId,
		time = util_date:unixtime()
	},
	log_inster(LogAccountInfo).

%% 添加经验值
log_exp_inster(PlayerState, NewPlayerStatem, {Reason, Message}, Exp) ->
	case PlayerState#player_state.is_robot /= 1 andalso Exp > ?MAX_EXP_LOG of
		true ->
			#db_player_base{player_id = PlayerId, name = Name, exp = OldExp, lv = OldLv} = PlayerState#player_state.db_player_base,
			#db_player_base{exp = NewExp, lv = NewLv} = NewPlayerStatem#player_state.db_player_base,

			StrMessage = case Message of
							 [] ->
								 "";
							 _ ->
								 Message1 = [integer_to_list(X) || X <- Message],
								 string:join(Message1, ",")
						 end,

			LogExpInfo = #db_log_exp{
				player_id = PlayerId,
				player_name = Name,
				exp = Exp,
				old_exp = OldExp,
				old_lv = OldLv,
				new_exp = NewExp,
				new_lv = NewLv,
				reason = Reason,
				message = StrMessage,
				createtime = util_date:unixtime(),
				server_id = config:get_server_no()
			},
			log_inster(LogExpInfo);
		_ ->
			skip
	end.

get_type(Type) ->
	Err = case Type of
			  {Type1, Message} ->
				  {Type1, Message};
			  _ ->
				  {Type, []}
		  end,
%% 	?ERR("Err ~p", [Err]),
	Err.

%% ***************************************************************
%% 内部调用
%% ***************************************************************
log_inster(LogInfo) ->
	gen_server2:apply_async(misc:whereis_name({local, log_mod}), {?MODULE, do_log_inster, [LogInfo]}).
do_log_inster(LogState, LogInfo) ->
	{{NowYear, NowMonth, _NowDay}, {_CurH, _CurM, _CurS}} = calendar:local_time(),
	%% 获取表名
	LogTable = element(1, LogInfo),
	%% 组合表名
	TableName = re:replace(lists:concat([LogTable, '_', NowYear, NowMonth]), "db_", "", [{return, list}]),
	%% 判断是否存在表信息
	NewLogState = case lists:member(TableName, LogState#log_state.log_tables) of
					  true ->
						  LogState;
					  _ ->
						  %% 判断是否存在表
						  case db_log:is_exists(LogState#log_state.db_name, TableName) of
							  false ->
								  %% 创建表信息
								  Sql = log_sql_lib:get_sql(LogTable, TableName),
								  Sql1 = xmerl_ucs:to_utf8(Sql),
								  db_log:execute(Sql1);
							  _ ->
								  skip
						  end,
						  NewList = [TableName | LogState#log_state.log_tables],
						  LogState#log_state{
							  log_tables = NewList
						  }
				  end,
	%% 插入数据
	db_log:insert(TableName, util_tuple:to_tuple_list(LogInfo)),
	{ok, NewLogState}.

log_chat(PlayerId, PlayerName, Content) ->
	dp_lib:cast({?MODULE, log_chat_local, [PlayerId, PlayerName, Content]}).
log_chat_local(PlayerId, PlayerName, Content) ->
	LogInfo = #db_log_chat{
		player_id = PlayerId,
		player_name = PlayerName,
		content = Content,
		server_id = config:get_server_no(),
		createtime = util_date:unixtime()
	},
	log_factory:log_db(LogInfo).

%%面对面交易
log_trade(TradeInfoA, TradeInfoB) ->
	dp_lib:cast({?MODULE, log_trade_local, [TradeInfoA, TradeInfoB]}).
log_trade_local(TradeInfoA, TradeInfoB) ->
	PlayerIdA = TradeInfoA#ets_transaction.player_idA,
	PlayerIdB = TradeInfoB#ets_transaction.player_idA,
	NeedJadeA = TradeInfoA#ets_transaction.jade,
	NeedJadeB = TradeInfoB#ets_transaction.jade,
	NeedGoodsListA = TradeInfoA#ets_transaction.goods_list,
	NeedGoodsListB = TradeInfoB#ets_transaction.goods_list,

	#db_player_base{name = PlayerNameA} = player_base_cache:select_row(PlayerIdA),
	#db_player_base{name = PlayerNameB} = player_base_cache:select_row(PlayerIdB),

	GoodListA = [
		begin
			#goods_conf{name = GoodsName} = goods_config:get(GoodsId),
			{obj, [{"goods_id", GoodsId}, {"goods_name", util_data:to_binary(GoodsName)}, {"num", Num}]}
		end
		|| #db_goods{goods_id = GoodsId, num = Num} <- NeedGoodsListA
	],
	GoodListB = [
		begin
			#goods_conf{name = GoodsName} = goods_config:get(GoodsId),
			{obj, [{"goods_id", GoodsId}, {"goods_name", util_data:to_binary(GoodsName)}, {"num", Num}]}
		end
		|| #db_goods{goods_id = GoodsId, num = Num} <- NeedGoodsListB
	],
	GoodsListAJson = util_data:to_binary(rfc4627:encode(GoodListA)),
	GoodsListBJson = util_data:to_binary(rfc4627:encode(GoodListB)),

	log_factory:log_db(#db_log_trade{
		player_id1 = PlayerIdA,
		player_name1 = PlayerNameA,
		goods_info1 = GoodsListAJson,
		jade1 = NeedJadeA,
		player_id2 = PlayerIdB,
		player_name2 = PlayerNameB,
		goods_info2 = GoodsListBJson,
		jade2 = NeedJadeB,
		type = 1,
		server_id = config:get_server_no(),
		createtime = util_date:unixtime()
	}),
	ok.

%%交易所购买
log_buy(PlayerIdBuy, PlayerIdSale, GoodsId, Num, Jade) ->
	dp_lib:cast({?MODULE, log_buy_local, [PlayerIdBuy, PlayerIdSale, GoodsId, Num, Jade]}).
log_buy_local(PlayerIdBuy, PlayerIdSale, GoodsId, Num, Jade) ->
	#db_player_base{name = PlayerNameA} = player_base_cache:select_row(PlayerIdBuy),
	#db_player_base{name = PlayerNameB} = player_base_cache:select_row(PlayerIdSale),
	NeedJadeA = Jade,
	#goods_conf{name = GoodsName} = goods_config:get(GoodsId),
	GoodListB = [{obj, [{"goods_id", GoodsId}, {"goods_name", util_data:to_binary(GoodsName)}, {"num", Num}]}],
	GoodsListBJson = util_data:to_binary(rfc4627:encode(GoodListB)),
	log_factory:log_db(#db_log_trade{
		player_id1 = PlayerIdBuy,
		player_name1 = PlayerNameA,
		goods_info1 = <<>>,
		jade1 = NeedJadeA,
		player_id2 = PlayerIdSale,
		player_name2 = PlayerNameB,
		goods_info2 = GoodsListBJson,
		jade2 = 0,
		type = 2,
		server_id = config:get_server_no(),
		createtime = util_date:unixtime()
	}),
	ok.

%% 物品变化记录
log_goods_change(PlayerState, GoodsId, Num, ChangeReason) ->
	case PlayerState#player_state.is_robot /= 1 of
		true ->
			#player_state{player_id = PlayerId, db_player_base = #db_player_base{name = PlayerName}} = PlayerState,
			log_goods_change(PlayerId, PlayerName, GoodsId, Num, ChangeReason);
		_ ->
			skip
	end.
log_goods_change(PlayerId, PlayerName, GoodsId, Num, ChangeReason) ->
	{Type1, _} = log_lib:get_type(ChangeReason),

	PlayerName2 = case PlayerName =/= null of
					  true -> PlayerName;
					  false ->
						  #db_player_base{name = PlayerName2_1} = player_base_cache:select_row(PlayerId),
						  PlayerName2_1
				  end,
	#goods_conf{type = Type, quality = Quality} = goods_lib:get_goods_conf_by_id(GoodsId),
	case Type =/= ?GOODS_TYPE_VALUE andalso (Type =/= ?GOODS_TYPE_EQUIPS orelse Quality > 2) of
		true ->
			CurrentNum = goods_lib:get_goods_num(GoodsId),
			log_factory:log_db(#db_log_goods{
				player_id = PlayerId,
				player_name = PlayerName2,
				server_id = config:get_server_no(),
				goods_id = GoodsId,
				num = Num,
				current_num = CurrentNum,
				reason = Type1,
				createtime = util_date:unixtime()
			});
		false ->
			skip
	end,
	ok.
%% 装备洗练变化记录
log_goods_attr_change(PlayerState, PlayerStateOld, GoodsInfoOld, GoodsInfoNew, ChangeReason) ->
	dp_lib:cast({?MODULE, log_goods_attr_change_local, [PlayerState, PlayerStateOld, GoodsInfoOld, GoodsInfoNew, ChangeReason]}).
log_goods_attr_change_local(PlayerState, PlayerStateOld, GoodsInfoOld, GoodsInfoNew, ChangeReason) ->
	#player_state{player_id = PlayerId, db_player_base = #db_player_base{name = PlayerName}} = PlayerState,

	#db_goods{id = Gid, goods_id = GoodsId} = GoodsInfoOld,
	#db_goods{id = NewGid, goods_id = NewGoodsId} = GoodsInfoNew,
	#goods_conf{name = GoodsName} = goods_config:get(GoodsId),
	#goods_conf{name = NewGoodsName} = goods_config:get(NewGoodsId),
	DataOld = {obj, [{"type", <<"goods">>}, {"gid", Gid}, {"goods_id", GoodsId},
		{"goods_name", util_data:to_binary(GoodsName)},
		{"stren_lv", GoodsInfoOld#db_goods.stren_lv}, {"soul", GoodsInfoOld#db_goods.soul},
		{"extra", util_data:term_to_bitstring(GoodsInfoOld#db_goods.extra)}]},
	AttrOld = util_data:to_binary(rfc4627:encode(DataOld)),
	DataNew = {obj, [{"type", <<"goods">>}, {"gid", NewGid}, {"goods_id", NewGoodsId},
		{"goods_name", util_data:to_binary(NewGoodsName)},
		{"stren_lv", GoodsInfoNew#db_goods.stren_lv}, {"soul", GoodsInfoNew#db_goods.soul},
		{"extra", util_data:term_to_bitstring(GoodsInfoNew#db_goods.extra)}]},
	AttrNew = util_data:to_binary(rfc4627:encode(DataNew)),

	case GoodsInfoOld#db_goods.location =:= ?EQUIPS_LOCATION_TYPE of
		true ->
			log_fight_change(PlayerState, PlayerStateOld, AttrOld, AttrNew, ChangeReason);
		false ->
			skip
	end,

	log_factory:log_db(#db_log_goods_attr{
		player_id = PlayerId,
		player_name = PlayerName,
		server_id = config:get_server_no(),
		gid = Gid,
		goods_id = GoodsId,
		attrs_old = AttrOld,
		attrs_new = AttrNew,
		reason = ChangeReason,
		createtime = util_date:unixtime()
	}),
	ok.


%% 战力变化,用户等级或VIP
log_fight_player_change(PlayerState, PlayerStateOld, ChangeReason) ->
	case PlayerState#player_state.is_robot /= 1 of
		true ->
			dp_lib:cast({?MODULE, log_fight_player_change_local, [PlayerState, PlayerStateOld, ChangeReason]});
		_ ->
			skip
	end.
log_fight_player_change_local(PlayerState, PlayerStateOld, ChangeReason) ->
	#player_state{db_player_base = #db_player_base{lv = LvNew, vip = VipNew}} = PlayerState,
	#player_state{db_player_base = #db_player_base{lv = LvOld, vip = VipOld}} = PlayerStateOld,
	DataNew = {obj, [{"type", <<"player">>}, {"lv", LvNew}, {"vip", VipNew}]},
	AttrNew = util_data:to_binary(rfc4627:encode(DataNew)),
	DataOld = {obj, [{"type", <<"player">>}, {"lv", LvOld}, {"vip", VipOld}]},
	AttrOld = util_data:to_binary(rfc4627:encode(DataOld)),
	log_fight_change(PlayerState, PlayerStateOld, AttrOld, AttrNew, ChangeReason).

%% 增加或减少武器引起的战力变化
log_fight_goods_change(PlayerState, PlayerStateOld, GoodsInfo, AddFlagOrGoodsInfo, ChangeReason) ->
	case PlayerState#player_state.is_robot /= 1 of
		true ->
			Args = [PlayerState, PlayerStateOld, GoodsInfo, AddFlagOrGoodsInfo, ChangeReason],
			dp_lib:cast({?MODULE, log_fight_goods_change_local, Args});
		_ ->
			skip
	end.
log_fight_goods_change_local(PlayerState, PlayerStateOld, GoodsInfo, IsAdd, ChangeReason) when is_boolean(IsAdd) ->
	case PlayerState#player_state.is_robot /= 1 of
		true ->
			{GoodsInfoOld, NewGoodsNew} =
				case IsAdd of
					true -> {null, GoodsInfo};
					false -> {GoodsInfo, null}
				end,
			log_fight_goods_change_local(PlayerState, PlayerStateOld, GoodsInfoOld, NewGoodsNew, ChangeReason);
		_ ->
			skip
	end;
%% 更换武器
log_fight_goods_change_local(PlayerState, PlayerStateOld, GoodsInfoOld, GoodsInfoNew, ChangeReason) ->
	case PlayerState#player_state.is_robot /= 1 of
		true ->
			AttrOld =
				case GoodsInfoOld of
					#db_goods{id = Gid, goods_id = GoodsId} ->
						#goods_conf{name = GoodsName} = goods_config:get(GoodsId),
						OldData = {obj, [{"type", <<"goods">>}, {"gid", Gid}, {"goods_id", GoodsId},
							{"goods_name", util_data:to_binary(GoodsName)},
							{"stren_lv", GoodsInfoOld#db_goods.stren_lv}, {"soul", GoodsInfoOld#db_goods.soul},
							{"extra", util_data:term_to_bitstring(GoodsInfoOld#db_goods.extra)}]},
						util_data:to_binary(rfc4627:encode(OldData));
					_ -> <<>>
				end,
			AttrNew =
				case GoodsInfoNew of
					#db_goods{id = NewGid, goods_id = NewGoodsId} ->
						#goods_conf{name = NewGoodsName} = goods_config:get(NewGoodsId),
						NewData = {obj, [{"type", <<"goods">>}, {"gid", NewGid}, {"goods_id", NewGoodsId},
							{"goods_name", util_data:to_binary(NewGoodsName)},
							{"stren_lv", GoodsInfoNew#db_goods.stren_lv}, {"soul", GoodsInfoNew#db_goods.soul},
							{"extra", util_data:term_to_bitstring(GoodsInfoNew#db_goods.extra)}]},
						util_data:to_binary(rfc4627:encode(NewData));
					_ -> <<>>
				end,
			log_fight_change(PlayerState, PlayerStateOld, AttrOld, AttrNew, ChangeReason);
		_ ->
			skip
	end.

%% 战力变化
log_fight_change(PlayerState, PlayerStateOld, AttrOld, AttrNew, ChangeReason) when is_binary(AttrOld) and is_binary(AttrNew) ->
	#player_state{player_id = PlayerId, db_player_base = #db_player_base{name = PlayerName, fight = FightNew}} = PlayerState,
	#player_state{db_player_base = #db_player_base{fight = FightOld}} = PlayerStateOld,

	log_factory:log_db(#db_log_fight{
		player_id = PlayerId,
		player_name = PlayerName,
		server_id = config:get_server_no(),
		createtime = util_date:unixtime(),
		reason = ChangeReason,
		fight_old = FightOld,
		fight_new = FightNew,
		attrs_old = AttrOld,
		attrs_new = AttrNew
	}).

%% 声望记录
log_reputation(PlayerState, Num, Reason) ->
	dp_lib:cast({?MODULE, log_reputation_local, [PlayerState, Num, Reason]}).
log_reputation_local(PlayerState, Num, Reason) ->
	#player_state{player_id = PlayerId, db_player_base = #db_player_base{name = PlayerName}} = PlayerState,

	#db_arena_record{reputation = Reputation} = arena_record_cache:get_arena_record(PlayerId),

	log_factory:log_db(#db_log_reputation{
		player_id = PlayerId,
		player_name = PlayerName,
		server_id = config:get_server_no(),
		createtime = util_date:unixtime(),
		reason = Reason,
		num = Num,
		current_num = Reputation
	}).

%% 掉落记录
log_drop(ObjState, SceneState, OwnerInfo, GoodsList, Reason) ->
	gen_server2:apply_async(misc:whereis_name({local, cache_log_mod}), {?MODULE, log_drop_local, [ObjState, SceneState, OwnerInfo, GoodsList, Reason]}).
log_drop_local(State, ObjState, SceneState, {OwnerId, TeamId, ServerId}, GoodsList, Reason) ->
	#scene_obj_state{
		obj_id = ObjId,
		obj_type = ObjType,
		monster_id = MonsterId,
		name = Name
	} = ObjState,
	Id =
		case ObjType of
			?OBJ_TYPE_MONSTER -> MonsterId;
			_ -> ObjId
		end,

	#scene_conf{scene_id = SceneId, name = SceneName} = scene_config:get(SceneState#scene_state.scene_id),
	Time = util_date:unixtime(),

	[
		begin
			{GoodsId, IsBind, Num} =
				if
					is_record(Goods, db_goods) ->
						#db_goods{
							goods_id = GoodsId1,
							is_bind = IsBind1,
							num = Num1
						} = Goods,
						{GoodsId1, IsBind1, Num1};
					true ->
						Goods
				end,

			#goods_conf{type = Type, quality = Quality} = goods_lib:get_goods_conf_by_id(GoodsId),
			case Type =/= ?GOODS_TYPE_VALUE andalso (Type =/= ?GOODS_TYPE_EQUIPS orelse Quality > 3) of
				true ->
					log_factory:log_db(#db_log_drop{
						obj_id = Id,
						obj_name = Name,
						server_id = ServerId,
						owner_id = OwnerId,
						team_id = TeamId,
						createtime = Time,
						reason = Reason,
						obj_type = ObjType,
						scene_id = SceneId,
						scene_name = SceneName,
						goods_id = GoodsId,
						is_bind = IsBind,
						num = Num
					});
				false ->
					skip
			end
		end
		|| Goods <- GoodsList],
	{ok, State}.


%%登录退出记录
log_login(Openid, Plat, PlayerId, PlayerName, LoginTime, LogoutTime, Type) ->
	case not lists:member(Openid, robot_account_config:get_list()) of
		true ->
			Args = [Openid, Plat, PlayerId, PlayerName, LoginTime, LogoutTime, Type],
			dp_lib:cast({?MODULE, log_login_local, Args});
		_ ->
			skip
	end.
log_login_local(Openid, Plat, PlayerId, PlayerName, LoginTime, LogoutTime, Type) ->
	PlayerName2 = case PlayerName =/= null of
					  true -> PlayerName;
					  false ->
						  case util_data:is_null(PlayerId) of
							  true -> null;
							  false ->
								  case player_base_cache:select_row(PlayerId) of
									  #db_player_base{name = PlayerName2_1} -> PlayerName2_1;
									  _ -> null
								  end
						  end
				  end,
	cache_log_lib:insert(#db_log_login{
		player_id = PlayerId,
		player_name = PlayerName2,
		openid = Openid,
		plat = Plat,
		server_id = config:get_server_no(),
		login_time = LoginTime,
		logout_time = LogoutTime,
		type = Type
	}),
	ok.


%% 邮件接收记录
log_mail(PlayerId, PlayerName, MailId, MailType, Sender, Title, Content, Award, SendTime, LimitTime) ->
	Args = [PlayerId, PlayerName, MailId, MailType, Sender, Title, Content, Award, SendTime, LimitTime],
	dp_lib:cast({?MODULE, log_mail_local, Args}).
log_mail_local(PlayerId, PlayerName, MailId, MailType, Sender, Title, Content, Award, SendTime, LimitTime) ->
	cache_log_lib:insert(#db_log_mail{
		player_id = PlayerId,
		player_name = PlayerName,
		server_id = config:get_server_no(),
		createtime = util_date:unixtime(),
		mail_id = MailId,
		mail_type = MailType,
		sender = Sender,
		title = Title,
		content = Content,
		award = Award,
		send_time = SendTime,
		limit_time = LimitTime
	}).

%%日常任务参与人数与完成人数
log_daily(PlayerState, Type, Jade, Status) ->
	#player_state{player_id = PlayerId, db_player_base = #db_player_base{name = PlayerName}} = PlayerState,
	dp_lib:cast({?MODULE, log_daily_local, [PlayerId, PlayerName, Type, Jade, Status]}).
log_daily(PlayerId, PlayerName, Type, Jade, Status) ->
	dp_lib:cast({?MODULE, log_daily_local, [PlayerId, PlayerName, Type, Jade, Status]}).

log_daily_local(PlayerId, PlayerName, Type, Jade, Status) ->
	cache_log_lib:insert(#db_log_daily{
		player_id = PlayerId,
		player_name = PlayerName,
		server_id = config:get_server_no(),
		createtime = util_date:unixtime(),
		reason = Type,
		jade = Jade,
		status = Status
	}).

%% 运营活动记录
log_activity(PlayerSate, ActivityId) ->
	dp_lib:cast({?MODULE, log_activity_local, [PlayerSate, ActivityId]}).
log_activity_local(PlayerState, ActivityId) ->
	#player_state{player_id = PlayerId, db_player_base = #db_player_base{name = PlayerName, lv = Lv, vip = Vip}} = PlayerState,
	cache_log_lib:insert(#db_log_activity{
		player_id = PlayerId,
		player_name = PlayerName,
		server_id = config:get_server_no(),
		createtime = util_date:unixtime(),
		activity_id = ActivityId,
		lv = Lv,
		vip = Vip
	}).

%% 物品投保记录
log_insurance(PlayerSate, GoodsId, Num, CurrentNum) ->
	dp_lib:cast({?MODULE, log_insurance_local, [PlayerSate, GoodsId, Num, CurrentNum]}).
log_insurance_local(PlayerState, GoodsId, Num, CurrentNum) ->
	#player_state{player_id = PlayerId, db_player_base = #db_player_base{name = PlayerName}} = PlayerState,
	cache_log_lib:insert(#db_log_insurance{
		player_id = PlayerId,
		player_name = PlayerName,
		server_id = config:get_server_no(),
		createtime = util_date:unixtime(),
		goods_id = GoodsId,
		num = Num,
		current_num = CurrentNum
	}).

%% 一生一次购买记录
log_shop_once(PlayerSate, GoodsId, Num, Cost) ->
	dp_lib:cast({?MODULE, log_shop_once_local, [PlayerSate, GoodsId, Num, Cost]}).
log_shop_once_local(PlayerState, GoodsId, Num, Cost) ->
	#player_state{player_id = PlayerId, db_player_base = #db_player_base{name = PlayerName}} = PlayerState,
	cache_log_lib:insert(#db_log_shop_once{
		player_id = PlayerId,
		player_name = PlayerName,
		server_id = config:get_server_no(),
		createtime = util_date:unixtime(),
		goods_id = GoodsId,
		num = Num,
		cost = Cost
	}).