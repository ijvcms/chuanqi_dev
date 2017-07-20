%%%-------------------------------------------------------------------
%%% @author qhb
%%% @copyright (C) 2016, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 14. 六月 2016 下午7:33
%%%-------------------------------------------------------------------
-module(restore_db).
-include("common.hrl").

%% API
-export([
	init_mysql/0,
	connect/1
]).

init_mysql() ->
	[Host, Port, User, Password, DBName, Encode] = config:get_mysql_config(?DB_POOL),
	case mysql:start_link(?DB_POOL_MIAND, Host, Port, User, Password, DBName, fun(_, _, _, _) -> ok end, Encode) of
		{ok, _} ->
			PoolId = list_to_atom(lists:concat([pool, 0])),
			ServerNo = config:get_server_no() - 100,%%用101来映射1
			TDBName = lists:concat([DBName, "_", ServerNo]),
			%%TDBName = DBName,
			%如果没有数据库的话，就创建数据库
			case db_mysql:is_exists_database(?DB_POOL_MIAND, TDBName) of
				false ->
					db_mysql:create_database(?DB_POOL_MIAND, PoolId, "chuanqi_db", Host, Port, User, Password, TDBName, Encode);
				_ ->
					case mysql:connect(PoolId, Host, Port, User, Password, TDBName, Encode, true) of
						{ok, _} ->
							io:format("restoredb ~p mysql is started~n", [ServerNo]);
						{error, _Reason} ->
							error
					end
			end;
		{error, _Reason} ->
			error
	end.

connect(ServerId) ->
	[Host, Port, User, Password, DBName, Encode] = config:get_mysql_config(mysql_conn),
	PoolId = list_to_atom(lists:concat([pool, ServerId])),
	NewDBName = lists:concat([DBName, '_', ServerId]),
	case mysql:connect(PoolId, Host, Port, User, Password, NewDBName, Encode, true) of
		{ok, _} ->
			io:format("~p mysql is connected~n", [PoolId]);
		{error, _Reason} ->
			error
	end.