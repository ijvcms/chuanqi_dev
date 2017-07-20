--
-- Author: yangjiacheng    383229800@qq.com
-- Date: 2015-09-09 
-- 商城控制器
import("app.utils.EquipUtil")
StoreController = StoreController or class("StoreController",BaseController)

function StoreController:ctor()	
	StoreController.Instance = self
	self:initProtocal()
end

function StoreController:getInstance()
	if StoreController.Instance==nil then
		StoreController.new()
	end
	return StoreController.Instance
end

function StoreController:initProtocal( )
	self:registerProtocal(16001,handler(self,self.onHandle16001))
end

function StoreController:onHandle16001(data)
	print("onHandle16001")
	if data.result ~= 0 then
		GlobalEventSystem:dispatchEvent(GlobalEvent.GET_ERROR_CODE,ErrorCodeInfoFormat(data.result))
	end
end

