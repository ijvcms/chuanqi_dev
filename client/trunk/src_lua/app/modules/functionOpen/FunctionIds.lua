--
-- Author: Alex mailto: liao131131@vip.qq.com
-- Date: 2016-01-27 15:45:28
--

-- module FunctionIds

module(...)

MAIN_TASK                = 1 -- 主线任务 ----------无
OPEN_ROLE_WIN            = 2 -- 角色 ----------打开角色窗口
OPEN_BAG_WIN             = 3 -- 背包 ----------打开背包窗口
OPEN_SKILL_WIN           = 4 -- 技能 ----------打开技能窗口
OPEN_GUILD_WIN           = 5 -- 行会 ----------打开行会窗口
OPEN_FRIEND_WIN          = 6 -- 社交（好友、 ----------打开好友窗口
OPEM_EMAIL_WIN           = 7 -- 社交（邮件） ----------打开邮件窗口
OPEN_TEAM_WIN            = 8 -- 组队 ----------打开组队窗口
OPEN_SYS_SETTING_WIN     = 9 -- 系统设置 ----------打开系统窗口
OPEN_CHAT_WIN            = 10 --  聊天系统 ----------打开聊天窗口
OPEN_STRENGTHEN_WIN      = 11 --  装备强化 ----------打开强化窗口
OPEN_WASHS_PRACTICE_WIN  = 12 --  装备洗练 ----------打开洗练窗口
OPEN_PRODU_WIN           = 13 --  装备打造 ----------打开打造窗口
OPEN_PK_MODE_VIEW        = 14 --  PK模式 ----------打开PK模式列表
OPEN_FIRST_WIN           = 15 --  首充 ----------打开首充窗口
OPEN_SHABAKE_WIN         = 16 --  沙巴克 ----------打开沙巴克窗口
OPEN_DAY_TASK_WIN        = 17 --  每日任务 ----------打开每日任务窗口
OPEN_QUALIFYING_WIN      = 18 --  排位赛 ----------打开排位赛窗口
OPEN_ACTIVITY_DAY_WIN        = 19 --  日常活动中心 ----------打开活动中心窗口
OPEN_REWARD_CENTER_WIN   = 20 --  福利中心 ----------打开福利中心窗口
OPEN_STORE_WIN           = 21 --  商城 ----------打开商城窗口
ALERT_HANG_UP            = 22 --  挂机 ----------先打开确认进入提示，再进入挂机
GOTO_FEAT_NPC            = 23 --  功勋任务 ----------自动寻路去找皇城监军7522，打开对话
GOTO_WORSHIP_NPC         = 24 --  膜拜功能 ----------自动寻路去找第一战士7523，打开对话
OPEN_WORLD_BOSS_WIN      = 25 --  世界BOSS ----------打开世界BOSS窗口
OPEN_SINGLE_FB_WIN       = 26 --  个人副本 ----------打开个人副本窗口
OPEN_DOWNLOAD_WIN        = 27 --  分包下载 ----------打开分包下载窗口
OPEN_STRATEGY_WIN        = 28 --  游戏攻略 ----------打开游戏攻略窗口
OPEN_TOP_UP_WIN          = 29 --  充值 ----------打开充值窗口
OPEN_EQUIP_SUB_MENU_VIEW = 30 --  装备 ----------打开装备2级菜单
OPEN_COMPOSE_WIN         = 31 -- 提纯 ----------打开提纯界面
OPEN_DECOMPOSE_WIN       = 32 -- 分解 ----------打开分解界面
OPEN_MEDALUP_WIN         = 33 -- 勋章 ----------打开勋章界面
OPEN_SIGN_WIN            = 34 -- 签到 ----------打开签到界面
OPEN_EXCHANGE_WIN        = 35 -- 交易所 ----------打开交易所界面
GOTO_DAILY_TASK_NPC      = 36 -- 日常任务 ----------自动寻路去找老兵7507，打开对话
OPEN_DARKHOUSE_WIN       = 37 -- 未知暗殿 ---------- 
OPEN_DRAGON_WIN			 = 38 --屠龙大会
OPEN_WINNER_WIN			 = 39 --胜者为王
OPEN_SERVICE_ACTIVITY_WIN			 = 40 --开服活动
OPEN_ACTIVITY_TIME_WIN			 = 41 --限时活动
OPEN_ACTIVITY_SPORT_WIN			 = 42 --竞技活动
--------------活动提示----------
OPEN_GUILD_BOSS_WIN			 = 43 --行会秘境
OPEN_GUILD_MJ_WIN			 = 44 --行会boss
OPEN_DRAGON_START			 = 45 --竞技活动
OPEN_DRAGON_DOING			 = 46 --竞技活动
OPEN_WINNER1_START			 = 47 --竞技活动
OPEN_WINNER1_DOING			 = 48 --竞技活动
OPEN_DARKHOUSE1_START		 = 49 --竞技活动
OPEN_DARKHOUSE1_DOING			 = 50 --竞技活动
OPEN_WINNER2_START			 = 59 --竞技活动
OPEN_WINNER2_DOING			 = 60 --竞技活动
OPEN_DARKHOUSE2_START			 = 61 --竞技活动
OPEN_DARKHOUSE2_DOING			 = 62 --竞技活动
OPEN_GUILD_BOSS_START			 = 53 --竞技活动
OPEN_GUILD_BOSS_DOING			 = 54 --竞技活动
OPEN_GUILD_MJ_START			 = 55 --竞技活动
OPEN_GUILD_MJ_DOING			 = 56 --竞技活动
OPEN_ANGPAO1			 = 63 --开服红包
OPEN_ANGPAO2			 = 64 --开服红包
OPEN_ANGPAO3			 = 65 --开服红包
OPEN_ANGPAO4			 = 66 --开服红包
OPEN_ANGPAO5			 = 67 --开服红包
OPEN_EXTENDS			 = 68 --继承
OPEN_SOUL			 = 69 --铸魂
OPEN_GUILD_BM_WIN        = 70 --行会红包
OPEN_TURN_PLATE_WIN        = 71 --转盘红包
OPEN_GUILD_WAR_WIN        = 72 --行会宣战
OPEN_MONSTER_ATTACK_WIN        = 75 --怪物攻城
OPEN_MONSTER_ATTACK_WIN_ING2        = 74 --怪物攻城(进行中)
OPEN_MONSTER_ATTACK_WIN_ING1        = 73 --怪物攻城(即将开启)
OPEN_LUCKDRRAW_WIN = 171 --抽奖

