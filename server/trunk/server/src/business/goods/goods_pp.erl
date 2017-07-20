%%%-------------------------------------------------------------------
%%% @author tuhujia
%%% @copyright (C) 2015, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 02. 九月 2015 11:38
%%%-------------------------------------------------------------------
-module(goods_pp).

-include("common.hrl").
-include("record.hrl").
-include("proto.hrl").
-include("cache.hrl").
-include("config.hrl").
-include("language_config.hrl").
-include("log_type_config.hrl").
-include("button_tips_config.hrl").

%% API
-export([
    handle/3
]).

%% ====================================================================
%% API functions
%% ====================================================================

%% 获取玩家道具信息列表
handle(14001, PlayerState, _Data) ->
    GoodsList = goods_lib:get_goods_info_list(),
    net_send:send_to_client(PlayerState#player_state.socket, 14001, #rep_goods_list{goods_list = GoodsList});

%%添加道具
handle(14003, PlayerState, _Data) ->
    case config:get_server_no() < 900 of
        true ->
            #req_add_goods{
                goods_id = GoodsId,
                is_bind = IsBind,
                num = Num
            } = _Data,
            case goods_lib_log:add_goods(PlayerState, GoodsId, IsBind, Num, ?LOG_TYPE_GM) of
                {ok, PlayerState1} ->
                    NPS = PlayerState1,
                    Result = 0;
                {fail, Reply} ->
                    ?DEBUG("cmd 14004 fail:~p~n", [Reply]),
                    NPS = PlayerState,
                    Result = 1
            end,
            net_send:send_to_client(NPS#player_state.socket, 14003, #rep_add_goods{result = Result}),
            {ok, NPS};
        _ ->
            {ok, PlayerState}
    end;


%% 按品质出售装备
handle(14004, PlayerState, #req_batch_sell_equips{quality = Quality}) ->
    case goods_lib:sell_equips_by_quality(PlayerState, Quality) of
        {ok, NewState, SellCoin, SuccList} ->
            net_send:send_to_client(PlayerState#player_state.socket, 14004, #rep_batch_sell_equips{result = ?ERR_COMMON_SUCCESS,
                get_coin = SellCoin,
                goods_list = SuccList}),
            {ok, NewState};
        {fail, Reply} ->
            ?DEBUG("cmd 14004 fail:~p~n", [Reply]),
            net_send:send_to_client(PlayerState#player_state.socket, 14004, #rep_batch_sell_equips{result = ?ERR_COMMON_FAIL})
    end;

%% 出售道具列表（根据唯一id）
handle(14005, PlayerState, #req_sell_goods_list_by_id{goods_list = GoodsIdList}) ->
    case goods_lib:sell_goods_list_by_id(PlayerState, GoodsIdList) of
        {ok, NewState, SellCoin, SuccList, Reply} ->
            net_send:send_to_client(PlayerState#player_state.socket, 14005, #rep_sell_goods_list_by_id{result = Reply,
                get_coin = SellCoin,
                goods_list = SuccList}),
            {ok, NewState};
        {fail, Reply} ->
            ?DEBUG("cmd 14005 fail:~p~n", [Reply]),
            net_send:send_to_client(PlayerState#player_state.socket, 14005, #rep_sell_goods_list_by_id{result = ?ERR_COMMON_FAIL})
    end;

%% 出售指定数量的道具（根据唯一id）
handle(14006, PlayerState, #req_sell_goods_by_num{id = Id, num = Num}) ->
    case goods_lib:sell_goods_by_id_and_num(PlayerState, Id, Num) of
        {ok, NewState} ->
            net_send:send_to_client(PlayerState#player_state.socket, 14006, #rep_sell_goods_by_num{result = ?ERR_COMMON_SUCCESS}),
            {ok, NewState};
        {fail, Reply} ->
            ?DEBUG("cmd 14006 fail:~p~n", [Reply]),
            net_send:send_to_client(PlayerState#player_state.socket, 14006, #rep_sell_goods_by_num{result = Reply})
    end;

%% 使用道具
handle(14007, PlayerState, #req_use_goods{goods_id = GoodsId, num = Num}) ->
    case goods_lib:use_goods(PlayerState, GoodsId, Num) of
        {ok, NewState} ->
            net_send:send_to_client(NewState#player_state.socket, 14007, #rep_use_goods{result = ?ERR_COMMON_SUCCESS}),
            {ok, NewState};
        {fail, Reply} ->
            ?DEBUG("cmd 14007 fail:~p~n", [Reply]),
            net_send:send_to_client(PlayerState#player_state.socket, 14007, #rep_use_goods{result = Reply})
    end;

%% 扩展背包
handle(14008, PlayerState, _Data) ->
    ?INFO("14008", [11]),
    case goods_lib:expend_bag(PlayerState) of
        {ok, PlayerState1} ->
            ?INFO("14008", [22]),
            net_send:send_to_client(PlayerState1#player_state.socket, 14008, #rep_expand_bag{result = ?ERR_COMMON_SUCCESS}),
            {ok, PlayerState1};
        {fail, Reply} ->
            ?DEBUG("cmd 14008 fail:~p~n", [Reply]),
            net_send:send_to_client(PlayerState#player_state.socket, 14008, #rep_expand_bag{result = Reply})
    end;

%% 获取礼包道具列表
handle(14009, PlayerState, #req_bag_reward{goods_id = GoodsId}) ->
    GoodsList = goods_util:get_bag_goods_list(PlayerState, GoodsId),
    goods_lib:broadcast_goods_reward(PlayerState, GoodsList);

%% 获取血包参数
handle(14010, PlayerState, _Data) ->
    DbBase = PlayerState#player_state.db_player_base,
    Value = DbBase#db_player_base.blood_bag,
    net_send:send_to_client(PlayerState#player_state.socket, 14010, #rep_get_blood_bag{value = Value});

%% 获取玩家装备信息列表
handle(14020, PlayerState, _Data) ->
    EquipsList = goods_lib:get_equips_info_list(),
    net_send:send_to_client(PlayerState#player_state.socket, 14020, #rep_equips_list{equips_list = EquipsList});

%% 装备穿戴
handle(14022, PlayerState, #req_change_equips{id = Id, goods_id = GoodsId, grid = Grid}) ->
%%     io:format("player id:~p~n", [PlayerState#player_state.player_id]),
    case equips_lib:change_equips(PlayerState, Id, GoodsId, Grid) of
        {ok, PlayerState1} ->
            net_send:send_to_client(PlayerState#player_state.socket, 14022, #rep_change_equips{result = ?ERR_COMMON_SUCCESS}),
            %% 强化开服活动
            active_service_lib:ref_button_tips(PlayerState1, ?ACTIVE_SERVICE_TYPE_STREN);%%
        {fail, Reply} ->
            ?DEBUG("cmd 14022 fail:~p~n", [Reply]),
            net_send:send_to_client(PlayerState#player_state.socket, 14022, #rep_change_equips{result = Reply})
    end;

%% 装备拆卸
handle(14023, PlayerState, #req_get_off_equips{grid = Grid}) ->
    case equips_lib:unload_equips(PlayerState, Grid) of
        {ok, PlayerState1} ->
            net_send:send_to_client(PlayerState#player_state.socket, 14023, #rep_get_off_equips{result = ?ERR_COMMON_SUCCESS}),
            %% 强化开服活动
            active_service_lib:ref_button_tips(PlayerState1, ?ACTIVE_SERVICE_TYPE_STREN);%%
        {fail, Reply} ->
            ?DEBUG("cmd 14023 fail:~p~n", [Reply]),
            net_send:send_to_client(PlayerState#player_state.socket, 14023, #rep_get_off_equips{result = Reply})
    end;

%% 装备强化
handle(14024, PlayerState, #req_equips_upgrade{id = Id, goods_list = GoodsList}) ->
  case equips_lib:upgrade_equips(PlayerState, Id, GoodsList) of
    {ok, PlayerState1, Reply, IsRefBut} ->
      net_send:send_to_client(PlayerState1#player_state.socket, 14024, #rep_equips_upgrade{result = Reply}),
      %% 日常任务添加
      task_comply:update_player_task_info(PlayerState1, ?TASKSORT_STREN, 1),
      case IsRefBut of
        true ->
          %% 强化开服活动
          active_service_lib:ref_button_tips(PlayerState1, ?ACTIVE_SERVICE_TYPE_STREN);%%
        _ ->
          {ok, PlayerState1}
      end;
    {fail, Reply} ->
      ?DEBUG("cmd 14024 fail:~p~n", [Reply]),
      net_send:send_to_client(PlayerState#player_state.socket, 14024, #rep_equips_upgrade{result = Reply})
  end;

%% 装备洗练
handle(14026, PlayerState, #req_equips_baptize{id = Id}) ->
    case equips_baptize:baptize_equips(PlayerState, Id) of
        {ok, PlayerState1, AttrList} ->
            net_send:send_to_client(PlayerState1#player_state.socket, 14026, #rep_equips_baptize{result = ?ERR_COMMON_SUCCESS,
                attr_list = AttrList}),
            %% 日常任务添加
            task_comply:update_player_task_info(PlayerState1, ?TASKSORT_BAPTIZE, 1);
        {fail, Reply} ->
            net_send:send_to_client(PlayerState#player_state.socket, 14026, #rep_equips_baptize{result = Reply})
    end;

%% 装备洗练保存
handle(14027, PlayerState, #req_equips_baptize_save{id = Id}) ->
    case equips_baptize:baptize_equips_save(PlayerState, Id) of
        {ok, PlayerState1} ->
            net_send:send_to_client(PlayerState1#player_state.socket, 14027, #rep_equips_baptize_save{result = ?ERR_COMMON_SUCCESS}),
            {ok, PlayerState1};
        {fail, Reply} ->
            net_send:send_to_client(PlayerState#player_state.socket, 14027, #rep_equips_baptize_save{result = Reply})
    end;

%% 请求锻造信息
handle(14028, PlayerState, _Data) ->
    PlayerId = PlayerState#player_state.player_id,
    {ForgeId, PlayerState1} = equips_forge:get_forge_equips_id(PlayerState),
    {StarLv, GoodsId} = equips_forge:forge_id_transformation(ForgeId),
    CounterLimit = counter_lib:get_limit(?EQUIPS_FORGE_UPDATE_TIMES_COUNTER),
    CounterNum = counter_lib:get_value(PlayerId, ?EQUIPS_FORGE_UPDATE_TIMES_COUNTER),

    GoodsConf = goods_lib:get_goods_conf_by_id(GoodsId),
    GoodsLv = GoodsConf#goods_conf.limit_lvl,
    MaxLv = equips_lib:get_equips_range_max_lv(GoodsLv),
    Quality = GoodsConf#goods_conf.quality,
    ConsumeConf = forge_consume_config:get({StarLv, MaxLv, Quality}),
    UseSmelt = ConsumeConf#forge_consume_conf.use_smelt,

    RepData = #rep_equips_forge_id{goods_id = GoodsId,
        star = StarLv,
        forge_num = CounterLimit - CounterNum,
        smelt = UseSmelt},
    net_send:send_to_client(PlayerState#player_state.socket, 14028, RepData),

    {ok, PlayerState1};

%% 锻造装备
handle(14029, PlayerState, _Data) ->
    ?INFO("1111 ~p", [14029]),
    case equips_forge:forge_equips(PlayerState) of
        {ok, PlayerState1} ->
            net_send:send_to_client(PlayerState1#player_state.socket, 14029, #rep_equips_forge{result = ?ERR_COMMON_SUCCESS}),
            %% 日常任务添加
            task_comply:update_player_task_info(PlayerState1, ?TASKSORT_FORGE, 1);
        {fail, Reply} ->
            net_send:send_to_client(PlayerState#player_state.socket, 14029, #rep_equips_forge{result = Reply})
    end;

%% 刷新锻造装备
handle(14030, PlayerState, #req_update_forge_info{type = Type}) ->
    case equips_forge:update_forge_equips_id(PlayerState, Type) of
        {ok, PlayerState1} ->
            net_send:send_to_client(PlayerState1#player_state.socket, 14030, #rep_update_forge_info{result = ?ERR_COMMON_SUCCESS}),
            {ok, PlayerState1};
        {fail, Reply} ->
            net_send:send_to_client(PlayerState#player_state.socket, 14030, #rep_update_forge_info{result = Reply})
    end;

%% 道具合成
handle(14031, PlayerState, #req_goods_fusion{formula_id = Id}) ->
    case goods_fusin:fusion_goods(PlayerState, Id) of
        {ok, PlayerState1} ->
            net_send:send_to_client(PlayerState1#player_state.socket, 14031, #rep_goods_fusion{result = ?ERR_COMMON_SUCCESS}),
            {ok, PlayerState1};
        {fail, Reply} ->
            net_send:send_to_client(PlayerState#player_state.socket, 14031, #rep_goods_fusion{result = Reply})
    end;

%% 神器吞噬
handle(14032, PlayerState, #req_art_devour{id = Id, devour_list = IdList}) ->
    case equips_artifact:devour_artifact(PlayerState, Id, IdList) of
        {ok, PlayerState1} ->
            net_send:send_to_client(PlayerState1#player_state.socket, 14032, #rep_art_devour{result = ?ERR_COMMON_SUCCESS}),
            {ok, PlayerState1};
        {fail, Reply} ->
            net_send:send_to_client(PlayerState#player_state.socket, 14032, #rep_art_devour{result = Reply})
    end;

%% 神器传承
handle(14033, PlayerState, #req_art_inherit{idA = IdA, idB = IdB}) ->
    case equips_artifact:inheritance_artifact(PlayerState, IdA, IdB) of
        {ok, PlayerState1} ->
            net_send:send_to_client(PlayerState1#player_state.socket, 14033, #rep_art_inherit{result = ?ERR_COMMON_SUCCESS}),
            {ok, PlayerState1};
        {fail, Reply} ->
            net_send:send_to_client(PlayerState#player_state.socket, 14033, #rep_art_inherit{result = Reply})
    end;

%% 勋章升级
handle(14034, PlayerState, #req_medal_upgrade{id = Id}) ->
    case equips_lib:medal_upgrade(PlayerState, Id) of
        {ok, PlayerState1} ->
            net_send:send_to_client(PlayerState1#player_state.socket, 14034, #rep_medal_upgrade{result = ?ERR_COMMON_SUCCESS}),
            %% 勋章开服活动
            active_service_lib:ref_button_tips(PlayerState1, ?ACTIVE_SERVICE_TYPE_MEDAL);%%
        {fail, Reply} ->
            net_send:send_to_client(PlayerState#player_state.socket, 14034, #rep_medal_upgrade{result = Reply})
    end;

%% 道具合成
handle(14035, PlayerState, #req_goods_fusion_plus{formula_id = Id, num = Num}) ->
    case goods_fusin:fusion_good_plus(PlayerState, Id, Num) of
        {ok, PlayerState1} ->
            net_send:send_to_client(PlayerState1#player_state.socket, 14035, #rep_goods_fusion_plus{result = ?ERR_COMMON_SUCCESS}),
            {ok, PlayerState1};
        {fail, Reply} ->
            net_send:send_to_client(PlayerState#player_state.socket, 14035, #rep_goods_fusion_plus{result = Reply})
    end;

%% 分解选中装备
handle(14037, PlayerState, #req_decompose_equips_by_list{goods_list = GoodsList}) ->
    case equips_lib:decompose_equips_by_id(PlayerState, GoodsList) of
        {ok, PlayerState1} ->
            net_send:send_to_client(PlayerState1#player_state.socket, 14037, #rep_decompose_equips_by_list{
                result = ?ERR_COMMON_SUCCESS, goods_list = GoodsList}),
            {ok, PlayerState1};
        {fail, Reply} ->
            net_send:send_to_client(PlayerState#player_state.socket, 14037, #rep_decompose_equips_by_list{result = Reply})
    end;

%% 分解品质装备
handle(14038, PlayerState, #req_decompose_equips_by_quality{quality_list = QualityList}) ->
    case equips_lib:decompose_equips_by_quality(PlayerState, QualityList) of
        {ok, PlayerState1, GoodsList} ->
            net_send:send_to_client(PlayerState1#player_state.socket, 14038, #rep_decompose_equips_by_quality{
                result = ?ERR_COMMON_SUCCESS, goods_list = GoodsList}),
            {ok, PlayerState1};
        {fail, Reply} ->
            net_send:send_to_client(PlayerState#player_state.socket, 14038, #rep_decompose_equips_by_quality{result = Reply})
    end;

%% 请求仓库道具信息列表
handle(14040, PlayerState, _Data) ->
    GoodsList = goods_store:get_store_info_list(),
    net_send:send_to_client(PlayerState#player_state.socket, 14040, #rep_store_list{
        store_cell = goods_store:get_store_cell(PlayerState), goods_list = GoodsList});

%% 道具存入仓库
handle(14042, PlayerState, #req_bag_to_store{id = Id, goods_id = GoodsId, num = Num}) ->
    case goods_store:move_goods_to_store(PlayerState, Id, GoodsId, Num) of
        {ok, PlayerState1} ->
            net_send:send_to_client(PlayerState1#player_state.socket, 14042, #rep_bag_to_store{result = ?ERR_COMMON_SUCCESS}),
            {ok, PlayerState1};
        {fail, Reply} ->
            net_send:send_to_client(PlayerState#player_state.socket, 14042, #rep_bag_to_store{result = Reply})
    end;

%% 仓库取出道具
handle(14043, PlayerState, #req_store_to_bag{id = Id, goods_id = GoodsId, num = Num}) ->
    case goods_store:move_goods_to_bag(PlayerState, Id, GoodsId, Num) of
        {ok, PlayerState1} ->
            net_send:send_to_client(PlayerState1#player_state.socket, 14043, #rep_store_to_bag{result = ?ERR_COMMON_SUCCESS}),
            {ok, PlayerState1};
        {fail, Reply} ->
            net_send:send_to_client(PlayerState#player_state.socket, 14043, #rep_store_to_bag{result = Reply})
    end;

%% 翅膀升级
handle(14044, PlayerState, #req_wing_upgrade{id = Id, type = Type}) ->
    case equips_lib:wing_upgrade(PlayerState, Id, Type) of
        {ok, PlayerState1} ->
            net_send:send_to_client(PlayerState1#player_state.socket, 14044, #rep_wing_upgrade{result = ?ERR_COMMON_SUCCESS}),
            %% 翅膀开服活动
            active_service_lib:ref_button_tips(PlayerState1, ?ACTIVE_SERVICE_TYPE_WING);
        {fail, Reply} ->
            net_send:send_to_client(PlayerState#player_state.socket, 14044, #rep_wing_upgrade{result = Reply})
    end;

%% 强化转移
handle(14045, PlayerState, #req_strengthen_change{idA = IdA, idB = IdB}) ->
    case equips_lib:upgrade_change(PlayerState, IdA, IdB) of
        {ok, PlayerState1} ->
            net_send:send_to_client(PlayerState#player_state.socket, 14045, #rep_strengthen_change{result = ?ERR_COMMON_SUCCESS}),
            {ok, PlayerState1};
        {fail, Reply} ->
            net_send:send_to_client(PlayerState#player_state.socket, 14045, #rep_strengthen_change{result = Reply})
    end;

%% 铸魂
handle(14046, PlayerState, #req_soul_equips{id = Id}) ->
    case equips_lib:soul_equips(PlayerState, Id) of
        {ok, PlayerState1} ->
            net_send:send_to_client(PlayerState1#player_state.socket, 14046, #rep_soul_equips{result = ?ERR_COMMON_SUCCESS}),
            {ok, PlayerState1};
        {fail, Reply} ->
            net_send:send_to_client(PlayerState#player_state.socket, 14046, #rep_soul_equips{result = Reply})
    end;

%% 洗练锁定
handle(14047, PlayerState, #req_equips_baptize_lock{id = GoodsKey, baptize_id = Id, state = State}) ->
    {_, Reply} = equips_baptize:baptize_lock(PlayerState, GoodsKey, Id, State),
    net_send:send_to_client(PlayerState#player_state.socket, 14047, #rep_equips_baptize_lock{result = Reply});

%% 装备投保
handle(14048, PlayerState, #req_equips_secure{id = Id, count = Count}) ->
    case equips_lib:equips_secure(PlayerState, Id, Count) of
        {ok, PlayerState1} ->
            net_send:send_to_client(PlayerState1#player_state.socket, 14048, #rep_equips_secure{result = ?ERR_COMMON_SUCCESS}),
            {ok, PlayerState1};
        {fail, Reply} ->
            net_send:send_to_client(PlayerState#player_state.socket, 14048, #rep_equips_secure{result = Reply})
    end;

%% 铸魂回收
handle(14049, PlayerState, #req_soul_change{id = Id}) ->
    case equips_lib:equips_soul_back(PlayerState, Id) of
        {ok, PlayerState1} ->
            net_send:send_to_client(PlayerState#player_state.socket, 14049, #rep_soul_change{result = ?ERR_COMMON_SUCCESS}),
            {ok, PlayerState1};
        {fail, Reply} ->
            net_send:send_to_client(PlayerState#player_state.socket, 14049, #rep_soul_change{result = Reply})
    end;

%% 洗练转移
handle(14050, PlayerState, #req_baptiz_change{idA = IdA, idB = IdB}) ->
    case equips_baptize:baptize_change(PlayerState, IdA, IdB) of
        {ok, PlayerState1} ->
            net_send:send_to_client(PlayerState#player_state.socket, 14050, #rep_baptiz_change{result = ?ERR_COMMON_SUCCESS}),
            {ok, PlayerState1};
        {fail, Reply} ->
            net_send:send_to_client(PlayerState#player_state.socket, 14050, #rep_baptiz_change{result = Reply})
    end;

%% 使用藏宝图
handle(14051, PlayerState, #req_goods_map{id = Id}) ->
    case goods_lib:use_goods_map(PlayerState, Id) of
        {ok, PlayerState1, Reply} ->
            net_send:send_to_client(PlayerState#player_state.socket, 14051, #rep_goods_map{result = Reply}),
            {ok, PlayerState1};
        {fail, Reply} ->
            net_send:send_to_client(PlayerState#player_state.socket, 14051, #rep_goods_map{result = Reply})
    end;

%% 坐骑升级
handle(14053, PlayerState, #req_mounts_upgrade{id = Id}) ->
    case equips_lib:mounts_upgrade(PlayerState, Id) of
        {ok, PlayerState1, Reply} ->
            net_send:send_to_client(PlayerState1#player_state.socket, 14053, #rep_mounts_upgrade{result = Reply}),
            {ok, PlayerState1};
        {fail, Reply} ->
            net_send:send_to_client(PlayerState#player_state.socket, 14053, #rep_mounts_upgrade{result = Reply})
    end;

%% 坐骑印记升级
handle(14054, PlayerState, #req_mounts_mark_upgrade{mark_type = MarkType, type = Type}) ->
    case player_mark_lib:upgrade_mounts_mark(PlayerState, MarkType, Type) of
        {ok, PlayerState1, Reply, Bless} ->
            net_send:send_to_client(PlayerState1#player_state.socket, 14054, #rep_mounts_mark_upgrade{result = Reply, mark_type = MarkType, bless = Bless}),
            {ok, PlayerState1};
        _ ->
            skip
    end;

%% 获取坐骑印记祝福值
handle(14055, PlayerState, #req_get_mounts_mark_bless{mark_type = MarkType}) ->
    PlayerId = PlayerState#player_state.player_id,
    DPMark = PlayerState#player_state.db_player_mark,
    MarkLv = player_mark_lib:get_mark_lv_by_type(DPMark, MarkType),
    Bless = player_mark_lib:get_player_mounts_mark_bless(PlayerId, MarkType, MarkLv),
    net_send:send_to_client(PlayerState#player_state.socket, 14055, #rep_get_mounts_mark_bless{bless = Bless, mark_type = MarkType});

handle(Cmd, PlayerState, Data) ->
    ?ERR("not define ~p cmd:~nstate: ~p~ndata: ~p", [Cmd, PlayerState, Data]),
    {ok, PlayerState}.
%% ====================================================================
%% Internal functions
%% ====================================================================
