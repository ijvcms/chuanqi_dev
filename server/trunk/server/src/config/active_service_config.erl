%%%-------------------------------------------------------------------
%%% @author zhengsiying
%%% @doc
%%%		自动生成文件，不要手动修改
%%% @end
%%% Created : 2016/10/12
%%%-------------------------------------------------------------------

-module(active_service_config).

-include("common.hrl").
-include("config.hrl").

-compile([export_all]).

get_list_conf() ->
	[ active_service_config:get(X) || X <- get_list() ].

get_list() ->
	[1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32, 33, 34, 35, 36, 37, 38, 39, 40, 41, 42, 43, 44, 45, 46, 47, 48, 49, 50, 51, 52, 53, 54, 55, 56, 57, 58, 59, 60, 61, 62, 63, 64, 65, 66].

get_monster_id_list() ->
	[6901, 6902, 6904, 6903, 6905, 6909, 6906, 6910, 6911].

get_type_list(1) ->
	[1, 2, 3, 4, 5];
get_type_list(3) ->
	[6, 7, 8, 9, 10];
get_type_list(4) ->
	[11, 12, 13];
get_type_list(6) ->
	[14, 15, 16];
get_type_list(7) ->
	[17];
get_type_list(8) ->
	[18, 19, 20, 21];
get_type_list(9) ->
	[22, 23, 24, 25, 26, 27, 28, 29, 30];
get_type_list(10) ->
	[31, 32, 33, 34, 35, 36];
get_type_list(11) ->
	[37, 38, 39, 40, 41, 42];
get_type_list(12) ->
	[43, 44, 45, 46, 47, 48];
get_type_list(13) ->
	[49, 50, 51, 52, 53, 54];
get_type_list(14) ->
	[55, 56, 57, 58, 59, 60];
get_type_list(15) ->
	[61, 62, 63, 64, 65, 66];
get_type_list(_) ->
 	[]. 

get(1) ->
	#active_service_conf{
		id = 1,
		type = 1,
		rank = 0,
		value = 50,
		reward_zhanshi = [{110061,1,30},{110083,1,5}],
		reward_fashi = [{110061,1,30},{110083,1,5}],
		reward_daoshi = [{110061,1,30},{110083,1,5}],
		reward = [],
		num = 1,
		condition_text = 50,
		min_jade = 0,
		max_jade = 0
	};

get(2) ->
	#active_service_conf{
		id = 2,
		type = 1,
		rank = 0,
		value = 100,
		reward_zhanshi = [{110062,1,30},{110086,1,5}],
		reward_fashi = [{110062,1,30},{110086,1,5}],
		reward_daoshi = [{110062,1,30},{110086,1,5}],
		reward = [],
		num = 1,
		condition_text = 100,
		min_jade = 0,
		max_jade = 0
	};

get(3) ->
	#active_service_conf{
		id = 3,
		type = 1,
		rank = 0,
		value = 500,
		reward_zhanshi = [{110063,1,30},{110091,1,5},{110056,1,5}],
		reward_fashi = [{110063,1,30},{110091,1,5},{110056,1,5}],
		reward_daoshi = [{110063,1,30},{110091,1,5},{110056,1,5}],
		reward = [],
		num = 1,
		condition_text = 500,
		min_jade = 0,
		max_jade = 0
	};

get(4) ->
	#active_service_conf{
		id = 4,
		type = 1,
		rank = 0,
		value = 1000,
		reward_zhanshi = [{110064,1,40},{110092,1,5},{110056,1,5}],
		reward_fashi = [{110064,1,40},{110092,1,5},{110056,1,5}],
		reward_daoshi = [{110064,1,40},{110092,1,5},{110056,1,5}],
		reward = [],
		num = 1,
		condition_text = 1000,
		min_jade = 0,
		max_jade = 0
	};

get(5) ->
	#active_service_conf{
		id = 5,
		type = 1,
		rank = 0,
		value = 3000,
		reward_zhanshi = [{110064,1,50},{110094,1,5},{110056,1,5}],
		reward_fashi = [{110064,1,50},{110094,1,5},{110056,1,5}],
		reward_daoshi = [{110064,1,50},{110094,1,5},{110056,1,5}],
		reward = [],
		num = 1,
		condition_text = 3000,
		min_jade = 0,
		max_jade = 0
	};

get(6) ->
	#active_service_conf{
		id = 6,
		type = 3,
		rank = 0,
		value = 888,
		reward_zhanshi = [{110140,1,3},{110127,1,20}],
		reward_fashi = [{110140,1,3},{110127,1,20}],
		reward_daoshi = [{110140,1,3},{110127,1,20}],
		reward = [],
		num = 1,
		condition_text = 888,
		min_jade = 0,
		max_jade = 0
	};

get(7) ->
	#active_service_conf{
		id = 7,
		type = 3,
		rank = 0,
		value = 2888,
		reward_zhanshi = [{110140,1,5},{110127,1,30}],
		reward_fashi = [{110140,1,5},{110127,1,30}],
		reward_daoshi = [{110140,1,5},{110127,1,30}],
		reward = [],
		num = 1,
		condition_text = 2888,
		min_jade = 0,
		max_jade = 0
	};

