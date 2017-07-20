%%%-------------------------------------------------------------------
%%% @author zhengsiying
%%% @doc
%%%		自动生成文件，不要手动修改
%%% @end
%%% Created : 2016/10/12
%%%-------------------------------------------------------------------

-module(stren_rate_config).

-include("common.hrl").
-include("config.hrl").

-compile([export_all]).

get_list() ->
	[{110079,1}, {110080,1}, {110081,1}, {110082,1}, {110083,1}, {110084,1}, {110085,1}, {110086,1}, {110087,1}, {110088,1}, {110089,11}, {110090,11}, {110091,11}, {110092,11}, {110093,11}, {110094,11}, {110095,11}, {110096,11}, {110097,11}, {110098,11}, {110099,21}, {110100,21}, {110101,21}, {110102,21}, {110103,21}, {110104,21}, {110105,21}, {110106,21}, {110107,21}, {110108,21}, {110079,2}, {110080,2}, {110081,2}, {110082,2}, {110083,2}, {110084,2}, {110085,2}, {110086,2}, {110087,2}, {110088,2}, {110089,12}, {110090,12}, {110091,12}, {110092,12}, {110093,12}, {110094,12}, {110095,12}, {110096,12}, {110097,12}, {110098,12}, {110099,22}, {110100,22}, {110101,22}, {110102,22}, {110103,22}, {110104,22}, {110105,22}, {110106,22}, {110107,22}, {110108,22}, {110079,3}, {110080,3}, {110081,3}, {110082,3}, {110083,3}, {110084,3}, {110085,3}, {110086,3}, {110087,3}, {110088,3}, {110089,13}, {110090,13}, {110091,13}, {110092,13}, {110093,13}, {110094,13}, {110095,13}, {110096,13}, {110097,13}, {110098,13}, {110099,23}, {110100,23}, {110101,23}, {110102,23}, {110103,23}, {110104,23}, {110105,23}, {110106,23}, {110107,23}, {110108,23}, {110079,4}, {110080,4}, {110081,4}, {110082,4}, {110083,4}, {110084,4}, {110085,4}, {110086,4}, {110087,4}, {110088,4}, {110089,14}, {110090,14}, {110091,14}, {110092,14}, {110093,14}, {110094,14}, {110095,14}, {110096,14}, {110097,14}, {110098,14}, {110099,24}, {110100,24}, {110101,24}, {110102,24}, {110103,24}, {110104,24}, {110105,24}, {110106,24}, {110107,24}, {110108,24}, {110079,5}, {110080,5}, {110081,5}, {110082,5}, {110083,5}, {110084,5}, {110085,5}, {110086,5}, {110087,5}, {110088,5}, {110089,15}, {110090,15}, {110091,15}, {110092,15}, {110093,15}, {110094,15}, {110095,15}, {110096,15}, {110097,15}, {110098,15}, {110099,25}, {110100,25}, {110101,25}, {110102,25}, {110103,25}, {110104,25}, {110105,25}, {110106,25}, {110107,25}, {110108,25}, {110079,6}, {110080,6}, {110081,6}, {110082,6}, {110083,6}, {110084,6}, {110085,6}, {110086,6}, {110087,6}, {110088,6}, {110089,16}, {110090,16}, {110091,16}, {110092,16}, {110093,16}, {110094,16}, {110095,16}, {110096,16}, {110097,16}, {110098,16}, {110099,26}, {110100,26}, {110101,26}, {110102,26}, {110103,26}, {110104,26}, {110105,26}, {110106,26}, {110107,26}, {110108,26}, {110079,7}, {110080,7}, {110081,7}, {110082,7}, {110083,7}, {110084,7}, {110085,7}, {110086,7}, {110087,7}, {110088,7}, {110089,17}, {110090,17}, {110091,17}, {110092,17}, {110093,17}, {110094,17}, {110095,17}, {110096,17}, {110097,17}, {110098,17}, {110099,27}, {110100,27}, {110101,27}, {110102,27}, {110103,27}, {110104,27}, {110105,27}, {110106,27}, {110107,27}, {110108,27}, {110079,8}, {110080,8}, {110081,8}, {110082,8}, {110083,8}, {110084,8}, {110085,8}, {110086,8}, {110087,8}, {110088,8}, {110089,18}, {110090,18}, {110091,18}, {110092,18}, {110093,18}, {110094,18}, {110095,18}, {110096,18}, {110097,18}, {110098,18}, {110099,28}, {110100,28}, {110101,28}, {110102,28}, {110103,28}, {110104,28}, {110105,28}, {110106,28}, {110107,28}, {110108,28}, {110079,9}, {110080,9}, {110081,9}, {110082,9}, {110083,9}, {110084,9}, {110085,9}, {110086,9}, {110087,9}, {110088,9}, {110089,19}, {110090,19}, {110091,19}, {110092,19}, {110093,19}, {110094,19}, {110095,19}, {110096,19}, {110097,19}, {110098,19}, {110099,29}, {110100,29}, {110101,29}, {110102,29}, {110103,29}, {110104,29}, {110105,29}, {110106,29}, {110107,29}, {110108,29}, {110079,10}, {110080,10}, {110081,10}, {110082,10}, {110083,10}, {110084,10}, {110085,10}, {110086,10}, {110087,10}, {110088,10}, {110089,20}, {110090,20}, {110091,20}, {110092,20}, {110093,20}, {110094,20}, {110095,20}, {110096,20}, {110097,20}, {110098,20}, {110099,30}, {110100,30}, {110101,30}, {110102,30}, {110103,30}, {110104,30}, {110105,30}, {110106,30}, {110107,30}, {110108,30}, {110099,31}, {110100,31}, {110101,31}, {110102,31}, {110103,31}, {110104,31}, {110105,31}, {110106,31}, {110107,31}, {110108,31}, {110099,32}, {110100,32}, {110101,32}, {110102,32}, {110103,32}, {110104,32}, {110105,32}, {110106,32}, {110107,32}, {110108,32}, {110099,33}, {110100,33}, {110101,33}, {110102,33}, {110103,33}, {110104,33}, {110105,33}, {110106,33}, {110107,33}, {110108,33}, {110099,34}, {110100,34}, {110101,34}, {110102,34}, {110103,34}, {110104,34}, {110105,34}, {110106,34}, {110107,34}, {110108,34}, {110099,35}, {110100,35}, {110101,35}, {110102,35}, {110103,35}, {110104,35}, {110105,35}, {110106,35}, {110107,35}, {110108,35}, {110099,36}, {110100,36}, {110101,36}, {110102,36}, {110103,36}, {110104,36}, {110105,36}, {110106,36}, {110107,36}, {110108,36}, {110099,37}, {110100,37}, {110101,37}, {110102,37}, {110103,37}, {110104,37}, {110105,37}, {110106,37}, {110107,37}, {110108,37}, {110099,38}, {110100,38}, {110101,38}, {110102,38}, {110103,38}, {110104,38}, {110105,38}, {110106,38}, {110107,38}, {110108,38}, {110099,39}, {110100,39}, {110101,39}, {110102,39}, {110103,39}, {110104,39}, {110105,39}, {110106,39}, {110107,39}, {110108,39}, {110099,40}, {110100,40}, {110101,40}, {110102,40}, {110103,40}, {110104,40}, {110105,40}, {110106,40}, {110107,40}, {110108,40}].

get({110079,1}) ->
	#stren_rate_conf{
		key = 1,
		goods_id = 110079,
		stren_lv = 1,
		rate = 2000
	};

get({110080,1}) ->
	#stren_rate_conf{
		key = 2,
		goods_id = 110080,
		stren_lv = 1,
		rate = 4000
	};

get({110081,1}) ->
	#stren_rate_conf{
		key = 3,
		goods_id = 110081,
		stren_lv = 1,
		rate = 8000
	};

get({110082,1}) ->
	#stren_rate_conf{
		key = 4,
		goods_id = 110082,
		stren_lv = 1,
		rate = 10000
	};

get({110083,1}) ->
	#stren_rate_conf{
		key = 5,
		goods_id = 110083,
		stren_lv = 1,
		rate = 10000
	};

get({110084,1}) ->
	#stren_rate_conf{
		key = 6,
		goods_id = 110084,
		stren_lv = 1,
		rate = 10000
	};

get({110085,1}) ->
	#stren_rate_conf{
		key = 7,
		goods_id = 110085,
		stren_lv = 1,
		rate = 10000
	};

get({110086,1}) ->
	#stren_rate_conf{
		key = 8,
		goods_id = 110086,
		stren_lv = 1,
		rate = 10000
	};

get({110087,1}) ->
	#stren_rate_conf{
		key = 9,
		goods_id = 110087,
		stren_lv = 1,
		rate = 10000
	};

