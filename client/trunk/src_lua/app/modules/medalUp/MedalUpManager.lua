--
-- Author: Yi hanneng
-- Date: 2016-01-18 18:05:36
--
MedalUpManager = MedalUpManager or class("MedalUpManager", BaseManager)

function MedalUpManager:ctor()
	MedalUpManager.Instance = self
	self.medalList = {}
	self:setMedalListInfo()
end

function MedalUpManager:getInstance()
	if nil == MedalUpManager.Instance then
		MedalUpManager.new()
	end
	return MedalUpManager.Instance
end

function MedalUpManager:setMedalListInfo()
	if #self.medalList > 1 then
		return 
	end
	self.medalList = configHelper:getMedal(RoleManager:getInstance().roleInfo.career)
 
end

function MedalUpManager:getMedalListInfo()
	return self.medalList
end

