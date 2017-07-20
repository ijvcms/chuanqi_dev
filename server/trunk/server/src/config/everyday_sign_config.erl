%%%-------------------------------------------------------------------
%%% @author zhengsiying
%%% @doc
%%%		自动生成文件，不要手动修改
%%% @end
%%% Created : 2016/10/12
%%%-------------------------------------------------------------------

-module(everyday_sign_config).

-include("common.hrl").
-include("config.hrl").

-compile([export_all]).

get_list() ->
	[{2016,2,1}, {2016,2,2}, {2016,2,3}, {2016,2,4}, {2016,2,5}, {2016,2,6}, {2016,2,7}, {2016,2,8}, {2016,2,9}, {2016,2,10}, {2016,2,11}, {2016,2,12}, {2016,2,13}, {2016,2,14}, {2016,2,15}, {2016,2,16}, {2016,2,17}, {2016,2,18}, {2016,2,19}, {2016,2,20}, {2016,2,21}, {2016,2,22}, {2016,2,23}, {2016,2,24}, {2016,2,25}, {2016,2,26}, {2016,2,27}, {2016,2,28}, {2016,2,29}, {2016,3,1}, {2016,3,2}, {2016,3,3}, {2016,3,4}, {2016,3,5}, {2016,3,6}, {2016,3,7}, {2016,3,8}, {2016,3,9}, {2016,3,10}, {2016,3,11}, {2016,3,12}, {2016,3,13}, {2016,3,14}, {2016,3,15}, {2016,3,16}, {2016,3,17}, {2016,3,18}, {2016,3,19}, {2016,3,20}, {2016,3,21}, {2016,3,22}, {2016,3,23}, {2016,3,24}, {2016,3,25}, {2016,3,26}, {2016,3,27}, {2016,3,28}, {2016,3,29}, {2016,3,30}, {2016,3,31}, {2016,4,1}, {2016,4,2}, {2016,4,3}, {2016,4,4}, {2016,4,5}, {2016,4,6}, {2016,4,7}, {2016,4,8}, {2016,4,9}, {2016,4,10}, {2016,4,11}, {2016,4,12}, {2016,4,13}, {2016,4,14}, {2016,4,15}, {2016,4,16}, {2016,4,17}, {2016,4,18}, {2016,4,19}, {2016,4,20}, {2016,4,21}, {2016,4,22}, {2016,4,23}, {2016,4,24}, {2016,4,25}, {2016,4,26}, {2016,4,27}, {2016,4,28}, {2016,4,29}, {2016,4,30}, {2016,5,1}, {2016,5,2}, {2016,5,3}, {2016,5,4}, {2016,5,5}, {2016,5,6}, {2016,5,7}, {2016,5,8}, {2016,5,9}, {2016,5,10}, {2016,5,11}, {2016,5,12}, {2016,5,13}, {2016,5,14}, {2016,5,15}, {2016,5,16}, {2016,5,17}, {2016,5,18}, {2016,5,19}, {2016,5,20}, {2016,5,21}, {2016,5,22}, {2016,5,23}, {2016,5,24}, {2016,5,25}, {2016,5,26}, {2016,5,27}, {2016,5,28}, {2016,5,29}, {2016,5,30}, {2016,5,31}, {2016,6,1}, {2016,6,2}, {2016,6,3}, {2016,6,4}, {2016,6,5}, {2016,6,6}, {2016,6,7}, {2016,6,8}, {2016,6,9}, {2016,6,10}, {2016,6,11}, {2016,6,12}, {2016,6,13}, {2016,6,14}, {2016,6,15}, {2016,6,16}, {2016,6,17}, {2016,6,18}, {2016,6,19}, {2016,6,20}, {2016,6,21}, {2016,6,22}, {2016,6,23}, {2016,6,24}, {2016,6,25}, {2016,6,26}, {2016,6,27}, {2016,6,28}, {2016,6,29}, {2016,6,30}, {2016,7,1}, {2016,7,2}, {2016,7,3}, {2016,7,4}, {2016,7,5}, {2016,7,6}, {2016,7,7}, {2016,7,8}, {2016,7,9}, {2016,7,10}, {2016,7,11}, {2016,7,12}, {2016,7,13}, {2016,7,14}, {2016,7,15}, {2016,7,16}, {2016,7,17}, {2016,7,18}, {2016,7,19}, {2016,7,20}, {2016,7,21}, {2016,7,22}, {2016,7,23}, {2016,7,24}, {2016,7,25}, {2016,7,26}, {2016,7,27}, {2016,7,28}, {2016,7,29}, {2016,7,30}, {2016,7,31}, {2016,8,1}, {2016,8,2}, {2016,8,3}, {2016,8,4}, {2016,8,5}, {2016,8,6}, {2016,8,7}, {2016,8,8}, {2016,8,9}, {2016,8,10}, {2016,8,11}, {2016,8,12}, {2016,8,13}, {2016,8,14}, {2016,8,15}, {2016,8,16}, {2016,8,17}, {2016,8,18}, {2016,8,19}, {2016,8,20}, {2016,8,21}, {2016,8,22}, {2016,8,23}, {2016,8,24}, {2016,8,25}, {2016,8,26}, {2016,8,27}, {2016,8,28}, {2016,8,29}, {2016,8,30}, {2016,8,31}, {2016,9,1}, {2016,9,2}, {2016,9,3}, {2016,9,4}, {2016,9,5}, {2016,9,6}, {2016,9,7}, {2016,9,8}, {2016,9,9}, {2016,9,10}, {2016,9,11}, {2016,9,12}, {2016,9,13}, {2016,9,14}, {2016,9,15}, {2016,9,16}, {2016,9,17}, {2016,9,18}, {2016,9,19}, {2016,9,20}, {2016,9,21}, {2016,9,22}, {2016,9,23}, {2016,9,24}, {2016,9,25}, {2016,9,26}, {2016,9,27}, {2016,9,28}, {2016,9,29}, {2016,9,30}, {2016,10,1}, {2016,10,2}, {2016,10,3}, {2016,10,4}, {2016,10,5}, {2016,10,6}, {2016,10,7}, {2016,10,8}, {2016,10,9}, {2016,10,10}, {2016,10,11}, {2016,10,12}, {2016,10,13}, {2016,10,14}, {2016,10,15}, {2016,10,16}, {2016,10,17}, {2016,10,18}, {2016,10,19}, {2016,10,20}, {2016,10,21}, {2016,10,22}, {2016,10,23}, {2016,10,24}, {2016,10,25}, {2016,10,26}, {2016,10,27}, {2016,10,28}, {2016,10,29}, {2016,10,30}, {2016,10,31}, {2016,11,1}, {2016,11,2}, {2016,11,3}, {2016,11,4}, {2016,11,5}, {2016,11,6}, {2016,11,7}, {2016,11,8}, {2016,11,9}, {2016,11,10}, {2016,11,11}, {2016,11,12}, {2016,11,13}, {2016,11,14}, {2016,11,15}, {2016,11,16}, {2016,11,17}, {2016,11,18}, {2016,11,19}, {2016,11,20}, {2016,11,21}, {2016,11,22}, {2016,11,23}, {2016,11,24}, {2016,11,25}, {2016,11,26}, {2016,11,27}, {2016,11,28}, {2016,11,29}, {2016,11,30}, {2016,12,1}, {2016,12,2}, {2016,12,3}, {2016,12,4}, {2016,12,5}, {2016,12,6}, {2016,12,7}, {2016,12,8}, {2016,12,9}, {2016,12,10}, {2016,12,11}, {2016,12,12}, {2016,12,13}, {2016,12,14}, {2016,12,15}, {2016,12,16}, {2016,12,17}, {2016,12,18}, {2016,12,19}, {2016,12,20}, {2016,12,21}, {2016,12,22}, {2016,12,23}, {2016,12,24}, {2016,12,25}, {2016,12,26}, {2016,12,27}, {2016,12,28}, {2016,12,29}, {2016,12,30}, {2016,12,31}, {2017,1,1}, {2017,1,2}, {2017,1,3}, {2017,1,4}, {2017,1,5}, {2017,1,6}, {2017,1,7}, {2017,1,8}, {2017,1,9}, {2017,1,10}, {2017,1,11}, {2017,1,12}, {2017,1,13}, {2017,1,14}, {2017,1,15}, {2017,1,16}, {2017,1,17}, {2017,1,18}, {2017,1,19}, {2017,1,20}, {2017,1,21}, {2017,1,22}, {2017,1,23}, {2017,1,24}, {2017,1,25}, {2017,1,26}, {2017,1,27}, {2017,1,28}, {2017,1,29}, {2017,1,30}, {2017,1,31}, {2017,2,1}, {2017,2,2}, {2017,2,3}, {2017,2,4}, {2017,2,5}, {2017,2,6}, {2017,2,7}, {2017,2,8}, {2017,2,9}, {2017,2,10}, {2017,2,11}, {2017,2,12}, {2017,2,13}, {2017,2,14}, {2017,2,15}, {2017,2,16}, {2017,2,17}, {2017,2,18}, {2017,2,19}, {2017,2,20}, {2017,2,21}, {2017,2,22}, {2017,2,23}, {2017,2,24}, {2017,2,25}, {2017,2,26}, {2017,2,27}, {2017,2,28}, {2017,3,1}, {2017,3,2}, {2017,3,3}, {2017,3,4}, {2017,3,5}, {2017,3,6}, {2017,3,7}, {2017,3,8}, {2017,3,9}, {2017,3,10}, {2017,3,11}, {2017,3,12}, {2017,3,13}, {2017,3,14}, {2017,3,15}, {2017,3,16}, {2017,3,17}, {2017,3,18}, {2017,3,19}, {2017,3,20}, {2017,3,21}, {2017,3,22}, {2017,3,23}, {2017,3,24}, {2017,3,25}, {2017,3,26}, {2017,3,27}, {2017,3,28}, {2017,3,29}, {2017,3,30}, {2017,3,31}, {2017,4,1}, {2017,4,2}, {2017,4,3}, {2017,4,4}, {2017,4,5}, {2017,4,6}, {2017,4,7}, {2017,4,8}, {2017,4,9}, {2017,4,10}, {2017,4,11}, {2017,4,12}, {2017,4,13}, {2017,4,14}, {2017,4,15}, {2017,4,16}, {2017,4,17}, {2017,4,18}, {2017,4,19}, {2017,4,20}, {2017,4,21}, {2017,4,22}, {2017,4,23}, {2017,4,24}, {2017,4,25}, {2017,4,26}, {2017,4,27}, {2017,4,28}, {2017,4,29}, {2017,4,30}, {2017,5,1}, {2017,5,2}, {2017,5,3}, {2017,5,4}, {2017,5,5}, {2017,5,6}, {2017,5,7}, {2017,5,8}, {2017,5,9}, {2017,5,10}, {2017,5,11}, {2017,5,12}, {2017,5,13}, {2017,5,14}, {2017,5,15}, {2017,5,16}, {2017,5,17}, {2017,5,18}, {2017,5,19}, {2017,5,20}, {2017,5,21}, {2017,5,22}, {2017,5,23}, {2017,5,24}, {2017,5,25}, {2017,5,26}, {2017,5,27}, {2017,5,28}, {2017,5,29}, {2017,5,30}, {2017,5,31}, {2017,6,1}, {2017,6,2}, {2017,6,3}, {2017,6,4}, {2017,6,5}, {2017,6,6}, {2017,6,7}, {2017,6,8}, {2017,6,9}, {2017,6,10}, {2017,6,11}, {2017,6,12}, {2017,6,13}, {2017,6,14}, {2017,6,15}, {2017,6,16}, {2017,6,17}, {2017,6,18}, {2017,6,19}, {2017,6,20}, {2017,6,21}, {2017,6,22}, {2017,6,23}, {2017,6,24}, {2017,6,25}, {2017,6,26}, {2017,6,27}, {2017,6,28}, {2017,6,29}, {2017,6,30}, {2017,7,1}, {2017,7,2}, {2017,7,3}, {2017,7,4}, {2017,7,5}, {2017,7,6}, {2017,7,7}, {2017,7,8}, {2017,7,9}, {2017,7,10}, {2017,7,11}, {2017,7,12}, {2017,7,13}, {2017,7,14}, {2017,7,15}, {2017,7,16}, {2017,7,17}, {2017,7,18}, {2017,7,19}, {2017,7,20}, {2017,7,21}, {2017,7,22}, {2017,7,23}, {2017,7,24}, {2017,7,25}, {2017,7,26}, {2017,7,27}, {2017,7,28}, {2017,7,29}, {2017,7,30}, {2017,7,31}, {2017,8,1}, {2017,8,2}, {2017,8,3}, {2017,8,4}, {2017,8,5}, {2017,8,6}, {2017,8,7}, {2017,8,8}, {2017,8,9}, {2017,8,10}, {2017,8,11}, {2017,8,12}, {2017,8,13}, {2017,8,14}, {2017,8,15}, {2017,8,16}, {2017,8,17}, {2017,8,18}, {2017,8,19}, {2017,8,20}, {2017,8,21}, {2017,8,22}, {2017,8,23}, {2017,8,24}, {2017,8,25}, {2017,8,26}, {2017,8,27}, {2017,8,28}, {2017,8,29}, {2017,8,30}, {2017,8,31}, {2017,9,1}, {2017,9,2}, {2017,9,3}, {2017,9,4}, {2017,9,5}, {2017,9,6}, {2017,9,7}, {2017,9,8}, {2017,9,9}, {2017,9,10}, {2017,9,11}, {2017,9,12}, {2017,9,13}, {2017,9,14}, {2017,9,15}, {2017,9,16}, {2017,9,17}, {2017,9,18}, {2017,9,19}, {2017,9,20}, {2017,9,21}, {2017,9,22}, {2017,9,23}, {2017,9,24}, {2017,9,25}, {2017,9,26}, {2017,9,27}, {2017,9,28}, {2017,9,29}, {2017,9,30}, {2017,10,1}, {2017,10,2}, {2017,10,3}, {2017,10,4}, {2017,10,5}, {2017,10,6}, {2017,10,7}, {2017,10,8}, {2017,10,9}, {2017,10,10}, {2017,10,11}, {2017,10,12}, {2017,10,13}, {2017,10,14}, {2017,10,15}, {2017,10,16}, {2017,10,17}, {2017,10,18}, {2017,10,19}, {2017,10,20}, {2017,10,21}, {2017,10,22}, {2017,10,23}, {2017,10,24}, {2017,10,25}, {2017,10,26}, {2017,10,27}, {2017,10,28}, {2017,10,29}, {2017,10,30}, {2017,10,31}, {2017,11,1}, {2017,11,2}, {2017,11,3}, {2017,11,4}, {2017,11,5}, {2017,11,6}, {2017,11,7}, {2017,11,8}, {2017,11,9}, {2017,11,10}, {2017,11,11}, {2017,11,12}, {2017,11,13}, {2017,11,14}, {2017,11,15}, {2017,11,16}, {2017,11,17}, {2017,11,18}, {2017,11,19}, {2017,11,20}, {2017,11,21}, {2017,11,22}, {2017,11,23}, {2017,11,24}, {2017,11,25}, {2017,11,26}, {2017,11,27}, {2017,11,28}, {2017,11,29}, {2017,11,30}, {2017,12,1}, {2017,12,2}, {2017,12,3}, {2017,12,4}, {2017,12,5}, {2017,12,6}, {2017,12,7}, {2017,12,8}, {2017,12,9}, {2017,12,10}, {2017,12,11}, {2017,12,12}, {2017,12,13}, {2017,12,14}, {2017,12,15}, {2017,12,16}, {2017,12,17}, {2017,12,18}, {2017,12,19}, {2017,12,20}, {2017,12,21}, {2017,12,22}, {2017,12,23}, {2017,12,24}, {2017,12,25}, {2017,12,26}, {2017,12,27}, {2017,12,28}, {2017,12,29}, {2017,12,30}, {2017,12,31}, {2018,1,1}, {2018,1,2}, {2018,1,3}, {2018,1,4}, {2018,1,5}, {2018,1,6}, {2018,1,7}, {2018,1,8}, {2018,1,9}, {2018,1,10}, {2018,1,11}, {2018,1,12}, {2018,1,13}, {2018,1,14}, {2018,1,15}, {2018,1,16}, {2018,1,17}, {2018,1,18}, {2018,1,19}, {2018,1,20}, {2018,1,21}, {2018,1,22}, {2018,1,23}, {2018,1,24}, {2018,1,25}, {2018,1,26}, {2018,1,27}, {2018,1,28}, {2018,1,29}, {2018,1,30}, {2018,1,31}, {2018,2,1}, {2018,2,2}, {2018,2,3}, {2018,2,4}, {2018,2,5}, {2018,2,6}, {2018,2,7}, {2018,2,8}, {2018,2,9}, {2018,2,10}, {2018,2,11}, {2018,2,12}, {2018,2,13}, {2018,2,14}, {2018,2,15}, {2018,2,16}, {2018,2,17}, {2018,2,18}, {2018,2,19}, {2018,2,20}, {2018,2,21}, {2018,2,22}, {2018,2,23}, {2018,2,24}, {2018,2,25}, {2018,2,26}, {2018,2,27}, {2018,2,28}, {2018,3,1}, {2018,3,2}, {2018,3,3}, {2018,3,4}, {2018,3,5}, {2018,3,6}, {2018,3,7}, {2018,3,8}, {2018,3,9}, {2018,3,10}, {2018,3,11}, {2018,3,12}, {2018,3,13}, {2018,3,14}, {2018,3,15}, {2018,3,16}, {2018,3,17}, {2018,3,18}, {2018,3,19}, {2018,3,20}, {2018,3,21}, {2018,3,22}, {2018,3,23}, {2018,3,24}, {2018,3,25}, {2018,3,26}, {2018,3,27}, {2018,3,28}, {2018,3,29}, {2018,3,30}, {2018,3,31}, {2018,4,1}, {2018,4,2}, {2018,4,3}, {2018,4,4}, {2018,4,5}, {2018,4,6}, {2018,4,7}, {2018,4,8}, {2018,4,9}, {2018,4,10}, {2018,4,11}, {2018,4,12}, {2018,4,13}, {2018,4,14}, {2018,4,15}, {2018,4,16}, {2018,4,17}, {2018,4,18}, {2018,4,19}, {2018,4,20}, {2018,4,21}, {2018,4,22}, {2018,4,23}, {2018,4,24}, {2018,4,25}, {2018,4,26}, {2018,4,27}, {2018,4,28}, {2018,4,29}, {2018,4,30}, {2018,5,1}, {2018,5,2}, {2018,5,3}, {2018,5,4}, {2018,5,5}, {2018,5,6}, {2018,5,7}, {2018,5,8}, {2018,5,9}, {2018,5,10}, {2018,5,11}, {2018,5,12}, {2018,5,13}, {2018,5,14}, {2018,5,15}, {2018,5,16}, {2018,5,17}, {2018,5,18}, {2018,5,19}, {2018,5,20}, {2018,5,21}, {2018,5,22}, {2018,5,23}, {2018,5,24}, {2018,5,25}, {2018,5,26}, {2018,5,27}, {2018,5,28}, {2018,5,29}, {2018,5,30}, {2018,5,31}, {2018,6,1}, {2018,6,2}, {2018,6,3}, {2018,6,4}, {2018,6,5}, {2018,6,6}, {2018,6,7}, {2018,6,8}, {2018,6,9}, {2018,6,10}, {2018,6,11}, {2018,6,12}, {2018,6,13}, {2018,6,14}, {2018,6,15}, {2018,6,16}, {2018,6,17}, {2018,6,18}, {2018,6,19}, {2018,6,20}, {2018,6,21}, {2018,6,22}, {2018,6,23}, {2018,6,24}, {2018,6,25}, {2018,6,26}, {2018,6,27}, {2018,6,28}, {2018,6,29}, {2018,6,30}, {2018,7,1}, {2018,7,2}, {2018,7,3}, {2018,7,4}, {2018,7,5}, {2018,7,6}, {2018,7,7}, {2018,7,8}, {2018,7,9}, {2018,7,10}, {2018,7,11}, {2018,7,12}, {2018,7,13}, {2018,7,14}, {2018,7,15}, {2018,7,16}, {2018,7,17}, {2018,7,18}, {2018,7,19}, {2018,7,20}, {2018,7,21}, {2018,7,22}, {2018,7,23}, {2018,7,24}, {2018,7,25}, {2018,7,26}, {2018,7,27}, {2018,7,28}, {2018,7,29}, {2018,7,30}, {2018,7,31}, {2018,8,1}, {2018,8,2}, {2018,8,3}, {2018,8,4}, {2018,8,5}, {2018,8,6}, {2018,8,7}, {2018,8,8}, {2018,8,9}, {2018,8,10}, {2018,8,11}, {2018,8,12}, {2018,8,13}, {2018,8,14}, {2018,8,15}, {2018,8,16}, {2018,8,17}, {2018,8,18}, {2018,8,19}, {2018,8,20}, {2018,8,21}, {2018,8,22}, {2018,8,23}, {2018,8,24}, {2018,8,25}, {2018,8,26}, {2018,8,27}, {2018,8,28}, {2018,8,29}, {2018,8,30}, {2018,8,31}, {2018,9,1}, {2018,9,2}, {2018,9,3}, {2018,9,4}, {2018,9,5}, {2018,9,6}, {2018,9,7}, {2018,9,8}, {2018,9,9}, {2018,9,10}, {2018,9,11}, {2018,9,12}, {2018,9,13}, {2018,9,14}, {2018,9,15}, {2018,9,16}, {2018,9,17}, {2018,9,18}, {2018,9,19}, {2018,9,20}, {2018,9,21}, {2018,9,22}, {2018,9,23}, {2018,9,24}, {2018,9,25}, {2018,9,26}, {2018,9,27}, {2018,9,28}, {2018,9,29}, {2018,9,30}, {2018,10,1}, {2018,10,2}, {2018,10,3}, {2018,10,4}, {2018,10,5}, {2018,10,6}, {2018,10,7}, {2018,10,8}, {2018,10,9}, {2018,10,10}, {2018,10,11}, {2018,10,12}, {2018,10,13}, {2018,10,14}, {2018,10,15}, {2018,10,16}, {2018,10,17}, {2018,10,18}, {2018,10,19}, {2018,10,20}, {2018,10,21}, {2018,10,22}, {2018,10,23}, {2018,10,24}, {2018,10,25}, {2018,10,26}, {2018,10,27}, {2018,10,28}, {2018,10,29}, {2018,10,30}, {2018,10,31}, {2018,11,1}, {2018,11,2}, {2018,11,3}, {2018,11,4}, {2018,11,5}, {2018,11,6}, {2018,11,7}, {2018,11,8}, {2018,11,9}, {2018,11,10}, {2018,11,11}, {2018,11,12}, {2018,11,13}, {2018,11,14}, {2018,11,15}, {2018,11,16}, {2018,11,17}, {2018,11,18}, {2018,11,19}, {2018,11,20}, {2018,11,21}, {2018,11,22}, {2018,11,23}, {2018,11,24}, {2018,11,25}, {2018,11,26}, {2018,11,27}, {2018,11,28}, {2018,11,29}, {2018,11,30}, {2018,12,1}, {2018,12,2}, {2018,12,3}, {2018,12,4}, {2018,12,5}, {2018,12,6}, {2018,12,7}, {2018,12,8}, {2018,12,9}, {2018,12,10}, {2018,12,11}, {2018,12,12}, {2018,12,13}, {2018,12,14}, {2018,12,15}, {2018,12,16}, {2018,12,17}, {2018,12,18}, {2018,12,19}, {2018,12,20}, {2018,12,21}, {2018,12,22}, {2018,12,23}, {2018,12,24}, {2018,12,25}, {2018,12,26}, {2018,12,27}, {2018,12,28}, {2018,12,29}, {2018,12,30}, {2018,12,31}].

get({2016,2,1}) ->
	#everyday_sign_conf{
		key = 1,
		year = 2016,
		month = 2,
		count = 1,
		reward = [],
		is_double = 0,
		vip_double = 0
	};

get({2016,2,2}) ->
	#everyday_sign_conf{
		key = 2,
		year = 2016,
		month = 2,
		count = 2,
		reward = [{110050,1,1},{110045,1,200},{110148,1,1},{110127,1,50}],
		is_double = 1,
		vip_double = 1
	};

get({2016,2,3}) ->
	#everyday_sign_conf{
		key = 3,
		year = 2016,
		month = 2,
		count = 3,
		reward = [],
		is_double = 0,
		vip_double = 0
	};

get({2016,2,4}) ->
	#everyday_sign_conf{
		key = 4,
		year = 2016,
		month = 2,
		count = 4,
		reward = [],
		is_double = 1,
		vip_double = 1
	};

get({2016,2,5}) ->
	#everyday_sign_conf{
		key = 5,
		year = 2016,
		month = 2,
		count = 5,
		reward = [{110050,1,1},{110045,1,300},{110148,1,1},{110127,1,100}],
		is_double = 0,
		vip_double = 0
	};

get({2016,2,6}) ->
	#everyday_sign_conf{
		key = 6,
		year = 2016,
		month = 2,
		count = 6,
		reward = [],
		is_double = 1,
		vip_double = 2
	};

get({2016,2,7}) ->
	#everyday_sign_conf{
		key = 7,
		year = 2016,
		month = 2,
		count = 7,
		reward = [],
		is_double = 0,
		vip_double = 0
	};

get({2016,2,8}) ->
	#everyday_sign_conf{
		key = 8,
		year = 2016,
		month = 2,
		count = 8,
		reward = [],
		is_double = 1,
		vip_double = 2
	};

get({2016,2,9}) ->
	#everyday_sign_conf{
		key = 9,
		year = 2016,
		month = 2,
		count = 9,
		reward = [],
		is_double = 0,
		vip_double = 0
	};

get({2016,2,10}) ->
	#everyday_sign_conf{
		key = 10,
		year = 2016,
		month = 2,
		count = 10,
		reward = [{110050,1,1},{110045,1,400},{110148,1,1},{110127,1,150}],
		is_double = 1,
		vip_double = 3
	};

get({2016,2,11}) ->
	#everyday_sign_conf{
		key = 11,
		year = 2016,
		month = 2,
		count = 11,
		reward = [],
		is_double = 0,
		vip_double = 0
	};

get({2016,2,12}) ->
	#everyday_sign_conf{
		key = 12,
		year = 2016,
		month = 2,
		count = 12,
		reward = [],
		is_double = 1,
		vip_double = 4
	};

get({2016,2,13}) ->
	#everyday_sign_conf{
		key = 13,
		year = 2016,
		month = 2,
		count = 13,
		reward = [],
		is_double = 0,
		vip_double = 0
	};

get({2016,2,14}) ->
	#everyday_sign_conf{
		key = 14,
		year = 2016,
		month = 2,
		count = 14,
		reward = [],
		is_double = 1,
		vip_double = 5
	};

get({2016,2,15}) ->
	#everyday_sign_conf{
		key = 15,
		year = 2016,
		month = 2,
		count = 15,
		reward = [],
		is_double = 0,
		vip_double = 0
	};

get({2016,2,16}) ->
	#everyday_sign_conf{
		key = 16,
		year = 2016,
		month = 2,
		count = 16,
		reward = [],
		is_double = 1,
		vip_double = 6
	};

get({2016,2,17}) ->
	#everyday_sign_conf{
		key = 17,
		year = 2016,
		month = 2,
		count = 17,
		reward = [{110050,1,1},{110045,1,500},{110148,1,2},{110127,1,200}],
		is_double = 0,
		vip_double = 0
	};

get({2016,2,18}) ->
	#everyday_sign_conf{
		key = 18,
		year = 2016,
		month = 2,
		count = 18,
		reward = [],
		is_double = 1,
		vip_double = 7
	};

get({2016,2,19}) ->
	#everyday_sign_conf{
		key = 19,
		year = 2016,
		month = 2,
		count = 19,
		reward = [],
		is_double = 0,
		vip_double = 0
	};

get({2016,2,20}) ->
	#everyday_sign_conf{
		key = 20,
		year = 2016,
		month = 2,
		count = 20,
		reward = [],
		is_double = 1,
		vip_double = 8
	};

get({2016,2,21}) ->
	#everyday_sign_conf{
		key = 21,
		year = 2016,
		month = 2,
		count = 21,
		reward = [],
		is_double = 0,
		vip_double = 0
	};

get({2016,2,22}) ->
	#everyday_sign_conf{
		key = 22,
		year = 2016,
		month = 2,
		count = 22,
		reward = [],
		is_double = 1,
		vip_double = 9
	};

get({2016,2,23}) ->
	#everyday_sign_conf{
		key = 23,
		year = 2016,
		month = 2,
		count = 23,
		reward = [],
		is_double = 0,
		vip_double = 0
	};

get({2016,2,24}) ->
	#everyday_sign_conf{
		key = 24,
		year = 2016,
		month = 2,
		count = 24,
		reward = [],
		is_double = 1,
		vip_double = 10
	};

get({2016,2,25}) ->
	#everyday_sign_conf{
		key = 25,
		year = 2016,
		month = 2,
		count = 25,
		reward = [],
		is_double = 0,
		vip_double = 0
	};

get({2016,2,26}) ->
	#everyday_sign_conf{
		key = 26,
		year = 2016,
		month = 2,
		count = 26,
		reward = [{110050,1,1},{110045,1,600},{110149,1,1},{110140,1,10}],
		is_double = 1,
		vip_double = 11
	};

get({2016,2,27}) ->
	#everyday_sign_conf{
		key = 27,
		year = 2016,
		month = 2,
		count = 27,
		reward = [],
		is_double = 0,
		vip_double = 0
	};

get({2016,2,28}) ->
	#everyday_sign_conf{
		key = 28,
		year = 2016,
		month = 2,
		count = 28,
		reward = [],
		is_double = 1,
		vip_double = 12
	};

get({2016,2,29}) ->
	#everyday_sign_conf{
		key = 29,
		year = 2016,
		month = 2,
		count = 29,
		reward = [],
		is_double = 0,
		vip_double = 0
	};

get({2016,3,1}) ->
	#everyday_sign_conf{
		key = 30,
		year = 2016,
		month = 3,
		count = 1,
		reward = [],
		is_double = 0,
		vip_double = 0
	};

get({2016,3,2}) ->
	#everyday_sign_conf{
		key = 31,
		year = 2016,
		month = 3,
		count = 2,
		reward = [{110050,1,1},{110045,1,200},{110148,1,1},{110127,1,50}],
		is_double = 1,
		vip_double = 1
	};

get({2016,3,3}) ->
	#everyday_sign_conf{
		key = 32,
		year = 2016,
		month = 3,
		count = 3,
		reward = [],
		is_double = 0,
		vip_double = 0
	};

get({2016,3,4}) ->
	#everyday_sign_conf{
		key = 33,
		year = 2016,
		month = 3,
		count = 4,
		reward = [],
		is_double = 1,
		vip_double = 1
	};

get({2016,3,5}) ->
	#everyday_sign_conf{
		key = 34,
		year = 2016,
		month = 3,
		count = 5,
		reward = [{110050,1,1},{110045,1,300},{110148,1,1},{110127,1,100}],
		is_double = 0,
		vip_double = 0
	};

get({2016,3,6}) ->
	#everyday_sign_conf{
		key = 35,
		year = 2016,
		month = 3,
		count = 6,
		reward = [],
		is_double = 1,
		vip_double = 2
	};

get({2016,3,7}) ->
	#everyday_sign_conf{
		key = 36,
		year = 2016,
		month = 3,
		count = 7,
		reward = [],
		is_double = 0,
		vip_double = 0
	};

