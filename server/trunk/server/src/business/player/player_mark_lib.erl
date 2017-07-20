%%%-------------------------------------------------------------------
%%% @author tuhujia
%%% @copyright (C) 2016, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 12. 六月 2016 10:24
%%%-------------------------------------------------------------------
-module(player_mark_lib).

-include("common.hrl").
-include("record.hrl").
-include("proto.hrl").
-include("cache.hrl").
-include("db_record.hrl").
-include("uid.hrl").
-include("config.hrl").
-include("language_config.hrl").
-include("gameconfig_config.hrl").
-include("log_type_config.hrl").
-include("button_tips_config.hrl").

%% API
-export([
	upgrade_mark/2,
	upgrade_mounts_mark/3,
	get_player_secure_attr/1,
	get_player_mounts_mark_attr/1,
	get_mark_lv_by_type/2,
	get_player_mounts_mark_bless/3,
	check_button_red/2,
	check_button_red_by_hp/1,
	check_button_red_by_atk/1,
	check_button_red_by_def/1,
	check_button_red_by_res/1,
	check_button_red_by_holy/1
]).

%% ====================================================================
%% API functions
%% ====================================================================

%% 印记升级
upgrade_mark(PlayerState, MarkType) ->
	case check_upgrade_mark(PlayerState, MarkType) of
		{ok, MarkConf} ->
			Stuff = MarkConf#mark_conf.upgrade_stuff,
			case goods_util:delete_special_list(PlayerState, Stuff, ?LOG_TYPE_UPGRADE_EQUIPS) of
				{ok, PlayerState1} ->
					DPMark = PlayerState#player_state.db_player_mark,
					Lv = MarkConf#mark_conf.lv,
					NewDPMark = set_mark_lv_by_type(DPMark, MarkType, Lv),

					PlayerState2 = PlayerState1#player_state{db_player_mark = NewDPMark},
					check_button_red(PlayerState2, MarkType),
					player_lib:update_refresh_player(PlayerState, PlayerState2);
				{fail, Reply} ->
					{fail, Reply}
			end;
		{fail, Reply} ->
			{fail, Reply}
	end.

%% 坐骑印记升级
upgrade_mounts_mark(PlayerState, MarkType, Type) ->
	DPMark = PlayerState#player_state.db_player_mark,
	MarkLv = get_mark_lv_by_type(DPMark, MarkType),
	DPB = PlayerState#player_state.db_player_base,
	Career = DPB#db_player_base.career,
	case mark_config:get({MarkType, MarkLv, Career}) of
		#mark_conf{} = MarkConf ->
			upgrade_mounts_mark_1(PlayerState, MarkType, Type, MarkConf, MarkLv);
		_ ->
			{fail, ?ERR_COMMON_FAIL}
	end.

upgrade_mounts_mark_1(PlayerState, MarkType, Type, MarkConf, MarkLv) ->
	case MarkConf#mark_conf.upgrade_stuff of
		[{GoodsId, Num}] ->
			GoodsNum = goods_lib:get_goods_num(GoodsId),
			case GoodsNum >= Num of
				true ->
					goods_lib_log:delete_goods_by_num(PlayerState, GoodsId, Num, ?LOG_TYPE_UPGRADE_EQUIPS),
					upgrade_mounts_mark_2(PlayerState, MarkType, MarkConf, MarkLv, 0);
				false ->
					case Type of
						0 -> %% 不使用元宝代替
							{fail, ?ERR_GOODS_NOT_ENOUGH};
						1 -> %% 使用元宝代替
							DPM = PlayerState#player_state.db_player_money,
							Jade = DPM#db_player_money.jade,
							NeedJade = (Num - GoodsNum) * MarkConf#mark_conf.stuff_jade,
							case Jade >= NeedJade of
								true ->
									goods_lib_log:delete_goods_by_num(PlayerState, GoodsId, GoodsNum, ?LOG_TYPE_UPGRADE_EQUIPS),
									upgrade_mounts_mark_2(PlayerState, MarkType, MarkConf, MarkLv, NeedJade);
								false ->
									{fail, ?ERR_PLAYER_JADE_NOT_ENOUGH}
							end
					end
			end;
		_ ->
			{fail, ?ERR_COMMON_FAIL}
	end.