OPEN_BUSINESS_WIN        = 77 --运营活动
OPEN_EQUIPSHOW_WIN        = 78 --装备展示

OPEN_ANSWERING_WIN1   = 79--趣味答题(即将开启)

OPEN_ANSWERING_WIN2   = 82--趣味答题(进行中)

OPEN_BOSSCOPY_WIN   = 80--个人boss副本

OPEN_INTERSERVICE_WIN   = 81--跨服boss

OPEN_INTERSERVICE_DRAGON_WIN   = 84--跨服火龙boss(进行中)
OPEN_INTERSERVICE_DRAGON_WIN2   = 102--跨服火龙boss(进行中)

OPEN_INTERSERVICE_DARK_WIN   = 86--跨服暗殿boss(进行中)

OPEN_HOLIDAY_WIN   = 85--节日活动

OPEN_ONETIMES_WIN   = 88--一生一次购买活动
OPEN_MERGEACTIVITY_WIN   = 89--一生一次购买活动
OPEN_SHENGHUANGMJ_WIN   = 90--神皇密境

OPEN_KFAD_BEGIN_WIN   = 91--跨服暗殿(即将开始)
OPEN_KFAD_JXZ_WIN   = 92--跨服暗殿(进行中)

OPEN_WCLD_BEGIN_WIN   = 94--王城乱斗(即将开始)
OPEN_WCLD_JXZ_WIN   = 95--王城乱斗(进行中)

OPEN_KFAD_WIN   = 97--跨服暗殿
OPEN_KFAD_WIN2   = 98--跨服暗殿
OPEN_KFAD_WIN3   = 99--跨服暗殿
OPEN_BFAD_WIN   = 100--本服暗殿

HLSD_WIN1 = 103 --本服火龙神殿(每日)
HLSD_WIN2 = 104 --本服火龙神殿
HLSD_WIN3 = 105

HLSD_WIN11 = 109 --本服火龙神殿(周日)
HLSD_WIN12 = 110
HLSD_WIN13 = 111

OPEN_DREAMLAND_112  = 112 -- 跨服幻境之城(活动)
OPEN_DREAMLAND_113  = 113 -- 跨服幻境之城(即将开启预告, 打开WinName.INTERSERVISE, 第3个)
OPEN_DREAMLAND_114  = 114 -- 跨服幻境之城(进行中, 打开WinName.INTERSERVISE, 第3个)

OPEN_DREAMLAND_115  = 115 -- 本服幻境之城()
OPEN_DREAMLAND_116  = 116 -- 本服幻境之城()
OPEN_DREAMLAND_117  = 117 -- 本服幻境之城()

OPEN_VARIATIONPALACE_119 = 119  -- 跨服变异地宫
OPEN_VARIATIONPALACE_120 = 120  -- 跨服变异地宫即将开启
OPEN_VARIATIONPALACE_121 = 121 --跨服变异地宫进行中


KFHL_SW_JJKS = 122  --跨服火龙上午-即将开始
KFHL_SW_JXZ = 123  --跨服火龙上午-进行中

BFHL_SW_JJKS = 126  --本服火龙上午-即将开始
BFHL_SW_JXZ = 127  --本服火龙上午-进行中

KFHL_ZMSW_JJKS = 124  --跨服火龙周末上午-即将开始
KFHL_ZMSW_JXZ = 125  --跨服火龙周末上午-进行中
 

KFHLSD_WIN1 = 106 --跨服火龙神殿
KFHLSD_WIN2 = 107 --跨服火龙神殿
KFHLSD_WIN3 = 108 --跨服火龙神殿
--OPEN_EXP_DOUBLE   = 101--全服双倍

LUCKTURNPLATE2_WIN = 216 --嘉年华转盘
INVEST_WIN = 1030 --投资计划

SEVEN_LOGIN = 128  --7天登录


