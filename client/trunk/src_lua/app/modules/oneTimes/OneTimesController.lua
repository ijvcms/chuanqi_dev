--
-- Author: Yi hanneng
-- Date: 2016-09-23 14:38:17
--
OneTimesController = OneTimesController or class("OneTimesController", BaseController)

function OneTimesController:ctor()
	OneTimesController.instance = self
	self:initProtocal()
end

function OneTimesController:getInstance()
	if OneTimesController.instance == nil then
		OneTimesController.new()
	end
	return OneTimesController.instance
end

function OneTimesController:initProtocal()
	self:registerProtocal(16004,handler(self,self.onHandle16004))
	self:registerProtocal(16005,handler(self,self.onHandle16005))
end

-- 
 
function OneTimesController:requestOnetimesInfo(lv)
	
	GameNet:sendMsgToSocket(16004,{lv = lv})
end

function OneTimesController:requestBuyOnetimes(lv,pos)
	GameNet:sendMsgToSocket(16005,{lv = lv,pos = pos})
end


--
function OneTimesController:onHandle16004(data)
	print("OneTimesController:onHandle16004")
 
	if nil ~= data then
		GlobalEventSystem:dispatchEvent(OneTimesEvent.ONETIMES_INFO_LIST,data)
		--GlobalEventSystem:dispatchEvent(BuffEvent.Buff_LIST)
	end
end

function OneTimesController:onHandle16005(data)
	print("OneTimesController:onHandle16005")
 
	if  data ~= nil and data.result == 0 then
		GlobalEventSystem:dispatchEvent(OneTimesEvent.GET_ONETIMES_REWARDS,data)
	else
		GlobalEventSystem:dispatchEvent(GlobalEvent.GET_ERROR_CODE,ErrorCodeInfoFormat(data.result))
	end
end
 