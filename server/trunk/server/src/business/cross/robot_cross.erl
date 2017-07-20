%%%-------------------------------------------------------------------
%%% @author yubing
%%% @copyright (C) 2016, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 30. 五月 2016 16:57
%%%-------------------------------------------------------------------
-module(robot_cross).
-include("gameconfig_config.hrl").
-include("record.hrl").
-include("cache.hrl").
-include("common.hrl").
-include("proto.hrl").
-include("config.hrl").
%% API
-export([
  init/0,
  check_robot/1,
  login_out/1,
  check_robot/3,
  change_sence/1,
  exe_robot/2,
  is_robot/1,
  is_robot_open_id/2
]).


-export([
  login/1,
  do_login/5,
  do_login_out/2,
  do_change_sence/4,
  do_is_robot/2
]).

-define(SCENEID_NEW, 20101).

%% 初始化机器人账号信息
init() ->
  [put(X, null) || X <- robot_account_config:get_list()].

%% 执行事件
exe_robot(F, C) ->
  case config:get_is_robot() of
    true ->
      ?MODULE:F(C);
    _ ->
      skip
  end.

%% 登陆记录
login([OpendId, PlayerId, ScendId, IsRobot]) ->
  gen_server2:apply_async(misc:whereis_name({local, robot_mod}), {?MODULE, do_login, [OpendId, PlayerId, ScendId, IsRobot]}).
do_login(_State, OpendId, PlayerId, SceneId, IsRobot) ->
  case IsRobot of
    1 ->
      put(OpendId, {PlayerId, SceneId});
    _Value ->
      skip
  end,
  check_robot(_State, SceneId, IsRobot).

%% 登出记录
login_out([OpendId]) ->
  gen_server2:apply_async(misc:whereis_name({local, robot_mod}), {?MODULE, do_login_out, [OpendId]}).
do_login_out(_, OpendId) ->
  erlang:put(OpendId, null).

%% 切换场景记录
change_sence([PlayerState]) ->
  case PlayerState#player_state.is_robot of
    1 ->
      #player_state{open_id = OpenId, player_id = PlayerId, scene_id = SceneId} = PlayerState,
      gen_server2:apply_async(misc:whereis_name({local, robot_mod}), {?MODULE, do_change_sence, [OpenId, PlayerId, SceneId]});
    _ ->
      skip
  end.
%% 修改 场景信息
do_change_sence(_, OpendId, PlayerId, SceneId) ->
  put(OpendId, {PlayerId, SceneId}).


%% 添加机器人
check_robot([ScendId]) ->
  gen_server2:apply_async(misc:whereis_name({local, robot_mod}), {?MODULE, check_robot, [ScendId, 0]}).

%% 检测是否可以生成机器人
check_robot(_, SceneId, IsRobot) ->
  PlayerNum = scene_mgr_lib:get_scene_player_num(?SCENEID_NEW, 1),
  case IsRobot =:= 1 orelse SceneId /= ?SCENEID_NEW orelse PlayerNum > 15 of
    true ->
      case PlayerNum > 15 of
        true ->
          check_robot_logout(SceneId);
        _ ->
          skip
      end;
    _ ->
      add_robot(get())
  end.

%% 检测机器人离去
check_robot_logout(ScendId) ->
  logout_robot(get(), ScendId).

%% 添加机器人
add_robot([]) ->
  skip;
add_robot([{Key, _} | H]) ->
  case get(Key) of
    null ->
      put(Key, 0),
      Ip = config:get_socket_ip(),
      Port = config:get_socket_port(),
      ?ERR("~p ", [config:get_robot_path()]),
      rpc:call(config:get_robot_path(), client, start, [Key, Ip, Port, 10]);
    _ ->
      add_robot(H)
  end.

%% 删除机器人
logout_robot([], _SceneId) ->
  skip;
logout_robot([{Key, _} | H], SceneId) ->
  case get(Key) of
    {PlayerId, SceneId1} when SceneId1 =:= SceneId ->
      ?ERR("11112 ~p", [SceneId]),
      player_lib:logout(PlayerId);
    _ ->
      logout_robot(H, SceneId)
  end.

%% 检测玩家是否机器人
is_robot(PlayerId) ->
  case gen_server2:apply_async(misc:whereis_name({local, robot_mod}), {?MODULE, do_check_robot, [PlayerId]}) of
    {ok, 1} ->
      true;
    _ ->
      false
  end.
do_is_robot(_, PlayerId) ->
  IsCheckRobot = lists:keymember(PlayerId, 2, get()),
  {ok, IsCheckRobot}.
%% 检测玩家是否机器人
is_robot_open_id(OpenId, _Platform) ->
  util_erl:get_if(lists:member(OpenId, robot_account_config:get_list()), 1, 0).