--
-- Author: 21102585@qq.com
-- Date: 2014-11-06 10:32:06
-- 窗口管理器

WinLayer = {
	bg= "bg",--背景层
	main = "main",--主框架层
	game = "game",--游戏层
	guide = "guide",--引导层	
	tooltips = "tooltips",--toolTip层
	messagelyr = "messagelyr",--信息提示层
}

--窗口名称定义
WinName = {
	CHATBAGWIN = "chatBagWin",--聊天发送装备背包
	ADDITEMWIN			= "addItemWin",				-- 测试道具用
	SKILLVIEW = "skillView", --技能界面zsq
	NPCBUYWIN = "npcBuyWin", --Npc购买界面
	NPCTRANSFER = "npcTransfer", --Npc传送界面 
	NPCDIALOG = "npcDialog", --Npc对话界面
	LUCKTURNPLATEWIN = "luckTurnPlateWin", --幸运大转盘
	LUCKTURNPLATE2WIN = "luckTurnPlate2Win", --元宝大转盘
	INVESTWIN = "investWin", --投资
	LUCKDRAWWIN = "luckDrawWin", --幸运抽奖
	SHENGHUANGMJ = "ShengHuangMJWin", --神皇密境
	UNIONWIN = "unionWin", --结盟
	GVGWIN = "gvgWin",--GVG
	GVGFUHUOWIN = "gvgFuHuoWin",--GVG复活
	TREASUERWIN = "treasureWin", --神秘探宝
	CHANGLINEWIN = "changLineWin",--切线
	INTERSERVISE = "interServise",--跨服Boss 跨服活动
	COPYPRIZETIPS = "copyPrizeTips",--副本奖励提示
	COPYCOUNTDOWNVIEW = "copyCountDownView",--副本倒计时提示
	WEARTEMPORARYWINGVIEW = "wearTemporaryWingView",--临时翅膀提示页面
	WEARRIDETIPSVIEW = "wearRideTipsView",--首次穿戴坐骑
	UPGRADEWINGTIPSVIEW = "upgradeWingTipsView",--翅膀升级提示页面
	FUNCTIONOPENPRIZEVIEW = "functionOpenPrizeView",--功能开放奖励提示页面
	LOGIN = "login",
	MERGEACTIVITY = "mergeActivity", --合服活动

	TIMEACTIVITY = "timeActivityWin", --限时活动
	SEVENLOGINWIN = "sevenLoginWin", --七天登录活动
	SERVERDARKWIN = "serverDarkWin", --跨服暗殿

	HLSDWIN = "hlsdWin", --火龙神殿
	KFHLSDWIN = "kfhlsdWin", --跨服火龙神殿

	KFHLSDWEEKWIN = "kfhlsdWeekWin", --跨服火龙神殿每周

	ALERT1 = "alert1",
	MAIN = "main",
	MATCHWIN = "matchWin",
	FIGHTOVER = "fightOver",
	TRAIN = "train",
	MAP = "map",  --地图
	RESURGE = "resurge",  --复活
	SHABAKE = "shabake",  --沙巴克主界面
	SHABAKE_RULE_WIN = "shabakeRuleWin",  --沙巴克规则界面
	SHABAKE_APPOINT_WIN = "shabakeAppointWin",  --沙巴克任命官员界面
	
	MAINROLEWIN			= "mainRoleWin",			-- 主角信息 装备导航栏
	BAGWIN				= "bagWin",					-- 背包窗口
	--SMELTWIN			= "smeltWin",				-- 熔炼窗口   (已删除)
	FRIEND			= "friendWin",				-- 社交窗口
	STOREWIN			= "storeWin",				-- 商城窗口
	STRATEGYWIN			= "strategyWin",			-- 游戏攻略窗口
	CHALLENGEBOSSWIN	= "challengeBossWin",		-- 挑战boss窗口
	STORAGEWIN			= "storageWin",				-- 仓库窗口
	SYSOPTIONWIN		= "sysOptionWin",			-- 系统设置窗口
	DAILYTASKWIN		= "dailyTaskWin",			-- 每日任务窗口
    TEAMWIN				= "teamWin",				-- 组队窗口
	COPYWIN				= "copyWin",				-- 副本窗口
	--MAYAWIN				= "mayaWin",				-- 玛雅窗口(已删)
	QUALIFYINGWIN		= "qualifyingWin",			-- 排位赛窗口
	QUALIFYINGSTOREWIN  = "qualifyingStoreWin",		-- 排位赛商店窗口
	WORSHIPWIN  = "worshipWin",		-- 膜拜
	MEDALUPWIN  = "medalUp",		-- 勋章升级窗口
	WINGWIN = "wingUp", --翅膀升级窗口
	EQUIPPRODUWIN = "equipProduWin", --武器打造
	EQUIPSTRENGWIN = "equipStrengWin", --武器强化
	EQUIPDECOMPOSEWIN = "equipDecomposeWin", --武器分解
	EQUIPCOMPOSEWIN = "equipComposeWin", --武器提纯
	GUILDWIN = "guildWin", -- 公会窗口
	VIPWIN = "vipWin", -- vip窗口
	ACTIVITYWIN = "activityWin", -- 活动窗口
	RECHARGEWIN = "rechargeWin", -- 充值窗口
	DLREWARDWIN = "dlRewardWin", --分包下载奖励
	WELFAREWIN = "welfareWin", -- 福利中心窗口
	SIGNWIN = "signWin", -- 月签窗口
	EXCHANGEWIN = "exchangeView", -- 交易所窗口
	DARKHOUSEWIN = "darkHouseView", -- 未知暗殿窗口
	DRAGONWIN = "dragonView", -- 屠龙大会窗口
	WINNERWIN = "winnerView", -- 胜者为王窗口
	RANKWIN = "rankWin", -- 排行榜
	ACTIVITYSERVICERANKWIN = "activityServiceWin", -- 开服活动
	MAILWIN = "mailWin", -- 邮件窗口
	EQUIPEXTENDSWIN = "equipExtendsWin", --武器继承
	EQUIPSOULWIN = "equipSoulWin", --武器铸魂
	EQUIPBAPTIZEWIN = "equipBaptizeWin", --武器洗炼
	SECUREWIN = "secureWin", --投保系统
	GUILDWARCOMFIRMWIN = "guildWarconfirmWin",--行会宣战
	GUILDWARWIN = "guildWarWin",
	GUILDWARRESULTWIN = "guildWarResultWin",
	MONSTERATTACKWIN = "monsterAttackWin",--怪物攻城
	BUSINESSWIN = "businessWin",--运营活动
	EQUIPSHOWWIN = "equipShowWin",--装备展示
	ANSWERINGWIN = "answeringWin",--趣味答题说明窗体
	ANSWERINGMAINWIN = "answeringMainWin",--趣味答题主题
	BOSSCOPYWIN = "bossCopyWin",--个人boss副本

	HOLIDAYWIN = "holidayWin",--节日活动

	ONETIMESWIN = "oneTimesWin",--一生一次购买活动

	DREAMLANDWIN = "dreamlandWin", -- 跨服幻境之城

	DREAMLANDLOCALWIN = "dreamlandLocalWin",
	
	PRIZERANK = "prizeRank", --奖励排行

	VARIATIONPALACE = "variationpalace", --变异地宫
	
	CHAT = "chat", --聊天

	ACTIVITYOPENCOMMVIEW = "activityOpenCommView"		--活动开启通用面板
}

