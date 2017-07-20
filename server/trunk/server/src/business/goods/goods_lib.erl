%%%-------------------------------------------------------------------
%%% @author tuhujia
%%% @copyright (C) 2015, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 22. 七月 2015 17:20
%%%-------------------------------------------------------------------
-module(goods_lib).

-include("common.hrl").
-include("record.hrl").
-include("proto.hrl").
-include("cache.hrl").
-include("db_record.hrl").
-include("config.hrl").
-include("uid.hrl").
-include("language_config.hrl").
-include("button_tips_config.hrl").
-include("log_type_config.hrl").
-include("notice_config.hrl").

%% API
-export([
	init_goods/1,
	update_guise_state/1,
	add_goods/4,
	add_goods_list/2,
	add_goods_list_and_auto_sell/2,%%log inner:hook
	add_equips/5,%%log inner:forge
	add_goods_by_goods_info/2,
	add_goods_list_by_goods_info/2,
	add_goods_list_and_send_mail/2,
	add_ring_goods/3,
	add_medal_goods/3,%%log inner:medal
	add_medal_goods/2,
	add_wing_goods/2,
	add_mounts_goods/2,
	delete_goods_by_id/3,
	delete_equips_by_id/2,%%log inner:artifact
	delete_equips_by_id/3,
	delete_goods_by_num/3,
	delete_goods_list_by_id/2,
	delete_goods_list_by_info/2,
	delete_goods_list_by_num/2,
	delete_player_goods_info/2,
	delete_player_goods_info/3,
	delete_goods_by_id_and_num/4,
	delete_goods_list_by_id_and_num/2,
	sell_equips_by_quality/2,%%log inner
	sell_goods_list_by_id/2,%%log inner
	sell_goods_by_id_and_num/3,%%log inner
	use_goods/3,
	use_goods_map/2,
	expend_bag/1,
	update_player_goods_info/2,
	update_player_goods_info/3,
	update_player_goods_info_no_broadcast/2,
	is_goods_enough/2,
	is_goods_list_enough/1,
	is_money_type_by_goods/1,
	get_goods_num/1,
	get_store_goods_num/1,
	get_goods_conf_by_id/1,
	get_player_equips_info_by_id/1,
	get_player_goods_info/3,
	get_goods_info_list/0,
	get_equips_info_list/0,
	get_wear_equips_info_list/0,
	get_goods_list/2,
	get_player_goods_info/2,
	get_proto_goods_list/1,
	get_free_bag_num/1,
	broadcast_goods_reward/2,
	broacast_goods_info_change/2,
	broadcast_goods_change/4,
	broadcast_goods_change/5,
	broadcast_goods_change_info/1,
	check_is_equips_by_id/1,
	decompose/3,
	add_goods_1/4,
	check_expire_goods/1,
	get_map_value_from_extra/1,
	handle/3,
	get_wing_button_tips/1,
	get_server_use/1
]).


-export([
	get_goods_info_list_need_cell/1,
	get_goods_list_need_cell/1,
	add_goods_list_and_send_mail_1/2,
	add_player_goods_info/2,
	delete_goods_manage/3
]).

%% ====================================================================
%% API functions
%% ====================================================================

%% 初始化玩家道具
init_goods(State) ->
	PlayerId = State#player_state.player_id,
	%%  初始化dict
	goods_dict:init_dict(),

	case goods_cache:select_all(PlayerId) of
		[] ->
			goods_dict:init_bag_cell(),
			%% 更新玩家外观
			update_guise_state(State);
		List ->
			%% 零时修改
			[GoodsList, EquipsList, StoreList, Cell, SCell] = unpack_goods_data(List),
			goods_dict:set_bag_cell(Cell),
			goods_dict:set_store_bag_cell(SCell),
			goods_dict:save_player_goods_list(GoodsList),
			goods_dict:save_player_equips_list(EquipsList),
			goods_dict:save_player_store_list(StoreList),

			%% 技能检测
			State1 = update_equips_skill(State, EquipsList),
			%% 更新限时道具列表到state
			State2 = update_expire_goods_list(State1, GoodsList, EquipsList, StoreList),
			%% 更新玩家外观
			update_guise_state(State2)
	end.

%% 解包物品数据，并导入进程字典
unpack_goods_data(CacherList) ->
	%% 通常道具
	NowTime = util_date:unixtime(),
	F = fun(GoodsInfo, [GoodsList, EquipsList, StoreList, Cell, SCell]) ->
		case is_record(GoodsInfo, db_goods) of
			true ->
				Id = GoodsInfo#db_goods.id,
				GoodsId = GoodsInfo#db_goods.goods_id,
				Num = GoodsInfo#db_goods.num,
				IsBind = GoodsInfo#db_goods.is_bind,
				Location = GoodsInfo#db_goods.location,
				ExpireTime = GoodsInfo#db_goods.expire_time,

				%% 时效性道具检测
				GoodsConf = goods_lib:get_goods_conf_by_id(GoodsId),
				case ExpireTime > 0 andalso NowTime >= ExpireTime andalso GoodsConf#goods_conf.is_timeliness_delete == 0 of
					true ->
						%% 过期删除道具
						PlayerId = GoodsInfo#db_goods.player_id,
						goods_cache:delete(Id, PlayerId),
						[GoodsList, EquipsList, StoreList, Cell, SCell];
					false ->
						%% 补偿检测
						case goods_compensate:mounts_compensate(GoodsInfo) of
							ok ->
								[GoodsList, EquipsList, StoreList, Cell, SCell];
							_ ->
								case Location =:= ?STORE_LOCATION_TYPE of
									true ->
										goods_dict:update_store_num_to_dict(GoodsId, Id, IsBind, Num),
										StoreList1 = lists:append([GoodsInfo], StoreList),
										[GoodsList, EquipsList, StoreList1, Cell, SCell + 1];
									false ->
										goods_dict:update_goods_num_to_dict(GoodsId, Id, IsBind, Num),
										case check_is_equips_by_id(GoodsId) of
											true ->
												EquipsList1 = lists:append([GoodsInfo], EquipsList),
												Cell1 = case check_goods_is_in_bag(GoodsInfo) of true -> Cell; false ->
													Cell + 1 end,
												[GoodsList, EquipsList1, StoreList, Cell1, SCell];
											false ->
												GoodsList1 = lists:append([GoodsInfo], GoodsList),
												[GoodsList1, EquipsList, StoreList, Cell + 1, SCell]
										end
								end
						end
				end;
			_ ->
				[GoodsList, EquipsList, StoreList, Cell, SCell]
		end
	end,
	lists:foldl(F, [[], [], [], 0, 0], CacherList).

%% 更新玩家外观
update_guise_state(State) ->

	DbBase = State#player_state.db_player_base,
	WingState = DbBase#db_player_base.wing_state,%%
	WeaponState = DbBase#db_player_base.weapon_state,

	%% 2套装备武器优先级检测
	WeaponInfo = equips_lib:get_equips_info_from_grid(?SUBTYPE_SP_WEAPON),
	ResWeapon = case WeaponInfo =:= [] orelse WeaponState =:= 1 of
					true ->
						case equips_lib:get_equips_info_from_grid(?SUBTYPE_WEAPON) of
							[] ->
								?DEFAULT_GUISE_WEAPON;
							Info ->
								Id = Info#db_goods.goods_id,
								Conf = get_goods_conf_by_id(Id),
								Conf#goods_conf.res
						end;
					_ ->
						GoodsId = WeaponInfo#db_goods.goods_id,
						GoodsConf = get_goods_conf_by_id(GoodsId),
						GoodsConf#goods_conf.res
				end,

	case equips_lib:get_equips_info_from_grid(?SUBTYPE_CLOTHES) of
		[] ->
			ResCLOTHES = ?DEFAULT_GUISE_CLOTHES;
		GoodsInfo1 ->
			GoodsId1 = GoodsInfo1#db_goods.goods_id,
			GoodsConf1 = get_goods_conf_by_id(GoodsId1),
			ResCLOTHES = GoodsConf1#goods_conf.res
	end,


	%% 隐藏翅膀外观判断
	ResWing =
		case WingState == 1 of
			true ->
				0;
			false ->
				case equips_lib:get_equips_info_from_grid(?SUBTYPE_WING) of
					[] ->
						0;
					GoodsInfo2 ->
						case GoodsInfo2#db_goods.expire_time == 0 orelse
							GoodsInfo2#db_goods.expire_time > util_date:unixtime() of
							true ->
								GoodsId2 = GoodsInfo2#db_goods.goods_id,
								GoodsConf2 = get_goods_conf_by_id(GoodsId2),
								GoodsConf2#goods_conf.res;
							false ->
								0
						end
				end
		end,

	%% 宠物删除
