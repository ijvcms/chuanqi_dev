--
-- Author: zhangshunqiu    21102585@qq.com
-- Date: 2015-12-15 17:14:07
-- 沙巴克

ShaBaKeModel = ShaBaKeModel or {}

function ShaBaKeModel:ctor()
	self.honorRoleList = {}
	self.occupyGuildName = "帮会名称"
	self.occupyDays = 5
	self.nextTimeNum = os.time()+10000
	self.nextDate = "12月13日"
	self.nextTime = "09:09"
	self.officer_id = 0
end

