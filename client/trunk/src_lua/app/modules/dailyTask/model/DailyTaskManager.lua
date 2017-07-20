--
-- Author: Your Name
-- Date: 2015-12-04 18:22:33
--
DailyTaskManager = DailyTaskManager or class("DailyTaskManager", BaseManager)

function DailyTaskManager:ctor()
	DailyTaskManager.Instance = self
	self.taskList = {}
	self.total = 0
	self.cur = 0
	self.getList = {}

end

function DailyTaskManager:getInstance()
	if DailyTaskManager.Instance==nil then
		DailyTaskManager.new()
	end
	return DailyTaskManager.Instance
end

function DailyTaskManager:setDailyTaskInfo(data)
	if nil ~= data then

		self.taskList = {}
		self.total = 0
		self.cur = 0

		--[[
		if data.player_reward_list and data.player_reward_list ~= "" then
			self.getList = StringUtil.split(data.player_reward_list, ",")
		end

		--]]
 
		self.getList = data.player_reward_list
 
		for i=1,#data.player_tasklist do
			local item = require("app.modules.dailyTask.model.DailyTaskVo").new()
			item.id = data.player_tasklist[i].task_id
			local config = configHelper:getTask(item.id)
			if config then
				--todo
			
			item.taskName = config.name
			item.taskDes = config.dec
			item.neednum = config.neednum
			item.active = config.active
			item.hadFinish = data.player_tasklist[i].nownum
			item.finish = data.player_tasklist[i].isfinish
			self.total = self.total + config.active
			item.interface = config.interface
			if item.finish == 1 then
				item.open = "已完成"
				self.cur = self.cur + config.active
			elseif item.finish == 0 then
				item.open = "去完成"
			end
			table.insert(self.taskList, item)

			end
		end


 
	GlobalEventSystem:dispatchEvent(DailyTaskEvent.GET_TASK_INFO, {list = self.taskList, cur = self.cur, total = self.total, getList = self.getList})

	end
end
