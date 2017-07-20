%%%-------------------------------------------------------------------
%%% @author tuhujia
%%% @copyright (C) 2015, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 05. 八月 2015 17:17
%%%-------------------------------------------------------------------
-module(mail_lib).
-include("common.hrl").
-include("record.hrl").
-include("config.hrl").
-include("cache.hrl").
-include("db_record.hrl").
-include("uid.hrl").
-include("proto.hrl").
-include("language_config.hrl").
-include("log_type_config.hrl").

-export([
	init_mail_conf/0,
	reload_mail_conf/0,
	on_player_login/1,
	on_player_logout/1,
	send_mail_to_player/2,
	send_mail_to_player/3,
	send_mail_to_player/5,
	send_text_mail_to_player/2,
	send_full_service_mail/2,
	get_mail_award/2,
	get_proto_mail_list/1,
	get_button_tips/1,
	remove_mail/2,
	add_full_service_mail/2
]).

%% 默认邮件保存7天
-define(SEVEN_DAY_TIMES, 7 * 24 * 3600).
%% 全服邮件到期时间
-define(LIMIT_FULL_SERVICE_TIMES, 1600000000).
%% 系统
-define(TYPE_SYSTEM_MAIL, 0).
%% 其他
-define(TYPE_OTHER_MAIL, 1).
%% 全服
-define(TYPE_FULL_SERVICE_MAIL, 2).

%%% ----------------------------------------------------------------------------
%%% 对外接口
%%% ----------------------------------------------------------------------------

