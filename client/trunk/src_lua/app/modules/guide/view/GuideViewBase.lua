--
-- Author: Alex mailto: liao131131@vip.qq.com
-- Date: 2016-01-11 15:08:50
--
local GuideViewBase = class("GuideViewBase", function()
	return display.newNode()
end)

function GuideViewBase:ctor(handler, guideStep)
	self._handler = handler
	self._guideStep = guideStep

    self:initialization()
end

--
-- Getter of the handler & controller
--
function GuideViewBase:getHandler() return self._handler end
function GuideViewBase:getController() return self:getHandler():getController() end

--
-- Override function.
-- Init function
--
function GuideViewBase:initialization()
    self:addCommonButtons()
end

--
-- Override function.
-- Handle receive demand data.
--
function GuideViewBase:handleDemandData(data)
end

--
-- Override function.
-- When show will call this function.
--
function GuideViewBase:show()
end

--
-- Override function.
-- When closing will call this function.
--
function GuideViewBase:close()
	self:removeSelfSafety()
end

--
-- 通用按钮。
--
function GuideViewBase:addCommonButtons()
    local buttonContainer = display.newNode()
    local buttonBg        = display.newSprite("common/guide/guide_closebtn.png")
    local buttomLabel     = display.newTTFLabel({
        text = "关闭引导",
        size = 20,
        color = cc.c3b(251, 253, 250),
        align = cc.TEXT_ALIGNMENT_CENTER -- 文字内部居中对齐
    })

    buttonContainer:addChild(buttonBg)
    buttonContainer:addChild(buttomLabel)
    buttonContainer:setPosition(284, display.height - 160)
    buttonContainer:setTouchEnabled(true)
    buttonContainer:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
        if event.name == "began" then
            buttonContainer:setScale(1.2)
            SoundManager:playClickSound()
        elseif event.name == "ended" then
            buttonContainer:setScale(1.0)
            GlobalController.guide:stopGuide()
        end
        return true
    end)

    self:addChild(buttonContainer)
end

return GuideViewBase