get({2016,3,8}) ->
	#everyday_sign_conf{
		key = 37,
		year = 2016,
		month = 3,
		count = 8,
		reward = [],
		is_double = 1,
		vip_double = 2
	};

get({2016,3,9}) ->
	#everyday_sign_conf{
		key = 38,
		year = 2016,
		month = 3,
		count = 9,
		reward = [],
		is_double = 0,
		vip_double = 0
	};

get({2016,3,10}) ->
	#everyday_sign_conf{
		key = 39,
		year = 2016,
		month = 3,
		count = 10,
		reward = [{110050,1,1},{110045,1,400},{110148,1,1},{110127,1,150}],
		is_double = 1,
		vip_double = 3
	};

get({2016,3,11}) ->
	#everyday_sign_conf{
		key = 40,
		year = 2016,
		month = 3,
		count = 11,
		reward = [],
		is_double = 0,
		vip_double = 0
	};

get({2016,3,12}) ->
	#everyday_sign_conf{
		key = 41,
		year = 2016,
		month = 3,
		count = 12,
		reward = [],
		is_double = 1,
		vip_double = 4
	};

get({2016,3,13}) ->
	#everyday_sign_conf{
		key = 42,
		year = 2016,
		month = 3,
		count = 13,
		reward = [],
		is_double = 0,
		vip_double = 0
	};

get({2016,3,14}) ->
	#everyday_sign_conf{
		key = 43,
		year = 2016,
		month = 3,
		count = 14,
		reward = [],
		is_double = 1,
		vip_double = 5
	};

get({2016,3,15}) ->
	#everyday_sign_conf{
		key = 44,
		year = 2016,
		month = 3,
		count = 15,
		reward = [],
		is_double = 0,
		vip_double = 0
	};

get({2016,3,16}) ->
	#everyday_sign_conf{
		key = 45,
		year = 2016,
		month = 3,
		count = 16,
		reward = [],
		is_double = 1,
		vip_double = 6
	};

get({2016,3,17}) ->
	#everyday_sign_conf{
		key = 46,
		year = 2016,
		month = 3,
		count = 17,
		reward = [{110050,1,1},{110045,1,500},{110148,1,2},{110127,1,200}],
		is_double = 0,
		vip_double = 0
	};

get({2016,3,18}) ->
	#everyday_sign_conf{
		key = 47,
		year = 2016,
		month = 3,
		count = 18,
		reward = [],
		is_double = 1,
		vip_double = 7
	};

get({2016,3,19}) ->
	#everyday_sign_conf{
		key = 48,
		year = 2016,
		month = 3,
		count = 19,
		reward = [],
		is_double = 0,
		vip_double = 0
	};

get({2016,3,20}) ->
	#everyday_sign_conf{
		key = 49,
		year = 2016,
		month = 3,
		count = 20,
		reward = [],
		is_double = 1,
		vip_double = 8
	};

get({2016,3,21}) ->
	#everyday_sign_conf{
		key = 50,
		year = 2016,
		month = 3,
		count = 21,
		reward = [],
		is_double = 0,
		vip_double = 0
	};

get({2016,3,22}) ->
	#everyday_sign_conf{
		key = 51,
		year = 2016,
		month = 3,
		count = 22,
		reward = [],
		is_double = 1,
		vip_double = 9
	};

get({2016,3,23}) ->
	#everyday_sign_conf{
		key = 52,
		year = 2016,
		month = 3,
		count = 23,
		reward = [],
		is_double = 0,
		vip_double = 0
	};

get({2016,3,24}) ->
	#everyday_sign_conf{
		key = 53,
		year = 2016,
		month = 3,
		count = 24,
		reward = [],
		is_double = 1,
		vip_double = 10
	};

get({2016,3,25}) ->
	#everyday_sign_conf{
		key = 54,
		year = 2016,
		month = 3,
		count = 25,
		reward = [],
		is_double = 0,
		vip_double = 0
	};

get({2016,3,26}) ->
	#everyday_sign_conf{
		key = 55,
		year = 2016,
		month = 3,
		count = 26,
		reward = [{110050,1,1},{110045,1,600},{110149,1,1},{110140,1,10}],
		is_double = 1,
		vip_double = 11
	};

get({2016,3,27}) ->
	#everyday_sign_conf{
		key = 56,
		year = 2016,
		month = 3,
		count = 27,
		reward = [],
		is_double = 0,
		vip_double = 0
	};

get({2016,3,28}) ->
	#everyday_sign_conf{
		key = 57,
		year = 2016,
		month = 3,
		count = 28,
		reward = [],
		is_double = 1,
		vip_double = 12
	};

get({2016,3,29}) ->
	#everyday_sign_conf{
		key = 58,
		year = 2016,
		month = 3,
		count = 29,
		reward = [],
		is_double = 0,
		vip_double = 0
	};

get({2016,3,30}) ->
	#everyday_sign_conf{
		key = 59,
		year = 2016,
		month = 3,
		count = 30,
		reward = [],
		is_double = 1,
		vip_double = 12
	};

get({2016,3,31}) ->
	#everyday_sign_conf{
		key = 60,
		year = 2016,
		month = 3,
		count = 31,
		reward = [],
		is_double = 0,
		vip_double = 0
	};

get({2016,4,1}) ->
	#everyday_sign_conf{
		key = 61,
		year = 2016,
		month = 4,
		count = 1,
		reward = [],
		is_double = 0,
		vip_double = 0
	};

get({2016,4,2}) ->
	#everyday_sign_conf{
		key = 62,
		year = 2016,
		month = 4,
		count = 2,
		reward = [{110050,1,1},{110045,1,200},{110148,1,1},{110127,1,50}],
		is_double = 1,
		vip_double = 1
	};

get({2016,4,3}) ->
	#everyday_sign_conf{
		key = 63,
		year = 2016,
		month = 4,
		count = 3,
		reward = [],
		is_double = 0,
		vip_double = 0
	};

get({2016,4,4}) ->
	#everyday_sign_conf{
		key = 64,
		year = 2016,
		month = 4,
		count = 4,
		reward = [],
		is_double = 1,
		vip_double = 1
	};

get({2016,4,5}) ->
	#everyday_sign_conf{
		key = 65,
		year = 2016,
		month = 4,
		count = 5,
		reward = [{110050,1,1},{110045,1,300},{110148,1,1},{110127,1,100}],
		is_double = 0,
		vip_double = 0
	};

get({2016,4,6}) ->
	#everyday_sign_conf{
		key = 66,
		year = 2016,
		month = 4,
		count = 6,
		reward = [],
		is_double = 1,
		vip_double = 2
	};

get({2016,4,7}) ->
	#everyday_sign_conf{
		key = 67,
		year = 2016,
		month = 4,
		count = 7,
		reward = [],
		is_double = 0,
		vip_double = 0
	};

get({2016,4,8}) ->
	#everyday_sign_conf{
		key = 68,
		year = 2016,
		month = 4,
		count = 8,
		reward = [],
		is_double = 1,
		vip_double = 2
	};

get({2016,4,9}) ->
	#everyday_sign_conf{
		key = 69,
		year = 2016,
		month = 4,
		count = 9,
		reward = [],
		is_double = 0,
		vip_double = 0
	};

get({2016,4,10}) ->
	#everyday_sign_conf{
		key = 70,
		year = 2016,
		month = 4,
		count = 10,
		reward = [{110050,1,1},{110045,1,400},{110148,1,1},{110127,1,150}],
		is_double = 1,
		vip_double = 3
	};

get({2016,4,11}) ->
	#everyday_sign_conf{
		key = 71,
		year = 2016,
		month = 4,
		count = 11,
		reward = [],
		is_double = 0,
		vip_double = 0
	};

get({2016,4,12}) ->
	#everyday_sign_conf{
		key = 72,
		year = 2016,
		month = 4,
		count = 12,
		reward = [],
		is_double = 1,
		vip_double = 4
	};

get({2016,4,13}) ->
	#everyday_sign_conf{
		key = 73,
		year = 2016,
		month = 4,
		count = 13,
		reward = [],
		is_double = 0,
		vip_double = 0
	};

get({2016,4,14}) ->
	#everyday_sign_conf{
		key = 74,
		year = 2016,
		month = 4,
		count = 14,
		reward = [],
		is_double = 1,
		vip_double = 5
	};

get({2016,4,15}) ->
	#everyday_sign_conf{
		key = 75,
		year = 2016,
		month = 4,
		count = 15,
		reward = [],
		is_double = 0,
		vip_double = 0
	};

get({2016,4,16}) ->
	#everyday_sign_conf{
		key = 76,
		year = 2016,
		month = 4,
		count = 16,
		reward = [],
		is_double = 1,
		vip_double = 6
	};

get({2016,4,17}) ->
	#everyday_sign_conf{
		key = 77,
		year = 2016,
		month = 4,
		count = 17,
		reward = [{110050,1,1},{110045,1,500},{110148,1,2},{110127,1,200}],
		is_double = 0,
		vip_double = 0
	};

get({2016,4,18}) ->
	#everyday_sign_conf{
		key = 78,
		year = 2016,
		month = 4,
		count = 18,
		reward = [],
		is_double = 1,
		vip_double = 7
	};

get({2016,4,19}) ->
	#everyday_sign_conf{
		key = 79,
		year = 2016,
		month = 4,
		count = 19,
		reward = [],
		is_double = 0,
		vip_double = 0
	};

get({2016,4,20}) ->
	#everyday_sign_conf{
		key = 80,
		year = 2016,
		month = 4,
		count = 20,
		reward = [],
		is_double = 1,
		vip_double = 8
	};

get({2016,4,21}) ->
	#everyday_sign_conf{
		key = 81,
		year = 2016,
		month = 4,
		count = 21,
		reward = [],
		is_double = 0,
		vip_double = 0
	};

get({2016,4,22}) ->
	#everyday_sign_conf{
		key = 82,
		year = 2016,
		month = 4,
		count = 22,
		reward = [],
		is_double = 1,
		vip_double = 9
	};

get({2016,4,23}) ->
	#everyday_sign_conf{
		key = 83,
		year = 2016,
		month = 4,
		count = 23,
		reward = [],
		is_double = 0,
		vip_double = 0
	};

get({2016,4,24}) ->
	#everyday_sign_conf{
		key = 84,
		year = 2016,
		month = 4,
		count = 24,
		reward = [],
		is_double = 1,
		vip_double = 10
	};

get({2016,4,25}) ->
	#everyday_sign_conf{
		key = 85,
		year = 2016,
		month = 4,
		count = 25,
		reward = [],
		is_double = 0,
		vip_double = 0
	};

get({2016,4,26}) ->
	#everyday_sign_conf{
		key = 86,
		year = 2016,
		month = 4,
		count = 26,
		reward = [{110050,1,1},{110045,1,600},{110149,1,1},{110140,1,10}],
		is_double = 1,
		vip_double = 11
	};

get({2016,4,27}) ->
	#everyday_sign_conf{
		key = 87,
		year = 2016,
		month = 4,
		count = 27,
		reward = [],
		is_double = 0,
		vip_double = 0
	};

get({2016,4,28}) ->
	#everyday_sign_conf{
		key = 88,
		year = 2016,
		month = 4,
		count = 28,
		reward = [],
		is_double = 1,
		vip_double = 12
	};

get({2016,4,29}) ->
	#everyday_sign_conf{
		key = 89,
		year = 2016,
		month = 4,
		count = 29,
		reward = [],
		is_double = 0,
		vip_double = 0
	};

get({2016,4,30}) ->
	#everyday_sign_conf{
		key = 90,
		year = 2016,
		month = 4,
		count = 30,
		reward = [],
		is_double = 1,
		vip_double = 12
	};

get({2016,5,1}) ->
	#everyday_sign_conf{
		key = 91,
		year = 2016,
		month = 5,
		count = 1,
		reward = [],
		is_double = 0,
		vip_double = 0
	};

get({2016,5,2}) ->
	#everyday_sign_conf{
		key = 92,
		year = 2016,
		month = 5,
		count = 2,
		reward = [{110050,1,1},{110045,1,200},{110148,1,1},{110127,1,50}],
		is_double = 1,
		vip_double = 1
	};

get({2016,5,3}) ->
	#everyday_sign_conf{
		key = 93,
		year = 2016,
		month = 5,
		count = 3,
		reward = [],
		is_double = 0,
		vip_double = 0
	};

get({2016,5,4}) ->
	#everyday_sign_conf{
		key = 94,
		year = 2016,
		month = 5,
		count = 4,
		reward = [],
		is_double = 1,
		vip_double = 1
	};

get({2016,5,5}) ->
	#everyday_sign_conf{
		key = 95,
		year = 2016,
		month = 5,
		count = 5,
		reward = [{110050,1,1},{110045,1,300},{110148,1,1},{110127,1,100}],
		is_double = 0,
		vip_double = 0
	};

get({2016,5,6}) ->
	#everyday_sign_conf{
		key = 96,
		year = 2016,
		month = 5,
		count = 6,
		reward = [],
		is_double = 1,
		vip_double = 2
	};

get({2016,5,7}) ->
	#everyday_sign_conf{
		key = 97,
		year = 2016,
		month = 5,
		count = 7,
		reward = [],
		is_double = 0,
		vip_double = 0
	};

get({2016,5,8}) ->
	#everyday_sign_conf{
		key = 98,
		year = 2016,
		month = 5,
		count = 8,
		reward = [],
		is_double = 1,
		vip_double = 2
	};

get({2016,5,9}) ->
	#everyday_sign_conf{
		key = 99,
		year = 2016,
		month = 5,
		count = 9,
		reward = [],
		is_double = 0,
		vip_double = 0
	};

get({2016,5,10}) ->
	#everyday_sign_conf{
		key = 100,
		year = 2016,
		month = 5,
		count = 10,
		reward = [{110050,1,1},{110045,1,400},{110148,1,1},{110127,1,150}],
		is_double = 1,
		vip_double = 3
	};

get({2016,5,11}) ->
	#everyday_sign_conf{
		key = 101,
		year = 2016,
		month = 5,
		count = 11,
		reward = [],
		is_double = 0,
		vip_double = 0
	};

get({2016,5,12}) ->
	#everyday_sign_conf{
		key = 102,
		year = 2016,
		month = 5,
		count = 12,
		reward = [],
		is_double = 1,
		vip_double = 4
	};

get({2016,5,13}) ->
	#everyday_sign_conf{
		key = 103,
		year = 2016,
		month = 5,
		count = 13,
		reward = [],
		is_double = 0,
		vip_double = 0
	};

get({2016,5,14}) ->
	#everyday_sign_conf{
		key = 104,
		year = 2016,
		month = 5,
		count = 14,
		reward = [],
		is_double = 1,
		vip_double = 5
	};

get({2016,5,15}) ->
	#everyday_sign_conf{
		key = 105,
		year = 2016,
		month = 5,
		count = 15,
		reward = [],
		is_double = 0,
		vip_double = 0
	};

get({2016,5,16}) ->
	#everyday_sign_conf{
		key = 106,
		year = 2016,
		month = 5,
		count = 16,
		reward = [],
		is_double = 1,
		vip_double = 6
	};

get({2016,5,17}) ->
	#everyday_sign_conf{
		key = 107,
		year = 2016,
		month = 5,
		count = 17,
		reward = [{110050,1,1},{110045,1,500},{110148,1,2},{110127,1,200}],
		is_double = 0,
		vip_double = 0
	};

get({2016,5,18}) ->
	#everyday_sign_conf{
		key = 108,
		year = 2016,
		month = 5,
		count = 18,
		reward = [],
		is_double = 1,
		vip_double = 7
	};

get({2016,5,19}) ->
	#everyday_sign_conf{
		key = 109,
		year = 2016,
		month = 5,
		count = 19,
		reward = [],
		is_double = 0,
		vip_double = 0
	};

get({2016,5,20}) ->
	#everyday_sign_conf{
		key = 110,
		year = 2016,
		month = 5,
		count = 20,
		reward = [],
		is_double = 1,
		vip_double = 8
	};

get({2016,5,21}) ->
	#everyday_sign_conf{
		key = 111,
		year = 2016,
		month = 5,
		count = 21,
		reward = [],
		is_double = 0,
		vip_double = 0
	};

get({2016,5,22}) ->
	#everyday_sign_conf{
		key = 112,
		year = 2016,
		month = 5,
		count = 22,
		reward = [],
		is_double = 1,
		vip_double = 9
	};

get({2016,5,23}) ->
	#everyday_sign_conf{
		key = 113,
		year = 2016,
		month = 5,
		count = 23,
		reward = [],
		is_double = 0,
		vip_double = 0
	};

get({2016,5,24}) ->
	#everyday_sign_conf{
		key = 114,
		year = 2016,
		month = 5,
		count = 24,
		reward = [],
		is_double = 1,
		vip_double = 10
	};

get({2016,5,25}) ->
	#everyday_sign_conf{
		key = 115,
		year = 2016,
		month = 5,
		count = 25,
		reward = [],
		is_double = 0,
		vip_double = 0
	};

get({2016,5,26}) ->
	#everyday_sign_conf{
		key = 116,
		year = 2016,
		month = 5,
		count = 26,
		reward = [{110050,1,1},{110045,1,600},{110149,1,1},{110140,1,10}],
		is_double = 1,
		vip_double = 11
	};

get({2016,5,27}) ->
	#everyday_sign_conf{
		key = 117,
		year = 2016,
		month = 5,
		count = 27,
		reward = [],
		is_double = 0,
		vip_double = 0
	};

get({2016,5,28}) ->
	#everyday_sign_conf{
		key = 118,
		year = 2016,
		month = 5,
		count = 28,
		reward = [],
		is_double = 1,
		vip_double = 12
	};

get({2016,5,29}) ->
	#everyday_sign_conf{
		key = 119,
		year = 2016,
		month = 5,
		count = 29,
		reward = [],
		is_double = 0,
		vip_double = 0
	};

get({2016,5,30}) ->
	#everyday_sign_conf{
		key = 120,
		year = 2016,
		month = 5,
		count = 30,
		reward = [],
		is_double = 1,
		vip_double = 12
	};

get({2016,5,31}) ->
	#everyday_sign_conf{
		key = 121,
		year = 2016,
		month = 5,
		count = 31,
		reward = [],
		is_double = 0,
		vip_double = 0
	};

get({2016,6,1}) ->
	#everyday_sign_conf{
		key = 122,
		year = 2016,
		month = 6,
		count = 1,
		reward = [],
		is_double = 0,
		vip_double = 0
	};

get({2016,6,2}) ->
	#everyday_sign_conf{
		key = 123,
		year = 2016,
		month = 6,
		count = 2,
		reward = [{110050,1,1},{110045,1,200},{110148,1,1},{110127,1,50}],
		is_double = 1,
		vip_double = 1
	};

get({2016,6,3}) ->
	#everyday_sign_conf{
		key = 124,
		year = 2016,
		month = 6,
		count = 3,
		reward = [],
		is_double = 0,
		vip_double = 0
	};

get({2016,6,4}) ->
	#everyday_sign_conf{
		key = 125,
		year = 2016,
		month = 6,
		count = 4,
		reward = [],
		is_double = 1,
		vip_double = 1
	};

get({2016,6,5}) ->
	#everyday_sign_conf{
		key = 126,
		year = 2016,
		month = 6,
		count = 5,
		reward = [{110050,1,1},{110045,1,300},{110148,1,1},{110127,1,100}],
		is_double = 0,
		vip_double = 0
	};

get({2016,6,6}) ->
	#everyday_sign_conf{
		key = 127,
		year = 2016,
		month = 6,
		count = 6,
		reward = [],
		is_double = 1,
		vip_double = 2
	};

get({2016,6,7}) ->
	#everyday_sign_conf{
		key = 128,
		year = 2016,
		month = 6,
		count = 7,
		reward = [],
		is_double = 0,
		vip_double = 0
	};

get({2016,6,8}) ->
	#everyday_sign_conf{
		key = 129,
		year = 2016,
		month = 6,
		count = 8,
		reward = [],
		is_double = 1,
		vip_double = 2
	};

get({2016,6,9}) ->
	#everyday_sign_conf{
		key = 130,
		year = 2016,
		month = 6,
		count = 9,
		reward = [],
		is_double = 0,
		vip_double = 0
	};

get({2016,6,10}) ->
	#everyday_sign_conf{
		key = 131,
		year = 2016,
		month = 6,
		count = 10,
		reward = [{110050,1,1},{110045,1,400},{110148,1,1},{110127,1,150}],
		is_double = 1,
		vip_double = 3
	};

get({2016,6,11}) ->
	#everyday_sign_conf{
		key = 132,
		year = 2016,
		month = 6,
		count = 11,
		reward = [],
		is_double = 0,
		vip_double = 0
	};

get({2016,6,12}) ->
	#everyday_sign_conf{
		key = 133,
		year = 2016,
		month = 6,
		count = 12,
		reward = [],
		is_double = 1,
		vip_double = 4
	};

get({2016,6,13}) ->
	#everyday_sign_conf{
		key = 134,
		year = 2016,
		month = 6,
		count = 13,
		reward = [],
		is_double = 0,
		vip_double = 0
	};

get({2016,6,14}) ->
	#everyday_sign_conf{
		key = 135,
		year = 2016,
		month = 6,
		count = 14,
		reward = [],
		is_double = 1,
		vip_double = 5
	};

get({2016,6,15}) ->
	#everyday_sign_conf{
		key = 136,
		year = 2016,
		month = 6,
		count = 15,
		reward = [],
		is_double = 0,
		vip_double = 0
	};

get({2016,6,16}) ->
	#everyday_sign_conf{
		key = 137,
		year = 2016,
		month = 6,
		count = 16,
		reward = [],
		is_double = 1,
		vip_double = 6
	};

get({2016,6,17}) ->
	#everyday_sign_conf{
		key = 138,
		year = 2016,
		month = 6,
		count = 17,
		reward = [{110050,1,1},{110045,1,500},{110148,1,2},{110127,1,200}],
		is_double = 0,
		vip_double = 0
	};

get({2016,6,18}) ->
	#everyday_sign_conf{
		key = 139,
		year = 2016,
		month = 6,
		count = 18,
		reward = [],
		is_double = 1,
		vip_double = 7
	};

get({2016,6,19}) ->
	#everyday_sign_conf{
		key = 140,
		year = 2016,
		month = 6,
		count = 19,
		reward = [],
		is_double = 0,
		vip_double = 0
	};

get({2016,6,20}) ->
	#everyday_sign_conf{
		key = 141,
		year = 2016,
		month = 6,
		count = 20,
		reward = [],
		is_double = 1,
		vip_double = 8
	};

get({2016,6,21}) ->
	#everyday_sign_conf{
		key = 142,
		year = 2016,
		month = 6,
		count = 21,
		reward = [],
		is_double = 0,
		vip_double = 0
	};

get({2016,6,22}) ->
	#everyday_sign_conf{
		key = 143,
		year = 2016,
		month = 6,
		count = 22,
		reward = [],
		is_double = 1,
		vip_double = 9
	};

get({2016,6,23}) ->
	#everyday_sign_conf{
		key = 144,
		year = 2016,
		month = 6,
		count = 23,
		reward = [],
		is_double = 0,
		vip_double = 0
	};

get({2016,6,24}) ->
	#everyday_sign_conf{
		key = 145,
		year = 2016,
		month = 6,
		count = 24,
		reward = [],
		is_double = 1,
		vip_double = 10
	};

get({2016,6,25}) ->
	#everyday_sign_conf{
		key = 146,
		year = 2016,
		month = 6,
		count = 25,
		reward = [],
		is_double = 0,
		vip_double = 0
	};

get({2016,6,26}) ->
	#everyday_sign_conf{
		key = 147,
		year = 2016,
		month = 6,
		count = 26,
		reward = [{110050,1,1},{110045,1,600},{110149,1,1},{110140,1,10}],
		is_double = 1,
		vip_double = 11
	};

get({2016,6,27}) ->
	#everyday_sign_conf{
		key = 148,
		year = 2016,
		month = 6,
		count = 27,
		reward = [],
		is_double = 0,
		vip_double = 0
	};

get({2016,6,28}) ->
	#everyday_sign_conf{
		key = 149,
		year = 2016,
		month = 6,
		count = 28,
		reward = [],
		is_double = 1,
		vip_double = 12
	};

get({2016,6,29}) ->
	#everyday_sign_conf{
		key = 150,
		year = 2016,
		month = 6,
		count = 29,
		reward = [],
		is_double = 0,
		vip_double = 0
	};

get({2016,6,30}) ->
	#everyday_sign_conf{
		key = 151,
		year = 2016,
		month = 6,
		count = 30,
		reward = [],
		is_double = 1,
		vip_double = 12
	};

get({2016,7,1}) ->
	#everyday_sign_conf{
		key = 152,
		year = 2016,
		month = 7,
		count = 1,
		reward = [],
		is_double = 0,
		vip_double = 0
	};

get({2016,7,2}) ->
	#everyday_sign_conf{
		key = 153,
		year = 2016,
		month = 7,
		count = 2,
		reward = [{110050,1,1},{110045,1,200},{110148,1,1},{110127,1,50}],
		is_double = 1,
		vip_double = 1
	};

get({2016,7,3}) ->
	#everyday_sign_conf{
		key = 154,
		year = 2016,
		month = 7,
		count = 3,
		reward = [],
		is_double = 0,
		vip_double = 0
	};

get({2016,7,4}) ->
	#everyday_sign_conf{
		key = 155,
		year = 2016,
		month = 7,
		count = 4,
		reward = [],
		is_double = 1,
		vip_double = 1
	};

get({2016,7,5}) ->
	#everyday_sign_conf{
		key = 156,
		year = 2016,
		month = 7,
		count = 5,
		reward = [{110050,1,1},{110045,1,300},{110148,1,1},{110127,1,100}],
		is_double = 0,
		vip_double = 0
	};

get({2016,7,6}) ->
	#everyday_sign_conf{
		key = 157,
		year = 2016,
		month = 7,
		count = 6,
		reward = [],
		is_double = 1,
		vip_double = 2
	};

get({2016,7,7}) ->
	#everyday_sign_conf{
		key = 158,
		year = 2016,
		month = 7,
		count = 7,
		reward = [],
		is_double = 0,
		vip_double = 0
	};

get({2016,7,8}) ->
	#everyday_sign_conf{
		key = 159,
		year = 2016,
		month = 7,
		count = 8,
		reward = [],
		is_double = 1,
		vip_double = 2
	};

get({2016,7,9}) ->
	#everyday_sign_conf{
		key = 160,
		year = 2016,
		month = 7,
		count = 9,
		reward = [],
		is_double = 0,
		vip_double = 0
	};

get({2016,7,10}) ->
	#everyday_sign_conf{
		key = 161,
		year = 2016,
		month = 7,
		count = 10,
		reward = [{110050,1,1},{110045,1,400},{110148,1,1},{110127,1,150}],
		is_double = 1,
		vip_double = 3
	};

get({2016,7,11}) ->
	#everyday_sign_conf{
		key = 162,
		year = 2016,
		month = 7,
		count = 11,
		reward = [],
		is_double = 0,
		vip_double = 0
	};

get({2016,7,12}) ->
	#everyday_sign_conf{
		key = 163,
		year = 2016,
		month = 7,
		count = 12,
		reward = [],
		is_double = 1,
		vip_double = 4
	};

get({2016,7,13}) ->
	#everyday_sign_conf{
		key = 164,
		year = 2016,
		month = 7,
		count = 13,
		reward = [],
		is_double = 0,
		vip_double = 0
	};

get({2016,7,14}) ->
	#everyday_sign_conf{
		key = 165,
		year = 2016,
		month = 7,
		count = 14,
		reward = [],
		is_double = 1,
		vip_double = 5
	};

get({2016,7,15}) ->
	#everyday_sign_conf{
		key = 166,
		year = 2016,
		month = 7,
		count = 15,
		reward = [],
		is_double = 0,
		vip_double = 0
	};

get({2016,7,16}) ->
	#everyday_sign_conf{
		key = 167,
		year = 2016,
		month = 7,
		count = 16,
		reward = [],
		is_double = 1,
		vip_double = 6
	};

get({2016,7,17}) ->
	#everyday_sign_conf{
		key = 168,
		year = 2016,
		month = 7,
		count = 17,
		reward = [{110050,1,1},{110045,1,500},{110148,1,2},{110127,1,200}],
		is_double = 0,
		vip_double = 0
	};

get({2016,7,18}) ->
	#everyday_sign_conf{
		key = 169,
		year = 2016,
		month = 7,
		count = 18,
		reward = [],
		is_double = 1,
		vip_double = 7
	};

get({2016,7,19}) ->
	#everyday_sign_conf{
		key = 170,
		year = 2016,
		month = 7,
		count = 19,
		reward = [],
		is_double = 0,
		vip_double = 0
	};

get({2016,7,20}) ->
	#everyday_sign_conf{
		key = 171,
		year = 2016,
		month = 7,
		count = 20,
		reward = [],
		is_double = 1,
		vip_double = 8
	};

get({2016,7,21}) ->
	#everyday_sign_conf{
		key = 172,
		year = 2016,
		month = 7,
		count = 21,
		reward = [],
		is_double = 0,
		vip_double = 0
	};

get({2016,7,22}) ->
	#everyday_sign_conf{
		key = 173,
		year = 2016,
		month = 7,
		count = 22,
		reward = [],
		is_double = 1,
		vip_double = 9
	};

get({2016,7,23}) ->
	#everyday_sign_conf{
		key = 174,
		year = 2016,
		month = 7,
		count = 23,
		reward = [],
		is_double = 0,
		vip_double = 0
	};

get({2016,7,24}) ->
	#everyday_sign_conf{
		key = 175,
		year = 2016,
		month = 7,
		count = 24,
		reward = [],
		is_double = 1,
		vip_double = 10
	};

get({2016,7,25}) ->
	#everyday_sign_conf{
		key = 176,
		year = 2016,
		month = 7,
		count = 25,
		reward = [],
		is_double = 0,
		vip_double = 0
	};

get({2016,7,26}) ->
	#everyday_sign_conf{
		key = 177,
		year = 2016,
		month = 7,
		count = 26,
		reward = [{110050,1,1},{110045,1,600},{110149,1,1},{110140,1,10}],
		is_double = 1,
		vip_double = 11
	};

get({2016,7,27}) ->
	#everyday_sign_conf{
		key = 178,
		year = 2016,
		month = 7,
		count = 27,
		reward = [],
		is_double = 0,
		vip_double = 0
	};

get({2016,7,28}) ->
	#everyday_sign_conf{
		key = 179,
		year = 2016,
		month = 7,
		count = 28,
		reward = [],
		is_double = 1,
		vip_double = 12
	};

get({2016,7,29}) ->
	#everyday_sign_conf{
		key = 180,
		year = 2016,
		month = 7,
		count = 29,
		reward = [],
		is_double = 0,
		vip_double = 0
	};

get({2016,7,30}) ->
	#everyday_sign_conf{
		key = 181,
		year = 2016,
		month = 7,
		count = 30,
		reward = [],
		is_double = 1,
		vip_double = 12
	};

get({2016,7,31}) ->
	#everyday_sign_conf{
		key = 182,
		year = 2016,
		month = 7,
		count = 31,
		reward = [],
		is_double = 0,
		vip_double = 0
	};

get({2016,8,1}) ->
	#everyday_sign_conf{
		key = 183,
		year = 2016,
		month = 8,
		count = 1,
		reward = [],
		is_double = 0,
		vip_double = 0
	};

get({2016,8,2}) ->
	#everyday_sign_conf{
		key = 184,
		year = 2016,
		month = 8,
		count = 2,
		reward = [{110050,1,1},{110045,1,200},{110148,1,1},{110127,1,50}],
		is_double = 1,
		vip_double = 1
	};

