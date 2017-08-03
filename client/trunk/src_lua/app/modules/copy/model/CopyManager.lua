--
-- Author: Your Name
-- Date: 2015-12-08 20:23:09
--
CopyManager = CopyManager or class("CopyManager", BaseManager)

function CopyManager:ctor()
	CopyManager.Instance = self
	self.copyList = {}
end
 
function CopyManager:getInstance()
	if nil == CopyManager.Instance then
		CopyManager.new()
	end
	return CopyManager.Instance
end

--[[
  <Param name="scene_id" type="int16" describe="场景id" /> 
  <Param name="now_times" type="int16" describe="进入次数" /> 
  <Param name="buy_times" type="int16" describe="已购买次数" /> 
  <Param name="is_pass" type="int8" describe="1,已经通关，0，没有通关" /> 
  <Param name="limit_buy_times" type="int16" describe="下一级场景id" /> 
--]]

function CopyManager:setCopyListInfo(list)

	if list == nil then
		return
	end

	self.copyList = {}
	local config = configHelper:getCopyList()
	for i=1,#list do
		local itemInfo =config[list[i].scene_id]
		local copyVo = require("app.modules.copy.model.CopyVo").new()
		copyVo:setData(itemInfo)
		copyVo.now_times = list[i].now_times
		copyVo.buy_times = list[i].buy_times
		copyVo.limit_buy_times = list[i].limit_buy_times
		copyVo.next_scene_id = list[i].next_scene_id
		copyVo.need_jade = list[i].need_jade
		
		--self.copyList[config[i].scene_id] = copyVo
		table.insert(self.copyList, copyVo)
	end
	GlobalEventSystem:dispatchEvent(CopyEvent.COPY_ALLINFO, {list = self.copyList})

end

function CopyManager:getRewardDes(copyId)
	if self.copyList and #self.copyList > 0 and copyId > 0 then
		for i=1,#self.copyList do
			if copyId == self.copyList[i].copyId then
				return self.copyList[i].copyInfo.rewardDes
			end
		end
	end
end

function CopyManager:getReward(copyId)
	if self.copyList and #self.copyList > 0 and copyId > 0 then
		for i=1,#self.copyList do
			if copyId == self.copyList[i].copyId then
				return self.copyList[i].copyRewardInfo.goodsList
			end
		end
	end
end