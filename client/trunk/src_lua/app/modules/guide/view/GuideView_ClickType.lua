--
-- Author: Alex mailto: liao131131@vip.qq.com
-- Date: 2016-01-11 14:56:39
--

--[[
    引导视图 - 点击类型的引导。
]]

local GuideViewBase    = import(".GuideViewBase")
local DirectionTipView = import(".DirectionTipView")
local GuideView_ClickType = class("GuideView_ClickType", GuideViewBase)

--
-- Override function.
--
function GuideView_ClickType:initialization()
    self:initComponents()

    GuideView_ClickType.super.initialization(self)
end

function GuideView_ClickType:initComponents()
    self:initTouchMaskLayer()
    self:initFocusRect()
    self:initTip()
end

function GuideView_ClickType:initTouchMaskLayer()
    -- 这个层的作用，就是用来阻挡用户事件，并且在点击到正确的位置的时候释放事件。
    local mask2 = display.newLayer()
    mask2:setTouchSwallowEnabled(true)

    local mask = display.newLayer()
    mask:setTouchSwallowEnabled(false)
    mask:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
        if event.name == "began" then
            local rect = self:getInteractionRect()
            local contains = cc.rectContainsPoint(rect, event)
            mask2:setTouchEnabled(not contains)
        elseif event.name == "ended" then
            mask2:setTouchEnabled(true)
        end

        return true
    end)

    self:addChild(mask2)
    self:addChild(mask)
end

function GuideView_ClickType:initTip()
    local operatePkg = self:getHandler():getOperateDataPkg()
    local tipView = DirectionTipView.new(operatePkg:getDirection(), operatePkg:getDescribe())
    local pos = operatePkg:getPosition()
    tipView:setPosition(pos.x, pos.y)
    self:addChild(tipView)
end

function GuideView_ClickType:initFocusRect()
    --方法一个矩形，中心点不变
    local function enlargeRect(rect, addVal)
        local newRect = cc.rect(rect.x, rect.y, rect.width, rect.height)
        newRect.x = newRect.x - addVal
        newRect.y = newRect.y - addVal
        newRect.width = newRect.width + addVal * 2
        newRect.height = newRect.height + addVal * 2
        return newRect
    end

    local function transitionRect(sp)
        local __sequeue = transition.sequence({
            cc.FadeIn:create(0.3),
            cc.DelayTime:create(0.4),
            cc.FadeOut:create(0.3),
        })
        local loop = cc.RepeatForever:create(__sequeue)
        sp:runAction(loop)
    end
    --self.effectId = "guidanceEffect2"
    --ArmatureManager:getInstance():loadEffect(self.effectId, handler(self, self.loadedEffect))
    local targetRect = enlargeRect(self:getInteractionRect(), 7)
    local img_targetArea = display.newScale9Sprite("common/guide/img_guide_target_area.png", 0, 0, targetRect)
    img_targetArea:setPosition(targetRect.x + targetRect.width / 2, targetRect.y + targetRect.height / 2)
    self:addChild(img_targetArea)
    transitionRect(img_targetArea)
end

function GuideView_ClickType:loadedEffect()
    --方法一个矩形，中心点不变
    local function enlargeRect(rect, addVal)
        local newRect = cc.rect(rect.x, rect.y, rect.width, rect.height)
        newRect.x = newRect.x - addVal
        newRect.y = newRect.y - addVal
        newRect.width = newRect.width + addVal * 2
        newRect.height = newRect.height + addVal * 2
        return newRect
    end
    local img_targetArea = ccs.Armature:create(self.effectId)
    local img_size = img_targetArea:getContentSize()
    local targetRect = enlargeRect(self:getInteractionRect(), 7)
    local scaleX = targetRect.width / img_size.width
    local scaleY =  targetRect.height / img_size.height
    img_targetArea:setScale(scaleX, scaleY)
    img_targetArea:setPosition(targetRect.x + targetRect.width / 2, targetRect.y + targetRect.height / 2)
    self:addChild(img_targetArea)
    img_targetArea:getAnimation():play("effect")
    img_targetArea:setNodeEventEnabled(true, function(event)
        if event.name == "cleanup" then
           ArmatureManager:getInstance():unloadEffect(self.effectId)
        end 
    end)
end

function GuideView_ClickType:getInteractionRect()
    local operatePkg = self:getHandler():getOperateDataPkg()
    local rect = operatePkg:getTargetRect()
    return rect
end

function GuideView_ClickType:show()
end

return GuideView_ClickType