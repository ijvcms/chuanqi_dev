--
-- Author: casen
-- Date: 2015-12-01 
-- 礼包奖励窗口

local equipTipsWin = require("app.modules.tips.view.equipTipsWin")

local itemTipsWin = require("app.modules.tips.view.itemTipsWin")

local GiftBox = GiftBox or class("GiftBox", function()
    return display.newColorLayer(cc.c4b(0,0,0,100))
end)

--构造
function GiftBox:ctor()
    self:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
        if event.name == "began" then
            SoundManager:playClickSound()
        elseif event.name == "ended" then
            self:onCloseClick()
        end     
        return true
    end)

    local bg = display.newScale9Sprite("#com_panelBg5.png", 0, 0, cc.size(506, 320),cc.rect(10, 10,1, 1))
        :pos(display.width/2,display.height/2)
        :addTo(self)

    local lab1 = display.newTTFLabel({text = "恭喜获得以下奖励:", size = 22, color = TextColor.TEXT_O})
        :pos(120,bg:getContentSize().height-30)
        :addTo(bg)
    display.setLabelFilter(lab1)

    local lab2 = display.newTTFLabel({text = "点击关闭", size = 24, color = TextColor.ITEM_R})
        :pos(bg:getContentSize().width/2,34)
        :addTo(bg)
    display.setLabelFilter(lab2)


    --滚动层
    self.scrollView = require("app.modules.bag.view.GBUIScrollView").new({viewRect = cc.rect(34,70,455,185),direction=1}):addTo(bg)
end

local xGap = 90
local yGap = 90
local perCountRow = 5
function GiftBox:setDatas(datas)
    local layer = display.newLayer()
    layer:setTouchEnabled(false)
    layer:setTouchSwallowEnabled(false)
    local rowCount = math.ceil((#datas)/perCountRow)
    if rowCount<= 0 then return end
    local realHeight = (rowCount-1)*yGap+80
    for i=1,#datas do
        local commonItem = CommonItemCell.new()
        commonItem:setData(datas[i])
        commonItem:checkNumAndArrow()
        layer:addChild(commonItem)
        local row = rowCount-math.ceil(i/perCountRow)+1
        local col = i%(perCountRow+1)
        if col == 0 then col = 1 end
        commonItem:setPosition((col-1)*xGap+76/2,(row-1)*yGap+76/2)
    end
    self.scrollView:addScrollNode(layer)
    layer:setContentSize(455,realHeight)
    layer:setPosition(34,185-realHeight+70)
end

--关闭按钮回调
function GiftBox:onCloseClick()
    self:removeSelfSafety()
end

return GiftBox