%%%-------------------------------------------------------------------
%%% @author zhengsiying
%%% @doc
%%%		自动生成文件，不要手动修改
%%% @end
%%% Created : 2016/10/12
%%%-------------------------------------------------------------------

-module(equips_suit_config).

-include("common.hrl").
-include("config.hrl").
-include("record.hrl").

-compile([export_all]).

get({1000, Count}) when Count >= 2 andalso Count =< 4 -> 
	#equips_suit_conf{
		key = 1000,
		min_count = 2,
		max_count = 4,
		attr_base = #attr_base{
			hp = 0,
			mp = 0,
			min_ac = 0,
			max_ac = 0,
			min_mac = 0,
			max_mac = 0,
			min_sc = 0,
			max_sc = 0,
			min_def = 7,
			max_def = 16,
			min_res = 5,
			max_res = 12,
			crit = 0,
			crit_att = 0,
			hit = 0,
			dodge = 0
		}
	};

get({1000, Count}) when Count >= 5 andalso Count =< 6 -> 
	#equips_suit_conf{
		key = 1000,
		min_count = 5,
		max_count = 6,
		attr_base = #attr_base{
			hp = 438,
			mp = 0,
			min_ac = 0,
			max_ac = 0,
			min_mac = 0,
			max_mac = 0,
			min_sc = 0,
			max_sc = 0,
			min_def = 0,
			max_def = 0,
			min_res = 0,
			max_res = 0,
			crit = 0,
			crit_att = 0,
			hit = 0,
			dodge = 0
		}
	};

get({1000, Count}) when Count >= 7 andalso Count =< 10 -> 
	#equips_suit_conf{
		key = 1000,
		min_count = 7,
		max_count = 10,
		attr_base = #attr_base{
			hp = 0,
			mp = 0,
			min_ac = 16,
			max_ac = 33,
			min_mac = 0,
			max_mac = 0,
			min_sc = 0,
			max_sc = 0,
			min_def = 0,
			max_def = 0,
			min_res = 0,
			max_res = 0,
			crit = 0,
			crit_att = 0,
			hit = 0,
			dodge = 0
		}
	};

get({1001, Count}) when Count >= 2 andalso Count =< 4 -> 
	#equips_suit_conf{
		key = 1001,
		min_count = 2,
		max_count = 4,
		attr_base = #attr_base{
			hp = 0,
			mp = 0,
			min_ac = 0,
			max_ac = 0,
			min_mac = 0,
			max_mac = 0,
			min_sc = 0,
			max_sc = 0,
			min_def = 16,
			max_def = 34,
			min_res = 12,
			max_res = 25,
			crit = 0,
			crit_att = 0,
			hit = 0,
			dodge = 0
		}
	};

get({1001, Count}) when Count >= 5 andalso Count =< 6 -> 
	#equips_suit_conf{
		key = 1001,
		min_count = 5,
		max_count = 6,
		attr_base = #attr_base{
			hp = 897,
			mp = 0,
			min_ac = 0,
			max_ac = 0,
			min_mac = 0,
			max_mac = 0,
			min_sc = 0,
			max_sc = 0,
			min_def = 0,
			max_def = 0,
			min_res = 0,
			max_res = 0,
			crit = 0,
			crit_att = 0,
			hit = 0,
			dodge = 0
		}
	};

get({1001, Count}) when Count >= 7 andalso Count =< 10 -> 
	#equips_suit_conf{
		key = 1001,
		min_count = 7,
		max_count = 10,
		attr_base = #attr_base{
			hp = 0,
			mp = 0,
			min_ac = 34,
			max_ac = 69,
			min_mac = 0,
			max_mac = 0,
			min_sc = 0,
			max_sc = 0,
			min_def = 0,
			max_def = 0,
			min_res = 0,
			max_res = 0,
			crit = 0,
			crit_att = 0,
			hit = 0,
			dodge = 0
		}
	};

get({1002, Count}) when Count >= 2 andalso Count =< 4 -> 
	#equips_suit_conf{
		key = 1002,
		min_count = 2,
		max_count = 4,
		attr_base = #attr_base{
			hp = 0,
			mp = 0,
			min_ac = 0,
			max_ac = 0,
			min_mac = 0,
			max_mac = 0,
			min_sc = 0,
			max_sc = 0,
			min_def = 27,
			max_def = 55,
			min_res = 19,
			max_res = 40,
			crit = 0,
			crit_att = 0,
			hit = 0,
			dodge = 0
		}
	};

get({1002, Count}) when Count >= 5 andalso Count =< 6 -> 
	#equips_suit_conf{
		key = 1002,
		min_count = 5,
		max_count = 6,
		attr_base = #attr_base{
			hp = 1462,
			mp = 0,
			min_ac = 0,
			max_ac = 0,
			min_mac = 0,
			max_mac = 0,
			min_sc = 0,
			max_sc = 0,
			min_def = 0,
			max_def = 0,
			min_res = 0,
			max_res = 0,
			crit = 0,
			crit_att = 0,
			hit = 0,
			dodge = 0
		}
	};

get({1002, Count}) when Count >= 7 andalso Count =< 10 -> 
	#equips_suit_conf{
		key = 1002,
		min_count = 7,
		max_count = 10,
		attr_base = #attr_base{
			hp = 0,
			mp = 0,
			min_ac = 56,
			max_ac = 112,
			min_mac = 0,
			max_mac = 0,
			min_sc = 0,
			max_sc = 0,
			min_def = 0,
			max_def = 0,
			min_res = 0,
			max_res = 0,
			crit = 0,
			crit_att = 0,
			hit = 0,
			dodge = 0
		}
	};

get({1003, Count}) when Count >= 2 andalso Count =< 4 -> 
	#equips_suit_conf{
		key = 1003,
		min_count = 2,
		max_count = 4,
		attr_base = #attr_base{
			hp = 0,
			mp = 0,
			min_ac = 0,
			max_ac = 0,
			min_mac = 0,
			max_mac = 0,
			min_sc = 0,
			max_sc = 0,
			min_def = 45,
			max_def = 90,
			min_res = 33,
			max_res = 66,
			crit = 0,
			crit_att = 0,
			hit = 0,
			dodge = 0
		}
	};

