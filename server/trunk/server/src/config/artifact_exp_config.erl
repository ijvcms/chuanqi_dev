%%%-------------------------------------------------------------------
%%% @author zhengsiying
%%% @doc
%%%		自动生成文件，不要手动修改
%%% @end
%%% Created : 2016/10/12
%%%-------------------------------------------------------------------

-module(artifact_exp_config).

-include("common.hrl").
-include("config.hrl").

-compile([export_all]).

get_list() ->
	[{1,1}, {2,1}, {3,1}, {4,1}, {5,1}, {6,1}, {7,1}, {8,1}, {9,1}, {10,1}, {1,2}, {2,2}, {3,2}, {4,2}, {5,2}, {6,2}, {7,2}, {8,2}, {9,2}, {10,2}].

get({1,1}) ->
	#artifact_exp_conf{
		key = 1,
		lv = 1,
		star_lv = 1,
		exp = 1,
		coin = 692
	};

get({2,1}) ->
	#artifact_exp_conf{
		key = 2,
		lv = 2,
		star_lv = 1,
		exp = 1,
		coin = 9902
	};

get({3,1}) ->
	#artifact_exp_conf{
		key = 3,
		lv = 3,
		star_lv = 1,
		exp = 3,
		coin = 25462
	};

get({4,1}) ->
	#artifact_exp_conf{
		key = 4,
		lv = 4,
		star_lv = 1,
		exp = 5,
		coin = 59412
	};

get({5,1}) ->
	#artifact_exp_conf{
		key = 5,
		lv = 5,
		star_lv = 1,
		exp = 7,
		coin = 91404
	};

get({6,1}) ->
	#artifact_exp_conf{
		key = 6,
		lv = 6,
		star_lv = 1,
		exp = 9,
		coin = 148532
	};

get({7,1}) ->
	#artifact_exp_conf{
		key = 7,
		lv = 7,
		star_lv = 1,
		exp = 11,
		coin = 208467
	};

get({8,1}) ->
	#artifact_exp_conf{
		key = 8,
		lv = 8,
		star_lv = 1,
		exp = 13,
		coin = 270060
	};

get({9,1}) ->
	#artifact_exp_conf{
		key = 9,
		lv = 9,
		star_lv = 1,
		exp = 15,
		coin = 356479
	};

get({10,1}) ->
	#artifact_exp_conf{
		key = 10,
		lv = 10,
		star_lv = 1,
		exp = 19,
		coin = 459746
	};

get({1,2}) ->
	#artifact_exp_conf{
		key = 11,
		lv = 1,
		star_lv = 2,
		exp = 1,
		coin = 1039
	};

get({2,2}) ->
	#artifact_exp_conf{
		key = 12,
		lv = 2,
		star_lv = 2,
		exp = 2,
		coin = 14853
	};

get({3,2}) ->
	#artifact_exp_conf{
		key = 13,
		lv = 3,
		star_lv = 2,
		exp = 4,
		coin = 38194
	};

get({4,2}) ->
	#artifact_exp_conf{
		key = 14,
		lv = 4,
		star_lv = 2,
		exp = 6,
		coin = 89119
	};

get({5,2}) ->
	#artifact_exp_conf{
		key = 15,
		lv = 5,
		star_lv = 2,
		exp = 9,
		coin = 137107
	};

get({6,2}) ->
	#artifact_exp_conf{
		key = 16,
		lv = 6,
		star_lv = 2,
		exp = 12,
		coin = 222799
	};

get({7,2}) ->
	#artifact_exp_conf{
		key = 17,
		lv = 7,
		star_lv = 2,
		exp = 16,
		coin = 312701
	};

get({8,2}) ->
	#artifact_exp_conf{
		key = 18,
		lv = 8,
		star_lv = 2,
		exp = 20,
		coin = 405090
	};

get({9,2}) ->
	#artifact_exp_conf{
		key = 19,
		lv = 9,
		star_lv = 2,
		exp = 25,
		coin = 534719
	};

get({10,2}) ->
	#artifact_exp_conf{
		key = 20,
		lv = 10,
		star_lv = 2,
		exp = 28,
		coin = 689619
	};

get(_Key) ->
	?ERR("undefined key from artifact_exp_config ~p", [_Key]).