--
-- Author: Alex mailto: liao131131@vip.qq.com
-- Date: 2016-01-14 10:48:21
--
local GuideViewBase    = import(".GuideViewBase")
local GuideView_Welcome = class("GuideView_Welcome", GuideViewBase)

--
-- Override function.
--
function GuideView_Welcome:initialization()
	self:setTouchEnabled(true)

    local blockMask = cc.LayerColor:create(cc.c4b(0,0,0,200))
    blockMask:setContentSize(display.width, display.height)
    self:addChild(blockMask)

	local welcomSprite = display.newSprite("common/guide/guide_welcome.png")
	welcomSprite:center()
	self:addChild(welcomSprite)

	self:initGuideButtons()
end

function GuideView_Welcome:initGuideButtons()
    local buttonContainer = display.newNode()
    local buttonBg        = display.newSprite("#com_labBtn2.png")
    local buttomLabel     = display.newTTFLabel({
        text = "开始游戏",
        size = 22,
        color = cc.c3b(255, 255, 255),
        align = cc.TEXT_ALIGNMENT_CENTER -- 文字内部居中对齐
    })

    buttonContainer:addChild(buttonBg)
    buttonContainer:addChild(buttomLabel)
    buttonContainer:setPosition(display.cx, 50)
    buttonContainer:setTouchEnabled(true)
    buttonContainer:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
        if event.name == "began" then
            buttonContainer:setScale(1.2)
            SoundManager:playClickSound()
        elseif event.name == "ended" then
            buttonContainer:setScale(1.0)

            local data = self:getHandler():getOperateDataPkg()
            self:getController():notifyEventWithConfirm(data:getOperateId())
        end
        return true
    end)

    self:addChild(buttonContainer)
end

function GuideView_Welcome:close()
	GuideView_Welcome.super.close(self)
end

return GuideView_Welcome