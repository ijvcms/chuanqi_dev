%%%-------------------------------------------------------------------
%%% @author zhengsiying
%%% @copyright (C) 2015, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 24. 九月 2015 下午4:20
%%%-------------------------------------------------------------------
-module(buff_base_lib).

-include("common.hrl").
-include("record.hrl").
-include("cache.hrl").
-include("config.hrl").
-include("proto.hrl").
-include("language_config.hrl").

%% API
-export([
	init/1,
	trigger/4,
	trigger/3,
	store_buff/3,
	remove_buff/2,
	get_buff_effect/3,
	get_buff_attr/3,
	remove_effect_buff/2,
	trigger_effect/1,
	trigger_effect/2,
	send_buff_info/1,
	send_buff_info/2,
	remove_abnormal_buff/1
]).

%% ====================================================================
%% API functions
%% ====================================================================
init(PlayerState) ->
	PlayerId = PlayerState#player_state.player_id,
	PlayerState1 = PlayerState#player_state{buff_dict = dict:new(), effect_dict = dict:new(), effect_src_dict = dict:new()},
	case buff_cache:select_all(PlayerId) of
		[] ->
			PlayerState1;
		List ->
			CurTime = util_date:unixtime(),
			F = fun(Buff, Acc) ->
				BuffId = Buff#db_buff.buff_id,
				BuffConf = buff_config:get(BuffId),
				EffectId = BuffConf#buff_conf.effect_id,
				case EffectId of
					?BUFF_EFFECT_EXP -> %% 双倍经验buff检测(下线保留 重算有效时间)
						DBP = PlayerState#player_state.db_player_base,
						LastLogoutTime = DBP#db_player_base.last_logout_time,
						case Buff#db_buff.remove_time =< LastLogoutTime of
							true ->
								buff_cache:delete({PlayerId, BuffId}),
								Acc;
							_ ->
								RemoveTime = CurTime + Buff#db_buff.remove_time - LastLogoutTime,
								store_buff(Acc, BuffId, Buff#db_buff{remove_time = RemoveTime})
						end;
					?BUFF_EFFECT_ATTR_PLUS -> %% 属性buff强化版(下线保留 重算有效时间)
						DBP = PlayerState#player_state.db_player_base,
						LastLogoutTime = DBP#db_player_base.last_logout_time,
						case Buff#db_buff.remove_time =< LastLogoutTime of
							true ->
								buff_cache:delete({PlayerId, BuffId}),
								Acc;
							_ ->
								RemoveTime = CurTime + Buff#db_buff.remove_time - LastLogoutTime,
								store_buff(Acc, BuffId, Buff#db_buff{remove_time = RemoveTime})
						end;
					_ -> %% 其他buff统一处理
						case Buff#db_buff.remove_time < CurTime of
							true ->
								buff_cache:delete({PlayerId, BuffId}),
								Acc;
							_ ->
								store_buff(Acc, BuffId, Buff)
						end
				end
			end,
			NewPlayerState = lists:foldl(F, PlayerState1, List),
			NewPlayerState
	end.

%% 移除减异buff(目前有中毒 降防) 玩家死亡移除所有负面buff信息
remove_abnormal_buff(PlayerState) when is_record(PlayerState, player_state) ->
	F = fun(BuffId, Buff, Acc) ->
		BuffId = Buff#db_buff.buff_id,
		case lists:member(BuffId, ?ABNORMAL_BUFF_ID_LIST) of
			true ->
				buff_cache:delete({Acc#player_state.player_id, BuffId}),
				remove_buff(Acc, BuffId);
			_ ->
				Acc
		end
	end,
	NewPlayerState = dict:fold(F, PlayerState, PlayerState#player_state.buff_dict),
	{ok, NewPlayerState}.

get_buff_effect(BuffDict, EffectDict, EffectId) ->
	case dict:find(EffectId, EffectDict) of
		{ok, BuffList} ->
			CurTime = util_date:unixtime(),
			F = fun(BuffId, Acc) ->
				case dict:find(BuffId, BuffDict) of
					{ok, #db_buff{remove_time = RT} = Buff} when RT >= CurTime ->
						BuffConf = buff_config:get(BuffId),
						buff_rule_lib:attach_effect(EffectId, BuffConf#buff_conf.rule, Buff, Acc);
					_ ->
						Acc
				end
			end,
			lists:foldl(F, #buff_effect{effect_id = EffectId}, BuffList);
		_ ->
			#buff_effect{effect_id = EffectId}
	end.

get_buff_attr(BuffDict, EffectDict, BaseAttr) ->
	BuffEffect = buff_base_lib:get_buff_effect(BuffDict, EffectDict, ?BUFF_EFFECT_ATTR),
	AttrChange = BuffEffect#buff_effect.attr_change,
	Attr1 = api_attr:compute_base_attr_p(BaseAttr, AttrChange),
	api_attr:attach_attr([AttrChange, Attr1]).

%% 只有玩家进程可以调用
trigger_effect(PlayerState) when is_record(PlayerState, player_state) ->
	{NewPlayerState, BuffResultList, RemoveList, _} = trigger_effect1(PlayerState),
	%% 移除buff信息
	case RemoveList /= [] of
		true ->
			[buff_cache:delete({PlayerState#player_state.player_id, BuffId}) || BuffId <- RemoveList],
			scene_skill_lib:remove_buff(PlayerState#player_state.scene_pid, ?OBJ_TYPE_PLAYER, PlayerState#player_state.player_id, RemoveList);
		_ ->
			skip
	end,
	%% buff效果值触发执行
	sync_trigger_effect_to_scene(NewPlayerState, lists:reverse(BuffResultList)),
	{ok, NewPlayerState, RemoveList}.
%% 场景进程调用
trigger_effect(SceneState, ObjState) ->
	case ObjState#scene_obj_state.buff_dict /= dict:new() of
		true ->
			CurTime = util_date:unixtime(),
			BuffTime = ObjState#scene_obj_state.buff_time,
			case BuffTime < CurTime of
				true ->
					{NewObjState, BuffResultList, _RemoveList, KillObjId} = trigger_effect1(ObjState),
					NewObjState1 = NewObjState#scene_obj_state{buff_time = CurTime + 1},
					%% 保存非常影响效率
					NewSceneState = scene_base_lib:store_scene_obj_state(SceneState, NewObjState1, ObjState),
					#scene_obj_state{
						obj_type = ObjType,
						obj_id = ObjId
					} = NewObjState1,
%% 					case RemoveList /= [] of
%% 						true ->
%% 							%% 移除buff推送信息
%% 							scene_skill_lib:do_remove_buff(NewSceneState, NewObjState1, RemoveList);
%% 						_ ->
%% 							skip
%% 					end,
					case length(BuffResultList) > 0 of
						true ->
							%% buff效果变化信息
							scene_send_lib:do_send_buff_effect(NewSceneState, ObjType, ObjId, BuffResultList);
						_ ->
							skip
					end,
					{NewSceneState, NewObjState1, KillObjId};
				_ ->
					{SceneState, ObjState, null}
			end;
		_ ->
			{SceneState, ObjState, null}
	end.
%% buff逻辑处理
trigger_effect1(ObjState) ->
	{BuffDict, EffectDict, EffectSrcDict} = get_buff_and_effect_dict(ObjState),
	case BuffDict /= dict:new() of
		true ->
			CurTime = util_date:unixtime(),
			F = fun(BuffId, Buff, Acc) ->
%%  				?ERR("~p ~p", [BuffId, Buff]),
				{ObjState1, BuffResultList1, RemoveList, KillObjId} = Acc,
				#buff_conf{
					effect_id = EffectId, %% 效果id
					src_id = SrcId, %% 来源
					interval = InterVal %% buff间隔
				} = buff_config:get(BuffId),
				%% 获取buff的执行时间
				#db_buff{next_time = NextTime, remove_time = RemoveTime} = Buff,
				%% buff的移除时间
				case RemoveTime > CurTime of
					true ->
						%% buff的效果值计算
						case InterVal /= 0 andalso NextTime =< CurTime of
							true ->
								%% 通过效果id 获取效果属性集合
								BuffEffect = get_buff_effect(BuffDict, EffectDict, EffectId),
								%% 触发效果信息
								case buff_rule_lib:trigger_effect(EffectId, ObjState1, Buff, BuffEffect) of
									{ObjState2, BuffResult} ->
										%% 加血效果
										NewNextTime = Buff#db_buff.next_time + InterVal,
										NewBuff = Buff#db_buff{next_time = NewNextTime},
										case is_record(ObjState, player_state) of
											true ->
												buff_cache:update({ObjState#player_state.player_id, BuffId}, NewBuff);
											_ ->
												skip
										end,
										NewBuffDict = dict:store(BuffId, NewBuff, BuffDict),
										%% 修改对象的buff信息
										ObjState3 = update_buff_and_effect_dict(ObjState2, NewBuffDict, EffectDict, EffectSrcDict),
										{ObjState3, [BuffResult | BuffResultList1], RemoveList, KillObjId};
									{ObjState2, BuffResult, NewKillObjId} ->
										%% 减血效果
										NewNextTime = Buff#db_buff.next_time + InterVal,
										NewBuff = Buff#db_buff{next_time = NewNextTime},
										case is_record(ObjState, player_state) of
											true ->
												buff_cache:update({ObjState#player_state.player_id, BuffId}, NewBuff);
											_ ->
												skip
										end,
										NewBuffDict = dict:store(BuffId, NewBuff, BuffDict),
										%% 修改对象的buff信息
										ObjState3 = update_buff_and_effect_dict(ObjState2, NewBuffDict, EffectDict, EffectSrcDict),
										{ObjState3, [BuffResult | BuffResultList1], RemoveList, NewKillObjId};
									_ ->
										%% 返回错误类型
										Acc
								end;
							_ ->
								%% 时间未到
								Acc
						end;
					_ ->
						%% 加入buff移除列表
						NewRemoveList = [BuffId | RemoveList],
						%% 移除buff
						NewBuffDict = dict:erase(BuffId, BuffDict),
						%% 效果表信息处理
						NewEffectDict =
							case dict:find(EffectId, EffectDict) of
								{ok, BuffList} ->
									%% 删除效果表里面的buffid信息
									NewBuffList = lists:delete(BuffId, BuffList),
									dict:store(EffectId, NewBuffList, EffectDict);
								_ ->
									EffectDict
							end,
						%% 移除来源效果表信息
						NewEffectSrcDict =
							case dict:find({EffectId, SrcId}, EffectSrcDict) of
								{ok, _BuffId} ->
									dict:erase({EffectId, SrcId}, EffectSrcDict);
								_ ->
									EffectSrcDict
							end,
						ObjState2 = update_buff_and_effect_dict(ObjState1, NewBuffDict, NewEffectDict, NewEffectSrcDict),
						{ObjState2, BuffResultList1, NewRemoveList, KillObjId}
				end
			end,
			dict:fold(F, {ObjState, [], [], null}, BuffDict);
		_ ->
			{ObjState, [], [], null}
	end.


%% %% buff逻辑处理
%% cleat_effect1(ObjState) ->
%% 	{BuffDict, EffectDict, EffectSrcDict} = get_buff_and_effect_dict(ObjState),
%% 	CurTime = util_date:unixtime(),
%% 	F = fun(BuffId, Buff, Acc) ->
%% 		BuffConf = buff_config:get(BuffId),
%% 		NewBuff = Buff#db_buff{remove_time = 0},
%% 		case is_record(ObjState, player_state) of
%% 			true ->
%% 				buff_cache:update({ObjState#player_state.player_id, BuffId}, NewBuff);
%% 			_ ->
%% 				skip
%% 		end,
%% 		NewBuffDict = dict:store(BuffId, NewBuff, BuffDict)
%% 	end,
%% 	dict:fold(F, {ObjState, [], null}, BuffDict).

sync_trigger_effect_to_scene(ObjState, BuffResultList) ->
	case BuffResultList /= [] of
		true ->
			{ScenePid, ObjType, ObjId, CurHp, CurMp, BuffDict} = get_sync_trigger_effect_info(ObjState),
			Update = #scene_obj_state{
				buff_dict = BuffDict,
				cur_hp = CurHp,
				cur_mp = CurMp
			},
%% 			?ERR("buff result : ~p", [{CurHp,CurMp}]),
			scene_skill_lib:trigger_buff_effect(ScenePid, ObjType, ObjId, Update, BuffResultList);
		_ ->
			skip
	end.

get_sync_trigger_effect_info(ObjState) when is_record(ObjState, player_state) ->
	#player_state{
		scene_pid = ScenePid,
		player_id = ObjId,
		db_player_attr = DbAttr,
		buff_dict = BuffDict
	} = ObjState,

	#db_player_attr{
		cur_hp = CurHp,
		cur_mp = CurMp
	} = DbAttr,
	{ScenePid, ?OBJ_TYPE_PLAYER, ObjId, CurHp, CurMp, BuffDict}.

%% 触发buff
trigger(CasterState, TargetState, BuffId, Rate) ->
	%% 检测怪物是否有晕眩抗性 中毒抗性 麻痹抗性
	case check_monster_resist(TargetState, BuffId) of
		true -> skip;
		false ->
			case util_rand:rand_hit(Rate) of
				true ->
					BuffDict = TargetState#combat_obj.buff_dict,
					case dict:find(BuffId, BuffDict) of
						{ok, Buff} ->
							trigger_same_buff(CasterState, TargetState, BuffId, Buff);
						_ ->
							trigger_different_buff(CasterState, TargetState, BuffId)
					end;
				_ ->
					skip
			end
	end.
%% 新增buff(只有玩家进程可以调用 不需要通知场景 玩家独立的状态buff)
trigger(PlayerState, BuffId, Rate) ->
	case util_rand:rand_hit(Rate) of
		true ->
			BuffDict = PlayerState#player_state.buff_dict,
			{ok, NewPlayerState} =
				case dict:find(BuffId, BuffDict) of
					{ok, Buff} ->
						trigger_same_buff(PlayerState, BuffId, Buff);
					_ ->
						trigger_different_buff(PlayerState, BuffId)
				end,
			Update = #scene_obj_state{
				buff_dict = NewPlayerState#player_state.buff_dict,
				effect_dict = NewPlayerState#player_state.effect_dict,
				effect_src_dict = NewPlayerState#player_state.effect_src_dict
			},
%% 			{ok, NewPlayerState2} = player_lib:update_double_exp(NewPlayerState),
			scene_obj_lib:update_obj(NewPlayerState#player_state.scene_pid, ?OBJ_TYPE_PLAYER, NewPlayerState#player_state
			.player_id, Update, true),
			{ok, NewPlayerState};
		_ ->
			skip
	end.

%% 触发相同buff id的buff
trigger_same_buff(CasterState, TargetState, BuffId, Buff) ->
	ObjType = TargetState#combat_obj.obj_type,
	ObjId = TargetState#combat_obj.obj_id,
	CurTime = util_date:unixtime(),
	BuffConf = buff_config:get(BuffId),
	{IsUpdate, NewBuff} =
		case buff_rule_lib:check_stack_rule(BuffConf#buff_conf.effect_id, CasterState, TargetState, Buff, BuffId, BuffId) of
			?STACK_RULE_REPLACE ->
				Buff1 = Buff#db_buff{
					remove_time = CurTime + BuffConf#buff_conf.duration
				},
				{true, Buff1};
			?STACK_RULE_TIME_ACCUMULATION ->
				Buff1 = Buff#db_buff{
					remove_time = Buff#db_buff.remove_time + BuffConf#buff_conf.duration
				},
				{true, Buff1};
			{?STACK_RULE_REPLACE, ExtraInfo} ->
				Buff1 = Buff#db_buff{
					extra_info = ExtraInfo,
					next_time = CurTime,
					remove_time = CurTime + BuffConf#buff_conf.duration
				},
				{true, Buff1};
			_ ->
				{false, null}
		end,

	case IsUpdate of
		true ->
			#skill_result{
				skill_cmd = ?SKILL_CMD_BUFF,
				obj_type = ObjType,
				obj_id = ObjId,
				result = [
					#buff_result{
						operate = ?BUFF_OPERATE_UPDATE,
						buff_id = BuffId,
						buff_info = NewBuff
					}
				]
			};
		_ ->
			skip
	end.
trigger_same_buff(PlayerState, BuffId, Buff) ->
	CurTime = util_date:unixtime(),
	BuffConf = buff_config:get(BuffId),
	{_IsUpdate, NewBuff} =
		case buff_rule_lib:check_stack_rule(BuffConf#buff_conf.effect_id, PlayerState, Buff, BuffId, BuffId) of
			?STACK_RULE_REPLACE ->
				Buff1 = Buff#db_buff{
					remove_time = CurTime + BuffConf#buff_conf.duration
				},
				{true, Buff1};
			?STACK_RULE_TIME_ACCUMULATION ->
				Buff1 = Buff#db_buff{
					remove_time = Buff#db_buff.remove_time + BuffConf#buff_conf.duration
				},
				{true, Buff1};
			{?STACK_RULE_REPLACE, ExtraInfo} ->
				Buff1 = Buff#db_buff{
					extra_info = ExtraInfo,
					next_time = CurTime,
					remove_time = CurTime + BuffConf#buff_conf.duration
				},
				{true, Buff1};
			_ ->
				{false, null}
		end,

	case _IsUpdate of
		true ->
			NewPlayerState = store_buff(PlayerState, BuffId, NewBuff),
			{ok, NewPlayerState};
		_ ->
			{ok, PlayerState}
	end.

%% 触发不同buff id的buff
trigger_different_buff(CasterState, TargetState, BuffId) ->
	try
		ObjType = TargetState#combat_obj.obj_type,
		ObjId = TargetState#combat_obj.obj_id,
		CurTime = util_date:unixtime(),
		BuffConf = buff_config:get(BuffId),
		EffectId = BuffConf#buff_conf.effect_id,
		SrcId = BuffConf#buff_conf.src_id,
		%% 被释放者的效果dict
		EffectSrcDict = TargetState#combat_obj.effect_src_dict,
		%% 在效果表里面找到 buffid
		case dict:find({EffectId, SrcId}, EffectSrcDict) of
			{ok, BuffId1} ->
				BuffDict = TargetState#combat_obj.buff_dict,
				{IsUpdate, NewBuff} =
					case dict:find(BuffId1, BuffDict) of
						{ok, Buff} ->
							case buff_rule_lib:check_stack_rule(BuffConf#buff_conf.effect_id, CasterState, TargetState, Buff, BuffId1, BuffId) of
								?STACK_RULE_REPLACE ->
									Buff1 = #db_buff{
										player_id = ObjId,
										buff_id = BuffId,
										remove_time = CurTime + BuffConf#buff_conf.duration
									},
									{true, Buff1};
								{?STACK_RULE_REPLACE, ExtraInfo} ->
									Buff1 = Buff#db_buff{
										buff_id = BuffId,
										extra_info = ExtraInfo,
										next_time = CurTime,
										remove_time = CurTime + BuffConf#buff_conf.duration
									},
									{true, Buff1};
								_RR ->
									{false, null}
							end;
						_ ->
							?ERR("buffid ~p effid ~p buffdict:~p effdict:~p", [BuffId1, {EffectId, SrcId}, dict:to_list(BuffDict), dict:to_list(EffectSrcDict)]),
%% 							NewBuff1 = #db_buff{
%% 								player_id = ObjId,
%% 								buff_id = BuffId,
%% 								remove_time = CurTime + BuffConf#buff_conf.duration,
%% 								next_time = CurTime,
%% 								extra_info = buff_rule_lib:make_extra_info(EffectId, CasterState, TargetState, BuffId)
%% 							},
%% 							Res1 = #skill_result{
%% 								skill_cmd = ?SKILL_CMD_BUFF,
%% 								obj_type = ObjType,
%% 								obj_id = ObjId,
%% 								result = [
%% 									#buff_result{
%% 										operate = ?BUFF_OPERATE_ADD,
%% 										buff_id = BuffId,
%% 										buff_info = NewBuff1
%% 									}
%% 								]
%% 							},
							{false, null}
					end,
				case IsUpdate of
					true ->
						#skill_result{
							skill_cmd = ?SKILL_CMD_BUFF,
							obj_type = ObjType,
							obj_id = ObjId,
							result = [
								#buff_result{
									operate = ?BUFF_OPERATE_DELETE,
									buff_id = BuffId1
								},
								#buff_result{
									operate = ?BUFF_OPERATE_ADD,
									buff_id = BuffId,
									buff_info = NewBuff
								}
							]
						};
					_ ->
						skip
				end;
			_ ->
				NewBuff = #db_buff{
					player_id = ObjId,
					buff_id = BuffId,
					remove_time = CurTime + BuffConf#buff_conf.duration,
					next_time = CurTime,
					extra_info = buff_rule_lib:make_extra_info(EffectId, CasterState, TargetState, BuffId)
				},
				#skill_result{
					skill_cmd = ?SKILL_CMD_BUFF,
					obj_type = ObjType,
					obj_id = ObjId,
					result = [
						#buff_result{
							operate = ?BUFF_OPERATE_ADD,
							buff_id = BuffId,
							buff_info = NewBuff
						}
					]
				}
		end
	catch
		Class:Err ->
			BuffConf1 = buff_config:get(BuffId),
			EffectId1 = BuffConf1#buff_conf.effect_id,
			SrcId1 = BuffConf1#buff_conf.src_id,
			EffectSrcDict1 = TargetState#combat_obj.effect_src_dict,
			{ok, BuffId2} = dict:find({EffectId1, SrcId1}, EffectSrcDict1),
			?ERR("trigger different buff error ~p,~p error:~n{~p: ~p ~p}", [BuffId, BuffId2, Class, Err, erlang:get_stacktrace()]),
			skip
	end.
