--
-- Author: Alex mailto: liao131131@vip.qq.com
-- Date: 2016-01-27 15:45:04
--

-- Global visible of the function defines.
FUNC_OPID = import(".FunctionIds")

local FunctionExecHandler = {}

-- 主线任务 ----------无
function FunctionExecHandler.handle_MAIN_TASK                ()
	GlobalMessage:alert({
		enterTxt = "确定",
		backTxt="取消",
		tipTxt = "【功能实现请相应负责人来实现，FunctionExecHandler 文件 handle_MAIN_TASK",
	})
end

-- 角色 ----------打开角色窗口
function FunctionExecHandler.handle_OPEN_ROLE_WIN            ()
	GlobalWinManger:openWin(WinName.MAINROLEWIN)
end

-- 背包 ----------打开背包窗口
function FunctionExecHandler.handle_OPEN_BAG_WIN             ()
	GlobalWinManger:openWin(WinName.BAGWIN)
end

-- 技能 ----------打开技能窗口
function FunctionExecHandler.handle_OPEN_SKILL_WIN           ()
	GlobalWinManger:openWin(WinName.SKILLVIEW)
end

-- 行会 ----------打开行会窗口
function FunctionExecHandler.handle_OPEN_GUILD_WIN           ()
	if tonumber(RoleManager:getInstance().guildInfo.guild_id) > 0 then
		GlobalWinManger:openWin(WinName.GUILDWIN)
	else
		GlobalEventSystem:dispatchEvent(GlobalEvent.SHOW_SYSTIPS,"您未加入行会！")
	end
end

-- 行会 ----------打开行会活动窗口
function FunctionExecHandler.handle_OPEN_GUILD_ACTIVITY_WIN           ()
	if tonumber(RoleManager:getInstance().guildInfo.guild_id) > 0 then
		GlobalWinManger:openWin(WinName.GUILDWIN,{tab = 4})
	else
		GlobalEventSystem:dispatchEvent(GlobalEvent.SHOW_SYSTIPS,"您未加入行会！")
	end
end

-- 社交（好友、 ----------打开好友窗口
function FunctionExecHandler.handle_OPEN_FRIEND_WIN          ()
	GlobalWinManger:openWin(WinName.FRIEND)
end

-- 社交（邮件） ----------打开邮件窗口
function FunctionExecHandler.handle_OPEM_EMAIL_WIN           ()
	GlobalWinManger:openWin(WinName.FRIEND)
end

-- 组队 ----------打开组队窗口
function FunctionExecHandler.handle_OPEN_TEAM_WIN            ()
	GlobalWinManger:openWin(WinName.TEAMWIN)
end

-- 系统设置 ----------打开系统窗口
function FunctionExecHandler.handle_OPEN_SYS_SETTING_WIN     ()
	GlobalWinManger:openWin(WinName.SYSOPTIONWIN)
end

 --  聊天系统 ----------打开聊天窗口
function FunctionExecHandler.handle_OPEN_CHAT_WIN            ()
	GlobalWinManger:openWin(WinName.SYSOPTIONWIN)
end

 --  装备强化 ----------打开强化窗口
function FunctionExecHandler.handle_OPEN_STRENGTHEN_WIN      ()
	GlobalWinManger:openWin(WinName.EQUIPSTRENGWIN)
end

 --  装备洗练 ----------打开洗练窗口
function FunctionExecHandler.handle_OPEN_WASHS_PRACTICE_WIN  ()
	GlobalWinManger:openWin(WinName.EQUIPWIN)
end

 --  装备打造 ----------打开打造窗口
function FunctionExecHandler.handle_OPEN_PRODU_WIN       ()
	GlobalWinManger:openWin(WinName.EQUIPPRODUWIN)
end

 --  PK模式 ----------打开PK模式列表
function FunctionExecHandler.handle_OPEN_PK_MODE_VIEW        ()
	GlobalMessage:alert({
		enterTxt = "确定",
		backTxt="取消",
		tipTxt = "【功能实现请相应负责人来实现，FunctionExecHandler 文件 handle_OPEN_PK_MODE_VIEW",
	})
end

 --  首充 ----------打开首充窗口
function FunctionExecHandler.handle_OPEN_FIRST_WIN           ()
	GlobalController.welfare:OpenFirstRechargeView()
end

 --  沙巴克 ----------打开沙巴克窗口
function FunctionExecHandler.handle_OPEN_SHABAKE_WIN         ()
	GlobalWinManger:openWin(WinName.SHABAKE)
end

 --  每日任务 ----------打开每日任务窗口
function FunctionExecHandler.handle_OPEN_DAY_TASK_WIN        ()
	GlobalWinManger:openWin(WinName.DAILYTASKWIN)
end

 --  排位赛 ----------打开排位赛窗口
function FunctionExecHandler.handle_OPEN_QUALIFYING_WIN      ()
	GlobalWinManger:openWin(WinName.QUALIFYINGWIN)
end

 --  活动中心 ----------打开日常活动窗口
function FunctionExecHandler.handle_OPEN_ACTIVITY_DAY_WIN        ()
	GlobalWinManger:openWin(WinName.ACTIVITYWIN,{type =1})
end

 --  活动中心 ----------打开限时活动窗口
function FunctionExecHandler.handle_OPEN_ACTIVITY_TIME_WIN        ()
	GlobalWinManger:openWin(WinName.TIMEACTIVITY,{type =2})
end

--  活动中心 ----------打开竞技活动窗口
function FunctionExecHandler.handle_OPEN_ACTIVITY_SPORT_WIN        ()
	GlobalWinManger:openWin(WinName.ACTIVITYWIN,{type =3})
end

 --  福利中心 ----------打开福利中心窗口
function FunctionExecHandler.handle_OPEN_REWARD_CENTER_WIN   ()
	GlobalWinManger:openWin(WinName.WELFAREWIN)
end

 --  商城 ----------打开商城窗口
function FunctionExecHandler.handle_OPEN_STORE_WIN           ()
	GlobalWinManger:openWin(WinName.STOREWIN)
	-- require("app.modules.guide.GuideTest"):new():Test()
end

 --  功勋任务 ----------自动寻路去找皇城监军7522，打开对话
