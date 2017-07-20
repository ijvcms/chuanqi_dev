%%%-------------------------------------------------------------------
%%% @author zhengsiying
%%% @copyright (C) 2015, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 24. 九月 2015 下午2:39
%%%-------------------------------------------------------------------
-module(buff_cache).

-include("common.hrl").
-include("cache.hrl").

%% API
-export([
	select_all/1,
	select_row/1,
	insert/1,
	update/2,
	delete/1,
	remove_cache/1
]).

%% ====================================================================
%% API functions
%% ====================================================================
select_all(PlayerId) ->
	db_cache_lib:select_all(?DB_BUFF, {PlayerId, '_'}).

select_row({PlayerId, BuffId}) ->
	db_cache_lib:select_row(?DB_BUFF, {PlayerId, BuffId}).

insert(Buff) ->
	#db_buff{
		player_id = PlayerId,
		buff_id = BuffId
	} = Buff,
	db_cache_lib:insert(?DB_BUFF, {PlayerId, BuffId}, Buff).

update({PlayerId, BuffId}, UpdateBuff) ->
	case select_row({PlayerId, BuffId}) of
		null ->
			skip;
		_ ->
			db_cache_lib:update(?DB_BUFF, {PlayerId, BuffId}, UpdateBuff)
	end.

delete({PlayerId, BuffId}) ->
	db_cache_lib:delete(?DB_BUFF, {PlayerId, BuffId}).

remove_cache(PlayerId) ->
	db_cache_lib:remove_all_cache(?DB_BUFF, {PlayerId, '_'}).

%% ====================================================================
%% Internal functions
%% ====================================================================
