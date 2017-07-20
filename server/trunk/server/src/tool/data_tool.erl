%%%-------------------------------------------------------------------
%%% @author qhb
%%% @copyright (C) 2017, <COMPANY>
%%% @doc
%%% 数据处理工具类
%%% @end
%%% Created : 03. 三月 2017 下午8:29
%%%-------------------------------------------------------------------
-module(data_tool).
-include("common.hrl").
-include("cache.hrl").
-include("record.hrl").
-include("config.hrl").
-include("uid.hrl").

%% API
-export([
	validate_player/1,
	clear_all_goods/1,
	clear_goods/2,
	clear_goods_bind/3,
	clear_mounts/1,
	clear_mail_from/2,

	send_goods_mail/2,
	update_goods_list_by_goods_info/2,
	update_goods_list_by_goods_info_low/2,
	add_goods_list_by_goods_info/2,

	update_player_shmj/2,
	low_goods_30/0,
	select_all_goods_30/0
]).

%%测试用记是否存在
validate_player(PlayerId) ->
	case player_base_cache:select_row(PlayerId) of
		#db_player_base{} ->
			skip;
		_ ->
			io:format("target:not exist player ~p ~n",[PlayerId])
	end.

%%清除所有物品
clear_all_goods(PlayerId) when is_integer(PlayerId)->
	case player_lib:get_player_pid(PlayerId) of
		null ->
			case goods_cache:select_all(PlayerId) of
				[] ->
					skip;
				List ->
					lists:foreach(fun(DbGoods) ->
						goods_cache:delete(DbGoods#db_goods.id, PlayerId)
					end, List)
			end;
		Pid ->
			gen_server2:apply_async(Pid, {?MODULE, clear_all_goods, []})
	end;
clear_all_goods(PlayerState) ->
	List = goods_dict:get_player_goods_list(),
	lists:foreach(fun(DbGoods) ->
		goods_lib:delete_player_goods_info(PlayerState, DbGoods, false)
	end, List),

	EquipsList = goods_dict:get_player_equips_list(),
	lists:foreach(fun(DbGoods) ->
		goods_lib:delete_player_goods_info(PlayerState, DbGoods, false)
	end, EquipsList),

	StoreList = goods_dict:get_player_store_list(),
	lists:foreach(fun(DbGoods) ->
		goods_lib:delete_player_goods_info(PlayerState, DbGoods, false)
	end, StoreList),
	{ok, PlayerState}.

%%清除指定物品
clear_goods(PlayerId, GoodsIdList) when is_integer(PlayerId)->
	case player_lib:get_player_pid(PlayerId) of
		null ->
			case goods_cache:select_all(PlayerId) of
				[] ->
					skip;
				List ->
					lists:foreach(fun(DbGoods) ->
						GoodsId = DbGoods#db_goods.goods_id,
						case lists:member(GoodsId, GoodsIdList) of
							true ->
								goods_cache:delete(DbGoods#db_goods.id, PlayerId);
							false ->
								skip
						end
					end, List),
					ok
			end;
		Pid ->
			gen_server2:apply_sync(Pid, {?MODULE, clear_goods, [GoodsIdList]}),
			ok
	end;
clear_goods(PlayerState, GoodsIdList) ->
	List = goods_dict:get_player_goods_list(),
	lists:foreach(fun(DbGoods) ->
		GoodsId = DbGoods#db_goods.goods_id,
		case lists:member(GoodsId, GoodsIdList) of
			true ->
				goods_lib:delete_player_goods_info(PlayerState, DbGoods, false);
			false ->
				skip
		end
	end, List),

	EquipsList = goods_dict:get_player_equips_list(),
	lists:foreach(fun(DbGoods) ->
		GoodsId = DbGoods#db_goods.goods_id,
		case lists:member(GoodsId, GoodsIdList) of
			true ->
				goods_lib:delete_player_goods_info(PlayerState, DbGoods, false);
			false ->
				skip
		end
	end, EquipsList),

	StoreList = goods_dict:get_player_store_list(),
	lists:foreach(fun(DbGoods) ->
		GoodsId = DbGoods#db_goods.goods_id,
		case lists:member(GoodsId, GoodsIdList) of
			true ->
				goods_lib:delete_player_goods_info(PlayerState, DbGoods, false);
			false ->
				skip
		end
	end, StoreList),
	{ok, PlayerState}.

%%清除指定绑定或非绑定的物品
clear_goods_bind(PlayerId, GoodsIdList, IsBind)->
	case goods_cache:select_all(PlayerId) of
		[] ->
			skip;
		List ->
			lists:foreach(fun(DbGoods) ->
				GoodsId = DbGoods#db_goods.goods_id,
				GoodsBind = DbGoods#db_goods.is_bind,
				case lists:member(GoodsId, GoodsIdList) andalso GoodsBind =:= IsBind of
					true ->
						goods_cache:delete(DbGoods#db_goods.id, PlayerId);
					false ->
						skip
				end
			end, List)
	end,
	ok.

%%清除除马
clear_mounts(PlayerIdOrState) ->
	Mounts = data_config:get_goods_mounts(),
	clear_goods(PlayerIdOrState, Mounts).

%%特殊属性更新
update_player_shmj(PlayerId, TotalCost) when is_integer(PlayerId)->
	case player_lib:get_player_pid(PlayerId) of
		null ->
			case player_base_cache:select_row(PlayerId) of
				null ->
					skip;
				DbPlayerBase ->
					NewDbPlayerBase = DbPlayerBase#db_player_base{lottery_score_use_1 = TotalCost},
					player_base_cache:update(PlayerId, NewDbPlayerBase),
					ok
			end;
		Pid ->
			gen_server2:apply_async(Pid, {?MODULE, update_player_shmj, [TotalCost]}),
			ok
	end;
update_player_shmj(PlayerState, TotalCost) ->
	Update = #player_state{
		db_player_base = #db_player_base{
			lottery_score_use_1 = TotalCost
		}
	},
	?WARNING("update_player_shmj ~p",[TotalCost]),
	{ok, PlayerState2} = player_lib:update_player_state(PlayerState, Update),
	#player_state{
		db_player_base = #db_player_base{
			lottery_score_use_1 = TotalCost2
		}
	} = PlayerState2,
	?WARNING("update_player_shmj2 ~p",[TotalCost2]),
	{ok, PlayerState2}.

