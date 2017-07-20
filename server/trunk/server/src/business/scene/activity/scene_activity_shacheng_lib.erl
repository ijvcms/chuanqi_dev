%%%-------------------------------------------------------------------
%%% @author zhengsiying
%%% @copyright (C) 2015, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 21. 十二月 2015 上午12:12
%%%-------------------------------------------------------------------
-module(scene_activity_shacheng_lib).

-include("common.hrl").
-include("record.hrl").
-include("proto.hrl").
-include("log_type_config.hrl").
-include("config.hrl").

%% API
-export([
	init/2,
	on_timer/1,
	on_start/1,
	on_end/1,
	on_obj_die/3,
	get_occupy_info/0,
	set_occupy_info/2,
	get_occupy_guild_id/0,
	get_rep_shacheng_info/0,
	bubble_point/1,
	update_time_box/3,
	get_ets_time/0
]).

-define(ADD_EXP_TIMES, 15). %% 添加经验时间(秒)
-define(REFUSE_BOX_TIMES, 5 * 60). %% 刷新宝箱时间(秒)

%% ====================================================================
%% API functions
%% ====================================================================
init(SceneState, _Args) ->
	{ok, SceneState#scene_state{refuse_box_time_shacheng = util_date:unixtime()}}.

on_timer(SceneState) ->
	%% 获取当前活动的状态信息
	CurStatus = SceneState#scene_state.activity_status,
	CurTime = util_date:unixtime(),
	%% 检测刷新宝箱
	SceneState2 = case CurStatus =:= ?ACTIVITY_STATUS_ON of
					  true ->
						  update_time_box(SceneState, CurTime, shacheng);
					  _ ->
						  SceneState
				  end,

	{ok, SceneState2}.

%% 皇宫开启
on_start(SceneState) ->
	gen_server2:apply_after(?ADD_EXP_TIMES * 1000, self(), {?MODULE, bubble_point, []}),
	CurTime = util_date:unixtime(),
	NewSceneState = SceneState#scene_state{
		refuse_box_time_shacheng = CurTime + ?REFUSE_BOX_TIMES
	},
	{ok, NewSceneState}.

on_end(SceneState) ->
	%% 首次沙巴克活动结束启动刷宝箱规则
	{ok, SceneState}.

on_obj_die(SceneState, _DieState, _KillerState) ->
	{ok, SceneState}.
%% 设置所属的工会
set_occupy_info(GuildId, IsActivity) ->
	case ets:lookup(?ETS_ACTIVITY_SHACHENG, 1) of%% 查看是否有沙城活动
		[OldEtsInfo] ->
			OldGuildId = OldEtsInfo#ets_activity_shacheng.guild_id,%% 如果有的话 那么变更工会
			OldActivity = OldEtsInfo#ets_activity_shacheng.is_activity,
			EtsInfo = OldEtsInfo#ets_activity_shacheng{
				guild_id = GuildId,
				is_activity = IsActivity
			},
			ets:insert(?ETS_ACTIVITY_SHACHENG, EtsInfo),
			case OldGuildId /= GuildId orelse OldActivity /= IsActivity of%% 如果工会变更，或者活动关闭，发送信息给前端
				true ->
					Data = get_rep_shacheng_info(),
					?INFO("send occupy data: ~p", [Data]),
					net_send:send_to_world(11018, Data);
				_ ->
					skip
			end;
		_ ->
			EtsInfo = #ets_activity_shacheng{
				id = 1,
				guild_id = GuildId,
				is_activity = IsActivity
			},
			ets:insert(?ETS_ACTIVITY_SHACHENG, EtsInfo)
	end.
%% 获取占领信息
get_occupy_info() ->
	case ets:lookup(?ETS_ACTIVITY_SHACHENG, 1) of
		[EtsInfo] ->
			EtsInfo;
		_ ->
			null
	end.
%% 获取当前沙城占领的工会id
get_occupy_guild_id() ->
	case ets:lookup(?ETS_ACTIVITY_SHACHENG, 1) of
		[EtsInfo] ->
			EtsInfo#ets_activity_shacheng.guild_id;
		_ ->
			0
	end.
