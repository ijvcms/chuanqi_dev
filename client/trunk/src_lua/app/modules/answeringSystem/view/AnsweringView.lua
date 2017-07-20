
--
-- Author: Shine
-- Date: 2016-07-26
--
--[[
-----------------趣味答题----------------
--]]

local AnsweringView =  class("AnsweringView", BaseView)

function AnsweringView:ctor(winTag,data,winconfig)
	--self:creatPillar()\
	self.ccuiFile = winconfig.url
	self.bg =  cc.LayerColor:create(cc.c4b(0,0,0,0))
	self.bg:setContentSize(display.width, display.height)
	self:setTouchEnabled(true)
	 self:setTouchSwallowEnabled(true)
	self:addChild(self.bg)
	AnsweringView.super.ctor(self,winTag,data,winconfig)
	local root = self:getRoot()

  	self:init()

end

function AnsweringView:init()
 
  	self.openTime = self:seekNodeByName("openTime1")
	self.enterBtn = self:seekNodeByName("confirmBtn")
	self.enterBtn:setTouchEnabled(true)
  	self.closeBtn = self:seekNodeByName("closeBtn")
  	self.closeBtn:setTouchEnabled(true)
  	self.helpBtn = self:seekNodeByName("helpBtn")
  	self.helpBtn:setTouchEnabled(true)
	
	
	 
	self.closeBtn:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
	        if event.name == "began" then
	            self.closeBtn:setScale(1.1)
	            SoundManager:playClickSound()
	        elseif event.name == "ended" then
	            self.closeBtn:setScale(1.0)
	            GlobalWinManger:closeWin(self.winTag)
	            self:removeSpriteFrames(self.ccuiFile)
	        end     
	        return true
    end)

    self.enterBtn:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
	        if event.name == "began" then
	            self.enterBtn:setScale(1.1)
	            SoundManager:playClickSound()
	        elseif event.name == "ended" then
	            self.enterBtn:setScale(1.0)
                GlobalController.answeringController:start()
            end     
	        return true
    end)

    self.helpBtn:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
	        if event.name == "began" then
	            self.closeBtn:setScale(1.1)
	            SoundManager:playClickSound()
	        elseif event.name == "ended" then
	            self.closeBtn:setScale(1.0)
	            local rewardView = require("app.modules.answeringSystem.view.AnsweringRewardView").new()
	            rewardView:setViewInfo()
	            GlobalEventSystem:dispatchEvent(GlobalEvent.SHOW_BOX, rewardView)  
	        end     
	        return true
    end)

end

function AnsweringView:setViewInfo(data)
	if data == nil then 
		data = configHelper:getDarkHouseGoods(5)
	end

	self.openTime:setString(data.open_time1)
	--self.openTime2:setString(data.open_time2)
  
	for i=1,#data.drop_list do
		
	  		local commonItem = CommonItemCell.new()
			commonItem:setData({goods_id = data.drop_list[i][1],is_bind = data.drop_list[i][2]})
			commonItem:setCount(data.drop_list[i][3])
			self:seekNodeByName("item"..i):addChild(commonItem, 10,10)
			commonItem:setPosition(commonItem:getContentSize().width/2 + 1, commonItem:getContentSize().height/2 + 2)
			commonItem:setScale(0.8)
	
  	end

end

function AnsweringView:open()
	self:setViewInfo(nil)
end

function AnsweringView:destory()
	--接着可能打开AnsweringMainView,不清理
end

function AnsweringView:close()
end

return AnsweringView
