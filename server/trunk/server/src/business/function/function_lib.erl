%%%-------------------------------------------------------------------
%%% @author yubing
%%% @copyright (C) 2016, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 07. 一月 2016 14:39
%%%-------------------------------------------------------------------
-module(function_lib).

-export([get_function_open_list/2, ref_function_open_list/1, is_function_open/2, get_activity_list/1
	, is_get_active_award/1, is_get_merit_task/1, is_get_worship_none/1, is_get_vip/1, check_function_open/2, check_is_open_time/1,
	open_function_list/2,
	close_function_list/2
]).

-include("cache.hrl").
-include("record.hrl").
-include("common.hrl").
-include("config.hrl").
-include("proto.hrl").
-include("language_config.hrl").
-include("button_tips_config.hrl").

%% 获取玩家已经开启的功能列表信息
get_function_open_list(_PlayerId, PlayerState) ->
	#player_state{db_player_base = Base} = PlayerState,

	%% 验证功能是否开启
	F1 = fun(X) ->
		case check_is_open_time(X) of
			{true, _} ->
				true;
			_ ->
				false
		end
	end,
	%% 等级开启
	FunctionList1 = [X#function_conf.id || X <- function_config:get_list(),
		X#function_conf.lv =< Base#db_player_base.lv,
		X#function_conf.task_id =:= 0,
		check_other_close_function(PlayerState, X) =:= true,
		F1(X),
		X#function_conf.type =:= 0
	],

