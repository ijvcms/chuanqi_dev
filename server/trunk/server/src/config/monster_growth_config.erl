%%%-------------------------------------------------------------------
%%% @author zhengsiying
%%% @doc
%%%		自动生成文件，不要手动修改
%%% @end
%%% Created : 2016/10/12
%%%-------------------------------------------------------------------

-module(monster_growth_config).

-include("common.hrl").
-include("config.hrl").
-include("record.hrl").

-compile([export_all]).

get(Count) when Count >=0 andalso Count =< 2 ->
	#monster_growth_conf{
	monster_id = 7502,
	min_kill_count = 0,
	max_kill_count = 2,
		attr_base = #attr_base{
			hp = 1000,
			mp = 0,
			min_ac = 0,
			max_ac = 1,
			min_mac = 0,
			max_mac = 1,
			min_sc = 0,
			max_sc = 1,
			min_def = 0,
			max_def = 1,
			min_res = 0,
			max_res = 1,
			crit = 0,
			crit_att = 0,
			hit = 15,
			dodge = 15
		},
	drop_list = [{0, [{1,100}],[{200003,1,1,10000}]}]
	};

get(Count) when Count >=3 andalso Count =< 4 ->
	#monster_growth_conf{
	monster_id = 7502,
	min_kill_count = 3,
	max_kill_count = 4,
		attr_base = #attr_base{
			hp = 2000,
			mp = 0,
			min_ac = 0,
			max_ac = 2,
			min_mac = 0,
			max_mac = 2,
			min_sc = 0,
			max_sc = 2,
			min_def = 0,
			max_def = 2,
			min_res = 0,
			max_res = 2,
			crit = 0,
			crit_att = 0,
			hit = 15,
			dodge = 15
		},
	drop_list = [{0, [{1,100}],[{201003,1,1,10000}]}]
	};

get(Count) when Count >=5 andalso Count =< 6 ->
	#monster_growth_conf{
	monster_id = 7502,
	min_kill_count = 5,
	max_kill_count = 6,
		attr_base = #attr_base{
			hp = 3000,
			mp = 0,
			min_ac = 0,
			max_ac = 3,
			min_mac = 0,
			max_mac = 3,
			min_sc = 0,
			max_sc = 3,
			min_def = 0,
			max_def = 3,
			min_res = 0,
			max_res = 3,
			crit = 0,
			crit_att = 0,
			hit = 15,
			dodge = 15
		},
	drop_list = [{0, [{1,100}],[{200003,1,1,10000}]}]
	};

get(Count) when Count >=7 andalso Count =< 8 ->
	#monster_growth_conf{
	monster_id = 7502,
	min_kill_count = 7,
	max_kill_count = 8,
		attr_base = #attr_base{
			hp = 4000,
			mp = 0,
			min_ac = 0,
			max_ac = 4,
			min_mac = 0,
			max_mac = 4,
			min_sc = 0,
			max_sc = 4,
			min_def = 0,
			max_def = 4,
			min_res = 0,
			max_res = 4,
			crit = 0,
			crit_att = 0,
			hit = 15,
			dodge = 15
		},
	drop_list = [{0, [{1,100}],[{200003,1,1,10000}]}]
	};

get(Count) when Count >=9 andalso Count =< 10 ->
	#monster_growth_conf{
	monster_id = 7502,
	min_kill_count = 9,
	max_kill_count = 10,
		attr_base = #attr_base{
			hp = 5000,
			mp = 0,
			min_ac = 0,
			max_ac = 5,
			min_mac = 0,
			max_mac = 5,
			min_sc = 0,
			max_sc = 5,
			min_def = 0,
			max_def = 5,
			min_res = 0,
			max_res = 5,
			crit = 0,
			crit_att = 0,
			hit = 15,
			dodge = 15
		},
	drop_list = [{0, [{1,100}],[{200003,1,1,10000}]}]
	};

get(Count) when Count >=11 andalso Count =< 12 ->
	#monster_growth_conf{
	monster_id = 7502,
	min_kill_count = 11,
	max_kill_count = 12,
		attr_base = #attr_base{
			hp = 6000,
			mp = 0,
			min_ac = 0,
			max_ac = 6,
			min_mac = 0,
			max_mac = 6,
			min_sc = 0,
			max_sc = 6,
			min_def = 0,
			max_def = 6,
			min_res = 0,
			max_res = 6,
			crit = 0,
			crit_att = 0,
			hit = 15,
			dodge = 15
		},
	drop_list = [{0, [{1,100}],[{200003,1,1,10000}]}]
	};

get(Count) when Count >=13 andalso Count =< 999999 ->
	#monster_growth_conf{
	monster_id = 7502,
	min_kill_count = 13,
	max_kill_count = 999999,
		attr_base = #attr_base{
			hp = 7000,
			mp = 0,
			min_ac = 0,
			max_ac = 7,
			min_mac = 0,
			max_mac = 7,
			min_sc = 0,
			max_sc = 7,
			min_def = 0,
			max_def = 7,
			min_res = 0,
			max_res = 7,
			crit = 0,
			crit_att = 0,
			hit = 15,
			dodge = 15
		},
	drop_list = [{0, [{1,100}],[{200003,1,1,10000}]}]
	};

get(_Key) ->
	?ERR("undefined key from monster_growth_config ~p", [_Key]).