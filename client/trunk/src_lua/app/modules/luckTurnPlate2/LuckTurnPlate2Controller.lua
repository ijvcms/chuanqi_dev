--
-- Author: zhangshunqiu    21102585@qq.com
-- Date: 2016-05-13 16:13:42
-- 幸运转盘控制器
LuckTurnPlate2Controller = LuckTurnPlate2Controller or class("LuckTurnPlate2Controller",BaseController)

function LuckTurnPlate2Controller:ctor()
	self.roleManager = RoleManager:getInstance()
	self:registerProto()

	self.autoGroupSkillSwitch = true
end


function LuckTurnPlate2Controller:registerProto()
	self:registerProtocal(35008,handler(self,self.onHandle35008))
	self:registerProtocal(35009,handler(self,self.onHandle35009))
end

--
function LuckTurnPlate2Controller:onHandle35008(data)
	print("onHandle35008")
	dump(data)
	if data then
		GlobalEventSystem:dispatchEvent(LuckTurnPlate2Event.TURNPLATE2_TIP_INIT, data)
	end
end

--
function LuckTurnPlate2Controller:onHandle35009(data)
	print("onHandle35009")
	dump(data)
	if data.result == 0  then 
		GlobalEventSystem:dispatchEvent(LuckTurnPlate2Event.TURNPLATE2_GET, data)
	end
end