%% 	io:format("open list : ~p~n", [FunctionList1]),
	%% 任务等级开启
	FunctionList2 = [X#function_conf.id || X <- function_config:get_list(),
		X#function_conf.task_id > 0,
		X#function_conf.lv =< Base#db_player_base.lv,
		player_task_finish_dict:is_exist_task(X#function_conf.task_id),
		X#function_conf.type == 0],

	%% 行会宣战功能按钮检测
	GuildId = Base#db_player_base.guild_id,
	FunctionList3 = check_player_login(GuildId),

	List = FunctionList1 ++ FunctionList2 ++ FunctionList3,
	?INFO("list ~p", [List]),
	List.

%% 升级,任务完成，判断玩家是否有功能开启
ref_function_open_list(PlayerState) ->
	Base = PlayerState#player_state.db_player_base,
	F = fun(X, List) ->
		case check_is_open_time(X) of%%
			{true, _} ->
				case X#function_conf.task_id > 0 of
					true ->
						case player_task_finish_dict:is_exist_task(X#function_conf.task_id) andalso X#function_conf.lv =< Base#db_player_base.lv of
							true ->
								[X#function_conf.id | List];
							_ ->
								List
						end;
					_ ->
						case X#function_conf.lv =< Base#db_player_base.lv of
							true ->
								[X#function_conf.id | List];
							_ ->
								List
						end
				end;
			_ ->
				List
		end
	end,
	%% 踢出已经开启的功能
	NoFunctionList = [X || X <- function_config:get_list(),
		lists:member(X#function_conf.id, PlayerState#player_state.function_open_list) =:= false,
		check_other_close_function(PlayerState, X) =:= true,
		X#function_conf.type == 0],

	%% 获取新开启的功能
	FunctionList = lists:foldl(F, [], NoFunctionList),
	%%?INFO("taskfinish ~p",[player_task_finish_dict:get_player_task_finish_list()]),
	%%?INFO("newfunction ~p",[FunctionList]),
	%%?INFO("newfunction1111 ~p",[PlayerState#player_state.function_open_list ++ FunctionList]),

	case length(FunctionList) > 0 of
		true ->
			%%?INFO("newfunction222 ~p",[FunctionList]),
			net_send:send_to_client(PlayerState#player_state.socket, 28000, #rep_ref_function_open_list{function_open_list = FunctionList}),
			Update = #player_state{
				function_open_list = PlayerState#player_state.function_open_list ++ FunctionList
			},
			%% 修改玩家状态
			{ok, PlayerState1} = player_lib:update_player_state(PlayerState, Update),
			%% 新功能开启检测
			check_function_open(PlayerState1, FunctionList);
		_ ->
			PlayerState
	end.

%% 判断功能是否有开启
is_function_open(PlayerState, FunctionId) ->
	lists:member(FunctionId, PlayerState#player_state.function_open_list).

%% 新功能开启检测
check_function_open(PlayerState, FunctionList) ->
	F = fun(X, {ok, PlayerState1}) ->
		case X of
%% 			?FUNCTION_ID_TASK_ACTIVE ->
%% 				%% 活跃任务
%% 				active_task_lib:check_ref_tasklist(PlayerState1, true,false);
			?FUNCTION_ID_ARENA ->
				%% 排位赛
				button_tips_lib:ref_button_tips(PlayerState1, ?BTN_ARENA);
			?FUNCTION_ID_TASK_MERIT ->
				%% 刷新活跃任务领取红点
				button_tips_lib:ref_button_tips(PlayerState1, ?BTN_TASK_MERIT);
			?FUNCTION_ID_WORSHIP ->
				%% 膜拜
				button_tips_lib:ref_button_tips(PlayerState1, ?BTN_WORSHIP);
			?FUNCTION_ID_INSTANCE_SINGLE ->
				%% 个人副本
				button_tips_lib:ref_button_tips(PlayerState1, ?BTN_INSTANCE_SINGLE);
			?FUNCTION_ID_WELFARE ->
				%% 福利大厅
				button_tips_lib:ref_button_tips(PlayerState1, ?BTN_WELFARE);
			_ ->
				{ok, PlayerState}
		end
	end,
	{ok, PlayerState2} = lists:foldr(F, {ok, PlayerState}, FunctionList),
	PlayerState2.

%% 玩家活动相关信息
get_activity_list(PlayerState) ->
	F = fun(X, List) ->
		case X#activity_list_conf.function_id of
			?FUNCTION_ID_TASK_ACTIVE ->
				Temp = #proto_activity_info{
					activity_id = X#activity_list_conf.id,
					max_num = 100,
					now_num = active_task_lib:get_active_num(PlayerState)
				},
				[Temp | List];
			?FUNCTION_ID_ARENA ->
				%% 已经挑战次数
				HitCount = counter_lib:get_value(PlayerState#player_state.player_id, ?ARENA_CHALLENGE_LIMIT_COUNTER),
				LimitCount = arena_lib:get_arena_num(PlayerState),
				Temp = #proto_activity_info{
					activity_id = X#activity_list_conf.id,
					now_num = HitCount,
					max_num = LimitCount
				},
				[Temp | List];
			?FUNCTION_ID_TASK_MERIT ->
				%% 功勋任务
				Temp = #proto_activity_info{
					activity_id = X#activity_list_conf.id,
					now_num = counter_lib:get_value(PlayerState#player_state.player_id, ?COUNTER_MERIT_TASK_NUM),
					max_num = counter_lib:get_limit(?COUNTER_MERIT_TASK_NUM)
				},
				[Temp | List];
			?FUNCTION_ID_WORSHIP ->
				MaxNum1 = counter_lib:get_limit(?COUNTER_WORSHIP_NONE),%% 免费膜拜次数
				MaxNum2 = counter_lib:get_limit(?COUNTER_WORSHIP_JADE), %% 元宝膜拜次数
				NowNum1 = counter_lib:get_value(PlayerState#player_state.player_id, ?COUNTER_WORSHIP_NONE),
				NowNum2 = counter_lib:get_value(PlayerState#player_state.player_id, ?COUNTER_WORSHIP_JADE),
				Temp = #proto_activity_info{
					activity_id = X#activity_list_conf.id,
					now_num = NowNum1 + NowNum2,
					max_num = MaxNum1 + MaxNum2
				},
				[Temp | List];
			?FUNCTION_ID_TASK_DAY -> %%每日任务
				Temp = #proto_activity_info{
					activity_id = X#activity_list_conf.id,
					now_num = counter_lib:get_value(PlayerState#player_state.player_id, ?COUNTER_DAY_TASK_NUM),
					max_num = counter_lib:get_limit(?COUNTER_DAY_TASK_NUM)
				},
				[Temp | List];
			?FUNCTION_MAP_TASK -> %% 宝图任务
				Temp = #proto_activity_info{
					activity_id = X#activity_list_conf.id,
					now_num = counter_lib:get_value(PlayerState#player_state.player_id, ?COUNTER_MAP_TASK_NUM),
					max_num = counter_lib:get_limit(?COUNTER_MAP_TASK_NUM)
				},
				[Temp | List];
			_ ->
				List
		end
	end,
	lists:foldr(F, [], activity_list_config:get_list_conf()).

%% 额外功能关闭判断
check_other_close_function(PlayerState, FC) ->
	#player_state{db_player_base = Base} = PlayerState,
	PlayerId = Base#db_player_base.player_id,
	case FC#function_conf.id of
		?FUNCTION_ID_RECHARGE ->  %% 首充功能
			counter_lib:check(PlayerId, ?COUNTER_FIRST_CHARGE_BAG);
		?FUNCTION_ID_EVERYDAY_SIGN ->  %% 每日签到
			counter_lib:check(PlayerId, ?COUNTER_EVERYDAY_SIGN_STATE);
		?FUNCTION_ID_PLAY ->  %% 充值功能
			not counter_lib:check(PlayerId, ?COUNTER_FIRST_CHARGE_BAG);
		?FUNCTION_ACTIVE_SERVICE ->%%开服活动
			CurTime = util_date:unixtime(),
			F = fun(X) ->
				{_BeginTime, _EndTime, ShowTime, _} = active_service_lib:get_active_time(X#active_service_type_conf.id),
				ShowTime > CurTime
			end,
			List = [X || X <- active_service_type_config:get_list_conf(), F(X)],
			length(List) > 0;
		?FUNCTION_MERGE_ACTIVE -> %% 合服活动
			CurTime = util_date:unixtime(),
			F = fun(X) ->
				{_BeginTime, _EndTime, ShowTime, _} = active_service_merge_lib:get_active_time(X#active_service_merge_type_conf.id),
				ShowTime > CurTime
			end,
			List = [X || X <- active_service_merge_type_config:get_list_conf(), F(X)],
			length(List) > 0;
		?FUNCTION_SHOP_ONCE ->	%%一生一次
			shop_lib:shop_once_function_check(Base);
		?FUNCTION_SEVEN_SIGN ->
%% 	  128 ->
%% 			io:format("check other close function : ~p~n", [FC#function_conf.id]),
			SignAwardStateList = welfare_active_lib:get_active_info(PlayerState, 1),
%% 			io:format("function seven sign --------: ~p~n",[SignAwardStateList]),
			SignAwardRes =
			lists:foldl(fun(#proto_active_info{state=AwardState}, Acc) ->
				Acc orelse (AwardState =/= 1)
				end, false, SignAwardStateList),
			SignAwardRes;
%% 			true;
		_ ->
			true
	end.
%% 判断功能是否还开启的
check_is_open_time(FunctionConf) ->
	#function_conf{
		begin_time = FBeginTime,
		id = FId,
		end_time = FEndTime
	} = FunctionConf,
	case FBeginTime of
		{BeginAddDay, {BeginH, BeginM}} ->
			CurTime = util_date:unixtime(),
			%% 活动判断
			Result = active_service_merge_lib:get_function(FId, CurTime),
			case Result of
				null ->
					case function_db:select_row(FId) of
						null ->
							{EndAddDay, {EndH, EndM}} = FEndTime,
							{{OpenY, OpenM, OpenD}, {_, _, _}} = config:get_start_time_str(),
							BeginTime = util_date:time_tuple_to_unixtime({{OpenY, OpenM, OpenD}, {BeginH, BeginM, 0}}) + BeginAddDay * ?DAY_TIME_COUNT,
							EndTime = util_date:time_tuple_to_unixtime({{OpenY, OpenM, OpenD}, {EndH, EndM, 0}}) + EndAddDay * ?DAY_TIME_COUNT,
							{BeginTime < CurTime andalso EndTime > CurTime, #db_function{id = FId, group_num = 1, end_time = EndTime, begin_time = BeginTime}};
						FunCtionInfo ->
							BeginTime = FunCtionInfo#db_function.begin_time,
							EndTime = FunCtionInfo#db_function.end_time,
							{BeginTime < CurTime andalso EndTime > CurTime, FunCtionInfo}
					end;
				_ ->
					Result
			end;
		_ ->
			{true, null}
	end.
%% *********************红点提示功能相关

%% 活跃任务是否有可以领取的奖励
is_get_active_award(PlayerState) ->

	case is_function_open(PlayerState, ?FUNCTION_ID_TASK_ACTIVE) of
		true ->
			NowActive = active_task_lib:get_active_num(PlayerState),
			Base = PlayerState#player_state.db_player_base,
			AwardActiveList = Base#db_player_base.task_reward_active,
			TaskAwardList = active_task_lib:taskreward_list(Base#db_player_base.lv),
			F = fun(X, List) ->
				case X#taskreward_conf.need_active > NowActive of
					true ->
						List;
					_ ->
						case lists:member({X#taskreward_conf.need_active}, AwardActiveList) of
							true ->
								List;
							_ ->
								[X | List]
						end
				end
			end,
			MyAwardList = lists:foldl(F, [], TaskAwardList),
			{PlayerState, length(MyAwardList)};
		_ ->
			{PlayerState, 0}
	end.

%% 功勋任务 是否有没有完成的次数
is_get_merit_task(PlayerState) ->
	case is_function_open(PlayerState, ?FUNCTION_ID_TASK_MERIT) of
		true ->
			NowNum = counter_lib:get_value(PlayerState#player_state.player_id, ?COUNTER_MERIT_TASK_NUM),
			MaxNum = counter_lib:get_limit(?COUNTER_MERIT_TASK_NUM),
			{PlayerState, MaxNum - NowNum};
		_ ->
			{PlayerState, 0}
	end.

%% 免费模版次数
is_get_worship_none(PlayerState) ->
	case is_function_open(PlayerState, ?FUNCTION_ID_WORSHIP) of
		true ->
			MaxNum1 = counter_lib:get_limit(?COUNTER_WORSHIP_NONE),%% 免费膜拜次数
			NowNum1 = counter_lib:get_value(PlayerState#player_state.player_id, ?COUNTER_WORSHIP_NONE),
			{PlayerState, MaxNum1 - NowNum1};
		_ ->
			{PlayerState, 0}
	end.


%% vip获取可以领取奖励的次数
is_get_vip(PlayerState) ->
	Base = PlayerState#player_state.db_player_base,
	VipLv = Base#db_player_base.vip,
	case VipLv > 0 of
		true ->
			F = fun(X) ->
				case player_vip_cache:select_row(PlayerState#player_state.player_id, X) of
					null ->
						case VipLv >= X of
							true ->
								true;
							_ ->
								false %%还未达到vip等级
						end;
					_ ->
						false %%已经领取过该vip奖励了
				end
			end,
			VipList = lists:seq(1, VipLv),
			VipLvLits = [X || X <- VipList, F(X) =:= true],
			{PlayerState, length(VipLvLits)};
		_ ->
			{PlayerState, 0}
	end.

%% 添加仇人 提示

%% 新增界面功能按钮
open_function_list(PlayerState, OpenList) ->
	FunctionList = PlayerState#player_state.function_open_list,
	NewFunctionList = OpenList ++ FunctionList,
	net_send:send_to_client(PlayerState#player_state.socket, 28000, #rep_ref_function_open_list{function_open_list = NewFunctionList}),
	PlayerState#player_state{function_open_list = NewFunctionList}.

%% 关闭界面功能按钮
close_function_list(PlayerState, CloseList) ->
	FunctionList = PlayerState#player_state.function_open_list,
	NewFunctionList = FunctionList -- CloseList,
	net_send:send_to_client(PlayerState#player_state.socket, 28002, #rep_ref_function_close_list{function_close_list = CloseList}),
	PlayerState#player_state{function_open_list = NewFunctionList}.

%% 上线检测功能按钮
check_player_login(GuildId) ->
	%% 行会宣战检测
	GuildFunction =
		case guild_challenge_lib:get_challenge_guild_id(GuildId) of
			0 ->
				[];
			_ ->
				[?FUNCTION_GUILD_CHALLENGE]
		end,
	%% 运营活动检测检测
	OperateFunction =
		case operate_active_lib:get_start_active_list() of
			[] ->
				[];
			_ ->
				[?FUNCTION_OPERATE_ACTIVE]
		end,
	%% 节日活动检测检测
	HolidayFunction =
		case operate_active_lib:get_start_holiday_active_list() of
			[] ->
				[];
			_ ->
				[?FUNCTION_HOLIDAY_ACTIVE]
		end,
	GuildFunction ++ OperateFunction ++ HolidayFunction.
