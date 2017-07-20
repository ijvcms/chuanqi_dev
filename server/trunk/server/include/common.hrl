-define(TCP_OPTIONS, [binary, {packet, 0}, {active, false}, {reuseaddr, true}, {nodelay, false}, {delay_send, true}, {send_timeout, 5000}, {keepalive, false}, {exit_on_close, true}]).
-define(FL_POLICY_REQ, <<"<poli">>).
-define(FL_POLICY_FILE, <<"<cross-domain-policy><allow-access-fromdomain='*'to-ports='*'/></cross-domain-policy>">>).

%% ==================================================================
%% log
%% ==================================================================
-define(TEST_MSG(Format, Args),
	erlang:group_leader(whereis(user), self()),
	logger:test_msg(?MODULE, ?LINE, Format, Args)).
-define(DEBUG(Format, Args),
	erlang:group_leader(whereis(user), self()),
	logger:debug_msg(?MODULE, ?LINE, Format, Args)).
-define(INFO(Format, Args),
	erlang:group_leader(whereis(user), self()),
	logger:info_msg(?MODULE, ?LINE, Format, Args)).
-define(WARNING(Format, Args),
	erlang:group_leader(whereis(user), self()),
	logger:warning_msg(?MODULE, ?LINE, Format, Args)).
-define(ERR(Format, Args),
	erlang:group_leader(whereis(user), self()),
	logger:error_msg(?MODULE, ?LINE, Format, Args)).
-define(CRITICAL(Format, Args),
	erlang:group_leader(whereis(user), self()),
	logger:critical_msg(?MODULE, ?LINE, Format, Args)).

-define(TEST_MSG(Format),
	?TEST_MSG(Format, [])).
-define(DEBUG(Format),
	?DEBUG(Format, [])).
-define(INFO(Format),
	?INFO(Format, [])).
-define(WARNING(Format),
	?WARNING(Format, [])).
-define(ERR(Format),
	?ERR(Format, [])).
-define(CRITICAL(Format),
	?CRITICAL(Format, [])).

-define(TRACE(X), io:format("TRACE======>>>>>~p:line~p,Value=~p\n", [?MODULE, ?LINE, X])).

%% ==================================================================
%% ets
%% ==================================================================
%% 记录在线玩家账号
-define(ETS_ACCOUNT_ONLINE, ets_account_online).

%% 记录在线玩家
-define(ETS_ONLINE, ets_online).

%% 记录运行中场景
-define(ETS_SCENE, ets_scene).

%% 记录场景id到场景进程的映射
-define(ETS_SCENE_MAPS, ets_scene_maps).

%% 记录玩家对应进入的场景
-define(ETS_PLAYER_SCENE, ets_player_scene).

%% 沙城活动
-define(ETS_ACTIVITY_SHACHENG, ets_activity_shacheng).

%% 记录对应场景boss刷新时间
-define(ETS_BOSS_REFRESH, ets_boss_refresh).

%% 记录玩家计数器
-define(ETS_PLAYER_COUNTER, ets_player_counter).

%% 关键字过滤缓存
-define(ETS_KEYWORD_GROUP, ets_keyword_group).

%% 聊天信息缓存
-define(ETS_CHAT, ets_chat).

%% 邮件配置表
-define(ETS_MAIL_CONF, ets_mail_conf).

%% 玩家邮件记录
-define(ETS_PLAYER_MAIL, ets_player_mail).

%% 玩家关系记录
-define(ETS_RELATIONSHIP, ets_relationship).

%% 玩家第一称号相关信息
-define(ETS_TITLE_CAREET, ets_title_careet).

%% 工会成员记录
-define(ETS_GUILD, ets_guild).

%% 工会成员记录
-define(ETS_GUILD_LIST, ets_guild_list).

%% 工会，军团对应的mode
-define(ETS_GUILD_MOD, ets_guild_mod).

%% 玩家宝石列表
-define(ETS_PLAYER_GEM_LIST, ets_player_gem_list).

%% 玩家竞技场排名
-define(ETS_ARENA_RANK, ets_arena_rank).

%% 玩家竞技场记录
-define(ETS_ARENA_RECORD, ets_arena_record).

%% 玩家竞技场商店记录
-define(ETS_ARENA_SHOP, ets_arena_shop).

%% 交易记录
-define(ETS_TRANSACTION, ets_transaction).

%% 队伍记录
-define(ETS_TEAM, ets_team).

%% 玩家队伍记录
-define(ETS_PlAYER_TEAM, ets_player_team).

%% 玩家名称est纪录
-define(ETS_PLAYER_ID_NAME, ets_player_id_name).
-define(ETS_PLAYER_NAME_ID, ets_player_name_id).

%% 通用配置
-define(ETS_COMMON_CONFIG, ets_common_config).

%% 公告
-define(ETS_NOTICE, ets_notice).

%% 云游商人商品列表ets
-define(ETS_WANDER_SHOP_LIST, ets_wander_shop_list).
%% 容联聊天
-define(ETS_RL_GROUP, ets_rl_group).
%% 限时活动提醒ets
-define(ETS_ACTIVE_REMIND, ets_active_remind).

%% 全服首次击杀boss信息记录
-define(ETS_ACTIVE_SERVICE_MONTHER, ets_active_service_monther).

%% 合服首次击杀boss信息记录
-define(ETS_ACTIVE_SERVICE_MONTHER_MERGE, ets_active_service_monther_merge).
%% 特殊掉落ets
-define(ETS_SPECIAL_DROP, ets_special_drop).

%% 玩家击杀ets记录
-define(ETS_PLAYER_KILL, ets_player_kill).

%% 功能标信息
-define(ETS_FUNCTION, ets_function).

%% 运营活动相关
-define(ETS_OPERATE_ACTIVE_CONF, ets_operate_active_conf).
-define(ETS_OPERATE_SUB_TYPE_CONF, ets_operate_sub_type_conf).
-define(ETS_OPEN_OPERATE_LIST, ets_open_operate_list).
-define(ETS_DOUBLE_EXP, ets_double_exp).

%% 根据坐标记录相邻区域 根据坐标找出相邻区域
-define(ETS_AREA_ID_LIST, ets_area_id_list).        %

%% 红点
-define(ETS_BUTTON_UPDATE_TIME, ets_button_update_time).

%% 沙巴克宝箱记录
-define(ETS_SBK_BOX, ets_sbk_box).

%% 沙巴克宝箱记录
-define(ETS_HJZC, ets_hjzc).

%% 结盟相关信息
-define(ETS_GUILD_ALLIANCE, ets_guild_alliance).    %%ets
-define(ETS_GUILD_ALLIANCE_STATE, ets_guild_alliance_state).    %%ets
%% ==================================================================
%% 敏感词
%% ==================================================================
%% 敏感词首字树
-define(ETS_SENSITIVE_WORD_FIRST, ets_sensitive_word_first).
%% 敏感词所有字树
-define(ETS_SENSITIVE_WORD_ALL, ets_sensitive_word_all).
%% 敏感词所有词哈希树
-define(ETS_SENSITIVE_WORD_HASH, ets_sensitive_word_hash).
%% 单一词树
-define(ETS_SENSITIVE_WORD_SINGLE, ets_sensitive_word_single).

%% ==================================================================
%% db
%% ==================================================================
%% 数据库连接相关
-define(DB_ENCODE, utf8).
-define(DB_POOL, mysql_conn).
-define(DB_POOL_MIAND, mysql_conn_db).%% 游戏数据库
-define(DB_POOL_LOG, mysql_conn_log).%% 日志数据库
-define(DB_POOL_DATA, mysql_conn_data).%% 中央数据库
-define(DB_POOL_FRIEND, mysql_conn_friend).    %% 好友数据库
-define(DB_MODULE, db_mysql).

%% ==================================================================
%% 自定义
%% ==================================================================
%% 百分比分母
-define(PERCENT_BASE, 10000).

%% 玩家自动回血时间(秒)
-define(PLAYER_RECOVER_CD, 12).

%% 广播类型
-define(BROADCAST_TYPE_WORLD, 1).

%% 平台表示
-define(PLATFORM_IOS, 1).
-define(PLATFORM_ANDROID, 2).

%% 退出标识
-define(LOGOUT_FLAG_PLAYER, 1).
-define(LOGOUT_FLAG_ACCOUNT, 2).
-define(LOGOUT_FLAG_OTHER_LOGIN, 3).

%% 性别类型
-define(SEX_MALE, 1).
-define(SEX_FEMALE, 2).

