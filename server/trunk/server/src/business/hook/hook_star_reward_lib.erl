%%%-------------------------------------------------------------------
%%% @author zhengsiying
%%% @copyright (C) 2015, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 20. 十月 2015 下午9:59
%%%-------------------------------------------------------------------
-module(hook_star_reward_lib).

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
	get_hook_star_reward_list/0,
	draw_reward/3,
	compute_reward/3
]).

%% ====================================================================
%% API functions
%% ====================================================================
%% 初始化挂机星级奖励
init(PlayerState) ->
	PlayerId = PlayerState#player_state.player_id,
	case hook_star_reward_cache:select_all(PlayerId) of
		[] ->
			put_hook_star_reward_dict(dict:new());
		List ->
			F = fun(DbHookStarReward, Acc) ->
				dict:store(DbHookStarReward#db_hook_star_reward.chapter, DbHookStarReward, Acc)
			end,
			HookStarRewardDict = lists:foldl(F, dict:new(), List),
			put_hook_star_reward_dict(HookStarRewardDict)
	end.
%% 获取星级奖励列表
%% 获取挂机星级奖励列表
get_hook_star_reward_list() ->
	HookStarRewardDict = get_hook_star_reward_dict(),
	F = fun(Chapter, DbHookStarReward, Acc) ->
		[#proto_hook_star_reward{
			chapter = Chapter,
			star = player_hook_star_lib:get_chapter_star(Chapter), %% 获取章节星级
			step_list = DbHookStarReward#db_hook_star_reward.step_list
		} | Acc]
	end,
	dict:fold(F, [], HookStarRewardDict).

%% 校验星级阶段奖励
check_condition([], _Star, StepList) ->
	lists:reverse(StepList);
check_condition([{Condition, Step} | T], Star, StepList) ->
	case Condition =< Star andalso Step =:= ?REWARD_STATUS_NULL of
		true ->
			check_condition(T, Star, [?REWARD_STATUS_CAN_DRAW | StepList]);
		_ ->
			check_condition(T, Star, [Step | StepList])
	end.

