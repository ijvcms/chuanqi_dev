%%%-------------------------------------------------------------------
%%% @author yubing
%%% @copyright (C) 2016, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 10. 五月 2016 14:17
%%%-------------------------------------------------------------------
-module(red_lib).


-include("common.hrl").
-include("record.hrl").
-include("cache.hrl").
-include("config.hrl").
-include("proto.hrl").
-include("uid.hrl").
-include("language_config.hrl").
-include("gameconfig_config.hrl").
-include("button_tips_config.hrl").
-include("log_type_config.hrl").
-include("notice_config.hrl").

-define(NEED_RMB, 10).
-define(RED_CHARGE, 18).%% 玩家充值红包
-define(RED_HOUR, 19).%% 系统红包
-define(RED_BOSS, 20).%% BOSS击杀红包
-define(HOUR, 1000).%% 间隔时间
-define(RED_LIMIT_LV, 35).%%等级限制


-export([
    init/1,
    receive_red/2,
    send_red_boss/1,
    send_red_charge/3,
    get_red_info/3
]).

-export([
    on_timer/1,
    do_add_red_record/2,
    do_send_red_info/3,
    do_is_red_record/3
]).

init(RedState) ->
    {BeginTime, EndTime, _, _} = active_service_lib:get_active_time(?ACTIVE_SERVICE_TYPE_RED),
    NewRedState = RedState#red_state{
        end_time = EndTime,
        begin_time = BeginTime,
        send_time = util_date:unixtime()
    },
    gen_server2:apply_after(?HOUR, self(), {?MODULE, on_timer, []}),
    {ok, NewRedState}.

on_timer(RedState) ->
    CurTime = util_date:unixtime(),
    case RedState#red_state.end_time < CurTime of
        true ->
            {ok, RedState};
        _ ->
            %% 获取服务器erlang的当前时间
            {{_, _, _}, {CurH, CurM, _CurS}} = calendar:local_time(),
            {ok, NewRedState} = if
                                    CurM =:= 0 andalso RedState#red_state.send_time < CurTime ->
                                        %% 查询会发送红包的时间段
                                        ActiveServiceConf = active_service_config:get(?RED_HOUR),
                                        case lists:member(CurH, ActiveServiceConf#active_service_conf.value) of
                                            true ->
                                                %% 记录发送时间
                                                RedState1 = RedState#red_state{
                                                    send_time = CurTime + 60
                                                },
                                                %% 添加发送的小时时间
                                                send_red_const(RedState1, ActiveServiceConf);
                                            _ ->
                                                {ok, RedState}
                                        end;
                                    true ->
                                        {ok, RedState}
                                end,
            gen_server2:apply_after(?HOUR, self(), {?MODULE, on_timer, []}),
            {ok, NewRedState}
    end.

%% 充值发送红包
send_red_charge(PlayerId, Rmd, IsBack) ->
    case is_active_open() of
        true ->
            RedNum = Rmd div ?NEED_RMB,
            case RedNum > 0 of
                true ->
                    %% 开服活动信息
                    ActiveServiceConf = active_service_config:get(?RED_CHARGE),
                    %% 获取充值玩家名称
                    EtsName = player_id_name_lib:get_ets_player_id_name_by_playerid(PlayerId),
                    PlayerName = EtsName#ets_player_id_name.name,
                    NoticeInfo = io_lib:format(ActiveServiceConf#active_service_conf.info, [util_data:to_list(PlayerName)]),

                    RedInfo = get_red_info(0, ActiveServiceConf, RedNum),
                    RedInfo1 = case IsBack of
                                   true ->
                                       RedInfo#db_red_record{
                                           loss_num = RedInfo#db_red_record.num
                                       };
                                   _ ->
                                       RedInfo
                               end,
                    case gen_server2:apply_sync(misc:whereis_name({local, red_mod}), {?MODULE, do_add_red_record, [RedInfo1]}) of
                        {ok, _} ->
                            send_red_info(RedInfo1, NoticeInfo);
                        _ ->
                            skip
                    end;
                _ ->
                    skip
            end;
        _ ->
            skip
    end.

