%%%-------------------------------------------------------------------
%%% @author qhb
%%% @copyright (C) 2017, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 04. 三月 2017 下午6:58
%%%-------------------------------------------------------------------
-module(source_db).
-include("common.hrl").
-include("cache.hrl").
-include("record.hrl").
-include("proto.hrl").
-include("gameconfig_config.hrl").

%% API
-export([
	select_player/2,
	select_all_goods/2
]).

select_player(Pool, PlayerId) ->
	case db_mysql:select_row(Pool, player_base, record_info(fields, db_player_base), [{player_id, PlayerId}]) of
		[] ->
			[];
		List ->
			Record = list_to_tuple([db_player_base | List]),
			%% 记录领取奖励设置
			TaskRewardActive = get_task_reward_active(Record),
			%% 记录设置信息
			HpSet = util_data:string_to_term(Record#db_player_base.hp_set),
			HpMpSet = util_data:string_to_term(Record#db_player_base.hpmp_set),
			Guise = get_guise(Record),
			EquilSellSet = get_equip_sell_set(Record),
			PickupSet = get_pickup_set(Record),
			Record#db_player_base{
				task_reward_active = TaskRewardActive,
				hp_set = HpSet,
				hpmp_set = HpMpSet,
				guise = Guise,
				equip_sell_set = EquilSellSet,
				pickup_set = PickupSet
			}
	end.

select_all_goods(Pool, PlayerId) ->
	case db_mysql:select_all(Pool, player_goods, record_info(fields, db_goods), [{player_id, PlayerId}], [], []) of
		[] ->
			[];
		List ->
			Fun = fun(List1) ->
				DbGoods = list_to_tuple([db_goods | List1]),
				DbGoods#db_goods{extra = util_data:string_to_term(DbGoods#db_goods.extra)}
			end,
			[Fun(X) || X <- List]
	end.


%% ====================================================================
%% Internal functions
%% ====================================================================
get_task_reward_active(PlayerBase) ->
	TaskRewardActive = util_data:string_to_term(PlayerBase#db_player_base.task_reward_active),
	F = fun(X) ->
		case X of
			{_} ->
				X;
			_ ->
				{X}
		end
	end,
	[F(X) || X <- TaskRewardActive].

get_equip_sell_set(Record) ->
	case is_record(util_data:string_to_term(Record#db_player_base.equip_sell_set), proto_equip_sell_set) of
		false ->
			?GAMECONFIG_EQUIP_SELL_SET;
		_ ->
			util_data:string_to_term(Record#db_player_base.equip_sell_set)
	end.

get_pickup_set(Record) ->
%%     ?ERR("222111 ~p", [Record#db_player_base.pickup_set]),
	PickUp = util_data:string_to_term(Record#db_player_base.pickup_set),
	case is_record(PickUp, proto_pickup_set) of
		false ->
			?GAMECONFIG_PiCKUP_SET;
		_ ->
			PickUp
	end.

get_guise(Record) ->
	case is_record(util_data:string_to_term(Record#db_player_base.guise), guise_state) of
		false ->
			?GAMECONFIG_GUISE_STATE;
		_ ->
			%% Guise信息转换
			OldGuise = util_data:string_to_term(Record#db_player_base.guise),
			case OldGuise of
				{_, Weapon, Clothes, Wing, Pet} ->
					#guise_state
					{
						weapon = Weapon,
						clothes = Clothes,
						wing = Wing,
						pet = Pet,
						mounts = 0,
						mounts_aura = 0
					};
				{_, Weapon, Clothes, Wing, Pet, _Mounts} ->
					#guise_state
					{
						weapon = Weapon,
						clothes = Clothes,
						wing = Wing,
						pet = Pet,
						mounts = 0,
						mounts_aura = 0
					};
				_ ->
					OldGuise#guise_state{mounts = 0, mounts_aura = 0}
			end
	end.
