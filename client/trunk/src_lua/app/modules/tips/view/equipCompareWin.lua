--
-- Author: casen
-- Date: 2015-09-01 
-- 装备对比窗口

require("app.modules.bag.view.TipsEquip")

local equipCompareWin = equipCompareWin or class("equipCompareWin", function()
    return display.newNode()
end)

--构造
function equipCompareWin:ctor()
    self:setContentSize(display.width, display.height)
    self.bg =  cc.LayerColor:create(cc.c4b(0,0,0,100))
    --self.bg:setOpacity(255*0.8)
    self.bg:setContentSize(display.width, display.height)
    
    self:setTouchEnabled(true)
    self:setTouchSwallowEnabled(true)
    self:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
        if event.name == "began" then
            SoundManager:playClickSound()
        elseif event.name == "ended" then
            self:removeSelfSafety()
        end     
        return true
    end)
    self:addChild(self.bg)

    self.leftEquip = TipsEquip.new() --416 400
    self.leftEquip:setPosition(display.cx - 416-6,display.cy-200)
    self:addChild(self.leftEquip)
    self.rightEquip = TipsEquip.new()
    self.rightEquip:setPosition(display.cx+6,display.cy-200)
    self:addChild(self.rightEquip)

    self.leftEquip:setBtnClickCallBack(function()
        self:removeSelfSafety()
    end)
    self.rightEquip:setBtnClickCallBack(function()
        self:removeSelfSafety()
    end)


end

function equipCompareWin:setData(leftEquip,rightEquip)
    if not leftEquip then return end
    if not rightEquip then return end
    self.leftEquip:setData(leftEquip)
    if leftEquip.location==1 then
        self.leftEquip.btnSell:setVisible(false)
        self.leftEquip.btnPutOn:setVisible(false)
        self.leftEquip.btnTakeOff:setVisible(true)
    end
    self.rightEquip:setData(rightEquip)
end


return equipCompareWin