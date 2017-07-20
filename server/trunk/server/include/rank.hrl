%% --------------------------------------------------------
%% @author thj
%% @created 2016-04-07
%% @doc 排行榜管理
%% @todo 排行榜头文件
%% --------------------------------------------------------

-define(MAX_RANK_NUM, 30).
-define(MAX_RANK_NUM_1, 10).

-define(MAX_RANK_PER_PAGE_NUM, 20).

-define(MAX_RANK_OPERATE_TYPE_4_NUM, 100).
-define(MAX_RANK_OPERATE_PAGE_NUM, 3).

%% SQL宏
-define(SQL_RANK_PLAYER_LV, "SELECT `player_id`, `name`, `career`,`lv`,`guild_id` FROM `player_base` where `lv`>~w ORDER BY `lv` DESC, `fight` ASC LIMIT ~w").
-define(SQL_RANK_PLAYER_FIGHT, "SELECT `player_id`, `name`, `career`,`fight`,`guild_id` FROM `player_base` where `fight`>~w ORDER BY `fight` DESC, `lv` ASC LIMIT ~w").
-define(SQL_RANK_GUILD_LV, io_lib:format(<<"SELECT `guild_id`, `guild_name`, `lv`, `chief_name`, `member_count` FROM `guild` ORDER BY `lv` DESC, `member_count` ASC LIMIT ~w">>, [?MAX_RANK_NUM])).

%% 玩家id / 帮派id 等唯一id映射到对应榜单的key
-define(ETS_RANK_INFO, ets_rank_info).

%% 排行榜ETS宏
-define(ETS_RANK_PLAYER_LV, ets_rank_player_lv).  %% 玩家等级排行
-define(ETS_RANK_PLAYER_FIGHT, ets_rank_player_fight).  %% 玩家战力排行
-define(ETS_RANK_GUILD_LV, ets_rank_guild_lv).   %% 公会等级排行


-define(ETS_OPERATE_TYPE_4, ets_rank_kill_active).  %% 运营活动类型5
%% 激活的排行榜
-define(ACTIVATE_RANKS, [
  ?ETS_RANK_PLAYER_LV,
  ?ETS_RANK_PLAYER_FIGHT,
  ?ETS_RANK_GUILD_LV
]).

%% 通过排行榜类型和玩家唯一id或者帮派唯一id等映射到排行榜(ets_rank_info)key的索引表
-record(ets_rank_info, {
  key = 0,      %% 排行榜标识
  rank_list = [],    %% 对应ets的排行榜列表
  update_time %% 更新时间纪录
}).

-record(ets_rank_player_lv, {
  player_id,
  name,
  career,
  lv,
  guild_id,
  rank
}).

-record(ets_rank_player_fight, {
  player_id,
  name,
  career,
  fight,
  guild_id,
  rank
}).

-record(ets_rank_guild_lv, {
  guild_id,
  guild_name,
  lv,
  chief_name,
  member_count,
  rank
}).

-record(ets_active_rank_info, {
  player_id,
  name,
  value,
  rank
}).

-record(ets_rank_kill_active, {
	player_id,
	player_name,
	score,
	rank
}).