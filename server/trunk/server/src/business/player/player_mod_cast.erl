%%%-------------------------------------------------------------------
%%% @author zhengsiying
%%% @copyright (C) 2015, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 23. 七月 2015 上午11:06
%%%-------------------------------------------------------------------
-module(player_mod_cast).
%%
-include("common.hrl").
-include("record.hrl").
-include("db_record.hrl").
-include("proto.hrl").
-include("cache.hrl").
-include("config.hrl").
-include("notice_config.hrl").
-include("language_config.hrl").
-include("button_tips_config.hrl").
-include("log_type_config.hrl").

%% API
-export([
	handle/2
]).

%% ====================================================================
%% API functions
%% ====================================================================
handle({'SOCKET_EVENT', Mod, Cmd, Data}, PlayerState) ->
	try
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
			skip ->
				{ok, PlayerState};
			Err1 ->
				?ERR("~p", [{Err1, Mod, Cmd}]),
				{ok, PlayerState}
		end
	catch
		Err:Info ->
			?ERR("~p ~p ~p ~p", [{Mod, Cmd, Data}, Err, Info, erlang:get_stacktrace()]),
			{ok, PlayerState}
	end;

%% 血量数据变化
handle({on_harm, HarmProto, CasterState, IsAddPk}, PlayerState) ->
	State =
		case HarmProto#proto_harm.cur_hp =< 0 of
			true ->
				?STATUS_DIE;
			_ ->
				?STATUS_ALIVE
		end,
	Update = #player_state{
		db_player_attr = #db_player_attr{
			cur_hp = HarmProto#proto_harm.cur_hp,
			cur_mp = HarmProto#proto_harm.cur_mp
		},
		db_player_base = #db_player_base{
			state = State
		}
	},
	{ok, PlayerState1} = player_lib:update_player_state(PlayerState, Update),
	case HarmProto#proto_harm.cur_hp =< 0 of
		true ->
			SceneId = PlayerState1#player_state.scene_id,
			SceneConf = scene_config:get(SceneId),
			DbPlayerBase = PlayerState1#player_state.db_player_base,
			%% 判定玩家是否掉落身上物品
			{PlayerState2, DropList} =
				case is_record(CasterState, scene_obj_state) of
					true ->
						case SceneConf#scene_conf.die_drop =:= 1 andalso CasterState#scene_obj_state.obj_type /= ?OBJ_TYPE_MONSTER of
							true ->
								drop_lib:scene_drop(PlayerState1, SceneConf, CasterState);
							_ ->
								{PlayerState1, []}
						end;
					_ ->
						{PlayerState1, []}
				end,

			#player_state{
				scene_pid = ScenePid,
				player_id = PlayerId,
				pet_dict = PetDict
			} = PlayerState2,
			scene_obj_lib:obj_die(ScenePid, ?OBJ_TYPE_PLAYER, PlayerId, DropList, CasterState),

			%% 添加仇人名单 begin
			case SceneConf#scene_conf.add_pk_value > 0 of
				true ->
					if
						is_record(CasterState, scene_obj_state) andalso CasterState#scene_obj_state.obj_type =:= ?OBJ_TYPE_PLAYER ->
							GuildIdA = CasterState#scene_obj_state.guild_id,
							GuildIdB = DbPlayerBase#db_player_base.guild_id,
							case not guild_challenge_lib:is_challenge(GuildIdA, GuildIdB)
								andalso PlayerState2#player_state.player_id =/= CasterState#scene_obj_state.obj_id of
								true ->
									%% 毒击杀加pk值
									case player_lib:is_outlaw(CasterState#scene_obj_state.name_colour)
										andalso IsAddPk
									of
										true ->
											gen_server2:cast(CasterState#scene_obj_state.obj_pid, {harm_player, SceneConf#scene_conf.add_pk_value});
										_ ->
											skip
									end,
									player_foe_lib:add_foe(PlayerState2, CasterState#scene_obj_state.obj_id);
								false ->
									skip
							end;
						true ->
							skip
					end;
				_ ->
					skip
			end,
			%% 添加仇人 end

			CasterName =
				if
					is_record(CasterState, scene_obj_state) ->
						CasterState#scene_obj_state.name;
					CasterState =:= fire_wall ->
						xmerl_ucs:to_utf8("火墙");
					true ->
						xmerl_ucs:to_utf8("毒")
				end,

			%% 发送死亡信息(前端收到后会弹复活面板)，如果是在竞技场死亡则不要发送
			IsSendDie =
				case SceneConf#scene_conf.type of
					?SCENE_TYPE_INSTANCE ->
						InstanceConf = instance_config:get(SceneId),
						case InstanceConf#instance_conf.type of
							?INSTANCE_TYPE_ARENA ->
								false;
							_ ->
								true
						end;
					_ ->
						true
				end,
			case IsSendDie of
				true ->
					player_pp:handle(10010, PlayerState, #req_player_die{caster_name = CasterName});
				_ ->
					skip
			end,

			%% 移除宠物
			case PetDict /= dict:new() of
				true ->
					F2 = fun(_, PetInfo) ->
						#pet_info{
							scene_pid = PetScenePid,
							uid = Uid
						} = PetInfo,
						case is_pid(PetScenePid) of
							true ->
								scene_obj_lib:remove_obj(PetScenePid, ?OBJ_TYPE_PET, Uid, ?LEAVE_SCENE_TYPE_INITIATIVE);
							_ ->
								skip
						end
					end,
					dict:map(F2, PetDict);
				_ ->
					skip
			end,
			case is_record(CasterState, scene_obj_state) of
				true ->
					log_factory:log_db(#db_log_dead{
						player_id = PlayerId,
						player_name = DbPlayerBase#db_player_base.name,
						scene_id = SceneId,
						reason = CasterState#scene_obj_state.obj_type,
						server_id = config:get_server_no(),
						createtime = util_date:unixtime()
					});
				false ->
					skip
			end,
			{ok, PlayerState3} = pet_lib:delete_all_pet(PlayerState2),
			%% 玩家死亡清除异常状态
			buff_base_lib:remove_abnormal_buff(PlayerState3);
		_ ->
			{ok, PlayerState1}
	end;

handle({on_cure, CureProto, _CasterState}, PlayerState) ->
	Update = #player_state{
		db_player_attr = #db_player_attr{
			cur_hp = CureProto#proto_cure.cur_hp,
			cur_mp = CureProto#proto_cure.cur_mp
		}
	},
	player_lib:update_player_state(PlayerState, Update);

