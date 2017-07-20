--
-- Author: Alex mailto: liao131131@vip.qq.com
-- Date: 2016-01-29 20:17:21
--

local scheduler = require(cc.PACKAGE_NAME .. ".scheduler")
local WelfareRewardItem = import(".WelfareRewardItem")
local WelfareRewardItem_Online = class("WelfareRewardItem_Online", WelfareRewardItem)

function WelfareRewardItem_Online:initialization()
	WelfareRewardItem_Online.super.initialization(self)
	self._ctrl = GlobalController.welfare
end

function WelfareRewardItem_Online:invalidateData()
	WelfareRewardItem_Online.super.invalidateData(self)
	self:clearTimer()

	local data = self:getData()

	-- 0未领取 1已领取 2 条件未达到，无法领取
	local itemState = GlobalController.welfare:GetRewardState(data.key)
	if itemState == 2 then
		self:startTimer()
	end
end

function WelfareRewardItem_Online:onTimerHandler()
	local data = self:getData()
	local surplusTime = data.value - self._ctrl:GetOnlineTime()
	self.lbl_condition_desc:setString(string.format("剩余时间%s", StringUtil.convertTime(surplusTime)))
end

function WelfareRewardItem_Online:startTimer()
	self:clearTimer()
	self._handle = scheduler.scheduleGlobal(handler(self, self.onTimerHandler), 1)
	self:onTimerHandler()
end

function WelfareRewardItem_Online:clearTimer()
	if self._handle then
		scheduler.unscheduleGlobal(self._handle)
		self._handle = nil
	end
end

function WelfareRewardItem_Online:onDestory()
	self:clearTimer()
	self._ctrl = nil

	WelfareRewardItem_Online.super.onDestory(self)
end


return WelfareRewardItem_Online