--
-- Author: Your Name
-- Date: 2015-12-10 17:51:47
--
MayaManager = MayaManager or class("MayaManager", BaseManager)

function MayaManager:ctor()
	MayaManager.Instance = self
	self.des = ""
	self.bossList = {}
end

function MayaManager:getInstance()
	if MayaManager.Instance == nil then
		MayaManager.new()
	end

	return MayaManager.Instance
end

function MayaManager:setInfo(data)
 
	if data ~= nil and data.refresh_list and #data.refresh_list > 0 then

		self.bossList = {}
		local config = configHelper:getMayaItems()
		for i=1,#data.refresh_list do
			local itemVo = require("app.modules.maya.model.MayaVo").new()
			itemVo.id = data.refresh_list[i].id
			itemVo.time = data.refresh_list[i].refresh_time
			itemVo.bossId = config[itemVo.id].boss_id
			itemVo.name = getConfigObject(itemVo.bossId,MonsterConf).name
			itemVo.lv = config[itemVo.id].floor
			if self.bossList[itemVo.lv] == nil then
				table.insert(self.bossList,{})
			end
			table.insert(self.bossList[itemVo.lv],itemVo)
		end
		
	end
 
	GlobalEventSystem:dispatchEvent(MayaEvent.MAYA_GET_INFO, {list = self.bossList, des = "test"})
end

