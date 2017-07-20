%%%-------------------------------------------------------------------
%%% @author zhengsiying
%%% @doc
%%%		自动生成文件，不要手动修改
%%% @end
%%% Created : 2016/10/12
%%%-------------------------------------------------------------------

-module(player_attr_config).

-include("common.hrl").
-include("config.hrl").
-include("record.hrl").

-compile([export_all]).

get_list() ->
	[{1000, 1}, {1000, 2}, {1000, 3}, {1000, 4}, {1000, 5}, {1000, 6}, {1000, 7}, {1000, 8}, {1000, 9}, {1000, 10}, {1000, 11}, {1000, 12}, {1000, 13}, {1000, 14}, {1000, 15}, {1000, 16}, {1000, 17}, {1000, 18}, {1000, 19}, {1000, 20}, {1000, 21}, {1000, 22}, {1000, 23}, {1000, 24}, {1000, 25}, {1000, 26}, {1000, 27}, {1000, 28}, {1000, 29}, {1000, 30}, {1000, 31}, {1000, 32}, {1000, 33}, {1000, 34}, {1000, 35}, {1000, 36}, {1000, 37}, {1000, 38}, {1000, 39}, {1000, 40}, {1000, 41}, {1000, 42}, {1000, 43}, {1000, 44}, {1000, 45}, {1000, 46}, {1000, 47}, {1000, 48}, {1000, 49}, {1000, 50}, {1000, 51}, {1000, 52}, {1000, 53}, {1000, 54}, {1000, 55}, {1000, 56}, {1000, 57}, {1000, 58}, {1000, 59}, {1000, 60}, {1000, 61}, {1000, 62}, {1000, 63}, {1000, 64}, {1000, 65}, {1000, 66}, {1000, 67}, {1000, 68}, {1000, 69}, {1000, 70}, {1000, 71}, {1000, 72}, {1000, 73}, {1000, 74}, {1000, 75}, {1000, 76}, {1000, 77}, {1000, 78}, {1000, 79}, {1000, 80}, {1000, 81}, {1000, 82}, {1000, 83}, {1000, 84}, {1000, 85}, {1000, 86}, {1000, 87}, {1000, 88}, {1000, 89}, {1000, 90}, {1000, 91}, {1000, 92}, {1000, 93}, {1000, 94}, {1000, 95}, {1000, 96}, {1000, 97}, {1000, 98}, {1000, 99}, {1000, 100}, {1000, 101}, {1000, 102}, {1000, 103}, {1000, 104}, {1000, 105}, {1000, 106}, {1000, 107}, {1000, 108}, {1000, 109}, {1000, 110}, {1000, 111}, {1000, 112}, {1000, 113}, {1000, 114}, {1000, 115}, {1000, 116}, {1000, 117}, {1000, 118}, {1000, 119}, {1000, 120}, {1000, 121}, {1000, 122}, {1000, 123}, {1000, 124}, {1000, 125}, {1000, 126}, {1000, 127}, {1000, 128}, {1000, 129}, {1000, 130}, {2000, 1}, {2000, 2}, {2000, 3}, {2000, 4}, {2000, 5}, {2000, 6}, {2000, 7}, {2000, 8}, {2000, 9}, {2000, 10}, {2000, 11}, {2000, 12}, {2000, 13}, {2000, 14}, {2000, 15}, {2000, 16}, {2000, 17}, {2000, 18}, {2000, 19}, {2000, 20}, {2000, 21}, {2000, 22}, {2000, 23}, {2000, 24}, {2000, 25}, {2000, 26}, {2000, 27}, {2000, 28}, {2000, 29}, {2000, 30}, {2000, 31}, {2000, 32}, {2000, 33}, {2000, 34}, {2000, 35}, {2000, 36}, {2000, 37}, {2000, 38}, {2000, 39}, {2000, 40}, {2000, 41}, {2000, 42}, {2000, 43}, {2000, 44}, {2000, 45}, {2000, 46}, {2000, 47}, {2000, 48}, {2000, 49}, {2000, 50}, {2000, 51}, {2000, 52}, {2000, 53}, {2000, 54}, {2000, 55}, {2000, 56}, {2000, 57}, {2000, 58}, {2000, 59}, {2000, 60}, {2000, 61}, {2000, 62}, {2000, 63}, {2000, 64}, {2000, 65}, {2000, 66}, {2000, 67}, {2000, 68}, {2000, 69}, {2000, 70}, {2000, 71}, {2000, 72}, {2000, 73}, {2000, 74}, {2000, 75}, {2000, 76}, {2000, 77}, {2000, 78}, {2000, 79}, {2000, 80}, {2000, 81}, {2000, 82}, {2000, 83}, {2000, 84}, {2000, 85}, {2000, 86}, {2000, 87}, {2000, 88}, {2000, 89}, {2000, 90}, {2000, 91}, {2000, 92}, {2000, 93}, {2000, 94}, {2000, 95}, {2000, 96}, {2000, 97}, {2000, 98}, {2000, 99}, {2000, 100}, {2000, 101}, {2000, 102}, {2000, 103}, {2000, 104}, {2000, 105}, {2000, 106}, {2000, 107}, {2000, 108}, {2000, 109}, {2000, 110}, {2000, 111}, {2000, 112}, {2000, 113}, {2000, 114}, {2000, 115}, {2000, 116}, {2000, 117}, {2000, 118}, {2000, 119}, {2000, 120}, {2000, 121}, {2000, 122}, {2000, 123}, {2000, 124}, {2000, 125}, {2000, 126}, {2000, 127}, {2000, 128}, {2000, 129}, {2000, 130}, {3000, 1}, {3000, 2}, {3000, 3}, {3000, 4}, {3000, 5}, {3000, 6}, {3000, 7}, {3000, 8}, {3000, 9}, {3000, 10}, {3000, 11}, {3000, 12}, {3000, 13}, {3000, 14}, {3000, 15}, {3000, 16}, {3000, 17}, {3000, 18}, {3000, 19}, {3000, 20}, {3000, 21}, {3000, 22}, {3000, 23}, {3000, 24}, {3000, 25}, {3000, 26}, {3000, 27}, {3000, 28}, {3000, 29}, {3000, 30}, {3000, 31}, {3000, 32}, {3000, 33}, {3000, 34}, {3000, 35}, {3000, 36}, {3000, 37}, {3000, 38}, {3000, 39}, {3000, 40}, {3000, 41}, {3000, 42}, {3000, 43}, {3000, 44}, {3000, 45}, {3000, 46}, {3000, 47}, {3000, 48}, {3000, 49}, {3000, 50}, {3000, 51}, {3000, 52}, {3000, 53}, {3000, 54}, {3000, 55}, {3000, 56}, {3000, 57}, {3000, 58}, {3000, 59}, {3000, 60}, {3000, 61}, {3000, 62}, {3000, 63}, {3000, 64}, {3000, 65}, {3000, 66}, {3000, 67}, {3000, 68}, {3000, 69}, {3000, 70}, {3000, 71}, {3000, 72}, {3000, 73}, {3000, 74}, {3000, 75}, {3000, 76}, {3000, 77}, {3000, 78}, {3000, 79}, {3000, 80}, {3000, 81}, {3000, 82}, {3000, 83}, {3000, 84}, {3000, 85}, {3000, 86}, {3000, 87}, {3000, 88}, {3000, 89}, {3000, 90}, {3000, 91}, {3000, 92}, {3000, 93}, {3000, 94}, {3000, 95}, {3000, 96}, {3000, 97}, {3000, 98}, {3000, 99}, {3000, 100}, {3000, 101}, {3000, 102}, {3000, 103}, {3000, 104}, {3000, 105}, {3000, 106}, {3000, 107}, {3000, 108}, {3000, 109}, {3000, 110}, {3000, 111}, {3000, 112}, {3000, 113}, {3000, 114}, {3000, 115}, {3000, 116}, {3000, 117}, {3000, 118}, {3000, 119}, {3000, 120}, {3000, 121}, {3000, 122}, {3000, 123}, {3000, 124}, {3000, 125}, {3000, 126}, {3000, 127}, {3000, 128}, {3000, 129}, {3000, 130}].

get({1000, 1}) ->
	#player_attr_conf{
		career = 1000,
		lv = 1,
		attr_base = #attr_base{
			hp = 25,
			mp = 13,
			min_ac = 1,
			max_ac = 2,
			min_mac = 0,
			max_mac = 0,
			min_sc = 0,
			max_sc = 0,
			min_def = 0,
			max_def = 1,
			min_res = 0,
			max_res = 1,
			crit = 0,
			crit_att = 5,
			hit = 15,
			dodge = 15
		}
	};

get({1000, 2}) ->
	#player_attr_conf{
		career = 1000,
		lv = 2,
		attr_base = #attr_base{
			hp = 70,
			mp = 37,
			min_ac = 2,
			max_ac = 5,
			min_mac = 0,
			max_mac = 0,
			min_sc = 0,
			max_sc = 0,
			min_def = 0,
			max_def = 3,
			min_res = 0,
			max_res = 3,
			crit = 0,
			crit_att = 5,
			hit = 15,
			dodge = 15
		}
	};

get({1000, 3}) ->
	#player_attr_conf{
		career = 1000,
		lv = 3,
		attr_base = #attr_base{
			hp = 115,
			mp = 61,
			min_ac = 4,
			max_ac = 8,
			min_mac = 0,
			max_mac = 0,
			min_sc = 0,
			max_sc = 0,
			min_def = 1,
			max_def = 4,
			min_res = 1,
			max_res = 4,
			crit = 0,
			crit_att = 5,
			hit = 15,
			dodge = 15
		}
	};

get({1000, 4}) ->
	#player_attr_conf{
		career = 1000,
		lv = 4,
		attr_base = #attr_base{
			hp = 160,
			mp = 85,
			min_ac = 6,
			max_ac = 12,
			min_mac = 0,
			max_mac = 0,
			min_sc = 0,
			max_sc = 0,
			min_def = 2,
			max_def = 6,
			min_res = 2,
			max_res = 6,
			crit = 0,
			crit_att = 5,
			hit = 15,
			dodge = 15
		}
	};

get({1000, 5}) ->
	#player_attr_conf{
		career = 1000,
		lv = 5,
		attr_base = #attr_base{
			hp = 205,
			mp = 109,
			min_ac = 7,
			max_ac = 15,
			min_mac = 0,
			max_mac = 0,
			min_sc = 0,
			max_sc = 0,
			min_def = 3,
			max_def = 7,
			min_res = 3,
			max_res = 7,
			crit = 0,
			crit_att = 5,
			hit = 15,
			dodge = 15
		}
	};

get({1000, 6}) ->
	#player_attr_conf{
		career = 1000,
		lv = 6,
		attr_base = #attr_base{
			hp = 250,
			mp = 133,
			min_ac = 9,
			max_ac = 18,
			min_mac = 0,
			max_mac = 0,
			min_sc = 0,
			max_sc = 0,
			min_def = 3,
			max_def = 9,
			min_res = 3,
			max_res = 9,
			crit = 0,
			crit_att = 5,
			hit = 15,
			dodge = 15
		}
	};

get({1000, 7}) ->
	#player_attr_conf{
		career = 1000,
		lv = 7,
		attr_base = #attr_base{
			hp = 295,
			mp = 157,
			min_ac = 11,
			max_ac = 22,
			min_mac = 0,
			max_mac = 0,
			min_sc = 0,
			max_sc = 0,
			min_def = 4,
			max_def = 10,
			min_res = 4,
			max_res = 10,
			crit = 0,
			crit_att = 5,
			hit = 15,
			dodge = 15
		}
	};

get({1000, 8}) ->
	#player_attr_conf{
		career = 1000,
		lv = 8,
		attr_base = #attr_base{
			hp = 340,
			mp = 181,
			min_ac = 12,
			max_ac = 25,
			min_mac = 0,
			max_mac = 0,
			min_sc = 0,
			max_sc = 0,
			min_def = 5,
			max_def = 12,
			min_res = 5,
			max_res = 12,
			crit = 0,
			crit_att = 5,
			hit = 15,
			dodge = 15
		}
	};

get({1000, 9}) ->
	#player_attr_conf{
		career = 1000,
		lv = 9,
		attr_base = #attr_base{
			hp = 385,
			mp = 205,
			min_ac = 14,
			max_ac = 28,
			min_mac = 0,
			max_mac = 0,
			min_sc = 0,
			max_sc = 0,
			min_def = 6,
			max_def = 13,
			min_res = 6,
			max_res = 13,
			crit = 0,
			crit_att = 5,
			hit = 15,
			dodge = 15
		}
	};

get({1000, 10}) ->
	#player_attr_conf{
		career = 1000,
		lv = 10,
		attr_base = #attr_base{
			hp = 430,
			mp = 229,
			min_ac = 15,
			max_ac = 31,
			min_mac = 0,
			max_mac = 0,
			min_sc = 0,
			max_sc = 0,
			min_def = 6,
			max_def = 15,
			min_res = 6,
			max_res = 15,
			crit = 0,
			crit_att = 5,
			hit = 15,
			dodge = 15
		}
	};

get({1000, 11}) ->
	#player_attr_conf{
		career = 1000,
		lv = 11,
		attr_base = #attr_base{
			hp = 475,
			mp = 253,
			min_ac = 17,
			max_ac = 35,
			min_mac = 0,
			max_mac = 0,
			min_sc = 0,
			max_sc = 0,
			min_def = 7,
			max_def = 16,
			min_res = 7,
			max_res = 16,
			crit = 0,
			crit_att = 10,
			hit = 15,
			dodge = 15
		}
	};

get({1000, 12}) ->
	#player_attr_conf{
		career = 1000,
		lv = 12,
		attr_base = #attr_base{
			hp = 520,
			mp = 277,
			min_ac = 19,
			max_ac = 38,
			min_mac = 0,
			max_mac = 0,
			min_sc = 0,
			max_sc = 0,
			min_def = 8,
			max_def = 18,
			min_res = 8,
			max_res = 18,
			crit = 0,
			crit_att = 10,
			hit = 15,
			dodge = 15
		}
	};

get({1000, 13}) ->
	#player_attr_conf{
		career = 1000,
		lv = 13,
		attr_base = #attr_base{
			hp = 565,
			mp = 301,
			min_ac = 20,
			max_ac = 41,
			min_mac = 0,
			max_mac = 0,
			min_sc = 0,
			max_sc = 0,
			min_def = 9,
			max_def = 19,
			min_res = 9,
			max_res = 19,
			crit = 0,
			crit_att = 10,
			hit = 15,
			dodge = 15
		}
	};

get({1000, 14}) ->
	#player_attr_conf{
		career = 1000,
		lv = 14,
		attr_base = #attr_base{
			hp = 610,
			mp = 325,
			min_ac = 22,
			max_ac = 45,
			min_mac = 0,
			max_mac = 0,
			min_sc = 0,
			max_sc = 0,
			min_def = 9,
			max_def = 21,
			min_res = 9,
			max_res = 21,
			crit = 0,
			crit_att = 10,
			hit = 15,
			dodge = 15
		}
	};

get({1000, 15}) ->
	#player_attr_conf{
		career = 1000,
		lv = 15,
		attr_base = #attr_base{
			hp = 655,
			mp = 349,
			min_ac = 24,
			max_ac = 48,
			min_mac = 0,
			max_mac = 0,
			min_sc = 0,
			max_sc = 0,
			min_def = 10,
			max_def = 22,
			min_res = 10,
			max_res = 22,
			crit = 0,
			crit_att = 10,
			hit = 15,
			dodge = 15
		}
	};

get({1000, 16}) ->
	#player_attr_conf{
		career = 1000,
		lv = 16,
		attr_base = #attr_base{
			hp = 700,
			mp = 373,
			min_ac = 25,
			max_ac = 51,
			min_mac = 0,
			max_mac = 0,
			min_sc = 0,
			max_sc = 0,
			min_def = 11,
			max_def = 24,
			min_res = 11,
			max_res = 24,
			crit = 0,
			crit_att = 10,
			hit = 15,
			dodge = 15
		}
	};

get({1000, 17}) ->
	#player_attr_conf{
		career = 1000,
		lv = 17,
		attr_base = #attr_base{
			hp = 745,
			mp = 397,
			min_ac = 27,
			max_ac = 55,
			min_mac = 0,
			max_mac = 0,
			min_sc = 0,
			max_sc = 0,
			min_def = 12,
			max_def = 25,
			min_res = 12,
			max_res = 25,
			crit = 0,
			crit_att = 10,
			hit = 15,
			dodge = 15
		}
	};

get({1000, 18}) ->
	#player_attr_conf{
		career = 1000,
		lv = 18,
		attr_base = #attr_base{
			hp = 790,
			mp = 421,
			min_ac = 29,
			max_ac = 58,
			min_mac = 0,
			max_mac = 0,
			min_sc = 0,
			max_sc = 0,
			min_def = 12,
			max_def = 27,
			min_res = 12,
			max_res = 27,
			crit = 0,
			crit_att = 10,
			hit = 15,
			dodge = 15
		}
	};

get({1000, 19}) ->
	#player_attr_conf{
		career = 1000,
		lv = 19,
		attr_base = #attr_base{
			hp = 835,
			mp = 445,
			min_ac = 30,
			max_ac = 61,
			min_mac = 0,
			max_mac = 0,
			min_sc = 0,
			max_sc = 0,
			min_def = 13,
			max_def = 28,
			min_res = 13,
			max_res = 28,
			crit = 0,
			crit_att = 10,
			hit = 15,
			dodge = 15
		}
	};

get({1000, 20}) ->
	#player_attr_conf{
		career = 1000,
		lv = 20,
		attr_base = #attr_base{
			hp = 903,
			mp = 481,
			min_ac = 33,
			max_ac = 66,
			min_mac = 0,
			max_mac = 0,
			min_sc = 0,
			max_sc = 0,
			min_def = 14,
			max_def = 30,
			min_res = 14,
			max_res = 30,
			crit = 0,
			crit_att = 10,
			hit = 15,
			dodge = 15
		}
	};

get({1000, 21}) ->
	#player_attr_conf{
		career = 1000,
		lv = 21,
		attr_base = #attr_base{
			hp = 970,
			mp = 517,
			min_ac = 35,
			max_ac = 71,
			min_mac = 0,
			max_mac = 0,
			min_sc = 0,
			max_sc = 0,
			min_def = 15,
			max_def = 33,
			min_res = 15,
			max_res = 33,
			crit = 0,
			crit_att = 15,
			hit = 15,
			dodge = 15
		}
	};

get({1000, 22}) ->
	#player_attr_conf{
		career = 1000,
		lv = 22,
		attr_base = #attr_base{
			hp = 1038,
			mp = 553,
			min_ac = 38,
			max_ac = 76,
			min_mac = 0,
			max_mac = 0,
			min_sc = 0,
			max_sc = 0,
			min_def = 16,
			max_def = 35,
			min_res = 16,
			max_res = 35,
			crit = 0,
			crit_att = 15,
			hit = 15,
			dodge = 15
		}
	};

get({1000, 23}) ->
	#player_attr_conf{
		career = 1000,
		lv = 23,
		attr_base = #attr_base{
			hp = 1105,
			mp = 589,
			min_ac = 40,
			max_ac = 81,
			min_mac = 0,
			max_mac = 0,
			min_sc = 0,
			max_sc = 0,
			min_def = 18,
			max_def = 37,
			min_res = 18,
			max_res = 37,
			crit = 0,
			crit_att = 15,
			hit = 15,
			dodge = 15
		}
	};

get({1000, 24}) ->
	#player_attr_conf{
		career = 1000,
		lv = 24,
		attr_base = #attr_base{
			hp = 1173,
			mp = 625,
			min_ac = 43,
			max_ac = 86,
			min_mac = 0,
			max_mac = 0,
			min_sc = 0,
			max_sc = 0,
			min_def = 19,
			max_def = 39,
			min_res = 19,
			max_res = 39,
			crit = 0,
			crit_att = 15,
			hit = 15,
			dodge = 15
		}
	};

get({1000, 25}) ->
	#player_attr_conf{
		career = 1000,
		lv = 25,
		attr_base = #attr_base{
			hp = 1240,
			mp = 661,
			min_ac = 45,
			max_ac = 91,
			min_mac = 0,
			max_mac = 0,
			min_sc = 0,
			max_sc = 0,
			min_def = 20,
			max_def = 42,
			min_res = 20,
			max_res = 42,
			crit = 0,
			crit_att = 15,
			hit = 15,
			dodge = 15
		}
	};

get({1000, 26}) ->
	#player_attr_conf{
		career = 1000,
		lv = 26,
		attr_base = #attr_base{
			hp = 1308,
			mp = 697,
			min_ac = 48,
			max_ac = 96,
			min_mac = 0,
			max_mac = 0,
			min_sc = 0,
			max_sc = 0,
			min_def = 21,
			max_def = 44,
			min_res = 21,
			max_res = 44,
			crit = 0,
			crit_att = 15,
			hit = 15,
			dodge = 15
		}
	};

get({1000, 27}) ->
	#player_attr_conf{
		career = 1000,
		lv = 27,
		attr_base = #attr_base{
			hp = 1375,
			mp = 733,
			min_ac = 50,
			max_ac = 101,
			min_mac = 0,
			max_mac = 0,
			min_sc = 0,
			max_sc = 0,
			min_def = 22,
			max_def = 46,
			min_res = 22,
			max_res = 46,
			crit = 0,
			crit_att = 15,
			hit = 15,
			dodge = 15
		}
	};

get({1000, 28}) ->
	#player_attr_conf{
		career = 1000,
		lv = 28,
		attr_base = #attr_base{
			hp = 1443,
			mp = 769,
			min_ac = 53,
			max_ac = 106,
			min_mac = 0,
			max_mac = 0,
			min_sc = 0,
			max_sc = 0,
			min_def = 23,
			max_def = 48,
			min_res = 23,
			max_res = 48,
			crit = 0,
			crit_att = 15,
			hit = 15,
			dodge = 15
		}
	};

get({1000, 29}) ->
	#player_attr_conf{
		career = 1000,
		lv = 29,
		attr_base = #attr_base{
			hp = 1510,
			mp = 805,
			min_ac = 55,
			max_ac = 111,
			min_mac = 0,
			max_mac = 0,
			min_sc = 0,
			max_sc = 0,
			min_def = 24,
			max_def = 51,
			min_res = 24,
			max_res = 51,
			crit = 0,
			crit_att = 15,
			hit = 15,
			dodge = 15
		}
	};

get({1000, 30}) ->
	#player_attr_conf{
		career = 1000,
		lv = 30,
		attr_base = #attr_base{
			hp = 1614,
			mp = 860,
			min_ac = 59,
			max_ac = 118,
			min_mac = 0,
			max_mac = 0,
			min_sc = 0,
			max_sc = 0,
			min_def = 26,
			max_def = 54,
			min_res = 26,
			max_res = 54,
			crit = 0,
			crit_att = 15,
			hit = 15,
			dodge = 15
		}
	};

get({1000, 31}) ->
	#player_attr_conf{
		career = 1000,
		lv = 31,
		attr_base = #attr_base{
			hp = 1717,
			mp = 916,
			min_ac = 63,
			max_ac = 126,
			min_mac = 0,
			max_mac = 0,
			min_sc = 0,
			max_sc = 0,
			min_def = 28,
			max_def = 57,
			min_res = 28,
			max_res = 57,
			crit = 0,
			crit_att = 20,
			hit = 15,
			dodge = 15
		}
	};

get({1000, 32}) ->
	#player_attr_conf{
		career = 1000,
		lv = 32,
		attr_base = #attr_base{
			hp = 1821,
			mp = 971,
			min_ac = 66,
			max_ac = 133,
			min_mac = 0,
			max_mac = 0,
			min_sc = 0,
			max_sc = 0,
			min_def = 29,
			max_def = 61,
			min_res = 29,
			max_res = 61,
			crit = 0,
			crit_att = 20,
			hit = 15,
			dodge = 15
		}
	};

get({1000, 33}) ->
	#player_attr_conf{
		career = 1000,
		lv = 33,
		attr_base = #attr_base{
			hp = 1924,
			mp = 1026,
			min_ac = 70,
			max_ac = 141,
			min_mac = 0,
			max_mac = 0,
			min_sc = 0,
			max_sc = 0,
			min_def = 31,
			max_def = 64,
			min_res = 31,
			max_res = 64,
			crit = 0,
			crit_att = 20,
			hit = 15,
			dodge = 15
		}
	};

get({1000, 34}) ->
	#player_attr_conf{
		career = 1000,
		lv = 34,
		attr_base = #attr_base{
			hp = 2028,
			mp = 1081,
			min_ac = 74,
			max_ac = 149,
			min_mac = 0,
			max_mac = 0,
			min_sc = 0,
			max_sc = 0,
			min_def = 33,
			max_def = 68,
			min_res = 33,
			max_res = 68,
			crit = 0,
			crit_att = 20,
			hit = 15,
			dodge = 15
		}
	};

get({1000, 35}) ->
	#player_attr_conf{
		career = 1000,
		lv = 35,
		attr_base = #attr_base{
			hp = 2131,
			mp = 1136,
			min_ac = 78,
			max_ac = 156,
			min_mac = 0,
			max_mac = 0,
			min_sc = 0,
			max_sc = 0,
			min_def = 35,
			max_def = 71,
			min_res = 35,
			max_res = 71,
			crit = 0,
			crit_att = 20,
			hit = 15,
			dodge = 15
		}
	};