get({1003, Count}) when Count >= 5 andalso Count =< 6 -> 
	#equips_suit_conf{
		key = 1003,
		min_count = 5,
		max_count = 6,
		attr_base = #attr_base{
			hp = 2340,
			mp = 0,
			min_ac = 0,
			max_ac = 0,
			min_mac = 0,
			max_mac = 0,
			min_sc = 0,
			max_sc = 0,
			min_def = 0,
			max_def = 0,
			min_res = 0,
			max_res = 0,
			crit = 0,
			crit_att = 0,
			hit = 0,
			dodge = 0
		}
	};

get({1003, Count}) when Count >= 7 andalso Count =< 10 -> 
	#equips_suit_conf{
		key = 1003,
		min_count = 7,
		max_count = 10,
		attr_base = #attr_base{
			hp = 0,
			mp = 0,
			min_ac = 90,
			max_ac = 180,
			min_mac = 0,
			max_mac = 0,
			min_sc = 0,
			max_sc = 0,
			min_def = 0,
			max_def = 0,
			min_res = 0,
			max_res = 0,
			crit = 0,
			crit_att = 0,
			hit = 0,
			dodge = 0
		}
	};

get({1004, Count}) when Count >= 2 andalso Count =< 4 -> 
	#equips_suit_conf{
		key = 1004,
		min_count = 2,
		max_count = 4,
		attr_base = #attr_base{
			hp = 0,
			mp = 0,
			min_ac = 0,
			max_ac = 0,
			min_mac = 0,
			max_mac = 0,
			min_sc = 0,
			max_sc = 0,
			min_def = 69,
			max_def = 138,
			min_res = 50,
			max_res = 101,
			crit = 0,
			crit_att = 0,
			hit = 0,
			dodge = 0
		}
	};

get({1004, Count}) when Count >= 5 andalso Count =< 6 -> 
	#equips_suit_conf{
		key = 1004,
		min_count = 5,
		max_count = 6,
		attr_base = #attr_base{
			hp = 3616,
			mp = 0,
			min_ac = 0,
			max_ac = 0,
			min_mac = 0,
			max_mac = 0,
			min_sc = 0,
			max_sc = 0,
			min_def = 0,
			max_def = 0,
			min_res = 0,
			max_res = 0,
			crit = 0,
			crit_att = 0,
			hit = 0,
			dodge = 0
		}
	};

get({1004, Count}) when Count >= 7 andalso Count =< 10 -> 
	#equips_suit_conf{
		key = 1004,
		min_count = 7,
		max_count = 10,
		attr_base = #attr_base{
			hp = 0,
			mp = 0,
			min_ac = 139,
			max_ac = 278,
			min_mac = 0,
			max_mac = 0,
			min_sc = 0,
			max_sc = 0,
			min_def = 0,
			max_def = 0,
			min_res = 0,
			max_res = 0,
			crit = 0,
			crit_att = 0,
			hit = 0,
			dodge = 0
		}
	};

get({1005, Count}) when Count >= 2 andalso Count =< 4 -> 
	#equips_suit_conf{
		key = 1005,
		min_count = 2,
		max_count = 4,
		attr_base = #attr_base{
			hp = 0,
			mp = 0,
			min_ac = 0,
			max_ac = 0,
			min_mac = 0,
			max_mac = 0,
			min_sc = 0,
			max_sc = 0,
			min_def = 105,
			max_def = 210,
			min_res = 77,
			max_res = 154,
			crit = 0,
			crit_att = 0,
			hit = 0,
			dodge = 0
		}
	};

get({1005, Count}) when Count >= 5 andalso Count =< 6 -> 
	#equips_suit_conf{
		key = 1005,
		min_count = 5,
		max_count = 6,
		attr_base = #attr_base{
			hp = 5460,
			mp = 0,
			min_ac = 0,
			max_ac = 0,
			min_mac = 0,
			max_mac = 0,
			min_sc = 0,
			max_sc = 0,
			min_def = 0,
			max_def = 0,
			min_res = 0,
			max_res = 0,
			crit = 0,
			crit_att = 0,
			hit = 0,
			dodge = 0
		}
	};

get({1005, Count}) when Count >= 7 andalso Count =< 10 -> 
	#equips_suit_conf{
		key = 1005,
		min_count = 7,
		max_count = 10,
		attr_base = #attr_base{
			hp = 0,
			mp = 0,
			min_ac = 210,
			max_ac = 420,
			min_mac = 0,
			max_mac = 0,
			min_sc = 0,
			max_sc = 0,
			min_def = 0,
			max_def = 0,
			min_res = 0,
			max_res = 0,
			crit = 0,
			crit_att = 0,
			hit = 0,
			dodge = 0
		}
	};

get({1006, Count}) when Count >= 2 andalso Count =< 4 -> 
	#equips_suit_conf{
		key = 1006,
		min_count = 2,
		max_count = 4,
		attr_base = #attr_base{
			hp = 0,
			mp = 0,
			min_ac = 0,
			max_ac = 0,
			min_mac = 0,
			max_mac = 0,
			min_sc = 0,
			max_sc = 0,
			min_def = 151,
			max_def = 303,
			min_res = 111,
			max_res = 222,
			crit = 0,
			crit_att = 0,
			hit = 0,
			dodge = 0
		}
	};

get({1006, Count}) when Count >= 5 andalso Count =< 6 -> 
	#equips_suit_conf{
		key = 1006,
		min_count = 5,
		max_count = 6,
		attr_base = #attr_base{
			hp = 7897,
			mp = 0,
			min_ac = 0,
			max_ac = 0,
			min_mac = 0,
			max_mac = 0,
			min_sc = 0,
			max_sc = 0,
			min_def = 0,
			max_def = 0,
			min_res = 0,
			max_res = 0,
			crit = 0,
			crit_att = 0,
			hit = 0,
			dodge = 0
		}
	};

