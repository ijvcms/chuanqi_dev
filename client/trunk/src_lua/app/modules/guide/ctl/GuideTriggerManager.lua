--
-- Author: Alex mailto: liao131131@vip.qq.com
-- Date: 2016-01-15 18:34:10
--

--[[
	引导触发管理器
	============
		此管理器主要根据配置的类型以及触发条件来检查是否触发这个触发器所指向引导。

		使 用 方 法
		----------
		使用以下代码(前提是本类得以注册在全局)：
			GuideTriggerManager.GetInstance():tryTrigger(type, data)
		或者:
			GlobalController.guide:getTriggerManager():tryTrigger(type, data)

		注意，每增加一个触发类型，都要在相应模块调用本触发器，并为触发类型写一个触发条件检测方法。
]]
local GuideTriggerManager = class("GuideTriggerManager")

TriggerType  = {}
TriggerType.TASK_ACCEPT   = 1
TriggerType.TASK_FINISH   = 2
TriggerType.SYSTEM_PUBLIC = 3
TriggerType.LEVEL_EQUAL   = 4
TriggerType.FIRST_IN_GAME = 5
TriggerType.INSTANCE_FINISH = 6--副本任务完成
TriggerType.TASK_ACCEPT_NOSTOP  = 7--接受任务，但是不终止任务运行

function GuideTriggerManager:ctor()
	self._triggerMethods = {
		[TriggerType.TASK_ACCEPT]          = handler(self, self.getTriggerWith_TaskAccept),
		[TriggerType.TASK_ACCEPT_NOSTOP]   = handler(self, self.getTriggerWith_TaskAcceptNoStop),
		[TriggerType.TASK_FINISH]          = handler(self, self.getTriggerWith_TaskFinish),
		[TriggerType.SYSTEM_PUBLIC]        = handler(self, self.getTriggerWith_SystemPublic),
		[TriggerType.LEVEL_EQUAL]          = handler(self, self.getTriggerWith_LevelEqual),
		[TriggerType.FIRST_IN_GAME]        = handler(self, self.getTriggerWith_FristInGame),
		[TriggerType.INSTANCE_FINISH]      = handler(self, self.getTriggerWith_InstanceFinish),
	}
end

--
-- 尝试触发引导。
-- @param type 触发类型
-- @param data 触发数据
-- @return 是否可以触发
--
function GuideTriggerManager:tryTrigger(type, data)
	local trigger = self:getTrigger(type, data)
	if trigger then
		GlobalController.guide:startGuideWithTrigger(trigger)
	end
	return trigger ~= nil
end


--
-- 根据触发类型和触发数据获得触发器，可以根据这个触发器传入引导系统控制器GuideController:startGuideWithTrigger(trigger)开始触发。
-- @param type 触发类型
-- @param data 触发数据
--
function GuideTriggerManager:getTrigger(type, data)
	local triggerMethod = self._triggerMethods[type]
	if triggerMethod then
		return triggerMethod(data)
	end
end

--
-- 触发条件检测方法，当任务接受的时候检测当前的任务ID是否可以被引导。
-- 如果检测条件成立，则返回这个触发数据。
--
function GuideTriggerManager:getTriggerWith_TaskAccept(data)
	local current_task_id = data.current_task_id
	local triggers = configHelper:getGuideTriggerByType(TriggerType.TASK_ACCEPT)
	if triggers and #triggers > 0 then
		for _, v in ipairs(triggers) do
			if checknumber(v.trigger_data) == current_task_id then
				return v
			end
		end
	end
end


function GuideTriggerManager:getTriggerWith_TaskAcceptNoStop(data)
	local current_task_id = data.current_task_id
	local triggers = configHelper:getGuideTriggerByType(TriggerType.TASK_ACCEPT_NOSTOP)
	if triggers and #triggers > 0 then
		for _, v in ipairs(triggers) do
			if checknumber(v.trigger_data) == current_task_id then
				return v
			end
		end
	end
end

--
-- 触发条件检测方法，当任务完成的时候检测当前的任务ID是否可以被引导。
-- 如果检测条件成立，则返回这个触发数据。
--
function GuideTriggerManager:getTriggerWith_TaskFinish(data)
	local current_task_id = data.current_task_id
	local triggers = configHelper:getGuideTriggerByType(TriggerType.TASK_FINISH)
	if triggers and #triggers > 0 then
		for _, v in ipairs(triggers) do
			if checknumber(v.trigger_data) == current_task_id then
				return v
			end
		end
	end
end

--
-- 触发条件检测方法，当系统开放的时候检测这个系统是否可以被引导。
-- 如果检测条件成立，则返回这个触发数据。
--
function GuideTriggerManager:getTriggerWith_SystemPublic(data)
	local func_id = data.func_id
	local triggers = configHelper:getGuideTriggerByType(TriggerType.SYSTEM_PUBLIC)
	if triggers and #triggers > 0 then
		for _, v in ipairs(triggers) do
			if checknumber(v.trigger_data) == func_id then
				return v
			end
		end
	end
end

function GuideTriggerManager:getTriggerWith_LevelEqual(data)
end

function GuideTriggerManager:getTriggerWith_FristInGame(data)
	-- 这里，使用了经验和等级来判断用户是否第一次进入游戏
	if data.current_lv == 1 and data.current_exp == 0 then

		-- 这个触发类型比较特殊，只要有这个触发器则成立。
		local triggers = configHelper:getGuideTriggerByType(TriggerType.FIRST_IN_GAME)
		if triggers and #triggers > 0 then
			-- 进入游戏判断是否为第一次进入游戏
			return triggers[1]
		end
	end
end

function GuideTriggerManager:getTriggerWith_InstanceFinish(data)
	local scene_id = data.scene_id
	local triggers = configHelper:getGuideTriggerByType(TriggerType.INSTANCE_FINISH)
	if triggers and #triggers > 0 then
		for _, v in ipairs(triggers) do
			if checknumber(v.trigger_data) == scene_id then
				return v
			end
		end
	end
end



return GuideTriggerManager