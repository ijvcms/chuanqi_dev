%%%-------------------------------------------------------------------
%%% @author yubing
%%% @copyright (C) 2016, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 06. 一月 2016 15:08
%%%-------------------------------------------------------------------
-module(worship_lib).

-export([get_worship_info/1,
	get_worship_first_career_list/0,
	worship/2,
	ref_worship_first_career_list/0
]).

-include("record.hrl").
-include("cache.hrl").
-include("common.hrl").
-include("proto.hrl").
-include("config.hrl").
-include("gameconfig_config.hrl").
-include("language_config.hrl").
-include("button_tips_config.hrl").
-include("log_type_config.hrl").

%% 获取膜拜信息
get_worship_info(PlayerState) ->
	NoneNum = counter_lib:get_value(PlayerState#player_state.player_id, ?COUNTER_WORSHIP_NONE),
	MaxNoneNum = counter_lib:get_limit(?COUNTER_WORSHIP_NONE),
	JADENum = counter_lib:get_value(PlayerState#player_state.player_id, ?COUNTER_WORSHIP_JADE),
	MaxJadeNum = counter_lib:get_limit(?COUNTER_WORSHIP_JADE),
	#rep_worship_info{
		num = MaxNoneNum - NoneNum,
		jade_num = MaxJadeNum - JADENum
	}.
%% 获取第一名职业列表
get_worship_first_career_list() ->
	CareerFirstList = careertitle_lib:get_ets_list(),
	F = fun(X) ->
		#proto_worship_first_career_info{
			name = X#ets_title_careet.name,
			sex = X#ets_title_careet.sex,
			career = X#ets_title_careet.career,
			fight = X#ets_title_careet.fight,
			player_id = X#ets_title_careet.player_id
		}
	end,
	[F(X) || X <- CareerFirstList].

%% 朝拜
worship(PlayerState, IsJade) ->
	Base = PlayerState#player_state.db_player_base,
	Money = PlayerState#player_state.db_player_money,
	case IsJade =:= 1 of
		true ->
			worship_jade(PlayerState, Base, Money);
		_ ->
			worship_none(PlayerState, Base)
	end.
%% 元宝朝拜
worship_jade(PlayerState, Base, Money) ->
	case Money#db_player_money.jade < ?GAMECONFIG_WORSHIP_JADE of
		true ->
			{ok, PlayerState, ?ERR_PLAYER_JADE_NOT_ENOUGH};
		_ ->
			case worship_goods_config:get(Base#db_player_base.lv) of
				null ->
					{ok, PlayerState, ?ERR_MAIN_TASK1};
				Worship ->
					case counter_lib:check(PlayerState#player_state.player_id, ?COUNTER_WORSHIP_JADE) of
						true ->
							case goods_lib_log:add_goods_list(PlayerState, Worship#worship_goods_conf.jade_goods, ?LOG_TYPE_WORSHOP) of
								{ok, PlayerState1} ->
									{ok, PlayerState2} = player_lib:incval_on_player_money_log(PlayerState1, #db_player_money.jade, -?GAMECONFIG_WORSHIP_JADE, ?LOG_TYPE_WORSHOP),

									counter_lib:update_limit(PlayerState2#player_state.player_id, ?COUNTER_WORSHIP_JADE),

									%% 触发活跃任务
									task_comply:update_player_task_info(PlayerState2, ?TASKSORT_WORSHIP, 1),
									log_lib:log_daily(PlayerState, ?LOG_TYPE_WORSHOP, -?GAMECONFIG_WORSHIP_JADE, ?STATUS_COMPLETE),
									operate_active_lib:update_limit_type(PlayerState, ?OPERATE_ACTIVE_LIMIT_TYPE_7),

									%% 此行必须最后一行 需要返回 状态信息
									{ok, PlayerState2, ?ERR_COMMON_SUCCESS};
								{fail, Err} ->
									{ok, PlayerState, Err};
								_ ->
									{ok, PlayerState, ?ERR_MAIN_TASK1}
							end;
						_ ->
							{ok, PlayerState, ?ERR_MAIN_TASK1}
					end
			end
	end.
%% 免费朝拜
worship_none(PlayerState, Base) ->
	case worship_goods_config:get(Base#db_player_base.lv) of
		null ->
			{ok, PlayerState, ?ERR_MAIN_TASK1};
		Worship ->
			case counter_lib:check(PlayerState#player_state.player_id, ?COUNTER_WORSHIP_NONE) of
				true ->
					case goods_lib_log:add_goods_list(PlayerState, Worship#worship_goods_conf.goods, ?LOG_TYPE_WORSHOP) of
						{ok, PlayerState1} ->
							counter_lib:update_limit(PlayerState#player_state.player_id, ?COUNTER_WORSHIP_NONE),

							%% 刷新免费朝拜红点
							button_tips_lib:ref_button_tips(PlayerState, ?BTN_WORSHIP),
							%% 触发活跃任务
							task_comply:update_player_task_info(PlayerState1, ?TASKSORT_WORSHIP, 1),
							log_lib:log_daily(PlayerState, ?LOG_TYPE_WORSHOP, 0, ?STATUS_COMPLETE),
							operate_active_lib:update_limit_type(PlayerState, ?OPERATE_ACTIVE_LIMIT_TYPE_7),
							%% 此行必须最后一行 需要返回 状态信息
							{ok, PlayerState1, ?ERR_COMMON_SUCCESS};
						{fail, Err} ->
							{ok, PlayerState, Err};
						_ ->
							{ok, PlayerState, ?ERR_MAIN_TASK1}
					end;
				_ ->
					{ok, PlayerState, ?ERR_MAIN_TASK1}
			end
	end.

%% 刷新第一名职业列表
ref_worship_first_career_list() ->
	List = get_worship_first_career_list(),
	net_send:send_to_world(27000, #rep_worship_frist_career_list{worship_frist_career_list = List}).
