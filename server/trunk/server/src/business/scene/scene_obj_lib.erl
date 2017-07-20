%%%-------------------------------------------------------------------
%%% @author zhengsiying
%%% @copyright (C) 2015, <COMPANY>
%%% @doc
%%%		场景对象管理模块
%%% @end
%%% Created : 09. 十一月 2015 下午3:06
%%%-------------------------------------------------------------------
-module(scene_obj_lib).

-include("common.hrl").
-include("record.hrl").
-include("config.hrl").
-include("proto.hrl").
-include("cache.hrl").
-include("notice_config.hrl").
-include("language_config.hrl").
-include("uid.hrl").
-include("log_type_config.hrl").
-include("spec.hrl").

%% API
-export([
	enter/5,
	transfer/2,
	create_all_monster/2,
	create_monster_round/5,
	create_monster/4,
	create_area_monster_from_scene/2,
	create_area_monster/2,
	create_pet/3,
	create_pet/5,
	create_image/3,
	obj_die/5,
	obj_die/6,
	pickup_drop/4,
	collection/6,
	check_drop/1,
	check_refresh_monster/1,
	get_drop_state/2,
	remove_obj/3,
	remove_obj/4,
	update_obj/5,
	start_move/6,
	move_sync/5,
	instant_move/5,
	player_revive/2,
	find_monster/3,
	update_monster_target/4,
	be_tempt/3,
	refuse_random_monster/1
]).

%% callbacks
-export([
	do_enter/5,
	do_transfer/3,
	do_obj_die/6,
	do_pickup_drop/4,
	do_collection/6,
	do_remove_obj/4,
	do_update_obj/5,
	do_start_move/6,
	do_move_sync/5,
	do_move_sync/6,
	do_player_revive/3,
	do_find_monster/3,
	do_update_monster_target/4,
	do_be_tempt/3,
	do_create_area_monster_from_scene/2
]).
%% 新加函数
-export([
	check_point/4,
	player_state_to_obj_state/5,
	make_proto_scene_drop/7,
	add_drop_state/2
]).

