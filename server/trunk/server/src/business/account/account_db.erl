%%%-------------------------------------------------------------------
%%% @author zhengsiying
%%% @copyright (C) 2015, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 21. 七月 2015 下午4:14
%%%-------------------------------------------------------------------
-module(account_db).

-include("common.hrl").
-include("record.hrl").
-include("db_record.hrl").

%% API
-export([
	select_all/1,
	select_all/2,
	select_row/1,
	insert/1,
	delete/3
]).

%% ====================================================================
%% API functions
%% ====================================================================
select_all({OpenId, Platform}) ->
	case db:select_all(account, record_info(fields, db_account), [{open_id, OpenId}, {platform, Platform}]) of
		[] ->
			[];
		List ->
			[list_to_tuple([db_account | Info]) || Info <- List]
	end.

select_all({OpenId, Platform}, ServerId) ->
	case db:select_all(account, record_info(fields, db_account), [{open_id, OpenId}, {platform, Platform}, {server_id, ServerId}]) of
		[] ->
			[];
		List ->
			[list_to_tuple([db_account | Info]) || Info <- List]
	end.

select_row(PlayerId) ->
	case db:select_row(account, record_info(fields, db_account), [{player_id, PlayerId}]) of
		[] ->
			null;
		List ->
			list_to_tuple([db_account | List])
	end.


insert(Account) ->
	db:insert(account, util_tuple:to_tuple_list(Account)).

delete(OpenId, Platform, PlayerId) ->
	db:delete(account, [{open_id, OpenId}, {platform, Platform}, {player_id, PlayerId}]).

%% ====================================================================
%% Internal functions
%% ====================================================================