%% Author: ming
%% Created: 2012-12-2
%% Description: TODO: public interface
-module(misc).

%%
%% Include files
%%
-include("common.hrl").
-include("record.hrl").

%%
%% Exported Functions
%%
-export([
	whereis_name/1,
	get_player_pid/1,
	register/3,
	create_process_name/2,
	is_process_alive/1,
	player_process_name/1,
	fix_record/2,
	get_node_type/0
]).

%%
%% API Functions
%%

%% find process
whereis_name({local, Atom}) ->
	erlang:whereis(Atom);

whereis_name({global, Atom}) ->
	global:whereis_name(Atom).

get_player_pid(Atom) ->
	whereis_name({global, player_process_name(Atom)}).

%% 注册进程名 
register(local, Name, Pid) ->
	erlang:register(Name, Pid);

register(global, Name, Pid) ->
	global:re_register_name(Name, Pid).

%% 创建进程名
create_process_name(Prefix, List) ->
	util_data:to_atom(lists:concat(lists:flatten([Prefix] ++ lists:map(fun(T) -> ['_', T] end, List)))).

%%进程是否存活 
is_process_alive(Pid) ->
	try
		if is_pid(Pid) ->
			case erlang:is_process_alive(Pid) of
				{badrpc, _Reason} -> false;
				Res -> Res
			end;
			true -> false
		end
	catch
		_:_ -> false
	end.

player_process_name(PlayerId) when is_integer(PlayerId) or is_atom(PlayerId) ->
	lists:concat([p_p_, PlayerId]);
player_process_name(PlayerId) when is_list(PlayerId) ->
	lists:flatten(["p_p_" | PlayerId]);
player_process_name(PlayerId) when is_binary(PlayerId) ->
	lists:concat([p_p_, tool:md5(PlayerId)]).

fix_record(TargetRecord, BadRecord) ->
	TargetRecordList = util_data:to_list(TargetRecord),
	BadRecordList = util_data:to_list(BadRecord),
	LenT = length(TargetRecordList),
	LenB = length(BadRecordList),
	case LenT == LenB of
		true ->
			BadRecord;
		_ ->
			ResetList = lists:sublist(TargetRecordList, LenB + 1, LenT),
			Re = lists:concat([BadRecordList, ResetList]),
			list_to_tuple(Re)
	end.

get_node_type() ->
	[NodeType | _T] = init:get_plain_arguments(),
	util_data:to_atom(NodeType).

%%
%% Local Functions
%%

