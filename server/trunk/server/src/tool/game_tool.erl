%%%-------------------------------------------------------------------
%%% @author yubing
%%% @copyright (C) 2016, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 06. 七月 2016 19:59
%%%-------------------------------------------------------------------
-module(game_tool).

-include("db_record.hrl").
-include("record.hrl").
-include("cache.hrl").
-include("common.hrl").
-include("proto.hrl").
-include("config.hrl").
-include("uid.hrl").
-include("util_json.hrl").
-include("proto_back.hrl").

%% API
-compile([export_all]).
%% 重新启动场景定时器
initS(SceneId) ->
	try
		case ets:lookup(?ETS_SCENE_MAPS, SceneId) of
			[EtsMaps] ->
				PidLineList = EtsMaps#ets_scene_maps.pid_list,
				F = fun(X) ->
					Num = scene_mgr_lib:get_scene_player_num(X#pid_line.pid),
					case Num > 0 of
						true ->
							scene_base_lib:init(X#pid_line.pid);
						_ ->
							ss
					end
				end,
				[F(X) || X <- PidLineList];
			_ ->
				skip
		end
	catch
		Err :Info ->
			?ERR("~p ~p", [Err, Info])
	end.

%% 学习所有技能
%% 临时接口  学习所有技能
learm_all_skill(PlayerState) ->
	PlayerBase = PlayerState#player_state.db_player_base,
	Career = PlayerBase#db_player_base.career,
	PlayerId = PlayerState#player_state.player_id,
	NewSkillDict = PlayerState#player_state.skill_dict,
	SkillList = [SId || {SId, SLv} <- skill_config:get_list(), SLv =:= 1 andalso (SId div 10000) * 1000 =:= Career],
	Fun = fun(Id, Acc) ->
		case skill_base_lib:get_skill_info(Acc, Id) of
			null ->
				S = #db_skill{
					player_id = PlayerId,
					skill_id = Id,
					lv = 1,
					pos = 0,
					exp = 0,
					auto_set = 0,
					next_time = 0
				},
				NSD = dict:store(Id, S, Acc),
				skill_cache:insert(S),
				skill_tree_lib:push_skill_info(PlayerState, S),
				NSD;
			_ ->
				Acc
		end
	end,
	NSD1 = lists:foldl(Fun, NewSkillDict, SkillList),

	{ok, PlayerState#player_state{skill_dict = NSD1}}.

%%学习单个技能
%% 临时接口
learm_one_skill(PlayerStatus, SkillId) ->
	case check_learn_skill(PlayerStatus, SkillId, 1) of
		{ok, SkillConf} ->
			SkillDict = PlayerStatus#player_state.skill_dict,
			PlayerId = PlayerStatus#player_state.player_id,
			SkillKeyBoard = PlayerStatus#player_state.skill_keyboard,
			{Pos, NewSkillKeyBoard} = get_new_pos(SkillId, SkillDict, SkillKeyBoard),
			SkillInfo = #db_skill{
				player_id = PlayerId,
				skill_id = SkillId,
				lv = 1,
				exp = 0,
				pos = Pos,
				auto_set = 0,
				next_time = 0
			},

			SkillType = SkillConf#skill_tree_conf.type,
			PasList = PlayerStatus#player_state.pass_trigger_skill_list,
			NewPasList = case SkillType of
							 ?SKILL_TYPE_PASSIVITY ->
								 lists:keystore(SkillId, 1, PasList, {SkillId, 1});
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
			{ok, PlayerStatus1};
		{fail, Reply} ->
			{fail, Reply}
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
					{break, 1}
			end
		end,
			fun(_) ->
				case SkillConf#skill_tree_conf.career =:= PlayerBase#db_player_base.career of
					true ->
						{continue, none};
					false ->
						{break, 2}
				end
			end,
			fun(_) ->
				case SkillConf#skill_tree_conf.limit_lv =< PlayerBase#db_player_base.lv of
					true ->
						{continue, none};
					false ->
						{break, 3}
				end
			end,
			fun(_) ->
				SkillDict = SkillDict = PlayerStatus#player_state.skill_dict,
				case skill_base_lib:get_skill_info(SkillDict, SkillId) of
					null ->       %% 1级技能激活检测
						case SkillLv =:= 1 of
							true ->
								{continue, SkillConf};
							false ->
								{break, 5}
						end;
					_SkillInfo ->  %% 技能升级检测
						{break, 6}
				end
			end
		]) of
		{break, Reply} -> {fail, Reply};
		{ok, Value} ->
			{ok, Value}
	end.

%% 获取技能配置
get_skill_conf(SkillId, SkillLv) ->
	skill_tree_config:get({SkillId, SkillLv}).

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
				[H | _] -> {H, [{H, SkillId}] ++ SkillKeyBoard}
			end;
		_ ->
			{0, SkillKeyBoard}
	end.

%% 更新技能dict 返回新的dict
update_skill_dict(SkillId, NewSkill, SkillDict) ->
	dict:store(SkillId, NewSkill, SkillDict).

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

%% 删掉翅膀并更新外观
delete_wing(PlayerState) ->
	case equips_lib:get_equips_info_from_grid(?SUBTYPE_WING) of
		[] ->
			{ok, PlayerState};
		GoodsInfo ->
			%% 外观变更检测
			goods_lib:delete_equips_by_id(PlayerState, GoodsInfo#db_goods.id),
			GuiseState = PlayerState#player_state.guise,
			UpdateState = #player_state{guise = GuiseState#guise_state{wing = 0}},
			UpdateState1 = UpdateState#player_state{pass_trigger_skill_list = PlayerState#player_state.pass_trigger_skill_list},
			UpdateState2 = equips_lib:update_equips_skill(UpdateState1, GoodsInfo, []),
			%% 更新玩家属性
			player_lib:update_refresh_player(PlayerState, UpdateState2)
	end.

%% 回收道具
retrieve_goods(PlayerState, GoodsId) ->
	Num = goods_lib:get_goods_num(GoodsId),
	case Num > 0 of
		true ->
			goods_lib:delete_goods_by_num(PlayerState, GoodsId, Num);
		_ ->
			skip
	end,
	Num1 = goods_lib:get_store_goods_num(GoodsId),
	case Num1 > 0 of
		true ->
			goods_store:delete_store_goods_by_num(PlayerState, GoodsId, Num1);
		_ ->
			skip
	end,
	TempNum = Num + Num1,
	case TempNum > 0 of
		true ->
			?ERR("~p", [TempNum]),
			GoodsConf = goods_config:get(GoodsId),
			Title = xmerl_ucs:to_utf8("特戒升级调整补偿"),
			Conter = xmerl_ucs:to_utf8("尊敬的玩家您好，因特戒打造系统调整，故需要进行赤练魂石的回收，我们将以每个赤练魂石1000元宝的价格进行回收，回收的元宝同此邮件一并发送，请注意查收。"),
			MailInfo1 = io_lib:format(xmerl_ucs:to_utf8("~s＊~w转化为~w个元宝"), [GoodsConf#goods_conf.name, TempNum, (Num + Num1) * 1000]),
			mail_lib:send_mail_to_player(PlayerState#player_state.player_id, xmerl_ucs:to_utf8("系统"), Title, Conter ++ MailInfo1, [{?GOODS_ID_JADE, 0, (Num + Num1) * 1000}]);
		_ ->
			?ERR("~p", [TempNum]),
			skip
	end.

