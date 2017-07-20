%%%-------------------------------------------------------------------
%%% @author yubing
%%% @copyright (C) 2015, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 08. 十二月 2015 10:27
%%%-------------------------------------------------------------------
-module(set_pp).

-export([handle/3]).

-include("cache.hrl").
-include("proto.hrl").
-include("common.hrl").
-include("record.hrl").
-include("config.hrl").
-include("log_type_config.hrl").
%% 设置自动回蓝
handle(22000, PlayerState, Data) ->
	?INFO(" 22000 : ~p ", [Data]),
	HpSet = Data#req_set_hpmp.hp_set,
	HpMpSet = Data#req_set_hpmp.hpmp_set,
	set_lib:update_player_hpmp(PlayerState, HpSet, HpMpSet);

%% 设置自动拾取
handle(22001, PlayerState, Data) ->
	?INFO(" 22000 : ~p ", [Data]),
	PickupSet = Data#req_set_pickup_sell.pickup_set,
	set_lib:update_player_pickup_sell(PlayerState, PickupSet);

%% 设置 激活码使用
handle(22002, PlayerState, Data1) ->
%%     case PlayerState#player_state.open_id of
%%         <<"aidan">> ->
%%             ?ERR("~p", [PlayerState#player_state.open_id]);
%%         _ ->
%%             skip
%%     end,
	case config:get_server_no() < 1000 orelse PlayerState#player_state.is_robot =:= 1 of
		true ->
			try
				Content = Data1#req_use_code.code,
				?ERR("18001: ~ts", [Content]),
				Team = erlang:binary_to_list(Content),
				Data = string:tokens(Team, " "),
				[T | H] = Data,
				case T of
					"task" ->
						[T1 | _H1] = H,
						task_test:task_jump(PlayerState, list_to_integer(T1));
					"taskok" ->
						[T1 | _H1] = H,
						task_test:task_finish(PlayerState, list_to_integer(T1));
					"exp" ->
						[T1 | _H1] = H,
						player_lib:add_exp(PlayerState, list_to_integer(T1), {?LOG_TYPE_GM, []});
					"vip" ->
						[T1 | _H1] = H,
						PlayerState1 = vip_lib:add_vip_exp(PlayerState, list_to_integer(T1)),
						{ok, PlayerState1};
					"month" ->
						ChargeConf = charge_config:get(1),
						charge_lib:bug_charge_month(PlayerState#player_state.player_id, ChargeConf),
						{ok, PlayerState};
					"skill" ->
						[T1 | _H1] = H,
						case game_tool:learm_one_skill(PlayerState, list_to_integer(T1)) of
							{ok, PlayerState1} ->
								{ok, PlayerState1};
							_ ->
								{ok, PlayerState}
						end;
					"skillall" ->
						game_tool:learm_all_skill(PlayerState);
					"1031" ->
						[T1 | _H1] = H,
						scene_pp:handle(11031, PlayerState, #req_quick_change_scene{scene_id = list_to_integer(T1)});
					"update" ->
						[T1 | H1] = H,
						[T2 | _H2] = H1,
						yu_test:update_name(list_to_integer(T1), T2),
						{ok, PlayerState};
					"money" ->
						[T1 | _H1] = H,
						{ok, PlayerState1} = player_lib:incval_on_player_money_log(PlayerState, #db_player_money.jade, list_to_integer(T1), ?LOG_TYPE_GM),
						player_lib:incval_on_player_money_log(PlayerState1, #db_player_money.coin, list_to_integer(T1) * 10, ?LOG_TYPE_GM);
					"delgamemoney" ->
						[T1 | _H1] = H,
						player_lib:incval_on_player_money_log(PlayerState, #db_player_money.coin, -list_to_integer(T1) * 100000, ?LOG_TYPE_GM);
					"sellgoods" ->
						[T1 | H1] = H,
						GoodsId = list_to_integer(T1),
						goods_lib:delete_goods_by_num(PlayerState, GoodsId, 1),
						log_lib:log_goods_change(PlayerState, GoodsId, 1, ?LOG_TYPE_GM),
						{ok, PlayerState};
					"stop" ->
						scene_tool:stop_scene(PlayerState#player_state.scene_pid),
						{ok, PlayerState};
					"stopall" ->
						scene_tool:stop_scene_all(scene_pid),
						{ok, PlayerState};
					"start" ->
						scene_mgr_lib:create_scene(PlayerState#player_state.scene_id),
						{ok, PlayerState};
					"ac" ->
%%                         [T1 | _H1] = H,
						%% 副本通关后继续留在副本中
						scene_pp:handle(11053, PlayerState, #req_guise_list{top = 20}),
						{ok, PlayerState};
					"goods" ->
						[T1 | _H1] = H,

						GoodsConf = try
										lists:keyfind(list_to_integer(T1), #goods_conf.id, goods_config:get_list_conf())
									catch
										_:_ ->
											lists:keyfind(T1, #goods_conf.name, goods_config:get_list_conf())
									end,
						Num = case length(Data) > 2 of
								  true ->
									  [T2 | _H2] = _H1,
									  list_to_integer(T2);
								  _ ->
									  1
							  end,

						?INFO("1111", [22222]),
						case GoodsConf#goods_conf.type =:= ?GOODS_TYPE_EQUIPS of
							true ->
								EquipsList = goods_dict:get_player_equips_list(),
								case lists:keymember(GoodsConf#goods_conf.id, #db_goods.goods_id, EquipsList) of
									true ->
										skip;
									_ ->
										goods_lib_log:add_goods(PlayerState, GoodsConf#goods_conf.id, 1, Num, ?LOG_TYPE_GM)
								end;
							_ ->
								goods_lib_log:add_goods(PlayerState, GoodsConf#goods_conf.id, 1, Num, ?LOG_TYPE_GM)
						end,
						{ok, PlayerState};
					"delete" ->
						game_tool:delete_wing(PlayerState);
				%%?INFO("123456 ~ts",[#db_player_money.coin]);
					"hh" ->
						GoodsCOnf = hook_lib:compute_hook_gain(PlayerState, 60),
						%%set_lib:use_code(PlayerState,"FAC98C49A3F9256");
						%%List = player_task_dict:get_player_task_list(),
						%%?INFO("list1111 ~p",[List]);
						?INFO("hh ~p", [GoodsCOnf]),
						{ok, PlayerState};
					"tt" ->
						transaction_pp:handle(20005, PlayerState, #req_trade_info{jade = -9999999999999});
				%%active_task_lib:ref_player_task_list(PlayerState#player_state.player_id);
					_ ->
						?INFO(" 22002 : ~p ", [Data1]),
						Code = erlang:binary_to_list(Data1#req_use_code.code),
						{ok, PlayerState1, Result} = set_lib:use_code(PlayerState, Code),
						net_send:send_to_client(PlayerState#player_state.socket, 22002, #rep_use_code{result = Result}),
						{ok, PlayerState1}
				end
			catch
				Error:Info ->
					?ERR("~p:~p, stacktrace:~p~n", [Error, Info, erlang:get_stacktrace()])
			end;
		_ ->
			?INFO(" 22002 : ~p ", [Data1]),
			Code = erlang:binary_to_list(Data1#req_use_code.code),
			{ok, PlayerState1, Result} = set_lib:use_code(PlayerState, Code),
			net_send:send_to_client(PlayerState#player_state.socket, 22002, #rep_use_code{result = Result}),
			{ok, PlayerState1}
	end;


%% 设置 装备出售
handle(22003, PlayerState, Data) ->
	?INFO(" 22004 : ~p ", [Data]),
	EquipSellSet = Data#req_set_equip_sell.equip_sell_set,
	set_lib:update_player_equip_sell(PlayerState, EquipSellSet);

%%boss刷新关注列表
handle(22004, PlayerState, _Data) ->
	player_monster_follow_lib:follow_list(PlayerState);

%%boss刷新关注或取消
handle(22005, PlayerState, Data) ->
	#req_monster_follow_action{scene_id = SceneId, monster_id = MonsterId, action = Action} = Data,
	player_monster_follow_lib:follow_action(PlayerState, SceneId, MonsterId, Action);


handle(Cmd, PlayerState, Data) ->
	?ERR("not define ~p cmd:~nstate: ~p~ndata: ~p", [Cmd, PlayerState, Data]),
	{ok, PlayerState}.

