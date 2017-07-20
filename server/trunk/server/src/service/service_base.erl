%%%-------------------------------------------------------------------
%%% @author zhengsiying
%%% @copyright (C) 2015, <COMPANY>
%%% @doc
%%%     基础服务：一般是每个节点都需要的服务
%%% @end
%%% Created : 07. 三月 2015 17:13
%%%-------------------------------------------------------------------
-module(service_base).

-include("common.hrl").

%% API
-export([
	start/0
]).
%% ====================================================================
%% API functions
%% ====================================================================
start() ->
	db:init(),
	error_logger:add_report_handler(logger_handle),
	ModList = [{misc_timer}, {mod_randseed},{dp_sup},{mod_ets_holder_sup}],%%  misc_timer 时间－时间戳  mod_ranseed 随机数
	ok = util:start_mod(permanent, ModList),
	ok.

%% ====================================================================
%% Internal functions
%% ====================================================================