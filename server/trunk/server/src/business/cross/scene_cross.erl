%%%-------------------------------------------------------------------
%%% @author yubing
%%% @copyright (C) 2016, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 30. 五月 2016 16:57
%%%-------------------------------------------------------------------
-module(scene_cross).

-include("record.hrl").
-include("cache.hrl").
-include("common.hrl").
-include("proto.hrl").
-include("language_config.hrl").

%% API
-export([
	send_cross/1,
	send_gen_server/2,
	send_to_client/2,
	send_cross_mod/4,
	send_to_client/3,
	send_to_mfc/4,
	send_log_out/1,
	ref_cross_goods/1,
	get_ets_player/1
]).

%% 连接跨服场景
send_cross(PlayerState) ->
	Base = PlayerState#player_state.db_player_base,
	PlayerState1 = PlayerState#player_state{
		server_pass = config:get_cross_path(),
		guild_name = guild_lib:get_guild_name(Base#db_player_base.guild_id),
		server_pass_my = node()
	},
	GoodsList = goods_dict:get_player_goods_list(),
	EquipList = goods_dict:get_player_equips_list(),
	BagCell = goods_dict:get_bag_cell(),
	case rpc:call(PlayerState1#player_state.server_pass, scene_cross, init, [PlayerState1, {EquipList, GoodsList, BagCell}]) of
		ok ->
			team_lib:leave_team(PlayerState),
			{ok, PlayerState1};
		_ ->
			?INFO("~p", [PlayerState1#player_state.server_pass]),
			{fail, ?ERR_CROSS}
	end.

%% 执行跨服场景的 对应函数信息
send_cross_mod(PlayerState, legion_pp, Cmd, Data) ->
	cross_boss_lib:handle(PlayerState, legion_pp, Cmd, Data);
send_cross_mod(PlayerState, Mod, Cmd, Data) ->
	case not util_data:is_null(PlayerState#player_state.server_pass) andalso
		lists:member(Mod, [scene_pp, skill_pp, team_pp, chat_pp]) of
		true ->
			?INFO("111 ~p", [{Cmd, Data}]),
			cross_boss_lib:handle(Mod, Cmd, Data, PlayerState, false);
		_ ->
			null
	end.


%% 刷新跨服物品的数据信息
ref_cross_goods(PlayerState) when is_record(PlayerState, player_state) ->
	#player_state{server_pass = ServerPass, player_id = PlayerId} = PlayerState,
	case not util_data:is_null(ServerPass) of
		true ->
			ref_cross_goods(PlayerId, ServerPass);
		_ ->
			skip
	end.
%% 刷新跨服物品的数据信息
ref_cross_goods(PlayerId, ServerPass) ->
	GoodsList = goods_dict:get_player_goods_list(),
	EquipList = goods_dict:get_player_equips_list(),
	BagCell = goods_dict:get_bag_cell(),
	rpc:call(ServerPass, scene_cross, ref_cross_goods, [PlayerId, {EquipList, GoodsList, BagCell}]).

%% 玩家登出 如果在跨服的话，告诉跨服场景
send_log_out(PlayerState) ->
	case not util_data:is_null(PlayerState#player_state.server_pass) of
		true ->
			?INFO("111 ~p", [2222]),
			rpc:call(PlayerState#player_state.server_pass, scene_cross, log_out, [PlayerState]),
			PlayerState#player_state{
				server_pass = null
			};
		_ ->
			PlayerState
	end.

get_ets_player(_) ->
	null.


%%************************************************************************
%% 内部方法
%%************************************************************************
%% 发送给玩家的gen_server
send_gen_server(PlayerId, Data) when is_integer(PlayerId) ->
	case player_lib:get_player_pid(PlayerId) of
		null ->
			skip;
		Pid ->
			send_gen_server(Pid, Data)
	end;
send_gen_server(Pid, Data) when is_pid(Pid) ->
	gen_server2:cast(Pid, Data);
send_gen_server(PlayerId, Data) ->
	case player_lib:get_player_pid(PlayerId) of
		null ->
			skip;
		Pid ->
			gen_server2:cast(Pid, Data)
	end.

%% 直接发送数据
send_to_client(PlayerId, Bin) when is_integer(PlayerId) ->
	case player_lib:get_player_pid(PlayerId) of
		null ->
			skip;
		Pid ->
			send_to_client(Pid, Bin)
	end;
send_to_client(Pid, Bin) when is_pid(Pid) ->
	gen_server2:apply_async(Pid, {?MODULE, send_to_client, [Bin]});
send_to_client(PlayerState, Bin) ->
	net_send:send_one(PlayerState#player_state.socket, Bin).

%% 发送数据 包含 cmd
send_to_client(Pid, Cmd, Data) when is_pid(Pid) ->
	gen_server2:apply_async(Pid, {?MODULE, send_to_client, [Cmd, Data]});
send_to_client(PlayerState, Cmd, Data) ->
	net_send:send_to_client(PlayerState#player_state.socket, Cmd, Data).

%% 调用方法
send_to_mfc(PlayerId, M, F, C) ->
	Pid = player_lib:get_player_pid(PlayerId),
	gen_server2:apply_sync(Pid, {M, F, C}).

