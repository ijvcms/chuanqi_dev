%%%-------------------------------------------------------------------
%%% @author zhengsiying
%%% @copyright (C) 2016, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 06. 一月 2016 下午4:36
%%%-------------------------------------------------------------------
-module(pet_cache).

-include("common.hrl").
-include("record.hrl").
-include("cache.hrl").

%% API
-export([
	select_row/1,
	insert/1,
	update/2,
	remove_cache/1,
	delete/1
]).

%% ====================================================================
%% API functions
%% ====================================================================
select_row(PlayerId) ->
	db_cache_lib:select_row(?DB_PET, PlayerId).

insert(Pet) ->
	db_cache_lib:insert(?DB_PET, Pet#db_pet.player_id, Pet).

update(PlayerId, UpdatePet) ->
	case select_row(PlayerId) of
		null->
			yu_test:log_err();
		_->
			skip
	end,
	db_cache_lib:update(?DB_PET, PlayerId, UpdatePet).

remove_cache(PlayerId) ->
	db_cache_lib:remove_cache(?DB_PET, PlayerId).

delete(PlayerId) ->
	case select_row(PlayerId) of
		null->
			skip;
		_->
			UpdatePet=#db_pet{
				pet_list = []
			},
			update(PlayerId,UpdatePet)
	end.
%% 	db_cache_lib:delete(?DB_PET, PlayerId).

%% ====================================================================
%% Internal functions
%% ====================================================================
