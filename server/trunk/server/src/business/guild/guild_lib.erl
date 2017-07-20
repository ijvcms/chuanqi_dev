%%%-------------------------------------------------------------------
%%% @author tuhujia
%%% @copyright (C) 2015, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 13. 八月 2015 10:46
%%%-------------------------------------------------------------------
-module(guild_lib).

-include("common.hrl").
-include("record.hrl").
-include("proto.hrl").
-include("cache.hrl").
-include("db_record.hrl").
-include("config.hrl").
-include("uid.hrl").
-include("language_config.hrl").
-include("button_tips_config.hrl").
-include("log_type_config.hrl").
-include("gameconfig_config.hrl").

%% API
-export([
	init_guild/0,
	on_player_login/1,
	on_player_logout/1,
	create_guild/3,
	apply_guild/2,
	agree_join_guild/2,
	refuse_join_guild/2,
	leave_guild/1,
	disband_guild/1,
	player_join_guild/2,
	create_player_guild_info/4,
	update_guild_info/1,
	update_player_guild_info/1,
	update_player_join_guild_info/1,
	get_guild_total_num/0,
	get_apply_guild_list_lengh/1,
	get_apply_guild_list/3,
	get_guild_fight_limit/1,
	set_guild_fight_limit/2,
	get_proto_guild_info_list/2,
	get_proto_player_guild_info/1,
	get_proto_guild_detailed_info/1,
	get_proto_guild_member_list/3,
	get_guild_member_num/1,
	get_proto_guild_log/1,
	get_online_players/1,
	get_online_players_postion/2,
	get_guild_name/1,
	get_guild_lv/1,
	get_guild_chief_id/1,
	get_apply_list_button_tips/1,
	set_guild_announce/2,
	set_guild_position/3,
	set_huizhang/2,
	delete_player_guild_info/2,
	delete_member_guild_info/1,
	clear_apply_lists/1,
	remove_guild_member/2,
	push_player_guild_info/2,
	push_proto_guild_detailed_info/2,
	push_player_leave_guild/1,
	broadcast_guild_info_change/1,
	send_guild_ask/2,
	agree_guild_ask/2,
	send_apply_list_button_tips/1,
	send_mail_to_all_member/2,
	get_guild_apply_button_tips/1,
	guild_leader_idlist/1,
	get_guild_info/1
]).

%% 创建帮派需要的等级
-define(CREATE_LV, 35).
%% 创建帮派需要金币
-define(CREATE_COIN, 0).
%% 创建帮派需要元宝
-define(CREATE_JADE, 0).
%% 最大申请列表
-define(MAX_APPLY_LIST, 50).

%% 副会长人数
-define(MAX_FHZ_NUM, 1).
%% 长老人数
-define(MAX_ZL_NUM, 3).
%% 精英人数
-define(MAX_JY_NUM, 5).
%% 初始化公告
-define(INIT_CONTENT, xmerl_ucs:to_utf8("1.每天捐献3次,提升行会等级;\n2.每天参加行会BOSS,有极品装备掉落;\n3.每周准时参加攻沙,无兄弟不传奇!")).

%% ====================================================================
%% API functions
%% ====================================================================

%% 初始帮派数据
init_guild() ->
	%% 帮派数据
	load_db_guild_info(),
	%% 玩家帮派数据
	load_db_player_guild_info(),
	ok.

load_db_guild_info() ->
	case guild_cache:select_all() of
		[] ->
			[];
		List ->
			Fun = fun(DbGuild, Acc) ->
				guild_cache:save_guild_info_to_ets(DbGuild),
				Acc ++ [DbGuild#db_guild.guild_id]
			end,
			lists:foldl(Fun, [], List)
	end.

load_db_player_guild_info() ->
	case player_guild_cache:select_all() of
		[] ->
			skip;
		List ->
			Fun = fun(DbPlayerGuild) ->
				player_guild_cache:save_player_guild_to_ets(DbPlayerGuild)
			end,
			[Fun(X) || X <- List]
	end.

%% 玩家登陆(上线检测更新战斗力,等级)
on_player_login(State) ->
	PlayerId = State#player_state.player_id,
	case player_guild_cache:select_row(PlayerId) of
		#db_player_guild{} = PlayerGuildInfo ->

			DbBase = State#player_state.db_player_base,
			%% OldGuildId = DbBase#db_player_base.guild_id,
			GuildId = PlayerGuildInfo#db_player_guild.guild_id,
			DbBase = State#player_state.db_player_base,
			OldGuildId = DbBase#db_player_base.guild_id,
			%% 更细基础属性
			PlayerGuildInfo1 = PlayerGuildInfo#db_player_guild{
				lv = DbBase#db_player_base.lv,
				fight = State#player_state.fighting,
				sex = DbBase#db_player_base.sex
			},
			player_guild_cache:replace(PlayerGuildInfo1),
			player_guild_cache:save_player_guild_to_ets(PlayerGuildInfo1),
			{ok, State1} =
				case OldGuildId =:= GuildId of
					true ->
						{ok, State};
					false ->
						Update = #player_state
						{
							db_player_base = #db_player_base
							{
								guild_id = GuildId
							}
						},
						player_lib:update_player_state(State, Update)
				end,

			push_player_guild_info(State, PlayerGuildInfo1),

			State1;
		_ ->
			%% 玩家没有加入行会
			Update = #player_state
			{
				db_player_base = #db_player_base
				{
					guild_id = 0
				}
			},
			{ok, State1} = player_lib:update_player_state(State, Update),
			net_send:send_to_client(State#player_state.socket, 17011, #rep_get_guild_member_info{player_guild_info = #proto_player_guild_info{}}),
			State1
	end.

%% 玩家退出
on_player_logout(State) ->
	PlayerId = State#player_state.player_id,
	DbBase = State#player_state.db_player_base,
	GuildId = DbBase#db_player_base.guild_id,
	case player_guild_cache:get_player_guild_info_from_ets(PlayerId, GuildId) of
		#db_player_guild{} = PlayerGuildInfo ->
			%% 更细基础属性
			PlayerGuildInfo1 = PlayerGuildInfo#db_player_guild{
				lv = DbBase#db_player_base.lv,
				fight = State#player_state.fighting,
				sex = DbBase#db_player_base.sex
			},
			%% player_guild_cache:replace(PlayerGuildInfo1),
			player_guild_cache:save_player_guild_to_ets(PlayerGuildInfo1);
		_ ->
			skip
	end.

%% 获取玩家帮派信息
get_proto_player_guild_info(State) ->
	PlayerId = State#player_state.player_id,
	DbBase = State#player_state.db_player_base,
	GuildId = DbBase#db_player_base.guild_id,
	case player_guild_cache:get_player_guild_info_from_ets(PlayerId, GuildId) of
		#db_player_guild{} = PlayerGuildInfo ->
			DbGuild = guild_cache:get_guild_info_from_ets(GuildId),

			#proto_player_guild_info{
				guild_id = GuildId,
				guild_name = PlayerGuildInfo#db_player_guild.guild_name,
				position = PlayerGuildInfo#db_player_guild.position,
				contribution = PlayerGuildInfo#db_player_guild.contribution,
				guild_lv = DbGuild#db_guild.lv
			};
		_ ->
			#proto_player_guild_info{}
	end.

