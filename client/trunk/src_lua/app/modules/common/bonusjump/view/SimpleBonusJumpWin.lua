local SimpleBonusJumpWin = SimpleBonusJumpWin or class("SimpleBonusJumpWin",BaseView)

SimpleBonusJumpWin.SimpleBonusJumpPresenter = require("app.modules.common.bonusjump.controller.SimpleBonusJumpPresenter")
SimpleBonusJumpWin.SimpleBonusJumpModel = require("app.modules.common.bonusjump.model.SimpleBonusJumpModel")


SimpleBonusJumpWin.cloesBtn = nil
SimpleBonusJumpWin.enterBtn = nil
SimpleBonusJumpWin.helpBtn = nil

SimpleBonusJumpWin.bonusItems = nil

SimpleBonusJumpWin.presenter = nil

SimpleBonusJumpWin.itemSize = 6

function SimpleBonusJumpWin:createModel()
	local conf = configHelper:getDarkHouseGoods(12)  --这里只是个Demo
	local dropList = nil
	if conf then
		dropList = conf.drop_list
	end
	local model = self.SimpleBonusJumpModel.new(winTag,data,winconfig,dropList)
	return model
end

function SimpleBonusJumpWin:initPresenter()
	local model = self:createModel()
	self.presenter = self.SimpleBonusJumpPresenter.new()
	self.presenter:setModel(model)
    self.presenter:setDelegate(self)
end

function SimpleBonusJumpWin:ctor(winTag, data, winconfig)
	SimpleBonusJumpWin.super.ctor(self, winTag, data, winconfig)
	
	local root = self:getRoot()
    root:setAnchorPoint(0.5, 0.5)
    root:setPosition(display.width/2.0, display.height/2.0)

    
    self:init()
    self:addEvent()

    self:initPresenter()
end

function SimpleBonusJumpWin:init()
    self.closeBtn = self:seekNodeByName("closeBtn")
    self.enterBtn = self:seekNodeByName("enterBtn")
    self.helpBtn = self:seekNodeByName("helpBtn")

    self.bonusItems = {}
    for i=1,self.itemSize do
    	local item = self:seekNodeByName("Item"..i)
    	if not item then
    		break
    	end 
    	item:setVisible(false)
    	table.insert(self.bonusItems,item)
    end

end

function SimpleBonusJumpWin:addEvent()
    -- 关闭按钮
    if self.closeBtn then
    	self.closeBtn:setTouchEnabled(true)
	    self.closeBtn:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
	        if event.name == "began" then
	            self.closeBtn:setScale(1.1)
	            SoundManager:playClickSound()
	            self.hasMoving = false
	        elseif "moved" == event.name then
	            local distance = math.abs(event.x - event.prevX)
	            if distance > 5 then
	                self.hasMoving = true
	            end
	        elseif event.name == "ended" then
	            self.closeBtn:setScale(1.0)
	            if not self.hasMoving then
	                self:onCloseClick()
	            end
	        end
	        return true
	    end)
    end

    if self.enterBtn then
    	self.enterBtn:setTouchEnabled(true)
	    self.enterBtn:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
	        if event.name == "began" then
	            self.enterBtn:setScale(1.1)
	            SoundManager:playClickSound()
	            self.hasMoving = false
	        elseif "moved" == event.name then
	            local distance = math.abs(event.x - event.prevX)
	            if distance > 5 then
	                self.hasMoving = true
	            end
	        elseif event.name == "ended" then
	            self.enterBtn:setScale(1.0)
	            if not self.hasMoving then
	                self:onEnterClick()
	            end
	        end
	        return true
	    end)
    end
    
     -- 进入按钮
    if self.helpBtn then
    	self.helpBtn:setTouchEnabled(true)
	    self.helpBtn:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
	        if event.name == "began" then
	            self.helpBtn:setScale(1.2)
	            SoundManager:playClickSound()
	        elseif event.name == "ended" then
	            self.helpBtn:setScale(1.0)
	            GlobalWinManger:openWin(WinName.PRIZERANK,{type = 1})
	        end     
	        return true
	    end)
    end

end

function SimpleBonusJumpWin:getItems()
	return self.bonusItems
end

-- 关闭按钮
function SimpleBonusJumpWin:onCloseClick()
    GlobalWinManger:closeWin(self.winTag)

end

function SimpleBonusJumpWin:onEnterClick()
	self.presenter:onEnterClick()
 --   local scene_id = 32112 -- 目前配置数据策划正在完善,还不知道从哪里能读取到这个值
--print("请求 11031 进入副本 scene_id = "..scene_id)
 --   GameNet:sendMsgToSocket(11031, {scene_id = scene_id})

    --GlobalEventSystem:dispatchEvent(FightEvent.CHANG_SCENE, {sceneId = scene_id})

end

-- 打开界面(自动调用)
function SimpleBonusJumpWin:open()
   -- self:setViewInfo()
    self.presenter:updateView()
end

-- 关闭界面(自动调用)
function SimpleBonusJumpWin:close()
	SimpleBonusJumpWin.super.close(self)
end

-- 清理界面(自动调用)
function SimpleBonusJumpWin:destory()
    SimpleBonusJumpWin.super.destory(self)

end

return SimpleBonusJumpWin