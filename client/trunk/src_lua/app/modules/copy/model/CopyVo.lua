--
-- Author: Your Name
-- Date: 2015-12-08 20:29:45
--
local CopyVo = CopyVo or class("CopyVo")

function CopyVo:ctor(data)

	self.copyId = 0
	self.bossId = 0
	self.now_times = 0
	self.buy_times = 0
	self.limit_buy_times = 0
	self.lv = 0
	self.next_scene_id = 0
end
--[[
{"id", "sTime", "eTime", "cTime", "tLimit", "cost", "prize", "name", "boss", "head", "type", "reward"}
{20010, 0, 60, 1800, 2, {{110057,1}}, {{110057,1,50000}}, "沃玛寺庙", 7002, 1, "【经验】", "经验：50000"}

--]]
function CopyVo:setData(data)

	if data ~= nil then
		self.copyId = data.id
		self.lv = data.lv

		self.copyInfo = require("app.modules.copy.model.CopyInfo").new()
		self.copyInfo:setData({id = data.id,name = data.name,res = data.head, reward = data.type, rewardDes = data.reward, lv = data.lv})

		self.copyRewardInfo = require("app.modules.copy.model.CopyRewardInfo").new()
		self.copyRewardInfo:setData(data.prize)

		self.bossId = data.boss
	
	end

end



return CopyVo