function FunctionExecHandler.handle_GOTO_FEAT_NPC            ()
	SceneManager:playerMoveToNPC(7522,true)
	GlobalWinManger:closeWin(WinName.ACTIVITYWIN,{type =1})
end

 --  膜拜功能 ----------自动寻路去找第一战士7523，打开对话
function FunctionExecHandler.handle_GOTO_WORSHIP_NPC         ()
	SceneManager:playerMoveToNPC(7523,true)
	GlobalWinManger:closeWin(WinName.ACTIVITYWIN,{type =1})
end

 --  世界BOSS ----------打开世界BOSS窗口
function FunctionExecHandler.handle_OPEN_WORLD_BOSS_WIN      ()
	GlobalWinManger:openWin(WinName.CHALLENGEBOSSWIN)
end

 --  个人副本 ----------打开个人副本窗口
function FunctionExecHandler.handle_OPEN_SINGLE_FB_WIN       ()
	GlobalWinManger:openWin(WinName.COPYWIN)
end

 --  分包下载 ----------打开分包下载窗口
function FunctionExecHandler.handle_OPEN_DOWNLOAD_WIN        ()
	GlobalWinManger:openWin(WinName.DLREWARDWIN)
end

--local node = nil

 --  游戏攻略 ----------打开游戏攻略窗口
function FunctionExecHandler.handle_OPEN_STRATEGY_WIN        ()
	GlobalWinManger:openWin(WinName.STRATEGYWIN)
	-- GlobalController.chat:pushSystemMsg("<font color='0x00ff00' size='20'>大陆的某个地方有BOSS刷新了，大家赶紧过去消灭他吧！</font>")

    --[[
	--------------------------------------------------------------------
	-- 弹出层失去触摸事件测试。 -- Start
	--------------------------------------------------------------------
	if node then 
		-- node:setVisible(false)
		-- local removeN = node
		-- GlobalTimer.performWithDelayGlobal(function(event)
  --          removeN:removeFromParent()
  --       end ,0.1)
node:removeFromParent()
	end

	node = display.newNode()
	-- 这个层的所用，就是用来阻挡用户事件
	-- 如果mask没有得到触摸事件响应，那么就会被阻挡住。
    local mask2 = display.newLayer()
    mask2:setTouchSwallowEnabled(true)
    local mask = display.newLayer()
    mask:setTouchSwallowEnabled(false)
    -- 在点击的时候立马把mask2禁止掉，这样可以继续传递触摸事件。
    -- 反之，如果没有禁止掉mask2，会阻挡所有的触摸事件，那么点击任何东西将不会有反应。
    -- 换句话来讲，如果mask没有接收到触摸事件，则会阻挡掉所有的触摸事件。
    -- 因为mask总会得到触摸事件才对，问题是偶发性的mask没有收到？why ？？？
    -- print("addNodeEventListener begin ")
    mask:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
        if event.name == "began" then
        	--print("------>began")
            mask2:setTouchSwallowEnabled(false)
        elseif event.name == "ended" then
        	mask2:setTouchSwallowEnabled(true)
        	--print("------->end")
    	end

        return true
    end)
    -- print("addNodeEventListener end ")
    display.newRect(cc.rect(0, 0, display.width, display.height),
        {fillColor = cc.c4f(0,0,1,.5), borderWidth = 1}):addTo(node)

    display.newTTFLabel({
    	text = "弹出层失去触摸事件测试",
    	size = 80,
    	color = display.COLOR_WHITE, 	
	}):addTo(node):pos(display.cx, display.cy)

	display.newTTFLabel({
    	text = "（正常情况下，出现了这段文字，你仍然可以点击任何东西。）",
    	size = 25,
    	color = TextColor.TEXT_G, 	
	}):addTo(node):pos(display.cx, display.cy - 80)

	display.newTTFLabel({
    	text = "（反之亦然，如果点击任何东西没有反应则说明失去了触摸事件。）",
    	size = 25,
    	color = TextColor.TEXT_C, 	
	}):addTo(node):pos(display.cx, display.cy - 80 - 30)

    node:addChild(mask2)
    node:addChild(mask)
    GlobalEventSystem:dispatchEvent(GlobalEvent.SHOW_BOX, node)
    --------------------------------------------------------------------
	-- 弹出层失去触摸事件测试。 -- End
	--------------------------------------------------------------------
	--]]
end

 --  充值 ----------打开充值窗口
function FunctionExecHandler.handle_OPEN_TOP_UP_WIN          ()
	GlobalWinManger:openWin(WinName.RECHARGEWIN)
end

 --  装备 ----------打开装备2级菜单
function FunctionExecHandler.handle_OPEN_EQUIP_SUB_MENU_VIEW ()
	GlobalEventSystem:dispatchEvent(GlobalEvent.SHOW_NAVIGATION_EQUIP_SUB)
end

 -- 提纯 ----------打开提纯界面
function FunctionExecHandler.handle_OPEN_COMPOSE_WIN         ()
	GlobalWinManger:openWin(WinName.EQUIPCOMPOSEWIN)
end

 -- 分解 ----------打开分解界面
function FunctionExecHandler.handle_OPEN_DECOMPOSE_WIN       ()
	GlobalWinManger:openWin(WinName.EQUIPDECOMPOSEWIN)
end

 -- 勋章 ----------打开勋章界面
function FunctionExecHandler.handle_OPEN_MEDALUP_WIN         ()
	GlobalWinManger:openWin(WinName.MEDALUPWIN)
end

-- 签到 ----------打开签到界面
function FunctionExecHandler.handle_OPEN_SIGN_WIN            ()
	GlobalWinManger:openWin(WinName.SIGNWIN)
end

-- 交易所 ----------打开交易所界面
function FunctionExecHandler.handle_OPEN_EXCHANGE_WIN        ()
	GlobalWinManger:openWin(WinName.EXCHANGEWIN)
end

-- 日常任务 ----------自动寻路去找老兵7507，打开对话
function FunctionExecHandler.handle_GOTO_DAILY_TASK_NPC      ()
	
	SceneManager:playerMoveToNPC(7507,true)
	GlobalWinManger:closeWin(WinName.ACTIVITYWIN,{type =1})
