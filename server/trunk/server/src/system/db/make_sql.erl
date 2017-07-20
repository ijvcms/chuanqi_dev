%% @author ming
%% @doc @todo Add description to make_sql.


-module(make_sql).


-export([insert/2,
	replace/2,
	update/3,
	select/3,
	select/5,
	delete/2]).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%  make sql

insert(TableName, FieldValueList) ->
	Vsql = do_replace(FieldValueList, <<>>),
	Bin1 = util_data:to_binary(TableName),
	<<"insert into `", Bin1/binary, "` set ", Vsql/binary>>.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
replace(TableName, FieldValueList) ->
	Vsql = do_replace(FieldValueList, <<>>),
	Bin1 = util_data:to_binary(TableName),
	<<"replace into `", Bin1/binary, "` set ", Vsql/binary>>.

do_replace([], Expr) ->
	Expr;

do_replace([{Field, Val}], Expr) when is_binary(Val) orelse is_list(Val) ->
	Bin1 = util_data:to_binary(Field),
	Bin2 = re:replace(Val, "'", "''", [global, {return, binary}]),
	<<Expr/binary, "`", Bin1/binary, "` = '", Bin2/binary, "'">>;

do_replace([{Field, Val} | T], Expr) when is_binary(Val) orelse is_list(Val) ->
	Bin1 = util_data:to_binary(Field),
	Bin2 = re:replace(Val, "'", "''", [global, {return, binary}]),
	do_replace(T, <<Expr/binary, "`", Bin1/binary, "` = '", Bin2/binary, "',">>);

do_replace([{Field, Val}], Expr) ->
	Bin1 = util_data:to_binary(Field),
	Bin2 = util_data:to_binary(Val),
	<<Expr/binary, "`", Bin1/binary, "` = ", Bin2/binary>>;

do_replace([{Field, Val} | T], Expr) ->
	Bin1 = util_data:to_binary(Field),
	Bin2 = util_data:to_binary(Val),
	do_replace(T, <<Expr/binary, "`", Bin1/binary, "` = ", Bin2/binary, ",">>).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
update(TableName, FieldValueList, WhereList) ->
	Vsql = do_replace(FieldValueList, <<>>),
	Bin1 = util_data:to_binary(TableName),
	Bin2 = get_where_sql(WhereList, <<>>),
	<<"update `", Bin1/binary, "` set ", Vsql/binary, " ", Bin2/binary>>.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
select(TableName, Fields, WhereList) ->
	select(TableName, Fields, WhereList, [], []).

select(TableName, Fields, WhereList, OrderList, Limit) ->
	BinTableName = util_data:to_binary(TableName),
	BinFields = case Fields of
					"count(1)" ->
						<<"count(1)">>;
					{max, Value} ->
						do_max(Value);
					_ ->
						do_select(Fields, <<>>)
				end,
	BinWhere = get_where_sql(WhereList, <<>>),
	BinOrder = get_order_sql(OrderList, <<>>),
	BinLimit = do_limit(Limit),
	<<"select ", BinFields/binary, " from `", BinTableName/binary, "` ", BinWhere/binary, " ", BinOrder/binary, " ", BinLimit/binary>>.

do_select([], Expr) ->
	Expr;

do_select([Fields], Expr) ->
	Bin1 = util_data:to_binary(Fields),
	<<Expr/binary, Bin1/binary>>;

do_select([Fields | T], Expr) ->
	Bin1 = util_data:to_binary(Fields),
	do_select(T, <<Expr/binary, Bin1/binary, ",">>).

do_max(Value) ->
	Bin1 = util_data:to_binary(Value),
	<<"max(", Bin1/binary, ")">>.

do_limit(Limit) ->
	case Limit of
		[Num] ->
			Bin1 = util_data:to_binary(Num),
			<<"limit ", Bin1/binary>>;
		[Num1, Num2] ->
			Bin2 = util_data:to_binary(Num1),
			Bin3 = util_data:to_binary(Num2),
			<<"limit ", Bin2/binary, ",", Bin3/binary>>;
		[] -> <<>>
	end.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
