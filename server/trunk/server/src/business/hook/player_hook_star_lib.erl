%%%-------------------------------------------------------------------
%%% @author zhengsiying
%%% @copyright (C) 2015, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 23. 九月 2015 上午10:30
%%%-------------------------------------------------------------------
-module(player_hook_star_lib).

-include("common.hrl").
-include("record.hrl").
-include("cache.hrl").
-include("config.hrl").
-include("proto.hrl").
-include("language_config.hrl").
-include("log_type_config.hrl").

%% API
-export([
	init/1,
	get_hook_star_list/0,
	store_hook_star/3,
	get_chapter_star/1,
	get_chapter_star/2,
	draw_first_prize/2
]).

%% ====================================================================
%% API functions
%% ====================================================================
%% 初始化星级信息
init(PlayerState) ->
	PlayerId = PlayerState#player_state.player_id,
	case player_hook_star_cache:select_all(PlayerId) of
		[] ->
			put_player_hook_star_dict(dict:new());
		List ->
			F = fun(DbHookStar, Acc) ->
					dict:store(DbHookStar#db_player_hook_star.hook_scene_id, DbHookStar, Acc)
				end,
			HookStarDict = lists:foldl(F, dict:new(), List),
			put_player_hook_star_dict(HookStarDict)
	end.

%% 获取挂机星级列表
get_hook_star_list() ->
	HookStarDict = get_player_hook_star_dict(),
	F = fun(SceneId, DbHookStar, Acc) ->
			[#proto_hook_star{
				hook_scene_id = SceneId,
				star = DbHookStar#db_player_hook_star.star,
				reward_status = DbHookStar#db_player_hook_star.reward_status
			} | Acc]
		end,
	dict:fold(F, [], HookStarDict).

%% 获取章节星级总数
get_chapter_star(Chapter) ->
	HookStarDict = get_player_hook_star_dict(),
	get_chapter_star(HookStarDict, Chapter).

%% 获取章节星级总数
get_chapter_star(HookStarDict, Chapter) ->
	List = hook_scene_config:get_chapter_list(Chapter),
	F = fun(SceneId, Acc) ->
		case get_hook_star_info(HookStarDict, SceneId) of
			#db_player_hook_star{} = DbHookStar ->
				Acc + DbHookStar#db_player_hook_star.star;
			_ ->
				Acc
		end
	end,
	lists:foldl(F, 0, List).

%% 更新挂机星级信息
store_hook_star(PlayerState, SceneId, Star) ->
	PlayerId = PlayerState#player_state.player_id,
	HookStarDict = get_player_hook_star_dict(),
	%% 判断对应场景通过星级是否已经有记录
	case dict:find(SceneId, HookStarDict) of
		{ok, DbHookStar} ->
			%% 有记录做更新操作
			case DbHookStar#db_player_hook_star.star < Star of
				true ->
					NewDbHookStar = DbHookStar#db_player_hook_star{star = Star},
					player_hook_star_cache:update({PlayerId, SceneId}, NewDbHookStar),
					NewHookStarDict = dict:store(SceneId, NewDbHookStar, HookStarDict),

					Data = make_rep_update_hook_star(NewDbHookStar),
					net_send:send_to_client(PlayerState#player_state.socket, 13016, Data),
					put_player_hook_star_dict(NewHookStarDict),

					HookSceneConf = hook_scene_config:get(SceneId),
					%% 计算星级奖励
					hook_star_reward_lib:compute_reward(PlayerState, NewHookStarDict, HookSceneConf#hook_scene_conf.chapter);
				_ ->
					skip
			end;
		_ ->
			%% 没记录做添加操作
			NewDbHookStar = #db_player_hook_star{
				player_id = PlayerId,
				hook_scene_id = SceneId,
				star = Star,
				reward_status = ?REWARD_STATUS_CAN_DRAW
			},
			player_hook_star_cache:insert(NewDbHookStar),
			NewHookStarDict = dict:store(SceneId, NewDbHookStar, HookStarDict),

			Data = make_rep_update_hook_star(NewDbHookStar),
			net_send:send_to_client(PlayerState#player_state.socket, 13016, Data),
			put_player_hook_star_dict(NewHookStarDict),

			HookSceneConf = hook_scene_config:get(SceneId),
			%% 计算星级奖励
			hook_star_reward_lib:compute_reward(PlayerState, NewHookStarDict, HookSceneConf#hook_scene_conf.chapter)
	end.

%% 领取挂机boos首次通关奖励
draw_first_prize(PlayerState, SceneId) ->
	HookStarDict = get_player_hook_star_dict(),
	case dict:find(SceneId, HookStarDict) of
		{ok, DbHookStar} ->
			%% 判断奖励是否可领取
			case DbHookStar#db_player_hook_star.reward_status of
				?REWARD_STATUS_CAN_DRAW ->
					HookSceneConf = hook_scene_config:get(SceneId),
					FirstPrize = HookSceneConf#hook_scene_conf.first_prize,
					GoodsList = [{GoodsId, ?BIND, Num} || {GoodsId, Num} <- FirstPrize],
					PlayerId = PlayerState#player_state.player_id,

					Socket = PlayerState#player_state.socket,
					case goods_lib_log:add_goods_list(PlayerState, GoodsList,?LOG_TYPE_HOOK_FRIST) of
						{ok, NewPlayerState} ->
							NewDbHookStar = DbHookStar#db_player_hook_star{reward_status = ?REWARD_STATUS_HAS_DRAW},
							player_hook_star_cache:update({PlayerId, SceneId}, NewDbHookStar),
							NewHookStarDict = dict:store(SceneId, NewDbHookStar, HookStarDict),

							net_send:send_to_client(Socket, 13024, #rep_draw_first_reward{}),

							Data = make_rep_update_hook_star(NewDbHookStar),
							net_send:send_to_client(Socket, 13016, Data),
							put_player_hook_star_dict(NewHookStarDict),

							{ok, NewPlayerState};
						{fail, Err} ->
							net_send:send_to_client(Socket, 13024, #rep_draw_first_reward{result = Err})
					end;
				_ ->
					skip
			end;
		_ ->
			skip
	end.

put_player_hook_star_dict(HookStarDict) ->
	put(hook_star_dict, HookStarDict).

get_player_hook_star_dict() ->
	get(hook_star_dict).

%% ====================================================================
%% Internal functions
%% ====================================================================
%% 获取挂机星级信息
get_hook_star_info(HookStarDict, SceneId) ->
	case dict:find(SceneId, HookStarDict) of
		{ok, DbHookStar} ->
			DbHookStar;
		_ ->
			null
	end.

%% 生成星级更新协议包
make_rep_update_hook_star(DbHookStar) ->
	#rep_update_hook_star{
		hook_star = #proto_hook_star{
			hook_scene_id = DbHookStar#db_player_hook_star.hook_scene_id,
			star = DbHookStar#db_player_hook_star.star,
			reward_status = DbHookStar#db_player_hook_star.reward_status
		}
	}.
