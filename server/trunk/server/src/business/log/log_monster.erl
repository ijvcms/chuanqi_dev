%%%-------------------------------------------------------------------
%%% @author qhb
%%% @copyright (C) 2016, <COMPANY>
%%% @doc
%%%	记录杀死怪物所用的时间
%%% @end
%%% Created : 17. 六月 2016 下午2:44
%%%-------------------------------------------------------------------
-module(log_monster).
-include("record.hrl").
-include("config.hrl").
-include("db_record.hrl").

-define(SCENE_1, 20007). %%幽暗神殿
-define(BOSS_SCENE_1, [7601,7603,7605,7613,7615,7617,7619]). %%幽暗神殿特殊boss

%% API
-export([
	harm_start_time/2,
	kill/2
]).

%% GEN API
-export([
	kill_local/2
]).

%%伤害开始时间
harm_start_time(MonsterId, SceneState) ->
	SecneId = SceneState#scene_state.scene_id,
	case SecneId of
		?SCENE_1 ->
			case get_monster(MonsterId) =:= 1 of
				true ->
					log_data:monster_harm_time_new(SecneId, MonsterId, util_date:unixtime());
				false ->
					skip
			end;
		_ ->
			case monster_config:get(MonsterId) of
				#monster_conf{type = 3 } ->
					log_data:monster_harm_time_new(SecneId, MonsterId, util_date:unixtime());
				_ ->
					skip
			end
	end.

%%boss死亡时间
kill(MonsterId, SceneState) ->
	dp_lib:cast({?MODULE, kill_local, [MonsterId, SceneState]}).
kill_local(MonsterId, SceneState) ->
	#scene_conf{scene_id = SceneId, name = SceneName} = scene_config:get(SceneState#scene_state.scene_id),
	case SceneId of
		?SCENE_1 ->
			case get_monster(MonsterId) =:= 1 of
				true ->
					die_1(MonsterId, SceneId, SceneName);
				false ->
					skip
			end;
		_ ->
			case monster_config:get(MonsterId) of
				#monster_conf{type = 3 } ->
					die_1(MonsterId, SceneId, SceneName);
				_ ->
					skip
			end
	end.

%%%===================================================================
%%% Internal functions
%%%===================================================================
%%记录杀死怪物所用的时间
die_1(MonsterId, SceneId, SceneName) ->
	#monster_conf{name = MonsterName} = monster_config:get(MonsterId),
	BeginTime = log_data:monster_harm_time_get(SceneId, MonsterId),
	Time = util_date:unixtime(),
	cache_log_lib:insert(#db_log_monster_kill{
		monster_id = MonsterId,
		monster_name = MonsterName,
		server_id = config:get_server_no(),
		createtime = Time,
		scene_id = SceneId,
		scene_name = SceneName,
		begin_time = BeginTime,
		duration = Time - BeginTime
	}),

	log_data:monster_harm_time_delete(SceneId, MonsterId).



%%------------------------------------------------------------
%%未知暗殿单独处理
get_monster(7601) -> 1;
get_monster(7603) -> 1;
get_monster(7605) -> 1;
get_monster(7613) -> 1;
get_monster(7615) -> 1;
get_monster(7617) -> 1;
get_monster(7619) -> 1;
get_monster(_MonsterId) -> 0.
