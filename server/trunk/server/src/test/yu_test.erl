%%%-------------------------------------------------------------------
%%% @author yubing
%%% @copyright (C) 2016, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 13. 四月 2016 17:32
%%%-------------------------------------------------------------------
-module(yu_test).

-include("db_record.hrl").
-include("record.hrl").
-include("cache.hrl").
-include("common.hrl").
-include("proto.hrl").
-include("config.hrl").
-include("uid.hrl").
-include("util_json.hrl").
-include("proto_back.hrl").
%% API
-compile([export_all]).

datetime_to_timestamp(DateTime) ->
    calendar:datetime_to_gregorian_seconds(DateTime) -
        calendar:datetime_to_gregorian_seconds({{1970, 1, 1}, {8, 0, 0}}).

dd(OldBuff) ->
    {_MinAtt, _MaxAtt} = OldBuff#db_buff.extra_info.

%% 发送周围玩家给玩家自己， 把自己信息告诉周围的玩家
send_scene_info_data_all(PlayerState) ->
    gen_server2:apply_async(PlayerState#player_state.scene_pid, {?MODULE, do_send_scene_info_data_all, [PlayerState#player_state.socket, PlayerState#player_state.scene_obj, PlayerState#player_state.player_id]}).

%% 发送周围玩家给玩家自己， 把自己信息告诉周围的玩家
do_send_scene_info_data_all(_SceneState, _Socket, _SceneObj, _PlayerId) ->
    scene_mgr_lib:create_scene(20101),
    {ok, _SceneState}.

log_err() ->
    try
        throw(40)
    catch
        40 ->
            ?ERR(" ~p", [erlang:get_stacktrace()])
    end.

get_log_err() ->
    try
        throw(40)
    catch
        40 ->
            erlang:get_stacktrace()
    end.

%%check_name(Name) ->
%%re:run(Name, "[\ud83c\udc00-\ud83c\udfff]|[\ud83d\udc00-\ud83d\udfff]|[\u2600-\u27ff]", [unicode]) =/= nomatch.
%% check_name(Name) ->
%% 	re:run(<<230,179,176,231,187,143,232,137,186>>, "^[\x{4e00}-\x{9fff}]+$", [unicode]) =/= nomatch.
%% 验证名字是否合法
check_name(Name) ->
    re:run(Name, "^[!@#$%^&*-_=+<>0-9a-zA-Z\x{4e00}-\x{9fff}]+$", [unicode]) == nomatch.

%% 修改玩家的名字
update_name(PlayerId, Name) ->
    Name1 = list_to_bitstring(Name),
    case player_base_cache:select_row(PlayerId) of
        null ->
            skip;
        Base ->
            Base1 = Base#db_player_base{
                name = Name1
            },
            player_base_cache:update(PlayerId, Base1),
            player_id_name_lib:save_ets_player(PlayerId, Base1#db_player_base.career, Name1)
    end.


add_ets() ->
    NewLists = lists:seq(1, 10000),
    F = fun(X) ->
        Daba = #db_buff{
            player_id = X,
            buff_id = 0
        },
        gen_server2:apply_async(misc:whereis_name({local, red_mod}), {?MODULE, do_add_ets1, [Daba]}),
        gen_server2:apply_async(misc:whereis_name({local, red_mod}), {?MODULE, do_add_ets, [Daba]})
    end,
    [F(X) || X <- NewLists],
    ?ERR("addets ~p", [111]),
    okadd_ets.

do_add_ets1(_State, Daba) ->
    buff_cache:insert(Daba),
    ?ERR("inster  ~p", [Daba]),
    {ok, _State}.


do_add_ets(_State, Daba) ->
    NewData = Daba#db_buff{
        buff_id = 0,
        next_time = uid_lib:get_uid(?UID_TYPE_PLAYER)
    },
    buff_cache:update({Daba#db_buff.player_id, Daba#db_buff.buff_id}, NewData),
    ?ERR("update ~p", [NewData]),
    {ok, _State}.

exe_sh_make() ->
    {_, Pwd} = util_data:my_exec("pwd"),
    Temp = string:rstr(Pwd, "\n"),
    Pwd1 = string:sub_string(Pwd, 1, Temp - 1),
    Make = lists:concat(["sh ", Pwd1, "/../sh/make.sh"]),
    util_data:my_exec(Make),

    Make1 = lists:concat(["sh ", Pwd1, "/../sh/hot.sh"]),
    util_data:my_exec(Make1).



test(PlayerState, Mod, Cmd, Data)->
    %% 跨服验证
    case scene_cross:send_cross_mod(PlayerState, Mod, Cmd, Data) of
        null ->
            case Mod /= null of
                true ->
                    case Mod:handle(Cmd, PlayerState, Data) of
                        {ok, NewState} ->
                            {ok, NewState};
                        {stop, Result, NewState} ->
                            {stop, Result, NewState};
                        _ ->
                            {ok, PlayerState}
                    end;
                _ ->
                    {ok, PlayerState}
            end;
        {ok, PlayerState1} ->
            {ok, PlayerState1};
        ok ->
            {ok, PlayerState};
        Err1 ->
            ?ERR("~p", [{Err1, Mod, Cmd}]),
            {ok, PlayerState}
    end.

tt() ->
    rpc:call('normal_2@192.168.10.188', yu_test, log_err, []).

