%%%-------------------------------------------------------------------
%%% @author tuhujia
%%% @copyright (C) 2015, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 03. 八月 2015 16:25
%%%-------------------------------------------------------------------
-module(chat_cache).

-include("common.hrl").
-include("cache.hrl").
-include("record.hrl").
-include("proto.hrl").

%% API
-export([
	get_chat_list/1,
	save_chat/2,
	delete_chat/2
]).

%% 1 世界  2 公会  3 队伍  4 私聊 5 系统
-define(WORD_CHAT_MAX_NUM, 20).
%% ====================================================================
%% API functions
%% ====================================================================

%% 获取聊天保存信息
get_chat_list(ChatSortAndToolId) ->
	case ets:lookup(?ETS_CHAT, ChatSortAndToolId) of
		[R | _] ->
			R#ets_chat.chat_list;
		_ ->
			[]
	end.

%% 更新聊天保存信息
save_chat(ChatSortAndToolId, ChatInfo) ->
	case get_chat_list(ChatSortAndToolId) of
		[] ->
			ets:insert(?ETS_CHAT, #ets_chat{chat_sort = ChatSortAndToolId, chat_list = [ChatInfo]});
		List ->
			List1 = [ChatInfo | List],
			List2 = lists:sublist(List1, ?WORD_CHAT_MAX_NUM),
			ets:update_element(?ETS_CHAT, ChatSortAndToolId, {#ets_chat.chat_list, List2})
	end.

%% 删除某人的聊天信息
delete_chat(ChatSortAndToolId, PlayerId) ->
%% 	io:format("delete chat : ~p~n", [{ChatSortAndToolId, PlayerId}]),
	case get_chat_list(ChatSortAndToolId) of
		[] -> next;
		List ->
%% 			io:format("chat info : ~p~n", [List]),
			List1 = [ChatInfo || ChatInfo <- List, ChatInfo#proto_world_chat_info.player_id=/=PlayerId],
			ets:update_element(?ETS_CHAT, ChatSortAndToolId, {#ets_chat.chat_list, List1})
	end.
