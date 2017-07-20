--
-- Author: 21102585@qq.com
-- Date: 2014-11-04 18:00:46
-- 事件常量
GlobalEvent = {
	SHOW_NAVIGATION = "SHOW_NAVIGATION",  --显示导航栏
	SHOW_NAVIGATION_EQUIP_SUB = "SHOW_NAVIGATION_EQUIP_SUB", -- 显示导航栏装备二级菜单
	SHOW_TOP_NAV_BAR = "show_top_nav_bar", -- 显示顶部导航栏
	HIDE_TOP_NAV_BAR = "hide_top_nav_bar", -- 隐藏顶部导航栏
	HIDE_SCENE_LOADING = "hide_scene_loading", --隐藏加载界面
	SHOW_SCENE_LOADING = "show_scene_loading", --显示加载界面
	UPDATE_SCENE_LOADING = "UPDATE_SCENE_LOADING", --更新场景进度百分数
	SCENE_SWITCH = "scene_switch", --场景切换
	WINDOW_ADD_SCENE = "window_show", --显示窗口
	
	WINDOW_CLOSE_SCENE = "window_close",--关闭窗口
	SHOW_MESSAGE  = "showMessage",--显示文字提示信息
	SHOW_BOX = "showBox",
	SHOW_NOTICE_BOX = "showNoticeBox", --登录界面公告
	SHOW_SYSTIPS = "showSystips",--显示系统提示
	SHOW_POWERCHANGE = "showPowerChange",		--显示战斗力改变
	GET_ERROR_CODE = "getErrorCode",	--有错误码
	GET_BOSS_REFRESH_TIME = "getBossRefreshTime",	--取得boss刷新剩余时间列表
	UPDATE_FUNCTION_OPEN = "UPDATE_FUNCTION_OPEN",	--更新功能开放
	ENTER_GAME = "ENTER_GAME", -- 登陆进入游戏并且等待进度条完毕之后将会触发这个事件。
	OPEN_SIGN = "OPEN_SIGN",--签到
	SHOW_NET_LOADING = "SHOW_NET_LOADING",--显示网络加载条
	GET_SERVER_TIME = "GET_SERVER_TIME",--获取服务器时间
}

--
SceneEvent = {
	RESET_NAV_CHILD = "RESET_NAV_CHILD", --重置二级字导航
	GET_MAP_ISOPEN = "GET_MAP_ISOPEN", --获取世界地图是否开放
	SCENE_UI_HIDE = "SCENE_UI_HIDE", --场景UI是否隐藏
	UPDATE_MAP_POS = "UPDATE_MAP_POS",
	MAP_ADD_ROLE = "MAP_ADD_ROLE", --小地图添加角色
	MAP_DEL_ROLE = "MAP_DEL_ROLE", --小地图删除角色
	MAP_ROLE_POS_UPDATE = "MAP_ROLE_POS_UPDATE", --小地图角色位置更新
	MAP_ROLE_PATH_UPDATE = "MAP_ROLE_PATH_UPDATE", --小地图角色路径更新
	OPEN_NAV = "OPEN_NAV", --显示导航栏
	HIDE_NAV = "HIDE_NAV", --显示导航栏
	NPC_OPEN_DIALOG = "NPC_OPEN_DIALOG",--开启Npc对话框
	NPC_ACCEPT_FIGHT = "NPC_ACCEPT_FIGHT", --NPC接受任务成功
	SHOW_AUTO_ROAD = "SHOW_AUTO_ROAD", --显示自动寻路
	SCENE_CHANG = "SCENE_CHANG", --跳场景
	NPC_15_BUY = "NPC_15_BUY",--云旅商人

	SHOW_COLLECT_BAR = "SHOW_COLLECT_BAR",--显示采集条

	INTER_SERVICE_TIME_UPDATE = "INTER_SERVICE_TIME_UPDATE",--跨服时间更新
	BOSS_SKILL_TIPS = "BOSS_SKILL_TIPS",--boss释放技能提示
	FUNCTION_OPEN_PRIZE_TIPS = "FUNCTION_OPEN_PRIZE_TIPS",--功能开放奖励提示
	FUNCTION_OPEN_GET_PRIZE = "FUNCTION_OPEN_GET_PRIZE",--功能开放奖励提示

	HUOLONG_COPY_TIPS = "HUOLONG_COPY_TIPS",--火龙神殿杀怪数量

	UPDATE_ABERRANCE_DATA = "UPDATE_ABERRANCE_DATA",--变异地宫数据
}