get(8) ->
	#active_service_conf{
		id = 8,
		type = 3,
		rank = 0,
		value = 5888,
		reward_zhanshi = [{110140,1,8},{110127,1,30}],
		reward_fashi = [{110140,1,8},{110127,1,30}],
		reward_daoshi = [{110140,1,8},{110127,1,30}],
		reward = [],
		num = 1,
		condition_text = 5888,
		min_jade = 0,
		max_jade = 0
	};

get(9) ->
	#active_service_conf{
		id = 9,
		type = 3,
		rank = 0,
		value = 10888,
		reward_zhanshi = [{110140,1,10},{110127,1,40}],
		reward_fashi = [{110140,1,10},{110127,1,40}],
		reward_daoshi = [{110140,1,10},{110127,1,40}],
		reward = [],
		num = 1,
		condition_text = 10888,
		min_jade = 0,
		max_jade = 0
	};

get(10) ->
	#active_service_conf{
		id = 10,
		type = 3,
		rank = 0,
		value = 16888,
		reward_zhanshi = [{110140,1,15},{110127,1,50}],
		reward_fashi = [{110140,1,15},{110127,1,50}],
		reward_daoshi = [{110140,1,15},{110127,1,50}],
		reward = [],
		num = 1,
		condition_text = 16888,
		min_jade = 0,
		max_jade = 0,
		info = <<"">>,
		mail_title = <<"">>,
		mail_text = <<"">>
	};

get(11) ->
	#active_service_conf{
		id = 11,
		type = 4,
		rank = 0,
		value = 328,
		reward_zhanshi = [{110045,1,30}],
		reward_fashi = [{110045,1,30}],
		reward_daoshi = [{110045,1,30}],
		reward = [],
		num = 1,
		condition_text = 328,
		min_jade = 0,
		max_jade = 0
	};

get(12) ->
	#active_service_conf{
		id = 12,
		type = 4,
		rank = 0,
		value = 1288,
		reward_zhanshi = [{110045,1,120}],
		reward_fashi = [{110045,1,120}],
		reward_daoshi = [{110045,1,120}],
		reward = [],
		num = 1,
		condition_text = 1288,
		min_jade = 0,
		max_jade = 0
	};

get(13) ->
	#active_service_conf{
		id = 13,
		type = 4,
		rank = 0,
		value = 3288,
		reward_zhanshi = [{110045,1,300}],
		reward_fashi = [{110045,1,300}],
		reward_daoshi = [{110045,1,300}],
		reward = [],
		num = 1,
		condition_text = 3288,
		min_jade = 0,
		max_jade = 0
	};

get(14) ->
	#active_service_conf{
		id = 14,
		type = 6,
		rank = 0,
		value = 4000,
		reward_zhanshi = [{110008,1,200},{110003,1,40}],
		reward_fashi = [{110008,1,200},{110003,1,40}],
		reward_daoshi = [{110008,1,200},{110003,1,40}],
		reward = [],
		num = 1,
		condition_text = 4000,
		min_jade = 0,
		max_jade = 0
	};

get(15) ->
	#active_service_conf{
		id = 15,
		type = 6,
		rank = 0,
		value = 8000,
		reward_zhanshi = [{110008,1,250},{110003,1,45}],
		reward_fashi = [{110008,1,250},{110003,1,45}],
		reward_daoshi = [{110008,1,250},{110003,1,45}],
		reward = [],
		num = 1,
		condition_text = 8000,
		min_jade = 0,
		max_jade = 0
	};

get(16) ->
	#active_service_conf{
		id = 16,
		type = 6,
		rank = 0,
		value = 16000,
		reward_zhanshi = [{110008,1,500},{110003,1,90}],
		reward_fashi = [{110008,1,500},{110003,1,90}],
		reward_daoshi = [{110008,1,500},{110003,1,90}],
		reward = [],
		num = 1,
		condition_text = 16000,
		min_jade = 0,
		max_jade = 0
	};

get(17) ->
	#active_service_conf{
		id = 17,
		type = 7,
		rank = 0,
		value = 98,
		reward_zhanshi = [{200021,0,1},{200022,0,1},{200023,0,2},{200025,0,1},{200026,0,2},{200027,0,1},{200029,0,1}],
		reward_fashi = [{201021,0,1},{201022,0,1},{201023,0,2},{201025,0,1},{201026,0,2},{201027,0,1},{201029,0,1}],
		reward_daoshi = [{202021,0,1},{202022,0,1},{202023,0,2},{202025,0,1},{202026,0,2},{202027,0,1},{202029,0,1}],
		reward = [],
		num = 1,
		condition_text = <<"98+">>,
		min_jade = 0,
		max_jade = 0
	};

get(18) ->
	#active_service_conf{
		id = 18,
		type = 8,
		rank = 0,
		value = 0,
		reward_zhanshi = [],
		reward_fashi = [],
		reward_daoshi = [],
		reward = [],
		num = 0,
		condition_text = <<"">>,
		min_jade = 1,
		max_jade = 10,
		info = xmerl_ucs:to_utf8("~s大发善心，给全服玩家发放爱心红包。")
	};

