%%%-------------------------------------------------------------------
%%% @author tuhujia
%%% @copyright (C) 2016, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 07. 七月 2016 09:51
%%%-------------------------------------------------------------------
-module(player_operate_record_cache).

-include("common.hrl").
-include("cache.hrl").
-include("record.hrl").

%% API
-export([
	select_all/1,
	select_row/3,
	replace/1,
	delete/3,
	remove_cache/3,
	get_info/4,
	update_info/4,
	update_info_by_value/5,
	update_info_by_count/5,
	update_info_by_every_day/4
]).

%% ====================================================================
%% API functions
%% ====================================================================
select_all(PlayerId) ->
	db_cache_lib:select_all(?DB_PLAYER_OPERATE_RECORD, {PlayerId, '_', '_'}).

select_row(PlayerId, ActiveId, Type) ->
	db_cache_lib:select_row(?DB_PLAYER_OPERATE_RECORD, {PlayerId, ActiveId, Type}).

replace(Info) ->
	PlayerId = Info#db_player_operate_record.player_id,
	ActiveId = Info#db_player_operate_record.active_id,
	Type = Info#db_player_operate_record.finish_limit_type,
	db_cache_lib:replace(?DB_PLAYER_OPERATE_RECORD, {PlayerId, ActiveId, Type}, Info).

delete(PlayerId, ActiveId, Type) ->
	db_cache_lib:delete(?DB_PLAYER_OPERATE_RECORD, {PlayerId, ActiveId, Type}).

remove_cache(PlayerId, ActiveId, Type) ->
	db_cache_lib:remove_cache(?DB_PLAYER_OPERATE_RECORD, {PlayerId, ActiveId, Type}).

%% ====================================================================
%%
%% ====================================================================

get_info(PlayerId, Id, LimitType, FinishType) ->
	CurTime = util_date:unixtime(),
	case select_row(PlayerId, Id, LimitType) of
		null ->
			R = #db_player_operate_record{
				player_id = PlayerId, %% 玩家id
				active_id = Id, %% 活动编号
				finish_limit_type = LimitType, %% 完成条件类型
				finish_limit_value = 0, %% 完成条件参数
				update_time = CurTime %% 更新时间
			},
			replace(R),
			R;
		Info ->
			case FinishType of
				1 ->  %% 活动期间内每天
					case util_date:get_today_unixtime() >= Info#db_player_operate_record.update_time of
						true -> %% 重置今天次数
							Info1 = Info#db_player_operate_record{
								finish_limit_value = 0,
								update_time = CurTime %% 更新时间
							},
							replace(Info1),
							Info1;
						false ->
							Info
					end;
				_ ->  %% 活动期间内
					Info
			end
	end.

update_info(PlayerId, Id, LimitType, FinishType) ->
	CurTime = util_date:unixtime(),
	Info = get_info(PlayerId, Id, LimitType, FinishType),
	NewInfo = Info#db_player_operate_record{
		finish_limit_value = Info#db_player_operate_record.finish_limit_value + 1,
		update_time = CurTime %% 更新时间
	},
	replace(NewInfo),
	NewInfo.

%% 每天更新一次的方法(例如用来纪录登陆次数)
update_info_by_every_day(PlayerId, Id, LimitType, FinishType) ->
	CurTime = util_date:unixtime(),
	Info = get_info(PlayerId, Id, LimitType, FinishType),
	Value = Info#db_player_operate_record.finish_limit_value,
	case util_date:get_today_unixtime() >= CurTime of
		true ->
			NewInfo = Info#db_player_operate_record{
				finish_limit_value = Value + 1,
				update_time = CurTime %% 更新时间
			},
			replace(NewInfo),
			NewInfo;
		false ->
			case Value == 0 of
				true ->
					NewInfo = Info#db_player_operate_record{
						finish_limit_value = 1,
						update_time = CurTime %% 更新时间
					},
					replace(NewInfo),
					NewInfo;
				false ->
					Info
			end
	end.

update_info_by_value(PlayerId, Id, LimitType, FinishType, Value) ->
	CurTime = util_date:unixtime(),
	Info = get_info(PlayerId, Id, LimitType, FinishType),
	NewInfo = Info#db_player_operate_record{
		finish_limit_value = Value,
		update_time = CurTime %% 更新时间
	},
	replace(NewInfo),
	NewInfo.

update_info_by_count(PlayerId, Id, LimitType, FinishType, Count) ->
	CurTime = util_date:unixtime(),
	Info = get_info(PlayerId, Id, LimitType, FinishType),
	NewInfo = Info#db_player_operate_record{
		finish_limit_value = Info#db_player_operate_record.finish_limit_value + Count,
		update_time = CurTime %% 更新时间
	},
	replace(NewInfo),
	NewInfo.