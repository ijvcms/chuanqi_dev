%%%-------------------------------------------------------------------
%%% @author zhengsiying
%%% @copyright (C) 2015, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 21. 七月 2015 下午5:46
%%%-------------------------------------------------------------------
-module(player_base_db).

-include("common.hrl").
-include("cache.hrl").
-include("record.hrl").
-include("proto.hrl").
-include("gameconfig_config.hrl").
%% API
-export([
    select_row/1,
    insert/1,
    update/2,
    select_all/0,
    check_name/1
]).

%% ====================================================================
%% API functions
%% ====================================================================
select_row(PlayerId) ->
    case db:select_row(player_base, record_info(fields, db_player_base), [{player_id, PlayerId}]) of
        [] ->
            null;
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

select_all() ->
    case db:select_all(player_base, record_info(fields, db_player_base), []) of
        [] ->
            [];
        List ->
            [list_to_tuple([db_player_base | X]) || X <- List]
    end.
%% 检测名字是否重复
check_name(Name) ->
    Sql = "select count(name) from player_base where name='~s'",
    Sql1 = io_lib:format(Sql, [Name]),
    case db:execute(Sql1) of
        [[0]] ->
            false;
        _ ->
            true
    end.

insert(PlayerBase) ->
    %% 记录领取奖励设置
    TaskRewardActive = util_data:term_to_string(PlayerBase#db_player_base.task_reward_active),
    %% 记录设置信息
    HpSet = util_data:term_to_string(PlayerBase#db_player_base.hp_set),
    HpMpSet = util_data:term_to_string(PlayerBase#db_player_base.hpmp_set),
    Guise = util_data:term_to_string(PlayerBase#db_player_base.guise),

    EquipSellSet = util_data:term_to_string(PlayerBase#db_player_base.equip_sell_set),
    PickupSet = util_data:term_to_string(PlayerBase#db_player_base.pickup_set),

    PlayerBase1 = PlayerBase#db_player_base{
        task_reward_active = TaskRewardActive,
        hp_set = HpSet,
        hpmp_set = HpMpSet,
        guise = Guise,
        equip_sell_set = EquipSellSet,
        pickup_set = PickupSet
    },
    db:insert(player_base, util_tuple:to_tuple_list(PlayerBase1)).

update(PlayerId, PlayerBase) ->
    %% 记录领取奖励设置
    TaskRewardActive = util_data:term_to_string(PlayerBase#db_player_base.task_reward_active),
    %% 记录设置信息
    HpSet = util_data:term_to_string(PlayerBase#db_player_base.hp_set),
    HpMpSet = util_data:term_to_string(PlayerBase#db_player_base.hpmp_set),
    Guise = util_data:term_to_string(PlayerBase#db_player_base.guise),

    EquipSellSet = util_data:term_to_string(PlayerBase#db_player_base.equip_sell_set),
    PickupSet = util_data:term_to_string(PlayerBase#db_player_base.pickup_set),

    PlayerBase1 = PlayerBase#db_player_base{
        task_reward_active = TaskRewardActive,
        hp_set = HpSet,
        hpmp_set = HpMpSet,
        guise = Guise,
        equip_sell_set = EquipSellSet,
        pickup_set = PickupSet
    },

    db:update(player_base, util_tuple:to_tuple_list(PlayerBase1), [{player_id, PlayerId}]).


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

%% ====================================================================
%% Internal functions
%% ====================================================================
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
