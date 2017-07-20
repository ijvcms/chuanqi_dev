--
-- Author: Alex mailto: liao131131@vip.qq.com
-- Date: 2016-01-19 11:53:28
--

--[[
	引导处理者 - 滑动类型的引导。
]]
local GuideHandler = import(".GuideHandler")
local GuideView_SlideType = import("..view.GuideView_SlideType")
local GuideHandler_SlideType = class("GuideHandler_SlideType", GuideHandler)

--
-- 当创建完毕。
--
function GuideHandler_SlideType:onCreate()
end

function GuideHandler_SlideType:onReceiveEvent(event)
end

function GuideHandler_SlideType:onExecute()
	--
	-- 执行父类的处理操作。
	--
	GuideHandler_SlideType.super.onExecute(self)

	self._view = GuideView_SlideType.new(self, self:getGuideStep())
	self._view:show()
	self:getController():showGuideView(self._view)
	
end

function GuideHandler_SlideType:onDeath()
	if self._view then
		self._view:close()
	end
end

return GuideHandler_SlideType