MiniMapEvent = {
	UPDATE_MINIMAP_POINT = "UPDATE_MINIMAP_POINT",
}

ChangLineEvent = {
	LINE_UPDATE = "LINE_UPDATE",
}

TreasureEvent = {
	UPDATE_SHOP_LIST = "UPDATE_SHOP_LIST",
	BUY_SUCCESS = "BUY_SUCCESS",
}

ShaBaKeEvent = {
	UPDATE_HONOR_LIST = "SHABAKE_UPDATE_HONOR_LIST", --更新英雄列表
	SBK_REWARDS_INFO  = "SBK_REWARDS_INFO",          --沙巴克奖励信息
	SBK_OFFICIAL_INFO = "SBK_OFFICIAL_INFO",          --官员任命
	SBK_OFFICIAL_UDATAELEFT = "SBK_OFFICIAL_UDATAELEFT", --更新官员列表
}

--技能事件
SkillEvent = {
	UPDATE_SKILL_LIST = "UPDATE_SKILL_LIST",  --更新技能列表
	UPDATE_AUTO_GROUP_SWITCH = "UPDATE_AUTO_GROUP_SWITCH",  --更新是否可以使用自动群体技能
	UPDATE_SKILL_LIST = "UPDATE_SKILL_LIST",  --更新技能列表
	UPDATE_AUTO_ATTACK = "UPDATE_AUTO_ATTACK", --更新自动攻击
	INIT_SKILL_LIST_COMPELETE = "INIT_SKILL_LIST_COMPELETE",	--初始化技能列表完成
}
--战斗事件
FightEvent = {
	SINGLE_GAME_OVER = "single_game_over",--当前小游戏结束事件
	SINGLE_UPDATE_SCORE = "single_update_score",--当前小游戏更新积分事件

	--独立游戏战斗系统需要
	CHANG_SELECT_TAR = "CHANG_SELECT_TAR",      --战斗选择目标更改
	SHOW_MOUSE_CLICK_EFF = "SHOW_MOUSE_CLICK_EFF", --显示点击效果
	SHOW_RESURGE = "SHOW_RESURGE",                 --显示复活界面
	CHANG_SCENE = "CHANG_SCENE",      --转换场景
	HANGUP_TIME = "HANGUP_TIME",      --挂机倒计时
	HANGUP_SHOW_TIP = "HANGUP_SHOW_TIP",      
	CHANG_HANGUP_SCENE = "CHANG_HANGUP_SCENE",      --切换挂机场景
	HANGUP_REPORT = "HANGUP_REPORT",--获取离线报告
	HANGUP_CHALLENGE_NUM = "HANGUP_CHALLENGE_NUM", --boss挑战次数
	HANGUP_STATISTICS = "HANGUP_STATISTICS", --挂机统计信息
	HANGUP_ENERGY = "HANGUP_ENERGY",--挂机体力
	HANGUP_UPDATE_STAR = "HANGUP_UPDATE_STAR",--挂机更新星级
	HANGUP_UPDATE_TIMES = "HANGUP_UPDATE_TIMES",--挂机更新扫荡次数
	HANGUP_UPDATE_CHAPTER_REWARD = "HANGUP_UPDATE_CHAPTER_REWARD",--更新章节奖励
	
	PLAY_FLY_EFFECT = "play_fly_effect",--播放飞行效果
	PLAY_TOP_EFFECT = "play_role_top_effect",--播放所以角色头顶效果
	PLAY_FOOT_EFFECT = "play_role_foot_effect",--播放所以角色脚底下效果
	ADD_ROLE_SHADOW = "add_role_shadow", --添加角色阴影	
	ADD_ROLE_TOP_CONTAINER = "ADD_ROLE_TOP_CONTAINER",
	VIBRATION_SCENE = "vibration_scene",--战斗中震荡场景
	SHOW_FIGHT_RESULT = "show_fight_result",--战斗胜利失败
	ROLE_MOVE_END = "role_move_end", --角色移动结束事件
	ATTACK_MAXOFSKILL = "attack_maxofskill", --放大招
	SHOW_FIGHTUI = "show_fightUI", --显示战斗技能界面事件(战斗开始)
	PROGRESS_FIGHTUI = "progress_fightUI",--禁止战斗ui点击和cd跑动,第一场战斗结束播放人物跑动不需要跑cd和按技能 1,开启 0，禁止
	HIDE_FIGHTUI = "hide_fightUI", --隐藏战斗ui(战斗结束)

	ADD_ROLE_HURT_LAB = "ADD_ROLE_HURT_LAB", --添加角色气血伤害文本
	ADD_ROLE_HP_CONTAINER = "ADD_ROLE_HP_CONTAINER", --添加血量容器
	ADD_TEAM_ICON = "ADD_TEAM_ICON",--添加队伍标识
	ADD_UNION_ICON = "ADD_UNION_ICON", --添加阵营标识
 
}

