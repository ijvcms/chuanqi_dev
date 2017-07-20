--
-- Author: zhangshunqiu    21102585@qq.com
-- Date: 2017-04-30 10:19:15
-- 经验气血功能按钮UI

local NavigationBtn = import("app.modules.mainUI.NavigationBtn")
local NavigationSubView = import("app.modules.mainUI.NavigationSubView")

local BottomExpHpUI = BottomExpHpUI or class("BottomExpHpUI", function() return display.newNode() end )



local EQUIP_SUB_MARK = "__equip_sub_mark__"
 
-- 左侧菜单
local ParamLeftList = {
	[1] = {win = WinName.MAINROLEWIN,icon = "#scene/scene_menuRoleBtn.png", name = "角色"},
	[2] = {win = WinName.BAGWIN,icon = "#scene/scene_menuBagBtn.png",name = "背包"},
	[3] = {win = WinName.SKILLVIEW,icon = "#scene/scene_menuSkillBtn.png",name = "技能"},
	[4] = {win = EQUIP_SUB_MARK,icon = "#scene/scene_menuEquip.png",name = "装备"},
}

-- 右侧菜单
local ParamRightList = {
	[1] = {win = WinName.GUILDWIN,icon = "#scene/scene_menuGuildBtn.png",name = "帮会"},
	[2] = {win = WinName.FRIEND,icon = "#scene/scene_menuSocialBtn.png",name = "社交"},
	--[3] = {win = WinName.TEAMWIN,icon = "#scene/main_teamIcon.png",},--组队
	[3] = {win = WinName.EXCHANGEWIN, icon = "#scene/scene_menuExchangBtn.png", name = "交易"},--交易所
	[4] = {win = WinName.SYSOPTIONWIN,icon = "#scene/scene_menuSettingBtn.png",name = "设置"},
	--[5] = {win = WinName.STOREWIN,icon = "#scene/scene_menuShopBtn.png",name = "商城"},
	
}

