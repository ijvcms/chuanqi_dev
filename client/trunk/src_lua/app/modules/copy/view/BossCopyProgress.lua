--
-- Author: Yi hanneng
-- Date: 2016-07-28 09:27:50
--

--[[
----------------------个人boss副本进度------------------
--]]
local scheduler = require(cc.PACKAGE_NAME .. ".scheduler")
local BossCopyProgress = BossCopyProgress or class("BossCopyProgress", function() return display.newNode() end )

function BossCopyProgress:ctor()
	self.ccui = cc.uiloader:load("resui/BossCopyProgress_1.ExportJson")
  	self:addChild(self.ccui)
   	self:init()
end

function BossCopyProgress:init()

	self.itemList = {}

	self.retractBtn = cc.uiloader:seekNodeByName(self.ccui, "retractBtn")
	self.retractBtn:setScaleX(-1)
	self.barLabel = cc.uiloader:seekNodeByName(self.ccui, "timeLabel")
	self.amount = cc.uiloader:seekNodeByName(self.ccui, "number1")
 	self.bg = cc.uiloader:seekNodeByName(self.ccui, "bg")
 	self.bg:setOpacity(180)
	self.btnState = true

	self.retractBtn:setTouchEnabled(true)
	self.retractBtn:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
        if event.name == "began" then
        	if self.btnState then
        		
        	else
        		
        	end
        elseif event.name == "ended" then
             if self.btnState then
             	
             	self:hide()	
             else
             
             	self:show()
			 
             end
 
        end
        return true
    end)

	 
	GlobalEventSystem:addEventListener(CopyEvent.COPY_BOSS_UPDATE,handler(self,self.setViewInfo))
	GameNet:sendMsgToSocket(11045)
end

function BossCopyProgress:hide()
	
	local action = cc.MoveTo:create(0.3, cc.p(-190, self:getPositionY()))	
    local action2 = cc.CallFunc:create(function() 
	    --self.retractBtn:setScaleX(-1)
	    self.retractBtn:setScaleX(1)
	    self.btnState = false 
    end)       
    self:stopAllActions()
	self:runAction(transition.sequence({action,action2}))

end

function BossCopyProgress:show()
	local action = cc.MoveTo:create(0.3, cc.p(0, self:getPositionY()))			
	local action3 = cc.CallFunc:create(function()
		self.retractBtn:setScaleX(-1)
		--self.retractBtn:setScaleX(1)
		self.btnState = true 
	end)     
	self:stopAllActions()  
	self:runAction(transition.sequence({action,action3}))
end

function BossCopyProgress:setViewInfo(data)
	if data == nil then
		return
	end
	data = data.data
 	self.time = data.left_time
 	self.amount:setString(data.left_boss)

 	if self.cdEventId == nil then
 		self.cdEventId = scheduler.scheduleGlobal(function()

	 	if self.time > 0 then
	 		self.time = self.time - 1
	 	else
	 		self.time = 0
	 	end

	 	self.barLabel:setString(StringUtil.convertTime(self.time))

	 	if self.time <= 0 then
	 		scheduler.unscheduleGlobal(self.cdEventId)
	        self.cdEventId = nil
	 	end

	    end,1)
 	end

end

function BossCopyProgress:destory()
	self:stopAllActions()
	if self.cdEventId then
		scheduler.unscheduleGlobal(self.cdEventId)
	    self.cdEventId = nil
	end
	GlobalEventSystem:removeEventListener(CopyEvent.COPY_BOSS_UPDATE)
	self:removeSelf()
end

function BossCopyProgress:close()
	self:destory()
end

return BossCopyProgress