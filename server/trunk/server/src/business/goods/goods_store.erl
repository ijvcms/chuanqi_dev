%%%-------------------------------------------------------------------
%%% @author tuhujia
%%% @copyright (C) 2015, <COMPANY>
%%% @doc 玩家仓库相关
%%%
%%% @end
%%% Created : 01. 十二月 2015 09:37
%%%-------------------------------------------------------------------
-module(goods_store).

-include("common.hrl").
-include("record.hrl").
-include("proto.hrl").
-include("cache.hrl").
-include("db_record.hrl").
-include("config.hrl").
-include("uid.hrl").
-include("language_config.hrl").
-include("log_type_config.hrl").

%% API
-export([
	add_store_goods/4,
	get_store_info_list/0,
	get_store_cell/1,
	move_goods_to_store/4,
	move_goods_to_bag/4,
	delete_store_goods_by_num/3
]).

%% ====================================================================
%% API functions
%% ====================================================================

%% 添加仓库道具
add_store_goods(State, GoodsId, IsBind, Num) when Num > 0 andalso (IsBind =:= ?NOT_BIND orelse IsBind == ?BIND) ->
	case check_store_cond(State, GoodsId, Num) of
		{ok, GoodsConfig} ->
			LimitNum = GoodsConfig#goods_conf.limit_num,
			case LimitNum of
				1 ->                                                                %% 不能堆叠道具
					add_unstack_goods(State, GoodsId, IsBind);
				_ ->                                                                %% 有堆叠限制道具
					add_stack_goods(State, GoodsId, IsBind, Num, LimitNum)
			end;
		{fail, Reply} ->
			{fail, Reply}
	end.

%% 添加不可堆叠道具
add_unstack_goods(State, GoodsId, IsBind) ->
	add_player_store_info(State, GoodsId, IsBind, 1, []),
	{ok, State}.

%% 添加可堆叠道具
add_stack_goods(State, GoodsId, IsBind, Num, LimitNum) ->
	case goods_dict:check_is_exist_store_goods(GoodsId, IsBind) of
		true ->
			[{Key, KeyNum} | _] = goods_dict:get_value_from_store_dict_by_id(GoodsId, IsBind),
			case KeyNum =:= LimitNum of
				true ->
					add_stack_goods_1(State, GoodsId, IsBind, Num, LimitNum);
				false ->
					add_stack_goods_2(State, GoodsId, IsBind, Num, Key, KeyNum, LimitNum)
			end;
		false ->
			add_stack_goods_1(State, GoodsId, IsBind, Num, LimitNum)
	end.

%% 循环添加道具
add_stack_goods_1(State, GoodsId, IsBind, Num, LimitNum) ->
	case Num > LimitNum of
		true ->
			add_player_store_info(State, GoodsId, IsBind, LimitNum, []),
			add_stack_goods_1(State, GoodsId, IsBind, Num - LimitNum, LimitNum);
		false ->
			add_player_store_info(State, GoodsId, IsBind, Num, [])
	end.