get({1000, 36}) ->
	#player_attr_conf{
		career = 1000,
		lv = 36,
		attr_base = #attr_base{
			hp = 2235,
			mp = 1192,
			min_ac = 82,
			max_ac = 164,
			min_mac = 0,
			max_mac = 0,
			min_sc = 0,
			max_sc = 0,
			min_def = 36,
			max_def = 75,
			min_res = 36,
			max_res = 75,
			crit = 0,
			crit_att = 20,
			hit = 15,
			dodge = 15
		}
	};

get({1000, 37}) ->
	#player_attr_conf{
		career = 1000,
		lv = 37,
		attr_base = #attr_base{
			hp = 2338,
			mp = 1247,
			min_ac = 85,
			max_ac = 171,
			min_mac = 0,
			max_mac = 0,
			min_sc = 0,
			max_sc = 0,
			min_def = 38,
			max_def = 78,
			min_res = 38,
			max_res = 78,
			crit = 0,
			crit_att = 20,
			hit = 15,
			dodge = 15
		}
	};

get({1000, 38}) ->
	#player_attr_conf{
		career = 1000,
		lv = 38,
		attr_base = #attr_base{
			hp = 2442,
			mp = 1302,
			min_ac = 89,
			max_ac = 179,
			min_mac = 0,
			max_mac = 0,
			min_sc = 0,
			max_sc = 0,
			min_def = 40,
			max_def = 82,
			min_res = 40,
			max_res = 82,
			crit = 0,
			crit_att = 20,
			hit = 15,
			dodge = 15
		}
	};

get({1000, 39}) ->
	#player_attr_conf{
		career = 1000,
		lv = 39,
		attr_base = #attr_base{
			hp = 2545,
			mp = 1357,
			min_ac = 93,
			max_ac = 187,
			min_mac = 0,
			max_mac = 0,
			min_sc = 0,
			max_sc = 0,
			min_def = 42,
			max_def = 85,
			min_res = 42,
			max_res = 85,
			crit = 0,
			crit_att = 20,
			hit = 15,
			dodge = 15
		}
	};

get({1000, 40}) ->
	#player_attr_conf{
		career = 1000,
		lv = 40,
		attr_base = #attr_base{
			hp = 2680,
			mp = 1429,
			min_ac = 98,
			max_ac = 196,
			min_mac = 0,
			max_mac = 0,
			min_sc = 0,
			max_sc = 0,
			min_def = 44,
			max_def = 90,
			min_res = 44,
			max_res = 90,
			crit = 0,
			crit_att = 20,
			hit = 15,
			dodge = 15
		}
	};

get({1000, 41}) ->
	#player_attr_conf{
		career = 1000,
		lv = 41,
		attr_base = #attr_base{
			hp = 2815,
			mp = 1501,
			min_ac = 103,
			max_ac = 206,
			min_mac = 0,
			max_mac = 0,
			min_sc = 0,
			max_sc = 0,
			min_def = 46,
			max_def = 94,
			min_res = 46,
			max_res = 94,
			crit = 0,
			crit_att = 25,
			hit = 15,
			dodge = 15
		}
	};

get({1000, 42}) ->
	#player_attr_conf{
		career = 1000,
		lv = 42,
		attr_base = #attr_base{
			hp = 2950,
			mp = 1573,
			min_ac = 108,
			max_ac = 216,
			min_mac = 0,
			max_mac = 0,
			min_sc = 0,
			max_sc = 0,
			min_def = 48,
			max_def = 99,
			min_res = 48,
			max_res = 99,
			crit = 0,
			crit_att = 25,
			hit = 15,
			dodge = 15
		}
	};

get({1000, 43}) ->
	#player_attr_conf{
		career = 1000,
		lv = 43,
		attr_base = #attr_base{
			hp = 3085,
			mp = 1645,
			min_ac = 113,
			max_ac = 226,
			min_mac = 0,
			max_mac = 0,
			min_sc = 0,
			max_sc = 0,
			min_def = 51,
			max_def = 103,
			min_res = 51,
			max_res = 103,
			crit = 0,
			crit_att = 25,
			hit = 15,
			dodge = 15
		}
	};

get({1000, 44}) ->
	#player_attr_conf{
		career = 1000,
		lv = 44,
		attr_base = #attr_base{
			hp = 3220,
			mp = 1717,
			min_ac = 118,
			max_ac = 236,
			min_mac = 0,
			max_mac = 0,
			min_sc = 0,
			max_sc = 0,
			min_def = 53,
			max_def = 108,
			min_res = 53,
			max_res = 108,
			crit = 0,
			crit_att = 25,
			hit = 15,
			dodge = 15
		}
	};

get({1000, 45}) ->
	#player_attr_conf{
		career = 1000,
		lv = 45,
		attr_base = #attr_base{
			hp = 3355,
			mp = 1789,
			min_ac = 123,
			max_ac = 246,
			min_mac = 0,
			max_mac = 0,
			min_sc = 0,
			max_sc = 0,
			min_def = 55,
			max_def = 112,
			min_res = 55,
			max_res = 112,
			crit = 0,
			crit_att = 25,
			hit = 15,
			dodge = 15
		}
	};

get({1000, 46}) ->
	#player_attr_conf{
		career = 1000,
		lv = 46,
		attr_base = #attr_base{
			hp = 3490,
			mp = 1861,
			min_ac = 128,
			max_ac = 256,
			min_mac = 0,
			max_mac = 0,
			min_sc = 0,
			max_sc = 0,
			min_def = 57,
			max_def = 117,
			min_res = 57,
			max_res = 117,
			crit = 0,
			crit_att = 25,
			hit = 15,
			dodge = 15
		}
	};

get({1000, 47}) ->
	#player_attr_conf{
		career = 1000,
		lv = 47,
		attr_base = #attr_base{
			hp = 3625,
			mp = 1933,
			min_ac = 133,
			max_ac = 266,
			min_mac = 0,
			max_mac = 0,
			min_sc = 0,
			max_sc = 0,
			min_def = 60,
			max_def = 121,
			min_res = 60,
			max_res = 121,
			crit = 0,
			crit_att = 25,
			hit = 15,
			dodge = 15
		}
	};

get({1000, 48}) ->
	#player_attr_conf{
		career = 1000,
		lv = 48,
		attr_base = #attr_base{
			hp = 3760,
			mp = 2005,
			min_ac = 138,
			max_ac = 276,
			min_mac = 0,
			max_mac = 0,
			min_sc = 0,
			max_sc = 0,
			min_def = 62,
			max_def = 126,
			min_res = 62,
			max_res = 126,
			crit = 0,
			crit_att = 25,
			hit = 15,
			dodge = 15
		}
	};

get({1000, 49}) ->
	#player_attr_conf{
		career = 1000,
		lv = 49,
		attr_base = #attr_base{
			hp = 3895,
			mp = 2077,
			min_ac = 143,
			max_ac = 286,
			min_mac = 0,
			max_mac = 0,
			min_sc = 0,
			max_sc = 0,
			min_def = 64,
			max_def = 130,
			min_res = 64,
			max_res = 130,
			crit = 0,
			crit_att = 25,
			hit = 15,
			dodge = 15
		}
	};

get({1000, 50}) ->
	#player_attr_conf{
		career = 1000,
		lv = 50,
		attr_base = #attr_base{
			hp = 4075,
			mp = 2173,
			min_ac = 149,
			max_ac = 299,
			min_mac = 0,
			max_mac = 0,
			min_sc = 0,
			max_sc = 0,
			min_def = 67,
			max_def = 136,
			min_res = 67,
			max_res = 136,
			crit = 0,
			crit_att = 25,
			hit = 15,
			dodge = 15
		}
	};

get({1000, 51}) ->
	#player_attr_conf{
		career = 1000,
		lv = 51,
		attr_base = #attr_base{
			hp = 4255,
			mp = 2269,
			min_ac = 156,
			max_ac = 312,
			min_mac = 0,
			max_mac = 0,
			min_sc = 0,
			max_sc = 0,
			min_def = 70,
			max_def = 142,
			min_res = 70,
			max_res = 142,
			crit = 0,
			crit_att = 30,
			hit = 15,
			dodge = 15
		}
	};

get({1000, 52}) ->
	#player_attr_conf{
		career = 1000,
		lv = 52,
		attr_base = #attr_base{
			hp = 4435,
			mp = 2365,
			min_ac = 162,
			max_ac = 325,
			min_mac = 0,
			max_mac = 0,
			min_sc = 0,
			max_sc = 0,
			min_def = 73,
			max_def = 148,
			min_res = 73,
			max_res = 148,
			crit = 0,
			crit_att = 30,
			hit = 15,
			dodge = 15
		}
	};

get({1000, 53}) ->
	#player_attr_conf{
		career = 1000,
		lv = 53,
		attr_base = #attr_base{
			hp = 4615,
			mp = 2461,
			min_ac = 169,
			max_ac = 338,
			min_mac = 0,
			max_mac = 0,
			min_sc = 0,
			max_sc = 0,
			min_def = 76,
			max_def = 154,
			min_res = 76,
			max_res = 154,
			crit = 0,
			crit_att = 30,
			hit = 15,
			dodge = 15
		}
	};

get({1000, 54}) ->
	#player_attr_conf{
		career = 1000,
		lv = 54,
		attr_base = #attr_base{
			hp = 4795,
			mp = 2557,
			min_ac = 176,
			max_ac = 352,
			min_mac = 0,
			max_mac = 0,
			min_sc = 0,
			max_sc = 0,
			min_def = 79,
			max_def = 160,
			min_res = 79,
			max_res = 160,
			crit = 0,
			crit_att = 30,
			hit = 15,
			dodge = 15
		}
	};

get({1000, 55}) ->
	#player_attr_conf{
		career = 1000,
		lv = 55,
		attr_base = #attr_base{
			hp = 4975,
			mp = 2653,
			min_ac = 182,
			max_ac = 365,
			min_mac = 0,
			max_mac = 0,
			min_sc = 0,
			max_sc = 0,
			min_def = 82,
			max_def = 166,
			min_res = 82,
			max_res = 166,
			crit = 0,
			crit_att = 30,
			hit = 15,
			dodge = 15
		}
	};

get({1000, 56}) ->
	#player_attr_conf{
		career = 1000,
		lv = 56,
		attr_base = #attr_base{
			hp = 5155,
			mp = 2749,
			min_ac = 189,
			max_ac = 378,
			min_mac = 0,
			max_mac = 0,
			min_sc = 0,
			max_sc = 0,
			min_def = 85,
			max_def = 172,
			min_res = 85,
			max_res = 172,
			crit = 0,
			crit_att = 30,
			hit = 15,
			dodge = 15
		}
	};

get({1000, 57}) ->
	#player_attr_conf{
		career = 1000,
		lv = 57,
		attr_base = #attr_base{
			hp = 5335,
			mp = 2845,
			min_ac = 195,
			max_ac = 391,
			min_mac = 0,
			max_mac = 0,
			min_sc = 0,
			max_sc = 0,
			min_def = 88,
			max_def = 178,
			min_res = 88,
			max_res = 178,
			crit = 0,
			crit_att = 30,
			hit = 15,
			dodge = 15
		}
	};

get({1000, 58}) ->
	#player_attr_conf{
		career = 1000,
		lv = 58,
		attr_base = #attr_base{
			hp = 5515,
			mp = 2941,
			min_ac = 202,
			max_ac = 404,
			min_mac = 0,
			max_mac = 0,
			min_sc = 0,
			max_sc = 0,
			min_def = 91,
			max_def = 184,
			min_res = 91,
			max_res = 184,
			crit = 0,
			crit_att = 30,
			hit = 15,
			dodge = 15
		}
	};

get({1000, 59}) ->
	#player_attr_conf{
		career = 1000,
		lv = 59,
		attr_base = #attr_base{
			hp = 5695,
			mp = 3037,
			min_ac = 209,
			max_ac = 418,
			min_mac = 0,
			max_mac = 0,
			min_sc = 0,
			max_sc = 0,
			min_def = 94,
			max_def = 190,
			min_res = 94,
			max_res = 190,
			crit = 0,
			crit_att = 30,
			hit = 15,
			dodge = 15
		}
	};

get({1000, 60}) ->
	#player_attr_conf{
		career = 1000,
		lv = 60,
		attr_base = #attr_base{
			hp = 5898,
			mp = 3145,
			min_ac = 216,
			max_ac = 432,
			min_mac = 0,
			max_mac = 0,
			min_sc = 0,
			max_sc = 0,
			min_def = 97,
			max_def = 197,
			min_res = 97,
			max_res = 197,
			crit = 0,
			crit_att = 30,
			hit = 15,
			dodge = 15
		}
	};

get({1000, 61}) ->
	#player_attr_conf{
		career = 1000,
		lv = 61,
		attr_base = #attr_base{
			hp = 6100,
			mp = 3253,
			min_ac = 223,
			max_ac = 447,
			min_mac = 0,
			max_mac = 0,
			min_sc = 0,
			max_sc = 0,
			min_def = 101,
			max_def = 204,
			min_res = 101,
			max_res = 204,
			crit = 0,
			crit_att = 35,
			hit = 15,
			dodge = 15
		}
	};

get({1000, 62}) ->
	#player_attr_conf{
		career = 1000,
		lv = 62,
		attr_base = #attr_base{
			hp = 6303,
			mp = 3361,
			min_ac = 231,
			max_ac = 462,
			min_mac = 0,
			max_mac = 0,
			min_sc = 0,
			max_sc = 0,
			min_def = 104,
			max_def = 210,
			min_res = 104,
			max_res = 210,
			crit = 0,
			crit_att = 35,
			hit = 15,
			dodge = 15
		}
	};

get({1000, 63}) ->
	#player_attr_conf{
		career = 1000,
		lv = 63,
		attr_base = #attr_base{
			hp = 6505,
			mp = 3469,
			min_ac = 238,
			max_ac = 477,
			min_mac = 0,
			max_mac = 0,
			min_sc = 0,
			max_sc = 0,
			min_def = 108,
			max_def = 217,
			min_res = 108,
			max_res = 217,
			crit = 0,
			crit_att = 35,
			hit = 15,
			dodge = 15
		}
	};

get({1000, 64}) ->
	#player_attr_conf{
		career = 1000,
		lv = 64,
		attr_base = #attr_base{
			hp = 6708,
			mp = 3577,
			min_ac = 246,
			max_ac = 492,
			min_mac = 0,
			max_mac = 0,
			min_sc = 0,
			max_sc = 0,
			min_def = 111,
			max_def = 224,
			min_res = 111,
			max_res = 224,
			crit = 0,
			crit_att = 35,
			hit = 15,
			dodge = 15
		}
	};

get({1000, 65}) ->
	#player_attr_conf{
		career = 1000,
		lv = 65,
		attr_base = #attr_base{
			hp = 6910,
			mp = 3685,
			min_ac = 253,
			max_ac = 507,
			min_mac = 0,
			max_mac = 0,
			min_sc = 0,
			max_sc = 0,
			min_def = 114,
			max_def = 231,
			min_res = 114,
			max_res = 231,
			crit = 0,
			crit_att = 35,
			hit = 15,
			dodge = 15
		}
	};

get({1000, 66}) ->
	#player_attr_conf{
		career = 1000,
		lv = 66,
		attr_base = #attr_base{
			hp = 7113,
			mp = 3793,
			min_ac = 260,
			max_ac = 521,
			min_mac = 0,
			max_mac = 0,
			min_sc = 0,
			max_sc = 0,
			min_def = 118,
			max_def = 237,
			min_res = 118,
			max_res = 237,
			crit = 0,
			crit_att = 35,
			hit = 15,
			dodge = 15
		}
	};

get({1000, 67}) ->
	#player_attr_conf{
		career = 1000,
		lv = 67,
		attr_base = #attr_base{
			hp = 7315,
			mp = 3901,
			min_ac = 268,
			max_ac = 536,
			min_mac = 0,
			max_mac = 0,
			min_sc = 0,
			max_sc = 0,
			min_def = 121,
			max_def = 244,
			min_res = 121,
			max_res = 244,
			crit = 0,
			crit_att = 35,
			hit = 15,
			dodge = 15
		}
	};

get({1000, 68}) ->
	#player_attr_conf{
		career = 1000,
		lv = 68,
		attr_base = #attr_base{
			hp = 7518,
			mp = 4009,
			min_ac = 275,
			max_ac = 551,
			min_mac = 0,
			max_mac = 0,
			min_sc = 0,
			max_sc = 0,
			min_def = 124,
			max_def = 251,
			min_res = 124,
			max_res = 251,
			crit = 0,
			crit_att = 35,
			hit = 15,
			dodge = 15
		}
	};

get({1000, 69}) ->
	#player_attr_conf{
		career = 1000,
		lv = 69,
		attr_base = #attr_base{
			hp = 7720,
			mp = 4117,
			min_ac = 283,
			max_ac = 566,
			min_mac = 0,
			max_mac = 0,
			min_sc = 0,
			max_sc = 0,
			min_def = 128,
			max_def = 258,
			min_res = 128,
			max_res = 258,
			crit = 0,
			crit_att = 35,
			hit = 15,
			dodge = 15
		}
	};

get({1000, 70}) ->
	#player_attr_conf{
		career = 1000,
		lv = 70,
		attr_base = #attr_base{
			hp = 7945,
			mp = 4237,
			min_ac = 291,
			max_ac = 583,
			min_mac = 0,
			max_mac = 0,
			min_sc = 0,
			max_sc = 0,
			min_def = 132,
			max_def = 265,
			min_res = 132,
			max_res = 265,
			crit = 0,
			crit_att = 35,
			hit = 15,
			dodge = 15
		}
	};

get({1000, 71}) ->
	#player_attr_conf{
		career = 1000,
		lv = 71,
		attr_base = #attr_base{
			hp = 8170,
			mp = 4357,
			min_ac = 299,
			max_ac = 599,
			min_mac = 0,
			max_mac = 0,
			min_sc = 0,
			max_sc = 0,
			min_def = 135,
			max_def = 273,
			min_res = 135,
			max_res = 273,
			crit = 0,
			crit_att = 40,
			hit = 15,
			dodge = 15
		}
	};

get({1000, 72}) ->
	#player_attr_conf{
		career = 1000,
		lv = 72,
		attr_base = #attr_base{
			hp = 8395,
			mp = 4477,
			min_ac = 308,
			max_ac = 616,
			min_mac = 0,
			max_mac = 0,
			min_sc = 0,
			max_sc = 0,
			min_def = 139,
			max_def = 280,
			min_res = 139,
			max_res = 280,
			crit = 0,
			crit_att = 40,
			hit = 15,
			dodge = 15
		}
	};

get({1000, 73}) ->
	#player_attr_conf{
		career = 1000,
		lv = 73,
		attr_base = #attr_base{
			hp = 8620,
			mp = 4597,
			min_ac = 316,
			max_ac = 632,
			min_mac = 0,
			max_mac = 0,
			min_sc = 0,
			max_sc = 0,
			min_def = 143,
			max_def = 288,
			min_res = 143,
			max_res = 288,
			crit = 0,
			crit_att = 40,
			hit = 15,
			dodge = 15
		}
	};

get({1000, 74}) ->
	#player_attr_conf{
		career = 1000,
		lv = 74,
		attr_base = #attr_base{
			hp = 8845,
			mp = 4717,
			min_ac = 324,
			max_ac = 649,
			min_mac = 0,
			max_mac = 0,
			min_sc = 0,
			max_sc = 0,
			min_def = 147,
			max_def = 295,
			min_res = 147,
			max_res = 295,
			crit = 0,
			crit_att = 40,
			hit = 15,
			dodge = 15
		}
	};

get({1000, 75}) ->
	#player_attr_conf{
		career = 1000,
		lv = 75,
		attr_base = #attr_base{
			hp = 9070,
			mp = 4837,
			min_ac = 332,
			max_ac = 665,
			min_mac = 0,
			max_mac = 0,
			min_sc = 0,
			max_sc = 0,
			min_def = 150,
			max_def = 303,
			min_res = 150,
			max_res = 303,
			crit = 0,
			crit_att = 40,
			hit = 15,
			dodge = 15
		}
	};

get({1000, 76}) ->
	#player_attr_conf{
		career = 1000,
		lv = 76,
		attr_base = #attr_base{
			hp = 9295,
			mp = 4957,
			min_ac = 341,
			max_ac = 682,
			min_mac = 0,
			max_mac = 0,
			min_sc = 0,
			max_sc = 0,
			min_def = 154,
			max_def = 310,
			min_res = 154,
			max_res = 310,
			crit = 0,
			crit_att = 40,
			hit = 15,
			dodge = 15
		}
	};

get({1000, 77}) ->
	#player_attr_conf{
		career = 1000,
		lv = 77,
		attr_base = #attr_base{
			hp = 9520,
			mp = 5077,
			min_ac = 349,
			max_ac = 698,
			min_mac = 0,
			max_mac = 0,
			min_sc = 0,
			max_sc = 0,
			min_def = 158,
			max_def = 318,
			min_res = 158,
			max_res = 318,
			crit = 0,
			crit_att = 40,
			hit = 15,
			dodge = 15
		}
	};

get({1000, 78}) ->
	#player_attr_conf{
		career = 1000,
		lv = 78,
		attr_base = #attr_base{
			hp = 9745,
			mp = 5197,
			min_ac = 357,
			max_ac = 715,
			min_mac = 0,
			max_mac = 0,
			min_sc = 0,
			max_sc = 0,
			min_def = 162,
			max_def = 325,
			min_res = 162,
			max_res = 325,
			crit = 0,
			crit_att = 40,
			hit = 15,
			dodge = 15
		}
	};

get({1000, 79}) ->
	#player_attr_conf{
		career = 1000,
		lv = 79,
		attr_base = #attr_base{
			hp = 9970,
			mp = 5317,
			min_ac = 365,
			max_ac = 731,
			min_mac = 0,
			max_mac = 0,
			min_sc = 0,
			max_sc = 0,
			min_def = 165,
			max_def = 333,
			min_res = 165,
			max_res = 333,
			crit = 0,
			crit_att = 40,
			hit = 15,
			dodge = 15
		}
	};

get({1000, 80}) ->
	#player_attr_conf{
		career = 1000,
		lv = 80,
		attr_base = #attr_base{
			hp = 10209,
			mp = 5444,
			min_ac = 374,
			max_ac = 748,
			min_mac = 0,
			max_mac = 0,
			min_sc = 0,
			max_sc = 0,
			min_def = 169,
			max_def = 340,
			min_res = 169,
			max_res = 340,
			crit = 0,
			crit_att = 40,
			hit = 15,
			dodge = 15
		}
	};

get({1000, 81}) ->
	#player_attr_conf{
		career = 1000,
		lv = 81,
		attr_base = #attr_base{
			hp = 10447,
			mp = 5572,
			min_ac = 383,
			max_ac = 766,
			min_mac = 0,
			max_mac = 0,
			min_sc = 0,
			max_sc = 0,
			min_def = 173,
			max_def = 348,
			min_res = 173,
			max_res = 348,
			crit = 0,
			crit_att = 45,
			hit = 15,
			dodge = 15
		}
	};

get({1000, 82}) ->
	#player_attr_conf{
		career = 1000,
		lv = 82,
		attr_base = #attr_base{
			hp = 10686,
			mp = 5699,
			min_ac = 391,
			max_ac = 783,
			min_mac = 0,
			max_mac = 0,
			min_sc = 0,
			max_sc = 0,
			min_def = 177,
			max_def = 356,
			min_res = 177,
			max_res = 356,
			crit = 0,
			crit_att = 45,
			hit = 15,
			dodge = 15
		}
	};

get({1000, 83}) ->
	#player_attr_conf{
		career = 1000,
		lv = 83,
		attr_base = #attr_base{
			hp = 10924,
			mp = 5826,
			min_ac = 400,
			max_ac = 801,
			min_mac = 0,
			max_mac = 0,
			min_sc = 0,
			max_sc = 0,
			min_def = 181,
			max_def = 364,
			min_res = 181,
			max_res = 364,
			crit = 0,
			crit_att = 45,
			hit = 15,
			dodge = 15
		}
	};

get({1000, 84}) ->
	#player_attr_conf{
		career = 1000,
		lv = 84,
		attr_base = #attr_base{
			hp = 11163,
			mp = 5953,
			min_ac = 409,
			max_ac = 818,
			min_mac = 0,
			max_mac = 0,
			min_sc = 0,
			max_sc = 0,
			min_def = 185,
			max_def = 372,
			min_res = 185,
			max_res = 372,
			crit = 0,
			crit_att = 45,
			hit = 15,
			dodge = 15
		}
	};

get({1000, 85}) ->
	#player_attr_conf{
		career = 1000,
		lv = 85,
		attr_base = #attr_base{
			hp = 11401,
			mp = 6080,
			min_ac = 418,
			max_ac = 836,
			min_mac = 0,
			max_mac = 0,
			min_sc = 0,
			max_sc = 0,
			min_def = 189,
			max_def = 380,
			min_res = 189,
			max_res = 380,
			crit = 0,
			crit_att = 45,
			hit = 15,
			dodge = 15
		}
	};

get({1000, 86}) ->
	#player_attr_conf{
		career = 1000,
		lv = 86,
		attr_base = #attr_base{
			hp = 11640,
			mp = 6208,
			min_ac = 426,
			max_ac = 853,
			min_mac = 0,
			max_mac = 0,
			min_sc = 0,
			max_sc = 0,
			min_def = 193,
			max_def = 388,
			min_res = 193,
			max_res = 388,
			crit = 0,
			crit_att = 45,
			hit = 15,
			dodge = 15
		}
	};

