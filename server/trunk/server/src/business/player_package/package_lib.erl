%%%-------------------------------------------------------------------
%%% @author yubing
%%% @copyright (C) 2016, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 19. 一月 2016 19:18
%%%-------------------------------------------------------------------
-module(package_lib).


-include("cache.hrl").
-include("record.hrl").
-include("common.hrl").
-include("config.hrl").
-include("proto.hrl").
-include("language_config.hrl").
-include("log_type_config.hrl").

-export([
	get_package_list/1,
	reward_package_goods/2
]).


%% 获取当前分包等级的状态 是否已经领取了奖励了
get_package_list(PlayerState) ->
	F=fun(X)->
		X#db_player_package.lv
	end,
	PackageList=player_package_cache:select_all(PlayerState#player_state.player_id),
	[F(X) || X <- PackageList ].

%% 领取奖励
reward_package_goods(PlayerState,Lv) ->
	case lists:member(Lv,get_package_list(PlayerState)) of
		false ->
			case package_goods_config:get(Lv) of
				null->
					{ok, PlayerState,?ERR_PACKAGE1};
				PackageConf->
					Goodslist = PackageConf#package_goods_conf.goods,
					case goods_lib_log:add_goods_list(PlayerState, Goodslist,?LOG_TYPE_PACKAGE) of
						{ok, PlayerState1} ->
							PackageInfo=#db_player_package{
								player_id = PlayerState#player_state.player_id,
								lv = Lv,
								is_receive = 1
							},
							player_package_cache:insert(PackageInfo),
							{ok, PlayerState1,0};
						%% 此行必须最后一行 需要返回 状态信息
						{fail, Err} ->
							{ok, PlayerState,Err};
						_ ->
							{ok, PlayerState,?ERR_PACKAGE1}
					end
			end;
		_->
			{ok, PlayerState,?ERR_PACKAGE1}
	end.
%% **********************************
%%



