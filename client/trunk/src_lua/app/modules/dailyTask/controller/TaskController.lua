--
-- Author: Yi hanneng
-- Date: 2016-01-05 14:21:22
--

require("app.modules.dailyTask.model.TaskManager")
TaskController = TaskController or class("TaskController", BaseController)

function TaskController:ctor()
	TaskController.instance = self
	self:initProtocal()
end

function TaskController:getInstance()
	if TaskController.instance == nil then
		TaskController.new()
	end
	return TaskController.instance
end

function TaskController:initProtocal()
	self:registerProtocal(26000,handler(self,self.onHandle26000))
	self:registerProtocal(26001,handler(self,self.onHandle26001))
	self:registerProtocal(26002,handler(self,self.onHandle26002))
	self:registerProtocal(26003,handler(self,self.onHandle26003))
	self:registerProtocal(26007,handler(self,self.onHandle26007))
	self:registerProtocal(26009,handler(self,self.onHandle26009))
end

-- 查询这个任务类型一件完成需要多少钱。
function TaskController:queryQuickFinishPrice(taskType)
	GameNet:sendMsgToSocket(26009, {task_type = taskType})
end

--获取任务导航
function TaskController:onHandle26000(data)
	--print("TaskController:onHandle26000")
	if nil ~= data then
		TaskManager:getInstance():handlerTaskList(data)
	end
end
--accept task
function TaskController:onHandle26001(data)
	print("TaskController:onHandle26001")
	if data.result == 0 then
		GlobalAnalytics:MissionBegin(data.task_id)
		if  GlobalController.guide:getTriggerType() ~= TriggerType.TASK_ACCEPT then --如果有开始任务引导，停止自动任务
			GlobalEventSystem:dispatchEvent(SceneEvent.NPC_ACCEPT_FIGHT)
		end
		TaskManager:getInstance():playEffect("accepttask")
	else
		GlobalEventSystem:dispatchEvent(GlobalEvent.SHOW_SYSTIPS,ErrorCodeNormalInfo[data.result])
	end
end
--finish task
function TaskController:onHandle26002(data)
	print("TaskController:onHandle26002")
	if data.result == 0 then
		--GlobalEventSystem:dispatchEvent(FriendEvent.FRIEND_APPLYFRIEND,data)
		GlobalAnalytics:MissionCompleted(data.task_id)
		TaskManager:getInstance():playEffect("completetask")
		self:analyticsTask(data.task_id)
	else
		GlobalEventSystem:dispatchEvent(GlobalEvent.SHOW_SYSTIPS,ErrorCodeNormalInfo[data.result])
	end
end

function TaskController:onHandle26007(data)
	print("TaskController:onHandle26007")
	if data.result == 0 then
		GlobalAnalytics:MissionBegin(data.task_id)
		GlobalAnalytics:MissionCompleted(data.task_id)
		self:analyticsTask(data.task_id)
	else
		GlobalEventSystem:dispatchEvent(GlobalEvent.SHOW_SYSTIPS,ErrorCodeNormalInfo[data.result])
	end
end

--统计功勋、日常任务完成任务数量
function TaskController:analyticsTask(task_id)
	local task = configHelper:getTask(task_id)
	if 9 == task.type_id then--功勋任务
        GlobalAnalytics:setActiveEvent("功勋任务", 0, 1)
    elseif 30011 == task.type_id then--日常任务
    	GlobalAnalytics:setActiveEvent("日常任务", 0, 1)
	end
end

--更新任务导航,服务器自动推
function TaskController:onHandle26003(data)
	print("TaskController:onHandle26003")
	dump(data)
	if nil ~= data then
		TaskManager:getInstance():udpateTaskList(data)
	end
end

-- 快速完成价格
function TaskController:onHandle26009(data)
	GlobalEventSystem:dispatchEvent(TaskEvent.ON_RCV_QUICK_FINISH_PRICE, data.result)
end


