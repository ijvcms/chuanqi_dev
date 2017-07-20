--
-- Author: Alex mailto: liao131131@vip.qq.com
-- Date: 2016-01-07 15:53:31
--

-- ------------------------------------------------------------------------
-- ////////////////////////////////////////////////////////////////////////
-- 新手引导模块测试，主要测试模块的功能列表以及事件派发验证。


local GuideTest = class("GuideTest")

function GuideTest:ctor()
end

function GuideTest:setUp()
end

function GuideTest:guideEventHandler(event)
	dump(event)
end

function GuideTest:doIt()
	-- GlobalController.guide:startGuide(10003) -- 使用技能石
	GlobalController.guide:startGuide(10009) -- 滑动
	-- GlobalController.guide:notifyEventWithConfirm(10001)
end

function GuideTest:Test()
	self:setUp()
	self:doIt()
end

return GuideTest