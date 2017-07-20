--
-- Author: zhangshunqiu    21102585@qq.com
-- Date: 2016-08-19 11:14:09
-- 临时翅膀倒计时按钮
local WingCountDownBtn = class("WingCountDownBtn", function()
	return display.newNode()
end)

function WingCountDownBtn.create(param)
	return WingCountDownBtn.new(param)
end

function WingCountDownBtn:ctor(param)
	self.bg = "#scene_serverBossBtn.png"
	--self.data = param.data

	self.bgSpr = display.newSprite(self.bg)
	self:addChild(self.bgSpr)

	self.timeNumLab = display.newTTFLabel({
                text = "00:00",
                size = 22,color = cc.c3b(255, 0, 0)})
                :align(display.CENTER,0,0)
                :addTo(self)
    self.timeNumLab:setPosition(0,-48)
    self:setVisible(false)
end

function WingCountDownBtn:open(num)
	self:setTime(num)
end

function WingCountDownBtn:setTime(num)
	self.time = num
	if self.time > 0 then
		if self.timerId == nil then
	        self.timerId = GlobalTimer.scheduleGlobal(handler(self,self.updateTime),1)
	    end
	    self:setVisible(true)
	else
		self:setVisible(false)
	end
end

function WingCountDownBtn:updateTime()
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

function WingCountDownBtn:destory()
	if self.timerId then
	 	GlobalTimer.unscheduleGlobal(self.timerId)
	 	self.timerId = nil
	end
end



return WingCountDownBtn
