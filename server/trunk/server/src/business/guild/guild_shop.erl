%%%-------------------------------------------------------------------
%%% @author tuhujia
%%% @copyright (C) 2015, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 13. 八月 2015 20:22
%%%-------------------------------------------------------------------
-module(guild_shop).

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
	exchange_guild_shop/3
]).

%% 行会商店兑换
exchange_guild_shop(State, ShopId, Num) ->
	PlayerBase = State#player_state.db_player_base,
	GuildId = PlayerBase#db_player_base.guild_id,
	case GuildId =:= 0 of
		true ->
			{fail, ?ERR_PLAYER_NOT_JOINED_GUILD};
		false ->
			exchange_guild_shop_1(State, ShopId, Num)
	end.

exchange_guild_shop_1(State, ShopId, Num) ->
	Conf = guild_shop_config:get(ShopId),
	LimitLv = Conf#guild_shop_conf.limit_lv,
	PlayerBase = State#player_state.db_player_base,
	PlayerLv = PlayerBase#db_player_base.lv,
	case PlayerLv >= LimitLv of
		true ->
			exchange_guild_shop_2(State, Conf, Num);
		false ->
			{fail, ?ERR_PLAYER_LV_NOT_ENOUGH}
	end.

exchange_guild_shop_2(State, Conf, Num) ->
	PlayerBase = State#player_state.db_player_base,
	GuildId = PlayerBase#db_player_base.guild_id,
	GuildInfo = guild_cache:get_guild_info_from_ets(GuildId),
	GuildLv = GuildInfo#db_guild.lv,
	LimitGuildLv = Conf#guild_shop_conf.limit_guild_lv,
	case GuildLv >= LimitGuildLv of
		true ->
			exchange_guild_shop_3(State, Conf, Num);
		false ->
			{fail, ?ERR_GUILD_LV_NOT_ENOUGH}
	end.

exchange_guild_shop_3(State, Conf, Num) ->
	PlayerBase = State#player_state.db_player_base,
	GuildId = PlayerBase#db_player_base.guild_id,
	PlayerId = State#player_state.player_id,
	PGInfo = player_guild_cache:get_player_guild_info_from_ets(PlayerId, GuildId),
	Contribution = PGInfo#db_player_guild.contribution,
	NeedContribution = Conf#guild_shop_conf.need_contribution,
	case Contribution >= NeedContribution * Num of
		true ->
			exchange_guild_shop_4(State, PGInfo, Conf, Num);
		false ->
			{fail, ?ERR_PLAYER_CONTRIBUTION_NOT_ENOUGH}
	end.

exchange_guild_shop_4(State, PGInfo, Conf, Num) ->
	LimitCount = Conf#guild_shop_conf.limit_count,
	ShopId = Conf#guild_shop_conf.key,
	PlayerId = State#player_state.player_id,
	case LimitCount > 0 of
		true ->
			case guild_shop_cache:select_row(PlayerId, ShopId) of
				null ->
					case Num > LimitCount of
						true ->
							{fail, ?ERR_PLAYER_COUNT_NOT_ENOUGH};
						false ->
							DbGuildShop = #db_player_guild_shop{
								player_id = PlayerId,
								shop_id = ShopId,
								count = Num,
								update_time = util_date:unixtime()
							},
							exchange_guild_shop_5(State, PGInfo, Conf, Num, DbGuildShop)
					end;
				DbGuildShop ->
					UpdateTime = DbGuildShop#db_player_guild_shop.update_time,
					Count =
					case UpdateTime > util_date:get_today_unixtime() of
						true ->
							DbGuildShop#db_player_guild_shop.count;
						false ->
							0
					end,

					case Count + Num > LimitCount of
						true ->
							{fail, ?ERR_PLAYER_COUNT_NOT_ENOUGH};
						false ->
							NewDbGuildShop = #db_player_guild_shop{
								player_id = PlayerId,
								shop_id = ShopId,
								count = Count + Num,
								update_time = util_date:unixtime()
							},
							exchange_guild_shop_5(State, PGInfo, Conf, Num, NewDbGuildShop)
					end
			end;
		false ->
			exchange_guild_shop_5(State, PGInfo, Conf, Num)
	end.

exchange_guild_shop_5(State, PGInfo, Conf, Num) ->
	GoodsId = Conf#guild_shop_conf.goods_id,
	case goods_lib_log:add_goods(State, GoodsId, ?BIND, Num,?LOG_TYPE_GUILD_SHOP) of
		{ok, State1} ->
			update_info(State1, PGInfo, Conf, Num),
			{ok, State1};
		{fail, Reply} ->
			{fail, Reply}
	end.
exchange_guild_shop_5(State, PGInfo, Conf, Num, DbGuildShop) ->
	GoodsId = Conf#guild_shop_conf.goods_id,
	case goods_lib_log:add_goods(State, GoodsId, ?BIND, Num,?LOG_TYPE_GUILD_SHOP) of
		{ok, State1} ->
			update_info(State1, PGInfo, Conf, Num),
			guild_shop_cache:replace(DbGuildShop),
			{ok, State1};
		{fail, Reply} ->
			{fail, Reply}
	end.

update_info(State, PGInfo, Conf, Num) ->
	Contribution = PGInfo#db_player_guild.contribution,
	NeedContribution = Num * Conf#guild_shop_conf.need_contribution,
	Contribution1 = Contribution - NeedContribution,
	PGInfo1 = PGInfo#db_player_guild{contribution = Contribution1},
	guild_lib:update_player_guild_info(PGInfo1),
	guild_lib:push_player_guild_info(State, PGInfo1).