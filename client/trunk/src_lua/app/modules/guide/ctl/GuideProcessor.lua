--
-- Author: Alex mailto: liao131131@vip.qq.com
-- Date: 2016-01-07 16:26:08
--

local GuideStep      = import("..model.GuideStep")
local GuideHandler   = import(".GuideHandler")
local GuideProcessor = class("GuideProcessor")

--[[
    新手引导处理器
	================
		引导处理器的启动与停止由引导控制器GuideController控制，本对象主要负责一个引导周期。
		在一个引导周期内，所有跟引导相关的操作，都由本类来进行处理。
		handleGuideEvent 方法接受来自于控制器捕获到的引导事件，此事件代表对当前引导操作的一个反馈。
		本类会负责过滤并处理那些只对当前引导命令感兴趣的的事件。通常这些事件来源于外部模块。

		有时候，在执行一个引导命令的时候，可能会需要外部模块的一些数据来定位当前的引导操作（例如目标元素的位置和大小）
		此时应当请求引导控制器GuideController广播一个需求事件，所有跟引导相关的模块都应当监听此事件并选择性的做出反馈。
		当有一个模块对这个需求事件产生了反馈，就会使用控制器传递针对这个需求的事件，然后由handleGuideEvent方法接收并处理。
		整个流程如下：
			时间线
			>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

			外部模块                       【监听到广播并做出反馈】
			控制器               【广播需求】                   【接收事件】
			本处理器 【请求控制器】                                        【处理事件】

			>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
			时间线

		注意：本类的实例在整个引导模块内应当只出现一个，如果存在此实例说明当前正在进行引导，反之亦然。
]]


--
-- 构造函数
-- @param controller 引导模块主控制器
-- @param step_id 本处理器序列起始步骤ID。
-- @param trigger_type 触发类型
function GuideProcessor:ctor(controller, step_id, trigger_type)
	self:initWithStepId(controller, step_id, trigger_type)
end

function GuideProcessor:initWithStepId(controller, step_id, trigger_type)
	assert(controller, "GuideProcessor -> initWithStepId -> controller can't be nil.")
	assert(step_id, "GuideProcessor -> initWithStepId -> step_id can't be nil.")
	self._controller = controller
	self._currentGuideStep  = GuideStep.new(step_id)
	self._trigger_type = trigger_type
end

function GuideProcessor:getHandler() return self._currentHandler end
function GuideProcessor:getController() return self._controller end
function GuideProcessor:getCurrentStep() return self._currentGuideStep end

function GuideProcessor:handleGuideEvent(guideEvent)
	local handler = self:getHandler()
	if not handler then return end

	-- handler 处理一遍
	handler:onReceiveEvent(guideEvent)

	-- 确认类型，进入下一步
	local event = handler:filterEvent(guideEvent)
	if event and event:getType() == event.TYPE_CONFIRM then
		self:next()
	end
end

function GuideProcessor:isInterestedIn(identify)
	if self._currentGuideStep then
		return self._currentGuideStep:checkIdentify(identify)
	end
	return false
end


--
-- 获取当前步骤的ID。
--
function GuideProcessor:getCurrentStepId()
	return self:getCurrentStep():getStepId()
end

--
--触发类型
--
function GuideProcessor:getTriggerType()
	return self._trigger_type
end

--
-- 开始处理引导命令。
--
function GuideProcessor:start()
	local currentStep = self:getCurrentStep()
	self:executeStep(currentStep)
end

--
-- 关闭现有引导，进入下一个引导。如果没有下一个引导，结束生命周期。
--
function GuideProcessor:next()
	local currentStep = self:getCurrentStep()
	local nextStep    = currentStep and currentStep:getNextStep() or nil

	self:killCurrentStep()
	self:executeStep(nextStep)
end

function GuideProcessor:executeStep(step)
	if step then
		self._currentGuideStep = step
		self._currentHandler = GuideHandler.create(self:getController(), step)
		self._currentHandler:onExecute()
	else
		-- 没有命令了，结束生命周期。
		self:killMe()
	end
end

function GuideProcessor:killCurrentStep()
	if self._currentHandler then
		self._currentHandler:onDeath()
	end
	self._currentGuideStep = nil
	self._currentHandler   = nil
end

function GuideProcessor:clear()
	self:killCurrentStep()
end

function GuideProcessor:killMe()
	if self._controller then
		self._controller:stopGuide()
		self._controller = nil
	end
end

return GuideProcessor