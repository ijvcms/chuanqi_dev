%%%-------------------------------------------------------------------
%%% @author qhb
%%% @copyright (C) 2016, <COMPANY>
%%% @doc
%%%	数据独立线程处理模块
%%% @end
%%% Created : 31. 五月 2016 下午4:08
%%%-------------------------------------------------------------------
-module(dp_lib).
-include("common.hrl").

%% API
-export([
	add/0,
	add/2,
	cast/1,
	cast/2,
	cast/3,
	get_name/1,
	get_name/2
]).

%%添加默认的一组数据处理，应用启用时初始化
add() ->
	[dp_sup:start_child([{dp, Index}]) || Index <- lists:seq(1, erlang:system_info(schedulers))],
	ok.

%%添加其它的数据处理，应用启用时初始化
add(Type, Num) ->
	[dp_sup:start_child([{Type, Index}]) || Index <- lists:seq(1, Num)],
	ok.

%%发送异步请求
cast(Mfa) ->
	ModName = get_name(erlang:system_info(scheduler_id)),
	%%?INFO("dp_lib:cast ~p",[ModName]),
	gen_server:cast(ModName, {dp_cast, Mfa}),
	ok.

cast(Index, Mfa) ->
	cast(dp, Index, Mfa).

%%发送特定类型的异步请求,由业务指定数据处理的进程
cast(Type, Index, Mfa) ->
	ModName = get_name(Type, Index),
	gen_server:cast(ModName, {dp_cast, Mfa}),
	ok.

%%获取数据处理进程的名字
get_name(Index) ->
	list_to_atom(lists:concat([dp,Index])).

get_name(Type, Index) ->
	list_to_atom(lists:concat([Type, Index])).