%%%-------------------------------------------------------------------
%%% @author tuhujia
%%% @copyright (C) 2015, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 22. 七月 2015 17:20
%%%-------------------------------------------------------------------
-module(goods_lib_log).

-include("common.hrl").
-include("record.hrl").
-include("proto.hrl").
-include("cache.hrl").
-include("db_record.hrl").
-include("config.hrl").
-include("uid.hrl").
-include("language_config.hrl").
-include("button_tips_config.hrl").

%% API
-export([
	add_goods/5,
	add_goods_list/3,
	add_goods_list_by_goods_info/3,
	add_goods_by_goods_info/3,
	add_goods_list_and_send_mail/3,
	delete_goods_by_num/4,
	delete_goods_by_id_and_num/5,
	delete_goods_list_by_id_and_num/3,
	delete_goods_list_by_info/3,
	decompose/4,
	delete_equips_by_id/3,
	delete_equips_by_id/4
]).

%% 添加道具
add_goods(State, GoodsId, IsBind, Num, Type) when Num > 0 andalso (IsBind =:= ?NOT_BIND orelse IsBind == ?BIND) andalso is_record(State, player_state) ->
	GoodsConf = goods_lib:get_goods_conf_by_id(GoodsId),
%% 	io:format("add goods ============>>>>>>>>>>>:~p~n", [{GoodsConf#goods_conf.type, GoodsConf#goods_conf.sub_type}]),
	Result =
		if
			GoodsConf#goods_conf.type =:= ?GOODS_TYPE_VALUE ->
				SubType = GoodsConf#goods_conf.sub_type,
				add_value_goods(State, SubType, Num, Type);
			GoodsConf#goods_conf.type =:= ?GOODS_TYPE_EQUIPS andalso
				GoodsConf#goods_conf.sub_type =:= ?SUBTYPE_WING ->
				goods_lib:add_wing_goods(State, GoodsId);
			GoodsConf#goods_conf.type =:= ?GOODS_TYPE_EQUIPS andalso
				GoodsConf#goods_conf.sub_type =:= ?SUBTYPE_MEDAL ->
				goods_lib:add_medal_goods(State, GoodsId);
			GoodsConf#goods_conf.type =:= ?GOODS_TYPE_EQUIPS andalso
				GoodsConf#goods_conf.sub_type =:= ?SUBTYPE_MOUNTS ->
				goods_lib:add_mounts_goods(State, GoodsId);
			GoodsConf#goods_conf.type =:= ?GOODS_TYPE_EQUIPS andalso
				GoodsConf#goods_conf.sub_type =:= ?SUBTYPE_RING_POWER ->
				goods_lib:add_ring_goods(State, GoodsId, ?SUBTYPE_RING_POWER);
			GoodsConf#goods_conf.type =:= ?GOODS_TYPE_EQUIPS andalso
				GoodsConf#goods_conf.sub_type =:= ?SUBTYPE_RING_DEFENSE ->
				goods_lib:add_ring_goods(State, GoodsId, ?SUBTYPE_RING_DEFENSE);
			GoodsConf#goods_conf.type =:= ?GOODS_TYPE_EQUIPS andalso
				GoodsConf#goods_conf.sub_type =:= ?SUBTYPE_RING_LIFE ->
				goods_lib:add_ring_goods(State, GoodsId, ?SUBTYPE_RING_LIFE);
			true ->
				goods_lib:add_goods_1(State, GoodsId, IsBind, Num)
		end,

	log_lib:log_goods_change(State, GoodsId, Num, Type),
	Result.

%% 添加数值型道具
add_value_goods(State, SubType, Num, Type) ->
	{Type1, Message} = log_lib:get_type(Type),
	case SubType of
		?SUBTYPE_JADE ->
			player_lib:incval_on_player_money_log(State, #db_player_money.jade, Num, Type1);
		?SUBTYPE_COIN ->
			player_lib:incval_on_player_money_log(State, #db_player_money.coin, Num, Type1);
		?SUBTYPE_GIFT ->
			player_lib:incval_on_player_money_log(State, #db_player_money.gift, Num, Type1);
		?SUBTYPE_EXP ->
			player_lib:add_exp(State, Num, {Type1, Message});
		?SUBTYPE_REPUTATION ->
			arena_lib:add_player_arena_reputation(State, Num, Type1);
		?SUBTYPE_FEATS ->
			player_lib:incval_on_player_money_log(State, #db_player_money.feats, Num, Type1);
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

%% 添加商品列表
add_goods_list(State, GoodsList, Type) ->
	PlayerBase = State#player_state.db_player_base,
	AllCell = PlayerBase#db_player_base.bag,
	UseCell = goods_dict:get_bag_cell(),
	NeedCell = goods_lib:get_goods_list_need_cell(GoodsList),
	case UseCell + NeedCell > AllCell of
		true ->
			{fail, ?ERR_PLAYER_BAG_NOT_ENOUGH};
		false ->
			Fun1 = fun({GoodsId, IsBind, Num}, PS) ->
				{ok, PS1} = add_goods(PS, GoodsId, IsBind, Num, Type),
				PS1
			end,
			State1 = lists:foldl(Fun1, State, GoodsList),
			{ok, State1}
	end.

%% 添加商品列表
add_goods_list_by_goods_info(State, GoodsInfoList, LogType) ->
	PlayerBase = State#player_state.db_player_base,
	AllCell = PlayerBase#db_player_base.bag,
	UseCell = goods_dict:get_bag_cell(),
	NeedCell = goods_lib:get_goods_info_list_need_cell(GoodsInfoList),

	case UseCell + NeedCell > AllCell of
		true ->
			{fail, ?ERR_PLAYER_BAG_NOT_ENOUGH};
		false ->

			Fun1 = fun(GoodsInfo, PS) ->
				{ok, PS1} = add_goods_by_goods_info(PS, GoodsInfo, LogType),
				PS1
			end,
			State1 = lists:foldl(Fun1, State, GoodsInfoList),
			{ok, State1}
	end.

%% 添加道具根据道具信息
add_goods_by_goods_info(State, GoodsInfo, LogType) ->
	GoodsId = GoodsInfo#db_goods.goods_id,
	IsBind = GoodsInfo#db_goods.is_bind,
	Num = GoodsInfo#db_goods.num,
	GoodsConf = goods_lib:get_goods_conf_by_id(GoodsId),
	case GoodsConf#goods_conf.type =:= ?TYPE_EQUIPS of
		true ->
			PlayerBase = State#player_state.db_player_base,
			AllCell = PlayerBase#db_player_base.bag,
			UseCell = goods_dict:get_bag_cell(),
			case AllCell - UseCell > 0 of
				true ->
					Result = goods_lib:add_player_goods_info(State, GoodsInfo),
					log_lib:log_goods_change(State, GoodsId, Num, LogType),
					Result;
				false ->
					{fail, ?ERR_PLAYER_BAG_NOT_ENOUGH}
			end;
		false ->
			add_goods(State, GoodsId, IsBind, Num, LogType)
	end.

%% 添加道具列表(背包已满发送邮件)
add_goods_list_and_send_mail(State, GoodsList, LogType) ->
	case add_goods_list(State, GoodsList, LogType) of
		{ok, State1} ->
			{ok, State1};
		{fail, _} ->
			%% 发送邮件
			goods_lib:add_goods_list_and_send_mail_1(State, GoodsList),
			{ok, State}
	end.


%% 删除道具(删除某个数量的道具,一	般系统使用)
delete_goods_by_num(State, GoodsId, Num, LogType) ->
	Result = goods_lib:delete_goods_by_num(State, GoodsId, Num),
	case Result of
		{ok, _} ->
			log_lib:log_goods_change(State, GoodsId, -Num, LogType);
		_ ->
			skip
	end,
	Result.

delete_goods_by_id_and_num(State, Id, GoodsId, Num, LogType) ->
	Result = goods_lib:delete_goods_by_id_and_num(State, Id, GoodsId, Num),
	case Result of
		{ok, _} ->
			log_lib:log_goods_change(State, GoodsId, -Num, LogType);
		_ ->
			skip
	end,
	Result.

delete_goods_list_by_id_and_num(State, GoodsList, LogType) ->
	[delete_goods_by_id_and_num(State, Id, GoodsId, Num, LogType) || {Id, GoodsId, Num} <- GoodsList].

%% 删除道具列表(Info)
delete_goods_list_by_info(State, GoodsList, LogType) ->
	Fun = fun(DbInfo, {_, AccState}) ->
		Id = DbInfo#db_goods.id,
		GoodsId = DbInfo#db_goods.goods_id,
		Num = DbInfo#db_goods.num,
		Result = goods_lib:delete_goods_by_id(AccState, Id, GoodsId),
		case Result of
			{ok, _} ->
				log_lib:log_goods_change(State, GoodsId, -Num, LogType);
			_ ->
				skip
		end,
		Result
	end,
	lists:foldl(Fun, {ok, State}, GoodsList).

%% 分解
decompose(PlayerState, EquipsList, AddGoodsList, LogType) ->
	PlayerBase = PlayerState#player_state.db_player_base,
	AllCell = PlayerBase#db_player_base.bag,
	UseCell = goods_dict:get_bag_cell(),
	NeedCell = goods_lib:get_goods_list_need_cell(AddGoodsList),
	FreeCell = length(EquipsList),
	%% 初始化玩家道具推送为不广播模式
	PlayerState1 = PlayerState#player_state{
		is_lottery_begin = true,
		equip_list = [],
		goods_list = []
	},

	case AllCell >= UseCell - FreeCell + NeedCell of
		true ->
			Fun = fun(Id, Acc) ->
				case delete_equips_by_id(Acc, Id, true, LogType) of
					{ok, Acc1} ->
						Acc1;
					_ ->
						Acc
				end
			end,
			PlayerState2 = lists:foldl(Fun, PlayerState1, EquipsList),
			{ok, PlayerState3} = add_goods_list(PlayerState2, AddGoodsList, LogType),
			%% 推送改变的道具列表给前段  并重置广播状态
			PlayerState4 = goods_lib:broadcast_goods_change_info(PlayerState3),
			{ok, PlayerState4};
		false ->
			{fail, ?ERR_PLAYER_BAG_NOT_ENOUGH}
	end.

%% 删除装备道具(利用道具唯一ID删除道具)
delete_equips_by_id(State, Id, LogType) ->
	case goods_lib:get_player_equips_info_by_id(Id) of
		#db_goods{} = GoodsInfo ->
			{ok, NewState} = goods_lib:delete_player_goods_info(State, GoodsInfo),
			log_lib:log_goods_change(State, GoodsInfo#db_goods.goods_id, -GoodsInfo#db_goods.num, LogType),
			%% 道具删除额处理
			goods_lib:delete_goods_manage(NewState, GoodsInfo#db_goods.goods_id, GoodsInfo#db_goods.num);
		_ ->
			{fail, ?ERR_GOODS_NOT_ENOUGH}
	end.
delete_equips_by_id(State, Id, IsBroad, LogType) ->
	case goods_lib:get_player_equips_info_by_id(Id) of
		#db_goods{} = GoodsInfo ->
			{ok, NewState} = goods_lib:delete_player_goods_info(State, GoodsInfo, IsBroad),
			log_lib:log_goods_change(State, GoodsInfo#db_goods.goods_id, -GoodsInfo#db_goods.num, LogType),
			%% 道具删除额处理
			goods_lib:delete_goods_manage(NewState, GoodsInfo#db_goods.goods_id, GoodsInfo#db_goods.num);
		_ ->
			{fail, ?ERR_GOODS_NOT_ENOUGH}
	end.
