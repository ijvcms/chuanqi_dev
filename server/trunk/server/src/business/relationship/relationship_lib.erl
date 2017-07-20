%%%-------------------------------------------------------------------
%%% @author tuhujia
%%% @copyright (C) 2015, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 10. 八月 2015 14:39
%%%-------------------------------------------------------------------
-module(relationship_lib).

-include("common.hrl").
-include("record.hrl").
-include("config.hrl").
-include("cache.hrl").
-include("db_record.hrl").
-include("uid.hrl").
-include("proto.hrl").

-export([
	save_ets/1,
	get_ets/1,
	init/1
]).

%% 初始话 玩家的关系信息
init(PlayerState) ->
	PlayerId = PlayerState#player_state.player_id,
	Ets = #ets_relationship
	{
		player_id = PlayerId,
		friend_list = player_friend_cache:select_all(PlayerId),
		foe_list = player_foe_cache:select_all(PlayerId),
		friend_ask_list = player_friend_ask_cache:select_all(PlayerId),
		black_list = player_black_cache:select_all(PlayerId)
	},
	save_ets(Ets).

%% 从ets获取玩家关系记录
get_ets(PlayerId) ->
	case ets:lookup(?ETS_RELATIONSHIP, PlayerId) of
		[R | _] ->
			R;
		[] ->
			[]
	end.
%% 保存玩家关系记录到ets
save_ets(EtsInfo) ->
	ets:insert(?ETS_RELATIONSHIP, EtsInfo).







