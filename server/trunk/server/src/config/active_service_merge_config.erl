%%%-------------------------------------------------------------------
%%% @author zhengsiying
%%% @doc
%%%		自动生成文件，不要手动修改
%%% @end
%%% Created : 2016/10/12
%%%-------------------------------------------------------------------

-module(active_service_merge_config).

-include("common.hrl").
-include("config.hrl").

-compile([export_all]).

get_list_conf() ->
	[ active_service_merge_config:get(X) || X <- get_list() ].

get_list() ->
	[1, 2, 3, 4, 5, 6, 22, 23, 61, 62, 63, 67, 68, 69, 70, 71, 72, 73, 74].

get_monster_id_list() ->
	[6916, 6917].

get_type_list(1) ->
	[1, 2, 3, 4, 5, 6];
get_type_list(9) ->
	[22, 23];
get_type_list(15) ->
	[61, 62, 63];
get_type_list(16) ->
	[67];
get_type_list(17) ->
	[68, 69, 70, 71, 72];
get_type_list(19) ->
	[73, 74];
get_type_list(_) ->
 	[]. 

get(1) ->
	#active_service_merge_conf{
		id = 1,
		type = 1,
		rank = 0,
		value = 98,
		reward_zhanshi = [{110260,1,5},{110003,1,30},{110091,1,5}],
		reward_fashi = [{110260,1,5},{110003,1,30},{110091,1,5}],
		reward_daoshi = [{110260,1,5},{110003,1,30},{110091,1,5}],
		reward = [],
		num = 1,
		condition_text = 98,
		min_jade = 0,
		max_jade = 0
	};

get(2) ->
	#active_service_merge_conf{
		id = 2,
		type = 1,
		rank = 0,
		value = 328,
		reward_zhanshi = [{110260,1,15},{110003,1,50},{110093,1,5}],
		reward_fashi = [{110260,1,15},{110003,1,50},{110093,1,5}],
		reward_daoshi = [{110260,1,15},{110003,1,50},{110093,1,5}],
		reward = [],
		num = 1,
		condition_text = 328,
		min_jade = 0,
		max_jade = 0
	};

get(3) ->
	#active_service_merge_conf{
		id = 3,
		type = 1,
		rank = 0,
		value = 648,
		reward_zhanshi = [{110147,1,1},{110003,1,60},{110193,1,20}],
		reward_fashi = [{110147,1,1},{110003,1,60},{110193,1,20}],
		reward_daoshi = [{110147,1,1},{110003,1,60},{110193,1,20}],
		reward = [],
		num = 1,
		condition_text = 648,
		min_jade = 0,
		max_jade = 0
	};

get(4) ->
	#active_service_merge_conf{
		id = 4,
		type = 1,
		rank = 0,
		value = 1998,
		reward_zhanshi = [{110163,1,2},{110284,1,50},{110283,1,100},{110103,1,5}],
		reward_fashi = [{110163,1,2},{110284,1,50},{110283,1,100},{110103,1,5}],
		reward_daoshi = [{110163,1,2},{110284,1,50},{110283,1,100},{110103,1,5}],
		reward = [],
		num = 1,
		condition_text = 1998,
		min_jade = 0,
		max_jade = 0
	};

get(5) ->
	#active_service_merge_conf{
		id = 5,
		type = 1,
		rank = 0,
		value = 3288,
		reward_zhanshi = [{110294,1,1},{110163,1,2},{110284,1,60},{110283,1,120}],
		reward_fashi = [{110294,1,1},{110163,1,2},{110284,1,60},{110283,1,120}],
		reward_daoshi = [{110294,1,1},{110163,1,2},{110284,1,60},{110283,1,120}],
		reward = [],
		num = 1,
		condition_text = 3288,
		min_jade = 0,
		max_jade = 0
	};

get(6) ->
	#active_service_merge_conf{
		id = 6,
		type = 1,
		rank = 0,
		value = 6480,
		reward_zhanshi = [{110294,1,2},{110163,1,4},{110222,1,10},{110105,1,5}],
		reward_fashi = [{110294,1,2},{110163,1,4},{110222,1,10},{110105,1,5}],
		reward_daoshi = [{110294,1,2},{110163,1,4},{110222,1,10},{110105,1,5}],
		reward = [],
		num = 1,
		condition_text = 6480,
		min_jade = 0,
		max_jade = 0
	};