%% 职业
-define(CAREER_ZHANSHI, 1000). %% 战士
-define(CAREER_FASHI, 2000). %% 法师
-define(CAREER_DAOSHI, 3000). %% 道士

%% 最多可建角色数量
-define(MAX_CREATE_COUNT, 3).

%% 道具相关
-define(GOODS_TYPE, 1).
-define(EQUIPS_TYPE, 2).%% 装备类型
-define(MAP_TYPE, 7).  %% 藏宝图类型

-define(ITEM_FLYING_SHOES, 110078).%% 小飞鞋道具id
-define(ITEM_CREATE_GUILD, 110048).%% 创建行会所需道具
-define(ITEM_REVIVE, 110054).%%复活丹道具

%%戒指
-define(RING_STEALTH_SKILL, 51200). %% 隐身戒指技能id
-define(RING_TRANSFER_SKILL, 51300). %% 传送戒指技能id

%% 状态
-define(STATUS_ALIVE, 1). %% 活着
-define(STATUS_DIE, 2). %% 死亡

%% pk模式
-define(PK_MODE_PEACE, 1). %% 和平
-define(PK_MODE_ALL, 2). %% 全体
-define(PK_MODE_GUILD, 3). %% 帮派
-define(PK_MODE_TEAM, 4). %% 队伍
-define(PK_MODE_JUSTICE, 5). %% 善恶
-define(PK_MODE_NOOB, 6). %% 新手
-define(PK_MODE_FOE, 7). %% 仇人模式
-define(PK_MODE_LEGION, 8). %%军团模式
-define(PK_MODE_ALLIANCE, 9). %%结盟模式
%% 聊天信息缓存
-define(ETS_FOE, ets_foe).%% 玩家仇人记录

%% 对象类型
-define(OBJ_TYPE_PLAYER, 1). %% 玩家
-define(OBJ_TYPE_MONSTER, 2). %% 怪物
-define(OBJ_TYPE_DROP, 3). %% 掉落
-define(OBJ_TYPE_PET, 4). %% 宠物
-define(OBJ_TYPE_FIRE_WALL, 5). %% 火墙
-define(OBJ_TYPE_IMAGE, 6). %% 玩家镜像
-define(OBJ_TYPE_COLLECT, 7). %% 采集道具

%% 所有对象类型列表
-define(OBJ_ALL_TYPE, [
	?OBJ_TYPE_PLAYER,
	?OBJ_TYPE_MONSTER,
	?OBJ_TYPE_DROP,
	?OBJ_TYPE_PET,
	?OBJ_TYPE_FIRE_WALL,
	?OBJ_TYPE_IMAGE,
	?OBJ_TYPE_COLLECT
]).

%% 生物型对象列表
-define(BIONT_TYPE, [
	?OBJ_TYPE_PLAYER,
	?OBJ_TYPE_MONSTER,
	?OBJ_TYPE_PET,
	?OBJ_TYPE_IMAGE,
	?OBJ_TYPE_COLLECT
]).

-define(DEFAULT_GUISE_WEAPON, 0). %% 武器默认外观
-define(DEFAULT_GUISE_CLOTHES, 10). %% 衣服默认外观

%% 玩家名字颜色
-define(NAME_COLOUR_WHITE, 1). %% 白色
-define(NAME_COLOUR_YELLOW, 2). %% 黄色
-define(NAME_COLOUR_RED, 3). %% 红色
-define(NAME_COLOUR_GRAY, 4). %% 灰色

%% 玩家属性变更原因
-define(UPDATE_CAUSE_OTHER, 0). %% 其他原因
-define(UPDATE_CAUSE_SKILL, 1). %% 技能
-define(UPDATE_CAUSE_SELF_RECOVER, 2). %% 自身恢复
-define(UPDATE_CAUSE_CHANGE_EQUIPS, 3). %% 换装
-define(UPDATE_CAUSE_LV_UP, 4). %% 升级
-define(UPDATE_CAUSE_DRUG, 5). %% 药物

%% 变更标识
-define(UPDATE_FLAG_OTHER, 0). %% 其他
-define(UPDATE_FLAG_HARM, 1). %% 伤害
-define(UPDATE_FLAG_RECOVER, 2). %% 恢复

%% 玩家更新key
-define(UPDATE_KEY_LV, 1). %% 等级
-define(UPDATE_KEY_EXP, 2). %% 经验
-define(UPDATE_KEY_CUR_HP, 3). %% 当前血量
-define(UPDATE_KEY_CUR_MP, 4). %% 当前魔法
-define(UPDATE_KEY_HP, 5). %% 血量上限
-define(UPDATE_KEY_MP, 6). %% 魔法上限
-define(UPDATE_KEY_MIN_AC, 7). %% 最小物理攻击
-define(UPDATE_KEY_MAX_AC, 8). %% 最大物理攻击
-define(UPDATE_KEY_MIN_MAC, 9). %% 最小魔法攻击
-define(UPDATE_KEY_MAX_MAC, 10). %% 最大魔法攻击
-define(UPDATE_KEY_MIN_SC, 11). %% 最小道术攻击
-define(UPDATE_KEY_MAX_SC, 12). %% 最大道术攻击
-define(UPDATE_KEY_MIN_DEF, 13). %% 最小物防
-define(UPDATE_KEY_MAX_DEF, 14). %% 最大物防
-define(UPDATE_KEY_MIN_RES, 15). %% 最小魔防
-define(UPDATE_KEY_MAX_RES, 16). %% 最大魔防
-define(UPDATE_KEY_CRIT, 17). %% 暴击
-define(UPDATE_KEY_CRIT_ATT, 18). %% 暴击伤害
-define(UPDATE_KEY_HIT, 19). %% 准确
-define(UPDATE_KEY_DODGE, 20). %% 敏捷
-define(UPDATE_KEY_DAMAGE_DEEPEN, 21). %% 伤害加深
-define(UPDATE_KEY_DAMAGE_REDUCTION, 22). %% 伤害减免
-define(UPDATE_KEY_HOLY, 23). %% 神圣
-define(UPDATE_KEY_SKILL_ADD, 24). %% 技能伤害追加
-define(UPDATE_KEY_M_HIT, 25). %% 魔法命中
-define(UPDATE_KEY_M_DODGE, 26). %% 魔法闪避
-define(UPDATE_KEY_HP_RECOVER, 27). %% 生命恢复
-define(UPDATE_KEY_MP_RECOVER, 28). %% 魔法恢复
-define(UPDATE_KEY_RESURGENCE, 29). %% 死亡恢复
-define(UPDATE_KEY_DAMAGE_OFFSET, 30). %% 伤害抵消
-define(UPDATE_KEY_JADE, 31). %% 元宝
-define(UPDATE_KEY_COIN, 32). %% 金币
-define(UPDATE_KEY_GUISE_WEAPON, 33). %% 武器外观
-define(UPDATE_KEY_GUISE_CLOTHES, 34). %% 衣服外观
-define(UPDATE_KEY_SMELT, 35). %% 熔炼值
-define(UPDATE_KEY_HOOK_SCENE_ID, 36). %% 当前挂机场景id
-define(UPDATE_KEY_PASS_HOOK_SCENE_ID, 37). %% 通过挂机场景id
-define(UPDATE_KEY_HP_P, 38). %% 血量上限万分比
-define(UPDATE_KEY_MP_P, 39). %% 魔法上限万分比
-define(UPDATE_KEY_MIN_AC_P, 40). %% 最小物理攻击万分比
-define(UPDATE_KEY_MAX_AC_P, 41). %% 最大物理攻击万分比
-define(UPDATE_KEY_MIN_MAC_P, 42). %% 最小魔法攻击万分比
-define(UPDATE_KEY_MAX_MAC_P, 43). %% 最大魔法攻击万分比
-define(UPDATE_KEY_MIN_SC_P, 44). %% 最小道术攻击万分比
-define(UPDATE_KEY_MAX_SC_P, 45). %% 最大道术攻击万分比
-define(UPDATE_KEY_MIN_DEF_P, 46). %% 最小物防万分比
-define(UPDATE_KEY_MAX_DEF_P, 47). %% 最小物防万分比
-define(UPDATE_KEY_MIN_RES_P, 48). %% 最小魔防万分比
-define(UPDATE_KEY_MAX_RES_P, 49). %% 最小魔防万分比
-define(UPDATE_KEY_CRIT_P, 50). %% 暴击万分比
-define(UPDATE_KEY_CRIT_ATT_P, 51). %% 暴击伤害万分比
-define(UPDATE_KEY_HIT_P, 52). %% 准确万分比
-define(UPDATE_KEY_DODGE_P, 53). %% 敏捷万分比
-define(UPDATE_KEY_DAMAGE_DEEPEN_P, 54). %% 伤害加深万分比
-define(UPDATE_KEY_DAMAGE_REDUCTION_P, 55). %% 伤害减免万分比
-define(UPDATE_KEY_HOLY_P, 56). %% 神圣万分比
-define(UPDATE_KEY_SKILL_ADD_P, 57). %% 技能伤害追加万分比
-define(UPDATE_KEY_M_HIT_P, 58). %% 魔法命中万分比
-define(UPDATE_KEY_M_DODGE_P, 59). %% 魔法闪避万分比
-define(UPDATE_KEY_HP_RECOVER_P, 60). %% 生命恢复万分比
-define(UPDATE_KEY_MP_RECOVER_P, 61). %% 魔法恢复万分比
-define(UPDATE_KEY_RESURGENCE_P, 62). %% 死亡恢复万分比
-define(UPDATE_KEY_DAMAGE_OFFSET_P, 63). %% 伤害抵消万分比
-define(UPDATE_KEY_FIGHTINF, 64). %% 玩家战斗力
-define(UPDATE_KEY_BAG, 65). %% 玩家背包格子数
-define(UPDATE_KEY_GUISE_WING, 66). %% 玩家外观翅膀
-define(UPDATE_KEY_GUISE_PET, 67). %% 玩家外观宠物
-define(UPDATE_KEY_COIN_P, 68). %% 金币加成百分比
-define(UPDATE_KEY_EXP_P, 69). %% 经验加成百分比
-define(UPDATE_KEY_GIFT, 70). %% 礼券
-define(UPDATE_KEY_PK_VALUE, 71). %% pk值
-define(UPDATE_KEY_PK_MODE, 72). %% pk模式
-define(UPDATE_KEY_VIP, 73). %% VIP等级
-define(UPDATE_KEY_LUCK, 74). %% 幸运
-define(UPDATE_KEY_NAME_COLOUR, 75). %% 名字颜色
-define(UPDATE_KEY_CAREER_Title, 76). %% 职业称号
-define(UPDATE_KEY_FEATS, 77). %% 职业称号
-define(UPDATE_KEY_VIP_EXP, 78). %% VIP经验
-define(UPDATE_KEY_WING_STATE, 79). %% 翅膀显示状态
-define(UPDATE_KEY_PET_ATT_TYPE, 80). %% 宠物攻击模式
-define(UPDATE_KEY_PET_NUM, 81). %% 宠物数量
-define(UPDATE_KEY_GUISE_MOUNTS, 82). %% 玩家外观坐骑
-define(UPDATE_KEY_TEAM_ID, 83). %% 队伍id
-define(UPDATE_KEY_HP_MARK_VALUE, 84). %% hp印记值
-define(UPDATE_KEY_ATK_MARK_VALUE, 85). %% atk印记值
-define(UPDATE_KEY_DEF_MARK_VALUE, 86). %% def印记值
-define(UPDATE_KEY_RES_MARK_VALUE, 87). %% res印记值
-define(UPDATE_KEY_HP_MARK, 88). %% hp印记
-define(UPDATE_KEY_ATK_MARK, 89). %% atk印记
-define(UPDATE_KEY_DEF_MARK, 90). %% def印记
-define(UPDATE_KEY_RES_MARK, 91). %% res印记
-define(UPDATE_KEY_HOLY_MARK, 92). %% holy印记
-define(UPDATE_KEY_MOUNT_MARK_1, 93). %% 坐骑印记1
-define(UPDATE_KEY_MOUNT_MARK_2, 94). %% 坐骑印记2
-define(UPDATE_KEY_MOUNT_MARK_3, 95). %% 坐骑印记3
-define(UPDATE_KEY_MOUNT_MARK_4, 96). %% 坐骑印记4
-define(UPDATE_KEY_GUISE_MOUNTS_AURA, 97). %% 坐骑光环
-define(UPDATE_KEY_COLLECT_STATE, 108). %% 采集状态
-define(UPDATE_KEY_WEAPON_STATE, 109). %% 特武显示状态

