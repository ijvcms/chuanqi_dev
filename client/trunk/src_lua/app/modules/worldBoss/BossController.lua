--
-- Author: Yi hanneng
-- Date: 2016-08-05 12:00:44
--
BossController = BossController or class("BossController", BaseController)

function BossController:ctor()
	BossController.instance = self
	self:initProtocal()
end

function BossController:getInstance()
	if BossController.instance == nil then
		BossController.new()
	end
	return BossController.instance
end

function BossController:initProtocal()
	 
	self:registerProtocal(11032,handler(self,self.onHandle11032))
	self:registerProtocal(11033,handler(self,self.onHandle11033))

	self:registerProtocal(11046,handler(self,self.onHandle11046))
	self:registerProtocal(11048,handler(self,self.onHandle11048))
	self:registerProtocal(11049,handler(self,self.onHandle11049))
 	self:registerProtocal(22005,handler(self,self.onHandle22005))
	 
end
--[[
<Param name="scene_id" type="int32" describe="场景id" /> 
  <Param name="monster_id" type="int32" describe="怪物id" /> 
  <Param name="action" type="int8" describe="动作，0取消关注1关注" /> 

--]]
--设置boss关注
function BossController:requestGZBoss(scene_id,monster_id,action)
	GameNet:sendMsgToSocket(22005, {scene_id = scene_id,monster_id = monster_id,action = action})
end
--请求boss关注列表
function BossController:requestGZBossList(type)
	GameNet:sendMsgToSocket(11048,{type = type})
end
--请求物品掉落
function BossController:requestGZBossDL()
	GameNet:sendMsgToSocket(11046)
end


function BossController:onHandle11032(data)
	print("BossController:onHandle11032")
 	dump(data)
 	if data.result == 0 then
		--GlobalEventSystem:dispatchEvent(GlobalEvent.SHOW_SYSTIPS,"传送失败，小飞鞋不足，已开启自动寻路!")
	else
		GlobalEventSystem:dispatchEvent(GlobalEvent.SHOW_SYSTIPS,ErrorCodeNormalInfo[data.result])
	end
 	
end

function BossController:onHandle11033(data)
	print("BossController:onHandle11033")
 	dump(data)
 	if data.result == 0 then
		GlobalEventSystem:dispatchEvent(GlobalEvent.SHOW_SYSTIPS,"传送成功，消耗小飞鞋X1")
	else
		GlobalEventSystem:dispatchEvent(GlobalEvent.SHOW_SYSTIPS,ErrorCodeNormalInfo[data.result])
	end
 	
end

function BossController:onHandle11046(data)
	print("BossController:onHandle11046")
 	 
	GlobalEventSystem:dispatchEvent(BossEvent.BOSS_DL, data) 
 
end

function BossController:onHandle11048(data)
	print("BossController:onHandle11048")
 
	GlobalEventSystem:dispatchEvent(BossEvent.BOSS_GZLIST, data)
	 
end

function BossController:onHandle11049(data)
	print("BossController:onHandle11049")
 	local BossTips = import("app.modules.worldBoss.view.BossTips").new()
	BossTips:setData(data)
	GlobalEventSystem:dispatchEvent(GlobalEvent.SHOW_BOX,BossTips)
	--GlobalEventSystem:dispatchEvent(BossEvent.BOSS_TIP, data)
	 
end

function BossController:onHandle22005(data)
	print("BossController:onHandle22005")
 	dump(data)
 	if data.result == 0 then
		GlobalEventSystem:dispatchEvent(BossEvent.BOSS_GZSUCCESS, data)
	else
		GlobalEventSystem:dispatchEvent(GlobalEvent.SHOW_SYSTIPS,ErrorCodeNormalInfo[data.result])
	end
 	
end