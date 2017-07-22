%%%-------------------------------------------------------------------
%%% @author yubing
%%% @copyright (C) 2015, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 15. 十二月 2015 18:27
%%%-------------------------------------------------------------------
-module(player_id_name_lib).

-export([
	get_ets_player_id_name_by_playerid/1,
	get_ets_player_id_name_by_playername/1,
	get_ets_player_id_name_by_playerid_nofail/1,
	save_ets_player_task/2,
	save_ets_player/1,
	save_ets_player/3,
	save_ets_player_task_player_id/2,
	get_player_name/1,
%% 	check_username/1,
	is_no_name/1,
	add_server_user/5,
	do_add_server_user/6,
	checklogin/2,
	add_user_plug/5,
	do_add_user_plug/6
]).
-include("record.hrl").
-include("common.hrl").

%%  通过玩家名称获取信息
get_ets_player_id_name_by_playername(Name) ->
	case ets:lookup(?ETS_PLAYER_NAME_ID, Name) of
		[R | _] ->
			R;
		_ ->
			fail
	end.
%%  通过玩家名称获取信息
get_ets_player_id_name_by_playerid(PlayerId) ->
	case ets:lookup(?ETS_PLAYER_ID_NAME, PlayerId) of
		[R | _] ->
			R;
		_ ->
			fail
	end.

get_ets_player_id_name_by_playerid_nofail(PlayerId) ->
	case ets:lookup(?ETS_PLAYER_ID_NAME, PlayerId) of
		[R | _] ->
			R;
		_ ->
			#ets_player_id_name{}
	end.

%% 获取玩家名称
get_player_name(PlayerId) ->
	EtsPlayerIdName = get_ets_player_id_name_by_playerid_nofail(PlayerId),
	EtsPlayerIdName#ets_player_id_name.name.

%% 保存称号信息
save_ets_player(Info) ->
	ets:insert(?ETS_PLAYER_NAME_ID, Info),
	ets:insert(?ETS_PLAYER_ID_NAME, Info).

save_ets_player(PlayerId, Career, Name) ->
	Info = #ets_player_id_name
	{
		player_id = PlayerId,
		name = Name,
		merit_task_id = 0,
		career = Career
	},
	save_ets_player(Info).


save_ets_player_task(EtsPlayerInfo, TaskId) ->
	EtsPlayerInfo1 = EtsPlayerInfo#ets_player_id_name
	{
		merit_task_id = TaskId
	},
	save_ets_player(EtsPlayerInfo1).

save_ets_player_task_player_id(PlayerId, TaskId) ->
	EtsPlayerInfo = get_ets_player_id_name_by_playerid(PlayerId),
	EtsPlayerInfo1 = EtsPlayerInfo#ets_player_id_name
	{
		merit_task_id = TaskId
	},
	save_ets_player(EtsPlayerInfo1).

%% 玩家名称是否正在使用
is_no_name(Name) ->
	case get_ets_player_id_name_by_playername(Name) of
		fail ->
			true;
	%%check_username(Name);
		_ ->
			false
	end.

%% %% 检查名字是否使用
%% check_username(Name) ->
%% 	try
%% 		%% erlang原生代码
%% 		%% inets:start(),
%% 		%% ssl:start(),
%% 		%% 组合兑换码参数
%% 		TestData = lists:concat([
%% 			"name=",bitstring_to_list(Name),
%% 			"&service_id=", config:get_server_no()
%% 		]),
%% 		%%{ok, {_,_,Body}}
%% 		%% http请求 获取内容
%% 		{ok, {_, _, Body}} = httpc:request(post, {"http://123.56.196.102/chuanqi/index.php/Home/Index/add_server_user",
%% 			[], "application/x-www-form-urlencoded", TestData}, [], []),
%% 		case Body of
%% 			"0" ->
%% 				true;
%% 			_ ->
%% 				false
%% 		end
%% 	catch
%% 		Error:Info ->
%% 			?ERR("~p:~p, stacktrace:~p~n", [Error, Info, erlang:get_stacktrace()]),
%% 			false
%% 	end.