LoginEvent = {
    START_CHECK_HEART = "START_CHECK_HEART", -- 开始心跳检查
    STOP_CHECK_HEART = "STOP_CHECK_HEART", -- 停止心跳检查
	DELECT_ROLE = "DELECT_ROLE",  --删除角色
	SOCKET_CONNECTED = "socket_connected",          --socket连接OK
	SOCKET_DISCONNECTED = "socket_disconnected",			        --socket连接关闭	
	SOCKET_CONNECT_FAILURE = "socket_connect_failure", -- socket连接失败
	LOGIN_SHOW_ACCOUNT = "LOGIN_SHOW_ACCOUNT",--显示帐号页面
	LOGIN_SHOW_REGITER = "LOGIN_SHOW_REGITER",--显示注册页面
	LOGIN_SHOW_SELROLE = "LOGIN_SHOW_SELROLE",--选择角色页面
	LOGIN_SHOW_ENTER = "LOGIN_SHOW_ENTER", ----显示登陆页面
	LOGIN_SHOW_SELSERVER = "LOGIN_SHOW_SELSERVER", ----显示选服页面

	SELF_LOGIN_VIEW = "SELF_LOGIN_VIEW",--自己登陆页面


	LOGIN_PLATEFORM_OK = "login_platForm_OK",--获取玩家ID
	LOGIN_GET_PLAYINFO = "login_get_playerinfo",--获取玩家信息
	LOGIN_REGITER = "login_regiter",--注册角色
	LOGIN_GOTO_REGITER = "login_goto_regiter",--去注册页面
	LOGIN_CHANGE = "login_change", --角色变化

	SHOW_PLAFORM = "show_plaform",--显示输入平台ID页面
}

RoleEvent = {
	UPDATE_ROLE_FIGHT_ATTR = "update_role_attr",   --更新角色战斗属性
	UPDATE_ROLE_BASE_ATTR = "update_role_base_attr",   --更新角色基础属性
	UPDATE_WEALTH = "update_role_Wealth",   --更新角色财富属性
	UPDATE_MAINROLE_ATTR = "update_mainrole_attr",	--更新主角基础属性
	UPDATE_MAINROLE_EQUIPLIST = "update_mainrole_equipList",	--更新主角装备列表
	MAINROLE_LEVEL_UP   = "mianrole_level_up",					--主角升级
	UPDATE_PKMODE = "UPDATE_PKMODE",					--PK模式
	GET_OTHER_ROLE_INFO = "get_other_role_info",		--查看其它玩家信息
	UPDATE_PET_ATT_STATES = "UPDATE_PET_ATT_STATES",--更新宠物战斗状态
	UPDATE_PET_NUM = "UPDATE_PET_NUM",--更新宠物数量
	UPDATE_HOME_NUM = "UPDATE_HOME_NUM",--更新回城石
	UPDATE_MARK_SUCCESS = "UPDATE_MARK_SUCCESS",--升级印记成功
	UPDATE_RIDE_INFO = "UPDATE_RIDE_INFO",--更新坐骑
	UPDATE_RIDE_EQUIP_INFO = "UPDATE_RIDE_EQUIP_INFO",--更新坐骑装备
	OPEN_RIDE_TAG = "OPEN_RIDE_TAG",--打开坐骑标签
	GET_RIDE_ZFINFO = "GET_RIDE_ZFINFO",--获取坐骑装备升阶祝福值

	RIDE_HONG_TIP = "RIDE_HONG_TIP",--获取坐骑装备升阶祝福值
}