get({110088,1}) ->
	#stren_rate_conf{
		key = 10,
		goods_id = 110088,
		stren_lv = 1,
		rate = 10000
	};

get({110089,11}) ->
	#stren_rate_conf{
		key = 11,
		goods_id = 110089,
		stren_lv = 11,
		rate = 2000
	};

get({110090,11}) ->
	#stren_rate_conf{
		key = 12,
		goods_id = 110090,
		stren_lv = 11,
		rate = 4000
	};

get({110091,11}) ->
	#stren_rate_conf{
		key = 13,
		goods_id = 110091,
		stren_lv = 11,
		rate = 8000
	};

get({110092,11}) ->
	#stren_rate_conf{
		key = 14,
		goods_id = 110092,
		stren_lv = 11,
		rate = 10000
	};

get({110093,11}) ->
	#stren_rate_conf{
		key = 15,
		goods_id = 110093,
		stren_lv = 11,
		rate = 10000
	};

get({110094,11}) ->
	#stren_rate_conf{
		key = 16,
		goods_id = 110094,
		stren_lv = 11,
		rate = 10000
	};

get({110095,11}) ->
	#stren_rate_conf{
		key = 17,
		goods_id = 110095,
		stren_lv = 11,
		rate = 10000
	};

get({110096,11}) ->
	#stren_rate_conf{
		key = 18,
		goods_id = 110096,
		stren_lv = 11,
		rate = 10000
	};

get({110097,11}) ->
	#stren_rate_conf{
		key = 19,
		goods_id = 110097,
		stren_lv = 11,
		rate = 10000
	};

get({110098,11}) ->
	#stren_rate_conf{
		key = 20,
		goods_id = 110098,
		stren_lv = 11,
		rate = 10000
	};

get({110099,21}) ->
	#stren_rate_conf{
		key = 21,
		goods_id = 110099,
		stren_lv = 21,
		rate = 2000
	};

get({110100,21}) ->
	#stren_rate_conf{
		key = 22,
		goods_id = 110100,
		stren_lv = 21,
		rate = 4000
	};

get({110101,21}) ->
	#stren_rate_conf{
		key = 23,
		goods_id = 110101,
		stren_lv = 21,
		rate = 8000
	};

get({110102,21}) ->
	#stren_rate_conf{
		key = 24,
		goods_id = 110102,
		stren_lv = 21,
		rate = 10000
	};

get({110103,21}) ->
	#stren_rate_conf{
		key = 25,
		goods_id = 110103,
		stren_lv = 21,
		rate = 10000
	};

get({110104,21}) ->
	#stren_rate_conf{
		key = 26,
		goods_id = 110104,
		stren_lv = 21,
		rate = 10000
	};

get({110105,21}) ->
	#stren_rate_conf{
		key = 27,
		goods_id = 110105,
		stren_lv = 21,
		rate = 10000
	};

get({110106,21}) ->
	#stren_rate_conf{
		key = 28,
		goods_id = 110106,
		stren_lv = 21,
		rate = 10000
	};

get({110107,21}) ->
	#stren_rate_conf{
		key = 29,
		goods_id = 110107,
		stren_lv = 21,
		rate = 10000
	};

get({110108,21}) ->
	#stren_rate_conf{
		key = 30,
		goods_id = 110108,
		stren_lv = 21,
		rate = 10000
	};

get({110079,2}) ->
	#stren_rate_conf{
		key = 31,
		goods_id = 110079,
		stren_lv = 2,
		rate = 1000
	};

get({110080,2}) ->
	#stren_rate_conf{
		key = 32,
		goods_id = 110080,
		stren_lv = 2,
		rate = 2000
	};

get({110081,2}) ->
	#stren_rate_conf{
		key = 33,
		goods_id = 110081,
		stren_lv = 2,
		rate = 4000
	};

get({110082,2}) ->
	#stren_rate_conf{
		key = 34,
		goods_id = 110082,
		stren_lv = 2,
		rate = 8000
	};

get({110083,2}) ->
	#stren_rate_conf{
		key = 35,
		goods_id = 110083,
		stren_lv = 2,
		rate = 10000
	};

get({110084,2}) ->
	#stren_rate_conf{
		key = 36,
		goods_id = 110084,
		stren_lv = 2,
		rate = 10000
	};

get({110085,2}) ->
	#stren_rate_conf{
		key = 37,
		goods_id = 110085,
		stren_lv = 2,
		rate = 10000
	};

get({110086,2}) ->
	#stren_rate_conf{
		key = 38,
		goods_id = 110086,
		stren_lv = 2,
		rate = 10000
	};

get({110087,2}) ->
	#stren_rate_conf{
		key = 39,
		goods_id = 110087,
		stren_lv = 2,
		rate = 10000
	};

get({110088,2}) ->
	#stren_rate_conf{
		key = 40,
		goods_id = 110088,
		stren_lv = 2,
		rate = 10000
	};

get({110089,12}) ->
	#stren_rate_conf{
		key = 41,
		goods_id = 110089,
		stren_lv = 12,
		rate = 1000
	};

get({110090,12}) ->
	#stren_rate_conf{
		key = 42,
		goods_id = 110090,
		stren_lv = 12,
		rate = 2000
	};

get({110091,12}) ->
	#stren_rate_conf{
		key = 43,
		goods_id = 110091,
		stren_lv = 12,
		rate = 4000
	};

get({110092,12}) ->
	#stren_rate_conf{
		key = 44,
		goods_id = 110092,
		stren_lv = 12,
		rate = 8000
	};

get({110093,12}) ->
	#stren_rate_conf{
		key = 45,
		goods_id = 110093,
		stren_lv = 12,
		rate = 10000
	};

get({110094,12}) ->
	#stren_rate_conf{
		key = 46,
		goods_id = 110094,
		stren_lv = 12,
		rate = 10000
	};

get({110095,12}) ->
	#stren_rate_conf{
		key = 47,
		goods_id = 110095,
		stren_lv = 12,
		rate = 10000
	};

get({110096,12}) ->
	#stren_rate_conf{
		key = 48,
		goods_id = 110096,
		stren_lv = 12,
		rate = 10000
	};

get({110097,12}) ->
	#stren_rate_conf{
		key = 49,
		goods_id = 110097,
		stren_lv = 12,
		rate = 10000
	};

get({110098,12}) ->
	#stren_rate_conf{
		key = 50,
		goods_id = 110098,
		stren_lv = 12,
		rate = 10000
	};

get({110099,22}) ->
	#stren_rate_conf{
		key = 51,
		goods_id = 110099,
		stren_lv = 22,
		rate = 1000
	};

get({110100,22}) ->
	#stren_rate_conf{
		key = 52,
		goods_id = 110100,
		stren_lv = 22,
		rate = 2000
	};

get({110101,22}) ->
	#stren_rate_conf{
		key = 53,
		goods_id = 110101,
		stren_lv = 22,
		rate = 4000
	};

get({110102,22}) ->
	#stren_rate_conf{
		key = 54,
		goods_id = 110102,
		stren_lv = 22,
		rate = 8000
	};

get({110103,22}) ->
	#stren_rate_conf{
		key = 55,
		goods_id = 110103,
		stren_lv = 22,
		rate = 10000
	};

get({110104,22}) ->
	#stren_rate_conf{
		key = 56,
		goods_id = 110104,
		stren_lv = 22,
		rate = 10000
	};

get({110105,22}) ->
	#stren_rate_conf{
		key = 57,
		goods_id = 110105,
		stren_lv = 22,
		rate = 10000
	};

get({110106,22}) ->
	#stren_rate_conf{
		key = 58,
		goods_id = 110106,
		stren_lv = 22,
		rate = 10000
	};

get({110107,22}) ->
	#stren_rate_conf{
		key = 59,
		goods_id = 110107,
		stren_lv = 22,
		rate = 10000
	};

get({110108,22}) ->
	#stren_rate_conf{
		key = 60,
		goods_id = 110108,
		stren_lv = 22,
		rate = 10000
	};

get({110079,3}) ->
	#stren_rate_conf{
		key = 61,
		goods_id = 110079,
		stren_lv = 3,
		rate = 500
	};

get({110080,3}) ->
	#stren_rate_conf{
		key = 62,
		goods_id = 110080,
		stren_lv = 3,
		rate = 1000
	};

get({110081,3}) ->
	#stren_rate_conf{
		key = 63,
		goods_id = 110081,
		stren_lv = 3,
		rate = 2000
	};

get({110082,3}) ->
	#stren_rate_conf{
		key = 64,
		goods_id = 110082,
		stren_lv = 3,
		rate = 4000
	};

