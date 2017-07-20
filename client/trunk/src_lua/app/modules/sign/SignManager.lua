--
-- Author: Yi hanneng
-- Date: 2016-02-23 17:41:39
--
SignManager = SignManager or class("SignManager", BaseManager)

function SignManager:ctor()
	SignManager.Instance = self
end

function SignManager:getInstance()
	if nil == SignManager.Instance then
		SignManager.new()
	end
	return SignManager.Instance
end

function SignManager:handlerData(data)
	if data == nil then
		return
	end
	
	local config = configHelper:getSignConfig(os.date("%Y"),os.date("%m"))
	GlobalEventSystem:dispatchEvent(SignEvent.SIGN_INFO, {list = config,is_sign = data.is_sign,sign_count = data.sign_count})

end