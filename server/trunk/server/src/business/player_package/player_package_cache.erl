%%%-------------------------------------------------------------------
%%% @author apple
%%% @copyright (C) 2015, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 30. 十一月 2015 19:19
%%%-------------------------------------------------------------------
-module(player_package_cache).

-include("common.hrl").
-include("cache.hrl").


-export([
	select_row/2,
	select_all/1,
	insert/1,
	delete/2,
	update/2
]).

select_row(PlayerId, PlayerLv) ->
	db_cache_lib:select_row(?DB_PLAYER_PACKAGE, {PlayerLv, PlayerId}).

select_all(PlayerId) ->
	db_cache_lib:select_all(?DB_PLAYER_PACKAGE, {'_', PlayerId}).

insert(PackageInfo) ->
	PlayerLv = PackageInfo#db_player_package.lv,
	PlayerId = PackageInfo#db_player_package.player_id,
	db_cache_lib:insert(?DB_PLAYER_PACKAGE, {PlayerLv, PlayerId}, PackageInfo).

update(PlayerId, PackageInfo) ->
	db_cache_lib:update(?DB_PLAYER_PACKAGE, {PackageInfo#db_player_package.lv, PlayerId}, PackageInfo).

delete(PlayerId, PackageInfo) ->
	db_cache_lib:delete(?DB_PLAYER_PACKAGE, {PackageInfo#db_player_package.lv, PlayerId}).

%% API