%% 初始化邮件配置
init_mail_conf() ->
	%% 数据库加载全服与配置邮件
	case db:select_all(mail_conf, record_info(fields, ets_mail_conf), []) of
		[] ->
			null;
		List ->
			Fun = fun(Info) ->
				EtsInfo = list_to_tuple([ets_mail_conf | Info]),
				Award = util_data:string_to_term(EtsInfo#ets_mail_conf.award),
				mail_cache:save_mail_conf_to_ets(EtsInfo#ets_mail_conf{award = Award})
			end,
			[Fun(X) || X <- List]
	end,

	%% 配置表加载邮件
	Fun1 = fun(Conf) ->
		R = #ets_mail_conf
		{
			id = Conf#mail_conf.id, %% id类型
			mail_type = Conf#mail_conf.mail_type,
			sender = Conf#mail_conf.sender,
			title = Conf#mail_conf.title,
			content = Conf#mail_conf.content,
			award = Conf#mail_conf.award,
			active_time = Conf#mail_conf.active_time,
			update_time = Conf#mail_conf.update_time
		},
		mail_cache:save_mail_conf_to_ets(R)
	end,
	[Fun1(X) || X <- mail_config:get_list_conf()].

%% 重载邮件配置
reload_mail_conf() ->
	ets:delete_all_objects(?ETS_MAIL_CONF),
	init_mail_conf().

%% 初始化玩家邮件
on_player_login(PlayerId) ->
	case mail_cache:select_all(PlayerId) of
		[] ->
			check_full_service_mail(PlayerId, []);
		List ->
			check_full_service_mail(PlayerId, List),
			Fun = fun(DbInfo) ->
				init_mail_ets(DbInfo)
			end,
			[Fun(X) || X <- List]
	end.

init_mail_ets(DbInfo) ->
	Id = DbInfo#db_player_mail.id,
	PlayerId = DbInfo#db_player_mail.player_id,
	LimitTime = DbInfo#db_player_mail.limit_time,
	NowTime = util_date:unixtime(),
	case NowTime >= LimitTime of
		false ->
			EtsInfo = #ets_player_mail{
				key = {Id, PlayerId},
				mail_id = DbInfo#db_player_mail.mail_id,
				mail_type = DbInfo#db_player_mail.mail_type,
				sender = DbInfo#db_player_mail.sender,
				title = DbInfo#db_player_mail.title,
				content = DbInfo#db_player_mail.content,
				award = DbInfo#db_player_mail.award,
				state = DbInfo#db_player_mail.state,
				send_time = DbInfo#db_player_mail.send_time,
				limit_time = DbInfo#db_player_mail.limit_time,
				update_time = DbInfo#db_player_mail.update_time
			},
			mail_cache:save_player_mail_to_ets(EtsInfo);
		true ->
			mail_db:delete({Id, PlayerId}),
			mail_cache:remove_cache(Id, PlayerId)
	end.

%% 上线检测全服邮件
check_full_service_mail(PlayerId, List) ->
	ConfList = mail_cache:get_spec_mail_conf_from_ets(),
	Fun = fun(MailConf, MailList) ->
		case MailConf#ets_mail_conf.mail_type =:= 2 of
			true ->
				MailId = MailConf#ets_mail_conf.id,
				case lists:keyfind(MailId, #db_player_mail.mail_id, MailList) of
					false ->
						%% 发送全服邮件
						NowTime = util_date:unixtime(),
						Uid = get_mail_uid(),

						EtsInfo = #ets_player_mail{
							key = {Uid, PlayerId},
							mail_id = MailId,
							mail_type = 2,
							send_time = NowTime,
							limit_time = ?LIMIT_FULL_SERVICE_TIMES,
							update_time = NowTime
						},

						mail_cache:save_player_mail_to_ets(EtsInfo),
						Result = mail_cache:replace(EtsInfo),
						log_mail(PlayerId, EtsInfo),
						Result;
					_ ->
						skip
				end;
			false ->
				skip
		end
	end,
	[Fun(X, List) || X <- ConfList].

%% 玩家离线处理
on_player_logout(PlayerId) ->
	mail_cache:delete_player_mail_from_ets(PlayerId).

%% 给玩家发送配置邮件,支持跨服或本服
send_mail_to_player(undefined, PlayerId, MailId) ->
	send_mail_to_player(PlayerId, MailId);
send_mail_to_player(ServerPass, PlayerId, MainId) ->
	cross_lib:send_cross_mfc(ServerPass, mail_lib, send_mail_to_player, [PlayerId, MainId]).

%% 给玩家发送配置邮件
send_mail_to_player(PlayerPid, MainId) when is_pid(PlayerPid) ->
	gen_server2:apply_async(PlayerPid, {?MODULE, send_mail_to_player, [MainId]});
send_mail_to_player(PlayerState, MainId) when is_record(PlayerState, player_state) ->
	send_mail_to_player(PlayerState#player_state.player_id, MainId);
%% 给玩家发送配置邮件
send_mail_to_player(PlayerId, MailId) ->
	Uid = get_mail_uid(),
	NowTime = util_date:unixtime(),
	case mail_cache:get_mail_conf_by_id(MailId) of
		[] -> skip;
		_ ->
			EtsInfo = #ets_player_mail{
				key = {Uid, PlayerId},
				mail_id = MailId,
				send_time = NowTime,
				limit_time = NowTime + ?SEVEN_DAY_TIMES,
				update_time = NowTime
			},

			case player_lib:get_socket(PlayerId) of
				null ->
					mail_cache:replace(EtsInfo);
				Socket ->
					mail_cache:save_player_mail_to_ets(EtsInfo),
					mail_cache:replace(EtsInfo),
					broadcast_mail_info(Socket, EtsInfo)
			end,
			log_mail(PlayerId, EtsInfo)
	end.

%% 新增全服邮件
add_full_service_mail(Content, Award) ->
	NewId = case db:select_row(mail_conf, [id], [], [{id, desc}]) of
				[Max | _] -> Max + 1;
				_ -> 1
			end,
	db:insert(mail_conf, [{id, NewId}, {mail_type, 2}, {title, xmerl_ucs:to_utf8("系统邮件")},
		{content, Content}, {award, util_data:term_to_string(Award)}]),

	EtsMailInfo = #ets_mail_conf{
		id = NewId,
		mail_type = 2,
		sender = "",
		title = xmerl_ucs:to_utf8("系统邮件"),
		content = Content,
		award = Award,
		active_time = 0,
		update_time = 0
	},
	mail_cache:save_mail_conf_to_ets(EtsMailInfo).

%% 发送全服邮件
send_full_service_mail(State, MailId) ->
	PlayerId = State#player_state.player_id,
	Uid = get_mail_uid(),
	NowTime = util_date:unixtime(),
	EtsInfo = #ets_player_mail{
		key = {Uid, PlayerId},
		mail_id = MailId,
		mail_type = 2,
		send_time = NowTime,
		award = [],
		limit_time = ?LIMIT_FULL_SERVICE_TIMES,
		update_time = NowTime
	},

	mail_cache:save_player_mail_to_ets(EtsInfo),
	mail_cache:replace(EtsInfo).

%% 给玩家发送指定内容邮件
send_mail_to_player(PlayerId, Sender, Title, Concent, Award) ->
	Uid = get_mail_uid(),
	NowTime = util_date:unixtime(),
	EtsInfo = #ets_player_mail{
		key = {Uid, PlayerId},
		mail_type = 1,
		sender = Sender,
		title = Title,
		content = Concent,
		award = Award,
		send_time = NowTime,
		limit_time = NowTime + ?SEVEN_DAY_TIMES,
		update_time = NowTime
	},
	case player_lib:get_socket(PlayerId) of
		null ->
			mail_cache:replace_to_db(EtsInfo);
		Socket ->
			mail_cache:save_player_mail_to_ets(EtsInfo),
			mail_cache:replace(EtsInfo),
			broadcast_mail_info(Socket, EtsInfo)
	end,
	log_mail(PlayerId, EtsInfo).

