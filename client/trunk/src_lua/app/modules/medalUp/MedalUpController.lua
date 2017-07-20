--
-- Author: Yi hanneng
-- Date: 2016-01-18 18:05:05
--
MedalUpController = MedalUpController or class("MedalUpController", BaseController)

function MedalUpController:ctor()
	MedalUpController.instance = self
	self:initProtocal()
end

function MedalUpController:getInstance()
	if MedalUpController.instance == nil then
		MedalUpController.new()
	end
	return MedalUpController.instance
end

function MedalUpController:initProtocal()
	self:registerProtocal(14034,handler(self,self.onHandle14034))
end

function MedalUpController:onHandle14034(data)
	print("MedalUpController:onHandle14034")
	dump(data)
	if data.result == 0 then
		GlobalEventSystem:dispatchEvent(MedalUpEvent.MedalUp_UP)
		GlobalEventSystem:dispatchEvent(EquipEvent.EQUIP_TIP,Equip_tip.EQUI_TIP_MEDAL)
	else
		GlobalEventSystem:dispatchEvent(GlobalEvent.SHOW_SYSTIPS,ErrorCodeNormalInfo[data.result])
	end
end