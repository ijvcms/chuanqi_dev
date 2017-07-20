%%%-------------------------------------------------------------------
%%% @author qhb
%%% @copyright (C) 2017, <COMPANY>
%%% @doc
%%%	数据管理工具,客户端调用
%%% @end
%%% Created : 04. 三月 2017 上午10:28
%%%-------------------------------------------------------------------
-module(restore_client).
-include("dev.hrl").

%% API
-compile([export_all]).

%%验证所有用户
validate_players() ->
	TargetServerIdList = config:get_merge_servers(),
	ConfigList = [R || R<- restore_batch_config:get_list_conf(),
		lists:member(R#restore_batch_conf.target_serverid, TargetServerIdList) ],
	lists:foreach(fun(Config) ->
		#restore_batch_conf{player_id = PlayerId, target_serverid = TargetServerId, source_serverid = SourceServerId} = Config,
		io:format("player ~p(~p <- ~p) ~n",[PlayerId, TargetServerId,SourceServerId]),
		restore_client_tool:validate_player(PlayerId, TargetServerId, SourceServerId)
	end, ConfigList).

%%还原神皇秘境相关数据
restore_20170228() ->
	TargetServerIdList = config:get_merge_servers(),
	ConfigList = [R || R<- restore_batch_config:get_list_conf(),
		lists:member(R#restore_batch_conf.target_serverid, TargetServerIdList) ],
	lists:foreach(fun(Config) ->
		#restore_batch_conf{player_id = PlayerId, target_serverid = TargetServerId, source_serverid = SourceServerId,
			goods_clear = GoodsClear, goods_replace = GoodsReplace, goods_add = GoodsAdd} = Config,
		%%清除非法所得
		restore_client_tool:clear_goods(PlayerId, TargetServerId, GoodsClear),
		%%还原物品(特戒)
		restore_client_tool:update_goods_low(PlayerId, TargetServerId, SourceServerId, GoodsReplace),
		%%还原马
		restore_client_tool:replace_mounts(PlayerId, TargetServerId, SourceServerId),
		%%新增或补偿
		restore_client_tool:send_goods_mail(PlayerId, TargetServerId, GoodsAdd),
		%%返回这段时间正常消耗的积分
		restore_client_tool:update_player_shmj(PlayerId, TargetServerId, SourceServerId),
		%%清除特定绑定属性的物品,如玄冰铁+7(110095)
		restore_client_tool:clear_goods_bind(PlayerId, TargetServerId, [110095], 1),
		io:format("player ~p(~p) complete ~n",[PlayerId, TargetServerId])
		end, ConfigList),
	ok.

%%还原单个玩家
restore_player(PlayerId) ->
	case restore_batch_config:get(PlayerId) of
		#restore_batch_conf{player_id = PlayerId, target_serverid = TargetServerId, source_serverid = SourceServerId,
			goods_clear = GoodsClear, goods_replace = GoodsReplace, goods_add = GoodsAdd} ->
			restore_client_tool:clear_goods(PlayerId, TargetServerId, GoodsClear),
			restore_client_tool:update_goods_low(PlayerId, TargetServerId, SourceServerId, GoodsReplace),
			restore_client_tool:replace_mounts(PlayerId, TargetServerId, SourceServerId),
			restore_client_tool:send_goods_mail(PlayerId, TargetServerId, GoodsAdd),
			restore_client_tool:update_player_shmj(PlayerId, TargetServerId, SourceServerId),
			restore_client_tool:clear_goods_bind(PlayerId, TargetServerId, [110095], 1),
			ok;
		_ ->
			skip
	end.

%%清除最新发的邮件(如发错的邮件)
clear_mail_from(PlayerId, DateTime) ->
	case restore_batch_config:get(PlayerId) of
		#restore_batch_conf{player_id = PlayerId, target_serverid = TargetServerId} ->
			restore_client_tool:clear_mail_from(PlayerId, TargetServerId, DateTime),
			ok;
		_ ->
			skip
	end.