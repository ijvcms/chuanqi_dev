%%%-------------------------------------------------------------------
%%% @author tuhujia
%%% @copyright (C) 2016, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 05. 四月 2016 11:38
%%%-------------------------------------------------------------------
-module(sign_cache).

-include("common.hrl").
-include("cache.hrl").

%% API
-export([
	select_row/1,
	insert/1,
	update/1,
	delete/1,
	remove_cache/2,
	get_player_sign_info/1
]).

%% ====================================================================
%% API functions
%% ====================================================================
select_row(PlayerId) ->
	db_cache_lib:select_row(?DB_PLAYER_SIGN, PlayerId).

insert(Info) ->
	db_cache_lib:insert(?DB_PLAYER_SIGN, Info#db_player_sign.player_id, Info).

update(Info) ->
	db_cache_lib:update(?DB_PLAYER_SIGN, Info#db_player_sign.player_id, Info).

delete(PlayerId) ->
	db_cache_lib:delete(?DB_PLAYER_SIGN, PlayerId).

remove_cache(Id, PlayerId) ->
	db_cache_lib:remove_cache(?DB_PLAYER_SIGN, {Id, PlayerId}).

%% ====================================================================
%%
%% ====================================================================

%% 获取玩家信息
get_player_sign_info(PlayerId) ->
	case sign_cache:select_row(PlayerId) of
		null ->
			{{_, Month, _}, _} = calendar:local_time(),
			Info = #db_player_sign
			{
				player_id = PlayerId, %% 玩家id
				sign_month = Month, %% 签到日期列表
				sign_list = [], %% 签到日期列表
				reward_list = [], %% 签到奖励列表
				count = 0, %% 补签次数
				update_time = util_date:unixtime() %% 更新时间
			},
			insert(Info),
			Info;
		Info ->
			{{_, Month, _}, _} = calendar:local_time(),
			case Month == Info#db_player_sign.sign_month of
				true ->
					sign_lib:check_refuse_sign_list(Info);
				false ->
					NewInfo = Info#db_player_sign
					{
						sign_month = Month, %% 签到日期列表
						sign_list = [], %% 签到日期列表
						reward_list = [], %% 签到奖励列表
						count = 0, %% 补签次数
						update_time = util_date:unixtime() %% 更新时间
					},
					update(NewInfo),
					NewInfo
			end
	end.
