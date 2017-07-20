%%%-------------------------------------------------------------------
%%% @author apple
%%% @copyright (C) 2015, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 30. 十一月 2015 14:11
%%%-------------------------------------------------------------------
-module(player_vip_db).

-include("common.hrl").
-include("cache.hrl").

%% API
-export([
	select_row/1,
	select_all/1,
	insert/1,
	update/2,
	delete/1
]).

%% ====================================================================
%% API functions
%% ====================================================================

select_row({VipLv, PlayerId}) ->
	case db:select_row(player_vip, record_info(fields, db_player_vip), [{vip_lv, VipLv}, {player_id, PlayerId}]) of
		[] ->
			null;
		List ->
			list_to_tuple([db_player_vip | List])
	end.

select_all({'_', PlayerId}) ->
	case db:select_all(player_vip, record_info(fields, db_player_vip), [{player_id, PlayerId}]) of
		[] ->
			[];
		List ->
			[list_to_tuple([db_player_vip | X]) || X <- List]
	end.

insert(PlayerVipInfo) ->
	db:insert(player_vip, util_tuple:to_tuple_list(PlayerVipInfo)).

update({VipLv, PlayerId}, PlayerVipInfo) ->
	db:update(player_vip, util_tuple:to_tuple_list(PlayerVipInfo), [{vip_lv, VipLv}, {player_id, PlayerId}]).

delete({VipLv, PlayerId}) ->
	db:delete(player_vip, [{vip_lv, VipLv}, {player_id, PlayerId}]).
%% API

