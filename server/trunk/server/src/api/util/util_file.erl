%%%-------------------------------------------------------------------
%%% @author zhengsiying
%%% @copyright (C) 2015, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 25. 三月 2015 20:37
%%%-------------------------------------------------------------------
-module(util_file).

-include("util_json.hrl").

%% API
-export([
    list_dir_recursive/1
]).

%% ====================================================================
%% API functions
%% ====================================================================
-spec(list_dir_recursive(Dir :: string()) -> [string()]).
list_dir_recursive(Dir) when is_list(Dir) ->
    case file:list_dir(Dir) of
        {ok, NewFiles} ->
            SortNewFiles = lists:sort(NewFiles),
            FullNewFiles = [filename:join(Dir, N) || N <- SortNewFiles],
            list_file_r(FullNewFiles, []);
        {error, _Reason} ->
            []
    end.
%% 不包含文件夹
list_file_r([] = _Files, Acc) ->
    Acc;
list_file_r([File | Tail] = _Files, Acc) ->
    case filelib:is_dir(File) of
        true ->
            list_file_r(Tail, Acc);
        false ->
            list_file_r(Tail, Acc ++ [File])
    end.

%% list_dirs_r([] = _Files, Acc) ->
%% 	Acc;
%% list_dirs_r([File | Tail] = _Files, Acc) ->
%% 	case filelib:is_dir(File) of
%% 		true ->
%% 			case file:list_dir(File) of
%% 				{ok, NewFiles} ->
%% 					FullNewFiles = [filename:join(File, N) || N <- NewFiles],
%% 					list_dirs_r(FullNewFiles ++ Tail, Acc);
%% 				{error, Reason} ->
%% 					lager:error("List dir(~p): ~p", [File, Reason]),
%% 					list_dirs_r(Tail, Acc)  % Ignore dir if error
%% 			end;
%% 		false ->
%% 			list_dirs_r(Tail, [File | Acc])
%% 	end.
%% ====================================================================
%% Internal functions
%% ====================================================================