add_server_user(PlayerId, OpenId, Name, RegisterTime, Vip) ->
	gen_server2:apply_async(misc:whereis_name({local, log_mod}), {?MODULE, do_add_server_user, [OpenId, Name, PlayerId, RegisterTime, Vip]}).
%% 添加玩家登陆记录
do_add_server_user(_, OpenId, Name, PlayerId, RegisterTime, Vip) ->
	try

		%% erlang原生代码
		%% inets:start(),
		%% ssl:start(),
		%% 组合兑换码参数
		TestData = lists:concat([
			"name=", bitstring_to_list(Name),
			"&open_id=", bitstring_to_list(OpenId),
			"&player_id=", PlayerId,
			"&service_id=", config:get_server_no(),
			"&register_time=", RegisterTime,
			"&vip=", Vip
		]),
		%%{ok, {_,_,Body}}
		%% http请求 获取内容
		{ok, {_, _, Body}} = httpc:request(post, {"http://123.206.225.144/chuanqi_mg/index.php/Home/Index/add_server_user",
			[], "application/x-www-form-urlencoded", TestData}, [], []),
		case Body of
			"0" ->
				true;
			_ ->
				false
		end
	catch
		Error:Info ->
			?ERR("~p:~p, stacktrace:~p~n", [Error, Info, erlang:get_stacktrace()]),
			false
	end.


add_user_plug(PlayerId, OpenId, Name, Vip, SkillNum) ->
	gen_server2:apply_async(misc:whereis_name({local, log_mod}), {?MODULE, do_add_user_plug, [OpenId, Name, PlayerId, Vip, SkillNum]}).
%% 添加玩家登陆记录
do_add_user_plug(_, OpenId, Name, PlayerId, Vip, SkillNum) ->
	try

		%% erlang原生代码
		%% inets:start(),
		%% ssl:start(),
		%% 组合兑换码参数
		TestData = lists:concat([
			"name=", bitstring_to_list(Name),
			"&open_id=", bitstring_to_list(OpenId),
			"&player_id=", PlayerId,
			"&service_id=", config:get_server_no(),
			"&vip=", Vip,
			"&skill_num=", SkillNum
		]),
		%%{ok, {_,_,Body}}
		%% http请求 获取内容
		{ok, {_, _, Body}} = httpc:request(post, {"http://123.206.225.144/chuanqi_mg/index.php/Home/Index/add_user_plug",
			[], "application/x-www-form-urlencoded", TestData}, [], []),
		case Body of
			"0" ->
				true;
			_ ->
				false
		end
	catch
		Error:Info ->
			?ERR("~p:~p, stacktrace:~p~n", [Error, Info, erlang:get_stacktrace()]),
			false
	end.

%% 验证账号是否能登陆
checklogin(OpenId, Socket) ->
	LoginTime = util_erl:get_if(config:get_server_no() < 1000, 0,  config:get_begin_time()),
	case LoginTime < util_date:unixtime() of
		true ->	true;
		_ ->
			try
				{ok, {{IP1, IP2, IP3, IP4}, _Port}} = inet:peername(Socket),
				Ip = lists:concat([IP1, ".", IP2, ".", IP3, ".", IP4]),
				%% 组合兑换码参数
				TestData = lists:concat([
					"ip=", Ip,
					"&open_id=", bitstring_to_list(OpenId),
					"&service_id=", config:get_server_no()
				]),
				{ok, {_, _, Body}} = httpc:request(post, {"http://123.206.225.144/chuanqi_mg/index.php/Home/Index/checklogin",
					[], "application/x-www-form-urlencoded", TestData}, [], []),
				case Body of
					"true" ->
						true;
					_ ->
						?ERR("body ~p", [Body]),
						false
				end
			catch
				Error:Info ->
					?ERR("~p:~p, stacktrace:~p~n", [Error, Info, erlang:get_stacktrace()]),
					false
			end
	end.