get({2016,8,3}) ->
	#everyday_sign_conf{
		key = 185,
		year = 2016,
		month = 8,
		count = 3,
		reward = [],
		is_double = 0,
		vip_double = 0
	};

get({2016,8,4}) ->
	#everyday_sign_conf{
		key = 186,
		year = 2016,
		month = 8,
		count = 4,
		reward = [],
		is_double = 1,
		vip_double = 1
	};

get({2016,8,5}) ->
	#everyday_sign_conf{
		key = 187,
		year = 2016,
		month = 8,
		count = 5,
		reward = [{110050,1,1},{110045,1,300},{110148,1,1},{110127,1,100}],
		is_double = 0,
		vip_double = 0
	};

get({2016,8,6}) ->
	#everyday_sign_conf{
		key = 188,
		year = 2016,
		month = 8,
		count = 6,
		reward = [],
		is_double = 1,
		vip_double = 2
	};

get({2016,8,7}) ->
	#everyday_sign_conf{
		key = 189,
		year = 2016,
		month = 8,
		count = 7,
		reward = [],
		is_double = 0,
		vip_double = 0
	};

get({2016,8,8}) ->
	#everyday_sign_conf{
		key = 190,
		year = 2016,
		month = 8,
		count = 8,
		reward = [],
		is_double = 1,
		vip_double = 2
	};

get({2016,8,9}) ->
	#everyday_sign_conf{
		key = 191,
		year = 2016,
		month = 8,
		count = 9,
		reward = [],
		is_double = 0,
		vip_double = 0
	};

get({2016,8,10}) ->
	#everyday_sign_conf{
		key = 192,
		year = 2016,
		month = 8,
		count = 10,
		reward = [{110050,1,1},{110045,1,400},{110148,1,1},{110127,1,150}],
		is_double = 1,
		vip_double = 3
	};

get({2016,8,11}) ->
	#everyday_sign_conf{
		key = 193,
		year = 2016,
		month = 8,
		count = 11,
		reward = [],
		is_double = 0,
		vip_double = 0
	};

get({2016,8,12}) ->
	#everyday_sign_conf{
		key = 194,
		year = 2016,
		month = 8,
		count = 12,
		reward = [],
		is_double = 1,
		vip_double = 4
	};

get({2016,8,13}) ->
	#everyday_sign_conf{
		key = 195,
		year = 2016,
		month = 8,
		count = 13,
		reward = [],
		is_double = 0,
		vip_double = 0
	};

get({2016,8,14}) ->
	#everyday_sign_conf{
		key = 196,
		year = 2016,
		month = 8,
		count = 14,
		reward = [],
		is_double = 1,
		vip_double = 5
	};

get({2016,8,15}) ->
	#everyday_sign_conf{
		key = 197,
		year = 2016,
		month = 8,
		count = 15,
		reward = [],
		is_double = 0,
		vip_double = 0
	};

get({2016,8,16}) ->
	#everyday_sign_conf{
		key = 198,
		year = 2016,
		month = 8,
		count = 16,
		reward = [],
		is_double = 1,
		vip_double = 6
	};

get({2016,8,17}) ->
	#everyday_sign_conf{
		key = 199,
		year = 2016,
		month = 8,
		count = 17,
		reward = [{110050,1,1},{110045,1,500},{110148,1,2},{110127,1,200}],
		is_double = 0,
		vip_double = 0
	};

get({2016,8,18}) ->
	#everyday_sign_conf{
		key = 200,
		year = 2016,
		month = 8,
		count = 18,
		reward = [],
		is_double = 1,
		vip_double = 7
	};

get({2016,8,19}) ->
	#everyday_sign_conf{
		key = 201,
		year = 2016,
		month = 8,
		count = 19,
		reward = [],
		is_double = 0,
		vip_double = 0
	};

get({2016,8,20}) ->
	#everyday_sign_conf{
		key = 202,
		year = 2016,
		month = 8,
		count = 20,
		reward = [],
		is_double = 1,
		vip_double = 8
	};

get({2016,8,21}) ->
	#everyday_sign_conf{
		key = 203,
		year = 2016,
		month = 8,
		count = 21,
		reward = [],
		is_double = 0,
		vip_double = 0
	};

get({2016,8,22}) ->
	#everyday_sign_conf{
		key = 204,
		year = 2016,
		month = 8,
		count = 22,
		reward = [],
		is_double = 1,
		vip_double = 9
	};

get({2016,8,23}) ->
	#everyday_sign_conf{
		key = 205,
		year = 2016,
		month = 8,
		count = 23,
		reward = [],
		is_double = 0,
		vip_double = 0
	};

get({2016,8,24}) ->
	#everyday_sign_conf{
		key = 206,
		year = 2016,
		month = 8,
		count = 24,
		reward = [],
		is_double = 1,
		vip_double = 10
	};

get({2016,8,25}) ->
	#everyday_sign_conf{
		key = 207,
		year = 2016,
		month = 8,
		count = 25,
		reward = [],
		is_double = 0,
		vip_double = 0
	};

get({2016,8,26}) ->
	#everyday_sign_conf{
		key = 208,
		year = 2016,
		month = 8,
		count = 26,
		reward = [{110050,1,1},{110045,1,600},{110149,1,1},{110140,1,10}],
		is_double = 1,
		vip_double = 11
	};

get({2016,8,27}) ->
	#everyday_sign_conf{
		key = 209,
		year = 2016,
		month = 8,
		count = 27,
		reward = [],
		is_double = 0,
		vip_double = 0
	};

get({2016,8,28}) ->
	#everyday_sign_conf{
		key = 210,
		year = 2016,
		month = 8,
		count = 28,
		reward = [],
		is_double = 1,
		vip_double = 12
	};

get({2016,8,29}) ->
	#everyday_sign_conf{
		key = 211,
		year = 2016,
		month = 8,
		count = 29,
		reward = [],
		is_double = 0,
		vip_double = 0
	};

get({2016,8,30}) ->
	#everyday_sign_conf{
		key = 212,
		year = 2016,
		month = 8,
		count = 30,
		reward = [],
		is_double = 1,
		vip_double = 12
	};

get({2016,8,31}) ->
	#everyday_sign_conf{
		key = 213,
		year = 2016,
		month = 8,
		count = 31,
		reward = [],
		is_double = 0,
		vip_double = 0
	};

get({2016,9,1}) ->
	#everyday_sign_conf{
		key = 214,
		year = 2016,
		month = 9,
		count = 1,
		reward = [],
		is_double = 0,
		vip_double = 0
	};

get({2016,9,2}) ->
	#everyday_sign_conf{
		key = 215,
		year = 2016,
		month = 9,
		count = 2,
		reward = [{110050,1,1},{110045,1,200},{110148,1,1},{110127,1,50}],
		is_double = 1,
		vip_double = 1
	};

get({2016,9,3}) ->
	#everyday_sign_conf{
		key = 216,
		year = 2016,
		month = 9,
		count = 3,
		reward = [],
		is_double = 0,
		vip_double = 0
	};

get({2016,9,4}) ->
	#everyday_sign_conf{
		key = 217,
		year = 2016,
		month = 9,
		count = 4,
		reward = [],
		is_double = 1,
		vip_double = 1
	};

get({2016,9,5}) ->
	#everyday_sign_conf{
		key = 218,
		year = 2016,
		month = 9,
		count = 5,
		reward = [{110050,1,1},{110045,1,300},{110148,1,1},{110127,1,100}],
		is_double = 0,
		vip_double = 0
	};

get({2016,9,6}) ->
	#everyday_sign_conf{
		key = 219,
		year = 2016,
		month = 9,
		count = 6,
		reward = [],
		is_double = 1,
		vip_double = 2
	};

get({2016,9,7}) ->
	#everyday_sign_conf{
		key = 220,
		year = 2016,
		month = 9,
		count = 7,
		reward = [],
		is_double = 0,
		vip_double = 0
	};

get({2016,9,8}) ->
	#everyday_sign_conf{
		key = 221,
		year = 2016,
		month = 9,
		count = 8,
		reward = [],
		is_double = 1,
		vip_double = 2
	};

get({2016,9,9}) ->
	#everyday_sign_conf{
		key = 222,
		year = 2016,
		month = 9,
		count = 9,
		reward = [],
		is_double = 0,
		vip_double = 0
	};

get({2016,9,10}) ->
	#everyday_sign_conf{
		key = 223,
		year = 2016,
		month = 9,
		count = 10,
		reward = [{110050,1,1},{110045,1,400},{110148,1,1},{110127,1,150}],
		is_double = 1,
		vip_double = 3
	};

get({2016,9,11}) ->
	#everyday_sign_conf{
		key = 224,
		year = 2016,
		month = 9,
		count = 11,
		reward = [],
		is_double = 0,
		vip_double = 0
	};

get({2016,9,12}) ->
	#everyday_sign_conf{
		key = 225,
		year = 2016,
		month = 9,
		count = 12,
		reward = [],
		is_double = 1,
		vip_double = 4
	};

get({2016,9,13}) ->
	#everyday_sign_conf{
		key = 226,
		year = 2016,
		month = 9,
		count = 13,
		reward = [],
		is_double = 0,
		vip_double = 0
	};

get({2016,9,14}) ->
	#everyday_sign_conf{
		key = 227,
		year = 2016,
		month = 9,
		count = 14,
		reward = [],
		is_double = 1,
		vip_double = 5
	};

get({2016,9,15}) ->
	#everyday_sign_conf{
		key = 228,
		year = 2016,
		month = 9,
		count = 15,
		reward = [],
		is_double = 0,
		vip_double = 0
	};

get({2016,9,16}) ->
	#everyday_sign_conf{
		key = 229,
		year = 2016,
		month = 9,
		count = 16,
		reward = [],
		is_double = 1,
		vip_double = 6
	};

get({2016,9,17}) ->
	#everyday_sign_conf{
		key = 230,
		year = 2016,
		month = 9,
		count = 17,
		reward = [{110050,1,1},{110045,1,500},{110148,1,2},{110127,1,200}],
		is_double = 0,
		vip_double = 0
	};

get({2016,9,18}) ->
	#everyday_sign_conf{
		key = 231,
		year = 2016,
		month = 9,
		count = 18,
		reward = [],
		is_double = 1,
		vip_double = 7
	};

get({2016,9,19}) ->
	#everyday_sign_conf{
		key = 232,
		year = 2016,
		month = 9,
		count = 19,
		reward = [],
		is_double = 0,
		vip_double = 0
	};

get({2016,9,20}) ->
	#everyday_sign_conf{
		key = 233,
		year = 2016,
		month = 9,
		count = 20,
		reward = [],
		is_double = 1,
		vip_double = 8
	};

get({2016,9,21}) ->
	#everyday_sign_conf{
		key = 234,
		year = 2016,
		month = 9,
		count = 21,
		reward = [],
		is_double = 0,
		vip_double = 0
	};

get({2016,9,22}) ->
	#everyday_sign_conf{
		key = 235,
		year = 2016,
		month = 9,
		count = 22,
		reward = [],
		is_double = 1,
		vip_double = 9
	};

get({2016,9,23}) ->
	#everyday_sign_conf{
		key = 236,
		year = 2016,
		month = 9,
		count = 23,
		reward = [],
		is_double = 0,
		vip_double = 0
	};

get({2016,9,24}) ->
	#everyday_sign_conf{
		key = 237,
		year = 2016,
		month = 9,
		count = 24,
		reward = [],
		is_double = 1,
		vip_double = 10
	};

get({2016,9,25}) ->
	#everyday_sign_conf{
		key = 238,
		year = 2016,
		month = 9,
		count = 25,
		reward = [],
		is_double = 0,
		vip_double = 0
	};

get({2016,9,26}) ->
	#everyday_sign_conf{
		key = 239,
		year = 2016,
		month = 9,
		count = 26,
		reward = [{110050,1,1},{110045,1,600},{110149,1,1},{110140,1,10}],
		is_double = 1,
		vip_double = 11
	};

get({2016,9,27}) ->
	#everyday_sign_conf{
		key = 240,
		year = 2016,
		month = 9,
		count = 27,
		reward = [],
		is_double = 0,
		vip_double = 0
	};

get({2016,9,28}) ->
	#everyday_sign_conf{
		key = 241,
		year = 2016,
		month = 9,
		count = 28,
		reward = [],
		is_double = 1,
		vip_double = 12
	};

get({2016,9,29}) ->
	#everyday_sign_conf{
		key = 242,
		year = 2016,
		month = 9,
		count = 29,
		reward = [],
		is_double = 0,
		vip_double = 0
	};

get({2016,9,30}) ->
	#everyday_sign_conf{
		key = 243,
		year = 2016,
		month = 9,
		count = 30,
		reward = [],
		is_double = 1,
		vip_double = 12
	};

get({2016,10,1}) ->
	#everyday_sign_conf{
		key = 244,
		year = 2016,
		month = 10,
		count = 1,
		reward = [],
		is_double = 0,
		vip_double = 0
	};

get({2016,10,2}) ->
	#everyday_sign_conf{
		key = 245,
		year = 2016,
		month = 10,
		count = 2,
		reward = [{110050,1,1},{110045,1,200},{110148,1,1},{110127,1,50}],
		is_double = 1,
		vip_double = 1
	};

get({2016,10,3}) ->
	#everyday_sign_conf{
		key = 246,
		year = 2016,
		month = 10,
		count = 3,
		reward = [],
		is_double = 0,
		vip_double = 0
	};

get({2016,10,4}) ->
	#everyday_sign_conf{
		key = 247,
		year = 2016,
		month = 10,
		count = 4,
		reward = [],
		is_double = 1,
		vip_double = 1
	};

get({2016,10,5}) ->
	#everyday_sign_conf{
		key = 248,
		year = 2016,
		month = 10,
		count = 5,
		reward = [{110050,1,1},{110045,1,300},{110148,1,1},{110127,1,100}],
		is_double = 0,
		vip_double = 0
	};

get({2016,10,6}) ->
	#everyday_sign_conf{
		key = 249,
		year = 2016,
		month = 10,
		count = 6,
		reward = [],
		is_double = 1,
		vip_double = 2
	};

get({2016,10,7}) ->
	#everyday_sign_conf{
		key = 250,
		year = 2016,
		month = 10,
		count = 7,
		reward = [],
		is_double = 0,
		vip_double = 0
	};

get({2016,10,8}) ->
	#everyday_sign_conf{
		key = 251,
		year = 2016,
		month = 10,
		count = 8,
		reward = [],
		is_double = 1,
		vip_double = 2
	};

get({2016,10,9}) ->
	#everyday_sign_conf{
		key = 252,
		year = 2016,
		month = 10,
		count = 9,
		reward = [],
		is_double = 0,
		vip_double = 0
	};

get({2016,10,10}) ->
	#everyday_sign_conf{
		key = 253,
		year = 2016,
		month = 10,
		count = 10,
		reward = [{110050,1,1},{110045,1,400},{110148,1,1},{110127,1,150}],
		is_double = 1,
		vip_double = 3
	};

get({2016,10,11}) ->
	#everyday_sign_conf{
		key = 254,
		year = 2016,
		month = 10,
		count = 11,
		reward = [],
		is_double = 0,
		vip_double = 0
	};

get({2016,10,12}) ->
	#everyday_sign_conf{
		key = 255,
		year = 2016,
		month = 10,
		count = 12,
		reward = [],
		is_double = 1,
		vip_double = 4
	};

get({2016,10,13}) ->
	#everyday_sign_conf{
		key = 256,
		year = 2016,
		month = 10,
		count = 13,
		reward = [],
		is_double = 0,
		vip_double = 0
	};

get({2016,10,14}) ->
	#everyday_sign_conf{
		key = 257,
		year = 2016,
		month = 10,
		count = 14,
		reward = [],
		is_double = 1,
		vip_double = 5
	};

get({2016,10,15}) ->
	#everyday_sign_conf{
		key = 258,
		year = 2016,
		month = 10,
		count = 15,
		reward = [],
		is_double = 0,
		vip_double = 0
	};

get({2016,10,16}) ->
	#everyday_sign_conf{
		key = 259,
		year = 2016,
		month = 10,
		count = 16,
		reward = [],
		is_double = 1,
		vip_double = 6
	};

get({2016,10,17}) ->
	#everyday_sign_conf{
		key = 260,
		year = 2016,
		month = 10,
		count = 17,
		reward = [{110050,1,1},{110045,1,500},{110148,1,2},{110127,1,200}],
		is_double = 0,
		vip_double = 0
	};

get({2016,10,18}) ->
	#everyday_sign_conf{
		key = 261,
		year = 2016,
		month = 10,
		count = 18,
		reward = [],
		is_double = 1,
		vip_double = 7
	};

get({2016,10,19}) ->
	#everyday_sign_conf{
		key = 262,
		year = 2016,
		month = 10,
		count = 19,
		reward = [],
		is_double = 0,
		vip_double = 0
	};

get({2016,10,20}) ->
	#everyday_sign_conf{
		key = 263,
		year = 2016,
		month = 10,
		count = 20,
		reward = [],
		is_double = 1,
		vip_double = 8
	};

get({2016,10,21}) ->
	#everyday_sign_conf{
		key = 264,
		year = 2016,
		month = 10,
		count = 21,
		reward = [],
		is_double = 0,
		vip_double = 0
	};

get({2016,10,22}) ->
	#everyday_sign_conf{
		key = 265,
		year = 2016,
		month = 10,
		count = 22,
		reward = [],
		is_double = 1,
		vip_double = 9
	};

get({2016,10,23}) ->
	#everyday_sign_conf{
		key = 266,
		year = 2016,
		month = 10,
		count = 23,
		reward = [],
		is_double = 0,
		vip_double = 0
	};

get({2016,10,24}) ->
	#everyday_sign_conf{
		key = 267,
		year = 2016,
		month = 10,
		count = 24,
		reward = [],
		is_double = 1,
		vip_double = 10
	};

get({2016,10,25}) ->
	#everyday_sign_conf{
		key = 268,
		year = 2016,
		month = 10,
		count = 25,
		reward = [],
		is_double = 0,
		vip_double = 0
	};

get({2016,10,26}) ->
	#everyday_sign_conf{
		key = 269,
		year = 2016,
		month = 10,
		count = 26,
		reward = [{110050,1,1},{110045,1,600},{110149,1,1},{110140,1,10}],
		is_double = 1,
		vip_double = 11
	};

get({2016,10,27}) ->
	#everyday_sign_conf{
		key = 270,
		year = 2016,
		month = 10,
		count = 27,
		reward = [],
		is_double = 0,
		vip_double = 0
	};

get({2016,10,28}) ->
	#everyday_sign_conf{
		key = 271,
		year = 2016,
		month = 10,
		count = 28,
		reward = [],
		is_double = 1,
		vip_double = 12
	};

get({2016,10,29}) ->
	#everyday_sign_conf{
		key = 272,
		year = 2016,
		month = 10,
		count = 29,
		reward = [],
		is_double = 0,
		vip_double = 0
	};

get({2016,10,30}) ->
	#everyday_sign_conf{
		key = 273,
		year = 2016,
		month = 10,
		count = 30,
		reward = [],
		is_double = 1,
		vip_double = 12
	};

get({2016,10,31}) ->
	#everyday_sign_conf{
		key = 274,
		year = 2016,
		month = 10,
		count = 31,
		reward = [],
		is_double = 0,
		vip_double = 0
	};

get({2016,11,1}) ->
	#everyday_sign_conf{
		key = 275,
		year = 2016,
		month = 11,
		count = 1,
		reward = [],
		is_double = 0,
		vip_double = 0
	};

get({2016,11,2}) ->
	#everyday_sign_conf{
		key = 276,
		year = 2016,
		month = 11,
		count = 2,
		reward = [{110050,1,1},{110045,1,200},{110148,1,1},{110127,1,50}],
		is_double = 1,
		vip_double = 1
	};

get({2016,11,3}) ->
	#everyday_sign_conf{
		key = 277,
		year = 2016,
		month = 11,
		count = 3,
		reward = [],
		is_double = 0,
		vip_double = 0
	};

get({2016,11,4}) ->
	#everyday_sign_conf{
		key = 278,
		year = 2016,
		month = 11,
		count = 4,
		reward = [],
		is_double = 1,
		vip_double = 1
	};

get({2016,11,5}) ->
	#everyday_sign_conf{
		key = 279,
		year = 2016,
		month = 11,
		count = 5,
		reward = [{110050,1,1},{110045,1,300},{110148,1,1},{110127,1,100}],
		is_double = 0,
		vip_double = 0
	};

get({2016,11,6}) ->
	#everyday_sign_conf{
		key = 280,
		year = 2016,
		month = 11,
		count = 6,
		reward = [],
		is_double = 1,
		vip_double = 2
	};

get({2016,11,7}) ->
	#everyday_sign_conf{
		key = 281,
		year = 2016,
		month = 11,
		count = 7,
		reward = [],
		is_double = 0,
		vip_double = 0
	};

get({2016,11,8}) ->
	#everyday_sign_conf{
		key = 282,
		year = 2016,
		month = 11,
		count = 8,
		reward = [],
		is_double = 1,
		vip_double = 2
	};

get({2016,11,9}) ->
	#everyday_sign_conf{
		key = 283,
		year = 2016,
		month = 11,
		count = 9,
		reward = [],
		is_double = 0,
		vip_double = 0
	};

get({2016,11,10}) ->
	#everyday_sign_conf{
		key = 284,
		year = 2016,
		month = 11,
		count = 10,
		reward = [{110050,1,1},{110045,1,400},{110148,1,1},{110127,1,150}],
		is_double = 1,
		vip_double = 3
	};

get({2016,11,11}) ->
	#everyday_sign_conf{
		key = 285,
		year = 2016,
		month = 11,
		count = 11,
		reward = [],
		is_double = 0,
		vip_double = 0
	};

get({2016,11,12}) ->
	#everyday_sign_conf{
		key = 286,
		year = 2016,
		month = 11,
		count = 12,
		reward = [],
		is_double = 1,
		vip_double = 4
	};

get({2016,11,13}) ->
	#everyday_sign_conf{
		key = 287,
		year = 2016,
		month = 11,
		count = 13,
		reward = [],
		is_double = 0,
		vip_double = 0
	};

get({2016,11,14}) ->
	#everyday_sign_conf{
		key = 288,
		year = 2016,
		month = 11,
		count = 14,
		reward = [],
		is_double = 1,
		vip_double = 5
	};

get({2016,11,15}) ->
	#everyday_sign_conf{
		key = 289,
		year = 2016,
		month = 11,
		count = 15,
		reward = [],
		is_double = 0,
		vip_double = 0
	};

get({2016,11,16}) ->
	#everyday_sign_conf{
		key = 290,
		year = 2016,
		month = 11,
		count = 16,
		reward = [],
		is_double = 1,
		vip_double = 6
	};

get({2016,11,17}) ->
	#everyday_sign_conf{
		key = 291,
		year = 2016,
		month = 11,
		count = 17,
		reward = [{110050,1,1},{110045,1,500},{110148,1,2},{110127,1,200}],
		is_double = 0,
		vip_double = 0
	};

get({2016,11,18}) ->
	#everyday_sign_conf{
		key = 292,
		year = 2016,
		month = 11,
		count = 18,
		reward = [],
		is_double = 1,
		vip_double = 7
	};

get({2016,11,19}) ->
	#everyday_sign_conf{
		key = 293,
		year = 2016,
		month = 11,
		count = 19,
		reward = [],
		is_double = 0,
		vip_double = 0
	};

get({2016,11,20}) ->
	#everyday_sign_conf{
		key = 294,
		year = 2016,
		month = 11,
		count = 20,
		reward = [],
		is_double = 1,
		vip_double = 8
	};

get({2016,11,21}) ->
	#everyday_sign_conf{
		key = 295,
		year = 2016,
		month = 11,
		count = 21,
		reward = [],
		is_double = 0,
		vip_double = 0
	};

get({2016,11,22}) ->
	#everyday_sign_conf{
		key = 296,
		year = 2016,
		month = 11,
		count = 22,
		reward = [],
		is_double = 1,
		vip_double = 9
	};

get({2016,11,23}) ->
	#everyday_sign_conf{
		key = 297,
		year = 2016,
		month = 11,
		count = 23,
		reward = [],
		is_double = 0,
		vip_double = 0
	};

get({2016,11,24}) ->
	#everyday_sign_conf{
		key = 298,
		year = 2016,
		month = 11,
		count = 24,
		reward = [],
		is_double = 1,
		vip_double = 10
	};

get({2016,11,25}) ->
	#everyday_sign_conf{
		key = 299,
		year = 2016,
		month = 11,
		count = 25,
		reward = [],
		is_double = 0,
		vip_double = 0
	};

get({2016,11,26}) ->
	#everyday_sign_conf{
		key = 300,
		year = 2016,
		month = 11,
		count = 26,
		reward = [{110050,1,1},{110045,1,600},{110149,1,1},{110140,1,10}],
		is_double = 1,
		vip_double = 11
	};

get({2016,11,27}) ->
	#everyday_sign_conf{
		key = 301,
		year = 2016,
		month = 11,
		count = 27,
		reward = [],
		is_double = 0,
		vip_double = 0
	};

get({2016,11,28}) ->
	#everyday_sign_conf{
		key = 302,
		year = 2016,
		month = 11,
		count = 28,
		reward = [],
		is_double = 1,
		vip_double = 12
	};

get({2016,11,29}) ->
	#everyday_sign_conf{
		key = 303,
		year = 2016,
		month = 11,
		count = 29,
		reward = [],
		is_double = 0,
		vip_double = 0
	};

get({2016,11,30}) ->
	#everyday_sign_conf{
		key = 304,
		year = 2016,
		month = 11,
		count = 30,
		reward = [],
		is_double = 1,
		vip_double = 12
	};

get({2016,12,1}) ->
	#everyday_sign_conf{
		key = 305,
		year = 2016,
		month = 12,
		count = 1,
		reward = [],
		is_double = 0,
		vip_double = 0
	};

get({2016,12,2}) ->
	#everyday_sign_conf{
		key = 306,
		year = 2016,
		month = 12,
		count = 2,
		reward = [{110050,1,1},{110045,1,200},{110148,1,1},{110127,1,50}],
		is_double = 1,
		vip_double = 1
	};

get({2016,12,3}) ->
	#everyday_sign_conf{
		key = 307,
		year = 2016,
		month = 12,
		count = 3,
		reward = [],
		is_double = 0,
		vip_double = 0
	};

get({2016,12,4}) ->
	#everyday_sign_conf{
		key = 308,
		year = 2016,
		month = 12,
		count = 4,
		reward = [],
		is_double = 1,
		vip_double = 1
	};

get({2016,12,5}) ->
	#everyday_sign_conf{
		key = 309,
		year = 2016,
		month = 12,
		count = 5,
		reward = [{110050,1,1},{110045,1,300},{110148,1,1},{110127,1,100}],
		is_double = 0,
		vip_double = 0
	};

get({2016,12,6}) ->
	#everyday_sign_conf{
		key = 310,
		year = 2016,
		month = 12,
		count = 6,
		reward = [],
		is_double = 1,
		vip_double = 2
	};

get({2016,12,7}) ->
	#everyday_sign_conf{
		key = 311,
		year = 2016,
		month = 12,
		count = 7,
		reward = [],
		is_double = 0,
		vip_double = 0
	};

get({2016,12,8}) ->
	#everyday_sign_conf{
		key = 312,
		year = 2016,
		month = 12,
		count = 8,
		reward = [],
		is_double = 1,
		vip_double = 2
	};

get({2016,12,9}) ->
	#everyday_sign_conf{
		key = 313,
		year = 2016,
		month = 12,
		count = 9,
		reward = [],
		is_double = 0,
		vip_double = 0
	};

get({2016,12,10}) ->
	#everyday_sign_conf{
		key = 314,
		year = 2016,
		month = 12,
		count = 10,
		reward = [{110050,1,1},{110045,1,400},{110148,1,1},{110127,1,150}],
		is_double = 1,
		vip_double = 3
	};

get({2016,12,11}) ->
	#everyday_sign_conf{
		key = 315,
		year = 2016,
		month = 12,
		count = 11,
		reward = [],
		is_double = 0,
		vip_double = 0
	};

get({2016,12,12}) ->
	#everyday_sign_conf{
		key = 316,
		year = 2016,
		month = 12,
		count = 12,
		reward = [],
		is_double = 1,
		vip_double = 4
	};

get({2016,12,13}) ->
	#everyday_sign_conf{
		key = 317,
		year = 2016,
		month = 12,
		count = 13,
		reward = [],
		is_double = 0,
		vip_double = 0
	};

get({2016,12,14}) ->
	#everyday_sign_conf{
		key = 318,
		year = 2016,
		month = 12,
		count = 14,
		reward = [],
		is_double = 1,
		vip_double = 5
	};

get({2016,12,15}) ->
	#everyday_sign_conf{
		key = 319,
		year = 2016,
		month = 12,
		count = 15,
		reward = [],
		is_double = 0,
		vip_double = 0
	};

get({2016,12,16}) ->
	#everyday_sign_conf{
		key = 320,
		year = 2016,
		month = 12,
		count = 16,
		reward = [],
		is_double = 1,
		vip_double = 6
	};

get({2016,12,17}) ->
	#everyday_sign_conf{
		key = 321,
		year = 2016,
		month = 12,
		count = 17,
		reward = [{110050,1,1},{110045,1,500},{110148,1,2},{110127,1,200}],
		is_double = 0,
		vip_double = 0
	};

get({2016,12,18}) ->
	#everyday_sign_conf{
		key = 322,
		year = 2016,
		month = 12,
		count = 18,
		reward = [],
		is_double = 1,
		vip_double = 7
	};

get({2016,12,19}) ->
	#everyday_sign_conf{
		key = 323,
		year = 2016,
		month = 12,
		count = 19,
		reward = [],
		is_double = 0,
		vip_double = 0
	};

get({2016,12,20}) ->
	#everyday_sign_conf{
		key = 324,
		year = 2016,
		month = 12,
		count = 20,
		reward = [],
		is_double = 1,
		vip_double = 8
	};

get({2016,12,21}) ->
	#everyday_sign_conf{
		key = 325,
		year = 2016,
		month = 12,
		count = 21,
		reward = [],
		is_double = 0,
		vip_double = 0
	};

get({2016,12,22}) ->
	#everyday_sign_conf{
		key = 326,
		year = 2016,
		month = 12,
		count = 22,
		reward = [],
		is_double = 1,
		vip_double = 9
	};

get({2016,12,23}) ->
	#everyday_sign_conf{
		key = 327,
		year = 2016,
		month = 12,
		count = 23,
		reward = [],
		is_double = 0,
		vip_double = 0
	};

get({2016,12,24}) ->
	#everyday_sign_conf{
		key = 328,
		year = 2016,
		month = 12,
		count = 24,
		reward = [],
		is_double = 1,
		vip_double = 10
	};

get({2016,12,25}) ->
	#everyday_sign_conf{
		key = 329,
		year = 2016,
		month = 12,
		count = 25,
		reward = [],
		is_double = 0,
		vip_double = 0
	};

get({2016,12,26}) ->
	#everyday_sign_conf{
		key = 330,
		year = 2016,
		month = 12,
		count = 26,
		reward = [{110050,1,1},{110045,1,600},{110149,1,1},{110140,1,10}],
		is_double = 1,
		vip_double = 11
	};

get({2016,12,27}) ->
	#everyday_sign_conf{
		key = 331,
		year = 2016,
		month = 12,
		count = 27,
		reward = [],
		is_double = 0,
		vip_double = 0
	};