get(19) ->
	#active_service_conf{
		id = 19,
		type = 8,
		rank = 0,
		value = [10,11,12,13,14,15,16,17,18,19,20,21,22],
		reward_zhanshi = [],
		reward_fashi = [],
		reward_daoshi = [],
		reward = [],
		num = 30,
		condition_text = <<"">>,
		min_jade = 1,
		max_jade = 10,
		info = xmerl_ucs:to_utf8("系统管理员大发善心，为全服发放红包。")
	};

get(20) ->
	#active_service_conf{
		id = 20,
		type = 8,
		rank = 0,
		value = 0,
		reward_zhanshi = [],
		reward_fashi = [],
		reward_daoshi = [],
		reward = [],
		num = 5,
		condition_text = <<"">>,
		min_jade = 1,
		max_jade = 10,
		info = xmerl_ucs:to_utf8("~s跪地求饶, 发出红包求放过！")
	};

get(21) ->
	#active_service_conf{
		id = 21,
		type = 8,
		rank = 0,
		value = 0,
		reward_zhanshi = [],
		reward_fashi = [],
		reward_daoshi = [],
		reward = [],
		num = 0,
		condition_text = <<"">>,
		min_jade = 0,
		max_jade = 0,
		info = xmerl_ucs:to_utf8("~s行会的~s发了~s元宝红包，令人羡慕不已！")
	};

get(22) ->
	#active_service_conf{
		id = 22,
		type = 9,
		rank = 0,
		value = 6901,
		reward_zhanshi = [{110008,0,200}],
		reward_fashi = [{110008,0,200}],
		reward_daoshi = [{110008,0,200}],
		reward = [{110045,1,50}],
		num = 1,
		condition_text = <<"">>,
		min_jade = 0,
		max_jade = 0,
		info = <<"">>,
		mail_title = <<"">>
	};

get(23) ->
	#active_service_conf{
		id = 23,
		type = 9,
		rank = 0,
		value = 6902,
		reward_zhanshi = [{110008,0,200}],
		reward_fashi = [{110008,0,200}],
		reward_daoshi = [{110008,0,200}],
		reward = [{110045,1,50}],
		num = 1,
		condition_text = <<"">>,
		min_jade = 0,
		max_jade = 0,
		info = <<"">>,
		mail_title = <<"">>
	};

get(24) ->
	#active_service_conf{
		id = 24,
		type = 9,
		rank = 0,
		value = 6904,
		reward_zhanshi = [{110008,0,400}],
		reward_fashi = [{110008,0,400}],
		reward_daoshi = [{110008,0,400}],
		reward = [{110045,1,100}],
		num = 1,
		condition_text = <<"">>,
		min_jade = 0,
		max_jade = 0,
		info = <<"">>,
		mail_title = <<"">>
	};

get(25) ->
	#active_service_conf{
		id = 25,
		type = 9,
		rank = 0,
		value = 6903,
		reward_zhanshi = [{110008,0,400}],
		reward_fashi = [{110008,0,400}],
		reward_daoshi = [{110008,0,400}],
		reward = [{110045,1,100}],
		num = 1,
		condition_text = <<"">>,
		min_jade = 0,
		max_jade = 0,
		info = <<"">>,
		mail_title = <<"">>
	};

get(26) ->
	#active_service_conf{
		id = 26,
		type = 9,
		rank = 0,
		value = 6905,
		reward_zhanshi = [{110008,0,400}],
		reward_fashi = [{110008,0,400}],
		reward_daoshi = [{110008,0,400}],
		reward = [{110045,1,100}],
		num = 1,
		condition_text = <<"">>,
		min_jade = 0,
		max_jade = 0,
		info = <<"">>,
		mail_title = <<"">>
	};

get(27) ->
	#active_service_conf{
		id = 27,
		type = 9,
		rank = 0,
		value = 6909,
		reward_zhanshi = [{110008,0,800}],
		reward_fashi = [{110008,0,800}],
		reward_daoshi = [{110008,0,800}],
		reward = [{110045,1,200}],
		num = 1,
		condition_text = <<"">>,
		min_jade = 0,
		max_jade = 0,
		info = <<"">>,
		mail_title = <<"">>
	};

get(28) ->
	#active_service_conf{
		id = 28,
		type = 9,
		rank = 0,
		value = 6906,
		reward_zhanshi = [{110008,0,1000}],
		reward_fashi = [{110008,0,1000}],
		reward_daoshi = [{110008,0,1000}],
		reward = [{110045,1,300}],
		num = 1,
		condition_text = <<"">>,
		min_jade = 0,
		max_jade = 0,
		info = <<"">>,
		mail_title = <<"">>
	};

get(29) ->
	#active_service_conf{
		id = 29,
		type = 9,
		rank = 0,
		value = 6910,
		reward_zhanshi = [{110008,0,1200}],
		reward_fashi = [{110008,0,1200}],
		reward_daoshi = [{110008,0,1200}],
		reward = [{110045,1,400}],
		num = 1,
		condition_text = <<"">>,
		min_jade = 0,
		max_jade = 0
	};

