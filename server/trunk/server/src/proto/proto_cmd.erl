%%%-------------------------------------------------------------------
%%% @author zhengsiying
%%% @copyright (C) 2015, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 16. 四月 2015 下午5:11
%%%-------------------------------------------------------------------
-module(proto_cmd).

%% API
-export([
	route/1,
	to_process/1
]).

-include("common.hrl").

%% ====================================================================
%% API functions
%% ====================================================================
route(Cmd) ->
%%     List = [10006, 13003, 32002, 32001, 13001, 11037, 21001],
%%     case lists:member(Cmd, List) of
%%         true ->
%%             skip;
%%         _ ->
%%             ?ERR("~p ", [Cmd])
%%     end,
	get_mod(Cmd div 1000).

to_process(10000) -> tcp_client;
to_process(10001) -> tcp_client;
to_process(10002) -> tcp_client;
to_process(10009) -> tcp_client;
to_process(10007) -> tcp_client;
to_process(10006) -> tcp_client;
to_process(10099) -> tcp_client;
to_process(_Cmd) -> player.

%% ====================================================================
%% Internal functions
%% ====================================================================
get_mod(9) -> misc_pp;
get_mod(10) -> player_pp;
get_mod(11) -> scene_pp;
get_mod(12) -> skill_pp;
get_mod(13) -> hook_pp;
get_mod(14) -> goods_pp;
get_mod(15) -> mail_pp;
get_mod(16) -> shop_pp;
get_mod(17) -> guild_pp;
get_mod(20) -> transaction_pp;
get_mod(18) -> chat_pp;
get_mod(19) -> active_task_pp;
get_mod(22) -> set_pp;
get_mod(21) -> team_pp;
get_mod(23) -> arena_pp;
get_mod(24) -> relationship_pp;
get_mod(25) -> city_pp;
get_mod(26) -> main_task_pp;
get_mod(27) -> worship_pp;
get_mod(29) -> vip_pp;
get_mod(28) -> function_pp;
get_mod(30) -> charge_pp;
get_mod(31) -> package_pp;
get_mod(32) -> active_pp;
get_mod(33) -> sale_pp;
get_mod(34) -> red_pp;
get_mod(35) -> lottery_pp;
get_mod(36) -> lottery_coin_pp;
get_mod(37) -> legion_pp;
get_mod(38) -> active_merge_pp;
get_mod(_) -> null.