get({2016,12,28}) ->
	#everyday_sign_conf{
		key = 332,
		year = 2016,
		month = 12,
		count = 28,
		reward = [],
		is_double = 1,
		vip_double = 12
	};

get({2016,12,29}) ->
	#everyday_sign_conf{
		key = 333,
		year = 2016,
		month = 12,
		count = 29,
		reward = [],
		is_double = 0,
		vip_double = 0
	};

get({2016,12,30}) ->
	#everyday_sign_conf{
		key = 334,
		year = 2016,
		month = 12,
		count = 30,
		reward = [],
		is_double = 1,
		vip_double = 12
	};

get({2016,12,31}) ->
	#everyday_sign_conf{
		key = 335,
		year = 2016,
		month = 12,
		count = 31,
		reward = [],
		is_double = 0,
		vip_double = 0
	};

get({2017,1,1}) ->
	#everyday_sign_conf{
		key = 336,
		year = 2017,
		month = 1,
		count = 1,
		reward = [],
		is_double = 0,
		vip_double = 0
	};

get({2017,1,2}) ->
	#everyday_sign_conf{
		key = 337,
		year = 2017,
		month = 1,
		count = 2,
		reward = [{110009,1,500000},{110045,1,100},{110148,1,1},{110127,1,30}],
		is_double = 0,
		vip_double = 0
	};

get({2017,1,3}) ->
	#everyday_sign_conf{
		key = 338,
		year = 2017,
		month = 1,
		count = 3,
		reward = [],
		is_double = 0,
		vip_double = 0
	};

get({2017,1,4}) ->
	#everyday_sign_conf{
		key = 339,
		year = 2017,
		month = 1,
		count = 4,
		reward = [],
		is_double = 0,
		vip_double = 0
	};

get({2017,1,5}) ->
	#everyday_sign_conf{
		key = 340,
		year = 2017,
		month = 1,
		count = 5,
		reward = [{110009,1,500000},{110045,1,150},{110148,1,1},{110127,1,60}],
		is_double = 0,
		vip_double = 0
	};

get({2017,1,6}) ->
	#everyday_sign_conf{
		key = 341,
		year = 2017,
		month = 1,
		count = 6,
		reward = [],
		is_double = 0,
		vip_double = 0
	};

get({2017,1,7}) ->
	#everyday_sign_conf{
		key = 342,
		year = 2017,
		month = 1,
		count = 7,
		reward = [],
		is_double = 0,
		vip_double = 0
	};

get({2017,1,8}) ->
	#everyday_sign_conf{
		key = 343,
		year = 2017,
		month = 1,
		count = 8,
		reward = [],
		is_double = 0,
		vip_double = 0
	};

get({2017,1,9}) ->
	#everyday_sign_conf{
		key = 344,
		year = 2017,
		month = 1,
		count = 9,
		reward = [],
		is_double = 0,
		vip_double = 0
	};

get({2017,1,10}) ->
	#everyday_sign_conf{
		key = 345,
		year = 2017,
		month = 1,
		count = 10,
		reward = [{110009,1,500000},{110045,1,200},{110148,1,1},{110127,1,90}],
		is_double = 0,
		vip_double = 0
	};

get({2017,1,11}) ->
	#everyday_sign_conf{
		key = 346,
		year = 2017,
		month = 1,
		count = 11,
		reward = [],
		is_double = 0,
		vip_double = 0
	};

get({2017,1,12}) ->
	#everyday_sign_conf{
		key = 347,
		year = 2017,
		month = 1,
		count = 12,
		reward = [],
		is_double = 0,
		vip_double = 0
	};

get({2017,1,13}) ->
	#everyday_sign_conf{
		key = 348,
		year = 2017,
		month = 1,
		count = 13,
		reward = [],
		is_double = 0,
		vip_double = 0
	};

get({2017,1,14}) ->
	#everyday_sign_conf{
		key = 349,
		year = 2017,
		month = 1,
		count = 14,
		reward = [],
		is_double = 0,
		vip_double = 0
	};

get({2017,1,15}) ->
	#everyday_sign_conf{
		key = 350,
		year = 2017,
		month = 1,
		count = 15,
		reward = [],
		is_double = 0,
		vip_double = 0
	};

get({2017,1,16}) ->
	#everyday_sign_conf{
		key = 351,
		year = 2017,
		month = 1,
		count = 16,
		reward = [],
		is_double = 0,
		vip_double = 0
	};

get({2017,1,17}) ->
	#everyday_sign_conf{
		key = 352,
		year = 2017,
		month = 1,
		count = 17,
		reward = [{110009,1,500000},{110045,1,250},{110148,1,2},{110127,1,120}],
		is_double = 0,
		vip_double = 0
	};

get({2017,1,18}) ->
	#everyday_sign_conf{
		key = 353,
		year = 2017,
		month = 1,
		count = 18,
		reward = [],
		is_double = 0,
		vip_double = 0
	};

get({2017,1,19}) ->
	#everyday_sign_conf{
		key = 354,
		year = 2017,
		month = 1,
		count = 19,
		reward = [],
		is_double = 0,
		vip_double = 0
	};

get({2017,1,20}) ->
	#everyday_sign_conf{
		key = 355,
		year = 2017,
		month = 1,
		count = 20,
		reward = [],
		is_double = 0,
		vip_double = 0
	};

get({2017,1,21}) ->
	#everyday_sign_conf{
		key = 356,
		year = 2017,
		month = 1,
		count = 21,
		reward = [],
		is_double = 0,
		vip_double = 0
	};

get({2017,1,22}) ->
	#everyday_sign_conf{
		key = 357,
		year = 2017,
		month = 1,
		count = 22,
		reward = [],
		is_double = 0,
		vip_double = 0
	};

get({2017,1,23}) ->
	#everyday_sign_conf{
		key = 358,
		year = 2017,
		month = 1,
		count = 23,
		reward = [],
		is_double = 0,
		vip_double = 0
	};

get({2017,1,24}) ->
	#everyday_sign_conf{
		key = 359,
		year = 2017,
		month = 1,
		count = 24,
		reward = [],
		is_double = 0,
		vip_double = 0
	};

get({2017,1,25}) ->
	#everyday_sign_conf{
		key = 360,
		year = 2017,
		month = 1,
		count = 25,
		reward = [],
		is_double = 0,
		vip_double = 0
	};

get({2017,1,26}) ->
	#everyday_sign_conf{
		key = 361,
		year = 2017,
		month = 1,
		count = 26,
		reward = [{110009,1,500000},{110045,1,300},{110149,1,1},{110140,1,10}],
		is_double = 0,
		vip_double = 0
	};

get({2017,1,27}) ->
	#everyday_sign_conf{
		key = 362,
		year = 2017,
		month = 1,
		count = 27,
		reward = [],
		is_double = 0,
		vip_double = 0
	};

get({2017,1,28}) ->
	#everyday_sign_conf{
		key = 363,
		year = 2017,
		month = 1,
		count = 28,
		reward = [],
		is_double = 0,
		vip_double = 0
	};

get({2017,1,29}) ->
	#everyday_sign_conf{
		key = 364,
		year = 2017,
		month = 1,
		count = 29,
		reward = [],
		is_double = 0,
		vip_double = 0
	};

get({2017,1,30}) ->
	#everyday_sign_conf{
		key = 365,
		year = 2017,
		month = 1,
		count = 30,
		reward = [],
		is_double = 0,
		vip_double = 0
	};

get({2017,1,31}) ->
	#everyday_sign_conf{
		key = 366,
		year = 2017,
		month = 1,
		count = 31,
		reward = [],
		is_double = 0,
		vip_double = 0
	};

get({2017,2,1}) ->
	#everyday_sign_conf{
		key = 367,
		year = 2017,
		month = 2,
		count = 1,
		reward = [],
		is_double = 0,
		vip_double = 0
	};

get({2017,2,2}) ->
	#everyday_sign_conf{
		key = 368,
		year = 2017,
		month = 2,
		count = 2,
		reward = [{110009,1,500000},{110045,1,100},{110148,1,1},{110127,1,30}],
		is_double = 0,
		vip_double = 0
	};

get({2017,2,3}) ->
	#everyday_sign_conf{
		key = 369,
		year = 2017,
		month = 2,
		count = 3,
		reward = [],
		is_double = 0,
		vip_double = 0
	};

get({2017,2,4}) ->
	#everyday_sign_conf{
		key = 370,
		year = 2017,
		month = 2,
		count = 4,
		reward = [],
		is_double = 0,
		vip_double = 0
	};

get({2017,2,5}) ->
	#everyday_sign_conf{
		key = 371,
		year = 2017,
		month = 2,
		count = 5,
		reward = [{110009,1,500000},{110045,1,150},{110148,1,1},{110127,1,60}],
		is_double = 0,
		vip_double = 0
	};

get({2017,2,6}) ->
	#everyday_sign_conf{
		key = 372,
		year = 2017,
		month = 2,
		count = 6,
		reward = [],
		is_double = 0,
		vip_double = 0
	};

get({2017,2,7}) ->
	#everyday_sign_conf{
		key = 373,
		year = 2017,
		month = 2,
		count = 7,
		reward = [],
		is_double = 0,
		vip_double = 0
	};

get({2017,2,8}) ->
	#everyday_sign_conf{
		key = 374,
		year = 2017,
		month = 2,
		count = 8,
		reward = [],
		is_double = 0,
		vip_double = 0
	};

get({2017,2,9}) ->
	#everyday_sign_conf{
		key = 375,
		year = 2017,
		month = 2,
		count = 9,
		reward = [],
		is_double = 0,
		vip_double = 0
	};

get({2017,2,10}) ->
	#everyday_sign_conf{
		key = 376,
		year = 2017,
		month = 2,
		count = 10,
		reward = [{110009,1,500000},{110045,1,200},{110148,1,1},{110127,1,90}],
		is_double = 0,
		vip_double = 0
	};

get({2017,2,11}) ->
	#everyday_sign_conf{
		key = 377,
		year = 2017,
		month = 2,
		count = 11,
		reward = [],
		is_double = 0,
		vip_double = 0
	};

get({2017,2,12}) ->
	#everyday_sign_conf{
		key = 378,
		year = 2017,
		month = 2,
		count = 12,
		reward = [],
		is_double = 0,
		vip_double = 0
	};

get({2017,2,13}) ->
	#everyday_sign_conf{
		key = 379,
		year = 2017,
		month = 2,
		count = 13,
		reward = [],
		is_double = 0,
		vip_double = 0
	};

get({2017,2,14}) ->
	#everyday_sign_conf{
		key = 380,
		year = 2017,
		month = 2,
		count = 14,
		reward = [],
		is_double = 0,
		vip_double = 0
	};

get({2017,2,15}) ->
	#everyday_sign_conf{
		key = 381,
		year = 2017,
		month = 2,
		count = 15,
		reward = [],
		is_double = 0,
		vip_double = 0
	};

get({2017,2,16}) ->
	#everyday_sign_conf{
		key = 382,
		year = 2017,
		month = 2,
		count = 16,
		reward = [],
		is_double = 0,
		vip_double = 0
	};

get({2017,2,17}) ->
	#everyday_sign_conf{
		key = 383,
		year = 2017,
		month = 2,
		count = 17,
		reward = [{110009,1,500000},{110045,1,250},{110148,1,2},{110127,1,120}],
		is_double = 0,
		vip_double = 0
	};

get({2017,2,18}) ->
	#everyday_sign_conf{
		key = 384,
		year = 2017,
		month = 2,
		count = 18,
		reward = [],
		is_double = 0,
		vip_double = 0
	};

get({2017,2,19}) ->
	#everyday_sign_conf{
		key = 385,
		year = 2017,
		month = 2,
		count = 19,
		reward = [],
		is_double = 0,
		vip_double = 0
	};

get({2017,2,20}) ->
	#everyday_sign_conf{
		key = 386,
		year = 2017,
		month = 2,
		count = 20,
		reward = [],
		is_double = 0,
		vip_double = 0
	};

get({2017,2,21}) ->
	#everyday_sign_conf{
		key = 387,
		year = 2017,
		month = 2,
		count = 21,
		reward = [],
		is_double = 0,
		vip_double = 0
	};

get({2017,2,22}) ->
	#everyday_sign_conf{
		key = 388,
		year = 2017,
		month = 2,
		count = 22,
		reward = [],
		is_double = 0,
		vip_double = 0
	};

get({2017,2,23}) ->
	#everyday_sign_conf{
		key = 389,
		year = 2017,
		month = 2,
		count = 23,
		reward = [],
		is_double = 0,
		vip_double = 0
	};

get({2017,2,24}) ->
	#everyday_sign_conf{
		key = 390,
		year = 2017,
		month = 2,
		count = 24,
		reward = [],
		is_double = 0,
		vip_double = 0
	};

get({2017,2,25}) ->
	#everyday_sign_conf{
		key = 391,
		year = 2017,
		month = 2,
		count = 25,
		reward = [],
		is_double = 0,
		vip_double = 0
	};

get({2017,2,26}) ->
	#everyday_sign_conf{
		key = 392,
		year = 2017,
		month = 2,
		count = 26,
		reward = [{110009,1,500000},{110045,1,300},{110149,1,1},{110140,1,10}],
		is_double = 0,
		vip_double = 0
	};

get({2017,2,27}) ->
	#everyday_sign_conf{
		key = 393,
		year = 2017,
		month = 2,
		count = 27,
		reward = [],
		is_double = 0,
		vip_double = 0
	};

get({2017,2,28}) ->
	#everyday_sign_conf{
		key = 394,
		year = 2017,
		month = 2,
		count = 28,
		reward = [],
		is_double = 0,
		vip_double = 0
	};

get({2017,3,1}) ->
	#everyday_sign_conf{
		key = 395,
		year = 2017,
		month = 3,
		count = 1,
		reward = [],
		is_double = 0,
		vip_double = 0
	};

get({2017,3,2}) ->
	#everyday_sign_conf{
		key = 396,
		year = 2017,
		month = 3,
		count = 2,
		reward = [{110009,1,500000},{110045,1,100},{110148,1,1},{110127,1,30}],
		is_double = 0,
		vip_double = 0
	};

get({2017,3,3}) ->
	#everyday_sign_conf{
		key = 397,
		year = 2017,
		month = 3,
		count = 3,
		reward = [],
		is_double = 0,
		vip_double = 0
	};

get({2017,3,4}) ->
	#everyday_sign_conf{
		key = 398,
		year = 2017,
		month = 3,
		count = 4,
		reward = [],
		is_double = 0,
		vip_double = 0
	};

get({2017,3,5}) ->
	#everyday_sign_conf{
		key = 399,
		year = 2017,
		month = 3,
		count = 5,
		reward = [{110009,1,500000},{110045,1,150},{110148,1,1},{110127,1,60}],
		is_double = 0,
		vip_double = 0
	};

get({2017,3,6}) ->
	#everyday_sign_conf{
		key = 400,
		year = 2017,
		month = 3,
		count = 6,
		reward = [],
		is_double = 0,
		vip_double = 0
	};

get({2017,3,7}) ->
	#everyday_sign_conf{
		key = 401,
		year = 2017,
		month = 3,
		count = 7,
		reward = [],
		is_double = 0,
		vip_double = 0
	};

get({2017,3,8}) ->
	#everyday_sign_conf{
		key = 402,
		year = 2017,
		month = 3,
		count = 8,
		reward = [],
		is_double = 0,
		vip_double = 0
	};

get({2017,3,9}) ->
	#everyday_sign_conf{
		key = 403,
		year = 2017,
		month = 3,
		count = 9,
		reward = [],
		is_double = 0,
		vip_double = 0
	};

get({2017,3,10}) ->
	#everyday_sign_conf{
		key = 404,
		year = 2017,
		month = 3,
		count = 10,
		reward = [{110009,1,500000},{110045,1,200},{110148,1,1},{110127,1,90}],
		is_double = 0,
		vip_double = 0
	};

get({2017,3,11}) ->
	#everyday_sign_conf{
		key = 405,
		year = 2017,
		month = 3,
		count = 11,
		reward = [],
		is_double = 0,
		vip_double = 0
	};

get({2017,3,12}) ->
	#everyday_sign_conf{
		key = 406,
		year = 2017,
		month = 3,
		count = 12,
		reward = [],
		is_double = 0,
		vip_double = 0
	};

get({2017,3,13}) ->
	#everyday_sign_conf{
		key = 407,
		year = 2017,
		month = 3,
		count = 13,
		reward = [],
		is_double = 0,
		vip_double = 0
	};

get({2017,3,14}) ->
	#everyday_sign_conf{
		key = 408,
		year = 2017,
		month = 3,
		count = 14,
		reward = [],
		is_double = 0,
		vip_double = 0
	};

get({2017,3,15}) ->
	#everyday_sign_conf{
		key = 409,
		year = 2017,
		month = 3,
		count = 15,
		reward = [],
		is_double = 0,
		vip_double = 0
	};

get({2017,3,16}) ->
	#everyday_sign_conf{
		key = 410,
		year = 2017,
		month = 3,
		count = 16,
		reward = [],
		is_double = 0,
		vip_double = 0
	};

get({2017,3,17}) ->
	#everyday_sign_conf{
		key = 411,
		year = 2017,
		month = 3,
		count = 17,
		reward = [{110009,1,500000},{110045,1,250},{110148,1,2},{110127,1,120}],
		is_double = 0,
		vip_double = 0
	};

get({2017,3,18}) ->
	#everyday_sign_conf{
		key = 412,
		year = 2017,
		month = 3,
		count = 18,
		reward = [],
		is_double = 0,
		vip_double = 0
	};

get({2017,3,19}) ->
	#everyday_sign_conf{
		key = 413,
		year = 2017,
		month = 3,
		count = 19,
		reward = [],
		is_double = 0,
		vip_double = 0
	};

get({2017,3,20}) ->
	#everyday_sign_conf{
		key = 414,
		year = 2017,
		month = 3,
		count = 20,
		reward = [],
		is_double = 0,
		vip_double = 0
	};

get({2017,3,21}) ->
	#everyday_sign_conf{
		key = 415,
		year = 2017,
		month = 3,
		count = 21,
		reward = [],
		is_double = 0,
		vip_double = 0
	};

get({2017,3,22}) ->
	#everyday_sign_conf{
		key = 416,
		year = 2017,
		month = 3,
		count = 22,
		reward = [],
		is_double = 0,
		vip_double = 0
	};

get({2017,3,23}) ->
	#everyday_sign_conf{
		key = 417,
		year = 2017,
		month = 3,
		count = 23,
		reward = [],
		is_double = 0,
		vip_double = 0
	};

get({2017,3,24}) ->
	#everyday_sign_conf{
		key = 418,
		year = 2017,
		month = 3,
		count = 24,
		reward = [],
		is_double = 0,
		vip_double = 0
	};

get({2017,3,25}) ->
	#everyday_sign_conf{
		key = 419,
		year = 2017,
		month = 3,
		count = 25,
		reward = [],
		is_double = 0,
		vip_double = 0
	};

get({2017,3,26}) ->
	#everyday_sign_conf{
		key = 420,
		year = 2017,
		month = 3,
		count = 26,
		reward = [{110009,1,500000},{110045,1,300},{110149,1,1},{110140,1,10}],
		is_double = 0,
		vip_double = 0
	};

get({2017,3,27}) ->
	#everyday_sign_conf{
		key = 421,
		year = 2017,
		month = 3,
		count = 27,
		reward = [],
		is_double = 0,
		vip_double = 0
	};

get({2017,3,28}) ->
	#everyday_sign_conf{
		key = 422,
		year = 2017,
		month = 3,
		count = 28,
		reward = [],
		is_double = 0,
		vip_double = 0
	};

get({2017,3,29}) ->
	#everyday_sign_conf{
		key = 423,
		year = 2017,
		month = 3,
		count = 29,
		reward = [],
		is_double = 0,
		vip_double = 0
	};

get({2017,3,30}) ->
	#everyday_sign_conf{
		key = 424,
		year = 2017,
		month = 3,
		count = 30,
		reward = [],
		is_double = 0,
		vip_double = 0
	};

get({2017,3,31}) ->
	#everyday_sign_conf{
		key = 425,
		year = 2017,
		month = 3,
		count = 31,
		reward = [],
		is_double = 0,
		vip_double = 0
	};

get({2017,4,1}) ->
	#everyday_sign_conf{
		key = 426,
		year = 2017,
		month = 4,
		count = 1,
		reward = [],
		is_double = 0,
		vip_double = 0
	};

get({2017,4,2}) ->
	#everyday_sign_conf{
		key = 427,
		year = 2017,
		month = 4,
		count = 2,
		reward = [{110009,1,500000},{110045,1,100},{110148,1,1},{110127,1,30}],
		is_double = 0,
		vip_double = 0
	};

get({2017,4,3}) ->
	#everyday_sign_conf{
		key = 428,
		year = 2017,
		month = 4,
		count = 3,
		reward = [],
		is_double = 0,
		vip_double = 0
	};

get({2017,4,4}) ->
	#everyday_sign_conf{
		key = 429,
		year = 2017,
		month = 4,
		count = 4,
		reward = [],
		is_double = 0,
		vip_double = 0
	};

get({2017,4,5}) ->
	#everyday_sign_conf{
		key = 430,
		year = 2017,
		month = 4,
		count = 5,
		reward = [{110009,1,500000},{110045,1,150},{110148,1,1},{110127,1,60}],
		is_double = 0,
		vip_double = 0
	};

get({2017,4,6}) ->
	#everyday_sign_conf{
		key = 431,
		year = 2017,
		month = 4,
		count = 6,
		reward = [],
		is_double = 0,
		vip_double = 0
	};

get({2017,4,7}) ->
	#everyday_sign_conf{
		key = 432,
		year = 2017,
		month = 4,
		count = 7,
		reward = [],
		is_double = 0,
		vip_double = 0
	};

get({2017,4,8}) ->
	#everyday_sign_conf{
		key = 433,
		year = 2017,
		month = 4,
		count = 8,
		reward = [],
		is_double = 0,
		vip_double = 0
	};

get({2017,4,9}) ->
	#everyday_sign_conf{
		key = 434,
		year = 2017,
		month = 4,
		count = 9,
		reward = [],
		is_double = 0,
		vip_double = 0
	};

get({2017,4,10}) ->
	#everyday_sign_conf{
		key = 435,
		year = 2017,
		month = 4,
		count = 10,
		reward = [{110009,1,500000},{110045,1,200},{110148,1,1},{110127,1,90}],
		is_double = 0,
		vip_double = 0
	};

get({2017,4,11}) ->
	#everyday_sign_conf{
		key = 436,
		year = 2017,
		month = 4,
		count = 11,
		reward = [],
		is_double = 0,
		vip_double = 0
	};

get({2017,4,12}) ->
	#everyday_sign_conf{
		key = 437,
		year = 2017,
		month = 4,
		count = 12,
		reward = [],
		is_double = 0,
		vip_double = 0
	};

get({2017,4,13}) ->
	#everyday_sign_conf{
		key = 438,
		year = 2017,
		month = 4,
		count = 13,
		reward = [],
		is_double = 0,
		vip_double = 0
	};

get({2017,4,14}) ->
	#everyday_sign_conf{
		key = 439,
		year = 2017,
		month = 4,
		count = 14,
		reward = [],
		is_double = 0,
		vip_double = 0
	};

get({2017,4,15}) ->
	#everyday_sign_conf{
		key = 440,
		year = 2017,
		month = 4,
		count = 15,
		reward = [],
		is_double = 0,
		vip_double = 0
	};

get({2017,4,16}) ->
	#everyday_sign_conf{
		key = 441,
		year = 2017,
		month = 4,
		count = 16,
		reward = [],
		is_double = 0,
		vip_double = 0
	};

get({2017,4,17}) ->
	#everyday_sign_conf{
		key = 442,
		year = 2017,
		month = 4,
		count = 17,
		reward = [{110009,1,500000},{110045,1,250},{110148,1,2},{110127,1,120}],
		is_double = 0,
		vip_double = 0
	};

get({2017,4,18}) ->
	#everyday_sign_conf{
		key = 443,
		year = 2017,
		month = 4,
		count = 18,
		reward = [],
		is_double = 0,
		vip_double = 0
	};

get({2017,4,19}) ->
	#everyday_sign_conf{
		key = 444,
		year = 2017,
		month = 4,
		count = 19,
		reward = [],
		is_double = 0,
		vip_double = 0
	};

get({2017,4,20}) ->
	#everyday_sign_conf{
		key = 445,
		year = 2017,
		month = 4,
		count = 20,
		reward = [],
		is_double = 0,
		vip_double = 0
	};

get({2017,4,21}) ->
	#everyday_sign_conf{
		key = 446,
		year = 2017,
		month = 4,
		count = 21,
		reward = [],
		is_double = 0,
		vip_double = 0
	};

get({2017,4,22}) ->
	#everyday_sign_conf{
		key = 447,
		year = 2017,
		month = 4,
		count = 22,
		reward = [],
		is_double = 0,
		vip_double = 0
	};

get({2017,4,23}) ->
	#everyday_sign_conf{
		key = 448,
		year = 2017,
		month = 4,
		count = 23,
		reward = [],
		is_double = 0,
		vip_double = 0
	};

get({2017,4,24}) ->
	#everyday_sign_conf{
		key = 449,
		year = 2017,
		month = 4,
		count = 24,
		reward = [],
		is_double = 0,
		vip_double = 0
	};

get({2017,4,25}) ->
	#everyday_sign_conf{
		key = 450,
		year = 2017,
		month = 4,
		count = 25,
		reward = [],
		is_double = 0,
		vip_double = 0
	};

get({2017,4,26}) ->
	#everyday_sign_conf{
		key = 451,
		year = 2017,
		month = 4,
		count = 26,
		reward = [{110009,1,500000},{110045,1,300},{110149,1,1},{110140,1,10}],
		is_double = 0,
		vip_double = 0
	};

get({2017,4,27}) ->
	#everyday_sign_conf{
		key = 452,
		year = 2017,
		month = 4,
		count = 27,
		reward = [],
		is_double = 0,
		vip_double = 0
	};

get({2017,4,28}) ->
	#everyday_sign_conf{
		key = 453,
		year = 2017,
		month = 4,
		count = 28,
		reward = [],
		is_double = 0,
		vip_double = 0
	};

get({2017,4,29}) ->
	#everyday_sign_conf{
		key = 454,
		year = 2017,
		month = 4,
		count = 29,
		reward = [],
		is_double = 0,
		vip_double = 0
	};

get({2017,4,30}) ->
	#everyday_sign_conf{
		key = 455,
		year = 2017,
		month = 4,
		count = 30,
		reward = [],
		is_double = 0,
		vip_double = 0
	};

get({2017,5,1}) ->
	#everyday_sign_conf{
		key = 456,
		year = 2017,
		month = 5,
		count = 1,
		reward = [],
		is_double = 0,
		vip_double = 0
	};

get({2017,5,2}) ->
	#everyday_sign_conf{
		key = 457,
		year = 2017,
		month = 5,
		count = 2,
		reward = [{110009,1,500000},{110045,1,100},{110148,1,1},{110127,1,30}],
		is_double = 0,
		vip_double = 0
	};

get({2017,5,3}) ->
	#everyday_sign_conf{
		key = 458,
		year = 2017,
		month = 5,
		count = 3,
		reward = [],
		is_double = 0,
		vip_double = 0
	};

get({2017,5,4}) ->
	#everyday_sign_conf{
		key = 459,
		year = 2017,
		month = 5,
		count = 4,
		reward = [],
		is_double = 0,
		vip_double = 0
	};

get({2017,5,5}) ->
	#everyday_sign_conf{
		key = 460,
		year = 2017,
		month = 5,
		count = 5,
		reward = [{110009,1,500000},{110045,1,150},{110148,1,1},{110127,1,60}],
		is_double = 0,
		vip_double = 0
	};

get({2017,5,6}) ->
	#everyday_sign_conf{
		key = 461,
		year = 2017,
		month = 5,
		count = 6,
		reward = [],
		is_double = 0,
		vip_double = 0
	};

get({2017,5,7}) ->
	#everyday_sign_conf{
		key = 462,
		year = 2017,
		month = 5,
		count = 7,
		reward = [],
		is_double = 0,
		vip_double = 0
	};

get({2017,5,8}) ->
	#everyday_sign_conf{
		key = 463,
		year = 2017,
		month = 5,
		count = 8,
		reward = [],
		is_double = 0,
		vip_double = 0
	};

get({2017,5,9}) ->
	#everyday_sign_conf{
		key = 464,
		year = 2017,
		month = 5,
		count = 9,
		reward = [],
		is_double = 0,
		vip_double = 0
	};

get({2017,5,10}) ->
	#everyday_sign_conf{
		key = 465,
		year = 2017,
		month = 5,
		count = 10,
		reward = [{110009,1,500000},{110045,1,200},{110148,1,1},{110127,1,90}],
		is_double = 0,
		vip_double = 0
	};

get({2017,5,11}) ->
	#everyday_sign_conf{
		key = 466,
		year = 2017,
		month = 5,
		count = 11,
		reward = [],
		is_double = 0,
		vip_double = 0
	};

get({2017,5,12}) ->
	#everyday_sign_conf{
		key = 467,
		year = 2017,
		month = 5,
		count = 12,
		reward = [],
		is_double = 0,
		vip_double = 0
	};

get({2017,5,13}) ->
	#everyday_sign_conf{
		key = 468,
		year = 2017,
		month = 5,
		count = 13,
		reward = [],
		is_double = 0,
		vip_double = 0
	};

get({2017,5,14}) ->
	#everyday_sign_conf{
		key = 469,
		year = 2017,
		month = 5,
		count = 14,
		reward = [],
		is_double = 0,
		vip_double = 0
	};

get({2017,5,15}) ->
	#everyday_sign_conf{
		key = 470,
		year = 2017,
		month = 5,
		count = 15,
		reward = [],
		is_double = 0,
		vip_double = 0
	};

get({2017,5,16}) ->
	#everyday_sign_conf{
		key = 471,
		year = 2017,
		month = 5,
		count = 16,
		reward = [],
		is_double = 0,
		vip_double = 0
	};

get({2017,5,17}) ->
	#everyday_sign_conf{
		key = 472,
		year = 2017,
		month = 5,
		count = 17,
		reward = [{110009,1,500000},{110045,1,250},{110148,1,2},{110127,1,120}],
		is_double = 0,
		vip_double = 0
	};

get({2017,5,18}) ->
	#everyday_sign_conf{
		key = 473,
		year = 2017,
		month = 5,
		count = 18,
		reward = [],
		is_double = 0,
		vip_double = 0
	};

get({2017,5,19}) ->
	#everyday_sign_conf{
		key = 474,
		year = 2017,
		month = 5,
		count = 19,
		reward = [],
		is_double = 0,
		vip_double = 0
	};

get({2017,5,20}) ->
	#everyday_sign_conf{
		key = 475,
		year = 2017,
		month = 5,
		count = 20,
		reward = [],
		is_double = 0,
		vip_double = 0
	};

get({2017,5,21}) ->
	#everyday_sign_conf{
		key = 476,
		year = 2017,
		month = 5,
		count = 21,
		reward = [],
		is_double = 0,
		vip_double = 0
	};

get({2017,5,22}) ->
	#everyday_sign_conf{
		key = 477,
		year = 2017,
		month = 5,
		count = 22,
		reward = [],
		is_double = 0,
		vip_double = 0
	};

get({2017,5,23}) ->
	#everyday_sign_conf{
		key = 478,
		year = 2017,
		month = 5,
		count = 23,
		reward = [],
		is_double = 0,
		vip_double = 0
	};

