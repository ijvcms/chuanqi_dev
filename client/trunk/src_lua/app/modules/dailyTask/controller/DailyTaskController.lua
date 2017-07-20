--
-- Author: Your Name
-- Date: 2015-11-30 11:34:45
--

require("app.modules.dailyTask.model.DailyTaskManager")

DailyTaskController = DailyTaskController or class("DailyTaskController",BaseController)

function DailyTaskController:ctor()

	 DailyTaskController.Instance = self
	self:initProtocal()
end

function DailyTaskController:getInstance()
	if DailyTaskController.Instance==nil then
		DailyTaskController.new()
	end
	return DailyTaskController.Instance
end

function DailyTaskController:initProtocal()
	self:registerProtocal(19000,handler(self,self.onHandle19000))
	self:registerProtocal(19001,handler(self,self.onHandle19001))
end
 
function DailyTaskController:onHandle19000(data)
	print("DailyTaskController:onHandle19000")
	if nil ~= data then
		DailyTaskManager:getInstance():setDailyTaskInfo(data)
	end
	
end

function DailyTaskController:onHandle19001(data)
 	if data.result == 0 then
 		--GlobalEventSystem:dispatchEvent(DailyTaskEvent.UPDATE_TASK_INFO)
 	elseif data.result == 7 then
 		GlobalEventSystem:dispatchEvent(GlobalEvent.SHOW_SYSTIPS,"背包已满!")
 	else
 		GlobalEventSystem:dispatchEvent(GlobalEvent.SHOW_SYSTIPS,"领取失败!")
 	end
end

function DailyTaskController:jumpTask(taskId)
	
end