get({1006, Count}) when Count >= 7 andalso Count =< 10 -> 
	#equips_suit_conf{
		key = 1006,
		min_count = 7,
		max_count = 10,
		attr_base = #attr_base{
			hp = 0,
			mp = 0,
			min_ac = 303,
			max_ac = 607,
			min_mac = 0,
			max_mac = 0,
			min_sc = 0,
			max_sc = 0,
			min_def = 0,
			max_def = 0,
			min_res = 0,
			max_res = 0,
			crit = 0,
			crit_att = 0,
			hit = 0,
			dodge = 0
		}
	};

get({1007, Count}) when Count >= 2 andalso Count =< 4 -> 
	#equips_suit_conf{
		key = 1007,
		min_count = 2,
		max_count = 4,
		attr_base = #attr_base{
			hp = 0,
			mp = 0,
			min_ac = 0,
			max_ac = 0,
			min_mac = 0,
			max_mac = 0,
			min_sc = 0,
			max_sc = 0,
			min_def = 214,
			max_def = 430,
			min_res = 157,
			max_res = 315,
			crit = 0,
			crit_att = 0,
			hit = 0,
			dodge = 0
		}
	};

get({1007, Count}) when Count >= 5 andalso Count =< 6 -> 
	#equips_suit_conf{
		key = 1007,
		min_count = 5,
		max_count = 6,
		attr_base = #attr_base{
			hp = 11212,
			mp = 0,
			min_ac = 0,
			max_ac = 0,
			min_mac = 0,
			max_mac = 0,
			min_sc = 0,
			max_sc = 0,
			min_def = 0,
			max_def = 0,
			min_res = 0,
			max_res = 0,
			crit = 0,
			crit_att = 0,
			hit = 0,
			dodge = 0
		}
	};

get({1007, Count}) when Count >= 7 andalso Count =< 10 -> 
	#equips_suit_conf{
		key = 1007,
		min_count = 7,
		max_count = 10,
		attr_base = #attr_base{
			hp = 0,
			mp = 0,
			min_ac = 431,
			max_ac = 862,
			min_mac = 0,
			max_mac = 0,
			min_sc = 0,
			max_sc = 0,
			min_def = 0,
			max_def = 0,
			min_res = 0,
			max_res = 0,
			crit = 0,
			crit_att = 0,
			hit = 0,
			dodge = 0
		}
	};

get({1008, Count}) when Count >= 2 andalso Count =< 4 -> 
	#equips_suit_conf{
		key = 1008,
		min_count = 2,
		max_count = 4,
		attr_base = #attr_base{
			hp = 0,
			mp = 0,
			min_ac = 0,
			max_ac = 0,
			min_mac = 0,
			max_mac = 0,
			min_sc = 0,
			max_sc = 0,
			min_def = 288,
			max_def = 577,
			min_res = 211,
			max_res = 423,
			crit = 0,
			crit_att = 0,
			hit = 0,
			dodge = 0
		}
	};

get({1008, Count}) when Count >= 5 andalso Count =< 6 -> 
	#equips_suit_conf{
		key = 1008,
		min_count = 5,
		max_count = 6,
		attr_base = #attr_base{
			hp = 15015,
			mp = 0,
			min_ac = 0,
			max_ac = 0,
			min_mac = 0,
			max_mac = 0,
			min_sc = 0,
			max_sc = 0,
			min_def = 0,
			max_def = 0,
			min_res = 0,
			max_res = 0,
			crit = 0,
			crit_att = 0,
			hit = 0,
			dodge = 0
		}
	};

get({1008, Count}) when Count >= 7 andalso Count =< 10 -> 
	#equips_suit_conf{
		key = 1008,
		min_count = 7,
		max_count = 10,
		attr_base = #attr_base{
			hp = 0,
			mp = 0,
			min_ac = 577,
			max_ac = 1155,
			min_mac = 0,
			max_mac = 0,
			min_sc = 0,
			max_sc = 0,
			min_def = 0,
			max_def = 0,
			min_res = 0,
			max_res = 0,
			crit = 0,
			crit_att = 0,
			hit = 0,
			dodge = 0
		}
	};

get({2000, Count}) when Count >= 2 andalso Count =< 4 -> 
	#equips_suit_conf{
		key = 2000,
		min_count = 2,
		max_count = 4,
		attr_base = #attr_base{
			hp = 0,
			mp = 0,
			min_ac = 0,
			max_ac = 0,
			min_mac = 0,
			max_mac = 0,
			min_sc = 0,
			max_sc = 0,
			min_def = 3,
			max_def = 7,
			min_res = 6,
			max_res = 14,
			crit = 0,
			crit_att = 0,
			hit = 0,
			dodge = 0
		}
	};

get({2000, Count}) when Count >= 5 andalso Count =< 6 -> 
	#equips_suit_conf{
		key = 2000,
		min_count = 5,
		max_count = 6,
		attr_base = #attr_base{
			hp = 235,
			mp = 0,
			min_ac = 0,
			max_ac = 0,
			min_mac = 0,
			max_mac = 0,
			min_sc = 0,
			max_sc = 0,
			min_def = 0,
			max_def = 0,
			min_res = 0,
			max_res = 0,
			crit = 0,
			crit_att = 0,
			hit = 0,
			dodge = 0
		}
	};

get({2000, Count}) when Count >= 7 andalso Count =< 10 -> 
	#equips_suit_conf{
		key = 2000,
		min_count = 7,
		max_count = 10,
		attr_base = #attr_base{
			hp = 0,
			mp = 0,
			min_ac = 0,
			max_ac = 0,
			min_mac = 17,
			max_mac = 36,
			min_sc = 0,
			max_sc = 0,
			min_def = 0,
			max_def = 0,
			min_res = 0,
			max_res = 0,
			crit = 0,
			crit_att = 0,
			hit = 0,
			dodge = 0
		}
	};

get({2001, Count}) when Count >= 2 andalso Count =< 4 -> 
	#equips_suit_conf{
		key = 2001,
		min_count = 2,
		max_count = 4,
		attr_base = #attr_base{
			hp = 0,
			mp = 0,
			min_ac = 0,
			max_ac = 0,
			min_mac = 0,
			max_mac = 0,
			min_sc = 0,
			max_sc = 0,
			min_def = 7,
			max_def = 16,
			min_res = 14,
			max_res = 29,
			crit = 0,
			crit_att = 0,
			hit = 0,
			dodge = 0
		}
	};

