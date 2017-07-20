--
-- Author: Yi hanneng
-- Date: 2016-01-22 14:47:57
--
VipManager = VipManager or class("VipManager", BaseController)

function VipManager:ctor()
	VipManager.instance = self
 	self.vipList = {}

 	self:setVipInfoList()
end

function VipManager:getInstance()
	if VipManager.instance == nil then
		VipManager.new()
	end
	return VipManager.instance
end
--获取玩家职业vip信息
function VipManager:setVipInfoList()
	self.vipList = configHelper:getVipInfo(RoleManager:getInstance().roleInfo.career)
end

function VipManager:getVipInfoList()
	return self.vipList
end

function VipManager:destory()
	self.vipList = nil
	VipManager.instance = nil
end