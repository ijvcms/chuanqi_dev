--
-- Author: Alex mailto: liao131131@vip.qq.com
-- Date: 2016-01-16 01:11:13
--

local GuideView_Welcome = import("..view.GuideView_Welcome")
local GuideHandler = import(".GuideHandler")
local GuideHandler_Welcome = class("GuideHandler_Welcome", GuideHandler)

--
-- 当创建完毕。
--
function GuideHandler_Welcome:onCreate()
end

function GuideHandler_Welcome:onReceiveEvent(event)
end

function GuideHandler_Welcome:onExecute()
	local view = GuideView_Welcome.new(self, self:getGuideStep())
	self:getController():showGuideView(view)
	view:show()

	self._view = view
end

function GuideHandler_Welcome:onDeath()
	self._view:close()
end

return GuideHandler_Welcome

