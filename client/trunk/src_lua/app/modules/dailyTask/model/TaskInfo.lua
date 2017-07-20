--
-- Author: Yi hanneng
-- Date: 2016-01-05 15:05:55
--
local TaskInfo = TaskInfo or class("TaskInfo")

function TaskInfo:ctor(data)

	self.id = 0
	self.accept_npc_id  = 0
	self.finish_npc_id = 0
	self.accept_des = ""
	self.accept_info = ""
	self.finish_des = ""
	self.finish_info = ""
	self.active_npc = 0
	self.needNum = 0
	self.currentNum = 0
	self.rewardList = {}
	self.exRewardList = {}
	self.state = 0  --0:任务进行中；1:任务完成；2:任务接取状态；3:删除
	self.des = ""
	self.showTip = ""
	self.name = ""
	self.type = 0 -- 1:主线任务；2:日常任务；3:功勋任务
	self.sort_id = 0 
	self.sendId = 0
	self.pos = {}
	self.openinstance = ""
	self.tool = 0
	self.effect = ""
	self.goods_extra_probability = 0
 
end

return TaskInfo