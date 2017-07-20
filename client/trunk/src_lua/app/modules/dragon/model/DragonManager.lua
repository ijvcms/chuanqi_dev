--
-- Author: Yi hanneng
-- Date: 2016-03-10 11:07:21
--
DragonManager = DragonManager or class("DragonManager", BaseManager)

function DragonManager:ctor()
	DragonManager.Instance = self
	 
end

function DragonManager:getInstance()
	if nil == DragonManager.Instance then
		DragonManager.new()
	end
	return DragonManager.Instance
end