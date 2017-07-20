%%%-------------------------------------------------------------------
%%% @author zhengsiying
%%% @copyright (C) 2016, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 27. 二月 2016 下午6:20
%%%-------------------------------------------------------------------
-module(button_tips_cache).

-include("common.hrl").
-include("cache.hrl").

%% API
-export([
	select_all/1,
	select_row/1,
	insert/1,
	update/2,
	delete/1,
	delete_all/1,
	remove_cache/1
]).

%% ====================================================================
%% API functions
%% ====================================================================
select_all(PlayerId) ->
	db_cache_lib:select_all(?DB_BUTTON_TIPS, {PlayerId, '_'}).

select_row({PlayerId, BtnId}) ->
	db_cache_lib:select_row(?DB_BUTTON_TIPS, {PlayerId, BtnId}).

insert(ButtonTips) ->
	#db_button_tips{
		player_id = PlayerId,
		btn_id = BtnId
	} = ButtonTips,
	db_cache_lib:insert(?DB_BUTTON_TIPS, {PlayerId, BtnId}, ButtonTips).

update({PlayerId, BtnId}, ButtonTips) ->
	db_cache_lib:update(?DB_BUTTON_TIPS, {PlayerId, BtnId}, ButtonTips).

delete({PlayerId, BtnId}) ->
	db_cache_lib:delete(?DB_BUTTON_TIPS, {PlayerId, BtnId}).

%% 特殊要求，特殊处理
delete_all(PlayerId) ->
	remove_cache(PlayerId),
	player_instance_db:delete_all(PlayerId).

remove_cache(PlayerId) ->
	db_cache_lib:remove_all_cache(?DB_BUTTON_TIPS, {PlayerId, '_'}).

%% ====================================================================
%% Internal functions
%% ====================================================================