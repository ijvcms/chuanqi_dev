%%%-------------------------------------------------------------------
%%% @author yubing
%%% @copyright (C) 2015, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 11. 十二月 2015 11:44
%%%-------------------------------------------------------------------
-module(player_foe_lib).


-include("common.hrl").
-include("record.hrl").
-include("config.hrl").
-include("cache.hrl").
-include("db_record.hrl").
-include("proto.hrl").
-include("gameconfig_config.hrl").
-include("language_config.hrl").


-export([get_foe_list/1, delete_foe/2, add_foe/2, get_foe_list_id/1, ref_foe_info/3]).

%% 获取仇人列表
get_foe_list(PlayerId) ->
	BlackList = player_foe_cache:get_foe_list(PlayerId),
	F = fun(X) ->
		FBase = player_base_cache:select_row(X#db_player_foe.tplayer_id),
		#proto_relationship_info
		{
			name = FBase#db_player_base.name,
			tplayer_id = FBase#db_player_base.player_id,
			lv = FBase#db_player_base.lv,
			career = FBase#db_player_base.career,
			fight = FBase#db_player_base.fight,
			last_offline_time = FBase#db_player_base.last_logout_time,
			isonline = player_lib:is_online_int(X#db_player_foe.tplayer_id)
		}
	end,
	[F(X) || X <- BlackList].

%% 获取仇人的id列表
get_foe_list_id(PlayerId) ->
	BlackList = player_foe_cache:get_foe_list(PlayerId),
	[X#db_player_foe.tplayer_id || X <- BlackList].

%% 刷新仇人信息
ref_foe_info(PlayerId, DelPlayerId, AddPlayerId) when is_integer(PlayerId) ->
	case player_lib:get_player_pid(PlayerId) of
		null ->
			skip;
		Pid ->
			gen_server2:apply_async(Pid, {?MODULE, ref_foe_info, [DelPlayerId, AddPlayerId]})
	end;
ref_foe_info(PlayerState, DelPlayerId, AddPlayerId) ->
	Data = #rep_ref_foe_info{
		del_player_id = DelPlayerId,
		add_player_id = AddPlayerId
	},
	net_send:send_to_client(PlayerState#player_state.socket, 11041, Data).

%% 删除仇人信息
delete_foe(PlayerState, TPlayerId) ->
	player_foe_cache:delete_foe_info(PlayerState#player_state.player_id, TPlayerId),
	ref_foe_info(PlayerState, TPlayerId, 0),
	0.

%% 添加仇人
add_foe(PlayerState, TPlayerId) ->
	%% 不是本服的人，那么就不添加仇人
	case player_id_name_lib:get_ets_player_id_name_by_playerid(TPlayerId) of
		fail ->
			skip;
		_ ->
			PlayerId = PlayerState#player_state.player_id,
			FoeList = player_foe_cache:get_foe_list(PlayerId),
			case lists:keyfind(TPlayerId, #db_player_foe.tplayer_id, FoeList) of
				false ->
					NowNum = length(FoeList),
					case NowNum >= ?GAMECONFIG_MAX_FOE_NUM of
						true ->
							NewFoeList = lists:keysort(#db_player_foe.time, FoeList),
							[OldFoeInfo | _NewFoeList1] = NewFoeList,
							FoeInfo = #db_player_foe
							{
								player_id = PlayerId,
								tplayer_id = TPlayerId,
								time = util_date:unixtime()
							},
							player_foe_cache:update_foe_info(OldFoeInfo#db_player_foe.player_id, OldFoeInfo#db_player_foe.tplayer_id, FoeInfo),
							ref_foe_info(PlayerState, OldFoeInfo#db_player_foe.tplayer_id, FoeInfo#db_player_foe.tplayer_id);
						_ ->
							player_foe_cache:add_foe_info(PlayerId, TPlayerId),
							ref_foe_info(PlayerState, 0, TPlayerId)
					end;
				OldFoeInfo ->
					FoeInfo = #db_player_foe
					{
						player_id = PlayerId,
						tplayer_id = TPlayerId,
						time = util_date:unixtime()
					},
					player_foe_cache:update_foe_info(OldFoeInfo#db_player_foe.player_id, OldFoeInfo#db_player_foe.tplayer_id, FoeInfo)
			end
	end.




