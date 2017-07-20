%%%-------------------------------------------------------------------
%%% @author tuhujia
%%% @copyright (C) 2015, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 10. 十月 2015 14:44
%%%-------------------------------------------------------------------
-module(skill_tree_lib).

-include("common.hrl").
-include("record.hrl").
-include("cache.hrl").
-include("config.hrl").
-include("proto.hrl").
-include("language_config.hrl").
-include("log_type_config.hrl").

%% API
-export([
	learn_skill/3,
  add_skill/3,
  clean_skill/2,
	learn_skill_by_use_goods/3,
	set_skill_keyboard/3,
	clear_skill_keyboard/2,
	active_skill_auto_set/3,
	del_skill_dict/2,
	add_skill_exp/3,
	upgrade_skill/4,
	push_skill_info/2
]).

-define(AUTO_SET_CLOSE, 0).		%% 自动设置开
-define(AUTO_SET_OPEN, 1).		%% 自动设置关

%% ====================================================================
%% API functions
%% ====================================================================

%% 学习技能
learn_skill(PlayerStatus, SkillId, SkillLv) ->
	case check_learn_skill(PlayerStatus, SkillId, SkillLv) of
		{ok, SkillConf} ->
			SkillDict = PlayerStatus#player_state.skill_dict,
			PlayerId = PlayerStatus#player_state.player_id,
			SkillKeyBoard = PlayerStatus#player_state.skill_keyboard,
			{Pos, NewSkillKeyBoard} = get_new_pos(SkillId, SkillDict, SkillKeyBoard),
			case SkillLv =:= 1 of
				true ->
					SkillInfo = #db_skill{
						player_id = PlayerId,
						skill_id = SkillId,
						lv = SkillLv,
						exp = 0,
						pos = Pos,
						auto_set = 0,
						next_time = 0
					},

					SkillType = SkillConf#skill_tree_conf.type,
					PasList = PlayerStatus#player_state.pass_trigger_skill_list,
					NewPasList = case SkillType of
									 ?SKILL_TYPE_PASSIVITY ->
										 lists:keystore(SkillId, 1, PasList, {SkillId, SkillLv});
									 _ ->
										 PasList
								 end,
