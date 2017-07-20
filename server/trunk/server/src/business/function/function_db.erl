%%%-------------------------------------------------------------------
%%% @author apple
%%% @copyright (C) 2015, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 30. 十一月 2015 14:11
%%%-------------------------------------------------------------------
-module(function_db).

-include("common.hrl").
-include("cache.hrl").

%% API
-export([
	select_row/1,
	insert/1,
	select_all/0,
	update/2,
	is_open_scene/1
]).

%% ====================================================================
%% API functions
%% ====================================================================

select_row(FunctionId) ->
	case db:select_row(function, record_info(fields, db_function), [{id, FunctionId}]) of
		[] ->
			null;
		List ->
			list_to_tuple([db_function | List])
	end.

select_all() ->
	case db:select_all(function, record_info(fields, db_function), []) of
		[] ->
			[];
		List ->
			[list_to_tuple([db_function | X]) || X <- List]
	end.

update(FunctionId, FunctionInfo) ->
	db:update(function, util_tuple:to_tuple_list(FunctionInfo), [{id, FunctionId}]).

insert(FunctionInfo) ->
	db:insert(function, util_tuple:to_tuple_list(FunctionInfo)).


%% 判断合服场景是否开放
is_open_scene(SceneId) ->
	case scene_merge_config:get(SceneId) of
		null ->
			true;
		FunctionId ->
			case length(config:get_merge_servers()) > 1 of
				true ->
					true;
				_ ->
					case select_row(FunctionId) of
						null ->
							false;
						SceneMergeInfo ->
							Curtime = util_date:unixtime(),
							SceneMergeInfo#db_function.begin_time < Curtime andalso SceneMergeInfo#db_function.end_time > Curtime
					end
			end
	end.