get({110083,3}) ->
	#stren_rate_conf{
		key = 65,
		goods_id = 110083,
		stren_lv = 3,
		rate = 8000
	};

get({110084,3}) ->
	#stren_rate_conf{
		key = 66,
		goods_id = 110084,
		stren_lv = 3,
		rate = 10000
	};

get({110085,3}) ->
	#stren_rate_conf{
		key = 67,
		goods_id = 110085,
		stren_lv = 3,
		rate = 10000
	};

get({110086,3}) ->
	#stren_rate_conf{
		key = 68,
		goods_id = 110086,
		stren_lv = 3,
		rate = 10000
	};

get({110087,3}) ->
	#stren_rate_conf{
		key = 69,
		goods_id = 110087,
		stren_lv = 3,
		rate = 10000
	};

get({110088,3}) ->
	#stren_rate_conf{
		key = 70,
		goods_id = 110088,
		stren_lv = 3,
		rate = 10000
	};

get({110089,13}) ->
	#stren_rate_conf{
		key = 71,
		goods_id = 110089,
		stren_lv = 13,
		rate = 500
	};

get({110090,13}) ->
	#stren_rate_conf{
		key = 72,
		goods_id = 110090,
		stren_lv = 13,
		rate = 1000
	};

get({110091,13}) ->
	#stren_rate_conf{
		key = 73,
		goods_id = 110091,
		stren_lv = 13,
		rate = 2000
	};

get({110092,13}) ->
	#stren_rate_conf{
		key = 74,
		goods_id = 110092,
		stren_lv = 13,
		rate = 4000
	};

get({110093,13}) ->
	#stren_rate_conf{
		key = 75,
		goods_id = 110093,
		stren_lv = 13,
		rate = 8000
	};

get({110094,13}) ->
	#stren_rate_conf{
		key = 76,
		goods_id = 110094,
		stren_lv = 13,
		rate = 10000
	};

get({110095,13}) ->
	#stren_rate_conf{
		key = 77,
		goods_id = 110095,
		stren_lv = 13,
		rate = 10000
	};

get({110096,13}) ->
	#stren_rate_conf{
		key = 78,
		goods_id = 110096,
		stren_lv = 13,
		rate = 10000
	};

get({110097,13}) ->
	#stren_rate_conf{
		key = 79,
		goods_id = 110097,
		stren_lv = 13,
		rate = 10000
	};

get({110098,13}) ->
	#stren_rate_conf{
		key = 80,
		goods_id = 110098,
		stren_lv = 13,
		rate = 10000
	};

get({110099,23}) ->
	#stren_rate_conf{
		key = 81,
		goods_id = 110099,
		stren_lv = 23,
		rate = 500
	};

get({110100,23}) ->
	#stren_rate_conf{
		key = 82,
		goods_id = 110100,
		stren_lv = 23,
		rate = 1000
	};

get({110101,23}) ->
	#stren_rate_conf{
		key = 83,
		goods_id = 110101,
		stren_lv = 23,
		rate = 2000
	};

get({110102,23}) ->
	#stren_rate_conf{
		key = 84,
		goods_id = 110102,
		stren_lv = 23,
		rate = 4000
	};

get({110103,23}) ->
	#stren_rate_conf{
		key = 85,
		goods_id = 110103,
		stren_lv = 23,
		rate = 8000
	};

get({110104,23}) ->
	#stren_rate_conf{
		key = 86,
		goods_id = 110104,
		stren_lv = 23,
		rate = 10000
	};

get({110105,23}) ->
	#stren_rate_conf{
		key = 87,
		goods_id = 110105,
		stren_lv = 23,
		rate = 10000
	};

get({110106,23}) ->
	#stren_rate_conf{
		key = 88,
		goods_id = 110106,
		stren_lv = 23,
		rate = 10000
	};

get({110107,23}) ->
	#stren_rate_conf{
		key = 89,
		goods_id = 110107,
		stren_lv = 23,
		rate = 10000
	};

get({110108,23}) ->
	#stren_rate_conf{
		key = 90,
		goods_id = 110108,
		stren_lv = 23,
		rate = 10000
	};

get({110079,4}) ->
	#stren_rate_conf{
		key = 91,
		goods_id = 110079,
		stren_lv = 4,
		rate = 250
	};

get({110080,4}) ->
	#stren_rate_conf{
		key = 92,
		goods_id = 110080,
		stren_lv = 4,
		rate = 500
	};

get({110081,4}) ->
	#stren_rate_conf{
		key = 93,
		goods_id = 110081,
		stren_lv = 4,
		rate = 1000
	};

get({110082,4}) ->
	#stren_rate_conf{
		key = 94,
		goods_id = 110082,
		stren_lv = 4,
		rate = 2000
	};

get({110083,4}) ->
	#stren_rate_conf{
		key = 95,
		goods_id = 110083,
		stren_lv = 4,
		rate = 4000
	};

get({110084,4}) ->
	#stren_rate_conf{
		key = 96,
		goods_id = 110084,
		stren_lv = 4,
		rate = 8000
	};

get({110085,4}) ->
	#stren_rate_conf{
		key = 97,
		goods_id = 110085,
		stren_lv = 4,
		rate = 10000
	};

get({110086,4}) ->
	#stren_rate_conf{
		key = 98,
		goods_id = 110086,
		stren_lv = 4,
		rate = 10000
	};

get({110087,4}) ->
	#stren_rate_conf{
		key = 99,
		goods_id = 110087,
		stren_lv = 4,
		rate = 10000
	};

get({110088,4}) ->
	#stren_rate_conf{
		key = 100,
		goods_id = 110088,
		stren_lv = 4,
		rate = 10000
	};

get({110089,14}) ->
	#stren_rate_conf{
		key = 101,
		goods_id = 110089,
		stren_lv = 14,
		rate = 250
	};

get({110090,14}) ->
	#stren_rate_conf{
		key = 102,
		goods_id = 110090,
		stren_lv = 14,
		rate = 500
	};

get({110091,14}) ->
	#stren_rate_conf{
		key = 103,
		goods_id = 110091,
		stren_lv = 14,
		rate = 1000
	};

get({110092,14}) ->
	#stren_rate_conf{
		key = 104,
		goods_id = 110092,
		stren_lv = 14,
		rate = 2000
	};

get({110093,14}) ->
	#stren_rate_conf{
		key = 105,
		goods_id = 110093,
		stren_lv = 14,
		rate = 4000
	};

get({110094,14}) ->
	#stren_rate_conf{
		key = 106,
		goods_id = 110094,
		stren_lv = 14,
		rate = 8000
	};

get({110095,14}) ->
	#stren_rate_conf{
		key = 107,
		goods_id = 110095,
		stren_lv = 14,
		rate = 10000
	};

get({110096,14}) ->
	#stren_rate_conf{
		key = 108,
		goods_id = 110096,
		stren_lv = 14,
		rate = 10000
	};

get({110097,14}) ->
	#stren_rate_conf{
		key = 109,
		goods_id = 110097,
		stren_lv = 14,
		rate = 10000
	};

get({110098,14}) ->
	#stren_rate_conf{
		key = 110,
		goods_id = 110098,
		stren_lv = 14,
		rate = 10000
	};

get({110099,24}) ->
	#stren_rate_conf{
		key = 111,
		goods_id = 110099,
		stren_lv = 24,
		rate = 250
	};

get({110100,24}) ->
	#stren_rate_conf{
		key = 112,
		goods_id = 110100,
		stren_lv = 24,
		rate = 500
	};

get({110101,24}) ->
	#stren_rate_conf{
		key = 113,
		goods_id = 110101,
		stren_lv = 24,
		rate = 1000
	};

get({110102,24}) ->
	#stren_rate_conf{
		key = 114,
		goods_id = 110102,
		stren_lv = 24,
		rate = 2000
	};

get({110103,24}) ->
	#stren_rate_conf{
		key = 115,
		goods_id = 110103,
		stren_lv = 24,
		rate = 4000
	};

get({110104,24}) ->
	#stren_rate_conf{
		key = 116,
		goods_id = 110104,
		stren_lv = 24,
		rate = 8000
	};

get({110105,24}) ->
	#stren_rate_conf{
		key = 117,
		goods_id = 110105,
		stren_lv = 24,
		rate = 10000
	};

get({110106,24}) ->
	#stren_rate_conf{
		key = 118,
		goods_id = 110106,
		stren_lv = 24,
		rate = 10000
	};

get({110107,24}) ->
	#stren_rate_conf{
		key = 119,
		goods_id = 110107,
		stren_lv = 24,
		rate = 10000
	};

get({110108,24}) ->
	#stren_rate_conf{
		key = 120,
		goods_id = 110108,
		stren_lv = 24,
		rate = 10000
	};

