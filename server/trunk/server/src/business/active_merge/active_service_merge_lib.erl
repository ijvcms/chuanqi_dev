%%%-------------------------------------------------------------------
%%% @author yubing
%%% @copyright (C) 2016, <COMPANY>
%%% @doc 开服活动信息
%%%
%%% @end
%%% Created : 23. 二月 2016 18:06
%%%-------------------------------------------------------------------
-module(active_service_merge_lib).

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
	receive_goods/2,
	get_active_service_list/2,
	do_receive_goods1/3,
	do_get_is_receive/3,
	get_button_tips_fight/1,
	get_button_tips_boss/1,
	get_button_tips_charge_by_exp/1,
	do_get_receive_num/2,
	get_active_time/1,
	is_open/1,
	is_show/1,
	send_active_service_info/4,
	insert_active_record/3,
	insert_active_record/4,
	is_over/1,
	check_active/3,
	get_goods_list/4,
	get_type_value/2,
	get_type_now_value/2,
	get_button_tips_stren_shop/1,
	get_function/2,
	check_double_exp/1,
	check_double_exp/0,
	get_button_tips_login/1,
	get_button_frist_pay/1,
	check_shabake_over/0
]).

-export([
	ref_button_tips/2,
	ref_button_tips1/2,
	do_insert_active_record/5,
	do_check_shabake_over/1
]).


%% 领取活动奖励
receive_goods(PlayerState, ActiveServiceConf) ->
	#player_state{player_id = PlayerId, db_player_base = Base} = PlayerState,
	%% 活动数据
	#active_service_merge_conf{
		type = Type,
		id = ActiveServiceId,
		reward_fashi = FaShi,
		reward_daoshi = DaoShi,
		reward_zhanshi = ZhanShi
	} = ActiveServiceConf,
	{_, EndTime, _, ActiveServiceTypeConf} = get_active_time(Type),
	%% 活动类型数据
	#active_service_merge_type_conf{
		receive_state = ReceiveState,
		is_one = IsOne
	} = ActiveServiceTypeConf,
	case ReceiveState of
		?RECEIVE_STATE_1 ->
			case EndTime < util_date:unixtime() of
				true ->
					{fail, ?ERR_ACTIVE_SERVICE_10};
				_ ->
					case check_active(PlayerState, ActiveServiceConf, Type) of
						0 ->
							%% 是全服活动还是单人活动
							{ok, Err} = case IsOne /= 0 of
											true ->
												case player_active_service_merge_cache:select_row({PlayerId, ActiveServiceId}) of
													null ->
														%% 添加领取记录
														PlayerActiveInfo = #db_player_active_service_merge{
															player_id = PlayerId,
															active_service_merge_id = ActiveServiceId,
															time = util_date:unixtime()
														},
														player_active_service_merge_cache:insert(PlayerActiveInfo),
														{ok, 0};
													_ ->
														{ok, ?ERR_ACTIVE_SERVICE_12}
												end;
											_ ->
												receive_goods1(PlayerId, ActiveServiceConf)
										end,
							case Err /= 0 of
								true ->
									{fail, Err};
								_ ->
									case Base#db_player_base.career of
										?CAREER_FASHI ->
											goods_lib_log:add_goods_list_and_send_mail(PlayerState, FaShi, ?LOG_TYPE_MERGE_ACTIVE_SERVICE);
										?CAREER_DAOSHI ->
											goods_lib_log:add_goods_list_and_send_mail(PlayerState, DaoShi, ?LOG_TYPE_MERGE_ACTIVE_SERVICE);
										_ ->
											goods_lib_log:add_goods_list_and_send_mail(PlayerState, ZhanShi, ?LOG_TYPE_MERGE_ACTIVE_SERVICE)
									end
							end;
						{State1, State2, PlayerMonsterInfo, _} ->
							receive_goods1(PlayerState, State1, State2, PlayerMonsterInfo, ActiveServiceConf);
						Err ->
							{fail, Err}
					end
			end;
		_ ->
			{fail, ?ERR_ACTIVE_SERVICE_11}
	end.

receive_goods1(PlayerState, State1, State2, PlayerMonsterInfo, ActiveServiceConf) ->
	Base = PlayerState#player_state.db_player_base,

	#active_service_merge_conf{
