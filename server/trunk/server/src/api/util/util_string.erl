%%%-------------------------------------------------------------------
%%% @author zhengsiying
%%% @copyright (C) 2015, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 30. 六月 2015 下午5:37
%%%-------------------------------------------------------------------
-module(util_string).

%% API
-export([
	check_name/1,
	check_emoji/2
]).

%% ====================================================================
%% API functions
%% ====================================================================
%% 验证名字是否合法
check_name(Name) ->
	re:run(Name, "^[~()?!@#$%^&*-_=+<>0-9a-zA-Z\x{4e00}-\x{9fff}]+$", [unicode]) == nomatch.



check_emoji([], List) ->
	List;
check_emoji([T | H], List) ->
	List1 = case T == "0x0" orelse (T == "0x9")
		orelse (T == "0xA") orelse (T == "0xD") orelse
		((T >= "0x20") andalso (T =< "0xD7FF")) orelse ((T >= "0xE000")
		andalso (T =< "0xFFFD")) orelse ((T >= "0x10000") andalso (T =< "0x10FFFF")) of
				true ->
					List;
				_ ->
					List ++ [T]
			end,
	check_emoji(H, List1).
%% ====================================================================
%% Internal functions
%% ====================================================================
