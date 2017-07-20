%%%-------------------------------------------------------------------
%%% @author qhb
%%% @copyright (C) 2016, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 21. 六月 2016 下午2:33
%%%-------------------------------------------------------------------
-module(guild_challenge_lib).
-include("common.hrl").
-include("record.hrl").
-include("cache.hrl").
-include("config.hrl").
-include("language_config.hrl").
-include("notice_config.hrl").
-include("proto.hrl").
-include("log_type_config.hrl").

-define(ETS_GUILD_CHALLENGE, ets_guild_challenge).	%%行会宣战记录
-define(ETS_GUILD_CHALLENGE_REV, ets_guild_challenge_rev).	%%行会宣战反向记录
-define(ETS_GUILD_CHALLENGE_LAST_TIME, ets_guild_challenge_last_time).	%%两个行会之间最后一次宣战时间
-define(TIMEOUT_GUILD_CHALLENGE, 180 * 1000).		%%行会宣战请求超时时间，3分钟
-define(TIME_GUILD_CHALLENGE, 3600 * 1000).			%%行会宣战时间
-define(TIMER_FRAME_LOG, 5000).						%%行会记录定时检查时间
-define(GUILD_CHALLENGE_COST, [{110048, 1}, {110050, 1}]).	%%宣战消耗物品

-record(ets_guild_challenge, {
	guild_id_a,		%%发起宣战行会id
	guild_id_b,		%%被宣战行会id
	guild_name_a,	%%发起宣战行会名
	guild_name_b,	%%被宣战行会名
	chief_id_a,		%%发起宣战行会会id
	chief_id_b,		%%被宣战行会会长id
	flag = 0,		%%宣战已经接受
	kill_by_a = 0,	%%发起宣战行会杀人数
	kill_by_b = 0,	%%被宣战行会杀人数
	changed = false,%%数据已经变化
	step = 0,		%%宣战所处的过程，1开始2结束
	time			%%宣战开始时间
}).

%% API
-export([
	apply/2,
	answer/3,
	info/1,
	kill_player/3,
	login_check/0,
	is_challenge/2,
	get_challenge_guild_id/1
]).

%% GEN API
-export([
	init_local/0,
	apply_local/3,
	on_timer_local/1,
	answer_local/4,
	kill_player_local/4,
	send_challenge_result_local/3,
	login_check_local/1,
	open_func_local/1,
	close_func_local/1
]).

