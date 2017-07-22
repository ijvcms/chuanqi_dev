%% Author: ming
%% Created: 2011-9-9
%% Description: TODO: Add description to config
-module(config).

%%
%% Include files
%%
-include("common.hrl").
-include("record.hrl").
-include("proto_back.hrl").
-include("util_json.hrl").
-define(APP, server).

%%
%% Exported Functions
%%
-compile(export_all).

%% ====================================================================
%% API functions
%% ====================================================================
get_env(Env) ->
	case application:get_env(?APP, Env) of
		{ok, Result} ->
			Result;
		undefined ->
			throw(undefined)
	end.

%% @doc 获取当前工作目录
%% @spec get_cwd() -> Dir.
get_cwd() ->
	case application:get_env(?APP, cwd) of
		{ok, Cwd} -> Cwd;
		_ -> "."
	end.
%% 获取服务器id
get_server_no() ->
	case application:get_env(?APP, server_no) of
		{ok, Key} -> Key;
		_ -> throw(undifined)
	end.

get_login_key() ->
	case application:get_env(?APP, login_key) of
		{ok, Key} -> Key;
		_ -> throw(undifined)
	end.

%% 获取ip与端口配置
get_tcp_listener() ->
	case application:get_env(?APP, tcp_listener) of
		{ok, false} -> throw(undefined);
		{ok, Tcp_listener} ->
			try
				{_, Ip} = lists:keyfind(ip, 1, Tcp_listener),
				{_, Port} = lists:keyfind(port, 1, Tcp_listener),
				[Ip, Port]
			catch
				_:_ -> exit({bad_config, {server, {tcp_listener, config_error}}})
			end;
		undefined -> throw(undefined)
	end.