function BottomExpHpUI:ctor(sceneUI)
    -- 装备二级菜单，强化、洗练、分解、提纯、打造、继承，勋章
    self.euiqpSubList = {
          {win = WinName.EQUIPSTRENGWIN, icon = "#scene/scene_menuStrengthenBtn.png", name = "强化",},--强化
	      {win = WinName.EQUIPBAPTIZEWIN, icon = "#scene/scene_menuWashsBtn.png", name = "洗练",},--洗练
	      --{win = WinName.EQUIPDECOMPOSEWIN, icon = "#scene/main_decomposeIcon.png", name = "#main_decomposeTxt.png",},
	      {win = WinName.EQUIPCOMPOSEWIN, icon = "#scene/scene_menuPurifyBtn.png", name = "提纯",},--提纯
	      {win = WinName.EQUIPPRODUWIN, icon = "#scene/scene_menuMakeBtn.png", name = "打造",},--打造
	      {win = WinName.EQUIPEXTENDSWIN, icon = "#scene/scene_menuInherianceBtn.png", name = "继承",}, --继承
	      {win = WinName.MEDALUPWIN, icon = "#scene/scene_menuMedalBtn.png", name = "勋章",}, --勋章
	      {win = WinName.EQUIPSOULWIN, icon = "#scene/scene_menuEquipSoulBtn.png", name = "铸魂",}, --铸魂
    }

	self.oldScale = 0
	self.mainSceneUI = sceneUI
	GlobalModel.hideNavigation = false
	self.leftBtnItemList = {}
	self.rightBtnItemList = {}
	self.equipBtn = nil

	self.btnLayer = display.newNode()
	-- layer:setPosition(display.cx, display.cy)
	self.btnLayer:setTouchEnabled(false)
	self.btnLayer:setAnchorPoint(0,0)
	self.btnLayer:pos(0, 4)
	self:addChild(self.btnLayer)

	--self.mpClippingRegion:setClippingRegion(cc.rect(-20, 0, 40, 80))

	--self:setPosition((display.width-946)/2,0)

	--气血和蓝
	self.yyOffSet = -10
	self.hpClippingRegion = cc.ClippingRegionNode:create()
	self.hpClippingRegion:setAnchorPoint(0,0)
	self.hpClippingRegion:setPosition(display.cx-97+55,15+self.yyOffSet)
	self:addChild(self.hpClippingRegion)
	self.hpPic = display.newSprite("#scene/scene_redHpPic.png")
	self.hpClippingRegion:addChild(self.hpPic)
	self.hpPic:setAnchorPoint(0,0)
	--self.hpClippingRegion:setClippingRegion(cc.rect(-20, 0, 40, 80))

	self.mpClippingRegion = cc.ClippingRegionNode:create()
	self.mpClippingRegion:setAnchorPoint(0,0)
	self.mpClippingRegion:setPosition(display.cx-97+92,15+self.yyOffSet)
	self:addChild(self.mpClippingRegion)

	self.mpPic = display.newSprite("#scene/scene_blueMpPic.png")
	self.mpClippingRegion:addChild(self.mpPic)
	self.mpPic:setAnchorPoint(0,0)

	self.hpMpBg = display.newSprite("#scene/scene_qixuekuang.png")
	self:addChild(self.hpMpBg)
	self.hpMpBg:setPosition(display.cx,52+self.yyOffSet)

	self.hpMpBtn = display.newSprite("#scene/scene_useSkillBtn.png")
	self.hpMpBtn:setScale(1.1)
	self:addChild(self.hpMpBtn)
	self.hpMpBtn:setOpacity(1)
	self.hpMpBtn:setPosition(display.cx,56+self.yyOffSet)
	self.hpMpBtn:setTouchEnabled(true)
	self.hpMpBtn:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
			if event.name == "began" then
			elseif event.name == "ended" then
			if GlobalModel.hideNavigation then
				self:showBtn(true)
			else
				self:hideBtn(true)
			end
			end
			return true
	    end)


	--经验条
	self.expBarBg = display.newSprite("#scene/scene_expBar.png") --display.newSprite("#scene/scene_expBar.png")
	self.expBarBg:setScaleX(display.width/16)
	self.expBarBg:setAnchorPoint(0,0)
	self:addChild(self.expBarBg)

	self.expBar = display.newSprite("#scene/scene_expPic.png") --4*4
	self.expBar:setAnchorPoint(0,0.5)
	self.expBar:setPosition(1,5)
	self:addChild(self.expBar)

	-- 经验
    self.expLab = display.newBMFontLabel({
            text = "",
            font = "fonts/bitmapText_22.fnt",
            })
    self.expLab:setTouchEnabled(false)
    self:addChild(self.expLab)
    self.expLab:setPosition(display.cx,-4)
    self.expLab:setAnchorPoint(0.5,0)
    self.expLab:setScale(0.9)
    --self.expLab:setColor(cc.c3b(228, 228, 228))

	
    self:update()

	if self.roleBaseAttEventId == nil then
		local function onUpdate()
        	self:update()
    	end
		self.roleBaseAttEventId = GlobalEventSystem:addEventListener(RoleEvent.UPDATE_ROLE_BASE_ATTR,onUpdate)
	end
	GlobalEventSystem:addEventListener(SceneEvent.OPEN_NAV, function()
		self:showBtn(false)
		end)
	GlobalEventSystem:addEventListener(SceneEvent.HIDE_NAV, function()
		self:hideBtn(true)
		end)
	self:showBtn(false)
	self:updateNaviBtn()

	if self.functionOpenEventId == nil then
        self.functionOpenEventId = GlobalEventSystem:addEventListener(GlobalEvent.UPDATE_FUNCTION_OPEN,handler(self,self.updateNaviBtn))
    end

    self:showClickChangSkillTips()
end

