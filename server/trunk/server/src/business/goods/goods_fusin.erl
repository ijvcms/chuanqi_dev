%%%-------------------------------------------------------------------
%%% @author tuhujia
%%% @copyright (C) 2015, <COMPANY>
%%% @doc 道具合成
%%%
%%% @end
%%% Created : 20. 八月 2015 10:12
%%%-------------------------------------------------------------------
-module(goods_fusin).

-include("common.hrl").
-include("record.hrl").
-include("proto.hrl").
-include("cache.hrl").
-include("db_record.hrl").
-include("config.hrl").
-include("language_config.hrl").
-include("log_type_config.hrl").

%% API
-export([
	fusion_goods/2,
	fusion_good_plus/3
]).

%% ====================================================================
%% API functions
%% ====================================================================

%% 道具合成
fusion_goods(State, Id) ->
	FusionConf = fusion_config:get(Id),
	Stuff = FusionConf#fusion_conf.stuff,
	case goods_util:check_cond_list(State, Stuff) of
		true ->
			fusion_goods_1(State, FusionConf);
		{fail, Reply} ->
			{fail, Reply}
	end.

%% 合成类型检测   神器特殊处理
fusion_goods_1(State, FusionConf) ->
	case FusionConf#fusion_conf.type of
		5 -> %% 神装打造
			fusion_artifact(State, FusionConf);
		6 -> %% 节日活动兑换
			fusion_holiday_active(State, FusionConf);
		_ ->
			fusion_goods_2(State, FusionConf)
	end.

%% 通常合成奖励
fusion_goods_2(State, FusionConf) ->
	Product = FusionConf#fusion_conf.product,
	case goods_util:add_reward_list(State, Product, ?LOG_TYPE_FUSION) of
		{ok, State1} ->
			Stuff = FusionConf#fusion_conf.stuff,
			{ok, State2} = goods_util:delete_cond_list(State1, Stuff, ?LOG_TYPE_FUSION),
			%% 推送更新后的属性
			player_lib:update_player_state(State, State2),

			%%log_add_reward_list(State1, Product),

			{ok, State2};
		{fail, Reply} ->
			{fail, Reply}
	end.

