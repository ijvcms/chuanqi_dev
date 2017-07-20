%%%-------------------------------------------------------------------
%%% @author yubing
%%% @copyright (C) 2016, <COMPANY>
%%% @doc 开服活动信息
%%%
%%% @end
%%% Created : 23. 二月 2016 18:06
%%%-------------------------------------------------------------------
-module(active_lib).

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
	init/2,
	on_timer/1,
	reset/0,
	get_show_active_type_list/0
]).
%% 初始化 IsOntime 是否启动定时器
init(ActiveState, IsOntime) ->
	F = fun(X) ->
		player_active_service_cache:select_all(X)
	end,
	NewList = [{X, F(X)} || X <- active_service_config:get_list()],

	ActiveState1 = ActiveState#active_state{
		active_service_list = NewList
	},

	CurtTime = util_date:unixtime(),
	F1 = fun(X, List) ->
		{BeginTime, EndTime, _, ActiveServiceTypeConf} = active_service_lib:get_active_time(X),
		case CurtTime < EndTime of
			true ->
				ActiveTimeInfo = #active_time_info{
					active_type_id = X,
					active_type_conf = ActiveServiceTypeConf,
					begin_time = BeginTime,
					end_time = EndTime,
					is_open = false
				},
				[ActiveTimeInfo | List];
			_ ->
				case CurtTime > EndTime of
					true ->
						check_receive_goods(X);
				%%skip;
					_ ->
						skip
				end,
				List
		end
	end,
	NewTypeList = lists:foldl(F1, [], active_service_type_config:get_list()),
	case IsOntime of
		true ->
			gen_server2:apply_after(10000, self(), {?MODULE, on_timer, []});
		_ ->
			skip
	end,
	ActiveState2 = ActiveState1#active_state{active_service_type_list = NewTypeList},
%% 	[exe(ActiveState2, X) || {X, _, BeginTime1, _, _} <- NewTypeList, BeginTime1 < CurtTime],
	{ok, ActiveState2}.

reset() ->
	gen_server2:apply_async(misc:whereis_name({local, active_mod}), {?MODULE, init, [false]}).

