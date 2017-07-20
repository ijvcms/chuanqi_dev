%%%-------------------------------------------------------------------
%%% @author zhengsiying
%%% @copyright (C) 2016, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 06. 一月 2016 下午4:20
%%%-------------------------------------------------------------------
-module(pet_db).

-include("common.hrl").
-include("record.hrl").
-include("cache.hrl").

%% API
-export([
	select_row/1,
	insert/1,
	update/2,
	delete/1
]).

%% ====================================================================
%% API functions
%% ====================================================================
select_row(PlayerId) ->
	case db:select_row(pet, record_info(fields, db_pet), [{player_id, PlayerId}]) of
		[] ->
			null;
		List ->
			DbPet = list_to_tuple([db_pet | List]),
			PetList = DbPet#db_pet.pet_list,
			DbPet#db_pet{pet_list = util_data:string_to_term(PetList)}
	end.

insert(Pet) ->
	PetList = Pet#db_pet.pet_list,
	db:insert(pet, util_tuple:to_tuple_list(Pet#db_pet{pet_list = util_data:term_to_string(PetList)})).

update(PlayerId, Pet) ->
	PetList = Pet#db_pet.pet_list,
	db:update(pet, util_tuple:to_tuple_list(Pet#db_pet{pet_list = util_data:term_to_string(PetList)}), [{player_id, PlayerId}]).

delete(PlayerId) ->
	db:delete(pet, [{player_id, PlayerId}]).

%% ====================================================================
%% Internal functions
%% ====================================================================