get({110079,5}) ->
	#stren_rate_conf{
		key = 121,
		goods_id = 110079,
		stren_lv = 5,
		rate = 125
	};

get({110080,5}) ->
	#stren_rate_conf{
		key = 122,
		goods_id = 110080,
		stren_lv = 5,
		rate = 250
	};

get({110081,5}) ->
	#stren_rate_conf{
		key = 123,
		goods_id = 110081,
		stren_lv = 5,
		rate = 500
	};

get({110082,5}) ->
	#stren_rate_conf{
		key = 124,
		goods_id = 110082,
		stren_lv = 5,
		rate = 1000
	};

get({110083,5}) ->
	#stren_rate_conf{
		key = 125,
		goods_id = 110083,
		stren_lv = 5,
		rate = 2000
	};

get({110084,5}) ->
	#stren_rate_conf{
		key = 126,
		goods_id = 110084,
		stren_lv = 5,
		rate = 4000
	};

get({110085,5}) ->
	#stren_rate_conf{
		key = 127,
		goods_id = 110085,
		stren_lv = 5,
		rate = 8000
	};

get({110086,5}) ->
	#stren_rate_conf{
		key = 128,
		goods_id = 110086,
		stren_lv = 5,
		rate = 10000
	};

get({110087,5}) ->
	#stren_rate_conf{
		key = 129,
		goods_id = 110087,
		stren_lv = 5,
		rate = 10000
	};

get({110088,5}) ->
	#stren_rate_conf{
		key = 130,
		goods_id = 110088,
		stren_lv = 5,
		rate = 10000
	};

get({110089,15}) ->
	#stren_rate_conf{
		key = 131,
		goods_id = 110089,
		stren_lv = 15,
		rate = 125
	};

get({110090,15}) ->
	#stren_rate_conf{
		key = 132,
		goods_id = 110090,
		stren_lv = 15,
		rate = 250
	};

get({110091,15}) ->
	#stren_rate_conf{
		key = 133,
		goods_id = 110091,
		stren_lv = 15,
		rate = 500
	};

get({110092,15}) ->
	#stren_rate_conf{
		key = 134,
		goods_id = 110092,
		stren_lv = 15,
		rate = 1000
	};

get({110093,15}) ->
	#stren_rate_conf{
		key = 135,
		goods_id = 110093,
		stren_lv = 15,
		rate = 2000
	};

get({110094,15}) ->
	#stren_rate_conf{
		key = 136,
		goods_id = 110094,
		stren_lv = 15,
		rate = 4000
	};

get({110095,15}) ->
	#stren_rate_conf{
		key = 137,
		goods_id = 110095,
		stren_lv = 15,
		rate = 8000
	};

get({110096,15}) ->
	#stren_rate_conf{
		key = 138,
		goods_id = 110096,
		stren_lv = 15,
		rate = 10000
	};

get({110097,15}) ->
	#stren_rate_conf{
		key = 139,
		goods_id = 110097,
		stren_lv = 15,
		rate = 10000
	};

get({110098,15}) ->
	#stren_rate_conf{
		key = 140,
		goods_id = 110098,
		stren_lv = 15,
		rate = 10000
	};

get({110099,25}) ->
	#stren_rate_conf{
		key = 141,
		goods_id = 110099,
		stren_lv = 25,
		rate = 125
	};

get({110100,25}) ->
	#stren_rate_conf{
		key = 142,
		goods_id = 110100,
		stren_lv = 25,
		rate = 250
	};

get({110101,25}) ->
	#stren_rate_conf{
		key = 143,
		goods_id = 110101,
		stren_lv = 25,
		rate = 500
	};

get({110102,25}) ->
	#stren_rate_conf{
		key = 144,
		goods_id = 110102,
		stren_lv = 25,
		rate = 1000
	};

get({110103,25}) ->
	#stren_rate_conf{
		key = 145,
		goods_id = 110103,
		stren_lv = 25,
		rate = 2000
	};

get({110104,25}) ->
	#stren_rate_conf{
		key = 146,
		goods_id = 110104,
		stren_lv = 25,
		rate = 4000
	};

get({110105,25}) ->
	#stren_rate_conf{
		key = 147,
		goods_id = 110105,
		stren_lv = 25,
		rate = 8000
	};

get({110106,25}) ->
	#stren_rate_conf{
		key = 148,
		goods_id = 110106,
		stren_lv = 25,
		rate = 10000
	};

get({110107,25}) ->
	#stren_rate_conf{
		key = 149,
		goods_id = 110107,
		stren_lv = 25,
		rate = 10000
	};

get({110108,25}) ->
	#stren_rate_conf{
		key = 150,
		goods_id = 110108,
		stren_lv = 25,
		rate = 10000
	};

get({110079,6}) ->
	#stren_rate_conf{
		key = 151,
		goods_id = 110079,
		stren_lv = 6,
		rate = 62
	};

get({110080,6}) ->
	#stren_rate_conf{
		key = 152,
		goods_id = 110080,
		stren_lv = 6,
		rate = 125
	};

get({110081,6}) ->
	#stren_rate_conf{
		key = 153,
		goods_id = 110081,
		stren_lv = 6,
		rate = 250
	};

get({110082,6}) ->
	#stren_rate_conf{
		key = 154,
		goods_id = 110082,
		stren_lv = 6,
		rate = 500
	};

get({110083,6}) ->
	#stren_rate_conf{
		key = 155,
		goods_id = 110083,
		stren_lv = 6,
		rate = 1000
	};

get({110084,6}) ->
	#stren_rate_conf{
		key = 156,
		goods_id = 110084,
		stren_lv = 6,
		rate = 2000
	};

get({110085,6}) ->
	#stren_rate_conf{
		key = 157,
		goods_id = 110085,
		stren_lv = 6,
		rate = 4000
	};

get({110086,6}) ->
	#stren_rate_conf{
		key = 158,
		goods_id = 110086,
		stren_lv = 6,
		rate = 8000
	};

get({110087,6}) ->
	#stren_rate_conf{
		key = 159,
		goods_id = 110087,
		stren_lv = 6,
		rate = 10000
	};

get({110088,6}) ->
	#stren_rate_conf{
		key = 160,
		goods_id = 110088,
		stren_lv = 6,
		rate = 10000
	};

get({110089,16}) ->
	#stren_rate_conf{
		key = 161,
		goods_id = 110089,
		stren_lv = 16,
		rate = 62
	};

get({110090,16}) ->
	#stren_rate_conf{
		key = 162,
		goods_id = 110090,
		stren_lv = 16,
		rate = 125
	};

get({110091,16}) ->
	#stren_rate_conf{
		key = 163,
		goods_id = 110091,
		stren_lv = 16,
		rate = 250
	};

get({110092,16}) ->
	#stren_rate_conf{
		key = 164,
		goods_id = 110092,
		stren_lv = 16,
		rate = 500
	};

get({110093,16}) ->
	#stren_rate_conf{
		key = 165,
		goods_id = 110093,
		stren_lv = 16,
		rate = 1000
	};

get({110094,16}) ->
	#stren_rate_conf{
		key = 166,
		goods_id = 110094,
		stren_lv = 16,
		rate = 2000
	};

get({110095,16}) ->
	#stren_rate_conf{
		key = 167,
		goods_id = 110095,
		stren_lv = 16,
		rate = 4000
	};

get({110096,16}) ->
	#stren_rate_conf{
		key = 168,
		goods_id = 110096,
		stren_lv = 16,
		rate = 8000
	};

get({110097,16}) ->
	#stren_rate_conf{
		key = 169,
		goods_id = 110097,
		stren_lv = 16,
		rate = 10000
	};

get({110098,16}) ->
	#stren_rate_conf{
		key = 170,
		goods_id = 110098,
		stren_lv = 16,
		rate = 10000
	};

get({110099,26}) ->
	#stren_rate_conf{
		key = 171,
		goods_id = 110099,
		stren_lv = 26,
		rate = 62
	};

get({110100,26}) ->
	#stren_rate_conf{
		key = 172,
		goods_id = 110100,
		stren_lv = 26,
		rate = 125
	};

get({110101,26}) ->
	#stren_rate_conf{
		key = 173,
		goods_id = 110101,
		stren_lv = 26,
		rate = 250
	};

get({110102,26}) ->
	#stren_rate_conf{
		key = 174,
		goods_id = 110102,
		stren_lv = 26,
		rate = 500
	};

get({110103,26}) ->
	#stren_rate_conf{
		key = 175,
		goods_id = 110103,
		stren_lv = 26,
		rate = 1000
	};

get({110104,26}) ->
	#stren_rate_conf{
		key = 176,
		goods_id = 110104,
		stren_lv = 26,
		rate = 2000
	};

