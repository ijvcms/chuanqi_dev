--
-- Author: Yi hanneng
-- Date: 2016-04-20 17:39:23
--
BuffController = BuffController or class("BuffController", BaseController)

function BuffController:ctor()
	BuffController.instance = self
	self:initProtocal()
end

function BuffController:getInstance()
	if BuffController.instance == nil then
		BuffController.new()
	end
	return BuffController.instance
end

function BuffController:initProtocal()
	self:registerProtocal(10012,handler(self,self.onHandle10012))
end

-- 
function BuffController:requestBuffInfo()
	GameNet:sendMsgToSocket(10012)
end


--获取任务导航
function BuffController:onHandle10012(data)
	--print("BuffController:onHandle10012")
	RoleManager:getInstance().buffData = data
	if nil ~= data then
		GlobalEventSystem:dispatchEvent(BuffEvent.Buff_INFO,data)
		GlobalEventSystem:dispatchEvent(BuffEvent.Buff_LIST)
	end
end
 