get({1000, 87}) ->
	#player_attr_conf{
		career = 1000,
		lv = 87,
		attr_base = #attr_base{
			hp = 11878,
			mp = 6335,
			min_ac = 435,
			max_ac = 871,
			min_mac = 0,
			max_mac = 0,
			min_sc = 0,
			max_sc = 0,
			min_def = 197,
			max_def = 396,
			min_res = 197,
			max_res = 396,
			crit = 0,
			crit_att = 45,
			hit = 15,
			dodge = 15
		}
	};

get({1000, 88}) ->
	#player_attr_conf{
		career = 1000,
		lv = 88,
		attr_base = #attr_base{
			hp = 12117,
			mp = 6462,
			min_ac = 444,
			max_ac = 888,
			min_mac = 0,
			max_mac = 0,
			min_sc = 0,
			max_sc = 0,
			min_def = 201,
			max_def = 404,
			min_res = 201,
			max_res = 404,
			crit = 0,
			crit_att = 45,
			hit = 15,
			dodge = 15
		}
	};

get({1000, 89}) ->
	#player_attr_conf{
		career = 1000,
		lv = 89,
		attr_base = #attr_base{
			hp = 12355,
			mp = 6589,
			min_ac = 453,
			max_ac = 906,
			min_mac = 0,
			max_mac = 0,
			min_sc = 0,
			max_sc = 0,
			min_def = 205,
			max_def = 412,
			min_res = 205,
			max_res = 412,
			crit = 0,
			crit_att = 45,
			hit = 15,
			dodge = 15
		}
	};

get({1000, 90}) ->
	#player_attr_conf{
		career = 1000,
		lv = 90,
		attr_base = #attr_base{
			hp = 12607,
			mp = 6724,
			min_ac = 462,
			max_ac = 924,
			min_mac = 0,
			max_mac = 0,
			min_sc = 0,
			max_sc = 0,
			min_def = 209,
			max_def = 420,
			min_res = 209,
			max_res = 420,
			crit = 0,
			crit_att = 45,
			hit = 15,
			dodge = 15
		}
	};

get({1000, 91}) ->
	#player_attr_conf{
		career = 1000,
		lv = 91,
		attr_base = #attr_base{
			hp = 12859,
			mp = 6858,
			min_ac = 471,
			max_ac = 943,
			min_mac = 0,
			max_mac = 0,
			min_sc = 0,
			max_sc = 0,
			min_def = 213,
			max_def = 429,
			min_res = 213,
			max_res = 429,
			crit = 0,
			crit_att = 50,
			hit = 15,
			dodge = 15
		}
	};

get({1000, 92}) ->
	#player_attr_conf{
		career = 1000,
		lv = 92,
		attr_base = #attr_base{
			hp = 13111,
			mp = 6992,
			min_ac = 480,
			max_ac = 961,
			min_mac = 0,
			max_mac = 0,
			min_sc = 0,
			max_sc = 0,
			min_def = 218,
			max_def = 437,
			min_res = 218,
			max_res = 437,
			crit = 0,
			crit_att = 50,
			hit = 15,
			dodge = 15
		}
	};

get({1000, 93}) ->
	#player_attr_conf{
		career = 1000,
		lv = 93,
		attr_base = #attr_base{
			hp = 13363,
			mp = 7127,
			min_ac = 490,
			max_ac = 980,
			min_mac = 0,
			max_mac = 0,
			min_sc = 0,
			max_sc = 0,
			min_def = 222,
			max_def = 446,
			min_res = 222,
			max_res = 446,
			crit = 0,
			crit_att = 50,
			hit = 15,
			dodge = 15
		}
	};

get({1000, 94}) ->
	#player_attr_conf{
		career = 1000,
		lv = 94,
		attr_base = #attr_base{
			hp = 13615,
			mp = 7261,
			min_ac = 499,
			max_ac = 998,
			min_mac = 0,
			max_mac = 0,
			min_sc = 0,
			max_sc = 0,
			min_def = 226,
			max_def = 454,
			min_res = 226,
			max_res = 454,
			crit = 0,
			crit_att = 50,
			hit = 15,
			dodge = 15
		}
	};

get({1000, 95}) ->
	#player_attr_conf{
		career = 1000,
		lv = 95,
		attr_base = #attr_base{
			hp = 13867,
			mp = 7396,
			min_ac = 508,
			max_ac = 1017,
			min_mac = 0,
			max_mac = 0,
			min_sc = 0,
			max_sc = 0,
			min_def = 230,
			max_def = 462,
			min_res = 230,
			max_res = 462,
			crit = 0,
			crit_att = 50,
			hit = 15,
			dodge = 15
		}
	};

get({1000, 96}) ->
	#player_attr_conf{
		career = 1000,
		lv = 96,
		attr_base = #attr_base{
			hp = 14119,
			mp = 7530,
			min_ac = 517,
			max_ac = 1035,
			min_mac = 0,
			max_mac = 0,
			min_sc = 0,
			max_sc = 0,
			min_def = 234,
			max_def = 471,
			min_res = 234,
			max_res = 471,
			crit = 0,
			crit_att = 50,
			hit = 15,
			dodge = 15
		}
	};

get({1000, 97}) ->
	#player_attr_conf{
		career = 1000,
		lv = 97,
		attr_base = #attr_base{
			hp = 14371,
			mp = 7664,
			min_ac = 527,
			max_ac = 1054,
			min_mac = 0,
			max_mac = 0,
			min_sc = 0,
			max_sc = 0,
			min_def = 239,
			max_def = 479,
			min_res = 239,
			max_res = 479,
			crit = 0,
			crit_att = 50,
			hit = 15,
			dodge = 15
		}
	};

get({1000, 98}) ->
	#player_attr_conf{
		career = 1000,
		lv = 98,
		attr_base = #attr_base{
			hp = 14623,
			mp = 7799,
			min_ac = 536,
			max_ac = 1072,
			min_mac = 0,
			max_mac = 0,
			min_sc = 0,
			max_sc = 0,
			min_def = 243,
			max_def = 488,
			min_res = 243,
			max_res = 488,
			crit = 0,
			crit_att = 50,
			hit = 15,
			dodge = 15
		}
	};

get({1000, 99}) ->
	#player_attr_conf{
		career = 1000,
		lv = 99,
		attr_base = #attr_base{
			hp = 14875,
			mp = 7933,
			min_ac = 545,
			max_ac = 1091,
			min_mac = 0,
			max_mac = 0,
			min_sc = 0,
			max_sc = 0,
			min_def = 247,
			max_def = 496,
			min_res = 247,
			max_res = 496,
			crit = 0,
			crit_att = 50,
			hit = 15,
			dodge = 15
		}
	};

get({1000, 100}) ->
	#player_attr_conf{
		career = 1000,
		lv = 100,
		attr_base = #attr_base{
			hp = 15145,
			mp = 8077,
			min_ac = 555,
			max_ac = 1111,
			min_mac = 0,
			max_mac = 0,
			min_sc = 0,
			max_sc = 0,
			min_def = 252,
			max_def = 505,
			min_res = 252,
			max_res = 505,
			crit = 0,
			crit_att = 50,
			hit = 15,
			dodge = 15
		}
	};

get({1000, 101}) ->
	#player_attr_conf{
		career = 1000,
		lv = 101,
		attr_base = #attr_base{
			hp = 15415,
			mp = 8221,
			min_ac = 565,
			max_ac = 1130,
			min_mac = 0,
			max_mac = 0,
			min_sc = 0,
			max_sc = 0,
			min_def = 256,
			max_def = 514,
			min_res = 256,
			max_res = 514,
			crit = 0,
			crit_att = 55,
			hit = 15,
			dodge = 15
		}
	};

get({1000, 102}) ->
	#player_attr_conf{
		career = 1000,
		lv = 102,
		attr_base = #attr_base{
			hp = 15685,
			mp = 8365,
			min_ac = 575,
			max_ac = 1150,
			min_mac = 0,
			max_mac = 0,
			min_sc = 0,
			max_sc = 0,
			min_def = 261,
			max_def = 523,
			min_res = 261,
			max_res = 523,
			crit = 0,
			crit_att = 55,
			hit = 15,
			dodge = 15
		}
	};

get({1000, 103}) ->
	#player_attr_conf{
		career = 1000,
		lv = 103,
		attr_base = #attr_base{
			hp = 15955,
			mp = 8509,
			min_ac = 585,
			max_ac = 1170,
			min_mac = 0,
			max_mac = 0,
			min_sc = 0,
			max_sc = 0,
			min_def = 265,
			max_def = 532,
			min_res = 265,
			max_res = 532,
			crit = 0,
			crit_att = 55,
			hit = 15,
			dodge = 15
		}
	};

get({1000, 104}) ->
	#player_attr_conf{
		career = 1000,
		lv = 104,
		attr_base = #attr_base{
			hp = 16225,
			mp = 8653,
			min_ac = 595,
			max_ac = 1190,
			min_mac = 0,
			max_mac = 0,
			min_sc = 0,
			max_sc = 0,
			min_def = 270,
			max_def = 541,
			min_res = 270,
			max_res = 541,
			crit = 0,
			crit_att = 55,
			hit = 15,
			dodge = 15
		}
	};

get({1000, 105}) ->
	#player_attr_conf{
		career = 1000,
		lv = 105,
		attr_base = #attr_base{
			hp = 16495,
			mp = 8797,
			min_ac = 605,
			max_ac = 1210,
			min_mac = 0,
			max_mac = 0,
			min_sc = 0,
			max_sc = 0,
			min_def = 274,
			max_def = 550,
			min_res = 274,
			max_res = 550,
			crit = 0,
			crit_att = 55,
			hit = 15,
			dodge = 15
		}
	};

get({1000, 106}) ->
	#player_attr_conf{
		career = 1000,
		lv = 106,
		attr_base = #attr_base{
			hp = 16765,
			mp = 8941,
			min_ac = 614,
			max_ac = 1229,
			min_mac = 0,
			max_mac = 0,
			min_sc = 0,
			max_sc = 0,
			min_def = 279,
			max_def = 559,
			min_res = 279,
			max_res = 559,
			crit = 0,
			crit_att = 55,
			hit = 15,
			dodge = 15
		}
	};

get({1000, 107}) ->
	#player_attr_conf{
		career = 1000,
		lv = 107,
		attr_base = #attr_base{
			hp = 17035,
			mp = 9085,
			min_ac = 624,
			max_ac = 1249,
			min_mac = 0,
			max_mac = 0,
			min_sc = 0,
			max_sc = 0,
			min_def = 283,
			max_def = 568,
			min_res = 283,
			max_res = 568,
			crit = 0,
			crit_att = 55,
			hit = 15,
			dodge = 15
		}
	};

get({1000, 108}) ->
	#player_attr_conf{
		career = 1000,
		lv = 108,
		attr_base = #attr_base{
			hp = 17305,
			mp = 9229,
			min_ac = 634,
			max_ac = 1269,
			min_mac = 0,
			max_mac = 0,
			min_sc = 0,
			max_sc = 0,
			min_def = 288,
			max_def = 577,
			min_res = 288,
			max_res = 577,
			crit = 0,
			crit_att = 55,
			hit = 15,
			dodge = 15
		}
	};

get({1000, 109}) ->
	#player_attr_conf{
		career = 1000,
		lv = 109,
		attr_base = #attr_base{
			hp = 17575,
			mp = 9373,
			min_ac = 644,
			max_ac = 1289,
			min_mac = 0,
			max_mac = 0,
			min_sc = 0,
			max_sc = 0,
			min_def = 292,
			max_def = 586,
			min_res = 292,
			max_res = 586,
			crit = 0,
			crit_att = 55,
			hit = 15,
			dodge = 15
		}
	};

get({1000, 110}) ->
	#player_attr_conf{
		career = 1000,
		lv = 110,
		attr_base = #attr_base{
			hp = 17863,
			mp = 9527,
			min_ac = 655,
			max_ac = 1310,
			min_mac = 0,
			max_mac = 0,
			min_sc = 0,
			max_sc = 0,
			min_def = 297,
			max_def = 596,
			min_res = 297,
			max_res = 596,
			crit = 0,
			crit_att = 55,
			hit = 15,
			dodge = 15
		}
	};

get({1000, 111}) ->
	#player_attr_conf{
		career = 1000,
		lv = 111,
		attr_base = #attr_base{
			hp = 18151,
			mp = 9680,
			min_ac = 665,
			max_ac = 1331,
			min_mac = 0,
			max_mac = 0,
			min_sc = 0,
			max_sc = 0,
			min_def = 302,
			max_def = 605,
			min_res = 302,
			max_res = 605,
			crit = 0,
			crit_att = 60,
			hit = 15,
			dodge = 15
		}
	};

get({1000, 112}) ->
	#player_attr_conf{
		career = 1000,
		lv = 112,
		attr_base = #attr_base{
			hp = 18439,
			mp = 9834,
			min_ac = 676,
			max_ac = 1352,
			min_mac = 0,
			max_mac = 0,
			min_sc = 0,
			max_sc = 0,
			min_def = 306,
			max_def = 615,
			min_res = 306,
			max_res = 615,
			crit = 0,
			crit_att = 60,
			hit = 15,
			dodge = 15
		}
	};

get({1000, 113}) ->
	#player_attr_conf{
		career = 1000,
		lv = 113,
		attr_base = #attr_base{
			hp = 18727,
			mp = 9988,
			min_ac = 686,
			max_ac = 1373,
			min_mac = 0,
			max_mac = 0,
			min_sc = 0,
			max_sc = 0,
			min_def = 311,
			max_def = 624,
			min_res = 311,
			max_res = 624,
			crit = 0,
			crit_att = 60,
			hit = 15,
			dodge = 15
		}
	};

get({1000, 114}) ->
	#player_attr_conf{
		career = 1000,
		lv = 114,
		attr_base = #attr_base{
			hp = 19015,
			mp = 10141,
			min_ac = 697,
			max_ac = 1394,
			min_mac = 0,
			max_mac = 0,
			min_sc = 0,
			max_sc = 0,
			min_def = 316,
			max_def = 634,
			min_res = 316,
			max_res = 634,
			crit = 0,
			crit_att = 60,
			hit = 15,
			dodge = 15
		}
	};

get({1000, 115}) ->
	#player_attr_conf{
		career = 1000,
		lv = 115,
		attr_base = #attr_base{
			hp = 19303,
			mp = 10295,
			min_ac = 707,
			max_ac = 1415,
			min_mac = 0,
			max_mac = 0,
			min_sc = 0,
			max_sc = 0,
			min_def = 321,
			max_def = 644,
			min_res = 321,
			max_res = 644,
			crit = 0,
			crit_att = 60,
			hit = 15,
			dodge = 15
		}
	};

get({1000, 116}) ->
	#player_attr_conf{
		career = 1000,
		lv = 116,
		attr_base = #attr_base{
			hp = 19591,
			mp = 10448,
			min_ac = 718,
			max_ac = 1437,
			min_mac = 0,
			max_mac = 0,
			min_sc = 0,
			max_sc = 0,
			min_def = 326,
			max_def = 653,
			min_res = 326,
			max_res = 653,
			crit = 0,
			crit_att = 60,
			hit = 15,
			dodge = 15
		}
	};

get({1000, 117}) ->
	#player_attr_conf{
		career = 1000,
		lv = 117,
		attr_base = #attr_base{
			hp = 19879,
			mp = 10602,
			min_ac = 729,
			max_ac = 1458,
			min_mac = 0,
			max_mac = 0,
			min_sc = 0,
			max_sc = 0,
			min_def = 330,
			max_def = 663,
			min_res = 330,
			max_res = 663,
			crit = 0,
			crit_att = 60,
			hit = 15,
			dodge = 15
		}
	};

get({1000, 118}) ->
	#player_attr_conf{
		career = 1000,
		lv = 118,
		attr_base = #attr_base{
			hp = 20167,
			mp = 10756,
			min_ac = 739,
			max_ac = 1479,
			min_mac = 0,
			max_mac = 0,
			min_sc = 0,
			max_sc = 0,
			min_def = 335,
			max_def = 672,
			min_res = 335,
			max_res = 672,
			crit = 0,
			crit_att = 60,
			hit = 15,
			dodge = 15
		}
	};

get({1000, 119}) ->
	#player_attr_conf{
		career = 1000,
		lv = 119,
		attr_base = #attr_base{
			hp = 20455,
			mp = 10909,
			min_ac = 750,
			max_ac = 1500,
			min_mac = 0,
			max_mac = 0,
			min_sc = 0,
			max_sc = 0,
			min_def = 340,
			max_def = 682,
			min_res = 340,
			max_res = 682,
			crit = 0,
			crit_att = 60,
			hit = 15,
			dodge = 15
		}
	};

get({1000, 120}) ->
	#player_attr_conf{
		career = 1000,
		lv = 120,
		attr_base = #attr_base{
			hp = 20761,
			mp = 11072,
			min_ac = 761,
			max_ac = 1522,
			min_mac = 0,
			max_mac = 0,
			min_sc = 0,
			max_sc = 0,
			min_def = 345,
			max_def = 692,
			min_res = 345,
			max_res = 692,
			crit = 0,
			crit_att = 60,
			hit = 15,
			dodge = 15
		}
	};

get({1000, 121}) ->
	#player_attr_conf{
		career = 1000,
		lv = 121,
		attr_base = #attr_base{
			hp = 21067,
			mp = 11236,
			min_ac = 772,
			max_ac = 1545,
			min_mac = 0,
			max_mac = 0,
			min_sc = 0,
			max_sc = 0,
			min_def = 350,
			max_def = 702,
			min_res = 350,
			max_res = 702,
			crit = 0,
			crit_att = 65,
			hit = 15,
			dodge = 15
		}
	};

get({1000, 122}) ->
	#player_attr_conf{
		career = 1000,
		lv = 122,
		attr_base = #attr_base{
			hp = 21373,
			mp = 11399,
			min_ac = 783,
			max_ac = 1567,
			min_mac = 0,
			max_mac = 0,
			min_sc = 0,
			max_sc = 0,
			min_def = 355,
			max_def = 713,
			min_res = 355,
			max_res = 713,
			crit = 0,
			crit_att = 65,
			hit = 15,
			dodge = 15
		}
	};

get({1000, 123}) ->
	#player_attr_conf{
		career = 1000,
		lv = 123,
		attr_base = #attr_base{
			hp = 21679,
			mp = 11562,
			min_ac = 795,
			max_ac = 1590,
			min_mac = 0,
			max_mac = 0,
			min_sc = 0,
			max_sc = 0,
			min_def = 360,
			max_def = 723,
			min_res = 360,
			max_res = 723,
			crit = 0,
			crit_att = 65,
			hit = 15,
			dodge = 15
		}
	};

get({1000, 124}) ->
	#player_attr_conf{
		career = 1000,
		lv = 124,
		attr_base = #attr_base{
			hp = 21985,
			mp = 11725,
			min_ac = 806,
			max_ac = 1612,
			min_mac = 0,
			max_mac = 0,
			min_sc = 0,
			max_sc = 0,
			min_def = 366,
			max_def = 733,
			min_res = 366,
			max_res = 733,
			crit = 0,
			crit_att = 65,
			hit = 15,
			dodge = 15
		}
	};

get({1000, 125}) ->
	#player_attr_conf{
		career = 1000,
		lv = 125,
		attr_base = #attr_base{
			hp = 22291,
			mp = 11888,
			min_ac = 817,
			max_ac = 1635,
			min_mac = 0,
			max_mac = 0,
			min_sc = 0,
			max_sc = 0,
			min_def = 371,
			max_def = 743,
			min_res = 371,
			max_res = 743,
			crit = 0,
			crit_att = 65,
			hit = 15,
			dodge = 15
		}
	};

get({1000, 126}) ->
	#player_attr_conf{
		career = 1000,
		lv = 126,
		attr_base = #attr_base{
			hp = 22597,
			mp = 12052,
			min_ac = 828,
			max_ac = 1657,
			min_mac = 0,
			max_mac = 0,
			min_sc = 0,
			max_sc = 0,
			min_def = 376,
			max_def = 753,
			min_res = 376,
			max_res = 753,
			crit = 0,
			crit_att = 65,
			hit = 15,
			dodge = 15
		}
	};

get({1000, 127}) ->
	#player_attr_conf{
		career = 1000,
		lv = 127,
		attr_base = #attr_base{
			hp = 22903,
			mp = 12215,
			min_ac = 839,
			max_ac = 1679,
			min_mac = 0,
			max_mac = 0,
			min_sc = 0,
			max_sc = 0,
			min_def = 381,
			max_def = 764,
			min_res = 381,
			max_res = 764,
			crit = 0,
			crit_att = 65,
			hit = 15,
			dodge = 15
		}
	};

get({1000, 128}) ->
	#player_attr_conf{
		career = 1000,
		lv = 128,
		attr_base = #attr_base{
			hp = 23209,
			mp = 12378,
			min_ac = 851,
			max_ac = 1702,
			min_mac = 0,
			max_mac = 0,
			min_sc = 0,
			max_sc = 0,
			min_def = 386,
			max_def = 774,
			min_res = 386,
			max_res = 774,
			crit = 0,
			crit_att = 65,
			hit = 15,
			dodge = 15
		}
	};

get({1000, 129}) ->
	#player_attr_conf{
		career = 1000,
		lv = 129,
		attr_base = #attr_base{
			hp = 23515,
			mp = 12541,
			min_ac = 862,
			max_ac = 1724,
			min_mac = 0,
			max_mac = 0,
			min_sc = 0,
			max_sc = 0,
			min_def = 391,
			max_def = 784,
			min_res = 391,
			max_res = 784,
			crit = 0,
			crit_att = 65,
			hit = 15,
			dodge = 15
		}
	};

get({1000, 130}) ->
	#player_attr_conf{
		career = 1000,
		lv = 130,
		attr_base = #attr_base{
			hp = 23839,
			mp = 12714,
			min_ac = 874,
			max_ac = 1748,
			min_mac = 0,
			max_mac = 0,
			min_sc = 0,
			max_sc = 0,
			min_def = 396,
			max_def = 795,
			min_res = 396,
			max_res = 795,
			crit = 0,
			crit_att = 65,
			hit = 15,
			dodge = 15
		}
	};

get({2000, 1}) ->
	#player_attr_conf{
		career = 2000,
		lv = 1,
		attr_base = #attr_base{
			hp = 11,
			mp = 22,
			min_ac = 0,
			max_ac = 0,
			min_mac = 1,
			max_mac = 2,
			min_sc = 0,
			max_sc = 0,
			min_def = 0,
			max_def = 0,
			min_res = 0,
			max_res = 1,
			crit = 0,
			crit_att = 5,
			hit = 15,
			dodge = 15
		}
	};

get({2000, 2}) ->
	#player_attr_conf{
		career = 2000,
		lv = 2,
		attr_base = #attr_base{
			hp = 32,
			mp = 61,
			min_ac = 0,
			max_ac = 0,
			min_mac = 3,
			max_mac = 6,
			min_sc = 0,
			max_sc = 0,
			min_def = 0,
			max_def = 1,
			min_res = 0,
			max_res = 2,
			crit = 0,
			crit_att = 5,
			hit = 15,
			dodge = 15
		}
	};

get({2000, 3}) ->
	#player_attr_conf{
		career = 2000,
		lv = 3,
		attr_base = #attr_base{
			hp = 53,
			mp = 100,
			min_ac = 0,
			max_ac = 0,
			min_mac = 5,
			max_mac = 10,
			min_sc = 0,
			max_sc = 0,
			min_def = 0,
			max_def = 2,
			min_res = 1,
			max_res = 3,
			crit = 0,
			crit_att = 5,
			hit = 15,
			dodge = 15
		}
	};

get({2000, 4}) ->
	#player_attr_conf{
		career = 2000,
		lv = 4,
		attr_base = #attr_base{
			hp = 74,
			mp = 139,
			min_ac = 0,
			max_ac = 0,
			min_mac = 7,
			max_mac = 14,
			min_sc = 0,
			max_sc = 0,
			min_def = 1,
			max_def = 2,
			min_res = 1,
			max_res = 5,
			crit = 0,
			crit_att = 5,
			hit = 15,
			dodge = 15
		}
	};

get({2000, 5}) ->
	#player_attr_conf{
		career = 2000,
		lv = 5,
		attr_base = #attr_base{
			hp = 95,
			mp = 178,
			min_ac = 0,
			max_ac = 0,
			min_mac = 9,
			max_mac = 18,
			min_sc = 0,
			max_sc = 0,
			min_def = 1,
			max_def = 3,
			min_res = 2,
			max_res = 6,
			crit = 0,
			crit_att = 5,
			hit = 15,
			dodge = 15
		}
	};

get({2000, 6}) ->
	#player_attr_conf{
		career = 2000,
		lv = 6,
		attr_base = #attr_base{
			hp = 116,
			mp = 217,
			min_ac = 0,
			max_ac = 0,
			min_mac = 11,
			max_mac = 22,
			min_sc = 0,
			max_sc = 0,
			min_def = 1,
			max_def = 4,
			min_res = 3,
			max_res = 7,
			crit = 0,
			crit_att = 5,
			hit = 15,
			dodge = 15
		}
	};

