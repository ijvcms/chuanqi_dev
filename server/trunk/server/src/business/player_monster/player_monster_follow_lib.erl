%%%-------------------------------------------------------------------
%%% @author qhb
%%% @copyright (C) 2016, <COMPANY>
%%% @doc
%%%	boss刷新关注
%%% @end
%%% Created : 04. 八月 2016 下午3:58
%%%-------------------------------------------------------------------
-module(player_monster_follow_lib).
-include("common.hrl").
-include("record.hrl").
-include("db_record.hrl").
-include("proto.hrl").
-include("cache.hrl").
-include("config.hrl").

%% API
-export([
	follow_list/1,
	follow_action/4,
	follow_dict/1,
	follow_push/2,
	follow_notice_online/2
]).

%% GEN API
-export([
	follow_notice_online_local/2
]).

%%boss刷新的关注列表
follow_list(PlayerState) ->
	PlayerId = PlayerState#player_state.player_id,
	List = player_monster_follow_db:select_all(PlayerState#player_state.player_id),
	Follows = [
		#proto_monster_follow{scene_id = SceneId, monster_id = MonsterId}
		|| #db_player_monster_follow{scene_id = SceneId, monster_id = MonsterId} <- List],
	Rep = #rep_monster_follow{follows = Follows},
	net_send:send_to_client(PlayerId, 22004, Rep),
	{ok, PlayerState}.

%%boss刷新关注
follow_action(PlayerState, SceneId, MonsterId, Action) ->
	#player_state{open_id = OpenId, platform = Channel, db_player_base = #db_player_base{player_id = PlayerId}} = PlayerState,
	case Action =:= 1 of
		true ->
			Data = #db_player_monster_follow{scene_id = SceneId, monster_id = MonsterId, player_id = PlayerId,
				open_id = OpenId, channel = Channel},
			player_monster_follow_db:replace(Data);
		false ->
			player_monster_follow_db:delete(SceneId, MonsterId, PlayerId)
	end,
	Rep = #rep_monster_follow_action{result = 0},
	net_send:send_to_client(PlayerId, 22005, Rep),
	{ok, PlayerState}.

%%boss刷新关注字典
follow_dict(PlayerId) ->
	List = player_monster_follow_db:select_all(PlayerId),
	Follows = [
		{{SceneId, MonsterId}, 1}
		|| #db_player_monster_follow{scene_id = SceneId, monster_id = MonsterId} <- List],
	dict:from_list(Follows).

%%boss刷新推送
follow_push(SceneId, MonsterId) ->
	Dict = get_follow_boss_dict(),
	Key = {SceneId, MonsterId},
	case dict:is_key(Key, Dict) andalso get(Key) =:= undefined of
		true ->
			put(Key, 1),
			?INFO("follow push ~p ~p",[SceneId, MonsterId]),
			%%push_game_lib:add_push_task(monster_refresh, [SceneId, MonsterId]),
			ok;
		false ->
			skip
	end,
	ok.

%%boss刷新通知
follow_notice_online(SceneId, MonsterId) ->
	Dict = get_follow_boss_dict(),
	Key = {SceneId, MonsterId},
	case dict:is_key(Key, Dict) of
		true ->
			erase(Key),
			?INFO("follow notice ~p ~p",[SceneId, MonsterId]),
			dp_lib:cast({?MODULE, follow_notice_online_local, [SceneId, MonsterId]}),
			ok;
		false ->
			skip
	end,
	ok.
follow_notice_online_local(SceneId, MonsterId) ->
	PlayerIdList = player_monster_follow_db:select_player_id(SceneId, MonsterId),
	lists:foreach(fun(PlayerId) ->
		case player_lib:is_online(PlayerId) of
			true ->
				Rep = #rep_boss_refresh_notice{scene_id = SceneId, monster_id = MonsterId},
				net_send:send_to_client(PlayerId, 11049, Rep),
				ok;
			false ->
				skip
		end
	end, PlayerIdList),
	ok.

%%%===================================================================
%%% Internal functions
%%%===================================================================

get_follow_boss_dict() ->
	case get(follow_boss_dict) of
		undefined ->
			List1 = world_boss_config:get_list_conf(),
			BossList1 = [{{SceneId, BossId}, 1} || #world_boss_conf{scene_id = SceneId, boss_id = BossId} <- List1],
			List2 = vip_boss_config:get_list_conf(),
			BossList2 = [{{SceneId, BossId}, 1} || #vip_boss_conf{scene_id = SceneId, boss_id = BossId} <- List2],
			BossKVList = lists:append(BossList1, BossList2),
			Dict = dict:from_list(BossKVList),
			put(follow_boss_dict, Dict),
			Dict;
		FollowBoosDict ->
			FollowBoosDict
	end.