BagEvent = {
	CANCEL_SELL = "cancel_sell",				--取消出售
	SEND_SELL 	= "send_sell",					--确认出售
	PROP_CHANGE = "prop_change",				--道具信息变更
	EQUIP_CHANGE = "equip_change",				--装备信息变更
	BAPTIZE_SUCCESS = "baptize_success",		--装备洗炼成功
	FORGE_REP = "forge_rep",					--收到装备锻造信息
	FUSION_SUCCESS = "fusion_success",			--合成道具成功
	ARTSWALLOW_SUCCESS = "artSwallow_success",	--神器吞噬成功
	CHANGE_EQUIP_TO_BAG = "change_equip_to_bag",--新增装备到装备背包/从装备背包中移除一件装备
	BODY_EQUIP_CHANGE = "body_equip_change",	--从身上脱下装备 / 穿上装备
	EXPAND_BAG_SUCCESS = "expand_bag_success",	--扩展背包成功
	BAG_COUNT_CHANGE = "bag_count_change",		--背包格子数改变
	NEED_JADE_REFRESH_FORGE = "needJadeRefreshForge",	--需要元宝才能刷新锻造
	STRENG_SUCCESS = "streng_success",			--强化成功
	-- GITFBOX_OPEN = "giftbox_open",				--礼包奖励
	GET_BLOOD_BAG = "get_blood_bag",			--取得血包剩余血量
	STRENG_FAIL   = "STRENG_FAIL",  				--强化失败
	QUICK_USE_CHANGE = "QUICK_USE_CHANGE",		--快速使用道具信息变更
}

StorageEvent = {
	DATA_CHANGED = "storage_data_changed"
}

MailEvent = {
	MAIL_PICK_SUCCESS = "mail_pick_success",	--领取邮件成功
	MAIL_DEL_SUCCESS = "mail_del_success",		--删除邮件成功
	MAIL_CHANGE = "mail_change",				--邮件信息改变
	MAIL_WIN_STATE_CHANGE = "mail_win_state_change",	--邮件窗口打开或关闭
}

GuildEvent = {
	JOIN_GUILD = "join_guild",				--加入公会
	EXIT_GUILD = "exit_guild",				--退出公会
	REQ_GUILD_COUNT = "req_guild_count",	--取得行会总数
	REQ_GUILD_LISTINFO = "req_guild_listInfo",--取得行会列表信息
	GUILD_DETAILED_INFO = "guild_detailed_info",--取得行会详细信息
	REQ_GUILD_MEMBER_LISTINFO = "req_guid_member_listInfo",--取得公会成员信息列表
	REQ_GUILD_MEMBER_COUNT = "req_guild_member_count",	--取得公会成员数
	REQ_GUILD_PROPOSER_LISTINFO = "req_guid_proposer_listInfo",--取得公会申请人信息列表
	REQ_GUILD_PROPOSER_COUNT = "req_guild_proposer_count",	--取得公会申请人数
	PROPOSER_AGREE = "proposer_agree",	--同意申请人入会
	PROPOSER_REFUSE = "proposer_refuse",--拒绝申请人入会
	PROPOSER_HANDLE = "proposer_handle",--已处理申请人
	REQ_APPOINT_MEMBER = "rep_appoint_member",--帮会成员职位委任
	ROLE_GUILD_INFO_CHANGE = "role_guild_info_change",--主角帮会信息改变
	REQ_GET_MEMBER_INFO = "req_get_member_info",--获取帮派成员详细信息
	GUILD_LV_CHANGE = "guild_lv_change",		--公会等级改变
	GUILD_NOTICE_CHANGE = "guild_notice_change",	--行会公告修改成功
	REQ_ENTER_GUILD_COND =  "req_enter_guild_cond",--取得入帮条件
	REQ_GUILD_DONATION_INFO = "req_guild_donation_info", --取得行会捐献状态
	REQ_REJECT_MEMBER = "req_reject_member",			--踢出行会成员
	REQ_GUILD_LOG_INFO = "rep_guild_log_info",			--取得行会日志
	RCV_ACT_GUILD_FB_INFO = "on_rcv_act_guild_fb_info", -- 获得公会活动 - 公会秘境信息
	RCV_ACT_SBK_FB_INFO = "rcv_act_sbk_fb_info", -- 获得公会活动 - 沙巴克秘境信息
	GUILD_BRIBERY_MONEY_LOG = "guild_briberymoney_log", -- 获取公会红包领取记录
	GUILD_BRIBERY_MONEY_INFO = "guild_briberymoney_info", -- 获取公会红包列表信息
	GUILD_BRIBERY_MONEY_GET = "guild_briberymoney_get", -- 领取公会红包
	GUILD_WAR_INFO = "GUILD_WAR_INFO", -- 行会宣战信息
	GUILD_CONT_CHANGE = "GUILD_CONT_CHANGE",
}


