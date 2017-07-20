--@author shine
--电源监控器
--单例
local BatteryMonitor = class("BatteryMonitor")
BatteryMonitor.EVENT_STATUS_CHANGED = "BATTERY_EVENT_STATUS_CHANGED"
BatteryMonitor.EVENT_LEVEL_CHANGED = "BATTERY_EVENT_LEVEL_CHANGED"
BatteryMonitor.StateUnknown = 0
BatteryMonitor.StateUnplugged = 1
BatteryMonitor.StatePlugged = 2

local Java_ClassName = "com/rongyao/chuanqi/utils/DeviceUtils"
local OC_ClassName = "Device"

function BatteryMonitor:ctor()
	self.batteryLevel = 100
	self.batteryStatus = 2
	local platform = device.platform
	if platform == "ios"  then
		local callHelper = require("framework.luaoc")
		callHelper.callStaticMethod(OC_ClassName, "setBatteryLevelListener", {handler = handler(self, self.handleBatteryLevelListener)})
		callHelper.callStaticMethod(OC_ClassName, "setBatteryStatusListener", {handler = handler(self, self.handleBatteryStatusListener)})
	elseif platform == "android" then
		local callHelper =require("framework.luaj")
		local fun = function (data)
            self:handleBatteryLevelListener(json.decode(data))
		end
		callHelper.callStaticMethod(Java_ClassName, "setBatteryLevelListener", {fun}, "(I)V")
		fun = function (data)
            self:handleBatteryStatusListener(json.decode(data))
		end
		callHelper.callStaticMethod(Java_ClassName, "setBatteryStatusListener", {fun}, "(I)V")
	end
end

--电能水平
function BatteryMonitor:handleBatteryLevelListener(data)
	self.batteryLevel = data.per
	GlobalEventSystem:dispatchEvent(BatteryMonitor.EVENT_LEVEL_CHANGED, self.batteryLevel)
end

--电池状态
--0未知状态
--1未充电
--2充电状体
function BatteryMonitor:handleBatteryStatusListener(data)
	self.batteryStatus =  data.status
    GlobalEventSystem:dispatchEvent(BatteryMonitor.EVENT_STATUS_CHANGED, self.batteryStatus)
end

return BatteryMonitor