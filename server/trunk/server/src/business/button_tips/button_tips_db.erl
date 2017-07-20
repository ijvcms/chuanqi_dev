%%%-------------------------------------------------------------------
%%% @author zhengsiying
%%% @copyright (C) 2016, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 27. 二月 2016 下午6:09
%%%-------------------------------------------------------------------
-module(button_tips_db).

-include("common.hrl").
-include("cache.hrl").

%% API
-export([
	select_all/1,
	select_row/1,
	insert/1,
	update/2,
	delete/1,
	delete_all/1
]).

%% ====================================================================
%% API functions
%% ====================================================================
select_all({PlayerId, '_'}) ->
	case db:select_all(button_tips, record_info(fields, db_button_tips), [{player_id, PlayerId}]) of
		[] ->
			[];
		List ->
			[list_to_tuple([db_button_tips | X]) || X <- List]
	end.

select_row({PlayerId, BtnId}) ->
	case db:select_row(button_tips, record_info(fields, db_button_tips), [{player_id, PlayerId}, {btn_id, BtnId}]) of
		[] ->
			null;
		List ->
			list_to_tuple([db_button_tips | List])
	end.

insert(ButtonTips) ->
	db:insert(button_tips, util_tuple:to_tuple_list(ButtonTips)).

update({PlayerId, BtnId}, ButtonTips) ->
	db:update(button_tips, util_tuple:to_tuple_list(ButtonTips), [{player_id, PlayerId}, {btn_id, BtnId}]).

delete({PlayerId, BtnId}) ->
	db:delete(button_tips, [{player_id, PlayerId}, {btn_id, BtnId}]).

%% 特殊要求，特殊处理
delete_all(PlayerId) ->
	db:delete(button_tips, [{player_id, PlayerId}]).