init_local() ->
	ets:new(?ETS_GUILD_CHALLENGE, [{keypos, #ets_guild_challenge.guild_id_a}, named_table, public, set]),
	%%{GuildIdB, GuildIdA}
	ets:new(?ETS_GUILD_CHALLENGE_REV, [named_table, public, set]),
	%%{{GuildIdA, GuildIdB}, Time}
	ets:new(?ETS_GUILD_CHALLENGE_LAST_TIME, [named_table, public, set]),
	gen_server2:apply_after(?TIMER_FRAME_LOG, self(), {?MODULE, on_timer_local, []}),
	ok.

on_timer_local(State) ->
	try
		check_challenge_status(),
		refresh_challenge_result()
	catch
			_Err:Reason ->
			?ERR("guild challenge timer error ~p ~p", [Reason, erlang:get_stacktrace()])
	end,
	gen_server2:apply_after(?TIMER_FRAME_LOG, self(), {?MODULE, on_timer_local, []}),
	{ok, State}.


%%发起行会挑战
apply(PlayerState, GuildIdB) ->
	gen_server2:apply_async(misc:whereis_name({local, guild_challenge_mod}),
		{?MODULE, apply_local, [PlayerState, GuildIdB]}).
apply_local(State, PlayerState, GuildIdB) ->
	case check_challenge_apply(PlayerState, GuildIdB) of
		{fail, Reply} ->
			net_send:send_to_client(PlayerState#player_state.socket, 17080, #rep_guild_challenge_apply{result = Reply});
		{ok, {GuildInfoA, GuildInfoB}} ->
			#db_guild{guild_name = GuildNameB, chief_id = ChiefIdB} = GuildInfoB,
			case player_lib:is_online(ChiefIdB) of
				true ->
					#db_guild{guild_id = GuildIdA, guild_name = GuildNameA, chief_id = ChiefIdA} = GuildInfoA,
					ets:insert(?ETS_GUILD_CHALLENGE,
						#ets_guild_challenge{
							guild_id_a = GuildIdA,
							guild_id_b = GuildIdB,
							guild_name_a = GuildNameA,
							guild_name_b = GuildNameB,
							chief_id_a = ChiefIdA,
							chief_id_b = ChiefIdB,
							flag = 0,
							changed = true,
							time = util_date:unixtime()
						}),
					ets:insert(?ETS_GUILD_CHALLENGE_LAST_TIME, {{GuildIdA, GuildIdB}, util_date:unixtime()}),
					sync_player(PlayerState#player_state.player_id, {goods_util, delete_special_list, [?GUILD_CHALLENGE_COST, ?LOG_TYPE_GUILD_CHALLENGE]}),
					RepA = #rep_guild_challenge_apply{result = ?ERR_COMMON_SUCCESS},
					net_send:send_to_client(ChiefIdA, 17080, RepA),

					Rep = #rep_guild_challenge_invite{guild_id_a = GuildIdA, guild_name_a = GuildNameA},
					net_send:send_to_client(ChiefIdB, 17081, Rep);
				false ->
					net_send:send_to_client(PlayerState#player_state.socket, 17080,
						#rep_guild_challenge_apply{result = ?ERR_GUILD_CHALLENGE_HUIZHANG_OFFLINE})
			end
	end,
	{ok, State}.

%%响应行会挑战，接受或拒绝
answer(PlayerState, GuildIdA, Type) ->
	gen_server2:apply_async(misc:whereis_name({local, guild_challenge_mod}),
		{?MODULE, answer_local, [PlayerState, GuildIdA, Type]}).
answer_local(State, PlayerState, GuildIdA, Type) ->
	case ets:lookup(?ETS_GUILD_CHALLENGE, GuildIdA) of
		[] ->
			DataB = #rep_guild_challenge_answer{result = ?ERR_GUILD_NOT_EXIST},
			net_send:send_to_client(PlayerState#player_state.socket, 17082, DataB),
			{ok, State};
		[R] ->
			#ets_guild_challenge{guild_id_b = GuildIdB, guild_name_a = GuildNameA, guild_name_b = GuildNameB,
				chief_id_a = ChiefIdA} = R,
			case Type of
				0 ->
					do_cancel(R),
					DataA = #rep_guild_challenge_apply{result = ?ERR_GUILD_CHALLENGE_REFUSE, guild_name_b = GuildNameB},
					DataB = #rep_guild_challenge_answer{result = ?ERR_COMMON_SUCCESS},
					net_send:send_to_client(ChiefIdA, 17080, DataA),
					net_send:send_to_client(PlayerState#player_state.socket, 17082, DataB),
					{ok, State};
				1 ->
					ets:insert(?ETS_GUILD_CHALLENGE_REV, {GuildIdB, GuildIdA}),
					update_challenge_record(GuildIdA, #ets_guild_challenge.flag, 1),
					update_challenge_record(GuildIdA, #ets_guild_challenge.time, util_date:unixtime()),
					update_challenge_record(GuildIdA, #ets_guild_challenge.step, 1),
					notice_lib:send_notice(0, ?NOTICE_GUILD_CHALLENGE_BEGIN, [GuildNameA, GuildNameB]),
%% 					open_func_all(GuildIdA),
%% 					open_func_all(GuildIdB),

					DataA = #rep_guild_challenge_apply{result = ?ERR_COMMON_SUCCESS, guild_name_b = GuildNameB},
					DataB = #rep_guild_challenge_answer{result = ?ERR_COMMON_SUCCESS},
					net_send:send_to_client(ChiefIdA, 17080, DataA),
					net_send:send_to_client(PlayerState#player_state.socket, 17082, DataB),
					{ok, State}
			end
	end.

%%如果击杀对像是挑战双方行会的人员，进行记录
kill_player(SceneState, CasterState, KilledObjState) ->
	gen_server2:apply_async(misc:whereis_name({local, guild_challenge_mod}),
		{?MODULE, kill_player_local, [SceneState, CasterState, KilledObjState]}).
kill_player_local(State, SceneState, CasterState, KilledObjState) ->
	#scene_obj_state{guild_id = GuildId1} = CasterState,
	#scene_obj_state{obj_id = KilledPlayerId, name = KilledName, guild_id = KilledGuildId} = KilledObjState,
	case is_challenge(GuildId1, KilledGuildId) of
		true ->
			case player_guild_cache:get_player_guild_info_from_ets(KilledPlayerId, KilledGuildId) of
				[] ->  skip;
				DbPlayerGuild ->
					{GuildIdA, _GuildIdB} = ge_challenge_guild_id_pair(GuildId1),
					case GuildId1 of
						GuildIdA -> inc_challenge_record(GuildIdA, #ets_guild_challenge.kill_by_a, 1);
						_ -> inc_challenge_record(GuildIdA, #ets_guild_challenge.kill_by_b, 1)
					end,
					update_challenge_record(GuildIdA, #ets_guild_challenge.changed, true),

					#db_player_guild{guild_name = KilledGuildName, position = Position} = DbPlayerGuild,
					#scene_conf{name = SceneName} = scene_config:get(SceneState#scene_state.scene_id),
					case Position of
						?HUIZHANG ->
							notice_lib:send_notice(0, ?NOTICE_GUILD_CHALLENGE_KILL,
								[KilledGuildName, xmerl_ucs:to_utf8("会长"), KilledName, SceneName]);
						?FU_HUIZHANG ->
							notice_lib:send_notice(0, ?NOTICE_GUILD_CHALLENGE_KILL,
								[KilledGuildName, xmerl_ucs:to_utf8("副会长"), KilledName, SceneName]);
						?ZHANGLAO ->
							notice_lib:send_notice(0, ?NOTICE_GUILD_CHALLENGE_KILL,
								[KilledGuildName, xmerl_ucs:to_utf8("长老"), KilledName, SceneName]);
						_ ->
							skip
					end
			end;
		false ->
			skip
	end,
	{ok, State}.

%%登录通知
login_check() ->
	gen_server2:apply_after(20 * 1000, self(), {?MODULE, login_check_local, []}).
login_check_local(PlayerState) ->
	case ge_challenge_guild_record(PlayerState) of
		#ets_guild_challenge{guild_id_a = GuildIdA, guild_name_a = GuildNameA, guild_id_b = GuildIdB,
			guild_name_b = GuildNameB,flag = 1, kill_by_a = KillNumA, kill_by_b = KillNumB, time = BegeinTime}  ->
			T1 = (?TIME_GUILD_CHALLENGE div 1000) - (util_date:unixtime() - BegeinTime),
			TimeLeft=
				case T1 >= 0 of
					true -> T1;
					false -> 0
				end,
			Rep = #rep_guild_challenge_result{guild_id_a = GuildIdA, guild_name_a = GuildNameA, guild_id_b = GuildIdB,
				guild_name_b = GuildNameB, kill_a = KillNumA, kill_b = KillNumB, time_left = TimeLeft},
			net_send:send_to_client(PlayerState#player_state.socket, 17083, Rep),
			open_func(PlayerState#player_state.player_id);
		_ ->
			skip
	end,
	{ok, PlayerState}.

%%获取挑战双方信息
info(PlayerState) ->
	case ge_challenge_guild_record(PlayerState) of
		#ets_guild_challenge{guild_id_a = GuildIdA, guild_name_a = GuildNameA, guild_id_b = GuildIdB,
			guild_name_b = GuildNameB,flag = _Flag} ->
			Rep = #rep_guild_challenge_info{guild_id_a = GuildIdA, guild_name_a = GuildNameA, guild_id_b = GuildIdB,
				guild_name_b = GuildNameB},
			net_send:send_to_client(PlayerState#player_state.socket, 17084, Rep);
		_ ->
			skip
	end,
	{ok, PlayerState}.

%%是否敌对双方行会
is_challenge(GuildId1, GuildId2) ->
	GuildId1 =/= 0 andalso GuildId2 =/= 0 andalso not util_data:is_null(GuildId1) andalso get_challenge_guild_id(GuildId1) =:= GuildId2.

%%获取正在挑战的帮派
get_challenge_guild_id(PlayerState) when is_record(PlayerState, player_state) ->
	DbBase = PlayerState#player_state.db_player_base,
	#db_player_base{guild_id = GuildIdA} = DbBase,
	case GuildIdA =/= 0 of
		true ->
			get_challenge_guild_id(GuildIdA);
		false -> 0
	end;
get_challenge_guild_id(GuildId) when is_number(GuildId)->
	case ets:lookup(?ETS_GUILD_CHALLENGE, GuildId) of
		[R] ->
			#ets_guild_challenge{guild_id_b = GuildB, flag = Flag} = R,
			case Flag =:=1 of
				true -> GuildB;
				false -> 0
			end;
		[] ->
			case ets:lookup(?ETS_GUILD_CHALLENGE_REV, GuildId) of
				[{_, R}] -> R;
				[] -> 0
			end
	end.


%%%===================================================================
%%% Internal functions
%%%===================================================================
%%验证挑战请求
check_challenge_apply(PlayerState, GuildIdB) ->
	DbBase = PlayerState#player_state.db_player_base,
	#db_player_base{player_id = PlayerId, guild_id = GuildIdA} = DbBase,
	case util:loop_functions(
		none,
		[
			fun(_) ->
				case GuildIdA =:= GuildIdB of
					true ->
						{break, ?ERR_COMMON_FAIL};
					false ->
						{continue, none}
				end
			end,
			fun(_) ->
				case guild_cache:get_guild_info_from_ets(GuildIdA) of
					[] ->
						{break, ?ERR_PLAYER_NOT_JOINED_GUILD};
					GuildInfoA ->
						{continue, GuildInfoA}
				end
			end,
			fun(GuildInfoA) ->
				#db_guild{chief_id = ChiefIdA} = GuildInfoA,
				case PlayerId =/= ChiefIdA of
					true ->
						{break, ?ERR_PLAYER_NOT_HUIZHANG};
					false ->
						{continue, GuildInfoA}
				end
			end,
			fun(GuildInfoA) ->
				Key = {GuildIdA, GuildIdB},
				case ets:lookup(?ETS_GUILD_CHALLENGE_LAST_TIME, Key) of
					[{_, LastTime}] ->
						case util_date:unixtime() - LastTime < ?TIME_GUILD_CHALLENGE div 1000 of
							true -> {break, ?ERR_GUILD_CHALLENGE_SAME_ONE_HOUR};
							false -> {continue, GuildInfoA}
						end;
					[] -> {continue, GuildInfoA}
				end
			end,
			fun(GuildInfoA) ->
				%%当存在对方发过来的请求时
				case ets:lookup(?ETS_GUILD_CHALLENGE, GuildIdB) of
					[_] ->
						{break, ?ERR_GUILD_CHALLENGE_ALREADY};
					[] ->
						{continue, GuildInfoA}
				end
			end,
			fun(GuildInfoA) ->
				case guild_cache:get_guild_info_from_ets(GuildIdB) of
					[] ->
						{break, ?ERR_PLAYER_NOT_JOINED_GUILD};
					GuildInfoB ->
						{continue, {GuildInfoA, GuildInfoB}}
				end
			end,
			fun({GuildInfoA, GuildInfoB}) ->
				StatusA = get_challenge_guild_id(GuildIdA),
				StatusB = get_challenge_guild_id(GuildIdB),
				case StatusA =/= 0 of
					true ->
						{break, ?ERR_GUILD_CHALLENGE_DO};
					false ->
						case StatusB =/= 0 of
							true -> {break, ?ERR_GUILD_CHALLENGE_TARGET_DO};
							false -> {continue, {GuildInfoA, GuildInfoB}}
						end
				end
			end,
			fun(Value) ->
				Flag = sync_player(PlayerState#player_state.player_id,
					{goods_util, check_special_list, [?GUILD_CHALLENGE_COST]}),
				case Flag of
					true ->
						{continue, Value};
					{fail, _} ->
						{break, ?ERR_GUILD_CHALLENGE_GOODS_NOT_ENOUGH}
				end
			end
		]
	) of
		{break, Reply} -> {fail, Reply};
		{ok, Value} -> {ok, Value}
	end.

%%检查挑战ets状态，超时或已经完成
check_challenge_status() ->
	List = ets:tab2list(?ETS_GUILD_CHALLENGE),
	lists:foreach(fun check_challenge_status1/1, List),
	ok.
check_challenge_status1(Challenge) ->
	#ets_guild_challenge{flag = Flag, time = Time} = Challenge,
	Now = util_date:unixtime(),
	case Flag =:= 1 of
		true ->
			case Now - Time >?TIME_GUILD_CHALLENGE div 1000 of
				true -> do_complete(Challenge);
				false -> skip
			end;
		false ->
			case Now - Time >?TIMEOUT_GUILD_CHALLENGE div 1000 of
				true ->
					do_cancel(Challenge);
				false -> skip
			end
	end,
	ok.

%%刷新客户端战绩
refresh_challenge_result() ->
	List = ets:tab2list(?ETS_GUILD_CHALLENGE),
	lists:foreach(fun refresh_challenge_result1/1, List),
	ok.
refresh_challenge_result1(Challenge) ->
	send_challenge_result(Challenge, false).

send_challenge_result(Challenge, IsEnd) ->
	#ets_guild_challenge{guild_id_a = GuildIdA, guild_name_a = GuildNameA, guild_id_b = GuildIdB,
		guild_name_b = GuildNameB,flag = Flag, kill_by_a = KillNumA, kill_by_b = KillNumB, time = BegeinTime,
		changed = Changed, step = Step} = Challenge,
	case Flag =:= 1 andalso Changed =:= true of
		true ->
			TimeLeft = case IsEnd of
						  true ->
							  if
								  KillNumA > KillNumB ->
									  notice_lib:send_notice(0, ?NOTICE_GUILD_CHALLENGE_WIN,
										  [GuildNameA, GuildNameB, integer_to_list(KillNumA)]);
								  KillNumB > KillNumA ->
									  notice_lib:send_notice(0, ?NOTICE_GUILD_CHALLENGE_WIN,
										  [GuildNameB, GuildNameA, integer_to_list(KillNumB)]);
								  true ->
									  notice_lib:send_notice(0, ?NOTICE_GUILD_CHALLENGE_DRAW,
										  [GuildNameA, GuildNameB, integer_to_list(KillNumA), integer_to_list(KillNumB)])
							  end,
							  0;
						  false ->
							  T1 = (?TIME_GUILD_CHALLENGE div 1000) - (util_date:unixtime() - BegeinTime),
							  case T1 >= 0 of
								  true -> T1;
								  false -> 0
							  end
					  end,
			Rep = #rep_guild_challenge_result{guild_id_a = GuildIdA, guild_name_a = GuildNameA, guild_id_b = GuildIdB,
				guild_name_b = GuildNameB, kill_a = KillNumA, kill_b = KillNumB, time_left = TimeLeft},
			Cmd = 17083,
			{ok, Bin} = pt:write_cmd(Cmd, Rep),
			Bin1 = pt:pack(Cmd, Bin),
			dp_lib:cast({?MODULE, send_challenge_result_local, [GuildIdA, Bin1, Step]}),
			dp_lib:cast({?MODULE, send_challenge_result_local, [GuildIdB, Bin1, Step]}),
			update_challenge_record(GuildIdA, #ets_guild_challenge.changed, false),
			update_challenge_record(GuildIdA, #ets_guild_challenge.step, 0),
			ok;
		false ->
			skip
	end.

send_challenge_result_local(GuildId, Bin, Step) ->
	case ets:lookup(?ETS_GUILD_LIST, GuildId) of
		[R] ->
			MemberList = R#ets_guild_list.member_list,
			lists:foreach(fun(E) ->
				PlayerId = E#db_player_guild.player_id,
				net_send:send_one(PlayerId, Bin),
				case Step of
					1 ->
						open_func(PlayerId);
					2 ->
						close_func(PlayerId);
					_ ->
						skip
				end
			end, MemberList);
		_ ->
			skip
	end.

%%行会挑战取消
do_cancel(Challenge) ->
	back_goods(Challenge#ets_guild_challenge.chief_id_a),
	delete_challenge_record(Challenge#ets_guild_challenge.guild_id_a),
	ok.

%%行会挑战结束
do_complete(Challenge) ->
	send_challenge_result(Challenge#ets_guild_challenge{changed = true, step = 2}, true),
%% 	#ets_guild_challenge{guild_id_a = GuildIdA, guild_id_b = GuildIdB} = Challenge,
%% 	close_func_all(GuildIdA),
%% 	close_func_all(GuildIdB),
	spawn(fun() -> send_mail_all(Challenge) end),
	delete_challenge_record(Challenge#ets_guild_challenge.guild_id_a).

%%发送邮件
send_mail_all(Challenge) ->
	#ets_guild_challenge{guild_id_a = GuildIdA, guild_name_a = GuildNameA1, guild_id_b = GuildIdB,
		guild_name_b = GuildNameB1,kill_by_a = KillNumA, kill_by_b = KillNumB} = Challenge,
	GuildNameA = re:replace(GuildNameA1, "", "", [global, {return, list}]),
	GuildNameB = re:replace(GuildNameB1, "", "", [global, {return, list}]),
	#mail_conf{title = TitleWin, content = ContentTpl1} = mail_config:get(66),
	ContentTplWin = re:replace(ContentTpl1, "%s", "~s", [global, {return, list}]),
	#mail_conf{title = TitleLoss, content = ContentTpl2} = mail_config:get(67),
	ContentTplLoss = re:replace(ContentTpl2, "%s", "~s", [global, {return, list}]),
	#mail_conf{title = TitleDraw, content = ContentTpl3} = mail_config:get(68),
	ContentTplDraw = re:replace(ContentTpl3, "%s", "~s", [global, {return, list}]),
	KillNumAStr = integer_to_list(KillNumA),
	KillNumBStr = integer_to_list(KillNumB),
	if
		KillNumA > KillNumB ->
			TitleA = TitleWin,
			ContentA = io_lib:format(ContentTplWin, [GuildNameA, GuildNameB, KillNumAStr]),
			TitleB = TitleLoss,
			ContentB = io_lib:format(ContentTplLoss, [GuildNameA, GuildNameB, KillNumBStr]),
			send_mail(GuildIdA, TitleA, ContentA),
			send_mail(GuildIdB, TitleB, ContentB);
		KillNumB > KillNumA ->
			TitleA = TitleLoss,
			ContentA = io_lib:format(ContentTplLoss, [GuildNameA, GuildNameB, KillNumAStr]),
			TitleB = TitleWin,
			ContentB = io_lib:format(ContentTplWin, [GuildNameA, GuildNameB, KillNumBStr]),
			send_mail(GuildIdA, TitleA, ContentA),
			send_mail(GuildIdB, TitleB, ContentB);
		true ->
			TitleA = TitleDraw,
			ContentA = io_lib:format(ContentTplDraw, [GuildNameA, GuildNameB, KillNumAStr, KillNumBStr]),
			TitleB = TitleDraw,
			ContentB = io_lib:format(ContentTplDraw, [GuildNameA, GuildNameB, KillNumAStr, KillNumBStr]),
			send_mail(GuildIdA, TitleA, ContentA),
			send_mail(GuildIdB, TitleB, ContentB)
	end,
	ok.
send_mail(GuildId, Title, Content) ->
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

%%返回商品
back_goods(PlayerId) ->
	Title = xmerl_ucs:to_utf8("宣战不成功返还物品"),
	Content = xmerl_ucs:to_utf8("请查收附件"),
	Award = [{GoodsId, 0, Num} || {GoodsId, Num} <-?GUILD_CHALLENGE_COST],
	mail_lib:send_mail_to_player(PlayerId, xmerl_ucs:to_utf8("系统"), Title, Content, Award).


%%功能按钮
%% open_func_all(GuildId) ->
%% 	case ets:lookup(?ETS_GUILD_LIST, GuildId) of
%% 		[R] ->
%% 			MemberList = R#ets_guild_list.member_list,
%% 			lists:foreach(fun(E) ->
%% 				PlayerId = E#db_player_guild.player_id,
%% 				open_func(PlayerId)
%% 			end, MemberList);
%% 		_ ->
%% 			skip
%% 	end.
%%
%% close_func_all(GuildId) ->
%% 	case ets:lookup(?ETS_GUILD_LIST, GuildId) of
%% 		[R] ->
%% 			MemberList = R#ets_guild_list.member_list,
%% 			lists:foreach(fun(E) ->
%% 				PlayerId = E#db_player_guild.player_id,
%% 				close_func(PlayerId)
%% 			end, MemberList);
%% 		_ ->
%% 			skip
%% 	end.

open_func(PlayerId) ->
	async_player(PlayerId, {?MODULE, open_func_local, []}).
open_func_local(PlayerState) ->
	NewPlayerState = function_lib:open_function_list(PlayerState, [72]),
	{ok, NewPlayerState}.

close_func(PlayerId) ->
	async_player(PlayerId, {?MODULE, close_func_local, []}).
close_func_local(PlayerState) ->
	NewPlayerState = function_lib:close_function_list(PlayerState, [72]),
	{ok, NewPlayerState}.

async_player(PlayerId, Mfa) ->
	case player_lib:get_player_pid(PlayerId) of
		null->
			skip;
		PlayerPid->
			gen_server2:apply_async(PlayerPid, Mfa)
	end.

sync_player(PlayerId, Mfa) ->
	case player_lib:get_player_pid(PlayerId) of
		null->
			skip;
		PlayerPid->
			gen_server2:apply_sync(PlayerPid, Mfa)
	end.


%%挑战双方
ge_challenge_guild_id_pair(GuildId) ->
	case ets:lookup(?ETS_GUILD_CHALLENGE, GuildId) of
		[R] ->
			#ets_guild_challenge{guild_id_a = GuildId, guild_id_b = GuildIdB} = R,
			{GuildId, GuildIdB};
		[] ->
			case ets:lookup(?ETS_GUILD_CHALLENGE_REV, GuildId) of
				[{GuildId, A}] -> {A, GuildId};
				[] -> null
			end
	end.

%%根据任意方帮派获取挑战记录
ge_challenge_guild_record(PlayerState) when is_record(PlayerState, player_state) ->
	DbBase = PlayerState#player_state.db_player_base,
	#db_player_base{guild_id = GuildId} = DbBase,
	ge_challenge_guild_record(GuildId);
ge_challenge_guild_record(GuildId) ->
	case ets:lookup(?ETS_GUILD_CHALLENGE, GuildId) of
		[R] ->
			R;
		[] ->
			case ets:lookup(?ETS_GUILD_CHALLENGE_REV, GuildId) of
				[{GuildId, A}] ->
					case ets:lookup(?ETS_GUILD_CHALLENGE, A) of
						[R] -> R;
						[] -> null
					end;
				[] -> null
			end
	end.

%% 挑战ets操作
delete_challenge_record(GuildIdA) ->
	case ets:lookup(?ETS_GUILD_CHALLENGE, GuildIdA) of
		[R] ->
			GuildIdB = R#ets_guild_challenge.guild_id_b,
			ets:delete(?ETS_GUILD_CHALLENGE, GuildIdA),
			ets:delete(?ETS_GUILD_CHALLENGE_REV, GuildIdB);
		[] ->
			skip
	end.

update_challenge_record(GuildIdA, Pos, Value) ->
	ets:update_element(?ETS_GUILD_CHALLENGE, GuildIdA, {Pos, Value}).

inc_challenge_record(GuildIdA, Pos, Value) ->
	ets:update_counter(?ETS_GUILD_CHALLENGE, GuildIdA, {Pos, Value}).