get({110105,26}) ->
	#stren_rate_conf{
		key = 177,
		goods_id = 110105,
		stren_lv = 26,
		rate = 4000
	};

get({110106,26}) ->
	#stren_rate_conf{
		key = 178,
		goods_id = 110106,
		stren_lv = 26,
		rate = 8000
	};

get({110107,26}) ->
	#stren_rate_conf{
		key = 179,
		goods_id = 110107,
		stren_lv = 26,
		rate = 10000
	};

get({110108,26}) ->
	#stren_rate_conf{
		key = 180,
		goods_id = 110108,
		stren_lv = 26,
		rate = 10000
	};

get({110079,7}) ->
	#stren_rate_conf{
		key = 181,
		goods_id = 110079,
		stren_lv = 7,
		rate = 31
	};

get({110080,7}) ->
	#stren_rate_conf{
		key = 182,
		goods_id = 110080,
		stren_lv = 7,
		rate = 62
	};

get({110081,7}) ->
	#stren_rate_conf{
		key = 183,
		goods_id = 110081,
		stren_lv = 7,
		rate = 125
	};

get({110082,7}) ->
	#stren_rate_conf{
		key = 184,
		goods_id = 110082,
		stren_lv = 7,
		rate = 250
	};

get({110083,7}) ->
	#stren_rate_conf{
		key = 185,
		goods_id = 110083,
		stren_lv = 7,
		rate = 500
	};

get({110084,7}) ->
	#stren_rate_conf{
		key = 186,
		goods_id = 110084,
		stren_lv = 7,
		rate = 1000
	};

get({110085,7}) ->
	#stren_rate_conf{
		key = 187,
		goods_id = 110085,
		stren_lv = 7,
		rate = 2000
	};

get({110086,7}) ->
	#stren_rate_conf{
		key = 188,
		goods_id = 110086,
		stren_lv = 7,
		rate = 4000
	};

get({110087,7}) ->
	#stren_rate_conf{
		key = 189,
		goods_id = 110087,
		stren_lv = 7,
		rate = 8000
	};

get({110088,7}) ->
	#stren_rate_conf{
		key = 190,
		goods_id = 110088,
		stren_lv = 7,
		rate = 10000
	};

get({110089,17}) ->
	#stren_rate_conf{
		key = 191,
		goods_id = 110089,
		stren_lv = 17,
		rate = 31
	};

get({110090,17}) ->
	#stren_rate_conf{
		key = 192,
		goods_id = 110090,
		stren_lv = 17,
		rate = 62
	};

get({110091,17}) ->
	#stren_rate_conf{
		key = 193,
		goods_id = 110091,
		stren_lv = 17,
		rate = 125
	};

get({110092,17}) ->
	#stren_rate_conf{
		key = 194,
		goods_id = 110092,
		stren_lv = 17,
		rate = 250
	};

get({110093,17}) ->
	#stren_rate_conf{
		key = 195,
		goods_id = 110093,
		stren_lv = 17,
		rate = 500
	};

get({110094,17}) ->
	#stren_rate_conf{
		key = 196,
		goods_id = 110094,
		stren_lv = 17,
		rate = 1000
	};

get({110095,17}) ->
	#stren_rate_conf{
		key = 197,
		goods_id = 110095,
		stren_lv = 17,
		rate = 2000
	};

get({110096,17}) ->
	#stren_rate_conf{
		key = 198,
		goods_id = 110096,
		stren_lv = 17,
		rate = 4000
	};

get({110097,17}) ->
	#stren_rate_conf{
		key = 199,
		goods_id = 110097,
		stren_lv = 17,
		rate = 8000
	};

get({110098,17}) ->
	#stren_rate_conf{
		key = 200,
		goods_id = 110098,
		stren_lv = 17,
		rate = 10000
	};

get({110099,27}) ->
	#stren_rate_conf{
		key = 201,
		goods_id = 110099,
		stren_lv = 27,
		rate = 31
	};

get({110100,27}) ->
	#stren_rate_conf{
		key = 202,
		goods_id = 110100,
		stren_lv = 27,
		rate = 62
	};

get({110101,27}) ->
	#stren_rate_conf{
		key = 203,
		goods_id = 110101,
		stren_lv = 27,
		rate = 125
	};

get({110102,27}) ->
	#stren_rate_conf{
		key = 204,
		goods_id = 110102,
		stren_lv = 27,
		rate = 250
	};

get({110103,27}) ->
	#stren_rate_conf{
		key = 205,
		goods_id = 110103,
		stren_lv = 27,
		rate = 500
	};

get({110104,27}) ->
	#stren_rate_conf{
		key = 206,
		goods_id = 110104,
		stren_lv = 27,
		rate = 1000
	};

get({110105,27}) ->
	#stren_rate_conf{
		key = 207,
		goods_id = 110105,
		stren_lv = 27,
		rate = 2000
	};

get({110106,27}) ->
	#stren_rate_conf{
		key = 208,
		goods_id = 110106,
		stren_lv = 27,
		rate = 4000
	};

get({110107,27}) ->
	#stren_rate_conf{
		key = 209,
		goods_id = 110107,
		stren_lv = 27,
		rate = 8000
	};

get({110108,27}) ->
	#stren_rate_conf{
		key = 210,
		goods_id = 110108,
		stren_lv = 27,
		rate = 10000
	};

get({110079,8}) ->
	#stren_rate_conf{
		key = 211,
		goods_id = 110079,
		stren_lv = 8,
		rate = 15
	};

get({110080,8}) ->
	#stren_rate_conf{
		key = 212,
		goods_id = 110080,
		stren_lv = 8,
		rate = 31
	};

get({110081,8}) ->
	#stren_rate_conf{
		key = 213,
		goods_id = 110081,
		stren_lv = 8,
		rate = 62
	};

get({110082,8}) ->
	#stren_rate_conf{
		key = 214,
		goods_id = 110082,
		stren_lv = 8,
		rate = 125
	};

get({110083,8}) ->
	#stren_rate_conf{
		key = 215,
		goods_id = 110083,
		stren_lv = 8,
		rate = 250
	};

get({110084,8}) ->
	#stren_rate_conf{
		key = 216,
		goods_id = 110084,
		stren_lv = 8,
		rate = 500
	};

get({110085,8}) ->
	#stren_rate_conf{
		key = 217,
		goods_id = 110085,
		stren_lv = 8,
		rate = 1000
	};

get({110086,8}) ->
	#stren_rate_conf{
		key = 218,
		goods_id = 110086,
		stren_lv = 8,
		rate = 2000
	};

get({110087,8}) ->
	#stren_rate_conf{
		key = 219,
		goods_id = 110087,
		stren_lv = 8,
		rate = 4000
	};

get({110088,8}) ->
	#stren_rate_conf{
		key = 220,
		goods_id = 110088,
		stren_lv = 8,
		rate = 8000
	};

get({110089,18}) ->
	#stren_rate_conf{
		key = 221,
		goods_id = 110089,
		stren_lv = 18,
		rate = 15
	};

get({110090,18}) ->
	#stren_rate_conf{
		key = 222,
		goods_id = 110090,
		stren_lv = 18,
		rate = 31
	};

get({110091,18}) ->
	#stren_rate_conf{
		key = 223,
		goods_id = 110091,
		stren_lv = 18,
		rate = 62
	};

get({110092,18}) ->
	#stren_rate_conf{
		key = 224,
		goods_id = 110092,
		stren_lv = 18,
		rate = 125
	};

get({110093,18}) ->
	#stren_rate_conf{
		key = 225,
		goods_id = 110093,
		stren_lv = 18,
		rate = 250
	};

get({110094,18}) ->
	#stren_rate_conf{
		key = 226,
		goods_id = 110094,
		stren_lv = 18,
		rate = 500
	};

get({110095,18}) ->
	#stren_rate_conf{
		key = 227,
		goods_id = 110095,
		stren_lv = 18,
		rate = 1000
	};

get({110096,18}) ->
	#stren_rate_conf{
		key = 228,
		goods_id = 110096,
		stren_lv = 18,
		rate = 2000
	};

get({110097,18}) ->
	#stren_rate_conf{
		key = 229,
		goods_id = 110097,
		stren_lv = 18,
		rate = 4000
	};

get({110098,18}) ->
	#stren_rate_conf{
		key = 230,
		goods_id = 110098,
		stren_lv = 18,
		rate = 8000
	};

get({110099,28}) ->
	#stren_rate_conf{
		key = 231,
		goods_id = 110099,
		stren_lv = 28,
		rate = 15
	};

get({110100,28}) ->
	#stren_rate_conf{
		key = 232,
		goods_id = 110100,
		stren_lv = 28,
		rate = 31
	};

