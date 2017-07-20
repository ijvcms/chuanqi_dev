--
-- Author: Yi hanneng
-- Date: 2016-06-13 12:01:15
--
SecureController = SecureController or class("SecureController",BaseController)

function SecureController:ctor()	
	SecureController.Instance = self
	self:initProtocal()
end

function SecureController:getInstance()
	if SecureController.Instance==nil then
		SecureController.new()
	end
	return SecureController.Instance
end

function SecureController:initProtocal( )
	self:registerProtocal(14048,handler(self,self.onHandle14048))
end

function SecureController:requestSecure(id,count)
	if id == nil or count == 0 then
		GlobalEventSystem:dispatchEvent(GlobalEvent.SHOW_SYSTIPS,"请输入投保次数！")
		return
	end
	GameNet:sendMsgToSocket(14048, {id = id,count = count})
end

function SecureController:onHandle14048(data)
	print("onHandle14048")
	if data.result ~= 0 then
		GlobalEventSystem:dispatchEvent(GlobalEvent.GET_ERROR_CODE,ErrorCodeInfoFormat(data.result))
	else
		GlobalEventSystem:dispatchEvent(GlobalEvent.SHOW_SYSTIPS,"投保成功！")
		GlobalEventSystem:dispatchEvent(SecureEvent.SECURE_SUCCESS)
	end
end