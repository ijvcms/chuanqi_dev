%%%-------------------------------------------------------------------
%%% @author yubing
%%% @copyright (C) 2015, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 16. 十二月 2015 11:46
%%%-------------------------------------------------------------------
-module(city_lib).

-include("cache.hrl").
-include("record.hrl").
-include("common.hrl").
-include("config.hrl").
-include("proto.hrl").
-include("language_config.hrl").
-include("log_type_config.hrl").
-include("button_tips_config.hrl").

-export([get_scene_city_officer_list/0,
    appoint_officer/4,
    recall_officer/3,
    get_reward_info/2,
    receive_day/2,
    receive_frist/2,
    init/0,
    update_scene_city/2,
    get_city_officer_player/2,
    get_ets_scene_city/1,
    get_scene_city_guild_id/0,
    get_scene_city_officer_list_all/0,
    update_city_Santo/1,
    update_city_member/2,
    delele_city_info/1,
    add_city_member/2,
    is_competence/2,
    receive_every/2,
    update_city_member_office/3,
    init_city_info/1
]).

-export([
    get_button_tips/1,
    get_button_tips_sbk/1,
    do_ref_button_tips_sbk/1,
    ref_button_tips_sbk/0
]).
%% ************************************  ets 处理信息
%% 初始化 沙巴克信息
init() ->
    SceneCityInfo = #ets_scene_city
    {
        scene_id = ?SCENEID_SHABAKE,
        city_info = city_info_cache:select_row(?SCENEID_SHABAKE),
        city_officer = city_officer_cache:select_all(?SCENEID_SHABAKE)
    },
    save_ets_scene_city(SceneCityInfo).

%% 保存玩家的城市场景信息
save_ets_scene_city(SceneCityInfo) ->
    ets:insert(?ETS_SCENE_CITY, SceneCityInfo).

%% 获取对应场景城市的信息
get_ets_scene_city(SceneId) ->
    case ets:lookup(?ETS_SCENE_CITY, SceneId) of
        [R | _] ->
            R;
        _ ->
            fail
    end.

