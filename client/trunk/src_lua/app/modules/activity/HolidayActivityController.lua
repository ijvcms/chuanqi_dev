--
-- Author: Yi hanneng
-- Date: 2016-08-18 17:21:14
--
HolidayActivityController = HolidayActivityController or class("HolidayActivityController", BaseController)

function HolidayActivityController:ctor()
	HolidayActivityController.instance = self
	self:initProtocal()
end

function HolidayActivityController:getInstance()
	if HolidayActivityController.instance == nil then
		HolidayActivityController.new()
	end
	return HolidayActivityController.instance
end

function HolidayActivityController:initProtocal()
	self:registerProtocal(32036,handler(self,self.onHandle32036))
	self:registerProtocal(32035,handler(self,self.onHandle32035))
	self:registerProtocal(32044,handler(self,self.onHandle32044))
end

-- 
function HolidayActivityController:requestActivityInfo()
	GameNet:sendMsgToSocket(32036)
end

function HolidayActivityController:requestRankById(id)
	GameNet:sendMsgToSocket(32035,{active_id = id})
end

function HolidayActivityController:requestExchangeById(id)
	GameNet:sendMsgToSocket(32044,{active_id = id})
end


--
function HolidayActivityController:onHandle32036(data)
	print("HolidayActivityController:onHandle32036")
	 
	if nil ~= data then
		GlobalEventSystem:dispatchEvent(HolidayEvent.HOLIDAY_INFO_LIST,data)
		--GlobalEventSystem:dispatchEvent(BuffEvent.Buff_LIST)
	end
end

function HolidayActivityController:onHandle32035(data)
	print("HolidayActivityController:onHandle32035")
 
	if  data ~= nil then
		GlobalEventSystem:dispatchEvent(HolidayEvent.RCV_HOLIDAY_RANK,data)
	end
end

function HolidayActivityController:onHandle32044(data)
	print("HolidayActivityController:onHandle32044")
 
	if  data ~= nil then
		GlobalEventSystem:dispatchEvent(HolidayEvent.RCV_HOLIDAY_COMPOSE,data)
	end
end