get(30) ->
	#active_service_conf{
		id = 30,
		type = 9,
		rank = 0,
		value = 6911,
		reward_zhanshi = [{110008,0,1300}],
		reward_fashi = [{110008,0,1300}],
		reward_daoshi = [{110008,0,1300}],
		reward = [{110045,1,500}],
		num = 1,
		condition_text = <<"">>,
		min_jade = 0,
		max_jade = 0
	};

get(31) ->
	#active_service_conf{
		id = 31,
		type = 10,
		rank = 1,
		value = 60,
		reward_zhanshi = [{110045,1,1000},{110109,1,2},{110193,1,50}],
		reward_fashi = [{110045,1,1000},{110109,1,2},{110193,1,50}],
		reward_daoshi = [{110045,1,1000},{110109,1,2},{110193,1,50}],
		reward = [],
		num = 1,
		condition_text = 60,
		min_jade = 0,
		max_jade = 0,
		info = <<"">>,
		mail_title = xmerl_ucs:to_utf8("冲级达人奖励"),
		mail_text = xmerl_ucs:to_utf8("恭喜获得冲级排行榜全服第一奖励")
	};

get(32) ->
	#active_service_conf{
		id = 32,
		type = 10,
		rank = 2,
		value = 60,
		reward_zhanshi = [{110045,1,800},{110050,1,3},{110193,1,30}],
		reward_fashi = [{110045,1,800},{110050,1,3},{110193,1,30}],
		reward_daoshi = [{110045,1,800},{110050,1,3},{110193,1,30}],
		reward = [],
		num = 1,
		condition_text = 60,
		min_jade = 0,
		max_jade = 0,
		info = <<"">>,
		mail_title = xmerl_ucs:to_utf8("冲级达人奖励"),
		mail_text = xmerl_ucs:to_utf8("恭喜获得冲级排行榜全服第二奖励")
	};

get(33) ->
	#active_service_conf{
		id = 33,
		type = 10,
		rank = 3,
		value = 60,
		reward_zhanshi = [{110045,1,600},{110050,1,2},{110193,1,20}],
		reward_fashi = [{110045,1,600},{110050,1,2},{110193,1,20}],
		reward_daoshi = [{110045,1,600},{110050,1,2},{110193,1,20}],
		reward = [],
		num = 1,
		condition_text = 60,
		min_jade = 0,
		max_jade = 0,
		info = <<"">>,
		mail_title = xmerl_ucs:to_utf8("冲级达人奖励"),
		mail_text = xmerl_ucs:to_utf8("恭喜获得冲级排行榜全服第三奖励")
	};

get(34) ->
	#active_service_conf{
		id = 34,
		type = 10,
		rank = 0,
		value = 55,
		reward_zhanshi = [{110045,1,150},{110050,1,1},{110007,1,50}],
		reward_fashi = [{110045,1,150},{110050,1,1},{110007,1,50}],
		reward_daoshi = [{110045,1,150},{110050,1,1},{110007,1,50}],
		reward = [],
		num = 0,
		condition_text = 55,
		min_jade = 0,
		max_jade = 0,
		info = <<"">>,
		mail_title = xmerl_ucs:to_utf8("冲级达人奖励"),
		mail_text = xmerl_ucs:to_utf8("恭喜获得冲级排行榜55等级段奖励")
	};

get(35) ->
	#active_service_conf{
		id = 35,
		type = 10,
		rank = 0,
		value = 50,
		reward_zhanshi = [{110045,1,100},{110009,1,500000},{110007,1,30}],
		reward_fashi = [{110045,1,100},{110009,1,500000},{110007,1,30}],
		reward_daoshi = [{110045,1,100},{110009,1,500000},{110007,1,30}],
		reward = [],
		num = 0,
		condition_text = 50,
		min_jade = 0,
		max_jade = 0,
		info = <<"">>,
		mail_title = xmerl_ucs:to_utf8("冲级达人奖励"),
		mail_text = xmerl_ucs:to_utf8("恭喜获得冲级排行榜50等级段奖励")
	};

get(36) ->
	#active_service_conf{
		id = 36,
		type = 10,
		rank = 0,
		value = 45,
		reward_zhanshi = [{110045,1,50},{110009,1,200000},{110007,1,20}],
		reward_fashi = [{110045,1,50},{110009,1,200000},{110007,1,20}],
		reward_daoshi = [{110045,1,50},{110009,1,200000},{110007,1,20}],
		reward = [],
		num = 0,
		condition_text = 45,
		min_jade = 0,
		max_jade = 0,
		info = <<"">>,
		mail_title = xmerl_ucs:to_utf8("冲级达人奖励"),
		mail_text = xmerl_ucs:to_utf8("恭喜获得冲级排行榜45等级段奖励")
	};

get(37) ->
	#active_service_conf{
		id = 37,
		type = 11,
		rank = 1,
		value = 188,
		reward_zhanshi = [{110097,1,5},{110101,1,5},{305017,1,1}],
		reward_fashi = [{110097,1,5},{110101,1,5},{305017,1,1}],
		reward_daoshi = [{110097,1,5},{110101,1,5},{305017,1,1}],
		reward = [],
		num = 1,
		condition_text = <<"188+">>,
		min_jade = 0,
		max_jade = 0,
		info = <<"">>,
		mail_title = xmerl_ucs:to_utf8("装备强化排行奖励"),
		mail_text = xmerl_ucs:to_utf8("恭喜获得强化排行榜全服第一奖励")
	};

