%%%-------------------------------------------------------------------
%%% @author yubing
%%% @copyright (C) 2015, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 14. 十二月 2015 11:20
%%%-------------------------------------------------------------------
-module(careertitle_lib).

-include("record.hrl").
-include("cache.hrl").
-include("common.hrl").
-include("gameconfig_config.hrl").

-export([get_career_title_player_id/2, update_career_title/1, init_title/0, get_ets/1, get_ets_list/0]).

%% 更新第一称号信息
init_title() ->
    case player_base_db:select_all() of
        [] ->
            skip;
        PlayerBaseList ->
            init_title1(PlayerBaseList, ?CAREER_ZHANSHI),
            init_title1(PlayerBaseList, ?CAREER_FASHI),
            init_title1(PlayerBaseList, ?CAREER_DAOSHI),

            %% 玩家名称 账号绑定纪录
            F = fun(X) ->
                Info = #ets_player_id_name
                {
                    player_id = X#db_player_base.player_id,
                    name = X#db_player_base.name,
                    merit_task_id = 0,
                    career = X#db_player_base.career
                },
                player_id_name_lib:save_ets_player(Info)
            end,
            [F(X) || X <- PlayerBaseList]
    end.
%% 初始化 第一职业称号基础数据信息
init_title1(PlayerBaseList, CAREER) ->
    case [X || X <- PlayerBaseList, X#db_player_base.career =:= CAREER, X#db_player_base.lv >= ?GAMECONFIG_CAREER_TITLE_LIMIT_LV] of
        [] ->
            skip;
        CareerZhanShiList ->
            CareerZhanShiList1 = lists:keysort(#db_player_base.fight, CareerZhanShiList),
            Info = lists:last(CareerZhanShiList1),
            Info1 = #ets_title_careet %%
            {
                career = CAREER,
                fight = Info#db_player_base.fight,
                player_id = Info#db_player_base.player_id,
                sex = Info#db_player_base.sex,
                name = Info#db_player_base.name
            },
            save_ets(Info1)
    end.


%% 从ets获取玩家关系记录
get_ets(Career) ->
    case ets:lookup(?ETS_TITLE_CAREET, Career) of
        [R | _] ->
            R;
        _ ->
            fail
    end.
%% 保存称号信息
save_ets(Info) ->
    ets:insert(?ETS_TITLE_CAREET, Info).

get_ets_list() ->
    ets:tab2list(?ETS_TITLE_CAREET).

%%根据玩家的id查询出当前的称号信息
get_career_title_player_id(PlayerId, Carret) ->

    Result = citytitle_lib:get_city_title_player_id(PlayerId),
    if
        Result > 0 ->
            Result;
        true ->
            case get_ets(Carret) of
                fail ->
                    0;
                R ->
                    case R#ets_title_careet.player_id =:= PlayerId of
                        true ->
                            Carret;
                        _ ->
                            0
                    end
            end
    end.

%%更新称号信息
update_career_title(PlayerState) ->
    Base = PlayerState#player_state.db_player_base,
    %% 判断等级是否足够，否则不予处理
    case Base#db_player_base.lv >= ?GAMECONFIG_CAREER_TITLE_LIMIT_LV of
        true ->
            case get_ets(Base#db_player_base.career) of
                fail ->
                    update_career_title2(PlayerState, Base);
                R ->
                    %% 如果是玩家自己的话，更新战斗力
                    case R#ets_title_careet.player_id =:= PlayerState#player_state.player_id of
                        true ->
                            Info = R#ets_title_careet
                            {
                                fight = PlayerState#player_state.fighting
                            },
                            save_ets(Info),
                            PlayerState;
                        _ ->
                            %% 如果不是自己，那么判断战力，查看是否更新称号信息
                            update_career_title1(R, PlayerState, Base)
                    end
            end;
        _ ->
            PlayerState
    end.

update_career_title2(PlayerState, Base) ->
    Info = #ets_title_careet %%
    {
        career = Base#db_player_base.career,
        player_id = PlayerState#player_state.player_id,
        fight = PlayerState#player_state.fighting,
        name = Base#db_player_base.name,
        sex = Base#db_player_base.sex
    },
    save_ets(Info),

    %% 更新称号雕像信息
    worship_lib:ref_worship_first_career_list(),
    %% 更新玩家的称号信息
    PlayerState#player_state
    {
        career_title = get_career_title_player_id(PlayerState#player_state.player_id, Base#db_player_base.career)
    }.

%%更新称号信息
update_career_title1(R, PlayerState, Base) ->
    case R#ets_title_careet.fight < PlayerState#player_state.fighting of
        true ->
            Info = #ets_title_careet %%
            {
                career = Base#db_player_base.career,
                player_id = PlayerState#player_state.player_id,
                fight = PlayerState#player_state.fighting,
                name = Base#db_player_base.name,
                sex = Base#db_player_base.sex
            },
            save_ets(Info),

            %% 更新以前头名的 称号信息
            case R#ets_title_careet.player_id =:= PlayerState#player_state.player_id of
                true ->
                    skip;
                _ ->
                    case player_lib:get_player_pid(R#ets_title_careet.player_id) of
                        null ->
                            skip;
                        PID ->
                            player_lib:update_player_career_title(PID)
                    end
            end,

            %% 更新称号雕像信息
            worship_lib:ref_worship_first_career_list(),
            %% 更新玩家的称号信息
            PlayerState#player_state
            {
                career_title = get_career_title_player_id(PlayerState#player_state.player_id, Base#db_player_base.career)
            };
        _ ->
            PlayerState
    end.



