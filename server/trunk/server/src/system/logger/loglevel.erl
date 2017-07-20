%% Author: ming
%% Created: 2012-12-17
%% Description: TODO: 增加日志级别系统
-module(loglevel).

-include("common.hrl").
-include("record.hrl").

-compile(export_all).

-define(LOGMODULE, "error_logger").

-define(LOG_LEVELS, [{0, no_log, "No log"}  %% 无日志
	, {1, critical, "Critical"}             %% 危险
	, {2, error, "Error"}                   %% 错误
	, {3, warning, "Warning"}               %% 警告
	, {4, info, "Info"}                     %% 信息
	, {5, debug, "Debug"}                   %% 调试
	, {6, test, "Test"}                     %% 测试
]).

get() ->
	Level = logger:get(),
	case lists:keysearch(Level, 1, ?LOG_LEVELS) of
		{value, Result} -> Result;
		_ -> erlang:error({no_such_loglevel, Level})
	end.

set(LogLevel) when is_atom(LogLevel) ->
	set(level_to_integer(LogLevel), []);
set(LogLevel) when is_integer(LogLevel) ->
	set(LogLevel, []);

set(_) ->
	exit("Loglevel must be an integer").

add_mod(Mod, LogLevel) when is_atom(Mod) andalso is_integer(LogLevel) ->
	ModList = [{Mod, LogLevel} | logger:get_mod_list()],
	Level = logger:get(),
	set(Level, ModList).

del_mod(Mod) when is_atom(Mod) ->
	ModList = logger:get_mod_list(),
	ModList1 = lists:keydelete(Mod, 1, ModList),
	Level = logger:get(),
	set(Level, ModList1).

init() ->
	add_mod(active_merge_lib, 5),
	add_mod(active_service_merge_lib, 5),
	add_mod(active_rank_merge_lib, 5),
	add_mod(active_merge_pp, 5),
	add_mod(scene_mgr_lib, 5),
	add_mod(chat_pp, 5).

del() ->
	ModList = logger:get_mod_list(),
	[del_mod(Mod) || {Mod, _} <- ModList].

set(LogLevel, ModList) when is_atom(LogLevel) andalso is_list(ModList) ->
	set(level_to_integer(LogLevel), ModList);
set(LogLevel, ModList) when is_integer(LogLevel) andalso is_list(ModList) ->
	try
		{Mod, Code} = dynamic_compile:from_string(logger_src(LogLevel, ModList)),
		code:load_binary(Mod, ?LOGMODULE ++ ".erl", Code)
	catch
		Type:Error -> ?CRITICAL("Error compiling logger (~p): ~p~n", [Type, Error])
	end;
set(_, _) ->
	exit("Loglevel must be an integer and also module list must be list(for example: [{mod name, loglevel}, ...])").

level_to_integer(Level) ->
	case lists:keysearch(Level, 2, ?LOG_LEVELS) of
		{value, {Int, Level, _Desc}} -> Int;
		_ -> erlang:error({no_such_loglevel, Level})
	end.

