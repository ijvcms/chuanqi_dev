--
-- Author: Alex mailto: liao131131@vip.qq.com
-- Date: 2016-01-30 09:44:52
--

--[[
	监视在线时间奖励，在倒计时完毕达到领取条件之后改变这个奖励的领取状态，使其变为可领取。
]]


local scheduler = require(cc.PACKAGE_NAME .. ".scheduler")
local MonitorTask = import(".MonitorTask")
local MonitorTask_Online = class("MonitorTask_Online", MonitorTask)

--
-- Virtual Override
-- 创建事件。
--
function MonitorTask_Online:onCreate()
	self._ctrl = GlobalController.welfare
end

--
-- Virtual Override
-- 运行事件。
--
function MonitorTask_Online:onRun()
	self:startTimer()
	self._change_handle = GlobalEventSystem:addEventListener(WelfareEvent.CHANGE_REWARDS_STATE, function()
		-- 状态更改，如果不是未达成状态，则结束掉这个监测任务。
		-- 未达成才需要监测嘛。
		if self._ctrl:GetRewardState(self:getRewardId()) ~= 2 then--奖励领取状态0未领取 1已领取 2条件未达到
			self:onDeath()
		end
	end)
end

--
-- Virtual Override
-- 结束事件。
--
function MonitorTask_Online:onDeath()
	self:clearTimer()
	if self._change_handle then
		GlobalEventSystem:removeEventListenerByHandle(self._change_handle)
		self._change_handle = nil
	end
	self._ctrl = nil
	
	MonitorTask_Online.super.onDeath(self)
end

function MonitorTask_Online:onTimerHandler()
	local data = self:getRewardData()
	local surplusTime = data.value - self._ctrl:GetOnlineTime()

	if surplusTime <= 0 then
		self:clearTimer()
		self:changeState(0)
	end
end

function MonitorTask_Online:startTimer()
	self:clearTimer()
	self._handle = scheduler.scheduleGlobal(handler(self, self.onTimerHandler), 1)
	self:onTimerHandler()
end

function MonitorTask_Online:clearTimer()
	if self._handle then
		scheduler.unscheduleGlobal(self._handle)
		self._handle = nil
	end
end

return MonitorTask_Online