trigger_different_buff(PlayerState, BuffId) ->
	CurTime = util_date:unixtime(),
	BuffConf = buff_config:get(BuffId),
	EffectId = BuffConf#buff_conf.effect_id,
	SrcId = BuffConf#buff_conf.src_id,
	EffectSrcDict = PlayerState#player_state.effect_src_dict,
	case dict:find({EffectId, SrcId}, EffectSrcDict) of
		{ok, BuffId1} ->
			BuffDict = PlayerState#player_state.buff_dict,
			{ok, Buff} = dict:find(BuffId1, BuffDict),
			{_IsUpdate, NewBuff} =
				case buff_rule_lib:check_stack_rule(BuffConf#buff_conf.effect_id, PlayerState, Buff, BuffId1, BuffId) of
					?STACK_RULE_REPLACE ->
						Buff1 = #db_buff{
							player_id = PlayerState#player_state.player_id,
							buff_id = BuffId,
							remove_time = CurTime + BuffConf#buff_conf.duration,
							next_time = CurTime,
							extra_info = buff_rule_lib:make_extra_info(EffectId, null, null, BuffId)
						},
						{true, Buff1};
					_ ->
						{false, null}
				end,

			case _IsUpdate of
				true ->
					PlayerState1 = remove_buff(PlayerState, BuffId1),
					NewPlayerState = store_buff(PlayerState1, BuffId, NewBuff),
					{ok, NewPlayerState};
				_ ->
					{ok, PlayerState}
			end;
		_ ->
			NewBuff = #db_buff{
				player_id = PlayerState#player_state.player_id,
				buff_id = BuffId,
				remove_time = CurTime + BuffConf#buff_conf.duration,
				next_time = CurTime,
				extra_info = buff_rule_lib:make_extra_info(EffectId, null, null, BuffId)
			},
			NewPlayerState = store_buff(PlayerState, BuffId, NewBuff),
			{ok, NewPlayerState}
	end.