end

--未知暗殿
function FunctionExecHandler.handle_OPEN_DARKHOUSE_WIN      ()
	 
	GlobalWinManger:openWin(WinName.DARKHOUSEWIN)
end
--屠龙大会
function FunctionExecHandler.handle_OPEN_DRAGON_WIN      ()
	 
	GlobalWinManger:openWin(WinName.DRAGONWIN)
end
--胜者为王
function FunctionExecHandler.handle_OPEN_WINNER_WIN      ()
	 
	GlobalWinManger:openWin(WinName.WINNERWIN)
end
--怪物攻城
function FunctionExecHandler.handle_OPEN_MONSTER_ATTACK_WIN      ()
	 
	GlobalWinManger:openWin(WinName.MONSTERATTACKWIN)
end

function FunctionExecHandler.handle_OPEN_ANSWERING_WIN()
	GlobalWinManger:openWin(WinName.ANSWERINGWIN)
end

--转盘
function FunctionExecHandler.handle_OPEN_TURN_PLATE_WIN      ()
	GlobalWinManger:openWin(WinName.LUCKTURNPLATEWIN)
end

--抽奖
function FunctionExecHandler.handle_OPEN_LUCKDRAW_WIN      ()
	GlobalWinManger:openWin(WinName.LUCKDRAWWIN)
end

--开服活动
function FunctionExecHandler.handle_OPEN_SERVICE_ACTIVITY_WIN      ()
	 
	GlobalWinManger:openWin(WinName.ACTIVITYSERVICERANKWIN)
end

function FunctionExecHandler.handle_OPEN_ANGPAO_WIN1      ()
	 GlobalController.login:requestAngPao(63)
end

function FunctionExecHandler.handle_OPEN_ANGPAO_WIN2      ()
	GlobalController.login:requestAngPao(64)
end

function FunctionExecHandler.handle_OPEN_ANGPAO_WIN3      ()
	GlobalController.login:requestAngPao(65)
end

function FunctionExecHandler.handle_OPEN_ANGPAO_WIN4      ()
	GlobalController.login:requestAngPao(66)
end

function FunctionExecHandler.handle_OPEN_ANGPAO_WIN5      ()
	GlobalController.login:requestAngPao(67)
end

function FunctionExecHandler.handle_OPEN_GUILD_BM_WIN()
	GlobalWinManger:openWin(WinName.GUILDWIN,{tab = 6})
	FunctionOpenManager:UpdateFunctionOpenByList({FUNC_OPID.OPEN_GUILD_BM_WIN}, false)
end

function FunctionExecHandler.handle_OPEN_EXTENDS()
	GlobalWinManger:openWin(WinName.EQUIPEXTENDSWIN)
end

function FunctionExecHandler.handle_OPEN_SOUL()
	GlobalWinManger:openWin(WinName.EQUIPSOULWIN)
end

function FunctionExecHandler.handle_OPEN_GUILD_WAR_WIN()
	GlobalWinManger:openWin(WinName.GUILDWARRESULTWIN)
end

function FunctionExecHandler.handle_OPEN_BUSINESS_WIN()
	GlobalWinManger:openWin(WinName.BUSINESSWIN)
end

function FunctionExecHandler.handle_OPEN_EQUIPSHOW_WIN()
	GlobalWinManger:openWin(WinName.EQUIPSHOWWIN)
end

--个人boss副本
function FunctionExecHandler.handle_OPEN_BOSSCOPY_WIN()
	GlobalWinManger:openWin(WinName.BOSSCOPYWIN)
end

--跨服boss
function FunctionExecHandler.handle_OPEN_INTERSERVICE_WIN()
	--GlobalWinManger:openWin(WinName.INTERSERVISE,{type= 1})
	GlobalWinManger:openWin(WinName.KFHLSDWEEKWIN)
end
--跨服boss
function FunctionExecHandler.handle_OPEN_INTERSERVICE_DRAGON_WIN()
	GlobalWinManger:openWin(WinName.KFHLSDWEEKWIN)
end

--跨服幻境之城(活动)
function FunctionExecHandler.handle_OPEN_INTERSERVICE_DRAK_WIN()
	--GlobalWinManger:openWin(WinName.INTERSERVISE,{type= 3})
	GlobalWinManger:openWin(WinName.DREAMLANDWIN)
end
-- 跨服幻境之城(活动)
function FunctionExecHandler.handle_OPEN_DREAMLAND_112()
	--GlobalWinManger:openWin(WinName.INTERSERVISE,{type= 3})
	GlobalWinManger:openWin(WinName.DREAMLANDWIN)
end
-- 跨服幻境之城(即将开启预告, 打开WinName.INTERSERVISE, 第3个)
function FunctionExecHandler.handle_OPEN_DREAMLAND_113()
	--GlobalWinManger:openWin(WinName.INTERSERVISE,{type= 3})
	GlobalWinManger:openWin(WinName.DREAMLANDWIN)
end
-- 跨服幻境之城(进行中, 打开WinName.INTERSERVISE, 第3个)
function FunctionExecHandler.handle_OPEN_DREAMLAND_114()
	--GlobalWinManger:openWin(WinName.INTERSERVISE,{type= 3})
	GlobalWinManger:openWin(WinName.DREAMLANDWIN)
end
--本服幻境
function FunctionExecHandler.handle_OPEN_DREAMLAND_115()
	GlobalWinManger:openWin(WinName.DREAMLANDLOCALWIN)
end

function FunctionExecHandler.handle_OPEN_VARIATIONPALACE()
	GlobalWinManger:openWin(WinName.VARIATIONPALACE)
end

--节日活动
function FunctionExecHandler.handle_OPEN_HOLIDAY_WIN()
	GlobalWinManger:openWin(WinName.HOLIDAYWIN)
end

--一生一次购买活动
function FunctionExecHandler.handle_OPEN_ONETIMES_WIN()
	GlobalWinManger:openWin(WinName.ONETIMESWIN)
end

--一生一次购买活动
function FunctionExecHandler.handle_OPEN_MERGEACTIVITY_WIN()
	GlobalWinManger:openWin(WinName.MERGEACTIVITY)
