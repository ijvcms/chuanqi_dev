%%%-------------------------------------------------------------------
%%% @author tuhujia
%%% @copyright (C) 2015, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 27. 八月 2015 11:29
%%%-------------------------------------------------------------------
-module(arena_shop_lib).

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
	buy_arena_item/2
]).

%% ====================================================================
%% API functions
%% ====================================================================

%% 购买竞技场商品
buy_arena_item(State, Id) ->
	PlayerId = State#player_state.player_id,
	case arena_shop_cache:check_can_buy_arena_shop_by_id(Id, PlayerId) of
		{ok, Conf} ->
			NeedReputation = Conf#arena_shop_conf.reputation,
			case arena_lib:get_player_arena_reputation(State) >= NeedReputation of
				true ->
					GoodsId = Conf#arena_shop_conf.goods_id,
					case goods_lib_log:add_goods(State, GoodsId, ?BIND, 1,?LOG_TYPE_BUY_ARENA) of
						{ok, State1} ->
							arena_lib:reduce_player_arena_reputation(State, NeedReputation, ?LOG_TYPE_BUY_ARENA),
							arena_shop_cache:add_arena_shop_buy_count(Id, PlayerId),
							{ok, State1};
						{fail, Reply} ->
							{fail, Reply}
					end;
				false ->
					{fail, ?ERR_PLAYER_REPUTATION_NOT_ENOUGH}
			end;
		{fail, Reply} ->
			{fail, Reply}
	end.