get({2017,5,24}) ->
	#everyday_sign_conf{
		key = 479,
		year = 2017,
		month = 5,
		count = 24,
		reward = [],
		is_double = 0,
		vip_double = 0
	};

get({2017,5,25}) ->
	#everyday_sign_conf{
		key = 480,
		year = 2017,
		month = 5,
		count = 25,
		reward = [],
		is_double = 0,
		vip_double = 0
	};

get({2017,5,26}) ->
	#everyday_sign_conf{
		key = 481,
		year = 2017,
		month = 5,
		count = 26,
		reward = [{110009,1,500000},{110045,1,300},{110149,1,1},{110140,1,10}],
		is_double = 0,
		vip_double = 0
	};

get({2017,5,27}) ->
	#everyday_sign_conf{
		key = 482,
		year = 2017,
		month = 5,
		count = 27,
		reward = [],
		is_double = 0,
		vip_double = 0
	};

get({2017,5,28}) ->
	#everyday_sign_conf{
		key = 483,
		year = 2017,
		month = 5,
		count = 28,
		reward = [],
		is_double = 0,
		vip_double = 0
	};

get({2017,5,29}) ->
	#everyday_sign_conf{
		key = 484,
		year = 2017,
		month = 5,
		count = 29,
		reward = [],
		is_double = 0,
		vip_double = 0
	};

get({2017,5,30}) ->
	#everyday_sign_conf{
		key = 485,
		year = 2017,
		month = 5,
		count = 30,
		reward = [],
		is_double = 0,
		vip_double = 0
	};

get({2017,5,31}) ->
	#everyday_sign_conf{
		key = 486,
		year = 2017,
		month = 5,
		count = 31,
		reward = [],
		is_double = 0,
		vip_double = 0
	};

get({2017,6,1}) ->
	#everyday_sign_conf{
		key = 487,
		year = 2017,
		month = 6,
		count = 1,
		reward = [],
		is_double = 0,
		vip_double = 0
	};

get({2017,6,2}) ->
	#everyday_sign_conf{
		key = 488,
		year = 2017,
		month = 6,
		count = 2,
		reward = [{110009,1,500000},{110045,1,100},{110148,1,1},{110127,1,30}],
		is_double = 0,
		vip_double = 0
	};

get({2017,6,3}) ->
	#everyday_sign_conf{
		key = 489,
		year = 2017,
		month = 6,
		count = 3,
		reward = [],
		is_double = 0,
		vip_double = 0
	};

get({2017,6,4}) ->
	#everyday_sign_conf{
		key = 490,
		year = 2017,
		month = 6,
		count = 4,
		reward = [],
		is_double = 0,
		vip_double = 0
	};

get({2017,6,5}) ->
	#everyday_sign_conf{
		key = 491,
		year = 2017,
		month = 6,
		count = 5,
		reward = [{110009,1,500000},{110045,1,150},{110148,1,1},{110127,1,60}],
		is_double = 0,
		vip_double = 0
	};

get({2017,6,6}) ->
	#everyday_sign_conf{
		key = 492,
		year = 2017,
		month = 6,
		count = 6,
		reward = [],
		is_double = 0,
		vip_double = 0
	};

get({2017,6,7}) ->
	#everyday_sign_conf{
		key = 493,
		year = 2017,
		month = 6,
		count = 7,
		reward = [],
		is_double = 0,
		vip_double = 0
	};

get({2017,6,8}) ->
	#everyday_sign_conf{
		key = 494,
		year = 2017,
		month = 6,
		count = 8,
		reward = [],
		is_double = 0,
		vip_double = 0
	};

get({2017,6,9}) ->
	#everyday_sign_conf{
		key = 495,
		year = 2017,
		month = 6,
		count = 9,
		reward = [],
		is_double = 0,
		vip_double = 0
	};

get({2017,6,10}) ->
	#everyday_sign_conf{
		key = 496,
		year = 2017,
		month = 6,
		count = 10,
		reward = [{110009,1,500000},{110045,1,200},{110148,1,1},{110127,1,90}],
		is_double = 0,
		vip_double = 0
	};

get({2017,6,11}) ->
	#everyday_sign_conf{
		key = 497,
		year = 2017,
		month = 6,
		count = 11,
		reward = [],
		is_double = 0,
		vip_double = 0
	};

get({2017,6,12}) ->
	#everyday_sign_conf{
		key = 498,
		year = 2017,
		month = 6,
		count = 12,
		reward = [],
		is_double = 0,
		vip_double = 0
	};

get({2017,6,13}) ->
	#everyday_sign_conf{
		key = 499,
		year = 2017,
		month = 6,
		count = 13,
		reward = [],
		is_double = 0,
		vip_double = 0
	};

get({2017,6,14}) ->
	#everyday_sign_conf{
		key = 500,
		year = 2017,
		month = 6,
		count = 14,
		reward = [],
		is_double = 0,
		vip_double = 0
	};

get({2017,6,15}) ->
	#everyday_sign_conf{
		key = 501,
		year = 2017,
		month = 6,
		count = 15,
		reward = [],
		is_double = 0,
		vip_double = 0
	};

get({2017,6,16}) ->
	#everyday_sign_conf{
		key = 502,
		year = 2017,
		month = 6,
		count = 16,
		reward = [],
		is_double = 0,
		vip_double = 0
	};

get({2017,6,17}) ->
	#everyday_sign_conf{
		key = 503,
		year = 2017,
		month = 6,
		count = 17,
		reward = [{110009,1,500000},{110045,1,250},{110148,1,2},{110127,1,120}],
		is_double = 0,
		vip_double = 0
	};

get({2017,6,18}) ->
	#everyday_sign_conf{
		key = 504,
		year = 2017,
		month = 6,
		count = 18,
		reward = [],
		is_double = 0,
		vip_double = 0
	};

get({2017,6,19}) ->
	#everyday_sign_conf{
		key = 505,
		year = 2017,
		month = 6,
		count = 19,
		reward = [],
		is_double = 0,
		vip_double = 0
	};

get({2017,6,20}) ->
	#everyday_sign_conf{
		key = 506,
		year = 2017,
		month = 6,
		count = 20,
		reward = [],
		is_double = 0,
		vip_double = 0
	};

get({2017,6,21}) ->
	#everyday_sign_conf{
		key = 507,
		year = 2017,
		month = 6,
		count = 21,
		reward = [],
		is_double = 0,
		vip_double = 0
	};

get({2017,6,22}) ->
	#everyday_sign_conf{
		key = 508,
		year = 2017,
		month = 6,
		count = 22,
		reward = [],
		is_double = 0,
		vip_double = 0
	};

get({2017,6,23}) ->
	#everyday_sign_conf{
		key = 509,
		year = 2017,
		month = 6,
		count = 23,
		reward = [],
		is_double = 0,
		vip_double = 0
	};

get({2017,6,24}) ->
	#everyday_sign_conf{
		key = 510,
		year = 2017,
		month = 6,
		count = 24,
		reward = [],
		is_double = 0,
		vip_double = 0
	};

get({2017,6,25}) ->
	#everyday_sign_conf{
		key = 511,
		year = 2017,
		month = 6,
		count = 25,
		reward = [],
		is_double = 0,
		vip_double = 0
	};

get({2017,6,26}) ->
	#everyday_sign_conf{
		key = 512,
		year = 2017,
		month = 6,
		count = 26,
		reward = [{110009,1,500000},{110045,1,300},{110149,1,1},{110140,1,10}],
		is_double = 0,
		vip_double = 0
	};

get({2017,6,27}) ->
	#everyday_sign_conf{
		key = 513,
		year = 2017,
		month = 6,
		count = 27,
		reward = [],
		is_double = 0,
		vip_double = 0
	};

get({2017,6,28}) ->
	#everyday_sign_conf{
		key = 514,
		year = 2017,
		month = 6,
		count = 28,
		reward = [],
		is_double = 0,
		vip_double = 0
	};

get({2017,6,29}) ->
	#everyday_sign_conf{
		key = 515,
		year = 2017,
		month = 6,
		count = 29,
		reward = [],
		is_double = 0,
		vip_double = 0
	};

get({2017,6,30}) ->
	#everyday_sign_conf{
		key = 516,
		year = 2017,
		month = 6,
		count = 30,
		reward = [],
		is_double = 0,
		vip_double = 0
	};

get({2017,7,1}) ->
	#everyday_sign_conf{
		key = 517,
		year = 2017,
		month = 7,
		count = 1,
		reward = [],
		is_double = 0,
		vip_double = 0
	};

get({2017,7,2}) ->
	#everyday_sign_conf{
		key = 518,
		year = 2017,
		month = 7,
		count = 2,
		reward = [{110009,1,500000},{110045,1,100},{110148,1,1},{110127,1,30}],
		is_double = 0,
		vip_double = 0
	};

get({2017,7,3}) ->
	#everyday_sign_conf{
		key = 519,
		year = 2017,
		month = 7,
		count = 3,
		reward = [],
		is_double = 0,
		vip_double = 0
	};

get({2017,7,4}) ->
	#everyday_sign_conf{
		key = 520,
		year = 2017,
		month = 7,
		count = 4,
		reward = [],
		is_double = 0,
		vip_double = 0
	};

get({2017,7,5}) ->
	#everyday_sign_conf{
		key = 521,
		year = 2017,
		month = 7,
		count = 5,
		reward = [{110009,1,500000},{110045,1,150},{110148,1,1},{110127,1,60}],
		is_double = 0,
		vip_double = 0
	};

get({2017,7,6}) ->
	#everyday_sign_conf{
		key = 522,
		year = 2017,
		month = 7,
		count = 6,
		reward = [],
		is_double = 0,
		vip_double = 0
	};

get({2017,7,7}) ->
	#everyday_sign_conf{
		key = 523,
		year = 2017,
		month = 7,
		count = 7,
		reward = [],
		is_double = 0,
		vip_double = 0
	};

get({2017,7,8}) ->
	#everyday_sign_conf{
		key = 524,
		year = 2017,
		month = 7,
		count = 8,
		reward = [],
		is_double = 0,
		vip_double = 0
	};

get({2017,7,9}) ->
	#everyday_sign_conf{
		key = 525,
		year = 2017,
		month = 7,
		count = 9,
		reward = [],
		is_double = 0,
		vip_double = 0
	};

get({2017,7,10}) ->
	#everyday_sign_conf{
		key = 526,
		year = 2017,
		month = 7,
		count = 10,
		reward = [{110009,1,500000},{110045,1,200},{110148,1,1},{110127,1,90}],
		is_double = 0,
		vip_double = 0
	};

get({2017,7,11}) ->
	#everyday_sign_conf{
		key = 527,
		year = 2017,
		month = 7,
		count = 11,
		reward = [],
		is_double = 0,
		vip_double = 0
	};

get({2017,7,12}) ->
	#everyday_sign_conf{
		key = 528,
		year = 2017,
		month = 7,
		count = 12,
		reward = [],
		is_double = 0,
		vip_double = 0
	};

get({2017,7,13}) ->
	#everyday_sign_conf{
		key = 529,
		year = 2017,
		month = 7,
		count = 13,
		reward = [],
		is_double = 0,
		vip_double = 0
	};

get({2017,7,14}) ->
	#everyday_sign_conf{
		key = 530,
		year = 2017,
		month = 7,
		count = 14,
		reward = [],
		is_double = 0,
		vip_double = 0
	};

get({2017,7,15}) ->
	#everyday_sign_conf{
		key = 531,
		year = 2017,
		month = 7,
		count = 15,
		reward = [],
		is_double = 0,
		vip_double = 0
	};

get({2017,7,16}) ->
	#everyday_sign_conf{
		key = 532,
		year = 2017,
		month = 7,
		count = 16,
		reward = [],
		is_double = 0,
		vip_double = 0
	};

get({2017,7,17}) ->
	#everyday_sign_conf{
		key = 533,
		year = 2017,
		month = 7,
		count = 17,
		reward = [{110009,1,500000},{110045,1,250},{110148,1,2},{110127,1,120}],
		is_double = 0,
		vip_double = 0
	};

get({2017,7,18}) ->
	#everyday_sign_conf{
		key = 534,
		year = 2017,
		month = 7,
		count = 18,
		reward = [],
		is_double = 0,
		vip_double = 0
	};

get({2017,7,19}) ->
	#everyday_sign_conf{
		key = 535,
		year = 2017,
		month = 7,
		count = 19,
		reward = [],
		is_double = 0,
		vip_double = 0
	};

get({2017,7,20}) ->
	#everyday_sign_conf{
		key = 536,
		year = 2017,
		month = 7,
		count = 20,
		reward = [],
		is_double = 0,
		vip_double = 0
	};

get({2017,7,21}) ->
	#everyday_sign_conf{
		key = 537,
		year = 2017,
		month = 7,
		count = 21,
		reward = [],
		is_double = 0,
		vip_double = 0
	};

get({2017,7,22}) ->
	#everyday_sign_conf{
		key = 538,
		year = 2017,
		month = 7,
		count = 22,
		reward = [],
		is_double = 0,
		vip_double = 0
	};

get({2017,7,23}) ->
	#everyday_sign_conf{
		key = 539,
		year = 2017,
		month = 7,
		count = 23,
		reward = [],
		is_double = 0,
		vip_double = 0
	};

get({2017,7,24}) ->
	#everyday_sign_conf{
		key = 540,
		year = 2017,
		month = 7,
		count = 24,
		reward = [],
		is_double = 0,
		vip_double = 0
	};

get({2017,7,25}) ->
	#everyday_sign_conf{
		key = 541,
		year = 2017,
		month = 7,
		count = 25,
		reward = [],
		is_double = 0,
		vip_double = 0
	};

get({2017,7,26}) ->
	#everyday_sign_conf{
		key = 542,
		year = 2017,
		month = 7,
		count = 26,
		reward = [{110009,1,500000},{110045,1,300},{110149,1,1},{110140,1,10}],
		is_double = 0,
		vip_double = 0
	};

get({2017,7,27}) ->
	#everyday_sign_conf{
		key = 543,
		year = 2017,
		month = 7,
		count = 27,
		reward = [],
		is_double = 0,
		vip_double = 0
	};

get({2017,7,28}) ->
	#everyday_sign_conf{
		key = 544,
		year = 2017,
		month = 7,
		count = 28,
		reward = [],
		is_double = 0,
		vip_double = 0
	};

get({2017,7,29}) ->
	#everyday_sign_conf{
		key = 545,
		year = 2017,
		month = 7,
		count = 29,
		reward = [],
		is_double = 0,
		vip_double = 0
	};

get({2017,7,30}) ->
	#everyday_sign_conf{
		key = 546,
		year = 2017,
		month = 7,
		count = 30,
		reward = [],
		is_double = 0,
		vip_double = 0
	};

get({2017,7,31}) ->
	#everyday_sign_conf{
		key = 547,
		year = 2017,
		month = 7,
		count = 31,
		reward = [],
		is_double = 0,
		vip_double = 0
	};

get({2017,8,1}) ->
	#everyday_sign_conf{
		key = 548,
		year = 2017,
		month = 8,
		count = 1,
		reward = [],
		is_double = 0,
		vip_double = 0
	};

get({2017,8,2}) ->
	#everyday_sign_conf{
		key = 549,
		year = 2017,
		month = 8,
		count = 2,
		reward = [{110009,1,500000},{110045,1,100},{110148,1,1},{110127,1,30}],
		is_double = 0,
		vip_double = 0
	};

get({2017,8,3}) ->
	#everyday_sign_conf{
		key = 550,
		year = 2017,
		month = 8,
		count = 3,
		reward = [],
		is_double = 0,
		vip_double = 0
	};

get({2017,8,4}) ->
	#everyday_sign_conf{
		key = 551,
		year = 2017,
		month = 8,
		count = 4,
		reward = [],
		is_double = 0,
		vip_double = 0
	};

get({2017,8,5}) ->
	#everyday_sign_conf{
		key = 552,
		year = 2017,
		month = 8,
		count = 5,
		reward = [{110009,1,500000},{110045,1,150},{110148,1,1},{110127,1,60}],
		is_double = 0,
		vip_double = 0
	};

get({2017,8,6}) ->
	#everyday_sign_conf{
		key = 553,
		year = 2017,
		month = 8,
		count = 6,
		reward = [],
		is_double = 0,
		vip_double = 0
	};

get({2017,8,7}) ->
	#everyday_sign_conf{
		key = 554,
		year = 2017,
		month = 8,
		count = 7,
		reward = [],
		is_double = 0,
		vip_double = 0
	};

get({2017,8,8}) ->
	#everyday_sign_conf{
		key = 555,
		year = 2017,
		month = 8,
		count = 8,
		reward = [],
		is_double = 0,
		vip_double = 0
	};

get({2017,8,9}) ->
	#everyday_sign_conf{
		key = 556,
		year = 2017,
		month = 8,
		count = 9,
		reward = [],
		is_double = 0,
		vip_double = 0
	};

get({2017,8,10}) ->
	#everyday_sign_conf{
		key = 557,
		year = 2017,
		month = 8,
		count = 10,
		reward = [{110009,1,500000},{110045,1,200},{110148,1,1},{110127,1,90}],
		is_double = 0,
		vip_double = 0
	};

get({2017,8,11}) ->
	#everyday_sign_conf{
		key = 558,
		year = 2017,
		month = 8,
		count = 11,
		reward = [],
		is_double = 0,
		vip_double = 0
	};

get({2017,8,12}) ->
	#everyday_sign_conf{
		key = 559,
		year = 2017,
		month = 8,
		count = 12,
		reward = [],
		is_double = 0,
		vip_double = 0
	};

get({2017,8,13}) ->
	#everyday_sign_conf{
		key = 560,
		year = 2017,
		month = 8,
		count = 13,
		reward = [],
		is_double = 0,
		vip_double = 0
	};

get({2017,8,14}) ->
	#everyday_sign_conf{
		key = 561,
		year = 2017,
		month = 8,
		count = 14,
		reward = [],
		is_double = 0,
		vip_double = 0
	};

get({2017,8,15}) ->
	#everyday_sign_conf{
		key = 562,
		year = 2017,
		month = 8,
		count = 15,
		reward = [],
		is_double = 0,
		vip_double = 0
	};

get({2017,8,16}) ->
	#everyday_sign_conf{
		key = 563,
		year = 2017,
		month = 8,
		count = 16,
		reward = [],
		is_double = 0,
		vip_double = 0
	};

get({2017,8,17}) ->
	#everyday_sign_conf{
		key = 564,
		year = 2017,
		month = 8,
		count = 17,
		reward = [{110009,1,500000},{110045,1,250},{110148,1,2},{110127,1,120}],
		is_double = 0,
		vip_double = 0
	};

get({2017,8,18}) ->
	#everyday_sign_conf{
		key = 565,
		year = 2017,
		month = 8,
		count = 18,
		reward = [],
		is_double = 0,
		vip_double = 0
	};

get({2017,8,19}) ->
	#everyday_sign_conf{
		key = 566,
		year = 2017,
		month = 8,
		count = 19,
		reward = [],
		is_double = 0,
		vip_double = 0
	};

get({2017,8,20}) ->
	#everyday_sign_conf{
		key = 567,
		year = 2017,
		month = 8,
		count = 20,
		reward = [],
		is_double = 0,
		vip_double = 0
	};

get({2017,8,21}) ->
	#everyday_sign_conf{
		key = 568,
		year = 2017,
		month = 8,
		count = 21,
		reward = [],
		is_double = 0,
		vip_double = 0
	};

get({2017,8,22}) ->
	#everyday_sign_conf{
		key = 569,
		year = 2017,
		month = 8,
		count = 22,
		reward = [],
		is_double = 0,
		vip_double = 0
	};

get({2017,8,23}) ->
	#everyday_sign_conf{
		key = 570,
		year = 2017,
		month = 8,
		count = 23,
		reward = [],
		is_double = 0,
		vip_double = 0
	};

get({2017,8,24}) ->
	#everyday_sign_conf{
		key = 571,
		year = 2017,
		month = 8,
		count = 24,
		reward = [],
		is_double = 0,
		vip_double = 0
	};

get({2017,8,25}) ->
	#everyday_sign_conf{
		key = 572,
		year = 2017,
		month = 8,
		count = 25,
		reward = [],
		is_double = 0,
		vip_double = 0
	};

get({2017,8,26}) ->
	#everyday_sign_conf{
		key = 573,
		year = 2017,
		month = 8,
		count = 26,
		reward = [{110009,1,500000},{110045,1,300},{110149,1,1},{110140,1,10}],
		is_double = 0,
		vip_double = 0
	};

get({2017,8,27}) ->
	#everyday_sign_conf{
		key = 574,
		year = 2017,
		month = 8,
		count = 27,
		reward = [],
		is_double = 0,
		vip_double = 0
	};

get({2017,8,28}) ->
	#everyday_sign_conf{
		key = 575,
		year = 2017,
		month = 8,
		count = 28,
		reward = [],
		is_double = 0,
		vip_double = 0
	};

get({2017,8,29}) ->
	#everyday_sign_conf{
		key = 576,
		year = 2017,
		month = 8,
		count = 29,
		reward = [],
		is_double = 0,
		vip_double = 0
	};

get({2017,8,30}) ->
	#everyday_sign_conf{
		key = 577,
		year = 2017,
		month = 8,
		count = 30,
		reward = [],
		is_double = 0,
		vip_double = 0
	};

get({2017,8,31}) ->
	#everyday_sign_conf{
		key = 578,
		year = 2017,
		month = 8,
		count = 31,
		reward = [],
		is_double = 0,
		vip_double = 0
	};

get({2017,9,1}) ->
	#everyday_sign_conf{
		key = 579,
		year = 2017,
		month = 9,
		count = 1,
		reward = [],
		is_double = 0,
		vip_double = 0
	};

get({2017,9,2}) ->
	#everyday_sign_conf{
		key = 580,
		year = 2017,
		month = 9,
		count = 2,
		reward = [{110009,1,500000},{110045,1,100},{110148,1,1},{110127,1,30}],
		is_double = 0,
		vip_double = 0
	};

get({2017,9,3}) ->
	#everyday_sign_conf{
		key = 581,
		year = 2017,
		month = 9,
		count = 3,
		reward = [],
		is_double = 0,
		vip_double = 0
	};

get({2017,9,4}) ->
	#everyday_sign_conf{
		key = 582,
		year = 2017,
		month = 9,
		count = 4,
		reward = [],
		is_double = 0,
		vip_double = 0
	};

get({2017,9,5}) ->
	#everyday_sign_conf{
		key = 583,
		year = 2017,
		month = 9,
		count = 5,
		reward = [{110009,1,500000},{110045,1,150},{110148,1,1},{110127,1,60}],
		is_double = 0,
		vip_double = 0
	};

get({2017,9,6}) ->
	#everyday_sign_conf{
		key = 584,
		year = 2017,
		month = 9,
		count = 6,
		reward = [],
		is_double = 0,
		vip_double = 0
	};

get({2017,9,7}) ->
	#everyday_sign_conf{
		key = 585,
		year = 2017,
		month = 9,
		count = 7,
		reward = [],
		is_double = 0,
		vip_double = 0
	};

get({2017,9,8}) ->
	#everyday_sign_conf{
		key = 586,
		year = 2017,
		month = 9,
		count = 8,
		reward = [],
		is_double = 0,
		vip_double = 0
	};

get({2017,9,9}) ->
	#everyday_sign_conf{
		key = 587,
		year = 2017,
		month = 9,
		count = 9,
		reward = [],
		is_double = 0,
		vip_double = 0
	};

get({2017,9,10}) ->
	#everyday_sign_conf{
		key = 588,
		year = 2017,
		month = 9,
		count = 10,
		reward = [{110009,1,500000},{110045,1,200},{110148,1,1},{110127,1,90}],
		is_double = 0,
		vip_double = 0
	};

get({2017,9,11}) ->
	#everyday_sign_conf{
		key = 589,
		year = 2017,
		month = 9,
		count = 11,
		reward = [],
		is_double = 0,
		vip_double = 0
	};

get({2017,9,12}) ->
	#everyday_sign_conf{
		key = 590,
		year = 2017,
		month = 9,
		count = 12,
		reward = [],
		is_double = 0,
		vip_double = 0
	};

get({2017,9,13}) ->
	#everyday_sign_conf{
		key = 591,
		year = 2017,
		month = 9,
		count = 13,
		reward = [],
		is_double = 0,
		vip_double = 0
	};

get({2017,9,14}) ->
	#everyday_sign_conf{
		key = 592,
		year = 2017,
		month = 9,
		count = 14,
		reward = [],
		is_double = 0,
		vip_double = 0
	};

get({2017,9,15}) ->
	#everyday_sign_conf{
		key = 593,
		year = 2017,
		month = 9,
		count = 15,
		reward = [],
		is_double = 0,
		vip_double = 0
	};

get({2017,9,16}) ->
	#everyday_sign_conf{
		key = 594,
		year = 2017,
		month = 9,
		count = 16,
		reward = [],
		is_double = 0,
		vip_double = 0
	};

get({2017,9,17}) ->
	#everyday_sign_conf{
		key = 595,
		year = 2017,
		month = 9,
		count = 17,
		reward = [{110009,1,500000},{110045,1,250},{110148,1,2},{110127,1,120}],
		is_double = 0,
		vip_double = 0
	};

get({2017,9,18}) ->
	#everyday_sign_conf{
		key = 596,
		year = 2017,
		month = 9,
		count = 18,
		reward = [],
		is_double = 0,
		vip_double = 0
	};

get({2017,9,19}) ->
	#everyday_sign_conf{
		key = 597,
		year = 2017,
		month = 9,
		count = 19,
		reward = [],
		is_double = 0,
		vip_double = 0
	};

get({2017,9,20}) ->
	#everyday_sign_conf{
		key = 598,
		year = 2017,
		month = 9,
		count = 20,
		reward = [],
		is_double = 0,
		vip_double = 0
	};

get({2017,9,21}) ->
	#everyday_sign_conf{
		key = 599,
		year = 2017,
		month = 9,
		count = 21,
		reward = [],
		is_double = 0,
		vip_double = 0
	};

get({2017,9,22}) ->
	#everyday_sign_conf{
		key = 600,
		year = 2017,
		month = 9,
		count = 22,
		reward = [],
		is_double = 0,
		vip_double = 0
	};

get({2017,9,23}) ->
	#everyday_sign_conf{
		key = 601,
		year = 2017,
		month = 9,
		count = 23,
		reward = [],
		is_double = 0,
		vip_double = 0
	};

get({2017,9,24}) ->
	#everyday_sign_conf{
		key = 602,
		year = 2017,
		month = 9,
		count = 24,
		reward = [],
		is_double = 0,
		vip_double = 0
	};

get({2017,9,25}) ->
	#everyday_sign_conf{
		key = 603,
		year = 2017,
		month = 9,
		count = 25,
		reward = [],
		is_double = 0,
		vip_double = 0
	};

get({2017,9,26}) ->
	#everyday_sign_conf{
		key = 604,
		year = 2017,
		month = 9,
		count = 26,
		reward = [{110009,1,500000},{110045,1,300},{110149,1,1},{110140,1,10}],
		is_double = 0,
		vip_double = 0
	};

get({2017,9,27}) ->
	#everyday_sign_conf{
		key = 605,
		year = 2017,
		month = 9,
		count = 27,
		reward = [],
		is_double = 0,
		vip_double = 0
	};

get({2017,9,28}) ->
	#everyday_sign_conf{
		key = 606,
		year = 2017,
		month = 9,
		count = 28,
		reward = [],
		is_double = 0,
		vip_double = 0
	};

get({2017,9,29}) ->
	#everyday_sign_conf{
		key = 607,
		year = 2017,
		month = 9,
		count = 29,
		reward = [],
		is_double = 0,
		vip_double = 0
	};

get({2017,9,30}) ->
	#everyday_sign_conf{
		key = 608,
		year = 2017,
		month = 9,
		count = 30,
		reward = [],
		is_double = 0,
		vip_double = 0
	};

get({2017,10,1}) ->
	#everyday_sign_conf{
		key = 609,
		year = 2017,
		month = 10,
		count = 1,
		reward = [],
		is_double = 0,
		vip_double = 0
	};

get({2017,10,2}) ->
	#everyday_sign_conf{
		key = 610,
		year = 2017,
		month = 10,
		count = 2,
		reward = [{110009,1,500000},{110045,1,100},{110148,1,1},{110127,1,30}],
		is_double = 0,
		vip_double = 0
	};

get({2017,10,3}) ->
	#everyday_sign_conf{
		key = 611,
		year = 2017,
		month = 10,
		count = 3,
		reward = [],
		is_double = 0,
		vip_double = 0
	};

get({2017,10,4}) ->
	#everyday_sign_conf{
		key = 612,
		year = 2017,
		month = 10,
		count = 4,
		reward = [],
		is_double = 0,
		vip_double = 0
	};

get({2017,10,5}) ->
	#everyday_sign_conf{
		key = 613,
		year = 2017,
		month = 10,
		count = 5,
		reward = [{110009,1,500000},{110045,1,150},{110148,1,1},{110127,1,60}],
		is_double = 0,
		vip_double = 0
	};

get({2017,10,6}) ->
	#everyday_sign_conf{
		key = 614,
		year = 2017,
		month = 10,
		count = 6,
		reward = [],
		is_double = 0,
		vip_double = 0
	};

get({2017,10,7}) ->
	#everyday_sign_conf{
		key = 615,
		year = 2017,
		month = 10,
		count = 7,
		reward = [],
		is_double = 0,
		vip_double = 0
	};

get({2017,10,8}) ->
	#everyday_sign_conf{
		key = 616,
		year = 2017,
		month = 10,
		count = 8,
		reward = [],
		is_double = 0,
		vip_double = 0
	};

get({2017,10,9}) ->
	#everyday_sign_conf{
		key = 617,
		year = 2017,
		month = 10,
		count = 9,
		reward = [],
		is_double = 0,
		vip_double = 0
	};

get({2017,10,10}) ->
	#everyday_sign_conf{
		key = 618,
		year = 2017,
		month = 10,
		count = 10,
		reward = [{110009,1,500000},{110045,1,200},{110148,1,1},{110127,1,90}],
		is_double = 0,
		vip_double = 0
	};

get({2017,10,11}) ->
	#everyday_sign_conf{
		key = 619,
		year = 2017,
		month = 10,
		count = 11,
		reward = [],
		is_double = 0,
		vip_double = 0
	};

get({2017,10,12}) ->
	#everyday_sign_conf{
		key = 620,
		year = 2017,
		month = 10,
		count = 12,
		reward = [],
		is_double = 0,
		vip_double = 0
	};

get({2017,10,13}) ->
	#everyday_sign_conf{
		key = 621,
		year = 2017,
		month = 10,
		count = 13,
		reward = [],
		is_double = 0,
		vip_double = 0
	};

get({2017,10,14}) ->
	#everyday_sign_conf{
		key = 622,
		year = 2017,
		month = 10,
		count = 14,
		reward = [],
		is_double = 0,
		vip_double = 0
	};

get({2017,10,15}) ->
	#everyday_sign_conf{
		key = 623,
		year = 2017,
		month = 10,
		count = 15,
		reward = [],
		is_double = 0,
		vip_double = 0
	};

get({2017,10,16}) ->
	#everyday_sign_conf{
		key = 624,
		year = 2017,
		month = 10,
		count = 16,
		reward = [],
		is_double = 0,
		vip_double = 0
	};

get({2017,10,17}) ->
	#everyday_sign_conf{
		key = 625,
		year = 2017,
		month = 10,
		count = 17,
		reward = [{110009,1,500000},{110045,1,250},{110148,1,2},{110127,1,120}],
		is_double = 0,
		vip_double = 0
	};

