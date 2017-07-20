%%%-------------------------------------------------------------------
%%% @author admin
%%% @copyright (C) 2016, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 01. 九月 2016 上午11:12
%%%-------------------------------------------------------------------
-module(drop_lib).
-author("admin").

-include("common.hrl").
-include("record.hrl").
-include("db_record.hrl").
-include("proto.hrl").
-include("cache.hrl").
-include("config.hrl").
-include("notice_config.hrl").
-include("language_config.hrl").
-include("button_tips_config.hrl").
-include("log_type_config.hrl").

-define(DROP_TYPE_0, 0).%%0 跨服不掉落
-define(DROP_TYPE_1, 1).%%1 跨服要掉落
%% MailInfo = io_lib:format(xmerl_ucs:to_utf8("~s的投保元宝*~w"), [Name, TempNum]),
%% NoticeInfo = io_lib:format(xmerl_ucs:to_utf8("~s的投保元宝"), [Name]),

-define(SECURE_MAIL, xmerl_ucs:to_utf8("~s的投保元宝*~w")).
-define(SECURE_NOTICE, xmerl_ucs:to_utf8("~s的投保元宝")).
-define(DROPJADE_MAIL, xmerl_ucs:to_utf8("~s转化为~w个元宝")).
-define(DROPJADE_NOTICE, xmerl_ucs:to_utf8("~s转化为~w个元宝")).
%% API
-export([
	scene_drop/3
]).

%% 跨服掉落
scene_drop(PlayerState, SceneConf, CasterState) ->
	#player_state{name_colour = NameColour} = PlayerState,
	#scene_conf{is_cross = IsCross} = SceneConf,
	%% 物品掉落列表
	DropList1 = get_drop_goods_list(NameColour, IsCross),
	%% 装备掉落的列表
	DropList2 = get_drop_equip_list(NameColour, IsCross),
	DropList3 = DropList2 ++ DropList1,

	%% 物品投保检测 跨服检测
	{PlayerState1, DropList4, MailInfoList, NoticeInfoList} = check_secure(PlayerState, DropList3, IsCross),

	%% 发送掉落公告
	drop_noice(PlayerState1, CasterState, SceneConf, NoticeInfoList),

	%% 发送掉落邮件
	drop_mail(PlayerState1, MailInfoList),
	{PlayerState1, DropList4}.


%% ************************************************************
%% 内部函数
%% ************************************************************
%% 获取掉落的物品信息 isCross 是否跨服
get_drop_goods_list(NameColour, IsCross) ->
	%% 获取玩家身上非绑定的物品
	GoodsList = goods_lib:get_goods_list(?NORMAL_LOCATION_TYPE, ?NOT_BIND),
	%% 根据红名获得物品掉落概率
	GoodsDropRate =
		case NameColour of
			?NAME_COLOUR_RED -> 500;
			_ -> 50
		end,
%%     GoodsDropRate = 9000,
	F = fun(GoodsInfo) ->
		#goods_conf{drop_type = DropType} = goods_config:get(GoodsInfo#db_goods.goods_id),
		%% 判断是否使跨服
		IsDrop = case IsCross of
					 1 ->
						 DropType =:= ?DROP_TYPE_1;
					 _ ->
						 true
				 end,
		case IsDrop of
			true ->
				util_rand:rand_hit(GoodsDropRate);
			_ ->
				false
		end
	end,
	lists:filter(F, GoodsList).

%% 获取掉落的装备信息
get_drop_equip_list(NameColour, IsCross) ->
	%% 获取玩家身上非绑定的装备
	EquipsList = goods_lib:get_goods_list(?EQUIPS_LOCATION_TYPE, ?NOT_BIND),
	?INFO("~p", [length(EquipsList)]),

	F1 =
		fun(EquipInfo) ->
			#goods_conf{drop_type = DropType, drop_rate1 = DropRate1, drop_rate2 = DropRate2} = goods_config:get(EquipInfo#db_goods.goods_id),
			%% 判断是否使跨服
			IsDrop = case IsCross of
						 1 ->
							 DropType =:= ?DROP_TYPE_1;
						 _ ->
							 true
					 end,
			case IsDrop of
				true ->
					DropRate =
						case NameColour of
							?NAME_COLOUR_RED -> DropRate2;
							_ -> DropRate1
						end,
%% 					DropRate = 9000,
					util_rand:rand_hit(DropRate);
				_ ->
					false
			end
		end,
	lists:filter(F1, EquipsList).