%%清除从哪个时间点开始的邮件,如错误的邮件
clear_mail_from(PlayerId, DataTime) ->
	case mail_cache:select_all(PlayerId) of
		[] ->
			ok;
		List ->
			Time = util_date:time_tuple_to_unixtime(DataTime),
			Fun = fun(DbInfo) ->
				Id = DbInfo#db_player_mail.id,
				PlayerId = DbInfo#db_player_mail.player_id,
				SendTime = DbInfo#db_player_mail.send_time,
				case SendTime > Time of
					true ->
						mail_db:delete({Id, PlayerId}),
						mail_cache:remove_cache(Id, PlayerId),
						mail_cache:delete_player_mail_from_ets_by_id(Id, PlayerId);
					false ->
						skip
				end
			end,
			[Fun(X) || X <- List]
	end.

send_goods_mail(PlayerId, GoodsList) ->
	%% 发送邮件
	case GoodsList of
		[] ->
			skip;
		_ ->
			Sender = "system",
			Title = xmerl_ucs:to_utf8("系统邮件"),
			Content = xmerl_ucs:to_utf8("数据处理邮件"),
			mail_lib:send_mail_to_player(PlayerId, Sender, Title, Content, GoodsList)
	end.

send_goods_mail2(PlayerId, Content, GoodsList) ->
	%% 发送邮件
	case GoodsList of
		[] ->
			skip;
		_ ->
			Sender = "system",
			Title = xmerl_ucs:to_utf8("系统邮件"),
			mail_lib:send_mail_to_player(PlayerId, Sender, Title, Content, GoodsList)
	end.

