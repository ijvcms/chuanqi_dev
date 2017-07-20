--@author shine
--时间控件
local Clock =  class("Clock", function() return display.newNode() end)

function Clock:ctor()
	self.timeLabel = display.newTTFLabel({size = 14, align = cc.TEXT_ALIGNMENT_CENTER,valign = cc.VERTICAL_TEXT_ALIGNMENT_CENTER})
	self:addChild(self.timeLabel)
	self.scheduler = require("framework.scheduler")
	local startFun = function()
	    self.timeLabel:setString(os.date("%H:%M", os.time()))
	    self.timeHandler = self.scheduler.scheduleGlobal(handler(self, self.handleTimeChanged), 60)
    end
    self.timeLabel:setString(os.date("%H:%M", os.time()))
    local sec = tonumber(os.date("%S", os.time()), 10)
	self.timeHandler = self.scheduler.performWithDelayGlobal(startFun, 60 - sec)
	self.timeLabel:setNodeEventEnabled(true, function(event)
        if event.name == "cleanup" then
        	self.scheduler.unscheduleGlobal(self.timeHandler)
        end 
	end)
	self:setContentSize(self.timeLabel:getContentSize())
end

function Clock:handleTimeChanged()
	self.timeLabel:setString(os.date("%H:%M", os.time()))
end



return Clock