get(38) ->
	#active_service_conf{
		id = 38,
		type = 11,
		rank = 2,
		value = 188,
		reward_zhanshi = [{110096,1,8},{110100,1,5}],
		reward_fashi = [{110096,1,8},{110100,1,5}],
		reward_daoshi = [{110096,1,8},{110100,1,5}],
		reward = [],
		num = 1,
		condition_text = <<"188+">>,
		min_jade = 0,
		max_jade = 0,
		info = <<"">>,
		mail_title = xmerl_ucs:to_utf8("装备强化排行奖励"),
		mail_text = xmerl_ucs:to_utf8("恭喜获得强化排行榜全服第二奖励")
	};

get(39) ->
	#active_service_conf{
		id = 39,
		type = 11,
		rank = 3,
		value = 188,
		reward_zhanshi = [{110096,1,5},{110099,1,5}],
		reward_fashi = [{110096,1,5},{110099,1,5}],
		reward_daoshi = [{110096,1,5},{110099,1,5}],
		reward = [],
		num = 1,
		condition_text = <<"188+">>,
		min_jade = 0,
		max_jade = 0,
		info = <<"">>,
		mail_title = xmerl_ucs:to_utf8("装备强化排行奖励"),
		mail_text = xmerl_ucs:to_utf8("恭喜获得强化排行榜全服第三奖励")
	};

get(40) ->
	#active_service_conf{
		id = 40,
		type = 11,
		rank = 0,
		value = 100,
		reward_zhanshi = [{110091,1,5},{110003,1,30}],
		reward_fashi = [{110091,1,5},{110003,1,30}],
		reward_daoshi = [{110091,1,5},{110003,1,30}],
		reward = [],
		num = 0,
		condition_text = <<"100+">>,
		min_jade = 0,
		max_jade = 0,
		info = <<"">>,
		mail_title = xmerl_ucs:to_utf8("装备强化排行奖励"),
		mail_text = xmerl_ucs:to_utf8("恭喜获得强化排行100等级段奖励")
	};

get(41) ->
	#active_service_conf{
		id = 41,
		type = 11,
		rank = 0,
		value = 60,
		reward_zhanshi = [{110088,1,5},{110003,1,20}],
		reward_fashi = [{110088,1,5},{110003,1,20}],
		reward_daoshi = [{110088,1,5},{110003,1,20}],
		reward = [],
		num = 0,
		condition_text = <<"60+">>,
		min_jade = 0,
		max_jade = 0,
		info = <<"">>,
		mail_title = xmerl_ucs:to_utf8("装备强化排行奖励"),
		mail_text = xmerl_ucs:to_utf8("恭喜获得强化排行60等级段奖励")
	};

get(42) ->
	#active_service_conf{
		id = 42,
		type = 11,
		rank = 0,
		value = 30,
		reward_zhanshi = [{110085,1,7},{110003,1,10}],
		reward_fashi = [{110085,1,7},{110003,1,10}],
		reward_daoshi = [{110085,1,7},{110003,1,10}],
		reward = [],
		num = 0,
		condition_text = <<"30+">>,
		min_jade = 0,
		max_jade = 0,
		info = <<"">>,
		mail_title = xmerl_ucs:to_utf8("装备强化排行奖励"),
		mail_text = xmerl_ucs:to_utf8("恭喜获得强化排行30等级段奖励")
	};

get(43) ->
	#active_service_conf{
		id = 43,
		type = 12,
		rank = 1,
		value = 71,
		reward_zhanshi = [{110140,1,100},{110127,1,200},{305016,1,1}],
		reward_fashi = [{110140,1,100},{110127,1,200},{305016,1,1}],
		reward_daoshi = [{110140,1,100},{110127,1,200},{305016,1,1}],
		reward = [],
		num = 1,
		condition_text = xmerl_ucs:to_utf8("7阶1星"),
		min_jade = 0,
		max_jade = 0,
		info = <<"">>,
		mail_title = xmerl_ucs:to_utf8("翅膀进阶排行奖励"),
		mail_text = xmerl_ucs:to_utf8("恭喜获得翅膀进阶排行榜全服第一奖励")
	};

get(44) ->
	#active_service_conf{
		id = 44,
		type = 12,
		rank = 2,
		value = 71,
		reward_zhanshi = [{110140,1,80},{110127,1,160}],
		reward_fashi = [{110140,1,80},{110127,1,160}],
		reward_daoshi = [{110140,1,80},{110127,1,160}],
		reward = [],
		num = 1,
		condition_text = xmerl_ucs:to_utf8("7阶1星"),
		min_jade = 0,
		max_jade = 0,
		info = <<"">>,
		mail_title = xmerl_ucs:to_utf8("翅膀进阶排行奖励"),
		mail_text = xmerl_ucs:to_utf8("恭喜获得翅膀进阶排行榜全服第二奖励")
	};