get({2017,10,18}) ->
	#everyday_sign_conf{
		key = 626,
		year = 2017,
		month = 10,
		count = 18,
		reward = [],
		is_double = 0,
		vip_double = 0
	};

get({2017,10,19}) ->
	#everyday_sign_conf{
		key = 627,
		year = 2017,
		month = 10,
		count = 19,
		reward = [],
		is_double = 0,
		vip_double = 0
	};

get({2017,10,20}) ->
	#everyday_sign_conf{
		key = 628,
		year = 2017,
		month = 10,
		count = 20,
		reward = [],
		is_double = 0,
		vip_double = 0
	};

get({2017,10,21}) ->
	#everyday_sign_conf{
		key = 629,
		year = 2017,
		month = 10,
		count = 21,
		reward = [],
		is_double = 0,
		vip_double = 0
	};

get({2017,10,22}) ->
	#everyday_sign_conf{
		key = 630,
		year = 2017,
		month = 10,
		count = 22,
		reward = [],
		is_double = 0,
		vip_double = 0
	};

get({2017,10,23}) ->
	#everyday_sign_conf{
		key = 631,
		year = 2017,
		month = 10,
		count = 23,
		reward = [],
		is_double = 0,
		vip_double = 0
	};

get({2017,10,24}) ->
	#everyday_sign_conf{
		key = 632,
		year = 2017,
		month = 10,
		count = 24,
		reward = [],
		is_double = 0,
		vip_double = 0
	};

get({2017,10,25}) ->
	#everyday_sign_conf{
		key = 633,
		year = 2017,
		month = 10,
		count = 25,
		reward = [],
		is_double = 0,
		vip_double = 0
	};

get({2017,10,26}) ->
	#everyday_sign_conf{
		key = 634,
		year = 2017,
		month = 10,
		count = 26,
		reward = [{110009,1,500000},{110045,1,300},{110149,1,1},{110140,1,10}],
		is_double = 0,
		vip_double = 0
	};

get({2017,10,27}) ->
	#everyday_sign_conf{
		key = 635,
		year = 2017,
		month = 10,
		count = 27,
		reward = [],
		is_double = 0,
		vip_double = 0
	};

get({2017,10,28}) ->
	#everyday_sign_conf{
		key = 636,
		year = 2017,
		month = 10,
		count = 28,
		reward = [],
		is_double = 0,
		vip_double = 0
	};

get({2017,10,29}) ->
	#everyday_sign_conf{
		key = 637,
		year = 2017,
		month = 10,
		count = 29,
		reward = [],
		is_double = 0,
		vip_double = 0
	};

get({2017,10,30}) ->
	#everyday_sign_conf{
		key = 638,
		year = 2017,
		month = 10,
		count = 30,
		reward = [],
		is_double = 0,
		vip_double = 0
	};

get({2017,10,31}) ->
	#everyday_sign_conf{
		key = 639,
		year = 2017,
		month = 10,
		count = 31,
		reward = [],
		is_double = 0,
		vip_double = 0
	};

get({2017,11,1}) ->
	#everyday_sign_conf{
		key = 640,
		year = 2017,
		month = 11,
		count = 1,
		reward = [],
		is_double = 0,
		vip_double = 0
	};

get({2017,11,2}) ->
	#everyday_sign_conf{
		key = 641,
		year = 2017,
		month = 11,
		count = 2,
		reward = [{110009,1,500000},{110045,1,100},{110148,1,1},{110127,1,30}],
		is_double = 0,
		vip_double = 0
	};

get({2017,11,3}) ->
	#everyday_sign_conf{
		key = 642,
		year = 2017,
		month = 11,
		count = 3,
		reward = [],
		is_double = 0,
		vip_double = 0
	};

get({2017,11,4}) ->
	#everyday_sign_conf{
		key = 643,
		year = 2017,
		month = 11,
		count = 4,
		reward = [],
		is_double = 0,
		vip_double = 0
	};

get({2017,11,5}) ->
	#everyday_sign_conf{
		key = 644,
		year = 2017,
		month = 11,
		count = 5,
		reward = [{110009,1,500000},{110045,1,150},{110148,1,1},{110127,1,60}],
		is_double = 0,
		vip_double = 0
	};

get({2017,11,6}) ->
	#everyday_sign_conf{
		key = 645,
		year = 2017,
		month = 11,
		count = 6,
		reward = [],
		is_double = 0,
		vip_double = 0
	};

get({2017,11,7}) ->
	#everyday_sign_conf{
		key = 646,
		year = 2017,
		month = 11,
		count = 7,
		reward = [],
		is_double = 0,
		vip_double = 0
	};

get({2017,11,8}) ->
	#everyday_sign_conf{
		key = 647,
		year = 2017,
		month = 11,
		count = 8,
		reward = [],
		is_double = 0,
		vip_double = 0
	};

get({2017,11,9}) ->
	#everyday_sign_conf{
		key = 648,
		year = 2017,
		month = 11,
		count = 9,
		reward = [],
		is_double = 0,
		vip_double = 0
	};

get({2017,11,10}) ->
	#everyday_sign_conf{
		key = 649,
		year = 2017,
		month = 11,
		count = 10,
		reward = [{110009,1,500000},{110045,1,200},{110148,1,1},{110127,1,90}],
		is_double = 0,
		vip_double = 0
	};

get({2017,11,11}) ->
	#everyday_sign_conf{
		key = 650,
		year = 2017,
		month = 11,
		count = 11,
		reward = [],
		is_double = 0,
		vip_double = 0
	};

get({2017,11,12}) ->
	#everyday_sign_conf{
		key = 651,
		year = 2017,
		month = 11,
		count = 12,
		reward = [],
		is_double = 0,
		vip_double = 0
	};

get({2017,11,13}) ->
	#everyday_sign_conf{
		key = 652,
		year = 2017,
		month = 11,
		count = 13,
		reward = [],
		is_double = 0,
		vip_double = 0
	};

get({2017,11,14}) ->
	#everyday_sign_conf{
		key = 653,
		year = 2017,
		month = 11,
		count = 14,
		reward = [],
		is_double = 0,
		vip_double = 0
	};

get({2017,11,15}) ->
	#everyday_sign_conf{
		key = 654,
		year = 2017,
		month = 11,
		count = 15,
		reward = [],
		is_double = 0,
		vip_double = 0
	};

get({2017,11,16}) ->
	#everyday_sign_conf{
		key = 655,
		year = 2017,
		month = 11,
		count = 16,
		reward = [],
		is_double = 0,
		vip_double = 0
	};

get({2017,11,17}) ->
	#everyday_sign_conf{
		key = 656,
		year = 2017,
		month = 11,
		count = 17,
		reward = [{110009,1,500000},{110045,1,250},{110148,1,2},{110127,1,120}],
		is_double = 0,
		vip_double = 0
	};

get({2017,11,18}) ->
	#everyday_sign_conf{
		key = 657,
		year = 2017,
		month = 11,
		count = 18,
		reward = [],
		is_double = 0,
		vip_double = 0
	};

get({2017,11,19}) ->
	#everyday_sign_conf{
		key = 658,
		year = 2017,
		month = 11,
		count = 19,
		reward = [],
		is_double = 0,
		vip_double = 0
	};

get({2017,11,20}) ->
	#everyday_sign_conf{
		key = 659,
		year = 2017,
		month = 11,
		count = 20,
		reward = [],
		is_double = 0,
		vip_double = 0
	};

get({2017,11,21}) ->
	#everyday_sign_conf{
		key = 660,
		year = 2017,
		month = 11,
		count = 21,
		reward = [],
		is_double = 0,
		vip_double = 0
	};

get({2017,11,22}) ->
	#everyday_sign_conf{
		key = 661,
		year = 2017,
		month = 11,
		count = 22,
		reward = [],
		is_double = 0,
		vip_double = 0
	};

get({2017,11,23}) ->
	#everyday_sign_conf{
		key = 662,
		year = 2017,
		month = 11,
		count = 23,
		reward = [],
		is_double = 0,
		vip_double = 0
	};

get({2017,11,24}) ->
	#everyday_sign_conf{
		key = 663,
		year = 2017,
		month = 11,
		count = 24,
		reward = [],
		is_double = 0,
		vip_double = 0
	};

get({2017,11,25}) ->
	#everyday_sign_conf{
		key = 664,
		year = 2017,
		month = 11,
		count = 25,
		reward = [],
		is_double = 0,
		vip_double = 0
	};

get({2017,11,26}) ->
	#everyday_sign_conf{
		key = 665,
		year = 2017,
		month = 11,
		count = 26,
		reward = [{110009,1,500000},{110045,1,300},{110149,1,1},{110140,1,10}],
		is_double = 0,
		vip_double = 0
	};

get({2017,11,27}) ->
	#everyday_sign_conf{
		key = 666,
		year = 2017,
		month = 11,
		count = 27,
		reward = [],
		is_double = 0,
		vip_double = 0
	};

get({2017,11,28}) ->
	#everyday_sign_conf{
		key = 667,
		year = 2017,
		month = 11,
		count = 28,
		reward = [],
		is_double = 0,
		vip_double = 0
	};

get({2017,11,29}) ->
	#everyday_sign_conf{
		key = 668,
		year = 2017,
		month = 11,
		count = 29,
		reward = [],
		is_double = 0,
		vip_double = 0
	};

get({2017,11,30}) ->
	#everyday_sign_conf{
		key = 669,
		year = 2017,
		month = 11,
		count = 30,
		reward = [],
		is_double = 0,
		vip_double = 0
	};

get({2017,12,1}) ->
	#everyday_sign_conf{
		key = 670,
		year = 2017,
		month = 12,
		count = 1,
		reward = [],
		is_double = 0,
		vip_double = 0
	};

get({2017,12,2}) ->
	#everyday_sign_conf{
		key = 671,
		year = 2017,
		month = 12,
		count = 2,
		reward = [{110009,1,500000},{110045,1,100},{110148,1,1},{110127,1,30}],
		is_double = 0,
		vip_double = 0
	};

get({2017,12,3}) ->
	#everyday_sign_conf{
		key = 672,
		year = 2017,
		month = 12,
		count = 3,
		reward = [],
		is_double = 0,
		vip_double = 0
	};

get({2017,12,4}) ->
	#everyday_sign_conf{
		key = 673,
		year = 2017,
		month = 12,
		count = 4,
		reward = [],
		is_double = 0,
		vip_double = 0
	};

get({2017,12,5}) ->
	#everyday_sign_conf{
		key = 674,
		year = 2017,
		month = 12,
		count = 5,
		reward = [{110009,1,500000},{110045,1,150},{110148,1,1},{110127,1,60}],
		is_double = 0,
		vip_double = 0
	};

get({2017,12,6}) ->
	#everyday_sign_conf{
		key = 675,
		year = 2017,
		month = 12,
		count = 6,
		reward = [],
		is_double = 0,
		vip_double = 0
	};

get({2017,12,7}) ->
	#everyday_sign_conf{
		key = 676,
		year = 2017,
		month = 12,
		count = 7,
		reward = [],
		is_double = 0,
		vip_double = 0
	};

get({2017,12,8}) ->
	#everyday_sign_conf{
		key = 677,
		year = 2017,
		month = 12,
		count = 8,
		reward = [],
		is_double = 0,
		vip_double = 0
	};

get({2017,12,9}) ->
	#everyday_sign_conf{
		key = 678,
		year = 2017,
		month = 12,
		count = 9,
		reward = [],
		is_double = 0,
		vip_double = 0
	};

get({2017,12,10}) ->
	#everyday_sign_conf{
		key = 679,
		year = 2017,
		month = 12,
		count = 10,
		reward = [{110009,1,500000},{110045,1,200},{110148,1,1},{110127,1,90}],
		is_double = 0,
		vip_double = 0
	};

get({2017,12,11}) ->
	#everyday_sign_conf{
		key = 680,
		year = 2017,
		month = 12,
		count = 11,
		reward = [],
		is_double = 0,
		vip_double = 0
	};

get({2017,12,12}) ->
	#everyday_sign_conf{
		key = 681,
		year = 2017,
		month = 12,
		count = 12,
		reward = [],
		is_double = 0,
		vip_double = 0
	};

get({2017,12,13}) ->
	#everyday_sign_conf{
		key = 682,
		year = 2017,
		month = 12,
		count = 13,
		reward = [],
		is_double = 0,
		vip_double = 0
	};

get({2017,12,14}) ->
	#everyday_sign_conf{
		key = 683,
		year = 2017,
		month = 12,
		count = 14,
		reward = [],
		is_double = 0,
		vip_double = 0
	};

get({2017,12,15}) ->
	#everyday_sign_conf{
		key = 684,
		year = 2017,
		month = 12,
		count = 15,
		reward = [],
		is_double = 0,
		vip_double = 0
	};

get({2017,12,16}) ->
	#everyday_sign_conf{
		key = 685,
		year = 2017,
		month = 12,
		count = 16,
		reward = [],
		is_double = 0,
		vip_double = 0
	};

get({2017,12,17}) ->
	#everyday_sign_conf{
		key = 686,
		year = 2017,
		month = 12,
		count = 17,
		reward = [{110009,1,500000},{110045,1,250},{110148,1,2},{110127,1,120}],
		is_double = 0,
		vip_double = 0
	};

get({2017,12,18}) ->
	#everyday_sign_conf{
		key = 687,
		year = 2017,
		month = 12,
		count = 18,
		reward = [],
		is_double = 0,
		vip_double = 0
	};

get({2017,12,19}) ->
	#everyday_sign_conf{
		key = 688,
		year = 2017,
		month = 12,
		count = 19,
		reward = [],
		is_double = 0,
		vip_double = 0
	};

get({2017,12,20}) ->
	#everyday_sign_conf{
		key = 689,
		year = 2017,
		month = 12,
		count = 20,
		reward = [],
		is_double = 0,
		vip_double = 0
	};

get({2017,12,21}) ->
	#everyday_sign_conf{
		key = 690,
		year = 2017,
		month = 12,
		count = 21,
		reward = [],
		is_double = 0,
		vip_double = 0
	};

get({2017,12,22}) ->
	#everyday_sign_conf{
		key = 691,
		year = 2017,
		month = 12,
		count = 22,
		reward = [],
		is_double = 0,
		vip_double = 0
	};

get({2017,12,23}) ->
	#everyday_sign_conf{
		key = 692,
		year = 2017,
		month = 12,
		count = 23,
		reward = [],
		is_double = 0,
		vip_double = 0
	};

get({2017,12,24}) ->
	#everyday_sign_conf{
		key = 693,
		year = 2017,
		month = 12,
		count = 24,
		reward = [],
		is_double = 0,
		vip_double = 0
	};

get({2017,12,25}) ->
	#everyday_sign_conf{
		key = 694,
		year = 2017,
		month = 12,
		count = 25,
		reward = [],
		is_double = 0,
		vip_double = 0
	};

get({2017,12,26}) ->
	#everyday_sign_conf{
		key = 695,
		year = 2017,
		month = 12,
		count = 26,
		reward = [{110009,1,500000},{110045,1,300},{110149,1,1},{110140,1,10}],
		is_double = 0,
		vip_double = 0
	};

get({2017,12,27}) ->
	#everyday_sign_conf{
		key = 696,
		year = 2017,
		month = 12,
		count = 27,
		reward = [],
		is_double = 0,
		vip_double = 0
	};

get({2017,12,28}) ->
	#everyday_sign_conf{
		key = 697,
		year = 2017,
		month = 12,
		count = 28,
		reward = [],
		is_double = 0,
		vip_double = 0
	};

get({2017,12,29}) ->
	#everyday_sign_conf{
		key = 698,
		year = 2017,
		month = 12,
		count = 29,
		reward = [],
		is_double = 0,
		vip_double = 0
	};

get({2017,12,30}) ->
	#everyday_sign_conf{
		key = 699,
		year = 2017,
		month = 12,
		count = 30,
		reward = [],
		is_double = 0,
		vip_double = 0
	};

get({2017,12,31}) ->
	#everyday_sign_conf{
		key = 700,
		year = 2017,
		month = 12,
		count = 31,
		reward = [],
		is_double = 0,
		vip_double = 0
	};

get({2018,1,1}) ->
	#everyday_sign_conf{
		key = 701,
		year = 2018,
		month = 1,
		count = 1,
		reward = [],
		is_double = 0,
		vip_double = 0
	};

get({2018,1,2}) ->
	#everyday_sign_conf{
		key = 702,
		year = 2018,
		month = 1,
		count = 2,
		reward = [{110009,1,500000},{110045,1,100},{110148,1,1},{110127,1,30}],
		is_double = 0,
		vip_double = 0
	};

get({2018,1,3}) ->
	#everyday_sign_conf{
		key = 703,
		year = 2018,
		month = 1,
		count = 3,
		reward = [],
		is_double = 0,
		vip_double = 0
	};

get({2018,1,4}) ->
	#everyday_sign_conf{
		key = 704,
		year = 2018,
		month = 1,
		count = 4,
		reward = [],
		is_double = 0,
		vip_double = 0
	};

get({2018,1,5}) ->
	#everyday_sign_conf{
		key = 705,
		year = 2018,
		month = 1,
		count = 5,
		reward = [{110009,1,500000},{110045,1,150},{110148,1,1},{110127,1,60}],
		is_double = 0,
		vip_double = 0
	};

get({2018,1,6}) ->
	#everyday_sign_conf{
		key = 706,
		year = 2018,
		month = 1,
		count = 6,
		reward = [],
		is_double = 0,
		vip_double = 0
	};

get({2018,1,7}) ->
	#everyday_sign_conf{
		key = 707,
		year = 2018,
		month = 1,
		count = 7,
		reward = [],
		is_double = 0,
		vip_double = 0
	};

get({2018,1,8}) ->
	#everyday_sign_conf{
		key = 708,
		year = 2018,
		month = 1,
		count = 8,
		reward = [],
		is_double = 0,
		vip_double = 0
	};

get({2018,1,9}) ->
	#everyday_sign_conf{
		key = 709,
		year = 2018,
		month = 1,
		count = 9,
		reward = [],
		is_double = 0,
		vip_double = 0
	};

get({2018,1,10}) ->
	#everyday_sign_conf{
		key = 710,
		year = 2018,
		month = 1,
		count = 10,
		reward = [{110009,1,500000},{110045,1,200},{110148,1,1},{110127,1,90}],
		is_double = 0,
		vip_double = 0
	};

get({2018,1,11}) ->
	#everyday_sign_conf{
		key = 711,
		year = 2018,
		month = 1,
		count = 11,
		reward = [],
		is_double = 0,
		vip_double = 0
	};

get({2018,1,12}) ->
	#everyday_sign_conf{
		key = 712,
		year = 2018,
		month = 1,
		count = 12,
		reward = [],
		is_double = 0,
		vip_double = 0
	};

get({2018,1,13}) ->
	#everyday_sign_conf{
		key = 713,
		year = 2018,
		month = 1,
		count = 13,
		reward = [],
		is_double = 0,
		vip_double = 0
	};

get({2018,1,14}) ->
	#everyday_sign_conf{
		key = 714,
		year = 2018,
		month = 1,
		count = 14,
		reward = [],
		is_double = 0,
		vip_double = 0
	};

get({2018,1,15}) ->
	#everyday_sign_conf{
		key = 715,
		year = 2018,
		month = 1,
		count = 15,
		reward = [],
		is_double = 0,
		vip_double = 0
	};

get({2018,1,16}) ->
	#everyday_sign_conf{
		key = 716,
		year = 2018,
		month = 1,
		count = 16,
		reward = [],
		is_double = 0,
		vip_double = 0
	};

get({2018,1,17}) ->
	#everyday_sign_conf{
		key = 717,
		year = 2018,
		month = 1,
		count = 17,
		reward = [{110009,1,500000},{110045,1,250},{110148,1,2},{110127,1,120}],
		is_double = 0,
		vip_double = 0
	};

get({2018,1,18}) ->
	#everyday_sign_conf{
		key = 718,
		year = 2018,
		month = 1,
		count = 18,
		reward = [],
		is_double = 0,
		vip_double = 0
	};

get({2018,1,19}) ->
	#everyday_sign_conf{
		key = 719,
		year = 2018,
		month = 1,
		count = 19,
		reward = [],
		is_double = 0,
		vip_double = 0
	};

get({2018,1,20}) ->
	#everyday_sign_conf{
		key = 720,
		year = 2018,
		month = 1,
		count = 20,
		reward = [],
		is_double = 0,
		vip_double = 0
	};

get({2018,1,21}) ->
	#everyday_sign_conf{
		key = 721,
		year = 2018,
		month = 1,
		count = 21,
		reward = [],
		is_double = 0,
		vip_double = 0
	};

get({2018,1,22}) ->
	#everyday_sign_conf{
		key = 722,
		year = 2018,
		month = 1,
		count = 22,
		reward = [],
		is_double = 0,
		vip_double = 0
	};

get({2018,1,23}) ->
	#everyday_sign_conf{
		key = 723,
		year = 2018,
		month = 1,
		count = 23,
		reward = [],
		is_double = 0,
		vip_double = 0
	};

get({2018,1,24}) ->
	#everyday_sign_conf{
		key = 724,
		year = 2018,
		month = 1,
		count = 24,
		reward = [],
		is_double = 0,
		vip_double = 0
	};

get({2018,1,25}) ->
	#everyday_sign_conf{
		key = 725,
		year = 2018,
		month = 1,
		count = 25,
		reward = [],
		is_double = 0,
		vip_double = 0
	};

get({2018,1,26}) ->
	#everyday_sign_conf{
		key = 726,
		year = 2018,
		month = 1,
		count = 26,
		reward = [{110009,1,500000},{110045,1,300},{110149,1,1},{110140,1,10}],
		is_double = 0,
		vip_double = 0
	};

get({2018,1,27}) ->
	#everyday_sign_conf{
		key = 727,
		year = 2018,
		month = 1,
		count = 27,
		reward = [],
		is_double = 0,
		vip_double = 0
	};

get({2018,1,28}) ->
	#everyday_sign_conf{
		key = 728,
		year = 2018,
		month = 1,
		count = 28,
		reward = [],
		is_double = 0,
		vip_double = 0
	};

get({2018,1,29}) ->
	#everyday_sign_conf{
		key = 729,
		year = 2018,
		month = 1,
		count = 29,
		reward = [],
		is_double = 0,
		vip_double = 0
	};

get({2018,1,30}) ->
	#everyday_sign_conf{
		key = 730,
		year = 2018,
		month = 1,
		count = 30,
		reward = [],
		is_double = 0,
		vip_double = 0
	};

get({2018,1,31}) ->
	#everyday_sign_conf{
		key = 731,
		year = 2018,
		month = 1,
		count = 31,
		reward = [],
		is_double = 0,
		vip_double = 0
	};

get({2018,2,1}) ->
	#everyday_sign_conf{
		key = 732,
		year = 2018,
		month = 2,
		count = 1,
		reward = [],
		is_double = 0,
		vip_double = 0
	};

get({2018,2,2}) ->
	#everyday_sign_conf{
		key = 733,
		year = 2018,
		month = 2,
		count = 2,
		reward = [{110009,1,500000},{110045,1,100},{110148,1,1},{110127,1,30}],
		is_double = 0,
		vip_double = 0
	};

get({2018,2,3}) ->
	#everyday_sign_conf{
		key = 734,
		year = 2018,
		month = 2,
		count = 3,
		reward = [],
		is_double = 0,
		vip_double = 0
	};

get({2018,2,4}) ->
	#everyday_sign_conf{
		key = 735,
		year = 2018,
		month = 2,
		count = 4,
		reward = [],
		is_double = 0,
		vip_double = 0
	};

get({2018,2,5}) ->
	#everyday_sign_conf{
		key = 736,
		year = 2018,
		month = 2,
		count = 5,
		reward = [{110009,1,500000},{110045,1,150},{110148,1,1},{110127,1,60}],
		is_double = 0,
		vip_double = 0
	};

get({2018,2,6}) ->
	#everyday_sign_conf{
		key = 737,
		year = 2018,
		month = 2,
		count = 6,
		reward = [],
		is_double = 0,
		vip_double = 0
	};

get({2018,2,7}) ->
	#everyday_sign_conf{
		key = 738,
		year = 2018,
		month = 2,
		count = 7,
		reward = [],
		is_double = 0,
		vip_double = 0
	};

get({2018,2,8}) ->
	#everyday_sign_conf{
		key = 739,
		year = 2018,
		month = 2,
		count = 8,
		reward = [],
		is_double = 0,
		vip_double = 0
	};

get({2018,2,9}) ->
	#everyday_sign_conf{
		key = 740,
		year = 2018,
		month = 2,
		count = 9,
		reward = [],
		is_double = 0,
		vip_double = 0
	};

get({2018,2,10}) ->
	#everyday_sign_conf{
		key = 741,
		year = 2018,
		month = 2,
		count = 10,
		reward = [{110009,1,500000},{110045,1,200},{110148,1,1},{110127,1,90}],
		is_double = 0,
		vip_double = 0
	};

get({2018,2,11}) ->
	#everyday_sign_conf{
		key = 742,
		year = 2018,
		month = 2,
		count = 11,
		reward = [],
		is_double = 0,
		vip_double = 0
	};

get({2018,2,12}) ->
	#everyday_sign_conf{
		key = 743,
		year = 2018,
		month = 2,
		count = 12,
		reward = [],
		is_double = 0,
		vip_double = 0
	};

get({2018,2,13}) ->
	#everyday_sign_conf{
		key = 744,
		year = 2018,
		month = 2,
		count = 13,
		reward = [],
		is_double = 0,
		vip_double = 0
	};

get({2018,2,14}) ->
	#everyday_sign_conf{
		key = 745,
		year = 2018,
		month = 2,
		count = 14,
		reward = [],
		is_double = 0,
		vip_double = 0
	};

get({2018,2,15}) ->
	#everyday_sign_conf{
		key = 746,
		year = 2018,
		month = 2,
		count = 15,
		reward = [],
		is_double = 0,
		vip_double = 0
	};

get({2018,2,16}) ->
	#everyday_sign_conf{
		key = 747,
		year = 2018,
		month = 2,
		count = 16,
		reward = [],
		is_double = 0,
		vip_double = 0
	};

get({2018,2,17}) ->
	#everyday_sign_conf{
		key = 748,
		year = 2018,
		month = 2,
		count = 17,
		reward = [{110009,1,500000},{110045,1,250},{110148,1,2},{110127,1,120}],
		is_double = 0,
		vip_double = 0
	};

get({2018,2,18}) ->
	#everyday_sign_conf{
		key = 749,
		year = 2018,
		month = 2,
		count = 18,
		reward = [],
		is_double = 0,
		vip_double = 0
	};

get({2018,2,19}) ->
	#everyday_sign_conf{
		key = 750,
		year = 2018,
		month = 2,
		count = 19,
		reward = [],
		is_double = 0,
		vip_double = 0
	};

get({2018,2,20}) ->
	#everyday_sign_conf{
		key = 751,
		year = 2018,
		month = 2,
		count = 20,
		reward = [],
		is_double = 0,
		vip_double = 0
	};

get({2018,2,21}) ->
	#everyday_sign_conf{
		key = 752,
		year = 2018,
		month = 2,
		count = 21,
		reward = [],
		is_double = 0,
		vip_double = 0
	};

get({2018,2,22}) ->
	#everyday_sign_conf{
		key = 753,
		year = 2018,
		month = 2,
		count = 22,
		reward = [],
		is_double = 0,
		vip_double = 0
	};

get({2018,2,23}) ->
	#everyday_sign_conf{
		key = 754,
		year = 2018,
		month = 2,
		count = 23,
		reward = [],
		is_double = 0,
		vip_double = 0
	};

get({2018,2,24}) ->
	#everyday_sign_conf{
		key = 755,
		year = 2018,
		month = 2,
		count = 24,
		reward = [],
		is_double = 0,
		vip_double = 0
	};

get({2018,2,25}) ->
	#everyday_sign_conf{
		key = 756,
		year = 2018,
		month = 2,
		count = 25,
		reward = [],
		is_double = 0,
		vip_double = 0
	};

get({2018,2,26}) ->
	#everyday_sign_conf{
		key = 757,
		year = 2018,
		month = 2,
		count = 26,
		reward = [{110009,1,500000},{110045,1,300},{110149,1,1},{110140,1,10}],
		is_double = 0,
		vip_double = 0
	};

get({2018,2,27}) ->
	#everyday_sign_conf{
		key = 758,
		year = 2018,
		month = 2,
		count = 27,
		reward = [],
		is_double = 0,
		vip_double = 0
	};

get({2018,2,28}) ->
	#everyday_sign_conf{
		key = 759,
		year = 2018,
		month = 2,
		count = 28,
		reward = [],
		is_double = 0,
		vip_double = 0
	};

get({2018,3,1}) ->
	#everyday_sign_conf{
		key = 760,
		year = 2018,
		month = 3,
		count = 1,
		reward = [],
		is_double = 0,
		vip_double = 0
	};

get({2018,3,2}) ->
	#everyday_sign_conf{
		key = 761,
		year = 2018,
		month = 3,
		count = 2,
		reward = [{110009,1,500000},{110045,1,100},{110148,1,1},{110127,1,30}],
		is_double = 0,
		vip_double = 0
	};

get({2018,3,3}) ->
	#everyday_sign_conf{
		key = 762,
		year = 2018,
		month = 3,
		count = 3,
		reward = [],
		is_double = 0,
		vip_double = 0
	};

get({2018,3,4}) ->
	#everyday_sign_conf{
		key = 763,
		year = 2018,
		month = 3,
		count = 4,
		reward = [],
		is_double = 0,
		vip_double = 0
	};

get({2018,3,5}) ->
	#everyday_sign_conf{
		key = 764,
		year = 2018,
		month = 3,
		count = 5,
		reward = [{110009,1,500000},{110045,1,150},{110148,1,1},{110127,1,60}],
		is_double = 0,
		vip_double = 0
	};

get({2018,3,6}) ->
	#everyday_sign_conf{
		key = 765,
		year = 2018,
		month = 3,
		count = 6,
		reward = [],
		is_double = 0,
		vip_double = 0
	};

get({2018,3,7}) ->
	#everyday_sign_conf{
		key = 766,
		year = 2018,
		month = 3,
		count = 7,
		reward = [],
		is_double = 0,
		vip_double = 0
	};

get({2018,3,8}) ->
	#everyday_sign_conf{
		key = 767,
		year = 2018,
		month = 3,
		count = 8,
		reward = [],
		is_double = 0,
		vip_double = 0
	};

get({2018,3,9}) ->
	#everyday_sign_conf{
		key = 768,
		year = 2018,
		month = 3,
		count = 9,
		reward = [],
		is_double = 0,
		vip_double = 0
	};

get({2018,3,10}) ->
	#everyday_sign_conf{
		key = 769,
		year = 2018,
		month = 3,
		count = 10,
		reward = [{110009,1,500000},{110045,1,200},{110148,1,1},{110127,1,90}],
		is_double = 0,
		vip_double = 0
	};

get({2018,3,11}) ->
	#everyday_sign_conf{
		key = 770,
		year = 2018,
		month = 3,
		count = 11,
		reward = [],
		is_double = 0,
		vip_double = 0
	};

get({2018,3,12}) ->
	#everyday_sign_conf{
		key = 771,
		year = 2018,
		month = 3,
		count = 12,
		reward = [],
		is_double = 0,
		vip_double = 0
	};

get({2018,3,13}) ->
	#everyday_sign_conf{
		key = 772,
		year = 2018,
		month = 3,
		count = 13,
		reward = [],
		is_double = 0,
		vip_double = 0
	};