get({2001, Count}) when Count >= 5 andalso Count =< 6 -> 
	#equips_suit_conf{
		key = 2001,
		min_count = 5,
		max_count = 6,
		attr_base = #attr_base{
			hp = 483,
			mp = 0,
			min_ac = 0,
			max_ac = 0,
			min_mac = 0,
			max_mac = 0,
			min_sc = 0,
			max_sc = 0,
			min_def = 0,
			max_def = 0,
			min_res = 0,
			max_res = 0,
			crit = 0,
			crit_att = 0,
			hit = 0,
			dodge = 0
		}
	};

get({2001, Count}) when Count >= 7 andalso Count =< 10 -> 
	#equips_suit_conf{
		key = 2001,
		min_count = 7,
		max_count = 10,
		attr_base = #attr_base{
			hp = 0,
			mp = 0,
			min_ac = 0,
			max_ac = 0,
			min_mac = 37,
			max_mac = 75,
			min_sc = 0,
			max_sc = 0,
			min_def = 0,
			max_def = 0,
			min_res = 0,
			max_res = 0,
			crit = 0,
			crit_att = 0,
			hit = 0,
			dodge = 0
		}
	};

get({2002, Count}) when Count >= 2 andalso Count =< 4 -> 
	#equips_suit_conf{
		key = 2002,
		min_count = 2,
		max_count = 4,
		attr_base = #attr_base{
			hp = 0,
			mp = 0,
			min_ac = 0,
			max_ac = 0,
			min_mac = 0,
			max_mac = 0,
			min_sc = 0,
			max_sc = 0,
			min_def = 12,
			max_def = 25,
			min_res = 23,
			max_res = 48,
			crit = 0,
			crit_att = 0,
			hit = 0,
			dodge = 0
		}
	};

get({2002, Count}) when Count >= 5 andalso Count =< 6 -> 
	#equips_suit_conf{
		key = 2002,
		min_count = 5,
		max_count = 6,
		attr_base = #attr_base{
			hp = 787,
			mp = 0,
			min_ac = 0,
			max_ac = 0,
			min_mac = 0,
			max_mac = 0,
			min_sc = 0,
			max_sc = 0,
			min_def = 0,
			max_def = 0,
			min_res = 0,
			max_res = 0,
			crit = 0,
			crit_att = 0,
			hit = 0,
			dodge = 0
		}
	};

get({2002, Count}) when Count >= 7 andalso Count =< 10 -> 
	#equips_suit_conf{
		key = 2002,
		min_count = 7,
		max_count = 10,
		attr_base = #attr_base{
			hp = 0,
			mp = 0,
			min_ac = 0,
			max_ac = 0,
			min_mac = 61,
			max_mac = 123,
			min_sc = 0,
			max_sc = 0,
			min_def = 0,
			max_def = 0,
			min_res = 0,
			max_res = 0,
			crit = 0,
			crit_att = 0,
			hit = 0,
			dodge = 0
		}
	};

get({2003, Count}) when Count >= 2 andalso Count =< 4 -> 
	#equips_suit_conf{
		key = 2003,
		min_count = 2,
		max_count = 4,
		attr_base = #attr_base{
			hp = 0,
			mp = 0,
			min_ac = 0,
			max_ac = 0,
			min_mac = 0,
			max_mac = 0,
			min_sc = 0,
			max_sc = 0,
			min_def = 21,
			max_def = 42,
			min_res = 39,
			max_res = 78,
			crit = 0,
			crit_att = 0,
			hit = 0,
			dodge = 0
		}
	};

get({2003, Count}) when Count >= 5 andalso Count =< 6 -> 
	#equips_suit_conf{
		key = 2003,
		min_count = 5,
		max_count = 6,
		attr_base = #attr_base{
			hp = 1260,
			mp = 0,
			min_ac = 0,
			max_ac = 0,
			min_mac = 0,
			max_mac = 0,
			min_sc = 0,
			max_sc = 0,
			min_def = 0,
			max_def = 0,
			min_res = 0,
			max_res = 0,
			crit = 0,
			crit_att = 0,
			hit = 0,
			dodge = 0
		}
	};

get({2003, Count}) when Count >= 7 andalso Count =< 10 -> 
	#equips_suit_conf{
		key = 2003,
		min_count = 7,
		max_count = 10,
		attr_base = #attr_base{
			hp = 0,
			mp = 0,
			min_ac = 0,
			max_ac = 0,
			min_mac = 99,
			max_mac = 198,
			min_sc = 0,
			max_sc = 0,
			min_def = 0,
			max_def = 0,
			min_res = 0,
			max_res = 0,
			crit = 0,
			crit_att = 0,
			hit = 0,
			dodge = 0
		}
	};

get({2004, Count}) when Count >= 2 andalso Count =< 4 -> 
	#equips_suit_conf{
		key = 2004,
		min_count = 2,
		max_count = 4,
		attr_base = #attr_base{
			hp = 0,
			mp = 0,
			min_ac = 0,
			max_ac = 0,
			min_mac = 0,
			max_mac = 0,
			min_sc = 0,
			max_sc = 0,
			min_def = 32,
			max_def = 64,
			min_res = 59,
			max_res = 119,
			crit = 0,
			crit_att = 0,
			hit = 0,
			dodge = 0
		}
	};

get({2004, Count}) when Count >= 5 andalso Count =< 6 -> 
	#equips_suit_conf{
		key = 2004,
		min_count = 5,
		max_count = 6,
		attr_base = #attr_base{
			hp = 1947,
			mp = 0,
			min_ac = 0,
			max_ac = 0,
			min_mac = 0,
			max_mac = 0,
			min_sc = 0,
			max_sc = 0,
			min_def = 0,
			max_def = 0,
			min_res = 0,
			max_res = 0,
			crit = 0,
			crit_att = 0,
			hit = 0,
			dodge = 0
		}
	};

