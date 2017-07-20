--
-- Author: Alex mailto: liao131131@vip.qq.com
-- Date: 2016-01-07 17:30:28
--

--[[
	GuideOrder 是引导配置数据对象，根据引导
]]

local GuideOperation = import(".GuideOperation")
local GuideStep = class("GuideStep")

function GuideStep:ctor(step_id)
	self._step_id = step_id
	self:initialization()
end

function GuideStep:initialization()
	self._stepData = configHelper:getGuideDataByStepId(self._step_id)
	self._operateDataPkg = GuideOperation.create(self._stepData.operate_data)
	-- dump(self._stepData, "", 4)
end

function GuideStep:getNextStep()
	local nextGuideStepId = self:getNextStepId()
	if nextGuideStepId and nextGuideStepId ~= 0 then
		return GuideStep.new(nextGuideStepId)
	end
end

function GuideStep:getStepId()
	return self._stepData.id
end

function GuideStep:getNextStepId()
	return self._stepData.next_id
end

function GuideStep:getOperateDataPkg()
	return self._operateDataPkg
end

function GuideStep:checkIdentify(identify)
	return self._operateDataPkg:checkIdentify(identify)
end


return GuideStep