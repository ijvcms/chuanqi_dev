%%%-------------------------------------------------------------------
%%% @author zhengsiying
%%% @doc
%%%		自动生成文件，不要手动修改
%%% @end
%%% Created : 2016/10/12
%%%-------------------------------------------------------------------

-module(city_officer_config).

-include("common.hrl").
-include("config.hrl").

-compile([export_all]).

get_list_conf() ->
	[ city_officer_config:get(X) || X <- get_list() ].

get_list() ->
	[1, 2, 3, 4].

get(1) ->
	#city_officer_conf{
		id = 1,
		num = 1,
		name = xmerl_ucs:to_utf8("城主"),
		isshow = 1,
		day_reward_goods = [{110009,0,500000},{110088,1,1},{110049,1,3}],
		frist_reward_goods = [{110008,0,5000}],
		every_reward_goods = [{305010,1,1}]
	};

get(2) ->
	#city_officer_conf{
		id = 2,
		num = 1,
		name = xmerl_ucs:to_utf8("副城主"),
		isshow = 0,
		day_reward_goods = [{110009,0,300000},{110085,1,1},{110049,1,2}],
		frist_reward_goods = [],
		every_reward_goods = []
	};

get(3) ->
	#city_officer_conf{
		id = 3,
		num = 3,
		name = xmerl_ucs:to_utf8("大臣"),
		isshow = 0,
		day_reward_goods = [{110009,0,200000},{110083,1,1},{110049,1,1}],
		frist_reward_goods = [],
		every_reward_goods = []
	};

get(4) ->
	#city_officer_conf{
		id = 4,
		num = 999,
		name = xmerl_ucs:to_utf8("成员"),
		isshow = 0,
		day_reward_goods = [{110009,0,50000},{110081,1,1}],
		frist_reward_goods = [],
		every_reward_goods = []
	};

get(_Key) ->
	?ERR("undefined key from city_officer_config ~p", [_Key]).