CorpsEvent = {
    JOIN_CORPS = "join_corps",				--加入军团
    EXIT_CORPS = "exit_corps",				--退出军团
	REQ_CORPS_COUNT = "req_corps_count",	--取得军团总数
	REQ_CORPS_LISTINFO = "req_corps_listInfo",  --取得军团列表信息
	CORPS_DETAILED_INFO = "corps_detailed_info",--取得军团详细信息
	REQ_CORPS_MEMBER_LISTINFO = "req_corps_member_listInfo",--取得军团成员信息列表
	REQ_CORPS_MEMBER_COUNT = "req_corps_member_count",	--取得军团成员数
	REQ_CORPS_PROPOSER_LISTINFO = "req_corps_proposer_listInfo",--取得军团申请人信息列表
	REQ_CORPS_PROPOSER_COUNT = "req_corps_proposer_count",	--取得军团申请人数
	PROPOSER_AGREE = "corps_proposer_agree",	--同意申请人入团
	PROPOSER_REFUSE = "corps_proposer_refuse",--拒绝申请人入团
	PROPOSER_HANDLE = "corps_proposer_handle",--已处理申请人
	CORPS_LV_CHANGE = "corps_lv_change",		--军团等级改变
	ROLE_CORPS_INFO_CHANGE = "role_corps_info_change",--军团信息改变
	CORPS_CONT_CHANGE = "corps_count_change",
	CORPS_NOTICE_CHANGE = "corps_notice_change",	--军团公告修改成功
	REQ_ENTER_CORPS_COND =  "req_enter_corps_cond",--取得入军条件
	REQ_APPOINT_MEMBER = "rep_corps_appoint_member",--军团成员职位委任
	REQ_REJECT_MEMBER = "req_corps_reject_member",			--踢出军团成员
}

ChatEvent = {
	CHAT_UPDATE = "CHAT_UPDATE", 			--更新聊天信息

	--GET_CHAT = "get_chat", 			--取得聊天信息
	SET_PRIVATE_CHAT = "set_private_chat", --设置私聊对象
	--CHANGE_SEND_CHANNEL = "change_send_channel",--改变发送聊天的频道
	CHAT_SEND_GOODS = "CHAT_SEND_GOODS",--发送物品
	CHAT_SEND_TEAM = "CHAT_SEND_TEAM",--发送组队
	CHAT_OPEN_FACE = "CHAT_OPEN_FACE",--
	CHAT_OPEN_BAG  = "CHAT_OPEN_BAG",
	CHAT_OPEN_ROLE = "CHAT_OPEN_ROLE",
	CHAT_SEND_FACE = "CHAT_SEND_FACE",
	CHAT_MD5_TIME  = "CHAT_MD5_TIME",--获取语音聊天md5和时间戳
	GET_CHAT_HISTORY = "get_chat_history" --历史信息
}

TradeEvent = {
	GET_B_TRADE_INFO = "get_b_trade_info", --取得对方的交易信息
	GET_FAIL_TRADE = "get_fail_trade",	  --交易失败
	GET_SUCCESS_TRADE = "get_success_trade", --交易成功
}

AutoDrugEvent = {
	AUTO_DRUG_ID_CHANGE = "auto_drug_id_change", --自动喝药设置的药品id改变
	AUTO_DRUG_DATA_CHANGE = "auto_drug_data_change", --自动喝药的本地配置改变
}

DailyTaskEvent = {
	GET_TASK_INFO = "get_task_info", --日常任务信息
	UPDATE_TASK_INFO = "update_task_info",	  --更新任务信息
	TASK_JUMP = "task_jump", --任务跳转
}

MayaEvent = {
	MAYA_GET_INFO = "maya_get_info", --日常任务信息
}

