--
-- Author: zhangshunqiu    21102585@qq.com
-- Date: 2016-01-11 14:32:10
-- 功能开放管理器
FunctionOpenManager = FunctionOpenManager or {}

FunctionExecHandler = import(".FunctionExecHandler")
FunctionOpenTipView = import(".view.FunctionOpenTipView")

FunctionOpenType = {
	MainTask    = 1,  -- 主线任务              ok
	Role  = 2,  -- 角色                        ok
	Bag  = 3,  -- 背包                         ok
	Skill   = 4,  -- 技能                      ok
	Social_guild = 5,  -- 社交（行会           ok
	Social_friend= 6,  -- 社交（好友、         ok  
	Social_email        = 7,  -- 社交（邮件）  ok
	Team         = 8,  -- 组队                 ok
	Sysoption   = 9,  -- 系统设置              ok
	Chat  = 10, -- 聊天系统                    ok

	Equip_streng  = 11, -- 装备强化            ok
	Equip_wash   = 12, -- 装备洗练             ok
	Equip_make = 13, -- 装备打造（神器打造）   ok

	PkMode = 14, -- PK模式                     ok
	FirstRecharge = 15, -- 首充                --还没有

	ShaBaKe = 16, -- 沙巴克                    ok

	DailyTask = 17, -- 每日任务                ok
	Qualifying = 18, -- 排位赛                 ok
	Activity = 19, -- 活动中心                 --还没有
	Welfare = 20, -- 福利中心                  --还没有
	Shop = 21, -- 商城                         ok
	HangUp = 22, -- 挂机                       ok
	Meritorious_task = 23, -- 功勋任务		   ok
	Worship = 24, -- 膜拜功能                  ok
	
}


FunctionOpenWinNameType = {
	[WinName.MAINROLEWIN] = 2,    -- 角色
	[WinName.BAGWIN] = 3,         -- 背包
	[WinName.SKILLVIEW] = 4,      -- 技能
	[WinName.TEAMWIN] = 8,        -- 组队
	[WinName.SYSOPTIONWIN] = 9,   -- 系统设置 
	[WinName.SHABAKE] = 16,       -- 沙巴克
	[WinName.DAILYTASKWIN] = 17,  -- 每日任务
	[WinName.QUALIFYINGWIN] = 18, -- 排位赛
	[WinName.STOREWIN] = 21,      -- 商城
	[WinName.WORSHIPWIN] = 24,    -- 膜拜功能
	[WinName.MEDALUPWIN]        = 33 , -- 勋章升级窗口
	[WinName.EQUIPPRODUWIN]     = 13 , -- 武器打造
	[WinName.EQUIPBAPTIZEWIN]   = 12 , -- 武器洗练
	[WinName.EQUIPSTRENGWIN]    = 11 , -- 武器强化
	[WinName.EQUIPDECOMPOSEWIN] = 32 , -- 武器分解 (已删)
	[WinName.EQUIPCOMPOSEWIN]   = 31 , -- 武器合成
	[WinName.SIGNWIN]   = 34 , -- 签到
	[WinName.DRAGONWIN]   = 38 , -- 屠龙大会
	[WinName.ACTIVITYSERVICERANKWIN]  = 40, --开服活动
	[WinName.EQUIPEXTENDSWIN]  = 68, --继承
	[WinName.EQUIPSOULWIN]  = 69, --铸魂
	
}

--FunctionOpenManager:getFunctionOpenById(FunctionOpenType.MainTask)
--FunctionOpenManager:getFunctionOpenByWinName(npcVO.param)
--FunctionOpenManager:showFunctionOpenTips(param)

-- MAINVIEW = "mainView", --主界面zsq
-- 	SKILLVIEW = "skillView", --技能界面zsq
-- 	NPCBUYWIN = "npcBuyWin", --Npc购买界面
-- 	NPCTRANSFER = "npcTransfer", --Npc传送界面 
-- 	NPCDIALOG = "npcDialog", --Npc对话界面
-- 	LOGIN = "login",
-- 	SMXJ = "smxj",
-- 	ALERT1 = "alert1",
-- 	MAIN = "main",
-- 	MATCHWIN = "matchWin",
-- 	FIGHTOVER = "fightOver",
-- 	TRAIN = "train",
-- 	BATTLE = "battle",
-- 	MAP = "map",  --地图
-- 	RESURGE = "resurge",  --复活
-- 	SHABAKE = "shabake",  --沙巴克主界面
-- 	SHABAKE_RULE_WIN = "shabakeRuleWin",  --沙巴克规则界面
-- 	SHABAKE_APPOINT_WIN = "shabakeAppointWin",  --沙巴克任命官员界面
	
