%%%-------------------------------------------------------------------
%%% @author zhengsiying
%%% @copyright (C) 2015, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 21. 四月 2014 下午6:17
%%%-------------------------------------------------------------------

-module(server_tool).

-include("common.hrl").
-include("record.hrl").

%% ====================================================================
%% API functions
%% ====================================================================
-export([]).
-compile(export_all).

%% 打印并排序各个表的缓存消耗
show_cache() ->
	io:format("table name | memory | size", []),
	lists:reverse(lists:keysort(2, [{T, ets:info(T, memory), ets:info(T, size)} || T <- ets:all()])).

%% 打印进程消耗内存的信息
show_process() ->
	lists:reverse(lists:keysort(2, [{erlang:process_info(P, registered_name), erlang:process_info(P, heap_size)} || P <- erlang:processes()])).

%% 打印当前进程数量
show_process_count() ->
	length(erlang:processes()).

%% 获取当前在线玩家数量
get_online_num() ->
	OnlineList = ets:tab2list(?ETS_ONLINE),
	F = fun(EtsOnline, Sum) ->
		case is_process_alive(EtsOnline#ets_online.pid) andalso EtsOnline#ets_online.is_robot /= 1 of
			true ->
				Sum + 1;
			_ ->
				Sum
		end
	end,
	lists:foldl(F, 0, OnlineList).

%% 获取当前在线玩家数量
get_online_player() ->
	ets:tab2list(?ETS_ONLINE).

%% 获取对应场景玩家总数
get_scene_player_num() ->
	List = ets:tab2list(?ETS_PLAYER_SCENE),
	F = fun(Info, Acc) ->
		case ets:lookup(?ETS_ONLINE, Info#ets_player_scene.player_id) of
			[#ets_online{}] ->
				SceneId = Info#ets_player_scene.scene_id,
				case lists:keyfind(SceneId, 1, Acc) of
					{_, Num} ->
						lists:keyreplace(SceneId, 1, Acc, {SceneId, Num + 1});
					_ ->
						lists:keystore(SceneId, 1, Acc, {SceneId, 1})
				end;
			_ ->
				Acc
		end
	end,
	lists:foldl(F, [], List).

%% 反编译
abstract(Mod) ->
	{ok, {_, [{abstract_code, {_, Ac}}]}} = beam_lib:chunks(code:which(Mod), [abstract_code]),
	io:fwrite("~ts~n", [erl_prettypr:format(erl_syntax:form_list(Ac))]).

%% ====================================================================
%% Internal functions
%% ====================================================================