--窗口配置信息，key是winTag

-- winTag 窗口唯一标识
-- layer 窗口需要添加的层
-- req 窗口类的地址
WinConfig = {

	activityOpenCommView = {winTag = WinName.ACTIVITYOPENCOMMVIEW, layer = WinLayer.main, req = "app.modules.activity.view.ActivityOpenCommView", url = "resui/activityOpenCommViewWin.ExportJson", openModel = 0, closeModel = 0, isDrag = 0, closeVisible = 0, title = "", useBg = false},
	skillView = {winTag = WinName.SKILLVIEW,  layer = WinLayer.main,req = "app.modules.skill.view.SkillView",url = "",openModel = 0,closeModel=0,isDrag=0,title ="技能",useBg = true},
	npcDialog = {winTag = WinName.NPCDIALOG,  layer = WinLayer.main,req = "app.modules.npcDialog.NpcDialogWin",url = "resui/npcspeakWin_1.ExportJson",openModel = 0,closeModel=0,isDrag=0,closeVisible = 1,title ="",useBg = false},
	copyPrizeTips = {winTag = WinName.COPYPRIZETIPS,  layer = WinLayer.main,req = "app.modules.mainUI.CopyPrizeView",url = "resui/storyInstanceWin.ExportJson",openModel = 0,closeModel=0,isDrag=0,closeVisible = 0,title ="",useBg = false},
	copyCountDownView = {winTag = WinName.COPYCOUNTDOWNVIEW,  layer = WinLayer.main,req = "app.modules.mainUI.CopyCountDownView",url = "resui/countDownWin.ExportJson",openModel = 0,closeModel=0,isDrag=0,closeVisible = 0,title ="",useBg = false},
	wearTemporaryWingView = {winTag = WinName.WEARTEMPORARYWINGVIEW,  layer = WinLayer.guide,req = "app.modules.wingUp.WearTemporaryWingView",url = "resui/timewingWin_1.ExportJson",openModel = 0,closeModel=0,isDrag=0,closeVisible = 0,title ="",useBg = false},
	wearRideTipsView = {winTag = WinName.WEARRIDETIPSVIEW,  layer = WinLayer.guide,req = "app.modules.mainUI.WearRideTipsView",url = "resui/tipsGetMount.ExportJson",openModel = 0,closeModel=0,isDrag=0,closeVisible = 0,title ="",useBg = false},
	mergeActivity = {winTag = WinName.MERGEACTIVITY,  layer = WinLayer.guide,req = "app.modules.mergeActivity.MergeActivityWin",url = "resui/mergeActivityWin.ExportJson",openModel = 0,closeModel=0,isDrag=0,closeVisible = 0,title ="合服活动",useBg = true},
	ShengHuangMJWin = {winTag = WinName.SHENGHUANGMJ,  layer = WinLayer.guide,req = "app.modules.shenghuangmj.ShengHuangMJWin",url = "resui/shenhuangmijingWin.ExportJson",openModel = 0,closeModel=0,isDrag=0,closeVisible = 0,title ="",useBg = false},
	unionWin = {winTag = WinName.UNIONWIN,  layer = WinLayer.guide,req = "app.modules.union.UnionWin",url = "resui/guildUnionWin.ExportJson",openModel = 0,closeModel=0,isDrag=0,closeVisible = 0,title ="",useBg = false},
	gvgWin = {winTag = WinName.GVGWIN,  layer = WinLayer.guide,req = "app.modules.gvg.GvgWin",url = "resui/gvgWin.ExportJson",openModel = 0,closeModel=0,isDrag=0,closeVisible = 0,title ="",useBg = false},
	gvgFuHuoWin = {winTag = WinName.GVGFUHUOWIN,  layer = WinLayer.guide,req = "app.modules.gvg.GvgFuHuoWin",url = "resui/gvgReviveWin.ExportJson",openModel = 0,closeModel=0,isDrag=0,closeVisible = 0,title ="",useBg = false},
	timeActivityWin = {winTag = WinName.TIMEACTIVITY,  layer = WinLayer.guide,req = "app.modules.timeActivity.TimeActivityWin",url = "resui/activityLimitWin.ExportJson",openModel = 0,closeModel=0,isDrag=0,closeVisible = 0,title ="限时活动",useBg = true},
	prizeRank = {winTag = WinName.PRIZERANK,  layer = WinLayer.guide,req = "app.modules.rank.PrizeRank",url = "resui/serverDreamlandRank.ExportJson",openModel = 0,closeModel=0,isDrag=0,closeVisible = 0,title ="",useBg = false},

	sevenLoginWin = {winTag = WinName.SEVENLOGINWIN,  layer = WinLayer.guide,req = "app.modules.welfare.view.SevenLoginWin",url = "resui/sevenDayWin.ExportJson",openModel = 0,closeModel=0,isDrag=0,closeVisible = 0,title ="",useBg = false},
	serverDarkWin = {winTag = WinName.SERVERDARKWIN,  layer = WinLayer.guide,req = "app.modules.interService.ServerDarkWin",url = "resui/serverBossItem2.ExportJson",openModel = 0,closeModel=0,isDrag=0,closeVisible = 0,title ="",useBg = false},
	hlsdWin = {winTag = WinName.HLSDWIN,  layer = WinLayer.guide,req = "app.modules.interService.HlsdWin",url = "resui/serverBossItem5.ExportJson",openModel = 0,closeModel=0,isDrag=0,closeVisible = 0,title ="",useBg = false},
	kfhlsdWin = {winTag = WinName.KFHLSDWIN,  layer = WinLayer.guide,req = "app.modules.interService.KfHlsdWin",url = "resui/serverBossItem4.ExportJson",openModel = 0,closeModel=0,isDrag=0,closeVisible = 0,title ="",useBg = false},
	kfhlsdWeekWin = {winTag = WinName.KFHLSDWEEKWIN,  layer = WinLayer.guide,req = "app.modules.interService.ServerDragonView",url = "resui/serverBossItem.ExportJson",openModel = 0,closeModel=0,isDrag=0,closeVisible = 0,title ="",useBg = false},
	--跨服幻境之城
	dreamlandWin = {winTag = WinName.DREAMLANDWIN ,nextWinTag = "",layer = WinLayer.guide,req = "app.modules.dreamland.view.DreamlandWin",url = "resui/serverBossItem3.ExportJson",openModel = 0,closeModel=0,isDrag=0,title ="",useBg = false},
	--app.modules.dreamland.view.DreamlandWin
	dreamlandLocalWin = {winTag = WinName.DREAMLANDLOCALWIN ,nextWinTag = "",layer = WinLayer.guide,req = "app.modules.dreamland.view.DreamlandLocalWin",url = "resui/serverBossItem6.ExportJson",openModel = 0,closeModel=0,isDrag=0,title ="",useBg = false},

	--跨服变异地宫
    variationpalace = {winTag = WinName.VARIATIONPALACE ,nextWinTag = "",layer = WinLayer.guide,req = "app.modules.variationpalace.view.VariationPalaceWin",url = "resui/serverBossItem7.ExportJson",openModel = 0,closeModel=0,isDrag=0,title ="",useBg = false},

	upgradeWingTipsView = {winTag = WinName.UPGRADEWINGTIPSVIEW,  layer = WinLayer.guide,req = "app.modules.wingUp.UpgradeWingTipsView",url = "resui/timewingWin_2.ExportJson",openModel = 0,closeModel=0,isDrag=0,closeVisible = 0,title ="",useBg = false},
	functionOpenPrizeView = {winTag = WinName.FUNCTIONOPENPRIZEVIEW,  layer = WinLayer.guide,req = "app.modules.functionOpen.view.FunctionOpenPrizeView",url = "resui/functionTipsWin.ExportJson",openModel = 0,closeModel=0,isDrag=0,closeVisible = 0,title ="",useBg = false},
	interServise = {winTag = WinName.INTERSERVISE,  layer = WinLayer.guide,req = "app.modules.interService.InterServiseWin",url = "resui/serverBossWin2.ExportJson",openModel = 0,closeModel=0,isDrag=0,closeVisible = 0,title ="跨服",useBg = true},
	luckTurnPlateWin = {winTag = WinName.LUCKTURNPLATEWIN,  layer = WinLayer.main,req = "app.modules.luckTurnPlate.luckTurnPlateWin",url = "resui/luckTurnPlateWin.ExportJson",openModel = 0,closeModel=0,isDrag=0,closeVisible = 0,title ="",useBg = false},
	luckTurnPlate2Win = {winTag = WinName.LUCKTURNPLATE2WIN,  layer = WinLayer.main,req = "app.modules.luckTurnPlate2.luckTurnPlate2Win",url = "resui/luckTurnPlateWin2.ExportJson",openModel = 0,closeModel=0,isDrag=0,closeVisible = 0,title ="",useBg = false},
	
	investWin = {winTag = WinName.INVESTWIN,  layer = WinLayer.main,req = "app.modules.invest.InvestWin",url = "resui/investWin.ExportJson",openModel = 0,closeModel=0,isDrag=0,closeVisible = 0,title ="",useBg = false},
	
	luckDrawWin = {winTag = WinName.LUCKDRAWWIN,  layer = WinLayer.main,req = "app.modules.luckDraw.LuckDrawWin",url = "resui/goldTurnPlateWin.ExportJson",openModel = 0,closeModel=0,isDrag=0,closeVisible = 0,title ="",useBg = false},
	treasureWin = {winTag = WinName.TREASUERWIN,  layer = WinLayer.guide,req = "app.modules.treasure.TreasureWin",url = "resui/treasureWin.ExportJson",openModel = 0,closeModel=0,isDrag=0,closeVisible = 0,title ="秘境寻宝",useBg = true},
	changLineWin = {winTag = WinName.CHANGLINEWIN,  layer = WinLayer.main,req = "app.modules.changLine.ChangLineWin",url = "resui/changeLineWin.ExportJson",openModel = 0,closeModel=0,isDrag=0,closeVisible = 0,title ="",useBg = false},
	npcTransfer = {winTag = WinName.NPCTRANSFER,  layer = WinLayer.main,req = "app.modules.npcDialog.NpcTransfer",url = "resui/npctransmitWin_1.ExportJson",openModel = 0,closeModel=0,isDrag=0,title ="",useBg = false},
	npcBuyWin = {winTag = WinName.NPCBUYWIN,  layer = WinLayer.main,req = "app.modules.npcDialog.NpcBuyWin",url = "resui/npcshopWin_1.ExportJson",openModel = 0,closeModel=0,isDrag=0,title ="小商店",useBg = true},
	worshipWin = {winTag = WinName.WORSHIPWIN,  layer = WinLayer.guide,req = "app.modules.worship.view.WorShipView",url = "resui/worshipWin_1.ExportJson",openModel = 0,closeModel=0,isDrag=0,title ="",useBg = false},
	medalUp = {winTag = WinName.MEDALUPWIN,  layer = WinLayer.main,req = "app.modules.medalUp.MedalUpView",url = "resui/medalUpWin_1.ExportJson",openModel = 0,closeModel=0,isDrag=0,title ="勋章",useBg = true},
    wingUp = {winTag = WinName.WINGWIN,  layer = WinLayer.main,req = "app.modules.wingUp.WingUpView",url = "resui/WingWin.ExportJson",openModel = 0,closeModel=0,isDrag=0,title ="翅膀",useBg = true},
	map = {winTag = WinName.MAP,  layer = WinLayer.guide,req = "app.modules.map.MapView",url = "resui/worldMap_1.ExportJson",openModel = 0,closeModel=0,isDrag=0,title ="地图",useBg = true},
	resurge = {winTag = WinName.RESURGE,  layer = WinLayer.messagelyr,req = "app.modules.fight.view.FightResurgeView",url = "",openModel = 0,closeModel=0,isDrag=0,title =""},
	shabake = {winTag = WinName.SHABAKE,  layer = WinLayer.messagelyr,req = "app.modules.shabake.ShaBaKeWin",url = "resui/shabakeWin.ExportJson",openModel = 0,closeModel=0,isDrag=0,title ="沙城争霸",useBg = true},
	shabakeRuleWin = {winTag = WinName.SHABAKE_RULE_WIN,  layer = WinLayer.messagelyr,req = "app.modules.shabake.ShaBaKeRuleWin",url = "resui/shabakeruleWin.ExportJson",openModel = 0,closeModel=0,isDrag=0,title =""},
	shabakeAppointWin = {winTag = WinName.SHABAKE_APPOINT_WIN,  layer = WinLayer.messagelyr,req = "app.modules.shabake.ShaBaKeAppointWin",url = "resui/shabakepositionWin.ExportJson",openModel = 0,closeModel=0,isDrag=0,title ="任命",useBg = true},
	
	login = {winTag = "login",  layer = WinLayer.storyDlg,req = "app.modules.login.view.LoginView",url = "res/ui/pnlDemoBtn.json",openModel = 1,closeModel=1},
	alert1 = {winTag = WinName.ALERT1,  layer = WinLayer.messagelyr,req = "app.gameui.message.AlertTipView1",url = "",openModel = 1,closeModel=1,},
	matchWin = {winTag = WinName.MATCHWIN ,layer = WinLayer.main,req = "app.modules.fight.MatchWin",url = "",closeModel=1,isDrag=0,title ="匹配界面"},
	fightOver = {winTag = WinName.FIGHTOVER ,nextWinTag = WinName.MAIN,layer = WinLayer.main,req = "app.modules.fight.FightOverWin",url = "",openModel = 0,closeModel=0,isDrag=0,title ="战斗结束界面"},
	train = {winTag = WinName.TRAIN ,nextWinTag = WinName.MAIN,layer = WinLayer.main,req = "app.modules.train.trainWin",url = "",openModel = 1,closeModel=1,isDrag=0,title ="训练界面"},
	
	mainRoleWin = {winTag = WinName.MAINROLEWIN ,nextWinTag = "",layer = WinLayer.main,req = "app.modules.role.view.MainRoleWin",url = "resui/roleWin.ExportJson",openModel = 0,closeModel=0,isDrag=0,title ="角  色",closeVisible=0,useBg = true},
	bagWin = {winTag = WinName.BAGWIN ,nextWinTag = "",layer = WinLayer.main,req = "app.modules.bag.view.bagWin",url = "resui/bagWin.ExportJson",openModel = 0,closeModel=0,isDrag=0,title ="背包",useBg = true},
	--smeltWin = {winTag = WinName.SMELTWIN ,nextWinTag = "",layer = WinLayer.main,req = "app.modules.equip.view.smeltWin",url = "resui/smeltWin.ExportJson",openModel = 0,closeModel=0,isDrag=0,title =""},
	addItemWin = {winTag = WinName.ADDITEMWIN ,nextWinTag = "",layer = WinLayer.main,req = "app.modules.bag.view.addItemWin",url = "resui/addItemWin.ExportJson",openModel = 0,closeModel=0,isDrag=0,title =""},
	friendWin = {winTag = WinName.FRIEND ,nextWinTag = "",layer = WinLayer.main,req = "app.modules.social.view.FriendView",url = "resui/friendUI.ExportJson",openModel = 0,closeModel=0,isDrag=0,title ="社  交",useBg = true},
	storeWin = {winTag = WinName.STOREWIN ,nextWinTag = "",layer = WinLayer.guide,req = "app.modules.store.view.storeWin",url = "resui/storeWin.ExportJson",openModel = 0,closeModel=0,isDrag=0,title ="商城",useBg = true},
	strategyWin = {winTag = WinName.STRATEGYWIN ,nextWinTag = "",layer = WinLayer.main,req = "app.modules.strategy.view.StrategyView",url = "resui/strategyWin.ExportJson",openModel = 0,closeModel=0,isDrag=0,title ="攻略",useBg = true},
	challengeBossWin = {winTag = WinName.CHALLENGEBOSSWIN ,nextWinTag = "",layer = WinLayer.guide,req = "app.modules.worldBoss.view.BossView",url = "resui/bossWin.ExportJson",openModel = 0,closeModel=0,isDrag=0,title ="BOSS",useBg = true},
	storageWin = {winTag = WinName.STORAGEWIN ,nextWinTag = "",layer = WinLayer.main,req = "app.modules.storage.view.StorageWin",url = "resui/storageWin.ExportJson",openModel = 0,closeModel=0,isDrag=0,title ="仓库",useBg = true},
	dailyTaskWin = {winTag = WinName.DAILYTASKWIN ,nextWinTag = "",layer = WinLayer.guide,req = "app.modules.dailyTask.view.DailyTaskView",url = "resui/goalWin_1.ExportJson",openModel = 0,closeModel=0,isDrag=0,title ="今日目标",useBg = true},
	copyWin = {winTag = WinName.COPYWIN ,nextWinTag = "",layer = WinLayer.guide,req = "app.modules.copy.view.CopyView",url = "resui/fubenWin_1.ExportJson",openModel = 0,closeModel=0,isDrag=0,title ="个人副本",useBg = true},
	teamWin = {winTag = WinName.TEAMWIN ,nextWinTag = "",layer = WinLayer.guide,req = "app.modules.team.view.TeamWin",url = "resui/teamWin.ExportJson",openModel = 0,closeModel=0,isDrag=0,title ="组队",useBg = true},
	sysOptionWin = {winTag = WinName.SYSOPTIONWIN ,nextWinTag = "",layer = WinLayer.main,req = "app.modules.sysOption.view.SysOptionWin",url = "resui/sysOptionWin.ExportJson",openModel = 0,closeModel=0,isDrag=0,title ="设置",useBg = true},
	--mayaWin = {winTag = WinName.MAYAWIN ,nextWinTag = "",layer = WinLayer.guide,req = "app.modules.maya.view.MayaView",url = "resui/maya.ExportJson",openModel = 0,closeModel=0,isDrag=0,title =""},
	qualifyingWin = {winTag = WinName.QUALIFYINGWIN ,nextWinTag = "",layer = WinLayer.guide,req = "app.modules.qualifying.view.QualifyingWin",url = "resui/qualifyingWin.ExportJson",openModel = 0,closeModel=0,isDrag=0,title ="排位赛",useBg = true},
	qualifyingStoreWin = {winTag = WinName.QUALIFYINGSTOREWIN ,nextWinTag = "",layer = WinLayer.guide,req = "app.modules.qualifying.view.QualifyingStoreWin",url = "resui/qualifyingStoreWin.ExportJson",openModel = 0,closeModel=0,isDrag=0,title ="商店",useBg = true},
	guildWin = {winTag = WinName.GUILDWIN ,nextWinTag = "",layer = WinLayer.main,req = "app.modules.guild.view.GuildWin",url = "resui/guildWin.ExportJson",openModel = 0,closeModel=0,isDrag=0,title ="帮会",useBg = true},

	equipBaptizeWin = {winTag = WinName.EQUIPBAPTIZEWIN ,nextWinTag = "",layer = WinLayer.main,req = "app.modules.equip.view.EquipBaptizeView",url = "resui/equipNewbaptize.ExportJson",openModel = 0,closeModel=0,isDrag=0,title ="洗练",useBg = true},
	equipSoulWin = {winTag = WinName.EQUIPSOULWIN ,nextWinTag = "",layer = WinLayer.main,req = "app.modules.equip.view.EquipSoulView",url = "resui/equipSoulWin.ExportJson",openModel = 0,closeModel=0,isDrag=0,title ="铸魂",useBg = true},
	equipExtendsWin = {winTag = WinName.EQUIPEXTENDSWIN ,nextWinTag = "",layer = WinLayer.main,req = "app.modules.equip.view.EquipExtendsView",url = "resui/inheritanceWin.ExportJson",openModel = 0,closeModel=0,isDrag=0,title ="继承",useBg = true},
	equipProduWin = {winTag = WinName.EQUIPPRODUWIN ,nextWinTag = "",layer = WinLayer.main,req = "app.modules.equip.view.EquipProduView",url = "resui/productionWin.ExportJson",openModel = 0,closeModel=0,isDrag=0,title ="打造",useBg = true},
	equipStrengWin = {winTag = WinName.EQUIPSTRENGWIN ,nextWinTag = "",layer = WinLayer.main,req = "app.modules.equip.view.EquipStrengView",url = "resui/strengthenWin.ExportJson",openModel = 0,closeModel=0,isDrag=0,title ="强化",useBg = true},
	equipDecomposeWin = {winTag = WinName.EQUIPDECOMPOSEWIN ,nextWinTag = "",layer = WinLayer.main,req = "app.modules.equip.view.EquipDecomposeView",url = "resui/equipTipsWin2.ExportJson",openModel = 0,closeModel=0,isDrag=0,title ="分解",useBg = true},
	equipComposeWin = {winTag = WinName.EQUIPCOMPOSEWIN ,nextWinTag = "",layer = WinLayer.main,req = "app.modules.equip.view.EquipComposeView",url = "resui/purificationWin.ExportJson",openModel = 0,closeModel=0,isDrag=0,title ="提纯",useBg = true},

	vipWin = {winTag = WinName.VIPWIN ,nextWinTag = "",layer = WinLayer.guide,req = "app.modules.vip.VipView",url = "resui/vipWin.ExportJson",openModel = 0,closeModel=0,isDrag=0,title ="VIP",useBg = true},
	activityWin = {winTag = WinName.ACTIVITYWIN ,nextWinTag = "",layer = WinLayer.guide,req = "app.modules.activity.view.ActivityView",url = "resui/activityWin.ExportJson",openModel = 0,closeModel=0,isDrag=0,title ="日常活动",useBg = true},

	rechargeWin = {winTag = WinName.RECHARGEWIN ,nextWinTag = "",layer = WinLayer.guide,req = "app.modules.recharge.RechargeView",url = "resui/chargeWin_1.ExportJson",openModel = 0,closeModel=0,isDrag=0,title ="充值",useBg = true},
	--oldrechargeWin = {winTag = WinName.RECHARGEWIN ,nextWinTag = "",layer = WinLayer.main,req = "app.modules.exchange.view.ExchangeView",url = "resui/exchangeBg.ExportJson",openModel = 0,closeModel=0,isDrag=0,title =""},
	dlRewardWin = {winTag = WinName.DLREWARDWIN ,nextWinTag = "",layer = WinLayer.main,req = "app.modules.downloadReward.DLRewardView",url = "resui/downloadWin_1.ExportJson",openModel = 0,closeModel=0,isDrag=0,title =""},
	welfareWin = {winTag = WinName.WELFAREWIN ,nextWinTag = "",layer = WinLayer.guide,req = "app.modules.welfare.view.WelfareWin",url = "resui/welfareNewWin.ExportJson",openModel = 0,closeModel=0,isDrag=0,title ="福利大厅",useBg = true},
--交易所
	exchangeView = {winTag = WinName.EXCHANGEWIN ,nextWinTag = "",layer = WinLayer.main,req = "app.modules.exChange.view.ExchangeView",url = "resui/exchangeBg.ExportJson",openModel = 0,closeModel=0,isDrag=0,title ="交易市场",useBg = true},
--未知暗殿
	darkHouseView = {winTag = WinName.DARKHOUSEWIN ,nextWinTag = "",layer = WinLayer.main,req = "app.modules.darkHouse.view.DarkHouseView",url = "resui/darkPalaceWin.ExportJson",openModel = 0,closeModel=0,isDrag=0,title =""},
--屠龙大会
	dragonView = {winTag = WinName.DRAGONWIN ,nextWinTag = "",layer = WinLayer.main,req = "app.modules.dragon.view.DragonView",url = "resui/killDragonWin.ExportJson",openModel = 0,closeModel=0,isDrag=0,title =""},

--胜者为王
	winnerView = {winTag = WinName.WINNERWIN ,nextWinTag = "",layer = WinLayer.main,req = "app.modules.winner.view.WinnerView",url = "resui/winnerWin.ExportJson",openModel = 0,closeModel=0,isDrag=0,title =""},
--排行榜
    rankWin = {winTag = WinName.RANKWIN ,nextWinTag = "",layer = WinLayer.main,req = "app.modules.rank.RankWin",url = "resui/rankingWin.ExportJson",openModel = 0,closeModel=0,isDrag=0,title ="排行榜",useBg = true},
    --开服活动
    activityServiceWin = {winTag = WinName.ACTIVITYSERVICERANKWIN ,nextWinTag = "",layer = WinLayer.guide,req = "app.modules.activity.view.OpenServeActivityView",url = "resui/serveActivityWin.ExportJson",openModel = 0,closeModel=0,isDrag=0,title ="开服活动",useBg = true},

     --邮件
    mailWin = {winTag = WinName.MAILWIN ,nextWinTag = "",layer = WinLayer.main,req = "app.modules.social.view.MailView",url = "resui/socialMailWin.ExportJson",openModel = 0,closeModel=0,isDrag=0,title ="邮件",useBg = true},

     --投保
    secureWin = {winTag = WinName.SECUREWIN ,nextWinTag = "",layer = WinLayer.main,req = "app.modules.secure.SecureView",url = "resui/insuranceWin.ExportJson",openModel = 0,closeModel=0,isDrag=0,title =""},
     --行会宣战
    guildWarconfirmWin = {winTag = WinName.GUILDWARCOMFIRMWIN ,nextWinTag = "",layer = WinLayer.main,req = "app.modules.guild.view.GuildWarComfirmWin",url = "resui/guildWarComfirmWin.ExportJson",openModel = 0,closeModel=0,isDrag=0,title =""},
     --行会宣战
    guildWarWin = {winTag = WinName.GUILDWARWIN ,nextWinTag = "",layer = WinLayer.main,req = "app.modules.guild.view.GuidWarWin",url = "resui/guildWarWin.ExportJson",openModel = 0,closeModel=0,isDrag=0,title ="行会宣战",useBg = true},
    --行会宣战
    guildWarResultWin = {winTag = WinName.GUILDWARRESULTWIN ,nextWinTag = "",layer = WinLayer.main,req = "app.modules.guild.view.GuildWarResultWin",url = "resui/guildWarResultWin.ExportJson",openModel = 0,closeModel=0,isDrag=0,title =""},
     --怪物攻城
    monsterAttackWin = {winTag = WinName.MONSTERATTACKWIN ,nextWinTag = "",layer = WinLayer.main,req = "app.modules.monsterAttack.view.MonsterAttackView",url = "resui/monsterAttackWin.ExportJson",openModel = 0,closeModel=0,isDrag=0,title =""},

    --趣味答题说明窗体
    answeringWin = {winTag = WinName.ANSWERINGWIN ,nextWinTag = "",layer = WinLayer.guide,req = "app.modules.answeringSystem.view.AnsweringView",url = "resui/examinationWin.ExportJson",openModel = 0,closeModel=0,isDrag=0,title =""},
    
    answeringMainWin = {winTag = WinName.ANSWERINGMAINWIN ,nextWinTag = "",layer = WinLayer.guide,req = "app.modules.answeringSystem.view.AnsweringMainView",url = "resui/examinationMainWin.ExportJson",openModel = 0,closeModel=0,isDrag=0,title =""},
    
    --运营活动
    businessWin = {winTag = WinName.BUSINESSWIN ,nextWinTag = "",layer = WinLayer.guide,req = "app.modules.business.view.BusinessActivityView",url = "resui/jingcaihuodongWin.ExportJson",openModel = 0,closeModel=0,isDrag=0,title =""},
    holidayWin = {winTag = WinName.HOLIDAYWIN ,nextWinTag = "",layer = WinLayer.guide,req = "app.modules.activity.view.HolidayActivityView",url = "resui/festivalActivityWin.ExportJson",openModel = 0,closeModel=0,isDrag=0,title =""},
    --装备展示
    equipShowWin = {winTag = WinName.EQUIPSHOWWIN ,nextWinTag = "",layer = WinLayer.guide,req = "app.modules.strategy.view.EquipShowView",url = "resui/strategyEquip.ExportJson",openModel = 0,closeModel=0,isDrag=0,title =""},

    bossCopyWin = {winTag = WinName.BOSSCOPYWIN ,nextWinTag = "",layer = WinLayer.guide,req = "app.modules.copy.view.BossCopyView",url = "resui/gerenbossWin.ExportJson",openModel = 0,closeModel=0,isDrag=0,title =""},
    oneTimesWin = {winTag = WinName.ONETIMESWIN ,nextWinTag = "",layer = WinLayer.guide,req = "app.modules.oneTimes.OneTimesView",url = "resui/oneTimesWin.ExportJson",openModel = 0,closeModel=0,isDrag=0,title =""},

    chatBagWin = {winTag = WinName.CHATBAGWIN ,nextWinTag = "",layer = WinLayer.guide,req = "app.modules.chat.view.ChatBagView",url = "resui/goodstipsWin.ExportJson",openModel = 0,closeModel=0,isDrag=0,title =""},
    chat = {winTag = WinName.CHAT ,nextWinTag = "",layer = WinLayer.guide,req = "app.modules.chat.view.ChatsWin",url = "resui/chatui_1.ExportJson",openModel = 0,closeModel=0,isDrag=0,title =""},

}

