--
-- Author: Yi hanneng
-- Date: 2016-03-02 09:26:39
--
DarkHouseManager = DarkHouseManager or class("DarkHouseManager", BaseManager)

function DarkHouseManager:ctor()
	DarkHouseManager.Instance = self
	 
end

function DarkHouseManager:getInstance()
	if nil == DarkHouseManager.Instance then
		DarkHouseManager.new()
	end
	return DarkHouseManager.Instance
end