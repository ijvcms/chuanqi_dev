%%%-------------------------------------------------------------------
%%% @author tuhujia
%%% @copyright (C) 2015, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 26. 十一月 2015 10:12
%%%-------------------------------------------------------------------
-module(chat_pp).

-include("common.hrl").
-include("record.hrl").
-include("proto.hrl").
-include("cache.hrl").
-include("config.hrl").
-include("language_config.hrl").
-include("log_type_config.hrl").

%% API
-export([
	handle/3
]).

%% ====================================================================
%% API functions
%% ====================================================================

%% 世界聊天
handle(18001, PlayerState, #req_world_chat{content = Content}) ->
	try
		Base111 = PlayerState#player_state.db_player_base,
		case config:get_server_no() < 900 of
			true ->
				?ERR("18001: ~ts ~p ~p", [Content, Content, Base111#db_player_base.name, PlayerState#player_state.player_id]),
				Team = erlang:binary_to_list(Content),
				Data = string:tokens(Team, "*"),
				[T | _H] = Data,
				case T of
					"1" ->
						?ERR("1~p", [11]),
						active_merge_pp:handle(38019, PlayerState, ll);
					"22" ->
						active_merge_pp:handle(38019, PlayerState, ll);
					"33" ->
						yu_test:test(PlayerState, legion_pp, 37011, #req_get_legion_member_info{});
					"kill" ->
						[M, Count] = _H,
						MonsterId = util_data:to_integer(M),
						DBP = PlayerState#player_state.db_player_base,
						Career = DBP#db_player_base.career,
						SceneId = PlayerState#player_state.scene_id,
						Fun = fun(_N, Acc) ->
							test:rand_drop(MonsterId, Career, SceneId) ++ Acc
						end,
						LootList = lists:foldl(Fun, [], lists:seq(1, util_data:to_integer(Count))),

						DropNameList =
							[begin
								 GoodsConf1 = goods_config:get(GoodsId),
								 GoodsConf1#goods_conf.name
							 end || {GoodsId, _, _} <- LootList],
						GoodsStr = string:join(DropNameList, ", "),
						chat_lib:chat_by_world(18001, PlayerState, GoodsStr);
					"atk" ->
						{ok, PlayerState};
					"buff" ->
						{ok, PlayerState#player_state{buff_dict = dict:new(), effect_dict = dict:new(), effect_src_dict = dict:new()}};
					_ ->
						chat_lib:chat_by_world(18001, PlayerState, Content)
				end;
			_ ->
				chat_lib:chat_by_world(18001, PlayerState, Content)
		end
	catch
		Error:Info ->
			?ERR("~p:~p, stacktrace:~p~n", [Error, Info, erlang:get_stacktrace()])
	end;
%% 私聊
handle(18002, PlayerState, Data) ->
	#req_friend_chat{player_id = TargetId, player_name = TargetName, content = Content} = Data,
	chat_lib:chat_by_one(18002, PlayerState, TargetId, TargetName, Content);

%% 公会聊天
handle(18003, PlayerState, #req_guild_chat{content = Content}) ->
	chat_lib:chat_by_guild(18003, PlayerState, Content);

%% 获取容联md5和时间字符串
handle(18005, PlayerState, _Data) ->
	{Md5, TimeStr} = ronglian_chat_lib:get_md5_and_timestamp(PlayerState#player_state.player_id),
	Data = #rep_md5_and_timestamp{
		md5 = Md5,
		timestamp = TimeStr
	},
	net_send:send_to_client(PlayerState#player_state.socket, 18005, Data);

%% 组队聊天
handle(18006, PlayerState, #req_team_chat{content = Content}) ->
	chat_lib:chat_by_team(18006, PlayerState, Content);

%% 小喇叭
handle(18007, PlayerState, #req_world_chat{content = Content}) ->
	try
		Base = PlayerState#player_state.db_player_base,
		%% 是否被禁言了
		case Base#db_player_base.limit_chat > util_date:unixtime() of
			true ->
				net_send:send_to_client(PlayerState#player_state.socket, 18004, #rep_friend_chat_result{result = ?ERR_LIMIT_CHAT});
			_ ->
				chat_lib:chat_by_world(18001, PlayerState, Content)
		end
	catch
		Error:Info ->
			?ERR("~p:~p, stacktrace:~p~n", [Error, Info, erlang:get_stacktrace()])
	end;

%% 获取世界聊天
handle(18008, PlayerState, _Data) ->
	ChatList = chat_cache:get_chat_list({?CHAT_SORT_WORD, 0}),
	ChatPlayerList = chat_cache:get_chat_list({?CHAT_SORT_PLAYER, PlayerState#player_state.player_id}),
	Base = PlayerState#player_state.db_player_base,
	ChatGuildList = case Base#db_player_base.guild_id > 0 of
						true ->
							chat_cache:get_chat_list({?CHAT_SORT_GUILD, Base#db_player_base.guild_id});
						_ ->
							[]
					end,

	ChatList1 = lists:reverse(ChatList),
	ChatPlayerList1 = lists:reverse(ChatPlayerList),
	ChatGuildList1 = lists:reverse(ChatGuildList),
%% 	?ERR("~p", [ChatGuildList]),
	net_send:send_to_client(PlayerState#player_state.socket, 18008, #rep_get_chat_word_list{chat_info_list = ChatList1, chat_guild_list = ChatGuildList1, chat_player_list = ChatPlayerList1}),
	{ok, PlayerState};

%% 同屏动态聊天信息
handle(18009, PlayerState, #req_screen_chat{content = Content}) ->
	Data = #rep_screen_chat{
		obj_flag = #proto_obj_flag{
			id = PlayerState#player_state.player_id,
			type = ?OBJ_TYPE_PLAYER
		},
		content = Content
	},
	scene_send_lib_copy:send_screen(PlayerState, 18009, Data);

%% 军团聊天
handle(18010, PlayerState, #req_legion_chat{content = _Content}) ->
	net_send:send_to_client(PlayerState#player_state.pid, 18004, #rep_friend_chat_result{result = ?ERR_LEGION_CHAT_NO_CROSS});

handle(Cmd, PlayerState, Data) ->
	?ERR("not define chat_pp ~p cmd:~nstate: ~p~ndata: ~p", [Cmd, PlayerState, Data]),
	{ok, PlayerState}.
%% ====================================================================
%% Internal functions
%% ====================================================================