function BottomExpHpUI:updateNaviBtn()
	local posx = display.cx - 30
	for i=#ParamLeftList,1,-1 do
		local conf = ParamLeftList[i]
		if FunctionOpenManager:getFunctionOpenByWinName(conf.win) then
			local item = self.leftBtnItemList[i]
			local isNew = false
			if item == nil then
				isNew = true
				item = NavigationBtn.new(conf)
				if conf.win == EQUIP_SUB_MARK then
					local dd = BaseTipsBtn.new(BtnTipsType.BTN_EQUIP,item)
				elseif conf.win == WinName.MAINROLEWIN then--角色
					local dd = BaseTipsBtn.new(BtnTipsType.BTN_ROLE,item)
				end

				item:setConfig(conf)
				self.leftBtnItemList[i] = item
				--item:setVisible(false)
				item:setPosition(posx-72,40)
				self.btnLayer:addChild(item)
				item:setTouchEnabled(true)
				item:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
					if event.name == "began" then
						item:setScale(1.1)
					elseif event.name == "ended" then
						item:setScale(1)
						self:onItemClick(item)
					end
					return true			
			    end)

			    if conf.win == EQUIP_SUB_MARK then
			    	self.equipBtn = item
			    end
			end
			item:stopAllActions()
			if isNew then
				local action1 = cc.DelayTime:create(0.2)
				local action2 = cc.CallFunc:create(function()
					item:setVisible(true)
					--item:setScale(0.1)
				end)
				local action3 = cc.ScaleTo:create(0.1, 1, 1)
                --item:runAction(transition.sequence({action1,action2,action1,action3}))
			else
				local action1 = cc.MoveTo:create(0.15, cc.p(posx-72,40))
				item:runAction(action1)
			end
			posx = posx - 72
		end
	end


	posx = display.cx + 30
	for i=1,#ParamRightList do
		local conf = ParamRightList[i]
		if FunctionOpenManager:getFunctionOpenByWinName(conf.win) then
			local item = self.rightBtnItemList[i]
			local isNew = false
			if item == nil then
				isNew = true
				item = NavigationBtn.new(conf)
				if conf.win == WinName.GUILDWIN then--行会
					local dd = BaseTipsBtn.new(BtnTipsType.BTN_ACTIVE_GUILD,item)
				elseif conf.win == WinName.EXCHANGEWIN then--交易所
					local dd = BaseTipsBtn.new(BtnTipsType.BTN_ACTIVE_EXCHAGE,item)
				elseif conf.win == WinName.SYSOPTIONWIN then--设置
					local dd = BaseTipsBtn.new(BtnTipsType.BIN_SET,item)
				end
				item:setConfig(conf)
				self.rightBtnItemList[i] = item
				--item:setVisible(false)
				item:setPosition(posx+72,40)
				self.btnLayer:addChild(item)
				item:setTouchEnabled(true)
				item:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
					if event.name == "began" then
						item:setScale(1.1)
					elseif event.name == "ended" then
						item:setScale(1)
						self:onItemClick(item)
					end				
					return true			
			    end)
			end
			item:stopAllActions()
			if isNew then
				local action1 = cc.DelayTime:create(0.2)
				local action2 = cc.CallFunc:create(function() 
					item:setVisible(true)
					--item:setScale(0.1)
				end)
				local action3 = cc.ScaleTo:create(0.1, 1, 1)
                --item:runAction(transition.sequence({action1,action2,action1,action3}))
			else
				local action1 = cc.MoveTo:create(0.15, cc.p(posx+72,40))
				item:runAction(action1)
			end
			posx = posx + 72
		end
	end
end

-- 显示装备二级菜单视图
function BottomExpHpUI:showEquipSubMenuView()
	if self.equipBtn then
		self:onItemClick(self.equipBtn)
	end
end

function BottomExpHpUI:onItemClick(item)
	if self.curSelItem then
		self.curSelItem:setSelect(false)
	end
	self.curSelItem = item
	self.curSelItem:setSelect(true)
	self:onClick(item:getConfig())
end

function BottomExpHpUI:resetCurItem() 
    if self.curSelItem then
		self.curSelItem:setSelect(false)
		self.curSelItem = nil
	end
end

function BottomExpHpUI:update()
	local roleInfo = RoleManager:getInstance().roleInfo
    local roleWealth = RoleManager:getInstance().wealth

    local needExp = getConfigObject(roleInfo.lv,PlayerUpgradeConf).need_exp
    local newScale = (roleInfo.exp/needExp)
   
    -- self.expBar:setScaleX((display.width-2)*newScale/4)

    --transition.scaleTo(self.expBar, {scaleX = (display.width-2)*newScale/4, time = 0.5})
    --self.expBar:stopAllActions()
    if self.expBarAction then
	    self.expBar:stopAction(self.expBarAction)
	end
    self.expBarAction = self.expBar:runAction(cc.ScaleTo:create(0.3, (display.width-2)*newScale/4, 1))

	if needExp == 0 then
		--self.expLab:setString(roleInfo.exp..":0;0=<")
		self.expLab:setString("")
	else
		self.expLab:setString(roleInfo.exp.."/"..needExp)
		--self.expLab:setString(roleInfo.exp.."/"..needExp.."("..math.floor((roleInfo.exp/needExp)*100).."%)")
	end
	self.hpClippingRegion:setClippingRegion(cc.rect(0, 0, 44, math.min(math.max(75*(roleInfo.cur_hp/roleInfo.hp)+5,5),80)))
    self.mpClippingRegion:setClippingRegion(cc.rect(0, 0, 43, math.min(math.max(75*(roleInfo.cur_mp/roleInfo.mp)+5,5),80)))
