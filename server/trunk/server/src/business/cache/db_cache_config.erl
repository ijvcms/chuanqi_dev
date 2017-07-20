%%%-------------------------------------------------------------------
%%% @author zhengsiying
%%% @copyright (C) 2015, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 16. 七月 2015 下午3:28
%%%-------------------------------------------------------------------
-module(db_cache_config).

-include("cache.hrl").

%% API
-export([
	get_list/0,
	get/1
]).

%% ====================================================================
%% API functions
%% ====================================================================
get_list() -> [
	?DB_PLAYER_BASE,
	?DB_PLAYER_MONEY,
	?DB_GOODS,
	?DB_PLAYER_COUNTER,
	?DB_PLAYER_ATTR,
	?DB_SKILL,
	?DB_BUFF,
	?DB_PLAYER_HOOK_STAR,
	?DB_PLAYER_MAIL,
	?DB_HOOK_STAR_REWARD,
	?DB_PLAYER_GUILD,
	?DB_GUILD,
	?DB_GUILD_ALLIANCE,
	?DB_PLAYER_GUILD_SHOP,
	?DB_PLAYER_TASK,
	?DB_PLAYER_TASK_FINISH,
	?DB_ARENA_RANK,
	?DB_ARENA_RECORD,
	?DB_ARENA_SHOP,
	?DB_PLAYER_FRIEND_ASK,
	?DB_PLAYER_FRIEND,
	?DB_PLAYER_FOE,
	?DB_PLAYER_BLACK,
	?DB_PLAYER_INSTANCE,
	?DB_PLAYER_INSTANCE_PASS,
	?DB_CITY_INFO,
	?DB_CITY_OFFICER,
	?DB_PET,
	?DB_PLAYER_GUIDE,
	?DB_PLAYER_VIP,
	?DB_PLAYER_PACKAGE,
	?DB_PLAYER_SALE,
	?DB_BUTTON_TIPS,
	?DB_MONSTER_KILLS,
	?DB_PLAYER_SIGN,
	?DB_PLAYER_DROP,
	?DB_SPECIAL_DROP,
	?DB_PLAYER_ACTIVE_SERVICE,
	?DB_PLAYER_MONTH,
	?DB_PLAYER_RED,
	?DB_RED_RECORD,
	?DB_PLAYER_MONSTER,
	?DB_PLAYER_MONSTER_STATE,
	?DB_LOTTERY_LOG,
	?DB_LOTTERY_DB,
	?DB_LOTTERY_COIN_DB,
	?DB_LOTTERY_COIN_LOG,
	?DB_LOTTERY_BOX_DB,
	?DB_LOTTERY_BOX_LOG,
	?DB_PLAYER_MYSTERY_SHOP,
	?DB_PLAYER_SHOP_ONCE,
	?DB_PLAYER_MARK,
	?DB_PLAYER_OPERATE_ACTIVE,
	?DB_PLAYER_OPERATE_RECORD,
	?DB_PLAYER_ACTIVE_SERVICE_RECORD,
	?DB_PLAYER_ACTIVE_SERVICE_MERGE,
	?DB_PLAYER_ACTIVE_SERVICE_RECORD_MERGE,
	?DB_PLAYER_MONSTER_MERGE
].

%% db模块必须提供select_row(Key), insert(Info), update(key, Info), delete(Key)这四个函数
%% 根据个人的需求提供select_all(Key)函数
get(?DB_PLAYER_BASE) ->
	#conf_cache{
		table_name = ?DB_PLAYER_BASE,
		key = #db_player_base.player_id,
		db_agent = player_base_db,
		init_time = 3600,
		hit_add_time = 10
	};
get(?DB_PLAYER_MONEY) ->
	#conf_cache{
		table_name = ?DB_PLAYER_MONEY,
		key = #db_player_money.player_id,
		db_agent = player_money_db,
		init_time = 3600,
		hit_add_time = 10
	};
