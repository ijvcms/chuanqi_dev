--
-- Author: Alex mailto: liao131131@vip.qq.com
-- Date: 2016-01-15 19:40:26
--
module(..., package.seeall)

--[[
	直接填写配置表中的操作ID。
	外部模块使用常量来替代。

	确认操作
	--------
	GlobalController.guide:notifyEventWithConfirm(GUIOP.XXXXXXX)
]]

CLICK_TASK_NAVIGATE  = 10002 -- 点击任务导航栏

CLICK_BOTTOM_NAV_ROLE   = nil    -- 点击底部导航栏的角色
CLICK_BOTTOM_NAV_BAG    = 10003  -- 点击底部导航栏的背包
CLICK_BOTTOM_NAV_SKILL  = 10007  -- 点击底部导航栏的技能
CLICK_BOTTOM_NAV_EQUIP  = 10010  -- 点击底部导航栏的装备

CLICK_BOTTOM_NAV_GUILD  = 20010    -- 点击底部导航栏的公会
CLICK_BOTTOM_NAV_SOCIAL = nil    -- 点击底部导航栏的社交
CLICK_BOTTOM_NAV_TEAM   = 20008  -- 点击底部导航栏的组队
CLICK_BOTTOM_NAV_SYS_OP = 20030  -- 点击底部导航栏的设置

CLICK_BOTTOM_SUB_NAV_STRENG =   30001--武器强化
CLICK_BOTTOM_SUB_NAV_BAPTIZE =  30002--武器洗炼
CLICK_BOTTOM_SUB_NAV_COMPOSE =  30003--武器提纯
CLICK_BOTTOM_SUB_NAV_PRODU =    30004--武器打造
CLICK_BOTTOM_SUB_NAV_EXTENDS =  30005--武器继承
CLICK_BOTTOM_SUB_NAV_MEDALUP =  30006--勋章升级窗口
CLICK_BOTTOM_SUB_NAV_SOUL =     30007--武器铸魂
CLICK_BOTTOM_SUB_NAV_WING =     30008--翅膀升级窗口

CLICK_TOP_NAV_STORE        = nil -- 点击顶部导航栏的商城
CLICK_TOP_NAV_SHABAKE      = nil -- 点击顶部导航栏的沙巴克
CLICK_TOP_NAV_STRATEGY     = nil -- 点击顶部导航栏的游戏攻略
CLICK_TOP_NAV_FIRST        = nil -- 点击顶部导航栏的首冲
CLICK_TOP_NAV_HANG_UP      = 20016 -- 点击顶部导航栏的挂机
CLICK_TOP_NAV_ACTIVITY_DAY = 20011 -- 点击顶部导航栏的日常活动
CLICK_TOP_NAV_WELFARE      = 20001 -- 点击顶部导航栏的福利中心
CLICK_TOP_NAV_DOWNLOAD     = nil -- 点击顶部导航栏的分包下载
CLICK_TOP_NAV_TOP_UP       = nil -- 点击顶部导航栏的充值
CLICK_TOP_NAV_SIGN         = nil -- 点击顶部导航栏的签到
CLICK_TOP_NAV_EXCHANG      = nil -- 点击顶部导航栏的交易所

CLICK_BAG_USE_BUTTON   = 10005 -- 点击背包内右侧的使用按钮
CLICK_WIN_CLOSE_BUTTON = 10006 -- 点击窗口的关闭按钮
CLICK_SKILL_QUICK_TAG  = 10008 -- 点击技能窗口的快捷设置页卡
CLICK_REWARD_FIRST_DAT = 20002 -- 点击领取第一天奖励按钮
CLICK_NEAR_TEAM_TAG    = 20009 -- 点击组队窗口的附近队伍页卡
CLICK_ACT_QUALIFYING   = 20012 -- 点击活动中心的排位赛按钮
CLICK_ACT_FEAT_TASK    = 20014 -- 点击活动中心的功勋任务按钮
WAIT_JOIN_HANG_UP      = 20019 -- 等待进入了挂机场景
CLICK_HANG_UP_BOSS     = 20017 -- 点击挂机的BOSS模型
CLICK_CHALLENG_BOSS    = 20018 -- 点击挂机挑战BOSS按钮
CLICK_ACT_TAB_TIME     = 20022 -- 点击活动窗口里面的限时活动分类页卡
CLICK_ACT_WORLD_BOSS   = 20023 -- 点击活动中心的世界BOSS按钮
CLICK_ACT_DAILY_TASK   = 20025 -- 点击活动中心的日常任务按钮

SLIDE_SKILL_SETTING    = 10009 -- 滑动技能设置
SLIDE_QUICK_TURN       = 20020 -- 滑动右下的快捷转盘

CLICK_SYS_OP_DRUG        = 20031 --设置里面的自动喝药
CLICK_SYS_OP_PICKUP      = nil   --设置里面的拾取设置
CLICK_SYS_OP_EFFECT      = 20040 --设置里面的游戏效果

CLICK_SYS_OP_DRUG_BTN1   = 20032 --设置里面的自动喝药的第一个加按钮（上面最上面的加号）
CLICK_SYS_OP_DRUG_BTN2   = 20034 --设置里面的自动喝药的第一个加按钮（上面中间的加号）
CLICK_SYS_OP_DRUG_BTN3   = nil --设置里面的自动喝药的第一个加按钮（上面下面的加号）
CLICK_SYS_OP_DRUG_LIST   = 20033 --设置里面的自动喝药的药瓶列表

CLICK_MAIN_QUIT  = 20038 -- 点击主界面左上角的退出按钮
CLICK_MAIN_SHOES = 20039 -- 点击主界面上的飞鞋


CLICK_EQUIP_SEL_LIST    = 20050 --选择物品列表
CLICK_STRENG_OP_SEL     = 20051 --选择强化的物品
CLICK_STRENG_OP_ADD_ALL = 20052 --强化一键加入
CLICK_STRENG_OP_STRENG  = 20053 --强化

CLICK_BAPTIZE_OP_SEL        = 20054 --选择洗练的物品
CLICK_BAPTIZE_OP_BAPTIZE    = 20055 --洗练
CLICK_BAPTIZE_OP_SAVE       = 20056 --洗练保留

CLICK_WING_OP_UPGRADE       = 20057 --翅膀升级