handle({buff_update, BuffUpdate, _CasterState}, PlayerState) ->
	?INFO("buff_update: ~p", [BuffUpdate]),
	{BuffDict, EffectDict, EffectSrcDict} = BuffUpdate,
	Update = #player_state{
		buff_dict = BuffDict,
		effect_dict = EffectDict,
		effect_src_dict = EffectSrcDict
	},
	player_lib:update_refresh_player(PlayerState, Update);

handle({call_pet, ScenePid, PetUid, MonsterId, Exp, CurHp}, PlayerState) ->
	pet_lib:add_pet(PlayerState, ScenePid, PetUid, MonsterId, Exp, CurHp);

handle({pet_update, ScenePid, PetUid, MonsterId, Exp, CurHp}, PlayerState) ->
	pet_lib:update_pet(PlayerState, ScenePid, PetUid, MonsterId, Exp, CurHp);

handle({pet_die, PetUid}, PlayerState) ->
	pet_lib:delete_pet(PlayerState, PetUid);

handle({join_guild, GuildId, GuildName, Pos}, PlayerState) ->
	guild_lib:create_player_guild_info(PlayerState, GuildId, GuildName, Pos),
	DbBase = PlayerState#player_state.db_player_base,
	DbBase1 = DbBase#db_player_base{guild_id = GuildId},
	PlayerState1 = PlayerState#player_state{db_player_base = DbBase1},
	player_lib:update_player_state(PlayerState, PlayerState1),

	%% 推送红点检测
	button_tips_lib:ref_button_tips(PlayerState1, ?BTN_GUILD_CONTRIBUTION),
	{ok, PlayerState1};