get(?DB_PLAYER_MARK) ->
	#conf_cache{
		table_name = ?DB_PLAYER_MARK,
		key = #db_player_mark.player_id,
		db_agent = player_mark_db,
		init_time = 3600,
		hit_add_time = 10
	};
get(?DB_GOODS) ->
	#conf_cache{
		table_name = ?DB_GOODS,
		key = {#db_goods.id, #db_goods.player_id},
		db_agent = goods_db,
		init_time = 3600,
		hit_add_time = 10
	};
get(?DB_PLAYER_COUNTER) ->
	#conf_cache{
		table_name = ?DB_PLAYER_COUNTER,
		key = {#db_player_counter.player_id, #db_player_counter.counter_id},
		db_agent = counter_db,
		init_time = 3600,
		hit_add_time = 10
	};
get(?DB_PLAYER_MAIL) ->
	#conf_cache{
		table_name = ?DB_PLAYER_MAIL,
		key = {#db_player_mail.id, #db_player_mail.player_id},
		db_agent = mail_db,
		init_time = 3600,
		hit_add_time = 10
	};
get(?DB_PLAYER_GUILD) ->
	#conf_cache{
		table_name = ?DB_PLAYER_GUILD,
		key = #db_player_guild.player_id,
		db_agent = player_guild_db,
		init_time = 3600,
		hit_add_time = 10
	};
get(?DB_GUILD) ->
	#conf_cache{
		table_name = ?DB_GUILD,
		key = #db_guild.guild_id,
		db_agent = guild_db,
		init_time = 3600,
		hit_add_time = 10
	};
get(?DB_GUILD_ALLIANCE) ->
	#conf_cache{
		table_name = ?DB_GUILD_ALLIANCE,
		key = #db_guild_alliance.guild_id,
		db_agent = guild_alliance_db,
		init_time = 3600,
		hit_add_time = 10
	};
get(?DB_PLAYER_GUILD_SHOP) ->
	#conf_cache{
		table_name = ?DB_PLAYER_GUILD_SHOP,
		key = {#db_player_guild_shop.player_id, #db_player_guild_shop.shop_id},
		db_agent = guild_shop_db,
		init_time = 3600,
		hit_add_time = 10
	};
get(?DB_PLAYER_GEM) ->
	#conf_cache{
		table_name = ?DB_PLAYER_GEM,
		key = {#db_player_gem.player_id, #db_player_gem.equips_type, #db_player_gem.gem_type},
		db_agent = player_gem_db,
		init_time = 3600,
		hit_add_time = 10
	};
get(?DB_ARENA_RANK) ->
	#conf_cache{
		table_name = ?DB_ARENA_RANK,
		key = #db_arena_rank.player_id,
		db_agent = arena_rank_db,
		init_time = 3600,
		hit_add_time = 10
	};
get(?DB_ARENA_RECORD) ->
	#conf_cache{
		table_name = ?DB_ARENA_RECORD,
		key = #db_arena_record.player_id,
		db_agent = arena_record_db,
		init_time = 3600,
		hit_add_time = 10
	};
get(?DB_ARENA_SHOP) ->
	#conf_cache{
		table_name = ?DB_ARENA_SHOP,
		key = {#db_arena_shop.id, #db_arena_shop.player_id},
		db_agent = arena_shop_db,
		init_time = 3600,
		hit_add_time = 10
	};
get(?DB_PLAYER_ATTR) ->
	#conf_cache{
		table_name = ?DB_PLAYER_ATTR,
		key = #db_player_attr.player_id,
		db_agent = player_attr_db,
		init_time = 3600,
		hit_add_time = 10
	};
get(?DB_SKILL) ->
	#conf_cache{
		table_name = ?DB_SKILL,
		key = {#db_skill.player_id, #db_skill.skill_id},
		db_agent = skill_db,
		init_time = 3600,
		hit_add_time = 10
	};
get(?DB_BUFF) ->
	#conf_cache{
		table_name = ?DB_BUFF,
		key = {#db_buff.player_id, #db_buff.buff_id},
		db_agent = buff_db,
		init_time = 3600,
		hit_add_time = 10
	};
