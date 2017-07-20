--
-- Author: Yi hanneng
-- Date: 2016-02-23 17:41:27
--
require("app.modules.sign.SignManager")
SignController = SignController or class("SignController", BaseController)

function SignController:ctor()
	SignController.Instance  = self
	self:initProtocal()
end

function SignController:getInstance()
	if nil == SignController.Instance then
		SignController.new()
	end
	return SignController.Instance 
end

function SignController:initProtocal()
	self:registerProtocal(32006,handler(self,self.onHandle32006))
	self:registerProtocal(32007,handler(self,self.onHandle32007))
end

function SignController:onHandle32006(data)
	print("SignController:onHandle32006")
	dump(data)
	if nil ~= data then
		--每天首次登陆打开
		GlobalEventSystem:dispatchEvent(GlobalEvent.OPEN_SIGN,data) 
		--正常打开
		SignManager:getInstance():handlerData(data)
	end

end

function SignController:onHandle32007(data)
	print("SignController:onHandle32007")
	dump(data)
	if data.result == 0 then
		GlobalEventSystem:dispatchEvent(SignEvent.SIGN_UPDATE)
	else
		GlobalEventSystem:dispatchEvent(GlobalEvent.SHOW_SYSTIPS,ErrorCodeNormalInfo[data.result])
	end

end