delete(TableName, WhereList) ->
	Bin1 = util_data:to_binary(TableName),
	Bin2 = get_where_sql(WhereList, <<>>),
	<<"delete from `", Bin1/binary, "` ", Bin2/binary>>.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


get_where_sql([], Expr) ->
	Expr;

get_where_sql([{Field, Val}], Expr) when is_binary(Val) orelse is_list(Val) ->
	Bin1 = util_data:to_binary(Field),
	Bin2 = re:replace(Val, "'", "''", [global, {return, binary}]),
	<<"where ", Expr/binary, "`", Bin1/binary, "` = '", Bin2/binary, "'">>;

get_where_sql([{Field, Val} | T], Expr) when is_binary(Val) orelse is_list(Val) ->
	Bin1 = util_data:to_binary(Field),
	Bin2 = re:replace(Val, "'", "''", [global, {return, binary}]),
	get_where_sql(T, <<Expr/binary, "`", Bin1/binary, "` = '", Bin2/binary, "' and ">>);

get_where_sql([{Field, Val}], Expr) ->
	Bin1 = util_data:to_binary(Field),
	Bin2 = util_data:to_binary(Val),
	<<"where ", Expr/binary, "`", Bin1/binary, "` = ", Bin2/binary>>;

get_where_sql([{Field, Val} | T], Expr) ->
	Bin1 = util_data:to_binary(Field),
	Bin2 = util_data:to_binary(Val),
	get_where_sql(T, <<Expr/binary, "`", Bin1/binary, "` = ", Bin2/binary, " and ">>);

get_where_sql([{Field, Operator, Val}], Expr) when is_binary(Val) orelse is_list(Val) ->
	Bin1 = util_data:to_binary(Field),
	case Operator of
		"in" ->
			Bin2 = get_in_string(Val),
			Bin3 = re:replace(Operator, "", "", [global, {return, binary}]),
			<<"where ", Expr/binary, "`", Bin1/binary, "`", Bin3/binary, "(", Bin2/binary, ")">>;
		_ ->
			Bin2 = re:replace(Val, "'", "''", [global, {return, binary}]),
			Bin3 = re:replace(Operator, "", "", [global, {return, binary}]),
			<<"where ", Expr/binary, "`", Bin1/binary, "`", Bin3/binary, "'", Bin2/binary, "'">>
	end;

get_where_sql([{Field, Operator, Val} | T], Expr) when is_binary(Val) orelse is_list(Val) ->
	Bin1 = util_data:to_binary(Field),
	case Operator of
		"in" ->
			Bin2 = get_in_string(Val),
			Bin3 = re:replace(Operator, "", "", [global, {return, binary}]),
			get_where_sql(T, <<Expr/binary, "`", Bin1/binary, "`", Bin3/binary, "'", Bin2/binary, "' and ">>);
		_ ->
			Bin2 = re:replace(Val, "'", "''", [global, {return, binary}]),
			Bin3 = re:replace(Operator, "", "", [global, {return, binary}]),
			get_where_sql(T, <<Expr/binary, "`", Bin1/binary, "`", Bin3/binary, "'", Bin2/binary, "' and ">>)
	end;

get_where_sql([{Field, Operator, Val}], Expr) ->
	Bin1 = util_data:to_binary(Field),
	Bin2 = util_data:to_binary(Val),
	Bin3 = re:replace(Operator, "", "", [global, {return, binary}]),
	<<"where ", Expr/binary, "`", Bin1/binary, "`", Bin3/binary, Bin2/binary>>;

get_where_sql([{Field, Operator, Val} | T], Expr) ->
	Bin1 = util_data:to_binary(Field),
	Bin2 = util_data:to_binary(Val),
	Bin3 = re:replace(Operator, "", "", [global, {return, binary}]),
	get_where_sql(T, <<Expr/binary, "`", Bin1/binary, "`", Bin3/binary, Bin2/binary, " and ">>);

