--
-- Author: Alex mailto: liao131131@vip.qq.com
-- Date: 2016-01-29 16:32:11
--
local WelfareData = class("WelfareData")

function WelfareData:ctor()
	self._state_list = nil
	self._ret_time = nil
end

--
-- 设置奖励列表的状态。
--
function WelfareData:setRewardsState(state_list)
	--[[
		<Type name="proto_active_info" describe="活动信息">
			<Param name="key" type="int16" describe="活动id"/>
			<Param name="state" type="int8" describe="奖励领取状态0未领取 1已领取 2条件未达到"/>
		</Type>
	]]
	self._state_list = {}
	table.merge(self._state_list, state_list)
end

--
-- 获取奖励列表的状态。
--
function WelfareData:getRewardsState()
	local state_list = {}
	table.merge(state_list, self._state_list)
	return state_list
end

--
-- 获取奖励信息。
--
function WelfareData:getReward(reward_id)
	if self._state_list then
		for _, v in ipairs(self._state_list) do
			if v.key == reward_id then return v end
		end
	end
end

--
-- 设置指定奖励的状态。
--
function WelfareData:setRewardState(reward_id, state)
	local reward = self:getReward(reward_id)
	if reward then
		reward.state = state
	end
end

--
-- 获取奖励信息的状态。
--
function WelfareData:getRewardState(reward_id)
	local reward = self:getReward(reward_id)
	if reward then
		return reward.state
	end
end

--
-- 设置当前的在线时间。
--
function WelfareData:setOnlineTime(new_time)
	self._ret_time = new_time
	self._ret_pt = os.time()
end

--
-- 获取当前的在线时间。
--
function WelfareData:getOnlineTime()
	if self._ret_time then
		return self._ret_time + (os.time() - self._ret_pt)
	end
end

return WelfareData