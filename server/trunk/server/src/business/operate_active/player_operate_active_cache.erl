%%%-------------------------------------------------------------------
%%% @author tuhujia
%%% @copyright (C) 2016, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 07. 七月 2016 09:52
%%%-------------------------------------------------------------------
-module(player_operate_active_cache).

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
	update_info/4
]).

%% ====================================================================
%% API functions
%% ====================================================================
select_all(PlayerId) ->
	db_cache_lib:select_all(?DB_PLAYER_OPERATE_ACTIVE, {PlayerId, '_'}).

select_row(PlayerId, ActiveId, SubType) ->
	db_cache_lib:select_row(?DB_PLAYER_OPERATE_ACTIVE, {PlayerId, ActiveId, SubType}).

replace(Info) ->
	PlayerId = Info#db_player_operate_active.player_id,
	ActiveId = Info#db_player_operate_active.active_id,
	SubType = Info#db_player_operate_active.sub_type,
	db_cache_lib:replace(?DB_PLAYER_OPERATE_ACTIVE, {PlayerId, ActiveId, SubType}, Info).

delete(PlayerId, ActiveId, SubType) ->
	db_cache_lib:delete(?DB_PLAYER_OPERATE_ACTIVE, {PlayerId, ActiveId, SubType}).

remove_cache(PlayerId, ActiveId, SubType) ->
	db_cache_lib:remove_cache(?DB_PLAYER_OPERATE_ACTIVE, {PlayerId, ActiveId, SubType}).

%% ====================================================================
%%
%% ====================================================================

get_info(PlayerId, Id, SubType, FinishType) ->
	CurTime = util_date:unixtime(),
	case select_row(PlayerId, Id, SubType) of
		null ->
			R = #db_player_operate_active{
				player_id = PlayerId, %% 玩家id
				active_id = Id, %% 活动编号
				sub_type = SubType,
				count = 0,
				update_time = CurTime %% 更新时间
			},
			replace(R),
			R;
		Info ->
			case FinishType of
				1 ->  %% 活动期间内每天
					case util_date:get_today_unixtime() >= Info#db_player_operate_active.update_time of
						true -> %% 重置今天次数
							Info1 = Info#db_player_operate_active{
								count = 0,
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

update_info(PlayerId, Id, SubType, FinishType) ->
	CurTime = util_date:unixtime(),
	Info = get_info(PlayerId, Id, SubType, FinishType),
	NewInfo =
		Info#db_player_operate_active{
			count = Info#db_player_operate_active.count + 1, %% 完成次数
			update_time = CurTime %% 更新时间
		},
	replace(NewInfo),
	NewInfo.