%% 固定时间发送红包
send_red_const(RedState, ActiveServiceConf) ->
    RedInfo = get_red_info(0, ActiveServiceConf, 0),
    {ok, _, NewRedState} = do_add_red_record(RedState, RedInfo),

    gen_server2:apply_after(1000, self(), {?MODULE, do_send_red_info, [RedInfo, ActiveServiceConf#active_service_conf.info]}),
    {ok, NewRedState}.

%% 击杀boss发送红包
send_red_boss(Name) ->
    try
        case is_active_open() of
            true ->
                ActiveServiceConf = active_service_config:get(?RED_BOSS),
                NoticeInfo = io_lib:format(ActiveServiceConf#active_service_conf.info, [Name]),
                RedInfo = get_red_info(0, ActiveServiceConf, 0),
                case gen_server2:apply_sync(misc:whereis_name({local, red_mod}), {?MODULE, do_add_red_record, [RedInfo]}) of
                    {ok, _} ->
                        send_red_info(RedInfo, NoticeInfo);
                    _ ->
                        skip
                end;
            _ ->
                skip
        end
    catch
        ERR:Info ->
            ?ERR(" 11 ~p ~p ", [ERR, Info, erlang:get_stacktrace()])
    end.


%% 领取红包
receive_red(PlayerState, RedId) ->
    Base = PlayerState#player_state.db_player_base,
    case Base#db_player_base.lv < ?RED_LIMIT_LV of
        true ->
            {fail, ?ERR_RED4};
        _ ->
            case gen_server2:apply_sync(misc:whereis_name({local, red_mod}), {?MODULE, do_is_red_record, [PlayerState#player_state.player_id, RedId]}) of
                {fail, Err} ->
                    {fail, Err};
                {ok, PlayerRedInfo} ->
                    player_lib:incval_on_player_money_log(PlayerState, #db_player_money.jade, PlayerRedInfo#db_player_red.jade, ?LOG_TYPE_RED_TYPE1)
            end
    end.

%%*******************************************
%%*********************************************************************
%% 添加红包信息
do_add_red_record(RedState, RedInfo) ->
    red_record_cache:insert(RedInfo),
    NewRedRecordList = [RedInfo | RedState#red_state.red_record_list],
    RedState1 = RedState#red_state{
        red_record_list = NewRedRecordList
    },
    {ok, 1, RedState1}.

%% 判断红包信息
do_is_red_record(RedState, PlayerId, RedId) ->
    case lists:keyfind(RedId, #db_red_record.red_id, RedState#red_state.red_record_list) of
        false ->
            {fail, ?ERR_RED1};%% 该红包已经消失了
        RedInfo ->
            ?INFO("RedInfo ~p", [RedInfo]),
            case RedInfo#db_red_record.loss_num >= RedInfo#db_red_record.num of
                true ->
                    {fail, ?ERR_RED2};%% 该红包已经被领取完了
                _ ->
                    Result = case lists:keyfind(RedId, 1, RedState#red_state.red_id_player_id_list) of
                                 false ->
                                     RedState1 = RedState#red_state{
                                         red_id_player_id_list = [{RedId, [PlayerId]}]
                                     },
                                     {ok, RedState1};
                                 {_, PlayerIdList} ->
                                     case lists:member(PlayerId, PlayerIdList) of
                                         true ->
                                             {fail, ?ERR_RED3}; %% 你已经领取过该红包了
                                         _ ->
                                             NewPlayerIdList = [PlayerId | PlayerIdList],
                                             NewRedIdPlayerIdList = lists:keyreplace(RedId, 1, RedState#red_state.red_id_player_id_list, {RedId, NewPlayerIdList}),
                                             RedState1 = RedState#red_state{
                                                 red_id_player_id_list = NewRedIdPlayerIdList
                                             },
                                             {ok, RedState1}
                                     end

                             end,
                    case Result of
                        {fail, Err} ->
                            {fail, Err};%%
                        {ok, NewRedState} ->
                            PlayerRedInfo = #db_player_red{
                                id = uid_lib:get_uid(?UID_TYPE_PLAYER_RED),
                                red_id = RedId,
                                time = util_date:unixtime(),
                                player_id = PlayerId,
                                jade = util_rand:rand(1, RedInfo#db_red_record.max_jade)
                            },
                            player_red_cache:insert(PlayerRedInfo),

                            %% 领取次数
                            RedInfo1 = RedInfo#db_red_record{
                                loss_num = RedInfo#db_red_record.loss_num + 1
                            },
                            NewList = lists:keyreplace(RedInfo#db_red_record.red_id, #db_red_record.red_id, RedState#red_state.red_record_list, RedInfo1),
                            NewRedState1 = NewRedState#red_state{
                                red_record_list = NewList
                            },
                            red_record_cache:update(RedInfo1#db_red_record.red_id, RedInfo1),

                            {ok, PlayerRedInfo, NewRedState1}
                    end
            end
    end.

%% 发送公告以及推送红包信息
send_red_info(RedInfo, NoticeInfo) ->
    notice_lib:send_notice(0, ?NOTICE_BACK, [NoticeInfo]),
    Data = #rep_send_red_info{
        red_id = RedInfo#db_red_record.red_id
    },
    net_send:send_to_world(34001, Data).

do_send_red_info(_State, RedInfo, NoticeInfo) ->
    send_red_info(RedInfo, NoticeInfo).

%% 获取红包信息
get_red_info(GuildId, ActiveServiceConf, Num) ->
    NeedNum = case Num > 0 of
                  true ->
                      Num;
                  _ ->
                      ActiveServiceConf#active_service_conf.num
              end,
    #db_red_record{
        guild_id = GuildId,
        active_service_id = ActiveServiceConf#active_service_conf.id,
        red_id = uid_lib:get_uid(?UID_TYPE_RED_RECORD),
        min_jade = ActiveServiceConf#active_service_conf.min_jade,
        max_jade = ActiveServiceConf#active_service_conf.max_jade,
        num = NeedNum,
        loss_num = 0,
        loss_jade = 0,
        player_id = 0,
        position = 0,
        begin_time = util_date:unixtime(),
        end_time = util_date:unixtime()
    }.
%% 活动是否开启
is_active_open() ->
    {_BeginTime, EndTime, _, _} = active_service_lib:get_active_time(?ACTIVE_SERVICE_TYPE_RED),
    EndTime > util_date:unixtime().