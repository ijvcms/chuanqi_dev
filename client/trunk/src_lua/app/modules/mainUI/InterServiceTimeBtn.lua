--
-- Author: zhangshunqiu    21102585@qq.com
-- Date: 2016-08-05 11:08:27
-- 跨服倒计时

local InterServiceTimeBtn = class("InterServiceTimeBtn", function()
	return display.newNode()
end)

function InterServiceTimeBtn.create(param)
	return InterServiceTimeBtn.new(param)
end

function InterServiceTimeBtn:ctor(param)
	self.bgSpr = display.newSprite("#btn_hlsd.png")
	self:addChild(self.bgSpr)

	self.timeNumLab = display.newTTFLabel({
                text = "00:00",
                size = 22,color = cc.c3b(255, 0, 0)})
                :align(display.CENTER,0,0)
                :addTo(self)
    self.timeNumLab:setPosition(0,-48)
    self:setVisible(false)
end

function InterServiceTimeBtn:open(num)
	if self.timeEventId == nil then
        self.timeEventId = GlobalEventSystem:addEventListener(SceneEvent.INTER_SERVICE_TIME_UPDATE,handler(self,self.setTime))
    end
    GameNet:sendMsgToSocket(11047,{})
end

function InterServiceTimeBtn:setTime(data)
	self.time = data.data.num
	if self.time > 0 then
		if self.timerId == nil then
	        self.timerId = GlobalTimer.scheduleGlobal(handler(self,self.updateTime),1)
	    end
	    self:setVisible(true)
	else
		self:setVisible(false)
	end
end

function InterServiceTimeBtn:updateTime()
	self.time = self.time -1
	local b = string.format("%02d",self.time/3600)..":"..string.format("%02d",(self.time%3600)/60)..":"..string.format("%02d",(self.time%60))
	self.timeNumLab:setString(b)
	if self.time <= 0 then
		if self.timerId then
		 	GlobalTimer.unscheduleGlobal(self.timerId)
		 	self.timerId = nil
		end
	end
end

function InterServiceTimeBtn:destory()
	if self.timerId then
	 	GlobalTimer.unscheduleGlobal(self.timerId)
	 	self.timerId = nil
	end
	if self.timeEventId then
        GlobalEventSystem:removeEventListenerByHandle(self.timeEventId)
        self.timeEventId = nil
    end
end



return InterServiceTimeBtn
