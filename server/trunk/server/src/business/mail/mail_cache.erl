%%%-------------------------------------------------------------------
%%% @author tuhujia
%%% @copyright (C) 2015, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 05. 八月 2015 15:36
%%%-------------------------------------------------------------------
-module(mail_cache).

-include("common.hrl").
-include("cache.hrl").
-include("record.hrl").
-include("config.hrl").

%% API
-export([
	select_all/1,
	select_row/2,
	replace/1,
	replace_to_db/1,
	delete/2,
	remove_cache/2,
	get_all_player_mail_from_ets/1,
	get_player_mail_from_ets/2,
	get_mail_conf_by_id/1,
	get_spec_mail_conf_from_ets/0,
	save_player_mail_to_ets/1,
	save_mail_conf_to_ets/1,
	delete_player_mail_from_ets/1,
	delete_player_mail_from_ets_by_id/2
]).


%% ====================================================================
%% API functions
%% ====================================================================
select_all(PlayerId) ->
	db_cache_lib:select_all(?DB_PLAYER_MAIL, {'_', PlayerId}).

select_row(Id, PlayerId) ->
	db_cache_lib:select_row(?DB_PLAYER_MAIL, {Id, PlayerId}).

replace(EtsInfo) ->
	{Id, PlayerId} = EtsInfo#ets_player_mail.key,
	DbInfo = #db_player_mail{id  = Id,
							 player_id = PlayerId,
							 mail_id = EtsInfo#ets_player_mail.mail_id,
							 mail_type = EtsInfo#ets_player_mail.mail_type,
							 sender = EtsInfo#ets_player_mail.sender,
							 title = EtsInfo#ets_player_mail.title,
							 content = EtsInfo#ets_player_mail.content,
							 award = EtsInfo#ets_player_mail.award,
							 state = EtsInfo#ets_player_mail.state,
							 send_time = EtsInfo#ets_player_mail.send_time,
							 limit_time = EtsInfo#ets_player_mail.limit_time,
							 update_time = EtsInfo#ets_player_mail.update_time},
	db_cache_lib:replace(?DB_PLAYER_MAIL, {Id, PlayerId}, DbInfo).

replace_to_db(EtsInfo) ->
	{Id, PlayerId} = EtsInfo#ets_player_mail.key,
	DbInfo = #db_player_mail{id  = Id,
							player_id = PlayerId,
							mail_id = EtsInfo#ets_player_mail.mail_id,
							mail_type = EtsInfo#ets_player_mail.mail_type,
							sender = EtsInfo#ets_player_mail.sender,
							title = EtsInfo#ets_player_mail.title,
							content = EtsInfo#ets_player_mail.content,
							award = util_data:term_to_string(EtsInfo#ets_player_mail.award),
							state = EtsInfo#ets_player_mail.state,
							send_time = EtsInfo#ets_player_mail.send_time,
							limit_time = EtsInfo#ets_player_mail.limit_time,
							update_time = EtsInfo#ets_player_mail.update_time},
	mail_db:replace(DbInfo).

delete(Id, PlayerId) ->
	db_cache_lib:delete(?DB_PLAYER_MAIL, {Id, PlayerId}).

remove_cache(Id, PlayerId) ->
	db_cache_lib:remove_cache(?DB_PLAYER_MAIL, {Id, PlayerId}).

%% ====================================================================
%%
%% ====================================================================

%% 获取玩家所有邮件
get_all_player_mail_from_ets(PlayerId) ->
	case ets:match_object(?ETS_PLAYER_MAIL, #ets_player_mail{key = {'_', PlayerId}, _ = '_'}) of
		MailList when length(MailList) > 0 ->
			MailList;
		_ ->
			[]
	end.

get_player_mail_from_ets(Id, PlayerId) ->
	case ets:lookup(?ETS_PLAYER_MAIL, {Id, PlayerId}) of
		[R|_] ->
			R;
		_ ->
			[]
	end.

get_mail_conf_by_id(MailId) ->
	case mail_config:get(MailId) of
		#mail_conf{} = MailConf->
			#ets_mail_conf
			{
				id = MailConf#mail_conf.id, %% id类型
				mail_type = MailConf#mail_conf.mail_type,
				sender = MailConf#mail_conf.sender,
				title = MailConf#mail_conf.title,
				content = MailConf#mail_conf.content,
				award = MailConf#mail_conf.award,
				active_time = MailConf#mail_conf.active_time,
				update_time = MailConf#mail_conf.update_time
			};
		_ ->
			case ets:lookup(?ETS_MAIL_CONF, MailId) of
				[R|_] ->
					R;
				_ ->
					[]
			end
	end.

get_spec_mail_conf_from_ets() ->
	case ets:match_object(?ETS_MAIL_CONF, #ets_mail_conf{mail_type = 2, _ = '_'}) of
		List when length(List) > 0 ->
			List;
		_ ->
			[]
	end.

save_player_mail_to_ets(MailInfo) ->
	ets:insert(?ETS_PLAYER_MAIL, MailInfo).

save_mail_conf_to_ets(MailInfo) ->
	ets:insert(?ETS_MAIL_CONF, MailInfo).

delete_player_mail_from_ets(PlayerId) ->
	ets:delete_object(?ETS_PLAYER_MAIL, #ets_player_mail{key = {'_', PlayerId}, _ = '_'}).

delete_player_mail_from_ets_by_id(Id, PlayerId) ->
	ets:delete(?ETS_PLAYER_MAIL, {Id, PlayerId}).