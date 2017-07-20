%%%-------------------------------------------------------------------
%%% @author tuhujia
%%% @copyright (C) 2016, <COMPANY>
%%% @doc 活动副本函数接口
%%%
%%% @end
%%% Created : 02. 三月 2016 15:26
%%%-------------------------------------------------------------------
-module(active_instance_lib).
%%
-include("common.hrl").
-include("record.hrl").
-include("proto.hrl").
-include("cache.hrl").
-include("db_record.hrl").
-include("config.hrl").
-include("uid.hrl").
-include("language_config.hrl").
-include("notice_config.hrl").
-include("button_tips_config.hrl").
-include("spec.hrl").

-define(ACTIVE_ID_WZAD, 10).%%平时本服暗殿
-define(ACTIVE_ID_DRAGON, 32108).%%本服火龙活动
-define(FUNCTION_ID_WZAD1, 50).%%平时本服暗殿
-define(FUNCTION_ID_WZAD2, 62).%%周六本服暗殿
-define(FUNCTION_ID_WZAD_CROSS1, 92).%%平时跨服暗殿
-define(FUNCTION_ID_WZAD_CROSS2, 99).%%周六跨服暗殿
-define(FUNCTION_ID_DRAGON, 111).%%本服火龙功能
-define(FUNCTION_ID_DRAGON_CROSS1, 108).%%跨服火龙功能
%% API
-export([
	enter_active_instance/2,
	get_active_wzad_button_tips/1,
	get_active_tldh_button_tips/1,
	get_active_szww_button_tips/1,
	get_active_gwgc_button_tips/1,
	get_active_double_exp_button_tips/1,
	get_active_gfad_button_tips/1,
	get_active_gfad2_button_tips/1,
	get_active_ad_button_tips/1,
	get_active_ad2_button_tips/1,
	send_active_button_to_all_player/1,
	send_active_button_to_all_player_1/1,
	open_monster_attack_instance/0,
  	is_open_double_exp_active/0,
	is_open_active/1,
	is_open_active_wzad/1,
	check_double_exp/1,
	check_wzad_open/0,
	check_wzad_cross_open/1,
	check_dragon_cross_open/1,
	get_open_active_wzad_time_flag/1
]).

%% ====================================================================
%% API functions
%% ====================================================================

%% 进入活动副本
enter_active_instance(PlayerState, ActiveId) ->
	Result = case active_instance_config:get(ActiveId) of
				 #active_instance_conf{} = ActConf ->
					 InstanceId = ActConf#active_instance_conf.instance_id,
					 case is_open_active(ActiveId) of
						 {ok, TimeStamp} ->
							 case check_enter_time(ActConf) of
								 true ->
									 case ets:lookup(?ETS_SCENE_MAPS, {InstanceId, ?WORLD_ACTIVE_SIGN}) of
										 [_EtsMaps] ->
											 enter_active_instance_1(PlayerState, ActConf, 0);
										 _ ->
											 case ActiveId of
												 ?ACTIVE_ID_MONSTER_ATK -> %% 怪物攻城
													 case scene_activity_palace_lib:is_open() of
														 true ->
															 {fail, ?ERR_ACTIVE_NOT_OPEN};
														 false ->
															 {fail, ?ERR_ACTIVE_GWGC_LIMIT}
													 end;
												 ?ACTIVE_ID_WZAD -> %%平时本服暗殿,前七天,因前端只传一个id过来,故需要自己来判断周六周日
													 case check_wzad_open() of
														 true ->
															 enter_active_instance_1(PlayerState, ActConf, TimeStamp);
														 false ->
															 {fail, ?ERR_ACTIVE_NOT_OPEN}
													 end;
												 ?ACTIVE_ID_DRAGON -> %%平时本服火龙,前七天,因前端只传一个id过来,故需要自己来判断周日
													 case check_dragon_open() of
														 true ->
															 enter_active_instance_1(PlayerState, ActConf, TimeStamp);
														 false ->
															 {fail, ?ERR_ACTIVE_NOT_OPEN}
													 end;
												 _ ->
													 ?ERR("~p", [222]),
													 enter_active_instance_1(PlayerState, ActConf, TimeStamp)
											 end
									 end;
								 false ->
									 case ActiveId of
										 ?ACTIVE_ID_SZWW -> %% 胜者为王活动id
											 {fail, ?ERR_ACTIVE_SZWW_LIMIT};
										 _ ->
											 {fail, ?ERR_ACTIVE_TIME_LIMIT}
									 end
							 end;
						 {fail, Reply} ->
							 {fail, Reply}
					 end;
				 _ ->
					 {fail, ?ERR_COMMON_FAIL}
			 end,
	case Result of
		{ok, _} ->
			case ActiveId of
				32112 ->
					case cross_lib:send_cross_mfc(scene_hjzc_lib, get_hjzc_state, []) of
						true ->
							Result;
						false ->
							{fail, ?ERR_ACTIVE_NOT_OPEN};
						Err ->
							?ERR("~p", [Err]),
							{fail, ?ERR_ACTIVE_NOT_OPEN}
					end;
				?SCENEID_HJZC_DATING ->
					case scene_hjzc_lib:get_hjzc_state() of
						true ->
							Result;
						false ->
							{fail, ?ERR_ACTIVE_NOT_OPEN};
						Err ->
							?ERR("~p", [Err]),
							{fail, ?ERR_ACTIVE_NOT_OPEN}
					end;
				_ ->
					Result
			end;
		_ ->
			Result
	end.