-- 	MAINROLEWIN			= "mainRoleWin",			-- 主角信息 装备导航栏
-- 	BAGWIN				= "bagWin",					-- 背包窗口
-- 	EQUIPWIN			= "equipWin",				-- 装备窗口
-- 	SMELTWIN			= "smeltWin",				-- 熔炼窗口
-- 	ADDITEMWIN			= "addItemWin",				-- 测试道具用
-- 	SOCIALWIN			= "socialWin",				-- 社交窗口
-- 	STOREWIN			= "storeWin",				-- 商城窗口
-- 	STRATEGYWIN			= "strategyWin",			-- 游戏攻略窗口
-- 	CHALLENGEBOSSWIN	= "challengeBossWin",		-- 挑战boss窗口
-- 	STORAGEWIN			= "storageWin",				-- 仓库窗口
-- 	SYSOPTIONWIN		= "sysOptionWin",			-- 系统设置窗口
-- 	DAILYTASKWIN		= "dailyTaskWin",			-- 每日任务窗口
--     TEAMWIN				= "teamWin",				-- 组队窗口
-- 	COPYWIN				= "copyWin",				-- 副本窗口
-- 	MAYAWIN				= "mayaWin",				-- 玛雅窗口
-- 	QUALIFYINGWIN		= "qualifyingWin",			-- 排位赛窗口
-- 	QUALIFYINGSTOREWIN  = "qualifyingStoreWin",		-- 排位赛商店窗口
-- 	WORSHIPWIN  = "worshipWin",		-- 排位赛商店窗口

function FunctionOpenManager:ctor()
	self.openDic = {}
end

function FunctionOpenManager:getFunctionOpenById(functionId)
	if self.openDic[functionId] then
		return true
	end
	return false
end

function FunctionOpenManager:getFunctionOpenByWinName(winName)
	local curtype = FunctionOpenWinNameType[winName]
	if curtype then
		return self:getFunctionOpenById(curtype)
	end
	return true
end

function FunctionOpenManager:showFunctionOpenTips(param)
	--新手
	if param == 14 then
		GlobalMessage:show("36级后才能切换模式")
	else
		GlobalMessage:show("功能未开放")
	end
end

function FunctionOpenManager:initFunctionOpenList(array)
	--dump(array)
	self.openDic = {}--切换账号时 清理资源
	self:setFunctionEnabled(array, true)
end

function FunctionOpenManager:UpdateFunctionOpenByList(array, enabled)
	--dump(array)
	if enabled then
		self:onOpenFunctions(array)
	end

	self:setFunctionEnabled(array, enabled)
	GlobalEventSystem:dispatchEvent(GlobalEvent.UPDATE_FUNCTION_OPEN)
end

function FunctionOpenManager:onOpenFunctions(array)
	for _, v in pairs(array) do
		if not self:getFunctionOpenById(v) then
			-- 弹出功能开放提示框
			local data = configHelper:getFunctionConfigById(v)
			if data and data.window == 1 and data.lv < 200 then
				FunctionOpenTipView.new(data)
				:show()
			end

			-- 引导触发 - 当系统开放的时候
            -- Start_of_Guide --------------
            GlobalController.guide:getTriggerManager():tryTrigger(TriggerType.SYSTEM_PUBLIC, {
              func_id = v
            })
            -- End_of_Guide --------------
		end
	end
end

function FunctionOpenManager:setFunctionEnabled(array, enabled)
	for _, v in pairs(array) do
		if not enabled then
			self.openDic[v] = nil
			--行会宣战   关闭要把对应行会玩家名字颜色恢复
			if v == 72 then
				GlobalController.guild.fight_guild_id = 0
				GlobalController.fight:updateShabakeRoleStates()
			end
		else
			self.openDic[v] = enabled
			--行会宣战   修改对应行会玩家名字颜色恢复
			if v == 72 then
				GlobalController.fight:updateShabakeRoleStates()
			end
		end
		
	end
end

function FunctionOpenManager:gotoFunctionById(func_id)
	-- 判断此功能是否开启，如果开启则打开，否则显示提示。
	if self:getFunctionOpenById(func_id) then
		FunctionExecHandler.execute(func_id)
	else
		self:showFunctionOpenTips(func_id)
		return false
	end

	return true
end

function FunctionOpenManager:clear()
	self.openDic = {}
end





