--
-- Author: 21102585@qq.com
-- Date: 2014-11-05 10:56:13
-- 游戏场景
require("app.gameui.BaseTipsBtn")
require("app.modules.equip.EquipManager")
require("app.modules.fight.view.SceneRole")

local MainScene = class("MainScene", function()
    return display.newScene("MainScene")
end)

MainScene.nodeAutoUseSpecialSkill = nil

function MainScene:ctor()
	display.addSpriteFrames("resui/navBtn.plist", "resui/navBtn.png")
	display.addSpriteFrames("resui/com.plist", "resui/com.png")
	display.addSpriteFrames("resui/scene.plist", "resui/scene.png")
	if self.showSceneLoadingEventId == nil then
        self.showSceneLoadingEventId = GlobalEventSystem:addEventListener(GlobalEvent.SHOW_SCENE_LOADING,handler(self,self.showLoading))
    end
    BtnTipManager:init()
    
	if self.scene == nil then
		self.scene = require("app.gameScene.display.SceneMainView").new()
		self:addChild(self.scene)
	end
	GlobalController.fight:setScene(self.scene)

	self.bg = self:creatLayer() 			--背景层
	self.main = self:creatLayer() 			--主框架层
	self.game = self:creatLayer() 			--游戏层
	--动态表情
	-- if self.faceView == nil then
	-- 	self.faceView = require("app.modules.face.view.FaceView").new()
	-- 	self:addChild(self.faceView)
	-- end
	self.guide = self:creatLayer() 			--引导层
	self.tooltips = self:creatLayer() 		--toolTip层
	self.messagelyr = self:creatLayer() 	--信息提示层
	
	if self.autoDrugListener == nil then
		self.autoDrugListener = require("app.modules.sysOption.AutoDrugListener").new()
		self:addChild(self.autoDrugListener)
	end

	if not self.nodeAutoUseSpecialSkill then
	--	self.nodeAutoUseSpecialSkill = require("app.modules.sysOption.AutoUseSpecialSkillListener").new()
	--	self:addChild(self.nodeAutoUseSpecialSkill)
	end
	-- self.messagelyr:setTouchEnabled(true)
	-- self.messagelyr:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
		
	-- 	local childs = self.messagelyr:getChildren()
	-- 	print(self.messagelyr:getChildrenCount(),childs[1])
	-- 	print(childs[1]:isTouchEnabled(),childs[1]:isTouchCaptureEnabled())
       
 --        return true
 --    end)
    if self.statusBar == nil then
    	self.statusBar = require("app.gameui.statusBar.StatusBar").new()
    	local size = self.statusBar:getContentSize()
    	self.statusBar:setPosition(display.width - size.width, size.height / 2)
		self:addChild(self.statusBar)
    end
    if DEBUG_LOGIN == false then
      	ChannelAPI:setLoginCallbackHandler(handler(self,self.setLoginCallback))
      	ChannelAPI:setLogoutCallbackHandler(handler(self,self.setLogoutCallback))
  	end

    self:addBackEvent()
end

function MainScene:showNetLoading(data)
	if data.data then
		if self.socketLoading == nil then
			self.socketLoading = require("app.gamenet.LoginNetLoading").new()
			self:addChild(self.socketLoading)
		end
	else
		if self.socketLoading then
			self.socketLoading:close()
		end
		self.socketLoading = nil
	end
end


--第三方登出成功
function MainScene:setLoginCallback(data)
	local  jsonData = json.decode(data.ret)
    if jsonData.code == 1 then
    	if GlobalModel.open_id ~= jsonData.open_id then
	    	GlobalModel.open_id = jsonData.open_id
	    	GlobalController.login:connectSocket()
	    	GlobalEventSystem:dispatchEvent(GlobalEvent.SCENE_SWITCH,SCENE_LOGIN)

		end
    else
    	GlobalEventSystem:dispatchEvent(GlobalEvent.SCENE_SWITCH,SCENE_LOGIN)
    end
	