%% 更新key后添加道具
add_stack_goods_2(State, GoodsId, IsBind, Num, Id, KeyNum, LimitNum) ->
	case get_player_store_goods_info(Id) of
		#db_goods{} = GoodsInfo ->
			case Num + KeyNum > LimitNum of
				true ->
					update_player_store_info(State, GoodsInfo#db_goods{num = LimitNum}),
					RemainNum = Num + KeyNum - LimitNum,
					add_stack_goods(State, GoodsId, IsBind, RemainNum, LimitNum);
				false ->
					update_player_store_info(State, GoodsInfo#db_goods{num = Num + KeyNum})
			end;
		_ ->
			{fail, ?ERR_COMMON_FAIL}
	end.

%% 删除指定id的仓库道具
%% delete_store_goods_by_id_num(State, Id, Num) ->
%% 	case get_player_store_goods_info(Id) of
%% 		#db_goods{} = GoodsInfo ->
%% 			GoodsNum = GoodsInfo#db_goods.num,
%% 			case GoodsNum >= Num of
%% 				true ->
%% 					NewNum = GoodsNum - Num,
%% 					case NewNum > 0 of
%% 						true -> 	%% 更新
%% 							update_player_store_info(State, GoodsInfo#db_goods{num = NewNum});
%% 						false ->    %% 删除
%% 							delete_player_store_info(State, GoodsInfo)
%% 					end;
%% 				false ->
%% 					{fail, ?ERR_COMMON_FAIL}
%% 			end;
%% 		_ ->
%% 			{fail, ?ERR_GOODS_NOT_ENOUGH}
%% 	end.

%% 获取玩家道具信息列表
get_store_info_list() ->
	List = goods_dict:get_player_store_list(),
	Fun = fun(DbGoods) ->
		GoodsId = DbGoods#db_goods.goods_id,
		case goods_lib:check_is_equips_by_id(GoodsId) of
			true ->
				Extra = DbGoods#db_goods.extra,
				BaptizeAttrList = equips_baptize:get_equips_baptize_attr(Extra),
				#proto_goods_full_info{
					id = DbGoods#db_goods.id,
					goods_id = DbGoods#db_goods.goods_id,
					is_bind = DbGoods#db_goods.is_bind,
					num = DbGoods#db_goods.num,
					stren_lv = DbGoods#db_goods.stren_lv,
					location = DbGoods#db_goods.location,
					grid = DbGoods#db_goods.grid,
					baptize_attr_list = goods_util:attr_type_list_changed_proto_list(BaptizeAttrList),
					soul = DbGoods#db_goods.soul,
					luck = goods_util:get_equips_luck(DbGoods),
					secure = DbGoods#db_goods.secure
				};
			false ->
				#proto_goods_full_info{
					id = DbGoods#db_goods.id,
					goods_id = DbGoods#db_goods.goods_id,
					is_bind = DbGoods#db_goods.is_bind,
					num = DbGoods#db_goods.num,
					stren_lv = DbGoods#db_goods.stren_lv,
					location = DbGoods#db_goods.location,
					grid = DbGoods#db_goods.grid,
					secure = DbGoods#db_goods.secure
				}
		end
	end,
	ProtoList = [Fun(X) || X <- List],
	ProtoList.
%% 道具存入仓库
move_goods_to_store(State, Id, GoodsId, Num) ->
	case check_move_goods(State, Id, GoodsId, Num, 1) of
		{ok, GoodsInfo} ->
			GoodsId = GoodsInfo#db_goods.goods_id,
			GoodsConf = goods_lib:get_goods_conf_by_id(GoodsId),
			Type = GoodsConf#goods_conf.type,
			LimitNum = GoodsConf#goods_conf.limit_num,
			case Type == ?TYPE_EQUIPS orelse Num == LimitNum of
				true ->
					NewGoodsInfo = GoodsInfo#db_goods{location = ?STORE_LOCATION_TYPE},
					%% 道具删除字典数据
					goods_dict:delete_goods_num_to_dict(GoodsId, Id, GoodsInfo#db_goods.is_bind),

					case goods_lib:check_is_equips_by_id(GoodsId) of
						true ->
							goods_dict:delete_player_equips_list_by_info(GoodsInfo);
						false ->
							goods_dict:delete_player_goods_list_by_info(GoodsInfo)
					end,

					goods_dict:delete_bag_cell(),   %%更新背包格子
					State1 = goods_lib:broacast_goods_info_change(State, GoodsInfo#db_goods{num = 0}),%%
					%% 更新跨服数据信息
					scene_cross:ref_cross_goods(State1),
					Result = update_player_store_info(State1, NewGoodsInfo, true),
					log_lib:log_goods_change(State, GoodsId, -Num, ?LOG_TYPE_MOVE_GOODS_TO_STORE),
					Result;
				false ->
					IsBind = GoodsInfo#db_goods.is_bind,
					GoodsNum = GoodsInfo#db_goods.num,
					case add_store_goods(State, GoodsId, IsBind, Num) of
						{ok, State1} ->
							Result =
								case Num == GoodsNum of
									true ->
										goods_lib:delete_player_goods_info(State1, GoodsInfo);
									false ->
										goods_lib:update_player_goods_info(State1, GoodsInfo#db_goods{num = GoodsNum - Num})
								end,
							log_lib:log_goods_change(State, GoodsId, -Num, ?LOG_TYPE_MOVE_GOODS_TO_STORE),
							Result;
						{fail, Reply} ->
							{fail, Reply}
					end
			end;
		{fail, Reply} ->
			{fail, Reply}
	end.
%%仓库取出道具
move_goods_to_bag(State, Id, GoodsId, Num) ->
	case check_move_goods(State, Id, GoodsId, Num, 2) of
		{ok, GoodsInfo} ->
			GoodsId = GoodsInfo#db_goods.goods_id,
			GoodsConf = goods_lib:get_goods_conf_by_id(GoodsId),
			Type = GoodsConf#goods_conf.type,
			LimitNum = GoodsConf#goods_conf.limit_num,
			case Type == ?TYPE_EQUIPS orelse Num == LimitNum of
				true ->
					NewGoodsInfo = GoodsInfo#db_goods{location = ?NORMAL_LOCATION_TYPE},
					%% 道具删除字典数据
					goods_dict:delete_store_goods_num_to_dict(GoodsId, Id, GoodsInfo#db_goods.is_bind),

					goods_dict:delete_player_store_list_by_info(GoodsInfo),

					goods_dict:delete_store_bag_cell(),   %%更新仓库格子
					broacast_store_info_change(State, GoodsInfo#db_goods{num = 0}),
					goods_lib:update_player_goods_info(State, NewGoodsInfo, true);
				false ->
					IsBind = GoodsInfo#db_goods.is_bind,
					GoodsNum = GoodsInfo#db_goods.num,
					case goods_lib_log:add_goods(State, GoodsId, IsBind, Num, ?LOG_TYPE_MOVE_GOODS_TO_BAG) of
						{ok, State1} ->
							case Num == GoodsNum of
								true ->
									delete_player_store_info(State1, GoodsInfo);
								false ->
									update_player_store_info(State1, GoodsInfo#db_goods{num = GoodsNum - Num})
							end;
						{fail, Reply} ->
							{fail, Reply}
					end
			end;
		{fail, Reply} ->
			{fail, Reply}
	end.

%% ====================================================================
%% 内部函数
%% ====================================================================

%% 添加道具条件检测
check_store_cond(State, GoodsId, Num) ->
	case util:loop_functions(
		none,
		[fun(_)
			-> GoodsConfig = goods_lib:get_goods_conf_by_id(GoodsId),
			case GoodsConfig =/= [] of
				true ->
					{continue, GoodsConfig};
				false ->
					{break, ?ERR_GOODS_NOT_EXIST}                 %% 非道具
			end
		end,
			fun(GoodsConfig) ->
				LimitNum = GoodsConfig#goods_conf.limit_num,
				case LimitNum > 0 andalso Num =< LimitNum of
					true ->
						{continue, GoodsConfig};
					false ->
						{break, ?ERR_GOODS_NOT_EXIST}                 %% 配置错误
				end
			end,
			fun(GoodsConfig) ->
				case get_store_can_use_cell(State) >= 1 of
					false ->
						{break, ?ERR_PLAYER_STORE_BAG_NOT_ENOUGH};
					true ->
						{continue, GoodsConfig}
				end
			end
		]) of
		{break, Reply} -> {fail, Reply};
		{ok, Value} ->
			{ok, Value}
	end.

%% 背包仓库互换基础条件检测
check_move_goods(State, Id, GoodsId, Num, Type) ->
	case util:loop_functions(
		none,
		[fun(_) ->
			%% 限时道具不给仓库操作
			GoodsConf = goods_lib:get_goods_conf_by_id(GoodsId),
			case GoodsConf#goods_conf.is_timeliness == 0 of
				true ->
					{continue, none};
				false ->
					{break, ?ERR_COMMON_FAIL}
			end
		end,
			fun(_) ->
				case Type of
					1 ->  %% 背包 -> 仓库
						case get_store_can_use_cell(State) >= 1 of
							true ->
								{continue, none};
							false ->
								{break, ?ERR_PLAYER_STORE_BAG_NOT_ENOUGH}
						end;
					2 ->  %% 仓库 -> 背包
						case get_bag_can_use_cell(State) >= 1 of
							true ->
								{continue, none};
							false ->
								{break, ?ERR_PLAYER_BAG_NOT_ENOUGH}
						end
				end
			end,
			fun(_) ->
				case Type of
					1 ->  %% 背包 -> 仓库
						case goods_lib:get_player_goods_info(Id, GoodsId, false) of %%
							{fail, Err1} ->
								{break, Err1};
							GoodsInfo ->
								{continue, GoodsInfo}
						end;
					2 ->  %% 仓库 -> 背包
						case get_player_store_goods_info(Id) of
							#db_goods{} = GoodsInfo ->
								{continue, GoodsInfo};
							_ ->
								{break, ?ERR_GOODS_NOT_EXIST}
						end
				end
			end,
			fun(GoodsInfo) ->
				case GoodsInfo#db_goods.location =/= ?EQUIPS_LOCATION_TYPE of
					true ->
						{continue, GoodsInfo};
					false ->
						{break, ?ERR_COMMON_FAIL}
				end
			end,
			fun(GoodsInfo) ->
				case GoodsInfo#db_goods.num >= Num of
					true ->
						{continue, GoodsInfo};
					false ->
						{break, ?ERR_GOODS_NOT_ENOUGH}
				end
			end
		]) of
		{break, Reply} -> {fail, Reply};
		{ok, Value} ->
			{ok, Value}
	end.

%% 添加道具信息
add_player_store_info(State, GoodsId, IsBind, Num, Extra) ->
	Id = get_new_goods_key(),
	PlayerId = State#player_state.player_id,

	GoodsInfo = #db_goods{
		id = Id,
		player_id = PlayerId,
		goods_id = GoodsId,
		is_bind = IsBind,
		num = Num,
		extra = Extra,
		location = ?STORE_LOCATION_TYPE,
		update_time = util_date:unixtime(),
		server_id = 0
	},
	%% 存库
	goods_cache:insert(GoodsInfo),

	%% 道具导入进程字典
	goods_dict:update_store_num_to_dict(GoodsId, Id, IsBind, Num),

	%% 更新列表
	goods_dict:update_player_store_list_by_info(GoodsInfo),

	%% 更新背包格子
	goods_dict:add_store_bag_cell(),

	%% 广播
	broacast_store_info_change(State, GoodsInfo),

	{ok, State}.

%% 更新玩家道具信息
update_player_store_info(State, GoodsInfo) ->
	Id = GoodsInfo#db_goods.id,
	PlayerId = GoodsInfo#db_goods.player_id,
	GoodsId = GoodsInfo#db_goods.goods_id,
	Num = GoodsInfo#db_goods.num,
	IsBind = GoodsInfo#db_goods.is_bind,

	%% 存库
	goods_cache:update(Id, PlayerId, GoodsInfo),

	goods_dict:update_store_num_to_dict(GoodsId, Id, IsBind, Num),

	goods_dict:update_player_store_list_by_info(GoodsInfo),

	%% 广播
	broacast_store_info_change(State, GoodsInfo),

	{ok, State}.

%% 更新玩家道具信息
update_player_store_info(State, GoodsInfo, BoolCell) ->
	Id = GoodsInfo#db_goods.id,
	PlayerId = GoodsInfo#db_goods.player_id,
	GoodsId = GoodsInfo#db_goods.goods_id,
	Num = GoodsInfo#db_goods.num,
	IsBind = GoodsInfo#db_goods.is_bind,

	%% 存库
	goods_cache:update(Id, PlayerId, GoodsInfo),

	goods_dict:update_store_num_to_dict(GoodsId, Id, IsBind, Num),

	goods_dict:update_player_store_list_by_info(GoodsInfo),

	case BoolCell of
		true ->
			%% 更新仓库格子
			goods_dict:add_store_bag_cell();
		false ->
			skip
	end,

	%% 广播
	broacast_store_info_change(State, GoodsInfo),

	{ok, State}.

%% 删除玩家道具信息
delete_player_store_info(State, GoodsInfo) ->
	Id = GoodsInfo#db_goods.id,
	PlayerId = GoodsInfo#db_goods.player_id,
	GoodsId = GoodsInfo#db_goods.goods_id,
	IsBind = GoodsInfo#db_goods.is_bind,

	%% 存库
	goods_cache:delete(Id, PlayerId),

	%% 道具删除字典数据
	goods_dict:delete_store_goods_num_to_dict(GoodsId, Id, IsBind),

	goods_dict:delete_player_store_list_by_info(GoodsInfo),

	%% 更新背包格子
	goods_dict:delete_store_bag_cell(),

	%% 广播
	broacast_store_info_change(State, GoodsInfo#db_goods{num = 0}),

	{ok, State}.

%% 获取仓库道具记录
get_player_store_goods_info(Id) ->
	case lists:keyfind(Id, #db_goods.id, goods_dict:get_player_store_list()) of
		false ->
			[];
		Info ->
			Info
	end.

%% 获取仓库格子数
get_store_cell(State) ->
	Base = State#player_state.db_player_base,
	VipNum = vip_lib:get_vip_store_num(Base#db_player_base.career, Base#db_player_base.vip),
	?STORE_BAG + VipNum.

%% 获取仓库剩余格子数
get_store_can_use_cell(State) ->
	%% vip仓库增加
	AllCell = get_store_cell(State),
	UseCell = goods_dict:get_store_bag_cell(),
	AllCell - UseCell.

%% 获取背包可用格子数
get_bag_can_use_cell(State) ->
	PlayerBase = State#player_state.db_player_base,
	AllCell = PlayerBase#db_player_base.bag,
	UseCell = goods_dict:get_bag_cell(),
	AllCell - UseCell.

%% 获取新的道具唯一ID
get_new_goods_key() ->
	uid_lib:get_uid(?UID_TYPE_PLAYER_GOODS).

%% 广播玩家道具信息变更
broacast_store_info_change(PlayerState, DbGoods) ->
	GoodsId = DbGoods#db_goods.goods_id,
	ProtoInfo =
		case goods_lib:check_is_equips_by_id(GoodsId) of
			true ->
				Extra = DbGoods#db_goods.extra,
				BaptizeAttrList = equips_baptize:get_equips_baptize_attr(Extra),
				#proto_goods_full_info{
					id = DbGoods#db_goods.id,
					goods_id = DbGoods#db_goods.goods_id,
					is_bind = DbGoods#db_goods.is_bind,
					num = DbGoods#db_goods.num,
					stren_lv = DbGoods#db_goods.stren_lv,
					location = DbGoods#db_goods.location,
					grid = DbGoods#db_goods.grid,
					baptize_attr_list = goods_util:attr_type_list_changed_proto_list(BaptizeAttrList),
					soul = DbGoods#db_goods.soul,
					luck = goods_util:get_equips_luck(DbGoods),
					secure = DbGoods#db_goods.secure
				};
			false ->
				#proto_goods_full_info{
					id = DbGoods#db_goods.id,
					goods_id = DbGoods#db_goods.goods_id,
					is_bind = DbGoods#db_goods.is_bind,
					num = DbGoods#db_goods.num,
					stren_lv = DbGoods#db_goods.stren_lv,
					location = DbGoods#db_goods.location,
					grid = DbGoods#db_goods.grid,
					secure = DbGoods#db_goods.secure
				}
		end,
	net_send:send_to_client(PlayerState#player_state.socket, 14041, #rep_broadcast_store_goods_info{goods_info = ProtoInfo}).

%% 检测仓库道具是否足够
is_store_goods_enough(GoodsId, Num) ->
	goods_lib:get_store_goods_num(GoodsId) >= Num.

delete_store_goods_by_num(State, GoodsId, Num) ->
	case is_store_goods_enough(GoodsId, Num) of
		true ->
			BindList = goods_dict:get_value_from_store_dict_by_id(GoodsId, ?BIND),
			NotBindList = goods_dict:get_value_from_store_dict_by_id(GoodsId, ?NOT_BIND),
			GoodsNumList = BindList ++ NotBindList,
			case delete_store_goods_by_num_1(State, GoodsId, Num, GoodsNumList) of
				{ok, State1} ->
					{ok, State1};
				Reply ->
					Reply
			end;
		false ->
			{fail, ?ERR_GOODS_NOT_ENOUGH}
	end.

delete_store_goods_by_num_1(State, _GoodsId, 0, _GoodsNumList) ->
	{ok, State};
delete_store_goods_by_num_1(State, GoodsId, Num, [H | T]) ->
	{Id, GoodsNum} = H,
	case get_player_store_goods_info(Id) of
		#db_goods{} = GoodsInfo ->
			case GoodsNum > Num andalso GoodsInfo#db_goods.location =:= ?STORE_LOCATION_TYPE of
				true ->
					update_player_store_info(State, GoodsInfo#db_goods{num = GoodsNum - Num});
				false ->
					{ok, State1} = delete_player_store_info(State, GoodsInfo),
					delete_store_goods_by_num_1(State1, GoodsId, Num - GoodsNum, T)
			end;
		_ ->
			{fail, ?ERR_GOODS_NOT_EXIST}
	end.