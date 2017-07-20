%%%-------------------------------------------------------------------
%%% @author tuhujia
%%% @copyright (C) 2015, <COMPANY>
%%% @doc
%%%		排位赛副本场景
%%% @end
%%% Created : 17. 十二月 2015 14:54
%%%-------------------------------------------------------------------
-module(instance_arena_lib).

-include("common.hrl").
-include("record.hrl").
-include("config.hrl").
-include("proto.hrl").
-include("cache.hrl").
-include("log_type_config.hrl").

%% API
-export([
	init/2,
	on_timer/1,
	on_obj_enter/2,
	on_obj_die/3,
	on_player_exit/3,
	instance_end/1,
	instance_close/1
]).

%% ====================================================================
%% API functions
%% ====================================================================
%% 初始化副本场景
init(SceneState, PlayerState) ->
	PlayerBase = PlayerState#player_state.db_player_base,
	NowRank = arena_lib:get_player_arena_rank(PlayerState),
	Extra = [PlayerState#player_state.guise,
			PlayerState#player_state.attr_total,
			PlayerState#player_state.order_skill_list],
	ArenaInfoA = #db_arena_rank{
		player_id = PlayerState#player_state.player_id,
		lv = PlayerBase#db_player_base.lv,
		rank = NowRank,
		name = PlayerBase#db_player_base.name,
		sex = PlayerBase#db_player_base.sex,
		career = PlayerBase#db_player_base.career,
		fighting = PlayerState#player_state.fighting,
		extra = Extra,
		guild_id = PlayerBase#db_player_base.guild_id,
		update_time = util_date:unixtime()
	},

	ArenaInfoB = PlayerState#player_state.scene_parameters,
	%% ArenaInfoB = ArenaInfoA,
	[OldGuise, TB, SkillList] = ArenaInfoB#db_arena_rank.extra,
	Guise = case OldGuise of
				{_, Weapon, Clothes, Wing, Pet} ->
					#guise_state
					{
						weapon = Weapon,
						clothes = Clothes,
						wing = Wing,
						pet = Pet,
						mounts = 0,
						mounts_aura = 0
					};
				{_, Weapon, Clothes, Wing, Pet, _Mounts} ->
					#guise_state
					{
						weapon = Weapon,
						clothes = Clothes,
						wing = Wing,
						pet = Pet,
						mounts = 0,
						mounts_aura = 0
					};
				_ ->
					OldGuise#guise_state{mounts = 0, mounts_aura = 0}
			end,

	TotalBase = case is_record(TB, attr_base) of
					true ->
						TB;
					_ ->
						ListTB = util_data:to_list(TB),
						OldLen = length(util_data:to_list(TB)),
						NewLen = length(util_data:to_list(#attr_base{})),
						Len = NewLen - OldLen,
						list_to_tuple(ListTB ++ lists:duplicate(Len, 0))
				end,

	PlayerId = 10 * ArenaInfoB#db_arena_rank.player_id,
	DbBase = #db_player_base{
		player_id = PlayerId,
		lv = ArenaInfoB#db_arena_rank.lv,
		name = ArenaInfoB#db_arena_rank.name,
		sex = ArenaInfoB#db_arena_rank.sex,
		career = ArenaInfoB#db_arena_rank.career,
		pk_mode = ?PK_MODE_ALL
	},
	AttrBase = #db_player_attr{cur_hp = TotalBase#attr_base.hp, cur_mp = TotalBase#attr_base.mp},

	%% 初始化镜像技能
	Fun = fun(Id, Acc) ->
			S = #db_skill{
				player_id = PlayerId,
				skill_id = Id,
				lv = 1,
				pos = 0,
				auto_set = 0,
				next_time = 0
			},
			NSD = dict:store(Id, S, Acc),
			NSD
	end,
	NSD1 = lists:foldl(Fun, dict:new(), SkillList),

	PlayerState1 = #player_state{
		player_id = PlayerId,
		db_player_base = DbBase#db_player_base{player_id = PlayerId},
		db_player_attr = AttrBase#db_player_attr{player_id = PlayerId},
		attr_base = TotalBase,
		attr_total = TotalBase,
		guise = Guise,
		skill_dict = NSD1,
		buff_dict = dict:new(),
		effect_dict = dict:new(),
		effect_src_dict = dict:new(),
		pass_trigger_skill_list = [],
		order_skill_list = SkillList,
		team_id = 0,%%
		team_pid = 0,
		leader = 0,
		last_use_skill_time = 0,
		pet_dict = dict:new()
	},

	{ok, SceneState1} = scene_obj_lib:create_image(SceneState, PlayerState1, {19, 10}),

	InstanceState = #instance_arena_state{
		player_id = PlayerState#player_state.player_id,
		player_socket = PlayerState#player_state.socket,
		arena_a = ArenaInfoA,
		arena_b = ArenaInfoB
	},

	SceneState1#scene_state{instance_state = InstanceState}.