%% 检测发送活动邮件
check_receive_goods(TypeId) ->
	F = fun(X) ->
		RankList = rank_lib:get_rank_list_active_type(X#active_service_conf.type, true),
		case player_active_service_cache:select_all(X#active_service_conf.id) of
			[] ->
				case lists:keyfind(X#active_service_conf.rank, #ets_active_rank_info.rank, RankList) of
					false ->
						skip;
					RankInfo ->
						active_rank_lib:checke_active_service(RankInfo#ets_active_rank_info.player_id, X)
				end;
			_ ->
				skip
		end
	end,
	[F(X) || X <- active_service_config:get_list_conf(), X#active_service_conf.type =:= TypeId, X#active_service_conf.rank > 0].

%% 定时查看活动是否完成
on_timer(ActiveState) ->
	CurtTime = util_date:unixtime(),
	F = fun(ActiveTimeInfo, List) ->

		#active_time_info{
			active_type_id = TypeId,
			begin_time = BeginTime,
			end_time = EndTime,
			is_open = IsOpen} = ActiveTimeInfo,

		case EndTime < CurtTime of
			true ->
				check_receive_goods(TypeId),
				OnlineList = player_lib:get_online_players(),
				[gen_server2:apply_async(X#ets_online.pid, {active_rank_lib, checke_acitve_over, []}) || X <- OnlineList],
				List;
			_ ->
				NewIsOpen = case IsOpen of
								true ->
									true;
								_ ->
									case BeginTime < CurtTime of
										true ->
											exe(ActiveState, TypeId),
											true;
										_ ->
											false
									end
							end,
				[ActiveTimeInfo#active_time_info{is_open = NewIsOpen} | List]
		end
	end,
	NewList = lists:foldl(F, [], ActiveState#active_state.active_service_type_list),
	gen_server2:apply_after(10000, self(), {?MODULE, on_timer, []}),
	{ok, ActiveState#active_state{active_service_type_list = NewList}}.

%% 获取显示的活动列表
get_show_active_type_list() ->
	CurTime = util_date:unixtime(),
	F = fun(X, List) ->
		{BeginTime, EndTime, ShowTime, #active_service_type_conf{receive_state = ReceiveState}} = active_service_lib:get_active_time(X),
		case ShowTime > CurTime of
			true ->
				State =
					case ReceiveState of
						?RECEIVE_STATE_2 ->
							case BeginTime > CurTime of
								true ->
									0;%% 0未开启 1，进行中，2 结束 3 不显示
								_ ->
									case EndTime > CurTime of
										true ->
											1;
										_ ->
											2
									end
							end;
						_ ->
							case CurTime > BeginTime of
								true ->
									3;
								_ ->
									-1
							end
					end,
				case State of
					-1 ->
						List;
					_ ->
						TypeInfo = #proto_active_service_type_info{
							type_id = X,
							state = State
						},
						[TypeInfo | List]
				end;
			_ ->
				List
		end
	end,
	lists:foldl(F, [], active_service_type_config:get_list()).


%% 新区冲级送好礼
exe(ActiveState, ActiveServiceType) ->
	F = fun(X, MinValue) ->
		#active_service_conf{value = Value} = active_service_config:get(X),
		case MinValue =:= 0 orelse Value < MinValue of
			true ->
				Value;
			_ ->
				MinValue
		end
	end,
	TempValue = lists:foldl(F, 0, active_service_config:get_type_list(ActiveServiceType)),
	Data = type_data(ActiveServiceType),
	init_insert(ActiveState, Data, TempValue, ActiveServiceType).
%% 新区冲级送好礼
type_data(?ACTIVE_SERVICE_TYPE_LV) ->
	Sql = "select lv,player_id from player_base",
	db:execute(Sql);
%% 强化达人还有谁
type_data(?ACTIVE_SERVICE_TYPE_STREN) ->
	Sql = "select SUM(stren_lv) ,player_id from player_goods GROUP BY player_id",
	db:execute(Sql);
%% 羽翼飞升酷炫拽
type_data(?ACTIVE_SERVICE_TYPE_WING) ->
	Sql = io_lib:format("select goods_id,player_id from player_goods WHERE location=1 and grid=~w", [?SUBTYPE_WING]),
	Data = db:execute(Sql),
	F = fun([GoodsId, PlayerId], List) ->
		GoodConf = goods_config:get(GoodsId),
		[[GoodConf#goods_conf.lv, PlayerId] | List]
	end,
	lists:foldl(F, [], Data);
%% 勋章升级超值礼
type_data(?ACTIVE_SERVICE_TYPE_MEDAL) ->
	Sql = io_lib:format("select goods_id,player_id from player_goods WHERE location=1 and grid=~w", [?SUBTYPE_MEDAL]),
	Data = db:execute(Sql),
	F = fun([GoodsId, PlayerId], List) ->
		GoodConf = goods_config:get(GoodsId),
		[[GoodConf#goods_conf.lv, PlayerId] | List]
	end,
	lists:foldl(F, [], Data);
%% 印记等级活动
type_data(?ACTIVE_SERVICE_TYPE_MARK) ->
	Sql = "select hp_mark+atk_mark+def_mark+res_mark+holy_mark,player_id from player_mark",
	db:execute(Sql);
%% 战力提升誓比高
type_data(?ACTIVE_SERVICE_TYPE_FIGHT) ->
	Sql = "select fight,player_id from player_base",
	db:execute(Sql);
type_data(_Type) ->
	[].
%% 添加进入数据库
init_insert(ActiveState, List, MinValue, Type) ->
	?INFO("~p ~p ~p", [length(List), Type, MinValue]),
	F = fun([Value, PlayerId]) ->
		active_service_lib:do_insert_active_record(ActiveState, Type, PlayerId, Value)
%% 		case Value >= MinValue of
%% 			true ->
%% 				active_service_lib:do_insert_active_record(ActiveState, Type, PlayerId, Value);
%% 			_ ->
%% 				skip
%% 		end
	end,
	[F(X) || X <- List].