%%替换同样的物品
update_goods_list_by_goods_info(PlayerId, GoodsInfoList) ->
	GoodsInfoKvList = [{R#db_goods.id, R} || R <- GoodsInfoList],
	GoodsInfoDict = dict:from_list(GoodsInfoKvList),
	OldGoodsInfoList = goods_cache:select_all(PlayerId),
	lists:foreach(fun(DbGoods) ->
		case dict:find(DbGoods#db_goods.id, GoodsInfoDict) of
			{ok, GoodsInfo} ->
				goods_cache:update(DbGoods#db_goods.id, DbGoods#db_goods.player_id, GoodsInfo);
			_ ->
				skip
		end
	end, OldGoodsInfoList),
	ok.

%%替换物品,特装降阶
update_goods_list_by_goods_info_low(PlayerId, GoodsInfoList) ->
	GoodsInfoKvList = [{R#db_goods.id, R} || R <- GoodsInfoList],
	GoodsInfoDict = dict:from_list(GoodsInfoKvList),
	SpecList = [{305000, 305036, 305039}, {305001, 305037, 305040}, {305002, 305038, 305041}, {305029, 305042, 305045}, {305030, 305043, 305046}, {305033, 305044, 305047}, {305062, 305063, 305064}, {305067, 305068, 305069}, {305072, 305073, 305074}, {305077, 305078, 305079}],
	SpecDict = lists:foldl(fun({G1, G2, G3}, DictAcc) ->
		dict:store(G3, G1, dict:store(G2, G1, dict:store(G1, G1, DictAcc)))
	end, dict:new(), SpecList),

	OldGoodsInfoList = goods_cache:select_all(PlayerId),
	lists:foreach(fun(DbGoods) ->
		case dict:find(DbGoods#db_goods.id, GoodsInfoDict) of
			{ok, _GoodsInfo} ->
				case dict:find(DbGoods#db_goods.goods_id, SpecDict) of
					{ok, Value} ->
						%%goods_cache:delete(DbGoods#db_goods.id, PlayerId),
						NewGoodsInfo = DbGoods#db_goods{goods_id = Value},
						goods_cache:update(DbGoods#db_goods.id, NewGoodsInfo#db_goods.player_id, NewGoodsInfo);
					_ ->
						%%goods_cache:update(DbGoods#db_goods.id, DbGoods#db_goods.player_id, GoodsInfo)
						skip
				end;
			_ ->
				case dict:find(DbGoods#db_goods.goods_id, SpecDict) of
					{ok, Value} ->
						%%goods_cache:delete(DbGoods#db_goods.id, PlayerId),
						NewGoodsInfo = DbGoods#db_goods{goods_id = Value},
						goods_cache:update(DbGoods#db_goods.id, NewGoodsInfo#db_goods.player_id, NewGoodsInfo);
					_ ->
						skip
				end
		end
	end, OldGoodsInfoList),
	ok.

%%物品强化超出30的还原
low_goods_30() ->
	OldGoodsInfoList = select_all_goods_30(),
	lists:foreach(fun(DbGoods) ->
		case DbGoods#db_goods.stren_lv > 30 of
			true ->
				NewGoodsInfo = DbGoods#db_goods{stren_lv = 30},
				?WARNING("player_id ~p,goods ~p ~p,~p",[DbGoods#db_goods.player_id, DbGoods#db_goods.goods_id, DbGoods#db_goods.id, DbGoods#db_goods.stren_lv]),
				goods_cache:update(DbGoods#db_goods.id, NewGoodsInfo#db_goods.player_id, NewGoodsInfo);
			false ->
				skip
		end
	end, OldGoodsInfoList),
	ok.

select_all_goods_30() ->
	case db:select_all(player_goods, record_info(fields, db_goods), [{stren_lv, ">", 30}]) of
		[] ->
			[];
		List ->
			Fun = fun(List1) ->
				DbGoods = list_to_tuple([db_goods | List1]),
				DbGoods#db_goods{extra = util_data:string_to_term(DbGoods#db_goods.extra)}
			end,
			[Fun(X) || X <- List]
	end.


%%添加物品,添加顺序身上装备,装备,道具,邮件
add_goods_list_by_goods_info(PlayerId, GoodsInfoList) ->
	OldGoodsInfoList = goods_cache:select_all(PlayerId),

	%%自动穿戴
	IsAutoOn = true,
	LeftGoodsInfoList =
		case IsAutoOn of
			true ->
				add_goods_list_by_goods_info_auto_on(PlayerId, OldGoodsInfoList, GoodsInfoList);
			false ->
				GoodsInfoList
		end,

	%%存放物品
	LeftGoodsInfoList2 = put_goods(PlayerId, OldGoodsInfoList, LeftGoodsInfoList),

	lists:foreach(fun(DbGoods) ->
		#db_goods{goods_id = GoodsId, num = Num, is_bind = IsBind} = DbGoods,
		send_goods_mail2(PlayerId, xmerl_ucs:to_utf8("数据处理邮件(背包已满)"), [{GoodsId, IsBind, Num}])
	end, LeftGoodsInfoList2),
	ok.




%%------------------------------------------------
%%当身上还有可穿戴位置时,将新加过来的在身上的物品也直接穿戴在身上,
add_goods_list_by_goods_info_auto_on(PlayerId, OldGoodsInfoList, GoodsInfoList) ->
	%%当前穿戴物品
	GridState =
		lists:foldl(fun(GoodsInfo, AccDict) ->
			#db_goods{location = Location, grid = Grid} = GoodsInfo,
			case Grid > 0 of
				true ->
					Key = {Location, Grid},
					case dict:find(Key, AccDict) of
						{ok, Value} ->
							dict:store(Key, Value + 1, AccDict);
						_ ->
							dict:store(Key,1, AccDict)
					end;
				false ->
					AccDict
			end
		end, dict:new(), OldGoodsInfoList),

	do_goods_info_on(PlayerId, GoodsInfoList, GridState, []).

%%穿戴
do_goods_info_on(_PlayerId, [], _GridState, LeftList) ->
	lists:reverse(LeftList);
do_goods_info_on(PlayerId, [GoodsInfo |LastGoodsInfoList], GridState, LeftList) ->
	#db_goods{location = Location, grid = Grid} = GoodsInfo,
	case Grid > 0 andalso can_on(GridState, Location, Grid) of
		true ->
			save_goods_info(GoodsInfo),
			Key = {Location, Grid},
			NewGridState = case dict:find(Key, GridState) of
							   {ok, Value} -> dict:store(Key,Value + 1, GridState);
							   _ -> dict:store(Key,1, GridState)
						   end,
			do_goods_info_on(PlayerId, LastGoodsInfoList, NewGridState, LeftList);
		false ->
			GoodsInfo2 = GoodsInfo#db_goods{location = ?NORMAL_LOCATION_TYPE, grid = 0},
			do_goods_info_on(PlayerId, LastGoodsInfoList, GridState, [GoodsInfo2 | LeftList])
	end.

%%是否有有旧的装备在身上能不能穿戴
can_on(GridState, Location, Grid) ->
	Key = {Location, Grid},
	case dict:find(Key, GridState) of
		{ok, _Value} -> false;
		_ -> true
	end.

%%存放物品
put_goods(PlayerId, OldGoodsInfoList, GoodsInfoList) ->
	DbPlayerBase = player_base_cache:select_row(PlayerId),
	%%背包
	AllBagCell = DbPlayerBase#db_player_base.bag,
	UseBagCell = length([R || R<-OldGoodsInfoList, R#db_goods.location =:= ?NORMAL_LOCATION_TYPE]),
	BagCelNum = AllBagCell - UseBagCell,
	%%仓库
	VipNum = vip_lib:get_vip_store_num(DbPlayerBase#db_player_base.career, DbPlayerBase#db_player_base.vip),
	AllStoreCell = ?STORE_BAG + VipNum,
	UseStoreCell = length([R || R<-OldGoodsInfoList, R#db_goods.location =:= ?STORE_LOCATION_TYPE]),
	StoreCellNum = AllStoreCell - UseStoreCell,

	%%优先装备
	%%装备分类存放,装备有强化及洗练
	EquipsList = lists:filter(fun(DbGoods) ->
		GoodsConf = goods_lib:get_goods_conf_by_id(DbGoods#db_goods.goods_id),
		GoodsConf#goods_conf.type =:= ?TYPE_EQUIPS
	end, GoodsInfoList),
	{LeftEquipsList1, LeftBagCelNum1, LeftStoreCelNum1}
		= put_goods1(EquipsList, [], BagCelNum, StoreCellNum),

	%%普通物品分类存放
	NormalGoodsInfoList = lists:filter(fun(DbGoods) ->
		GoodsConf = goods_lib:get_goods_conf_by_id(DbGoods#db_goods.goods_id),
		GoodsConf#goods_conf.type =/= ?TYPE_EQUIPS
	end, GoodsInfoList),
	{LeftNormalGoodsInfoList2, LeftBagCelNum2, LeftStoreCelNum2}
		= put_goods1(NormalGoodsInfoList, [], LeftBagCelNum1, LeftStoreCelNum1),

	%%自动选择空闲背包存放,装备优先
	{LeftGoodsInfoList, _LeftBagCelNum3, _LeftStoreCelNum3}
		= put_goods2(LeftEquipsList1 ++ LeftNormalGoodsInfoList2, [], LeftBagCelNum2, LeftStoreCelNum2),
	LeftGoodsInfoList.

%%不同背包的物品分别存放
put_goods1([], LeftGoodsInfoList, LeftBagCellNum, LeftStoreCelNum) ->
	{LeftGoodsInfoList, LeftBagCellNum, LeftStoreCelNum};
put_goods1([GoodsInfo|LastGoodsInfoList], LeftGoodsInfoList, LeftBagCellNum, LeftStoreCelNum) ->
	#db_goods{location = Location} = GoodsInfo,
	case Location of
		?NORMAL_LOCATION_TYPE ->
			case LeftBagCellNum > 0 of
				true ->
					save_goods_info(GoodsInfo),
					put_goods1(LastGoodsInfoList, LeftGoodsInfoList, LeftBagCellNum - 1, LeftStoreCelNum);
				false ->
					put_goods1(LastGoodsInfoList, [GoodsInfo | LeftGoodsInfoList], LeftBagCellNum, LeftStoreCelNum)
			end;
		?STORE_LOCATION_TYPE ->
			case LeftStoreCelNum > 0 of
				true ->
					save_goods_info(GoodsInfo),
					put_goods1(LastGoodsInfoList, LeftGoodsInfoList, LeftBagCellNum, LeftStoreCelNum - 1);
				false ->
					put_goods1(LastGoodsInfoList, [GoodsInfo | LeftGoodsInfoList], LeftBagCellNum, LeftStoreCelNum)
			end;
		_ ->
			put_goods1(LastGoodsInfoList, [GoodsInfo | LeftGoodsInfoList], LeftBagCellNum, LeftStoreCelNum)
	end.

%%不同背包的物品自动放入空的背包
put_goods2([], LeftGoodsInfoList, LeftBagCellNum, LeftStoreCelNum) ->
	{lists:reverse(LeftGoodsInfoList), LeftBagCellNum, LeftStoreCelNum};
put_goods2([GoodsInfo|LastGoodsInfoList], LeftGoodsInfoList, LeftBagCellNum, LeftStoreCelNum) ->
	if
		LeftBagCellNum > 0 ->
			NewGoodsInfo = GoodsInfo#db_goods{location = ?NORMAL_LOCATION_TYPE},
			save_goods_info(NewGoodsInfo),
			put_goods2(LastGoodsInfoList, LeftGoodsInfoList, LeftBagCellNum - 1, LeftStoreCelNum);
		LeftStoreCelNum > 0 ->
			NewGoodsInfo = GoodsInfo#db_goods{location = ?STORE_LOCATION_TYPE},
			save_goods_info(NewGoodsInfo),
			put_goods2(LastGoodsInfoList, LeftGoodsInfoList, LeftBagCellNum, LeftStoreCelNum - 1);
		true ->
			put_goods2(LastGoodsInfoList, [GoodsInfo | LeftGoodsInfoList], LeftBagCellNum, LeftStoreCelNum)
	end.

%%保存物品
save_goods_info(GoodsInfo) ->
	Id = get_new_goods_key(),
	NewGoodsInfo = GoodsInfo#db_goods{
		id = Id
	},
	goods_cache:insert(NewGoodsInfo).

%% 获取新的道具唯一ID
get_new_goods_key() ->
	uid_lib:get_uid(?UID_TYPE_PLAYER_GOODS).

