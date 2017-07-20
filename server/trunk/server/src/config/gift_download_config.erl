%%%-------------------------------------------------------------------
%%% @author zhengsiying
%%% @doc
%%%		自动生成文件，不要手动修改
%%% @end
%%% Created : 2016/10/12
%%%-------------------------------------------------------------------

-module(gift_download_config).

-include("common.hrl").
-include("config.hrl").

-compile([export_all]).

get_list_conf() ->
	[ gift_download_config:get(X) || X <- get_list() ].

get_list() ->
	[40, 50, 79].

get(40) ->
	#gift_download_conf{
		key = 40,
		reward = [{110045,1,50},{110083,1,10},{110003,1,10},{110056,1,1}],
		counter_id = 10074
	};

get(50) ->
	#gift_download_conf{
		key = 50,
		reward = [{110045,1,100},{110086,1,5},{110160,1,10},{110007,1,10}],
		counter_id = 10075
	};

get(79) ->
	#gift_download_conf{
		key = 79,
		reward = [{110045,1,250},{110090,1,5},{110219,1,2},{110193,1,10}],
		counter_id = 10076
	};

get(_Key) ->
	?ERR("undefined key from gift_download_config ~p", [_Key]).