get(?DB_PLAYER_HOOK_STAR) ->
	#conf_cache{
		table_name = ?DB_PLAYER_HOOK_STAR,
		key = {#db_player_hook_star.player_id, #db_player_hook_star.hook_scene_id},
		db_agent = player_hook_star_db,
		init_time = 3600,
		hit_add_time = 10
	};
%% 任务相关缓存config信息
get(?DB_PLAYER_TASK) ->
	#conf_cache{
		table_name = ?DB_PLAYER_TASK,%% 表名信息
		key = {#db_player_task.taskid_id, #db_player_task.player_id},%% 缓存指定的键值 信息
		db_agent = player_task_db,%% 指定缓存运行的db文件
		init_time = 3600,%%缓存持续时间
		hit_add_time = 10 %%每一次更新，缓存增加时间
	};
%% 任务相关缓存config信息
get(?DB_PLAYER_TASK_FINISH) ->
	#conf_cache{
		table_name = ?DB_PLAYER_TASK_FINISH,%% 表名信息
		key = {#db_player_task_finish.taskid_id, #db_player_task_finish.player_id},%% 缓存指定的键值 信息
		db_agent = player_task_finish_db,%% 指定缓存运行的db文件
		init_time = 3600,%%缓存持续时间
		hit_add_time = 10 %%每一次更新，缓存增加时间
	};
get(?DB_HOOK_STAR_REWARD) ->
	#conf_cache{
		table_name = ?DB_HOOK_STAR_REWARD,
		key = {#db_hook_star_reward.player_id, #db_hook_star_reward.chapter},
		db_agent = hook_star_reward_db,
		init_time = 3600,
		hit_add_time = 10
	};
%% ---------------------------------------------------------
%% 社交关系相关表 信息 begin
get(?DB_PLAYER_BLACK) ->
	#conf_cache{
		table_name = ?DB_PLAYER_BLACK,
		key = {#db_player_black.player_id, #db_player_black.tplayer_id},
		db_agent = player_black_db,
		init_time = 3600,
		hit_add_time = 10
	};
get(?DB_PLAYER_FOE) ->
	#conf_cache{
		table_name = ?DB_PLAYER_FOE,
		key = {#db_player_foe.player_id, #db_player_foe.tplayer_id},
		db_agent = player_foe_db,
		init_time = 3600,
		hit_add_time = 10
	};
get(?DB_PLAYER_FRIEND) ->
	#conf_cache{
		table_name = ?DB_PLAYER_FRIEND,
		key = {#db_player_friend.player_id, #db_player_friend.tplayer_id},
		db_agent = player_friend_db,
		init_time = 3600,
		hit_add_time = 10
	};
get(?DB_PLAYER_FRIEND_ASK) ->
	#conf_cache{
		table_name = ?DB_PLAYER_FRIEND_ASK,
		key = {#db_player_friend_ask.player_id, #db_player_friend_ask.tplayer_id},
		db_agent = player_friend_ask_db,
		init_time = 3600,
		hit_add_time = 10
	};
%% 社交关系表 end
%% ---------------------------------------------------------
%% 玩家副本映射
get(?DB_PLAYER_INSTANCE) ->
	#conf_cache{
		table_name = ?DB_PLAYER_INSTANCE,
		key = {#db_player_instance.player_id, #db_player_instance.scene_id},
		db_agent = player_instance_db,
		init_time = 3600,
		hit_add_time = 10
	};
%% 玩家副本通关信息
get(?DB_PLAYER_INSTANCE_PASS) ->
	#conf_cache{
		table_name = ?DB_PLAYER_INSTANCE_PASS,
		key = {#db_player_instance_pass.player_id, #db_player_instance_pass.scene_id},
		db_agent = player_instance_pass_db,
		init_time = 3600,
		hit_add_time = 10
	};

%% ---------------------------------------------------------
%% 官员配置信息
get(?DB_CITY_INFO) ->
	#conf_cache{
		table_name = ?DB_CITY_INFO,
		key = #db_city_info.scene_id,
		db_agent = city_info_db,
		init_time = 3600,
		hit_add_time = 10
	};