get_where_sql([{Field, Operator, Val, OrAnd}], Expr) when is_binary(Val) orelse is_list(Val) ->
	Bin1 = util_data:to_binary(Field),
	Bin2 = re:replace(Val, "'", "''", [global, {return, binary}]),
	Bin3 = re:replace(OrAnd, "", "", [global, {return, binary}]),
	Bin4 = re:replace(Operator, "", "", [global, {return, binary}]),
	<<"where ", Expr/binary, "`", Bin1/binary, "`", Bin4/binary, "'", Bin2/binary, "' ", Bin3/binary>>;

get_where_sql([{Field, Operator, Val, OrAnd} | T], Expr) when is_binary(Val) orelse is_list(Val) ->
	Bin1 = util_data:to_binary(Field),
	Bin2 = re:replace(Val, "'", "''", [global, {return, binary}]),
	Bin3 = re:replace(OrAnd, "", "", [global, {return, binary}]),
	Bin4 = re:replace(Operator, "", "", [global, {return, binary}]),
	get_where_sql(T, <<Expr/binary, "`", Bin1/binary, "`", Bin4/binary, "'", Bin2/binary, "' ", Bin3/binary, " ">>);

get_where_sql([{Field, Operator, Val, OrAnd}], Expr) ->
	Bin1 = util_data:to_binary(Field),
	Bin2 = util_data:to_binary(Val),
	Bin3 = re:replace(OrAnd, "", "", [global, {return, binary}]),
	Bin4 = re:replace(Operator, "", "", [global, {return, binary}]),
	<<"where ", Expr/binary, "`", Bin1/binary, "`", Bin4/binary, "'", Bin2/binary, "' ", Bin3/binary>>;

get_where_sql([{Field, Operator, Val, OrAnd} | T], Expr) ->
	Bin1 = util_data:to_binary(Field),
	Bin2 = util_data:to_binary(Val),
	Bin3 = re:replace(OrAnd, "", "", [global, {return, binary}]),
	Bin4 = re:replace(Operator, "", "", [global, {return, binary}]),
	get_where_sql(T, <<Expr/binary, "`", Bin1/binary, "`", Bin4/binary, "'", Bin2/binary, "' ", Bin3/binary, " ">>).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

get_order_sql([], Expr) ->
	Expr;

get_order_sql([{Field}], Expr) ->
	Bin1 = util_data:to_binary(Field),
	<<"order by ", Expr/binary, "`", Bin1/binary, "`">>;

get_order_sql([{Field} | T], Expr) ->
	Bin1 = util_data:to_binary(Field),
	get_order_sql(T, <<Expr/binary, "`", Bin1/binary, "`,">>);

get_order_sql([{Field, Order}], Expr) ->
	Bin1 = util_data:to_binary(Field),
	Bin2 = util_data:to_binary(Order),
	<<"order by ", Expr/binary, "`", Bin1/binary, "` ", Bin2/binary>>;

get_order_sql([{Field, Order} | T], Expr) ->
	Bin1 = util_data:to_binary(Field),
	Bin2 = util_data:to_binary(Order),
	get_order_sql(T, <<Expr/binary, "`", Bin1/binary, "` ", Bin2/binary, ",">>).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

get_in_string(RecordList) ->
	NewLast = tl(RecordList),
	FirstRecord = lists:nth(1, RecordList),
	F = fun(Record, Acc) ->
		Bin1 = re:replace(Record, "'", "''", [global, {return, binary}]),
		<<Acc/binary, ", '", Bin1/binary, "'">>
	end,
	Bin0 = re:replace(FirstRecord, "'", "''", [global, {return, binary}]),
	Acc0 = <<"'", Bin0/binary, "'">>,
	lists:foldl(F, Acc0, NewLast).