get({2000, 7}) ->
	#player_attr_conf{
		career = 2000,
		lv = 7,
		attr_base = #attr_base{
			hp = 137,
			mp = 256,
			min_ac = 0,
			max_ac = 0,
			min_mac = 13,
			max_mac = 26,
			min_sc = 0,
			max_sc = 0,
			min_def = 2,
			max_def = 4,
			min_res = 3,
			max_res = 9,
			crit = 0,
			crit_att = 5,
			hit = 15,
			dodge = 15
		}
	};

get({2000, 8}) ->
	#player_attr_conf{
		career = 2000,
		lv = 8,
		attr_base = #attr_base{
			hp = 158,
			mp = 295,
			min_ac = 0,
			max_ac = 0,
			min_mac = 14,
			max_mac = 29,
			min_sc = 0,
			max_sc = 0,
			min_def = 2,
			max_def = 5,
			min_res = 4,
			max_res = 10,
			crit = 0,
			crit_att = 5,
			hit = 15,
			dodge = 15
		}
	};

get({2000, 9}) ->
	#player_attr_conf{
		career = 2000,
		lv = 9,
		attr_base = #attr_base{
			hp = 179,
			mp = 334,
			min_ac = 0,
			max_ac = 0,
			min_mac = 16,
			max_mac = 33,
			min_sc = 0,
			max_sc = 0,
			min_def = 2,
			max_def = 6,
			min_res = 5,
			max_res = 11,
			crit = 0,
			crit_att = 5,
			hit = 15,
			dodge = 15
		}
	};

get({2000, 10}) ->
	#player_attr_conf{
		career = 2000,
		lv = 10,
		attr_base = #attr_base{
			hp = 200,
			mp = 373,
			min_ac = 0,
			max_ac = 0,
			min_mac = 18,
			max_mac = 37,
			min_sc = 0,
			max_sc = 0,
			min_def = 3,
			max_def = 7,
			min_res = 5,
			max_res = 13,
			crit = 0,
			crit_att = 5,
			hit = 15,
			dodge = 15
		}
	};

get({2000, 11}) ->
	#player_attr_conf{
		career = 2000,
		lv = 11,
		attr_base = #attr_base{
			hp = 221,
			mp = 412,
			min_ac = 0,
			max_ac = 0,
			min_mac = 20,
			max_mac = 41,
			min_sc = 0,
			max_sc = 0,
			min_def = 3,
			max_def = 7,
			min_res = 6,
			max_res = 14,
			crit = 0,
			crit_att = 10,
			hit = 15,
			dodge = 15
		}
	};

get({2000, 12}) ->
	#player_attr_conf{
		career = 2000,
		lv = 12,
		attr_base = #attr_base{
			hp = 242,
			mp = 451,
			min_ac = 0,
			max_ac = 0,
			min_mac = 22,
			max_mac = 45,
			min_sc = 0,
			max_sc = 0,
			min_def = 3,
			max_def = 8,
			min_res = 7,
			max_res = 15,
			crit = 0,
			crit_att = 10,
			hit = 15,
			dodge = 15
		}
	};

get({2000, 13}) ->
	#player_attr_conf{
		career = 2000,
		lv = 13,
		attr_base = #attr_base{
			hp = 263,
			mp = 490,
			min_ac = 0,
			max_ac = 0,
			min_mac = 24,
			max_mac = 49,
			min_sc = 0,
			max_sc = 0,
			min_def = 4,
			max_def = 9,
			min_res = 7,
			max_res = 16,
			crit = 0,
			crit_att = 10,
			hit = 15,
			dodge = 15
		}
	};

get({2000, 14}) ->
	#player_attr_conf{
		career = 2000,
		lv = 14,
		attr_base = #attr_base{
			hp = 284,
			mp = 529,
			min_ac = 0,
			max_ac = 0,
			min_mac = 26,
			max_mac = 53,
			min_sc = 0,
			max_sc = 0,
			min_def = 4,
			max_def = 9,
			min_res = 8,
			max_res = 18,
			crit = 0,
			crit_att = 10,
			hit = 15,
			dodge = 15
		}
	};

get({2000, 15}) ->
	#player_attr_conf{
		career = 2000,
		lv = 15,
		attr_base = #attr_base{
			hp = 305,
			mp = 568,
			min_ac = 0,
			max_ac = 0,
			min_mac = 28,
			max_mac = 57,
			min_sc = 0,
			max_sc = 0,
			min_def = 4,
			max_def = 10,
			min_res = 9,
			max_res = 19,
			crit = 0,
			crit_att = 10,
			hit = 15,
			dodge = 15
		}
	};

get({2000, 16}) ->
	#player_attr_conf{
		career = 2000,
		lv = 16,
		attr_base = #attr_base{
			hp = 326,
			mp = 607,
			min_ac = 0,
			max_ac = 0,
			min_mac = 30,
			max_mac = 61,
			min_sc = 0,
			max_sc = 0,
			min_def = 5,
			max_def = 11,
			min_res = 9,
			max_res = 20,
			crit = 0,
			crit_att = 10,
			hit = 15,
			dodge = 15
		}
	};

get({2000, 17}) ->
	#player_attr_conf{
		career = 2000,
		lv = 17,
		attr_base = #attr_base{
			hp = 347,
			mp = 646,
			min_ac = 0,
			max_ac = 0,
			min_mac = 32,
			max_mac = 65,
			min_sc = 0,
			max_sc = 0,
			min_def = 5,
			max_def = 11,
			min_res = 10,
			max_res = 22,
			crit = 0,
			crit_att = 10,
			hit = 15,
			dodge = 15
		}
	};

get({2000, 18}) ->
	#player_attr_conf{
		career = 2000,
		lv = 18,
		attr_base = #attr_base{
			hp = 368,
			mp = 685,
			min_ac = 0,
			max_ac = 0,
			min_mac = 34,
			max_mac = 68,
			min_sc = 0,
			max_sc = 0,
			min_def = 5,
			max_def = 12,
			min_res = 11,
			max_res = 23,
			crit = 0,
			crit_att = 10,
			hit = 15,
			dodge = 15
		}
	};

get({2000, 19}) ->
	#player_attr_conf{
		career = 2000,
		lv = 19,
		attr_base = #attr_base{
			hp = 389,
			mp = 724,
			min_ac = 0,
			max_ac = 0,
			min_mac = 36,
			max_mac = 72,
			min_sc = 0,
			max_sc = 0,
			min_def = 6,
			max_def = 13,
			min_res = 11,
			max_res = 24,
			crit = 0,
			crit_att = 10,
			hit = 15,
			dodge = 15
		}
	};

get({2000, 20}) ->
	#player_attr_conf{
		career = 2000,
		lv = 20,
		attr_base = #attr_base{
			hp = 421,
			mp = 782,
			min_ac = 0,
			max_ac = 0,
			min_mac = 39,
			max_mac = 78,
			min_sc = 0,
			max_sc = 0,
			min_def = 6,
			max_def = 14,
			min_res = 12,
			max_res = 26,
			crit = 0,
			crit_att = 10,
			hit = 15,
			dodge = 15
		}
	};

get({2000, 21}) ->
	#player_attr_conf{
		career = 2000,
		lv = 21,
		attr_base = #attr_base{
			hp = 452,
			mp = 841,
			min_ac = 0,
			max_ac = 0,
			min_mac = 42,
			max_mac = 84,
			min_sc = 0,
			max_sc = 0,
			min_def = 7,
			max_def = 15,
			min_res = 13,
			max_res = 28,
			crit = 0,
			crit_att = 15,
			hit = 15,
			dodge = 15
		}
	};

get({2000, 22}) ->
	#player_attr_conf{
		career = 2000,
		lv = 22,
		attr_base = #attr_base{
			hp = 484,
			mp = 899,
			min_ac = 0,
			max_ac = 0,
			min_mac = 45,
			max_mac = 90,
			min_sc = 0,
			max_sc = 0,
			min_def = 7,
			max_def = 16,
			min_res = 14,
			max_res = 30,
			crit = 0,
			crit_att = 15,
			hit = 15,
			dodge = 15
		}
	};

get({2000, 23}) ->
	#player_attr_conf{
		career = 2000,
		lv = 23,
		attr_base = #attr_base{
			hp = 515,
			mp = 958,
			min_ac = 0,
			max_ac = 0,
			min_mac = 48,
			max_mac = 96,
			min_sc = 0,
			max_sc = 0,
			min_def = 8,
			max_def = 17,
			min_res = 15,
			max_res = 32,
			crit = 0,
			crit_att = 15,
			hit = 15,
			dodge = 15
		}
	};

get({2000, 24}) ->
	#player_attr_conf{
		career = 2000,
		lv = 24,
		attr_base = #attr_base{
			hp = 547,
			mp = 1016,
			min_ac = 0,
			max_ac = 0,
			min_mac = 51,
			max_mac = 102,
			min_sc = 0,
			max_sc = 0,
			min_def = 8,
			max_def = 18,
			min_res = 16,
			max_res = 34,
			crit = 0,
			crit_att = 15,
			hit = 15,
			dodge = 15
		}
	};

get({2000, 25}) ->
	#player_attr_conf{
		career = 2000,
		lv = 25,
		attr_base = #attr_base{
			hp = 578,
			mp = 1075,
			min_ac = 0,
			max_ac = 0,
			min_mac = 53,
			max_mac = 107,
			min_sc = 0,
			max_sc = 0,
			min_def = 9,
			max_def = 19,
			min_res = 17,
			max_res = 36,
			crit = 0,
			crit_att = 15,
			hit = 15,
			dodge = 15
		}
	};

get({2000, 26}) ->
	#player_attr_conf{
		career = 2000,
		lv = 26,
		attr_base = #attr_base{
			hp = 610,
			mp = 1133,
			min_ac = 0,
			max_ac = 0,
			min_mac = 56,
			max_mac = 113,
			min_sc = 0,
			max_sc = 0,
			min_def = 9,
			max_def = 20,
			min_res = 18,
			max_res = 38,
			crit = 0,
			crit_att = 15,
			hit = 15,
			dodge = 15
		}
	};

get({2000, 27}) ->
	#player_attr_conf{
		career = 2000,
		lv = 27,
		attr_base = #attr_base{
			hp = 641,
			mp = 1192,
			min_ac = 0,
			max_ac = 0,
			min_mac = 59,
			max_mac = 119,
			min_sc = 0,
			max_sc = 0,
			min_def = 10,
			max_def = 21,
			min_res = 19,
			max_res = 40,
			crit = 0,
			crit_att = 15,
			hit = 15,
			dodge = 15
		}
	};

get({2000, 28}) ->
	#player_attr_conf{
		career = 2000,
		lv = 28,
		attr_base = #attr_base{
			hp = 673,
			mp = 1250,
			min_ac = 0,
			max_ac = 0,
			min_mac = 62,
			max_mac = 125,
			min_sc = 0,
			max_sc = 0,
			min_def = 11,
			max_def = 22,
			min_res = 20,
			max_res = 42,
			crit = 0,
			crit_att = 15,
			hit = 15,
			dodge = 15
		}
	};

get({2000, 29}) ->
	#player_attr_conf{
		career = 2000,
		lv = 29,
		attr_base = #attr_base{
			hp = 704,
			mp = 1309,
			min_ac = 0,
			max_ac = 0,
			min_mac = 65,
			max_mac = 131,
			min_sc = 0,
			max_sc = 0,
			min_def = 11,
			max_def = 23,
			min_res = 21,
			max_res = 44,
			crit = 0,
			crit_att = 15,
			hit = 15,
			dodge = 15
		}
	};

get({2000, 30}) ->
	#player_attr_conf{
		career = 2000,
		lv = 30,
		attr_base = #attr_base{
			hp = 753,
			mp = 1398,
			min_ac = 0,
			max_ac = 0,
			min_mac = 70,
			max_mac = 140,
			min_sc = 0,
			max_sc = 0,
			min_def = 12,
			max_def = 25,
			min_res = 22,
			max_res = 47,
			crit = 0,
			crit_att = 15,
			hit = 15,
			dodge = 15
		}
	};

get({2000, 31}) ->
	#player_attr_conf{
		career = 2000,
		lv = 31,
		attr_base = #attr_base{
			hp = 801,
			mp = 1488,
			min_ac = 0,
			max_ac = 0,
			min_mac = 74,
			max_mac = 149,
			min_sc = 0,
			max_sc = 0,
			min_def = 13,
			max_def = 27,
			min_res = 24,
			max_res = 50,
			crit = 0,
			crit_att = 20,
			hit = 15,
			dodge = 15
		}
	};

get({2000, 32}) ->
	#player_attr_conf{
		career = 2000,
		lv = 32,
		attr_base = #attr_base{
			hp = 849,
			mp = 1578,
			min_ac = 0,
			max_ac = 0,
			min_mac = 79,
			max_mac = 158,
			min_sc = 0,
			max_sc = 0,
			min_def = 13,
			max_def = 28,
			min_res = 25,
			max_res = 53,
			crit = 0,
			crit_att = 20,
			hit = 15,
			dodge = 15
		}
	};

get({2000, 33}) ->
	#player_attr_conf{
		career = 2000,
		lv = 33,
		attr_base = #attr_base{
			hp = 898,
			mp = 1667,
			min_ac = 0,
			max_ac = 0,
			min_mac = 83,
			max_mac = 167,
			min_sc = 0,
			max_sc = 0,
			min_def = 14,
			max_def = 30,
			min_res = 27,
			max_res = 56,
			crit = 0,
			crit_att = 20,
			hit = 15,
			dodge = 15
		}
	};

get({2000, 34}) ->
	#player_attr_conf{
		career = 2000,
		lv = 34,
		attr_base = #attr_base{
			hp = 946,
			mp = 1757,
			min_ac = 0,
			max_ac = 0,
			min_mac = 88,
			max_mac = 176,
			min_sc = 0,
			max_sc = 0,
			min_def = 15,
			max_def = 31,
			min_res = 28,
			max_res = 59,
			crit = 0,
			crit_att = 20,
			hit = 15,
			dodge = 15
		}
	};

get({2000, 35}) ->
	#player_attr_conf{
		career = 2000,
		lv = 35,
		attr_base = #attr_base{
			hp = 994,
			mp = 1847,
			min_ac = 0,
			max_ac = 0,
			min_mac = 92,
			max_mac = 185,
			min_sc = 0,
			max_sc = 0,
			min_def = 16,
			max_def = 33,
			min_res = 30,
			max_res = 62,
			crit = 0,
			crit_att = 20,
			hit = 15,
			dodge = 15
		}
	};

get({2000, 36}) ->
	#player_attr_conf{
		career = 2000,
		lv = 36,
		attr_base = #attr_base{
			hp = 1043,
			mp = 1937,
			min_ac = 0,
			max_ac = 0,
			min_mac = 97,
			max_mac = 194,
			min_sc = 0,
			max_sc = 0,
			min_def = 17,
			max_def = 35,
			min_res = 31,
			max_res = 65,
			crit = 0,
			crit_att = 20,
			hit = 15,
			dodge = 15
		}
	};

get({2000, 37}) ->
	#player_attr_conf{
		career = 2000,
		lv = 37,
		attr_base = #attr_base{
			hp = 1091,
			mp = 2026,
			min_ac = 0,
			max_ac = 0,
			min_mac = 101,
			max_mac = 203,
			min_sc = 0,
			max_sc = 0,
			min_def = 17,
			max_def = 36,
			min_res = 33,
			max_res = 68,
			crit = 0,
			crit_att = 20,
			hit = 15,
			dodge = 15
		}
	};

get({2000, 38}) ->
	#player_attr_conf{
		career = 2000,
		lv = 38,
		attr_base = #attr_base{
			hp = 1139,
			mp = 2116,
			min_ac = 0,
			max_ac = 0,
			min_mac = 106,
			max_mac = 212,
			min_sc = 0,
			max_sc = 0,
			min_def = 18,
			max_def = 38,
			min_res = 34,
			max_res = 71,
			crit = 0,
			crit_att = 20,
			hit = 15,
			dodge = 15
		}
	};

get({2000, 39}) ->
	#player_attr_conf{
		career = 2000,
		lv = 39,
		attr_base = #attr_base{
			hp = 1187,
			mp = 2206,
			min_ac = 0,
			max_ac = 0,
			min_mac = 110,
			max_mac = 221,
			min_sc = 0,
			max_sc = 0,
			min_def = 19,
			max_def = 39,
			min_res = 36,
			max_res = 74,
			crit = 0,
			crit_att = 20,
			hit = 15,
			dodge = 15
		}
	};

get({2000, 40}) ->
	#player_attr_conf{
		career = 2000,
		lv = 40,
		attr_base = #attr_base{
			hp = 1250,
			mp = 2323,
			min_ac = 0,
			max_ac = 0,
			min_mac = 116,
			max_mac = 232,
			min_sc = 0,
			max_sc = 0,
			min_def = 20,
			max_def = 42,
			min_res = 38,
			max_res = 78,
			crit = 0,
			crit_att = 20,
			hit = 15,
			dodge = 15
		}
	};

get({2000, 41}) ->
	#player_attr_conf{
		career = 2000,
		lv = 41,
		attr_base = #attr_base{
			hp = 1313,
			mp = 2440,
			min_ac = 0,
			max_ac = 0,
			min_mac = 122,
			max_mac = 244,
			min_sc = 0,
			max_sc = 0,
			min_def = 21,
			max_def = 44,
			min_res = 40,
			max_res = 81,
			crit = 0,
			crit_att = 25,
			hit = 15,
			dodge = 15
		}
	};

get({2000, 42}) ->
	#player_attr_conf{
		career = 2000,
		lv = 42,
		attr_base = #attr_base{
			hp = 1376,
			mp = 2557,
			min_ac = 0,
			max_ac = 0,
			min_mac = 128,
			max_mac = 256,
			min_sc = 0,
			max_sc = 0,
			min_def = 22,
			max_def = 46,
			min_res = 42,
			max_res = 85,
			crit = 0,
			crit_att = 25,
			hit = 15,
			dodge = 15
		}
	};

get({2000, 43}) ->
	#player_attr_conf{
		career = 2000,
		lv = 43,
		attr_base = #attr_base{
			hp = 1439,
			mp = 2674,
			min_ac = 0,
			max_ac = 0,
			min_mac = 133,
			max_mac = 267,
			min_sc = 0,
			max_sc = 0,
			min_def = 23,
			max_def = 48,
			min_res = 44,
			max_res = 89,
			crit = 0,
			crit_att = 25,
			hit = 15,
			dodge = 15
		}
	};

get({2000, 44}) ->
	#player_attr_conf{
		career = 2000,
		lv = 44,
		attr_base = #attr_base{
			hp = 1502,
			mp = 2791,
			min_ac = 0,
			max_ac = 0,
			min_mac = 139,
			max_mac = 279,
			min_sc = 0,
			max_sc = 0,
			min_def = 24,
			max_def = 50,
			min_res = 46,
			max_res = 93,
			crit = 0,
			crit_att = 25,
			hit = 15,
			dodge = 15
		}
	};

get({2000, 45}) ->
	#player_attr_conf{
		career = 2000,
		lv = 45,
		attr_base = #attr_base{
			hp = 1565,
			mp = 2908,
			min_ac = 0,
			max_ac = 0,
			min_mac = 145,
			max_mac = 291,
			min_sc = 0,
			max_sc = 0,
			min_def = 25,
			max_def = 52,
			min_res = 48,
			max_res = 97,
			crit = 0,
			crit_att = 25,
			hit = 15,
			dodge = 15
		}
	};

get({2000, 46}) ->
	#player_attr_conf{
		career = 2000,
		lv = 46,
		attr_base = #attr_base{
			hp = 1628,
			mp = 3025,
			min_ac = 0,
			max_ac = 0,
			min_mac = 151,
			max_mac = 302,
			min_sc = 0,
			max_sc = 0,
			min_def = 26,
			max_def = 54,
			min_res = 50,
			max_res = 101,
			crit = 0,
			crit_att = 25,
			hit = 15,
			dodge = 15
		}
	};

get({2000, 47}) ->
	#player_attr_conf{
		career = 2000,
		lv = 47,
		attr_base = #attr_base{
			hp = 1691,
			mp = 3142,
			min_ac = 0,
			max_ac = 0,
			min_mac = 157,
			max_mac = 314,
			min_sc = 0,
			max_sc = 0,
			min_def = 28,
			max_def = 56,
			min_res = 52,
			max_res = 105,
			crit = 0,
			crit_att = 25,
			hit = 15,
			dodge = 15
		}
	};

get({2000, 48}) ->
	#player_attr_conf{
		career = 2000,
		lv = 48,
		attr_base = #attr_base{
			hp = 1754,
			mp = 3259,
			min_ac = 0,
			max_ac = 0,
			min_mac = 163,
			max_mac = 326,
			min_sc = 0,
			max_sc = 0,
			min_def = 29,
			max_def = 58,
			min_res = 53,
			max_res = 109,
			crit = 0,
			crit_att = 25,
			hit = 15,
			dodge = 15
		}
	};

get({2000, 49}) ->
	#player_attr_conf{
		career = 2000,
		lv = 49,
		attr_base = #attr_base{
			hp = 1817,
			mp = 3376,
			min_ac = 0,
			max_ac = 0,
			min_mac = 169,
			max_mac = 338,
			min_sc = 0,
			max_sc = 0,
			min_def = 30,
			max_def = 60,
			min_res = 55,
			max_res = 113,
			crit = 0,
			crit_att = 25,
			hit = 15,
			dodge = 15
		}
	};

get({2000, 50}) ->
	#player_attr_conf{
		career = 2000,
		lv = 50,
		attr_base = #attr_base{
			hp = 1901,
			mp = 3532,
			min_ac = 0,
			max_ac = 0,
			min_mac = 176,
			max_mac = 353,
			min_sc = 0,
			max_sc = 0,
			min_def = 31,
			max_def = 63,
			min_res = 58,
			max_res = 118,
			crit = 0,
			crit_att = 25,
			hit = 15,
			dodge = 15
		}
	};

get({2000, 51}) ->
	#player_attr_conf{
		career = 2000,
		lv = 51,
		attr_base = #attr_base{
			hp = 1985,
			mp = 3688,
			min_ac = 0,
			max_ac = 0,
			min_mac = 184,
			max_mac = 369,
			min_sc = 0,
			max_sc = 0,
			min_def = 32,
			max_def = 66,
			min_res = 61,
			max_res = 123,
			crit = 0,
			crit_att = 30,
			hit = 15,
			dodge = 15
		}
	};

get({2000, 52}) ->
	#player_attr_conf{
		career = 2000,
		lv = 52,
		attr_base = #attr_base{
			hp = 2069,
			mp = 3844,
			min_ac = 0,
			max_ac = 0,
			min_mac = 192,
			max_mac = 384,
			min_sc = 0,
			max_sc = 0,
			min_def = 34,
			max_def = 69,
			min_res = 63,
			max_res = 128,
			crit = 0,
			crit_att = 30,
			hit = 15,
			dodge = 15
		}
	};

get({2000, 53}) ->
	#player_attr_conf{
		career = 2000,
		lv = 53,
		attr_base = #attr_base{
			hp = 2153,
			mp = 4000,
			min_ac = 0,
			max_ac = 0,
			min_mac = 200,
			max_mac = 400,
			min_sc = 0,
			max_sc = 0,
			min_def = 35,
			max_def = 72,
			min_res = 66,
			max_res = 133,
			crit = 0,
			crit_att = 30,
			hit = 15,
			dodge = 15
		}
	};

get({2000, 54}) ->
	#player_attr_conf{
		career = 2000,
		lv = 54,
		attr_base = #attr_base{
			hp = 2237,
			mp = 4156,
			min_ac = 0,
			max_ac = 0,
			min_mac = 208,
			max_mac = 416,
			min_sc = 0,
			max_sc = 0,
			min_def = 37,
			max_def = 74,
			min_res = 68,
			max_res = 139,
			crit = 0,
			crit_att = 30,
			hit = 15,
			dodge = 15
		}
	};

get({2000, 55}) ->
	#player_attr_conf{
		career = 2000,
		lv = 55,
		attr_base = #attr_base{
			hp = 2321,
			mp = 4312,
			min_ac = 0,
			max_ac = 0,
			min_mac = 215,
			max_mac = 431,
			min_sc = 0,
			max_sc = 0,
			min_def = 38,
			max_def = 77,
			min_res = 71,
			max_res = 144,
			crit = 0,
			crit_att = 30,
			hit = 15,
			dodge = 15
		}
	};

get({2000, 56}) ->
	#player_attr_conf{
		career = 2000,
		lv = 56,
		attr_base = #attr_base{
			hp = 2405,
			mp = 4468,
			min_ac = 0,
			max_ac = 0,
			min_mac = 223,
			max_mac = 447,
			min_sc = 0,
			max_sc = 0,
			min_def = 39,
			max_def = 80,
			min_res = 74,
			max_res = 149,
			crit = 0,
			crit_att = 30,
			hit = 15,
			dodge = 15
		}
	};

get({2000, 57}) ->
	#player_attr_conf{
		career = 2000,
		lv = 57,
		attr_base = #attr_base{
			hp = 2489,
			mp = 4624,
			min_ac = 0,
			max_ac = 0,
			min_mac = 231,
			max_mac = 462,
			min_sc = 0,
			max_sc = 0,
			min_def = 41,
			max_def = 83,
			min_res = 76,
			max_res = 154,
			crit = 0,
			crit_att = 30,
			hit = 15,
			dodge = 15
		}
	};