enter_active_instance_1(PlayerState, ActConf, TimeStamp) ->
	InstanceId = ActConf#active_instance_conf.instance_id,
	PlayerState1 = case TimeStamp == 0 of
					   true -> PlayerState#player_state{scene_parameters = 0};
					   false -> PlayerState#player_state{scene_parameters = TimeStamp}
				   end,

	case scene_mgr_lib:change_scene(PlayerState1, self(), InstanceId) of%%
		{ok, PlayerState2} ->
			%% 创建子副本
			SubInsList = ActConf#active_instance_conf.sub_instance_list,
			create_sub_instance(PlayerState2, SubInsList),

			{ok, PlayerState2#player_state{scene_parameters = []}};
		_ ->
			{fail, ?ERR_COMMON_FAIL}
	end.

%% 创建活动的子副本
create_sub_instance(PlayerState, SubInsList) ->
	Fun = fun(SceneId) ->
		case ets:lookup(?ETS_SCENE_MAPS, {SceneId, ?ALL_SERVER_SIGN}) of
			[_EtsMaps] ->
				skip;
			_ ->
				scene_mgr_lib:create_scene(SceneId, PlayerState)
		end
	end,
	[Fun(X) || X <- SubInsList].

%%检查本服暗殿是否开启
check_wzad_open() ->
	case is_open_active_wzad(?ACTIVE_ID_WZAD) of
		{ok, _} ->
			check_wzad_open(?FUNCTION_ID_WZAD1, ?FUNCTION_ID_WZAD2);
		_ ->
			false
	end.

%%检查跨服暗殿是否开启
check_wzad_cross_open(SceneId) ->
	case is_open_active_wzad(SceneId) of
		{ok, _} ->
			check_wzad_open(?FUNCTION_ID_WZAD_CROSS1, ?FUNCTION_ID_WZAD_CROSS2);
		_ ->
			false
	end.

%%检查本服火龙是否开启
check_dragon_open() ->
	case is_open_active_dragon(?ACTIVE_ID_DRAGON) of
		{ok, _} ->
			Conf = function_config:get(?FUNCTION_ID_DRAGON),
			case function_lib:check_is_open_time(Conf) of
				{true, _} ->
					true;
				_ ->
					false
			end;
		_ ->
			false
	end.

%%检查跨服火龙是否开启
check_dragon_cross_open(_SceneId) ->
	%%只需要判断开服日期就可以(只有一个时间段,进场景有判断时间)
	Conf = function_config:get(?FUNCTION_ID_DRAGON_CROSS1),
	case function_lib:check_is_open_time(Conf) of
		{true, _} ->
			true;
		_ ->
			false
	end.

%% ====================================================================
%% inside functions
%% ====================================================================

%% 检测活动是否开启
is_open_active(ActiveId) ->
	Result = case active_instance_config:get(ActiveId) of
				 #active_instance_conf{} = ActConf ->
					 OpenWeekList = ActConf#active_instance_conf.open_week,
					 Week = util_date:get_week(),
					 case lists:member(Week, OpenWeekList) of
						 true ->
							 case check_open_time(1, ActConf) of
								 {ok, TimeStamp} ->
									 {ok, TimeStamp};
								 _ ->
									 case check_open_time(2, ActConf) of
										 {ok, TimeStamp} ->
											 {ok, TimeStamp};
										 {fail, Reply} ->
											 {fail, Reply}
									 end
							 end;
						 false ->
							 {fail, ?ERR_ACTIVE_NOT_OPEN}
					 end;
				 _ ->
					 {fail, ?ERR_ACTIVE_NOT_OPEN}
			 end,
	case Result of
		{ok, _} ->
			case ActiveId of
				32112 ->
					case cross_lib:send_cross_mfc(scene_hjzc_lib, get_hjzc_state, []) of
						true ->
							Result;
						false ->
							{fail, ?ERR_ACTIVE_NOT_OPEN};
						Err ->
							?ERR("~p", [Err]),
							{fail, ?ERR_ACTIVE_NOT_OPEN}
					end;
				?SCENEID_HJZC_DATING ->
					case scene_hjzc_lib:get_hjzc_state() of
						true ->
							Result;
						false ->
							{fail, ?ERR_ACTIVE_NOT_OPEN};
						Err ->
							?ERR("~p", [Err]),
							{fail, ?ERR_ACTIVE_NOT_OPEN}
					end;
				_ ->
					Result
			end;
		_ ->
			Result
	end.

%% 双倍经验检查
is_open_double_exp_active() ->
	case active_instance_config:get(15) of
		#active_instance_conf{} = ActConf ->
			OpenWeekList = ActConf#active_instance_conf.open_week,
			Week = util_date:get_week(),
			case lists:member(Week, OpenWeekList) of
				true ->
					case check_open_time(3, ActConf) of
						{ok, _} ->
							{ok, true};
						_ ->
							case check_open_time(4, ActConf) of
								{ok, _} ->
									{ok, true};
								{fail, Reply} ->
									{fail, Reply}
							end
					end;
				false ->
					{fail, ?ERR_ACTIVE_NOT_OPEN}
			end;
		_ ->
			{fail, ?ERR_ACTIVE_NOT_OPEN}
	end.


%%是否在暗殿开启的时间段
is_open_active_wzad(ActiveId) ->
	case active_instance_config:get(ActiveId) of
		#active_instance_conf{} = ActConf ->
			OpenWeekList = ActConf#active_instance_conf.open_week,
			Week = util_date:get_week(),
			case lists:member(Week, OpenWeekList) of
				true ->
					case Week < 0 of
						true ->
							case check_open_time(1, ActConf) of
								{ok, TimeStamp} ->
									{ok, TimeStamp};
								{fail, Reply} ->
									{fail, Reply}
							end;
						false ->
							case check_open_time(1, ActConf) of
								{ok, TimeStamp} ->
									{ok, TimeStamp};
								_ ->
									case check_open_time(2, ActConf) of
										{ok, TimeStamp} ->
											{ok, TimeStamp};
										{fail, Reply} ->
											{fail, Reply}
									end
							end
					end;
				false ->
					{fail, ?ERR_ACTIVE_NOT_OPEN}
			end;
		_ ->
			{fail, ?ERR_ACTIVE_NOT_OPEN}
	end.

%%是否在本服火龙开启的时间段,周一到周五,周日
is_open_active_dragon(ActiveId) ->
	case active_instance_config:get(ActiveId) of
		#active_instance_conf{} = ActConf ->
			OpenWeekList = ActConf#active_instance_conf.open_week,
			Week = util_date:get_week(),
			case lists:member(Week, OpenWeekList) of
				true ->
					if
						Week < 8 ->
							case check_open_time(1, ActConf) of
								{ok, TimeStamp} ->
									{ok, TimeStamp};
								_ ->
									case check_open_time(2, ActConf) of
										{ok, TimeStamp2} ->
											{ok, TimeStamp2};
										{fail, Reply2} ->
											{fail, Reply2}
									end
							end;
						Week =:= 70 ->%%不启用
							case check_open_time(2, ActConf) of
								{ok, TimeStamp} ->
									{ok, TimeStamp};
								{fail, Reply} ->
									{fail, Reply}
							end;
						true ->
							{fail, ?ERR_ACTIVE_NOT_OPEN}
					end;
				false ->
					{fail, ?ERR_ACTIVE_NOT_OPEN}
			end;
		_ ->
			{fail, ?ERR_ACTIVE_NOT_OPEN}
	end.

%%获取暗殿开启的时间段
get_open_active_wzad_time_flag(ActiveId) ->
	case active_instance_config:get(ActiveId) of
		#active_instance_conf{} = ActConf ->
			OpenWeekList = ActConf#active_instance_conf.open_week,
			Week = util_date:get_week(),
			case lists:member(Week, OpenWeekList) of
				true ->
					case Week < 6 of
						true ->
							case check_open_time(3, ActConf) of
								{ok, _} ->
									1;
								{fail, _} ->
									0
							end;
						false ->
							case check_open_time(3, ActConf) of
								{ok, _} ->
									1;
								_ ->
									case check_open_time(4, ActConf) of
										{ok, _} ->
											2;
										{fail, _} ->
											0
									end
							end
					end;
				false ->
					0
			end;
		_ ->
			0
	end.

check_open_time(1, ActConf) ->
	OpenTime = ActConf#active_instance_conf.open_time_1,
	CloseTime = ActConf#active_instance_conf.close_time_1,
	check_open_time2(OpenTime, CloseTime);
check_open_time(2, ActConf) ->
	OpenTime = ActConf#active_instance_conf.open_time_2,
	CloseTime = ActConf#active_instance_conf.close_time_2,
	check_open_time2(OpenTime, CloseTime);
check_open_time(3, ActConf) ->
	OpenTime = ActConf#active_instance_conf.open_time_1,
	CloseTime = ActConf#active_instance_conf.close_time_1,
	check_open_time3(OpenTime, CloseTime);
check_open_time(4, ActConf) ->
	OpenTime = ActConf#active_instance_conf.open_time_2,
	CloseTime = ActConf#active_instance_conf.close_time_2,
	check_open_time3(OpenTime, CloseTime).


check_open_time2(OpenTime, CloseTime) ->
	case OpenTime == [] andalso CloseTime == [] of
		true ->
			{fail, ?ERR_ACTIVE_NOT_OPEN};
		false ->
			{Date, _} = calendar:local_time(),
			OpenTemp = util_date:time_tuple_to_unixtime({Date, OpenTime}),
			CloseTemp = util_date:time_tuple_to_unixtime({Date, CloseTime}),
			NowTime = util_date:unixtime(),
			case NowTime >= OpenTemp andalso NowTime < CloseTemp of
				true ->
					{ok, CloseTemp - NowTime};
				false ->
					{fail, ?ERR_ACTIVE_NOT_OPEN}
			end
	end.

check_open_time3(OpenTime, CloseTime) ->
	case OpenTime == [] andalso CloseTime == [] of
		true ->
			{fail, ?ERR_ACTIVE_NOT_OPEN};
		false ->
			NowTime = time(),
			case NowTime >= OpenTime andalso NowTime < CloseTime of
				true ->
					{ok, true};
				false ->
					{fail, ?ERR_ACTIVE_NOT_OPEN}
			end
	end.

check_enter_time(ActConf) ->
	OpenTime = ActConf#active_instance_conf.open_time_1,
	CloseTime = ActConf#active_instance_conf.close_time_1,
	NowTime = time(),
	case NowTime >= OpenTime andalso NowTime =< CloseTime of
		true ->
			check_enter_time_1(ActConf);
		false ->
			check_enter_time_2(ActConf)
	end.

check_enter_time_1(ActConf) ->
	EnterTime = ActConf#active_instance_conf.enter_time_1,
	StopTime = ActConf#active_instance_conf.stop_time_1,
	case EnterTime == [] andalso StopTime == [] of
		true ->
			true;
		false ->
			NowTime = time(),
			NowTime >= EnterTime andalso NowTime =< StopTime
	end.

check_enter_time_2(ActConf) ->
	EnterTime2 = ActConf#active_instance_conf.enter_time_2,
	StopTime2 = ActConf#active_instance_conf.stop_time_2,
	case EnterTime2 == [] andalso StopTime2 == [] of
		true ->
			true;
		false ->
			NowTime = time(),
			NowTime >= EnterTime2 andalso NowTime =< StopTime2
	end.


%% ====================================================================
%% 红点提示接口
%% ====================================================================
%% 未知暗殿
get_active_wzad_button_tips(PlayerState) ->
	FunctionList = PlayerState#player_state.function_open_list,
	case lists:member(?FUNCTION_ACTIVE_WZAD, FunctionList) of
		true ->
			check_button_tips(PlayerState, 10);
		false ->
			{PlayerState, 0}
	end.

%% 屠龙大会
get_active_tldh_button_tips(PlayerState) ->
	FunctionList = PlayerState#player_state.function_open_list,
	case lists:member(?FUNCTION_ACTIVE_TLDH, FunctionList) of
		true ->
			check_button_tips(PlayerState, 11);
		false ->
			{PlayerState, 0}
	end.

%% 胜者为王
get_active_szww_button_tips(PlayerState) ->
	FunctionList = PlayerState#player_state.function_open_list,
	case lists:member(?FUNCTION_ACTIVE_SZWW, FunctionList) of
		true ->
			check_button_tips(PlayerState, 12);
		false ->
			{PlayerState, 0}
	end.

%% 双倍经验
get_active_double_exp_button_tips(PlayerState) ->
	check_button_tips(PlayerState, 15).
%% 跨服暗殿 每天
get_active_gfad_button_tips(PlayerState) ->
	case is_wzad_cross_fun_enable() of
		true ->
			case get_open_active_wzad_time_flag(32104) of
				1 ->
					{PlayerState, 1};
				_ ->
					{PlayerState, 0}
			end;
		false ->
			{PlayerState, 0}
	end.
%% 跨服暗殿 周末早上
get_active_gfad2_button_tips(PlayerState) ->
	case is_wzad_cross_fun_enable() of
		true ->
			case get_open_active_wzad_time_flag(32104) of
				2 ->
					{PlayerState, 1};
				_ ->
					{PlayerState, 0}
			end;
		false ->
			{PlayerState, 0}
	end.
%% 暗殿每天
get_active_ad_button_tips(PlayerState) ->
	case is_wzad_fun_enable() of
		true ->
			case get_open_active_wzad_time_flag(10) of
				1 ->
					{PlayerState, 1};
				_ ->
					{PlayerState, 0}
			end;
		false ->
			{PlayerState, 0}
	end.
%% 暗殿周末早上
get_active_ad2_button_tips(PlayerState) ->
	case is_wzad_fun_enable() of
		true ->
			case get_open_active_wzad_time_flag(10) of
				2 ->
					{PlayerState, 1};
				_ ->
					{PlayerState, 0}
			end;
		false ->
			{PlayerState, 0}
	end.

%% 怪物攻城
get_active_gwgc_button_tips(PlayerState) ->
	case ets:lookup(?ETS_SCENE_MAPS, {?SCENEID_MONSTER_ATK, ?WORLD_ACTIVE_SIGN}) of
		[_EtsMaps] ->
			{PlayerState, 1};
		_ ->
			{PlayerState, 0}
	end.

check_button_tips(PlayerState, ActiveId) ->
	case is_open_active(ActiveId) of
		{ok, _} ->
			{PlayerState, 1};
		_ ->
			{PlayerState, 0}
	end.

%% 红点推送给行会成员
send_active_button_to_all_player(NoticId) ->
	case NoticId of
		?NOTICE_WZAD_OPEN ->
			send_active_button_to_all_player_1(?BTN_ACTIVE_WZAD);
		?NOTICE_WZAD_CLOSE ->
			send_active_button_to_all_player_1(?BTN_ACTIVE_WZAD);
		?NOTICE_TLDH_OPEN ->
			send_active_button_to_all_player_1(?BTN_ACTIVE_TLDH);
		?NOTICE_TLDH_CLOSE ->
			send_active_button_to_all_player_1(?BTN_ACTIVE_TLDH);
		?NOTICE_SZWW_OPEN ->
			send_active_button_to_all_player_1(?BTN_ACTIVE_SZWW);
		?NOTICE_SZWW_CLOSE ->
			send_active_button_to_all_player_1(?BTN_ACTIVE_SZWW);
		?NOTICE_MONSTER_ATK_OPEN ->
			send_active_button_to_all_player_1(?BTN_ACTIVE_MAC);

	%%-define(BTN_ACTIVE_CROSS_WZAD, 107). %% 跨服暗殿每天
	%%-define(BTN_ACTIVE_CROSS_WZAD_WEEKEND, 108). %% 跨服暗殿周末
	%%-define(BTN_ACTIVE_DOUBLE_EXP, 109). %% 全服双倍经验

	%%?NOTICE_WZAD_WEEKEND_OPEN->
		59 ->
			send_active_button_to_all_player_1(106);%%?BTN_ACTIVE_WZAD_WEEKEND
	%%?NOTICE_WZAD_WEEKEND_CLOSE->
		60 ->
			send_active_button_to_all_player_1(106);%%?BTN_ACTIVE_WZAD_WEEKEND

	%%WZAD_CROSS_OPEN->
		56 ->
			send_active_button_to_all_player_1(107);%%?BTN_ACTIVE_CROSS_WZAD
	%%WZAD_CROSS_CLOSE->
		57 ->
			send_active_button_to_all_player_1(107);%%?BTN_ACTIVE_CROSS_WZAD

	%%?NOTICE__DOUBLE_EXP_OPEN->
		63 ->
			send_active_button_to_all_player_1(109);%%BTN_ACTIVE_DOUBLE_EXP
	%%?NOTICE__DOUBLE_EXP_CLOSE->
		64 ->
			send_active_button_to_all_player_1(109);%%?BTN_ACTIVE_DOUBLE_EXP
	%%?NOTICE_CROSS_WEEKEND_OPEN->
		61 ->
			send_active_button_to_all_player_1(107),%%?BTN_ACTIVE_CROSS_WZAD
			send_active_button_to_all_player_1(108);%%BTN_ACTIVE_CROSS_WZAD_WEEKEND
	%%?NOTICE_CROSS_WEEKEND_CLOSE->
		62 ->
			send_active_button_to_all_player_1(107),%%?BTN_ACTIVE_CROSS_WZAD
			send_active_button_to_all_player_1(108);%%?BTN_ACTIVE_CROSS_WZAD_WEEKEND
		_ ->
			skip
	end.

send_active_button_to_all_player_1(TipsId) ->
	Fun = fun(PlayerPid) ->
		gen_server2:cast(PlayerPid, {update_button_tips, TipsId})
	end,
	PlayerList = player_lib:get_online_players(),
	[Fun(EtsOnline#ets_online.pid) || EtsOnline <- PlayerList].

%% 开启怪物攻城
open_monster_attack_instance() ->
	ActConf = active_instance_config:get(?ACTIVE_ID_MONSTER_ATK),
	InstanceId = ActConf#active_instance_conf.instance_id,
	scene_mgr_lib:create_scene(InstanceId, #player_state{scene_parameters = 0}).


%% 判断是否有双倍
check_double_exp(PlayerState) ->
	case is_open_double_exp_active() of
		{ok, _} ->
			PlayerState#player_state{is_double_exp = 2};
		_ ->
			PlayerState
	end.

%%检查暗殿功能开放
check_wzad_open(FunId1, FunId2) ->
	%%平时晚上的暗殿
	Conf = function_config:get(FunId1),
	WeekFlag =
		case function_lib:check_is_open_time(Conf) of
			{true, _} ->
				true;
			_ ->
				false
		end,

	%%周末早上的暗殿
	Week = util_date:get_week(),
	WeekEndFlag =
		case Week =:= 6 orelse Week =:= 7 of
			true ->
				Conf7 = function_config:get(FunId2),
				case function_lib:check_is_open_time(Conf7) of
					{true, _} -> true;
					_ -> false
				end;
			false ->
				false
		end,
	WeekFlag orelse WeekEndFlag.

%%检查本服暗殿功能开启
is_wzad_fun_enable() ->
	check_wzad_open(?FUNCTION_ID_WZAD1, ?FUNCTION_ID_WZAD2).
%%检查跨服暗殿功能开启
is_wzad_cross_fun_enable() ->
	check_wzad_open(?FUNCTION_ID_WZAD_CROSS1, ?FUNCTION_ID_WZAD_CROSS2).