get(?DB_CITY_OFFICER) ->
	#conf_cache{
		table_name = ?DB_CITY_OFFICER,
		key = {#db_city_officer.scene_id, #db_city_officer.player_id},
		db_agent = city_officer_db,
		init_time = 3600,
		hit_add_time = 10
	};

get(?DB_PLAYER_GUIDE) ->
	#conf_cache{
		table_name = ?DB_PLAYER_GUIDE,
		key = {#db_player_guide.guide_step_id, #db_player_guide.player_id},
		db_agent = player_guide_db,
		init_time = 3600,
		hit_add_time = 10
	};

get(?DB_PLAYER_VIP) ->
	#conf_cache{
		table_name = ?DB_PLAYER_VIP,
		key = {#db_player_vip.vip_lv, #db_player_vip.player_id},
		db_agent = player_vip_db,
		init_time = 3600,
		hit_add_time = 10
	};


get(?DB_PLAYER_PACKAGE) ->
	#conf_cache{
		table_name = ?DB_PLAYER_PACKAGE,
		key = {#db_player_package.lv, #db_player_package.player_id},
		db_agent = player_package_db,
		init_time = 3600,
		hit_add_time = 10
	};

get(?DB_PLAYER_SALE) ->
	#conf_cache{
		table_name = ?DB_PLAYER_SALE,
		key = {#db_player_sale.id, #db_player_sale.player_id},
		db_agent = player_sale_db,
		init_time = 3600,
		hit_add_time = 10
	};
get(?DB_MONSTER_KILLS) ->
	#conf_cache{
		table_name = ?DB_MONSTER_KILLS,
		key = {#db_monster_kills.monster_id, #db_monster_kills.scene_id},
		db_agent = monster_kills_db,
		init_time = 3600,
		hit_add_time = 10
	};
get(?DB_PLAYER_SIGN) ->
	#conf_cache{
		table_name = ?DB_PLAYER_SIGN,
		key = #db_player_sign.player_id,
		db_agent = sign_db,
		init_time = 3600,
		hit_add_time = 10
	};
%%开服活动 相关信息
get(?DB_PLAYER_ACTIVE_SERVICE) ->
	#conf_cache{
		table_name = ?DB_PLAYER_ACTIVE_SERVICE,
		key = {#db_player_active_service.player_id, #db_player_active_service.active_service_id},
		db_agent = player_active_service_db,
		init_time = 3600,
		hit_add_time = 10
	};

%% ---------------------------------------------------------
%% 宠物信息
get(?DB_PET) ->
	#conf_cache{
		table_name = ?DB_PET,
		key = #db_pet.player_id,
		db_agent = pet_db,
		init_time = 3600,
		hit_add_time = 10
	};

get(?DB_BUTTON_TIPS) ->
	#conf_cache{
		table_name = ?DB_BUTTON_TIPS,
		key = {#db_button_tips.player_id, #db_button_tips.btn_id},
		db_agent = button_tips_db,
		init_time = 3600,
		hit_add_time = 10
	};

get(?DB_RED_RECORD) ->
	#conf_cache{
		table_name = ?DB_RED_RECORD,
		key = #db_red_record.red_id,
		db_agent = red_record_db,
		init_time = 3600,
		hit_add_time = 10
	};
get(?DB_PLAYER_RED) ->
	#conf_cache{
		table_name = ?DB_PLAYER_RED,
		key = {#db_player_red.red_id, #db_player_red.player_id},
		db_agent = player_red_db,
		init_time = 3600,
		hit_add_time = 10
	};
%% ---------------------------------------------------------
%% 掉落信息
get(?DB_PLAYER_DROP) ->
	#conf_cache{
		table_name = ?DB_PLAYER_DROP,
		key = {#db_player_drop.player_id, #db_player_drop.monster_id},
		db_agent = player_drop_db,
		init_time = 3600,
		hit_add_time = 10
	};