get({2018,3,14}) ->
	#everyday_sign_conf{
		key = 773,
		year = 2018,
		month = 3,
		count = 14,
		reward = [],
		is_double = 0,
		vip_double = 0
	};

get({2018,3,15}) ->
	#everyday_sign_conf{
		key = 774,
		year = 2018,
		month = 3,
		count = 15,
		reward = [],
		is_double = 0,
		vip_double = 0
	};

get({2018,3,16}) ->
	#everyday_sign_conf{
		key = 775,
		year = 2018,
		month = 3,
		count = 16,
		reward = [],
		is_double = 0,
		vip_double = 0
	};

get({2018,3,17}) ->
	#everyday_sign_conf{
		key = 776,
		year = 2018,
		month = 3,
		count = 17,
		reward = [{110009,1,500000},{110045,1,250},{110148,1,2},{110127,1,120}],
		is_double = 0,
		vip_double = 0
	};

get({2018,3,18}) ->
	#everyday_sign_conf{
		key = 777,
		year = 2018,
		month = 3,
		count = 18,
		reward = [],
		is_double = 0,
		vip_double = 0
	};

get({2018,3,19}) ->
	#everyday_sign_conf{
		key = 778,
		year = 2018,
		month = 3,
		count = 19,
		reward = [],
		is_double = 0,
		vip_double = 0
	};

get({2018,3,20}) ->
	#everyday_sign_conf{
		key = 779,
		year = 2018,
		month = 3,
		count = 20,
		reward = [],
		is_double = 0,
		vip_double = 0
	};

get({2018,3,21}) ->
	#everyday_sign_conf{
		key = 780,
		year = 2018,
		month = 3,
		count = 21,
		reward = [],
		is_double = 0,
		vip_double = 0
	};

get({2018,3,22}) ->
	#everyday_sign_conf{
		key = 781,
		year = 2018,
		month = 3,
		count = 22,
		reward = [],
		is_double = 0,
		vip_double = 0
	};

get({2018,3,23}) ->
	#everyday_sign_conf{
		key = 782,
		year = 2018,
		month = 3,
		count = 23,
		reward = [],
		is_double = 0,
		vip_double = 0
	};

get({2018,3,24}) ->
	#everyday_sign_conf{
		key = 783,
		year = 2018,
		month = 3,
		count = 24,
		reward = [],
		is_double = 0,
		vip_double = 0
	};

get({2018,3,25}) ->
	#everyday_sign_conf{
		key = 784,
		year = 2018,
		month = 3,
		count = 25,
		reward = [],
		is_double = 0,
		vip_double = 0
	};

get({2018,3,26}) ->
	#everyday_sign_conf{
		key = 785,
		year = 2018,
		month = 3,
		count = 26,
		reward = [{110009,1,500000},{110045,1,300},{110149,1,1},{110140,1,10}],
		is_double = 0,
		vip_double = 0
	};

get({2018,3,27}) ->
	#everyday_sign_conf{
		key = 786,
		year = 2018,
		month = 3,
		count = 27,
		reward = [],
		is_double = 0,
		vip_double = 0
	};

get({2018,3,28}) ->
	#everyday_sign_conf{
		key = 787,
		year = 2018,
		month = 3,
		count = 28,
		reward = [],
		is_double = 0,
		vip_double = 0
	};

get({2018,3,29}) ->
	#everyday_sign_conf{
		key = 788,
		year = 2018,
		month = 3,
		count = 29,
		reward = [],
		is_double = 0,
		vip_double = 0
	};

get({2018,3,30}) ->
	#everyday_sign_conf{
		key = 789,
		year = 2018,
		month = 3,
		count = 30,
		reward = [],
		is_double = 0,
		vip_double = 0
	};

get({2018,3,31}) ->
	#everyday_sign_conf{
		key = 790,
		year = 2018,
		month = 3,
		count = 31,
		reward = [],
		is_double = 0,
		vip_double = 0
	};

get({2018,4,1}) ->
	#everyday_sign_conf{
		key = 791,
		year = 2018,
		month = 4,
		count = 1,
		reward = [],
		is_double = 0,
		vip_double = 0
	};

get({2018,4,2}) ->
	#everyday_sign_conf{
		key = 792,
		year = 2018,
		month = 4,
		count = 2,
		reward = [{110009,1,500000},{110045,1,100},{110148,1,1},{110127,1,30}],
		is_double = 0,
		vip_double = 0
	};

get({2018,4,3}) ->
	#everyday_sign_conf{
		key = 793,
		year = 2018,
		month = 4,
		count = 3,
		reward = [],
		is_double = 0,
		vip_double = 0
	};

get({2018,4,4}) ->
	#everyday_sign_conf{
		key = 794,
		year = 2018,
		month = 4,
		count = 4,
		reward = [],
		is_double = 0,
		vip_double = 0
	};

get({2018,4,5}) ->
	#everyday_sign_conf{
		key = 795,
		year = 2018,
		month = 4,
		count = 5,
		reward = [{110009,1,500000},{110045,1,150},{110148,1,1},{110127,1,60}],
		is_double = 0,
		vip_double = 0
	};

get({2018,4,6}) ->
	#everyday_sign_conf{
		key = 796,
		year = 2018,
		month = 4,
		count = 6,
		reward = [],
		is_double = 0,
		vip_double = 0
	};

get({2018,4,7}) ->
	#everyday_sign_conf{
		key = 797,
		year = 2018,
		month = 4,
		count = 7,
		reward = [],
		is_double = 0,
		vip_double = 0
	};

get({2018,4,8}) ->
	#everyday_sign_conf{
		key = 798,
		year = 2018,
		month = 4,
		count = 8,
		reward = [],
		is_double = 0,
		vip_double = 0
	};

get({2018,4,9}) ->
	#everyday_sign_conf{
		key = 799,
		year = 2018,
		month = 4,
		count = 9,
		reward = [],
		is_double = 0,
		vip_double = 0
	};

get({2018,4,10}) ->
	#everyday_sign_conf{
		key = 800,
		year = 2018,
		month = 4,
		count = 10,
		reward = [{110009,1,500000},{110045,1,200},{110148,1,1},{110127,1,90}],
		is_double = 0,
		vip_double = 0
	};

get({2018,4,11}) ->
	#everyday_sign_conf{
		key = 801,
		year = 2018,
		month = 4,
		count = 11,
		reward = [],
		is_double = 0,
		vip_double = 0
	};

get({2018,4,12}) ->
	#everyday_sign_conf{
		key = 802,
		year = 2018,
		month = 4,
		count = 12,
		reward = [],
		is_double = 0,
		vip_double = 0
	};

get({2018,4,13}) ->
	#everyday_sign_conf{
		key = 803,
		year = 2018,
		month = 4,
		count = 13,
		reward = [],
		is_double = 0,
		vip_double = 0
	};

get({2018,4,14}) ->
	#everyday_sign_conf{
		key = 804,
		year = 2018,
		month = 4,
		count = 14,
		reward = [],
		is_double = 0,
		vip_double = 0
	};

get({2018,4,15}) ->
	#everyday_sign_conf{
		key = 805,
		year = 2018,
		month = 4,
		count = 15,
		reward = [],
		is_double = 0,
		vip_double = 0
	};

get({2018,4,16}) ->
	#everyday_sign_conf{
		key = 806,
		year = 2018,
		month = 4,
		count = 16,
		reward = [],
		is_double = 0,
		vip_double = 0
	};

get({2018,4,17}) ->
	#everyday_sign_conf{
		key = 807,
		year = 2018,
		month = 4,
		count = 17,
		reward = [{110009,1,500000},{110045,1,250},{110148,1,2},{110127,1,120}],
		is_double = 0,
		vip_double = 0
	};

get({2018,4,18}) ->
	#everyday_sign_conf{
		key = 808,
		year = 2018,
		month = 4,
		count = 18,
		reward = [],
		is_double = 0,
		vip_double = 0
	};

get({2018,4,19}) ->
	#everyday_sign_conf{
		key = 809,
		year = 2018,
		month = 4,
		count = 19,
		reward = [],
		is_double = 0,
		vip_double = 0
	};

get({2018,4,20}) ->
	#everyday_sign_conf{
		key = 810,
		year = 2018,
		month = 4,
		count = 20,
		reward = [],
		is_double = 0,
		vip_double = 0
	};

get({2018,4,21}) ->
	#everyday_sign_conf{
		key = 811,
		year = 2018,
		month = 4,
		count = 21,
		reward = [],
		is_double = 0,
		vip_double = 0
	};

get({2018,4,22}) ->
	#everyday_sign_conf{
		key = 812,
		year = 2018,
		month = 4,
		count = 22,
		reward = [],
		is_double = 0,
		vip_double = 0
	};

get({2018,4,23}) ->
	#everyday_sign_conf{
		key = 813,
		year = 2018,
		month = 4,
		count = 23,
		reward = [],
		is_double = 0,
		vip_double = 0
	};

get({2018,4,24}) ->
	#everyday_sign_conf{
		key = 814,
		year = 2018,
		month = 4,
		count = 24,
		reward = [],
		is_double = 0,
		vip_double = 0
	};

get({2018,4,25}) ->
	#everyday_sign_conf{
		key = 815,
		year = 2018,
		month = 4,
		count = 25,
		reward = [],
		is_double = 0,
		vip_double = 0
	};

get({2018,4,26}) ->
	#everyday_sign_conf{
		key = 816,
		year = 2018,
		month = 4,
		count = 26,
		reward = [{110009,1,500000},{110045,1,300},{110149,1,1},{110140,1,10}],
		is_double = 0,
		vip_double = 0
	};

get({2018,4,27}) ->
	#everyday_sign_conf{
		key = 817,
		year = 2018,
		month = 4,
		count = 27,
		reward = [],
		is_double = 0,
		vip_double = 0
	};

get({2018,4,28}) ->
	#everyday_sign_conf{
		key = 818,
		year = 2018,
		month = 4,
		count = 28,
		reward = [],
		is_double = 0,
		vip_double = 0
	};

get({2018,4,29}) ->
	#everyday_sign_conf{
		key = 819,
		year = 2018,
		month = 4,
		count = 29,
		reward = [],
		is_double = 0,
		vip_double = 0
	};

get({2018,4,30}) ->
	#everyday_sign_conf{
		key = 820,
		year = 2018,
		month = 4,
		count = 30,
		reward = [],
		is_double = 0,
		vip_double = 0
	};

get({2018,5,1}) ->
	#everyday_sign_conf{
		key = 821,
		year = 2018,
		month = 5,
		count = 1,
		reward = [],
		is_double = 0,
		vip_double = 0
	};

get({2018,5,2}) ->
	#everyday_sign_conf{
		key = 822,
		year = 2018,
		month = 5,
		count = 2,
		reward = [{110009,1,500000},{110045,1,100},{110148,1,1},{110127,1,30}],
		is_double = 0,
		vip_double = 0
	};

get({2018,5,3}) ->
	#everyday_sign_conf{
		key = 823,
		year = 2018,
		month = 5,
		count = 3,
		reward = [],
		is_double = 0,
		vip_double = 0
	};

get({2018,5,4}) ->
	#everyday_sign_conf{
		key = 824,
		year = 2018,
		month = 5,
		count = 4,
		reward = [],
		is_double = 0,
		vip_double = 0
	};

get({2018,5,5}) ->
	#everyday_sign_conf{
		key = 825,
		year = 2018,
		month = 5,
		count = 5,
		reward = [{110009,1,500000},{110045,1,150},{110148,1,1},{110127,1,60}],
		is_double = 0,
		vip_double = 0
	};

get({2018,5,6}) ->
	#everyday_sign_conf{
		key = 826,
		year = 2018,
		month = 5,
		count = 6,
		reward = [],
		is_double = 0,
		vip_double = 0
	};

get({2018,5,7}) ->
	#everyday_sign_conf{
		key = 827,
		year = 2018,
		month = 5,
		count = 7,
		reward = [],
		is_double = 0,
		vip_double = 0
	};

get({2018,5,8}) ->
	#everyday_sign_conf{
		key = 828,
		year = 2018,
		month = 5,
		count = 8,
		reward = [],
		is_double = 0,
		vip_double = 0
	};

get({2018,5,9}) ->
	#everyday_sign_conf{
		key = 829,
		year = 2018,
		month = 5,
		count = 9,
		reward = [],
		is_double = 0,
		vip_double = 0
	};

get({2018,5,10}) ->
	#everyday_sign_conf{
		key = 830,
		year = 2018,
		month = 5,
		count = 10,
		reward = [{110009,1,500000},{110045,1,200},{110148,1,1},{110127,1,90}],
		is_double = 0,
		vip_double = 0
	};

get({2018,5,11}) ->
	#everyday_sign_conf{
		key = 831,
		year = 2018,
		month = 5,
		count = 11,
		reward = [],
		is_double = 0,
		vip_double = 0
	};

get({2018,5,12}) ->
	#everyday_sign_conf{
		key = 832,
		year = 2018,
		month = 5,
		count = 12,
		reward = [],
		is_double = 0,
		vip_double = 0
	};

get({2018,5,13}) ->
	#everyday_sign_conf{
		key = 833,
		year = 2018,
		month = 5,
		count = 13,
		reward = [],
		is_double = 0,
		vip_double = 0
	};

get({2018,5,14}) ->
	#everyday_sign_conf{
		key = 834,
		year = 2018,
		month = 5,
		count = 14,
		reward = [],
		is_double = 0,
		vip_double = 0
	};

get({2018,5,15}) ->
	#everyday_sign_conf{
		key = 835,
		year = 2018,
		month = 5,
		count = 15,
		reward = [],
		is_double = 0,
		vip_double = 0
	};

get({2018,5,16}) ->
	#everyday_sign_conf{
		key = 836,
		year = 2018,
		month = 5,
		count = 16,
		reward = [],
		is_double = 0,
		vip_double = 0
	};

get({2018,5,17}) ->
	#everyday_sign_conf{
		key = 837,
		year = 2018,
		month = 5,
		count = 17,
		reward = [{110009,1,500000},{110045,1,250},{110148,1,2},{110127,1,120}],
		is_double = 0,
		vip_double = 0
	};

get({2018,5,18}) ->
	#everyday_sign_conf{
		key = 838,
		year = 2018,
		month = 5,
		count = 18,
		reward = [],
		is_double = 0,
		vip_double = 0
	};

get({2018,5,19}) ->
	#everyday_sign_conf{
		key = 839,
		year = 2018,
		month = 5,
		count = 19,
		reward = [],
		is_double = 0,
		vip_double = 0
	};

get({2018,5,20}) ->
	#everyday_sign_conf{
		key = 840,
		year = 2018,
		month = 5,
		count = 20,
		reward = [],
		is_double = 0,
		vip_double = 0
	};

get({2018,5,21}) ->
	#everyday_sign_conf{
		key = 841,
		year = 2018,
		month = 5,
		count = 21,
		reward = [],
		is_double = 0,
		vip_double = 0
	};

get({2018,5,22}) ->
	#everyday_sign_conf{
		key = 842,
		year = 2018,
		month = 5,
		count = 22,
		reward = [],
		is_double = 0,
		vip_double = 0
	};

get({2018,5,23}) ->
	#everyday_sign_conf{
		key = 843,
		year = 2018,
		month = 5,
		count = 23,
		reward = [],
		is_double = 0,
		vip_double = 0
	};

get({2018,5,24}) ->
	#everyday_sign_conf{
		key = 844,
		year = 2018,
		month = 5,
		count = 24,
		reward = [],
		is_double = 0,
		vip_double = 0
	};

get({2018,5,25}) ->
	#everyday_sign_conf{
		key = 845,
		year = 2018,
		month = 5,
		count = 25,
		reward = [],
		is_double = 0,
		vip_double = 0
	};

get({2018,5,26}) ->
	#everyday_sign_conf{
		key = 846,
		year = 2018,
		month = 5,
		count = 26,
		reward = [{110009,1,500000},{110045,1,300},{110149,1,1},{110140,1,10}],
		is_double = 0,
		vip_double = 0
	};

get({2018,5,27}) ->
	#everyday_sign_conf{
		key = 847,
		year = 2018,
		month = 5,
		count = 27,
		reward = [],
		is_double = 0,
		vip_double = 0
	};

get({2018,5,28}) ->
	#everyday_sign_conf{
		key = 848,
		year = 2018,
		month = 5,
		count = 28,
		reward = [],
		is_double = 0,
		vip_double = 0
	};

get({2018,5,29}) ->
	#everyday_sign_conf{
		key = 849,
		year = 2018,
		month = 5,
		count = 29,
		reward = [],
		is_double = 0,
		vip_double = 0
	};

get({2018,5,30}) ->
	#everyday_sign_conf{
		key = 850,
		year = 2018,
		month = 5,
		count = 30,
		reward = [],
		is_double = 0,
		vip_double = 0
	};

get({2018,5,31}) ->
	#everyday_sign_conf{
		key = 851,
		year = 2018,
		month = 5,
		count = 31,
		reward = [],
		is_double = 0,
		vip_double = 0
	};

get({2018,6,1}) ->
	#everyday_sign_conf{
		key = 852,
		year = 2018,
		month = 6,
		count = 1,
		reward = [],
		is_double = 0,
		vip_double = 0
	};

get({2018,6,2}) ->
	#everyday_sign_conf{
		key = 853,
		year = 2018,
		month = 6,
		count = 2,
		reward = [{110009,1,500000},{110045,1,100},{110148,1,1},{110127,1,30}],
		is_double = 0,
		vip_double = 0
	};

get({2018,6,3}) ->
	#everyday_sign_conf{
		key = 854,
		year = 2018,
		month = 6,
		count = 3,
		reward = [],
		is_double = 0,
		vip_double = 0
	};

get({2018,6,4}) ->
	#everyday_sign_conf{
		key = 855,
		year = 2018,
		month = 6,
		count = 4,
		reward = [],
		is_double = 0,
		vip_double = 0
	};

get({2018,6,5}) ->
	#everyday_sign_conf{
		key = 856,
		year = 2018,
		month = 6,
		count = 5,
		reward = [{110009,1,500000},{110045,1,150},{110148,1,1},{110127,1,60}],
		is_double = 0,
		vip_double = 0
	};

get({2018,6,6}) ->
	#everyday_sign_conf{
		key = 857,
		year = 2018,
		month = 6,
		count = 6,
		reward = [],
		is_double = 0,
		vip_double = 0
	};

get({2018,6,7}) ->
	#everyday_sign_conf{
		key = 858,
		year = 2018,
		month = 6,
		count = 7,
		reward = [],
		is_double = 0,
		vip_double = 0
	};

get({2018,6,8}) ->
	#everyday_sign_conf{
		key = 859,
		year = 2018,
		month = 6,
		count = 8,
		reward = [],
		is_double = 0,
		vip_double = 0
	};

get({2018,6,9}) ->
	#everyday_sign_conf{
		key = 860,
		year = 2018,
		month = 6,
		count = 9,
		reward = [],
		is_double = 0,
		vip_double = 0
	};

get({2018,6,10}) ->
	#everyday_sign_conf{
		key = 861,
		year = 2018,
		month = 6,
		count = 10,
		reward = [{110009,1,500000},{110045,1,200},{110148,1,1},{110127,1,90}],
		is_double = 0,
		vip_double = 0
	};

get({2018,6,11}) ->
	#everyday_sign_conf{
		key = 862,
		year = 2018,
		month = 6,
		count = 11,
		reward = [],
		is_double = 0,
		vip_double = 0
	};

get({2018,6,12}) ->
	#everyday_sign_conf{
		key = 863,
		year = 2018,
		month = 6,
		count = 12,
		reward = [],
		is_double = 0,
		vip_double = 0
	};

get({2018,6,13}) ->
	#everyday_sign_conf{
		key = 864,
		year = 2018,
		month = 6,
		count = 13,
		reward = [],
		is_double = 0,
		vip_double = 0
	};

get({2018,6,14}) ->
	#everyday_sign_conf{
		key = 865,
		year = 2018,
		month = 6,
		count = 14,
		reward = [],
		is_double = 0,
		vip_double = 0
	};

get({2018,6,15}) ->
	#everyday_sign_conf{
		key = 866,
		year = 2018,
		month = 6,
		count = 15,
		reward = [],
		is_double = 0,
		vip_double = 0
	};

get({2018,6,16}) ->
	#everyday_sign_conf{
		key = 867,
		year = 2018,
		month = 6,
		count = 16,
		reward = [],
		is_double = 0,
		vip_double = 0
	};

get({2018,6,17}) ->
	#everyday_sign_conf{
		key = 868,
		year = 2018,
		month = 6,
		count = 17,
		reward = [{110009,1,500000},{110045,1,250},{110148,1,2},{110127,1,120}],
		is_double = 0,
		vip_double = 0
	};

get({2018,6,18}) ->
	#everyday_sign_conf{
		key = 869,
		year = 2018,
		month = 6,
		count = 18,
		reward = [],
		is_double = 0,
		vip_double = 0
	};

get({2018,6,19}) ->
	#everyday_sign_conf{
		key = 870,
		year = 2018,
		month = 6,
		count = 19,
		reward = [],
		is_double = 0,
		vip_double = 0
	};

get({2018,6,20}) ->
	#everyday_sign_conf{
		key = 871,
		year = 2018,
		month = 6,
		count = 20,
		reward = [],
		is_double = 0,
		vip_double = 0
	};

get({2018,6,21}) ->
	#everyday_sign_conf{
		key = 872,
		year = 2018,
		month = 6,
		count = 21,
		reward = [],
		is_double = 0,
		vip_double = 0
	};

get({2018,6,22}) ->
	#everyday_sign_conf{
		key = 873,
		year = 2018,
		month = 6,
		count = 22,
		reward = [],
		is_double = 0,
		vip_double = 0
	};

get({2018,6,23}) ->
	#everyday_sign_conf{
		key = 874,
		year = 2018,
		month = 6,
		count = 23,
		reward = [],
		is_double = 0,
		vip_double = 0
	};

get({2018,6,24}) ->
	#everyday_sign_conf{
		key = 875,
		year = 2018,
		month = 6,
		count = 24,
		reward = [],
		is_double = 0,
		vip_double = 0
	};

get({2018,6,25}) ->
	#everyday_sign_conf{
		key = 876,
		year = 2018,
		month = 6,
		count = 25,
		reward = [],
		is_double = 0,
		vip_double = 0
	};

get({2018,6,26}) ->
	#everyday_sign_conf{
		key = 877,
		year = 2018,
		month = 6,
		count = 26,
		reward = [{110009,1,500000},{110045,1,300},{110149,1,1},{110140,1,10}],
		is_double = 0,
		vip_double = 0
	};

get({2018,6,27}) ->
	#everyday_sign_conf{
		key = 878,
		year = 2018,
		month = 6,
		count = 27,
		reward = [],
		is_double = 0,
		vip_double = 0
	};

get({2018,6,28}) ->
	#everyday_sign_conf{
		key = 879,
		year = 2018,
		month = 6,
		count = 28,
		reward = [],
		is_double = 0,
		vip_double = 0
	};

get({2018,6,29}) ->
	#everyday_sign_conf{
		key = 880,
		year = 2018,
		month = 6,
		count = 29,
		reward = [],
		is_double = 0,
		vip_double = 0
	};

get({2018,6,30}) ->
	#everyday_sign_conf{
		key = 881,
		year = 2018,
		month = 6,
		count = 30,
		reward = [],
		is_double = 0,
		vip_double = 0
	};

get({2018,7,1}) ->
	#everyday_sign_conf{
		key = 882,
		year = 2018,
		month = 7,
		count = 1,
		reward = [],
		is_double = 0,
		vip_double = 0
	};

get({2018,7,2}) ->
	#everyday_sign_conf{
		key = 883,
		year = 2018,
		month = 7,
		count = 2,
		reward = [{110009,1,500000},{110045,1,100},{110148,1,1},{110127,1,30}],
		is_double = 0,
		vip_double = 0
	};

get({2018,7,3}) ->
	#everyday_sign_conf{
		key = 884,
		year = 2018,
		month = 7,
		count = 3,
		reward = [],
		is_double = 0,
		vip_double = 0
	};

get({2018,7,4}) ->
	#everyday_sign_conf{
		key = 885,
		year = 2018,
		month = 7,
		count = 4,
		reward = [],
		is_double = 0,
		vip_double = 0
	};

get({2018,7,5}) ->
	#everyday_sign_conf{
		key = 886,
		year = 2018,
		month = 7,
		count = 5,
		reward = [{110009,1,500000},{110045,1,150},{110148,1,1},{110127,1,60}],
		is_double = 0,
		vip_double = 0
	};

get({2018,7,6}) ->
	#everyday_sign_conf{
		key = 887,
		year = 2018,
		month = 7,
		count = 6,
		reward = [],
		is_double = 0,
		vip_double = 0
	};

get({2018,7,7}) ->
	#everyday_sign_conf{
		key = 888,
		year = 2018,
		month = 7,
		count = 7,
		reward = [],
		is_double = 0,
		vip_double = 0
	};

get({2018,7,8}) ->
	#everyday_sign_conf{
		key = 889,
		year = 2018,
		month = 7,
		count = 8,
		reward = [],
		is_double = 0,
		vip_double = 0
	};

get({2018,7,9}) ->
	#everyday_sign_conf{
		key = 890,
		year = 2018,
		month = 7,
		count = 9,
		reward = [],
		is_double = 0,
		vip_double = 0
	};

get({2018,7,10}) ->
	#everyday_sign_conf{
		key = 891,
		year = 2018,
		month = 7,
		count = 10,
		reward = [{110009,1,500000},{110045,1,200},{110148,1,1},{110127,1,90}],
		is_double = 0,
		vip_double = 0
	};

get({2018,7,11}) ->
	#everyday_sign_conf{
		key = 892,
		year = 2018,
		month = 7,
		count = 11,
		reward = [],
		is_double = 0,
		vip_double = 0
	};

get({2018,7,12}) ->
	#everyday_sign_conf{
		key = 893,
		year = 2018,
		month = 7,
		count = 12,
		reward = [],
		is_double = 0,
		vip_double = 0
	};

get({2018,7,13}) ->
	#everyday_sign_conf{
		key = 894,
		year = 2018,
		month = 7,
		count = 13,
		reward = [],
		is_double = 0,
		vip_double = 0
	};

get({2018,7,14}) ->
	#everyday_sign_conf{
		key = 895,
		year = 2018,
		month = 7,
		count = 14,
		reward = [],
		is_double = 0,
		vip_double = 0
	};

get({2018,7,15}) ->
	#everyday_sign_conf{
		key = 896,
		year = 2018,
		month = 7,
		count = 15,
		reward = [],
		is_double = 0,
		vip_double = 0
	};

get({2018,7,16}) ->
	#everyday_sign_conf{
		key = 897,
		year = 2018,
		month = 7,
		count = 16,
		reward = [],
		is_double = 0,
		vip_double = 0
	};

get({2018,7,17}) ->
	#everyday_sign_conf{
		key = 898,
		year = 2018,
		month = 7,
		count = 17,
		reward = [{110009,1,500000},{110045,1,250},{110148,1,2},{110127,1,120}],
		is_double = 0,
		vip_double = 0
	};

get({2018,7,18}) ->
	#everyday_sign_conf{
		key = 899,
		year = 2018,
		month = 7,
		count = 18,
		reward = [],
		is_double = 0,
		vip_double = 0
	};

get({2018,7,19}) ->
	#everyday_sign_conf{
		key = 900,
		year = 2018,
		month = 7,
		count = 19,
		reward = [],
		is_double = 0,
		vip_double = 0
	};

get({2018,7,20}) ->
	#everyday_sign_conf{
		key = 901,
		year = 2018,
		month = 7,
		count = 20,
		reward = [],
		is_double = 0,
		vip_double = 0
	};

get({2018,7,21}) ->
	#everyday_sign_conf{
		key = 902,
		year = 2018,
		month = 7,
		count = 21,
		reward = [],
		is_double = 0,
		vip_double = 0
	};

get({2018,7,22}) ->
	#everyday_sign_conf{
		key = 903,
		year = 2018,
		month = 7,
		count = 22,
		reward = [],
		is_double = 0,
		vip_double = 0
	};

get({2018,7,23}) ->
	#everyday_sign_conf{
		key = 904,
		year = 2018,
		month = 7,
		count = 23,
		reward = [],
		is_double = 0,
		vip_double = 0
	};

get({2018,7,24}) ->
	#everyday_sign_conf{
		key = 905,
		year = 2018,
		month = 7,
		count = 24,
		reward = [],
		is_double = 0,
		vip_double = 0
	};

get({2018,7,25}) ->
	#everyday_sign_conf{
		key = 906,
		year = 2018,
		month = 7,
		count = 25,
		reward = [],
		is_double = 0,
		vip_double = 0
	};

get({2018,7,26}) ->
	#everyday_sign_conf{
		key = 907,
		year = 2018,
		month = 7,
		count = 26,
		reward = [{110009,1,500000},{110045,1,300},{110149,1,1},{110140,1,10}],
		is_double = 0,
		vip_double = 0
	};

get({2018,7,27}) ->
	#everyday_sign_conf{
		key = 908,
		year = 2018,
		month = 7,
		count = 27,
		reward = [],
		is_double = 0,
		vip_double = 0
	};

get({2018,7,28}) ->
	#everyday_sign_conf{
		key = 909,
		year = 2018,
		month = 7,
		count = 28,
		reward = [],
		is_double = 0,
		vip_double = 0
	};

get({2018,7,29}) ->
	#everyday_sign_conf{
		key = 910,
		year = 2018,
		month = 7,
		count = 29,
		reward = [],
		is_double = 0,
		vip_double = 0
	};

get({2018,7,30}) ->
	#everyday_sign_conf{
		key = 911,
		year = 2018,
		month = 7,
		count = 30,
		reward = [],
		is_double = 0,
		vip_double = 0
	};

get({2018,7,31}) ->
	#everyday_sign_conf{
		key = 912,
		year = 2018,
		month = 7,
		count = 31,
		reward = [],
		is_double = 0,
		vip_double = 0
	};

get({2018,8,1}) ->
	#everyday_sign_conf{
		key = 913,
		year = 2018,
		month = 8,
		count = 1,
		reward = [],
		is_double = 0,
		vip_double = 0
	};

get({2018,8,2}) ->
	#everyday_sign_conf{
		key = 914,
		year = 2018,
		month = 8,
		count = 2,
		reward = [{110009,1,500000},{110045,1,100},{110148,1,1},{110127,1,30}],
		is_double = 0,
		vip_double = 0
	};

get({2018,8,3}) ->
	#everyday_sign_conf{
		key = 915,
		year = 2018,
		month = 8,
		count = 3,
		reward = [],
		is_double = 0,
		vip_double = 0
	};

get({2018,8,4}) ->
	#everyday_sign_conf{
		key = 916,
		year = 2018,
		month = 8,
		count = 4,
		reward = [],
		is_double = 0,
		vip_double = 0
	};

get({2018,8,5}) ->
	#everyday_sign_conf{
		key = 917,
		year = 2018,
		month = 8,
		count = 5,
		reward = [{110009,1,500000},{110045,1,150},{110148,1,1},{110127,1,60}],
		is_double = 0,
		vip_double = 0
	};

get({2018,8,6}) ->
	#everyday_sign_conf{
		key = 918,
		year = 2018,
		month = 8,
		count = 6,
		reward = [],
		is_double = 0,
		vip_double = 0
	};

get({2018,8,7}) ->
	#everyday_sign_conf{
		key = 919,
		year = 2018,
		month = 8,
		count = 7,
		reward = [],
		is_double = 0,
		vip_double = 0
	};

