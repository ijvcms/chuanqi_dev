%% Author: ming
%% Created: 2012-11-20
%% Description: TODO: Add description to db
-module(db).

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

init() ->
    init_mysql(),
    db_log:init_mysql().

%% ====================================================================
%% API functions
%% ====================================================================
init_mysql() ->
    [Host, Port, User, Password, DBName, Encode] = config:get_mysql_config(?DB_POOL),
    case mysql:start_link(?DB_POOL_MIAND, Host, Port, User, Password, DBName, fun(_, _, _, _) -> ok end, Encode) of
        {ok, _} ->
            TDBName = lists:concat([DBName, "_", config:get_server_no()]),
            %% 如果没有数据库的话，就创建数据库
            case db_mysql:is_exists_database(?DB_POOL_MIAND, TDBName) of
                false ->
                    db_mysql:create_database(?DB_POOL_MIAND, ?DB_POOL, "chuanqi_db", Host, Port, User, Password, TDBName, Encode);
                _ ->
                    case mysql:connect(?DB_POOL, Host, Port, User, Password, TDBName, Encode, true) of
                        {ok, _} ->
                            update_sql(?DB_POOL),
                            db_data_init:delete_lottery_old(),
                            %% 加入节点监控信息
                            ?TRACE("mysql is started");
                        {error, _Reason} ->
                            error
                    end
            end;
        {error, _Reason} ->
            error
    end.

update_sql(PoolId) ->
    {ok, Dir} = file:get_cwd(),
    %% 组合成文件夹路径
    Dir1 = case PoolId of
               ?DB_POOL ->
                   re:replace(Dir, "config", "db_script/db_sql", [{return, list}]);
               ?DB_POOL_LOG ->
                   re:replace(Dir, "config", "db_script/log_sql", [{return, list}]);
               _ ->
                   null
           end,

    ServerId = config:get_server_no(),
    UpdateFile = re:replace(Dir, "config", lists:concat(["db_script/", "update", ServerId, ".txt"]), [{return, list}]),
    FileList = util_file:list_dir_recursive(Dir1),
    ?INFO("Dir1 ~p", [{Dir1, FileList}]),
    F = fun(X) ->
        IsSQL =
            case file:read_file(UpdateFile) of
                {ok, UpdateInfo} ->
                    T = erlang:binary_to_list(UpdateInfo),
                    UpdateList = string:tokens(T, "\n"),
                    case lists:member(X, UpdateList) of
                        true ->
                            false;
                        _ ->
                            UpdateInfo1 = lists:concat([T, "\n", X]),
                            file:write_file(UpdateFile, UpdateInfo1),
                            true
                    end;
                _ ->
                    file:write_file(UpdateFile, X),
                    true
            end,
        case IsSQL of
            true ->
                db_mysql:init_sql_file(PoolId, X);
            _ ->
                skip
        end
    end,
    [F(X) || X <- FileList].




connect(PoolId) ->
    [Host, Port, User, Password, DBName, Encode] = config:get_mysql_config(PoolId),
    case mysql:connect(PoolId, Host, Port, User, Password, DBName, Encode, true) of
        {ok, _} ->
            %% 加入节点监控信息
            ?TRACE(lists:concat(["mysql(", PoolId, ",", DBName, ") is connect"]));
        {error, _Reason} ->
            error
    end.

execute(Sql) ->
    ?DB_MODULE:execute(?DB_POOL, Sql).

is_exists(DBName, TableName) ->
    ?DB_MODULE:is_exists(?DB_POOL, DBName, TableName).

%% 插入数据表
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%	成功返回影响的行数   出错返回 Errmsg
%%  insert(TableName, FieldValueList)
%%  TableName = atom
%%  FieldValueList = [{Field1,Value1},{Field2,Value2},...]
insert(TableName, FieldValueList) ->
    ?DB_MODULE:insert(?DB_POOL, TableName, FieldValueList).

%% 修改数据表(replace方式)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%	成功返回影响的行数   出错返回 Errmsg
%%  replace(TableName, FieldValueList)
%%  TableName = atom
%%  FieldValueList = [{Field1,Value1},{Field2,Value2},...]
replace(TableName, FieldValueList) ->
    ?DB_MODULE:replace(?DB_POOL, TableName, FieldValueList).

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
    ?DB_MODULE:update(?DB_POOL, TableName, FieldValueList, WhereList).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%	成功返回List   出错返回 Errmsg
select_all(TableName, Fields, WhereList) ->
    ?DB_MODULE:select_all(?DB_POOL, TableName, Fields, WhereList, [], []).

select_all(TableName, Fields, WhereList, OrderList) when is_list(Fields) ->
    ?DB_MODULE:select_all(?DB_POOL, TableName, Fields, WhereList, OrderList, []).

select_all(TableName, Fields, WhereList, OrderList, Limit) ->
    ?DB_MODULE:select_all(?DB_POOL, TableName, Fields, WhereList, OrderList, Limit).

select_all(Sql) ->
    ?DB_MODULE:select_all(?DB_POOL, Sql).

%% 获取一个数据字段
select_one(TableName, Fields, WhereList) ->
    ?DB_MODULE:select_one(?DB_POOL, TableName, Fields, WhereList).

select_one(TableName, Fields, WhereList, OrderList, Limit) ->
    ?DB_MODULE:select_one(?DB_POOL, TableName, Fields, WhereList, OrderList, Limit).

select_one(Sql) ->
    ?DB_MODULE:select_one(?DB_POOL, Sql).

%% 取出一行
select_row(TableName, Fields, WhereList) ->
    ?DB_MODULE:select_row(?DB_POOL, TableName, Fields, WhereList, []).

select_row(TableName, Fields, WhereList, OrderList) ->
    ?DB_MODULE:select_row(?DB_POOL, TableName, Fields, WhereList, OrderList).

select_row(Sql) ->
    ?DB_MODULE:select_row(?DB_POOL, Sql).

%% 获取数据行数
select_count(TableName, WhereList) ->
    ?DB_MODULE:select_count(?DB_POOL, TableName, WhereList).

select_max(TableName, Field) ->
    ?DB_MODULE:select_max(?DB_POOL, TableName, Field, []).

select_max(TableName, Field, WhereList) ->
    ?DB_MODULE:select_max(?DB_POOL, TableName, Field, WhereList).

%%	成功返回影响的行数   出错返回 Errmsg
delete(TableName, WhereList) ->
    ?DB_MODULE:delete(?DB_POOL, TableName, WhereList).

