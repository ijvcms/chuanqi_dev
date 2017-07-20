%%%-------------------------------------------------------------------
%%% @author qhb
%%% @copyright (C) 2017, <COMPANY>
%%% @doc
%%%	客户端工具类
%%% @end
%%% Created : 04. 三月 2017 上午9:37
%%%-------------------------------------------------------------------
-module(restore_client_tool).
-include("common.hrl").
-include("cache.hrl").

%% API
-compile([export_all]).


%%------------------------------------------------
%%测试用记是否存在
validate_player(PlayerId, TargetServerId, SrcServerId) ->
	Pool = get_pool(SrcServerId),
	case source_db:select_player(Pool, PlayerId) of
		#db_player_base{} ->
			skip;
		_ ->
			io:format("source:not exist player ~p(~p) ~n",[PlayerId, SrcServerId])
	end,
	Remote = get_remote(TargetServerId),
	rpc:call(Remote, data_tool, validate_player, [PlayerId]).


%%清除指定物品
clear_goods(PlayerId, TargetServerId, GoodsIdList) ->
	case GoodsIdList of
		[] ->
			skip;
		_ ->
			Remote = get_remote(TargetServerId),
			rpc:call(Remote, data_tool, clear_goods, [PlayerId, GoodsIdList])
	end.

%%清除指定绑定属性的物品
clear_goods_bind(PlayerId, TargetServerId, GoodsIdList, IsBind) ->
	case GoodsIdList of
		[] ->
			skip;
		_ ->
			Remote = get_remote(TargetServerId),
			rpc:call(Remote, data_tool, clear_goods_bind, [PlayerId, GoodsIdList, IsBind])
	end.

%%替换指定物品
update_goods(PlayerId, TargetServerId, SrcServerId, GoodsIdList) ->
	case GoodsIdList of
		[] ->
			skip;
		_ ->
			GoodsInfoList = get_source_goods_info_list(PlayerId, SrcServerId, GoodsIdList),
			Remote = get_remote(TargetServerId),
			rpc:call(Remote, data_tool, update_goods_list_by_goods_info, [PlayerId, GoodsInfoList])
	end.

%%替换指定物品
update_goods_low(PlayerId, TargetServerId, SrcServerId, GoodsIdList) ->
	case GoodsIdList of
		[] ->
			skip;
		_ ->
			GoodsInfoList = get_source_goods_info_list(PlayerId, SrcServerId, GoodsIdList),
			Remote = get_remote(TargetServerId),
			rpc:call(Remote, data_tool, update_goods_list_by_goods_info_low, [PlayerId, GoodsInfoList])
	end.

%%替换指定物品
replace(PlayerId, TargetServerId, SrcServerId, GoodsIdList) ->
	case GoodsIdList of
		[] ->
			skip;
		_ ->
			clear_goods(PlayerId, TargetServerId, GoodsIdList),

			GoodsInfoList = get_source_goods_info_list(PlayerId, SrcServerId, GoodsIdList),
			add_goods_list_by_goods_info(PlayerId, TargetServerId, GoodsInfoList)
	end.

%%替换马
replace_mounts(PlayerId, TargetServerId, SrcServerId) ->
	Mounts = data_config:get_goods_mounts(),
	replace(PlayerId, TargetServerId, SrcServerId, Mounts).

%%更新特殊属性
update_player_shmj(PlayerId, TargetServerId, SrcServerId) ->
	Pool = get_pool(SrcServerId),
	#db_player_base{lottery_score_use_1 = LotteryScoreUse} = source_db:select_player(Pool, PlayerId),
	Remote = get_remote(TargetServerId),
	rpc:call(Remote, data_tool, update_player_shmj, [PlayerId, LotteryScoreUse]).

clear_mail_from(PlayerId, TargetServerId, DateTime) ->
	Remote = get_remote(TargetServerId),
	rpc:call(Remote, data_tool, clear_mail_from, [PlayerId, DateTime]).

send_goods_mail(PlayerId, TargetServerId, GoodsList) ->
	Remote = get_remote(TargetServerId),
	rpc:call(Remote, data_tool, send_goods_mail, [PlayerId, GoodsList]).

%%add
%% add_goods(PlayerId, TargetServerId, GoodsList) ->
%% 	case GoodsList of
%% 		[] ->
%% 			skip;
%% 		_ ->
%% 			Remote = get_remote(TargetServerId),
%% 			rpc:call(Remote, data_tool, add_goods_list, [PlayerId, GoodsList])
%% 	end.

add_goods_list_by_goods_info(PlayerId, TargetServerId, GoodsInfoList) ->
	Remote = get_remote(TargetServerId),
	rpc:call(Remote, data_tool, add_goods_list_by_goods_info, [PlayerId, GoodsInfoList]).

get_source_player(SrcServerId, PlayerId) ->
	Pool = get_pool(SrcServerId),
	source_db:select_player(Pool, PlayerId).

%%------------------------------------------------
get_remote(TargetServerId) ->
	TargetName = lists:concat(["normal_", TargetServerId]),
	TargetStr = re:replace(util_data:to_list(node()), "restore_1", TargetName, [global, {return, list}]),
	util_data:to_atom(TargetStr).

get_pool(ServerId) ->
	Pool = list_to_atom(lists:concat([pool, ServerId])),
	Pool.

get_source_goods_info_list(PlayerId, SrcServerId, GoodsIdList) ->
	Pool = get_pool(SrcServerId),
	case source_db:select_all_goods(Pool, PlayerId) of
		[] ->
			[];
		List ->
			[DbGoods || DbGoods <- List, lists:member(DbGoods#db_goods.goods_id, GoodsIdList)]
	end.