%%%-------------------------------------------------------------------
%%% @author tuhujia
%%% @copyright (C) 2015, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 13. 八月 2015 10:46
%%%-------------------------------------------------------------------
-module(red_guild_lib).

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
-include("notice_config.hrl").

-define(REDTYPE1, 1).%% 手气红包
-define(REDTYPE2, 2).%% 定额红包

-define(RED_GUILD, 21).%% 工会红包
-define(NOTICE_JADE, 100).%% 公告红包需要元宝数

-define(GUILD_TIME, 2000).%% 一小时执行一次

-define(GUILD_RED_PAGE_NUM, 20).
-define(GUILD_RED_LOG_PAGE_NUM, 20).
%% 工会红包
%% API
-export([
	get_guild_red_info_list/3,
	get_guild_red_log_list/2,
	send_red_guild/5,
	do_send_red_info1/3,
	do_receive_red_guild/3,
	receive_red_guild/2,
	init/0,
	do_send_red_guild/2,
	on_timer/1
]).
%% 初始
init() ->
	RedState = #red_guild_state{
		red_guild_record_list = red_record_db:select_all()
	},

	gen_server2:apply_after(?GUILD_TIME, self(), {?MODULE, on_timer, []}),
	{ok, RedState}.
%% 定时器
on_timer(RedState) ->
	CurTime = util_date:unixtime(),
	OldList = [X || X <- RedState#red_guild_state.red_guild_record_list, X#db_red_record.end_time < CurTime, X#db_red_record.jade > X#db_red_record.loss_jade],
	%%?ERR("11 ~p",[RedState#red_guild_state.red_guild_record_list]),
	F = fun(X, List) ->
		Goodslist = [{?GOODS_ID_JADE, 0, X#db_red_record.jade - X#db_red_record.loss_jade}],
		mail_lib:send_mail_to_player(X#db_red_record.player_id, <<"">>, xmerl_ucs:to_utf8("行会红包元宝返还"), xmerl_ucs:to_utf8("您发放的行会红包24小时内未被全部领取，返还剩余元宝，请查收附件"), Goodslist),
		NewRedInfo = X#db_red_record{
			loss_jade = X#db_red_record.jade,
			loss_num = X#db_red_record.num
		},
		red_record_cache:update(X#db_red_record.red_id, NewRedInfo),

		lists:delete(X, List)
	end,
	NewList = lists:foldr(F, RedState#red_guild_state.red_guild_record_list, OldList),
	RedState1 = RedState#red_guild_state{
		red_guild_record_list = NewList
	},
	gen_server2:apply_after(?GUILD_TIME, self(), {?MODULE, on_timer, []}),
	{ok, RedState1}.

%% 获取帮派红包列表
get_guild_red_info_list(GuildId, PlayerId, LastRedId) ->
	RedList = red_record_db:select_all({GuildId, LastRedId}),
	F = fun(X) ->
		%% 红包当前状态  0正常，1，已结领取过了，2，已结领取完了 3,已超时
		State = case player_red_cache:select_row(PlayerId, X#db_red_record.red_id) of
					null ->
						case X#db_red_record.loss_num >= X#db_red_record.num of
							true ->
								2;
							_ ->
								0
						end;
					_ ->
						1
				end,
		#proto_guild_red_info{
			red_id = X#db_red_record.red_id,
			name = X#db_red_record.name,
			num = X#db_red_record.num,
			position = X#db_red_record.position,
			des = X#db_red_record.des,
			state = State
		}
	end,
	[F(X) || X <- RedList].

%% 获取帮派红包记录列表
get_guild_red_log_list(GuildId, LastRedId) ->
	RedLogList = player_red_db:select_all({GuildId, LastRedId}),
	F = fun(X) ->
		#proto_guild_red_log{
			id = X#db_player_red.id,
			name = player_id_name_lib:get_player_name(X#db_player_red.player_id),
			jade = X#db_player_red.jade
		}
	end,
	[F(X) || X <- RedLogList].

%% 发送工会红包
send_red_guild(PlayerState, Jade, Num,Des, RedTypeId) ->
	DbMoney = PlayerState#player_state.db_player_money,
	Base = PlayerState#player_state.db_player_base,
	MemberNum = guild_lib:get_guild_member_num(PlayerState),

	SendJade = case RedTypeId of
				   ?REDTYPE1 ->
					   Jade;
				   ?REDTYPE2 ->
					   Jade * Num;
				   _ ->
					   0
			   end,

	case DbMoney#db_player_money.jade < SendJade orelse SendJade < 1 orelse Num < 1 orelse Num > MemberNum of
		true ->
			if
				SendJade < 1 orelse Num < 1 ->
					{fail, ?LANGUEGE_CITY_SCENE8};%% 元宝不足
				Num > MemberNum ->
					{fail, ?ERR_RED5};%% 元宝不足
				true ->
					{fail, ?ERR_PLAYER_JADE_NOT_ENOUGH}
			end;
		_ ->
			case SendJade < Num of
				true ->
					{fail, ?ERR_RED8};%%
				_ ->

					case Base#db_player_base.guild_id < 1 of
						true ->
							{fail, ?ERR_PLAYER_NOT_JOINED_GUILD};
						_ ->
							GuildName = guild_lib:get_guild_name(Base#db_player_base.guild_id),
							PlayerName = Base#db_player_base.name,
							case player_guild_cache:get_player_guild_info_from_ets(PlayerState#player_state.player_id, Base#db_player_base.guild_id) of
								[] ->
									{fail, ?ERR_PLAYER_NOT_JOINED_GUILD};
								PlayerGuildInfo ->
									ActiveServiceConf = active_service_config:get(?RED_GUILD),
									NoticeInfo = io_lib:format(ActiveServiceConf#active_service_conf.info, [util_data:to_list(GuildName), util_data:to_list(PlayerName), util_data:to_list(SendJade)]),
									RedGuildInfo = #db_red_record{
										player_id = PlayerState#player_state.player_id,
										position = PlayerGuildInfo#db_player_guild.position,
										guild_id = Base#db_player_base.guild_id,
										red_id = uid_lib:get_uid(?UID_TYPE_RED_RECORD),
										jade = SendJade,
										num = Num,
										red_type_id = RedTypeId,
										loss_jade = 0,
										loss_num = 0,
										name = Base#db_player_base.name,
										begin_time = util_date:unixtime(),
										des = Des,
										end_time = util_date:unixtime() + ?DAY_TIME_COUNT
									},
									red_record_cache:insert(RedGuildInfo),
									%% 添加红包
									gen_server2:apply_async(misc:whereis_name({local, red_guild_mod}), {?MODULE, do_send_red_guild, [RedGuildInfo]}),

									%%日志
									GuildId = PlayerGuildInfo#db_player_guild.guild_id,
									Name = PlayerGuildInfo#db_player_guild.name,
									guild_cache:update_guild_log_list(GuildId, 6, util_date:unixtime(), Name, SendJade),

									%% 发送公告 告知其他帮会成员
									send_red_info(RedGuildInfo, NoticeInfo, Base#db_player_base.guild_id),
									player_lib:incval_on_player_money_log(PlayerState, #db_player_money.jade, -SendJade, ?LOG_TYPE_RED_TYPE_GUILD)
							end
					end
			end
	end.
%% 添加红包
do_send_red_guild(RedState, RedGuildInfo) ->
	NewList = [RedGuildInfo | RedState#red_guild_state.red_guild_record_list],
	NewRedState = RedState#red_guild_state{
		red_guild_record_list = NewList
	},
	{ok, NewRedState}.


%% 领取工会红包
receive_red_guild(PlayerState, RedId) ->
	case gen_server2:apply_sync(misc:whereis_name({local, red_guild_mod}), {?MODULE, do_receive_red_guild, [PlayerState#player_state.db_player_base, RedId]}) of
		{fail, Err} ->
			{fail, Err};
		{ok, PlayerRedInfo} ->
			send_red_log(PlayerState, PlayerRedInfo),
			{ok, PlayerState1} = player_lib:incval_on_player_money_log(PlayerState, #db_player_money.jade, PlayerRedInfo#db_player_red.jade, ?LOG_TYPE_RED_TYPE_GUILD),
			{ok, PlayerState1, PlayerRedInfo#db_player_red.jade}
	end.
%% 领取工会红包
do_receive_red_guild(RedState, Base, RedId) ->
	case lists:keyfind(RedId, #db_red_record.red_id, RedState#red_guild_state.red_guild_record_list) of
		false ->
			{fail, ?ERR_RED1};%% 该红包已经消失了
		RedInfo ->
			case RedInfo#db_red_record.guild_id /= Base#db_player_base.guild_id orelse RedInfo#db_red_record.end_time < util_date:unixtime() of
				true ->
					{fail, ?ERR_RED1};%% 该红包已经消失了
				_ ->
					case RedInfo#db_red_record.loss_num >= RedInfo#db_red_record.num of
						true ->
							{fail, ?ERR_RED2};%% 该红包已经被领取完了
						_ ->
							case player_red_cache:select_row(Base#db_player_base.player_id, RedId) of
								null ->
									NeedJade = get_jade(RedInfo),
									case NeedJade =:= 0 of
										true ->
											{fail, ?ERR_RED2};%% 该红包已经被领取完了
										_ ->
											PlayerRedInfo = #db_player_red{
												id = uid_lib:get_uid(?UID_TYPE_PLAYER_RED),
												red_id = RedId,
												guild_id = Base#db_player_base.guild_id,
												time = util_date:unixtime(),
												player_id = Base#db_player_base.player_id,
												jade = NeedJade
											},
											player_red_db:insert(PlayerRedInfo),
											%% 修改红包领取信息
											NewRedInfo = RedInfo#db_red_record{
												loss_num = RedInfo#db_red_record.loss_num + 1,
												loss_jade = RedInfo#db_red_record.loss_jade + NeedJade
											},
											red_record_cache:update(RedId, NewRedInfo),

											NewList = lists:keyreplace(RedId, #db_red_record.red_id, RedState#red_guild_state.red_guild_record_list, NewRedInfo),
											%% 更新状态
											RedState1 = RedState#red_guild_state{
												red_guild_record_list = NewList
											},
											{ok, PlayerRedInfo, RedState1}
									end;
								_ ->
									{fail, ?ERR_RED3} %% 你已经领取过该红包了
							end
					end
			end
	end.

%% *********************************************************************
%% 发送公告以及推送红包信息
send_red_info(RedInfo, NoticeInfo, GuildId) ->
	case RedInfo#db_red_record.jade >= ?NOTICE_JADE of
		true ->
			notice_lib:send_notice(0, ?NOTICE_BACK, [NoticeInfo]);
		_ ->
			skip
	end,
	PlayerList = guild_lib:get_online_players(GuildId),
	Proto = #proto_guild_red_info{
		red_id = RedInfo#db_red_record.red_id,
		name = RedInfo#db_red_record.name,
		num = RedInfo#db_red_record.num,
		position = RedInfo#db_red_record.position,
		des = RedInfo#db_red_record.des,
		state = 0
	},
	RedBin = net_send:get_bin(17066, #rep_send_guild_red_info{red_info = Proto}),%% 新的行会红包信息 在红包界面推送
	NewRedBin = net_send:get_bin(17068, #rep_send_guild_red{}),%% 有行会红包，图标闪烁
	[send_red_info1(X#ets_online.player_id, RedBin, NewRedBin) || X <- PlayerList].
%% 发送新的 红包日志信息
send_red_log(PlayerState, PlayerRedInfo) ->
	Base = PlayerState#player_state.db_player_base,
	PlayerList = guild_lib:get_online_players(Base#db_player_base.guild_id),
	Proto = #proto_guild_red_log{
		id = PlayerRedInfo#db_player_red.id,
		name = Base#db_player_base.name,
		jade = PlayerRedInfo#db_player_red.jade
	},
	NewRedLogBin = net_send:get_bin(17067, #rep_send_guild_red_log{red_log = Proto}),%%新的红包领取日志
	[send_red_info1(X#ets_online.player_id, NewRedLogBin, null) || X <- PlayerList].

%% 发送工会红包信息
send_red_info1(Playerid, RedBin, NewRedBin) ->
	case player_lib:get_player_pid(Playerid) of
		null ->
			skip;
		PId ->
			gen_server2:apply_async(PId, {?MODULE, do_send_red_info1, [RedBin, NewRedBin]})
	end.
%% 发送工会红包信息
do_send_red_info1(PlayerState, RedBin, NewRedBin) ->
	case PlayerState#player_state.is_guild_red of
		false ->
			case NewRedBin /= null of
				true ->
					net_send:send_one(PlayerState#player_state.socket, NewRedBin);
				_ ->
					skip
			end;
		_ ->
			net_send:send_one(PlayerState#player_state.socket, RedBin)
	end.

%% *****************************
get_jade(RedInfo) ->
	case RedInfo#db_red_record.red_type_id of
		?REDTYPE1 ->
			case RedInfo#db_red_record.num - RedInfo#db_red_record.loss_num of
				1 ->
					RedInfo#db_red_record.jade - RedInfo#db_red_record.loss_jade;
				_ ->
					TempJade = RedInfo#db_red_record.jade - RedInfo#db_red_record.loss_jade - RedInfo#db_red_record.num,
					case TempJade > 0 of
						true ->
							1 + random:uniform(TempJade);
						_ ->
							1
					end
			end;
		?REDTYPE2 ->
			RedInfo#db_red_record.jade div RedInfo#db_red_record.num;
		_ ->
			0
	end.