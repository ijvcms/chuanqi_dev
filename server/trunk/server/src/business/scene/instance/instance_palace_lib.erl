-module(instance_palace_lib).
-author("tim").
%% 变异地宫副本
-include("common.hrl").
-include("record.hrl").
-include("config.hrl").
-include("proto.hrl").
-include("cache.hrl").
-include("notice_config.hrl").

-define(PLAYER_LOGOUT_HOLD_TIME, 300). %% 玩家下线后副本保留时间

-record(instance_palace_state, {
	scene_sign,						%%
	boss_rate,						%% 产生boss概率
	boss_num_cfg,					%% boss刷新次数配置值
	boss_cd_cfg,					%% boss刷新cd配置值
	boss_create_num,      %% boss刷新次数
	boss_create_cd, 			%% boss刷新cd
	rule_monster_list,		%% boss生成规则
	monster_left          %% 还可以选的怪物
}).
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
%% 初始化副本
init(SceneState, PS) ->
	SceneSign = instance_base_lib:get_instance_sign(PS, SceneState#scene_state.scene_id),

	#scene_conf{rule_monster_list = RuleMonsterListExt} = scene_config:get(SceneState#scene_state.scene_id),
	{Rate, Cd, Num, RuleMonsterList} = RuleMonsterListExt,

	InstanceState = #instance_palace_state{
		scene_sign = SceneSign,
		boss_rate = Rate,
		boss_num_cfg = Num,
		boss_cd_cfg = Cd,
		boss_create_num = 0,
		boss_create_cd = 0,
		rule_monster_list = RuleMonsterList,
		monster_left = RuleMonsterList
	},
	spec_palace_boss_mod:init_scene(SceneState#scene_state.scene_id, SceneState#scene_state.end_time),
	SceneState#scene_state{instance_state = InstanceState}.

%% 派生的定时器
on_timer(SceneState) ->
	SceneState.

%% 玩家进入事件
on_obj_enter(SceneState, PlayerState) when is_record(PlayerState, player_state) ->
	log_instance:on_player_enter(SceneState, PlayerState),
	SceneState.

%% 对象死亡事件
on_obj_die(SceneState, DieState, KillerState) ->
	{ok, SceneState1} = calc_boss_num(SceneState, DieState),
	{ok, NewSceneState} = create_boss(SceneState1, DieState, KillerState),
	NewSceneState.

%% 玩家退出事件
on_player_exit(SceneState, ObjState, _LeaveType) ->
	log_instance:on_player_exit(SceneState, ObjState),
	SceneState.

%% 副本结束
instance_end(SceneState) ->
	SceneState.

%% 副本关闭
instance_close(SceneState) ->
	InstanceState = SceneState#scene_state.instance_state,
	SceneSign = InstanceState#instance_palace_state.scene_sign,
	SceneId = SceneState#scene_state.scene_id,
	Key = {SceneId, SceneSign},
	case ets:lookup(?ETS_SCENE_MAPS, Key) of
		[_EtsMaps] ->
			ets:delete(?ETS_SCENE_MAPS, Key);
		_ ->
			skip
	end,
	ets:delete(?ETS_SCENE, self()),
	spec_palace_boss_mod:terminate_scene(SceneState#scene_state.scene_id),
	SceneState.

%% ====================================================================
%% Internal functions
%% ====================================================================
%% 生成boss
create_boss(SceneState, #scene_obj_state{obj_type = ?OBJ_TYPE_MONSTER, monster_id = MonsterId, x=PosX, y=PosY},
		#scene_obj_state{name = KillerName})
	->
	#monster_conf{type=Type} = monster_config:get(MonsterId),
	case Type == ?MONSTER_TYPE_NORMAL orelse Type == ?MONSTER_TYPE_ELITE of
		true ->
			InstanceState = SceneState#scene_state.instance_state,
			#instance_palace_state{
				boss_rate = Rate,
				boss_num_cfg = BossCreateNumCfg,
				boss_cd_cfg = BossCreateCdCfg,
				boss_create_num = BossCreateNum,
				boss_create_cd = BossCreateCd,
				monster_left = MonsterLeft,
				rule_monster_list = RuleMonsterList
			} = InstanceState,
			Now = util_date:unixtime(),
			case BossCreateCd < Now of
				true ->
					case util_rand:rand_hit(Rate) of
						true ->
							MonsterRule = util_erl:get_if(MonsterLeft == [], RuleMonsterList, MonsterLeft),
							{ok, Monster, NewMonsterRule} = choice_monster(MonsterRule),
							{monster_type, BossId, _Count, RefreshInterval, _RefreshLocation} = Monster,
							RefreshLocation = {point_list,[{PosX,PosY}]},
							Rule = {monster_type, BossId, 1, RefreshInterval, RefreshLocation},
							#monster_conf{name=BossName} = monster_config:get(BossId),
							SceneState1 = scene_obj_lib:create_area_monster(SceneState, Rule),
							notice_lib:send_notice(0, ?NOTICE_BYDG, [KillerName, BossName]),
							{NewBossCreateNum, NewBossCreateCd} =
								util_erl:get_if(BossCreateNum + 1 >= BossCreateNumCfg, {0, Now + BossCreateCdCfg}, {BossCreateNum + 1, BossCreateCd}),
							InstanceState2 = InstanceState#instance_palace_state{monster_left =  NewMonsterRule, boss_create_num =
							NewBossCreateNum, boss_create_cd=NewBossCreateCd},
							SceneState1#scene_state{instance_state = InstanceState2};
						false ->
							SceneState
					end;
				false ->
					SceneState
			end;
		false ->
			SceneState
	end;
create_boss(SceneState, _DieState,_KillerState) ->
	SceneState.



%%选择怪物
choice_monster(MonsterRule) ->
	Monster = util_rand:weight_rand_ex(MonsterRule),
	{monster_type, MonsterId, _, _, _} = Monster,
	NewMonsterRule =
		lists:foldl(fun({X, _R}, Acc) ->
			case X of
				{monster_type, MonsterId, _, _, _} -> Acc;
				_ -> [X|Acc]
			end
		end, [], MonsterRule),
	{ok, Monster, NewMonsterRule}.


%% 统计boss
%% 更新击杀数量
calc_boss_num(SceneState, DieState) ->
	#scene_state{scene_id = SceneId}=SceneState,
	#scene_obj_state{obj_type=ObjType, monster_id=MonsterId}=DieState,
	case ObjType of
		?OBJ_TYPE_MONSTER ->
			MonsterConf = monster_config:get(MonsterId),
			case MonsterConf#monster_conf.type of
				?MONSTER_TYPE_BOSS ->
					spec_palace_boss_mod:add_num(SceneId, MonsterId);
				_ -> next
			end;
		_ -> next
	end,
	{ok, SceneState}.


