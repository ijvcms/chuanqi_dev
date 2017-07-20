%%%-------------------------------------------------------------------
%%% @author zhengsiying
%%% @copyright (C) 2015, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 20. 十月 2015 下午2:54
%%%-------------------------------------------------------------------
-module(notice_lib).

-include("common.hrl").
-include("record.hrl").
-include("notice_config.hrl").
-include("proto.hrl").

%% API
-export([
    send_notice/3,
    send_notice_crass/4,
    send_career_title/2
]).

%% GEN API
-export([
    send_career_title_local/3
]).


%% ====================================================================
%% API functions
%% ====================================================================
send_notice(_PlayerId, NoticeMacro, ArgList) ->
    case notice_config:get(NoticeMacro) of
        #notice_conf{} = NoticeConf ->
            ArgList1 = [util_data:to_list(Arg) || Arg <- ArgList],
            Data = #rep_notice{
                notice_id = NoticeConf#notice_conf.notice_id,
                arg_list = ArgList1
            },
            case NoticeConf#notice_conf.broadcast_type of
                ?BROADCAST_TYPE_WORLD ->
                    net_send:send_to_world(9999, Data);
                _ ->
                    skip
            end;
        _ ->
            ?ERR("not notice [~p]", [NoticeMacro])
    end.
send_notice_crass(ServerPass, _PlayerId, NoticeMacro, ArgList) ->
    cross_lib:send_cross_mfc(ServerPass, ?MODULE, send_notice, [_PlayerId, NoticeMacro, ArgList]).


send_career_title(CareerTitle, PlayerName) ->
    gen_server2:apply_async(misc:whereis_name({local, notice_mod}), {?MODULE, send_career_title_local, [CareerTitle, PlayerName]}),
    ok.

send_career_title_local(State, CareerTitle, PlayerName) ->
    SpanLimit = 60 * 30,
    LastTime = get(CareerTitle),
    Time = util_date:unixtime(),
    case LastTime =:= undefined orelse Time - LastTime > SpanLimit of
        true ->
            spawn(fun() ->
                util:sleep(5000),
                case CareerTitle of
                    ?CITY_TITLE ->
                        notice_lib:send_notice(0, ?NOTICE_CITY_TITLE, [PlayerName]);
                    ?CAREER_ZHANSHI ->
                        notice_lib:send_notice(0, ?NOTICE_CAREER_ZHANSHI, [PlayerName]);
                    ?CAREER_FASHI ->
                        notice_lib:send_notice(0, ?NOTICE_CAREER_FASHI, [PlayerName]);
                    ?CAREER_DAOSHI ->
                        notice_lib:send_notice(0, ?NOTICE_CAREER_DAOSHI, [PlayerName]);
                    _ -> skip
                end
            end),
            put(CareerTitle, Time),
            ok;
        false ->
            skip
    end,
    {ok, State}.

%% ====================================================================
%% Internal functions
%% ====================================================================
