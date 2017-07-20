--
-- Author: Your Name
-- Date: 2015-12-08 20:10:11
--

require("app.modules.copy.model.CopyManager")

CopyController = CopyController or class("CopyController", BaseController)

function CopyController:ctor()
	CopyController.Instance  = self
	self:initProtocal()
end

function CopyController:getInstance()
	if nil == CopyController.Instance then
		CopyController.new()
	end
	return CopyController.Instance 
end

function CopyController:initProtocal()
	self:registerProtocal(11013,handler(self,self.onHandle11013))
	self:registerProtocal(11015,handler(self,self.onHandle11015))
	self:registerProtocal(11017,handler(self,self.onHandle11017))
	self:registerProtocal(11034,handler(self,self.onHandle11034))
	self:registerProtocal(11035,handler(self,self.onHandle11035))
	self:registerProtocal(11036,handler(self,self.onHandle11036))
	--个人boss副本
	self:registerProtocal(11045,handler(self,self.onHandle11045))
	self:registerProtocal(10016,handler(self,self.onHandle10016))
end

function CopyController:onHandle11013(data)

	if nil ~= data then
		GlobalEventSystem:dispatchEvent(CopyEvent.COPY_UPDATECOPYTIME, data)
	end

end
--副本场景信息更新
function CopyController:onHandle11015(data)

	if nil ~= data then
		GlobalEventSystem:dispatchEvent(CopyEvent.COPY_TIPINFO, {time = data.end_time, kill_boss = data.kill_boss,boss_count = data.boss_count, kill_monster = data.kill_monster, monster_count = data.monster_count, scene_id = data.scene_id, reward = CopyManager:getInstance():getRewardDes(data.scene_id),round = data.round})
	end

end
--副本结算结果
function CopyController:onHandle11017(data)
	print("CopyController:onHandle11017")
	local instance_type =  configHelper:getCopyInfo(data.scene_id).instanceType
	--GlobalWinManger:openWin(WinName.COPYCOUNTDOWNVIEW,{time = 10})
	if instance_type == 1 then --个人副本
		if nil ~= data and data.instance_result == 1 then
		    --GlobalEventSystem:dispatchEvent(CopyEvent.COPY_REWARD, {scene_id = data.scene_id, goodsList = CopyManager:getInstance():getReward(data.scene_id)})
	    	 local copyReward = require("app.modules.copy.view.CopyRewardView").new()
			    copyReward:setViewInfo({scene_id = data.scene_id, goodsList = CopyManager:getInstance():getReward(data.scene_id)})

			    GlobalEventSystem:dispatchEvent(GlobalEvent.SHOW_BOX,copyReward)

	    end
		--统计挑战个人副本情况
        GlobalAnalytics:setActiveEvent("个人副本", data.scene_id, data.instance_result)
    else-- 剧情副本
    	-- Guild
    	GlobalController.guide:getTriggerManager():tryTrigger(TriggerType.INSTANCE_FINISH, {
            scene_id = data.scene_id
        })
	end
    
end


function CopyController:onHandle11034(data)
	print("CopyController:onHandle11034")
	dump(data)
	if nil ~= data then
		CopyManager:getInstance():setCopyListInfo(data.fb_list)
		--  GlobalEventSystem:dispatchEvent(CopyEvent.COPY_UPDATECOPYTIME, data)
	end

end

function CopyController:onHandle11035(data)
	print("CopyController:onHandle11035")
	dump(data)
	if data.result == 0 then
		 
	else
		GlobalEventSystem:dispatchEvent(GlobalEvent.SHOW_SYSTIPS,ErrorCodeNormalInfo[data.result])
	end

end

function CopyController:onHandle11036(data)
	print("CopyController:onHandle11036")
	dump(data)
	if nil ~= data then
		GlobalEventSystem:dispatchEvent(CopyEvent.COPY_UPDATECOPYTIME, data.fb_info)
	end

end

--boss副本入口界面信息
function CopyController:onHandle10016(data)
	print("CopyController:onHandle10016")
	dump(data)
	if nil ~= data and data.result then
		GlobalEventSystem:dispatchEvent(CopyEvent.COPY_BOSS_INFO, data)
	end

end

--boss副本场景信息更新
function CopyController:onHandle11045(data)
	dump(data)
	if nil ~= data then
		GlobalEventSystem:dispatchEvent(CopyEvent.COPY_BOSS_UPDATE, data)
	end

end
