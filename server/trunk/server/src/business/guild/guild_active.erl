%%%-------------------------------------------------------------------
%%% @author tuhujia
%%% @copyright (C) 2016, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 22. 一月 2016 09:11
%%%-------------------------------------------------------------------
-module(guild_active).

-include("common.hrl").
-include("record.hrl").
-include("proto.hrl").
-include("cache.hrl").
-include("db_record.hrl").
-include("config.hrl").
-include("uid.hrl").
-include("language_config.hrl").
-include("button_tips_config.hrl").
-include("notice_config.hrl").

%% API
-export([
	get_proto_active_info/1,
	get_guild_fam_info/0,
	get_sbk_fam_info/0,
	challenge_guild_active/2,
	clear_sbk_fem_state/1,
	open_sbk_fem/1,
	enter_sbk_fem/1,
	get_guild_boss_button_tips/1,
	get_guild_mj_button_tips/1,
	get_sbk_mj_button_tips/1,
	send_active_button_to_guild/1
]).

-define(NOT_ACTIVE_TYPE, 1).  	%% 活动不可用
-define(CLOSE_ACTIVE_TYPE, 2).  %% 活动未开启
-define(OPEN_ACTIVE_TYPE, 3).   %% 活动已开启
-define(KILL_BOSS_TYPE, 4).  	%% 已击杀boss
-define(NOT_KILL_BOSS_TYPE, 5). %% 未击杀boss

-define(SBK_FEM_INSTANSE, 20304). %% 行会秘境副本id

-define(ACTIVE_KEY, active).

%% ====================================================================
%% API functions
%% ====================================================================

%% 获取活动信息
get_proto_active_info(GuildId) ->
	case guild_cache:get_guild_info_from_ets(GuildId) of
		[] ->
			[];
		GuildInfo ->
			Fun = fun(ActConf, Acc) ->
				case ActConf#guild_active_conf.is_push == 1 of
					true ->
						proto_active_info(ActConf, GuildInfo);
					false ->
						Acc
				end

			end,
			lists:foldl(Fun, [], guild_active_config:get_list_conf())
	end.

proto_active_info(ActConf, GuildInfo) ->
	OpenWeekList = ActConf#guild_active_conf.open_week,
	Week = util_date:get_week(),
	case lists:member(Week, OpenWeekList) of
		true ->
			{Date, _} = calendar:local_time(),
			OpenTime = ActConf#guild_active_conf.open_time,
			OpenTemp = util_date:time_tuple_to_unixtime({Date, OpenTime}),
			NowTime = util_date:unixtime(),
			case OpenTemp > NowTime of
				true ->
					{?CLOSE_ACTIVE_TYPE, 0};
				false ->
					CloseTime = ActConf#guild_active_conf.close_time,
					CloseTemp = util_date:time_tuple_to_unixtime({Date, CloseTime}),
					case NowTime >= OpenTemp andalso NowTime =< CloseTemp of
						true ->
							{?OPEN_ACTIVE_TYPE, CloseTemp - NowTime};
						false ->
							ActiveId = ActConf#guild_active_conf.key,
							{_, IsKillBoss, _} = get_active_info(GuildInfo, ActiveId),
							case IsKillBoss == 1 of
								true ->
									{?KILL_BOSS_TYPE, 0};
								false ->
									{?NOT_KILL_BOSS_TYPE, 0}
							end
					end
			end;
		false ->
			{?NOT_ACTIVE_TYPE, 0}
	end.

%% 	#proto_guild_active{
%% 		id = ActConf#guild_active_conf.key,	%%  行会活动id
%% 		state = State ,  %%  状态 1不可用 2未开启 3已开启 4已击杀boss 5未击杀boss
%% 		time = Time  %%  结束还剩多少时间
%% 	}.

