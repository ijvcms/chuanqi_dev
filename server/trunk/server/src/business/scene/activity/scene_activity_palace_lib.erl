%%%-------------------------------------------------------------------
%%% @author zhengsiying
%%% @copyright (C) 2015, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 21. 十二月 2015 上午12:13
%%%-------------------------------------------------------------------
-module(scene_activity_palace_lib).

-include("common.hrl").
-include("record.hrl").
-include("notice_config.hrl").
-include("config.hrl").
-include("gameconfig_config.hrl").
-include("log_type_config.hrl").
-include("cache.hrl").
-include("language_config.hrl").

%% API
-export([
	init/2,
	on_timer/1,
	on_start/1,
	on_end/1,
	on_obj_die/3,
	get_next_start_time/1,
	is_open/0,
	bubble_point/1,
	check_collect/3
]).

-define(ADD_EXP_TIMES, 15). %% 添加经验时间(秒)
-define(REFUSE_BOX_TIMES, 5 * 60). %% 刷新宝箱时间(秒)

%% ====================================================================
%% API functions 初始话皇宫活动信息
%% ====================================================================
init(SceneState, _Args) ->
	GuildId = city_lib:get_scene_city_guild_id(),%% 获取当前皇宫所有者
	scene_activity_shacheng_lib:set_occupy_info(GuildId, ?ACTIVITY_STATUS_OFF),%% 设置沙城相关信息
	{ok, SceneState#scene_state{refuse_box_time_shacheng = util_date:unixtime()}}.
%% 定时器
on_timer(SceneState) ->
	case SceneState#scene_state.activity_status of
		?ACTIVITY_STATUS_ON ->
			check_cur_occupy(SceneState);
		_ ->
			skip
	end,

	%% 获取当前活动的状态信息
	CurStatus = SceneState#scene_state.activity_status,
	%% 获取增加经验的 时间处理
	CurTime = util_date:unixtime(),
	%% 检测定时刷新宝箱
	SceneState2 = case CurStatus =:= ?ACTIVITY_STATUS_ON of
					  true ->
						  scene_activity_shacheng_lib:update_time_box(SceneState, CurTime, palace);
					  _ ->
						  SceneState
				  end,

	{ok, SceneState2}.
%% 皇宫开启
on_start(SceneState) ->
	GuildId = city_lib:get_scene_city_guild_id(),
	scene_activity_shacheng_lib:set_occupy_info(GuildId, ?ACTIVITY_STATUS_ON),
	check_cur_occupy(SceneState),
	gen_server2:apply_after(?ADD_EXP_TIMES * 1000, self(), {?MODULE, bubble_point, []}),
	CurTime = util_date:unixtime(),
	NewSceneState = SceneState#scene_state{
		refuse_box_time_shacheng = CurTime + ?REFUSE_BOX_TIMES
	},
	%% 宝箱信息记录
	EtsBox = #ets_sbk_box{
		key = ?SCENEID_SHABAKE,
		ref_shacheng_time = CurTime + ?REFUSE_BOX_TIMES,
		ref_palace_time = CurTime + ?REFUSE_BOX_TIMES + ?REFUSE_BOX_TIMES,
		player_dice = dict:new()
	},
	ets:insert(?ETS_SBK_BOX, EtsBox),
	{ok, NewSceneState}.
%% 皇宫结束
on_end(SceneState) ->
	NewSceneState = update_box(SceneState),
	GuildId = scene_activity_shacheng_lib:get_occupy_guild_id(),
	case GuildId /= 0 of
		true ->
			?ERR("update scene city: ~p", [GuildId]),
			city_lib:update_scene_city(?SCENEID_SHABAKE, GuildId),
			GuildName = guild_lib:get_guild_name(GuildId),
			%% 给归属行会成员发放邮件奖励
			guild_lib:send_mail_to_all_member(GuildId, ?GAMECONFIG_SBK_WIN_MAIL_ID),
			active_service_merge_lib:check_shabake_over(),
			notice_lib:send_notice(0, ?NOTICE_SHACHENG_OCCUPY, [GuildName]);
		_ ->
			notice_lib:send_notice(0, ?NOTICE_SHACHENG_NOT_OCCUPY, [])
	end,
	scene_activity_shacheng_lib:set_occupy_info(GuildId, ?ACTIVITY_STATUS_OFF),

	{ok, NewSceneState}.