get({2004, Count}) when Count >= 7 andalso Count =< 10 -> 
	#equips_suit_conf{
		key = 2004,
		min_count = 7,
		max_count = 10,
		attr_base = #attr_base{
			hp = 0,
			mp = 0,
			min_ac = 0,
			max_ac = 0,
			min_mac = 152,
			max_mac = 305,
			min_sc = 0,
			max_sc = 0,
			min_def = 0,
			max_def = 0,
			min_res = 0,
			max_res = 0,
			crit = 0,
			crit_att = 0,
			hit = 0,
			dodge = 0
		}
	};

get({2005, Count}) when Count >= 2 andalso Count =< 4 -> 
	#equips_suit_conf{
		key = 2005,
		min_count = 2,
		max_count = 4,
		attr_base = #attr_base{
			hp = 0,
			mp = 0,
			min_ac = 0,
			max_ac = 0,
			min_mac = 0,
			max_mac = 0,
			min_sc = 0,
			max_sc = 0,
			min_def = 49,
			max_def = 98,
			min_res = 91,
			max_res = 182,
			crit = 0,
			crit_att = 0,
			hit = 0,
			dodge = 0
		}
	};

get({2005, Count}) when Count >= 5 andalso Count =< 6 -> 
	#equips_suit_conf{
		key = 2005,
		min_count = 5,
		max_count = 6,
		attr_base = #attr_base{
			hp = 2940,
			mp = 0,
			min_ac = 0,
			max_ac = 0,
			min_mac = 0,
			max_mac = 0,
			min_sc = 0,
			max_sc = 0,
			min_def = 0,
			max_def = 0,
			min_res = 0,
			max_res = 0,
			crit = 0,
			crit_att = 0,
			hit = 0,
			dodge = 0
		}
	};

get({2005, Count}) when Count >= 7 andalso Count =< 10 -> 
	#equips_suit_conf{
		key = 2005,
		min_count = 7,
		max_count = 10,
		attr_base = #attr_base{
			hp = 0,
			mp = 0,
			min_ac = 0,
			max_ac = 0,
			min_mac = 231,
			max_mac = 462,
			min_sc = 0,
			max_sc = 0,
			min_def = 0,
			max_def = 0,
			min_res = 0,
			max_res = 0,
			crit = 0,
			crit_att = 0,
			hit = 0,
			dodge = 0
		}
	};

get({2006, Count}) when Count >= 2 andalso Count =< 4 -> 
	#equips_suit_conf{
		key = 2006,
		min_count = 2,
		max_count = 4,
		attr_base = #attr_base{
			hp = 0,
			mp = 0,
			min_ac = 0,
			max_ac = 0,
			min_mac = 0,
			max_mac = 0,
			min_sc = 0,
			max_sc = 0,
			min_def = 70,
			max_def = 141,
			min_res = 131,
			max_res = 262,
			crit = 0,
			crit_att = 0,
			hit = 0,
			dodge = 0
		}
	};

get({2006, Count}) when Count >= 5 andalso Count =< 6 -> 
	#equips_suit_conf{
		key = 2006,
		min_count = 5,
		max_count = 6,
		attr_base = #attr_base{
			hp = 4252,
			mp = 0,
			min_ac = 0,
			max_ac = 0,
			min_mac = 0,
			max_mac = 0,
			min_sc = 0,
			max_sc = 0,
			min_def = 0,
			max_def = 0,
			min_res = 0,
			max_res = 0,
			crit = 0,
			crit_att = 0,
			hit = 0,
			dodge = 0
		}
	};

get({2006, Count}) when Count >= 7 andalso Count =< 10 -> 
	#equips_suit_conf{
		key = 2006,
		min_count = 7,
		max_count = 10,
		attr_base = #attr_base{
			hp = 0,
			mp = 0,
			min_ac = 0,
			max_ac = 0,
			min_mac = 333,
			max_mac = 667,
			min_sc = 0,
			max_sc = 0,
			min_def = 0,
			max_def = 0,
			min_res = 0,
			max_res = 0,
			crit = 0,
			crit_att = 0,
			hit = 0,
			dodge = 0
		}
	};

get({2007, Count}) when Count >= 2 andalso Count =< 4 -> 
	#equips_suit_conf{
		key = 2007,
		min_count = 2,
		max_count = 4,
		attr_base = #attr_base{
			hp = 0,
			mp = 0,
			min_ac = 0,
			max_ac = 0,
			min_mac = 0,
			max_mac = 0,
			min_sc = 0,
			max_sc = 0,
			min_def = 100,
			max_def = 200,
			min_res = 185,
			max_res = 373,
			crit = 0,
			crit_att = 0,
			hit = 0,
			dodge = 0
		}
	};

get({2007, Count}) when Count >= 5 andalso Count =< 6 -> 
	#equips_suit_conf{
		key = 2007,
		min_count = 5,
		max_count = 6,
		attr_base = #attr_base{
			hp = 6037,
			mp = 0,
			min_ac = 0,
			max_ac = 0,
			min_mac = 0,
			max_mac = 0,
			min_sc = 0,
			max_sc = 0,
			min_def = 0,
			max_def = 0,
			min_res = 0,
			max_res = 0,
			crit = 0,
			crit_att = 0,
			hit = 0,
			dodge = 0
		}
	};

get({2007, Count}) when Count >= 7 andalso Count =< 10 -> 
	#equips_suit_conf{
		key = 2007,
		min_count = 7,
		max_count = 10,
		attr_base = #attr_base{
			hp = 0,
			mp = 0,
			min_ac = 0,
			max_ac = 0,
			min_mac = 474,
			max_mac = 948,
			min_sc = 0,
			max_sc = 0,
			min_def = 0,
			max_def = 0,
			min_res = 0,
			max_res = 0,
			crit = 0,
			crit_att = 0,
			hit = 0,
			dodge = 0
		}
	};

get({2008, Count}) when Count >= 2 andalso Count =< 4 -> 
	#equips_suit_conf{
		key = 2008,
		min_count = 2,
		max_count = 4,
		attr_base = #attr_base{
			hp = 0,
			mp = 0,
			min_ac = 0,
			max_ac = 0,
			min_mac = 0,
			max_mac = 0,
			min_sc = 0,
			max_sc = 0,
			min_def = 134,
			max_def = 269,
			min_res = 249,
			max_res = 500,
			crit = 0,
			crit_att = 0,
			hit = 0,
			dodge = 0
		}
	};

