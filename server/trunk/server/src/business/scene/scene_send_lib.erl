%%%-------------------------------------------------------------------
%%% @author zhengsiying
%%% @copyright (C) 2015, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 09. 十一月 2015 下午4:46
%%%-------------------------------------------------------------------
-module(scene_send_lib).

-include("common.hrl").
-include("record.hrl").
-include("proto.hrl").
-include("cache.hrl").
-include("config.hrl").

%% API
-export([
	send_screen/5,
	send_screen2/5,
	send_scene/3,
	send_enter_screen/2,
	send_enter_screen/3,
	send_enter_screen/4,
	send_leave_screen/2,
	send_leave_screen/3,
	send_enter_screen_pet/2,
	send_scene_info_data/3,
	send_move_sync/3,
	send_monster_update/2,
	send_scene_near_team_info/3,
	send_scene_near_player_info/3,
	send_scene_teammate_flag/4,
	send_screen_player_update/4,
	send_screen_pet_update/3,
	make_rep_obj_enter/2,
	send_screen_player/2,
	send_buff_effect/4,
	make_buff_list/1,
	make_hp_mp_update_list/2,
	make_rep_obj_often_update/2,
	make_rep_obj_often_update_atk/4
]).

%% callbacks
-export([
	do_send_screen/6,
	do_send_scene/3,
	do_send_scene_info_data/3,
	do_send_buff_effect/4,
	do_send_scene_near_team_info/3,
	do_send_scene_near_player_info/3,
	do_send_scene_teammate_flag/4
]).

-export([
	add_send_screen_12010/7,
	add_send_screen_11020/4,
	make_rep_change_scene/2
]).

%% ====================================================================
%% API functions
%% ====================================================================
%% 全屏广播(包括自己)
send_screen(ScenePid, ObjType, ObjId, Cmd, Data) ->
	gen_server2:apply_sync(ScenePid, {?MODULE, do_send_screen, [ObjType, ObjId, true, Cmd, Data]}).

%% 全屏广播(不包括自己)
send_screen2(ScenePid, ObjType, ObjId, Cmd, Data) ->
	gen_server2:apply_sync(ScenePid, {?MODULE, do_send_screen, [ObjType, ObjId, false, Cmd, Data]}).