%% 获取行会秘境信息
get_guild_fam_info() ->
	ActConf = guild_active_config:get(?ACTIVE_GUILD_FEM),
	SubIns = ActConf#guild_active_conf.sub_instance,
	{_, LimitLv} = lists:keyfind(guild_lv, 1, ActConf#guild_active_conf.enter_limit),
	OpenTime = ActConf#guild_active_conf.open_time,
	CloseTime = ActConf#guild_active_conf.close_time,
	%%Week = util_date:get_week(),
	{Date, _} = calendar:local_time(),
	OpenTemp = util_date:time_tuple_to_unixtime({Date, OpenTime}),
	CloseTemp = util_date:time_tuple_to_unixtime({Date, CloseTime}),
	TimeStamp = 0,

	#rep_guild_fam_info
	{
		num = 1 + length(SubIns) ,  %%  层数
		lv = LimitLv,  				%%  进入等级
		open_time = OpenTemp + TimeStamp,  			%%  开始时间戳
		close_time = CloseTemp + TimeStamp  		%%  关闭时间戳
	}.

%% 获取沙巴克秘境信息
get_sbk_fam_info() ->
	CityId = city_lib:get_scene_city_guild_id(),
	GuildName = guild_lib:get_guild_name(CityId),
	ActConf = guild_active_config:get(?ACTIVE_SBK_FEM),
	{_, LimitLv} = lists:keyfind(player_lv, 1, ActConf#guild_active_conf.enter_limit),
	{State, Time} = get_sbk_fem_state(CityId),


	#rep_sbk_fam_info
	{
		sbk_name = GuildName ,  %%  归属公会名字
		lv = LimitLv ,  %%  限制等级
		state = State,  %%  开启状态
		timestamp = Time  %%  还剩多少秒关闭
	}.


%% 开启沙巴克秘境
open_sbk_fem(PlayerState) ->
	DbBase = PlayerState#player_state.db_player_base,
	GuildId = DbBase#db_player_base.guild_id,
	case guild_cache:get_guild_info_from_ets(GuildId) of
		[] ->
			{fail, ?ERR_PLAYER_NOT_JOINED_GUILD};
		GuildInfo ->
			ActConf = guild_active_config:get(?ACTIVE_SBK_FEM),
			OpenLimit = ActConf#guild_active_conf.open_limit,
			case check_guild_active_cond_list(PlayerState, GuildInfo, OpenLimit) of
				{ok, _} ->
					case is_open_active(?ACTIVE_SBK_FEM) of
						{ok, _TimeStamp} ->
							{State, _Time} = get_sbk_fem_state(GuildId),
							case State == 0 of
								true ->
									CountType = ActConf#guild_active_conf.count_type,
									LimitCount = ActConf#guild_active_conf.limit_count,
									case check_guild_active_count(CountType, GuildInfo, ?ACTIVE_SBK_FEM, LimitCount) of
										{ok, NewGuildInfo} ->
											update_sbk_fem_state(GuildId),
											%% 扣除行会资金
											{_, Capital} = lists:keyfind(guild_capital, 1, OpenLimit),
											guild_contribution:add_guild_capital_by_info(NewGuildInfo, -Capital),

											guild_pp:handle(17062, PlayerState, []),
											{ok, ?ERR_COMMON_SUCCESS};
										{fail, Reply} ->
											{fail, Reply}
									end;
								false ->
									{fail, ?ERR_SBK_FEM_ALREADY_OPEN}
							end;
						{fail, Reply} ->
							{fail, Reply}
					end;

				{fail, Reply} ->
					{fail, Reply}
			end
	end.

%% 进入沙巴克秘境
enter_sbk_fem(PlayerState) ->
	CityId = city_lib:get_scene_city_guild_id(),
	DbBase = PlayerState#player_state.db_player_base,
	GuildId = DbBase#db_player_base.guild_id,
	{State, _Time} = get_sbk_fem_state(CityId),
	case CityId == GuildId of
		true ->
			case State == 1 of
				true ->
					challenge_guild_active(PlayerState, ?ACTIVE_SBK_FEM);
				false ->
					{fail, ?ERR_SBK_FEM_NOT_OPEN}
			end;
		false ->
			{fail, ?ERR_GUILD_NOT_SBK_CITY}
	end.

%% 挑战行会活动相关副本
challenge_guild_active(PlayerState, ActiveId) ->
	DbBase = PlayerState#player_state.db_player_base,
	GuildId = DbBase#db_player_base.guild_id,
	case guild_cache:get_guild_info_from_ets(GuildId) of
		[] ->
			{fail, ?ERR_PLAYER_NOT_JOINED_GUILD};
		GuildInfo ->
			ActConf = guild_active_config:get(ActiveId),
			OpenLimit = ActConf#guild_active_conf.enter_limit,
			case check_guild_active_cond_list(PlayerState, GuildInfo, OpenLimit) of
				{ok, _} ->
					case is_open_active(ActiveId) of
						{ok, TimeStamp} ->
							challenge_guild_active(PlayerState, GuildInfo, ActConf, TimeStamp);
						{fail, Reply} ->
							{fail, Reply}
					end;
				{fail, Reply} ->
					{fail, Reply}
			end
	end.

challenge_guild_active(PlayerState, GuildInfo, ActConf, TimeStamp) ->
	%% 检测 如果副本已创建 跳过次数检测
	SceneId = ActConf#guild_active_conf.enter_instance,
	DbBase = PlayerState#player_state.db_player_base,
	GuildId = DbBase#db_player_base.guild_id,
	ActiveId = ActConf#guild_active_conf.key,
	case ets:lookup(?ETS_SCENE_MAPS, {SceneId, GuildId}) of
		[_EtsMaps] ->
			enter_active(PlayerState, GuildInfo, ActiveId, TimeStamp, false);
		_ ->
			CountType = ActConf#guild_active_conf.count_type,
			LimitCount = ActConf#guild_active_conf.limit_count,
			case check_guild_active_count(CountType, GuildInfo, ActiveId, LimitCount) of
				{ok, NewGuildInfo} ->
					enter_active(PlayerState, NewGuildInfo, ActiveId, TimeStamp, true);
				{fail, Reply} ->
					{fail, Reply}
			end
	end.

%% 进入活动副本
enter_active(PlayerState, GuildInfo, ActiveId, TimeStamp, IsAddCount) ->
	ActConf = guild_active_config:get(ActiveId),
	SceneId = ActConf#guild_active_conf.enter_instance,
	PlayerState1 = case TimeStamp == 0 of
					   true -> PlayerState#player_state{scene_parameters = 0};
					   false -> PlayerState#player_state{scene_parameters = TimeStamp}
				   end,

	case IsAddCount of
		false ->
			skip;
		true ->
			%% 添加公会活动次数
			add_active_count(GuildInfo, ActiveId)
	end,

	case scene_mgr_lib:change_scene(PlayerState1, self(), SceneId) of
		{ok, PlayerState2} ->
			%% 创建子副本
			SubInsList = ActConf#guild_active_conf.sub_instance,
			create_sub_instance(PlayerState2, SubInsList),

			{ok, PlayerState2#player_state{scene_parameters = []}};
		_ ->
			{fail, ?ERR_COMMON_FAIL}
	end.
%% 创建工会活动
create_sub_instance(PlayerState, SubInsList) ->
	DbBase = PlayerState#player_state.db_player_base,
	GuildId = DbBase#db_player_base.guild_id,

	Fun = fun(SceneId) ->
		case ets:lookup(?ETS_SCENE_MAPS, {SceneId, GuildId}) of
			[_EtsMaps] ->
				skip;
			_ ->
				scene_mgr_lib:create_scene(SceneId, PlayerState)
		end
	end,
	[Fun(X)||X <- SubInsList].

%% 获取沙巴克秘境状态和剩余时间
get_sbk_fem_state(GuildId) ->
	case ets:lookup(?ETS_GUILD_LIST, GuildId) of
		[R|_] ->
			Conf = instance_config:get(?SBK_FEM_INSTANSE),
			Time = Conf#instance_conf.close_time,
			{R#ets_guild_list.sbk_fem_state,
			Time - (util_date:unixtime() - R#ets_guild_list.sbk_fem_time)};
		_ ->
			{0, 0}
	end.

%% 更新沙巴克秘境状态
update_sbk_fem_state(GuildId) ->
	ets:update_element(?ETS_GUILD_LIST, GuildId, [{#ets_guild_list.sbk_fem_state, 1},
												  {#ets_guild_list.sbk_fem_time, util_date:unixtime()}]).

%% 清楚沙巴克秘境状态
clear_sbk_fem_state(GuildId) ->
	ets:update_element(?ETS_GUILD_LIST, GuildId, [{#ets_guild_list.sbk_fem_state, 0},
												  {#ets_guild_list.sbk_fem_time, 0}]).

%% ====================================================================
%% 内部函数
%% ====================================================================

%% 根据id获取对应活动信息
get_active_info(GuildInfo, ActiveId) ->
	Extra = GuildInfo#db_guild.extra,
	case lists:keyfind(?ACTIVE_KEY, 1, Extra) of
		false ->
			[];
		{_, ActiveList} ->
			case lists:keyfind(ActiveId, 1, ActiveList) of
				false ->
					[];
				{_, Count, IsKillBoss, UpdateTime} ->
					{Count, IsKillBoss, UpdateTime}
			end
	end.

%% 检查活动是否在有效时间内
is_open_active(ActiveId) ->
	ActConf = guild_active_config:get(ActiveId),
	OpenWeekList = ActConf#guild_active_conf.open_week,
	Week = util_date:get_week(),
	case lists:member(Week, OpenWeekList) of
		true ->
			OpenTime = ActConf#guild_active_conf.open_time,
			CloseTime = ActConf#guild_active_conf.close_time,
			case OpenTime == [] andalso CloseTime == [] of
				true ->
					{ok, 0};
				false ->
					{Date, _} = calendar:local_time(),
					OpenTemp = util_date:time_tuple_to_unixtime({Date, OpenTime}),
					CloseTemp = util_date:time_tuple_to_unixtime({Date, CloseTime}),
					NowTime = util_date:unixtime(),
					case NowTime >= OpenTemp andalso NowTime =< CloseTemp of
						true ->
							{ok, CloseTemp - OpenTemp};
						false ->
							{fail, ?ERR_GUILD_ACTIVE_NOT_OPEN}
					end
			end;
		false ->
			{fail, ?ERR_GUILD_ACTIVE_NOT_OPEN}
	end.

%% 检测活动次数限制
check_guild_active_count(<<"day">>, GuildInfo, ActiveId, LimitCount) when LimitCount > 0 ->
	{Count, UpdateTime} =
		case get_active_info(GuildInfo, ActiveId) of
			[] ->
				{0, 0};
			{C, _I, U} ->
				{C, U}
		end,

	case util_date:get_today_unixtime() >= UpdateTime of
		true ->
			%% 重置挑战次数
			NewGuildInfo = reset_active_count(GuildInfo, ActiveId),
			{ok, NewGuildInfo};
		false ->
			case Count < LimitCount of
				true ->
					{ok, GuildInfo};
				false ->
					{fail, ?ERR_GUILD_ACTIVE_COUNT_NOT_ENOUGH}
			end
	end;
check_guild_active_count(<<"week">>, GuildInfo, ActiveId, LimitCount) when LimitCount > 0 ->
	{Count, UpdateTime} =
		case get_active_info(GuildInfo, ActiveId) of
			[] ->
				{0, 0};
			{C, _I, U} ->
				{C, U}
		end,

	case util_date:check_week_time(UpdateTime) of
		false ->
			%% 重置挑战次数
			NewGuildInfo = reset_active_count(GuildInfo, ActiveId),
			{ok, NewGuildInfo};
		true ->
			case Count < LimitCount of
				true ->
					{ok, GuildInfo};
				false ->
					{fail, ?ERR_GUILD_ACTIVE_COUNT_NOT_ENOUGH}
			end
	end;
check_guild_active_count(_Type, _GuildInfo, _ActiveId, _LimitCount) ->
	?DEBUG("guild active conf error: ~p",[_Type]),
	{fail, ?ERR_COMMON_FAIL}.

%% 更新活动挑战次数
reset_active_count(GuildInfo, ActiveId) ->
	Extra = GuildInfo#db_guild.extra,
	NowTime = util_date:unixtime(),
	case lists:keyfind(?ACTIVE_KEY, 1, Extra) of
		false ->
			NewExtra = lists:keystore(?ACTIVE_KEY, 1, Extra, {?ACTIVE_KEY, [{ActiveId, 0, 0, NowTime}]}),
			NewGuildInfo = GuildInfo#db_guild{extra = NewExtra};
		{_, List} ->
			List1 = lists:keystore(ActiveId, 1, List, {ActiveId, 0, 0, NowTime}),
			NewExtra = lists:keystore(?ACTIVE_KEY, 1, Extra, {?ACTIVE_KEY, List1}),
			NewGuildInfo = GuildInfo#db_guild{extra = NewExtra}
	end,

	guild_cache:replace(NewGuildInfo),
	guild_cache:save_guild_info_to_ets(NewGuildInfo),

	NewGuildInfo.

%% 添加活动挑战次数
add_active_count(GuildInfo, ActiveId) ->
	Extra = GuildInfo#db_guild.extra,
	NowTime = util_date:unixtime(),
	case get_active_info(GuildInfo, ActiveId) of
		[] ->
			NewExtra = lists:keystore(?ACTIVE_KEY, 1, Extra, {?ACTIVE_KEY, [{ActiveId, 1, 0, NowTime}]}),
			NewGuildInfo = GuildInfo#db_guild{extra = NewExtra};
		{C, I, _} ->
			{_, List} = lists:keyfind(?ACTIVE_KEY, 1, Extra),
			List1 = lists:keystore(ActiveId, 1, List, {ActiveId, C + 1, I, NowTime}),
			NewExtra = lists:keystore(?ACTIVE_KEY, 1, Extra, {?ACTIVE_KEY, List1}),
			NewGuildInfo = GuildInfo#db_guild{extra = NewExtra}
	end,

	guild_cache:replace(NewGuildInfo),
	guild_cache:save_guild_info_to_ets(NewGuildInfo),

	NewGuildInfo.

%% 活动进入条件检测
check_guild_active_cond_list(_State, _GuildInfo, []) ->
	{ok, true};
check_guild_active_cond_list(State, GuildInfo, [H|T]) ->
	case check_guild_active_cond(State, GuildInfo, H) of
		{ok, true} ->
			check_guild_active_cond_list(State, GuildInfo, T);
		{fail, Reply} ->
			{fail, Reply}
	end.

check_guild_active_cond(_State, GuildInfo, {guild_lv, LimitLv}) ->
	case GuildInfo#db_guild.lv >= LimitLv of
		true ->
			{ok, true};
		false ->
			{fail, ?ERR_GUILD_LV_NOT_ENOUGH}
	end;
check_guild_active_cond(_State, GuildInfo, {guild_capital, Val}) ->
	case GuildInfo#db_guild.capital >= Val of
		true ->
			{ok, true};
		false ->
			{fail, ?ERR_GUILD_CAPITAL_NOT_ENOUGH}
	end;
check_guild_active_cond(State, _GuildInfo, {player_lv, LimitLv}) ->
	DbBase = State#player_state.db_player_base,
	case DbBase#db_player_base.lv >= LimitLv of
		true ->
			{ok, true};
		false ->
			{fail, ?ERR_PLAYER_LV_NOT_ENOUGH}
	end;
check_guild_active_cond(State, _GuildInfo, is_sbk) ->
	case city_lib:is_competence(State, ?SCENEID_SHABAKE) of
		true ->
			{ok, true};
		false ->
			{fail, ?ERR_GUILD_NOT_SBK_CITY}
	end;
check_guild_active_cond(State, GuildInfo, is_guild_hz) ->
	PlayerId = State#player_state.player_id,
	GuildId = GuildInfo#db_guild.guild_id,
	case player_guild_cache:get_player_guild_info_from_ets(PlayerId, GuildId) of
		[] ->
			{fail, ?ERR_GUILD_NOT_EXIST};
		PlayerGuildInfo ->
			case PlayerGuildInfo#db_player_guild.position > ?FU_HUIZHANG of
				true ->
					{fail, ?ERR_GUILD_COMPETENCE};
				_ ->
					{ok, true}
			end
	end;
check_guild_active_cond(_State, _GuildInfo, _Other) ->
	?DEBUG("not defined cond arameter in guild_active: ~p",[_Other]),
	{fail, ?ERR_COMMON_FAIL}.

%% 获取行会boss红点提示
get_guild_boss_button_tips(PlayerState) ->
	check_button_tips(PlayerState, 1).

%% 获取行会秘境红点提示
get_guild_mj_button_tips(PlayerState) ->
	check_button_tips(PlayerState, 4).

%% 获取行会沙巴克秘境红点提示
get_sbk_mj_button_tips(PlayerState) ->
	CityId = city_lib:get_scene_city_guild_id(),
	DbBase = PlayerState#player_state.db_player_base,
	GuildId = DbBase#db_player_base.guild_id,
	{State, _Time} = get_sbk_fem_state(CityId),
	case CityId == GuildId of
		true ->
			case State == 1 of
				true ->
					check_button_tips(PlayerState, 5);
				false ->
					{PlayerState, 0}
			end;
		false ->
			{PlayerState, 0}
	end.

check_button_tips(PlayerState, ActiveId) ->
	DbBase = PlayerState#player_state.db_player_base,
	GuildId = DbBase#db_player_base.guild_id,
	case guild_cache:get_guild_info_from_ets(GuildId) of
		[] ->
			{PlayerState, 0};
		GuildInfo ->
			ActConf = guild_active_config:get(ActiveId),
			OpenLimit = ActConf#guild_active_conf.enter_limit,
			case check_guild_active_cond_list(PlayerState, GuildInfo, OpenLimit) of
				{ok, _} ->
					case is_open_active(ActiveId) of
						{ok, _TimeStamp} ->
							{PlayerState, 1};
						{fail, _Reply} ->
							{PlayerState, 0}
					end;
				{fail, _Reply} ->
					{PlayerState, 0}
			end
	end.

%% 红点推送给行会成员
send_active_button_to_guild(NoticId) ->
	case NoticId of
		?NOTICE_GUILD_BOSS ->
			send_active_button_to_guild_1(?BTN_GUILD_BOSS);
		?NOTICE_GUILD_MJ ->
			send_active_button_to_guild_1(?BTN_GUILD_MJ);
		_ ->
			skip
	 end.

send_active_button_to_guild_1(TipsId) ->
	Fun = fun(PlayerPid) ->
				gen_server2:cast(PlayerPid, {update_button_tips, TipsId})
		  end,
	PlayerList = player_lib:get_online_players(),
	[Fun(EtsOnline#ets_online.pid) || EtsOnline <- PlayerList].