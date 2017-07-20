%%%-------------------------------------------------------------------
%%% @author yubing
%%% @copyright (C) 2016, <COMPANY>
%%% @doc 开服活动信息
%%%
%%% @end
%%% Created : 23. 二月 2016 18:06
%%%-------------------------------------------------------------------
-module(active_shop_lib).

-include("common.hrl").
-include("record.hrl").
-include("config.hrl").
-include("cache.hrl").
-include("db_record.hrl").
-include("proto.hrl").
-include("language_config.hrl").
-include("log_type_config.hrl").
-include("button_tips_config.hrl").
-include("rank.hrl").
-include("uid.hrl").
%%% ----------------------------------------------------------------------------
%%% 对外接口
%%% ----------------------------------------------------------------------------

-export([
	get_active_shop_list/2,
	buy_mystery_shop/3,
	get_active_shop_proto/2
]).


%%获取活动列表信息
get_active_shop_list(PlayerState, Type) ->
	[get_active_shop_proto(PlayerState#player_state.player_id, X) || X <- active_service_shop_config:get_type_list(Type)].

%% 获取商品相关信息
get_active_shop_proto(PlayerId, ActiveShopKey) ->
	ShopConf = active_service_shop_config:get(ActiveShopKey),
	{BuyNum1, LimitNum1} = case ShopConf#active_service_shop_conf.counter_id > 0 of
							   true ->
								   BuyNum = counter_lib:get_value(PlayerId, ShopConf#active_service_shop_conf.counter_id),
								   LimitNum = counter_lib:get_limit(ShopConf#active_service_shop_conf.counter_id),
								   {BuyNum, LimitNum};
							   _ ->
								   {0, 0}
						   end,

	#proto_active_shop{
		id = ShopConf#active_service_shop_conf.key,
		goods_id = ShopConf#active_service_shop_conf.goods_id,
		num = ShopConf#active_service_shop_conf.num,
		is_bind = ShopConf#active_service_shop_conf.is_bind,
		price = ShopConf#active_service_shop_conf.price,
		curr_type = ShopConf#active_service_shop_conf.curr_type,
		buy_num = BuyNum1,
		limit_num = LimitNum1
	}.

%% 购买商品
buy_mystery_shop(PlayerState, ActiveShopKey, BuyNum) ->
	ActiveShopConf = active_service_shop_config:get(ActiveShopKey),
	#active_service_shop_conf{
		curr_type = CurrType,
		price = Price,
		counter_id = CounterId,
		goods_id = GoodsId,
		is_bind = IsBind,
		num = Num,
		type = Type
	} = ActiveShopConf,
	case check_shop(PlayerState, CounterId, BuyNum) of
		{fail, Err} ->
			{fail, Err};
		_ ->
			NeedPrice = Price * BuyNum,
			AddNum = Num * BuyNum,
			case mystery_shop_lib:check_price(PlayerState, CurrType, NeedPrice) of
				{ok, _Price} ->
					case goods_lib_log:add_goods_list(PlayerState, [{GoodsId, IsBind, AddNum}], log_type_config:get_active_type_id(Type)) of
						{ok, PlayerState1} ->
							update_shop(PlayerState1, CounterId, BuyNum),
							%% 扣除玩家的消耗
							mystery_shop_lib:deduct_money(PlayerState1, CurrType, NeedPrice,log_type_config:get_active_type_id(Type));
						Err ->
							Err
					end;
				Err ->
					Err
			end
	end.
%% 判断商品的限制信息
check_shop(PlayerState, CounterId, Num) ->
	case CounterId > 0 of
		true ->
			case counter_lib:check_num(PlayerState#player_state.player_id, CounterId, Num) of
				false ->
					{fail, ?ERR_BUY_MYSTERY_LIMIT};
				_ ->
					true
			end;
		_ ->
			true
	end.
%% 记录玩家购买次数
update_shop(PlayerState, CounterId, Num) ->
	case CounterId > 0 of
		true ->
			%% 神秘商人购买上限
			counter_lib:update_limit(PlayerState#player_state.player_id, CounterId, Num);
		_ ->
			skip
	end.
