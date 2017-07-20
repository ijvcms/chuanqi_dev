%%%-------------------------------------------------------------------
%%% @author tuhujia
%%% @copyright (C) 2015, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 27. 八月 2015 14:10
%%%-------------------------------------------------------------------
-module(arena_shop_cache).

-include("common.hrl").
-include("cache.hrl").
-include("record.hrl").
-include("config.hrl").
-include("language_config.hrl").

%% API
-export([
	select_row/1,
	insert/1,
	replace/1,
	update/2,
	delete/1,
	remove_cache/1,
	get_arena_shop_count_by_id/2,
	add_arena_shop_buy_count/2,
	check_can_buy_arena_shop_by_id/2
]).

%% ====================================================================
%% API functions
%% ====================================================================
select_row({Id, PlayerId}) ->
	db_cache_lib:select_row(?DB_ARENA_SHOP, {Id, PlayerId}).

insert(Info) ->
	Id = Info#db_arena_shop.id,
	PlayerId = Info#db_arena_shop.player_id,
	db_cache_lib:insert(?DB_ARENA_SHOP, {Id, PlayerId}, Info).

replace(Info) ->
	Id = Info#db_arena_shop.id,
	PlayerId = Info#db_arena_shop.player_id,
	db_cache_lib:replace(?DB_ARENA_SHOP, {Id, PlayerId}, Info).

update({Id, PlayerId}, Info) ->
	db_cache_lib:update(?DB_ARENA_SHOP, {Id, PlayerId}, Info).

delete({Id, PlayerId}) ->
	db_cache_lib:delete(?DB_ARENA_SHOP, {Id, PlayerId}).

remove_cache({Id, PlayerId}) ->
	db_cache_lib:remove_cache(?DB_ARENA_SHOP, {Id, PlayerId}).

%% ====================================================================
%%
%% ====================================================================

%% 获取商品购买记录
get_arena_shop_count_by_id(Id, PlayerId) ->
	case select_row({Id, PlayerId}) of
		null ->
			R = #db_arena_shop{id = Id, player_id = PlayerId, count = 0, update_time = util_date:unixtime()},
			insert(R),
			0;
		Info ->
			Info1 = check_arena_shop_info(Info),
			case Info =:= Info1 of
				true ->
					replace(Info1);
				false ->
					skip
			end,
			Info1#db_arena_shop.count
	end.

%% 时间检查
check_arena_shop_info(Info) ->
	UpdateTime = Info#db_arena_shop.update_time,
	case UpdateTime >= util_date:get_today_unixtime() of
		true ->
			Info;
		false ->
			Info1 = Info#db_arena_shop{count = 0, update_time = util_date:unixtime()},
			replace(Info1),
			Info1
	end.

%% 增加购买次数
add_arena_shop_buy_count(Id, PlayerId) ->
	Count = get_arena_shop_count_by_id(Id, PlayerId),
	Info1 = #db_arena_shop{
		id = Id,
		player_id = PlayerId,
		count = Count + 1,
		update_time = util_date:unixtime()
	},
	replace(Info1).

%% 检查是否能继续购买
check_can_buy_arena_shop_by_id(Id, PlayerId) ->
	Conf = arena_shop_config:get(Id),
	case get_arena_shop_count_by_id(Id, PlayerId) < Conf#arena_shop_conf.limit_count of
		true ->
			{ok, Conf};
		false ->
			{fail, ?ERR_ARENA_GOODS_LIMIT}
	end.