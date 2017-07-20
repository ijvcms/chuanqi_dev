%%%-------------------------------------------------------------------
%%% @author zhengsiying
%%% @copyright (C) 2015, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 23. 七月 2015 上午10:03
%%%-------------------------------------------------------------------
-module(player_money_db).

-include("common.hrl").
-include("cache.hrl").

%% API
-export([
	select_row/1,
	insert/1,
	update/2
]).

%% ====================================================================
%% API functions
%% ====================================================================
select_row(PlayerId) ->
	case db:select_row(player_money, record_info(fields, db_player_money), [{player_id, PlayerId}]) of
		[] ->
			null;
		List ->
			list_to_tuple([db_player_money | List])
	end.

insert(PlayerMoney) ->
	db:insert(player_money, util_tuple:to_tuple_list(PlayerMoney)).

update(PlayerId, PlayerMoney) ->
	db:update(player_money, util_tuple:to_tuple_list(PlayerMoney), [{player_id, PlayerId}]).

%% ====================================================================
%% Internal functions
%% ====================================================================
