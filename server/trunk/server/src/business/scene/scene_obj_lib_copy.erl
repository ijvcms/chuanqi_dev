%%%-------------------------------------------------------------------
%%% @author yubing
%%% @copyright (C) 2016, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 20. 四月 2016 11:31
%%%-------------------------------------------------------------------
-module(scene_obj_lib_copy).


-include("common.hrl").
-include("record.hrl").
-include("config.hrl").
-include("cache.hrl").
-include("proto.hrl").
-include("language_config.hrl").

%% API
-export([enter/5, do_enter/5, make_drop_all/7]).

%% ====================================================================
%% API functions 进入场景
%% ====================================================================
%% 对象进入场景（非场景进程调用，可能是玩家进程，也可能是场景管理进程等
enter(ObjState, ObjPid, ScenePid, ChangeType, Point) ->
	gen_server2:apply_async(ScenePid, {?MODULE, do_enter, [ObjState, ObjPid, ChangeType, Point]}).

%% 对象进入场景，玩家进入（场景进程调用）
do_enter(SceneState, PlayerState, PlayerPid, ChangeType, Point) when is_record(PlayerState, player_state) ->

	%% 校验玩家进入坐标点，如果进入的坐标点为不可走点，强制修改为出生点（出生点策划控制一定要是可走点）
	%% 获取场景对象信息 查看玩家是否在场景中
	ObjState =
		case scene_base_lib:get_scene_obj_state(SceneState, ?OBJ_TYPE_PLAYER, PlayerState#player_state.player_id) of
			#scene_obj_state{} = Obj ->
				%% 对玩家进入坐标点进行校验
				{X1, Y1} = scene_obj_lib:check_point(SceneState, PlayerState, ChangeType, Point),
				Obj#scene_obj_state{x = X1, y = Y1, obj_pid = PlayerPid};
			_ ->
				%% 对玩家进入坐标点进行校验
				{X, Y} = scene_obj_lib:check_point(SceneState, PlayerState, ChangeType, Point),%% 获取坐标
				AreaId = area_lib:get_area_id({X, Y}, SceneState#scene_state.width, SceneState#scene_state.high),%% 获取区域id
				scene_obj_lib:player_state_to_obj_state(PlayerState, PlayerPid, X, Y, AreaId)%% 创建场景里面的玩家对象信息
		end,
	%% 保存玩家场景对象
	SceneState1 = scene_base_lib:store_scene_obj_state(SceneState, ObjState),%%
%% 	%% 玩家进场景必须知道场景所有对象
%% 	case scene_base_lib:do_get_screen_obj(SceneState1, ObjState#scene_obj_state.obj_type, ObjState#scene_obj_state.obj_id, false) of
%% 		[] ->
%% 			skip;
%% 		ObjList ->
%% 			%% 发送进入信息给其他人
%% 			scene_send_lib:send_enter_screen(ObjList, ObjState, false)
%% 	end,

	%% 判断是否需要恢复宠物，如果有，创建宠物（一般是在玩家登陆游戏的时候做这样操作）
	RecoverList = PlayerState#player_state.recover_pet_list,
	SceneState2 =
		case RecoverList /= [] of
			true ->
				F = fun({MonsterId, Exp, CurHp}, Acc) ->
					case scene_obj_lib:create_pet(Acc, ObjState, MonsterId, Exp, CurHp) of
						{ok, Acc1} ->
							Acc1;
						_ ->
							Acc
					end
				end,
				lists:foldl(F, SceneState1, RecoverList);
			_ ->
				SceneState1
		end,

	SceneId = SceneState2#scene_state.scene_id,
	#scene_obj_state{
		x = CurX,
		y = CurY
	} = ObjState,

	SceneConf = scene_config:get(SceneId),
	NewSceneState =
		case SceneConf#scene_conf.type of
			?SCENE_TYPE_INSTANCE ->
				%% 如果场景是副本场景触发对象进入事件
				{ok, SceneState3} = instance_base_lib:on_obj_enter(SceneState2, PlayerState),
				SceneState3;
			_ ->
				SceneState2
		end,
	%% 通知玩家进程玩家成功进入场景
	gen_server2:cast(PlayerPid, {succeed_change_scene, SceneId, {ObjState, CurX, CurY, NewSceneState#scene_state.line_num}, self()}),
	{ok, NewSceneState};
%% 这里是宠物进入场景
do_enter(SceneState, ObjState, _ObjPid, ChangeType, Point) when is_record(ObjState, scene_obj_state) ->
	%% 必须先校验坐标点
	{X, Y} = scene_obj_lib:check_point(SceneState, ObjState, ChangeType, Point),
	SceneId = SceneState#scene_state.scene_id,
	SceneConf = scene_config:get(SceneId),
	NewObjState =
		case SceneConf#scene_conf.type of
			?SCENE_TYPE_INSTANCE ->
				InstanceConf = instance_config:get(SceneId),
				case InstanceConf#instance_conf.type of
					?INSTANCE_TYPE_ARENA ->
						%% 如果宠物进入的是竞技场场景，必须要让宠物休息一段时间
						%% 这里根据策划需求来写死，一般要大于倒计时
						CurTime = util_date:longunixtime(),
						ObjState#scene_obj_state{
							x = X,
							y = Y,
							ex = X,
							ey = Y,
							next_action_time = CurTime + 5000
						};
					_ ->
						ObjState#scene_obj_state{
							x = X,
							y = Y,
							ex = X,
							ey = Y
						}
				end;
			_ ->
				ObjState#scene_obj_state{
					x = X,
					y = Y,
					ex = X,
					ey = Y
				}
		end,

	NewSceneState = scene_base_lib:store_scene_obj_state(SceneState, NewObjState, ObjState),

	#scene_obj_state{
		obj_type = ObjType,
		obj_id = ObjId,
		monster_id = MonsterId,
		exp = Exp,
		cur_hp = CurHp
	} = NewObjState,

	ObjList = scene_base_lib:do_get_screen_biont(NewSceneState, ObjType, ObjId, false),
	%% 通知场景玩家对象进入
	scene_send_lib:send_enter_screen_pet(ObjList, NewObjState),
	%% 通知玩家进程宠物更新
	gen_server2:cast(ObjState#scene_obj_state.owner_pid, {pet_update, self(), ObjId, MonsterId, Exp, CurHp}),
	{ok, NewSceneState}.

%% 掉落发送
make_drop_all(GoodsList, DropPointList, SceneState, DieObjState, OwnerId, TeamId, {X, Y}) ->
	{SceneState1, DropList} = make_drop(GoodsList, DropPointList, SceneState, DieObjState, OwnerId, TeamId, []),
	ObjList = scene_base_lib:get_screen_obj_by_point(SceneState1, {X, Y}, [], [?OBJ_TYPE_PLAYER]),
	SendPlayerList = [Obj#scene_obj_state.obj_id || Obj <- ObjList],
	?INFO("DropList ~p", [DropList]),
	Data = #rep_obj_enter{drop_list = DropList},
	{ok, Bin} = pt:write_cmd(11005, Data),
	Bin1 = pt:pack(11005, Bin),
	net_send:send_one_list(SendPlayerList, Bin1),
	SceneState1.

%% 生成掉落
make_drop([], _DropPointList, SceneState, _DieObjState, _OwnerId, _TeamId, DropList) ->
	{SceneState, DropList};
make_drop(_GoodsList, [], SceneState, _DieObjState, _OwnerId, _TeamId, DropList) ->
	{SceneState, DropList};
make_drop([{GoodsId, IsBind, Num} | T], [{X, Y} | T1], SceneState, DieObjState, OwnerId, TeamId, DropList) ->
	make_drop([{GoodsId, IsBind, Num, null} | T], [{X, Y} | T1], SceneState, DieObjState, OwnerId, TeamId, DropList);
make_drop([GoodsInfo | T], [{X, Y} | T1], SceneState, DieObjState, OwnerId, TeamId, DropList) when is_record(GoodsInfo, db_goods) ->
	#db_goods{
		goods_id = GoodsId,
		is_bind = IsBind,
		num = Num
	} = GoodsInfo,
	GoodsInfo1 = GoodsInfo#db_goods{
		server_id = DieObjState#scene_obj_state.server_id
	},
	make_drop([{GoodsId, IsBind, Num, GoodsInfo1} | T], [{X, Y} | T1], SceneState, DieObjState, OwnerId, TeamId, DropList);
make_drop([{GoodsId, IsBind, Num, GoodsInfo} | T], [{X, Y} | T1], SceneState, DieObjState, OwnerId, TeamId, DropList) ->
	Uid = SceneState#scene_state.drop_cur_uid + 1,
	AreaId = area_lib:get_area_id({X, Y}, SceneState#scene_state.width, SceneState#scene_state.high),

%% 根据掉落物品归属，计算掉落归属时间以及掉落消失时间
	CurTime = util_date:unixtime(),
	{RemoveTime, OwnerChangeTime} =
		case OwnerId /= 0 of
			true ->
				{CurTime + ?DROP_REMOVE_TIME + ?DROP_OWNER_CHANGE_REMOVE_TIME, CurTime + ?DROP_OWNER_CHANGE_REMOVE_TIME};
			_ ->
				{CurTime + ?DROP_REMOVE_TIME, 0}
		end,
	GoodsConf = goods_config:get(GoodsId),

%% 对不同的物品做唯一id分段(用于玩家拾取是判断是否需要背包空格)
	Uid1 =
		case GoodsConf#goods_conf.type of
			?GOODS_TYPE_VALUE ->
				?DROP_TYPE_MONEY * ?DROP_SECTION_BASE_NUM + Uid;
			_ ->
				?DROP_TYPE_ITEM * ?DROP_SECTION_BASE_NUM + Uid
		end,
	DropState = #scene_drop_state{
		uid = Uid1,
		goods_id = GoodsId,
		bind = IsBind,
		num = Num,
		goods_info = GoodsInfo,
		x = X,
		y = Y,
		area_id = AreaId,
		remove_time = RemoveTime,
		owner_id = OwnerId,
		owner_change_time = OwnerChangeTime,
		team_id = TeamId,
		server_id = DieObjState#scene_obj_state.server_id
	},
	SceneState1 = scene_obj_lib:add_drop_state(SceneState, DropState),
	NewSceneState = SceneState1#scene_state{drop_cur_uid = Uid},

	%% 通知客户端生成掉落
	DropData = scene_obj_lib:make_proto_scene_drop(Uid1, GoodsId, X, Y, OwnerId, TeamId, OwnerChangeTime),
	DropList1 = [DropData | DropList],
	make_drop(T, T1, NewSceneState, DieObjState, OwnerId, TeamId, DropList1).