get({2008, Count}) when Count >= 5 andalso Count =< 6 -> 
	#equips_suit_conf{
		key = 2008,
		min_count = 5,
		max_count = 6,
		attr_base = #attr_base{
			hp = 8085,
			mp = 0,
			min_ac = 0,
			max_ac = 0,
			min_mac = 0,
			max_mac = 0,
			min_sc = 0,
			max_sc = 0,
			min_def = 0,
			max_def = 0,
			min_res = 0,
			max_res = 0,
			crit = 0,
			crit_att = 0,
			hit = 0,
			dodge = 0
		}
	};

get({2008, Count}) when Count >= 7 andalso Count =< 10 -> 
	#equips_suit_conf{
		key = 2008,
		min_count = 7,
		max_count = 10,
		attr_base = #attr_base{
			hp = 0,
			mp = 0,
			min_ac = 0,
			max_ac = 0,
			min_mac = 634,
			max_mac = 1270,
			min_sc = 0,
			max_sc = 0,
			min_def = 0,
			max_def = 0,
			min_res = 0,
			max_res = 0,
			crit = 0,
			crit_att = 0,
			hit = 0,
			dodge = 0
		}
	};

get({3000, Count}) when Count >= 2 andalso Count =< 4 -> 
	#equips_suit_conf{
		key = 3000,
		min_count = 2,
		max_count = 4,
		attr_base = #attr_base{
			hp = 0,
			mp = 0,
			min_ac = 0,
			max_ac = 0,
			min_mac = 0,
			max_mac = 0,
			min_sc = 0,
			max_sc = 0,
			min_def = 5,
			max_def = 11,
			min_res = 5,
			max_res = 11,
			crit = 0,
			crit_att = 0,
			hit = 0,
			dodge = 0
		}
	};

get({3000, Count}) when Count >= 5 andalso Count =< 6 -> 
	#equips_suit_conf{
		key = 3000,
		min_count = 5,
		max_count = 6,
		attr_base = #attr_base{
			hp = 337,
			mp = 0,
			min_ac = 0,
			max_ac = 0,
			min_mac = 0,
			max_mac = 0,
			min_sc = 0,
			max_sc = 0,
			min_def = 0,
			max_def = 0,
			min_res = 0,
			max_res = 0,
			crit = 0,
			crit_att = 0,
			hit = 0,
			dodge = 0
		}
	};

get({3000, Count}) when Count >= 7 andalso Count =< 10 -> 
	#equips_suit_conf{
		key = 3000,
		min_count = 7,
		max_count = 10,
		attr_base = #attr_base{
			hp = 0,
			mp = 0,
			min_ac = 0,
			max_ac = 0,
			min_mac = 0,
			max_mac = 0,
			min_sc = 16,
			max_sc = 33,
			min_def = 0,
			max_def = 0,
			min_res = 0,
			max_res = 0,
			crit = 0,
			crit_att = 0,
			hit = 0,
			dodge = 0
		}
	};

get({3001, Count}) when Count >= 2 andalso Count =< 4 -> 
	#equips_suit_conf{
		key = 3001,
		min_count = 2,
		max_count = 4,
		attr_base = #attr_base{
			hp = 0,
			mp = 0,
			min_ac = 0,
			max_ac = 0,
			min_mac = 0,
			max_mac = 0,
			min_sc = 0,
			max_sc = 0,
			min_def = 11,
			max_def = 23,
			min_res = 11,
			max_res = 23,
			crit = 0,
			crit_att = 0,
			hit = 0,
			dodge = 0
		}
	};

get({3001, Count}) when Count >= 5 andalso Count =< 6 -> 
	#equips_suit_conf{
		key = 3001,
		min_count = 5,
		max_count = 6,
		attr_base = #attr_base{
			hp = 690,
			mp = 0,
			min_ac = 0,
			max_ac = 0,
			min_mac = 0,
			max_mac = 0,
			min_sc = 0,
			max_sc = 0,
			min_def = 0,
			max_def = 0,
			min_res = 0,
			max_res = 0,
			crit = 0,
			crit_att = 0,
			hit = 0,
			dodge = 0
		}
	};

get({3001, Count}) when Count >= 7 andalso Count =< 10 -> 
	#equips_suit_conf{
		key = 3001,
		min_count = 7,
		max_count = 10,
		attr_base = #attr_base{
			hp = 0,
			mp = 0,
			min_ac = 0,
			max_ac = 0,
			min_mac = 0,
			max_mac = 0,
			min_sc = 34,
			max_sc = 69,
			min_def = 0,
			max_def = 0,
			min_res = 0,
			max_res = 0,
			crit = 0,
			crit_att = 0,
			hit = 0,
			dodge = 0
		}
	};

get({3002, Count}) when Count >= 2 andalso Count =< 4 -> 
	#equips_suit_conf{
		key = 3002,
		min_count = 2,
		max_count = 4,
		attr_base = #attr_base{
			hp = 0,
			mp = 0,
			min_ac = 0,
			max_ac = 0,
			min_mac = 0,
			max_mac = 0,
			min_sc = 0,
			max_sc = 0,
			min_def = 18,
			max_def = 37,
			min_res = 18,
			max_res = 37,
			crit = 0,
			crit_att = 0,
			hit = 0,
			dodge = 0
		}
	};

get({3002, Count}) when Count >= 5 andalso Count =< 6 -> 
	#equips_suit_conf{
		key = 3002,
		min_count = 5,
		max_count = 6,
		attr_base = #attr_base{
			hp = 1125,
			mp = 0,
			min_ac = 0,
			max_ac = 0,
			min_mac = 0,
			max_mac = 0,
			min_sc = 0,
			max_sc = 0,
			min_def = 0,
			max_def = 0,
			min_res = 0,
			max_res = 0,
			crit = 0,
			crit_att = 0,
			hit = 0,
			dodge = 0
		}
	};