end
--神皇秘境
function FunctionExecHandler.handle_OPEN_SHENGHUANGMJ_WIN()
	GlobalWinManger:openWin(WinName.SHENGHUANGMJ)
end
--王城乱斗
function FunctionExecHandler.handle_OPEN_WCLD_BEGIN_WIN()
	--GlobalWinManger:openWin(WinName.)
end
--王城乱斗
function FunctionExecHandler.handle_OPEN_WCLD_JXZ_WIN()
	--GlobalWinManger:openWin(WinName.)
end
--跨服暗殿
function FunctionExecHandler.handle_OPEN_KFAD_BEGIN_WIN()
	--GlobalWinManger:openWin(WinName.INTERSERVISE)
	GlobalWinManger:openWin(WinName.SERVERDARKWIN,3)
end
--跨服暗殿
function FunctionExecHandler.handle_OPEN_KFAD_JXZ_WIN()
	--GlobalWinManger:openWin(WinName.INTERSERVISE)
	GlobalWinManger:openWin(WinName.SERVERDARKWIN,3)
end

function FunctionExecHandler.handle_OPEN_KFAD_WIN()--97
	GlobalWinManger:openWin(WinName.SERVERDARKWIN)
end

function FunctionExecHandler.handle_OPEN_KFAD_WIN2()--98
	GlobalWinManger:openWin(WinName.SERVERDARKWIN)
end

function FunctionExecHandler.handle_OPEN_KFAD_WIN3()--99
	GlobalWinManger:openWin(WinName.SERVERDARKWIN)
end
function FunctionExecHandler.handle_OPEN_BFAD_WIN() --100
	GlobalWinManger:openWin(WinName.DARKHOUSEWIN)
end
--火龙神殿
function FunctionExecHandler.handle_OPEN_HLSD_WIN() --100
	GlobalWinManger:openWin(WinName.HLSDWIN)
end
--跨服火龙神殿
function FunctionExecHandler.handle_OPEN_KFHLSD_WIN() --100
	GlobalWinManger:openWin(WinName.KFHLSDWIN)--周末
end

function FunctionExecHandler.handle_OPEN_KFHLWEEK_WIN()
	GlobalWinManger:openWin(WinName.KFHLSDWEEKWIN) --周一到周五
end


--嘉年华转盘
function FunctionExecHandler.handle_OPEN_LUCKTURNPLATE2_WIN() --100
	GlobalWinManger:openWin(WinName.LUCKTURNPLATE2WIN)
end
--投资计划
function FunctionExecHandler.handle_OPEN_INVEST_WIN() --100
	GlobalWinManger:openWin(WinName.INVESTWIN)
end

--七天登录
function FunctionExecHandler.handle_SEVEN_LOGIN_WIN() --100
	GlobalWinManger:openWin(WinName.SEVENLOGINWIN)
end

-- /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

