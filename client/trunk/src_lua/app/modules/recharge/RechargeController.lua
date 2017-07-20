--
-- Author: Yi hanneng
-- Date: 2016-01-26 09:54:30
--
require("app.modules.recharge.RechargeManager")
RechargeController = RechargeController or class("RechargeController", BaseController)

function RechargeController:ctor()
	RechargeController.instance = self
	self:initProtocal()
end

function RechargeController:getInstance()
	if RechargeController.instance == nil then
		RechargeController.new()
	end
	return RechargeController.instance
end

function RechargeController:initProtocal()
	self:registerProtocal(30001,handler(self,self.onHandle30001))
	self:registerProtocal(30002,handler(self,self.onHandle30002))
end



function RechargeController:onHandle30001(data)
	print("RechargeController:onHandle30001")
	--dump(data)
	if data.result == 0 then
		local dec,rmb,index = RechargeManager:getInstance():getChargeItemData()
		
--		GlobalModel.isPaying = true
		ChannelAPI:pay(data.order_id, rmb, dec, 0, data.pay_type, index)
	else
		GlobalEventSystem:dispatchEvent(GlobalEvent.SHOW_SYSTIPS,ErrorCodeNormalInfo[data.result])
	end
	 
end

function RechargeController:onHandle30002(data)
	print("RechargeController:onHandle30002")
	RechargeManager:getInstance():handlerChargetList(data)
end