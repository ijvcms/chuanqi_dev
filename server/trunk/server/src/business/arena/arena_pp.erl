%%%-------------------------------------------------------------------
%%% @author tuhujia
%%% @copyright (C) 2015, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 14. 十二月 2015 14:11
%%%-------------------------------------------------------------------
-module(arena_pp).

-include("common.hrl").
-include("record.hrl").
-include("proto.hrl").
-include("cache.hrl").
-include("config.hrl").
-include("language_config.hrl").

%% API
-export([
	handle/3
]).

%% ====================================================================
%% API functions
%% ====================================================================

%% 获取排行榜排名
handle(23001, PlayerState, _Data) ->
	Rank = arena_lib:get_player_arena_rank(PlayerState),
	net_send:send_to_client(PlayerState#player_state.socket, 23001, #rep_get_arena_rank{rank = Rank});

%% 获取挑战次数
handle(23002, PlayerState, _Data) ->
	Count = arena_lib:get_challenge_count(PlayerState),
	net_send:send_to_client(PlayerState#player_state.socket, 23002, #rep_get_arena_count{count = Count});

%% 获取挑战玩家信息
handle(23003, PlayerState, _Data) ->
	arena_lib:get_match_arena_info(PlayerState);

%% 获取排行榜
handle(23004, PlayerState, _Data) ->
	arena_lib:get_rank_list_before_twenty(PlayerState#player_state.socket);

%% 获取挑战记录
handle(23005, PlayerState, _Data) ->
	Proto = arena_lib:get_player_challenge_record(PlayerState),
	net_send:send_to_client(PlayerState#player_state.socket, 23005, #rep_arena_record_list{list = Proto});

%% 兑换
handle(23006, PlayerState, #req_arena_shop{id = Id}) ->
	case arena_shop_lib:buy_arena_item(PlayerState, Id) of
		{ok, PlayerState1} ->
			net_send:send_to_client(PlayerState#player_state.socket, 23006, #rep_arena_shop{result = ?ERR_COMMON_SUCCESS}),
			{ok, PlayerState1};
		{fail, Reply} ->
			net_send:send_to_client(PlayerState#player_state.socket, 23006, #rep_arena_shop{result = Reply})
	end;

%% 获取声望
handle(23007, PlayerState, _Data) ->
	Value = arena_lib:get_player_arena_reputation(PlayerState),
	net_send:send_to_client(PlayerState#player_state.socket, 23007, #rep_get_arena_reputation{reputation = Value});

%% 发起挑战
handle(23008, PlayerState, #req_challenge_arena{player_id = PlayerIdB}) ->
	case arena_lib:challenge_arena_player(PlayerState, PlayerIdB) of
		{ok, PlayerState1} ->
			net_send:send_to_client(PlayerState#player_state.socket, 23008, #rep_challenge_arena{result = ?ERR_COMMON_SUCCESS}),
			{ok, PlayerState1};
		{fail, Reply} ->
			net_send:send_to_client(PlayerState#player_state.socket, 23008, #rep_challenge_arena{result = Reply})
	end;

%% 刷新匹配列表
handle(23009, PlayerState, _Data) ->
	{_, Reply} = arena_lib:refuse_match_arena_info(PlayerState),
	net_send:send_to_client(PlayerState#player_state.socket, 23009, #rep_refuse_match_list{result = Reply});

%% 清空列表
handle(23010, PlayerState, _Data) ->
	PlayerId = PlayerState#player_state.player_id,
	arena_record_cache:clear_arena_record(PlayerId),
	net_send:send_to_client(PlayerState#player_state.socket, 23005, #rep_arena_record_list{list = []}),
	net_send:send_to_client(PlayerState#player_state.socket, 23010, #rep_clear_arena_record{result = ?ERR_COMMON_SUCCESS});

handle(Cmd, PlayerState, Data) ->
	?ERR("not define ~p cmd:~nstate: ~p~ndata: ~p", [Cmd, PlayerState, Data]),
	{ok, PlayerState}.