%%%-------------------------------------------------------------------
%%% @author tuhujia
%%% @copyright (C) 2015, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 05. 十一月 2015 16:47
%%%-------------------------------------------------------------------
-module(guild_shop_db).

-include("common.hrl").
-include("cache.hrl").

%% API
-export([
	select_row/1,
	replace/1,
	insert/1,
	update/2
]).

%% ====================================================================
%% API functions
%% ====================================================================
select_row({PlayerId, ShopId}) ->
	case db:select_row(player_guild_shop, record_info(fields, db_player_guild_shop), [{player_id, PlayerId}, {shop_id, ShopId}]) of
		[] ->
			null;
		List ->
			list_to_tuple([db_player_guild_shop | List])
	end.

replace(Info) ->
	db:replace(player_guild_shop, util_tuple:to_tuple_list(Info)).

insert(Info) ->
	db:insert(player_guild_shop, util_tuple:to_tuple_list(Info)).

update({PlayerId, ShopId}, Info) ->
	db:update(player_guild_shop, util_tuple:to_tuple_list(Info), [{player_id, PlayerId}, {shop_id, ShopId}]).

%% ====================================================================
%% Internal functions
%% ====================================================================
