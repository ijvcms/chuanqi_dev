%%%-------------------------------------------------------------------
%%% @author tuhujia
%%% @copyright (C) 2015, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 05. 八月 2015 15:05
%%%-------------------------------------------------------------------
-module(mail_db).

-include("common.hrl").
-include("cache.hrl").
-include("db_record.hrl").

%% API
-export([
	select_all/1,
	select_row/1,
	replace/1,
	delete/1,
	insert/1,
	update/2
]).

%% ====================================================================
%% API functions
%% ====================================================================
select_all({'_', PlayerId}) ->
	case db:select_all(player_mail, record_info(fields, db_player_mail), [{player_id, PlayerId}]) of
		[] ->
			[];
		List ->
			Fun =
				fun(Info) ->
					DbInfo = list_to_tuple([db_player_mail | Info]),
					Award = util_data:string_to_term(DbInfo#db_player_mail.award),
					DbInfo#db_player_mail{award = Award}
				end,
			[Fun(X) || X <- List]
	end.

select_row({Id, PlayerId}) ->
	case db:select_row(player_mail, record_info(fields, db_player_mail), [{id, Id}, {player_id, PlayerId}]) of
		[] ->
			null;
		Info ->
			DbInfo = list_to_tuple([db_player_mail | Info]),
			?INFO("dbinfo ~p",[DbInfo]),
			Award = util_data:string_to_term(DbInfo#db_player_mail.award),
			DbInfo#db_player_mail{award = Award}
	end.

replace(Info) ->
	db:replace(player_mail, util_tuple:to_tuple_list(Info)).

delete({Id, PlayerId}) ->
	db:delete(player_mail, [{id, Id}, {player_id, PlayerId}]).

insert(Info) ->
	Award = util_data:term_to_string(Info#db_player_mail.award),
	Info1 = Info#db_player_mail{award = Award},
	db:insert(player_mail, util_tuple:to_tuple_list(Info1)).

update({Id, PlayerId}, Info) ->
	Award = util_data:term_to_string(Info#db_player_mail.award),
	Info1 = Info#db_player_mail{award = Award},
	db:update(player_mail, util_tuple:to_tuple_list(Info1), [{id, Id}, {player_id, PlayerId}]).

%% ====================================================================
%% Internal functions
%% ====================================================================
