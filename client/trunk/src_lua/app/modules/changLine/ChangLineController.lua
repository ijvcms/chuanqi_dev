--
-- Author: zhangshunqiu    21102585@qq.com
-- Date: 2016-05-13 16:13:42
-- 幸运转盘控制器
ChangLineController = ChangLineController or class("ChangLineController",BaseController)

function ChangLineController:ctor()
	self.roleManager = RoleManager:getInstance()
	self:registerProto()

	self.autoGroupSkillSwitch = true
end


function ChangLineController:registerProto()
	self:registerProtocal(11038,handler(self,self.onHandle11038))
	--self:registerProtocal(11039,handler(self,self.onHandle11039))
end
--获取当前场景的线路信息
function ChangLineController:onHandle11038(data)
	
	if data.line_info_list then
		GlobalModel.curLine = data.now_line
		GlobalModel.lineList =  data.line_info_list
		GlobalEventSystem:dispatchEvent(ChangLineEvent.LINE_UPDATE,  {list = data.line_list,nowline = data.now_line})
		-- <Type name="proto_line_info" describe="线路信息">
		-- 	<Param name="line_num" type="int16" describe="线路"/>
		-- 	<Param name="state" type="int8" describe="线路状态 0，绿色，1，红色"/>
		-- 	<Param name="player_num" type="int16" describe="当前线路的人数"/>
		-- </Type>
	end
end