%% 获取帮派详细信息
get_proto_guild_detailed_info(State) ->
	DbBase = State#player_state.db_player_base,
	GuildId = DbBase#db_player_base.guild_id,
	case guild_cache:get_guild_info_from_ets(GuildId) of
		#db_guild{} = GuildInfo ->
			#proto_guild_detailed_info{
				guild_id = GuildId,
				guild_name = GuildInfo#db_guild.guild_name,
				chairman_name = GuildInfo#db_guild.chief_name,
				guild_lv = GuildInfo#db_guild.lv,
				guild_rank = GuildInfo#db_guild.rank,
				number = GuildInfo#db_guild.member_count,
				exp = GuildInfo#db_guild.expe,
				capital = GuildInfo#db_guild.capital,
				announce = GuildInfo#db_guild.internal_announce
			};
		_ ->
			#proto_guild_detailed_info{}
	end.

%% 推送行会详细信息
push_proto_guild_detailed_info(State, GuildInfo) ->
	Proto = #proto_guild_detailed_info{
		guild_id = GuildInfo#db_guild.guild_id,
		guild_name = GuildInfo#db_guild.guild_name,
		chairman_name = GuildInfo#db_guild.chief_name,
		guild_lv = GuildInfo#db_guild.lv,
		guild_rank = GuildInfo#db_guild.rank,
		number = GuildInfo#db_guild.member_count,
		exp = GuildInfo#db_guild.expe,
		capital = GuildInfo#db_guild.capital,
		announce = GuildInfo#db_guild.internal_announce
	},
	net_send:send_to_client(State#player_state.socket, 17010, #rep_guild_detailed_info{guild_detailed_info = Proto}).

%% 创建帮派
create_guild(State, GuildName, IsJade) ->
	case check_create_guild(State, GuildName, IsJade) of
		{ok, _Reply} ->
			GuildId = create_guild_info(State, GuildName),
			create_player_guild_info(State, GuildId, GuildName, ?HUIZHANG),

			PlayerBase = State#player_state.db_player_base,
			PlayerBase1 = PlayerBase#db_player_base{guild_id = GuildId},
			State1 = State#player_state{db_player_base = PlayerBase1},
			player_lib:update_player_state(State, State1),

			{ok, State2} = case IsJade of
							   1 ->
								   GoodsConf = goods_config:get(?ITEM_CREATE_GUILD),
								   %% 扣除元宝
								   player_lib:incval_on_player_money_log(State1, #db_player_money.jade, -GoodsConf#goods_conf.price_jade, ?LOG_TYPE_CREATE_GUILD);
							   _ ->
								   %% 扣除道具
								   goods_lib_log:delete_goods_by_num(State, ?ITEM_CREATE_GUILD, 1, ?LOG_TYPE_CREATE_GUILD),
								   {ok, State1}
						   end,

			update_guild_rank(),
			%% 更新行会日志
			DbBase = State#player_state.db_player_base,
			Name = DbBase#db_player_base.name,
			%%guild_cache:update_guild_log_list(GuildId, 1, util_date:unixtime(), Name, 0),

			%% 红点检测
			button_tips_lib:ref_button_tips(State2, ?BTN_GUILD_CONTRIBUTION),

			guild_cache:update_guild_log_list(GuildId, 10, util_date:unixtime(), Name, 0),

			%% 扣除金币
			player_lib:incval_on_player_money_log(State2, #db_player_money.coin, -?CREATE_COIN, ?LOG_TYPE_CREATE_GUILD);
		{fail, Reply} ->
			{fail, Reply}
	end.

%% 申请加入帮派
apply_guild(State, GuildId) ->
	case check_apply_guild(State, GuildId) of
		{ok, _} ->
			Args = [GuildId, State],
			guild_mod:update_guild(GuildId, fun guild_cache:update_guild_apply_list/2, Args),
			{ok, ?ERR_COMMON_SUCCESS};
		{fail, Reply} ->
			{fail, Reply}
	end.

%% 获取申请列表长度
get_apply_guild_list_lengh(State) ->
	PlayerId = State#player_state.player_id,
	DbBase = State#player_state.db_player_base,
	GuildId = DbBase#db_player_base.guild_id,
	case player_guild_cache:get_player_guild_info_from_ets(PlayerId, GuildId) of
		[] ->
			0;
		PlayerGuildInfo ->
			case PlayerGuildInfo#db_player_guild.position =:= ?HUIZHANG of
				true ->
					ApplyList = guild_cache:get_guild_apply_list(GuildId),
					Len = length(ApplyList),
					Len;
				false ->
					0
			end
	end.

%% 获取申请列表
get_apply_guild_list(State, Min, Max) when Min > 0 andalso Max > 0 andalso Max > Min ->
	PlayerId = State#player_state.player_id,
	DbBase = State#player_state.db_player_base,
	GuildId = DbBase#db_player_base.guild_id,
	case player_guild_cache:get_player_guild_info_from_ets(PlayerId, GuildId) of
		[] ->
			[];
		PlayerGuildInfo ->
			case PlayerGuildInfo#db_player_guild.position =< ?FU_HUIZHANG of
				true ->
					%% 红点通知
					button_tips_lib:send_button_tips(State, ?BTN_GUILD_APPLY_LIST, 0),
					get_proto_info_by_apply_guild(GuildId, Min, Max);
				false ->
					[]
			end
	end.

%% 同意加入帮派
agree_join_guild(State, ApplyId) ->
	case check_agree_join_guild(State, ApplyId) of
		{ok, [GuildInfo, ApplyInfo]} ->
			GuildId = GuildInfo#db_guild.guild_id,
			Args = [ApplyInfo, GuildId],
			guild_mod:update_guild(GuildId, fun guild_lib:player_join_guild/2, Args),
			{ok, ?ERR_COMMON_SUCCESS};
		{fail, Reply} ->
			{fail, Reply}
	end.

%% 拒绝加入帮派
refuse_join_guild(State, ApplyId) ->
	DbBase = State#player_state.db_player_base,
	GuildId = DbBase#db_player_base.guild_id,
	guild_cache:delete_guild_apply_list_by_apply_id(GuildId, ApplyId),
	{ok, ?ERR_COMMON_SUCCESS}.

%% 退出帮派
leave_guild(State) ->
	DbBase = State#player_state.db_player_base,
	GuildId = DbBase#db_player_base.guild_id,
	case GuildId =/= 0 of
		true ->
			Args = [State, GuildId],
			guild_mod:update_guild(GuildId, fun guild_lib:delete_player_guild_info/2, Args),

			PlayerBase = State#player_state.db_player_base,
			PlayerBase1 = PlayerBase#db_player_base{guild_id = 0},
			State1 = State#player_state{db_player_base = PlayerBase1},
			player_lib:update_player_state(State, State1),

			%% 更新计数器
			PlayerId = State#player_state.player_id,
			counter_lib:update(PlayerId, ?GUILD_JOIN_TIME_LIMIT_COUNTER),

			%% 推送红点检测
			button_tips_lib:ref_button_tips(State1, ?BTN_GUILD_CONTRIBUTION),

			%% 退出帮派推送
			guild_lib:push_player_leave_guild(State1),

			{ok, State1};
		false ->
			{fail, ?ERR_PLAYER_NOT_JOINED_GUILD}
	end.

%% 解散帮派
disband_guild(State) ->
	DbBase = State#player_state.db_player_base,
	GuildId = DbBase#db_player_base.guild_id,
	Args = [State, GuildId],
	guild_mod:update_guild(GuildId, fun guild_lib:delete_player_guild_info/2, Args),
	delete_guild_info(GuildId),

	%% 解散帮派 沙巴克相关处理
	city_lib:delele_city_info(GuildId),

	PlayerBase = State#player_state.db_player_base,
	PlayerBase1 = PlayerBase#db_player_base{guild_id = 0},
	State1 = State#player_state{db_player_base = PlayerBase1},

	%% 更新计数器
	PlayerId = State#player_state.player_id,
	counter_lib:update(PlayerId, ?GUILD_JOIN_TIME_LIMIT_COUNTER),

	%% 推送红点检测
	button_tips_lib:ref_button_tips(State1, ?BTN_GUILD_CONTRIBUTION),

	%% 推送
	push_player_leave_guild(State1),
	{ok, State1}.

%% 获取帮派总数
get_guild_total_num() ->
	ets:info(?ETS_GUILD, size).

%% 获取帮派战力限制数值
get_guild_fight_limit(GuildId) ->
	case guild_cache:get_guild_info_from_ets(GuildId) of
		[] ->
			{fail, ?ERR_GUILD_NOT_EXIST};
		GuildInfo ->
			Fight = get_guild_fight(GuildInfo),
			{ok, Fight}
	end.

%% 设置帮派战斗力限制
set_guild_fight_limit(State, Fight) ->
	PlayerBase = State#player_state.db_player_base,
	GuildId = PlayerBase#db_player_base.guild_id,
	case guild_cache:get_guild_info_from_ets(GuildId) of
		[] ->
			{fail, ?ERR_GUILD_NOT_EXIST};
		GuildInfo ->
			PlayerId = State#player_state.player_id,
			case player_guild_cache:get_player_guild_info_from_ets(PlayerId, GuildId) of
				[] ->
					{fail, ?ERR_GUILD_NOT_EXIST};
				PlayerGuildInfo ->
					case PlayerGuildInfo#db_player_guild.position > ?FU_HUIZHANG of
						true ->
							{fail, ?ERR_GUILD_COMPETENCE};
						_ ->
							update_guild_fight(GuildInfo, Fight),
							{ok, ?ERR_COMMON_SUCCESS}
					end
			end
	end.

%% 获取帮派列表
get_proto_guild_info_list(MinValue, MaxValue) ->
	List = ets:tab2list(?ETS_GUILD),
	SortList = lists:keysort(#db_guild.lv, List),
	RankList = lists:reverse(SortList),
	Len = length(RankList),
	Fun = fun(N, Acc) ->
		case N > Len of
			true -> Acc;
			false ->
				GuildInfo = lists:nth(N, RankList),
				%% 行会排名更细检测
				case GuildInfo#db_guild.rank =:= N of
					true ->
						skip;
					false ->
						GuildInfo1 = GuildInfo#db_guild{rank = N},
						update_guild_info(GuildInfo1)
				end,

				Proto =
					#proto_guild_info{
						guild_id = GuildInfo#db_guild.guild_id,
						guild_rank = N,
						guild_name = GuildInfo#db_guild.guild_name,
						chairman_name = GuildInfo#db_guild.chief_name,
						guild_lv = GuildInfo#db_guild.lv,
						fight = get_guild_fight(GuildInfo),
						number = GuildInfo#db_guild.member_count
					},
				Acc ++ [Proto]
		end
	end,
	lists:foldl(Fun, [], lists:seq(MinValue, MaxValue)).

%% 获取玩家申请信息记录
get_proto_info_by_apply_guild(GuildId, Min, Max) ->
	ApplyList = guild_cache:get_guild_apply_list(GuildId),
	Len = length(ApplyList),
	Fun = fun(N, Acc) ->
		case N > Len of
			true -> Acc;
			false ->
				{PlayerId, Name, Lv, Career, Fighting} = lists:nth(N, ApplyList),
				Proto =
					#proto_apply_guild_info{
						player_id = PlayerId,
						player_name = Name,
						lv = Lv,
						career = Career,
						fighting = Fighting,
						online = case player_lib:is_online(PlayerId) of true -> 1; false -> 0 end
					},
				Acc ++ [Proto]
		end
	end,
	lists:foldl(Fun, [], lists:seq(Min, Max)).

%% 获取帮派成员信息列表
get_proto_guild_member_list(State, Min, Max) ->
	DbBase = State#player_state.db_player_base,
	GuildId = DbBase#db_player_base.guild_id,
	Memberlist = guild_cache:get_guild_member_list_from_ets(GuildId),
	Len = length(Memberlist),
	Fun = fun(N, Acc) ->
		case N > Len of
			true -> Acc;
			false ->
				PlayerGuildInfo = lists:nth(N, Memberlist),
				Proto = #proto_guild_member_info{
					player_id = PlayerGuildInfo#db_player_guild.player_id,
					player_name = PlayerGuildInfo#db_player_guild.name,
					position = PlayerGuildInfo#db_player_guild.position,
					lv = PlayerGuildInfo#db_player_guild.lv,
					career = PlayerGuildInfo#db_player_guild.career,
					fighting = PlayerGuildInfo#db_player_guild.fight,
					contribution = PlayerGuildInfo#db_player_guild.totoal_contribution
				},
				Acc ++ [Proto]
		end
	end,
	lists:foldl(Fun, [], lists:seq(Min, Max)).

%% 获取帮派成员数量
get_guild_member_num(State) ->
	DbBase = State#player_state.db_player_base,
	GuildId = DbBase#db_player_base.guild_id,
	player_guild_cache:get_guild_member_num_from_ets(GuildId).

%% 设置行会公告
set_guild_announce(State, Content) ->
	case check_guild_content(State, Content) of
		{ok, GuildInfo} ->
			update_guild_info(GuildInfo#db_guild{internal_announce = Content}),
			{ok, ?ERR_COMMON_SUCCESS};
		{fail, Reply} ->
			{fail, Reply}
	end.

%% 清空申请列表
clear_apply_lists(State) ->
	case is_huizhang(State) of
		{ok, GuildInfo} ->
			guild_cache:clear_guild_apply_list(GuildInfo#db_guild.guild_id),
			{ok, ?ERR_COMMON_SUCCESS};
		{fail, Reply} ->
			{fail, Reply}
	end.

%% 剔除公会成员
remove_guild_member(State, PlayerId) ->
	case check_remove_guild_member(State, PlayerId) of
		{ok, GuildInfo, DbPlayerGuild} ->
			GuildId = GuildInfo#db_guild.guild_id,
			Args = [DbPlayerGuild],
			guild_mod:update_guild(GuildId, fun guild_lib:delete_member_guild_info/1, Args),
			{ok, ?ERR_COMMON_SUCCESS};
		{fail, Reply} ->
			{fail, Reply}
	end.

%% 委任职位
set_guild_position(State, PlayerId, Position) ->
	case check_set_position(State, Position, PlayerId) of
		{ok, GuildInfo, DbPlayerGuild} ->
			GuildId = GuildInfo#db_guild.guild_id,
			Args = [DbPlayerGuild#db_player_guild{position = Position}],
			guild_mod:update_guild(GuildId, fun guild_lib:update_player_join_guild_info/1, Args),

			%% 更新行会日志
			Name = DbPlayerGuild#db_player_guild.name,
			guild_cache:update_guild_log_list(GuildId, 5, util_date:unixtime(), Name, Position),

			{ok, ?ERR_COMMON_SUCCESS};
		{fail, Reply} ->
			{fail, Reply}
	end.

%% 委任会长
set_huizhang(State, PlayerId) ->
	case is_huizhang(State) of
		{ok, GuildInfo} ->
			GuildId = GuildInfo#db_guild.guild_id,
			case player_guild_cache:get_player_guild_info_from_ets(PlayerId, GuildId) of
				#db_player_guild{} = DbPlayerGuild ->
					ChirfName = DbPlayerGuild#db_player_guild.name,
					NewGuildInfo = GuildInfo#db_guild{chief_name = ChirfName, chief_id = PlayerId},
					update_guild_info(NewGuildInfo),

					%% 推送会长信息
					Args = [DbPlayerGuild#db_player_guild{position = ?HUIZHANG}],
					guild_mod:update_guild(GuildId, fun guild_lib:update_player_join_guild_info/1, Args),

					%% 玩家更新为普通会员
					PGInfo = player_guild_cache:get_player_guild_info_from_ets(State#player_state.player_id, GuildId),
					PGInfo1 = PGInfo#db_player_guild{position = ?HUIYUAN},
					update_player_guild_info(PGInfo1),
					push_player_guild_info(State, PGInfo1),

					%% 更新行会日志
					guild_cache:update_guild_log_list(GuildId, 5, util_date:unixtime(), ChirfName, ?HUIZHANG),

					%% 沙巴克相应处理
					city_lib:update_city_Santo(GuildId),
					{ok, ?ERR_COMMON_SUCCESS};
				_ ->
					{fail, ?ERR_COMMON_FAIL}
			end;
		{fail, Reply} ->
			{fail, Reply}
	end.

%% 获取帮派名称
get_guild_name(GuildId) ->
	case guild_cache:get_guild_info_from_ets(GuildId) of
		[] ->
			"";
		R ->
			R#db_guild.guild_name
	end.

%% 获取帮派等级
get_guild_lv(GuildId) ->
	case guild_cache:get_guild_info_from_ets(GuildId) of
		[] ->
			0;
		R ->
			R#db_guild.lv
	end.

%% 获取帮主id
get_guild_chief_id(GuildId) ->
	case guild_cache:get_guild_info_from_ets(GuildId) of
		[] ->
			0;
		R ->
			R#db_guild.chief_id
	end.

%% 获取公会日志
get_proto_guild_log(GuildId) ->
	LogList = guild_cache:get_guild_log_list(GuildId),
	Fun = fun({Type, Param1, Param2, Param3}) ->
		#proto_guild_log_info{
			type = Type,
			parameter1 = Param1,
			parameter2 = Param2,
			parameter3 = Param3
		}
	end,
	[Fun(X) || X <- LogList].

%% ====================================================================
%% 外部调用扩展函数
%% ====================================================================

%% 获取在线玩家
get_online_players(GuildId) ->
	MemberList = guild_cache:get_guild_member_list_from_ets(GuildId),
	Fun = fun(PGInfo, Acc) ->
		PlayerId = PGInfo#db_player_guild.player_id,
		case ets:lookup(?ETS_ONLINE, PlayerId) of
			[EtsOnline] ->
				[EtsOnline] ++ Acc;
			_ ->
				Acc
		end
	end,
	lists:foldl(Fun, [], MemberList).

%% 获取在线玩家
get_online_players_postion(GuildId, Postion) ->
	MemberList = guild_cache:get_guild_member_list_from_ets(GuildId),
	Fun = fun(PGInfo, Acc) ->
		PlayerId = PGInfo#db_player_guild.player_id,
		case PGInfo#db_player_guild.position =< Postion of
			true ->
				case ets:lookup(?ETS_ONLINE, PlayerId) of
					[EtsOnline] ->
						[EtsOnline] ++ Acc;
					_ ->
						Acc
				end;
			_ ->
				Acc
		end
	end,
	lists:foldl(Fun, [], MemberList).

%% 推送行会最新信息给行会所有在线玩家
broadcast_guild_info_change(GuildInfo) ->
	GuildId = GuildInfo#db_guild.guild_id,
	Fun = fun(EtsOnline) ->
		PlayerId = EtsOnline#ets_online.player_id,
		PlayerGuildInfo = player_guild_cache:get_player_guild_info_from_ets(PlayerId, GuildId),
		Proto = #proto_player_guild_info{
			guild_id = GuildId,
			position = PlayerGuildInfo#db_player_guild.position,
			contribution = PlayerGuildInfo#db_player_guild.contribution,
			guild_lv = GuildInfo#db_guild.lv,
			guild_name = GuildInfo#db_guild.guild_name
		},
		net_send:send_to_client(EtsOnline#ets_online.socket, 17011, #rep_get_guild_member_info{player_guild_info = Proto})
	end,
	[Fun(X) || X <- get_online_players(GuildId)].

guild_leader_idlist(GuildId) ->
	Memberlist = guild_cache:get_guild_member_list_from_ets(GuildId),
	[M#db_player_guild.player_id || M <- Memberlist, M#db_player_guild.position < 3].

get_guild_info(GuildId) ->
	case guild_cache:get_guild_info_from_ets(GuildId) of
		[] ->
			null;
		R ->
			R
	end.


%% ====================================================================
%% Internal functions
%% ====================================================================

%% 获取唯一id
get_guild_uid() ->
	uid_lib:get_uid(?UID_TYPE_GUILD).

%% 创建帮派条件检测
check_create_guild(State, GuildName, IsJade) ->
	case util:loop_functions(
		none,
		[fun(_)
			->
			NameLen = utf8_length(GuildName),
			case NameLen >= 1 andalso NameLen =< 12 of
				true -> {continue, none};
				false -> {break, ?ERR_GUILD_NAME_LEN_LIMIT}
			end
		end,
			fun(_) ->
				case check_guild_name(GuildName) andalso not util_string:check_name(GuildName) of
					true -> {continue, none};
					false -> {break, ?ERR_GUILD_NAME_ERROR}
				end
			end,
			fun(_) ->
				PlayerBase = State#player_state.db_player_base,
				Lv = PlayerBase#db_player_base.lv,
				case Lv >= ?CREATE_LV of
					true ->
						{continue, PlayerBase};
					false ->
						{break, ?ERR_GUILD_NOT_ENOUGH_35LV}
				end
			end,
			fun(PlayerBase) ->
				PlayerBase = State#player_state.db_player_base,
				GuildId = PlayerBase#db_player_base.guild_id,
				case GuildId =/= 0 of
					true ->
						{break, ?ERR_PLAYER_JOINED_GUILD};
					false ->
						{continue, none}
				end
			end,
			fun(_) ->
				PlayerMoney = State#player_state.db_player_money,
				Coin = PlayerMoney#db_player_money.coin,
				case Coin >= ?CREATE_COIN of
					true ->
						{continue, PlayerMoney};
					false ->
						{break, ?ERR_PLAYER_COIN_NOT_ENOUGH}
				end
			end,
			fun(PlayerMoney) ->
				PlayerMoney = State#player_state.db_player_money,
				Jade = PlayerMoney#db_player_money.jade,
				case Jade >= ?CREATE_JADE of
					true ->
						{continue, none};
					false ->
						{break, ?ERR_PLAYER_JADE_NOT_ENOUGH}
				end
			end,
			fun(_) ->
				PlayerId = State#player_state.player_id,
				case is_leave_guild_24_hours(PlayerId) of
					true -> {continue, none};
					false -> {break, ?ERR_GUILD_LEAVE_NOT_ENOUGH_24_HOURS}
				end
			end,
			fun(_) ->
				case is_guild_name_valid(GuildName) of
					false -> {continue, none};
					true -> {break, ?ERR_GUILD_NAME_SAME}
				end
			end,
			fun(_) ->
				PlayerMoney = State#player_state.db_player_money,
				GoodsConf = goods_config:get(?ITEM_CREATE_GUILD),
				case IsJade of
					1 ->
						%% 如果是直接使用元宝，那么就直接判断元宝
						Jade = PlayerMoney#db_player_money.jade,
						case Jade >= GoodsConf#goods_conf.price_jade of
							true ->
								{continue, none};
							false ->
								{break, ?ERR_PLAYER_JADE_NOT_ENOUGH}
						end;
					_ ->
						%% 否则判断道具
						case goods_lib:get_goods_num(?ITEM_CREATE_GUILD) > 0 of
							false ->
								{break, {?ERR_GOODS_NOT_ENOUGH, GoodsConf#goods_conf.price_jade}};
							true ->
								{continue, none}
						end
				end
			end
		]) of
		{break, Reply} -> {fail, Reply};
		{ok, Value} ->
			{ok, Value}
	end.

%% 申请加入帮派检测
check_apply_guild(State, GuildId) ->
	case util:loop_functions(
		none,
		[fun(_) ->
			PlayerId = State#player_state.player_id,
			case is_leave_guild_24_hours(PlayerId) of
				true -> {continue, none};
				false -> {break, ?ERR_GUILD_LEAVE_NOT_ENOUGH_24_HOURS}
			end
		end,
			fun(_) ->
				PlayerBase = State#player_state.db_player_base,
				Lv = PlayerBase#db_player_base.lv,
				case Lv >= ?CREATE_LV of
					true ->
						{continue, none};
					false ->
						{break, ?ERR_GUILD_NOT_ENOUGH_35LV}
				end
			end,
			fun(_) ->
				case guild_cache:get_guild_info_from_ets(GuildId) of
					[] ->
						{break, ?ERR_GUILD_NOT_EXIST};
					GuildInfo ->
						{continue, GuildInfo}
				end
			end,
			fun(GuildInfo) ->
				Extra = GuildInfo#db_guild.extra,
				case lists:keyfind(fight, 1, Extra) of
					false ->
						{continue, GuildInfo};
					{fight, Fight} ->
						case State#player_state.fighting >= Fight of
							true -> {continue, GuildInfo};
							false -> {break, ?ERR_PLAYER_FIGHT_NOT_ENOUGH}
						end
				end
			end,
			fun(GuildInfo) ->
				case check_guild_member_limit(GuildInfo) of
					true ->
						{continue, none};
					false ->
						{break, ?ERR_GUILD_MEMBER_ENOUGH}
				end
			end,
			fun(_) ->
				ApplyList = guild_cache:get_guild_apply_list(GuildId),
				case length(ApplyList) >= ?MAX_APPLY_LIST of
					true ->
						{break, ?ERR_GUILD_APPLY_ENOUGH};
					false ->
						{continue, none}
				end
			end
		]) of
		{break, Reply} -> {fail, Reply};
		{ok, Value} ->
			{ok, Value}
	end.

check_agree_join_guild(State, ApplyId) ->
	DbBase = State#player_state.db_player_base,
	GuildId = DbBase#db_player_base.guild_id,
	case util:loop_functions(
		none,
		[fun(_) ->
			case guild_cache:get_guild_info_from_ets(GuildId) of
				[] ->
					{break, ?ERR_GUILD_NOT_EXIST};
				GuildInfo ->
					{continue, GuildInfo}
			end
		end,
			fun(GuildInfo) ->
				case player_guild_cache:get_player_guild_info_from_ets(State#player_state.player_id, GuildId) of
					[] ->
						{break, ?ERR_GUILD_COMPETENCE};
					PlayerGuildInfo ->
						case PlayerGuildInfo#db_player_guild.position > ?ZHANGLAO of
							true ->
								{break, ?ERR_GUILD_COMPETENCE};
							_ ->
								{continue, GuildInfo}
						end
				end
			end,
			fun(GuildInfo) ->
				case check_guild_member_limit(GuildInfo) of
					true ->
						{continue, GuildInfo};
					false ->
						{break, ?ERR_GUILD_MEMBER_ENOUGH}
				end
			end,
			fun(GuildInfo) ->
				ApplyList = guild_cache:get_guild_apply_list(GuildId),
				case lists:keyfind(ApplyId, 1, ApplyList) of
					false ->
						{break, ?ERR_APPLIST_NOT_EXIST};
					ApplyInfo ->
						{continue, [GuildInfo, ApplyInfo]}
				end
			end,
			fun([GuildInfo, ApplyInfo]) ->
				case is_join_guild(ApplyId) of
					true ->
						guild_cache:delete_guild_apply_list_by_apply_id(GuildId, ApplyId),
						{break, ?ERR_PLAYER_JOINED_GUILD};
					false ->
						{continue, [GuildInfo, ApplyInfo]}
				end
			end
		]) of
		{break, Reply} -> {fail, Reply};
		{ok, Value} ->
			{ok, Value}
	end.

%% 工会设置检测
check_guild_content(State, Content) ->
	DbBase = State#player_state.db_player_base,
	GuildId = DbBase#db_player_base.guild_id,
	case util:loop_functions(
		none,
		[fun(_) ->
			NameLen = utf8_length(Content),
			case NameLen >= 1 andalso NameLen =< 50 of
				true -> {continue, none};
				false -> {break, ?ERR_GUILD_NAME_LEN_LIMIT}
			end
		end,
			fun(_) ->
				case guild_cache:get_guild_info_from_ets(GuildId) of
					[] ->
						{break, ?ERR_GUILD_NOT_EXIST};
					GuildInfo ->
						{continue, GuildInfo}
				end
			end,
			fun(GuildInfo) ->
				case player_guild_cache:get_player_guild_info_from_ets(State#player_state.player_id, GuildId) of
					[] ->
						{break, ?ERR_GUILD_COMPETENCE};
					PlayerGuildInfo ->
						case PlayerGuildInfo#db_player_guild.position > ?FU_HUIZHANG of
							true ->
								{break, ?ERR_GUILD_COMPETENCE};
							_ ->
								{continue, GuildInfo}
						end
				end
			end
		]) of
		{break, Reply} -> {fail, Reply};
		{ok, Value} ->
			{ok, Value}
	end.

%% 检查设置职位
check_set_position(State, Position, MemberId) ->
	DbBase = State#player_state.db_player_base,
	GuildId = DbBase#db_player_base.guild_id,
	case util:loop_functions(
		none,
		[fun(_) ->
			case guild_cache:get_guild_info_from_ets(GuildId) of
				[] ->
					{break, ?ERR_GUILD_NOT_EXIST};
				GuildInfo ->
					{continue, GuildInfo}
			end
		end,
			fun(GuildInfo) ->
				case Position =:= ?FU_HUIZHANG orelse Position =:= ?JINGYING orelse Position =:= ?ZHANGLAO of
					true ->
						PosNum = guild_cache:get_position_num(GuildId, Position),
						GuildLv = GuildInfo#db_guild.lv,
						PosLimit = get_position_limit(Position, GuildLv),
						case PosNum < PosLimit of
							true ->
								{continue, GuildInfo};
							false ->
								{break, ?ERR_GUILD_POSITION}
						end;
					false ->
						{continue, GuildInfo}
				end
			end,
			fun(GuildInfo) ->
				GuildId = GuildInfo#db_guild.guild_id,
				case player_guild_cache:get_player_guild_info_from_ets(MemberId, GuildId) of
					#db_player_guild{} = DbPlayerGuild ->
						{continue, {GuildInfo, DbPlayerGuild}};
					_ ->
						{break, ?ERR_COMMON_FAIL}
				end
			end,
			fun({GuildInfo, DbPlayerGuild}) ->
				case player_guild_cache:get_player_guild_info_from_ets(State#player_state.player_id, GuildId) of
					#db_player_guild{} = PlayerGuildInfo ->
						PlayerPos = PlayerGuildInfo#db_player_guild.position,
						MemberPos = DbPlayerGuild#db_player_guild.position,
						case PlayerPos =< ?ZHANGLAO andalso PlayerPos < MemberPos of
							true ->
								{continue, {GuildInfo, DbPlayerGuild}};
							false ->
								{break, ?ERR_GUILD_COMPETENCE}
						end;
					_ ->
						{break, ?ERR_COMMON_FAIL}
				end
			end
		]) of
		{break, Reply} -> {fail, Reply};
		{ok, {X, Y}} ->
			{ok, X, Y}
	end.

%% 委任职位检测
is_huizhang(State) ->
	DbBase = State#player_state.db_player_base,
	GuildId = DbBase#db_player_base.guild_id,
	case util:loop_functions(
		none,
		[fun(_) ->
			case guild_cache:get_guild_info_from_ets(GuildId) of
				[] ->
					{break, ?ERR_GUILD_NOT_EXIST};
				GuildInfo ->
					{continue, GuildInfo}
			end
		end,
			fun(GuildInfo) ->
				ChiefId = GuildInfo#db_guild.chief_id,
				PlayerId = State#player_state.player_id,
				case ChiefId =:= PlayerId of
					true ->
						{continue, GuildInfo};
					false ->
						{break, ?ERR_PLAYER_NOT_HUIZHANG}
				end
			end
		]) of
		{break, Reply} -> {fail, Reply};
		{ok, Value} ->
			{ok, Value}
	end.

%% 检测踢出成员
check_remove_guild_member(State, MemberId) ->
	DbBase = State#player_state.db_player_base,
	GuildId = DbBase#db_player_base.guild_id,
	case util:loop_functions(
		none,
		[fun(_) ->
			case guild_cache:get_guild_info_from_ets(GuildId) of
				[] ->
					{break, ?ERR_GUILD_NOT_EXIST};
				GuildInfo ->
					{continue, GuildInfo}
			end
		end,
			fun(GuildInfo) ->
				GuildId = GuildInfo#db_guild.guild_id,
				case player_guild_cache:get_player_guild_info_from_ets(MemberId, GuildId) of
					#db_player_guild{} = DbPlayerGuild ->
						{continue, {GuildInfo, DbPlayerGuild}};
					_ ->
						{break, ?ERR_COMMON_FAIL}
				end
			end,
			fun({GuildInfo, DbPlayerGuild}) ->
				case player_guild_cache:get_player_guild_info_from_ets(State#player_state.player_id, GuildId) of
					#db_player_guild{} = PlayerGuildInfo ->
						PlayerPos = PlayerGuildInfo#db_player_guild.position,
						MemberPos = DbPlayerGuild#db_player_guild.position,
						case PlayerPos =< ?ZHANGLAO andalso PlayerPos < MemberPos of
							true ->
								{continue, {GuildInfo, DbPlayerGuild}};
							false ->
								{break, ?ERR_GUILD_COMPETENCE}
						end;
					_ ->
						{break, ?ERR_COMMON_FAIL}
				end
			end
		]) of
		{break, Reply} -> {fail, Reply};
		{ok, {X, Y}} ->
			{ok, X, Y}
	end.

create_guild_info(State, GuildName) ->
	GuildId = get_guild_uid(),
	PlayerId = State#player_state.player_id,
	PlayerBase = State#player_state.db_player_base,
	Name = PlayerBase#db_player_base.name,
	NowTime = util_date:unixtime(),

	GuildInfo = #db_guild{
		guild_id = GuildId,
		guild_name = GuildName,
		chief_id = PlayerId,
		chief_name = Name,
		state = 0,
		rank = 0,
		member_count = 1,
		lv = 1,
		expe = 0,
		active = 0,
		capital = 0,
		public_announce = "",
		internal_announce = ?INIT_CONTENT,
		extra = [],
		create_time = NowTime,
		update_time = NowTime
	},

	guild_cache:replace(GuildInfo),
	guild_cache:save_guild_info_to_ets(GuildInfo),
	GuildId.

create_player_guild_info(State, GuildId, GuildName, Pos) ->
	PlayerId = State#player_state.player_id,
	PlayerBase = State#player_state.db_player_base,
	Name = PlayerBase#db_player_base.name,
	Career = PlayerBase#db_player_base.career,
	Lv = PlayerBase#db_player_base.lv,
	Sex = PlayerBase#db_player_base.sex,
	Fight = State#player_state.fighting,
	NowTime = util_date:unixtime(),

	PlayerGuildInfo =
		#db_player_guild{
			player_id = PlayerId,
			name = Name,
			guild_id = GuildId,
			career = Career,
			sex = Sex,
			lv = Lv,
			guild_name = GuildName,
			position = Pos,
			fight = Fight,
			contribution = 0,
			totoal_contribution = 0,
			extra = [],
			join_time = NowTime,
			login_time = NowTime,
			update_time = NowTime
		},

	player_guild_cache:replace(PlayerGuildInfo),
	player_guild_cache:save_player_guild_to_ets(PlayerGuildInfo),
	%% 推送行会信息
	push_player_guild_info(State, PlayerGuildInfo).

%% 玩家加入帮派处理
add_player_join_guild_info(ApplyInfo, GuildInfo) ->
	{ApplyId, Name, Lv, Career, Fighting} = ApplyInfo,
	%% 帮派处理
	NewGuildInfo = GuildInfo#db_guild{member_count = 1 + GuildInfo#db_guild.member_count},
	guild_cache:replace(NewGuildInfo),
	guild_cache:save_guild_info_to_ets(NewGuildInfo),

	%% 玩家处理
	GuildId = GuildInfo#db_guild.guild_id,
	GuildName = GuildInfo#db_guild.guild_name,
	Pos = ?HUIYUAN,
	NowTime = util_date:unixtime(),
	case player_lib:get_player_pid(ApplyId) of
		null ->
			PlayerGuildInfo =
				#db_player_guild{
					player_id = ApplyId,
					name = Name,
					guild_id = GuildId,
					career = Career,
					sex = 0,
					lv = Lv,
					guild_name = GuildName,
					position = Pos,
					fight = Fighting,
					contribution = 0,
					totoal_contribution = 0,
					extra = [],
					join_time = NowTime,
					login_time = NowTime,
					update_time = NowTime
				},
			player_guild_cache:replace(PlayerGuildInfo),
			player_guild_cache:save_player_guild_to_ets(PlayerGuildInfo),
			guild_cache:delete_guild_apply_list_by_apply_id(GuildId, ApplyId);
		PlayerPid ->
			guild_cache:delete_guild_apply_list_by_apply_id(GuildId, ApplyId),
			gen_server2:cast(PlayerPid, {join_guild, GuildId, GuildName, Pos})
	end,
	%% 检测以前日志信息
	city_lib:add_city_member(ApplyId, GuildId),
	%% 更新行会日志
	guild_cache:update_guild_log_list(GuildId, 1, NowTime, Name, 0).

update_player_join_guild_info(PlayerGuildInfo) ->
	%% 玩家处理
	PlayerId = PlayerGuildInfo#db_player_guild.player_id,
	player_guild_cache:replace(PlayerGuildInfo),
	player_guild_cache:save_player_guild_to_ets(PlayerGuildInfo),

	%% 沙巴克相应修改
	city_lib:update_city_member_office(PlayerId, PlayerGuildInfo#db_player_guild.guild_id, PlayerGuildInfo#db_player_guild.position),
	case player_lib:get_player_pid(PlayerId) of
		null ->
			skip;
		PlayerPid ->
			gen_server2:cast(PlayerPid, {boradcast_player_guild_info, PlayerGuildInfo})
	end.

delete_player_guild_info(State, GuildId) ->
	PlayerId = State#player_state.player_id,
	GuildInfo = guild_cache:get_guild_info_from_ets(GuildId),
	NewMemberCount = GuildInfo#db_guild.member_count - 1,
	GuildInfo1 = GuildInfo#db_guild{member_count = NewMemberCount},

	case NewMemberCount =:= 0 of
		true ->
			%% 退出联盟
			alliance_lib:alliance_exit(GuildId),
			guild_cache:delete(GuildId),
			guild_cache:delete_guild_info_from_ets(GuildId);
		false ->
			guild_cache:replace(GuildInfo1),
			guild_cache:save_guild_info_to_ets(GuildInfo1)
	end,
	player_guild_cache:delete(PlayerId),
	player_guild_cache:delete_player_guild_info_from_ets(PlayerId, GuildId),
	%% 更新行会日志
	DbBase = State#player_state.db_player_base,
	Name = DbBase#db_player_base.name,
	guild_cache:update_guild_log_list(GuildId, 2, util_date:unixtime(), Name, 0),


	%% 退出帮派 沙巴克相关处理
	city_lib:update_city_member(PlayerId, GuildId).

delete_member_guild_info(PlayerGuildInfo) ->
	PlayerId = PlayerGuildInfo#db_player_guild.player_id,
	GuildId = PlayerGuildInfo#db_player_guild.guild_id,
	GuildInfo = guild_cache:get_guild_info_from_ets(GuildId),
	NewMemberCount = GuildInfo#db_guild.member_count - 1,
	GuildInfo1 = GuildInfo#db_guild{member_count = NewMemberCount},

	case NewMemberCount =:= 0 of
		true ->
			guild_cache:delete(GuildId),
			guild_cache:delete_guild_info_from_ets(GuildId);
		false ->
			guild_cache:replace(GuildInfo1),
			guild_cache:save_guild_info_to_ets(GuildInfo1)
	end,
	player_guild_cache:delete(PlayerId),
	player_guild_cache:delete_player_guild_info_from_ets(PlayerId, GuildId),

	case player_lib:get_player_pid(PlayerId) of
		null ->
			skip;
		PlayerPid ->
			gen_server2:cast(PlayerPid, {leave_guild})
	end,

	%% 退出帮派 沙巴克相关处理
	city_lib:update_city_member(PlayerId, GuildId),
	%% 更新行会日志
	guild_cache:update_guild_log_list(GuildId, 3, util_date:unixtime(), PlayerGuildInfo#db_player_guild.name, 0).

delete_guild_info(GuildId) ->
	guild_cache:delete(GuildId).

update_guild_info(Info) ->
	guild_cache:replace(Info),
	guild_cache:save_guild_info_to_ets(Info).

update_player_guild_info(Info) ->
	player_guild_cache:replace(Info),
	player_guild_cache:save_player_guild_to_ets(Info).

player_join_guild(ApplyInfo, GuildId) ->
	%% 再次检测公会成员是否已满
	case guild_cache:get_guild_info_from_ets(GuildId) of
		[] ->
			skip;
		GuildInfo ->
			case check_guild_member_limit(GuildInfo) of
				true ->
					add_player_join_guild_info(ApplyInfo, GuildInfo);
				false ->
					skip
			end
	end.

get_guild_fight(GuildInfo) ->
	Extra = GuildInfo#db_guild.extra,
	case lists:keyfind(fight, 1, Extra) of
		false ->
			0;
		{fight, Fight} ->
			Fight
	end.

update_guild_fight(GuildInfo, Fight) ->
	Extra = GuildInfo#db_guild.extra,
	NewExtra = lists:keystore(fight, 1, Extra, {fight, Fight}),
	NewGuildInfo = GuildInfo#db_guild{extra = NewExtra},

	guild_cache:replace(NewGuildInfo),
	guild_cache:save_guild_info_to_ets(NewGuildInfo).

%% 检测玩家是否加入帮派
is_join_guild(PlayerId) ->
	case player_guild_cache:select_row(PlayerId) of
		#db_player_guild{} = PlayerGuildInfo ->
			PlayerGuildInfo#db_player_guild.guild_id =/= 0;
		_ ->
			false
	end.

check_guild_member_limit(GuildInfo) ->
	GuildLv = GuildInfo#db_guild.lv,
	GuildConf = guild_config:get(GuildLv),
	GuildMemberLimit = GuildConf#guild_conf.member_limit,
	MemberNum = GuildInfo#db_guild.member_count,
	MemberNum < GuildMemberLimit.

%% 推送玩家行会信息
push_player_guild_info(State, PlayerGuildInfo) ->
	GuildId = PlayerGuildInfo#db_player_guild.guild_id,
	DbGuild = guild_cache:get_guild_info_from_ets(GuildId),
	Proto = #proto_player_guild_info{
		guild_id = GuildId,
		position = PlayerGuildInfo#db_player_guild.position,
		contribution = PlayerGuildInfo#db_player_guild.contribution,
		guild_lv = DbGuild#db_guild.lv,
		guild_name = DbGuild#db_guild.guild_name
	},
	net_send:send_to_client(State#player_state.socket, 17011, #rep_get_guild_member_info{player_guild_info = Proto}).

%% 推送玩家离开行会
push_player_leave_guild(State) ->
	NowTime = util_date:unixtime(),
	Base = State#player_state.db_player_base,
	?INFO(" push_player_leave_guild ~p", [Base#db_player_base.guild_id]),
	active_task_lib:check_ref_guild_task(State, Base, NowTime, false),
	net_send:send_to_client(State#player_state.socket, 17011, #rep_get_guild_member_info{player_guild_info = #proto_player_guild_info{}}).

%% 创建帮会更细行会排名
update_guild_rank() ->
	List = ets:tab2list(?ETS_GUILD),
	SortList = lists:keysort(#db_guild.lv, List),
	RankList = lists:reverse(SortList),
	Len = length(RankList),
	Fun = fun(Rank, GuildInfo) ->
		%% 行会排名更细检测
		case GuildInfo#db_guild.rank =:= Rank of
			true ->
				skip;
			false ->
				GuildInfo1 = GuildInfo#db_guild{rank = Rank},
				update_guild_info(GuildInfo1)
		end
	end,
	[Fun(X, Y) || X <- lists:seq(1, Len), Y <- RankList, Len > 0].

%% 获取字符串长度("中文"->2)
utf8_length(Bin) when is_binary(Bin) ->
	length(unicode:characters_to_list(Bin, utf8)).

%% check_account_name(Name) ->
%% 	re:run(Name,"^[_0-9a-zA-Z]{4,14}$") =/= nomatch
%% 		andalso check_forbid_words(list_to_binary(Name)).

%% %% 检查敏感关键字
%% %% 无敏感关键字->true | 包含敏感关键字->false
%% check_forbid_words(Utf8) when is_binary(Utf8) ->
%% 	keyword_filter:check_keyword(Utf8).

%% 检查行会名字是否合法
check_guild_name(Name) ->
	U = unicode:characters_to_list(Name, utf8),
	lists:all(fun(X) when X > 127 -> true;
		(X) -> (X >= $0 andalso X =< $9) orelse (X >= $a andalso X =< $z) orelse (X >= $A andalso X =< $Z)
	end, U).

%% 检查行会名是否存在
is_guild_name_valid(GuildName) when is_binary(GuildName) ->
	F = fun(GuildInfo, Acc) ->
		case GuildInfo#db_guild.guild_name =:= GuildName of
			true -> Acc ++ [GuildInfo];
			false -> Acc
		end
	end,
	ets:foldl(F, [], ?ETS_GUILD) =/= [];
is_guild_name_valid(_GuildName) -> false.

%% 检查玩家退出帮派是否满24小时
is_leave_guild_24_hours(PlayerId) ->
	counter_lib:check(PlayerId, ?GUILD_JOIN_TIME_LIMIT_COUNTER).

%% 获取不同职位对应的人数限制
get_position_limit(Pos, GuildLv) ->
	case Pos of
		?FU_HUIZHANG ->
			?MAX_FHZ_NUM;
		?JINGYING ->
			?MAX_JY_NUM + GuildLv;
		?ZHANGLAO ->
			?MAX_ZL_NUM
	end.

%% ****************************************邀请加入帮会，对方同意逻辑
%%  邀请 检测
check_agree_join_guild_player(PlayerState, TPlayerId, GuildId) ->
	case util:loop_functions(
		none,
		[
			fun(_) ->
				case guild_cache:get_guild_info_from_ets(GuildId) of
					[] ->
						{break, ?ERR_GUILD_NOT_EXIST};
					GuildInfo ->
						{continue, GuildInfo}
				end
			end,
			fun(GuildInfo) ->
				case check_guild_member_limit(GuildInfo) of
					true ->
						{continue, GuildInfo};
					false ->
						{break, ?ERR_GUILD_MEMBER_ENOUGH}
				end
			end,
			fun(GuildInfo) ->
				case player_guild_cache:get_player_guild_info_from_ets(PlayerState#player_state.player_id, GuildId) of
					[] ->
						{break, ?ERR_GUILD_COMPETENCE};
					PlayerGuildInfo ->
						case PlayerGuildInfo#db_player_guild.position > ?ZHANGLAO of
							true ->
								{break, ?ERR_GUILD_COMPETENCE};
							_ ->
								{continue, GuildInfo}
						end
				end
			end,
			fun(GuildInfo) ->
				DbBase = player_base_cache:select_row(TPlayerId),
				case DbBase#db_player_base.guild_id > 0 of
					true ->
						{break, ?ERR_PLAYER_JOINED_GUILD};
					false ->
						{continue, GuildInfo}
				end
			end
		]) of
		{break, Reply} -> {fail, Reply};
		{ok, Value} -> {ok, Value}
	end.

%% 同意 检测
check_agree_join_guild_player(PlayerState, GuildId) ->
	case util:loop_functions(
		none,
		[
			fun(_) ->
				case guild_cache:get_guild_info_from_ets(GuildId) of
					[] ->
						{break, ?ERR_GUILD_NOT_EXIST};
					GuildInfo ->
						{continue, GuildInfo}
				end
			end,
			fun(GuildInfo) ->
				case check_guild_member_limit(GuildInfo) of
					true ->
						{continue, GuildInfo};
					false ->
						{break, ?ERR_GUILD_MEMBER_ENOUGH}
				end
			end,
			fun(GuildInfo) ->
				DbBase = PlayerState#player_state.db_player_base,
				case DbBase#db_player_base.guild_id > 0 of
					true ->
						{break, ?ERR_PLAYER_JOINED_GUILD};
					false ->
						Lv = DbBase#db_player_base.lv,
						case Lv >= ?CREATE_LV of
							true ->
								{continue, GuildInfo};
							false ->
								{break, ?ERR_GUILD_NOT_ENOUGH_35LV}
						end
				end
			end,
			fun(GuildInfo) ->
				PlayerId = PlayerState#player_state.player_id,
				case is_leave_guild_24_hours(PlayerId) of
					true -> {continue, GuildInfo};
					false -> {break, ?ERR_GUILD_LEAVE_NOT_ENOUGH_24_HOURS}
				end
			end
		]) of
		{break, Reply} -> {fail, Reply};
		{ok, Value} -> {ok, Value}
	end.

%% 发送邀请信息
send_guild_ask(PlayerState, TPlayerId) ->
	DBBase = PlayerState#player_state.db_player_base,
	case check_agree_join_guild_player(PlayerState, TPlayerId, DBBase#db_player_base.guild_id) of
		{ok, GuildInfo} ->
			Data = #rep_guild_ask_player_info{
				guild_id = GuildInfo#db_guild.guild_id,
				guild_name = GuildInfo#db_guild.guild_name,
				tname = DBBase#db_player_base.name
			},
			net_send:send_to_client(TPlayerId, 17055, Data),
			?ERR_COMMON_SUCCESS;
		{fail, Result} ->
			Result
	end.

%% 同意加入帮派
agree_guild_ask(State, GuildId) ->
	case check_agree_join_guild_player(State, GuildId) of
		{ok, _GuildInfo} ->
			Base = State#player_state.db_player_base,

			PlayerId = State#player_state.player_id,
			Name = Base#db_player_base.name,
			Lv = Base#db_player_base.lv,
			Career = Base#db_player_base.career,
			Fighting = State#player_state.fighting,

			ApplyInfo = {PlayerId, Name, Lv, Career, Fighting},
			Args = [ApplyInfo, GuildId],
			guild_mod:update_guild(GuildId, fun guild_lib:player_join_guild/2, Args),
			?ERR_COMMON_SUCCESS;
		{fail, Result} ->
			Result
	end.

%% 行会申请列表红点提示
get_apply_list_button_tips(PlayerState) ->
	PlayerId = PlayerState#player_state.player_id,
	DbBase = PlayerState#player_state.db_player_base,
	GuildId = DbBase#db_player_base.guild_id,
	case player_guild_cache:get_player_guild_info_from_ets(PlayerId, GuildId) of
		[] ->
			{PlayerState, 0};
		PlayerGuildInfo ->
			case PlayerGuildInfo#db_player_guild.position =< ?FU_HUIZHANG of
				true ->
					case guild_cache:get_guild_apply_list(GuildId) =/= [] of
						true ->
							{PlayerState, 1};
						false ->
							{PlayerState, 0}
					end;
				_ ->
					{PlayerState, 0}
			end
	end.

%% 申请加入帮派红点提示
send_apply_list_button_tips(MemberList) ->
	Fun = fun(DPG) ->
		case DPG#db_player_guild.position =< ?FU_HUIZHANG of
			true ->
				PlayerId = DPG#db_player_guild.player_id,
				case player_lib:get_player_pid(PlayerId) of
					null ->
						skip;
					PlayerPid ->
						gen_server2:cast(PlayerPid, {update_button_tips, ?BTN_GUILD_APPLY_LIST})
				end;
			_ ->
				skip
		end
	end,
	[Fun(X) || X <- MemberList].

%% 给行会所以成员发放邮件奖励
send_mail_to_all_member(GuildId, MailId) ->
	MemberList = guild_cache:get_guild_member_num_from_ets(GuildId),
	Fun = fun(DPG) ->
		mail_lib:send_mail_to_player(DPG#db_player_guild.player_id, MailId)
	end,
	[Fun(X) || X <- MemberList].

%% 行会申请按钮红点提示
get_guild_apply_button_tips(PlayerState) ->
	DPB = PlayerState#player_state.db_player_base,
	Lv = DPB#db_player_base.lv,
	GuildId = DPB#db_player_base.guild_id,
	case GuildId == 0 andalso Lv >= 35 of
		true ->
			{PlayerState, 1};
		false ->
			{PlayerState, 0}
	end.