get({110101,28}) ->
	#stren_rate_conf{
		key = 233,
		goods_id = 110101,
		stren_lv = 28,
		rate = 62
	};

get({110102,28}) ->
	#stren_rate_conf{
		key = 234,
		goods_id = 110102,
		stren_lv = 28,
		rate = 125
	};

get({110103,28}) ->
	#stren_rate_conf{
		key = 235,
		goods_id = 110103,
		stren_lv = 28,
		rate = 250
	};

get({110104,28}) ->
	#stren_rate_conf{
		key = 236,
		goods_id = 110104,
		stren_lv = 28,
		rate = 500
	};

get({110105,28}) ->
	#stren_rate_conf{
		key = 237,
		goods_id = 110105,
		stren_lv = 28,
		rate = 1000
	};

get({110106,28}) ->
	#stren_rate_conf{
		key = 238,
		goods_id = 110106,
		stren_lv = 28,
		rate = 2000
	};

get({110107,28}) ->
	#stren_rate_conf{
		key = 239,
		goods_id = 110107,
		stren_lv = 28,
		rate = 4000
	};

get({110108,28}) ->
	#stren_rate_conf{
		key = 240,
		goods_id = 110108,
		stren_lv = 28,
		rate = 8000
	};

get({110079,9}) ->
	#stren_rate_conf{
		key = 241,
		goods_id = 110079,
		stren_lv = 9,
		rate = 7
	};

get({110080,9}) ->
	#stren_rate_conf{
		key = 242,
		goods_id = 110080,
		stren_lv = 9,
		rate = 15
	};

get({110081,9}) ->
	#stren_rate_conf{
		key = 243,
		goods_id = 110081,
		stren_lv = 9,
		rate = 31
	};

get({110082,9}) ->
	#stren_rate_conf{
		key = 244,
		goods_id = 110082,
		stren_lv = 9,
		rate = 62
	};

get({110083,9}) ->
	#stren_rate_conf{
		key = 245,
		goods_id = 110083,
		stren_lv = 9,
		rate = 125
	};

get({110084,9}) ->
	#stren_rate_conf{
		key = 246,
		goods_id = 110084,
		stren_lv = 9,
		rate = 250
	};

get({110085,9}) ->
	#stren_rate_conf{
		key = 247,
		goods_id = 110085,
		stren_lv = 9,
		rate = 500
	};

get({110086,9}) ->
	#stren_rate_conf{
		key = 248,
		goods_id = 110086,
		stren_lv = 9,
		rate = 1000
	};

get({110087,9}) ->
	#stren_rate_conf{
		key = 249,
		goods_id = 110087,
		stren_lv = 9,
		rate = 2000
	};

get({110088,9}) ->
	#stren_rate_conf{
		key = 250,
		goods_id = 110088,
		stren_lv = 9,
		rate = 4000
	};

get({110089,19}) ->
	#stren_rate_conf{
		key = 251,
		goods_id = 110089,
		stren_lv = 19,
		rate = 7
	};

get({110090,19}) ->
	#stren_rate_conf{
		key = 252,
		goods_id = 110090,
		stren_lv = 19,
		rate = 15
	};

get({110091,19}) ->
	#stren_rate_conf{
		key = 253,
		goods_id = 110091,
		stren_lv = 19,
		rate = 31
	};

get({110092,19}) ->
	#stren_rate_conf{
		key = 254,
		goods_id = 110092,
		stren_lv = 19,
		rate = 62
	};

get({110093,19}) ->
	#stren_rate_conf{
		key = 255,
		goods_id = 110093,
		stren_lv = 19,
		rate = 125
	};

get({110094,19}) ->
	#stren_rate_conf{
		key = 256,
		goods_id = 110094,
		stren_lv = 19,
		rate = 250
	};

get({110095,19}) ->
	#stren_rate_conf{
		key = 257,
		goods_id = 110095,
		stren_lv = 19,
		rate = 500
	};

get({110096,19}) ->
	#stren_rate_conf{
		key = 258,
		goods_id = 110096,
		stren_lv = 19,
		rate = 1000
	};

get({110097,19}) ->
	#stren_rate_conf{
		key = 259,
		goods_id = 110097,
		stren_lv = 19,
		rate = 2000
	};

get({110098,19}) ->
	#stren_rate_conf{
		key = 260,
		goods_id = 110098,
		stren_lv = 19,
		rate = 4000
	};

get({110099,29}) ->
	#stren_rate_conf{
		key = 261,
		goods_id = 110099,
		stren_lv = 29,
		rate = 7
	};

get({110100,29}) ->
	#stren_rate_conf{
		key = 262,
		goods_id = 110100,
		stren_lv = 29,
		rate = 15
	};

get({110101,29}) ->
	#stren_rate_conf{
		key = 263,
		goods_id = 110101,
		stren_lv = 29,
		rate = 31
	};

get({110102,29}) ->
	#stren_rate_conf{
		key = 264,
		goods_id = 110102,
		stren_lv = 29,
		rate = 62
	};

get({110103,29}) ->
	#stren_rate_conf{
		key = 265,
		goods_id = 110103,
		stren_lv = 29,
		rate = 125
	};

get({110104,29}) ->
	#stren_rate_conf{
		key = 266,
		goods_id = 110104,
		stren_lv = 29,
		rate = 250
	};

get({110105,29}) ->
	#stren_rate_conf{
		key = 267,
		goods_id = 110105,
		stren_lv = 29,
		rate = 500
	};

get({110106,29}) ->
	#stren_rate_conf{
		key = 268,
		goods_id = 110106,
		stren_lv = 29,
		rate = 1000
	};

get({110107,29}) ->
	#stren_rate_conf{
		key = 269,
		goods_id = 110107,
		stren_lv = 29,
		rate = 2000
	};

get({110108,29}) ->
	#stren_rate_conf{
		key = 270,
		goods_id = 110108,
		stren_lv = 29,
		rate = 4000
	};

get({110079,10}) ->
	#stren_rate_conf{
		key = 271,
		goods_id = 110079,
		stren_lv = 10,
		rate = 3
	};

get({110080,10}) ->
	#stren_rate_conf{
		key = 272,
		goods_id = 110080,
		stren_lv = 10,
		rate = 7
	};

get({110081,10}) ->
	#stren_rate_conf{
		key = 273,
		goods_id = 110081,
		stren_lv = 10,
		rate = 15
	};

get({110082,10}) ->
	#stren_rate_conf{
		key = 274,
		goods_id = 110082,
		stren_lv = 10,
		rate = 31
	};

get({110083,10}) ->
	#stren_rate_conf{
		key = 275,
		goods_id = 110083,
		stren_lv = 10,
		rate = 62
	};

get({110084,10}) ->
	#stren_rate_conf{
		key = 276,
		goods_id = 110084,
		stren_lv = 10,
		rate = 125
	};

get({110085,10}) ->
	#stren_rate_conf{
		key = 277,
		goods_id = 110085,
		stren_lv = 10,
		rate = 250
	};

get({110086,10}) ->
	#stren_rate_conf{
		key = 278,
		goods_id = 110086,
		stren_lv = 10,
		rate = 500
	};

get({110087,10}) ->
	#stren_rate_conf{
		key = 279,
		goods_id = 110087,
		stren_lv = 10,
		rate = 1000
	};

get({110088,10}) ->
	#stren_rate_conf{
		key = 280,
		goods_id = 110088,
		stren_lv = 10,
		rate = 2000
	};

get({110089,20}) ->
	#stren_rate_conf{
		key = 281,
		goods_id = 110089,
		stren_lv = 20,
		rate = 3
	};

get({110090,20}) ->
	#stren_rate_conf{
		key = 282,
		goods_id = 110090,
		stren_lv = 20,
		rate = 7
	};

get({110091,20}) ->
	#stren_rate_conf{
		key = 283,
		goods_id = 110091,
		stren_lv = 20,
		rate = 15
	};

get({110092,20}) ->
	#stren_rate_conf{
		key = 284,
		goods_id = 110092,
		stren_lv = 20,
		rate = 31
	};

get({110093,20}) ->
	#stren_rate_conf{
		key = 285,
		goods_id = 110093,
		stren_lv = 20,
		rate = 62
	};

get({110094,20}) ->
	#stren_rate_conf{
		key = 286,
		goods_id = 110094,
		stren_lv = 20,
		rate = 125
	};

get({110095,20}) ->
	#stren_rate_conf{
		key = 287,
		goods_id = 110095,
		stren_lv = 20,
		rate = 250
	};

get({110096,20}) ->
	#stren_rate_conf{
		key = 288,
		goods_id = 110096,
		stren_lv = 20,
		rate = 500
	};