%% 全屏广播(不包括自己)
do_send_screen(SceneState, ObjType, ObjId, IncludeSelf, Cmd, Data) ->
	case scene_base_lib:do_get_screen_biont(SceneState, ObjType, ObjId, IncludeSelf) of
		[] ->
			skip;
		ObjList ->
			{ok, Bin} = pt:write_cmd(Cmd, Data),
			Bin1 = pt:pack(Cmd, Bin),
			F = fun(ObjState) ->
				case ObjState#scene_obj_state.obj_type of
					?OBJ_TYPE_PLAYER ->
						%% ?INFO("send player: ~p: ~p", [ObjState#scene_obj_state.obj_id, Data]),
						net_send:send_one(ObjState#scene_obj_state.obj_id, Bin1);
					_ ->
						skip
				end
			end,
			[F(X) || X <- ObjList]
	end.

add_send_screen_12010(SceneState, ObjType, ObjId, TargetList, BuffList, MoveList, KnockBackList) ->
	case scene_base_lib:do_get_screen_biont(SceneState, ObjType, ObjId, true) of
		[] ->
			SceneState;
		ObjList ->
			F = fun(ObjState, TempSceneState) ->
				case ObjState#scene_obj_state.obj_type of
					?OBJ_TYPE_PLAYER ->
						PlayerId = ObjState#scene_obj_state.obj_id,
						%% ?INFO("send player: ~p: ~p", [ObjState#scene_obj_state.obj_id, Data]),
						case lists:keyfind(PlayerId, 1, TempSceneState#scene_state.send_list_12010) of
							false ->
								NewList = [{PlayerId, TargetList, BuffList, MoveList, KnockBackList} | TempSceneState#scene_state.send_list_12010],
								TempSceneState#scene_state{
									send_list_12010 = NewList
								};
							{_, TargetList1, BuffList1, MoveList1, KnockBackList1} ->
								TargetListNew = TargetList1 ++ TargetList,
								BuffListNew = BuffList ++ BuffList1,
								MoveListNew = MoveList ++ MoveList1,
								KnockBackListNew = KnockBackList ++ KnockBackList1,
								?INFO("12010 ~p ~p ~p ~p ~p", [PlayerId, length(TargetListNew), length(BuffListNew), length(MoveListNew), length(KnockBackListNew)]),
								lists:keyreplace(PlayerId, 1, TempSceneState#scene_state.send_list_12010, {PlayerId, TargetListNew, BuffListNew, MoveListNew, KnockBackListNew}),
								TempSceneState
						end;
					_ ->
						TempSceneState
				end
			end,
			lists:foldr(F, SceneState, ObjList)
	end.

add_send_screen_11020(SceneState, ObjType, ObjId, Data) ->
	case scene_base_lib:do_get_screen_biont(SceneState, ObjType, ObjId, true) of
		[] ->
			SceneState;
		ObjList ->
			F = fun(ObjState, TempSceneState) ->
				case ObjState#scene_obj_state.obj_type of
					?OBJ_TYPE_PLAYER ->
						PlayerId = ObjState#scene_obj_state.obj_id,
						%% ?INFO("send player: ~p: ~p", [ObjState#scene_obj_state.obj_id, Data]),
						case lists:keyfind(PlayerId, 1, TempSceneState#scene_state.send_list_11020) of
							false ->
								NewList = [{PlayerId, Data} | TempSceneState#scene_state.send_list_11020],
								TempSceneState#scene_state{
									send_list_11020 = NewList
								};
							{_, List} ->
								NewList = List ++ Data,
								%%?INFO("11020 ~p ~p",[PlayerId,length(NewList)]),
								lists:keyreplace(PlayerId, 1, TempSceneState#scene_state.send_list_11020, {PlayerId, NewList}),
								TempSceneState
						end;
					_ ->
						TempSceneState
				end
			end,
			lists:foldr(F, SceneState, ObjList)
	end.

%% 全场景广播
send_scene(ScenePid, Cmd, Data) ->
	gen_server2:apply_sync(ScenePid, {?MODULE, do_send_scene, [Cmd, Data]}).
%% 全场景广播
do_send_scene(SceneState, Cmd, Data) ->
	case scene_base_lib:do_get_scene_players(SceneState) of
		[] ->
			skip;
		ObjList ->
			{ok, Bin} = pt:write_cmd(Cmd, Data),
			Bin1 = pt:pack(Cmd, Bin),
			F = fun(ObjState) ->
				case ObjState#scene_obj_state.obj_type of
					?OBJ_TYPE_PLAYER ->
						%% ?INFO("send player: ~p: ~p", [ObjState#scene_obj_state.obj_id, Data]),
						net_send:send_one(ObjState#scene_obj_state.obj_id, Bin1);
					_ ->
						skip
				end
			end,
			[F(X) || X <- ObjList]
	end.

%% 宠物发送
send_enter_screen_pet(ObjList, ObjState) ->
	case ObjList /= [] of
		true ->
			%% 发送给别人
			{Data, TempNum} = make_rep_obj_enter([ObjState], {#rep_obj_enter{}, 0}),
			case TempNum > 0 of
				true ->
					{ok, Bin} = pt:write_cmd(11005, Data),
					Bin1 = pt:pack(11005, Bin),
					scene_send_lib:send_screen_player(ObjList, Bin1);
				_ ->
					skip
			end;
		_ ->
			skip
	end.
%% 对象列表 发送
send_enter_screen(ObjList, ObjState) ->
	send_enter_screen(ObjList, ObjState, true, false).
send_enter_screen(ObjList, ObjState, IsSendSelf) ->
	send_enter_screen(ObjList, ObjState, IsSendSelf, false).
send_enter_screen(ObjList, ObjState, IsSendSelf, IsInstant) ->
	case ObjList /= [] of
		true ->
			%% 发送给别人
			{Data, TempNum} = make_rep_obj_enter([ObjState], {#rep_obj_enter{}, 0}),
			case TempNum > 0 of
				true ->
					{ok, Bin} = pt:write_cmd(11005, Data),
					Bin1 = pt:pack(11005, Bin),
					scene_send_lib_copy:send_screen_player(ObjList, Bin1);
				_ ->
					skip
			end;
		_ ->
			skip
	end,
	if
		ObjState#scene_obj_state.obj_type =:= ?OBJ_TYPE_PLAYER andalso IsSendSelf =:= true ->
			%% 发送给自己
			ObjList1 =
				case IsInstant of
					true ->
						[ObjState | ObjList];
					_ ->
						ObjList
				end,
			{Data1, TempNum1} = make_rep_obj_enter(ObjList1, {#rep_obj_enter{}, 0}),
			case TempNum1 > 0 of
				true ->
%% 					case 438086664195=:=ObjState#scene_obj_state.obj_id of
%% 						true->
%% 							?INFO("TTTSSS666 ~p ",[Data1]);
%% 						_->
%% 							skip
%% 					end,
					%%net_send:send_to_client(ObjState#scene_obj_state.obj_id, 11005, Data1);
					scene_send_lib_copy:send_player_id(ObjState#scene_obj_state.obj_id, 11005, Data1);
				_ ->
					skip
			end;
		true ->
			skip
	end.
%% 离屏广播
send_leave_screen(ObjList, ObjState) ->
	send_leave_screen(ObjList, ObjState, true).
%% 离屏广播
send_leave_screen(ObjList, ObjState, IsSendSelf) ->
	case ObjList /= [] of
		true ->
			ObjType = ObjState#scene_obj_state.obj_type,
			ObjId = ObjState#scene_obj_state.obj_id,
			%% 发给别人
			Data = #rep_obj_leave{
				obj_list = [#proto_obj_flag{type = ObjType, id = ObjId}]
			},
			{ok, Bin} = pt:write_cmd(11004, Data),
			Bin1 = pt:pack(11004, Bin),
			scene_send_lib_copy:send_screen_player(ObjList, Bin1),

			case ObjType of
				?OBJ_TYPE_PLAYER ->
					case IsSendSelf of
						true ->
							%% 发给自己
							List = [#proto_obj_flag{type = Obj#scene_obj_state.obj_type, id = Obj#scene_obj_state.obj_id} || Obj <- ObjList],
							Data1 = #rep_obj_leave{
								obj_list = List
							},
							net_send:send_to_client(ObjId, 11004, Data1);
						_ ->
							skip
					end;
				_ ->
					skip
			end;
		_ ->
			skip
	end.
%% 获取玩家所在场景的对象信息
send_scene_info_data(ScenePid, Socket, PlayerId) ->
	gen_server2:apply_async(ScenePid, {?MODULE, do_send_scene_info_data, [Socket, PlayerId]}).
%% 获取玩家所在场景的对象信息
do_send_scene_info_data(SceneState, Socket, PlayerId) ->
	?ERR("SS ~p", [1111]),
	case scene_base_lib:do_get_screen_obj(SceneState, ?OBJ_TYPE_PLAYER, PlayerId, true) of
		[] ->
			net_send:send_to_client(Socket, 11001, #rep_change_scene{scene_id = SceneState#scene_state.scene_id});
		ObjList ->
			Data = make_rep_change_scene(ObjList, #rep_change_scene{scene_id = SceneState#scene_state.scene_id}),
			net_send:send_to_client(Socket, 11001, Data)
	end.
%% 发送移动同步数据
send_move_sync(ObjList, ObjState, IsRevive) ->
	case ObjList /= [] of
		true ->
			case IsRevive of
				true ->
					%% 发送给自己和别人
					{Data, TempNum} = make_rep_obj_enter([ObjState], {#rep_obj_enter{}, 0}),
					case TempNum > 0 of
						true ->
							{ok, Bin} = pt:write_cmd(11005, Data),
							Bin1 = pt:pack(11005, Bin),
							case ObjState#scene_obj_state.obj_type of
								?OBJ_TYPE_PLAYER ->
									?ERR("11005 ~p", [Data]);
								_ ->
									skip
							end,
							scene_send_lib_copy:send_screen_player(ObjList, Bin1);
						_ ->
							skip
					end;
				_ ->
%% 					#scene_obj_state{
%% 						obj_type = ObjType,
%% 						obj_id = ObjId,
%% 						x = X,
%% 						y = Y,
%% 						ex = EX,
%% 						ey = EY,
%% 						direction = Direction
%% 					} = ObjState,
%%
%% 					%% 发送给客户端
%% 					Data = #rep_move_sync{
%% 						obj_flag = #proto_obj_flag{type = ObjType, id = ObjId},
%% 						point = #proto_point{x = X, y = Y},
%% 						end_point = #proto_point{x = EX, y = EY},
%% 						direction = Direction
%% 					},
%% 					{ok, Bin} = pt:write_cmd(11003, Data),
%% 					Bin1 = pt:pack(11003, Bin),
%% 					scene_send_lib_copy:send_screen_player(ObjList, Bin1)
					skip
			end;
		_ ->
			skip
	end.
%% 发送玩家修改
send_screen_player_update(SceneState, OldObjState, NewObjState, Cause) ->
	List = [?UPDATE_KEY_GUISE_WEAPON, ?UPDATE_KEY_GUISE_CLOTHES, ?UPDATE_KEY_GUISE_WING, ?UPDATE_KEY_GUISE_PET, ?UPDATE_KEY_GUISE_MOUNTS, ?UPDATE_KEY_GUISE_MOUNTS_AURA],
	#scene_obj_state{
		obj_type = ObjType,
		obj_id = ObjId
	} = NewObjState,
	case need_update_screen(List, OldObjState, NewObjState) of
		true ->
			%% 发送给别人
			{Data, TempNum} = make_rep_obj_enter([NewObjState], {#rep_obj_enter{}, 0}),
			case TempNum > 0 of
				true ->
					scene_send_lib_copy:do_send_screen(SceneState, ObjType, ObjId, true, 11005, Data);
				_ ->
					skip
			end;
		_ ->
			skip
	end,

	OldPetNum = dict:size(OldObjState#scene_obj_state.pet_dict),
	NewPetNum = dict:size(NewObjState#scene_obj_state.pet_dict),
	case OldObjState#scene_obj_state.guild_id /= NewObjState#scene_obj_state.guild_id orelse
		OldObjState#scene_obj_state.name_colour /= NewObjState#scene_obj_state.name_colour orelse
		OldObjState#scene_obj_state.career_title /= NewObjState#scene_obj_state.career_title orelse
		OldObjState#scene_obj_state.team_id /= NewObjState#scene_obj_state.team_id orelse
		OldObjState#scene_obj_state.legion_id /= NewObjState#scene_obj_state.legion_id orelse
		OldObjState#scene_obj_state.collect_state /= NewObjState#scene_obj_state.collect_state orelse
		OldPetNum /= NewPetNum of
		true ->
			Data1 = make_rep_obj_update([NewObjState], #rep_obj_update{}),
			do_send_screen(SceneState, ObjType, ObjId, true, 11011, Data1);
		_ ->
			skip
	end,

	OldAttr = NewObjState#scene_obj_state.attr_total,
	NewAttr = NewObjState#scene_obj_state.attr_total,
	case OldObjState#scene_obj_state.cur_hp /= NewObjState#scene_obj_state.cur_hp orelse
		OldObjState#scene_obj_state.cur_mp /= NewObjState#scene_obj_state.cur_mp orelse
		OldAttr#attr_base.hp /= NewAttr#attr_base.hp orelse
		OldAttr#attr_base.mp /= NewAttr#attr_base.mp of
		true ->
			HpChange = NewObjState#scene_obj_state.cur_hp - OldObjState#scene_obj_state.cur_hp,
			MpChange = NewObjState#scene_obj_state.cur_mp - OldObjState#scene_obj_state.cur_mp,
			Data2 = make_rep_obj_often_update([{NewObjState, Cause, 0, HpChange, MpChange}], #rep_obj_often_update{}),
%%  			?ERR("dATA~p", [Data2]),
			do_send_screen(SceneState, ObjType, ObjId, true, 11020, Data2);
		_ ->
			skip
	end.
%% 发送宠物修改
send_screen_pet_update(SceneState, OldObjState, NewObjState) ->
	if
		OldObjState#scene_obj_state.lv /= NewObjState#scene_obj_state.lv ->
			{Data, TempNum} = make_rep_obj_enter([NewObjState], {#rep_obj_enter{}, 0}),
			case TempNum > 0 of
				true ->
					#scene_obj_state{
						obj_type = ObjType,
						obj_id = ObjId
					} = NewObjState,
					scene_send_lib_copy:do_send_screen(SceneState, ObjType, ObjId, false, 11005, Data);
				_ ->
					skip
			end;
		OldObjState#scene_obj_state.guild_id /= NewObjState#scene_obj_state.guild_id orelse
			OldObjState#scene_obj_state.legion_id /= NewObjState#scene_obj_state.legion_id orelse
			OldObjState#scene_obj_state.name_colour /= NewObjState#scene_obj_state.name_colour orelse
			OldObjState#scene_obj_state.career_title /= NewObjState#scene_obj_state.career_title ->
			#scene_obj_state{
				obj_type = ObjType,
				obj_id = ObjId
			} = NewObjState,
			Data = make_rep_pet_update([NewObjState], #rep_pet_update{}),
			do_send_screen(SceneState, ObjType, ObjId, true, 11027, Data);
		true ->
			skip
	end.

send_buff_effect(ScenePid, ObjType, ObjId, BuffResultList) ->
	gen_server2:apply_async(ScenePid, {?MODULE, do_send_buff_effect, [ObjType, ObjId, BuffResultList]}).

do_send_buff_effect(SceneState, ObjType, ObjId, BuffResultList) ->
	F = fun(Result) ->
		if
			is_record(Result, proto_harm) ->
				HpMpUpdateList = make_hp_mp_update_list(SceneState, #skill_effect{harm_list = [Result], cure_list = []}),
				Data = scene_send_lib:make_rep_obj_often_update(HpMpUpdateList, #rep_obj_often_update{}),
%% 				?ERR("DATA skill ~p", [Data]),
				scene_send_lib:do_send_screen(SceneState, ObjType, ObjId, true, 11020, Data);
			is_record(Result, proto_cure) ->
				HpMpUpdateList = make_hp_mp_update_list(SceneState, #skill_effect{harm_list = [], cure_list = [Result]}),
				Data = scene_send_lib:make_rep_obj_often_update(HpMpUpdateList, #rep_obj_often_update{}),
%%  			?ERR("DATA skill ~p", [Data]),
				scene_send_lib:do_send_screen(SceneState, ObjType, ObjId, true, 11020, Data);
			true ->
				skip
		end
	end,
	lists:foreach(F, BuffResultList).

send_scene_near_team_info(ScenePid, PlayerId, PlayerSocket) when is_pid(ScenePid) ->
	gen_server2:apply_async(ScenePid, {?MODULE, do_send_scene_near_team_info, [PlayerId, PlayerSocket]}).

do_send_scene_near_team_info(SceneState, PlayerId, PlayerSocket) ->
	PlayerList = scene_base_lib:do_get_screen_biont(SceneState, ?OBJ_TYPE_PLAYER, PlayerId, false),
	%% 队伍过滤
	TeamList = filter_team(PlayerList),
	Proto = team_lib:pack_near_by_team_info(TeamList),
	net_send:send_to_client(PlayerSocket, 21011, #rep_near_by_team{info_list = Proto}),
	{ok, SceneState}.

send_scene_near_player_info(ScenePid, PlayerId, PlayerSocket) when is_pid(ScenePid) ->
	gen_server2:apply_async(ScenePid, {?MODULE, do_send_scene_near_player_info, [PlayerId, PlayerSocket]}).

do_send_scene_near_player_info(SceneState, PlayerId, PlayerSocket) ->
	PlayerList = scene_base_lib:do_get_screen_biont(SceneState, ?OBJ_TYPE_PLAYER, PlayerId, false),
	PlayerList1 = [X || X <- PlayerList, X#scene_obj_state.obj_type == ?OBJ_TYPE_PLAYER],
	Proto = team_lib:pack_near_by_player_info(PlayerList1),
	net_send:send_to_client(PlayerSocket, 21010, #rep_near_by_player{info_list = Proto}),
	{ok, SceneState}.

filter_team(PlayerList) ->
	Fun = fun(SceneObj, Acc) ->
		case SceneObj#scene_obj_state.leader == 1 of
			true ->
				TeamId = SceneObj#scene_obj_state.team_id,
				[TeamId] ++ Acc;
			false ->
				Acc
		end
	end,
	lists:foldl(Fun, [], PlayerList).

send_scene_teammate_flag(ScenePid, PlayerId, TeamId, PlayerSocket) ->
	gen_server2:apply_async(ScenePid, {?MODULE, do_send_scene_teammate_flag, [PlayerId, TeamId, PlayerSocket]}).

do_send_scene_teammate_flag(SceneState, PlayerId, TeamId, PlayerSocket) ->
	PlayerList = scene_base_lib:do_get_scene_players(SceneState),
	%% 队员信息
	Fun = fun(Obj, Acc) ->
		case Obj#scene_obj_state.team_id =/= 0 andalso
			Obj#scene_obj_state.team_id == TeamId andalso
			Obj#scene_obj_state.obj_id =/= PlayerId of
			true ->
				[#proto_map_teammate_flag{
					point = #proto_point{
						x = Obj#scene_obj_state.x,
						y = Obj#scene_obj_state.y
					}
				}] ++ Acc;
			false ->
				Acc
		end
	end,
	Proto = lists:foldl(Fun, [], PlayerList),
	net_send:send_to_client(PlayerSocket, 11019, #rep_scene_map_flag{flag_list = Proto}),
	{ok, SceneState}.

send_monster_update(SceneState, ObjState) ->
	#scene_obj_state{
		obj_type = ObjType,
		obj_id = ObjId,
		cur_target = CurTarget,
		drop_owner = DropOwner
	} = ObjState,
	ProtoEnmity = make_proto_enmity(CurTarget),
	ProtoDropOwner = make_proto_drop_owner(DropOwner),

	Data = #rep_update_enmity{
		obj_flag = #proto_obj_flag{type = ObjType, id = ObjId},
		enmity = ProtoEnmity,
		drop_owner = ProtoDropOwner
	},
	do_send_screen(SceneState, ObjType, ObjId, false, 11023, Data).

%% ====================================================================
%% Internal functions 发送给场景中的玩家
%% ====================================================================
send_screen_player(ObjList, Bin) ->
	[begin
		 case Obj#scene_obj_state.obj_type of
			 ?OBJ_TYPE_PLAYER ->
				 net_send:send_one(Obj#scene_obj_state.obj_id, Bin);
			 _ ->
				 skip
		 end
	 end || Obj <- ObjList].

%% 组合场景元素信息
make_rep_obj_enter([], {Data, Num}) ->
	{Data, Num};
make_rep_obj_enter([ObjState | T], {Data, Num}) ->
	ObjInfo = make_obj_info(ObjState#scene_obj_state.obj_type, ObjState),
	{NewData, NewNum} =
		case ObjState#scene_obj_state.obj_type of
			?OBJ_TYPE_PLAYER -> %%玩家
				List = Data#rep_obj_enter.player_list,
				{Data#rep_obj_enter{player_list = [ObjInfo | List]}, Num + 1};
			?OBJ_TYPE_IMAGE -> %% 玩家镜像
				List = Data#rep_obj_enter.player_list,
				{Data#rep_obj_enter{player_list = [ObjInfo | List]}, Num + 1};
			?OBJ_TYPE_MONSTER -> %%怪物
				List = Data#rep_obj_enter.monster_list,
				{Data#rep_obj_enter{monster_list = [ObjInfo | List]}, Num + 1};
			?OBJ_TYPE_DROP -> %%掉落物品
				List = Data#rep_obj_enter.drop_list,
				{Data#rep_obj_enter{drop_list = [ObjInfo | List]}, Num + 1};
			?OBJ_TYPE_PET -> %%宠物
				List = Data#rep_obj_enter.monster_list,
				{Data#rep_obj_enter{monster_list = [ObjInfo | List]}, Num + 1};
			?OBJ_TYPE_FIRE_WALL -> %%火墙
				List = Data#rep_obj_enter.fire_wall_list,
				{Data#rep_obj_enter{fire_wall_list = [ObjInfo | List]}, Num + 1};
			?OBJ_TYPE_COLLECT -> %% 采集怪物
				List = Data#rep_obj_enter.monster_list,
				{Data#rep_obj_enter{monster_list = [ObjInfo | List]}, Num + 1};
			_ ->
				{Data, Num}
		end,
	make_rep_obj_enter(T, {NewData, NewNum}).

%% 场景玩家角色信息
make_obj_info(?OBJ_TYPE_PLAYER, ObjState) ->
	AttrTotal = ObjState#scene_obj_state.attr_total,
	Guise = ObjState#scene_obj_state.guise,
	BuffList = make_buff_list(ObjState#scene_obj_state.buff_dict),
	ProtoGuise = player_lib:make_proto_guise(Guise),
	#proto_scene_player{
		obj_flag = #proto_obj_flag{type = ?OBJ_TYPE_PLAYER, id = ObjState#scene_obj_state.obj_id}, %% 对象类型，和 对象唯一标示
		name = ObjState#scene_obj_state.name,
		sex = ObjState#scene_obj_state.sex,
		career = ObjState#scene_obj_state.career,
		lv = ObjState#scene_obj_state.lv,
		direction = ObjState#scene_obj_state.direction,
		cur_hp = ObjState#scene_obj_state.cur_hp,
		cur_mp = ObjState#scene_obj_state.cur_mp,
		hp = AttrTotal#attr_base.hp,
		mp = AttrTotal#attr_base.mp,
		begin_point = #proto_point{x = ObjState#scene_obj_state.x, y = ObjState#scene_obj_state.y},
		end_point = #proto_point{x = ObjState#scene_obj_state.ex, y = ObjState#scene_obj_state.ey},
		guise = ProtoGuise,
		buff_list = BuffList,
		guild_id = ObjState#scene_obj_state.guild_id,
		legion_id = ObjState#scene_obj_state.legion_id,
		guild_name = guild_lib:get_guild_name(ObjState#scene_obj_state.guild_id),
		name_colour = ObjState#scene_obj_state.name_colour,
		%% 职业第一称号信息
		career_title = careertitle_lib:get_career_title_player_id(ObjState#scene_obj_state.obj_id, ObjState#scene_obj_state.career),
		pet_num = dict:size(ObjState#scene_obj_state.pet_dict),
		team_id = ObjState#scene_obj_state.team_id,
		server_name = ObjState#scene_obj_state.server_name,
		collect_state = ObjState#scene_obj_state.collect_state
	};
make_obj_info(?OBJ_TYPE_IMAGE, ObjState) ->
	AttrTotal = ObjState#scene_obj_state.attr_total,
	Guise = ObjState#scene_obj_state.guise,
	BuffList = make_buff_list(ObjState#scene_obj_state.buff_dict),
	ProtoGuise = player_lib:make_proto_guise(Guise),
	#proto_scene_player{
		obj_flag = #proto_obj_flag{type = ?OBJ_TYPE_IMAGE, id = ObjState#scene_obj_state.obj_id}, %% 对象类型，和 对象唯一标示
		name = ObjState#scene_obj_state.name,
		sex = ObjState#scene_obj_state.sex,
		career = ObjState#scene_obj_state.career,
		lv = ObjState#scene_obj_state.lv,
		direction = ObjState#scene_obj_state.direction,
		cur_hp = ObjState#scene_obj_state.cur_hp,
		cur_mp = ObjState#scene_obj_state.cur_mp,
		hp = AttrTotal#attr_base.hp,
		mp = AttrTotal#attr_base.mp,
		begin_point = #proto_point{x = ObjState#scene_obj_state.x, y = ObjState#scene_obj_state.y},
		end_point = #proto_point{x = ObjState#scene_obj_state.ex, y = ObjState#scene_obj_state.ey},
		guise = ProtoGuise,
		buff_list = BuffList,
		guild_id = ObjState#scene_obj_state.guild_id,
		legion_id = ObjState#scene_obj_state.legion_id,
		guild_name = guild_lib:get_guild_name(ObjState#scene_obj_state.guild_id),
		name_colour = ObjState#scene_obj_state.name_colour,
		%% 职业第一称号信息
		career_title = careertitle_lib:get_career_title_player_id(ObjState#scene_obj_state.obj_id, ObjState#scene_obj_state.career),
		server_name = ObjState#scene_obj_state.server_name
	};
make_obj_info(?OBJ_TYPE_MONSTER, ObjState) ->
	AttrTotal = ObjState#scene_obj_state.attr_total,
	BuffList = make_buff_list(ObjState#scene_obj_state.buff_dict),
	Enmity = make_proto_enmity(ObjState#scene_obj_state.cur_target),
	DropOwner = make_proto_drop_owner(ObjState#scene_obj_state.drop_owner),
	#proto_scene_monster{
		obj_flag = #proto_obj_flag{type = ?OBJ_TYPE_MONSTER, id = ObjState#scene_obj_state.obj_id},
		monster_id = ObjState#scene_obj_state.monster_id,
		name = ObjState#scene_obj_state.name,
		direction = ObjState#scene_obj_state.direction,
		cur_hp = ObjState#scene_obj_state.cur_hp,
		cur_mp = ObjState#scene_obj_state.cur_mp,
		hp = AttrTotal#attr_base.hp,
		mp = AttrTotal#attr_base.mp,
		begin_point = #proto_point{x = ObjState#scene_obj_state.x, y = ObjState#scene_obj_state.y},
		end_point = #proto_point{x = ObjState#scene_obj_state.ex, y = ObjState#scene_obj_state.ey},
		buff_list = BuffList,
		enmity = Enmity,
		drop_owner = DropOwner
	};
make_obj_info(?OBJ_TYPE_DROP, ObjState) ->
	TimeOut = max(ObjState#scene_obj_state.owner_change_time - util_date:unixtime(), 0),
	{OwnerId, TeamId} =
		case TimeOut > 0 of
			true ->
				{ObjState#scene_obj_state.owner_id, ObjState#scene_obj_state.team_id};
			_ ->
				{0, 0}
		end,
	#proto_scene_drop{
		obj_flag = #proto_obj_flag{type = ?OBJ_TYPE_DROP, id = ObjState#scene_obj_state.obj_id},
		goods_id = ObjState#scene_obj_state.goods_id,
		point = #proto_point{x = ObjState#scene_obj_state.x, y = ObjState#scene_obj_state.y},
		num = ObjState#scene_obj_state.drop_num,
		player_id = OwnerId,
		time_out = TimeOut,
		team_id = TeamId
	};
make_obj_info(?OBJ_TYPE_PET, ObjState) ->
	AttrTotal = ObjState#scene_obj_state.attr_total,
	BuffList = make_buff_list(ObjState#scene_obj_state.buff_dict),
	#proto_scene_monster{
		obj_flag = #proto_obj_flag{type = ?OBJ_TYPE_PET, id = ObjState#scene_obj_state.obj_id},
		owner_flag = #proto_obj_flag{type = ?OBJ_TYPE_PLAYER, id = ObjState#scene_obj_state.owner_id},
		monster_id = ObjState#scene_obj_state.monster_id,
		name = ObjState#scene_obj_state.name,
		direction = ObjState#scene_obj_state.direction,
		cur_hp = ObjState#scene_obj_state.cur_hp,
		cur_mp = ObjState#scene_obj_state.cur_mp,
		hp = AttrTotal#attr_base.hp,
		mp = AttrTotal#attr_base.mp,
		begin_point = #proto_point{x = ObjState#scene_obj_state.x, y = ObjState#scene_obj_state.y},
		end_point = #proto_point{x = ObjState#scene_obj_state.ex, y = ObjState#scene_obj_state.ey},
		buff_list = BuffList,
		guild_id = ObjState#scene_obj_state.guild_id,
		legion_id = ObjState#scene_obj_state.legion_id,
		team_id = ObjState#scene_obj_state.team_id,
		name_colour = ObjState#scene_obj_state.name_colour,
		server_name = ObjState#scene_obj_state.server_name
	};
make_obj_info(?OBJ_TYPE_COLLECT, ObjState) ->
	AttrTotal = ObjState#scene_obj_state.attr_total,
	BuffList = make_buff_list(ObjState#scene_obj_state.buff_dict),
	Enmity = make_proto_enmity(ObjState#scene_obj_state.cur_target),
	DropOwner = make_proto_drop_owner(ObjState#scene_obj_state.drop_owner),
	#proto_scene_monster{
		obj_flag = #proto_obj_flag{type = ?OBJ_TYPE_COLLECT, id = ObjState#scene_obj_state.obj_id},
		monster_id = ObjState#scene_obj_state.monster_id,
		name = ObjState#scene_obj_state.name,
		direction = ObjState#scene_obj_state.direction,
		cur_hp = ObjState#scene_obj_state.cur_hp,
		cur_mp = ObjState#scene_obj_state.cur_mp,
		hp = AttrTotal#attr_base.hp,
		mp = AttrTotal#attr_base.mp,
		begin_point = #proto_point{x = ObjState#scene_obj_state.x, y = ObjState#scene_obj_state.y},
		end_point = #proto_point{x = ObjState#scene_obj_state.ex, y = ObjState#scene_obj_state.ey},
		buff_list = BuffList,
		enmity = Enmity,
		drop_owner = DropOwner
	};
make_obj_info(?OBJ_TYPE_FIRE_WALL, ObjState) ->
	#proto_fire_wall{
		obj_flag = #proto_obj_flag{type = ?OBJ_TYPE_DROP, id = ObjState#scene_obj_state.obj_id},
		point = #proto_point{x = ObjState#scene_obj_state.x, y = ObjState#scene_obj_state.y}
	}.

make_buff_list(BuffDict) ->
	CurTime = util_date:unixtime(),
	F = fun(BuffId, Buff, Acc) ->
		BuffConf = buff_config:get(BuffId),
		ProtoBuff = #proto_buff{
			buff_id = BuffId,
			countdown = Buff#db_buff.remove_time - CurTime,
			effect_id = BuffConf#buff_conf.effect_id
		},
		[ProtoBuff | Acc]
	end,
	dict:fold(F, [], BuffDict).

make_rep_change_scene([], Data) ->
	Data;
make_rep_change_scene([ObjState | T], Data) ->
	ObjInfo = make_obj_info(ObjState#scene_obj_state.obj_type, ObjState),
	NewData =
		case ObjState#scene_obj_state.obj_type of
			?OBJ_TYPE_PLAYER ->
				List = Data#rep_change_scene.player_list,
				Data#rep_change_scene{player_list = [ObjInfo | List]};
			?OBJ_TYPE_IMAGE -> %% 玩家镜像
				List = Data#rep_change_scene.player_list,
				Data#rep_change_scene{player_list = [ObjInfo | List]};
			?OBJ_TYPE_MONSTER ->
				List = Data#rep_change_scene.monster_list,
				Data#rep_change_scene{monster_list = [ObjInfo | List]};
			?OBJ_TYPE_DROP ->
				List = Data#rep_change_scene.drop_list,
				Data#rep_change_scene{drop_list = [ObjInfo | List]};
			?OBJ_TYPE_PET ->
				List = Data#rep_change_scene.monster_list,
				Data#rep_change_scene{monster_list = [ObjInfo | List]};
			?OBJ_TYPE_FIRE_WALL ->
				List = Data#rep_change_scene.fire_wall_list,
				Data#rep_change_scene{fire_wall_list = [ObjInfo | List]};
			?OBJ_TYPE_COLLECT ->
				List = Data#rep_change_scene.monster_list,
				Data#rep_change_scene{monster_list = [ObjInfo | List]};
			_ ->
				Data
		end,
	make_rep_change_scene(T, NewData).

make_rep_obj_update([], Data) ->
	Data;
make_rep_obj_update([ObjState | T], Data) ->
	ObjInfo = #proto_scene_player_update{
		obj_flag = #proto_obj_flag{type = ObjState#scene_obj_state.obj_type, id = ObjState#scene_obj_state.obj_id},
		guild_id = ObjState#scene_obj_state.guild_id,
		legion_id = ObjState#scene_obj_state.legion_id,
		guild_name = guild_lib:get_guild_name(ObjState#scene_obj_state.guild_id),
		name_colour = ObjState#scene_obj_state.name_colour,
		%% 职业第一称号信息
		career_title = careertitle_lib:get_career_title_player_id(ObjState#scene_obj_state.obj_id, ObjState#scene_obj_state.career),
		pet_num = dict:size(ObjState#scene_obj_state.pet_dict),
		team_id = ObjState#scene_obj_state.team_id,
		collect_state = ObjState#scene_obj_state.collect_state
	},
	List = Data#rep_obj_update.player_list,
	NewData = Data#rep_obj_update{player_list = [ObjInfo | List]},
	make_rep_obj_update(T, NewData).

need_update_screen([], _OldState, _NewState) ->
	false;
need_update_screen([K | T], OldState, NewState) ->
	V1 = get_update_key_value(K, OldState),
	V2 = get_update_key_value(K, NewState),
	case V1 /= V2 of
		true ->
			true;
		_ ->
			need_update_screen(T, OldState, NewState)
	end.

make_hp_mp_update_list(SceneState, SkillEffect) ->
	#skill_effect{
		harm_list = HarmList,
		cure_list = CureList
	} = SkillEffect,
	make_hp_mp_update_list1(HarmList ++ CureList, SceneState, []).

make_hp_mp_update_list1([], _SceneState, List) ->
	List;
make_hp_mp_update_list1([#proto_harm{} = ProtoHarm | T], SceneState, List) ->
	#proto_harm{
		obj_flag = #proto_obj_flag{type = ObjType, id = ObjId},
		harm_status = HarmStatus,
		harm_value = HarmValue
	} = ProtoHarm,
	case scene_base_lib:get_scene_obj_state(SceneState, ObjType, ObjId) of
		#scene_obj_state{} = NewState ->
			case HarmStatus of
				?HARM_STATUS_MP ->
					make_hp_mp_update_list1(T, SceneState, [{NewState, ?UPDATE_CAUSE_SKILL, HarmStatus, 0, -HarmValue} | List]);
				_ ->
					make_hp_mp_update_list1(T, SceneState, [{NewState, ?UPDATE_CAUSE_SKILL, HarmStatus, -HarmValue, 0} | List])
			end;
		_ ->
			make_hp_mp_update_list1(T, SceneState, List)
	end;
make_hp_mp_update_list1([#proto_cure{} = ProtoCure | T], SceneState, List) ->
	#proto_cure{
		obj_flag = #proto_obj_flag{type = ObjType, id = ObjId},
		add_hp = AddHp
	} = ProtoCure,
	case scene_base_lib:get_scene_obj_state(SceneState, ObjType, ObjId) of
		#scene_obj_state{} = NewState ->
			make_hp_mp_update_list1(T, SceneState, [{NewState, ?UPDATE_CAUSE_SKILL, ?HARM_STATUS_NORMAL, AddHp, 0} | List]);
		_ ->
			make_hp_mp_update_list1(T, SceneState, List)
	end.

make_rep_obj_often_update([], Data) ->
	Data;
make_rep_obj_often_update([{NewState, Cause, HarmStatus, HpChange, MpChange} | T], Data) ->
	#scene_obj_state{
		obj_type = ObjType,
		obj_id = ObjId,
		cur_hp = CurHp1,
		cur_mp = CurMp1,
		attr_total = Attr
	} = NewState,

	ObjInfo = #proto_scene_obj_often_update{
		obj_flag = #proto_obj_flag{type = ObjType, id = ObjId},
		cause = Cause,
		harm_status = HarmStatus,
		hp_change = HpChange,
		mp_change = MpChange,
		cur_hp = CurHp1,
		cur_mp = CurMp1,
		hp = Attr#attr_base.hp,
		mp = Attr#attr_base.mp
	},
	List = Data#rep_obj_often_update.obj_list,
	NewData = Data#rep_obj_often_update{obj_list = [ObjInfo | List]},
	make_rep_obj_often_update(T, NewData).

make_rep_obj_often_update_atk(_AtkObjId, _AtkObjType, [], Data) ->
	Data;
make_rep_obj_often_update_atk(AtkObjId, AtkObjType, [{NewState, Cause, HarmStatus, HpChange, MpChange} | T], Data) ->
	#scene_obj_state{
		obj_type = ObjType,
		obj_id = ObjId,
		cur_hp = CurHp1,
		cur_mp = CurMp1,
		attr_total = Attr
	} = NewState,

	ObjInfo = #proto_scene_obj_often_update{
		obj_flag = #proto_obj_flag{type = ObjType, id = ObjId},
		obj_atk = #proto_obj_flag{type = AtkObjType, id = AtkObjId},
		cause = Cause,
		harm_status = HarmStatus,
		hp_change = HpChange,
		mp_change = MpChange,
		cur_hp = CurHp1,
		cur_mp = CurMp1,
		hp = Attr#attr_base.hp,
		mp = Attr#attr_base.mp
	},
	List = Data#rep_obj_often_update.obj_list,
	NewData = Data#rep_obj_often_update{obj_list = [ObjInfo | List]},
	make_rep_obj_often_update_atk(AtkObjId, AtkObjType, T, NewData).

make_proto_enmity(Target) ->
	case util_data:is_null(Target) of
		true ->
			#proto_enmity{};
		_ ->
			#cur_target_info{
				obj_type = ObjType,
				obj_id = ObjId,
				name = Name,
				career = Career,
				sex = Sex,
				monster_id = MonsterId
			} = Target,

			#proto_enmity{
				obj_flag = #proto_obj_flag{type = ObjType, id = ObjId},
				name = Name,
				career = Career,
				sex = Sex,
				monster_id = MonsterId
			}
	end.

make_proto_drop_owner(DropOwner) ->
	case util_data:is_null(DropOwner) of
		true ->
			#proto_drop_owner{};
		_ ->
			#cur_drop_owner_info{
				player_id = ObjId,
				name = Name
			} = DropOwner,

			#proto_drop_owner{
				obj_flag = #proto_obj_flag{type = ?OBJ_TYPE_PLAYER, id = ObjId},
				name = Name
			}
	end.

make_rep_pet_update([], Data) ->
	Data;
make_rep_pet_update([ObjState | T], Data) ->
	ObjInfo = #proto_scene_pet_update{
		obj_flag = #proto_obj_flag{type = ObjState#scene_obj_state.obj_type, id = ObjState#scene_obj_state.obj_id},
		guild_id = ObjState#scene_obj_state.guild_id,
		legion_id = ObjState#scene_obj_state.legion_id,
		name_colour = ObjState#scene_obj_state.name_colour
	},
	List = Data#rep_pet_update.pet_list,
	NewData = Data#rep_pet_update{pet_list = [ObjInfo | List]},
	make_rep_obj_update(T, NewData).

get_update_key_value(UpdateKey, SceneObjState) ->
	IndexList = get_key_map(UpdateKey),
	get_update_key_value1(IndexList, SceneObjState).

get_update_key_value1([], V) ->
	V;
get_update_key_value1([K | T], V) ->
	V1 = element(K, V),
	get_update_key_value1(T, V1).

get_key_map(?UPDATE_KEY_LV) -> [#scene_obj_state.lv];
get_key_map(?UPDATE_KEY_CUR_HP) -> [#scene_obj_state.cur_hp];
get_key_map(?UPDATE_KEY_CUR_MP) -> [#scene_obj_state.cur_mp];
get_key_map(?UPDATE_KEY_HP) -> [#scene_obj_state.attr_total, #attr_base.hp];
get_key_map(?UPDATE_KEY_MP) -> [#scene_obj_state.attr_total, #attr_base.mp];
get_key_map(?UPDATE_KEY_MIN_AC) -> [#scene_obj_state.attr_total, #attr_base.min_ac];
get_key_map(?UPDATE_KEY_MAX_AC) -> [#scene_obj_state.attr_total, #attr_base.max_ac];
get_key_map(?UPDATE_KEY_MIN_MAC) -> [#scene_obj_state.attr_total, #attr_base.min_mac];
get_key_map(?UPDATE_KEY_MAX_MAC) -> [#scene_obj_state.attr_total, #attr_base.max_mac];
get_key_map(?UPDATE_KEY_MIN_SC) -> [#scene_obj_state.attr_total, #attr_base.min_sc];
get_key_map(?UPDATE_KEY_MAX_SC) -> [#scene_obj_state.attr_total, #attr_base.max_sc];
get_key_map(?UPDATE_KEY_MIN_DEF) -> [#scene_obj_state.attr_total, #attr_base.min_def];
get_key_map(?UPDATE_KEY_MAX_DEF) -> [#scene_obj_state.attr_total, #attr_base.max_def];
get_key_map(?UPDATE_KEY_MIN_RES) -> [#scene_obj_state.attr_total, #attr_base.min_res];
get_key_map(?UPDATE_KEY_MAX_RES) -> [#scene_obj_state.attr_total, #attr_base.max_res];
get_key_map(?UPDATE_KEY_CRIT) -> [#scene_obj_state.attr_total, #attr_base.crit];
get_key_map(?UPDATE_KEY_CRIT_ATT) -> [#scene_obj_state.attr_total, #attr_base.crit_att];
get_key_map(?UPDATE_KEY_HIT) -> [#scene_obj_state.attr_total, #attr_base.hit];
get_key_map(?UPDATE_KEY_DODGE) -> [#scene_obj_state.attr_total, #attr_base.dodge];
get_key_map(?UPDATE_KEY_DAMAGE_DEEPEN) -> [#scene_obj_state.attr_total, #attr_base.damage_deepen];
get_key_map(?UPDATE_KEY_DAMAGE_REDUCTION) -> [#scene_obj_state.attr_total, #attr_base.damage_reduction];
get_key_map(?UPDATE_KEY_HOLY) -> [#scene_obj_state.attr_total, #attr_base.holy];
get_key_map(?UPDATE_KEY_SKILL_ADD) -> [#scene_obj_state.attr_total, #attr_base.skill_add];
get_key_map(?UPDATE_KEY_M_HIT) -> [#scene_obj_state.attr_total, #attr_base.m_hit];
get_key_map(?UPDATE_KEY_M_DODGE) -> [#scene_obj_state.attr_total, #attr_base.m_dodge];
get_key_map(?UPDATE_KEY_HP_RECOVER) -> [#scene_obj_state.attr_total, #attr_base.hp_recover];
get_key_map(?UPDATE_KEY_MP_RECOVER) -> [#scene_obj_state.attr_total, #attr_base.mp_recover];
get_key_map(?UPDATE_KEY_RESURGENCE) -> [#scene_obj_state.attr_total, #attr_base.resurgence];
get_key_map(?UPDATE_KEY_DAMAGE_OFFSET) -> [#scene_obj_state.attr_total, #attr_base.damage_offset];
get_key_map(?UPDATE_KEY_GUISE_WEAPON) -> [#scene_obj_state.guise, #guise_state.weapon];
get_key_map(?UPDATE_KEY_GUISE_CLOTHES) -> [#scene_obj_state.guise, #guise_state.clothes];
get_key_map(?UPDATE_KEY_GUISE_WING) -> [#scene_obj_state.guise, #guise_state.wing];
get_key_map(?UPDATE_KEY_GUISE_PET) -> [#scene_obj_state.guise, #guise_state.pet];
get_key_map(?UPDATE_KEY_GUISE_MOUNTS) -> [#scene_obj_state.guise, #guise_state.mounts];
get_key_map(?UPDATE_KEY_GUISE_MOUNTS_AURA) -> [#scene_obj_state.guise, #guise_state.mounts_aura];
get_key_map(?UPDATE_KEY_COLLECT_STATE) -> [#scene_obj_state.collect_state].