on_obj_die(SceneState, _DieState, _KillerState) ->
	check_cur_occupy(SceneState),
	{ok, SceneState}.

%% ====================================================================
%% Internal functions
%% ====================================================================
check_cur_occupy(SceneState) ->
	PlayerList = scene_base_lib:do_get_scene_players(SceneState),%% 获取场景中的所有玩家
	F = fun(ObjState, TempList) ->
		#scene_obj_state{
			guild_id = GuildId,
			cur_hp = CurHp
		} = ObjState,%% 查看玩家的血量
		case CurHp > 0 of
			true ->
				util_list:store(GuildId, TempList);%% 获取场景里面所有血量大于0的玩家的 工会id
			_ ->
				TempList
		end
	end,
	List = lists:foldl(F, [], PlayerList),

	%% 当前在皇宫中帮派的数量
	Num = length(List),
	case Num == 1 of
		true ->%% 如果只有单独的一个工会在皇宫中 那么执行零时占领逻辑
			[OccupyGuildId] = List,%% 新占领皇宫的工会id
			CurGuildId = scene_activity_shacheng_lib:get_occupy_guild_id(),%% 获取以前沙城占领的工会id
			case CurGuildId /= OccupyGuildId andalso OccupyGuildId /= 0 of
				true ->
					%% 如果新占领的工会id不为0，且新占领的工会id和原工会id不相同 那么更新相关信息
					?INFO("set occupy_guild_id : ~p", [OccupyGuildId]),
					%% 设置新的占领工会
					scene_activity_shacheng_lib:set_occupy_info(OccupyGuildId, SceneState#scene_state.activity_status),
					GuildName = guild_lib:get_guild_name(OccupyGuildId),
					%% 发送全服工会占领公告
					notice_lib:send_notice(0, ?NOTICE_SHACHENG_TEMP_OCCUPY, [GuildName]);
				_ ->
					skip
			end;
		_ ->
			skip
	end.

%% 判断沙巴克是否今天开启
is_open() ->
	{_BeginTime, EndTime} = get_next_start_time(?SCENEID_SHABAKE),
	{{_EndYear, _EndMonth, EndDay}, {_CurH, _CurM, _CurS}} = util_date:unixtime_to_local_time(EndTime),
	{{_NowYear, _NowMonth, NowDay}, {_CurH1, _CurM1, _CurS1}} = util_date:unixtime_to_local_time(util_date:unixtime()),
	EndDay =:= NowDay.

%% 获取沙巴克开启时间
get_next_start_time(SceneId) ->
	SceneConf = scene_config:get(SceneId),
	ActivityConf = scene_activity_config:get(SceneConf#scene_conf.activity_id),
	{Day, {BeginH, BeginM}, {EndH, EndM}} = ActivityConf#scene_activity_conf.frist_time,
	%% 获取开服时间
	{{OpenY, OpenM, OpenD}, {_OpenH, _OpenI, _OpenS}} = config:get_start_time_str(),

	NowEndTime = util_date:time_tuple_to_unixtime({{OpenY, OpenM, OpenD}, {EndH, EndM, 0}}),
	EndTime = NowEndTime + Day * ?DAY_TIME_COUNT,
	CurTime = util_date:unixtime(),
	case EndTime > CurTime of
		true ->
			NowBeginTime = util_date:time_tuple_to_unixtime({{OpenY, OpenM, OpenD}, {BeginH, BeginM, 0}}),
			BeginTime = NowBeginTime + Day * ?DAY_TIME_COUNT,
			{BeginTime, EndTime};
		_ ->
			get_next(ActivityConf, CurTime)
	end.

%% 获取沙巴克开启时间
get_next(ActivityConf, CurTime) ->
	%% DayLimit－开服多少天内不开启
	{DayLimit, Week, {H, M}, {EndH, EndM}} = ActivityConf#scene_activity_conf.start_time,
	%% 获取开服时间
	{{OpenY, OpenM, OpenD}, {OpenH, OpenI, OpenS}} = config:get_start_time_str(),
	%%{{OpenY, OpenM, OpenD}, {OpenH, OpenI, OpenS}} = {{2016, 04, 20}, {10, 0, 0}},
	%% 开服时间是星期几
	OpenWeek = calendar:day_of_the_week({OpenY, OpenM, OpenD}),
	%% 获取服务器erlang的当前时间

	%%CurTime = util_date:datetime_to_timestamp({{NowYear, NowMonth, NowDay}, {_CurH, _CurM, _CurS}}),
	%%算出开服时间的周末
	OpenTempTime = util_date:time_tuple_to_unixtime({{OpenY, OpenM, OpenD}, {OpenH, OpenI, OpenS}}),
	TempTime = OpenTempTime + (7 - OpenWeek) * ?DAY_TIME_COUNT,

	NowTime = case CurTime < OpenTempTime of
				  true ->
					  OpenTempTime;
				  _ ->
					  CurTime
			  end,

	{{NowYear, NowMonth, NowDay}, {_CurH, _CurM, _CurS}} = util_date:unixtime_to_local_time(NowTime),
	%%{{NowYear, NowMonth, NowDay}, {_CurH, _CurM, _CurS}} = {{2016, 04, 26}, {10, 0, 0}},

	%% 今天是星期几
	NowWeek = calendar:day_of_the_week({NowYear, NowMonth, NowDay}),


	AddDay = case Week - OpenWeek < DayLimit andalso TempTime > NowTime of
				 true ->
					 TempWeek = Week - NowWeek,
					 if
						 TempWeek < 0 ->%% 当前时间大于 周期时间
							 7 - NowWeek + Week;
						 true ->
							 TempWeek + 7
					 end;
				 _ ->
					 %% 如果当天大于开启时间的星期
					 TempWeek = Week - NowWeek,
					 if
						 TempWeek < 0 ->%% 当前时间大于 周期时间
							 7 - NowWeek + Week;
						 true ->
							 TempWeek
					 end
			 end,

	NowEndTime = util_date:time_tuple_to_unixtime({{NowYear, NowMonth, NowDay}, {EndH, EndM, 0}}),
	EndTime = NowEndTime + AddDay * ?DAY_TIME_COUNT,
	NowBeginTime = util_date:time_tuple_to_unixtime({{NowYear, NowMonth, NowDay}, {H, M, 0}}),
	BeginTime = NowBeginTime + AddDay * ?DAY_TIME_COUNT,
	case EndTime =< NowTime of
		true ->
			{BeginTime + 7 * ?DAY_TIME_COUNT, EndTime + 7 * ?DAY_TIME_COUNT};
		_ ->
			{BeginTime, EndTime}
	end.

%% %% 获取沙巴克开启时间
%% make_next_start_time(SceneState) ->
%% 	SceneId = SceneState#scene_state.scene_id,
%% 	SceneConf = scene_config:get(SceneId),
%% 	ActivityConf = scene_activity_config:get(SceneConf#scene_conf.activity_id),
%% 	%% DayLimit多少时间后 Week 星期几开
%% 	{DayLimit, Week, {H, M}, _EndTime} = ActivityConf#scene_activity_conf.start_time,
%% 	ServerStartTime = config:get_start_time(),
%% 	CurTime = util_date:unixtime(),
%% 	%% 已经开启服务器时间
%% 	T = CurTime - ServerStartTime,
%% 	%% 一天开启的服务器的时间
%% 	TimeCount = H * 3600 + M * 60,
%% 	%% 获取服务器erlang的当前时间
%% 	{Date, {CurH, CurM, CurS}} = calendar:local_time(),
%% 	%% 获取当前的星期
%% 	CurWeek = calendar:day_of_the_week(Date),
%% 	%% 当前的今天走过的秒数
%% 	TimeCount1 = CurH * 3600 + CurM * 60 + CurS,
%% 	%% 当天零点时间戳
%% 	DayTime = util_date:get_today_unixtime(),
%% 	case Week /= 0 of
%% 		true ->
%% 			case T >= DayLimit*?DAY_TIME_COUNT of
%% 				true ->
%% 					%% 如果已经没有服务器开服时间限制
%% 					%% 计算如果不受开服时间影响，只受星期影响的话需要后推多少天
%% 					T1 =
%% 						if
%% 							Week > CurWeek  ->
%% 								%% 如果开启活动周几数字大于当前周几数则返回本周时差
%% 								(Week - CurWeek)*?DAY_TIME_COUNT;
%% 							Week == CurWeek andalso TimeCount > TimeCount1 ->
%% 								%% 如果开启活动周几数字等于当前周几数，则判断开启时长书是否大于当前时长数，返回本周时差
%% 								(Week - CurWeek)*?DAY_TIME_COUNT;
%% 							true ->
%% 								%% 否则返回下周时差
%% 								(Week + 7 - CurWeek)*?DAY_TIME_COUNT
%% 						end,
%% 					DayTime + T1 + TimeCount;
%% 				_ ->
%% 					%% 如果还受开服时间限制影响
%% 					%% 计算只受开服时间影响不受星期影响需要后退多少时间
%% 					T1 = DayLimit*?DAY_TIME_COUNT - T,
%% 					%% 计算如果不受开服时间影响，只受星期影响的话需要后推多少天
%% 					T2 =
%% 						if
%% 							Week > CurWeek  ->
%% 								%% 如果开启活动周几数字大于当前周几数则返回本周时差
%% 								(Week - CurWeek)*?DAY_TIME_COUNT;
%% 							Week == CurWeek andalso TimeCount > TimeCount1 ->
%% 								%% 如果开启活动周几数字等于当前周几数，则判断开启时长书是否大于当前时长数，返回本周时差
%% 								(Week - CurWeek)*?DAY_TIME_COUNT;
%% 							true ->
%% 								%% 否则返回下周时差
%% 								(Week + 7 - CurWeek)*?DAY_TIME_COUNT
%% 						end,
%%
%% 					case T1 > T2 of
%% 						true ->
%% 							%% 获取最接近无开服限制的星期数
%% 							W = T1 div (7 * ?DAY_TIME_COUNT),
%% 							%% 获取经过w个星期后的开启时差
%% 							T3 = T2 + W * (7 * ?DAY_TIME_COUNT),
%%
%% 							%% 获取真实需要延后的时间
%% 							case T3 > T2 of
%% 								true ->
%% 									DayTime + T3 + TimeCount;
%% 								_ ->
%% 									DayTime + T3 + (7 * ?DAY_TIME_COUNT) + TimeCount
%% 							end;
%% 						_ ->
%% 							DayTime + T1 + TimeCount
%% 					end
%% 			end;
%% 		_ ->
%% 			case T >= DayLimit*?DAY_TIME_COUNT of
%% 				true ->
%% 					%% 如果已经没有服务器开服时间限制
%% 					case TimeCount > TimeCount1 of
%% 						true ->
%% 							DayTime + TimeCount;
%% 						_ ->
%% 							DayTime + ?DAY_TIME_COUNT + TimeCount
%% 					end;
%% 				_ ->
%% 					T1 = DayLimit*?DAY_TIME_COUNT - T,
%% 					T2 =
%% 						case TimeCount > TimeCount1 of
%% 							true ->
%% 								TimeCount - TimeCount1;
%% 							_ ->
%% 								TimeCount + ?DAY_TIME_COUNT - TimeCount1
%% 						end,
%% 					case T1 > T2 of
%% 						true ->
%% 							%% 获取最接近无开服限制的天数
%% 							TT = T1 div ?DAY_TIME_COUNT,
%% 							T3 = T2 + TT * ?DAY_TIME_COUNT,
%%
%% 							%% 获取真实需要延后的时间
%% 							case T3 > T2 of
%% 								true ->
%% 									CurTime + T3;
%% 								_ ->
%% 									CurTime + T3 + ?DAY_TIME_COUNT
%% 							end;
%% 						_ ->
%% 							CurTime + T2
%% 					end
%% 			end
%% 	end.

bubble_point(SceneState) ->
	case ets:lookup(?ETS_ACTIVITY_SHACHENG, 1) of%% 查看是否有沙城活动
		[OldEtsInfo] ->
			case OldEtsInfo#ets_activity_shacheng.is_activity of
				?ACTIVITY_STATUS_ON ->
					ObjList = scene_base_lib:do_get_scene_players(SceneState),
					Fun = fun(ObjState) ->
						Pid = ObjState#scene_obj_state.obj_pid,
						Exp = max(0, 2 * (ObjState#scene_obj_state.lv - 10) * 100),
						gen_server2:cast(Pid, {add_value, ?SUBTYPE_EXP, Exp, ?LOG_TYPE_OFFICER_DAY})
					end,
					[Fun(X) || X <- ObjList],
					gen_server2:apply_after(?ADD_EXP_TIMES * 1000, self(), {?MODULE, bubble_point, []}),
					{ok, SceneState};
				_ ->
					skip
			end;
		_ ->
			skip
	end.

%% 检测采集条件
check_collect(PlayerId, GuildId, MonsterId) ->
	%% 某个宝箱只有沙巴克成员才能拾取
	case MonsterId of
		21500 -> %% 沙巴克结束宝箱id
			case city_lib:get_scene_city_guild_id() == GuildId of
				true ->
					check_collect(PlayerId, MonsterId);
				false ->
					{fail, ?ERR_COMMON_FAIL}
			end;
		_ ->
			check_collect(PlayerId, MonsterId)
	end.

check_collect(PlayerId, MonsterId) ->
	case ets:lookup(?ETS_SBK_BOX, ?SCENEID_SHABAKE) of
		[R | _] ->
			case update_collect_count(PlayerId, MonsterId, R#ets_sbk_box.player_dice) of
				{fail, Err} ->
					{fail, Err};
				PlayerDictNew ->
					R1 = R#ets_sbk_box{
						player_dice = PlayerDictNew
					},
					ets:insert(?ETS_SBK_BOX, R1),
					{ok, ?ERR_COMMON_SUCCESS}
			end;
		_ ->
			R1=#ets_sbk_box{
				key = ?SCENEID_SHABAKE,
				player_dice = dict:new()
			},
			ets:insert(?ETS_SBK_BOX,R1),
			check_collect(PlayerId,MonsterId)
	end.

%% 更新采集数量
update_collect_count(PlayerId, MonsterId, PlayerDict) ->
	NowTime = util_date:unixtime(),
	case dict:find({PlayerId, MonsterId}, PlayerDict) of
		{ok, {GiveCount, GiveTime}} ->
			MonsterConf = monster_config:get(MonsterId),
			ResetTime = MonsterConf#monster_conf.box_reset_time,
			BoxCount = MonsterConf#monster_conf.box_count,
%% 			?ERR("~p", [{ResetTime, BoxCount, NowTime}]),
			case NowTime >= ResetTime + GiveTime orelse BoxCount > GiveCount of
				true ->
					case NowTime >= ResetTime + GiveTime of
						true ->
							dict:store({PlayerId, MonsterId}, {GiveCount + 1, NowTime}, PlayerDict);
						false ->
							dict:store({PlayerId, MonsterId}, {GiveCount + 1, GiveTime}, PlayerDict)
					end;
				_ ->
					case GiveCount >= BoxCount of
						true ->
							{fail, ?ERR_COLLECT_COUNT};
						_ ->
							{fail, ?ERR_COLLECT_TIME}
					end
			end;
		_ ->
			dict:store({PlayerId, MonsterId}, {1, NowTime}, PlayerDict)
	end.


%% 发送胜利通知
%% send_sbk_win(GuildId) ->
%% 	MemberList = guild_cache:get_guild_member_num_from_ets(GuildId),
%% 	Fun = fun(DPG) ->
%% 		PlayerId = DPG#db_player_guild.player_id,
%% 		case player_lib:get_socket(PlayerId) of
%% 			null ->
%% 				skip;
%% 			Socket ->
%% 				net_send:send_to_client(Socket, 25009, #rep_sbk_win{scene_id = ?SCENEID_SHABAKE})
%% 		end
%% 	end,
%% 	[Fun(X) || X <- MemberList].

%% 检测是否刷新宝箱
update_box(SceneState) ->
	?WARNING("update_box",[]),
	SceneInfo = city_lib:get_ets_scene_city(?SCENEID_SHABAKE),
	case SceneInfo#ets_scene_city.city_info of
		null ->
%% 					case config:get_merge_servers() of
%% 						[] -> %% 未合服
%% 							notice_lib:send_notice(0, ?NOTICE_COMBINED, []);
%% 						_ ->  %% 合服
%% 							notice_lib:send_notice(0, ?NOTICE_OPEN, [])
%% 					end,
			SceneConf = scene_config:get(SceneState#scene_state.scene_id),
			RuleMonsterList =
				case lists:keyfind(end_box, 1, SceneConf#scene_conf.rule_monster_list) of
					false ->
						[];
					{_, L} ->
						L
				end,
			%% 刷新宝箱
			F = fun(RuleInfo, Acc) ->
				scene_obj_lib:create_area_monster(Acc, RuleInfo)
			end,
			?WARNING("update_box2 ~p",[length(RuleMonsterList)]),
			SceneState1 = lists:foldl(F, SceneState, RuleMonsterList),
			SceneState1;
		_ ->
			?WARNING("update_box3",[]),
			SceneState
	end.