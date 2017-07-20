%%%-------------------------------------------------------------------
%%% @author yubing
%%% @copyright (C) 2015, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 17. 十二月 2015 14:28
%%%-------------------------------------------------------------------
-module(city_pp).


-include("proto.hrl").
-include("record.hrl").
-include("common.hrl").
-include("cache.hrl").
%% API
-export([handle/3]).


%%获取沙巴克管理信息
handle(25000, PlayerState, Data) ->
	?INFO(" 25000 ~p ",[Data]),
	Min = Data#req_city_info_list.min_value,
	Max = Data#req_city_info_list.max_value,
	CityOfficreList = city_lib:get_scene_city_officer_list_all(),
	MemberList = guild_lib:get_proto_guild_member_list(PlayerState, Min, Max),
	MemberNum=guild_lib:get_guild_member_num(PlayerState),
	?INFO(" 25000 ~p ",[CityOfficreList]),
	net_send:send_to_client(PlayerState#player_state.socket, 25000, #rep_city_info_list{min_value = Min, max_value = Max, city_officer_list = CityOfficreList, guild_member_list = MemberList,member_num = MemberNum});

%% 任命官员
handle(25001, PlayerState, Data) ->
	?INFO(" 25001 ~p ",[Data]),
	OfficerId = Data#req_city_appoint_officer.officer_id,
	TPlayerId = Data#req_city_appoint_officer.tplayerId,
	Result = city_lib:appoint_officer(PlayerState, ?SCENEID_SHABAKE, OfficerId, TPlayerId),
	?INFO(" 25001 111 ~p ",[Result]),
	if
		Result>0 ->
			net_send:send_to_client(PlayerState#player_state.socket, 25001, #rep_city_appoint_officer{result = Result});
		true->
			CityOfficreList = city_lib:get_scene_city_officer_list(),
			net_send:send_to_client(PlayerState#player_state.socket,25007,#rep_city_ref__info{city_officer_list = CityOfficreList })
	end;

%% 解雇官员
handle(25002, PlayerState, Data) ->
	TPlayerId = Data#req_city_recall_officer.tplayerId,
	Result = city_lib:recall_officer(PlayerState, ?SCENEID_SHABAKE, TPlayerId),
	if
		Result>0 ->
			net_send:send_to_client(PlayerState#player_state.socket, 25002, #rep_city_recall_officer{result = Result});
		true->
			CityOfficreList = city_lib:get_scene_city_officer_list(),
			net_send:send_to_client(PlayerState#player_state.socket,25007,#rep_city_ref__info{city_officer_list = CityOfficreList })
	end;


%% 获取领取界面的奖励信息
handle(25003, PlayerState, _Data) ->
	Data1 = city_lib:get_reward_info(PlayerState, ?SCENEID_SHABAKE),
	net_send:send_to_client(PlayerState#player_state.socket, 25003, Data1);

%% 领取第一次奖励
handle(25004, PlayerState, _Data) ->
	{ok, PlayerState1, Result} = city_lib:receive_frist(PlayerState, ?SCENEID_SHABAKE),
	net_send:send_to_client(PlayerState#player_state.socket, 25004, #rep_city_receive_frist{result = Result}),
	{ok, PlayerState1};

%% 领取每一次奖励
handle(25008, PlayerState, _Data) ->
	{ok, PlayerState1, Result} = city_lib:receive_every(PlayerState, ?SCENEID_SHABAKE),
	net_send:send_to_client(PlayerState#player_state.socket, 25008, #rep_city_receive_every{result = Result}),
	{ok, PlayerState1};

%% 领取每日奖励
handle(25005, PlayerState, _Data) ->
	{ok, PlayerState1, Result} = city_lib:receive_day(PlayerState, ?SCENEID_SHABAKE),
	net_send:send_to_client(PlayerState#player_state.socket, 25005, #rep_city_receive_day{result = Result}),
	{ok, PlayerState1};

%% 获取沙巴克信息
handle(25006, PlayerState, _Data) ->
	{NextTime,_EndTime} = scene_activity_palace_lib:get_next_start_time(?SCENEID_SHABAKE),
	case city_lib:get_city_officer_player(PlayerState#player_state.player_id, ?SCENEID_SHABAKE) of
		false ->
			SceneInfo = city_lib:get_ets_scene_city(?SCENEID_SHABAKE),
			case SceneInfo#ets_scene_city.city_info of
				null->
					Data1 = #rep_city_info
					{
						city_officer_list = [],
						officer_id = 0,
						occupy_day = 0,
						next_open_time = NextTime
					},
					net_send:send_to_client(PlayerState#player_state.socket, 25006, Data1);
				CityInfo->
					CityInfo = SceneInfo#ets_scene_city.city_info,
					Data1 = #rep_city_info
					{
						city_officer_list = city_lib:get_scene_city_officer_list_all(),
						officer_id = 0,
						occupy_day = (util_date:get_today_unixtime() - CityInfo#db_city_info.occupy_time) div ?DAY_TIME_COUNT,
						guild_name = guild_lib:get_guild_name(CityInfo#db_city_info.guild_id),
						next_open_time = NextTime
					},
					?INFO(" 25006 ~p ",[Data1]),
					net_send:send_to_client(PlayerState#player_state.socket, 25006, Data1)
			end;
		CityOfficeInfo ->
			SceneInfo = city_lib:get_ets_scene_city(?SCENEID_SHABAKE),
			CityInfo = SceneInfo#ets_scene_city.city_info,

			Data1 = #rep_city_info
			{
				city_officer_list = city_lib:get_scene_city_officer_list_all(),
				officer_id = CityOfficeInfo#db_city_officer.officer_id,
				occupy_day = (util_date:get_today_unixtime() - CityInfo#db_city_info.occupy_time) div ?DAY_TIME_COUNT,
				guild_name = guild_lib:get_guild_name(CityInfo#db_city_info.guild_id),
				next_open_time = NextTime
			},
			net_send:send_to_client(PlayerState#player_state.socket, 25006, Data1)
	end;

handle(Cmd, PlayerState, Data) ->
	?ERR("not define ~p cmd:~nstate: ~p~ndata: ~p", [Cmd, PlayerState, Data]),
	{ok, PlayerState}.