get({2000, 58}) ->
	#player_attr_conf{
		career = 2000,
		lv = 58,
		attr_base = #attr_base{
			hp = 2573,
			mp = 4780,
			min_ac = 0,
			max_ac = 0,
			min_mac = 239,
			max_mac = 478,
			min_sc = 0,
			max_sc = 0,
			min_def = 42,
			max_def = 86,
			min_res = 79,
			max_res = 159,
			crit = 0,
			crit_att = 30,
			hit = 15,
			dodge = 15
		}
	};

get({2000, 59}) ->
	#player_attr_conf{
		career = 2000,
		lv = 59,
		attr_base = #attr_base{
			hp = 2657,
			mp = 4936,
			min_ac = 0,
			max_ac = 0,
			min_mac = 247,
			max_mac = 494,
			min_sc = 0,
			max_sc = 0,
			min_def = 44,
			max_def = 88,
			min_res = 81,
			max_res = 165,
			crit = 0,
			crit_att = 30,
			hit = 15,
			dodge = 15
		}
	};

get({2000, 60}) ->
	#player_attr_conf{
		career = 2000,
		lv = 60,
		attr_base = #attr_base{
			hp = 2752,
			mp = 5111,
			min_ac = 0,
			max_ac = 0,
			min_mac = 255,
			max_mac = 511,
			min_sc = 0,
			max_sc = 0,
			min_def = 45,
			max_def = 92,
			min_res = 84,
			max_res = 170,
			crit = 0,
			crit_att = 30,
			hit = 15,
			dodge = 15
		}
	};

get({2000, 61}) ->
	#player_attr_conf{
		career = 2000,
		lv = 61,
		attr_base = #attr_base{
			hp = 2846,
			mp = 5287,
			min_ac = 0,
			max_ac = 0,
			min_mac = 264,
			max_mac = 529,
			min_sc = 0,
			max_sc = 0,
			min_def = 47,
			max_def = 95,
			min_res = 87,
			max_res = 176,
			crit = 0,
			crit_att = 35,
			hit = 15,
			dodge = 15
		}
	};

get({2000, 62}) ->
	#player_attr_conf{
		career = 2000,
		lv = 62,
		attr_base = #attr_base{
			hp = 2941,
			mp = 5462,
			min_ac = 0,
			max_ac = 0,
			min_mac = 273,
			max_mac = 546,
			min_sc = 0,
			max_sc = 0,
			min_def = 48,
			max_def = 98,
			min_res = 90,
			max_res = 182,
			crit = 0,
			crit_att = 35,
			hit = 15,
			dodge = 15
		}
	};

get({2000, 63}) ->
	#player_attr_conf{
		career = 2000,
		lv = 63,
		attr_base = #attr_base{
			hp = 3035,
			mp = 5638,
			min_ac = 0,
			max_ac = 0,
			min_mac = 282,
			max_mac = 564,
			min_sc = 0,
			max_sc = 0,
			min_def = 50,
			max_def = 101,
			min_res = 93,
			max_res = 188,
			crit = 0,
			crit_att = 35,
			hit = 15,
			dodge = 15
		}
	};

get({2000, 64}) ->
	#player_attr_conf{
		career = 2000,
		lv = 64,
		attr_base = #attr_base{
			hp = 3130,
			mp = 5813,
			min_ac = 0,
			max_ac = 0,
			min_mac = 290,
			max_mac = 581,
			min_sc = 0,
			max_sc = 0,
			min_def = 51,
			max_def = 104,
			min_res = 96,
			max_res = 194,
			crit = 0,
			crit_att = 35,
			hit = 15,
			dodge = 15
		}
	};

get({2000, 65}) ->
	#player_attr_conf{
		career = 2000,
		lv = 65,
		attr_base = #attr_base{
			hp = 3224,
			mp = 5989,
			min_ac = 0,
			max_ac = 0,
			min_mac = 299,
			max_mac = 599,
			min_sc = 0,
			max_sc = 0,
			min_def = 53,
			max_def = 107,
			min_res = 99,
			max_res = 200,
			crit = 0,
			crit_att = 35,
			hit = 15,
			dodge = 15
		}
	};

get({2000, 66}) ->
	#player_attr_conf{
		career = 2000,
		lv = 66,
		attr_base = #attr_base{
			hp = 3319,
			mp = 6164,
			min_ac = 0,
			max_ac = 0,
			min_mac = 308,
			max_mac = 616,
			min_sc = 0,
			max_sc = 0,
			min_def = 55,
			max_def = 110,
			min_res = 102,
			max_res = 206,
			crit = 0,
			crit_att = 35,
			hit = 15,
			dodge = 15
		}
	};

get({2000, 67}) ->
	#player_attr_conf{
		career = 2000,
		lv = 67,
		attr_base = #attr_base{
			hp = 3413,
			mp = 6340,
			min_ac = 0,
			max_ac = 0,
			min_mac = 317,
			max_mac = 634,
			min_sc = 0,
			max_sc = 0,
			min_def = 56,
			max_def = 114,
			min_res = 105,
			max_res = 211,
			crit = 0,
			crit_att = 35,
			hit = 15,
			dodge = 15
		}
	};

get({2000, 68}) ->
	#player_attr_conf{
		career = 2000,
		lv = 68,
		attr_base = #attr_base{
			hp = 3508,
			mp = 6515,
			min_ac = 0,
			max_ac = 0,
			min_mac = 325,
			max_mac = 651,
			min_sc = 0,
			max_sc = 0,
			min_def = 58,
			max_def = 117,
			min_res = 108,
			max_res = 217,
			crit = 0,
			crit_att = 35,
			hit = 15,
			dodge = 15
		}
	};

get({2000, 69}) ->
	#player_attr_conf{
		career = 2000,
		lv = 69,
		attr_base = #attr_base{
			hp = 3602,
			mp = 6691,
			min_ac = 0,
			max_ac = 0,
			min_mac = 334,
			max_mac = 669,
			min_sc = 0,
			max_sc = 0,
			min_def = 59,
			max_def = 120,
			min_res = 111,
			max_res = 223,
			crit = 0,
			crit_att = 35,
			hit = 15,
			dodge = 15
		}
	};

get({2000, 70}) ->
	#player_attr_conf{
		career = 2000,
		lv = 70,
		attr_base = #attr_base{
			hp = 3707,
			mp = 6886,
			min_ac = 0,
			max_ac = 0,
			min_mac = 344,
			max_mac = 689,
			min_sc = 0,
			max_sc = 0,
			min_def = 61,
			max_def = 123,
			min_res = 114,
			max_res = 230,
			crit = 0,
			crit_att = 35,
			hit = 15,
			dodge = 15
		}
	};

get({2000, 71}) ->
	#player_attr_conf{
		career = 2000,
		lv = 71,
		attr_base = #attr_base{
			hp = 3812,
			mp = 7081,
			min_ac = 0,
			max_ac = 0,
			min_mac = 354,
			max_mac = 708,
			min_sc = 0,
			max_sc = 0,
			min_def = 63,
			max_def = 127,
			min_res = 117,
			max_res = 236,
			crit = 0,
			crit_att = 40,
			hit = 15,
			dodge = 15
		}
	};

get({2000, 72}) ->
	#player_attr_conf{
		career = 2000,
		lv = 72,
		attr_base = #attr_base{
			hp = 3917,
			mp = 7276,
			min_ac = 0,
			max_ac = 0,
			min_mac = 364,
			max_mac = 728,
			min_sc = 0,
			max_sc = 0,
			min_def = 65,
			max_def = 130,
			min_res = 120,
			max_res = 243,
			crit = 0,
			crit_att = 40,
			hit = 15,
			dodge = 15
		}
	};

get({2000, 73}) ->
	#player_attr_conf{
		career = 2000,
		lv = 73,
		attr_base = #attr_base{
			hp = 4022,
			mp = 7471,
			min_ac = 0,
			max_ac = 0,
			min_mac = 373,
			max_mac = 747,
			min_sc = 0,
			max_sc = 0,
			min_def = 66,
			max_def = 134,
			min_res = 124,
			max_res = 249,
			crit = 0,
			crit_att = 40,
			hit = 15,
			dodge = 15
		}
	};

get({2000, 74}) ->
	#player_attr_conf{
		career = 2000,
		lv = 74,
		attr_base = #attr_base{
			hp = 4127,
			mp = 7666,
			min_ac = 0,
			max_ac = 0,
			min_mac = 383,
			max_mac = 767,
			min_sc = 0,
			max_sc = 0,
			min_def = 68,
			max_def = 137,
			min_res = 127,
			max_res = 256,
			crit = 0,
			crit_att = 40,
			hit = 15,
			dodge = 15
		}
	};

get({2000, 75}) ->
	#player_attr_conf{
		career = 2000,
		lv = 75,
		attr_base = #attr_base{
			hp = 4232,
			mp = 7861,
			min_ac = 0,
			max_ac = 0,
			min_mac = 393,
			max_mac = 786,
			min_sc = 0,
			max_sc = 0,
			min_def = 70,
			max_def = 141,
			min_res = 130,
			max_res = 262,
			crit = 0,
			crit_att = 40,
			hit = 15,
			dodge = 15
		}
	};

get({2000, 76}) ->
	#player_attr_conf{
		career = 2000,
		lv = 76,
		attr_base = #attr_base{
			hp = 4337,
			mp = 8056,
			min_ac = 0,
			max_ac = 0,
			min_mac = 403,
			max_mac = 806,
			min_sc = 0,
			max_sc = 0,
			min_def = 72,
			max_def = 144,
			min_res = 133,
			max_res = 269,
			crit = 0,
			crit_att = 40,
			hit = 15,
			dodge = 15
		}
	};

get({2000, 77}) ->
	#player_attr_conf{
		career = 2000,
		lv = 77,
		attr_base = #attr_base{
			hp = 4442,
			mp = 8251,
			min_ac = 0,
			max_ac = 0,
			min_mac = 412,
			max_mac = 825,
			min_sc = 0,
			max_sc = 0,
			min_def = 73,
			max_def = 148,
			min_res = 137,
			max_res = 275,
			crit = 0,
			crit_att = 40,
			hit = 15,
			dodge = 15
		}
	};

get({2000, 78}) ->
	#player_attr_conf{
		career = 2000,
		lv = 78,
		attr_base = #attr_base{
			hp = 4547,
			mp = 8446,
			min_ac = 0,
			max_ac = 0,
			min_mac = 422,
			max_mac = 845,
			min_sc = 0,
			max_sc = 0,
			min_def = 75,
			max_def = 151,
			min_res = 140,
			max_res = 282,
			crit = 0,
			crit_att = 40,
			hit = 15,
			dodge = 15
		}
	};

get({2000, 79}) ->
	#player_attr_conf{
		career = 2000,
		lv = 79,
		attr_base = #attr_base{
			hp = 4652,
			mp = 8641,
			min_ac = 0,
			max_ac = 0,
			min_mac = 432,
			max_mac = 864,
			min_sc = 0,
			max_sc = 0,
			min_def = 77,
			max_def = 155,
			min_res = 143,
			max_res = 288,
			crit = 0,
			crit_att = 40,
			hit = 15,
			dodge = 15
		}
	};

get({2000, 80}) ->
	#player_attr_conf{
		career = 2000,
		lv = 80,
		attr_base = #attr_base{
			hp = 4764,
			mp = 8847,
			min_ac = 0,
			max_ac = 0,
			min_mac = 442,
			max_mac = 885,
			min_sc = 0,
			max_sc = 0,
			min_def = 79,
			max_def = 159,
			min_res = 147,
			max_res = 295,
			crit = 0,
			crit_att = 40,
			hit = 15,
			dodge = 15
		}
	};

get({2000, 81}) ->
	#player_attr_conf{
		career = 2000,
		lv = 81,
		attr_base = #attr_base{
			hp = 4875,
			mp = 9054,
			min_ac = 0,
			max_ac = 0,
			min_mac = 452,
			max_mac = 905,
			min_sc = 0,
			max_sc = 0,
			min_def = 81,
			max_def = 162,
			min_res = 150,
			max_res = 302,
			crit = 0,
			crit_att = 45,
			hit = 15,
			dodge = 15
		}
	};

get({2000, 82}) ->
	#player_attr_conf{
		career = 2000,
		lv = 82,
		attr_base = #attr_base{
			hp = 4986,
			mp = 9261,
			min_ac = 0,
			max_ac = 0,
			min_mac = 463,
			max_mac = 926,
			min_sc = 0,
			max_sc = 0,
			min_def = 82,
			max_def = 166,
			min_res = 153,
			max_res = 309,
			crit = 0,
			crit_att = 45,
			hit = 15,
			dodge = 15
		}
	};

get({2000, 83}) ->
	#player_attr_conf{
		career = 2000,
		lv = 83,
		attr_base = #attr_base{
			hp = 5098,
			mp = 9467,
			min_ac = 0,
			max_ac = 0,
			min_mac = 473,
			max_mac = 947,
			min_sc = 0,
			max_sc = 0,
			min_def = 84,
			max_def = 170,
			min_res = 157,
			max_res = 316,
			crit = 0,
			crit_att = 45,
			hit = 15,
			dodge = 15
		}
	};

get({2000, 84}) ->
	#player_attr_conf{
		career = 2000,
		lv = 84,
		attr_base = #attr_base{
			hp = 5209,
			mp = 9674,
			min_ac = 0,
			max_ac = 0,
			min_mac = 483,
			max_mac = 967,
			min_sc = 0,
			max_sc = 0,
			min_def = 86,
			max_def = 173,
			min_res = 160,
			max_res = 323,
			crit = 0,
			crit_att = 45,
			hit = 15,
			dodge = 15
		}
	};

get({2000, 85}) ->
	#player_attr_conf{
		career = 2000,
		lv = 85,
		attr_base = #attr_base{
			hp = 5320,
			mp = 9881,
			min_ac = 0,
			max_ac = 0,
			min_mac = 494,
			max_mac = 988,
			min_sc = 0,
			max_sc = 0,
			min_def = 88,
			max_def = 177,
			min_res = 164,
			max_res = 329,
			crit = 0,
			crit_att = 45,
			hit = 15,
			dodge = 15
		}
	};

get({2000, 86}) ->
	#player_attr_conf{
		career = 2000,
		lv = 86,
		attr_base = #attr_base{
			hp = 5432,
			mp = 10088,
			min_ac = 0,
			max_ac = 0,
			min_mac = 504,
			max_mac = 1009,
			min_sc = 0,
			max_sc = 0,
			min_def = 90,
			max_def = 181,
			min_res = 167,
			max_res = 336,
			crit = 0,
			crit_att = 45,
			hit = 15,
			dodge = 15
		}
	};

get({2000, 87}) ->
	#player_attr_conf{
		career = 2000,
		lv = 87,
		attr_base = #attr_base{
			hp = 5543,
			mp = 10294,
			min_ac = 0,
			max_ac = 0,
			min_mac = 514,
			max_mac = 1029,
			min_sc = 0,
			max_sc = 0,
			min_def = 92,
			max_def = 185,
			min_res = 171,
			max_res = 343,
			crit = 0,
			crit_att = 45,
			hit = 15,
			dodge = 15
		}
	};

get({2000, 88}) ->
	#player_attr_conf{
		career = 2000,
		lv = 88,
		attr_base = #attr_base{
			hp = 5654,
			mp = 10501,
			min_ac = 0,
			max_ac = 0,
			min_mac = 525,
			max_mac = 1050,
			min_sc = 0,
			max_sc = 0,
			min_def = 94,
			max_def = 188,
			min_res = 174,
			max_res = 350,
			crit = 0,
			crit_att = 45,
			hit = 15,
			dodge = 15
		}
	};

get({2000, 89}) ->
	#player_attr_conf{
		career = 2000,
		lv = 89,
		attr_base = #attr_base{
			hp = 5765,
			mp = 10708,
			min_ac = 0,
			max_ac = 0,
			min_mac = 535,
			max_mac = 1071,
			min_sc = 0,
			max_sc = 0,
			min_def = 95,
			max_def = 192,
			min_res = 178,
			max_res = 357,
			crit = 0,
			crit_att = 45,
			hit = 15,
			dodge = 15
		}
	};

get({2000, 90}) ->
	#player_attr_conf{
		career = 2000,
		lv = 90,
		attr_base = #attr_base{
			hp = 5883,
			mp = 10926,
			min_ac = 0,
			max_ac = 0,
			min_mac = 546,
			max_mac = 1093,
			min_sc = 0,
			max_sc = 0,
			min_def = 97,
			max_def = 196,
			min_res = 181,
			max_res = 364,
			crit = 0,
			crit_att = 45,
			hit = 15,
			dodge = 15
		}
	};

get({2000, 91}) ->
	#player_attr_conf{
		career = 2000,
		lv = 91,
		attr_base = #attr_base{
			hp = 6001,
			mp = 11144,
			min_ac = 0,
			max_ac = 0,
			min_mac = 557,
			max_mac = 1114,
			min_sc = 0,
			max_sc = 0,
			min_def = 99,
			max_def = 200,
			min_res = 185,
			max_res = 372,
			crit = 0,
			crit_att = 50,
			hit = 15,
			dodge = 15
		}
	};

get({2000, 92}) ->
	#player_attr_conf{
		career = 2000,
		lv = 92,
		attr_base = #attr_base{
			hp = 6118,
			mp = 11363,
			min_ac = 0,
			max_ac = 0,
			min_mac = 568,
			max_mac = 1136,
			min_sc = 0,
			max_sc = 0,
			min_def = 101,
			max_def = 204,
			min_res = 189,
			max_res = 379,
			crit = 0,
			crit_att = 50,
			hit = 15,
			dodge = 15
		}
	};

get({2000, 93}) ->
	#player_attr_conf{
		career = 2000,
		lv = 93,
		attr_base = #attr_base{
			hp = 6236,
			mp = 11581,
			min_ac = 0,
			max_ac = 0,
			min_mac = 579,
			max_mac = 1158,
			min_sc = 0,
			max_sc = 0,
			min_def = 103,
			max_def = 208,
			min_res = 192,
			max_res = 386,
			crit = 0,
			crit_att = 50,
			hit = 15,
			dodge = 15
		}
	};

get({2000, 94}) ->
	#player_attr_conf{
		career = 2000,
		lv = 94,
		attr_base = #attr_base{
			hp = 6353,
			mp = 11800,
			min_ac = 0,
			max_ac = 0,
			min_mac = 590,
			max_mac = 1180,
			min_sc = 0,
			max_sc = 0,
			min_def = 105,
			max_def = 212,
			min_res = 196,
			max_res = 393,
			crit = 0,
			crit_att = 50,
			hit = 15,
			dodge = 15
		}
	};

get({2000, 95}) ->
	#player_attr_conf{
		career = 2000,
		lv = 95,
		attr_base = #attr_base{
			hp = 6471,
			mp = 12018,
			min_ac = 0,
			max_ac = 0,
			min_mac = 601,
			max_mac = 1202,
			min_sc = 0,
			max_sc = 0,
			min_def = 107,
			max_def = 216,
			min_res = 199,
			max_res = 401,
			crit = 0,
			crit_att = 50,
			hit = 15,
			dodge = 15
		}
	};

get({2000, 96}) ->
	#player_attr_conf{
		career = 2000,
		lv = 96,
		attr_base = #attr_base{
			hp = 6589,
			mp = 12236,
			min_ac = 0,
			max_ac = 0,
			min_mac = 612,
			max_mac = 1224,
			min_sc = 0,
			max_sc = 0,
			min_def = 109,
			max_def = 219,
			min_res = 203,
			max_res = 408,
			crit = 0,
			crit_att = 50,
			hit = 15,
			dodge = 15
		}
	};

get({2000, 97}) ->
	#player_attr_conf{
		career = 2000,
		lv = 97,
		attr_base = #attr_base{
			hp = 6706,
			mp = 12455,
			min_ac = 0,
			max_ac = 0,
			min_mac = 622,
			max_mac = 1245,
			min_sc = 0,
			max_sc = 0,
			min_def = 111,
			max_def = 223,
			min_res = 207,
			max_res = 415,
			crit = 0,
			crit_att = 50,
			hit = 15,
			dodge = 15
		}
	};

get({2000, 98}) ->
	#player_attr_conf{
		career = 2000,
		lv = 98,
		attr_base = #attr_base{
			hp = 6824,
			mp = 12673,
			min_ac = 0,
			max_ac = 0,
			min_mac = 633,
			max_mac = 1267,
			min_sc = 0,
			max_sc = 0,
			min_def = 113,
			max_def = 227,
			min_res = 210,
			max_res = 423,
			crit = 0,
			crit_att = 50,
			hit = 15,
			dodge = 15
		}
	};

get({2000, 99}) ->
	#player_attr_conf{
		career = 2000,
		lv = 99,
		attr_base = #attr_base{
			hp = 6941,
			mp = 12892,
			min_ac = 0,
			max_ac = 0,
			min_mac = 644,
			max_mac = 1289,
			min_sc = 0,
			max_sc = 0,
			min_def = 115,
			max_def = 231,
			min_res = 214,
			max_res = 430,
			crit = 0,
			crit_att = 50,
			hit = 15,
			dodge = 15
		}
	};

get({2000, 100}) ->
	#player_attr_conf{
		career = 2000,
		lv = 100,
		attr_base = #attr_base{
			hp = 7067,
			mp = 13126,
			min_ac = 0,
			max_ac = 0,
			min_mac = 656,
			max_mac = 1313,
			min_sc = 0,
			max_sc = 0,
			min_def = 117,
			max_def = 235,
			min_res = 218,
			max_res = 438,
			crit = 0,
			crit_att = 50,
			hit = 15,
			dodge = 15
		}
	};

get({2000, 101}) ->
	#player_attr_conf{
		career = 2000,
		lv = 101,
		attr_base = #attr_base{
			hp = 7193,
			mp = 13360,
			min_ac = 0,
			max_ac = 0,
			min_mac = 668,
			max_mac = 1336,
			min_sc = 0,
			max_sc = 0,
			min_def = 119,
			max_def = 240,
			min_res = 222,
			max_res = 445,
			crit = 0,
			crit_att = 55,
			hit = 15,
			dodge = 15
		}
	};

get({2000, 102}) ->
	#player_attr_conf{
		career = 2000,
		lv = 102,
		attr_base = #attr_base{
			hp = 7319,
			mp = 13594,
			min_ac = 0,
			max_ac = 0,
			min_mac = 679,
			max_mac = 1359,
			min_sc = 0,
			max_sc = 0,
			min_def = 121,
			max_def = 244,
			min_res = 226,
			max_res = 453,
			crit = 0,
			crit_att = 55,
			hit = 15,
			dodge = 15
		}
	};

get({2000, 103}) ->
	#player_attr_conf{
		career = 2000,
		lv = 103,
		attr_base = #attr_base{
			hp = 7445,
			mp = 13828,
			min_ac = 0,
			max_ac = 0,
			min_mac = 691,
			max_mac = 1383,
			min_sc = 0,
			max_sc = 0,
			min_def = 123,
			max_def = 248,
			min_res = 230,
			max_res = 461,
			crit = 0,
			crit_att = 55,
			hit = 15,
			dodge = 15
		}
	};

get({2000, 104}) ->
	#player_attr_conf{
		career = 2000,
		lv = 104,
		attr_base = #attr_base{
			hp = 7571,
			mp = 14062,
			min_ac = 0,
			max_ac = 0,
			min_mac = 703,
			max_mac = 1406,
			min_sc = 0,
			max_sc = 0,
			min_def = 126,
			max_def = 252,
			min_res = 234,
			max_res = 469,
			crit = 0,
			crit_att = 55,
			hit = 15,
			dodge = 15
		}
	};

get({2000, 105}) ->
	#player_attr_conf{
		career = 2000,
		lv = 105,
		attr_base = #attr_base{
			hp = 7697,
			mp = 14296,
			min_ac = 0,
			max_ac = 0,
			min_mac = 715,
			max_mac = 1430,
			min_sc = 0,
			max_sc = 0,
			min_def = 128,
			max_def = 256,
			min_res = 237,
			max_res = 477,
			crit = 0,
			crit_att = 55,
			hit = 15,
			dodge = 15
		}
	};

get({2000, 106}) ->
	#player_attr_conf{
		career = 2000,
		lv = 106,
		attr_base = #attr_base{
			hp = 7823,
			mp = 14530,
			min_ac = 0,
			max_ac = 0,
			min_mac = 726,
			max_mac = 1453,
			min_sc = 0,
			max_sc = 0,
			min_def = 130,
			max_def = 261,
			min_res = 241,
			max_res = 484,
			crit = 0,
			crit_att = 55,
			hit = 15,
			dodge = 15
		}
	};

get({2000, 107}) ->
	#player_attr_conf{
		career = 2000,
		lv = 107,
		attr_base = #attr_base{
			hp = 7949,
			mp = 14764,
			min_ac = 0,
			max_ac = 0,
			min_mac = 738,
			max_mac = 1476,
			min_sc = 0,
			max_sc = 0,
			min_def = 132,
			max_def = 265,
			min_res = 245,
			max_res = 492,
			crit = 0,
			crit_att = 55,
			hit = 15,
			dodge = 15
		}
	};

get({2000, 108}) ->
	#player_attr_conf{
		career = 2000,
		lv = 108,
		attr_base = #attr_base{
			hp = 8075,
			mp = 14998,
			min_ac = 0,
			max_ac = 0,
			min_mac = 750,
			max_mac = 1500,
			min_sc = 0,
			max_sc = 0,
			min_def = 134,
			max_def = 269,
			min_res = 249,
			max_res = 500,
			crit = 0,
			crit_att = 55,
			hit = 15,
			dodge = 15
		}
	};

