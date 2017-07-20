%% @author qhb
%% @doc @todo Add description to util_tuple.


-module(util_tuple_log).

-include("common.hrl").
-include("record.hrl").
-include("cache.hrl").
-include("db_record.hrl").

-define(LIST_TO_RECORD(RecName, List), list_to_tuple([RecName])).

%% ====================================================================
%% API functions
%% ====================================================================
-export([
	to_log_table/1
]).

to_log_table(Tuple) ->
	[H | _V] = tuple_to_list(Tuple),
	H.

%% ====================================================================
%% Internal functions
%% ====================================================================