get(45) ->
	#active_service_conf{
		id = 45,
		type = 12,
		rank = 3,
		value = 71,
		reward_zhanshi = [{110140,1,60},{110127,1,120}],
		reward_fashi = [{110140,1,60},{110127,1,120}],
		reward_daoshi = [{110140,1,60},{110127,1,120}],
		reward = [],
		num = 1,
		condition_text = xmerl_ucs:to_utf8("7阶1星"),
		min_jade = 0,
		max_jade = 0,
		info = <<"">>,
		mail_title = xmerl_ucs:to_utf8("翅膀进阶排行奖励"),
		mail_text = xmerl_ucs:to_utf8("恭喜获得翅膀进阶排行榜全服第三奖励")
	};

get(46) ->
	#active_service_conf{
		id = 46,
		type = 12,
		rank = 0,
		value = 51,
		reward_zhanshi = [{110140,1,30},{110127,1,90}],
		reward_fashi = [{110140,1,30},{110127,1,90}],
		reward_daoshi = [{110140,1,30},{110127,1,90}],
		reward = [],
		num = 0,
		condition_text = xmerl_ucs:to_utf8("5阶1星"),
		min_jade = 0,
		max_jade = 0,
		info = <<"">>,
		mail_title = xmerl_ucs:to_utf8("翅膀进阶排行奖励"),
		mail_text = xmerl_ucs:to_utf8("恭喜获得翅膀进阶排行榜5阶等级段奖励")
	};

get(47) ->
	#active_service_conf{
		id = 47,
		type = 12,
		rank = 0,
		value = 41,
		reward_zhanshi = [{110140,1,20},{110127,1,60}],
		reward_fashi = [{110140,1,20},{110127,1,60}],
		reward_daoshi = [{110140,1,20},{110127,1,60}],
		reward = [],
		num = 0,
		condition_text = xmerl_ucs:to_utf8("4阶1星"),
		min_jade = 0,
		max_jade = 0,
		info = <<"">>,
		mail_title = xmerl_ucs:to_utf8("翅膀进阶排行奖励"),
		mail_text = xmerl_ucs:to_utf8("恭喜获得翅膀进阶排行榜4阶等级段奖励")
	};

get(48) ->
	#active_service_conf{
		id = 48,
		type = 12,
		rank = 0,
		value = 31,
		reward_zhanshi = [{110140,1,10},{110127,1,30}],
		reward_fashi = [{110140,1,10},{110127,1,30}],
		reward_daoshi = [{110140,1,10},{110127,1,30}],
		reward = [],
		num = 0,
		condition_text = xmerl_ucs:to_utf8("3阶1星"),
		min_jade = 0,
		max_jade = 0,
		info = <<"">>,
		mail_title = xmerl_ucs:to_utf8("翅膀进阶排行奖励"),
		mail_text = xmerl_ucs:to_utf8("恭喜获得翅膀进阶排行榜3阶等级段奖励")
	};

get(49) ->
	#active_service_conf{
		id = 49,
		type = 13,
		rank = 1,
		value = 22,
		reward_zhanshi = [{110193,1,50},{110054,1,20},{110109,1,3}],
		reward_fashi = [{110193,1,50},{110054,1,20},{110109,1,3}],
		reward_daoshi = [{110193,1,50},{110054,1,20},{110109,1,3}],
		reward = [],
		num = 1,
		condition_text = xmerl_ucs:to_utf8("4阶黑铁勋章"),
		min_jade = 0,
		max_jade = 0,
		info = <<"">>,
		mail_title = xmerl_ucs:to_utf8("勋章进阶排行奖励"),
		mail_text = xmerl_ucs:to_utf8("恭喜获得勋章进阶排行榜全服第一奖励")
	};

get(50) ->
	#active_service_conf{
		id = 50,
		type = 13,
		rank = 2,
		value = 22,
		reward_zhanshi = [{110193,1,30},{110054,1,10},{110109,1,2}],
		reward_fashi = [{110193,1,30},{110054,1,10},{110109,1,2}],
		reward_daoshi = [{110193,1,30},{110054,1,10},{110109,1,2}],
		reward = [],
		num = 1,
		condition_text = xmerl_ucs:to_utf8("4阶黑铁勋章"),
		min_jade = 0,
		max_jade = 0,
		info = <<"">>,
		mail_title = xmerl_ucs:to_utf8("勋章进阶排行奖励"),
		mail_text = xmerl_ucs:to_utf8("恭喜获得勋章进阶排行榜全服第二奖励")
	};

get(51) ->
	#active_service_conf{
		id = 51,
		type = 13,
		rank = 3,
		value = 22,
		reward_zhanshi = [{110193,1,20},{110054,1,5},{110109,1,1}],
		reward_fashi = [{110193,1,20},{110054,1,5},{110109,1,1}],
		reward_daoshi = [{110193,1,20},{110054,1,5},{110109,1,1}],
		reward = [],
		num = 1,
		condition_text = xmerl_ucs:to_utf8("4阶黑铁勋章"),
		min_jade = 0,
		max_jade = 0,
		info = <<"">>,
		mail_title = xmerl_ucs:to_utf8("勋章进阶排行奖励"),
		mail_text = xmerl_ucs:to_utf8("恭喜获得勋章进阶排行榜全服第三奖励")
	};

