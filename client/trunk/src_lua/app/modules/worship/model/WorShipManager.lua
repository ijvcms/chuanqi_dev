--
-- Author: Yi hanneng
-- Date: 2016-01-11 11:37:27
--

WorShipManager = WorShipManager or class("WorShipManager", BaseManager)

function WorShipManager:ctor()
	WorShipManager.instance = self
	self.ws_list = {}
end

function WorShipManager:getInstance()
	if WorShipManager.instance == nil then
		WorShipManager.new()
	end
	return WorShipManager.instance
end

function WorShipManager:setWSList(data)
	self.ws_list = {}
	for i=1,#data.worship_frist_career_list do
		local info = require("app.modules.worship.model.WorShipVo").new()
		info.sex = data.worship_frist_career_list[i].sex
		info.career = data.worship_frist_career_list[i].career
		info.name = data.worship_frist_career_list[i].name
		info.fight = data.worship_frist_career_list[i].fight
		info.player_id = data.worship_frist_career_list[i].player_id
		table.insert(self.ws_list,info)
	end
	
	if #self.ws_list > 1 then
		table.sort(self.ws_list,function(a,b) return a.career<b.career end)
	end
	
	GlobalEventSystem:dispatchEvent(WorShipEvent.WSE_UPDATE_INFO, self.ws_list)

end
