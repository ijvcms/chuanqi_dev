%%%-------------------------------------------------------------------
%%% @author tuhujia
%%% @copyright (C) 2015, <COMPANY>
%%% @doc 锻造功能已关闭
%%%
%%% @end
%%% Created : 18. 九月 2015 16:28
%%%-------------------------------------------------------------------
-module(equips_forge).

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
	get_forge_equips_id/1,
	update_forge_equips_id/2,
	forge_equips/1,
	forge_id_transformation/1,
	update_forges_equips/1
]).

%% 锻造系数
-define(FORGE_RUP, 1000000).
%% 百分比系数
-define(RATE_RUP, 10000).
%% 最高品质
-define(MAX_QUALITY, 4).
%% 次数锻造
-define(FORGE_COUNTER, 1).
%% 宝石锻造
-define(FORGE_JADE, 2).
%% 宝石锻造需要价格
-define(FORGE_JADE_NEED, 10).

%% ====================================================================
%% API functions
%% ====================================================================

%% 获取锻造装备id
get_forge_equips_id(State) ->
	PlayerBase = State#player_state.db_player_base,
	ForgeId = PlayerBase#db_player_base.forge,
	case ForgeId =:= 0 of
		true ->
			PlayerLv = PlayerBase#db_player_base.lv,
			NewForgeId = update_forges_equips(PlayerLv),
			PlayerBase1 = PlayerBase#db_player_base{forge = NewForgeId},
			State1 = State#player_state{db_player_base = PlayerBase1},

			%% 加入缓存
			player_base_cache:update(State#player_state.player_id, PlayerBase1),

			{NewForgeId, State1};
		false ->
			{ForgeId, State}
	end.

%% 刷新锻造装备id
update_forge_equips_id(State, ?FORGE_COUNTER) ->
	PlayerId = State#player_state.player_id,
	case counter_lib:check(PlayerId, ?EQUIPS_FORGE_UPDATE_TIMES_COUNTER) of
		true ->
			PlayerBase = State#player_state.db_player_base,
			PlayerLv = PlayerBase#db_player_base.lv,
			NewForgeId = update_forges_equips(PlayerLv),
			PlayerBase1 = PlayerBase#db_player_base{forge = NewForgeId},
			State1 = State#player_state{db_player_base = PlayerBase1},

			%% 更新计数器
			counter_lib:update(PlayerId, ?EQUIPS_FORGE_UPDATE_TIMES_COUNTER),

			%% 加入缓存
			player_base_cache:update(State#player_state.player_id, PlayerBase1),

			%% 推送新的锻造信息
			goods_lib:handle(14028, State1, []),

			{ok, State1};
		false ->
			{fail, ?ERR_FORGE_UPDATE_TIMES_NOT_ENOUGH}
	end;
%% 刷新锻造装备id
update_forge_equips_id(State, ?FORGE_JADE) ->
	PlayerMoney = State#player_state.db_player_money,
	PlayerJade = PlayerMoney#db_player_money.jade,
	case PlayerJade >= ?FORGE_JADE_NEED of
		true ->
			PlayerBase = State#player_state.db_player_base,
			PlayerLv = PlayerBase#db_player_base.lv,
			NewForgeId = update_forges_equips(PlayerLv),
			PlayerBase1 = PlayerBase#db_player_base{forge = NewForgeId},
			State1 = State#player_state{db_player_base = PlayerBase1},

			%% 加入缓存
			player_base_cache:update(State#player_state.player_id, PlayerBase1),

			%% 推送新的锻造信息
			goods_lib:handle(14028, State1, []),

			{ok, State2} = player_lib:incval_on_player_money_log(State1, #db_player_money.jade, -?FORGE_JADE_NEED, ?LOG_TYPE_FORGE_EQUIPS),
			{ok, State2};
		false ->
			{fail, ?ERR_PLAYER_JADE_NOT_ENOUGH}
	end.

%% 锻造装备
forge_equips(State) ->
	case check_forge_equips(State) of
		{ok, UseSmelt, GoodsId, StarLv} ->
			Extra = case StarLv > 0 of true -> [{?EQUIPS_AIRFACT_KEY, StarLv, 1, 0}]; false -> [] end,
			case goods_lib:add_equips(State, GoodsId, 1, 1, Extra) of
				{fail, _} ->
					{fail, ?ERR_PLAYER_BAG_NOT_ENOUGH};
				_ ->
					%% 扣除熔炼值
					{ok, State1} = player_lib:incval_on_player_money_log(State, #db_player_money.smelt_value, -UseSmelt, ?LOG_TYPE_FORGE_EQUIPS),
					%% 推送新的锻造信息
					PlayerBase = State1#player_state.db_player_base,
					PlayerBase1 = PlayerBase#db_player_base{forge = 0},
					{ok, State2} = goods_lib:handle(14028, State1#player_state{db_player_base = PlayerBase1}, []),
					{ok, State2}
			end;
		{fail, Reply} ->
			{fail, Reply}
	end.

%% 装备锻造检测
check_forge_equips(State) ->
	case util:loop_functions(
		none,
		[fun(_)
			->
			PlayerBase = State#player_state.db_player_base,
			ForgeId = PlayerBase#db_player_base.forge,
			{StarLv, GoodsId} = forge_id_transformation(ForgeId),
			GoodsConf = goods_lib:get_goods_conf_by_id(GoodsId),
			GoodsLv = GoodsConf#goods_conf.limit_lvl,
			MaxLv = equips_lib:get_equips_range_max_lv(GoodsLv),
			Quality = GoodsConf#goods_conf.quality,
			ConsumeConf = forge_consume_config:get({StarLv, MaxLv, Quality}),
			UseSmelt = ConsumeConf#forge_consume_conf.use_smelt,

			PlayerMoney = State#player_state.db_player_money,
			SmeltValue = PlayerMoney#db_player_money.smelt_value,


			case UseSmelt > SmeltValue of
				true ->
					{break, ?ERR_PLAYER_SMELT_NOT_ENOUGH};
				false ->
					{continue, {UseSmelt, GoodsId, StarLv}}
			end
		end
		]) of
		{break, Reply} -> {fail, Reply};
		{ok, {UseSmelt, GoodsId, StarLv}} ->
			{ok, UseSmelt, GoodsId, StarLv}
	end.

%% ====================================================================
%%
%% ====================================================================

%% 刷新装备锻造id
update_forges_equips(_PlayerLv) ->
%% 	PlayerLv = util_rand:rand(1, 30),
%% 	List = [{S, Min, Max}||{S, Min, Max} <- equips_forge_config:get_list(), PlayerLv >= Min andalso PlayerLv =< Max],
%% 	Rand = util_rand:rand(1, ?RATE_RUP),
%% 	ForgeConf = get_rand_forge_conf([], Rand, 0, List),
%%
%% 	{GodStar, MinLv, MaxLv} = ForgeConf#equips_forge_conf.key,
%% 	QualityRandList = ForgeConf#equips_forge_conf.quality_rate,
%% 	Quality = get_rand_qulity(util_rand:rand(1, ?RATE_RUP), 0, QualityRandList),
%% 	EquipsList = equips_config:get({util_rand:rand(MinLv, MaxLv), Quality}),
	EquipsList = equips_config:get({33, 2}),

	GoodsId = util_rand:list_rand(EquipsList),
%% 	ForgeId = ?FORGE_RUP * GodStar + GoodsId,
	ForgeId = ?FORGE_RUP * 0 + GoodsId,
	ForgeId.

%% get_rand_forge_conf(Conf, _Rand, _Value, []) ->
%% 	Conf;
%% get_rand_forge_conf([], Rand, Value, [H|T]) ->
%% 	Conf = equips_forge_config:get(H),
%% 	Value1 = Value + Conf#equips_forge_conf.rate,
%% 	case Value1 >= Rand of
%% 		true ->
%% 			Conf;
%% 		false ->
%% 			get_rand_forge_conf([], Rand, Value1, T)
%% 	end.
%%
%% get_rand_qulity(Rand, Value, [H|T]) ->
%% 	{Quality, Value1} = H,
%% 	Value2 = Value + Value1,
%% 	case Value2 >= Rand of
%% 		true ->
%% 			Quality;
%% 		false ->
%% 			get_rand_qulity(Rand, Value2, T)
%% 	end.

forge_id_transformation(ForgeId) ->
	StarLv = ForgeId div ?FORGE_RUP,
	GoodsId = ForgeId rem ?FORGE_RUP,
	{StarLv, GoodsId}.