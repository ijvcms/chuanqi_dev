%%%-------------------------------------------------------------------
%%% @author zhengsiying
%%% @copyright (C) 2015, <COMPANY>
%%% @doc
%%%		场景基础模块
%%% @end
%%% Created : 09. 十一月 2015 下午3:04
%%%-------------------------------------------------------------------
-module(scene_base_lib).

-include("common.hrl").
-include("record.hrl").
-include("config.hrl").
-include("proto.hrl").

-define(TIMER_FRAME, 1000).

%% API
-export([
	init/3,
	init/2,
	filter_point/2,
	get_scene_obj_state/3,
	get_scene_players/1,
	get_scene_obj_list/2,
	get_screen_obj/3,
	get_screen_obj/4,
	get_screen_biont/3,
	get_screen_biont/4,
	get_screen_obj_by_point/2,
	get_screen_obj_by_point/3,
	get_screen_obj_by_point/4,
	store_scene_obj_state/2,
	store_scene_obj_state/3,
	erase_scene_obj_state/2,
	get_area_obj/2,
	add_obj_to_area/4,
	delete_obj_from_area/4,
	get_point_obj/2,
	add_obj_to_point/4,
	delete_obj_from_point/4,
	update_monster_area/3,
	delete_obj_from_monster_area/3,
	put_obstacle_dict/1,
	get_obstacle_dict/0,
	add_obstacle/2,
	delete_obstacle/2,
	add_monster_refresh/6,
	delete_monster_refresh/2,
	add_monster_area/6
]).

%% callbacks
-export([
	do_get_scene_players/1,
	do_get_scene_obj_list/2,
	do_get_screen_obj/4,
	do_get_screen_biont/4,
	on_timer/1,
	init/1
]).

%% ====================================================================
%% API functions
%% ====================================================================
%% 场景初始化
init(SceneId, LineNum) ->
	init(SceneId, null, LineNum).

%% TempLineNum:LineNum or {LineNum, ScenePic}
init(SceneId, PlayerState, TempLineNum) ->
	CurTime = util_date:unixtime(),
	SceneConf = scene_config:get(SceneId),
	MapMod = SceneConf#scene_conf.map_data,
	{Width, High} = MapMod:range(),

	{LineNum, ScenePic} =
		case TempLineNum of
			{TempLineNum1, ScenePic1} ->
				{TempLineNum1, ScenePic1};
			_ ->
				{TempLineNum, 0}
		end,

	SceneState = #scene_state{
		scene_conf = SceneConf,
		scene_id = SceneId,
		width = Width,
		high = High,
		obj_dict = dict:new(),
		area_dict = dict:new(),
		point_dict = dict:new(),
		drop_dict = dict:new(),
		drop_point_dict = dict:new(),
		fire_wall_dict = dict:new(),
		fire_wall_point_dict = dict:new(),
		monster_area_dict = dict:new(),
		monster_refresh_dict = dict:new(),
		cur_uid = util_rand:rand(1000, 100000),
		drop_cur_uid = util_rand:rand(1000, 100000),
		fire_wall_cur_uid = util_rand:rand(1000, 100000),
		activity_status = ?ACTIVITY_STATUS_OFF,
		round = 1,
		send_list_11020 = [],
		send_list_12010 = [],
		line_num = LineNum,
		activity_begintime_endtime = null,
		enter_instance_player_list = [],
		ai_obj_on_time = CurTime,
		scene_pic = ScenePic
	},
	%% 初始化障碍字典
	put_obstacle_dict(dict:new()),
	SceneState1 = init_monster_area(SceneState, SceneConf),
	SceneState2 = scene_obj_lib:create_all_monster(SceneState1, SceneConf),

	SceneState3 =
		case SceneConf#scene_conf.type of
			?SCENE_TYPE_INSTANCE ->
				{ok, _SceneState2} = instance_base_lib:init(SceneState2, PlayerState),
				_SceneState2;
			_ ->
				SceneState2
		end,
	%% 查看场景活动相关信息
	NewSceneState =
		case SceneConf#scene_conf.activity_id /= 0 of
			true ->%% 如果有副本的话，那么启动当前场景活动的初始话
				{ok, SceneState4} = scene_activity_base_lib:init(SceneState3, []),
				SceneState4;
			_ ->
				SceneState3
		end,
	gen_server2:apply_after(?TIMER_FRAME, self(), {?MODULE, on_timer, []}),
	NewSceneState.

init(ScenePId) ->
	gen_server2:apply_after(?TIMER_FRAME, ScenePId, {?MODULE, on_timer, []}).