%% 	case equips_lib:get_equips_info_from_grid(?SUBTYPE_PET) of
%% 		[] ->
%% 			ResPet = 0;
%% 		GoodsInfo3 ->
%% 			GoodsId3 = GoodsInfo3#db_goods.goods_id,
%% 			GoodsConf3 = get_goods_conf_by_id(GoodsId3),
%% 			ResPet = GoodsConf3#goods_conf.res
%% 	end,
	case equips_lib:get_equips_info_from_grid(?SUBTYPE_MOUNTS) of
		[] ->
			ResMonth = 0;
		GoodsInfo3 ->
			GoodsId3 = GoodsInfo3#db_goods.goods_id,
			GoodsConf3 = get_goods_conf_by_id(GoodsId3),
			ResMonth = GoodsConf3#goods_conf.res
	end,

	%% 坐骑光环处理
	DPMark = State#player_state.db_player_mark,
	Career = DbBase#db_player_base.career,
	Lv = lists:min([DPMark#db_player_mark.mounts_mark_1, DPMark#db_player_mark.mounts_mark_2,
		DPMark#db_player_mark.mounts_mark_3, DPMark#db_player_mark.mounts_mark_4]),
	MarkConf = mark_config:get({?MARK_TYPE_MOUNTS_1, Lv, Career}),
	ResMountAura = MarkConf#mark_conf.res,

	GuiseState = #guise_state{weapon = ResWeapon, clothes = ResCLOTHES, wing = ResWing, pet = 0, mounts = ResMonth, mounts_aura = ResMountAura},

	State#player_state{guise = GuiseState}.

%% 更新装备自带技能
update_equips_skill(State, EquipsList) ->
	PassList = State#player_state.pass_trigger_skill_list,
	Fun = fun(GoodsInfo, Acc) ->
		GoodsId = GoodsInfo#db_goods.goods_id,
		case GoodsInfo#db_goods.location =:= 1 of
			true ->
				GoodsConf = get_goods_conf_by_id(GoodsId),
				Extra = GoodsConf#goods_conf.extra,
				case lists:keyfind(skill, 1, Extra) of
					{_, SkillId, SkillLv} ->
						lists:keystore(SkillId, 1, Acc, {SkillId, SkillLv});
					_ ->
						Acc
				end;
			false ->
				Acc
		end
	end,
	NewPassList = lists:foldl(Fun, PassList, EquipsList),
	State#player_state{pass_trigger_skill_list = NewPassList}.

%% 更新限时道具检测列表
update_expire_goods_list(State, GoodsList, EquipsList, StoreList) ->
	NowTime = util_date:unixtime(),
	%% 加载所有还没过期的道具
	List1 = [{X#db_goods.id, X#db_goods.expire_time} || X <- GoodsList, X#db_goods.expire_time > 0 andalso X#db_goods.expire_time > NowTime],
	List2 = [{X#db_goods.id, X#db_goods.expire_time} || X <- EquipsList, X#db_goods.expire_time > 0 andalso X#db_goods.expire_time > NowTime],
	List3 = [{X#db_goods.id, X#db_goods.expire_time} || X <- StoreList, X#db_goods.expire_time > 0 andalso X#db_goods.expire_time > NowTime],
	List = List1 ++ List2 ++ List3,
	State#player_state{expire_goods_list = List}.

%% 添加道具
add_goods(State, GoodsId, IsBind, Num) when Num > 0 andalso (IsBind =:= ?NOT_BIND orelse IsBind == ?BIND) andalso is_record(State, player_state) ->
	GoodsConf = get_goods_conf_by_id(GoodsId),
	if
		GoodsConf#goods_conf.type =:= ?GOODS_TYPE_VALUE ->
			SubType = GoodsConf#goods_conf.sub_type,
			add_value_goods(State, SubType, Num);
		GoodsConf#goods_conf.type =:= ?GOODS_TYPE_EQUIPS andalso
			GoodsConf#goods_conf.sub_type =:= ?SUBTYPE_WING ->
			add_wing_goods(State, GoodsId);
		GoodsConf#goods_conf.type =:= ?GOODS_TYPE_EQUIPS andalso
			GoodsConf#goods_conf.sub_type =:= ?SUBTYPE_MEDAL ->
			goods_lib:add_medal_goods(State, GoodsId);
		GoodsConf#goods_conf.type =:= ?GOODS_TYPE_EQUIPS andalso
			GoodsConf#goods_conf.sub_type =:= ?SUBTYPE_MOUNTS ->
			goods_lib:add_mounts_goods(State, GoodsId);
		GoodsConf#goods_conf.type =:= ?GOODS_TYPE_EQUIPS andalso
			GoodsConf#goods_conf.sub_type =:= ?SUBTYPE_RING_POWER ->
			add_ring_goods(State, GoodsId, ?SUBTYPE_RING_POWER);
		GoodsConf#goods_conf.type =:= ?GOODS_TYPE_EQUIPS andalso
			GoodsConf#goods_conf.sub_type =:= ?SUBTYPE_RING_DEFENSE ->
			add_ring_goods(State, GoodsId, ?SUBTYPE_RING_DEFENSE);
		GoodsConf#goods_conf.type =:= ?GOODS_TYPE_EQUIPS andalso
			GoodsConf#goods_conf.sub_type =:= ?SUBTYPE_RING_LIFE ->
			add_ring_goods(State, GoodsId, ?SUBTYPE_RING_LIFE);
		true ->
			add_goods_1(State, GoodsId, IsBind, Num)
	end.

add_goods_1(State, GoodsId, IsBind, Num) ->
	case check_goods_cond(State, GoodsId, IsBind, Num) of
		{ok, GoodsConfig} ->
			Result =
				case GoodsConfig#goods_conf.limit_num of
					1 ->                                                                %% 不能堆叠道具
						add_unstack_goods(State, GoodsId, IsBind, Num);
					_ ->                                                                %% 有堆叠限制道具
						add_stack_goods(State, GoodsId, IsBind, Num)
				end,

			case Result of
				{ok, NewState} -> add_goods_manage(NewState, GoodsId, IsBind, Num);
				{fail, R} -> {fail, R}
			end;
		{fail, Reply} ->
			{fail, Reply}
	end.

%% 添加数值型道具
add_value_goods(State, SubType, Num) ->
	case SubType of
		?SUBTYPE_JADE ->
			player_lib:incval_on_player_money_log(State, #db_player_money.jade, Num, 0);
		?SUBTYPE_COIN ->
			player_lib:incval_on_player_money_log(State, #db_player_money.coin, Num, 0);
		?SUBTYPE_GIFT ->
			player_lib:incval_on_player_money_log(State, #db_player_money.gift, Num, 0);
		?SUBTYPE_EXP ->
			player_lib:add_exp(State, Num, {0, []});
		?SUBTYPE_REPUTATION ->
			arena_lib:add_player_arena_reputation(State, Num, ?LOG_TYPE_GM);
		?SUBTYPE_FEATS ->
			player_lib:incval_on_player_money_log(State, #db_player_money.feats, Num, 0);
		?SUBTYPE_GUILD_EXP ->
			PlayerBase = State#player_state.db_player_base,
			GuildId = PlayerBase#db_player_base.guild_id,
			Args = [State, GuildId, Num, 0],
			guild_mod:update_guild(GuildId, fun guild_contribution:update_guild_info_by_donation/4, Args),
			{ok, State};
		?SUBTYPE_GUILD_CAPITAL ->
			PlayerBase = State#player_state.db_player_base,
			GuildId = PlayerBase#db_player_base.guild_id,
			Args = [State, GuildId, 0, Num],
			guild_mod:update_guild(GuildId, fun guild_contribution:update_guild_info_by_donation/4, Args),
			{ok, State};
		?SUBTYPE_GUILD_CON ->
			guild_contribution:update_player_contribution(State, Num),
			{ok, State};
		?SUBTYPE_VIP_EXP ->
			State1 = vip_lib:add_vip_exp(State, Num),
			{ok, State1};
		?SUBTYPE_HP_MARK_VALUE ->
			{ok, State1} = player_lib:incval_on_player_money_log(State, #db_player_money.hp_mark_value, Num, 0),
			player_mark_lib:check_button_red(State1, ?MARK_TYPE_HP);
		?SUBTYPE_ATK_MARK_VALUE ->
			{ok, State1} = player_lib:incval_on_player_money_log(State, #db_player_money.atk_mark_value, Num, 0),
			player_mark_lib:check_button_red(State1, ?MARK_TYPE_ATK);
		?SUBTYPE_DEF_MARK_VALUE ->
			{ok, State1} = player_lib:incval_on_player_money_log(State, #db_player_money.def_mark_value, Num, 0),
			player_mark_lib:check_button_red(State1, ?MARK_TYPE_DEF);
		?SUBTYPE_RES_MARK_VALUE ->
			{ok, State1} = player_lib:incval_on_player_money_log(State, #db_player_money.res_mark_value, Num, 0),
			player_mark_lib:check_button_red(State1, ?MARK_TYPE_RES);
		_ ->
			{ok, State}
	end.

%% 添加不可堆叠道具
add_unstack_goods(State, GoodsId, IsBind, Num) ->
	Fun = fun(_, State1) ->
		{ok, NewState} = add_player_goods_info(State1, GoodsId, IsBind, 1, []),
		NewState
	end,
	State2 = lists:foldr(Fun, State, lists:seq(1, Num)),

	{ok, State2}.

%% 添加可堆叠道具
add_stack_goods(State, GoodsId, IsBind, Num) ->
	LimitNum = get_limit_num(GoodsId),

	case goods_dict:check_is_exist_goods(GoodsId, IsBind) of
		true ->
			[{Key, KeyNum} | _] = goods_dict:get_value_from_dict_by_id(GoodsId, IsBind),
			case KeyNum =:= LimitNum of
				true ->
					add_stack_goods_1(State, GoodsId, IsBind, Num);
				false ->
					add_stack_goods_2(State, GoodsId, IsBind, Num, Key, KeyNum)
			end;
		false ->
			add_stack_goods_1(State, GoodsId, IsBind, Num)
	end.

%% 循环添加道具
add_stack_goods_1(State, GoodsId, IsBind, Num) ->
	LimitNum = get_limit_num(GoodsId),

	case Num > LimitNum of
		true ->
			{ok, State1} = add_player_goods_info(State, GoodsId, IsBind, LimitNum, []),
			add_stack_goods_1(State1, GoodsId, IsBind, Num - LimitNum);
		false ->
			add_player_goods_info(State, GoodsId, IsBind, Num, [])
	end.

%% 更新key后添加道具
add_stack_goods_2(State, GoodsId, IsBind, Num, Id, KeyNum) ->
	LimitNum = get_limit_num(GoodsId),
	case get_player_goods_info(Id, GoodsId, false) of %%
		{fail, Err} ->
			{fail, Err};
		GoodsInfo ->
			case Num + KeyNum > LimitNum of
				true ->
					{ok, State1} = update_player_goods_info(State, GoodsInfo#db_goods{num = LimitNum}),
					RemainNum = Num + KeyNum - LimitNum,
					add_stack_goods(State1, GoodsId, IsBind, RemainNum);
				false ->
					update_player_goods_info(State, GoodsInfo#db_goods{num = Num + KeyNum})
			end
	end.

%% 添加商品列表
add_goods_list(State, GoodsList) ->
	PlayerBase = State#player_state.db_player_base,
	AllCell = PlayerBase#db_player_base.bag,
	UseCell = goods_dict:get_bag_cell(),
	NeedCell = get_goods_list_need_cell(GoodsList),

	case UseCell + NeedCell > AllCell of
		true ->
			{fail, ?ERR_PLAYER_BAG_NOT_ENOUGH};
		false ->

			Fun1 = fun({GoodsId, IsBind, Num}, PS) ->
				{ok, PS1} = add_goods(PS, GoodsId, IsBind, Num),
				PS1
			end,
			State1 = lists:foldl(Fun1, State, GoodsList),
			{ok, State1}
	end.

%% 添加道具列表(且自动出售)  挂机专用
add_goods_list_and_auto_sell(State, GoodsList) ->
	Base = State#player_state.db_player_base,
	Fun = fun({GoodsId, IsBind, Num}, [Acc, Zcc, PS]) ->
		GoodsConf = get_goods_conf_by_id(GoodsId),
		%% 加上设置判断
		case set_lib:is_equip_sell(Base#db_player_base.equip_sell_set, GoodsConf) of
			true ->
				%% 如果为真就是要卖出的装备， 那么处理卖出逻辑
				Sale = GoodsConf#goods_conf.sale,
				Zcc1 =
					case GoodsConf#goods_conf.type =:= ?EQUIPS_TYPE of
						true ->
							Quality = GoodsConf#goods_conf.quality,
							case lists:keyfind(Quality, 1, Zcc) of
								{_, N} ->
									lists:keyreplace(Quality, 1, Zcc, {Quality, N + Num});
								_ ->
									lists:append(Zcc, [{Quality, Num}])
							end;
						false ->
							Zcc
					end,
				[Num * Sale + Acc, Zcc1, PS];
			_ ->
				case goods_lib_log:add_goods(PS, GoodsId, IsBind, Num, ?LOG_TYPE_HOOK) of
					{ok, PS1} ->
						[Acc, Zcc, PS1];
					{fail, _} ->
						Sale = GoodsConf#goods_conf.sale,
						Zcc1 =
							case GoodsConf#goods_conf.type =:= ?EQUIPS_TYPE of
								true ->
									Quality = GoodsConf#goods_conf.quality,
									case lists:keyfind(Quality, 1, Zcc) of
										{_, N} ->
											lists:keyreplace(Quality, 1, Zcc, {Quality, N + Num});
										_ ->
											lists:append(Zcc, [{Quality, Num}])
									end;
								false ->
									Zcc
							end,
						[Num * Sale + Acc, Zcc1, PS]
				end
		end
	end,
	[SellCoin, QList, State1] = lists:foldl(Fun, [0, [], State], GoodsList),

	{ok, PlayerState} = player_lib:incval_on_player_money_log(State1, #db_player_money.coin, SellCoin, ?LOG_TYPE_HOOK),

	{ok, PlayerState, SellCoin, QList}.


%% 单纯添加道具
add_equips(State, GoodsId, IsBind, Num, Extra) when Num > 0 andalso (IsBind =:= ?NOT_BIND orelse IsBind == ?BIND) ->
	case check_goods_cond(State, GoodsId, IsBind, Num) of
		{ok, _} ->
			Result = [add_player_goods_info(State, GoodsId, IsBind, 1, Extra) || _X <- lists:seq(1, Num)],
			[log_lib:log_goods_change(State, GoodsId, 1, ?LOG_TYPE_FORGE_EQUIPS) || _X <- lists:seq(1, Num)],
			Result;
		{fail, Reply} ->
			{fail, Reply}
	end.

%% 添加道具根据道具信息
add_goods_by_goods_info(State, GoodsInfo) ->
	GoodsId = GoodsInfo#db_goods.goods_id,
	IsBind = GoodsInfo#db_goods.is_bind,
	Num = GoodsInfo#db_goods.num,
	GoodsConf = get_goods_conf_by_id(GoodsId),
	case GoodsConf#goods_conf.type =:= ?TYPE_EQUIPS of
		true ->
			PlayerBase = State#player_state.db_player_base,
			AllCell = PlayerBase#db_player_base.bag,
			UseCell = goods_dict:get_bag_cell(),
			case AllCell - UseCell > 0 of
				true ->
					add_player_goods_info(State, GoodsInfo);
				false ->
					{fail, ?ERR_PLAYER_BAG_NOT_ENOUGH}
			end;
		false ->
			add_goods(State, GoodsId, IsBind, Num)
	end.

%% 添加商品列表
add_goods_list_by_goods_info(State, GoodsInfoList) ->
	PlayerBase = State#player_state.db_player_base,
	AllCell = PlayerBase#db_player_base.bag,
	UseCell = goods_dict:get_bag_cell(),
	NeedCell = get_goods_info_list_need_cell(GoodsInfoList),

	case UseCell + NeedCell > AllCell of
		true ->
			{fail, ?ERR_PLAYER_BAG_NOT_ENOUGH};
		false ->

			Fun1 = fun(GoodsInfo, PS) ->
				{ok, PS1} = add_goods_by_goods_info(PS, GoodsInfo),
				PS1
			end,
			State1 = lists:foldl(Fun1, State, GoodsInfoList),
			{ok, State1}
	end.

%% 添加道具列表(背包已满发送邮件)
add_goods_list_and_send_mail(State, GoodsList) ->
	case add_goods_list(State, GoodsList) of
		{ok, State1} ->
			{ok, State1};
		{fail, _} ->
			%% 发送邮件
			add_goods_list_and_send_mail_1(State, GoodsList),
			{ok, State}
	end.

add_goods_list_and_send_mail_1(State, GoodsList) ->
	case length(GoodsList) > 5 of
		true ->
			{List1, List2} = lists:split(5, GoodsList),
			add_goods_list_and_send_mail_2(State, List1),
			add_goods_list_and_send_mail_1(State, List2);
		false ->
			add_goods_list_and_send_mail_2(State, GoodsList)
	end.

add_goods_list_and_send_mail_2(State, GoodsList) ->
	%% 发送邮件
	PlayerId = State#player_state.player_id,
	Sender = "",
	Title = xmerl_ucs:to_utf8("系统邮件"),
	Content = xmerl_ucs:to_utf8("由于背包空间不足,奖励通过邮件发放"),
	mail_lib:send_mail_to_player(PlayerId, Sender, Title, Content, GoodsList).

%% 删除所有道具(利用道具唯一ID删除道具)
delete_goods_by_id(State, Id, GoodsId) ->
	delete_goods_by_id(State, Id, GoodsId, true).
delete_goods_by_id(State, Id, GoodsId, IsBroadCast) ->
	case get_player_goods_info(Id, GoodsId, false) of %%
		{fail, Err} ->
			{fail, Err};
		GoodsInfo ->
			{ok, NewState} = delete_player_goods_info(State, GoodsInfo, IsBroadCast),
			delete_goods_manage(NewState, GoodsId, GoodsInfo#db_goods.num)
	end.

%% 删除装备道具(利用道具唯一ID删除道具)
delete_equips_by_id(State, Id) ->
	case get_player_equips_info_by_id(Id) of
		#db_goods{} = GoodsInfo ->
			{ok, NewState} = delete_player_goods_info(State, GoodsInfo),
			log_lib:log_goods_change(State, GoodsInfo#db_goods.goods_id, GoodsInfo#db_goods.num, ?LOG_TYPE_DEVOUR_ARTIFACT),
			delete_goods_manage(NewState, GoodsInfo#db_goods.goods_id, GoodsInfo#db_goods.num);
		_ ->
			{fail, ?ERR_GOODS_NOT_ENOUGH}
	end.
delete_equips_by_id(State, Id, IsBroad) ->
	case get_player_equips_info_by_id(Id) of
		#db_goods{} = GoodsInfo ->
			{ok, NewState} = delete_player_goods_info(State, GoodsInfo, IsBroad),
			delete_goods_manage(NewState, GoodsInfo#db_goods.goods_id, GoodsInfo#db_goods.num);
		_ ->
			{fail, ?ERR_GOODS_NOT_ENOUGH}
	end.

%% 删除指定道具数量
delete_goods_by_id_and_num(State, Id, GoodsId, Num) ->
	case get_player_goods_info(Id, GoodsId, false) of %%
		{fail, Err} ->
			{fail, Err};
		GoodsInfo ->
			GoodsNum = GoodsInfo#db_goods.num,
			case Num == GoodsNum of
				true ->
					{ok, NewState} = delete_player_goods_info(State, GoodsInfo),
					delete_goods_manage(NewState, GoodsId, GoodsInfo#db_goods.num);
				false ->
					case Num > GoodsNum of
						true -> {fail, ?ERR_GOODS_NOT_ENOUGH};
						false ->
							{ok, NewState} = update_player_goods_info(State, GoodsInfo#db_goods{num = GoodsNum - Num}),
							delete_goods_manage(NewState, GoodsId, GoodsInfo#db_goods.num)
					end
			end
	end.

delete_goods_list_by_id_and_num(State, GoodsList) ->
	[delete_goods_by_id_and_num(State, Id, GoodsId, Num) || {Id, GoodsId, Num} <- GoodsList].

%% 删除道具(删除某个数量的道具,一	般系统使用)
delete_goods_by_num(State, GoodsId, Num) ->
	case is_goods_enough(GoodsId, Num) of
		true ->
			BindList = goods_dict:get_value_from_dict_by_id(GoodsId, ?BIND),
			NotBindList = goods_dict:get_value_from_dict_by_id(GoodsId, ?NOT_BIND),
			GoodsNumList = BindList ++ NotBindList,
			case delete_goods_by_num_1(State, GoodsId, Num, GoodsNumList) of
				{ok, State1} ->
					delete_goods_manage(State1, GoodsId, Num);
				Reply ->
					Reply
			end;
		false ->
			{fail, ?ERR_GOODS_NOT_ENOUGH}
	end.

delete_goods_by_num_1(State, _GoodsId, 0, _GoodsNumList) ->
	{ok, State};
delete_goods_by_num_1(State, GoodsId, Num, [H | T]) ->
	{Id, GoodsNum} = H,
	case get_player_goods_info(Id, GoodsId, false) of %%
		{fail, Err} ->
			{fail, Err};
		GoodsInfo ->
			case GoodsNum > Num andalso GoodsInfo#db_goods.location =:= 0 of
				true ->
					update_player_goods_info(State, GoodsInfo#db_goods{num = GoodsNum - Num});
				false ->
					{ok, State1} = delete_player_goods_info(State, GoodsInfo),
					delete_goods_by_num_1(State1, GoodsId, Num - GoodsNum, T)
			end
	end.

%% 删除道具列表(key)
delete_goods_list_by_id(State, GoodsList) ->
	Fun = fun({Id, GoodsId}, {_, AccState}) ->
		delete_goods_by_id(AccState, Id, GoodsId)
	end,
	lists:foldl(Fun, {ok, State}, GoodsList).

%% 删除道具列表(Info)
delete_goods_list_by_info(State, GoodsList) ->
	Fun = fun(DbInfo, {_, AccState}) ->
		Id = DbInfo#db_goods.id,
		GoodsId = DbInfo#db_goods.goods_id,
		delete_goods_by_id(AccState, Id, GoodsId)
	end,
	lists:foldl(Fun, {ok, State}, GoodsList).

%% 删除道具列表(数量)
delete_goods_list_by_num(State, GoodsList) ->
	Fun = fun({GoodsId, Num}) ->
		delete_goods_by_num(State, GoodsId, Num)
	end,
	[Fun(X) || {X} <- GoodsList],
	{ok, State}.

%% 按品质出售装备
sell_equips_by_quality(State, Quality) ->
	EquipsInfoList = goods_dict:get_player_equips_list(),

	Fun = fun(GoodsInfo, {Coin, List}) ->
		GoodsId = GoodsInfo#db_goods.goods_id,
		GoodsConf = get_goods_conf_by_id(GoodsId),
		Quality1 = GoodsConf#goods_conf.quality,
		IsSell = GoodsConf#goods_conf.is_sell,
		Location = GoodsInfo#db_goods.location,
		IsArtifact = lists:keyfind(?EQUIPS_AIRFACT_KEY, 1, GoodsInfo#db_goods.extra),
		case Quality =:= Quality1 andalso Location =/= 1 andalso IsArtifact =:= false andalso
			IsSell =/= 1 of
			true ->
				%% 删除装备
				Id = GoodsInfo#db_goods.id,
				case delete_goods_by_id(State, Id, GoodsId, false) of
					{ok, _} ->
						Num = GoodsInfo#db_goods.num,

						Sale = GoodsConf#goods_conf.sale,
						log_lib:log_goods_change(State, GoodsId, Num, ?LOG_TYPE_SALE),
						{Num * Sale + Coin, List ++ [Id]};
					_ ->
						{Coin, List}
				end;
			false ->
				{Coin, List}
		end
	end,
	{SellCoin, SuccList} = lists:foldl(Fun, {0, []}, EquipsInfoList),

	{ok, State1} = player_lib:incval_on_player_money_log(State, #db_player_money.coin, SellCoin, ?LOG_TYPE_SELL_GOODS),
	{ok, State1, SellCoin, SuccList}.

%% 出售道具列表根据道具唯一ID
sell_goods_list_by_id(State, IdList) ->
	Fun = fun(Id, {Coin, List, Reply}) ->
		case get_player_goods_info(Id, false) of%%
			{fail, Err} ->
				{Coin, List, Err};
			GoodsInfo ->
				GoodsId = GoodsInfo#db_goods.goods_id,
				GoodsConf = get_goods_conf_by_id(GoodsId),
				%% 删除装备
				Id = GoodsInfo#db_goods.id,
				IsSell = GoodsConf#goods_conf.is_sell,
				Location = GoodsInfo#db_goods.location,
				case Location =/= 1 andalso IsSell =/= 1 of
					true ->
						case delete_goods_by_id(State, Id, GoodsId, false) of
							{ok, _} ->
								Num = GoodsInfo#db_goods.num,
								Sale = GoodsConf#goods_conf.sale,
								log_lib:log_goods_change(State, GoodsId, Num, ?LOG_TYPE_SALE),
								{Num * Sale + Coin, List ++ [Id], Reply};
							_ ->
								{Coin, List, Reply}
						end;
					false ->
						{Coin, List, ?ERR_CANNOT_SELL}
				end
		end
	end,
	{SellCoin, SuccList, NewReply} = lists:foldl(Fun, {0, [], ?ERR_COMMON_SUCCESS}, IdList),

	{ok, State1} = player_lib:incval_on_player_money_log(State, #db_player_money.coin, SellCoin, ?LOG_TYPE_SELL_GOODS),
	{ok, State1, SellCoin, SuccList, NewReply}.

%% 出售指定数量道具
sell_goods_by_id_and_num(State, Id, Num) ->
	case get_player_goods_info(Id, false) of %%
		{fail, Err} ->
			{fail, Err};
		GoodsInfo ->
			sell_goods_by_id_and_num_1(State, GoodsInfo, Num)
	end.

sell_goods_by_id_and_num_1(State, GoodsInfo, Num) ->
	GoodNum = GoodsInfo#db_goods.num,
	case GoodNum >= Num of
		true ->
			sell_goods_by_id_and_num_2(State, GoodsInfo, Num);
		false ->
			{fail, ?ERR_GOODS_NOT_ENOUGH}
	end.

sell_goods_by_id_and_num_2(State, GoodsInfo, Num) ->
	GoodsId = GoodsInfo#db_goods.goods_id,
	GoodsConf = get_goods_conf_by_id(GoodsId),
	IsSell = GoodsConf#goods_conf.is_sell,
	Location = GoodsInfo#db_goods.location,
	case Location =/= 1 andalso IsSell =/= 1 of
		true ->
			%% 删除装备
			Id = GoodsInfo#db_goods.id,
			delete_goods_by_num(State, Id, Num),
			log_lib:log_goods_change(State, GoodsId, Num, ?LOG_TYPE_SALE),
			%% 添加金币
			SellCoin = GoodsConf#goods_conf.sale,
			player_lib:incval_on_player_money_log(State, #db_player_money.coin, SellCoin, ?LOG_TYPE_SELL_GOODS);
		false ->
			{fail, ?ERR_CANNOT_SELL}
	end.

%% 使用道具
use_goods(State, GoodsId, Num) when Num > 0 ->
	case check_use_goods(State, GoodsId, Num) of
		{ok, Extra} ->
			case Num > 1 of
				false ->
					use_goods_screen(State, GoodsId, Extra);
				true ->
					use_goods_by_effect(State, GoodsId, Num, Extra)
			end;
		{fail, Reply} ->
			{fail, Reply}
	end.

use_goods_screen(State, GoodsId, Extra) ->
	case GoodsId of
		110049 ->   %% 祝福油特殊处理
			use_goods_by_bless_oil(State, GoodsId, normal_bless_oil);
		110147 ->    %% 特殊祝福油
			use_goods_by_bless_oil(State, GoodsId, special_bless_oil);
		_ ->
			%% 特殊处理
			%% 初始化玩家道具推送为不广播模式
			State1 = State#player_state{
				is_lottery_begin = true,
				equip_list = [],
				goods_list = [],
				bag_goods_list = []
			},
			case use_goods_by_effect(State1, GoodsId, Extra) of
				{ok, State2} ->
					%% 是否发送公告信息 组合公告信息
					GoodsConf = goods_config:get(GoodsId),
					%% 删除消耗
					{ok, State2_1} =
						case GoodsConf#goods_conf.cost /= [] of
							true ->
								goods_util:delete_special_list_jade(State2, GoodsConf#goods_conf.cost, ?LOG_TYPE_TRANSFER);
							_ ->
								{ok, State2}
						end,
					case GoodsConf#goods_conf.notice_id > 0 of
						true ->
							?INFO("~p", [State2_1#player_state.bag_goods_list]),
							Base = State#player_state.db_player_base,
							F = fun(X) ->
								{TempGoodsId, _TempIsBind, TempNum} = X,
								TempGoodsConf = goods_config:get(TempGoodsId),
								io_lib:format("~s*~w", [TempGoodsConf#goods_conf.name, TempNum])
							end,
							NoticeInfoList = [F(X) || X <- State2_1#player_state.bag_goods_list],
							GoodsStr = string:join(NoticeInfoList, ", "),
							notice_lib:send_notice(0, GoodsConf#goods_conf.notice_id, [Base#db_player_base.name, GoodsStr]);
						_ ->
							skip
					end,

					%% 推送改变的道具列表给前段  并重置广播状态
					State3 = goods_lib:broadcast_goods_change_info(State2_1),
					{ok, State3};
				{fail, Reply} ->
					{fail, Reply}
			end
	end.

use_goods_by_bless_oil(State, GoodsId, Type) ->
	case goods_util:use_goods_bless_oil(Type, State) of
		{ok, State1} ->
			delete_goods_by_num(State, GoodsId, 1),
			log_lib:log_goods_change(State, GoodsId, -1, ?LOG_TYPE_GOOD_EFFECT),
			{ok, State1};
		{fail, ?ERR_BLESS_OIL_NOT_EFFECT} ->
			delete_goods_by_num(State, GoodsId, 1),
			log_lib:log_goods_change(State, GoodsId, -1, ?LOG_TYPE_GOOD_EFFECT),
			{fail, ?ERR_BLESS_OIL_NOT_EFFECT};
		{fail, Reply} ->
			{fail, Reply}
	end.

use_goods_by_effect(State, GoodsId, Extra) ->
	case goods_util:use_goods_effect(State, Extra) of
		{ok, State1} ->
			%% 扣除道具
			update_goods_cd_list(GoodsId),
			{ok, State2} = player_lib:update_player_state(State, State1),
			{ok, State3} = delete_goods_by_num(State2, GoodsId, 1),

			log_lib:log_goods_change(State2, GoodsId, -1, ?LOG_TYPE_GOOD_EFFECT),
			{ok, State3};
		{refuse_attr, State1} -> %% 需要刷新属性
			%% 扣除道具
			update_goods_cd_list(GoodsId),
			{ok, State2} = player_lib:update_player_state(State, State1, true, true),
			{ok, State3} = delete_goods_by_num(State2, GoodsId, 1),
			log_lib:log_goods_change(State2, GoodsId, -1, ?LOG_TYPE_GOOD_EFFECT),
			{ok, State3};
		{fail, Reply} ->
			{fail, Reply};
		{_, State1} ->
			{ok, State2} = player_lib:update_player_state(State, State1),
			update_goods_cd_list(GoodsId),
			{ok, State3} = delete_goods_by_num(State2, GoodsId, 1),
			log_lib:log_goods_change(State2, GoodsId, -1, ?LOG_TYPE_GOOD_EFFECT),
			{ok, State3}
	end.

use_goods_by_effect(State, GoodsId, Num, Extra) ->
	case goods_util:use_goods_effect(State, Num, Extra) of
		{ok, State1} ->
			%% 扣除道具
			update_goods_cd_list(GoodsId),
			{ok, State2} = player_lib:update_player_state(State, State1),
			{ok, State3} = delete_goods_by_num(State2, GoodsId, Num),
			log_lib:log_goods_change(State, GoodsId, -Num, ?LOG_TYPE_GOOD_EFFECT),
			{ok, State3};
		{refuse_attr, State1} -> %% 需要刷新属性
			%% 扣除道具
			update_goods_cd_list(GoodsId),
			{ok, State2} = player_lib:update_player_state(State, State1, true, true),
			{ok, State3} = delete_goods_by_num(State2, GoodsId, Num),
			log_lib:log_goods_change(State, GoodsId, -Num, ?LOG_TYPE_GOOD_EFFECT),
			{ok, State3};
		{fail, Reply} ->
			{fail, Reply};
		{_, State1} ->
			{ok, State2} = player_lib:update_player_state(State, State1),
			update_goods_cd_list(GoodsId),
			{ok, State3} = delete_goods_by_num(State2, GoodsId, Num),
			log_lib:log_goods_change(State, GoodsId, -Num, ?LOG_TYPE_GOOD_EFFECT),
			{ok, State3}
	end.

%% 扩充背包
expend_bag(PlayerState) ->
	PlayerBase = PlayerState#player_state.db_player_base,
	PlayerBag = PlayerBase#db_player_base.bag,
	case PlayerBag >= ?MAX_BAG of
		false ->
			expend_bag_1(PlayerState);
		true ->
			{fail, ?ERR_MAX_BAG_LIMIT}
	end.

expend_bag_1(PlayerState) ->
	PlayerMoney = PlayerState#player_state.db_player_money,
	PlayerJade = PlayerMoney#db_player_money.jade,
	PlayerBase = PlayerState#player_state.db_player_base,
	PlayerBag = PlayerBase#db_player_base.bag,
	Count = ((PlayerBag - ?INIT_BAG) div ?EXPEND_BAG_BY_EVERYONE) + 1,
	NeedJade = Count * ?EXPEND_BAG_JADE,
	case PlayerJade >= NeedJade of
		true ->
			expend_bag_2(PlayerState);
		false ->
			{fail, ?ERR_PLAYER_JADE_NOT_ENOUGH}
	end.

expend_bag_2(PlayerState) ->
	PlayerBase = PlayerState#player_state.db_player_base,
	PlayerBag = PlayerBase#db_player_base.bag,
	PlayerBase1 = PlayerBase#db_player_base{bag = PlayerBag + ?EXPEND_BAG_BY_EVERYONE},
	PlayerState1 = PlayerState#player_state{db_player_base = PlayerBase1},
	Count = ((PlayerBag - ?INIT_BAG) div ?EXPEND_BAG_BY_EVERYONE) + 1,
	NeedJade = Count * ?EXPEND_BAG_JADE,
	%% 扣除金币
	{ok, PlayerState2} = player_lib:incval_on_player_money_log(PlayerState1, #db_player_money.jade, -NeedJade, false, ?LOG_TYPE_EXPEND_BAG),
	%% 更新属性
	player_lib:update_player_state(PlayerState, PlayerState2),
	{ok, PlayerState2}.

%% 分解
decompose(PlayerState, EquipsList, AddGoodsList) ->
	PlayerBase = PlayerState#player_state.db_player_base,
	AllCell = PlayerBase#db_player_base.bag,
	UseCell = goods_dict:get_bag_cell(),
	NeedCell = get_goods_list_need_cell(AddGoodsList),
	FreeCell = length(EquipsList),

	case AllCell >= UseCell - FreeCell + NeedCell of
		true ->
			[delete_equips_by_id(PlayerState, Id, true) || Id <- EquipsList],
			add_goods_list(PlayerState, AddGoodsList);
		false ->
			{fail, ?ERR_PLAYER_BAG_NOT_ENOUGH}
	end.


%% ====================================================================

%% 添加道具信息
add_player_goods_info(State, GoodsId, IsBind, Num, Extra) ->
	Id = get_new_goods_key(),
	PlayerId = State#player_state.player_id,

	%% 检测如果是装备自动添加洗练属性
	GoodsConf = get_goods_conf_by_id(GoodsId),
	NewExtra =
		case GoodsConf#goods_conf.id of
			?SPEC_TIMELESS_GOODS ->
				AttrList = [{1, 1, 23, 37}, {2, 1, 23, 37}, {3, 1, 23, 37}, {4, 1, 23, 37}],
				[{?EQUIPS_BAPTIZE_KEY, 0, AttrList}];
			_ ->
				case GoodsConf#goods_conf.type of
					?MAP_TYPE ->
						get_map_extra(State);
					_ ->
						Extra
				end
		end,

	%% 限时时间计算
	ExpireTime =
		case GoodsId of
			?SPEC_TIMELESS_GOODS ->
				{_, EndTime} = scene_activity_palace_lib:get_next_start_time(?SCENEID_SHABAKE),
				EndTime;
			_ ->
				case GoodsConf#goods_conf.is_timeliness of
					0 -> 0;
					Time -> util_date:unixtime() + Time
				end
		end,

	GoodsInfo = #db_goods{
		id = Id,
		player_id = PlayerId,
		goods_id = GoodsId,
		is_bind = IsBind,
		num = Num,
		extra = NewExtra,
		update_time = util_date:unixtime(),
		expire_time = ExpireTime,
		server_id = 0
	},
	%% 存库
	goods_cache:insert(GoodsInfo),

	%% 道具导入进程字典
	goods_dict:update_goods_num_to_dict(GoodsId, Id, IsBind, Num),

	%% 更新列表
	case check_is_equips_by_id(GoodsId) of
		true ->
			goods_dict:update_player_equips_list_by_info(GoodsInfo);
		false ->
			goods_dict:update_player_goods_list_by_info(GoodsInfo)
	end,

	%% 更新背包格子
	goods_dict:add_bag_cell(),

	%% 广播
	State1 = broacast_goods_info_change(State, GoodsInfo),%%

	%% 更新跨服数据信息
	scene_cross:ref_cross_goods(State1),

	%% 时效列表更新
	NewExpireList =
		case ExpireTime > 0 of
			true ->
				[{Id, ExpireTime}] ++ State1#player_state.expire_goods_list;
			false ->
				State1#player_state.expire_goods_list
		end,

	{ok, State1#player_state{expire_goods_list = NewExpireList}}.

add_player_goods_info(State, GoodsInfo) ->
	Id = get_new_goods_key(),
	GoodsId = GoodsInfo#db_goods.goods_id,
	PlayerId = State#player_state.player_id,
	Extra = GoodsInfo#db_goods.extra,
	IsBind = GoodsInfo#db_goods.is_bind,
	Num = GoodsInfo#db_goods.num,

	NewGoodsInfo = #db_goods{
		id = Id,
		player_id = PlayerId,
		goods_id = GoodsId,
		is_bind = IsBind,
		num = Num,
		extra = Extra,
		stren_lv = GoodsInfo#db_goods.stren_lv,
		soul = GoodsInfo#db_goods.soul,
		update_time = util_date:unixtime(),
		expire_time = GoodsInfo#db_goods.expire_time,
		bless = GoodsInfo#db_goods.bless,
		secure = GoodsInfo#db_goods.secure,
		server_id = GoodsInfo#db_goods.server_id
	},
	%% 存库
	goods_cache:insert(NewGoodsInfo),

	%% 道具导入进程字典
	goods_dict:update_goods_num_to_dict(GoodsId, Id, IsBind, Num),

	%% 更新列表
	case check_is_equips_by_id(GoodsId) of
		true ->
			goods_dict:update_player_equips_list_by_info(NewGoodsInfo);
		false ->
			goods_dict:update_player_goods_list_by_info(NewGoodsInfo)
	end,

	%% 更新背包格子
	goods_dict:add_bag_cell(),

	%% 广播
	State1 = broacast_goods_info_change(State, NewGoodsInfo),%%
	%% 更新跨服数据信息
	scene_cross:ref_cross_goods(State1),
	{ok, State1}.

%% 更新玩家道具信息
update_player_goods_info(State, GoodsInfo) ->
	Id = GoodsInfo#db_goods.id,
	PlayerId = GoodsInfo#db_goods.player_id,
	GoodsId = GoodsInfo#db_goods.goods_id,
	Num = GoodsInfo#db_goods.num,
	IsBind = GoodsInfo#db_goods.is_bind,

	%% 存库
	goods_cache:update(Id, PlayerId, GoodsInfo),

	goods_dict:update_goods_num_to_dict(GoodsId, Id, IsBind, Num),

	case check_is_equips_by_id(GoodsId) of
		true ->
			goods_dict:update_player_equips_list_by_info(GoodsInfo);
		false ->
			goods_dict:update_player_goods_list_by_info(GoodsInfo)
	end,

	%% 广播
	State1 = broacast_goods_info_change(State, GoodsInfo),%%
	%% 更新跨服数据信息
	scene_cross:ref_cross_goods(State1),
	{ok, State1}.

%% 更新玩家道具信息
update_player_goods_info_no_broadcast(State, GoodsInfo) ->
	Id = GoodsInfo#db_goods.id,
	PlayerId = GoodsInfo#db_goods.player_id,
	GoodsId = GoodsInfo#db_goods.goods_id,
	Num = GoodsInfo#db_goods.num,
	IsBind = GoodsInfo#db_goods.is_bind,

	%% 存库
	goods_cache:update(Id, PlayerId, GoodsInfo),

	goods_dict:update_goods_num_to_dict(GoodsId, Id, IsBind, Num),

	case check_is_equips_by_id(GoodsId) of
		true ->
			goods_dict:update_player_equips_list_by_info(GoodsInfo);
		false ->
			goods_dict:update_player_goods_list_by_info(GoodsInfo)
	end,

	{ok, State}.

%% 更新玩家道具信息
update_player_goods_info(State, GoodsInfo, BagBool) ->
	Id = GoodsInfo#db_goods.id,
	PlayerId = GoodsInfo#db_goods.player_id,
	GoodsId = GoodsInfo#db_goods.goods_id,
	Num = GoodsInfo#db_goods.num,
	IsBind = GoodsInfo#db_goods.is_bind,

	%% 存库
	goods_cache:update(Id, PlayerId, GoodsInfo),

	goods_dict:update_goods_num_to_dict(GoodsId, Id, IsBind, Num),

	case check_is_equips_by_id(GoodsId) of
		true ->
			goods_dict:update_player_equips_list_by_info(GoodsInfo);
		false ->
			goods_dict:update_player_goods_list_by_info(GoodsInfo)
	end,

	case BagBool of
		true ->
			goods_dict:add_bag_cell();
		false ->
			goods_dict:delete_bag_cell()
	end,

	%% 广播
	State1 = broacast_goods_info_change(State, GoodsInfo),%%
	%% 更新跨服数据信息
	scene_cross:ref_cross_goods(State1),
	{ok, State1}.

%% 删除玩家道具信息
delete_player_goods_info(State, GoodsInfo) ->
	delete_player_goods_info(State, GoodsInfo, true).
delete_player_goods_info(State, GoodsInfo, IsBroadCast) ->
	Id = GoodsInfo#db_goods.id,
	PlayerId = GoodsInfo#db_goods.player_id,
	GoodsId = GoodsInfo#db_goods.goods_id,
	IsBind = GoodsInfo#db_goods.is_bind,

	%% 存库
	goods_cache:delete(Id, PlayerId),

	%% 道具删除字典数据
	goods_dict:delete_goods_num_to_dict(GoodsId, Id, IsBind),

	case check_is_equips_by_id(GoodsId) of
		true ->
			goods_dict:delete_player_equips_list_by_info(GoodsInfo);
		false ->
			goods_dict:delete_player_goods_list_by_info(GoodsInfo)
	end,

	%% 更新背包格子(如果是删除穿戴身上的道具 不需要更新背包格子)
	case GoodsInfo#db_goods.location == ?EQUIPS_LOCATION_TYPE of
		true -> skip;
		_ -> goods_dict:delete_bag_cell()
	end,

	%% 广播
	State1 =
		case IsBroadCast of
			true ->
				%% 更新跨服数据信息
				scene_cross:ref_cross_goods(State),
				broacast_goods_info_change(State, GoodsInfo#db_goods{num = 0});%%
			_ ->
				State
		end,

	%% 时效列表更新
	NewExpireList = lists:keydelete(Id, 1, State#player_state.expire_goods_list),
	NewState = State1#player_state{expire_goods_list = NewExpireList},

	%% 检测如果是穿戴身上的装备,更新技能和外观
	case GoodsInfo#db_goods.location =:= ?EQUIPS_LOCATION_TYPE of
		true ->
			%% 外观变更检测
			UpdateState = equips_lib:restore_guise_state(NewState, GoodsInfo),
			UpdateState1 = UpdateState#player_state{pass_trigger_skill_list = State#player_state.pass_trigger_skill_list},
			UpdateState2 = equips_lib:update_equips_skill(UpdateState1, GoodsInfo, []),
			%% 更新玩家属性
			player_lib:update_player_state(NewState, UpdateState2);
		false ->
			{ok, NewState}
	end.

%% 道具cd更新
update_goods_cd_list(GoodsId) ->
	GoodsConf = goods_lib:get_goods_conf_by_id(GoodsId),
	Type = GoodsConf#goods_conf.type,
	SubType = GoodsConf#goods_conf.sub_type,
	ConfList = goods_type_config:get_list(),
	case lists:member({Type, SubType}, ConfList) of
		true ->
			TypeConf = goods_type_config:get({Type, SubType}),
			CdTime = TypeConf#goods_type_conf.cd_time,
			case CdTime > 0 of
				true ->
					CdList = goods_dict:get_goods_cd_list(),
					NowTime = util_date:unixtime(),
					CdList1 = lists:keystore({Type, SubType}, 1, CdList, {{Type, SubType}, NowTime + CdTime}),
					goods_dict:set_goods_cd_list(CdList1);
				false ->
					ok
			end;
		false ->
			skip
	end.

%% 添加道具成功额外处理
add_goods_manage(State, GoodsId, _IsBind, _GoodsNum) ->
	task_comply:update_player_tasksort_hava_goods(State, GoodsId),

	%% 按钮提示刷新
	{ok, NewState} = button_tips_lib:ref_button_tips(State, ?BTN_INSTANCE_SINGLE),
	set_lib:check_hpmp_button_tips(State, GoodsId),
	{ok, NewState}.

%% 删除道具完成额外处理
delete_goods_manage(State, GoodsId, _GoodsNum) ->
	task_comply:update_player_tasksort_hava_goods(State, GoodsId),

	%% 按钮提示刷新
	{ok, NewState} = button_tips_lib:ref_button_tips(State, ?BTN_INSTANCE_SINGLE),
	set_lib:check_hpmp_button_tips(State, GoodsId),
	{ok, NewState}.

%% 勋章专用接口
add_medal_goods(State, OldLv, NewLv) ->
	case OldLv < 25 andalso NewLv >= 25 of
		true ->
			PlayerId = State#player_state.player_id,
			DbBase = State#player_state.db_player_base,
			Career = DbBase#db_player_base.career,
			%% 临时添加勋章道具
			GoodsId = case Career of
						  ?CAREER_ZHANSHI ->
							  306000;
						  ?CAREER_FASHI ->
							  306200;
						  ?CAREER_DAOSHI ->
							  306400
					  end,

			case get_goods_num(GoodsId) == 0 of
				true ->
					Id = uid_lib:get_uid(?UID_TYPE_PLAYER_GOODS),
					GoodsInfo = #db_goods{
						id = Id,
						player_id = PlayerId,
						goods_id = GoodsId,
						is_bind = ?BIND,
						num = 1,
						location = ?EQUIPS_LOCATION_TYPE,
						grid = ?SUBTYPE_MEDAL,
						extra = [],
						update_time = util_date:unixtime(),
						server_id = 0
					},
					log_lib:log_goods_change(State, GoodsId, 1, ?LOG_TYPE_MEDAL_UPGRADE),

					%% 存库
					goods_cache:insert(GoodsInfo),

					%% 道具导入进程字典
					goods_dict:update_goods_num_to_dict(GoodsId, Id, ?BIND, 1),

					%% 更新列表
					goods_dict:update_player_equips_list_by_info(GoodsInfo),

					%% 广播
					State1 = broacast_goods_info_change(State, GoodsInfo),%%
					%% 更新跨服数据信息
					scene_cross:ref_cross_goods(State1),
					%% 刷新属性
					Result = player_lib:update_refresh_player(State1, #player_state{}),
					case Result of
						{ok, StateNew} ->
							log_lib:log_fight_goods_change(StateNew, State, GoodsInfo, true, ?LOG_TYPE_EQUIPS_ON);
						_ -> skip
					end,
					Result;
				false ->
					{ok, State}
			end;
		false ->
			{ok, State}
	end.

%% 勋章专用接口
add_medal_goods(State, GoodsId) ->
	case equips_lib:get_equips_info_from_grid(?SUBTYPE_MEDAL) of
		[] ->
			PlayerId = State#player_state.player_id,
			Id = uid_lib:get_uid(?UID_TYPE_PLAYER_GOODS),
			GoodsInfo = #db_goods{
				id = Id,
				player_id = PlayerId,
				goods_id = GoodsId,
				is_bind = ?BIND,
				num = 1,
				location = ?EQUIPS_LOCATION_TYPE,
				grid = ?SUBTYPE_WING,
				extra = [],
				update_time = util_date:unixtime(),
				server_id = 0
			},
			%% 存库
			goods_cache:insert(GoodsInfo),

			%% 道具导入进程字典
			goods_dict:update_goods_num_to_dict(GoodsId, Id, ?BIND, 1),

			%% 更新列表
			goods_dict:update_player_equips_list_by_info(GoodsInfo),

			%% 广播
			State1 = broacast_goods_info_change(State, GoodsInfo),%%
			%% 更新跨服数据信息
			scene_cross:ref_cross_goods(State1),
			%% 刷新属性
			PS1 = goods_lib:update_guise_state(State1),
			Result = player_lib:update_refresh_player(State, PS1),
			case Result of
				{ok, StateNew} ->
					log_lib:log_fight_goods_change(StateNew, State, GoodsInfo, true, ?LOG_TYPE_EQUIPS_ON);
				_ -> skip
			end,
			Result;
		GoodsInfo ->
			%% 机器人特殊处理
			case State#player_state.is_robot == 1 of
				true ->
					NewGoodsInfo = GoodsInfo#db_goods{goods_id = GoodsId},
					goods_dict:delete_goods_num_to_dict(GoodsInfo#db_goods.goods_id, GoodsInfo#db_goods.id, GoodsInfo#db_goods.is_bind),
					goods_lib:update_player_goods_info(State, NewGoodsInfo),
					player_lib:update_refresh_player(State, #player_state{});
				false ->
					{ok, State}
			end
	end.


%% 戒指专用接口
add_ring_goods(State, GoodsId, SubType) ->
	case equips_lib:get_equips_info_from_grid(SubType) of
		[] ->
			PlayerId = State#player_state.player_id,
			Id = uid_lib:get_uid(?UID_TYPE_PLAYER_GOODS),
			GoodsInfo = #db_goods{
				id = Id,
				player_id = PlayerId,
				goods_id = GoodsId,
				is_bind = ?BIND,
				num = 1,
				location = ?EQUIPS_LOCATION_TYPE,
				grid = SubType,
				extra = [],
				update_time = util_date:unixtime(),
				server_id = 0
			},
			%% 存库
			goods_cache:insert(GoodsInfo),

			%% 道具导入进程字典
			goods_dict:update_goods_num_to_dict(GoodsId, Id, ?BIND, 1),

			%% 更新列表
			goods_dict:update_player_equips_list_by_info(GoodsInfo),

			%% 广播
			State1 = broacast_goods_info_change(State, GoodsInfo),%%
			%% 更新跨服数据信息
			scene_cross:ref_cross_goods(State1),
			%% 刷新属性
			PS1 = goods_lib:update_guise_state(State1),
			Result = player_lib:update_refresh_player(State, PS1),
			case Result of
				{ok, StateNew} ->
					log_lib:log_fight_goods_change(StateNew, State, GoodsInfo, true, ?LOG_TYPE_EQUIPS_ON);
				_ -> skip
			end,
			Result;
		GoodsInfo ->
			%% 机器人特殊处理
			case State#player_state.is_robot == 1 of
				true ->
					NewGoodsInfo = GoodsInfo#db_goods{goods_id = GoodsId},
					goods_dict:delete_goods_num_to_dict(GoodsInfo#db_goods.goods_id, GoodsInfo#db_goods.id, GoodsInfo#db_goods.is_bind),
					goods_lib:update_player_goods_info(State, NewGoodsInfo),
					player_lib:update_refresh_player(State, #player_state{});
				false ->
					{ok, State}
			end
	end.

%% 翅膀专用接口
add_wing_goods(State, GoodsId) ->
	case equips_lib:get_equips_info_from_grid(?SUBTYPE_WING) of
		[] ->
			PlayerId = State#player_state.player_id,
			Id = uid_lib:get_uid(?UID_TYPE_PLAYER_GOODS),

			%% 限时时间计算
			GoodsConf = get_goods_conf_by_id(GoodsId),
			ExpireTime =
				case GoodsConf#goods_conf.is_timeliness of
					0 -> 0;
					Time -> util_date:unixtime() + Time
				end,

			GoodsInfo = #db_goods{
				id = Id,
				player_id = PlayerId,
				goods_id = GoodsId,
				is_bind = ?BIND,
				num = 1,
				location = ?EQUIPS_LOCATION_TYPE,
				grid = ?SUBTYPE_WING,
				extra = [],
				expire_time = ExpireTime,
				update_time = util_date:unixtime(),
				server_id = 0
			},
			%% 存库
			goods_cache:insert(GoodsInfo),

			%% 道具导入进程字典
			goods_dict:update_goods_num_to_dict(GoodsId, Id, ?BIND, 1),

			%% 更新列表
			goods_dict:update_player_equips_list_by_info(GoodsInfo),


			%% 广播
			State1 = broacast_goods_info_change(State, GoodsInfo),%%

			%% 更新跨服数据信息
			scene_cross:ref_cross_goods(State1),
			%% 刷新属性
			PS1 = goods_lib:update_guise_state(State1),
			{ok, PS2} = player_lib:update_refresh_player(State, PS1),
			log_lib:log_fight_goods_change(PS2, State, GoodsInfo, true, ?LOG_TYPE_EQUIPS_ON),

			%% 时效列表更新
			NewExpireList =
				case ExpireTime > 0 of
					true ->
						[{Id, ExpireTime}] ++ State1#player_state.expire_goods_list;
					false ->
						State1#player_state.expire_goods_list
				end,

			{ok, PS2#player_state{expire_goods_list = NewExpireList}};
		GoodsInfo ->
			%% 机器人特殊处理
			case State#player_state.is_robot == 1 of
				true ->
					NewGoodsInfo = GoodsInfo#db_goods{goods_id = GoodsId},
					goods_dict:delete_goods_num_to_dict(GoodsInfo#db_goods.goods_id, GoodsInfo#db_goods.id, GoodsInfo#db_goods.is_bind),
					goods_lib:update_player_goods_info(State, NewGoodsInfo),
					player_lib:update_refresh_player(State, #player_state{});
				false ->
					%% 如果当前翅膀为时效翅膀 专为激活 非时效翅膀不处理(玩家处理)
					OldGoodsId = GoodsInfo#db_goods.goods_id,
					OldGoodsConf = goods_lib:get_goods_conf_by_id(OldGoodsId),
					case OldGoodsConf#goods_conf.is_timeliness > 0 of
						true ->
							%% 更新穿戴在身上的装备 并更新属性
							case wing_mapping_config:get(OldGoodsId) of
								#wing_mapping_conf{} = WingConf ->
									EquipsInfo = GoodsInfo#db_goods{
										goods_id = WingConf#wing_mapping_conf.wing_id,
										expire_time = 0,
										update_time = util_date:unixtime()
									},
									{ok, PS} = goods_lib:update_player_goods_info(State, EquipsInfo),

									%% 外观变更检测
									UpdateState = equips_lib:check_guise_state(State, EquipsInfo),
									UpdateState1 = UpdateState#player_state{pass_trigger_skill_list = State#player_state.pass_trigger_skill_list},
									UpdateState2 = equips_lib:update_equips_skill(UpdateState1, GoodsInfo, EquipsInfo),
									%% 更新玩家属性
									{ok, PS1} = player_lib:update_refresh_player(PS, UpdateState2),
									NewExpireList = lists:keydelete(GoodsInfo#db_goods.id, 1, PS#player_state.expire_goods_list),
									%% 红点通知
									button_tips_lib:send_button_tips(PS1, ?BTN_LIMIT_WING, 0),
									{ok, PS1#player_state{expire_goods_list = NewExpireList}};
								_ ->
									{ok, State}
							end;
						false ->
							{ok, State}
					end
			end
	end.

%% 坐骑专用接口
add_mounts_goods(State, GoodsId) ->
	case equips_lib:get_equips_info_from_grid(?SUBTYPE_MOUNTS) of
		[] ->
			PlayerId = State#player_state.player_id,
			Id = uid_lib:get_uid(?UID_TYPE_PLAYER_GOODS),
			GoodsInfo = #db_goods{
				id = Id,
				player_id = PlayerId,
				goods_id = GoodsId,
				is_bind = ?BIND,
				num = 1,
				location = ?EQUIPS_LOCATION_TYPE,
				grid = ?SUBTYPE_MOUNTS,
				extra = [],
				update_time = util_date:unixtime(),
				server_id = 0
			},
			%% 存库
			goods_cache:insert(GoodsInfo),

			%% 道具导入进程字典
			goods_dict:update_goods_num_to_dict(GoodsId, Id, ?BIND, 1),

			%% 更新列表
			goods_dict:update_player_equips_list_by_info(GoodsInfo),

			%% 广播
			State1 = broacast_goods_info_change(State, GoodsInfo),%%
			%% 更新跨服数据信息
			scene_cross:ref_cross_goods(State1),
			%% 刷新属性
			PS1 = goods_lib:update_guise_state(State1),
			Result = player_lib:update_refresh_player(State, PS1),
			case Result of
				{ok, StateNew} ->
					log_lib:log_fight_goods_change(StateNew, State, GoodsInfo, true, ?LOG_TYPE_EQUIPS_ON);
				_ -> skip
			end,
			Result;
		_GoodsInfo ->
			{ok, State}
	end.

%% 限时道具检测
check_expire_goods(PlayerState) ->
	ExpireGoodsList = PlayerState#player_state.expire_goods_list,
	NowTime = util_date:unixtime(),
	Fun = fun({Id, ExpireTime}, {PS, RefBool}) ->
		case NowTime >= ExpireTime of
			true ->
				%% 删除过期道具 如果是穿戴的装备更新外观和属性
				case get_player_goods_info(Id, false) of %%
					{fail, _Err} ->
						NewExpireList = lists:keydelete(Id, 1, PS#player_state.expire_goods_list),
						{PS#player_state{expire_goods_list = NewExpireList}, RefBool};
					GoodsInfo ->
						NewPS =
							case GoodsInfo#db_goods.location == ?EQUIPS_LOCATION_TYPE of
								true ->
									%% 外观变更检测
									UpdateState = equips_lib:restore_guise_state(PS, GoodsInfo),
									UpdateState1 = UpdateState#player_state{pass_trigger_skill_list = PS#player_state.pass_trigger_skill_list},
									UpdateState2 = equips_lib:update_equips_skill(UpdateState1, GoodsInfo, []),
									%% 更新外观
									{ok, PS1} = player_lib:update_player_state(PS, UpdateState2),
									PS1;
								false ->
									PS
							end,

						%% 删除道具
						Id = GoodsInfo#db_goods.id,
						GoodsId = GoodsInfo#db_goods.goods_id,
						GoodsConf = goods_lib:get_goods_conf_by_id(GoodsId),
						case GoodsConf#goods_conf.is_timeliness_delete of
							0 -> %% 删除
								case goods_lib:delete_goods_by_id(NewPS, Id, GoodsId) of
									{ok, NewPS1} ->
										NewExpireList = lists:keydelete(Id, 1, PS#player_state.expire_goods_list),
										{NewPS1#player_state{expire_goods_list = NewExpireList}, true};
									_ ->
										{NewPS, RefBool}
								end;
							1 -> %% 不删除
								case GoodsConf#goods_conf.type == ?EQUIPS_TYPE andalso
									GoodsConf#goods_conf.sub_type == ?SUBTYPE_WING of
									true ->
										Socket = PlayerState#player_state.socket,
										%% 红点通知
										button_tips_lib:send_button_tips(PlayerState, ?BTN_LIMIT_WING, 1),
										net_send:send_to_client(Socket, 14052, #rep_goods_expire{result = 0});
									false ->
										skip
								end,
								NewExpireList = lists:keydelete(Id, 1, PS#player_state.expire_goods_list),
								{NewPS#player_state{expire_goods_list = NewExpireList}, true}
						end
				end;
			false ->
				{PS, RefBool}
		end
	end,
	lists:foldl(Fun, {PlayerState, false}, ExpireGoodsList).

%% 使用藏宝图
use_goods_map(PlayerState, Id) ->
	case goods_lib:get_player_goods_info(Id, false) of %%
		{fail, Err} ->
			{fail, Err};
		GoodsInfo ->
			use_goods_map_1(PlayerState, GoodsInfo)
	end.

use_goods_map_1(PlayerState, GoodsInfo) ->
	case get_map_value_from_extra(GoodsInfo#db_goods.extra) of
		{0, 0, 0} ->
			ok;
		{MapId, EX, EY} ->
			%% 挖宝允许4格误差
			DPB = PlayerState#player_state.db_player_base,
			X = DPB#db_player_base.x,
			Y = DPB#db_player_base.y,
			SceneId = PlayerState#player_state.scene_id,
			D = util_math:get_distance({X, Y}, {EX, EY}),
			case D =< 4 andalso SceneId == MapId of
				true ->
					use_goods_map_2(PlayerState, GoodsInfo);
				false ->
					{fail, ?ERR_DIGING_3}
			end
	end.

use_goods_map_2(PlayerState, GoodsInfo) ->
	DPB = PlayerState#player_state.db_player_base,
	Lv = DPB#db_player_base.lv,
	GoodsMapConf = goods_map_config:get(Lv),
	F = util_rand:weight_rand_ex(GoodsMapConf#goods_map_conf.type_list),
	log_lib:log_goods_change(PlayerState, GoodsInfo#db_goods.goods_id, -1, ?LOG_TYPE_GOOD_EFFECT),
	case F of
		1 ->
			delete_goods_by_id(PlayerState, GoodsInfo#db_goods.id, GoodsInfo#db_goods.goods_id),
			use_goods_map_3(PlayerState, GoodsInfo, GoodsMapConf);
		2 ->
			use_goods_map_4(PlayerState, GoodsInfo, GoodsMapConf);
		3 ->
			delete_goods_by_id(PlayerState, GoodsInfo#db_goods.id, GoodsInfo#db_goods.goods_id),
			use_goods_map_5(PlayerState, GoodsInfo, GoodsMapConf);
		4 ->
			delete_goods_by_id(PlayerState, GoodsInfo#db_goods.id, GoodsInfo#db_goods.goods_id),
			{fail, ?ERR_DIGING_4}
	end.

%% 扣血
use_goods_map_3(PlayerState, _GoodsInfo, _GoodsMapConf) ->
	DbAttr = PlayerState#player_state.db_player_attr,
	CurHp = DbAttr#db_player_attr.cur_hp,
	case CurHp =< 0 of
		false ->
			NewDbAttr = #db_player_attr{cur_hp = 1},
			{ok, PlayerState1} = player_lib:update_player_state(PlayerState, #player_state{db_player_attr = NewDbAttr}),
			{ok, PlayerState1, ?ERR_DIGING_1};
		true ->
			{fail, ?ERR_DIGING_4}
	end.
%% 道具
use_goods_map_4(PlayerState, GoodsInfo, GoodsMapConf) ->
	{GoodsId, IsBind, Num} = util_rand:weight_rand_ex(GoodsMapConf#goods_map_conf.goods_list),
	case goods_lib_log:add_goods(PlayerState, GoodsId, IsBind, Num, ?LOG_TYPE_GOOD_EFFECT) of
		{ok, PlayerState1} ->
			%% 检查是否公告
			delete_goods_by_id(PlayerState, GoodsInfo#db_goods.id, GoodsInfo#db_goods.goods_id),
			GoodsConf = goods_lib:get_goods_conf_by_id(GoodsId),
			case GoodsConf#goods_conf.is_notice of
				1 ->
					{MapId, _EX, _EY} = get_map_value_from_extra(GoodsInfo#db_goods.extra),
					SceneConf = scene_config:get(MapId),
					DPB = PlayerState#player_state.db_player_base,
					PlayerName = DPB#db_player_base.name,
					SceneName = SceneConf#scene_conf.name,
					GoodsName = GoodsConf#goods_conf.name,
					notice_lib:send_notice(0, ?NOTICE_XUNBAO, [PlayerName, SceneName, GoodsName]);
				_ ->
					skip
			end,
			{ok, PlayerState2} = player_lib:update_player_state(PlayerState, PlayerState1),
			{ok, PlayerState2, ?ERR_COMMON_SUCCESS};
		{fail, Reply} ->
			{fail, Reply}
	end.
%% 刷怪
use_goods_map_5(PlayerState, GoodsInfo, GoodsMapConf) ->
	{_MapId, EX, EY} = get_map_value_from_extra(GoodsInfo#db_goods.extra),
	MonsterId = util_rand:weight_rand_ex(GoodsMapConf#goods_map_conf.monster_list),
	RefAtom = {monster_type, MonsterId, 1, -1, ?TIME_CLEAR_MAP_MONSTER, {point_list, [{EX, EY}]}},
	scene_obj_lib:create_area_monster_from_scene(PlayerState#player_state.scene_pid, RefAtom),
	{ok, PlayerState, ?ERR_DIGING_2}.

%% ====================================================================
%% Internal functions
%% ====================================================================

%% 检测该道具是否是装备
check_is_equips_by_id(GoodsId) ->
	GoodsId >= 200000.

%% 检测该道具是否在背包
check_goods_is_in_bag(GoodsInfo) ->
	GoodsInfo#db_goods.location =:= 1.

%% 获取道具配置
get_goods_conf_by_id(GoodsId) ->
	goods_config:get(GoodsId).

%% 检车道具是否是货币类型
is_money_type_by_goods(GoodsId) ->
	GoodsConf = get_goods_conf_by_id(GoodsId),
	GoodsConf#goods_conf.type =:= ?GOODS_TYPE_VALUE.


%% 获取道具列表
get_goods_list(BagType, BindType) ->
	case BagType of
		?NORMAL_LOCATION_TYPE ->
			GoodsList = goods_dict:get_player_goods_list(),
			EquipsList = goods_dict:get_player_equips_list(),
			List1 = [X || X <- GoodsList, X#db_goods.is_bind =:= BindType andalso X#db_goods.location =:= BagType],
			List2 = [X || X <- EquipsList, X#db_goods.is_bind =:= BindType andalso X#db_goods.location =:= BagType],
			List1 ++ List2;
		?EQUIPS_LOCATION_TYPE ->
			EquipsList = goods_dict:get_player_equips_list(),
			[X || X <- EquipsList, X#db_goods.is_bind =:= BindType andalso X#db_goods.location =:= BagType]
	end.


%% 获取指定道具记录
get_player_goods_info(Id, GoodsId, IsServer) ->
	case check_is_equips_by_id(GoodsId) of
		true ->
			case lists:keyfind(Id, #db_goods.id, goods_dict:get_player_equips_list()) of
				false ->
					{fail, ?ERR_GOODS_NOT_EXIST};
				Info ->
					case goods_lib:get_server_use(Info#db_goods.server_id) of
						1 ->
							Info;
						_ ->
							case IsServer of
								true ->
									{fail, ?ERR_SERVER_NO_USE};
								_ ->
									Info
							end
					end
			end;
		false ->
			case lists:keyfind(Id, #db_goods.id, goods_dict:get_player_goods_list()) of
				false ->
					{fail, ?ERR_GOODS_NOT_EXIST};
				Info ->
					case goods_lib:get_server_use(Info#db_goods.server_id) of
						1 ->
							Info;
						_ ->
							case IsServer of
								true ->
									{fail, ?ERR_SERVER_NO_USE};
								_ ->
									Info
							end
					end
			end
	end.

%% IsServer 是否判断获取原点
get_player_goods_info(Id, IsServer) ->
	GoodsList = goods_dict:get_player_goods_list(),
	EquipsList = goods_dict:get_player_equips_list(),
	AllGoodsList = lists:append(GoodsList, EquipsList),
	case lists:keyfind(Id, #db_goods.id, AllGoodsList) of
		false ->
			{fail, ?ERR_GOODS_NOT_EXIST};
		Info ->
			case goods_lib:get_server_use(Info#db_goods.server_id) of
				1 ->
					Info;
				_ ->
					case IsServer of
						true ->
							{fail, ?ERR_SERVER_NO_USE};
						_ ->
							Info
					end
			end
	end.

%% 根据唯一id获取玩家装备信息
get_player_equips_info_by_id(Id) ->
	case lists:keyfind(Id, #db_goods.id, goods_dict:get_player_equips_list()) of
		false ->
			[];
		Info ->
			Info
	end.

%% 获取道具总数量(该接口包括穿在身上的装备数量)
get_goods_num(GoodsId) ->
	GoodsList = goods_dict:get_value_from_dict_by_id(GoodsId, ?NOT_BIND),
	GoodsBindList = goods_dict:get_value_from_dict_by_id(GoodsId, ?BIND),
	Fun = fun({_Id, Num}, Acc) ->
		Num + Acc
	end,
	lists:foldl(Fun, 0, GoodsList ++ GoodsBindList).

%% 获取仓库道具总数量
get_store_goods_num(GoodsId) ->
	GoodsList = goods_dict:get_value_from_store_dict_by_id(GoodsId, ?NOT_BIND),
	GoodsBindList = goods_dict:get_value_from_store_dict_by_id(GoodsId, ?BIND),
	Fun = fun({_Id, Num}, Acc) ->
		Num + Acc
	end,
	lists:foldl(Fun, 0, GoodsList ++ GoodsBindList).

%% 添加道具条件检测
check_goods_cond(State, GoodsId, IsBind, Num) ->
	case util:loop_functions(
		none,
		[fun(_)
			-> GoodsConfig = get_goods_conf_by_id(GoodsId),
			case GoodsConfig =/= [] of
				true ->
					{continue, GoodsConfig};
				false ->
					{break, ?ERR_GOODS_NOT_EXIST}                 %% 非道具
			end
		end,
			fun(GoodsConfig) ->
				case GoodsConfig#goods_conf.limit_num > 0 of
					true ->
						{continue, GoodsConfig};
					false ->
						{break, ?ERR_GOODS_NOT_EXIST}                 %% 配置错误
				end
			end,
			fun(GoodsConfig) ->
				PlayerBase = State#player_state.db_player_base,
				AllCell = PlayerBase#db_player_base.bag,
				UseCell = goods_dict:get_bag_cell(),
				NeedCell = get_need_cell_num(GoodsId, IsBind, Num),
				case NeedCell + UseCell > AllCell of
					true ->
						{break, ?ERR_PLAYER_BAG_NOT_ENOUGH};
					false ->
						{continue, GoodsConfig}
				end
			end
		]) of
		{break, Reply} -> {fail, Reply};
		{ok, Value} ->
			{ok, Value}
	end.

%% 使用道具检测
check_use_goods(State, GoodsId, Num) ->
	case util:loop_functions(
		none,
		[fun(_)
			-> GoodsConfig = get_goods_conf_by_id(GoodsId),
			case GoodsConfig =/= [] of
				true ->
					{continue, GoodsConfig};
				false ->
					{break, ?ERR_GOODS_NOT_EXIST}                 %% 非道具
			end
		end,
			fun(GoodsConfig) ->
				case GoodsConfig#goods_conf.is_use =:= 1 of
					true ->
						{continue, GoodsConfig};
					false ->
						{break, ?ERR_GOODS_CANNOT_USE}
				end
			end,
			fun(GoodsConfig) ->    %% cd检测
				Type = GoodsConfig#goods_conf.type,
				SubType = GoodsConfig#goods_conf.sub_type,
				CdList = goods_dict:get_goods_cd_list(),
				case lists:keyfind({Type, SubType}, 1, CdList) of
					{_, Time} ->
						case util_date:unixtime() >= Time of
							true ->
								{continue, GoodsConfig};
							false ->
								{break, ?ERR_GOODS_CD}
						end;
					false ->
						{continue, GoodsConfig}
				end
			end,
			fun(GoodsConfig) ->    %% 道具使用是否需要其他消耗
				case GoodsConfig#goods_conf.cost of
					[] ->
						{continue, GoodsConfig};
					_ ->
						?INFO("~p", [GoodsConfig#goods_conf.cost]),
						case goods_util:check_special_list_jade(State, GoodsConfig#goods_conf.cost) of
							true ->
								{continue, GoodsConfig};
							{fail, _Err} ->
								{break, ?ERR_NO_YAOSHI}
						end
				end
			end,
			fun(GoodsConfig) ->
				case GoodsConfig#goods_conf.type =/= 2 of
					true ->
						{continue, GoodsConfig#goods_conf.extra};
					false ->
						{break, ?ERR_GOODS_CANNOT_USE}
				end
			end,
			fun(Extra) ->
				GoodsNum = get_goods_num(GoodsId),
				case GoodsNum >= Num of
					true ->
						{continue, Extra};
					false ->
						{break, ?ERR_GOODS_NOT_ENOUGH}
				end
			end,
			fun(Extra) -> %% 竞技场不能使用道具
				case State#player_state.scene_id =/= ?ARENA_INSTANCE_ID of
					true ->
						{continue, Extra};
					false ->
						{break, ?ERR_COMMON_FAIL}
				end
			end
		]) of
		{break, Reply} -> {fail, Reply};
		{ok, Value} ->
			{ok, Value}
	end.


%% 检测道具是否足够
is_goods_enough(GoodsId, Num) ->
	get_goods_num(GoodsId) >= Num.

%% 检测道具是否足够(列表)
is_goods_list_enough([]) ->
	true;
is_goods_list_enough([{GoodsId, Num} | T]) ->
	case get_goods_num(GoodsId) >= Num of
		true ->
			is_goods_list_enough(T);
		false ->
			false
	end.

%% 获取背包可用空格数量
get_free_bag_num(State) ->
	PlayerBase = State#player_state.db_player_base,
	AllCell = PlayerBase#db_player_base.bag,
	UseCell = goods_dict:get_bag_cell(),
	AllCell - UseCell.

%% 获取新的道具唯一ID
get_new_goods_key() ->
	uid_lib:get_uid(?UID_TYPE_PLAYER_GOODS).

%% 获取限制数量
get_limit_num(GoodsId) ->
	GoodsConfig = get_goods_conf_by_id(GoodsId),
	GoodsConfig#goods_conf.limit_num.

%% 获取玩家添加道具所需要用到的格子数
get_need_cell_num(GoodsId, IsBind, Num) when Num > 0 andalso (IsBind =:= ?NOT_BIND orelse IsBind == ?BIND) ->
	LimitNum = get_limit_num(GoodsId),
	List = goods_dict:get_value_from_dict_by_id(GoodsId, IsBind),
	List1 = [{Id, N} || {Id, N} <- List, N =/= LimitNum],
	get_need_cell_num(0, Num, LimitNum, List1).
get_need_cell_num(_Cell, _Num, LimitNum, _List) when LimitNum =< 0 ->
	0;
get_need_cell_num(Cell, 0, _LimitNum, []) ->
	Cell;
get_need_cell_num(Cell, Num, LimitNum, []) ->
	case Num - LimitNum > 0 of
		true ->
			get_need_cell_num(Cell + 1, Num - LimitNum, LimitNum, []);
		false ->
			Cell + 1
	end;
get_need_cell_num(Cell, Num, LimitNum, [H | T]) ->
	{_K, N} = H,
	case N + Num > LimitNum of
		true ->
			get_need_cell_num(Cell + 1, N + Num - LimitNum, LimitNum, T);
		false ->
			Cell
	end.

get_goods_list_need_cell(GoodsList) ->
	Fun = fun({GoodsId, IsBind, Num}, Acc) ->
		Acc + get_need_cell_num(GoodsId, IsBind, Num)
	end,
	lists:foldl(Fun, 0, GoodsList).
get_goods_info_list_need_cell(GoodsInfoList) ->
	Fun = fun(DbGoods, Acc) ->
		GoodsId = DbGoods#db_goods.goods_id,
		IsBind = DbGoods#db_goods.is_bind,
		Num = DbGoods#db_goods.num,
		Acc + get_need_cell_num(GoodsId, IsBind, Num)
	end,
	lists:foldl(Fun, 0, GoodsInfoList).

%% 获取玩家道具信息列表
get_goods_info_list() ->
	List = goods_dict:get_player_goods_list(),
	Fun = fun(DbGoods) ->
		{MapId, EX, EY} = get_map_value_from_extra(DbGoods#db_goods.extra),
		GoodsProto =
			#proto_goods_info{
				id = DbGoods#db_goods.id,
				goods_id = DbGoods#db_goods.goods_id,
				is_bind = DbGoods#db_goods.is_bind,
				num = DbGoods#db_goods.num,
				stren_lv = DbGoods#db_goods.stren_lv,
				location = DbGoods#db_goods.location,
				grid = DbGoods#db_goods.grid,
				expire_time = DbGoods#db_goods.expire_time,
				map_scene = MapId,  %%  宝图场景id
				map_x = EX,  %%  宝图x坐标
				map_y = EY  %%  宝图y坐标
			},
		#goods_conf{sort = SortNum} = get_goods_conf_by_id(DbGoods#db_goods.goods_id),
		{GoodsProto, SortNum}
	end,
	NotSortGoodsPosList = [Fun(X) || X <- List],
	SortGoodsPosList = lists:keysort(2, NotSortGoodsPosList),
	GoodsList = [Goods || {Goods, _} <- SortGoodsPosList],
	GoodsList.

%% 获取玩家装备信息列表
get_equips_info_list() ->
	List = goods_dict:get_player_equips_list(),
	Fun = fun(DbGoods) ->
		Extra = DbGoods#db_goods.extra,
		BaptizeAttrList = equips_baptize:get_equips_baptize_attr(Extra),

		#proto_equips_info{ %%
			id = DbGoods#db_goods.id,
			goods_id = DbGoods#db_goods.goods_id,
			is_bind = DbGoods#db_goods.is_bind,
			num = DbGoods#db_goods.num,
			stren_lv = DbGoods#db_goods.stren_lv,
			location = DbGoods#db_goods.location,
			grid = DbGoods#db_goods.grid,
			baptize_attr_list = goods_util:attr_type_list_changed_proto_list(BaptizeAttrList),
			soul = DbGoods#db_goods.soul,
			luck = goods_util:get_equips_luck(DbGoods),
			expire_time = DbGoods#db_goods.expire_time,
			secure = DbGoods#db_goods.secure,
			bless = DbGoods#db_goods.bless,
			server_id = DbGoods#db_goods.server_id,
			is_use = goods_lib:get_server_use(DbGoods#db_goods.server_id)
		}
	end,
	EquipsList = [Fun(X) || X <- List],
	EquipsList.

%% 获取玩家穿戴的装备列表
get_wear_equips_info_list() ->
	List = goods_dict:get_player_equips_list(),
	Fun = fun(DbGoods) ->
		Extra = DbGoods#db_goods.extra,
		BaptizeAttrList = equips_baptize:get_equips_baptize_attr(Extra),

		#proto_equips_info{ %%
			id = DbGoods#db_goods.id,
			goods_id = DbGoods#db_goods.goods_id,
			is_bind = DbGoods#db_goods.is_bind,
			num = DbGoods#db_goods.num,
			stren_lv = DbGoods#db_goods.stren_lv,
			location = DbGoods#db_goods.location,
			grid = DbGoods#db_goods.grid,
			baptize_attr_list = goods_util:attr_type_list_changed_proto_list(BaptizeAttrList),
			soul = DbGoods#db_goods.soul,
			luck = goods_util:get_equips_luck(DbGoods),
			expire_time = DbGoods#db_goods.expire_time,
			secure = DbGoods#db_goods.secure,
			bless = DbGoods#db_goods.bless,
			server_id = DbGoods#db_goods.server_id,
			is_use = goods_lib:get_server_use(DbGoods#db_goods.server_id)
		}
	end,
	EquipsList = [Fun(X) || X <- List, X#db_goods.location =/= 0],
	EquipsList.

%% 广播玩家道具信息变更
broacast_goods_info_change(PlayerState, GoodsInfo) ->
	GoodsId = GoodsInfo#db_goods.goods_id,
	case check_is_equips_by_id(GoodsId) of
		true ->
			goods_lib:handle(14021, PlayerState, GoodsInfo);
		false ->
			goods_lib:handle(14002, PlayerState, GoodsInfo)
	end.

%% 广播玩家道具信息
handle(14002, PlayerState, GoodsInfo) ->
	{MapId, EX, EY} = goods_lib:get_map_value_from_extra(GoodsInfo#db_goods.extra),
	ProtoInfo = [#proto_goods_info{
		id = GoodsInfo#db_goods.id,
		goods_id = GoodsInfo#db_goods.goods_id,
		is_bind = GoodsInfo#db_goods.is_bind,
		num = GoodsInfo#db_goods.num,
		stren_lv = GoodsInfo#db_goods.stren_lv,
		location = GoodsInfo#db_goods.location,
		grid = GoodsInfo#db_goods.grid,
		expire_time = GoodsInfo#db_goods.expire_time,
		map_scene = MapId,  %%  宝图场景id
		map_x = EX,  %%  宝图x坐标
		map_y = EY  %%  宝图y坐标
	}],
	case PlayerState#player_state.is_lottery_begin of
		true ->
			PlayerState#player_state{
				goods_list = PlayerState#player_state.goods_list ++ ProtoInfo
			};
		_ ->
			net_send:send_to_client(PlayerState#player_state.socket, 14002, #rep_broadcast_goods_info{goods_list = ProtoInfo}),
			PlayerState
	end;

%% 广播玩家装备信息
handle(14021, PlayerState, GoodsInfo) ->
	%% ?INFO("14021 :~p",[GoodsInfo]),
	Extra = GoodsInfo#db_goods.extra,
	BaptizeAttrList = equips_baptize:get_equips_baptize_attr(Extra),

	ProtoInfo = [#proto_equips_info{ %%
		id = GoodsInfo#db_goods.id,
		goods_id = GoodsInfo#db_goods.goods_id,
		is_bind = GoodsInfo#db_goods.is_bind,
		num = GoodsInfo#db_goods.num,
		stren_lv = GoodsInfo#db_goods.stren_lv,
		location = GoodsInfo#db_goods.location,
		grid = GoodsInfo#db_goods.grid,
		baptize_attr_list = goods_util:attr_type_list_changed_proto_list(BaptizeAttrList),
		soul = GoodsInfo#db_goods.soul,
		luck = goods_util:get_equips_luck(GoodsInfo),
		expire_time = GoodsInfo#db_goods.expire_time,
		secure = GoodsInfo#db_goods.secure,
		bless = GoodsInfo#db_goods.bless,
		server_id = GoodsInfo#db_goods.server_id,
		is_use = goods_lib:get_server_use(GoodsInfo#db_goods.server_id)
	}],

	case PlayerState#player_state.is_lottery_begin of
		true ->
			PlayerState#player_state{
				equip_list = PlayerState#player_state.equip_list ++ ProtoInfo
			};
		_ ->
			net_send:send_to_client(PlayerState#player_state.socket, 14021, #rep_broadcast_equips_info{equips_list = ProtoInfo}),
			PlayerState
	end.

broadcast_goods_change_info(PlayerState) ->
	ProtoGoodsList = PlayerState#player_state.goods_list,
	ProtoEquipsList = PlayerState#player_state.equip_list,
	case ProtoGoodsList of
		[] -> skip;
		_ ->
			net_send:send_to_client(PlayerState#player_state.socket, 14002, #rep_broadcast_goods_info{goods_list = ProtoGoodsList})
	end,
	case ProtoEquipsList of
		[] -> skip;
		_ ->
			net_send:send_to_client(PlayerState#player_state.socket, 14021, #rep_broadcast_equips_info{equips_list = ProtoEquipsList})
	end,
	%% ?ERR("broadcast_goods_change_info :~p,~p~n",[ProtoGoodsList, ProtoEquipsList]),
	PlayerState#player_state{is_lottery_begin = false, goods_list = [], equip_list = []}.

%% 广播礼包奖励
broadcast_goods_reward(State, GoodsList) ->
	ProtoList = get_proto_goods_list(GoodsList),
	net_send:send_to_client(State#player_state.socket, 14009, #rep_bag_reward{goods_list = ProtoList}).

get_proto_goods_list(GoodsList) ->
	Fun = fun(GoodsId, IsBind, Num) ->
		#proto_goods_list{
			goods_id = GoodsId,
			is_bind = IsBind,
			num = Num
		}
	end,
	[Fun(X, Y, Z) || {X, Y, Z} <- GoodsList].

%% 推送道具变更信息
broadcast_goods_change(State, GoodsId, Num, GoodsList) ->
	Proto = get_proto_goods_list(GoodsList),
	net_send:send_to_client(State#player_state.socket, 14011, #rep_goods_change{
		goods_id = GoodsId,
		num = Num,
		goods_list = Proto
	}).

broadcast_goods_change(State, GoodsId, Num, GoodsList, Type) ->
	Proto = get_proto_goods_list(GoodsList),
	net_send:send_to_client(State#player_state.socket, 14011, #rep_goods_change{
		goods_id = GoodsId,
		num = Num,
		type = Type,
		goods_list = Proto
	}).

%% 获取藏宝图额外信息
get_map_extra(State) ->
	DPB = State#player_state.db_player_base,
	Lv = DPB#db_player_base.lv,
	GoodsMapConf = goods_map_config:get(Lv),
	{MapId, X1, Y1, X2, Y2} = util_rand:list_rand(GoodsMapConf#goods_map_conf.scene_list),
	X = util_rand:rand(X1, X2),
	Y = util_rand:rand(Y1, Y2),
	[{?GOODS_MAP_KEY, MapId, X, Y}].

get_map_value_from_extra(Extra) ->
	case Extra of
		[{?GOODS_MAP_KEY, MapId, EX, EY}] ->
			{MapId, EX, EY};
		_ ->
			{0, 0, 0}
	end.

%% 行会申请按钮红点提示
get_wing_button_tips(PlayerState) ->
	case equips_lib:get_equips_info_from_grid(?SUBTYPE_WING) of
		[] ->
			{PlayerState, 0};
		GoodsInfo ->
			ExpireTime = GoodsInfo#db_goods.expire_time,
			case ExpireTime =/= 0 andalso util_date:unixtime() >= ExpireTime of
				true ->
					{PlayerState, 1};
				false ->
					{PlayerState, 0}
			end
	end.

%% 当前服务器，是否可以使用
get_server_use(ServerId) ->
	case ServerId < 1 orelse ServerId =:= config:get_server_no() of
		true ->
			1;
		_ ->
			case lists:member(ServerId, config:get_merge_servers()) of
				true ->
					1;
				_ ->
					0
			end
	end.
	