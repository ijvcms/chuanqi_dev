%%%-------------------------------------------------------------------
%%% @author qhb
%%% @copyright (C) 2016, <COMPANY>
%%% @doc
%%%	礼包
%%% @end
%%% Created : 19. 八月 2016 下午4:41
%%%-------------------------------------------------------------------
-module(gift_lib).
-include("common.hrl").
-include("config.hrl").
-include("record.hrl").
-include("cache.hrl").

%% API
-export([
    download/2,
    function_notice_first_key/1
]).

%%下载资源包礼包
download(PlayerId, Lv) ->
    List1 = gift_download_config:get_list(),
    List2 = [R || R <- List1, R =< Lv],
    case List2 of
        [] ->
            skip;
        _ ->
            [
                begin
                    #gift_download_conf{key = Key, reward = Reward, counter_id = CounterId} = gift_download_config:get(R),
                    case counter_lib:check(PlayerId, CounterId) of
                        true ->
                            Sender = xmerl_ucs:to_utf8("系统"),
                            Title = integer_to_list(Key) ++ xmerl_ucs:to_utf8("级下载奖励"),
                            Content = xmerl_ucs:to_utf8("恭喜您下载了新的资源，现在您能游历更多地图，挑战更多BOSS了，为表示感谢，我们为您准备了下载礼包，请及时领取。"),
                            mail_lib:send_mail_to_player(PlayerId, Sender, Title, Content, Reward),
                            counter_lib:update(PlayerId, CounterId);
                        false ->
                            skip
                    end
                end
                || R <- List2]
    end,
    ok.

%%第一个可以领取功能预告礼包id，没有则返回0
function_notice_first_key(PlayerState) ->
    #player_state{db_player_base = #db_player_base{player_id = PlayerId, lv = Lv}} = PlayerState,
    List1 = function_notice_config:get_list_conf(),
    List2 = [R || R <- List1, R#function_notice_conf.lv =< Lv],
    case List2 of
        [] ->
            0;
        _ ->
            F = fun(R) ->
                #function_notice_conf{counter_id = CounterId} = R,
                CounterId > 0 andalso counter_lib:check(PlayerId, CounterId)
            end,
            List3 = [X || X <- List2, F(X)],
            case List3 of
                [] -> 0;
                [H | _] -> H#function_notice_conf.id
            end
    end.