%% 添加或者更新buff
store_buff(ObjState, BuffId, Buff) ->
	{BuffDict, EffectDict, EffectSrcDict} = get_buff_and_effect_dict(ObjState),
	{BuffDict1, EffectDict1, EffectSrcDict1} = store_buff1(BuffId, Buff, BuffDict, EffectDict, EffectSrcDict),
	update_buff_and_effect_dict(ObjState, BuffDict1, EffectDict1, EffectSrcDict1).

store_buff1(BuffId, Buff, BuffDict, EffectDict, EffectSrcDict) ->
	BuffDict1 = dict:store(BuffId, Buff, BuffDict),

	#buff_conf{
		effect_id = EffectId,
		src_id = SrcId
	} = buff_config:get(BuffId),
	EffectDict1 =
		case dict:find(EffectId, EffectDict) of
			{ok, BuffList} ->
				NewBuffList = util_list:store(BuffId, BuffList),
				dict:store(EffectId, NewBuffList, EffectDict);
			_ ->
				dict:store(EffectId, [BuffId], EffectDict)
		end,

	EffectSrcDict1 = dict:store({EffectId, SrcId}, BuffId, EffectSrcDict),
	{BuffDict1, EffectDict1, EffectSrcDict1}.

%% 移除同种效果buff
remove_effect_buff(ObjState, EffectId) ->
	{_BuffDict, EffectDict, _EffectSrcDict} = get_buff_and_effect_dict(ObjState),
	case dict:find(EffectId, EffectDict) of
		{ok, BuffList} when BuffList /= [] ->
			F = fun(BuffId, Acc) ->
				remove_buff(Acc, BuffId)
			end,
			NewObjState = lists:foldl(F, ObjState, BuffList),

			case is_record(NewObjState, scene_obj_state) of
				true ->
					sync_buff_update_to_obj(NewObjState);
				_ ->
					skip
			end,
			{NewObjState, BuffList};
		_ ->
			{ObjState, []}
	end.

