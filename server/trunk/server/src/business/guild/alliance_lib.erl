%%%-------------------------------------------------------------------
%%% @author qhb
%%% @copyright (C) 2016, <COMPANY>
%%% @doc
%%%	行会结盟
%%% @end
%%% Created : 14. 十一月 2016 上午11:05
%%%-------------------------------------------------------------------
-module(alliance_lib).
-include("common.hrl").
-include("record.hrl").
-include("cache.hrl").
-include("language_config.hrl").
-include("config.hrl").
-include("proto.hrl").
-include("notice_config.hrl").
-include("main_record.hrl").
-include("uid.hrl").

-define(ALLIANCE_MEMBER_LIMIT, 5).    %%结盟成员数量
-define(ALLIANCE_REQ_LIMIT, 2).        %%给每一个行会发送结盟请求的数次

%% API
-export([
	init/0,
	apply/4,
	answer/5,
	exit/1,
	kick/3,
	check_state/1,
	guild_info/1,
	guild_info/2,
	get_guild_name/1,
	is_guild_alliance/2,
	reset/0,
	alliance_exit/1
]).

%% GEN API
-export([
	apply_local/5,
	answer_local/6,
	exit_local/2,
	kick_local/4,
	check_state_local/2,
	guild_info_local/2,
	guild_info_local/3,
	send_mail_local/3
]).