end

--第三方登出成功
function MainScene:setLogoutCallback()
    GameNet:sendMsgToSocket(10007,{flag=2})
end

--进入场景
function MainScene:onEnter()
	self:initGlobalEventListeners()
	self:showLoading({data = true})
	-- self.navigationView:setViewVisible(false)
	--self:switchView(1)
	--local sceneId = (RoleManager:getInstance().roleInfo.hookSceneId or 10001)
	--self:changScene({sceneId = 0})
	GlobalModel.initViewOK = true
	GlobalModel.firstInitScene = false
	if GlobalModel.initDataOK and GlobalModel.initViewOK then
		GameNet:sendMsgToSocket(11001, {})--11001, {scene_id = 0}
	end

	--self:changScene({sceneId = sceneId})
	--两秒后获取挂机奖励
	-- local action1 = cc.DelayTime:create(0.8)
 -- 	local action2 = cc.CallFunc:create(function() GameNet:sendMsgToSocket(13009) end)
 -- 	local action4 = transition.sequence({action1,action2})
 -- 	self:runAction(action4)
 --GlobalEvent.SHOW_SCENE_LOADING
 	if self.showSceneLoadingEventId == nil then
        self.showSceneLoadingEventId = GlobalEventSystem:addEventListener(GlobalEvent.SHOW_SCENE_LOADING,handler(self,self.showLoading))
    end

    GlobalEventSystem:dispatchEvent(EquipEvent.EQUIP_TIP,Equip_tip.EQUI_TIP_MEDAL)
    GlobalEventSystem:dispatchEvent(RoleEvent.RIDE_HONG_TIP)

    GlobalController.chat:callUiInitCompleted()
end



--
-- 初始化全局事件处理。
--
function MainScene:initGlobalEventListeners()
	if self.isListenerEvents then return end
	self.isListenerEvents = true

    --[[
      {{GLOBAL EVENT HANDLER}}
      全局事件处理 - 添加一个窗口至场景。
    ]]
	self.winShowEventHandler = GlobalEventSystem:addEventListener(GlobalEvent.WINDOW_ADD_SCENE, function(data)
		local window = data.data.view
		local layer  = data.data.layer

		if window and layer then
			--window:removeFromParent()--会清理事件，导致错误
			self[layer]:addChild(window)
		end
	end)

	--[[
      {{GLOBAL EVENT HANDLER}}
      全局事件处理 - 将一个窗口从其父窗口内移除。
    ]]
	self.winCloseEventHandler = GlobalEventSystem:addEventListener(GlobalEvent.WINDOW_CLOSE_SCENE, function(data)
		local window = data.data.view
		if window then
			local removeWin = window
		    GlobalTimer.performWithDelayGlobal(function(event)
                removeWin:removeFromParent()
            end ,0.05)--安全移除Node,别乱动
			window:setVisible(false)
		end
	end)

	--[[
      {{GLOBAL EVENT HANDLER}}
      全局事件处理 - 显示提示消息
    ]]
	self.msgShowEventHandler = GlobalEventSystem:addEventListener(GlobalEvent.SHOW_MESSAGE, function(data)
		local msgView = data.data
		if msgView then
			--msgView:removeFromParent()--会清理事件，导致错误
			self.messagelyr:addChild(msgView)
		end
	end)

    --[[
      {{GLOBAL EVENT HANDLER}}
      全局事件处理 - 显示提示窗口
    ]]
	self.boxShowEventHandler = GlobalEventSystem:addEventListener(GlobalEvent.SHOW_BOX, function(data)
		local boxView = data.data
		if boxView then
			--boxView:removeFromParent()--会清理事件，导致错误
			-- print("GG",boxView)
			self.messagelyr:addChild(boxView)
		end
	end)

	-- --[[
 --      {{GLOBAL EVENT HANDLER}}
 --      全局事件处理 - 显示导航栏
 --    ]]
	-- self.showNavigationEventHandler = GlobalEventSystem:addEventListener(GlobalEvent.SHOW_NAVIGATION, function(data)
	-- 	self:onShowNavigation(data.data)
	-- end)

	-- --[[
 --      {{GLOBAL EVENT HANDLER}}
 --      全局事件处理 - 显示装备二级菜单
 --    ]]
	-- self.showNavigationSubEventHandler = GlobalEventSystem:addEventListener(GlobalEvent.SHOW_NAVIGATION_EQUIP_SUB, function(data)
	-- 	self:onShowEquipSubMenuView()
	-- end)

	--[[
      {{GLOBAL EVENT HANDLER}}
      全局事件处理 - 改变游戏场景
    ]]
	self.changSceneEventHandler = GlobalEventSystem:addEventListener(FightEvent.CHANG_SCENE, function(view)
        self:changScene(view.data)
    end)

    if self.netLoadingEventId == nil then
        self.netLoadingEventId = GlobalEventSystem:addEventListener(GlobalEvent.SHOW_NET_LOADING,handler(self,self.showNetLoading))
    end