sync_buff_update_to_obj(ObjState) ->
	#scene_obj_state{
		buff_dict = BuffDict,
		effect_dict = EffectDict,
		effect_src_dict = EffectSrcDict
	} = ObjState,
	BuffUpdate = {BuffDict, EffectDict, EffectSrcDict},
	case ObjState#scene_obj_state.obj_type of
		?OBJ_TYPE_PLAYER ->
			gen_server2:cast(ObjState#scene_obj_state.obj_pid, {buff_update, BuffUpdate, null});
		_ ->
			skip
	end.

%% 移除单个buff
remove_buff(ObjState, BuffId) ->
	{BuffDict, EffectDict, EffectSrcDict} = get_buff_and_effect_dict(ObjState),
	{BuffDict1, EffectDict1, EffectSrcDict1} = remove_buff1(BuffId, BuffDict, EffectDict, EffectSrcDict),
	update_buff_and_effect_dict(ObjState, BuffDict1, EffectDict1, EffectSrcDict1).

remove_buff1(BuffId, BuffDict, EffectDict, EffectSrcDict) ->
	BuffDict1 = dict:erase(BuffId, BuffDict),

	#buff_conf{
		effect_id = EffectId,
		src_id = SrcId
	} = buff_config:get(BuffId),
	EffectDict1 =
		case dict:find(EffectId, EffectDict) of
			{ok, BuffList} ->
				NewBuffList = lists:delete(BuffId, BuffList),
				dict:store(EffectId, NewBuffList, EffectDict);
			_ ->
				EffectDict
		end,

	EffectSrcDict1 = dict:erase({EffectId, SrcId}, EffectSrcDict),
	{BuffDict1, EffectDict1, EffectSrcDict1}.