-define(ALL_UPDATE_KEY, [
	?UPDATE_KEY_LV,
	?UPDATE_KEY_EXP,
	?UPDATE_KEY_CUR_HP,
	?UPDATE_KEY_CUR_MP,
	?UPDATE_KEY_HP,
	?UPDATE_KEY_MP,
	?UPDATE_KEY_MIN_AC,
	?UPDATE_KEY_MAX_AC,
	?UPDATE_KEY_MIN_MAC,
	?UPDATE_KEY_MAX_MAC,
	?UPDATE_KEY_MIN_SC,
	?UPDATE_KEY_MAX_SC,
	?UPDATE_KEY_MIN_DEF,
	?UPDATE_KEY_MAX_DEF,
	?UPDATE_KEY_MIN_RES,
	?UPDATE_KEY_MAX_RES,
	?UPDATE_KEY_CRIT,
	?UPDATE_KEY_CRIT_ATT,
	?UPDATE_KEY_HIT,
	?UPDATE_KEY_DODGE,
	?UPDATE_KEY_DAMAGE_DEEPEN,
	?UPDATE_KEY_DAMAGE_REDUCTION,
	?UPDATE_KEY_HOLY,
	?UPDATE_KEY_SKILL_ADD,
	?UPDATE_KEY_M_HIT,
	?UPDATE_KEY_M_DODGE,
	?UPDATE_KEY_HP_RECOVER,
	?UPDATE_KEY_MP_RECOVER,
	?UPDATE_KEY_RESURGENCE,
	?UPDATE_KEY_DAMAGE_OFFSET,
	?UPDATE_KEY_JADE,
	?UPDATE_KEY_COIN,
	?UPDATE_KEY_GUISE_WEAPON,
	?UPDATE_KEY_GUISE_CLOTHES,
	?UPDATE_KEY_SMELT,
	?UPDATE_KEY_HOOK_SCENE_ID,
	?UPDATE_KEY_PASS_HOOK_SCENE_ID,
	?UPDATE_KEY_HP_P,
	?UPDATE_KEY_MP_P,
	?UPDATE_KEY_MIN_AC_P,
	?UPDATE_KEY_MAX_AC_P,
	?UPDATE_KEY_MIN_MAC_P,
	?UPDATE_KEY_MAX_MAC_P,
	?UPDATE_KEY_MIN_SC_P,
	?UPDATE_KEY_MAX_SC_P,
	?UPDATE_KEY_MIN_DEF_P,
	?UPDATE_KEY_MAX_DEF_P,
	?UPDATE_KEY_MIN_RES_P,
	?UPDATE_KEY_MAX_RES_P,
	?UPDATE_KEY_CRIT_P,
	?UPDATE_KEY_CRIT_ATT_P,
	?UPDATE_KEY_HIT_P,
	?UPDATE_KEY_DODGE_P,
	?UPDATE_KEY_DAMAGE_DEEPEN_P,
	?UPDATE_KEY_DAMAGE_REDUCTION_P,
	?UPDATE_KEY_HOLY_P,
	?UPDATE_KEY_SKILL_ADD_P,
	?UPDATE_KEY_M_HIT_P,
	?UPDATE_KEY_M_DODGE_P,
	?UPDATE_KEY_HP_RECOVER_P,
	?UPDATE_KEY_MP_RECOVER_P,
	?UPDATE_KEY_RESURGENCE_P,
	?UPDATE_KEY_DAMAGE_OFFSET_P,
	?UPDATE_KEY_FIGHTINF,
	?UPDATE_KEY_BAG,
	?UPDATE_KEY_GUISE_WING,
	?UPDATE_KEY_GUISE_PET,
	?UPDATE_KEY_GIFT,
	?UPDATE_KEY_PK_VALUE,
	?UPDATE_KEY_PK_MODE,
	?UPDATE_KEY_VIP,
	?UPDATE_KEY_LUCK,
	?UPDATE_KEY_NAME_COLOUR,
	?UPDATE_KEY_CAREER_Title,
	?UPDATE_KEY_FEATS,
	?UPDATE_KEY_VIP_EXP,
	?UPDATE_KEY_WING_STATE,
	?UPDATE_KEY_PET_ATT_TYPE,
	?UPDATE_KEY_PET_NUM,
	?UPDATE_KEY_GUISE_MOUNTS,
	?UPDATE_KEY_TEAM_ID,
	?UPDATE_KEY_HP_MARK_VALUE,
	?UPDATE_KEY_ATK_MARK_VALUE,
	?UPDATE_KEY_DEF_MARK_VALUE,
	?UPDATE_KEY_RES_MARK_VALUE,
	?UPDATE_KEY_HP_MARK,
	?UPDATE_KEY_ATK_MARK,
	?UPDATE_KEY_DEF_MARK,
	?UPDATE_KEY_RES_MARK,
	?UPDATE_KEY_HOLY_MARK,
	?UPDATE_KEY_MOUNT_MARK_1,
	?UPDATE_KEY_MOUNT_MARK_2,
	?UPDATE_KEY_MOUNT_MARK_3,
	?UPDATE_KEY_MOUNT_MARK_4,
	?UPDATE_KEY_GUISE_MOUNTS_AURA,
	?UPDATE_KEY_WEAPON_STATE
]).