%% ---------------------------------------------------------
%%月卡
get(?DB_PLAYER_MONTH) ->
	#conf_cache{
		table_name = ?DB_PLAYER_MONTH,
		key = #db_player_month.player_id,
		db_agent = player_month_db,
		init_time = 3600,
		hit_add_time = 10
	};
%% 玩家击杀boss相关信息
get(?DB_PLAYER_MONSTER) ->
	#conf_cache{
		table_name = ?DB_PLAYER_MONSTER,%% 表名信息
		key = {#db_player_monster.monster_id, #db_player_monster.player_id},%% 缓存指定的键值 信息
		db_agent = player_monster_db,%% 指定缓存运行的db文件
		init_time = 3600,%%缓存持续时间
		hit_add_time = 10 %%每一次更新，缓存增加时间
	};
%% ---------------------------------------------------------
%%保存场景怪物状态
get(?DB_PLAYER_MONSTER_STATE) ->
	#conf_cache{
		table_name = ?DB_PLAYER_MONSTER_STATE,
		key = #db_player_monster_state.player_id,
		db_agent = player_monster_state_db,
		init_time = 3600,
		hit_add_time = 10
	};
%% ---------------------------------------------------------
%% 抽奖记录相关
get(?DB_LOTTERY_DB) ->
	#conf_cache{
		table_name = ?DB_LOTTERY_DB,%% 表名信息
		key = #db_lottery_db.lottery_id,%% 缓存指定的键值 信息
		db_agent = lottery_db_db,%% 指定缓存运行的db文件
		init_time = 3600,%%缓存持续时间
		hit_add_time = 10 %%每一次更新，缓存增加时间
	};
%% 抽奖日志相关
get(?DB_LOTTERY_COIN_LOG) ->
	#conf_cache{
		table_name = ?DB_LOTTERY_COIN_LOG,%% 表名信息
		key = #db_lottery_coin_log.id,%% 缓存指定的键值 信息
		db_agent = lottery_coin_log_db,%% 指定缓存运行的db文件
		init_time = 3600,%%缓存持续时间
		hit_add_time = 10 %%每一次更新，缓存增加时间
	};
%% 抽奖记录相关
get(?DB_LOTTERY_COIN_DB) ->
	#conf_cache{
		table_name = ?DB_LOTTERY_COIN_DB,%% 表名信息
		key = #db_lottery_coin_db.lottery_coin_id,%% 缓存指定的键值 信息
		db_agent = lottery_coin_db_db,%% 指定缓存运行的db文件
		init_time = 3600,%%缓存持续时间
		hit_add_time = 10 %%每一次更新，缓存增加时间
	};
%% 抽奖日志相关
get(?DB_LOTTERY_LOG) ->
	#conf_cache{
		table_name = ?DB_LOTTERY_LOG,%% 表名信息
		key = #db_lottery_log.id,%% 缓存指定的键值 信息
		db_agent = lottery_log_db,%% 指定缓存运行的db文件
		init_time = 3600,%%缓存持续时间
		hit_add_time = 10 %%每一次更新，缓存增加时间
	};
%% 抽奖箱日志相关
get(?DB_LOTTERY_BOX_LOG) ->
	#conf_cache{
		table_name = ?DB_LOTTERY_BOX_LOG,%% 表名信息
		key = #db_lottery_box_log.id,%% 缓存指定的键值 信息
		db_agent = lottery_box_log_db,%% 指定缓存运行的db文件
		init_time = 3600,%%缓存持续时间
		hit_add_time = 10 %%每一次更新，缓存增加时间
	};
%% 抽奖箱记录相关
get(?DB_LOTTERY_BOX_DB) ->
	#conf_cache{
		table_name = ?DB_LOTTERY_BOX_DB,%% 表名信息
		key = #db_lottery_box_db.lottery_id,%% 缓存指定的键值 信息
		db_agent = lottery_box_db_db,%% 指定缓存运行的db文件
		init_time = 3600,%%缓存持续时间
		hit_add_time = 10 %%每一次更新，缓存增加时间
	};