%% ====================================================================
%% Internal functions
%% ====================================================================
get_buff_and_effect_dict(PlayerState) when is_record(PlayerState, player_state) ->
	#player_state{
		buff_dict = BuffDict,
		effect_dict = EffectDict,
		effect_src_dict = EffectSrcDict
	} = PlayerState,
	{BuffDict, EffectDict, EffectSrcDict};
get_buff_and_effect_dict(SceneObjState) when is_record(SceneObjState, scene_obj_state) ->
	#scene_obj_state{
		buff_dict = BuffDict,
		effect_dict = EffectDict,
		effect_src_dict = EffectSrcDict
	} = SceneObjState,
	{BuffDict, EffectDict, EffectSrcDict};
get_buff_and_effect_dict(HookObjState) when is_record(HookObjState, hook_obj_state) ->
	#hook_obj_state{
		buff_dict = BuffDict,
		effect_dict = EffectDict,
		effect_src_dict = EffectSrcDict
	} = HookObjState,
	{BuffDict, EffectDict, EffectSrcDict}.

update_buff_and_effect_dict(PlayerState, BuffDict, EffectDict, EffectSrcDict) when is_record(PlayerState, player_state) ->
	PlayerState#player_state{buff_dict = BuffDict, effect_dict = EffectDict, effect_src_dict = EffectSrcDict};
