%%%-------------------------------------------------------------------
%%% @author zhengsiying
%%% @copyright (C) 2016, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 13. 一月 2016 下午2:15
%%%-------------------------------------------------------------------
-module(back_pp).

-include("common.hrl").
-include("record.hrl").
-include("proto_back.hrl").
-include("notice_config.hrl").
-include("cache.hrl").
-include("db_record.hrl").
-include("config.hrl").
-include("proto.hrl").
%% API
-export([
	handle/3
]).

%% ====================================================================
%% API functions  pt_ex 也要添加编码信息
%% ====================================================================
%% 发送公告
handle(Socket, 1005, Data) ->
	try
		?INFO("1005 ~p", [Data]),
		Info1 = Data#back_req_notice.notice,
		notice_lib:send_notice(0, ?NOTICE_BACK, [Info1]),
		net_send:send_to_back(Socket, 1005, #back_rep_notice{result = 0})
	catch
		Error:Info ->
			?ERR("~p:~p data:~p ~p", [Error, Info, Data, erlang:get_stacktrace()]),
			net_send:send_to_back(Socket, 1005, #back_rep_notice{result = -9})
	end;
%% 发送邮件
handle(Socket, 1006, Data) ->
	try
		?INFO("1006 ~p", [Data]),
		TargetType = Data#back_req_send_mail.targetype,
		?INFO("1006 TargetType ~p", [TargetType]),
		TargetArr = Data#back_req_send_mail.targetarr,
		GoodsList = util_data:string_to_term(Data#back_req_send_mail.goodslist),
		Title = Data#back_req_send_mail.title,
		Content = Data#back_req_send_mail.content,
		case TargetType of
			1 ->
				?INFO("1006 11  ~p", [TargetArr]),
				back_lib:send_mail_player_name(Title, Content, TargetArr, GoodsList);
			2 ->
				?INFO("1006 22 ~p", [TargetArr]),
				%%通过玩家id发邮件,且物品里有"首充大礼包",
				case lists:keyfind(110123, 1, GoodsList) of
					false ->
						skip;
					_ ->
						%%只针对第一个玩家处理,不允许多的处理
						[PlayerIdStr | _] = TargetArr,
						PlayerId = util_data:to_integer(PlayerIdStr),
						case counter_lib:get_value(PlayerId, ?COUNTER_FIRST_CHARGE) =:= 0 of
							true ->
								%%屏蔽指定的首充双倍
								ChargeList = [5, 6, 7],
								lists:foreach(fun(Key) ->
									#charge_conf{counter_id = CounterId} = charge_config:get(Key),
									counter_lib:update(PlayerId, CounterId),
									ok
								end, ChargeList),
								%%屏蔽客户端首充礼包按钮
								counter_lib:update(PlayerId, ?COUNTER_FIRST_CHARGE),
								counter_lib:update(PlayerId, ?COUNTER_FIRST_CHARGE_BAG);
							false ->
								skip
						end
				end,
				back_lib:send_mail_player_id(Title, Content, TargetArr, GoodsList);
			3 ->
				mail_lib:add_full_service_mail(Content, GoodsList);
			_ ->
				skip
		end,
		net_send:send_to_back(Socket, 1006, #back_rep_send_mail{result = 0})
	catch
		Error:Info ->
			?ERR("~p:~p data:~p ~p", [Error, Info, Data, erlang:get_stacktrace()]),
			net_send:send_to_back(Socket, 1006, #back_rep_send_mail{result = -9})
	end;

%% 禁言
handle(Socket, 1007, Data) ->
	try
		?INFO("1007 ~p", [Data]),
		PlayerId = Data#back_req_limit_chat.player_id,
		LimitChat = Data#back_req_limit_chat.limit_chat,
		Pid = player_lib:get_player_pid(PlayerId),
		case is_pid(Pid) of
			true ->
				Update = #player_state{
					db_player_base = #db_player_base{
						limit_chat = LimitChat
					}
				},
				player_lib:update_player_state_back(Pid, Update),
				?INFO("1007 11 ~p ~p", [PlayerId, LimitChat]);
			_ ->
				Base = player_base_cache:select_row(PlayerId),
				Base1 = Base#db_player_base{
					limit_chat = LimitChat
				},
				player_base_cache:update(PlayerId, Base1),
				?INFO("1007 22 ~p ~p", [PlayerId, LimitChat])
		end,
		chat_cache:delete_chat({?CHAT_SORT_WORD, 0}, PlayerId),
		net_send:send_to_back(Socket, 1007, #back_rep_limit_chat{result = 0})
	catch
		Error:Info ->
			?ERR("~p:~p data:~p ~p", [Error, Info, Data, erlang:get_stacktrace()]),
			net_send:send_to_back(Socket, 1007, #back_rep_limit_chat{result = -9})
	end;

%% 封号
handle(Socket, 1008, Data) ->
	try
		?INFO("1008 ~p", [Data]),
		PlayerId = Data#back_req_limit_login.player_id,
		LimitLogin = Data#back_req_limit_login.limit_login,
		Pid = player_lib:get_player_pid(PlayerId),
		case is_pid(Pid) of
			true ->
				Update = #player_state{
					db_player_base = #db_player_base{
						limit_login = LimitLogin
					}
				},
				player_lib:update_player_state_back(Pid, Update);
			_ ->
				Base = player_base_cache:select_row(PlayerId),
				Base1 = Base#db_player_base{
					limit_login = LimitLogin
				},
				player_base_cache:update(PlayerId, Base1)
		end,
		chat_cache:delete_chat({?CHAT_SORT_WORD, 0}, PlayerId),
		net_send:send_to_back(Socket, 1008, #back_rep_limit_login{result = 0})
	catch
		Error:Info ->
			?ERR("~p:~p data:~p ~p", [Error, Info, Data, erlang:get_stacktrace()]),
			net_send:send_to_back(Socket, 1008, #back_rep_limit_login{result = -9})
	end;

%% 充值
handle(Socket, 1009, Data) ->
	try
		?ERR("1009 22 ~p", [Data]),
		#back_req_charge{id = PlayerChargeId, player_id = PlayerId} = Data,

		Pid = player_lib:get_player_pid(PlayerId),
		Result1 = case is_pid(Pid) of
					  true ->
						  case charge_lib:buy_charge_pay(Pid, PlayerChargeId) of
							  {ok, Result} ->
								  Result;
							  {fail, Result} ->
								  Result;
							  _ ->
								  -9
						  end;
					  _ ->
						  case charge_lib:buy_charge_pay(PlayerId, PlayerChargeId) of
							  {ok, Result} ->
								  Result;
							  {fail, Result} ->
								  Result;
							  _ ->
								  -9
						  end
				  end,
		net_send:send_to_back(Socket, 1009, #back_rep_charge{result = Result1})
	catch
		Error:Info ->
			?ERR("~p:~p data:~p ~p", [Error, Info, Data, erlang:get_stacktrace()]),
			net_send:send_to_back(Socket, 1009, #back_rep_charge{result = -9})
	end;

%% 发送红包
handle(Socket, 1010, Data) ->
	try
		?INFO("1009 22 ~p", [Data]),
		#back_req_send_red{rmb = _Rmb, name = Name} = Data,
		Result1 = case player_id_name_lib:get_ets_player_id_name_by_playername(Name) of
					  fail ->
						  -9;
					  Ets_Player_Name ->
						  red_lib:send_red_charge(Ets_Player_Name#ets_player_id_name.player_id, 20, true),
						  0
				  end,
		net_send:send_to_back(Socket, 1010, #back_rep_charge{result = Result1})
	catch
		Error:Info ->
			?ERR("~p:~p data:~p ~p", [Error, Info, Data, erlang:get_stacktrace()]),
			net_send:send_to_back(Socket, 1010, #back_rep_charge{result = -9})
	end;

%% 获取在线人数
handle(Socket, 1011, Data) ->
	try
		?INFO("1010 ~p", [Data]),
		OnlineNum = server_tool:get_online_num(),
		net_send:send_to_back(Socket, 1011, #back_rep_online_num{status = 0, data = OnlineNum})
	catch
		Error:Info ->
			?ERR("~p:~p data:~p ~p", [Error, Info, Data, erlang:get_stacktrace()]),
			net_send:send_to_back(Socket, 1011, #back_rep_online_num{status = -9})
	end;

%% 功能开启时间修改
handle(Socket, 1012, Data) ->
	try
		?INFO("1012 ~p", [Data]),
		FunctionId = Data#back_req_update_function.function_id,
		BeginTime = Data#back_req_update_function.begin_time,
		EndTime = Data#back_req_update_function.end_time,
		Group = Data#back_req_update_function.group,
		FunctionConf = function_config:get(FunctionId),

		case function_db:select_row(FunctionId) of
			null ->
				FunCtionInfo = #db_function{
					id = FunctionId,
					begin_time = BeginTime,
					end_time = EndTime,
					group_num = Group
				},
				function_db:insert(FunCtionInfo);
			FunCtionInfo ->
				FunCtionInfo1 = FunCtionInfo#db_function{
					begin_time = BeginTime,
					end_time = EndTime,
					group_num = Group
				},
				function_db:update(FunctionId, FunCtionInfo1)
		end,

		PlayerList = player_lib:get_online_players(),
		case function_lib:check_is_open_time(FunctionConf) of %%
			{true, _} ->
				Fun = fun(EtsOnline) ->
					gen_server2:cast(EtsOnline#ets_online.pid, {update_function_button, [{?FUNCTION_STATE_OPEN, FunctionId}]})
				end,
				[Fun(X) || X <- PlayerList];
			_ ->
				Fun1 = fun(EtsOnline1) ->
					gen_server2:cast(EtsOnline1#ets_online.pid, {update_function_button, [{?FUNCTION_STATE_CLOSE, FunctionId}]})
				end,
				[Fun1(X) || X <- PlayerList]
		end,
		net_send:send_to_back(Socket, 1012, #back_rep_update_function{result = 0})
	catch
		Error:Info ->
			?ERR("~p:~p data:~p ~p", [Error, Info, Data, erlang:get_stacktrace()]),
			net_send:send_to_back(Socket, 1012, #back_rep_update_function{result = -9})
	end;

%% 机器人修改 服务器相关配置更新
handle(Socket, 1013, Data) ->
	try
		config:get_tcp_listener_html(),
		net_send:send_to_back(Socket, 1013, #back_rep_ref_server_info{result = 0})
	catch
		Error:Info ->
			?ERR("~p:~p data:~p ~p", [Error, Info, Data, erlang:get_stacktrace()]),
			net_send:send_to_back(Socket, 1013, #back_rep_update_function{result = -9})
	end;

%% 运营活动新增
handle(Socket, 1014, Data) ->
	try
		operate_active_lib:update_operate_active_conf(Data),
		net_send:send_to_back(Socket, 1014, #back_rep_ref_operate_active_conf{result = 0})
	catch
		Error:Info ->
			?ERR("~p:~p data:~p ~p", [Error, Info, Data, erlang:get_stacktrace()]),
			net_send:send_to_back(Socket, 1014, #back_rep_ref_operate_active_conf{result = -9})
	end;

handle(Socket, 1015, Data) ->
	try
		operate_active_lib:update_operate_sub_type_conf(Data),
		net_send:send_to_back(Socket, 1014, #back_rep_ref_operate_sub_type_conf{result = 0})
	catch
		Error:Info ->
			?ERR("~p:~p data:~p ~p", [Error, Info, Data, erlang:get_stacktrace()]),
			net_send:send_to_back(Socket, 1014, #back_rep_ref_operate_sub_type_conf{result = -9})
	end;

%% 管理端配置
handle(Socket, 1016, Data) ->
	try
		?INFO("1016 ~p", [Data]),
		config:reload_manager_config_html(),
		net_send:send_to_back(Socket, 1016, #back_rep_manager_config{code = 0})
	catch
		Error:Info ->
			?ERR("~p:~p data:~p ~p", [Error, Info, Data, erlang:get_stacktrace()]),
			net_send:send_to_back(Socket, 1016, #back_rep_manager_config{code = -9})
	end;

%% 批量查询是否在线
handle(Socket, 1017, Data) ->
	try
		?INFO("1017 ~p", [Data]),
		#back_req_online_status{player_id_list = PlayerIdList} = Data,
		List =
			lists:foldl(fun(PlayerId, Acc) ->
				case ets:lookup(?ETS_ONLINE, PlayerId) of
					[] -> [0 | Acc];
					_ -> [1 | Acc]
				end
			end, [], PlayerIdList),
		OnlineStatus = lists:reverse(List),
		net_send:send_to_back(Socket, 1017, #back_rep_online_status{code = 0, status_list = OnlineStatus})
	catch
		Error:Info ->
			?ERR("~p:~p data:~p ~p", [Error, Info, Data, erlang:get_stacktrace()]),
			net_send:send_to_back(Socket, 1017, #back_rep_online_status{code = 1})
	end;

handle(Socket, Cmd, Data) ->
	?INFO("~p, ~p, ~p", [Socket, Cmd, Data]).

%% ====================================================================
%% Internal functions
%% ====================================================================