end

function BottomExpHpUI:onFightClick()
	local sceneId = (RoleManager:getInstance().roleInfo.hookSceneId or 10001)
	if GameSceneModel.sceneId ~= sceneId then
		GameNet:sendMsgToSocket(13001, {scene_id = sceneId})
	end

	self:closeWin()
end

function BottomExpHpUI:onClick(data)
	--GlobalEventSystem:addEventListener(GlobalEvent.SHOW_NAVIGATION,onShowNavigation)
	--GlobalWinManger:openWin(self.curWinName,true)
	--GlobalEventSystem:dispatchEvent(GlobalEvent.SHOW_NAVIGATION,{visible = false})
	local openWinName = data.win
	if openWinName == "11" then
		GlobalEventSystem:dispatchEvent(GlobalEvent.SCENE_SWITCH,SCENE_LOGIN)
	end

	if openWinName == "22" then
		--GameNet:sendMsgToSocket(13001, {scene_id = 10002})
	end
 
	if openWinName == "" then
		GlobalMessage:show("该功能未开放！")
		return
	end

	-- 关闭旧窗口
	self:closeWin()

	-- 打开新的窗口
	self.curWin = openWinName
	if self.curWin and self.curWin ~= "" then
		-- 如果点击的是二级菜单入口，则打开二级菜单
		if openWinName == EQUIP_SUB_MARK then
			self:showSubItems(self.euiqpSubList)
		else
			-- 判断此功能是否开启，如果开启则打开，否则显示提示。
			if FunctionOpenManager:getFunctionOpenByWinName(self.curWin) then
				-- 如果有旧的二级窗口，则关掉它。
				if self.subView then
					self.subView:setVisible(false)
				end
				--装备打造特殊处理
			 	if self.curWin == "equipProduWin" then
			 		GlobalWinManger:openWin(self.curWin,2)
			 	elseif self.curWin == "wingUp" then
			 		local wing = GlobalController.wingUp:getCurTempWing()
			 		if wing and wing.expire_time <= socket.gettime() then
			 			GlobalWinManger:openWin(WinName.UPGRADEWINGTIPSVIEW)
			 		else
			 			GlobalWinManger:openWin(self.curWin)
			 		end
			 	else
			 		GlobalWinManger:openWin(self.curWin)
			 	end
				
			else
				FunctionOpenManager:showFunctionOpenTips(self.curWin)
			end
		end

		self:confirmGuide(self.curWin)
	end
end