%% 朝向
-define(DIRECTION_UP, 1). %% 上
-define(DIRECTION_UP_RIGHT, 2). %% 右上
-define(DIRECTION_RIGHT, 3).%% 右
-define(DIRECTION_DOWN_RIGHT, 4).%% 右下
-define(DIRECTION_DOWN, 5).%% 下
-define(DIRECTION_DOWN_LEFT, 6).%% 左下
-define(DIRECTION_LEFT, 7).%% 左
-define(DIRECTION_UP_LEFT, 8).%% 左上

%% 掉落消失时间(单位秒)
-define(DROP_REMOVE_TIME, 180).

%% 掉落归属消失时间(单位秒)
-define(DROP_OWNER_CHANGE_REMOVE_TIME, 120).

%% 一天时长
-define(DAY_TIME_COUNT, 86400).
%% 一个小时时长
-define(HOUR_TIME_COUNT, 3600).

-define(BTN_TIPS_TRIGGER_SERVER, 1).%% 服务端触发
-define(BTN_TIPS_TRIGGER_CLIENT, 2).%% 客户端触发

%% ------------------------------------------------------
%% 功能开启相关
%% ------------------------------------------------------
-define(FUNCTION_STATE_OPEN, 1). %% 开启
-define(FUNCTION_STATE_CLOSE, 2). %% 关闭

-define(FUNCTION_ID_TASK_MAIN, 1). %% 主线任务
-define(FUNCTION_ID_PLAYER, 2). %% 角色
-define(FUNCTION_ID_GOODS, 3). %% 背包
-define(FUNCTION_ID_SKILL, 4). %% 技能
-define(FUNCTION_ID_GUILD, 5). %% 行会
-define(FUNCTION_ID_RELATIONSHIP, 6). %% 好友
-define(FUNCTION_ID_MAIL, 7). %% 邮件
-define(FUNCTION_ID_TEAM, 8). %% 组队
-define(FUNCTION_ID_SET, 9). %% 系统设置
-define(FUNCTION_ID_CHAT, 10). %% 聊天系统
-define(FUNCTION_ID_EQUIPS_UPGRADE, 11). %% 装备强化
-define(FUNCTION_ID_EQUIPS_BAPTIZE, 12). %% 装备洗练
-define(FUNCTION_ID_EQUIPS_FORGE, 13). %% 装备打造
-define(FUNCTION_ID_PK_MODE, 14). %% PK模式
-define(FUNCTION_ID_RECHARGE, 15). %% 首充
-define(FUNCTION_ID_SHABAKE, 16). %% 沙巴克
-define(FUNCTION_ID_TASK_ACTIVE, 17). %% 活跃任务
-define(FUNCTION_ID_ARENA, 18). %% 排位赛
-define(FUNCTION_ID_ACTIVITY, 19). %% 活动中心
-define(FUNCTION_ID_WELFARE, 20). %% 福利中心
-define(FUNCTION_ID_SHOP, 21). %% 商城
-define(FUNCTION_ID_HOOK, 22). %% 挂机
-define(FUNCTION_ID_TASK_MERIT, 23). %% 功勋任务
-define(FUNCTION_ID_WORSHIP, 24). %% 膜拜功能
-define(FUNCTION_ID_WORD_BOSS, 25). %% 世界BOSS
-define(FUNCTION_ID_INSTANCE_SINGLE, 26). %% 个人副本
-define(FUNCTION_ID_PACKAGE, 27). %% 分包下载
-define(FUNCTION_ID_GAME_HELP, 28). %% 游戏攻略
-define(FUNCTION_ID_PLAY, 29). %% 充值
-define(FUNCTION_ID_EQUIP, 30). %% 装备
-define(FUNCTION_ID_PURIFY, 31). %% 提纯
-define(FUNCTION_ID_DECOMPOSE, 32). %% 分解
-define(FUNCTION_ID_MEDAL, 33). %% 勋章

-define(FUNCTION_ID_EVERYDAY_SIGN, 34). %% 签到
-define(FUNCTION_ID_SALE, 35). %% 交易所
-define(FUNCTION_ID_TASK_DAY, 36). %% 日常任务
-define(FUNCTION_ACTIVE_WZAD, 37). %% 未知暗殿
-define(FUNCTION_ACTIVE_TLDH, 38). %% 屠龙大会
-define(FUNCTION_ACTIVE_SZWW, 39). %% 胜者为王
-define(FUNCTION_ACTIVE_SERVICE, 40).%% 开服活动

-define(FUNCTION_LOTTERY, 71).%% 转盘
-define(FUNCTION_GUILD_CHALLENGE, 72). %% 行会宣战

-define(FUNCTION_MYSTERY_SHOP, 76).%% 神秘商店

-define(FUNCTION_OPERATE_ACTIVE, 77). %% 运营活动
-define(FUNCTION_MAP_TASK, 83).%% 宝图任务
-define(FUNCTION_HOLIDAY_ACTIVE, 85). %%节日活动活动
-define(FUNCTION_SHOP_ONCE, 88).%% 一生一次活动
-define(FUNCTION_MERGE_ACTIVE, 89).%% 合服活动
-define(FUNCTION_LOTTERY_SHMJ, 90).        %% 神皇秘境抽奖

-define(FUNCTION_SEVEN_SIGN, 128). %%七天签到
%% ------------------------------------------------------
%% 场景相关
%% ------------------------------------------------------
%% 区域类型
-define(AREA_TYPE_RECTANGLE, 1). %% 矩形区域
-define(AREA_TYPE_CIRCLE, 2). %% 圆形区域
-define(AREA_TYPE_LINE, 3). %% 线性区域

%% 场景类型
-define(SCENE_TYPE_MAIN_CITY, 1). %% 城市场景
-define(SCENE_TYPE_OUTDOOR, 2). %% 普通场景
-define(SCENE_TYPE_INSTANCE, 3). %% 普通副本

%% 副本类型
-define(INSTANCE_TYPE_SINGLE, 1). %% 个人副本
-define(INSTANCE_TYPE_ARENA, 2). %% 竞技场副本
-define(INSTANCE_TYPE_MULTIPLE, 3). %% 多人副本
-define(INSTANCE_TYPE_PLOT, 4). %% 剧情副本
-define(INSTANCE_TYP_DRAGON, 5). %% 世界boss副本
-define(INSTANCE_TYP_WZAD, 6). %% 未知暗殿副本
-define(INSTANCE_TYP_SZWW, 7). %% 胜者为王副本
-define(INSTANCE_TYP_ATTACK_CITY, 8). %% 怪物攻城副本
-define(INSTANCE_TYP_SINGLE_BOSS, 9). %% 个人BOSS副本
-define(INSTANCE_CROSS_BOSS, 10). %% 跨服boss(跨服火龙1)
-define(INSTANCE_CROSS_KING, 11). %% 王城乱斗
-define(INSTANCE_CROSS_DARK, 12). %% 跨服暗殿
-define(INSTANCE_DRAGON_NATIVE, 13). %% 本服火龙
-define(INSTANCE_CROSS_BOSS2, 14). %% 跨服boss(跨服火龙2)
-define(INSTANCE_CROSS_HJZC_DATING, 15). %% 跨服幻境之城大厅
-define(INSTANCE_CROSS_HJZC, 16). %% 跨服幻境之城
-define(INSTANCE_NATIVE_HJZC_DATING, 17). %% 本服幻境之城大厅
-define(INSTANCE_NATIVE_HJZC, 18). %% 本服幻境之城
-define(INSTANCE_TYPE_PALACE, 19). %% 异化地宫


%% 副本结束状态
-define(INSTANCE_END_STATE, 1).

%% 场景活动
-define(SCENE_ACTIVITY_SHACHENG, 1). %% 沙城
-define(SCENE_ACTIVITY_PALACE, 2). %% 皇宫