local FunctionRouters = {
	[FUNC_OPID.MAIN_TASK                ] = FunctionExecHandler.handle_MAIN_TASK               ,-- 主线任务 ----------无
	[FUNC_OPID.OPEN_ROLE_WIN            ] = FunctionExecHandler.handle_OPEN_ROLE_WIN           ,-- 角色 ----------打开角色窗口
	[FUNC_OPID.OPEN_BAG_WIN             ] = FunctionExecHandler.handle_OPEN_BAG_WIN            ,-- 背包 ----------打开背包窗口
	[FUNC_OPID.OPEN_SKILL_WIN           ] = FunctionExecHandler.handle_OPEN_SKILL_WIN          ,-- 技能 ----------打开技能窗口
	[FUNC_OPID.OPEN_GUILD_WIN           ] = FunctionExecHandler.handle_OPEN_GUILD_WIN          ,-- 行会 ----------打开行会窗口
	[FUNC_OPID.OPEN_FRIEND_WIN          ] = FunctionExecHandler.handle_OPEN_FRIEND_WIN         ,-- 社交（好友、 ----------打开好友窗口
	[FUNC_OPID.OPEM_EMAIL_WIN           ] = FunctionExecHandler.handle_OPEM_EMAIL_WIN          ,-- 社交（邮件） ----------打开邮件窗口
	[FUNC_OPID.OPEN_TEAM_WIN            ] = FunctionExecHandler.handle_OPEN_TEAM_WIN           ,-- 组队 ----------打开组队窗口
	[FUNC_OPID.OPEN_SYS_SETTING_WIN     ] = FunctionExecHandler.handle_OPEN_SYS_SETTING_WIN    ,-- 系统设置 ----------打开系统窗口
	[FUNC_OPID.OPEN_CHAT_WIN            ] = FunctionExecHandler.handle_OPEN_CHAT_WIN           , -- 聊天系统 ----------打开聊天窗口
	[FUNC_OPID.OPEN_STRENGTHEN_WIN      ] = FunctionExecHandler.handle_OPEN_STRENGTHEN_WIN     , -- 装备强化 ----------打开强化窗口
	[FUNC_OPID.OPEN_WASHS_PRACTICE_WIN  ] = FunctionExecHandler.handle_OPEN_WASHS_PRACTICE_WIN , -- 装备洗练 ----------打开洗练窗口
	[FUNC_OPID.OPEN_PRODU_WIN           ] = FunctionExecHandler.handle_OPEN_PRODU_WIN          , -- 装备打造 ----------打开打造窗口
	[FUNC_OPID.OPEN_PK_MODE_VIEW        ] = FunctionExecHandler.handle_OPEN_PK_MODE_VIEW       , -- PK模式 ----------打开PK模式列表
	[FUNC_OPID.OPEN_FIRST_WIN           ] = FunctionExecHandler.handle_OPEN_FIRST_WIN          , -- 首充 ----------打开首充窗口
	[FUNC_OPID.OPEN_SHABAKE_WIN         ] = FunctionExecHandler.handle_OPEN_SHABAKE_WIN        , -- 沙巴克 ----------打开沙巴克窗口
	[FUNC_OPID.OPEN_DAY_TASK_WIN        ] = FunctionExecHandler.handle_OPEN_DAY_TASK_WIN       , -- 每日任务 ----------打开每日任务窗口
	[FUNC_OPID.OPEN_QUALIFYING_WIN      ] = FunctionExecHandler.handle_OPEN_QUALIFYING_WIN     , -- 排位赛 ----------打开排位赛窗口
	[FUNC_OPID.OPEN_ACTIVITY_DAY_WIN    ] = FunctionExecHandler.handle_OPEN_ACTIVITY_DAY_WIN, -- 日常活动中心 ----------打开活动中心窗口
	[FUNC_OPID.OPEN_ACTIVITY_TIME_WIN   ] = FunctionExecHandler.handle_OPEN_ACTIVITY_TIME_WIN, -- 限时活动中心 ----------打开活动中心窗口
	[FUNC_OPID.OPEN_ACTIVITY_SPORT_WIN  ] = FunctionExecHandler.handle_OPEN_ACTIVITY_SPORT_WIN, -- 竞技活动中心 ----------打开活动中心窗口
	[FUNC_OPID.OPEN_REWARD_CENTER_WIN   ] = FunctionExecHandler.handle_OPEN_REWARD_CENTER_WIN  , -- 福利中心 ----------打开福利中心窗口
	[FUNC_OPID.OPEN_STORE_WIN           ] = FunctionExecHandler.handle_OPEN_STORE_WIN          , -- 商城 ----------打开商城窗口
	[FUNC_OPID.ALERT_HANG_UP            ] = FunctionExecHandler.handle_ALERT_HANG_UP           , -- 挂机 ----------先打开确认进入提示，再进入挂机
	[FUNC_OPID.GOTO_FEAT_NPC            ] = FunctionExecHandler.handle_GOTO_FEAT_NPC           , -- 功勋任务 ----------自动寻路去找皇城监军7522，打开对话
	[FUNC_OPID.GOTO_WORSHIP_NPC         ] = FunctionExecHandler.handle_GOTO_WORSHIP_NPC        , -- 膜拜功能 ----------自动寻路去找第一战士7523，打开对话
	[FUNC_OPID.OPEN_WORLD_BOSS_WIN      ] = FunctionExecHandler.handle_OPEN_WORLD_BOSS_WIN     , -- 世界BOSS ----------打开世界BOSS窗口
	[FUNC_OPID.OPEN_SINGLE_FB_WIN       ] = FunctionExecHandler.handle_OPEN_SINGLE_FB_WIN      , -- 个人副本 ----------打开个人副本窗口
	[FUNC_OPID.OPEN_DOWNLOAD_WIN        ] = FunctionExecHandler.handle_OPEN_DOWNLOAD_WIN       , -- 分包下载 ----------打开分包下载窗口
	[FUNC_OPID.OPEN_STRATEGY_WIN        ] = FunctionExecHandler.handle_OPEN_STRATEGY_WIN       , -- 游戏攻略 ----------打开游戏攻略窗口
	[FUNC_OPID.OPEN_TOP_UP_WIN          ] = FunctionExecHandler.handle_OPEN_TOP_UP_WIN         , -- 充值 ----------打开充值窗口
	[FUNC_OPID.OPEN_EQUIP_SUB_MENU_VIEW ] = FunctionExecHandler.handle_OPEN_EQUIP_SUB_MENU_VIEW, -- 装备 ----------打开装备2级菜单
	[FUNC_OPID.OPEN_COMPOSE_WIN         ] = FunctionExecHandler.handle_OPEN_COMPOSE_WIN        , -- 提纯 ----------打开提纯界面
	[FUNC_OPID.OPEN_DECOMPOSE_WIN       ] = FunctionExecHandler.handle_OPEN_DECOMPOSE_WIN      , -- 分解 ----------打开分解界面
	[FUNC_OPID.OPEN_MEDALUP_WIN         ] = FunctionExecHandler.handle_OPEN_MEDALUP_WIN        , -- 勋章 ----------打开勋章界面
	[FUNC_OPID.OPEN_SIGN_WIN            ] = FunctionExecHandler.handle_OPEN_SIGN_WIN           , -- 签到 ----------打开签到界面
	[FUNC_OPID.OPEN_EXCHANGE_WIN        ] = FunctionExecHandler.handle_OPEN_EXCHANGE_WIN       , -- 交易所 ----------打开交易所界面
	[FUNC_OPID.GOTO_DAILY_TASK_NPC      ] = FunctionExecHandler.handle_GOTO_DAILY_TASK_NPC     , -- 日常任务 ----------自动寻路去找老兵7507，打开对话
	[FUNC_OPID.OPEN_DARKHOUSE_WIN      	] = FunctionExecHandler.handle_OPEN_DARKHOUSE_WIN      , -- 未知暗殿 ----------自动寻路去找老兵7507，打开对话
	[FUNC_OPID.OPEN_DRAGON_WIN      	] = FunctionExecHandler.handle_OPEN_DRAGON_WIN		   , -- 屠龙大会 ----

	[FUNC_OPID.OPEN_WINNER_WIN      	] = FunctionExecHandler.handle_OPEN_WINNER_WIN		   , -- 胜者为王 ----
	[FUNC_OPID.OPEN_SERVICE_ACTIVITY_WIN      	] = FunctionExecHandler.handle_OPEN_SERVICE_ACTIVITY_WIN		   , -- 胜者为王 ----

	--特殊活动提醒功能
	[FUNC_OPID.OPEN_DRAGON_START      	] = FunctionExecHandler.handle_OPEN_DRAGON_WIN,
	[FUNC_OPID.OPEN_DRAGON_DOING      	] = FunctionExecHandler.handle_OPEN_DRAGON_WIN,
	[FUNC_OPID.OPEN_WINNER1_START      	] = FunctionExecHandler.handle_OPEN_WINNER_WIN,
	[FUNC_OPID.OPEN_WINNER1_DOING      	] = FunctionExecHandler.handle_OPEN_WINNER_WIN,
	[FUNC_OPID.OPEN_DARKHOUSE1_START      	] = FunctionExecHandler.handle_OPEN_DARKHOUSE_WIN,
	[FUNC_OPID.OPEN_DARKHOUSE1_DOING      	] = FunctionExecHandler.handle_OPEN_DARKHOUSE_WIN,
	[FUNC_OPID.OPEN_WINNER2_START      	] = FunctionExecHandler.handle_OPEN_WINNER_WIN,
	[FUNC_OPID.OPEN_WINNER2_DOING      	] = FunctionExecHandler.handle_OPEN_WINNER_WIN,
	[FUNC_OPID.OPEN_DARKHOUSE2_START      	] = FunctionExecHandler.handle_OPEN_DARKHOUSE_WIN,
	[FUNC_OPID.OPEN_DARKHOUSE2_DOING      	] = FunctionExecHandler.handle_OPEN_DARKHOUSE_WIN,
	[FUNC_OPID.OPEN_GUILD_BOSS_START      	] = FunctionExecHandler.handle_OPEN_GUILD_ACTIVITY_WIN,
	[FUNC_OPID.OPEN_GUILD_BOSS_DOING      	] = FunctionExecHandler.handle_OPEN_GUILD_ACTIVITY_WIN,
	[FUNC_OPID.OPEN_GUILD_MJ_START      	] = FunctionExecHandler.handle_OPEN_GUILD_ACTIVITY_WIN,
	[FUNC_OPID.OPEN_GUILD_MJ_DOING      	] = FunctionExecHandler.handle_OPEN_GUILD_ACTIVITY_WIN,
	[FUNC_OPID.OPEN_GUILD_BOSS_WIN      	] = FunctionExecHandler.handle_OPEN_GUILD_ACTIVITY_WIN,
	[FUNC_OPID.OPEN_GUILD_MJ_WIN      	] = FunctionExecHandler.handle_OPEN_GUILD_ACTIVITY_WIN,
	--开服活动红包
	[FUNC_OPID.OPEN_ANGPAO1      	] = FunctionExecHandler.handle_OPEN_ANGPAO_WIN1,
	[FUNC_OPID.OPEN_ANGPAO2      	] = FunctionExecHandler.handle_OPEN_ANGPAO_WIN2,
	[FUNC_OPID.OPEN_ANGPAO3      	] = FunctionExecHandler.handle_OPEN_ANGPAO_WIN3,
	[FUNC_OPID.OPEN_ANGPAO4      	] = FunctionExecHandler.handle_OPEN_ANGPAO_WIN4,
	[FUNC_OPID.OPEN_ANGPAO5      	] = FunctionExecHandler.handle_OPEN_ANGPAO_WIN5,

	[FUNC_OPID.OPEN_EXTENDS      	] = FunctionExecHandler.handle_OPEN_EXTENDS,
	[FUNC_OPID.OPEN_SOUL      	] = FunctionExecHandler.handle_OPEN_SOUL,
	--行会红包
	[FUNC_OPID.OPEN_GUILD_BM_WIN    ] = FunctionExecHandler.handle_OPEN_GUILD_BM_WIN,
	--转盘
	[FUNC_OPID.OPEN_TURN_PLATE_WIN    ] = FunctionExecHandler.handle_OPEN_TURN_PLATE_WIN,
	--抽奖
	[FUNC_OPID.OPEN_LUCKDRRAW_WIN    ] = FunctionExecHandler.handle_OPEN_LUCKDRAW_WIN,
	[FUNC_OPID.OPEN_GUILD_WAR_WIN    ] = FunctionExecHandler.handle_OPEN_GUILD_WAR_WIN,--行会宣战

	[FUNC_OPID.OPEN_MONSTER_ATTACK_WIN    ] = FunctionExecHandler.handle_OPEN_MONSTER_ATTACK_WIN,--怪物攻城
	[FUNC_OPID.OPEN_MONSTER_ATTACK_WIN_ING1    ] = FunctionExecHandler.handle_OPEN_MONSTER_ATTACK_WIN,--怪物攻城
	[FUNC_OPID.OPEN_MONSTER_ATTACK_WIN_ING2    ] = FunctionExecHandler.handle_OPEN_MONSTER_ATTACK_WIN,--怪物攻城

	[FUNC_OPID.OPEN_BUSINESS_WIN    ] = FunctionExecHandler.handle_OPEN_BUSINESS_WIN,--运营活动
	[FUNC_OPID.OPEN_EQUIPSHOW_WIN    ] = FunctionExecHandler.handle_OPEN_EQUIPSHOW_WIN,--装备展示

	[FUNC_OPID.OPEN_ANSWERING_WIN1 ] = FunctionExecHandler.handle_OPEN_ANSWERING_WIN,--趣味答题
	[FUNC_OPID.OPEN_ANSWERING_WIN2 ] = FunctionExecHandler.handle_OPEN_ANSWERING_WIN,--趣味答题

	[FUNC_OPID.OPEN_BOSSCOPY_WIN ] = FunctionExecHandler.handle_OPEN_BOSSCOPY_WIN,--个人boss副本

	[FUNC_OPID.OPEN_INTERSERVICE_WIN ] = FunctionExecHandler.handle_OPEN_INTERSERVICE_WIN,--跨服BOSS
	[FUNC_OPID.OPEN_INTERSERVICE_DRAGON_WIN ] = FunctionExecHandler.handle_OPEN_INTERSERVICE_DRAGON_WIN,--跨服火龙BOSS 
	[FUNC_OPID.OPEN_INTERSERVICE_DRAGON_WIN2 ] = FunctionExecHandler.handle_OPEN_INTERSERVICE_DRAGON_WIN,--跨服火龙BOSS 
	[FUNC_OPID.OPEN_INTERSERVICE_DARK_WIN ] = FunctionExecHandler.handle_OPEN_INTERSERVICE_DRAK_WIN,--跨服暗殿BOSS 
	[FUNC_OPID.OPEN_HOLIDAY_WIN ] = FunctionExecHandler.handle_OPEN_HOLIDAY_WIN, --节日活动
	[FUNC_OPID.OPEN_ONETIMES_WIN ] = FunctionExecHandler.handle_OPEN_ONETIMES_WIN, --一生一次购买活动
	[FUNC_OPID.OPEN_MERGEACTIVITY_WIN ] = FunctionExecHandler.handle_OPEN_MERGEACTIVITY_WIN,
	[FUNC_OPID.OPEN_SHENGHUANGMJ_WIN ] = FunctionExecHandler.handle_OPEN_SHENGHUANGMJ_WIN,

	[FUNC_OPID.OPEN_DREAMLAND_112 ] = FunctionExecHandler.handle_OPEN_DREAMLAND_112, -- 跨服幻境之城(活动)
	[FUNC_OPID.OPEN_DREAMLAND_113 ] = FunctionExecHandler.handle_OPEN_DREAMLAND_113, -- 跨服幻境之城(即将开启预告, 打开WinName.INTERSERVISE, 第3个)
	[FUNC_OPID.OPEN_DREAMLAND_114 ] = FunctionExecHandler.handle_OPEN_DREAMLAND_114, -- 跨服幻境之城(进行中, 打开WinName.INTERSERVISE, 第3个)

	[FUNC_OPID.OPEN_DREAMLAND_115 ] = FunctionExecHandler.handle_OPEN_DREAMLAND_115, -- 本服幻境之城
	[FUNC_OPID.OPEN_DREAMLAND_116 ] = FunctionExecHandler.handle_OPEN_DREAMLAND_115, -- 本服幻境之城
	[FUNC_OPID.OPEN_DREAMLAND_117 ] = FunctionExecHandler.handle_OPEN_DREAMLAND_115, -- 本服幻境之城

	[FUNC_OPID.OPEN_VARIATIONPALACE_119] = FunctionExecHandler.handle_OPEN_VARIATIONPALACE, --跨服变异地宫
	[FUNC_OPID.OPEN_VARIATIONPALACE_120] = FunctionExecHandler.handle_OPEN_VARIATIONPALACE, --跨服变异地宫
	[FUNC_OPID.OPEN_VARIATIONPALACE_121] = FunctionExecHandler.handle_OPEN_VARIATIONPALACE, --跨服变异地宫

	[FUNC_OPID.OPEN_KFAD_BEGIN_WIN ] = FunctionExecHandler.handle_OPEN_KFAD_BEGIN_WIN,
	[FUNC_OPID.OPEN_KFAD_JXZ_WIN ] = FunctionExecHandler.handle_OPEN_KFAD_JXZ_WIN,
	[FUNC_OPID.OPEN_WCLD_BEGIN_WIN ] = FunctionExecHandler.handle_OPEN_WCLD_BEGIN_WIN,
	[FUNC_OPID.OPEN_WCLD_JXZ_WIN ] = FunctionExecHandler.handle_OPEN_WCLD_JXZ_WIN,

	[FUNC_OPID.OPEN_KFAD_WIN ] = FunctionExecHandler.handle_OPEN_KFAD_WIN,
	[FUNC_OPID.OPEN_KFAD_WIN2 ] = FunctionExecHandler.handle_OPEN_KFAD_WIN2,
	[FUNC_OPID.OPEN_KFAD_WIN3 ] = FunctionExecHandler.handle_OPEN_KFAD_WIN3,
	[FUNC_OPID.OPEN_BFAD_WIN ] = FunctionExecHandler.handle_OPEN_BFAD_WIN,

	--跨服火龙神殿
	[FUNC_OPID.KFHLSD_WIN1 ] = FunctionExecHandler.handle_OPEN_KFHLSD_WIN,
	[FUNC_OPID.KFHLSD_WIN2 ] = FunctionExecHandler.handle_OPEN_KFHLSD_WIN,
	[FUNC_OPID.KFHLSD_WIN3 ] = FunctionExecHandler.handle_OPEN_KFHLSD_WIN,


	[FUNC_OPID.KFHL_SW_JJKS ] = FunctionExecHandler.handle_OPEN_KFHLWEEK_WIN,
	[FUNC_OPID.KFHL_SW_JXZ ] = FunctionExecHandler.handle_OPEN_KFHLWEEK_WIN,
	
	[FUNC_OPID.BFHL_SW_JJKS ] = FunctionExecHandler.handle_OPEN_HLSD_WIN,
	[FUNC_OPID.BFHL_SW_JXZ ] = FunctionExecHandler.handle_OPEN_HLSD_WIN,
	[FUNC_OPID.KFHL_ZMSW_JJKS ] = FunctionExecHandler.handle_OPEN_KFHLSD_WIN,
	[FUNC_OPID.KFHL_ZMSW_JXZ ] = FunctionExecHandler.handle_OPEN_KFHLSD_WIN,

	--本服火龙神殿
	[FUNC_OPID.HLSD_WIN1 ] = FunctionExecHandler.handle_OPEN_HLSD_WIN,
	[FUNC_OPID.HLSD_WIN2 ] = FunctionExecHandler.handle_OPEN_HLSD_WIN,
	[FUNC_OPID.HLSD_WIN3 ] = FunctionExecHandler.handle_OPEN_HLSD_WIN,
	[FUNC_OPID.HLSD_WIN11 ] = FunctionExecHandler.handle_OPEN_HLSD_WIN,
	[FUNC_OPID.HLSD_WIN12 ] = FunctionExecHandler.handle_OPEN_HLSD_WIN,
	[FUNC_OPID.HLSD_WIN13 ] = FunctionExecHandler.handle_OPEN_HLSD_WIN,

	[FUNC_OPID.LUCKTURNPLATE2_WIN ] = FunctionExecHandler.handle_OPEN_LUCKTURNPLATE2_WIN,
	[FUNC_OPID.INVEST_WIN ] = FunctionExecHandler.handle_OPEN_INVEST_WIN,

	[FUNC_OPID.SEVEN_LOGIN ] = FunctionExecHandler.handle_SEVEN_LOGIN_WIN,
}