get(52) ->
	#active_service_conf{
		id = 52,
		type = 13,
		rank = 0,
		value = 17,
		reward_zhanshi = [{110007,1,30},{110049,1,5}],
		reward_fashi = [{110007,1,30},{110049,1,5}],
		reward_daoshi = [{110007,1,30},{110049,1,5}],
		reward = [],
		num = 0,
		condition_text = xmerl_ucs:to_utf8("8阶生铁勋章"),
		min_jade = 0,
		max_jade = 0,
		info = <<"">>,
		mail_title = xmerl_ucs:to_utf8("勋章进阶排行奖励"),
		mail_text = xmerl_ucs:to_utf8("恭喜获得勋章进阶8阶生铁奖励")
	};

get(53) ->
	#active_service_conf{
		id = 53,
		type = 13,
		rank = 0,
		value = 12,
		reward_zhanshi = [{110007,1,20},{110049,1,3}],
		reward_fashi = [{110007,1,20},{110049,1,3}],
		reward_daoshi = [{110007,1,20},{110049,1,3}],
		reward = [],
		num = 0,
		condition_text = xmerl_ucs:to_utf8("3阶生铁勋章"),
		min_jade = 0,
		max_jade = 0,
		info = <<"">>,
		mail_title = xmerl_ucs:to_utf8("勋章进阶排行奖励"),
		mail_text = xmerl_ucs:to_utf8("恭喜获得勋章进阶3阶生铁奖励")
	};

get(54) ->
	#active_service_conf{
		id = 54,
		type = 13,
		rank = 0,
		value = 6,
		reward_zhanshi = [{110007,1,10},{110049,1,2}],
		reward_fashi = [{110007,1,10},{110049,1,2}],
		reward_daoshi = [{110007,1,10},{110049,1,2}],
		reward = [],
		num = 0,
		condition_text = xmerl_ucs:to_utf8("6阶青铜勋章"),
		min_jade = 0,
		max_jade = 0,
		info = <<"">>,
		mail_title = xmerl_ucs:to_utf8("勋章进阶排行奖励"),
		mail_text = xmerl_ucs:to_utf8("恭喜获得勋章进阶6阶青铜奖励")
	};

get(55) ->
	#active_service_conf{
		id = 55,
		type = 14,
		rank = 1,
		value = 50,
		reward_zhanshi = [{110219,1,50},{110050,1,3},{110222,1,3}],
		reward_fashi = [{110219,1,50},{110050,1,3},{110222,1,3}],
		reward_daoshi = [{110219,1,50},{110050,1,3},{110222,1,3}],
		reward = [],
		num = 1,
		condition_text = <<"50+">>,
		min_jade = 0,
		max_jade = 0,
		info = <<"">>,
		mail_title = xmerl_ucs:to_utf8("印记升级排行奖励"),
		mail_text = xmerl_ucs:to_utf8("恭喜获得印记升级排行榜全服第一奖励")
	};

get(56) ->
	#active_service_conf{
		id = 56,
		type = 14,
		rank = 2,
		value = 50,
		reward_zhanshi = [{110219,1,30},{110050,1,2},{110222,1,2}],
		reward_fashi = [{110219,1,30},{110050,1,2},{110222,1,2}],
		reward_daoshi = [{110219,1,30},{110050,1,2},{110222,1,2}],
		reward = [],
		num = 1,
		condition_text = <<"50+">>,
		min_jade = 0,
		max_jade = 0,
		info = <<"">>,
		mail_title = xmerl_ucs:to_utf8("印记升级排行奖励"),
		mail_text = xmerl_ucs:to_utf8("恭喜获得印记升级排行榜全服第二奖励")
	};

get(57) ->
	#active_service_conf{
		id = 57,
		type = 14,
		rank = 3,
		value = 50,
		reward_zhanshi = [{110219,1,20},{110050,1,1},{110222,1,1}],
		reward_fashi = [{110219,1,20},{110050,1,1},{110222,1,1}],
		reward_daoshi = [{110219,1,20},{110050,1,1},{110222,1,1}],
		reward = [],
		num = 1,
		condition_text = <<"50+">>,
		min_jade = 0,
		max_jade = 0,
		info = <<"">>,
		mail_title = xmerl_ucs:to_utf8("印记升级排行奖励"),
		mail_text = xmerl_ucs:to_utf8("恭喜获得印记升级排行榜全服第三奖励")
	};

get(58) ->
	#active_service_conf{
		id = 58,
		type = 14,
		rank = 0,
		value = 35,
		reward_zhanshi = [{110219,1,10},{110009,1,500000}],
		reward_fashi = [{110219,1,10},{110009,1,500000}],
		reward_daoshi = [{110219,1,10},{110009,1,500000}],
		reward = [],
		num = 0,
		condition_text = <<"35+">>,
		min_jade = 0,
		max_jade = 0,
		info = <<"">>,
		mail_title = xmerl_ucs:to_utf8("印记升级排行奖励"),
		mail_text = xmerl_ucs:to_utf8("恭喜获得印记升级排行榜35等级段奖励")
	};

