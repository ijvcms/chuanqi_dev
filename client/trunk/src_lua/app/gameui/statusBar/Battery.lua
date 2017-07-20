--@author shine
--电池控件
local BatteryMonitor = require("app.gameui.statusBar.BatteryMonitor")

local Battery =  class("Battery", function() return display.newNode() end)


function Battery:ctor(param)
    local bg = display.newSprite("#scene/scene_battery.png")
    self.valueImg = display.newSprite("#scene/scene_batteryPower.png")
    local bgSize = bg:getContentSize()
    local valueImgSize = self.valueImg:getContentSize()
    self.valueImg:setAnchorPoint(0, 0.5)
    self.valueImg:setPosition((bgSize.width - valueImgSize.width) / 2, bgSize.height / 2)
    bg:addChild(self.valueImg)
    self.chargeImg = display.newSprite("#scene/scene_batteryCharge.png")
    self.chargeImg:setPosition(bgSize.width / 2, bgSize.height / 2)
    bg:addChild(self.chargeImg)
    self:addChild(bg)
    self:setContentSize(bg:getContentSize())
    self:handleBatteryLevelListener({data = GlobalController.batteryMonitor.batteryLevel})
    self:handleBatteryStatusListener({data = GlobalController.batteryMonitor.batteryStatus})
    self.statusHandler = GlobalEventSystem:addEventListener(BatteryMonitor.EVENT_STATUS_CHANGED,handler(self, self.handleBatteryStatusListener))
    self.levelHandler = GlobalEventSystem:addEventListener(BatteryMonitor.EVENT_LEVEL_CHANGED,handler(self, self.handleBatteryLevelListener))
    self.valueImg:setNodeEventEnabled(true, function(event)
        if event.name == "cleanup" then
            GlobalEventSystem:removeEventListenerByHandle(self.statusHandler)
            GlobalEventSystem:removeEventListenerByHandle(self.levelHandler)
        end 
    end)
end

--电能水平
function Battery:handleBatteryLevelListener(data)
	local scaleX = data.data / 100.0
	self.valueImg:setScaleX(scaleX)
end

--电池状态
--0未知状态
--1未充电
--2充电状体
function Battery:handleBatteryStatusListener(data)
    if data.data == 2 then
    	self.chargeImg:setVisible(true)
    else
    	self.chargeImg:setVisible(false)
    end
end


return Battery

