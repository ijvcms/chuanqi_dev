--
-- Author: zhangshunqiu    21102585@qq.com
-- Date: 2016-05-13 16:13:42
-- 神皇密境
ShengHuangMJController = ShengHuangMJController or class("ShengHuangMJController",BaseController)

function ShengHuangMJController:ctor()
	self.roleManager = RoleManager:getInstance()
	self:registerProto()

	self.autoGroupSkillSwitch = true
end


function ShengHuangMJController:registerProto()
	self:registerProtocal(35004,handler(self,self.onHandle35004))
	self:registerProtocal(35005,handler(self,self.onHandle35005))
	self:registerProtocal(35006,handler(self,self.onHandle35006))
	self:registerProtocal(35007,handler(self,self.onHandle35007))
end

function ShengHuangMJController:onHandle35004(data)
	dump(data)
	if data then
		GlobalEventSystem:dispatchEvent(ShenghuangEvent.SHENGHUANG_INIT, data)
	end
end

function ShengHuangMJController:onHandle35005(data)
	if data.result == 0 then
		GlobalEventSystem:dispatchEvent(ShenghuangEvent.SHENGHUANG_GET_PRIZE, data)
	else
		GlobalEventSystem:dispatchEvent(GlobalEvent.GET_ERROR_CODE,ErrorCodeInfoFormat(data.result))
	end
end

function ShengHuangMJController:onHandle35006(data)
	if data.result == 0 then 
		GlobalEventSystem:dispatchEvent(ShenghuangEvent.SHENGHUANG_EXCHANG, data)
	else
		GlobalEventSystem:dispatchEvent(GlobalEvent.GET_ERROR_CODE,ErrorCodeInfoFormat(data.result))
	end
end

function ShengHuangMJController:onHandle35007(data)
	if data.log_lists then
		GlobalEventSystem:dispatchEvent(ShenghuangEvent.SHENGHUANG_UPDATE_LOG, data.log_lists)
	end
end