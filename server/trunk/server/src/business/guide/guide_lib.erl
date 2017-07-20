%%%-------------------------------------------------------------------
%%% @author yubing
%%% @copyright (C) 2016, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 19. 一月 2016 14:57
%%%-------------------------------------------------------------------
-module(guide_lib).


-include("cache.hrl").
-include("record.hrl").
-include("common.hrl").
-include("config.hrl").
-include("proto.hrl").
-include("language_config.hrl").

-export([get_guide_state/2,get_guide_list/1]).


%% 判断玩家是否有做过当前新手步数
get_guide_state(PlayerId,GuideStepId)->
	case player_guide_cache:select_row(PlayerId,GuideStepId) of
		null->
			GuideStepInfo=#db_player_guide{
				player_id = PlayerId,
				guide_step_id = GuideStepId
			},
			player_guide_cache:insert(GuideStepInfo),
			0;
		_->
			1
	end.

get_guide_list(PlayerId)->
	GuideList= player_guide_cache:select_all(PlayerId),
	F=fun(X)->
		X#db_player_guide.guide_step_id
	end,
	[F(X) || X <- GuideList].
