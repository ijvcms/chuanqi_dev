%%%-------------------------------------------------------------------
%%% @author apple
%%% @copyright (C) 2015, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 30. 十一月 2015 19:19
%%%-------------------------------------------------------------------
-module(player_vip_cache).

-include("common.hrl").
-include("cache.hrl").


-export([
	select_row/2,
	select_all/1,
	insert/1,
	delete/2,
	update/2
]).

select_row(PlayerId, VipLv) ->
	db_cache_lib:select_row(?DB_PLAYER_VIP,{VipLv, PlayerId}).

select_all(PlayerId) ->
	db_cache_lib:select_all(?DB_PLAYER_VIP, {'_', PlayerId}).

insert(PlayerVipInfo) ->
	VipLv = PlayerVipInfo#db_player_vip.vip_lv,
	PlayerId = PlayerVipInfo#db_player_vip.player_id,
	db_cache_lib:insert(?DB_PLAYER_VIP, {VipLv, PlayerId}, PlayerVipInfo).

update(PlayerId, PlayerVipInfo) ->
	db_cache_lib:update(?DB_PLAYER_VIP, {PlayerVipInfo#db_player_vip.vip_lv, PlayerId}, PlayerVipInfo).

delete(PlayerId, PlayerVipInfo) ->
	db_cache_lib:delete(?DB_PLAYER_VIP, {PlayerVipInfo#db_player_vip.vip_lv, PlayerId}).

%% API

