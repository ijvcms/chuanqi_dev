--
-- Author: Alex mailto: liao131131@vip.qq.com
-- Date: 2016-01-19 14:12:56
--

--[[
    引导视图 - 滑动类型的引导。
]]
local GuideViewBase = import(".GuideViewBase")
local GuideView_SlideType = class("GuideView_SlideType", GuideViewBase)

--
-- Override function.
--
function GuideView_SlideType:initialization()
    self:initComponents()

    GuideView_SlideType.super.initialization(self)
end

function GuideView_SlideType:initComponents()
	self:initTouchMaskLayer()
	self:initSlideMovie()

    -- 调试查看点击区域
    -- self:initFocusRect()
end

function GuideView_SlideType:initFocusRect()
    -- 放大一个矩形，中心店不变
    local function enlargeRect(rect, addVal)
        local newRect = cc.rect(rect.x, rect.y, rect.width, rect.height)
        newRect.x = newRect.x - addVal
        newRect.y = newRect.y - addVal
        newRect.width = newRect.width + addVal * 2
        newRect.height = newRect.height + addVal * 2
        return newRect
    end
    
    local targetRect = enlargeRect(self:getInteractionRect(), 7)
    local img_targetArea = display.newScale9Sprite("common/guide/img_guide_target_area.png", 0, 0, targetRect)
    img_targetArea:setAnchorPoint(cc.p(0, 0))
    img_targetArea:setPosition(targetRect.x, targetRect.y)
    self:addChild(img_targetArea)
end


function GuideView_SlideType:initTouchMaskLayer()
    -- 这个层的所用，就是用来阻挡用户事件，并且在点击到正确的位置的时候释放事件。
    local mask2 = display.newLayer()
    mask2:setContentSize(display.width, display.height)
    mask2:setTouchEnabled(true)
    mask2:setTouchSwallowEnabled(true)

    local mask = display.newLayer()
    mask:setContentSize(display.width, display.height)
    mask:setTouchEnabled(true)
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

function GuideView_SlideType:initSlideMovie()
    -- 针对这个特定操作显示特定的图片。
    if self:getHandler():getOperateDataPkg():getOperateId() == GUIOP.SLIDE_QUICK_TURN then
        self:createSkillImages()
    else
        self:createTwoPoint()
    end

    self:createFinger()
end

--
-- 针对特定的操作，显示特别的一些图片。
--
function GuideView_SlideType:createSkillImages()
    local img1 = display.newSprite("common/guide/img_guide_skill_tip.png")
    img1:setPosition(display.width - 100, 366)
    self:addChild(img1)

    local img2 = display.newSprite("common/guide/img_guide_skill_tip.png")
    img2:setScaleY(-1)
    img2:rotation(70)
    img2:setPosition(display.width - 210, 200)
    self:addChild(img2)
end

--
-- 创建起点和终点。
--
function GuideView_SlideType:createTwoPoint()
    local operatePkg = self:getHandler():getOperateDataPkg()
    local startPoint = operatePkg:getStartPoint()
    local endPoint   = operatePkg:getEndPoint()

    local function transitionPoint(sp)
        local __scale15 = cc.ScaleTo:create(.5, 1.5)
        local __scale05 = cc.ScaleTo:create(.5, 0.5)
        local __sequeue = transition.sequence({
            __scale15, __scale05
        })
        local loop = cc.RepeatForever:create(__sequeue)
        sp:runAction(loop)
    end

    local startSp = display.newSprite("common/guide/img_guide_point.png")
    startSp:setPosition(startPoint.x, startPoint.y)
    self:addChild(startSp)

    local endSp = display.newSprite("common/guide/img_guide_point.png")
    endSp:setPosition(endPoint.x, endPoint.y)
    self:addChild(endSp)

    transitionPoint(startSp)
    transitionPoint(endSp)

    self.startSp = startSp
    self.endSp = endSp
end

--
-- 创建手指，并播放从起点到终点的动画。
--
function GuideView_SlideType:createFinger()
    local operatePkg = self:getHandler():getOperateDataPkg()
    local startPoint = operatePkg:getStartPoint()
    local endPoint   = operatePkg:getEndPoint()

    local finger = display.newSprite("common/guide/img_guide_finger.png")
    finger:setAnchorPoint(cc.p(0, 1))
    self:addChild(finger)

    local __toStart = cc.MoveTo:create(0, startPoint)
    local __fadeIn  = cc.FadeIn:create(.2)
    local __moveTo  = cc.MoveTo:create(1, endPoint)
    local __fadeOut = cc.FadeOut:create(.2)
    local __sequeue = transition.sequence({
        __toStart, __fadeIn, __moveTo, __fadeOut
    })
    local loop = cc.RepeatForever:create(__sequeue)
    finger:runAction(loop)

    self.finger = finger
end

--
-- 获取可触摸区域。
--
function GuideView_SlideType:getInteractionRect()
    local operatePkg = self:getHandler():getOperateDataPkg()
    local rect = operatePkg:getTargetRect()
    return rect
end

--
-- When show will call this function.
--
function GuideView_SlideType:show()
end

--
-- When closing will call this function.
--
function GuideView_SlideType:close()
    if self.finger then
        self.finger:stopAllActions()
        self.finger = nil
    end

    if self.startSp then
        self.startSp:stopAllActions()
        self.endSp:stopAllActions()
        self.startSp = nil
        self.endSp = nil
    end

    GuideView_SlideType.super.close(self)
end

return GuideView_SlideType