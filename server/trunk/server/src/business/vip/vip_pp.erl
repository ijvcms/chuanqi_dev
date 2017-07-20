%%%-------------------------------------------------------------------
%%%-------------------------------------------------------------------
%%%-------------------------------------------------------------------
%%% @author yubing
%%% @copyright (C) 2016, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 05. 一月 2016 14:16
%%%-------------------------------------------------------------------
-module(vip_pp).


-include("proto.hrl").
-include("record.hrl").
-include("common.hrl").
-include("cache.hrl").
-include("config.hrl").
-include("language_config.hrl").
%% API
-export([handle/3]).

%% 获取vip信息
handle(29001, PlayerState, Data) ->
	VipLv = Data#req_get_vip_state.vip_lv,
	Result = vip_lib:get_vip_state(PlayerState, VipLv),
	Base = PlayerState#player_state.db_player_base,
	?INFO("29001Result ~p", [Result]),
	net_send:send_to_client(PlayerState#player_state.socket, 29001, #rep_get_vip_state{result = Result, vip_exp = Base#db_player_base.vip_exp});

%% 领取奖励
handle(29002, PlayerState, Data) ->
	?INFO("29002 ~p", [Data]),
	VipLv = Data#req_receive_vip_goods.vip_lv,
	{ok, PlayerState1, Result} = vip_lib:receive_vip_goods(PlayerState, VipLv),
	net_send:send_to_client(PlayerState#player_state.socket, 29002, #rep_receive_vip_goods{result = Result}),
	{ok, PlayerState1};

%% 清理pk值
handle(29004, PlayerState, _Data) ->
	case vip_lib:clear_pk(PlayerState) of
		{ok, PlayerState1} ->
			net_send:send_to_client(PlayerState1#player_state.socket, 29002, #rep_clear_pk{result = ?ERR_COMMON_SUCCESS}),
			{ok, PlayerState1};
		{fail, Err} ->
			net_send:send_to_client(PlayerState#player_state.socket, 29002, #rep_clear_pk{result = Err})
	end;

%% 小飞鞋
handle(29005, PlayerState, Data) ->
	SceneId = Data#req_flying_shoes.scene_id,
	X = Data#req_flying_shoes.x,
	Y = Data#req_flying_shoes.y,
	IsEquip = Data#req_flying_shoes.is_equip,
	Point = case {X, Y} =:= {0, 0} of
				true ->
					null;
				_ ->
					{X, Y}
			end,
	?INFO("29005 ~p", [Data]),
	case vip_lib:check_change_scene(PlayerState, IsEquip) of
		{PlayerState1, ItemLoss} when is_record(PlayerState1, player_state) ->
			case cross_lib:change_scene_11031(PlayerState1, SceneId, ItemLoss, Point, true, IsEquip =:= 1) of
				{ok, PlayerState2} ->
					?INFO("29005 111 ~p", [222]),
					net_send:send_to_client(PlayerState1#player_state.socket, 29005, #rep_flying_shoes{}),
					{ok, PlayerState2};
				{fail, Err} ->
					?INFO("29005 111 ~p", [Err]),
					net_send:send_to_client(PlayerState1#player_state.socket, 29005, #rep_flying_shoes{result = Err}),
					{ok, PlayerState1};
				Err ->
					?INFO("~p", [Err]),
					{ok, PlayerState1}
			end;
		{fail, Err} ->
			?INFO("29005 111 ~p", [Err]),
			net_send:send_to_client(PlayerState#player_state.socket, 29005, #rep_flying_shoes{result = Err})
	end;


%% 获取vip信息
handle(29006, PlayerState, Data) ->
	VipExp = Data#req_add_vip_exp.vip_exp,
	PlayerState1 = vip_lib:add_vip_exp(PlayerState, VipExp),
	{ok, PlayerState1};

handle(Cmd, PlayerState, Data) ->
	?ERR("not define ~p cmd:~nstate: ~p~ndata: ~p", [Cmd, PlayerState, Data]),
	{ok, PlayerState}.

