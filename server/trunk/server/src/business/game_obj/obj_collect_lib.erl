%%%-------------------------------------------------------------------
%%% @author tuhujia
%%% @copyright (C) 2016, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 29. 十二月 2016 11:38
%%%-------------------------------------------------------------------
-module(obj_collect_lib).

-include("common.hrl").
-include("record.hrl").
-include("proto.hrl").
-include("config.hrl").
-include("notice_config.hrl").

%% callbacks
-export([
	ai_action/2,
	on_timer/2,
	on_die/3,
	do_move/2,
	do_trigger_skill/2
]).

%% ====================================================================
%% API functions
%% ====================================================================
%% AI行动
ai_action(SceneState, ObjState) ->
	{SceneState, ObjState}.

%% 定时器 内部定时器1秒执行一次
on_timer(SceneState, ObjState) ->
	#scene_obj_state{
		go_out_time = GoOutTime
	} = ObjState,
	{SceneState1, ObjState1} =
		case is_integer(GoOutTime) andalso GoOutTime /= 0 andalso GoOutTime < util_date:unixtime() of
			true ->
				game_obj_lib:on_remove(SceneState, ObjState);
			_ ->
				{SceneState, ObjState}
		end,
	{SceneState1, ObjState1}.

do_move(SceneState, ObjState) ->
	{SceneState, ObjState}.

do_trigger_skill(SceneState, ObjState) ->
	{SceneState, ObjState}.

on_die(SceneState, ObjState, _KillerState) ->
	{SceneState, ObjState}.