%%%-------------------------------------------------------------------
%%% @author zhengsiying
%%% @copyright (C) 2015, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 15. 十二月 2015 下午8:18
%%%-------------------------------------------------------------------
-module(player_active_service_cache).

-include("common.hrl").
-include("cache.hrl").

%% API
-export([
	select_all/1,
	select_row/1,
	insert/1
]).

%% ====================================================================
%% API functions
%% ====================================================================
select_all(ActiveServiceId) ->
	db_cache_lib:select_all(?DB_PLAYER_ACTIVE_SERVICE, {'_', ActiveServiceId}).

select_row({PlayerId, ActiveServiceId}) ->
	db_cache_lib:select_row(?DB_PLAYER_ACTIVE_SERVICE, {PlayerId, ActiveServiceId}).

insert(ActiveServiceInfo) ->
	#db_player_active_service{
		player_id = PlayerId,
		active_service_id = ActiveServiceId
	} = ActiveServiceInfo,
	db_cache_lib:insert(?DB_PLAYER_ACTIVE_SERVICE, {PlayerId, ActiveServiceId}, ActiveServiceInfo).


%% ====================================================================
%% Internal functions
%% ====================================================================