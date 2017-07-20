%%%-------------------------------------------------------------------
%%% @author yubing
%%% @copyright (C) 2015, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 16. 十二月 2015 11:46
%%%-------------------------------------------------------------------
-module(back_lib).

-include("cache.hrl").
-include("record.hrl").
-include("common.hrl").
-include("config.hrl").
-include("proto.hrl").
-include("language_config.hrl").


-export([send_mail_player_name/4,send_mail_player_id/4]).

%% 根据玩家名字发送邮件
send_mail_player_name(Title,Content,NameList,GoodsList)->
	?INFO("NameList ~w~n",[NameList]),
	F=fun(X)->
		?INFO("NameList 1111 ~p",[X]),
		case player_id_name_lib:get_ets_player_id_name_by_playername(X) of
			fail->
				skip;
			Ets_Player_Name->
				?INFO("NameList 2222 ~p",[GoodsList]),
				mail_lib:send_mail_to_player(Ets_Player_Name#ets_player_id_name.player_id,<<"">>,Title,Content,GoodsList)
		end
	end,
	[F(X) || X<- NameList].

%% 根据玩家id发送邮件
send_mail_player_id(Title,Content,PlayerIdList,GoodsList)->
	F=fun(X)->
		PlyaerId=util_data:to_integer(X),
		mail_lib:send_mail_to_player(PlyaerId,<<"">>,Title,Content,GoodsList)
	end,
	[F(X) || X<- PlayerIdList].

%% 发送全副邮件





