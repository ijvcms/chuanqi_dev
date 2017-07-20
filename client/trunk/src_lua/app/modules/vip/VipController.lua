--
-- Author: Yi hanneng
-- Date: 2016-01-22 14:47:47
--
VipController = VipController or class("VipController", BaseController)

function VipController:ctor()
	VipController.instance = self
	self:initProtocal()
end

function VipController:getInstance()
	if VipController.instance == nil then
		VipController.new()
	end
	return VipController.instance
end

function VipController:initProtocal()
	self:registerProtocal(29001,handler(self,self.onHandle29001))
	self:registerProtocal(29002,handler(self,self.onHandle29002))
end

function VipController:getVipInfo(lv)
	 self:sendMsgToSocket(29001, {vip_lv = lv})
end

--获取vip信息
function VipController:onHandle29001(data)
	print("VipController:onHandle29001")
	GlobalEventSystem:dispatchEvent(VipEvent.VIP_STATE, { flag = data.result, exp = data.vip_exp} )
end
--领取vip奖励
function VipController:onHandle29002(data)
	print("VipController:onHandle29002")
	if data.result == 0 then
		GlobalEventSystem:dispatchEvent(VipEvent.VIP_RECEIVE)
	end
end