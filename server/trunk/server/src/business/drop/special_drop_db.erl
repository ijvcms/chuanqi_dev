%%%-------------------------------------------------------------------
%%% @author tuhujia
%%% @copyright (C) 2016, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 12. 四月 2016 11:17
%%%-------------------------------------------------------------------
-module(special_drop_db).

-include("common.hrl").
-include("cache.hrl").

%% API
-export([
	select_all/0,
	select_row/1,
	replace/1,
	insert/1,
	update/2
]).

%% ====================================================================
%% API functions
%% ====================================================================
select_all() ->
	case db:select_all(special_drop, record_info(fields, db_special_drop), []) of
		[] ->
			[];
		List ->
			Fun =
				fun(List1) ->
					list_to_tuple([db_special_drop | List1])
				end,
			[Fun(X) || X <- List]
	end.

select_row(DropType) ->
	case db:select_row(special_drop, record_info(fields, db_special_drop), [{drop_type, DropType}]) of
		[] ->
			null;
		List ->
			list_to_tuple([db_special_drop | List])
	end.

replace(Info) ->
	db:replace(special_drop, util_tuple:to_tuple_list(Info)).

insert(Info) ->
	db:insert(special_drop, util_tuple:to_tuple_list(Info)).

update(DropType, Info) ->
	db:update(special_drop, util_tuple:to_tuple_list(Info), [{drop_type, DropType}]).

%% ====================================================================
%% Internal functions
%% ====================================================================