get({2000, 109}) ->
	#player_attr_conf{
		career = 2000,
		lv = 109,
		attr_base = #attr_base{
			hp = 8201,
			mp = 15232,
			min_ac = 0,
			max_ac = 0,
			min_mac = 761,
			max_mac = 1523,
			min_sc = 0,
			max_sc = 0,
			min_def = 136,
			max_def = 273,
			min_res = 253,
			max_res = 508,
			crit = 0,
			crit_att = 55,
			hit = 15,
			dodge = 15
		}
	};

get({2000, 110}) ->
	#player_attr_conf{
		career = 2000,
		lv = 110,
		attr_base = #attr_base{
			hp = 8336,
			mp = 15481,
			min_ac = 0,
			max_ac = 0,
			min_mac = 774,
			max_mac = 1548,
			min_sc = 0,
			max_sc = 0,
			min_def = 138,
			max_def = 278,
			min_res = 257,
			max_res = 516,
			crit = 0,
			crit_att = 55,
			hit = 15,
			dodge = 15
		}
	};

get({2000, 111}) ->
	#player_attr_conf{
		career = 2000,
		lv = 111,
		attr_base = #attr_base{
			hp = 8470,
			mp = 15731,
			min_ac = 0,
			max_ac = 0,
			min_mac = 786,
			max_mac = 1573,
			min_sc = 0,
			max_sc = 0,
			min_def = 140,
			max_def = 282,
			min_res = 261,
			max_res = 524,
			crit = 0,
			crit_att = 60,
			hit = 15,
			dodge = 15
		}
	};

get({2000, 112}) ->
	#player_attr_conf{
		career = 2000,
		lv = 112,
		attr_base = #attr_base{
			hp = 8605,
			mp = 15980,
			min_ac = 0,
			max_ac = 0,
			min_mac = 799,
			max_mac = 1598,
			min_sc = 0,
			max_sc = 0,
			min_def = 143,
			max_def = 287,
			min_res = 265,
			max_res = 533,
			crit = 0,
			crit_att = 60,
			hit = 15,
			dodge = 15
		}
	};

get({2000, 113}) ->
	#player_attr_conf{
		career = 2000,
		lv = 113,
		attr_base = #attr_base{
			hp = 8739,
			mp = 16230,
			min_ac = 0,
			max_ac = 0,
			min_mac = 811,
			max_mac = 1623,
			min_sc = 0,
			max_sc = 0,
			min_def = 145,
			max_def = 291,
			min_res = 270,
			max_res = 541,
			crit = 0,
			crit_att = 60,
			hit = 15,
			dodge = 15
		}
	};

get({2000, 114}) ->
	#player_attr_conf{
		career = 2000,
		lv = 114,
		attr_base = #attr_base{
			hp = 8873,
			mp = 16480,
			min_ac = 0,
			max_ac = 0,
			min_mac = 824,
			max_mac = 1648,
			min_sc = 0,
			max_sc = 0,
			min_def = 147,
			max_def = 296,
			min_res = 274,
			max_res = 549,
			crit = 0,
			crit_att = 60,
			hit = 15,
			dodge = 15
		}
	};

get({2000, 115}) ->
	#player_attr_conf{
		career = 2000,
		lv = 115,
		attr_base = #attr_base{
			hp = 9008,
			mp = 16729,
			min_ac = 0,
			max_ac = 0,
			min_mac = 836,
			max_mac = 1673,
			min_sc = 0,
			max_sc = 0,
			min_def = 149,
			max_def = 300,
			min_res = 278,
			max_res = 558,
			crit = 0,
			crit_att = 60,
			hit = 15,
			dodge = 15
		}
	};

get({2000, 116}) ->
	#player_attr_conf{
		career = 2000,
		lv = 116,
		attr_base = #attr_base{
			hp = 9142,
			mp = 16979,
			min_ac = 0,
			max_ac = 0,
			min_mac = 849,
			max_mac = 1698,
			min_sc = 0,
			max_sc = 0,
			min_def = 152,
			max_def = 305,
			min_res = 282,
			max_res = 566,
			crit = 0,
			crit_att = 60,
			hit = 15,
			dodge = 15
		}
	};

get({2000, 117}) ->
	#player_attr_conf{
		career = 2000,
		lv = 117,
		attr_base = #attr_base{
			hp = 9277,
			mp = 17228,
			min_ac = 0,
			max_ac = 0,
			min_mac = 861,
			max_mac = 1723,
			min_sc = 0,
			max_sc = 0,
			min_def = 154,
			max_def = 309,
			min_res = 286,
			max_res = 574,
			crit = 0,
			crit_att = 60,
			hit = 15,
			dodge = 15
		}
	};

get({2000, 118}) ->
	#player_attr_conf{
		career = 2000,
		lv = 118,
		attr_base = #attr_base{
			hp = 9411,
			mp = 17478,
			min_ac = 0,
			max_ac = 0,
			min_mac = 874,
			max_mac = 1748,
			min_sc = 0,
			max_sc = 0,
			min_def = 156,
			max_def = 314,
			min_res = 290,
			max_res = 583,
			crit = 0,
			crit_att = 60,
			hit = 15,
			dodge = 15
		}
	};

get({2000, 119}) ->
	#player_attr_conf{
		career = 2000,
		lv = 119,
		attr_base = #attr_base{
			hp = 9545,
			mp = 17728,
			min_ac = 0,
			max_ac = 0,
			min_mac = 886,
			max_mac = 1773,
			min_sc = 0,
			max_sc = 0,
			min_def = 158,
			max_def = 318,
			min_res = 295,
			max_res = 591,
			crit = 0,
			crit_att = 60,
			hit = 15,
			dodge = 15
		}
	};

get({2000, 120}) ->
	#player_attr_conf{
		career = 2000,
		lv = 120,
		attr_base = #attr_base{
			hp = 9688,
			mp = 17993,
			min_ac = 0,
			max_ac = 0,
			min_mac = 899,
			max_mac = 1799,
			min_sc = 0,
			max_sc = 0,
			min_def = 161,
			max_def = 323,
			min_res = 299,
			max_res = 600,
			crit = 0,
			crit_att = 60,
			hit = 15,
			dodge = 15
		}
	};

get({2000, 121}) ->
	#player_attr_conf{
		career = 2000,
		lv = 121,
		attr_base = #attr_base{
			hp = 9831,
			mp = 18258,
			min_ac = 0,
			max_ac = 0,
			min_mac = 913,
			max_mac = 1826,
			min_sc = 0,
			max_sc = 0,
			min_def = 163,
			max_def = 328,
			min_res = 303,
			max_res = 609,
			crit = 0,
			crit_att = 65,
			hit = 15,
			dodge = 15
		}
	};

get({2000, 122}) ->
	#player_attr_conf{
		career = 2000,
		lv = 122,
		attr_base = #attr_base{
			hp = 9974,
			mp = 18523,
			min_ac = 0,
			max_ac = 0,
			min_mac = 926,
			max_mac = 1852,
			min_sc = 0,
			max_sc = 0,
			min_def = 166,
			max_def = 332,
			min_res = 308,
			max_res = 618,
			crit = 0,
			crit_att = 65,
			hit = 15,
			dodge = 15
		}
	};

get({2000, 123}) ->
	#player_attr_conf{
		career = 2000,
		lv = 123,
		attr_base = #attr_base{
			hp = 10117,
			mp = 18788,
			min_ac = 0,
			max_ac = 0,
			min_mac = 939,
			max_mac = 1879,
			min_sc = 0,
			max_sc = 0,
			min_def = 168,
			max_def = 337,
			min_res = 312,
			max_res = 626,
			crit = 0,
			crit_att = 65,
			hit = 15,
			dodge = 15
		}
	};

get({2000, 124}) ->
	#player_attr_conf{
		career = 2000,
		lv = 124,
		attr_base = #attr_base{
			hp = 10259,
			mp = 19054,
			min_ac = 0,
			max_ac = 0,
			min_mac = 952,
			max_mac = 1905,
			min_sc = 0,
			max_sc = 0,
			min_def = 170,
			max_def = 342,
			min_res = 317,
			max_res = 635,
			crit = 0,
			crit_att = 65,
			hit = 15,
			dodge = 15
		}
	};

get({2000, 125}) ->
	#player_attr_conf{
		career = 2000,
		lv = 125,
		attr_base = #attr_base{
			hp = 10402,
			mp = 19319,
			min_ac = 0,
			max_ac = 0,
			min_mac = 966,
			max_mac = 1932,
			min_sc = 0,
			max_sc = 0,
			min_def = 173,
			max_def = 347,
			min_res = 321,
			max_res = 644,
			crit = 0,
			crit_att = 65,
			hit = 15,
			dodge = 15
		}
	};

get({2000, 126}) ->
	#player_attr_conf{
		career = 2000,
		lv = 126,
		attr_base = #attr_base{
			hp = 10545,
			mp = 19584,
			min_ac = 0,
			max_ac = 0,
			min_mac = 979,
			max_mac = 1958,
			min_sc = 0,
			max_sc = 0,
			min_def = 175,
			max_def = 351,
			min_res = 326,
			max_res = 653,
			crit = 0,
			crit_att = 65,
			hit = 15,
			dodge = 15
		}
	};

get({2000, 127}) ->
	#player_attr_conf{
		career = 2000,
		lv = 127,
		attr_base = #attr_base{
			hp = 10688,
			mp = 19849,
			min_ac = 0,
			max_ac = 0,
			min_mac = 992,
			max_mac = 1985,
			min_sc = 0,
			max_sc = 0,
			min_def = 177,
			max_def = 356,
			min_res = 330,
			max_res = 662,
			crit = 0,
			crit_att = 65,
			hit = 15,
			dodge = 15
		}
	};

get({2000, 128}) ->
	#player_attr_conf{
		career = 2000,
		lv = 128,
		attr_base = #attr_base{
			hp = 10831,
			mp = 20114,
			min_ac = 0,
			max_ac = 0,
			min_mac = 1005,
			max_mac = 2011,
			min_sc = 0,
			max_sc = 0,
			min_def = 180,
			max_def = 361,
			min_res = 334,
			max_res = 671,
			crit = 0,
			crit_att = 65,
			hit = 15,
			dodge = 15
		}
	};

get({2000, 129}) ->
	#player_attr_conf{
		career = 2000,
		lv = 129,
		attr_base = #attr_base{
			hp = 10973,
			mp = 20380,
			min_ac = 0,
			max_ac = 0,
			min_mac = 1019,
			max_mac = 2038,
			min_sc = 0,
			max_sc = 0,
			min_def = 182,
			max_def = 366,
			min_res = 339,
			max_res = 679,
			crit = 0,
			crit_att = 65,
			hit = 15,
			dodge = 15
		}
	};

get({2000, 130}) ->
	#player_attr_conf{
		career = 2000,
		lv = 130,
		attr_base = #attr_base{
			hp = 11125,
			mp = 20660,
			min_ac = 0,
			max_ac = 0,
			min_mac = 1033,
			max_mac = 2066,
			min_sc = 0,
			max_sc = 0,
			min_def = 185,
			max_def = 371,
			min_res = 343,
			max_res = 689,
			crit = 0,
			crit_att = 65,
			hit = 15,
			dodge = 15
		}
	};

get({3000, 1}) ->
	#player_attr_conf{
		career = 3000,
		lv = 1,
		attr_base = #attr_base{
			hp = 18,
			mp = 18,
			min_ac = 0,
			max_ac = 0,
			min_mac = 0,
			max_mac = 0,
			min_sc = 1,
			max_sc = 2,
			min_def = 0,
			max_def = 1,
			min_res = 0,
			max_res = 1,
			crit = 0,
			crit_att = 5,
			hit = 15,
			dodge = 15
		}
	};

get({3000, 2}) ->
	#player_attr_conf{
		career = 3000,
		lv = 2,
		attr_base = #attr_base{
			hp = 51,
			mp = 51,
			min_ac = 0,
			max_ac = 0,
			min_mac = 0,
			max_mac = 0,
			min_sc = 3,
			max_sc = 6,
			min_def = 0,
			max_def = 2,
			min_res = 0,
			max_res = 2,
			crit = 0,
			crit_att = 5,
			hit = 15,
			dodge = 15
		}
	};

get({3000, 3}) ->
	#player_attr_conf{
		career = 3000,
		lv = 3,
		attr_base = #attr_base{
			hp = 84,
			mp = 84,
			min_ac = 0,
			max_ac = 0,
			min_mac = 0,
			max_mac = 0,
			min_sc = 4,
			max_sc = 9,
			min_def = 1,
			max_def = 3,
			min_res = 1,
			max_res = 3,
			crit = 0,
			crit_att = 5,
			hit = 15,
			dodge = 15
		}
	};

get({3000, 4}) ->
	#player_attr_conf{
		career = 3000,
		lv = 4,
		attr_base = #attr_base{
			hp = 117,
			mp = 117,
			min_ac = 0,
			max_ac = 0,
			min_mac = 0,
			max_mac = 0,
			min_sc = 6,
			max_sc = 13,
			min_def = 1,
			max_def = 4,
			min_res = 1,
			max_res = 4,
			crit = 0,
			crit_att = 5,
			hit = 15,
			dodge = 15
		}
	};

get({3000, 5}) ->
	#player_attr_conf{
		career = 3000,
		lv = 5,
		attr_base = #attr_base{
			hp = 150,
			mp = 150,
			min_ac = 0,
			max_ac = 0,
			min_mac = 0,
			max_mac = 0,
			min_sc = 8,
			max_sc = 16,
			min_def = 2,
			max_def = 5,
			min_res = 2,
			max_res = 6,
			crit = 0,
			crit_att = 5,
			hit = 15,
			dodge = 15
		}
	};

get({3000, 6}) ->
	#player_attr_conf{
		career = 3000,
		lv = 6,
		attr_base = #attr_base{
			hp = 183,
			mp = 183,
			min_ac = 0,
			max_ac = 0,
			min_mac = 0,
			max_mac = 0,
			min_sc = 10,
			max_sc = 20,
			min_def = 2,
			max_def = 6,
			min_res = 3,
			max_res = 7,
			crit = 0,
			crit_att = 5,
			hit = 15,
			dodge = 15
		}
	};

get({3000, 7}) ->
	#player_attr_conf{
		career = 3000,
		lv = 7,
		attr_base = #attr_base{
			hp = 216,
			mp = 216,
			min_ac = 0,
			max_ac = 0,
			min_mac = 0,
			max_mac = 0,
			min_sc = 12,
			max_sc = 24,
			min_def = 3,
			max_def = 7,
			min_res = 3,
			max_res = 8,
			crit = 0,
			crit_att = 5,
			hit = 15,
			dodge = 15
		}
	};

get({3000, 8}) ->
	#player_attr_conf{
		career = 3000,
		lv = 8,
		attr_base = #attr_base{
			hp = 249,
			mp = 249,
			min_ac = 0,
			max_ac = 0,
			min_mac = 0,
			max_mac = 0,
			min_sc = 13,
			max_sc = 27,
			min_def = 3,
			max_def = 8,
			min_res = 4,
			max_res = 9,
			crit = 0,
			crit_att = 5,
			hit = 15,
			dodge = 15
		}
	};

get({3000, 9}) ->
	#player_attr_conf{
		career = 3000,
		lv = 9,
		attr_base = #attr_base{
			hp = 282,
			mp = 282,
			min_ac = 0,
			max_ac = 0,
			min_mac = 0,
			max_mac = 0,
			min_sc = 15,
			max_sc = 31,
			min_def = 4,
			max_def = 9,
			min_res = 4,
			max_res = 10,
			crit = 0,
			crit_att = 5,
			hit = 15,
			dodge = 15
		}
	};

get({3000, 10}) ->
	#player_attr_conf{
		career = 3000,
		lv = 10,
		attr_base = #attr_base{
			hp = 315,
			mp = 315,
			min_ac = 0,
			max_ac = 0,
			min_mac = 0,
			max_mac = 0,
			min_sc = 17,
			max_sc = 34,
			min_def = 4,
			max_def = 11,
			min_res = 5,
			max_res = 12,
			crit = 0,
			crit_att = 5,
			hit = 15,
			dodge = 15
		}
	};

get({3000, 11}) ->
	#player_attr_conf{
		career = 3000,
		lv = 11,
		attr_base = #attr_base{
			hp = 348,
			mp = 348,
			min_ac = 0,
			max_ac = 0,
			min_mac = 0,
			max_mac = 0,
			min_sc = 19,
			max_sc = 38,
			min_def = 5,
			max_def = 12,
			min_res = 6,
			max_res = 13,
			crit = 0,
			crit_att = 10,
			hit = 15,
			dodge = 15
		}
	};

get({3000, 12}) ->
	#player_attr_conf{
		career = 3000,
		lv = 12,
		attr_base = #attr_base{
			hp = 381,
			mp = 381,
			min_ac = 0,
			max_ac = 0,
			min_mac = 0,
			max_mac = 0,
			min_sc = 21,
			max_sc = 42,
			min_def = 6,
			max_def = 13,
			min_res = 6,
			max_res = 14,
			crit = 0,
			crit_att = 10,
			hit = 15,
			dodge = 15
		}
	};

get({3000, 13}) ->
	#player_attr_conf{
		career = 3000,
		lv = 13,
		attr_base = #attr_base{
			hp = 414,
			mp = 414,
			min_ac = 0,
			max_ac = 0,
			min_mac = 0,
			max_mac = 0,
			min_sc = 22,
			max_sc = 45,
			min_def = 6,
			max_def = 14,
			min_res = 7,
			max_res = 15,
			crit = 0,
			crit_att = 10,
			hit = 15,
			dodge = 15
		}
	};

get({3000, 14}) ->
	#player_attr_conf{
		career = 3000,
		lv = 14,
		attr_base = #attr_base{
			hp = 447,
			mp = 447,
			min_ac = 0,
			max_ac = 0,
			min_mac = 0,
			max_mac = 0,
			min_sc = 24,
			max_sc = 49,
			min_def = 7,
			max_def = 15,
			min_res = 7,
			max_res = 16,
			crit = 0,
			crit_att = 10,
			hit = 15,
			dodge = 15
		}
	};

get({3000, 15}) ->
	#player_attr_conf{
		career = 3000,
		lv = 15,
		attr_base = #attr_base{
			hp = 480,
			mp = 480,
			min_ac = 0,
			max_ac = 0,
			min_mac = 0,
			max_mac = 0,
			min_sc = 26,
			max_sc = 52,
			min_def = 7,
			max_def = 16,
			min_res = 8,
			max_res = 18,
			crit = 0,
			crit_att = 10,
			hit = 15,
			dodge = 15
		}
	};

get({3000, 16}) ->
	#player_attr_conf{
		career = 3000,
		lv = 16,
		attr_base = #attr_base{
			hp = 513,
			mp = 513,
			min_ac = 0,
			max_ac = 0,
			min_mac = 0,
			max_mac = 0,
			min_sc = 28,
			max_sc = 56,
			min_def = 8,
			max_def = 17,
			min_res = 9,
			max_res = 19,
			crit = 0,
			crit_att = 10,
			hit = 15,
			dodge = 15
		}
	};

get({3000, 17}) ->
	#player_attr_conf{
		career = 3000,
		lv = 17,
		attr_base = #attr_base{
			hp = 546,
			mp = 546,
			min_ac = 0,
			max_ac = 0,
			min_mac = 0,
			max_mac = 0,
			min_sc = 30,
			max_sc = 60,
			min_def = 8,
			max_def = 18,
			min_res = 9,
			max_res = 20,
			crit = 0,
			crit_att = 10,
			hit = 15,
			dodge = 15
		}
	};

get({3000, 18}) ->
	#player_attr_conf{
		career = 3000,
		lv = 18,
		attr_base = #attr_base{
			hp = 579,
			mp = 579,
			min_ac = 0,
			max_ac = 0,
			min_mac = 0,
			max_mac = 0,
			min_sc = 31,
			max_sc = 63,
			min_def = 9,
			max_def = 19,
			min_res = 10,
			max_res = 21,
			crit = 0,
			crit_att = 10,
			hit = 15,
			dodge = 15
		}
	};

get({3000, 19}) ->
	#player_attr_conf{
		career = 3000,
		lv = 19,
		attr_base = #attr_base{
			hp = 612,
			mp = 612,
			min_ac = 0,
			max_ac = 0,
			min_mac = 0,
			max_mac = 0,
			min_sc = 33,
			max_sc = 67,
			min_def = 9,
			max_def = 20,
			min_res = 10,
			max_res = 22,
			crit = 0,
			crit_att = 10,
			hit = 15,
			dodge = 15
		}
	};

get({3000, 20}) ->
	#player_attr_conf{
		career = 3000,
		lv = 20,
		attr_base = #attr_base{
			hp = 662,
			mp = 662,
			min_ac = 0,
			max_ac = 0,
			min_mac = 0,
			max_mac = 0,
			min_sc = 36,
			max_sc = 72,
			min_def = 10,
			max_def = 22,
			min_res = 11,
			max_res = 24,
			crit = 0,
			crit_att = 10,
			hit = 15,
			dodge = 15
		}
	};

get({3000, 21}) ->
	#player_attr_conf{
		career = 3000,
		lv = 21,
		attr_base = #attr_base{
			hp = 711,
			mp = 711,
			min_ac = 0,
			max_ac = 0,
			min_mac = 0,
			max_mac = 0,
			min_sc = 39,
			max_sc = 78,
			min_def = 11,
			max_def = 24,
			min_res = 12,
			max_res = 26,
			crit = 0,
			crit_att = 15,
			hit = 15,
			dodge = 15
		}
	};

get({3000, 22}) ->
	#player_attr_conf{
		career = 3000,
		lv = 22,
		attr_base = #attr_base{
			hp = 761,
			mp = 761,
			min_ac = 0,
			max_ac = 0,
			min_mac = 0,
			max_mac = 0,
			min_sc = 41,
			max_sc = 83,
			min_def = 12,
			max_def = 25,
			min_res = 13,
			max_res = 28,
			crit = 0,
			crit_att = 15,
			hit = 15,
			dodge = 15
		}
	};

get({3000, 23}) ->
	#player_attr_conf{
		career = 3000,
		lv = 23,
		attr_base = #attr_base{
			hp = 810,
			mp = 810,
			min_ac = 0,
			max_ac = 0,
			min_mac = 0,
			max_mac = 0,
			min_sc = 44,
			max_sc = 88,
			min_def = 13,
			max_def = 27,
			min_res = 14,
			max_res = 30,
			crit = 0,
			crit_att = 15,
			hit = 15,
			dodge = 15
		}
	};

get({3000, 24}) ->
	#player_attr_conf{
		career = 3000,
		lv = 24,
		attr_base = #attr_base{
			hp = 860,
			mp = 860,
			min_ac = 0,
			max_ac = 0,
			min_mac = 0,
			max_mac = 0,
			min_sc = 47,
			max_sc = 94,
			min_def = 14,
			max_def = 29,
			min_res = 15,
			max_res = 31,
			crit = 0,
			crit_att = 15,
			hit = 15,
			dodge = 15
		}
	};

get({3000, 25}) ->
	#player_attr_conf{
		career = 3000,
		lv = 25,
		attr_base = #attr_base{
			hp = 909,
			mp = 909,
			min_ac = 0,
			max_ac = 0,
			min_mac = 0,
			max_mac = 0,
			min_sc = 49,
			max_sc = 99,
			min_def = 14,
			max_def = 30,
			min_res = 16,
			max_res = 33,
			crit = 0,
			crit_att = 15,
			hit = 15,
			dodge = 15
		}
	};

get({3000, 26}) ->
	#player_attr_conf{
		career = 3000,
		lv = 26,
		attr_base = #attr_base{
			hp = 959,
			mp = 959,
			min_ac = 0,
			max_ac = 0,
			min_mac = 0,
			max_mac = 0,
			min_sc = 52,
			max_sc = 105,
			min_def = 15,
			max_def = 32,
			min_res = 17,
			max_res = 35,
			crit = 0,
			crit_att = 15,
			hit = 15,
			dodge = 15
		}
	};

get({3000, 27}) ->
	#player_attr_conf{
		career = 3000,
		lv = 27,
		attr_base = #attr_base{
			hp = 1008,
			mp = 1008,
			min_ac = 0,
			max_ac = 0,
			min_mac = 0,
			max_mac = 0,
			min_sc = 55,
			max_sc = 110,
			min_def = 16,
			max_def = 34,
			min_res = 18,
			max_res = 37,
			crit = 0,
			crit_att = 15,
			hit = 15,
			dodge = 15
		}
	};

get({3000, 28}) ->
	#player_attr_conf{
		career = 3000,
		lv = 28,
		attr_base = #attr_base{
			hp = 1058,
			mp = 1058,
			min_ac = 0,
			max_ac = 0,
			min_mac = 0,
			max_mac = 0,
			min_sc = 57,
			max_sc = 115,
			min_def = 17,
			max_def = 35,
			min_res = 18,
			max_res = 39,
			crit = 0,
			crit_att = 15,
			hit = 15,
			dodge = 15
		}
	};

get({3000, 29}) ->
	#player_attr_conf{
		career = 3000,
		lv = 29,
		attr_base = #attr_base{
			hp = 1107,
			mp = 1107,
			min_ac = 0,
			max_ac = 0,
			min_mac = 0,
			max_mac = 0,
			min_sc = 60,
			max_sc = 121,
			min_def = 18,
			max_def = 37,
			min_res = 19,
			max_res = 40,
			crit = 0,
			crit_att = 15,
			hit = 15,
			dodge = 15
		}
	};