TeamEvent = {
	TEAM_INFO_CHANGED    = "te_team_info_changed",    -- 队伍信息更改
	TEAM_OPTION_CHANGED  = "te_team_option_changed",  -- 组队系统的选项更改
	JOIN_TEAM            = "te_join_team",            -- 我加入了一个队伍
	LEAVE_TEAM           = "te_leave_team",           -- 我离开了当前队伍
	DISSOLUTION_TEAM     = "te_dissolution_team",     -- 队伍被解散
	TEAM_LEAD_CHANGED    = "te_team_lead_changed",    -- 队伍的队长更改
	RECEIVE_INVITE       = "te_receive_invite",       -- 接收邀请通知
	RECEIVE_REQUEST      = "te_receive_request",      -- 接收申请请求
	GET_NEAR_PLAYER_INFO = "te_get_near_player_info", -- 获取附近玩家信息
	GET_NEAR_TEAM_INFO   = "te_get_near_team_info",   -- 获取附近团队信息
	NAV_UPDATE 			 = "te_NAV_UPDATE",-- 更新团队信息

	GET_FRIEND_LIST      = "GET_FRIEND_LIST",			--邀请界面好友列表
	GET_GUILD_MEMBER_LIST = "GET_GUILD_MEMBER_LIST",   	--邀请界面行会成员列表
	GET_CORPS_MEMBER_LIST = "GET_CORPS_MEMBER_LIST",   	--邀请界面军团成员列表
	GET_NEAR_PALER_LIST  = "GET_NEAR_PALER_LIST", 		--邀请界面附近玩家列表

	SHOW_MYTEAM          = "show_myteam",
	SHOW_NEARTEAM		 ="show_nearteam",

}

DreanlandEvent = {
	hjzc_rank_list		= "hjzc_rank_list",			-- 获取幻境之城的排名信息
	hjzc_plyaer_info	= "hjzc_plyaer_info",		-- 获取玩家幻境之城的点亮信息
}

QualifyingEvent = {
	RANK_OF_QUALIFYING  = "qe_rank_of_qualifying", -- 获取我在排位赛中的排名
	COUNT_OF_CHALLENGE  = "qe_count_of_challenge", -- 获取我当前的挑战次数
	VALUE_OF_FAME       = "qe_value_of_fame",      -- 获取排位赛声望
	LIST_OF_CHALLENGE   = "qe_list_of_challenge",  -- 获取挑战列表
	LIST_OF_TOTAL_RANK  = "qe_list_of_total_rank", -- 获取总排行
	LIST_OF_RECORD      = "qe_list_of_record",     -- 获取我的挑战记录列表
	CHALLENGE_START     = "qe_challenge_start",    -- 开始挑战事件
	CHALLENGE_RESULT    = "qe_challenge_result",   -- 挑战结束结果事件
}

CopyEvent = {
	COPY_ALLINFO = "copy_allinfo",--获取了个人副本列表信息
	COPY_UPDATESEL = "copy_udateSel",--
	COPY_UPDATECOPYTIME = "copy_udatecopytime",--更新副本次数
	COPY_ENTERCOPY = "copy_entercopyp",--更新副本次数
	COPY_TIPINFO = "COPY_TIPINFO",
	COPY_REWARD = "COPY_REWARD",
	COPY_BOSS_UPDATE = "COPY_BOSS_UPDATE",--更新个人boss副本信息
	COPY_BOSS_INFO = "COPY_BOSS_INFO",--个人boss副本界面信息
}

FriendEvent = {
	FRIEND_GETLIST = "FRIEND_GETLIST",--获取了好友列表
	FRIEND_RESEARCH = "FRIEND_RESEARCH",--搜素用户
	FRIEND_APPLYFRIEND = "FRIEND_APPLYFRIEND",--申请好友成功返回

	FRIEND_UPDATE_GOODFRIENDLIST = "FRIEND_UPDATE_GOODFRIENDLIST",
	FRIEND_UPDATE_BLACKLIST = "FRIEND_UPDATE_BLACKLIST",
	FRIEND_UPDATE_ENEMYLIST = "FRIEND_UPDATE_ENEMYLIST",
	FRIEND_UPDATE_APPLYLIST = "FRIEND_UPDATE_APPLYLIST",

}

TaskEvent = {
	NAV_UPDATE = "NAV_UPDATE",
	NAV_UPDATE_OVER = "NAV_UPDATE_OVER",
	NAV_HIDE = "NAV_HIDE",
	NAV_SHOW = "NAV_SHOW",
	ON_RCV_QUICK_FINISH_PRICE = "ON_RCV_QUICK_FINISH_PRICE",

}

WorShipEvent = {
	WSE_INFO = "WSE_INFO",
	WSE_UPDATE_INFO = "WSE_UPDATE_INFO",

}

GuideEvent = {
	GUIDE_DEMAND_EVENT = "guide_demand_event"  -- 引导需求广播事件。
}

MedalUpEvent = {
	MedalUp_UP = "MedalUp_UP"  -- 勋章升级。
}