local guideConfirmOp = {
	[FUNC_OPID.OPEN_ROLE_WIN            ] = GUIOP.CLICK_BOTTOM_NAV_ROLE,-- 角色 ----------打开角色窗口
	[FUNC_OPID.OPEN_BAG_WIN             ] = GUIOP.CLICK_BOTTOM_NAV_BAG,-- 背包 ----------打开背包窗口
    [FUNC_OPID.OPEN_SKILL_WIN           ] = GUIOP.CLICK_BOTTOM_NAV_SKILL,-- 技能 ----------打开技能窗口
	[FUNC_OPID.OPEN_GUILD_WIN           ] = GUIOP.CLICK_BOTTOM_NAV_GUILD,-- 行会 ----------打开行会窗口
	[FUNC_OPID.OPEN_FRIEND_WIN          ] = GUIOP.CLICK_BOTTOM_NAV_SOCIAL,-- 社交（好友、 ----------打开好友窗口
	[FUNC_OPID.OPEM_EMAIL_WIN           ] = GUIOP.CLICK_BOTTOM_NAV_SOCIAL,-- 社交（邮件） ----------打开邮件窗口
	[FUNC_OPID.OPEN_TEAM_WIN            ] = GUIOP.CLICK_BOTTOM_NAV_TEAM,-- 组队 ----------打开组队窗口
	[FUNC_OPID.OPEN_SYS_SETTING_WIN     ] = GUIOP.CLICK_BOTTOM_NAV_SYS_OP,-- 系统设置 ----------打开系统窗口
	[FUNC_OPID.OPEN_CHAT_WIN            ] = GUIOP.NULL, -- 聊天系统 ----------打开聊天窗口
	[FUNC_OPID.OPEN_STRENGTHEN_WIN      ] = GUIOP.CLICK_BOTTOM_NAV_STRENG, -- 装备强化 ----------打开强化窗口
	[FUNC_OPID.OPEN_WASHS_PRACTICE_WIN  ] = GUIOP.CLICK_BOTTOM_NAV_WASHSPRACTICE, -- 装备洗练 ----------打开洗练窗口
	[FUNC_OPID.OPEN_PRODU_WIN           ] = GUIOP.CLICK_BOTTOM_NAV_PRODU, -- 装备打造 ----------打开打造窗口
	[FUNC_OPID.OPEN_PK_MODE_VIEW        ] = GUIOP.NULL, -- PK模式 ----------打开PK模式列表
	[FUNC_OPID.OPEN_FIRST_WIN           ] = GUIOP.CLICK_TOP_NAV_FIRST, -- 首充 ----------打开首充窗口
	[FUNC_OPID.OPEN_SHABAKE_WIN         ] = GUIOP.CLICK_TOP_NAV_SHABAKE, -- 沙巴克 ----------打开沙巴克窗口
	[FUNC_OPID.OPEN_DAY_TASK_WIN        ] = GUIOP.NULL, -- 每日任务 ----------打开每日任务窗口
	[FUNC_OPID.OPEN_QUALIFYING_WIN      ] = GUIOP.NULL, -- 排位赛 ----------打开排位赛窗口
	[FUNC_OPID.OPEN_ACTIVITY_DAY_WIN    ] = GUIOP.CLICK_TOP_NAV_ACTIVITY_DAY, -- 日常活动 ----------打开活动中心窗口
	[FUNC_OPID.OPEN_REWARD_CENTER_WIN   ] = GUIOP.CLICK_TOP_NAV_WELFARE, -- 福利中心 ----------打开福利中心窗口
	[FUNC_OPID.OPEN_STORE_WIN           ] = GUIOP.CLICK_TOP_NAV_STORE, -- 商城 ----------打开商城窗口
	[FUNC_OPID.ALERT_HANG_UP            ] = GUIOP.CLICK_TOP_NAV_HANG_UP, -- 挂机 ----------先打开确认进入提示，再进入挂机
	[FUNC_OPID.GOTO_FEAT_NPC            ] = GUIOP.NULL, -- 功勋任务 ----------自动寻路去找皇城监军7522，打开对话
	[FUNC_OPID.GOTO_WORSHIP_NPC         ] = GUIOP.NULL, -- 膜拜功能 ----------自动寻路去找第一战士7523，打开对话
	[FUNC_OPID.OPEN_WORLD_BOSS_WIN      ] = GUIOP.NULL, -- 世界BOSS ----------打开世界BOSS窗口
	[FUNC_OPID.OPEN_SINGLE_FB_WIN       ] = GUIOP.NULL, -- 个人副本 ----------打开个人副本窗口
	[FUNC_OPID.OPEN_DOWNLOAD_WIN        ] = GUIOP.CLICK_TOP_NAV_DOWNLOAD, -- 分包下载 ----------打开分包下载窗口
	[FUNC_OPID.OPEN_STRATEGY_WIN        ] = GUIOP.CLICK_TOP_NAV_STRATEGY, -- 游戏攻略 ----------打开游戏攻略窗口
	[FUNC_OPID.OPEN_TOP_UP_WIN          ] = GUIOP.CLICK_TOP_NAV_TOP_UP, -- 充值 ----------打开充值窗口
	[FUNC_OPID.OPEN_EQUIP_SUB_MENU_VIEW ] = GUIOP.CLICK_BOTTOM_NAV_EQUIP, -- 装备 ----------打开装备2级菜单
	[FUNC_OPID.OPEN_COMPOSE_WIN         ] = GUIOP.CLICK_BOTTOM_NAV_COMPOSE, -- 提纯 ----------打开提纯界面
	[FUNC_OPID.OPEN_DECOMPOSE_WIN       ] = GUIOP.CLICK_BOTTOM_NAV_DECOMPOSE, -- 分解 ----------打开分解界面
	[FUNC_OPID.OPEN_MEDALUP_WIN         ] = GUIOP.CLICK_BOTTOM_NAV_MEDALUP, -- 勋章 ----------打开勋章界面
	[FUNC_OPID.OPEN_SIGN_WIN            ] = GUIOP.CLICK_TOP_NAV_SIGN, -- 签到 ----------打开签到界面
	[FUNC_OPID.OPEN_EXCHANGE_WIN        ] = GUIOP.CLICK_TOP_NAV_EXCHANG, -- 交易所 ----------打开交易所界面
}

function FunctionExecHandler.execute(func_id)
	if FunctionRouters[func_id] then
		FunctionRouters[func_id]()
	end

	-- 引导事件确认
	FunctionExecHandler.confirmGuide(func_id)
end

--
-- 根据请求的功能ID，来发出引导确认事件，以便引导进入下一步。
--
function FunctionExecHandler.confirmGuide(func_id)

	local op = guideConfirmOp[func_id]
	if op then
		GlobalController.guide:notifyEventWithConfirm(op)
	end
end

return FunctionExecHandler