get({2018,8,8}) ->
	#everyday_sign_conf{
		key = 920,
		year = 2018,
		month = 8,
		count = 8,
		reward = [],
		is_double = 0,
		vip_double = 0
	};

get({2018,8,9}) ->
	#everyday_sign_conf{
		key = 921,
		year = 2018,
		month = 8,
		count = 9,
		reward = [],
		is_double = 0,
		vip_double = 0
	};

get({2018,8,10}) ->
	#everyday_sign_conf{
		key = 922,
		year = 2018,
		month = 8,
		count = 10,
		reward = [{110009,1,500000},{110045,1,200},{110148,1,1},{110127,1,90}],
		is_double = 0,
		vip_double = 0
	};

get({2018,8,11}) ->
	#everyday_sign_conf{
		key = 923,
		year = 2018,
		month = 8,
		count = 11,
		reward = [],
		is_double = 0,
		vip_double = 0
	};

get({2018,8,12}) ->
	#everyday_sign_conf{
		key = 924,
		year = 2018,
		month = 8,
		count = 12,
		reward = [],
		is_double = 0,
		vip_double = 0
	};

get({2018,8,13}) ->
	#everyday_sign_conf{
		key = 925,
		year = 2018,
		month = 8,
		count = 13,
		reward = [],
		is_double = 0,
		vip_double = 0
	};

get({2018,8,14}) ->
	#everyday_sign_conf{
		key = 926,
		year = 2018,
		month = 8,
		count = 14,
		reward = [],
		is_double = 0,
		vip_double = 0
	};

get({2018,8,15}) ->
	#everyday_sign_conf{
		key = 927,
		year = 2018,
		month = 8,
		count = 15,
		reward = [],
		is_double = 0,
		vip_double = 0
	};

get({2018,8,16}) ->
	#everyday_sign_conf{
		key = 928,
		year = 2018,
		month = 8,
		count = 16,
		reward = [],
		is_double = 0,
		vip_double = 0
	};

get({2018,8,17}) ->
	#everyday_sign_conf{
		key = 929,
		year = 2018,
		month = 8,
		count = 17,
		reward = [{110009,1,500000},{110045,1,250},{110148,1,2},{110127,1,120}],
		is_double = 0,
		vip_double = 0
	};

get({2018,8,18}) ->
	#everyday_sign_conf{
		key = 930,
		year = 2018,
		month = 8,
		count = 18,
		reward = [],
		is_double = 0,
		vip_double = 0
	};

get({2018,8,19}) ->
	#everyday_sign_conf{
		key = 931,
		year = 2018,
		month = 8,
		count = 19,
		reward = [],
		is_double = 0,
		vip_double = 0
	};

get({2018,8,20}) ->
	#everyday_sign_conf{
		key = 932,
		year = 2018,
		month = 8,
		count = 20,
		reward = [],
		is_double = 0,
		vip_double = 0
	};

get({2018,8,21}) ->
	#everyday_sign_conf{
		key = 933,
		year = 2018,
		month = 8,
		count = 21,
		reward = [],
		is_double = 0,
		vip_double = 0
	};

get({2018,8,22}) ->
	#everyday_sign_conf{
		key = 934,
		year = 2018,
		month = 8,
		count = 22,
		reward = [],
		is_double = 0,
		vip_double = 0
	};

get({2018,8,23}) ->
	#everyday_sign_conf{
		key = 935,
		year = 2018,
		month = 8,
		count = 23,
		reward = [],
		is_double = 0,
		vip_double = 0
	};

get({2018,8,24}) ->
	#everyday_sign_conf{
		key = 936,
		year = 2018,
		month = 8,
		count = 24,
		reward = [],
		is_double = 0,
		vip_double = 0
	};

get({2018,8,25}) ->
	#everyday_sign_conf{
		key = 937,
		year = 2018,
		month = 8,
		count = 25,
		reward = [],
		is_double = 0,
		vip_double = 0
	};

get({2018,8,26}) ->
	#everyday_sign_conf{
		key = 938,
		year = 2018,
		month = 8,
		count = 26,
		reward = [{110009,1,500000},{110045,1,300},{110149,1,1},{110140,1,10}],
		is_double = 0,
		vip_double = 0
	};

get({2018,8,27}) ->
	#everyday_sign_conf{
		key = 939,
		year = 2018,
		month = 8,
		count = 27,
		reward = [],
		is_double = 0,
		vip_double = 0
	};

get({2018,8,28}) ->
	#everyday_sign_conf{
		key = 940,
		year = 2018,
		month = 8,
		count = 28,
		reward = [],
		is_double = 0,
		vip_double = 0
	};

get({2018,8,29}) ->
	#everyday_sign_conf{
		key = 941,
		year = 2018,
		month = 8,
		count = 29,
		reward = [],
		is_double = 0,
		vip_double = 0
	};

get({2018,8,30}) ->
	#everyday_sign_conf{
		key = 942,
		year = 2018,
		month = 8,
		count = 30,
		reward = [],
		is_double = 0,
		vip_double = 0
	};

get({2018,8,31}) ->
	#everyday_sign_conf{
		key = 943,
		year = 2018,
		month = 8,
		count = 31,
		reward = [],
		is_double = 0,
		vip_double = 0
	};

get({2018,9,1}) ->
	#everyday_sign_conf{
		key = 944,
		year = 2018,
		month = 9,
		count = 1,
		reward = [],
		is_double = 0,
		vip_double = 0
	};

get({2018,9,2}) ->
	#everyday_sign_conf{
		key = 945,
		year = 2018,
		month = 9,
		count = 2,
		reward = [{110009,1,500000},{110045,1,100},{110148,1,1},{110127,1,30}],
		is_double = 0,
		vip_double = 0
	};

get({2018,9,3}) ->
	#everyday_sign_conf{
		key = 946,
		year = 2018,
		month = 9,
		count = 3,
		reward = [],
		is_double = 0,
		vip_double = 0
	};

get({2018,9,4}) ->
	#everyday_sign_conf{
		key = 947,
		year = 2018,
		month = 9,
		count = 4,
		reward = [],
		is_double = 0,
		vip_double = 0
	};

get({2018,9,5}) ->
	#everyday_sign_conf{
		key = 948,
		year = 2018,
		month = 9,
		count = 5,
		reward = [{110009,1,500000},{110045,1,150},{110148,1,1},{110127,1,60}],
		is_double = 0,
		vip_double = 0
	};

get({2018,9,6}) ->
	#everyday_sign_conf{
		key = 949,
		year = 2018,
		month = 9,
		count = 6,
		reward = [],
		is_double = 0,
		vip_double = 0
	};

get({2018,9,7}) ->
	#everyday_sign_conf{
		key = 950,
		year = 2018,
		month = 9,
		count = 7,
		reward = [],
		is_double = 0,
		vip_double = 0
	};

get({2018,9,8}) ->
	#everyday_sign_conf{
		key = 951,
		year = 2018,
		month = 9,
		count = 8,
		reward = [],
		is_double = 0,
		vip_double = 0
	};

get({2018,9,9}) ->
	#everyday_sign_conf{
		key = 952,
		year = 2018,
		month = 9,
		count = 9,
		reward = [],
		is_double = 0,
		vip_double = 0
	};

get({2018,9,10}) ->
	#everyday_sign_conf{
		key = 953,
		year = 2018,
		month = 9,
		count = 10,
		reward = [{110009,1,500000},{110045,1,200},{110148,1,1},{110127,1,90}],
		is_double = 0,
		vip_double = 0
	};

get({2018,9,11}) ->
	#everyday_sign_conf{
		key = 954,
		year = 2018,
		month = 9,
		count = 11,
		reward = [],
		is_double = 0,
		vip_double = 0
	};

get({2018,9,12}) ->
	#everyday_sign_conf{
		key = 955,
		year = 2018,
		month = 9,
		count = 12,
		reward = [],
		is_double = 0,
		vip_double = 0
	};

get({2018,9,13}) ->
	#everyday_sign_conf{
		key = 956,
		year = 2018,
		month = 9,
		count = 13,
		reward = [],
		is_double = 0,
		vip_double = 0
	};

get({2018,9,14}) ->
	#everyday_sign_conf{
		key = 957,
		year = 2018,
		month = 9,
		count = 14,
		reward = [],
		is_double = 0,
		vip_double = 0
	};

get({2018,9,15}) ->
	#everyday_sign_conf{
		key = 958,
		year = 2018,
		month = 9,
		count = 15,
		reward = [],
		is_double = 0,
		vip_double = 0
	};

get({2018,9,16}) ->
	#everyday_sign_conf{
		key = 959,
		year = 2018,
		month = 9,
		count = 16,
		reward = [],
		is_double = 0,
		vip_double = 0
	};

get({2018,9,17}) ->
	#everyday_sign_conf{
		key = 960,
		year = 2018,
		month = 9,
		count = 17,
		reward = [{110009,1,500000},{110045,1,250},{110148,1,2},{110127,1,120}],
		is_double = 0,
		vip_double = 0
	};

get({2018,9,18}) ->
	#everyday_sign_conf{
		key = 961,
		year = 2018,
		month = 9,
		count = 18,
		reward = [],
		is_double = 0,
		vip_double = 0
	};

get({2018,9,19}) ->
	#everyday_sign_conf{
		key = 962,
		year = 2018,
		month = 9,
		count = 19,
		reward = [],
		is_double = 0,
		vip_double = 0
	};

get({2018,9,20}) ->
	#everyday_sign_conf{
		key = 963,
		year = 2018,
		month = 9,
		count = 20,
		reward = [],
		is_double = 0,
		vip_double = 0
	};

get({2018,9,21}) ->
	#everyday_sign_conf{
		key = 964,
		year = 2018,
		month = 9,
		count = 21,
		reward = [],
		is_double = 0,
		vip_double = 0
	};

get({2018,9,22}) ->
	#everyday_sign_conf{
		key = 965,
		year = 2018,
		month = 9,
		count = 22,
		reward = [],
		is_double = 0,
		vip_double = 0
	};

get({2018,9,23}) ->
	#everyday_sign_conf{
		key = 966,
		year = 2018,
		month = 9,
		count = 23,
		reward = [],
		is_double = 0,
		vip_double = 0
	};

get({2018,9,24}) ->
	#everyday_sign_conf{
		key = 967,
		year = 2018,
		month = 9,
		count = 24,
		reward = [],
		is_double = 0,
		vip_double = 0
	};

get({2018,9,25}) ->
	#everyday_sign_conf{
		key = 968,
		year = 2018,
		month = 9,
		count = 25,
		reward = [],
		is_double = 0,
		vip_double = 0
	};

get({2018,9,26}) ->
	#everyday_sign_conf{
		key = 969,
		year = 2018,
		month = 9,
		count = 26,
		reward = [{110009,1,500000},{110045,1,300},{110149,1,1},{110140,1,10}],
		is_double = 0,
		vip_double = 0
	};

get({2018,9,27}) ->
	#everyday_sign_conf{
		key = 970,
		year = 2018,
		month = 9,
		count = 27,
		reward = [],
		is_double = 0,
		vip_double = 0
	};

get({2018,9,28}) ->
	#everyday_sign_conf{
		key = 971,
		year = 2018,
		month = 9,
		count = 28,
		reward = [],
		is_double = 0,
		vip_double = 0
	};

get({2018,9,29}) ->
	#everyday_sign_conf{
		key = 972,
		year = 2018,
		month = 9,
		count = 29,
		reward = [],
		is_double = 0,
		vip_double = 0
	};

get({2018,9,30}) ->
	#everyday_sign_conf{
		key = 973,
		year = 2018,
		month = 9,
		count = 30,
		reward = [],
		is_double = 0,
		vip_double = 0
	};

get({2018,10,1}) ->
	#everyday_sign_conf{
		key = 974,
		year = 2018,
		month = 10,
		count = 1,
		reward = [],
		is_double = 0,
		vip_double = 0
	};

get({2018,10,2}) ->
	#everyday_sign_conf{
		key = 975,
		year = 2018,
		month = 10,
		count = 2,
		reward = [{110009,1,500000},{110045,1,100},{110148,1,1},{110127,1,30}],
		is_double = 0,
		vip_double = 0
	};

get({2018,10,3}) ->
	#everyday_sign_conf{
		key = 976,
		year = 2018,
		month = 10,
		count = 3,
		reward = [],
		is_double = 0,
		vip_double = 0
	};

get({2018,10,4}) ->
	#everyday_sign_conf{
		key = 977,
		year = 2018,
		month = 10,
		count = 4,
		reward = [],
		is_double = 0,
		vip_double = 0
	};

get({2018,10,5}) ->
	#everyday_sign_conf{
		key = 978,
		year = 2018,
		month = 10,
		count = 5,
		reward = [{110009,1,500000},{110045,1,150},{110148,1,1},{110127,1,60}],
		is_double = 0,
		vip_double = 0
	};

get({2018,10,6}) ->
	#everyday_sign_conf{
		key = 979,
		year = 2018,
		month = 10,
		count = 6,
		reward = [],
		is_double = 0,
		vip_double = 0
	};

get({2018,10,7}) ->
	#everyday_sign_conf{
		key = 980,
		year = 2018,
		month = 10,
		count = 7,
		reward = [],
		is_double = 0,
		vip_double = 0
	};

get({2018,10,8}) ->
	#everyday_sign_conf{
		key = 981,
		year = 2018,
		month = 10,
		count = 8,
		reward = [],
		is_double = 0,
		vip_double = 0
	};

get({2018,10,9}) ->
	#everyday_sign_conf{
		key = 982,
		year = 2018,
		month = 10,
		count = 9,
		reward = [],
		is_double = 0,
		vip_double = 0
	};

get({2018,10,10}) ->
	#everyday_sign_conf{
		key = 983,
		year = 2018,
		month = 10,
		count = 10,
		reward = [{110009,1,500000},{110045,1,200},{110148,1,1},{110127,1,90}],
		is_double = 0,
		vip_double = 0
	};

get({2018,10,11}) ->
	#everyday_sign_conf{
		key = 984,
		year = 2018,
		month = 10,
		count = 11,
		reward = [],
		is_double = 0,
		vip_double = 0
	};

get({2018,10,12}) ->
	#everyday_sign_conf{
		key = 985,
		year = 2018,
		month = 10,
		count = 12,
		reward = [],
		is_double = 0,
		vip_double = 0
	};

get({2018,10,13}) ->
	#everyday_sign_conf{
		key = 986,
		year = 2018,
		month = 10,
		count = 13,
		reward = [],
		is_double = 0,
		vip_double = 0
	};

get({2018,10,14}) ->
	#everyday_sign_conf{
		key = 987,
		year = 2018,
		month = 10,
		count = 14,
		reward = [],
		is_double = 0,
		vip_double = 0
	};

get({2018,10,15}) ->
	#everyday_sign_conf{
		key = 988,
		year = 2018,
		month = 10,
		count = 15,
		reward = [],
		is_double = 0,
		vip_double = 0
	};

get({2018,10,16}) ->
	#everyday_sign_conf{
		key = 989,
		year = 2018,
		month = 10,
		count = 16,
		reward = [],
		is_double = 0,
		vip_double = 0
	};

get({2018,10,17}) ->
	#everyday_sign_conf{
		key = 990,
		year = 2018,
		month = 10,
		count = 17,
		reward = [{110009,1,500000},{110045,1,250},{110148,1,2},{110127,1,120}],
		is_double = 0,
		vip_double = 0
	};

get({2018,10,18}) ->
	#everyday_sign_conf{
		key = 991,
		year = 2018,
		month = 10,
		count = 18,
		reward = [],
		is_double = 0,
		vip_double = 0
	};

get({2018,10,19}) ->
	#everyday_sign_conf{
		key = 992,
		year = 2018,
		month = 10,
		count = 19,
		reward = [],
		is_double = 0,
		vip_double = 0
	};

get({2018,10,20}) ->
	#everyday_sign_conf{
		key = 993,
		year = 2018,
		month = 10,
		count = 20,
		reward = [],
		is_double = 0,
		vip_double = 0
	};

get({2018,10,21}) ->
	#everyday_sign_conf{
		key = 994,
		year = 2018,
		month = 10,
		count = 21,
		reward = [],
		is_double = 0,
		vip_double = 0
	};

get({2018,10,22}) ->
	#everyday_sign_conf{
		key = 995,
		year = 2018,
		month = 10,
		count = 22,
		reward = [],
		is_double = 0,
		vip_double = 0
	};

get({2018,10,23}) ->
	#everyday_sign_conf{
		key = 996,
		year = 2018,
		month = 10,
		count = 23,
		reward = [],
		is_double = 0,
		vip_double = 0
	};

get({2018,10,24}) ->
	#everyday_sign_conf{
		key = 997,
		year = 2018,
		month = 10,
		count = 24,
		reward = [],
		is_double = 0,
		vip_double = 0
	};

get({2018,10,25}) ->
	#everyday_sign_conf{
		key = 998,
		year = 2018,
		month = 10,
		count = 25,
		reward = [],
		is_double = 0,
		vip_double = 0
	};

get({2018,10,26}) ->
	#everyday_sign_conf{
		key = 999,
		year = 2018,
		month = 10,
		count = 26,
		reward = [{110009,1,500000},{110045,1,300},{110149,1,1},{110140,1,10}],
		is_double = 0,
		vip_double = 0
	};

get({2018,10,27}) ->
	#everyday_sign_conf{
		key = 1000,
		year = 2018,
		month = 10,
		count = 27,
		reward = [],
		is_double = 0,
		vip_double = 0
	};

get({2018,10,28}) ->
	#everyday_sign_conf{
		key = 1001,
		year = 2018,
		month = 10,
		count = 28,
		reward = [],
		is_double = 0,
		vip_double = 0
	};

get({2018,10,29}) ->
	#everyday_sign_conf{
		key = 1002,
		year = 2018,
		month = 10,
		count = 29,
		reward = [],
		is_double = 0,
		vip_double = 0
	};

get({2018,10,30}) ->
	#everyday_sign_conf{
		key = 1003,
		year = 2018,
		month = 10,
		count = 30,
		reward = [],
		is_double = 0,
		vip_double = 0
	};

get({2018,10,31}) ->
	#everyday_sign_conf{
		key = 1004,
		year = 2018,
		month = 10,
		count = 31,
		reward = [],
		is_double = 0,
		vip_double = 0
	};

get({2018,11,1}) ->
	#everyday_sign_conf{
		key = 1005,
		year = 2018,
		month = 11,
		count = 1,
		reward = [],
		is_double = 0,
		vip_double = 0
	};

get({2018,11,2}) ->
	#everyday_sign_conf{
		key = 1006,
		year = 2018,
		month = 11,
		count = 2,
		reward = [{110009,1,500000},{110045,1,100},{110148,1,1},{110127,1,30}],
		is_double = 0,
		vip_double = 0
	};

get({2018,11,3}) ->
	#everyday_sign_conf{
		key = 1007,
		year = 2018,
		month = 11,
		count = 3,
		reward = [],
		is_double = 0,
		vip_double = 0
	};

get({2018,11,4}) ->
	#everyday_sign_conf{
		key = 1008,
		year = 2018,
		month = 11,
		count = 4,
		reward = [],
		is_double = 0,
		vip_double = 0
	};

get({2018,11,5}) ->
	#everyday_sign_conf{
		key = 1009,
		year = 2018,
		month = 11,
		count = 5,
		reward = [{110009,1,500000},{110045,1,150},{110148,1,1},{110127,1,60}],
		is_double = 0,
		vip_double = 0
	};

get({2018,11,6}) ->
	#everyday_sign_conf{
		key = 1010,
		year = 2018,
		month = 11,
		count = 6,
		reward = [],
		is_double = 0,
		vip_double = 0
	};

get({2018,11,7}) ->
	#everyday_sign_conf{
		key = 1011,
		year = 2018,
		month = 11,
		count = 7,
		reward = [],
		is_double = 0,
		vip_double = 0
	};

get({2018,11,8}) ->
	#everyday_sign_conf{
		key = 1012,
		year = 2018,
		month = 11,
		count = 8,
		reward = [],
		is_double = 0,
		vip_double = 0
	};

get({2018,11,9}) ->
	#everyday_sign_conf{
		key = 1013,
		year = 2018,
		month = 11,
		count = 9,
		reward = [],
		is_double = 0,
		vip_double = 0
	};

get({2018,11,10}) ->
	#everyday_sign_conf{
		key = 1014,
		year = 2018,
		month = 11,
		count = 10,
		reward = [{110009,1,500000},{110045,1,200},{110148,1,1},{110127,1,90}],
		is_double = 0,
		vip_double = 0
	};

get({2018,11,11}) ->
	#everyday_sign_conf{
		key = 1015,
		year = 2018,
		month = 11,
		count = 11,
		reward = [],
		is_double = 0,
		vip_double = 0
	};

get({2018,11,12}) ->
	#everyday_sign_conf{
		key = 1016,
		year = 2018,
		month = 11,
		count = 12,
		reward = [],
		is_double = 0,
		vip_double = 0
	};

get({2018,11,13}) ->
	#everyday_sign_conf{
		key = 1017,
		year = 2018,
		month = 11,
		count = 13,
		reward = [],
		is_double = 0,
		vip_double = 0
	};

get({2018,11,14}) ->
	#everyday_sign_conf{
		key = 1018,
		year = 2018,
		month = 11,
		count = 14,
		reward = [],
		is_double = 0,
		vip_double = 0
	};

get({2018,11,15}) ->
	#everyday_sign_conf{
		key = 1019,
		year = 2018,
		month = 11,
		count = 15,
		reward = [],
		is_double = 0,
		vip_double = 0
	};

get({2018,11,16}) ->
	#everyday_sign_conf{
		key = 1020,
		year = 2018,
		month = 11,
		count = 16,
		reward = [],
		is_double = 0,
		vip_double = 0
	};

get({2018,11,17}) ->
	#everyday_sign_conf{
		key = 1021,
		year = 2018,
		month = 11,
		count = 17,
		reward = [{110009,1,500000},{110045,1,250},{110148,1,2},{110127,1,120}],
		is_double = 0,
		vip_double = 0
	};

get({2018,11,18}) ->
	#everyday_sign_conf{
		key = 1022,
		year = 2018,
		month = 11,
		count = 18,
		reward = [],
		is_double = 0,
		vip_double = 0
	};

get({2018,11,19}) ->
	#everyday_sign_conf{
		key = 1023,
		year = 2018,
		month = 11,
		count = 19,
		reward = [],
		is_double = 0,
		vip_double = 0
	};

get({2018,11,20}) ->
	#everyday_sign_conf{
		key = 1024,
		year = 2018,
		month = 11,
		count = 20,
		reward = [],
		is_double = 0,
		vip_double = 0
	};

get({2018,11,21}) ->
	#everyday_sign_conf{
		key = 1025,
		year = 2018,
		month = 11,
		count = 21,
		reward = [],
		is_double = 0,
		vip_double = 0
	};

get({2018,11,22}) ->
	#everyday_sign_conf{
		key = 1026,
		year = 2018,
		month = 11,
		count = 22,
		reward = [],
		is_double = 0,
		vip_double = 0
	};

get({2018,11,23}) ->
	#everyday_sign_conf{
		key = 1027,
		year = 2018,
		month = 11,
		count = 23,
		reward = [],
		is_double = 0,
		vip_double = 0
	};

get({2018,11,24}) ->
	#everyday_sign_conf{
		key = 1028,
		year = 2018,
		month = 11,
		count = 24,
		reward = [],
		is_double = 0,
		vip_double = 0
	};

get({2018,11,25}) ->
	#everyday_sign_conf{
		key = 1029,
		year = 2018,
		month = 11,
		count = 25,
		reward = [],
		is_double = 0,
		vip_double = 0
	};

get({2018,11,26}) ->
	#everyday_sign_conf{
		key = 1030,
		year = 2018,
		month = 11,
		count = 26,
		reward = [{110009,1,500000},{110045,1,300},{110149,1,1},{110140,1,10}],
		is_double = 0,
		vip_double = 0
	};

get({2018,11,27}) ->
	#everyday_sign_conf{
		key = 1031,
		year = 2018,
		month = 11,
		count = 27,
		reward = [],
		is_double = 0,
		vip_double = 0
	};

get({2018,11,28}) ->
	#everyday_sign_conf{
		key = 1032,
		year = 2018,
		month = 11,
		count = 28,
		reward = [],
		is_double = 0,
		vip_double = 0
	};

get({2018,11,29}) ->
	#everyday_sign_conf{
		key = 1033,
		year = 2018,
		month = 11,
		count = 29,
		reward = [],
		is_double = 0,
		vip_double = 0
	};

get({2018,11,30}) ->
	#everyday_sign_conf{
		key = 1034,
		year = 2018,
		month = 11,
		count = 30,
		reward = [],
		is_double = 0,
		vip_double = 0
	};

get({2018,12,1}) ->
	#everyday_sign_conf{
		key = 1035,
		year = 2018,
		month = 12,
		count = 1,
		reward = [],
		is_double = 0,
		vip_double = 0
	};

get({2018,12,2}) ->
	#everyday_sign_conf{
		key = 1036,
		year = 2018,
		month = 12,
		count = 2,
		reward = [{110009,1,500000},{110045,1,100},{110148,1,1},{110127,1,30}],
		is_double = 0,
		vip_double = 0
	};

get({2018,12,3}) ->
	#everyday_sign_conf{
		key = 1037,
		year = 2018,
		month = 12,
		count = 3,
		reward = [],
		is_double = 0,
		vip_double = 0
	};

get({2018,12,4}) ->
	#everyday_sign_conf{
		key = 1038,
		year = 2018,
		month = 12,
		count = 4,
		reward = [],
		is_double = 0,
		vip_double = 0
	};

get({2018,12,5}) ->
	#everyday_sign_conf{
		key = 1039,
		year = 2018,
		month = 12,
		count = 5,
		reward = [{110009,1,500000},{110045,1,150},{110148,1,1},{110127,1,60}],
		is_double = 0,
		vip_double = 0
	};

get({2018,12,6}) ->
	#everyday_sign_conf{
		key = 1040,
		year = 2018,
		month = 12,
		count = 6,
		reward = [],
		is_double = 0,
		vip_double = 0
	};

get({2018,12,7}) ->
	#everyday_sign_conf{
		key = 1041,
		year = 2018,
		month = 12,
		count = 7,
		reward = [],
		is_double = 0,
		vip_double = 0
	};

get({2018,12,8}) ->
	#everyday_sign_conf{
		key = 1042,
		year = 2018,
		month = 12,
		count = 8,
		reward = [],
		is_double = 0,
		vip_double = 0
	};

get({2018,12,9}) ->
	#everyday_sign_conf{
		key = 1043,
		year = 2018,
		month = 12,
		count = 9,
		reward = [],
		is_double = 0,
		vip_double = 0
	};

get({2018,12,10}) ->
	#everyday_sign_conf{
		key = 1044,
		year = 2018,
		month = 12,
		count = 10,
		reward = [{110009,1,500000},{110045,1,200},{110148,1,1},{110127,1,90}],
		is_double = 0,
		vip_double = 0
	};

get({2018,12,11}) ->
	#everyday_sign_conf{
		key = 1045,
		year = 2018,
		month = 12,
		count = 11,
		reward = [],
		is_double = 0,
		vip_double = 0
	};

get({2018,12,12}) ->
	#everyday_sign_conf{
		key = 1046,
		year = 2018,
		month = 12,
		count = 12,
		reward = [],
		is_double = 0,
		vip_double = 0
	};

get({2018,12,13}) ->
	#everyday_sign_conf{
		key = 1047,
		year = 2018,
		month = 12,
		count = 13,
		reward = [],
		is_double = 0,
		vip_double = 0
	};

get({2018,12,14}) ->
	#everyday_sign_conf{
		key = 1048,
		year = 2018,
		month = 12,
		count = 14,
		reward = [],
		is_double = 0,
		vip_double = 0
	};

get({2018,12,15}) ->
	#everyday_sign_conf{
		key = 1049,
		year = 2018,
		month = 12,
		count = 15,
		reward = [],
		is_double = 0,
		vip_double = 0
	};

get({2018,12,16}) ->
	#everyday_sign_conf{
		key = 1050,
		year = 2018,
		month = 12,
		count = 16,
		reward = [],
		is_double = 0,
		vip_double = 0
	};

get({2018,12,17}) ->
	#everyday_sign_conf{
		key = 1051,
		year = 2018,
		month = 12,
		count = 17,
		reward = [{110009,1,500000},{110045,1,250},{110148,1,2},{110127,1,120}],
		is_double = 0,
		vip_double = 0
	};

get({2018,12,18}) ->
	#everyday_sign_conf{
		key = 1052,
		year = 2018,
		month = 12,
		count = 18,
		reward = [],
		is_double = 0,
		vip_double = 0
	};

get({2018,12,19}) ->
	#everyday_sign_conf{
		key = 1053,
		year = 2018,
		month = 12,
		count = 19,
		reward = [],
		is_double = 0,
		vip_double = 0
	};

get({2018,12,20}) ->
	#everyday_sign_conf{
		key = 1054,
		year = 2018,
		month = 12,
		count = 20,
		reward = [],
		is_double = 0,
		vip_double = 0
	};

get({2018,12,21}) ->
	#everyday_sign_conf{
		key = 1055,
		year = 2018,
		month = 12,
		count = 21,
		reward = [],
		is_double = 0,
		vip_double = 0
	};

get({2018,12,22}) ->
	#everyday_sign_conf{
		key = 1056,
		year = 2018,
		month = 12,
		count = 22,
		reward = [],
		is_double = 0,
		vip_double = 0
	};

get({2018,12,23}) ->
	#everyday_sign_conf{
		key = 1057,
		year = 2018,
		month = 12,
		count = 23,
		reward = [],
		is_double = 0,
		vip_double = 0
	};

get({2018,12,24}) ->
	#everyday_sign_conf{
		key = 1058,
		year = 2018,
		month = 12,
		count = 24,
		reward = [],
		is_double = 0,
		vip_double = 0
	};

get({2018,12,25}) ->
	#everyday_sign_conf{
		key = 1059,
		year = 2018,
		month = 12,
		count = 25,
		reward = [],
		is_double = 0,
		vip_double = 0
	};

get({2018,12,26}) ->
	#everyday_sign_conf{
		key = 1060,
		year = 2018,
		month = 12,
		count = 26,
		reward = [{110009,1,500000},{110045,1,300},{110149,1,1},{110140,1,10}],
		is_double = 0,
		vip_double = 0
	};

get({2018,12,27}) ->
	#everyday_sign_conf{
		key = 1061,
		year = 2018,
		month = 12,
		count = 27,
		reward = [],
		is_double = 0,
		vip_double = 0
	};

get({2018,12,28}) ->
	#everyday_sign_conf{
		key = 1062,
		year = 2018,
		month = 12,
		count = 28,
		reward = [],
		is_double = 0,
		vip_double = 0
	};

get({2018,12,29}) ->
	#everyday_sign_conf{
		key = 1063,
		year = 2018,
		month = 12,
		count = 29,
		reward = [],
		is_double = 0,
		vip_double = 0
	};

get({2018,12,30}) ->
	#everyday_sign_conf{
		key = 1064,
		year = 2018,
		month = 12,
		count = 30,
		reward = [],
		is_double = 0,
		vip_double = 0
	};

get({2018,12,31}) ->
	#everyday_sign_conf{
		key = 1065,
		year = 2018,
		month = 12,
		count = 31,
		reward = [],
		is_double = 0,
		vip_double = 0
	};

get(_Key) ->
	?ERR("undefined key from everyday_sign_config ~p", [_Key]).