%% 副本挑战结果
-define(INSTANCE_RESULT_SUCCESS, 1). %% 副本挑战成功
-define(INSTANCE_RESULT_FAIL, 2). %% 副本挑战失败

%% 格子标识
-define(GRID_FLAG_ON, 0). %% 可走点
-define(GRID_FLAG_OFF, 1). %% 不可走点
-define(GRID_FLAG_LUCENCY, 2). %% 透明点

%% 格子像素
-define(GRID_PX, 64). %% 格子像素

%% 场景活动状态
-define(ACTIVITY_STATUS_OFF, 0). %% 关闭
-define(ACTIVITY_STATUS_ON, 1). %% 开启

%% 切换场景状态
-define(CHANGE_SCENE_TYPE_CHANGE, 1). %% 主动切换场景
-define(CHANGE_SCENE_TYPE_ENTER, 2). %% 登陆进入场景
-define(CHANGE_SCENE_TYPE_REVIVE, 3). %% 复活进入场景
-define(CHANGE_SCENE_TYPE_LEAVE_INSTANCE, 4). %% 离开副本

%% 离开场景类型
-define(LEAVE_SCENE_TYPE_INITIATIVE, 1). %% 主动离开
-define(LEAVE_SCENE_TYPE_LOGOUT, 2). %% 下线离开

%% 进出副本是否满状态
-define(INSTANCE_RECOVER_NOT, 0).%% 不是满状态
-define(INSTANCE_RECOVER_IS, 1).%% 是满状态

%% 副本是否使用临时pk模式
-define(INSTANCE_TEMP_PK_MODE_NOT, 0).
-define(INSTANCE_TEMP_PK_MODE_USE, 1).

%% 变异地宫ids
-define(SCENE_PALACE_1, 32122). %% 变异地宫1层
-define(SCENE_PALACE_2, 32123). %% 变异地宫2层
-define(SCENE_PALACE_3, 32124). %% 变异地宫3层
-define(SCENE_PALACE_4, 32125). %% 变异地宫4层

%% ------------------------------------------------------
%% 挂机相关
%% ------------------------------------------------------
%% 初始挂机地图
-define(INIT_HOOK_SCENE_ID, 10001).

-define(INIT_CHALLENGE_NUM, 3).%% 每天 boos挑战次数

-define(ROUND_STATUS_INIT, 0).%% 初始
-define(ROUND_STATUS_START, 1).%% 开始
-define(ROUND_STATUS_END, 2).%% 结束

-define(RESULT_STATUS_FAIL, 0).%% 失败
-define(RESULT_STATUS_WIN, 1).%%胜利
-define(RESULT_STATUS_WAIT, 2). %% 等待

-define(HOOK_DRIVE_CLIENT, 1).%% 前端驱动
-define(HOOK_DRIVE_SERVER, 2).%% 后端驱动

-define(MAX_POWER, 20).
-define(POWER_TIME_RECOVER, 3600).
-define(MAX_BUY_POWER_TIMES, 15).

-define(REWARD_STATUS_NULL, 0).
-define(REWARD_STATUS_CAN_DRAW, 1).
-define(REWARD_STATUS_HAS_DRAW, 2).

%% ------------------------------------------------------
%% 技能相关
%% ------------------------------------------------------
%% 最短施法间隔(单位：毫秒)
-define(MIN_INTERVAL_ZHANSHI, 400). %% 战士
-define(MIN_INTERVAL_FASHI, 400). %% 法师
-define(MIN_INTERVAL_DAOSHI, 400). %% 道士

%% 技能目标
-define(SKILL_TARGET_MYSELF, 1). %% 自己
-define(SKILL_TARGET_FRIENDLY, 2). %% 友方
-define(SKILL_TARGET_HOSTILE, 3). %% 敌方

%% 技能类型
-define(SKILL_TYPE_DRIVING, 1). %% 主动
-define(SKILL_TYPE_PASSIVITY, 2). %% 被动

%% 施法距离最小误差修正
-define(MIN_SPELL_DISTANCE_AMEND, 2).

%% 技能范围
-define(SKILL_RANGE_SINGLE, single). %% 单体
-define(SKILL_RANGE_RANG, rang). %% 群攻
-define(SKILL_RANGE_CIRCLE, circle). %% 圆形
-define(SKILL_RANGE_SECTOR, sector). %% 扇形
-define(SKILL_RANGE_LINE, line). %% 直线

%% 技能伤害状态
-define(HARM_STATUS_MISS, 1). %% MISS
-define(HARM_STATUS_NORMAL, 2). %% 普通伤害
-define(HARM_STATUS_CRIT, 3). %% 暴击伤害
-define(HARM_STATUS_THORNS, 4). %% 反击伤害
-define(HARM_STATUS_MP, 5). %% 扣蓝

-define(SKILL_CMD_COST_MP, 1). %% 扣蓝
-define(SKILL_CMD_HARM, 2). %% 伤害
-define(SKILL_CMD_CURE, 3). %% 回血
-define(SKILL_CMD_BUFF, 4). %% buff
-define(SKILL_CMD_CALL_PET, 5). %% 召唤
-define(SKILL_CMD_FIRE_WALL, 6). %% 火墙
-define(SKILL_CMD_REMOVE_EFFECT, 7). %% 移除效果
-define(SKILL_CMD_MOVE, 8). %% 移动
-define(SKILL_CMD_KNOCKBACK, 9). %% 击退
-define(SKILL_CMD_TEMPT, 10). %% 诱惑

-define(TARGET_TYPE_OBJ, 1).
-define(TARGET_TYPE_POINT, 2).

-define(BUFF_OPERATE_ADD, 1).
-define(BUFF_OPERATE_UPDATE, 2).
-define(BUFF_OPERATE_DELETE, 3).

%% 烈火剑法技能特殊化
-define(SPECIAL_SKILL_ID_FIRE, 10500).
-define(SPECIAL_SKILL_ID_FIRE_1, 99900).

%% 战士烈火可替换技能
-define(SKILL_ID_GENERAL, 10100). %% 普通剑法
-define(SKILL_ID_CISHA, 10300). %% 刺杀
-define(SKILL_ID_BANYUE, 10400). %% 半月剑法
-define(SKILL_ID_KUANGFENGZHAN, 10700). %% 狂风斩

%% 战士身上有烈火buff的时候可替换的只能列表
-define(SKILL_ID_FIRE_REPLACE_LIST, [
	?SKILL_ID_GENERAL,
	?SKILL_ID_CISHA,
	?SKILL_ID_BANYUE,
	?SKILL_ID_KUANGFENGZHAN
]).

%% 技能增加熟练度触发类型
-define(SKILL_TRIGGER_1, 1). %% 使用一次增加熟练度
-define(SKILL_TRIGGER_2, 2). %% 目标受伤害增加熟练度
-define(SKILL_TRIGGER_3, 3). %% 召唤成功增加熟练度
-define(SKILL_TRIGGER_4, 4). %% 被动技能触发一次增加熟练度
-define(SKILL_TRIGGER_5, 5). %% 对怪物使用一次增加熟练度
-define(SKILL_TRIGGER_6, 6). %% 对方中状态增加熟练度

%% ------------------------------------------------------
%% buff相关
%% ------------------------------------------------------
-define(BUFF_EFFECT_DAMAGE_REDUCTION, 1). %% 减伤
-define(BUFF_EFFECT_ATTR, 2). %% 属性加成
-define(BUFF_EFFECT_FIRE, 3). %% 烈火效果
-define(BUFF_EFFECT_STUN, 4). %% 晕眩
-define(BUFF_EFFECT_POISON, 5). %% 毒
-define(BUFF_EFFECT_INVISIBILITY, 6). %% 隐身
-define(BUFF_EFFECT_MB, 7). %% 麻痹
-define(BUFF_EFFECT_CURE, 8). %% 治疗
-define(BUFF_EFFECT_EXP, 9). %% 经验加成buff
-define(BUFF_EFFECT_ATTR_PLUS, 10). %% 属性加成(计算战斗力)
-define(BUFF_EFFECT_SILENT, 11). %% 沉默

-define(STACK_RULE_NOT, 0).
-define(STACK_RULE_REPLACE, 1).
-define(STACK_RULE_STORE, 2).
-define(STACK_RULE_TIME_ACCUMULATION, 3).

%% 减异buff列表
-define(ABNORMAL_BUFF_ID_LIST, [1401, 1402, 1403, 1404, 1501, 1502, 1503, 1504]).