function BottomExpHpUI:showSubItems(items)
	-- 如果有旧的二级窗口，则关掉它。
	if self.subView  then
		self.subView:setVisible(true)
	end

	--先过滤翅膀
    self:checkWing()
	-- 入口过滤
	-- 判断此功能是否开启，如果开启则打开，否则显示。
	local subItems = {}
	for _, v in pairs(items) do
		if FunctionOpenManager:getFunctionOpenByWinName(v.win) then
			subItems[#subItems + 1] = v
		end
	end
	if self.subView == nil then
		self.subView = NavigationSubView.new()
		self:addChild(self.subView)
		self.subView:setOnItemClickeHandler(handler(self, self.onClick))
	end
	if #subItems == 0 then
		self.subView:setVisible(false)
	end
	self.subView:setConfig(subItems)
	self.subView:setPosition(self.curSelItem:getPositionX(), self.curSelItem:getPositionY() + 40)
	--GlobalEventSystem:dispatchEvent(GlobalEvent.SHOW_BOX, subView)
	
	
	--GlobalEventSystem:dispatchEvent(EquipEvent.EQUIP_TIP,Equip_tip.EQUI_TIP_MEDAL)
end

--检查翅膀
function BottomExpHpUI:checkWing()
	if nil ~= self.isAddWingBtn then
		return
	end
	local equipList = RoleManager:getInstance().roleInfo.equip
    for i=1,#equipList do
        local subTypeName,subType = configHelper:getEquipTypeByEquipId(equipList[i].goods_id)
        if subType == 13 then -- 翅膀
        	table.insert(self.euiqpSubList, {win = WinName.WINGWIN, icon = "#scene/scene_menuWingBtn.png",name = "翅膀"})
        	self.isAddWingBtn = true
        	break
        end
    end
end

--
-- 根据点击的窗口名，来发出引导确认事件。
--
function BottomExpHpUI:confirmGuide(winName)
	local op = GUIMR.OMT_NAV_OPS[winName]
	if op then
		GlobalController.guide:notifyEventWithConfirm(op)
	end
end

function BottomExpHpUI:closeWin()
	if self.curWin and self.curWin ~= "" then
		if self.curWin ~= EQUIP_SUB_MARK then
			GlobalWinManger:closeWin(self.curWin,true) 
		end
	end

	self.curWin = ""
end

function BottomExpHpUI:setViewVisible(b)
	self:setVisible(b)
	-- for i=1,#self.btnList do
	-- 	self.btnList[i]:setVisible(b)
	-- end
end

function BottomExpHpUI:showBtn(ismove)
	if GlobalModel.hideNavigation == false and ismove == false then return end
	local pos
	GlobalModel.hideNavigation = false
	pos = cc.p(0, 4)
	if ismove then
		self.btnLayer:stopAllActions()
		self.btnLayer:setVisible(true)
		local action1 = cc.MoveTo:create(0.2, pos)
		local action2 = cc.CallFunc:create(function()
			self.btnLayer:setVisible(true)
			end)
		local action4 = transition.sequence({action1,action2})
		self.btnLayer:runAction(action4)
	else
		self.btnLayer:setVisible(true)
		self.btnLayer:setPosition(pos.x,pos.y)
	end
	if self.mainSceneUI then
		self.mainSceneUI:updateSkillViewPos()
	end
	self:showClickChangSkillTips()
end

function BottomExpHpUI:showClickChangSkillTips()
	if RoleManager:getInstance().roleInfo.lv < 16 then
		if self.changSkillTips == nil then
			self.changSkillTips = display.newSprite("#scene/scene_clickChangSkill.png")
			self.changSkillTips:setOpacity(180)
			self:addChild(self.changSkillTips)
			self.changSkillTips:setPosition(display.cx,56+self.yyOffSet)
		end
		self.changSkillTips:setVisible(true)
	end
end

function BottomExpHpUI:hideBtn(ismove)
	if GlobalModel.hideNavigation == true then return end
	local pos
	if GlobalModel.hideNavigation then
		GlobalModel.hideNavigation = false
		--GlobalEventSystem:dispatchEvent(SceneEvent.SCENE_UI_HIDE,true)
		pos = cc.p(0,-100)
	else
		GlobalModel.hideNavigation = true
		--GlobalEventSystem:dispatchEvent(SceneEvent.SCENE_UI_HIDE,false)
		pos = cc.p(0, 4)
	end
	GlobalModel.hideNavigation = true
		--GlobalEventSystem:dispatchEvent(SceneEvent.SCENE_UI_HIDE,false)
	pos = cc.p(0,-100)
	if ismove then
		self.btnLayer:stopAllActions()
		self.btnLayer:setVisible(true)
		local action1 = cc.MoveTo:create(0.2, pos)
		local action2 = cc.CallFunc:create(function() 
			self.btnLayer:setVisible(false)
			end)
		local action4 = transition.sequence({action1,action2})
		self.btnLayer:runAction(action4)
	else
		self.btnLayer:setVisible(false)
		self.btnLayer:setPosition(pos.x,pos.y)
	end

	if self.mainSceneUI then
		self.mainSceneUI:updateSkillViewPos()
	end
	if self.changSkillTips then
		self.changSkillTips:setVisible(false)
	end
end


function BottomExpHpUI:destory()
	self.mainSceneUI = nil
	if self.roleBaseAttEventId then
		GlobalEventSystem:removeEventListenerByHandle(self.roleBaseAttEventId)
		self.roleBaseAttEventId = nil
	end
	GlobalEventSystem:removeEventListener(SceneEvent.OPEN_NAV)
	GlobalEventSystem:removeEventListener(SceneEvent.HIDE_NAV)
	if self.functionOpenEventId then
        GlobalEventSystem:removeEventListenerByHandle(self.functionOpenEventId)
        self.functionOpenEventId = nil
    end
    self.expBarAction = nil
 	self.expBar:stopAllActions()
end


return BottomExpHpUI