local WinManager = class("WinManager")

function WinManager:ctor()
	self.winList = {}
	self.curWinTag = ""

	GlobalEventSystem:addEventListener(DailyTaskEvent.TASK_JUMP, function(data)

		local info = StringUtil.split(data.data.win, ",")
		if info[1] == "win" then
			if info[2] == "equipProduWin" then
			 	self:openWin(info[2],tonumber(info[3]))
			else
				self:openWin(info[2],{tab = tonumber(info[3])})
			end
			
		elseif info[1] == "scene" then
			GameNet:sendMsgToSocket(info[2], {scene_id = tonumber(info[3])  or (RoleManager:getInstance().roleInfo.hookSceneId or 10001) } )
			self:closeWin(self.curWinTag)
		elseif info[1] == "npc" then
			local function enterFun()
                SceneManager:playerMoveToNPC(tonumber(info[2]),true)
                self:closeWin(self.curWinTag)
            end

            GlobalMessage:alert({
              enterTxt = "确定",
              backTxt= "取消",
              tipTxt = "是否寻路到对应的NPC？",
              enterFun = enterFun,
              tipShowMid = true
            })
			
		elseif info[1] == "activity" then
			--GameNet:sendMsgToSocket(32008, {active_id = self.activity_id})
		end
 
		
	end)


