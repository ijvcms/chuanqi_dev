%%%-------------------------------------------------------------------
%%% @author yubing
%%% @copyright (C) 2015, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 10. 十二月 2015 19:32
%%%-------------------------------------------------------------------
-module(player_foe_db).


%% API
-export([
	select_row/1,
	select_all/1,
	insert/1,
	update/2,
	delete/1
]).

-include("record.hrl").
-include("cache.hrl").
-include("common.hrl").
%% ====================================================================
%% API functions
%% ====================================================================
select_row({PlayerId, TPlayerId}) ->
	case db:select_row(player_foe, record_info(fields,db_player_foe), [{player_id, PlayerId}, {tplayer_id, TPlayerId}]) of
		[] ->
			null;
		List ->
			list_to_tuple([db_player_foe | List])
	end.

select_all({PlayerId,'_'}) ->
	case db:select_all(player_foe, record_info(fields, db_player_foe), [{player_id, PlayerId}]) of
		[] ->
			[];
		List ->
			[list_to_tuple([db_player_foe | X]) || X <- List]
	end.

delete({PlayerId, TPlayerId}) ->
	db:delete(player_foe,  [{player_id, PlayerId}, {tplayer_id, TPlayerId}]).

insert(Info) ->
	db:insert(player_foe, util_tuple:to_tuple_list(Info)).

update({PlayerId, TPlayerId}, Info) ->
	db:update(player_foe, util_tuple:to_tuple_list(Info),  [{player_id, PlayerId}, {tplayer_id, TPlayerId}]).
