%%%-------------------------------------------------------------------
%%% @author tuhujia
%%% @copyright (C) 2016, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 05. 四月 2016 11:39
%%%-------------------------------------------------------------------
-module(sign_db).

-include("common.hrl").
-include("cache.hrl").

%% API
-export([
	select_row/1,
	insert/1,
	update/2,
	delete/1
]).

%% ====================================================================
%% API functions
%% ====================================================================
select_row(PlayerId) ->
	case db:select_row(player_sign, record_info(fields, db_player_sign), [{player_id, PlayerId}]) of
		[] ->
			null;
		List ->
			DbInfo = list_to_tuple([db_player_sign | List]),
			DbInfo#db_player_sign
			{
				sign_list = util_data:string_to_term(DbInfo#db_player_sign.sign_list),
				reward_list = util_data:string_to_term(DbInfo#db_player_sign.reward_list)
			}
	end.

insert(Info) ->
	NewInfo = Info#db_player_sign
	{
		sign_list = util_data:term_to_string(Info#db_player_sign.sign_list),
		reward_list = util_data:term_to_string(Info#db_player_sign.reward_list)
	},
	db:insert(player_sign, util_tuple:to_tuple_list(NewInfo)).

update(PlayerId, Info) ->
	NewInfo = Info#db_player_sign
	{
		sign_list = util_data:term_to_string(Info#db_player_sign.sign_list),
		reward_list = util_data:term_to_string(Info#db_player_sign.reward_list)
	},
	db:update(player_sign, util_tuple:to_tuple_list(NewInfo), [{player_id, PlayerId}]).

delete(PlayerId) ->
	db:delete(player_sign, [{player_id, PlayerId}]).
%% ====================================================================
%% Internal functions
%% ====================================================================