end	


--各种窗口的通过判断.
local function _checkWinTagPass(winTag)
	if winTag == WinName.WINGWIN then  --如果没有翅膀,升级翅膀会报错
		local equipList = RoleManager:getInstance().roleInfo.equip
		for _,equip in ipairs(equipList or {}) do
			local subTypeName,subType = configHelper:getEquipTypeByEquipId(equip.goods_id)
		    if subType == 13 then -- 翅膀
		      return true
		    end
		end
		GlobalMessage:show("还没有获得翅膀")
		return false
	end
	return true
end


-- 打开窗口
--@param  winTag 窗口Id
function WinManager:openWin(winTag,params)
	if GameSceneModel.isInterService then 
		if winTag == WinName.WELFAREWIN or 
			winTag == WinName.FRIEND or 
			 winTag == WinName.STRATEGYWIN or 
			 winTag == WinName.GUILDWIN or 
			 winTag == WinName.EXCHANGEWIN or 

			 winTag == WinName.EXCHANGEWIN or 

			 winTag == WinName.RANKWIN then 

			GlobalMessage:show("跨服中，不能使用该功能")
			return
		end
	end
	if GlobalController:getScene() == SCENE_MAIN then
		if self.curWinTag == winTag then
			return
		end
		print("openWin",winTag,self.curWinTag)
		if not _checkWinTagPass(winTag) then
			return
		end
		local conf = WinConfig[winTag]
		if conf then
			-- if winTag == WinName.FIGHT then
			-- 	GlobalEventSystem:dispatchEvent(GlobalEvent.SHOW_NAVIGATION,{visible = false})
			-- else
			-- 	GlobalEventSystem:dispatchEvent(GlobalEvent.SHOW_NAVIGATION,{visible = true})
			-- end
			if winTag ~= WinName.CHATBAGWIN and winTag ~= WinName.COPYPRIZETIPS and winTag ~= WinName.SERVERDARKWIN and winTag ~= WinName.PRIZERANK and winTag ~= WinName.SERVERDARKWIN then
	            for k,v in pairs(self.winList) do
					if k ~= WinName.WEARTEMPORARYWINGVIEW and k ~= WinName.UPGRADEWINGTIPSVIEW then
		            	self:closeWin(k,true)
		            end
	            end
	        end
            self.curWinTag = winTag -- closeWin会清除self.curWinTag

			local curWin		
			if self.winList[winTag] == nil then	
				local req = conf.req
				curWin = require(req).new(winTag,params or {},conf)
				GlobalEventSystem:dispatchEvent(GlobalEvent.WINDOW_ADD_SCENE,{view = curWin,layer = conf.layer})
				self.winList[winTag] = curWin
				curWin:open()
				SoundManager:playSoundByType(SoundType.WIN_OPEN)
				
			else			
				curWin = self.winList[winTag]
				if curWin.setData then
					curWin:setData(params or {})
					print("-------------窗口重新加载数据")
				end
				curWin:open()
				curWin:setVisible(true)
				--curWin:setPosition(0,0)			
				print("-------------窗口已加载")
				SoundManager:playSoundByType(SoundType.WIN_OPEN)
			end

			local callback = function ()

			end
			if conf.openModel then
				local sequence
				if conf.openModel == 1 then
					curWin:setPosition(0-display.width,0)		
					sequence = transition.sequence({
    				cc.MoveTo:create(0.3, cc.p(0, 0)),
    				--cc.FadeOut:create(0.2),
    				-- cc.DelayTime:create(0.5),
    				--cc.FadeIn:create(0.3),
    				cc.CallFunc:create(callback),
					})
					curWin:runAction(sequence)
				elseif conf.openModel == 2 then
					curWin:setPosition(0,0-display.height)
					sequence = transition.sequence({
    				cc.MoveTo:create(0.3, cc.p(0, 0)),
    				-- cc.FadeOut:create(0.2),
    				-- cc.DelayTime:create(0.5),
    				-- cc.FadeIn:create(0.3),
    				cc.CallFunc:create(callback),
					})
					curWin:runAction(sequence)
				else
					callback()
				end					
				
			else
				callback()
			end
			-- if winTag == WinName.FIGHT then
			-- 	for k,v in pairs(self.winList) do
			-- 		if v.winTag ~= WinName.FIGHT then
			-- 			v:setVisible(false)
			-- 		end
			-- 	end	
			-- end	
		else
			print("---------------未注册的窗口")
		end
	else
		print("-----------------没有主场景",winTag)	
	end	
