--
-- Author: Yi hanneng
-- Date: 2016-01-26 10:10:14
--
require("app.modules.downloadReward.DLRewardManager")
DLRewardController = DLRewardController or class("DLRewardController", BaseController)

function DLRewardController:ctor()
	DLRewardController.instance = self
	self:initProtocal()
end

function DLRewardController:getInstance()
	if DLRewardController.instance == nil then
		DLRewardController.new()
	end
	return DLRewardController.instance
end

function DLRewardController:initProtocal()
	self:registerProtocal(31001,handler(self,self.onHandle31001))
	self:registerProtocal(31002,handler(self,self.onHandle31002))
end

function DLRewardController:onHandle31001(data)
	print("DLRewardController:onHandle31001")
	dump(data)
	DLRewardManager:getInstance():handlerList(data)
end

function DLRewardController:onHandle31002(data)
	print("DLRewardController:onHandle31002")
	dump(data)
	if data.result == 0 then
		GlobalEventSystem:dispatchEvent(DownLoadEvent.DOWENLOAD_REWARD_SUCCESS)
	else
		GlobalEventSystem:dispatchEvent(GlobalEvent.SHOW_SYSTIPS,ErrorCodeNormalInfo[data.result])
	end
end