%%%-------------------------------------------------------------------
%%% @author zhengsiying
%%% @copyright (C) 2015, <COMPANY>
%%% @doc
%%%		协议编解码扩展
%%% @end
%%% Created : 25. 三月 2015 20:31
%%%-------------------------------------------------------------------
-module(pt_ex).

-include("common.hrl").
-include("util_json.hrl").
-include("proto_back.hrl").

%% API
-export([
	read_cmd/1,
	write_cmd/2
]).

%% ====================================================================
%% API functions
%% ====================================================================
read_cmd(Bin) ->
	try
		#back_req{cmd = Cmd, data = Data} = ?JSON_TO_RECORD(back_req, Bin),
		{Cmd, read_cmd(Cmd, Data)}
	catch
		Error:Info ->
			?ERR("~p back_pp", [Bin]),
			?ERR("~p:~p, stacktrace:~p~n", [Error, Info, erlang:get_stacktrace()])
	end.

read_cmd(1000, Bin) ->
	?RFC4627_TO_RECORD(back_req_recharge, Bin);
read_cmd(1005, Bin) ->
	?RFC4627_TO_RECORD(back_req_notice, Bin);
read_cmd(1006, Bin) ->
	?RFC4627_TO_RECORD(back_req_send_mail, Bin);
read_cmd(1007, Bin) ->
	?RFC4627_TO_RECORD(back_req_limit_chat, Bin);
read_cmd(1008, Bin) ->
	?RFC4627_TO_RECORD(back_req_limit_login, Bin);
read_cmd(1009, Bin) ->
	?RFC4627_TO_RECORD(back_req_charge, Bin);
read_cmd(1010, Bin) ->
	?RFC4627_TO_RECORD(back_req_send_red, Bin);
read_cmd(1011, _Bin) ->
	#back_req_online_num{};
read_cmd(1012, Bin) ->
	?RFC4627_TO_RECORD(back_req_update_function, Bin);
read_cmd(1013, _Bin) ->
	#back_req_ref_server_info{};
read_cmd(1014, Bin) ->
	?RFC4627_TO_RECORD(back_req_ref_operate_active_conf, Bin);
read_cmd(1015, Bin) ->
	?RFC4627_TO_RECORD(back_req_ref_operate_sub_type_conf, Bin);
read_cmd(1016, _Bin) ->
	#back_req_manager_config{};
read_cmd(1017, Bin) ->
	?RFC4627_TO_RECORD(back_req_online_status, Bin);
read_cmd(Cmd, Bin) ->
	?ERR("not cmd: ~p, ~p", [Cmd, Bin]).

%% ---------------------------------------------------------------
%% write_cmd
%% ---------------------------------------------------------------
write_cmd(1000, Data) ->
	DataBin = ?RFC4627_FROM_RECORD(back_rep_recharge, Data),
	pack(1000, DataBin);
write_cmd(1005, Data) ->
	DataBin = ?RFC4627_FROM_RECORD(back_rep_notice, Data),
	pack(1005, DataBin);
write_cmd(1006, Data) ->
	DataBin = ?RFC4627_FROM_RECORD(back_rep_send_mail, Data),
	pack(1006, DataBin);
write_cmd(1007, Data) ->
	DataBin = ?RFC4627_FROM_RECORD(back_rep_limit_chat, Data),
	pack(1007, DataBin);
write_cmd(1008, Data) ->
	DataBin = ?RFC4627_FROM_RECORD(back_rep_limit_login, Data),
	pack(1008, DataBin);
write_cmd(1009, Data) ->
	DataBin = ?RFC4627_FROM_RECORD(back_rep_charge, Data),
	pack(1009, DataBin);
write_cmd(1010, Data) ->
	DataBin = ?RFC4627_FROM_RECORD(back_rep_send_red, Data),
	pack(1010, DataBin);
write_cmd(1011, Data) ->
	DataBin = ?RFC4627_FROM_RECORD(back_rep_online_num, Data),
	pack(1011, DataBin);
write_cmd(1012, Data) ->
	DataBin = ?RFC4627_FROM_RECORD(back_rep_update_function, Data),
	pack(1012, DataBin);
write_cmd(1013, Data) ->
	DataBin = ?RFC4627_FROM_RECORD(back_rep_ref_server_info, Data),
	pack(1013, DataBin);
write_cmd(1014, Data) ->
	DataBin = ?RFC4627_FROM_RECORD(back_rep_ref_operate_active_conf, Data),
	pack(1014, DataBin);
write_cmd(1015, Data) ->
	DataBin = ?RFC4627_FROM_RECORD(back_rep_ref_operate_sub_type_conf, Data),
	pack(1015, DataBin);
write_cmd(1016, Data) ->
	DataBin = ?RFC4627_FROM_RECORD(back_rep_manager_config, Data),
	pack(1016, DataBin);
write_cmd(1017, Data) ->
	DataBin = ?RFC4627_FROM_RECORD(back_rep_online_status, Data),
	pack(1017, DataBin);
%% write_cmd(1014, Data) ->
%% 	DataBin = ?RFC4627_FROM_RECORD(back_rep_ref_operate_active, Data),
%% 	pack(1014, DataBin);
write_cmd(Cmd, Data) ->
	?ERR("not cmd: ~p, ~p", [Cmd, Data]).

%% ---------------------------------------------------------------
%% write_cmd
%% ---------------------------------------------------------------
pack(Cmd, DataBin) ->
	JsonList = ?JSON_FROM_RECORD(back_rep, #back_rep{cmd = Cmd, data = DataBin}),
	util_data:to_binary(JsonList).

%% ====================================================================
%% Internal functions
%% ====================================================================
