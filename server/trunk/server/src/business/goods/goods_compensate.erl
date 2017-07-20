%%%-------------------------------------------------------------------
%%% @author tuhujia
%%% @copyright (C) 2016, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 19. 九月 2016 09:31
%%%-------------------------------------------------------------------
-module(goods_compensate).

-include("common.hrl").
-include("record.hrl").
-include("proto.hrl").
-include("cache.hrl").
-include("db_record.hrl").
-include("config.hrl").
-include("uid.hrl").
-include("language_config.hrl").
-include("button_tips_config.hrl").
-include("log_type_config.hrl").
-include("notice_config.hrl").

%% API
-export([
	mounts_compensate/1
]).

%% ====================================================================
%% API functions
%% ====================================================================

%% 20160919 旧版坐骑补偿(308000 308001)
mounts_compensate(GoodsInfo) ->
	case GoodsInfo#db_goods.goods_id of
		308000 ->
			%% 删除旧的坐骑
			goods_cache:delete(GoodsInfo#db_goods.id, GoodsInfo#db_goods.player_id),
			mail_lib:send_mail_to_player(GoodsInfo#db_goods.player_id, 102),
			ok;
		308001 ->
			%% 删除旧的坐骑
			goods_cache:delete(GoodsInfo#db_goods.id, GoodsInfo#db_goods.player_id),
			mail_lib:send_mail_to_player(GoodsInfo#db_goods.player_id, 103),
			ok;
		_ ->
			skip
	end.