%% 发送文字邮件
send_text_mail_to_player(PlayerId, Concent) ->
	Uid = get_mail_uid(),
	NowTime = util_date:unixtime(),
	EtsInfo = #ets_player_mail{
		key = {Uid, PlayerId},
		mail_type = 0,
		sender = "",
		title = xmerl_ucs:to_utf8("系统邮件"),
		content = Concent,
		award = [],
		state = 1,
		send_time = NowTime,
		limit_time = NowTime + ?SEVEN_DAY_TIMES,
		update_time = NowTime
	},

	case player_lib:get_socket(PlayerId) of
		null ->
			mail_cache:replace_to_db(EtsInfo);
		Socket ->
			mail_cache:save_player_mail_to_ets(EtsInfo),
			mail_cache:replace(EtsInfo),
			broadcast_mail_info(Socket, EtsInfo)
	end,
	log_mail(PlayerId, EtsInfo).

%% 收取邮件奖励
get_mail_award(State, Id) ->
	PlayerId = State#player_state.player_id,
	case mail_cache:get_player_mail_from_ets(Id, PlayerId) of
		[] ->
			{fail, ?ERR_COMMON_FAIL};
		MailInfo ->
			case MailInfo#ets_player_mail.state == 1 of
				true ->
					{fail, ?ERR_COMMON_FAIL};
				false ->
					Type = MailInfo#ets_player_mail.mail_type,
					get_mail_award_1(Type, State, MailInfo)
			end
	end.

