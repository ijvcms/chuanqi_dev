--
-- Author: Yi hanneng
-- Date: 2016-01-26 10:10:00
--
DLRewardManager = DLRewardManager or class("DLRewardManager", BaseManager)

function DLRewardManager:ctor()
	DLRewardManager.instance = self
	self.downloadrewardList = {}
	self:setList()
end

function DLRewardManager:getInstance()
	if DLRewardManager.instance == nil then
		DLRewardManager.new()
	end
	return DLRewardManager.instance
end

function DLRewardManager:setList()
	local config = configHelper:getDownLoadConfig()
	for i=1,#config do
		for j=1,#config[i].reward do
			self.downloadrewardList[#self.downloadrewardList + 1] = config[i].reward[j]
		end
	end
	--GlobalEventSystem:dispatchEvent(DownLoadEvent.DOWENLOAD_LIST,{list = self.downloadrewardList})
end

function DLRewardManager:getList()
	return self.downloadrewardList
end

function DLRewardManager:handlerList(data)
	GlobalEventSystem:dispatchEvent(DownLoadEvent.DOWENLOAD_LIST,{list = data.lv_list})
end

