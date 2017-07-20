%%%-------------------------------------------------------------------
%%% @author zhengsiying
%%% @copyright (C) 2015, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 19. 八月 2015 下午3:21
%%%-------------------------------------------------------------------
-module(skill_pp).

-include("common.hrl").
-include("record.hrl").
-include("proto.hrl").
-include("cache.hrl").
-include("language_config.hrl").

%% API
-export([
	handle/3
]).

-define(MAX_ATK_NUM, 2).

%% ====================================================================
%% API functions
%% ====================================================================
%% 获取玩家已学技能列表
handle(12001, PlayerState, _) ->
	?INFO("recv 12001 =========", []),
	SkillDict = PlayerState#player_state.skill_dict,
	F = fun(_K, V, Acc) ->
		ProtoSkill = #proto_skill{
			skill_id = V#db_skill.skill_id,
			lv = V#db_skill.lv,
			exp = V#db_skill.exp,
			pos = V#db_skill.pos,
			auto_set = V#db_skill.auto_set
		},
		[ProtoSkill | Acc]
	end,
	SkillList = dict:fold(F, [], SkillDict),
	net_send:send_to_client(PlayerState#player_state.socket, 12001, #rep_skill_list{skill_list = SkillList});
%% 释放技能
handle(12002, PlayerState, Data) ->
	?INFO("12002 ~p", [Data]),
	case PlayerState#player_state.atk_num > ?MAX_ATK_NUM of
		true ->
			?ERR("111KK ~p", [22]),
%% 			player_lib:kick_player(PlayerState, ?ERR_ACCOUNT_ERR);
			Base = PlayerState#player_state.db_player_base,
			player_id_name_lib:add_user_plug(PlayerState#player_state.player_id, PlayerState#player_state.open_id, Base#db_player_base.name, Base#db_player_base.vip, PlayerState#player_state.atk_num);
		_ ->
			PlayerState1 = PlayerState#player_state{
				atk_num = PlayerState#player_state.atk_num + 1
			},
			CurTime = util_date:unixtime(),
			PlayerState2 = case PlayerState1#player_state.atk_time < CurTime of
							   true ->
								   PlayerState1#player_state{
									   atk_num = 0,
									   atk_time = CurTime
								   };
							   _ ->
								   PlayerState1
						   end,
