%% @author qhb
%% @doc @todo Add description to cacheutil_table.
%% 分表状态

-module(cache_table).
-include("common.hrl").

%% ====================================================================
%% API functions
%% ====================================================================
-export([
		 init/0,
		 is_exist/2,
		 create_if_not_exist/3,
		 create/3
		]).


init() ->
	ets:new(ets_table_status, [named_table, public, set]).


is_exist(PoolId, TableName) ->
	Key = {PoolId, TableName},
	EtsValue = util_ets:get(ets_table_status, Key),
	case EtsValue of
		undefined ->
			DbName = get_dbname_by_pool_id(PoolId),
			case db_mysql:is_exists(PoolId, DbName, TableName) of
				true ->
					ets:insert(ets_table_status, {Key, true}),
					true;
				false ->
					false
			end;
		{Key, _} ->
			true
	end.

create_if_not_exist(PoolId, TableName, CreateTableSql) ->
	case is_exist(PoolId, TableName) of
		true ->
			skip;
		false ->
			create(PoolId, TableName, CreateTableSql)
	end.


create(PoolId, TableName, CreateTableSql) ->
	Sql = io_lib:format(CreateTableSql, [TableName]),
	Sql1 = xmerl_ucs:to_utf8(Sql),
	db_mysql:execute(PoolId, Sql1).

%% ====================================================================
%% Internal functions
%% ====================================================================

%%数据库连接与数据库对应关系
get_dbname_by_pool_id(?DB_POOL_DATA) ->
	"chuanqi_data";
get_dbname_by_pool_id(PoolId) ->
	[_Host, _Port, _User, _Password, DBName, _Encode] = config:get_mysql_config(PoolId),
	lists:concat([DBName, "_", config:get_server_no()]).