%%%-------------------------------------------------------------------
%%% @author qhb
%%% @copyright (C) 2016, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 27. 六月 2016 下午7:21
%%%-------------------------------------------------------------------
-module(log_data).
-define(ETS_LOG_TEMP_DATA, ets_log_temp_data).

%% API
-export([
	monster_harm_time_new/3,
	monster_harm_time_get/2,
	monster_harm_time_delete/2,
	instance_enter_time_put/2,
	instance_enter_time_get/2,
	instance_enter_time_delete/2,
	instance_enter_time_key/2
]).

%% GEN API
-export([
	init_local/0
]).

init_local() ->
	ets:new(?ETS_LOG_TEMP_DATA, [named_table, public, set]),
	ok.

%%保存怪物第一次伤害时间
monster_harm_time_new(SceneId, MonsterId, Time) ->
	Key = monster_harm_time_key(SceneId, MonsterId),
	case ets:member(?ETS_LOG_TEMP_DATA, Key) of
		true ->
			skip;
		false ->
			ets:insert(?ETS_LOG_TEMP_DATA, {Key, Time})
	end.

monster_harm_time_get(SceneId, MonsterId) ->
	Key = monster_harm_time_key(SceneId, MonsterId),
	case ets:lookup(?ETS_LOG_TEMP_DATA, Key) of
		[{_, T}] -> T;
		_ -> 0
	end.

monster_harm_time_delete(SceneId, MonsterId) ->
	Key = monster_harm_time_key(SceneId, MonsterId),
	ets:delete(?ETS_LOG_TEMP_DATA, Key).

monster_harm_time_key(SceneId, MonsterId) ->
	{log_monster_key, SceneId, MonsterId}.

%%副本进入时间
instance_enter_time_put(PlayerId, SceneId) ->
	Key = instance_enter_time_key(PlayerId, SceneId),
	ets:insert(?ETS_LOG_TEMP_DATA, {Key, util_date:unixtime()}).

instance_enter_time_get(PlayerId, SceneId) ->
	Key = instance_enter_time_key(PlayerId, SceneId),
	case ets:lookup(?ETS_LOG_TEMP_DATA, Key) of
		[{_, T}] -> T;
		_ -> 0
	end.

instance_enter_time_delete(PlayerId, SceneId) ->
	Key = instance_enter_time_key(PlayerId, SceneId),
	ets:delete(?ETS_LOG_TEMP_DATA, Key).

instance_enter_time_key(PlayerId, SceneId) ->
	{log_instance_enter_time_key, PlayerId, SceneId}.