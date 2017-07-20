%%%-------------------------------------------------------------------
%%% @author tuhujia
%%% @copyright (C) 2016, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 29. 一月 2016 11:51
%%%-------------------------------------------------------------------
-module(active_ets).

-include("common.hrl").
-include("record.hrl").
-include("proto.hrl").
-include("cache.hrl").
-include("config.hrl").
-include("language_config.hrl").
-include("rank.hrl").
-include("button_tips_config.hrl").

%% API
-export([
	init/0,
	get_ets_monster/1,
	save_ets_monster/1,
	save_kill_team/3,
	save_kill/2,
	save_kill_monster/2
]).

init() ->
	case player_monster_cache:select_all() of
		[] ->
			skip;
		PlayerMonsterList ->
			List = [X || X <- PlayerMonsterList, X#db_player_monster.is_frist =:= 1],
			F = fun(X) ->
				save_ets_monster(X)
			end,
			[F(X) || X <- List]
	end.

%% 击杀怪物判断 首杀
save_kill_team(MonsterId, DropOwnerId, MemberList) ->
	%% boss首杀活动
	case lists:member(MonsterId, active_service_config:get_monster_id_list()) of
		true ->
			active_service_lib:insert_active_record(?ACTIVE_SERVICE_TYPE_MONSTER, DropOwnerId, MonsterId),
			F = fun(R) ->
				case R#team_mb.player_id /= DropOwnerId of
					true ->
						active_service_lib:insert_active_record(?ACTIVE_SERVICE_TYPE_MONSTER, R#team_mb.player_id, MonsterId);
					_ ->
						skip
				end
			end,
			[F(X) || X <- MemberList];
		_ ->
			skip
	end.

%% 保存击杀信息
save_kill(PlayerId, MonsterId) ->
	case lists:member(MonsterId, active_service_config:get_monster_id_list()) of
		true ->
			active_service_lib:insert_active_record(?ACTIVE_SERVICE_TYPE_MONSTER, PlayerId, MonsterId);
		_ ->
			skip
	end.
%% 保存击杀信息
save_kill_monster(PlayerId, MonsterId) ->
	case ets:lookup(?ETS_ACTIVE_SERVICE_MONTHER, MonsterId) of
		[] ->
			PlayerMonsterInfo = #db_player_monster{
				player_id = PlayerId,
				monster_id = MonsterId,
				time = util_date:unixtime(),
				is_frist = 1,
				is_frist_goods = 0,
				is_goods = 0
			},
			player_monster_cache:insert(PlayerMonsterInfo),
			save_ets_monster(PlayerMonsterInfo),
			button_tips_lib:ref_button_tips_player_id(PlayerId, ?BTN_ACTIVE_SERVICE_BOSS);
		_ ->
			case player_monster_cache:select_row(PlayerId, MonsterId) of
				null ->
					PlayerMonsterInfo = #db_player_monster{
						player_id = PlayerId,
						monster_id = MonsterId,
						time = util_date:unixtime(),
						is_frist = 0,
						is_frist_goods = 0,
						is_goods = 0
					},
					player_monster_cache:insert(PlayerMonsterInfo),
					button_tips_lib:ref_button_tips_player_id(PlayerId, ?BTN_ACTIVE_SERVICE_BOSS);
				_ ->
					skip
			end
	end.


save_ets_monster(Info) ->
	ets:insert(?ETS_ACTIVE_SERVICE_MONTHER, Info).

get_ets_monster(MonsterId) ->
	case ets:lookup(?ETS_ACTIVE_SERVICE_MONTHER, MonsterId) of
		[R | _] ->
			R;
		_ ->
			null
	end.