get({3002, Count}) when Count >= 7 andalso Count =< 10 -> 
	#equips_suit_conf{
		key = 3002,
		min_count = 7,
		max_count = 10,
		attr_base = #attr_base{
			hp = 0,
			mp = 0,
			min_ac = 0,
			max_ac = 0,
			min_mac = 0,
			max_mac = 0,
			min_sc = 56,
			max_sc = 112,
			min_def = 0,
			max_def = 0,
			min_res = 0,
			max_res = 0,
			crit = 0,
			crit_att = 0,
			hit = 0,
			dodge = 0
		}
	};

get({3003, Count}) when Count >= 2 andalso Count =< 4 -> 
	#equips_suit_conf{
		key = 3003,
		min_count = 2,
		max_count = 4,
		attr_base = #attr_base{
			hp = 0,
			mp = 0,
			min_ac = 0,
			max_ac = 0,
			min_mac = 0,
			max_mac = 0,
			min_sc = 0,
			max_sc = 0,
			min_def = 30,
			max_def = 60,
			min_res = 30,
			max_res = 60,
			crit = 0,
			crit_att = 0,
			hit = 0,
			dodge = 0
		}
	};

get({3003, Count}) when Count >= 5 andalso Count =< 6 -> 
	#equips_suit_conf{
		key = 3003,
		min_count = 5,
		max_count = 6,
		attr_base = #attr_base{
			hp = 1800,
			mp = 0,
			min_ac = 0,
			max_ac = 0,
			min_mac = 0,
			max_mac = 0,
			min_sc = 0,
			max_sc = 0,
			min_def = 0,
			max_def = 0,
			min_res = 0,
			max_res = 0,
			crit = 0,
			crit_att = 0,
			hit = 0,
			dodge = 0
		}
	};

get({3003, Count}) when Count >= 7 andalso Count =< 10 -> 
	#equips_suit_conf{
		key = 3003,
		min_count = 7,
		max_count = 10,
		attr_base = #attr_base{
			hp = 0,
			mp = 0,
			min_ac = 0,
			max_ac = 0,
			min_mac = 0,
			max_mac = 0,
			min_sc = 90,
			max_sc = 180,
			min_def = 0,
			max_def = 0,
			min_res = 0,
			max_res = 0,
			crit = 0,
			crit_att = 0,
			hit = 0,
			dodge = 0
		}
	};

get({3004, Count}) when Count >= 2 andalso Count =< 4 -> 
	#equips_suit_conf{
		key = 3004,
		min_count = 2,
		max_count = 4,
		attr_base = #attr_base{
			hp = 0,
			mp = 0,
			min_ac = 0,
			max_ac = 0,
			min_mac = 0,
			max_mac = 0,
			min_sc = 0,
			max_sc = 0,
			min_def = 46,
			max_def = 92,
			min_res = 46,
			max_res = 92,
			crit = 0,
			crit_att = 0,
			hit = 0,
			dodge = 0
		}
	};

get({3004, Count}) when Count >= 5 andalso Count =< 6 -> 
	#equips_suit_conf{
		key = 3004,
		min_count = 5,
		max_count = 6,
		attr_base = #attr_base{
			hp = 2782,
			mp = 0,
			min_ac = 0,
			max_ac = 0,
			min_mac = 0,
			max_mac = 0,
			min_sc = 0,
			max_sc = 0,
			min_def = 0,
			max_def = 0,
			min_res = 0,
			max_res = 0,
			crit = 0,
			crit_att = 0,
			hit = 0,
			dodge = 0
		}
	};

get({3004, Count}) when Count >= 7 andalso Count =< 10 -> 
	#equips_suit_conf{
		key = 3004,
		min_count = 7,
		max_count = 10,
		attr_base = #attr_base{
			hp = 0,
			mp = 0,
			min_ac = 0,
			max_ac = 0,
			min_mac = 0,
			max_mac = 0,
			min_sc = 139,
			max_sc = 278,
			min_def = 0,
			max_def = 0,
			min_res = 0,
			max_res = 0,
			crit = 0,
			crit_att = 0,
			hit = 0,
			dodge = 0
		}
	};

get({3005, Count}) when Count >= 2 andalso Count =< 4 -> 
	#equips_suit_conf{
		key = 3005,
		min_count = 2,
		max_count = 4,
		attr_base = #attr_base{
			hp = 0,
			mp = 0,
			min_ac = 0,
			max_ac = 0,
			min_mac = 0,
			max_mac = 0,
			min_sc = 0,
			max_sc = 0,
			min_def = 70,
			max_def = 140,
			min_res = 70,
			max_res = 140,
			crit = 0,
			crit_att = 0,
			hit = 0,
			dodge = 0
		}
	};

get({3005, Count}) when Count >= 5 andalso Count =< 6 -> 
	#equips_suit_conf{
		key = 3005,
		min_count = 5,
		max_count = 6,
		attr_base = #attr_base{
			hp = 4200,
			mp = 0,
			min_ac = 0,
			max_ac = 0,
			min_mac = 0,
			max_mac = 0,
			min_sc = 0,
			max_sc = 0,
			min_def = 0,
			max_def = 0,
			min_res = 0,
			max_res = 0,
			crit = 0,
			crit_att = 0,
			hit = 0,
			dodge = 0
		}
	};

get({3005, Count}) when Count >= 7 andalso Count =< 10 -> 
	#equips_suit_conf{
		key = 3005,
		min_count = 7,
		max_count = 10,
		attr_base = #attr_base{
			hp = 0,
			mp = 0,
			min_ac = 0,
			max_ac = 0,
			min_mac = 0,
			max_mac = 0,
			min_sc = 210,
			max_sc = 420,
			min_def = 0,
			max_def = 0,
			min_res = 0,
			max_res = 0,
			crit = 0,
			crit_att = 0,
			hit = 0,
			dodge = 0
		}
	};

get({3006, Count}) when Count >= 2 andalso Count =< 4 -> 
	#equips_suit_conf{
		key = 3006,
		min_count = 2,
		max_count = 4,
		attr_base = #attr_base{
			hp = 0,
			mp = 0,
			min_ac = 0,
			max_ac = 0,
			min_mac = 0,
			max_mac = 0,
			min_sc = 0,
			max_sc = 0,
			min_def = 101,
			max_def = 202,
			min_res = 101,
			max_res = 202,
			crit = 0,
			crit_att = 0,
			hit = 0,
			dodge = 0
		}
	};