%% 初始化刷怪区
init_monster_area(SceneState, SceneConf) ->
	MonsterList = SceneConf#scene_conf.monster_list,
	F = fun(RuleInfo, Acc) ->
		case RuleInfo of
			{area_type, AreaFlag, MonsterId, Num, RefreshInterval, RefreshLocation} ->
				add_monster_area(Acc, AreaFlag, MonsterId, Num, RefreshLocation, RefreshInterval);
			_ ->
				Acc
		end
	end,
	lists:foldl(F, SceneState, MonsterList).

%% -------------------------------------------------------------------------------
%% 场景定时器
%% -------------------------------------------------------------------------------
on_timer(SceneState) ->
	try
		%% 判断是否是副本场景
		SceneConf = scene_config:get(SceneState#scene_state.scene_id),
		case SceneConf#scene_conf.copy_num /= 1 of
			true ->
				on_timer2(SceneState, SceneConf);
			_ ->
				on_timer1(SceneState, SceneConf)
		end
	catch
		Err:Info ->
			?ERR("~p ~p ~p ~p", [SceneState#scene_state.scene_id, Err, Info, erlang:get_stacktrace()]),
			gen_server2:apply_after(?TIMER_FRAME, self(), {?MODULE, on_timer, []}),
			{ok, SceneState}
	end.

%% 单线定时器
on_timer1(SceneState, SceneConf) ->

	PlayerList = scene_base_lib:do_get_scene_obj_list(SceneState, [?OBJ_TYPE_PLAYER]),

	NewPlayerList = [X#scene_obj_state.obj_id || X <- PlayerList],
	ets:update_element(?ETS_SCENE, self(), {#ets_scene.player_list, NewPlayerList}),
	%% 判断是否是副本场景
	SceneState1 = scene_obj_lib:check_drop(SceneState), %% 检查掉落，过期掉落
	SceneState2 = scene_skill_lib:check_and_do_fire_wall(SceneState1), %% 检查并触发火墙效果
	SceneState3 = scene_obj_lib:check_refresh_monster(SceneState2), %% 检查并刷新怪物
	%% 判断场景里面是否有玩家如果有触发怪物AI(怪物攻城场景除外)
	SceneState4 =
		case PlayerList == [] andalso SceneState#scene_state.scene_id =/= ?SCENEID_MONSTER_ATK of
			true ->
				SceneState3;
			false ->

				Ftemp = fun(X, AccP1) ->
					case X#scene_obj_state.obj_type =:= ?OBJ_TYPE_PLAYER of
						true ->
							case player_lib:is_online(X#scene_obj_state.obj_id) of
								false ->
									%%AccNew;
									erase_scene_obj_state(AccP1, X);
								_ ->
									AccP1
							end;
						_ ->
							AccP1
					end
				end,
				AccP2 = lists:foldr(Ftemp, SceneState3, PlayerList),

				%% 触发怪物定时器
				ObjList = scene_base_lib:do_get_scene_obj_list(AccP2, [?OBJ_TYPE_MONSTER, ?OBJ_TYPE_PET, ?OBJ_TYPE_IMAGE, ?OBJ_TYPE_COLLECT]),
				F = fun(ObjState, Acc) ->
					#scene_obj_state{
						obj_type = ObjType,
						obj_id = ObjId
					} = ObjState,
					ObjState1 = scene_base_lib:get_scene_obj_state(Acc, ObjType, ObjId),
					case check_ai(ObjState1, PlayerList, SceneConf) of
						true ->
							{Acc1, _} = game_obj_lib:on_timer(Acc, ObjState1),
							Acc1;
						_ ->
							Acc
					end
				end,
				SceneStateTemp = lists:foldl(F, AccP2, ObjList),
				%% 发送组合信息
				SceneStateTemp1 = SceneStateTemp#scene_state{
					send_list_11020 = scene_send_lib_copy:send_lists_11020(SceneStateTemp#scene_state.send_list_11020)
				},
				%% 发送组合信息
				SceneStateTemp1#scene_state{
					send_list_12010 = scene_send_lib_copy:send_lists_12010(SceneStateTemp1#scene_state.send_list_12010)
				}
		end,
	case SceneConf#scene_conf.type of
		?SCENE_TYPE_INSTANCE ->
			%% 触发副本定时器
			case instance_base_lib:on_timer(SceneState4) of
				{ok, NewSceneState} ->
					gen_server2:apply_after(?TIMER_FRAME, self(), {?MODULE, on_timer, []}),
					{ok, NewSceneState};
				{stop, Result, NewSceneState} ->
					{stop, Result, NewSceneState};
				_ ->
					gen_server2:apply_after(?TIMER_FRAME, self(), {?MODULE, on_timer, []}),
					{ok, SceneState4}
			end;
		_ ->
			%% 判断是否是活动场景
			case SceneConf#scene_conf.activity_id /= 0 of
				true ->
					%% 触发活动定时器
					{ok, SceneState5} = scene_activity_base_lib:on_timer(SceneState4),
					gen_server2:apply_after(?TIMER_FRAME, self(), {?MODULE, on_timer, []}),
					{ok, SceneState5};
				_ ->
					gen_server2:apply_after(?TIMER_FRAME, self(), {?MODULE, on_timer, []}),
					{ok, SceneState4}
			end
	end.
%% 多线定时器
on_timer2(SceneState, SceneConf) ->


	PlayerList = scene_base_lib:do_get_scene_obj_list(SceneState, [?OBJ_TYPE_PLAYER]),

	NewPlayerList = [X#scene_obj_state.obj_id || X <- PlayerList],
	ets:update_element(?ETS_SCENE, self(), {#ets_scene.player_list, NewPlayerList}),

	%% 判断是否是副本场景
	SceneState4 = case PlayerList of
					  [] ->
						  SceneState;
					  _ ->
						  SceneState1 = scene_obj_lib:check_drop(SceneState), %% 检查掉落，过期掉落
						  SceneState2 = scene_skill_lib:check_and_do_fire_wall(SceneState1), %% 检查并触发火墙效果
						  SceneState3 = scene_obj_lib:check_refresh_monster(SceneState2), %% 检查并刷新怪物
						  Ftemp = fun(X, AccP1) ->
							  case X#scene_obj_state.obj_type =:= ?OBJ_TYPE_PLAYER of
								  true ->
									  case player_lib:is_online(X#scene_obj_state.obj_id) of
										  false ->
											  %%AccNew;
											  erase_scene_obj_state(AccP1, X);
										  _ ->
											  AccP1
									  end;
								  _ ->
									  AccP1
							  end
						  end,
						  AccP2 = lists:foldr(Ftemp, SceneState3, PlayerList),

						  %% 触发怪物定时器
						  ObjList = scene_base_lib:do_get_scene_obj_list(AccP2, [?OBJ_TYPE_MONSTER, ?OBJ_TYPE_PET, ?OBJ_TYPE_IMAGE, ?OBJ_TYPE_COLLECT]),
						  F = fun(ObjState, Acc) ->
							  #scene_obj_state{
								  obj_type = ObjType,
								  obj_id = ObjId
							  } = ObjState,
							  ObjState1 = scene_base_lib:get_scene_obj_state(Acc, ObjType, ObjId),
							  case check_ai(ObjState1, PlayerList, SceneConf) of
								  true ->
									  {Acc1, _} = game_obj_lib:on_timer(Acc, ObjState1),
									  Acc1;
								  _ ->
									  Acc
							  end
						  end,
						  SceneStateTemp = lists:foldl(F, AccP2, ObjList),
						  %% 发送组合信息
						  SceneStateTemp1 = SceneStateTemp#scene_state{
							  send_list_11020 = scene_send_lib_copy:send_lists_11020(SceneStateTemp#scene_state.send_list_11020)
						  },
						  %% 发送组合信息
						  SceneStateTemp1#scene_state{
							  send_list_12010 = scene_send_lib_copy:send_lists_12010(SceneStateTemp1#scene_state.send_list_12010)
						  }
				  end,
	case SceneConf#scene_conf.type of
		?SCENE_TYPE_INSTANCE ->
			%% 触发副本定时器
			case instance_base_lib:on_timer(SceneState4) of
				{ok, NewSceneState} ->
					gen_server2:apply_after(?TIMER_FRAME, self(), {?MODULE, on_timer, []}),
					{ok, NewSceneState};
				{stop, Result, NewSceneState} ->
					{stop, Result, NewSceneState};
				_ ->
					gen_server2:apply_after(?TIMER_FRAME, self(), {?MODULE, on_timer, []}),
					{ok, SceneState4}
			end;
		_ ->
			%% 判断是否是活动场景
			case SceneConf#scene_conf.activity_id /= 0 of
				true ->
					%% 触发活动定时器
					{ok, SceneState5} = scene_activity_base_lib:on_timer(SceneState4),
					gen_server2:apply_after(?TIMER_FRAME, self(), {?MODULE, on_timer, []}),
					{ok, SceneState5};
				_ ->
					gen_server2:apply_after(?TIMER_FRAME, self(), {?MODULE, on_timer, []}),
					{ok, SceneState4}
			end
	end.


%% 检测怪物周围是否有玩家
check_ai(_MonsterState, _PlayerList, SceneConf) ->
	case SceneConf#scene_conf.scene_id =:= ?SCENEID_MONSTER_ATK of
%% 	case true of
		true ->
			true;
		_ ->
			#scene_obj_state{x = TX, y = TY, obj_type = ObjType} = _MonsterState,
			case ObjType of
				?OBJ_TYPE_MONSTER ->
					F = fun(X) ->
						util_math:check_rectangle({X#scene_obj_state.x, X#scene_obj_state.y}, {TX, TY}, 12, 7)
					end,
					lists:any(F, _PlayerList);
				_ ->
					true
			end
	end.

%% -------------------------------------------------------------------------------
%% 场景区域坐标判断
%% -------------------------------------------------------------------------------
%% 过滤点
filter_point(ScenePid, PointList) when is_pid(ScenePid) ->
	gen_server2:apply_sync(ScenePid, {?MODULE, filter_point, [PointList]});
filter_point(SceneState, PointList) when is_record(SceneState, scene_state) ->
	filter_point(PointList, SceneState, []).

filter_point([], _SceneState, List) ->
	List;
filter_point([Point | T], SceneState, List) ->
	PointDict = SceneState#scene_state.point_dict,
	case dict:find(Point, PointDict) of
		{ok, ObjList} when ObjList /= [] ->
			filter_point(T, SceneState, List);
		_ ->
			filter_point(T, SceneState, [Point | List])
	end.

%% 获取场景对象信息
get_scene_obj_state(ScenePid, ObjType, ObjId) when is_pid(ScenePid) ->
	gen_server2:apply_sync(ScenePid, {?MODULE, get_scene_obj_state, [ObjType, ObjId]});
%% 获取场景对象信息
get_scene_obj_state(SceneState, ObjType, ObjId) when is_record(SceneState, scene_state) ->
	case dict:find(ObjType, SceneState#scene_state.obj_dict) of
		{ok, TypeObjDict} ->
			case dict:find(ObjId, TypeObjDict) of
				{ok, ObjState} ->
					ObjState;
				_ ->
					null
			end;
		_ ->
			null
	end.

%% 获取一个场景内的所有玩家
get_scene_players(ScenePid) ->
	gen_server2:apply_sync(ScenePid, {?MODULE, do_get_scene_players, []}).
%% 获取场景中的 所有玩家
do_get_scene_players(SceneState) ->
	do_get_scene_obj_list(SceneState, ?OBJ_TYPE_PLAYER).

%% 获取场景对应类型对象列表
get_scene_obj_list(ScenePid, ObjType) ->
	gen_server2:apply_sync(ScenePid, {?MODULE, do_get_scene_obj_list, [ObjType]}).

do_get_scene_obj_list(SceneState, ObjType) when is_integer(ObjType) ->
	case dict:find(ObjType, SceneState#scene_state.obj_dict) of
		{ok, Dict} ->
			F = fun(_K, V, Acc) ->
				[V | Acc]
			end,
			dict:fold(F, [], Dict);
		_ ->
			[]
	end;
do_get_scene_obj_list(SceneState, ObjTypeList) when is_list(ObjTypeList) ->
	F = fun(ObjType, Acc) ->
		case dict:find(ObjType, SceneState#scene_state.obj_dict) of
			{ok, Dict} ->
				F1 = fun(_K, V, Acc1) ->
					[V | Acc1]
				end,
				dict:fold(F1, Acc, Dict);
			_ ->
				Acc
		end
	end,
	lists:foldl(F, [], ObjTypeList).

%% 获取同屏所有对象(包括掉落和火墙等非生物)
get_screen_obj(ScenePid, ObjType, ObjId) ->
	gen_server2:apply_sync(ScenePid, {?MODULE, do_get_screen_obj, [ObjType, ObjId, true]}).
get_screen_obj(ScenePid, ObjType, ObjId, IncludeSelf) ->
	gen_server2:apply_sync(ScenePid, {?MODULE, do_get_screen_obj, [ObjType, ObjId, IncludeSelf]}).
%% 获取同屏所有对象(包括掉落和火墙等非生物)
do_get_screen_obj(SceneState, ObjType, ObjId, IncludeSelf) ->
	case get_scene_obj_state(SceneState, ObjType, ObjId) of
		#scene_obj_state{} = ObjState ->
			X = ObjState#scene_obj_state.x,
			Y = ObjState#scene_obj_state.y,
			case IncludeSelf =:= true of
				true ->
					get_screen_obj_by_point(SceneState, {X, Y});
				_ ->
					get_screen_obj_by_point(SceneState, {X, Y}, [{ObjType, ObjId}])
			end;
		_ ->
			[]
	end.

%% 获取同屏生物(只包括人怪物和宠物)
get_screen_biont(ScenePid, ObjType, ObjId) ->
	gen_server2:apply_sync(ScenePid, {?MODULE, do_get_screen_biont, [ObjType, ObjId, true]}).
get_screen_biont(ScenePid, ObjType, ObjId, IncludeSelf) ->
	gen_server2:apply_sync(ScenePid, {?MODULE, do_get_screen_biont, [ObjType, ObjId, IncludeSelf]}).
%% 获取同屏生物(只包括人怪物和宠物)
do_get_screen_biont(SceneState, ObjType, ObjId, IncludeSelf) ->
	case get_scene_obj_state(SceneState, ObjType, ObjId) of
		#scene_obj_state{} = ObjState ->
			X = ObjState#scene_obj_state.x,
			Y = ObjState#scene_obj_state.y,
			case IncludeSelf =:= true of
				true ->
					get_screen_obj_by_point(SceneState, {X, Y}, [], ?BIONT_TYPE);
				_ ->
					get_screen_obj_by_point(SceneState, {X, Y}, [{ObjType, ObjId}], ?BIONT_TYPE)
			end;
		_ ->
			[]
	end.

%% 以坐标(x,y)为中心点获取一屏内所有对象
get_screen_obj_by_point(SceneState, {X, Y}) ->
	get_screen_obj_by_point(SceneState, {X, Y}, [], ?OBJ_ALL_TYPE).

get_screen_obj_by_point(SceneState, {X, Y}, ExcludeList) ->
	get_screen_obj_by_point(SceneState, {X, Y}, ExcludeList, ?OBJ_ALL_TYPE).

%% 以坐标(x,y)为中心点获取一屏内所有对象，并排除ExcludeList列表内的对象
%% ExcludeList格式如：[{obj_type, obj_id}, ...]
get_screen_obj_by_point(SceneState, {X, Y}, ExcludeList, IncludeTypeList) ->
	%% 根据坐标找出相邻区域
	case area_lib:get_screen_area({X, Y}, SceneState#scene_state.width, SceneState#scene_state.high) of
		[] ->
			[];
		AreaList ->
			%% 获取相邻区域所有对象id
			F = fun(AreaId, Acc) ->
				Acc ++ get_area_obj(SceneState, AreaId)
			end,
			List = lists:foldl(F, [], AreaList),

			F1 =
				fun({ObjType1, ObjId1}, Acc) ->
					case lists:member(ObjType1, IncludeTypeList) andalso (not lists:member({ObjType1, ObjId1}, ExcludeList)) of
						true ->
							case to_scene_obj_state(ObjType1, SceneState, ObjId1) of
								#scene_obj_state{x = X1, y = Y1} = ObjState1 ->
									case area_lib:is_in_screen({X, Y}, {X1, Y1}) of
										true ->
											[ObjState1 | Acc];
										_ ->
											Acc
									end;
								_ ->
									Acc
							end;
						_ ->
							Acc
					end
				end,
			lists:foldl(F1, [], List)
	end.

%% 添加对象进场景 保存玩家场景对象
store_scene_obj_state(SceneState, NewObjState, OldState) ->
	case NewObjState /= OldState of
		true ->
			store_scene_obj_state(SceneState, NewObjState);%%
		_ ->
			SceneState
	end.
%% 添加对象进场景 保存玩家场景对象
store_scene_obj_state(SceneState, ObjState) when is_record(ObjState, scene_obj_state) ->
	#scene_obj_state{
		obj_type = ObjType,
		obj_id = ObjId,
		area_id = AreaId,
		x = X,
		y = Y,
		ex = EX,
		ey = EY,
		area_flag = AreaFlag,
		cur_hp = CurHp
	} = ObjState,

	NewState1 =
		case get_scene_obj_state(SceneState, ObjType, ObjId) of
			#scene_obj_state{} = OldObjState ->
				#scene_obj_state{
					area_id = OldAreaId,
					x = OldX,
					y = OldY,
					ex = OldEX,
					ey = OldEY
				} = OldObjState,
				case {X, Y} /= {OldX, OldY} orelse {EX, EY} /= {OldEX, OldEY} of
					true ->
						case ObjType /= ?OBJ_TYPE_PLAYER of
							true ->
								%% 对于非玩家对象，一步走一格是瞬间的事情，结束点则是对象所站的点
								%% 删除旧的障碍点
								scene_base_lib:delete_obstacle({OldX, OldY}, {ObjType, ObjId}),
								scene_base_lib:delete_obstacle({OldEX, OldEY}, {ObjType, ObjId}),
								scene_base_lib:delete_obstacle({X, Y}, {ObjType, ObjId}),
								case CurHp > 0 of
									true ->
										%% 添加新障碍点
										scene_base_lib:add_obstacle({EX, EY}, {ObjType, ObjId});
									_ ->
										%% 如果对象死亡，不能成为障碍点，所以也必须删除障碍点
										scene_base_lib:delete_obstacle({EX, EY}, {ObjType, ObjId})
								end;
							_ ->
								%% 对于玩家对象当前点才是玩家所在的坐标点
								%% 删除旧的障碍点
								scene_base_lib:delete_obstacle({OldX, OldY}, {ObjType, ObjId}),
								scene_base_lib:delete_obstacle({OldEX, OldEY}, {ObjType, ObjId}),
								scene_base_lib:add_obstacle({X, Y}, {ObjType, ObjId})
						end,

						SceneState2 =
							case {X, Y} /= {OldX, OldY} of
								true ->
									%% 删除对象旧坐标点索引
									SceneState1 = delete_obj_from_point(SceneState, {OldX, OldY}, ObjType, ObjId),
									%% 添加对象坐标点索引
									add_obj_to_point(SceneState1, {X, Y}, ObjType, ObjId);
								_ ->
									%% 添加对象坐标点索引
									add_obj_to_point(SceneState, {X, Y}, ObjType, ObjId)
							end,

						SceneState4 =
							case OldAreaId /= AreaId of
								true ->
									%% 删除对象旧区域索引
									SceneState3 = delete_obj_from_area(SceneState2, OldAreaId, ObjType, ObjId),
									%% 添加对象当前区域索引
									add_obj_to_area(SceneState3, AreaId, ObjType, ObjId);
								_ ->
									%% 添加对象当前区域索引
									add_obj_to_area(SceneState2, AreaId, ObjType, ObjId)
							end,
						SceneState4;
					_ ->
						SceneState
				end;
			_ ->
				%% 添加对象坐标点索引
				SceneState1 = add_obj_to_point(SceneState, {X, Y}, ObjType, ObjId),
				%% 添加对象当前区域索引
				SceneState2 = add_obj_to_area(SceneState1, AreaId, ObjType, ObjId),
				case not util_data:is_null(AreaFlag) of
					true ->
						%% 如果有刷怪区标识，添加对象进刷怪区管理
						add_obj_to_monster_area(SceneState2, AreaFlag, ObjId);
					_ ->
						SceneState2
				end
		end,
	%% 添加对象进对象字典
	add_obj_to_dict(NewState1, ObjState);
%% 批量更新对象
store_scene_obj_state(SceneState, UpdateDict) when is_tuple(UpdateDict) ->
	F = fun(_K, V, Acc) ->
		store_scene_obj_state(Acc, V)%%
	end,
	dict:fold(F, SceneState, UpdateDict).

%% 移除对象
erase_scene_obj_state(SceneState, ObjState) ->
	#scene_obj_state{
		obj_type = ObjType,
		obj_id = ObjId,
		x = X,
		y = Y,
		ex = EX,
		ey = EY,
		area_id = AreaId
	} = ObjState,

	%% 移除对象障碍点
	scene_base_lib:delete_obstacle({EX, EY}, {ObjType, ObjId}),
	scene_base_lib:delete_obstacle({X, Y}, {ObjType, ObjId}),

	%% 在对象字典里移除对象
	case dict:find(ObjType, SceneState#scene_state.obj_dict) of
		{ok, TypeObjDict} ->
			#scene_state{
				obj_dict = ObjDict,
				area_dict = AreaDict,
				point_dict = PointDict
			} = SceneState,
			NewTypeObjDict = dict:erase(ObjId, TypeObjDict),
			NewObjDict = dict:store(ObjType, NewTypeObjDict, ObjDict),

			%% 移除对象区域索引
			NewAreaDict =
				case dict:find(AreaId, AreaDict) of
					{ok, ObjFlagList} ->
						dict:store(AreaId, lists:delete({ObjType, ObjId}, ObjFlagList), AreaDict);
					_ ->
						AreaDict
				end,

			%% 移除对象坐标点索引
			NewPointDict =
				case dict:find({X, Y}, PointDict) of
					{ok, ObjFlagList1} ->
						dict:store({X, Y}, lists:delete({ObjType, ObjId}, ObjFlagList1), PointDict);
					_ ->
						PointDict
				end,
			SceneState1 = SceneState#scene_state{
				obj_dict = NewObjDict,
				area_dict = NewAreaDict,
				point_dict = NewPointDict
			},
			SceneState1;
		_ ->
			SceneState
	end.

%% 添加对象进对象字典
add_obj_to_dict(SceneState, ObjState) ->
	#scene_obj_state{
		obj_type = ObjType,
		obj_id = ObjId
	} = ObjState,
	NewTypeObjDict =
		case dict:find(ObjType, SceneState#scene_state.obj_dict) of
			{ok, TypeObjDict} ->
				dict:store(ObjId, ObjState, TypeObjDict);
			_ ->
				dict:store(ObjId, ObjState, dict:new())
		end,
	NewObjDict = dict:store(ObjType, NewTypeObjDict, SceneState#scene_state.obj_dict),
	SceneState#scene_state{obj_dict = NewObjDict}.

%% 更加区域id获得区域对象唯一标识列表
get_area_obj(SceneState, AreaId) ->
	case dict:find(AreaId, SceneState#scene_state.area_dict) of
		{ok, ObjFlagList} ->
			ObjFlagList;
		_ ->
			[]
	end.

%% 添加对象进区域索引字典
add_obj_to_area(SceneState, AreaId, ObjType, ObjId) ->
	OldAreaDict = SceneState#scene_state.area_dict,
	%% 进入新区域添加区域映射
	AreaObjList = get_area_obj(SceneState, AreaId),
	NewAreaObjList = util_list:store({ObjType, ObjId}, AreaObjList),
	NewAreaDict = dict:store(AreaId, NewAreaObjList, OldAreaDict),
	SceneState#scene_state{area_dict = NewAreaDict}.

%% 从区域索引字典删除对象
delete_obj_from_area(SceneState, AreaId, ObjType, ObjId) ->
	%% 离开旧区域删除区域映射
	OldAreaDict = SceneState#scene_state.area_dict,
	AreaObjList = get_area_obj(SceneState, AreaId),
	NewAreaObjList = lists:delete({ObjType, ObjId}, AreaObjList),
	NewAreaDict =
		case NewAreaObjList /= [] of
			true ->
				dict:store(AreaId, NewAreaObjList, OldAreaDict);
			_ ->
				dict:erase(AreaId, OldAreaDict)
		end,
	SceneState#scene_state{area_dict = NewAreaDict}.

%% 根据坐标点获取对象唯一标识列表
get_point_obj(SceneState, Point) ->
	case dict:find(Point, SceneState#scene_state.point_dict) of
		{ok, ObjFlagList} ->
			ObjFlagList;
		_ ->
			[]
	end.

%% 添加对象进坐标点索引字典
add_obj_to_point(SceneState, Point, ObjType, ObjId) ->
	OldPointDict = SceneState#scene_state.point_dict,
	PointObjList = get_point_obj(SceneState, Point),
	NewPointObjList = util_list:store({ObjType, ObjId}, PointObjList),
	NewPointDict = dict:store(Point, NewPointObjList, OldPointDict),
	SceneState#scene_state{point_dict = NewPointDict}.

%% 从坐标点索引字典删除对象索引
delete_obj_from_point(SceneState, Point, ObjType, ObjId) ->
	OldPointDict = SceneState#scene_state.point_dict,
	PointObjList = get_area_obj(SceneState, Point),
	NewPointObjList = lists:delete({ObjType, ObjId}, PointObjList),
	NewPointDict =
		case NewPointObjList /= [] of
			true ->
				dict:store(Point, NewPointObjList, OldPointDict);
			_ ->
				dict:erase(Point, OldPointDict)
		end,
	SceneState#scene_state{point_dict = NewPointDict}.

%% 添加怪物刷怪区管理对象
add_monster_area(SceneState, AreaFlag, MonsterId, Count, RefreshLocation, RefreshInterval) ->
	OldDict = SceneState#scene_state.monster_area_dict,
	State = #monster_area_state{
		area_flag = AreaFlag,
		monster_id = MonsterId,
		count = Count,
		monster_list = [],
		next_refresh_time = util_date:unixtime() + RefreshInterval,
		refresh_location = RefreshLocation,
		refresh_interval = RefreshInterval
	},
	NewDict = dict:store(AreaFlag, State, OldDict),
	SceneState#scene_state{monster_area_dict = NewDict}.

%% 更新怪物刷怪区管理对象
update_monster_area(SceneState, AreaFlag, NextRefreshTime) ->
	case get_monster_area_obj(SceneState, AreaFlag) of
		#monster_area_state{} = Obj ->
			OldDict = SceneState#scene_state.monster_area_dict,
			NewObj = Obj#monster_area_state{next_refresh_time = NextRefreshTime},
			NewDict = dict:store(AreaFlag, NewObj, OldDict),
			SceneState#scene_state{monster_area_dict = NewDict};
		_ ->
			SceneState
	end.

%% 获取怪物刷怪区管理对象
get_monster_area_obj(SceneState, AreaFlag) ->
	case dict:find(AreaFlag, SceneState#scene_state.monster_area_dict) of
		{ok, MonsterAreaState} ->
			MonsterAreaState;
		_ ->
			null
	end.

%% 添加怪物进刷怪区管理对象
add_obj_to_monster_area(SceneState, AreaFlag, ObjId) ->
	case get_monster_area_obj(SceneState, AreaFlag) of
		#monster_area_state{monster_list = List} = Obj ->
			OldDict = SceneState#scene_state.monster_area_dict,
			NewList = util_list:store(ObjId, List),
			NewObj = Obj#monster_area_state{monster_list = NewList},
			NewDict = dict:store(AreaFlag, NewObj, OldDict),
			SceneState#scene_state{monster_area_dict = NewDict};
		_ ->
			SceneState
	end.

%% 在刷怪区管理对象中删除怪物
delete_obj_from_monster_area(SceneState, AreaFlag, ObjId) ->
	case get_monster_area_obj(SceneState, AreaFlag) of
		#monster_area_state{monster_list = List} = Obj ->
			OldDict = SceneState#scene_state.monster_area_dict,
			NewList = lists:delete(ObjId, List),
			NewObj = Obj#monster_area_state{monster_list = NewList},
			NewDict = dict:store(AreaFlag, NewObj, OldDict),
			SceneState#scene_state{monster_area_dict = NewDict};
		_ ->
			SceneState
	end.

put_obstacle_dict(Dict) ->
	put(obstacle_dict, Dict).

get_obstacle_dict() ->
	get(obstacle_dict).

%% 添加障碍点
add_obstacle({X, Y}, {ObjType, ObjId}) ->
	Dict = get_obstacle_dict(),
	NewDict =
		case dict:find({X, Y}, Dict) of
			{ok, ObjList} ->
				ObjList1 = util_list:store({ObjType, ObjId}, ObjList),
				dict:store({X, Y}, ObjList1, Dict);
			_ ->
				dict:store({X, Y}, [{ObjType, ObjId}], Dict)
		end,
	put_obstacle_dict(NewDict).

%% 移除障碍点
delete_obstacle({X, Y}, {ObjType, ObjId}) ->
	Dict = get_obstacle_dict(),
	NewDict =
		case dict:find({X, Y}, Dict) of
			{ok, ObjList} ->
				NewObjList = lists:delete({ObjType, ObjId}, ObjList),
				case NewObjList /= [] of
					true ->
						dict:store({X, Y}, NewObjList, Dict);
					_ ->
						dict:erase({X, Y}, Dict)
				end;
			_ ->
				Dict
		end,
	put_obstacle_dict(NewDict).

%% 添加怪物刷新对象
add_monster_refresh(SceneState, DieObjId, RefreshTime, MonsterId, RefreshInterval, RefreshLocation) ->
	RefDict = SceneState#scene_state.monster_refresh_dict,
	State = #monster_refresh_state{
		die_obj_id = DieObjId,
		monster_id = MonsterId,
		next_refresh_time = RefreshTime,
		refresh_location = RefreshLocation,
		refresh_interval = RefreshInterval
	},
	NewDict = dict:store(DieObjId, State, RefDict),
	SceneState#scene_state{
		monster_refresh_dict = NewDict
	}.

%% 删除怪物刷新对象
delete_monster_refresh(SceneState, DieObjId) ->
	RefDict = SceneState#scene_state.monster_refresh_dict,
	NewDict = dict:erase(DieObjId, RefDict),
	SceneState#scene_state{
		monster_refresh_dict = NewDict
	}.

%% ====================================================================
%% Internal functions
%% ====================================================================
%% 转换为场景对象
to_scene_obj_state(?OBJ_TYPE_DROP, SceneState, ObjId) ->
	case scene_obj_lib:get_drop_state(SceneState, ObjId) of
		#scene_drop_state{} = DropState ->
			X1 = DropState#scene_drop_state.x,
			Y1 = DropState#scene_drop_state.y,
			#scene_obj_state{
				obj_type = ?OBJ_TYPE_DROP,
				goods_id = DropState#scene_drop_state.goods_id,
				obj_id = DropState#scene_drop_state.uid,
				x = X1,
				y = Y1,
				drop_num = DropState#scene_drop_state.num,
				owner_id = DropState#scene_drop_state.owner_id,
				owner_change_time = DropState#scene_drop_state.owner_change_time,
				team_id = DropState#scene_drop_state.team_id
			};
		_ ->
			null
	end;
to_scene_obj_state(?OBJ_TYPE_FIRE_WALL, SceneState, ObjId) ->
	case scene_skill_lib:get_fire_wall_state(SceneState, ObjId) of
		#fire_wall_state{} = FireWallState ->
			X1 = FireWallState#fire_wall_state.x,
			Y1 = FireWallState#fire_wall_state.y,
			#scene_obj_state{
				obj_type = ?OBJ_TYPE_FIRE_WALL,
				obj_id = FireWallState#fire_wall_state.uid,
				x = X1,
				y = Y1
			};
		_ ->
			null
	end;
to_scene_obj_state(ObjType, SceneState, ObjId) ->
	case get_scene_obj_state(SceneState, ObjType, ObjId) of
		#scene_obj_state{} = ObjState ->
			ObjState;
		_ ->
			null
	end.