end

--
-- 移除全局事件处理。
--
function MainScene:removeGlobalEventListeners()
	if self.isListenerEvents then
		GlobalEventSystem:removeEventListenerByHandle(self.changSceneEventHandler)
		GlobalEventSystem:removeEventListenerByHandle(self.winShowEventHandler)
		GlobalEventSystem:removeEventListenerByHandle(self.winCloseEventHandler)
		GlobalEventSystem:removeEventListenerByHandle(self.msgShowEventHandler)
		GlobalEventSystem:removeEventListenerByHandle(self.boxShowEventHandler)
		-- GlobalEventSystem:removeEventListenerByHandle(self.showNavigationEventHandler)
		-- GlobalEventSystem:removeEventListenerByHandle(self.showNavigationSubEventHandler)
		
		self.changSceneEventHandler        = nil
		self.winShowEventHandler           = nil
		self.winCloseEventHandler          = nil
		self.msgShowEventHandler           = nil
		self.boxShowEventHandler           = nil
		

		self.isListenerEvents = false
	end

	GlobalEventSystem:removeEventListenerByHandle(self.netLoadingEventId)
	self.netLoadingEventId = nil
end

--
-- 改变当前游戏场景，并发送消息至服务器。
--
function MainScene:changScene(data)
	local sceneId = data.sceneId
	self.sceneId = sceneId
	local sceneConfig = getConfigObject(sceneId,ActivitySceneConf)
	if sceneConfig.story_reward == "" or sceneConfig.story_reward == nil then
		if GameSceneModel.sceneId == sceneId then
			GlobalAlert:show("已在场景中！")
		else
	        GameNet:sendMsgToSocket(11031, {scene_id = sceneId})
	    end
    else
    	GlobalWinManger:openWin(WinName.COPYPRIZETIPS,{sceneId = tonumber(self.sceneId),sendtype = 1})
    end
end

--退出场景
function MainScene:onExit()
	self.sceneId = 0
	GlobalAlert:destory()
	GlobalModel.initDataOK = false
	GlobalModel.initViewOK = false
	
	self:stopAllActions()
	self:removeGlobalEventListeners()
	SceneManager:clearTranferArr()
	
	if self.showSceneLoadingEventId then
        GlobalEventSystem:removeEventListenerByHandle(self.showSceneLoadingEventId)
        self.showSceneLoadingEventId = nil
    end
    self:showLoading({data = false})

    self:showNetLoading({data = false})
    GlobalController.guide:stopGuide()
	GlobalController.fight:destory()

	ArmatureManager:getInstance():destory()
	FightEffectManager:destory()
	GameSceneModel:clear()
	FightModel:destory()
	if self.scene then
		self.scene:destory()
		self:removeChild(self.scene)
		self.scene = nil
	end
	-- if self.navigationView then
	-- 	self.navigationView:destory()
	-- 	self:removeChild(self.navigationView)
	-- 	self.navigationView = nil
	-- end
	if self.chatView then
		self.chatView:destory()
		self:removeChild(self.chatView)
		self.chatView = nil
	end

	if self.autoDrugListener then
		self.autoDrugListener:destory()
		self:removeChild(self.autoDrugListener)
		self.autoDrugListener = nil
	end

	if self.nodeAutoUseSpecialSkill then
		self.nodeAutoUseSpecialSkill:removeSelf()
		self.nodeAutoUseSpecialSkill =  nil
	end

	FightSkillManager:destory()
	GlobalWinManger:destory()
	BtnTipManager:destory()
    EquipManager:getInstance():clear()
    --ShowTipsManager:clear()
    SystemNotice:clear()
