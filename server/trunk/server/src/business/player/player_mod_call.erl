%%%-------------------------------------------------------------------
%%% @author zhengsiying
%%% @copyright (C) 2015, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 24. 七月 2015 上午11:20
%%%-------------------------------------------------------------------
-module(player_mod_call).

-include("common.hrl").
-include("record.hrl").
-include("cache.hrl").

%% API
-export([
	handle/3
]).

%% ====================================================================
%% API functions
%% ====================================================================
handle({reenter, Socket, SocketPid, OsType}, _From, PlayerState) ->
	PlayerId = PlayerState#player_state.player_id,
	{ok, NewPlayerBase} = player_base_cache:update(PlayerId, #db_player_base{os_type = OsType, last_login_time = util_date:unixtime()}),
	PlayerState1 = PlayerState#player_state{db_player_base = NewPlayerBase, socket = Socket, socket_pid = SocketPid},

	case PlayerState#player_state.socket_pid /= SocketPid of
		true ->
			gen_server2:cast(PlayerState#player_state.socket_pid, {socket_closed});
		_ ->
			skip
	end,
	HookState = player_lib:get_hook_state(),
	{ok, PlayerState2} = hook_lib:update_last_hook_time(PlayerState1, HookState),

	DbPlayerAttr = PlayerState2#player_state.db_player_attr,
	?INFO("reenter: ~p", [DbPlayerAttr#db_player_attr.cur_hp]),
	case DbPlayerAttr#db_player_attr.cur_hp =< 0 of
		true ->
			Attr = PlayerState2#player_state.attr_total,
			DbUpdate1 = #db_player_attr{cur_hp = Attr#attr_base.hp},
			{ok, NewDbPlayerAttr} = player_attr_cache:update(PlayerId, DbUpdate1),
			{ok, PlayerState2#player_state{db_player_attr = NewDbPlayerAttr}};
		_ ->
			{ok, PlayerState2}
	end;

handle({get_trade_info}, _From, PlayerState) ->
	DbBase = PlayerState#player_state.db_player_base,
	DbMoney = PlayerState#player_state.db_player_money,
	AllCell = DbBase#db_player_base.bag,
	UseCell = goods_dict:get_bag_cell(),
	Cell = AllCell - UseCell,
	Jade = DbMoney#db_player_money.jade,
	GoodsList = goods_lib:get_goods_list(?NORMAL_LOCATION_TYPE, ?NOT_BIND),
	Result = [Cell, Jade, GoodsList],
	{ok, PlayerState, Result};

%% 获取玩家的军团id
handle({get_legion_id}, _From, PlayerState) ->
	DbBase = PlayerState#player_state.db_player_base,
	{ok, PlayerState, DbBase#db_player_base.legion_id};

handle(_Request, _From, PlayerState) ->
	{ok, PlayerState}.

%% ====================================================================
%% Internal functions
%% ====================================================================
