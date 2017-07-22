%%%-------------------------------------------------------------------
%%% @author yubing
%%% @copyright (C) 2015, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 08. 十二月 2015 10:27
%%%-------------------------------------------------------------------
-module(set_lib).
-export([
	update_player_hpmp/3,
	update_player_pickup_sell/2,
	update_player_equip_sell/2,
	is_equip_sell/2,
	use_code/2,
	check_hpmp_button_tips/2,
	get_hpmp1_button_tips/1,
	get_hpmp2_button_tips/1,
	get_hpmp3_button_tips/1,
	init/0]).

-include("cache.hrl").
-include("record.hrl").
-include("proto.hrl").
-include("config.hrl").
-include("common.hrl").
-include("language_config.hrl").
-include("log_type_config.hrl").
-include("button_tips_config.hrl").

init() ->
	inets:start(),
	ssl:start().

%% 修改玩家的药品设置信息
update_player_hpmp(PlayerState, HpSet, HpMpSet) ->
	Update = #player_state{
		db_player_base = #db_player_base
		{
			hp_set = HpSet,
			hpmp_set = HpMpSet
		}
	},
	{ok, NewPlayerState} = player_lib:update_player_state(PlayerState, Update),
	check_hpmp_button_tips(NewPlayerState),
	{ok, NewPlayerState}.

check_hpmp_button_tips(PlayerState) ->
	button_tips_lib:ref_button_tips(PlayerState, ?BIN_AUTO_DRINK_RED),
	button_tips_lib:ref_button_tips(PlayerState, ?BIN_AUTO_DRINK_BLUE),
	button_tips_lib:ref_button_tips(PlayerState, ?BIN_AUTO_DRINK_SUN).

check_hpmp_button_tips(PlayerState, GoodsId) ->
	AotoType = get_auto_goods(GoodsId),
	case AotoType of
		1 -> button_tips_lib:ref_button_tips(PlayerState, ?BIN_AUTO_DRINK_RED);
		2 -> button_tips_lib:ref_button_tips(PlayerState, ?BIN_AUTO_DRINK_BLUE);
		3 -> button_tips_lib:ref_button_tips(PlayerState, ?BIN_AUTO_DRINK_SUN);
		_ -> skip
	end.

get_hpmp1_button_tips(PlayerState) ->
	#player_state{db_player_base = #db_player_base{hp_set = HpSet}} = PlayerState,
	{proto_hp_set,Open1,_,GoodsId1_1,_, _GoodsId1_2} = HpSet,
	case Open1 =:= 1 andalso (GoodsId1_1 =:= 0 orelse goods_lib:get_goods_num(GoodsId1_1) =:= 0) of
		true ->
			Num = goods_lib:get_goods_num(110004) + goods_lib:get_goods_num(110076),
			{PlayerState, Num};
		false ->
			{PlayerState, 0}
	end.

get_hpmp2_button_tips(PlayerState) ->
	#player_state{db_player_base = #db_player_base{hp_set = HpSet}} = PlayerState,
	{proto_hp_set,Open1,_,_GoodsId1_1,_, GoodsId1_2} = HpSet,
	case Open1 =:= 1 andalso (GoodsId1_2 =:= 0 orelse goods_lib:get_goods_num(GoodsId1_2) =:= 0) of
		true ->
			Num = goods_lib:get_goods_num(110005) + goods_lib:get_goods_num(110077),
			{PlayerState, Num};
		false ->
			{PlayerState, 0}
	end.

get_hpmp3_button_tips(PlayerState) ->
	#player_state{db_player_base = #db_player_base{hpmp_set = HpMpSet}} = PlayerState,
	{proto_hpmp_set,Open2,_,GoodsId2_1} = HpMpSet,
	case Open2 =:= 1 andalso (GoodsId2_1 =:= 0 orelse goods_lib:get_goods_num(GoodsId2_1) =:= 0) of
		true ->
			Num = goods_lib:get_goods_num(110006) + goods_lib:get_goods_num(110007) + goods_lib:get_goods_num(110193),
			{PlayerState, Num};
		false ->
			{PlayerState, 0}
	end.

