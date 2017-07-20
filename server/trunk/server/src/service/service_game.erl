%%%-------------------------------------------------------------------
%%% @author zhengsiying
%%% @copyright (C) 2015, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 25. 七月 2015 下午2:57
%%%-------------------------------------------------------------------
-module(service_game).


%% API
-export([
	start/0
]).

%% ====================================================================
%% API functions
%% ====================================================================
start() ->
	ModList = [
		{uid_mod},
		{online_mod},
		{scene_mgr_mod},
		{sensitive_word_mod},
		{sale_mod},
		{ronglian_chat_mod},
		{rank_mod},
		{active_mod},
		{active_merge_mod},
		{red_mod},
		{lottery_mod},
		{log_mod},
		{red_guild_mod},
		{cache_log_mod},
		{email_mod},
		{robot_mod},
		{guild_challenge_mod},
		{operate_active_mod},
		{push_game_mod},
		{notice_mod},
		{spec_dragon_mod},
		{spec_palace_boss_mod},
		{alliance_mod},
		{player_batch_mod}
	],
	ok = util:start_mod(permanent, ModList),
	ok = guild_mod:start(),    %% 帮会
%% 	ok = util:start_mod(permanent, [{online_mod}, {scene_mgr_mod}]),
	scene_mgr_lib:create_permanently_scene(),%% 初始化 创建全部场景信息
	dp_lib:add(),
	dp_lib:add(dp_push, 10),
	mod_ets_holder_sup:start_child([{modlib, [{log_data}]}]),
	%%player_batch_lib:start_task(),%%批量处理任务
	ok.

%% ====================================================================
%% Internal functions
%% ====================================================================