%%初始化
init() ->
	ets:new(?ETS_GUILD_ALLIANCE, [{keypos, #ets_guild_alliance.id}, named_table, public, set]),
	ets:new(?ETS_GUILD_ALLIANCE_STATE, [{keypos, #ets_guild_alliance_state.guild_id}, named_table, public, set]),

	%% 缓存工会状态信息
	GuildList = guild_alliance_cache:select_all(),
	F = fun(#db_guild_alliance{guild_id = GuildId, alliance_id = AId}, Acc) ->
		EtsState = #ets_guild_alliance_state{
			guild_id = GuildId,
			alliance_id = AId
		},
		ets:insert(?ETS_GUILD_ALLIANCE_STATE, EtsState),
		case lists:keyfind(AId, 1, Acc) of
			false ->
				[{AId, [GuildId]} | Acc];
			{_, List} ->
				List1 = [GuildId | List],
				lists:keyreplace(AId, 1, Acc, {AId, List1})
		end
	end,
	AidList = lists:foldl(F, [], GuildList),

	%% 缓存id信息
	F1 = fun({Aid, GuildIdList}) ->
		Ets_Guild_Alliance = #ets_guild_alliance{
			id = Aid,
			guild_list = GuildIdList
		},
		ets:insert(?ETS_GUILD_ALLIANCE, Ets_Guild_Alliance)
	end,
	[F1(X) || X <- AidList],
	ok.

%%发送结盟请求,模式1(GuildId)找对对方的任何人都可以发,模式2(PlayerId)需要找到对方会长或副会长才能发,
apply(PlayerState, ServerIdB, GuildIdB, PlayerIdB) ->
	#player_state{player_id = PlayerId, server_pass = ServerPass,
		db_player_base = #db_player_base{guild_id = GuildId, scene_id = SceneId}} = PlayerState,
	case scene_config:get(SceneId) of
		#scene_conf{is_cross = 1} ->
			case is_leader(PlayerId, GuildId) of
				true ->
					gen_server2:cast({alliance_mod, ServerPass}, {?MODULE, apply_local,
						[PlayerState, ServerIdB, GuildIdB, PlayerIdB]});
				false ->
					Rep1 = #rep_guild_alliance_apply{result = ?ERR_NO_PERMISSION},
					net_send:send_to_client(PlayerId, 17085, Rep1)
			end;
		_ ->
			case is_leader(PlayerId, GuildId) of
				true ->
					gen_server2:cast(alliance_mod, {?MODULE, apply_local,
						[PlayerState, ServerIdB, GuildIdB, PlayerIdB]});
				false ->
					Rep1 = #rep_guild_alliance_apply{result = ?ERR_NO_PERMISSION},
					net_send:send_to_client(PlayerId, 17085, Rep1)
			end
	end.
apply_local(State, PlayerState, _ServerIdB, GuildIdB, _PlayerIdB) ->
	case check_alliance_apply(PlayerState, GuildIdB) of
		{fail, Err} ->
			RepA = #rep_guild_alliance_apply{result = Err},
			net_send:send_to_client(PlayerState#player_state.player_id, 17085, RepA);
		{ok, {_ServerNodeB, OnlineLeaders}} ->
			#player_state{db_player_base = DbBase, server_no = ServerIdA} = PlayerState,
			GuildNameA = guild_lib:get_guild_name(DbBase#db_player_base.guild_id),
			#db_player_base{player_id = PlayerIdA, name = NameA, guild_id = GuildIdA} = DbBase,
			%%保存请求
			allicance_req(GuildIdA, GuildIdB),
			%%给自己的结果
			Rep1 = #rep_guild_alliance_apply{result = ?ERR_COMMON_SUCCESS},
			net_send:send_to_client(PlayerIdA, 17085, Rep1),

%% 			%%发给对方
%% 			Rep2 = #rep_guild_alliance_invite{server_id_a = ServerIdA, guild_id_a = GuildIdA, guild_name_a = GuildNameA,
%% 				player_id_a = PlayerIdA, player_name_a = NameA},
%% 			net_send:send_to_client(PlayerIdB, 17086, Rep2)
			%%发给对方
			[begin
				 Rep2 = #rep_guild_alliance_invite{server_id_a = ServerIdA, guild_id_a = GuildIdA, guild_name_a = GuildNameA,
					 player_id_a = PlayerIdA, player_name_a = NameA},
				 net_send:send_to_client(LeaderId, 17086, Rep2)
			 end || LeaderId <- OnlineLeaders]
	end,
	{ok, State}.

%%应答结盟请求
answer(PlayerState, _ServerIdA, GuildIdA, PlayerIdA, Type) ->
	ServerPass = PlayerState#player_state.server_pass,
	case util_data:is_null(ServerPass) of
		true ->
			gen_server2:cast(alliance_mod, {?MODULE, answer_local,
				[PlayerState, _ServerIdA, GuildIdA, PlayerIdA, Type]});
		_ ->
			gen_server2:cast({alliance_mod, ServerPass}, {?MODULE, answer_local,
				[PlayerState, _ServerIdA, GuildIdA, PlayerIdA, Type]})
	end.

answer_local(State, PlayerState, _ServerIdA, GuildIdA, PlayerIdA, Type) ->
	%%对方可能发多个请求给不同的行会,所以需要检查是否已经满员
	{ok, Result} =
		case Type =:= 1 of
			true ->
				#player_state{db_player_base = DbBase, server_no = ServerIdB} = PlayerState,
				GuildNameB = guild_lib:get_guild_name(DbBase#db_player_base.guild_id),
				#db_player_base{player_id = PlayerIdB, name = NameB, guild_id = GuildIdB} = DbBase,
				case check_alliance_enalbe(GuildIdA, GuildIdB) of
					{fail, Err} ->
						{ok, Err};
					_ ->
						%%结盟
						alliance_join(GuildIdA, GuildIdB),
						%%反馈给发起方
						Rep2 = #rep_guild_alliance_result{server_id_b = ServerIdB, guild_id_b = GuildIdB, guild_name_b = GuildNameB,
							player_id_b = PlayerIdB, player_name_b = NameB},
						net_send:send_to_client(PlayerIdA, 17088, Rep2),
						{ok, ?ERR_COMMON_SUCCESS}
				end;
			false ->
				{ok, ?ERR_COMMON_SUCCESS}
		end,
	%%给自己的结果
	Rep1 = #rep_guild_alliance_answer{result = Result, type = Type},
	net_send:send_to_client(PlayerState#player_state.player_id, 17087, Rep1),
	{ok, State}.

%%退出结盟
exit(PlayerState) ->
	#player_state{player_id = PlayerId, server_pass = ServerPass,
		db_player_base = #db_player_base{guild_id = GuildId}} = PlayerState,
	case is_leader(PlayerId, GuildId) of
		true ->
			case util_data:is_null(ServerPass) of
				true ->
					gen_server2:cast(alliance_mod, {?MODULE, exit_local,
						[PlayerState]});
				_ ->
					gen_server2:cast({alliance_mod, ServerPass}, {?MODULE, exit_local,
						[PlayerState]})
			end;
		false ->
			Rep1 = #rep_guild_alliance_exit{result = ?ERR_NO_PERMISSION},
			net_send:send_to_client(PlayerId, 17089, Rep1)
	end.

exit_local(State, PlayerState) ->
	#player_state{db_player_base = DbBase} = PlayerState,
	#db_player_base{player_id = PlayerIdA, guild_id = GuildIdA} = DbBase,
	alliance_exit(GuildIdA),
	Rep1 = #rep_guild_alliance_exit{result = ?ERR_COMMON_SUCCESS},
	net_send:send_to_client(PlayerIdA, 17089, Rep1),
	{ok, State}.

%%踢出结盟
kick(PlayerState, ServerIdB, GuildIdB) ->
	#player_state{player_id = PlayerId, server_pass = ServerPass,
		db_player_base = #db_player_base{guild_id = GuildId}} = PlayerState,
	case is_leader(PlayerId, GuildId) of
		true ->
			case util_data:is_null(ServerPass) of
				true ->
					gen_server2:cast(alliance_mod, {?MODULE, kick_local,
						[PlayerState, ServerIdB, GuildIdB]});
				_ ->
					gen_server2:cast({alliance_mod, ServerPass}, {?MODULE, kick_local,
						[PlayerState, ServerIdB, GuildIdB]})
			end;
		false ->
			Rep1 = #rep_guild_alliance_kick{result = ?ERR_NO_PERMISSION},
			net_send:send_to_client(PlayerId, 17090, Rep1)
	end.

kick_local(State, PlayerState, _ServerIdB, GuildIdB) ->
	#player_state{db_player_base = DbBase} = PlayerState,
	#db_player_base{player_id = PlayerIdA, name = Name, guild_id = GuildIdA} = DbBase,
	alliance_exit(GuildIdB),
	GuildNameA = guild_lib:get_guild_name(GuildIdA),
	%%发给自己
	Rep1 = #rep_guild_alliance_kick{result = ?ERR_COMMON_SUCCESS},
	net_send:send_to_client(PlayerIdA, 17090, Rep1),
	%%发给对方
	Rep2 = #rep_guild_alliance_out{guild_id = GuildIdB, guild_name = GuildNameA, player_name = Name},
	PlayerList = guild_lib:get_online_players_postion(GuildIdB, ?FU_HUIZHANG),
	[net_send:send_to_client(X#ets_online.pid, 17091, Rep2) || X <- PlayerList],
	{ok, State}.


%%发送玩家的结盟状态
check_state(PlayerState) ->
	#player_state{server_pass = ServerPass, db_player_base = #db_player_base{scene_id = SceneId}} = PlayerState,
	case scene_config:get(SceneId) of
		#scene_conf{is_cross = 1} ->
			gen_server2:cast({alliance_mod, ServerPass}, {?MODULE, check_state_local,
				[PlayerState]});
		_ ->
			gen_server2:cast(alliance_mod, {?MODULE, check_state_local,
				[PlayerState]})
	end.
check_state_local(State, PlayerState) ->
	%%?WARNING("check state2",[]),
	#player_state{db_player_base = DbBase} = PlayerState,
	#db_player_base{player_id = PlayerIdA, guild_id = GuildIdA} = DbBase,
	GuildIdList =
		case ets:lookup(?ETS_GUILD_ALLIANCE_STATE, GuildIdA) of
			[] ->
				[];
			[#ets_guild_alliance_state{alliance_id = Aid}] ->
				case ets:lookup(ets_guild_alliance, Aid) of
					[] ->
						[];
					[#ets_guild_alliance{guild_list = List01}] ->
						List01
				end
		end,
	GuildList2 = [get_guild_info(R) || R <- GuildIdList],
	List = [#proto_guild_simple_info{server_id = pack_server_id(ServerNo2), guild_id = GuildId2, guild_name = GuildName2}
		|| #ets_guild_info{server_no = ServerNo2, guild_id = GuildId2, guild_name = GuildName2} <- GuildList2],
	Rep1 = #rep_guild_alliance_state_push{list = List},
	net_send:send_to_client(PlayerIdA, 17092, Rep1),
	{ok, State}.

%%发送玩家的结盟列表
guild_info(PlayerState) ->
	#player_state{server_pass = ServerPass, db_player_base = #db_player_base{scene_id = SceneId}} = PlayerState,
	case scene_config:get(SceneId) of
		#scene_conf{is_cross = 1} ->
			gen_server2:cast({alliance_mod, ServerPass}, {?MODULE, guild_info_local,
				[PlayerState]});
		_ ->
			gen_server2:cast(alliance_mod, {?MODULE, guild_info_local,
				[PlayerState]})
	end.
guild_info_local(State, PlayerState) ->
	#player_state{db_player_base = DbBase} = PlayerState,
	#db_player_base{player_id = PlayerIdA, guild_id = GuildIdA} = DbBase,
	GuildIdList =
		case ets:lookup(?ETS_GUILD_ALLIANCE_STATE, GuildIdA) of
			[] ->
				[];
			[#ets_guild_alliance_state{alliance_id = Aid}] ->
				case ets:lookup(?ETS_GUILD_ALLIANCE, Aid) of
					[] ->
						[];
					[#ets_guild_alliance{guild_list = List01}] ->
						List01
				end
		end,
	GuildList2 = [get_guild_info(R) || R <- GuildIdList],
	Fun = fun(#ets_guild_info{server_no = ServerNo2, guild_id = GuildId2, guild_name = GuildName2, server = Server}) ->
		#db_guild{member_count = MemberCount, chief_name = ChiefName, lv = GuildLv} = alliance_guild_info(Server, GuildId2),
		#proto_guild_standard_info{server_id = pack_server_id(ServerNo2), guild_id = GuildId2, guild_name = GuildName2,
			number = MemberCount, chairman_name = ChiefName, guild_lv = GuildLv}
	end,
	List = [Fun(E) || E <- GuildList2],
	Rep1 = #rep_guild_alliance_info{list = List},
	net_send:send_to_client(PlayerIdA, 17093, Rep1),
	{ok, State}.

%%跨服帮会信息
guild_info(PlayerState, GuildId) ->
	#player_state{server_pass = ServerPass, db_player_base = #db_player_base{scene_id = SceneId}} = PlayerState,
	case scene_config:get(SceneId) of
		#scene_conf{is_cross = 1} ->
			gen_server2:cast({alliance_mod, ServerPass}, {?MODULE, guild_info_local,
				[PlayerState, GuildId]});
		_ ->
			gen_server2:cast(alliance_mod, {?MODULE, guild_info_local,
				[PlayerState, GuildId]})
	end.
guild_info_local(State, PlayerState, GuildId) ->
	#ets_guild_info{server_no = ServerNo2, guild_id = GuildId2, guild_name = GuildName2, server = Server} = get_guild_info(GuildId),
	#db_guild{member_count = MemberCount, chief_name = ChiefName, lv = GuildLv} = alliance_guild_info(Server, GuildId2),
	Proto = #proto_guild_standard_info{server_id = pack_server_id(ServerNo2), guild_id = GuildId2, guild_name = GuildName2,
		number = MemberCount, chairman_name = ChiefName, guild_lv = GuildLv},
	Rep1 = #rep_guild_alliance_guild{result = 0, guild_info = Proto},
	net_send:send_to_client(PlayerState#player_state.player_id, 17094, Rep1),
	{ok, State}.

%%判断是否已经结盟
is_guild_alliance(GuildA, GuildB) ->
	case ets:lookup(?ETS_GUILD_ALLIANCE_STATE, GuildA) of
		[] -> false;
		[#ets_guild_alliance_state{alliance_id = Aid1}] ->
			case Aid1 =:= 0 of
				true -> false;
				_ ->
					case ets:lookup(?ETS_GUILD_ALLIANCE_STATE, GuildB) of
						[] -> false;
						[#ets_guild_alliance_state{alliance_id = Aid2}] when Aid1 =/= Aid2 -> false;
						_ -> true
					end

			end
	end.

get_guild_name(GuildId) ->
	case guild_cache:get_guild_info_from_ets(GuildId) of
		#db_guild{guild_name = GuildName} ->
			GuildName;
		_ ->
			""
	end.

%%跨服副本关闭后清除结盟
reset() ->
	ets:delete_all_objects(?ETS_GUILD_ALLIANCE),
	ets:delete_all_objects(?ETS_GUILD_ALLIANCE_STATE),
	ok.

%%验证结盟请求
check_alliance_apply(PlayerState, GuildIdB) ->
	DbBase = PlayerState#player_state.db_player_base,
	#db_player_base{player_id = _PlayerId, guild_id = GuildIdA} = DbBase,
	case util:loop_functions(
		none,
		[
			%%已经结盟的，不能再结盟了
			fun(_) ->
				case ets:lookup(?ETS_GUILD_ALLIANCE_STATE, GuildIdB) of
					[] -> {continue, none};
					_ -> {break, ?ERR_GUILD_ALLIANCE}
				end
			end,
			fun(_) ->
				%%结盟帮必要条件检查
				case check_alliance_enalbe(GuildIdA, GuildIdB) of
					{fail, ErrCode} ->
						{break, ErrCode};
					_ ->
						{continue, none}
				end
			end,
			fun(_) ->
				%%一天内请求太多,防骚扰
				IsReqTooMany =
					case ets:lookup(?ETS_GUILD_ALLIANCE_STATE, GuildIdA) of
						[] -> true;
						[#ets_guild_alliance_state{request_list = ReqList}] ->
							case lists:keyfind(GuildIdB, 1, ReqList) of
								false -> true;
								{_, CurTime, Times} ->
									case CurTime < util_date:unixtime() of
										true ->
											true;
										_ ->
											Times < ?ALLIANCE_REQ_LIMIT
									end
							end
					end,
				case IsReqTooMany of
					false ->
						{break, ?ERR_GUILD_ALLIANCE_REQ_LIMIT};
					true ->
						{continue, none}
				end
			end,
			fun(_) ->
				%%查找对方节点
				case guild_cache:get_guild_info_from_ets(GuildIdB) of
					#db_guild{} ->
						{continue, config:get_server_no()};
					_ ->
						{break, ?ERR_COMMON_FAIL}
				end
			end,
			fun(ServerNodeB) ->
				Leaders = allicance_guild_leaders(ServerNodeB, GuildIdB),
				case Leaders of
					[] ->
						{break, ?ERR_GUILD_ALLIANCE_LEADER_NOT_CROSS};
					[_ | _] ->
						{continue, {ServerNodeB, Leaders}}
				end
			end
		]
	) of
		{break, Reply} -> {fail, Reply};
		{ok, Value} -> {ok, Value}
	end.

%%能结盟的必要条件检查
check_alliance_enalbe(GuildIdA, GuildIdB) ->
	case util:loop_functions(
		none,
		[
			fun(_) ->
				%%不能是相同的行会
				case GuildIdA =:= GuildIdB of
					true ->
						{break, ?ERR_COMMON_FAIL};
					false ->
						{continue, none}
				end
			end,
			fun(_) ->
				%%已经是盟友
				case is_guild_alliance(GuildIdA, GuildIdB) of
					true ->
						{break, ?ERR_GUILD_ALLIANCE_ALREADY};
					false ->
						{continue, none}
				end
			end,
			fun(_) ->
				%%是对立的结盟
				Aid1 = get_guild_aliance_id(GuildIdA),
				Aid2 = get_guild_aliance_id(GuildIdB),
				case Aid1 =/= 0 andalso Aid1 =:= Aid2 of
					true ->
						{break, ?ERR_GUILD_ALLIANCE_ENEMY};
					false ->
						{continue, none}
				end
			end,
			fun(_) ->
				%%自己的结盟帮会已经超出3个
				case get_alliance_member_count(GuildIdA) >= ?ALLIANCE_MEMBER_LIMIT of
					true ->
						{break, ?ERR_GUILD_ALLIANCE_MEMBER_LIMIT1};
					false ->
						{continue, none}
				end
			end,
			fun(_) ->
				%%结盟帮会不能超出3个
				case get_alliance_member_count(GuildIdB) >= ?ALLIANCE_MEMBER_LIMIT of
					true ->
						{break, ?ERR_GUILD_ALLIANCE_MEMBER_LIMIT2};
					false ->
						{continue, none}
				end
			end
		]
	) of
		{break, Reply} -> {fail, Reply};
		{ok, Value} -> {ok, Value}
	end.

%%检查结盟帮会数量
get_alliance_member_count(GuildId) ->
	case ets:lookup(?ETS_GUILD_ALLIANCE_STATE, GuildId) of
		[] -> 0;
		[#ets_guild_alliance_state{alliance_id = Aid}] ->
			case Aid =:= 0 of
				true -> 0;
				_ ->
					case ets:lookup(ets_guild_alliance, Aid) of
						[] -> %%正常不会走这个流程
							warn,
							refresh,
							0;
						[A] ->
							Len = length(A#ets_guild_alliance.guild_list),
							case Len < 2 of
								true ->
									warn;
								false ->
									skip
							end,
							Len
					end

			end
	end.

%%获取结盟id
get_guild_aliance_id(GuildId) ->
	case ets:lookup(?ETS_GUILD_ALLIANCE_STATE, GuildId) of
		[] ->
			0;
		[#ets_guild_alliance_state{alliance_id = Aid1}] ->
			%%也可能为0
			Aid1
	end.

%%设置或清除结盟id
set_guild_aliance_id(GuildId, Aid) ->
	guild_alliance_cache:update_guild_alliance(GuildId, Aid),
	case ets:lookup(?ETS_GUILD_ALLIANCE_STATE, GuildId) of
		[] ->
			ets:insert(?ETS_GUILD_ALLIANCE_STATE, #ets_guild_alliance_state{guild_id = GuildId, alliance_id = Aid});
		[A] ->
			%%#ets_guild_alliance_state{alliance_id = Aid1} = A,
			ets:insert(?ETS_GUILD_ALLIANCE_STATE, A#ets_guild_alliance_state{alliance_id = Aid})
	end.

%% get_aliance_state(GuildId) ->
%% 	case ets:lookup(ets_guild_alliance_state, GuildId) of
%% 		[] ->
%% 			{null, null};
%% 		[St1] ->
%% 			#ets_guild_alliance_state{alliance_id = Aid1} = St1,
%% 			case Aid1 =:= 0 of
%% 				true -> {St1, null};
%% 				_ ->
%% 					case ets:lookup(ets_guild_alliance, Aid1) of
%% 						[] ->
%% 							update,
%% 							{St1, null};
%% 						[St2] ->
%% 							{St1, St2}
%% 					end
%% 			end
%% 	end.

%%保存行会结盟请求
allicance_req(GuildA, GuildB) ->
	CurTime = util_date:get_tomorrow_unixtime(),
	case ets:lookup(?ETS_GUILD_ALLIANCE_STATE, GuildA) of
		[] ->
			St = #ets_guild_alliance_state{guild_id = GuildA, request_list = [{GuildB, CurTime, 1}]},
			ets:insert(?ETS_GUILD_ALLIANCE_STATE, St);
		[R] ->
			ReqList = R#ets_guild_alliance_state.request_list,
			case lists:keyfind(GuildB, 1, ReqList) of
				false ->
					St = R#ets_guild_alliance_state{request_list = [{GuildB, CurTime, 1} | ReqList]},
					ets:insert(?ETS_GUILD_ALLIANCE_STATE, St);
				{GuildB, CurTime1, Times1} ->
					Times = case CurTime1 < CurTime of
								true ->
									0;
								_ ->
									Times1
							end,
					?ERR("~p", [{GuildB, Times}]),
					NewReqList = lists:keyreplace(GuildB, 1, ReqList, {GuildB, CurTime1, Times + 1}),
					R2 = R#ets_guild_alliance_state{request_list = NewReqList},
					ets:insert(?ETS_GUILD_ALLIANCE_STATE, R2)
			end
	end.

%%会会结盟,执行前需要检查结盟必要条件
alliance_join(GuildIdA, GuildIdB) ->
	Aid1 = get_guild_aliance_id(GuildIdA),
	Aid2 = get_guild_aliance_id(GuildIdB),
	Alliance =
		case Aid1 =:= 0 andalso Aid2 =:= 0 of
			true ->
				%%单个行会的结盟标识
				Aid = uid_lib:get_uid(?UID_TYPE_ALLIANCE),
				set_guild_aliance_id(GuildIdA, Aid),
				set_guild_aliance_id(GuildIdB, Aid),
				%%结盟的行会列表
				A = #ets_guild_alliance{id = Aid, guild_list = [GuildIdA, GuildIdB]},
				A;
			_ ->
				%%单个行会的结盟标识
				Aid = case Aid1 =/= 0 of
						  true ->
							  set_guild_aliance_id(GuildIdB, Aid1),
							  Aid1;
						  false ->
							  set_guild_aliance_id(GuildIdA, Aid2),
							  Aid2
					  end,
				%%结盟的行会列表
				case ets:lookup(?ETS_GUILD_ALLIANCE, Aid) of
					[] ->    %%正常数据不会走这一流程
						warn,
						#ets_guild_alliance{id = Aid, guild_list = [GuildIdA, GuildIdB]};
					[A] ->
						GuildList = A#ets_guild_alliance.guild_list,
						GuildList2 = case lists:member(GuildIdA, GuildList) of
										 true -> GuildList;
										 false -> [GuildIdA | GuildList]
									 end,
						GuildList3 = case lists:member(GuildIdB, GuildList2) of
										 true -> GuildList2;
										 false -> [GuildIdB | GuildList2]
									 end,
						A#ets_guild_alliance{guild_list = GuildList3}
				end
		end,
	ets:insert(?ETS_GUILD_ALLIANCE, Alliance),
	%%刷新客户端结盟行会里的玩家状态
	alliance_refresh(Alliance#ets_guild_alliance.guild_list, Alliance#ets_guild_alliance.guild_list),
	%%公告,主要是给结盟外的人看
	alliance_notice_join(Alliance#ets_guild_alliance.guild_list),
	%%结盟邮件,主要是给结盟内的人看
	alliance_mail_join(Alliance#ets_guild_alliance.guild_list),
	ok.

%%退出结盟
alliance_exit(GuildId) ->
	case ets:lookup(?ETS_GUILD_ALLIANCE_STATE, GuildId) of
		[] ->
			false;
		[A] ->
			#ets_guild_alliance_state{alliance_id = Aid} = A,
			case ets:lookup(?ETS_GUILD_ALLIANCE, Aid) of
				[] ->
					false;
				[B] ->
					#ets_guild_alliance{guild_list = List} = B,

					%%List4 =
					case length(List) > 2 of
						true ->
							set_guild_aliance_id(GuildId, 0),
							List2 = lists:delete(GuildId, List),
							ets:insert(?ETS_GUILD_ALLIANCE, B#ets_guild_alliance{guild_list = List2}),

							%%刷新客户端结盟行会里的玩家状态
							%%还在结盟的两个
							alliance_refresh(List2, List2),
							%%退出的那个推空列表
							alliance_refresh([GuildId], []),

							%%退出公告,第一个为退出的行会
							List3 = [GuildId | List2],
							alliance_notice_exit(List3),
							List2;
						false ->
							[set_guild_aliance_id(R, 0) || R <- List],
							ets:delete(?ETS_GUILD_ALLIANCE, Aid),

							%%刷新客户端结盟行会里的玩家状态
							alliance_refresh(List, []),

							%%退出公告
							alliance_notice_exit(List),
							[]
					end,

					%%刷新客户端结盟行会里的玩家状态
					%%alliance_refresh(List, List4),
					%%退出结盟邮件
					alliance_mail_exit(GuildId, List),
					true
			end
	end.

%%结盟状态变化时,刷新在线的结盟相关人员的结盟状态
alliance_refresh(GuildIdList, GuildIdListLeft) ->
	GuildList2 = [get_guild_info(R) || R <- GuildIdListLeft],
	List = [#proto_guild_simple_info{server_id = pack_server_id(ServerNo2), guild_id = GuildId2, guild_name = GuildName2}
		|| #ets_guild_info{server_no = ServerNo2, guild_id = GuildId2, guild_name = GuildName2} <- GuildList2],
	Rep = #rep_guild_alliance_state_push{list = List},
	Fun = fun(GuildId) ->
		PlayerList = guild_lib:get_online_players(GuildId),
		[net_send:send_to_client(X#ets_online.pid, 17092, Rep) || X <- PlayerList]
	end,
	lists:foreach(Fun, GuildIdList).

%%结盟公告
alliance_notice_join(GuildIdList) ->
	GuildList2 = [get_guild_info(R) || R <- GuildIdList],
	List = lists:flatten(
		[[pack_server_id(ServerNo2), GuildName2] || #ets_guild_info{server_no = ServerNo2, guild_name = GuildName2} <- GuildList2]
	),
	case length(GuildIdList) of
		2 ->
			notice_lib:send_notice(0, ?NOTICE_UNION_1, List);
		3 ->
			notice_lib:send_notice(0, ?NOTICE_UNION_2, List);
		_ ->
			skip
	end.

%%退出结盟公告
alliance_notice_exit(GuildIdList) ->
	GuildList2 = [get_guild_info(R) || R <- GuildIdList],
	List = lists:flatten(
		[[pack_server_id(ServerNo2), GuildName2] || #ets_guild_info{server_no = ServerNo2, guild_name = GuildName2} <- GuildList2]
	),
	case length(GuildIdList) of
		2 ->
			notice_lib:send_notice(0, ?NOTICE_UNION_3, List);
		3 ->
			notice_lib:send_notice(0, ?NOTICE_UNION_4, List);
		_ ->
			skip
	end.

%%加入联盟时发的邮件
alliance_mail_join(GuildIdList) ->
	case length(GuildIdList) of
		2 ->
			alliance_mail(GuildIdList, 104, []);
		3 ->
			alliance_mail(GuildIdList, 105, []);
		_ ->
			0
	end.

%%退出联盟时发的邮件
alliance_mail_exit(GuildId, GuildIdList) ->
	case length(GuildIdList) of
		2 ->
			alliance_mail(GuildIdList, 106, []);
		3 ->
			GuildIdList2 = lists:delete(GuildId, GuildIdList),
			%%给还在结盟中的两个行会发送某行会解除结盟的邮件
			#ets_guild_info{server_no = ServerNo, guild_name = GuildName} = get_guild_info(GuildId),
			alliance_mail(GuildIdList2, 106, [util_data:to_list(pack_server_id(ServerNo)), util_data:to_list(GuildName)]),

			%%给退结盟的那个行会发送与其它两个行会解除结盟的邮件
			GuildList2 = [get_guild_info(R) || R <- GuildIdList2],
			List = lists:flatten(
				[[pack_server_id(ServerNo2), GuildName2] || #ets_guild_info{server_no = ServerNo2, guild_name = GuildName2} <- GuildList2]
			),
			List2 = [util_data:to_list(R) || R <- List],
			alliance_mail([GuildId], 107, List2);
		_ ->
			0
	end.

%%给联盟里的所有人员发关于结盟的邮件
alliance_mail(GuildIdList, MailId, Args) ->
	#mail_conf{title = Title, content = ContentTpl1} = mail_config:get(MailId),
	ContentTpl2 = re:replace(ContentTpl1, "%s", "~s", [global, {return, list}]),
	GuildList = [get_guild_info(R) || R <- GuildIdList],
	Fun = fun(E) ->
		#ets_guild_info{server = ServerNode, guild_id = GuildId} = E,
		Content =
			case Args of
				[] ->
					%%参数为空时发送的是对方的信息
					GuildList2 = lists:delete(E, GuildList),
					List = lists:flatten(
						[[pack_server_id(ServerNo2), GuildName2]
							|| #ets_guild_info{server_no = ServerNo2, guild_name = GuildName2} <- GuildList2]
					),
					List2 = [util_data:to_list(R) || R <- List],
					%%?WARNING("tpl1 ~w ~w ~w",[Title, ContentTpl2, List2]),
					io_lib:format(ContentTpl2, List2);
				[_ | _] ->
					%%?WARNING("tpl2 ~w ~w ~w",[Title, ContentTpl2, Args]),
					%%参数不为空就是当前参数的信息
					io_lib:format(ContentTpl2, Args)
			end,
		%%?WARNING("send ~w ~w mail ~w ~w", [ServerNode, GuildId, Title, Content]),
		send_mail(ServerNode, GuildId, Title, Content),
		ok
	end,
	lists:foreach(Fun, GuildList),
	ok.

%%跨服获取行会的领导id
allicance_guild_leaders(_ServerNode, GuildIdB) ->
	case guild_lib:guild_leader_idlist(GuildIdB) of
		[_ | _] = List ->
			List;
		_ ->
			[]
	end.

%%跨服获取行会信息
alliance_guild_info(_ServerNode, GuildIdB) ->
	case guild_lib:get_guild_info(GuildIdB) of
		#db_guild{} = R ->
			R;
		_ ->
			#db_guild{}
	end.

%%判断是否为行会领导
is_leader(PlayerId, GuildId) ->
	case player_guild_cache:get_player_guild_info_from_ets(PlayerId, GuildId) of
		#db_player_guild{position = Position} when Position > 0 andalso Position < 3 -> true;
		_ -> false
	end.

%%获取行会的基本信息
get_guild_info(GuildId) ->
	case guild_cache:get_guild_info_from_ets(GuildId) of
		#db_guild{guild_name = GuildName} ->
			#ets_guild_info{
				guild_id = GuildId,
				guild_name = GuildName,
				server_no = config:get_server_no(),
				server = config:get_cross_path()};
		_ ->
			#ets_guild_info{}
	end.

%%格式化区服id给前端显示
pack_server_id(ServerId) ->
	case ServerId > 1000 of
		true -> ServerId - (ServerId div 1000) * 1000;
		false -> ServerId
	end.

%%发送邮件
send_mail(ServerNode, GuildId, Title, Content) ->
	rpc:cast(ServerNode, ?MODULE, send_mail_local, [GuildId, Title, Content]).
send_mail_local(GuildId, Title, Content) ->
	case ets:lookup(?ETS_GUILD_LIST, GuildId) of
		[R] ->
			MemberList = R#ets_guild_list.member_list,
			lists:foreach(fun(E) ->
				util:sleep(20),
				PlayerId = E#db_player_guild.player_id,
				mail_lib:send_mail_to_player(PlayerId, xmerl_ucs:to_utf8("系统"), Title, Content, [])
			end, MemberList);
		_ ->
			skip
	end.


%% is_cross(ServerId) ->
%% 	ok.
%%
%% cast(ServerId, MFC) when is_cross(ServerId)->
%% 	ok.
%%
%%
%% send_to_client(Area, Target, Cmd, Data) when is_cross(Area) ->
%% 	ok;
%% send_to_client(_Area, Target, Cmd, Data)  ->
%% 	send_to_client(Target, Cmd, Data).
%%
%% send_to_client(Pid, Cmd, Data) when is_pid(Pid) ->
%% 	gen_server2:apply_async(Pid, {?MODULE, send_to_client, [Cmd, Data]});
%% send_to_client(Target, Cmd, Data) ->
%% 	net_send:send_to_client(Target, Cmd, Data).