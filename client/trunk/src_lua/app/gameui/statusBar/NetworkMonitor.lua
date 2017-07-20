--@author shine
--网络监控器
--单例
local NetworkMonitor = class("NetworkMonitor")

NetworkMonitorEvent = {
	EVENT_TYPE_CHANGED = "NETWORK_EVENT_TYPE_CHANGED",
	EVENT_SPEED_CHANGED = "EVENT_SPEED_CHANGED",
}
NetworkMonitor.TypeUnknown = 0
NetworkMonitor.TypeWIFI = 1
NetworkMonitor.TypeWWAN = 2
NetworkMonitor.TypeNone = 3

local Java_ClassName = "com/rongyao/chuanqi/utils/DeviceUtils"
local OC_ClassName = "Device"

function NetworkMonitor:ctor()
	self.networkType = 1
	local platform = device.platform
	if platform == "ios"  then
		local callHelper = require("framework.luaoc")
		callHelper.callStaticMethod(OC_ClassName, "setNetworkTypeListener", {handler = handler(self, self.handleNetworkTypeListener)})
	elseif platform == "android" then
		local callHelper =require("framework.luaj")
		local fun = function (data)
            self:handleNetworkTypeListener(json.decode(data))
		end
		callHelper.callStaticMethod(Java_ClassName, "setNetworkTypeListener", {fun}, "(I)V")
	end
end

--网络类型
--WIFI  1
--窝锋   2
--没网络 3
function NetworkMonitor:handleNetworkTypeListener(data)
	self.networkType = data.type
	GlobalEventSystem:dispatchEvent(NetworkMonitorEvent.EVENT_TYPE_CHANGED, self.networkType)
end

return  NetworkMonitor