get(22) ->
	#active_service_merge_conf{
		id = 22,
		type = 9,
		rank = 0,
		value = 6916,
		reward_zhanshi = [{110008,0,1400},{110167,1,2},{110193,1,10}],
		reward_fashi = [{110008,0,1400},{110167,1,2},{110193,1,10}],
		reward_daoshi = [{110008,0,1400},{110167,1,2},{110193,1,10}],
		reward = [],
		num = 1,
		condition_text = <<"">>,
		min_jade = 0,
		max_jade = 0,
		info = <<"">>,
		mail_title = <<"">>
	};

get(23) ->
	#active_service_merge_conf{
		id = 23,
		type = 9,
		rank = 0,
		value = 6917,
		reward_zhanshi = [{110008,0,1600},{110167,1,2},{110193,1,10},{110054,1,5}],
		reward_fashi = [{110008,0,1600},{110167,1,2},{110193,1,10},{110054,1,5}],
		reward_daoshi = [{110008,0,1600},{110167,1,2},{110193,1,10},{110054,1,5}],
		reward = [],
		num = 1,
		condition_text = <<"">>,
		min_jade = 0,
		max_jade = 0,
		info = <<"">>,
		mail_title = <<"">>
	};

get(61) ->
	#active_service_merge_conf{
		id = 61,
		type = 15,
		rank = 1,
		value = 60000,
		reward_zhanshi = [{110294,1,3},{110163,1,5},{110105,1,5}],
		reward_fashi = [{110294,1,3},{110163,1,5},{110105,1,5}],
		reward_daoshi = [{110294,1,3},{110163,1,5},{110105,1,5}],
		reward = [],
		num = 1,
		condition_text = 60000,
		min_jade = 0,
		max_jade = 0,
		info = <<"">>,
		mail_title = xmerl_ucs:to_utf8("战力排行榜奖励"),
		mail_text = xmerl_ucs:to_utf8("恭喜获得战力排行榜全服第一奖励")
	};

get(62) ->
	#active_service_merge_conf{
		id = 62,
		type = 15,
		rank = 2,
		value = 60000,
		reward_zhanshi = [{110163,1,4},{110105,1,4}],
		reward_fashi = [{110163,1,4},{110105,1,4}],
		reward_daoshi = [{110163,1,4},{110105,1,4}],
		reward = [],
		num = 1,
		condition_text = 60000,
		min_jade = 0,
		max_jade = 0,
		info = <<"">>,
		mail_title = xmerl_ucs:to_utf8("战力排行榜奖励"),
		mail_text = xmerl_ucs:to_utf8("恭喜获得战力排行榜全服第二奖励")
	};

get(63) ->
	#active_service_merge_conf{
		id = 63,
		type = 15,
		rank = 3,
		value = 60000,
		reward_zhanshi = [{110163,1,3},{110105,1,3}],
		reward_fashi = [{110163,1,3},{110105,1,3}],
		reward_daoshi = [{110163,1,3},{110105,1,3}],
		reward = [],
		num = 1,
		condition_text = 60000,
		min_jade = 0,
		max_jade = 0,
		info = <<"">>,
		mail_title = xmerl_ucs:to_utf8("战力排行榜奖励"),
		mail_text = xmerl_ucs:to_utf8("恭喜获得战力排行榜全服第三奖励")
	};

get(67) ->
	#active_service_merge_conf{
		id = 67,
		type = 16,
		rank = 0,
		value = 1,
		reward_zhanshi = [{110260,1,5},{110193,1,2},{110049,1,5},{110050,1,1},{110054,1,2},{110078,1,50}],
		reward_fashi = [{110260,1,5},{110193,1,2},{110049,1,5},{110050,1,1},{110054,1,2},{110078,1,50}],
		reward_daoshi = [{110260,1,5},{110193,1,2},{110049,1,5},{110050,1,1},{110054,1,2},{110078,1,50}],
		reward = [],
		num = 1,
		condition_text = 1,
		min_jade = 0,
		max_jade = 0
	};

