%% @author qhb
%% @doc @todo Add description to util_ets.


-module(util_ets).

%% ====================================================================
%% API functions
%% ====================================================================
-export([
	lookup/2,
	get/2,
	delete/2,
	get_load/3,
	foreach/2,
	foreach/3
]).

lookup(Table, Key) ->
	Key2 = case Key of
			   _ when is_list(Key) ->
				   list_to_binary(Key);
			   _ -> Key
		   end,
	ets:lookup(Table, Key2).

get(Table, Key) ->
	case lookup(Table, Key) of
		[] -> undefined;
		[R] -> R
	end.

delete(Table, Key) ->
	Key2 = case Key of
			   _ when is_list(Key) ->
				   list_to_binary(Key);
			   _ -> Key
		   end,
	ets:delete(Table, Key2).

get_load(ETSTable, RecType, FieldValue) ->
	{_KeyName, KeyValue} = FieldValue,
	case util_ets:lookup(ETSTable, KeyValue) of
		[] ->
			Value2 = dbutil_rec:find(RecType, rec_util:fields(RecType), [FieldValue]),
			case Value2 of
				undefined -> undefined;
				_ ->
					ets:insert(ETSTable, Value2),
					Value2
			end;
		[Value] ->
			Value
	end.

foreach(Table, Func) ->
	ets:safe_fixtable(Table, true),
	Result = foreach(Table, ets:first(Table), Func),
	ets:safe_fixtable(Table, false),
	Result.

foreach(_, '$end_of_table', _) ->
	ets_end;
foreach(Table, Idx, Func) ->
	Result = case ets:lookup(Table, Idx) of
				 [Ele] -> Func(Idx, Ele);
				 [] -> ets_continue
			 end,
	case Result of
		ets_continue -> foreach(Table, ets:next(Table, Idx), Func);
		_ -> Result
	end.

%% ====================================================================
%% Internal functions
%% ====================================================================