%% 			?INFO("12002 ~p", [Data]),
			case skill_base_lib:start_use_skill(PlayerState2, Data) of
				{ok, PlayerState3} ->
					{ok, PlayerState3};
				{fail, Err} ->
					Data1 = #rep_start_use_skill{
						result = Err
					},
					%% ?ERR("~p", [Err]),
					net_send:send_to_client(PlayerState2#player_state.socket, 12002, Data1);
				_DD ->
					?ERR("SKIPP ~p", [_DD]),
					skip
			end
	end;

%% 升级与学习技能
handle(12004, PlayerState, #req_upgrade_skill{skill_id = SkillId, lv = SkillLv}) ->
	case skill_tree_lib:learn_skill(PlayerState, SkillId, SkillLv) of
		{ok, PlayerState1} ->
			net_send:send_to_client(PlayerState#player_state.socket, 12004, #rep_upgrade_skill{result = ?ERR_COMMON_SUCCESS}),
			{ok, PlayerState1};
		{fail, Result} ->
			net_send:send_to_client(PlayerState#player_state.socket, 12004, #rep_upgrade_skill{result = Result})
	end;
%% "技能设置快捷键"
handle(12005, PlayerState, #req_set_pos{skill_id = SkillId, pos = Pos}) ->
	case skill_tree_lib:set_skill_keyboard(PlayerState, SkillId, Pos) of
		{ok, PlayerState1} ->
			net_send:send_to_client(PlayerState#player_state.socket, 12005, #rep_set_pos{result = ?ERR_COMMON_SUCCESS}),
			{ok, PlayerState1};
		{fail, Result} ->
			net_send:send_to_client(PlayerState#player_state.socket, 12005, #rep_set_pos{result = Result})
	end;
%% 清空快捷键
handle(12006, PlayerState, #req_clear_pos{skill_id = SkillId}) ->
	case skill_tree_lib:clear_skill_keyboard(PlayerState, SkillId) of
		{ok, PlayerState1} ->
			net_send:send_to_client(PlayerState#player_state.socket, 12006, #rep_clear_pos{result = ?ERR_COMMON_SUCCESS}),
			{ok, PlayerState1};
		{fail, Result} ->
			net_send:send_to_client(PlayerState#player_state.socket, 12006, #rep_clear_pos{result = Result})
	end;
%% 激活自动技能
handle(12007, PlayerState, #req_active_auto_skill{skill_id = SkillId, switch = Switch}) ->
	case skill_tree_lib:active_skill_auto_set(PlayerState, SkillId, Switch) of
		{ok, PlayerState1} ->
			case SkillId of
				30600 when Switch == 1 ->
					case skill_tree_lib:active_skill_auto_set(PlayerState1, 30800, 0) of
						{ok, PlayerState2} ->
							net_send:send_to_client(PlayerState#player_state.socket, 12007, #rep_active_auto_skill{result = ?ERR_COMMON_SUCCESS}),
							{ok, PlayerState2};
						_ ->
							net_send:send_to_client(PlayerState#player_state.socket, 12007, #rep_active_auto_skill{result = ?ERR_COMMON_SUCCESS}),
							{ok, PlayerState1}
					end;
				30800 when Switch == 1 ->
					case skill_tree_lib:active_skill_auto_set(PlayerState1, 30600, 0) of
						{ok, PlayerState2} ->
							net_send:send_to_client(PlayerState#player_state.socket, 12007, #rep_active_auto_skill{result = ?ERR_COMMON_SUCCESS}),
							{ok, PlayerState2};
						_ ->
							net_send:send_to_client(PlayerState#player_state.socket, 12007, #rep_active_auto_skill{result = ?ERR_COMMON_SUCCESS}),
							{ok, PlayerState1}
					end;
				_ ->
					net_send:send_to_client(PlayerState#player_state.socket, 12007, #rep_active_auto_skill{result = ?ERR_COMMON_SUCCESS}),
					{ok, PlayerState1}
			end;
		{fail, Result} ->
			net_send:send_to_client(PlayerState#player_state.socket, 12007, #rep_active_auto_skill{result = Result})
	end;
%% 设置与获取群体技能开关
handle(12008, PlayerState, #req_set_group_switch{type = Type}) ->
	DbBase = PlayerState#player_state.db_player_base,
	case Type of
		0 ->
			Update = #player_state{db_player_base = #db_player_base{skill_set = 0}},
			net_send:send_to_client(PlayerState#player_state.socket, 12008, #rep_set_group_switch{type = 0}),
			player_lib:update_player_state(PlayerState, Update);
		1 ->
			Update = #player_state{db_player_base = #db_player_base{skill_set = 1}},
			net_send:send_to_client(PlayerState#player_state.socket, 12008, #rep_set_group_switch{type = 1}),
			player_lib:update_player_state(PlayerState, Update);
		_ ->
			Set = DbBase#db_player_base.skill_set,
			net_send:send_to_client(PlayerState#player_state.socket, 12008, #rep_set_group_switch{type = Set})
	end;
%% 增加技能熟练度
handle(12009, PlayerState, #req_add_skill_exp{skill_id = SkillId, goods_id = GoodsId, num = Num}) ->
	case skill_tree_lib:upgrade_skill(PlayerState, SkillId, GoodsId, Num) of
		{ok, PlayerState1} ->
			net_send:send_to_client(PlayerState#player_state.socket, 12009, #rep_add_skill_exp{result = ?ERR_COMMON_SUCCESS}),
			{ok, PlayerState1};
		{fail, Result} ->
			net_send:send_to_client(PlayerState#player_state.socket, 12009, #rep_add_skill_exp{result = Result})
	end;
%% 触发技能效果
handle(12010, PlayerState, _Data) ->
%% 	?INFO("12010 ~p", [_Data]),
	skill_base_lib:trigger_skill(PlayerState);

handle(Cmd, PlayerState, Data) ->
	?ERR("not define ~p cmd:~nstate: ~p~ndata: ~p", [Cmd, PlayerState, Data]),
	{ok, PlayerState}.
%% ====================================================================
%% Internal functions
%% ====================================================================