EquipEvent = {
	
	SELECT_GOODS_SUCCESS = "SELECT_GOODS_SUCCESS", --选择物品
	COMPOSE_SUCCESS = "COMPOSE_SUCCESS",            --提纯成功
	DECOMPOSE_SUCCESS = "DECOMPOSE_SUCCESS",
	EQUIP_TIP = "EQUIP_TIP",--红点提示
	EXTENDS_SUCCESS = "EXTENDS_SUCCESS",            --继承成功
	SOUL_SUCCESS = "SOUL_SUCCESS",--铸魂成功
	BAPTIZE_SUCCESS = "BAPTIZE_SUCCESS",--洗炼成功
	BAPTIZE_LOCK_SUCCESS = "BAPTIZE_LOCK_SUCCESS",--洗炼锁定
	BAPTIZE_UNLOCK_SUCCESS = "BAPTIZE_UNLOCK_SUCCESS",--洗炼解锁
}

VipEvent = {
	VIP_STATE = "VIP_STATE",   --vip状态
	VIP_RECEIVE = "VIP_RECEIVE", --成功领取vip奖励
}

ActivityEvent = {
	RCV_ACTIVITY_INFO = "rcv_activity_info", -- 获取到活动信息
	RCV_ACTIVITY_SERVICE_INFO = "RCV_ACTIVITY_SERVICE_INFO", --获取开服活动信息
	RCV_ACTIVITY_SERVICE_REWARD = "RCV_ACTIVITY_SERVICE_REWARD",
	RCV_ACTIVITY_SERVICE_LIST = "RCV_ACTIVITY_SERVICE_LIST",
	RCV_ACTIVITY_SERVICE_SHOP_BUY = "RCV_ACTIVITY_SERVICE_SHOP_BUY"
}

RechargeEvent = {
	
	RECHARGE_LIST = "RECHARGE_LIST", --已购买过的key列表
}

LuckTurnPlateEvent = {
	TURNPLATE_GET = "TURNPLATE_GET", --转盘抽奖
	TURNPLATE_TIP_UPDATE = "TURNPLATE_TIP_UPDATE", --转盘抽奖提示更新
	TURNPLATE_TIP_INIT = "TURNPLATE_TIP_INIT", --转盘初始化
}

LuckTurnPlate2Event = {
	TURNPLATE2_GET = "TURNPLATE2_GET", --转盘抽奖
	TURNPLATE2_TIP_UPDATE = "TURNPLATE2_TIP_UPDATE", --转盘抽奖提示更新
	TURNPLATE2_TIP_INIT = "TURNPLATE2_TIP_INIT", --转盘初始化
}

ShenghuangEvent = {
	SHENGHUANG_INIT = "SHENGHUANG_INIT", --神皇初始化
	SHENGHUANG_GET_PRIZE = "SHENGHUANG_GET_PRIZE",----神皇抽奖
	SHENGHUANG_EXCHANG = "SHENGHUANG_EXCHANG",----神皇兑换
	SHENGHUANG_UPDATE_LOG = "SHENGHUANG_UPDATE_LOG",----神皇日志更新
}

LuckDrawEvent = {
	LUCKDRAW_GET = "LUCKDRAW_GET", --抽奖
	LUCKDRAW_TIP_UPDATE = "LUCKDRAW_TIP_UPDATE", --抽奖提示更新
}

DownLoadEvent = {
	
	DOWENLOAD_LIST = "DOWENLOAD_LIST", --分包奖励列表
	DOWENLOAD_REWARD_SUCCESS = "DOWENLOAD_REWARD_SUCCESS",--领取奖励成功
}

WelfareEvent = {
	CHANGE_REWARDS_STATE = "welfareevent_change_rewards_state", -- 福利奖励列表状态改变
	CHANGE_ONLINE_TIME = "welfareevent_change_online_time",     -- 玩家在线时长发生改变
	GET_FIRST_GOODS_LIST = "welfareevent_get_first_goods_list", -- 获取首冲奖励
	GET_SIGN_LIST = "GET_SIGN_LIST", -- 获取签到信息
	DO_SIGN = "DO_SIGN", -- 签到
	DO_SIGN2 = "DO_SIGN2", -- 补签
	GET_SIGN_REWARDS = "GET_SIGN_REWARDS", -- 获取签到奖励
	CHANGE_REWARDITEM_STATE = "CHANGE_REWARDITEM_STATE", -- 福利奖励状态改变

	GET_MONTHCARD = "GET_MONTHCARD", -- 领取月卡奖励
	GET_MONTHCARD_INFO = "GET_MONTHCARD_INFO", -- 月卡界面信息
}

