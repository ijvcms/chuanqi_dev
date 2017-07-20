--
-- Author: zhangshunqiu    21102585@qq.com
-- Date: 2016-05-13 16:13:42
-- GVG
GvgController = GvgController or class("GvgController",BaseController)

function GvgController:ctor()
	self.roleManager = RoleManager:getInstance()
	self:registerProto()

	self.autoGroupSkillSwitch = true
end


function GvgController:registerProto()
	self:registerProtocal(11056,handler(self,self.onHandle11056))
	self:registerProtocal(11057,handler(self,self.onHandle11057))
	self:registerProtocal(11058,handler(self,self.onHandle11058))
	-- self:registerProtocal(35007,handler(self,self.onHandle35007))
end

--GVG排行榜数据
function GvgController:onHandle11056(data)
	if data.time_left then
		GlobalEventSystem:dispatchEvent(GvgEvent.GVG_CHANG_TIME, data.time_left)
	end
end

--GVG左侧列表排行榜数据
function GvgController:onHandle11057(data)
	if data then
		GlobalEventSystem:dispatchEvent(GvgEvent.GVG_LEFT_RANK, data)
	else
		GlobalEventSystem:dispatchEvent(GlobalEvent.GET_ERROR_CODE,ErrorCodeInfoFormat(data.result))
	end
end

--GVG通知结束
function GvgController:onHandle11058(data)
	if data then
		GlobalWinManger:openWin(WinName.GVGWIN,data)
	else
		GlobalEventSystem:dispatchEvent(GlobalEvent.GET_ERROR_CODE,ErrorCodeInfoFormat(data.result))
	end
end