%% 神秘商店
get(?DB_PLAYER_MYSTERY_SHOP) ->
	#conf_cache{
		table_name = ?DB_PLAYER_MYSTERY_SHOP,%% 表名信息
		key = {#db_player_mystery_shop.player_id, #db_player_mystery_shop.id},%% 缓存指定的键值 信息
		db_agent = player_mystery_shop_db,%% 指定缓存运行的db文件
		init_time = 3600,%%缓存持续时间
		hit_add_time = 10 %%每一次更新，缓存增加时间
	};
%% 一生一次礼包
get(?DB_PLAYER_SHOP_ONCE) ->
	#conf_cache{
		table_name = ?DB_PLAYER_SHOP_ONCE,%% 表名信息
		key = {#db_player_shop_once.player_id, #db_player_shop_once.lv, #db_player_shop_once.pos},%% 缓存指定的键值 信息
		db_agent = player_shop_once_db,%% 指定缓存运行的db文件
		init_time = 3600,%%缓存持续时间
		hit_add_time = 10 %%每一次更新，缓存增加时间
	};

get(?DB_SPECIAL_DROP) ->
	#conf_cache{
		table_name = ?DB_SPECIAL_DROP,
		key = #db_special_drop.drop_type,
		db_agent = special_drop_db,
		init_time = 3600,
		hit_add_time = 10
	};
%% 开服活动
get(?DB_PLAYER_ACTIVE_SERVICE_RECORD) ->
	#conf_cache{
		table_name = ?DB_PLAYER_ACTIVE_SERVICE_RECORD,
		key = {#db_player_active_service_record.active_service_type_id, #db_player_active_service_record.player_id},
		db_agent = player_active_service_record_db,
		init_time = 3600,
		hit_add_time = 10
	};
%%合服活动 相关信息
get(?DB_PLAYER_ACTIVE_SERVICE_MERGE) ->
	#conf_cache{
		table_name = ?DB_PLAYER_ACTIVE_SERVICE_MERGE,
		key = {#db_player_active_service_merge.player_id, #db_player_active_service_merge.active_service_merge_id},
		db_agent = player_active_service_merge_db,
		init_time = 3600,
		hit_add_time = 10
	};
%% 合服活动 记录
get(?DB_PLAYER_ACTIVE_SERVICE_RECORD_MERGE) ->
	#conf_cache{
		table_name = ?DB_PLAYER_ACTIVE_SERVICE_RECORD_MERGE,
		key = {#db_player_active_service_record_merge.active_service_merge_type_id, #db_player_active_service_record_merge.player_id},
		db_agent = player_active_service_record_merge_db,
		init_time = 3600,
		hit_add_time = 10
	};
%% 合服击杀boss相关信息
get(?DB_PLAYER_MONSTER_MERGE) ->
	#conf_cache{
		table_name = ?DB_PLAYER_MONSTER_MERGE,%% 表名信息
		key = {#db_player_monster_merge.monster_id, #db_player_monster_merge.player_id},%% 缓存指定的键值 信息
		db_agent = player_monster_merge_db,%% 指定缓存运行的db文件
		init_time = 3600,%%缓存持续时间
		hit_add_time = 10 %%每一次更新，缓存增加时间
	};
%% 运营活动
get(?DB_PLAYER_OPERATE_RECORD) ->
	#conf_cache{
		table_name = ?DB_PLAYER_OPERATE_RECORD,
		key = {#db_player_operate_record.player_id, #db_player_operate_record.active_id, #db_player_operate_record.finish_limit_type},
		db_agent = player_operate_record_db,
		init_time = 3600,
		hit_add_time = 10
	};

get(?DB_PLAYER_OPERATE_ACTIVE) ->
	#conf_cache{
		table_name = ?DB_PLAYER_OPERATE_ACTIVE,
		key = {#db_player_operate_active.player_id, #db_player_operate_active.active_id, #db_player_operate_active.sub_type},
		db_agent = player_operate_active_db,
		init_time = 3600,
		hit_add_time = 10
	}.

%% ====================================================================
%% Internal functions
%% ====================================================================