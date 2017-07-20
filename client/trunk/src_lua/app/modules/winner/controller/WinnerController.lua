--
-- Author: Yi hanneng
-- Date: 2016-03-10 11:01:36
--

WinnerController = WinnerController or class("WinnerController", BaseController)

function WinnerController:ctor()
	WinnerController.instance = self
	self:initProtocal()
end

function WinnerController:getInstance()
	if WinnerController.instance == nil then
		WinnerController.new()
	end
	return WinnerController.instance
end

function WinnerController:initProtocal()
	 
	self:registerProtocal(11029,handler(self,self.onHandle11029))
 	self:registerProtocal(11030,handler(self,self.onHandle11030))
	 
end
 
function WinnerController:onHandle11029(data)
	print("WinnerController:onHandle11029")
 	dump(data)
 	GlobalEventSystem:dispatchEvent(WinnerEvent.WINNER_UPDATE_INFO,data)
end

function WinnerController:onHandle11030(data)
	print("WinnerController:onHandle11030")
 	dump(data)
	local WinnerReward = require("app.modules.winner.view.WinnerReward").new()
	WinnerReward:setViewInfo(data)
	GlobalEventSystem:dispatchEvent(GlobalEvent.SHOW_BOX,WinnerReward)  
end