%% 节日活动兑换
fusion_holiday_active(State, FusionConf) ->
	case operate_active_lib:get_holiday_loot_active_id() of
		[ActiveId | _] ->
			FusionId = FusionConf#fusion_conf.key,
			Conf = holidays_active_config:get(?OPERATE_ACTIVE_TYPE_5),
			Product = FusionConf#fusion_conf.product,
			{_, LimitNum} = lists:keyfind(FusionId, 1, Conf#holidays_active_conf.reward),
			case LimitNum of
				0 -> %% 无限制兑换
					fusion_goods_2(State, FusionConf);
				_ ->
					PlayerId = State#player_state.player_id,
					ActiveConf = operate_active_lib:get_operate_active_conf(ActiveId),
					FinishType = ActiveConf#ets_operate_active_conf.finish_type,
					Info = player_operate_record_cache:get_info(PlayerId, ActiveId, FusionId, FinishType),
					case Info#db_player_operate_record.finish_limit_value >= LimitNum of
						false ->
							case goods_util:add_reward_list(State, Product, ?LOG_TYPE_HOLIDAY_CHANGE) of
								{ok, State1} ->
									Stuff = FusionConf#fusion_conf.stuff,
									{ok, State2} = goods_util:delete_cond_list(State1, Stuff, ?LOG_TYPE_HOLIDAY_CHANGE),
									%% 推送更新后的属性
									player_lib:update_player_state(State, State2),

									%% log_add_reward_list(State1, Product),

									OperateInfo = player_operate_record_cache:update_info(PlayerId, ActiveId, FusionId, FinishType),

									Proto =
										[
											#proto_operate_holiday_change_info{
												active_id = ActiveId,  %%  活动编号
												fusion_id = FusionId,  %%  兑换配方id
												count = OperateInfo#db_player_operate_record.finish_limit_value  %%  已兑换次数
											}],
									net_send:send_to_client(State2#player_state.socket, 32044, #rep_get_operate_holiday_change_info{list = Proto}),
									{ok, State2};
								{fail, Reply} ->
									{fail, Reply}
							end;
						true ->
							{fail, ?ERR_COMMON_FAIL}
					end
			end;
		_ ->
			{fail, ?ERR_COMMON_FAIL}
	end.

%% log_add_reward_list(State, RewardList) ->
%% 	[
%% 		case R of
%% 			{"goods", GoodsId, _IsBind, Num} ->
%% 				log_lib:log_goods_change(State, GoodsId, Num, ?LOG_TYPE_BUILD);
%% 			_ ->
%% 				skip
%% 		end
%% 		|| R <- RewardList
%% 	].

%% log_delete_cond_list(PS, Stuff) ->
%% 	[
%% 		case R of
%% 			{"goods", GoodsId, Num} ->
%% 				log_lib:log_goods_change(PS, GoodsId, -Num, ?LOG_TYPE_FUSION);
%% 			_ ->
%% 				skip
%% 		end
%% 		|| R <- Stuff
%% 	].

%% 神装打造
fusion_artifact(State, FusionConf) ->
	WGoodsId = FusionConf#fusion_conf.wear_equips,
	[{_, PGoodsId, _, _}] = FusionConf#fusion_conf.product_equips,
	WGConf = goods_lib:get_goods_conf_by_id(WGoodsId),
	PGConf = goods_lib:get_goods_conf_by_id(PGoodsId),
	case WGConf#goods_conf.type == ?EQUIPS_TYPE andalso
		PGConf#goods_conf.type == ?EQUIPS_TYPE andalso
		WGConf#goods_conf.sub_type == PGConf#goods_conf.sub_type of
		true ->
			fusion_artifact_1(State, FusionConf);
		false ->
			{fail, ?ERR_COMMON_FAIL}
	end.

fusion_artifact_1(State, FusionConf) ->
	%% 获取穿戴的装备列表
	WGoodsId = FusionConf#fusion_conf.wear_equips,
	EquipsList = [X || X <- goods_dict:get_player_equips_list(), X#db_goods.location =:= ?EQUIPS_LOCATION_TYPE],
	case lists:keyfind(WGoodsId, #db_goods.goods_id, EquipsList) of
		#db_goods{} = GoodsInfo ->
			[{_, PGoodsId, IsBind, _}] = FusionConf#fusion_conf.product_equips,
			PGoodsConf = goods_lib:get_goods_conf_by_id(PGoodsId),

			%% 铸魂精华返还
			Consume = equips_lib:get_change_consume(GoodsInfo, false),
			GoodsList = [{G, ?NOT_BIND, N} || {G, N} <- Consume],
			%% 获取铸魂精魂
			SoulNum =
				case lists:keyfind(?GOODS_ID_SOUL, 1, GoodsList) of
					false ->
						0;
					{_, _, _TempNum} ->
						_TempNum
				end,
			%% 获取铸魂精魂 剩余数据
			{SoulLv, SoulNum1} = get_soul_lv(PGoodsId, 0, SoulNum),
			GoodsList1 =
				case SoulNum1 > 0 of
					true ->
						lists:keyreplace(?GOODS_ID_SOUL, 1, GoodsList, {?GOODS_ID_SOUL, ?NOT_BIND, SoulNum1});
					_ ->
						lists:keydelete(?GOODS_ID_SOUL, 1, GoodsList)
				end,
			case goods_lib_log:add_goods_list(State, GoodsList1, ?LOG_TYPE_ARTIFACT) of
				{ok, PlayerState1} ->

					DPB = PlayerState1#player_state.db_player_base,
					Lv = DPB#db_player_base.lv,
					%% 检查合成的装备  如果大于玩家等级就直接放入背包
					%% 更新穿戴在身上的装备 并更新属性
					EquipsInfo = GoodsInfo#db_goods{
						goods_id = PGoodsId,
						is_bind = IsBind,
						stren_lv = GoodsInfo#db_goods.stren_lv,
						soul = SoulLv,
						extra = lists:keydelete(?EQUIPS_LUCK_KEY, 1, GoodsInfo#db_goods.extra),
						update_time = util_date:unixtime(),
						secure = 0
					},
					Result =
						case PGoodsConf#goods_conf.limit_lvl > Lv of
							true ->
								case goods_lib_log:add_goods_by_goods_info(PlayerState1, EquipsInfo, ?LOG_TYPE_FUSION) of
									{ok, _} ->
										%% 外观变更检测
										goods_lib_log:delete_equips_by_id(PlayerState1, GoodsInfo#db_goods.id, ?LOG_TYPE_FUSION),
										UpdateState = equips_lib:restore_guise_state(PlayerState1, EquipsInfo),
										UpdateState1 = UpdateState#player_state{pass_trigger_skill_list = PlayerState1#player_state.pass_trigger_skill_list},
										UpdateState2 = equips_lib:update_equips_skill(UpdateState1, GoodsInfo, []),
										%% 更新玩家属性
										player_lib:update_refresh_player(PlayerState1, UpdateState2);
									{fail, _R} ->
										{fail, _R}
								end;
							false ->
								goods_dict:delete_goods_num_to_dict(GoodsInfo#db_goods.goods_id, GoodsInfo#db_goods.id, GoodsInfo#db_goods.is_bind),
								goods_lib:update_player_goods_info(PlayerState1, EquipsInfo),
								%% 外观变更检测
								UpdateState = equips_lib:check_guise_state(PlayerState1, EquipsInfo),
								UpdateState1 = UpdateState#player_state{pass_trigger_skill_list = PlayerState1#player_state.pass_trigger_skill_list},
								UpdateState2 = equips_lib:update_equips_skill(UpdateState1, GoodsInfo, EquipsInfo),
								%% 更新玩家属性
								player_lib:update_refresh_player(PlayerState1, UpdateState2)
						end,

					case Result of
						{ok, PlayerState1_1} ->
							%% 扣除材料
							Stuff = FusionConf#fusion_conf.stuff,
							NewStuff = lists:keydelete(WGoodsId, 2, Stuff),
							{ok, PlayerState2} = goods_util:delete_cond_list(PlayerState1_1, NewStuff, ?LOG_TYPE_FUSION),
							{ok, PlayerState3} = player_lib:update_player_state(PlayerState1, PlayerState2),

							GConf = goods_config:get(GoodsInfo#db_goods.goods_id),
							Price = GConf#goods_conf.secure_price,
							Secure = GoodsInfo#db_goods.secure,
							player_lib:incval_on_player_money_log(PlayerState3, #db_player_money.jade, Secure * Price, true, ?LOG_TYPE_EQUIPS_SECURE);
						{fail, Reply} ->
							{fail, Reply}
					end;
				{fail, Reply} ->
					{fail, Reply}
			end;
		_ ->
			{fail, ?ERR_GOODS_NOT_ENOUGH}
	end.

%% 道具合成扩展
fusion_good_plus(State, Id, N) ->
	FusionConf = fusion_config:get(Id),
	Stuff = FusionConf#fusion_conf.stuff,
	Stuff1 = goods_util:stack_cond_and_award(Stuff, N),
	case goods_util:check_cond_list(State, Stuff1) of
		true ->
			fusion_good_plus_1(State, FusionConf, N);
		{fail, Reply} ->
			{fail, Reply}
	end.

fusion_good_plus_1(State, FusionConf, N) ->
	Product = FusionConf#fusion_conf.product,
	Product1 = goods_util:stack_cond_and_award(Product, N),
	case goods_util:add_reward_list(State, Product1, ?LOG_TYPE_FUSION) of
		{ok, State1} ->
			Stuff = FusionConf#fusion_conf.stuff,
			Stuff1 = goods_util:stack_cond_and_award(Stuff, N),
			{ok, State2} = goods_util:delete_cond_list(State1, Stuff1, ?LOG_TYPE_FUSION),
			%% 推送更新后的属性
			player_lib:update_player_state(State, State2),
			{ok, State2};
		{fail, Reply} ->
			{fail, Reply}
	end.

%% 获取铸魂的等级
get_soul_lv(GoodsId, SoulLv, SoulNum) ->
	case equips_soul_config:get({GoodsId, SoulLv + 1}) of
		#equips_soul_conf{} = SoulConf ->
			[{_, Num}] = SoulConf#equips_soul_conf.consume,
			case SoulNum > Num of
				true ->
					get_soul_lv(GoodsId, SoulLv + 1, SoulNum - Num);
				_ ->
					{SoulLv, SoulNum}
			end;
		_ ->
			{SoulLv, SoulNum}
	end.