%%%-------------------------------------------------------------------
%%% @author yubing
%%% @copyright (C) 2015, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 11. 十二月 2015 11:24
%%%-------------------------------------------------------------------
-module(player_black_lib).

-include("common.hrl").
-include("record.hrl").
-include("config.hrl").
-include("cache.hrl").
-include("db_record.hrl").
-include("proto.hrl").
-include("gameconfig_config.hrl").
-include("language_config.hrl").

-export([get_black_list/1, delete_black/2, add_black/2]).

%% 获取黑名单列表
get_black_list(PlayerId) ->
    BlackList = player_black_cache:get_black_list(PlayerId),
    F = fun(X) ->
        FBase = player_base_cache:select_row(X#db_player_black.tplayer_id),
        #proto_relationship_info
        {
            name = FBase#db_player_base.name,
            tplayer_id = FBase#db_player_base.player_id,
            lv = FBase#db_player_base.lv,
            career = FBase#db_player_base.career,
            fight = FBase#db_player_base.fight,
            last_offline_time = FBase#db_player_base.last_logout_time
        }
    end,
    [F(X) || X <- BlackList].

%% 删除黑名单信息
delete_black(PlayerState, TPlayerId) ->
    player_black_cache:delete_black_info(PlayerState#player_state.player_id, TPlayerId),

    NewList = lists:keydelete(TPlayerId, #db_player_black.tplayer_id, PlayerState#player_state.black_friend_list),
    NewPlayerState = PlayerState#player_state{
        black_friend_list = NewList
    },
    {NewPlayerState, 0}.


%% 添加黑名单
add_black(PlayerState, TPlayerId) ->
    PlayerId = PlayerState#player_state.player_id,
    BlackList = player_black_cache:get_black_list(PlayerId),
    case lists:keymember(TPlayerId, #db_player_black.tplayer_id, BlackList) of
        true ->
            {PlayerState, ?LANGUEGE_RELATIONSHIP7};
        _ ->
            NowNum = length(BlackList),
            case NowNum >= ?GAMECONFIG_MAX_BLACK_NUM of
                true ->
                    {PlayerState, ?LANGUEGE_RELATIONSHIP6};
                _ ->
                    BlackInfo = #db_player_black
                    {
                        player_id = PlayerId,
                        tplayer_id = TPlayerId
                    },
                    NewList = [BlackInfo | PlayerState#player_state.black_friend_list],

                    NewPlayerState = PlayerState#player_state{
                        black_friend_list = NewList
                    },
                    player_black_cache:add_black_info(PlayerId, TPlayerId),
                    player_friend_lib:delete_friend(PlayerId, TPlayerId),

                    {NewPlayerState, 0}
            end
    end.

