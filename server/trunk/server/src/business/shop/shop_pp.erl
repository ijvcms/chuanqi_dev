%%%-------------------------------------------------------------------
%%% @author tuhujia
%%% @copyright (C) 2015, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 16. 十月 2015 15:42
%%%-------------------------------------------------------------------
-module(shop_pp).

-include("common.hrl").
-include("record.hrl").
-include("proto.hrl").
-include("cache.hrl").
-include("config.hrl").
-include("language_config.hrl").

%% API
-export([
    handle/3
]).

%% ====================================================================
%% API functions
%% ====================================================================

%% 购买商品
handle(16001, PlayerState, #req_buy_shop{id = ShopId, num = ShopNum}) ->
    case shop_lib:buy_shop(PlayerState, ShopId, ShopNum) of
        {ok, PlayerState1} ->
            net_send:send_to_client(PlayerState1#player_state.socket, 16001, #rep_buy_shop{result = ?ERR_COMMON_SUCCESS}),
            {ok, PlayerState1};
        {fail, Reply} ->
            net_send:send_to_client(PlayerState#player_state.socket, 16001, #rep_buy_shop{result = Reply})
    end;

%% 获取云游商人列表
handle(16002, PlayerState, _Data) ->
    wander_shop_lib:send_proto_wander_shop_list(PlayerState);

%%商品数量限制
handle(16003, PlayerState, #req_buy_limit{id = ShopId}) ->
    ShopConf = shop_config:get(ShopId),
    CounterId = ShopConf#shop_conf.counter_id,

    case CounterId > 0 of
        true ->
            UseNum = counter_lib:get_value(PlayerState#player_state.player_id, CounterId),
            LimitNum = counter_lib:get_limit(CounterId),
            Rep = #rep_buy_limit{use_num = UseNum, limit_num = LimitNum},
            net_send:send_to_client(PlayerState#player_state.socket, 16003, Rep);
        false ->
            Rep = #rep_buy_limit{use_num = 0, limit_num = 0},
            net_send:send_to_client(PlayerState#player_state.socket, 16003, Rep)
    end;

%%一生一次礼包状态列表
handle(16004, PlayerState, #req_shop_once_list{lv = Lv}) ->
    shop_lib:shop_once_state(PlayerState, Lv);

%%一生一次礼包购买
handle(16005, PlayerState, #req_shop_once_buy{lv = Lv, pos = Pos}) ->
    case shop_lib:shop_once_buy(PlayerState, Lv, Pos) of
        {ok, PlayerState1} ->
            net_send:send_to_client(PlayerState1#player_state.socket, 16005, #rep_shop_once_buy{result = ?ERR_COMMON_SUCCESS}),
            {ok, PlayerState1};
        {fail, Reply} ->
            net_send:send_to_client(PlayerState#player_state.socket, 16005, #rep_shop_once_buy{result = Reply})
    end;


%% 获取神秘商人物品
handle(16100, PlayerState, _Data) ->
    %% 判断神秘商人是否开启
    FunctionConf = function_config:get(?FUNCTION_MYSTERY_SHOP),
    case function_lib:check_is_open_time(FunctionConf) of%%
        {true, _} ->
            PlayerState1 = mystery_shop_lib:ref_time(PlayerState),
            List = mystery_shop_lib:get_mystery_shop_list(PlayerState1),
            CurTime = util_date:unixtime(),

            Data1 = #rep_get_mystery_shop_list{
                is_open = 1,
                mystery_shop_list = List,
                count = counter_lib:get_last_value(PlayerState1#player_state.player_id, ?COUNTER_BUY_MYSTERY_LIMIE),
                ref_time = PlayerState1#player_state.ref_mystery_shop_time - CurTime,
                need_jade = mystery_shop_lib:get_need_jade()
            },
            net_send:send_to_client(PlayerState#player_state.socket, 16100, Data1),
            {ok, PlayerState1};
        _ ->
            Data1 = #rep_get_mystery_shop_list{
                is_open = 0
            },
            net_send:send_to_client(PlayerState#player_state.socket, 16100, Data1)
    end;

%% 购买神秘商人物品
handle(16101, PlayerState, #req_buy_mystery_shop{mystery_shop_id = MysteryShopId}) ->
    case mystery_shop_lib:buy_mystery_shop(PlayerState, MysteryShopId) of
        {ok, PlayerState1} ->
            net_send:send_to_client(PlayerState1#player_state.socket, 16101, #rep_buy_mystery_shop{result = ?ERR_COMMON_SUCCESS}),
            {ok, PlayerState1};
        {fail, Reply} ->
            net_send:send_to_client(PlayerState#player_state.socket, 16101, #rep_buy_mystery_shop{result = Reply})
    end;

%% 手动刷新神秘商店物品
handle(16102, PlayerState, _Data) ->
    case mystery_shop_lib:ref_mystery_shop_list(PlayerState) of
        {ok, PlayerState1, List} ->
            Data1 = #rep_ref_mystery_shop_list{
                mystery_shop_list = List,
                result = 0
            },
            net_send:send_to_client(PlayerState1#player_state.socket, 16102, Data1),
            {ok, PlayerState1};
        {fail, Reply} ->
            net_send:send_to_client(PlayerState#player_state.socket, 16102, #rep_ref_mystery_shop_list{result = Reply})
    end;

handle(Cmd, PlayerState, Data) ->
    ?ERR("not define ~p cmd:~nstate: ~p~ndata: ~p", [Cmd, PlayerState, Data]),
    {ok, PlayerState}.