get({3006, Count}) when Count >= 5 andalso Count =< 6 -> 
	#equips_suit_conf{
		key = 3006,
		min_count = 5,
		max_count = 6,
		attr_base = #attr_base{
			hp = 6075,
			mp = 0,
			min_ac = 0,
			max_ac = 0,
			min_mac = 0,
			max_mac = 0,
			min_sc = 0,
			max_sc = 0,
			min_def = 0,
			max_def = 0,
			min_res = 0,
			max_res = 0,
			crit = 0,
			crit_att = 0,
			hit = 0,
			dodge = 0
		}
	};

get({3006, Count}) when Count >= 7 andalso Count =< 10 -> 
	#equips_suit_conf{
		key = 3006,
		min_count = 7,
		max_count = 10,
		attr_base = #attr_base{
			hp = 0,
			mp = 0,
			min_ac = 0,
			max_ac = 0,
			min_mac = 0,
			max_mac = 0,
			min_sc = 303,
			max_sc = 607,
			min_def = 0,
			max_def = 0,
			min_res = 0,
			max_res = 0,
			crit = 0,
			crit_att = 0,
			hit = 0,
			dodge = 0
		}
	};

get({3007, Count}) when Count >= 2 andalso Count =< 4 -> 
	#equips_suit_conf{
		key = 3007,
		min_count = 2,
		max_count = 4,
		attr_base = #attr_base{
			hp = 0,
			mp = 0,
			min_ac = 0,
			max_ac = 0,
			min_mac = 0,
			max_mac = 0,
			min_sc = 0,
			max_sc = 0,
			min_def = 143,
			max_def = 287,
			min_res = 143,
			max_res = 287,
			crit = 0,
			crit_att = 0,
			hit = 0,
			dodge = 0
		}
	};

get({3007, Count}) when Count >= 5 andalso Count =< 6 -> 
	#equips_suit_conf{
		key = 3007,
		min_count = 5,
		max_count = 6,
		attr_base = #attr_base{
			hp = 8625,
			mp = 0,
			min_ac = 0,
			max_ac = 0,
			min_mac = 0,
			max_mac = 0,
			min_sc = 0,
			max_sc = 0,
			min_def = 0,
			max_def = 0,
			min_res = 0,
			max_res = 0,
			crit = 0,
			crit_att = 0,
			hit = 0,
			dodge = 0
		}
	};

get({3007, Count}) when Count >= 7 andalso Count =< 10 -> 
	#equips_suit_conf{
		key = 3007,
		min_count = 7,
		max_count = 10,
		attr_base = #attr_base{
			hp = 0,
			mp = 0,
			min_ac = 0,
			max_ac = 0,
			min_mac = 0,
			max_mac = 0,
			min_sc = 431,
			max_sc = 862,
			min_def = 0,
			max_def = 0,
			min_res = 0,
			max_res = 0,
			crit = 0,
			crit_att = 0,
			hit = 0,
			dodge = 0
		}
	};

get({3008, Count}) when Count >= 2 andalso Count =< 4 -> 
	#equips_suit_conf{
		key = 3008,
		min_count = 2,
		max_count = 4,
		attr_base = #attr_base{
			hp = 0,
			mp = 0,
			min_ac = 0,
			max_ac = 0,
			min_mac = 0,
			max_mac = 0,
			min_sc = 0,
			max_sc = 0,
			min_def = 192,
			max_def = 385,
			min_res = 192,
			max_res = 385,
			crit = 0,
			crit_att = 0,
			hit = 0,
			dodge = 0
		}
	};

get({3008, Count}) when Count >= 5 andalso Count =< 6 -> 
	#equips_suit_conf{
		key = 3008,
		min_count = 5,
		max_count = 6,
		attr_base = #attr_base{
			hp = 11550,
			mp = 0,
			min_ac = 0,
			max_ac = 0,
			min_mac = 0,
			max_mac = 0,
			min_sc = 0,
			max_sc = 0,
			min_def = 0,
			max_def = 0,
			min_res = 0,
			max_res = 0,
			crit = 0,
			crit_att = 0,
			hit = 0,
			dodge = 0
		}
	};

get({3008, Count}) when Count >= 7 andalso Count =< 10 -> 
	#equips_suit_conf{
		key = 3008,
		min_count = 7,
		max_count = 10,
		attr_base = #attr_base{
			hp = 0,
			mp = 0,
			min_ac = 0,
			max_ac = 0,
			min_mac = 0,
			max_mac = 0,
			min_sc = 577,
			max_sc = 1155,
			min_def = 0,
			max_def = 0,
			min_res = 0,
			max_res = 0,
			crit = 0,
			crit_att = 0,
			hit = 0,
			dodge = 0
		}
	};

get({1000}) ->
	[2,5,7];

get({1001}) ->
	[2,5,7];

get({1002}) ->
	[2,5,7];

get({1003}) ->
	[2,5,7];

get({1004}) ->
	[2,5,7];

get({1005}) ->
	[2,5,7];

get({1006}) ->
	[2,5,7];

get({1007}) ->
	[2,5,7];

get({1008}) ->
	[2,5,7];

get({2000}) ->
	[2,5,7];

get({2001}) ->
	[2,5,7];

get({2002}) ->
	[2,5,7];

get({2003}) ->
	[2,5,7];

get({2004}) ->
	[2,5,7];

get({2005}) ->
	[2,5,7];

get({2006}) ->
	[2,5,7];

get({2007}) ->
	[2,5,7];

get({2008}) ->
	[2,5,7];

get({3000}) ->
	[2,5,7];

get({3001}) ->
	[2,5,7];

get({3002}) ->
	[2,5,7];

get({3003}) ->
	[2,5,7];

get({3004}) ->
	[2,5,7];

get({3005}) ->
	[2,5,7];

get({3006}) ->
	[2,5,7];

get({3007}) ->
	[2,5,7];

get({3008}) ->
	[2,5,7];

get(_Key) ->
	skip.