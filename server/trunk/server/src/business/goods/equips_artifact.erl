%%%-------------------------------------------------------------------
%%% @author tuhujia
%%% @copyright (C) 2015, <COMPANY>
%%% @doc 神器系统
%%%
%%% @end
%%% Created : 20. 八月 2015 15:34
%%%-------------------------------------------------------------------
-module(equips_artifact).

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
	devour_artifact/3,
	inheritance_artifact/3,
	get_equips_artifact_info/1,
	get_arit_attr_record/2
]).

%% ====================================================================
%% API functions
%% ====================================================================

%% 神器吞噬
devour_artifact(State, Id1, IdList) ->
	case goods_lib:get_player_equips_info_by_id(Id1) of
		[] ->
			{fail, ?ERR_GOODS_NOT_EXIST};
		GoodsInfo ->
			Extra = GoodsInfo#db_goods.extra,
			case get_equips_artifact_info(Extra) of
				{0, 0, 0} ->
					{fail, ?ERR_GOODS_NOT_ART};
				_ ->
					devour_artifact_1(State, GoodsInfo, IdList)
			end
	end.

devour_artifact_1(State, GoodsInfo, IdList) ->
	Result = get_total_exp(IdList),
	case Result of
		{ok, TotalExp} ->
			devour_artifact_2(State, GoodsInfo, IdList, TotalExp);
		{fail, Reply} ->
			{fail, Reply}
	end.

