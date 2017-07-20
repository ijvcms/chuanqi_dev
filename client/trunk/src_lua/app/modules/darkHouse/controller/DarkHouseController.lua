--
-- Author: Yi hanneng
-- Date: 2016-03-02 09:25:14
--

require("app.modules.darkHouse.model.DarkHouseManager")
DarkHouseController = DarkHouseController or class("DarkHouseController", BaseController)

function DarkHouseController:ctor()
	DarkHouseController.instance = self
	self:initProtocal()
end

function DarkHouseController:getInstance()
	if DarkHouseController.instance == nil then
		DarkHouseController.new()
	end
	return DarkHouseController.instance
end

function DarkHouseController:initProtocal()
	 
	self:registerProtocal(32008,handler(self,self.onHandle32008))
 
	 
end
 
function DarkHouseController:onHandle32008(data)
	print("DarkHouseController:onHandle32008")
 	dump(data)
 	if data.result == 0 then
		 
	else
		GlobalEventSystem:dispatchEvent(GlobalEvent.SHOW_SYSTIPS,ErrorCodeNormalInfo[data.result])
	end
end