handle({get_player_detailed_info, Socket}, PlayerState) ->
	EquipsList = goods_lib:get_wear_equips_info_list(),
	DbBase = PlayerState#player_state.db_player_base,
	Fight = PlayerState#player_state.fighting,
	PlayerId = PlayerState#player_state.player_id,
	Name = DbBase#db_player_base.name,
	Sex = DbBase#db_player_base.sex,
	Lv = DbBase#db_player_base.lv,
	Career = DbBase#db_player_base.career,
	GuiseState = PlayerState#player_state.guise,
	ProtoGuise = player_lib:make_proto_guise(GuiseState),
	GuildName = guild_lib:get_guild_name(DbBase#db_player_base.guild_id),
	ProtoMark = player_lib:make_proto_mark(PlayerState#player_state.db_player_mark),
	Proto = #rep_get_player_info{
		player_id = PlayerId,
		name = Name,
		guild_name = GuildName,
		lv = Lv,
		sex = Sex,
		career = Career,
		fight = Fight,
		equips_list = EquipsList,
		guise = ProtoGuise,
		mark = ProtoMark,
		result = 0
	},
	net_send:send_to_client(Socket, 10011, Proto),
	{ok, PlayerState};

handle({boradcast_player_guild_info, PlayerGuildInfo}, PlayerState) ->
	guild_lib:push_player_guild_info(PlayerState, PlayerGuildInfo),
	{ok, PlayerState};

handle({leave_guild}, PlayerState) ->
	Update = #player_state{
		db_player_base = #db_player_base{
			guild_id = 0
		}
	},
	{ok, NewPlayerState} = player_lib:update_player_state(PlayerState, Update),
	guild_lib:push_player_leave_guild(NewPlayerState),
	{ok, NewPlayerState};
%% 更新军团信息
handle({boradcast_player_legion_info, PlayerGuildInfo, DbLegion}, PlayerState) ->
	GuildId = PlayerGuildInfo#db_player_legion.legion_id,
	Proto = #proto_player_legion_info{
		legion_id = GuildId,
		position = PlayerGuildInfo#db_player_legion.position,
		contribution = PlayerGuildInfo#db_player_legion.contribution,
		legion_lv = DbLegion#db_legion.lv,
		legion_name = DbLegion#db_legion.legion_name
	},
	net_send:send_to_client(PlayerState#player_state.pid, 37011, #rep_get_legion_member_info{player_legion_info = Proto}),
	{ok, PlayerState};
%% 军团离开
handle({leave_legion}, PlayerState) ->
	Update = #player_state{
		db_player_base = #db_player_base{
			guild_id = 0
		}
	},
	{ok, NewPlayerState} = player_lib:update_player_state(PlayerState, Update),
	net_send:send_to_client(NewPlayerState#player_state.pid, 37011, #rep_get_legion_member_info{player_legion_info = #proto_player_legion_info{}}),
	{ok, NewPlayerState};


handle({trade_success, GetJade, GetGoodsList}, PlayerState) ->
	{ok, PlayerState1} = transaction_lib:succ_trade(PlayerState, GetJade, GetGoodsList),
	{ok, PlayerState1};

handle({harm_player, AddPkValue}, PlayerState) ->
	GrayTime = util_date:unixtime() + 30,
	Update =
		case AddPkValue > 0 of
			true ->

				DbPlayerBase = PlayerState#player_state.db_player_base,
				OldPkValue = DbPlayerBase#db_player_base.pk_value,
				NewPkValue = min(OldPkValue + AddPkValue, ?MAX_PK_VALUE),
				NameColour = player_lib:get_name_colour(NewPkValue, GrayTime),
				#player_state{
					gray_time = GrayTime,
					name_colour = NameColour,
					db_player_base = #db_player_base{
						pk_value = NewPkValue
					}
				};
			_ ->
				DbPlayerBase = PlayerState#player_state.db_player_base,
				PkValue = DbPlayerBase#db_player_base.pk_value,
				NameColour = player_lib:get_name_colour(PkValue, GrayTime),
				#player_state{
					gray_time = GrayTime,
					name_colour = NameColour
				}
		end,
	player_lib:update_player_state(PlayerState, Update);

%% 切换场景
handle({change_scene, SceneId, ChangeType, Point}, PlayerState) ->
	scene_mgr_lib:change_scene(PlayerState, self(), SceneId, ChangeType, Point);

