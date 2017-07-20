--
-- Author: Yi hanneng
-- Date: 2016-03-10 09:51:04
--
local scheduler = require(cc.PACKAGE_NAME .. ".scheduler")
local WinnerList = WinnerList or class("WinnerList", function() return display.newNode() end )

function WinnerList:ctor()
	self.ccui = cc.uiloader:load("resui/WinnerList.ExportJson")
  	self:addChild(self.ccui)
   	
   	self:init()
end

function WinnerList:init()

	self.itemList = {}

	self.retractBtn = cc.uiloader:seekNodeByName(self.ccui, "retractBtn")
	self.retractBtn:setScaleX(-1)
	self.layer = cc.uiloader:seekNodeByName(self.ccui, "mainLayer")

	self.bar = cc.uiloader:seekNodeByName(self.ccui, "bar")
	self.barLabel = cc.uiloader:seekNodeByName(self.ccui, "barLabel")
	self.amount = cc.uiloader:seekNodeByName(self.ccui, "amount")
 
	self.showPoint = self.layer:getPositionX()
	self.hidePoint = self.layer:getPositionX() - 178
	self.btnState = true

	self.retractBtn:setTouchEnabled(true)
	self.retractBtn:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
        if event.name == "began" then

        elseif event.name == "ended" then
        	
             if self.btnState then

             	self:hide()	
             else
             	
             	self:show()
			 
             end
 
        end
        return true
    end)

	 
	GlobalEventSystem:addEventListener(WinnerEvent.WINNER_UPDATE_INFO,handler(self,self.setViewInfo))
end

function WinnerList:hide()
	if self.layer then
		--todo
	local action = cc.MoveTo:create(0.3, cc.p(self.hidePoint, self.layer:getPositionY()))	
    local action2 = cc.CallFunc:create(function() 
	    --self.retractBtn:setScaleX(-1)
	    self.retractBtn:setScaleX(1)
	    self.btnState = false 
    end)       
    self.layer:stopAllActions()
	self.layer:runAction(transition.sequence({action,action2}))
	end

end

function WinnerList:show()
	if self.layer then
	local action = cc.MoveTo:create(0.3, cc.p(self.showPoint, self.layer:getPositionY()))					
	local action3 = cc.CallFunc:create(function()
		self.retractBtn:setScaleX(-1)
		--self.retractBtn:setScaleX(1)
		self.btnState = true 
	end)     
	self.layer:stopAllActions()  
	self.layer:runAction(transition.sequence({action,action3}))
end

end

function WinnerList:setViewInfo(data)

	data = data.data
 
	--设置自己排名和伤害

	self.bar:setPercent(data.time/data.total_time*100)
 	self.amount:setString(data.the_number)

 	if self.cdEventId == nil then
 		self.time = data.time
 		self.barLabel:setString(StringUtil.convertTime(data.time))
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

function WinnerList:destory()
	if self.cdEventId then
		scheduler.unscheduleGlobal(self.cdEventId)
	    self.cdEventId = nil
	end
	GlobalEventSystem:removeEventListener(WinnerEvent.WINNER_UPDATE_INFO)
	self:removeSelf()
end

function WinnerList:close()
	
	self:destory()
end

return WinnerList