end

--只打开这一个窗口，其他窗口关闭
function WinManager:openWinOnly(winTag,params)
	
end	

function WinManager:closeWin(winTag,isdestory)
	if GlobalController:getScene() == SCENE_MAIN then

		if not isdestory then
			GlobalEventSystem:dispatchEvent(SceneEvent.RESET_NAV_CHILD)
		end

		if self.curWinTag == winTag then
			self.curWinTag = ""
		end	
		print("closeWin",winTag,WinConfig[winTag])
		if WinConfig[winTag] then
			if self.winList[winTag] ~= nil then
				local conf = WinConfig[winTag]
				local win = self.winList[winTag]			
				-- if conf.closeVisible == 1 then
				-- 	win:close()
				-- 	win:setVisible(false)
				-- else
				-- 	win:close()				
				-- 	win:destory()
				-- 	self.winList[winTag] = nil
				-- 	GlobalEventSystem:dispatchEvent(GlobalEvent.WINDOW_CLOSE_SCENE,{view = win,layer = conf.layer})
				-- end
				local callback = function ()
					if conf.closeVisible == 1 and not isdestory then
						win:close()
						win:setVisible(false)
					else
						win:close()				
						win:destory()
						self.winList[winTag] = nil
						GlobalEventSystem:dispatchEvent(GlobalEvent.WINDOW_CLOSE_SCENE,{view = win,layer = conf.layer})
					end				
				end

				local sequence

				if conf.closeModel then
					local sequence
					if conf.closeModel == 1 then								
						sequence = transition.sequence({
	    				cc.MoveTo:create(0.3, cc.p(display.width, 0)),
	    				-- cc.FadeOut:create(0.2),
	    				-- cc.DelayTime:create(0.5),
	    				-- cc.FadeIn:create(0.3),
	    				cc.CallFunc:create(callback),
						})
						win:runAction(sequence)
					elseif conf.closeModel == 2 then						
						sequence = transition.sequence({
	    				cc.MoveTo:create(0.3, cc.p(0, display.height)),
	    				-- cc.FadeOut:create(0.2),
	    				-- cc.DelayTime:create(0.5),
	    				-- cc.FadeIn:create(0.3),
	    				cc.CallFunc:create(callback),
						})
						win:runAction(sequence)
					else
						callback()
					end	
				else
					callback()
				end
				SoundManager:playSoundByType(SoundType.WIN_CLOSE )
				if conf.nextWinTag and conf.nextWinTag ~= "" then
					self:openWin(conf.nextWinTag)
				end
				-- if winTag == WinName.FIGHT then
				-- 	for k,v in pairs(self.winList) do
				-- 		v:setVisible(true)
				-- 	end
				-- end
			end	
		end	
	end	
end

function WinManager:getWin(winTag)
	return self.winList[winTag]
end

function WinManager:getIsOpen(winTag)
	return self.winList[winTag] ~= nil
end	


function WinManager:closeAllWindow()
	for tag, win in pairs(self.winList) do
        self:closeWin(tag,true)
    end
    self.winList = {}
    self.curWinTag = ""
end	

function WinManager:destory()
	self:closeAllWindow()
end



return WinManager