get(59) ->
	#active_service_conf{
		id = 59,
		type = 14,
		rank = 0,
		value = 25,
		reward_zhanshi = [{110219,1,5},{110009,1,300000}],
		reward_fashi = [{110219,1,5},{110009,1,300000}],
		reward_daoshi = [{110219,1,5},{110009,1,300000}],
		reward = [],
		num = 0,
		condition_text = <<"25+">>,
		min_jade = 0,
		max_jade = 0,
		info = <<"">>,
		mail_title = xmerl_ucs:to_utf8("印记升级排行奖励"),
		mail_text = xmerl_ucs:to_utf8("恭喜获得印记升级排行榜25等级段奖励")
	};

get(60) ->
	#active_service_conf{
		id = 60,
		type = 14,
		rank = 0,
		value = 20,
		reward_zhanshi = [{110219,1,5},{110009,1,100000}],
		reward_fashi = [{110219,1,5},{110009,1,100000}],
		reward_daoshi = [{110219,1,5},{110009,1,100000}],
		reward = [],
		num = 0,
		condition_text = <<"20+">>,
		min_jade = 0,
		max_jade = 0,
		info = <<"">>,
		mail_title = xmerl_ucs:to_utf8("印记升级排行奖励"),
		mail_text = xmerl_ucs:to_utf8("恭喜获得印记升级排行榜20等级段奖励")
	};

get(61) ->
	#active_service_conf{
		id = 61,
		type = 15,
		rank = 1,
		value = 45000,
		reward_zhanshi = [{110163,1,2},{110222,1,3},{305018,1,1}],
		reward_fashi = [{110163,1,2},{110222,1,3},{305018,1,1}],
		reward_daoshi = [{110163,1,2},{110222,1,3},{305018,1,1}],
		reward = [],
		num = 1,
		condition_text = 45000,
		min_jade = 0,
		max_jade = 0,
		info = <<"">>,
		mail_title = xmerl_ucs:to_utf8("战力名人榜奖励"),
		mail_text = xmerl_ucs:to_utf8("恭喜获得战力名人排行榜全服第一奖励")
	};

get(62) ->
	#active_service_conf{
		id = 62,
		type = 15,
		rank = 2,
		value = 45000,
		reward_zhanshi = [{110163,1,2},{110222,1,2}],
		reward_fashi = [{110163,1,2},{110222,1,2}],
		reward_daoshi = [{110163,1,2},{110222,1,2}],
		reward = [],
		num = 1,
		condition_text = 45000,
		min_jade = 0,
		max_jade = 0,
		info = <<"">>,
		mail_title = xmerl_ucs:to_utf8("战力名人榜奖励"),
		mail_text = xmerl_ucs:to_utf8("恭喜获得战力名人排行榜全服第二奖励")
	};

get(63) ->
	#active_service_conf{
		id = 63,
		type = 15,
		rank = 3,
		value = 45000,
		reward_zhanshi = [{110163,1,1},{110222,1,1}],
		reward_fashi = [{110163,1,1},{110222,1,1}],
		reward_daoshi = [{110163,1,1},{110222,1,1}],
		reward = [],
		num = 1,
		condition_text = 45000,
		min_jade = 0,
		max_jade = 0,
		info = <<"">>,
		mail_title = xmerl_ucs:to_utf8("战力名人榜奖励"),
		mail_text = xmerl_ucs:to_utf8("恭喜获得战力名人排行榜全服第三奖励")
	};

get(64) ->
	#active_service_conf{
		id = 64,
		type = 15,
		rank = 0,
		value = 25000,
		reward_zhanshi = [{110109,1,2},{110003,1,30}],
		reward_fashi = [{110109,1,2},{110003,1,30}],
		reward_daoshi = [{110109,1,2},{110003,1,30}],
		reward = [],
		num = 0,
		condition_text = 25000,
		min_jade = 0,
		max_jade = 0,
		info = <<"">>,
		mail_title = xmerl_ucs:to_utf8("战力名人榜奖励"),
		mail_text = xmerl_ucs:to_utf8("恭喜获得战力25000阶段奖励")
	};

get(65) ->
	#active_service_conf{
		id = 65,
		type = 15,
		rank = 0,
		value = 15000,
		reward_zhanshi = [{110149,1,1},{110003,1,20}],
		reward_fashi = [{110149,1,1},{110003,1,20}],
		reward_daoshi = [{110149,1,1},{110003,1,20}],
		reward = [],
		num = 0,
		condition_text = 15000,
		min_jade = 0,
		max_jade = 0,
		info = <<"">>,
		mail_title = xmerl_ucs:to_utf8("战力名人榜奖励"),
		mail_text = xmerl_ucs:to_utf8("恭喜获得战力15000阶段奖励")
	};

get(66) ->
	#active_service_conf{
		id = 66,
		type = 15,
		rank = 0,
		value = 10000,
		reward_zhanshi = [{110148,1,1},{110003,1,10}],
		reward_fashi = [{110148,1,1},{110003,1,10}],
		reward_daoshi = [{110148,1,1},{110003,1,10}],
		reward = [],
		num = 0,
		condition_text = 10000,
		min_jade = 0,
		max_jade = 0,
		info = <<"">>,
		mail_title = xmerl_ucs:to_utf8("战力名人榜奖励"),
		mail_text = xmerl_ucs:to_utf8("恭喜获得战力10000阶段奖励")
	};

get(_Key) ->
	?ERR("undefined key from active_service_config ~p", [_Key]).