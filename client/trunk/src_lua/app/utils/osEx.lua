local ChannelApiHelper =  class("ChannelApiHelper")

local Java_ClassName = "com/rongyao/chuanqi/utils/DeviceUtils"
local OC_ClassName = "Device"

function os.getFreeMemory()
	local platform = device.platform
	if platform == "android" then
		local callHelper =require("framework.luaj")
		local ok, ret = callHelper.callStaticMethod(Java_ClassName, "getFreeMemory", {}, "()I")
		if ok then
			return ret
		else
			return 200
		end
	elseif platform == "ios"  then
		local callHelper = require("framework.luaoc")
		local ok, ret = callHelper.callStaticMethod(OC_ClassName, "getFreeMemory")
		if ok then
			return ret
		else
			return 100
		end
	end
	return 200
end