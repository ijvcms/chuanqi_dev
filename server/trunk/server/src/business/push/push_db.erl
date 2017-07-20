%%%-------------------------------------------------------------------
%%% @author qhb
%%% @copyright (C) 2016, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 20. 七月 2016 下午2:36
%%%-------------------------------------------------------------------
-module(push_db).

%% API
-export([
	init_mysql/0
]).


init_mysql() ->
	[Host, Port, User, Password, _DBName, Encode] = config:get_mysql_config(mysql_conn),
	PoolId = list_to_atom(lists:concat([pool])),
	NewDBName = "chuanqi_mg",
	case mysql:start_link(PoolId, Host, Port, User, Password, NewDBName, fun(_, _, _, _) -> ok end, Encode) of
		{ok, _} ->
			case mysql:connect(PoolId, Host, Port, User, Password, NewDBName, Encode, true) of
				{ok, _} ->
					io:format("~p mysql is started~n", [PoolId]);
				{error, _Reason} ->
					error
			end;
		{error, _Reason} ->
			_Reason
	end.