devour_artifact_2(State, GoodsInfo, IdList, TotalExp) ->
	BaseMoney = State#player_state.db_player_money,
	Extra = GoodsInfo#db_goods.extra,
	{StarLv, Lv, ArtExp} = get_equips_artifact_info(Extra),
	{NLv, NArtExp, NeedCoin} = get_new_lv_and_exp(StarLv, Lv, ArtExp, TotalExp, 0),
	case BaseMoney#db_player_money.coin >= NeedCoin of
		true ->
			NewArtAttr = {?EQUIPS_AIRFACT_KEY, StarLv, NLv, NArtExp},

			NewExtra = lists:keystore(?EQUIPS_AIRFACT_KEY, 1, Extra, NewArtAttr),

			%% 更新神器属性
			goods_lib:update_player_goods_info(State, GoodsInfo#db_goods{extra = NewExtra}),
			%% 删除材料
			[goods_lib_log:delete_equips_by_id(State, Id,?LOG_TYPE_DEVOUR_ARTIFACT)||Id <- IdList],
			%% 扣钱
			player_lib:incval_on_player_money_log(State, #db_player_money.coin, -NeedCoin,?LOG_TYPE_DEVOUR_ARTIFACT);
		false ->
			{fail, ?ERR_PLAYER_COIN_NOT_ENOUGH}
	end.

get_total_exp(IdList) ->
	Fun = fun(Id, Acc) ->
			case Acc of
				{ok, Exp} ->
					check_id_list(Id, Exp);
				{fail, _Reply} ->
					Acc
			end
		  end,
	lists:foldl(Fun, {ok, 0}, IdList).

check_id_list(Id, Exp) ->
	case goods_lib:get_player_equips_info_by_id(Id) of
		[] ->
			{fail, ?ERR_GOODS_NOT_EXIST};
		GoodsInfo ->
			case GoodsInfo#db_goods.location =:= 1 of
				true ->
					{fail, ?ERR_COMMON_FAIL};
				false ->
					Extra = GoodsInfo#db_goods.extra,
					case get_equips_artifact_info(Extra) of
						{0, 0, 0} ->
							{fail, ?ERR_NOT_ART_CANNOT_DEVOUR};
						{StarLv, Lv, ArtExp} ->
							{ok, get_exp(StarLv, Lv, ArtExp) + Exp}
					end
			end
	end.

%% 神器传承
inheritance_artifact(State, Id1, Id2) ->
	case goods_lib:get_player_equips_info_by_id(Id1) of
		[] ->
			{fail, ?ERR_GOODS_NOT_EXIST};
		GoodsInfo ->
			inheritance_artifact_1(State, GoodsInfo, Id2)
	end.

inheritance_artifact_1(State, GoodsInfo1, Id2) ->
	case goods_lib:get_player_equips_info_by_id(Id2) of
		[] ->
			{fail, ?ERR_GOODS_NOT_EXIST};
		GoodsInfo2 ->
			inheritance_artifact_2(State, GoodsInfo1, GoodsInfo2)
	end.

inheritance_artifact_2(State, GoodsInfo1, GoodsInfo2) ->
	DbPlayerMoney = State#player_state.db_player_money,
	PlayerCoin = DbPlayerMoney#db_player_money.coin,
	GoodsId1 = GoodsInfo1#db_goods.goods_id,
	GoodsId2 = GoodsInfo2#db_goods.goods_id,
	NeedCoin = get_inheritance_artifact_coin(GoodsId1, GoodsId2),

	case PlayerCoin >= NeedCoin of
		true ->
			inheritance_artifact_3(State, GoodsInfo1, GoodsInfo2, NeedCoin);
		false ->
			{fail, ?ERR_PLAYER_COIN_NOT_ENOUGH}
	end.

inheritance_artifact_3(State, GoodsInfo1, GoodsInfo2, NeedCoin) ->
	Extra1 = GoodsInfo1#db_goods.extra,

	case get_equips_artifact_info(Extra1) of
		{0, 0, 0} ->
			{fail, ?ERR_NOT_ART_CANNOT_INHERIT};
		{StarLv, Lv, ArtExp} ->
			Extra2 = GoodsInfo2#db_goods.extra,
			NewExtra1 = lists:keydelete(?EQUIPS_AIRFACT_KEY, 1, Extra1),
			NewExtra2 = lists:keystore(?EQUIPS_AIRFACT_KEY, 1, Extra2, {?EQUIPS_AIRFACT_KEY, StarLv, Lv, ArtExp}),

			%% 更新神器属性
			goods_lib:update_player_goods_info(State, GoodsInfo1#db_goods{extra = NewExtra1}),
			goods_lib:update_player_goods_info(State, GoodsInfo2#db_goods{extra = NewExtra2}),
			%% 更新属性 扣钱
			player_lib:incval_on_player_money_log(State, #db_player_money.coin, -NeedCoin,?LOG_TYPE_DEVOUR_ARTIFACT)
	end.

%% ====================================================================
%% API COMMON
%% ====================================================================

%% 获取新等级和经验
get_new_lv_and_exp(_StarNum1, Lv1, Exp1, 0, TotalCoin) ->
	{Lv1, Exp1, TotalCoin};
get_new_lv_and_exp(StarNum1, Lv1, Exp1, Exp, Coin) ->
	ExpConf = artifact_exp_config:get({Lv1, StarNum1}),
	NeedExp = ExpConf#artifact_exp_conf.exp,
	CoinC = ExpConf#artifact_exp_conf.coin,
	TotalCoin = CoinC * Exp + Coin,
	case Exp1 + Exp < NeedExp of
		true ->
			{Lv1, Exp1 + Exp, TotalCoin};
		false ->
			get_new_lv_and_exp(StarNum1, Lv1 + 1, 0, Exp1 + Exp - NeedExp, TotalCoin)
	end.

%% 获取神器经验
get_exp(_StarLv, 1, _Exp) ->
	1;
get_exp(StarLv, Lv, Exp) ->
	exp(StarLv, Lv - 1, 0) + Exp.

exp(_StarLv, 0, Exp) ->
	Exp;
exp(StarLv, Lv, Exp) ->
	Conf = artifact_exp_config:get({Lv, StarLv}),
	exp(StarLv, Lv - 1, Exp + Conf#artifact_exp_conf.exp).

%% 获取玩家神器对应属性纪录
get_arit_attr_record(SubType, Extra) ->
	case get_equips_artifact_info(Extra) of
		{0, 0, 0} ->
			[];
		{StarLv, Lv, _Exp} ->
			ArtConf = artifact_attr_config:get({SubType, StarLv, Lv}),
			AttrList = ArtConf#artifact_attr_conf.attr_list,

			Fun = fun({Key, Value}, Acc) ->
				[_, AttrKey] = player_lib:get_key_map(Key),
				case Key >= ?UPDATE_KEY_HP_P of
					true ->
						Value1 = max(0, Value * 100 + element(AttrKey, Acc)),
						setelement(AttrKey, Acc, Value1);
					false ->
						Value1 = max(0, Value + element(AttrKey, Acc)),
						setelement(AttrKey, Acc, Value1)
				end
			end,
			lists:foldl(Fun, #attr_base{}, AttrList)
	end.

%% 获取玩家神器属性
get_equips_artifact_info(Extra) ->
	case lists:keyfind(?EQUIPS_AIRFACT_KEY, 1, Extra) of
		{_, StarLv, Lv, Exp} ->
			{StarLv, Lv, Exp};
		_ ->
			{0, 0, 0}
	end.

%% 获取神器传承消耗金币
get_inheritance_artifact_coin(GoodsId1, GoodsId2) ->
	GoodsConf1 = goods_lib:get_goods_conf_by_id(GoodsId1),
	GoodsConf2 = goods_lib:get_goods_conf_by_id(GoodsId2),
	Limit1 = GoodsConf1#goods_conf.limit_lvl,
	Limit2 = GoodsConf2#goods_conf.limit_lvl,

	if
		Limit1 > Limit2 ->
			10000;
		Limit1 == Limit2 ->
			20000;
		true ->
			50000
	end.