%% 计算星级章节奖励
compute_reward(PlayerState, HookStarDict, Chapter) ->
	Star = player_hook_star_lib:get_chapter_star(HookStarDict, Chapter),
	HookStarRewardConf = hook_star_reward_config:get(Chapter),
	[Step1, Step2, Step3] = get_step_list(Chapter),
	#hook_star_reward_conf{
		step1_condition = Condition1,
		step2_condition = Condition2,
		step3_condition = Condition3
	} = HookStarRewardConf,
	List = [{Condition1, Step1}, {Condition2, Step2}, {Condition3, Step3}],
	NewStepList = check_condition(List, Star, []),

	case NewStepList /= [Step1, Step2, Step3] orelse Step1 =:= ?REWARD_STATUS_NULL of
		true ->
			%% 更行奖励阶段列表
			update_step_list(PlayerState#player_state.player_id, Chapter, NewStepList);
		_ ->
			skip
	end,

	Data = #rep_update_star_reward{
		hook_star_reward = #proto_hook_star_reward{
			chapter = Chapter,
			star = Star,
			step_list = NewStepList
		}
	},
	net_send:send_to_client(PlayerState#player_state.socket, 13023, Data).

%% 领取奖励
draw_reward(PlayerState, Chapter, Step) ->
	Star = player_hook_star_lib:get_chapter_star(Chapter),
	HookStarRewardConf = hook_star_reward_config:get(Chapter),
	StepList = get_step_list(Chapter),
	%% 根据领取阶段更新生成领取奖励后的阶段列表以及奖励状态
	{StepStatus, Condition, Reward, NewStepList} =
		case Step of
			1 ->
				[_StepStatus, _Step2, _Step3] = StepList,
				_Condition = HookStarRewardConf#hook_star_reward_conf.step1_condition,
				_Reward = HookStarRewardConf#hook_star_reward_conf.step1_reward,
				_NewStepList = [?REWARD_STATUS_HAS_DRAW, _Step2, _Step3],
				{_StepStatus, _Condition, _Reward, _NewStepList};
			2 ->
				[_Step1, _StepStatus, _Step3] = StepList,
				_Condition = HookStarRewardConf#hook_star_reward_conf.step2_condition,
				_Reward = HookStarRewardConf#hook_star_reward_conf.step2_reward,
				_NewStepList = [_Step1, ?REWARD_STATUS_HAS_DRAW, _Step3],
				{_StepStatus, _Condition, _Reward, _NewStepList};
			3 ->
				[_Step1, _Step2, _StepStatus] = StepList,
				_Condition = HookStarRewardConf#hook_star_reward_conf.step3_condition,
				_Reward = HookStarRewardConf#hook_star_reward_conf.step3_reward,
				_NewStepList = [_Step1, _Step2, ?REWARD_STATUS_HAS_DRAW],
				{_StepStatus, _Condition, _Reward, _NewStepList}
		end,

	Socket = PlayerState#player_state.socket,
	%% 判断当前阶段奖励是否被领取
	case StepStatus /= ?REWARD_STATUS_HAS_DRAW of
		true ->
			%% 如果没有被领取，判断是否符合星级条件
			case Star >= Condition of
				true ->
					%% 给玩家添加物品
					GoodsList = [{GoodsId, ?BIND, Num} || {GoodsId, Num} <- Reward],
					case goods_lib_log:add_goods_list(PlayerState, GoodsList,?LOG_TYPE_HOOK) of
						{ok, NewPlayerState} ->
							%% 更新阶段奖励列表
							update_step_list(PlayerState#player_state.player_id, Chapter, NewStepList),
							net_send:send_to_client(Socket, 13022, #rep_draw_star_reward{}),
							Data = #rep_update_star_reward{
								hook_star_reward = #proto_hook_star_reward{
									chapter = Chapter,
									star = Star,
									step_list = NewStepList
								}
							},
							%% 发送消息给前端
							net_send:send_to_client(Socket, 13023, Data),
							{ok, NewPlayerState};
						{fail, ErrCode} ->
							net_send:send_to_client(Socket, 13022, #rep_draw_star_reward{result = ErrCode}),
							{fail, ErrCode}
					end;
				_ ->
					ErrCode = ?ERR_HOOK_STAR_REWARD_CONDITION,
					net_send:send_to_client(Socket, 13022, #rep_draw_star_reward{result = ErrCode}),
					{fail, ErrCode}
			end;
		_ ->
			ErrCode = ?ERR_HOOK_STAR_REWARD_HAVE_BEEN_DRAW,
			net_send:send_to_client(Socket, 13022, #rep_draw_star_reward{result = ErrCode}),
			{fail, ErrCode}
	end.

put_hook_star_reward_dict(HookStarRewardDict) ->
	put(hook_star_reward_dict, HookStarRewardDict).

get_hook_star_reward_dict() ->
	get(hook_star_reward_dict).

%% ====================================================================
%% Internal functions
%% ====================================================================
%% 设置阶段奖励列表
get_step_list(Chapter) ->
	HookStarRewardDict = get_hook_star_reward_dict(),
	case dict:find(Chapter, HookStarRewardDict) of
		{ok, DbHookStarReward} ->
			DbHookStarReward#db_hook_star_reward.step_list;
		_ ->
			[0, 0, 0]
	end.

%% 更新阶段奖励列表
update_step_list(PlayerId, Chapter, StepList) ->
	HookStarRewardDict = get_hook_star_reward_dict(),
	NewDbHookStarReward = #db_hook_star_reward{player_id = PlayerId, chapter = Chapter, step_list = StepList},
	hook_star_reward_cache:replace(NewDbHookStarReward),
	NewDict = dict:store(Chapter, NewDbHookStarReward, HookStarRewardDict),
	put_hook_star_reward_dict(NewDict).