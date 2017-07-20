%%%-------------------------------------------------------------------
%%% @author tuhujia
%%% @copyright (C) 2015, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 13. 八月 2015 20:22
%%%-------------------------------------------------------------------
-module(guild_contribution).

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


%% API
-export([
	playe_donate/2,
	update_guild_info_by_donation/4,
	get_player_donate_info/1,
	add_capital/2,
	add_guild_capital_by_info/2,
	get_button_tips/1,
	update_player_contribution/2
]).


%% 玩家捐献GUILD_DONATE
playe_donate(State, Type) ->
	case check_guild_donation(State, Type) of
		{ok, Conf} ->
			ConsumeType = Conf#guild_donation_conf.consume_type,
			ConsumeValue = Conf#guild_donation_conf.consume_value,
			CounterId = Conf#guild_donation_conf.counter_id,
			Contribution = Conf#guild_donation_conf.contribution,
			GuildCapital = Conf#guild_donation_conf.guild_capital,
			GuildExp = Conf#guild_donation_conf.guild_exp,

			update_player_contribution(State, Contribution),
			%% 行会数据进程更新
			PlayerBase = State#player_state.db_player_base,
			GuildId = PlayerBase#db_player_base.guild_id,
			Args = [State, GuildId, GuildExp, GuildCapital],
			guild_mod:update_guild(GuildId, fun guild_contribution:update_guild_info_by_donation/4, Args),

			%% 更新计数器
			PlayerId = State#player_state.player_id,
			counter_lib:update(PlayerId, CounterId),

			%% 推送捐献状态
			Proto = get_player_donate_info(PlayerId),
			net_send:send_to_client(State#player_state.socket, 17052, #rep_guild_donation_info{donation_info = Proto}),

			%% 更新行会日志
			DbBase = State#player_state.db_player_base,
			Name = DbBase#db_player_base.name,
			guild_cache:update_guild_log_list(GuildId, 4, util_date:unixtime(), Name, Type),

			%% 红点检测
			button_tips_lib:ref_button_tips(State, ?BTN_GUILD_CONTRIBUTION),

			%% 扣除玩家对应金币
			case ConsumeType of
				?SUBTYPE_JADE ->
					%% 元宝消耗日志
					goods_lib:broadcast_goods_change(State, ?GOODS_ID_JADE, ConsumeValue, [{2, 1, Contribution}]),

					player_lib:incval_on_player_money_log(State, #db_player_money.jade, -ConsumeValue,?LOG_TYPE_GUILD_DONATE);
				?SUBTYPE_COIN ->
					%% 元宝消耗日志
					goods_lib:broadcast_goods_change(State, ?GOODS_ID_COIN, ConsumeValue, [{2, 1, Contribution}]),

					player_lib:incval_on_player_money_log(State, #db_player_money.coin, -ConsumeValue,?LOG_TYPE_GUILD_DONATE)
			end;
		{fail, Reply} ->
			{fail, Reply}
	end.

%% 增加个人贡献
update_player_contribution(State, Value) ->
	PlayerBase = State#player_state.db_player_base,
	GuildId = PlayerBase#db_player_base.guild_id,
	PlayerId = State#player_state.player_id,
	case player_guild_cache:get_player_guild_info_from_ets(PlayerId, GuildId) of
		[] ->
			skip;
		PGInfo ->
			Contribution = PGInfo#db_player_guild.contribution,
			Contribution1 = Contribution + Value,
			TotalContribution = PGInfo#db_player_guild.totoal_contribution,
			TotalContribution1 = TotalContribution + Value,
			PGInfo1 = PGInfo#db_player_guild{contribution = Contribution1, totoal_contribution = TotalContribution1},
			guild_lib:push_player_guild_info(State, PGInfo1),
			guild_lib:update_player_guild_info(PGInfo1)
	end.

%% 行会新增数值
update_guild_info_by_donation(State, GuildId, Exp, Capital) ->
	case guild_cache:get_guild_info_from_ets(GuildId) of
		[] ->
			skip;
		GuildInfo ->
			GuildInfo1 = add_guild_exp(GuildInfo, Exp),
			GuildInfo2 = add_guild_capital(GuildInfo1, Capital),
			guild_lib:update_guild_info(GuildInfo2),
			%% 推送行会详细信息
			case GuildInfo#db_guild.lv =:= GuildInfo2#db_guild.lv of
				true ->
					skip;
				false ->
					guild_lib:broadcast_guild_info_change(GuildInfo2)
			end,
			guild_lib:push_proto_guild_detailed_info(State, GuildInfo2)
	end.

%% 增加帮会经验
add_guild_exp(GuildInfo, Value) ->
	Lv = GuildInfo#db_guild.lv,
	Exp = GuildInfo#db_guild.expe,
	GuildConf = guild_config:get(Lv),
	LvExp = GuildConf#guild_conf.exp,
	case Exp + Value >= LvExp of
		true ->
			add_guild_exp(GuildInfo#db_guild{lv = Lv + 1}, Value + Exp - LvExp);
		false ->
			GuildInfo#db_guild{expe = Exp + Value}
	end.

%% 增加帮会资金
add_guild_capital(GuildInfo, Value) ->
	C = GuildInfo#db_guild.capital,
	C1 = C + Value,
	GuildInfo#db_guild{capital = C1}.

%% 增加帮会资金 外部接口
add_guild_capital_by_info(GuildInfo, Value) ->
	Args = [GuildInfo, Value],
	GuildId = GuildInfo#db_guild.guild_id,
	guild_mod:update_guild(GuildId, fun guild_contribution:add_capital/2, Args).

add_capital(GuildInfo, Value) ->
	C = GuildInfo#db_guild.capital,
	C1 = C + Value,
	guild_lib:update_guild_info(GuildInfo#db_guild{capital = C1}).


%% 捐献条件检测
check_guild_donation(State, Type) ->
	case util:loop_functions(
		none,
		[fun(_) ->
			PlayerBase = State#player_state.db_player_base,
			GuildId = PlayerBase#db_player_base.guild_id,
			case GuildId =:= 0 of
				true ->
					{break, ?ERR_PLAYER_NOT_JOINED_GUILD};
				false ->
					{continue, none}
			end
		end,
		fun(_) ->
			Conf = guild_donation_config:get(Type),
			ConsumeType = Conf#guild_donation_conf.consume_type,
			ConsumeValue = Conf#guild_donation_conf.consume_value,
			PlayerMoney = State#player_state.db_player_money,
			case ConsumeType of
				?SUBTYPE_COIN ->
					Coin = PlayerMoney#db_player_money.coin,
					case ConsumeValue > Coin of
						true -> {break, ?ERR_PLAYER_COIN_NOT_ENOUGH};
						false -> {continue, Conf}
					end;
				?SUBTYPE_JADE ->
					Jade = PlayerMoney#db_player_money.jade,
					case ConsumeValue > Jade of
						true -> {break, ?ERR_PLAYER_JADE_NOT_ENOUGH};
						false -> {continue, Conf}
					end
			end
		end,
		fun(Conf) ->
			CounterId = Conf#guild_donation_conf.counter_id,
			PlayerId = State#player_state.player_id,
			case counter_lib:check(PlayerId, CounterId) of
				true ->
					{continue, Conf};
				false ->
					{break, ?ERR_PLAYER_ALREADY_DONATE}
			end
		end
		]) of
		{break,Reply} -> {fail, Reply};
		{ok, T} ->
			{ok, T}
	end.

%% 获取玩家捐献信息
get_player_donate_info(PlayerId) ->
	Fun = fun(Type) ->
			Conf = guild_donation_config:get(Type),
			CounterId = Conf#guild_donation_conf.counter_id,
			#proto_donation_info{
				type = Type,
				count = counter_lib:get_value(PlayerId, CounterId)
			}
		  end,
	[Fun(X)||X <- guild_donation_config:get_list()].

%% 红点提示
get_button_tips(PlayerState) ->
	case check_guild_donation(PlayerState, 1) of
		{ok, _Conf} ->
			{PlayerState, 1};
		_ ->
			{PlayerState, 0}
	end.