get({110097,20}) ->
	#stren_rate_conf{
		key = 289,
		goods_id = 110097,
		stren_lv = 20,
		rate = 1000
	};

get({110098,20}) ->
	#stren_rate_conf{
		key = 290,
		goods_id = 110098,
		stren_lv = 20,
		rate = 2000
	};

get({110099,30}) ->
	#stren_rate_conf{
		key = 291,
		goods_id = 110099,
		stren_lv = 30,
		rate = 3
	};

get({110100,30}) ->
	#stren_rate_conf{
		key = 292,
		goods_id = 110100,
		stren_lv = 30,
		rate = 7
	};

get({110101,30}) ->
	#stren_rate_conf{
		key = 293,
		goods_id = 110101,
		stren_lv = 30,
		rate = 15
	};

get({110102,30}) ->
	#stren_rate_conf{
		key = 294,
		goods_id = 110102,
		stren_lv = 30,
		rate = 31
	};

get({110103,30}) ->
	#stren_rate_conf{
		key = 295,
		goods_id = 110103,
		stren_lv = 30,
		rate = 62
	};

get({110104,30}) ->
	#stren_rate_conf{
		key = 296,
		goods_id = 110104,
		stren_lv = 30,
		rate = 125
	};

get({110105,30}) ->
	#stren_rate_conf{
		key = 297,
		goods_id = 110105,
		stren_lv = 30,
		rate = 250
	};

get({110106,30}) ->
	#stren_rate_conf{
		key = 298,
		goods_id = 110106,
		stren_lv = 30,
		rate = 500
	};

get({110107,30}) ->
	#stren_rate_conf{
		key = 299,
		goods_id = 110107,
		stren_lv = 30,
		rate = 1000
	};

get({110108,30}) ->
	#stren_rate_conf{
		key = 300,
		goods_id = 110108,
		stren_lv = 30,
		rate = 2000
	};

get({110099,31}) ->
	#stren_rate_conf{
		key = 301,
		goods_id = 110099,
		stren_lv = 31,
		rate = 3
	};

get({110100,31}) ->
	#stren_rate_conf{
		key = 302,
		goods_id = 110100,
		stren_lv = 31,
		rate = 7
	};

get({110101,31}) ->
	#stren_rate_conf{
		key = 303,
		goods_id = 110101,
		stren_lv = 31,
		rate = 15
	};

get({110102,31}) ->
	#stren_rate_conf{
		key = 304,
		goods_id = 110102,
		stren_lv = 31,
		rate = 31
	};

get({110103,31}) ->
	#stren_rate_conf{
		key = 305,
		goods_id = 110103,
		stren_lv = 31,
		rate = 62
	};

get({110104,31}) ->
	#stren_rate_conf{
		key = 306,
		goods_id = 110104,
		stren_lv = 31,
		rate = 125
	};

get({110105,31}) ->
	#stren_rate_conf{
		key = 307,
		goods_id = 110105,
		stren_lv = 31,
		rate = 250
	};

get({110106,31}) ->
	#stren_rate_conf{
		key = 308,
		goods_id = 110106,
		stren_lv = 31,
		rate = 500
	};

get({110107,31}) ->
	#stren_rate_conf{
		key = 309,
		goods_id = 110107,
		stren_lv = 31,
		rate = 1000
	};

get({110108,31}) ->
	#stren_rate_conf{
		key = 310,
		goods_id = 110108,
		stren_lv = 31,
		rate = 2000
	};

get({110099,32}) ->
	#stren_rate_conf{
		key = 311,
		goods_id = 110099,
		stren_lv = 32,
		rate = 3
	};

get({110100,32}) ->
	#stren_rate_conf{
		key = 312,
		goods_id = 110100,
		stren_lv = 32,
		rate = 7
	};

get({110101,32}) ->
	#stren_rate_conf{
		key = 313,
		goods_id = 110101,
		stren_lv = 32,
		rate = 15
	};

get({110102,32}) ->
	#stren_rate_conf{
		key = 314,
		goods_id = 110102,
		stren_lv = 32,
		rate = 31
	};

get({110103,32}) ->
	#stren_rate_conf{
		key = 315,
		goods_id = 110103,
		stren_lv = 32,
		rate = 62
	};

get({110104,32}) ->
	#stren_rate_conf{
		key = 316,
		goods_id = 110104,
		stren_lv = 32,
		rate = 125
	};

get({110105,32}) ->
	#stren_rate_conf{
		key = 317,
		goods_id = 110105,
		stren_lv = 32,
		rate = 250
	};

get({110106,32}) ->
	#stren_rate_conf{
		key = 318,
		goods_id = 110106,
		stren_lv = 32,
		rate = 500
	};

get({110107,32}) ->
	#stren_rate_conf{
		key = 319,
		goods_id = 110107,
		stren_lv = 32,
		rate = 1000
	};

get({110108,32}) ->
	#stren_rate_conf{
		key = 320,
		goods_id = 110108,
		stren_lv = 32,
		rate = 2000
	};

get({110099,33}) ->
	#stren_rate_conf{
		key = 321,
		goods_id = 110099,
		stren_lv = 33,
		rate = 3
	};

get({110100,33}) ->
	#stren_rate_conf{
		key = 322,
		goods_id = 110100,
		stren_lv = 33,
		rate = 7
	};

get({110101,33}) ->
	#stren_rate_conf{
		key = 323,
		goods_id = 110101,
		stren_lv = 33,
		rate = 15
	};

get({110102,33}) ->
	#stren_rate_conf{
		key = 324,
		goods_id = 110102,
		stren_lv = 33,
		rate = 31
	};

get({110103,33}) ->
	#stren_rate_conf{
		key = 325,
		goods_id = 110103,
		stren_lv = 33,
		rate = 62
	};

get({110104,33}) ->
	#stren_rate_conf{
		key = 326,
		goods_id = 110104,
		stren_lv = 33,
		rate = 125
	};

get({110105,33}) ->
	#stren_rate_conf{
		key = 327,
		goods_id = 110105,
		stren_lv = 33,
		rate = 250
	};

get({110106,33}) ->
	#stren_rate_conf{
		key = 328,
		goods_id = 110106,
		stren_lv = 33,
		rate = 500
	};

get({110107,33}) ->
	#stren_rate_conf{
		key = 329,
		goods_id = 110107,
		stren_lv = 33,
		rate = 1000
	};

get({110108,33}) ->
	#stren_rate_conf{
		key = 330,
		goods_id = 110108,
		stren_lv = 33,
		rate = 2000
	};

get({110099,34}) ->
	#stren_rate_conf{
		key = 331,
		goods_id = 110099,
		stren_lv = 34,
		rate = 3
	};

get({110100,34}) ->
	#stren_rate_conf{
		key = 332,
		goods_id = 110100,
		stren_lv = 34,
		rate = 7
	};

get({110101,34}) ->
	#stren_rate_conf{
		key = 333,
		goods_id = 110101,
		stren_lv = 34,
		rate = 15
	};

get({110102,34}) ->
	#stren_rate_conf{
		key = 334,
		goods_id = 110102,
		stren_lv = 34,
		rate = 31
	};

get({110103,34}) ->
	#stren_rate_conf{
		key = 335,
		goods_id = 110103,
		stren_lv = 34,
		rate = 62
	};

get({110104,34}) ->
	#stren_rate_conf{
		key = 336,
		goods_id = 110104,
		stren_lv = 34,
		rate = 125
	};

get({110105,34}) ->
	#stren_rate_conf{
		key = 337,
		goods_id = 110105,
		stren_lv = 34,
		rate = 250
	};

get({110106,34}) ->
	#stren_rate_conf{
		key = 338,
		goods_id = 110106,
		stren_lv = 34,
		rate = 500
	};

get({110107,34}) ->
	#stren_rate_conf{
		key = 339,
		goods_id = 110107,
		stren_lv = 34,
		rate = 1000
	};

get({110108,34}) ->
	#stren_rate_conf{
		key = 340,
		goods_id = 110108,
		stren_lv = 34,
		rate = 2000
	};

get({110099,35}) ->
	#stren_rate_conf{
		key = 341,
		goods_id = 110099,
		stren_lv = 35,
		rate = 3
	};

get({110100,35}) ->
	#stren_rate_conf{
		key = 342,
		goods_id = 110100,
		stren_lv = 35,
		rate = 7
	};

get({110101,35}) ->
	#stren_rate_conf{
		key = 343,
		goods_id = 110101,
		stren_lv = 35,
		rate = 15
	};

get({110102,35}) ->
	#stren_rate_conf{
		key = 344,
		goods_id = 110102,
		stren_lv = 35,
		rate = 31
	};

