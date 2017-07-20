--
-- Author: Yi hanneng
-- Date: 2016-06-28 10:16:53
--
MonsterAttackController = MonsterAttackController or class("MonsterAttackController", BaseController)

function MonsterAttackController:ctor()
	MonsterAttackController.instance = self
	self:initProtocal()
end

function MonsterAttackController:getInstance()
	if MonsterAttackController.instance == nil then
		MonsterAttackController.new()
	end
	return MonsterAttackController.instance
end

function MonsterAttackController:initProtocal()
	 
	self:registerProtocal(11042,handler(self,self.onHandle11042))
 	--self:registerProtocal(11030,handler(self,self.onHandle11030))
	 
end
 
function MonsterAttackController:onHandle11042(data)
	print("MonsterAttackController:onHandle11042")
 	--dump(data)
 	if data.type == 1 then
 		GlobalEventSystem:dispatchEvent(MonsterAttackEvent.MONSTER_UPDATE_INFO,data)
 	else
 		self:onHandle11030(data)
 	end
 	
end

function MonsterAttackController:onHandle11030(data)
	print("MonsterAttackController:onHandle11030")
 	dump(data)
	local WinnerReward = require("app.modules.monsterAttack.view.MonsterAttackResultView").new()
	WinnerReward:setViewInfo(data)
	GlobalEventSystem:dispatchEvent(GlobalEvent.SHOW_BOX,WinnerReward)  
end