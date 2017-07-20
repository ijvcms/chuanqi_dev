%% Author: ming
%% Created: 2012-11-20
%% Description: TODO: Add description to db
-module(db_log).

%%
%% Include files
%%
-include("common.hrl").
-include("record.hrl").
-include("db_record.hrl").
%%
%% Exported Functions
%%
-compile([export_all]).

%% ====================================================================
%% API functions
%% ====================================================================
init_mysql() ->
	connect_data(?DB_POOL_DATA),%%数据中心
	connect(?DB_POOL_LOG).

connect(PoolId) ->
	[Host, Port, User, Password, DBName, Encode] = config:get_mysql_config(PoolId),
	TDBName = lists:concat([DBName, "_", config:get_server_no()]),
	case db_mysql:is_exists_database(?DB_POOL, TDBName) of
		false ->
			db_mysql:create_database(?DB_POOL, PoolId, "chuanqi_log", Host, Port, User, Password, TDBName, Encode);
		_ ->
			case mysql:connect(PoolId, Host, Port, User, Password, TDBName, Encode, true) of
				{ok, _} ->
					db:update_sql(PoolId),
					%% 加入节点监控信息
					?TRACE(lists:concat(["mysql(", PoolId, ",", TDBName, ") is connect"]));
				{error, _Reason} ->
					?ERR(" ~n error ~p ~n ", [_Reason]),
					error
			end
	end.

%%集中的数据存储库
connect_data(PoolId) ->
	[Host, Port, User, Password, _DBName, Encode] = config:get_mysql_config(?DB_POOL_LOG),
	TDBName = "chuanqi_data",
	case db_mysql:is_exists_database(?DB_POOL, TDBName) of
		false ->
			db_mysql:create_database(?DB_POOL, PoolId, "chuanqi_log", Host, Port, User, Password, TDBName, Encode);
		_ ->
			case mysql:connect(PoolId, Host, Port, User, Password, TDBName, Encode, true) of
				{ok, _} ->
					%% 加入节点监控信息
					?TRACE(lists:concat(["mysql(", PoolId, ",", TDBName, ") is connect"]));
				{error, _Reason} ->
					?ERR(" ~n error ~p ~n ", [_Reason]),
					error
			end
	end.

execute(Sql) ->
	db_mysql:execute(?DB_POOL_LOG, Sql).

is_exists(DBName, TableName) ->
	db_mysql:is_exists(?DB_POOL_LOG, DBName, TableName).


%% 插入数据表
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%	成功返回影响的行数   出错返回 Errmsg
%%  insert(TableName, FieldValueList)
%%  TableName = atom
%%  FieldValueList = [{Field1,Value1},{Field2,Value2},...]
insert(TableName, FieldValueList) ->
	db_mysql:insert(?DB_POOL_LOG, TableName, FieldValueList).

%% 修改数据表(replace方式)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%	成功返回影响的行数   出错返回 Errmsg
%%  replace(TableName, FieldValueList)
%%  TableName = atom
%%  FieldValueList = [{Field1,Value1},{Field2,Value2},...]
replace(TableName, FieldValueList) ->
	?DB_MODULE:replace(?DB_POOL_LOG, TableName, FieldValueList).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%	成功返回影响的行数   出错返回 Errmsg
%%  update(TableName, FieldValueList,WhereList)
%%  TableName = atom
%%  FieldValueList = [{Field1,Value1},{Field2,Value2},...]
%%  WhereList = [{Field1,Value1},{Field2,Value2},...] |
%%              [{Field1,Operator1,Value1},{Field2,Operator2,Value2},...] |
%%              [{Field1,Operator1,Value1,Orand},{Field2,Operator2,Value2,Orand},...]
%%  Operator = "<" | ">" | "="...
%%  Orand = "or" | "and"
update(TableName, FieldValueList, WhereList) ->
	?DB_MODULE:update(?DB_POOL_LOG, TableName, FieldValueList, WhereList).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%	成功返回List   出错返回 Errmsg
select_all(TableName, Fields, WhereList) ->
	?DB_MODULE:select_all(?DB_POOL_LOG, TableName, Fields, WhereList, [], []).

select_all(TableName, Fields, WhereList, OrderList) when is_list(Fields) ->
	?DB_MODULE:select_all(?DB_POOL_LOG, TableName, Fields, WhereList, OrderList, []).

select_all(TableName, Fields, WhereList, OrderList, Limit) ->
	?DB_MODULE:select_all(?DB_POOL_LOG, TableName, Fields, WhereList, OrderList, Limit).

select_all(Sql) ->
	?DB_MODULE:select_all(?DB_POOL_LOG, Sql).

%% 获取一个数据字段
select_one(TableName, Fields, WhereList) ->
	?DB_MODULE:select_one(?DB_POOL_LOG, TableName, Fields, WhereList).

select_one(TableName, Fields, WhereList, OrderList, Limit) ->
	?DB_MODULE:select_one(?DB_POOL_LOG, TableName, Fields, WhereList, OrderList, Limit).

select_one(Sql) ->
	?DB_MODULE:select_one(?DB_POOL_LOG, Sql).

%% 取出一行
select_row(TableName, Fields, WhereList) ->
	?DB_MODULE:select_row(?DB_POOL_LOG, TableName, Fields, WhereList, []).

select_row(TableName, Fields, WhereList, OrderList) ->
	?DB_MODULE:select_row(?DB_POOL_LOG, TableName, Fields, WhereList, OrderList).

select_row(Sql) ->
	?DB_MODULE:select_row(?DB_POOL_LOG, Sql).

%% 获取数据行数
select_count(TableName, WhereList) ->
	?DB_MODULE:select_count(?DB_POOL_LOG, TableName, WhereList).

select_max(TableName, Field) ->
	?DB_MODULE:select_max(?DB_POOL_LOG, TableName, Field, []).

select_max(TableName, Field, WhereList) ->
	?DB_MODULE:select_max(?DB_POOL_LOG, TableName, Field, WhereList).

%%	成功返回影响的行数   出错返回 Errmsg
delete(TableName, WhereList) ->
	?DB_MODULE:delete(?DB_POOL_LOG, TableName, WhereList).

