%%%-------------------------------------------------------------------
%%% @author zhengsiying
%%% @copyright (C) 2015, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 30. 十二月 2015 下午3:34
%%%-------------------------------------------------------------------
-module(sensitive_word_lib).

-include("common.hrl").
-include("record.hrl").

%% API
-export([
	init/0,
	check/1
]).

%% ====================================================================
%% API functions
%% ====================================================================
init() ->
	List = sensitive_word_config:get_list(),
	F = fun(Word) ->
			[H | T] = Word,
			case T /= [] of
				true ->
					ets:insert(?ETS_SENSITIVE_WORD_FIRST, {H}),
					[ets:insert(?ETS_SENSITIVE_WORD_ALL, {X}) || X <- Word],
					Hash = erlang:md5(xmerl_ucs:to_utf8(Word)),
					ets:insert(?ETS_SENSITIVE_WORD_HASH, {Hash});
				_ ->
					ets:insert(?ETS_SENSITIVE_WORD_SINGLE, {H})
			end
		end,
	lists:foreach(F, List).


%% 判断是否有敏感词
%% 注意: 如果有敏感词返回true, 没有返回false !!!!!!!
check(Bin) when is_binary(Bin) ->
	List = xmerl_ucs:from_utf8(Bin),
	ttmp_check(List);
check(List) when is_list(List) ->
	ttmp_check(List).

%% 使用TTMP算法
%% 1、首先扫描文章里面的每一个字符，只有当某一个字符是脏字表中任意一个脏词的第一个字符（称为“起始符”），我们才试图看看接下来是否是脏字（触发检索）。
%% 2、但是我们也不是毫无头绪的就开始循环脏字表的每一个词条：
%% 2.1、我们往后检索一个字符，先看一下这个字符是否是脏字表里面的任意一个字符，如果不是，就表明不可能是脏字表中的任何一个条目，就可以退出了。
%% 2.2、如果是，我们就取从第一个被检出字符到目前扫描到的字符之间的字符串，求哈希值，看看能否从哈希表中检出一个脏词。
%% 如果检出了，那就大功告成，否则继续检索后面一个字符（重复2.1、2.2），直至找不到，或者超出脏字表条目最大的长度。
%% 2.3、如果都找不到，或者超长，那么接下来就回到刚才的那个“起始符”后一个字符继续扫描（重复1、2），直至整个文章结束
ttmp_check([]) ->
	false;
ttmp_check([H]) ->
	case ets:lookup(?ETS_SENSITIVE_WORD_SINGLE, H) of
		[_] ->
			true;
		_ ->
			case ets:lookup(?ETS_SENSITIVE_WORD_FIRST, H) of
				[_] ->
					Hash = erlang:md5(xmerl_ucs:to_utf8([H])),
					case ets:lookup(?ETS_SENSITIVE_WORD_HASH, Hash) of
						[_] ->
							true;
						_ ->
							false
					end;
				_ ->
					false
			end
	end;
ttmp_check(List) ->
	[H | T] = List,
	case ets:lookup(?ETS_SENSITIVE_WORD_SINGLE, H) of
		[_] ->
			true;
		_ ->
			case ets:lookup(?ETS_SENSITIVE_WORD_FIRST, H) of
				[_] ->
					case ttmp_check1([H], T) of
						true ->
							true;
						_ ->
							ttmp_check(T)
					end;
				_ ->
					ttmp_check(T)
			end
	end.

ttmp_check1(_List, []) ->
	false;
ttmp_check1(List, [H | T]) ->
	case ets:lookup(?ETS_SENSITIVE_WORD_ALL, H) of
		[_] ->
			%% 这里为了减少列表相加的性能消耗，记录反序的字符串，需要使用的时候再反转
			List1 = [H | List],
			List2 = lists:reverse(List1),
			Hash = erlang:md5(xmerl_ucs:to_utf8(List2)),
			case ets:lookup(?ETS_SENSITIVE_WORD_HASH, Hash) of
				[_] ->
					true;
				_ ->
					ttmp_check1(List1, T)
			end;
		_ ->
			false
	end.

%% ====================================================================
%% Internal functions
%% ====================================================================
