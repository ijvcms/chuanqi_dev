%%%-------------------------------------------------------------------
%%% @author tuhujia
%%% @copyright (C) 2015, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 03. 十一月 2015 14:46
%%%-------------------------------------------------------------------
-module(guild_pp).

-include("common.hrl").
-include("record.hrl").
-include("proto.hrl").
-include("cache.hrl").
-include("config.hrl").
-include("language_config.hrl").
-include("button_tips_config.hrl").

%% API
-export([
    handle/3
]).

%% ====================================================================
%% API functions
%% ====================================================================

%% 创建帮派
handle(17001, PlayerState, #req_create_guild{guild_name = GuildName, is_jade = IsJade}) ->
    ?ERR("~p", [GuildName]),
    %%yu_test:test(PlayerState, legion_pp, 37001, #req_create_legion{legion_name = GuildName, is_jade = IsJade}),
    case guild_lib:create_guild(PlayerState, GuildName, IsJade) of
        {ok, PlayerState1} ->
            net_send:send_to_client(PlayerState#player_state.socket, 17001, #rep_create_guild{result = ?ERR_COMMON_SUCCESS}),
            {ok, PlayerState1};
        {fail, Reply} ->
            {Reply2, NeedJad2} = case Reply of
                                     {Reply1, NeedJade1} ->
                                         {Reply1, NeedJade1};
                                     _ ->
                                         {Reply, 0}
                                 end,
            net_send:send_to_client(PlayerState#player_state.socket, 17001, #rep_create_guild{result = Reply2, need_jade = NeedJad2})
    end;

%% 获取加入帮派条件
handle(17002, PlayerState, #req_enter_guild_cond{guild_id = GuildId}) ->
    case guild_lib:get_guild_fight_limit(GuildId) of
        {ok, Fight} ->
            net_send:send_to_client(PlayerState#player_state.socket, 17002, #rep_enter_guild_cond{result = ?ERR_COMMON_SUCCESS,
                fight = Fight});
        {fail, Reply} ->
            net_send:send_to_client(PlayerState#player_state.socket, 17002, #rep_enter_guild_cond{result = Reply})
    end;

%% 设置加入帮派条件
handle(17003, PlayerState, #req_set_guild_cond{fight = Fight}) ->
    {_, Reply} = guild_lib:set_guild_fight_limit(PlayerState, Fight),
    net_send:send_to_client(PlayerState#player_state.socket, 17003, #rep_set_guild_cond{result = Reply, fight = Fight});

%% 获取帮派总数
handle(17004, PlayerState, _Data) ->
    GuildNum = guild_lib:get_guild_total_num(),
    net_send:send_to_client(PlayerState#player_state.socket, 17004, #rep_get_guild_num{guild_num = GuildNum});

%% 获取帮派信息列表
handle(17005, PlayerState, #req_get_guild_list{min_value = MinValue, max_value = MaxValue}) ->
    ProtoList = guild_lib:get_proto_guild_info_list(MinValue, MaxValue),
    net_send:send_to_client(PlayerState#player_state.socket, 17005, #rep_get_guild_list{guild_info = ProtoList});

%% 申请加入帮派
handle(17006, PlayerState, #req_apply_enter_guild{guild_id = GuildId}) ->
    {_, Reply} = guild_lib:apply_guild(PlayerState, GuildId),
    button_tips_lib:send_button_tips(PlayerState, ?BTN_GUILD_APPLY, 0),
    net_send:send_to_client(PlayerState#player_state.socket, 17006, #rep_apply_enter_guild{result = Reply});

%% 获取申请列表数量
handle(17007, PlayerState, _Data) ->
    Num = guild_lib:get_apply_guild_list_lengh(PlayerState),
    net_send:send_to_client(PlayerState#player_state.socket, 17007, #rep_apply_guild_num{num = Num});

%% 获取申请列表信息
handle(17008, PlayerState, #req_apply_guild_info{min_value = MinValue, max_value = MaxValue}) ->
    ProtoList = guild_lib:get_apply_guild_list(PlayerState, MinValue, MaxValue),
    net_send:send_to_client(PlayerState#player_state.socket, 17008, #rep_apply_guild_info{apply_guild_info = ProtoList, max_value = MaxValue, min_value = MinValue});

%% 同意玩家加入帮派
handle(17009, PlayerState, #req_agree_join_guild{player_id = ApplyId, type = Type}) ->
    {_, Reply} =
        case Type of
            1 ->    %% 同意
                guild_lib:agree_join_guild(PlayerState, ApplyId);
            2 ->    %% 拒绝
                guild_lib:refuse_join_guild(PlayerState, ApplyId)
        end,
    net_send:send_to_client(PlayerState#player_state.socket, 17009, #rep_agree_join_guild{result = Reply, player_id = ApplyId, type = Type});

%% 获取帮派详细信息
handle(17010, PlayerState, _Data) ->
    Proto = guild_lib:get_proto_guild_detailed_info(PlayerState),
    net_send:send_to_client(PlayerState#player_state.socket, 17010, #rep_guild_detailed_info{guild_detailed_info = Proto});

%% 获取玩家帮派信息
handle(17011, PlayerState, _Data) ->
    Proto = guild_lib:get_proto_player_guild_info(PlayerState),
    net_send:send_to_client(PlayerState#player_state.socket, 17011, #rep_get_guild_member_info{player_guild_info = Proto});

%% 获取帮派成员信息列表
handle(17012, PlayerState, #req_guild_member_info_list{min_value = Min, max_value = Max}) ->
    Proto = guild_lib:get_proto_guild_member_list(PlayerState, Min, Max),
    net_send:send_to_client(PlayerState#player_state.socket, 17012, #rep_guild_member_info_list{guild_member_info_list = Proto, min_value = Min, max_value = Max});

%% 退出帮派
handle(17013, PlayerState, _Data) ->
    case guild_lib:leave_guild(PlayerState) of
        {ok, PlayerState1} ->
            net_send:send_to_client(PlayerState#player_state.socket, 17013, #rep_leave_guild{result = ?ERR_COMMON_SUCCESS}),
            {ok, PlayerState1};
        {fail, Reply} ->
            net_send:send_to_client(PlayerState#player_state.socket, 17013, #rep_leave_guild{result = Reply})
    end;

%% 获取帮派成员数量
handle(17015, PlayerState, _Data) ->
    Num = guild_lib:get_guild_member_num(PlayerState),
    net_send:send_to_client(PlayerState#player_state.socket, 17015, #rep_get_guild_member_num{num = Num});

%% 设置行会公告
handle(17016, PlayerState, #req_write_announce{content = Content}) ->
    {_, Reply} = guild_lib:set_guild_announce(PlayerState, Content),
    net_send:send_to_client(PlayerState#player_state.socket, 17016, #rep_write_announce{result = Reply});

%%  剔除成员
handle(17018, PlayerState, #req_reject_member{player_id = PlayerId}) ->
    {_, Reply} = guild_lib:remove_guild_member(PlayerState, PlayerId),
    net_send:send_to_client(PlayerState#player_state.socket, 17018, #rep_reject_member{result = Reply});

%% 委任职位
handle(17019, PlayerState, #req_appoint_member{position = Position, player_id = PlayerId}) ->
    {_, Reply} = case Position of
                     ?HUIZHANG ->
                         guild_lib:set_huizhang(PlayerState, PlayerId);
                     _ ->
                         guild_lib:set_guild_position(PlayerState, PlayerId, Position)
                 end,
    net_send:send_to_client(PlayerState#player_state.socket, 17019, #rep_appoint_member{result = Reply, player_id = PlayerId, position = Position});

%% 清空申请列表
handle(17020, PlayerState, _Data) ->
    {_, Reply} = guild_lib:clear_apply_lists(PlayerState),
    net_send:send_to_client(PlayerState#player_state.socket, 17020, #rep_clear_apply_list{result = Reply});

%% 玩家捐献
handle(17050, PlayerState, #req_guild_donation{type = Type}) ->
    case guild_contribution:playe_donate(PlayerState, Type) of
        {ok, PlayerState1} ->
            net_send:send_to_client(PlayerState#player_state.socket, 17050, #rep_guild_donation{result = ?ERR_COMMON_SUCCESS}),
            {ok, PlayerState1};
        {fail, Reply} ->
            net_send:send_to_client(PlayerState#player_state.socket, 17050, #rep_guild_donation{result = Reply})
    end;

%% 玩家帮派商店兑换
handle(17051, PlayerState, #req_guild_shop{shop_id = ShopId, num = Num}) ->
    case guild_shop:exchange_guild_shop(PlayerState, ShopId, Num) of
        {ok, PlayerState1} ->
            net_send:send_to_client(PlayerState#player_state.socket, 17051, #rep_guild_shop{result = ?ERR_COMMON_SUCCESS}),
            {ok, PlayerState1};
        {fail, Reply} ->
            net_send:send_to_client(PlayerState#player_state.socket, 17051, #rep_guild_shop{result = Reply})
    end;

%% 获取玩家捐献信息
handle(17052, PlayerState, _Data) ->
    Proto = guild_contribution:get_player_donate_info(PlayerState#player_state.player_id),
    net_send:send_to_client(PlayerState#player_state.socket, 17052, #rep_guild_donation_info{donation_info = Proto});

%% 获取行会日志信息
handle(17053, PlayerState, _Data) ->
    DbBase = PlayerState#player_state.db_player_base,
    GuildId = DbBase#db_player_base.guild_id,
    Proto = guild_lib:get_proto_guild_log(GuildId),
    net_send:send_to_client(PlayerState#player_state.socket, 17053, #rep_guild_log_info{guild_log_info = Proto});

%% 发送行会邀请
handle(17054, PlayerState, Data) ->
    TPlayerId = Data#req_guild_ask.tplayer_id,
    Result = guild_lib:send_guild_ask(PlayerState, TPlayerId),
    net_send:send_to_client(PlayerState#player_state.socket, 17054, #rep_guild_ask{result = Result});

%% 同意会长的邀请
handle(17056, PlayerState, Data) ->
    GuildId = Data#req_guild_agree_ask.guild_id,
    Result = guild_lib:agree_guild_ask(PlayerState, GuildId),
    net_send:send_to_client(PlayerState#player_state.socket, 17056, #rep_guild_agree_ask{result = Result});

%% 进入行会秘境
handle(17057, PlayerState, _Data) ->
    case guild_active:challenge_guild_active(PlayerState, ?ACTIVE_GUILD_FEM) of
        {ok, PlayerState1} ->
            net_send:send_to_client(PlayerState#player_state.socket, 17057, #rep_enter_guild_fam{result = ?ERR_COMMON_SUCCESS}),
            {ok, PlayerState1};
        {fail, Reply} ->
            net_send:send_to_client(PlayerState#player_state.socket, 17057, #rep_enter_guild_fam{result = Reply})
    end;

%% 开启沙巴克秘境
handle(17058, PlayerState, _Data) ->
    case guild_active:open_sbk_fem(PlayerState) of
        {ok, _} ->
            net_send:send_to_client(PlayerState#player_state.socket, 17058, #rep_open_sbk_fam{result = ?ERR_COMMON_SUCCESS});
        {fail, Reply} ->
            net_send:send_to_client(PlayerState#player_state.socket, 17058, #rep_open_sbk_fam{result = Reply})
    end;

%% 进入沙巴克秘境
handle(17059, PlayerState, _Data) ->
    case guild_active:enter_sbk_fem(PlayerState) of
        {ok, PlayerState1} ->
            net_send:send_to_client(PlayerState#player_state.socket, 17059, #rep_enter_sbk_fam{result = ?ERR_COMMON_SUCCESS}),
            {ok, PlayerState1};
        {fail, Reply} ->
            net_send:send_to_client(PlayerState#player_state.socket, 17059, #rep_enter_sbk_fam{result = Reply})
    end;

%% 挑战公会boss
handle(17060, PlayerState, #req_challenge_guild_active{id = Id}) ->
    case guild_active:challenge_guild_active(PlayerState, Id) of
        {ok, PlayerState1} ->
            %% 任务检测
            task_comply:update_player_task_info(PlayerState1, ?TASKSORT_GUILD_FB, 1),
            net_send:send_to_client(PlayerState#player_state.socket, 17060, #rep_challenge_guild_active{result = ?ERR_COMMON_SUCCESS}),
            {ok, PlayerState1};
        {fail, Reply} ->
            net_send:send_to_client(PlayerState#player_state.socket, 17060, #rep_challenge_guild_active{result = Reply})
    end;

%% 获取行会秘境信息
handle(17061, PlayerState, _Data) ->
    Proto = guild_active:get_guild_fam_info(),
    net_send:send_to_client(PlayerState#player_state.socket, 17061, Proto);

%% 获取沙巴克秘境信息
handle(17062, PlayerState, _Data) ->
    Proto = guild_active:get_sbk_fam_info(),
    net_send:send_to_client(PlayerState#player_state.socket, 17062, Proto);

%%*******************************************工会红包信息
%% 获取工会红包信息
handle(17063, PlayerState, _Data) ->
    Base = PlayerState#player_state.db_player_base,
    RedList = red_guild_lib:get_guild_red_info_list(Base#db_player_base.guild_id, PlayerState#player_state.player_id, 0),
    RedLogList = red_guild_lib:get_guild_red_log_list(Base#db_player_base.guild_id, 0),
    net_send:send_to_client(PlayerState#player_state.socket, 17063, #rep_get_guild_red_list{red_list = RedList, red_log_list = RedLogList}),
    {ok, PlayerState#player_state{is_guild_red = true}};

%% 获取下一页的红包信息
handle(17064, PlayerState, Data) ->
    Base = PlayerState#player_state.db_player_base,
    RedId = Data#req_get_guild_red_info_page.last_red_id,
    RedList = red_guild_lib:get_guild_red_info_list(Base#db_player_base.guild_id, PlayerState#player_state.player_id, RedId),
    net_send:send_to_client(PlayerState#player_state.socket, 17064, #rep_get_guild_red_info_page{red_list = RedList});

%% 获取下一页的红包日志信息
handle(17065, PlayerState, Data) ->
    Base = PlayerState#player_state.db_player_base,
    Id = Data#req_get_guild_red_log_page.last_id,
    RedLogList = red_guild_lib:get_guild_red_log_list(Base#db_player_base.guild_id, Id),
    net_send:send_to_client(PlayerState#player_state.socket, 17065, #rep_get_guild_red_log_page{red_log_list = RedLogList});

%% 离开工会红包
handle(17069, PlayerState, _Data) ->
    {ok, PlayerState#player_state{is_guild_red = false}};

%% 工会领取红包
handle(17070, PlayerState, Data) ->
    RedId = Data#req_receive_red_guild.red_id,
    ?INFO("17070 ~p", [Data]),
    case red_guild_lib:receive_red_guild(PlayerState, RedId) of
        {fail, Err} ->
            net_send:send_to_client(PlayerState#player_state.socket, 17070, #rep_receive_red_guild{result = Err, red_id = RedId});
        {ok, PlayerState1, Jade} ->
            net_send:send_to_client(PlayerState#player_state.socket, 17070, #rep_receive_red_guild{result = 0, red_id = RedId, jade = Jade}),
            {ok, PlayerState1};
        DD ->
            ?INFO("17070 111 ~p", [DD])
    end;
%% 工会发送红包
handle(17071, PlayerState, Data) ->

    #req_send_red_guild{jade = Jade, num = Num, type = RedType, des = Des} = Data,
    ?INFO("17071 ~p", [Data]),
    case red_guild_lib:send_red_guild(PlayerState, Jade, Num, Des, RedType) of
        {fail, Err} ->
            net_send:send_to_client(PlayerState#player_state.socket, 17071, #rep_send_red_guild{result = Err});
        {ok, PlayerState1} ->
            net_send:send_to_client(PlayerState#player_state.socket, 17071, #rep_send_red_guild{result = 0}),
            {ok, PlayerState1}
    end;

handle(17080, PlayerState, Data) ->
    #req_guild_challenge_apply{guild_id_b = GuildIdB} = Data,
    guild_challenge_lib:apply(PlayerState, GuildIdB);

handle(17082, PlayerState, Data) ->
    #req_guild_challenge_answer{guild_id_a = GuildIdA, type = Type} = Data,
    guild_challenge_lib:answer(PlayerState, GuildIdA, Type);

handle(17084, PlayerState, _) ->
    guild_challenge_lib:info(PlayerState);

%%行会结盟请求
handle(17085, PlayerState, Data) ->
    #req_guild_alliance_apply{server_id_b = ServerIdB, guild_id_b = GuildIdB, player_id_b = PlayerIdB} = Data,
    alliance_lib:apply(PlayerState, ServerIdB, GuildIdB, PlayerIdB);

%%响应行会结盟请求
handle(17087, PlayerState, Data) ->
    #req_guild_alliance_answer{server_id_a = ServerIdA, guild_id_a = GuildIdA, player_id_a = PlayerIdA,
        type = Type} = Data,
    alliance_lib:answer(PlayerState, ServerIdA, GuildIdA, PlayerIdA, Type);

%%退出行会结盟
handle(17089, PlayerState, _Data) ->
    alliance_lib:exit(PlayerState);

%%踢出行会结盟
handle(17090, PlayerState, Data) ->
    #req_guild_alliance_kick{server_id_b = ServerIdB, guild_id_b = GuildIdB} = Data,
    alliance_lib:kick(PlayerState, ServerIdB, GuildIdB);

%%行会结盟信息
handle(17093, PlayerState, _Data) ->
    alliance_lib:guild_info(PlayerState);

%%跨服帮会信息
handle(17094, PlayerState, Data) ->
    #req_guild_alliance_guild{guild_id = Guild} = Data,
    alliance_lib:guild_info(PlayerState, Guild);


handle(Cmd, PlayerState, Data) ->
    ?ERR("not define ~p cmd:~nstate: ~p~ndata: ~p", [Cmd, PlayerState, Data]),
    {ok, PlayerState}.
