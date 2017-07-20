--
-- Author: Alex mailto: liao131131@vip.qq.com
-- Date: 2016-02-24 17:28:54
--

local scheduler = require(cc.PACKAGE_NAME .. ".scheduler")
local QuickQuantityController = class("QuickQuantityController")

--[[
	快速计数自增/自减操作控制器。
	用于商店或一切需要用到数量的 +/- 按钮的增量操作。
]]
function QuickQuantityController:ctor(setFunc, getFunc)
	self.setFunc = setFunc
	self.getFunc = getFunc
end

function QuickQuantityController:setMinimumValue(val)
	self.min = val
end

function QuickQuantityController:setMaximumValue(val)
	self.max = val
end

function QuickQuantityController:start(delay, isAddition)
	self:stop()
	self.isAddition = isAddition
	self.preHandle = scheduler.performWithDelayGlobal(function()
		self.handle = scheduler.scheduleGlobal(handler(self, self.onTimerHandler), .1)
	end, delay)
end

function QuickQuantityController:stop()
	if self.preHandle then
		scheduler.unscheduleGlobal(self.preHandle)
		self.preHandle = nil
	end

	if self.handle then
		scheduler.unscheduleGlobal(self.handle)
		self.handle = nil
		return true
	end

	return false
end

function QuickQuantityController:onTimerHandler()
	local orgValue = checknumber(self.getFunc())
	if (orgValue  <= 10 and orgValue >= 0) or orgValue % 10 ~= 0 then
		self.applyValue = 1
	else
        self.applyValue = 10
	end
	local targetValue
	if self.isAddition then
		targetValue = orgValue + self.applyValue
		if self.max and targetValue > self.max then
			self.setFunc(self.max)
			return
		end
	else
		targetValue = orgValue - self.applyValue
		if self.min and targetValue < self.min then
			self.setFunc(self.min)
			return
		end
	end
	self.setFunc(targetValue)
end

return QuickQuantityController