%% ------------------------------------------------------
%% 怪物相关/ AI相关
%% ------------------------------------------------------
-define(MONSTER_TYPE_NORMAL, 1). %% 普通怪物
-define(MONSTER_TYPE_ELITE, 2). %% 精英怪物
-define(MONSTER_TYPE_BOSS, 3). %% boss怪物

-define(MONSTER_NOTICE_NULL, 0). %% 无公告
-define(MONSTER_NOTICE_REFRESH, 1). %% 刷新公告
-define(MONSTER_NOTICE_DIE, 2). %% 死亡公告
-define(MONSTER_NOTICE_ALL, 3). %% 刷新和死亡都公告
-define(MONSTER_NOTICE_SPEC_ALL, 4). %% 特殊怪物刷新和死亡都公告
-define(MONSTER_NOTICE_COLLECTION, 5). %% 采集相关公告信息

-define(REFRESH_COUNT_DOWN_NOT, 0). %% 不需要刷新倒计时
-define(REFRESH_COUNT_DOWN, 1). %% 需要刷新倒计时

%% AI心跳
-define(AI_HEARTBEAT, 100).

%% AI状态
-define(AI_STATE_STOP, stop).
-define(AI_STATE_WAIT, wait).
-define(AI_STATE_MOVE, move).
-define(AI_STATE_DIE, die).
-define(AI_STATE_ATTACK, attack).
-define(AI_STATE_LOCK, lock).
-define(AI_STATE_STATIC, static).

%% 目标检查返回值
-define(CHECK_TARGET_CAN_ATTACK, 1). %% 可以攻击攻击
-define(CHECK_TARGET_SO_FAR, 2). %% 目标太远
-define(CHECK_TARGET_SKILL_CD, 3). %% 技能CD中
-define(CHECK_TARGET_DIE, 4). %% 目标死亡
-define(CHECK_TARGET_INVISIBILITY, 5). %% 目标无敌
-define(CHECK_TARGET_ESCAPE, 6). %% 目标逃脱

%% 检查主人返回值
-define(CHECK_OWNER_SO_FAR, 1). %% 主人远离
-define(CHECK_OWNER_NOT_FOUND, 2). %% 主人不在同一张场景
-define(CHECK_OWNER_SIDE, 3). %% 主人就在旁边

-define(ATTACK_TYPE_INITIATIVE, 1). %% 主动攻击
-define(ATTACK_TYPE_PASSIVITY, 2). %% 被动攻击
-define(ATTACK_TYPE_STATIC, 3). %% 站桩怪物
-define(ATTACK_TYPE_GUARD, 4). %% 守卫怪物
-define(ATTACK_TYPE_GUARD_2, 5). %% 守卫类型2(不打宠物)
-define(ATTACK_TYPE_STATIC_2, 6). %% 站桩(龙柱)
-define(ATTACK_TYPE_MOVE, 7). %% 优先移动到指定位置怪物(中途可攻击玩家)
-define(ATTACK_TYPE_MOVE_2, 8). %% 优先移动到指定位置怪物(只攻击龙柱)
-define(ATTACK_TYPE_COLLECTION, 9). %% 采集类怪物

-define(MONSTER_MOVE_SPEED, 80). %% 怪物移动速度(像素/秒)
-define(MONSTER_REST_TIME, 500). %% 怪物休息时间(毫秒)
-define(MONSTER_CORPSE_STAY_TIME, 5000). %% 怪物尸体消失时间(毫秒)
-define(MONSTER_VIEW_RANGE, 1). %% 怪物可视区域(格子)

-define(PET_MOVE_SPEED, 100). %% 怪物移动速度(像素/秒)
-define(PET_REST_TIME, 500). %% 宠物休息时间(毫秒)
-define(PET_CORPSE_STAY_TIME, 2000). %% 怪物尸体消失时间(毫秒)

%% ------------------------------------------------------
%% 道具相关
%% ------------------------------------------------------

-define(INIT_BAG, 50). %% 初始化背包最大格子数
-define(MAX_BAG, 100). %% 最大背包最大格子数
-define(STORE_BAG, 25). %% 仓库基础格子数
-define(EXPEND_BAG_BY_EVERYONE, 5). %% 每次扩展背包格子数
-define(EXPEND_BAG_JADE, 20). %% 扩展背包所需元宝系数

-define(NORMAL_LOCATION_TYPE, 0). %% 普通背包
-define(EQUIPS_LOCATION_TYPE, 1). %% 穿戴背包
-define(STORE_LOCATION_TYPE, 2). %% 仓库背包

-define(NOT_BIND, 0). %% 非绑定状态
-define(BIND, 1). %% 绑定状态

-define(QUALITY_WHITE, 1). %% 白色品质

%% 道具类型
-define(GOODS_TYPE_EQUIPS, 2). %% 装备类型
-define(GOODS_TYPE_VALUE, 5). %% 直接添加数值型道具
-define(GOODS_TYPE_ZHUFUYU, 1). %% 祝福玉道具类型

%% 掉落物品分段
-define(DROP_TYPE_MONEY, 1). %% 掉落属于货币类(不需要玩家身上有背包空格)
-define(DROP_TYPE_ITEM, 2). %% 掉落属于物品类(需要玩家身上有背包空格)

%% 掉落分类基数
-define(DROP_SECTION_BASE_NUM, 10000000000). %% 掉落uid分段基数

%% 掉落归属有效期(用于怪物首刀归属，并不是用于掉落物品)
-define(DROP_OWNER_EFFECTIVE_TIME, 30).

%% 道具额外属性key值
-define(EQUIPS_BAPTIZE_KEY, bap). %% 洗练属性的key
-define(EQUIPS_AIRFACT_KEY, air). %% 神器属性的key
-define(EQUIPS_LUCK_KEY, luck). %% 幸运属性的key
-define(GOODS_MAP_KEY, map). %% 藏宝图的key

%% 道具类型
-define(TYPE_EQUIPS, 2). %% 装备类型

%% 道具子类型
-define(SUBTYPE_WEAPON, 1). %% 武器
-define(SUBTYPE_CLOTHES, 2). %% 衣服
-define(SUBTYPE_HELMET, 3). %% 头盔
-define(SUBTYPE_NECKLACE, 4). %% 项链
-define(SUBTYPE_MEDAL, 5). %% 勋章
-define(SUBTYPE_BANGLE, 6). %% 手镯
-define(SUBTYPE_RING, 7). %% 戒指
-define(SUBTYPE_BELT, 8). %% 腰带
%% -define(SUBTYPE_TROUSERS,9). %% 裤子
-define(SUBTYPE_SHOES, 10). %% 鞋子
%% 11 12类型不能使用
-define(SUBTYPE_WING, 13). %% 翅膀
-define(SUBTYPE_PET, 14). %% 宠物
-define(SUBTYPE_MOUNTS, 15). %% 坐骑
%% 戒指特殊处理
-define(SUBTYPE_RING_POWER, 101). %% 力量戒指
-define(SUBTYPE_RING_DEFENSE, 102).     %% 防御戒指
-define(SUBTYPE_RING_LIFE, 103).            %% 生命戒指



-define(SUBTYPE_SP_WEAPON, 21). %% 特武
-define(SUBTYPE_SP_CLOTHES, 22). %% 特甲
-define(SUBTYPE_SP_AMULET, 23). %% 护符
-define(SUBTYPE_SP_GAITER, 24). %% 护腿
-define(SUBTYPE_SP_MASK, 25). %% 面具
-define(SUBTYPE_SP_SCARF, 26). %% 头巾
-define(SUBTYPE_SP_EARRING, 27). %% 耳环
-define(SUBTYPE_SP_PAULDRON, 28). %% 护肩
-define(SUBTYPE_SP_RING, 29). %% 特戒
%% 30类型不能使用

-define(SUBTYPE_COIN, 1). %% 金币
-define(SUBTYPE_JADE, 2). %% 元宝
-define(SUBTYPE_GIFT, 3). %% 礼券
-define(SUBTYPE_EXP, 4). %% 经验
-define(SUBTYPE_REPUTATION, 5). %% 声望
-define(SUBTYPE_FEATS, 6). %% 功勋
-define(SUBTYPE_GUILD_EXP, 7). %% 行会经验
-define(SUBTYPE_GUILD_CAPITAL, 8). %% 行会资金
-define(SUBTYPE_GUILD_CON, 9). %% 行会捐献
-define(SUBTYPE_VIP_EXP, 10). %% VIP经验
-define(SUBTYPE_HP_MARK_VALUE, 11). %% hp印记值
-define(SUBTYPE_ATK_MARK_VALUE, 12). %% atk印记值
-define(SUBTYPE_DEF_MARK_VALUE, 13). %% def印记值
-define(SUBTYPE_RES_MARK_VALUE, 14). %% res印记值