end	

--创建层
function MainScene:creatLayer()
	local layer = display.newNode()
	-- layer:setPosition(display.cx, display.cy)
	layer:setTouchEnabled(false)
	layer:setAnchorPoint(0,0)
	layer:pos(0, 0)
	self:addChild(layer)
	return layer
end	



-- function MainScene:onShowNavigation(param)
-- 	if self.navigationView then
-- 		if param.visible then
-- 			self.navigationView:setViewVisible(true)
-- 		else
-- 			self.navigationView:setViewVisible(false)
-- 		end
-- 	end
-- end

-- function MainScene:onShowEquipSubMenuView()
-- 	if self.navigationView then
-- 		self.navigationView:showEquipSubMenuView()
-- 	end
-- end

--场景进度条
function MainScene:showLoading(data)
    if data.data then
        if self.loading == nil then --and self.sceneId ~= GameSceneModel.sceneId  then
            self.loading = require("app.gameScene.loading.LoadingSceneUI").new()
            self:addChild(self.loading)
            GlobalEventSystem:dispatchEvent(LoginEvent.STOP_CHECK_HEART)
        end
        self.loading:open()
    else
        if self.loading then
            self.loading:destory()
            self:removeChild(self.loading)
            self.loading = nil
            GlobalEventSystem:dispatchEvent(GlobalEvent.HIDE_SCENE_LOADING)
            GlobalEventSystem:dispatchEvent(LoginEvent.START_CHECK_HEART)
        end
    end
    GlobalEventSystem:dispatchEvent(GlobalEvent.SHOW_NAVIGATION,{visible = (data.data==false)})
end


function MainScene:switchView(index)
	if self.curWinName ~= nil and self.curWinName ~= "" then
		GlobalWinManger:closeWin(self.curWinName)
		self.curWinName = nil
	end
	if index == 1 then
		self.curWinName = WinName.FIGHT--MAINVIEW--FIGHT--MAINROLE，WinName.MAINVIEW
    elseif index == 2 then
         self.curWinName = WinName.MAINROLE				
    elseif index == 3 then
         				
    end
    if self.curWinName and self.curWinName ~= "" then
     	GlobalWinManger:openWin(self.curWinName)
    end
end

function MainScene:addBackEvent()
  if device.platform == "android" then
    self.main:addNodeEventListener(cc.KEYPAD_EVENT, function(event)
        if event.key == "back" then
            local exitFun = function()
                local function enterFun()
                    os.exit()
                end

                GlobalAlert:pop({tipTxt = "是否确定退出游戏?",enterFun = handler(self, enterFun),hideBackBtn = false,alertName = "hasExitGame"})

                -- GlobalMessage:alert({
                --     enterTxt = "确定",
                --     backTxt= "取消",
                --     tipTxt = "是否确定退出游戏?",
                --     enterFun = handler(self, enterFun),
                --     tipShowMid = true,
                -- })
            end
            if DEBUG_LOGIN then
                exitFun()
            else
                ChannelAPI:exit(exitFun)
            end
        end
    end)
    self.main:setKeypadEnabled(true)
  end 
end

return MainScene