%% 获取ip与端口配置
get_tcp_listener_html() ->
	%% 组合兑换码参数
	TestData = lists:concat([
		"service_id=", config:get_server_no()
	]),
	%%td20150239code=11212323&platform_id=10&player_id=111&service_id=1004
	%% 添加key属性信息
	%%{ok, {_,_,Body}}
	%% http请求 获取内容
	{ok, {_, _, Body}} = httpc:request(post, {"http://123.206.225.144/chuanqi_mg/index.php/Home/Index/get_server_info_v2_2",
		[], "application/x-www-form-urlencoded", TestData}, [], []),

	?ERR("~n data~p  http: ~p~n", [TestData, Body]),
	ServerInfo = ?JSON_TO_RECORD(back_server_info, Body),


	Post = [{ip, "127.0.0.1"}, {port, ServerInfo#back_server_info.service_port}],
	application:set_env(?APP, tcp_listener, Post),
	%% 开服限制在使用
%% 	application:set_env(?APP, start_time, {{2016, 9, 12}, {10, 0, 0}}),
%% 	active_lib:reset(),
	application:set_env(?APP, begin_time, ServerInfo#back_server_info.begin_time),%% 获取服务器列表开启显示的时间
	application:set_env(?APP, socket_ip, ServerInfo#back_server_info.ip),%% 获取服务器连接的ip地址
	application:set_env(?APP, socket_port, ServerInfo#back_server_info.service_port),%% 获取服务器连接的端口号
	application:set_env(?APP, background_port, ServerInfo#back_server_info.port),%% 赋值后端端口号
	application:set_env(?APP, robot_time, ServerInfo#back_server_info.robot_time),%% 机器人开启时间
	application:set_env(?APP, merge_time, util_date:unixtime_to_local_time(ServerInfo#back_server_info.merge_time)),%% 合服时间
	application:set_env(?APP, merge_times, ServerInfo#back_server_info.merge_times),%% 合服次数
	application:set_env(?APP, cross_path, util_data:to_atom(erlang:binary_to_list(ServerInfo#back_server_info.cross_path))),%% 跨服服务器地址
	application:set_env(?APP, robot_path, util_data:to_atom(erlang:binary_to_list(ServerInfo#back_server_info.robot_path))),%% 机器人对应地址

	reload_manager_config_html(),
	ok.

%% 获取跨服区的服务器列表
get_cross_server_list_html() ->
	TestData = lists:concat([
		"service_id=", config:get_server_no()
	]),
	%% http请求 获取内容
	{ok, {_, _, Body}} = httpc:request(post, {"http://123.206.225.144/chuanqi_mg/index.php/Home/Index/get_server_info_list",
		%% {ok, {_, _, Body}} = httpc:request(post, {"http://www/chuanqi_mg/index.php/Home/Index/get_operate_active_conf",
		[], "application/x-www-form-urlencoded", TestData}, [], []),

%% 	?ERR("~p", [Body]),
	A = ?JSON_TO_RECORD(back_cross_server_info, Body),
	%% io:format("ddddd:~p~n", [A]),
	A.

%% 获取运营活动配置配置配置
get_operate_active_conf_html() ->
	TestData = lists:concat([
		"service_id=", config:get_server_no()
	]),
	%% http请求 获取内容
	{ok, {_, _, Body}} = httpc:request(post, {"http://123.206.225.144/chuanqi_mg/index.php/Home/Index/get_operate_active_conf",
		%% {ok, {_, _, Body}} = httpc:request(post, {"http://www/chuanqi_mg/index.php/Home/Index/get_operate_active_conf",
		[], "application/x-www-form-urlencoded", TestData}, [], []),

%% 	?ERR("~p", [Body]),
	A = ?JSON_TO_RECORD(back_req_ref_operate_active_conf, Body),
	%% io:format("ddddd:~p~n", [A]),
	A.

get_operate_sub_type_conf_html() ->
	TestData = lists:concat([
		"service_id=", config:get_server_no()
	]),
	%% http请求 获取内容
	{ok, {_, _, Body}} = httpc:request(post, {"http://123.206.225.144/chuanqi_mg/index.php/Home/Index/get_operate_sub_type_conf",
		%% {ok, {_, _, Body}} = httpc:request(post, {"http://www/chuanqi_mg/index.php/Home/Index/get_operate_sub_type_conf",
		[], "application/x-www-form-urlencoded", TestData}, [], []),

	A = ?JSON_TO_RECORD(back_req_ref_operate_sub_type_conf, Body),
	%% io:format("ccccc:~p~n", [A]),
	A.

reload_manager_config_html() ->
	Params = lists:concat([
		"service_id=", config:get_server_no()
	]),

	{ok, {_, _, Body}} = httpc:request(post, {"http://123.206.225.144/chuanqi_mg/index.php/Home/Index/config",
		[], "application/x-www-form-urlencoded", Params}, [], []),

	io:format("manager_config data~p  http: ~p~n", [Params, Body]),
	{ok, ManagerConfigs, []} = rfc4627:decode(Body),
	ManagerConfigs2 = [list_to_tuple(R) || R <- ManagerConfigs],

	PayType =
		case lists:keyfind(<<"paytype">>, 1, ManagerConfigs2) of
			{_, Val} ->
				util_data:to_integer(Val);
			_ ->
				0
		end,
	application:set_env(?APP, paytype, PayType),
	io:format("~p~n", [ManagerConfigs]),
	ok.

get_manager_paytype() ->
	case application:get_env(?APP, paytype) of
		{ok, Value} -> Value;
		_ -> 0
	end.

get_log_level() ->
	case application:get_env(?APP, log_level) of
		{ok, Log_level} -> Log_level;
		_ -> 3
	end.

get_log_list() ->
	case application:get_env(?APP, log_list) of
		{ok, LogList} -> LogList;
		_ -> []
	end.

get_log_tty() ->
	case application:get_env(?APP, log_tty) of
		{ok, true} ->
			true;
		_ -> false
	end.

get_gm_switch() ->
	case application:get_env(?APP, gm_switch) of
		{ok, on} -> on;
		_ ->
			false
	end.

get_mysql_config(Data_Config) ->
	case application:get_env(?APP, Data_Config) of
		{ok, false} -> throw(undefined);
		{ok, Mysql_config} ->
			{_, Host} = lists:keyfind(host, 1, Mysql_config),
			{_, Port} = lists:keyfind(port, 1, Mysql_config),
			{_, User} = lists:keyfind(user, 1, Mysql_config),
			{_, Password} = lists:keyfind(password, 1, Mysql_config),
			{_, DB} = lists:keyfind(db, 1, Mysql_config),
			{_, Encode} = lists:keyfind(encode, 1, Mysql_config),
			[Host, Port, User, Password, DB, Encode];
		undefined -> throw(undefined)
	end.

%% 版本号
get_app_version() ->
	case application:get_env(?APP, app_version) of
		{ok, Version} ->
			Version;
		_ ->
			2013110
	end.
%% 获取后台端口
get_background_port() ->
	case application:get_env(?APP, background_port) of
		{ok, Port} ->
			Port;
		_ ->
			0
	end.

%% 获取服务器端口
get_socket_port() ->
	case application:get_env(?APP, socket_port) of
		{ok, Port} ->
			Port;
		_ ->
			0
	end.

%% 获取服务器ip
get_socket_ip() ->
	case application:get_env(?APP, socket_ip) of
		{ok, Ip} ->
			erlang:binary_to_list(Ip);
		_ ->
			null
	end.

%% 获取开服时间
get_start_time() ->
	case ets:lookup(?ETS_COMMON_CONFIG, start_time) of
		[EtsInfo] ->
			EtsInfo#ets_common_config.value;
		_ ->
			case application:get_env(?APP, start_time) of
				{ok, Result} ->
					Time = util_date:time_tuple_to_unixtime(Result),
					ets:insert(?ETS_COMMON_CONFIG, #ets_common_config{key = start_time, value = Time}),
					Time;
				undefined ->
					CurTime = util_date:unixtime(),
					ets:insert(?ETS_COMMON_CONFIG, #ets_common_config{key = start_time, value = CurTime}),
					CurTime
			end
	end.
%% 获取是否开启机器人
get_is_robot() ->
	case application:get_env(?APP, robot_time) of
		{ok, Result} ->
			Result > util_date:unixtime();
		_ ->
			false
	end.

%% 获取跨服地址
get_cross_path() ->
	case application:get_env(?APP, cross_path) of
		{ok, Result} ->
			Result;
		_ ->
			null
	end.

%% 获取机器人服务器对应地址
get_robot_path() ->
	case application:get_env(?APP, robot_path) of
		{ok, Result} ->
			Result;
		_ ->
			null
	end.

%% 获取php开启时间
get_begin_time() ->
	case application:get_env(?APP, begin_time) of
		{ok, Result} ->
			Result;
		_ ->
			get_start_time()
	end.
%% 获取开服时间
get_start_time_str() ->
	case application:get_env(?APP, start_time) of
		{ok, Port} ->
			Port;
		_ ->
			{{1970, 1, 1}, {8, 0, 0}}
	end.

%%合服的所有区id
get_merge_servers() ->
	case application:get_env(?APP, merge_servers) of
		{ok, MergeServers} -> MergeServers;
		_ -> []
	end.

%%合服时间
get_merge_time() ->
	case application:get_env(?APP, merge_time) of
		{ok, Cfg} ->
			Cfg;
		_ -> {{2016, 09, 23}, {10, 0, 0}}
	end.

%%合服次数，默认0
get_merge_times() ->
	case application:get_env(?APP, merge_times) of
		{ok, Cfg} -> Cfg;
		_ -> 0
	end.

get_server_name() ->
	case application:get_env(?APP, source_servers) of
		{ok, ServerList} ->
			Length = length(ServerList),
			case Length > 1 of
				true ->
%% 					[Frist | _] = ServerList,
%% 					Last = lists:last(ServerList),
					lists:concat([get_server_no() rem 1000]);
				_ ->
					lists:concat([get_server_no() rem 1000])
			end;
		_ ->
			lists:concat([get_server_no() rem 1000])
	end.