get(68) ->
	#active_service_merge_conf{
		id = 68,
		type = 17,
		rank = 0,
		value = 1,
		reward_zhanshi = [{110009,1,200000},{110007,1,5},{110003,1,5}],
		reward_fashi = [{110009,1,200000},{110007,1,5},{110003,1,5}],
		reward_daoshi = [{110009,1,200000},{110007,1,5},{110003,1,5}],
		reward = [],
		num = 0,
		condition_text = <<"">>,
		min_jade = 0,
		max_jade = 0
	};

get(69) ->
	#active_service_merge_conf{
		id = 69,
		type = 17,
		rank = 0,
		value = 2,
		reward_zhanshi = [{110009,1,300000},{110007,1,6},{110003,1,6},{110148,1,2}],
		reward_fashi = [{110009,1,300000},{110007,1,6},{110003,1,6},{110148,1,2}],
		reward_daoshi = [{110009,1,300000},{110007,1,6},{110003,1,6},{110148,1,2}],
		reward = [],
		num = 0,
		condition_text = <<"">>,
		min_jade = 0,
		max_jade = 0
	};

get(70) ->
	#active_service_merge_conf{
		id = 70,
		type = 17,
		rank = 0,
		value = 3,
		reward_zhanshi = [{110009,1,400000},{110193,1,3},{110003,1,7},{110168,1,1}],
		reward_fashi = [{110009,1,400000},{110193,1,3},{110003,1,7},{110168,1,1}],
		reward_daoshi = [{110009,1,400000},{110193,1,3},{110003,1,7},{110168,1,1}],
		reward = [],
		num = 0,
		condition_text = <<"">>,
		min_jade = 0,
		max_jade = 0
	};

get(71) ->
	#active_service_merge_conf{
		id = 71,
		type = 17,
		rank = 0,
		value = 4,
		reward_zhanshi = [{110009,1,500000},{110193,1,4},{110003,1,8},{110166,1,1}],
		reward_fashi = [{110009,1,500000},{110193,1,4},{110003,1,8},{110166,1,1}],
		reward_daoshi = [{110009,1,500000},{110193,1,4},{110003,1,8},{110166,1,1}],
		reward = [],
		num = 0,
		condition_text = <<"">>,
		min_jade = 0,
		max_jade = 0
	};

get(72) ->
	#active_service_merge_conf{
		id = 72,
		type = 17,
		rank = 0,
		value = 5,
		reward_zhanshi = [{110009,1,600000},{110193,1,5},{110003,1,10},{110167,1,1},{110168,1,1}],
		reward_fashi = [{110009,1,600000},{110193,1,5},{110003,1,10},{110167,1,1},{110168,1,1}],
		reward_daoshi = [{110009,1,600000},{110193,1,5},{110003,1,10},{110167,1,1},{110168,1,1}],
		reward = [],
		num = 0,
		condition_text = <<"">>,
		min_jade = 0,
		max_jade = 0
	};

get(73) ->
	#active_service_merge_conf{
		id = 73,
		type = 19,
		rank = 0,
		value = 1,
		reward_zhanshi = [{110008,0,6000}],
		reward_fashi = [{110008,0,6000}],
		reward_daoshi = [{110008,0,6000}],
		reward = [],
		num = 0,
		condition_text = <<"">>,
		min_jade = 0,
		max_jade = 0,
		info = <<"">>,
		mail_title = xmerl_ucs:to_utf8("合服首次攻城奖励"),
		mail_text = xmerl_ucs:to_utf8("恭喜你们成为首次攻城获胜行会，这是会长奖励")
	};

get(74) ->
	#active_service_merge_conf{
		id = 74,
		type = 19,
		rank = 0,
		value = 0,
		reward_zhanshi = [{110260,1,5},{110091,1,5},{110003,1,20}],
		reward_fashi = [{110260,1,5},{110091,1,5},{110003,1,20}],
		reward_daoshi = [{110260,1,5},{110091,1,5},{110003,1,20}],
		reward = [],
		num = 0,
		condition_text = <<"">>,
		min_jade = 0,
		max_jade = 0,
		info = <<"">>,
		mail_title = xmerl_ucs:to_utf8("合服首次攻城奖励"),
		mail_text = xmerl_ucs:to_utf8("恭喜你们成为首次攻城获胜行会，这是会员奖励")
	};

get(_Key) ->
	?ERR("undefined key from active_service_merge_config ~p", [_Key]).