%% 打开系统邮件
get_mail_award_1(?TYPE_SYSTEM_MAIL, State, MailInfo) ->
	MailId = MailInfo#ets_player_mail.mail_id,
	MailConf = mail_cache:get_mail_conf_by_id(MailId),
	AwardList = MailConf#ets_mail_conf.award,

	case goods_lib_log:add_goods_list(State, AwardList, ?LOG_TYPE_MAIL) of
		{ok, State1} ->
			MailInfo1 = MailInfo#ets_player_mail{state = 1},
			mail_cache:replace(MailInfo1),
			mail_cache:save_player_mail_to_ets(MailInfo1),
			broadcast_mail_info(State#player_state.socket, MailInfo1),
			{ok, State1};
		{fail, Reply} ->
			{fail, Reply}
	end;


%% 打开其他邮件
get_mail_award_1(?TYPE_OTHER_MAIL, State, MailInfo) ->
	AwardList = MailInfo#ets_player_mail.award,

	case goods_lib_log:add_goods_list(State, AwardList, ?LOG_TYPE_MAIL) of
		{ok, State1} ->
			MailInfo1 = MailInfo#ets_player_mail{state = 1},
			mail_cache:replace(MailInfo1),
			mail_cache:save_player_mail_to_ets(MailInfo1),
			broadcast_mail_info(State#player_state.socket, MailInfo1),
			{ok, State1};
		{fail, Reply} ->
			{fail, Reply}
	end;

%% 打开全服邮件
get_mail_award_1(?TYPE_FULL_SERVICE_MAIL, State, MailInfo) ->
	MailId = MailInfo#ets_player_mail.mail_id,
	MailConf = mail_cache:get_mail_conf_by_id(MailId),
	AwardList = MailConf#ets_mail_conf.award,

	case goods_lib_log:add_goods_list(State, AwardList, ?LOG_TYPE_MAIL) of
		{ok, State1} ->
			%% 全服邮件不删除  改变邮件状态
			MailInfo1 = MailInfo#ets_player_mail{state = 1},
			mail_cache:replace(MailInfo1),
			mail_cache:save_player_mail_to_ets(MailInfo1),
			broadcast_mail_info(State#player_state.socket, MailInfo1),
			{ok, State1};
		{fail, Reply} ->
			{fail, Reply}
	end.

%% 删除邮件
remove_mail(State, Id) ->
	PlayerId = State#player_state.player_id,
	case mail_cache:get_player_mail_from_ets(Id, PlayerId) of
		[] ->
			{fail, ?ERR_MAIL_NOT_EXIST};
		MailInfo ->
			case MailInfo#ets_player_mail.mail_type == ?TYPE_FULL_SERVICE_MAIL of
				true ->
					{ok, State};
				false ->
					mail_cache:delete(Id, PlayerId),
					mail_cache:delete_player_mail_from_ets_by_id(Id, PlayerId),
					{ok, State}
			end
	end.

%% 获取邮件信息列表
get_proto_mail_list(PlayerId) ->
	EtsMailList = mail_cache:get_all_player_mail_from_ets(PlayerId),
	Fun = fun(EtsMail) ->
		MailId = EtsMail#ets_player_mail.mail_id,
		{Id, _} = EtsMail#ets_player_mail.key,
		State = EtsMail#ets_player_mail.state,
		case MailId =:= 0 of
			true ->
				#proto_mail_info{
					id = Id,
					title = EtsMail#ets_player_mail.title,
					content = EtsMail#ets_player_mail.content,
					award = case State =:= 0 of true -> changed_award_to_proto(EtsMail#ets_player_mail.award); false ->
						[] end,
					state = EtsMail#ets_player_mail.state,
					send_time = EtsMail#ets_player_mail.send_time
				};
			false ->
				MailConf = mail_cache:get_mail_conf_by_id(MailId),
				#proto_mail_info{
					id = Id,
					title = MailConf#ets_mail_conf.title,
					content = MailConf#ets_mail_conf.content,
					award = case State =:= 0 of true -> changed_award_to_proto(MailConf#ets_mail_conf.award); false ->
						[] end,
					state = EtsMail#ets_player_mail.state,
					send_time = EtsMail#ets_player_mail.send_time
				}
		end
	end,
	%% 已领取的全服邮件不推送 X#ets_player_mail =:= ?TYPE_FULL_SERVICE_MAIL andalso X#ets_player_mail.state =:= 1
	ProtoMailList = [Fun(X) || X <- EtsMailList,
		(X#ets_player_mail.mail_type =/= ?TYPE_FULL_SERVICE_MAIL orelse X#ets_player_mail.state =/= 1)],
	ProtoMailList.

%% ====================================================================
%% Internal functions
%% ====================================================================

%% 获取唯一id
get_mail_uid() ->
	uid_lib:get_uid(?UID_TYPE_PLAYER_MAIL).

%% 奖励列表转换为proto
changed_award_to_proto(AwardList) ->
	case AwardList =:= undefined of
		true ->
			[];
		_ ->
			Fun = fun({GoodsId, IsBind, Num}) ->
				#proto_mail_award{
					goods_id = GoodsId,
					is_bind = IsBind,
					num = Num
				}
			end,
			[Fun(X) || X <- AwardList]
	end.

%% 广播玩家邮件信息
broadcast_mail_info(Socket, EtsMail) ->
	MailId = EtsMail#ets_player_mail.mail_id,
	{Id, _} = EtsMail#ets_player_mail.key,
	State = EtsMail#ets_player_mail.state,
	ProtoMailInfo =
		case MailId =:= 0 of
			true ->
				#proto_mail_info{
					id = Id,
					title = EtsMail#ets_player_mail.title,
					content = EtsMail#ets_player_mail.content,
					award = case State =:= 0 of true -> changed_award_to_proto(EtsMail#ets_player_mail.award); false ->
						[] end,
					state = EtsMail#ets_player_mail.state,
					send_time = EtsMail#ets_player_mail.send_time
				};
			false ->
				MailConf = mail_cache:get_mail_conf_by_id(MailId),
				#proto_mail_info{
					id = Id,
					title = MailConf#ets_mail_conf.title,
					content = MailConf#ets_mail_conf.content,
					award = case State =:= 0 of true -> changed_award_to_proto(MailConf#ets_mail_conf.award); false ->
						[] end,
					state = EtsMail#ets_player_mail.state,
					send_time = EtsMail#ets_player_mail.send_time
				}
		end,
	net_send:send_to_client(Socket, 15002, #rep_broadcast_mail_info{mail_info = ProtoMailInfo}).

%% 邮件红点提示
get_button_tips(PlayerState) ->
	PlayerId = PlayerState#player_state.player_id,
	EtsMailList = mail_cache:get_all_player_mail_from_ets(PlayerId),
	Len = length([X || X <- EtsMailList, X#ets_player_mail.state == 0]),
	{PlayerState, Len}.


log_mail(PlayerId, EtsInfo) ->
	#db_player_base{name = PlayerName} = player_base_cache:select_row(PlayerId),
	#ets_player_mail{
		mail_id = MailId,
		mail_type = MailType,
		sender = Sender,
		title = Title,
		content = Content,
		award = Award1,
		send_time = SendTime,
		limit_time = LimitTime
	} = EtsInfo,
	Award2 =
		case MailId =/= 0 of
			true ->
				MailConf = mail_config:get(MailId),
				MailConf#mail_conf.award;
			false ->
				Award1
		end,
	Award = util_data:term_to_string(Award2),
	log_lib:log_mail(PlayerId, PlayerName, MailId, MailType, Sender, Title, Content, Award, SendTime, LimitTime),
	ok.