upgrade_mounts_mark_2(PlayerState, MarkType, MarkConf, MarkLv, NeedJade) ->
	PlayerId = PlayerState#player_state.player_id,
	Bless = get_player_mounts_mark_bless(PlayerId, MarkType, MarkLv),
	MaxBless = MarkConf#mark_conf.max_bless,
	OneBless = MarkConf#mark_conf.one_bless,
	case Bless + OneBless >= MaxBless of
		true -> 	%% 成功升级 并清空祝福值
			upgrade_mounts_mark_3(PlayerState, MarkType, MarkConf, MarkLv, NeedJade);
		false ->
			[Round1, Round2, Rate] = MarkConf#mark_conf.bless_section,
			case Bless >= Round1 andalso Bless =< Round2 of
				true -> %% 启用概率
					case util_rand:rand_hit(Rate) of
						true ->
							upgrade_mounts_mark_3(PlayerState, MarkType, MarkConf, MarkLv, NeedJade);
						false ->
							upgrade_mounts_mark_4(PlayerState, MarkType, MarkConf, MarkLv, NeedJade, Bless)
					end;
				false ->
					upgrade_mounts_mark_4(PlayerState, MarkType, MarkConf, MarkLv, NeedJade, Bless)
			end
	end.

%% 成功处理
upgrade_mounts_mark_3(PlayerState, MarkType, MarkConf, MarkLv, NeedJade) ->
	PlayerId = PlayerState#player_state.player_id,
	CounterId = get_player_mounts_mark_bless_counter_id(MarkType, MarkLv),
	counter_lib:update_value(PlayerId, CounterId, 0),
	net_send:send_to_client(PlayerState#player_state.socket, 14055, #rep_get_mounts_mark_bless{bless = 0, mark_type = MarkType}),

	DPMark = PlayerState#player_state.db_player_mark,
	Lv = 1 + MarkConf#mark_conf.lv,
	NewDPMark = set_mark_lv_by_type(DPMark, MarkType, Lv),

	PlayerState1 = PlayerState#player_state{db_player_mark = NewDPMark},
	%% 更新外观
	PlayerState2 = goods_lib:update_guise_state(PlayerState1),
	{ok, PlayerState3} = player_lib:incval_on_player_money_log(PlayerState2, #db_player_money.jade, -NeedJade, ?LOG_TYPE_UPGRADE_EQUIPS),
	{ok, PlayerState4} = player_lib:update_refresh_player(PlayerState, PlayerState3),
	{ok, PlayerState4, ?ERR_COMMON_SUCCESS, 0}.

%% 失败处理
upgrade_mounts_mark_4(PlayerState, MarkType, MarkConf, MarkLv, NeedJade, Bless) ->
	PlayerId = PlayerState#player_state.player_id,
	CounterId = get_player_mounts_mark_bless_counter_id(MarkType, MarkLv),
	counter_lib:update_value(PlayerId, CounterId, Bless + MarkConf#mark_conf.one_bless),

	{ok, PlayerState1} = player_lib:incval_on_player_money_log(PlayerState, #db_player_money.jade, -NeedJade, ?LOG_TYPE_UPGRADE_EQUIPS),
	{ok, PlayerState1, ?ERR_COMMON_FAIL, Bless + MarkConf#mark_conf.one_bless}.


%% 获取印记的祝福值
get_player_mounts_mark_bless(PlayerId, MarkType, MarkLv) ->
	CounterId = get_player_mounts_mark_bless_counter_id(MarkType, MarkLv),
	counter_lib:get_value(PlayerId, CounterId).

get_player_mounts_mark_bless_counter_id(MarkType, MarkLv) ->
	case MarkType of
		?MARK_TYPE_MOUNTS_1 ->
			case MarkLv > 3 of
				false ->
					10100;
				true ->
					10101
			end;
		?MARK_TYPE_MOUNTS_2 ->
			case MarkLv > 3 of
				false ->
					10102;
				true ->
					10103
			end;
		?MARK_TYPE_MOUNTS_3 ->
			case MarkLv > 3 of
				false ->
					10104;
				true ->
					10105
			end;
		?MARK_TYPE_MOUNTS_4 ->
			case MarkLv > 3 of
				false ->
					10106;
				true ->
					10107
			end
	end.

%% upgrade_mounts_mark(PlayerState, MarkType, GoodsId) ->
%% 	case GoodsId == 0 of
%% 		true ->  %% 正常升级
%% 			upgrade_mounts_mark_normal(PlayerState, MarkType);
%% 		false -> %% 使用祝福玉
%% 			case goods_lib:get_goods_num(GoodsId) > 0 of
%% 				true ->
%% 					GoodsConf = goods_lib:get_goods_conf_by_id(GoodsId),
%% 					case GoodsConf#goods_conf.type == ?GOODS_TYPE_ZHUFUYU of
%% 						true ->
%% 							case GoodsConf#goods_conf.sub_type of
%% 								4 -> %%  初级祝福玉：使坐骑装备强化失败的情况下，装备等级只下降1级
%% 									upgrade_mounts_mark_special_1(PlayerState, MarkType, GoodsId);
%% 								5 -> %%  中级祝福玉：使坐骑装备强化失败的情况下，装备等级不降级
%% 									upgrade_mounts_mark_special_2(PlayerState, MarkType, GoodsId);
%% 								6 -> %%  高级祝福玉：进行强化时一定能成功
%% 									upgrade_mounts_mark_special_3(PlayerState, MarkType, GoodsId);
%% 								_ ->
%% 									{fail, ?ERR_COMMON_FAIL}
%% 							end;
%% 						false ->
%% 							{fail, ?ERR_COMMON_FAIL}
%% 					end;
%% 				false ->
%% 					{fail, ?ERR_GOODS_NOT_ENOUGH}
%% 			end
%% 	end.
%%
%% upgrade_mounts_mark_normal(PlayerState, MarkType) ->
%% 	case check_upgrade_mark(PlayerState, MarkType) of
%% 		{ok, MarkConf} ->
%% 			Stuff = MarkConf#mark_conf.upgrade_stuff,
%% 			case goods_util:delete_special_list(PlayerState, Stuff, ?LOG_TYPE_UPGRADE_EQUIPS) of
%% 				{ok, PlayerState1} ->
%% 					%% 判断强化成功或者失败(失败后降5级 最低为1级)
%% 					case util_rand:rand_hit(MarkConf#mark_conf.rate) of
%% 						true ->
%% 							DPMark = PlayerState#player_state.db_player_mark,
%% 							Lv = MarkConf#mark_conf.lv,
%% 							NewDPMark = set_mark_lv_by_type(DPMark, MarkType, Lv),
%%
%% 							PlayerState2 = PlayerState1#player_state{db_player_mark = NewDPMark},
%% 							%% 更新外观
%% 							PlayerState3 = goods_lib:update_guise_state(PlayerState2),
%% 							player_lib:update_refresh_player(PlayerState, PlayerState3);
%% 						false ->
%% 							DPMark = PlayerState#player_state.db_player_mark,
%% 							Lv = max(1, get_mark_lv_by_type(DPMark, MarkType) - 5),
%% 							NewDPMark = set_mark_lv_by_type(DPMark, MarkType, Lv),
%%
%% 							PlayerState2 = PlayerState1#player_state{db_player_mark = NewDPMark},
%% 							%% 更新外观
%% 							PlayerState3 = goods_lib:update_guise_state(PlayerState2),
%% 							{ok, PlayerState4} = player_lib:update_refresh_player(PlayerState, PlayerState3),
%% 							{ok, PlayerState4, ?ERR_COMMON_FAIL}
%% 					end;
%% 				{fail, Reply} ->
%% 					{fail, Reply}
%% 			end;
%% 		{fail, Reply} ->
%% 			{fail, Reply}
%% 	end.
%%
%% upgrade_mounts_mark_special_1(PlayerState, MarkType, GoodsId) ->
%% 	case check_upgrade_mark(PlayerState, MarkType) of
%% 		{ok, MarkConf} ->
%% 			Stuff = MarkConf#mark_conf.upgrade_stuff,
%% 			case goods_util:delete_special_list(PlayerState, Stuff, ?LOG_TYPE_UPGRADE_EQUIPS) of
%% 				{ok, PlayerState1} ->
%% 					goods_lib_log:delete_goods_by_num(PlayerState1, GoodsId, 1, ?LOG_TYPE_UPGRADE_EQUIPS),
%% 					case util_rand:rand_hit(MarkConf#mark_conf.rate) of
%% 						true ->
%% 							DPMark = PlayerState#player_state.db_player_mark,
%% 							Lv = MarkConf#mark_conf.lv,
%% 							NewDPMark = set_mark_lv_by_type(DPMark, MarkType, Lv),
%%
%% 							PlayerState2 = PlayerState1#player_state{db_player_mark = NewDPMark},
%% 							%% 更新外观
%% 							PlayerState3 = goods_lib:update_guise_state(PlayerState2),
%% 							player_lib:update_refresh_player(PlayerState, PlayerState3);
%% 						false ->
%% 							DPMark = PlayerState#player_state.db_player_mark,
%% 							Lv = max(1, get_mark_lv_by_type(DPMark, MarkType) - 1),
%% 							NewDPMark = set_mark_lv_by_type(DPMark, MarkType, Lv),
%%
%% 							PlayerState2 = PlayerState1#player_state{db_player_mark = NewDPMark},
%% 							%% 更新外观
%% 							PlayerState3 = goods_lib:update_guise_state(PlayerState2),
%% 							{ok, PlayerState4} = player_lib:update_refresh_player(PlayerState, PlayerState3),
%% 							{ok, PlayerState4, ?ERR_COMMON_FAIL}
%% 					end;
%% 				{fail, Reply} ->
%% 					{fail, Reply}
%% 			end;
%% 		{fail, Reply} ->
%% 			{fail, Reply}
%% 	end.
%%
%% upgrade_mounts_mark_special_2(PlayerState, MarkType, GoodsId) ->
%% 	case check_upgrade_mark(PlayerState, MarkType) of
%% 		{ok, MarkConf} ->
%% 			Stuff = MarkConf#mark_conf.upgrade_stuff,
%% 			case goods_util:delete_special_list(PlayerState, Stuff, ?LOG_TYPE_UPGRADE_EQUIPS) of
%% 				{ok, PlayerState1} ->
%% 					goods_lib_log:delete_goods_by_num(PlayerState1, GoodsId, 1, ?LOG_TYPE_UPGRADE_EQUIPS),
%% 					case util_rand:rand_hit(MarkConf#mark_conf.rate) of
%% 						true ->
%% 							DPMark = PlayerState#player_state.db_player_mark,
%% 							Lv = MarkConf#mark_conf.lv,
%% 							NewDPMark = set_mark_lv_by_type(DPMark, MarkType, Lv),
%%
%% 							PlayerState2 = PlayerState1#player_state{db_player_mark = NewDPMark},
%% 							%% 更新外观
%% 							PlayerState3 = goods_lib:update_guise_state(PlayerState2),
%% 							player_lib:update_refresh_player(PlayerState, PlayerState3);
%% 						false ->
%% 							{ok, PlayerState1, ?ERR_COMMON_FAIL}
%% 					end;
%% 				{fail, Reply} ->
%% 					{fail, Reply}
%% 			end;
%% 		{fail, Reply} ->
%% 			{fail, Reply}
%% 	end.
%%
%% upgrade_mounts_mark_special_3(PlayerState, MarkType, GoodsId) ->
%% 	case check_upgrade_mark(PlayerState, MarkType) of
%% 		{ok, MarkConf} ->
%% 			Stuff = MarkConf#mark_conf.upgrade_stuff,
%% 			case goods_util:delete_special_list(PlayerState, Stuff, ?LOG_TYPE_UPGRADE_EQUIPS) of
%% 				{ok, PlayerState1} ->
%% 					goods_lib_log:delete_goods_by_num(PlayerState1, GoodsId, 1, ?LOG_TYPE_UPGRADE_EQUIPS),
%%
%% 					DPMark = PlayerState#player_state.db_player_mark,
%% 					Lv = MarkConf#mark_conf.lv,
%% 					NewDPMark = set_mark_lv_by_type(DPMark, MarkType, Lv),
%%
%% 					PlayerState2 = PlayerState1#player_state{db_player_mark = NewDPMark},
%% 					%% 更新外观
%% 					PlayerState3 = goods_lib:update_guise_state(PlayerState2),
%% 					player_lib:update_refresh_player(PlayerState, PlayerState3);
%% 				{fail, Reply} ->
%% 					{fail, Reply}
%% 			end;
%% 		{fail, Reply} ->
%% 			{fail, Reply}
%% 	end.

check_upgrade_mark(PlayerState, MarkType) ->
	DPMark = PlayerState#player_state.db_player_mark,
	MarkLv = get_mark_lv_by_type(DPMark, MarkType),
	DPB = PlayerState#player_state.db_player_base,
	Career = DPB#db_player_base.career,
	case util:loop_functions(
		none,
		[fun(_)
			->
			case mark_config:get({MarkType, MarkLv + 1, Career}) of
				#mark_conf{} = MarkConf ->
					{continue, MarkConf};
				_ ->
					{break, ?ERR_COMMON_FAIL}
			end
		end,
		fun(MarkConf) ->
			Stuff = MarkConf#mark_conf.upgrade_stuff,
			case goods_util:check_special_list(PlayerState, Stuff) of
				true ->
					{continue, MarkConf};
				{fail, Reply} ->
					{break, Reply}
			end
		end,
		fun(MarkConf) ->
			Cond = MarkConf#mark_conf.limit_cond,
			case check_upgrade_cond(PlayerState, Cond) of
				{ok, _} ->
					{continue, MarkConf};
				{fail, Reply} ->
					{break, Reply}
			end
		end
		]) of
		{break, Reply} -> {fail, Reply};
		{ok, Conf} ->
			{ok, Conf}
	end.

%% 根据对应类型获取对应等级
get_mark_lv_by_type(DPMark, Type) ->
	case Type of
		?MARK_TYPE_HP ->
			DPMark#db_player_mark.hp_mark;
		?MARK_TYPE_ATK ->
			DPMark#db_player_mark.atk_mark;
		?MARK_TYPE_DEF ->
			DPMark#db_player_mark.def_mark;
		?MARK_TYPE_RES ->
			DPMark#db_player_mark.res_mark;
		?MARK_TYPE_HOLY ->
			DPMark#db_player_mark.holy_mark;
		?MARK_TYPE_MOUNTS_1 ->
			DPMark#db_player_mark.mounts_mark_1;
		?MARK_TYPE_MOUNTS_2 ->
			DPMark#db_player_mark.mounts_mark_2;
		?MARK_TYPE_MOUNTS_3 ->
			DPMark#db_player_mark.mounts_mark_3;
		?MARK_TYPE_MOUNTS_4 ->
			DPMark#db_player_mark.mounts_mark_4
	end.

%% 设置等级
set_mark_lv_by_type(DPMark, MarkType, Lv) ->
	case MarkType of
		?MARK_TYPE_HP ->
			DPMark#db_player_mark{hp_mark = Lv};
		?MARK_TYPE_ATK ->
			DPMark#db_player_mark{atk_mark = Lv};
		?MARK_TYPE_DEF ->
			DPMark#db_player_mark{def_mark = Lv};
		?MARK_TYPE_RES ->
			DPMark#db_player_mark{res_mark = Lv};
		?MARK_TYPE_HOLY ->
			DPMark#db_player_mark{holy_mark = Lv};
		?MARK_TYPE_MOUNTS_1 ->
			DPMark#db_player_mark{mounts_mark_1 = Lv};
		?MARK_TYPE_MOUNTS_2 ->
			DPMark#db_player_mark{mounts_mark_2 = Lv};
		?MARK_TYPE_MOUNTS_3 ->
			DPMark#db_player_mark{mounts_mark_3 = Lv};
		?MARK_TYPE_MOUNTS_4 ->
			DPMark#db_player_mark{mounts_mark_4 = Lv}
	end.

check_upgrade_cond(PlayerState, []) ->
	{ok, PlayerState};
check_upgrade_cond(PlayerState, [{Type, Lv}| T]) ->
	DPMark = PlayerState#player_state.db_player_mark,
	case get_mark_lv_by_type(DPMark, Type) >= Lv of
		true ->
			check_upgrade_cond(PlayerState, T);
		false ->
			{fail, ?ERR_PLAYER_MARK_LV_NOT_ENOUGH}
	end.

%% 获取玩家印记属性
get_player_secure_attr(PlayerState) ->
	DPMark = PlayerState#player_state.db_player_mark,
	DPB = PlayerState#player_state.db_player_base,
	Career = DPB#db_player_base.career,

	Fun = fun(Type, Acc) ->
		case get_attr_conf(Type, get_mark_lv_by_type(DPMark, Type), Career) of
			[] ->
				Acc;
			Attr ->
				api_attr:attach_attr([Attr, Acc])
		end
	end,
	lists:foldl(Fun, #attr_base{}, [?MARK_TYPE_HP, ?MARK_TYPE_ATK, ?MARK_TYPE_DEF, ?MARK_TYPE_RES, ?MARK_TYPE_HOLY]).

%% 获取坐骑印记属性
get_player_mounts_mark_attr(PlayerState) ->
	DPMark = PlayerState#player_state.db_player_mark,
	DPB = PlayerState#player_state.db_player_base,
	Career = DPB#db_player_base.career,

	Fun = fun(Type, Acc) ->
		case get_attr_conf(Type, get_mark_lv_by_type(DPMark, Type), Career) of
			[] ->
				Acc;
			Attr ->
				api_attr:attach_attr([Attr, Acc])
		end
	end,
	lists:foldl(Fun, #attr_base{}, [?MARK_TYPE_MOUNTS_1, ?MARK_TYPE_MOUNTS_2, ?MARK_TYPE_MOUNTS_3, ?MARK_TYPE_MOUNTS_4]).

get_attr_conf(Type, Lv, Career) ->
	case Lv > 0 of
		true ->
			case mark_config:get({Type, Lv, Career}) of
				#mark_conf{} = MarkConf ->
					MarkConf#mark_conf.attr_base;
				_ ->
					[]
			end;
		false ->
			[]
	end.

%% 红点检测
check_button_red(PlayerState, MarkType) ->
	case MarkType of
		?MARK_TYPE_HP ->
			button_tips_lib:ref_button_tips(PlayerState, ?BTN_ROLE_STAMP_HP),
			button_tips_lib:ref_button_tips(PlayerState, ?BTN_ROLE_STAMP_HOLY);
		?MARK_TYPE_ATK ->
			button_tips_lib:ref_button_tips(PlayerState, ?BTN_ROLE_STAMP_ATK),
			button_tips_lib:ref_button_tips(PlayerState, ?BTN_ROLE_STAMP_HOLY);
		?MARK_TYPE_DEF ->
			button_tips_lib:ref_button_tips(PlayerState, ?BTN_ROLE_STAMP_DEF),
			button_tips_lib:ref_button_tips(PlayerState, ?BTN_ROLE_STAMP_HOLY);
		?MARK_TYPE_RES ->
			button_tips_lib:ref_button_tips(PlayerState, ?BTN_ROLE_STAMP_MDEF),
			button_tips_lib:ref_button_tips(PlayerState, ?BTN_ROLE_STAMP_HOLY);
		?MARK_TYPE_HOLY ->
			button_tips_lib:ref_button_tips(PlayerState, ?BTN_ROLE_STAMP_HOLY)
	end.

check_button_red_by_hp(PlayerState) ->
	case check_upgrade_mark(PlayerState, ?MARK_TYPE_HP) of
		{ok, _} ->
			{PlayerState, 1};
		_ ->
			{PlayerState, 0}
	end.

check_button_red_by_atk(PlayerState) ->
	case check_upgrade_mark(PlayerState, ?MARK_TYPE_ATK) of
		{ok, _} ->
			{PlayerState, 1};
		_ ->
			{PlayerState, 0}
	end.

check_button_red_by_def(PlayerState) ->
	case check_upgrade_mark(PlayerState, ?MARK_TYPE_DEF) of
		{ok, _} ->
			{PlayerState, 1};
		_ ->
			{PlayerState, 0}
	end.

check_button_red_by_res(PlayerState) ->
	case check_upgrade_mark(PlayerState, ?MARK_TYPE_RES) of
		{ok, _} ->
			{PlayerState, 1};
		_ ->
			{PlayerState, 0}
	end.

check_button_red_by_holy(PlayerState) ->
	case check_upgrade_mark(PlayerState, ?MARK_TYPE_HOLY) of
		{ok, _} ->
			{PlayerState, 1};
		_ ->
			{PlayerState, 0}
	end.