update_buff_and_effect_dict(SceneObjState, BuffDict, EffectDict, EffectSrcDict) when is_record(SceneObjState, scene_obj_state) ->
	SceneObjState#scene_obj_state{buff_dict = BuffDict, effect_dict = EffectDict, effect_src_dict = EffectSrcDict};
update_buff_and_effect_dict(HookObjState, BuffDict, EffectDict, EffectSrcDict) when is_record(HookObjState, hook_obj_state) ->
	HookObjState#hook_obj_state{buff_dict = BuffDict, effect_dict = EffectDict, effect_src_dict = EffectSrcDict}.

%% 推送玩家最新的buff
send_buff_info(PlayerState) ->
	DbBase = PlayerState#player_state.db_player_base,
	BloodValue = DbBase#db_player_base.blood_bag,
	IsDouble = PlayerState#player_state.is_double_exp,

	SpecBuff1 = case BloodValue > 0 of true -> [#proto_spec_buff{type = 1, value = BloodValue, countdown = 0}]; false ->
		[] end,
	SpecBuff2 = case IsDouble == 0 of true -> []; false -> [#proto_spec_buff{type = 2, value = 0, countdown = 0}] end,
%% 	SpecBuff3 = case buff_config:get(VipBuffId) of
%% 					#buff_conf{} = _R ->
%% 						[#proto_spec_buff{type = VipBuffId, value = 0, countdown = 0}];
%% 					_ ->
%% 						[]
%% 				end,
	ProtoSpecBuff = lists:concat([SpecBuff1, SpecBuff2]),
	ProtoBuff = scene_send_lib:make_buff_list(PlayerState#player_state.buff_dict),
	Fun = fun(BuffInfo, Acc) ->
		BuffId = BuffInfo#proto_buff.buff_id,
		BuffConf = buff_config:get(BuffId),
		case BuffConf#buff_conf.show == 1 of
			true -> lists:concat([[BuffInfo],Acc]);
			false -> Acc
		end
	end,
	ProtoBuff1 = lists:foldl(Fun, [], ProtoBuff),
	net_send:send_to_client(PlayerState#player_state.pid, 10012, #rep_get_player_buff_flag{spec_buff_list = ProtoSpecBuff, buff_list = ProtoBuff1}).
send_buff_info(PlayerState, BuffDict) ->
	DbBase = PlayerState#player_state.db_player_base,
	BloodValue = DbBase#db_player_base.blood_bag,
%% 	VipLv = DbBase#db_player_base.vip,
%% 	Career = DbBase#db_player_base.career,
%% 	VipConf = vip_config:get(VipLv, Career),
%% 	VipBuffId = VipConf#vip_conf.vipbuffid,
	IsDouble = PlayerState#player_state.is_double_exp,
	SpecBuff1 = case BloodValue > 0 of true -> [#proto_spec_buff{type = 1, value = BloodValue, countdown = 0}]; false ->
		[] end,
	SpecBuff2 = case IsDouble == 0 of true -> []; false -> [#proto_spec_buff{type = 2, value = 0, countdown = 0}] end,
%% 	SpecBuff3 = case buff_config:get(VipBuffId) of
%% 					#buff_conf{} = _R ->
%% 						[#proto_spec_buff{type = VipBuffId, value = 0, countdown = 0}];
%% 					_ ->
%% 						[]
%% 				end,
	ProtoSpecBuff = lists:concat([SpecBuff1, SpecBuff2]),
	ProtoBuff = scene_send_lib:make_buff_list(BuffDict),
	Fun = fun(BuffInfo, Acc) ->
		BuffId = BuffInfo#proto_buff.buff_id,
		BuffConf = buff_config:get(BuffId),
		case BuffConf#buff_conf.show == 1 of
			true -> [BuffInfo] ++ Acc;
			false -> Acc
		end
	end,
	ProtoBuff1 = lists:foldl(Fun, [], ProtoBuff),
	net_send:send_to_client(PlayerState#player_state.pid, 10012, #rep_get_player_buff_flag{spec_buff_list = ProtoSpecBuff, buff_list = ProtoBuff1}).


%% 检测怪物是否有晕眩抗性 中毒抗性 麻痹抗性
check_monster_resist(TargetState, BuffId) ->
	case TargetState#combat_obj.obj_type of
		?OBJ_TYPE_MONSTER ->
			BuffIdConf = buff_config:get(BuffId),
			MonsterConf = monster_config:get(TargetState#combat_obj.monster_id),
			case BuffIdConf#buff_conf.effect_id of
				?BUFF_EFFECT_STUN ->
					MonsterConf#monster_conf.is_resist_stun == 1;
				?BUFF_EFFECT_POISON ->
					MonsterConf#monster_conf.is_resist_poison == 1;
				?BUFF_EFFECT_MB ->
					MonsterConf#monster_conf.is_resist_mb == 1;
				?BUFF_EFFECT_SILENT ->
					MonsterConf#monster_conf.is_resist_silent == 1;
				_ ->
					false
			end;
		_ ->
			false
	end.
