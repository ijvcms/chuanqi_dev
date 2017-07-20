%%%-------------------------------------------------------------------
%%% @author qhb
%%% @copyright (C) 2016, <COMPANY>
%%% @doc
%%%	玩家的扩展属性或状态,可随时动态增加,不需要耦合在玩家的属性协议里
%%% @end
%%% Created : 19. 十一月 2016 下午9:52
%%%-------------------------------------------------------------------
-module(player_extra_lib).
-author("qhb").
-include("record.hrl").
-include("proto.hrl").
%%
%% API
-export([
	request/2
]).

%%请求服务端发送状态数据，参数为需要推送的协议
request(PlayerState, ProList) ->
	lists:foreach(fun(Pro) ->
		push(Pro, PlayerState)
	end, ProList).


%%临时加,推送开服第几天
push(11056, PlayerState) ->
	{{OpenY, OpenM, OpenD}, {_, _, _}} = config:get_start_time_str(),
	BeginTime = util_date:time_tuple_to_unixtime({{OpenY, OpenM, OpenD}, {0, 0, 0}}),
	Day = max(1, util_erl:ceil((util_date:unixtime() - BeginTime) / 86400)),
	Rep = #rep_instance_king_round_time_left{time_left = Day},
	net_send:send_to_client(PlayerState#player_state.socket, 11056, Rep);
%%推送王城乱斗的排行
push(11057, PlayerState) ->
	instance_king_lib:push_player_rank(PlayerState);
%%结盟状态
push(17092, PlayerState) ->
	alliance_lib:check_state(PlayerState);
push(_ProId, _) ->
	ok.