-define(GOODS_ID_JADE, 110008). %% 元宝
-define(GOODS_ID_COIN, 110009). %% 金币
-define(GOODS_ID_GIFT, 110045). %% 礼券
-define(GOODS_ID_SOUL, 110160). %% 铸魂精华
%% ------------------------------------------------------
%% 帮派相关
%% ------------------------------------------------------
%% 帮派职位
-define(HUIZHANG, 1). %% 会长
-define(FU_HUIZHANG, 2). %% 副会长
-define(ZHANGLAO, 3). %%  长老
-define(JINGYING, 4).
-define(HUIYUAN, 5).

-define(CITY_TITLE, 1001). %% 城市城主称号
-define(OFFICER_HEAD, 1). %% 城主
-define(OFFICER_SOLDIER, 4). %% 小兵－成员－无官职

-define(ACTIVE_GUILD_FEM, 4).   %% 行会秘境活动id
-define(ACTIVE_SBK_FEM, 5).        %% 沙巴克秘境活动id

-define(ACTIVE_ID_SZWW, 12).   %% 胜者为王活动id
-define(ACTIVE_ID_MONSTER_ATK, 13).   %% 怪物攻城活动id

%% ------------------------------------------------------
%% 计数器相关
%% ------------------------------------------------------

-define(EQUIPS_FORGE_UPDATE_TIMES_COUNTER, 10001). %% 装备锻造限制次数
-define(GUILD_JOIN_TIME_LIMIT_COUNTER, 10005). %% 加入帮派时间限制
-define(ARENA_CHALLENGE_LIMIT_COUNTER, 10006). %% 竞技场挑战次数
-define(COUNTER_MERIT_TASK_NUM, 10007). %% 功勋任务接取次数
-define(COUNTER_WORSHIP_NONE, 10008). %% 免费膜拜次数
-define(COUNTER_WORSHIP_JADE, 10009). %% 元宝膜拜次数
-define(COUNTER_FH_NUM, 10010). %% 原地复活次数
-define(COUNTER_DAY_TASK_NUM, 10040). %% 日常任务接取次数
-define(COUNTER_WEEK_TASK_NUM, 10044).%% 周任务接取次数

-define(COUNTER_MERIT_TASK_JADE, 10041). %% 功勋任务元宝花费次数
-define(COUNTER_DAY_TASK_JADE, 10042). %% 日常任务元宝花费次数

-define(COUNTER_MAP_TASK_NUM, 10069). %% 宝图任务取次数
-define(COUNTER_MAP_TASK_JADE, 10070). %% 宝图任务元宝完成次数


-define(COUNTER_FB_BUY_NUM, 10011). %% 副本已经购买的次数
-define(COUNTER_FB_CLEAR_RED, 10012). %% 红名清洗次数

-define(COUNTER_FIRST_CHARGE, 10021). %% 首充
-define(COUNTER_LOGIN_DAYS, 10022). %% 登录天数
-define(COUNTER_ONLINE_TIMES, 10023). %% 每日在线时长
-define(COUNTER_FIRST_CHARGE_BAG, 10037). %% 首充礼包
-define(COUNTER_EVERYDAY_SIGN_COUNT, 10038). %% 每月已签到次数
-define(COUNTER_EVERYDAY_SIGN_STATE, 10039). %% 每日签到状态
-define(COUNTER_WORLD_BOSS_TRANSFER, 10043). %% 世界boss传送



-define(COUNTER_HOOK_NUM, 10045). %% 挂机免费次数
-define(COUNTER_HOOK_BUY_NUM, 10046). %% 挂机购买次数

-define(COUNTER_KILL_PLAYER, 10058). %% 击杀玩家获得功勋限制

-define(COUNTER_BUY_MYSTERY_LIMIE, 10065). %% 神秘商人购买上限


%% ------------------------------------------------------
%% 特殊技能
%% ------------------------------------------------------

-define(SKILL_ID_MABI, 50100). %% 麻痹技能
-define(SKILL_ID_HUSHEN, 50200). %% 护身技能
-define(SKILL_ID_FUHUO, 50300). %% 护身技能
-define(SKILL_ID_SILENT, 50400). %% 沉默技能
-define(SKILL_ID_HP_SUCK, 50500). %% 吸血技能
-define(SKILL_ID_MP_SUCK, 50600). %% 扣篮技能
-define(SKILL_ID_THORNS, 50700). %% 扣篮技能
-define(SKILL_ID_ADD_MP, 50800). %% 吸蓝技能
-define(REVIVE_TYPE_REVIVE_AREA, 1). %% 复活点复活
-define(REVIVE_TYPE_INPLACE, 2). %% 原地复活


%% 玩家任务大类型
-define(TASKTYPEID1, 1). %% 主线任务
-define(TASKTYPEID2, 2). %% 活跃任务任务
-define(TASKTYPEID_MERIT, 3). %% 功勋任务
-define(TASKTYPEID_DAY, 4). %%日常任务－
-define(TASKTYPEID_WEEK, 5).%% 周任务
-define(TASKTYPEID_GUILD, 6).%% 工会任务
-define(TASKTYPEID_OTHER, 7).%% 支线任务
-define(TASKTYPEID_MAP, 8).%% 宝图任务
%% 任务完成类型
-define(TASKSORT_BATTLE, 1). %% 快速战斗
-define(TASKSORT_BOSS, 2). %% 击杀boss
-define(TASKSORT_STREN, 3). %% 强化装备--
-define(TASKSORT_BAPTIZE, 4). %% 洗练装备--
-define(TASKSORT_SMELT, 5). %% 熔炼装备--
-define(TASKSORT_FORGE, 6). %% 打造装备--
-define(TASKSORT_KILL_SCENE, 7). %% 场景击杀
-define(TASKSORT_DIALOG, 8). %% 对话任务
-define(TASKSORT_MONSTER, 9). %% 杀特定的怪物
-define(TASKSORT_HAVE_ITEM, 10). %% 拥有特定的道具
-define(TASKSORT_UP_LV, 11). %% 拥有特定的道具
-define(TASKSORT_PAST_FB, 12). %% 通关副本
-define(TASKSORT_COLLECT_ITEM, 13).%% 搜集道具
-define(TASKSORT_SCENE_GO_IN, 14).%% 进入特殊场景
-define(TASKSORT_TASKTYPE_COMPLETE, 15).%% 完成任务大类型任务
-define(TASKSORT_ARENA, 16).%% 完成排位赛
-define(TASKSORT_WORSHIP, 17).%% 完成膜拜任务
-define(TASKSORT_GUILD_FB, 18).%% 行会副本

%% 场景id
-define(SCENEID_FB_MAYA, 20001). %% 玛雅神殿id
-define(SCENEID_SHABAKE, 20015). %% 沙巴克
-define(SCENEID_MONSTER_ATK, 22001). %% 怪物攻城
%%-define(SCENEID_HJZC_DATING, 32114). %% 幻境之城大厅
%%-define(SCENEID_HJZC_FAJIAN, 32115). %% 幻境之城房间
%% ------------------------------------------------------
%% pk值相关
%% ------------------------------------------------------
-define(MAX_PK_VALUE, 100).%% pk值最大值
-define(PK_VALUE_REDUCE_INTERVAL, 18).%% pk值减少间隔

%% ------------------------------------------------------
%% 交易相关
%% ------------------------------------------------------
-define(TRADE_SPEND_JADE, 0). %% 交易花费元宝

%% ------------------------------------------------------
%% 队伍相关
%% ------------------------------------------------------
-define(MAX_TEAM_MB, 5).        %% 队伍最大成员数

%% 纪录城市的归属信息
-define(ETS_SCENE_CITY, ets_scene_city).

%% 关系类型
-define(RELATIONSHIP_FRIEND, 1). %% 好友
-define(RELATIONSHIP_BLACK, 3). %% 黑名单
-define(RELATIONSHIP_FOE, 4). %% 仇人


%% ------------------------------------------------------
%% 竞技场相关
%% ------------------------------------------------------
-define(MAX_ARENA_RANK, 10000). %% 竞技最大排名

%% 竞技场挑战次数
-define(LIMIT_CHALLENGE_COUNT, 10).
%% 竞技场副本id
-define(ARENA_INSTANCE_ID, 20017).