SignEvent = {
	SIGN_INFO = "SIGN_INFO", --签到界面信息
	SIGN_UPDATE = "SIGN_UPDATE", --签到成功更新

}


GragonEvent = {
	
	GRAGON_UPDATE_INFO = "GRAGON_UPDATE_INFO",--屠龙大会信息更新
	GRAGON_OPEN_REWARD = "GRAGON_OPEN_REWARD",--屠龙大会打开结束界面
	GRAGON_ENTER 		="GRAGON_ENTER",


}

WinnerEvent = {
	
	WINNER_UPDATE_INFO = "WINNER_UPDATE_INFO",--胜者为王信息更新
	WINNER_OPEN_REWARD = "WINNER_OPEN_REWARD",--胜者为王打开结束界面
	WINNER_ENTER 		="WINNER_ENTER",

}

MonsterAttackEvent = {
	
	MONSTER_UPDATE_INFO = "MONSTER_UPDATE_INFO",--怪物攻城信息更新
	MONSTER_OPEN_REWARD = "MONSTER_OPEN_REWARD",--怪物打开结束界面
	MONSTER_ENTER 		="MONSTER_ENTER",

}

BuffEvent = {
	
	Buff_LIST = "Buff_LIST",
	Buff_INFO = "Buff_INFO",--buff信息
 

}

SecureEvent = {
	SECURE_SUCCESS = "SECURE_SUCCESS",--投保成功
}

BusinessEvent = {
	BUSINESS_INFO_LIST = "BUSINESS_INFO_LIST",--运营活动列表
	RCV_BUSINESS_REWARD = "RCV_BUSINESS_REWARD",--领取返回
}

BossEvent = {
	BOSS_DL = "BOSS_DL",--物品掉落
	BOSS_GZLIST = "BOSS_GZLIST",--关注列表
	BOSS_GZSUCCESS = "BOSS_GZSUCCESS",--关注成功
	BOSS_TIP = "BOSS_TIP",--关注推送
}

HolidayEvent = {
	HOLIDAY_INFO_LIST = "HOLIDAY_INFO_LIST",--节日活动列表
	RCV_HOLIDAY_RANK = "RCV_HOLIDAY_RANK",--排名返回
	HOLIDAY_COMPOSE_SUCCESS = "HOLIDAY_COMPOSE_SUCCESS",--合成返回
	RCV_HOLIDAY_COMPOSE = "RCV_HOLIDAY_COMPOSE",--合成返回
}

OneTimesEvent = {
	
	ONETIMES_INFO_LIST = "ONETIMES_INFO_LIST",--一生一次礼包信息列表
	GET_ONETIMES_REWARDS = "GET_ONETIMES_REWARDS",--购买一生一次礼包
}

MergeActivityEvent = {
	UPDATE_ACTIVITY_TYPE = "UPDATE_ACTIVITY_TYPE",--更新合服活动类型
	UPDATE_MERGE_ACTIVITY_DATA = "UPDATE_MERGE_ACTIVITY_DATA",--更新合服活动数据
	GET_MERGE_PRIZE_SUCCESS = "GET_MERGE_PRIZE_SUCCESS",--获取奖励成功
	UPDATE_MERGE_SHOP_DATA = "UPDATE_MERGE_SHOP_DATA",--更新限购礼包数据
}

GvgEvent = {
	GVG_CHANG_TIME = "GVG_CHANG_TIME", --GVG转换时间
	GVG_LEFT_RANK = "GVG_LEFT_RANK", --Gvg排行榜
}

UnionEvent = {
	GET_UNION_INFO_LIST = "GET_UNION_INFO_LIST", --获取玩家同盟详细信息列表
	GET_UNION_LIST = "GET_UNION_LIST", --获取玩家同盟列表
	PLAYER_INFO = "PLAYER_INFO", --获取单个玩家信息
}

ChopEvent = {
	CHOP_INFO_UP = "CHOP_INFO_UP",
}

TimeEquipEvent = {
	CHANG_MODEL = "time_equip_chang_model",
	CHANG_ATTR = "time_equip_chang_attr",
}

InvestEvent = {
	CHONGZHI = "invest_chongzhi",
	INVEST_LIST = "invest_List",
	GET_INVEST = "invest_Get",
}