%% 成功切换场景
handle({succeed_change_scene, SceneId, {SceneObj, X, Y, SceneLineNum}, ScenePid}, PlayerState) ->
	HookState = player_lib:get_hook_state(),%% 获取挂机心跳信息
	PlayerState1 =
		case hook_lib:update_drive(PlayerState, HookState, ?HOOK_DRIVE_SERVER) of%% 更新挂机驱动
			{_PlayerState1, _HookState1} ->
				player_lib:put_hook_state(_HookState1),%% 修改挂机状态
				_PlayerState1;
			_ ->
				PlayerState
		end,

	#player_state{
		pet_dict = PetDict
	} = PlayerState1,
	%% 获取玩家所在场景的对象信息
	scene_send_lib_copy:send_scene_info_data(ScenePid, PlayerState1#player_state.pid, SceneObj),
	?INFO("~p ~p ~p", [ScenePid, PlayerState1#player_state.server_pass, SceneLineNum]),
	%% 切换场景成功后调用的函数(玩家进程调用)
	cross_lib:succeed_change_scene(PlayerState1, SceneId, ScenePid),

	DbPlayerBase = PlayerState1#player_state.db_player_base,
	OldPkMode = DbPlayerBase#db_player_base.pk_mode,
	SetPkMode = DbPlayerBase#db_player_base.set_pk_mode,
	%% 根据进入的场景id获取合理的pk模式
	NewPkMode = scene_mgr_lib:get_new_pk_mode(SceneId, OldPkMode, SetPkMode),
	Update =
		#player_state{
			scene_id = SceneId,
			scene_pid = ScenePid,
			scene_obj = SceneObj,
			scene_line_num = SceneLineNum,
			is_load_over = false,
			db_player_base = #db_player_base{pk_mode = NewPkMode, scene_id = SceneId, x = X, y = Y}
		},

	case player_lib:update_player_state(PlayerState1, Update) of
		{ok, NewPlayerState} ->
			%% 修改机器人相关信息
			robot_cross:exe_robot(change_sence, [NewPlayerState]),

			%% 通知宠物切换场景
			case PetDict /= dict:new() andalso DbPlayerBase#db_player_base.pet_att_type == ?ATTACK_TYPE_INITIATIVE of
				true ->
					F = fun(_, PetInfo) ->
						#pet_info{
							scene_pid = PetScenePid,
							uid = Uid
						} = PetInfo,
						case is_pid(ScenePid) of
							true ->
								obj_pet_lib:recall(PetScenePid, Uid, ScenePid, SceneId, self(), {X, Y});
							_ ->
								skip
						end
					end,
					dict:map(F, PetDict);
				_ ->
					skip
			end,

			task_comply:update_player_task_info_tool(NewPlayerState, ?TASKSORT_SCENE_GO_IN, SceneId, 1),

			%% 通知队伍进程
			case NewPlayerState#player_state.team_id > 0 of
				true ->
					team_lib:update_team_info(NewPlayerState, NewPlayerState#player_state.team_pid);
				_ ->
					skip
			end,
			{ok, NewPlayerState};
		{fail, Err} ->
			{fail, Err}
	end;

handle({move, {X, Y}}, PlayerState) ->
	Update =
		#player_state{
			db_player_base = #db_player_base{x = X, y = Y}
		},
	case player_lib:update_player_state(PlayerState, Update) of
		{ok, NewPlayerState} ->
			{ok, NewPlayerState};
		{fail, Err} ->
			{fail, Err}
	end;

handle({join_team, TeamId, TeamPid}, PlayerState) ->
	case PlayerState#player_state.team_id > 0 of
		false ->
			case gen_server:call(TeamPid, {'JOIN_TEAM', PlayerState, self()}) of
				{ok, _} ->
					PlayerState1 = PlayerState#player_state{team_id = TeamId, team_pid = TeamPid, leader = 0},
					player_lib:update_player_state(PlayerState, PlayerState1),
					{ok, PlayerState1};
				_ ->
					{ok, PlayerState}
			end;
		true ->
			{ok, PlayerState}
	end;

handle({invite_team_sw, TeamId, Name, InviteSocket, InviteId}, PlayerState) ->
	PlayerTeam = PlayerState#player_state.team_id,
	case PlayerState#player_state.team_switch_1 == 1 andalso PlayerTeam == 0 of
		true ->
			case team_lib:agree_team_invite(PlayerState, TeamId, 1, InviteId) of
				{ok, TeamPid} ->
					PlayerState1 = PlayerState#player_state{team_id = TeamId, leader = 0, team_pid = TeamPid},
					player_lib:update_player_state(PlayerState, PlayerState1),
					{ok, PlayerState1};
				_ ->
					{ok, PlayerState}
			end;
		false ->
			case PlayerTeam == 0 of
				true ->
					net_send:send_to_client(PlayerState#player_state.socket, 21005,
						#rep_broadcast_invite{team_id = TeamId, player_name = Name, player_id = InviteId}),
					{ok, PlayerState};
				false ->
					net_send:send_to_client(InviteSocket, 21004,
						#rep_invite_join_team{result = ?ERR_OTHER_HAVE_TEAM}),
					{ok, PlayerState}
			end
	end;

handle({apply_join_team_sw, PlayerId, Name}, PlayerState) ->
	case PlayerState#player_state.team_switch_2 == 1 of
		true ->
			team_lib:agree_apply_team(PlayerState, PlayerId, 1);
		false ->
			net_send:send_to_client(PlayerState#player_state.socket, 21008,
				#rep_broadcast_apply{player_id = PlayerId, player_name = Name})
	end,
	{ok, PlayerState};

handle({update_team_info, TeamId, Leader, TeamPid}, PlayerState) ->
	PlayerState1 = PlayerState#player_state{team_id = TeamId, leader = Leader, team_pid = TeamPid},
%% 如果队伍id为0 更新队伍列表
	case TeamId == 0 of
		true ->
			cross_lib:delete_player_team_from_ets(PlayerState1),
			team_lib:send_team_info(PlayerState1#player_state.pid, []);
		false ->
			skip
	end,
	player_lib:update_player_state(PlayerState, PlayerState1),
	{ok, PlayerState1};

handle({create_and_join_team, JoinDBP, JoinSocket, JoinPid}, PlayerState) ->
	#player_state{server_pass = ServerPass} = PlayerState,
	case not util_data:is_null(ServerPass) of
		true ->
			cross_lib:send_cross_mfc(ServerPass, team_lib, create_and_join_team, [PlayerState, JoinDBP, JoinSocket, JoinPid]);
		_ ->
			team_lib:create_and_join_team(PlayerState, JoinDBP, JoinSocket, JoinPid)
	end;


handle({add_goods_list, GoodsList, LogType}, PlayerState) ->
	case goods_lib_log:add_goods_list(PlayerState, GoodsList, LogType) of
		{ok, PlayerState1} ->
			PlayerState2 = PlayerState1#player_state{scene_parameters = []},
			{ok, PlayerState2};
		_ ->
			{ok, PlayerState}
	end;

handle({update_fh_cd, Cd, ObjType, ObjId}, PlayerState) ->
	Proto = #proto_obj_flag{type = ObjType, id = ObjId},
	net_send:send_to_client(PlayerState#player_state.socket, 11012, #rep_scene_revive{obj_flag = Proto}),
	player_lib:update_player_state(PlayerState, #player_state{db_player_base = #db_player_base{fh_cd = Cd}});

handle({add_skill_exp, SkillId}, PlayerState) ->
	skill_tree_lib:add_skill_exp(PlayerState, SkillId, 1);

%% 通关副本
handle({clearance_instance, SceneId}, PlayerState) ->
	{ok, PlayerState1} = task_comply:update_player_tasksort_past_fb(PlayerState, SceneId),
	{ok, PlayerState1};

%% 添加money类
handle({add_value, SubType, Num, Type}, PlayerState) ->
	{Type1, Message} = log_lib:get_type(Type),
	case SubType of
		?SUBTYPE_JADE ->
			player_lib:incval_on_player_money_log(PlayerState, #db_player_money.jade, Num, Type1);
		?SUBTYPE_COIN ->
			player_lib:incval_on_player_money_log(PlayerState, #db_player_money.coin, Num, Type1);
		?SUBTYPE_GIFT ->
			player_lib:incval_on_player_money_log(PlayerState, #db_player_money.gift, Num, Type1);
		?SUBTYPE_EXP ->
			player_lib:add_exp(PlayerState, Num, {Type1, Message});
		?SUBTYPE_REPUTATION ->
			arena_lib:add_player_arena_reputation(PlayerState, Num, Type1);
		?SUBTYPE_FEATS ->
			player_lib:incval_on_player_money_log(PlayerState, #db_player_money.feats, Num, Type1);
		_ ->
			{ok, PlayerState}
	end;

%% 红点推送
handle({update_button_tips, ButtonTipsId}, PlayerState) ->
	case ButtonTipsId == ?BTN_GUILD_BOSS orelse
		ButtonTipsId == ?BTN_GUILD_MJ of
		true ->
			DPB = PlayerState#player_state.db_player_base,
			GuildId = DPB#db_player_base.guild_id,
			case GuildId =/= 0 of
				true ->
					button_tips_lib:ref_button_tips(PlayerState, ButtonTipsId);
				false ->
					{ok, PlayerState}
			end;
		false ->
			button_tips_lib:ref_button_tips(PlayerState, ButtonTipsId)
	end;

%% 玩家击杀玩家
handle({kill_player, TargetState}, PlayerState) ->
	SceneId = PlayerState#player_state.scene_id,
	SceneConf = scene_config:get(SceneId),
	case is_record(TargetState, scene_obj_state) andalso SceneConf#scene_conf.add_pk_value > 0 of
		true ->
%% PK获得功勋
%% 击杀45级以上，且比自己低5级以内或自己高级的玩家才有效
%% 只能击杀非本行会的玩家才有效
			DPB = PlayerState#player_state.db_player_base,
			TargetLv = TargetState#scene_obj_state.lv,
			PlayerLv = DPB#db_player_base.lv,
			TargetGuildId = TargetState#scene_obj_state.guild_id,
			PlayerGuildId = DPB#db_player_base.guild_id,
			case TargetLv >= 45 andalso TargetLv >= PlayerLv - 5 andalso
				(TargetGuildId == 0 orelse PlayerGuildId == 0 orelse TargetGuildId =/= PlayerGuildId) of
				true ->
%% 满足以上条件，每次击杀后，可以获得20点功勋值，每天通过杀人获得的功勋值有上限，上限为500点(配置counter)
					PlayerId = PlayerState#player_state.player_id,
					CounterInfo = counter_lib:get_info(PlayerId, ?COUNTER_KILL_PLAYER),
					case CounterInfo#ets_player_counter.value < counter_lib:get_limit(?COUNTER_KILL_PLAYER) of
						true ->
%% 一天内击杀同一玩家超过3次后，再次击杀该玩家将不会再获得功勋值
							TargetId = TargetState#scene_obj_state.obj_id,
							Bool =
								case ets:lookup(?ETS_PLAYER_KILL, {PlayerId, TargetId}) of
									[R | _] ->
										case R#ets_player_kill.update_time =< util_date:get_today_unixtime() of
											true ->
												R1 = R#ets_player_kill{
													count = 1,
													update_time = util_date:unixtime()
												},
												ets:insert(?ETS_PLAYER_KILL, R1),
												true;
											false ->
												case R#ets_player_kill.count >= 3 of
													true ->
														false;
													false ->
														R1 = R#ets_player_kill{
															count = R#ets_player_kill.count + 1
														},
														ets:insert(?ETS_PLAYER_KILL, R1),
														true
												end
										end;
									_ ->
										R = #ets_player_kill{
											key = {PlayerId, TargetId},
											count = 1,
											update_time = util_date:unixtime()
										},
										ets:insert(?ETS_PLAYER_KILL, R),
										true
								end,
							case Bool of
								true ->
									counter_lib:update_value(PlayerId, ?COUNTER_KILL_PLAYER, CounterInfo#ets_player_counter.value + 20),
									player_lib:incval_on_player_money_log(PlayerState, #db_player_money.feats, 20, ?LOG_TYPE_KILL_PLAYER);
								false ->
									{ok, PlayerState}
							end;
						false ->
							{ok, PlayerState}
					end;
				false ->
					{ok, PlayerState}
			end;
		_ ->
			{ok, PlayerState}
	end;

%% 更新双倍经验状态
handle({update_double_exp}, PlayerState) ->
	{ok, NewPlayerState} = player_lib:update_double_exp(PlayerState),
	{ok, NewPlayerState};

%% 更新功能按钮
%% handle({update_function_button, State, List}, PlayerState) ->
%% 	NewPlayerState =
%% 		case State of
%% 			?FUNCTION_STATE_OPEN ->
%% 				function_lib:open_function_list(PlayerState, List);
%% 			?FUNCTION_STATE_CLOSE ->
%% 				function_lib:close_function_list(PlayerState, List)
%% 		end,
%% 	{ok, NewPlayerState};
handle({update_function_button, List}, PlayerState) ->
	NewPlayerState =
		lists:foldl(fun({State, ID}, Acc) ->
			case State of
				?FUNCTION_STATE_OPEN ->
					function_lib:open_function_list(Acc, [ID]);
				?FUNCTION_STATE_CLOSE ->
					function_lib:close_function_list(Acc, [ID])
			end
		end, PlayerState, List),
	{ok, NewPlayerState};


%% 初始化玩家信息
handle({init_player_state2}, PlayerState) ->
	{ok, NewPlayerState} = player_lib:init_player_state2(PlayerState),
	{ok, NewPlayerState};


handle(Request, State) ->
	?ERR("unknown mod player cast request: ~p", [Request]),
	{ok, State}.

%% ====================================================================
%% Internal functions
%% ====================================================================
