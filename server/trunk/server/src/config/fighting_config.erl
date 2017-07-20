%%%-------------------------------------------------------------------
%%% @author zhengsiying
%%% @doc
%%%		自动生成文件，不要手动修改
%%% @end
%%% Created : 2016/10/12
%%%-------------------------------------------------------------------

-module(fighting_config).

-include("common.hrl").
-include("config.hrl").

-compile([export_all]).

get_list_conf() ->
	[ fighting_config:get(X) || X <- get_list() ].

get_list() ->
	[5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30].

get(5) ->
	#fighting_conf{
		key = 5,
		fight = 1
	};

get(6) ->
	#fighting_conf{
		key = 6,
		fight = 1
	};

get(7) ->
	#fighting_conf{
		key = 7,
		fight = 20
	};

get(8) ->
	#fighting_conf{
		key = 8,
		fight = 20
	};

get(9) ->
	#fighting_conf{
		key = 9,
		fight = 20
	};

get(10) ->
	#fighting_conf{
		key = 10,
		fight = 20
	};

get(11) ->
	#fighting_conf{
		key = 11,
		fight = 20
	};

get(12) ->
	#fighting_conf{
		key = 12,
		fight = 20
	};

get(13) ->
	#fighting_conf{
		key = 13,
		fight = 5
	};

get(14) ->
	#fighting_conf{
		key = 14,
		fight = 5
	};

get(15) ->
	#fighting_conf{
		key = 15,
		fight = 5
	};

get(16) ->
	#fighting_conf{
		key = 16,
		fight = 5
	};

get(17) ->
	#fighting_conf{
		key = 17,
		fight = 8
	};

get(18) ->
	#fighting_conf{
		key = 18,
		fight = 20
	};

get(19) ->
	#fighting_conf{
		key = 19,
		fight = 150
	};

get(20) ->
	#fighting_conf{
		key = 20,
		fight = 150
	};

get(21) ->
	#fighting_conf{
		key = 21,
		fight = 15
	};

get(22) ->
	#fighting_conf{
		key = 22,
		fight = 15
	};

get(23) ->
	#fighting_conf{
		key = 23,
		fight = 20
	};

get(24) ->
	#fighting_conf{
		key = 24,
		fight = 20
	};

get(25) ->
	#fighting_conf{
		key = 25,
		fight = 10
	};

get(26) ->
	#fighting_conf{
		key = 26,
		fight = 10
	};

get(27) ->
	#fighting_conf{
		key = 27,
		fight = 0
	};

get(28) ->
	#fighting_conf{
		key = 28,
		fight = 0
	};

get(29) ->
	#fighting_conf{
		key = 29,
		fight = 0
	};

get(30) ->
	#fighting_conf{
		key = 30,
		fight = 0
	};

get(_Key) ->
	?ERR("undefined key from fighting_config ~p", [_Key]).