get({3000, 30}) ->
	#player_attr_conf{
		career = 3000,
		lv = 30,
		attr_base = #attr_base{
			hp = 1183,
			mp = 1183,
			min_ac = 0,
			max_ac = 0,
			min_mac = 0,
			max_mac = 0,
			min_sc = 64,
			max_sc = 129,
			min_def = 19,
			max_def = 39,
			min_res = 21,
			max_res = 43,
			crit = 0,
			crit_att = 15,
			hit = 15,
			dodge = 15
		}
	};

get({3000, 31}) ->
	#player_attr_conf{
		career = 3000,
		lv = 31,
		attr_base = #attr_base{
			hp = 1259,
			mp = 1259,
			min_ac = 0,
			max_ac = 0,
			min_mac = 0,
			max_mac = 0,
			min_sc = 68,
			max_sc = 137,
			min_def = 20,
			max_def = 42,
			min_res = 22,
			max_res = 46,
			crit = 0,
			crit_att = 20,
			hit = 15,
			dodge = 15
		}
	};

get({3000, 32}) ->
	#player_attr_conf{
		career = 3000,
		lv = 32,
		attr_base = #attr_base{
			hp = 1335,
			mp = 1335,
			min_ac = 0,
			max_ac = 0,
			min_mac = 0,
			max_mac = 0,
			min_sc = 73,
			max_sc = 146,
			min_def = 21,
			max_def = 44,
			min_res = 23,
			max_res = 49,
			crit = 0,
			crit_att = 20,
			hit = 15,
			dodge = 15
		}
	};

get({3000, 33}) ->
	#player_attr_conf{
		career = 3000,
		lv = 33,
		attr_base = #attr_base{
			hp = 1411,
			mp = 1411,
			min_ac = 0,
			max_ac = 0,
			min_mac = 0,
			max_mac = 0,
			min_sc = 77,
			max_sc = 154,
			min_def = 23,
			max_def = 47,
			min_res = 25,
			max_res = 51,
			crit = 0,
			crit_att = 20,
			hit = 15,
			dodge = 15
		}
	};

get({3000, 34}) ->
	#player_attr_conf{
		career = 3000,
		lv = 34,
		attr_base = #attr_base{
			hp = 1487,
			mp = 1487,
			min_ac = 0,
			max_ac = 0,
			min_mac = 0,
			max_mac = 0,
			min_sc = 81,
			max_sc = 162,
			min_def = 24,
			max_def = 50,
			min_res = 26,
			max_res = 54,
			crit = 0,
			crit_att = 20,
			hit = 15,
			dodge = 15
		}
	};

get({3000, 35}) ->
	#player_attr_conf{
		career = 3000,
		lv = 35,
		attr_base = #attr_base{
			hp = 1563,
			mp = 1563,
			min_ac = 0,
			max_ac = 0,
			min_mac = 0,
			max_mac = 0,
			min_sc = 85,
			max_sc = 170,
			min_def = 25,
			max_def = 52,
			min_res = 28,
			max_res = 57,
			crit = 0,
			crit_att = 20,
			hit = 15,
			dodge = 15
		}
	};

get({3000, 36}) ->
	#player_attr_conf{
		career = 3000,
		lv = 36,
		attr_base = #attr_base{
			hp = 1639,
			mp = 1639,
			min_ac = 0,
			max_ac = 0,
			min_mac = 0,
			max_mac = 0,
			min_sc = 89,
			max_sc = 179,
			min_def = 27,
			max_def = 55,
			min_res = 29,
			max_res = 60,
			crit = 0,
			crit_att = 20,
			hit = 15,
			dodge = 15
		}
	};

get({3000, 37}) ->
	#player_attr_conf{
		career = 3000,
		lv = 37,
		attr_base = #attr_base{
			hp = 1714,
			mp = 1714,
			min_ac = 0,
			max_ac = 0,
			min_mac = 0,
			max_mac = 0,
			min_sc = 93,
			max_sc = 187,
			min_def = 28,
			max_def = 57,
			min_res = 30,
			max_res = 62,
			crit = 0,
			crit_att = 20,
			hit = 15,
			dodge = 15
		}
	};

get({3000, 38}) ->
	#player_attr_conf{
		career = 3000,
		lv = 38,
		attr_base = #attr_base{
			hp = 1790,
			mp = 1790,
			min_ac = 0,
			max_ac = 0,
			min_mac = 0,
			max_mac = 0,
			min_sc = 97,
			max_sc = 195,
			min_def = 29,
			max_def = 60,
			min_res = 32,
			max_res = 65,
			crit = 0,
			crit_att = 20,
			hit = 15,
			dodge = 15
		}
	};

get({3000, 39}) ->
	#player_attr_conf{
		career = 3000,
		lv = 39,
		attr_base = #attr_base{
			hp = 1866,
			mp = 1866,
			min_ac = 0,
			max_ac = 0,
			min_mac = 0,
			max_mac = 0,
			min_sc = 102,
			max_sc = 204,
			min_def = 30,
			max_def = 62,
			min_res = 33,
			max_res = 68,
			crit = 0,
			crit_att = 20,
			hit = 15,
			dodge = 15
		}
	};

get({3000, 40}) ->
	#player_attr_conf{
		career = 3000,
		lv = 40,
		attr_base = #attr_base{
			hp = 1965,
			mp = 1965,
			min_ac = 0,
			max_ac = 0,
			min_mac = 0,
			max_mac = 0,
			min_sc = 107,
			max_sc = 214,
			min_def = 32,
			max_def = 66,
			min_res = 35,
			max_res = 72,
			crit = 0,
			crit_att = 20,
			hit = 15,
			dodge = 15
		}
	};

get({3000, 41}) ->
	#player_attr_conf{
		career = 3000,
		lv = 41,
		attr_base = #attr_base{
			hp = 2064,
			mp = 2064,
			min_ac = 0,
			max_ac = 0,
			min_mac = 0,
			max_mac = 0,
			min_sc = 112,
			max_sc = 225,
			min_def = 34,
			max_def = 69,
			min_res = 37,
			max_res = 75,
			crit = 0,
			crit_att = 25,
			hit = 15,
			dodge = 15
		}
	};

get({3000, 42}) ->
	#player_attr_conf{
		career = 3000,
		lv = 42,
		attr_base = #attr_base{
			hp = 2163,
			mp = 2163,
			min_ac = 0,
			max_ac = 0,
			min_mac = 0,
			max_mac = 0,
			min_sc = 118,
			max_sc = 236,
			min_def = 35,
			max_def = 72,
			min_res = 39,
			max_res = 79,
			crit = 0,
			crit_att = 25,
			hit = 15,
			dodge = 15
		}
	};

get({3000, 43}) ->
	#player_attr_conf{
		career = 3000,
		lv = 43,
		attr_base = #attr_base{
			hp = 2262,
			mp = 2262,
			min_ac = 0,
			max_ac = 0,
			min_mac = 0,
			max_mac = 0,
			min_sc = 123,
			max_sc = 247,
			min_def = 37,
			max_def = 75,
			min_res = 40,
			max_res = 82,
			crit = 0,
			crit_att = 25,
			hit = 15,
			dodge = 15
		}
	};

get({3000, 44}) ->
	#player_attr_conf{
		career = 3000,
		lv = 44,
		attr_base = #attr_base{
			hp = 2361,
			mp = 2361,
			min_ac = 0,
			max_ac = 0,
			min_mac = 0,
			max_mac = 0,
			min_sc = 129,
			max_sc = 258,
			min_def = 39,
			max_def = 79,
			min_res = 42,
			max_res = 86,
			crit = 0,
			crit_att = 25,
			hit = 15,
			dodge = 15
		}
	};

get({3000, 45}) ->
	#player_attr_conf{
		career = 3000,
		lv = 45,
		attr_base = #attr_base{
			hp = 2460,
			mp = 2460,
			min_ac = 0,
			max_ac = 0,
			min_mac = 0,
			max_mac = 0,
			min_sc = 134,
			max_sc = 268,
			min_def = 40,
			max_def = 82,
			min_res = 44,
			max_res = 90,
			crit = 0,
			crit_att = 25,
			hit = 15,
			dodge = 15
		}
	};

get({3000, 46}) ->
	#player_attr_conf{
		career = 3000,
		lv = 46,
		attr_base = #attr_base{
			hp = 2559,
			mp = 2559,
			min_ac = 0,
			max_ac = 0,
			min_mac = 0,
			max_mac = 0,
			min_sc = 139,
			max_sc = 279,
			min_def = 42,
			max_def = 85,
			min_res = 46,
			max_res = 93,
			crit = 0,
			crit_att = 25,
			hit = 15,
			dodge = 15
		}
	};

get({3000, 47}) ->
	#player_attr_conf{
		career = 3000,
		lv = 47,
		attr_base = #attr_base{
			hp = 2658,
			mp = 2658,
			min_ac = 0,
			max_ac = 0,
			min_mac = 0,
			max_mac = 0,
			min_sc = 145,
			max_sc = 290,
			min_def = 44,
			max_def = 89,
			min_res = 48,
			max_res = 97,
			crit = 0,
			crit_att = 25,
			hit = 15,
			dodge = 15
		}
	};

get({3000, 48}) ->
	#player_attr_conf{
		career = 3000,
		lv = 48,
		attr_base = #attr_base{
			hp = 2757,
			mp = 2757,
			min_ac = 0,
			max_ac = 0,
			min_mac = 0,
			max_mac = 0,
			min_sc = 150,
			max_sc = 301,
			min_def = 45,
			max_def = 92,
			min_res = 49,
			max_res = 100,
			crit = 0,
			crit_att = 25,
			hit = 15,
			dodge = 15
		}
	};

get({3000, 49}) ->
	#player_attr_conf{
		career = 3000,
		lv = 49,
		attr_base = #attr_base{
			hp = 2856,
			mp = 2856,
			min_ac = 0,
			max_ac = 0,
			min_mac = 0,
			max_mac = 0,
			min_sc = 156,
			max_sc = 312,
			min_def = 47,
			max_def = 95,
			min_res = 51,
			max_res = 104,
			crit = 0,
			crit_att = 25,
			hit = 15,
			dodge = 15
		}
	};

get({3000, 50}) ->
	#player_attr_conf{
		career = 3000,
		lv = 50,
		attr_base = #attr_base{
			hp = 2988,
			mp = 2988,
			min_ac = 0,
			max_ac = 0,
			min_mac = 0,
			max_mac = 0,
			min_sc = 163,
			max_sc = 326,
			min_def = 49,
			max_def = 100,
			min_res = 54,
			max_res = 109,
			crit = 0,
			crit_att = 25,
			hit = 15,
			dodge = 15
		}
	};

get({3000, 51}) ->
	#player_attr_conf{
		career = 3000,
		lv = 51,
		attr_base = #attr_base{
			hp = 3120,
			mp = 3120,
			min_ac = 0,
			max_ac = 0,
			min_mac = 0,
			max_mac = 0,
			min_sc = 170,
			max_sc = 340,
			min_def = 51,
			max_def = 104,
			min_res = 56,
			max_res = 114,
			crit = 0,
			crit_att = 30,
			hit = 15,
			dodge = 15
		}
	};

get({3000, 52}) ->
	#player_attr_conf{
		career = 3000,
		lv = 52,
		attr_base = #attr_base{
			hp = 3252,
			mp = 3252,
			min_ac = 0,
			max_ac = 0,
			min_mac = 0,
			max_mac = 0,
			min_sc = 177,
			max_sc = 355,
			min_def = 53,
			max_def = 108,
			min_res = 58,
			max_res = 118,
			crit = 0,
			crit_att = 30,
			hit = 15,
			dodge = 15
		}
	};

get({3000, 53}) ->
	#player_attr_conf{
		career = 3000,
		lv = 53,
		attr_base = #attr_base{
			hp = 3384,
			mp = 3384,
			min_ac = 0,
			max_ac = 0,
			min_mac = 0,
			max_mac = 0,
			min_sc = 184,
			max_sc = 369,
			min_def = 56,
			max_def = 113,
			min_res = 61,
			max_res = 123,
			crit = 0,
			crit_att = 30,
			hit = 15,
			dodge = 15
		}
	};

get({3000, 54}) ->
	#player_attr_conf{
		career = 3000,
		lv = 54,
		attr_base = #attr_base{
			hp = 3516,
			mp = 3516,
			min_ac = 0,
			max_ac = 0,
			min_mac = 0,
			max_mac = 0,
			min_sc = 192,
			max_sc = 384,
			min_def = 58,
			max_def = 117,
			min_res = 63,
			max_res = 128,
			crit = 0,
			crit_att = 30,
			hit = 15,
			dodge = 15
		}
	};

get({3000, 55}) ->
	#player_attr_conf{
		career = 3000,
		lv = 55,
		attr_base = #attr_base{
			hp = 3648,
			mp = 3648,
			min_ac = 0,
			max_ac = 0,
			min_mac = 0,
			max_mac = 0,
			min_sc = 199,
			max_sc = 398,
			min_def = 60,
			max_def = 122,
			min_res = 66,
			max_res = 133,
			crit = 0,
			crit_att = 30,
			hit = 15,
			dodge = 15
		}
	};

get({3000, 56}) ->
	#player_attr_conf{
		career = 3000,
		lv = 56,
		attr_base = #attr_base{
			hp = 3780,
			mp = 3780,
			min_ac = 0,
			max_ac = 0,
			min_mac = 0,
			max_mac = 0,
			min_sc = 206,
			max_sc = 412,
			min_def = 62,
			max_def = 126,
			min_res = 68,
			max_res = 138,
			crit = 0,
			crit_att = 30,
			hit = 15,
			dodge = 15
		}
	};

get({3000, 57}) ->
	#player_attr_conf{
		career = 3000,
		lv = 57,
		attr_base = #attr_base{
			hp = 3912,
			mp = 3912,
			min_ac = 0,
			max_ac = 0,
			min_mac = 0,
			max_mac = 0,
			min_sc = 213,
			max_sc = 427,
			min_def = 64,
			max_def = 130,
			min_res = 70,
			max_res = 142,
			crit = 0,
			crit_att = 30,
			hit = 15,
			dodge = 15
		}
	};

get({3000, 58}) ->
	#player_attr_conf{
		career = 3000,
		lv = 58,
		attr_base = #attr_base{
			hp = 4044,
			mp = 4044,
			min_ac = 0,
			max_ac = 0,
			min_mac = 0,
			max_mac = 0,
			min_sc = 220,
			max_sc = 441,
			min_def = 67,
			max_def = 135,
			min_res = 73,
			max_res = 147,
			crit = 0,
			crit_att = 30,
			hit = 15,
			dodge = 15
		}
	};

get({3000, 59}) ->
	#player_attr_conf{
		career = 3000,
		lv = 59,
		attr_base = #attr_base{
			hp = 4176,
			mp = 4176,
			min_ac = 0,
			max_ac = 0,
			min_mac = 0,
			max_mac = 0,
			min_sc = 228,
			max_sc = 456,
			min_def = 69,
			max_def = 139,
			min_res = 75,
			max_res = 152,
			crit = 0,
			crit_att = 30,
			hit = 15,
			dodge = 15
		}
	};

get({3000, 60}) ->
	#player_attr_conf{
		career = 3000,
		lv = 60,
		attr_base = #attr_base{
			hp = 4325,
			mp = 4325,
			min_ac = 0,
			max_ac = 0,
			min_mac = 0,
			max_mac = 0,
			min_sc = 236,
			max_sc = 472,
			min_def = 71,
			max_def = 144,
			min_res = 78,
			max_res = 157,
			crit = 0,
			crit_att = 30,
			hit = 15,
			dodge = 15
		}
	};

get({3000, 61}) ->
	#player_attr_conf{
		career = 3000,
		lv = 61,
		attr_base = #attr_base{
			hp = 4473,
			mp = 4473,
			min_ac = 0,
			max_ac = 0,
			min_mac = 0,
			max_mac = 0,
			min_sc = 244,
			max_sc = 488,
			min_def = 74,
			max_def = 149,
			min_res = 81,
			max_res = 163,
			crit = 0,
			crit_att = 35,
			hit = 15,
			dodge = 15
		}
	};

get({3000, 62}) ->
	#player_attr_conf{
		career = 3000,
		lv = 62,
		attr_base = #attr_base{
			hp = 4622,
			mp = 4622,
			min_ac = 0,
			max_ac = 0,
			min_mac = 0,
			max_mac = 0,
			min_sc = 252,
			max_sc = 504,
			min_def = 76,
			max_def = 154,
			min_res = 83,
			max_res = 168,
			crit = 0,
			crit_att = 35,
			hit = 15,
			dodge = 15
		}
	};

get({3000, 63}) ->
	#player_attr_conf{
		career = 3000,
		lv = 63,
		attr_base = #attr_base{
			hp = 4770,
			mp = 4770,
			min_ac = 0,
			max_ac = 0,
			min_mac = 0,
			max_mac = 0,
			min_sc = 260,
			max_sc = 520,
			min_def = 79,
			max_def = 159,
			min_res = 86,
			max_res = 174,
			crit = 0,
			crit_att = 35,
			hit = 15,
			dodge = 15
		}
	};

get({3000, 64}) ->
	#player_attr_conf{
		career = 3000,
		lv = 64,
		attr_base = #attr_base{
			hp = 4919,
			mp = 4919,
			min_ac = 0,
			max_ac = 0,
			min_mac = 0,
			max_mac = 0,
			min_sc = 268,
			max_sc = 537,
			min_def = 81,
			max_def = 164,
			min_res = 89,
			max_res = 179,
			crit = 0,
			crit_att = 35,
			hit = 15,
			dodge = 15
		}
	};

get({3000, 65}) ->
	#player_attr_conf{
		career = 3000,
		lv = 65,
		attr_base = #attr_base{
			hp = 5067,
			mp = 5067,
			min_ac = 0,
			max_ac = 0,
			min_mac = 0,
			max_mac = 0,
			min_sc = 276,
			max_sc = 553,
			min_def = 84,
			max_def = 169,
			min_res = 91,
			max_res = 184,
			crit = 0,
			crit_att = 35,
			hit = 15,
			dodge = 15
		}
	};

get({3000, 66}) ->
	#player_attr_conf{
		career = 3000,
		lv = 66,
		attr_base = #attr_base{
			hp = 5216,
			mp = 5216,
			min_ac = 0,
			max_ac = 0,
			min_mac = 0,
			max_mac = 0,
			min_sc = 284,
			max_sc = 569,
			min_def = 86,
			max_def = 174,
			min_res = 94,
			max_res = 190,
			crit = 0,
			crit_att = 35,
			hit = 15,
			dodge = 15
		}
	};

get({3000, 67}) ->
	#player_attr_conf{
		career = 3000,
		lv = 67,
		attr_base = #attr_base{
			hp = 5364,
			mp = 5364,
			min_ac = 0,
			max_ac = 0,
			min_mac = 0,
			max_mac = 0,
			min_sc = 292,
			max_sc = 585,
			min_def = 89,
			max_def = 179,
			min_res = 97,
			max_res = 195,
			crit = 0,
			crit_att = 35,
			hit = 15,
			dodge = 15
		}
	};

get({3000, 68}) ->
	#player_attr_conf{
		career = 3000,
		lv = 68,
		attr_base = #attr_base{
			hp = 5513,
			mp = 5513,
			min_ac = 0,
			max_ac = 0,
			min_mac = 0,
			max_mac = 0,
			min_sc = 300,
			max_sc = 601,
			min_def = 91,
			max_def = 184,
			min_res = 99,
			max_res = 201,
			crit = 0,
			crit_att = 35,
			hit = 15,
			dodge = 15
		}
	};

get({3000, 69}) ->
	#player_attr_conf{
		career = 3000,
		lv = 69,
		attr_base = #attr_base{
			hp = 5661,
			mp = 5661,
			min_ac = 0,
			max_ac = 0,
			min_mac = 0,
			max_mac = 0,
			min_sc = 309,
			max_sc = 618,
			min_def = 94,
			max_def = 189,
			min_res = 102,
			max_res = 206,
			crit = 0,
			crit_att = 35,
			hit = 15,
			dodge = 15
		}
	};

get({3000, 70}) ->
	#player_attr_conf{
		career = 3000,
		lv = 70,
		attr_base = #attr_base{
			hp = 5826,
			mp = 5826,
			min_ac = 0,
			max_ac = 0,
			min_mac = 0,
			max_mac = 0,
			min_sc = 318,
			max_sc = 636,
			min_def = 96,
			max_def = 194,
			min_res = 105,
			max_res = 212,
			crit = 0,
			crit_att = 35,
			hit = 15,
			dodge = 15
		}
	};

get({3000, 71}) ->
	#player_attr_conf{
		career = 3000,
		lv = 71,
		attr_base = #attr_base{
			hp = 5991,
			mp = 5991,
			min_ac = 0,
			max_ac = 0,
			min_mac = 0,
			max_mac = 0,
			min_sc = 327,
			max_sc = 654,
			min_def = 99,
			max_def = 200,
			min_res = 108,
			max_res = 218,
			crit = 0,
			crit_att = 40,
			hit = 15,
			dodge = 15
		}
	};

get({3000, 72}) ->
	#player_attr_conf{
		career = 3000,
		lv = 72,
		attr_base = #attr_base{
			hp = 6156,
			mp = 6156,
			min_ac = 0,
			max_ac = 0,
			min_mac = 0,
			max_mac = 0,
			min_sc = 336,
			max_sc = 672,
			min_def = 102,
			max_def = 205,
			min_res = 111,
			max_res = 224,
			crit = 0,
			crit_att = 40,
			hit = 15,
			dodge = 15
		}
	};

get({3000, 73}) ->
	#player_attr_conf{
		career = 3000,
		lv = 73,
		attr_base = #attr_base{
			hp = 6321,
			mp = 6321,
			min_ac = 0,
			max_ac = 0,
			min_mac = 0,
			max_mac = 0,
			min_sc = 345,
			max_sc = 690,
			min_def = 105,
			max_def = 211,
			min_res = 114,
			max_res = 230,
			crit = 0,
			crit_att = 40,
			hit = 15,
			dodge = 15
		}
	};

get({3000, 74}) ->
	#player_attr_conf{
		career = 3000,
		lv = 74,
		attr_base = #attr_base{
			hp = 6486,
			mp = 6486,
			min_ac = 0,
			max_ac = 0,
			min_mac = 0,
			max_mac = 0,
			min_sc = 354,
			max_sc = 708,
			min_def = 107,
			max_def = 216,
			min_res = 117,
			max_res = 236,
			crit = 0,
			crit_att = 40,
			hit = 15,
			dodge = 15
		}
	};

get({3000, 75}) ->
	#player_attr_conf{
		career = 3000,
		lv = 75,
		attr_base = #attr_base{
			hp = 6651,
			mp = 6651,
			min_ac = 0,
			max_ac = 0,
			min_mac = 0,
			max_mac = 0,
			min_sc = 363,
			max_sc = 726,
			min_def = 110,
			max_def = 222,
			min_res = 120,
			max_res = 242,
			crit = 0,
			crit_att = 40,
			hit = 15,
			dodge = 15
		}
	};

get({3000, 76}) ->
	#player_attr_conf{
		career = 3000,
		lv = 76,
		attr_base = #attr_base{
			hp = 6816,
			mp = 6816,
			min_ac = 0,
			max_ac = 0,
			min_mac = 0,
			max_mac = 0,
			min_sc = 372,
			max_sc = 744,
			min_def = 113,
			max_def = 227,
			min_res = 123,
			max_res = 248,
			crit = 0,
			crit_att = 40,
			hit = 15,
			dodge = 15
		}
	};

get({3000, 77}) ->
	#player_attr_conf{
		career = 3000,
		lv = 77,
		attr_base = #attr_base{
			hp = 6981,
			mp = 6981,
			min_ac = 0,
			max_ac = 0,
			min_mac = 0,
			max_mac = 0,
			min_sc = 381,
			max_sc = 762,
			min_def = 116,
			max_def = 233,
			min_res = 126,
			max_res = 254,
			crit = 0,
			crit_att = 40,
			hit = 15,
			dodge = 15
		}
	};

get({3000, 78}) ->
	#player_attr_conf{
		career = 3000,
		lv = 78,
		attr_base = #attr_base{
			hp = 7146,
			mp = 7146,
			min_ac = 0,
			max_ac = 0,
			min_mac = 0,
			max_mac = 0,
			min_sc = 390,
			max_sc = 780,
			min_def = 118,
			max_def = 238,
			min_res = 129,
			max_res = 260,
			crit = 0,
			crit_att = 40,
			hit = 15,
			dodge = 15
		}
	};

get({3000, 79}) ->
	#player_attr_conf{
		career = 3000,
		lv = 79,
		attr_base = #attr_base{
			hp = 7311,
			mp = 7311,
			min_ac = 0,
			max_ac = 0,
			min_mac = 0,
			max_mac = 0,
			min_sc = 399,
			max_sc = 798,
			min_def = 121,
			max_def = 244,
			min_res = 132,
			max_res = 266,
			crit = 0,
			crit_att = 40,
			hit = 15,
			dodge = 15
		}
	};

get({3000, 80}) ->
	#player_attr_conf{
		career = 3000,
		lv = 80,
		attr_base = #attr_base{
			hp = 7486,
			mp = 7486,
			min_ac = 0,
			max_ac = 0,
			min_mac = 0,
			max_mac = 0,
			min_sc = 408,
			max_sc = 817,
			min_def = 124,
			max_def = 250,
			min_res = 135,
			max_res = 272,
			crit = 0,
			crit_att = 40,
			hit = 15,
			dodge = 15
		}
	};

