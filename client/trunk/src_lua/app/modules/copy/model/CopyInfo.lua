--
-- Author: Your Name
-- Date: 2015-12-09 17:41:53
--
local CopyInfo = CopyInfo or class("CopyInfo")
function CopyInfo:ctor()

	self.id = 0
	self.name = ""
	self.res = ""
	self.reward = ""
	self.rewardDes = ""
	self.lv = 0
end

function CopyInfo:setData(data)
	if data == nil then
		return
	end
	self.id = data.id
	self.name = data.name
	self.res = data.res
	self.reward = data.reward
	self.rewardDes = data.rewardDes
	self.lv  = data.lv
end
return CopyInfo