%%     id = ActiveServiceId,
		reward_fashi = RewardFa,
		reward_daoshi = RewardDao,
		reward_zhanshi = RewardZhan
	} = ActiveServiceConf,

	{ok, PlayerState2, PlayerMonsterInfo1} =
		case State1 =:= 0 of
			true ->
				GoodsList = get_goods_list(Base#db_player_base.career, RewardFa, RewardDao, RewardZhan),
				{ok, PlayerState1} = goods_lib_log:add_goods_list_and_send_mail(PlayerState, GoodsList, ?LOG_TYPE_MERGE_ACTIVE_SERVICE),

				NewInfo = PlayerMonsterInfo#db_player_monster_merge{
					is_frist_goods = 2
				},
				{ok, PlayerState1, NewInfo};
			_ ->
				{ok, PlayerState, PlayerMonsterInfo}

		end,
	case State2 =:= 0 of
		true ->
			GoodsList1 = ActiveServiceConf#active_service_merge_conf.reward,
			NewInfo1 = PlayerMonsterInfo1#db_player_monster_merge{
				is_goods = 2
			},
			player_monster_merge_cache:update({PlayerState2#player_state.player_id, PlayerMonsterInfo#db_player_monster_merge.monster_id}, NewInfo1),

			case NewInfo1#db_player_monster_merge.is_frist =:= 1 of
				true ->
					active_merge_ets:save_ets_monster(NewInfo1);
				_ ->
					skip
			end,
			goods_lib_log:add_goods_list_and_send_mail(PlayerState2, GoodsList1, ?LOG_TYPE_MERGE_ACTIVE_SERVICE);
		_ ->
			{ok, PlayerState2}
	end.

%% 获取活动的详细信息
send_active_service_info(PlayerState, ActiveServiceTypeConf, BeginTime, EndTime) ->
	#active_service_merge_type_conf{receive_state = ReceiveState, id = TypeId} = ActiveServiceTypeConf,
	case ReceiveState of
		?RECEIVE_STATE_1 ->
			Value = get_type_value(PlayerState#player_state.player_id, TypeId),
			List = get_active_service_list(PlayerState, TypeId),
			Data = #rep_active_service_merge_list{
				begin_time = BeginTime,
				end_time = EndTime,
				active_service_list = List,
				my_value = Value
			},
			?INFO(" 38012 ~p ~p", [Data, TypeId]),
			net_send:send_to_client(PlayerState#player_state.socket, 38012, Data);
		?RECEIVE_STATE_2 ->
			%% 活动排名
			{MyLv, MyRank, List} = active_rank_merge_lib:get_rank_list(PlayerState, TypeId, BeginTime, EndTime),
			Data = #rep_active_service_merge_rank_list{
				begin_time = BeginTime,
				end_time = EndTime,
				my_lv = MyLv,
				my_rank = MyRank,
				rank_list = List
			},
			?INFO(" 38040 ~p", [Data]),
			net_send:send_to_client(PlayerState#player_state.socket, 38040, Data);
		?RECEIVE_STATE_3 ->
			%% 活动商店
			List = active_shop_merge_lib:get_active_shop_list(PlayerState, TypeId),
			Data = #rep_active_shop_merge_list{
				goods_list = List,
				begin_time = BeginTime,
				end_time = EndTime
			},
			?INFO(" 38041 ~p", [Data]),
			net_send:send_to_client(PlayerState#player_state.socket, 38041, Data);
		_ ->
			Data = #rep_active_service_merge_list{
				begin_time = BeginTime,
				end_time = EndTime
			},
			?INFO(" 38012 ~p", [Data]),
			net_send:send_to_client(PlayerState#player_state.socket, 38012, Data)
	end.

%%获取活动列表信息
get_active_service_list(PlayerState, ?ACTIVE_SERVICE_TYPE_MONSTER) ->
	List = [X || X <- active_service_merge_config:get_list_conf(), X#active_service_merge_conf.type =:= ?ACTIVE_SERVICE_TYPE_MONSTER],
	F = fun(X) ->
		{State1, State2, _, Name} = check_active(PlayerState, X, ?ACTIVE_SERVICE_TYPE_MONSTER),
		#proto_active_service_info{
			active_service_id = X#active_service_merge_conf.id,
			is_receive = State1,%% 0可以领取1,未达到条件，2，已经领取，3，已经领取完了
			state2 = State2,
			name = Name
		}
	end,
	[F(X) || X <- List];
%%获取活动列表信息
get_active_service_list(PlayerState, ActiveServiceType) ->
	{_, EndTime, _, _} = get_active_time(ActiveServiceType),
	List = [X || X <- active_service_merge_config:get_list_conf(), X#active_service_merge_conf.type =:= ActiveServiceType],
	F = fun(X) ->
		IsTemp = case EndTime < util_date:unixtime() of
					 true ->
						 ?ERR_ACTIVE_SERVICE_10;
					 _ ->
						 check_active(PlayerState, X, ActiveServiceType)
				 end,
		get_proto_active_service_info(PlayerState#player_state.player_id, IsTemp, X)
	end,
	[F(X) || X <- List].

%%**********************************************************************
%%------------------------------------------------------------------------------------
%% 红点相关提示
%%------------------------------------------------------------------------------------
%% 战力活动
get_button_tips_fight(PlayerState) ->
	Type = ?MERGE_ACTIVE_SERVICE_TYPE_FIGHT,
	NowValue = get_type_now_value(PlayerState, Type),
	?INFO("~p", [{Type, NowValue}]),
	%% 活动记录
	active_service_merge_lib:insert_active_record(Type, PlayerState, NowValue),
	{PlayerState, 0}.
%% 战力
get_type_now_value(PlayerState, ?MERGE_ACTIVE_SERVICE_TYPE_FIGHT) ->
	PlayerState#player_state.fighting;
get_type_now_value(_, _) ->
	0.


%%------------------------------------------------------------------------------------
%% 红点相关提示 开服活动
%%------------------------------------------------------------------------------------
%% 充值送大礼
get_button_tips_charge_by_exp(PlayerState) ->
	get_button_tips(PlayerState, ?MERGE_ACTIVE_SERVICE_TYPE_CHARGE_BY_EXP).
%% 登录送大礼
get_button_tips_login(PlayerState) ->
	get_button_tips(PlayerState, ?MERGE_ACTIVE_SERVICE_LOGION).
%% 首冲
get_button_frist_pay(PlayerState) ->
	get_button_tips(PlayerState, ?MERGE_ACTIVE_SERVICE_FRIST_PAY).
%% boss首杀活动
get_button_tips_boss(PlayerState) ->
	get_button_tips(PlayerState, ?MERGE_ACTIVE_SERVICE_TYPE_MONSTER).
%% 2强化折扣日
get_button_tips_stren_shop(PlayerState) ->
	TempNum = case is_open(?MERGE_ACTIVE_SERVICE_TYPE_STREN_SHOP) of
				  true ->
					  1;
				  _ ->
					  0
			  end,
	?INFO("get_button_tips_stren_shop ~p", [TempNum]),
	{PlayerState, TempNum}.

%% 红点处理
get_button_tips(PlayerState, ?MERGE_ACTIVE_SERVICE_TYPE_MONSTER) ->
	List = [X || X <- active_service_merge_config:get_list_conf(), X#active_service_merge_conf.type =:= ?ACTIVE_SERVICE_TYPE_MONSTER],
	F1 = fun(X, Sum) ->
		{State1, State2, _, _} = check_active(PlayerState, X, X#active_service_merge_conf.type),
		case State1 =:= 0 orelse State2 =:= 0 of
			true ->
				Sum + 1;
			_ ->
				Sum
		end
	end,
	Temp = lists:foldr(F1, 0, List),
	{PlayerState, Temp};
get_button_tips(PlayerState, TypeId) ->
	Num = get_type_value(PlayerState#player_state.player_id, TypeId),
	List = [X || X <- active_service_merge_config:get_list_conf(), X#active_service_merge_conf.type =:= TypeId],
	F1 = fun(X, Sum) ->
		case Num >= X#active_service_merge_conf.value of
			true ->
				{ok, {Result, _}} = get_is_receive(PlayerState#player_state.player_id, X),
				case Result =:= 0 of
					true ->
						Sum + 1;
					_ ->
						Sum
				end;
			_ ->
				Sum
		end
	end,
	Temp = lists:foldr(F1, 0, List),
	?INFO("~p", [{Num, Temp, TypeId}]),
	{PlayerState, Temp}.

ref_button_tips1(PlayerState, ?MERGE_ACTIVE_SERVICE_TYPE_STREN_SHOP) ->
	button_tips_lib:ref_button_tips(PlayerState, ?BTN_ACTIVE_SERVICE_STREN_SHOP_MERGE);
ref_button_tips1(_, _) ->
	skip.

%% 刷新红点
ref_button_tips(PlayerId, Type) when is_integer(PlayerId) ->
	case player_lib:get_player_pid(PlayerId) of
		null ->
			?INFO("~p", [{Type, PlayerId}]),
			skip;
		Pid ->
			gen_server2:apply_async(Pid, {?MODULE, ref_button_tips, [Type]})
	end;
%% 刷新红点
ref_button_tips(PlayerState, Type) ->
	#active_service_merge_type_conf{receive_state = ReceiveState} = active_service_merge_type_config:get(Type),
	case ReceiveState of
		?RECEIVE_STATE_1 ->
			case Type of
				?MERGE_ACTIVE_SERVICE_TYPE_CHARGE_BY_EXP ->
					button_tips_lib:ref_button_tips(PlayerState, ?BTN_ACTIVE_SERVICE_EXP_MERGE);
				?MERGE_ACTIVE_SERVICE_TYPE_MONSTER ->
					button_tips_lib:ref_button_tips(PlayerState, ?BTN_ACTIVE_SERVICE_BOSS_MERGE);
				?MERGE_ACTIVE_SERVICE_LOGION ->
					button_tips_lib:ref_button_tips(PlayerState, ?BTN_ACTIVE_SERVICE_LOGION_MERGE);
				?MERGE_ACTIVE_SERVICE_FRIST_PAY ->
					button_tips_lib:ref_button_tips(PlayerState, ?BTN_ACTIVE_SERVICE_FRIST_PAY_MERGE);
				_ ->
					?ERR("no type ~p", [Type]),
					{ok, PlayerState}
			end;
		_ ->
			case Type of
				?MERGE_ACTIVE_SERVICE_TYPE_FIGHT ->
					get_button_tips_fight(PlayerState);
				?MERGE_ACTIVE_SERVICE_TYPE_STREN_SHOP ->
					button_tips_lib:ref_button_tips(PlayerState, ?BTN_ACTIVE_SERVICE_STREN_SHOP_MERGE);
				_ ->
					?ERR("no type ~p", [Type]),
					skip
			end,
			{ok, PlayerState}
	end.

%%------------------------------------------------------------------------------------
%%  第一判断活动任务 玩家是否已经达标
%%------------------------------------------------------------------------------------
%% 战力判断
check_active(PlayerState, ActiveServiceConf, ?MERGE_ACTIVE_SERVICE_TYPE_FIGHT) ->
	Num = get_type_value(PlayerState#player_state.player_id, ?ACTIVE_SERVICE_TYPE_FIGHT),
	case Num >= ActiveServiceConf#active_service_merge_conf.value of
		false ->
			?ERR_ACTIVE_SERVICE_4;
		_ ->
			0
	end;
%% 累计充值奖励
check_active(PlayerState, ActiveServiceConf, ?MERGE_ACTIVE_SERVICE_TYPE_CHARGE_BY_EXP) ->
	Num = get_type_value(PlayerState#player_state.player_id, ?ACTIVE_SERVICE_TYPE_CHARGE_BY_EXP),
	case Num >= ActiveServiceConf#active_service_merge_conf.value of
		false ->
			?ERR_ACTIVE_SERVICE_11;
		_ ->
			0
	end;
%% 全服首杀奖励
check_active(PlayerState, ActiveServiceConf, ?MERGE_ACTIVE_SERVICE_TYPE_MONSTER) ->
	%% 0可以领取1,未达到条件，2，已经领取，
	case active_merge_ets:get_ets_monster(ActiveServiceConf#active_service_merge_conf.value) of
		null ->
			{1, 1, null, <<"">>};%% {全服首次奖励,单次首杀奖励,全服领取玩家名称}
		PlayerMonsterInfo ->
			{State1, State2, MonsterInfo} = case PlayerMonsterInfo#db_player_monster_merge.player_id =:= PlayerState#player_state.player_id of
												true ->
													State = PlayerMonsterInfo#db_player_monster_merge.is_frist_goods,
													MyState = PlayerMonsterInfo#db_player_monster_merge.is_goods,
													{State, MyState, PlayerMonsterInfo};
												_ ->
													State = case PlayerMonsterInfo#db_player_monster_merge.is_frist_goods =:= 2 of
																true ->
																	2;%% 0可以领取1,未达到条件，2，已经领取，
																_ ->
																	1%% 0可以领取1,未达到条件，2，已经领取，
															end,
													case player_monster_merge_cache:select_row(PlayerState#player_state.player_id, ActiveServiceConf#active_service_merge_conf.value) of
														null ->
															{State, 1, null};
														NowPlayerMonsterInfo ->
															MyState = NowPlayerMonsterInfo#db_player_monster_merge.is_goods,
															{State, MyState, NowPlayerMonsterInfo}
													end
											end,
			{State1, State2, MonsterInfo, player_id_name_lib:get_player_name(PlayerMonsterInfo#db_player_monster_merge.player_id)}
	end;
%% 合服首充
check_active(PlayerState, ActiveServiceConf, ?MERGE_ACTIVE_SERVICE_FRIST_PAY) ->
	Num = get_type_value(PlayerState#player_state.player_id, ?MERGE_ACTIVE_SERVICE_FRIST_PAY),
	case Num >= ActiveServiceConf#active_service_merge_conf.value of
		false ->
			?ERR_MAIN_TASK1;
		_ ->
			0
	end;
%% 合服连续登陆
check_active(PlayerState, ActiveServiceConf, ?MERGE_ACTIVE_SERVICE_LOGION) ->
	Num = get_type_value(PlayerState#player_state.player_id, ?MERGE_ACTIVE_SERVICE_LOGION),
	case Num >= ActiveServiceConf#active_service_merge_conf.value of
		false ->
			?ERR_MAIN_TASK1;
		_ ->
			0
	end;
%% 累计充值奖励
check_active(_PlayerState, Conf, Type) ->
	?ERR(" conf not: ~p type: ~p", [Conf, Type]),
	?ERR_MAIN_TASK1.

%% 领取奖励
receive_goods1(PlayerId, ActiveServiceConf) ->
	gen_server2:apply_sync(misc:whereis_name({local, active_merge_mod}), {?MODULE, do_receive_goods1, [PlayerId, ActiveServiceConf]}).

do_receive_goods1(ActiveState, PlayerId, ActiveServiceConf) ->
	ActiveServiceId = ActiveServiceConf#active_service_merge_conf.id,
	{_, List} = lists:keyfind(ActiveServiceId, 1, ActiveState#active_merge_state.active_service_list),
	case lists:keymember(PlayerId, #db_player_active_service_merge.player_id, List) of
		false ->
			%% 判断领取人数
			case length(List) >= ActiveServiceConf#active_service_merge_conf.num andalso ActiveServiceConf#active_service_merge_conf.num /= 0 of
				true ->
					{ok, ?ERR_ACTIVE_SERVICE_2, ActiveState};
				_ ->
					PlayerActiveInfo = #db_player_active_service_merge{
						player_id = PlayerId,
						active_service_merge_id = ActiveServiceId,
						time = util_date:unixtime()
					},
					player_active_service_merge_cache:insert(PlayerActiveInfo),
					NewList = {ActiveServiceId, [PlayerActiveInfo | List]},
					ActiveList = lists:keyreplace(ActiveServiceId, 1, ActiveState#active_merge_state.active_service_list, NewList),

					NewActiveState = ActiveState#active_merge_state{
						active_service_list = ActiveList
					},
					{ok, 0, NewActiveState}
			end;
		_ ->
			{ok, ?ERR_ACTIVE_SERVICE_1, ActiveState}
	end.

%% 领取奖励相关判断
get_is_receive(PlayerId, ActiveServiceConf) ->
	ActiveServiceTypeConf = active_service_merge_type_config:get(ActiveServiceConf#active_service_merge_conf.type),
	%% 是否单人副本
	case ActiveServiceTypeConf#active_service_merge_type_conf.is_one /= 0 of
		true ->
			case player_active_service_merge_cache:select_row({PlayerId, ActiveServiceConf#active_service_merge_conf.id}) of
				null ->
					{ok, {0, 0}};%% 0可以领取1,未达到条件，2，已经领取，3，已经领取完了
				_ ->
					{ok, {2, 0}}
			end;
		_ ->
			gen_server2:apply_sync(misc:whereis_name({local, active_merge_mod}), {?MODULE, do_get_is_receive, [PlayerId, ActiveServiceConf]})
	end.

do_get_is_receive(ActiveState, PlayerId, ActiveServiceConf) ->
	ActiveServiceId = ActiveServiceConf#active_service_merge_conf.id,
	{_, List} = lists:keyfind(ActiveServiceId, 1, ActiveState#active_merge_state.active_service_list),
	Num = length(List),
	case lists:keymember(PlayerId, #db_player_active_service_merge.player_id, List) of
		false ->
			%% 判断领取人数
			case length(List) >= ActiveServiceConf#active_service_merge_conf.num of
				true ->
					{ok, {3, Num}, ActiveState};%% 0可以领取1,未达到条件，2，已经领取，3，已经领取完了
				_ ->
					{ok, {0, Num}, ActiveState}
			end;
		_ ->
			{ok, {2, Num}, ActiveState}
	end.

%% 获取奖励领取人数
get_receive_num(ActiveServiceConf) ->
	gen_server2:apply_sync(misc:whereis_name({local, active_merge_mod}), {?MODULE, do_get_receive_num, [ActiveServiceConf]}).

do_get_receive_num(ActiveState, ActiveServiceConf) ->
	ActiveServiceId = ActiveServiceConf#active_service_merge_conf.id,
	{_, List} = lists:keyfind(ActiveServiceId, 1, ActiveState#active_merge_state.active_service_list),
	Num = length(List),
	{ok, Num}.

%%获取列表相关信息
get_proto_active_service_info(PlayerId, IsTrue, ActiveServiceConf) ->
	case IsTrue =:= 0 of
		true ->
			{ok, {Result, Num}} = get_is_receive(PlayerId, ActiveServiceConf),
			#proto_active_service_info{
				is_receive = Result,
				num = ActiveServiceConf#active_service_merge_conf.num - Num,
				active_service_id = ActiveServiceConf#active_service_merge_conf.id
			};
		_ ->
			{ok, Num} = get_receive_num(ActiveServiceConf),
			#proto_active_service_info{
				is_receive = 1,%% 0可以领取1,未达到条件，2，已经领取，3，已经领取完了
				num = ActiveServiceConf#active_service_merge_conf.num - Num,
				active_service_id = ActiveServiceConf#active_service_merge_conf.id
			}
	end.

%%---------------------------------------------------------------------
%%---------------------------------------------------------------------
%%---------------------------------------------------------------------
%% 获取活动的开始结束时间
get_active_time(ActiveServiceType) ->
	ActiveServiceConf = active_service_merge_type_config:get(ActiveServiceType),
	case config:get_merge_times() of
		1 ->
			{BeginAddDay, {BeginH, BeginM}} = ActiveServiceConf#active_service_merge_type_conf.begin_time,
			{EndAddDay, {EndH, EndM}} = ActiveServiceConf#active_service_merge_type_conf.end_time,
			{ShowAddDay, {ShowH, ShowM}} = ActiveServiceConf#active_service_merge_type_conf.show_time,
			{{OpenY, OpenM, OpenD}, {_, _, _}} = config:get_merge_time(),
			BeginTime = util_date:time_tuple_to_unixtime({{OpenY, OpenM, OpenD}, {BeginH, BeginM, 0}}) + BeginAddDay * ?DAY_TIME_COUNT,
			EndTime = util_date:time_tuple_to_unixtime({{OpenY, OpenM, OpenD}, {EndH, EndM, 0}}) + (EndAddDay + BeginAddDay) * ?DAY_TIME_COUNT,
			ShowTime = util_date:time_tuple_to_unixtime({{OpenY, OpenM, OpenD}, {ShowH, ShowM, 0}}) + (ShowAddDay + BeginAddDay) * ?DAY_TIME_COUNT,
			{BeginTime, EndTime, ShowTime, ActiveServiceConf};
		_ ->
			{0, 0, 0, ActiveServiceConf}
	end.

%% 判断活动是否开启
is_open(ActiveServiceType) ->
	{BeginTime, EndTime, _, _} = get_active_time(ActiveServiceType),
	CurtTime = util_date:unixtime(),
	BeginTime < CurtTime andalso CurtTime < EndTime.
%% 判断活动是否显示
is_show(ActiveServiceType) ->
	{_BeginTime, _, ShowTime, _} = get_active_time(ActiveServiceType),
	CurtTime = util_date:unixtime(),
	CurtTime < ShowTime.

%% 判断活动是否已经结束
is_over(ActiveServiceType) ->
	{BeginTime, EndTime, _ShowTime, _} = get_active_time(ActiveServiceType),
	CurtTime = util_date:unixtime(),
	case CurtTime > BeginTime of
		true ->
			EndTime < CurtTime;
		_ ->
			false
	end.

%% 活动幸运转盘开启判断
get_function(FId, CurTime) ->
	case FId of
		?FUNCTION_LOTTERY ->
			{BeginTime, EndTime, _ShowTime, #active_service_merge_type_conf{value = Value}} = get_active_time(?MERGE_ACTIVE_SERVICE_LOTTERY),
			case CurTime > BeginTime andalso EndTime > CurTime of
				true ->
					Data = #db_function{id = FId, group_num = Value, end_time = EndTime, begin_time = BeginTime},
					{true, Data};
				_ ->
					null
			end;
		_ ->
			null
	end.


%% 判断是否有双倍
check_double_exp(PlayerState) ->
	case is_open(?MERGE_ACTIVE_SERVICE_DOUBLE_EXP) of
		true ->
			PlayerState#player_state{is_double_exp = 2};
		_ ->
			PlayerState
	end.
%% 发送给玩家检测双倍经验
check_double_exp() ->
%% 	io:format("active service merge lib :~p~n", [util_date:longunixtime()]),
	PlayerList = player_lib:get_online_players(),
	Fun = fun(EtsOnline) ->
		gen_server2:cast(EtsOnline#ets_online.pid, {update_double_exp})
	end,
	[Fun(X) || X <- PlayerList].


%% 合服后沙巴克首次占领奖励
check_shabake_over() ->
	gen_server2:apply_async(misc:whereis_name({local, active_merge_mod}), {?MODULE, do_check_shabake_over, []}).
%% 合服后沙巴克首次占领奖励
do_check_shabake_over(ActiveState) ->
	Type = ?MERGE_ACTIVE_SERVICE_FRIST_SHABAKE,
	CurTime = util_date:unixtime(),
	case lists:keyfind(Type, #active_time_info.active_type_id, ActiveState#active_merge_state.active_service_type_list) of
		false ->
%% 			?INFO("do_insert_active_record ~p", [111]),
			skip;
		#active_time_info{
			begin_time = BeginTime, end_time = EndTime} ->
			case CurTime > BeginTime andalso CurTime < EndTime of
				true ->
					ActiveServiceConfList = [X || X <- active_service_merge_config:get_list_conf(),
						X#active_service_merge_conf.type =:= Type,
						length(player_active_service_merge_cache:select_all(X#active_service_merge_conf.id)) < 1
					],
					case length(ActiveServiceConfList) > 0 of
						false ->
%% 							?INFO("do_insert_active_record ~p", [2222]),
							skip;
						_ ->
							SceneInfo = city_lib:get_ets_scene_city(?SCENEID_SHABAKE),
							CityInfo = SceneInfo#ets_scene_city.city_info,
							%% 获取帮会的官员信息
							GuildMemberList = [X || X <- guild_cache:get_guild_member_list(CityInfo#db_city_info.guild_id)],
							F = fun(X) ->
								case lists:keyfind(X#db_player_guild.position, #active_service_merge_conf.value, ActiveServiceConfList) of
									false ->
										ActiveServiceConf = lists:keyfind(0, #active_service_merge_conf.value, ActiveServiceConfList),
										active_rank_merge_lib:checke_active_service(X#db_player_guild.player_id, ActiveServiceConf);
									ActiveServiceConf ->
										active_rank_merge_lib:checke_active_service(X#db_player_guild.player_id, ActiveServiceConf)
								end
							end,
							[F(X) || X <- GuildMemberList]
					end;
				_ ->
					skip
			end
	end,
	{ok, ActiveState}.


%% 异步添加和动记录记录
insert_active_record(ActiveServiceType, PlayerState, Num) when is_record(PlayerState, player_state) ->
	#player_state{db_player_base = #db_player_base{lv = Lv}, player_id = PlayerId} = PlayerState,
	insert_active_record(ActiveServiceType, PlayerId, Lv, Num);

insert_active_record(ActiveServiceType, PlayerId, Num) ->
	insert_active_record(ActiveServiceType, PlayerId, 0, Num).
%% 异步添加和动记录记录
insert_active_record(ActiveServiceType, PlayerId, PlayerLv, Num) ->
	gen_server2:apply_async(misc:whereis_name({local, active_merge_mod}), {?MODULE, do_insert_active_record, [ActiveServiceType, PlayerId, PlayerLv, Num]}).

%% 击杀怪物记录
do_insert_active_record(ActiveState, ?MERGE_ACTIVE_SERVICE_TYPE_MONSTER, PlayerId, _PlayerLv, MonsterId) ->
	CurTime = util_date:unixtime(),
	case lists:keyfind(?MERGE_ACTIVE_SERVICE_TYPE_MONSTER, #active_time_info.active_type_id, ActiveState#active_merge_state.active_service_type_list) of
		false ->
			?INFO("do_insert_active_record ~p", [111]),
			skip;
		#active_time_info{begin_time = BeginTime, end_time = EndTime} ->
			case CurTime > BeginTime andalso CurTime < EndTime of
				true ->
					active_merge_ets:save_kill_monster(PlayerId, MonsterId);
				_ ->
					skip
			end
	end,
	{ok, ActiveState};
%% 异步添加和动记录记录
do_insert_active_record(ActiveState, ActiveServiceType, PlayerId, PlayerLv, Num) ->
	CurTime = util_date:unixtime(),
	case lists:keyfind(ActiveServiceType, #active_time_info.active_type_id, ActiveState#active_merge_state.active_service_type_list) of
		false ->
			?INFO("do_insert_active_record ~p", [111]),
			skip;
		#active_time_info{
			active_type_conf = #active_service_merge_type_conf{is_add = IsAdd, value = _MinValue, limit_lv = LimitLv, receive_state = _ReceiveState},
			begin_time = BeginTime, end_time = EndTime} ->
			case CurTime > BeginTime andalso CurTime < EndTime andalso LimitLv =< PlayerLv of
				true ->
					case player_active_service_record_merge_cache:select_row(ActiveServiceType, PlayerId) of
						null ->
							RecordInfo = #db_player_active_service_record_merge{
								player_id = PlayerId,
								active_service_merge_type_id = ActiveServiceType,
								update_time = CurTime,
								value = Num
							},
							player_active_service_record_merge_cache:insert(RecordInfo),
							%% 红点刷新
							ref_button_tips(PlayerId, ActiveServiceType);
						RecordInfo ->
							#db_player_active_service_record_merge{value = OldValue, update_time = OldUpdateTime} = RecordInfo,
							NewValue = case IsAdd of
										   1 ->%% 1 为累加类型
											   OldValue + Num;
										   2 ->%% 2 为时间累加类型
											   {{_OldYear, _OldMonth, OldDay}, {_, _, _}} = util_date:unixtime_to_local_time(OldUpdateTime),
											   {{_NewYear, _NewMonth, NewDay}, {_, _, _}} = util_date:unixtime_to_local_time(CurTime),
											   case OldDay /= NewDay of
												   true ->
													   OldValue + 1;
												   _ ->
													   OldValue
											   end;
										   _ -> %% 0 为替换类型
											   Num
									   end,
							?INFO("~p", [{NewValue, OldValue}]),
							case NewValue /= OldValue of
								true ->
									RecordInfo1 = RecordInfo#db_player_active_service_record_merge{
										value = NewValue,
										update_time = CurTime
									},
									player_active_service_record_merge_cache:update({ActiveServiceType, PlayerId}, RecordInfo1),
									?INFO("~p", [RecordInfo1]),
									%% 红点刷新
									ref_button_tips(PlayerId, ActiveServiceType);
								_ ->
									skip
							end
					end;
				_ ->
					skip
			end
	end,
	{ok, ActiveState}.

%% 获取活动记录的值
get_type_value(PlayerId, Type) ->
	case player_active_service_record_merge_cache:select_row(Type, PlayerId) of
		null ->
			0;
		RecordInfo ->
			RecordInfo#db_player_active_service_record_merge.value
	end.

%% 获取道具列表
get_goods_list(Career, RewardFa, RewardDao, RewardZhan) ->
	case Career of
		?CAREER_FASHI ->
			RewardFa;
		?CAREER_DAOSHI ->
			RewardDao;
		_ ->
			RewardZhan
	end.