%% 获取沙城相关信息，并发送给前端
get_rep_shacheng_info() ->
	case scene_activity_shacheng_lib:get_occupy_info() of
		#ets_activity_shacheng{} = EtsInfo ->
			GuildId = EtsInfo#ets_activity_shacheng.guild_id,
			GuildName = guild_lib:get_guild_name(GuildId),
			#rep_shacheng_info{
				guild_id = GuildId,
				guild_name = GuildName,
				activity = EtsInfo#ets_activity_shacheng.is_activity
			};
		_ ->
			#rep_shacheng_info{}
	end.

%% ====================================================================
%% Internal functions
%% ====================================================================

bubble_point(SceneState) ->
	case ets:lookup(?ETS_ACTIVITY_SHACHENG, 1) of%% 查看是否有沙城活动
		[OldEtsInfo] ->
			case OldEtsInfo#ets_activity_shacheng.is_activity of
				?ACTIVITY_STATUS_ON ->
					ObjList = scene_base_lib:do_get_scene_players(SceneState),
					Fun = fun(ObjState) ->
						Pid = ObjState#scene_obj_state.obj_pid,
						Exp = max(0, (ObjState#scene_obj_state.lv - 10) * 100),
						gen_server2:cast(Pid, {add_value, ?SUBTYPE_EXP, Exp, ?LOG_TYPE_OFFICER_DAY})
					end,
					[Fun(X) || X <- ObjList],
					gen_server2:apply_after(?ADD_EXP_TIMES * 1000, self(), {?MODULE, bubble_point, []}),
					{ok, SceneState};
				_ ->
					skip
			end;
		_ ->
			skip
	end.

%% 定时刷新宝箱
update_time_box(SceneState, CurTime, Mod) ->
	R = get_ets_time(),
	RefTime = case Mod of
				  shacheng ->
					  R#ets_sbk_box.ref_shacheng_time;
				  _ ->
					  R#ets_sbk_box.ref_palace_time
			  end,

	case CurTime > RefTime of
		true ->
			case Mod of
				shacheng ->
					R1 = R#ets_sbk_box{
						ref_shacheng_time = CurTime + ?REFUSE_BOX_TIMES + ?REFUSE_BOX_TIMES
					},
					ets:insert(?ETS_SBK_BOX, R1);
				_ ->
					R1 = R#ets_sbk_box{
						ref_palace_time = CurTime + ?REFUSE_BOX_TIMES + ?REFUSE_BOX_TIMES
					},
					ets:insert(?ETS_SBK_BOX, R1)
			end,
			SceneConf = scene_config:get(SceneState#scene_state.scene_id),
			RuleMonsterList =
				case lists:keyfind(time_box, 1, SceneConf#scene_conf.rule_monster_list) of
					false ->
						[];
					{_, L} ->
						L
				end,
%% 			?ERR("~p", [RuleMonsterList]),
			%% 刷新宝箱
			F = fun(RuleInfo, Acc) ->
%% 				?ERR("~p", [RuleInfo]),
				scene_obj_lib:create_area_monster(Acc, RuleInfo)
			end,
			SceneState1 = lists:foldl(F, SceneState, RuleMonsterList),
			SceneState1;
		_ ->
			SceneState
	end.



get_ets_time() ->
	case ets:lookup(?ETS_SBK_BOX, ?SCENEID_SHABAKE) of
		[R | _] ->
			R;
		_ ->
			CurTime = util_date:unixtime(),
			%% 宝箱信息记录
			EtsBox = #ets_sbk_box{
				key = ?SCENEID_SHABAKE,
				ref_shacheng_time = CurTime + ?REFUSE_BOX_TIMES,
				ref_palace_time = CurTime + ?REFUSE_BOX_TIMES + ?REFUSE_BOX_TIMES,
				player_dice = dict:new()
			},
			ets:insert(?ETS_SBK_BOX, EtsBox),
			EtsBox
	end.

