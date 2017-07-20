%%%--------------------------------------
%%% @Module  : db_mysql
%%% @Author  : ming
%%% @Created : 2013.12.22
%%% @Description: mysql 数据库操作  
%%%--------------------------------------
-module(db_mysql).
-include("common.hrl").
-include("record.hrl").
-compile([export_all]).

execute(PoolId, Sql) ->
	db_mysqlutil:execute({Sql, PoolId}).

get_db_name(PoolId) ->
	[_Host, _Port, _User, _Password, DBName, _Encode] = config:get_mysql_config(PoolId),
	lists:concat([DBName, "_", config:get_server_no()]).

%% 表是否存在
is_exists(PoolId, DBName, TableName) ->
	Sql = io_lib:format(<<"SELECT COUNT(TABLE_NAME) FROM information_schema.TABLES WHERE TABLE_SCHEMA='~s' and table_name = '~s'">>, [util_data:to_list(DBName), util_data:to_list(TableName)]),
	Count = db_mysqlutil:get_one({Sql, PoolId}),
	Count >= 1.

%% 判断数据库是否存在
is_exists_database(PoolId, DataBaseName) ->
	Sql = io_lib:format(<<"SELECT count(SCHEMA_NAME) FROM information_schema.SCHEMATA where SCHEMA_NAME='~s'">>, [util_data:to_list(DataBaseName)]),
	Count = db_mysqlutil:get_one({Sql, PoolId}),
	Count >= 1.

%% 创建数据库
create_database(MianPoolId, PoolId, FileName, Host, Port, User, Password, TDBName, Encode) ->
	%% 创建数据库
	Sql = io_lib:format(<<"CREATE DATABASE `~s` DEFAULT CHARACTER SET utf8 COLLATE utf8_general_ci">>, [util_data:to_list(TDBName)]),
	execute(MianPoolId, Sql),
	case mysql:connect(PoolId, Host, Port, User, Password, TDBName, Encode, true) of
		{ok, _} ->
			init_database(PoolId, FileName),
			db:update_sql(?DB_POOL),
			%% 加入节点监控信息
			?TRACE(lists:concat(["mysql(", PoolId, ",", TDBName, ") is connect"]));
		{error, _Reason} ->
			?ERR(" ~n error ~p ~n ", [_Reason]),
			error
	end.

%% 初始化数据库数据
init_database(PoolId, FileName) ->
	{ok, Dir} = file:get_cwd(),
	%% 组合成文件夹路径
	Dir1 = re:replace(Dir, "config", "db_script/", [{return, list}]),
	FileDir = lists:concat([Dir1, FileName, ".sql"]),
	init_sql_file(PoolId,FileDir).

%% 执行sql文件
init_sql_file(PoolId, FileDir) ->
	{ok, SqlFile} = file:read_file(FileDir),
	T = erlang:binary_to_list(SqlFile),
	SqlList = string:tokens(T, ";"),
	execute_list(PoolId, SqlList).

execute_list(_PoolId, []) ->
	ok;
%% 执行sql语句
execute_list(PoolId, [Sql | H]) ->
	execute(PoolId, Sql),
	execute_list(PoolId, H).


%% 插入数据表
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%	成功返回影响的行数   出错返回 Errmsg
%%  insert(TableName, FieldValueList)
%%  TableName = atom
%%  FieldValueList = [{Field1,Value1},{Field2,Value2},...]
insert(PoolId, TableName, FieldValueList) ->
	Sql = make_sql:insert(TableName, FieldValueList),
	db_mysqlutil:execute({Sql, PoolId}).

%% 修改数据表(replace方式)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%	成功返回影响的行数   出错返回 Errmsg
%%  replace(TableName, FieldValueList)
%%  TableName = atom
%%  FieldValueList = [{Field1,Value1},{Field2,Value2},...]
replace(PoolId, TableName, FieldValueList) ->
	Sql = make_sql:replace(TableName, FieldValueList),
	db_mysqlutil:execute({Sql, PoolId}).

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
update(PoolId, TableName, FieldValueList, WhereList) ->
	Sql = make_sql:update(TableName, FieldValueList, WhereList),
	db_mysqlutil:execute({Sql, PoolId}).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%	成功返回List   出错返回 Errmsg
select_all(PoolId, TableName, Fields, WhereList) ->
	select_all(PoolId, TableName, Fields, WhereList, [], []).

select_all(PoolId, TableName, Fields, WhereList, OrderList) ->
	select_all(PoolId, TableName, Fields, WhereList, OrderList, []).

select_all(PoolId, TableName, Fields, WhereList, OrderList, Limit) ->
	Sql = make_sql:select(TableName, Fields, WhereList, OrderList, Limit),
	db_mysqlutil:get_all({Sql, PoolId}).

select_all(PoolId, Sql) ->
	db_mysqlutil:get_all({Sql, PoolId}).

%% 获取一个数据字段
select_one(PoolId, TableName, Fields, WhereList) ->
	Sql = make_sql:select(TableName, Fields, WhereList),
	db_mysqlutil:get_one({Sql, PoolId}).

select_one(PoolId, TableName, Fields, WhereList, OrderList, Limit) ->
	Sql = make_sql:select(TableName, Fields, WhereList, OrderList, Limit),
	db_mysqlutil:get_one({Sql, PoolId}).

select_one(PoolId, Sql) ->
	db_mysqlutil:get_one({Sql, PoolId}).

%% 取出一行
select_row(PoolId, TableName, Fields, WhereList) ->
	select_row(PoolId, TableName, Fields, WhereList, []).

select_row(PoolId, TableName, Fields, WhereList, OrderList) ->
	Sql = make_sql:select(TableName, Fields, WhereList, OrderList, [1]),
	db_mysqlutil:get_row({Sql, PoolId}).

select_row(PoolId, Sql) ->
	db_mysqlutil:get_row({Sql, PoolId}).

%% 获取数据行数
select_count(PoolId, TableName, WhereList) ->
	Sql = make_sql:select(TableName, "count(1)", WhereList),
	db_mysqlutil:get_one({Sql, PoolId}).

select_max(PoolId, TableName, Field) ->
	select_max(PoolId, TableName, Field, []).

select_max(PoolId, TableName, Field, WhereList) ->
	Sql = make_sql:select(TableName, {max, Field}, WhereList),
	db_mysqlutil:get_one({Sql, PoolId}).

%%	成功返回影响的行数   出错返回 Errmsg
delete(PoolId, TableName, WhereList) ->
	Sql = make_sql:delete(TableName, WhereList),
	db_mysqlutil:execute({Sql, PoolId}).
