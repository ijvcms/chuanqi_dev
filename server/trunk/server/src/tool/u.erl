%%----------------------------------------------------
%% Erlang模块热更新到所有线路（包括server的回调函数，如果对state有影响时慎用）
%%
%% 检查：
%%      u:c()                %% 列出前5分钟内编译过的文件
%%      u:c(N)               %% 列出前N分钟内编译过的文件
%%
%% 更新：
%%      u:u()                %% 更新前5分钟内编译过的文件
%%      u:u(N)               %% 更新前N分钟内编译过的文件
%%      u:u([mod_xx, ...])   %% 指定模块（不带后缀名）
%%      u:u(m)               %% 编译并加载文件
%%
%% Tips: u - update, c - check
%% 
%% @author rolong@vip.qq.com
%%----------------------------------------------------

-module(u).
-compile(export_all).
-include_lib("kernel/include/file.hrl").
-include("common.hrl").
-include("record.hrl").

c() ->
	c(5).
c(S) when is_integer(S) ->
	case file:list_dir(".") of
		{ok, FileList} ->
			Files = get_new_file(FileList, S * 60),
			info("---------check modules---------~n~w~n=========check modules=========", [Files]);
		Any -> info("Error Dir: ~w", [Any])
	end;
c(_) -> info("ERROR======> Badarg", []).

admin() ->
	spawn(fun() -> u(m) end),
	ok.

u() ->
	u(5).
u(m) ->
	StartTime = util_date:unixtime(),
	info("----------makes----------", []),
	make_sure_working_dir(),
	c:cd("../"),
	make:all(),
	EndTime = util_date:unixtime(),
	Time = EndTime - StartTime,
	info("Make Time : ~w s", [Time]),
	u(Time / 60);
u(S) when is_number(S) ->
	make_sure_working_dir(),
	c:cd("../ebin"),
	case file:list_dir(".") of
		{ok, FileList} ->
			Files = get_new_file(FileList, util_math:ceil(S * 60) + 3),
			u(Files);
		Any -> info("Error Dir: ~w", [Any])
	end;
u(Files) when is_list(Files) ->
	AllNode = [node()],
	info("---------modules---------~n~w~n----------nodes----------", [Files]),
	load(Files),
	loads(AllNode, Files);
u(_) -> info("ERROR======> Badarg", []).

%% m(['src/data/*','src/lib/lib_goods.erl'])
m(Files) when is_list(Files) ->
	StartTime = util_date:unixtime(),
	info("----------makes----------~n~w~n", [Files]),
	c:cd("../"),
	Res = make:files(Files, [debug_info, {i, "include"}, {outdir, "ebin"}]),
	c:cd("ebin"),
	EndTime = util_date:unixtime(),
	Time = EndTime - StartTime,
	info("Make Time : ~w s", [Time]),
	Res.

info(V) ->
	info(V, []).
info(V, P) ->
	io:format(V ++ "~n", P).

%% 更新到所有线路
loads([], _Files) -> ok;
loads([H | T], Files) ->
	info("[~w]", [H]),
	rpc:cast(H, u, load, [Files]),
	loads(T, Files).

get_new_file(Files, S) ->
	get_new_file(Files, S, []).
get_new_file([], _S, Result) -> Result;
get_new_file([H | T], S, Result) ->
	NewResult = case string:tokens(H, ".") of
					[Left, Right] when Right =:= "beam" ->
						case file:read_file_info(H) of
							{ok, FileInfo} ->
								Now = calendar:local_time(),
								case calendar:time_difference(FileInfo#file_info.mtime, Now) of
									{Days, Times} ->
										Seconds = calendar:time_to_seconds(Times),
										case Days =:= 0 andalso Seconds < S of
											true ->
												FileName = list_to_atom(Left),
												[FileName | Result];
											false -> Result
										end;
									_ -> Result
								end;
							_ -> Result
						end;
					_ -> Result
				end,
	get_new_file(T, S, NewResult).

load([]) -> ok;
load([FileName | T]) ->
	c:l(FileName),
	info("loaded: ~w", [FileName]),
	load(T).
%    case code:soft_purge(FileName) of
%        true ->
%            case code:load_file(FileName) of
%                {module, _} ->
%                    info("loaded: ~w", [FileName]),
%                    ok;
%                    %% info("loaded: ~w", [FileName]);
%                {error, What} -> info("ERROR======> loading: ~w (~w)", [FileName, What])
%            end;
%        false -> info("ERROR======> Processes lingering : ~w [zone ~w] ", [FileName, srv_kernel:zone_id()])
%    end,
%    load(T).


%% @spec hotswap() -> ok
%% @doc 用于远程热更新
hotswap(NodeArg) ->
	Node = util_data:to_atom(hd(NodeArg)),
	net_adm:ping(Node),
	rpc:call(Node, ?MODULE, do_hotswap, []).

do_hotswap() ->
	CommandFile = "../../hotswap/hotswap_command.txt",
	case filelib:is_file(CommandFile) andalso filelib:file_size(CommandFile) > 2 of
		true ->
			{{Y, M, D}, {H, I, S}} = erlang:localtime(),
			TimeString = io_lib:format("[~w-~w-~w ~w:~w:~w]", [Y, M, D, H, I, S]),
			try
				info("===> command running ..."),
				case file:open(CommandFile, read) of
					{ok, IoDevice} ->
						case file:eval(CommandFile) of
							ok -> info("Update Time: ~s", [TimeString]);
							{error, EvalErr} -> info("~s Eval Error:~w", [TimeString, EvalErr])
						end,
						info("command:"),
						ResultData = parse(IoDevice, <<>>),
						case byte_size(ResultData) < 5 of
							true -> info("Empty Command (<5byte): ~s", [TimeString]);
							false -> info("=> ~s", [ResultData])
						end,
						file:close(IoDevice),
						file:delete(CommandFile);
					{error, OpenErr} ->
						info("~s Open Error:~w\n", [TimeString, OpenErr])
				end
			catch T : X ->
				info("~s Error: ~w : ~w\nUpdate Server Is Stopped!\n", [TimeString, T, X])
			end;
		false -> ignore
	end,
	ok.

parse(IoDevice, D) ->
	case io:get_line(IoDevice, '') of
		eof ->
			%% info("\n--- DONE ---"),
			D;
		Data ->
			%% io:format("=> ~s", [Data]),
			parse(IoDevice, list_to_binary([D, Data]))
	end.

%% @doc 保证正确的工作路径
%% @spec make_sure_working_dir() -> any().
make_sure_working_dir() ->
	Cwd = config:get_cwd(),
	case file:get_cwd() == Cwd of
		true ->
			skip;
		_ ->
			c:cd(Cwd)
	end.
