%%%-------------------------------------------------------------------
%%% @author zhengsiying
%%% @doc
%%%		自动生成文件，不要手动修改
%%% @end
%%% Created : 2016/10/12
%%%-------------------------------------------------------------------

-module(wing_mapping_config).

-include("common.hrl").
-include("config.hrl").

-compile([export_all]).

get_list_conf() ->
	[ wing_mapping_config:get(X) || X <- get_list() ].

get_list() ->
	[309000, 309001, 309002, 309003, 309004, 309005, 309006, 309007, 309008, 309009, 309200, 309201, 309202, 309203, 309204, 309205, 309206, 309207, 309208, 309209, 309400, 309401, 309402, 309403, 309404, 309405, 309406, 309407, 309408, 309409].

get(309000) ->
	#wing_mapping_conf{
		key = 309000,
		wing_id = 307000
	};

get(309001) ->
	#wing_mapping_conf{
		key = 309001,
		wing_id = 307001
	};

get(309002) ->
	#wing_mapping_conf{
		key = 309002,
		wing_id = 307002
	};

get(309003) ->
	#wing_mapping_conf{
		key = 309003,
		wing_id = 307003
	};

get(309004) ->
	#wing_mapping_conf{
		key = 309004,
		wing_id = 307004
	};

get(309005) ->
	#wing_mapping_conf{
		key = 309005,
		wing_id = 307005
	};

get(309006) ->
	#wing_mapping_conf{
		key = 309006,
		wing_id = 307006
	};

get(309007) ->
	#wing_mapping_conf{
		key = 309007,
		wing_id = 307007
	};

get(309008) ->
	#wing_mapping_conf{
		key = 309008,
		wing_id = 307008
	};

get(309009) ->
	#wing_mapping_conf{
		key = 309009,
		wing_id = 307009
	};

get(309200) ->
	#wing_mapping_conf{
		key = 309200,
		wing_id = 307200
	};

get(309201) ->
	#wing_mapping_conf{
		key = 309201,
		wing_id = 307201
	};

get(309202) ->
	#wing_mapping_conf{
		key = 309202,
		wing_id = 307202
	};

get(309203) ->
	#wing_mapping_conf{
		key = 309203,
		wing_id = 307203
	};

get(309204) ->
	#wing_mapping_conf{
		key = 309204,
		wing_id = 307204
	};

get(309205) ->
	#wing_mapping_conf{
		key = 309205,
		wing_id = 307205
	};

get(309206) ->
	#wing_mapping_conf{
		key = 309206,
		wing_id = 307206
	};

get(309207) ->
	#wing_mapping_conf{
		key = 309207,
		wing_id = 307207
	};

get(309208) ->
	#wing_mapping_conf{
		key = 309208,
		wing_id = 307208
	};

get(309209) ->
	#wing_mapping_conf{
		key = 309209,
		wing_id = 307209
	};

get(309400) ->
	#wing_mapping_conf{
		key = 309400,
		wing_id = 307400
	};

get(309401) ->
	#wing_mapping_conf{
		key = 309401,
		wing_id = 307401
	};

get(309402) ->
	#wing_mapping_conf{
		key = 309402,
		wing_id = 307402
	};

get(309403) ->
	#wing_mapping_conf{
		key = 309403,
		wing_id = 307403
	};

get(309404) ->
	#wing_mapping_conf{
		key = 309404,
		wing_id = 307404
	};

get(309405) ->
	#wing_mapping_conf{
		key = 309405,
		wing_id = 307405
	};

get(309406) ->
	#wing_mapping_conf{
		key = 309406,
		wing_id = 307406
	};

get(309407) ->
	#wing_mapping_conf{
		key = 309407,
		wing_id = 307407
	};

get(309408) ->
	#wing_mapping_conf{
		key = 309408,
		wing_id = 307408
	};

get(309409) ->
	#wing_mapping_conf{
		key = 309409,
		wing_id = 307409
	};

get(_Key) ->
	?ERR("undefined key from wing_mapping_config ~p", [_Key]).