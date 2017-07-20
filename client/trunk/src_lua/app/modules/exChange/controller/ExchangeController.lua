--
-- Author: Yi hanneng
-- Date: 2016-02-25 11:41:20
--

require("app.modules.exChange.model.ExChangeManager")
ExchangeController = ExchangeController or class("ExchangeController", BaseController)

function ExchangeController:ctor()
	ExchangeController.instance = self
	self:initProtocal()
end

function ExchangeController:getInstance()
	if ExchangeController.instance == nil then
		ExchangeController.new()
	end
	return ExchangeController.instance
end

function ExchangeController:initProtocal()
	 
	self:registerProtocal(33000,handler(self,self.onHandle33000))
	self:registerProtocal(33001,handler(self,self.onHandle33001))
	self:registerProtocal(33002,handler(self,self.onHandle33002))
	self:registerProtocal(33003,handler(self,self.onHandle33003))
	self:registerProtocal(33004,handler(self,self.onHandle33004))
	self:registerProtocal(33005,handler(self,self.onHandle33005))
	self:registerProtocal(33006,handler(self,self.onHandle33006))
	self:registerProtocal(33007,handler(self,self.onHandle33007))
	self:registerProtocal(33008,handler(self,self.onHandle33008))
	self:registerProtocal(33009,handler(self,self.onHandle33009))
	self:registerProtocal(33010,handler(self,self.onHandle33010))
	 
end
 
function ExchangeController:onHandle33000(data)
	print("ExchangeController:onHandle33000")
 	dump(data)
	ExChangeManager:getInstance():handler33000(data)
end

function ExchangeController:onHandle33001(data)
	print("ExchangeController:onHandle33001")
 
	ExChangeManager:getInstance():handler33000(data)
end

function ExchangeController:onHandle33002(data)
	print("ExchangeController:onHandle33002")
 
	ExChangeManager:getInstance():handler33002(data)
end

function ExchangeController:onHandle33003(data)
	print("ExchangeController:onHandle33003")
 
	ExChangeManager:getInstance():handler33003(data)
end


function ExchangeController:onHandle33004(data)
	print("ExchangeController:onHandle33004")
 
	if data.result == 0 then
		GlobalEventSystem:dispatchEvent(ExChangeEvent.SALE_UP_SUCCESS)
	else
		GlobalEventSystem:dispatchEvent(GlobalEvent.SHOW_SYSTIPS,ErrorCodeNormalInfo[data.result])
	end
end

function ExchangeController:onHandle33005(data)
	print("ExchangeController:onHandle33005")
 
	if data.result == 0 then
		GlobalEventSystem:dispatchEvent(ExChangeEvent.BUY_SUCCESS)
	else
		GlobalEventSystem:dispatchEvent(GlobalEvent.SHOW_SYSTIPS,ErrorCodeNormalInfo[data.result])
	end
end

function ExchangeController:onHandle33006(data)
	print("ExchangeController:onHandle33006")
 
	if data.result == 0 then
		GlobalEventSystem:dispatchEvent(ExChangeEvent.STORAGEVIEW_DOWN_SUCCESS)
	else
		GlobalEventSystem:dispatchEvent(GlobalEvent.SHOW_SYSTIPS,ErrorCodeNormalInfo[data.result])
	end
end

function ExchangeController:onHandle33007(data)
	print("ExchangeController:onHandle33007")
 
	if data.result == 0 then
		GlobalEventSystem:dispatchEvent(ExChangeEvent.RECEIVEVIEW_RECEIVE_SUCCESS)
	else
		GlobalEventSystem:dispatchEvent(GlobalEvent.SHOW_SYSTIPS,ErrorCodeNormalInfo[data.result])
	end
end
--获取购买交易税
function ExchangeController:onHandle33008(data)
	print("ExchangeController:onHandle33008")
 	if data.result == 0 then
 		GlobalEventSystem:dispatchEvent(GlobalEvent.SHOW_SYSTIPS,"该物品已不存在！")
 		GlobalEventSystem:removeEventListener(ExChangeEvent.BUYVIEW_FEE)
 	else
 		GlobalEventSystem:dispatchEvent(ExChangeEvent.BUYVIEW_FEE,data)
 	end
	
end
--获取出售需要的金币
function ExchangeController:onHandle33009(data)
	print("ExchangeController:onHandle33009")
 
	GlobalEventSystem:dispatchEvent(ExChangeEvent.SALE_FEE,data)
end

function ExchangeController:onHandle33010(data)
	print("ExchangeController:onHandle33010")
 
	GlobalEventSystem:dispatchEvent(ExChangeEvent.RECEIVE_FEE,data)
end