%% ====================================================================
%% API functions 进入场景
%% ====================================================================
%% 对象进入场景（非场景进程调用，可能是玩家进程，也可能是场景管理进程等）
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
				{X1, Y1} = check_point(SceneState, PlayerState, ChangeType, Point),
				Obj#scene_obj_state{x = X1, y = Y1};
			_ ->
				%% 对玩家进入坐标点进行校验
				{X, Y} = check_point(SceneState, PlayerState, ChangeType, Point),%% 获取坐标
				AreaId = area_lib:get_area_id({X, Y}, SceneState#scene_state.width, SceneState#scene_state.high),%% 获取区域id
				player_state_to_obj_state(PlayerState, PlayerPid, X, Y, AreaId)%% 创建场景里面的玩家对象信息
		end,
	%% 保存玩家场景对象
	SceneState1 = scene_base_lib:store_scene_obj_state(SceneState, ObjState),%%
	%% 玩家进场景必须知道场景所有对象
	case scene_base_lib:do_get_screen_obj(SceneState1, ObjState#scene_obj_state.obj_type, ObjState#scene_obj_state.obj_id, false) of
		[] ->
			skip;
		ObjList ->
			%% 发送进入信息给其他人
			scene_send_lib:send_enter_screen(ObjList, ObjState, false)%% 已经移动到copy那边了
	end,

	%% 判断是否需要恢复宠物，如果有，创建宠物（一般是在玩家登陆游戏的时候做这样操作）
	RecoverList = PlayerState#player_state.recover_pet_list,
	SceneState2 =
		case RecoverList /= [] of
			true ->
				F = fun({MonsterId, Exp, CurHp}, Acc) ->
					case create_pet(Acc, ObjState, MonsterId, Exp, CurHp) of
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
	%% 通知玩家进程玩家成功进入场景
	gen_server2:cast(PlayerPid, {succeed_change_scene, SceneId, {ObjState, CurX, CurY, SceneState2#scene_state.line_num}, self()}),
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
	{ok, NewSceneState};
%% 这里是宠物进入场景
do_enter(SceneState, ObjState, _ObjPid, ChangeType, Point) when is_record(ObjState, scene_obj_state) ->
	%% 必须先校验坐标点
	{X, Y} = check_point(SceneState, ObjState, ChangeType, Point),
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
	scene_send_lib:send_enter_screen(ObjList, NewObjState, false),%% 移动到copy
	%% 通知玩家进程宠物更新
	gen_server2:cast(ObjState#scene_obj_state.owner_pid, {pet_update, self(), ObjId, MonsterId, Exp, CurHp}),
	{ok, NewSceneState}.

%% 传送阵传送
transfer(PlayerState, TransferId) ->
	case transfer_config:get(TransferId) of
		#transfer_conf{} = TransferConf ->
			#player_state{
				player_id = PlayerId,
				scene_id = SceneId,
				scene_pid = ScenePid,
				db_player_base = DbPlayerBase
			} = PlayerState,
			Lv = DbPlayerBase#db_player_base.lv,

			#transfer_conf{
				from_scene = FScene,
				lv_limit = LvLimit,
				guild_lv_limit = GuildLvLimit,
				order_num = OrderNum,
				direction = Direction,
				to_scene = ToSceneId,
				to_pos = ToPosList
			} = TransferConf,
			?WARNING("transfer ~p", [[TransferId, OrderNum, Direction,ScenePid,"zsq"]]),

			case OrderNum /= 0 orelse Direction /= 0 of
				true ->
					scene_hjzc_lib:change_scene_line(PlayerState, ToSceneId, ToPosList, OrderNum, Direction);
				_ ->
					case FScene == SceneId andalso Lv >= LvLimit of
						true ->
							case guild_lib:get_guild_lv(DbPlayerBase#db_player_base.guild_id) >= GuildLvLimit of
								true ->
									%% 通知场景进程，玩家要进行传送阵传送
									gen_server2:apply_async(ScenePid, {?MODULE, do_transfer, [PlayerId, TransferId]}),
									{ok, PlayerState};
								false ->
									{fail, ?ERR_GUILD_LV_NOT_ENOUGH}
							end;
						_ ->
							%% 传送条件不符
							{fail, ?ERR_PLAYER_LV_NOT_GO_TO}
					end
			end;
		_ ->
			%% 无效的操作
			{fail, ?ERR_COMMON_FAIL}
	end.

%% 传送阵传送（玩家当前所处场景进程处理）
do_transfer(SceneState, PlayerId, TransferId) ->
	case scene_base_lib:get_scene_obj_state(SceneState, ?OBJ_TYPE_PLAYER, PlayerId) of
		#scene_obj_state{} = Obj ->
			TransferConf = transfer_config:get(TransferId),
			X = Obj#scene_obj_state.x,
			Y = Obj#scene_obj_state.y,
			#transfer_conf{
				to_scene = ToScene,
				to_pos = ToPosList,
				from_pos = {FX, FY}
			} = TransferConf,
			ToPos = util_rand:list_rand(ToPosList),
			D = util_math:get_distance({X, Y}, {FX, FY}),
			%% 检查玩家与传送阵的距离是否合法
			%% 允许有两格距离的误差
			?WARNING("do_transfer ~p", [[D,X,Y,FX,FY,"zsq"]]),
			case D =< 2 of
				true ->
					%% 通知玩家进程可以切换场景
					gen_server2:cast(Obj#scene_obj_state.obj_pid, {change_scene, ToScene, ?CHANGE_SCENE_TYPE_CHANGE, ToPos});
				_ ->
					skip
			end;
		_ ->
			skip
	end.

%% 校验坐标点
check_point(SceneState, PlayerState, ChangeType, Point) when is_record(PlayerState, player_state) ->
	SceneId = SceneState#scene_state.scene_id,
	PlayerId = PlayerState#player_state.player_id,
	DbPlayerBase = PlayerState#player_state.db_player_base,
	GuildId = DbPlayerBase#db_player_base.guild_id,
	%% 判断是不是指定坐标点传送
	case Point of
		{X, Y} ->
			%% 如果是指点坐标点传送，判断指点的坐标点是否是可走点
			case area_lib:get_grid_flag(SceneId, {X, Y}) of
				?GRID_FLAG_OFF ->
					%% 如果坐标点不可走，进入修正坐标流程
					check_point1(SceneState, ?OBJ_TYPE_PLAYER, PlayerId, GuildId, ChangeType);
				_ ->
					%% 否则直接返回指点坐标
					{X, Y}
			end;
		_ ->
			%% 不是指定坐标传送，进入修正坐标流程
			check_point1(SceneState, ?OBJ_TYPE_PLAYER, PlayerId, GuildId, ChangeType)
	end;
check_point(_SceneState, _ObjState, _ChangeType, Point) ->
	Point.

%% 校验坐标点（修正坐标流程）
check_point1(SceneState, ObjType, ObjId, GuildId, ChangeType) ->
	SceneId = SceneState#scene_state.scene_id,
	SceneConf = scene_config:get(SceneId),
	PointTemp =
		case ChangeType of
			?CHANGE_SCENE_TYPE_REVIVE ->
				%% 如果切场景方式是复活切场景
				IsActivityTime = scene_activity_base_lib:is_activity_time(SceneState),
				%% 判断是否在沙城场景，同时判断沙城活动有没有开启
				case SceneConf#scene_conf.activity_id =:= ?SCENE_ACTIVITY_SHACHENG andalso IsActivityTime =:= true of
					true ->
						%% 如果是沙城活动期间
						ActivityConf = scene_activity_config:get(SceneConf#scene_conf.activity_id),
						{revive_area, Attack, Defend} = ActivityConf#scene_activity_conf.effect,
						OccupyGuildId = scene_activity_shacheng_lib:get_occupy_guild_id(),
						%% 根据是否是占领帮派把玩家复活到不同的坐标点
						case GuildId /= 0 andalso GuildId =:= OccupyGuildId of
							true ->
								%% 占领帮派，复活到防守方复活点
								Defend;
							_ ->
								%% 非占领帮派，复活到进攻方复活点
								Attack
						end;
					_ ->
						%% 非特殊场景在场景复活点复活
						TempLength = length(SceneConf#scene_conf.revive_area),%%
						case TempLength > 0 of
							true ->
								TempRandNum = random:uniform(TempLength),
								lists:nth(TempRandNum, SceneConf#scene_conf.revive_area);%%
							_ ->
								{}
						end
				end;
			_ ->
				%% 如果不是复活方式进行的切换场景，在出生点出生
				TempLength = length(SceneConf#scene_conf.birth_area),%%
				case TempLength > 0 of
					true ->
						TempRandNum = random:uniform(TempLength),
						lists:nth(TempRandNum, SceneConf#scene_conf.birth_area);%%
					_ ->
						{}
				end

		end,

	{{BX, BY}, {EX, EY}} = case PointTemp of
							   {} ->
								   yu_test:log_err(),
								   ?ERR("~p", [{SceneId, ObjType, ObjId, GuildId, ChangeType}]),
								   TempLength1 = length(SceneConf#scene_conf.birth_area),%%
								   case TempLength1 > 0 of
									   true ->
										   TempRandNum1 = random:uniform(TempLength1),
										   lists:nth(TempRandNum1, SceneConf#scene_conf.birth_area);%%
									   _ ->
										   {}
								   end;
							   _ ->
								   PointTemp
						   end,

	case ChangeType of
		?CHANGE_SCENE_TYPE_REVIVE ->
			%% 如果是复活传送，直接根据复活区域返回所在坐标
			{util_rand:rand(BX, EX), util_rand:rand(BY, EY)};
		_ ->
			case scene_base_lib:get_scene_obj_state(SceneState, ObjType, ObjId) of
				#scene_obj_state{x = X1, y = Y1} = _Obj ->
					%% 如果对象原本就在当前场景，判断玩家当前所在坐标是否是不可走点
					case area_lib:get_grid_flag(SceneId, {X1, Y1}) of
						?GRID_FLAG_OFF ->
							%% 如果是不可走点，根据修正区域返回坐标
							{util_rand:rand(BX, EX), util_rand:rand(BY, EY)};
						_ ->
							%% 否则返回当前坐标
							{X1, Y1}
					end;
				_ ->
					%% 如果是新进入这个场景，根据修正区域返回坐标
					{util_rand:rand(BX, EX), util_rand:rand(BY, EY)}
			end
	end.

%% 创建场景所有怪物
create_all_monster(SceneState, SceneConf) ->
	MonsterList = SceneConf#scene_conf.monster_list,
	F = fun(RuleInfo, Acc) ->
		create_area_monster(Acc, RuleInfo)
	end,
	lists:foldl(F, SceneState, MonsterList).

%% 加载下一波怪物
create_monster_round(SceneState, SceneConf, Round, EndTime, CurTime) ->
	RuleMonsterList = SceneConf#scene_conf.rule_monster_list,
	?INFO("create_monster_round 111 ~p", [Round]),
	case lists:keyfind(Round, 2, RuleMonsterList) of
		{_, _, MonsterList} ->
			F = fun(RuleInfo, Acc) ->
				create_area_monster(Acc, RuleInfo)
			end,
			SceneState1 = lists:foldl(F, SceneState, MonsterList),
			?INFO("create_monster_round 222 ~p", [Round]),
			%% 根据刷怪配置计算怪物总数和boss总数
			F1 = fun(Info, Acc) ->
				{MonsterCount, BossCount} = Acc,
				case Info of
					{monster_type, MonsterId, Num, _, _} ->
						MonsterConf = monster_config:get(MonsterId),
						case MonsterConf#monster_conf.type of
							?MONSTER_TYPE_BOSS ->
								{MonsterCount, BossCount + Num};
							_ ->
								{MonsterCount + Num, BossCount}
						end;
					{area_type, _, _, Num, _, _} ->
						{MonsterCount + Num, BossCount}
				end
			end,
			{MonsterCount, BossCount} = lists:foldl(F1, {0, 0}, MonsterList),

			InstanceState = #instance_single_state{
				monster_count = MonsterCount,
				kill_monster_count = 0,
				boss_count = BossCount,
				kill_boss_count = 0,
				logout_time = 0
			},

			SceneState2 = SceneState1#scene_state{
				round = Round,
				instance_state = InstanceState
			},
			%% 发送给前端更新数据信息
			Data = #rep_single_instance_info{
				scene_id = SceneConf#scene_conf.scene_id,
				monster_count = MonsterCount,
				kill_monster = 0,
				boss_count = BossCount,
				kill_boss = 0,
				end_time = EndTime - CurTime,
				round = Round
			},
			scene_send_lib:do_send_scene(SceneState, 11015, Data),
			{SceneState2, 1};
		_ ->
			{SceneState, 0}
	end.

%% 创建一个刷怪区怪物
create_area_monster_from_scene(ScenePid, Conf) ->
	gen_server2:apply_async(ScenePid, {?MODULE, do_create_area_monster_from_scene, [Conf]}).
do_create_area_monster_from_scene(SceneState, {monster_type, MonsterId, Num, RefreshInterval, RefreshLocation}) ->
	do_create_area_monster_from_scene(SceneState, {monster_type, MonsterId, Num, RefreshInterval, 0, RefreshLocation});
do_create_area_monster_from_scene(SceneState, {monster_type, MonsterId, Num, RefreshInterval, GoOutTime, RefreshLocation}) ->
	F = fun(_, Acc) ->
		case create_monster(Acc, MonsterId, RefreshInterval, RefreshLocation, GoOutTime) of
			{ok, NewAcc} ->
				NewAcc;
			_ ->
				Acc
		end
	end,
	NewSceneState = lists:foldl(F, SceneState, lists:seq(1, Num)),
	{ok, NewSceneState}.

%% 创建一个刷怪区怪物
create_area_monster(SceneState, {monster_type, MonsterId, Num, RefreshInterval, RefreshLocation}) ->
	create_area_monster(SceneState, {monster_type, MonsterId, Num, RefreshInterval, 0, RefreshLocation});
create_area_monster(SceneState, {monster_type, MonsterId, Num, RefreshInterval, GoOutTime, RefreshLocation}) ->
	F = fun(_, Acc) ->
		case create_monster(Acc, MonsterId, RefreshInterval, RefreshLocation, GoOutTime) of
			{ok, NewAcc} ->
				NewAcc;
			_ ->
				Acc
		end
	end,
	lists:foldl(F, SceneState, lists:seq(1, Num));
create_area_monster(SceneState, {area_type, AreaFlag, MonsterId, Num, RefreshInterval, RefreshLocation}) ->
	create_area_monster(SceneState, {area_type, AreaFlag, MonsterId, Num, RefreshInterval, 0, RefreshLocation});
create_area_monster(SceneState, {area_type, AreaFlag, MonsterId, Num, RefreshInterval, GoOutTime, RefreshLocation}) ->
	F = fun(_, Acc) ->
		case create_monster(Acc, MonsterId, RefreshInterval, RefreshLocation, AreaFlag, GoOutTime) of
			{ok, NewAcc} ->
				NewAcc;
			_ ->
				Acc
		end
	end,
	lists:foldl(F, SceneState, lists:seq(1, Num));
create_area_monster(SceneState, {collect_type, MonsterId, Num, RefreshInterval, RefreshLocation}) ->
	create_area_monster(SceneState, {collect_type, MonsterId, Num, RefreshInterval, 0, RefreshLocation});
create_area_monster(SceneState, {collect_type, MonsterId, Num, RefreshInterval, GoOutTime, RefreshLocation}) ->
	F = fun(_, Acc) ->
		case create_one_collect_monster(Acc, MonsterId, RefreshInterval, RefreshLocation, GoOutTime) of
			{ok, NewAcc} ->
				NewAcc;
			_ ->
				Acc
		end
	end,
	lists:foldl(F, SceneState, lists:seq(1, Num)).

%% 创建一个刷新规则作用于自身的怪物
create_monster(SceneState, MonsterId, RefreshInterval, RefreshLocation) ->
	create_one_monster(SceneState, MonsterId, RefreshInterval, RefreshLocation, null, 0).
%% 创建一个刷新规则作用于自身的怪物
create_monster(SceneState, MonsterId, RefreshInterval, RefreshLocation, GoOutTime) ->
	create_one_monster(SceneState, MonsterId, RefreshInterval, RefreshLocation, null, GoOutTime).
%% 创建一个刷新规则作用于刷怪区的怪物
create_monster(SceneState, MonsterId, RefreshInterval, RefreshLocation, AreaFlag, GoOutTime) ->
	create_one_monster(SceneState, MonsterId, RefreshInterval, RefreshLocation, AreaFlag, GoOutTime).

%% 创建一个怪物
create_one_monster(SceneState, MonsterId, RefreshInterval, RefreshLocation, AreaFlag, GoOutTime) ->
	try
		{X, Y} = find_empty_point(1, SceneState, RefreshLocation),
		Uid = SceneState#scene_state.cur_uid + util_rand:rand(1, 10),
		AreaId = area_lib:get_area_id({X, Y}, SceneState#scene_state.width, SceneState#scene_state.high),
		SceneId = SceneState#scene_state.scene_id,
		ObjState = monster_to_obj_state(MonsterId, SceneId, Uid, X, Y, AreaId, RefreshInterval, RefreshLocation, AreaFlag, GoOutTime),
		SceneState1 = scene_base_lib:store_scene_obj_state(SceneState, ObjState),%%

		ObjType = ObjState#scene_obj_state.obj_type,
		ObjId = ObjState#scene_obj_state.obj_id,
		ScreenObjList = scene_base_lib:do_get_screen_biont(SceneState1, ObjType, ObjId, false),
		scene_send_lib:send_enter_screen(ScreenObjList, ObjState, false),

		scene_base_lib:add_obstacle({X, Y}, {?OBJ_TYPE_MONSTER, Uid}),
		NewSceneState = SceneState1#scene_state{cur_uid = Uid + 1},

		%% 世界boss刷新公告
		SceneConf = scene_config:get(SceneId),
		#monster_conf{
			notice = Notice,
			count_down = CountDown,
			name = Name
		} = monster_config:get(MonsterId),
		%% 只有线路1才发送公告
		case SceneState#scene_state.line_num =:= 1 of
			true ->
				case Notice of
					?MONSTER_NOTICE_ALL ->
						notice_lib:send_notice(0, ?NOTICE_WORD_BOSS_REF, [Name, SceneConf#scene_conf.name]);
					?MONSTER_NOTICE_REFRESH ->
						notice_lib:send_notice(0, ?NOTICE_WORD_BOSS_REF, [Name, SceneConf#scene_conf.name]);
					?MONSTER_NOTICE_SPEC_ALL ->
						notice_lib:send_notice(0, ?NOTICE_RANDOM_BOSS_REF, [Name, SceneConf#scene_conf.name]);
					_ ->
						skip
				end;
			_ ->
				skip
		end,

		%% 怪物刷新倒计时
		case CountDown of
			?REFRESH_COUNT_DOWN ->
				scene_mgr_lib:update_boss_refresh(SceneId, SceneState#scene_state.line_num, MonsterId, 0);
			_ ->
				skip
		end,

		{ok, NewSceneState}
	catch
		Error:Info ->
			?ERR("scene_id:~p  monster_id:~p, RefreshLocation:~p  ~p:~p ~n", [SceneState#scene_state.scene_id, MonsterId, RefreshLocation, Error, Info]),
			{ok, SceneState}
	end.

%% 创建一个玩家镜像
create_image(SceneState, PlayerState, {X, Y}) ->
	AreaId = area_lib:get_area_id({X, Y}, SceneState#scene_state.width, SceneState#scene_state.high),
	ObjState = image_to_obj_state(PlayerState, X, Y, AreaId),
	SceneState1 = scene_base_lib:store_scene_obj_state(SceneState, ObjState),%%

	ObjType = ObjState#scene_obj_state.obj_type,
	ObjId = ObjState#scene_obj_state.obj_id,
	ScreenObjList = scene_base_lib:do_get_screen_biont(SceneState1, ObjType, ObjId, false),

	scene_send_lib:send_enter_screen(ScreenObjList, ObjState, false),
	{ok, SceneState1}.

%% 添加怪物刷新对象，指定下一次根据刷新时间地点指定下一次刷新怪物
next_create_monster(SceneState, DieObjId, MonsterId, RefreshInterval, RefreshLocation) ->
	#scene_state{
		scene_id = SceneId,
		monster_refresh_dict = MonsterRefDict
	} = SceneState,
	case dict:find(DieObjId, MonsterRefDict) of
		{ok, _} ->
			SceneState;
		_ ->
			#monster_conf{
				type = Type,
				notice = Notice,
				count_down = CountDown,
				name = Name,
				random_refuse = _RandomRefuse,
				is_red = ISRed
			} = monster_config:get(MonsterId),
			SceneConf = scene_config:get(SceneId),

			CurTime = util_date:unixtime(),
			%% 根据限制计算下一次刷怪时间
			RefreshTime =
				case Type of
					?MONSTER_TYPE_BOSS ->
						RandRI = get_refresh_interval(RefreshInterval),
						{{BH, BM}, {EH, EM}} = SceneConf#scene_conf.boss_refresh_limit,
						Time = CurTime + RandRI,
						{_, {Hour, Min, _Second}} = util_date:unixtime_to_local_time(Time),
						M1 = Hour * 60 + Min,
						M2 = BH * 60 + BM,
						M3 = EH * 60 + EM,

						RefreshCountdown =
							case (M1 >= 0 andalso M1 < M2) orelse M1 >= M3 of
								true ->
									util_date:get_tomorrow_unixtime() + M2 * 60 - CurTime;
								_ ->
									RandRI
							end,

						CurTime + RefreshCountdown;
					_ ->
						CurTime + get_refresh_interval(RefreshInterval)
				end,

			%% 判断是否掉落红包
			case ISRed =:= 1 of
				true ->
					red_lib:send_red_boss(Name);
				_ ->
					skip
			end,

			%% 获取新的怪物id
			%% NewMonsterId = get_random_monster_id(MonsterId, RandomRefuse),

			%% 怪物刷新倒计时
			case CountDown of
				?REFRESH_COUNT_DOWN ->
					%% 如果是需要倒计时统计，更新怪物刷新倒计时
					scene_mgr_lib:update_boss_refresh(SceneId, SceneState#scene_state.line_num, MonsterId, RefreshTime);
				_ ->
					skip
			end,

			%% 判断怪物死亡是否需要通知玩家，如果是广播怪物死亡消息给前端
			case SceneState#scene_state.line_num =:= 1 of
				true ->
					%% 刷新boss刷新时间信息
					case lists:member(MonsterId, world_boss_config:get_monsterid_list()) of
						true ->
							scene_lib:ref_world_boss();
						_ ->
							skip
					end,
					case Notice of
						?MONSTER_NOTICE_ALL ->
							notice_lib:send_notice(0, ?NOTICE_WORD_BOSS_DIE, [Name, SceneConf#scene_conf.name]);
						?MONSTER_NOTICE_DIE ->
							notice_lib:send_notice(0, ?NOTICE_WORD_BOSS_DIE, [Name, SceneConf#scene_conf.name]);
						?MONSTER_NOTICE_SPEC_ALL ->
							notice_lib:send_notice(0, ?NOTICE_RANDOM_BOSS_DIE, [Name, SceneConf#scene_conf.name]);
						_ ->
							skip
					end;
				_ ->
					skip
			end,

			scene_base_lib:add_monster_refresh(SceneState, DieObjId, RefreshTime, MonsterId, RefreshInterval, RefreshLocation)
	end.

%% 创建宠物
create_pet(SceneState, CasterObjState, MonsterId) ->
	create_pet(SceneState, CasterObjState, MonsterId, 0, null).
%% 创建宠物
create_pet(SceneState, CasterObjState, MonsterId, Exp, CurHp) ->
	SceneId = SceneState#scene_state.scene_id,
	#scene_obj_state{
		obj_type = OwnerType,
		obj_pid = OwnerPid,
		x = X,
		y = Y
	} = CasterObjState,

	%% 根据施法者，计算出宠物出生坐标
	PointList = area_lib:get_round_point_list(SceneId, {X, Y}, 2),
	{X1, Y1} =
		case util_rand:list_rand(PointList) of
			{_X, _Y} ->
				{_X, _Y};
			_ ->
				{X, Y}
		end,

	Uid = uid_lib:get_uid(?UID_TYPE_PET),
	AreaId = area_lib:get_area_id({X1, Y1}, SceneState#scene_state.width, SceneState#scene_state.high),
	ObjState = pet_to_obj_state(Uid, MonsterId, Exp, CurHp, X1, Y1, AreaId, CasterObjState),
	SceneState1 = scene_base_lib:store_scene_obj_state(SceneState, ObjState),%%

	ScenePid = self(),
	SceneState2 =
		case OwnerType of
			?OBJ_TYPE_PLAYER ->
				%% 如果施法者是玩家
				%% 通知玩家怪物召唤成功
				gen_server2:cast(OwnerPid, {call_pet, ScenePid, Uid, MonsterId, Exp, ObjState#scene_obj_state.cur_hp}),
				SceneState1;
			_ ->
				%% 施法者不是玩家
				%% 直接更新场景中施法者宠物字典
				PetDict = CasterObjState#scene_obj_state.pet_dict,
				PetInfo = #pet_info{
					uid = Uid,
					scene_pid = ScenePid,
					monster_id = MonsterId,
					exp = Exp
				},
				NewPetDict = dict:store(Uid, PetInfo, PetDict),
				NewCasterObj = CasterObjState#scene_obj_state{pet_dict = NewPetDict},
				scene_base_lib:store_scene_obj_state(SceneState1, NewCasterObj, CasterObjState)
		end,

	ObjType = ObjState#scene_obj_state.obj_type,
	ObjId = ObjState#scene_obj_state.obj_id,
	ScreenObjList = scene_base_lib:do_get_screen_biont(SceneState2, ObjType, ObjId, false),

	%% 通知场景玩家对象进屏
	scene_send_lib:send_enter_screen(ScreenObjList, ObjState, false),

	%% {NewSceneState, _} = game_obj_lib:start_ai(SceneState2, ObjState),
	{ok, SceneState2}.

%% 创建一个采集怪物
create_one_collect_monster(SceneState, MonsterId, RefreshInterval, RefreshLocation, GoOutTime) ->
	try
		{X, Y} = find_empty_point(1, SceneState, RefreshLocation),
		Uid = SceneState#scene_state.cur_uid + util_rand:rand(1, 10),
		AreaId = area_lib:get_area_id({X, Y}, SceneState#scene_state.width, SceneState#scene_state.high),
		SceneId = SceneState#scene_state.scene_id,
		ObjState = collection_to_obj_state(MonsterId, SceneId, Uid, X, Y, AreaId, RefreshInterval, RefreshLocation, null, GoOutTime),
		SceneState1 = scene_base_lib:store_scene_obj_state(SceneState, ObjState),%%

		ObjType = ObjState#scene_obj_state.obj_type,
		ObjId = ObjState#scene_obj_state.obj_id,
		ScreenObjList = scene_base_lib:do_get_screen_biont(SceneState1, ObjType, ObjId, false),
		scene_send_lib:send_enter_screen(ScreenObjList, ObjState, false),

		scene_base_lib:add_obstacle({X, Y}, {?OBJ_TYPE_COLLECT, Uid}),
		NewSceneState = SceneState1#scene_state{cur_uid = Uid + 1},

		{ok, NewSceneState}
	catch
		Error:Info ->
			?ERR("scene_id:~p  monster_id:~p, RefreshLocation:~p  ~p:~p ~n", [SceneState#scene_state.scene_id, MonsterId, RefreshLocation, Error, Info]),
			{ok, SceneState}
	end.

%% 检查并刷新怪物
check_refresh_monster(SceneState) ->
	%% 刷新刷怪区规则控制的怪物
	Dict = SceneState#scene_state.monster_area_dict,
	CurTime = util_date:unixtime(),
	F = fun(_, AreaObj, Acc) ->
		#monster_area_state{
			area_flag = AreaFlag,
			count = Count,
			monster_id = MonsterId,
			monster_list = List,
			next_refresh_time = RefTime,
			refresh_interval = RI,
			refresh_location = RL
		} = AreaObj,
		CurCount = length(List),
		%%CurCount = check_monster(SceneState,List),
		case CurTime >= RefTime andalso RI >= 0 of
			true ->
				Acc1 = scene_base_lib:update_monster_area(Acc, AreaFlag, CurTime + RI),
				case Count > CurCount of
					true ->
						create_area_monster(Acc1, {area_type, AreaFlag, MonsterId, Count - CurCount, RI, RL});
					_ ->
						Acc1
				end;
			_ ->
				Acc
		end
	end,
	SceneState1 = dict:fold(F, SceneState, Dict),

	%% 刷新单个刷新怪物
	Dict1 = SceneState1#scene_state.monster_refresh_dict,
	F1 =
		fun(_, RefreshState, Acc) ->
			#monster_refresh_state{
				die_obj_id = DieObjId,
				monster_id = MonsterId,
				next_refresh_time = RefreshTime,
				refresh_location = RefreshLocation,
				refresh_interval = RefreshInterval
			} = RefreshState,

			case CurTime >= RefreshTime - 300 of
				true ->
					player_monster_follow_lib:follow_push(SceneState#scene_state.scene_id, MonsterId),
					ok;
				false ->
					no
			end,


			case CurTime >= RefreshTime of
				true ->
					Acc1 = scene_base_lib:delete_monster_refresh(Acc, DieObjId),
					%% 检测如果是随机场景怪物刷新在其他场景
					case random_monster_config:get(MonsterId) of
						#random_monster_conf{} = Conf ->
							refuse_random_monster(Conf),
							Acc1;
						_ ->
							player_monster_follow_lib:follow_notice_online(SceneState#scene_state.scene_id, MonsterId),
							case create_monster(Acc1, MonsterId, RefreshInterval, RefreshLocation) of
								{ok, Acc2} ->
									Acc2;
								_ ->
									Acc
							end
					end;
				_ ->
					Acc
			end
		end,
	dict:fold(F1, SceneState1, Dict1).

%% check_monster(SceneState, List) ->
%% 	F = fun(X, Sum) ->
%% 		case scene_base_lib:get_scene_obj_state(SceneState, ?OBJ_TYPE_MONSTER, X) of
%% 			#scene_obj_state{cur_hp = CurHp} = _ when CurHp > 0 ->
%% 				Sum + 1;
%% 			_ ->
%% 				Sum
%% 		end
%% 	end,
%% 	lists:foldl(F, 0, List).

%% 对象死亡
obj_die(ScenePid, ObjType, ObjId, GoodsList, KillerState) ->
	gen_server2:apply_async(ScenePid, {?MODULE, do_obj_die, [ObjType, ObjId, GoodsList, KillerState, null]}).

obj_die(ScenePid, ObjType, ObjId, GoodsList, KillerState, OwnerFlag) ->
	gen_server2:apply_async(ScenePid, {?MODULE, do_obj_die, [ObjType, ObjId, GoodsList, KillerState, OwnerFlag]}).

do_obj_die(SceneState, ObjType, ObjId, GoodsList, KillerState, OwnerFlag) ->
	case scene_base_lib:get_scene_obj_state(SceneState, ObjType, ObjId) of
		#scene_obj_state{cur_hp = CurHp, x = X, y = Y} = ObjState when CurHp =< 0 ->
			SceneConf = scene_config:get(SceneState#scene_state.scene_id),
			SceneState1 =
				case SceneConf#scene_conf.type of
					?SCENE_TYPE_INSTANCE ->
						{ok, _SceneState} = instance_base_lib:on_obj_die(SceneState, ObjState, KillerState),
						_SceneState;
					_ ->
						SceneState
				end,

			%%player_monster_lib:city_boss_killer_last(ObjState, KillerState),

			SceneState2 =
				case GoodsList /= [] of
					true ->
						%% 生成归属id
						{OwnerId, TeamId, ServerId} = make_owner_id(SceneState1, OwnerFlag),
						player_monster_lib:save_monster_boss_drop(SceneState, ObjState, KillerState, GoodsList, OwnerId),

						log_lib:log_drop(ObjState, SceneState, {OwnerId, TeamId, ServerId}, GoodsList, ?LOG_TYPE_DROP),
						DropNum = length(GoodsList),
						%% 根据掉落数量，获取掉落坐标点列表
						DropPointList = get_drop_point_list(DropNum, SceneState1, {X, Y}, 0, []),
						%% 生成掉落
						%%_SceneState1 = make_drop(GoodsList, DropPointList, SceneState1, OwnerId, TeamId), 20160429修改
						_SceneState1 = scene_obj_lib_copy:make_drop_all(GoodsList, DropPointList, SceneState1, ObjState, OwnerId, TeamId, {X, Y}),
						_SceneState1;
					_ ->
						SceneState1
				end,

			#scene_obj_state{
				monster_id = MonsterId,
				refresh_interval = RefreshInterval,
				refresh_location = RefreshLocation,
				area_flag = AreaFlag
			} = ObjState,

			NewSceneState =
				case ObjType of
					?OBJ_TYPE_MONSTER ->
						%% 开始定时刷出新怪
						case RefreshInterval >= 0 andalso util_data:is_null(AreaFlag) of
							true ->
								next_create_monster(SceneState2, ObjId, MonsterId, RefreshInterval, RefreshLocation);
							_ ->
								SceneState2
						end;
					_ ->
						SceneState2
				end,

			case not util_data:is_null(AreaFlag) of
				true ->
					NewSceneState1 = scene_base_lib:delete_obj_from_monster_area(NewSceneState, AreaFlag, ObjId),
					{ok, NewSceneState1};
				_ ->
					{ok, NewSceneState}
			end;
		_ ->
			{ok, SceneState}
	end.

%% 生成归属id
make_owner_id(SceneState, OwnerFlag) ->
	case OwnerFlag of
		{OwnerType, OwnerId} ->
			%% 如果归属玩家在场景里面，并且是活着的状态
			case scene_base_lib:get_scene_obj_state(SceneState, OwnerType, OwnerId) of
				#scene_obj_state{cur_hp = CurHp} = ObjState ->
					case OwnerType of
						?OBJ_TYPE_PLAYER ->
							case CurHp > 0 of
								true ->
									%% 归属属于归属者
									{OwnerId, ObjState#scene_obj_state.team_id, ObjState#scene_obj_state.server_id};
								_ ->
									{0, 0, 0}
							end;
						_ ->
							%% 如果归属者不是玩家，那么寻找归属者的主人
							OwnerId1 = ObjState#scene_obj_state.owner_id,
							case scene_base_lib:get_scene_obj_state(SceneState, OwnerType, OwnerId1) of
								#scene_obj_state{cur_hp = CurHp1} = _bjState when CurHp1 > 0 ->
									%% 归属属于原归属者主人
									{OwnerId1, ObjState#scene_obj_state.team_id, ObjState#scene_obj_state.server_id};
								_ ->
									{0, 0, 0}
							end
					end;
				_ ->
					{0, 0, 0}
			end;
		_ ->
			{0, 0, 0}
	end.

%% 根据掉落数量获取掉落坐标点列表
get_drop_point_list(Num, SceneState, {X, Y}, Radius, List) ->
	case Num =< 0 orelse Radius >= 20 of
		true ->
			List;
		_ ->
			SceneId = SceneState#scene_state.scene_id,
			List1 = area_lib:get_round_border(SceneId, {X, Y}, Radius),

			%% 过滤掉已经有掉落的点
			F = fun(Point) ->
				case get_obj_from_drop_point(SceneState, Point) of
					[] ->
						true;
					_ ->
						false
				end
			end,
			List2 = lists:filter(F, List1),

			%% 过滤掉传送阵周边
			TransferList = transfer_config:get_scene_transfer_list(SceneId),
			F1 =
				fun(Point) ->
					filter_transfer(TransferList, Point)
				end,
			List3 = lists:filter(F1, List2),

			Num1 = length(List3),
			case Num1 > Num of
				true ->
					lists:sublist(List3, Num) ++ List;
				_ ->
					get_drop_point_list(Num - Num1, SceneState, {X, Y}, Radius + 1, List3 ++ List)
			end
	end.

%% 过滤掉传送阵坐标坐标
filter_transfer([], {_X, _Y}) ->
	true;
filter_transfer([{X1, Y1} | T], {X, Y}) ->
	BX = max(X1 - 1, 0),
	BY = max(Y1 - 1, 0),
	EX = max(X1 + 1, 0),
	EY = max(Y1 + 1, 0),
	case X >= BX andalso X =< EX andalso Y >= BY andalso Y =< EY of
		true ->
			false;
		_ ->
			filter_transfer(T, {X, Y})
	end.

%% 拾取掉落
pickup_drop(ScenePid, PlayerId, TeamId, DropId) ->
	gen_server2:apply_async(ScenePid, {?MODULE, do_pickup_drop, [PlayerId, TeamId, DropId]}).
%% 摄取掉落的物品
do_pickup_drop(SceneState, PlayerId, TeamId, DropId) ->
	case scene_base_lib:get_scene_obj_state(SceneState, ?OBJ_TYPE_PLAYER, PlayerId) of
		#scene_obj_state{} = ObjState ->
			case get_drop_state(SceneState, DropId) of
				#scene_drop_state{} = DropState ->
					#scene_drop_state{
						goods_id = GoodsId,
						owner_id = OwnerId,
						owner_change_time = OwnerChangeTime,
						bind = IsBind,
						num = Num,
						x = X1,
						y = Y1,
						team_id = OwnerTeamId,
						goods_info = GoodsInfo
					} = DropState,

					CurTime = util_date:unixtime(),
					case PlayerId == OwnerId orelse OwnerChangeTime < CurTime orelse
						(TeamId > 0 andalso TeamId == OwnerTeamId) of
						true ->
							#scene_obj_state{
								obj_pid = ObjPid,
								x = X,
								y = Y
							} = ObjState,

							Dist = util_math:get_distance({X, Y}, {X1, Y1}),
							%% 检查距离是否合法
							case Dist =< 2 of
								true ->
									%% 先删除场景掉落，再通知玩家进程添加掉落物品
									NewState = delete_drop_state(SceneState, DropState),
									player_lib:pickup_drop(ObjPid, GoodsId, Num, IsBind, GoodsInfo),
									{ok, NewState};
								_ ->
									{ok, SceneState}
							end;
						_ ->
							{ok, SceneState}
					end;
				_ ->
					{ok, SceneState}
			end;
		_ ->
			{ok, SceneState}
	end.

%% 检查掉落（定时移除消失的掉落物品）
check_drop(SceneState) ->
	DropDict = SceneState#scene_state.drop_dict,
	CurTime = util_date:unixtime(),
	F = fun(_K, DropState, Acc) ->
		case DropState#scene_drop_state.remove_time =< CurTime of
			true ->
				delete_drop_state(Acc, DropState);
			_ ->
				Acc
		end
	end,
	dict:fold(F, SceneState, DropDict).

%% 场景采集
collection(ScenePid, PlayerId, GuildId, PlayerPid, FreeBag, ObjId) ->
	gen_server2:apply_async(ScenePid, {?MODULE, do_collection, [PlayerId, GuildId, PlayerPid, FreeBag, ObjId]}).
%% 采集场景怪物
do_collection(SceneState, PlayerId, GuildId, PlayerPid, FreeBag, ObjId) ->
	case do_collection1(SceneState, PlayerId, GuildId, PlayerPid, FreeBag, ObjId) of
		{fail, Err} ->
			net_send:send_to_client(PlayerPid, 11043, #rep_collection{result = Err}),
			{ok, SceneState};
		{ok, SceneState1} ->
			net_send:send_to_client(PlayerPid, 11043, #rep_collection{result = ?ERR_COMMON_SUCCESS}),
			{ok, SceneState1}
	end.
do_collection1(SceneState, PlayerId, GuildId, _PlayerPid, FreeBag, ObjId) ->
	case scene_base_lib:get_scene_obj_state(SceneState, ?OBJ_TYPE_PLAYER, PlayerId) of
		#scene_obj_state{} = ObjState ->
			case scene_base_lib:get_scene_obj_state(SceneState, ?OBJ_TYPE_COLLECT, ObjId) of
				#scene_obj_state{} = CollectObjState ->
					#scene_obj_state{
						x = X,
						y = Y,
						obj_pid = ObjPid,
						career = Career,
						name = ObjName
					} = ObjState,

					#scene_obj_state{
						x = X1,
						y = Y1,
						monster_id = MonsterId
					} = CollectObjState,

					Dist = util_math:get_distance({X, Y}, {X1, Y1}),
					%% 检查距离是否合法
					case Dist =< 2 of
						true ->
							MonsterConf = monster_config:get(MonsterId),
							DropList = MonsterConf#monster_conf.drop_list,
							CollectList = rand_drop(DropList, Career, []),
							case FreeBag >= length(CollectList) of
								true ->
									%% 检测采集次数限制
									case scene_activity_palace_lib:check_collect(PlayerId, GuildId, MonsterId) of
										{ok, _} ->
											%% 告诉副本场景 怪物死亡
											?INFO("~p", [SceneState#scene_state.scene_id]),
											SceneState_1 = case SceneState#scene_state.scene_id of
															   ?SCENEID_HJZC_FAJIAN ->
																   {ok, _SceneState} = instance_base_lib:on_obj_die(SceneState, CollectObjState, ObjState),
																   _SceneState;
															   _ ->
																   SceneState
														   end,
											%% 删除场景怪物，
											{ok, SceneState1} = do_remove_obj(SceneState_1, ?OBJ_TYPE_COLLECT, ObjId, ?LEAVE_SCENE_TYPE_INITIATIVE),
											%% 添加采集物品进入玩家背包
											player_lib:collection(ObjPid, CollectList),

											%% 发送公告信息
											case MonsterConf#monster_conf.notice > 0 of
												true ->
													F = fun(TempGoodsInfo) ->
														{TempGoodsId, _TempIsBind, TempNum} = TempGoodsInfo,
														TempGoodsConf = goods_config:get(TempGoodsId),
														io_lib:format("~s*~w", [TempGoodsConf#goods_conf.name, TempNum])
													end,
													NoticeInfoList = [F(X11) || X11 <- CollectList],
													GoodsStr = string:join(NoticeInfoList, ", "),
													notice_lib:send_notice(0, ?NOTICE_HJBX, [ObjName, GoodsStr]);
												_ ->
													skip
											end,

											%% 如果是怪物攻城场景，那么删除宝箱数量
											SceneState2 = case SceneState1#scene_state.scene_id == ?SCENEID_MONSTER_ATK of
															  true ->
																  instance_attack_city_lib:delete_box_num(SceneState1, 1);
															  false ->
																  SceneState1
														  end,
											#scene_obj_state{
												monster_id = MonsterId,
												refresh_interval = RefreshInterval,
												refresh_location = RefreshLocation,
												area_flag = AreaFlag
											} = CollectObjState,

											%% 开始定时刷出新怪
											NewSceneState =
												case RefreshInterval >= 0 andalso util_data:is_null(AreaFlag) of
													true ->
														next_create_monster(SceneState2, ObjId, MonsterId, RefreshInterval, RefreshLocation);
													_ ->
														SceneState2
												end,


											case not util_data:is_null(AreaFlag) of
												true ->
													NewSceneState1 = scene_base_lib:delete_obj_from_monster_area(NewSceneState, AreaFlag, ObjId),
													{ok, NewSceneState1};
												_ ->
													{ok, NewSceneState}
											end;
										Reply ->
											Reply
									end;
								false ->
									{fail, ?ERR_PLAYER_BAG_NOT_ENOUGH}
							end;
						_ ->
							{fail, ?ERR_COMMON_FAIL}
					end;
				_ ->
					{fail, ?ERR_COMMON_FAIL}
			end;
		_ ->
			{fail, ?ERR_COMMON_FAIL}
	end.

rand_drop([], _Career, DropList) ->
	DropList;
rand_drop([{CareerLimit, DropWeightList, List} | T], Career, DropList) ->
	case CareerLimit == 0 orelse CareerLimit == Career of
		true ->
			List1 = [{{GoodsId, IsBind, Num}, Rate} || {GoodsId, IsBind, Num, Rate} <- List],
			DropNum = util_rand:weight_rand_ex(DropWeightList),
			DropList1 =
				case DropNum > 0 of
					true ->
						[util_rand:weight_rand_ex(List1) || _N <- lists:seq(1, DropNum)];
					_ ->
						[]
				end,
			rand_drop(T, Career, DropList1 ++ DropList);
		_ ->
			rand_drop(T, Career, DropList)
	end.

%% 移除对象
remove_obj(ScenePid, ObjType, ObjId) ->
	gen_server2:apply_async(ScenePid, {?MODULE, do_remove_obj, [ObjType, ObjId, ?LEAVE_SCENE_TYPE_INITIATIVE]}).

%% 移除对象
remove_obj(ScenePid, ObjType, ObjId, LeaveType) ->
	gen_server2:apply_async(ScenePid, {?MODULE, do_remove_obj, [ObjType, ObjId, LeaveType]}).

%% 移除对象
do_remove_obj(SceneState, ObjType, ObjId, LeaveType) ->
	%% 删除玩家的在场景进程中的信息
	case ObjType =:= ?OBJ_TYPE_PLAYER of
		true ->
			ScenePid = self(),
			case ets:lookup(?ETS_SCENE, ScenePid) of
				[EtsScene] ->
					case LeaveType of
						?LEAVE_SCENE_TYPE_INITIATIVE ->
							NewPlayerList = lists:delete(ObjId, EtsScene#ets_scene.player_list),
							ets:update_element(?ETS_SCENE, ScenePid, {#ets_scene.player_list, NewPlayerList});
						_ ->
							skip
					end,
					ok;
				_ ->
					skip
			end;
		_ ->
			skip
	end,
	?INFO("~p remove obj: ~p, ~p", [self(), SceneState#scene_state.scene_id, {ObjType, ObjId}]),
	%% 通知其他玩家该玩家离开场景
	case scene_base_lib:get_scene_obj_state(SceneState, ObjType, ObjId) of
		#scene_obj_state{} = ObjState ->
			SceneConf = scene_config:get(SceneState#scene_state.scene_id),
			ObjList = scene_base_lib:do_get_screen_biont(SceneState, ObjType, ObjId, false),
			SceneState1 = scene_base_lib:erase_scene_obj_state(SceneState, ObjState),
			%% 通知同屏玩家移除对象
			scene_send_lib:send_leave_screen(ObjList, ObjState, false),
			case ObjType == ?OBJ_TYPE_PLAYER andalso SceneConf#scene_conf.type == ?SCENE_TYPE_INSTANCE of
				true ->
					%% 如果移除对象是玩家，并且是副本场景，触发玩家退出事件
					instance_base_lib:on_player_exit(SceneState1, ObjState, LeaveType);
				_ ->
					{ok, SceneState1}
			end;
		_ ->
			{ok, SceneState}
	end.

%% 被诱惑
be_tempt(ScenePid, ObjType, ObjId) ->
	gen_server2:apply_async(ScenePid, {?MODULE, do_be_tempt, [ObjType, ObjId]}).

%% 被诱惑
do_be_tempt(SceneState, ObjType, ObjId) ->
	case scene_base_lib:get_scene_obj_state(SceneState, ObjType, ObjId) of
		#scene_obj_state{} = ObjState ->
			%% 执行对象移除逻辑，已经对象刷新逻辑
			case do_remove_obj(SceneState, ObjType, ObjId, ?LEAVE_SCENE_TYPE_INITIATIVE) of
				{ok, SceneState1} ->
					#scene_obj_state{
						monster_id = MonsterId,
						refresh_interval = RefreshInterval,
						refresh_location = RefreshLocation,
						area_flag = AreaFlag
					} = ObjState,

					SceneState2 =
						case ObjType of
							?OBJ_TYPE_MONSTER ->
								%% 开始定时刷出新怪
								case RefreshInterval >= 0 andalso util_data:is_null(AreaFlag) of
									true ->
										next_create_monster(SceneState1, ObjId, MonsterId, RefreshInterval, RefreshLocation);
									_ ->
										SceneState1
								end;
							_ ->
								SceneState1
						end,

					case not util_data:is_null(AreaFlag) of
						true ->
							NewSceneState = scene_base_lib:delete_obj_from_monster_area(SceneState2, AreaFlag, ObjId),
							{ok, NewSceneState};
						_ ->
							{ok, SceneState2}
					end;
				_ ->
					skip
			end;
		_ ->
			skip
	end.

%% 检查是否可以移动到对应的位置 IsInstant 是否瞬间移动
check_move(ObjState, SceneId, {BX, BY}, {EX, EY}, IsInstant, IsRevive) ->
	case IsInstant orelse IsRevive of
		true ->
			true;
		_ ->
			GridFlag1 = area_lib:get_grid_flag(SceneId, {BX, BY}),
			GridFlag2 = area_lib:get_grid_flag(SceneId, {EX, EY}),
			OldX = ObjState#scene_obj_state.x,
			OldY = ObjState#scene_obj_state.y,
			D = util_math:get_distance({BX, BY}, {OldX, OldY}),
			GridFlag1 /= ?GRID_FLAG_OFF andalso GridFlag2 /= ?GRID_FLAG_OFF andalso D =< 5
	end.

%% 开始移动
start_move(ScenePid, ObjType, ObjId, {BX, BY}, {EX, EY}, Direction) ->
	gen_server2:apply_async(ScenePid, {?MODULE, do_start_move, [ObjType, ObjId, {BX, BY}, {EX, EY}, Direction]}).

do_start_move(SceneState, ObjType, ObjId, {BX, BY}, {EX, EY}, Direction) ->
	case scene_base_lib:get_scene_obj_state(SceneState, ObjType, ObjId) of
		#scene_obj_state{} = ObjState ->
			OldX = ObjState#scene_obj_state.x,
			OldY = ObjState#scene_obj_state.y,
			SceneId = SceneState#scene_state.scene_id,
			case check_move(ObjState, SceneId, {BX, BY}, {EX, EY}, false, false) of
				true ->
					SceneState1 =
						case OldX /= BX orelse OldY /= BY of
							true ->
								case do_move_sync(SceneState, ObjType, ObjId, {BX, BY}, Direction) of
									{ok, _SceneState} ->
										_SceneState;
									_ ->
										SceneState
								end;
							_ ->
								SceneState
						end,

					case {BX, BY} /= {EX, EY} of
						true ->
							Data = make_rep_start_move(ObjType, ObjId, {BX, BY}, {EX, EY}, Direction),

							scene_send_lib_copy:do_send_screen(SceneState1, ObjType, ObjId, false, 11002, Data);
						_ ->
							skip
					end,

					ObjState1 = scene_base_lib:get_scene_obj_state(SceneState1, ObjType, ObjId),
					ObjState2 = ObjState1#scene_obj_state{ex = EX, ey = EY},
					SceneState2 = scene_base_lib:store_scene_obj_state(SceneState1, ObjState2, ObjState),

%% 					case scene_skill_lib:remove_effect_buff(SceneState2, ObjType, ObjId, ?BUFF_EFFECT_INVISIBILITY) of
%% 						{NewSceneState, _} ->
%% 							{ok, NewSceneState};
%% 						_ ->
%% 							{ok, SceneState2}
%% 					end;
					{ok, SceneState2};
				_ ->
					skip
			end;
		_ ->
			skip
	end.

%% 移动同步
move_sync(ScenePid, ObjType, ObjId, {X, Y}, Direction) ->
	gen_server2:apply_async(ScenePid, {?MODULE, do_move_sync, [ObjType, ObjId, {X, Y}, Direction]}).

%% 瞬间移动
instant_move(ScenePid, ObjType, ObjId, {X, Y}, Direction) ->
	gen_server2:apply_async(ScenePid, {?MODULE, do_move_sync, [ObjType, ObjId, {X, Y}, Direction, true]}).

%% 移动同步
do_move_sync(SceneState, ObjType, ObjId, {X, Y}, Direction) ->
	do_move_sync(SceneState, ObjType, ObjId, {X, Y}, Direction, false).
%% 移动同步
do_move_sync(SceneState, ObjType, ObjId, {X, Y}, Direction, IsInstant) ->
	do_move_sync(SceneState, ObjType, ObjId, {X, Y}, Direction, IsInstant, false).
%% 移动同步
do_move_sync(SceneState, ObjType, ObjId, {X, Y}, Direction, IsInstant, IsRevive) ->
	case scene_base_lib:get_scene_obj_state(SceneState, ObjType, ObjId) of
		#scene_obj_state{} = ObjState ->
			SceneId = SceneState#scene_state.scene_id,
			case check_move(ObjState, SceneId, {X, Y}, {X, Y}, IsInstant, IsRevive) of
				true ->
					OldX = ObjState#scene_obj_state.x,
					OldY = ObjState#scene_obj_state.y,

					%% 对象移动出旧区域
					OldAreaId = ObjState#scene_obj_state.area_id,
					AreaId = area_lib:get_area_id({X, Y}, SceneState#scene_state.width, SceneState#scene_state.high),

					NewObj =
						case IsInstant of
							true ->
								ObjState#scene_obj_state{
									direction = Direction,
									x = X,
									y = Y,
									area_id = AreaId,
									ex = X,
									ey = Y
								};
							_ ->
								ObjState#scene_obj_state{
									direction = Direction,
									x = X,
									y = Y,
									area_id = AreaId
								}
						end,
					SceneState1 = scene_base_lib:store_scene_obj_state(SceneState, NewObj, ObjState),

					case OldAreaId /= AreaId orelse util_math:get_distance({OldX, OldY}, {X, Y}) >= 1 of
						true ->
							%% 通知玩家场景更新玩家当前坐标
							case ObjType of
								?OBJ_TYPE_PLAYER ->
									gen_server2:cast(ObjState#scene_obj_state.obj_pid, {move, {X, Y}});
								_ ->
									skip
							end,

							%% 获取旧屏对象
							ObjList1 = scene_base_lib:get_screen_obj_by_point(SceneState1, {OldX, OldY}, [{ObjType, ObjId}]),
							%% 获取新屏对象
							ObjList2 = scene_base_lib:get_screen_obj_by_point(SceneState1, {X, Y}, [{ObjType, ObjId}]),
							%% 离屏对象
							LeaveObjs = ObjList1 -- ObjList2,
							%% 相交屏对象
							IntersectObjs = ObjList1 -- LeaveObjs,
							%% 进屏对象
							EnterObjs = ObjList2 -- IntersectObjs,

							%% 移动同步广播
							scene_send_lib:send_move_sync(IntersectObjs, NewObj, IsRevive),
							%% 离屏广播
							scene_send_lib:send_leave_screen(LeaveObjs, NewObj),
							%% 进屏广播
							scene_send_lib:send_enter_screen(EnterObjs, NewObj, true, IsInstant),
							%% 检测修改怪物ai
							game_obj_lib:set_monster_targer(SceneState1, ObjType, ObjId, ObjList2);
						_ ->
							{ok, SceneState1}
					end;
				_ ->
					ObjList = scene_base_lib:do_get_screen_obj(SceneState, ObjType, ObjId, true),
					scene_send_lib:send_move_sync(ObjList, ObjState, false),
					%% 进屏广播
					EnterObjs = ObjList -- [ObjState],
					scene_send_lib:send_enter_screen(EnterObjs, ObjState, true, IsInstant)
			end;
		_ ->
			skip
	end.
%% 修改对象状态信息
update_obj(ScenePid, ObjType, ObjId, Update, Cause) ->
	gen_server2:apply_async(ScenePid, {?MODULE, do_update_obj, [ObjType, ObjId, Update, Cause]}).
%% 修改对象状态信息
do_update_obj(SceneState, ObjType, ObjId, Update, Cause) ->
	case scene_base_lib:get_scene_obj_state(SceneState, ObjType, ObjId) of
		#scene_obj_state{} = ObjState ->
			ObjState1 = util_tuple:copy_elements(ObjState, Update),
			NewObjState =
				case ObjState1#scene_obj_state.cur_hp > 0 of
					true ->
						ObjState1;
					_ ->
						ObjState1#scene_obj_state{status = ?STATUS_DIE}
				end,
			NewSceneState = scene_base_lib:store_scene_obj_state(SceneState, NewObjState, ObjState),
			case ObjType of
				?OBJ_TYPE_PLAYER ->
					scene_send_lib:send_screen_player_update(SceneState, ObjState, NewObjState, Cause);
				?OBJ_TYPE_PET ->
					scene_send_lib:send_screen_pet_update(SceneState, ObjState, NewObjState);
				_ ->
					skip
			end,
			{ok, NewSceneState};
		_ ->
			skip
	end.
%% 玩家复活
player_revive(PlayerState, ReviveType) ->
	#player_state{
		scene_pid = ScenePid
	} = PlayerState,
	gen_server2:apply_async(ScenePid, {?MODULE, do_player_revive, [PlayerState, ReviveType]}).
%% 玩家复活
do_player_revive(SceneState, PlayerState, ReviveType) ->
	PlayerId = PlayerState#player_state.player_id,
	%% 获取场景玩家列表
	case scene_base_lib:get_scene_obj_state(SceneState, ?OBJ_TYPE_PLAYER, PlayerId) of
		#scene_obj_state{} = ObjState ->
			%% 获取玩家属性
			AttrTotal = ObjState#scene_obj_state.attr_total,
			NewObjState = ObjState#scene_obj_state{
				cur_mp = AttrTotal#attr_base.mp,
				cur_hp = AttrTotal#attr_base.hp,
				status = ?STATUS_ALIVE,
				buff_dict = PlayerState#player_state.buff_dict,
				effect_dict = PlayerState#player_state.effect_dict,
				effect_src_dict = PlayerState#player_state.effect_src_dict
			},
			%% 保存玩家的场景对象
			SceneState1 = scene_base_lib:store_scene_obj_state(SceneState, NewObjState, ObjState),
			NewSceneState =
				case ReviveType of
					?REVIVE_TYPE_INPLACE ->
						?INFO("do_player_revive 222 ~p", [222]),
						ObjList = scene_base_lib:do_get_screen_biont(SceneState1, ?OBJ_TYPE_PLAYER, PlayerId, true),

						%% 发送给自己和别人
						{Data, TempNum} = scene_send_lib:make_rep_obj_enter([NewObjState], {#rep_obj_enter{}, 0}),
						{ok, SceneState2} =
							case TempNum > 0 of
								true ->
									{ok, Bin} = pt:write_cmd(11005, Data),
									Bin1 = pt:pack(11005, Bin),
									scene_send_lib:send_screen_player(ObjList, Bin1),
									game_obj_lib:set_monster_targer(SceneState1, ?OBJ_TYPE_PLAYER, PlayerId, ObjList);
								_ ->
									{ok, SceneState1}
							end,
						SceneState2;
					_ ->
						?INFO("do_player_revive 111 ~p", [111]),
						GuildId = ObjState#scene_obj_state.guild_id,
						%% 如果是在沙巴克，根据占领状态复活到不同坐标点
						{X, Y} = check_point1(SceneState, ?OBJ_TYPE_PLAYER, PlayerId, GuildId, ?CHANGE_SCENE_TYPE_REVIVE),
						case do_move_sync(SceneState1, ?OBJ_TYPE_PLAYER, PlayerId, {X, Y}, NewObjState#scene_obj_state.direction, true, true) of
							{ok, SceneState2} ->
								SceneState2;
							_ ->
								SceneState1
						end
				end,

			{ok, NewSceneState};
		_ ->
			skip
	end.

%% 寻找当前场景存活怪物, 并把某个怪物的坐标点回给前端
find_monster(ScenePid, PlayerId, Socket) ->
	gen_server2:apply_async(ScenePid, {?MODULE, do_find_monster, [PlayerId, Socket]}).
%% 寻找当前场景存活怪物, 并把某个怪物的坐标点回给前端
do_find_monster(SceneState, _PlayerId, Socket) ->
	MonsterList = scene_base_lib:do_get_scene_obj_list(SceneState, ?OBJ_TYPE_MONSTER),
	case MonsterList /= [] of
		true ->
			F = fun(Obj) ->
				Obj#scene_obj_state.cur_hp > 0
			end,
			List1 = lists:filter(F, MonsterList),
			case List1 /= [] of
				true ->
					Monster = util_rand:list_rand(List1),
					Data = #rep_monster_point{
						can_find = 1,
						point = #proto_point{x = Monster#scene_obj_state.x, y = Monster#scene_obj_state.y}
					},
					net_send:send_to_client(Socket, 11021, Data);
				_ ->
					Data = #rep_monster_point{can_find = 0},
					net_send:send_to_client(Socket, 11021, Data)
			end;
		_ ->
			Data = #rep_monster_point{can_find = 0},
			net_send:send_to_client(Socket, 11021, Data)
	end.

update_monster_target(ScenePid, ObjType, ObjId, Target) ->
	gen_server2:apply_async(ScenePid, {?MODULE, do_update_monster_target, [ObjType, ObjId, Target]}).

do_update_monster_target(SceneState, ObjType, ObjId, Target) ->
	case scene_base_lib:get_scene_obj_state(SceneState, ObjType, ObjId) of
		#scene_obj_state{monster_id = MonsterId} = Obj ->
			NewObj = Obj#scene_obj_state{cur_target = Target},
			MonsterConf = monster_config:get(MonsterId),
			case MonsterConf#monster_conf.type of
				?MONSTER_TYPE_BOSS ->
					scene_send_lib:send_monster_update(SceneState, NewObj);
				_ ->
					skip
			end,
			NewSceneState = scene_base_lib:store_scene_obj_state(SceneState, NewObj, Obj),
			{ok, NewSceneState};
		_ ->
			skip
	end.

%% ====================================================================
%% Internal functions
%% ====================================================================
%% 获取一个空的坐标点
find_empty_point(N, SceneState, {area, {X1, Y1}, {X2, Y2}}) ->
	X = util_rand:rand(X1, X2),
	Y = util_rand:rand(Y1, Y2),
	case N >= 10 of
		true ->
			{X, Y};
		_ ->
			case scene_base_lib:get_point_obj(SceneState, {X, Y}) of
				[] ->
					{X, Y};
				_ ->
					find_empty_point(N + 1, SceneState, {area, {X1, Y1}, {X2, Y2}})
			end
	end;
%% 获取一个空的坐标点
find_empty_point(N, SceneState, {point_list, PointList}) ->
	Point = util_rand:list_rand(PointList),
	case N >= 10 of
		true ->
			Point;
		_ ->
			case scene_base_lib:get_point_obj(SceneState, Point) of
				[] ->
					Point;
				_ ->
					find_empty_point(N + 1, SceneState, {point_list, PointList})
			end
	end.
%% 获取掉落物品信息
get_drop_state(SceneState, DropUid) ->
	DropDict = SceneState#scene_state.drop_dict,
	case dict:find(DropUid, DropDict) of
		{ok, DropState} ->
			DropState;
		_ ->
			null
	end.
%% 添加掉落物品信息
add_drop_state(SceneState, DropState) ->
	#scene_drop_state{
		uid = Uid,
		x = X,
		y = Y,
		area_id = AreaId
	} = DropState,

	NewState1 =
		case get_drop_state(SceneState, Uid) of
			#scene_drop_state{} = _OldDropState ->
				SceneState;
			_ ->
				SceneState1 = scene_base_lib:add_obj_to_area(SceneState, AreaId, ?OBJ_TYPE_DROP, Uid),
				add_obj_to_drop_point(SceneState1, {X, Y}, Uid)
		end,

	DropDict = dict:store(Uid, DropState, NewState1#scene_state.drop_dict),
	NewState1#scene_state{drop_dict = DropDict}.
%% 删除掉落物品信息
delete_drop_state(SceneState, DropState) ->
	#scene_drop_state{
		uid = Uid,
		x = X,
		y = Y,
		area_id = AreaId
	} = DropState,

	SceneState1 = scene_base_lib:delete_obj_from_area(SceneState, AreaId, ?OBJ_TYPE_DROP, Uid),
	SceneState2 = delete_obj_from_drop_point(SceneState1, {X, Y}, Uid),

	DropDict = dict:erase(Uid, SceneState2#scene_state.drop_dict),

	NewSceneState = SceneState2#scene_state{drop_dict = DropDict},

	ObjList = scene_base_lib:get_screen_obj_by_point(NewSceneState, {X, Y}, [], [?OBJ_TYPE_PLAYER]),
	%% 离屏广播
	scene_send_lib:send_leave_screen(ObjList, #scene_obj_state{obj_type = ?OBJ_TYPE_DROP, obj_id = Uid}),

	NewSceneState.

get_obj_from_drop_point(SceneState, Point) ->
	DropPointDict = SceneState#scene_state.drop_point_dict,
	case dict:find(Point, DropPointDict) of
		{ok, List} ->
			List;
		_ ->
			[]
	end.

add_obj_to_drop_point(SceneState, Point, Uid) ->
	DropPointDict = SceneState#scene_state.drop_point_dict,
	List = get_obj_from_drop_point(SceneState, Point),
	NewList = util_list:store(Uid, List),
	NewDropPointDict = dict:store(Point, NewList, DropPointDict),
	SceneState#scene_state{drop_point_dict = NewDropPointDict}.

delete_obj_from_drop_point(SceneState, Point, Uid) ->
	DropPointDict = SceneState#scene_state.drop_point_dict,
	List = get_obj_from_drop_point(SceneState, Point),
	NewList = lists:delete(Uid, List),
	NewDropPointDict = dict:store(Point, NewList, DropPointDict),
	SceneState#scene_state{drop_point_dict = NewDropPointDict}.

make_proto_scene_drop(DropUid, GoodsId, X, Y, OwnerId, TeamId, OwnerChangeTime) ->
	#proto_scene_drop{
		obj_flag = #proto_obj_flag{type = ?OBJ_TYPE_DROP, id = DropUid},
		goods_id = GoodsId,
		point = #proto_point{x = X, y = Y},
		player_id = OwnerId,
		time_out = max(OwnerChangeTime - util_date:unixtime(), 0),
		team_id = TeamId
	}.

make_rep_start_move(ObjType, ObjId, {BX, BY}, {EX, EY}, Direction) ->
	#rep_start_move{
		obj_flag = #proto_obj_flag{type = ObjType, id = ObjId},
		begin_point = #proto_point{x = BX, y = BY},
		end_point = #proto_point{x = EX, y = EY},
		direction = Direction
	}.
%% 创建玩家场景对象
player_state_to_obj_state(PlayerState, PlayerPid, X, Y, AreaId) ->
	PlayerId = PlayerState#player_state.player_id,
	ObjState = init_base_info(#scene_obj_state{}, ?OBJ_TYPE_PLAYER, PlayerId, X, Y, X, Y, ?DIRECTION_UP, AreaId),
	ObjState1 = init_biont_info(ObjState, ?OBJ_TYPE_PLAYER, {PlayerState}),
	ObjState2 = init_player_info(ObjState1, PlayerState, PlayerPid),
	ObjState2.
%% 创建怪物场景对象
monster_to_obj_state(MonsterId, SceneId, Uid, X, Y, AreaId, RefreshInterval, RefreshLocation, AreaFlag, GoOutTime) ->
	MonsterConf = monster_config:get(MonsterId),
	Dire =
		%% 所有不动怪物的朝向默认为右边
	case MonsterConf#monster_conf.attack_type == ?ATTACK_TYPE_STATIC_2 orelse
		MonsterConf#monster_conf.attack_type == ?ATTACK_TYPE_STATIC of
		true ->
			util_rand:rand(?DIRECTION_RIGHT, ?DIRECTION_RIGHT);
		false ->
			util_rand:rand(?DIRECTION_UP, ?DIRECTION_UP_LEFT)
	end,
	ObjState = init_base_info(#scene_obj_state{}, ?OBJ_TYPE_MONSTER, Uid, X, Y, X, Y, Dire, AreaId),
	ObjState1 = init_biont_info(ObjState, ?OBJ_TYPE_MONSTER, {MonsterId, SceneId}),
	ObjState2 = init_ai_info(ObjState1, ?OBJ_TYPE_MONSTER, MonsterId),
	ObjState3 = init_monster_info(ObjState2, SceneId, MonsterId, X, Y, RefreshInterval, RefreshLocation, AreaFlag, GoOutTime),
	ObjState3.
%% 创建宠物场景对象
pet_to_obj_state(Uid, MonsterId, Exp, CurHp, X, Y, AreaId, OwnerState) ->
	ObjState = init_base_info(#scene_obj_state{}, ?OBJ_TYPE_PET, Uid, X, Y, X, Y, ?DIRECTION_UP, AreaId),
	ObjState1 = init_biont_info(ObjState, ?OBJ_TYPE_PET, {MonsterId, CurHp, OwnerState}),
	ObjState2 = init_ai_info(ObjState1, ?OBJ_TYPE_PET, {MonsterId, OwnerState}),
	ObjState3 = init_pet_info(ObjState2, MonsterId, Exp, OwnerState),
	ObjState3.
%% 创建玩家镜像场景对象
image_to_obj_state(PlayerState, X, Y, AreaId) ->
	PlayerId = PlayerState#player_state.player_id,
	ObjState = init_base_info(#scene_obj_state{}, ?OBJ_TYPE_IMAGE, PlayerId, X, Y, X, Y, ?DIRECTION_UP, AreaId),
	ObjState1 = init_biont_info(ObjState, ?OBJ_TYPE_IMAGE, {PlayerState}),
	ObjState2 = init_player_info(ObjState1, PlayerState, null),
	ObjState3 = init_ai_info(ObjState2, ?OBJ_TYPE_IMAGE, PlayerState),
	ObjState3.
%% 创建采集场景对象
collection_to_obj_state(MonsterId, SceneId, Uid, X, Y, AreaId, RefreshInterval, RefreshLocation, AreaFlag, GoOutTime) ->
	Dire = ?DIRECTION_RIGHT,
	ObjState = init_base_info(#scene_obj_state{}, ?OBJ_TYPE_COLLECT, Uid, X, Y, X, Y, Dire, AreaId),
	ObjState1 = init_biont_info(ObjState, ?OBJ_TYPE_MONSTER, {MonsterId, SceneId}),
	ObjState2 = init_ai_info(ObjState1, ?OBJ_TYPE_MONSTER, MonsterId),
	ObjState3 = init_monster_info(ObjState2, SceneId, MonsterId, X, Y, RefreshInterval, RefreshLocation, AreaFlag, GoOutTime),
	ObjState3.

make_skill_dict(SkillRule) ->
	F = fun(L, Acc) ->
		case L of
			{_, _, List} ->
				F1 =
					fun({SkillId, _}, Acc1) ->
						Skill = #db_skill{
							skill_id = SkillId,
							lv = 1,
							next_time = 0
						},
						dict:store(SkillId, Skill, Acc1)
					end,
				lists:foldl(F1, Acc, List);
			{_, _, _, List1, List2} ->
				List3 = [S || {_, _, _, S} <- List1],
				List4 = [S1 || {S1, _} <- List2],
				F2 =
					fun(SkillId, Acc1) ->
						Skill = #db_skill{
							skill_id = SkillId,
							lv = 1,
							next_time = 0
						},
						dict:store(SkillId, Skill, Acc1)
					end,
				lists:foldl(F2, Acc, List3 ++ List4)
		end
	end,
	lists:foldl(F, dict:new(), SkillRule).

init_base_info(ObjState, ObjType, ObjId, X, Y, EX, EY, Dire, AreaId) ->
	ObjState#scene_obj_state{
		%% 基础信息
		obj_type = ObjType, %% 对象类型
		obj_id = ObjId, %% 对象id
		x = X, %% 当前x坐标
		y = Y, %% 当前y坐标
		ex = EX, %% 移动目标点x坐标
		ey = EY, %% 移动目标点y坐标
		direction = Dire, %% 朝向
		area_id = AreaId, %% 区域id
		buff_time = util_date:unixtime() %% buff时间
	}.

init_biont_info(ObjState, ?OBJ_TYPE_PLAYER, {PlayerState}) ->
	DbPlayerBase = PlayerState#player_state.db_player_base,
	DbPlayerAttr = PlayerState#player_state.db_player_attr,
	ObjState#scene_obj_state{
		%% 生物信息
		name = DbPlayerBase#db_player_base.name,
		career = DbPlayerBase#db_player_base.career,
		sex = DbPlayerBase#db_player_base.sex,
		lv = DbPlayerBase#db_player_base.lv,
		cur_hp = DbPlayerAttr#db_player_attr.cur_hp,
		cur_mp = DbPlayerAttr#db_player_attr.cur_mp,
		attr_base = PlayerState#player_state.attr_base,
		attr_total = PlayerState#player_state.attr_total,
		buff_dict = PlayerState#player_state.buff_dict,
		effect_dict = PlayerState#player_state.effect_dict,
		effect_src_dict = PlayerState#player_state.effect_src_dict,
		last_move_time = util_date:unixtime(),
		pass_trigger_skill_list = PlayerState#player_state.pass_trigger_skill_list,
		status = ?STATUS_ALIVE,
		pk_mode = DbPlayerBase#db_player_base.pk_mode,
		vip = DbPlayerBase#db_player_base.vip
	};
init_biont_info(ObjState, ?OBJ_TYPE_PET, {MonsterId, CurHp, OwnerState}) ->
	#scene_obj_state{
		lv = OwnerLv,
		pk_mode = PkMode
	} = OwnerState,
%%     ?ERR("~p", [OwnerLv]),
	MonsterConf = monster_config:get(MonsterId),
	Name = MonsterConf#monster_conf.name ++ "(" ++ util_data:to_list(OwnerState#scene_obj_state.name) ++ ")",
	AttrBase = api_attr:addition_attr(MonsterConf#monster_conf.attr_base, OwnerLv / 100),
	CurHp1 =
		case util_data:is_null(CurHp) of
			true ->
				AttrBase#attr_base.hp;
			_ ->
				CurHp
		end,

	ObjState#scene_obj_state{
		%% 生物信息
		name = Name, %% 名字
		career = MonsterConf#monster_conf.career, %% 职业
		lv = MonsterConf#monster_conf.lv, %% 等级
		cur_hp = CurHp1, %% 当前血量
		cur_mp = AttrBase#attr_base.mp, %% 当前魔法
		attr_base = AttrBase, %% 基础属性
		attr_total = AttrBase, %% 对象总属性
		effect_dict = dict:new(), %% 效果字典
		effect_src_dict = dict:new(), %% 效果来源字典
		buff_dict = dict:new(), %% buff字典
		last_move_time = 0, %% 最后移动时间
		pass_trigger_skill_list = [], %% 被动技能列表
		status = ?STATUS_ALIVE,
		pk_mode = PkMode
	};
init_biont_info(ObjState, ?OBJ_TYPE_MONSTER, {MonsterId}) ->
	MonsterConf = monster_config:get(MonsterId),
	Name = MonsterConf#monster_conf.name,
	AttrBase = MonsterConf#monster_conf.attr_base,
	ObjState#scene_obj_state{
		%% 生物信息
		name = Name, %% 名字
		career = MonsterConf#monster_conf.career, %% 职业
		lv = MonsterConf#monster_conf.lv, %% 等级
		cur_hp = AttrBase#attr_base.hp, %% 当前血量
		cur_mp = AttrBase#attr_base.mp, %% 当前魔法
		attr_base = AttrBase, %% 基础属性
		attr_total = AttrBase, %% 对象总属性
		effect_dict = dict:new(), %% 效果字典
		effect_src_dict = dict:new(), %% 效果来源字典
		buff_dict = dict:new(), %% buff字典
		last_move_time = 0, %% 最后移动时间
		pass_trigger_skill_list = [], %% 被动技能列表
		status = ?STATUS_ALIVE,
		pk_mode = ?PK_MODE_ALL
	};
init_biont_info(ObjState, ?OBJ_TYPE_MONSTER, {MonsterId, SceneId}) ->
	MonsterConf = monster_config:get(MonsterId),
	Name = MonsterConf#monster_conf.name,
	AttrBase = get_monster_attr(MonsterConf, SceneId),
	ObjState#scene_obj_state{
		%% 生物信息
		name = Name, %% 名字
		career = MonsterConf#monster_conf.career, %% 职业
		lv = MonsterConf#monster_conf.lv, %% 等级
		cur_hp = AttrBase#attr_base.hp, %% 当前血量
		cur_mp = AttrBase#attr_base.mp, %% 当前魔法
		attr_base = AttrBase, %% 基础属性
		attr_total = AttrBase, %% 对象总属性
		effect_dict = dict:new(), %% 效果字典
		effect_src_dict = dict:new(), %% 效果来源字典
		buff_dict = dict:new(), %% buff字典
		last_move_time = 0, %% 最后移动时间
		pass_trigger_skill_list = [], %% 被动技能列表
		status = ?STATUS_ALIVE,
		pk_mode = ?PK_MODE_ALL
	};
init_biont_info(ObjState, ?OBJ_TYPE_IMAGE, {PlayerState}) ->
	DbPlayerBase = PlayerState#player_state.db_player_base,
	DbPlayerAttr = PlayerState#player_state.db_player_attr,
	ObjState#scene_obj_state{
		%% 生物信息
		name = DbPlayerBase#db_player_base.name,
		career = DbPlayerBase#db_player_base.career,
		sex = DbPlayerBase#db_player_base.sex,
		lv = DbPlayerBase#db_player_base.lv,
		cur_hp = DbPlayerAttr#db_player_attr.cur_hp,
		cur_mp = DbPlayerAttr#db_player_attr.cur_mp,
		attr_base = PlayerState#player_state.attr_base,
		attr_total = PlayerState#player_state.attr_total,
		buff_dict = PlayerState#player_state.buff_dict,
		effect_dict = PlayerState#player_state.effect_dict,
		effect_src_dict = PlayerState#player_state.effect_src_dict,
		last_move_time = util_date:unixtime(),
		pass_trigger_skill_list = PlayerState#player_state.pass_trigger_skill_list,
		status = ?STATUS_ALIVE,
		pk_mode = ?PK_MODE_ALL
	}.

init_player_info(ObjState, PlayerState, PlayerPid) ->
	DbPlayerBase = PlayerState#player_state.db_player_base,
	PetAttType =
		case DbPlayerBase#db_player_base.pet_att_type of
			?ATTACK_TYPE_PASSIVITY ->
				?ATTACK_TYPE_PASSIVITY;
			_ ->
				?ATTACK_TYPE_INITIATIVE
		end,
	ObjState#scene_obj_state{
		%% 玩家特有信息
		obj_pid = PlayerPid, %% 对象pid
		guise = PlayerState#player_state.guise,
		name_colour = PlayerState#player_state.name_colour,
		fh_cd = DbPlayerBase#db_player_base.fh_cd,
		career_title = PlayerState#player_state.career_title,
		guild_id = DbPlayerBase#db_player_base.guild_id,
		legion_id = DbPlayerBase#db_player_base.legion_id,
		team_id = PlayerState#player_state.team_id,
		leader = PlayerState#player_state.leader,
		pet_dict = PlayerState#player_state.pet_dict,
		pet_att_type = PetAttType,
		server_pass = PlayerState#player_state.server_pass_my,
		server_id = PlayerState#player_state.server_no,
		server_name = PlayerState#player_state.server_name,
		collect_state = 0
	}.

init_monster_info(ObjState, SceneId, MonsterId, BrithX, BrithY, RefreshInterval, RefreshLocation, AreaFlag, GoOutTime) ->
	List =
		case util_data:is_null(BrithX) orelse util_data:is_null(BrithY) of
			true ->
				null;
			_ ->
				case ObjState#scene_obj_state.patrol_range of
					{_, _} ->
						null;
					_ ->
						area_lib:get_round_point_list(SceneId, {BrithX, BrithY}, ObjState#scene_obj_state.patrol_range)
				end
		end,
	%% 怪物离开时间 0 为没有该功能
	GoOutTime1 = case GoOutTime > 0 of
					 true ->
						 util_date:unixtime() + GoOutTime;
					 _ ->
						 0
				 end,
	ObjState#scene_obj_state{
		%% 怪物宠物通用信息
		monster_id = MonsterId, %% 如果是怪物有怪物模板id

		%% 怪物信息
		birth_x = BrithX, %% 出生点x坐标
		birth_y = BrithY, %% 出生点y坐标
		refresh_location = RefreshLocation, %% 刷新区域，只有怪物才有
		refresh_interval = RefreshInterval, %% 刷新间隔，只有怪物才有
		area_flag = AreaFlag, %% 刷怪区标识(只有怪物才有，用于映射对应的刷怪区)
		drop_owner = null,
		warning_info = [], %% 怪物即将预警的信息
		warning_skill_info = [], %% 怪物即将释放的技能信息
		last_skill = 0,
		patrol_list = List,
		go_out_time = GoOutTime1
	}.

init_pet_info(ObjState, MonsterId, Exp, OwnerState) ->
	#scene_obj_state{
		obj_type = OwnerType,
		obj_id = OwnerId,
		obj_pid = OwnerPid,
		guild_id = GuildId,
		team_id = TeamId,
		legion_id = LegionId,
		name_colour = NameColour,
		server_name = Server_Name
	} = OwnerState,

	ObjState#scene_obj_state{
		monster_id = MonsterId, %% 如果是怪物有怪物模板id
		exp = Exp,
		%% 宠物信息
		owner_type = OwnerType,
		owner_id = OwnerId, %% 主人id
		owner_pid = OwnerPid, %% 主人pid
		guild_id = GuildId,
		legion_id = LegionId,
		team_id = TeamId,
		name_colour = NameColour,
		server_name = Server_Name
	}.

init_ai_info(ObjState, ?OBJ_TYPE_MONSTER, MonsterId) ->
	MonsterConf = monster_config:get(MonsterId),
	SkillRule = MonsterConf#monster_conf.skill_rule,
	SkillDict = make_skill_dict(SkillRule),

	CurTime = util_date:longunixtime(),
	NextActionTime = CurTime,
	ObjState#scene_obj_state{
		%% AI信息
		cur_target = null, %% 当前仇恨目标
		attack_type = MonsterConf#monster_conf.attack_type,
		guard_range = MonsterConf#monster_conf.guard_range,
		patrol_range = MonsterConf#monster_conf.patrol_range,
		chase_range = MonsterConf#monster_conf.chase_range,
		walk_range = MonsterConf#monster_conf.walk_range,
		speed = MonsterConf#monster_conf.speed, %% 速度
		patrol_interval = MonsterConf#monster_conf.patrol_interval, %% 巡逻间隔
		patrol_rate = MonsterConf#monster_conf.patrol_rate, %% 巡逻概率
		chase_interval = MonsterConf#monster_conf.chase_interval, %% 追击间隔
		monster_res_id = MonsterConf#monster_conf.resId,
		skill_dict = SkillDict, %% 技能字典(用于存放技能CD等)
		skill_rule = SkillRule, %% 技能释放规则
		last_use_skill_time = 0, %% 最后施法时间(毫秒)
		ai_state = ?AI_STATE_WAIT, %% ai状态
		action_cmd = {ai_action, []}, %% 行动指令
		enmity_dict = dict:new(),
		next_action_time = NextActionTime, %% 下一次行动时间
		public_cd_interval = get_public_cd_interval(?OBJ_TYPE_MONSTER, ?CAREER_ZHANSHI, SkillRule, SkillDict)
	};
init_ai_info(ObjState, ?OBJ_TYPE_PET, {MonsterId, OwnerState}) ->
	MonsterConf = monster_config:get(MonsterId),
	SkillRule = MonsterConf#monster_conf.skill_rule,
	SkillDict = make_skill_dict(SkillRule),

	CurTime = util_date:longunixtime(),
	NextActionTime = CurTime,
	ObjState#scene_obj_state{
		%% AI信息
		cur_target = null, %% 当前仇恨目标
		attack_type = OwnerState#scene_obj_state.pet_att_type,
		guard_range = MonsterConf#monster_conf.guard_range,
		patrol_range = MonsterConf#monster_conf.patrol_range,
		chase_range = MonsterConf#monster_conf.chase_range,
		walk_range = MonsterConf#monster_conf.walk_range,
		speed = MonsterConf#monster_conf.speed, %% 速度
		patrol_interval = MonsterConf#monster_conf.patrol_interval, %% 巡逻间隔
		patrol_rate = MonsterConf#monster_conf.patrol_rate, %% 巡逻概率
		chase_interval = MonsterConf#monster_conf.chase_interval, %% 追击间隔
		skill_dict = SkillDict, %% 技能字典(用于存放技能CD等)
		skill_rule = SkillRule, %% 技能释放规则
		last_use_skill_time = 0, %% 最后施法时间(毫秒)
		ai_state = ?AI_STATE_WAIT, %% ai状态
		action_cmd = {ai_action, []}, %% 行动指令
		enmity_dict = dict:new(),
		next_action_time = NextActionTime, %% 下一次行动时间
		public_cd_interval = get_public_cd_interval(?OBJ_TYPE_PET, ?CAREER_ZHANSHI, SkillRule, SkillDict)
	};
init_ai_info(ObjState, ?OBJ_TYPE_IMAGE, PlayerState) ->
	CurTime = util_date:longunixtime(),
	Interval = 200,
	GuardRange = 30,
	PatrolRange = 30,
	ChaseRange = 30,
	WalkRange = 30,
	Speed = 1,
	PatrolRate = 5000,
	NextActionTime = CurTime + Interval + 5000,
	SkillList = [{SkillId, 10000} || SkillId <- PlayerState#player_state.order_skill_list],
	SkillRule = [{0, 10000, SkillList}],
	SkillDict = PlayerState#player_state.skill_dict,
	ObjState#scene_obj_state{
		%% AI信息
		cur_target = null, %% 当前仇恨目标
		attack_type = ?ATTACK_TYPE_INITIATIVE,
		guard_range = GuardRange,
		patrol_range = PatrolRange,
		chase_range = ChaseRange,
		walk_range = WalkRange,
		speed = Speed, %% 速度
		patrol_interval = {Interval, Interval}, %% 巡逻间隔
		patrol_rate = PatrolRate, %% 巡逻概率
		chase_interval = Interval, %% 追击间隔
		skill_dict = SkillDict, %% 技能字典(用于存放技能CD等)
		skill_rule = SkillRule, %% 技能释放规则
		last_use_skill_time = 0, %% 最后施法时间(毫秒)
		ai_state = ?AI_STATE_WAIT, %% ai状态
		action_cmd = {ai_action, []}, %% 行动指令
		enmity_dict = dict:new(),
		next_action_time = NextActionTime, %% 下一次行动时间
		public_cd_interval = get_public_cd_interval(?OBJ_TYPE_IMAGE, ObjState#scene_obj_state.career, SkillRule, SkillDict)
	}.

get_public_cd_interval(ObjType, Career, SkillRule, SkillDict) ->
	case ObjType =:= ?OBJ_TYPE_PLAYER orelse ObjType =:= ?OBJ_TYPE_IMAGE of
		true ->
			case Career of
				?CAREER_ZHANSHI -> ?MIN_INTERVAL_ZHANSHI;
				?CAREER_FASHI -> ?MIN_INTERVAL_FASHI;
				_ -> ?MIN_INTERVAL_DAOSHI
			end;
		_ ->
			SkillList1 = case SkillRule of
							 [{_MinHp, _MaxHp, SkillList} | _T] ->
								 SkillList;
							 [{_MinHp, _MaxHp, _W, _, SkillList} | _T] ->
								 SkillList
						 end,
			[{SkillId, _Rate} | _TT] = SkillList1,
			{ok, Skill} = dict:find(SkillId, SkillDict),
			SkillConf = skill_config:get({SkillId, Skill#db_skill.lv}),
			SkillConf#skill_conf.cd
	end.

get_monster_attr(MonsterConf, SceneId) ->
	case MonsterConf#monster_conf.is_growth == 1 of
		true ->
			MonsterId = MonsterConf#monster_conf.monster_id,
			KillCount = monster_kills_cache:get_monster_kills_count(MonsterId, SceneId),
			case monster_growth_config:get(KillCount) of
				#monster_growth_conf{} = GrowthConf ->
					GrowthConf#monster_growth_conf.attr_base;
				_ ->
					MonsterConf#monster_conf.attr_base
			end;
		false ->
			MonsterConf#monster_conf.attr_base
	end.

get_refresh_interval(RefreshInterval) ->
	case RefreshInterval of
		{random_type, Rand1, Rand2} ->
			R = util_rand:rand(Rand1, Rand2),
			R;
		Value when is_integer(Value) ->
			Value;
		_ ->
			86400
	end.

%% get_random_monster_id(MonsterId, RandomRefuse) ->
%% 	case util_rand:weight_rand_2(1, RandomRefuse) of
%% 		[MId] ->
%% 			MId;
%% 		_ ->
%% 			MonsterId
%% 	end.

refuse_random_monster(Conf) ->
	[{SceneId, RefuseConf}] = util_rand:weight_rand_2(1, Conf#random_monster_conf.refuse_list),
	case ets:lookup(?ETS_SCENE_MAPS, SceneId) of
		[EtsMap | _] ->
			%% 获取对应1线pid
			case lists:keyfind(1, #pid_line.line_num, EtsMap#ets_scene_maps.pid_list) of
				false ->
					skip;
				R ->
					create_area_monster_from_scene(R#pid_line.pid, RefuseConf)
			end;
		_ ->
			skip
	end.