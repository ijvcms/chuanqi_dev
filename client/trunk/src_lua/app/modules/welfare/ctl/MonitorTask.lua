--
-- Author: Alex mailto: liao131131@vip.qq.com
-- Date: 2016-01-30 09:31:10
--

--[[
	监视任务基类、用于福利奖励后台运行任务。
	例如子类 MonitorTask_Online，监视在线时间与领取条件是否达到，然后修改奖励状态使其可以领取。
	三个主要的方法，也是一个任务的生命周期:
		onCreate(), onRun(), onDeath()
	跟福利奖励相关的方法:
		changeState()，改变一个奖励的状态（已领取、不可领取、可领取）。
]]


local MonitorTask = class("MonitorTask")

local CURRENT_MODULE_NAME = ...

--
-- Factory Method
--
function MonitorTask.create(reward_id, state)
	local reward_info = configHelper:getWelfareRewardById(reward_id)
	local reward_type = reward_info.type

	local task = nil

	-- 筛选出需要进行更新监听的任务。
	if reward_type == 2 then
		-- 只有未达到条件的在线奖励才会进行监测。
		if state == 2 then
			task = import(".MonitorTask_Online", CURRENT_MODULE_NAME).new(reward_info)
		end
	end

	return task
end

-- ///////////////////////////////////////////////////////////////////////////////////////////////////

function MonitorTask:ctor(reward_info)
	self._reward_info = reward_info
	self:onCreate()
end

--
-- Virtual Override
-- 创建事件。
--
function MonitorTask:onCreate()
end

--
-- Virtual Override
-- 运行事件。
--
function MonitorTask:onRun()
end

--
-- Virtual Override
-- 结束事件。
--
function MonitorTask:onDeath()
	if self._death_callback then
		self._death_callback()
	end
end

--
-- 更改这个任务奖励的状态。
--
function MonitorTask:changeState(state)
	GlobalController.welfare:SetRewardState(self:getRewardId(), state)
end

--
-- 设置终结回调函数。
--
function MonitorTask:setOnDeathCallBack(callback)
	self._death_callback = callback
end

--
-- 获取奖励Id以及奖励信息。
--
function MonitorTask:getRewardId() return self._reward_info.key end
function MonitorTask:getRewardData() return self._reward_info end


return MonitorTask