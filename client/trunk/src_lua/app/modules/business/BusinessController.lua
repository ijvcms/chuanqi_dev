--
-- Author: Yi hanneng
-- Date: 2016-07-08 15:49:01
--

BusinessController = BusinessController or class("BusinessController", BaseController)

function BusinessController:ctor()
	BusinessController.instance = self
	self:initProtocal()
end

function BusinessController:getInstance()
	if BusinessController.instance == nil then
		BusinessController.new()
	end
	return BusinessController.instance
end

function BusinessController:initProtocal()
	self:registerProtocal(32020,handler(self,self.onHandle32020))
	self:registerProtocal(32021,handler(self,self.onHandle32021))
	self:registerProtocal(32045,handler(self,self.onHandle32045))
end

-- 
function BusinessController:requestBusinessInfo()
	GameNet:sendMsgToSocket(32020)
end

function BusinessController:requestBusinessById(id)
	GameNet:sendMsgToSocket(32021,{active_id = id})
end

function BusinessController:requestBusinessReceiveReward(id, subType)
	GameNet:sendMsgToSocket(32045,{active_id = id,sub_type = subType})
end

--获取任务导航
function BusinessController:onHandle32020(data)
	print("BusinessController:onHandle32020")

	if nil ~= data then
		GlobalEventSystem:dispatchEvent(BusinessEvent.BUSINESS_INFO_LIST,data)
		--GlobalEventSystem:dispatchEvent(BuffEvent.Buff_LIST)
	end
end

function BusinessController:onHandle32021(data)
	print("BusinessController:onHandle32021")
 
	if  data.result == 1 or data.result == 2  then
		GlobalEventSystem:dispatchEvent(BusinessEvent.RCV_BUSINESS_REWARD,{state = data.result})
	else
		GlobalEventSystem:dispatchEvent(GlobalEvent.SHOW_SYSTIPS,ErrorCodeNormalInfo[data.result])
	end
end

function BusinessController:onHandle32045(data)
	print("BusinessController:onHandle32045")
	dump(data)
	if  data.result == 0 then
		GlobalEventSystem:dispatchEvent(BusinessEvent.RCV_BUSINESS_REWARD,data)
	else
		GlobalEventSystem:dispatchEvent(GlobalEvent.SHOW_SYSTIPS,ErrorCodeNormalInfo[data.result])
	end
end
 