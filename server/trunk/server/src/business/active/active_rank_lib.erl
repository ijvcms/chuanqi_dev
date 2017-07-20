%%%-------------------------------------------------------------------
%%% @author yubing
%%% @copyright (C) 2016, <COMPANY>
%%% @doc 开服活动信息
%%%
%%% @end
%%% Created : 23. 二月 2016 18:06
%%%-------------------------------------------------------------------
-module(active_rank_lib).

-include("common.hrl").
-include("record.hrl").
-include("config.hrl").
-include("cache.hrl").
-include("db_record.hrl").
-include("proto.hrl").
-include("language_config.hrl").
-include("log_type_config.hrl").
-include("button_tips_config.hrl").
-include("rank.hrl").
-include("uid.hrl").
%%% ----------------------------------------------------------------------------
%%% 对外接口
%%% ----------------------------------------------------------------------------

-export([
	get_rank_list/4,
	checke_acitve_over/1,
	checke_active_service/2
]).

%%获取活动列表信息
get_rank_list(PlayerState, Type, BegionTime, EndTime) ->
	CurTime = util_date:unixtime(),
	case BegionTime > CurTime of
		true ->
			{0, 0, []};
		_ ->
			%% 排名列表
			RankList = rank_lib:get_rank_list_active_type(Type, false),
			#player_state{player_id = PlayerId} = PlayerState,
			SubList = lists:sublist(RankList, 1, 3),
			MyRank = case lists:keyfind(PlayerState#player_state.player_id, #ets_active_rank_info.player_id, RankList) of
						 false ->
							 0;
						 RankInfo ->
							 RankInfo#ets_active_rank_info.rank
					 end,
			MyLv =
				case EndTime > CurTime of
					true ->
						%% 如果活动还未结束就调用当前的值
						active_service_lib:get_type_now_value(PlayerState, Type);
					_ ->
						%% 如果活动已经结束，就调用结束的值
						active_service_lib:get_type_value(PlayerId, Type)
				end,
			MyLv1 = get_my_lv(Type, MyLv),
			Fun = fun(Info) ->
				#proto_active_service_rank_info
				{
					name = Info#ets_active_rank_info.name,  %%  玩家名字
					rank = Info#ets_active_rank_info.rank,  %%  玩家排名
					player_id = Info#ets_active_rank_info.player_id,
					value = Info#ets_active_rank_info.value
				}
			end,
			List = [Fun(X) || X <- SubList],
			?INFO("~p", [{MyLv}]),
			{MyLv1, MyRank, List}
	end.



get_my_lv(?ACTIVE_SERVICE_TYPE_WING, MyLv) when MyLv > 0 ->
	List = goods_config:get_type_list(?SUBTYPE_WING),
	{_, Name} = lists:keyfind(MyLv, 1, List),
	xmerl_ucs:to_utf8(Name);
get_my_lv(?ACTIVE_SERVICE_TYPE_MEDAL, MyLv) when MyLv > 0 ->
	List = goods_config:get_type_list(?SUBTYPE_MEDAL),
	{_, Name} = lists:keyfind(MyLv, 1, List),
	xmerl_ucs:to_utf8(Name);
get_my_lv(_, MyLv) ->
	MyLv.

%%*****************************************************************
%% 排名活动检测
%%*****************************************************************


%% 检测开服活动，发放玩家的奖励
checke_acitve_over(PlayerState) ->
	F = fun(X) ->
		ActiveServerTypeConf = active_service_type_config:get(X),
		case ActiveServerTypeConf#active_service_type_conf.receive_state of
			?RECEIVE_STATE_2 ->
				%% 获取活动列表
				[checke_active_service(PlayerState, M) || M <- active_service_config:get_list_conf(),
					M#active_service_conf.rank =:= 0 andalso M#active_service_conf.type =:= X];
			_ ->
				skip
		end
	end,
	[F(X) || X <- active_service_type_config:get_list(), active_service_lib:is_over(X)].

%% 发送玩家的开服活动信息
checke_active_service(PlayerState, ActiveServerConf) when is_record(PlayerState, player_state) ->
	case active_service_lib:check_active(PlayerState, ActiveServerConf, ActiveServerConf#active_service_conf.type) of
		0 ->
			#player_state{player_id = PlayerId, db_player_base = #db_player_base{career = Career}} = PlayerState,
			send_active_goods(PlayerId, Career, ActiveServerConf);
		_ ->
			skip
	end;
checke_active_service(PlayerId, ActiveServerConf) ->
	EtsPlayerNameInfo = player_id_name_lib:get_ets_player_id_name_by_playerid(PlayerId),
	#ets_player_id_name{player_id = PlayerId, career = Career} = EtsPlayerNameInfo,
	send_active_goods(PlayerId, Career, ActiveServerConf).

%% 发送奖励
send_active_goods(PlayerId, Career, ActiveServerConf) ->
	#active_service_conf{
		id = ActiveServiceId,
		mail_title = MailTitle,
		mail_text = MailInfo,
		reward_fashi = RewardFa,
		reward_daoshi = RewardDao,
		reward_zhanshi = RewardZhan
	} = ActiveServerConf,
	%% 查看是否已经发放了该活动的奖励了
	case player_active_service_cache:select_row({PlayerId, ActiveServiceId}) of
		null ->
			%% 添加领取记录
			PlayerActiveInfo = #db_player_active_service{
				player_id = PlayerId,
				active_service_id = ActiveServiceId,
				time = util_date:unixtime()
			},
			player_active_service_cache:insert(PlayerActiveInfo),
			GoodsList = active_service_lib:get_goods_list(Career, RewardFa, RewardDao, RewardZhan),
			mail_lib:send_mail_to_player(PlayerId, <<"">>, MailTitle, MailInfo, GoodsList);
		_ ->
			skip
	end.