%% 派生的定时器
on_timer(SceneState) ->
	SceneState.

%% 玩家进入事件
on_obj_enter(SceneState, PlayerState) when is_record(PlayerState, player_state) ->
	SceneState.

%% 对象死亡事件
on_obj_die(SceneState, DieState, _KillerState) ->
	InstanceState = SceneState#scene_state.instance_state,
	case DieState#scene_obj_state.obj_type of
		?OBJ_TYPE_IMAGE ->
			%% 镜像死亡
			arena_lib:challenge_win(InstanceState#instance_arena_state.arena_a, InstanceState#instance_arena_state.arena_b);
		?OBJ_TYPE_PLAYER ->
			%% 玩家死亡
			arena_lib:challenge_lose(InstanceState#instance_arena_state.arena_a, InstanceState#instance_arena_state.arena_b);
		_ ->
			%% 其他东西死亡
			skip
	end,
	NewInstanceState = InstanceState#instance_arena_state{is_send_result = true},
	%% {ok, NewSceneState} = instance_base_lib:instance_close(SceneState#scene_state{instance_state = NewInstanceState}),
	SceneState#scene_state{instance_state = NewInstanceState}.

%% 玩家退出事件
on_player_exit(SceneState, _ObjState, _LeaveType) ->
	InstanceState = SceneState#scene_state.instance_state,
	#instance_arena_state{arena_a = #db_arena_rank{player_id = PlayerId, name = PlayerName}} = InstanceState,
	case InstanceState#instance_arena_state.is_send_result of
		true ->
			log_lib:log_daily(PlayerId, PlayerName, ?LOG_TYPE_ARENA, 0, ?STATUS_COMPLETE);
		_ ->
			log_lib:log_daily(PlayerId, PlayerName, ?LOG_TYPE_ARENA, 0, ?STATUS_COMPLETE_NOT),
			arena_lib:challenge_lose(InstanceState#instance_arena_state.arena_a, InstanceState#instance_arena_state.arena_b)
	end,
	{ok, NewSceneState} = instance_base_lib:instance_close(SceneState),
	NewSceneState.

%% 副本结束事件
instance_end(SceneState) ->
	%% 这里结束意味着挑战失败
	InstanceState = SceneState#scene_state.instance_state,
	case InstanceState#instance_arena_state.is_send_result of
		true ->
			skip;
		_ ->
			arena_lib:challenge_lose(InstanceState#instance_arena_state.arena_a, InstanceState#instance_arena_state.arena_b)
	end,
	ObjList = scene_base_lib:do_get_scene_obj_list(SceneState, [?OBJ_TYPE_MONSTER, ?OBJ_TYPE_IMAGE]),
	F = fun(ObjState, Acc) ->
		#scene_obj_state{
			obj_type = ObjType,
			obj_id = ObjId
		} = ObjState,
		{ok, Acc1} = scene_obj_lib:do_remove_obj(Acc, ObjType, ObjId, ?LEAVE_SCENE_TYPE_INITIATIVE),
		Acc1
	end,
	SceneState1 = lists:foldl(F, SceneState, ObjList),
	NewInstanceState = InstanceState#instance_arena_state{is_send_result = true},
	SceneState1#scene_state{instance_end_state = ?INSTANCE_END_STATE, instance_state = NewInstanceState}.

%% 副本关闭事件
instance_close(SceneState) ->
	SceneState.

%% ====================================================================
%% Internal functions
%% ====================================================================