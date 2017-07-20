%%%-------------------------------------------------------------------
%%% @author zhengsiying
%%% @doc
%%%        自动生成文件，不要手动修改
%%% @end
%%% Created : 2016/10/12
%%%-------------------------------------------------------------------

%% ===================================================================
%% define
%% ===================================================================
-define(BTN_ACTIVITY, 1). %% 活动中心
-define(BTN_DAILY_TARGET, 2). %% 今日目标
-define(BTN_ARENA, 3). %% 排位赛
-define(BTN_TASK_MERIT, 4). %% 功勋任务
-define(BTN_WORSHIP, 5). %% 膜拜英雄
-define(BTN_INSTANCE_SINGLE, 6). %% 个人副本
-define(BTN_WELFARE, 7). %% 福利大厅
-define(BTN_LOGIN, 8). %% 连续登陆
-define(BTN_AWARD_ONLINE, 9). %% 在线奖励
-define(BTN_EQUIP, 11). %% 装备
-define(BTN_MEDAL, 12). %% 勋章
-define(BTN_MEDAL_UPGRADE, 13). %% 升级
-define(BTN_ACTIVITY_DAILY, 14). %% 日常任务
-define(BIN_GUILD, 15). %% 行会
-define(BIN_GUILD_INFO, 16). %% 行会信息
-define(BTN_GUILD_CONTRIBUTION, 17). %% 每日捐献
-define(BIN_GUILD_ACTIVE, 18). %% 行会活动
-define(BTN_GUILD_BOSS, 19). %% 行会BOSS
-define(BTN_GUILD_MJ, 20). %% 行会秘境
-define(BTN_SBK_MJ, 21). %% 沙巴克秘境
-define(BTN_GUILD_APPLY_LIST, 22). %% 申请列表
-define(BIN_SOCIAL, 23). %% 社交
-define(BTN_MAIL, 24). %% 邮件
-define(BIN_FIRST_CHARGR, 25). %% 首充
-define(BIN_PLAYER_SALE, 26). %% 交易所
-define(BTN_SALE, 27). %% 领取物品
-define(BIN_SIGN, 28). %% 每日签到
-define(BTN_SBK, 29). %% 沙巴克
-define(BIN_SBK_REWARD, 30). %% 沙巴克奖励信息
-define(BIN_VIP_BUTTON, 31). %% VIP按钮
-define(BTN_VIP_REWARD_1, 32). %% VIP1
-define(BTN_VIP_REWARD_2, 33). %% VIP2
-define(BTN_VIP_REWARD_3, 34). %% VIP3
-define(BTN_VIP_REWARD_4, 35). %% VIP4
-define(BTN_VIP_REWARD_5, 36). %% VIP5
-define(BTN_VIP_REWARD_6, 37). %% VIP6
-define(BTN_VIP_REWARD_7, 38). %% VIP7
-define(BTN_VIP_REWARD_8, 39). %% VIP8
-define(BTN_VIP_REWARD_9, 40). %% VIP9
-define(BTN_VIP_REWARD_10, 41). %% VIP10
-define(BTN_VIP_REWARD_11, 42). %% VIP11
-define(BTN_VIP_REWARD_12, 43). %% VIP12
-define(BTN_VIP_REWARD_13, 44). %% VIP13
-define(BTN_VIP_REWARD_14, 45). %% VIP14
-define(BTN_VIP_REWARD_15, 46). %% VIP15
-define(BIN_SET, 47). %% 设置
-define(BIN_AUTO_DRINK, 48). %% 自动喝药
-define(BIN_AUTO_DRINK_RED, 49). %% 红药点
-define(BIN_AUTO_DRINK_BLUE, 50). %% 蓝药点
-define(BIN_AUTO_DRINK_SUN, 51). %% 太阳水点
-define(BIN_DOWNLOAD, 52). %% 下载奖励
-define(BIN_FRIEND, 53). %% 好友
-define(BIN_FOE, 54). %% 仇人
-define(BIN_LIMIT_TIME_ACTIVE, 55). %% 限时活动
-define(BTN_ACTIVE_WZAD, 56). %% 未知暗殿
-define(BTN_ACTIVE_TLDH, 57). %% 屠龙大会
-define(BTN_ACTIVE_SZWW, 58). %% 胜者为王
-define(BTN_ACTIVE_SERVICE, 59). %% 开服活动
-define(BTN_ACTIVE_SERVICE_LV, 60). %% 等级活动
-define(BTN_ACTIVE_SERVICE_FIGHT, 61). %% 战力活动
-define(BTN_ACTIVE_SERVICE_MEDAL, 62). %% 勋章活动
-define(BTN_ACTIVE_SERVICE_WING, 63). %% 翅膀活动
-define(BTN_ACTIVE_SERVICE_STREN, 64). %% 强化活动
-define(BTN_HOOK, 65). %% 挂机
-define(BTN_HOOK_BOOS, 66). %% 挑战boss
-define(BTN_HOOK_RAIDS, 67). %% 扫荡挂机
-define(BTN_MONTH_GOODS, 68). %% 月卡奖励
-define(BTN_ACTIVE_SERVICE_CHARGE, 69). %% 累积充值98元
-define(BIN_SIGN_BTN, 70). %% 签到按钮
-define(BIN_SIGN_REWARD, 71). %% 签到奖励
-define(BIN_LEVEL_REWARD, 72). %% 等级礼包
-define(BTN_ACTIVE_SERVICE_EQUIP, 73). %% 暂未用到
-define(BTN_ACTIVE_SERVICE_BOSS, 75). %% 首杀BOSS活动
-define(BTN_ROLE, 76). %% 角色
-define(BTN_ROLE_STAMP, 77). %% 印记标签
-define(BTN_ROLE_STAMP_HP, 78). %% 生命印记
-define(BTN_ROLE_STAMP_ATK, 79). %% 攻击印记
-define(BTN_ROLE_STAMP_DEF, 80). %% 物防印记
-define(BTN_ROLE_STAMP_MDEF, 81). %% 魔防印记
-define(BTN_ROLE_STAMP_HOLY, 82). %% 神圣印记
-define(BTN_ACTIVE_MAC, 83). %% 怪物攻城
-define(BTN_GUILD_APPLY, 84). %% 行会申请按钮
-define(BTN_ACTIVE_SERVICE_MARK, 85). %% 印记活动
-define(BTN_ACTIVE_SERVICE_RANK, 86). %% 开服排行榜
-define(BTN_ACTIVE_SERVICE_INSIDE, 87). %% 开服活动（里面）
-define(BTN_LIMIT_WING, 88). %% 限时翅膀
-define(BTN_ACTIVE_SERVICE_EXP, 89). %% 1充值送大礼
-define(BTN_ACTIVE_SERVICE_STREN_SHOP, 90). %% 2强化折扣日
-define(BTN_ACTIVE_SERVICE_JADE_SELL, 91). %% 3消耗元宝送物品
-define(BTN_ACTIVE_SERVICE_MYSTERY_SHOP_SELL, 92). %% 4神秘商店回馈
-define(BTN_ACTIVE_SERVICE_MARK_SHOP, 93). %% 5印记折扣
-define(BTN_ACTIVE_SERVICE_MYSTERY_SHOP_SELL_1, 94). %% 6神秘商店回馈
-define(BTN_LEGION_TAG, 95). %% 军团标签页
-define(BTN_GUIDE_TAG, 96). %% 行会标签页
-define(BTN_LEGION_APPLY_LIST, 97). %% 军团申请红点
-define(BTN_ACTIVE_SERVICE_MERGE, 98). %% 合服总按钮
-define(BTN_ACTIVE_SERVICE_EXP_MERGE, 99). %% 合服累计充值
-define(BTN_ACTIVE_SERVICE_BOSS_MERGE, 100). %% 合服 全服首杀活动
-define(BTN_ACTIVE_SERVICE_STREN_SHOP_MERGE, 101). %% 合服超值礼包商店
-define(BTN_ACTIVE_SERVICE_FRIST_PAY_MERGE, 102). %% 合服首冲
-define(BTN_ACTIVE_SERVICE_LOGION_MERGE, 103). %% 合服登录大礼
-define(BTN_ACTIVE_WZAD2, 104). %% 神秘暗殿时间红点2
-define(BTN_ACTVE_SZWW2, 105). %% 胜者为王2
%% ===================================================================
%% record
%% ===================================================================

-record(button_tips_conf, {
	id, %% 按钮id
	name, %% 按钮说明
	macro, %% 按钮宏
	parent, %% 上级菜单id
	daily_refresh, %% 是否每日刷新
	trigger, %% 触发端
	daily_one_count %% 是否每日只显示一次
}).