%% ------------------------------------------------------
%% 副本相关相关
%% ------------------------------------------------------
-define(WORLD_ACTIVE_SIGN, 10001). %% 世界活动标记

%% ------------------------------------------------------
%% 全服标记
%% ------------------------------------------------------
-define(ALL_SERVER_SIGN, 1000). %% 全服标记

%% ------------------------------------------------------
%% 商店相关
%% ------------------------------------------------------
-define(SHOP_TYPE_WANDER, 15). %% 云游商店类型

%% ------------------------------------------------------
%% 客户端104011协议数据类型  由于不全，删除这些类型
%% ------------------------------------------------------
%% -define(LOG_14011_MB, 3). %% 膜拜
%% -define(LOG_14011_GX_TASK, 4). %% 功勋任务
%% -define(LOG_14011_EVERY_TASK, 5). %% 每日任务
%% -define(LOG_14011_SALE_COST, 6). %% 交易所扣除
%% -define(LOG_14011_SALE_GET, 7). %% 交易所获得
%% -define(LOG_14011_MAP_TASK, 8). %% 宝图任务

-define(ACTIVE_SERVICE_TYPE_CHARGE_BY_EXP, 1).%% 第一天：充值送大礼
-define(ACTIVE_SERVICE_TYPE_STREN_SHOP, 2).%%强化折扣商店
-define(ACTIVE_SERVICE_TYPE_JADE_SELL, 3).%% 累计消费
-define(ACTIVE_SERVICE_TYPE_MYSTERY_SHOP_SELL, 4).%% 神秘商人累计消费
-define(ACTIVE_SERVICE_TYPE_MARK_SHOP, 5).%%印记商店
-define(ACTIVE_SERVICE_TYPE_MYSTERY_SHOP_SELL_1, 6).%%神秘商人累计消费

-define(ACTIVE_SERVICE_TYPE_CHARGE, 7).%% 累计充值 赤月紫装欢乐送
-define(ACTIVE_SERVICE_TYPE_RED, 8).%% 红包活动
-define(ACTIVE_SERVICE_TYPE_MONSTER, 9).%% 全服首杀活动


-define(ACTIVE_SERVICE_TYPE_LV, 10).%% 新区冲级送好礼
-define(ACTIVE_SERVICE_TYPE_STREN, 11).%% 强化达人还有谁
-define(ACTIVE_SERVICE_TYPE_WING, 12).%% 羽翼飞升酷炫拽
-define(ACTIVE_SERVICE_TYPE_MEDAL, 13).%% 勋章升级超值礼
-define(ACTIVE_SERVICE_TYPE_MARK, 14). %%印记等级活动
-define(ACTIVE_SERVICE_TYPE_FIGHT, 15).%% 战力提升誓比高


-define(MERGE_ACTIVE_SERVICE_TYPE_CHARGE_BY_EXP, 1).%%合服 第一天：充值送大礼
-define(MERGE_ACTIVE_SERVICE_TYPE_STREN_SHOP, 2).%%合服强化折扣商店
-define(MERGE_ACTIVE_SERVICE_TYPE_MONSTER, 9).%%合服 全服首杀活动
-define(MERGE_ACTIVE_SERVICE_TYPE_FIGHT, 15).%%合服 战力提升誓比高
-define(MERGE_ACTIVE_SERVICE_FRIST_PAY, 16).%% 合服首冲
-define(MERGE_ACTIVE_SERVICE_LOGION, 17).%% 合服登录大礼
-define(MERGE_ACTIVE_SERVICE_DOUBLE_EXP, 18).%% 合服双倍
-define(MERGE_ACTIVE_SERVICE_FRIST_SHABAKE, 19).%% 合服首次沙巴克
-define(MERGE_ACTIVE_SERVICE_LOTTERY, 20).%% 合服转盘
%% 特殊限时装备
-define(SPEC_TIMELESS_GOODS, 305010).

%% 玩家印记类型
-define(MARK_TYPE_HP, 1).
-define(MARK_TYPE_ATK, 2).
-define(MARK_TYPE_DEF, 3).
-define(MARK_TYPE_RES, 4).
-define(MARK_TYPE_HOLY, 5).
-define(MARK_TYPE_MOUNTS_1, 6).
-define(MARK_TYPE_MOUNTS_2, 7).
-define(MARK_TYPE_MOUNTS_3, 8).
-define(MARK_TYPE_MOUNTS_4, 9).

-define(STATUS_COMPLETE_NOT, 0).%%未完成
-define(STATUS_COMPLETE, 1).    %%完成
-define(STATUS_TASK_BEGIN, 10).    %%任务开始
-define(STATUS_TASK_END, 11).    %%任务结束

%% 龙柱怪物id
-define(MONSTER_ID_LONGZHU, 8210).

%% ------------------------------------------------------
%% 运营活动类型
%% ------------------------------------------------------
-define(OPERATE_ACTIVE_TYPE_1, 1). %% 运营活动类型1 文字活动
-define(OPERATE_ACTIVE_TYPE_2, 2). %% 运营活动类型2 双倍活动
-define(OPERATE_ACTIVE_TYPE_3, 3). %% 运营活动类型3 条件活动
-define(OPERATE_ACTIVE_TYPE_4, 4). %% 运营活动类型4 节日活动怪物积分
-define(OPERATE_ACTIVE_TYPE_5, 5). %% 运营活动类型5 怪物掉落活动

-define(OPERATE_ACTIVE_LIMIT_TYPE_1, 1). %% 达到等级
-define(OPERATE_ACTIVE_LIMIT_TYPE_2, 2). %% 累计充值
-define(OPERATE_ACTIVE_LIMIT_TYPE_3, 3). %% 累计在线时间
-define(OPERATE_ACTIVE_LIMIT_TYPE_4, 4). %% 累计登陆天数
-define(OPERATE_ACTIVE_LIMIT_TYPE_5, 5). %% 累计消耗元宝
-define(OPERATE_ACTIVE_LIMIT_TYPE_6, 6). %% 日常任务
-define(OPERATE_ACTIVE_LIMIT_TYPE_7, 7). %% 膜拜英雄
-define(OPERATE_ACTIVE_LIMIT_TYPE_8, 8). %% 排位赛
-define(OPERATE_ACTIVE_LIMIT_TYPE_9, 9). %% 功勋任务
-define(OPERATE_ACTIVE_LIMIT_TYPE_10, 10). %% 个人副本（经验、金币、材料）
-define(OPERATE_ACTIVE_LIMIT_TYPE_11, 11). %% 屠龙大会
-define(OPERATE_ACTIVE_LIMIT_TYPE_12, 12). %% 胜者为王
-define(OPERATE_ACTIVE_LIMIT_TYPE_13, 13). %% 神秘暗殿
-define(OPERATE_ACTIVE_LIMIT_TYPE_14, 14). %% 行会BOSS
-define(OPERATE_ACTIVE_LIMIT_TYPE_15, 15). %% 行会秘境
-define(OPERATE_ACTIVE_LIMIT_TYPE_16, 16). %% 怪物攻城
-define(OPERATE_ACTIVE_LIMIT_TYPE_17, 17). %% 宝图任务(暂时无效）
-define(OPERATE_ACTIVE_LIMIT_TYPE_18, 18). %% 节日活动怪物积分
-define(OPERATE_ACTIVE_LIMIT_TYPE_19, 19). %% 怪物掉落活动

%% 聊天类型 %% 1 世界  2 公会  3 队伍  4 私聊 5 系统 6,军团
-define(CHAT_SORT_WORD, 1).%% 世界聊天
-define(CHAT_SORT_GUILD, 2).%% 工会聊天
-define(CHAT_SORT_PLAYER, 4).%% 私聊聊天
-define(CHAT_SORT_LEGION, 6).%%军团聊天
%% 藏宝图怪清理时间
-define(TIME_CLEAR_MAP_MONSTER, 900).

%% 开服活动领取类型
-define(RECEIVE_STATE_1, 1).%% 玩家自己领取
-define(RECEIVE_STATE_2, 2).%% 服务器发送邮件
-define(RECEIVE_STATE_3, 3).%%商店类型

%% 开服活动分类类型
-define(ACTIVE_SERVICE_UI_RANK, 2).%% 开服排行榜
-define(ACTIVE_SERVICE_UI_INSIDE, 1).%% 开服活动

%% 抽奖箱抽奖类型
-define(LOTTERY_BOX_TYPE_1, 1).        %% 神皇秘境
-define(LOTTERY_BOX_TYPE_2, 2).        %% 抽奖