%% 修改对应玩家的信息
update_city_officerinfo({SceneId, PlayerId}, CityOfficerInfo) ->
    city_officer_cache:update({SceneId, PlayerId}, CityOfficerInfo),

    SceneInfo = get_ets_scene_city(SceneId),
    CityOfficerList = lists:keyreplace(CityOfficerInfo#db_city_officer.player_id, #db_city_officer.player_id, SceneInfo#ets_scene_city.city_officer, CityOfficerInfo),
    SceneInfo1 = SceneInfo#ets_scene_city
    {
        city_officer = CityOfficerList
    },
    save_ets_scene_city(SceneInfo1).

%% 添加成员信息
inster_city_officerinfo(SceneId, CityOfficerInfo) ->
    city_officer_cache:insert(CityOfficerInfo),
    SceneInfo = get_ets_scene_city(SceneId),
    CityOfficerList = [CityOfficerInfo | SceneInfo#ets_scene_city.city_officer],
    SceneInfo1 = SceneInfo#ets_scene_city
    {
        city_officer = CityOfficerList
    },
    save_ets_scene_city(SceneInfo1).

%%*************************************** 逻辑信息
%% 修改城市沙巴克状态信息
update_scene_city(SceneId, GuildId) ->
    SceneInfo = get_ets_scene_city(SceneId),
    case SceneInfo#ets_scene_city.city_info of
        null ->
            update_scene_city1(SceneInfo, SceneId, GuildId);
        CityInfo ->
            case CityInfo#db_city_info.guild_id =:= GuildId of
                true ->
                    %% 修改每次攻城奖励
                    OldCityOfficerInfo = lists:keyfind(?OFFICER_HEAD, #db_city_officer.officer_id, SceneInfo#ets_scene_city.city_officer),
                    NewCityOfficerinfo = OldCityOfficerInfo#db_city_officer{
                        every_player_id = 0
                    },

                    city_officer_cache:update({SceneId, NewCityOfficerinfo#db_city_officer.player_id}, NewCityOfficerinfo),
                    CityOfficerList = lists:keyreplace(?OFFICER_HEAD, #db_city_officer.officer_id, SceneInfo#ets_scene_city.city_officer, NewCityOfficerinfo),
                    SceneInfo1 = SceneInfo#ets_scene_city
                    {
                        city_officer = CityOfficerList
                    },
                    save_ets_scene_city(SceneInfo1);
                _ ->
                    update_scene_city2(SceneInfo, SceneId, GuildId)
            end
    end.

%%如果沙巴克没有被人占领 ，那么处理相关信息
update_scene_city1(SceneInfo, SceneId, GuildId) ->
%% 添加城市信息
    CityInfo = #db_city_info
    {
        scene_id = SceneId,
        guild_id = GuildId,
        occupy_time = util_date:get_today_unixtime(),
        every_player_id = 0,
        frist_player_id = 0
    },
    city_info_cache:insert(CityInfo),

    GuildMemberList = [X || X <- guild_cache:get_guild_member_list(GuildId), X#db_player_guild.position =< ?ZHANGLAO],

    %% 添加官员信息
    F = fun(X) ->
        init_city_officer(SceneInfo, X#db_player_guild.position, X#db_player_guild.player_id)
    end,
    NewList = [F(X) || X <- GuildMemberList],

    %% 修改ets缓存信息
    SceneInfo1 = SceneInfo#ets_scene_city
    {
        city_info = CityInfo,
        city_officer = NewList
    },
    save_ets_scene_city(SceneInfo1),
    %% 更新称号信息
    NewCityOfficerInfo = lists:keyfind(?OFFICER_HEAD, #db_city_officer.officer_id, SceneInfo1#ets_scene_city.city_officer),
    citytitle_lib:update_city_title(NewCityOfficerInfo#db_city_officer.player_id).

%%如果沙巴克已经被人占领的化，那么修改沙巴克相关信息
update_scene_city2(SceneInfo, SceneId, GuildId) ->
    CityInfo = SceneInfo#ets_scene_city.city_info,
    %% 修改城市信息
    CityInfo1 = CityInfo#db_city_info
    {
        guild_id = GuildId,
        occupy_time = util_date:get_today_unixtime()
    },
    city_info_cache:update(SceneId, CityInfo1),

    %% 获取帮会的官员信息
    GuildMemberList = [X || X <- guild_cache:get_guild_member_list(GuildId), X#db_player_guild.position =< ?ZHANGLAO],

    %% 获取官员信息
    OfficeConfList = city_officer_config:get_list_conf(),
    %% 添加官员信息
    CityOfficeList = SceneInfo#ets_scene_city.city_officer,
    %% 修改官员信息
    F = fun(X, List) ->
        case X#city_officer_conf.id of
            ?OFFICER_SOLDIER ->
                DelList = [X1 || X1 <- CityOfficeList, X1#db_city_officer.officer_id =:= X#city_officer_conf.id],
                F1 = fun(X1) ->
                    city_officer_cache:delete({SceneId, X1#db_city_officer.player_id})
                end,
                [F1(X1) || X1 <- DelList],
                List;
            _ ->
                AllList = [X1 || X1 <- CityOfficeList, X1#db_city_officer.officer_id =:= X#city_officer_conf.id],
                UserList = [X1 || X1 <- GuildMemberList, X1#db_player_guild.position =:= X#city_officer_conf.id],
                AllNum = length(AllList),
                %% 处理官职信息
                F1 = fun(X1, [TempList, Num]) ->
                    case Num > AllNum of
                        true ->
                            CityOfficerInfo = init_city_officer(SceneInfo, X1#db_player_guild.position, X1#db_player_guild.player_id),
                            [[CityOfficerInfo | TempList], Num + 1];
                        _ ->
                            OfficeInfo = lists:nth(Num, AllList),
                            CityOfficerInfo = OfficeInfo#db_city_officer
                            {
                                player_id = X1#db_player_guild.player_id,
                                every_player_id = 0
                            },
                            city_officer_cache:update({SceneId, OfficeInfo#db_city_officer.player_id}, CityOfficerInfo),
                            [[CityOfficerInfo | TempList], Num + 1]
                    end
                end,
                [List1, Num1] = lists:foldr(F1, [[], 1], UserList),
                %% 删除多余的官职信息
                case Num1 =< AllNum of
                    true ->
                        F2 = fun(X1) ->
                            OfficeInfo = lists:nth(X1, AllList),
                            city_officer_cache:delete({SceneId, OfficeInfo#db_city_officer.player_id})
                        end,
                        [F2(X1) || X1 <- lists:seq(Num1, AllNum)];
                    _ ->
                        skip
                end,
                List ++ List1
        end
    end,
    CityOfficerList = lists:foldl(F, [], OfficeConfList),

    SceneInfo1 = SceneInfo#ets_scene_city
    {
        city_info = CityInfo1,
        city_officer = CityOfficerList
    },
    save_ets_scene_city(SceneInfo1),
    %% 获取以前城主信息
    OldCityOfficerInfo = lists:keyfind(?OFFICER_HEAD, #db_city_officer.officer_id, CityOfficeList),
    %% 获取以前城主信息
    NewCityOfficerInfo = lists:keyfind(?OFFICER_HEAD, #db_city_officer.officer_id, SceneInfo1#ets_scene_city.city_officer),
    citytitle_lib:update_city_title(OldCityOfficerInfo#db_city_officer.player_id),
    citytitle_lib:update_city_title(NewCityOfficerInfo#db_city_officer.player_id).


%% 初始城市官员基础数据信息
init_city_officer(SceneInfo, OfficerId, PlayerId) ->
    CityOfficerInfo = #db_city_officer
    {
        scene_id = SceneInfo#ets_scene_city.scene_id,
        officer_id = OfficerId,
        player_id = PlayerId,
        frist_player_id = 0,
        day_time = 0,
        is_del = 0,
        day_officer_id = 0,
        every_player_id = 0
    },
    city_officer_cache:insert(CityOfficerInfo),
    CityOfficerInfo.

%% 判断当前玩家是否是当前场景的拥有者
is_occupy_scene_city(PlayerState, SceneId) ->
    Base = PlayerState#player_state.db_player_base,
    case get_ets_scene_city(SceneId) of
        fail ->
            false;
        SceneInfo ->
            case SceneInfo#ets_scene_city.city_info of
                null ->
                    false;
                CityInfo ->
                    case CityInfo#db_city_info.guild_id =:= Base#db_player_base.guild_id of
                        true ->
                            true;
                        _ ->
                            false
                    end
            end
    end.

%% 获取沙城的帮派id
get_scene_city_guild_id() ->
    SceneInfo = get_ets_scene_city(?SCENEID_SHABAKE),
    case SceneInfo#ets_scene_city.city_info of
        null ->
            0;
        CityInfo ->
            CityInfo#db_city_info.guild_id
    end.

%% 判断是不是有权限管理沙巴克城市
is_competence(PlayerState, SceneId) ->
    Base = PlayerState#player_state.db_player_base,
    case get_ets_scene_city(SceneId) of
        fail ->
            false;
        SceneInfo ->
            case SceneInfo#ets_scene_city.city_info of
                null ->
                    false;
                CityInfo ->
                    case CityInfo#db_city_info.guild_id =:= Base#db_player_base.guild_id of
                        true ->
                            CityOfficerList = SceneInfo#ets_scene_city.city_officer,
                            case lists:keyfind(PlayerState#player_state.player_id, #db_city_officer.player_id, CityOfficerList) of
                                false ->
                                    false;
                                CityOfficerinfo ->
                                    case CityOfficerinfo#db_city_officer.officer_id =:= ?OFFICER_HEAD of
                                        true ->
                                            true;
                                        _ ->
                                            false
                                    end
                            end;
                        _ ->
                            false
                    end
            end
    end.

%% 获取玩家的官员信息
get_city_officer_player(PlayerId, SceneId) ->
    case get_ets_scene_city(SceneId) of
        fail ->
            false;
        SceneInfo ->
            case lists:keyfind(PlayerId, #db_city_officer.player_id, SceneInfo#ets_scene_city.city_officer) of
                false ->
                    false;
                CityOfficerInfo ->
                    CityOfficerInfo
            end
    end.

%% 获取领取 首次奖励的帮派信息
get_city_guild_info(SceneId) ->
    SceneInfo = get_ets_scene_city(SceneId),
    case lists:keyfind(?OFFICER_HEAD, #db_city_officer.officer_id, SceneInfo#ets_scene_city.city_officer) of
        false ->
            {<<"">>, <<"">>, <<"">>};
        CityOfficerInfo ->
            PlayerEtsName = player_id_name_lib:get_ets_player_id_name_by_playerid_nofail(CityOfficerInfo#db_city_officer.player_id),
            Frist_PlayerEtsName = player_id_name_lib:get_ets_player_id_name_by_playerid_nofail(CityOfficerInfo#db_city_officer.frist_player_id),
            Every_PlayerEtsName = player_id_name_lib:get_ets_player_id_name_by_playerid_nofail(CityOfficerInfo#db_city_officer.every_player_id),
            {Frist_PlayerEtsName#ets_player_id_name.name, PlayerEtsName#ets_player_id_name.name, Every_PlayerEtsName#ets_player_id_name.name}
    end.


% **************************************接口相关信息
% 帮主变更相应修改
update_city_Santo(GuildId) ->
    SceneInfo = get_ets_scene_city(?SCENEID_SHABAKE),
    case SceneInfo#ets_scene_city.city_info of
        null ->
            skip;
        CityInfo ->
            if
                CityInfo#db_city_info.guild_id =:= GuildId ->
                    update_city_Santo2(?SCENEID_SHABAKE, SceneInfo, GuildId);
                true ->
                    skip
            end
    end.
update_city_Santo2(SceneId, SceneInfo, GuildId) ->
    %% 获取老帮主信息
    OldOfficerInfo = lists:keyfind(?OFFICER_HEAD, #db_city_officer.officer_id, SceneInfo#ets_scene_city.city_officer),
    NewPlayerId = guild_lib:get_guild_chief_id(GuildId),
    case lists:keyfind(NewPlayerId, #db_city_officer.player_id, SceneInfo#ets_scene_city.city_officer) of
        false ->
            NewOfficerInfo1 = OldOfficerInfo#db_city_officer
            {
                player_id = NewPlayerId
            },
            city_officer_cache:insert(NewOfficerInfo1),


            OldOfficerInfo1 = #db_city_officer
            {
                officer_id = ?OFFICER_SOLDIER,
                player_id = OldOfficerInfo#db_city_officer.player_id,
                day_time = 0,
                scene_id = SceneId,
                frist_player_id = 0,
                is_del = 0,
                day_officer_id = 0,
                every_player_id = 0
            },
            city_officer_cache:update({SceneId, OldOfficerInfo1#db_city_officer.player_id}, OldOfficerInfo1),


            List1 = lists:keyreplace(OldOfficerInfo1#db_city_officer.player_id, #db_city_officer.player_id, SceneInfo#ets_scene_city.city_officer, OldOfficerInfo1),
            List2 = [NewOfficerInfo1 | List1],

            SceneInfo1 = SceneInfo#ets_scene_city
            {
                city_officer = List2
            },
            save_ets_scene_city(SceneInfo1);
        NewOfficerInfo -> %% 新帮主信息
            NewOfficerInfo1 = NewOfficerInfo#db_city_officer
            {
                player_id = OldOfficerInfo#db_city_officer.player_id
            },
            city_officer_cache:update({SceneId, NewOfficerInfo1#db_city_officer.player_id}, NewOfficerInfo1),

            List1 = lists:keyreplace(NewOfficerInfo1#db_city_officer.player_id, #db_city_officer.player_id, SceneInfo#ets_scene_city.city_officer, NewOfficerInfo1),

            OldOfficerInfo1 = OldOfficerInfo#db_city_officer
            {
                player_id = NewPlayerId
            },
            city_officer_cache:update({SceneId, OldOfficerInfo1#db_city_officer.player_id}, OldOfficerInfo1),


            List2 = lists:keyreplace(OldOfficerInfo1#db_city_officer.player_id, #db_city_officer.player_id, List1, OldOfficerInfo1),
            SceneInfo1 = SceneInfo#ets_scene_city
            {
                city_officer = List2
            },
            save_ets_scene_city(SceneInfo1)
    end,
    citytitle_lib:update_city_title(NewPlayerId),
    citytitle_lib:update_city_title(OldOfficerInfo#db_city_officer.player_id).


% 成员退帮相应修改
update_city_member(PlayerId, GuildId) ->
    SceneInfo = get_ets_scene_city(?SCENEID_SHABAKE),
    case SceneInfo#ets_scene_city.city_info of
        null ->
            skip;
        CityInfo ->
            if
                CityInfo#db_city_info.guild_id =:= GuildId ->
                    update_city_member1(PlayerId, SceneInfo);
                true ->
                    skip
            end
    end.
update_city_member1(PlayerId, SceneInfo) ->
    case lists:keyfind(PlayerId, #db_city_officer.player_id, SceneInfo#ets_scene_city.city_officer) of
        false ->
            skip;
        NewOfficerInfo ->
            case NewOfficerInfo#db_city_officer.officer_id =:= ?OFFICER_HEAD of
                true ->
                    delele_city_info1(SceneInfo);
                _ ->
                    case NewOfficerInfo#db_city_officer.day_time < util_date:unixtime() of
                        true ->
                            %% 如果领取奖励的时间 小于了当前时间那么直接删掉
                            city_officer_cache:delete({NewOfficerInfo#db_city_officer.scene_id, NewOfficerInfo#db_city_officer.player_id}),
                            List1 = lists:keydelete(NewOfficerInfo#db_city_officer.player_id, #db_city_officer.player_id, SceneInfo#ets_scene_city.city_officer),
                            SceneInfo1 = SceneInfo#ets_scene_city
                            {
                                city_officer = List1
                            },
                            save_ets_scene_city(SceneInfo1);
                        _ ->
                            %% 如果领取奖励的时间大于了当前时间
                            NewOfficerInfo1 = NewOfficerInfo#db_city_officer{
                                is_del = 1
                            },
                            city_officer_cache:update({NewOfficerInfo#db_city_officer.scene_id, NewOfficerInfo#db_city_officer.player_id}, NewOfficerInfo1),

                            List1 = lists:keyreplace(NewOfficerInfo#db_city_officer.player_id, #db_city_officer.player_id, SceneInfo#ets_scene_city.city_officer, NewOfficerInfo1),
                            SceneInfo1 = SceneInfo#ets_scene_city
                            {
                                city_officer = List1
                            },
                            save_ets_scene_city(SceneInfo1)
                    end
            end
    end.


% 帮派解散相应修改
delele_city_info(GuildId) ->
    SceneInfo = get_ets_scene_city(?SCENEID_SHABAKE),
    case SceneInfo#ets_scene_city.city_info of
        null ->
            skip;
        CityInfo ->
            if
                CityInfo#db_city_info.guild_id =:= GuildId ->
                    delele_city_info1(SceneInfo);
                true ->
                    skip
            end
    end.
delele_city_info1(SceneInfo) ->
    city_info_cache:delete(SceneInfo#ets_scene_city.scene_id),
    SceneInfo1 = SceneInfo#ets_scene_city
    {
        city_info = null
    },

    OldCityOfficer = lists:keyfind(?OFFICER_HEAD, #db_city_officer.officer_id, SceneInfo#ets_scene_city.city_officer),
    F = fun(X, List) ->
        case X#db_city_officer.officer_id =:= ?OFFICER_HEAD of
            true ->
                NewOfficerInfo = X#db_city_officer
                {
                    player_id = 0
                },
                city_officer_cache:update({SceneInfo#ets_scene_city.scene_id, X#db_city_officer.player_id}, NewOfficerInfo),
                [NewOfficerInfo | List];
            _ ->
                city_officer_cache:delete({SceneInfo#ets_scene_city.scene_id, X#db_city_officer.player_id}),
                List
        end
    end,
    List1 = lists:foldl(F, [], SceneInfo1#ets_scene_city.city_officer),
    ?INFO("lists1 ~p", [List1]),
    SceneInfo2 = SceneInfo1#ets_scene_city
    {
        city_officer = List1
    },

    ?INFO("SceneInfo2 ~p", [SceneInfo2]),
    save_ets_scene_city(SceneInfo2),
    citytitle_lib:update_city_title(OldCityOfficer#db_city_officer.player_id).


%% 添加帮会成员
add_city_member(PlayerId, GuildId) ->
    SceneInfo = get_ets_scene_city(?SCENEID_SHABAKE),
    case SceneInfo#ets_scene_city.city_info of
        null ->
            skip;
        CityInfo ->
            if
                CityInfo#db_city_info.guild_id =:= GuildId ->
                    add_city_member1(PlayerId, SceneInfo);
                true ->
                    skip
            end
    end.
add_city_member1(PlayerId, SceneInfo) ->
    case lists:keyfind(PlayerId, #db_city_officer.player_id, SceneInfo#ets_scene_city.city_officer) of
        false ->
            skip;
        NewOfficerInfo ->
            NewOfficerInfo1 = NewOfficerInfo#db_city_officer{
                officer_id = ?OFFICER_SOLDIER,
                is_del = 0
            },
            city_officer_cache:update({NewOfficerInfo#db_city_officer.scene_id, NewOfficerInfo#db_city_officer.player_id}, NewOfficerInfo1),
            List1 = lists:keyreplace(NewOfficerInfo#db_city_officer.player_id, #db_city_officer.player_id, SceneInfo#ets_scene_city.city_officer, NewOfficerInfo1),
            SceneInfo1 = SceneInfo#ets_scene_city
            {
                city_officer = List1
            },
            save_ets_scene_city(SceneInfo1)
    end.

%% 委任副会长，长老
update_city_member_office(PlayerId, GuildId, OfficeId) ->
    SceneInfo = get_ets_scene_city(?SCENEID_SHABAKE),
    case SceneInfo#ets_scene_city.city_info of
        null ->
            skip;
        CityInfo ->
            if
                CityInfo#db_city_info.guild_id =:= GuildId ->
                    update_city_member_office1(PlayerId, SceneInfo, OfficeId);
                true ->
                    skip
            end
    end.
update_city_member_office1(PlayerId, SceneInfo, OfficeId) ->
    NewOfficeId = case OfficeId > ?OFFICER_SOLDIER of
                      true ->
                          ?OFFICER_SOLDIER;
                      _ ->
                          OfficeId
                  end,
    case lists:keyfind(PlayerId, #db_city_officer.player_id, SceneInfo#ets_scene_city.city_officer) of
        false ->
            case NewOfficeId =:= ?OFFICER_HEAD of
                true ->
                    HeadOfficerInfo = lists:keyfind(NewOfficeId, #db_city_officer.officer_id, SceneInfo#ets_scene_city.city_officer),

                    HeadOfficerInfo1 = HeadOfficerInfo#db_city_officer{
                        player_id = PlayerId
                    },
                    city_officer_cache:insert(HeadOfficerInfo1),
                    ?ERR("11111 ~p", [HeadOfficerInfo1]),

                    CityOfficerInfo = #db_city_officer
                    {
                        scene_id = SceneInfo#ets_scene_city.scene_id,
                        officer_id = ?OFFICER_SOLDIER,
                        player_id = HeadOfficerInfo#db_city_officer.player_id,
                        frist_player_id = 0,
                        day_time = 0,
                        is_del = 0,
                        day_officer_id = 0,
                        every_player_id = 0
                    },
                    ?ERR("2222 ~p", [CityOfficerInfo]),
                    city_officer_cache:update({CityOfficerInfo#db_city_officer.scene_id, CityOfficerInfo#db_city_officer.player_id}, CityOfficerInfo),
                    NewList1 = lists:keyreplace(CityOfficerInfo#db_city_officer.player_id, #db_city_officer.player_id, SceneInfo#ets_scene_city.city_officer, CityOfficerInfo),
                    %% 如果没有那么就新键

                    NewList = [HeadOfficerInfo1 | NewList1],
                    SceneInfo1 = SceneInfo#ets_scene_city
                    {
                        city_officer = NewList
                    },
                    save_ets_scene_city(SceneInfo1);
                _ ->
                    %% 如果没有那么就新键
                    CityOfficerInfo = #db_city_officer
                    {
                        scene_id = SceneInfo#ets_scene_city.scene_id,
                        officer_id = NewOfficeId,
                        player_id = PlayerId,
                        frist_player_id = 0,
                        day_time = 0,
                        is_del = 0,
                        day_officer_id = 0,
                        every_player_id = 0
                    },
                    city_officer_cache:insert(CityOfficerInfo),
                    NewList = [CityOfficerInfo | SceneInfo#ets_scene_city.city_officer],
                    SceneInfo1 = SceneInfo#ets_scene_city
                    {
                        city_officer = NewList
                    },
                    save_ets_scene_city(SceneInfo1)
            end;
        NewOfficerInfo ->
            NewOfficeId = case OfficeId > ?OFFICER_SOLDIER of
                              true ->
                                  ?OFFICER_SOLDIER;
                              _ ->
                                  OfficeId
                          end,
            case NewOfficerInfo#db_city_officer.officer_id =:= NewOfficeId of
                true ->
                    skip;
                _ ->
                    case NewOfficeId =:= ?OFFICER_HEAD of
                        true ->
                            %% 获取会长的信息
                            HeadOfficerInfo = lists:keyfind(NewOfficeId, #db_city_officer.officer_id, SceneInfo#ets_scene_city.city_officer),
                            HeadOfficerInfo1 = HeadOfficerInfo#db_city_officer{
                                player_id = PlayerId
                            },
                            %% 更改会长信息，替换
                            NewList1 = lists:keyreplace(PlayerId, #db_city_officer.player_id, SceneInfo#ets_scene_city.city_officer, HeadOfficerInfo1),

                            %% 替换信息的信息
                            NewOfficerInfo1 = NewOfficerInfo#db_city_officer{
                                player_id = HeadOfficerInfo#db_city_officer.player_id
                            },
                            NewList2 = lists:keyreplace(NewOfficerInfo1#db_city_officer.player_id, #db_city_officer.player_id, NewList1, NewOfficerInfo1),

                            city_officer_cache:update({NewOfficerInfo1#db_city_officer.scene_id, NewOfficerInfo1#db_city_officer.player_id}, NewOfficerInfo1),
                            city_officer_cache:update({HeadOfficerInfo1#db_city_officer.scene_id, HeadOfficerInfo1#db_city_officer.player_id}, HeadOfficerInfo1),
                            SceneInfo1 = SceneInfo#ets_scene_city
                            {
                                city_officer = NewList2
                            },
                            save_ets_scene_city(SceneInfo1);
                        _ ->
                            NewOfficerInfo1 = NewOfficerInfo#db_city_officer{
                                officer_id = NewOfficeId
                            },
                            city_officer_cache:update({NewOfficerInfo#db_city_officer.scene_id, NewOfficerInfo#db_city_officer.player_id}, NewOfficerInfo1),
                            List1 = lists:keyreplace(NewOfficerInfo#db_city_officer.player_id, #db_city_officer.player_id, SceneInfo#ets_scene_city.city_officer, NewOfficerInfo1),
                            SceneInfo1 = SceneInfo#ets_scene_city
                            {
                                city_officer = List1
                            },
                            save_ets_scene_city(SceneInfo1)
                    end
            end
    end.
%% **************************************界面相关信息
%% 获取沙巴克官员列表信息
get_scene_city_officer_list() ->
    SceneInfo = get_ets_scene_city(?SCENEID_SHABAKE),
    F = fun(X) ->
        city_officer_config:get(X#db_city_officer.officer_id),
        Base = player_base_cache:select_row(X#db_city_officer.player_id),
        #proto_city_officer_info
        {
            officer_id = X#db_city_officer.officer_id,
            tplayer_id = X#db_city_officer.player_id,
            tname = Base#db_player_base.name,
            guise = player_lib:make_proto_guise(Base#db_player_base.guise),
            sex = Base#db_player_base.sex,
            career = Base#db_player_base.career
        }
    end,
    [F(X) || X <- SceneInfo#ets_scene_city.city_officer,
        X#db_city_officer.officer_id /= ?OFFICER_HEAD,
        X#db_city_officer.officer_id /= ?OFFICER_SOLDIER,
        X#db_city_officer.is_del =:= 0].
%% 获取官员列表，包含会长
get_scene_city_officer_list_all() ->
    SceneInfo = get_ets_scene_city(?SCENEID_SHABAKE),
    F = fun(X) ->
        city_officer_config:get(X#db_city_officer.officer_id),
        Base = player_base_cache:select_row(X#db_city_officer.player_id),
        #proto_city_officer_info
        {
            officer_id = X#db_city_officer.officer_id,
            tplayer_id = X#db_city_officer.player_id,
            tname = Base#db_player_base.name,
            guise = player_lib:make_proto_guise(Base#db_player_base.guise),
            sex = Base#db_player_base.sex,
            career = Base#db_player_base.career
        }
    end,
    [F(X) || X <- SceneInfo#ets_scene_city.city_officer,
        X#db_city_officer.officer_id /= ?OFFICER_SOLDIER,
        X#db_city_officer.is_del =:= 0].


%% 任命官员
appoint_officer(PlayerState, SceneId, OfficerId, TPlayerId) ->
    case is_competence(PlayerState, SceneId) of
        false ->
            ?LANGUEGE_CITY_SCENE7;
        _ ->
            OfficerInfo = city_officer_config:get(OfficerId),
            SceneInfo = get_ets_scene_city(SceneId),
            OfficeList = [X || X <- SceneInfo#ets_scene_city.city_officer,
                X#db_city_officer.officer_id =:= OfficerId,
                X#db_city_officer.is_del =:= 0
            ],
            case length(OfficeList) >= OfficerInfo#city_officer_conf.num of
                true ->
                    ?LANGUEGE_CITY_SCENE10;
                _ ->
                    case lists:keyfind(TPlayerId, #db_city_officer.player_id, SceneInfo#ets_scene_city.city_officer) of
                        false ->
                            CityOfficerInfo1 = #db_city_officer
                            {
                                officer_id = OfficerId,
                                day_time = 0,
                                scene_id = SceneId,
                                player_id = TPlayerId,
                                frist_player_id = 0,
                                day_officer_id = 0,
                                every_player_id = 0,
                                is_del = 0
                            },
                            city_officer_cache:insert(CityOfficerInfo1),
                            CityOfficerList = [CityOfficerInfo1 | SceneInfo#ets_scene_city.city_officer],
                            SceneInfo1 = SceneInfo#ets_scene_city
                            {
                                city_officer = CityOfficerList
                            },
                            save_ets_scene_city(SceneInfo1),
                            0;
                        CityOfficerInfo ->
                            case CityOfficerInfo#db_city_officer.officer_id /= ?OFFICER_SOLDIER of
                                true ->
                                    ?LANGUEGE_CITY_SCENE_OFFICER;
                                _ ->
                                    CityOfficerInfo1 = CityOfficerInfo#db_city_officer
                                    {
                                        officer_id = OfficerId
                                    },
                                    city_officer_cache:update({SceneId, CityOfficerInfo#db_city_officer.player_id}, CityOfficerInfo1),
                                    CityOfficerList = lists:keyreplace(TPlayerId, #db_city_officer.player_id, SceneInfo#ets_scene_city.city_officer, CityOfficerInfo1),
                                    SceneInfo1 = SceneInfo#ets_scene_city
                                    {
                                        city_officer = CityOfficerList
                                    },
                                    save_ets_scene_city(SceneInfo1),
                                    0
                            end
                    end
            end
    end.

%% 解雇官员
recall_officer(PlayerState, SceneId, TPlayerId) ->
    case is_competence(PlayerState, SceneId) of
        false ->
            ?LANGUEGE_CITY_SCENE7;
        _ ->
            SceneInfo = get_ets_scene_city(SceneId),
            CityOfficerInfo = lists:keyfind(TPlayerId, #db_city_officer.player_id, SceneInfo#ets_scene_city.city_officer),
            CityOfficerInfo1 = CityOfficerInfo#db_city_officer
            {
                officer_id = ?OFFICER_SOLDIER
            },
            city_officer_cache:update({SceneId, CityOfficerInfo#db_city_officer.player_id}, CityOfficerInfo1),

            CityOfficerList = lists:keyreplace(TPlayerId, #db_city_officer.player_id, SceneInfo#ets_scene_city.city_officer, CityOfficerInfo1),
            SceneInfo1 = SceneInfo#ets_scene_city
            {
                city_officer = CityOfficerList
            },
            save_ets_scene_city(SceneInfo1),
            0
    end.

%% 领取界面的领取信息
get_reward_info(PlayerState, SceneId) ->
    {FristName, Name, EveryName} = get_city_guild_info(SceneId),
    %% 是否是沙巴克的占领者成员
    case is_occupy_scene_city(PlayerState, SceneId) of
        false ->
            %% 查看场景是否有被占领
            #rep_city_reward_info
            {
                officer_id = 0,
                isday = 1,
                isfrist = 1,
                isexery = 1,
                frist_player_name = FristName,
                title_player_name = Name,
                every_player_name = EveryName
            };
        _ ->
            RepCityRewardInfo = get_reward_info2(PlayerState, SceneId),
            RepCityRewardInfo#rep_city_reward_info
            {
                frist_player_name = FristName,
                title_player_name = Name,
                every_player_name = EveryName
            }
    end.

%% 领取界面的领奖信息2
get_reward_info2(PlayerState, SceneId) ->
    %% 获取自己的官职信息
    case get_city_officer_player(PlayerState#player_state.player_id, SceneId) of
        false ->
            %% 数据正确
            #rep_city_reward_info
            {
                officer_id = ?OFFICER_SOLDIER,
                isday = 0,
                isfrist = 1,
                isexery = 1
            };
        CityOfficerInfo ->
            %% 如果是官员的化
            case CityOfficerInfo#db_city_officer.officer_id =:= ?OFFICER_HEAD of
                true ->
                    CityRewardInfo = case CityOfficerInfo#db_city_officer.frist_player_id > 0 of
                                         true ->
                                             #rep_city_reward_info
                                             {
                                                 officer_id = CityOfficerInfo#db_city_officer.officer_id,
                                                 isday = is_receive_day_officer(SceneId, CityOfficerInfo),
                                                 isfrist = 1
                                             };
                                         _ ->
                                             #rep_city_reward_info
                                             {
                                                 officer_id = CityOfficerInfo#db_city_officer.officer_id,
                                                 isday = is_receive_day_officer(SceneId, CityOfficerInfo),
                                                 isfrist = 0
                                             }
                                     end,
                    case CityOfficerInfo#db_city_officer.every_player_id > 0 of
                        true ->
                            CityRewardInfo#rep_city_reward_info{
                                isexery = 1
                            };
                        _ ->
                            CityRewardInfo#rep_city_reward_info{
                                isexery = 0
                            }
                    end;
                _ ->
                    #rep_city_reward_info
                    {
                        officer_id = CityOfficerInfo#db_city_officer.officer_id,
                        isday = is_receive_day_officer(SceneId, CityOfficerInfo),
                        isfrist = 1,
                        isexery = 1
                    }
            end
    end.

%%领取第一次奖励%%
receive_frist(PlayerState, SceneId) ->
    %% 获取玩家的官员信息 判断权限是否可以领取
    case get_city_officer_player(PlayerState#player_state.player_id, SceneId) of
        false ->
            {ok, PlayerState, ?LANGUEGE_CITY_SCENE8};
        CityOfficerInfo ->
            case CityOfficerInfo#db_city_officer.frist_player_id < 1 andalso CityOfficerInfo#db_city_officer.officer_id =:= ?OFFICER_HEAD of
                true ->
                    OfficerInfo = city_officer_config:get(CityOfficerInfo#db_city_officer.officer_id),
                    GoodsList = OfficerInfo#city_officer_conf.frist_reward_goods,
                    case goods_lib_log:add_goods_list(PlayerState, GoodsList, ?LOG_TYPE_OFFICER_FRIST) of
                        {ok, PlayerState1} ->
                            %% 领取成功修改 状态
                            CityOfficerInfo1 = CityOfficerInfo#db_city_officer
                            {
                                frist_player_id = PlayerState#player_state.player_id
                            },
                            update_city_officerinfo(
                                {CityOfficerInfo#db_city_officer.scene_id, CityOfficerInfo#db_city_officer.player_id},
                                CityOfficerInfo1),
                            {ok, PlayerState1, 0};
                        {fail, Err} ->
                            {ok, PlayerState, Err}
                    end;
                _ ->
                    {ok, PlayerState, ?LANGUEGE_CITY_SCENE8}
            end
    end.

%% 领取每一次攻城奖励
receive_every(PlayerState, SceneId) ->
    %% 获取玩家的官员信息 判断权限是否可以领取
    case get_city_officer_player(PlayerState#player_state.player_id, SceneId) of
        false ->
            {ok, PlayerState, ?LANGUEGE_CITY_SCENE8};
        CityOfficerInfo ->
            case CityOfficerInfo#db_city_officer.every_player_id < 1 andalso CityOfficerInfo#db_city_officer.officer_id =:= ?OFFICER_HEAD of
                true ->
                    OfficerInfo = city_officer_config:get(CityOfficerInfo#db_city_officer.officer_id),
                    GoodsList = OfficerInfo#city_officer_conf.every_reward_goods,
                    case goods_lib_log:add_goods_list(PlayerState, GoodsList, ?LOG_TYPE_OFFICER_FRIST) of
                        {ok, PlayerState1} ->
                            %% 领取成功修改 状态
                            CityOfficerInfo1 = CityOfficerInfo#db_city_officer
                            {
                                every_player_id = PlayerState#player_state.player_id
                            },
                            update_city_officerinfo(
                                {CityOfficerInfo#db_city_officer.scene_id, CityOfficerInfo#db_city_officer.player_id},
                                CityOfficerInfo1),
                            {ok, PlayerState1, 0};
                        {fail, Err} ->
                            {ok, PlayerState, Err}
                    end;
                _ ->
                    {ok, PlayerState, ?LANGUEGE_CITY_SCENE8}
            end
    end.

%% 领取每一次攻击奖励
%% 领取每日奖励
receive_day(PlayerState, SceneId) ->
    case is_occupy_scene_city(PlayerState, SceneId) of
        false ->
            {ok, PlayerState, ?LANGUEGE_CITY_SCENE8};
        _ ->
            receve_day1(PlayerState, SceneId)
    end.
%% 领取每日奖励
receve_day1(PlayerState, SceneId) ->
    case get_city_officer_player(PlayerState#player_state.player_id, SceneId) of
        false ->
            OfficerInfo = city_officer_config:get(?OFFICER_SOLDIER),
            case goods_lib_log:add_goods_list(PlayerState, OfficerInfo#city_officer_conf.day_reward_goods, ?LOG_TYPE_OFFICER_DAY) of
                {ok, PlayerState1} ->
                    %% 如果领取成功修改 状态
                    CityOfficerInfo1 = #db_city_officer
                    {
                        day_time = util_date:get_tomorrow_unixtime(),
                        officer_id = ?OFFICER_SOLDIER,
                        player_id = PlayerState#player_state.player_id,
                        scene_id = SceneId,
                        day_officer_id = ?OFFICER_SOLDIER,
                        frist_player_id = 0,
                        is_del = 0,
                        every_player_id = 0
                    },
                    inster_city_officerinfo(SceneId, CityOfficerInfo1),
                    {ok, PlayerState1, 0};
                {fail, Err} ->
                    {ok, PlayerState, Err}
            end;
        CityOfficerInfo ->
            case is_receive_day_officer(SceneId, CityOfficerInfo) of
                0 ->
                    OfficerInfo = city_officer_config:get(CityOfficerInfo#db_city_officer.officer_id),
                    case goods_lib_log:add_goods_list(PlayerState, OfficerInfo#city_officer_conf.day_reward_goods, ?LOG_TYPE_OFFICER_DAY) of
                        {ok, PlayerState1} ->
                            %% 如果领取成功修改 状态
                            CityOfficerInfo1 = CityOfficerInfo#db_city_officer
                            {
                                day_time = util_date:get_tomorrow_unixtime(),
                                day_officer_id = CityOfficerInfo#db_city_officer.officer_id
                            },
                            update_city_officerinfo(
                                {CityOfficerInfo#db_city_officer.scene_id, CityOfficerInfo#db_city_officer.player_id},
                                CityOfficerInfo1),

                            {ok, PlayerState1, 0};
                        {fail, Err} ->
                            {ok, PlayerState, Err}
                    end;
                _ ->
                    {ok, PlayerState, ?LANGUEGE_CITY_SCENE9}
            end
    end.

%% 判断是否能领取大臣，以及副城主的 每日奖励
is_receive_day_officer(SceneId, CityOfficerInfo) ->
    case CityOfficerInfo#db_city_officer.day_time > util_date:unixtime() of
        true ->
            1;
        _ ->
            case CityOfficerInfo#db_city_officer.officer_id =:= ?OFFICER_SOLDIER of
                true ->
                    0;
                _ ->
                    SceneInfo = get_ets_scene_city(SceneId),
                    NewList = [X || X <- SceneInfo#ets_scene_city.city_officer
                        , X#db_city_officer.day_officer_id =:= CityOfficerInfo#db_city_officer.officer_id
                        , X#db_city_officer.day_time > util_date:unixtime()],
                    Num = length(NewList),
                    Officerinfo = city_officer_config:get(CityOfficerInfo#db_city_officer.officer_id),
                    if
                        Num >= Officerinfo#city_officer_conf.num ->
                            1;
                        true ->
                            0
                    end
            end
    end.


%% ===================================================================
%% 红点提示
%% ===================================================================
get_button_tips(PlayerState) ->
    Info = get_reward_info(PlayerState, ?SCENEID_SHABAKE),
    Num = case Info#rep_city_reward_info.isfrist of
              1 ->
                  0;
              0 ->
                  1
          end,
    Num1 = case Info#rep_city_reward_info.isexery of
               1 ->
                   Num;
               0 ->
                   Num + 1
           end,

    Num2 = case Info#rep_city_reward_info.isday of
               1 ->
                   Num1;
               _ ->
                   Num1 + 1
           end,
    {PlayerState, Num2}.

%% 获取沙巴克的红点信息
get_button_tips_sbk(PlayerState) ->
    {BeginTime, EndTime} = scene_activity_palace_lib:get_next_start_time(?SCENEID_SHABAKE),
    CurTime = util_date:unixtime(),
    case CurTime >= BeginTime andalso EndTime > CurTime of
        true ->
            {PlayerState, 1};
        _ ->
            {PlayerState, 0}
    end.

ref_button_tips_sbk() ->
    Playerlist = player_lib:get_online_players(),
    [ref_button_tips_sbk(X#ets_online.pid) || X <- Playerlist].

%% 刷新沙巴克开启关闭红点
ref_button_tips_sbk(PlayerPid) when is_pid(PlayerPid) ->
    gen_server2:apply_async(PlayerPid, {?MODULE, do_ref_button_tips_sbk, []});
%% 发送聊天信息
ref_button_tips_sbk(Playerid) ->
    case player_lib:get_player_pid(Playerid) of
        null ->
            skip;
        PId ->
            ref_button_tips_sbk(PId)
    end.
%% 发送聊天信息
do_ref_button_tips_sbk(PlayerState) ->
    button_tips_lib:ref_button_tips(PlayerState, ?BTN_SBK).

%% 处理错误数据
init_city_info(SceneId) ->
    SceneInfo = get_ets_scene_city(SceneId),
%%     CityInfo = SceneInfo#ets_scene_city.city_info,
%%     GuildId = CityInfo#db_city_info.guild_id,
    %% 添加官员信息
    CityOfficeList = SceneInfo#ets_scene_city.city_officer,
    %% 修改官员信息
    F = fun(X, List) ->
        #db_city_officer{player_id = PlayerId} = X,
        case player_guild_cache:select_row(PlayerId) of
            [] ->
                city_officer_cache:delete({SceneId, PlayerId}),
                List;
            PlayerGuildInfo ->
                case PlayerGuildInfo#db_player_guild.position =< ?ZHANGLAO of
                    true ->
                        CityOfficerInfo = X#db_city_officer
                        {
                            officer_id = PlayerGuildInfo#db_player_guild.position
                        },
                        city_officer_cache:update({SceneId, PlayerId}, CityOfficerInfo),
                        [CityOfficerInfo | List];
                    _ ->
                        CityOfficerInfo = X#db_city_officer
                        {
                            officer_id = ?OFFICER_SOLDIER
                        },
                        city_officer_cache:update({SceneId, PlayerId}, CityOfficerInfo),
                        [CityOfficerInfo | List]
                end
        end
    end,
    CityOfficerList = lists:foldl(F, [], CityOfficeList),

    SceneInfo1 = SceneInfo#ets_scene_city
    {
        city_officer = CityOfficerList
    },
    save_ets_scene_city(SceneInfo1).

