--
-- Author: Your Name
-- Date: 2015-12-04 17:25:12
--
local DailyTaskVo = DailyTaskVo or class("DailyTaskVo")

	function DailyTaskVo:ctor()
	
		self.id = 0
		self.taskName = ""
		self.taskDes = ""
		self.neednum = 0
		self.active = 0
		self.hadFinish = 0
		self.finish = 0
		self.open = ""
		self.interface = ""

	end

return DailyTaskVo