get({3000, 81}) ->
	#player_attr_conf{
		career = 3000,
		lv = 81,
		attr_base = #attr_base{
			hp = 7661,
			mp = 7661,
			min_ac = 0,
			max_ac = 0,
			min_mac = 0,
			max_mac = 0,
			min_sc = 418,
			max_sc = 836,
			min_def = 127,
			max_def = 255,
			min_res = 138,
			max_res = 279,
			crit = 0,
			crit_att = 45,
			hit = 15,
			dodge = 15
		}
	};

get({3000, 82}) ->
	#player_attr_conf{
		career = 3000,
		lv = 82,
		attr_base = #attr_base{
			hp = 7836,
			mp = 7836,
			min_ac = 0,
			max_ac = 0,
			min_mac = 0,
			max_mac = 0,
			min_sc = 427,
			max_sc = 855,
			min_def = 130,
			max_def = 261,
			min_res = 142,
			max_res = 285,
			crit = 0,
			crit_att = 45,
			hit = 15,
			dodge = 15
		}
	};

get({3000, 83}) ->
	#player_attr_conf{
		career = 3000,
		lv = 83,
		attr_base = #attr_base{
			hp = 8011,
			mp = 8011,
			min_ac = 0,
			max_ac = 0,
			min_mac = 0,
			max_mac = 0,
			min_sc = 437,
			max_sc = 874,
			min_def = 133,
			max_def = 267,
			min_res = 145,
			max_res = 291,
			crit = 0,
			crit_att = 45,
			hit = 15,
			dodge = 15
		}
	};

get({3000, 84}) ->
	#player_attr_conf{
		career = 3000,
		lv = 84,
		attr_base = #attr_base{
			hp = 8186,
			mp = 8186,
			min_ac = 0,
			max_ac = 0,
			min_mac = 0,
			max_mac = 0,
			min_sc = 446,
			max_sc = 893,
			min_def = 136,
			max_def = 273,
			min_res = 148,
			max_res = 298,
			crit = 0,
			crit_att = 45,
			hit = 15,
			dodge = 15
		}
	};

get({3000, 85}) ->
	#player_attr_conf{
		career = 3000,
		lv = 85,
		attr_base = #attr_base{
			hp = 8361,
			mp = 8361,
			min_ac = 0,
			max_ac = 0,
			min_mac = 0,
			max_mac = 0,
			min_sc = 456,
			max_sc = 912,
			min_def = 139,
			max_def = 279,
			min_res = 151,
			max_res = 304,
			crit = 0,
			crit_att = 45,
			hit = 15,
			dodge = 15
		}
	};

get({3000, 86}) ->
	#player_attr_conf{
		career = 3000,
		lv = 86,
		attr_base = #attr_base{
			hp = 8536,
			mp = 8536,
			min_ac = 0,
			max_ac = 0,
			min_mac = 0,
			max_mac = 0,
			min_sc = 465,
			max_sc = 931,
			min_def = 141,
			max_def = 285,
			min_res = 154,
			max_res = 310,
			crit = 0,
			crit_att = 45,
			hit = 15,
			dodge = 15
		}
	};

get({3000, 87}) ->
	#player_attr_conf{
		career = 3000,
		lv = 87,
		attr_base = #attr_base{
			hp = 8710,
			mp = 8710,
			min_ac = 0,
			max_ac = 0,
			min_mac = 0,
			max_mac = 0,
			min_sc = 475,
			max_sc = 950,
			min_def = 144,
			max_def = 290,
			min_res = 158,
			max_res = 317,
			crit = 0,
			crit_att = 45,
			hit = 15,
			dodge = 15
		}
	};

get({3000, 88}) ->
	#player_attr_conf{
		career = 3000,
		lv = 88,
		attr_base = #attr_base{
			hp = 8885,
			mp = 8885,
			min_ac = 0,
			max_ac = 0,
			min_mac = 0,
			max_mac = 0,
			min_sc = 484,
			max_sc = 969,
			min_def = 147,
			max_def = 296,
			min_res = 161,
			max_res = 323,
			crit = 0,
			crit_att = 45,
			hit = 15,
			dodge = 15
		}
	};

get({3000, 89}) ->
	#player_attr_conf{
		career = 3000,
		lv = 89,
		attr_base = #attr_base{
			hp = 9060,
			mp = 9060,
			min_ac = 0,
			max_ac = 0,
			min_mac = 0,
			max_mac = 0,
			min_sc = 494,
			max_sc = 988,
			min_def = 150,
			max_def = 302,
			min_res = 164,
			max_res = 330,
			crit = 0,
			crit_att = 45,
			hit = 15,
			dodge = 15
		}
	};

get({3000, 90}) ->
	#player_attr_conf{
		career = 3000,
		lv = 90,
		attr_base = #attr_base{
			hp = 9245,
			mp = 9245,
			min_ac = 0,
			max_ac = 0,
			min_mac = 0,
			max_mac = 0,
			min_sc = 504,
			max_sc = 1008,
			min_def = 153,
			max_def = 308,
			min_res = 167,
			max_res = 336,
			crit = 0,
			crit_att = 45,
			hit = 15,
			dodge = 15
		}
	};

get({3000, 91}) ->
	#player_attr_conf{
		career = 3000,
		lv = 91,
		attr_base = #attr_base{
			hp = 9430,
			mp = 9430,
			min_ac = 0,
			max_ac = 0,
			min_mac = 0,
			max_mac = 0,
			min_sc = 514,
			max_sc = 1029,
			min_def = 156,
			max_def = 314,
			min_res = 171,
			max_res = 343,
			crit = 0,
			crit_att = 50,
			hit = 15,
			dodge = 15
		}
	};

get({3000, 92}) ->
	#player_attr_conf{
		career = 3000,
		lv = 92,
		attr_base = #attr_base{
			hp = 9615,
			mp = 9615,
			min_ac = 0,
			max_ac = 0,
			min_mac = 0,
			max_mac = 0,
			min_sc = 524,
			max_sc = 1049,
			min_def = 159,
			max_def = 320,
			min_res = 174,
			max_res = 350,
			crit = 0,
			crit_att = 50,
			hit = 15,
			dodge = 15
		}
	};

get({3000, 93}) ->
	#player_attr_conf{
		career = 3000,
		lv = 93,
		attr_base = #attr_base{
			hp = 9799,
			mp = 9799,
			min_ac = 0,
			max_ac = 0,
			min_mac = 0,
			max_mac = 0,
			min_sc = 534,
			max_sc = 1069,
			min_def = 163,
			max_def = 327,
			min_res = 177,
			max_res = 356,
			crit = 0,
			crit_att = 50,
			hit = 15,
			dodge = 15
		}
	};

get({3000, 94}) ->
	#player_attr_conf{
		career = 3000,
		lv = 94,
		attr_base = #attr_base{
			hp = 9984,
			mp = 9984,
			min_ac = 0,
			max_ac = 0,
			min_mac = 0,
			max_mac = 0,
			min_sc = 544,
			max_sc = 1089,
			min_def = 166,
			max_def = 333,
			min_res = 181,
			max_res = 363,
			crit = 0,
			crit_att = 50,
			hit = 15,
			dodge = 15
		}
	};

get({3000, 95}) ->
	#player_attr_conf{
		career = 3000,
		lv = 95,
		attr_base = #attr_base{
			hp = 10169,
			mp = 10169,
			min_ac = 0,
			max_ac = 0,
			min_mac = 0,
			max_mac = 0,
			min_sc = 554,
			max_sc = 1109,
			min_def = 169,
			max_def = 339,
			min_res = 184,
			max_res = 370,
			crit = 0,
			crit_att = 50,
			hit = 15,
			dodge = 15
		}
	};

get({3000, 96}) ->
	#player_attr_conf{
		career = 3000,
		lv = 96,
		attr_base = #attr_base{
			hp = 10354,
			mp = 10354,
			min_ac = 0,
			max_ac = 0,
			min_mac = 0,
			max_mac = 0,
			min_sc = 564,
			max_sc = 1129,
			min_def = 172,
			max_def = 345,
			min_res = 187,
			max_res = 377,
			crit = 0,
			crit_att = 50,
			hit = 15,
			dodge = 15
		}
	};

get({3000, 97}) ->
	#player_attr_conf{
		career = 3000,
		lv = 97,
		attr_base = #attr_base{
			hp = 10539,
			mp = 10539,
			min_ac = 0,
			max_ac = 0,
			min_mac = 0,
			max_mac = 0,
			min_sc = 575,
			max_sc = 1150,
			min_def = 175,
			max_def = 351,
			min_res = 191,
			max_res = 383,
			crit = 0,
			crit_att = 50,
			hit = 15,
			dodge = 15
		}
	};

get({3000, 98}) ->
	#player_attr_conf{
		career = 3000,
		lv = 98,
		attr_base = #attr_base{
			hp = 10723,
			mp = 10723,
			min_ac = 0,
			max_ac = 0,
			min_mac = 0,
			max_mac = 0,
			min_sc = 585,
			max_sc = 1170,
			min_def = 178,
			max_def = 357,
			min_res = 194,
			max_res = 390,
			crit = 0,
			crit_att = 50,
			hit = 15,
			dodge = 15
		}
	};

get({3000, 99}) ->
	#player_attr_conf{
		career = 3000,
		lv = 99,
		attr_base = #attr_base{
			hp = 10908,
			mp = 10908,
			min_ac = 0,
			max_ac = 0,
			min_mac = 0,
			max_mac = 0,
			min_sc = 595,
			max_sc = 1190,
			min_def = 181,
			max_def = 364,
			min_res = 198,
			max_res = 397,
			crit = 0,
			crit_att = 50,
			hit = 15,
			dodge = 15
		}
	};

get({3000, 100}) ->
	#player_attr_conf{
		career = 3000,
		lv = 100,
		attr_base = #attr_base{
			hp = 11106,
			mp = 11106,
			min_ac = 0,
			max_ac = 0,
			min_mac = 0,
			max_mac = 0,
			min_sc = 606,
			max_sc = 1212,
			min_def = 184,
			max_def = 370,
			min_res = 201,
			max_res = 404,
			crit = 0,
			crit_att = 50,
			hit = 15,
			dodge = 15
		}
	};

get({3000, 101}) ->
	#player_attr_conf{
		career = 3000,
		lv = 101,
		attr_base = #attr_base{
			hp = 11304,
			mp = 11304,
			min_ac = 0,
			max_ac = 0,
			min_mac = 0,
			max_mac = 0,
			min_sc = 616,
			max_sc = 1233,
			min_def = 188,
			max_def = 377,
			min_res = 205,
			max_res = 411,
			crit = 0,
			crit_att = 55,
			hit = 15,
			dodge = 15
		}
	};

get({3000, 102}) ->
	#player_attr_conf{
		career = 3000,
		lv = 102,
		attr_base = #attr_base{
			hp = 11502,
			mp = 11502,
			min_ac = 0,
			max_ac = 0,
			min_mac = 0,
			max_mac = 0,
			min_sc = 627,
			max_sc = 1255,
			min_def = 191,
			max_def = 383,
			min_res = 208,
			max_res = 418,
			crit = 0,
			crit_att = 55,
			hit = 15,
			dodge = 15
		}
	};

get({3000, 103}) ->
	#player_attr_conf{
		career = 3000,
		lv = 103,
		attr_base = #attr_base{
			hp = 11700,
			mp = 11700,
			min_ac = 0,
			max_ac = 0,
			min_mac = 0,
			max_mac = 0,
			min_sc = 638,
			max_sc = 1276,
			min_def = 194,
			max_def = 390,
			min_res = 212,
			max_res = 426,
			crit = 0,
			crit_att = 55,
			hit = 15,
			dodge = 15
		}
	};

get({3000, 104}) ->
	#player_attr_conf{
		career = 3000,
		lv = 104,
		attr_base = #attr_base{
			hp = 11898,
			mp = 11898,
			min_ac = 0,
			max_ac = 0,
			min_mac = 0,
			max_mac = 0,
			min_sc = 649,
			max_sc = 1298,
			min_def = 198,
			max_def = 397,
			min_res = 216,
			max_res = 433,
			crit = 0,
			crit_att = 55,
			hit = 15,
			dodge = 15
		}
	};

get({3000, 105}) ->
	#player_attr_conf{
		career = 3000,
		lv = 105,
		attr_base = #attr_base{
			hp = 12096,
			mp = 12096,
			min_ac = 0,
			max_ac = 0,
			min_mac = 0,
			max_mac = 0,
			min_sc = 660,
			max_sc = 1320,
			min_def = 201,
			max_def = 403,
			min_res = 219,
			max_res = 440,
			crit = 0,
			crit_att = 55,
			hit = 15,
			dodge = 15
		}
	};

get({3000, 106}) ->
	#player_attr_conf{
		career = 3000,
		lv = 106,
		attr_base = #attr_base{
			hp = 12294,
			mp = 12294,
			min_ac = 0,
			max_ac = 0,
			min_mac = 0,
			max_mac = 0,
			min_sc = 670,
			max_sc = 1341,
			min_def = 204,
			max_def = 410,
			min_res = 223,
			max_res = 447,
			crit = 0,
			crit_att = 55,
			hit = 15,
			dodge = 15
		}
	};

get({3000, 107}) ->
	#player_attr_conf{
		career = 3000,
		lv = 107,
		attr_base = #attr_base{
			hp = 12492,
			mp = 12492,
			min_ac = 0,
			max_ac = 0,
			min_mac = 0,
			max_mac = 0,
			min_sc = 681,
			max_sc = 1363,
			min_def = 207,
			max_def = 416,
			min_res = 226,
			max_res = 454,
			crit = 0,
			crit_att = 55,
			hit = 15,
			dodge = 15
		}
	};

get({3000, 108}) ->
	#player_attr_conf{
		career = 3000,
		lv = 108,
		attr_base = #attr_base{
			hp = 12690,
			mp = 12690,
			min_ac = 0,
			max_ac = 0,
			min_mac = 0,
			max_mac = 0,
			min_sc = 692,
			max_sc = 1384,
			min_def = 211,
			max_def = 423,
			min_res = 230,
			max_res = 462,
			crit = 0,
			crit_att = 55,
			hit = 15,
			dodge = 15
		}
	};

get({3000, 109}) ->
	#player_attr_conf{
		career = 3000,
		lv = 109,
		attr_base = #attr_base{
			hp = 12888,
			mp = 12888,
			min_ac = 0,
			max_ac = 0,
			min_mac = 0,
			max_mac = 0,
			min_sc = 703,
			max_sc = 1406,
			min_def = 214,
			max_def = 430,
			min_res = 234,
			max_res = 469,
			crit = 0,
			crit_att = 55,
			hit = 15,
			dodge = 15
		}
	};

get({3000, 110}) ->
	#player_attr_conf{
		career = 3000,
		lv = 110,
		attr_base = #attr_base{
			hp = 13099,
			mp = 13099,
			min_ac = 0,
			max_ac = 0,
			min_mac = 0,
			max_mac = 0,
			min_sc = 714,
			max_sc = 1429,
			min_def = 218,
			max_def = 437,
			min_res = 237,
			max_res = 476,
			crit = 0,
			crit_att = 55,
			hit = 15,
			dodge = 15
		}
	};

get({3000, 111}) ->
	#player_attr_conf{
		career = 3000,
		lv = 111,
		attr_base = #attr_base{
			hp = 13311,
			mp = 13311,
			min_ac = 0,
			max_ac = 0,
			min_mac = 0,
			max_mac = 0,
			min_sc = 726,
			max_sc = 1452,
			min_def = 221,
			max_def = 444,
			min_res = 241,
			max_res = 484,
			crit = 0,
			crit_att = 60,
			hit = 15,
			dodge = 15
		}
	};

get({3000, 112}) ->
	#player_attr_conf{
		career = 3000,
		lv = 112,
		attr_base = #attr_base{
			hp = 13522,
			mp = 13522,
			min_ac = 0,
			max_ac = 0,
			min_mac = 0,
			max_mac = 0,
			min_sc = 737,
			max_sc = 1475,
			min_def = 225,
			max_def = 451,
			min_res = 245,
			max_res = 492,
			crit = 0,
			crit_att = 60,
			hit = 15,
			dodge = 15
		}
	};

get({3000, 113}) ->
	#player_attr_conf{
		career = 3000,
		lv = 113,
		attr_base = #attr_base{
			hp = 13733,
			mp = 13733,
			min_ac = 0,
			max_ac = 0,
			min_mac = 0,
			max_mac = 0,
			min_sc = 749,
			max_sc = 1498,
			min_def = 228,
			max_def = 458,
			min_res = 249,
			max_res = 499,
			crit = 0,
			crit_att = 60,
			hit = 15,
			dodge = 15
		}
	};

get({3000, 114}) ->
	#player_attr_conf{
		career = 3000,
		lv = 114,
		attr_base = #attr_base{
			hp = 13944,
			mp = 13944,
			min_ac = 0,
			max_ac = 0,
			min_mac = 0,
			max_mac = 0,
			min_sc = 760,
			max_sc = 1521,
			min_def = 232,
			max_def = 465,
			min_res = 253,
			max_res = 507,
			crit = 0,
			crit_att = 60,
			hit = 15,
			dodge = 15
		}
	};

get({3000, 115}) ->
	#player_attr_conf{
		career = 3000,
		lv = 115,
		attr_base = #attr_base{
			hp = 14155,
			mp = 14155,
			min_ac = 0,
			max_ac = 0,
			min_mac = 0,
			max_mac = 0,
			min_sc = 772,
			max_sc = 1544,
			min_def = 235,
			max_def = 472,
			min_res = 257,
			max_res = 515,
			crit = 0,
			crit_att = 60,
			hit = 15,
			dodge = 15
		}
	};

get({3000, 116}) ->
	#player_attr_conf{
		career = 3000,
		lv = 116,
		attr_base = #attr_base{
			hp = 14367,
			mp = 14367,
			min_ac = 0,
			max_ac = 0,
			min_mac = 0,
			max_mac = 0,
			min_sc = 783,
			max_sc = 1567,
			min_def = 239,
			max_def = 479,
			min_res = 260,
			max_res = 522,
			crit = 0,
			crit_att = 60,
			hit = 15,
			dodge = 15
		}
	};

get({3000, 117}) ->
	#player_attr_conf{
		career = 3000,
		lv = 117,
		attr_base = #attr_base{
			hp = 14578,
			mp = 14578,
			min_ac = 0,
			max_ac = 0,
			min_mac = 0,
			max_mac = 0,
			min_sc = 795,
			max_sc = 1590,
			min_def = 242,
			max_def = 486,
			min_res = 264,
			max_res = 530,
			crit = 0,
			crit_att = 60,
			hit = 15,
			dodge = 15
		}
	};

get({3000, 118}) ->
	#player_attr_conf{
		career = 3000,
		lv = 118,
		attr_base = #attr_base{
			hp = 14789,
			mp = 14789,
			min_ac = 0,
			max_ac = 0,
			min_mac = 0,
			max_mac = 0,
			min_sc = 806,
			max_sc = 1613,
			min_def = 246,
			max_def = 493,
			min_res = 268,
			max_res = 538,
			crit = 0,
			crit_att = 60,
			hit = 15,
			dodge = 15
		}
	};

get({3000, 119}) ->
	#player_attr_conf{
		career = 3000,
		lv = 119,
		attr_base = #attr_base{
			hp = 15000,
			mp = 15000,
			min_ac = 0,
			max_ac = 0,
			min_mac = 0,
			max_mac = 0,
			min_sc = 818,
			max_sc = 1636,
			min_def = 249,
			max_def = 500,
			min_res = 272,
			max_res = 546,
			crit = 0,
			crit_att = 60,
			hit = 15,
			dodge = 15
		}
	};

get({3000, 120}) ->
	#player_attr_conf{
		career = 3000,
		lv = 120,
		attr_base = #attr_base{
			hp = 15225,
			mp = 15225,
			min_ac = 0,
			max_ac = 0,
			min_mac = 0,
			max_mac = 0,
			min_sc = 830,
			max_sc = 1661,
			min_def = 253,
			max_def = 507,
			min_res = 276,
			max_res = 554,
			crit = 0,
			crit_att = 60,
			hit = 15,
			dodge = 15
		}
	};

get({3000, 121}) ->
	#player_attr_conf{
		career = 3000,
		lv = 121,
		attr_base = #attr_base{
			hp = 15449,
			mp = 15449,
			min_ac = 0,
			max_ac = 0,
			min_mac = 0,
			max_mac = 0,
			min_sc = 842,
			max_sc = 1685,
			min_def = 257,
			max_def = 515,
			min_res = 280,
			max_res = 562,
			crit = 0,
			crit_att = 65,
			hit = 15,
			dodge = 15
		}
	};

get({3000, 122}) ->
	#player_attr_conf{
		career = 3000,
		lv = 122,
		attr_base = #attr_base{
			hp = 15673,
			mp = 15673,
			min_ac = 0,
			max_ac = 0,
			min_mac = 0,
			max_mac = 0,
			min_sc = 855,
			max_sc = 1710,
			min_def = 260,
			max_def = 522,
			min_res = 284,
			max_res = 570,
			crit = 0,
			crit_att = 65,
			hit = 15,
			dodge = 15
		}
	};

get({3000, 123}) ->
	#player_attr_conf{
		career = 3000,
		lv = 123,
		attr_base = #attr_base{
			hp = 15898,
			mp = 15898,
			min_ac = 0,
			max_ac = 0,
			min_mac = 0,
			max_mac = 0,
			min_sc = 867,
			max_sc = 1734,
			min_def = 264,
			max_def = 530,
			min_res = 288,
			max_res = 578,
			crit = 0,
			crit_att = 65,
			hit = 15,
			dodge = 15
		}
	};

get({3000, 124}) ->
	#player_attr_conf{
		career = 3000,
		lv = 124,
		attr_base = #attr_base{
			hp = 16122,
			mp = 16122,
			min_ac = 0,
			max_ac = 0,
			min_mac = 0,
			max_mac = 0,
			min_sc = 879,
			max_sc = 1759,
			min_def = 268,
			max_def = 537,
			min_res = 292,
			max_res = 586,
			crit = 0,
			crit_att = 65,
			hit = 15,
			dodge = 15
		}
	};

get({3000, 125}) ->
	#player_attr_conf{
		career = 3000,
		lv = 125,
		attr_base = #attr_base{
			hp = 16347,
			mp = 16347,
			min_ac = 0,
			max_ac = 0,
			min_mac = 0,
			max_mac = 0,
			min_sc = 891,
			max_sc = 1783,
			min_def = 272,
			max_def = 545,
			min_res = 296,
			max_res = 594,
			crit = 0,
			crit_att = 65,
			hit = 15,
			dodge = 15
		}
	};

get({3000, 126}) ->
	#player_attr_conf{
		career = 3000,
		lv = 126,
		attr_base = #attr_base{
			hp = 16571,
			mp = 16571,
			min_ac = 0,
			max_ac = 0,
			min_mac = 0,
			max_mac = 0,
			min_sc = 904,
			max_sc = 1808,
			min_def = 275,
			max_def = 552,
			min_res = 300,
			max_res = 603,
			crit = 0,
			crit_att = 65,
			hit = 15,
			dodge = 15
		}
	};

get({3000, 127}) ->
	#player_attr_conf{
		career = 3000,
		lv = 127,
		attr_base = #attr_base{
			hp = 16795,
			mp = 16795,
			min_ac = 0,
			max_ac = 0,
			min_mac = 0,
			max_mac = 0,
			min_sc = 916,
			max_sc = 1832,
			min_def = 279,
			max_def = 560,
			min_res = 305,
			max_res = 611,
			crit = 0,
			crit_att = 65,
			hit = 15,
			dodge = 15
		}
	};

get({3000, 128}) ->
	#player_attr_conf{
		career = 3000,
		lv = 128,
		attr_base = #attr_base{
			hp = 17020,
			mp = 17020,
			min_ac = 0,
			max_ac = 0,
			min_mac = 0,
			max_mac = 0,
			min_sc = 928,
			max_sc = 1857,
			min_def = 283,
			max_def = 567,
			min_res = 309,
			max_res = 619,
			crit = 0,
			crit_att = 65,
			hit = 15,
			dodge = 15
		}
	};

get({3000, 129}) ->
	#player_attr_conf{
		career = 3000,
		lv = 129,
		attr_base = #attr_base{
			hp = 17244,
			mp = 17244,
			min_ac = 0,
			max_ac = 0,
			min_mac = 0,
			max_mac = 0,
			min_sc = 940,
			max_sc = 1881,
			min_def = 287,
			max_def = 575,
			min_res = 313,
			max_res = 627,
			crit = 0,
			crit_att = 65,
			hit = 15,
			dodge = 15
		}
	};

get({3000, 130}) ->
	#player_attr_conf{
		career = 3000,
		lv = 130,
		attr_base = #attr_base{
			hp = 17482,
			mp = 17482,
			min_ac = 0,
			max_ac = 0,
			min_mac = 0,
			max_mac = 0,
			min_sc = 953,
			max_sc = 1907,
			min_def = 291,
			max_def = 583,
			min_res = 317,
			max_res = 636,
			crit = 0,
			crit_att = 65,
			hit = 15,
			dodge = 15
		}
	};

get(_Key) ->
	?ERR("undefined key from player_attr_config ~p", [_Key]).