%%%-------------------------------------------------------------------
%%% @author zhengsiying
%%% @copyright (C) 2015, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 15. 七月 2015 下午7:25
%%%-------------------------------------------------------------------
-module(db_ex).

-include("common.hrl").

%% API
-compile([export_all]).

%% ====================================================================
%% API functions
%% ====================================================================
init_mysql(PoolId) ->
	[Host, Port, User, Password, DBName, Encode] = config:get_mysql_config(PoolId),
	case mysql:start_link(PoolId, Host, Port, User, Password, DBName, fun(_, _, _, _) -> ok end, Encode) of
		{ok, _} ->
			case mysql:connect(PoolId, Host, Port, User, Password, DBName, Encode, true) of
				{ok, _} ->
					%% 加入节点监控信息
					?TRACE("mysql is started");
				{error, _Reason} ->
					error
			end;
		{error, _Reason} ->
			error
	end.

connect(PoolId) ->
	[Host, Port, User, Password, DBName, Encode] = config:get_mysql_config(PoolId),
	case mysql:connect(PoolId, Host, Port, User, Password, DBName, Encode, true)of
		{ok, _}->
			%% 加入节点监控信息
			?TRACE(lists:concat(["mysql(", PoolId, ",", DBName, ") is connect"]));
		{error, _Reason}->
			error
	end.

execute(PoolId, Sql) ->
	?DB_MODULE:execute(PoolId, Sql).

is_exists(PoolId, TableName) ->
	?DB_MODULE:is_exists(PoolId, TableName).

insert(PoolId, TableName, FieldValueList) ->
	?DB_MODULE:insert(PoolId, TableName, FieldValueList).

replace(PoolId, TableName, FieldValueList) ->
	?DB_MODULE:replace(PoolId, TableName, FieldValueList).

select_all(PoolId, TableName, Fields, WhereList) when is_list(Fields) ->
	?DB_MODULE:select_all(PoolId, TableName, Fields, WhereList, [], []).

select_all(PoolId, TableName, Fields, WhereList, OrderList) when is_list(Fields) ->
	?DB_MODULE:select_all(PoolId, TableName, Fields, WhereList, OrderList, []).

select_all(PoolId, TableName, Fields, WhereList, OrderList, Limit) ->
	?DB_MODULE:select_all(PoolId, TableName, Fields, WhereList, OrderList, Limit).

select_all(PoolId, Sql) ->
	?DB_MODULE:select_all(PoolId, Sql).

%% 获取一个数据字段
select_one(PoolId, TableName, Fields, WhereList) ->
	?DB_MODULE:select_one(PoolId, TableName, Fields, WhereList).

select_one(PoolId, TableName, Fields, WhereList, OrderList, Limit) ->
	?DB_MODULE:select_one(PoolId, TableName, Fields, WhereList, OrderList, Limit).

select_one(PoolId, Sql) ->
	?DB_MODULE:select_one(PoolId, Sql).

%% 取出一行
select_row(PoolId, TableName, Fields, WhereList) ->
	?DB_MODULE:select_row(PoolId, TableName, Fields, WhereList, []).

select_row(PoolId, TableName, Fields, WhereList, OrderList) ->
	?DB_MODULE:select_row(PoolId, TableName, Fields, WhereList, OrderList).

select_row(PoolId, Sql) ->
	?DB_MODULE:select_row(PoolId, Sql).

%% 获取数据行数
select_count(PoolId, TableName, WhereList) ->
	?DB_MODULE:select_count(PoolId, TableName, WhereList).

select_max(PoolId, TableName, Field) ->
	?DB_MODULE:select_max(PoolId, TableName, Field, []).

select_max(PoolId, TableName, Field, WhereList) ->
	?DB_MODULE:select_max(PoolId, TableName, Field, WhereList).

%%	成功返回影响的行数   出错返回 Errmsg
delete(PoolId, TableName, WhereList) ->
	?DB_MODULE:delete(PoolId, TableName, WhereList).

%% ====================================================================
%% Internal functions
%% ====================================================================
