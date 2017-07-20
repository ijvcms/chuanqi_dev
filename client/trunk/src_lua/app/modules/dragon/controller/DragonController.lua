--
-- Author: Yi hanneng
-- Date: 2016-03-10 11:01:36
--

DragonController = DragonController or class("DragonController", BaseController)

function DragonController:ctor()
	DragonController.instance = self
	self:initProtocal()
end

function DragonController:getInstance()
	if DragonController.instance == nil then
		DragonController.new()
	end
	return DragonController.instance
end

function DragonController:initProtocal()
	 
	self:registerProtocal(11028,handler(self,self.onHandle11028))
 
	 
end
 
function DragonController:onHandle11028(data)
	print("DragonController:onHandle11028")
 	if data.type == 1 then
 		GlobalEventSystem:dispatchEvent(GragonEvent.GRAGON_UPDATE_INFO,data)
 	elseif data.type == 2 then
 		--打开活动结束界面
 		local DTRewardView = require("app.modules.dragon.view.DragonReward").new()
 		DTRewardView:setViewInfo(data)
  		GlobalEventSystem:dispatchEvent(GlobalEvent.SHOW_BOX,DTRewardView)  
 		 
 	end
  	
end