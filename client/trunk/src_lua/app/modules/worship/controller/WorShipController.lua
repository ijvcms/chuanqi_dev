--
-- Author: Yi hanneng
-- Date: 2016-01-11 11:33:21
--
require("app.modules.worship.model.WorShipManager")

WorShipController = WorShipController or class("WorShipController",BaseController)

function WorShipController:ctor()
	WorShipController.instance = self
	self:initProtocal()
end

function WorShipController:getInstance()
	if WorShipController.instance == nil then
		WorShipController.new()
	end
	return WorShipController.instance
end

function WorShipController:initProtocal()
	self:registerProtocal(27000,handler(self,self.onHandle27000))
	self:registerProtocal(27001,handler(self,self.onHandle27001))
	self:registerProtocal(27002,handler(self,self.onHandle27002))
end

function WorShipController:onHandle27000(data)
	print("WorShipController:onHandle27000")
	if nil ~= data then
		WorShipManager:getInstance():setWSList(data)
	end
end

function WorShipController:onHandle27001(data)
	print("WorShipController:onHandle27001")
	if nil ~= data then
		GlobalEventSystem:dispatchEvent(WorShipEvent.WSE_INFO, data)
	end
end

function WorShipController:onHandle27002(data)
	print("WorShipController:onHandle27002")
	 
	if data.result ~= 0 then
		GlobalEventSystem:dispatchEvent(GlobalEvent.SHOW_SYSTIPS,ErrorCodeNormalInfo[data.result])
	else
		GameNet:sendMsgToSocket(27001)
		--统计膜拜情况
        GlobalAnalytics:setActiveEvent("膜拜英雄", 0, 1)
	end
end

