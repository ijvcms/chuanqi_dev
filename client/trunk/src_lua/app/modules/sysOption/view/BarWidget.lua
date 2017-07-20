local BarWidget = class("BarWidget", function()
    return display.newNode()
end)

function BarWidget:ctor(width,height,barColor)
    self.barWidth = width
    self.barHeight = height
    local bg = display.newScale9Sprite("#com_bar1Bg.png",nil,nil,cc.size(width,height))
    local barMask = cc.ClippingRegionNode:create()
    bg:addChild(barMask)
    -- barMask:setPosition(bg:getContentSize().width/2,bg:getContentSize().height/2)
    local bar = display.newScale9Sprite(barColor==1 and "#com_redBar.png" or "#com_blueBar.png" ,nil,nil,cc.size(width, height))
    barMask:addChild(bar)
    bar:setPosition(bg:getContentSize().width/2,bg:getContentSize().height/2)
    barMask:setClippingRegion(cc.rect(0,0,width,height))
    self.barMask = barMask
    self:addChild(bg)

    local point = display.newSprite("#com_switchBtn.png")
    bg:addChild(point)
    point:setPositionY(9)
    point:setTouchEnabled(true)
    point:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
        if event.name == "began" then
            SoundManager:playClickSound()
        elseif event.name == "ended" then
            local pos = bg:convertToNodeSpace(cc.p(event.x, event.y))
            self:setPercent(pos.x/width*100)
        elseif event.name == "moved" then
            local pos = bg:convertToNodeSpace(cc.p(event.x, event.y))
            self:setPercent(pos.x/width*100)
        end     
        return true
    end)
    self.point = point

    self:setPercent(100)
end

function BarWidget:setListener(func)
    self.listener = func
end

function BarWidget:setPercent(percent)
    if percent<0 then percent = 0 end
    if percent>100 then percent = 100 end
    self.barMask:setClippingRegion(cc.rect(0,0,self.barWidth*percent/100,self.barHeight))
    self.barMask:setVisible(percent~=0)
    self.curPercent = percent

    self.point:setPositionX(self.barWidth*percent/100)

    if self.listener then
        self.listener(percent)
    end
end

function BarWidget:getPercent()
    return self.curPercent
end

return BarWidget