get_auto_goods(110004) -> 1;
get_auto_goods(110076) -> 1;
get_auto_goods(110005) -> 2;
get_auto_goods(110077) -> 2;
get_auto_goods(110006) -> 3;
get_auto_goods(110007) -> 3;
get_auto_goods(110193) -> 3;
get_auto_goods(_) -> 0.

%% 修改玩家的装备出售，自动拾取设置信息
update_player_pickup_sell(PlayerState, PickupSet) ->
	Update = #player_state{
		db_player_base = #db_player_base
		{
			pickup_set = PickupSet
		}
	},
	player_lib:update_player_state(PlayerState, Update).

%% 修改玩家的装备出售设置信息
update_player_equip_sell(PlayerState, EquipSellSet) ->
	Update = #player_state{
		db_player_base = #db_player_base
		{
			equip_sell_set = EquipSellSet
		}
	},
	player_lib:update_player_state(PlayerState, Update).

%% 使用兑换码
use_code(PlayerState, Code) ->
	try
		%% erlang原生代码
		%% inets:start(),
		%% ssl:start(),
		%% 组合兑换码参数
		TestData = lists:concat([
			"code=", Code,
			"&platform_id=", PlayerState#player_state.platform,
			"&player_id=", PlayerState#player_state.player_id,
			"&service_id=", config:get_server_no()
		]),
		%%td20150239code=11212323&platform_id=10&player_id=111&service_id=1004
		%% 添加key属性信息
		TestData1 = lists:concat(["td20150239", TestData]),
		?INFO("testdata1 ~p", [TestData1]),
		%% md5 处理
		TestData2 = lists:concat([TestData, "&sign=", my_md5:md5(TestData1)]),
		%%{ok, {_,_,Body}}
		%% http请求 获取内容
		{ok, {_, _, Body}} = httpc:request(post, {"http://123.206.225.144/chuanqi_mg/index.php/Home/Index/usecode",
			[], "application/x-www-form-urlencoded", TestData2}, [], []),

		?INFO("dd 22 ~ts", [Body]),
		Data = string:tokens(Body, "&"),
		%% 分离内容 获取头
		[Result | H] = Data,
		case erlang:list_to_integer(Result) of
			0 -> %% 兑换成功 获取物品列表
				[GoodsList | _] = H,
				?INFO("dd goodslist ~p", [GoodsList]),
				GoodsList1 = util_data:string_to_term(GoodsList),

				{ok, PlayerState1}=goods_lib_log:add_goods_list_and_send_mail(PlayerState, GoodsList1,?LOG_TYPE_CODE),
				{ok, PlayerState1, ?ERR_COMMON_SUCCESS};
			Result1 -> %% 错误 返回错误码
				?INFO("dd 33 ~p", [Result1]),
				{ok, PlayerState, Result1}
		end
	catch
		Error:Info ->
			?ERR("~p:~p, stacktrace:~p~n", [Error, Info, erlang:get_stacktrace()]),
			{ok, PlayerState, ?ERR_CODE105}
	end.


%% 检测装备是否直接卖出
is_equip_sell(EquipSellSet, GoodsConf) ->
	if
		GoodsConf#goods_conf.type =:= ?EQUIPS_TYPE ->
			if
				GoodsConf#goods_conf.quality =:= 1 ->
					case EquipSellSet#proto_equip_sell_set.white =:= 1 of
						true ->
							true;
						_ ->
							false
					end;
				GoodsConf#goods_conf.quality =:= 2 ->
					case EquipSellSet#proto_equip_sell_set.green =:= 1 of
						true ->
							true;
						_ ->
							false
					end;
				GoodsConf#goods_conf.quality =:= 3 ->
					case EquipSellSet#proto_equip_sell_set.blue =:= 1 of
						true ->
							true;
						_ ->
							false
					end;
				true ->
					case EquipSellSet#proto_equip_sell_set.purple =:= 1 of
						true ->
							true;
						_ ->
							false
					end
			end;
		true ->
			false
	end.








