%%%-------------------------------------------------------------------
%%% @author yubing
%%% @copyright (C) 2015, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 10. 十二月 2015 20:04
%%%-------------------------------------------------------------------
-module(player_foe_cache).

-include("cache.hrl").
-include("record.hrl").
-include("common.hrl").

-export([
	select_row/2,
	select_all/1,
	insert/1,
	delete/2,
	update/3,
	get_foe_list/1,
	add_foe_info/2,
	delete_foe_info/2,
	update_foe_info/3,
	is_foe/2
]).
%% ====================================================================
%% API functions
%% ====================================================================
select_row(PlayerId, TPlayerId) ->
	db_cache_lib:select_row(?DB_PLAYER_FOE, {PlayerId, TPlayerId}).

select_all(PlayerId) ->
	db_cache_lib:select_all(?DB_PLAYER_FOE, {PlayerId, '_'}).

insert(Info) ->
	PlayerId = Info#db_player_foe.player_id,
	TPlayerId = Info#db_player_foe.tplayer_id,
	db_cache_lib:insert(?DB_PLAYER_FOE, {PlayerId, TPlayerId}, Info).

update(PlayerId, TPlayerId, Info) ->
	db_cache_lib:update(?DB_PLAYER_FOE, {PlayerId, TPlayerId}, Info).

delete(PlayerId, TPlayerId) ->
	db_cache_lib:delete(?DB_PLAYER_FOE, {PlayerId, TPlayerId}).


%% 获取玩家的仇人列表
get_foe_list(PlayerId) ->
	case relationship_lib:get_ets(PlayerId) of
		[] ->
			select_all(PlayerId);
		Ets ->
			Ets#ets_relationship.foe_list
	end.
%% 判断玩家是否仇人
is_foe(PlayerId, TPlayerId) ->
	NewList = get_foe_list(PlayerId),
	lists:keymember(TPlayerId, #db_player_foe.tplayer_id, NewList).

%% 添加玩家的仇人信息
add_foe_info(PlayerId, TPlayerId) ->
	FoeInfo = #db_player_foe
	{
		player_id = PlayerId,
		tplayer_id = TPlayerId,
		time = util_date:unixtime()
	},
	insert(FoeInfo),
	case relationship_lib:get_ets(PlayerId) of
		[] ->
			skip;
		Ets ->
			FoeList = Ets#ets_relationship.foe_list,
			FoeList1 = [FoeInfo | FoeList],
			Ets1 = Ets#ets_relationship
			{
				foe_list = FoeList1
			},
			relationship_lib:save_ets(Ets1)
	end.

%% 修改玩家的仇人信息
update_foe_info(PlayerId, TPlayerId, FoeInfo) ->
	update(PlayerId, TPlayerId, FoeInfo),
	case relationship_lib:get_ets(PlayerId) of
		[] ->
			skip;
		Ets ->
			FoeList = Ets#ets_relationship.foe_list,
			FoeList1 = lists:keyreplace(TPlayerId, #db_player_foe.tplayer_id, FoeList, FoeInfo),
			Ets1 = Ets#ets_relationship
			{
				foe_list = FoeList1
			},
			relationship_lib:save_ets(Ets1)
	end.

%% 删除玩家的仇人信息
delete_foe_info(PlayerId, TPlayerId) ->
	delete(PlayerId, TPlayerId),

	case relationship_lib:get_ets(PlayerId) of
		[] ->
			skip;
		Ets ->
			FoeList = Ets#ets_relationship.foe_list,
			FoeList1 = lists:keydelete(TPlayerId, #db_player_foe.tplayer_id, FoeList),
			Ets1 = Ets#ets_relationship
			{
				foe_list = FoeList1
			},
			relationship_lib:save_ets(Ets1)
	end.

