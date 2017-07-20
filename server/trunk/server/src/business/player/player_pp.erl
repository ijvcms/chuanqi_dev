%%%-------------------------------------------------------------------
%%% @author zhengsiying
%%% @copyright (C) 2015, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 21. 七月 2015 上午11:09
%%%-------------------------------------------------------------------
-module(player_pp).

-include("common.hrl").
-include("record.hrl").
-include("proto.hrl").
-include("language_config.hrl").
-include("cache.hrl").

%% API
-export([
	handle/3
]).

%% ====================================================================
%% API functions
%% ====================================================================
%% 获取创建角色列表
handle(10000, ClientState, Data) when is_record(ClientState, tcp_client_state) ->
	#req_player_list{
		open_id = OpenId,
		platform = Platform,
		server_id = ClientServerId
	} = Data,

	account_lib:login(OpenId, Platform, self(), ClientState#tcp_client_state.socket),
	List = player_lib:get_player_list_data(OpenId, Platform, ClientServerId),

	net_send:send_to_client(ClientState#tcp_client_state.socket, 10000, #rep_player_list{player_list = List}),
	{ok, ClientState#tcp_client_state{open_id = OpenId, platform = Platform}};

%% 创建角色
handle(10001, ClientState, Data) when is_record(ClientState, tcp_client_state) ->
	case player_lib:create(Data) of
		{ok, ProtoInfo} ->
			net_send:send_to_client(ClientState#tcp_client_state.socket, 10001, #rep_create{player_info = ProtoInfo}),
			{ok, ClientState};
		{fail, Err} ->
			net_send:send_to_client(ClientState#tcp_client_state.socket, 10001, #rep_create{result = Err}),
			{fail, Err}
	end;

%% 进入游戏
handle(10002, ClientState, Data) when is_record(ClientState, tcp_client_state) ->
%% 	io:format("begin  login:~p~n", [util_date:longunixtime()]),
	case player_lib:login(ClientState, Data) of
		{fail, Err} ->
			net_send:send_to_client(ClientState#tcp_client_state.socket, 10002, #rep_enter{result = Err}),
			{fail, Err};
		{ok, NewClientState} ->
%% 			io:format("finish login:~p~n", [util_date:longunixtime()]),
			net_send:send_to_client(ClientState#tcp_client_state.socket, 10002, #rep_enter{}),
			{ok, NewClientState}
	end;

%% %% 机器人进入游戏
%% handle(10099, ClientState, Data) when is_record(ClientState, tcp_client_state) ->
%% 	Data1 = #req_enter{
%% 		player_id = Data#req_enter_robot.player_id,
%% 		open_id = Data#req_enter_robot.open_id,
%% 		platform = Data#req_enter_robot.platform,
%% 		os_type = Data#req_enter_robot.os_type
%% 	},
%% 	case erlang:binary_to_list(Data#req_enter_robot.key) of
%% 		"td2015" ->
%% 			case player_lib:login(ClientState, Data1) of
%% 				{fail, Err} ->
%% 					net_send:send_to_client(ClientState#tcp_client_state.socket, 10002, #rep_enter{result = Err}),
%% 					{fail, Err};
%% 				{ok, NewClientState} ->
%% 					net_send:send_to_client(ClientState#tcp_client_state.socket, 10002, #rep_enter{}),
%% 					{ok, NewClientState}
%% 			end;
%% 		_ ->
%% 			skip
%% 	end;

%% 玩家主动退出
handle(10007, ClientState, Data) when is_record(ClientState, tcp_client_state) ->
	Flag = Data#req_logout.flag,
	%%Platform = ClientState#tcp_client_state.platform,
	%%OpenId = ClientState#tcp_client_state.open_id,
	PlayerId = ClientState#tcp_client_state.player_id,
	case Flag of
	%% 账号退出
		?LOGOUT_FLAG_ACCOUNT ->
			account_lib:logout(ClientState),
			net_send:send_to_client(ClientState#tcp_client_state.socket, 10007, #rep_logout{flag = ?LOGOUT_FLAG_ACCOUNT}),
			{ok, ClientState#tcp_client_state{open_id = null, platform = null, player_id = null, player_pid = null}};
	%% 角色退出
		?LOGOUT_FLAG_PLAYER ->
			player_lib:logout(PlayerId),
			net_send:send_to_client(ClientState#tcp_client_state.socket, 10007, #rep_logout{flag = ?LOGOUT_FLAG_PLAYER}),
			{ok, ClientState#tcp_client_state{player_id = null, player_pid = null}};
		_ ->
			skip
	end;

%% 获取玩家信息
handle(10003, PlayerState, _Data) ->
	?INFO("10003 ~p", [_Data]),
	ProtoPlayerInfo = player_lib:get_player_detail_data(PlayerState),
	net_send:send_to_client(PlayerState#player_state.socket, 10003, #rep_player_info{player_info = ProtoPlayerInfo});

%% 玩家复活
handle(10005, PlayerState, Data) ->
	?INFO("10005 ~p", [Data]),
	ReviveType = Data#req_revive.type,
	case player_lib:revive(PlayerState, ReviveType) of
		{ok, NewPlayerState} ->
			net_send:send_to_client(PlayerState#player_state.socket, 10005, #rep_revive{}),
			{ok, NewPlayerState};
		{fail, Err} ->
			net_send:send_to_client(PlayerState#player_state.socket, 10005, #rep_revive{result = Err}),
			{fail, Err}
	end;

%% 心跳包(不做任何修改，在每次收包的时候就已经更新心跳)
handle(10006, ClientState, _Data) when is_record(ClientState, tcp_client_state) ->
	CurTime = util_date:unixtime(),
%% 	ClientTime = Data#req_heart.client_time,
%% 	case CurTime - ClientTime > 360 of
%% 		true ->
%% 			?ERR("~p", [ClientState#tcp_client_state.open_id]);
%% 		_ ->
%% 			skip
%% 	end,
	net_send:send_to_client(ClientState#tcp_client_state.socket, 10006, #rep_heart{server_time = CurTime}),
	{ok, ClientState};

%% 切换PK模式
handle(10008, PlayerState, Data) ->
	PkMode = Data#req_change_pk_mode.pk_mode,
	case player_lib:chang_pk_mode(PlayerState, PkMode) of
		{ok, NewPlayerState} ->
			net_send:send_to_client(NewPlayerState#player_state.socket, 10008, #rep_change_pk_mode{pk_mode = PkMode}),
			{ok, NewPlayerState};
		_ ->
			net_send:send_to_client(PlayerState#player_state.socket, 10008, #rep_change_pk_mode{result = ?ERR_COMMON_FAIL, pk_mode = PkMode})
	end;

handle(10009, ClientState, Data) when is_record(ClientState, tcp_client_state) ->
	PlayerId = Data#req_delete_player.player_id,
	account_lib:delete_player(ClientState#tcp_client_state.open_id, ClientState#tcp_client_state.platform, PlayerId),
	net_send:send_to_client(ClientState#tcp_client_state.socket, 10009, #rep_delete_player{player_id = PlayerId});

%% 玩家死亡，复活界面
handle(10010, PlayerState, #req_player_die{caster_name = CasterName}) ->
	DbPlayerBase = PlayerState#player_state.db_player_base,
	%% vip免费复活次数
	VipFhNum = vip_lib:get_vip_fh_num(PlayerState#player_state.player_id, DbPlayerBase#db_player_base.career, DbPlayerBase#db_player_base.vip),
	net_send:send_to_client(PlayerState#player_state.socket, 10010, #rep_player_die{caster_name = CasterName, fh_vip_num = VipFhNum});

%% 获取玩家信息
handle(10011, PlayerState, #req_get_player_info{player_id = PlayerId}) ->
	player_lib:get_player_detailed_info(PlayerState, PlayerId);

%% 获取玩家状态图标
handle(10012, PlayerState, _Data) ->
	buff_base_lib:send_buff_info(PlayerState);

%% 设置翅膀显示状态
handle(10013, PlayerState, #req_change_wing_state{state = State, subtype = SubType}) when State =< 1 ->
	DbBase = PlayerState#player_state.db_player_base,
	DbBase1 =
		case SubType of
			?SUBTYPE_WING ->
				DbBase#db_player_base{wing_state = State};
			?SUBTYPE_SP_WEAPON ->
				DbBase#db_player_base{weapon_state = State};
			_ ->
				DbBase
		end,
	PS1 = PlayerState#player_state{db_player_base = DbBase1},
	PS2 = goods_lib:update_guise_state(PS1),
	{ok, PS3} = player_lib:update_player_state(PlayerState, PS2),
	net_send:send_to_client(PlayerState#player_state.socket, 10013, #rep_change_wing_state{subtype = SubType, state = State}),
	{ok, PS3};

%% 切换宠物攻击模式
handle(10014, PlayerState, _Data) ->
	pet_lib:change_att_type(PlayerState);

handle(10015, PlayerState, #req_upgrade_mark{type = Type}) ->
	case player_mark_lib:upgrade_mark(PlayerState, Type) of
		{ok, PlayerState1} ->
			net_send:send_to_client(PlayerState#player_state.socket, 10015, #rep_upgrade_mark{result = ?ERR_COMMON_SUCCESS}),
			active_service_lib:ref_button_tips(PlayerState1, ?ACTIVE_SERVICE_TYPE_MARK);
		{fail, Reply} ->
			net_send:send_to_client(PlayerState#player_state.socket, 10015, #rep_upgrade_mark{result = Reply})
	end;

%% 获取玩家的副本剩余时间
handle(10016, PlayerState, _Data) ->
	?INFO("10016 ~p", [_Data]),
	player_lib:get_player_extra_data(PlayerState);

%% 获取玩家的扩展状态
handle(10017, PlayerState, Data) ->
	#req_player_extra_push{push_list = PushList} = Data,
	player_extra_lib:request(PlayerState, PushList);

%% 获取服务器时间信息
handle(10018, PlayerState, _Data) ->
	{{OpenY, OpenM, OpenD}, {_, _, _}} = config:get_start_time_str(),
	BeginTime = util_date:time_tuple_to_unixtime({{OpenY, OpenM, OpenD}, {0, 0, 0}}),
	OpenDays = max(1, util_erl:ceil((util_date:unixtime() - BeginTime) / 86400)),
	Rep = #rep_time_info{open_days = OpenDays, server_time = util_date:unixtime()},
	net_send:send_to_client(PlayerState#player_state.socket, 10018, Rep);

handle(Cmd, State, Data) ->
	?ERR("not define ~p cmd:~nstate: ~p~ndata: ~p", [Cmd, State, Data]),
	{ok, State}.
%% ====================================================================
%% Internal functions
%% ====================================================================