logger_src(Loglevel, ModList) ->
	L = integer_to_list(Loglevel),
	ML = util_data:term_to_string(ModList),

	F = fun({Mod, Lv}, Acc) ->
		{_Test, _Debug, _Info, _Warning, _Error, _Critical} = Acc,
		M = atom_to_list(Mod),
		L1 = integer_to_list(Lv),
		_Test1 =
			"test_msg(" ++ M ++ ", Line, Format, Args) when " ++ L1 ++ " >= 6 ->
				notify(info_msg,
				\"~nT(~p:~p:~p) : \"++Format++\"~n\",
			   [self(), " ++ M ++ ", Line]++Args);
			   " ++ _Test,
		_Debug1 =
			"debug_msg(" ++ M ++ ", Line, Format, Args) when " ++ L1 ++ " >= 5 ->
				notify(info_msg,
				\"~nT(~p:~p:~p) : \"++Format++\"~n\",
			   [self(), " ++ M ++ ", Line]++Args);
			   " ++ _Debug,
		_Info1 =
			"info_msg(" ++ M ++ ", Line, Format, Args) when " ++ L1 ++ " >= 4 ->
				notify(info_msg,
				\"~nT(~p:~p:~p) : \"++Format++\"~n\",
			   [self(), " ++ M ++ ", Line]++Args);
			   " ++ _Info,
		_Warning1 =
			"warning_msg(" ++ M ++ ", Line, Format, Args) when " ++ L1 ++ " >= 3 ->
				notify(info_msg,
				\"~nT(~p:~p:~p) : \"++Format++\"~n\",
			   [self(), " ++ M ++ ", Line]++Args);
			   " ++ _Warning,
		_Error1 =
			"error_msg(" ++ M ++ ", Line, Format, Args) when " ++ L1 ++ " >= 2 ->
				notify(info_msg,
				\"~nT(~p:~p:~p) : \"++Format++\"~n\",
			   [self(), " ++ M ++ ", Line]++Args);
			   " ++ _Error,
		_Critical1 =
			"critical_msg(" ++ M ++ ", Line, Format, Args) when " ++ L1 ++ " >= 1 ->
				notify(info_msg,
				\"~nT(~p:~p:~p) : \"++Format++\"~n\",
			   [self(), " ++ M ++ ", Line]++Args);
			   " ++ _Critical,
		{_Test1, _Debug1, _Info1, _Warning1, _Error1, _Critical1}
	end,
	{Test, Debug, Info, Warning, Error, Critical} = lists:foldl(F, {"", "", "", "", "", ""}, ModList),
	"-module(logger).

	-export([test_msg/4,
			 debug_msg/4,
			 info_msg/4,
			 warning_msg/4,
			 error_msg/4,
			 critical_msg/4,
			 get/0,
			 get_mod_list/0]).

   get() -> " ++ L ++ ".

   get_mod_list() -> " ++ ML ++ ".

    %% Helper functions
    "
		++ Test ++ "
    test_msg(Module, Line, Format, Args) when " ++ L ++ " >= 6 ->
            notify(info_msg,
                   \"~nT(~p:~p:~p) : \"++Format++\"~n\",
                   [self(), Module, Line]++Args);
    test_msg(_,_,_,_) -> ok.

	" ++ Debug ++ "
    debug_msg(Module, Line, Format, Args) when " ++ L ++ " >= 5 ->
            notify(info_msg,
                   \"~nD(~p:~p:~p) : \"++Format++\"~n\",
                   [self(), Module, Line]++Args);
    debug_msg(_,_,_,_) -> ok.

	" ++ Info ++ "
    info_msg(Module, Line, Format, Args) when " ++ L ++ " >= 4 ->
            notify(info_msg,
                   \"~nI(~p:~p:~p) : \"++Format++\"~n\",
                   [self(), Module, Line]++Args);
    info_msg(_,_,_,_) -> ok.

    " ++ Warning ++ "
    warning_msg(Module, Line, Format, Args) when " ++ L ++ " >= 3 ->
            notify(warning_msg,
                   \"~nW(~p:~p:~p) : \"++Format++\"~n\",
                   [self(), Module, Line]++Args);
    warning_msg(_,_,_,_) -> ok.

	" ++ Error ++ "
    error_msg(Module, Line, Format, Args) when " ++ L ++ " >= 2 ->
		case Args of
			%% start with : ** Node php
			[42,42,32,78,111,100,101,32,112,104,112|_] ->
				ok;
			_ ->
            	notify(error,
                   \"~nE(~p:~p:~p) : \"++Format++\"~n\",
                   [self(), Module, Line]++Args)
		end;
    error_msg(_,_,_,_) -> ok.

	" ++ Critical ++ "
    critical_msg(Module, Line, Format, Args) when " ++ L ++ " >= 1 ->
            notify(error,
                   \"~nC(~p:~p:~p) : \"++Format++\"~n\",
                   [self(), Module, Line]++Args);
    critical_msg(_,_,_,_) -> ok.

    %% Distribute the message to the Erlang error logger
    notify(Type, Format, Args) ->
            LoggerMsg = {Type, group_leader(), {self(), Format, Args}},
            gen_event:notify(error_logger, LoggerMsg).
    ".