get({110103,35}) ->
	#stren_rate_conf{
		key = 345,
		goods_id = 110103,
		stren_lv = 35,
		rate = 62
	};

get({110104,35}) ->
	#stren_rate_conf{
		key = 346,
		goods_id = 110104,
		stren_lv = 35,
		rate = 125
	};

get({110105,35}) ->
	#stren_rate_conf{
		key = 347,
		goods_id = 110105,
		stren_lv = 35,
		rate = 250
	};

get({110106,35}) ->
	#stren_rate_conf{
		key = 348,
		goods_id = 110106,
		stren_lv = 35,
		rate = 500
	};

get({110107,35}) ->
	#stren_rate_conf{
		key = 349,
		goods_id = 110107,
		stren_lv = 35,
		rate = 1000
	};

get({110108,35}) ->
	#stren_rate_conf{
		key = 350,
		goods_id = 110108,
		stren_lv = 35,
		rate = 2000
	};

get({110099,36}) ->
	#stren_rate_conf{
		key = 351,
		goods_id = 110099,
		stren_lv = 36,
		rate = 3
	};

get({110100,36}) ->
	#stren_rate_conf{
		key = 352,
		goods_id = 110100,
		stren_lv = 36,
		rate = 7
	};

get({110101,36}) ->
	#stren_rate_conf{
		key = 353,
		goods_id = 110101,
		stren_lv = 36,
		rate = 15
	};

get({110102,36}) ->
	#stren_rate_conf{
		key = 354,
		goods_id = 110102,
		stren_lv = 36,
		rate = 31
	};

get({110103,36}) ->
	#stren_rate_conf{
		key = 355,
		goods_id = 110103,
		stren_lv = 36,
		rate = 62
	};

get({110104,36}) ->
	#stren_rate_conf{
		key = 356,
		goods_id = 110104,
		stren_lv = 36,
		rate = 80
	};

get({110105,36}) ->
	#stren_rate_conf{
		key = 357,
		goods_id = 110105,
		stren_lv = 36,
		rate = 200
	};

get({110106,36}) ->
	#stren_rate_conf{
		key = 358,
		goods_id = 110106,
		stren_lv = 36,
		rate = 400
	};

get({110107,36}) ->
	#stren_rate_conf{
		key = 359,
		goods_id = 110107,
		stren_lv = 36,
		rate = 800
	};

get({110108,36}) ->
	#stren_rate_conf{
		key = 360,
		goods_id = 110108,
		stren_lv = 36,
		rate = 1600
	};

get({110099,37}) ->
	#stren_rate_conf{
		key = 361,
		goods_id = 110099,
		stren_lv = 37,
		rate = 3
	};

get({110100,37}) ->
	#stren_rate_conf{
		key = 362,
		goods_id = 110100,
		stren_lv = 37,
		rate = 7
	};

get({110101,37}) ->
	#stren_rate_conf{
		key = 363,
		goods_id = 110101,
		stren_lv = 37,
		rate = 15
	};

get({110102,37}) ->
	#stren_rate_conf{
		key = 364,
		goods_id = 110102,
		stren_lv = 37,
		rate = 31
	};

get({110103,37}) ->
	#stren_rate_conf{
		key = 365,
		goods_id = 110103,
		stren_lv = 37,
		rate = 62
	};

get({110104,37}) ->
	#stren_rate_conf{
		key = 366,
		goods_id = 110104,
		stren_lv = 37,
		rate = 80
	};

get({110105,37}) ->
	#stren_rate_conf{
		key = 367,
		goods_id = 110105,
		stren_lv = 37,
		rate = 200
	};

get({110106,37}) ->
	#stren_rate_conf{
		key = 368,
		goods_id = 110106,
		stren_lv = 37,
		rate = 400
	};

get({110107,37}) ->
	#stren_rate_conf{
		key = 369,
		goods_id = 110107,
		stren_lv = 37,
		rate = 800
	};

get({110108,37}) ->
	#stren_rate_conf{
		key = 370,
		goods_id = 110108,
		stren_lv = 37,
		rate = 1600
	};

get({110099,38}) ->
	#stren_rate_conf{
		key = 371,
		goods_id = 110099,
		stren_lv = 38,
		rate = 3
	};

get({110100,38}) ->
	#stren_rate_conf{
		key = 372,
		goods_id = 110100,
		stren_lv = 38,
		rate = 7
	};

get({110101,38}) ->
	#stren_rate_conf{
		key = 373,
		goods_id = 110101,
		stren_lv = 38,
		rate = 15
	};

get({110102,38}) ->
	#stren_rate_conf{
		key = 374,
		goods_id = 110102,
		stren_lv = 38,
		rate = 31
	};

get({110103,38}) ->
	#stren_rate_conf{
		key = 375,
		goods_id = 110103,
		stren_lv = 38,
		rate = 62
	};

get({110104,38}) ->
	#stren_rate_conf{
		key = 376,
		goods_id = 110104,
		stren_lv = 38,
		rate = 80
	};

get({110105,38}) ->
	#stren_rate_conf{
		key = 377,
		goods_id = 110105,
		stren_lv = 38,
		rate = 200
	};

get({110106,38}) ->
	#stren_rate_conf{
		key = 378,
		goods_id = 110106,
		stren_lv = 38,
		rate = 400
	};

get({110107,38}) ->
	#stren_rate_conf{
		key = 379,
		goods_id = 110107,
		stren_lv = 38,
		rate = 800
	};

get({110108,38}) ->
	#stren_rate_conf{
		key = 380,
		goods_id = 110108,
		stren_lv = 38,
		rate = 1600
	};

get({110099,39}) ->
	#stren_rate_conf{
		key = 381,
		goods_id = 110099,
		stren_lv = 39,
		rate = 3
	};

get({110100,39}) ->
	#stren_rate_conf{
		key = 382,
		goods_id = 110100,
		stren_lv = 39,
		rate = 7
	};

get({110101,39}) ->
	#stren_rate_conf{
		key = 383,
		goods_id = 110101,
		stren_lv = 39,
		rate = 15
	};

get({110102,39}) ->
	#stren_rate_conf{
		key = 384,
		goods_id = 110102,
		stren_lv = 39,
		rate = 31
	};

get({110103,39}) ->
	#stren_rate_conf{
		key = 385,
		goods_id = 110103,
		stren_lv = 39,
		rate = 62
	};

get({110104,39}) ->
	#stren_rate_conf{
		key = 386,
		goods_id = 110104,
		stren_lv = 39,
		rate = 80
	};

get({110105,39}) ->
	#stren_rate_conf{
		key = 387,
		goods_id = 110105,
		stren_lv = 39,
		rate = 200
	};

get({110106,39}) ->
	#stren_rate_conf{
		key = 388,
		goods_id = 110106,
		stren_lv = 39,
		rate = 400
	};

get({110107,39}) ->
	#stren_rate_conf{
		key = 389,
		goods_id = 110107,
		stren_lv = 39,
		rate = 800
	};

get({110108,39}) ->
	#stren_rate_conf{
		key = 390,
		goods_id = 110108,
		stren_lv = 39,
		rate = 1600
	};

get({110099,40}) ->
	#stren_rate_conf{
		key = 391,
		goods_id = 110099,
		stren_lv = 40,
		rate = 3
	};

get({110100,40}) ->
	#stren_rate_conf{
		key = 392,
		goods_id = 110100,
		stren_lv = 40,
		rate = 7
	};

get({110101,40}) ->
	#stren_rate_conf{
		key = 393,
		goods_id = 110101,
		stren_lv = 40,
		rate = 15
	};

get({110102,40}) ->
	#stren_rate_conf{
		key = 394,
		goods_id = 110102,
		stren_lv = 40,
		rate = 31
	};

get({110103,40}) ->
	#stren_rate_conf{
		key = 395,
		goods_id = 110103,
		stren_lv = 40,
		rate = 62
	};

get({110104,40}) ->
	#stren_rate_conf{
		key = 396,
		goods_id = 110104,
		stren_lv = 40,
		rate = 80
	};

get({110105,40}) ->
	#stren_rate_conf{
		key = 397,
		goods_id = 110105,
		stren_lv = 40,
		rate = 200
	};

get({110106,40}) ->
	#stren_rate_conf{
		key = 398,
		goods_id = 110106,
		stren_lv = 40,
		rate = 400
	};

get({110107,40}) ->
	#stren_rate_conf{
		key = 399,
		goods_id = 110107,
		stren_lv = 40,
		rate = 800
	};

get({110108,40}) ->
	#stren_rate_conf{
		key = 400,
		goods_id = 110108,
		stren_lv = 40,
		rate = 1600
	};

get(_Key) ->
	?ERR("undefined key from stren_rate_config ~p", [_Key]).