%% 					OSL = PlayerStatus#player_state.order_skill_list,
%% 					OSL1 = lists:append(OSL, [SkillId]),

					skill_cache:insert(SkillInfo),
					NewSkillDict = update_skill_dict(SkillId, SkillInfo, SkillDict),
					%% 推送
					push_skill_info(PlayerStatus, SkillInfo),
					PlayerStatus1 = PlayerStatus#player_state{skill_dict = NewSkillDict, pass_trigger_skill_list = NewPasList, skill_keyboard = NewSkillKeyBoard},

					%% 扣除道具
					GoodsId1 = SkillConf#skill_tree_conf.goods_1,
					Num1 = SkillConf#skill_tree_conf.num_1,
					{ok, PlayerStatus2} = goods_lib_log:delete_goods_by_num(PlayerStatus1, GoodsId1, Num1, ?LOG_TYPE_SKILL_UPGRADE),

					%% 设置类型为1 2的技能自动设置
					AutoType = SkillConf#skill_tree_conf.auto_type,
					case AutoType =/= 0 of
						true ->
							case active_skill_auto_set(PlayerStatus2, SkillId, ?AUTO_SET_OPEN) of
								{ok, PlayerStatus3} ->
									DbBase = PlayerStatus3#player_state.db_player_base,
									PlayerState4 = PlayerStatus3#player_state{db_player_base = DbBase#db_player_base{skill_set = 1}},
									net_send:send_to_client(PlayerState4#player_state.socket, 12008, #rep_set_group_switch{type = 1}),
									{ok, PlayerState4};
								_D ->
									{ok, PlayerStatus2}
							end;
						false ->
							{ok, PlayerStatus1}
					end;
				false ->
					SkillType = SkillConf#skill_tree_conf.type,
					PasList = PlayerStatus#player_state.pass_trigger_skill_list,
					NewPasList = case SkillType of
									 ?SKILL_TYPE_PASSIVITY ->
										 lists:keystore(SkillId, 1, PasList, {SkillId, SkillLv});
									 _ ->
										 PasList
								 end,
					SkillInfo = skill_base_lib:get_skill_info(SkillDict, SkillId),
					SkillInfo1 = SkillInfo#db_skill{lv = SkillLv},

					skill_cache:update({PlayerId, SkillId}, SkillInfo1),
					NewSkillDict = update_skill_dict(SkillId, SkillInfo1, SkillDict),

					%% 扣除道具
					GoodsId1 = SkillConf#skill_tree_conf.goods_1,
					Num1 = SkillConf#skill_tree_conf.num_1,
					{ok, PlayerStatus1} = goods_lib_log:delete_goods_by_num(PlayerStatus, GoodsId1, Num1, ?LOG_TYPE_SKILL_UPGRADE),
					%% 推送
					push_skill_info(PlayerStatus1, SkillInfo1),
					{ok, PlayerStatus1#player_state{skill_dict = NewSkillDict, pass_trigger_skill_list = NewPasList}}
			end;
		{fail, Reply} ->
			{fail, Reply}
	end.

%% 戒指加技能
add_skill(PlayerStatus ,SkillId, SkillLv) ->
	PlayerId = PlayerStatus#player_state.player_id,
	SkillDict = PlayerStatus#player_state.skill_dict,
	PasList = PlayerStatus#player_state.pass_trigger_skill_list,
	SkillInfo = #db_skill{
		player_id = PlayerId,
		skill_id = SkillId,
		lv = SkillLv,
		exp = 0,
		pos = 5,
		auto_set = 0,
		next_time = 0
	},
%% 	io:format("insert skill info:~p~n",[SkillInfo]),
	skill_cache:insert(SkillInfo),
	NewSkillDict = update_skill_dict(SkillId, SkillInfo, SkillDict),
	NewPasList = lists:keystore(SkillId, 1, PasList, {SkillId, SkillLv}),
	push_skill_info(PlayerStatus, SkillInfo),
	PlayerStatus1 = PlayerStatus#player_state{skill_dict = NewSkillDict, pass_trigger_skill_list = NewPasList},
	{ok, PlayerStatus1}.


%% @doc 脱掉戒指
clean_skill(PlayerStatus, SkillId) ->
	PlayerId = PlayerStatus#player_state.player_id,
	SkillDict = PlayerStatus#player_state.skill_dict,
	SkillInfo = skill_base_lib:get_skill_info(SkillDict, SkillId),
	PasList = PlayerStatus#player_state.pass_trigger_skill_list,
	NewPasList = lists:keydelete(SkillId, 1, PasList),
	skill_cache:delete({PlayerId, SkillId}),
	NewSkillDict = dict:erase(SkillId, SkillDict),
%% 	io:format("clean skill :~p~n", [{SkillDict, NewSkillDict}]),
	%% 推送
	push_skill_info(PlayerStatus, SkillInfo#db_skill{pos=0, auto_set=0}),
	PlayerStatus1 = PlayerStatus#player_state{skill_dict = NewSkillDict, pass_trigger_skill_list = NewPasList},
	{ok, PlayerStatus1}.



learn_skill_by_use_goods(PlayerStatus, SkillId, SkillLv) ->
	SkillDict = PlayerStatus#player_state.skill_dict,
	case skill_base_lib:get_skill_info(SkillDict, SkillId) of
		null ->       %% 1级技能激活检测
			case check_learn_skill(PlayerStatus, SkillId, SkillLv) of
				{ok, SkillConf} ->
					SkillDict = PlayerStatus#player_state.skill_dict,
					PlayerId = PlayerStatus#player_state.player_id,
					SkillKeyBoard = PlayerStatus#player_state.skill_keyboard,
					{Pos, NewSkillKeyBoard} = get_new_pos(SkillId, SkillDict, SkillKeyBoard),
					case SkillLv =:= 1 of
						true ->
							SkillInfo = #db_skill{
								player_id = PlayerId,
								skill_id = SkillId,
								lv = SkillLv,
								exp = 0,
								pos = Pos,
								auto_set = 0,
								next_time = 0
							},

							SkillType = SkillConf#skill_tree_conf.type,
							PasList = PlayerStatus#player_state.pass_trigger_skill_list,
							NewPasList = case SkillType of
											 ?SKILL_TYPE_PASSIVITY ->
												 lists:keystore(SkillId, 1, PasList, {SkillId, SkillLv});
											 _ ->
												 PasList
										 end,
		%% 					OSL = PlayerStatus#player_state.order_skill_list,
		%% 					OSL1 = lists:append(OSL, [SkillId]),

							skill_cache:insert(SkillInfo),
							NewSkillDict = update_skill_dict(SkillId, SkillInfo, SkillDict),
							%% 推送
							push_skill_info(PlayerStatus, SkillInfo),
							PlayerStatus1 = PlayerStatus#player_state{skill_dict = NewSkillDict, pass_trigger_skill_list = NewPasList, skill_keyboard = NewSkillKeyBoard},

							%% 设置类型为1 2的技能自动设置
							AutoType = SkillConf#skill_tree_conf.auto_type,
							case AutoType =/= 0 of
								true ->
									case active_skill_auto_set(PlayerStatus1, SkillId, ?AUTO_SET_OPEN) of
										{ok, PlayerStatus2} ->
											DbBase = PlayerStatus2#player_state.db_player_base,
											PlayerState3 = PlayerStatus2#player_state{db_player_base = DbBase#db_player_base{skill_set = 1}},
											net_send:send_to_client(PlayerState3#player_state.socket, 12008, #rep_set_group_switch{type = 1}),
											{ok, PlayerState3};
										_D ->
											{ok, PlayerStatus1}
									end;
								false ->
									{ok, PlayerStatus1}
							end;
						false ->
							SkillType = SkillConf#skill_tree_conf.type,
							PasList = PlayerStatus#player_state.pass_trigger_skill_list,
							NewPasList = case SkillType of
											 ?SKILL_TYPE_PASSIVITY ->
												 lists:keystore(SkillId, 1, PasList, {SkillId, SkillLv});
											 _ ->
												 PasList
										 end,
							SkillInfo = skill_base_lib:get_skill_info(SkillDict, SkillId),
							SkillInfo1 = SkillInfo#db_skill{lv = SkillLv},

							skill_cache:update({PlayerId, SkillId}, SkillInfo1),
							NewSkillDict = update_skill_dict(SkillId, SkillInfo1, SkillDict),
							%% 推送
							push_skill_info(PlayerStatus, SkillInfo1),
							{ok, PlayerStatus#player_state{skill_dict = NewSkillDict, pass_trigger_skill_list = NewPasList}}
					end;
				{fail, Reply} ->
					{fail, Reply}
			end;
		_ ->
			{fail, ?ERR_SKILL_ALREADY_LEARN}
	end.

check_learn_skill(PlayerStatus, SkillId, SkillLv) ->
	PlayerBase = PlayerStatus#player_state.db_player_base,
	SkillConf = get_skill_conf(SkillId, SkillLv),
	case util:loop_functions(
		none,
		[fun(_)
			->
			case is_record(SkillConf, skill_tree_conf) of
				true ->
					{continue, none};
				false ->
					{break, ?ERR_SKILL_NOT_EXIST}
			end
		end,
		fun(_) ->
			case SkillConf#skill_tree_conf.career =:= PlayerBase#db_player_base.career of
				true ->
					{continue, none};
				false ->
					{break, ?ERR_PLAYER_CAREER_LIMIT}
			end
		end,
		fun(_) ->
			case SkillConf#skill_tree_conf.limit_lv =< PlayerBase#db_player_base.lv of
				true ->
					{continue, none};
				false ->
					{break, ?ERR_PLAYER_LV_NOT_ENOUGH}
			end
		end,
		fun(_) ->
			GoodsId1 = SkillConf#skill_tree_conf.goods_1,
			Num1 = SkillConf#skill_tree_conf.num_1,
			case goods_lib:get_goods_num(GoodsId1) >= Num1 of
				true ->
					{continue, none};
				false ->
					{break, ?ERR_GOODS_NOT_ENOUGH}
			end
		end,
		fun(_) ->
			SkillDict = PlayerStatus#player_state.skill_dict,
			case skill_base_lib:get_skill_info(SkillDict, SkillId) of
				null ->       %% 1级技能激活检测
					case SkillLv =:= 1 of
						true ->
							{continue, SkillConf};
						false ->
							{break, ?ERR_SKILL_NOT_LEARN}
					end;
				SkillInfo ->  %% 技能升级检测
					case SkillInfo#db_skill.lv =:= 3 of
						true ->
							{continue, SkillConf};
						false ->
							{break, ?ERR_SKILL_ALREADY_LEARN}
					end
			end
		end
		]) of
		{break, Reply} -> {fail, Reply};
		{ok, Value} ->
			{ok, Value}
	end.

%% 技能设置快捷键
set_skill_keyboard(PlayerStats, SkillId, Pos) when Pos > 0 andalso Pos < 10 ->
	SkillDict = SkillDict = PlayerStats#player_state.skill_dict,
	case skill_base_lib:get_skill_info(SkillDict, SkillId) of
		null ->
			{fail, ?ERR_SKILL_NOT_EXIST};
		SkillInfo ->  %% 技能升级检测
			set_skill_keyboard_1(PlayerStats, SkillInfo, Pos)
	end.

set_skill_keyboard_1(PlayerStats, SkillInfo, Pos) ->
	case SkillInfo#db_skill.pos =:= Pos of
		true ->
			{ok, PlayerStats};
		false ->
			set_skill_keyboard_2(PlayerStats, SkillInfo, Pos)
	end.

set_skill_keyboard_2(PlayerStats, SkillInfo, Pos) ->
	SkillKeyBoard = PlayerStats#player_state.skill_keyboard,
	SkillId = SkillInfo#db_skill.skill_id,
	case lists:keyfind(SkillId, 2, SkillKeyBoard) of
		false ->
			set_skill_keyboard_3(PlayerStats, SkillInfo, Pos);
		true ->
			{fail, ?ERR_COMMON_FAIL}
	end.

set_skill_keyboard_3(PlayerStats, SkillInfo, Pos) ->
	SkillKeyBoard = PlayerStats#player_state.skill_keyboard,
	PlayerId = PlayerStats#player_state.player_id,
	SkillId = SkillInfo#db_skill.skill_id,
	SkillDict = PlayerStats#player_state.skill_dict,
	case lists:keyfind(Pos, 1, SkillKeyBoard) of
		{_, OldSkillId} ->  %% 技能替换位置
			OldSkillInfo = skill_base_lib:get_skill_info(SkillDict, OldSkillId),
			SkillInfo1 = SkillInfo#db_skill{pos = Pos},
			OldSkillInfo1 = OldSkillInfo#db_skill{pos = 0},

			skill_cache:update({PlayerId, SkillId}, SkillInfo1),
			skill_cache:update({PlayerId, OldSkillId}, OldSkillInfo1),

			NewSkillDict = update_skill_dict(SkillId, SkillInfo1, SkillDict),
			NewSkillDict1 = update_skill_dict(OldSkillId, OldSkillInfo1, NewSkillDict),

			NewSkillKeyBoard = lists:keystore(Pos, 1, SkillKeyBoard, {Pos, SkillId}),
			NewSkillKeyBoard1 = lists:delete({Pos, OldSkillId}, NewSkillKeyBoard),

			%% 推送
			push_skill_info(PlayerStats, SkillInfo1),
			push_skill_info(PlayerStats, OldSkillInfo1),
			{ok, PlayerStats#player_state{skill_dict = NewSkillDict1, skill_keyboard = NewSkillKeyBoard1}};
		_ ->                %% 新增快捷按键
			SkillInfo1 = SkillInfo#db_skill{pos = Pos},
			skill_cache:update({PlayerId, SkillId}, SkillInfo1),
			NewSkillDict = update_skill_dict(SkillId, SkillInfo1, SkillDict),
			NewSkillKeyBoard = lists:keystore(SkillId, 2, SkillKeyBoard, {Pos, SkillId}),
			%% 推送
			push_skill_info(PlayerStats, SkillInfo1),
			{ok, PlayerStats#player_state{skill_dict = NewSkillDict, skill_keyboard = NewSkillKeyBoard}}
	end.

%% 清除技能快捷键
clear_skill_keyboard(PlayerStats, SkillId) ->
	SkillKeyBoard = PlayerStats#player_state.skill_keyboard,
	case lists:keyfind(SkillId, 2, SkillKeyBoard) of
		{Pos, _SkillId} ->
			PlayerId = PlayerStats#player_state.player_id,
			SkillDict = PlayerStats#player_state.skill_dict,
			SkillInfo = skill_base_lib:get_skill_info(SkillDict, SkillId),
			SkillInfo1 = SkillInfo#db_skill{pos = 0},
			NewSkillDict = update_skill_dict(SkillId, SkillInfo1, SkillDict),
			NewSkillKeyBoard = lists:delete({Pos, SkillId}, SkillKeyBoard),
			%% 推送
			skill_cache:update({PlayerId, SkillId}, SkillInfo1),
			push_skill_info(PlayerStats, SkillInfo1),
			{ok, PlayerStats#player_state{skill_dict = NewSkillDict, skill_keyboard = NewSkillKeyBoard}};
		_ ->
			{fail, ?ERR_SKILL_NOT_SET_KEYBOARD}
	end.

%% 激活技能快捷键
active_skill_auto_set(PlayerStats, SkillId, AutoType) ->
	SkillDict = SkillDict = PlayerStats#player_state.skill_dict,
	case skill_base_lib:get_skill_info(SkillDict, SkillId) of
		null ->
			{fail, ?ERR_SKILL_NOT_EXIST};
		SkillInfo ->
			active_skill_auto_set_1(PlayerStats, SkillInfo, AutoType)
	end.

active_skill_auto_set_1(PlayerStats, SkillInfo, Switch) when Switch =:= ?AUTO_SET_CLOSE
														orelse Switch =:= ?AUTO_SET_OPEN ->
	SkillId = SkillInfo#db_skill.skill_id,
	SkillConf = get_skill_conf(SkillId, 1),
	Type = SkillConf#skill_tree_conf.auto_type,
	case SkillConf#skill_tree_conf.auto_type of
		1 ->
			active_skill_auto_set_2(PlayerStats, SkillInfo, Type, Switch);
		2 ->
			active_skill_auto_set_2(PlayerStats, SkillInfo, Type, Switch);
		3 ->
			active_skill_auto_set_3(PlayerStats, SkillInfo, Switch);
		4->
			active_skill_auto_set_3(PlayerStats, SkillInfo, Switch);
		_ ->
			{fail, ?ERR_SKILL_NOT_ACTIVE}
	end.

active_skill_auto_set_2(PlayerStats, SkillInfo, _Type, ?AUTO_SET_CLOSE) ->
	OrderSkillList = PlayerStats#player_state.order_skill_list,
	PlayerId = PlayerStats#player_state.player_id,
	SkillId = SkillInfo#db_skill.skill_id,
	SkillDict = PlayerStats#player_state.skill_dict,
	case lists:member(SkillId, OrderSkillList) of
		true ->
			SkillInfo1 = SkillInfo#db_skill{auto_set = ?AUTO_SET_CLOSE},
			skill_cache:update({PlayerId, SkillId}, SkillInfo1),
			NewSkillDict = update_skill_dict(SkillId, SkillInfo1, SkillDict),
			NewOrderSkillList = lists:delete(SkillId, OrderSkillList),
			%% 推送
			push_skill_info(PlayerStats, SkillInfo1),
			{ok, PlayerStats#player_state{skill_dict = NewSkillDict, order_skill_list = NewOrderSkillList}};
		false ->
			{fail, ?ERR_COMMON_FAIL}
	end;
active_skill_auto_set_2(PlayerStats, SkillInfo, Type, ?AUTO_SET_OPEN) ->
	OrderSkillList = PlayerStats#player_state.order_skill_list,
	PlayerId = PlayerStats#player_state.player_id,
	SkillId = SkillInfo#db_skill.skill_id,
	SkillDict = PlayerStats#player_state.skill_dict,
	case check_old_auto_skill(Type, OrderSkillList) of
		{ok, OldSkillId} ->
			OldSkillInfo = skill_base_lib:get_skill_info(SkillDict, OldSkillId),
			SkillInfo1 = SkillInfo#db_skill{auto_set = ?AUTO_SET_OPEN},
			OldSkillInfo1 = OldSkillInfo#db_skill{auto_set = ?AUTO_SET_CLOSE},

			skill_cache:update({PlayerId, SkillId}, SkillInfo1),
			skill_cache:update({PlayerId, OldSkillId}, OldSkillInfo1),

			NewSkillDict = update_skill_dict(SkillId, SkillInfo1, SkillDict),
			NewSkillDict1 = update_skill_dict(OldSkillId, OldSkillInfo1, NewSkillDict),

			NewOrderSkillList = lists:delete(OldSkillId, OrderSkillList),
			NewOrderSkillList1 = lists:append(NewOrderSkillList, [SkillId]),

			%% 推送
			push_skill_info(PlayerStats, SkillInfo1),
			push_skill_info(PlayerStats, OldSkillInfo1),
			{ok, PlayerStats#player_state{skill_dict = NewSkillDict1, order_skill_list = NewOrderSkillList1}};
		_ ->
			SkillInfo1 = SkillInfo#db_skill{auto_set = ?AUTO_SET_OPEN},
			skill_cache:update({PlayerId, SkillId}, SkillInfo1),
			NewSkillDict = update_skill_dict(SkillId, SkillInfo1, SkillDict),
			NewOrderSkillList = lists:append(OrderSkillList, [SkillId]),
			%% 推送
			push_skill_info(PlayerStats, SkillInfo1),
			{ok, PlayerStats#player_state{skill_dict = NewSkillDict, order_skill_list = NewOrderSkillList}}
	end.

active_skill_auto_set_3(PlayerStats, SkillInfo, Switch) ->
	OrderSkillList = PlayerStats#player_state.order_skill_list,
	PlayerId = PlayerStats#player_state.player_id,
	SkillId = SkillInfo#db_skill.skill_id,
	SkillDict = PlayerStats#player_state.skill_dict,

	SkillInfo1 = SkillInfo#db_skill{auto_set = Switch},
	skill_cache:update({PlayerId, SkillId}, SkillInfo1),
	NewSkillDict = update_skill_dict(SkillId, SkillInfo1, SkillDict),
	NewOrderSkillList =
		case Switch of
			?AUTO_SET_CLOSE ->
				lists:delete(SkillId, OrderSkillList);
			?AUTO_SET_OPEN ->
				case lists:member(SkillId, OrderSkillList) of
					true ->
						OrderSkillList;
					false ->
						lists:append(OrderSkillList, [SkillId])
				end
		end,

	%% 推送
	push_skill_info(PlayerStats, SkillInfo1),
	{ok, PlayerStats#player_state{skill_dict = NewSkillDict, order_skill_list = NewOrderSkillList}}.

check_old_auto_skill(_Type, []) ->
	0;
check_old_auto_skill(Type, [SkillId|T]) ->
	SkillConf = get_skill_conf(SkillId, 1),
	case SkillConf#skill_tree_conf.auto_type =:= Type of
		true ->
			{ok, SkillId};
		false ->
			check_old_auto_skill(Type, T)
	end.


%% 获取技能配置
get_skill_conf(SkillId, SkillLv) ->
	skill_tree_config:get({SkillId, SkillLv}).

%% 更新技能dict 返回新的dict
update_skill_dict(SkillId, NewSkill, SkillDict) ->
	dict:store(SkillId, NewSkill, SkillDict).

%%
del_skill_dict(SkillId, SkillDict) ->
	dict:erase(SkillId, SkillDict).

%% 推送技能变更信息
push_skill_info(PlayerState, SkillInfo) ->
	ProtoSkill = #proto_skill{
		skill_id = SkillInfo#db_skill.skill_id,
		lv = SkillInfo#db_skill.lv,
		exp = SkillInfo#db_skill.exp,
		pos = SkillInfo#db_skill.pos,
		auto_set = SkillInfo#db_skill.auto_set
	},
	net_send:send_to_client(PlayerState#player_state.socket, 12003, #rep_skill_info{skill_info = ProtoSkill}).

%% 增加技能熟练度
add_skill_exp(PlayerStatus, SkillId, ExpValue) ->
	SkillDict = PlayerStatus#player_state.skill_dict,
	SkillInfo = skill_base_lib:get_skill_info(SkillDict, SkillId),
	SkillLv = SkillInfo#db_skill.lv,
	SkillConf = get_skill_conf(SkillId, SkillLv),
	NextExp = SkillConf#skill_tree_conf.next_exp,
	LimitLv = SkillConf#skill_tree_conf.limit_lv,
	DbBase = PlayerStatus#player_state.db_player_base,
	PlayerLv = DbBase#db_player_base.lv,

	case NextExp == 0 orelse LimitLv > PlayerLv of
		false ->
			Exp = SkillInfo#db_skill.exp,
			NextExp = SkillConf#skill_tree_conf.next_exp,
			PlayerId = PlayerStatus#player_state.player_id,

			SkillConf2 = get_skill_conf(SkillId, SkillLv + 1),
			case Exp + ExpValue >= NextExp andalso PlayerLv >= SkillConf2#skill_tree_conf.limit_lv of
				true ->
					SkillInfo1 = SkillInfo#db_skill{lv = SkillLv + 1, exp = 0},
					SkillType = SkillConf#skill_tree_conf.type,
					PasList = PlayerStatus#player_state.pass_trigger_skill_list,
					NewPasList = case SkillType of
									 ?SKILL_TYPE_PASSIVITY ->
										 lists:keystore(SkillId, 1, PasList, {SkillId, SkillLv});
									 _ ->
										 PasList
								 end,

					skill_cache:update({PlayerId, SkillId}, SkillInfo1),
					NewSkillDict = update_skill_dict(SkillId, SkillInfo1, SkillDict),
					%% 推送
					push_skill_info(PlayerStatus, SkillInfo1),
					Updata = #player_state{skill_dict = NewSkillDict, pass_trigger_skill_list = NewPasList},
					player_lib:update_player_state(PlayerStatus, Updata);
				false ->
					case Exp + ExpValue > NextExp of
						true ->
							{ok, PlayerStatus};
						false ->
							SkillInfo1 = SkillInfo#db_skill{exp = Exp + ExpValue},
							skill_cache:update({PlayerId, SkillId}, SkillInfo1),
							NewSkillDict = update_skill_dict(SkillId, SkillInfo1, SkillDict),
							push_skill_info(PlayerStatus, SkillInfo1),
							{ok, PlayerStatus#player_state{skill_dict = NewSkillDict}}
					end
			end;
		true ->
			{ok, PlayerStatus}
	end.

%% 升级技能
upgrade_skill(PlayerStatus, SkillId, GoodsId, Num) when Num > 0 ->
	case check_upgrade_skill(PlayerStatus, SkillId, GoodsId, Num) of
		{ok, AddExp} ->
			goods_lib_log:delete_goods_by_num(PlayerStatus, GoodsId, Num, ?LOG_TYPE_SKILL_UPGRADE),
			add_skill_exp(PlayerStatus, SkillId, AddExp);
		{fail, Reply} ->
			{fail, Reply}
	end.

check_upgrade_skill(PlayerStatus, SkillId, GoodsId, Num) ->
	SkillDict = PlayerStatus#player_state.skill_dict,
	SkillInfo = skill_base_lib:get_skill_info(SkillDict, SkillId),
	SkillLv = SkillInfo#db_skill.lv,
	SkillConf = get_skill_conf(SkillId, SkillLv),

	case util:loop_functions(
		none,
		[fun(_)
			->
			NextExp = SkillConf#skill_tree_conf.next_exp,
			case NextExp == 0 of
				false ->
					{continue, none};
				true ->
					{break, ?ERR_COMMON_FAIL}
			end
		end,
		fun(_) ->
			LimitLv = SkillConf#skill_tree_conf.limit_lv,
			DbBase = PlayerStatus#player_state.db_player_base,
			PlayerLv = DbBase#db_player_base.lv,
			case PlayerLv >= LimitLv of
				true ->
					{continue, none};
				false ->
					{break, ?ERR_PLAYER_LV_NOT_ENOUGH}
			end
		end,
		fun(_) ->
			GoodsConf = goods_lib:get_goods_conf_by_id(GoodsId),
			case GoodsConf#goods_conf.extra of
				[{skill_exp, Exp}] ->
					{continue, Exp * Num};
				_ ->
					{break, ?ERR_GOODS_NOT_ENOUGH}
			end
		end,
		fun(AddExp) ->
			case goods_lib:get_goods_num(GoodsId) >= Num of
				true ->
					{continue, AddExp};
				false ->
					{break, ?ERR_GOODS_NOT_ENOUGH}
			end
		end
		]) of
		{break, Reply} -> {fail, Reply};
		{ok, Value} ->
			{ok, Value}
	end.

%% 获取技能设置位置
get_new_pos(SkillId, SkillDict, SkillKeyBoard) ->
	SkillConf = get_skill_conf(SkillId, 1),
	case SkillConf#skill_tree_conf.type of
		?SKILL_TYPE_DRIVING ->
			Fun = fun(_SkillId, DbSKill, Acc) ->
				lists:delete(DbSKill#db_skill.pos, Acc)
			end,

			case dict:fold(Fun, [1, 2, 3], SkillDict) of
				[] -> {0, SkillKeyBoard};
				[H|_] -> {H, [{H, SkillId}] ++ SkillKeyBoard}
			end;
		_ ->
			{0, SkillKeyBoard}
	end.