%% 物品投保检测处理 并删除玩家物品或者道具信息
check_secure(PlayerState, DropList3, IsCross) ->
	%% DropList 掉落列表, MailInfoList 邮件发送列表, NoticeList 公告发送列表
	Fun = fun(Info, {TempPlayerState, DropList, MailInfoList, NoticeList}) ->
		#db_goods{secure = Secure, num = Num, id = DbId, goods_id = GoodsId} = Info,
		#goods_conf{drop_jade = DropJade, name = Name, type = Type, secure_price = SecurePrice} = goods_config:get(GoodsId),
		case Secure > 0 of
			true ->
				%% 玩家数据处理
				goods_lib:update_player_goods_info(TempPlayerState, Info#db_goods{secure = Secure - 1}),
				TempNum = util_math:floor(SecurePrice * 0.7),
				DropInfo = #db_goods{
					id = 0,
					player_id = TempPlayerState#player_state.player_id,
					goods_id = ?GOODS_ID_JADE,
					is_bind = ?NOT_BIND,
					num = TempNum,
					server_id = 0
				},
				MailInfo = io_lib:format(?SECURE_MAIL, [Name, TempNum]),
				NoticeInfo = io_lib:format(?SECURE_NOTICE, [Name]),
				{TempPlayerState, [DropInfo | DropList], [MailInfo | MailInfoList], [NoticeInfo | NoticeList]};
			false ->
				%% 计算新的掉落数量
				TempNum = case Num > 1 of
							  true ->
								  case get_bag_num(Num) of
									  0 ->
										  1;
									  Num1 ->
										  Num1
								  end;
							  _ ->
								  Num
						  end,
				%% 删除玩家道具信息
				ResultObj = case Type of
								?EQUIPS_TYPE ->
									goods_lib:delete_equips_by_id(TempPlayerState, DbId);
								_ ->
									goods_lib:delete_goods_by_id_and_num(TempPlayerState, DbId, GoodsId, TempNum)
							end,
				%% 删除数据后记录信息
				case ResultObj of
					{ok, TempPlayerState1} ->
						%% 如果是跨服的话 就进行跨服的特殊判定
						{DropInfo, MailInfo, NoticeInfo} =
							case IsCross =:= 1 andalso DropJade > 0 of
								true ->
									DropInfo1 = #db_goods{
										id = 0,
										player_id = TempPlayerState#player_state.player_id,
										goods_id = ?GOODS_ID_JADE,
										is_bind = ?NOT_BIND,
										num = DropJade * TempNum,
										server_id = 0
									},
									MailInfo1 = io_lib:format(?DROPJADE_MAIL, [Name, TempNum * DropJade]),
									NoticeInfo1 = io_lib:format(?DROPJADE_NOTICE, [Name, TempNum * DropJade]),
									{DropInfo1, MailInfo1, NoticeInfo1};
								_ ->
									DropInfo1 = Info#db_goods{
										num = TempNum
									},
									MailInfo1 = io_lib:format("~s*~w", [Name, TempNum]),
									NoticeInfo1 = Name,
									{DropInfo1, MailInfo1, NoticeInfo1}
							end,
						{TempPlayerState1, [DropInfo | DropList], [MailInfo | MailInfoList], [NoticeInfo | NoticeList]};
					_ ->
						{TempPlayerState, DropList, MailInfoList, NoticeList}
				end
		end
	end,
	lists:foldl(Fun, {PlayerState, [], [], []}, DropList3).

%% 获取物品掉落 数量权重信息
get_bag_num(Num) ->
	BagDropList = bag_drop_config:get_list_conf(),
	RdNum = util_rand:weight_rand([X#bag_drop_conf.weight || X <- BagDropList]),
	BagDropConf = rand_bag_num(BagDropList, {RdNum, 0, null}),

	#bag_drop_conf{num_min = Min, num_max = Max} = BagDropConf,
	TempNum = Num * util_rand:rand(Min, Max) * 0.0001,
	round(TempNum).

%% 从列表中 随机一个物品
rand_bag_num([], {_, _, ResConf}) ->
	ResConf;
rand_bag_num([BagDropConf | H], {RdNum, TempNum, ResConf}) ->
	case ResConf /= null of
		true ->
			ResConf;
		_ ->
			NewTempSum = TempNum + BagDropConf#bag_drop_conf.weight,
			case RdNum >= TempNum + 1 andalso RdNum =< NewTempSum of
				true ->
					BagDropConf;
				_ ->
					rand_bag_num(H, {RdNum, NewTempSum, ResConf})
			end
	end.


%% 发送掉落公告
drop_noice(PlayerState, CasterState, SceneConf, NoticeInfoList) ->
	case NoticeInfoList /= [] of
		true ->
			#player_state{db_player_base = #db_player_base{name = PlayerName}, server_pass = ServerPass} = PlayerState,
			SceneName = SceneConf#scene_conf.name,
			GoodsStr = string:join(NoticeInfoList, ", "),
			CastName = CasterState#scene_obj_state.name,
			case not util_data:is_null(ServerPass) of
				true ->
					notice_lib:send_notice_crass(ServerPass, 0, ?NOTICE_MONSTER_LOOT, [PlayerName, SceneName, CastName, GoodsStr]);
				_ ->
					notice_lib:send_notice(0, ?NOTICE_MONSTER_LOOT, [PlayerName, SceneName, CastName, GoodsStr])
			end;
		_ ->
			skil
	end.

%% 发送掉落邮件
drop_mail(PlayerState, MailInfoList) ->
	case MailInfoList /= [] of
		true ->
			GoodsStr1 = string:join(MailInfoList, ", "),
			MailStr = xmerl_ucs:to_utf8("你被击杀了,死亡导致掉落物品:") ++ GoodsStr1,
			mail_lib:send_text_mail_to_player(PlayerState#player_state.player_id, MailStr);
		false ->
			skip
	end.